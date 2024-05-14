(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[Download,
  {
    Example[{Basic, "Downloading an object returns an object packet:"},
      Download[Object[Sample, "Download Test Oligomer"]],
      PacketP[]
    ],

    Example[{Basic, "Downloading a Link returns the packet for the object the link points to:"},
      Download[Link[Object[User, Emerald, Developer, "Test: developer 1"], ProtocolsAuthored, "link-id"]],
      PacketP[]
    ],

    Example[{Basic, "Download only a sub-set of fields from an object:"},
      Download[Object[Sample, "Download Test Oligomer"], {Name, DeveloperObject}],
      {"Download Test Oligomer", True}
    ],

    Example[{Additional, "$CacheSize", "Limit the amount of data (in bytes) that will be cached by setting $CacheSize:"},
      Block[{$CacheSize=12000000},
        Download[{
          Object[Sample, "Download Test Oligomer"],
          Object[Container, Rack, "Download Test Rack"]
        }]
      ],
      {PacketP[]..}
    ],

    Example[{Additional, "Fields", "Any fields which are not set will be either Null (single fields) or {} (multiple fields):"},
      With[{object=Upload[<|Type -> Object[Container, Plate], DeveloperObject -> True|>]},
        Lookup[Download[object], {Container, DeveloperObject, Contents}]
      ],
      {Null, True, {}}
    ],

    Example[{Additional, "Download a set of fields from a list of objects and/or links:"},
      Download[
        {Object[Container, Plate, "Download Test Plate"], Link[Object[Sample, "Download Test Oligomer"], "link-id"]},
        Name
      ],
      {"Download Test Plate", "Download Test Oligomer"}
    ],

    (* Link Tests *)

    Test["Links return appropriately:",
      Module[{newId, dataIds, check},
        (* Create some data objects to link to*)
        dataIds=Upload[
          Table[<|Type -> Object[Example, Data], Name -> "Test Data "<>ToString[i]<>DateString[]|>, {i, 1, 3}]
        ];
        (* Create a person object with links to the newly created data objects. *)
        newId=Upload[<|
          Type -> Object[Example, Person, Emerald],
          FirstName -> "Test 1",
          LastName -> "Pilot",
          Replace[DataRelation] -> Map[Link[#, PersonRelation]&, dataIds]
        |>];

        (* Check that we download correctly formated Link[] heads *)
        check=Download[newId];
        {
          Lookup[check, DataRelation],
          MatchQ[Lookup[check, DataRelation], Map[Link[#, PersonRelation, _String]&, dataIds]]
        }
      ],
      {_List, True}
    ],

    Test["Dereferencing through links works:",
      Module[
        {
          dataId1=CreateID[Object[Example, Data]],
          dataId2=CreateID[Object[Example, Data]],
          dataId3=CreateID[Object[Example, Data]],
          newIds
        },
        newIds=Upload[
          {
            <|
              Object -> dataId1,
              Name -> "Data 1"<>CreateUUID[],
              Replace[AppendRelation1] -> {
                Link[dataId2, AppendRelation2],
                Link[dataId3, AppendRelation2]
              }
            |>,
            <|
              Object -> dataId2,
              Name -> "Data 2"<>CreateUUID[]
            |>,
            <|
              Object -> dataId3,
              Name -> "Data 3"<>CreateUUID[]
            |>
          }
        ];
        {
          dataId1[AppendRelation1][Name],
          dataId2[AppendRelation2][Name]
        }
      ],
      {
        {prefixStringMatchP["Data 2"], prefixStringMatchP["Data 3"]},
        {prefixStringMatchP["Data 1"]}
      }
    ],

    Test["Download through links on fields beyond PaginationLength in an indexed multiple field with Cache->packets:",
      Module[
        {object, relations, packet},
        relations=CreateID[Table[Object[Example, Data], {70}]];
        object=Upload[<|
          Type -> Object[Example, Data],
          Replace[GroupedMultipleAppendRelation] -> Map[
            {"A", Link[#, GroupedMultipleAppendRelationAmbiguous, 2]}&,
            relations
          ]
        |>];
        packet=Download[object];

        Download[object, GroupedMultipleAppendRelation[[All, 2]][Name], Cache -> {packet}]
      ],
      {Repeated[Null, 70]}
    ],

    (* Listable *)

    Example[{Additional, "Structured Lists", "Download will preserve the structure of nested Lists:"},
      Download[{
        {Object[Sample, "Download Test Oligomer"]},
        {Object[Container, Plate, "Download Test Plate"], Object[Sample, "Download Test Oligomer"]}
      }],
      {{_Association}, {_Association, _Association}}
    ],

    Test["Download is Listable:",
      Module[{newIds, uniqVal1, uniqVal2, check},
        uniqVal1=RandomInteger[2^32];
        uniqVal2=RandomInteger[2^32];
        newIds=Upload[
          {
            <|
              Type -> Object[Example, Person, Emerald],
              FirstName -> "Test 1",
              LastName -> "Pilot "<>ToString[uniqVal1]
            |>,
            <|
              Type -> Object[Example, Data],
              Name -> "Test Data"<>ToString[uniqVal2]
            |>
          }
        ];
        check=Download[newIds];
        {
          {Lookup[check[[1]], {Object, Type, FirstName}], Lookup[check[[1]], LastName] === "Pilot "<>ToString[uniqVal1]},
          {Lookup[check[[2]], {Object, Type}], Lookup[check[[2]], Name] === "Test Data"<>ToString[uniqVal2]}
        }
      ],
      {
        {{Object[Example, Person, Emerald, _String], Object[Example, Person, Emerald], "Test 1"}, True},
        {{Object[Example, Data, _String], Object[Example, Data]}, True}
      }
    ],

    Test["Downloading nested fields from duplicate nested objects returns the correct fields:",
      With[{obj=Upload[<|Type -> Object[Example, Data], Number -> 1.|>]},
        Download[{{obj, obj}, {obj, obj}}, {{Number, Number}, {Type, Type}}]
      ],
      {
        {{1., 1.}, {1., 1.}},
        {{Object[Example, Data], Object[Example, Data]}, {Object[Example, Data], Object[Example, Data]}}
      }
    ],

    Test["Downloading an empty list of objects returns empty list:",
      Download[{}],
      {}
    ],

    Test["Downloading an empty list of objects with a list of fields returns empty list:",
      Download[{}, {Object, Name}],
      {}
    ],

    Test["Downloaded an empty nested field from an object returns an empty nested list:",
      Download[Object[Container, Rack, "rack"], {{}}],
      {{}}
    ],

    Test["Downloaded an empty nested field from a list of objects returns an empty nested list:",
      Download[{Object[Container, Rack, "rack"]}, {{}}],
      {{}}
    ],

    Test["Downloaded an empty nested field from a nested list of objects returns an triply nested empty list:",
      Download[{{Object[Container, Rack, "rack"]}}, {{}}],
      {{{}}}
    ],

    Test["Downloading an empty list of fields from a list of objects returns a list of empty lists:",
      Download[Search[Object[Sample], DeveloperObject == True, SubTypes -> False, MaxResults -> 5], {}],
      {Repeated[{}, 5]}
    ],

    Test["Downloading an empty nested list from a nested list returns a list with the same length:",
      Download[
        {
          {Object[Item, Consumable, "id:-1"]},
          {Object[Item, Consumable, "id:-1"]}
        },
        {{}, {}}
      ],
      {{{}}, {{}}}
    ],

    Test["Downloading a list of objects with duplicates does not remove duplicates:",
      With[
        {object=Upload[<|Type -> Object[Example, Data], TestIdentifier -> CreateUUID[]|>]},

        Download[{object, object}]
      ],
      {_Association, _Association}
    ],

    Test["Downloading a list of objects with duplicates and specific fields does not remove duplicates:",
      With[
        {object=Upload[<|Type -> Object[Example, Data], TestIdentifier -> CreateUUID[]|>]},

        Download[{object, object}, TestIdentifier]
      ],
      {id_String, id_String}
    ],

    (* Simulations *)

    Test["UpdateSimulation can merge multiple simulations:",
      Module[
        {newContainerPackets, newContainer1, newContainer2, newRuler, simulation1, newSamplePackets,
          sample1, sample2, simulation2, sampleStatusPackets, simulation3},

        newContainerPackets=ECL`InternalUpload`UploadSample[
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

        newContainer1=newContainerPackets[[1]][Object];
        newContainer2=newContainerPackets[[2]][Object];
        newRuler=newContainerPackets[[3]][Object];

        simulation1=UpdateSimulation[Simulation[], Simulation[newContainerPackets]];

        newSamplePackets=ECL`InternalUpload`UploadSample[
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

        sample1=newSamplePackets[[1]][Object];
        sample2=newSamplePackets[[2]][Object];

        simulation2=UpdateSimulation[simulation1, Simulation[newSamplePackets]];

        sampleStatusPackets=ECL`InternalUpload`UploadSampleStatus[{sample1, sample2}, Available, Simulation -> simulation2, Upload -> False];

        simulation3=UpdateSimulation[simulation2, Simulation[sampleStatusPackets]];

        Download[{sample1, sample2}, Status, Simulation -> simulation3]
      ],
      {Available, Available}
    ],

    Test["UpdateSimulation is automatically called under the hood when we're in a global simulation:",
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
    ],

    Test["Downloading from a simulation works (using UploadSample to generate simulated samples):",
      Module[{uploadPackets, containerObject},
        uploadPackets=ECL`InternalUpload`UploadSample[
          {Model[Container, Vessel, "50mL Tube"]},
          {{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}},
          Upload -> False
        ];
        containerObject=uploadPackets[[1]][Object];
        Download[containerObject, Container[Name], Simulation -> Simulation[uploadPackets]]
      ],
      "Ambient Storage Shelf"
    ],

    Test["Downloading from a simulation works:",
      Module[{uploadPackets, containerObject},
        uploadPackets=ECL`InternalUpload`UploadSample[
          {Model[Container, Vessel, "50mL Tube"]},
          {{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}},
          Upload -> False
        ];
        containerObject=uploadPackets[[1]][Object];
        Download[containerObject, Container[Name], Simulation -> Simulation[uploadPackets]]
      ],
      "Ambient Storage Shelf"
    ],

    (* Options Examples *)
    Example[{Options, PaginationLength, "If a multiple field is longer than the PaginationLength it will be returned as a RuleDelayed:"},
      With[
        {
          object=Upload[
            <|
              Type -> Object[Protocol, MeasureWeight],
              Replace[NumberOfWeighings] -> Range[10],
              DeveloperObject -> True
            |>
          ]
        },
        Normal[Download[object, PaginationLength -> 5]]
      ],
      KeyValuePattern[{NumberOfWeighings :> Object[___][NumberOfWeighings]}]
    ],

    Example[{Options, HaltingCondition, "HaltingCondition->Inclusive includes the final object that failed the search condition in a recursive download:"},
      Download[Object[Sample, "Download Test Oligomer"], Repeated[Container], Status == Available, HaltingCondition -> Inclusive],
      {LinkP[Object[Container, Plate]], LinkP[Object[Container, Rack]]}
    ],

    Example[{Options, BigQuantityArrayByteLimit, "A byte limit can be set to prevent download quantity Arrays over a particular size:"},
      Module[{obj},
        bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
        obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
        {Download[obj, BigDataQuantityArray, BigQuantityArrayByteLimit -> 1], Download[obj, BigDataQuantityArray, BigQuantityArrayByteLimit -> None]}
      ],
      {$Failed, bigQA},
      Variables :> {bigQA},
      Messages :> Message[Download::FieldTooLarge]
    ],

    Example[{Options, SquashResponses, "SquashResponses->False uses deprecated Download logic for reduced performance:"},
      Download[Object[Container, Plate, "Download Test Plate"], SquashResponses -> False],
      _
    ],

    (* Messages Examples *)
    Example[{Messages, "NetworkError", "Returns $Failed and throws a message if there is an error communicating with the ECL servers:"},
      Download[Object[Sample, "Download Test Oligomer"], Contents],
      $Failed,
      Messages :> {
        Message[Download::NetworkError]
      },
      Stubs :> {
        $ECLTracing := False,
        GoCall["NativeDownload", ___] := <|"Expression" -> {{$Failed}}, "Warnings" -> {<|"Name" -> "Download::NetworkError", "Arguments" -> {}, "Error" -> ""|>}|>,
        GoCall["NativeDownloadWarnings", ___] := {<|"Name" -> "Download::NetworkError", "Arguments" -> {"Fake network error"}, "Error" -> ""|>},
        GoCall["NativeDownloadError", ___] := "",
        GoCall["NativeDownloadExpression", 0, ___] := "{{$Failed}}",
        GoCall["NativeDownloadExpression", 1, ___] := ""
      }
    ],

    Example[{Messages, "NotLoggedIn", "Returns $Failed and throws a NotLoggedIn message if not logged in:"},
      Download[Object[Sample, "Download Test Oligomer"], Contents],
      $Failed,
      Messages :> {
        Message[Download::NotLoggedIn]
      },
      Stubs :> {
        $ECLTracing := False,
        GoCall["NativeDownload", ___] := <|"Expression" -> {{$Failed}}, "Warnings" -> {<|"Name" -> "Download::NotLoggedIn", "Arguments" -> {}, "Error" -> ""|>}|>,
        GoCall["NativeDownloadWarnings", ___] := {<|"Name" -> "Download::NotLoggedIn", "Arguments" -> {}, "Error" -> ""|>},
        GoCall["NativeDownloadError", ___] := "",
        GoCall["NativeDownloadExpression", 0, ___] := "{{$Failed}}",
        GoCall["NativeDownloadExpression", 1, ___] := ""
      }
    ],

    Example[{Messages, "FieldTooLarge", "If a bigQAField is too large, it won't get downloaded:"},
      Module[{bigQA, obj},
        bigQA=QuantityArray[RandomReal[10000, {1000, 3}], {Minute, Meter Nano, AbsorbanceUnit Milli}];
        obj=Upload[<|Type -> Object[Example, Data], BigDataQuantityArray -> bigQA|>];
        Download[obj, BigDataQuantityArray, BigQuantityArrayByteLimit -> 1]
      ],
      $Failed,
      Messages :> Message[Download::FieldTooLarge]
    ],

    Example[{Messages, "ObjectDoesNotExist", "When Object id does not exist, the ObjectDoesNotExist message is thrown and $Failed is returned:"},
      Download[Object[Sample, "id:abc"]],
      $Failed,
      Messages :> {
        Message[Download::ObjectDoesNotExist, "{Object[Sample, \"id:abc\"]}"]
      }
    ],

    Example[{Messages, "ObjectDoesNotExist", "When Object Name does not exist, the ObjectDoesNotExist message is thrown and $Failed is returned:"},
      Download[Object[Sample, "ThisIsNotAnID"]],
      $Failed,
      Messages :> {
        Message[Download::ObjectDoesNotExist, "{Object[Sample, \"ThisIsNotAnID\"]}"]
      }
    ],

    Example[{Messages, "MismatchedType", "Downloading an object whose id exists in the database with a different type, fails and provides a message:"},
      Download[Object[Container, id]],
      $Failed,
      Messages :> {Message[Download::MismatchedType]},
      Variables :> {id},
      SetUp :> {id=Last[Upload[<|
        Type -> Object[Sample],
        DeveloperObject -> True
      |>]]},
      TearDown :> {EraseObject[Object[Sample, id], Force -> True]}
    ],

    Example[{Messages, "DatePrecedeCreationTime", "When Object of invalid date is downloaded, DatePrecedeCreationTime message is thrown and $Failed is returned:"},
      Download[Object[Sample, id], Date -> Now - 1 Year],
      $Failed,
      Messages :> {
        Message[Download::DatePrecedeCreationTime]
      },
      Variables :> {id},
      SetUp :> {id=Last[Upload[<|
        Type -> Object[Sample],
        DeveloperObject -> True
      |>]]},
      TearDown :> {EraseObject[Object[Sample, id], Force -> True]}
    ],

    Example[{Messages, "BadCache", "Cache->packets removes everything that does not have a valid object key from the packets list, and provides a warning for any non null ignored elements:"},
      Download[
        Object[Container, Plate, "Download Test Plate"],
        Packet[Name, Container],
        Cache -> {
          Null,
          Download[Object[Container, Plate, "Download Test Plate"]],
          <|Type -> Object[Container, Plate], Name -> "Download Test Plate"|>,
          <|Object -> "Download Test Plate"|>
        }
      ],
      KeyValuePattern[{
        Name -> "Download Test Plate",
        Container -> LinkP[]
      }],
      Messages :> {Message[Download::BadCache, "{2,3}"]}
    ],
    Example[{Messages, "SomeMetaDataUnavailable", "Meta data on fields with multiple entries were not tracked for some older data. For results containing such data, Download provides a warning:"},
      Download[Link[Object[Notebook, Script, "id:L8kPEjnEKep4"], DateObject[{2020, 8, 18, 4, 47, 1.7767529487609863`}, "Instant",
        "Gregorian", -7.`]], CurrentProtocols[Status]] ,
      {InCart,InCart,InCart},
      Messages :> {
        Message[Download::SomeMetaDataUnavailable, "CurrentProtocols"]
      }
    ],

    (* SubValues *)
    Example[{Additional, "SubValues", "Download a field from an object without using the Download symbol:"},
      Object[Sample, "Download Test Oligomer"][Name],
      "Download Test Oligomer"
    ],

    Example[{Additional, "SubValues", "Download multiple fields from an object without using the Download symbol:"},
      Object[Sample, "Download Test Oligomer"][{Name, DeveloperObject}],
      {"Download Test Oligomer", True}
    ],

    Example[{Additional, "SubValues", "Download a field from a list of object references:"},
      {Object[Sample, "Download Test Oligomer"], Object[Container, Rack, "Download Test Rack"]}[Name],
      {"Download Test Oligomer", "Download Test Rack"}
    ],

    (* Length *)
    (* TODO: remove once this syntax is depricated *)
    Example[{Additional, "Length", "Download the length of a multiple field without using the Download symbol:"},
      Object[Container, Rack, "Download Test Rack"][Contents, Length],
      1
    ],

    Test["Download the length of a multiple field without using the Download symbol:",
      Object[Container, Rack, "Download Test Rack"][Field[Length[Contents]]],
      1
    ],

    (* FieldReference *)

    Example[{Additional, "Field Reference", "Download the Name of an object from a field reference:"},
      Download[Object[Sample, "Download Test Oligomer", Name]],
      "Download Test Oligomer"
    ],

    Example[{Additional, "Field Reference", "Download a list of field references:"},
      Download[
        {
          Object[Sample, "Download Test Oligomer", Name],
          Object[Sample, "Download Test Oligomer", Container]
        }
      ],
      {"Download Test Oligomer", LinkP[]}
    ],

    Example[{Additional, "Field Reference", "Downloading a field reference to a specific index only returns items at that index:"},
      Download[Object[Container, Plate, "Download Test Plate", Contents, 1]],
      {"A1"}
    ],

    Example[{Additional, "Field Reference", "Downloading a field reference to a specific named column only returns items at that index:"},
      Download[Object[Example, Data, "Download Test: named fields 1", NamedMultiple, UnitColumn]],
      {
        Quantity[11., "Nanometers"],
        Quantity[12., "Nanometers"]
      }
    ],

    (* TODO *)

    Example[{Additional, "Names", "Download an object using its name:"},
      Download[Object[Sample, "Download Test Oligomer"]],
      PacketP[]
    ],

    Example[{Additional, "ReplaceAll", "Use /. to download field values from a list of objects:"},
      Container /. {Object[Sample, "Download Test Oligomer"], Object[Container, Rack, "Download Test Rack"]},
      {LinkP[], Null}
    ],

    Test["Downloading a field whose object id exists in the database with a different type, fails and provides a message:",
      Download[Object[Container, id], Name],
      $Failed,
      Messages :> {Message[Download::MismatchedType]},
      Variables :> {id},
      SetUp :> {id=Last[Upload[<|
        Type -> Object[Sample],
        DeveloperObject -> True
      |>]]},
      TearDown :> {EraseObject[Object[Sample, id], Force -> True]}
    ],

    Test["Cache -> packets works with no good packets:",
      Download[
        Object[Container, Plate, "Download Test Plate"],
        Packet[Name, Container],
        Cache -> {
          Null,
          <|Type -> Object[Container, Plate], Name -> "Download Test Plate"|>,
          <|Object -> "Download Test Plate"|>
        }
      ],
      KeyValuePattern[{
        Object -> ObjectP[Object[Container, Plate, "id:WNa4ZjR1n9bL"]],
        Type -> TypeP[Object[Container, Plate]],
        ID -> "id:WNa4ZjR1n9bL",
        Name -> "Download Test Plate",
        Container -> LinkP[]
      }],
      Messages :> {Message[Download::BadCache, "{1,2}"]}
    ],

    Test["Names can have weird characters in them:",
      Module[
        {objects, names},
        names={
          "with a / "<>CreateUUID[],
          "with a % "<>CreateUUID[],
          "with a ( "<>CreateUUID[],
          "with a ) "<>CreateUUID[],
          "with a > "<>CreateUUID[],
          "with a < "<>CreateUUID[],
          "with a ? "<>CreateUUID[],
          "with a & "<>CreateUUID[]
        };
        objects=Upload[
          <|Type -> Object[Example, Data], Name -> #|>& /@ names
        ];

        MatchQ[
          Transpose@Download[Map[Object[Example, Data, #] &, names], {Object, Name}],
          {objects, names}
        ]
      ],
      True
    ],

    Test["Pulling object field does not hit database:",
      Download[Object[Example, Data, "id:NotARealObject"], Object],
      Object[Example, Data, "id:NotARealObject"]
    ],

    Test["Pulling object, type, and ID fields does not hit database:",
      Download[Object[Example, Data, "id:NotARealObject"], {Object, Type, ID, Type}],
      {Object[Example, Data, "id:NotARealObject"], Object[Example, Data], "id:NotARealObject", Object[Example, Data]}
    ],

    Test["Local pulling works for a _Packet:",
      Download[Object[Example, Data, "id:NotARealObject"], Packet[Object, Type, ID, Type]],
      KeyValuePattern[{Object -> Object[Example, Data, "id:NotARealObject"], Type -> Object[Example, Data], ID -> "id:NotARealObject"}]
    ],

    Test["Local pulling from list of objects:",
      Download[{Object[Example, Data, "id:NotARealObject"]}, {Object, Type}],
      {{Object[Example, Data, "id:NotARealObject"], Object[Example, Data]}}
    ],

    Test["Local pulling from mixed list of objects:",
      Download[{Object[Example, Data, "id:NotARealObject"], Model[Example, Data, "id:NotARealObject"], Link[Object[Example, Data, "id:NotARealObject"]]}, Type],
      {Object[Example, Data], Model[Example, Data], Object[Example, Data]}
    ],

    Test["Given mixed list with id/name, can only locally pull from objects with id:",
      With[
        {object=Upload[<|Type -> Model[Example, Data]|>, Verbose -> False]},
        Download[{Object[Example, Data, "ThisIsAName"], object}, Name]
      ],
      {$Failed, Null},
      Messages :> {
        Message[Download::ObjectDoesNotExist, "{Object[Example, Data, \"ThisIsAName\"]}"]
      }
    ],

    Test["Given mixed list with id/name, can locally pull type from both:",
      Download[{Object[Example, Data, "ThisIsAName"], Model[Example, Data, "id:NotARealObject"]}, Type],
      {Object[Example, Data], Model[Example, Data]}
    ],

    Test["In mixed list of name/id objects, can only pull ID from things with IDs:",
      Download[{Object[Example, Data, "ThisIsAName"], Object[Example, Data, "id:NotARealObject"]}, ID],
      {$Failed, "id:NotARealObject"},
      Messages :> {
        Message[Download::ObjectDoesNotExist, "{Object[Example, Data, \"ThisIsAName\"]}"]
      }
    ],

    (* $Failed *)
    Example[{Additional, "$Failed", "Downloading $Failed returns $Failed:"},
      Download[$Failed],
      $Failed
    ],

    Example[{Additional, "$Failed", "Downloading a list of fields from $Failed returns $Failed for each field:"},
      Download[$Failed, {ID, Name}],
      {$Failed, $Failed}
    ],

    Example[{Additional, "$Failed", "Downloading a list of fields with a Packet from $Failed returns $Failed:"},
      Download[$Failed, Packet[ID, Name]],
      $Failed
    ],

    Example[{Additional, "$Failed", "Downloading a list of object references where some are $Failed returns $Failed for each field:"},
      Download[{Object[Container, Plate, "Download Test Plate"], $Failed}, {Name, Container}],
      {
        {"Download Test Plate", LinkP[]},
        {$Failed, $Failed}
      }
    ],

    (* Null *)
    Example[{Additional, "Null", "Downloading Null returns Null:"},
      Download[Null],
      Null
    ],

    Example[{Additional, "Null", "Downloading a list of fields from Null returns Null:"},
      Download[Null, {Name, ID}],
      Null
    ],

    Test["If first input is Null, output is always Null:",
      {
        Download[Null],
        Download[Null,All],
        Download[Null,Name],
        Download[Null,{Name,ID}],
        Download[Null,{}],
        Download[Null,Object,Cache->{<|Object->Object[Sample,"Something"]|>}],
        Download[Null, Repeated[Container], Status == Available && DeveloperObject == True],
        Download[Null, Repeated[Container], Status == Available && DeveloperObject == True, Cache -> {}]
      },
      {Null..}
    ],

    Example[{Additional, "Null", "Downloading a list of objects where some indices are Null returns Null for those indices:"},
      Download[{Object[Sample, "Download Test Oligomer"], Null}],
      {PacketP[], Null}
    ],

    Example[{Additional, "Null", "Downloading a list of fields from a list of objects where some indices are Null returns Null for those indices:"},
      Download[{Object[Sample, "Download Test Oligomer"], Null}, {ID, Container}],
      {{_String, LinkP[]}, Null}
    ],

    Example[{Additional, "Null", "With _Packet, Downloading a list of fields from a list of objects where some indices are Null returns Null for those indices:"},
      Download[{Object[Sample, "Download Test Oligomer"], Null}, Packet[ID, Container]],
      {_Association, Null}
    ],

    Test["Downloading empty fields list from a list of objects or Null returns Null at the correct indices:",
      Download[{Object[Sample, "Download Test Oligomer"], Null}, {}],
      {{}, Null}
    ],

    Test["Downloading Object/Type/ID from $Failed takes the fast path properly:",
      Download[$Failed, Type],
      $Failed
    ],

    Test["With _Packet, Downloading empty fields list from a list of objects (with IDs: fast path) or Null returns Null at the correct indices:",
      Download[{Object[Sample, "id:M8n3rxYab9BM"], Null}, Packet[]],
      {_Association, Null}
    ],

    Test["With _Packet, Downloading empty fields list from a list of objects (without IDs) or Null returns Null at the correct indices:",
      Download[{Object[Sample, "Download Test Oligomer"], Null}, Packet[]],
      {_Association, Null}
    ],

    Test["Downloading the whole packet after downloading a single field fetches the additional fields:",
      With[
        {object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1}, Name -> CreateUUID[]|>, Verbose -> False]},
        Download[object, Name, Verbose -> False];
        Download[object][Random]
      ],
      {1.0}
    ],

    Test["Download individual multiple fields in separate requests does not infinitely recur on delayed rules:",
      With[{object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> Range[200], Name -> CreateUUID[]|>, Verbose -> False]},
        Download[object];
        object[Name];
        object[Random]
      ],
      N[Range[200]]
    ],

    Example[{Additional, "Packets", "Downloading a packet returns the packet untouched:"},
      Download[<|Object -> Object[Sample, "id:1234"], Type -> Object[Sample], ID -> "id:1234", Name -> "MyName"|>],
      <|Object -> Object[Sample, "id:1234"], Type -> Object[Sample], ID -> "id:1234", Name -> "MyName"|>
    ],

    Example[{Additional, "Packets", "Downloading a specific field from a packet extracts that field:"},
      Download[<|Object -> Object[Sample, "id:1234"], Type -> Object[Sample], ID -> "id:1234", ModelName -> "MyModelName"|>, ModelName],
      "MyModelName"
    ],

    Example[{Messages, "MissingField", "When Downloading a specific field from a packet that is missing from the packet, returns $Failed and a warning message:"},
      Download[<|Object -> Object[Sample, "id:1234"], Type -> Object[Sample], ID -> "id:1234"|>, {Name, Container}],
      {$Failed, $Failed},
      Messages :> {Message[Download::MissingField, "{Name,Container}", "{Object[Sample, \"id:1234\"]}"]}
    ],

    Test["Download a part from a packet without a type:",
      Download[<|Object->Object[Container, Vessel, "50mL Tube"], MyField -> {{1, 2}, {3, 4}}|>, MyField[[2, 1]]],
      3
    ],

    Test["Download a length from a packet without a type:",
      Download[<|Object->Object[Container, Vessel, "50mL Tube"], Myfield -> {{1, 2}, {3, 4}}|>, Length[Myfield]],
      2
    ],

    Test["Downloading a field from a packet succeeds when there is no type information:",
      Download[<|Object->Object[Container, Vessel, "50mL Tube"], LocalField -> "value"|>, LocalField],
      "value"
    ],

    Test["When Downloading through a link in a packet, fetch the values on the other side of the link from the server:",
      Module[
        {object, relatedObject},
        relatedObject=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>];
        object=Upload[<|Type -> Object[Example, Data], SingleRelation -> Link[relatedObject, SingleRelationAmbiguous]|>];

        Download[
          Download[object],
          SingleRelation[Random]
        ]
      ],
      N[{1, 2, 3}]
    ],

    Test["Regular multiple fields containing lists including nulls can be downloaded:",
      Module[
        {chroma, obj},
        chroma=Upload@<|Type -> Object[Protocol, AbsorbanceSpectroscopy], DeveloperObject -> True|>;
        obj=Upload@<|
          Type -> Model[Sample],
          Replace[Protocols] -> {Link[chroma, SamplesIn], Null},
          DeveloperObject -> True
        |>;
        Download[obj, Protocols]
      ],
      {_Link, Null}
    ],

    (* Cache *)

    Example[{Options, Cache, "Cache->Session forces subsequent Download calls to refer to the local cache without checking the server for changes:"},
      Download[Object[Sample, "Download Test Oligomer"], Cache -> Session],
      PacketP[]
    ],

    Example[{Options, Cache, "Test - Cache->Download always checks the server for the latest version of the object regardless the object was cached with Session:"},
      Download[Object[Sample, "Download Test Oligomer"], Container, Cache -> Download],
      LinkP[]
    ],

    Example[{Options, Cache, "Cache->Automatic uses the value of Cache in the type definition for each object:"},
      Download[
        {
          Object[User, Emerald, Developer, "Test: developer 1"],
          Object[Container, Plate, "Download Test Plate"]
        },
        Cache -> Automatic
      ],
      {PacketP[], PacketP[]}
    ],

    Example[{Options, Cache, "Cache->packets will go to the server for fields missing in a packet provided via the option but still throw messages:"},
      With[
        {
          packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Object, Container]]
        },
        Download[
          Object[Sample, "Download Test Oligomer"],
          {Container, Model},
          Cache -> {packet}
        ]
      ],
      {LinkP[], LinkP[]},
      Messages :> {Message[Download::MissingCacheField]}
    ],

    Example[{Options, Cache, "Cache->packets will use the values in the packets, providing messages for any missing keys, when given a list of FieldReferences:"},
      With[
        {
          packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Object, Container]]
        },
        Download[
          {
            Object[Sample, "Download Test Oligomer", Container],
            Object[Sample, "Download Test Oligomer", Model]
          },
          Cache -> {packet}
        ]
      ],
      {LinkP[], LinkP[]},
      Messages :> {Message[Download::MissingCacheField]}
    ],

    Example[{Options, Cache, "Cache->packets will use historic values provided by the packets:"},
      Module[{object, relatedObject, date},
        relatedObject=Upload[<|Type -> Object[Example, Analysis], StringData -> "blah"|>];
        Pause[1];
        date=Now;
        object=Upload[<|Type -> Object[Example, Data], OneWayLinkTemporal -> Link[relatedObject, date]|>];
        Download[object, OneWayLinkTemporal[StringData], Cache -> {<|Object -> object,
          OneWayLinkTemporal -> Link[relatedObject, date]|>, <|Object -> relatedObject, DownloadDate -> date,
          StringData -> "fakeBlah"|>}]],
      "fakeBlah"
    ],

    Test["Downloading with an invalid date will default to None:",
      Download[$PersonID, Name, Date->Style[DateObject[List[2020,11,27,3,4,42.`],"Instant","Gregorian",-7.`],Rule[ContextMenu,List[MenuItem["Copy to clipboard",KernelExecute[CopyToClipboard[DateObject[List[2020,11,27,3,4,42.`],"Instant","Gregorian",-7.`]]],Rule[MenuEvaluator,Automatic]]]],Rule[LineBreakWithin,False],Rule[FontSize,11]]],
      $Failed,
      Messages :> {Message[Error::Pattern]}
    ],

    Test["Test - Cache->packets prefers the values in the packets over values in the cache or on the server when downloading the entire object:",
      Module[{model, object, modelPacket, objectPacket},
        model=Upload[<|Type -> Model[Example, Data]|>, Verbose -> False];
        object=Upload[<|Type -> Object[Example, Data]|>, Verbose -> False];
        {modelPacket, objectPacket}=Download[{model, object}];
        {
          Lookup[Download[object, Cache -> {Join[objectPacket, <|Random -> Range[20]|>]}], Random],
          Lookup[Download[model, Cache -> {Join[modelPacket, <|Number -> 4|>]}], Number]
        }
      ],
      {Range[20], 4}
    ],

    Example[{Messages, "FieldDoesntExist", "Downloading a field that does not exist in a type returns $Failed:"},
      Download[Object[Sample, "Download Test Oligomer"], Contents],
      $Failed,
      Messages :> {
        Message[Download::FieldDoesntExist]
      }
    ],

    Example[{Messages, "MissingCacheField", "Downloading a field from an object specified via that Cache option which is missing that field goes to the server to get the value but also throws a warning:"},
      With[
        {packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Container, Object]]},

        Download[Object[Sample, "Download Test Oligomer"], Model, Cache -> {packet}]
      ],
      ObjectP[Model[Sample]],
      Messages :> {
        Message[Download::MissingCacheField]
      }
    ],

    Test["MissingCacheField will not be returned for non-super useres:",
      With[
        {packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Container, Object]]},
        Download[Object[Sample, "Download Test Oligomer"], Model, Cache -> {packet}]
      ],
      ObjectP[Model[Sample]],
      (* The postman+user object *)
      Stubs:>{$PersonID=Object[User, "id:lYq9jRxLGdj4"]}
    ],

    Test["Downloading a field from an object that is not specified in the cache and that also does not exist for the type does not throw the MissingCacheError message and only throws FieldDoesntExist:",
      With[
        {packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Container, Object]]},

        Download[Object[Sample, "Download Test Oligomer"], DefaultStorageCondition, Cache -> {packet}]
      ],
      $Failed,
      Messages :> {
        Message[Download::FieldDoesntExist]
      }
    ],

    Test["Downloading a field from an object that is not specified in the cache and that also does not exist for the type does not throw the MissingCacheError message and only throws FieldDoesntExist:",
      With[
        {packet=Download[Object[Sample, "Download Test Oligomer"], Packet[Container, Object]]},
        Download[Object[Sample, "Download Test Oligomer"], Packet[DefaultStorageCondition], Cache -> {packet}]
      ],
      PacketP[],
      Messages :> {
        Message[Download::FieldDoesntExist]
      }
    ],

    Example[{Additional, "Download a field through a link:"},
      Download[Object[Sample, "Download Test Oligomer"], Container[Contents]],
      {{"A1", LinkP[]}}
    ],

    Example[{Additional, "Traversal", "Named rows can be downloaded from fields that are Single:"},
      Download[Object[Example, Data, "Download Test: named fields 1"], NamedSingle[[UnitColumn]]],
      Quantity[11., "Nanometers"]
    ],

    Example[{Additional, "Traversal", "Named columns can be downloaded from fields that are Multiple:"},
      Download[Object[Example, Data, "Download Test: named fields 1"], NamedMultiple[[2, UnitColumn]]],
      Quantity[12., "Nanometers"]
    ],

    Example[{Additional, "Traversal", "Multiple keys can be downloaded from named fields:"},
      Download[Object[Example, Data, "Download Test: named fields 1"], NamedSingle[[{UnitColumn, MultipleLink}]]],
      KeyValuePattern[{UnitColumn -> Quantity[11., "Nanometers"], MultipleLink -> _Link | Null}]
    ],

    Example[{Messages, "Part", "Return $Failed and provide a message when an out of bounds part is is requested from a field:"},
      Download[Object[Container, Rack, "rack"], Contents[[4]]],
      $Failed,
      Messages :> {Message[Download::Part]}
    ],

    Test["Download through a row in a multiple non indexed field:",
      With[
        {
          object=Upload[<|Type -> Object[Example, Data]|>],
          analysis=Upload[<|Type -> Object[Example, Analysis], TableName -> "a name"|>]
        },
        Upload[<|Object -> object, Replace[DataAnalysis] -> {Link[analysis, DataAnalysis]}|>];
        Download[object, DataAnalysis[[1]][TableName]]
      ],
      "a name"
    ],

    Test["Download a span through a link:",
      Download[Object[Container, Rack, "rack"], Contents[[2;;3, 1;;1]]],
      {{"A2"}, {"A3"}}
    ],

    Test["Download a field through a span and a link:",
      Download[Object[Container, Rack, "rack"], Contents[[2;;3, 2]][Name]],
      {"plate2", "plate3"}
    ],

    Example[{Additional, "Field", "Download through links using the Field syntax:"},
      Download[Object[Sample, "Download Test Oligomer"], Field[Container[Container]]],
      LinkP[]
    ],

    Example[{Additional, "Download a field through a link and another field at the same time:"},
      Download[Object[Sample, "Download Test Oligomer"], {Container[Name], Name}],
      {
        "Download Test Plate",
        "Download Test Oligomer"
      }
    ],

    Test["Download a field through a link and another field at the same time with the same root:",
      Module[{object1, object2},
        object1=Upload[<|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>];
        object2=Upload[<|Type -> Object[Example, Data], SingleRelation -> Link[object1, SingleRelationAmbiguous], Replace[Random] -> {4, 5, 6}, Name -> CreateUUID[]|>];

        Download[object2, {SingleRelation[Random], SingleRelation}]
      ],
      {
        N[{1, 2, 3}],
        LinkP[]
      }
    ],

    Test["Downloading a field with length greater than the default page size that is session cached does not produce a recursion error:",
      With[
        {object=Upload[<|Type -> Object[Example, Data], Replace[Random] -> Range[1000]|>]},

        Download[object, Cache -> Session];
        Download[object, Random]
      ],
      N[Range[1000]]
    ],

    Example[{Additional, "Nested Lists", "Download multiple lists of fields from one object:"},
      Download[Object[Sample, "Download Test Oligomer"], {{Status}, {Name, Container}, {}}],
      {{Available}, {"Download Test Oligomer", LinkP[]}, {}}
    ],

    Example[{Additional, "Nested Lists", "For each object, Download a list of fields:"},
      Download[
        {
          Object[Sample, "Download Test Oligomer"],
          Object[Container, Plate, "Download Test Plate"]
        },
        {{Status}, {Name, Container}}
      ],
      {{Available}, {"Download Test Plate", LinkP[]}}
    ],

    Example[{Additional, "Nested Lists", "Download a field from a nested list of objects:"},
      Download[
        {
          {Object[Sample, "Download Test Oligomer"], Object[Container, Plate, "Download Test Plate"]},
          {},
          {Object[Container, Rack, "Download Test Rack"]}
        },
        Name
      ],
      {{"Download Test Oligomer", "Download Test Plate"}, {}, {"Download Test Rack"}}
    ],

    Example[{Additional, "Nested Lists", "Download the same set of fields for each object in a nested list:"},
      Download[
        {
          {Object[Sample, "Download Test Oligomer"], Object[Container, Plate, "Download Test Plate"]},
          {},
          {Object[Container, Rack, "Download Test Rack"]}
        },
        {Name, Status}
      ],
      {{{"Download Test Oligomer", Available}, {"Download Test Plate", Available}}, {}, {{"Download Test Rack", InUse}}}
    ],

    Example[{Additional, "Nested Lists", "For each object in a list of objects, Download the corresponding list of fields:"},
      Download[
        {
          {Object[Sample, "Download Test Oligomer"], Object[Container, Plate, "Download Test Plate"]},
          {},
          {Object[Container, Rack, "Download Test Rack"]}
        },
        {{Name, Status}, {Status}, {Container, Model}}
      ],
      {{{"Download Test Oligomer", Available}, {"Download Test Plate", Available}}, {}, {{Null, Null}}}
    ],

    Example[{Messages, "MapThread", "Returns $Failed and throws a message if search conditions do not match the length of fields:"},
      Download[
        {Object[Sample, "Download Test Oligomer"], Object[Container, Plate, "Download Test Plate"]},
        {Repeated[Container]},
        {Status == Available, None}
      ],
      $Failed,
      Messages :> {
        Message[Download::MapThread, "{Status == Available, None}","Search Conditions","{Repeated[Container]}","Fields"]
      }
    ],

    Example[{Messages, "InvalidField", "Returns $Failed for each field in each object and throws a message if input fields are not symbols or valid link traversal expressions when specified in nested lists:"},
      Download[{Object[Sample, "Download Test Oligomer"]}, {{Container[[Product, 5]][Field]}}],
      {{$Failed}},
      Messages :> {
        Message[Download::InvalidField, "\"Field\""]
      }
    ],

    Example[{Attributes, HoldRest, "The field arguments to Download are held so Evaluate must be used to force evaluation if necessary:"},
      Module[
        {assoc},
        assoc=<|"Field1" -> Container, "Field2" -> Name|>;

        {
          Download[Object[Sample, "Download Test Oligomer"], Lookup[assoc, "Field1"][Lookup[assoc, "Field2"]]],
          Download[Object[Sample, "Download Test Oligomer"], Evaluate[Lookup[assoc, "Field1"][Lookup[assoc, "Field2"]]]]
        }
      ],
      {
        $Failed,
        "Download Test Plate"
      },
      Messages :> {Message[Download::FieldDoesntExist,"Lookup","Object[Sample, \"Download Test Oligomer\"]"]}
    ],

    Example[{Messages, "PacketLength", "Returns $Failed and provides a message when trying to coerce a Length into a Packet:"},
      Download[
        Object[Example, Data, "Download Test: named fields 1"],
        Packet[Length[NamedMultiple]]
      ],
      $Failed,
      Messages :> {Message[Download::PacketLength,"\"{Packet[Length[NamedMultiple]]}\""]}
    ],

    Test["Returns $Failed if Downloading Length ofa  single field:",
      Download[Object[Sample, "Download Test Oligomer"], Length[Name]],
      $Failed,
      Messages :> {Message[Download::Length]}
    ],

    Example[{Attributes, HoldRest, "A symbol with values will be evaluated automatically (without the use of Evaluate):"},
      Module[
        {object, myFields},
        object=Object[Sample, "Download Test Oligomer"];
        myFields={Name, Container};

        Download[object, myFields]
      ],
      {"Download Test Oligomer", LinkP[]}
    ],

    Test["Cache -> packets option works with objects that are not requested:",
      With[
        {
          objects=Upload[{
            <|Type -> Object[Example, Data], Replace[Random] -> {1, 2, 3}|>,
            <|Type -> Object[Example, Data], Name -> CreateUUID[]|>
          }]
        },
        Download[objects[[1]], Cache -> {<|Object -> objects[[2]], Random -> {4}|>}]
      ],
      PacketP[]
    ],

    Test["Returns correct length from explicit cache after Traversal:",
      With[{
        objectA=Upload[<|Type->Object[Container, Plate]|>],
        objectB=Upload[<|Type->Object[Container, Rack]|>]},
        Download[objectA, Container[Length[Contents]],
          Cache -> {
            <|
              Object -> objectA,
              Container -> Link[objectB]
            |>,
            <|
              Object -> objectB,
              Contents -> {{Null, Null, Null}, {Null, Null, Null}}
            |>
          }
        ]
      ],
      2
    ],

    Test["Does not evaluate explicit cache:",
      Download[
        Object[Container, Rack, "Download Test Rack"],
        Name,
        Cache -> {<|
          Object -> Object[Container, Rack, "id:54n6evKYp1N7"],
          Name -> "Download Test Rack",
          UhOh :> (On[Assert];Assert[False];Off[Assert])
        |>}
      ],
      "Download Test Rack"
    ],

    Test["Returns part from explicit cache:",
      Download[
        Object[Container, Plate, "id:abc"],
        Container[Contents][[1, 1;;2]],
        Cache -> {
          <|
            Object -> Object[Container, Plate, "id:abc"],
            Container -> Link[Object[Container, Rack, "id:def"], Contents, 2]
          |>,
          <|
            Object -> Object[Container, Rack, "id:def"],
            Contents -> {{1, 2, 3}, {"A", "B", "C"}}
          |>
        }
      ],
      {1, 2}
    ],

    Test["Returns all from explicit cache:",
      Download[
        objectA,
        Container[Container][All],
        Cache -> {
          <|
            Object -> objectA,
            Container -> Link[objectB, Contents, 2]
          |>,
          <|
            Object -> objectB,
            Container -> Link[objectC, Contents, 2]
          |>,
          <|
            Object -> objectC,
            Contents -> {{1, 2, 3}, {"A", "B", "C"}}
          |>
        }
      ],
      KeyValuePattern[{Object -> objectC, Contents -> {{1, 2, 3}, {"A", "B", "C"}}}],
      Variables :> {objectA, objectB, objectC},
      SetUp :> (
        {objectA, objectB, objectC} = Upload[{<|Type->Object[Sample]|>,<|Type->Object[Container, Plate]|>,<|Type->Object[Container, Rack]|>}];
      )
    ],

    Test["Returns named part from explicit cache:",
      With[{obj=Upload[<|Type->Object[Example,Data]|>]},
        Download[obj, NamedSingle[[UnitColumn]],
          Cache -> {<|
            Object -> obj,
            NamedSingle -> <|
              UnitColumn -> Quantity[12.`, "Nanometers"],
              MultipleLink -> Null
            |>
          |>}
        ]
      ],
      Quantity[12., "Nanometers"]
    ],

    Test["Download all values at a specific index from a field and a field that has no value:",
      With[
        {
          object=Upload[
            Association[
              Type -> Object[Example, Data],
              Replace[GroupedUnits] -> {
                {"Hello", 10 Minute},
                {"World", 5 Minute}
              }
            ]
          ]
        },

        Download[object, {Name, GroupedUnits[[All, 1]], GroupedMultipleReplaceRelation[[2]]}]
      ],
      {Null, {"Hello", "World"}, $Failed},
      Messages :> {Message[Download::Part]}
    ],

    Test["Downloading All from a indexed multple field returns packets:",
      Download[Object[Container, Rack, "rack"], Contents[[All, 2]][All]],
      {_Association, _Association, _Association}
    ],

    Test["Downloading All from a multiple to single field returns packets:",
      Download[Object[Example, Data, "tree: 1"], MultipleAppendRelation[SingleRelation][All]],
      {_Association, _Association}
    ],

    Test["Downloading All from a row of a multiple field returns packets:",
      Download[Object[Example, Data, "tree: 1"], MultipleAppendRelation[[1]][All]],
      _Association
    ],

    Test["Download All from a sequence of multiple fields returns packets:",
      With[{objects=Upload[Table[<|Type -> Object[Example, Data]|>, {7}]]},
        Upload[{
          <|Object -> objects[[1]], Replace[MultipleAppendRelation] -> {Link[objects[[2]], MultipleAppendRelationAmbiguous], Link[objects[[3]], MultipleAppendRelationAmbiguous]}|>,
          <|Object -> objects[[2]], Replace[MultipleAppendRelation] -> {Link[objects[[4]], MultipleAppendRelationAmbiguous], Link[objects[[5]], MultipleAppendRelationAmbiguous]}|>,
          <|Object -> objects[[3]], Replace[MultipleAppendRelation] -> {Link[objects[[6]], MultipleAppendRelationAmbiguous], Link[objects[[7]], MultipleAppendRelationAmbiguous]}|>
        }];
        Download[objects[[1]], MultipleAppendRelation[MultipleAppendRelation][All]]
      ],
      {{_Association, _Association}, {_Association, _Association}}
    ],

    Test["Download All from a multiple to single relation returns Null when the single fields are null:",
      Download[Object[Example, Data, "tree: 1"], MultipleAppendRelation[TestName][All]],
      {Null, Null}
    ],

    Test["Downloading All from a sequence of multiple fields returns packets:",
      Download[Object[Container, Rack, "rack"], Contents[[All, 2]][Contents][[All, 2]][All]],
      {{_Association, _Association, _Association},
        {_Association, _Association, _Association},
        {}}
    ],

    Test["MapThread over the same object works correctly:",
      Download[
        {Object[Sample, "Download Test Oligomer"], Object[Sample, "Download Test Oligomer"]},
        {{Name}, {Container}}
      ],
      {{"Download Test Oligomer"}, {LinkP[]}}
    ],

    Test["Downloading through links behavior ok when some part of the path does not exist in some of the objects:",
      Module[{newIds, data1, data2, person1},
        newIds=Upload[{
          <|Type -> Object[Example, Data], Name -> "data 1 "<>CreateUUID[], Replace[Random] -> {1.1, 1.2, 1.3}|>,
          <|Type -> Object[Example, Data], Name -> "data 2 "<>CreateUUID[], Replace[Random] -> {2.1, 2.2, 2.3}|>,
          <|Type -> Object[Example, Person, Emerald], Name -> "person 1 "<>CreateUUID[]|>
        }];
        {data1, data2, person1}=newIds;
        Upload[{
          <|Object -> data1, Replace[PersonRelation] -> Link[person1, DataRelation]|>,
          <|Object -> person1, Append[DataRelation] -> {Link[data2, PersonRelation]}|>
        }];
        ClearDownload[];
        Download[
          {person1, data1},
          {
            {Name},
            {Name, PersonRelation[Random]}
          }
        ]
      ],
      _List,
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["Downloading a field from a temporal packet in the explicit cache _does_ go to the server if traversing through a link missing in the packet:",
      Module[
        {object, relatedObject, date},
        relatedObject=Upload[<|Type -> Object[Example, Analysis], StringData -> "blah"|>];
        (* These are blazing fast so pause for a moment *)
        Pause[1];
        date=Now;
        object=Upload[<|Type -> Object[Example, Data], OneWayLinkTemporal -> Link[relatedObject, date]|>];
        Download[object, OneWayLinkTemporal[StringData], Cache -> {<|Object -> object|>}]
      ],
      "blah",
      Messages :> {Message[Download::MissingCacheField]}
    ],

    Test["Downloading a field from a packet in the explicit cache does go to the server if traversing through a link that exists in the packet:",
      Module[
        {object, relatedObject},
        relatedObject=Upload[<|Type -> Object[Example, Data], Append[Random] -> {1, 2, 3}|>];
        object=Upload[<|Type -> Object[Example, Data], SingleRelation -> Link[relatedObject, SingleRelationAmbiguous]|>];

        Download[object, SingleRelation[Random], Cache -> {Download[object]}]
      ],
      N[{1, 2, 3}]
    ],

    Example[{Messages, "NotLinkField", "All cannot be the first symbol in a Field:"},
      Download[Object[Sample, "Download Test Oligomer"], All[Protocols][Name]],
      $Failed,
      Messages :> {
        Message[Download::NotLinkField, "All[Protocols[Name]]", "All"]
      }
    ],

    Example[{Messages, "InvalidField", "Field sequence with nonsense inputs throws an error:"},
      Download[Object[Sample, "Download Test Oligomer"], InvalidField],
      $Failed,
      Messages :> {
        Message[Download::FieldDoesntExist,"Constellation`Private`InvalidField","Object[Sample, \"Download Test Oligomer\"]"]
      }
    ],

    Example[{Messages, "UnknownType", "Nonexistant type returns $Failed and provides an error:"},
      Download[Object[A, B, "id"]],
      $Failed,
      Messages :> {
        Message[Download::UnknownType,"{Object[A, B]}"]
      }
    ],

    Example[{Messages, "InvalidSearch", "Returns $Failed and throws a message if search conditions are not properly formatted:"},
      Download[Object[Sample, "Download Test Oligomer"], Repeated[Container], This + Is + Not - ValidSearch],
      $Failed,
      Messages :> {
        Message[Download::InvalidSearch, {HoldForm[This + Is + Not - ValidSearch]}, {Defer[Repeated[Container]]}]
      }
    ],

    Example[{Additional, "Search Conditions", "Recursively download a link field while a search condition remains True:"},
      Download[Object[Sample, "Download Test Oligomer"], Repeated[Container], Status == Available && DeveloperObject == True],
      {LinkP[Object[Container, Plate]]}
    ],

    Test["Recursively download a multiple link field while a search condition remains True:",
      Download[Object[Container, Rack, "rack"], Contents[[All, 2]]..[Object],
        Type == Object[Container, Plate] && DeveloperObject == True
      ],
      {{ObjectReferenceP[Object[Container, Plate]], {}}, {ObjectReferenceP[Object[Container, Plate]], {}}, {ObjectReferenceP[Object[Container, Plate]], {}}}
    ],

    Test["Recursively download a multiple link field through a packet, while a search condition remains True:",
      With[{packet=Download[Object[Container, Rack, "rack"]]},
        Download[packet, Contents[[All, 2]]..[Object],
          Type == Object[Container, Plate] && DeveloperObject == True
        ]
      ],
      {{ObjectReferenceP[Object[Container, Plate]], {}}, {ObjectReferenceP[Object[Container, Plate]], {}}, {ObjectReferenceP[Object[Container, Plate]], {}}}
    ],

    Example[{Additional, "Search Conditions", "None must be used as a placeholder when recursively downloading some fields with search conditions but not others:"},
      Download[{Object[Sample, "Download Test Oligomer"], Object[Container, Plate, "Download Test Plate"]}, {Repeated[Container], Name}, {Status == Available && DeveloperObject == True, None}],
      {
        {{LinkP[Object[Container, Plate]]}, "Download Test Oligomer"},
        {{}, "Download Test Plate"}
      }
    ],

    Example[{Additional, "Search Conditions", "Use search conditions when downloading different fields from different objects:"},
      Download[{{Object[Sample, "Download Test Oligomer"]}, {Object[Container, Plate, "Download Test Plate"]}}, {{Repeated[Container]}, {Name}}, {{Status == Available && DeveloperObject == True}, {None}}],
      {
        {{{LinkP[Object[Container, Plate]]}}},
        {{"Download Test Plate"}}
      }
    ],

    Example[{Messages, "UnusedSearchConditions", "A warning will be thrown if search conditions are specified for a non-recursive download:"},
      Download[Object[Sample, "Download Test Oligomer"], Name, Status == Available],
      "Download Test Oligomer",
      Messages :> {
        Message[Download::UnusedSearchConditions, "{{Status == Available}}","{{Name}}"]
      }
    ],

    (* Recursive Download Single*)
    Example[{Additional, "Repeated", "Downloading a repeated field MyField.. returns each MyField available through repeated MyField references, until an object does not contain MyField:"},
      Download[Object[Sample, "Download Test Oligomer"], Container ..],
      {LinkP[Object[Container, Plate], Contents, 2], LinkP[Object[Container, Rack], Contents, 2]}
    ],

    Example[{Additional, "Repeated", "Downloading a repeated field MyFields.. returns $Failed each time a type does not contain the required field:"},
      Download[Object[Container, Rack, "Download Test Rack"], Repeated[Contents[[All, 2]]]],
      {{
        LinkP[Object[Container, Plate], Container], {{
          LinkP[Object[Sample], Container],
          $Failed
        }}
      }},
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["Downloading a repeated field MyField.. followed by more fields returns $Failed each time a type does not contain the required field:",
      Download[Object[Container, Rack, "Download Test Rack"], Repeated[Contents[[All, 2]]][{Name, Object}]],
      {{
        {"Download Test Plate", ObjectReferenceP[Object[Container, Plate]]}, {
          {
            {"Download Test Oligomer", ObjectReferenceP[Object[Sample]]},
            $Failed
          }
        }
      }},
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["When downloading through a packet, and a Repeated sequence returns $Failed, return $Failed for links that follow in the traversal:",
      With[{packet=Download[Object[Container, Rack, "Download Test Rack"]]},
        Download[packet, Contents[[All, 2]]..[{Name, Object}]]
      ],
      {{
        { "Download Test Plate", ObjectReferenceP[Object[Container, Plate]] },
        {{
          { "Download Test Oligomer", ObjectReferenceP[Object[Sample]] },
          $Failed
        }}
      }},
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["When downloading a Repeated sequence, which returns $Failed after one link, return $Failed for links that follow in the traversal:",
      Download[Object[Container, Plate, "Download Test Plate"], Contents[[All, 2]]..[{Name, Object}]],
      {{
        { "Download Test Oligomer", ObjectReferenceP[Object[Sample]] },
        $Failed
      }},
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["When downloading through a packet, and a Repeated sequence returns $Failed after one link, return $Failed for links that follow in the traversal:",
      With[{packet=Download[Object[Container, Plate, "Download Test Plate"]]},
        Download[packet, Contents[[All, 2]]..[{Name, Object}]]
      ],
      {{
        { "Download Test Oligomer", ObjectReferenceP[Object[Sample]] },
        $Failed
      }},
      Messages :> {Message[Download::FieldDoesntExist]}
    ],

    Test["Downloading a repeated field MyField.. that is not a link returns $Failed and provides a Download::NotLinkField message:",
      Download[Object[Example, Data, "linked list 1"], Name..],
      $Failed,
      Messages :> {Message[Download::NotLinkField, "Name..", "Name"]}
    ],

    Test["A repeated field can be downloaded from a list of objects:",
      Download[{object1, object2}, SingleRelation..],
      {links1, links2},
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A repeated field can be downloaded from a nested list of objects:",
      Download[{{object1, object2}, {object3, object1}}, SingleRelation..],
      {
        {links1, links2},
        {links3, links1}
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A list of repeated fields can be downloaded from an object:",
      Download[object1, {SingleRelation.., TestName..}],
      {links1, {LinkP[object4, ReplaceRepeated]}},
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A list of repeated fields can be downloaded from a list of objects:",
      Download[{object1, object2}, {SingleRelation.., TestName..}],
      {
        {links1, {LinkP[object4, ReplaceRepeated]}},
        {links2, {LinkP[object4, ReplaceRepeated]}}
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A list of repeated fields can be downloaded from a nested list of objects:",
      Download[{{object1, object2}, {object3, object1}}, {SingleRelation.., TestName}],
      {
        {
          {links1, LinkP[object4, ReplaceRepeated]},
          {links2, LinkP[object4, ReplaceRepeated]}
        },
        {
          {links3, LinkP[object4, ReplaceRepeated]},
          {links1, LinkP[object4, ReplaceRepeated]}
        }
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A nested list of repeated fields can be downloaded from an object:",
      Download[object1, {{SingleRelation.., TestName..}, {TestName..}}],
      {
        {links1, {LinkP[object4, ReplaceRepeated]}},
        {{LinkP[object4, ReplaceRepeated]}}
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A nested list of repeated fields can be downloaded from a list of objects:",
      Download[{object1, object2}, {{SingleRelation.., TestName..}, {TestName..}}],
      {
        {links1, {LinkP[object4, ReplaceRepeated]}},
        {{LinkP[object4, ReplaceRepeated]}}
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["A nested list of repeated fields can be downloaded from a nested list of objects:",
      Download[{{object1, object2}, {object3, object1}}, {{SingleRelation.., TestName..}, {TestName..}}],
      {
        {
          {links1, {LinkP[object4, ReplaceRepeated]}}, (* 2, 1 *)
          {links2, {LinkP[object4, ReplaceRepeated]}} (* 1, 2 *)
        },
        {
          {{LinkP[object4, ReplaceRepeated]}}, (* 2, 1 *)
          {{LinkP[object4, ReplaceRepeated]}} (* 2, 2 *)
        }
      },
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Test["Downloading a field repeated a maximum number of N times will return at most N fields:",
      Download[object1, Repeated[SingleRelation, 2]],
      Take[links1, 2],
      Variables :> {object1, object2, object3, object4, links1, links2, links3},
      SetUp :> (
        {object1, object2, object3, object4, links1, links2, links3}=setupRepeatedObjects[];
      )
    ],

    Example[{Messages, "Cycle", "Recursively downloading a field which results in a cycle stops when it reaches a previously traversed element and throws a message:"},
      Download[Object[Container, Rack, "Download Test: cycle 1"], Container..],
      {
        LinkP[Object[Container, Rack]],
        LinkP[Object[Container, Rack]],
        LinkP[Object[Container, Rack, "Download Test: cycle 1"]]
      },
      Messages :> {Download::Cycle}
    ],

    Test["Recursively downloading from a packet a field which results in a cycle stops when it reaches a previously traversed element and throws a message:",
      With[{packet=Download[Object[Container, Rack, "Download Test: cycle 1"]]},
        Download[packet, Container..]
      ],
      {
        LinkP[Object[Container, Rack]],
        LinkP[Object[Container, Rack]],
        LinkP[Object[Container, Rack, "Download Test: cycle 1"]]
      },
      Messages :> {Message[Download::Cycle]}
    ],

    Test["A recursive field can be downloaded through a Packet:",
      With[{rootPacket=Download[Object[Example, Data, "linked list 1"]]},
        Download[rootPacket, SingleRelation..[Number]]
      ],
      {2., 3., 4., 5.}
    ],

    Test["A finite recursive field can be downloaded through a Packet:",
      With[{rootPacket=Download[Object[Example, Data, "linked list 1"]]},
        Download[rootPacket, Repeated[SingleRelation, 2][Number]]
      ],
      {2., 3.}
    ],

    Test["Recursively downloading a Null field returns an empty list:",
      Download[Object[Example, Data, "linked list 5"], SingleRelation..],
      {}
    ],

    Test["Recursively downloading an indexed field with non links Returns failed and provides a NotLinkField message:",
      Download[Object[Container, Rack, "Download Test Rack"], Contents..],
      $Failed,
      Messages :> {Message[Download::NotLinkField, "Contents..", "Contents"]}
    ],

    Test["Recursively downloading an indexed field with non links from a packet Returns failed and provides a NotLinkField message:",
      With[{packet=Download[Object[Container, Rack, "Download Test Rack"]]},
        Download[packet, Contents..]
      ],
      $Failed,
      Messages :> {Message[Download::NotLinkField, "Contents..", "Contents"]}
    ],

    Test["Recursively downloading 1 repetition of a null field, followed by more fields, returns {}:",
      Download[Object[Container, Rack, "rack"], Repeated[Container, 1][Object]],
      {}
    ],

    Test["Recursively downloading one more repetition than exists on server returns those items on the server:",
      Download[Object[Example, Data, "linked list 1"], Repeated[SingleRelation, 5]],
      {Repeated[LinkP[Object[Example, Data]], 4]}
    ],

    (* Recursive Download Multiple *)
    Test["Recursively downloading multiple fields returns a nested list of items:",
      Download[Object[Container, Rack, "rack"], Repeated[Contents[[All, 2]], 2][Name]],
      {
        {"plate1", {"oligomer1", "oligomer2", "oligomer3"}},
        {"plate2", {"oligomer4", "oligomer5", "oligomer6"}},
        {"plate3", {}}
      }
    ],

    Test["Recursively Download a multiple Field through a packet:",
      With[{packet=Download[Object[Container, Rack, "rack"]]},
        Download[packet, Repeated[Contents[[All, 2]], 2][Name]]
      ],
      {
        {"plate1", {"oligomer1", "oligomer2", "oligomer3"}},
        {"plate2", {"oligomer4", "oligomer5", "oligomer6"}},
        {"plate3", {}}
      }
    ],

    Example[{Additional, "Length", "Length fields can contain subsequent fields, but only the length of the first field is returned:"},
      Download[Object[Container, Rack, "Download Test Rack"], Length[Contents[Name]]],
      1
    ],

    Example[{Additional, "Length", "Download the length of a Repeated traversal:"},
      Download[
        Object[Sample, "Download Test Oligomer"],
        Length[Repeated[Container]]
      ],
      2
    ],

    Example[{Messages, "Length", "Cannot Download Length from a single field:"},
      Download[Object[Container, Rack, "Download Test Rack"], Length[Name]],
      $Failed,
      Messages :> {
        Message[Download::Length]
      }
    ],

    (* Recursive Download Nested *)
    Test["Recursively downloading a sequence of fields returns the fields found by repeatedly following the sequence:",
      Module[{skippedList},
        skippedList=Download[Object[Example, Data, "linked list 1"], SingleRelation[SingleRelation]..];
        skippedList[Number]
      ],
      {3., 5.}
    ],

    Test["A recursive sequence of fields can be followed by a non recursive sequence:",
      Download[Object[Example, Data, "linked list 1"], SingleRelation[SingleRelation]..[Number]],
      {3., 5.}
    ],

    Test["A nested recursive field can be downloaded through a Packet:",
      Module[{rootPacket},
        rootPacket=Download[Object[Example, Data, "linked list 1"]];
        Download[
          Download[rootPacket, SingleRelation[SingleRelation]..],
          Number
        ]
      ],
      {3., 5.}
    ],

    Test["Recursively downloading a sequence of multiple fields returns a tree of fields found by repeatedly following the sequence:",
      Module[{nodes},
        setupTree[];
        nodes=Download[Object[Example, Data, "tree: 1"], MultipleAppendRelation[SingleRelation]..];
        nodes /. MapThread[Rule, {Flatten[nodes], Download[Flatten[nodes], Number]}]
      ],
      {
        {111., {{11111., {}}, {11121., {}}}},
        {121., {{12111., {}}, {12121., {}}}}
      }
    ],

    Test["A recursive sequence over multiple fields can be followed by additional fields:",
      Download[Object[Example, Data, "tree: 1"], MultipleAppendRelation[SingleRelation]..[Name]],
      {
        {
          "tree: 111", {
          {"tree: 11111", {}},
          {"tree: 11121", {}}
        }
        },
        {
          "tree: 121", {
          {"tree: 12111", {}},
          {"tree: 12121", {}}
        }
        }
      }
    ],

    Test["A recursive sequence over multiple fields can be followed by additional fields and downloaded through a packet:",
      With[{packet=Download[Object[Example, Data, "tree: 1"]]},
        Download[packet, MultipleAppendRelation[SingleRelation]..[Name]]
      ],
      {
        {
          "tree: 111", {
          {"tree: 11111", {}},
          {"tree: 11121", {}}
        }
        },
        {
          "tree: 121", {
          {"tree: 12111", {}},
          {"tree: 12121", {}}
        }
        }
      }
    ],

    Test["Downloading Repeated from session cached objects always goes to server:",
      Module[
        {ids},
        ids=CreateID[Table[Object[Example, Data], {5}]];
        Upload[{
          <|Object -> ids[[1]], SingleRelation -> Link[ids[[2]], SingleRelationAmbiguous]|>,
          <|Object -> ids[[2]], SingleRelation -> Link[ids[[3]], SingleRelationAmbiguous]|>,
          <|Object -> ids[[3]], SingleRelation -> Link[ids[[4]], SingleRelationAmbiguous]|>,
          <|Object -> ids[[4]], SingleRelation -> Link[ids[[5]], SingleRelationAmbiguous]|>
        }];
        Download[ids[[1;;2]], Cache -> Session];
        Download[ids[[1]], Repeated[SingleRelation]]
      ],
      {Repeated[LinkP[], {4}]}
    ],

    Example[{Messages, "NotLinkField", "Cannot download through links for fields which are not links:"},
      Download[Object[Sample, "Download Test Oligomer"], Name[Container][Model]],
      $Failed,
      Messages :> {
        Message[Download::NotLinkField, "{Defer[Name[Container][Model]]}", "{Defer[Name]}"]
      }
    ],

    Test["Only those fields which are failing are returned as $Failed when downloading through links:",
      Download[Object[Sample, "Download Test Oligomer"], {Container, Container[Name][Model]}],
      {_Link, $Failed},
      Messages :> {
        Message[Download::NotLinkField, "{Defer[Container[Name][Model]]}","{Defer[Name]}"]
      }
    ],

    Test["Downloading a sequence of fields, one of which is not a link, provides a NotLinkField message:",
      Download[Object[Container, Rack, "rack"], Contents[[All, 2]][Name][Object]],
      {$Failed, $Failed, $Failed},
      Messages :> {Download::NotLinkField}
    ],

    Test["Downloading a list of field sequences provides a NotLinkField message when a traversed field is not a link:",
      Download[Object[Container, Rack, "rack"], {Contents[[All, 2]][Name][Object], Name}],
      {{$Failed, $Failed, $Failed}, "rack"},
      Messages :> {Download::NotLinkField}
    ],

    Test["Downloading All through a field when the root is a packet returns a packet:",
      Module[
        {rootPacket, relationPacket, objects},
        objects=Upload[Table[<|Type -> Object[Example, Data]|>, {2}]];
        Upload[<|Object -> objects[[1]], SingleRelation -> Link[objects[[2]], SingleRelationAmbiguous]|>];
        {rootPacket, relationPacket}=Download[objects];

        SameQ[
          KeySort[Download[rootPacket, SingleRelation[All]]],
          KeySort[relationPacket]
        ]
      ],
      True
    ],

    Test["Recursive Download with Search conditions filters correctly:",
      With[{objects=Upload[Table[<|Type -> Object[Example, Data]|>, 4]]},
        Upload[{
          <|Object -> objects[[1]], SingleRelation -> Link[objects[[2]], SingleRelationAmbiguous]|>,
          <|Object -> objects[[2]], SingleRelation -> Link[objects[[3]], SingleRelationAmbiguous]|>,
          <|Object -> objects[[3]], SingleRelation -> Link[objects[[4]], SingleRelationAmbiguous]|>
        }];
        (*Get everything in the cache so we can be sure the additional items are not returned*)
        Download[objects[[1]], SingleRelation..];
        With[{obj=objects[[4]]},
          Download[objects[[1]], SingleRelation.., SingleRelation != obj]
        ]
      ],
      {LinkP[Object[Example, Data]]}
    ],

    Test["Download single indices from multiple, multiple fields starting with an object reference:",
      With[{objects=Upload[Table[<|Type -> Object[Example, Data]|>, 3]]},
        Upload[{
          <|
            Object -> objects[[1]],
            Append[MultipleAppendRelation] -> {
              Link[objects[[2]], MultipleAppendRelationAmbiguous],
              Link[objects[[3]], MultipleAppendRelationAmbiguous]
            }
          |>,
          <|Object -> objects[[2]], Append[Random] -> {1, 2, 3}|>
        }];

        Download[objects[[1]], Field[MultipleAppendRelation[[1]][Random][[1]]]]
      ],
      1.0
    ],

    Test["Download single indices from multiple, multiple fields starting with a packet reference:",
      With[{objects=Upload[Table[<|Type -> Object[Example, Data]|>, 3]]},
        Upload[{
          <|
            Object -> objects[[1]],
            Append[MultipleAppendRelation] -> {
              Link[objects[[2]], MultipleAppendRelationAmbiguous],
              Link[objects[[3]], MultipleAppendRelationAmbiguous]
            }
          |>,
          <|Object -> objects[[2]], Append[Random] -> {1, 2, 3}|>
        }];

        With[{packet=Download[objects[[1]]]},
          Download[packet, Field[MultipleAppendRelation[[1]][Random][[1]]]]
        ]
      ],
      1.0
    ],

    Example[{Additional, "Named Fields", "Download a named single field:"},
      With[
        {obj=Upload[<|
          Type -> Object[Example, Data],
          NamedSingle -> <|UnitColumn -> 1 Nanometer, MultipleLink -> Null|>
        |>]},

        Download[obj, NamedSingle]
      ],

      <|UnitColumn -> 1. Nanometer, MultipleLink -> Null|>
    ],

    Example[{Additional, "Named Fields", "Download a named multiple field:"},
      With[
        {obj=Upload[<|
          Type -> Object[Example, Data],
          Replace[NamedMultiple] -> {<|UnitColumn -> 1 Nanometer, SingleLink -> Null|>}
        |>]},

        Download[obj, NamedMultiple]
      ],

      {<|UnitColumn -> 1. Nanometer, SingleLink -> Null|>}
    ],

    Test["Download named multiple field from packet:",
      With[
        {packet=Download[Upload[<|
          Type -> Object[Example, Data],
          Replace[NamedMultiple] -> {
            <|UnitColumn -> 1 Nanometer, SingleLink -> Null|>
          }
        |>]]},

        Download[packet, NamedMultiple]
      ],
      {<|UnitColumn -> 1. Nanometer, SingleLink -> Null|>}
    ],

    Test["Downloading a list of fields from a nested object:",
      Download[
        {{Object[Sample, "Download Test Oligomer"]}},
        {{{Object, Type}, ID}}
      ],
      {{{{Object[Sample, _String], Object[Sample]}, _String}}}
    ],

    Test["Downloading a list of fields from a nested packet:",
      With[
        {packet=Download[Object[Sample, "Download Test Oligomer"]]},

        Download[{{packet}}, {{{Object, Type}, ID}}]
      ],
      {{{{Object[Sample, _String], Object[Sample]}, _String}}}
    ],

    (* 1 object, 1 _Packet *)
    Example[{Additional, "Packet", "Download fields into a Packet :"},
      Download[Object[User, Emerald, Developer, "Test: developer 1"], Packet[Name, MiddleName]],
      KeyValuePattern@{
        Name -> _String,
        MiddleName -> _String,
        (* default fields *)
        ID -> _String,
        Object -> _,
        Type -> _
      }
    ],

    Example[{Additional, "Packet", "Downloading with an empty Packet of fields returns a packet of default fields:"},
      Download[Object[User, Emerald, Developer, "Test: developer 1"], Packet[]],
      KeyValuePattern@{ID -> _String, Object -> _, Type -> _}
    ],

    Test["Downloading with an empty Packet of fields FROM a user-specifed packet with missing ID and Type can derive them from the Object:",
      Download[<|Object -> Object[User, "id:321"], Name -> "Kevin"|>, Packet[Name]],
      KeyValuePattern@{Name -> "Kevin", ID -> "id:321", Object -> Object[User, "id:321"], Type -> Object[User]}
    ],

    Test["Downloading with an empty Packet of fields FROM a user-specifed packet with missing Object can derive them from the ID and Type:",
      Download[<|Type -> Object[User], ID -> "id:321", Name -> "Kevin"|>, Packet[Name]],
      KeyValuePattern@{Name -> "Kevin", ID -> "id:321", Object -> Object[User, "id:321"], Type -> Object[User]}
    ],

    Example[{Additional, "Packet", "Downloading with a list of Packets of fields, instead of a list of lists of fields, returns a list of packets:"},
      Download[$PersonID, {Packet[Name], Packet[ID]}],
      {
        KeyValuePattern@{ID -> _, Object -> _, Type -> _, Name -> _},
        KeyValuePattern@{ID -> _, Object -> _, Type -> _}
      }
    ],

    Example[{Messages, "PacketWrapperMultipleObjects", "When using the Packet syntax, cannot download through multiple links in the same Packet:"},
      Download[Object[Sample, "Download Test Oligomer"], Packet[Repeated[Container], Container[Name]]],
      $Failed,
      Messages :> {
        Message[Download::PacketWrapperMultipleObjects, "\"{Packet[Repeated[Container],Container[Name]]}\""]
      }
    ],

    Example[{Additional, "Packet", "Downloading using Repeated & Packet returns a packet at each level:"},
      Download[Object[Sample, "Download Test Oligomer"], Packet[Repeated[Container]]],
      {PacketP[Object[Container, Plate]], PacketP[Object[Container, Rack]]}
    ],

    Example[{Additional, "Packet", "Download through links and get back a packet with the specified fields:"},
      Download[Object[Container, Rack, "Download Test Rack"], Packet[Contents[[All, 2]][{Container, Name}]]],
      {
        KeyValuePattern[{
          Object -> ObjectReferenceP[Object[Container, Plate]],
          Type -> Object[Container, Plate],
          ID -> _String,
          Name -> "Download Test Plate",
          Container -> LinkP[]
        }]
      }
    ],

    Test["Download Repeated with the Packet wrapper after traversing a link:",
      Download[Object[Sample, "Download Test Oligomer"], Packet[Container[Repeated[Container]]]],
      {
        KeyValuePattern[{
          Object -> ObjectReferenceP[Object[Container, Rack]],
          Type -> Object[Container, Rack],
          ID -> _String
        }]
      }
    ],

    Example[{Additional, "Packet", "Downloading additional fields from Repeated using Packet returns a packet for each set of fields:"},
      Download[Object[Sample, "Download Test Oligomer"], Packet[Repeated[Container][{Name, Contents}]]],
      {
        KeyValuePattern[{
          Object -> ObjectReferenceP[Object[Container, Plate]],
          Type -> Object[Container, Plate],
          ID -> _String,
          Name -> "Download Test Plate",
          Contents -> _List
        }],
        KeyValuePattern[{
          Object -> ObjectReferenceP[Object[Container, Rack]],
          Type -> Object[Container, Rack],
          ID -> _String,
          Name -> "Download Test Rack",
          Contents -> _List
        }]
      }
    ],

    Example[{Additional, "Packet", "Downloading one object with a List[List[___Packet]] of fields works:"},
      Download[Object[User, Emerald, Developer, "Test: developer 1"],
        {
          {Packet[Name], Packet[HireDate]},
          {Packet[LastName]}
        }
      ],
      {
        {
          KeyValuePattern@{Name -> Object[User, Emerald, Developer, "Test: developer 1"][Name]},
          KeyValuePattern@{HireDate -> Object[User, Emerald, Developer, "Test: developer 1"][HireDate]}
        },
        {
          KeyValuePattern@{LastName -> Object[User, Emerald, Developer, "Test: developer 1"][LastName]}
        }
      }
    ],

    Example[{Additional, "Packet", "Downloading a List[objects] with a List[List[___Packet]] of fields works:"},
      Download[{
        Object[User, Emerald, Operator, "Test: operator 1"],
        Object[User, Emerald, Operator, "Test: operator 2"]
      }, {
        {Packet[Name], Packet[HireDate]},
        {Packet[LastName]}
      }],
      {
        {
          KeyValuePattern@{Name -> Object[User, Emerald, Operator, "Test: operator 1"][Name]},
          KeyValuePattern@{HireDate -> Object[User, Emerald, Operator, "Test: operator 1"][HireDate]}
        },
        {
          KeyValuePattern@{LastName -> Object[User, Emerald, Operator, "Test: operator 2"][LastName]}
        }
      }
    ],

    Example[{Additional, "Packet", "Downloading a List[List[objects]] with a List[List[___Packet]] of fields works:"},
      Download[{
        {
          Object[User, Emerald, Developer, "Test: developer 1"],
          Object[User, Emerald, Developer, "Test: developer 2"]
        }, {
          Object[User, Emerald, Operator, "Test: operator 1"],
          Object[User, Emerald, Operator, "Test: operator 2"]
        }
      }, {
        {Packet[Name], Packet[HireDate]},
        {Packet[LastName]}
      }],
      {
        {
          {
            KeyValuePattern@{Name -> Object[User, Emerald, Developer, "Test: developer 1"][Name]},
            KeyValuePattern@{HireDate -> Object[User, Emerald, Developer, "Test: developer 1"][HireDate]}
          }, {
          KeyValuePattern@{Name -> Object[User, Emerald, Developer, "Test: developer 2"][Name]},
          KeyValuePattern@{HireDate -> Object[User, Emerald, Developer, "Test: developer 2"][HireDate]}
        }
        }, {
        {
          KeyValuePattern@{LastName -> Object[User, Emerald, Operator, "Test: operator 1"][LastName]}
        }, {
          KeyValuePattern@{LastName -> Object[User, Emerald, Operator, "Test: operator 2"][LastName]}
        }
      }
      }
    ],

    Example[{Additional, "Packet", "Downloading with a list of fields and Packets of fields, returns a list of some packets and some values:"},
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {Packet[Name], Packet[Status], Status, LastName, MiddleName}
      ],
      {
        KeyValuePattern@{Name -> _String},
        KeyValuePattern@{Status -> _},
        _,
        _String,
        _String
      }
    ],

    Test["Downloading Packet[All] provides a packet with all fields populated:",
      Download[Object[Sample, "Download Test Oligomer"], Packet[All]],
      KeyValuePattern[Name -> "Download Test Oligomer"]
    ],

    Example[{Messages, "RedundantField", "Downloading Packet[All, Field] provides a packet with all fields populated, and warns that Field is redundant:"},
      Download[Object[Sample, "Download Test Oligomer"], Packet[All, Name]],
      KeyValuePattern[Name -> "Download Test Oligomer"],
      Messages :> {Message[Download::RedundantField, {Packet[All, Name]}]}
    ],

    Test["Downloading with a mixed list of Packets (of fields) AND lists (of fields), is unsupported:",
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {Packet[Name], Packet[MiddleName], {MiddleName, LastName, FirstName}}
      ],
      _Download
    ],

    Test["Downloading with a List[List[List[___Packet]]] of fields is unsupported:",
      (* we should make this return a single failure and message *)
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {
          {
            {Packet[Type]},
            {Packet[Name], Packet[ID]}
          }, {
          {Packet[MiddleName]}
        }
        }
      ],
      _Download
    ],

    (* lists of objects, 1 _Packet *)
    Test["Downloading with a Packet of fields, for a list of objects, works:",
      Download[
        {
          Object[User, Emerald, Developer, "Test: developer 1"],
          Object[User, Emerald, Developer, "Test: developer 2"]
        },
        Packet[Name]
      ],
      {
        KeyValuePattern@{Name -> _String},
        KeyValuePattern@{Name -> _String}
      }
    ],

    Test["Downloading with a Packet of fields, for a list of objects, works:",
      Download[
        {
          {
            Object[User, Emerald, Developer, "Test: developer 1"],
            Object[User, Emerald, Developer, "Test: developer 1"]
          },
          {
            Object[User, Emerald, Operator, "Test: operator 1"]
          }
        },
        Packet[Name]
      ],
      {
        { KeyValuePattern@{Name -> _String}, KeyValuePattern@{Name -> _String} },
        { KeyValuePattern@{Name -> _String} }
      }
    ],

    Test["Downloading with a Packet of fields, for a List[List[List[___]]] of objects, is undefined:",
      Download[
        {{{Object[User, Emerald, Developer, "Test: developer 1"]}}},
        Packet[Name]
      ],
      _Download
    ],

    (* lists of objects, lists of _Packet *)
    Example[{Additional, "Packet", "Downloading with a list of Packet of fields, for a list of lists of objects, works (depth: 2,2):"},
      Download[
        {
          {
            Object[User, Emerald, Developer, "Test: developer 1"],
            Object[User, Emerald, Developer, "Test: developer 2"]
          },
          {Object[User, Emerald, Operator, "Test: operator 1"]}
        },
        {Packet[Name], Packet[Status]}
      ],
      {
        {
          { KeyValuePattern@{Name -> _}, KeyValuePattern@{Status -> _} },
          { KeyValuePattern@{Name -> _}, KeyValuePattern@{Status -> _} }
        },
        {
          { KeyValuePattern@{Name -> _}, KeyValuePattern@{Status -> _} }
        }
      }
    ],

    Example[{Additional, "Packet", "Downloading a list of both fields and Packets of fields works:"},
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {LastName, Packet[Name, HireDate], Status}
      ],
      {_String, KeyValuePattern@{Name -> _String, HireDate -> _}, _}
    ],

    Test["Downloading a list of both Packets of fields and lists of fields is unsupported:",
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {LastName, Packet[Name, HireDate], {Status, MiddleName}}
      ],
      _Download
    ],

    Test["Downloading a list of both fields and lists of fields, is unsupported:",
      Download[
        Object[User, Emerald, Developer, "Test: developer 1"],
        {LastName, {Status, MiddleName}}
      ],
      _Download
    ],

    Test["Downloading empty lists from list of Nulls returns list of Nulls:",
      Download[{Null, Null, Null}, {{}, {}, {}}],
      {Null, Null, Null}
    ],

    Test["Downloading empty lists from list of Nulls and other values returns list of Nulls and empty lists:",
      Download[{Null, $PersonID, Null}, {{}, {}, {}}],
      {Null, {}, Null}
    ],

    Test["Download MapThread case handles Nulls with empty lists of fields:",
      Download[{{Null, $PersonID, Null}, {$PersonID}}, {{}, {}}],
      {{Null, {}, Null}, {{}}}
    ],

    Example[{Additional, "VariableUnit", "Quantities in VariableUnit fields will be downloaded in the original units (which were uploaded with):"},
      Download[{obj1, obj2, obj3}, VariableUnitData],
      {3 Gallon (* volume *), 2 Liter (* volume *), 7 Kilogram (* mass *)},
      Variables :> {obj1, obj2, obj3},
      SetUp :> (
        {obj1, obj2, obj3}=Upload[{
          <| Type -> Object[Example, Data], VariableUnitData -> 3 Gallon, DeveloperObject -> True |>,
          <| Type -> Object[Example, Data], VariableUnitData -> 2 Liter, DeveloperObject -> True |>,
          <| Type -> Object[Example, Data], VariableUnitData -> 7 Kilogram, DeveloperObject -> True |>
        }]
      )
    ],

    Example[{Additional, "VariableUnit", "Quantities in VariableUnit fields will be downloaded in the original units (from cache packets):"},
      Module[{p1,p2,p3,pkts,objs},
        {p1,p2,p3}=Upload[{<|Type -> Object[Example, Data]|>,<|Type -> Object[Example, Data]|>,<|Type -> Object[Example, Data]|>}];
        pkts={
          <|Object -> p1, VariableUnitData -> 3 Gallon, DeveloperObject -> True|>,
          <|Object -> p2, VariableUnitData -> 2 Liter, DeveloperObject -> True|>,
          <|Object -> p3, VariableUnitData -> 7 Kilogram, DeveloperObject -> True|>
        };
        objs={p1,p2,p3};
        Download[objs, VariableUnitData, Cache -> pkts]
      ],
      {3 Gallon, 2 Liter, 7 Kilogram}
    ],

    Test["Handle unicode characters in string fields:",
      With[{name="Unicode \[CapitalAHat]\[Micro]m"},
        Quiet[
          Upload[<|Type -> Object[Example, Data], Name -> name|>],
          {Upload::NonUniqueName}
        ];
        Download[Object[Example, Data, name], Name]
      ],
      "Unicode \[CapitalAHat]\[Micro]m"
    ],
    Example[{Options, Date, "Date Option allows the user to download an Object as it looked at a specific time. Note a single date can apply across a list of objects:"},
      Download[Object[Sample, "Download Test Sample With Time"], Date -> Now],
      PacketP[]
    ],
    Example[{Options, Date, "Whenever a Temporal Link is Downloaded, the Cache option is ignored and the values are downloaded directly from the Database:"},
      Module[{downloadTime, packet},
        downloadTime=Now - 1 Second;
        packet=Download[Object[Sample, "Download Test Sample With Time"], Date -> downloadTime];
        (* Make sure the packet has a DownloadDate, and give it a fake name *)
        packet=Append[packet, {DownloadDate -> downloadTime, Name -> "FakeName"}];
        (* First is a download with time so it uses the packet,the second is a temporal link, however date option takes precedence so it goes to the database with downloadTime *)
        Download[{Object[Sample, "Download Test Sample With Time"], Link[Object[Sample, "Download Test Sample With Time"], downloadTime]},
          Name, Cache -> {packet}, Date -> downloadTime]
      ],
      {"FakeName", "Download Test Sample With Time"}
    ],
    Example[{Options, Date, "A list of dates threads across a list of objects:"},
      Download[{Object[Sample, "Download Test Sample With Time"], Object[Sample, "Download Test Sample With Time"]}, Date -> {Now, Now}],
      {PacketP[], PacketP[]}
    ],
    Example[{Messages, "DateMismatch", "Fail if provided dates cannot thread with the provided objects:"},
      Download[Object[Sample, "Download Test Sample With Time"], Date -> {Now, Now}],
      $Failed,
      Messages :> {Message[Download::DateMismatch], Message[Flatten::normal]}
    ],

    (* The Date option allows the user to download the state of an object from during a specific time *)
    Test["Date option works when downloading a single object:",
      Module[{objs, t, oldPacket, newPacket},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        oldPacket=Download[Object[Sample, "Download Test Sample With Time"], Date -> t];
        newPacket=Download[Object[Sample, "Download Test Sample With Time"]];
        {Lookup[oldPacket, ShelfLife] == 1 Day, Lookup[newPacket, ShelfLife] == 2 Day}
      ],
      {True, True}
    ],
    Test["Date->Now grabs the most recent values:",
      Module[{objs, t, oldPacket, newPacket},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        newPacket=Download[{Object[Sample, "Download Test Sample With Time"],
          Object[Sample, "Download Test Sample With Time"]}, Date -> Now];

        {Lookup[newPacket[[1]], ShelfLife] == 2 Day, Lookup[newPacket[[2]], ShelfLife] == 2 Day}
      ],
      {True, True}
    ],
    Test["Single specified date applies across a list of objects:",
      Module[{objs, t, oldPackets, newPackets},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        oldPackets=Download[{objs[[1]], objs[[2]]}, Date -> t];
        newPackets=Download[{objs[[1]], objs[[2]]}];
        {
          Lookup[oldPackets[[1]], ShelfLife] == 1 Day,
          Lookup[oldPackets[[2]], ShelfLife] == 1 Day,
          Lookup[newPackets[[1]], ShelfLife] == 2 Day,
          Lookup[newPackets[[2]], ShelfLife] == 2 Day
        }
      ],
      {True, True, True, True}
    ],
    Test["List of dates applies across a list of objects:",
      Module[{objs, t, packets, now},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        now=DateObject[];
        packets=Download[{objs[[1]], objs[[2]]}, Date -> {t, now}];
        Lookup[#, ShelfLife] == 1 Day & /@ packets
      ],
      {True, False}
    ],
    Test["List of dates applies across a list of the same object:",
      Module[{objs, t, packets, now},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        now=DateObject[];
        packets=Download[{objs[[1]], objs[[1]]}, Date -> {t, now}];
        Lookup[#, ShelfLife] == 1 Day & /@ packets
      ],
      {True, False}
    ],
    (* Repeat the same tests but specify a field *)
    Test["Date option works when downloading a field from a single object:",
      Module[{objs, t, oldShelfLife, newShelfLife},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        oldShelfLife=Download[Object[Sample, "Download Test Sample With Time"], ShelfLife, Date -> t];
        newShelfLife=Download[Object[Sample, "Download Test Sample With Time"], ShelfLife];
        {oldShelfLife == 1 Day, newShelfLife == 2 Day}
      ],
      {True, True}
    ],
    Test["Single specified date applies across a list of objects when a field is specified:",
      Module[{objs, t, oldShelfLives, newShelfLives},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        oldShelfLives=Download[{objs[[1]], objs[[2]]}, ShelfLife, Date -> t];
        newShelfLives=Download[{objs[[1]], objs[[2]]}, ShelfLife];
        # == 1 Day & /@ Flatten[{oldShelfLives, newShelfLives}]
      ],
      {True, True, False, False}
    ],
    Test["List of dates applies across a list of objects when a field is specified:",
      Module[{objs, t, shelfLives, now},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        now=DateObject[];
        shelfLives=Download[{objs[[1]], objs[[2]]}, ShelfLife, Date -> {t, now}];
        # == 1 Day & /@ shelfLives
      ],
      {True, False}
    ],
    Test["List of dates applies across a list the same object when a field is specified:",
      Module[{objs, t, shelfLives, now},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        now=DateObject[];
        shelfLives=Download[{objs[[1]], objs[[1]]}, ShelfLife, Date -> {t, now}];
        # == 1 Day & /@ shelfLives
      ],
      {True, False}
    ],
    Test["The date option works with a single link:",
      Download[Link[Object[Protocol, HPLC, "id:3em6ZvLMmnAz"], "qdkmxzZZxamV"], Status,
        Date -> DateObject[{2020, 8, 18, 4, 47, 1.7767529487609863`}, "Instant", "Gregorian", -7.`]],
      InCart
    ],
    Test["List of dates applies across a list of links when a field is specified:",
      Module[{objs, t, shelfLives, now, links},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        links=Link /@ objs;
        now=DateObject[];
        shelfLives=Download[{links[[1]], links[[2]]}, ShelfLife, Date -> {t, now}];
        # == 1 Day & /@ shelfLives
      ],
      {True, False}
    ],
    Test["List of dates applies across a list of links:",
      Module[{objs, t, packets, now, links},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        links=Link /@ objs;
        now=DateObject[];
        packets=Download[{links[[1]], links[[2]]}, Date -> {t, now}];
        Lookup[#, ShelfLife] == 1 Day & /@ packets
      ],
      {True, False}
    ],
    Test["TemporalLinks download objects at the specified time:",
      Module[{objs, t, packets, tlinkold, tlinknew},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        tlinkold=Link[objs[[1]], timestampOfTimeObjChanges];
        tlinknew=Link[objs[[1]], Now];
        packets=Download[{tlinknew, tlinkold, objs[[1]], Link[objs[[1]]]}]; (* Two tlinks and a regular object, and a regular link*)
        Lookup[#, ShelfLife] == 1 Day & /@ packets
      ],
      {False, True, False, False}
    ],
    Test["TemporalLinks download fields at the specified time:",
      Module[{objs, t, shelfLives, tlinkold, tlinknew},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        tlinkold=Link[objs[[1]], timestampOfTimeObjChanges];
        tlinknew=Link[objs[[1]], Now];
        shelfLives=Download[{tlinknew, tlinkold, objs[[1]], Link[objs[[1]]]}, ShelfLife]; (* Two tlinks and a regular object, and a regular link*)
        # == 1 Day & /@ shelfLives
      ],
      {False, True, False, False}
    ],
    Test["Date option overrides a temporal link:",
      Module[{objs, t, shelfLives, tlinkold, packet, field},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        tlinkold=Link[objs[[1]], timestampOfTimeObjChanges];
        packet=Download[tlinkold, Date -> DateObject[]];
        field=Download[tlinkold, ShelfLife, Date -> DateObject[]];
        {Lookup[packet, ShelfLife] == 1 Day, field == 1 Day}
      ],
      {False, False}
    ],
    Test["Date option in a list overrides temporal link:",
      Module[{objs, t, tlinkold, packets, fields},
        {objs, t}={timeObjs, timestampOfTimeObjChanges};
        tlinkold=Link[objs[[1]], timestampOfTimeObjChanges];
        packets=Download[{tlinkold, tlinkold}, Date -> {None, Now}];
        fields=Download[{tlinkold, tlinkold}, ShelfLife, Date -> {None, Now}];
        {Lookup[#, ShelfLife] == 1 Day & /@ packets, # == 1 Day & /@ fields}
      ],
      {{True, False}, {True, False}}
    ],
    Test["Download Through Links works when a Date is specified:",
      Quiet[Download[Object[Notebook, Script, "id:L8kPEjnEKep4"], CurrentProtocols[Status], Date -> DateObject[{2020, 8, 18, 4, 47, 1.7767529487609863`},
        "Instant", "Gregorian", -7.`]],Download::SomeMetaDataUnavailable],
      {InCart, InCart, InCart}
    ],
    Example[{Options, IgnoreTime, "Download with Date option and with IgnoreTime option specified:"},
      {Download[analysis, StringData, Date -> time1, IgnoreTime -> False],
        Download[analysis, StringData, Date -> time1, IgnoreTime -> True]},
      {"1", "2"},
      Variables :> {analysis, time1},
      SetUp :> (
        analysis=
            Upload[<|Type -> Object[Example, Analysis], StringData -> "1"|>];
        Pause[1];
        time1=Now;
        Upload[<|Object -> analysis, StringData -> "2"|>];
      )
    ],
    Example[{Options, IgnoreTime, "Download with Date option and with IgnoreTime option specified:"},
      {Download[analysis, StringData, Date -> time1, IgnoreTime -> False],
        Download[analysis, StringData, Date -> time1, IgnoreTime -> True]},
      {"1", "2"},
      Variables :> {analysis, time1},
      SetUp :> (
        analysis=
            Upload[<|Type -> Object[Example, Analysis], StringData -> "1"|>];
        Pause[1];
        time1=Now;
        Upload[<|Object -> analysis, StringData -> "2"|>];
      )
    ],
    Test["Download through Links works when a Temporal Link is provided:",
      Quiet[Download[Link[Object[Notebook, Script, "id:L8kPEjnEKep4"], DateObject[{2020, 8, 18, 4, 47, 1.7767529487609863`}, "Instant",
        "Gregorian", -7.`]] , CurrentProtocols[Status]],Download::SomeMetaDataUnavailable],
      {InCart, InCart, InCart}
    ],
    Test["Download temporal link with IgnoreTime specified:",
      Module[{analysis,time1},
        analysis= Upload[<|Type -> Object[Example, Analysis], StringData -> "1"|>];
        Pause[2];
        time1=Now;
        Upload[<|Object -> analysis, StringData -> "2"|>];
        {Download[Link[analysis, time1], StringData, IgnoreTime -> False], Download[Link[analysis, time1], StringData, IgnoreTime -> True]}
      ],
      {"1", "2"}
    ],
    Test["Download via one way temporal link exercising cache with IgnoreTime specified:",
      {Download[data2, OneWayLinkTemporal[StringData], IgnoreTime -> False],
        Download[data2, OneWayLinkTemporal[StringData], IgnoreTime -> True],
        Download[data2, OneWayLinkTemporal[StringData]],
        Download[data2, OneWayLinkTemporal[StringData], IgnoreTime -> True]},
      {"2", "10", "2", "10"},
      Variables :> {analysis2, time2, data2},
      SetUp :> (
        analysis2=
            Upload[<|Type -> Object[Example, Analysis], StringData -> "2"|>];
        Pause[1];
        time2=Now;
        data2=Upload[<|Type -> Object[Example, Data], Number -> 5,
          OneWayLink -> Link[analysis2],
          OneWayLinkTemporal -> Link[analysis2, time2]|>];
        Pause[1];
        Upload[<|Object -> analysis2, StringData -> "10"|>];
      )
    ],
    Test["Temporal Packets dont match on non-temporal downloads:",
      With[{
        packet=<|Name -> "Made up name on Download Test Sample With Time",
          Object -> Object[Sample, "id:7X104vneXJ09"], ID -> "id:7X104vneXJ09",
          Type -> Object[Sample],
          DownloadDate -> DateObject["Sep 2 2020"]|>
      },
        Download[{Object[Sample, "id:7X104vneXJ09"], Object[Sample, "id:7X104vneXJ09"]}, Name, Cache -> {packet}, Date -> {Now, Now - 1Second}]],
      {"Download Test Sample With Time", "Download Test Sample With Time"}
    ],
    Test["Links are preserved when downloading from a packet:",
      Module[
        {packet1, packet2},
        packet1=Download[<|Object -> Model[Maintenance, RefillReservoir, NMR, "id:rea9jlRz4w8p"], FillLiquidModel -> Link[Model[Sample, "Milli-Q water"]]|>];
        packet2=Download[<|Object -> Model[Maintenance, RefillReservoir, NMR, "id:rea9jlRz4w8p"], FillLiquidModel -> Link[Model[Sample, "Milli-Q water"]]|>, All];
        {
          Lookup[packet1, FillLiquidModel],
          Lookup[packet2, FillLiquidModel]
        }
      ],
      {LinkP[], LinkP[]}
    ],
    Test["Lookup Repeated works with Temporal Objects:",
      Download[
        {Object[Container, Vessel, "id:dORYzZJWk1kb"], Object[Container, Vessel, "id:AEqRl9KAXEmw"]},
        Container..,
        Date -> DateObject[{2020, 8, 31, 15, 26, 54}, "Instant", "Gregorian", "GMT-5"]
      ],

      {{TemporalLinkP[Object[Container, OperatorCart, "id:6V0npvK6GGp8"]], TemporalLinkP[Object[Container, Room, "id:pZx9jonGkPKj"]]},
        {TemporalLinkP[Object[Container, OperatorCart, "id:6V0npvK6GGp8"]], TemporalLinkP[Object[Container, Room, "id:pZx9jonGkPKj"]]}}
    ],
    Example[{Additional, "Download with Time respects Timeless Objects. (Historical value was 1 degree):"},
      Download[timelessObj, Temperature, Date -> historicalTime],
      Quantity[10000.`, "DegreesCelsius"]
    ],
    Example[{Additional, "Download with Time respects Timeless Object through a Link. (Historical value was 1 degree):"},
      Download[temporalObjThatHasLinkToTimelessObj, DataAnalysisTimeless[Temperature], Date -> historicalTime],
      Quantity[10000.`, "DegreesCelsius"]
    ],
    Test["DebugTime can be used to access the historical value of a timeless object:",
      {Download[timelessObj, Temperature], Download[temporalObjThatHasLinkToTimelessObj, DataAnalysisTimeless[Temperature]]},
      {Quantity[1.`, "DegreesCelsius"], Quantity[1.`, "DegreesCelsius"]},
      SetUp :> setDebugTime[historicalTime],
      TearDown :> clearDebugTime[]
    ],
    Test["Nulls within a cacheball are inconsequential when Downloading Through Links:",
      MatchQ[
        First@Download[Object[Sample, "id:AEqRl9KDwPPl"], Packet[Composition[[All, 2]][MolecularWeight]], Cache -> {<|Object -> Object[Sample, "id:AEqRl9KDwPPl"],
          Composition -> {{Quantity[136.086`, ("Grams") / ("Moles")], Link[Model[Molecule, "id:vXl9j57PmP5D"], "XnlV5jjKDmMM"]}, {Null, Null}}|>}],
        First@Download[Object[Sample, "id:AEqRl9KDwPPl"], Packet[Composition[[All, 2]][MolecularWeight]], Cache -> {<|Object -> Object[Sample, "id:AEqRl9KDwPPl"],
          Composition -> {{Quantity[136.086`, ("Grams") / ("Moles")], Link[Model[Molecule, "id:vXl9j57PmP5D"], "XnlV5jjKDmMM"]}}|>}]
      ],
      True
    ],
    Test["Object pagination works with Download[{obj,...}] case:",
      Module[
        {controlResult, paginatedResult, originalPageSize},
        controlResult=Download[{$PersonID,$PersonID,$PersonID}];
        paginatedResult=Block[{GoLink`Private`$pageLength=2},Download[{$PersonID,$PersonID,$PersonID}]];
        MatchQ[controlResult,paginatedResult]
      ],
      True
    ],
    Test["Object pagination works with Download[{obj,...},fields] case",
      Module[
        {controlResult, paginatedResult, originalPageSize},
        controlResult=Download[{$PersonID,$PersonID,$PersonID},DateCreated];
        paginatedResult=Block[{GoLink`Private`$pageLength=2},Download[{$PersonID,$PersonID,$PersonID},DateCreated]];
        MatchQ[controlResult,paginatedResult]
      ],
      True
    ],
    Test["Object pagination works with Download[{{obj,...},{obj,...},...},fields] case",
      Module[
        {controlResult, paginatedResult, originalPageSize},
        controlResult=Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},DateCreated];
        paginatedResult=Block[{GoLink`Private`$pageLength=2},Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},DateCreated]];
        MatchQ[controlResult,paginatedResult]
      ],
      True
    ],
    Test["Object pagination works with Download[{{obj,...},{obj,...},...},{{field1},{field2}}] case where the objects and fields are index matched",
      Module[
        {controlResult, paginatedResult, originalPageSize},
        controlResult=Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},{{DateCreated},{Object}}];
        paginatedResult=Block[{GoLink`Private`$pageLength=2},Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},{{DateCreated},{Object}}]];
        MatchQ[controlResult,paginatedResult]
      ],
      True
    ],
    Test["Object pagination works with Download[{{obj,...},{obj,...},...},{{field1},{field2}}] case where the objects and fields are NOT index matched",
      Module[
        {controlResult, paginatedResult, originalPageSize},
        controlResult=Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},{{DateCreated}}];
        paginatedResult=Block[{GoLink`Private`$pageLength=2},Download[{{$PersonID,$PersonID,$PersonID},{$PersonID}},{{DateCreated}}]];
        MatchQ[controlResult,paginatedResult]
      ],
      True
    ],
    Test["Downloading from empty lists does not hit NativeDownload:",
      Block[{GoLink`Private`NativeDownload},
        GoLink`Private`NativeDownload[___] := Throw[$Failed, "NativeDownload"];
        {
          Catch[Download[{{}, {}}], "NativeDownload"], (* returns input immediately *)
          Catch[Download[Object[Data,"id:123"]], "NativeDownload"] (* hits NativeDownload, returns $Failed *)
        }
      ],
      {
        {{},{}},
        $Failed
      }
    ]
  },
  Stubs :> {
    $DisableVerbosePrinting=True
  },
  SymbolSetUp :> {
    {timeObjs, timestampOfTimeObjChanges}=setupDownloadWithTimeExampleObjects[];
    {timelessObj, temporalObjThatHasLinkToTimelessObj, historicalTime}=setupTimelessObject[];
    setupRepeatedObjects[];
    setupRecursiveCycle[];
    setupNamedFields[];
    setupWeirdNames[];
    setupLinkedList[];
    setupTree[];
    setupMultipleRecursive[];
    setupDownloadExampleObjects[];
    setupDownloadWithTimeExampleObjects[];
    setupExamplePeople[];
    setupIndexedMultipleErase[];
    setupNamedMultipleErase[];
  }
]; (* end of DefineTests[Download] *)

setupRepeatedObjects[]:=Module[
  {objects, links},

  objects=CreateID[Table[Object[Example, Data], {4}]];

  Upload[{
    <|
      Object -> objects[[1]],
      SingleRelation -> Link[objects[[2]], SingleRelationAmbiguous],
      TestName -> Link[objects[[4]], ReplaceRepeated]
    |>,
    <|
      Object -> objects[[2]],
      SingleRelation -> Link[objects[[3]], SingleRelationAmbiguous],
      TestName -> Link[objects[[4]], ReplaceRepeated]
    |>,
    <|
      Object -> objects[[3]],
      SingleRelation -> Link[objects[[4]], SingleRelationAmbiguous],
      TestName -> Link[objects[[4]], ReplaceRepeated]
    |>
  }];

  links={
    LinkP[objects[[2]], SingleRelationAmbiguous],
    LinkP[objects[[3]], SingleRelationAmbiguous],
    LinkP[objects[[4]], SingleRelationAmbiguous]
  };

  ClearDownload[];
  {Sequence @@ objects, links, Take[links, 2;;-1], Take[links, 3;;-1]}
];

idempotentUpload[type:typeP, name:_String, fields:_Association:<||>]:=With[
  {namedObject=Append[type, name]},

  If[DatabaseMemberQ[namedObject],
    namedObject,
    Upload[Join[
      <|Type -> type, Name -> name, DeveloperObject -> True|>,
      fields
    ]]
  ]
];


setupRecursiveCycle[]:=With[{
  cycle1=idempotentUpload[Object[Container, Rack], "Download Test: cycle 1"],
  cycle2=idempotentUpload[Object[Container, Rack], "Download Test: cycle 2"],
  cycle3=idempotentUpload[Object[Container, Rack], "Download Test: cycle 3"]
},

  Upload[{
    <|Object -> cycle1, Container -> Link[cycle2, Contents, 2]|>,
    <|Object -> cycle2, Container -> Link[cycle3, Contents, 2]|>,
    <|Object -> cycle3, Container -> Link[cycle1, Contents, 2]|>
  }];

  ClearDownload[];
  cycle1
];

setupNamedFields[]:=With[
  {
    linkId=CreateLinkID[3],
    obj1=idempotentUpload[Object[Example, Data], "Download Test: named fields 1", <||>],
    obj2=idempotentUpload[Object[Example, Data], "Download Test: named fields 2", <||>],
    obj3=idempotentUpload[Object[Example, Data], "Download Test: named fields 3", <||>],
    obj4=idempotentUpload[Object[Example, Data], "Download Test: named fields 4", <||>]
  },

  Upload[{
    <|
      Object -> obj1,
      NamedSingle -> <|
        UnitColumn -> 11 Nanometer,
        MultipleLink -> Link[obj2, NamedMultiple, SingleLink, linkId[[1]]]
      |>,
      Replace[NamedMultiple] -> {
        <|UnitColumn -> 11 Nanometer, SingleLink -> Null|>,
        <|UnitColumn -> 12 Nanometer, SingleLink -> Null|>
      }
    |>,
    <|
      Object -> obj2,
      NamedSingle -> <|UnitColumn -> 21 Nanometer, MultipleLink -> Null|>,
      Replace[NamedMultiple] -> {
        <|
          UnitColumn -> 21 Nanometer,
          SingleLink -> Link[obj1, NamedSingle, MultipleLink, linkId[[1]]]
        |>,
        <|
          UnitColumn -> 22 Nanometer,
          SingleLink -> Link[obj3, NamedSingle, MultipleLink, linkId[[2]]]
        |>
      }
    |>,
    <|
      Object -> obj3,
      NamedSingle -> <|
        UnitColumn -> 31 Nanometer,
        MultipleLink -> Link[obj2, NamedMultiple, SingleLink, linkId[[2]]]
      |>,
      Replace[NamedMultiple] -> {
        <|UnitColumn -> 31 Nanometer, SingleLink -> Null|>,
        <|
          UnitColumn -> 32 Nanometer,
          SingleLink -> Link[obj4, NamedSingle, MultipleLink, linkId[[3]]]
        |>
      }
    |>,
    <|
      Object -> obj4,
      NamedSingle -> <|
        UnitColumn -> 41 Nanometer,
        MultipleLink -> Link[obj3, NamedMultiple, SingleLink, linkId[[3]]]
      |>,
      Replace[NamedMultiple] -> {
        <|UnitColumn -> 41 Nanometer, SingleLink -> Null|>,
        <|UnitColumn -> 42 Nanometer, SingleLink -> Null|>
      }
    |>
  }]
];

setupWeirdNames[]:=With[
  {weirdNames=Map[
    idempotentUpload[Object[Example, Data], #] &, {
      "with a /",
      "with a %",
      "with a (",
      "with a )",
      "with a >",
      "with a <",
      "with a ?",
      "with a &"
    }]},

  ClearDownload[];

  weirdNames
];

setupLinkedList[]:=Module[
  {node5, node4, node3, node2, node1},
  node5=idempotentUpload[
    Object[Example, Data], "linked list 5",
    <|Number -> 5|>
  ];

  node4=idempotentUpload[
    Object[Example, Data], "linked list 4",
    <|SingleRelation -> Link[node5, SingleRelationAmbiguous], Number -> 4|>
  ];

  node3=idempotentUpload[
    Object[Example, Data], "linked list 3",
    <|SingleRelation -> Link[node4, SingleRelationAmbiguous], Number -> 3|>
  ];

  node2=idempotentUpload[
    Object[Example, Data], "linked list 2",
    <|SingleRelation -> Link[node3, SingleRelationAmbiguous], Number -> 2|>
  ];

  node1=idempotentUpload[
    Object[Example, Data], "linked list 1",
    <|SingleRelation -> Link[node2, SingleRelationAmbiguous], Number -> 1|>
  ];

  ClearDownload[];

  node1
];

setupTree[]:=Module[{
  tree1,
  tree11, tree12,
  tree111, tree121,
  tree1111, tree1112, tree1211, tree1212,
  tree11111, tree11121, tree12111, tree12121
},
  tree11111=idempotentUpload[Object[Example, Data], "tree: 11111", <|Number -> 11111|>];
  tree12111=idempotentUpload[Object[Example, Data], "tree: 12111", <|Number -> 12111|>];
  tree11121=idempotentUpload[Object[Example, Data], "tree: 11121", <|Number -> 11121|>];
  tree12121=idempotentUpload[Object[Example, Data], "tree: 12121", <|Number -> 12121|>];

  tree1111=idempotentUpload[Object[Example, Data], "tree: 1111",
    <|Number -> 1111, SingleRelation -> Link[tree11111, SingleRelationAmbiguous]|>];

  tree1211=idempotentUpload[Object[Example, Data], "tree: 1211",
    <|Number -> 1211, SingleRelation -> Link[tree12111, SingleRelationAmbiguous]|>];

  tree1112=idempotentUpload[Object[Example, Data], "tree: 1112",
    <|Number -> 1112, SingleRelation -> Link[tree11121, SingleRelationAmbiguous]|>];

  tree1212=idempotentUpload[Object[Example, Data], "tree: 1212",
    <|Number -> 1212, SingleRelation -> Link[tree12121, SingleRelationAmbiguous]|>];

  tree111=idempotentUpload[Object[Example, Data], "tree: 111",
    <|
      Number -> 111,
      Replace[MultipleAppendRelation] -> {
        Link[tree1111, MultipleAppendRelationAmbiguous],
        Link[tree1112, MultipleAppendRelationAmbiguous]
      }
    |>];

  tree121=idempotentUpload[Object[Example, Data], "tree: 121",
    <|
      Number -> 121,
      Replace[MultipleAppendRelation] -> {
        Link[tree1211, MultipleAppendRelationAmbiguous],
        Link[tree1212, MultipleAppendRelationAmbiguous]
      }
    |>];

  tree11=idempotentUpload[Object[Example, Data], "tree: 11",
    <|Number -> 11, SingleRelation -> Link[tree111, SingleRelationAmbiguous]|>];

  tree12=idempotentUpload[Object[Example, Data], "tree: 12",
    <|Number -> 12, SingleRelation -> Link[tree121, SingleRelationAmbiguous]|>];

  tree1=idempotentUpload[Object[Example, Data], "tree: 1",
    <|Number -> 1, Replace[MultipleAppendRelation] -> {
      Link[tree11, MultipleAppendRelationAmbiguous],
      Link[tree12, MultipleAppendRelationAmbiguous]
    }
    |>];

  ClearDownload[];

  tree1
];

setupMultipleRecursive[]:=Module[
  {oligomer1, oligomer2, oligomer3, oligomer4, oligomer5, oligomer6,
    plate1, plate2, plate3, rack},

  oligomer1=idempotentUpload[Object[Sample], "oligomer1"];
  oligomer2=idempotentUpload[Object[Sample], "oligomer2"];
  oligomer3=idempotentUpload[Object[Sample], "oligomer3"];
  oligomer4=idempotentUpload[Object[Sample], "oligomer4"];
  oligomer5=idempotentUpload[Object[Sample], "oligomer5"];
  oligomer6=idempotentUpload[Object[Sample], "oligomer6"];

  plate1=idempotentUpload[Object[Container, Plate], "plate1",
    <|Replace[Contents] -> {
      {"A1", Link[oligomer1, Container]},
      {"A2", Link[oligomer2, Container]},
      {"A3", Link[oligomer3, Container]}}|>];

  plate2=idempotentUpload[Object[Container, Plate], "plate2",
    <|Replace[Contents] -> {
      {"A1", Link[oligomer4, Container]},
      {"A2", Link[oligomer5, Container]},
      {"A3", Link[oligomer6, Container]}
    }|>];

  plate3=idempotentUpload[Object[Container, Plate], "plate3"];

  rack=idempotentUpload[Object[Container, Rack], "rack",
    <|Replace[Contents] -> {
      {"A1", Link[plate1, Container]},
      {"A2", Link[plate2, Container]},
      {"A3", Link[plate3, Container]}
    }|>];

  ClearDownload[];

  rack
];

setupDownloadExampleObjects[]:=Module[
  {oligomer, containerPlate, rack, objs, model},

  oligomer=If[DatabaseMemberQ[Object[Sample, "Download Test Oligomer"]],
    Object[Sample, "Download Test Oligomer"],
    Upload[<|Type -> Object[Sample], Name -> "Download Test Oligomer", DeveloperObject -> True|>]
  ];

  containerPlate=If[DatabaseMemberQ[Object[Container, Plate, "Download Test Plate"]],
    Object[Container, Plate, "Download Test Plate"],
    Upload[<|Type -> Object[Container, Plate], Name -> "Download Test Plate", DeveloperObject -> True|>]
  ];

  rack=If[DatabaseMemberQ[Object[Container, Rack, "Download Test Rack"]],
    Object[Container, Rack, "Download Test Rack"],
    Upload[<|Type -> Object[Container, Rack], Name -> "Download Test Rack", DeveloperObject -> True|>]
  ];

  model=If[DatabaseMemberQ[Model[Sample, "Download Test Model"]],
    Model[Sample, "Download Test Model"],
    Upload[<|Type -> Model[Sample], Name -> "Download Test Model", DeveloperObject -> True|>]
  ];

  objs=Upload[{
    <|Object -> containerPlate, Status -> Available, Replace[Contents] -> {{"A1", Link[oligomer, Container]}}|>,
    <|Object -> oligomer, Status -> Available, Model -> Link[model, Objects]|>,
    <|Object -> rack, Replace[Contents] -> {{"A1", Link[containerPlate, Container]}}, Status -> InUse|>
  }];

  ClearDownload[];

  objs
];

setupDownloadWithTimeExampleObjects[]:=Module[
  {objs, initialUploadAssociations, toCreateList, timestampBeforeChanges, initialShelfLife, newShelfLife},

  objs={
    Object[Sample, "Download Test Sample With Time"],
    Object[Container, Plate, "Download Test Plate With Time"],
    Object[Container, Rack, "Download Test Rack With Time"],
    Model[Sample, "Download Test Model With Time"]
  };

  initialUploadAssociations={
    <|Type -> Object[Sample], Name -> "Download Test Sample With Time", DeveloperObject -> True|>,
    <|Type -> Object[Container, Plate], Name -> "Download Test Plate With Time", DeveloperObject -> True|>,
    <|Type -> Object[Container, Rack], Name -> "Download Test Rack With Time", DeveloperObject -> True|>,
    <|Type -> Model[Sample], Name -> "Download Test Model With Time", DeveloperObject -> True|>

  };

  (* We only want to pick the objects that are false*)
  toCreateList=!# & /@ DatabaseMemberQ[objs];
  Upload[PickList[initialUploadAssociations, toCreateList]];


  initialShelfLife=1 Day;
  newShelfLife=2 Day;

  (* Initialize them with the verbose->False *)
  Upload[Association[Object -> #, ShelfLife -> initialShelfLife]& /@ objs];

  (* Grab the timestamp of the initial state *)
  (* Add a 1 second buffer around the timestamps to avoid weird timing conflicts with the stamp *)
  Pause[1];
  timestampBeforeChanges=DateObject[];
  Pause[1];

  (* Now add "predictable" changes to these objects *)
  Upload[Association[Object -> #, ShelfLife -> newShelfLife]& /@ objs];

  (* Just use DateObject[] to get a most recent timestamp, or don't specify a date at all! *)
  (* Just wait one more second to ensure *)
  Pause[1];
  {objs, timestampBeforeChanges}
];

setupExamplePeople[]:=Module[
  {developer1, developer2, operator1, operator2},

  developer1=idempotentUpload[
    Object[User, Emerald, Developer],
    "Test: developer 1",
    <|
      MiddleName -> "middle name 1",
      LastName -> "last name 1",
      HireDate -> DateObject[List[2017, 11, 10], "Day", "Gregorian", -8.`],
      Status -> Historical,
      DeveloperObject -> True
    |>
  ];

  developer2=idempotentUpload[
    Object[User, Emerald, Developer],
    "Test: developer 2",
    <|
      MiddleName -> "middle name 2",
      LastName -> "last name 2",
      HireDate -> DateObject[List[2017, 11, 10], "Day", "Gregorian", -8.`],
      Status -> Historical,
      DeveloperObject -> True
    |>
  ];

  operator1=idempotentUpload[
    Object[User, Emerald, Operator],
    "Test: operator 1",
    <|
      MiddleName -> "middle name 1",
      LastName -> "last name 1",
      HireDate -> DateObject[List[2017, 11, 10], "Day", "Gregorian", -8.`],
      Status -> Historical,
      DeveloperObject -> True
    |>
  ];

  operator2=idempotentUpload[
    Object[User, Emerald, Operator],
    "Test: operator 2",
    <|
      MiddleName -> "middle name 2",
      LastName -> "last name 2",
      HireDate -> DateObject[List[2017, 11, 10], "Day", "Gregorian", -8.`],
      Status -> Historical,
      DeveloperObject -> True
    |>
  ];

  ClearDownload[];

  {developer1, developer2, operator1, operator2}
];

setupIndexedMultipleErase[]:=(
  idempotentUpload[
    Object[Container, Rack],
    "Test Erase IndexedMultiple",
    <|Replace[Contents] -> {{"A1", Null}, {"A2", Null}, {"A3", Null}}|>
  ];
  Upload[<|
    Object -> Object[Container, Rack, "Test Erase IndexedMultiple"],
    Replace[Contents] -> {{"A1", Null}, {"A2", Null}, {"A3", Null}}
  |>]
);

setupTimelessObject[]:=Module[{timelessObj, temporalObjThatHasLinkToTimelessObj, historicalTime},
  timelessObj=Upload[<|Object -> CreateID[Object[Example, TimelessData]], Temperature -> 1 Celsius|>];
  temporalObjThatHasLinkToTimelessObj=Upload[<|Object -> CreateID[Object[Example, Analysis]], DataAnalysisTimeless -> Link[timelessObj, DataAnalysis]|>];
  (* To account for any differences between the local time and the Database *)
  Pause[1 Second];
  historicalTime=DateObject[];
  Upload[<|Object -> timelessObj, Temperature -> 10000 Celsius|>];
  {timelessObj, temporalObjThatHasLinkToTimelessObj, historicalTime}
];

setupNamedMultipleErase[]:=With[{linkId=CreateLinkID[3]},
  idempotentUpload[Object[Example, Data], "Test Erase NamedMultiple"];
  idempotentUpload[Object[Example, Data], "Test Erase NamedSingle 1"];
  idempotentUpload[Object[Example, Data], "Test Erase NamedSingle 2"];
  idempotentUpload[Object[Example, Data], "Test Erase NamedSingle 3"];
  Upload[{
    <|
      Object -> Object[Example, Data, "Test Erase NamedMultiple"],
      Replace[NamedMultiple] -> {
        <|
          UnitColumn -> 1 Nanometer,
          SingleLink -> Link[
            Object[Example, Data, "Test Erase NamedSingle 1"],
            NamedSingle,
            MultipleLink,
            linkId[[1]]
          ]
        |>,
        <|
          UnitColumn -> 2 Nanometer,
          SingleLink -> Link[
            Object[Example, Data, "Test Erase NamedSingle 2"],
            NamedSingle,
            MultipleLink,
            linkId[[2]]
          ]
        |>,
        <|
          UnitColumn -> 3 Nanometer,
          SingleLink -> Link[
            Object[Example, Data, "Test Erase NamedSingle 3"],
            NamedSingle,
            MultipleLink,
            linkId[[3]]
          ]
        |>
      }
    |>,
    <|
      Object -> Object[Example, Data, "Test Erase NamedSingle 1"],
      NamedSingle -> <|
        UnitColumn -> 1 Nanometer,
        MultipleLink -> Link[
          Object[Example, Data, "Test Erase NamedMultiple"],
          NamedMultiple,
          SingleLink,
          linkId[[1]]
        ]
      |>
    |>,
    <|
      Object -> Object[Example, Data, "Test Erase NamedSingle 2"],
      NamedSingle -> <|
        UnitColumn -> 2 Nanometer,
        MultipleLink -> Link[
          Object[Example, Data, "Test Erase NamedMultiple"],
          NamedMultiple,
          SingleLink,
          linkId[[2]]
        ]
      |>
    |>,
    <|
      Object -> Object[Example, Data, "Test Erase NamedSingle 3"],
      NamedSingle -> <|
        UnitColumn -> 3 Nanometer,
        MultipleLink -> Link[
          Object[Example, Data, "Test Erase NamedMultiple"],
          NamedMultiple,
          SingleLink,
          linkId[[3]]
        ]
      |>
    |>
  }]
];