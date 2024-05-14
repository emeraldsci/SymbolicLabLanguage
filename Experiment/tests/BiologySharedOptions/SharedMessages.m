(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*checkSolidMedia*)

DefineTests[checkSolidMedia,
	{
		(* input a list of samples where some are in solid media and others arent and messages->True, should return the list of samples in solid media and the error *)
		Example[{Basic, "Return a list of invalid input samples that are in solid media and an error message:"},
			checkSolidMedia[
				Download[
					{
						Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID]
					}
				],
				True
			],
			{{ObjectP[Object[Sample]]...}, Null},
			Messages :> {Error::InvalidSolidMediaSample}
		],
		(* input a list of samples where some are in solid media and others arent and messages->False, should return the list of samples in solid media and the passing and failing tests, and no message *)
		Example[{Basic, "Return a list of invalid input samples that are in solid media and a list of failing and passing solid media tests:"},
			checkSolidMedia[
				Download[
					{
						Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID]
					}
				],
				False
			],
			{{ObjectP[Object[Sample]]...}, {TestP..}}
		],
		(* input a list of samples where no samples are in solid media (no invalid solid media samples) and messages->True, should return an empty list and no message *)
		Example[{Basic, "Return an empty list and no error message if there are no samples in solid media:"},
			checkSolidMedia[
				Download[
					{
						Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID]
					}
				],
				True
			],
			{{}, Null}
		],
		(* input a list of samples where no samples are in solid media (no invalid solid media samples) and messages->False, should return an empty list and the passing tests, and no message *)
		Example[{Basic, "Return an empty list and a list of passing solid media tests if there are no samples in solid media:"},
			checkSolidMedia[
				Download[
					{
						Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID]
					}
				],
				False
			],
			{{}, {TestP..}}
		]

	},

	SymbolSetUp :> (
		Module[{existsFilter, plate0, sample0, sample1, sample2, sample3},
			$CreatedObjects = {};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			Off[Warning::DeprecatedProduct];

			existsFilter = DatabaseMemberQ[{
				Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkSolidMedia "<>$SessionUUID]

			}];

			EraseObject[
				PickList[
					{
						Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Sample, "Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID],
						Object[Container, Plate, "Test 96-well plate 0 for checkSolidMedia "<>$SessionUUID]
					},
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			plate0 = Upload[
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-well plate 0 for checkSolidMedia "<>$SessionUUID,
					DeveloperObject -> True
				|>
			];

			{sample0, sample1, sample2, sample3} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}}
				},
				{
					{"A1", plate0},
					{"A2", plate0},
					{"A3", plate0},
					{"A4", plate0}
				},
				Name -> {
					"Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID,
					"Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID,
					"Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID,
					"Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Microbial,
					Microbial,
					Microbial,
					Microbial
				},
				CultureAdhesion -> {
					Suspension,
					Suspension,
					SolidMedia,
					SolidMedia
				},
				Living -> {
					True,
					True,
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];

			Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3}];
		]
	),

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[Flatten[{
				Object[Sample, "Suspension bacteria cell sample 0 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Suspension bacteria cell sample 1 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Solid media bacteria cell sample 2 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Sample, "Solid media bacteria cell sample 3 (Test for checkSolidMedia) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkSolidMedia "<>$SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	)
];

(* ::Subsection::Closed:: *)
(*checkDiscardedSamples*)

DefineTests[checkDiscardedSamples,
	{
		(* input a list of samples where some are discarded and others arent and messages->True, should return the list of discarded samples and the error *)
		Example[{Basic, "Return a list of invalid input samples that are discarded and an error message:"},
			checkDiscardedSamples[
				Download[
					{
						Object[Sample, "Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID]
					}
				],
				True
			],
			{{ObjectP[Object[Sample]]...}, Null},
			Messages :> {Error::DiscardedSamples}
		],
		(* input a list of samples where some are discarded and others arent and messages->False, should return the list of discarded samples and the passing and failing tests, and no message *)
		Example[{Basic, "Return a list of invalid input samples that are discarded and a list of failing and passing discarded sample tests:"},
			checkDiscardedSamples[
				Download[
					{
						Object[Sample, "Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID]
					}
				],
				False
			],
			{{ObjectP[Object[Sample]]...}, {TestP..}}
		],
		(* input a list of samples where no samples are discarded (no invalid discarded samples) and messages->True, should return an empty list and no message *)
		Example[{Basic, "Return an empty list and no error message if there are no discarded samples:"},
			checkDiscardedSamples[
				Download[
					{
						Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID]
					}
				],
				True
			],
			{{}, Null}
		],
		(* input a list of samples where no samples are discarded (no invalid discarded samples) and messages->False, should return an empty list and the passing tests, and no message *)
		Example[{Basic, "Return an empty list and a list of passing solid media tests if there are no samples in solid media:"},
			checkDiscardedSamples[
				Download[
					{
						Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID]
					}
				],
				False
			],
			{{}, {TestP..}}
		]

	},

	SymbolSetUp :> (
		Module[{existsFilter, plate0, sample0, sample1, sample2, sample3},
			$CreatedObjects = {};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			Off[Warning::DeprecatedProduct];

			existsFilter = DatabaseMemberQ[{
				Object[Sample, "Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkDiscardedSamples "<>$SessionUUID]

			}];

			EraseObject[
				PickList[
					{
						Object[Sample, "Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID],
						Object[Container, Plate, "Test 96-well plate 0 for checkDiscardedSamples "<>$SessionUUID]
					},
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			plate0 = Upload[
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-well plate 0 for checkDiscardedSamples "<>$SessionUUID,
					DeveloperObject -> True
				|>
			];

			{sample0, sample1, sample2, sample3} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}}
				},
				{
					{"A1", plate0},
					{"A2", plate0},
					{"A3", plate0},
					{"A4", plate0}
				},
				Name -> {
					"Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID,
					"Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID,
					"Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID,
					"Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Microbial,
					Microbial,
					Microbial,
					Microbial
				},
				CultureAdhesion -> {
					Suspension,
					Suspension,
					Suspension,
					Suspension
				},
				Living -> {
					True,
					True,
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];

			Upload[<|Object -> #, Status -> Discarded, DeveloperObject -> True|>& /@ {sample0, sample1}];

			Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample2, sample3}];
		]
	),

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[Flatten[{
				Object[Sample, "Discarded bacteria cell sample 0 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Discarded bacteria cell sample 1 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Available bacteria cell sample 2 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Sample, "Available bacteria cell sample 3 (Test for checkDiscardedSamples) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkDiscardedSamples "<>$SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	)
];

(* ::Subsection::Closed:: *)
(*checkDeprecatedSampleModels*)
(*TODO this needs to be changed to have test sample models that are deprecated. also need to add documentation*)
(*
DefineTests[checkDeprecatedSampleModels,
	{
		(* input a list of samples where some are deprecated and others arent and messages->True, should return the list of deprecated samples and the error *)
		Example[{Basic, "Return a list of invalid input samples with deprecated models and an error message:"},
			checkDeprecatedSampleModels[
				Download[
					{
						Object[Sample, "Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID]
					}
				],
				True
			],
			{{ObjectP[Object[Sample]]...}, Null},
			Messages :> {Error::DeprecatedModels}
		],
		(* input a list of samples where some are deprecated and others arent and messages->False, should return the list of deprecated samples and the passing and failing tests, and no message *)
		Example[{Basic, "Return a list of invalid input samples with deprecated models and a list of failing and passing deprecated sample tests:"},
			checkDeprecatedSampleModels[
				Download[
					{
						Object[Sample, "Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID]
					}
				],
				False
			],
			{{ObjectP[Object[Sample]]...}, {TestP..}}
		],
		(* input a list of samples where no samples are deprecated (no invalid deprecated samples) and messages->True, should return an empty list and no message *)
		Example[{Basic, "Return an empty list and no error message if there are no deprecated samples:"},
			checkDeprecatedSampleModels[
				Download[
					{
						Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID]
					}
				],
				True
			],
			{{}, Null}
		],
		(* input a list of samples where no samples are deprecated (no invalid deprecated samples) and messages->False, should return an empty list and the passing tests, and no message *)
		Example[{Basic, "Return an empty list and a list of passing deprecated sample model tests if there are no deprecated samples:"},
			checkDeprecatedSampleModels[
				Download[
					{
						Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID]
					}
				],
				False
			],
			{{}, {TestP..}}
		]

	},

	SymbolSetUp :> (
		Module[{existsFilter, plate0, sample0, sample1, sample2, sample3},
			$CreatedObjects = {};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			Off[Warning::DeprecatedProduct];

			existsFilter = DatabaseMemberQ[{
				Object[Sample, "Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkDeprecatedSampleModels "<>$SessionUUID]

			}];

			EraseObject[
				PickList[
					{
						Object[Sample, "Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
						Object[Container, Plate, "Test 96-well plate 0 for checkDeprecatedSampleModels "<>$SessionUUID]

					},
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];

			plate0 = Upload[
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-well plate 0 for checkDiscardedSamples "<>$SessionUUID,
					DeveloperObject -> True
				|>
			];

			{sample0, sample1, sample2, sample3} = UploadSample[
				{
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					{{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}}
				},
				{
					{"A1", plate0},
					{"A2", plate0},
					{"A3", plate0},
					{"A4", plate0}
				},
				Name -> {
					"Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID,
					"Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID,
					"non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID,
					"non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID
				},
				InitialAmount -> {
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter,
					0.5 Milliliter
				},
				CellType -> {
					Microbial,
					Microbial,
					Microbial,
					Microbial
				},
				CultureAdhesion -> {
					Suspension,
					Suspension,
					Suspension,
					Suspension
				},
				Living -> {
					True,
					True,
					True,
					True
				},
				State -> Liquid,
				FastTrack -> True
			];

			Upload[<|Object -> #, Status -> Discarded, DeveloperObject -> True|>& /@ {sample0, sample1}];

			Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample2, sample3}];
		]
	),

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[Flatten[{
				Object[Sample, "Deprecated bacteria cell sample 0 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "Deprecated bacteria cell sample 1 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "non-Deprecated bacteria cell sample 2 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Sample, "non-Deprecated bacteria cell sample 3 (Test for checkDeprecatedSampleModels) "<>$SessionUUID],
				Object[Container, Plate, "Test 96-well plate 0 for checkDeprecatedSampleModels "<>$SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	)
];
*)