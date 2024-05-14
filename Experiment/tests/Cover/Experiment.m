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
		(* ===Messages=== *)
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
				Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, fakeBench, containerModel},
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
				Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID]
			};

			fakeBench=Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Fake bench for ExperimentCover tests" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];

			containerModel=Upload[Association[
				DeveloperObject->True,
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
					Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
					Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Item, Cap, "VWR Flip Off 13mm Cap"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well UV-Star Plate"],
					Model[Container, Plate, "96-well UV-Star Plate"],
					Model[Container, Plate, "96-well UV-Star Plate"],
					Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"],
					Model[Container, Vessel, "0.6mL Microcentrifuge Tube"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Rack, "Universal Cap Rack"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Plate, "Lunatic Chip Plate"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Item, Lid, "Universal Black Lid"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container,Bag,Autoclave,"Small Autoclave Bag"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					containerModel,
					Model[Container, Vessel, "1L Pear Shaped Flask with 24/40 Joint"],
					Model[Item, Cap, "24/40 PTFE Stopper"],
					Model[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint"]
				},
				{
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench}
				},
				Name -> {
					"Covered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered 0.3mL High-Recovery Crimp Top Vial (13mm) for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 1" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 2" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 3" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 4" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 5" <> $SessionUUID,
					"Covered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered Flip Off 13mm Cap on Vial for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered DWP for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID,
					"Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID,
					"Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID,
					"Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID,
					"0.6 Microcentrifuge Tube for ExperimentCover Testing" <> $SessionUUID,
					"Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID,
					"Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID,
					"Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID,
					"Universal black lid for ExperimentCover testing" <> $SessionUUID,
					"Universal black lid 2 for ExperimentCover testing" <> $SessionUUID,
					"Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID,
					"Autoclave bag for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID,
					"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID,
					"Uncovered large plate for ExperimentCover Testing"<> $SessionUUID,
					"Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID,
					"24/40 PTFE Stopper for ExperimentCover Testing" <> $SessionUUID,
					"Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID
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

			(* Make all the test objects and models developer objects *)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
		];
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
				Model[Container, Plate, "Plate model for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered large plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, DropletCartridge, "Uncovered Bio-Rad GCR96 Digital PCR Cartridge Testing"<> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 2" <> $SessionUUID],
				Object[Container, Plate, "Uncovered 96-well UV-Star Plate Testing 3" <> $SessionUUID],
				Object[Item, Cap, "Cap for a 2 mL Tube on a cap rack for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 1" <> $SessionUUID],
				Object[Container, Rack, "Universal Cap Rack for ExperimentCover Testing 2" <> $SessionUUID],
				Object[Item, Cap, "50mL Tube Cap PreviousCover for Tube #4 on Cap Rack for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 2mL Tube for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Bag,Autoclave,"Autoclave bag for ExperimentCover Testing" <> $SessionUUID],
				Object[Container,Vessel,"Uncovered 50mL Tube for ExperimentCover Testing 6" <> $SessionUUID],
				Object[Item,Cap,"Autoclave bagged 50 mL tube cap for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered Lunatic chip plate for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid for ExperimentCover testing" <> $SessionUUID],
				Object[Item, Lid, "Universal black lid 2 for ExperimentCover testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Plate, "Uncovered DWP 3 (with Contents) for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 1 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 2 for ExperimentCover Testing" <> $SessionUUID],
				Object[Sample, "Water Sample 3 for ExperimentCover Testing" <> $SessionUUID],
				Object[Container, Vessel, "Uncovered 1L Pear Shaped Flask with 24/40 Joint for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Cap, "24/40 PTFE Stopper for ExperimentCover Testing" <> $SessionUUID],
				Object[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint for ExperimentCover Testing" <> $SessionUUID]
			}],ObjectP[]];


			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force->True, Verbose->False]];
			Unset[$CreatedObjects];
		];
	)
];
