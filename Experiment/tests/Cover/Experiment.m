(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCover: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentCover*)


DefineTests[ExperimentCover,
	{
		(* ===Basic===*)
		Example[{Basic, "Create a protocol object to cover an uncovered container:"},
			ExperimentCover[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing"  <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Cover]]
		],
		Example[{Basic, "For a variety of standard containers, the cover chosen is EngineDefault->True:"},
			ExperimentCover[
				{
					Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID],
					Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID]
				},
				Output -> Options
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, EngineDefault], {True, True}]&)
			}]
		],
		Example[{Basic, "When covering multiple containers at the same time, they're based by CoverType:"},
			Module[{protocol},
				protocol=ExperimentCover[
					{
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 2" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 3" <> $SessionUUID],
						Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID],
						Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID]
					}
				];

				Download[
					protocol,
					BatchedUnitOperations[CoverType]
				]
			],
			{
				{Screw..},
				{Seal}
			}
		],
		Example[{Basic, "Resolve options to cover an uncovered container that's already on a bench:"},
			ExperimentCover[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, {Model[CoverType], Model[CoverFootprint]}], {Crimp, Crimped13mmCap}]&),
				Environment -> ObjectP[Object[Container, Bench, "Fake bench for ExperimentCover tests" <> $SessionUUID]]
			}]
		],
		Example[{Basic, "Environment resolves to a BSC if SterileTechnique->True:"},
			ExperimentCover[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				SterileTechnique -> True,
				Output -> Options
			],
			KeyValuePattern[{
				Environment -> ObjectP[Model[Instrument, BiosafetyCabinet]]
			}]
		],
		Example[{Basic, "When covering a container with a built in cover, doesn't generate any resources for caps:"},
			Module[{protocol},
				protocol=ExperimentCover[
					Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCover Testing" <> $SessionUUID]
				];

				Download[protocol, Covers]
			],
			{Null}
		],
		Example[{Basic, "DWP resolves to a press square seal:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[
				Cover -> ObjectP[Model[Item, PlateSeal, "Plate Seal, 96-Well Square"]]
			]
		],
		Example[{Basic, "Test Robotic version Lid Place:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[]
		],
		Example[{Basic, "Test Robotic version Seal Plate:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				CoverType->Seal,
				Preparation -> Robotic
			],
			ObjectP[]
		],
		(* ===Additional=== *)
		Example[{Additional, "For covering the container with a cap on a cap rack, populate CapRack and CapRacks in the protocol and unit operation:"},
			Module[{protocol},
				protocol=ExperimentCover[
					Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID],
					Cover -> Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCover Testing" <> $SessionUUID]
				];

				Download[
					protocol,
					{CapRacks, BatchedUnitOperations[CapRack]}
				]
			],
			{
				{
					ObjectP[Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID]]
				},
				{
					{
						ObjectP[Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID]]
					}
				}
			}
		],
		Example[{Additional, "Do not allow black lid to be reused on a plate except for Lunatic plate or in a big RSP call:"},
			Download[ExperimentCover[{
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID]
			}],
				UsePreviousCovers],
			{False, True}
		],
		Example[{Additional,"An item originally inside an autoclave bag can used as the cover:"},
			Download[
				ExperimentCover[
					Object[Container,Vessel,"Uncovered 50mL Tube for ExperimentCover Testing 5" <> $SessionUUID],
					Cover->Object[Item,Cap,"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID]
				],
				Covers[Container]
			],
			{ObjectP[Object[Container,Bag,Autoclave]]}
		],
		Example[{Additional, "Given multiple samples in the same container as the input in a Robotic preparation, cover the container with only one cover:"},
			SameQ@@Download[
				ExperimentCover[
					{Object[Sample, "Water Sample 1 for ExperimentCover Testing" <> $SessionUUID], Object[Sample, "Water Sample 2 for ExperimentCover Testing" <> $SessionUUID]},
					Preparation -> Robotic
				],
				OutputUnitOperations[[1]][CoverLabel]
			],
			True,
			Stubs:>{$ECLApplication=Engine}
		],
		Example[{Additional, "If given a container that needs a cap that is a tapered stopper (with TaperGroundJointSize populated), then a KeckClamp will automatically be used:"},
			Download[
				Lookup[
					ExperimentCover[
						{Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID]},
						Output->Options
					],
					{Cover, KeckClamp}
				],
				TaperGroundJointSize
			],
			{"24/40", {"24/25", "24/40"}},
			Stubs:>{$ECLApplication=Engine}
		],
		Example[{Additional, "When a KeckClamp is used, the KeckClamp field of the BatchedUnitOperation is populated:"},
			Download[
				ExperimentCover[
					{Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID]}
				],
				BatchedUnitOperations[[1]][KeckClamp]
			],
			{ObjectP[Model[Item, Clamp]]},
			Stubs:>{$ECLApplication=Engine}
		],
		Example[{Additional, "If the previous cover is an aspiration cap, UsePreviousCover will auto-resolve to False:"},
			options = ExperimentCover[
				{Object[Container, Vessel, "Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, {UsePreviousCover, Cover}],
			{False, ObjectP[Model[Item, Cap, "GL45 Bottle Cap"]]},
			Variables :> {options}
		],
		Example[{Additional, "If an aspiration cap is specified as the Cover option, then it doesn't matter if the same cap was the previous cover:"},
			options = ExperimentCover[
				{Object[Container, Vessel, "Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing"<>$SessionUUID]},
				Output -> Options,
				Cover -> Object[Item, Cap, "Test Aspiration Cap previously covered on 100mL Glass Bottle" <> $SessionUUID]
			];
			Lookup[options, Cover],
			ObjectP[Object[Item, Cap, "Test Aspiration Cap previously covered on 100mL Glass Bottle" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Message, "KeckClampConflict", "If a KeckClamp and Cover are incompatible with one another, an error is thrown:"},
			ExperimentCover[
				{Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID]},
				KeckClamp -> Model[Item, Clamp, "Keck Clamps for 14/20, 14/35 Taper Joint"]
			],
			$Failed,
			Messages:>{
				Error::KeckClampConflict,
				Error::InvalidOption
			},
			Stubs:>{$ECLApplication=Engine}
		],
		Example[{Message, "KeckClampConflict", "If a Cover requires a KeckClamp, but none is provdied, an error is thrown:"},
			ExperimentCover[
				{Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID]},
				KeckClamp -> Null
			],
			$Failed,
			Messages:>{
				Error::KeckClampConflict,
				Error::InvalidOption
			},
			Stubs:>{$ECLApplication=Engine}
		],
		(* ===Options=== *)
		Example[{Options, "If a heat-activated type plate sealer is given, the result cover Seal Type is temperature-activated adhesive and PlateSealAdapter is selected:"},
			ExperimentCover[{
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID]
			},
				Instrument-> Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"],
				Output -> Options
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, SealType], {TemperatureActivatedAdhesive, TemperatureActivatedAdhesive}]&),
				PlateSealAdapter ->
					{ObjectP[Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]], ObjectP[Model[Container, Rack, "PX1 sealer adapter for GCR96 droplet cartridge"]]}
			}]
		],
		Example[{Options, "If Temperature is given, a Bio-Rad Plate Sealer must be used:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Temperature -> 185 Celsius,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument-> ObjectP[Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]],
				PlateSealAdapter -> ObjectP[Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]],
				Preparation -> Manual
			}]
		],
		Example[{Options, "If Time is given, a Bio-Rad Plate Sealer must be used:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Time -> 1 Second,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument-> ObjectP[Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]],
				PlateSealAdapter -> ObjectP[Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]],
				Preparation -> Manual
			}]
		],
		Example[{Options, "If a PlateSealAdapter is given, a Bio-Rad Plate Sealer must be used and parameters are set:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				PlateSealAdapter-> Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument-> ObjectP[Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]],
				Preparation -> Manual
			}]
		],
		Example[{Options, "If a PlateSealPaddle is given, crystal clear sealing film is set:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				PlateSealPaddle-> Model[Item, PlateSealRoller, "Film Sealing Paddle"],
				Output -> Options
			],
			KeyValuePattern[{
				Cover-> ObjectP[Model[Item, PlateSeal,"Crystal Clear Sealing Film"]],
				Preparation -> Manual
			}]
		],
		Example[{Options, "If a heat-activated type plate seal is given, a Bio-Rad plate sealer will be used:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Cover-> Model[Item, PlateSeal, "SBS PCR Plate Seal, Pierceable Heat-Sealed Aluminum"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]],
				PlateSealAdapter-> ObjectP[Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]]
			}]
		],
		Example[{Options, "If Opaque is given as True, the result cover must be opaque:"},
			ExperimentCover[{
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID],
				Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing" <> $SessionUUID]
			},
				Opaque -> True,
				Output -> Options
			],
			KeyValuePattern[{
				Cover -> _?(MatchQ[Download[#, Opaque], {True, True, True}]&)
			}]
		],
		Example[{Options, "If a Hamilton plate sealer is given, the plate seal should be Hamilton plate seal:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Instrument-> Model[Instrument, PlateSealer, "Hamilton Plate Sealer"],
				Output -> Options
			],
			KeyValuePattern[{
				Cover -> ObjectP[Model[Item, PlateSeal, "Aluminum Plate Seal for Hamilton"]]
			}]
		],
		Example[{Options, "Test robotic version with Seal,a Hamilton plate sealer must be used:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				CoverType-> Seal,
				Preparation -> Robotic,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument-> ObjectP[Model[Instrument, PlateSealer, "Hamilton Plate Sealer"]]
			}]
		],
		Example[{Options, "Test robotic version with Place:"},
			ExperimentCover[{
					Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
					Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
					Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing" <> $SessionUUID]
				},
				CoverType-> Place,
				Preparation -> Robotic,
				Output -> Options
			],
			KeyValuePattern[{
				Cover-> ObjectP[Model[Item, Lid, "Universal Black Lid"]],
				Instrument ->Null
			}]
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				CoverType-> Seal,
				OptionsResolverOnly -> True,
				Preparation -> Robotic,
				Output -> Options
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				CoverType-> Seal,
				OptionsResolverOnly -> True,
				Preparation -> Robotic,
				Output -> Result
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],
		Example[{Options, CoverType, "If CoverType is set to AluminumFoil, properly select an AluminumFoil lid to place on the container:"},
			Lookup[
				ExperimentCover[
					Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
					CoverType -> AluminumFoil,
					Output -> Options
				],
				{CoverType, Cover}
			],
			{AluminumFoil, ObjectP[Model[Item, Lid]]}
		],
		Example[{Options, CoverType, "If CoverType is set to AluminumFoil, make a resource for the roll of aluminum foil we will use to make it:"},
			Download[
				ExperimentCover[
					Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
					CoverType -> AluminumFoil
				],
				{AluminumFoilRoll, Covers, BatchedUnitOperations[CoverLink]}
			],
			(* Model[Item, Consumable, "Aluminum Foil"] *)
			{ObjectP[Model[Item, Consumable, "id:xRO9n3vk166w"]], {ObjectP[Model[Item, Lid]]}, {{ObjectP[Model[Item, Lid]]}}}
		],
		Example[{Options, AluminumFoilRoll, "Set the aluminum foil roll to use in wrapping a flask or creating a foil cover with the AluminumFoilRoll option:"},
			Download[
				ExperimentCover[
					Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
					CoverType -> AluminumFoil,
					AluminumFoilRoll -> Object[Item, Consumable, "Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID]
				],
				AluminumFoilRoll
			],
			ObjectP[Object[Item, Consumable, "Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID]]
		],
		Example[{Options, AluminumFoilRoll, "If CoverType is set to AluminumFoil or AluminumFoil is set to True, AluminumFoilRoll is set to a model of aluminum foil:"},
			Download[
				ExperimentCover[
					Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
					CoverType -> AluminumFoil
				],
				AluminumFoilRoll
			],
			ObjectP[Model[Item, Consumable, "Aluminum Foil"]]
		],
		Example[{Options, AluminumFoilRoll, "If CoverType is set to AluminumFoil but the Cover is an existing Object[Item, Lid], then we do not need to pick an AluminumFoilRoll:"},
			Download[
				ExperimentCover[
					Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
					Cover -> Object[Item, Lid, "Unused aluminum foil lid for ExperimentCover Testing" <> $SessionUUID]
				],
				AluminumFoilRoll
			],
			Null
		],
		(* ===Messages=== *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCover[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCover[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCover[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCover[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					Cover -> Null,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCover[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					Cover -> Null,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCover[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "AluminumFoilRollConflict", "If AluminumFoilRoll is specified, then CoverType must be set to AluminumFoil or AluminumFoil must be set to True:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				AluminumFoilRoll -> Object[Item, Consumable, "Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::AluminumFoilRollConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CoverContainerConflict", "Throws an error if the given cover is not compatible with the container:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "VWR Flip Off 13mm Cap"]
			],
			$Failed,
			Messages :> {
				Error::CoverContainerConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CoverOptionsConflict", "Throws an error if the given cover is not compatible with the container for either Opaque or CoverType requirement:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Opaque ->True,
				Cover -> Model[Item, PlateSeal, "Optically Clear Plate Seal for Hamilton"]
			],
			$Failed,
			Messages :> {
				Error::CoverOptionsConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KeepCoveredConflict", "Cannot keep a plate covered when it's covered by a plate seal:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Cover -> Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"],
				KeepCovered -> True
			],
			$Failed,
			Messages :> {
				Error::KeepCoveredConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerInstrumentConflict", "Error when a Plate Seal is given as the cover but the instrument is not a plate sealer:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"],
				Cover -> Model[Item, PlateSeal, "SBS PCR Plate Seal, Permanent Heat-Sealed Clear "]
			],
			$Failed,
			Messages :> {
				Error::PlateSealerInstrumentConflict,
				Error::CrimperConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerInstrumentConflict", "Error when a Plate Seal is not compatible with Hamilton plate sealer:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateSealer, "Hamilton Plate Sealer"],
				Cover -> Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"],
				Preparation->Manual
			], $Failed,
			Messages :> {
				Error::PlateSealerInstrumentConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerInstrumentConflict", "Error when a Plate Seal is not compatible with BioRad plate sealer:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"],
				Cover -> Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]
			], $Failed,
			Messages :> {
				Error::PlateSealerInstrumentConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerHeightConflict", "Throws an error if the given container is not compatible to Hamilton plate sealer instrument:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Instrument->Model[Instrument, PlateSealer, "Hamilton Plate Sealer"]
			],
			$Failed,
			Messages :> {
				Error::PlateSealerInstrumentConflict,
				Error::PlateSealerHeightConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealerHeightConflict", "Throws an error if the given container is not compatible to BioRad plate sealer instrument:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Instrument-> Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]
			],
			$Failed,
			Messages :> {
				Error::PlateSealerHeightConflict,
				Error::PlateSealAdapterConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealAdaptorConflict", "Throws an error if the given container is not compatible to the given BioRad plate sealer adaptor:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				PlateSealAdapter-> Model[Container, Rack, "PX1 sealer adapter for GCR96 droplet cartridge"]
			],
			$Failed,
			Messages :> {
				Error::PlateSealAdapterConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealPaddleConflict", "Throws an error if the given PlateSeal is not compatible to the given PlateSealPaddle:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				PlateSealPaddle-> Model[Item, PlateSealRoller, "Film Sealing Paddle"],
				Cover-> Model[Item, PlateSeal, "AeraSeal Plate Seal, Breathable"]
			],
			$Failed,
			Messages :> {
				Error::PlateSealPaddleConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PlateSealPaddleConflict", "Throws an error if the given PlateSealPaddle is not compatible to the given PlateSeal:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				PlateSealPaddle-> Model[Item, PlateSealRoller, "Amplate Plate Seal Roller"],
				Cover-> Model[Item, PlateSeal,"Crystal Clear Sealing Film"]
			],
			$Failed,
			Messages :> {
				Error::PlateSealPaddleConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CrimperConflict", "Error when given a crimper that does not match CrimpType:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Crimper, "Kebby Pneumatic Power Crimper"]
			],
			$Failed,
			Messages :> {
				Error::CoverContainerConflict,
				Error::CrimperConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "When Preparation->Robotic, cannot use a Cap or Vessel:"},
			ExperimentCover[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "VWR Flip Off 13mm Cap"],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UsePreviousCoverConflict", "If UsePreviousCover->True, the Cover option must be set to the previous cover:"},
			ExperimentCover[
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Cover -> Model[Item, Cap, "VWR Flip Off 13mm Cap"],
				UsePreviousCover -> True
			],
			$Failed,
			Messages :> {
				Error::UsePreviousCoverConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ContainerIsAlreadyCovered", "Specifying a container that is already covered results in an error:"},
			ExperimentCover[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ContainerIsAlreadyCovered,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ContainerLidIncompatible", "Give an error if a plate is too large to be covered with a lid:"},
			ExperimentCover[
				Object[Container, Plate, "Uncovered large plate for ExperimentCover Testing" <> $SessionUUID],
				CoverType->Place
			],
			$Failed,
			Messages :> {
				Error::ContainerLidIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Basic, "When covering a container with a Null notebook, the generated resource is set to have Rent -> True:"},
			Module[{protocolPackets},
				protocolPackets=ExperimentCover[
					Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID],
					Upload -> False
				];
				Cases[protocolPackets, KeyValuePattern[Rent -> True]]
			],
			{PacketP[]}
		]
	},

	Stubs :> {
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$AllowPublicObjects=True
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects={};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container, Bench, "Fake bench for ExperimentCover tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 5" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCover Testing" <> $SessionUUID],
				Model[Container, Plate, "Plate model for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered large plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ExperimentCover testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ExperimentCover testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Bag,Autoclave,"Autoclave bag for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Vessel,"Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID],
				Object[Item,Cap,"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 1 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 3 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "24/40 PTFE Stopper for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Consumable, "Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Lid, "Unused aluminum foil lid for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing"<>$SessionUUID],
				Object[Item, Cap, "Test Aspiration Cap previously covered on 100mL Glass Bottle" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[{allObjects, fakeBench, containerModel},

				fakeBench=Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for ExperimentCover tests" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				containerModel=Upload[Association[
					Type->Model[Container,Plate],
					Name->"Plate model for ExperimentCover Testing" <> $SessionUUID,
					NumberOfWells->1,
					AspectRatio->1,
					Footprint->Plate,
					DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Dimensions->{Quantity[0.12776`,"Meters"],Quantity[0.08548`,"Meters"],Quantity[50`,"Millimeters"]},
					Replace[ExternalDimensions3D]->{{Quantity[0.12776`,"Meters"],Quantity[0.08548`,"Meters"],Quantity[0,"Millimeters"]},{Quantity[200,"Meters"],Quantity[200,"Meters"],Quantity[50,"Millimeters"]}},
					Replace[Positions]->{
						<|Name->"A1",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
					},
					Replace[PositionPlotting]->{
						<|Name->"A1",XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>
					},
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place}
				]];


				UploadSample[
					{
						(*1*)Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
						(*2*)Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
						(*3*)Model[Container, Vessel, "50mL Tube"],
						(*4*)Model[Container, Vessel, "50mL Tube"],
						(*5*)Model[Container, Vessel, "50mL Tube"],
						(*6*)Model[Container, Vessel, "50mL Tube"],
						(*7*)Model[Container, Vessel, "50mL Tube"],
						(*8*)Model[Item, Cap, "VWR Flip Off 13mm Cap"],
						(*9*)Model[Item, Cap, "VWR Flip Off 13mm Cap"],
						(*10*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*11*)Model[Container, Plate, "96-well UV-Star Plate"],
						(*12*)Model[Container, Plate, "96-well UV-Star Plate"],
						(*13*)Model[Container, Plate, "96-well UV-Star Plate"],
						(*14*)Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"],
						(*15*)Model[Container, Vessel, "0.6mL Microcentrifuge Tube"],
						(*16*)Model[Container, Rack, "Universal Cap Rack"],
						(*17*)Model[Container, Rack, "Universal Cap Rack"],
						(*18*)Model[Container, Vessel, "2mL Tube"],
						(*19*)Model[Container, Plate, "Lunatic Chip Plate"],
						(*20*)Model[Item, Lid, "Universal Black Lid"],
						(*21*)Model[Item, Lid, "Universal Black Lid"],
						(*22*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*23*)Model[Container,Bag,Autoclave,"Small Autoclave Bag"],
						(*24*)Model[Container, Vessel, "50mL Tube"],
						(*25*)Model[Item,Cap,"50 mL tube cap"],
						(*26*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*27*)containerModel,
						(*28*)Model[Container, Vessel, "1L Pear Shaped Flask with 24/40 Joint"],
						(*29*)Model[Item, Cap, "24/40 PTFE Stopper"],
						(*30*)Model[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint"],
						(*31*)Model[Container, Vessel, "250mL Erlenmeyer Flask"],
						(*32*)Model[Item, Consumable, "Aluminum Foil"],
						(*33*)Model[Item, Lid, "Aluminum Foil Cover"],
						(*34*)Model[Container, Vessel, "100 mL Glass Bottle"],
						(*35*)Model[Item, Cap, "1L Bottle HexCap Aspiration Cap"]
					},
					{
						(*1*){"Work Surface", fakeBench},
						(*2*){"Work Surface", fakeBench},
						(*3*){"Work Surface", fakeBench},
						(*4*){"Work Surface", fakeBench},
						(*5*){"Work Surface", fakeBench},
						(*6*){"Work Surface", fakeBench},
						(*7*){"Work Surface", fakeBench},
						(*8*){"Work Surface", fakeBench},
						(*9*){"Work Surface", fakeBench},
						(*10*){"Work Surface", fakeBench},
						(*11*){"Work Surface", fakeBench},
						(*12*){"Work Surface", fakeBench},
						(*13*){"Work Surface", fakeBench},
						(*14*){"Work Surface", fakeBench},
						(*15*){"Work Surface", fakeBench},
						(*16*){"Work Surface", fakeBench},
						(*17*){"Work Surface", fakeBench},
						(*18*){"Work Surface", fakeBench},
						(*19*){"Work Surface", fakeBench},
						(*20*){"Work Surface", fakeBench},
						(*21*){"Work Surface", fakeBench},
						(*22*){"Work Surface", fakeBench},
						(*23*){"Work Surface", fakeBench},
						(*24*){"Work Surface", fakeBench},
						(*25*){"Work Surface", fakeBench},
						(*26*){"Work Surface", fakeBench},
						(*27*){"Work Surface", fakeBench},
						(*28*){"Work Surface", fakeBench},
						(*29*){"Work Surface", fakeBench},
						(*30*){"Work Surface", fakeBench},
						(*31*){"Work Surface", fakeBench},
						(*32*){"Work Surface", fakeBench},
						(*33*){"Work Surface", fakeBench},
						(*34*){"Work Surface", fakeBench},
						(*35*){"Work Surface", fakeBench}
					},
					Name -> {
						(*1*)"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID,
						(*2*)"Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID,
						(*3*)"Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID,
						(*4*)"Uncovered 50mL Tube for ExperimentCover Testing 2" <> $SessionUUID,
						(*5*)"Uncovered 50mL Tube for ExperimentCover Testing 3" <> $SessionUUID,
						(*6*)"Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID,
						(*7*)"Uncovered 50mL Tube for ExperimentCover Testing 5" <> $SessionUUID,
						(*8*)"Covered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID,
						(*9*)"Uncovered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID,
						(*10*)"Uncovered DWP for ExperimentCover Testing" <> $SessionUUID,
						(*11*)"Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID,
						(*12*)"Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID,
						(*13*)"Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID,
						(*14*)"Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID,
						(*15*)"0.6 Microcentrifuge Tube for ExperimentCover Testing" <> $SessionUUID,
						(*16*)"Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID,
						(*17*)"Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID,
						(*18*)"Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID,
						(*19*)"Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID,
						(*20*)"Universal black lid for ExperimentCover testing" <> $SessionUUID,
						(*21*)"Universal black lid 2 for ExperimentCover testing" <> $SessionUUID,
						(*22*)"Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID,
						(*23*)"Autoclave bag for ExperimentCover Testing" <> $SessionUUID,
						(*24*)"Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID,
						(*25*)"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID,
						(*26*)"Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID,
						(*27*)"Uncovered large plate for ExperimentCover Testing"<> $SessionUUID,
						(*28*)"Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID,
						(*29*)"24/40 PTFE Stopper for ExperimentCover Testing" <> $SessionUUID,
						(*30*)"Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID,
						(*31*)"Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID,
						(*32*)"Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID,
						(*33*)"Unused aluminum foil lid for ExperimentCover Testing" <> $SessionUUID,
						(*34*)"Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing" <> $SessionUUID,
						(*35*)"Test Aspiration Cap previously covered on 100mL Glass Bottle" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1",Object[Container, Plate, "Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID]},
						{"A2",Object[Container, Plate, "Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID]},
						{"A1",Object[Container, Plate, "Uncovered large plate for ExperimentCover Testing" <> $SessionUUID]}
					},
					InitialAmount -> {1Milliliter,1Milliliter,1Milliliter},
					Name -> {
						"Water Sample 1 for ExperimentCover Testing" <> $SessionUUID,
						"Water Sample 2 for ExperimentCover Testing" <> $SessionUUID,
						"Water Sample 3 for ExperimentCover Testing" <> $SessionUUID
					}
				];

				(* Upload a cap that one a universal cap rack for use in the unit test*)
				UploadSample[
					{
						Model[Item, Cap, "2 mL tube cap, standard"],
						Model[Item, Cap, "50 mL tube cap"]
					},
					{
						{"A1", Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID]},
						{"A1", Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID]}
					},
					Name -> {
						"Cap for a 2 mL Tube on a cap rack for ExperimentCover Testing" <> $SessionUUID,
						"50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCover Testing" <> $SessionUUID
					}
				];

				Upload[<|
					Object -> Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID],
					PreviousCover -> Link[Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCover Testing" <> $SessionUUID]]
				|>];

				(* Add Cover field to Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing"] *)
				UploadCover[
					Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
					Cover -> Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID]
				];

				(* Set PreviousCover field for Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing"]
				 and Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing"] *)
				Upload[{
					<|
						Object -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
						PreviousCover -> Link[Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCover Testing"<> $SessionUUID]]
					|>,
					<|
						Object -> Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID],
						PreviousCover -> Link[Object[Item, Lid, "Universal black lid for ExperimentCover testing"<> $SessionUUID]]
					|>,
					<|
						Object -> Object[Container, Plate, "Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID],
						PreviousCover -> Link[Object[Item, Lid, "Universal black lid 2 for ExperimentCover testing"<> $SessionUUID]]
					|>
				}];

				(* Put a cap inside an autoclave bag *)
				UploadLocation[
					Object[Item,Cap,"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID],
					{"A1",Object[Container,Bag,Autoclave,"Autoclave bag for ExperimentCover Testing"<> $SessionUUID]}
				];

				(* Set the Count of the Object[Item, Clamp], which is actually a bag of Keck clamps *)
				UploadCount[Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID], 10];

				(* Construct some cover history here *)
				UploadCover[Object[Container, Vessel, "Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing" <> $SessionUUID], Cover -> Object[Item, Cap, "Test Aspiration Cap previously covered on 100mL Glass Bottle" <> $SessionUUID]];
				UploadCover[Object[Container, Vessel, "Uncovered 100mL Glass Bottle previously covered by Aspiration cap for ExperimentCover Testing" <> $SessionUUID], Cover -> Null];
			];
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Fake bench for ExperimentCover tests" <> $SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 2" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 3" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for ExperimentCover Testing 5" <> $SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCover Testing" <> $SessionUUID],
				Model[Container, Plate, "Plate model for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered large plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ExperimentCover testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ExperimentCover testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Bag,Autoclave,"Autoclave bag for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Vessel,"Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID],
				Object[Item,Cap,"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 1 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 3 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "24/40 PTFE Stopper for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 250mL Erlenmeyer Flask for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Consumable, "Aluminum foil roll for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Lid, "Unused aluminum foil lid for ExperimentCover Testing" <> $SessionUUID]
			}], ObjectP[]];


			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force->True, Verbose->False]];
			Unset[$CreatedObjects];
		];
	)
];



(* ::Subsection::Closed:: *)
(*Cover*)



DefineTests[Cover,
	{
		Example[{Basic, "Create a protocol object to cover an uncovered container:"},
			Experiment[{
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
					Amount -> 0.1 Milliliter
				],
				Cover[
					Sample -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID]
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "For a variety of standard containers, the cover chosen is EngineDefault->True:"},
			Experiment[{
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
					Amount -> 0.1 Milliliter
				],
				Cover[
					Sample -> {
						Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 1"<>$SessionUUID],
						Object[Container, Plate, "Uncovered DWP for Cover Testing"<>$SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol]]
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for Cover tests"<>$SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 1"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 2"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 3"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 4"<>$SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for Cover Testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered DWP for Cover Testing"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 1"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 2"<>$SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for Cover Testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for Cover Testing"<>$SessionUUID],
				Object[Item, Lid, "Universal black lid for Cover testing"<>$SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for Cover testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for Cover Testing"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench},
			allObjects = {
				Object[Container, Bench, "Test bench for Cover tests"<>$SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 1"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 2"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 3"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 4"<>$SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for Cover Testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered DWP for Cover Testing"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 1"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 2"<>$SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for Cover Testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for Cover Testing"<>$SessionUUID],
				Object[Item, Lid, "Universal black lid for Cover testing"<>$SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for Cover testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for Cover Testing"<>$SessionUUID]
			};

			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for Cover tests"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];

			UploadSample[
				{
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "id:6V0npvmW99k1"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "0.6mL Microcentrifuge Tube"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "Lunatic Chip Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID,
					"Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID,
					"Uncovered 50mL Tube for Cover Testing 1"<>$SessionUUID,
					"Uncovered 50mL Tube for Cover Testing 2"<>$SessionUUID,
					"Uncovered 50mL Tube for Cover Testing 3"<>$SessionUUID,
					"Uncovered 50mL Tube for Cover Testing 4"<>$SessionUUID,
					"Covered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID,
					"Uncovered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID,
					"Uncovered DWP for Cover Testing"<>$SessionUUID,
					"0.6 Microcentrifuge Tube for Cover Testing"<>$SessionUUID,
					"Universal Cap Rack for Cover Testing 1"<>$SessionUUID,
					"Universal Cap Rack for Cover Testing 2"<>$SessionUUID,
					"Uncovered 2mL Tube for Cover Testing"<>$SessionUUID,
					"Uncovered Lunatic chip plate for Cover Testing"<>$SessionUUID,
					"Universal black lid for Cover testing"<>$SessionUUID,
					"Universal black lid 2 for Cover testing"<>$SessionUUID,
					"Uncovered DWP 2 for Cover Testing"<>$SessionUUID
				}
			];

			(* Upload a cap that one a universal cap rack for use in the unit test*)
			UploadSample[
				{
					Model[Item, Cap, "2 mL tube cap, standard"],
					Model[Item, Cap, "50 mL tube cap"]
				},
				{
					{"A1", Object[Container, Rack, "Universal Cap Rack for Cover Testing 1"<>$SessionUUID]},
					{"A1", Object[Container, Rack, "Universal Cap Rack for Cover Testing 2"<>$SessionUUID]}
				},
				Name -> {
					"Cap for a 2 mL Tube on a cap rack for Cover Testing"<>$SessionUUID,
					"50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for Cover Testing"<>$SessionUUID
				}
			];

			Upload[<|
				Object -> Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 4"<>$SessionUUID],
				PreviousCover -> Link[Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for Cover Testing"<>$SessionUUID]]
			|>];

			(* Add Cover field to Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing" <> $SessionUUID] *)
			UploadCover[
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Cover -> Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID]
			];

			(* Set PreviousCover field for Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing" <> $SessionUUID]
			 and Object[Container, Plate, "Uncovered Lunatic chip plate for Cover Testing" <> $SessionUUID] *)
			Upload[{
				<|
					Object -> Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
					PreviousCover -> Link[Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered Lunatic chip plate for Cover Testing"<>$SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid for Cover testing"<>$SessionUUID]]
				|>,
				<|
					Object -> Object[Container, Plate, "Uncovered DWP 2 for Cover Testing"<>$SessionUUID],
					PreviousCover -> Link[Object[Item, Lid, "Universal black lid 2 for Cover testing"<>$SessionUUID]]
				|>
			}];

			(*Make all the test objects and models developer objects*)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for Cover tests"<>$SessionUUID],
				Object[Container, Vessel, "Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "0.6 Microcentrifuge Tube for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 1"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 2"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 3"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 50mL Tube for Cover Testing 4"<>$SessionUUID],
				Object[Item, Cap, "Covered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Uncovered Flip Off 13mm Cap on Vial for Cover Testing"<>$SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for Cover Testing"<>$SessionUUID],
				Object[Container, Plate, "Uncovered DWP for Cover Testing"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 1"<>$SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for Cover Testing 2"<>$SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for Cover Testing"<>$SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for Cover Testing"<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];
