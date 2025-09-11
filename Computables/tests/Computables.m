(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Computables: Tests*)


(* ::Section:: *)
(*Unit Tests*)


(* ::Subsection::Closed:: *)
(*analysis*)


(* ::Subsubsection::Closed:: *)
(*derivativeComputable*)


DefineTests[
	derivativeComputable,
	{
		Test[
			"Return a derivative function given a pure function:",
			derivativeComputable[9846.214253504275` - 52.40042854700855` #1&],
			_Function
		]
	}
];


(* ::Subsection::Closed:: *)
(*qualification*)


(* ::Subsubsection::Closed:: *)
(*qualificationFrequency*)


DefineTests[
	qualificationFrequency,
	{
		Test["Null returns Null:",
			qualificationFrequency[Null],
			Null
		],
		Test["A model with a QualificationFrequency informed will output qualification frequency in the proper format (with units):",
			qualificationFrequency[Link[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], Objects, "Vrbp1jKdPZvx"]],
			{{ObjectReferenceP[Model[Qualification]], GreaterP[0 * Day] | Null}..}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*qualificationFrequenciesComputable*)


DefineTests[
	qualificationFrequenciesComputable,
	{
		Test["Null returns Null:",
			qualificationFrequenciesComputable[{}, Null],
			Null
		],
		Test["Return Null if no targets informed:",
			qualificationFrequenciesComputable[{}, Model[Qualification, Autoclave, "id:1ZA60vwjbbOw"]],
			Null
		],
		Test["Return frequencies for a target that match the given modelQualification:",
			qualificationFrequenciesComputable[{Link[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], QualificationFrequency, 1, "J8AY5jDkkDOD"], Link[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], QualificationFrequency, 1, "bq9LA0J1nkWa"], Link[Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], QualificationFrequency, 1, "vXl9j57WV0WN"], Link[Model[Instrument, LiquidHandler, "LegacyID:4"], "Missing[54n6evLrrLdB]"]}, Model[Qualification, LiquidLevelDetection, "id:Z1lqpMGjeeVz"]],
			{{Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], Quantity[8.`, "Days"]}, {Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], Quantity[8.`, "Days"]}, {Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Quantity[8.`, "Days"]} },
			Stubs :> {
				Download[{Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], Model[Instrument, LiquidHandler, "LegacyID:4"]}, {Object, QualificationFrequency}]:={
					{Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"], {{Link[Model[Qualification, PipettingLinearity, "id:dORYzZn0oo8R"], Targets, "M8n3rx0YLKxl"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:eGakld01zzbe"], Targets, "8qZ1VW0rxWAx"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:pZx9jonGJJX0"], Targets, "AEqRl9KkJvzl"], Null}, {Link[Model[Qualification, LiquidLevelDetection, "id:Z1lqpMGjeeVz"], Targets, "Y0lXejMnEk6W"], Quantity[8.`, "Days"]}}},
					{Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], {{Link[Model[Qualification, PipettingLinearity, "id:4pO6dMWvnnLo"], Targets, "D8KAEvG5xZb0"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:Vrbp1jG800nx"], Targets, "O81aEBZ159Pp"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:XnlV5jmbZZd8"], Targets, "zGj91a7AvK9e"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:qdkmxz0A88Ra"], Targets, "1ZA60vLA1BXE"], Null}, {Link[Model[Qualification, LiquidLevelDetection, "id:Z1lqpMGjeeVz"], Targets, "mnk9jORxVGXw"], Quantity[8.`, "Days"]}}},
					{Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], {{Link[Model[Qualification, PipettingLinearity, "id:dORYzZn0oo8R"], Targets, "BYDOjvGeN00q"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:4pO6dMWvnnLo"], Targets, "lYq9jRxmPlX4"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:Vrbp1jG800nx"], Targets, "bq9LA0J9wzde"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:XnlV5jmbZZd8"], Targets, "bq9LA0Jxkaxz"], Null}, {Link[Model[Qualification, PipettingLinearity, "id:qdkmxz0A88Ra"], Targets, "qdkmxzqGKGZ0"], Null}, {Link[Model[Qualification, LiquidLevelDetection, "id:Z1lqpMGjeeVz"], Targets, "AEqRl9KOPKrw"], Quantity[8.`, "Days"]}}},
					{$Failed, $Failed}
				}
			}
		]
	},
	Stubs :> {
		Download[link_Link, Object]:=FirstOrDefault[link],
		Download[x_List, Object]:=Download[#, Object]& /@ x
	}
];


(* ::Subsection::Closed:: *)
(*maintenance*)


(* ::Subsubsection::Closed:: *)
(*maintenanceFrequency*)


DefineTests[
	maintenanceFrequency,
	{
		Test["Null returns Null:",
			maintenanceFrequency[Null],
			Null
		],
		Test["A model with a MaintenanceFrequency informed will output maintenances in the proper format (with units):",
			maintenanceFrequency[Link[Model[Instrument, PeptideSynthesizer, "id:WNa4ZjRr58Wq"], Objects, "4pO6dM5mnNA8"]],
			{{ObjectReferenceP[Model[Maintenance]], GreaterP[0 * Day] | Null}..}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*maintenanceFrequenciesComputable*)


DefineTests[
	maintenanceFrequenciesComputable,
	{
		Test["Null returns Null:",
			maintenanceFrequenciesComputable[{}, Null],
			Null
		],
		Test["Return Null if no targets informed:",
			maintenanceFrequenciesComputable[{}, Model[Maintenance, CalibrateVolume, "id:BYDOjv1VA4PX"]],
			Null
		],
		Test["Return maintenances for a target that match the given modelMaintenance:",
			maintenanceFrequenciesComputable[{Link[Model[Container, FlammableCabinet, "id:XnlV5jmbZZqn"], MaintenanceFrequency, 1, "9RdZXv1GL9oa"], Link[Model[Container, FlammableCabinet, "id:o1k9jAKOwwXx"], MaintenanceFrequency, 1, "XnlV5jKNZz9o"]}, Model[Maintenance, Clean, "id:KBL5DvYl3zNx"]],
			{{Model[Container, FlammableCabinet, "id:XnlV5jmbZZqn"], Quantity[14.`, "Days"]}, {Model[Container, FlammableCabinet, "id:o1k9jAKOwwXx"], Quantity[14.`, "Days"]} },
			Stubs :> {
				Download[{Model[Container, FlammableCabinet, "id:XnlV5jmbZZqn"], Model[Container, FlammableCabinet, "id:o1k9jAKOwwXx"]}, {Object, MaintenanceFrequency}]:={
					{Model[Container, FlammableCabinet, "id:XnlV5jmbZZqn"], {{Link[Model[Maintenance, Clean, "id:KBL5DvYl3zNx"], Targets, "zGj91a7Rda1J"], Quantity[14.`, "Days"]}}},
					{Model[Container, FlammableCabinet, "id:o1k9jAKOwwXx"], {{Link[Model[Maintenance, Clean, "id:KBL5DvYl3zNx"], Targets, "4pO6dM5Nx3rz"], Quantity[14.`, "Days"]}, {Link[Model[Maintenance, Clean, "id:KBL5DvYl3zNx"], Targets, "Vrbp1jKXxMPm"], Quantity[14.`, "Days"]}, {Link[Model[Maintenance, Clean, "id:KBL5DvYl3zNx"], Targets, "KBL5DvwGop17"], Quantity[14.`, "Days"]}}}
				}
			}
		]
	},
	Stubs :> {
		Download[link_Link, Object]:=FirstOrDefault[link],
		Download[x_List, Object]:=Download[#, Object]& /@ x
	}
];


(* ::Subsubsection::Closed:: *)
(*structuresComputable*)


DefineTests[structuresComputable,
	{
		Test["Gets all the structures involved in a nested reaction:",
			structuresComputable[ReactionMechanism[Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]]], List[]], Structure[List[Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[]]], List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]]]]], 1000000], Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]]]], Structure[List[Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[]]], List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]], Bond[List[1, 1, Span[28, 42]], List[3, 1, Span[1, 15]]]]]], 1000000], Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]], Bond[List[1, 1, Span[28, 42]], List[3, 1, Span[1, 15]]]]]], List[Structure[List[Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[]], Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[16, 40]]], Bond[List[1, 1, Span[28, 42]], List[2, 1, Span[1, 15]]]]]], 1]]],
			{StructureP..}
		],
		Test["Gets the structures from a single reaction:",
			structuresComputable[ReactionMechanism[Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]]], List[]], Structure[List[Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[]]], List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]]]]], 1000000]]],
			{StructureP..}
		],
		Test["Does not evaluate when given improper input:",
			structuresComputable[Taco],
			structuresComputable[Taco]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*strandsComputable*)


DefineTests[strandsComputable,
	{
		Test["Converts a list of structures to a list of strands:",
			strandsComputable[ReactionMechanism[Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]]], List[]], Structure[List[Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[]]], List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]]]]], 1000000], Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]]]], Structure[List[Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[]]], List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]], Bond[List[1, 1, Span[28, 42]], List[3, 1, Span[1, 15]]]]]], 1000000], Reaction[List[Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[1, 25]]], Bond[List[1, 1, Span[28, 42]], List[3, 1, Span[1, 15]]]]]], List[Structure[List[Strand[DNA["GAGATACTGAGGCTCTACATTTCCT", "D"], Modification["Fluorescein"]]], List[]], Structure[List[Strand[Modification["Dabcyl"], DNA["AGGAAATGTAGAGCCTCAGTATCTC", "D'"], DNA["A", "L5'"], DNA["GCACATTTAAGCCAT", "T'"]], Strand[DNA["ATGGCTTAAATGTGC", "T"], DNA["GAGATACTGAGGCTCTACATTTCCT", "D"]]], List[Bond[List[1, 1, Span[2, 26]], List[2, 1, Span[16, 40]]], Bond[List[1, 1, Span[28, 42]], List[2, 1, Span[1, 15]]]]]], 1]]],
			{StrandP..}
		],
		Test["Does not evaluate when given improper input:",
			strandsComputable[Taco],
			strandsComputable[Taco]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*reactantsComputable*)


DefineTests[reactantsComputable,
	{
		Test["No reactants if everything is reversible:",
			reactantsComputable[ReactionMechanism[Reaction[{"A", "B"}, {"C", "D"}, 10^3, 1 / 10^6]]],
			{}
		],
		Test["Returns a flat list of all reactants consumed during the reaction:",
			reactantsComputable[ReactionMechanism[Reaction[{"A", "B"}, {"C", "D"}, 10^3, 1 / 10^6], Reaction[{"D", "E"}, {"F", "G"}, 10^3]]],
			{"E"}
		],
		Test["Does not evaluate when given improper input:",
			reactantsComputable[Taco],
			reactantsComputable[Taco]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*intermediateSpeciesComputable*)


DefineTests[intermediateSpeciesComputable,
	{
		Test["Gets all the species which are produced and then consumed during a chain of reactions:",
			intermediateSpeciesComputable[ReactionMechanism[Reaction[{"D", "E"}, {"F", "G"}, 10^3], Reaction[{"G", "A"}, {"Z", "Y"}, 10^3, 1 / 10^6]]],
			{"A", "G", "Y", "Z"}
		],
		Test["Returns an empty list when there are no intermediate species:",
			intermediateSpeciesComputable[ReactionMechanism[Reaction[{"D", "E"}, {"F", "G"}, 10^3]]],
			{}
		],
		Test["Does not evaluate when given improper input:",
			intermediateSpeciesComputable[Taco],
			intermediateSpeciesComputable[Taco]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*reactionProductsComputable*)


DefineTests[reactionProductsComputable,
	{
		Test["Gets all the species which are produced in a chain of reactions:",
			reactionProductsComputable[ReactionMechanism[Reaction[{"D", "E"}, {"F", "G"}, 10^3, 1 / 10^6], Reaction[{"G", "A"}, {"Z", "Y"}, 10^3]]],
			{"Y", "Z"}
		],
		Test["No products if everything is reversible:",
			reactionProductsComputable[ReactionMechanism[Reaction[{"D", "E"}, {"F", "G"}, 10^3, 1 / 10^6]]],
			{}
		],
		Test["Does not evaluate when given improper input:",
			reactionProductsComputable[Taco],
			reactionProductsComputable[Taco]
		]
	}
];


(* ::Subsection:: *)
(*modelInstrument*)


(* ::Subsection:: *)
(*part*)


(* ::Subsubsection::Closed:: *)
(*partsCurrentComputable*)


DefineTests[
	partsCurrentComputable,
	{
		(* BioSafetycabinet has no parts, but does have contents *)
		Test["No Parts returns Null:",
			partsCurrentComputable[
				Download[Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsCurrentComputable unit tests "<>$SessionUUID],ContentsLog],
				Download[Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsCurrentComputable unit tests "<>$SessionUUID],Contents]
			],
			Null,
			TimeConstraint->500
		],
		(* Pipette has no contents *)
		Test["No Contents returns Null:",
			partsCurrentComputable[
				Download[Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsCurrentComputable unit tests "<>$SessionUUID],ContentsLog],
				Download[Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsCurrentComputable unit tests "<>$SessionUUID],Contents]
			],
			Null
		],
		(* HPLC has parts *)
		Test["Select parts from a list of contents and return:",
			partsCurrentComputable[
				Download[Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsCurrentComputable unit tests "<>$SessionUUID],ContentsLog],
				Download[Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsCurrentComputable unit tests "<>$SessionUUID],Contents]
			],
			{{ObjectP[Object[Part]],_?DateObjectQ,_?TimeQ}..}
		]
	},
	SymbolSetUp:>{
		Module[{objects,existingObjects,test1Packets,allUploadPackets},

			(* All objects created for this unit test *)
			objects=Cases[
				Flatten[{
					Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 2 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 2 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 3 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,SampleLoop,"Test Plumbing SampleLoop 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,CheckValve,"Test Part CheckValve 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Piston,"Test Part Piston 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Seal,"Test Part Seal 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Container,Vessel,"Test Container Vessel 1 for partsCurrentComputable unit tests "<>$SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects=PickList[objects,DatabaseMemberQ[objects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Packets for first test *)
			test1Packets=Module[{objectIDs$,linkIDs$},

				objectIDs$=CreateID[
					{
						Object[Instrument,HandlingStation,BiosafetyCabinet],
						Object[Instrument,HPLC],
						Object[Instrument,Pipette],
						Object[Part,Lamp],
						Object[Part,Lamp],
						Object[Plumbing,Tubing],
						Object[Plumbing,Tubing],
						Object[Plumbing,Tubing],
						Object[Plumbing,SampleLoop],
						Object[Part,CheckValve],
						Object[Part,Piston],
						Object[Part,Seal],
						Object[Container,Vessel]
					}
				];

				linkIDs$=CreateLinkID[10];

				{
					<|
						Object->objectIDs$[[1]],
						Type->Object[Instrument,HandlingStation,BiosafetyCabinet],
						Name->"Test Instrument BiosafetyCabinet 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,HandlingStation,BiosafetyCabinet,"id:XnlV5jNYpXYP"],Objects],
						Replace[Contents]->{
							{"Lysol Reservoir Slot",Link[objectIDs$[[13]],Container,linkIDs$[[10]]]}
						},
						Replace[ContentsLog]->{
							{DateObject[{2017,6,2,19,24,42.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[13]],LocationLog,3],"Lysol Reservoir Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]}
						},
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[2]],
						Type->Object[Instrument,HPLC],
						Name->"Test Instrument HPLC 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,HPLC,"id:P5ZnEjdExnnn"],Objects],
						Replace[Contents]->{
							{"Lamp Slot 1",Link[objectIDs$[[4]],Container,linkIDs$[[1]]]},
							{"Lamp Slot 2",Link[objectIDs$[[5]],Container,linkIDs$[[2]]]},
							{"Buffer A Inlet Slot",Link[objectIDs$[[6]],Container,linkIDs$[[3]]]},
							{"Buffer B Inlet Slot",Link[objectIDs$[[7]],Container,linkIDs$[[4]]]},
							{"Buffer C Inlet Slot",Link[objectIDs$[[8]],Container,linkIDs$[[5]]]},
							{"Sample Loop Slot",Link[objectIDs$[[9]],Container,linkIDs$[[6]]]},
							{"Pump Check Valves Slot",Link[objectIDs$[[10]],Container,linkIDs$[[7]]]},
							{"Pump Pistons Slot",Link[objectIDs$[[11]],Container,linkIDs$[[8]]]},
							{"Pump Piston Seals Slot",Link[objectIDs$[[12]],Container,linkIDs$[[9]]]}
						},
						Replace[ContentsLog]->{
							{DateObject[{2015,6,30,17,52,10.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[4]],LocationLog,3],Null,Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2015,6,30,17,52,10.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[4]],LocationLog,3],"Lamp Slot 1",Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2015,6,30,18,0,56.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[5]],LocationLog,3],Null,Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2015,6,30,18,0,56.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[5]],LocationLog,3],"Lamp Slot 2",Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2017,10,26,17,57,28.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[6]],LocationLog,3],"Buffer A Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2017,10,26,17,57,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[7]],LocationLog,3],"Buffer B Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2017,10,26,17,57,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[8]],LocationLog,3],"Buffer C Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2020,9,16,8,34,33.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[9]],LocationLog,3],"Sample Loop Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,14,25,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[10]],LocationLog,3],"Pump Check Valves Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,15,10,38.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[11]],LocationLog,3],"Pump Pistons Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,15,25,55.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[12]],LocationLog,3],"Pump Piston Seals Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]}
						},
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[3]],
						Type->Object[Instrument,Pipette],
						Name->"Test Instrument Pipette 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,Pipette,"id:bq9LA0dBGezz"],Objects],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[4]],
						Type->Object[Part,Lamp],
						Name->"Test Part Lamp 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Lamp,"id:eGakld01zVJn"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[1]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[5]],
						Type->Object[Part,Lamp],
						Name->"Test Part Lamp 2 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Lamp,"id:Y0lXejGKdbMP"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[2]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[6]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[3]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[7]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 2 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[4]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[8]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 3 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[5]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[9]],
						Type->Object[Plumbing,SampleLoop],
						Name->"Test Plumbing SampleLoop 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,SampleLoop,"id:J8AY5jDazMl9"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[6]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[10]],
						Type->Object[Part,CheckValve],
						Name->"Test Part CheckValve 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Part,CheckValve,"id:R8e1PjpNG1dp"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[7]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[11]],
						Type->Object[Part,Piston],
						Name->"Test Part Piston 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Piston,"id:vXl9j57R10DN"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[8]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[12]],
						Type->Object[Part,Seal],
						Name->"Test Part Seal 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Seal,"id:4pO6dM51G648"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[9]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[13]],
						Type->Object[Container,Vessel],
						Name->"Test Container Vessel 1 for partsCurrentComputable unit tests "<>$SessionUUID,
						Model->Link[Model[Container,Vessel,"id:KBL5DvYl33Oj"],Objects],
						Container->Link[objectIDs$[[1]],Contents,2,linkIDs$[[10]]],
						DeveloperObject->True
					|>
				}
			];

			(* Combine packets for upload *)
			allUploadPackets=Flatten[{test1Packets}];

			Upload[allUploadPackets]
		]
	},
	SymbolTearDown:>{
		Module[{objects,existingObjects},

			(* All objects created for this unit test *)
			objects=Cases[
				Flatten[{
					Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 2 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 2 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 3 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Plumbing,SampleLoop,"Test Plumbing SampleLoop 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,CheckValve,"Test Part CheckValve 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Piston,"Test Part Piston 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Part,Seal,"Test Part Seal 1 for partsCurrentComputable unit tests "<>$SessionUUID],
					Object[Container,Vessel,"Test Container Vessel 1 for partsCurrentComputable unit tests "<>$SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects=PickList[objects,DatabaseMemberQ[objects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
		]
	}
];


(* ::Subsubsection:: *)
(*partsHistoryComputable*)


DefineTests[
	partsHistoryComputable,
	{
		(* Pipette has no contents *)
		Test["No Contents Log returns Null:",
			partsHistoryComputable[Download[Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsHistoryComputatble unit tests "<>$SessionUUID], ContentsLog], Download[Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsHistoryComputatble unit tests "<>$SessionUUID], Parts]],
			Null
		],
		(* BioSafetyCabinet has no parts, but does have contents *)
		Test["If contentsLog doesn't contain a part, return Null:",
			partsHistoryComputable[Download[Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsHistoryComputatble unit tests "<>$SessionUUID], ContentsLog], Download[Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsHistoryComputatble unit tests "<>$SessionUUID], Parts]],
			Null,
			TimeConstraint -> 500
		],
		Test["If historical contents contains a part, return its object, date activated and deactivated:",
			partsHistoryComputable[Download[Object[Instrument, WaterPurifier,"Test Instrument WaterPurifier 1 for partsHistoryComputatble unit tests "<>$SessionUUID], ContentsLog], Download[Object[Instrument, WaterPurifier,"Test Instrument WaterPurifier 1 for partsHistoryComputatble unit tests "<>$SessionUUID], Parts]],
			{{ObjectP[Object[Part]], _?DateObjectQ, _?DateObjectQ}..}
		],
		Test["If historical contents and current parts both contain elements, only return historical parts that aren't in current parts list:",
			partsHistoryComputable[Download[Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID], ContentsLog], Download[Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID], Parts]],
			{{ObjectP[Object[Part]], _?DateObjectQ, _?DateObjectQ}..}
		]
	},
	SymbolSetUp:>{
		Module[{objects,existingObjects,test1Packets,allUploadPackets},

			(* All objects created for this unit test *)
			objects=Cases[
				Flatten[{
					Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,WaterPurifier,"Test Instrument WaterPurifier 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Filter,"Test Part Filter for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 2 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 2 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 3 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,SampleLoop,"Test Plumbing SampleLoop 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,CheckValve,"Test Part CheckValve 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Piston,"Test Part Piston 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Seal,"Test Part Seal 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Container,Vessel,"Test Container Vessel 1 for partsHistoryComputatble unit tests "<>$SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects=PickList[objects,DatabaseMemberQ[objects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Packets for first test *)
			test1Packets=Module[{objectIDs$,linkIDs$},

				objectIDs$=CreateID[
					{
						Object[Instrument,HandlingStation,BiosafetyCabinet],
						Object[Instrument,HPLC],
						Object[Instrument,Pipette],
						Object[Part,Lamp],
						Object[Part,Lamp],
						Object[Plumbing,Tubing],
						Object[Plumbing,Tubing],
						Object[Plumbing,Tubing],
						Object[Plumbing,SampleLoop],
						Object[Part,CheckValve],
						Object[Part,Piston],
						Object[Part,Seal],
						Object[Container,Vessel],
						Object[Instrument,WaterPurifier],
						Object[Part,Filter]
					}
				];

				linkIDs$=CreateLinkID[10];

				{
					<|
						Object->objectIDs$[[1]],
						Type->Object[Instrument,HandlingStation,BiosafetyCabinet],
						Name->"Test Instrument BiosafetyCabinet 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,HandlingStation,BiosafetyCabinet,"id:XnlV5jNYpXYP"],Objects],
						Replace[Contents]->{
							{"Lysol Reservoir Slot",Link[objectIDs$[[13]],Container,linkIDs$[[10]]]}
						},
						Replace[ContentsLog]->{
							{DateObject[{2017,6,2,19,24,42.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[13]],LocationLog,3],"Lysol Reservoir Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]}
						},
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[2]],
						Type->Object[Instrument,HPLC],
						Name->"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,HPLC,"id:P5ZnEjdExnnn"],Objects],
						Replace[Contents]->{
							{"Lamp Slot 1",Link[objectIDs$[[4]],Container,linkIDs$[[1]]]},
							{"Buffer A Inlet Slot",Link[objectIDs$[[6]],Container,linkIDs$[[3]]]},
							{"Buffer B Inlet Slot",Link[objectIDs$[[7]],Container,linkIDs$[[4]]]},
							{"Buffer C Inlet Slot",Link[objectIDs$[[8]],Container,linkIDs$[[5]]]},
							{"Sample Loop Slot",Link[objectIDs$[[9]],Container,linkIDs$[[6]]]},
							{"Pump Check Valves Slot",Link[objectIDs$[[10]],Container,linkIDs$[[7]]]},
							{"Pump Pistons Slot",Link[objectIDs$[[11]],Container,linkIDs$[[8]]]},
							{"Pump Piston Seals Slot",Link[objectIDs$[[12]],Container,linkIDs$[[9]]]}
						},
						Replace[ContentsLog]->{
							{DateObject[{2015,6,30,17,52,10.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[4]],LocationLog,3],Null,Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2015,6,30,18,0,56.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[5]],LocationLog,3],Null,Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2015,6,30,18,0,56.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[5]],LocationLog,3],"Lamp Slot 2",Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2017,10,26,17,57,28.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[6]],LocationLog,3],"Buffer A Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2017,10,26,17,57,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[7]],LocationLog,3],"Buffer B Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2017,10,26,17,57,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[8]],LocationLog,3],"Buffer C Inlet Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2019,6,30,16,0,56.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[5]],LocationLog,3],"Lamp Slot 2",Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2019,6,30,17,52,10.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[4]],LocationLog,3],"Lamp Slot 1",Link[Object[User,Emerald,Developer,"id:KBL5DvwA5Z6a"]]},
							{DateObject[{2020,9,16,8,34,33.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[9]],LocationLog,3],"Sample Loop Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,14,25,29.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[10]],LocationLog,3],"Pump Check Valves Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,15,10,38.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[11]],LocationLog,3],"Pump Pistons Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]},
							{DateObject[{2021,1,20,15,25,55.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[12]],LocationLog,3],"Pump Piston Seals Slot",Link[Object[User,Emerald,Developer,"id:mnk9jORrxrRw"]]}
						},
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[3]],
						Type->Object[Instrument,Pipette],
						Name->"Test Instrument Pipette 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument,Pipette,"id:bq9LA0dBGezz"],Objects],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[4]],
						Type->Object[Part,Lamp],
						Name->"Test Part Lamp 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Lamp,"id:eGakld01zVJn"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[1]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[5]],
						Type->Object[Part,Lamp],
						Name->"Test Part Lamp 2 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Lamp,"id:Y0lXejGKdbMP"],Objects],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[6]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[3]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[7]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 2 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[4]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[8]],
						Type->Object[Plumbing,Tubing],
						Name->"Test Plumbing Tubing 3 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,Tubing,"id:kEJ9mqa1pZkV"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[5]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[9]],
						Type->Object[Plumbing,SampleLoop],
						Name->"Test Plumbing SampleLoop 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Plumbing,SampleLoop,"id:J8AY5jDazMl9"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[6]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[10]],
						Type->Object[Part,CheckValve],
						Name->"Test Part CheckValve 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part,CheckValve,"id:R8e1PjpNG1dp"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[7]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[11]],
						Type->Object[Part,Piston],
						Name->"Test Part Piston 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Piston,"id:vXl9j57R10DN"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[8]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[12]],
						Type->Object[Part,Seal],
						Name->"Test Part Seal 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part,Seal,"id:4pO6dM51G648"],Objects],
						Container->Link[objectIDs$[[2]],Contents,2,linkIDs$[[9]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[13]],
						Type->Object[Container,Vessel],
						Name->"Test Container Vessel 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Container,Vessel,"id:KBL5DvYl33Oj"],Objects],
						Container->Link[objectIDs$[[1]],Contents,2,linkIDs$[[10]]],
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[14]],
						Type->Object[Instrument,WaterPurifier],
						Name->"Test Instrument WaterPurifier 1 for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Instrument, WaterPurifier, "id:R8e1Pjp6lZ7X"],Objects],
						Replace[ContentsLog]->{
							{DateObject[{2017,6,2,19,24,42.},"Instant","Gregorian",-8.],In,Link[objectIDs$[[15]],LocationLog,3],"MilliPak Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]},
							{DateObject[{2019,6,2,19,24,42.},"Instant","Gregorian",-8.],Out,Link[objectIDs$[[15]],LocationLog,3],"MilliPak Slot",Link[Object[User,Emerald,Developer,"id:jLq9jXvZ9lmz"]]}

						},
						DeveloperObject->True
					|>,
					<|
						Object->objectIDs$[[15]],
						Type->Object[Part,Filter],
						Name->"Test Part Filter for partsHistoryComputatble unit tests "<>$SessionUUID,
						Model->Link[Model[Part, Filter, "id:D8KAEvGPZnWR"],Objects],
						DeveloperObject->True
					|>
				}
			];

			(* Combine packets for upload *)
			allUploadPackets=Flatten[{test1Packets}];

			Upload[allUploadPackets]
		]
	},
	SymbolTearDown:>{
		Module[{objects,existingObjects},

			(* All objects created for this unit test *)
			objects=Cases[
				Flatten[{
					Object[Instrument,HandlingStation,BiosafetyCabinet,"Test Instrument BiosafetyCabinet 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,Pipette,"Test Instrument Pipette 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,HPLC,"Test Instrument HPLC 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Instrument,WaterPurifier,"Test Instrument WaterPurifier 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Filter,"Test Part Filter for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Lamp,"Test Part Lamp 2 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 2 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,Tubing,"Test Plumbing Tubing 3 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Plumbing,SampleLoop,"Test Plumbing SampleLoop 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,CheckValve,"Test Part CheckValve 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Piston,"Test Part Piston 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Part,Seal,"Test Part Seal 1 for partsHistoryComputatble unit tests "<>$SessionUUID],
					Object[Container,Vessel,"Test Container Vessel 1 for partsHistoryComputatble unit tests "<>$SessionUUID]
				}],
				ObjectReferenceP[]
			];

			existingObjects=PickList[objects,DatabaseMemberQ[objects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*figureComputable*)


DefineTests[
	figureComputable,
	{
		Test[
			"Given a report[Figure] object, return the figure specified in the FigureExpression",
			(
				figExpression=Hold[ListLinePlot[Table[i, {i, 10}]]];
				figureComputable[figExpression]
			),
			_?ValidGraphicsQ
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*figureEnvironmentComputable*)


DefineTests[
	figureEnvironmentComputable,
	{
		Test[
			"Return Null if no surrounding environment for a figure is given:",
			(
				figExpression=Hold[ListLinePlot[Table[i, {i, 10}]]];
				figureEnvironmentComputable[figExpression]
			),
			Null
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*fractionContainerReplacement*)

DefineTests[
	fractionContainerReplacement,
	{
		Test["Updates fields in Dionex protocol for procedure usage:",
			fractionContainerReplacement[Object[Protocol, HPLC, "Test HPLC protocol for fractionContainerReplacement"<>$SessionUUID]],
			ObjectP[Object[Protocol, HPLC]]
		],
		Test["Updates fields in Agilent protocol for procedure usage:",
			fractionContainerReplacement[Object[Protocol, HPLC, "Test HPLC protocol 2 for fractionContainerReplacement"<>$SessionUUID]];
			Download[Object[Protocol, HPLC, "Test HPLC protocol 2 for fractionContainerReplacement"<>$SessionUUID], {ReplacementFractionContainers,FractionContainerReplacement[[All,3]]}],
			{
				{ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]..},
				{"A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", "A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5"}
			}
		],
		Test["Updates fields in a SemiPreparative Agilent protocol for procedure usage:",
			fractionContainerReplacement[Object[Protocol, HPLC, "Test HPLC protocol 3 for fractionContainerReplacement"<>$SessionUUID]],
			ObjectP[Object[Protocol, HPLC]]
		],
		Test["When Upload is False, return the change packets:",
			fractionContainerReplacement[Object[Protocol, HPLC, "Test HPLC protocol for fractionContainerReplacement"<>$SessionUUID],Upload->False],
			PacketP[Object[Protocol, HPLC]]
		]
	},
	SymbolSetUp:>{
		Module[
			{allObjects},
			(* Check list of created objects to delete if they exist in database. *)
			allObjects = Cases[Flatten[{
				Object[Protocol, HPLC, "Test HPLC protocol for fractionContainerReplacement"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 2 for fractionContainerReplacement"<>$SessionUUID],
				Object[Protocol, HPLC, "Test HPLC protocol 3 for fractionContainerReplacement"<>$SessionUUID],
				Object[Instrument, HPLC, "Test HPLC instrument for fractionContainerReplacement"<>$SessionUUID],
				Object[Container, Deck, "Test Deck for fractionContainerReplacement"<>$SessionUUID],
				Object[Instrument, HPLC, "Test HPLC instrument for fractionContainerReplacement"<>$SessionUUID],
				Object[Instrument, HPLC, "Test HPLC instrument 2 for fractionContainerReplacement"<>$SessionUUID],
				Object[Instrument, HPLC, "Test HPLC instrument 3 for fractionContainerReplacement"<>$SessionUUID],
				Table[Object[Container, Plate, "Test container"<>ToString[x]<>" for fractionContainerReplacement"<>$SessionUUID],{x, 1, 4}],
				Table[Object[Container, Vessel, "Test container vessel"<>ToString[x]<>" for fractionContainerReplacement"<>$SessionUUID],{x, 1, 20}],
				Table[Object[Container, Rack, "Test small rack"<>ToString[x]<>" for fractionContainerReplacement"<>$SessionUUID],{x, 1, 3}],
				Table[Object[Container, Rack, "Test large rack"<>ToString[x]<>" for fractionContainerReplacement"<>$SessionUUID],{x, 1, 3}]
			}],ObjectP[]];
			EraseObject[
				PickList[allObjects,DatabaseMemberQ[allObjects]],
				Force -> True,
				Verbose -> False
			];
		];
		Module[
			{protocolObject, containers, instrument, instrument2, instrument3, deck, racks, agilentProtocolObject, semiPrepAgilentProtocolObject, deckPlacements},

			(* Set created objects as empty list *)
			$CreatedObjects = {};

			(* Set up deck*)
			deck = Upload[<|
				Type -> Object[Container, Deck],
				Model -> Link[Model[Container, Deck, "Avant Buffer Sample Deck"], Objects],
				Name -> "Test Deck for fractionContainerReplacement"<>$SessionUUID
			|>];

			(* Set up instruments *)
			instrument = Upload[<|
				Type -> Object[Instrument, HPLC],
				Name -> "Test HPLC instrument for fractionContainerReplacement"<>$SessionUUID,
				Replace[FractionCollectorDeck] -> Link[deck,Instruments],
				DeveloperObject -> True,
				Timebase -> "HPLC20A"
			|>];
			instrument2 = Upload[<|
				Type -> Object[Instrument, HPLC],
				Name -> "Test HPLC instrument 2 for fractionContainerReplacement"<>$SessionUUID,
				Replace[FractionCollectorDeck] -> Link[deck,Instruments],
				DeveloperObject -> True,
				Timebase -> Null,
				Scale -> Preparative
			|>];
			instrument3 = Upload[<|
				Type -> Object[Instrument, HPLC],
				Name -> "Test HPLC instrument 3 for fractionContainerReplacement"<>$SessionUUID,
				Replace[FractionCollectorDeck] -> Link[deck,Instruments],
				DeveloperObject -> True,
				Timebase -> Null,
				Scale -> SemiPreparative
			|>];

			containers = Upload[
				Flatten[{
					{
						<|
							Type -> Object[Container, Plate],
							Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
							Name -> "Test container1 for fractionContainerReplacement" <> $SessionUUID
						|>,
						<|
							Type -> Object[Container, Plate],
							Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
							Name -> "Test container2 for fractionContainerReplacement" <> $SessionUUID
						|>,
						<|
							Type -> Object[Container, Plate],
							Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
							Name -> "Test container3 for fractionContainerReplacement" <> $SessionUUID
						|>,
						<|
							Type -> Object[Container, Plate],
							Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
							Name -> "Test container4 for fractionContainerReplacement" <> $SessionUUID
						|>
					},
					Map[
						<|
							Type -> Object[Container, Vessel],
							Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
							Name -> "Test container vessel" <> ToString[#] <> " for fractionContainerReplacement" <> $SessionUUID
						|>&,
						Range[20]
					]
				}]
			];

			racks=Upload[
				Join[
					Map[
						<|
							Type -> Object[Container, Rack],
							Model -> Link[Experiment`Private`$LargeAgilentHPLCAutosamplerRack,Objects],
							Name -> "Test small rack"<>ToString[#]<>" for fractionContainerReplacement"<>$SessionUUID
						|>&,
						Range[3]
					],
					Map[
						<|
							Type -> Object[Container, Rack],
							Model -> Link[Experiment`Private`$LargeAgilentHPLCAutosamplerRack,Objects],
							Name -> "Test large rack"<>ToString[#]<>" for fractionContainerReplacement"<>$SessionUUID
						|>&,
						Range[3]
					]
				]
			];

			deckPlacements = MapThread[
				{Link[#1],{"Rack Slot "<>ToString[#2]}}&,
				{racks,Range[6]}
			];


			protocolObject = Upload[<|
				Type -> Object[Protocol, HPLC],
				Name -> "Test HPLC protocol for fractionContainerReplacement"<>$SessionUUID,
				Replace[AwaitingFractionContainers] -> True,
				Replace[ReplacementFractionContainers] -> Link[containers[[1;;4]]],
				Replace[Instrument] -> Link[instrument],
				NumberOfFractionContainers -> 4
			|>];

			agilentProtocolObject = Upload[<|
				Type -> Object[Protocol, HPLC],
				Name -> "Test HPLC protocol 2 for fractionContainerReplacement"<>$SessionUUID,
				Replace[AwaitingFractionContainers] -> True,
				Replace[ReplacementFractionContainers] -> Link[containers[[5;;]]],
				Replace[Instrument] -> Link[instrument2],
				NumberOfFractionContainers -> 20,
				Replace[AutosamplerDeckPlacements] -> deckPlacements
			|>];

			semiPrepAgilentProtocolObject = Upload[<|
				Type -> Object[Protocol, HPLC],
				Name -> "Test HPLC protocol 3 for fractionContainerReplacement"<>$SessionUUID,
				Replace[AwaitingFractionContainers] -> True,
				Replace[ReplacementFractionContainers] -> Link[containers[[1;;4]]],
				Replace[Instrument] -> Link[instrument3],
				NumberOfFractionContainers -> 4
			|>];
		]
	},
	SymbolTearDown:>{
		EraseObject[$CreatedObjects, Force->True, Verbose -> False]
	}
];
