(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ObjectLogAssociation*)

DefineTests[
	ObjectLogAssociation,
	{
		Example[{Options, DatesOnly, "DatesOnly->True only returns a list of dates for each log entry:"},
			ObjectLogAssociation[Object[Sample], DatesOnly->True, MaxResults -> 2],
			ListableP[_DateObject]
		],
		Example[{Options, ObjectIdsOnly, "ObjectIdsOnly->True only returns a list of object IDs for each log entry:"},
			ObjectLogAssociation[Object[Sample], ObjectIdsOnly->True, MaxResults -> 2],
			ListableP[ObjectReferenceP[Object[Sample]]]
		],
		Example[{Options, MaxResults, "MaxResults limits the number of results from ObjectLog[]:"},
			ObjectLogAssociation[Object[Sample], MaxResults -> 2],
			ObjectLogOutputP
		],
		Example[{Options, SubTypes, "SubTypes->True also considers subtypes as part of a Type's object log:"},
			ObjectLogAssociation[Object[Sample], SubTypes -> True, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, User, "User returns a log of the most recent changes made by the specified user:"},
			ObjectLogAssociation[User -> $PersonID, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, StartDate, "StartDate specifies a lower bound for the object log. Default is None and represents the earliest possible changes:"},
			ObjectLogAssociation[Object[Sample], StartDate -> Yesterday, Order -> OldToNew, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, EndDate, "EndDate specifies an upper bound for the object log. Default is Now:"},
			ObjectLogAssociation[Object[Sample], EndDate -> Yesterday, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Fields, "The Field option only returns logs with changes given on specified fields:"},
			ObjectLogAssociation[Object[Sample, "ObjectLogAssociation "<>$SessionUUID], Fields -> {Count}, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Fields, "The Field option only returns logs with changes given on specified singleton field:"},
			ObjectLogAssociation[Object[Sample, "ObjectLogAssociation "<>$SessionUUID], Fields -> Count, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, Order, "Order represents whether the logs are sorted by most recent or by most oldest. Order is descending by default with the most recent changes on top:"},
			ObjectLogAssociation[Object[Sample, "ObjectLogAssociation "<>$SessionUUID], Order -> OldToNew, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, RevisionHistory, "By default revision history is hidden, but revision history displays whether the object log was modified and by whom:"},
			ObjectLogAssociation[Object[Sample, "ObjectLogAssociation "<>$SessionUUID], RevisionHistory -> True, MaxResults -> 5],
			ObjectLogOutputP
		],
		Example[{Options, LogKinds, "LogKinds option returns list of all object log entries of a particular kind e.g. FieldAdditionModification, ObjectCreation etc. Default is All:"},
			ObjectLogAssociation[Object[Sample, "ObjectLogAssociation "<>$SessionUUID], LogKinds -> {FieldAdditionModification}],
			ObjectLogOutputP
		],
		Example[{Messages, "NotLoggedIn", "Fails if returned if the user is not logged in:"},
			ObjectLogAssociation[],
			$Failed,
			Messages :> {ObjectLogAssociation::NotLoggedIn},
			Stubs :> {
				Constellation`Private`loggedInQ[]:=False
			}
		],
		Example[{Messages, "RequestError", "Fails if there is an error in the request call that can't be caught by a pattern:"},
			ObjectLogAssociation[Object[User, Emerald, Developer, "id:1"]],
			$Failed,
			Messages :> {ObjectLogAssociation::RequestError}],
		Example[{Messages, "NoResults", "If there are no results, ObjectLog returns null:"},
			ObjectLogAssociation[StartDate -> Now + 1 Hour],
			Null,
			Messages :> {ObjectLogAssociation::NoResults}
		],
		Example[{Messages, "InvalidData", "Some older data has some invalid inconsistencies. If there is one, ObjectLog will warn the user:"},
			Message[ObjectLogAssociation::InvalidData],
			Null,
			Messages :> {ObjectLogAssociation::InvalidData}
		],
		Example[{Messages, "SomeMetaDataUnavailable", "Meta data on fields with multiple entries were not tracked for some older data. For results containing such data, ObjectLog will warn the user:"},
			Message[ObjectLogAssociation::SomeMetaDataUnavailable,"{SamplesIn, SamplesOut}"],
			Null,
			Messages :> {ObjectLogAssociation::SomeMetaDataUnavailable}
		],
		Example[{Messages, "InvalidField", "Computable fields cannot be retrieved using ObjectLog:"},
			ObjectLogAssociation[Object[Container], Fields->{AllowedPositions}],
			$Failed,
			Messages :> {ObjectLogAssociation::InvalidField}
		]
	},
	SymbolSetUp :> {
		Module[{object},
			object=Upload[<|Type->Object[Sample], Name->"ObjectLogAssociation "<>$SessionUUID|>,AllowPublicObjects->True];

			(* Make a few modifications to the object *)
			Upload[<|Object->object, Count->1|>];
			Upload[<|Object->object, Count->2|>];
			Upload[<|Object->object, Count->3|>];
			Upload[<|Object->object, Count->4|>];
			Upload[<|Object->object, Count->5|>];
		];
	}
]
