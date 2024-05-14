(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(* computeContainerCoverNotebookMismatches *)
DefineTests[computeContainerCoverNotebookMismatches,
	{

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
(* PlotContainerCoverNotebookMismatches *)
DefineTests[PlotContainerCoverNotebookMismatches,
	{	Example[{Basic,"Given a specific date, return that date and the total number of containers that were created before that date, along with the following container/cover notebook categories: Null container notebook with populated cover notebook, populated container notebook with Null cover notebook, mismatching populated notebooks, matching populated notebooks, mismatching populated notebooks that have conflicting financers."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 9, 28, 7, 14, 19.2263475}, "Instant", "Gregorian", -7.]],
				{Download::SomeMetaDataUnavailable}
			],
			{DateObject[{2021, 9, 28, 7, 14, 19.2263475}, "Instant", "Gregorian", -7.], _Integer, _Integer, _Integer, _Integer, _Integer, _Integer},
			TimeConstraint -> 5000
	],
		Example[{Basic,"If the given date yields that no containers were created, return that date and 0 for each category of notebook matching."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2020, 9, 28, 7, 21, 41.6937898}, "Instant", "Gregorian", -7.]],
				{Download::SomeMetaDataUnavailable}
			],
			{DateObject[{2020, 9, 28, 7, 21, 41.6937898}, "Instant", "Gregorian", -7.], 0, 0, 0, 0, 0, 0},
			TimeConstraint -> 5000
		],
		Example[{Basic,"Given a start date, end date, and increment of time, return 4 plots in this order: A plot containing mismatches of a Null cover notebook and a populated container notebook, a plot containing mismatches of a Null container notebook and a populated cover notebook, a plot containing mismatches of populated cover and container notebooks, and a plot with notebook mismatches that have conflicting financers as well."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 8, 2, 16, 43, 27.9247669}, "Instant", "Gregorian", -7.], DateObject[{2021, 12, 2, 16, 43, 25.8611553}, "Instant", "Gregorian", -7.], 1 Week],
				{Download::SomeMetaDataUnavailable}
			],
			Grid[{{_?ValidGraphicsQ,_?ValidGraphicsQ},{_?ValidGraphicsQ,_?ValidGraphicsQ}}],
			TimeConstraint -> 5000

		],
		Example[{Basic,"Given a start date, end date, and increment of time, if the increment is less than 1 Day, throw an error."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 8, 2, 16, 43, 27.9247669}, "Instant", "Gregorian", -7.], DateObject[{2021, 12, 2, 16, 43, 25.8611553}, "Instant", "Gregorian", -7.], 1 Hour],
				{Download::SomeMetaDataUnavailable}
			],
			$Failed,
			Messages :> PlotContainerCoverNotebookMismatches::UnacceptableIncrement,
			TimeConstraint -> 5000

		],
		Example[{Basic,"Given a start date, end date, and increment of time, if the increment is not divisible by 1 day, throw a message indicating that the increment has been floored to be an integer number of days."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 8, 2, 16, 43, 27.9247669}, "Instant", "Gregorian", -7.], DateObject[{2021, 12, 2, 16, 43, 25.8611553}, "Instant", "Gregorian", -7.], 1 Week + 1 Hour],
				{Download::SomeMetaDataUnavailable}
			],
			Grid[{{_?ValidGraphicsQ,_?ValidGraphicsQ},{_?ValidGraphicsQ,_?ValidGraphicsQ}}],
			Messages :> PlotContainerCoverNotebookMismatches::RoundingIncrement,
			TimeConstraint -> 5000

		],
		Example[{Options, OutputFormat,"If OutputFormat is set to Plot and given a specific date, return a bar chart with the following container/cover notebook categories: Null container notebook with populated cover notebook, populated container notebook with Null cover notebook, mismatching populated notebooks, matching populated notebooks, mismatching populated notebooks that have conflicting financers. Additionally, return a table with the specific containers and covers that have notebooks with conflicing financers."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 11, 30, 17, 14, 54.1652125}, "Instant", "Gregorian", -7.], OutputFormat->Plot],
				{Download::SomeMetaDataUnavailable}
			],
			{_?ValidGraphicsQ, _},
			TimeConstraint -> 5000
		],
		Example[{Options, OutputFormat,"If OutputFormat is set to Plot but no containers were found to exist on the specified date, return a message indicating so."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 1, 30, 17, 13, 53.4629819}, "Instant", "Gregorian", -7.], OutputFormat->Plot],
				{Download::SomeMetaDataUnavailable}
			],
			$Failed,
			Messages :> PlotContainerCoverNotebookMismatches::NoContainersFound,
			TimeConstraint -> 5000

		],
		Example[{Options, OutputFormat,"If OutputFormat is set to Plot and containers were found to exist on the specified date but no conflicting container and cover notebook financers were found, return a bar chart showing the container/cover notebook categories and a message about no conflicting financers."},
			Quiet[
				PlotContainerCoverNotebookMismatches[DateObject[{2021, 10, 2, 14, 10, 59.3249384}, "Instant", "Gregorian", -7.], OutputFormat->Plot],
				{Download::SomeMetaDataUnavailable}
			],
			{_?ValidGraphicsQ},
			Messages :> PlotContainerCoverNotebookMismatches::NoContainerCoverFinancerConflict,
			TimeConstraint -> 5000
		]
	},
	SymbolSetUp:> {
		Module[{allObjects, existingObjects, testData, filePath, newCloudFile},
			$CreatedObjects = {};

			allObjects = {
				Object[EmeraldCloudFile, "Container-Cover Mismatches Per Day"]
			};

			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			testData = {{DateObject[{2021, 2, 2, 0, 0, 0.`}, "Instant", "Gregorian", -7.`], 0, 0, 0, 0, 0, 0}};

			filePath = 	FileNameJoin[{$TemporaryDirectory,"container_log_data_test.csv"}];

			Export[filePath, testData];

			newCloudFile = UploadCloudFile[filePath];

			Upload[
				<|
					Object->newCloudFile,
					Name->"Container-Cover Mismatches Per Day",
					FileName->"Container-Cover Mismatches Per Day"
				|>
			];
		]
	},
		SymbolTearDown :> Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects];
		]

];