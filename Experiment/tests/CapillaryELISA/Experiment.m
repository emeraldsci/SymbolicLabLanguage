(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCapillaryELISA: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentCapillaryELISA*)

DefineTests[ExperimentCapillaryELISA,
	{
		(* ===Basic examples=== *)
		Example[{Basic, "Accepts a sample object and generates a protocol using a pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Basic, "Accepts a non-empty container and generates a protocol using a pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				Object[Container, Vessel, "ExperimentCapillaryELISA test  container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Basic, "Accepts a sample object and generates a protocol using a customizable capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]]
		],
		Example[{Basic, "Accepts a non-empty container and generates a protocol using a customizable capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]]
		],
		Example[{Additional, "Accepts multiple samples with the same analyte and generates a protocol using a pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 4 with pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 5 with pre-loaded analyte" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Additional, "Input a sample as {Position,Container}:"},
			ExperimentCapillaryELISA[{"A1", Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryELISA]]
		],
		Example[{Additional, "Input a sample as a mixture: "},
			ExperimentCapillaryELISA[
				{{"A1", Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID]},
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			Messages :> {Warning::SampleAndContainerSpecified}
		],
		Example[{Additional, "Accepts multiple samples with different analytes and generates a protocol using a multi-analyte pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 4 with pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 5 with pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 6 with pre-loaded analyte" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Additional, "Accepts a test samples with multiple analytes and generates a protocol using a multi-analyte pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 3 with pre-loaded analytes" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],

		Example[{Additional, "Accepts multiple samples without pre-loaded analytes and generates a protocol using a customizable capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Incubate -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Output -> Options];
			{Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True, True, True, True},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 240
		],

		(* ===Options=== *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCapillaryELISA[
				{Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID], Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs},
			Messages :> {Warning::AliquotRequired}
		],

		(* Instrument *)
		Example[{Options, Instrument, "The Instrument option defaults to Model[Instrument,CapillaryELISA,\"Ella\"]:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectReferenceP[Model[Instrument, CapillaryELISA, "Ella"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Instrument, "The function accepts an appropriate Instrument Object:"},
			options = Quiet[
				ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Instrument -> Object[Instrument, CapillaryELISA, "Ella"],
					Output -> Options
				],
				{Warning::InstrumentUndergoingMaintenance}
			];
			Lookup[options, Instrument],
			ObjectReferenceP[Object[Instrument, CapillaryELISA, "Ella"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CartridgeType *)
		Example[{Options, CartridgeType, "The CartridgeType option can be used to select a customizable capillary ELISA cartridge for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CartridgeType -> Customizable,
				Output -> Options
			];
			Lookup[options, CartridgeType],
			Customizable,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CartridgeType, "The CartridgeType option can be used to select a pre-loaded SinglePlex72X1 capillary ELISA cartridge for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				CartridgeType -> SinglePlex72X1,
				Output -> Options
			];
			Lookup[options, CartridgeType],
			SinglePlex72X1,
			(* Turn on DeveloperSearch to find our test pre-loaded analytes, manufacturing specifications and cartridges *)
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, CartridgeType, "The CartridgeType option can be used to select a pre-loaded MultiAnalyte32X4 capillary ELISA cartridge for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				CartridgeType -> MultiAnalyte32X4,
				Output -> Options
			];
			Lookup[options, CartridgeType],
			MultiAnalyte32X4,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],

		(* Cartridge *)
		Example[{Options, Cartridge, "The Cartridge option can be used to select a customizable capillary ELISA cartridge model for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Model[Container, Plate, Irregular, CapillaryELISA, "Human 48-Digoxigenin Cartridge"],
				Output -> Options
			];
			Lookup[options, Cartridge],
			ObjectReferenceP[Model[Container, Plate, Irregular, CapillaryELISA, "Human 48-Digoxigenin Cartridge"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Cartridge, "The Cartridge option can be used to select a pre-loaded SinglePlex72X1 capillary ELISA cartridge object for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Cartridge],
			ObjectReferenceP[Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]],
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, Cartridge, "The Cartridge option can be used to select a pre-loaded MultiAnalyte32X4 capillary ELISA cartridge object for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Cartridge],
			ObjectReferenceP[Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID]],
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],

		(* Species *)
		Example[{Options, Species, "The Species option defaults to Human:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Species],
			Human,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Species, "The function is available for different Species option values:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Species -> Mouse,
				Output -> Options
			];
			Lookup[options, Species],
			Mouse,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Analytes *)
		Example[{Options, Analytes, "The Analytes option can be set to capillary ELISA pre-loaded analytes to use a pre-loaded capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4"},
				Output -> Options
			];
			Lookup[options, Analytes],
			{"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4"},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, Analytes, "The Analytes option can be set to a certain antigen molecule for a customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				Analytes -> {Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]},
				Output -> Options
			];
			Lookup[options, Analytes],
			{ObjectReferenceP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Analytes, "The Analytes option can be set to different certain antigen molecules for different samples for a customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				Analytes -> {{Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]}, {Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}},
				Output -> Options
			];
			Lookup[options, Analytes],
			{{ObjectReferenceP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]]}, {ObjectReferenceP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			TimeConstraint -> 300
		],

		(* SampleVolume *)
		Example[{Options, SampleVolume, "The SampleVolume option can be set to the desired volumes to be mixed with SpikeSample before dilution:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				SampleVolume -> {100Microliter, 200Microliter},
				Output -> Options
			];
			Lookup[options, SampleVolume],
			{100Microliter, 200Microliter},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* SpikeSample *)
		Example[{Options, SpikeSample, "The input samples can be mixed with SpikeSample to increase the concentration(s) of analyte(s):"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				SpikeSample -> {Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID], Null},
				Output -> Options
			];
			Lookup[options, SpikeSample],
			{ObjectReferenceP[Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID]], Null},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* SpikeVolume *)
		Example[{Options, SpikeVolume, "The SpikeVolume option can be set to the desired volumes of SpikeSample to be mixed with the input samples before dilution:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				SpikeSample -> {Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID], Null},
				SpikeVolume -> {100Microliter, Null},
				Output -> Options
			];
			Lookup[options, SpikeVolume],
			{100Microliter, Null},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* SpikeSampleStorageCondition *)
		Example[{Options, SpikeSampleStorageCondition, "The SpikeSampleStorageCondition option can be set to the desired storage condition of SpikeSample after the protocol is finished:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]
				},
				SpikeSample -> {
					Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
					Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID]},
				SpikeSampleStorageCondition -> {AmbientStorage, Freezer},
				Output -> Options
			];
			Lookup[options, SpikeSampleStorageCondition],
			{AmbientStorage, Freezer},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DilutionCurve *)
		Example[{Options, DilutionCurve, "The DilutionCurve option can be set to a list of fixed volume dilutions:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{20Microliter, 60Microliter}, {25Microliter, 55Microliter}, {30Microliter, 50Microliter}, {35Microliter, 45Microliter}, {40Microliter, 40Microliter}},
				Output -> Options
			];
			Lookup[options, DilutionCurve],
			{{20Microliter, 60Microliter}, {25Microliter, 55Microliter}, {30Microliter, 50Microliter}, {35Microliter, 45Microliter}, {40Microliter, 40Microliter}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DilutionCurve, "The DilutionCurve option can be set to a list of dilution factors:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{80Microliter, 0.1}, {80Microliter, 0.2}, {80Microliter, 0.3}, {80Microliter, 0.4}, {80Microliter, 0.5}},
				Output -> Options
			];
			Lookup[options, DilutionCurve],
			{{80Microliter, 0.1}, {80Microliter, 0.2}, {80Microliter, 0.3}, {80Microliter, 0.4}, {80Microliter, 0.5}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* SerialDilutionCurve *)
		Example[{Options, SerialDilutionCurve, "The SerialDilutionCurve option can be set to a list of stepwise dilution volumes:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SerialDilutionCurve -> {20Microliter, 60Microliter, 5},
				Output -> Options
			];
			Lookup[options, SerialDilutionCurve],
			{20Microliter, 60Microliter, 5},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SerialDilutionCurve, "The SerialDilutionCurve option can be set to a list of stepwise dilution factors:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SerialDilutionCurve -> {100Microliter, {0.25, 5}},
				Output -> Options
			];
			Lookup[options, SerialDilutionCurve],
			{100Microliter, {0.25, 5}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Diluent *)
		Example[{Options, Diluent, "The Diluent option defaults to Model[Sample,\"Simple Plex Sample Diluent 13\"] for a customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {CartridgeType, Diluent}],
			{Customizable, ObjectReferenceP[Model[Sample, "Simple Plex Sample Diluent 13"]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Diluent, "The Diluent option defaults to the best diluent for the analytes of the pre-loaded capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {CartridgeType, Diluent}],
			{SinglePlex72X1 | MultiAnalyte32X4, ObjectP[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]]},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, Diluent, "The Diluent option can be set to the desired buffer:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Diluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, Diluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Dilution Mix Options *)
		Example[{Options, DilutionMixVolume, "The DilutionMixVolume option can be set to the desired volume that is pipetted up and down in the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionMixVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, DilutionMixVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Dilution Mix Options *)
		Example[{Options, DilutionNumberOfMixes, "The DilutionNumberOfMixes option can be set to the desired number of pipette up and down cycles that is used to mix the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionNumberOfMixes -> 20,
				Output -> Options
			];
			Lookup[options, DilutionNumberOfMixes],
			20,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Dilution Mix Options *)
		Example[{Options, DilutionMixRate, "The DilutionMixRate option can be set to the desired speed of pipette up and down cycles that is used to mix the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionMixRate -> 150Microliter / Second,
				Output -> Options
			];
			Lookup[options, DilutionMixRate],
			150Microliter / Second,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Antibody Related Options for Input Samples *)
		(* CustomCaptureAntibody *)
		Example[{Options, CustomCaptureAntibody, "The CustomCaptureAntibody option is automatically selected based on the presented analyte inside the input sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomCaptureAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CustomCaptureAntibody, "The CustomCaptureAntibody option can be set to the desired capture antibody for the input sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomCaptureAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyResuspension *)
		Example[{Options, CaptureAntibodyResuspension, "The CaptureAntibodyResuspension option is automatically set based on the state of the CustomCaptureAntibody:"},
			options = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				CustomCaptureAntibody -> {
					Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
					Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID]},
				Output -> Options
			];
			{Download[Lookup[options, CustomCaptureAntibody], State], Lookup[options, CaptureAntibodyResuspension]},
			{{Liquid, Solid}, {False, True}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyResuspension, "The CaptureAntibodyResuspension option can be set to True for a solid-state CustomCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspension -> True,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyResuspension],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyResuspensionConcentration *)
		Example[{Options, CaptureAntibodyResuspensionConcentration, "The CaptureAntibodyResuspensionConcentration option can be set to the desired concentration for solid-state CustomCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspensionConcentration -> 0.8Milligram / Milliliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyResuspensionConcentration],
			0.8Milligram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyResuspensionDiluent *)
		Example[{Options, CaptureAntibodyResuspensionDiluent, "The CaptureAntibodyResuspensionDiluent option is automatically set to Model[Sample,StockSolution,\"Filtered PBS, Sterile\"] for solid-state CustomCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyResuspensionDiluent, "The CaptureAntibodyResuspensionDiluent option can be set to the desired buffer to resuspend the solid-state CustomCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspensionDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyStorageCondition *)
		Example[{Options, CaptureAntibodyStorageCondition, "The CaptureAntibodyStorageCondition option can be set to the desired storage condition for the resuspended capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, CaptureAntibodyConjugation, "The CaptureAntibodyConjugation option is automatically set based whether the provided CustomCaptureAntibody is conjugated with Digoxigenin or not:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			{DeleteCases[Flatten[Quiet[Download[Lookup[options, CustomCaptureAntibody], Composition[[All, 2]][SecondaryAntibodies][Object]]]], $Failed], Lookup[options, CaptureAntibodyConjugation]},
			{{}, True},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyConjugation, "The CaptureAntibodyConjugation option is automatically set based whether the provided CustomCaptureAntibody is conjugated with Digoxigenin or not:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				Output -> Options
			];
			{DeleteCases[Flatten[Quiet[Download[Lookup[options, CustomCaptureAntibody], Composition[[All, 2]][SecondaryAntibodies][Object]]]], $Failed], Lookup[options, CaptureAntibodyConjugation]},
			{{ObjectP[Model[Molecule, Protein, Antibody, "Anti-Digoxigenin Antibody"]]}, False},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyConjugation, "The CaptureAntibodyConjugation option can be set to True if a bioconjugation reaction with Digoxigenin NHS-ester is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugation],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyVolume *)
		Example[{Options, CaptureAntibodyVolume, "The CaptureAntibodyVolume option can be set to the desired volume of CustomCaptureAntibody to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyVolume],
			50Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DigoxigeninReagent *)
		Example[{Options, DigoxigeninReagent, "The DigoxigeninReagent is automatically set to Model[Sample,StockSolution,\"Digoxigenin-NHS, 0.67 mg/mL in DMF\"] when CaptureAntibodyConjugation is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DigoxigeninReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Digoxigenin-NHS, 0.67 mg/mL in DMF"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DigoxigeninReagent, "The DigoxigeninReagent can be set to the desired digoxigenin-NHS reagent for the conjugation of CustomCaptureAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DigoxigeninReagent -> Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"],
				Output -> Options
			];
			Lookup[options, DigoxigeninReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DigoxigeninReagentVolume *)
		Example[{Options, DigoxigeninReagentVolume, "The DigoxigeninReagentVolume option can be set to the desired volume of DigoxigeninReagent to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DigoxigeninReagentVolume -> 5Microliter,
				Output -> Options
			];
			Lookup[options, DigoxigeninReagentVolume],
			5Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationBuffer *)
		Example[{Options, CaptureAntibodyConjugationBuffer, "The CaptureAntibodyConjugationBuffer is automatically set to Model[Sample,StockSolution,\"Sodium bicarbonate working stock 75 mg/mL\"] when CaptureAntibodyConjugation is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Sodium bicarbonate working stock 75 mg/mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyConjugationBuffer, "The CaptureAntibodyConjugationBuffer can be set to the desired buffer for the conjugation of CustomCaptureAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationBufferVolume *)
		Example[{Options, CaptureAntibodyConjugationBufferVolume, "The CaptureAntibodyConjugationBufferVolume option is automatically set based on the CaptureAntibodyVolume and DigoxigeninReagentVolume:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			1 / 9 * (Lookup[options, CaptureAntibodyVolume] + Lookup[options, DigoxigeninReagentVolume]),
			Lookup[options, CaptureAntibodyConjugationBufferVolume],
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyConjugationBufferVolume, "The CaptureAntibodyConjugationBufferVolume option can be set to the desired buffer volume for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationBufferVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationBufferVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationContainer *)
		Example[{Options, CaptureAntibodyConjugationContainer, "The CaptureAntibodyConjugationContainer option can be set to the desired container for the conjugation reaction to happen:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationContainer],
			ObjectReferenceP[Model[Container, Vessel, "2mL Tube"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationTime *)
		Example[{Options, CaptureAntibodyConjugationTime, "The CaptureAntibodyConjugationTime option can be set to the desired incubation period for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationTime -> 30Minute,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationTime],
			30Minute,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationTemperature *)
		Example[{Options, CaptureAntibodyConjugationTemperature, "The CaptureAntibodyConjugationTemperature option can be set to the desired incubation temperature for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationTemperature -> 40Celsius,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationTemperature],
			40Celsius,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyPurificationColumn *)
		Example[{Options, CaptureAntibodyPurificationColumn, "The CaptureAntibodyPurificationColumn option can be set to the desired 40K MWCO desalting spin column to purify the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyPurificationColumn, "The CaptureAntibodyPurificationColumn option can be set to the desired 7K MWCO desalting spin column to purify the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalCaptureAntibodyPurificationColumn
			}
		],

		(* CaptureAntibodyColumnWashBuffer *)
		Example[{Options, CaptureAntibodyColumnWashBuffer, "The CaptureAntibodyColumnWashBuffer option is automatically set to Model[Sample,StockSolution,\"Filtered PBS, Sterile\"] to equilibrate the desalting spin column for the purification of conjugated capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyColumnWashBuffer, "The CaptureAntibodyColumnWashBuffer option can be set to the desired buffer to equilibrate the desalting spin column for the purification of conjugated capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyColumnWashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyConjugationStorageCondition *)
		Example[{Options, CaptureAntibodyConjugationStorageCondition, "The CaptureAntibodyConjugationStorageCondition option can be set to the desired storage condition for the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyConjugationStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyConjugationStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyDilution *)
		Example[{Options, CaptureAntibodyDilution, "The CaptureAntibodyDilution option can be set to True when dilution of capture antibody samples is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyDilution -> True,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyDilution],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyTargetConcentration *)
		Example[{Options, CaptureAntibodyTargetConcentration, "The CaptureAntibodyTargetConcentration option can be set to the desired concentration for capillary ELISA cartridge loading when CaptureAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyTargetConcentration -> 5.0Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyTargetConcentration],
			5.0Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* CaptureAntibodyDiluent *)
		Example[{Options, CaptureAntibodyDiluent, "The CaptureAntibodyDiluent option is automatically set to Model[Sample,\"Simple Plex Reagent Diluent\"] to mix and dilute the capture antibody samples when CaptureAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Simple Plex Reagent Diluent"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyDiluent, "The CaptureAntibodyDiluent option can be set to the desired buffer to dilute the capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CaptureAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalCaptureAntibodyDiluent
			}
		],

		(* CustomDetectionAntibody *)
		Example[{Options, CustomDetectionAntibody, "The CustomDetectionAntibody option is automatically selected based on the presented analyte inside the input sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomDetectionAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CustomDetectionAntibody, "The CustomDetectionAntibody option can be set to the desired detection antibody for the input sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomDetectionAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyResuspension *)
		Example[{Options, DetectionAntibodyResuspension, "The DetectionAntibodyResuspension option is automatically set based on the state of the CustomDetectionAntibody:"},
			options = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				CustomDetectionAntibody -> {
					Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
					Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID]},
				Output -> Options
			];
			{Download[Lookup[options, CustomDetectionAntibody], State], Lookup[options, DetectionAntibodyResuspension]},
			{{Liquid, Solid}, {False, True}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyResuspension, "The DetectionAntibodyResuspension option can be set to True for a solid-state CustomDetectionAntibody:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyResuspension -> True,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyResuspension],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyResuspensionConcentration *)
		Example[{Options, DetectionAntibodyResuspensionConcentration, "The DetectionAntibodyResuspensionConcentration option can be set to the desired concentration for solid-state CustomDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyResuspensionConcentration -> 0.8Milligram / Milliliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyResuspensionConcentration],
			0.8Milligram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyResuspensionDiluent *)
		Example[{Options, DetectionAntibodyResuspensionDiluent, "The DetectionAntibodyResuspensionDiluent option is automatically set to Model[Sample,StockSolution,\"Filtered PBS, Sterile\"] for solid-state CustomDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyResuspensionDiluent, "The DetectionAntibodyResuspensionDiluent option can be set to the desired buffer to resuspend the solid-state CustomDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyResuspensionDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyStorageCondition *)
		Example[{Options, DetectionAntibodyStorageCondition, "The DetectionAntibodyStorageCondition option can be set to the desired storage condition for the resuspended detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, DetectionAntibodyConjugation, "The DetectionAntibodyConjugation option is automatically set based whether the provided CustomDetectionAntibody is conjugated with Biotin or not:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			{DeleteCases[Flatten[Quiet[Download[Lookup[options, CustomDetectionAntibody], Composition[[All, 2]][Targets][Object]]]], $Failed], Lookup[options, DetectionAntibodyConjugation]},
			{{ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]]}, True},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, DetectionAntibodyConjugation, "The DetectionAntibodyConjugation option is automatically set based whether the provided CustomDetectionAntibody is conjugated with Biotin or not:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				Output -> Options
			];
			{DeleteCases[Flatten[Quiet[Download[Lookup[options, CustomDetectionAntibody], Composition[[All, 2]][Targets][Object]]]], $Failed], Lookup[options, DetectionAntibodyConjugation]},
			{{ObjectP[Model[Molecule, Protein, "Streptavidin"]]}, False},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyConjugation, "The DetectionAntibodyConjugation option can be set to True if a bioconjugation reaction with biotinylation reagent is desired::"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugation],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyVolume *)
		Example[{Options, DetectionAntibodyVolume, "The DetectionAntibodyVolume option can be set to the desired volume of CustomDetectionAntibody to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyVolume],
			50Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* BiotinReagent *)
		Example[{Options, BiotinReagent, "The BiotinReagent can be set to the desired biotin-XX reagent for the conjugation of CustomDetectionAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				BiotinReagent -> Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"],
				Output -> Options
			];
			Lookup[options, BiotinReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* BiotinReagentVolume *)
		Example[{Options, BiotinReagentVolume, "The BiotinReagentVolume option can be set to the desired volume of BiotinReagent to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				BiotinReagentVolume -> 5Microliter,
				Output -> Options
			];
			Lookup[options, BiotinReagentVolume],
			5Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationBuffer *)
		Example[{Options, DetectionAntibodyConjugationBuffer, "The DetectionAntibodyConjugationBuffer is automatically set to Model[Sample,StockSolution,\"Sodium bicarbonate working stock 75 mg/mL\"] when DetectionAntibodyConjugation is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Sodium bicarbonate working stock 75 mg/mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyConjugationBuffer, "The DetectionAntibodyConjugationBuffer can be set to the desired buffer for the conjugation of CustomDetectionAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationBufferVolume *)
		Example[{Options, DetectionAntibodyConjugationBufferVolume, "The DetectionAntibodyConjugationBufferVolume option is automatically set based on the DetectionAntibodyVolume and BiotinReagentVolume:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			1 / 9 * (Lookup[options, DetectionAntibodyVolume] + Lookup[options, BiotinReagentVolume]),
			Lookup[options, DetectionAntibodyConjugationBufferVolume],
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyConjugationBufferVolume, "The DetectionAntibodyConjugationBufferVolume option can be set to the desired buffer volume for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationBufferVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationBufferVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationContainer *)
		Example[{Options, DetectionAntibodyConjugationContainer, "The DetectionAntibodyConjugationContainer option can be set to the desired container for the conjugation reaction to happen:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationContainer],
			ObjectReferenceP[Model[Container, Vessel, "2mL Tube"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationTime *)
		Example[{Options, DetectionAntibodyConjugationTime, "The DetectionAntibodyConjugationTime option can be set to the desired incubation period for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationTime -> 30Minute,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationTime],
			30Minute,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationTemperature *)
		Example[{Options, DetectionAntibodyConjugationTemperature, "The DetectionAntibodyConjugationTemperature option can be set to the desired incubation temperature for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationTemperature -> 40Celsius,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationTemperature],
			40Celsius,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyPurificationColumn *)
		Example[{Options, DetectionAntibodyPurificationColumn, "The DetectionAntibodyPurificationColumn option can be set to the desired 40K MWCO desalting spin column to purify the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyPurificationColumn, "The DetectionAntibodyPurificationColumn option can be set to the desired 7K MWCO desalting spin column to purify the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalDetectionAntibodyPurificationColumn
			}
		],

		(* DetectionAntibodyColumnWashBuffer *)
		Example[{Options, DetectionAntibodyColumnWashBuffer, "The DetectionAntibodyColumnWashBuffer option is automatically set to Model[Sample,StockSolution,\"Filtered PBS, Sterile\"] to equilibrate the desalting spin column for the purification of conjugated detection antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyColumnWashBuffer, "The DetectionAntibodyColumnWashBuffer option can be set to the desired buffer to equilibrate the desalting spin column for the purification of conjugated detection antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyColumnWashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyConjugationStorageCondition *)
		Example[{Options, DetectionAntibodyConjugationStorageCondition, "The DetectionAntibodyConjugationStorageCondition option can be set to the desired storage condition for the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyConjugationStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyConjugationStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyDilution *)
		Example[{Options, DetectionAntibodyDilution, "The DetectionAntibodyDilution option can be set to True when dilution of detection antibody samples is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyDilution -> True,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyDilution],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyTargetConcentration *)
		Example[{Options, DetectionAntibodyTargetConcentration, "The DetectionAntibodyTargetConcentration option can be set to the desired concentration for capillary ELISA cartridge loading when DetectionAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyTargetConcentration -> 5Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyTargetConcentration],
			5Microgram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* DetectionAntibodyDiluent *)
		Example[{Options, DetectionAntibodyDiluent, "The DetectionAntibodyDiluent option is automatically set to Model[Sample,\"Simple Plex Reagent Diluent\"] to mix and dilute the detection antibody samples when DetectionAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Simple Plex Reagent Diluent"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyDiluent, "The DetectionAntibodyDiluent option can be set to the desired buffer to dilute the detection antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DetectionAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalDetectionAntibodyDiluent
			}
		],

		(* Standard *)
		Example[{Options, Standard, "The Standard sample is automatically selected based on the presented Analytes in the input samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Standard],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Standard, "The desired Standard samples, either provided as Model[Sample] or Object[Sample] can be selected in the Standard option to be run in the same capillary ELISA experiment with the input samples:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> {
					Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 1" <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, Standard],
			{ObjectReferenceP[Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID]], ObjectReferenceP[Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 1" <> $SessionUUID]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Standard, "The Standard option is automatically set to Null when a pre-loaded capillary ELISA cartridge is used:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Standard],
			Null,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, Standard, "The Standard option can be set to the desired sample with known concentrations of analyte(s) when a pre-loaded capillary ELISA cartridge is used:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Standard],
			ObjectReferenceP[Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID]],
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],

		(* StandardResuspension *)
		Example[{Options, StandardResuspension, "The StandardResuspension option is automatically set based on the state of the Standard sample:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> {
					Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
					Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID]
				},
				Output -> Options
			];
			{Download[Lookup[options, Standard], State], Lookup[options, StandardResuspension]},
			{{Liquid, Solid}, {False, True}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		Example[{Options, StandardResuspension, "The StandardResuspension option can be set to True for a solid-state Standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspension -> True,
				Output -> Options
			];
			Lookup[options, StandardResuspension],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* StandardResuspensionConcentration *)
		Example[{Options, StandardResuspensionConcentration, "The StandardResuspensionConcentration option is automatically set based on the upper detection limit of the analyte in the pre-loaded capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardResuspensionConcentration],
			40000Picogram / Milliliter,
			EquivalenceFunction -> Equal,
			Stubs :> {
				$DeveloperSearch = True
			},
			Variables :> {options}
		],
		Example[{Options, StandardResuspensionConcentration, "The StandardResuspensionConcentration option can be set to the desired concentration for solid-state Standard:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspensionConcentration -> 100Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardResuspensionConcentration],
			100Microgram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* StandardResuspensionDiluent *)
		Example[{Options, StandardResuspensionDiluent, "The StandardResuspensionDiluent option is automatically set to Model[Sample,\"Simple Plex Sample Diluent 13\"] for a customizable capillary ELISA cartridge and solid-state Standard:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Simple Plex Sample Diluent 13"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],
		Example[{Options, StandardResuspensionDiluent, "The StandardResuspensionDiluent option defaults to the best diluent for the analytes of the pre-loaded capillary ELISA cartridge for a solid-state Standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardResuspensionDiluent],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, StandardResuspensionDiluent, "The StandardResuspensionDiluent option can be set to the desired buffer to resuspend the solid-state Standard:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspensionDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardDiluent,
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* StandardStorageCondition *)
		Example[{Options, StandardStorageCondition, "The StandardStorageCondition option is automatically set to Freezer for solid-state Standard:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardStorageCondition],
			Freezer,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],
		Example[{Options, StandardStorageCondition, "The StandardStorageCondition option can be set to the desired storage condition for the resuspended standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, StandardStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			}
		],

		(* StandardDilutionCurve *)
		Example[{Options, StandardDilutionCurve, "The StandardDilutionCurve option can be set to a list of fixed volume dilutions:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> {{20Microliter, 60Microliter}, {25Microliter, 55Microliter}, {30Microliter, 50Microliter}, {35Microliter, 45Microliter}, {40Microliter, 40Microliter}},
				Output -> Options
			];
			Lookup[options, StandardDilutionCurve],
			{{20Microliter, 60Microliter}, {25Microliter, 55Microliter}, {30Microliter, 50Microliter}, {35Microliter, 45Microliter}, {40Microliter, 40Microliter}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardDilutionCurve, "The StandardDilutionCurve option can be set to a list of dilution factors:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> {{80Microliter, 0.1}, {80Microliter, 0.2}, {80Microliter, 0.3}, {80Microliter, 0.4}, {80Microliter, 0.5}},
				Output -> Options
			];
			Lookup[options, StandardDilutionCurve],
			{{80Microliter, 0.1}, {80Microliter, 0.2}, {80Microliter, 0.3}, {80Microliter, 0.4}, {80Microliter, 0.5}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(*
		Example[{Options,StandardDilutionCurve,"The StandardDilutionCurve option can be set to linear dilution series:"},
			options=ExperimentCapillaryELISA[Object[Sample,"ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard->Model[Sample,"ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve->{80Microliter,{0.1,0.05},5},
				Output->Options
			];
			Lookup[options,StandardDilutionCurve],
			{80Microliter,{0.1,0.05},5},
			Variables:>{options},
			Stubs:>{
				Search[Object[ManufacturingSpecification,CapillaryELISACartridge]]={}
			}
		],
		*)

		(* StandardSerialDilutionCurve *)
		Example[{Options, StandardSerialDilutionCurve, "The StandardSerialDilutionCurve option can be set to a list of stepwise dilution volumes:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardSerialDilutionCurve -> {20Microliter, 60Microliter, 5},
				Output -> Options
			];
			Lookup[options, StandardSerialDilutionCurve],
			{20Microliter, 60Microliter, 5},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardSerialDilutionCurve, "The StandardSerialDilutionCurve option can be set to a list of stepwise dilution factors:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardSerialDilutionCurve -> {100Microliter, {0.25, 5}},
				Output -> Options
			];
			Lookup[options, StandardSerialDilutionCurve],
			{100Microliter, {0.25, 5}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDiluent *)
		Example[{Options, StandardDiluent, "The StandardDiluent option defaults to Model[Sample,\"Simple Plex Sample Diluent 13\"] for a customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {CartridgeType, StandardDiluent}],
			{Customizable, Model[Sample, "id:eGakldJEGX4o"]}, (* Model[Sample, "Simple Plex Sample Diluent 13"] *)
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardDiluent, "The StandardDiluent option defaults to the best diluent for the analytes of the pre-loaded capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardDiluent],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			Variables :> {options}
		],
		Example[{Options, StandardDiluent, "The StandardDiluent option can be set to the desired buffer:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardDiluent
			}
		],

		(* StandardDilution Mix Options *)
		Example[{Options, StandardDilutionMixVolume, "The StandardDilutionMixVolume option can be set to the desired volume that is pipetted up and down in the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDilutionMixVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, StandardDilutionMixVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* StandardDilution Mix Options *)
		Example[{Options, StandardDilutionNumberOfMixes, "The StandardDilutionNumberOfMixes option can be set to the desired number of pipette up and down cycles that is used to mix the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDilutionNumberOfMixes -> 20,
				Output -> Options
			];
			Lookup[options, StandardDilutionNumberOfMixes],
			20,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* StandardDilution Mix Options *)
		Example[{Options, StandardDilutionMixRate, "The StandardDilutionMixRate option can be set to the desired speed of pipette up and down cycles that is used to mix the diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDilutionMixRate -> 150Microliter / Second,
				Output -> Options
			];
			Lookup[options, StandardDilutionMixRate],
			150Microliter / Second,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Standard Antibody Related Options for Input Samples *)
		(* StandardCaptureAntibody *)
		Example[{Options, StandardCaptureAntibody, "The StandardCaptureAntibody option is automatically selected based on the presented analyte inside the Standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardCaptureAntibody, "The StandardCaptureAntibody option can be set to the desired capture antibody for the Standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyResuspension *)
		Example[{Options, StandardCaptureAntibodyResuspension, "The StandardCaptureAntibodyResuspension option can be set to True for a solid-state StandardCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspension -> True,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyResuspension],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyResuspensionConcentration *)
		Example[{Options, StandardCaptureAntibodyResuspensionConcentration, "The StandardCaptureAntibodyResuspensionConcentration option can be set to the desired concentration for solid-state StandardCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspensionConcentration -> 0.8Milligram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyResuspensionConcentration],
			0.8Milligram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyResuspensionDiluent *)
		Example[{Options, StandardCaptureAntibodyResuspensionDiluent, "The StandardCaptureAntibodyResuspensionDiluent option can be set to the desired buffer to resuspend the solid-state StandardCaptureAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspensionDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyStorageCondition *)
		Example[{Options, StandardCaptureAntibodyStorageCondition, "The StandardCaptureAntibodyStorageCondition option can be set to the desired storage condition for the resuspended capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, StandardCaptureAntibodyConjugation, "The StandardCaptureAntibodyConjugation option can be set to True if a bioconjugation reaction with Digoxigenin NHS-ester is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugation],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyVolume *)
		Example[{Options, StandardCaptureAntibodyVolume, "The StandardCaptureAntibodyVolume option can be set to the desired volume of StandardCaptureAntibody to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyVolume],
			50Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDigoxigeninReagent *)
		Example[{Options, StandardDigoxigeninReagent, "The DigoxigeninReagent can be set to the desired digoxigenin-NHS reagent for the conjugation of StandardCaptureAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDigoxigeninReagent -> Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"],
				Output -> Options
			];
			Lookup[options, StandardDigoxigeninReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Digoxigenin-NHS, 2 mg/mL in DMF"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDigoxigeninReagentVolume *)
		Example[{Options, StandardDigoxigeninReagentVolume, "The DigoxigeninReagentVolume option can be set to the desired volume of DigoxigeninReagent to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDigoxigeninReagentVolume -> 5Microliter,
				Output -> Options
			];
			Lookup[options, StandardDigoxigeninReagentVolume],
			5Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationBuffer *)
		Example[{Options, StandardCaptureAntibodyConjugationBuffer, "The StandardCaptureAntibodyConjugationBuffer can be set to the desired buffer for the conjugation of StandardCaptureAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationBufferVolume *)
		Example[{Options, StandardCaptureAntibodyConjugationBufferVolume, "The StandardCaptureAntibodyConjugationBufferVolume option can be set to the desired buffer volume for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationBufferVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationBufferVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationContainer *)
		Example[{Options, StandardCaptureAntibodyConjugationContainer, "The StandardCaptureAntibodyConjugationContainer option can be set to the desired container for the conjugation reaction to happen:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationContainer],
			ObjectReferenceP[Model[Container, Vessel, "2mL Tube"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationTime *)
		Example[{Options, StandardCaptureAntibodyConjugationTime, "The StandardCaptureAntibodyConjugationTime option can be set to the desired incubation period for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationTime -> 30Minute,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationTime],
			30Minute,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationTemperature *)
		Example[{Options, StandardCaptureAntibodyConjugationTemperature, "The StandardCaptureAntibodyConjugationTemperature option can be set to the desired incubation temperature for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationTemperature -> 40Celsius,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationTemperature],
			40Celsius,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyPurificationColumn *)
		Example[{Options, StandardCaptureAntibodyPurificationColumn, "The StandardCaptureAntibodyPurificationColumn option can be set to the desired 40K MWCO desalting spin column to purify the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardCaptureAntibodyPurificationColumn, "The StandardCaptureAntibodyPurificationColumn option can be set to the desired 7K MWCO desalting spin column to purify the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardCaptureAntibodyPurificationColumn
			}
		],

		(* StandardCaptureAntibodyColumnWashBuffer *)
		Example[{Options, StandardCaptureAntibodyColumnWashBuffer, "The StandardCaptureAntibodyColumnWashBuffer option can be set to the desired buffer to equilibrate the desalting spin column for the purification of conjugated capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyColumnWashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyConjugationStorageCondition *)
		Example[{Options, StandardCaptureAntibodyConjugationStorageCondition, "The StandardCaptureAntibodyConjugationStorageCondition option can be set to the desired storage condition for the conjugated capture antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyConjugationStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyDilution *)
		Example[{Options, StandardCaptureAntibodyDilution, "The StandardCaptureAntibodyDilution option can be set to True when dilution of capture antibody samples is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyDilution -> True,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyDilution],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyTargetConcentration *)
		Example[{Options, StandardCaptureAntibodyTargetConcentration, "The StandardCaptureAntibodyTargetConcentration option can be set to the desired concentration for capillary ELISA cartridge loading when StandardCaptureAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyTargetConcentration -> 5.0Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyTargetConcentration],
			5.0Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardCaptureAntibodyDiluent *)
		Example[{Options, StandardCaptureAntibodyDiluent, "The StandardCaptureAntibodyDiluent option can be set to the desired buffer to dilute the capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardCaptureAntibodyDiluent
			}
		],

		(* StandardDetectionAntibody *)
		Example[{Options, StandardDetectionAntibody, "The StandardDetectionAntibody option is automatically selected based on the presented analyte inside the standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardDetectionAntibody, "The StandardDetectionAntibody option can be set to the desired detection antibody for the standard sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyResuspension *)
		Example[{Options, StandardDetectionAntibodyResuspension, "The StandardDetectionAntibodyResuspension option can be set to True for a solid-state StandardDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyResuspension -> True,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyResuspension],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyResuspensionConcentration *)
		Example[{Options, StandardDetectionAntibodyResuspensionConcentration, "The StandardDetectionAntibodyResuspensionConcentration option can be set to the desired concentration for solid-state StandardDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyResuspensionConcentration -> 0.8Milligram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyResuspensionConcentration],
			0.8Milligram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyResuspensionDiluent *)
		Example[{Options, StandardDetectionAntibodyResuspensionDiluent, "The StandardDetectionAntibodyResuspensionDiluent option can be set to the desired buffer to resuspend the solid-state StandardDetectionAntibody:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyResuspensionDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyResuspensionDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyStorageCondition *)
		Example[{Options, StandardDetectionAntibodyStorageCondition, "The StandardDetectionAntibodyStorageCondition option can be set to the desired storage condition for the resuspended detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, StandardDetectionAntibodyConjugation, "The StandardDetectionAntibodyConjugation option can be set to True if a bioconjugation reaction with biotinylation reagent is desired::"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugation],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyVolume *)
		Example[{Options, StandardDetectionAntibodyVolume, "The StandardDetectionAntibodyVolume option can be set to the desired volume of StandardDetectionAntibody to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyVolume],
			50Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardBiotinReagent *)
		Example[{Options, StandardBiotinReagent, "The StandardBiotinReagent can be set to the desired biotin-XX reagent for the conjugation of StandardDetectionAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardBiotinReagent -> Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"],
				Output -> Options
			];
			Lookup[options, BiotinReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardBiotinReagentVolume *)
		Example[{Options, StandardBiotinReagentVolume, "The StandardBiotinReagentVolume option can be set to the desired volume of StandardBiotinReagent to be used in the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardBiotinReagentVolume -> 5Microliter,
				Output -> Options
			];
			Lookup[options, StandardBiotinReagentVolume],
			5Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationBuffer *)
		Example[{Options, StandardDetectionAntibodyConjugationBuffer, "The StandardDetectionAntibodyConjugationBuffer can be set to the desired buffer for the conjugation of StandardDetectionAntibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationBufferVolume *)
		Example[{Options, StandardDetectionAntibodyConjugationBufferVolume, "The StandardDetectionAntibodyConjugationBufferVolume option can be set to the desired buffer volume for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationBufferVolume -> 10Microliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationBufferVolume],
			10Microliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationContainer *)
		Example[{Options, StandardDetectionAntibodyConjugationContainer, "The StandardDetectionAntibodyConjugationContainer option can be set to the desired container for the conjugation reaction to happen:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationContainer],
			ObjectReferenceP[Model[Container, Vessel, "2mL Tube"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationTime *)
		Example[{Options, StandardDetectionAntibodyConjugationTime, "The StandardDetectionAntibodyConjugationTime option can be set to the desired incubation period for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationTime -> 30Minute,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationTime],
			30Minute,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationTemperature *)
		Example[{Options, StandardDetectionAntibodyConjugationTemperature, "The StandardDetectionAntibodyConjugationTemperature option can be set to the desired incubation temperature for the conjugation reaction:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationTemperature -> 40Celsius,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationTemperature],
			40Celsius,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyPurificationColumn *)
		Example[{Options, StandardDetectionAntibodyPurificationColumn, "The StandardDetectionAntibodyPurificationColumn option can be set to the desired 40K MWCO desalting spin column to purify the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardDetectionAntibodyPurificationColumn, "The StandardDetectionAntibodyPurificationColumn option can be set to the desired 7K MWCO desalting spin column to purify the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardDetectionAntibodyPurificationColumn
			}
		],

		(* StandardDetectionAntibodyColumnWashBuffer *)
		Example[{Options, StandardDetectionAntibodyColumnWashBuffer, "The StandardDetectionAntibodyColumnWashBuffer option can be set to the desired buffer to equilibrate the desalting spin column for the purification of conjugated detection antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyColumnWashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyColumnWashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyConjugationStorageCondition *)
		Example[{Options, StandardDetectionAntibodyConjugationStorageCondition, "The StandardDetectionAntibodyConjugationStorageCondition option can be set to the desired storage condition for the conjugated detection antibody sample:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyConjugationStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyConjugationStorageCondition],
			Disposal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyDilution *)
		Example[{Options, StandardDetectionAntibodyDilution, "The StandardDetectionAntibodyDilution option can be set to True when dilution of detection antibody samples is desired:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyDilution -> True,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyDilution],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyTargetConcentration *)
		Example[{Options, StandardDetectionAntibodyTargetConcentration, "The StandardDetectionAntibodyTargetConcentration option can be set to the desired concentration for capillary ELISA cartridge loading when StandardDetectionAntibodyDilution is True:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyTargetConcentration -> 5Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyTargetConcentration],
			5Microgram / Milliliter,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardDetectionAntibodyDiluent *)
		Example[{Options, StandardDetectionAntibodyDiluent, "The StandardDetectionAntibodyDiluent option can be set to the desired buffer to dilute the detection antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalStandardDetectionAntibodyDiluent
			}
		],

		(* WashBuffer *)
		Example[{Options, WashBuffer, "The WashBuffer option defaults to Model[Sample,\"Simple Plex Wash Buffer\"]:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, WashBuffer],
			ObjectReferenceP[Model[Sample, "Simple Plex Wash Buffer"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, WashBuffer, "The WashBuffer option can be set to a desired buffer that is loaded in the capillary ELISA cartridge to automatically flow through the capillaries to remove excess reagents between the antibody binding steps of analyte(s) with capture antibody and detection antibody.:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				WashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, WashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::NonOptimalWashBuffer
			}
		],

		(* Cartridge Loading *)
		Example[{Options, LoadingVolume, "LoadingVolume can be specified for each input sample and the same volume is applied to all of its diluted samples:"},
			options = ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				LoadingVolume -> {50Microliter, 55Microliter},
				Output -> Options
			];
			Lookup[options, LoadingVolume],
			{50Microliter, 55Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CaptureAntibodyLoadingVolume, "The CaptureAntibodyLoadingVolume option can be used to specify the volume of capture antibody sample loaded into the customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyLoadingVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyLoadingVolume],
			50Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DetectionAntibodyLoadingVolume, "The DetectionAntibodyLoadingVolume option can be used to specify the volume of detection antibody sample loaded into the customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyLoadingVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyLoadingVolume],
			50Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardLoadingVolume, "If Standard is added to the exerpiment, StandardLoadingVolume can be specified for each standard sample and the same volume is applied to all of its diluted samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardLoadingVolume -> 55Microliter,
				Output -> Options
			];
			Lookup[options, StandardLoadingVolume],
			55Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardCaptureAntibodyLoadingVolume, "The StandardCaptureAntibodyLoadingVolume option can be used to specify the volume of standard capture antibody sample loaded into the customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyLoadingVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyLoadingVolume],
			50Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardDetectionAntibodyLoadingVolume, "The StandardDetectionAntibodyLoadingVolume option can be used to specify the volume of standard detection antibody sample loaded into the customizable capillary ELISA cartridge:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyLoadingVolume -> 50Microliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyLoadingVolume],
			50Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* StandardComposition *)
		Example[{Options, StandardComposition, "The StandardComposition option is automatically resolved based on the composition of the standard sample to reflect the concentration(s) of analyte(s) of interest:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StandardComposition],
			{{200Microgram / Milliliter, ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, StandardComposition, "The StandardComposition option can be used to specify the concentration(s) of analyte(s) of interest in the standard sample for data processing:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardComposition -> {{100Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}},
				Output -> Options
			];
			Lookup[options, StandardComposition],
			{{100Microgram / Milliliter, ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* SpikeConcentration *)
		Example[{Options, SpikeConcentration, "The SpikeConcentration option is automatically resolved based on the composition of the spike sample to reflect the concentration(s) of analyte(s) of interest:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, SpikeConcentration],
			{{1000Picogram / Milliliter, ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SpikeConcentration, "The SpikeConcentration option can be used to specify the concentration(s) of analyte(s) of interest in the spike sample for data processing:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeConcentration -> {{500Picogram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}},
				Output -> Options
			];
			Lookup[options, SpikeConcentration],
			{{500Picogram / Milliliter, ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Shared Option Test *)
		Example[{Options, Template, "Inherit options from a previously run protocol:"},
			options = Quiet[
				ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Template -> Object[Protocol, CapillaryELISA, "Test CapillaryELISA Instrument option template protocol" <> $SessionUUID],
					Output -> Options
				],
				{Warning::InstrumentUndergoingMaintenance}
			];
			Lookup[options, Instrument],
			Object[Instrument, CapillaryELISA, "id:pZx9jo8Le044"],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Name, "Name the protocol for CapillaryELISA:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Name -> "What is the name of this test protocol",
				Output -> Options
			];
			Lookup[options, Name],
			"What is the name of this test protocol",
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* --- Sample Prep unit tests --- *)
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run on a capillary ELISA experiment:"},
			options=ExperimentCapillaryELISA["Test Sample Container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Test Sample Container",
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					Transfer[
						Source->Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
						Amount->50Microliter,
						Destination->{"A1","Test Sample Container"}
					]
				},
				Output -> Options
			];
			Lookup[options, CartridgeType],
			Customizable,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], IncubateAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			},
			TimeConstraint -> 300
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], CentrifugeTime -> 5 * Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CentrifugeTemperature -> 30 * Celsius,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			30 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 300
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], CentrifugeAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			},
			TimeConstraint -> 300
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 300
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 300
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FilterMaterial -> PES, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 10 without pre-loaded analyte (semi-large volume)" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 10 without pre-loaded analyte (semi-large volume)" <> $SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FiltrationType -> Syringe,
				FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 9 without pre-loaded analyte (large volume)" <> $SessionUUID],
				FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], FilterAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			},
			TimeConstraint -> 300
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			},
			TimeConstraint -> 300
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], AliquotAmount -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], AssayVolume -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], TargetConcentration -> 500Picogram / Milliliter, Output -> Options];
			Lookup[options, TargetConcentration],
			500Picogram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				TargetConcentration -> 500Picogram / Milliliter,
				TargetConcentrationAnalyte -> Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectReferenceP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Plex Sample Diluent 13"], AliquotAmount -> 0.2 * Milliliter, AssayVolume -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, "Simple Plex Sample Diluent 13"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Plex Sample Diluent 13"], AliquotAmount -> 0.1 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, "Simple Plex Sample Diluent 13"], AliquotAmount -> 0.2 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				AssayBuffer -> Model[Sample, "Simple Plex Sample Diluent 13"], AliquotAmount -> 0.2 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, "Simple Plex Sample Diluent 13"]],
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				IncubateAliquotDestinationWell -> "A1", AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 300
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			TimeConstraint -> 300
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::AliquotRequired
			},
			TimeConstraint -> 300
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* ===Messages=== *)
		Example[{Messages, "InputContainsTemporalLinks", "A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentCapillaryELISA[
				Link[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Now]
			],
			ObjectP[Object[Protocol, CapillaryELISA]],
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages, "DiscardedSamples", "The input sample cannot have a Status of Discarded:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 8 without pre-loaded analyte (discarded)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "SolidSamplesNotAllowed", "The input sample must be in liquid state:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 2" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples,
				(* From Aliquot resolver *)
				Error::SolidSamplesUnsupported,
				Error::InvalidInput
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooManyCapillaryELISAInputSamples", "There must be 72 or fewer input samples:"},
			ExperimentCapillaryELISA[ConstantArray[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], 73]],
			$Failed,
			TimeConstraint -> 1000,
			Messages :> {
				Error::TooManyCapillaryELISAInputSamples,
				Error::InvalidInput
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* Option Rounding *)
		Example[{Options, DilutionCurve, "Rounds specified DilutionCurve to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{39.99Microliter, 50Microliter}, {29.99Microliter, 60Microliter}}, Output -> Options];
			Lookup[roundedOptions, DilutionCurve],
			{{40Microliter, 50Microliter}, {30Microliter, 60Microliter}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DilutionCurve, "Rounds multiple specified DilutionCurves to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				DilutionCurve -> {{{39.99Microliter, 50Microliter}, {29.99Microliter, 60Microliter}}, {{39.99Microliter, 50Microliter}, {29.99Microliter, 60Microliter}}}, Output -> Options];
			Lookup[roundedOptions, DilutionCurve],
			{{{40Microliter, 50Microliter}, {30Microliter, 60Microliter}}, {{40Microliter, 50Microliter}, {30Microliter, 60Microliter}}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DilutionCurve, "Rounds multiple specified DilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				DilutionCurve -> {{{99.99Microliter, 0.1}, {89.99Microliter, 0.2}}, {{19.99Microliter, 70Microliter}, {29.99Microliter, 60Microliter}}}, Output -> Options];
			Lookup[roundedOptions, DilutionCurve],
			{{{100Microliter, 0.1}, {90Microliter, 0.2}}, {{20Microliter, 70Microliter}, {30Microliter, 60Microliter}}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, DilutionCurve, "Rounds multiple specified DilutionCurve to the nearest 0.1 Microliter for volumes and 0.1 for dilution factors:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				DilutionCurve -> {{{99.99Microliter, 0.1005}, {89.99Microliter, 0.21256}}, {{19.99Microliter, 70Microliter}, {29.99Microliter, 60Microliter}}}, Output -> Options];
			Lookup[roundedOptions, DilutionCurve],
			{{{100Microliter, 0.10}, {90Microliter, 0.21}}, {{20Microliter, 70Microliter}, {30Microliter, 60Microliter}}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, SerialDilutionCurve, "Rounds specified SerialDilutionCurve to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SerialDilutionCurve -> {39.99Microliter, 80Microliter, 10}, Output -> Options];
			Lookup[roundedOptions, SerialDilutionCurve],
			{40Microliter, 80Microliter, 10},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SerialDilutionCurve, "Rounds multiple specified SerialDilutionCurve to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				SerialDilutionCurve -> {{39.99Microliter, 80Microliter, 10}, {39.99Microliter, 90Microliter, 10}}, Output -> Options];
			Lookup[roundedOptions, SerialDilutionCurve],
			{{40Microliter, 80Microliter, 10}, {40Microliter, 90Microliter, 10}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SerialDilutionCurve, "Rounds specified multiple SerialDilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				SerialDilutionCurve -> {{39.99Microliter, 80Microliter, 10}, {89.99Microliter, {0.5, 10}}}, Output -> Options];
			Lookup[roundedOptions, SerialDilutionCurve],
			{{40Microliter, 80Microliter, 10}, {90Microliter, {0.5, 10}}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, SerialDilutionCurve, "Rounds specified SerialDilutionCurve to the nearest 0.1 Microliter for volumes and 0.1 for dilution factors:"},
			roundedOptions = ExperimentCapillaryELISA[
				{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				SerialDilutionCurve -> {{39.99Microliter, 80Microliter, 10}, {90.01Microliter, {0.403, 10}}, {99.99Microliter, {0.123, 0.202, 0.301}}}, Output -> Options];
			Lookup[roundedOptions, SerialDilutionCurve],
			{{40Microliter, 80Microliter, 10}, {90Microliter, {0.40, 10}}, {100Microliter, {0.12, 0.20, 0.30}}},
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, StandardResuspensionConcentration, "Rounds specified StandardResuspensionConcentration to the nearest 0.1 Microgram/Milliliter for mass concentrations:"},
			roundedOptions = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspension -> True,
				StandardResuspensionConcentration -> 100.603Microgram / Milliliter,
				Output -> Options];
			Lookup[roundedOptions, StandardResuspensionConcentration],
			100.6Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision,
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Options, StandardResuspensionConcentration, "Rounds specified StandardResuspensionConcentration to the nearest 0.1 Nano Molar for molar concentrations:"},
			roundedOptions = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspension -> True,
				CaptureAntibodyResuspensionConcentration -> 20.0123 * Nano * Molar,
				Output -> Options
			];
			Lookup[roundedOptions, CaptureAntibodyResuspensionConcentration],
			20 * Nano * Molar,
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, LoadingVolume, "Rounds specified LoadingVolume to the nearest 0.1 Microliter:"},
			roundedOptions = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				LoadingVolume -> 50.8900Microliter,
				Output -> Options];
			Lookup[roundedOptions, LoadingVolume],
			50.9Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {roundedOptions},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, NumberOfReplicates, "Indicate the number of times the experiment should be replicated:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				NumberOfReplicates -> 3,
				Output -> Options];
			Lookup[options, NumberOfReplicates],
			3,
			Variables :> {options},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Options, NumberOfReplicates, "If NumberOfReplicates is greater than 1, SamplesIn index-matched fields are either empty or expanded to match:"},
			(
				protocol = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], NumberOfReplicates -> 3];
				indexMatchedFields = Select[Lookup[LookupTypeDefinition[Object[Protocol, CapillaryELISA]], Fields], MemberQ[#[[2]], HoldPattern[IndexMatching -> SamplesIn]] &][[All, 1]];
				Length /@ Download[protocol, indexMatchedFields]
			),
			(* Fields are allowed to be empty, but if they are populated, they must match the length of SamplesIn * NumberOfReplicates *)
			{(0 | 3)..},
			Variables :> {protocol, indexMatchedFields}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentCapillaryELISA[
				Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
				PreparedModelAmount -> 1.8 Milliliter,
				Aliquot -> True,
				Mix -> True,
				Cartridge->Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, CapillaryELISA]]
		],
		(* == Messages == *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCapillaryELISA[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCapillaryELISA[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCapillaryELISA[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCapillaryELISA[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
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

				ExperimentCapillaryELISA[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Error::MustSpecifyCaptureAntibody,Error::MustSpecifyDetectionAntibody,Error::InvalidOption,Warning::AliquotRequired}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
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

				ExperimentCapillaryELISA[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Error::MustSpecifyCaptureAntibody,Error::MustSpecifyDetectionAntibody,Error::InvalidOption,Warning::AliquotRequired}
		],

		Example[{Messages, "DuplicateName", "If the Name option is specified, it cannot be identical to an existing Object[Protocol,CapillaryELISA] Name:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Name -> "Test CapillaryELISA Instrument option template protocol" <> $SessionUUID],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "DeprecatedCapillaryELISAInstrumentModel", "The function cannot accept a deprecated capillary ELISA instrument model:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Instrument -> Model[Instrument, CapillaryELISA, "Test CapillaryELISA instrument model for ExperimentCapillaryELISA tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::DeprecatedCapillaryELISAInstrumentModel,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "RetiredCapillaryELISAInstrument", "The function cannot accept a retired capillary ELISA instrument:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Instrument -> Object[Instrument, CapillaryELISA, "Test CapillaryELISA instrument object for ExperimentCapillaryELISA tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::RetiredCapillaryELISAInstrument,
				Error::DeprecatedCapillaryELISAInstrumentModel,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "DiscardedCapillaryELISACartridge", "The function cannot accept a a discarded capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1 (discarded)" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::DiscardedCapillaryELISACartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],

		Example[{Messages, "TooManyLoadingSamplesForCapillaryELISA", "The total number of loading samples including all diluted samples must be smaller than or equal to 72 in a capillary ELISA experimient:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SerialDilutionCurve -> {80Microliter, {0.5, 80}}
			],
			$Failed,
			Messages :> {
				Error::TooManyLoadingSamplesForCapillaryELISA,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "ExceedCapillaryELISACartridgeCapacity", "The total number of loading samples including all diluted samples must be smaller than or equal to the capacity of the capillary ELISA cartridge (48 for a customizable cartridge):"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Model[Container, Plate, Irregular, CapillaryELISA, "Human 48-Digoxigenin Cartridge"],
				SerialDilutionCurve -> {80Microliter, {0.5, 50}}
			],
			$Failed,
			Messages :> {
				Error::ExceedCapillaryELISACartridgeCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedCapillaryELISACartridgeCapacity", "The total number of loading samples including all diluted samples must be smaller than or equal to the capacity of the capillary ELISA cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
				SerialDilutionCurve -> {80Microliter, {0.5, 35}}
			],
			$Failed,
			Messages :> {
				Error::ExceedCapillaryELISACartridgeCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "CannotCreateNewCustomizableCartridge", "There is only one customizable cartridge so the Cartridge option cannot be set to Null when CartridgeType is Customizable:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> Customizable
			],
			$Failed,
			Messages :> {
				Error::CannotCreateNewCustomizableCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictCartridgeAndCartridgeType", "Cartridge option should be in accordance with the CartridgeType option:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
				CartridgeType -> MultiPlex32X8
			],
			$Failed,
			Messages :> {
				Error::ConflictCartridgeAndCartridgeType,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "ConflictCartridgeAndAnalytes", "Cartridge option should be in accordance with the Analytes option (provided as analyte names):"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
				Analytes -> {"IL-2", "IL-4", "IL-5", "IL-6"}
			],
			$Failed,
			Messages :> {
				Error::ConflictCartridgeAndAnalytes,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "ConflictCartridgeAndAnalytes", "Cartridge option should be in accordance with the Analytes option (provided as analyte molecules):"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
				Analytes -> {Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID], Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID], Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID], Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::ConflictCartridgeAndAnalytes,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "ConflictPreLoadedAnalytes", "For a cartridge that is not customizable (limited to 48 total samples), all samples are subject to the same analytes:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				SerialDilutionCurve -> {100Microliter, {0.4, 25}},
				Analytes -> {
					{Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID]},
					{Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 6" <> $SessionUUID]}
				}
			],
			$Failed,
			Messages :> {
				Error::ConflictPreLoadedAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "ExceedLengthAnalytesForCustomizableCartridge", "In a customizable cartridge, only one analyte can be tested per sample:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CartridgeType -> Customizable,
				Analytes -> {
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::ExceedLengthAnalytesForCustomizableCartridge,
				Error::InvalidOption
			},
			TimeConstraint -> 300,
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotUseMultiPlex32X8CartridgeForNonHuman", "MultiPlex32X8 cartridge is only available for Pro-Inflammation and Oncology panel:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				Species -> Mouse,
				CartridgeType -> MultiPlex32X8
			],
			$Failed,
			Messages :> {
				Error::CannotUseMultiPlex32X8CartridgeForNonHuman,
				Warning::LongLeadTimeCartridge,
				Error::MustSpecifyPreLoadedCartridgeAnalytes,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "DuplicatedAnalytes", "The specified Analyte Names for creating new cartridges cannot lead to the same analyte molecules:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-11"}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "DuplicatedAnalytes", "The specified Analyte Molecules for creating new cartridges must be unique:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],

		Example[{Messages, "TooManyAnalytes", "The specified number of Analyte Molecules should not be larger than the analyte capacity of the cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 4" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::TooManyAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			},
			TimeConstraint -> 600
		],
		Example[{Messages, "TooManyAnalytes", "The specified number of Analyte Names should not be larger than the analyte capacity of the cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4", "IL-5"}
			],
			$Failed,
			Messages :> {
				Error::TooManyAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "TooManyAnalytesForSampleNumber", "No multiplex assays can be performed when the total number of sample is over 32:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				SerialDilutionCurve -> {50Microliter, 100Microliter, 50},
				Cartridge -> Null,
				Analytes -> {"IL-1-beta", "IL-2", "IL-4", "IL-6"}
			],
			$Failed,
			Messages :> {
				Error::TooManyAnalytesForSampleNumber,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],

		Example[{Messages, "UnsupportedAnalytes", "Analytes must be supported by pre-loaded capillary ELISA cartridges to create a new cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				Analytes -> {
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::UnsupportedAnalytes,
				Warning::LongLeadTimeCartridge,
				Warning::EmptyCartridgeChannel,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "WrongSpeciesAnalytes", "Analyte Molecules must be in accordance with the specified Species:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				Species -> Mouse,
				Analytes -> {Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 8" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::AnalytesSpeciesUnavailable,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "WrongCartridgeTypeAnalytes", "Analyte Molecules must be available for the specified MultiPlex32X8 CartridgeType:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiPlex32X8,
				Analytes -> {
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 4" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 6" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 7" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 9" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {
				Error::AnalytesIncompatibleWithCartridgeType,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			TimeConstraint -> 300,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "WrongCartridgeTypeAnalytes", "Analytes must be available for the specified MultiPlex32X8 CartridgeType:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiPlex32X8,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4", "IL-5", "IL-6", "IL-7", "IFN-gamma"}
			],
			$Failed,
			Messages :> {
				Error::AnalytesIncompatibleWithCartridgeType,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "WrongCartridgeTypeAnalytes", "Analytes must be available for MultiPlex32X8 CartridgeType when more than 4 analytes are selected:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4", "IFN-gamma"}
			],
			$Failed,
			Messages :> {
				Error::AnalytesIncompatibleWithCartridgeType,
				Warning::LongLeadTimeCartridge,
				Warning::EmptyCartridgeChannel,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "NoCommonDiluentForAnalytes", "Analyte must share the same recommended diluent to be used in the same cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "BAFF"}
			],
			$Failed,
			Messages :> {
				Error::NoCommonDiluentForAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "NoCommonMinDilutionFactorForAnalytes", "Analyte must share the same recommended dilution factor to be used in the same cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-2", "AFP"}
			],
			$Failed,
			Messages :> {
				Error::NoCommonMinDilutionFactorForAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Messages, "IncompatibleAnalytes", "Analyte must be compatible to be used in the same cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-1-beta", "IL-7", "CA9"}
			],
			$Failed,
			Messages :> {
				Error::IncompatibleAnalytes,
				Warning::LongLeadTimeCartridge,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],

		Example[{Messages, "CannotSpecifySpikeOptions", "When SpikeSample is Null, none of the Spike related options should be specified:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID]
				},
				SpikeSample -> {Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID], Null},
				SpikeVolume -> {50Microliter, 50Microliter}
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifySpikeOptions,
				Warning::NoELISAAssayTypeForAntibodySamples,
				Error::InvalidInput,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonLiquidSpike", "When SpikeSample is Null, none of the Spike related options should be specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonLiquidSpike,
				Error::IncompleteResolvedSpikeConcentration,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifySpikeOptions", "When SpikeSample is specified, none of the Spike related options should be set to Null:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifySpikeOptions,
				Error::InvalidInput,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "WrongAnalyteSpikeConcentration", "SpikeConcentration option should give concentration information about the analyte presented in the input sample:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CartridgeType -> Customizable,
				Analytes -> {Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]},
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeConcentration -> {{100Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}}
			],
			$Failed,
			Messages :> {
				Error::IncosistentAnalyteAndSpikeConcentration,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughSampleVolumeAndSpikeVolume", "Enough volume of input samples must be provided to make the desired dilutions (defaulted to 30 Microliter required volume for DilutionCurve):"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SampleVolume -> 20Microliter
			],
			$Failed,
			Messages :> {
				Error::NotEnoughSampleVolumeAndSpikeVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughSampleVolumeAndSpikeVolume", "Enough volume of input samples must be provided to make the desired dilutions:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SampleVolume -> 20Microliter,
				DilutionCurve -> {{40Microliter, 40Microliter}}
			],
			$Failed,
			Messages :> {
				Error::NotEnoughSampleVolumeAndSpikeVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughSampleVolumeAndSpikeVolume", "Enough volume of input samples plus spike samples must be provided to make the desired dilutions:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SampleVolume -> 20Microliter,
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeVolume -> 15Microliter,
				DilutionCurve -> {{40Microliter, 40Microliter}}
			],
			$Failed,
			Messages :> {
				Error::NotEnoughSampleVolumeAndSpikeVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughSampleVolumeAndSpikeVolume", "Enough volume of input samples plus spike samples (if applicable) must be provided to make the desired dilutions (defaulted to 30 Microliter required volume for DilutionCurve):"},
			ExperimentCapillaryELISA[{Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID], Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]},
				SampleVolume -> 10Microliter,
				SpikeSample -> {Null, Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID]},
				SpikeVolume -> {Null, 15Microliter}
			],
			$Failed,
			Messages :> {
				Error::NotEnoughSampleVolumeAndSpikeVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CapillaryELISASampleDilution", "Dilution is required on all the loading samples for the best performance of microfludics:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> Null,
				Output -> Options
			];
			Lookup[options, SerialDilutionCurve],
			Except[Null],
			Messages :> {
				Warning::CapillaryELISASampleDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Variables :> {options}
		],
		Example[{Messages, "ConflictDilutionCurve", "Only one of DilutionCurve and SerialDilutionCurve can be provided:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{40Microliter, 40Microliter}},
				SerialDilutionCurve -> {100Microliter, {0.3, 5}}
			],
			$Failed,
			Messages :> {
				Error::ConflictDilutionCurve,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalLoadingVolume", "The loading volume of the sample should be larger than 50Microliter for the best ELISA results:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				LoadingVolume -> 30Microliter,
				Output -> Options
			];
			Lookup[options, LoadingVolume],
			30Microliter,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalLoadingVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughDilutionPreparationVolume", "The prepared volumes of the diluted samples must be larger than the required loading volumes plus 5 Microliter:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{20Microliter, 30Microliter}},
				LoadingVolume -> 55Microliter
			],
			$Failed,
			Messages :> {
				Error::NotEnoughDilutionPreparationVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooLargeDilutionMixVolumeForCapillaryELISASample", "The specified DilutionMixVolume should not be larger than the prepared volume of each diluted sample:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{60Microliter, 0.5}},
				DilutionMixVolume -> 100Microliter
			],
			$Failed,
			Messages :> {
				Error::TooLargeDilutionMixVolumeForCapillaryELISASample,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyAntibodyOptions", "The antibody options cannot be specified for a pre-loaded cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyAntibodyOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidCaptureAntibodyResuspensionForSolid", "CaptureAntibodyResuspension must be True for solid state capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspension -> False
			],
			$Failed,
			Messages :> {
				Error::InvalidCaptureAntibodyResuspensionForSolid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidCaptureAntibodyResuspensionForLiquid", "CaptureAntibodyResuspension must be False for liquid state capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidCaptureAntibodyResuspensionForLiquid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyCaptureAntibodyResuspensionOptions", "The capture antibody resuspension related options cannot be specified for liquid state capture antibody samples:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyResuspensionDiluent -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyCaptureAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyCaptureAntibodyResuspensionOptions", "The capture antibody resuspension related options cannot be Null for solid state capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyStorageCondition -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyCaptureAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyCaptureAntibodyConjugationOptions", "The capture antibody conjugation related options cannot be specified when CaptureAntibodyConjugation is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyConjugation -> False,
				CaptureAntibodyConjugationTemperature -> 40Celsius
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyCaptureAntibodyConjugationOptions", "The capture antibody conjugation related options cannot be Null when CaptureAntibodyConjugation is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				CaptureAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictCaptureAntibodyConjugationOptions", "The capture antibody conjugation related options should all be Null or not Null to indicate whether conjugation is requested on the capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugationTime -> 1Hour,
				CaptureAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "UnsupportedCaptureAntibodyPurificationColumn", "The specified CaptureAntibodyPurificationColumn should be a supported Zeba spin column for the purification of conjugated capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 0.22um, 0.5mL"]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedCaptureAntibodyPurificationColumn,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalCaptureAntibodyPurificationColumn", "The specified CaptureAntibodyPurificationColumn should be set to a 40K MWCO desalting spin column for the best purification result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalCaptureAntibodyPurificationColumn
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyCaptureAntibodyDilutionOptions", "The capture antibody dilution related options cannot be specified when CaptureAntibodyDilution is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyDilution -> False,
				CaptureAntibodyTargetConcentration -> 3.5 Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CaptureAntibodyDilutionRecommended", "Dilution is recommended for the capture antibody when it is either resuspended or conjugated in this protocol:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				CaptureAntibodyDilution -> False,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyDilution],
			False,
			Variables :> {options},
			Messages :> {
				Warning::CaptureAntibodyDilutionRecommended
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyCaptureAntibodyDilutionOptions", "The capture antibody dilution related options cannot be Null when CaptureAntibodyDilution is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyDilution -> True,
				CaptureAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictCaptureAntibodyDilutionOptions", "The capture antibody dilution related options should all be Null or not Null to indicate whether dilution is requested on the capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyTargetConcentration -> 3.5Microgram / Milliliter,
				CaptureAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalCaptureAntibodyDiluent", "The CaptureAntibodyDiluent option should be kept as Model[Sample,\"Simple Plex Reagent Diluent\"] or a sample with this model for the capture antibody samples for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, CaptureAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalCaptureAntibodyDiluent
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyCaptureAntibodyLoadingVolume", "The MustSpecifyCaptureAntibodyLoadingVolume option should not be Null when CustomCaptureAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyCaptureAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "InvalidDetectionAntibodyResuspensionForSolid", "DetectionAntibodyResuspension must be True for solid state detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyResuspension -> False
			],
			$Failed,
			Messages :> {
				Error::InvalidDetectionAntibodyResuspensionForSolid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidDetectionAntibodyResuspensionForLiquid", "DetectionAntibodyResuspension must be False for liquid state detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidDetectionAntibodyResuspensionForLiquid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyDetectionAntibodyResuspensionOptions", "The detection antibody resuspension related options cannot be specified for liquid state detection antibody samples:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyResuspensionDiluent -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyDetectionAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDetectionAntibodyResuspensionOptions", "The detection antibody resuspension related options cannot be Null for solid state detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyStorageCondition -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyDetectionAntibodyConjugationOptions", "The detection antibody conjugation related options cannot be specified when DetectionAntibodyConjugation is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyConjugation -> False,
				DetectionAntibodyConjugationTemperature -> 40Celsius
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDetectionAntibodyConjugationOptions", "The detection antibody conjugation related options cannot be Null when DetectionAntibodyConjugation is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				DetectionAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictDetectionAntibodyConjugationOptions", "The detection antibody conjugation related options should all be Null or not Null to indicate whether conjugation is requested on the detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyConjugationTime -> 1Hour,
				DetectionAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "UnsupportedDetectionAntibodyPurificationColumn", "The specified DetectionAntibodyPurificationColumn should be a supported Zeba spin column for the purification of conjugated detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 0.22um, 0.5mL"]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedDetectionAntibodyPurificationColumn,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalDetectionAntibodyPurificationColumn", "The specified DetectionAntibodyPurificationColumn should be set to a 40K MWCO desalting spin column for the best purification result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalDetectionAntibodyPurificationColumn
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyDetectionAntibodyDilutionOptions", "The detection antibody dilution related options cannot be specified when DetectionAntibodyDilution is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyDilution -> False,
				DetectionAntibodyTargetConcentration -> 3.5 Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "DetectionAntibodyDilutionRecommended", "Dilution is recommended for the detection antibody when it is either resuspended or conjugated in this protocol:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				DetectionAntibodyDilution -> False,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyDilution],
			False,
			Variables :> {options},
			Messages :> {
				Warning::DetectionAntibodyDilutionRecommended
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDetectionAntibodyDilutionOptions", "The detection antibody dilution related options cannot be Null when DetectionAntibodyDilution is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyDilution -> True,
				DetectionAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictDetectionAntibodyDilutionOptions", "The detection antibody dilution related options should all be Null or not Null to indicate whether dilution is requested on the detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyTargetConcentration -> 3.5Microgram / Milliliter,
				DetectionAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalDetectionAntibodyDiluent", "The DetectionAntibodyDiluent option should be kept as Model[Sample,\"Simple Plex Reagent Diluent\"] or a sample with this model for the detection antibody samples for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, DetectionAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalDetectionAntibodyDiluent
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDetectionAntibodyLoadingVolume", "The MustSpecifyDetectionAntibodyLoadingVolume option should not be Null when CustomDetectionAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "MustSpecifyDetectionAntibodyLoadingVolume", "The MustSpecifyDetectionAntibodyLoadingVolume option should not be Null when CustomDetectionAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "CannotSpecifyNullStandard", "The Standard option should not have Null member:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> {Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID], Null}
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyNullStandard,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardOptions", "The Standard related options should not be specified when Standard is set to Null:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Null,
				StandardResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardOptions,
				Error::InvalidStandardOptionLength,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidStandardResuspensionForSolid", "StandardResuspension must be True for solid state standard samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspension -> False
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardResuspensionForSolid,
				Warning::NoELISAAssayTypeForAntibodySamples,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidStandardResuspensionForLiquid", "StandardResuspension must be False for liquid state standard samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardResuspensionForLiquid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardResuspensionOptions", "The standard resuspension related options cannot be specified for liquid state standard samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardStorageCondition -> Freezer
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardResuspensionOptions", "The standard resuspension related options cannot be Null for solid state standard samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardStorageCondition -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardResuspensionOptions,
				Warning::NoELISAAssayTypeForAntibodySamples,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardOptions", "The standard dilution related options cannot be Null if Standard is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionMixVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CapillaryELISAStandardDilution", "Dilution is required on all the loading standard samples for the best performance of microfludics:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> Null,
				Output -> Options
			];
			Lookup[options, StandardSerialDilutionCurve],
			Except[Null],
			Messages :> {
				Warning::CapillaryELISAStandardDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			},
			Variables :> {options}
		],
		Example[{Messages, "ConflictStandardDilutionCurve", "Only one of StandardDilutionCurve and StandardSerialDilutionCurve can be provided:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> {{40Microliter, 40Microliter}},
				StandardSerialDilutionCurve -> {100Microliter, {0.3, 5}}
			],
			$Failed,
			Messages :> {
				Error::ConflictStandardDilutionCurve,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardLoadingVolume", "The loading volume of the standard sample should be larger than 50Microliter for the best ELISA results:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardLoadingVolume -> 30Microliter,
				Output -> Options
			];
			Lookup[options, StandardLoadingVolume],
			30Microliter,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardLoadingVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardDilutionCurve", "The total number of dilutions for standard samples should be larger than 5 to generate a valid standard curve:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> {{30Microliter, 30Microliter}},
				Upload -> False
			],
			{PacketP[]..},
			Messages :> {
				Warning::NonOptimalStandardDilutionCurve
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughStandardDilutionPreparationVolume", "The prepared volumes of the diluted standard samples must be larger than the required loading volumes plus 5 Microliter:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDilutionCurve -> {{20Microliter, 30Microliter}},
				StandardLoadingVolume -> 55Microliter
			],
			$Failed,
			Messages :> {
				Warning::NonOptimalStandardDilutionCurve,
				Error::NotEnoughStandardDilutionPreparationVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooLargeDilutionMixVolumeForCapillaryELISAStandard", "The specified StandardDilutionMixVolume should not be larger than the prepared volume of each diluted standard sample:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardSerialDilutionCurve -> {60Microliter, {0.3, 5}},
				StandardDilutionMixVolume -> 100Microliter
			],
			$Failed,
			Messages :> {
				Error::TooLargeDilutionMixVolumeForCapillaryELISAStandard,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictCapillaryELISAStandardComposition", "If the Standard sample is resuspended in the experiment, StandardResuspensionConcentration should be reflected in StandardComposition:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
				StandardResuspensionConcentration -> 100Microgram / Milliliter,
				StandardComposition -> {{200Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}},
				Output -> Options
			];
			{Lookup[options, StandardResuspensionConcentration], Lookup[options, StandardComposition]},
			{100Microgram / Milliliter, {{200Microgram / Milliliter, ObjectP[Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]]}}},
			Variables :> {options},
			Messages :> {
				Warning::ConflictCapillaryELISAStandardComposition,
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedStandardComposition", "The customizable capillary ELISA cartridge can only be used to detect the concentration of one analyte:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Model[Container, Plate, Irregular, CapillaryELISA, "Human 48-Digoxigenin Cartridge"],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardComposition -> {{200Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]}, {200Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID]}}
			],
			$Failed,
			Messages :> {
				Error::ExceedStandardComposition,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "WrongAnalyteStandardComposition", "The StandardComposition option should provide information about the pre-loaded capillary ELISA cartridge analytes:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardComposition -> {{200Microgram / Milliliter, Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID]}}
			],
			$Failed,
			Messages :> {
				Error::AnalyteUnavailableInStandardComposition,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True
			}
		],

		Example[{Messages, "CannotSpecifyStandardAntibodyOptions", "The standard antibody options cannot be specified for a pre-loaded cartridge:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				Cartridge -> Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardAntibodyOptions,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "InvalidStandardCaptureAntibodyResuspensionForSolid", "StandardCaptureAntibodyResuspension must be True for solid state standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspension -> False
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardCaptureAntibodyResuspensionForSolid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidStandardCaptureAntibodyResuspensionForLiquid", "StandardCaptureAntibodyResuspension must be False for liquid state standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardCaptureAntibodyResuspensionForLiquid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardCaptureAntibodyResuspensionOptions", "The standard capture antibody resuspension related options cannot be specified for liquid state standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyResuspensionDiluent -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardCaptureAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardCaptureAntibodyResuspensionOptions", "The standard capture antibody resuspension related options cannot be Null for solid state standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyStorageCondition -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardCaptureAntibodyConjugationOptions", "The standard capture antibody conjugation related options cannot be specified when StandardCaptureAntibodyConjugation is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> False,
				StandardCaptureAntibodyConjugationTemperature -> 40Celsius
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardCaptureAntibodyConjugationOptions", "The standard capture antibody conjugation related options cannot be Null when StandardCaptureAntibodyConjugation is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				StandardCaptureAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictStandardCaptureAntibodyConjugationOptions", "The standard capture antibody conjugation related options should all be Null or not Null to indicate whether conjugation is requested on the standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugationTime -> 1Hour,
				StandardCaptureAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictStandardCaptureAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "UnsupportedStandardCaptureAntibodyPurificationColumn", "The specified StandardCaptureAntibodyPurificationColumn should be a supported Zeba spin column for the purification of conjugated standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 0.22um, 0.5mL"]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedStandardCaptureAntibodyPurificationColumn,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardCaptureAntibodyPurificationColumn", "The specified StandardCaptureAntibodyPurificationColumn should be set to a 40K MWCO desalting spin column for the best purification result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardCaptureAntibodyPurificationColumn
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardCaptureAntibodyDilutionOptions", "The standard capture antibody dilution related options cannot be specified when StandardCaptureAntibodyDilution is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyDilution -> False,
				StandardCaptureAntibodyTargetConcentration -> 3.5 Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "StandardCaptureAntibodyDilutionRecommended", "Dilution is recommended for the standard capture antibody when it is either resuspended or conjugated in this protocol:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				StandardCaptureAntibodyDilution -> False,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyDilution],
			False,
			Variables :> {options},
			Messages :> {
				Warning::StandardCaptureAntibodyDilutionRecommended
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardCaptureAntibodyDilutionOptions", "The standard capture antibody dilution related options cannot be Null when StandardCaptureAntibodyDilution is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyDilution -> True,
				StandardCaptureAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictStandardCaptureAntibodyDilutionOptions", "The standard capture antibody dilution related options should all be Null or not Null to indicate whether dilution is requested on the standard capture antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyTargetConcentration -> 3.5Microgram / Milliliter,
				StandardCaptureAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictStandardCaptureAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardCaptureAntibodyDiluent", "The StandardCaptureAntibodyDiluent option should be kept as Model[Sample,\"Simple Plex Reagent Diluent\"] or a sample with this model for the standard capture antibody samples for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardCaptureAntibodyDiluent
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardCaptureAntibodyLoadingVolume", "The MustSpecifyStandardCaptureAntibodyLoadingVolume option should not be Null when StandardCaptureAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "InvalidStandardDetectionAntibodyResuspensionForSolid", "StandardDetectionAntibodyResuspension must be True for solid state standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyResuspension -> False
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardDetectionAntibodyResuspensionForSolid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "InvalidStandardDetectionAntibodyResuspensionForLiquid", "StandardDetectionAntibodyResuspension must be False for liquid state standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyResuspension -> True
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardDetectionAntibodyResuspensionForLiquid,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardDetectionAntibodyResuspensionOptions", "The standard detection antibody resuspension related options cannot be specified for liquid state standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyResuspensionDiluent -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardDetectionAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDetectionAntibodyResuspensionOptions", "The standard detection antibody resuspension related options cannot be Null for solid state standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyStorageCondition -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDetectionAntibodyResuspensionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardDetectionAntibodyConjugationOptions", "The standard detection antibody conjugation related options cannot be specified when StandardDetectionAntibodyConjugation is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> False,
				StandardDetectionAntibodyConjugationTemperature -> 40Celsius
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDetectionAntibodyConjugationOptions", "The standard detection antibody conjugation related options cannot be Null when StandardDetectionAntibodyConjugation is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				StandardDetectionAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictStandardDetectionAntibodyConjugationOptions", "The standard detection antibody conjugation related options should all be Null or not Null to indicate whether conjugation is requested on the standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyConjugationTime -> 1Hour,
				StandardDetectionAntibodyConjugationTemperature -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictStandardDetectionAntibodyConjugationOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "UnsupportedStandardDetectionAntibodyPurificationColumn", "The specified StandardDetectionAntibodyPurificationColumn should be a supported Zeba spin column for the purification of conjugated standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 0.22um, 0.5mL"]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedStandardDetectionAntibodyPurificationColumn,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardDetectionAntibodyPurificationColumn", "The specified StandardDetectionAntibodyPurificationColumn should be set to a 40K MWCO desalting spin column for the best purification result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyPurificationColumn],
			ObjectReferenceP[Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 7K MWCO, 5 mL"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardDetectionAntibodyPurificationColumn
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CannotSpecifyStandardDetectionAntibodyDilutionOptions", "The standard detection antibody dilution related options cannot be specified when StandardDetectionAntibodyDilution is set to False:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyDilution -> False,
				StandardDetectionAntibodyTargetConcentration -> 3.5 Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::CannotSpecifyStandardDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "StandardDetectionAntibodyDilutionRecommended", "Dilution is recommended for the standard detection antibody when it is either resuspended or conjugated in this protocol:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				StandardDetectionAntibodyDilution -> False,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyDilution],
			False,
			Variables :> {options},
			Messages :> {
				Warning::StandardDetectionAntibodyDilutionRecommended
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDetectionAntibodyDilutionOptions", "The standard detection antibody dilution related options cannot be Null when StandardDetectionAntibodyDilution is set to True:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyDilution -> True,
				StandardDetectionAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictStandardDetectionAntibodyDilutionOptions", "The standard detection antibody dilution related options should all be Null or not Null to indicate whether dilution is requested on the standard detection antibody samples:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyTargetConcentration -> 3.5Microgram / Milliliter,
				StandardDetectionAntibodyDiluent -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictStandardDetectionAntibodyDilutionOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardDetectionAntibodyDiluent", "The StandardDetectionAntibodyDiluent option should be kept as Model[Sample,\"Simple Plex Reagent Diluent\"] or a sample with this model for the standard detection antibody samples for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardDetectionAntibodyDiluent
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDetectionAntibodyLoadingVolume", "The MustSpecifyStandardDetectionAntibodyLoadingVolume option should not be Null when StandardDetectionAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDetectionAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "MustSpecifyStandardDetectionAntibodyLoadingVolume", "The MustSpecifyStandardDetectionAntibodyLoadingVolume option should not be Null when StandardDetectionAntibody is specified:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyLoadingVolume -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDetectionAntibodyLoadingVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "NonOptimalWashBuffer", "The WashBuffer should be kept as Model[Sample,\"Simple Plex Wash Buffer\"] for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				WashBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, WashBuffer],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalWashBuffer
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "ConflictCapillaryELISAAntibodyObjectSample", "The same antibody object should not be used as capture and detection antibody:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID],
				CustomDetectionAntibody -> Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ConflictCapillaryELISAAntibodyObjectSample,
				Warning::ConflictAntibodyEpitopes,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ConflictCapillaryELISAAntibodyOptions", "The same antibody object should not be used as capture and detection antibody:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				CustomCaptureAntibody -> Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID],
				CaptureAntibodyResuspensionConcentration -> 200Microgram / Milliliter,
				StandardCaptureAntibody -> Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspensionConcentration -> 100Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::ConflictCapillaryELISAAntibodyOptions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "LongLeadTimeCartridge", "A pre-loaded cartridge that is not stocked at ECL may take up to 14 days to arrive:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Cartridge],
			ObjectReferenceP[Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID]],
			Variables :> {options},
			Messages :> {
				Warning::LongLeadTimeCartridge
			},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "MustSpecifyPreLoadedCartridgeAnalytes", "To create a new capillary ELISA cartridge, pre-loaded analytes must be specified:"},
			ExperimentCapillaryELISA[
				Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4
			],
			$Failed,
			Messages :> {
				Warning::LongLeadTimeCartridge,
				Error::MustSpecifyPreLoadedCartridgeAnalytes,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		(* TODO A better message test for Warning::EmptyCartridgeChannel is required. Here we use Duplicated Analytes to stop resource packet evaluation *)
		Example[{Messages, "EmptyCartridgeChannel", "Every channel in the pre-loaded capillary ELISA cartridge should provide assay for a distinct analyte:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Cartridge -> Null,
				CartridgeType -> MultiAnalyte32X4,
				Analytes -> {"IL-1-alpha", "IL-11"}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedAnalytes,
				Warning::LongLeadTimeCartridge,
				Warning::EmptyCartridgeChannel,
				Error::InvalidOption
			},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "InvalidStandardOptionLength", "When Standard is Automatic, all standard related options should be provided with the same length as the resolved standard sample:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardResuspension -> {True, False},
				StandardDilutionMixRate -> {100Microliter / Second, 150Microliter / Second}
			],
			$Failed,
			Messages :> {
				Error::InvalidStandardOptionLength,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],

		Example[{Messages, "NonOptimalStandardResuspensionConcentration", "The StandardResuspensionConcentration option should not be higher than 25 times the upper detection limit of the analyte for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
				StandardResuspensionConcentration -> 150Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardResuspensionConcentration],
			150Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Stubs :> {
				$DeveloperSearch = True
			},
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardResuspensionConcentration
			}
		],
		Example[{Messages, "IncompleteResolvedStandardComposition", "The StandardComposition of the standard sample must be provided for data processing:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 3" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::IncompleteResolvedStandardComposition,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardDiluent", "The StandardDiluent option should be kept as the preferred diluent of the cartridge to achieve the best ELISA results:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardDiluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, StandardDiluent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardDiluent
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Here the same antibody sample is used for capture/detection antibody - they are guaranteed to share the same epitopes. It may be a good idea to create some test objects with shared epitopes *)
		Example[{Messages, "ConflictStandardAntibodyEpitopes", "The StandardCaptureAntibody and StandardDetectionAntibody of the standard samples should not share the same binding epitopes on the analytes for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				Output -> Options
			];
			MatchQ[Lookup[options, StandardCaptureAntibody], ObjectP[Lookup[options, StandardDetectionAntibody]]],
			True,
			Variables :> {options},
			Messages :> {
				Warning::ConflictStandardAntibodyEpitopes
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NoELISAAssayTypeForAntibodySamples", "The specified CustomCaptureAntibody should be available for ELISA assays:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomCaptureAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID]],
			Variables :> {options},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NoELISAAssayTypeForAntibodySamples", "The specified CustomDetectionAntibody should be available for ELISA assays:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CustomDetectionAntibody],
			ObjectP[Model[Sample, "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID]],
			Variables :> {options},
			Messages :> {
				Warning::NoELISAAssayTypeForAntibodySamples
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardCaptureAntibody", "The StandardCaptureAntibody must be provided for the standard sample when a customizable cartridge is used in the experiment:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibody,
				Error::MustSpecifyStandardDetectionAntibody,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDetectionAntibody", "The StandardDetectionAntibody must be provided for the standard sample when a customizable cartridge is used in the experiment:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardCaptureAntibody,
				Error::MustSpecifyStandardDetectionAntibody,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardDigoxigeninReagentVolume", "The StandardDigoxigeninReagentVolume must be provided for the standard capture antibody sample when conjugation is performed:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 7" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardDigoxigeninReagentVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyStandardBiotinReagentVolume", "The StandardBiotinReagentVolume must be provided for the standard detection antibody sample when conjugation is performed:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 8" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyStandardBiotinReagentVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughStandardDigoxigeninReagentVolume", "The StandardDigoxigeninReagentVolume should provide excess amount of digoxigenin reagent compared to StandardCaptureAntibody in the bioconjugation process to achieve the best conjugation efficiency for standard capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				StandardCaptureAntibodyVolume -> 1000Microliter,
				StandardDigoxigeninReagent -> Model[Sample, StockSolution, "Digoxigenin-NHS, 0.67 mg/mL in DMF"],
				StandardDigoxigeninReagentVolume -> 1Microliter,
				Output -> Options
			];
			Lookup[options, StandardDigoxigeninReagentVolume],
			1Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NotEnoughStandardDigoxigeninReagentVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughStandardBiotinReagentVolume", "The StandardBiotinReagentVolume should provide excess amount of digoxigenin reagent compared to StandardDetectionAntibody in the bioconjugation process to achieve the best conjugation efficiency for standard capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				StandardDetectionAntibodyVolume -> 1000Microliter,
				StandardBiotinReagent -> Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"],
				StandardBiotinReagentVolume -> 0.5Microliter,
				Output -> Options
			];
			Lookup[options, StandardBiotinReagentVolume],
			0.5Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NotEnoughStandardBiotinReagentVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedStandardCaptureAntibodyConjugationContainerCapacity", "The StandardCaptureAntibodyConjugationContainer provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				StandardCaptureAntibodyVolume -> 1000Microliter,
				StandardDigoxigeninReagentVolume -> 200Microliter,
				StandardCaptureAntibodyConjugationContainer -> Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"]
			],
			$Failed,
			Messages :> {
				Error::ExceedStandardCaptureAntibodyConjugationContainerCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedStandardDetectionAntibodyConjugationContainerCapacity", "The StandardDetectionAntibodyConjugationContainer provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				StandardDetectionAntibodyVolume -> 1000Microliter,
				StandardBiotinReagentVolume -> 200Microliter,
				StandardDetectionAntibodyConjugationContainer -> Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"]
			],
			$Failed,
			Messages :> {
				Error::ExceedStandardDetectionAntibodyConjugationContainerCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedStandardCaptureAntibodyPurificationColumnCapacity", "The StandardCaptureAntibodyPurificationColumn provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyConjugation -> True,
				StandardCaptureAntibodyVolume -> 1000Microliter,
				StandardDigoxigeninReagentVolume -> 200Microliter,
				StandardCaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]
			],
			$Failed,
			Messages :> {
				Error::ExceedStandardCaptureAntibodyPurificationColumnCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedStandardDetectionAntibodyPurificationColumnCapacity", "The StandardDetectionAntibodyPurificationColumn provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyConjugation -> True,
				StandardDetectionAntibodyVolume -> 1000Microliter,
				StandardBiotinReagentVolume -> 200Microliter,
				StandardDetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]
			],
			$Failed,
			Messages :> {
				Error::ExceedStandardDetectionAntibodyPurificationColumnCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooHighStandardCaptureAntibodyDilution", "The specified StandardCaptureAntibodyTargetConcentration cannot be higher than the StandardCaptureAntibodyResuspensionConcentration:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				StandardCaptureAntibodyResuspension -> True,
				StandardCaptureAntibodyResuspensionConcentration -> 100Microgram / Milliliter,
				StandardCaptureAntibodyTargetConcentration -> 200Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::TooHighStandardCaptureAntibodyDilution,
				Warning::NonOptimalStandardCaptureAntibodyDilution,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooHighStandardDetectionAntibodyDilution", "The specified StandardDetectionAntibodyTargetConcentration cannot be higher than the StandardDetectionAntibodyResuspensionConcentration:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				StandardDetectionAntibodyResuspension -> True,
				StandardDetectionAntibodyResuspensionConcentration -> 100Microgram / Milliliter,
				StandardDetectionAntibodyTargetConcentration -> 200Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::TooHighStandardDetectionAntibodyDilution,
				Warning::NonOptimalStandardDetectionAntibodyDilution,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardCaptureAntibodyDilution", "The specified StandardCaptureAntibodyTargetConcentration should not be higher than 50 Microgram/Milliliter for the best ELISA results:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				StandardCaptureAntibodyTargetConcentration -> 60Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardCaptureAntibodyTargetConcentration],
			60Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardCaptureAntibodyDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalStandardDetectionAntibodyDilution", "The specified StandardDetectionAntibodyTargetConcentration cannot be higher than the StandardDetectionAntibodyResuspensionConcentration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				Standard -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
				StandardDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				StandardDetectionAntibodyTargetConcentration -> 60Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, StandardDetectionAntibodyTargetConcentration],
			60Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalStandardDetectionAntibodyDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "IncompleteResolvedSpikeConcentration", "The SpikeConcentration of the spike sample must be provided for data processing:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				SpikeSample -> Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 3" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::IncompleteResolvedSpikeConcentration,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalCapillaryELISASampleDilution", "The DilutionCurve should not lead to a dilution higher than the minimum dilution factor:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				DilutionCurve -> {{60Microliter, 40Microliter}, {40Microliter, 60Microliter}},
				Output -> Options
			];
			Lookup[options, DilutionCurve],
			{{60Microliter, 40Microliter}, {40Microliter, 60Microliter}},
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalCapillaryELISASampleDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		(* Here the same antibody sample is used for capture/detection antibody - they are guaranteed to share the same epitopes. It may be a good idea to create some test objects with shared epitopes *)
		Example[{Messages, "ConflictAntibodyEpitopes", "The CustomCaptureAntibody and CustomDetectionAntibody of the samples should not share the same binding epitopes on the analytes for the best ELISA result:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				Output -> Options
			];
			MatchQ[Lookup[options, CustomCaptureAntibody], ObjectP[Lookup[options, CustomDetectionAntibody]]],
			True,
			Variables :> {options},
			Messages :> {
				Warning::ConflictAntibodyEpitopes
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyCaptureAntibody", "The CustomCaptureAntibody must be provided for the samples when a customizable cartridge is used in the experiment:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyCaptureAntibody,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDetectionAntibody", "The CustomCaptureAntibody must be provided for the samples when a customizable cartridge is used in the experiment:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Null
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDetectionAntibody,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyDigoxigeninReagentVolume", "The DigoxigeninReagentVolume must be provided for the capture antibody sample when conjugation is performed:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 7" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyDigoxigeninReagentVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "MustSpecifyBiotinReagentVolume", "The BiotinReagentVolume must be provided for the detection antibody sample when conjugation is performed:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 8" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::MustSpecifyBiotinReagentVolume,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughDigoxigeninReagentVolume", "The DigoxigeninReagentVolume should provide excess amount of digoxigenin reagent compared to CustomCaptureAntibody in the bioconjugation process to achieve the best conjugation efficiency for capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				CaptureAntibodyVolume -> 1000Microliter,
				DigoxigeninReagent -> Model[Sample, StockSolution, "Digoxigenin-NHS, 0.67 mg/mL in DMF"],
				DigoxigeninReagentVolume -> 1Microliter,
				Output -> Options
			];
			Lookup[options, DigoxigeninReagentVolume],
			1Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NotEnoughDigoxigeninReagentVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NotEnoughBiotinReagentVolume", "The BiotinReagentVolume should provide excess amount of digoxigenin reagent compared to CustomDetectionAntibody in the bioconjugation process to achieve the best conjugation efficiency for capture antibody samples:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				DetectionAntibodyVolume -> 1000Microliter,
				BiotinReagent -> Model[Sample, StockSolution, "Biotin-XX, 1 mg/mL in DMSO"],
				BiotinReagentVolume -> 0.5Microliter,
				Output -> Options
			];
			Lookup[options, BiotinReagentVolume],
			0.5Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NotEnoughBiotinReagentVolume
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedCaptureAntibodyConjugationContainerCapacity", "The CaptureAntibodyConjugationContainer provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				CaptureAntibodyVolume -> 1000Microliter,
				DigoxigeninReagentVolume -> 200Microliter,
				CaptureAntibodyConjugationContainer -> Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"]
			],
			$Failed,
			Messages :> {
				Error::ExceedCaptureAntibodyConjugationContainerCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedDetectionAntibodyConjugationContainerCapacity", "The DetectionAntibodyConjugationContainer provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				DetectionAntibodyVolume -> 1000Microliter,
				BiotinReagentVolume -> 200Microliter,
				DetectionAntibodyConjugationContainer -> Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"]
			],
			$Failed,
			Messages :> {
				Error::ExceedDetectionAntibodyConjugationContainerCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedCaptureAntibodyPurificationColumnCapacity", "The CaptureAntibodyPurificationColumn provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyConjugation -> True,
				CaptureAntibodyVolume -> 1000Microliter,
				DigoxigeninReagentVolume -> 200Microliter,
				CaptureAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]
			],
			$Failed,
			Messages :> {
				Error::ExceedCaptureAntibodyPurificationColumnCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "ExceedDetectionAntibodyPurificationColumnCapacity", "The DetectionAntibodyPurificationColumn provides enough capacity for the reaction mixture:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyConjugation -> True,
				DetectionAntibodyVolume -> 1000Microliter,
				BiotinReagentVolume -> 200Microliter,
				DetectionAntibodyPurificationColumn -> Model[Container, Vessel, Filter, "Zeba Spin Desalting Columns, 40K MWCO, 0.5 mL"]
			],
			$Failed,
			Messages :> {
				Error::ExceedDetectionAntibodyPurificationColumnCapacity,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooHighCaptureAntibodyDilution", "The specified CaptureAntibodyTargetConcentration cannot be higher than the CaptureAntibodyResuspensionConcentration:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
				CaptureAntibodyResuspension -> True,
				CaptureAntibodyResuspensionConcentration -> 100Microgram / Milliliter,
				CaptureAntibodyTargetConcentration -> 200Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::TooHighCaptureAntibodyDilution,
				Warning::NonOptimalCaptureAntibodyDilution,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "TooHighDetectionAntibodyDilution", "The specified DetectionAntibodyTargetConcentration cannot be higher than the DetectionAntibodyResuspensionConcentration:"},
			ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
				DetectionAntibodyResuspension -> True,
				DetectionAntibodyResuspensionConcentration -> 100Microgram / Milliliter,
				DetectionAntibodyTargetConcentration -> 200Microgram / Milliliter
			],
			$Failed,
			Messages :> {
				Error::TooHighDetectionAntibodyDilution,
				Warning::NonOptimalDetectionAntibodyDilution,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalCaptureAntibodyDilution", "The specified CaptureAntibodyTargetConcentration should not be higher than 50 Microgram/Milliliter for the best ELISA results:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomCaptureAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
				CaptureAntibodyTargetConcentration -> 60Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, CaptureAntibodyTargetConcentration],
			60Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalCaptureAntibodyDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "NonOptimalDetectionAntibodyDilution", "The specified DetectionAntibodyTargetConcentration cannot be higher than the DetectionAntibodyResuspensionConcentration:"},
			options = ExperimentCapillaryELISA[Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
				CustomDetectionAntibody -> Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
				DetectionAntibodyTargetConcentration -> 60Microgram / Milliliter,
				Output -> Options
			];
			Lookup[options, DetectionAntibodyTargetConcentration],
			60Microgram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {
				Warning::NonOptimalDetectionAntibodyDilution
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		],
		Example[{Messages, "CapillaryELISAConflictingStorageConditions", "If the same object is used more than once in the experiment, same storage condition should be used:"},
			ExperimentCapillaryELISA[
				{
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
					Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID]
				},
				SamplesInStorageCondition -> {Freezer, AmbientStorage}
			],
			$Failed,
			Messages :> {
				Error::CapillaryELISAConflictingStorageConditions,
				Error::InvalidOption
			},
			Stubs :> {
				Search[Object[ManufacturingSpecification, CapillaryELISACartridge]] = {}
			}
		]
	},
	Parallel->True,
	(* NOTE: We have to turn these messages off in our SetUp as well since our tests run in parallel on Manifold. *)
	SetUp:> {
		$CreatedObjects = {};
		(* Turn off the SamplesOutOfStock and DeprecatedProduct warnings for unit tests. This is because we use Zeba spin columns in our experiment. The product is tracked and ordered through the storage buffer inside. It is stocked at ECL so there should not be a case that *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
	},
	TearDown :> {
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects];

		(* Turn Warnings back on *)
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
	},
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISA tests" <> $SessionUUID],

						(* Instrument *)
						Model[Instrument, CapillaryELISA, "Test CapillaryELISA instrument model for ExperimentCapillaryELISA tests" <> $SessionUUID],
						Object[Instrument, CapillaryELISA, "Test CapillaryELISA instrument object for ExperimentCapillaryELISA tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 3 for test sample 3 with pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 4 for test sample 4 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 5 for test sample 5 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 6 for test sample 6 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 7 for test sample 7 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 8 for test sample 8 (discarded) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 9 for test sample 9 (large volume) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 10 for test sample 10 (semi-large volume) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container for pre-loaded analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 2" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 3" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 4" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 5" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 6" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 4" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 6" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 7" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 8" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 9" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 10" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 11" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 2" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 3" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 4" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 5" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 6" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 7" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 8" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 9" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 10" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 11" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 12" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 13" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 2" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 3" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 4" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 5" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 6" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 3 with pre-loaded analytes" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 4 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 5 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 3 with pre-loaded analytes" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 4 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 5 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 6 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 8 without pre-loaded analyte (discarded)" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 9 without pre-loaded analyte (large volume)" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 10 without pre-loaded analyte (semi-large volume)" <> $SessionUUID],

						(* Pre-loaded Analyte Sample Model and Object *)
						Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte sample 1" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 3" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 2" <> $SessionUUID],


						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 7" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 8" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 2" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 3" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 4" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 6" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  diluent model 2" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1 (discarded)" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],

						(* Test Protocol *)
						Object[Protocol, CapillaryELISA, "Test CapillaryELISA Instrument option template protocol" <> $SessionUUID],

						(* Test Product *)
						Object[Product,"Test Product for CapELISA Sample model 1 " <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];

		(* Turn off the SamplesOutOfStock and DeprecatedProduct warnings for unit tests. This is because we use Zeba spin columns in our experiment. The product is tracked and ordered through the storage buffer inside. It is stocked at ECL so there should not be a case that *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench,
					testInstrumentModel, testInstrument,
					container1, container2, container3, container4, container5, container6, container7, container8, container9, container10, diluentContainer1, diluentContainer2, antibodyContainer1, antibodyContainer2, antibodyContainer3, antibodyContainer4, antibodyContainer5, antibodyContainer6, preloadedAnalyteSampleContainer, analyteSampleContainer1, analyteSampleContainer2,
					testDiluentModel1, testDiluentModel2, testAnalyteModel1, testAnalyteModel2, testAnalyteModel3, testAntibodyModel1, testAntibodyModel2, testAntibodyModel3, testAntibodyModel4, testAntibodyModel5, testAntibodyModel6, testAntibodyModel7, testAntibodyModel8,
					preloadedAnalyte1, preloadedAnalyte2, preloadedAnalyte3, preloadedAnalyte4, preloadedAnalyte5, preloadedAnalyte6, preloadedAnalyte7, preloadedAnalyte8, preloadedAnalyte9, preloadedAnalyte10, preloadedAnalyte11,
					customizableAnalyte1, customizableAnalyte2, antibodyMolecule1, antibodyMolecule2, antibodyMolecule3, antibodyMolecule4, antibodyMolecule5, antibodyMolecule6,
					preloadedAnalyteManufacturingSpecification1, preloadedAnalyteManufacturingSpecification2, preloadedAnalyteManufacturingSpecification3, preloadedAnalyteManufacturingSpecification4, preloadedAnalyteManufacturingSpecification5, preloadedAnalyteManufacturingSpecification6, preloadedAnalyteManufacturingSpecification7, preloadedAnalyteManufacturingSpecification8, preloadedAnalyteManufacturingSpecification9, preloadedAnalyteManufacturingSpecification10, preloadedAnalyteManufacturingSpecification11, preloadedAnalyteManufacturingSpecification12, preloadedAnalyteManufacturingSpecification13,
					cartridgeModel1, cartridgeModel2, cartridgeModel3, cartridgeObject1, cartridgeObject1discarded, cartridgeObject2,
					testSampleModel1, testSampleModel2, testSampleModel3, testSampleModel4, testSampleModel5, preloadedAnalyteModel, testSample1, testSample2,
					testSample3, testSample4, testSample5, testSample6, testSample7, testSample8, testSample9, testSample10, testDiluent1, preloadedAnalyteSample,
					analyteStandardSample1, analyteStandardSample2, antibodySample1, antibodySample2, antibodySample3, antibodySample4, antibodySample5,
					antibodySample6,	antibodyMoleculePacket1,
					antibodyMoleculePacket2, antibodyMoleculePacket3, antibodyMoleculePacket4, antibodyMoleculePacket5, antibodyMoleculePacket6,
					testSampleModelPacket1, testSampleModelPacket2, testSampleModelPacket3, testSampleModelPacket4, testSampleModelPacket5, testProduct1,
					allDeveloperObjects
				},

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentCapillaryELISA tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				(* set up test instrument model and object *)
				testInstrumentModel = Upload[
					<|
						Type -> Model[Instrument, CapillaryELISA],
						Name -> "Test CapillaryELISA instrument model for ExperimentCapillaryELISA tests" <> $SessionUUID,
						Deprecated -> True
					|>
				];

				testInstrument = Upload[
					<|
						Type -> Object[Instrument, CapillaryELISA],
						Model -> Link[Model[Instrument, CapillaryELISA, "Test CapillaryELISA instrument model for ExperimentCapillaryELISA tests" <> $SessionUUID], Objects],
						Name -> "Test CapillaryELISA instrument object for ExperimentCapillaryELISA tests" <> $SessionUUID,
						Status -> Retired,
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					antibodyContainer1,
					antibodyContainer2,
					antibodyContainer3,
					antibodyContainer4,
					antibodyContainer5,
					antibodyContainer6,
					preloadedAnalyteSampleContainer,
					analyteSampleContainer1,
					analyteSampleContainer2,
					diluentContainer1,
					container9,
					container10
				} = UploadSample[
					Join[ConstantArray[Model[Container, Vessel, "2mL Tube"], 17],{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "Amber Glass Bottle 4 L"], Model[Container, Vessel, "50mL Tube"]}],
					ConstantArray[{"Work Surface", testBench}, 20],
					Status -> ConstantArray[Available, 20],
					Name -> {
						"ExperimentCapillaryELISA test  container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 3 for test sample 3 with pre-loaded analytes" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 4 for test sample 4 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 5 for test sample 5 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 6 for test sample 6 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 7 for test sample 7 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 8 for test sample 8 (discarded) without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 2" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 3" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 4" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 5" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample container 6" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container for pre-loaded analyte sample" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 1 for customizable analyte sample" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 2 for customizable analyte sample" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container for pre-loaded diluent 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 9 for test sample 9 (large volume) without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  container 10 for test sample 10 (semi-large volume) without pre-loaded analyte" <> $SessionUUID
					}
				];

				{
					testDiluentModel1,
					testDiluentModel2,
					testAnalyteModel1,
					testAnalyteModel2,
					testAnalyteModel3,
					testAntibodyModel1,
					testAntibodyModel2,
					testAntibodyModel3,
					testAntibodyModel4,
					testAntibodyModel5,
					testAntibodyModel6,
					testAntibodyModel7,
					testAntibodyModel8
				} = Upload[{
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  diluent model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Solid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  customizable analyte model 3" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Solid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Solid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 7" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>,
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  antibody model 8" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid
					|>
				}];

				(* Make some analytes *)
				{
					preloadedAnalyte1,
					preloadedAnalyte2,
					preloadedAnalyte3,
					preloadedAnalyte4,
					preloadedAnalyte5,
					preloadedAnalyte6,
					preloadedAnalyte7,
					preloadedAnalyte8,
					preloadedAnalyte9,
					preloadedAnalyte10,
					preloadedAnalyte11,
					(* Customizable Analyte and Antibodies - This is very special because we are not going to make these Model[Molecule]s DeveloperObject. This is because we want the resource picking to recognize this in a Non-DeveloperSearch. *)
					(* We do not use an existing REAL analyte and/or antibodies because they may become pre-loaded antibodies in the future and that will mess up our cartridge resolver. *)
					(* since $DeveloperObject is switched on, We'll Upload DeveloperObject -> Null later *)
					customizableAnalyte1,
					customizableAnalyte2
				} = UploadProtein[
					{
						"ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 4" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 6" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 7" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 8" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 9" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 10" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte 11" <> $SessionUUID,
						"ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					DefaultSampleModel -> {Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, testAnalyteModel1, testAnalyteModel2}
				];

				(* Make Antibodies for Customizable Analyte *)
				{
					antibodyMoleculePacket1,
					antibodyMoleculePacket2
				} = UploadAntibody[
					{
						"ExperimentCapillaryELISA test  antibody identity model 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody identity model 2" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Targets -> {customizableAnalyte1},
					Clonality -> {Polyclonal, Monoclonal},
					DefaultSampleModel -> {testAntibodyModel1, testAntibodyModel2},
					AssayTypes -> {ELISA},
					Upload -> False
				];
				{
					antibodyMoleculePacket3,
					antibodyMoleculePacket4
				} = UploadAntibody[
					{
						"ExperimentCapillaryELISA test  antibody identity model 3" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody identity model 4" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Targets -> {customizableAnalyte2},
					Clonality -> {Polyclonal, Monoclonal},
					DefaultSampleModel -> {testAntibodyModel3, testAntibodyModel4},
					Upload -> False
				];
				{antibodyMoleculePacket5} = UploadAntibody[
					"ExperimentCapillaryELISA test  antibody identity model 5" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Clonality -> Polyclonal,
					SecondaryAntibodies -> {Model[Molecule, Protein, Antibody, "Anti-Digoxigenin Antibody"]},
					AssayTypes -> {ELISA},
					Upload -> False
				];
				{antibodyMoleculePacket6} = UploadAntibody[
					"ExperimentCapillaryELISA test  antibody identity model 6" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Clonality -> Monoclonal,
					Targets -> {Model[Molecule, Protein, "Streptavidin"]},
					AssayTypes -> {ELISA},
					Upload -> False
				];

				{
					antibodyMolecule1,
					antibodyMolecule2,
					antibodyMolecule3,
					antibodyMolecule4,
					antibodyMolecule5,
					antibodyMolecule6
				} = Upload[{
					antibodyMoleculePacket1,
					antibodyMoleculePacket2,
					antibodyMoleculePacket3,
					antibodyMoleculePacket4,
					antibodyMoleculePacket5,
					antibodyMoleculePacket6
				}];

				(* Make Manufacturing Specifications *)
				{
					preloadedAnalyteManufacturingSpecification1,
					preloadedAnalyteManufacturingSpecification2,
					preloadedAnalyteManufacturingSpecification3,
					preloadedAnalyteManufacturingSpecification4,
					preloadedAnalyteManufacturingSpecification5,
					preloadedAnalyteManufacturingSpecification6,
					preloadedAnalyteManufacturingSpecification7,
					preloadedAnalyteManufacturingSpecification8,
					preloadedAnalyteManufacturingSpecification9,
					preloadedAnalyteManufacturingSpecification10,
					preloadedAnalyteManufacturingSpecification11,
					preloadedAnalyteManufacturingSpecification12
				} = Upload[
					Join[
						MapThread[
							<|
								Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
								Name -> #1,
								AnalyteName -> #2,
								AnalyteMolecule -> Link[#3],
								Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
								Species -> Human,
								RecommendedMinDilutionFactor -> 0.5,
								RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
								UpperQuantitationLimit -> 4000Picogram / Milliliter,
								LowerQuantitationLimit -> 1Picogram / Milliliter
							|>&,
							{
								{
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 2" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 3" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 4" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 5" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 6" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 7" <> $SessionUUID,
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 8" <> $SessionUUID,
									(* This is a repeated analyte manufacturing specification *)
									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 9" <> $SessionUUID
								},
								(* We have to randomly select some analyte names for our test manufacturing specifications *)
								{"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4", "IL-5", "IL-6", "IL-7", "IL-10", "IL-11"},
								{
									preloadedAnalyte1,
									preloadedAnalyte2,
									preloadedAnalyte3,
									preloadedAnalyte4,
									preloadedAnalyte5,
									preloadedAnalyte6,
									preloadedAnalyte7,
									preloadedAnalyte8,
									preloadedAnalyte1
								}
							}
						],
						{
							(* For the wrong CartridgeType test *)
							<|
								Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
								Name -> "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 10" <> $SessionUUID,
								AnalyteName -> "IFN-gamma",
								AnalyteMolecule -> Link[preloadedAnalyte9],
								Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4},
								Species -> Human,
								RecommendedMinDilutionFactor -> 0.5,
								RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
								UpperQuantitationLimit -> 4000Picogram / Milliliter,
								LowerQuantitationLimit -> 1Picogram / Milliliter
							|>,
							(* For the non-compatible min dilution factor test *)
							<|
								Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
								Name -> "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 11" <> $SessionUUID,
								AnalyteName -> "AFP",
								AnalyteMolecule -> Link[preloadedAnalyte10],
								Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
								Species -> Human,
								RecommendedMinDilutionFactor -> 0.1,
								RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
								UpperQuantitationLimit -> 4000Picogram / Milliliter,
								LowerQuantitationLimit -> 1Picogram / Milliliter
							|>,
							(* For the non-compatible diluent test *)
							<|
								Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
								Name -> "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 12" <> $SessionUUID,
								AnalyteName -> "BAFF",
								AnalyteMolecule -> Link[preloadedAnalyte11],
								Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
								Species -> Human,
								RecommendedMinDilutionFactor -> 0.5,
								RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISA test  diluent model 2" <> $SessionUUID]],
								UpperQuantitationLimit -> 4000Picogram / Milliliter,
								LowerQuantitationLimit -> 1Picogram / Milliliter
							|>
						}
					]
				];

				(* Incompatible Analyte *)
				preloadedAnalyteManufacturingSpecification13 = Upload[<|
					Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
					Name -> "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 13" <> $SessionUUID,
					AnalyteName -> "CA9",
					AnalyteMolecule -> Link[preloadedAnalyte8],
					Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
					Species -> Human,
					RecommendedMinDilutionFactor -> 0.5,
					RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID]],
					Replace[IncompatibleAnalytes] -> {Link[Object[ManufacturingSpecification, CapillaryELISACartridge, 									"ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 7" <> $SessionUUID], IncompatibleAnalytes]},
					UpperQuantitationLimit -> 4000Picogram / Milliliter,
					LowerQuantitationLimit -> 1Picogram / Milliliter
				|>];

				(* Make Cartridges *)
				{
					cartridgeModel1,
					cartridgeModel2,
					cartridgeModel3
				} = Upload[
					{
						<|
							Type -> Model[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
							Replace[AnalyteNames] -> {"IL-1-alpha"},
							Replace[AnalyteMolecules] -> {Link[preloadedAnalyte1]},
							MaxNumberOfSamples -> 72,
							CartridgeType -> SinglePlex72X1,
							MinBufferVolume -> 10.0Milliliter,
							MaxCentrifugationForce -> 0 GravitationalAcceleration
						|>,
						<|
							Type -> Model[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID,
							Replace[AnalyteNames] -> {"IL-1-alpha", "IL-1-beta", "IL-2", "IL-4"},
							Replace[AnalyteMolecules] -> {Link[preloadedAnalyte1], Link[preloadedAnalyte2], Link[preloadedAnalyte3], Link[preloadedAnalyte4]},
							MaxNumberOfSamples -> 32,
							CartridgeType -> MultiAnalyte32X4,
							MinBufferVolume -> 16.0Milliliter,
							MaxCentrifugationForce -> 0 GravitationalAcceleration
						|>,

						(* long lead time warning *)
						<|
							Type -> Model[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID,
							Replace[AnalyteNames] -> {"IL-1-beta"},
							Replace[AnalyteMolecules] -> {Link[preloadedAnalyte2]},
							MaxNumberOfSamples -> 72,
							CartridgeType -> SinglePlex72X1,
							MinBufferVolume -> 10.0Milliliter,
							MaxCentrifugationForce -> 0 GravitationalAcceleration
						|>
					}
				];

				(* Make Available Cartridge Objects for our pre-loaded cartridge model so it can be searched in resolver. Make sure to include DeveloperSearch for these *)
				{
					cartridgeObject1,
					cartridgeObject1discarded,
					cartridgeObject2
				} = Upload[
					{
						<|
							Type -> Object[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID,
							Model -> Link[cartridgeModel1, Objects],
							Status -> Available,
							Site -> Link[$Site]
						|>,
						<|
							Type -> Object[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1 (discarded)" <> $SessionUUID,
							Model -> Link[cartridgeModel1, Objects],
							Status -> Discarded,
							Site -> Link[$Site]
						|>,
						<|
							Type -> Object[Container, Plate, Irregular, CapillaryELISA],
							Name -> "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID,
							Model -> Link[cartridgeModel2, Objects],
							Status -> Available,
							Site -> Link[$Site]
						|>
					}
				];

				(* Make some test sample models *)
				{
					testSampleModelPacket1,
					testSampleModelPacket2,
					testSampleModelPacket3,
					testSampleModelPacket4,
					testSampleModelPacket5
				} = UploadSampleModel[
					{
						"ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample model 3 with pre-loaded analytes" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample model 4 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample model 5 without pre-loaded analyte" <> $SessionUUID
					},
					Composition -> {
						{{1000Picogram / Milliliter, preloadedAnalyte1}, {100VolumePercent, Model[Molecule, "Water"]}},
						{{1000Picogram / Milliliter, customizableAnalyte1}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1000Picogram / Milliliter, preloadedAnalyte1}, {1000Picogram / Milliliter, preloadedAnalyte2}, {1000Picogram / Milliliter, preloadedAnalyte3}, {1000Picogram / Milliliter, preloadedAnalyte4}, {100VolumePercent, Model[Molecule, "Water"]}},
						{{1000Picogram / Milliliter, preloadedAnalyte2}, {100VolumePercent, Model[Molecule, "Water"]}},
						{{1000Picogram / Milliliter, customizableAnalyte2}, {100 VolumePercent, Model[Molecule, "Water"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid,
					Upload -> False
				];

				{
					testSampleModel1,
					testSampleModel2,
					testSampleModel3,
					testSampleModel4,
					testSampleModel5
				} = Upload[{
					testSampleModelPacket1,
					testSampleModelPacket2,
					testSampleModelPacket3,
					testSampleModelPacket4,
					testSampleModelPacket5
				}];

				Upload[{
					<|Object -> testSampleModel1, Replace[Analytes] -> {Link[preloadedAnalyte1]}|>,
					<|Object -> testSampleModel2, Replace[Analytes] -> {Link[customizableAnalyte1]}|>,
					<|Object -> testSampleModel3, Replace[Analytes] -> {Link[preloadedAnalyte1], Link[preloadedAnalyte2], Link[preloadedAnalyte3], Link[preloadedAnalyte4]}|>,
					<|Object -> testSampleModel4, Replace[Analytes] -> {Link[preloadedAnalyte2]}|>,
					<|Object -> testSampleModel5, Replace[Analytes] -> {Link[customizableAnalyte2]}|>
				}];



				(* Create the Preloaded Analyte Sample *)
				preloadedAnalyteModel = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Solid,
						Replace[Composition] -> {{100MassPercent, Link[preloadedAnalyte1]}}
					|>
				];

				(* Upload Composition information for the DefaultSampleModel of Customizable Analyte and Antibodies *)
				Upload[
					{
						<|
							Object -> testAnalyteModel1,
							Replace[Composition] -> {{200Microgram / Milliliter, Link[customizableAnalyte1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
						|>,
						<|
							Object -> testAnalyteModel2,
							Replace[Composition] -> {{100MassPercent, Link[customizableAnalyte2]}}
						|>,
						(* Upload the composition without concentration for some tests *)
						<|
							Object -> testAnalyteModel3,
							Replace[Composition] -> {{Null, Link[customizableAnalyte1]}}
						|>,
						<|
							Object -> testAntibodyModel1,
							Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
						|>,
						<|
							Object -> testAntibodyModel2,
							Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule2]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
						|>,
						<|
							Object -> testAntibodyModel3,
							Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule3]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
						|>,
						<|
							Object -> testAntibodyModel4,
							Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule4]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
						|>,
						<|
							Object -> testAntibodyModel5,
							Replace[Composition] -> {{100MassPercent, Link[antibodyMolecule5]}}
						|>,
						<|
							Object -> testAntibodyModel6,
							Replace[Composition] -> {{100MassPercent, Link[antibodyMolecule6]}}
						|>,
						<|
							Object -> testAntibodyModel7,
							Replace[Composition] -> {{Null, Link[antibodyMolecule1]}}
						|>,
						<|
							Object -> testAntibodyModel8,
							Replace[Composition] -> {{Null, Link[antibodyMolecule2]}}
						|>,

						(* Make a test protocol for the Template option unit test *)
						<|
							Type -> Object[Protocol, CapillaryELISA],
							DeveloperObject -> True,
							Name -> "Test CapillaryELISA Instrument option template protocol" <> $SessionUUID,
							ResolvedOptions -> {Instrument -> Object[Instrument, CapillaryELISA, "id:pZx9jo8Le044"]}
						|>
					}
				];

				(* Make some test sample objects in the test container objects *)
				{
					testSample1,
					testSample2,
					testSample3,
					testSample4,
					testSample5,
					testSample6,
					testSample7,
					testSample8,
					testSample9,
					testSample10,
					testDiluent1,
					preloadedAnalyteSample,
					analyteStandardSample1,
					analyteStandardSample2,
					antibodySample1,
					antibodySample2,
					antibodySample3,
					antibodySample4,
					antibodySample5,
					antibodySample6
				} = UploadSample[
					{
						Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 3 with pre-loaded analytes" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 4 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 5 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", container10},
						{"A1", diluentContainer1},
						{"A1", preloadedAnalyteSampleContainer},
						{"A1", analyteSampleContainer1},
						{"A1", analyteSampleContainer2},
						{"A1", antibodyContainer1},
						{"A1", antibodyContainer2},
						{"A1", antibodyContainer3},
						{"A1", antibodyContainer4},
						{"A1", antibodyContainer5},
						{"A1", antibodyContainer6}
					},
					Name -> {
						"ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 3 with pre-loaded analytes" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 4 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 5 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 6 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 8 without pre-loaded analyte (discarded)" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 9 without pre-loaded analyte (large volume)" <> $SessionUUID,
						"ExperimentCapillaryELISA test  sample 10 without pre-loaded analyte (semi-large volume)" <> $SessionUUID,
						"ExperimentCapillaryELISA test  diluent object 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  pre-loaded analyte sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  customizable analyte sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  customizable analyte sample 2" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 2" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 3" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 4" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID,
						"ExperimentCapillaryELISA test  antibody sample 6" <> $SessionUUID
					},
					InitialAmount -> {1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1Liter, 20Milliliter, 40Milliliter, 1Gram, 1.8Milliliter, 1Gram, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 1.8Milliliter, 500Microgram, 500Microgram}
				];

				(* Create a test product for model input testing *)
				testProduct1 = UploadProduct[
					Name->"Test Product for CapELISA Sample model 1 " <> $SessionUUID,
					ProductModel->Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
					CatalogDescription -> "Test Description",
					(* Just say were from VWR so we don't also have to make a test supplier *)
					Supplier->Object[Company,Supplier,"id:kEJ9mqaVz5Op"],
					CatalogNumber->"1",
					Packaging->Single,
					NumberOfItems->1,
					ProductURL->"www.testURL.com",
					SampleType->Vial,
					DefaultContainerModel->Model[Container,Vessel,"2mL Tube"],
					Amount->2Milliliter,
					Price->1USD
				];

				(* make these objects Non-Developer *)
				Upload[<|Object -> #, DeveloperObject -> Null|>& /@ {analyteStandardSample1, analyteStandardSample2, testSample2, testSample8, testSample9, testSample10, antibodySample1, antibodySample2, antibodySample3, antibodySample4, antibodySample5, antibodySample6}];

				(* Make our discarded sample Discarded *)
				Upload[
					<|
						Object -> testSample8,
						Status -> Discarded
					|>
				];

			]
		]
	},


	SymbolTearDown :> (
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISA tests" <> $SessionUUID],

						(* Instrument *)
						Model[Instrument, CapillaryELISA, "Test CapillaryELISA instrument model for ExperimentCapillaryELISA tests" <> $SessionUUID],
						Object[Instrument, CapillaryELISA, "Test CapillaryELISA instrument object for ExperimentCapillaryELISA tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 3 for test sample 3 with pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 4 for test sample 4 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 5 for test sample 5 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 6 for test sample 6 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 7 for test sample 7 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 8 for test sample 8 (discarded) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 9 for test sample 9 (large volume) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 10 for test sample 10 (semi-large volume) without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container for pre-loaded analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  container 2 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 2" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 3" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 4" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 5" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISA test  antibody sample container 6" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 1" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 2" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 3" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 4" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 5" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 6" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 7" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 8" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 9" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 10" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  pre-loaded analyte 11" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 1" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 2" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 3" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 4" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 5" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 6" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 7" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 8" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 9" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 10" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 11" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 12" <> $SessionUUID],
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISA test  pre-loaded analyte manufacturing specification 13" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 1" <> $SessionUUID],
						Model[Molecule, Protein, "ExperimentCapillaryELISA test  customizable analyte 2" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 2" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 3" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 4" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 5" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISA test  antibody identity model 6" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISA test  sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 3 with pre-loaded analytes" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 4 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  sample model 5 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 3 with pre-loaded analytes" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 4 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 5 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 6 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 7 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 8 without pre-loaded analyte (discarded)" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 9 without pre-loaded analyte (large volume)" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  sample 10 without pre-loaded analyte (semi-large volume)" <> $SessionUUID],

						(* Pre-loaded Analyte Sample Model and Object *)
						Model[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte model 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  pre-loaded analyte sample 1" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  customizable analyte model 3" <> $SessionUUID],


						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  customizable analyte sample 2" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 2" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 3" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 4" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 5" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 6" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 7" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  antibody model 8" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 2" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 3" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 4" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 5" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISA test  antibody sample 6" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISA test  diluent model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISA test  diluent model 2" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISA test  diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 2" <> $SessionUUID],
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge model for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1 (discarded)" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISA MultiAnalyte32X4 test pre-loaded cartridge for pre-loaded analytes 1, 2, 3 and 4" <> $SessionUUID],

						(* Test Protocol *)
						Object[Protocol, CapillaryELISA, "Test CapillaryELISA Instrument option template protocol" <> $SessionUUID],

						(* Test Product *)
						Object[Product,"Test Product for CapELISA Sample model 1 " <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			(* Turn on the SamplesOutOfStock and DeprecatedProduct warning *)
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::DeprecatedProduct];
		]
	),

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}

];



(* ::Subsection::Closed:: *)
(*ValidExperimentCapillaryELISAQ*)


DefineTests[
	ValidExperimentCapillaryELISAQ,
	{
		Example[{Basic, "Returns a Boolean indicating the validity of a capillary ELISA experiment with a customizable cartridge:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ValidExperimentCapillaryELISAQ test sample 2 without pre-loaded analyte" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a capillary ELISA experiment with a pre-loaded cartridge:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ValidExperimentCapillaryELISAQ test sample 1 with pre-loaded analyte" <> $SessionUUID]],
			True,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = "ValidExperimentCapillaryELISAQ"
			}
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID]],
			False
		],
		Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID],
				Verbose -> True
			],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},
	SymbolSetUp :> (

		Module[{allObjects, existingObjects},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ValidExperimentCapillaryELISAQ tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ValidExperimentCapillaryELISAQ test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ValidExperimentCapillaryELISAQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ValidExperimentCapillaryELISAQ test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ValidExperimentCapillaryELISAQ test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ValidExperimentCapillaryELISAQ test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 1" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
		];

		(* Turn off the SamplesOutOfStock and DeprecatedProduct warnings for unit tests. This is because we use Zeba spin columns in our experiment. The product is tracked and ordered through the storage buffer inside. It is stocked at ECL so there should not be a case that *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					testBench,
					container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
					testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
					preloadedAnalyte1,
					customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
					preloadedAnalyteManufacturingSpecification1,
					cartridgeModel1, cartridgeObject1,
					testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2,
					allDeveloperObjects
				},

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ValidExperimentCapillaryELISAQ tests" <> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site],
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				{
					container1,
					container2,
					container3,
					antibodyContainer1,
					antibodyContainer2,
					analyteSampleContainer1
				} = UploadSample[
					ConstantArray[Model[Container, Vessel, "2mL Tube"], 6],
					ConstantArray[{"Work Surface", testBench}, 6],
					Status -> ConstantArray[Available, 6],
					Name -> {
						"ValidExperimentCapillaryELISAQ test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test antibody sample container 1" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test antibody sample container 2" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test container 1 for customizable analyte sample" <> $SessionUUID
					}
				];

				diluentContainer1 = UploadSample[
					Model[Container, Vessel, "50mL Tube"],
					{"Work Surface", testBench},
					Status -> Available,
					Name -> "ValidExperimentCapillaryELISAQ test container for pre-loaded diluent 1" <> $SessionUUID
				];

				testDiluentModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ValidExperimentCapillaryELISAQ test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAnalyteModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ValidExperimentCapillaryELISAQ test customizable analyte model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAntibodyModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ValidExperimentCapillaryELISAQ test antibody model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];
				testAntibodyModel2 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ValidExperimentCapillaryELISAQ test antibody model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				(* Make some analytes *)
				preloadedAnalyte1 = UploadProtein[
					"ValidExperimentCapillaryELISAQ test pre-loaded analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False
				];

				(* Customizable Analyte and Antibodies - This is very special because we are not going to make these Model[Molecule]s Non-DeveloperObject. This is because we want the resource picking to recognize this in a Non-DeveloperSearch. *)
				(* We do not use an existing REAL analyte and/or antibodies because they may become pre-loaded antibodies in the future and that will mess up our cartridge resolver. *)
				customizableAnalyte1 = UploadProtein[
					"ValidExperimentCapillaryELISAQ test customizable analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					DefaultSampleModel -> testAnalyteModel1
				];

				(* Make Antibodies for Customizable Analyte *)
				{
					antibodyMolecule1,
					antibodyMolecule2
				} = UploadAntibody[
					{
						"ValidExperimentCapillaryELISAQ test antibody identity model 1" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test antibody identity model 2" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Targets -> {customizableAnalyte1},
					Clonality -> {Polyclonal, Monoclonal},
					DefaultSampleModel -> {testAntibodyModel1, testAntibodyModel2}
				];

				Upload[<|Object -> #, Replace[AssayTypes] -> {ELISA}|>]& /@ {antibodyMolecule1, antibodyMolecule2};

				(* Make Manufacturing Specifications *)
				preloadedAnalyteManufacturingSpecification1 = Upload[
					<|
						Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
						Name -> "ValidExperimentCapillaryELISAQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
						AnalyteName -> "IL-1-alpha",
						AnalyteMolecule -> Link[preloadedAnalyte1],
						Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
						Species -> Human,
						RecommendedMinDilutionFactor -> 0.5,
						RecommendedDiluent -> Link[Model[Sample, "ValidExperimentCapillaryELISAQ test diluent model 1" <> $SessionUUID]],
						UpperQuantitationLimit -> 4000Picogram / Milliliter,
						LowerQuantitationLimit -> 1Picogram / Milliliter
					|>
				];

				(* Make Cartridges *)
				cartridgeModel1 = Upload[
					<|
						Type -> Model[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames] -> {"IL-1-alpha"},
						Replace[AnalyteMolecules] -> {Link[preloadedAnalyte1]},
						MaxNumberOfSamples -> 72,
						CartridgeType -> SinglePlex72X1,
						MinBufferVolume -> 10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Make Available Cartridge Objects for our pre-loaded cartridge model so it can be searched in resolver. Make sure to include DeveloperSearch for these *)
				cartridgeObject1 = Upload[
					<|
						Type -> Object[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID,
						Model -> Link[cartridgeModel1, Objects],
						Site -> Link[$Site],
						Status -> Available
					|>
				];

				(* Make some test sample models *)
				testSampleModel1 = UploadSampleModel[
					"ValidExperimentCapillaryELISAQ test sample model 1 with pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, preloadedAnalyte1}, {100VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel1, Replace[Analytes] -> {Link[preloadedAnalyte1]}|>];

				testSampleModel2 = UploadSampleModel[
					"ValidExperimentCapillaryELISAQ test sample model 2 without pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, customizableAnalyte1}, {100 VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel2, Replace[Analytes] -> {Link[customizableAnalyte1]}|>];

				(* Upload Composition information for the DefaultSampleModel of Customizable Analyte and Antibodies *)
				Upload[
					<|
						Object -> testAnalyteModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[customizableAnalyte1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				Upload[
					<|
						Object -> testAntibodyModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];
				Upload[
					<|
						Object -> testAntibodyModel2,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule2]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				(* Make some test sample objects in the test container objects *)
				{
					testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2
				} = UploadSample[
					{
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test diluent model 1" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 1" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 2" <> $SessionUUID]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", diluentContainer1},
						{"A1", analyteSampleContainer1},
						{"A1", antibodyContainer1},
						{"A1", antibodyContainer2}
					},
					Name -> {
						"ValidExperimentCapillaryELISAQ test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test diluent object 1" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test customizable analyte sample 1" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test antibody sample 1" <> $SessionUUID,
						"ValidExperimentCapillaryELISAQ test antibody sample 2" <> $SessionUUID
					},
					InitialAmount -> {2Milliliter, 2Milliliter, 2Milliliter, 40Milliliter, 2Milliliter, 2Milliliter, 2Milliliter}
				];

				(* Make our discarded sample Discarded *)
				Upload[
					<|
						Object -> testSample3,
						Status -> Discarded
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects = Cases[
					Flatten[
						{
							testBench,
							container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
							testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
							preloadedAnalyte1,
							customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
							preloadedAnalyteManufacturingSpecification1,
							cartridgeModel1, cartridgeObject1,
							(* note that I'm commenting out analyteStandardSample1 and antibodySample1 and antibodySample2 on purpose because I don't want it to be a DeveloperObject so that I don't get FRQ errors *)
							testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1(*, analyteStandardSample1, antibodySample1, antibodySample2*)
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ allDeveloperObjects];

			]
		]
	),

	SymbolTearDown :> {
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ValidExperimentCapillaryELISAQ tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ValidExperimentCapillaryELISAQ test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ValidExperimentCapillaryELISAQ test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ValidExperimentCapillaryELISAQ test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ValidExperimentCapillaryELISAQ test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ValidExperimentCapillaryELISAQ test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ValidExperimentCapillaryELISAQ test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 1" <> $SessionUUID],
						Model[Sample, "ValidExperimentCapillaryELISAQ test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ValidExperimentCapillaryELISAQ test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ValidExperimentCapillaryELISAQ test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ValidExperimentCapillaryELISAQ test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ValidExperimentCapillaryELISAQ SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			(* Turn on the SamplesOutOfStock and DeprecatedProduct warning *)
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::DeprecatedProduct];
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*ExperimentCapillaryELISAOptions*)


DefineTests[
	ExperimentCapillaryELISAOptions,
	{
		Example[{Basic, "Display the option values which will be used in the capillary ELISA experiment with a customizable cartridge:"},
			ExperimentCapillaryELISAOptions[Object[Sample, "ExperimentCapillaryELISAOptions test sample 2 without pre-loaded analyte" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Display the option values which will be used in the capillary ELISA experiment with a pre-loaded cartridge:"},
			ExperimentCapillaryELISAOptions[Object[Sample, "ExperimentCapillaryELISAOptions test sample 1 with pre-loaded analyte" <> $SessionUUID]],
			_Grid,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = "ExperimentCapillaryELISAOptions"
			}
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentCapillaryELISAOptions[Object[Sample, "ExperimentCapillaryELISAOptions test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID]],
			_Grid,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentCapillaryELISAOptions[Object[Sample, "ExperimentCapillaryELISAOptions test sample 2 without pre-loaded analyte" <> $SessionUUID], OutputFormat -> List],
			{(_Rule | _RuleDelayed)..}
		]
	},
	SymbolSetUp :> {

		Module[{allObjects, existingObjects},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISAOptions tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAOptions test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISAOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAOptions test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAOptions test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAOptions test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISAOptions test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISAOptions test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
		];

		(* Turn off the SamplesOutOfStock and DeprecatedProduct warnings for unit tests. This is because we use Zeba spin columns in our experiment. The product is tracked and ordered through the storage buffer inside. It is stocked at ECL so there should not be a case that *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					testBench,
					container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
					testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
					preloadedAnalyte1,
					customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
					preloadedAnalyteManufacturingSpecification1,
					cartridgeModel1, cartridgeObject1,
					testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2,
					allDeveloperObjects
				},

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentCapillaryELISAOptions tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					container2,
					container3,
					antibodyContainer1,
					antibodyContainer2,
					analyteSampleContainer1
				} = UploadSample[
					ConstantArray[Model[Container, Vessel, "2mL Tube"], 6],
					ConstantArray[{"Work Surface", testBench}, 6],
					Status -> ConstantArray[Available, 6],
					Name -> {
						"ExperimentCapillaryELISAOptions test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test antibody sample container 1" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test antibody sample container 2" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test container 1 for customizable analyte sample" <> $SessionUUID
					}
				];

				diluentContainer1 = UploadSample[
					Model[Container, Vessel, "50mL Tube"],
					{"Work Surface", testBench},
					Status -> Available,
					Name -> "ExperimentCapillaryELISAOptions test container for pre-loaded diluent 1" <> $SessionUUID
				];

				testDiluentModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAOptions test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAnalyteModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAOptions test customizable analyte model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAntibodyModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAOptions test antibody model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];
				testAntibodyModel2 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAOptions test antibody model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				(* Make some analytes *)
				preloadedAnalyte1 = UploadProtein[
					"ExperimentCapillaryELISAOptions test pre-loaded analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False
				];

				(* Customizable Analyte and Antibodies - This is very special because we are not going to make these Model[Molecule]s Non-DeveloperObject. This is because we want the resource picking to recognize this in a Non-DeveloperSearch. *)
				(* We do not use an existing REAL analyte and/or antibodies because they may become pre-loaded antibodies in the future and that will mess up our cartridge resolver. *)
				customizableAnalyte1 = UploadProtein[
					"ExperimentCapillaryELISAOptions test customizable analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					DefaultSampleModel -> testAnalyteModel1
				];

				(* Make Antibodies for Customizable Analyte *)
				{
					antibodyMolecule1,
					antibodyMolecule2
				} = UploadAntibody[
					{
						"ExperimentCapillaryELISAOptions test antibody identity model 1" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test antibody identity model 2" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Targets -> {customizableAnalyte1},
					Clonality -> {Polyclonal, Monoclonal},
					DefaultSampleModel -> {testAntibodyModel1, testAntibodyModel2}
				];

				Upload[<|Object -> #, Replace[AssayTypes] -> {ELISA}|>]& /@ {antibodyMolecule1, antibodyMolecule2};

				(* Make Manufacturing Specifications *)
				preloadedAnalyteManufacturingSpecification1 = Upload[
					<|
						Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
						Name -> "ExperimentCapillaryELISAOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
						AnalyteName -> "IL-1-alpha",
						AnalyteMolecule -> Link[preloadedAnalyte1],
						Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
						Species -> Human,
						RecommendedMinDilutionFactor -> 0.5,
						RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISAOptions test diluent model 1" <> $SessionUUID]],
						UpperQuantitationLimit -> 4000Picogram / Milliliter,
						LowerQuantitationLimit -> 1Picogram / Milliliter
					|>
				];

				(* Make Cartridges *)
				cartridgeModel1 = Upload[
					<|
						Type -> Model[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames] -> {"IL-1-alpha"},
						Replace[AnalyteMolecules] -> {Link[preloadedAnalyte1]},
						MaxNumberOfSamples -> 72,
						CartridgeType -> SinglePlex72X1,
						MinBufferVolume -> 10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Make Available Cartridge Objects for our pre-loaded cartridge model so it can be searched in resolver. Make sure to include DeveloperSearch for these *)
				cartridgeObject1 = Upload[
					<|
						Type -> Object[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID,
						Model -> Link[cartridgeModel1, Objects],
						Status -> Available,
						Site -> Link[$Site]
					|>
				];

				(* Make some test sample models *)
				testSampleModel1 = UploadSampleModel[
					"ExperimentCapillaryELISAOptions test sample model 1 with pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, preloadedAnalyte1}, {100VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel1, Replace[Analytes] -> {Link[preloadedAnalyte1]}|>];

				testSampleModel2 = UploadSampleModel[
					"ExperimentCapillaryELISAOptions test sample model 2 without pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, customizableAnalyte1}, {100 VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel2, Replace[Analytes] -> {Link[customizableAnalyte1]}|>];

				(* Upload Composition information for the DefaultSampleModel of Customizable Analyte and Antibodies *)
				Upload[
					<|
						Object -> testAnalyteModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[customizableAnalyte1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				Upload[
					<|
						Object -> testAntibodyModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];
				Upload[
					<|
						Object -> testAntibodyModel2,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule2]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				(* Make some test sample objects in the test container objects *)
				{
					testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2
				} = UploadSample[
					{
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test diluent model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 2" <> $SessionUUID]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", diluentContainer1},
						{"A1", analyteSampleContainer1},
						{"A1", antibodyContainer1},
						{"A1", antibodyContainer2}
					},
					Name -> {
						"ExperimentCapillaryELISAOptions test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test sample 3 without pre-loaded analyte (discarded)" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test diluent object 1" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test customizable analyte sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test antibody sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISAOptions test antibody sample 2" <> $SessionUUID
					},
					InitialAmount -> {2Milliliter, 2Milliliter, 2Milliliter, 40Milliliter, 2Milliliter, 2Milliliter, 2Milliliter}
				];

				(* Make our discarded sample Discarded *)
				Upload[
					<|
						Object -> testSample3,
						Status -> Discarded
					|>
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects = Cases[
					Flatten[
						{
							testBench,
							container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
							testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
							preloadedAnalyte1,
							customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
							preloadedAnalyteManufacturingSpecification1,
							cartridgeModel1, cartridgeObject1,
							(* note that I'm commenting out analyteStandardSample1 and antibodySample1 and antibodySample2 on purpose because I don't want it to be a DeveloperObject so that I don't get FRQ errors *)
							testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1(*, analyteStandardSample1, antibodySample1, antibodySample2*)
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ allDeveloperObjects];

			]
		]
	},

	SymbolTearDown :> {
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISAOptions tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAOptions test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAOptions test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISAOptions test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAOptions test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAOptions test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAOptions test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test sample 3 without pre-loaded analyte"],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISAOptions test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISAOptions test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAOptions test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAOptions test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISAOptions test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISAOptions test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAOptions SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			(* Turn on the SamplesOutOfStock and DeprecatedProduct warning *)
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::DeprecatedProduct];
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*ExperimentCapillaryELISAPreview*)


DefineTests[
	ExperimentCapillaryELISAPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentCapillaryELISA:"},
			ExperimentCapillaryELISAPreview[Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID]],
			Null
		],
		Example[{Basic, "No preview is available for a pre-loaded capillary ELISA cartridge:"},
			ExperimentCapillaryELISAPreview[Object[Sample, "ExperimentCapillaryELISAPreview test sample 1 with pre-loaded analyte" <> $SessionUUID]],
			Null,
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = "ExperimentCapillaryELISAPreview"
			}
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentCapillaryELISAPreview[{Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID], Object[Sample, "ExperimentCapillaryELISAPreview test sample 3 without pre-loaded analyte" <> $SessionUUID]}],
			Null
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentCapillaryELISAOptions:"},
			ExperimentCapillaryELISAOptions[Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentCapillaryELISAQ:"},
			ValidExperimentCapillaryELISAQ[Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID]],
			True
		]
	},
	SymbolSetUp :> (

		Module[{allObjects, existingObjects},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISAPreview tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAPreview test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISAPreview test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAPreview test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAPreview test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAPreview test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 3 without pre-loaded analyte" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISAPreview test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISAPreview test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
		];

		(* Turn off the SamplesOutOfStock and DeprecatedProduct warnings for unit tests. This is because we use Zeba spin columns in our experiment. The product is tracked and ordered through the storage buffer inside. It is stocked at ECL so there should not be a case that *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					testBench,
					container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
					testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
					preloadedAnalyte1,
					customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
					preloadedAnalyteManufacturingSpecification1,
					cartridgeModel1, cartridgeObject1,
					testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2,
					allDeveloperObjects
				},

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentCapillaryELISAPreview tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					container2,
					container3,
					antibodyContainer1,
					antibodyContainer2,
					analyteSampleContainer1
				} = UploadSample[
					ConstantArray[Model[Container, Vessel, "2mL Tube"], 6],
					ConstantArray[{"Work Surface", testBench}, 6],
					Status -> ConstantArray[Available, 6],
					Name -> {
						"ExperimentCapillaryELISAPreview test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test antibody sample container 1" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test antibody sample container 2" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test container 1 for customizable analyte sample" <> $SessionUUID
					}
				];

				diluentContainer1 = UploadSample[
					Model[Container, Vessel, "50mL Tube"],
					{"Work Surface", testBench},
					Status -> Available,
					Name -> "ExperimentCapillaryELISAPreview test container for pre-loaded diluent 1" <> $SessionUUID
				];

				testDiluentModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAPreview test diluent model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAnalyteModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAPreview test customizable analyte model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				testAntibodyModel1 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAPreview test antibody model 1" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];
				testAntibodyModel2 = Upload[
					<|
						Type -> Model[Sample],
						Name -> "ExperimentCapillaryELISAPreview test antibody model 2" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
						State -> Liquid,
						Notebook->Null
					|>
				];

				(* Make some analytes *)
				preloadedAnalyte1 = UploadProtein[
					"ExperimentCapillaryELISAPreview test pre-loaded analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False
				];

				(* Customizable Analyte and Antibodies - This is very special because we are not going to make these Model[Molecule]s Non-DeveloperObject. This is because we want the resource picking to recognize this in a Non-DeveloperSearch. *)
				(* We do not use an existing REAL analyte and/or antibodies because they may become pre-loaded antibodies in the future and that will mess up our cartridge resolver. *)
				customizableAnalyte1 = UploadProtein[
					"ExperimentCapillaryELISAPreview test customizable analyte 1" <> $SessionUUID,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					DefaultSampleModel -> testAnalyteModel1
				];

				(* Make Antibodies for Customizable Analyte *)
				{
					antibodyMolecule1,
					antibodyMolecule2
				} = UploadAntibody[
					{
						"ExperimentCapillaryELISAPreview test antibody identity model 1" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test antibody identity model 2" <> $SessionUUID
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					ExpirationHazard -> False,
					Targets -> {customizableAnalyte1},
					Clonality -> {Polyclonal, Monoclonal},
					DefaultSampleModel -> {testAntibodyModel1, testAntibodyModel2}
				];

				Upload[<|Object -> #, Replace[AssayTypes] -> {ELISA}|>]& /@ {antibodyMolecule1, antibodyMolecule2};

				(* Make Manufacturing Specifications *)
				preloadedAnalyteManufacturingSpecification1 = Upload[
					<|
						Type -> Object[ManufacturingSpecification, CapillaryELISACartridge],
						Name -> "ExperimentCapillaryELISAPreview test pre-loaded analyte manufacturing specification 1" <> $SessionUUID,
						AnalyteName -> "IL-1-alpha",
						AnalyteMolecule -> Link[preloadedAnalyte1],
						Replace[CartridgeType] -> {SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4, MultiPlex32X8},
						Species -> Human,
						RecommendedMinDilutionFactor -> 0.5,
						RecommendedDiluent -> Link[Model[Sample, "ExperimentCapillaryELISAPreview test diluent model 1" <> $SessionUUID]],
						UpperQuantitationLimit -> 4000Picogram / Milliliter,
						LowerQuantitationLimit -> 1Picogram / Milliliter
					|>
				];

				(* Make Cartridges *)
				cartridgeModel1 = Upload[
					<|
						Type -> Model[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID,
						Replace[AnalyteNames] -> {"IL-1-alpha"},
						Replace[AnalyteMolecules] -> {Link[preloadedAnalyte1]},
						MaxNumberOfSamples -> 72,
						CartridgeType -> SinglePlex72X1,
						MinBufferVolume -> 10.0Milliliter,
						MaxCentrifugationForce -> 0 GravitationalAcceleration
					|>
				];

				(* Make Available Cartridge Objects for our pre-loaded cartridge model so it can be searched in resolver. Make sure to include DeveloperSearch for these *)
				cartridgeObject1 = Upload[
					<|
						Type -> Object[Container, Plate, Irregular, CapillaryELISA],
						Name -> "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID,
						Model -> Link[cartridgeModel1, Objects],
						Status -> Available,
						Site -> Link[$Site]
					|>
				];

				(* Make some test sample models *)
				testSampleModel1 = UploadSampleModel[
					"ExperimentCapillaryELISAPreview test sample model 1 with pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, preloadedAnalyte1}, {100VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel1, Replace[Analytes] -> {Link[preloadedAnalyte1]}|>];

				testSampleModel2 = UploadSampleModel[
					"ExperimentCapillaryELISAPreview test sample model 2 without pre-loaded analyte" <> $SessionUUID,
					Composition -> {{1000Picogram / Milliliter, customizableAnalyte1}, {100 VolumePercent, Model[Molecule, "Water"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					State -> Liquid
				];
				Upload[<|Object -> testSampleModel2, Replace[Analytes] -> {Link[customizableAnalyte1]}|>];

				(* Upload Composition information for the DefaultSampleModel of Customizable Analyte and Antibodies *)
				Upload[
					<|
						Object -> testAnalyteModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[customizableAnalyte1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				Upload[
					<|
						Object -> testAntibodyModel1,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule1]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];
				Upload[
					<|
						Object -> testAntibodyModel2,
						Replace[Composition] -> {{200Microgram / Milliliter, Link[antibodyMolecule2]}, {100VolumePercent, Link[Model[Molecule, "Water"]]}}
					|>
				];

				(* Make some test sample objects in the test container objects *)
				{
					testSample1, testSample2, testSample3, testDiluent1, analyteStandardSample1, antibodySample1, antibodySample2
				} = UploadSample[
					{
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 2 without pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test diluent model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test customizable analyte model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 2" <> $SessionUUID]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", diluentContainer1},
						{"A1", analyteSampleContainer1},
						{"A1", antibodyContainer1},
						{"A1", antibodyContainer2}
					},
					Name -> {
						"ExperimentCapillaryELISAPreview test sample 1 with pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test sample 3 without pre-loaded analyte" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test diluent object 1" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test customizable analyte sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test antibody sample 1" <> $SessionUUID,
						"ExperimentCapillaryELISAPreview test antibody sample 2" <> $SessionUUID
					},
					InitialAmount -> {2Milliliter, 2Milliliter, 2Milliliter, 40Milliliter, 2Milliliter, 2Milliliter, 2Milliliter}
				];

				(* Get all objects so we can make sure they are developer objects *)
				allDeveloperObjects = Cases[
					Flatten[
						{
							testBench,
							container1, container2, container3, diluentContainer1, antibodyContainer1, antibodyContainer2, analyteSampleContainer1,
							testDiluentModel1, testAnalyteModel1, testAntibodyModel1, testAntibodyModel2,
							preloadedAnalyte1,
							customizableAnalyte1, antibodyMolecule1, antibodyMolecule2,
							preloadedAnalyteManufacturingSpecification1,
							cartridgeModel1, cartridgeObject1,
							(* note that I'm commenting out analyteStandardSample1 and antibodySample1 and antibodySample2 on purpose because I don't want it to be a DeveloperObject so that I don't get FRQ errors *)
							testSampleModel1, testSampleModel2, testSample1, testSample2, testSample3, testDiluent1(*, analyteStandardSample1, antibodySample1, antibodySample2*)
						}
					],
					ObjectP[]
				];

				(* Make all the test objects and models developer objects *)
				(* There are several test objects  *)
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ allDeveloperObjects];

			]
		]
	),

	SymbolTearDown :> (
		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = Cases[
				Flatten[
					{
						(* Bench *)
						Object[Container, Bench, "Test bench for ExperimentCapillaryELISAPreview tests" <> $SessionUUID],

						(* Containers *)
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 1 for test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 2 for test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 3 for test sample 3 without pre-loaded analytes" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container for pre-loaded diluent 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test container 1 for customizable analyte sample" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test antibody sample container 1" <> $SessionUUID],
						Object[Container, Vessel, "ExperimentCapillaryELISAPreview test antibody sample container 2" <> $SessionUUID],

						(* Pre-loaded Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAPreview test pre-loaded analyte 1" <> $SessionUUID],

						(* Manufacturing Specifications *)
						Object[ManufacturingSpecification, CapillaryELISACartridge, "ExperimentCapillaryELISAPreview test pre-loaded analyte manufacturing specification 1" <> $SessionUUID],

						(* Customizable Analytes *)
						Model[Molecule, Protein, "ExperimentCapillaryELISAPreview test customizable analyte 1" <> $SessionUUID],

						(* Antibody Identity Models *)
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAPreview test antibody identity model 1" <> $SessionUUID],
						Model[Molecule, Protein, Antibody, "ExperimentCapillaryELISAPreview test antibody identity model 2" <> $SessionUUID],

						(* Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 1 with pre-loaded analyte" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test sample model 2 without pre-loaded analyte" <> $SessionUUID],

						(* Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 1 with pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 2 without pre-loaded analyte" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test sample 3 without pre-loaded analyte" <> $SessionUUID],

						(* Customizable Analyte Sample Model *)
						Model[Sample, "ExperimentCapillaryELISAPreview test customizable analyte model 1" <> $SessionUUID],

						(* Customizable Analyte Sample Object *)
						Object[Sample, "ExperimentCapillaryELISAPreview test customizable analyte sample 1" <> $SessionUUID],

						(* Antibody Sample Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 1" <> $SessionUUID],
						Model[Sample, "ExperimentCapillaryELISAPreview test antibody model 2" <> $SessionUUID],

						(* Antibody Sample Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test antibody sample 1" <> $SessionUUID],
						Object[Sample, "ExperimentCapillaryELISAPreview test antibody sample 2" <> $SessionUUID],

						(* Reagent Models *)
						Model[Sample, "ExperimentCapillaryELISAPreview test diluent model 1" <> $SessionUUID],

						(* Reagent Objects *)
						Object[Sample, "ExperimentCapillaryELISAPreview test diluent object 1" <> $SessionUUID],

						(* Cartridge Object *)
						(* Create several pre-loaded cartridges so that they can be searched in our resolver using DeveloperSearch *)
						Model[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge model for pre-loaded analyte 1" <> $SessionUUID],
						Object[Container, Plate, Irregular, CapillaryELISA, "ExperimentCapillaryELISAPreview SinglePlex72X1 test pre-loaded cartridge for pre-loaded analyte 1" <> $SessionUUID]
					}
				],
				ObjectP[]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			(* Turn on the SamplesOutOfStock and DeprecatedProduct warning *)
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::DeprecatedProduct];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
