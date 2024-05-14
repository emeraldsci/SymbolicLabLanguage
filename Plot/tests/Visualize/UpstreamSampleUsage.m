(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*UpstreamSampleUsage*)


DefineTests[UpstreamSampleUsage,
	{
		Example[{Basic,"Creates a graph to visualize the usage of a parent sample in the generation of downstream samples:"},
			UpstreamSampleUsage[
				Object[Sample, "Sample 9 for UpstreamSampleUsage tests "<>$SessionUUID]
			],
			_Graph
		],

		(* both graph formats *)
		Example[{Options,GraphLayout,"Use the GraphLayout option to display the graph in a radial or layered form:"},
			{
				UpstreamSampleUsage[
					Object[Sample, "Sample 9 for UpstreamSampleUsage tests "<>$SessionUUID],
					GraphLayout -> "RadialDrawing"
				],
				UpstreamSampleUsage[
					Object[Sample, "Sample 9 for UpstreamSampleUsage tests "<>$SessionUUID],
					GraphLayout -> "LayeredEmbedding"
				]
			},
			{_Graph, _Graph}
		],

		(* all output forms *)
		Example[{Options,Output,"Output -> List returns a list of all samples into which the parent sample was transferred either directly or indirectly:"},
			UpstreamSampleUsage[
				Object[Sample, "Sample 14 for UpstreamSampleUsage tests "<>$SessionUUID],
				Output -> List
			],
			_List
		],
		Example[{Options,Output,"Output -> Graph returns a graphic showing the network of all samples into which the parent sample was transferred either directly or indirectly:"},
			UpstreamSampleUsage[
				Object[Sample, "Sample 14 for UpstreamSampleUsage tests "<>$SessionUUID],
				Output -> Graph
			],
			_Graph
		],
		Example[{Options,Output,"Output -> Association returns associations indicating the sample transfers:"},
			UpstreamSampleUsage[
				Object[Sample, "Sample 14 for UpstreamSampleUsage tests "<>$SessionUUID],
				Output -> Association
			],
			{_Rule..}
		],
		Example[{Messages,"NoTransfersOut","If a sample has not been transferred out of, a warning is shown:"},
			UpstreamSampleUsage[
				Object[Sample, "Sample 20 for UpstreamSampleUsage tests "<>$SessionUUID]
			],
			Null,
			Messages:>{UpstreamSampleUsage::NoTransfersOut}
		]
	},

	SymbolSetUp :> (
		(*generic teardown*)
		Module[{objs, existingObjs},
			objs = Quiet[
				Cases[
					Flatten[{
						Object[Container, Bench, "Fake bench for UpstreamSampleUsage tests"],
						Table[Object[Container, Vessel, StringJoin["Container ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID]], {x, 1,20}],
						Table[Object[Sample, StringJoin["Sample ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID]], {x, 1,20}]
					}],
					ObjectP[]
				]
			];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		(* set up sample graph *)
		Module[
			{
				fakeBench, containers, sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				sample8, sample9, sample10, sample11, sample12, sample13, sample14,
				sample15, sample16, sample17, sample18, sample19, sample20, transferTuples
			},
			(* set up fake bench as a location for the vessel *)
			fakeBench = Upload[
				<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for UpstreamSampleUsage tests", DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>
			];

			(* create containers *)
			containers = ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Container, Vessel, "id:bq9LA0dBGGR6"], 20],
				ConstantArray[{"Bench Top Slot",fakeBench}, 20],
				Name -> Table[
					StringJoin["Container ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID],
					{x, 1,20}
				]
			];

			(* put samples into containers - start with a reasonable initial volume *)
			{
				sample1, sample2, sample3, sample4, sample5, sample6, sample7,
				sample8, sample9, sample10, sample11, sample12, sample13, sample14,
				sample15, sample16, sample17, sample18, sample19, sample20
			} = ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample, "Milli-Q water"], 20],
				Map[{"A1",#}&, containers],
				InitialAmount -> 10 Milliliter,
				Name -> Table[StringJoin["Sample ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID], {x, 1,20}]
			];

			(* make everything a dev object *)
			Upload[
				Map[
					Association[Object -> #, DeveloperObject -> True]&,
					Cases[Flatten[{sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20, containers}], ObjectP[]]
				]
			];

			(*organize transfers in a way that is readable*)
			transferTuples = {
				(*an consolidate from  1-5 to 6*)
				{sample1, sample2, 10 Microliter},
				{sample2, sample6, 10 Microliter},
				{sample3, sample6, 10 Microliter},
				{sample4, sample6, 10 Microliter},
				{sample5, sample6, 10 Microliter},

				(*an aliquot from 6 to 7-9*)
				{sample6, sample7, 10 Microliter},
				{sample7, sample8, 10 Microliter},
				{sample8, sample9, 10 Microliter},

				(* a long chain of transfers from 9 through 15 *)
				{sample9, sample10, 10 Microliter},
				{sample10, sample11, 10 Microliter},
				{sample11, sample12, 10 Microliter},
				{sample12, sample13, 10 Microliter},
				{sample13, sample14, 10 Microliter},

				(* consolidation - this is just because I am lazy and want to reuse this as a template *)
				{sample16, sample15, 10 Microliter},
				{sample17, sample15, 10 Microliter},
				{sample18, sample15, 10 Microliter},
				{sample19, sample15, 10 Microliter}
			};

			(*upload the transfers so that we catch any framework changes*)
			ECL`InternalUpload`UploadSampleTransfer[
				Sequence@@Transpose[transferTuples],
				FastTrack -> True
			];

		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Fake bench for UpstreamSampleUsage tests"],
					Table[Object[Container, Vessel, StringJoin["Container ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID]], {x, 1,20}],
					Table[Object[Sample, StringJoin["Sample ",ToString[x]," for UpstreamSampleUsage tests ", $SessionUUID]], {x, 1,20}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

