(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ReviewExperiment*)


(* ::Subsubsection::Closed:: *)
(*ReviewExperiment*)


DefineTests[ReviewExperiment,
	{
		Example[{Basic,"Generate a review of a particular protocol:"},
			Quiet[ReviewExperiment[Object[Qualification, HPLC, "id:N80DNj1xRAA6"]],{Download::SomeMetaDataUnavailable}],
			ObjectP[Object[Report,ReviewExperiment]],
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects,Force->True];
			)
		],
		Example[{Basic,"Fetch the review notebook from a review:"},
			(
				review = Quiet[ReviewExperiment[Object[Qualification, HPLC, "id:N80DNj1xRAA6"]],{Download::SomeMetaDataUnavailable}];
				Download[review,ReviewNotebook[Object]]
			),
			ObjectP[Object[EmeraldCloudFile]],
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{review}
		],
		Example[{Options,Upload,"Return a packet:"},
			Quiet[
				ReviewExperiment[
					Object[Qualification, HPLC, "id:N80DNj1xRAA6"],
					Upload -> False
				],
				{Download::SomeMetaDataUnavailable}
			],
			PacketP[Object[Report,ReviewExperiment]],
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{review}
		],
		Example[{Options,Export,"Do not export a report notebook:"},
			(
				review = Quiet[
					ReviewExperiment[
						Object[Qualification, HPLC, "id:N80DNj1xRAA6"],
						Export->False
					],
					{Download::SomeMetaDataUnavailable}
				];
				Download[review,ReviewNotebook[Object]]
			),
			Null,
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{review}
		]
	}
];
