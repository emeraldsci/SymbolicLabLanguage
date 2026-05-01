(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*Simulation*)

DefineTests[
	Simulation,
	{
		Example[{Basic, "Simulation[] will make a blank simulation:"},
			Simulation[],
			ECL`Simulation[Association[ECL`Packets -> {}, ECL`Labels -> {}, ECL`LabelFields -> {}, ECL`SimulatedObjects -> {}, ECL`Updated -> True, ECL`NativeSimulationID -> None]]
		],
		Example[{Basic, "Simulation[myChangePacket] will make a simulation with that change packet:"},
			Simulation[<|Object -> ECL`SimulateCreateID[Object[Sample]], Name -> "best sample ever"|>],
			ECL`Simulation[Association[ECL`Packets -> {KeyValuePattern[Name -> "best sample ever"]}, ECL`Labels -> {}, ECL`LabelFields -> {}, ECL`SimulatedObjects -> {}, ECL`Updated -> False, ECL`NativeSimulationID -> None]]
		],
		Example[{Basic, "Simulation[myChangePackets] will make a simulation with those change packets:"},
			Simulation[{
				<|Object -> ECL`SimulateCreateID[Object[Sample]], Name -> "best sample ever"|>,
				<|Object -> ECL`SimulateCreateID[Object[User]], Name -> "best user ever"|>
			}],
			ECL`Simulation[Association[ECL`Packets -> {KeyValuePattern[Name -> "best sample ever"], KeyValuePattern[Name -> "best user ever"]}, ECL`Labels -> {}, ECL`LabelFields -> {}, ECL`SimulatedObjects -> {}, ECL`Updated -> False, ECL`NativeSimulationID -> None]]
		],
		Example[{Basic, "Simulation[myRules] will make a simulation that includes those packets and rules:"},
			Simulation[
				Packets -> {
					<|Object -> ECL`SimulateCreateID[Object[Sample]], Name -> "best sample ever"|>,
					<|Object -> ECL`SimulateCreateID[Object[User]], Name -> "best user ever"|>
				},
				Labels -> {
					"label" -> ECL`SimulateCreateID[Object[Sample]]
				},
				ECL`LabelFields -> {}
			],
			ECL`Simulation[Association[
				ECL`Packets -> {KeyValuePattern[Name -> "best sample ever"], KeyValuePattern[Name -> "best user ever"]},
				ECL`Labels -> {"label" -> ObjectP[Object[Sample]]},
				ECL`LabelFields -> {},
				ECL`SimulatedObjects -> {},
				ECL`Updated -> False,
				ECL`NativeSimulationID -> None
			]]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*EnterSimulation*)

DefineTests[
	EnterSimulation,
	{
		Example[{Basic, "UpdateSimulation is automatically called under the hood when we're in a global simulation:"},
			Module[
				{newContainerObjects, newContainer1, newContainer2, newRuler, newSampleObjects, sample1, sample2, simulatedSampleStatuses},

				EnterSimulation[];

				newContainerObjects=ECL`InternalUpload`UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Item, Ruler, "Calibration Ruler"]
					},
					{
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}
					}
				];

				newContainer1=newContainerObjects[[1]];
				newContainer2=newContainerObjects[[2]];
				newRuler=newContainerObjects[[3]];

				newSampleObjects=ECL`InternalUpload`UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", newContainer1},
						{"A1", newContainer2}
					}
				];

				sample1=newSampleObjects[[1]];
				sample2=newSampleObjects[[2]];

				UploadSampleStatus[{sample1, sample2}, Available];

				simulatedSampleStatuses=Download[{sample1, sample2}, Status];

				ExitSimulation[];

				{
					simulatedSampleStatuses,
					DatabaseMemberQ[{sample1, sample2}]
				}
			],
			{
				{Available, Available},
				{False, False}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExitSimulation*)

DefineTests[
	ExitSimulation,
	{
		Example[{Basic, "UpdateSimulation is automatically called under the hood when we're in a global simulation:"},
			Module[
				{newContainerObjects, newContainer1, newContainer2, newRuler, newSampleObjects, sample1, sample2, simulatedSampleStatuses},

				EnterSimulation[];

				newContainerObjects=ECL`InternalUpload`UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Item, Ruler, "Calibration Ruler"]
					},
					{
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}
					}
				];

				newContainer1=newContainerObjects[[1]];
				newContainer2=newContainerObjects[[2]];
				newRuler=newContainerObjects[[3]];

				newSampleObjects=ECL`InternalUpload`UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", newContainer1},
						{"A1", newContainer2}
					}
				];

				sample1=newSampleObjects[[1]];
				sample2=newSampleObjects[[2]];

				UploadSampleStatus[{sample1, sample2}, Available];

				simulatedSampleStatuses=Download[{sample1, sample2}, Status];

				ExitSimulation[];

				{
					simulatedSampleStatuses,
					DatabaseMemberQ[{sample1, sample2}]
				}
			],
			{
				{Available, Available},
				{False, False}
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*StartUniqueLabelsSession*)

DefineTests[
	StartUniqueLabelsSession,
	{
		Example[{Basic, "StartUniqueLabelsSession[] stashes any existing unique label information and starts a new session:"},
			Module[{},
				CreateUniqueLabel["best label ever"];

				StartUniqueLabelsSession[];

				CreateUniqueLabel["best label ever"]
			],
			"best label ever 1"
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*EndUniqueLabelsSession*)

DefineTests[
	EndUniqueLabelsSession,
	{
		Example[{Basic, "EndUniqueLabelsSession[] will unstash any existing label information:"},
			Module[{},
				CreateUniqueLabel["best label ever"];

				StartUniqueLabelsSession[];

				CreateUniqueLabel["best label ever"];

				EndUniqueLabelsSession[];

				CreateUniqueLabel["best label ever"]
			],
			"best label ever 2"
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*CreateUniqueLabel*)

DefineTests[
	CreateUniqueLabel,
	{
		Example[{Basic, "CreateUniqueLabel[] will create a unique label by appending a number to the base label:"},
			CreateUniqueLabel["best label ever"],
			_String
		],
		Example[{Basic, "CreateUniqudLabel[] will increment the label's number if the base label has been used during the same evaluation:"},
			{
				CreateUniqueLabel["best label ever"],
				CreateUniqueLabel["best label ever"],
				CreateUniqueLabel["best label ever"]
			},
			{
				_String,
				_String,
				_String
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*UpdateSimulation*)

DefineTests[
	UpdateSimulation,
	{
		Example[{Basic, "UpdateSimulation will merge in change packets into an empty simulation:"},
			UpdateSimulation[
				Simulation[],
				Simulation@ECL`InternalUpload`UploadSample[
					{Model[Container, Vessel, "50mL Tube"]},
					{{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}},
					Upload -> False
				]
			],
			SimulationP
		],
		(* NOTE: UploadSample calls UploadLocation which updates locations via automatic backlink creation. *)
		Example[{Basic, "UpdateSimulation will also create backlinks:"},
			Module[{uploadPackets, containerObject},
				uploadPackets = ECL`InternalUpload`UploadSample[
					{Model[Container, Vessel, "50mL Tube"]},
					{{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}},
					Upload -> False
				];

				containerObject = uploadPackets[[1]][Object];

				Download[containerObject, Container, Simulation -> Simulation[uploadPackets]]
			],
			ObjectP[Object[Container, Shelf, "Ambient Storage Shelf"]]
		],
		Example[{Basic, "UpdateSimulation can merge multiple simulations:"},
			Module[
				{newContainerPackets, newContainer1, newContainer2, newRuler, simulation1, newSamplePackets,
					sample1, sample2, simulation2, sampleStatusPackets, simulation3},

				newContainerPackets = ECL`InternalUpload`UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Item, Ruler, "Calibration Ruler"]
					},
					{
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}
					},
					Upload -> False
				];

				newContainer1 = newContainerPackets[[1]][Object];
				newContainer2 = newContainerPackets[[2]][Object];
				newRuler = newContainerPackets[[3]][Object];

				simulation1 = UpdateSimulation[Simulation[], Simulation[newContainerPackets]];

				newSamplePackets = ECL`InternalUpload`UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", newContainer1},
						{"A1", newContainer2}
					},
					Simulation -> simulation1,
					Upload -> False
				];

				sample1 = newSamplePackets[[1]][Object];
				sample2 = newSamplePackets[[2]][Object];

				simulation2 = UpdateSimulation[simulation1, Simulation[newSamplePackets]];

				sampleStatusPackets = ECL`InternalUpload`UploadSampleStatus[{sample1, sample2}, Available, Simulation -> simulation2, Upload -> False];

				simulation3 = UpdateSimulation[simulation2, Simulation[sampleStatusPackets]];

				Download[{sample1, sample2}, Status, Simulation -> simulation3]
			],
			{Available, Available}
		],
		Example[{Basic, "UpdateSimulation is automatically called under the hood when we're in a global simulation:"},
			Module[
				{newContainerObjects, newContainer1, newContainer2, newRuler, newSampleObjects, sample1, sample2, simulatedSampleStatuses},

				EnterSimulation[];

				newContainerObjects = ECL`InternalUpload`UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Item, Ruler, "Calibration Ruler"]
					},
					{
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}
					}
				];

				newContainer1 = newContainerObjects[[1]];
				newContainer2 = newContainerObjects[[2]];
				newRuler = newContainerObjects[[3]];

				newSampleObjects = ECL`InternalUpload`UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", newContainer1},
						{"A1", newContainer2}
					}
				];

				sample1 = newSampleObjects[[1]];
				sample2 = newSampleObjects[[2]];

				UploadSampleStatus[{sample1, sample2}, Available];

				simulatedSampleStatuses = Download[{sample1, sample2}, Status];

				ExitSimulation[];

				{
					simulatedSampleStatuses,
					DatabaseMemberQ[{sample1, sample2}]
				}
			],
			{
				{Available, Available},
				{False, False}
			}
		],
		Example[{Basic, "UpdateSimulation handles existing simulated objects properly if given two simulations (doesn't overwrite fields in the previously simulated object):"},
			Module[{containerID, sample1ID, sample2ID, sample3ID, sample4ID, existingSimulation, newSimulation},
				containerID = SimulateCreateID[Object[Container, Plate]];
				sample1ID = SimulateCreateID[Object[Sample]];
				sample2ID = SimulateCreateID[Object[Sample]];
				sample3ID = SimulateCreateID[Object[Sample]];
				sample4ID = SimulateCreateID[Object[Sample]];

				existingSimulation = Simulation[<|
					Object -> containerID,
					Type -> Object[Container, Plate], ID -> containerID[ID],
					Contents -> {
						{"A1", ECL`Link[sample1ID, ECL`Container, "clientId:link453"]},
						{"B1", ECL`Link[sample2ID, ECL`Container, "clientId:link454"]}
					}|>];

				newSimulation = Simulation[{
					<|Object -> containerID,
						Type -> Object[Container, Plate],
						Append[ContentsLog] -> {{DateObject[{2021, 11, 9, 13, 30,
							44.2146502}, "Instant", "Gregorian", -8.], In, ECL`Link[
							sample3ID, ECL`LocationLog, 3,
							"clientId:link542"], "C1", ECL`Link[
							Null]}}, Append[Contents] -> {{"C1", ECL`Link[
						sample3ID, ECL`Container,
						"clientId:link550"]}}|>, <|Object ->
							containerID,
						Type -> Object[Container, Plate],
						Append[ContentsLog] -> {{DateObject[{2021, 11, 9, 13, 30,
							44.2146502}, "Instant", "Gregorian", -8.], In, ECL`Link[
							sample4ID, ECL`LocationLog, 3,
							"clientId:link543"], "D1", Null}}, Append[Contents] -> {{"D1", ECL`Link[
							sample4ID, ECL`Container,
							"clientId:link551"]}}|>, <|Object ->
							containerID,
						Replace[StorageSchedule] -> {},
						Append[StorageConditionLog] -> {{DateObject[{2021, 11, 9, 13, 30,
							45.2196443}, "Instant", "Gregorian", -8.], ECL`Link[
							ECL`Model[ECL`StorageCondition, "id:7X104vnR18vX"]], Null}}, StorageCondition -> ECL`Link[
							ECL`Model[ECL`StorageCondition, "id:7X104vnR18vX"]],
						AwaitingStorageUpdate -> Null, AwaitingDisposal -> Null|>
				}];

				Length@Download[
					containerID,
					Contents,
					Simulation -> UpdateSimulation[existingSimulation, newSimulation]
				]
			],
			4
		],
		Test["UpdateSimulation will properly put prepends at the beginning:",
			Module[{initialID, initialPacket, initialSimulation, prependPacket, prependSimulation, updatedSimulation},
				initialID = SimulateCreateID[Model[Sample]];
				initialPacket = <|
					Object -> initialID,
					Composition -> {
						{50 VolumePercent, Model[Molecule, "Water"]},
						{40 VolumePercent, Model[Molecule, "Methanol"]},
						{9 VolumePercent, Model[Molecule, "Acetone"]}
					}
				|>;
				initialSimulation = Simulation[initialPacket];
				prependPacket = <|
					Object -> initialID,
					Prepend[Composition] -> {
						{1 VolumePercent, Model[Molecule, "Acetonitrile"]}
					}
				|>;
				prependSimulation = Simulation[prependPacket];

				updatedSimulation = UpdateSimulation[initialSimulation, prependSimulation];
				Download[initialID, Composition, Simulation -> updatedSimulation]
			],
			{
				{1 VolumePercent, Model[Molecule, "id:6V0npvmlWlvV"]}, (*Model[Molecule, "Acetonitrile"]*)
				{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}, (*Model[Molecule, "Water"]*)
				{40 VolumePercent, Model[Molecule, "id:M8n3rx0676xR"]}, (*Model[Molecule, "Methanol"]*)
				{9 VolumePercent, Model[Molecule, "id:xRO9n3BPmP3q"]} (*Model[Molecule, "Acetone"]*)
			}
		],
		Test["UpdateSimulation will not include past values for the ContentsLog or StatusLog of a given container or instrument:",
			Module[{beforeStatusLog, beforeContentsLog, newLinkID, statusLogPacket, contentsPackets, newLinkID2,
				newSimulation, afterStatusLog, afterContentsLog, beforeLocationLog, afterLocationLog},
				{beforeStatusLog, beforeContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}];
				beforeLocationLog = Download[Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID], LocationLog];
				{newLinkID, newLinkID2} = CreateLinkID[2];
				statusLogPacket = <|
					Object -> Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID],
					Append[StatusLog] -> {{Now, InUse, Link[$PersonID]}}
				|>;
				contentsPackets = {
					<|
						Object -> Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID],
						Append[Contents] -> {{"A2", Link[Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID], Container]}},
						Append[ContentsLog] -> {{Now, In, Link[Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID], LocationLog, 3, newLinkID], "A2", Link[$PersonID]}}
					|>,
					<|
						Object -> Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID],
						Append[LocationLog] -> {
							{Now, Out, Link[Object[Container, Bench, "Test bench 1 for UpdateSimulation unit tests" <> $SessionUUID], ContentsLog, 3, newLinkID2], "Work Surface", Link[$PersonID]},
							{Now, In, Link[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], ContentsLog, 3, newLinkID], "A2", Link[$PersonID]}
						}
					|>,
					<|
						Object -> Object[Container, Bench, "Test bench 1 for UpdateSimulation unit tests" <> $SessionUUID],
						Append[ContentsLog] -> {
							{Now, Out, Link[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], LocationLog, 3, newLinkID2], "Work Surface", Link[$PersonID]}
						}
					|>
				};
				newSimulation = UpdateSimulation[Simulation[], Simulation[Flatten[{statusLogPacket, contentsPackets}]]];

				{afterStatusLog, afterContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}, Simulation -> newSimulation];
				afterLocationLog = Download[Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID], LocationLog, Simulation -> newSimulation];
				{
					beforeStatusLog,
					afterStatusLog,
					beforeContentsLog,
					afterContentsLog,
					beforeLocationLog,
					afterLocationLog
				}
			],
			{
				(* before status log has the old values *)
				{
					{_?DateObjectQ, Available, ObjectP[]},
					{_?DateObjectQ, InUse, ObjectP[]},
					{_?DateObjectQ, Available, ObjectP[]}
				},
				(* after status log has none of the values *)
				{},
				(* before contents log has the old values *)
				{
					{_?DateObjectQ, In, ObjectP[], "A1", ObjectP[]}
				},
				(* after contents log only has none of the values *)
				{},
				(* before location log has the old values, but after one has them too in addition to the new ones; this is deliberate because we need the LocationLog in simulation land for the MoveBack task *)
				{
					{_?DateObjectQ, In, ObjectP[], "Work Surface", ObjectP[]}
				},
				{
					{_?DateObjectQ, In, ObjectP[], "Work Surface", ObjectP[]},
					{_?DateObjectQ, Out, ObjectP[], "Work Surface", ObjectP[]},
					{_?DateObjectQ, In, ObjectP[], "A2", ObjectP[]}
				}
			}
		],
		Test["UpdateSimulation will drop the StatusLog/ContentsLog of containers and instruments if they're included in the simulation but not change values:",
			Module[{beforeStatusLog, beforeContentsLog,
				newSimulation, afterStatusLog, afterContentsLog},
				{beforeStatusLog, beforeContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}];

				newSimulation = UpdateSimulation[Simulation[], Simulation[Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID]]]];

				{afterStatusLog, afterContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}, Simulation -> newSimulation];
				{
					beforeStatusLog,
					afterStatusLog,
					beforeContentsLog,
					afterContentsLog
				}
			],
			{
				(* before status log has the old values *)
				{
					{_?DateObjectQ, Available, ObjectP[]},
					{_?DateObjectQ, InUse, ObjectP[]},
					{_?DateObjectQ, Available, ObjectP[]}
				},
				(* after status log has {} *)
				{},
				(* before contents log has the old values *)
				{
					{_?DateObjectQ, In, ObjectP[], "A1", ObjectP[]}
				},
				(* after contents log has {}*)
				{}
			}
		],
		Test["UpdateSimulation will drop the StatusLog/ContentsLog of containers and instruments if they're included in the original simulation (even if we're not updating something else, because we want to get rid of it):",
			Module[{beforeStatusLog, beforeContentsLog,
				newSimulation, afterStatusLog, afterContentsLog},
				{beforeStatusLog, beforeContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}];

				newSimulation = UpdateSimulation[Simulation[Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID]]], Simulation[]];

				{afterStatusLog, afterContentsLog} = Download[Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID], {StatusLog, ContentsLog}, Simulation -> newSimulation];
				{
					beforeStatusLog,
					afterStatusLog,
					beforeContentsLog,
					afterContentsLog
				}
			],
			{
				(* before status log has the old values *)
				{
					{_?DateObjectQ, Available, ObjectP[]},
					{_?DateObjectQ, InUse, ObjectP[]},
					{_?DateObjectQ, Available, ObjectP[]}
				},
				(* after status log has {} *)
				{},
				(* before contents log has the old values *)
				{
					{_?DateObjectQ, In, ObjectP[], "A1", ObjectP[]}
				},
				(* after contents log has {}*)
				{}
			}
		],
		Test["If a named multiple field has unevaluated stuff in it, this gets evaluated/resolved before adding to the simulation:",
			Module[{imageSamplePacket, updatedSimulation},
				imageSamplePacket = <|
					Object -> CreateID[Object[Protocol, ImageSample]],
					Replace[BatchedImagingParameters] -> {
						<|
							Imager -> Link[Object[Instrument, SampleImager, "id:R8e1Pjp4DD7p"], "lkjlkjlkjlkjklj"],
							ImageContainer -> False,
							ImagingDirection -> {Side},
							IlluminationDirection -> {Side},
							SecondaryRack -> Null,
							ImageFilePrefix -> "mnk9j_okaz0al_sampleimager",
							BatchNumber -> 1,
							Wells -> Null,
							PlateMethodFileName -> Null,
							RunTime -> Null,
							FieldOfView -> Null,
							ImagingDistance -> 38.5 Centimeter,
							Pedestals -> SmallAndLarge,
							ExposureTime -> 33 Millisecond,
							FocalLength -> 55 Millimeter,
							Backdrop -> Null
						|>
					}
				|> /. {link_Link:>RemoveLinkID[link]};
				updatedSimulation = UpdateSimulation[Simulation[], Simulation[imageSamplePacket]];
				Lookup[Lookup[First[updatedSimulation], Packets][[1]], BatchedImagingParameters]
			],
			{ <|
				Imager -> Link[Object[Instrument, SampleImager, "id:R8e1Pjp4DD7p"]],
				ImageContainer -> False,
				ImagingDirection -> {Side},
				IlluminationDirection -> {Side},
				SecondaryRack -> Null,
				ImageFilePrefix -> "mnk9j_okaz0al_sampleimager",
				BatchNumber -> 1,
				Wells -> Null,
				PlateMethodFileName -> Null,
				RunTime -> Null,
				FieldOfView -> Null,
				ImagingDistance -> 38.5 Centimeter,
				Pedestals -> SmallAndLarge,
				ExposureTime -> 33 Millisecond,
				FocalLength -> 55 Millimeter,
				Backdrop -> Null
			|>
			}
		],
		Test["Replace[MultipleField] -> singletonValue makes the simulation actually have {singletonValue} like real Upload:",
			Module[{testID, testSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				testSimulation = Simulation[<|Object -> testID, Replace[WorkingSourceWell] -> "A1"|>];
				updatedSimulation = UpdateSimulation[Simulation[], testSimulation];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A1"}
		],
		Test["Update Simulation can keep track of multiple simulations:",
			Module[{testObject, currentSimulationFirstRead, branchedSimulation,branchedSimulationFirstRead,currentSimulationSecondRead,branchedSimulationSecondRead,branchedSimulationThirdRead,currentSimulationThirdRead},
				testObject = SimulateCreateID[Object[Example, Data]];
				ExitSimulation[];
				EnterSimulation[];
				$CurrentSimulation = UpdateSimulation[Simulation[], Simulation[Packets->{<|Object->testObject,Number->1|>}]];
				If[!MatchQ[Lookup[$CurrentSimulation[[1]],NativeSimulationID],_String],Message["NativeSimulationID is not populated"]];
				currentSimulationFirstRead = Download[testObject,Number];
				branchedSimulation = UpdateSimulation[$CurrentSimulation, Simulation[Packets->{<|Object->testObject,Number->2|>}]];
				If[!MatchQ[Lookup[branchedSimulation[[1]],NativeSimulationID],_String],Message["NativeSimulationID is not populated"]];
				branchedSimulationFirstRead = Download[testObject,Number,Simulation->branchedSimulation];
				currentSimulationSecondRead = Download[testObject,Number];
				branchedSimulationSecondRead = Download[testObject,Number,Simulation->branchedSimulation];
				$CurrentSimulation = UpdateSimulation[$CurrentSimulation, Simulation[Packets->{<|Object->testObject,Number->3|>}]];
				If[!MatchQ[Lookup[$CurrentSimulation[[1]],NativeSimulationID],_String],Message["NativeSimulationID is not populated"]];
				branchedSimulationThirdRead = Download[testObject,Number,Simulation->branchedSimulation];
				currentSimulationThirdRead = Download[testObject,Number];
				ExitSimulation[];
				{currentSimulationFirstRead,branchedSimulationFirstRead,currentSimulationSecondRead,branchedSimulationSecondRead,branchedSimulationThirdRead,currentSimulationThirdRead}
			],
			{1,2,1,2,2,3}
		],
		Test["Replace[SingleField] -> singletonValue doesn't add a list just like real Upload:",
			Module[{testID, testSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				testSimulation = Simulation[<|Object -> testID, Replace[DisplayedAmount] -> "1 Gram"|>];
				updatedSimulation = UpdateSimulation[Simulation[], testSimulation];
				Download[testID, DisplayedAmount, Simulation -> updatedSimulation]
			],
			"1 Gram"
		],
		Test["Replace[MultipleField] -> Null gives you {}, NOT {Null}, just like real Upload:", (* for better or for worse, this is what Upload does and UpdateSimulation needs to replicate it *)
			Module[{testID, testSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				testSimulation = Simulation[<|Object -> testID, Replace[WorkingSourceWell] -> Null|>];
				updatedSimulation = UpdateSimulation[Simulation[], testSimulation];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{}
		],
		Test["Replace[IndexedMultipleField] -> list adds the extra list if it is a list that is a singleton entry:",
			Module[{testID, testSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[Protocol, Transfer]];
				testSimulation = Simulation[<|Object -> testID, Replace[StatusLog] -> {Now, Available, Null}|>];
				updatedSimulation = UpdateSimulation[Simulation[], testSimulation];
				Download[testID, StatusLog, Simulation -> updatedSimulation]
			],
			{{_?DateObjectQ, Available, Null}}
		],
		Test["Replace[MultipleField] paired with a matching backlink from the linked object does not cause a duplicate entry in the multiple field:",
			Module[{protocolID, unitOperationID, simulation},
				protocolID = SimulateCreateID[Object[Protocol, Transfer]];
				unitOperationID = SimulateCreateID[Object[UnitOperation, Transfer]];

				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {
						<|Type -> Object[Protocol, Transfer], Object -> protocolID, Replace[BatchedUnitOperations] -> {Link[unitOperationID, Protocol]}|>,
						<|Type -> Object[UnitOperation, Transfer], Object -> unitOperationID, Protocol -> Link[protocolID, BatchedUnitOperations]|>
					}]
				];

				Length[Download[protocolID, BatchedUnitOperations, Simulation -> simulation]]
			],
			1
		],
		Test["If doing Append[NamedMultipleField] -> <|...|>, don't throw an error and get confused:",
			Module[{testID, testSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[Maintenance,AlignLiquidHandlerDevicePrecision]];
				testSimulation = Simulation[<|Object -> testID, Append[ChannelAdjustmentsLog] -> <|Channel -> 1, TranslationDirection -> Left, TranslationRotation -> 365, TiltDirection -> Null, TiltRotation -> Null|>|>];
				updatedSimulation = UpdateSimulation[Simulation[], testSimulation];
				Download[testID, ChannelAdjustmentsLog, Simulation -> updatedSimulation]
			],
			{<|Channel -> 1, TranslationDirection -> Left, TranslationRotation -> 365, TiltDirection -> Null, TiltRotation -> Null|>}
		],
		Test["Replace[MultipleField] paired with a matching backlink from the linked object does not cause a duplicate entry in the multiple field:",
			Module[{protocolID, unitOperationID, simulation},
				protocolID = SimulateCreateID[Object[Protocol, Transfer]];
				unitOperationID = SimulateCreateID[Object[UnitOperation, Transfer]];

				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {
						<|Type -> Object[Protocol, Transfer], Object -> protocolID, Replace[BatchedUnitOperations] -> {Link[unitOperationID, Protocol]}|>,
						<|Type -> Object[UnitOperation, Transfer], Object -> unitOperationID, Protocol -> Link[protocolID, BatchedUnitOperations]|>
					}]
				];

				Length[Download[protocolID, BatchedUnitOperations, Simulation -> simulation]]
			],
			1
		],
		Test["Erase[MultipleField] -> rowIndex deletes the entry at that row:",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = Simulation[<|Object -> testID, WorkingSourceWell -> {"A1", "A2", "A3"}|>];

				updatedSimulation = UpdateSimulation[initialSimulation, Simulation[<|Object -> testID, Erase[WorkingSourceWell] -> 2|>]];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A1", "A3"}
		],
		Test["Erase[MultipleField] -> {{row1}, {row2}} deletes multiple rows at once:",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = Simulation[<|Object -> testID, WorkingSourceWell -> {"A1", "A2", "A3"}|>];

				updatedSimulation = UpdateSimulation[initialSimulation, Simulation[<|Object -> testID, Erase[WorkingSourceWell] -> {{1}, {3}}|>]];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A2"}
		],
		Test["EraseCases[MultipleField] -> value removes all entries matching the value:",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = Simulation[<|Object -> testID, WorkingSourceWell -> {"A1", "A2", "A1"}|>];

				updatedSimulation = UpdateSimulation[initialSimulation, Simulation[<|Object -> testID, EraseCases[WorkingSourceWell] -> "A1"|>]];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A2"}
		],
		Test["A change packet with only a Type key (no Object key) gets a SimulateCreateID-based Object assigned automatically:",
			Module[{simulation},
				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {<|Type -> Object[UnitOperation, Transfer]|>}]
				];

				SimulatedObjectQ[Lookup[First[Lookup[First[simulation], Packets]], Object]]
			],
			True
		],
		Test["When the same object appears in multiple change packets in newSimulation, the packets are applied in order so the last value wins:",
			Module[{testID, simulation},
				testID = SimulateCreateID[Object[Example, Data]];
				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {
						<|Object -> testID, Type -> Object[Example, Data], Number -> 1|>,
						<|Object -> testID, Number -> 2|>
					}]
				];

				Download[testID, Number, Simulation -> simulation]
			],
			2
		],
		Test["When the same label name exists in both currentSimulation and newSimulation, the newSimulation's object reference wins:",
			Module[{id1, id2, currentSim, newSim, updatedSim},
				id1 = SimulateCreateID[Object[Sample]];
				id2 = SimulateCreateID[Object[Sample]];
				currentSim = Simulation[Packets -> {}, Labels -> {"my sample" -> id1}, LabelFields -> {}];
				newSim = Simulation[Packets -> {}, Labels -> {"my sample" -> id2}, LabelFields -> {}];

				updatedSim = UpdateSimulation[currentSim, newSim];
				Lookup[Lookup[First[updatedSim], Labels], "my sample"] === id2
			],
			True
		],
		Test["Labels from currentSimulation that do not conflict with newSimulation labels are preserved:",
			Module[{id1, id2, currentSim, newSim, updatedSim, labels},
				id1 = SimulateCreateID[Object[Sample]];
				id2 = SimulateCreateID[Object[Sample]];
				currentSim = Simulation[Packets -> {}, Labels -> {"sample one" -> id1}, LabelFields -> {}];
				newSim = Simulation[Packets -> {}, Labels -> {"sample two" -> id2}, LabelFields -> {}];

				updatedSim = UpdateSimulation[currentSim, newSim];
				labels = Lookup[First[updatedSim], Labels];
				{Length[labels], MemberQ[labels[[All, 1]], "sample one"], MemberQ[labels[[All, 1]], "sample two"]}
			],
			{2, True, True}
		],
		Test["LabelFields from currentSimulation and newSimulation are merged, with newSimulation winning on conflict:",
			Module[{currentSim, newSim, updatedSim, labelFields},
				(* LabelFields maps label names to field symbols/strings - not object references *)
				currentSim = Simulation[Packets -> {}, Labels -> {}, LabelFields -> {"lbl" -> Volume, "other" -> Name}];
				newSim = Simulation[Packets -> {}, Labels -> {}, LabelFields -> {"lbl" -> Mass}];

				updatedSim = UpdateSimulation[currentSim, newSim];
				labelFields = Lookup[First[updatedSim], LabelFields];
				(* "lbl" should point to Mass (newSim wins), "other" should be preserved from currentSim *)
				{
					Lookup[labelFields, "lbl"] === Mass,
					MemberQ[labelFields[[All, 1]], "other"]
				}
			],
			{True, True}
		],
		Test["Objects created with SimulateCreateID appear in the SimulatedObjects field of the resulting simulation:",
			Module[{testID, simulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {<|Object -> testID, Type -> Object[UnitOperation, Transfer]|>}]
				];

				MemberQ[Lookup[First[simulation], SimulatedObjects], testID]
			],
			True
		],
		Test["When currentSimulation has Updated->False (change packets not yet applied), it is normalized before merging in newSimulation:",
			Module[{testID, changeSimulation, result},
				testID = SimulateCreateID[Object[Example, Data]];
				(* Simulation[] with a change packet has Updated->False *)
				changeSimulation = Simulation[<|Object -> testID, Type -> Object[Example, Data], Number -> 10|>];

				result = UpdateSimulation[changeSimulation, Simulation[<|Object -> testID, Number -> 20|>]];
				Download[testID, Number, Simulation -> result]
			],
			20
		],
		Test["Append[MultipleField] with a single matching element appends it as one entry (not a list-of-list):",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = Simulation[<|Object -> testID, WorkingSourceWell -> {"A1", "A2"}|>];

				updatedSimulation = UpdateSimulation[initialSimulation, Simulation[<|Object -> testID, Append[WorkingSourceWell] -> "A3"|>]];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A1", "A2", "A3"}
		],
		Test["Append[MultipleField] with a list of elements joins all of them onto the end:",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = Simulation[<|Object -> testID, WorkingSourceWell -> {"A1"}|>];

				updatedSimulation = UpdateSimulation[initialSimulation, Simulation[<|Object -> testID, Append[WorkingSourceWell] -> {"A2", "A3"}|>]];
				Download[testID, WorkingSourceWell, Simulation -> updatedSimulation]
			],
			{"A1", "A2", "A3"}
		],
		Test["Append[MultipleField] on a brand-new simulated object (field not yet set) starts from {} and produces a one-element list:",
			Module[{testID, simulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {<|Object -> testID, Type -> Object[UnitOperation, Transfer], Append[WorkingSourceWell] -> "A1"|>}]
				];

				Download[testID, WorkingSourceWell, Simulation -> simulation]
			],
			{"A1"}
		],
		Test["A newly simulated object has all unspecified single fields defaulted to Null and multiple fields to {}:",
			Module[{testID, simulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {<|Object -> testID, Type -> Object[UnitOperation, Transfer], DisplayedAmount -> "5 mL"|>}]
				];

				(* DisplayedAmount is set; WorkingSourceWell (Multiple) should default to {} *)
				Download[testID, {DisplayedAmount, WorkingSourceWell}, Simulation -> simulation]
			],
			{"5 mL", {}}
		],
		Test["Object references in name form (Object[..., \"name\"]) are resolved to ID form using the current simulation before processing:",
			Module[{testID, initialSimulation, updatedSimulation},
				testID = SimulateCreateID[Object[UnitOperation, Transfer]];
				initialSimulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {<|Object -> testID, Type -> Object[UnitOperation, Transfer], Name -> "my test UO", DisplayedAmount -> "1 mL"|>}]
				];

				updatedSimulation = UpdateSimulation[
					initialSimulation,
					Simulation[Packets -> {<|Object -> Object[UnitOperation, Transfer, "my test UO"], DisplayedAmount -> "2 mL"|>}]
				];
				Download[testID, DisplayedAmount, Simulation -> updatedSimulation]
			],
			"2 mL"
		],
		Test["Replace[MultipleField] paired with a matching backlink and an additional no-op change packet for the same object does not cause a duplicate entry in the multiple field:",
			Module[{protocolID, unitOpID, simulation},
				protocolID = SimulateCreateID[Object[Protocol, Transfer]];
				unitOpID = SimulateCreateID[Object[UnitOperation, Transfer]];

				simulation = UpdateSimulation[
					Simulation[],
					Simulation[Packets -> {
						<|Type -> Object[Protocol, Transfer], Object -> protocolID, Replace[BatchedUnitOperations] -> {Link[unitOpID, Protocol]}|>,
						<|Type -> Object[UnitOperation, Transfer], Object -> unitOpID, Protocol -> Link[protocolID, BatchedUnitOperations]|>,
						<|Object -> protocolID|>
					}]
				];

				Length[Download[protocolID, BatchedUnitOperations, Simulation -> simulation]]
			],
			1
		],
		Test["If updating SampleHistory or TransfersIn for a Waste sample, drop the field because it will likely be way too big:",
			Module[
				{
					testSampleID, testSampleID2, testSampleID3, testSampleID4, transferID1, transferID2, testSimulation,
					updatedSimulation, newPacket
				},
				{testSampleID, testSampleID2, testSampleID3, testSampleID4, transferID1, transferID2} = SimulateCreateID[
					{
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Sample],
						Object[Protocol, Transfer],
						Object[Protocol, Transfer]
					}
				];
				testSimulation = Simulation[<|
					Object -> testSampleID,
					SampleHistory -> {
						Transferred[
							Date -> Now,
							Direction -> In,
							Source -> testSampleID2,
							Destination -> testSampleID,
							Amount -> 1 Milliliter,
							Protocol -> SimulateCreateID[transferID1]
						],
						Transferred[
							Date -> Now,
							Direction -> In,
							Source -> testSampleID3,
							Destination -> testSampleID,
							Amount -> 1 Milliliter,
							Protocol -> SimulateCreateID[transferID1]
						]
					},
					TransfersIn -> {
						{Now, 1 Milliliter, Link[testSampleID2, TransfersOut, 3], Link[transferID1], All},
						{Now, 1 Milliliter, Link[testSampleID3, TransfersOut, 3], Link[transferID1], All}
					},
					WasteType -> Chemical,
					Name -> "test sample name 1 before changing it"
				|>];
				newPacket = <|
					Object -> testSampleID,
					Append[SampleHistory] -> {
						Transferred[
							Date -> Now,
							Direction -> In,
							Source -> testSampleID4,
							Destination -> testSampleID,
							Amount -> 1 Milliliter,
							Protocol -> SimulateCreateID[transferID2]
						]
					},
					Append[TransfersIn] -> {
						{Now, 1 Milliliter, Link[testSampleID4, TransfersOut, 3], Link[transferID2], Partial}
					},
					Name -> "test sample name 1 after changing it"
				|>;
				updatedSimulation = UpdateSimulation[testSimulation, Simulation[newPacket]];
				Download[testSampleID, {SampleHistory, TransfersIn, Name}, Simulation -> updatedSimulation]
			],
			{
				{},
				{},
				"test sample name 1 after changing it"
			}
		]
	},
	SymbolSetUp :> (
		Module[{allObjs, existsFilter},
			allObjs = {
				Object[Container, Bench, "Test bench 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			(* note that I'm using Pick instead of PickList because Pick is in Core and lower in the dependency order than Constellation *)
			EraseObject[Pick[allObjs, existsFilter], Force -> True]
		];
		Module[{testBench, testRack, testContainer1, testContainer2,
			linkID1, linkID2, linkID3},

			{
				testBench,
				testRack,
				testContainer1,
				testContainer2
			} = CreateID[{
				Object[Container, Bench],
				Object[Container, Rack],
				Object[Container, Vessel],
				Object[Container, Vessel]
			}];
			{
				linkID1,
				linkID2,
				linkID3
			} = CreateLinkID[3];
			Upload[{
				<|
					Object -> testBench,
					Type -> Object[Container, Bench],
					Name -> "Test bench 1 for UpdateSimulation unit tests" <> $SessionUUID,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Replace[ContentsLog] -> {
						{Now, In, Link[testRack, LocationLog, 3, linkID1], "Work Surface", Link[$PersonID]},
						{Now, In, Link[testContainer2, LocationLog, 3, linkID2], "Work Surface", Link[$PersonID]}
					},
					Replace[Contents] -> {
						{"Work Surface", Link[testRack, Container]},
						{"Work Surface", Link[testContainer2, Container]}
					},
					Status -> Available
				|>,
				<|
					Object -> testRack,
					Type -> Object[Container, Rack],
					Name -> "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Rack, "50 Slot 2mL Tube Rack"], Objects],
					Replace[ContentsLog] -> {
						{Now, In, Link[testContainer1, LocationLog, 3, linkID3], "A1", Link[$PersonID]}
					},
					Replace[Contents] -> {
						{"A1", Link[testContainer1, Container]}
					},
					Replace[LocationLog] -> {
						{Now, In, Link[testBench, ContentsLog, 3, linkID1], "Work Surface", Link[$PersonID]}
					},
					Status -> Available,
					Replace[StatusLog] -> {
						{Now - 1 Hour, Available, Link[$PersonID]},
						{Now - 30 Minute, InUse, Link[$PersonID]},
						{Now, Available, Link[$PersonID]}
					}
				|>,
				<|
					Object -> testContainer1,
					Type -> Object[Container, Vessel],
					Name -> "Test tube 1 for UpdateSimulation unit tests" <> $SessionUUID,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Replace[LocationLog] -> {
						{Now, In, Link[testRack, ContentsLog, 3, linkID3], "A1", Link[$PersonID]}
					}
				|>,
				<|
					Object -> testContainer2,
					Type -> Object[Container, Vessel],
					Name -> "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Replace[LocationLog] -> {
						{Now, In, Link[testBench, ContentsLog, 3, linkID2], "Work Surface", Link[$PersonID]}
					}
				|>
			}]
		];

	),
	SymbolTearDown :> (
		Module[{allObjs, existsFilter},
			allObjs = {
				Object[Container, Bench, "Test bench 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Rack, "Test rack 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 1 for UpdateSimulation unit tests" <> $SessionUUID],
				Object[Container, Vessel, "Test tube 2 for UpdateSimulation unit tests" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			(* note that I'm using Pick instead of PickList because Pick is in Core and lower in the dependency order than Constellation *)
			EraseObject[Pick[allObjs, existsFilter], Force -> True]
		]
	)

];

(* ::Subsubsection::Closed:: *)
(*LookupObjectLabel*)
DefineTests[
	LookupObjectLabel,
	{
		Example[{Basic, "Given Simulation Packet, LookupObjectLabel can find the label of Sample in that Protocol:"},
			Module[{sample, user, simulationPacket},
				sample = SimulateCreateID[Object[Sample]];
				user = SimulateCreateID[Object[User]];
				simulationPacket = Simulation[
					Packets->{
						Association[Object->sample,Name->"best sample ever"],
						Association[Object->user,Name->"best user ever"]
					},
					Labels->{
						"labelSample"->sample
					},
					LabelFields->{}
				];
				LookupObjectLabel[simulationPacket,sample]
			],
			"labelSample"
		],
		Example[{Basic, "Given Simulation Packet, LookupObjectLabel return Null when Object has no Label:"},
			Module[{sample, user, simulationPacket},
				sample = SimulateCreateID[Object[Sample]];
				user = SimulateCreateID[Object[User]];
				simulationPacket = Simulation[
					Packets->{
						Association[Object->sample,Name->"best sample ever"],
						Association[Object->user,Name->"best user ever"]
					},
					Labels->{
						"labelSample"->sample
					},
					LabelFields->{}
				];
				LookupObjectLabel[simulationPacket,user]
			],
			Null
		],
		Example[{Messages, "Given Simulation Packet, LookupObjectLabel return Null when Simulation Packet has no Object:"},
			Module[{sample, user, simulationPacket},
				sample = SimulateCreateID[Object[Sample]];
				user = SimulateCreateID[Object[User]];
				simulationPacket = Simulation[
					Packets -> Null,
					Labels->{
						"labelSample"->sample
					},
					LabelFields->{}
				];
				LookupObjectLabel[simulationPacket,sample]
			],
			Null,
			Messages :> {Error::InvalidSimulation}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(* SimulatedObjectQ *)

DefineTests[
	SimulatedObjectQ,
	{
		Example[{Basic, "Returns True if the object is a simulated object:"},
			SimulatedObjectQ[SimulateCreateID[Object[Sample]]],
			True
		],
		Example[{Basic, "Returns False if the object is not a simulated object:"},
			SimulatedObjectQ[Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Basic, "Takes a list of objects as an input:"},
			SimulatedObjectQ[{Link[Model[Container, Vessel, "2mL Tube"]], <|Object -> SimulateCreateID[Object[User]]|>}],
			{False, True}
		]
	}
]