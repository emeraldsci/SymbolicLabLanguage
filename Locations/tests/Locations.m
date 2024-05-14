(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Location*)


DefineTests[
	Location,
	{
		(* --- Examples --- *)

		Example[{Basic,"Find the address of a given item within the ECL (up to the Room level by default):"},
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID]],
			_Pane
		],
		Example[{Basic, "Find the address of a given item within the ECL at some point in the past:"},
			Location[Object[Instrument, PlateReader, "id:qdkmxz0A8D70"], DateObject["July 4 2015"]],
			_Pane
		],
		Example[{Additional,"The function returns an empty list if the supplied item has no container:"},
			Location[Object[Container,Building,"Location test building"<>$SessionUUID]],
			{}
		],
		Example[{Behaviors,"ReverseMapping","Lists of inputs are handled by the ReverseMapping behavior:"},
			Location[{Object[Container,Bench,"Location test bench 1"<>$SessionUUID], Object[Container,Bench,"Location test bench 2"<>$SessionUUID]}],
			{_Pane, _Pane}
		],
		Example[{Options,LevelsUp,"Find the address of a given item up to a specified number of levels above it in the container tree:"},
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID], LevelsUp -> 2],
			_Pane
		],
		Example[{Options,LevelsUp,"Find the absolute address of a given item in the ECL:"},
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID],LevelsUp->Infinity],
			_Pane
		],
		Example[{Options,NearestUp,"Find the address of a given item, traversing until hitting a container of a specified Type:"},
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID],NearestUp->Object[Container,Floor]],
			_Pane
		],
		Example[{Options,Output,"Return a list of associations containing location information:"},
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID], Output->Association],
			{
					<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
					<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
					<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
					<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Bench Top Slot"|>
			}
		],
		Example[{Options,Output,"Return a detailed table of location information:"},
			Location[Object[Container, Room, "Location test room"<>$SessionUUID],Output->Table],
			_Pane
		],
		Example[{Options,Output,"Return a location string:"},
			Location[Object[Container, Room, "Location test room"<>$SessionUUID],Output->String],
			"Location test building"<>$SessionUUID<>" [First Floor Slot], Location test floor"<>$SessionUUID<>" [Room Slot 1]"
		],
		Example[{Messages,"ObjectNotFound","If any of the provided Object(s) do not exist in the database, an error is returned:"},
			Location[Object[Container, Room, "id:DoesNotExist"]],
			$Failed,
			Messages:>{Location::ObjectNotFound}
		],
		Example[{Messages,"InvalidDate","If the provided date is not in the past, an error is returned:"},
			Location[Object[Container, Room, "Location test room"<>$SessionUUID], Tomorrow],
			$Failed,
			Messages:>{Location::InvalidDate}
		],


		(* --- Tests --- *)

		Test["Past date Location overload operates properly on multiple past locations when some are empty:",
			Location[{Object[Container, Plate, "id:BYDOjv1Z9M4z"], Object[Container, Bag, "id:WNa4ZjR1aE1L"]}, DateObject["April 11 2017 00:00:00"], Output->Association, NearestUp->Object[Container,Room]],
			{
				{
					<|"Object" -> ObjectP[Object[Container, Room, "id:pZx9jonGkPKj"]], "Name" -> "Chemistry Lab", "Position" -> "RT VLM Slot"|>,
					<|"Object" -> ObjectP[Object[Instrument, VerticalLift, "id:R8e1PjRDba9a"]], "Name" -> "Ambient VLM", "Position" -> "A3"|>,
					<|"Object" -> ObjectP[Object[Container, Shelf, "id:eGakld01q5Kn"]], "Name" -> "Ambient VLM Shelf 3", "Position" -> "B2"|>,
					<|"Object" -> ObjectP[Object[Container, Rack, "id:rea9jl1o3bEo"]], "Name" -> "Tote for 2 mL DWP 2", "Position" -> "D1"|>
				},
				{}
			}
		],
		Test["Past date Location overload operates properly on multiple past locations when all are empty:",
			Location[{Object[Container, Plate, "id:D8KAEvd4YMXl"], Object[Container, Plate, "id:KBL5DvYkAMzd"]}, DateObject["Jan 1 2017"], Output->Association],
			{{},{}}
		],
		Test["Find the address of a given item within the ECL:",
			Location[Object[Container, Room, "Location test room"<>$SessionUUID], Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
				<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>
			}
		],
		Test["Find the address of a given item within the ECL at some point in the past:",
			Location[Object[Instrument, PlateReader, "id:qdkmxz0A8D70"], DateObject["July 4 2015"], Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, Building, "id:9RdZXvKBzXvl"]], "Name" -> "844 Dubuque Avenue", "Position" -> "First Floor Slot"|>,
				<|"Object" ->  ObjectP[Object[Container, Floor, "id:dORYzZn0XzZw"]], "Name" -> "844 Dubuque Avenue First Floor", "Position" -> "Chemistry Lab Slot"|>,
				<|"Object" ->  ObjectP[Object[Container, Room, "id:pZx9jonGkPKj"]], "Name" -> "Chemistry Lab", "Position" -> "Bench Slot 12"|>,
				<|"Object" ->  ObjectP[Object[Container, Bench, "id:1ZA60vwjVKBw"]], "Name" -> _String, "Position" -> "Bench Top Slot"|>,
				<|"Object" ->  ObjectP[Object[Container, Shelf, "id:eGakld01q6Z1"]], "Name" -> _String, "Position" -> "PheraStar Slot"|>
			}
		],
		Test["Lists of inputs are are handled by the ReverseMapping behavior:",
			Location[{Object[Container,Bench,"Location test bench 1"<>$SessionUUID], Object[Container,Bench,"Location test bench 2"<>$SessionUUID]}, Output->Association],
			{
				{
					<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
					<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
					<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>
				}, 
				{
					<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
					<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
					<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 2"|>
				}
			}
		],
		Test["Find the address of a given item up to a specified number of levels above it in the container tree:",
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID], LevelsUp -> 2, Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Bench Top Slot"|>
			}
		],
		Test["Find the absolute address of a given item in the ECL:",
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID],LevelsUp->Infinity, Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
				<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Bench Top Slot"|>
			}
		],
		Test["Find the address of a given item, traversing until hitting a container of a specified Type:",
			Location[Object[Container, Shelf, "Location test shelf 1"<>$SessionUUID],NearestUp->Object[Container,Bench], Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Bench Top Slot"|>
			}
		],
		Test["Find the address for an installed plumbing item:",
			Location[Object[Plumbing, Tubing, "Location test tubing"<>$SessionUUID], Output -> Association],
			{
				<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" ->"Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
				<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Work Surface"|>,
				<|"Object" -> ObjectP[Object[Instrument, HPLC, "Location test HPLC"<>$SessionUUID]], "Name" -> "Location test HPLC"<>$SessionUUID, "Position" -> ""|>
			},
			SetUp:>{
				Upload[{
					<|
						Object->Object[Plumbing, Tubing, "Location test tubing"<>$SessionUUID],
						ConnectedLocation->Link[Object[Instrument, HPLC, "Location test HPLC"<>$SessionUUID],ConnectedPlumbing],
						Status->Installed
					|>,
					<|
						Object->Object[Instrument, HPLC, "Location test HPLC"<>$SessionUUID],
						Container->Link[Object[Container, Bench, "Location test bench 1"<>$SessionUUID], Contents, 2],
						Position -> "Work Surface"
					|>
				}];
			}
		],
		Test["Find the address for an installed fitting (such as Nut or Ferrule) item:",
			Location[Object[Part, Nut, "Test nut for Location"<>$SessionUUID], Output -> Association],
			{
				<|"Object" ->ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
				<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Work Surface"|>,
				<|"Object" -> ObjectP[Object[Plumbing, Tubing,  "Test tubing for Location"<>$SessionUUID]], "Name" -> "Test tubing for Location"<>$SessionUUID, "Position" -> ""|>},
			SetUp:>{
				Module[{},
					Upload[<|
						Type->Object[Plumbing, Tubing],
						Name->"Test tubing for Location"<>$SessionUUID,
						Container->Link[Object[Container, Bench, "Location test bench 1"<>$SessionUUID], Contents, 2],
						Position -> "Work Surface"
					|>];
					Upload[
						<|
							Type->Object[Part, Nut],
							Name->"Test nut for Location"<>$SessionUUID,
							InstalledLocation->Link[Object[Plumbing, Tubing, "Test tubing for Location"<>$SessionUUID],Nuts,2],
							Status->Installed
						|>];
				];
			},
			TearDown:>{
				EraseObject[{
					Object[Part, Nut, "Test nut for Location"<>$SessionUUID],
					Object[Plumbing, Tubing, "Test tubing for Location"<>$SessionUUID]
				},
					Force -> True
				];
			}
		],
		Test["Find the address for an installed fitting (such as Nut or Ferrule) when it is connected to a plumbing item in an instrument:",
			Location[Object[Part, Nut, "Test nut for Location"<>$SessionUUID], Output -> Association],
			{
				<|"Object" -> ObjectP[Object[Container, Building, "Location test building"<>$SessionUUID]], "Name" -> "Location test building"<>$SessionUUID, "Position" -> "First Floor Slot"|>,
				<|"Object" -> ObjectP[Object[Container, Floor, "Location test floor"<>$SessionUUID]], "Name" -> "Location test floor"<>$SessionUUID, "Position" -> "Room Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Room, "Location test room"<>$SessionUUID]], "Name" -> "Location test room"<>$SessionUUID, "Position" -> "Bench Slot 1"|>,
				<|"Object" -> ObjectP[Object[Container, Bench, "Location test bench 1"<>$SessionUUID]], "Name" -> "Location test bench 1"<>$SessionUUID, "Position" -> "Work Surface"|>,
				<|"Object" -> ObjectP[Object[Instrument, HPLC, "Test HPLC for Location"<>$SessionUUID]], "Name" -> "Test HPLC for Location"<>$SessionUUID, "Position" -> "Column Slot"|>,
				<|"Object" -> ObjectP[Object[Plumbing, Tubing, "Test tubing for Location"<>$SessionUUID]], "Name" -> "Test tubing for Location"<>$SessionUUID, "Position" -> ""|>},
			SetUp:>{
				Module[{},
					Upload[
						<|
							Type->Object[Instrument, HPLC],
							Name->"Test HPLC for Location"<>$SessionUUID,
							Container -> Link[Object[Container, Bench, "Location test bench 1"<>$SessionUUID], Contents, 2],
							Position -> "Work Surface",
							Model -> Link[Model[Instrument, HPLC, "id:N80DNjlYwwJq"],Objects],
							DeveloperObject -> True
						|>
					];
					Upload[
						<|
							Type->Object[Plumbing, Tubing],
							Name->"Test tubing for Location"<>$SessionUUID,
							Container -> Link[Object[Instrument, HPLC, "Test HPLC for Location"<>$SessionUUID], Contents, 2],
							Position -> "Column Slot",
							ConnectedLocation -> Link[Object[Instrument, HPLC, "Test HPLC for Location"<>$SessionUUID], ConnectedPlumbing], Status -> Installed
						|>
					];
					Upload[
						<|
							Type->Object[Part, Nut],
							Name->"Test nut for Location"<>$SessionUUID,
							InstalledLocation->Link[Object[Plumbing, Tubing, "Test tubing for Location"<>$SessionUUID],Nuts,2],
							Status->Installed
						|>
					];
				];
			},
			TearDown:>{
				EraseObject[{
					Object[Part, Nut, "Test nut for Location"<>$SessionUUID],
					Object[Plumbing, Tubing, "Test tubing for Location"<>$SessionUUID],
					Object[Instrument, HPLC, "Test HPLC for Location"<>$SessionUUID]
				},
					Force -> True
				];
			}
		],
		Test["Find the address for an InUse plumbing item:",
			Location[Object[Plumbing, Cap, "Location test cap"<>$SessionUUID],Output->Association],
			{
				<|"Object" -> ObjectP[Object[Container, OperatorCart, "Location test cart"<>$SessionUUID]],"Name" -> "Location test cart"<>$SessionUUID,"Position" -> "Tray Slot"|>
			},
			SetUp:>{
				Upload[
					<|
						Object -> Object[Plumbing, Cap, "Location test cap"<>$SessionUUID],
						Container -> Link[Object[Container, OperatorCart, "Location test cart"<>$SessionUUID], Contents,2],
						Position -> "Tray Slot",
						Status -> InUse
					|>
				];
			}

		]
	},
	SymbolSetUp:>{

		$CreatedObjects = {};
		Block[{$DeveloperUpload = True},
			Module[{allObjects,existingObjects},

				(*Gather all the objects and models created in SymbolSetUp*)
				allObjects = {
					Object[Container,Room,"Location test room" <> $SessionUUID],
					Model[Container,Room,"Location test room model" <> $SessionUUID],
					Model[Container,Floor,"Location test floor model" <> $SessionUUID],
					Object[Container,Floor,"Location test floor" <> $SessionUUID],
					Model[Container,Building,"Location test building model" <> $SessionUUID],
					Object[Container,Building,"Location test building" <> $SessionUUID],
					Object[Container,Bench,"Location test bench" <> $SessionUUID],
					Object[Container,Bench,"Location test bench 1" <> $SessionUUID],
					Object[Container,Bench,"Location test bench 2" <> $SessionUUID],
					Object[Container,Bench,"Location test bench with enclosure" <> $SessionUUID],
					Object[Container,Enclosure,"Location test enclosure" <> $SessionUUID],
					Object[Container,Shelf,"Location test shelf 1" <> $SessionUUID],
					Object[Instrument,HPLC,"Location test HPLC" <> $SessionUUID],
					Object[Plumbing,Tubing,"Location test tubing" <> $SessionUUID],
					Object[Plumbing,Cap,"Location test cap" <> $SessionUUID],
					Object[Container,OperatorCart,"Location test cart" <> $SessionUUID]
				};

				(*Check whether the names we want to give below already exist in the database*)
				existingObjects = PickList[allObjects,DatabaseMemberQ[allObjects]];

				(*Erase any objects and models that we failed to erase in the last unit test*)
				Quiet[EraseObject[existingObjects,Force -> True,Verbose -> False]];

			];

			(*Make a room/builing/floor models*)
			Upload[{
				<|
					Type -> Model[Container,Room],
					Name -> "Location test room model" <> $SessionUUID,
					Replace[PositionPlotting] -> {
						<|Name -> "Bench Slot 1",XOffset -> Quantity[7.62,"Meters"],YOffset -> Quantity[5.7912,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 2",XOffset -> Quantity[9.4488,"Meters"],YOffset -> Quantity[5.7912,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 3",XOffset -> Quantity[11.2776,"Meters"],YOffset -> Quantity[5.7912,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 4",XOffset -> Quantity[13.1064,"Meters"],YOffset -> Quantity[5.7912,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 5",XOffset -> Quantity[7.62,"Meters"],YOffset -> Quantity[3.6576,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 6",XOffset -> Quantity[9.4488,"Meters"],YOffset -> Quantity[3.6576,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 7",XOffset -> Quantity[11.2776,"Meters"],YOffset -> Quantity[3.6576,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Bench Slot 8",XOffset -> Quantity[13.1064,"Meters"],YOffset -> Quantity[3.6576,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "NMR Slot 1",XOffset -> Quantity[11.8872,"Meters"],YOffset -> Quantity[1.524,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Circle,Rotation -> 0.|>,
						<|Name -> "NMR Slot 2",XOffset -> Quantity[9.144,"Meters"],YOffset -> Quantity[1.524,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Circle,Rotation -> 0.|>
					},
					Replace[Positions] -> {
						<|Name -> "Bench Slot 1",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 2",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 3",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 4",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 5",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 6",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 7",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Bench Slot 8",Footprint -> Open,MaxWidth -> Quantity[1.8288,"Meters"],MaxDepth -> Quantity[0.9144,"Meters"],MaxHeight -> Null|>,
						<|Name -> "NMR Slot 1",Footprint -> Open,MaxWidth -> Quantity[2.4384,"Meters"],MaxDepth -> Quantity[2.4384,"Meters"],MaxHeight -> Null|>,
						<|Name -> "NMR Slot 2",Footprint -> Open,MaxWidth -> Quantity[2.4384,"Meters"],MaxDepth -> Quantity[2.4384,"Meters"],MaxHeight -> Null|>
					}
				|>,
				<|
					Type -> Model[Container,Floor],
					Name -> "Location test floor model" <> $SessionUUID,
					Replace[PositionPlotting] -> {
						<|Name -> "Room Slot 1",XOffset -> Quantity[3.3528,"Meters"],YOffset -> Quantity[8.8392,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Room Slot 2",XOffset -> Quantity[8.5344,"Meters"],YOffset -> Quantity[8.8392,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Room Slot 3",XOffset -> Quantity[11.5824,"Meters"],YOffset -> Quantity[8.8392,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Room Slot 4",XOffset -> Quantity[7.9248,"Meters"],YOffset -> Quantity[3.2004,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>
					},
					Replace[Positions] -> {
						<|Name -> "Room Slot 1",Footprint -> Open,MaxWidth -> Quantity[6.7056,"Meters"],MaxDepth -> Quantity[3.048,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Room Slot 2",Footprint -> Open,MaxWidth -> Quantity[3.048,"Meters"],MaxDepth -> Quantity[3.048,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Room Slot 3",Footprint -> Open,MaxWidth -> Quantity[3.048,"Meters"],MaxDepth -> Quantity[3.048,"Meters"],MaxHeight -> Null|>,
						<|Name -> "Room Slot 4",Footprint -> Open,MaxWidth -> Quantity[15.8496,"Meters"],MaxDepth -> Quantity[6.4008,"Meters"],MaxHeight -> Null|>
					}
				|>,
				<|
					Type -> Model[Container,Building],
					Name -> "Location test building model" <> $SessionUUID,
					Replace[PositionPlotting] -> {
						<|Name -> "First Floor Slot",XOffset -> Quantity[7.9248,"Meters"],YOffset -> Quantity[5.1816,"Meters"],ZOffset -> Quantity[0.,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>,
						<|Name -> "Second Floor Slot",XOffset -> Quantity[7.9248,"Meters"],YOffset -> Quantity[5.1816,"Meters"],ZOffset -> Quantity[3.6576,"Meters"],CrossSectionalShape -> Rectangle,Rotation -> 0.|>
					},
					Replace[Positions] -> {
						<|Name -> "First Floor Slot",Footprint -> Open,MaxWidth -> Quantity[15.8496,"Meters"],MaxDepth -> Quantity[10.3632,"Meters"],MaxHeight -> Quantity[3.048,"Meters"]|>,
						<|Name -> "Second Floor Slot",Footprint -> Open,MaxWidth -> Quantity[15.8496,"Meters"],MaxDepth -> Quantity[10.3632,"Meters"],MaxHeight -> Quantity[3.048,"Meters"]|>
					}
				|>
			}];

			Upload[{
				<|Type -> Object[Container,Building],
					Model -> Link[Model[Container,Building,"Location test building model" <> $SessionUUID],Objects],
					Name -> "Location test building" <> $SessionUUID
				|>,
				<|Type -> Object[Instrument,HPLC],
					Model -> Link[Model[Instrument,HPLC,"Waters Acquity UPLC H-Class FLR"],Objects],
					Name -> "Location test HPLC" <> $SessionUUID
				|>,
				<|Type -> Object[Container,OperatorCart],
					Model -> Link[Model[Container,OperatorCart,"Chemistry Lab Cart"],Objects],
					Name -> "Location test cart" <> $SessionUUID
				|>
			}];

			(*Make some things to set up or fake room*)
			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Floor,"Location test floor model" <> $SessionUUID]
				},
				{
					{"First Floor Slot",Object[Container,Building,"Location test building" <> $SessionUUID]}
				},
				Name -> {
					"Location test floor" <> $SessionUUID
				},
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack -> True
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Room,"Location test room model" <> $SessionUUID]
				},
				{
					{"Room Slot 1",Object[Container,Floor,"Location test floor" <> $SessionUUID]}
				},
				Name -> {
					"Location test room" <> $SessionUUID
				},
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack -> True
			];

			ECL`InternalUpload`UploadSample[
				Table[
					Model[Container,Bench,"The Bench of Testing"],
					2
				],
				{
					{"Bench Slot 1",Object[Container,Room,"Location test room" <> $SessionUUID]},
					{"Bench Slot 2",Object[Container,Room,"Location test room" <> $SessionUUID]}
				},
				Name -> {
					"Location test bench 1" <> $SessionUUID,
					"Location test bench 2" <> $SessionUUID
				},
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack -> True
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Shelf,"id:kEJ9mqaVPPVp"],
					Model[Plumbing,Tubing,"PharmaPure #17"],
					Model[Plumbing,Cap,"id:4pO6dM5qEmXz"]
				},
				{
					{"Bench Top Slot",Object[Container,Bench,"Location test bench 1" <> $SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Location test bench 1" <> $SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Location test bench 1" <> $SessionUUID]}
				},
				Name -> {
					"Location test shelf 1" <> $SessionUUID,
					"Location test tubing" <> $SessionUUID,
					"Location test cap" <> $SessionUUID
				},
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack -> True
			];
		]

	},
	SymbolTearDown:>{
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False];

		Unset[$CreatedObjects];
	}
];


(* ::Subsection::Closed:: *)
(*PlaceItems*)


DefineTests[PlaceItems,
	{
		Example[{Basic,"Return Placements for a set of tube models into a tube rack:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},Model[Container,Rack,"4-position Tube Rack"]],
			{OrderlessPatternSequence[
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"A1"],
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"C1"],
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"D1"]
			]}
		],
		Example[{Basic,"Return Placements for tubes into a destination instrument:"},
			PlaceItems[{Object[Container,Vessel,"2mL Tube to Place in Rack"],Object[Container,Vessel,"2mL Tube to Place II"]},Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"]],
			{OrderlessPatternSequence[
				Placement[Item->Object[Container,Vessel,"id:eGakldJ4808e"],Destination->Object[Container,Rack,"id:1ZA60vLXbE1q"],Position->"A1"],
				Placement[Item->Object[Container,Vessel,"id:Y0lXejM6xeKv"],Destination->Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],Position->"Tube Slot 1"]
			]}
		],
		Example[{Basic,"Place a mixed group of objects and models into a rack model:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"],Object[Container,Vessel,"2mL Tube to Place in Rack"]},Model[Container,Rack,"4-position Tube Rack"]],
			{OrderlessPatternSequence[
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"B1"],
				Placement[Item->Object[Container,Vessel,"id:eGakldJ4808e"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"A1"]
			]}
		],
		Example[{Basic,"A failure is returned if the item group cannot be placed at once into the destination:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},Model[Container,Rack,"4-position Tube Rack"]],
			$Failed,
			Messages:>{
				PlaceItems::NoPlacementsFound
			}
		],
		Example[{Basic,"Return Placements for a set of tube models into a tube rack using search conditions:"},
			PlaceItems[
				{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Hold[Name=="4-position Tube Rack"&&DeveloperObject==True]
			],
			{OrderlessPatternSequence[
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"A1"],
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"C1"],
				Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"D1"]
			]}
		],
		Example[{Basic,"Return Placements for groups of tube models into tube racks using search conditions:"},
			PlaceItems[
				{
					{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
					{Model[Container,Vessel,"2mL Tube"],Object[Container,Vessel,"2mL Tube to Place in Rack"]}
				},
				{
					Hold[Name=="4-position Tube Rack"&&DeveloperObject==True],
					Hold[Name=="4-position Tube Rack"&&DeveloperObject==True]
				}
			],
			{
				{OrderlessPatternSequence[
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"A1"],
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1"]
				]},
				{OrderlessPatternSequence[
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1"],
					Placement[Item->Object[Container,Vessel,"id:eGakldJ4808e"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"A1"]
				]}
			}
		],
		Example[{Basic,"A failure is returned if any of the search conditions yield no results:"},
			PlaceItems[
				{
					{Model[Container, Vessel, "2mL Tube"]},
					{Model[Container, Vessel,"2mL Tube"]}
				},
				{
					Hold[Name=="4-position Tube Rack"&&DeveloperObject==True],
					Hold[Name=="Non-Existent Tube Rack"&&DeveloperObject==True]
				}
			],
			$Failed,
			Messages:>{
				PlaceItems::NoRacksFound
			}
		],
		Example[{Additional,"All layouts available to a destination model are considered when looking for possible placements for an item group:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"]},Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]],
			{Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1",Layout->Model[DeckLayout,"id:Y0lXejM6vPeP"]]}
		],
		Example[{Additional,"Determine placements for multiple groups of items into different destinations:"},
			PlaceItems[
				{
					{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
					{Model[Container,Vessel,"2mL Tube"],Object[Container,Vessel,"2mL Tube to Place in Rack"]},
					{Model[Container,Vessel,"2mL Tube"]}
				},
				{
					Model[Container,Rack,"4-position Tube Rack"],
					Model[Container,Rack,"4-position Tube Rack"],
					Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]
				}
			],
			{
				{OrderlessPatternSequence[
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"A1"],
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"C1"],
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"D1"]
				]},
				{OrderlessPatternSequence[
					Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"B1"],
					Placement[Item->Object[Container,Vessel,"id:eGakldJ4808e"],Destination->Model[Container,Rack,"4-position Tube Rack"],Position->"A1"]
				]},
				{Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1",Layout->Model[DeckLayout,"id:Y0lXejM6vPeP"]]}
			}
		],
		Example[{Additional,"Pierce into nested layouts to determine whether the items to place can be accommodated by the destination:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"]},Model[Instrument,LiquidHandler,"Test Liquid Handler, Nested Layout"]],
			{Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1",Layout->Model[DeckLayout,"id:aXRlGn6xo1Ax"]]}
		],
		Example[{Options,Layout,"A deck layout may be provided as input when determining possible placements into a destination model with layouts:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"]},Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"],Layout->Model[DeckLayout,"Simple Layout for Test Liquid Handler"]],
			{Placement[Item->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Destination->Model[Container,Rack,"id:kEJ9mqR4PwNz"],Position->"B1",Layout->Model[DeckLayout,"Simple Layout for Test Liquid Handler"]]}
		],
		Example[{Options,LevelsDown,"Do not consider any Contents of a destination when looking for possible placement positions:"},
			PlaceItems[{Object[Container,Vessel,"2mL Tube to Place II"]},Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],LevelsDown->0],
			{Placement[Item->Object[Container,Vessel,"id:Y0lXejM6xeKv"],Destination->Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],Position->"Tube Slot 1"]}
		],
		Example[{Options,LevelsDown,"Request a number of times to consider contents of the destination when looking for placements:"},
			PlaceItems[{Object[Container,Vessel,"2mL Tube to Place II"]},Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],LevelsDown->1],
			{Placement[Item->Object[Container,Vessel,"id:Y0lXejM6xeKv"],Destination->Object[Container,Rack,"id:1ZA60vLXbE1q"],Position->"A1"]}
		],
		Example[{Options,OpenFootprint,"Allow consideration of Open Footprint positions when placing an item with a footprint:"},
			PlaceItems[{Model[Container,Plate,"96-well 2mL Deep Well Plate"]},Model[Container,Rack,"Single Open Position Rack"],OpenFootprint->True],
			{Placement[Item->Model[Container,Plate,"id:L8kPEjkmLbvW"],Destination->Model[Container,Rack,"Single Open Position Rack"],Position->"A1"]}
		],
		Example[{Messages,"InputLengthMismatch","Inputs must match in length:"},
			PlaceItems[{{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]}},{Model[Container,Rack,"4-position Tube Rack"],Model[Container,Rack,"4-position Tube Rack"]}],
			$Failed,
			Messages:>{
				PlaceItems::InputLengthMismatch
			}
		],
		Example[{Messages,"OptionLengthMismatch","MapThread options, when specified, must match length of input lists:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},Model[Container,Rack,"4-position Tube Rack"],OpenFootprint->{True,False}],
			$Failed,
			Messages:>{
				PlaceItems::OptionLengthMismatch
			}
		],
		Example[{Messages,"DuplicateItems","A message is provided to indicate that duplicated Objects within an item group have been ignored:"},
			PlaceItems[{Object[Container,Vessel,"2mL Tube to Place in Rack"],Object[Container,Vessel,"2mL Tube to Place in Rack"],Object[Container,Vessel,"2mL Tube to Place II"]},Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"]],
			{OrderlessPatternSequence[
				Placement[Item->Object[Container,Vessel,"id:eGakldJ4808e"],Destination->Object[Container,Rack,"id:1ZA60vLXbE1q"],Position->"A1"],
				Placement[Item->Object[Container,Vessel,"id:Y0lXejM6xeKv"],Destination->Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],Position->"Tube Slot 1"]
			]},
			Messages:>{
				PlaceItems::DuplicateItems
			}
		],
		Example[{Messages,"UnrecognizedLayout","A provided deck layout must be an available layout of the destination:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"]},Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"],Layout->Model[DeckLayout,"Plate Rack Sub-Layout"]],
			$Failed,
			Messages:>{
				PlaceItems::UnrecognizedLayout
			}
		],
		Example[{Messages,"NoPlacementsFound","A failure is returned if the item group cannot be placed at once into the destination:"},
			PlaceItems[{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},Model[Container,Rack,"4-position Tube Rack"]],
			$Failed,
			Messages:>{
				PlaceItems::NoPlacementsFound
			}
		]
	}
];



(* ::Subsection::Closed:: *)
(*Placement*)


DefineTests[
	Placement,
	{
		Example[{Basic,"Creates a Placement primitive:"},
			Placement[
				Item -> Object[Sample, "id:L8kPEjNGZZ7V"],
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"]
			],
			_Placement
		],
		Example[{Basic,"Fetch parameter by dereferencing the desired key:"},
			Placement[
				Item -> Object[Sample, "id:L8kPEjNGZZ7V"],
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"]
			][Destination],
			Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"]
		],
		Example[{Basic,"Specific Position and Layout values can be optionally specified:"},
			Placement[
				Item -> Object[Sample, "id:L8kPEjNGZZ7V"],
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"],
				Position -> "A1",
				Layout -> Model[DeckLayout,"Gilson Liquid Handler - Solid Phase Synthesis Configuration"]
			],
			_Placement
		],
		Example[{Messages,"InvalidPlacement","Throws a message if an extra key is provided:"},
			Placement[
				Item -> Object[Sample, "id:L8kPEjNGZZ7V"],
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"],
				Position -> "A1",
				Layout -> Model[DeckLayout,"Gilson Liquid Handler - Solid Phase Synthesis Configuration"],
				InvalidKey -> 3
			],
			$Failed,
			Messages:>{Placement::InvalidPlacement}
		],
		Example[{Messages,"InvalidPlacement","Throws a message if a key's value does not match PlacementP:"},
			Placement[
				Item -> 3,
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"],
				Position -> "A1",
				Layout -> Model[DeckLayout,"Gilson Liquid Handler - Solid Phase Synthesis Configuration"]
			],
			$Failed,
			Messages:>{Placement::InvalidPlacement}
		],
		Example[{Messages,"InsufficientParameters","Throws a message Item and Destination keys are not specified:"},
			Placement[
				Destination -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"],
				Position -> "A1",
				Layout -> Model[DeckLayout,"Gilson Liquid Handler - Solid Phase Synthesis Configuration"]
			],
			$Failed,
			Messages:>{Placement::InsufficientParameters}
		],
		Example[{Messages,"InsufficientParameters","Throws a message if no keys are provided:"},
			Placement[],
			$Failed,
			Messages:>{Placement::InsufficientParameters}
		]
	}
];


(* ::Subsection::Closed:: *)
(*openLocations*)


DefineTests[
	openLocations,
	{
		Example[{Basic,"Returns all locations in a model:"},
			openLocations[Model[Container,Rack,"4-position Tube Rack"]],
			{{ObjectP[],LocationPositionP}..}
		],
		Example[{Basic,"Returns all open locations in an object:"},
			openLocations[Object[Instrument, VerticalLift, "Vertical Lift with Plate/Tube Positions"]],
			{{ObjectP[],LocationPositionP}..}
		],
		Example[{Basic,"Returns all locations in an object that can fit a particular object:"},
			openLocations[
				Object[Instrument, VerticalLift, "Vertical Lift with Plate/Tube Positions"],
				Object[Container, Vessel, "2mL Tube to Place in Rack"]
			],
			{{ObjectP[],LocationPositionP}..}
		],
		Example[{Additional,"Returns all locations in a model that can fit a particular model:"},
			openLocations[
				Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"],
				Model[Container,Vessel,"2mL Tube"]
			],
			{{ObjectP[],LocationPositionP}..}
		],
		Example[{Additional,"The function will pierce into nested layouts to determine whether the items to place can be accommodated by the destination:"},
			openLocations[
				Model[Instrument,LiquidHandler,"Test Liquid Handler, Nested Layout"],
				Model[Container,Vessel,"2mL Tube"]
			],
			{{ObjectP[],LocationPositionP}..}
		],

		Example[{Additional,"Return all unoccupied positions in a rack that can accommodate a 2mL tube:"},
			openLocations[
				Object[Container,Rack,"Empty 4-position Rack"],
				Object[Container,Vessel,"2mL Tube to Place in Rack"]
			],
			{
				{Object[Container,Rack,"Empty 4-position Rack"],"A1"},
				{Object[Container,Rack,"Empty 4-position Rack"],"B1"},
				{Object[Container,Rack,"Empty 4-position Rack"],"C1"},
				{Object[Container,Rack,"Empty 4-position Rack"],"D1"}
			}
		],
		Example[{Additional,"An empty list is returned if the provided destination has no positions that can fit the desired item:"},
			openLocations[
				Object[Container,Rack,"Empty 4-position Rack"],
				Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			{}
		],
		Example[{Additional,"If multiple layouts exist in a model's AvailableLayouts, a layout must be specified:"},
			openLocations[
				Model[Instrument, LiquidHandler, "Test Liquid Handler with Multiple Layouts"],
				Model[Container,Vessel,"2mL Tube"],
				Model[DeckLayout, "id:9RdZXv1WDb36"]
			],
			{{Model[Container, Rack, "id:kEJ9mqR4PwNz"], "A1"}, {Model[Container, Rack, "id:kEJ9mqR4PwNz"], "B1"}, {Model[Container, Rack, "id:kEJ9mqR4PwNz"], "C1"}, {Model[Container, Rack, "id:kEJ9mqR4PwNz"], "D1"}}
		],
		Example[{Options,LevelsDown,"Indicate that a position set can be found by looking at the destination's contents layers a number of times:"},
			openLocations[
				Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				LevelsDown->0
			],
			{
				{Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],"Plate Slot 1"}
			}
		],
		Example[{Options,LevelsDown,"By default, open positions are found by looking at all layers of contents of the destination container:"},
			openLocations[
				Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],
				Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			{
				{Object[Instrument,VerticalLift,"Vertical Lift with Plate/Tube Positions"],"Plate Slot 1"},
				{Object[Container,Rack,"id:pZx9jo8AJpX5"],"A1"},
				{Object[Container,Rack,"id:pZx9jo8AJpX5"],"B1"},
				{Object[Container,Rack,"id:pZx9jo8AJpX5"],"C1"},
				{Object[Container,Rack,"id:pZx9jo8AJpX5"],"D1"}
			}
		],
		Example[{Options,OpenFootprint,"Exclude consideration of Open-footprint positions when placing an item with a footprint:"},
			openLocations[
				Model[Container,Rack,"Single Open Position Rack"],
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				OpenFootprint->False
			],
			{}
		],
		Example[{Options,OpenFootprint,"Allow consideration of Open Footprint positions when placing an item with a footprint:"},
			openLocations[
				Model[Container,Rack,"Single Open Position Rack"],
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				OpenFootprint->True
			],
			{{Model[Container,Rack,"Single Open Position Rack"],"A1"}}
		],
		Example[{Messages,"InputLengthMismatch","Input lists must have matching lengths:"},
			openLocations[
				{Model[Container,Rack,"4-position Tube Rack"]},
				{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]}
			],
			$Failed,
			Messages:>{openLocations::InputLengthMismatch}
		],
		Example[{Messages,"OptionLengthMismatch","Option lists must have matching lengths:"},
			openLocations[
				{Model[Container,Rack,"4-position Tube Rack"]},
				{Model[Container,Vessel,"2mL Tube"]},
				LevelsDown -> {1,3}
			],
			$Failed,
			Messages:>{openLocations::OptionLengthMismatch}
		],
		Example[{Messages,"TooManyLayouts","If multiple layouts exist in a model's AvailableLayouts and a layout is not specified, an error is thrown:"},
			openLocations[
				Model[Instrument, LiquidHandler, "Test Liquid Handler with Multiple Layouts"],
				Model[Container,Vessel,"2mL Tube"]
			],
			$Failed,
			Messages:>{openLocations::TooManyLayouts}
		],
		Example[{Messages,"UnrecognizedLayout","If a layout is provided that does not exist in the AvailableLayouts field of the destination model, an error is thrown:"},
			openLocations[
				Model[Instrument, LiquidHandler, "Test Liquid Handler with Multiple Layouts"],
				Model[Container,Vessel,"2mL Tube"],
				Model[DeckLayout, "id:Y0lXejM6vPeP"]
			],
			$Failed,
			Messages:>{openLocations::UnrecognizedLayout}
		],
		(* Following was added post bug report caused by trying to pull Contents fields out of Object[Part,OpticModule] *)
		Test["Doesn't choke when the Contents tree contains Object[Part]s:",
			openLocations[
				{Object[Instrument,PlateReader,"Pherastar FS"]},
				{Object[Container,Vessel,"id:qdkmxzq0x6l4"]},
				{Model[DeckLayout,"id:L8kPEjnNaJ6P"]}
			],
			{{}}
		]
	}
];



(* ::Subsection::Closed:: *)
(*validPlacementQ*)

DefineTests[
	validPlacementQ,
	{
		Example[{Basic,"Determines if the placement of a model into a destination model is possible:"},
			validPlacementQ[
				Model[Container,Vessel,"2mL Tube"],
				Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]
			],
			True
		],
		Example[{Basic,"Allows objects to be used in prospective placement:"},
			validPlacementQ[
				Object[Container, Vessel, "2mL Tube to Place in Rack"],
				Object[Instrument, VerticalLift, "Vertical Lift with Plate/Tube Positions"]
			],
			True
		],
		Example[{Basic,"Determines if the placement of an item into a destination is possible:"},
			validPlacementQ[
				Model[Container,Vessel,"2mL Tube"],
				{Model[Container, Rack, "id:kEJ9mqR4PwNz"],"A1"}
			],
			True
		],
		Example[{Additional,"Accepts Placement symbolic representations as input:"},
			validPlacementQ[
				Placement[
					Item -> Model[Container,Vessel,"2mL Tube"],
					Destination -> Model[Container, Rack, "id:kEJ9mqR4PwNz"],
					Position -> "A1"
				]
			],
			True
		],
		Example[{Additional,"Determines if multiple items can be placed on a single destination:"},
			validPlacementQ[
				{Model[Container,Vessel,"2mL Tube"],Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
				Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]
			],
			True
		],
		Example[{Additional,"Returns False if the provided destination has no positions that can fit the desired item:"},
			validPlacementQ[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				Model[Container, Rack, "id:kEJ9mqR4PwNz"]
			],
			False
		],
		Example[{Options,Layout,"A Model[DeckLayout] can be specified:"},
			validPlacementQ[
				Model[Container,Vessel,"2mL Tube"],
				Model[Instrument, LiquidHandler, "Test Liquid Handler with Multiple Layouts"],
				Layout -> Model[DeckLayout, "id:9RdZXv1WDb36"]
			],
			True
		],
		Example[{Options,LevelsDown,"Indicate the number of layers of contents that should be traversed in search of a valid placement in the destination:"},
			validPlacementQ[
				Model[Container,Vessel,"2mL Tube"],
				Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"],
				LevelsDown->0
			],
			False
		],
		Example[{Options,OpenFootprint,"Allow consideration of Open Footprint positions when placing an item with a footprint:"},
			validPlacementQ[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				Model[Container,Rack,"Single Open Position Rack"],
				OpenFootprint->True
			],
			True
		],
		Example[{Options,OpenFootprint,"By default, positions with an Open footprint is not considered valid:"},
			validPlacementQ[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				Model[Container,Rack,"Single Open Position Rack"]
			],
			False
		],
		Example[{Messages,"InputLengthMismatch","Inputs must match in length:"},
			validPlacementQ[
				{{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]}},
				{Model[Container,Rack,"4-position Tube Rack"],Model[Container,Rack,"4-position Tube Rack"]}
			],
			$Failed,
			Messages:>{validPlacementQ::InputLengthMismatch}
		],
		Example[{Messages,"OptionLengthMismatch","MapThread options, when specified, must match length of input lists:"},
			validPlacementQ[
				{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Model[Container,Rack,"4-position Tube Rack"],
				OpenFootprint->{True,False}
			],
			$Failed,
			Messages:>{validPlacementQ::OptionLengthMismatch}
		],
		Example[{Additional,"If the destination has fewer positions than required for all items, returns False:"},
			validPlacementQ[
				{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]
			],
			False
		],
		Example[{Additional,"Listable inputs are accepted:"},
			validPlacementQ[
				{
					{Model[Container,Vessel,"2mL Tube"]},
					{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]}
				},
				{
					Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"],
					Model[Instrument,LiquidHandler,"Test Liquid Handler with Simple Layout"]
				}
			],
			{True,False}
		]
	}
];


(* ::Subsection::Closed:: *)
(*PlotLocation*)


(* ::Subsubsection::Closed:: *)
(*PlotLocation*)


DefineTests[
	PlotLocation,
	{
		(* --- Basic --- *)
		Example[{Basic,"Plot the location of an instrument in the context of the building that holds it:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot the location of two objects within the same building:"},
			PlotLocation[{Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Object[Instrument, HPLC, "PlotLocation test HPLC"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plotting the location of a building plots the building itself:"},
			PlotLocation[Object[Container, Building,"PlotLocation test building"<>$SessionUUID]],
			_?ValidGraphicsQ
		],

		(* --- Additional --- *)
		Example[{Additional, "If a valid position is specified, its parent container is plotted and the position highlighted:"},
			PlotLocation[{Object[Container, Shelf, "PlotLocation test shelf 1"<>$SessionUUID], "Slot 1"}],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Multiple items whose containers or contents overlap given the provided 'Levels'/'Nearest' options can be plotted together, generating a single plot:"},
			PlotLocation[{Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Object[Container, Bench, "PlotLocation test bench 3"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],

		(* --- Options --- *)
		Example[{Options,LevelsDown,"Specify how many levels of contents within the provided object will be displayed:"},
			PlotLocation[Object[Container, Shelf, "PlotLocation test shelf 1"<>$SessionUUID],LevelsDown->2],
			_?ValidGraphicsQ
		],
		Example[{Options,LevelsUp,"Specify how many levels of containers enclosing the provided object will be displayed:"},
			PlotLocation[Object[Container, Shelf, "PlotLocation test shelf 1"<>$SessionUUID],LevelsUp->2],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestUp,"Plot the requested object, traversing the containers enclosing the provided object until reaching an object of a given type:"},
			PlotLocation[Object[Container, Shelf, "PlotLocation test shelf 1"<>$SessionUUID],NearestUp->Object[Container,Room]],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestDown,"Plot the requested object, traversing the contents of the provided object until reaching an object of a given type:"},
			PlotLocation[Object[Container, Shelf, "PlotLocation test shelf 1"<>$SessionUUID],NearestDown->Object[Instrument]],
			_?ValidGraphicsQ
		],
		Example[{Options, Map, "Separate plots can be generated for each member of listed input using the Map->True:"},
			PlotLocation[{Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Object[Container, Bench, "PlotLocation test bench 3"<>$SessionUUID]}, Map -> True],
			{Repeated[_?ValidGraphicsQ,{2}]}
		],
		Example[{Options, Map, "If Map->False and a list of items is supplied, a single plot is returned if the items' containers or contents overlap given the provided 'Levels'/'Nearest' options:"},
			PlotLocation[{Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Object[Container, Bench, "PlotLocation test bench 3"<>$SessionUUID]}, Map -> False],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotType, "Plot the location of an instrument in the context of the building that holds it in 3D:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], PlotType->Plot3D],
			_?ValidGraphicsQ
		],
		Example[{Options, ImageSize, "Change the size of the output plot:"},
			PlotLocation[Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], ImageSize -> 1000],
			_?ValidGraphicsQ
		],
		Example[{Options, Axes, "Turn off display of axes around the output plot:"},
			PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], Axes->False],
			_?ValidGraphicsQ
		],
		Example[{Options, TargetUnits, "Set the units in which the plot will be displayed:"},
			PlotLocation[Object[Instrument, HPLC, "PlotLocation test HPLC"<>$SessionUUID], TargetUnits->Kilo Meter],
			_?ValidGraphicsQ
		],
		Example[{Options, Highlight, "Highlight one or more items or positions:"},
			PlotLocation[Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Highlight -> {Object[Container, Room, "PlotLocation test room"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightInput, "If HighlightInput -> False, input items will not automatically be highlighted:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], HighlightInput->False],
			_?ValidGraphicsQ
		],
		Example[{Options, LabelPositions, "Draw text labels direction within plotted positions:"},
			PlotLocation[Object[Container, Building,"PlotLocation test building"<>$SessionUUID], LabelPositions->True],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightStyle, "Modify the Style options applied to highlighted items:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], HighlightStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, ContainerStyle, "Modify the Style options applied to container graphics:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], ContainerStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, PositionStyle, "Modify the Style options applied to position graphics:"},
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], PositionStyle->{Orange}],
			_?ValidGraphicsQ
		],
		Example[{Options, LiveDisplay, "Allow clicking on containers to refocus the output plot:"},
			PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], LiveDisplay->True],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotRange, "Specify the PlotRange of the container plot:"},
			PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], PlotRange->{{0 Meter, 10 Meter},{0 Meter, 10 Meter}}],
			_?ValidGraphicsQ
		],

		(* --- Messages --- *)
		Example[{Messages, "IncompatibleOptions", "If two mutually exclusive option values are specified, an error is displayed and the conflict is resolved automatically:"},
			PlotLocation[Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], PlotType->Plot3D, LiveDisplay->True],
			_?ValidGraphicsQ,
			Messages :> {PlotLocation::IncompatibleOptions}
		],
		Example[{Messages, "ObjectNotFound", "If an object is supplied that is not in the database, an error is displayed and execution is aborted:"},
			PlotLocation[Object[Container, Bench, "DoesNotExist"]],
			$Failed,
			Messages :> {PlotLocation::ObjectNotFound}
		],
		Example[{Messages, "DisconnectedGraph", "If Map->False and the list of provided items do not have overlapping containers or contents given the provided 'Levels'/'Nearest' options, a warning is displayed:"},
			PlotLocation[{Object[Container, Floor, "PlotLocation test floor 3" <> $SessionUUID], Object[Container, Shelf,"PlotLocation test shelf 1"<>$SessionUUID]}, Map->False],
			{Repeated[_?ValidGraphicsQ, {2}]},
			Messages :> {PlotLocation::DisconnectedGraph},
			TimeConstraint -> 120
		],
		Example[{Messages, "ModelNotFound", "If a provided item or an item in its containers or contents has no Model, an error is returned:"},
			PlotLocation[Object[Container, Vessel,"PlotLocation test vessel no model"<>$SessionUUID]],
			$Failed,
			Messages :> {PlotLocation::ModelNotFound}
		],
		Example[{Messages, "MismatchedUnits", "If TargetUnits is specified as a list and the elements do not match, a warning is displayed:"},
			PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], TargetUnits->{Foot, Meter}],
			_?ValidGraphicsQ,
			Messages :> {PlotLocation::MismatchedUnits}
		],
		Example[{Messages, "InvalidObject", "If an input or one of its containers or contents is missing fields required for plotting, an error is returned:"},
			PlotLocation[Object[Container,Room,"PlotLocation test room 2"<>$SessionUUID]],
			$Failed,
			Messages :> {PlotLocation::InvalidObject}
		],
		Example[{Messages, "InvalidPosition", "Contents with Positions that do not appear in their container's model are reported and excluded from plotting:"},
			PlotLocation[Object[Container, Room, "PlotLocation test room"<>$SessionUUID]],
			_?ValidGraphicsQ,
			Messages :> {PlotLocation::InvalidPosition},
			SetUp :> {Upload[<|Object->Object[Container, Room, "PlotLocation test room"<>$SessionUUID], Position->"Nonexistent Slot"|>]},
			TearDown :> {Upload[<|Object->Object[Container, Room, "PlotLocation test room"<>$SessionUUID], Position->"ECL-2 Lab Slot"|>]}
		],


		(* --- TESTS --- *)
		Test["Listed position input is handled appropriately:",
			PlotLocation[{{Object[Container, Plate, "PlotLocation test plate"<>$SessionUUID],"A1"}, {Object[Container, Plate, "PlotLocation test plate"<>$SessionUUID],"H12"}}],
			_?ValidGraphicsQ
		],
		Test["Highlighting still works properly when referring to an item by Name rather than ID:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotLocation[Object[Container, Plate, "PlotLocation test plate"<>$SessionUUID], Highlight->{{Object[Container, Plate, "PlotLocation test plate"<>$SessionUUID],"A1"}}, HighlightInput->False],
				Darker[Green],
				Infinity
			]],
			GreaterP[0]
		],
		Test["HighlightStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], HighlightStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}, LiveDisplay -> False],
				EdgeForm[{Orange, Dashed}],
				Infinity
			]],
			GreaterP[0]
		],
		Test["ContainerStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], ContainerStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}, LiveDisplay -> False],
				EdgeForm[{Orange, Dashed}],
				Infinity
			]],
			GreaterP[0]
		],
		Test["HighlightStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotLocation[Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID], PositionStyle->{Orange}, LiveDisplay -> False],
				Orange,
				Infinity
			]],
			GreaterP[0]
		],
		Test["NearestUp terminates at the appropriate level, excluding the Building:",
			Length[Cases[
				PlotLocation[Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID],NearestUp->Object[Container,Floor]],
				Object[Container, Building, "PlotLocation test building"<>$SessionUUID],
				Infinity
			]],
			0
		],
		Test["NearestUp terminates at the appropriate level, including the Floor:",
			Length[Cases[
				PlotLocation[Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID],NearestUp->Object[Container,Floor]],
				Object[Container, Floor, "PlotLocation test floor"<>$SessionUUID],
				Infinity
			]],
			0
		],
		Test["NearestDown terminates at the appropriate level, including the benches:",
			Length[Cases[
				PlotLocation[Object[Container, Building, "PlotLocation test building"<>$SessionUUID], NearestDown -> Object[Container, Bench]],
				ObjectP[Object[Container, Bench]],
				Infinity
			]],
			GreaterP[0]
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->True:",
			PlotLocation[{Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Object[Container, Shelf,"PlotLocation test shelf 1"<>$SessionUUID]}, LevelsUp->0, LevelsDown->2, Map->True],
			{Repeated[_?ValidGraphicsQ,{2}]}
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->False and they are the only input:",
			PlotLocation[Object[Container, Shelf,"PlotLocation test shelf 1"<>$SessionUUID], LevelsUp->0, LevelsDown->2, Map->False],
			_?ValidGraphicsQ
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->False and other non-bare inputs exist:",
			PlotLocation[{Object[Container, Bench, "PlotLocation test bench 2"<>$SessionUUID], Object[Container, Shelf,"PlotLocation test shelf 1"<>$SessionUUID]}, LevelsUp->0, LevelsDown->2, Map->False],
			{Repeated[_?ValidGraphicsQ,{2}]},
			Messages :> {PlotLocation::DisconnectedGraph}
		],
		Test["Level spec 'All' is properly resolved to 'Infinity':",
			PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], LevelsDown->All],
			ValidGraphicsP[]
		],
		Test["If asked to highlight an item that is in the container tree but below the levels being displayed, the smallest item being displayed that contains the requested object will be highlighted:",
			Length[Cases[
				PlotLocation[Object[Container, Bench, "PlotLocation test bench 2" <> $SessionUUID], Highlight -> {Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID]}, HighlightInput -> False],
				Darker[Green],
				Infinity
			]],
			GreaterP[0]
		],
		Test["If asked to highlight a position in an object that is in the container tree but below the levels being displayed, the smallest item being displayed that contains the requested object will be highlighted:",
			Length[Cases[
				PlotLocation[Object[Container, Bench, "PlotLocation test bench 2" <> $SessionUUID], Highlight -> {{Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID],"Deck Slot"}}, HighlightInput -> False],
				Darker[Green],
				Infinity
			]],
			GreaterP[0]
		],
		Test["If asked to highlight an item that is not in the query container tree at all, nothing is highlighted:",
			Length[Cases[
				PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Highlight -> {Object[Container, Building,"PlotLocation test building 3"<>$SessionUUID]}, HighlightInput -> False],
				Darker[Green],
				Infinity
			]],
			0
		],
		Test["If HighlightInput->Automatic and other objects or positions have been specified for highlighting, input is not highlighted:",
			Length[Cases[
				PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Highlight -> {Object[Container, Building,"PlotLocation test building"<>$SessionUUID]}, HighlightInput->Automatic],
				Darker[Green],
				Infinity
			]],
			2
		],
		Test["If HighlightInput->Automatic and no other objects or positions have been specified for highlighting, input is highlighted:",
			Length[Cases[
				PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Highlight -> {}, HighlightInput->Automatic],
				Darker[Green],
				Infinity
			]],
			2
		],
		Test["If HighlightInput->True, input is highlighted regardless of whether other objects or positions have been specified for highlighting:",
			Length[Cases[
				PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Highlight -> {Object[Container, Building,"PlotLocation test building"<>$SessionUUID]}, HighlightInput->True],
				Darker[Green],
				Infinity
			]],
			4
		],
		Test["If HighlightInput->False, input is not highlighted regardless of whether other objects or positions have been specified for highlighting:",
			Length[Cases[
				PlotLocation[Object[Instrument, LiquidHandler, "PlotLocation test liquid handler"<>$SessionUUID], Highlight -> {}, HighlightInput->False],
				Darker[Green],
				Infinity
			]],
			0
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,uploads},
			$CreatedObjects = {};

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Room,"PlotLocation test room"<>$SessionUUID],
				Object[Container,Room,"PlotLocation test room 2"<>$SessionUUID],
				Model[Container,Room,"PlotLocation test room model"<>$SessionUUID],
				Model[Container,Floor,"PlotLocation test floor model"<>$SessionUUID],
				Object[Container,Floor,"PlotLocation test floor"<>$SessionUUID],
				Object[Container,Floor,"PlotLocation test floor 2"<>$SessionUUID],
				Object[Container,Floor,"PlotLocation test floor 3"<>$SessionUUID],
				Model[Container,Building,"PlotLocation test building model"<>$SessionUUID],
				Object[Container,Building,"PlotLocation test building"<>$SessionUUID],
				Object[Container,Building,"PlotLocation test building 2"<>$SessionUUID],
				Object[Container,Building,"PlotLocation test building 3"<>$SessionUUID],
				Object[Container,Bench,"PlotLocation test bench"<>$SessionUUID],
				Object[Container,Bench,"PlotLocation test bench 1"<>$SessionUUID],
				Object[Container,Bench,"PlotLocation test bench 2"<>$SessionUUID],
				Object[Container,Bench,"PlotLocation test bench 3"<>$SessionUUID],
				Object[Container,Bench,"PlotLocation test bench with enclosure"<>$SessionUUID],
				Object[Container, Enclosure,"PlotLocation test enclosure"<>$SessionUUID],
				Object[Container,Shelf,"PlotLocation test shelf 1"<>$SessionUUID],
				Object[Instrument,HPLC,"PlotLocation test HPLC"<>$SessionUUID],
				Object[Instrument,LiquidHandler,"PlotLocation test liquid handler"<>$SessionUUID],
				Object[Plumbing,Tubing,"PlotLocation test tubing"<>$SessionUUID],
				Object[Plumbing,Cap,"PlotLocation test cap"<>$SessionUUID],
				Object[Container, OperatorCart,"PlotLocation test cart"<>$SessionUUID],
				Object[Container, Vessel,"PlotLocation test vessel no model"<>$SessionUUID],
				Object[Container, Plate,"PlotLocation test plate"<>$SessionUUID],
				Object[Container, Floor,"PlotLocation test floor invalid object"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(*Make a room/building/floor models*)
		Upload[{
			<|
				Type->Model[Container,Room],
				Name->"PlotLocation test room model"<>$SessionUUID,
				DeveloperObject->True,
				Replace[PositionPlotting]->{
					<|Name -> "Bench Slot 1", XOffset -> Quantity[7.62, "Meters"], YOffset -> Quantity[5.7912, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 2", XOffset -> Quantity[9.4488, "Meters"], YOffset -> Quantity[5.7912, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 3", XOffset -> Quantity[11.2776, "Meters"], YOffset -> Quantity[5.7912, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 4", XOffset -> Quantity[13.1064, "Meters"], YOffset -> Quantity[5.7912, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 5", XOffset -> Quantity[7.62, "Meters"], YOffset -> Quantity[3.6576, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 6", XOffset -> Quantity[9.4488, "Meters"], YOffset -> Quantity[3.6576, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 7", XOffset -> Quantity[11.2776, "Meters"], YOffset -> Quantity[3.6576, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Bench Slot 8", XOffset -> Quantity[13.1064, "Meters"], YOffset -> Quantity[3.6576, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "NMR Slot 1", XOffset -> Quantity[11.8872, "Meters"], YOffset -> Quantity[1.524, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Circle, Rotation -> 0.|>,
					<|Name -> "NMR Slot 2", XOffset -> Quantity[9.144, "Meters"], YOffset -> Quantity[1.524, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Circle, Rotation -> 0.|>
				},
				Replace[Positions]->{
					<|Name -> "Bench Slot 1", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 2", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 3", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 4", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 5", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 6", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 7", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Bench Slot 8", Footprint -> Open, MaxWidth -> Quantity[1.8288, "Meters"], MaxDepth -> Quantity[0.9144, "Meters"], MaxHeight -> Null|>,
					<|Name -> "NMR Slot 1", Footprint -> Open, MaxWidth -> Quantity[2.4384, "Meters"], MaxDepth -> Quantity[2.4384, "Meters"], MaxHeight -> Null|>,
					<|Name -> "NMR Slot 2", Footprint -> Open, MaxWidth -> Quantity[2.4384, "Meters"], MaxDepth -> Quantity[2.4384, "Meters"], MaxHeight -> Null|>
				}
			|>,
			<|
				Type->Model[Container,Floor],
				Name->"PlotLocation test floor model"<>$SessionUUID,
				DeveloperObject->True,
				Replace[PositionPlotting]->{
					<|Name -> "Room Slot 1", XOffset -> Quantity[3.3528, "Meters"], YOffset -> Quantity[8.8392, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Room Slot 2", XOffset -> Quantity[8.5344, "Meters"], YOffset -> Quantity[8.8392, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Room Slot 3", XOffset -> Quantity[11.5824, "Meters"], YOffset -> Quantity[8.8392, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Room Slot 4", XOffset -> Quantity[7.9248, "Meters"], YOffset -> Quantity[3.2004, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>
				},
				Replace[Positions]->{
					<|Name -> "Room Slot 1", Footprint -> Open, MaxWidth -> Quantity[6.7056, "Meters"], MaxDepth -> Quantity[3.048, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Room Slot 2", Footprint -> Open, MaxWidth -> Quantity[3.048, "Meters"], MaxDepth -> Quantity[3.048, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Room Slot 3", Footprint -> Open, MaxWidth -> Quantity[3.048, "Meters"], MaxDepth -> Quantity[3.048, "Meters"], MaxHeight -> Null|>,
					<|Name -> "Room Slot 4", Footprint -> Open, MaxWidth -> Quantity[15.8496, "Meters"], MaxDepth -> Quantity[6.4008, "Meters"], MaxHeight -> Null|>
				}
			|>,
			<|
				Type->Model[Container,Building],
				Name->"PlotLocation test building model"<>$SessionUUID,
				DeveloperObject->True,
				Replace[PositionPlotting]->{
					<|Name -> "First Floor Slot", XOffset -> Quantity[7.9248, "Meters"], YOffset -> Quantity[5.1816, "Meters"], ZOffset -> Quantity[0., "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>,
					<|Name -> "Second Floor Slot", XOffset -> Quantity[7.9248, "Meters"], YOffset -> Quantity[5.1816, "Meters"], ZOffset -> Quantity[3.6576, "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>
				},
				Replace[Positions]->{
					<|Name -> "First Floor Slot", Footprint -> Open, MaxWidth -> Quantity[15.8496, "Meters"], MaxDepth -> Quantity[10.3632, "Meters"], MaxHeight -> Quantity[3.048, "Meters"]|>,
					<|Name -> "Second Floor Slot", Footprint -> Open, MaxWidth -> Quantity[15.8496, "Meters"], MaxDepth -> Quantity[10.3632, "Meters"], MaxHeight -> Quantity[3.048, "Meters"]|>
				}
			|>
		}];

		Upload[{
			<|Type->Object[Container,Building],
				Model->Link[Model[Container,Building,"ECL-2"],Objects],
				Name->"PlotLocation test building"<>$SessionUUID
			|>,
			<|Type->Object[Container,Building],
				Model->Link[Model[Container,Building,"ECL-2"],Objects],
				Name->"PlotLocation test building 2"<>$SessionUUID
			|>,
			<|Type->Object[Container,Building],
				Model->Link[Model[Container,Building,"ECL-2"],Objects],
				Name->"PlotLocation test building 3"<>$SessionUUID
			|>,
			<|Type->Object[Instrument,HPLC],
				Model->Link[Model[Instrument,HPLC,"Waters Acquity UPLC H-Class FLR"],Objects],
				Name->"PlotLocation test HPLC"<>$SessionUUID
			|>,
			<|Type->Object[Instrument,LiquidHandler],
				Model->Link[Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"],Objects],
				Name->"PlotLocation test liquid handler"<>$SessionUUID
			|>,
			<|Type->Object[Container, OperatorCart],
				Model->Link[Model[Container, OperatorCart,"Chemistry Lab Cart"],Objects],
				Name->"PlotLocation test cart"<>$SessionUUID
			|>,
			<|Type->Object[Container, Vessel],
				Name-> "PlotLocation test vessel no model"<>$SessionUUID
			|>
		}];

		(*Make some things to set up or fake room*)
		ECL`InternalUpload`UploadSample[
			{
				Model[Container, Floor,"ECL-2 First Floor"],
				Model[Container, Floor,"PlotLocation test floor model"<>$SessionUUID],
				Model[Container, Floor,"ECL-2 First Floor"]
			},
			{
				{"First Floor Slot", Object[Container,Building,"PlotLocation test building"<>$SessionUUID]},
				{"First Floor Slot", Object[Container,Building,"PlotLocation test building 2"<>$SessionUUID]},
				{"First Floor Slot", Object[Container,Building,"PlotLocation test building 3"<>$SessionUUID]}
			},
			Name->{
				"PlotLocation test floor"<>$SessionUUID,
				"PlotLocation test floor 2"<>$SessionUUID,
				"PlotLocation test floor 3"<>$SessionUUID
			},
			StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
			FastTrack->True
		];

		ECL`InternalUpload`UploadSample[
			{
				Model[Container, Room, "Chemistry Lab"],
				Model[Container, Room, "PlotLocation test room model"<>$SessionUUID]
			},
			{
				{"ECL-2 Lab Slot", Object[Container,Floor,"PlotLocation test floor"<>$SessionUUID]},
				{"Room Slot 1", Object[Container,Floor,"PlotLocation test floor 2"<>$SessionUUID]}
			},
			Name->{
				"PlotLocation test room"<>$SessionUUID,
				"PlotLocation test room 2"<>$SessionUUID
			},
			StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
			FastTrack->True
		];

		ECL`InternalUpload`UploadSample[
			Table[
				Model[Container, Bench, "The Bench of Testing"],
				3
			],
			{
				{"Bench Slot 4", Object[Container,Room,"PlotLocation test room"<>$SessionUUID]},
				{"Bench Slot 5", Object[Container,Room,"PlotLocation test room"<>$SessionUUID]},
				{"Bench Slot 6", Object[Container,Room,"PlotLocation test room"<>$SessionUUID]}
			},
			Name->{
				"PlotLocation test bench 1"<>$SessionUUID,
				"PlotLocation test bench 2"<>$SessionUUID,
				"PlotLocation test bench 3"<>$SessionUUID
			},
			StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
			FastTrack->True
		];

		ECL`InternalUpload`UploadSample[
			{
				Model[Container, Shelf, "id:kEJ9mqaVPPVp"],
				Model[Plumbing,Tubing,"PharmaPure #17"],
				Model[Plumbing, Cap, "id:4pO6dM5qEmXz"],
				Model[Container, Plate, "id:kEJ9mqRXALxE"]
			},
			{
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 1"<>$SessionUUID]},
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 1"<>$SessionUUID]},
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 1"<>$SessionUUID]},
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 2"<>$SessionUUID]}
			},
			Name->{
				"PlotLocation test shelf 1"<>$SessionUUID,
				"PlotLocation test tubing"<>$SessionUUID,
				"PlotLocation test cap"<>$SessionUUID,
				"PlotLocation test plate"<>$SessionUUID
			},
			StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
			FastTrack->True
		];

		uploads=ECL`InternalUpload`UploadLocation[
			{
				Object[Instrument,HPLC,"PlotLocation test HPLC"<>$SessionUUID],
				Object[Instrument,LiquidHandler,"PlotLocation test liquid handler"<>$SessionUUID],
				Object[Container,Vessel,"PlotLocation test vessel no model"<>$SessionUUID]
			},
			{
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 2"<>$SessionUUID]},
				{"Lower Shelf Slot", Object[Container,Bench,"PlotLocation test bench 2"<>$SessionUUID]},
				{"Bench Top Slot", Object[Container,Bench,"PlotLocation test bench 1"<>$SessionUUID]}
			},
			FastTrack->True,
			Upload->False
		];
		Upload[
			Join[
				uploads,
				{
					<|
						Object->Object[Instrument,HPLC,"PlotLocation test HPLC"<>$SessionUUID],
						DeveloperObject->True
					|>,
					<|
						Object->Object[Instrument,LiquidHandler,"PlotLocation test liquid handler"<>$SessionUUID],
						DeveloperObject->True
					|>
				}
			]
		];

		];
	},
	SymbolTearDown:>{
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False];

		Unset[$CreatedObjects];
	}
];


(* ::Subsubsection::Closed:: *)
(*rotatePrimitive*)


DefineTests[
	rotatePrimitive,
	{
		Test["Test rotation of a point about the origin in 2D:",
			rotatePrimitive[
				{1,1},
				{0,0},
				90 Degree
			],
			{-1,1}
		],
		Test["Test rotation of a point about another non-origin point in 2D:",
			rotatePrimitive[
				{1,1},
				{2,2},
				90 Degree
			],
			{3,1}
		],
		Test["Test rotation of a simple polygon about the origin in 2D:",
			rotatePrimitive[
				Polygon[{{0,0},{0,1},{1,1},{1,0}}],
				{0,0},
				90 Degree
			],
			Polygon[{{0,0},{-1,0},{-1,1},{0,1}}]
		],
		Test["Test rotation of a complex polygon (multiple polygons in deeper lists) about the origin in 2D:",
			rotatePrimitive[
				Polygon[{
					{{0,0},{0,1},{1,1},{1,0}},
					{{0,0},{0,1},{1,1},{1,0}}
				}],
				{0,0},
				90 Degree
			],
			Polygon[{{{0,0},{-1,0},{-1,1},{0,1}},{{0,0},{-1,0},{-1,1},{0,1}}}]
		],
		Test["Test rotation of a Rectangle about a point in 2D:",
			rotatePrimitive[
				Rectangle[
					{0,0},
					{1,1}
				],
				{2,1},
				90 Degree
			],
			Rectangle[{3,-1},{2,0}]
		],
		Test["Test rotation of a Circle about the origin in 2D:",
			rotatePrimitive[
				Circle[{1,1},1],
				{0,0},
				90 Degree
			],
			Circle[{-1,1},1]
		],
		Test["Test rotation of a Disk about the origin in 2D:",
			rotatePrimitive[
				Disk[{1,1},1],
				{0,0},
				90 Degree
			],
			Disk[{-1,1},1]
		],
		Test["Test rotation of a Circle with extra arguments about the origin in 2D:",
			rotatePrimitive[
				Circle[{1,1},1,{0,90 Degree}],
				{0,0},
				90 Degree
			],
			Circle[{-1,1},1,{0,90 Degree}]
		]
	}
];


(* ::Subsection::Closed:: *)
(*PlotContents*)


DefineTests[
	PlotContents,
	{
		(* --- Basic --- *)
		Example[{Basic,"Plot the high-level contents of the ECL-2 facility:"},
			PlotContents[Object[Container, Building,"PlotContents test building"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot the contents of a Vertical Lift shelf:"},
			PlotContents[Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot the contents of a 96-well plate:"},
			PlotContents[Object[Container, Plate, "PlotContents test plate"<>$SessionUUID]],
			_?ValidGraphicsQ
		],

		(* --- Additional --- *)
		Example[{Additional, "If a valid position is specified, its parent container is plotted and the position highlighted:"},
			PlotContents[{Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID], "A1"}],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Multiple items whose containers or contents overlap given the provided 'Levels'/'Nearest' options can be plotted together, generating a single plot:"},
			PlotContents[{
				Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID],
				Object[Container, Bench, "PlotContents test bench 3" <> $SessionUUID]},
				LevelsUp -> 1],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Plotting the contents of an empty container plots the container itself:"},
			PlotContents[Object[Container, Plate, "PlotContents test plate 2"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Plot the layout of a container model:"},
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			_?ValidGraphicsQ
		],

		(* --- Options --- *)
		Example[{Options,LevelsDown,"Specify how many levels of contents within the provided object will be displayed:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID],LevelsDown->2],
			_?ValidGraphicsQ
		],
		Example[{Options,LevelsUp,"Specify how many levels of containers enclosing the provided object will be displayed:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID],LevelsUp->2],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestUp,"Plot the requested object, traversing the containers enclosing the provided object until reaching an object of a given type:"},
			PlotContents[Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID],NearestUp->Object[Container,Room]],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestDown,"Plot the requested object, traversing the contents of the provided object until reaching an object of a given type:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID],NearestDown->Object[Instrument]],
			_?ValidGraphicsQ
		],
		Example[{Options, Map, "Separate plots can be generated for each member of listed input using the Map->True:"},
			PlotContents[{Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID], Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID]}, Map -> True],
			SlideView[{ValidGraphicsP[]..}]
		],
		Example[{Options, Map, "If Map->False and a list of items is supplied, a single plot is returned if the items' containers or contents overlap given the provided 'Levels'/'Nearest' options:"},
			PlotContents[
				{Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID],
				Object[Container, Bench, "PlotContents test bench 3" <> $SessionUUID]},
				LevelsUp -> 1,
				Map -> False],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotType, "Plot the location of an instrument in the context of the building that holds it in 3D:"},
			PlotContents[Object[Instrument, LiquidHandler, "PlotContents test liquid handler"<>$SessionUUID], PlotType->Plot3D],
			_?ValidGraphicsQ
		],
		Example[{Options, ImageSize, "Change the size of the output plot:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID], ImageSize -> 1000],
			_?ValidGraphicsQ
		],
		Example[{Options, Axes, "Turn off display of axes around the output plot:"},
			PlotContents[Object[Instrument, HPLC, "PlotContents test HPLC"<>$SessionUUID], Axes->False],
			_?ValidGraphicsQ
		],
		Example[{Options, TargetUnits, "Set the units in which the plot will be displayed:"},
			PlotContents[Object[Instrument, HPLC, "PlotContents test HPLC"<>$SessionUUID], TargetUnits->Kilo Meter],
			_?ValidGraphicsQ
		],
		Example[{Options, Highlight, "Highlight one or more items or positions:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID], Highlight -> {Object[Instrument, HPLC, "id:R8e1PjRDbaPa"]}],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightInput, "If HighlightInput -> False, input items will not automatically be highlighted:"},
			PlotContents[Object[Instrument, LiquidHandler, "PlotContents test liquid handler"<>$SessionUUID], HighlightInput->False],
			_?ValidGraphicsQ
		],
		Example[{Options, LabelPositions, "Draw text labels direction within plotted positions:"},
			PlotContents[Object[Instrument, HPLC, "PlotContents test HPLC"<>$SessionUUID], LabelPositions->True],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightStyle, "Modify the Style options applied to highlighted items:"},
			PlotContents[Object[Instrument, LiquidHandler, "PlotContents test liquid handler"<>$SessionUUID], HighlightStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, ContainerStyle, "Modify the Style options applied to container graphics:"},
			PlotContents[Object[Instrument, LiquidHandler, "PlotContents test liquid handler"<>$SessionUUID], ContainerStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, PositionStyle, "Modify the Style options applied to position graphics:"},
			PlotContents[Object[Instrument, LiquidHandler, "PlotContents test liquid handler"<>$SessionUUID], PositionStyle->{Orange}],
			_?ValidGraphicsQ
		],
		Example[{Options, LiveDisplay, "Allow clicking on containers to refocus the output plot:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID], LiveDisplay->True],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotRange, "Specify the PlotRange of the container plot:"},
			PlotContents[Object[Instrument, HPLC, "PlotContents test HPLC"<>$SessionUUID], PlotRange->{{0 Meter, 0.5 Meter},{0 Meter, 0.5 Meter}}],
			_?ValidGraphicsQ
		],

		(* --- Messages --- *)
		Example[{Messages, "IncompatibleOptions", "If two mutually exclusive option values are specified, an error is displayed and the conflict is resolved automatically:"},
			PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID], PlotType->Plot3D, LiveDisplay->True],
			_?ValidGraphicsQ,
			Messages :> {PlotContents::IncompatibleOptions}
		],
		Example[{Messages, "ObjectNotFound", "If an object is supplied that is not in the database, an error is displayed and execution is aborted:"},
			PlotContents[Object[Container, Bench, "DoesNotExist"]],
			$Failed,
			Messages :> {PlotContents::ObjectNotFound}
		],
		Example[{Messages, "DisconnectedGraph", "If Map->False and the list of provided items do not have overlapping containers or contents given the provided 'Levels'/'Nearest' options, a warning is displayed:"},
			PlotContents[{Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID], Object[Container, Bench, "PlotContents test bench 3" <> $SessionUUID]},
				Map -> False],
			SlideView[{ValidGraphicsP[]..}],
			Messages :> {PlotContents::DisconnectedGraph}
		],
		Example[{Messages, "ModelNotFound", "If a provided item or an item in its containers or contents has no Model, an error is returned:"},
			PlotContents[Object[Container, Vessel,"PlotContents test vessel no model"<>$SessionUUID]],
			$Failed,
			Messages :> {PlotContents::ModelNotFound},
			Stubs :> {ValidObjectQ[stuff_List, ___] := Table[True, Length[stuff]]}
		],
		Example[{Messages, "MismatchedUnits", "If TargetUnits is specified as a list and the elements do not match, a warning is displayed:"},
			PlotContents[Object[Instrument, HPLC, "PlotContents test HPLC"<>$SessionUUID], TargetUnits->{Foot, Meter}],
			_?ValidGraphicsQ,
			Messages :> {PlotContents::MismatchedUnits}
		],
		Example[{Messages, "InvalidObject", "If an input or one of its containers or contents is missing fields required for plotting, an error is returned:"},
			PlotContents[Object[Container,Room,"PlotContents test room 2"<>$SessionUUID]],
			$Failed,
			Messages :> {PlotContents::InvalidObject}
		],
		Example[{Messages, "InvalidPosition", "Contents with Positions that do not appear in their container's model are reported and excluded from plotting:"},
			PlotContents[Object[Container, Room, "PlotContents test room"<>$SessionUUID]],
			_?ValidGraphicsQ,
			Messages :> {PlotContents::InvalidPosition},
			SetUp :> {Upload[<|Object->Object[Container, Bench, "PlotContents test bench 1"<>$SessionUUID], Position->"Nonexistent Slot"|>]},
			TearDown :> {Upload[<|Object->Object[Container, Bench, "PlotContents test bench 1"<>$SessionUUID], Position->"Bench Slot 4"|>]}
		],

		(* --- TESTS --- *)
		Test["Listed position input is handled appropriately:",
			PlotContents[{{Object[Container, Plate, "PlotContents test plate"<>$SessionUUID],"A1"}, {Object[Container, Plate, "PlotContents test plate"<>$SessionUUID],"H12"}}],
			_?ValidGraphicsQ
		],
		Test["Highlighting still works properly when referring to an item by Name rather than ID:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotContents[Object[Container, Plate, "PlotContents test plate"<>$SessionUUID], Highlight->{{Object[Container, Plate, "PlotContents test plate"<>$SessionUUID],"A1"}}, HighlightInput->False],
				Darker[Green],
				Infinity
			]],
			GreaterP[0]
		],
		Test["HighlightStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotContents[Object[Container, Floor, "PlotContents test floor"<>$SessionUUID], HighlightStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}, LiveDisplay -> False],
				EdgeForm[{Orange, Dashed}],
				Infinity
			]],
			GreaterP[0]
		],
		Test["ContainerStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotContents[Object[Container, Floor, "PlotContents test floor"<>$SessionUUID], ContainerStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}, LiveDisplay -> False],
				EdgeForm[{Orange, Dashed}],
				Infinity
			]],
			GreaterP[0]
		],
		Test["HighlightStyle option is properly conveyed into the plot graphics:",
			(* Look for the highlighted position color *)
			Length[Cases[
				PlotContents[Object[Container, Floor, "PlotContents test floor"<>$SessionUUID], PositionStyle->{Orange}, LiveDisplay -> False],
				Orange,
				Infinity
			]],
			GreaterP[0]
		],
		Test["NearestUp terminates at the appropriate level, excluding the Building:",
			Length[Cases[
				PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID],NearestUp->Object[Container,Floor]],
				Object[Container, Building, "PlotContents test building"<>$SessionUUID],
				Infinity
			]],
			0
		],
		Test["NearestUp terminates at the appropriate level, including the Floor:",
			Length[Cases[
				PlotContents[Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID],NearestUp->Object[Container,Floor]],
				Object[Container, Floor, "PlotContents test floor"<>$SessionUUID],
				Infinity
			]],
			0
		],
		Test["NearestDown terminates at the appropriate level, including the benches:",
			Length[Cases[
				PlotContents[Object[Container, Building, "PlotContents test building"<>$SessionUUID], NearestDown -> Object[Container, Bench]],
				ObjectP[Object[Container, Bench]],
				Infinity
			]],
			GreaterP[0]
		],
		Test["Axes can be toggled off for model plotting:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Axes->False],
			_?ValidGraphicsQ
		],
		Test["TargetUnits can be specified for model plotting:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"], TargetUnits->Mile],
			_?ValidGraphicsQ
		],
		Test["LevelsUp/Down are ignored when plotting a model:",
			SameQ[
				PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"], LevelsUp->10, LevelsDown->4],
				PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
			],
			True
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->True:",
			PlotContents[{Object[Container, Bench, "PlotContents test bench 2"<>$SessionUUID], Object[Container, Plate, "PlotContents test plate"<>$SessionUUID]}, LevelsUp->0, LevelsDown->2, Map->True],
			SlideView[{ValidGraphicsP[]..}]
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->False and they are the only input:",
			PlotContents[Object[Container, Plate, "PlotContents test plate"<>$SessionUUID], LevelsUp->0, LevelsDown->2, Map->False],
			_?ValidGraphicsQ
		],
		Test["Items with no container or contents within specified LevelsUp/LevelsDown are handled properly when Map->False and other non-bare inputs exist:",
			PlotContents[
				{Object[Container, Bench, "PlotContents test bench 2" <> $SessionUUID], Object[Container, Bench, "PlotContents test bench 3" <> $SessionUUID]},
				LevelsUp->0, LevelsDown->2, Map->False
			],
			SlideView[{ValidGraphicsP[]..}],
			Messages :> {PlotContents::DisconnectedGraph}
		],
		Test["Items with non-container terminal items plot without issue (tests proper detection of $Failed results from Download):",
			PlotContents[Object[Container, Plate, "PlotContents test plate"<>$SessionUUID], LevelsDown -> Infinity],
			ValidGraphicsP[]
		],

		(* Output tests *)
		Test["Setting Output to Result returns the plot:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->Result],
			ValidGraphicsP[]
		],

		Test["Setting Output to Preview returns the plot:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->Preview],
			ValidGraphicsP[]
		],

		Test["Setting Output to Options returns the resolved options:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotContents]]
		],

		Test["Setting Output to Tests returns a list of tests:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->Tests],
			{(_EmeraldTest|_Example)...}
		],

		Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
			PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotContents]]
		],

		Test["Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotContents[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Output->Options],
			Sort@Keys@SafeOptions@PlotContents
		],

		Test["Correctly plots Oval wells of the plate:",
			Module[{existingErrors,newErrors},
				existingErrors=FrontEndExecute[FrontEnd`GetErrorsInSelectionPacket[EvaluationNotebook[]]];
				(* we are Printing this so the results is displayed in FE *)
				Print[PlotContents@Model[Container,Plate,Irregular,"PlotContents test plate model 1"<>$SessionUUID]];
				newErrors=FrontEndExecute[FrontEnd`GetErrorsInSelectionPacket[EvaluationNotebook[]]];
				MatchQ[existingErrors,newErrors]
			],
			True
		]

	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		Block[{$DeveloperUpload = True},
			Module[{allObjects,existingObjects,uploads},

				(*Gather all the objects and models created in SymbolSetUp*)
				allObjects={
					Object[Container,Room,"PlotContents test room"<>$SessionUUID],
					Object[Container,Room,"PlotContents test room 2"<>$SessionUUID],
					Model[Container,Room,"PlotContents test room model"<>$SessionUUID],
					Model[Container,Floor,"PlotContents test floor model"<>$SessionUUID],
					Object[Container,Floor,"PlotContents test floor"<>$SessionUUID],
					Object[Container,Floor,"PlotContents test floor 2"<>$SessionUUID],
					Object[Container,Floor,"PlotContents test floor 3"<>$SessionUUID],
					Model[Container,Building,"PlotContents test building model"<>$SessionUUID],
					Object[Container,Building,"PlotContents test building"<>$SessionUUID],
					Object[Container,Building,"PlotContents test building 2"<>$SessionUUID],
					Object[Container,Building,"PlotContents test building 3"<>$SessionUUID],
					Object[Container,Bench,"PlotContents test bench"<>$SessionUUID],
					Object[Container,Bench,"PlotContents test bench 1"<>$SessionUUID],
					Object[Container,Bench,"PlotContents test bench 2"<>$SessionUUID],
					Object[Container,Bench,"PlotContents test bench 3"<>$SessionUUID],
					Object[Container,Bench,"PlotContents test bench with enclosure"<>$SessionUUID],
					Object[Container,Enclosure,"PlotContents test enclosure"<>$SessionUUID],
					Object[Container,Shelf,"PlotContents test shelf 1"<>$SessionUUID],
					Object[Instrument,HPLC,"PlotContents test HPLC"<>$SessionUUID],
					Object[Instrument,LiquidHandler,"PlotContents test liquid handler"<>$SessionUUID],
					Object[Plumbing,Tubing,"PlotContents test tubing"<>$SessionUUID],
					Object[Plumbing,Cap,"PlotContents test cap"<>$SessionUUID],
					Object[Container,OperatorCart,"PlotContents test cart"<>$SessionUUID],
					Object[Container,Vessel,"PlotContents test vessel no model"<>$SessionUUID],
					Object[Container,Plate,"PlotContents test plate"<>$SessionUUID],
					Object[Container,Plate,"PlotContents test plate 2"<>$SessionUUID],
					Model[Container,Plate,Irregular,"PlotContents test plate model 1"<>$SessionUUID],
					Object[Container,Floor,"PlotContents test floor invalid object"<>$SessionUUID],
					Object[Sample,"PlotContents test sample"<>$SessionUUID],
					Object[Instrument,VerticalLift,"PlotContents test VLM"<>$SessionUUID],
					Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID],
					Object[Container,Vessel,"PlotContents test vessel in VLM"<>$SessionUUID]
				};

				(*Check whether the names we want to give below already exist in the database*)
				existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

				(*Erase any objects and models that we failed to erase in the last unit test*)
				Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

				(*Make a room/building/floor models*)
				Upload[{
					<|
						Type->Model[Container,Room],
						Name->"PlotContents test room model"<>$SessionUUID,
						DeveloperObject->True,
						Replace[PositionPlotting]->{
							<|Name->"Bench Slot 1",XOffset->Quantity[7.62,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 2",XOffset->Quantity[9.4488,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 3",XOffset->Quantity[11.2776,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 4",XOffset->Quantity[13.1064,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 5",XOffset->Quantity[7.62,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 6",XOffset->Quantity[9.4488,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 7",XOffset->Quantity[11.2776,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Bench Slot 8",XOffset->Quantity[13.1064,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"NMR Slot 1",XOffset->Quantity[11.8872,"Meters"],YOffset->Quantity[1.524,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Circle,Rotation->0.|>,
							<|Name->"NMR Slot 2",XOffset->Quantity[9.144,"Meters"],YOffset->Quantity[1.524,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Circle,Rotation->0.|>
						},
						Replace[Positions]->{
							<|Name->"Bench Slot 1",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 2",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 3",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 4",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 5",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 6",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 7",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"Bench Slot 8",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
							<|Name->"NMR Slot 1",Footprint->Open,MaxWidth->Quantity[2.4384,"Meters"],MaxDepth->Quantity[2.4384,"Meters"],MaxHeight->Null|>,
							<|Name->"NMR Slot 2",Footprint->Open,MaxWidth->Quantity[2.4384,"Meters"],MaxDepth->Quantity[2.4384,"Meters"],MaxHeight->Null|>
						}
					|>,
					<|
						Type->Model[Container,Floor],
						Name->"PlotContents test floor model"<>$SessionUUID,
						DeveloperObject->True,
						Replace[PositionPlotting]->{
							<|Name->"Room Slot 1",XOffset->Quantity[3.3528,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Room Slot 2",XOffset->Quantity[8.5344,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Room Slot 3",XOffset->Quantity[11.5824,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Room Slot 4",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[3.2004,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>
						},
						Replace[Positions]->{
							<|Name->"Room Slot 1",Footprint->Open,MaxWidth->Quantity[6.7056,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
							<|Name->"Room Slot 2",Footprint->Open,MaxWidth->Quantity[3.048,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
							<|Name->"Room Slot 3",Footprint->Open,MaxWidth->Quantity[3.048,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
							<|Name->"Room Slot 4",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[6.4008,"Meters"],MaxHeight->Null|>
						}
					|>,
					<|
						Type->Model[Container,Building],
						Name->"PlotContents test building model"<>$SessionUUID,
						DeveloperObject->True,
						Replace[PositionPlotting]->{
							<|Name->"First Floor Slot",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[5.1816,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
							<|Name->"Second Floor Slot",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[5.1816,"Meters"],ZOffset->Quantity[3.6576,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>
						},
						Replace[Positions]->{
							<|Name->"First Floor Slot",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[10.3632,"Meters"],MaxHeight->Quantity[3.048,"Meters"]|>,
							<|Name->"Second Floor Slot",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[10.3632,"Meters"],MaxHeight->Quantity[3.048,"Meters"]|>
						}
					|>
				}];

				Upload[{
					<|Type->Object[Container,Building],
						Model->Link[Model[Container,Building,"ECL-2"],Objects],
						Name->"PlotContents test building"<>$SessionUUID
					|>,
					<|Type->Object[Container,Building],
						Model->Link[Model[Container,Building,"ECL-2"],Objects],
						Name->"PlotContents test building 2"<>$SessionUUID
					|>,
					<|Type->Object[Container,Building],
						Model->Link[Model[Container,Building,"ECL-2"],Objects],
						Name->"PlotContents test building 3"<>$SessionUUID
					|>,
					<|Type->Object[Instrument,HPLC],
						Model->Link[Model[Instrument,HPLC,"Waters Acquity UPLC H-Class FLR"],Objects],
						Name->"PlotContents test HPLC"<>$SessionUUID
					|>,
					<|Type->Object[Instrument,LiquidHandler],
						Model->Link[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Objects],
						Name->"PlotContents test liquid handler"<>$SessionUUID,
						DeveloperObject->True
					|>,
					<|Type->Object[Instrument,VerticalLift],
						Model->Link[Model[Instrument,VerticalLift,"id:Z1lqpMGjeKd9"],Objects],
						Name->"PlotContents test VLM"<>$SessionUUID
					|>,
					<|Type->Object[Container,OperatorCart],
						Model->Link[Model[Container,OperatorCart,"Chemistry Lab Cart"],Objects],
						Name->"PlotContents test cart"<>$SessionUUID
					|>,
					<|Type->Object[Container,Vessel],
						Name->"PlotContents test vessel no model"<>$SessionUUID
					|>,
					<|
						ConicalWellDepth -> Quantity[9., "Millimeters"],
						Replace[ConicalWellDepths] -> {Quantity[9., "Millimeters"]},
						Replace[CoverFootprints] -> {Lid1WellDish, LidSBSUniversal, SealSBS},
						CrossSectionalShape -> Rectangle,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						DepthMargin -> Quantity[1.7, "Millimeters"],
						Dimensions -> {Quantity[0.1272, "Meters"], Quantity[0.085, "Meters"],Quantity[0.014, "Meters"]},
						Expires -> False,
						Footprint -> Plate,
						GripHeight -> Quantity[7., "Millimeters"],
						HorizontalMargin -> Quantity[6.85, "Millimeters"],
						ImageFile -> Link[Object[EmeraldCloudFile, "id:dORYzZJrdlAD"]],
						MaxTemperature -> Quantity[40., "DegreesCelsius"],
						MaxVolume -> Quantity[0.5, "Milliliters"],
						Replace[MaxVolumes] -> {Quantity[0.015, "Milliliters"]},
						MinTemperature -> Quantity[4., "DegreesCelsius"],
						MinVolume -> Quantity[0.001, "Milliliters"],
						Replace[MinVolumes] -> {Quantity[0.001, "Milliliters"]},
						NumberOfWells -> 1,
						Opaque -> False, PlateColor -> Clear,
						Replace[PositionPlotting] -> {<|
							Name->"A1",
							XOffset->Quantity[0.00895,"Meters"],
							YOffset->Quantity[0.0785,"Meters"],
							ZOffset->Quantity[0.007,"Meters"],
							CrossSectionalShape->Oval,
							Rotation->90.
						|>},
						Replace[Positions] -> {<|
							Name->"A1",Footprint->Null,
							MaxWidth->Quantity[0.0025,"Meters"],
							MaxDepth->Quantity[0.0043,"Meters"],
							MaxHeight->Quantity[0.009,"Meters"]
						|>},
						Replace[RecommendedFillVolumes] -> {Quantity[15., "Microliters"]},
						Reusability -> False, SelfStanding -> True,
						Sterile -> False, StorageOrientation -> Any, TransportStable -> True,
						Type -> Model[Container, Plate, Irregular],
						Unimageable -> True,
						VerifiedContainerModel -> True,
						VerticalMargin -> Quantity[4.35, "Millimeters"],
						WellBottom -> VBottom,
						Replace[WellBottoms] -> {VBottom},
						WellColor -> Clear,
						Replace[WellColors] -> {Clear},
						WellDepth -> Quantity[9., "Millimeters"],
						Replace[WellDepths] -> {Quantity[9., "Millimeters"]},
						WellDimensions -> {Quantity[2.5, "Millimeters"], Quantity[4.3, "Millimeters"]},
						Replace[WellPositionDimensions] -> {{
							Quantity[2.5, "Millimeters"],
							Quantity[4.3, "Millimeters"]
						}},
						Replace[WellTreatments] -> {NonTreated},
						Replace[Authors] -> {Link[Object[User, Emerald, Developer, "dima"]]},
						Replace[Synonyms] -> {"PlotContents test plate model 1"<>$SessionUUID},
						Name -> "PlotContents test plate model 1"<>$SessionUUID
					|>
				}];

				(*Make some things to set up or test room*)
				ECL`InternalUpload`UploadSample[
					{
						Model[Container,Floor,"ECL-2 First Floor"],
						Model[Container,Floor,"PlotContents test floor model"<>$SessionUUID],
						Model[Container,Floor,"ECL-2 First Floor"],
						Model[Container,Shelf,"id:N80DNj1W8lE6"]
					},
					{
						{"First Floor Slot",Object[Container,Building,"PlotContents test building"<>$SessionUUID]},
						{"First Floor Slot",Object[Container,Building,"PlotContents test building 2"<>$SessionUUID]},
						{"First Floor Slot",Object[Container,Building,"PlotContents test building 3"<>$SessionUUID]},
						{"A1",Object[Instrument,VerticalLift,"PlotContents test VLM"<>$SessionUUID]}
					},
					Name->{
						"PlotContents test floor"<>$SessionUUID,
						"PlotContents test floor 2"<>$SessionUUID,
						"PlotContents test floor 3"<>$SessionUUID,
						"PlotContents test VLM Shelf"<>$SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					FastTrack->True
				];

				ECL`InternalUpload`UploadSample[
					{
						Model[Container,Room,"Chemistry Lab"],
						Model[Container,Room,"PlotContents test room model"<>$SessionUUID],
						Model[Container,Vessel,"id:Vrbp1jG800Zm"]
					},
					{
						{"ECL-2 Lab Slot",Object[Container,Floor,"PlotContents test floor"<>$SessionUUID]},
						{"Room Slot 1",Object[Container,Floor,"PlotContents test floor 2"<>$SessionUUID]},
						{"A3",Object[Container,Shelf,"PlotContents test VLM Shelf"<>$SessionUUID]}
					},
					Name->{
						"PlotContents test room"<>$SessionUUID,
						"PlotContents test room 2"<>$SessionUUID,
						"PlotContents test vessel in VLM"<>$SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					FastTrack->True
				];

				ECL`InternalUpload`UploadSample[
					Table[
						Model[Container,Bench,"The Bench of Testing"],
						3
					],
					{
						{"Bench Slot 4",Object[Container,Room,"PlotContents test room"<>$SessionUUID]},
						{"Bench Slot 5",Object[Container,Room,"PlotContents test room"<>$SessionUUID]},
						{"Bench Slot 6",Object[Container,Room,"PlotContents test room"<>$SessionUUID]}
					},
					Name->{
						"PlotContents test bench 1"<>$SessionUUID,
						"PlotContents test bench 2"<>$SessionUUID,
						"PlotContents test bench 3"<>$SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					FastTrack->True
				];

				ECL`InternalUpload`UploadSample[
					{
						Model[Container,Shelf,"id:kEJ9mqaVPPVp"],
						Model[Plumbing,Tubing,"PharmaPure #17"],
						Model[Plumbing,Cap,"id:4pO6dM5qEmXz"],
						Model[Container,Plate,"96-well 2mL Deep Well Plate"],
						Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					},
					{
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 1"<>$SessionUUID]},
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 1"<>$SessionUUID]},
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 1"<>$SessionUUID]},
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 2"<>$SessionUUID]},
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 2"<>$SessionUUID]}
					},
					Name->{
						"PlotContents test shelf 1"<>$SessionUUID,
						"PlotContents test tubing"<>$SessionUUID,
						"PlotContents test cap"<>$SessionUUID,
						"PlotContents test plate"<>$SessionUUID,
						"PlotContents test plate 2"<>$SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					FastTrack->True
				];

				ECL`InternalUpload`UploadSample[
					{
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",Object[Container,Plate,"PlotContents test plate"<>$SessionUUID]}
					},
					Name->{
						"PlotContents test sample"<>$SessionUUID
					},
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
				];

				uploads=ECL`InternalUpload`UploadLocation[
					{
						Object[Instrument,HPLC,"PlotContents test HPLC"<>$SessionUUID],
						Object[Instrument,LiquidHandler,"PlotContents test liquid handler"<>$SessionUUID],
						Object[Instrument,VerticalLift,"PlotContents test VLM"<>$SessionUUID],
						Object[Container,Vessel,"PlotContents test vessel no model"<>$SessionUUID]
					},
					{
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 2"<>$SessionUUID]},
						{"Lower Shelf Slot",Object[Container,Bench,"PlotContents test bench 2"<>$SessionUUID]},
						{"RT VLM Slot",Object[Container,Room,"PlotContents test room"<>$SessionUUID]},
						{"Bench Top Slot",Object[Container,Bench,"PlotContents test bench 1"<>$SessionUUID]}
					},
					FastTrack->True,
					Upload->False
				];
				Upload[uploads];
			]
		]
	},
	SymbolTearDown:>{
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False];

		Unset[$CreatedObjects];
	}
];


(* ::Subsection::Closed:: *)
(*ToBarcode*)


DefineTests[
	ToBarcode,
	{
		Example[{Basic,"Converts from a sample to a barcode:"},
			ToBarcode[Object[Sample, "id:54"]],
			"id:54"
		],
		Example[{Attributes,"Listable","Return a list of barcodes:"},
			ToBarcode[{Object[Sample, "id:12"],Object[Sample, "id:20"],Object[Sample, "id:1"]}],
			{"id:12","id:20","id:1"}
		],
		Example[{Additional, "Symbolic input remains unevaluated:"},
			ToBarcode[Fish],
			_ToBarcode
		]
	}
];


(* ::Subsection::Closed:: *)
(*ToObject*)


DefineTests[
	ToObject,
	{
		Example[{Basic,"Converts from an SLL3 barcode to an object:"},
			ToObject["id:54n6evL5wvbB"],
			Object[Sample, "id:54n6evL5wvbB"]
		],

		Example[{Basic,"The function can handle multiple consecutively-scanned barcodes in a single string, separated by spaces:"},
			ToObject["id:54n6evL5wvbB id:n0k9mG8xZGop id:01G6nvwVavb4 "],
			{Object[Sample, "id:54n6evL5wvbB"], Object[Sample, "id:n0k9mG8xZGop"], Object[Item,Consumable,"id:01G6nvwVavb4"]}
		],

		Example[{Attributes,"Listable","The function is listable by barcodes:"},
			ToObject[{"id:54n6evL5wvbB", "id:n0k9mG8xZGop", "id:01G6nvwVavb4"}],
			{Object[Sample, "id:54n6evL5wvbB"], Object[Sample, "id:n0k9mG8xZGop"], Object[Item,Consumable,"id:01G6nvwVavb4"]}
		],

		Example[{Additional,"Works with tailing space:"},
			ToObject["id:54n6evL5wvbB "],
			Object[Sample, "id:54n6evL5wvbB"]
		],

		Test["Symbolic input remains unevaluated:",
			ToObject[Fish],
			_ToObject
		]
	}
];


(* ::Subsection::Closed:: *)
(*plotContainer*)


(* ::Subsubsection::Closed:: *)
(*plotContainer*)


DefineTests[
	plotContainer,
	{
		(* --- Basic --- *)
		Example[{Basic,"Generate a plot of the location of an instrument in the context of the building that holds it:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Generate a plot of the location of two objects within the same building:"},
			plotContainer[{Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], Object[Instrument, HPLC, "plotContainer test HPLC"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Generate a plot of the location of a building plots the building itself:"},
			plotContainer[Object[Container, Building,"plotContainer test building"<>$SessionUUID]],
			_?ValidGraphicsQ
		],
		
		(* --- Additional --- *)
		Example[{Additional, "If a valid position is specified, its parent container is plotted and the position highlighted:"},
			plotContainer[{Object[Container, Shelf, "plotContainer test shelf 1"<>$SessionUUID], "Slot 1"}],
			_?ValidGraphicsQ
		],
		Example[{Additional, "Multiple items whose containers or contents overlap given the provided 'Levels'/'Nearest' options can be plotted together, generating a single plot:"},
			plotContainer[{Object[Container, Bench, "plotContainer test bench 2"<>$SessionUUID], Object[Container, Bench, "plotContainer test bench 3"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],
		
		(* --- Options --- *)
		Example[{Options,LevelsDown,"Specify how many levels of contents within the provided object will be displayed:"},
			plotContainer[Object[Container, Shelf, "plotContainer test shelf 1"<>$SessionUUID],LevelsDown->2],
			_?ValidGraphicsQ
		],
		Example[{Options,LevelsUp,"Specify how many levels of containers enclosing the provided object will be displayed:"},
			plotContainer[Object[Container, Shelf, "plotContainer test shelf 1"<>$SessionUUID],LevelsUp->2],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestUp,"Generate a plot of the requested object, traversing the containers enclosing the provided object until reaching an object of a given type:"},
			plotContainer[Object[Container, Shelf, "plotContainer test shelf 1"<>$SessionUUID],NearestUp->Object[Container,Room]],
			_?ValidGraphicsQ
		],
		Example[{Options,NearestDown,"Generate a plot of the requested object, traversing the contents of the provided object until reaching an object of a given type:"},
			plotContainer[Object[Container, Shelf, "plotContainer test shelf 1"<>$SessionUUID],NearestDown->Object[Instrument]],
			_?ValidGraphicsQ
		],
		Example[{Options, Map, "Separate plots can be generated for each member of listed input using the Map->True:"},
			plotContainer[{Object[Container, Bench, "plotContainer test bench 2"<>$SessionUUID], Object[Container, Bench, "plotContainer test bench 3"<>$SessionUUID]}, Map -> True],
			{Repeated[_?ValidGraphicsQ,{2}]}
		],
		Example[{Options, Map, "If Map->False and a list of items is supplied, a single plot is returned if the items' containers or contents overlap given the provided 'Levels'/'Nearest' options:"},
			plotContainer[{Object[Container, Bench, "plotContainer test bench 2"<>$SessionUUID], Object[Container, Bench, "plotContainer test bench 3"<>$SessionUUID]}, Map -> False],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotType, "Generate a plot of the location of an instrument in the context of the building that holds it in 3D:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], PlotType->Plot3D],
			_?ValidGraphicsQ
		],
		Example[{Options, ImageSize, "Change the size of the output plot:"},
			plotContainer[Object[Container, Bench, "plotContainer test bench 2"<>$SessionUUID], ImageSize -> 1000],
			_?ValidGraphicsQ
		],
		Example[{Options, Axes, "Turn off display of axes around the output plot:"},
			plotContainer[Object[Container, Floor, "plotContainer test floor"<>$SessionUUID], Axes->False],
			_?ValidGraphicsQ
		],
		Example[{Options, TargetUnits, "Set the units in which the plot will be displayed:"},
			plotContainer[Object[Instrument, HPLC, "plotContainer test HPLC"<>$SessionUUID], TargetUnits->Kilo Meter],
			_?ValidGraphicsQ
		],
		Example[{Options, Highlight, "Highlight one or more items or positions:"},
			plotContainer[Object[Container, Bench, "plotContainer test bench 2"<>$SessionUUID], Highlight -> {Object[Container, Room, "plotContainer test room"<>$SessionUUID]}],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightInput, "If HighlightInput -> False, input items will not automatically be highlighted:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], HighlightInput->False],
			_?ValidGraphicsQ
		],
		Example[{Options, LabelPositions, "Draw text labels direction within plotted positions:"},
			plotContainer[Object[Container, Building,"plotContainer test building"<>$SessionUUID], LabelPositions->True],
			_?ValidGraphicsQ
		],
		Example[{Options, HighlightStyle, "Modify the Style options applied to highlighted items:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], HighlightStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, ContainerStyle, "Modify the Style options applied to container graphics:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], ContainerStyle->{EdgeForm[{Orange, Dashed}],FaceForm[None]}],
			_?ValidGraphicsQ
		],
		Example[{Options, PositionStyle, "Modify the Style options applied to position graphics:"},
			plotContainer[Object[Instrument, LiquidHandler, "plotContainer test liquid handler"<>$SessionUUID], PositionStyle->{Orange}],
			_?ValidGraphicsQ
		],
		Example[{Options, LiveDisplay, "Allow clicking on containers to refocus the output plot:"},
			plotContainer[Object[Container, Floor, "plotContainer test floor"<>$SessionUUID], LiveDisplay->True],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotRange, "Specify the PlotRange of the container plot:"},
			plotContainer[Object[Container, Floor, "plotContainer test floor"<>$SessionUUID], PlotRange->{{0 Meter, 10 Meter},{0 Meter, 10 Meter}}],
			_?ValidGraphicsQ
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,uploads},

			$CreatedObjects={};

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Room,"plotContainer test room"<>$SessionUUID],
				Object[Container,Room,"plotContainer test room 2"<>$SessionUUID],
				Model[Container,Room,"plotContainer test room model"<>$SessionUUID],
				Model[Container,Floor,"plotContainer test floor model"<>$SessionUUID],
				Object[Container,Floor,"plotContainer test floor"<>$SessionUUID],
				Object[Container,Floor,"plotContainer test floor 2"<>$SessionUUID],
				Object[Container,Floor,"plotContainer test floor 3"<>$SessionUUID],
				Model[Container,Building,"plotContainer test building model"<>$SessionUUID],
				Object[Container,Building,"plotContainer test building"<>$SessionUUID],
				Object[Container,Building,"plotContainer test building 2"<>$SessionUUID],
				Object[Container,Building,"plotContainer test building 3"<>$SessionUUID],
				Object[Container,Bench,"plotContainer test bench"<>$SessionUUID],
				Object[Container,Bench,"plotContainer test bench 1"<>$SessionUUID],
				Object[Container,Bench,"plotContainer test bench 2"<>$SessionUUID],
				Object[Container,Bench,"plotContainer test bench 3"<>$SessionUUID],
				Object[Container,Bench,"plotContainer test bench with enclosure"<>$SessionUUID],
				Object[Container,Enclosure,"plotContainer test enclosure"<>$SessionUUID],
				Object[Container,Shelf,"plotContainer test shelf 1"<>$SessionUUID],
				Object[Instrument,HPLC,"plotContainer test HPLC"<>$SessionUUID],
				Object[Instrument,LiquidHandler,"plotContainer test liquid handler"<>$SessionUUID],
				Object[Plumbing,Tubing,"plotContainer test tubing"<>$SessionUUID],
				Object[Plumbing,Cap,"plotContainer test cap"<>$SessionUUID],
				Object[Container,OperatorCart,"plotContainer test cart"<>$SessionUUID],
				Object[Container,Vessel,"plotContainer test vessel no model"<>$SessionUUID],
				Object[Container,Plate,"plotContainer test plate"<>$SessionUUID],
				Object[Container,Floor,"plotContainer test floor invalid object"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(*Make a room/building/floor models*)
			Upload[{
				<|
					Type->Model[Container,Room],
					Name->"plotContainer test room model"<>$SessionUUID,
					DeveloperObject->True,
					Replace[PositionPlotting]->{
						<|Name->"Bench Slot 1",XOffset->Quantity[7.62,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 2",XOffset->Quantity[9.4488,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 3",XOffset->Quantity[11.2776,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 4",XOffset->Quantity[13.1064,"Meters"],YOffset->Quantity[5.7912,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 5",XOffset->Quantity[7.62,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 6",XOffset->Quantity[9.4488,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 7",XOffset->Quantity[11.2776,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Bench Slot 8",XOffset->Quantity[13.1064,"Meters"],YOffset->Quantity[3.6576,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"NMR Slot 1",XOffset->Quantity[11.8872,"Meters"],YOffset->Quantity[1.524,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Circle,Rotation->0.|>,
						<|Name->"NMR Slot 2",XOffset->Quantity[9.144,"Meters"],YOffset->Quantity[1.524,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Circle,Rotation->0.|>
					},
					Replace[Positions]->{
						<|Name->"Bench Slot 1",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 2",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 3",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 4",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 5",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 6",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 7",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"Bench Slot 8",Footprint->Open,MaxWidth->Quantity[1.8288,"Meters"],MaxDepth->Quantity[0.9144,"Meters"],MaxHeight->Null|>,
						<|Name->"NMR Slot 1",Footprint->Open,MaxWidth->Quantity[2.4384,"Meters"],MaxDepth->Quantity[2.4384,"Meters"],MaxHeight->Null|>,
						<|Name->"NMR Slot 2",Footprint->Open,MaxWidth->Quantity[2.4384,"Meters"],MaxDepth->Quantity[2.4384,"Meters"],MaxHeight->Null|>
					}
				|>,
				<|
					Type->Model[Container,Floor],
					Name->"plotContainer test floor model"<>$SessionUUID,
					DeveloperObject->True,
					Replace[PositionPlotting]->{
						<|Name->"Room Slot 1",XOffset->Quantity[3.3528,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Room Slot 2",XOffset->Quantity[8.5344,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Room Slot 3",XOffset->Quantity[11.5824,"Meters"],YOffset->Quantity[8.8392,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Room Slot 4",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[3.2004,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>
					},
					Replace[Positions]->{
						<|Name->"Room Slot 1",Footprint->Open,MaxWidth->Quantity[6.7056,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
						<|Name->"Room Slot 2",Footprint->Open,MaxWidth->Quantity[3.048,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
						<|Name->"Room Slot 3",Footprint->Open,MaxWidth->Quantity[3.048,"Meters"],MaxDepth->Quantity[3.048,"Meters"],MaxHeight->Null|>,
						<|Name->"Room Slot 4",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[6.4008,"Meters"],MaxHeight->Null|>
					}
				|>,
				<|
					Type->Model[Container,Building],
					Name->"plotContainer test building model"<>$SessionUUID,
					DeveloperObject->True,
					Replace[PositionPlotting]->{
						<|Name->"First Floor Slot",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[5.1816,"Meters"],ZOffset->Quantity[0.,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>,
						<|Name->"Second Floor Slot",XOffset->Quantity[7.9248,"Meters"],YOffset->Quantity[5.1816,"Meters"],ZOffset->Quantity[3.6576,"Meters"],CrossSectionalShape->Rectangle,Rotation->0.|>
					},
					Replace[Positions]->{
						<|Name->"First Floor Slot",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[10.3632,"Meters"],MaxHeight->Quantity[3.048,"Meters"]|>,
						<|Name->"Second Floor Slot",Footprint->Open,MaxWidth->Quantity[15.8496,"Meters"],MaxDepth->Quantity[10.3632,"Meters"],MaxHeight->Quantity[3.048,"Meters"]|>
					}
				|>
			}];

			Upload[{
				<|Type->Object[Container,Building],
					Model->Link[Model[Container,Building,"ECL-2"],Objects],
					Name->"plotContainer test building"<>$SessionUUID
				|>,
				<|Type->Object[Container,Building],
					Model->Link[Model[Container,Building,"ECL-2"],Objects],
					Name->"plotContainer test building 2"<>$SessionUUID
				|>,
				<|Type->Object[Container,Building],
					Model->Link[Model[Container,Building,"ECL-2"],Objects],
					Name->"plotContainer test building 3"<>$SessionUUID
				|>,
				<|Type->Object[Instrument,HPLC],
					Model->Link[Model[Instrument,HPLC,"Waters Acquity UPLC H-Class FLR"],Objects],
					Name->"plotContainer test HPLC"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|Type->Object[Instrument,LiquidHandler],
					Model->Link[Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"],Objects],
					Name->"plotContainer test liquid handler"<>$SessionUUID,
					DeveloperObject->True
				|>,
				<|Type->Object[Container,OperatorCart],
					Model->Link[Model[Container,OperatorCart,"Chemistry Lab Cart"],Objects],
					Name->"plotContainer test cart"<>$SessionUUID
				|>,
				<|Type->Object[Container,Vessel],
					Name->"plotContainer test vessel no model"<>$SessionUUID
				|>
			}];

			(*Make some things to set up or fake room*)
			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Floor,"ECL-2 First Floor"],
					Model[Container,Floor,"plotContainer test floor model"<>$SessionUUID],
					Model[Container,Floor,"ECL-2 First Floor"]
				},
				{
					{"First Floor Slot",Object[Container,Building,"plotContainer test building"<>$SessionUUID]},
					{"First Floor Slot",Object[Container,Building,"plotContainer test building 2"<>$SessionUUID]},
					{"First Floor Slot",Object[Container,Building,"plotContainer test building 3"<>$SessionUUID]}
				},
				Name->{
					"plotContainer test floor"<>$SessionUUID,
					"plotContainer test floor 2"<>$SessionUUID,
					"plotContainer test floor 3"<>$SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack->True
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Room,"Chemistry Lab"],
					Model[Container,Room,"plotContainer test room model"<>$SessionUUID]
				},
				{
					{"ECL-2 Lab Slot",Object[Container,Floor,"plotContainer test floor"<>$SessionUUID]},
					{"Room Slot 1",Object[Container,Floor,"plotContainer test floor 2"<>$SessionUUID]}
				},
				Name->{
					"plotContainer test room"<>$SessionUUID,
					"plotContainer test room 2"<>$SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack->True
			];

			ECL`InternalUpload`UploadSample[
				Table[
					Model[Container,Bench,"The Bench of Testing"],
					3
				],
				{
					{"Bench Slot 4",Object[Container,Room,"plotContainer test room"<>$SessionUUID]},
					{"Bench Slot 5",Object[Container,Room,"plotContainer test room"<>$SessionUUID]},
					{"Bench Slot 6",Object[Container,Room,"plotContainer test room"<>$SessionUUID]}
				},
				Name->{
					"plotContainer test bench 1"<>$SessionUUID,
					"plotContainer test bench 2"<>$SessionUUID,
					"plotContainer test bench 3"<>$SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack->True
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Container,Shelf,"id:kEJ9mqaVPPVp"],
					Model[Plumbing,Tubing,"PharmaPure #17"],
					Model[Plumbing,Cap,"id:4pO6dM5qEmXz"],
					Model[Container,Plate,"id:kEJ9mqRXALxE"]
				},
				{
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 1"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 1"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 1"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 2"<>$SessionUUID]}
				},
				Name->{
					"plotContainer test shelf 1"<>$SessionUUID,
					"plotContainer test tubing"<>$SessionUUID,
					"plotContainer test cap"<>$SessionUUID,
					"plotContainer test plate"<>$SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				FastTrack->True
			];

			uploads=ECL`InternalUpload`UploadLocation[
				{
					Object[Instrument,HPLC,"plotContainer test HPLC"<>$SessionUUID],
					Object[Instrument,LiquidHandler,"plotContainer test liquid handler"<>$SessionUUID],
					Object[Container,Vessel,"plotContainer test vessel no model"<>$SessionUUID]
				},
				{
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 2"<>$SessionUUID]},
					{"Lower Shelf Slot",Object[Container,Bench,"plotContainer test bench 2"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"plotContainer test bench 1"<>$SessionUUID]}
				},
				FastTrack->True,
				Upload->False
			];
			Upload[uploads]
		]
	},
	SymbolTearDown:>{
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False];
		
		Unset[$CreatedObjects];
	}
];
