(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*PlotContainerCoverNotebookMismatches*)

DefineOptions[PlotContainerCoverNotebookMismatches,
	Options:>{
		{OutputFormat->Count,(Plot|Count),"Indicates whether the data computed about container/cover notebook mismatches is presented visually."}
	}
];

PlotContainerCoverNotebookMismatches::NoContainersFound = "No containers were found to have been created before this specific date.";
PlotContainerCoverNotebookMismatches::NoContainerCoverFinancerConflict = "No container and cover combination have conflicting financers.";
PlotContainerCoverNotebookMismatches::UnacceptableIncrement = "You cannot specify a time increment less than 1 Day. Please increase the increment time.";
PlotContainerCoverNotebookMismatches::RoundingIncrement = "The specified increment has been rounded down so that it is divisible by the smallest allowed increment of 1 Day: `1`";


(*Performs search on all available/stocked containers created before a specified date*)
(*and plots the container/cover notebook mismatches visually*)
(*Additionally creates a table with notebook mismatches that also have conflicting financers*)
PlotContainerCoverNotebookMismatches[date_?DateObjectQ, ops:OptionsPattern[]]:= Module[
	{safeOps, outputFormat, allContainers, allContainersCount, allFields, allContainerValues, containers, containerNotebooks, containerNotebookFinancers,
	covers, coverNotebooks, coverNotebookFinancers, containerWithNullNotebook, coverWithNullNotebook, coverContainerMismatch, coverContainerMatch,
	coverContainerFinancerConflict, containersAndCoverContainerNullMismatch, containersAndCoverCoverNullMismatch, containersAndCoverMismatchesWithNoNull,
	containersAndCoverContainerMatch, conflictingContainersAndCoversAndNotebooks, numOfContainerWithNullNotebook, numOfCoverWithNullNotebook,
	numOfCoverContainerMismatch, numOfCoverContainerMatch, numOfCoverContainerFinancerConflict, dateAndDataPoint,
	visualizationData, containersAndCoverMismatchesBarChart, conflictingCoverFinancersTable},

	(* get safeOps *)
	safeOps = SafeOptions[PlotContainerCoverNotebookMismatches, ToList[ops]];

	(* lookup and set user defined options to local variables *)
	{outputFormat} = Lookup[safeOps,{OutputFormat}];

	(*Search for all Available and Stocked vessels and plates currently in the lab*)
	allContainers = Search[{Object[Container, Vessel], Object[Container, Plate]}, Status==(Available|Stocked)&&DateCreated <= date];

	(*number of available/stocked containers found at this specific date*)
	allContainersCount = Length[allContainers];

	(*if we found no containers, return 0 for every category of notebook relation and the number of containers*)
	If[allContainersCount==0,
		If[MatchQ[outputFormat, Plot],
			Message[PlotContainerCoverNotebookMismatches::NoContainersFound];Return[$Failed],
			Return[{date, 0, 0, 0, 0, 0, 0}]
		]
	];

	(*all relevant fields required to make comparisons between container, cover, and sample notebooks/financers*)
	allFields = {
		Object,
		Notebook[Object],
		Notebook[Financers][Object],
		Cover[Object],
		Cover[Notebook][Object],
		Cover[Notebook][Financers][Object]
	};

	(*Extraction of all the relevant fields from all our containers*)
	allContainerValues = Download[allContainers, allFields, Date->date];

	(*all containers*)
	containers = allContainerValues[[All,1]];

	(*all container notebooks*)
	containerNotebooks = allContainerValues[[All,2]];

	(*all financers attached to the container notebooks*)
	containerNotebookFinancers = allContainerValues[[All,3]];

	(*all covers assigned to the containers, can be Null*)
	covers = allContainerValues[[All,4]];

	(*all cover notebooks*)
	coverNotebooks = allContainerValues[[All,5]];

	(*all financers attached to the cover notebooks*)
	coverNotebookFinancers = allContainerValues[[All,6]];

	(*Determine if a pairing of a container with its cover such that the notebook of the container is null but the notebook of the cover is not null*)
	containerWithNullNotebook = MapThread[
		MatchQ[#1, Null]&&!MatchQ[#2, Null]&&!MatchQ[#3, Null]&,
		{containerNotebooks, coverNotebooks, covers}
	];

	(*Determine if a pairing of a container with its cover such that the notebook of the container is not null but the notebook of the cover is null*)
	coverWithNullNotebook = MapThread[
		!MatchQ[#1, Null]&&MatchQ[#2, Null]&&!MatchQ[#3, Null]&,
		{containerNotebooks, coverNotebooks, covers}
	];

	(*Determine if a pairing of a container with its cover is such that the notebook of the container and the notebook of the cover are both not Null and not matching*)
	coverContainerMismatch = MapThread[
		!MemberQ[{#1, #2}, Null]&&!MatchQ[#1, #2]&&!MatchQ[#3, Null]&,
		{containerNotebooks, coverNotebooks, covers}
	];

	(*Determine if a container/cover pair do have matching notebooks*)
	coverContainerMatch = MapThread[
		MatchQ[#1, #2]&&!MatchQ[#3, Null]&,
		{containerNotebooks, coverNotebooks, covers}
	];

	(*Determine if a container/cover pair have notebooks with conflicting financers*)
	coverContainerFinancerConflict = MapThread[
		!MemberQ[{#1, #2}, Null]&&!MatchQ[#1, #2]&&!MatchQ[#3, Null]&,
		{containerNotebookFinancers, coverNotebookFinancers, covers}
	];

	(*Select every container/cover pair where the notebook of the container is Null but the notebook of the cover is not*)
	containersAndCoverContainerNullMismatch = If[MatchQ[outputFormat, Plot],
			Transpose[{PickList[containers, containerWithNullNotebook, True], PickList[covers, containerWithNullNotebook, True]}],
			{}
	];

	(*Select every container/cover pair where the notebook of the cover is Null but the notebook of the container is not*)
	containersAndCoverCoverNullMismatch = If[MatchQ[outputFormat, Plot],
			Transpose[{PickList[containers, coverWithNullNotebook, True], PickList[covers, coverWithNullNotebook, True]}],
			{}
	];
	(*Select every container/cover pair where neither notebook is Null but the notebooks do not match*)
	containersAndCoverMismatchesWithNoNull = If[MatchQ[outputFormat, Plot],
     	Transpose[{PickList[containers, coverContainerMismatch, True], PickList[covers, coverContainerMismatch, True]}],
			{}
	];
	(*Select every container/cover pair where the notebook of the container and the cover do match*)
	containersAndCoverContainerMatch = If[MatchQ[outputFormat, Plot],
			Transpose[{PickList[containers, coverContainerMatch, True], PickList[covers, coverContainerMatch, True]}],
			{}
	];

	(*Select every container/cover pair that have notebooks with conflicting financers*)
	conflictingContainersAndCoversAndNotebooks = If[MatchQ[outputFormat, Plot],
			PickList[Transpose[{containers, containerNotebooks, covers, coverNotebooks}], coverContainerFinancerConflict, True],
			{}
	];

	(*Count the number of times where we have a mismatch, a null/notebook combination, or a match notebook for each time increment*)
	{numOfContainerWithNullNotebook, numOfCoverWithNullNotebook, numOfCoverContainerMismatch, numOfCoverContainerMatch, numOfCoverContainerFinancerConflict} =
			Map[Count[#, True]&,
				{
					containerWithNullNotebook,
					coverWithNullNotebook,
					coverContainerMismatch,
					coverContainerMatch,
					coverContainerFinancerConflict
				}
			];

	(*Pair up each count with its respective time increment so that we can track *)
	dateAndDataPoint = Prepend[{allContainersCount,numOfContainerWithNullNotebook, numOfCoverWithNullNotebook, numOfCoverContainerMismatch, numOfCoverContainerMatch, numOfCoverContainerFinancerConflict},date];

	(*Create list with counts of data for display in case we are going to visualize the container/cover mismatches*)
	visualizationData = {numOfContainerWithNullNotebook, numOfCoverWithNullNotebook, numOfCoverContainerMismatch, numOfCoverContainerFinancerConflict};

	(*If OutputFormat is Plot, create a visual representation of the mismatches for comparison using a barchart*)
	containersAndCoverMismatchesBarChart = If[MatchQ[outputFormat, Plot],
		EmeraldBarChart[
			{visualizationData},
			Legend->ToString/@visualizationData,
			PlotLabel->"Container And Cover Notebook Relationships",
			ChartLabels->{"Container w/ Null Notebook", "Cover w/ Null Notebook", "Mismatching Notebooks", "Conflicting Financers"}
		],
		Null
	];

	(*Form a table that shows the specific container/cover mismatching financers so that they can be easily referenced/changed*)
	conflictingCoverFinancersTable = If[MatchQ[outputFormat, Plot],
			If[numOfCoverContainerFinancerConflict>=1,
					PlotTable[conflictingContainersAndCoversAndNotebooks,
						TableHeadings->{Table[x,{x, 1, Length[conflictingContainersAndCoversAndNotebooks]}],{"Container", "Notebook", "Cover", "Cover Notebook"}},
						Title->"Containers And Covers With Conflicting Financers"
					],
				Nothing
			],
			Null
	];

	(*If OutputFormat is set to Plot and no conflicting cover/container financers were found, provide message saying so*)
	If[MatchQ[outputFormat, Plot]&&conflictingCoverFinancersTable==Nothing,
		Message[PlotContainerCoverNotebookMismatches::NoContainerCoverFinancerConflict];Nothing
	];

	(*If OutputFormat is set to Plot, output each graphic. Otherwise, return the date and the container/cover matching data*)
	If[MatchQ[outputFormat, Plot],
		{containersAndCoverMismatchesBarChart,conflictingCoverFinancersTable},
		dateAndDataPoint
	]

];


(*Takes in a start date and end date and plots categories of notebook mismatches between cover/container pairs*)
(*at specified time increments*)
PlotContainerCoverNotebookMismatches[startDate_?DateObjectQ, endDate_?DateObjectQ, increment_]:=Module[
	{flooredIncrement, roundedEndDate, roundedStartDate, dateRange, existingData, newData, finalData, sortedFinalData, requestedDateRange, existingDates,
		newDates, filteredData, filePath, newCloudFile, plotData, nullContainerNotebookData, nullCoverNotebookData, mismatchingNotebookData, conflictingNotebookData
	},

	(*we aren't tracking the mismatches any more specific timing than daily. If a smaller increment is requested, then return failed*)
	If[increment < 1 Day,
		Message[PlotContainerCoverNotebookMismatches::UnacceptableIncrement];Return[$Failed]
	];

	flooredIncrement = Floor[increment, 1 Day];

	If[flooredIncrement!=increment,
		Message[PlotContainerCoverNotebookMismatches::RoundingIncrement, flooredIncrement]
	];

	(*round the startDate and endDate so that it is always at midnight*)
	roundedEndDate = DateObject[DateObject[endDate, "Day"], {0, 00, 0}];
	roundedStartDate = DateObject[DateObject[startDate, "Day"], {0, 00, 0}];

	(*find the range between the rounded start date and the rounded end date using increment*)
	requestedDateRange = DateRange[roundedStartDate, roundedEndDate, flooredIncrement];

	(*import cloud file with name "Container-Cover Mismatches Per Day" containing existing data*)
	existingData = ToExpression@ImportCloudFile[Object[EmeraldCloudFile,"Container-Cover Mismatches Per Day"], Format->"CSV"];

	(*check all the dates we have in the existing cloud file*)
	existingDates = existingData[[All,1]];

	(*compare the existing dates with the date range that has been requested, pulling out the requested dates that are not found in existing dates*)
	newDates = Complement[requestedDateRange, existingDates];

	(*if we are requesting any dates that we don't have, run computeContainerNotebookMismatches to find the number of *)
	(*containers with Null notebooks, covers with Null notebooks, mismatching cover/container notebooks, and matching cover/container notebooks*)
	newData=If[Length[newDates]>0,
		PlotContainerCoverNotebookMismatches[#, OutputFormat->Count]&/@ newDates,
		{}
	];

	(*join the existing data and the computed new data, along with a precautionary check to remove any duplicated data*)
	finalData = DeleteDuplicates[Join[newData, existingData]];

	(*sort the final data by date*)
	sortedFinalData = SortBy[finalData, First];

	(*pull out the data that match the requested date range values*)
	filteredData = Cases[sortedFinalData,{Alternatives@@requestedDateRange,__}];

	(*if we had to compute any new data, replace the current cloud file with a cloud file containing new data*)
	If[Length[newDates]>0,
		filePath=If[ProductionQ[],
			FileNameJoin[{$TemporaryDirectory,"container_log_data_production.csv"}],
			FileNameJoin[{$TemporaryDirectory,"container_log_data_test.csv"}]
		];
		Export[filePath,sortedFinalData];
		newCloudFile=UploadCloudFile[filePath];
		Upload[<|Object->Object[EmeraldCloudFile,"Container-Cover Mismatches Per Day"],Name->Null, FileName->Null|>];
		Upload[<|Object->newCloudFile,Name->"Container-Cover Mismatches Per Day",FileName->"Container-Cover Mismatches Per Day"|>];
	];

	(*plot the mismatches along with the total number of containers*)
	plotData = Transpose[{filteredData[[All,1]], #}]&/@({filteredData[[All,3]], filteredData[[All,4]], filteredData[[All,5]], filteredData[[All,7]]});

	(*Plot the requested dates using the data we already computed and any requested existing data*)
	nullContainerNotebookData=EmeraldDateListPlot[
		plotData[[1]],
		PlotStyle->{Orange},
		PlotLabel->"Public Containers with Private Covers Over Time",
		PlotRange->All,
		GridLines -> {{{"October 18, 2022", Directive[Dashed, Thick, Red]}, {"October 25, 2022", Directive[Dashed, Thick, Green]}, {"November 3, 2022", Directive[Dashed, Thick, Blue]}, {"November 18, 2022", Directive[Dashed, Thick, Orange]}}, {{0, Directive[Thin, Black]}}}
	];

	(*Plot the requested dates using the data we already computed and any requested existing data*)
	nullCoverNotebookData=EmeraldDateListPlot[
		plotData[[2]],
		PlotStyle->{Darker[Blue]},
		PlotLabel->"Private Containers with Public Covers Over Time",
		PlotRange->{Automatic, {0, 300}},
		GridLines -> {{{"October 18, 2022", Directive[Dashed, Thick, Red]}, {"October 25, 2022", Directive[Dashed, Thick, Green]}, {"November 3, 2022", Directive[Dashed, Thick, Blue]}, {"November 18, 2022", Directive[Dashed, Thick, Orange]}}, {{0, Directive[Thin, Black]}}}
	];

	(*Plot the requested dates using the data we already computed and any requested existing data*)
	mismatchingNotebookData=EmeraldDateListPlot[
		plotData[[3]],
		PlotStyle->{Purple},
		PlotLabel->"Container/Cover Combinations with \n Mismatching Notebooks Over Time ",
		PlotRange->{Automatic, {0, 300}},
		GridLines -> {{}, {{0, Directive[Thin, Black]}}}
	];

	(*Plot the requested dates using the data we already computed and any requested existing data*)
	conflictingNotebookData=EmeraldDateListPlot[
		plotData[[4]],
		PlotStyle->{Darker[Red]},
		PlotLabel->"Container/Cover Combinations with \n Conflicting Notebook Financers Over Time",
		PlotRange->All,
		GridLines -> {{{"October 18, 2022", Directive[Dashed, Thick, Red]}}, {{0, Directive[Thin, Black]}}}
	];

Grid[{
	{nullContainerNotebookData, nullCoverNotebookData},
	{mismatchingNotebookData, conflictingNotebookData}
}]

];

(* ::Section:: *)

(* ::Subsection::Closed:: *)