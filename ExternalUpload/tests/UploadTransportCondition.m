(* ::Package:: *)

(* ::Section:: *)
(*Unit Tests*)


(* ::Subsection::Closed:: *)
(*UploadTransportCondition*)


(* Define the Unit Tests *)
DefineTests[UploadTransportCondition,
	{
		Example[{Basic, "Upload a transport condition to a Object[Sample]:"},
			(
				UploadTransportCondition[Object[Sample, "Test Sample 1 for UploadTransportCondition"<> $SessionUUID], Chilled];
				Download[Object[Sample, "Test Sample 1 for UploadTransportCondition"<> $SessionUUID], {TransportCondition}][Name]
			),
			{"Chilled"}
		],

		Example[{Basic, "Upload a single transport condition to multiple objects:"},
			(
				UploadTransportCondition[{Object[Sample, "Test Sample 4 for UploadTransportCondition"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportCondition"<> $SessionUUID]}, Minus40];
				Flatten[Download[{Object[Sample, "Test Sample 4 for UploadTransportCondition"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportCondition"<> $SessionUUID]}, {TransportCondition}]][Name]
			),
			{"Minus 40","Minus 40"}
		],

		Example[{Options, Upload, "Set Upload->False to show the packets which would be uploaded:"},
			(
				UploadTransportCondition[Object[Sample, "Test Sample 1 for UploadTransportCondition"<> $SessionUUID], Chilled, Upload -> False]
			),
			PacketP[]
		],

		Example[{Messages, "DiscardedSamples", "Will throw a warning when uploading a transport condition to a discarded sample:"},
			(
				status=Download[Object[Sample, "Test Sample 3 for UploadTransportCondition"<> $SessionUUID], Status];
				UploadTransportCondition[Object[Sample, "Test Sample 3 for UploadTransportCondition"<> $SessionUUID], Chilled];
				status
			),
			Discarded,
			Messages :> {Warning::DiscardedSamples}
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs,containerIDs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportCondition"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportCondition"<> $SessionUUID],
				Object[Sample, "Test Sample 3 for UploadTransportCondition"<> $SessionUUID],
				Object[Sample, "Test Sample 4 for UploadTransportCondition"<> $SessionUUID],

				Object[Container, Vessel, "Test Container 1 for UploadTransportCondition"<> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for UploadTransportCondition"<> $SessionUUID],
				Object[Container, Vessel, "Test Container 4 for UploadTransportCondition"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			containerIDs = Table[CreateID[Object[Container,Vessel]],3];

			Upload[{
				<|
					Object->containerIDs[[1]],
					Name-> "Test Container 1 for UploadTransportCondition"<> $SessionUUID,
					Model->Link[Model[Container, Vessel, "2mL Tube"],Objects]
				|>,
				<|
					Object->containerIDs[[2]],
					Name-> "Test Container 3 for UploadTransportCondition"<> $SessionUUID,
					Model->Link[Model[Container, Vessel, "2mL Tube"],Objects]
				|>,
				<|
					Object->containerIDs[[3]],
					Name-> "Test Container 4 for UploadTransportCondition"<> $SessionUUID,
					Model->Link[Model[Container, Vessel, "2mL Tube"],Objects]
				|>
			}];

			Upload[{
				<|
					Type -> Object[Sample],
					Name -> "Test Sample 1 for UploadTransportCondition"<> $SessionUUID,
					StorageCondition-> Link[Model[StorageCondition,"Refrigerator"]],
					Container->Link[Object[Container, Vessel, "Test Container 1 for UploadTransportCondition"<> $SessionUUID],Contents,2],
					DeveloperObject -> True
				|>,
				<|Type -> Model[Sample], Name -> "Test Sample 2 for UploadTransportCondition"<> $SessionUUID, DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]], DeveloperObject -> True|>,
				<|
					Type -> Object[Sample],
					Name -> "Test Sample 3 for UploadTransportCondition"<> $SessionUUID,
					Status -> Discarded,
					StorageCondition -> Link[Model[StorageCondition,"Freezer"]],
					Container->Link[Object[Container, Vessel, "Test Container 3 for UploadTransportCondition"<> $SessionUUID],Contents,2],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Sample],
					Name -> "Test Sample 4 for UploadTransportCondition"<> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
					Container->Link[Object[Container, Vessel, "Test Container 4 for UploadTransportCondition"<> $SessionUUID],Contents,2],
					DeveloperObject -> True|>
			}];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportCondition"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportCondition"<> $SessionUUID],
				Object[Sample, "Test Sample 3 for UploadTransportCondition"<> $SessionUUID],
				Object[Sample, "Test Sample 4 for UploadTransportCondition"<> $SessionUUID],

				Object[Container, Vessel, "Test Container 1 for UploadTransportCondition"<> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for UploadTransportCondition"<> $SessionUUID],
				Object[Container, Vessel, "Test Container 4 for UploadTransportCondition"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	}
];


(* ::Subsection:: *)
(*UploadTransportConditionOptions*)

DefineTests[UploadTransportConditionOptions,
	{
		Example[{Basic, "Returns resolved options for UploadTransportCondition when passed a singleton input:"},
			(
				UploadTransportConditionOptions[Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], Chilled, OutputFormat -> List]
			),
			{}
		],

		Example[{Basic, "Returns resolved options for UploadTransportConditions when passed a list of inputs:"},
			(
				UploadTransportConditionOptions[{Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportConditionOptions"<> $SessionUUID]}, {35 Celsius, Ambient}, OutputFormat -> List]
			),
			{}
		],

		Example[{Basic, "Does not actually change the transport condition of the input:"},
			(
				beforeCondition=Download[Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], {TransportTemperature}];
				UploadTransportConditionOptions[Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], Ambient];
				afterCondition=Download[Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], {TransportTemperature}];
				{beforeCondition, afterCondition}
			),
			{{EqualP[4 Celsius]}, {EqualP[4 Celsius]}}
		],

		Example[{Additional, "Returns the resolved options when uploading a single transport condition to multiple objects:"},
			(
				UploadTransportConditionOptions[{Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportConditionOptions"<> $SessionUUID]}, Ambient]
			),
			{}
		],

		Example[{Options, OutputFormat, "Returns resolved options for UploadTransportCondition as a table:"},
			(
				UploadTransportConditionOptions[Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID], Chilled, OutputFormat -> Table]
			),
			Graphics_
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportConditionOptions"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];


			Upload[{
				<|Type -> Object[Sample], Name -> "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID, TransportTemperature->4 Celsius, DeveloperObject -> True|>,
				<|Type -> Model[Sample], Name -> "Test Sample 2 for UploadTransportConditionOptions"<> $SessionUUID, DeveloperObject -> True|>
			}];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportConditionOptions"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportConditionOptions"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	}
];

(* ::Subsection:: *)
(*UploadTransportConditionPreview*)
DefineTests[UploadTransportConditionPreview,
	{
		Example[{Basic, "Returns Null when passed a singleton input:"},
			(
				UploadTransportConditionPreview[Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], Chilled]
			),
			Null
		],

		Example[{Basic, "Returns Null when passed a list of inputs:"},
			(
				UploadTransportConditionPreview[{Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportConditionPreview"<> $SessionUUID]}, {35 Celsius, Ambient}]
			),
			Null
		],

		Example[{Basic, "Does not actually change the transport condition of the input:"},
			(
				beforeCondition=Download[Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], {TransportTemperature}];
				UploadTransportConditionPreview[Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], Ambient];
				afterCondition=Download[Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], {TransportTemperature}];
				{beforeCondition, afterCondition}
			),
			{{EqualP[4 Celsius]}, {EqualP[4 Celsius]}}
		],

		Example[{Additional, "Returns Null when passed a list of samples and a single transport condition:"},
			(
				UploadTransportConditionPreview[{Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID], Model[Sample, "Test Sample 2 for UploadTransportConditionPreview"<> $SessionUUID]}, Chilled]
			),
			Null
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportConditionPreview"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];


			Upload[{
				<|Type -> Object[Sample], Name -> "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID, TransportTemperature->4 Celsius, DeveloperObject -> True|>,
				<|Type -> Model[Sample], Name -> "Test Sample 2 for UploadTransportConditionPreview"<> $SessionUUID, DeveloperObject -> True|>
			}];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for UploadTransportConditionPreview"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for UploadTransportConditionPreview"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	}
];


(* ::Subsection:: *)
(*ValidUploadTransportConditionQ*)
DefineTests[ValidUploadTransportConditionQ,
	{
		Example[{Basic, "Validate a request to add a single samples transport condition:"},
			(
				ValidUploadTransportConditionQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Chilled]
			),
			True
		],

		Example[{Basic, "Validate a request to add transport conditions to multiple objects:"},
			(
				ValidUploadTransportConditionQ[{Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Model[Sample, "Test Sample 2 for ValidUploadTransportConditionQ"<> $SessionUUID]}, {35 Celsius, Ambient}]
			),
			True
		],

		Example[{Basic, "Does not actually change the transport condition of the input:"},
			(
				beforeCondition=Download[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], {TransportTemperature}];
				ValidUploadTransportConditionQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Ambient];
				afterCondition=Download[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], {TransportTemperature}];
				{beforeCondition, afterCondition}
			),
			{{EqualP[4 Celsius]}, {EqualP[4 Celsius]}}
		],

		Example[{Basic, "Invalid object input will not cause validation to fail:"},
			{
				ValidUploadTransportConditionQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Chilled],
				ValidObjectQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID]]
			},
			{True, False}
		],

		Example[{Additional, "Validate a request to add a single transport condition to multiple objects:"},
			(
				ValidUploadTransportConditionQ[{Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Model[Sample, "Test Sample 2 for ValidUploadTransportConditionQ"<> $SessionUUID]}, Chilled]
			),
			True
		],

		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			(
				ValidUploadTransportConditionQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], 60 Celsius, OutputFormat -> TestSummary]
			),
			_EmeraldTestSummary
		],

		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidUploadTransportConditionQ[Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID], Ambient, Verbose -> True],
			True
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for ValidUploadTransportConditionQ"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];


			Upload[{
			<|Type -> Object[Sample], Name -> "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID,  TransportTemperature->4 Celsius, DeveloperObject -> True|>,
			<|Type -> Model[Sample], Name -> "Test Sample 2 for ValidUploadTransportConditionQ"<> $SessionUUID, DeveloperObject -> True|>
			}];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Object[Sample, "Test Sample 1 for ValidUploadTransportConditionQ"<> $SessionUUID],
				Model[Sample, "Test Sample 2 for ValidUploadTransportConditionQ"<> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	}
];
