(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentGrowCrystal: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentGrowCrystal*)


DefineTests[ExperimentGrowCrystal,
	{
		(* ===Basic===*)
		Example[{Basic, "Create a protocol object to grow crystal of one sample:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GrowCrystal]]
		],
		Example[{Basic, "Create a protocol object to grow crystal of several samples:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]
			],
			ObjectP[Object[Protocol, GrowCrystal]]
		],
		Example[{Basic, "Create a protocol object to grow crystal of sample from a container:"},
			ExperimentGrowCrystal[
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GrowCrystal]]
		],
		Example[{Basic, "Create a protocol object to grow crystal of sample from a prepared crystallization plate:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GrowCrystal]]
		],
		Example[{Basic, "When samples are prepared in a container without cover, doesn't generate any resources for Plate but generates resource for Cover:"},
			protocol = ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True
			];
			{MemberQ[protocol[RequiredResources][[All,2]], AssayPlates], MemberQ[protocol[RequiredResources][[All, 2]], CrystallizationCover]},
			{False, True},
			Variables :> {protocol}
		],
		Example[{Basic, "When samples are prepared in a container with a crystallization cover, doesn't generate any resources for Plate or Cover:"},
			protocol = ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True
			];
			{MemberQ[protocol[RequiredResources][[All, 2]], AssayPlates], MemberQ[protocol[RequiredResources][[All, 2]], CrystallizationCover]},
			{False, False},
			Variables :> {protocol}
		],
		Example[{Basic, "When samples are prepared in a container with a cover which is not suitable for crystal incubator, doesn't generate any resources for Plate but generates resource for Cover:"},
			protocol = ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True
			];
			{MemberQ[protocol[RequiredResources][[All, 2]], AssayPlates], MemberQ[protocol[RequiredResources][[All, 2]], CrystallizationCover]},
			{False, True},
			Variables :> {protocol}
		],
		(* ===Options=== *)
		Example[{Options, PreparedPlate, "If PreparedPlate is True, all sample preparation related options should be Null:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirDispensingInstrument -> Null,
				DropSetterInstrument -> Null,
				CrystallizationScreeningMethod -> Null,
				ReservoirBuffers -> Null,
				DilutionBuffer -> Null,
				Additives -> Null,
				CoCrystallizationReagents -> Null,
				CoCrystallizationAirDry -> Null,
				CoCrystallizationAirDryTime -> Null,
				CoCrystallizationAirDryTemperature -> Null,
				SeedingSolution -> Null,
				Oil -> Null
			}]
		],
		Example[{Options, CrystallizationTechnique, "If CrystallizationTechnique is specified as SittingDropVaporDiffusion, a ReservoirDispensingInstrument must be used:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				Output -> Options
			],
			KeyValuePattern[{ReservoirDispensingInstrument -> ObjectP[]}]
		],
		Example[{Options, CrystallizationTechnique, "If specified CrystallizationTechnique is MicrobatchWithoutOil, a ReservoirDispensingInstrument must not be used:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CrystallizationTechnique -> MicrobatchWithoutOil,
				Output -> Options
			],
			KeyValuePattern[{ReservoirDispensingInstrument -> Null}]
		],
		Example[{Options, CrystallizationStrategy, "If CrystallizationStrategy is Screening, the DropSetterInstrument must be Echo Acoustic Liquid Handler:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{DropSetterInstrument -> ObjectP[Model[Instrument, LiquidHandler, AcousticLiquidHandler]]}]
		],
		Example[{Options, CrystallizationStrategy, "If CrystallizationStrategy is Optimization, the DropSetterInstrument must be Hamilton LiquidHandler:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{DropSetterInstrument -> ObjectP[Model[Instrument, LiquidHandler, "Super STAR"]]}]
		],
		Example[{Options, CrystallizationPlate, "If CrystallizationPlate is specified, CrystallizationTechnique must be compatible with CrystallizationPlate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationTechnique -> SittingDropVaporDiffusion}]
		],
		Example[{Options, CrystallizationCover, "CrystallizationCover indicates the final PlateSeal on CrystallizationPlate when it is stored in crystal incubator:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				CrystallizationCover -> Object[Item, PlateSeal, "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{CrystallizationCover -> ObjectP[Object[Item, PlateSeal, "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID]]}]
		],
		Example[{Options, CrystallizationPlateLabel, "CrystallizationPlateLabel indicates the name string of CrystallizationPlate for downstream operations:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				CrystallizationPlateLabel -> "myTest Plate Label",
				Output -> Options
			],
			KeyValuePattern[{CrystallizationPlateLabel -> "myTest Plate Label"}]
		],
		Example[{Options, DropSetterInstrument, "DropSetterInstrument indicates the instrument to transfer samples and buffers to drop wells:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DropSetterInstrument -> Model[Instrument, LiquidHandler, AcousticLiquidHandler, "Labcyte Echo 650"],
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			],
			KeyValuePattern[{DropSetterInstrument -> ObjectP[Model[Instrument, LiquidHandler, AcousticLiquidHandler, "Labcyte Echo 650"]]}]
		],
		Example[{Options, ReservoirDispensingInstrument, "ReservoirDispensingInstrument indicates the instrument to transfer buffers to reservoir wells:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ReservoirDispensingInstrument -> Model[Instrument, LiquidHandler, "Super STAR"],
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirDispensingInstrument -> ObjectP[Model[Instrument, LiquidHandler, "Super STAR"]],
				CrystallizationTechnique -> SittingDropVaporDiffusion
			}]
		],
		Example[{Options, ImagingInstrument, "If ImagingInstrument is specified, UVImaging is True if the ImagingInstrument is capable of UVImaging:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ImagingInstrument -> Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"],
				Output -> Options
			],
			KeyValuePattern[{
				ImagingInstrument -> ObjectP[Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"]],
				UVImaging -> True
			}]
		],
		Example[{Options, ImagingInstrument, "If ImagingInstrument is specified, UVImaging is False if the ImagingInstrument is not capable of UVImaging:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ImagingInstrument -> Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				ImagingInstrument -> ObjectP[Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID]]
			}]
		],
		Example[{Options, UVImaging, "UVImaging indicates if UV Imaging mode is used to monitor crystallization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				UVImaging -> False,
				Output -> Options
			],
			KeyValuePattern[{UVImaging -> False}]
		],
		Example[{Options, CrossPolarizedImaging, "CrossPolarizedImaging indicates if CrossPolarizedImaging Imaging mode is used to monitor crystallization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CrossPolarizedImaging -> False,
				Output -> Options
			],
			KeyValuePattern[{CrossPolarizedImaging -> False}]
		],
		Example[{Options, PreMixBuffer, "PreMixBuffer indicates if buffers should be mixed before adding to CrystallizationPlate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				PreMixBuffer -> False,
				Output -> Options
			],
			KeyValuePattern[{PreMixBuffer -> False}]
		],
		Example[{Options, MaxCrystallizationTime, "MaxCrystallizationTime indicates if the max duration of crystallization process inside of the crystal incubator:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				MaxCrystallizationTime -> 2 Day,
				Output -> Options
			],
			KeyValuePattern[{MaxCrystallizationTime -> 2 Day}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If CrystallizationScreeningMethod with ReservoirBuffers field is specified, ReservoirBuffers option is populated accordingly:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]],
				ReservoirBuffers -> {
					ObjectP[Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Model[Sample, "Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				}
			}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If CrystallizationScreeningMethod with Additives field is specified, Additives option is populated accordingly:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]],
				Additives -> {
					ObjectP[Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				}
			}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is protein, CrystallizationScreeningMethod is resolved to Hampton Research Crystal Screen Lite when doing optimization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is protein, CrystallizationScreeningMethod is resolved to Hampton Research MembFac HT Screen when doing screening:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research MembFac HT Screen"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is DNA, CrystallizationScreeningMethod is resolved to Hampton Research Crystal Screen Lite when doing optimization:"},
			ExperimentGrowCrystal[
				Object[Sample, "DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is DNA, CrystallizationScreeningMethod is resolved to Hampton Research MembFac HT Screen when doing screening:"},
			ExperimentGrowCrystal[
				Object[Sample, "DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research MembFac HT Screen"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is antibody, CrystallizationScreeningMethod is resolved to Hampton Research GRAS2 Screen when doing screening:"},
			ExperimentGrowCrystal[
				Object[Sample, "Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research GRAS Screen 2"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is antibody, CrystallizationScreeningMethod is resolved to Hampton Research Crystal Screen Lite when doing optimization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is small molecule, CrystallizationScreeningMethod is resolved to Hampton Research SaltRX 1 Screen when doing optimization :"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research SaltRx 1 Screen" ]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If input sample is small molecule, CrystallizationScreeningMethod is resolved to Hampton Research SaltRX HT Screen when doing screening:"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Hampton Research SaltRx HT Screen" ]]}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If CrystallizationScreeningMethod is Custom, screening reagents are either None or a list of values:"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Custom,
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationScreeningMethod -> Custom,
				ReservoirBuffers ->  {ObjectP[]},
				Additives -> None,
				CoCrystallizationReagents -> None
			}]
		],
		Example[{Options, CrystallizationScreeningMethod, "If CrystallizationScreeningMethod is None, CrystallizationStrategy is Preparation:"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> None,
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationScreeningMethod -> None,
				ReservoirBuffers -> {ObjectP[]},
				Additives -> None,
				CoCrystallizationReagents -> None
			}]
		],
		Example[{Options, SampleVolumes, "If CrystallizationStrategy is Optimization, SampleVolumes is resolved to 2 Microliter:"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{SampleVolumes -> {2 Microliter}}]
		],
		Example[{Options, SampleVolumes, "If CrystallizationStrategy is Screening, SampleVolumes is resolved to 200 Nanoliter:"},
			ExperimentGrowCrystal[
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Screening,
				Output -> Options
			],
			KeyValuePattern[{SampleVolumes -> {200 Nanoliter}}]
		],
		Example[{Options, SampleVolumes, "If one input sample has specified SampleVolumes, SampleVolumes of other inputs are resolved to the minimum of the specified SampleVolumes:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				SampleVolumes -> {{200 Nanoliter, 500 Nanoliter}, Automatic},
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{SampleVolumes -> {{200 Nanoliter, 500 Nanoliter}, {200 Nanoliter}}}]
		],
		Example[{Options, ReservoirBuffers, "If only one ReservoirBuffers is specified directly, CrystallizationScreeningMethod is resolved to None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				ReservoirDropVolume -> 1 Microliter,
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirBuffers -> {ObjectP[Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID]]},
				ReservoirDropVolume -> VolumeP,
				CrystallizationScreeningMethod -> None
			}]
		],
		Example[{Options, ReservoirBuffers, "If ReservoirBuffers is specified as multiple values directly, CrystallizationScreeningMethod is resolved to Custom:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ReservoirBuffers -> {
					Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirBuffers -> {
					ObjectP[Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				},
				ReservoirDropVolume -> VolumeP,
				CrystallizationScreeningMethod -> Custom
			}]
		],
		Example[{Options, ReservoirBuffers, "If ReservoirBuffers is not specified and CrystallizationScreeningMethod is not used, ReservoirBuffers is resolved to NaCl solution:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> None,
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirBuffers -> {ObjectP[Model[Sample, StockSolution, "300mM Sodium Chloride"]]},
				CrystallizationScreeningMethod -> None
			}]
		],
		Example[{Options, ReservoirBufferVolume, "ReservoirBufferVolume indicates the volume for reservoir wells when using SittingDropVaporDiffusion CrystallizationTechnique:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBufferVolume -> 200 Microliter,
				Output -> Options
			],
			KeyValuePattern[{ReservoirBufferVolume -> 200 Microliter}]
		],
		Example[{Options, ReservoirBufferVolume, "ReservoirBufferVolume is resolved to Null if CrystallizationTechnique is not SittingDropVaporDiffusion:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CrystallizationTechnique -> MicrobatchWithoutOil,
				Output -> Options
			],
			KeyValuePattern[{ReservoirBufferVolume -> Null}]
		],
		Example[{Options, ReservoirDropVolume, "ReservoirDropVolume is resolved to Null if ReservoirBuffers is None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ReservoirBuffers -> None,
				Output -> Options
			],
			KeyValuePattern[{
				ReservoirBuffers -> None,
				ReservoirDropVolume -> Null
			}]
		],
		Example[{Options, DilutionBuffer, "DilutionBuffer indicates the buffer to bring the concentration of sample down:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			],
			KeyValuePattern[{DilutionBuffer -> ObjectP[Model[Sample, "Milli-Q water"]]}]
		],
		Example[{Options, DilutionBufferVolume, "DilutionBufferVolume indicates the volume to mix with samples for dilution:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {1 Microliter},
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				DilutionBufferVolume -> 1 Microliter,
				Output -> Options
			],
			KeyValuePattern[{DilutionBufferVolume -> 1 Microliter}]
		],
		Example[{Options, Additives, "If Additives is not specified and CrystallizationScreeningMethod is None, Additives is resolved to None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> None,
				CrystallizationStrategy -> Optimization,
				Output -> Options
			],
			KeyValuePattern[{Additives -> None}]
		],
		Example[{Options, Additives, "If Additives is not specified and CrystallizationScreeningMethod is Custom, Additives is resolved to None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Custom,
				Output -> Options
			],
			KeyValuePattern[{Additives -> None}]
		],
		Example[{Options, AdditiveVolume, "AdditiveVolume indicates the volume to mix with samples for dilution:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				AdditiveVolume -> 1 Microliter,
				SampleVolumes -> {2 Microliter},
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationScreeningMethod -> ObjectP[Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]],
				AdditiveVolume -> 1 Microliter
			}]
		],
		Example[{Options, CoCrystallizationReagents, "If CoCrystallizationReagents is not specified and CrystallizationScreeningMethod is None, CoCrystallizationReagents is resolved to None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> None,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagents -> None,
				CrystallizationStrategy -> Preparation
			}]
		],
		Example[{Options, CoCrystallizationReagents, "If CoCrystallizationReagents is not specified and CrystallizationScreeningMethod is Custom, CoCrystallizationReagents is resolved to None:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Custom,
				Output -> Options
			],
			KeyValuePattern[{CoCrystallizationReagents -> None}]
		],
		Example[{Options, CoCrystallizationReagentVolume, "CoCrystallizationReagentVolume indicates the volume to mix with samples for dilution:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CoCrystallizationReagentVolume -> 1 Microliter,
				SampleVolumes -> {2 Microliter},
				CoCrystallizationReagents -> {Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagents -> {ObjectP[Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]]},
				CoCrystallizationReagentVolume -> 1 Microliter
			}]
		],
		Example[{Options, CoCrystallizationAirDry, "CoCrystallizationAirDry indicates whether the CoCrystallizationReagents are added before other samples or buffers:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> None,
				CoCrystallizationReagents -> {
					Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagentVolume -> 1 Microliter,
				CoCrystallizationAirDry -> True,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagents -> {
					ObjectP[Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				},
				CoCrystallizationAirDry -> True
			}]
		],
		Example[{Options, CoCrystallizationAirDryTime, "CoCrystallizationAirDryTime indicates how long the CoCrystallizationReagents are kept in fume hood before adding other samples or buffers:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> None,
				CoCrystallizationReagents -> {
					Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagentVolume -> 1 Microliter,
				CoCrystallizationAirDryTime -> 2 Hour,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagents -> {
					ObjectP[Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				},
				CoCrystallizationAirDry -> True,
				CoCrystallizationAirDryTime -> 2 Hour,
				CoCrystallizationAirDryTemperature -> Ambient
			}]
		],
		Example[{Options, CoCrystallizationAirDryTime, "If there are two samples but only one of them has True CoCrystallizationAirDry, CoCrystallizationAirDryTime is resolved:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				ReservoirBuffers -> None,
				CrystallizationStrategy -> Screening,
				CoCrystallizationReagents -> {
					{
						Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					{
						Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
					}
				},
				CoCrystallizationAirDry -> {True, False},
				CoCrystallizationReagentVolume -> {1 Microliter, 200 Nanoliter},
				CoCrystallizationAirDryTime -> Automatic,
				PreMixBuffer -> False,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationAirDry -> {True, False},
				CoCrystallizationAirDryTime -> 30 Minute
			}]
		],
		Example[{Options, CoCrystallizationAirDryTime, "If there are two samples and only of them has CoCrystallizationReagents and True CoCrystallizationAirDry, CoCrystallizationAirDryTime is resolved:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationStrategy -> Preparation,
				CoCrystallizationReagents -> {
					{
						Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					None
				},
				CoCrystallizationAirDry -> {True, Automatic},
				CoCrystallizationAirDryTime -> Automatic,
				PreMixBuffer -> False,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagentVolume -> {500 Nanoliter, Null},
				CoCrystallizationAirDryTime -> 30 Minute,
				CoCrystallizationAirDryTemperature -> 40 Celsius
			}]
		],
		Example[{Options, CoCrystallizationAirDryTemperature, "CoCrystallizationAirDryTemperature indicates the temperature the CoCrystallizationReagents are kept in fume hood or heater block of LH before adding other samples or buffers:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> None,
				CoCrystallizationReagents -> {
					Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationAirDry -> True,
				CoCrystallizationReagentVolume -> 1 Microliter,
				CoCrystallizationAirDryTime -> 2 Hour,
				CoCrystallizationAirDryTemperature -> Ambient,
				Output -> Options
			],
			KeyValuePattern[{
				CoCrystallizationReagents -> {
					ObjectP[Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]],
					ObjectP[Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]]
				},
				CoCrystallizationAirDry -> True,
				CoCrystallizationAirDryTime -> 2 Hour,
				CoCrystallizationAirDryTemperature -> Ambient
			}]
		],
		Example[{Options, SeedingSolution, "SeedingSolution indicates the crystal seeding solutions to facilitate crystallization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SeedingSolution -> Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{SeedingSolution -> ObjectP[Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]]}]
		],
		Example[{Options, SeedingSolutionVolume, "SeedingSolutionVolume indicates amount of seeding solution to each drop well to facilitate crystallization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {1 Microliter},
				SeedingSolution -> Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SeedingSolutionVolume -> 1 Microliter,
				Output -> Options
			],
			KeyValuePattern[{
				SeedingSolution -> ObjectP[Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]],
				SeedingSolutionVolume -> 1 Microliter
			}]
		],
		Example[{Options, Oil, "Oil indicates the oil layer over aqueous droplet when using MicrobatchUnderOil:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Preparation,
				Oil -> Model[Sample, "Mineral Oil"],
				Output -> Options
			],
			KeyValuePattern[{
				Oil -> ObjectP[Model[Sample, "Mineral Oil"]],
				CrystallizationTechnique -> MicrobatchUnderOil
			}]
		],
		Example[{Options, Oil, "Oil is resolved to Null if CrystallizationTechnique is not MicrobatchUnderOil:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				Output -> Options
			],
			KeyValuePattern[{Oil -> Null}]
		],
		Example[{Options, OilVolume, "OilVolume indicates amount of seeding solution to each drop well to facilitate crystallization:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {1 Microliter},
				CrystallizationTechnique -> MicrobatchUnderOil,
				OilVolume -> 14 Microliter,
				Output -> Options
			],
			KeyValuePattern[{
				Oil -> ObjectP[],
				OilVolume -> 14 Microliter
			}]
		],
		Example[{Options, DropSamplesOutLabel, "DropSamplesOutLabel indicates the name string of output samples in drop well for downstream operations:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Preparation,
				DropSamplesOutLabel -> {"my Output sample 1"},
				Output -> Options
			],
			KeyValuePattern[{DropSamplesOutLabel -> {"my Output sample 1"}}]
		],
		Example[{Options, ReservoirSamplesOutLabel, "ReservoirSamplesOutLabel indicates the name string of out samples in reservoir well for downstream operations:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{
				DropSamplesOutLabel -> {Alternatives[{_String}, Null]..},
				ReservoirSamplesOutLabel -> {Alternatives[{_String}, Null]..}
			}]
		],
		Example[{Options, DropDestination, "DropDestination is resolved to set up imaging schedule:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				ReservoirBuffers -> None,
				Output -> Options
			],
			KeyValuePattern[{DropDestination -> {Drop1}}]
		],
		Example[{Options, DropDestination, "DropDestination can be set:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "48 Intelli 3 Drop Plate"],
				DilutionBuffer -> Model[Sample, "Milli-Q water"],
				ReservoirBuffers -> None,
				DropDestination -> {Drop2},
				Output -> Options
			],
			KeyValuePattern[{DropDestination -> {Drop2}}]
		],
		Example[{Options, DropDestination, "DropDestination is resolved to multiple values if CrystallizationTechnique is SittingDropVaporDiffusion:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {200 Nanoliter, 250 Nanoliter, 300 Nanoliter},
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				Output -> Options
			],
			KeyValuePattern[{
				DropDestination -> {Drop1, Drop2, Drop3}
			}]
		],
		Example[{Options, DropDestination, "DropDestination is resolved to single value if total crystallization conditions can be divided evenly:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {200 Nanoliter, 250 Nanoliter},
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				CrystallizationScreeningMethod -> Custom,
				Additives -> {
					Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				Output -> Options
			],
			KeyValuePattern[{DropDestination -> {Drop1}}]
		],
		Example[{Options, DropDestination, "DropDestination is resolved to a single value if CrystallizationTechnique not SittingDropVaporDiffusion:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CoCrystallizationReagents-> {
					Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				Additives -> {
					Object[Sample, "Additive 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 3 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				ReservoirBuffers -> None,
				CrystallizationTechnique -> MicrobatchWithoutOil,
				Output -> Options
			],
			KeyValuePattern[{
				CrystallizationTechnique -> MicrobatchWithoutOil,
				DropDestination -> {Drop1}
			}]
		],
		Example[{Options, DropDestination, "If a prepared plate is given, DropDestination is resolved based on well contents:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			KeyValuePattern[{DropDestination -> {{Drop1}, {Drop1}, Null, Null}}]
		],
		(* Shared Options *)
		Example[{Options, {Centrifuge, CentrifugeIntensity, CentrifugeTime, CentrifugeTemperature}, "Set Centrifuge, CentrifugeIntensity, CentrifugeTime, CentrifugeTemperature options:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Centrifuge -> True,
				CentrifugeIntensity -> 1000 RPM,
				CentrifugeTime -> 2 Minute,
				CentrifugeTemperature -> Ambient,
				Output -> Options
			];
			Lookup[options, {Centrifuge, CentrifugeIntensity, CentrifugeTime, CentrifugeTemperature}],
			{True, 1000 RPM, 2 Minute, Ambient},
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, {Filtration, FiltrationType, FilterTime, FilterMaterial, FilterPoreSize}, "Set Filtration, FiltrationType, FilterTime, FilterMaterial, FilterPoreSize options:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Filtration -> True,
				FiltrationType -> Syringe,
				FilterTime -> 5 Minute,
				FilterMaterial -> PES,
				FilterPoreSize -> 0.45 Micrometer,
				Output -> Options
			];
			Lookup[options, {Filtration, FiltrationType, FilterTime, FilterMaterial, FilterPoreSize}],
			{True, Syringe, 5 Minute,PES, 0.45 Micrometer},
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, {Incubate, IncubationTime, IncubationTemperature}, "Set Incubate, IncubationTime, IncubationTemperature options:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Incubate -> True,
				IncubationTime -> 30 Minute,
				IncubationTemperature -> 40 Celsius,
				Output -> Options
			];
			Lookup[options, {Incubate, IncubationTime, IncubationTemperature}],
			{True, 30 Minute, 40 Celsius},
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryPrimitives option to prepare a plate from models before the experiment is run:"},
			protocol = ExperimentGrowCrystal[
				"ExperimentGrowCrystal PreparatoryUnitOperations test plate",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "ExperimentGrowCrystal PreparatoryUnitOperations test plate", Container -> Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"]],
					Transfer[Source -> Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"], Destination -> {"A1Drop1", "ExperimentGrowCrystal PreparatoryUnitOperations test plate"}, Amount -> 2 Microliter]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, Output, "Return a list of resolved options for the given samples when Output is set to Options:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Options
			],
			{_Rule..}
		],
		Example[{Options, Output, "Return a list of tests for the given samples when Output is set to Tests:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Tests
			],
			{_EmeraldTest..}
		],
		Example[{Options, Output, "Create a simulation protocol for the given samples when Output is set to Simulation:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		],
		(* ===Messages=== *)
		Example[{Messages, "SolidSamplesUnsupported", "Throws an error if the input sample is not liquid:"},
			ExperimentGrowCrystal[
				Object[Sample, "Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::SolidSamplesUnsupported,
				Error::InvalidInput
			}
		],
		Example[{Messages, "GrowCrystalTooManySamples", "Throws an error if specified number of SamplesIn exceeds the number of wells of a single plate:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::GrowCrystalTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InstrumentPrecision", "Throws a warning if option is rounded:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBufferVolume -> 20.11 Microliter,
				Output -> Options
			];
			Lookup[options, ReservoirBufferVolume],
			20.1 Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Messages, "DropVolumePrecision", "Throws a warning if SampleVolumes is rounded when using Hamilton:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {2040 Nanoliter},
				Output -> Options
			];
			Lookup[options, SampleVolumes],
			{2000 Nanoliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::DropVolumePrecision},
			Variables :> {options}
		],
		Example[{Messages, "DropVolumePrecision", "Throws a warning if SampleVolumes is rounded when using Echo:"},
			options = ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {204 Nanoliter},
				Output -> Options
			];
			Lookup[options, SampleVolumes],
			{205 Nanoliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::DropVolumePrecision},
			Variables :> {options}
		],
		Example[{Messages, "DropVolumePrecision", "Throws a warning if CoCrystallizationReagents is rounded to either nearest 10 or 100 Nanoliter based on Air Dry:"},
			options = ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationStrategy -> Optimization,
				CoCrystallizationReagents -> {
					Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagentVolume -> {1.01 Microliter, 202 Nanoliter},
				CoCrystallizationAirDry -> {True, False},
				Output -> Options
			];
			Lookup[options, CoCrystallizationReagentVolume],
			{1000 Nanoliter, 200 Nanoliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::DropVolumePrecision},
			Variables :> {options}
		],
		Example[{Messages, "Warning::DropSamplePreMixed", "Throws a warning if premixing with samples occurs:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationStrategy -> Optimization,
				ReservoirDropVolume -> 200 Nanoliter,
				CoCrystallizationReagents -> {
					Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagentVolume -> 200 Nanoliter,
				Output -> Options
			],
			_,
			Messages :> {Warning::DropSamplePreMixed}
		],
		Example[{Messages, "InvalidPlateSample", "Throws an error not all contents on prepared plate are not input samples:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "PreparedPlate Drop Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Reservoir Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				PreparedPlate -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidPlateSample,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidPlateSample", "Throws an error if CrystallizationPlate is not empty:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> False,
				CrystallizationPlate -> Object[Container, Plate, Irregular, Crystallization, "CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]
			],
			$Failed,
			Messages :> {
				Error::InvalidPlateSample,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidPreparedPlateModel", "Throws an error if the container model of prepared plate is not a crystallization plate:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidPreparedPlateModel,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidPreparedPlateVolume", "Throws an error if any samples from a prepared plate is not within the volume range of the container:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidPreparedPlateVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConflictingCrystallizationPlateWithTechnique", "Throws an error if specified CrystallizationTechnique is not compatible with specified CrystallizationPlate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"],
				OilVolume -> 5 Microliter,
				CrystallizationTechnique -> MicrobatchUnderOil
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrystallizationPlateWithTechnique,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingReservoirDispenserWithTechnique", "Throws an error if specified CrystallizationTechnique and specified ReservoirDispensingInstrument do not match:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> MicrobatchUnderOil,
				ReservoirDispensingInstrument -> Model[Instrument, LiquidHandler, "Super STAR"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingReservoirDispenserWithTechnique,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrystallizationTechniqueWithPreparation", "Throws an error if specified CrystallizationTechnique and specified sample preparation options do not match:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> MicrobatchWithoutOil,
				ReservoirBufferVolume -> 200 Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrystallizationTechniqueWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDropSetterWithStrategy", "Throws an error if DropSetterInstrument is specified does not match with specified CrystallizationStrategy:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DropSetterInstrument -> Model[Instrument, LiquidHandler, "Super STAR"],
				CrystallizationStrategy -> Screening
			],
			$Failed,
			Messages :> {
				Error::ConflictingDropSetterWithStrategy,
				Warning::RiskOfEvaporation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDropSetterWithReservoirDispenser", "Throws an error if DropSetterInstrument and ReservoirDispensingInstrument are specified as different robotic LiquidHandler:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DropSetterInstrument -> Model[Instrument, LiquidHandler, "Super STAR"],
				ReservoirDispensingInstrument -> Model[Instrument, LiquidHandler, "Hamilton STARlet"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingDropSetterWithReservoirDispenser,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUVImaging", "Throws an error if Imager is not capable of UVImaging when UVImaging is specified as True:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				UVImaging -> True,
				ImagingInstrument -> Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Output -> Options
			],
			_,
			Messages :> {
				Error::ConflictingUVImaging,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrossPolarizedImaging", "Throws an error if Imager is not capable of ConflictingCrossPolarizedImaging when ConflictingCrossPolarizedImaging is specified as True:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrossPolarizedImaging -> True,
				ImagingInstrument -> Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Output -> Options
			],
			_,
			Messages :> {
				Error::ConflictingCrossPolarizedImaging,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUVImaging", "Throws an error if CrystallizationCover is not transparent for UV:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				UVImaging -> True,
				CrystallizationCover -> Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingUVImaging,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingVisibleLightImaging", "Throws an error if CrystallizationCover is not opaque:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				UVImaging -> False,
				CrystallizationCover -> Model[Item, PlateSeal, "Aluminum Plate Seal for Hamilton"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingVisibleLightImaging,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrystallizationCoverWithContainer", "Throws an error if CrystallizationCover is not the same FootPrint as the CrystallizationPlate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
				CrystallizationCover -> Model[Item, PlateSeal, "DSC Plate Seal, 96-Well Round Pierceable"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrystallizationCoverWithContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidInstrumentModels", "Throws an error if specified DropSetterInstrument can not handle liquid:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				DropSetterInstrument -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"]
			],
			$Failed,
			Messages :> {
				Error::InvalidInstrumentModels,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidInstrumentModels", "Throws an error if specified ReservoirDispensingInstrument can not handle liquid:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirDispensingInstrument -> Model[Instrument, LiquidHandler, "GX-271 for Solid Phase Synthesis"]
			],
			$Failed,
			Messages :> {
				Error::InvalidInstrumentModels,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateWithInstrument", "Throws an error if DropSetterInstrument is specified for PreparedPlate:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				DropSetterInstrument -> Model[Instrument,LiquidHandler,"Super STAR"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateWithInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateWithPreparation", "Throws an error if any of sample preparation related options other than SampleVolumes is specified for PreparedPlate:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateWithPreparation", "Throws an error if SampleVolumes is not specified when PreparedPlate is set to False:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> False,
				SampleVolumes -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateWithCrystallizationPlate", "Throws an error if CrystallizationPlate is not the same container of input when PreparedPlate is True:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				CrystallizationPlate -> Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateWithCrystallizationPlate,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrystallizationPlateWithInstrument", "Throws an error if CrystallizationPlate is taller than MaxPlateHeight of DropSetterInstrument:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DropSetterInstrument -> Model[Instrument, LiquidHandler, AcousticLiquidHandler, "Labcyte Echo 650"],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrystallizationPlateWithInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrystallizationPlateWithInstrument", "Throws an error if CrystallizationPlate is bigger than MaxPlateDimensions of crystal incubator:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
				PreMixBuffer -> False
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrystallizationPlateWithInstrument,
				Warning::DropSamplePreMixed,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationAirDryTemperature has value but CoCrystallizationAirDry is all False:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagents -> {
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					}
				},
				CoCrystallizationAirDry -> False,
				CoCrystallizationAirDryTemperature -> Ambient
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationAirDryTime has value while CoCrystallizationAirDry is specified as False:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagents -> {
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					}
				},
				CoCrystallizationAirDry -> False,
				CoCrystallizationAirDryTime -> 1 Hour
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationAirDryTime has value while no CoCrystallizationReagents is specified:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationStrategy -> Preparation,
				CoCrystallizationReagents -> None,
				CoCrystallizationAirDry -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationAirDryTime is longer than an hour but CoCrystallizationAirDryTemperature is set at high temperature:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagents -> {
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					{
						Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
					}
				},
				CoCrystallizationAirDry -> {True, False},
				CoCrystallizationAirDryTime -> 4 Hour,
				CoCrystallizationAirDryTemperature -> 60 Celsius
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Warning::CoCrystallizationReagentsAliquotedBeforeAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationAirDryTemperature is higher than MaxTemperature of CrystallizationPlate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Preparation,
				CoCrystallizationReagents -> {Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				CoCrystallizationReagentVolume -> 1 Microliter,
				CoCrystallizationAirDry -> True,
				CoCrystallizationAirDryTime -> 4 Hour,
				CoCrystallizationAirDryTemperature -> 90 Celsius
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationAirDry", "Throws an error if CoCrystallizationReagentVolume is not in the same transfer model when air dry:"},
			ExperimentGrowCrystal[
				{
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CrystallizationStrategy -> Optimization,
				CoCrystallizationReagents -> {Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				CoCrystallizationReagentVolume -> {5 Microliter, 200 Nanoliter},
				CoCrystallizationAirDry -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationAirDry,
				Warning::CoCrystallizationReagentsAliquotedBeforeAirDry,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCoCrystallizationReagents", "Throws an error if CoCrystallizationReagentVolume is more than the MaxVolume of the plate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				CrystallizationStrategy -> Screening,
				CoCrystallizationReagents -> {Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				CoCrystallizationReagentVolume -> 2 Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingCoCrystallizationReagents,
				Error::ConflictingTotalDropVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDilutionBuffer", "Throws an error if DilutionBuffer is None while DilutionBufferVolume is specified:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DilutionBuffer -> None,
				DilutionBufferVolume -> 200 Nanoliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingDilutionBuffer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSeedingSolution", "Throws an error if SeedingSolution is None while SeedingSolutionVolume is specified:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SeedingSolution -> None,
				SeedingSolutionVolume -> 200 Nanoliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingSeedingSolution,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingOilOption", "Throws an error if Oil is Null while OilVolume is specified:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Oil -> Model[Sample, "Mineral Oil"],
				OilVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingOilOption,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingOilOption", "Throws an error if OilVolume is not 3 times larger than the total aqueous drop sample:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Oil -> Model[Sample, "Mineral Oil"],
				CrystallizationStrategy -> Optimization,
				SampleVolumes -> {3 Microliter},
				ReservoirDropVolume -> 2 Microliter,
				OilVolume -> 10 Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingOilOption,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreMixBuffer", "Throws an error if PreMixBuffer is not Null but PreparedPlate is True:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				PreMixBuffer -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreMixBuffer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreMixBuffer", "Throws an error if PreMixBuffer is False but PreMix with Sample is required:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Optimization,
				CoCrystallizationReagents -> {
					Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				CoCrystallizationReagentVolume -> 200 Nanoliter,
				CoCrystallizationAirDry -> False,
				ReservoirDropVolume -> 600 Nanoliter,
				PreparedPlate -> False,
				PreMixBuffer -> False
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreMixBuffer,
				Warning::DropSamplePreMixed,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingScreeningMethodWithBuffers", "Throws an error if specified CrystallizationScreeningMethod is not the same as specified buffer options:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::ConflictingScreeningMethodWithBuffers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingScreeningMethodWithStrategy", "Throws an error if specified CrystallizationScreeningMethod is not compatible with specified CrystallizationStrategy:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationStrategy -> Preparation
			],
			$Failed,
			Messages :> {
				Error::ConflictingScreeningMethodWithStrategy,
				Warning::DropSamplePreMixed,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSampleVolumes", "Throws an error if SampleVolumes is outside of the volume range:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 MRC 2 Drop Plate"],
				SampleVolumes -> {800 Nanoliter, 1200 Nanoliter}
			],
			$Failed,
			Messages :> {
				Error::ConflictingSampleVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDropVolume", "Throws an error if total drop volume exceeds the MaxVolume of the plate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				SampleVolumes -> {800 Nanoliter},
				ReservoirDropVolume -> 250 Nanoliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingTotalDropVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingReservoirOptions", "Throws an error if specified ReservoirBuffers is None while specified ReservoirDropVolume is not Null:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> None,
				ReservoirBufferVolume -> 1 Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingReservoirOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingReservoirOptions", "Throws an error if specified ReservoirBufferVolume exceeds the MaxVolume of reservoir well:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				ReservoirBufferVolume -> 250 Microliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingReservoirOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSamplesOutLabel", "Throws an error if specified DropSamplesOutLabel exceeds the number of DropSamplesOut:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				DropSamplesOutLabel -> {"Too many label1", "Too many label2"}
			],
			$Failed,
			Messages :> {
				Error::ConflictingSamplesOutLabel,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSamplesOutLabel", "Throws an error if specified DropSamplesOutLabel is Null for an unprepared plate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				DropSamplesOutLabel -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingSamplesOutLabel,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSamplesOutLabel", "Throws an error if ReservoirSamplesOutLabel has been specified but CrystallizationTechnique is Microbatch:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> MicrobatchWithoutOil,
				ReservoirSamplesOutLabel -> {"my imaginary reservoir sample"}
			],
			$Failed,
			Messages :> {
				Error::ConflictingSamplesOutLabel,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedBuffers", "Throws an error if specified Buffers for the ReservoirBuffers are duplicated:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {
					Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedBuffers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedBuffers", "Throws an error if specified Buffers for the ReservoirBuffers and DilutionBuffer are duplicated:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				DilutionBuffer -> Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::DuplicatedBuffers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiscardedBuffers", "Throws an error if specified Buffer has been discarded:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Object[Sample, "Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::DiscardedBuffers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DeprecatedBufferModels", "Throws an error if the model of specified Buffer has been deprecated:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Model[Sample, "Test Deprecated Reservoir Buffer Model for ExperimentGrowCrystal Testing" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::DeprecatedBufferModels,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NonLiquidBuffer", "Throws an error if specified Buffer is not liquid:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ReservoirBuffers -> {Model[Sample, "Solid sample model for ExperimentGrowCrystal Testing" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::NonLiquidBuffers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDropDestination", "Throws an error if specified DropDestination is not found on the plate:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {200 Nanoliter, 250 Nanoliter, 300 Nanoliter},
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				DropDestination -> {Drop2, Drop3, Drop4}
			],
			$Failed,
			Messages :> {
				Error::ConflictingDropDestination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDropDestination", "Throws an error if specified DropDestination mismatched the number of crystallization conditions:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {200 Nanoliter, 250 Nanoliter, 300 Nanoliter},
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "96 Intelli 3 Drop Plate"],
				ReservoirBuffers -> {Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				DropDestination -> {Drop2, Drop3}
			],
			$Failed,
			Messages :> {
				Error::ConflictingDropDestination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "GrowCrystalTooManyConditions", "Throws an error if specified combination of SamplesOut exceeds the number of wells:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> Range[100 Nanoliter, 700 Nanoliter, 10 Nanoliter],
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "id:E8zoYvzbBO1w"],
				ReservoirBuffers -> {
					Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]
				},
				ReservoirDropVolume -> 200 Nanoliter
			],
			$Failed,
			Messages :> {
				Error::GrowCrystalTooManyConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RiskOfEvaporation", "Throws a warning if transfers for SetDrop step if more than 5 minutes on Echo:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				SampleVolumes -> {60 Nanoliter, 80 Nanoliter, 100 Nanoliter, 120 Nanoliter},
				ReservoirDropVolume -> 60 Nanoliter,
				CrystallizationPlate -> Model[Container, Plate, Irregular, Crystallization, "MiTeGen 4 Drop Plate"],
				CrystallizationTechnique -> SittingDropVaporDiffusion,
				PreMixBuffer -> False,
				Output -> Options
			],
			_List,
			Messages :> {
				Warning::RiskOfEvaporation,
				Warning::DropSampleAliquoted
			}
		],
		Example[{Messages, "CoCrystallizationReagentsAliquotedBeforeAirDry", "Throws a warning if CoCrystallizationReagents that need to be air dried have been aliquoted:"},
			ExperimentGrowCrystal[
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CoCrystallizationAirDry -> True,
				CoCrystallizationReagents -> {Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
				CoCrystallizationReagentVolume -> 500 Nanoliter,
				Output -> Options
			],
			_List,
			Messages :> {Warning::CoCrystallizationReagentsAliquotedBeforeAirDry}
		],
		Example[{Messages, "AliquotRequired", "Throws a warning if input sample requires aliquoting:"},
			ExperimentGrowCrystal[
				Object[Sample, "Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"],
				SampleVolumes-> {1 Microliter}
			],
			ObjectP[Object[Protocol, GrowCrystal]],
			Messages :> {
				Warning::AliquotRequired,
				Warning::SampleMustBeMoved,
				Warning::TotalAliquotVolumeTooLarge,
				Warning::InsufficientVolume
			}
		],
		Example[{Messages, "GrowCrystalPreparationNotSupported", "Don't allow sample preparation for the time being:"},
			Block[{$GrowCrystalPreparedOnly = True},
				ExperimentGrowCrystal[
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					PreparedPlate -> False
				]
			],
			$Failed,
			Messages :> {
				Error::GrowCrystalPreparationNotSupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoAvailableStoragePosition", "If there is no available storage slot, return a warning message:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				ImagingInstrument -> Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GrowCrystal]],
			Messages :> {Warning::NoAvailableStoragePosition},
			Stubs :> {Experiment`Private`allActiveInstrumentPacketsCache[_]:={
				<|Model -> Link[Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID], Objects], Object -> Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID], ID -> "id:12345678", Type -> Object[Instrument, CrystalIncubator]|>,
				<|Model -> Link[Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"], Objects], Object -> Object[Instrument, CrystalIncubator, "Black Adam"], ID -> "id:Y0lXejMXEEdm", Type -> Object[Instrument, CrystalIncubator]|>,
				<|Model -> Link[Model[Instrument, CrystalIncubator, "Formulatrix Rock Imager"], Objects], Object -> Object[Instrument, CrystalIncubator, "Wonder Woman"], ID -> "id:rea9jlaDeo73", Type -> Object[Instrument, CrystalIncubator]|>
				}
			}
		],
		(* ===ADDITIONAL=== *)
		Example[{Additional, "Accepts solid drop sample in a prepared crystallization plate as input:"},
			ExperimentGrowCrystal[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID],
				PreparedPlate -> True,
				MaxCrystallizationTime -> 0 Day,
				UVImaging -> False,
				CrossPolarizedImaging -> True
			],
			ObjectP[Object[Protocol, GrowCrystal]]
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the tests for preparing CrystallizationPlate to still pass even if we're not yet supporting in lab *)
		$GrowCrystalPreparedOnly = False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				(*Models*)
				Model[Molecule, Oligomer, "Test DNA model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test DNA oligomer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 10mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 10mg/ml Lysozyme sample in Freezer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 8mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "Test lysozyme antibody for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Acetate in refrigerator for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Deprecated Reservoir Buffer Model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Urea for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Antibody sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Solid sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
				(*Objects*)
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Reservoir Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Reservoir Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Sample 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 7 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 8 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 9 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 10 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 11 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CrystallizationPlate Sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Solid Sample in PreparedPlate" <> $SessionUUID],
				Object[Sample, "Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 3 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Containers*)
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for small molecule for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Covers*)
				Object[Item, PlateSeal, "PlateSeal 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Container*)
				Object[Container, Bench, "Test bench for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Instrument*)
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[
			{
				allObjects, testBench, allContainers, testPlate1, testPlate2, testPlate3, testDNAmodel, testCover1, testCover2,
				testCover3, testCover4, testCover5, testDNAsampleModel, allInputs, allSolutionsInEchoPlate, allPreparedSamples,
				testProtein1SampleModel, testProtein2SampleModel,testProtein3SampleModel, testAbSampleModel, testAbModel, testSolidSampleModel,
				testRBmodel1, testRBmodel2, testRBmodel3, testRBmodel4, testRBmodel5, testADmodel1, testADmodel2, testADmodel3,
				testCCAmodel1, testCCAmodel2, allBuffers, testMethod1, testMethod2, testMethod3, testCrystalIncubatorModel1,
				testCrystalIncubatorModel2, testCrystalIncubatorModel3, testCrystalIncubator, testCrystalIncubator2, testCrystalIncubator3
			},
			allObjects = {
				(*Models*)
				Model[Molecule, Oligomer, "Test DNA model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test DNA oligomer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 10mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 10mg/ml Lysozyme sample in Freezer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test 8mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "Test lysozyme antibody for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Reservoir Buffer Ammonium Acetate in refrigerator for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Deprecated Reservoir Buffer Model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Urea for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Antibody sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Sample, "Solid sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
				(*Objects*)
				Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Reservoir Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Reservoir Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Sample 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 7 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 8 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 9 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 10 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "PreparedPlate Drop Sample 11 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CrystallizationPlate Sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Solid Sample in PreparedPlate" <> $SessionUUID],
				Object[Sample, "Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Additive 3 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Sample, "Sample for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Method, CrystallizationScreening, "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Containers*)
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for small molecule for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Covers*)
				Object[Item, PlateSeal, "PlateSeal 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				Object[Item, PlateSeal, "PlateSeal 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Container*)
				Object[Container, Bench, "Test bench for ExperimentGrowCrystal Testing" <> $SessionUUID],
				(*Instrument*)
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
				Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID]
			};
			Block[{$AllowPublicObjects = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				allContainers = UploadSample[
					{
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
						Model[Container, Plate, Irregular, Crystallization, "96 MRC Under Oil Plate"],
						Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
						Model[Container, Vessel, "0.15ml Blue Strip PCR Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
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
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for small molecule for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Oil for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Container for Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Tube for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allContainers;

				testPlate1 = Upload[<|
					Type -> Model[Container, Plate, Irregular, Crystallization],
					Name -> "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID,
					Replace[Synonyms] -> {"Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID},
					Opaque -> False,
					SelfStanding -> True,
					Treatment -> NonTreated,
					MinTemperature -> Quantity[-20., "DegreesCelsius"],
					MaxTemperature -> Quantity[65., "DegreesCelsius"],
					MinVolume -> 50 Microliter,
					MaxVolume -> 200 Microliter,
					Dimensions -> {127.5 Millimeter, 85.3 Millimeter, 14.4 Millimeter},
					CrossSectionalShape -> Rectangle,
					Footprint -> Plate,
					Replace[Positions] -> {
						<|Name -> "A1Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A1Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>,
						<|Name -> "A2Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A2Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1Drop1", XOffset -> Quantity[14.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A1Reservoir", XOffset -> Quantity[22.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>,
						<|Name -> "A2Drop1", XOffset -> Quantity[32.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A2Reservoir", XOffset -> Quantity[40.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>
					},
					Reusability -> False,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place},
					(*Plate*)
					PlateColor -> Clear,
					WellColor -> Clear,
					WellDiameter -> 6 Millimeter,
					HorizontalMargin -> 11.2 Millimeter,
					VerticalMargin -> 8.15 Millimeter,
					DepthMargin -> 11.8 Millimeter,
					HorizontalPitch -> 18 Millimeter,
					VerticalPitch -> 9 Millimeter,
					HorizontalOffset -> Quantity[0., "Millimeters"],
					VerticalOffset -> Quantity[0., "Millimeters"],
					WellBottomThickness -> 0.8 Millimeter,
					VerifiedContainerModel -> True,
					AspectRatio -> 4,
					Columns -> 4,
					Rows -> 1,
					NumberOfWells -> 4,
					RecommendedFillVolume -> Quantity[100., "Microliters"],
					WellBottom -> RoundBottom,
					WellDepth -> 1.8 Millimeter,
					FlangeWidth -> 1.8 Millimeter,
					FlangeHeight -> 4.2 Millimeter,
					(*irregular*)
					Replace[RecommendedFillVolumes] -> {Quantity[5, "Microliters"], Quantity[100, "Microliters"], Quantity[5, "Microliters"], Quantity[100, "Microliters"]},
					Replace[WellTreatments] -> ConstantArray[NonTreated, 4],
					Replace[WellPositionDimensions] -> {
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]},
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]}
					},
					Replace[WellDiameters] -> {Quantity[6, "Millimeters"], Null, Quantity[6, "Millimeters"], Null},
					Replace[ConicalWellDepths] -> {Quantity[1.2, "Millimeters"], Null, Quantity[1.2, "Millimeters"], Null},
					Replace[MaxVolumes] -> {Quantity[10, "Microliters"], Quantity[200, "Microliters"], Quantity[10, "Microliters"], Quantity[200, "Microliters"]},
					Replace[MinVolumes] -> {Quantity[1, "Microliters"], Quantity[50, "Microliters"], Quantity[1, "Microliters"], Quantity[50, "Microliters"]},
					Replace[WellBottoms] -> {RoundBottom, FlatBottom, RoundBottom, FlatBottom},
					Replace[WellColors] -> ConstantArray[Clear, 4],
					Replace[WellDepths] -> {Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"], Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"]},
					(*special*)
					LabeledRows -> 1,
					LabeledColumns -> 2,
					Replace[CompatibleCrystallizationTechniques] -> {SittingDropVaporDiffusion, MicrobatchWithoutOil},
					HighPrecisionPositionRequired -> True,
					LiquidHandlerPrefix -> "Test_ExperimentGrowCrystal",
					VerifiedFormulatrixContainerModel -> True,
					Replace[MaxViewingAngles] -> {118, 36, 118, 36},
					Replace[CoveredVolumes] -> ConstantArray[215 Microliter, 4],
					MaxTransparentWavelength -> 750 Nanometer,
					MinTransparentWavelength -> 240 Nanometer,
					Replace[HeadspaceSharingWells] -> {{"A1Reservoir", "A1Drop1"}, {"A2Reservoir", "A2Drop1"}},
					Replace[WellContents] -> {Drop1, Reservoir, Drop1, Reservoir},
					Replace[WellPositionBottomThickness] -> ConstantArray[0.8 Millimeter, 4],
					DeveloperObject -> True
				|>];

				testPlate2 = Upload[<|
					Type -> Model[Container, Plate, Irregular, Crystallization],
					Name -> "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID,
					Replace[Synonyms] -> {"Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID},
					Opaque -> False,
					SelfStanding -> True,
					Treatment -> NonTreated,
					MinTemperature -> Quantity[-20., "DegreesCelsius"],
					MaxTemperature -> Quantity[65., "DegreesCelsius"],
					MinVolume -> 50 Microliter,
					MaxVolume -> 200 Microliter,
					Dimensions -> {127.5 Millimeter, 85.3 Millimeter, 17 Millimeter},
					CrossSectionalShape -> Rectangle,
					Footprint -> Plate,
					Replace[Positions] -> {
						<|Name -> "A1Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A1Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>,
						<|Name -> "A2Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A2Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1Drop1", XOffset -> Quantity[14.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A1Reservoir", XOffset -> Quantity[22.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>,
						<|Name -> "A2Drop1", XOffset -> Quantity[32.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A2Reservoir", XOffset -> Quantity[40.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>
					},
					Reusability -> False,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place},
					(*Plate*)
					PlateColor -> Clear,
					WellColor -> Clear,
					WellDiameter -> 6 Millimeter,
					HorizontalMargin -> 11.2 Millimeter,
					VerticalMargin -> 8.15 Millimeter,
					DepthMargin -> 11.8 Millimeter,
					HorizontalPitch -> 18 Millimeter,
					VerticalPitch -> 9 Millimeter,
					HorizontalOffset -> Quantity[0., "Millimeters"],
					VerticalOffset -> Quantity[0., "Millimeters"],
					WellBottomThickness -> 0.8 Millimeter,
					VerifiedContainerModel -> True,
					AspectRatio -> 4,
					Columns -> 4,
					Rows -> 1,
					NumberOfWells -> 4,
					RecommendedFillVolume -> Quantity[100., "Microliters"],
					WellBottom -> RoundBottom,
					WellDepth -> 1.8 Millimeter,
					FlangeWidth -> 1.8 Millimeter,
					FlangeHeight -> 4.2 Millimeter,
					(*irregular*)
					Replace[RecommendedFillVolumes] -> {Quantity[5, "Microliters"], Quantity[100, "Microliters"], Quantity[5, "Microliters"], Quantity[100, "Microliters"]},
					Replace[WellTreatments] -> ConstantArray[NonTreated, 4],
					Replace[WellPositionDimensions] -> {
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]},
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]}
					},
					Replace[WellDiameters] -> {Quantity[6, "Millimeters"], Null, Quantity[6, "Millimeters"], Null},
					Replace[ConicalWellDepths] -> {Quantity[1.2, "Millimeters"], Null, Quantity[1.2, "Millimeters"], Null},
					Replace[MaxVolumes] -> {Quantity[10, "Microliters"], Quantity[200, "Microliters"], Quantity[10, "Microliters"], Quantity[200, "Microliters"]},
					Replace[MinVolumes] -> {Quantity[1, "Microliters"], Quantity[50, "Microliters"], Quantity[1, "Microliters"], Quantity[50, "Microliters"]},
					Replace[WellBottoms] -> {RoundBottom, FlatBottom, RoundBottom, FlatBottom},
					Replace[WellColors] -> ConstantArray[Clear, 4],
					Replace[WellDepths] -> {Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"], Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"]},
					(*special*)
					LabeledRows -> 1,
					LabeledColumns -> 2,
					Replace[CompatibleCrystallizationTechniques] -> {SittingDropVaporDiffusion, MicrobatchWithoutOil},
					HighPrecisionPositionRequired -> True,
					LiquidHandlerPrefix -> "Test_ExperimentGrowCrystal",
					VerifiedFormulatrixContainerModel -> True,
					Replace[MaxViewingAngles] -> {118, 36, 118, 36},
					Replace[CoveredVolumes] -> ConstantArray[215 Microliter, 4],
					MaxTransparentWavelength -> 750 Nanometer,
					MinTransparentWavelength -> 240 Nanometer,
					Replace[HeadspaceSharingWells] -> {{"A1Reservoir", "A1Drop1"}, {"A2Reservoir", "A2Drop1"}},
					Replace[WellContents] -> {Drop1, Reservoir, Drop1, Reservoir},
					Replace[WellPositionBottomThickness] -> ConstantArray[0.8 Millimeter, 4],
					DeveloperObject -> True
				|>];

				testPlate3 = Upload[<|
					Type -> Model[Container, Plate, Irregular, Crystallization],
					Name -> "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID,
					Replace[Synonyms] -> {"Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID},
					Opaque -> False,
					SelfStanding -> True,
					Treatment -> NonTreated,
					MinTemperature -> Quantity[-20., "DegreesCelsius"],
					MaxTemperature -> Quantity[65., "DegreesCelsius"],
					MinVolume -> 50 Microliter,
					MaxVolume -> 200 Microliter,
					Dimensions -> {132 Millimeter, 85.3 Millimeter, 14.4 Millimeter},
					CrossSectionalShape -> Rectangle,
					Footprint -> Plate,
					Replace[Positions] -> {
						<|Name -> "A1Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A1Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>,
						<|Name -> "A2Drop1", Footprint -> Null, MaxWidth -> Quantity[6, "Millimeters"], MaxDepth -> Quantity[6, "Millimeters"], MaxHeight -> Quantity[1.8, "Millimeters"]|>,
						<|Name -> "A2Reservoir", Footprint -> Null, MaxWidth -> Quantity[8.1, "Millimeters"], MaxDepth -> Quantity[6.6, "Millimeters"], MaxHeight -> Quantity[10, "Millimeters"]|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1Drop1", XOffset -> Quantity[14.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A1Reservoir", XOffset -> Quantity[22.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>,
						<|Name -> "A2Drop1", XOffset -> Quantity[32.2, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[12.6, "Millimeters"], CrossSectionalShape -> Circle, Rotation -> 0|>,
						<|Name -> "A2Reservoir", XOffset -> Quantity[40.55, "Millimeters"], YOffset -> Quantity[74.15, "Millimeters"], ZOffset -> Quantity[4.4, "Millimeters"], CrossSectionalShape -> Rectangle, Rotation -> 0|>
					},
					Reusability -> False,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place},
					(*Plate*)
					PlateColor -> Clear,
					WellColor -> Clear,
					WellDiameter -> 6 Millimeter,
					HorizontalMargin -> 11.2 Millimeter,
					VerticalMargin -> 8.15 Millimeter,
					DepthMargin -> 11.8 Millimeter,
					HorizontalPitch -> 18 Millimeter,
					VerticalPitch -> 9 Millimeter,
					HorizontalOffset -> Quantity[0., "Millimeters"],
					VerticalOffset -> Quantity[0., "Millimeters"],
					WellBottomThickness -> 0.8 Millimeter,
					VerifiedContainerModel -> True,
					AspectRatio -> 4,
					Columns -> 4,
					Rows -> 1,
					NumberOfWells -> 4,
					RecommendedFillVolume -> Quantity[100., "Microliters"],
					WellBottom -> RoundBottom,
					WellDepth -> 1.8 Millimeter,
					FlangeWidth -> 1.8 Millimeter,
					FlangeHeight -> 4.2 Millimeter,
					(*irregular*)
					Replace[RecommendedFillVolumes] -> {Quantity[5, "Microliters"], Quantity[100, "Microliters"], Quantity[5, "Microliters"], Quantity[100, "Microliters"]},
					Replace[WellTreatments] -> ConstantArray[NonTreated, 4],
					Replace[WellPositionDimensions] -> {
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]},
						{Quantity[6, "Millimeters"], Quantity[6, "Millimeters"]},
						{Quantity[8.1, "Millimeters"], Quantity[6.6, "Millimeters"]}
					},
					Replace[WellDiameters] -> {Quantity[6, "Millimeters"], Null, Quantity[6, "Millimeters"], Null},
					Replace[ConicalWellDepths] -> {Quantity[1.2, "Millimeters"], Null, Quantity[1.2, "Millimeters"], Null},
					Replace[MaxVolumes] -> {Quantity[10, "Microliters"], Quantity[200, "Microliters"], Quantity[10, "Microliters"], Quantity[200, "Microliters"]},
					Replace[MinVolumes] -> {Quantity[1, "Microliters"], Quantity[50, "Microliters"], Quantity[1, "Microliters"], Quantity[50, "Microliters"]},
					Replace[WellBottoms] -> {RoundBottom, FlatBottom, RoundBottom, FlatBottom},
					Replace[WellColors] -> ConstantArray[Clear, 4],
					Replace[WellDepths] -> {Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"], Quantity[1.8, "Millimeters"], Quantity[10, "Millimeters"]},
					(*special*)
					LabeledRows -> 1,
					LabeledColumns -> 2,
					Replace[CompatibleCrystallizationTechniques] -> {SittingDropVaporDiffusion, MicrobatchWithoutOil},
					HighPrecisionPositionRequired -> True,
					LiquidHandlerPrefix -> "Test_ExperimentGrowCrystal",
					VerifiedFormulatrixContainerModel -> True,
					Replace[MaxViewingAngles] -> {118, 36, 118, 36},
					Replace[CoveredVolumes] -> ConstantArray[215 Microliter, 4],
					MaxTransparentWavelength -> 750 Nanometer,
					MinTransparentWavelength -> 240 Nanometer,
					Replace[HeadspaceSharingWells] -> {{"A1Reservoir", "A1Drop1"}, {"A2Reservoir", "A2Drop1"}},
					Replace[WellContents] -> {Drop1, Reservoir, Drop1, Reservoir},
					Replace[WellPositionBottomThickness] -> ConstantArray[0.8 Millimeter, 4],
					DeveloperObject -> True
				|>];

				(*Create plate seal objects*)
				testCover1 = Upload[<|
					Type -> Object[Item, PlateSeal],
					Model -> Link[Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"], Objects],
					Name -> "PlateSeal 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				testCover2 = Upload[<|
					Type -> Object[Item, PlateSeal],
					Model -> Link[Model[Item, PlateSeal, "Crystal Clear Sealing Film"], Objects],
					Name -> "PlateSeal 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				testCover3 = Upload[<|
					Type -> Object[Item, PlateSeal],
					Model -> Link[Model[Item, PlateSeal, "Crystal Clear Sealing Film"], Objects],
					Name -> "PlateSeal 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				testCover4 = Upload[<|
					Type -> Object[Item, PlateSeal],
					Model -> Link[Model[Item, PlateSeal, "Crystal Clear Sealing Film"], Objects],
					Name -> "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				testCover5 = Upload[<|
					Type -> Object[Item, PlateSeal],
					Model -> Link[Model[Item, PlateSeal, "Crystal Clear Sealing Film"], Objects],
					Name -> "PlateSeal 5 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				(* Create test DNA Models *)
				testDNAmodel = UploadOligomer["Test DNA model for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Molecule -> Strand[DNA["AATTGTTCGGACACT"]],
					PolymerType -> DNA
				];
				Upload[<|Object -> testDNAmodel, DeveloperObject -> True|>];

				(* Create a Model[Sample] of DNA with Analytes *)
				testDNAsampleModel = UploadSampleModel[
					"Test DNA oligomer for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {{1 Millimolar, testDNAmodel}, {100 VolumePercent, Model[Molecule, "Water"]}},
					Solvent -> Model[Sample, "Milli-Q water"],
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> testDNAsampleModel, DeveloperObject -> True, Replace[Analytes] -> {Link[testDNAmodel]}|>];

				(* Create a Model[Sample] of Protein with Analytes *)
				testProtein1SampleModel = UploadSampleModel[
					"Test 10mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{10 Milligram/Milliliter, Model[Molecule, Protein, "Lysozyme from chicken egg white"]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					Solvent -> Model[Sample, "Milli-Q water"],
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> testProtein1SampleModel, DeveloperObject -> True, Replace[Analytes] -> {Link[Model[Molecule, Protein, "Lysozyme from chicken egg white"]]}|>];

				testProtein2SampleModel = UploadSampleModel[
					"Test 10mg/ml Lysozyme sample in Freezer for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{10 Milligram/Milliliter, Model[Molecule, Protein, "Lysozyme from chicken egg white"]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					Solvent -> Model[Sample, "Milli-Q water"],
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> testProtein2SampleModel, DeveloperObject -> True, Replace[Analytes] -> {Link[Model[Molecule, Protein, "Lysozyme from chicken egg white"]]}|>];


				(* Create a Model[Sample] of Protein without Analytes*)
				testProtein3SampleModel = UploadSampleModel[
					"Test 8mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{8 Milligram/Milliliter, Model[Molecule, Protein, "Lysozyme from chicken egg white"]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					Solvent -> Model[Sample, "Milli-Q water"],
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> testProtein3SampleModel, DeveloperObject -> True|>];

				(* Create sample model for for antibody sample (Antibody) *)
				testAbModel = UploadAntibody[
					"Test lysozyme antibody for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Targets -> {Model[Molecule, Protein, "Lysozyme from chicken egg white"]},
					Clonality -> Monoclonal,
					State -> Solid,
					Isotype -> IgG1,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					RecommendedDilution -> 0.01
				];
				Upload[<|Object -> testAbModel, DeveloperObject -> True|>];

				testAbSampleModel = UploadSampleModel[
					"Antibody sample model for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{0.01 Milligram/Milliliter, testAbModel},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					Solvent -> Model[Sample, "Milli-Q water"],
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				(* Create sample model for solid sample *)
				testSolidSampleModel = UploadSampleModel[
					"Solid sample model for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{100 MassPercent, testAbModel}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {testAbSampleModel, testAbModel, testSolidSampleModel};

				(* Create buffer Models *)
				testRBmodel1 = UploadSampleModel[
					"Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Sodium Acetate"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {CarbonSteel, Polyurethane, Silicone, Viton},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testRBmodel2 = UploadSampleModel[
					"Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Ammonium Chloride"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {Brass, Bronze, CarbonSteel, CastIron, Copper, Hastelloy},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testRBmodel3 = UploadSampleModel[
					"Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Ammonium Acetate"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {Brass, Bronze, Polyurethane},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testRBmodel4 = UploadSampleModel[
					"Test Reservoir Buffer Ammonium Acetate in refrigerator for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Ammonium Acetate"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {Brass, Bronze, Polyurethane},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testRBmodel5 = UploadSampleModel[
					"Test Deprecated Reservoir Buffer Model for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Ammonium Acetate"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {Brass, Bronze, Polyurethane},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];
				Upload[<|Object -> testRBmodel5, Deprecated -> True|>];

				testADmodel1 = UploadSampleModel[
					"Test Additive Urea for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{0.1 Molar, Model[Molecule, "Urea"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {2, 1, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {Polycarbonate, PVC},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testADmodel2 = UploadSampleModel[
					"Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{0.1 Molar, Model[Molecule, "Spermidine"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testADmodel3 = UploadSampleModel[
					"Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{1 Molar, Model[Molecule, "Spermidine"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testCCAmodel1 = UploadSampleModel[
					"Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{100 Milligram/Milliliter, Model[Molecule, Protein, "Lysozyme from chicken egg white"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				testCCAmodel2 = UploadSampleModel[
					"Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Composition -> {
						{2 Molar, Model[Molecule, Protein, "Ubiquitin"]},
						{100 MassPercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					Solvent -> {Model[Sample, "Milli-Q water"]},
					DefaultStorageCondition -> Model[StorageCondition, "Freezer"],
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1"
				];

				Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {testRBmodel1, testRBmodel2, testRBmodel3, testRBmodel4, testRBmodel5, testADmodel1, testADmodel2, testADmodel3, testCCAmodel1, testCCAmodel2};

				(* Create Input samples *)
				allInputs = UploadSample[
					{
						testProtein1SampleModel,
						Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
						testProtein3SampleModel,
						testAbSampleModel,
						Model[Sample, StockSolution, "480 mg/L Caffeine in 40% Methanol"],
						testDNAsampleModel,
						testSolidSampleModel,
						testProtein1SampleModel,
						testProtein2SampleModel,
						testRBmodel1,
						testRBmodel2,
						testRBmodel3,
						testRBmodel4,
						testRBmodel5,
						testADmodel1,
						testADmodel2,
						testADmodel3,
						testCCAmodel1,
						testCCAmodel2
					},
					{
						{"A1", Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for small molecule for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]}
					},
					InitialAmount -> Join[ConstantArray[1 Milliliter, 6], {100 Milligram}, {15 Microliter}, ConstantArray[30 Milliliter, 11]],
					Name -> {
						"Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Sample for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID
					}
				];

				(* Create buffers in Echo compatible container *)
				allSolutionsInEchoPlate = UploadSample[
					{
						testProtein2SampleModel,
						testADmodel1,
						testADmodel2,
						testADmodel3,
						testCCAmodel1,
						testCCAmodel2,
						testProtein2SampleModel
					},
					{
						{"A1", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A4", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A5", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A6", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"B1", Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID]}
					},
					InitialAmount -> ConstantArray[50 Microliter, 7],
					Name -> {
						"Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 3 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID
					}
				];

				(* Create Prepared Plates *)
				(* Make test sample objects *)
				allPreparedSamples = UploadSample[
					Join[
						{testProtein1SampleModel, testProtein3SampleModel, testRBmodel4, testRBmodel4, testRBmodel4},
						ConstantArray[testProtein1SampleModel, 9],
						{Model[Sample, "Sodium Chloride"]}
					],
					{
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Reservoir", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2Reservoir", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID]}
					},
					InitialAmount -> {
						8 Microliter,
						8 Microliter,
						100 Microliter,
						100 Microliter,
						8 Microliter,
						8 Microliter,
						8 Microliter,
						8 Microliter,
						8 Microliter,
						20 Microliter,
						20 Microliter,
						8 Microliter,
						8 Microliter,
						8 Microliter,
						1 Gram
					},
					Name -> {
						"PreparedPlate Drop Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Reservoir Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Reservoir Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CrystallizationPlate Sample for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Sample 4 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 5 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 6 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 7 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 8 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 9 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 10 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"PreparedPlate Drop Sample 11 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Solid Sample in PreparedPlate" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True|>]& /@ Join[allSolutionsInEchoPlate, allPreparedSamples];

				(* Add Cover field to PreparedPlate 2  *)
				UploadCover[
					Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Cover -> testCover2
				];

				(* Add Cover field to PreparedPlate 3  *)
				UploadCover[
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Cover -> testCover3
				];

				(* Add Cover field to PreparedPlate 5 *)
				UploadCover[
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Cover -> testCover1
				];

				(* Add Cover field to PreparedPlate 6 *)
				UploadCover[
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Cover -> testCover5
				];

				testMethod1 = Upload[<|
					Type -> Object[Method, CrystallizationScreening],
					Name -> "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Replace[ReservoirBuffers] -> {
						Link[testRBmodel1],
						Link[testRBmodel2],
						Link[testRBmodel3]
					},
					DeveloperObject -> True
				|>];

				testMethod2 = Upload[<|
					Type -> Object[Method, CrystallizationScreening],
					Name -> "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Replace[Additives] -> {
						Link[testADmodel2],
						Link[testADmodel3]
					},
					DeveloperObject -> True
				|>];

				testMethod3 = Upload[<|
					Type -> Object[Method, CrystallizationScreening],
					Name -> "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
					Replace[ReservoirBuffers] -> {
						Link[testRBmodel1],
						Link[testRBmodel2],
						Link[testRBmodel3]
					},
					Replace[Additives] -> {
						Link[testADmodel1],
						Link[testADmodel2],
						Link[testADmodel3]
					},
					DeveloperObject -> True
				|>];

				(* Create Sample Objects for buffers *)
				allBuffers = UploadSample[
					{
						Model[Sample, StockSolution, "100 mM Sodium Phosphate Buffer, 200 mM NaCl, pH 6.8"],
						Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test Additive Urea for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
						Model[Sample, StockSolution, "480 mg/L Caffeine in 40% Methanol"],
						Model[Sample, "Mineral Oil"],
						Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID]
					},
					{
						{"A1", Object[Container, Vessel, "Container for Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Plate, "Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Oil for ExperimentGrowCrystal Testing" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Container for Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID]}
					},
					InitialAmount -> ConstantArray[10 Milliliter, 12],
					Name -> {
						"Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Oil for ExperimentGrowCrystal Testing" <> $SessionUUID,
						"Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allBuffers;
				UploadSampleStatus[Object[Sample, "Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID], Discarded];

				(* Create new test instrument model *)
				testCrystalIncubatorModel1 = Upload[<|
					Type -> Model[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID,
					MinTemperature -> 3 Celsius,
					MaxTemperature -> 29 Celsius,
					Append[ImagingModes] -> {VisibleLightImaging, CrossPolarizedImaging},
					Append[MicroscopeModes] -> {BrightField, Polarized},
					MaxPlateDimensions -> {130 Millimeter, 86 Millimeter, 45 Millimeter},
					Capacity -> 1,
					Replace[Positions] -> <|Name -> "Plate Slot", Footprint -> Open, MaxWidth -> 0.2 Meter, MaxDepth -> 0.38 Meter, MaxHeight -> 0.6 Meter|>,
					Replace[PositionPlotting] -> <|Name -> "Plate Slot", XOffset -> 0.4 Meter, YOffset -> 0.2 Meter, ZOffset -> 1.48 Meter, CrossSectionalShape -> Rectangle, Rotation -> 0.`|>,
					DeveloperObject -> True
				|>];
				testCrystalIncubatorModel2 = Upload[<|
					Type -> Model[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID,
					MinTemperature -> 3 Celsius,
					MaxTemperature -> 29 Celsius,
					Append[ImagingModes] -> {VisibleLightImaging, UVImaging},
					Append[MicroscopeModes] -> {BrightField, Polarized},
					MaxPlateDimensions -> {130 Millimeter, 86 Millimeter, 45 Millimeter},
					Capacity -> 1,
					Replace[Positions] -> <|Name -> "Plate Slot", Footprint -> Open, MaxWidth -> 0.2 Meter, MaxDepth -> 0.38 Meter, MaxHeight -> 0.6 Meter|>,
					Replace[PositionPlotting] -> <|Name -> "Plate Slot", XOffset -> 0.4 Meter, YOffset -> 0.2 Meter, ZOffset -> 1.48 Meter, CrossSectionalShape -> Rectangle, Rotation -> 0.`|>,
					DeveloperObject -> True
				|>];
				testCrystalIncubatorModel3 = Upload[<|
					Type -> Model[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID,
					MinTemperature -> 3 Celsius,
					MaxTemperature -> 29 Celsius,
					Append[ImagingModes] -> {VisibleLightImaging, UVImaging},
					Append[MicroscopeModes] -> {BrightField, Polarized},
					MaxPlateDimensions -> {130 Millimeter, 86 Millimeter, 45 Millimeter},
					Capacity -> 1,
					Replace[Positions] -> <|Name -> "Plate Slot", Footprint -> Open, MaxWidth -> 0.2 Meter, MaxDepth -> 0.38 Meter, MaxHeight -> 0.6 Meter|>,
					Replace[PositionPlotting] -> <|Name -> "Plate Slot", XOffset -> 0.4 Meter, YOffset -> 0.2 Meter, ZOffset -> 1.48 Meter, CrossSectionalShape -> Rectangle, Rotation -> 0.`|>,
					DeveloperObject -> True
				|>];
				(* Create new test instruments *)
				testCrystalIncubator = Upload[<|
					Type -> Object[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID,
					Model -> Link[Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID], Objects],
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];
				testCrystalIncubator2 = Upload[<|
					Type -> Object[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator for ExperimentGrowCrystal Testing 2" <> $SessionUUID,
					Model -> Link[Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID], Objects],
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];
				testCrystalIncubator3 = Upload[<|
					Type -> Object[Instrument, CrystalIncubator],
					Name -> "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID,
					Model -> Link[Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID], Objects],
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];
				UploadLocation[Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID], {"Plate Slot", Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID]}];
      ]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					(*Models*)
					Model[Molecule, Oligomer, "Test DNA model for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test 10mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test 10mg/ml Lysozyme sample in Freezer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test 8mg/ml Lysozyme sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Molecule, Protein, Antibody, "Test lysozyme antibody for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Reservoir Buffer Sodium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Reservoir Buffer Ammonium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Reservoir Buffer Ammonium Acetate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Reservoir Buffer Ammonium Acetate in refrigerator for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Deprecated Reservoir Buffer Model for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Additive Urea for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Additive Spermidine for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test Additive Sodium Chloride for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test CoCrystallization Reagent1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Test CoCrystallization Reagent2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Antibody sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Sample, "Solid sample model for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
					Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
					Model[Container, Plate, Irregular, Crystallization, "Test Crystallization Plate Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
					(*Objects*)
					Object[Sample, "Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Small molecule sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Reservoir Sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Reservoir Sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Sample 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 7 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 8 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 9 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 10 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "PreparedPlate Drop Sample 11 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CrystallizationPlate Sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Solid Sample in PreparedPlate" <> $SessionUUID],
					Object[Sample, "Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 4 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Protein sample 5 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Additive 3 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 1 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "CoCrystallizationReagent 2 in SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Sample, "Sample for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Method, CrystallizationScreening, "Test ScreeningMethod 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Method, CrystallizationScreening, "Test ScreeningMethod 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Method, CrystallizationScreening, "Test ScreeningMethod 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					(*Containers*)
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, "PreparedPlate 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 6 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "CrystallizationPlate with Contents for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PreparedPlate with Solid Samples for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Protein sample 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Protein sample 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Antibody sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Solid sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for small molecule for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for DNA sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Seeding Solution for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Dilution Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, "Container for Reservoir Buffers for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, "Container for Additives for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, "Container for CoCrystallizationReagents for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Plate, "Container for SourcePlate for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Oil for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Discarded Reservoir Buffer for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Container for Aliquot sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Frozen protein sample for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Reservoir Buffer 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Additive 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Additive 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk Additive 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Container, Vessel, "Tube for Bulk CoCrystallizationReagent 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					(*Covers*)
					Object[Item, PlateSeal, "PlateSeal 1 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Item, PlateSeal, "PlateSeal 2 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Item, PlateSeal, "PlateSeal 3 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Item, PlateSeal, "PlateSeal 4 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					Object[Item, PlateSeal, "PlateSeal 5 for ExperimentGrowCrystal Testing" <> $SessionUUID],
					(*Container*)
					Object[Container, Bench, "Test bench for ExperimentGrowCrystal Testing" <> $SessionUUID],
					(*Instrument*)
					Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
					Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
					Model[Instrument, CrystalIncubator, "Test Crystal Incubator Model for ExperimentGrowCrystal Testing 3" <> $SessionUUID],
					Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 1" <> $SessionUUID],
					Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 2" <> $SessionUUID],
					Object[Instrument, CrystalIncubator, "Test Crystal Incubator for ExperimentGrowCrystal Testing 3" <> $SessionUUID]
					}
				}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentGrowCrystalQ*)


DefineTests[ValidExperimentGrowCrystalQ,
	{
		Example[{Basic, "Returns a Boolean indicating the validity of a GrowCrystal experimental setup on a sample:"},
			ValidExperimentGrowCrystalQ[
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a GrowCrystal experimental setup on multiple samples:"},
			ValidExperimentGrowCrystalQ[
				{
					Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID],
					Object[Sample, "ValidExperimentGrowCrystalQ test sample 2" <> $SessionUUID]
				},
				CrystallizationScreeningMethod -> Object[Method, CrystallizationScreening, "Hampton Research Crystal Screen Lite"]
			],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a GrowCrystal experimental setup on a prepared plate:"},
			ValidExperimentGrowCrystalQ[
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID]
			],
			True
		],
		Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentGrowCrystalQ[
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID],
				Verbose -> True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentGrowCrystalQ[
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},


	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the tests for preparing CrystallizationPlate to still pass even if we're not yet supporting in lab *)
		$GrowCrystalPreparedOnly = False
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 2 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 3 from PreparedPlate" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 4 from PreparedPlate" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench, allContainers, allInputs},
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 2 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 3 from PreparedPlate" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 4 from PreparedPlate" <> $SessionUUID]
			};

			(* Create Containers *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID,
				Transfer[Notebook] -> Null,
				DeveloperObject -> True,
				Site -> Link[$Site]
			|>];
			allContainers = UploadSample[
				{
					Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
					Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
					Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Container for Protein sample 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID,
					"Container for Protein sample 2 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID,
					"PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allContainers;

			(* Create Samples *)
			allInputs = UploadSample[
				{
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, StockSolution, "480 mg/L Caffeine in 40% Methanol"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"]
				},
				{
					{"A1", Object[Container, Vessel, "Container for Protein sample 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Container for Protein sample 2 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID]},
					{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID]},
					{"B1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID]}
				},
				InitialAmount -> {1 Milliliter, 1 Milliliter, 1 Microliter, 1 Microliter},
				Name -> {
					"ValidExperimentGrowCrystalQ test sample 1"<>$SessionUUID,
					"ValidExperimentGrowCrystalQ test sample 2"<>$SessionUUID,
					"ValidExperimentGrowCrystalQ test sample 3 from PreparedPlate"<>$SessionUUID,
					"ValidExperimentGrowCrystalQ test sample 4 from PreparedPlate"<>$SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allInputs;
		]
	),


	SymbolTearDown :> (
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 2 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for ValidExperimentGrowCrystalQ Testing" <> $SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 1"<>$SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 2"<>$SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 3 from PreparedPlate"<>$SessionUUID],
				Object[Sample, "ValidExperimentGrowCrystalQ test sample 4 from PreparedPlate"<>$SessionUUID]
			};

			(* Check whether the created objects and models exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase all the created objects and models *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*GrowCrystal*)
(* This is the unit test for the primitive heads *)

DefineTests[GrowCrystal,
	{
		Example[{Basic, "Returns sample preparation protocols or scripts to run a GrowCrystal experiment:"},
			ExperimentManualSamplePreparation[
				GrowCrystal[
					Sample -> Object[Sample, "GrowCrystal UO test sample 1" <> $SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Returns sample preparation protocols or scripts to run a GrowCrystal experiment for prepared plate:"},
			ExperimentManualSamplePreparation[
				GrowCrystal[
					Sample -> Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Can use Experiment for building the protocol from a set of primitives:"},
			ExperimentManualSamplePreparation[
				{
					LabelContainer[
						Label -> "my container",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "my container",
						Amount -> 10 Milliliter
					],
					GrowCrystal[
						Sample -> "my container"
					]
				}
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		]
	},


	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		(* want the tests for preparing CrystallizationPlate to still pass even if we're not yet supporting in lab *)
		$GrowCrystalPreparedOnly = False
	},


	SymbolSetUp :> (
		Module[{allObjects, existingObjects},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Container, Vessel,"Container for Protein sample 1 for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 1" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 2 from PreparedPlate" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 3 from PreparedPlate" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench, allContainers, allInputs},
			allObjects = {
				Object[Container, Bench, "Test bench for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 1" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 2 from PreparedPlate" <> $SessionUUID],
				Object[Sample, "GrowCrystal UO test sample 3 from PreparedPlate" <> $SessionUUID]
			};

			(* Create Containers *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for GrowCrystal UO Testing" <> $SessionUUID,
				DeveloperObject -> True,
				Site -> Link[$Site]
			|>];
			allContainers = UploadSample[
				{
					Model[Container, Vessel, "2-mL clear tube with blue screwcap"],
					Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Container for Protein sample 1 for GrowCrystal UO Testing" <> $SessionUUID,
					"PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allContainers;

			(* Create Samples *)
			allInputs = UploadSample[
				{
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"]
				},
				{
					{"A1", Object[Container, Vessel, "Container for Protein sample 1 for GrowCrystal UO Testing" <> $SessionUUID]},
					{"A1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID]},
					{"B1Drop1", Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID]}
				},
				InitialAmount -> {1 Milliliter, 1 Microliter, 1 Microliter},
				Name -> {
					"GrowCrystal UO test sample 1" <> $SessionUUID,
					"GrowCrystal UO test sample 2 from PreparedPlate" <> $SessionUUID,
					"GrowCrystal UO test sample 3 from PreparedPlate" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allInputs;
		]
	),


	SymbolTearDown :> (
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects =Cases[Flatten[
				{
					$CreatedObjects,
					{
						Object[Container, Bench, "Test bench for GrowCrystal UO Testing" <> $SessionUUID],
						Object[Container, Vessel,"Container for Protein sample 1 for GrowCrystal UO Testing" <> $SessionUUID],
						Object[Container, Plate, Irregular, Crystallization, "PreparedPlate 1 for GrowCrystal UO Testing" <> $SessionUUID],
						Object[Sample, "GrowCrystal UO test sample 1" <> $SessionUUID],
						Object[Sample, "GrowCrystal UO test sample 2 from PreparedPlate" <> $SessionUUID],
						Object[Sample, "GrowCrystal UO test sample 3 from PreparedPlate" <> $SessionUUID]
					}
				}],
				ObjectP[]
			];

			(* Check whether the created objects and models exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase all the created objects and models *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];


DefineTests[ExperimentGrowCrystalOptions,
	{
		Example[{Basic, "Returns options for each sample used in a GrowCrystal experiment:"},
			ExperimentGrowCrystalOptions[
				Object[Sample, "ExperimentGrowCrystalOptions test sample 1" <> $SessionUUID]
			],
			_Grid
		]
	},

	Stubs:> {
		$PersonID = Object[User,"Test user for notebook-less test protocols"],
		(* want the tests for preparing CrystallizationPlate to still pass even if we're not yet supporting in lab *)
		$GrowCrystalPreparedOnly = False
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalOptions test sample 1" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{allObjects, testBench, allContainers, allInputs},
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalOptions test sample 1" <> $SessionUUID]
			};

			(* Create Containers *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ExperimentGrowCrystalOptions Testing" <> $SessionUUID,
				DeveloperObject -> True
			|>];
			allContainers = UploadSample[
				{
					Model[Container, Vessel, "2-mL clear tube with blue screwcap"]
				},
				{
					{"Work Surface", testBench}
				},
				Name -> {
					"Container for Protein sample 1 for ExperimentGrowCrystalOptions Testing" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allContainers;

			(* Create Samples *)
			allInputs = UploadSample[
				{
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"]
				},
				{
					{"A1", Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalOptions Testing" <> $SessionUUID]}
				},
				InitialAmount -> {1 Milliliter},
				Name -> {
					"ExperimentGrowCrystalOptions test sample 1" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allInputs;
		]
	),


	SymbolTearDown :> (
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalOptions Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalOptions test sample 1" <> $SessionUUID]
			};

			(* Check whether the created objects and models exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase all the created objects and models *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];

DefineTests[ExperimentGrowCrystalPreview,
	{
		Example[{Basic, "Returns nothing for sample used in a GrowCrystal experiment:"},
			ExperimentGrowCrystalPreview[
				Object[Sample, "ExperimentGrowCrystalPreview test sample 1" <> $SessionUUID]
			],
			Null
		]
	},

	Stubs:>{
		$PersonID = Object[User,"Test user for notebook-less test protocols"],
		(* want the tests for preparing CrystallizationPlate to still pass even if we're not yet supporting in lab *)
		$GrowCrystalPreparedOnly = False
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalPreview test sample 1" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Module[{allObjects, testBench, allContainers, allInputs},
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalPreview test sample 1" <> $SessionUUID]
			};

			(* Create Containers *)
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ExperimentGrowCrystalPreview Testing" <> $SessionUUID,
				DeveloperObject -> True
			|>];
			allContainers = UploadSample[
				{
					Model[Container, Vessel, "2-mL clear tube with blue screwcap"]
				},
				{
					{"Work Surface", testBench}
				},
				Name -> {
					"Container for Protein sample 1 for ExperimentGrowCrystalPreview Testing" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allContainers;

			(* Create Samples *)
			allInputs = UploadSample[
				{
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"]
				},
				{
					{"A1", Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalPreview Testing" <> $SessionUUID]}
				},
				InitialAmount -> {1 Milliliter},
				Name -> {
					"ExperimentGrowCrystalPreview test sample 1" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>]& /@ allInputs;
		]
	),


	SymbolTearDown :> (
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Container, Vessel, "Container for Protein sample 1 for ExperimentGrowCrystalPreview Testing" <> $SessionUUID],
				Object[Sample, "ExperimentGrowCrystalPreview test sample 1" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
	)
];