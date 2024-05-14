(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineTests[
	ValidContainerStorageConditionQ,
	{
		Example[{Messages, "Returns False for any samples where the specified storage condition conflicts with the storage condition of samples that share the same container:"},
			ValidContainerStorageConditionQ[
				{Object[Sample, "ValidContainerStorageConditionQ test sample 1"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 2"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 3"]},
				{Freezer, Refrigerator, Freezer}
			],
			{False, False, False},
			Messages :> {Error::SharedContainerStorageCondition}
		],
		Example[{Basic, "Returns True for any samples that share a container and the specified storage conditions are compatible:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"], Object[Sample, "ValidContainerStorageConditionQ test sample 3"]}, {Freezer, Freezer, Freezer}],
			{True, True, True}
		],
		Example[{Messages, "Returns False for any samples where the specified storage condition conflicts with the storage condition of unused samples that share the same container:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"]}, {Freezer, Freezer}],
			{False, False},
			Messages :> {Error::SharedContainerStorageCondition}
		],
		Example[{Messages, "Returns False for any samples generated in the same container where the specified storage condition conflicts with the storage condition of samples that share the same container:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"]}, {{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}, {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}, {Freezer, AmbientStorage}],
			{False, False},
			Messages :> {Error::SharedContainerStorageCondition}
		],
		Example[{Basic, "Returns True for any samples where the storage condition is Null since this will default to the container storage condition:"},
			ValidContainerStorageConditionQ[
				{Object[Sample, "ValidContainerStorageConditionQ test sample 1"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 2"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 3"]},
				{Null, Null, Null}
			],
			{True, True, True}
		],
		Example[{Basic, "Returns True for any samples where the storage condition is Null and samples sharing that container have specified storage conditions:"},
			ValidContainerStorageConditionQ[
				{Object[Sample, "ValidContainerStorageConditionQ test sample 1"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 2"],
					Object[Sample, "ValidContainerStorageConditionQ test sample 3"]},
				{Null, Freezer, Null}
			],
			{True, True, True}
		],
		Example[{Basic, "Returns True for any samples generated in the same container where the storage condition is Null:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"]}, {{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}, {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}, {Null, Null}],
			{True, True}
		],
		Example[{Basic, "Returns True for any samples generated in the same container where the storage condition of some samples are Null and some samples are specified:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"]}, {{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}, {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}, {Null, Freezer}],
			{True, True}
		],
		Example[{Options, Output, "Returns the results and tests:"},
			ValidContainerStorageConditionQ[{Object[Sample, "ValidContainerStorageConditionQ test sample 1"], Object[Sample, "ValidContainerStorageConditionQ test sample 2"], Object[Sample, "ValidContainerStorageConditionQ test sample 3"]}, {Freezer, Refrigerator, Freezer}, Output -> {Result, Tests}],
			{{False, False, False}, {TestP}}
		]
	},

	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Sample, "ValidContainerStorageConditionQ test sample 1"],
				Object[Sample, "ValidContainerStorageConditionQ test sample 2"],
				Object[Sample, "ValidContainerStorageConditionQ test sample 3"],
				Object[Container, Plate, "ValidContainerStorageConditionQ test container"]
			}], ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];

		Module[ {container, samples},
			(*Upload empty containers*)
			container=ECL`InternalUpload`UploadSample[
				Model[Container, Plate, "96-well 2mL Deep Well Plate"], {"A1",
					Object[Container, Shelf, "Ambient Storage Shelf"]}, Name -> "ValidContainerStorageConditionQ test container"];

			(*Upload test sample objects. Place test objects in the same plate*)
			samples=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", Object[Container, Plate, "ValidContainerStorageConditionQ test container"]},
					{"A2", Object[Container, Plate, "ValidContainerStorageConditionQ test container"]},
					{"A3", Object[Container, Plate, "ValidContainerStorageConditionQ test container"]}
				},
				Name ->
					{
						"ValidContainerStorageConditionQ test sample 1",
						"ValidContainerStorageConditionQ test sample 2",
						"ValidContainerStorageConditionQ test sample 3"
					},
				InitialAmount -> ConstantArray[0.5 Milliliter, 3]
			];

		];
	),

	SymbolTearDown :> (

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Sample, "ValidContainerStorageConditionQ test sample 1"],
				Object[Sample, "ValidContainerStorageConditionQ test sample 2"],
				Object[Sample, "ValidContainerStorageConditionQ test sample 3"],
				Object[Container, Plate, "ValidContainerStorageConditionQ test container"]
			}], ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		]
	)
];
