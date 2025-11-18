(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(* ObjectToFilePath *)


DefineTests[ObjectToFilePath,
	{
		Example[{Basic,"Convert an object to a lowercase string:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]],
			"01_g6nvk_kr3o7"
		],
		Example[{Basic,"Use ObjectToFilePath to construct a file path:"},
			FileNameJoin[{$PublicPath,"Data","PlateReader",ObjectToFilePath[Object[Protocol, FluorescenceKinetics, "id:zGj91aR3re6x"]]}],
			FileNameJoin[{$PublicPath,"Data","PlateReader","z_gj91a_r3re6x"}]
		],
		Example[{Basic,"Convert objects in any form to a list of strings:"},
			ObjectToFilePath[{Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Model[Sample, "Milli-Q water"],Download[Model[Container, Plate, "id:L8kPEjkmLbvW"]],Link[Model[Container, Vessel, "id:xRO9n3vk11pw"]],Link[Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"]]}],
			{"01_g6nvk_kr3o7", "8q_z1_v_w_nmd_l_b_d", "_l8k_p_ejkm_lbv_w","x_r_o9n3vk11pw", "mnk9j_o3q_dzp_y"}
		],
		Example[{Basic,"Convert an object to a string and back:"},
			Object["id:"<>ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Lowercase->False]],
			Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]
		],
		Example[{Options,OutputFormat,"Indicate that the object string should include the type:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],OutputFormat->Object],
			"Model_Instrument_PlateReader_id_01_g6nvk_kr3o7"
		],
		Example[{Options,OutputFormat,"Indicate that the object string should include the id prefix:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],OutputFormat->ID],
			"id_01_g6nvk_kr3o7"
		],
		Example[{Options,Lowercase,"Indicate that the id should be left in its original mixed-case state:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"], Lowercase->False],
			"01G6nvkKr3o7"
		],
		Example[{Options,SpecialCharacter,"Indicate that $ should be used to distinguish special characters:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"], SpecialCharacter->"$"],
			"01$g6nvk$kr3o7"
		],
		Example[{Options,SpecialCharacter,"Indicate that ( should be used to distinguish special characters:"},
			ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"], SpecialCharacter->"("],
			"01(g6nvk(kr3o7"
		],
		Example[{Messages,"MissingObjects","Print a message and return $Failed if any of the objects provided are not in the database:"},
			ObjectToFilePath[{Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Model[Instrument, PlateReader, "id:123"]}],
			$Failed,
			Messages:>{ObjectToFilePath::MissingObjects}
		],
		Example[{Issues,"An object string can only be converted back to an object without performing string replacements when Lowercase->False and OutputFormat -> String:"},
			{
				Object["id:"<>ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Lowercase->False,OutputFormat -> String]],
				Object["id:"<>ObjectToFilePath[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Lowercase->True,OutputFormat -> String]]
			},
			{ObjectP[],$Failed}
		],
		Test["Accepts a list of objects:",
			ObjectToFilePath[{Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Object[Protocol, FluorescenceKinetics, "id:zGj91aR3re6x"]}],
			{"01_g6nvk_kr3o7","z_gj91a_r3re6x"}
		],
		Test["Handles a mixed list:",
			ObjectToFilePath[{Download[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]],Link[Object[Protocol, FluorescenceKinetics, "id:zGj91aR3re6x"]]}],
			{"01_g6nvk_kr3o7","z_gj91a_r3re6x"}
		],
		Test["Handles objects with different levels of subtyping:",
			ObjectToFilePath[{Object[Sample, "id:vXl9j5qkOV3Z"],Model[ReactionMechanism, "id:XnlV5jmaOaVB"]},OutputFormat->Object,Lowercase->False],
			{"Object_Sample_id_vXl9j5qkOV3Z","Model_ReactionMechanism_id_XnlV5jmaOaVB"}
		]
	}
];


(* ::Subsection:: *)
(*Patterns and Conversions*)


(* ::Subsubsection::Closed:: *)
(*typeUnits*)


DefineTests[
	typeUnits,
	{
			Example[{Basic,"Units of a Type:"},
				typeUnits[Object[Data,AbsorbanceSpectroscopy]],
				{Rule[_Symbol,None|UnitsP[]|{(None|UnitsP[])...}|{Rule[_,(None|UnitsP[])|{(None|UnitsP[])...}]...}]...}
			],
			
			Example[{Basic,"Units of all data types:"},
				typeUnits/@Types[Object[Data]],
				Table[{Rule[_Symbol,
					UnitsP[] | {(UnitsP[] | None |
							Null | {(UnitsP[] | None | Null) ...}) ...} | {Rule[_,
						UnitsP[] | None | Null | {UnitsP[] ...}] ...}] ...}, {Length[
					Types[Object[Data]]]}]
			],
			
			Example[{Basic,"Does not evaluate on non-types:"},
				typeUnits[Pony],
				typeUnits[Pony]
			]
	}
];


(* ::Subsubsection::Closed:: *)
(*NamedObject*)


DefineTests[
	NamedObject,
	{
		Example[{Basic,"Convert an ObjectReference to show the Object's Name instead of an ID:"},
			NamedObject[Object[Company, Supplier, "id:eGakld01qrkB"]],
			Object[Company, Supplier, "Emerald Cloud Lab"]
		],
		Example[{Basic,"Convert multiple ObjectReferences to show the Object's Name instead of an ID:"},
			NamedObject[{Object[Company, Supplier, "id:eGakld01qrkB"], Model[Sample,"id:8qZ1VWNmdLBD"]}],
			{Object[Company, Supplier, "Emerald Cloud Lab"], Model[Sample,"Milli-Q water"]}
		],
		Example[{Basic,"Convert a Link to show the Object's Name instead of an ID:"},
			NamedObject[Link[Object[Company, Supplier, "id:eGakld01qrkB"]]],
			Object[Company, Supplier, "Emerald Cloud Lab"]
		],
		Example[{Basic,"Convert a packet to the named version of the object:"},
			NamedObject[<|Name->"Milli-Q water",Object->Model[Sample,"id:8qZ1VWNmdLBD"],ID->"id:8qZ1VWNmdLBD",Type->Model[Sample]|>],
			Model[Sample,"Milli-Q water"]
		],
		Example[{Additional,"Convert a shorthand Object reference:"},
			NamedObject[Object["id:L8kPEjkmLbvW"]],
			Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		],
		Example[{Additional, "If a Null or $Failed is in the input list, just return Null or $Failed:"},
			NamedObject[{Object[Company, Supplier, "id:eGakld01qrkB"], $Failed, Model[Sample,"id:8qZ1VWNmdLBD"], Null}],
			{Object[Company, Supplier, "Emerald Cloud Lab"], $Failed, Model[Sample,"Milli-Q water"], Null}
		],
		Example[{Additional, "Find all Objects at arbitrary depth in an arbitrary expression and convert to named form where possible:"},
			NamedObject[{
				{{0.149567 VolumePercent,Link[Model[Molecule,"id:Vrbp1jK4Z9qz"],"pZx9jowMRoxj"]},{99.8504 VolumePercent,Link[Model[Molecule,"id:vXl9j57PmP5D"],"4pO6dMqGZMOr"]},{0.0319179 Mole/Liter,Link[Model[Molecule,"id:WNa4ZjKVdVOD"],"Vrbp1jOlBjbW"]}},
				{{0.149567 VolumePercent,Link[Model[Molecule,"id:Vrbp1jK4Z9qz"],"GmzlKjr1XlmE"]},{99.8504 VolumePercent,Link[Model[Molecule,"id:vXl9j57PmP5D"],"AEqRl9mwZREp"]},{0.0319179 Mole/Liter,Link[Model[Molecule,"id:WNa4ZjKVdVOD"],"o1k9jAvMq917"]},{1.4036 Mole/Liter,Link[Model[Molecule,"id:BYDOjvG676mq"],"zGj91anMP9Ge"]}}
			}],
			{{{_, Model[Molecule, Except[_?(StringMatchQ[#, "id:"~~___]&)]]}..}..}
		],
		Example[{Options, ConvertToObjectReference, "Replaces links with object references if ConvertToObjectReference is set to True:"},
			NamedObject[Link[Model[Molecule,"id:Vrbp1jK4Z9qz"]], ConvertToObjectReference -> True],
			Model[Molecule, Except[_?(StringMatchQ[#, "id:"~~___]&)]]
		],
		Example[{Options, ConvertToObjectReference, "Leaves links in place (with IDs converted to names) if ConvertToObjectReference is set to False:"},
			NamedObject[Link[Model[Molecule,"id:Vrbp1jK4Z9qz"]], ConvertToObjectReference -> False],
			Link[Model[Molecule, Except[_?(StringMatchQ[#, "id:"~~___]&)]]]
		],
		Example[{Options, MaxNumberOfObjects, "If the expression includes more than MaxNumberOfObjects objects than leaves the input expression untouched."},
			MatchQ[NamedObject[expression, MaxNumberOfObjects->1], expression],
			True,
			SetUp:>{expression = {Object[Company, Supplier, "id:eGakld01qrkB"],Model[Molecule,"id:Vrbp1jK4Z9qz"]}},
			Variables :> {expression}
		],
		Example[{Options, Cache, "Supply a cache to avoid a database trip."},
			NamedObject[Model[Sample,"id:8qZ1VWNmdLBD"], Cache -> {<|Name->"Milli-Q water",Object->Model[Sample,"id:8qZ1VWNmdLBD"],ID->"id:8qZ1VWNmdLBD",Type->Model[Sample]|>}],
			Model[Sample,"Milli-Q water"]
		],
		Test["If run on an atomic expression, returns input without error (ensure that permissiveness of 'expr_' input pattern doesn't cause issues):",
			NamedObject["taco"],
			"taco"
		],
		Test["If run on an object of a type that does not have the Name field, returns input without error :",
			NamedObject[obj],
			obj,
			SetUp:>{obj = Upload[<|Type -> Object[UnitTest, Function], DeveloperObject -> True|>]},
			TearDown:>EraseObject[obj,Force->True,Verbose->False],
			Variables :> {obj}
		],
		Test["If a packet is provided with the name key, the conversion is fast (a database trip is not required):",
			RepeatedTiming[NamedObject[<|Name->"Milli-Q water",Object->Model[Sample,"id:8qZ1VWNmdLBD"],ID->"id:8qZ1VWNmdLBD",Type->Model[Sample]|>]],
			(* This should be more like 0.01 but a database trip will take more than 0.1 *)
			{LessP[0.1], Model[Sample,"Milli-Q water"]}
		],
		Test["If a packet is provided without the name key, the name is obtained from the database and the conversion is successful:",
			NamedObject[<|Object->Model[Sample,"id:8qZ1VWNmdLBD"],ID->"id:8qZ1VWNmdLBD",Type->Model[Sample]|>],
			(* This should be more like 0.01 but a database trip will take more than 0.1 *)
			Model[Sample,"Milli-Q water"]
		],
		Test["If a packet containing the object name is supplied, conversion is fast (a database trip is not required):",
			RepeatedTiming[NamedObject[Model[Sample,"id:8qZ1VWNmdLBD"], Cache -> {<|Name->"Milli-Q water",Object->Model[Sample,"id:8qZ1VWNmdLBD"],ID->"id:8qZ1VWNmdLBD",Type->Model[Sample]|>}]],
			{LessP[0.1], Model[Sample,"Milli-Q water"]}
		],
		Test["If an object is provided in named form, conversion is fast (a database trip is not required):",
			RepeatedTiming[NamedObject[Model[Sample,"Milli-Q water"]]],
			{LessP[0.1], Model[Sample,"Milli-Q water"]}
		],
		Test["Upload packets don't break the function and remain unevaluated:",
			NamedObject[<|Type -> Object[Sample], Status -> Available, Name -> "Test Sample"|>],
			<|Type -> Object[Sample], Status -> Available, Name -> "Test Sample"|>
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PDBIDExistsQ*)


DefineTests[PDBIDExistsQ,
	{
		Example[{Basic,"Return false if the provied string is not in the PDB ID database:"},
			PDBIDExistsQ["0000000000"],
			False
		],
		Example[{Basic,"Return true if the provied string is in the PDB ID database:"},
			PDBIDExistsQ["5RUB"],
			True
		],
		Example[{Basic,"Return true if the provied string is in the PDB ID database:"},
			PDBIDExistsQ["5MAC"],
			True
		],
		Example[{Messages,UnexpectedError,"Return a message if an unexpected value is returned:"},
			PDBIDExistsQ["5MAC"],
			True,
			Messages :> {PDBIDExistsQ::UnexpectedError},
			Stubs:>{
				URLRead[_,{"StatusCode","Body"}]:=<|"StatusCode"->"500","Body"->"Oops"|>
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*FluidContainerTypes*)

DefineTests[
	"FluidContainerTypes",
	{
		Example[{Basic,"Returns a list of all types that are fluid containers:"},
			FluidContainerTypes,
			{TypeP[]..}
		],

		Example[{Basic,"Does not contain any object types which are not fluid containers-like:"},
			MemberQ[FluidContainerTypes,Object[User]],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*SelfContainedSampleTypes*)


DefineTests["SelfContainedSampleTypes",
	{
		Example[{Basic,"Returns a list of the self-contained sample types:"},
			SelfContainedSampleTypes,
			{TypeP[Object[Item]] ..}
		],
		Example[{Basic,"The list of self-contained sample types contains exactly the same elements as a list of all types of Object[Item]:"},
			ContainsExactly[SelfContainedSampleTypes,Types[Object[Item]]],
			True
		],
		Example[{Basic,"The list of self-contained sample types includes Object[Item]:"},
			MemberQ[SelfContainedSampleTypes,Object[Item]],
			True
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*NonSelfContainedSampleTypes*)


DefineTests["NonSelfContainedSampleTypes",
	{
		Example[{Basic,"Returns a list of the non-self-contained sample types:"},
			NonSelfContainedSampleTypes,
			{TypeP[Object[Sample]] ..}
		],
		Example[{Basic,"The list of non-self-contained sample types contains exactly the same elements as a list of all types of Object[Sample]:"},
			ContainsExactly[NonSelfContainedSampleTypes,Types[Object[Sample]]],
			True
		],
		Example[{Basic,"The list of non-self-contained sample types contains only Object[Sample]:"},
			NonSelfContainedSampleTypes,
			{Object[Sample]}
		],
		Example[{Basic,"The list of non-self-contained sample types includes Object[Sample]:"},
			MemberQ[NonSelfContainedSampleTypes,Object[Sample]],
			True
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ProtocolTypes*)


DefineTests[
	ProtocolTypes,
	{
		Example[{Basic,"Returns a list of all Protocol,Qualification,Maintenance types:"},
			ProtocolTypes[],
			{TypeP[]..}
		],
		
		Example[{Basic,"Does not contain any object types which are not protocols-like:"},
			MemberQ[ProtocolTypes[],Object[User]],
			False
		],
		
		Example[{Applications,"Check if a type is a protocol type:"},
			MemberQ[ProtocolTypes[],Object[Data,NMR]],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ProtocolTypeP*)


DefineTests[
	ProtocolTypeP,
	{
		Example[{Basic,"Returns a pattern which matches all Protocol,Qualification,Maintenance types:"},
			MatchQ[Object[Protocol,HPLC],ProtocolTypeP[]],
			True
		],
		
		Example[{Basic,"Returns a pattern which matches does not match anything but Protocol,Qualification,Maintenance types:"},
			MatchQ[Object[Data,NMR],ProtocolTypeP[]],
			False
		],
		
		Example[{Basic,"Does not match anything that is not a type:"},
			MatchQ[12,ProtocolTypeP[]],
			False
		]
	}
];




(* ::Subsection::Closed:: *)
(*AchievableResolution*)


(* ::Subsubsection::Closed:: *)
(*AchievableResolution*)


DefineTests[AchievableResolution,
	{
		Example[{Basic,"Convert a desired volume into a volume that can be accurately measured by ECL:"},
			AchievableResolution[4.99997 Milliliter],
			5 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Basic,"Consider a specific type of measuring device when determining a measurable amount:"},
			AchievableResolution[2.3333 Milliliter,Model[Item, Tips]],
			2.335 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Basic,"An amount within achievable measurement resolution is left unchanged:"},
			AchievableResolution[100 Gram,All],
			100 Gram,
			EquivalenceFunction->Equal
		],
		Example[{Additional,"Consider multiple possible device types when determining the achievable resolution:"},
			AchievableResolution[500 Milliliter,{Model[Item,Tips],Model[Container,GraduatedCylinder]}],
			500 Milliliter,
			EquivalenceFunction->Equal
		],
		Example[{Additional,"Large amounts that would require multiple transfers are rounded based on the resolution of the largest available measuring device:"},
			AchievableResolution[50.004 Liter],
			50 Liter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Options,RoundingFunction,"By default, amounts will be rounded to the nearest achievable amount:"},
			AchievableResolution[501 Milliliter],
			500 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Options,RoundingFunction,"Specify that the achievable amount should always be greater than the provided amount:"},
			AchievableResolution[501 Milliliter,RoundingFunction->Ceiling],
			510 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Options,RoundingFunction,"Specify that the achievable amount should always be less than the provided amount:"},
			AchievableResolution[519 Milliliter,RoundingFunction->Floor],
			510 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Messages,"AmountRounded","Any time an amount is rounded, a message is provided to indicate this rounding has occurred:"},
			AchievableResolution[4.99997 Milliliter],
			5 Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AmountRounded}
		],
		Example[{Messages,"MinimumAmount","An amount has no achievable resolution if it is below the minimum measurable amount by any measuring device in ECL:"},
			AchievableResolution[1 Picoliter],
			$Failed,
			EquivalenceFunction->Equal,
			Messages:>{Error::MinimumAmount}
		],
		Example[{Messages,"MinimumAmount","An amount has no achievable resolution if it is below the minimum measurable amount by a specific measuring device:"},
			AchievableResolution[500 Microliter,Model[Container,GraduatedCylinder]],
			$Failed,
			EquivalenceFunction->Equal,
			Messages:>{Error::MinimumAmount}
		],
		Test["Don't throw AmountRounded message when Messages->False:",
			AchievableResolution[4.99997 Milliliter,Messages->False],
			5 Milliliter,
			EquivalenceFunction->Equal
		],
		Test["Don't throw MinimumAmount message when Messages->False:",
			AchievableResolution[1 Picoliter,Messages->False],
			$Failed,
			EquivalenceFunction->Equal
		]
	}
];


(* ::Subsection::Closed:: *)
(* TransferDevices *)


(* ::Subsubsection::Closed:: *)
(*TransferDevices*)


DefineTests[TransferDevices,
	{
		Example[{Basic,"Return a pipette that can be used in the ECL to transfer 15uL:"},
			TransferDevices[Model[Item,Tips],15 Microliter],
			{{ObjectReferenceP[Model[Item,Tips]],LessEqualP[15 Microliter],GreaterEqualP[15 Microliter],_}..}
		],
		Example[{Basic,"Determine all devices which can measure 5mL:"},
			TransferDevices[All,5 Milliliter],
			{{_,LessEqualP[5 Milliliter],GreaterEqualP[5 Milliliter],_}..}
		],
		Example[{Basic,"Returns all graduated cylinders that may be used as measuring devices:"},
			TransferDevices[Model[Container,GraduatedCylinder],All],
			{{ObjectP[Model[Container,GraduatedCylinder]],_,_,_}..}
		],
		Example[{Options,TipType,"Indicate that wide bore tips of the right size should be returned:"},
			Module[{myTips},
				myTips=TransferDevices[Model[Item,Tips],100 Microliter,TipType->WideBore];
				Download[myTips[[All,1]], WideBore]
			],
			{True..}
		],
		Example[{Options,PipetteType,"Indicate that only serological tips should be returned:"},
			Module[{myTips},
				myTips=TransferDevices[Model[Item,Tips],1.5 Milliliter,PipetteType->Serological];
				Download[myTips[[All,1]], PipetteType]
			],
			{Serological..}
		],
		Example[{Options,EngineDefault,"Indicate if only all possible transfer devices (not only Engine defaults) are returned:"},
			Module[{myEngineDefaultTips,myAllTips},
				myEngineDefaultTips=TransferDevices[Model[Item, Tips], 200 Microliter];
				myAllTips=TransferDevices[Model[Item, Tips], 200 Microliter, EngineDefault -> All];
				{
					SubsetQ[myAllTips,myEngineDefaultTips],
					Download[UnsortedComplement[myAllTips[[All,1]],myEngineDefaultTips[[All,1]]],EngineDefault]
				}
			],
			(* There should be at least one non-EngineDefault tip in the list *)
			{True,{(Null|False)..}}
		],
		Test["Handles listed device type input:",
			TransferDevices[{Model[Container,GraduatedCylinder],Model[Item,Tips]},All],
			{{ObjectP[{Model[Item,Tips],Model[Container,GraduatedCylinder]}],_,_,_}..}
		],
		Test["Returns all the devices and their ranges:",
			TransferDevices[All,All],
			{{_,_,_,_}..}
		]
	}
];


(* ::Subsection::Closed:: *)
(* SampleVolumeRangeQ *)


(* ::Subsubsection::Closed:: *)
(*SampleVolumeRangeQ*)


DefineTests[SampleVolumeRangeQ,
	{
		Example[{Basic,"Return False if the volume is too small to be reliably measured:"},
			SampleVolumeRangeQ[0.05 Microliter],
			False
		],
		Example[{Basic,"Returns True if the volume can be measured and stored without issue:"},
			SampleVolumeRangeQ[5 Milliliter],
			True
		],
		Example[{Basic,"Returns False if the volume is too large to be stored in an ECL standarized container:"},
			SampleVolumeRangeQ[5 Milliliter],
			True
		]
	}
];





(* ::Subsection::Closed:: *)
(* optionsToTable *)


DefineTests[optionsToTable,
	{
		Example[{Basic,"Displays the options (excluding hidden options) organized into a table:"},
			optionsToTable[{Destination -> $Site,
				ExpectedDeliveryDate -> Null, TrackingNumber -> {"12345"},
				Shipper -> Null, DateShipped -> Now, Mass -> None, Volume -> None,
				Output -> Options, Name -> Null, Upload -> True, Cache -> {}, 
				FastTrack -> False, Email -> False}, 
				DropShipSamples],
			Graphics_
		],

		Example[{Basic,"If no options are given, returns an empty list:"},
			optionsToTable[{}, DropShipSamples],
			{}
		],

		Example[{Basic,"If only hidden options are given, returns an empty list:"},
			optionsToTable[{Upload -> True, Cache -> {}, FastTrack -> False, Email -> False}, DropShipSamples],
			{}
		],

		Example[{Basic,"If $Failed is given, returns $Failed:"},
			optionsToTable[$Failed, DropShipSamples],
			$Failed
		]
	}
];
