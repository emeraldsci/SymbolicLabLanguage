(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* ExperimentSerialDilute *)

DefineTests[ExperimentSerialDilute,
	{
		(*new unit tests*)
		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->FromConcentrate, CB->defined:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
				ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
					Model[Sample, StockSolution, "10x PBS"]},
				BufferDilutionFactor -> 10,
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 3000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->FromConcentrate, CB->defined:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[100 Microliter, 6], Table[100 Microliter, 6]},
				ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
					Model[Sample, StockSolution, "10x PBS"]},
				BufferDilutionFactor -> 10,
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 3000
		],

		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->FromConcentrate, CB->Null:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 3000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->FromConcentrate, CB->Null:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[100 Microliter, 6], Table[100 Microliter, 6]},
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 3000
		],

		(*Using built primitives*)
		Example[{Basic,
			"Generate a new manual sample preparation protocol with a labeled containerOut:"},
			Module[{allPrims},
				allPrims = {
					LabelContainer[
						Label -> "myContainer 1",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					SerialDilute[
						Source ->Object[Sample, "ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
						SerialDilutionFactors -> {10, 10, 10},
						ContainerOut -> {"myContainer 1", "myContainer 1",
							"myContainer 1"}
					]
				};
			Quiet[ExperimentManualSamplePreparation[allPrims],{Warning::AmbiguousAnalyte}]
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 2000
		],

		(*
		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->Direct, CB->Null:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
				BufferDilutionFactor -> 10, Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->Direct, CB->Null:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> Table[100 Microliter, 6],
				BufferDilutionFactor -> 10, Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->Direct, CB->defined:"},
			ExperimentSerialDilute[
				{
					Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]
				},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume ->  Table[100 Microliter, 6],
				ConcentratedBuffer ->
        			{Model[Sample, StockSolution, "10x PBS"],
					Model[Sample, StockSolution, "10x PBS"]},
				Diluent ->
        			{Model[Sample, StockSolution, "1x PBS from 10X stock"],
					Model[Sample, StockSolution, "1x PBS from 10X stock"]},
				BufferDilutionFactor -> 10,
				Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->Direct, CB->defined:"},
			ExperimentSerialDilute[
				{
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]
				},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
				ConcentratedBuffer ->
					{Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
				Diluent ->
					{Model[Sample, StockSolution, "1x PBS from 10X stock"],
						Model[Sample, StockSolution, "1x PBS from 10X stock"]},
				BufferDilutionFactor -> 10,
				Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->Direct, CB->null,one sample:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> Table[2 Milliliter, 6], Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->Direct, CB->null,one sample:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> Table[200 Microliter, 6], Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new manual protocol to serial dilute a sample with BDS->FromConcentrate, CB->null,one sample:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> Table[100 Microliter, 6], Preparation -> Manual, BufferDilutionStrategy->FromConcentrate],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new robotic protocol to serial dilute a sample with BDS->FromConcentrate, CB->null,one sample:"},
			ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 6],
				FinalVolume -> Table[100 Microliter, 6], Preparation -> Robotic, BufferDilutionStrategy->FromConcentrate],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new manual sample prep protocol to serial dilute three samples:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 2 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 3],
				FinalVolume -> { Table[100 Microliter, 3], Table[2 Milliliter, 3],
					Table[100 Microliter, 3]},
				Diluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10, Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new manual sample prep protocol with DestinationWells specified:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 3],
				FinalVolume -> Table[100 Microliter, 3],
				DestinationWells -> {{"A1", "A2", "A3"}, {"B1", "B2", "B3"}},
				Diluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10, Preparation -> Manual],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],

		Example[{Basic,
			"Generate a new robotic sample prep protocol with ContainerOut specified:"},
			Module[{specifiedContainerOut},

				(*create fake plate*)
				specifiedContainerOut = UploadSample[
					Model[Container, Plate, "96-well 2mL Deep Well Plate"], {"Top Slot",
						Object[Instrument, Dishwasher, "Rosie"]}, Status -> Available,
					Name -> StringJoin["Test plate for expSD",ToString[Unique[]]]];

				(*use fake plate in experiment call*)
				ExperimentSerialDilute[{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 3],
					FinalVolume -> {Table[100 Microliter, 3], Table[200 Microliter, 3]},
					Diluent -> Model[Sample, "Milli-Q water"],
					ContainerOut -> {Table[specifiedContainerOut, 3],
						Table[specifiedContainerOut, 3]},
					BufferDilutionFactor -> 10, Preparation -> Robotic]
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			EquivalenceFunction -> MatchQ, TimeConstraint -> 1000
		],*)

		(*Options tests*)
		Example[{Options, Analyte,
			"The analyte to be diluted in the dilutions, should be found automatically:"},
			options =
				ExperimentSerialDilute[{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					Preparation -> Manual, Output -> Options];
			Lookup[options, Analyte], {Model[Molecule, "id:Vrbp1jK4Z9qz"],
			Model[Molecule, "id:vXl9j57PmP5D"]}, EquivalenceFunction -> MatchQ,TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, TransferAmounts,
			"The amounts of sample to be diluted with BDS->Direct, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
					Diluent -> {Model[Sample, StockSolution, "1x PBS from 10X stock"],
						Model[Sample, StockSolution, "1x PBS from 10X stock"]},
					BufferDilutionFactor -> 10, Preparation -> Manual,Output->Options];
			Lookup[options, TransferAmounts], {{200*Microliter,200*Microliter,200*Microliter,200*Microliter,200*Microliter,200*Microliter},
			{10*Microliter,10*Microliter,10*Microliter,10*Microliter,10*Microliter,10*Microliter}}, EquivalenceFunction -> MatchQ,
			TimeConstraint -> 2000,
			Variables :> {options}],

		Example[{Options, TransferAmounts,
			"The amounts of sample to be diluted with BDS->FromConcentrate, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
					BufferDilutionFactor -> 10,
					BufferDilutionStrategy -> FromConcentrate, Preparation -> Manual,Output->Options];
			Lookup[options, TransferAmounts], {{200*Microliter,200*Microliter,200*Microliter,200*Microliter,200*Microliter,200*Microliter},
			{10*Microliter,10*Microliter,10*Microliter,10*Microliter,10*Microliter,10*Microliter}}, EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, DiluentAmount,
			"The amounts of diluent in which to dilute the samples BDS->Direct and CB->Defined, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
					Diluent -> {Model[Sample, StockSolution, "1x PBS from 10X stock"],
						Model[Sample, StockSolution, "1x PBS from 10X stock"]},
					BufferDilutionFactor -> 10, Preparation -> Manual, Output->Options];
			Lookup[options, DiluentAmount], {{1780*Microliter,1800*Microliter,1800*Microliter,1800*Microliter,
			1800*Microliter,1800*Microliter},{89*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter}},
			TimeConstraint -> 1000,
			EquivalenceFunction -> MatchQ,
			Variables :> {options}],

		Example[{Options, ConcentratedBufferAmount,
			"The amount of concentrated buffer to add at first with BDS->Direct and CB->Defined, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
					Diluent -> {Model[Sample, StockSolution, "1x PBS from 10X stock"],
						Model[Sample, StockSolution, "1x PBS from 10X stock"]},
					BufferDilutionFactor -> 10, Preparation -> Manual, Output->Options];
			Lookup[options, ConcentratedBufferAmount], {{20*Microliter},{1*Microliter}},
			EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, DiluentAmount,
			"The amount of diluent in which to dilute the samples with BDS->Direct and CB->not defined, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					TransferAmounts -> {Table[200 Microliter, 6],
						Table[10 Microliter, 6]},
					Preparation -> Manual, Output->Options];
			Lookup[options, DiluentAmount], {{1800*Microliter,1800*Microliter,1800*Microliter,1800*Microliter,
			1800*Microliter,1800*Microliter},{90*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter}},
			EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, ConcentratedBufferAmount,
			"The amount of concentrated buffer to add at first with BDS->Direct and CB->not defined, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					TransferAmounts -> {Table[200 Microliter, 6],
						Table[10 Microliter, 6]},
					Preparation -> Manual, Output->Options];
			Lookup[options, ConcentratedBuffer], {Null,Null},
			EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, BufferDiluentAmount,
			"The amount of buffer diluent in which to dilute the concentrated buffer or sample, with BDS->FromConcentrate and CB->not defined, should be found automatically:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					BufferDilutionStrategy -> FromConcentrate,
					Preparation -> Manual,
					Output->Options
				];
			Lookup[options, BufferDiluentAmount],{{1800*Microliter,1800*Microliter,1800*Microliter,1800*Microliter,
			1800*Microliter,1800*Microliter},{90*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter,90*Microliter}},
			EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, Diluent,
			"The diluent in which to dilute the sample, with BDS->FromConcentrate and CB->Defined:"},
			options =
				ExperimentSerialDilute[
					{Object[Sample,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
						Object[Sample,
							"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> Table[10, 6],
					FinalVolume -> {Table[2 Milliliter, 6], Table[100 Microliter, 6]},
					ConcentratedBuffer -> {Model[Sample, StockSolution, "10x PBS"],
						Model[Sample, StockSolution, "10x PBS"]},
					BufferDilutionFactor -> 10,
					BufferDilutionStrategy -> Direct, Preparation -> Manual,
					Output->Options
				];
			Lookup[options, Diluent],{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
			EquivalenceFunction -> MatchQ,
			TimeConstraint -> 1000,
			Variables :> {options}],

		Example[{Options, ConcentratedBufferAmount, "The amount of buffer to be diluted in the dilutions, should be found automatically:"},
			options = ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				FinalVolume -> {1 Milliliter, 1 Milliliter, 1 Milliliter},
				TransferAmounts -> {50 Microliter, 50 Microliter, 50 Microliter},
				DiluentAmount -> {950 Microliter, 950 Microliter, 950 Microliter},
				BufferDilutionFactor -> 10];
			Lookup[options, ConcentratedBufferAmount],
			{{0Microliter, 0Microliter, 0Microliter},{0Microliter, 0Microliter, 0Microliter}},
			TimeConstraint -> 1000,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, ConcentratedBuffer, "The buffer to be diluted in the dilutions, should be found automatically:"},
			options = ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				FinalVolume -> {1 Milliliter, 1 Milliliter, 1 Milliliter},
				TransferAmounts -> {50 Microliter, 50 Microliter, 50 Microliter},
				DiluentAmount -> {950 Microliter, 950 Microliter, 950 Microliter},
				BufferDilutionFactor -> 10];
			Lookup[options, ConcentratedBuffer],
			{Null,Null},
			TimeConstraint -> 1000,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, BufferDiluent, "The buffer diluent to be added in the dilutions, should be found automatically:"},
			options = ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				FinalVolume -> {1 Milliliter, 1 Milliliter, 1 Milliliter},
				TransferAmounts -> {50 Microliter, 50 Microliter, 50 Microliter},
				DiluentAmount -> {950 Microliter, 950 Microliter, 950 Microliter},
				BufferDilutionFactor -> 10];
			Lookup[options, BufferDiluent],
			{Null,Null},
			TimeConstraint -> 1000,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, DestinationWells,
			"The wells for the dilutions, should be found automatically:"},
			options =
				ExperimentSerialDilute[{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
					SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
					FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options,
				DestinationWells], {{"A1", "A2", "A3"}, {"A4", "A5", "A6"}},
			TimeConstraint -> 1000, EquivalenceFunction -> Equal,
			Variables :> {options}],

		Example[{Options, ContainerOut, "The containers for the dilutions, should be found automatically:"},
			options = ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				FinalVolume -> {1 Milliliter, 1 Milliliter, 1 Milliliter},
				TransferAmounts -> {50 Microliter, 50 Microliter, 50 Microliter},
				DiluentAmount -> {950 Microliter, 950 Microliter, 950 Microliter},
				BufferDilutionFactor -> 10];
			Lookup[options, ContainerOut],
			{{{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1,
				Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1,
				Model[Container, Plate, "id:L8kPEjkmLbvW"]}}, {{1,
				Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1,
				Model[Container, Plate, "id:L8kPEjkmLbvW"]}, {1,
				Model[Container, Plate, "id:L8kPEjkmLbvW"]}}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, SerialDilutionFactors, "The SerialDilutionFactors, should just be set automatically:"},
			options = ExperimentSerialDilute[
				{Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
					Object[Sample,
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				FinalVolume -> {1 Milliliter, 1 Milliliter, 1 Milliliter},
				TransferAmounts -> {50 Microliter, 50 Microliter, 50 Microliter},
				DiluentAmount -> {950 Microliter, 950 Microliter, 950 Microliter},
				BufferDilutionFactor -> 10];
			Lookup[options, SerialDilutionFactors],
			{{2,2,2},{2,2,2}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		(*Labels tests of options*)
		Example[{Options, SourceLabel, "Given the Sources labels, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				SourceLabel -> {"Source Label 1", "Source Label 2"},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options, SourceLabel],
			{"Source Label 1","Source Label 2"},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, SourceContainerLabel, "Given the Source Container labels, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				SourceContainerLabel -> {"Source Container Label 1", "Source Container Label 2"},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options, SourceContainerLabel],
			{"Source Container Label 1","Source Container Label 2"},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, SampleOutLabel, "Given the SampleOut labels, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, Output -> Options,
				SampleOutLabel->{"Sample Out Label 1","Sample Out Label 2","Sample Out Label 3"},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options, SampleOutLabel],
			{{"Sample Out Label 1","Sample Out Label 2","Sample Out Label 3"}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, ContainerOutLabel, "Given the ContainerOut labels, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				ContainerOutLabel->{"ContainerOut Label 1","ContainerOut label 2","ContainerOut label 3"},
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, ContainerOutLabel],
			{{"ContainerOut Label 1","ContainerOut label 2","ContainerOut label 3"}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, DiluentLabel, "Given the Diluent label, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				DiluentLabel->{"Diluent label 1"},
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, DiluentLabel],
			{"Diluent label 1"},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, ConcentratedBufferLabel, "Given the ConcentratedBuffer label, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 3],
				FinalVolume -> {Table[2 Milliliter, 3]},
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Manual,
				ConcentratedBuffer -> Model[Sample, "Milli-Q water"],
				ConcentratedBufferLabel -> {"ConcentratedBuffer Label 1"},
				Output -> Options];
			Lookup[options, ConcentratedBufferLabel],
			{"ConcentratedBuffer Label 1"},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, BufferDiluentLabel, "Given the BufferDiluentLabel label, label them properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> Table[10, 3],
				FinalVolume -> {Table[2 Milliliter, 3]},
				BufferDilutionStrategy -> FromConcentrate, Preparation -> Manual,
				BufferDiluentLabel -> {"BufferDiluent Label 1"}, Output -> Options];
			Lookup[options, BufferDiluentLabel],
			{"BufferDiluent Label 1"},
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, NumberOfSerialDilutions, "Calculate the NumberOfSerialDilutions properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, NumberOfSerialDilutions],
			{3},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, TargetConcentrations, "Calculate the TargetConcentrations properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, TargetConcentrations],
			{{0.030607432200008194*Mole/Liter,
				0.0030607432200008195*Mole/Liter,
				0.00030607432200008196*Mole/Liter}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, FinalVolume, "Return FinalVolume properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options, FinalVolume],
			{{100Microliter,100Microliter,100Microliter}},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, BufferDilutionStrategy, "Return BufferDilutionStrategy properly, Direct:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100Microliter, 100Microliter, 100 Microliter}];
			Lookup[options, BufferDilutionStrategy],
			{Direct},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],

		Example[{Options, BufferDilutionStrategy, "Return BufferDilutionStrategy properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100Microliter, 100Microliter, 100 Microliter},BufferDilutionStrategy->FromConcentrate];
			Lookup[options, BufferDilutionStrategy],
			{FromConcentrate},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, BufferDilutionFactor, "Return BufferDilutionFactor properly:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100Microliter, 100Microliter, 100 Microliter}];
			Lookup[options, BufferDilutionFactor],
			{10},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, DiscardFinalTransfer, "Return DiscardFinalTransfer properly, default is False:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100Microliter, 100Microliter, 100 Microliter}];
			Lookup[options, DiscardFinalTransfer],
			{False},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, TransferMix, "Return TransferMix properly, default is True:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100Microliter, 100Microliter, 100 Microliter}];
			Lookup[options, TransferMix],
			{True},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, TransferMixType, "Return TransferMixType properly, default is Swirl:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, TransferMixType],
			{Swirl},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, TransferNumberOfMixes, "Return TransferNumberOfMixes properly, default is 20:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, TransferNumberOfMixes],
			{20},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, Incubate, "Return Incubate properly, default is True:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, Incubate],
			{True},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, IncubationTime, "Return IncubationTime properly, default is 15Min:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, IncubationTime],
			{15 Minute},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, MaxIncubationTime, "Return IncubationTime properly, default is Null:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, MaxIncubationTime],
			{Null},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, IncubationTemperature, "Return IncubationTemperature properly, default is Ambient:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, IncubationTemperature],
			{Ambient},
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, Preparation, "Return Preparation properly, should be Manual here:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {2 Milliliter, 2 Milliliter, 2 Milliliter}];
			Lookup[options, Preparation],
			Manual,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		Example[{Options, Preparation, "Return Preparation properly, should be Robotic here:"},
			options = ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10}, Output -> Options,
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter}];
			Lookup[options, Preparation],
			Robotic,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 1000,
			Variables :> {options}
		],

		(*message unit tests*)
		Example[{Messages, "DiscardedSamples", "Discarded samples test:"},
			ExperimentSerialDilute[
				{Object[Sample, "ExperimentSerialDilute New Test Chemical 4 (Discarded)"<>$SessionUUID]}
			],
			$Failed,
			Messages :>
					{
						Error::DiscardedSamples,
						Error::InvalidInput
					}
		],

		Example[{Messages,"MismatchedNumber","Mismatched number of serial dilutions:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 2 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {2, 2, 2}, NumberOfSerialDilutions -> 4],
			$Failed,
			Messages:>{
				Error::SerialDiluteNumberErr,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MismatchedNumber","Mismatched number of serial dilutions TotalConcentrations:"},
			ExperimentSerialDilute[
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID
				],
				TargetConcentrations->{1Molar,0.5Molar,0.25Molar},
				NumberOfSerialDilutions->4
			],
			$Failed,
			Messages:>{
				Error::SerialDiluteNumberErr,
				Error::InvalidOption
			}
		],

		Example[{Messages,"BufferDilutionStrategyErr","The selected BufferDilutionStrategy is not compatible with the given information:"},
			ExperimentSerialDilute[
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID
				],
				BufferDilutionStrategy->Direct,
				TargetConcentrations->{1Molar,0.5Molar,0.25Molar},
				NumberOfSerialDilutions->3,
				BufferDilutionFactor->1,
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDiluentAmount->{1Milliliter,1Milliliter,1Milliliter},
				(*TransferAmount->2Milliliter,*)
				ConcentratedBufferAmount->{5Microliter},
				(*DiluentAmount->90Microliter,*)
				ConcentratedBuffer->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::BufferDilutionStrategyErr,
				Error::InvalidOption
			}
		],

		Example[{Messages,"IncompatibleIncubateDevice","The specified Incubate option is not compatible with the ContainerOut:"},
			ExperimentSerialDilute[
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				SerialDilutionFactors->{10,10,10},
				FinalVolume->{2Milliliter,2Milliliter,2Milliliter},
				Incubate->{True},
				Preparation->Robotic
			],
			$Failed,
			Messages:>{
				Error::IncompatibleIncubateDevice,
				Error::InvalidOption
			}
		],

		(*this error covers all 3 conflicting incubate messages*)
		Example[{Messages,"ConflictingIncubate","The specified Incubate option is conflicting with the ContainerOut:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,
					"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
				Incubate -> {True, False}],
			$Failed,
			Messages:>{
				Error::ConflictingIncubate,
				Error::ConflictingIncubateTime,
				Error::ConflictingIncubateTemp,
				Error::InvalidOption
			}
		],

		Example[{Messages, "UnevenTransferAmountsError",
			"The specified number of TransferAmounts does not match the NumberOfSerialDilutions:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
				TransferAmounts -> {10 Microliter, 10 Microliter}], $Failed,
			Messages :> {Error::UnevenNumberTransferAmount,
				Error::InvalidOption}],

		Example[{Messages, "UnevenDiluentAmountsError",
			"The specified number of DiluentAmount does not match the NumberOfSerialDilutions:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
				DiluentAmount -> {10 Microliter, 10 Microliter}], $Failed,
			Messages :> {Error::UnevenNumberDiluentAmount, Error::InvalidOption}],

		Example[{Messages, "UnevenBufferDiluentAmountsError",
			"The specified number of BufferDiluentAmount does not match the NumberOfSerialDilutions:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
				BufferDiluentAmount -> {10 Microliter, 10 Microliter},
				BufferDilutionStrategy -> FromConcentrate], $Failed,
			Messages :> {Error::UnevenNumberBufferDiluentAmount,
				Error::InvalidOption}],

		Example[{Messages, "UnevenConcentratedBufferAmountsError",
			"The specified number of ConcentratedBufferAmounts does not match the NumberOfSerialDilutions:"},
			ExperimentSerialDilute[{Object[Sample,
				"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID]},
				SerialDilutionFactors -> {10, 10, 10},
				FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
				ConcentratedBufferAmount -> {10 Microliter, 10 Microliter},
				BufferDilutionStrategy -> FromConcentrate], $Failed,
			Messages :> {Error::UnevenNumberConcentratedBufferAmount,
				Error::InvalidOption}]

	},
	(* A little background here: these unit tests have failed because of  non-reproducible General::stop errors, with no other errors being thrown. This is at least plausibly because of an overly zealous Quiet[] somewhere along the line, but is essentially impossible to diagnose at present. Preventing this message should help to diagnose any future problems. *)
	TurnOffMessages :> {General::stop},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols=True,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>(
		ClearDownload[];
		ClearMemoization[];
		InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
		InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
		InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
		InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
		InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs,existingObjs},
			allObjs={
				Object[Container,Bench,"Fake bench for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 1 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 2 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 3 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 4 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 5 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 6 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 7 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 8 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 9 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 10 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 11 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 12 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 13 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 14 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Plate,"Fake plate 1 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 2 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 4 (Discarded)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 5 (no amount)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemcial 6 (100 mg)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 7 (0.01 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 8 (120 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 9 (200 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical In Plate 2 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical In Plate 3 (100 uL)"<>$SessionUUID],
				Object[Protocol,SampleManipulation,Dilute,"Existing ExperimentSerialDilute Protocol"<>$SessionUUID]
			};
			existingObjs=PickList[allObjs,DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,
					container,container2,container3,container4,container5,container6,container7,container8,container9,container10,container11,container12,container13,container14,plate1,
					sample,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,
					allObjs,templateProtocol
				},

				(* create a fake bench for our test containers *)
				fakeBench=Upload[<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Fake bench for ExperimentSerialDilute tests"<>$SessionUUID,
					DeveloperObject->True|>];

				(* call UploadSample to create test containers *)
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13,
					container14,
					plate1
				}=UploadSample[
					{
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Status->{
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name->{
						"Fake container 1 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 2 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 3 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 4 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 5 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 6 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 7 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 8 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 9 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 10 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 11 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 12 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 13 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake container 14 for ExperimentSerialDilute tests"<>$SessionUUID,
						"Fake plate 1 for ExperimentSerialDilute tests"<>$SessionUUID
					}
				];

				(* call UploadSample to create test samples *)
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Acetone, Reagent Grade"],
						Model[Sample,StockSolution,"10x UV buffer"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Sodium Chloride"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"T7 RNA Polymerase"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",plate1},
						{"A2",plate1}
					},
					InitialAmount->{
						100 Microliter,
						100 Microliter,
						200 Microliter,
						100 Microliter,
						Null,
						100 Milligram,
						0.01 Microliter,
						120 Microliter,
						200 Microliter,
						100 Microliter,
						100 Microliter
					},
					Name->{
						"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 2 (100 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 4 (Discarded)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 5 (no amount)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemcial 6 (100 mg)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 7 (0.01 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 8 (120 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical 9 (200 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical In Plate 2 (100 uL)"<>$SessionUUID,
						"ExperimentSerialDilute New Test Chemical In Plate 3 (100 uL)"<>$SessionUUID
					}
				];

				(* make a new protocol object for templating *)
				(*templateProtocol=ExperimentSerialDilute[sample8,TotalVolume->123 Microliter,Name->"Existing ExperimentSerialDilute Protocol"<>$SessionUUID];*)

				allObjs=Cases[Flatten[{
					container,container2,container3,container4,container5,container6,container7,container8,container9,container10,container11,container12,container13,container14,plate1,
					sample,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,
					templateProtocol,Download[templateProtocol,{ProcedureLog[Object],RequiredResources[[All,1]][Object]}]
				}],ObjectP[]];

				(* final upload call: *)
				(* 1) make sure we set all objects to DeveloperObject -> True *)
				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@PickList[allObjs,DatabaseMemberQ[allObjs]]
				}]];
				UploadSampleStatus[sample4,Discarded,FastTrack->True]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs,existingObjs},
			allObjs={
				Object[Container,Bench,"Fake bench for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 1 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 2 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 3 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 4 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 5 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 6 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 7 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 8 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 9 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 10 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 11 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 12 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 13 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Vessel,"Fake container 14 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Container,Plate,"Fake plate 1 for ExperimentSerialDilute tests"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 1 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 2 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 3 (200 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 4 (Discarded)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 5 (no amount)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemcial 6 (100 mg)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 7 (0.01 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 8 (120 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical 9 (200 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical In Plate 2 (100 uL)"<>$SessionUUID],
				Object[Sample,"ExperimentSerialDilute New Test Chemical In Plate 3 (100 uL)"<>$SessionUUID],
				Object[Protocol,SampleManipulation,Dilute,"Existing ExperimentSerialDilute Protocol"<>$SessionUUID]
			};
			existingObjs=PickList[allObjs,DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		]
	)
];

(* ::Subsection:: *)
(* SerialDilute *)
DefineTests[SerialDilute,
	{
		Example[{Basic,"Generate a manual sample preparation protocol with SerialDilute unit operation with a labeled container:"},
			Module[{allPrims},
				allPrims = {
					LabelContainer[
						Label -> "myContainer 1",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					SerialDilute[
						Source -> Object[Sample, "Test sample for SerialDilute " <> $SessionUUID],
						FinalVolume -> {100 Microliter, 100 Microliter, 100 Microliter},
						SerialDilutionFactors -> {10, 10, 10},
						ContainerOut -> {"myContainer 1", "myContainer 1", "myContainer 1"}
					]
				};
				ExperimentManualSamplePreparation[allPrims]
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			EquivalenceFunction->MatchQ
		]
	},
	Stubs:>{
		$PersonID = Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> Module[{bench, vessel, objs, existingObjs},
		ClearDownload[];
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		objs = Quiet[Cases[
			Flatten[{
				Object[Sample, "Test sample for SerialDilute " <> $SessionUUID]
			}],
			ObjectP[]
		]];
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False];

		bench = Upload[
			<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for SerialDilute" <> $SessionUUID,
				Site -> Link[$Site]
			|>
		];

		vessel = UploadSample[
			Model[Container, Vessel, "50mL Tube"],
			{"Work Surface", bench},
			Name -> "Test vessel for SerialDilute " <> $SessionUUID
		];

		UploadSample[
			Model[Sample, "Red Food Dye"],
			{"A1", vessel},
			Name -> "Test sample for SerialDilute " <> $SessionUUID,
			InitialAmount -> 40 Milliliter
		]
	],
	SymbolTearDown:>Module[{objs, existingObjs},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		objs = Quiet[Cases[
			DeleteDuplicates[Flatten[{
				$CreatedObjects,
				Object[Sample,"Test sample for SerialDilute "<>$SessionUUID]
			}]],
			ObjectP[]
		]];
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(*ExperimentSerialDiluteOptions*)

DefineTests[ExperimentSerialDiluteOptions,
	{
		(*new unit tests*)
		Example[{Basic,
			"Display the option values for a protocol to serial dilute a sample:"},
			ExperimentSerialDiluteOptions[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
				ConcentratedBuffer->{Model[Sample,StockSolution,"10x PBS"],Model[Sample,StockSolution,"10x PBS"]},
				BufferDilutionFactor->10,
				BufferDilutionStrategy->FromConcentrate,Preparation->Manual],
			_Grid,
			TimeConstraint->3000
		],

		Example[{Basic,"Display the option values for a new robotic protocol:"},
			ExperimentSerialDiluteOptions[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[100 Microliter,6],Table[100 Microliter,6]},
				ConcentratedBuffer->{Model[Sample,StockSolution,"10x PBS"],Model[Sample,StockSolution,"10x PBS"]},
				BufferDilutionFactor->10,
				BufferDilutionStrategy->FromConcentrate,Preparation->Robotic
			],
			_Grid,
			TimeConstraint->2000
		],

		Example[{Basic,"Display the option values for a new manual protocol:"},
			ExperimentSerialDiluteOptions[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
				BufferDilutionStrategy->FromConcentrate,Preparation->Manual],
			_Grid,
			TimeConstraint->2000
		]
	},
	SymbolSetUp:>(
		Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2, testBench},
			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			$CreatedObjects={};

			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter=DatabaseMemberQ[{
				Object[Container, Bench, "Test bench for ExperimentIRSpectroscopyPreview tests"<> $SessionUUID]
				Object[Container,Vessel,"Test container 1 for ExperimentSerialDiluteOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentSerialDiluteOptions"<> $SessionUUID],

				Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID],
				Object[Sample,"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID]
			}];

			EraseObject[
				PickList[
					{
						Object[Container,Vessel,"Test container 1 for ExperimentSerialDiluteOptions"],
						Object[Container,Vessel,"Test container 2 for ExperimentSerialDiluteOptions"],

						Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID],
						Object[Sample,"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID]
					},
					existsFilter
				],
				Force->True,
				Verbose->False
			];

			Block[{$DeveloperUpload = True},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentIRSpectroscopyPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				|>];

				(* Create some empty containers *)
				{emptyContainer1,emptyContainer2}=UploadSample[
					{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
					{{"Work Surface", testBench}, {"Work Surface", testBench}},
					Name->{"Test container 1 for ExperimentSerialDiluteOptions"<>$SessionUUID, "Test container 2 for ExperimentSerialDiluteOptions"<>$SessionUUID}
				];

				(* Create some water samples *)
				{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
					{
						Model[Sample, StockSolution, "1 M TrisHCl, pH 7.5"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",emptyContainer1},
						{"A1",emptyContainer2}
					},
					InitialAmount->{40 Milliliter,20 Milliliter},
					Name->{
						"Test Tris sample in 50mL tube (1) for ExperimentSerialDiluteOptions "<>$SessionUUID,
						"Test water sample in 50mL tube (2) for ExperimentSerialDiluteOptions "<>$SessionUUID
					}
				];
			];
		];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ValidExperimentSerialDiluteQ*)

DefineTests[ValidExperimentSerialDiluteQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentSerialDiluteQ[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
				BufferDilutionStrategy->FromConcentrate,Preparation->Manual],
			True,
			TimeConstraint->3000
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentSerialDiluteQ[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[5000 Microliter,6]},
				BufferDilutionStrategy->FromConcentrate,Preparation->Robotic],
			False,
			TimeConstraint->2000
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentSerialDiluteQ[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
				BufferDilutionStrategy->FromConcentrate,Preparation->Manual,OutputFormat->TestSummary],
			_EmeraldTestSummary,
			TimeConstraint->2000
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentSerialDiluteQ[
				{Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]},
				SerialDilutionFactors->Table[10,6],
				FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
				BufferDilutionStrategy->FromConcentrate,Preparation->Manual,Verbose->True],
			True,
			TimeConstraint->3000
		]
	},
	SymbolSetUp:>(Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2},
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ValidExperimentSerialDiluteQ " <> $SessionUUID],
			Object[Container,Vessel,"Test container 2 for ValidExperimentSerialDiluteQ " <> $SessionUUID],

			Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]
		}];

		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ValidExperimentSerialDiluteQ " <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ValidExperimentSerialDiluteQ " <> $SessionUUID],

					Object[Sample,"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ValidExperimentSerialDiluteQ " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ValidExperimentSerialDiluteQ " <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create some water samples *)
		{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "1 M TrisHCl, pH 7.5"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2}
			},
			InitialAmount->{40 Milliliter,20 Milliliter},
			Name->{
				"Test Tris sample in 50mL tube (1) for ValidExperimentSerialDiluteQ "<>$SessionUUID,
				"Test water sample in 50mL tube (2) for ValidExperimentSerialDiluteQ "<>$SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>
		}];
	]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
