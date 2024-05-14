(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment DNASynthesis: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*DNASynthesis*)

(* ::Subsubsection:: *)
(*ExperimentDNASynthesis*)

DefineTests[ExperimentDNASynthesis,
	{
		Example[{Basic, "Generates a protocol to synthesize oligonucleotides of the provided sequences:"},
			ExperimentDNASynthesis[{"ATGCAGTGAC", Strand[DNA["GTAGACTGAT"]], Structure[{Strand[DNA["TTCAGACAAG"]]}, {}]}],
			ObjectReferenceP[Object[Protocol, DNASynthesis]]
		],
		Example[{Basic, "Generates a protocol to synthesize oligonucleotides:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "Test oligo ATGC" <> $SessionUUID], Model[Sample, "Test oligo GC" <> $SessionUUID]}],
			ObjectReferenceP[Object[Protocol, DNASynthesis]]
		],
		Example[{Basic, "Generates a protocol to synthesize a single oligonucleotide:"},
			ExperimentDNASynthesis[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]],
			ObjectReferenceP[Object[Protocol, DNASynthesis]]
		],
		Example[{Basic, "Generates a protocol to synthesize oligonucleotides of the provided sequences:"},
			ExperimentDNASynthesis[{"ATGCAGTGAC", Strand[DNA["GTAGACTGAT"]], Structure[{Strand[DNA["TTCAGACAAG"]]}, {}], Model[Sample, "Test oligo ATGC" <> $SessionUUID]}],
			ObjectReferenceP[Object[Protocol, DNASynthesis]]
		],

		(* Synthesizer *)
		Example[
			{Options, Instrument, "Specify synthesizer instrument to use as a model:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Instrument -> Model[Instrument, DNASynthesizer, "id:Vrbp1jG3Ya1O"]],
				Instrument],
			LinkP[Model[Instrument, DNASynthesizer, "id:Vrbp1jG3Ya1O"]]
		],
		Example[
			{Options, Instrument, "Specify synthesizer instrument to use as an object:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Instrument -> Object[Instrument, DNASynthesizer, "Test DNA Synthesizer for ExperimentDNASynthesis" <> $SessionUUID]],
				Instrument],
			LinkP[Object[Instrument, DNASynthesizer, "Test DNA Synthesizer for ExperimentDNASynthesis" <> $SessionUUID]]
		],

		(* Scale *)
		Example[
			{Options, Scale, "Synthesize DNA using 1 umole of resin active sites:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], Scale],
			1 Micromole,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Scale, "Synthesize DNA using 0.2 umole of resin active sites:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], Scale],
			0.2 Micromole,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Scale, "Synthesize DNA using 40 nmole of resin active sites:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], Scale],
			40 Nanomole,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Scale, "Automatic scale resolves to 0.2 umole of resin unless Columns is specified as an object:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}], Scale],
			0.2 Micromole,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Scale, "If the input is a string, Scale is automatic and no Column is specified, Scale resolves to 0.2 Micromole:"},
			Lookup[ExperimentDNASynthesis["ATGCAGTGAC", Output->Options], Scale],
			0.2 Micromole
		],
		Example[
			{Options, Scale, "If Scale is automatic and Columns is specified as an object, Scale resolves to the amount of resin active sites available on the column:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> {Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID]}], Scale],
			40 Nanomole,
			EquivalenceFunction -> Equal
		],
		Example[
			{Messages, "ColumnLoadingsDiffer", "If Scale is automatic and Columns is specified as an object but the columns differ in the amount of active sites, a warning is given and Scale resolves to the amount of resin active sites available on the largest column:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> {Object[Sample, "Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID]}], Scale],
			1 Micromole,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::ColumnLoadingsDiffer}
		],
		Example[
			{Messages, "MismatchedColumnAndScale", "If scale does not match the amount of active sites available on the specified sample resin, a warning is given:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, Columns -> Object[Sample, "Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Scale -> 40 Nano Mole], Scale],
			40 Nanomole,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::MismatchedColumnAndScale}
		],
		Example[
			{Messages, "InvalidDNAResins", "If a resin was given without scale information, an error is thrown:"},
			Download[
				ExperimentDNASynthesis[
					{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "polyATCy3Test" <> $SessionUUID]},
					Columns -> {Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis No Loading" <> $SessionUUID], Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID]},
					Scale -> 40 Nano Mole
				],
				Scale
			],
			$Failed,
			EquivalenceFunction -> Equal,
			Messages :> {Error::InvalidResins, Warning::ColumnLoadingsDiffer, Error::InvalidOption}
		],

		(*NumberOfReplicates*)
		Example[
			{Options, NumberOfReplicates, "Specify that the strands should be synthesized multiple times:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATCy3Test" <> $SessionUUID]}, NumberOfReplicates -> 3],
				StrandModels],
			{ObjectP[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]], ObjectP[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]], ObjectP[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]], ObjectP[Model[Sample, "polyATCy3Test" <> $SessionUUID]], ObjectP[Model[Sample, "polyATCy3Test" <> $SessionUUID]], ObjectP[Model[Sample, "polyATCy3Test" <> $SessionUUID]]}
		],

		(*Columns*)
		Example[
			{Options, Columns, "Synthesize DNA using a specified Model[Sample]:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID]], Columns],
			{LinkP[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID]], LinkP[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID]]}
		],
		Example[
			{Options, Columns, "Synthesize DNA using a specified Model[Sample]:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "Test oligo ATGC" <> $SessionUUID]}, Columns -> Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID]], Columns],
			{LinkP[Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID]]}
		],
		Example[
			{Options, Columns, "Synthesize DNA using a specified Object[Sample]:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> {Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID]}], Columns],
			{LinkP[Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID]], LinkP[Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID]]}
		],
		Example[
			{Options, Columns, "Synthesize DNA using a specified Object[Sample]:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "Test oligo ATGC" <> $SessionUUID]}, Columns -> Object[Sample, "Test GC resin for ExperimentDNASynthesis" <> $SessionUUID]], Columns],
			{LinkP[Object[Sample, "Test GC resin for ExperimentDNASynthesis" <> $SessionUUID]]}
		],
		Example[{Options, Columns, "Synthesize DNA using a different specified Model[Sample] or Model[Resin] for each oligomer:"},
			Download[
				ExperimentDNASynthesis[
					{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "Test oligo ATGC" <> $SessionUUID]},
					Columns -> {Model[Sample, "UnySupport"], Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID]}
				],
				Columns
			],
			{LinkP[Model[Sample, "UnySupport"]], LinkP[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID]]}
		],
		Example[
			{Options, Columns, "When a column with oligomer already on it, if instances of a monomer do not occur in the portion of the desired sequence that does not overlap with the existing oligomer on the resin, those monomers are non considered during option resolution:"},
			MemberQ[Flatten[Download[ExperimentDNASynthesis[{Model[Sample, "Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID]}, Columns -> Model[Sample, "3'Tamra CPG"]], {Phosphoramidites, SynthesisCycles}]], Modification["Tamra"]],
			False
		],
		Example[{Messages, "MismatchedColumnAndStrand", "Returns Failed if the preloaded sequence on the specified resin does not match the 3' bases in the model oligomer:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> Model[Sample, "Test GC resin model for ExperimentDNASynthesis" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::MismatchedColumnAndStrand, Error::InvalidOption},
			Variables :> {protocol}
		],
		Example[{Messages, "ReusedColumn", "If Columns are specified as objects (as opposed to models), unique objects must be used:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Columns -> {Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::ReusedColumn, Error::InvalidOption}
		],

		(* Number of Initial Washes*)
		Example[
			{Options, NumberOfInitialWashes, "Specify the number of washes at the start of the synthesis:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfInitialWashes -> 3],
				NumberOfInitialWashes],
			3
		],
		Example[
			{Options, NumberOfInitialWashes, "Automatic number of initial washes resolves to 1:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}],
				NumberOfInitialWashes],
			1
		],

		(* Initial Wash Time *)
		Example[
			{Options, InitialWashTime, "Specify the wait time between the washes at the start of the synthesis:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, InitialWashTime -> 30 Second],
				InitialWashTime],
			30 Second,
			EquivalenceFunction -> Equal
		],


		(* Initial Wash Volume *)
		Example[
			{Options, InitialWashVolume, "Specify the volume of the washes at the start of the synthesis:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, InitialWashVolume -> 30 Micro Liter],
				InitialWashVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, InitialWashVolume, "Automatic initial wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole],
				InitialWashVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, InitialWashVolume, "Automatic initial wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole],
				InitialWashVolume],
			250 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, InitialWashVolume, "Automatic initial wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole],
				InitialWashVolume],
			280 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Number of Deprotections*)
		Example[
			{Options, NumberOfDeprotections, "Specify the number of times that the deprotection solution is added to the resin after each cycle:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfDeprotections -> 4], NumberOfDeprotections],
			4
		],
		Example[
			{Options, NumberOfDeprotections, "Automatic number of deprotections resolves to 2 when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], NumberOfDeprotections],
			2
		],
		Example[
			{Options, NumberOfDeprotections, "Automatic number of deprotections resolves to 2 when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], NumberOfDeprotections],
			2
		],
		Example[
			{Options, NumberOfDeprotections, "Automatic number of deprotections resolves to 3 when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], NumberOfDeprotections],
			3
		],

		(* Deprotection Time *)
		Example[
			{Options, DeprotectionTime, "Specify the wait time between the deprotections:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, DeprotectionTime -> 30 Second], DeprotectionTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(* Deprotection Volume *)
		Example[
			{Options, DeprotectionVolume, "Specify the volume of deprotection solvent used in each deprotection iteration:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, DeprotectionVolume -> 30 Micro Liter], DeprotectionVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionVolume, "Automatic deprotection volume resolves to 60 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], DeprotectionVolume],
			60 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionVolume, "Automatic deprotection volume resolves to 140 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], DeprotectionVolume],
			140 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionVolume, "Automatic deprotection volume resolves to 180 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], DeprotectionVolume],
			180 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Final Deprotection *)
		Example[
			{Options, FinalDeprotection, "Specify whether the oligomers will be deprotected (detritylated) at the end of the synthesis:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, FinalDeprotection -> False], FinalDeprotection],
			{False, False}
		],
		Example[
			{Options, FinalDeprotection, "Specify different final deprotection options for different oligomers:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, FinalDeprotection -> {True, False}], FinalDeprotection],
			{True, False}
		],


		(* Number of Post-Deprotection Washes*)
		Example[
			{Options, NumberOfDeprotectionWashes, "Specify the number of times the resin is washed after deprotection:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfDeprotectionWashes -> 3], NumberOfDeprotectionWashes],
			3
		],

		(* Deprotection Wash Time *)
		Example[
			{Options, DeprotectionWashTime, "Specify the wait time between the post-deprotection washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, DeprotectionWashTime -> 30 Second], DeprotectionWashTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(* Deprotection Wash Volume *)
		Example[
			{Options, DeprotectionWashVolume, "Specify the volume of the post-deprotection washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, DeprotectionWashVolume -> 30 Micro Liter], DeprotectionWashVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionWashVolume, "Automatic deprotection wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], DeprotectionWashVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionWashVolume, "Automatic deprotection wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], DeprotectionWashVolume],
			250 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeprotectionWashVolume, "Automatic deprotection wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], DeprotectionWashVolume],
			280 Microliter,
			EquivalenceFunction -> Equal
		],

		(*Activator Solution*)
		Example[
			{Options, ActivatorSolution, "Specify the activator solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, ActivatorSolution -> Model[Sample, "id:E8zoYveRlKq5"]], ActivatorSolution],
			{LinkP[Model[Sample, "id:E8zoYveRlKq5"]]}
		],
		Example[
			{Options, ActivatorSolution, "Specify the activator solution as a model when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					ActivatorSolution -> Model[Sample, "id:E8zoYveRlKq5"]
				],
				ActivatorSolution
			],
			{LinkP[Model[Sample, "id:E8zoYveRlKq5"]], LinkP[Model[Sample, "id:E8zoYveRlKq5"]]}
		],
		Example[
			{Options, ActivatorSolution, "Specify the activator solution as model, or Automatic when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					ActivatorSolution -> {Automatic, Model[Sample, "id:E8zoYveRlKq5"]}],
				ActivatorSolution
			],
			{LinkP[Model[Sample, "id:E8zoYveRlKq5"]], LinkP[Model[Sample, "id:E8zoYveRlKq5"]]}
		],
		Example[
			{Options, ActivatorSolution, "Specify the activator solution as object or Automatic when all banks are used:"},
			Download[ExperimentDNASynthesis[
				ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
				ActivatorSolution -> {Automatic, Object[Sample, "Test activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]}
			],
				ActivatorSolution
			],
			{LinkP[Model[Sample, "id:E8zoYveRlKq5"]], LinkP[Object[Sample, "Test activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]]}
		],
		Example[
			{Messages, "MismatchDeckReagentBanks", "Raise error when the number of specified Activator Solutions is not copacetic with the number of banks used:"},
			ExperimentDNASynthesis[
				ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
				ActivatorSolution -> {Model[Sample, "id:E8zoYveRlKq5"]}
			],
			$Failed,
			Messages :> {Error::MismatchDeckReagentBanks, Error::InvalidOption}
		],

		(* Activator Volume *)
		Example[
			{Options, ActivatorVolume, "Specify the volume of activator solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, ActivatorVolume -> 30 Micro Liter], ActivatorVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ActivatorVolume, "Automatic activator volume resolves to 40 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], ActivatorVolume],
			40 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ActivatorVolume, "Automatic activator volume resolves to 45 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], ActivatorVolume],
			45 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ActivatorVolume, "Automatic activator volume resolves to 115 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], ActivatorVolume],
			115 Microliter,
			EquivalenceFunction -> Equal
		],

		(*CapA Solution*)
		Example[
			{Options, CapASolution, "Specify the Cap A solution:"},
			Download[
				ExperimentDNASynthesis[
					{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CapASolution -> Model[Sample, "id:4pO6dMWvnAKX"]
				],
				CapASolution
			],
			{LinkP[Model[Sample, "id:4pO6dMWvnAKX"]]}
		],
		Example[
			{Options, CapASolution, "Specify the Cap A solution as a model when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapASolution -> Model[Sample, "id:4pO6dMWvnAKX"]
				],
				CapASolution
			],
			{LinkP[Model[Sample, "id:4pO6dMWvnAKX"]], LinkP[Model[Sample, "id:4pO6dMWvnAKX"]]}
		],
		Example[
			{Options, CapASolution, "Specify the Cap A solution as model or Automatic when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapASolution -> {Automatic, Model[Sample, "id:4pO6dMWvnAKX"]}
				],
				CapASolution
			],
			{LinkP[Model[Sample, "id:4pO6dMWvnAKX"]], LinkP[Model[Sample, "id:4pO6dMWvnAKX"]]}
		],
		Example[
			{Options, CapASolution, "Specify the Cap A solution as object or Automatic when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapASolution -> {Automatic, Object[Sample, "Test Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]}
				],
				CapASolution
			],
			{LinkP[Model[Sample, "id:4pO6dMWvnAKX"]], LinkP[Object[Sample, "Test Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]]}
		],
		Example[
			{Messages, "MismatchDeckReagentBanks", "Raise error when the number of specified CapA Solutions is not copacetic with teh number of banks used:"},
			ExperimentDNASynthesis[
				ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
				CapASolution -> {Model[Sample, "id:4pO6dMWvnAKX"]}
			],
			$Failed,
			Messages :> {Error::MismatchDeckReagentBanks, Error::InvalidOption}
		],

		(* CapA Volume *)
		Example[
			{Options, CapAVolume, "Specify the volume of Cap A solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CapAVolume -> 200 Micro Liter], CapAVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapAVolume, "Automatic Cap A volume resolves to 40 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], CapAVolume],
			20 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapAVolume, "Automatic Cap A volume resolves to 30 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], CapAVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapAVolume, "Automatic Cap A volume resolves to 80 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], CapAVolume],
			80 Microliter,
			EquivalenceFunction -> Equal
		],

		(*CapB Solution*)
		Example[
			{Options, CapBSolution, "Specify the Cap B solution:"},
			Download[
				ExperimentDNASynthesis[
					{
						Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
						Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]
					},
					CapBSolution -> Model[Sample, "id:P5ZnEj4P8qKE"]],
				CapBSolution
			],
			{LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]]}
		],
		Example[
			{Options, CapBSolution, "Specify the Cap B solution as a model when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapBSolution -> Model[Sample, "id:P5ZnEj4P8qKE"]],
				CapBSolution
			],
			{LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]], LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]]}
		],
		Example[
			{Options, CapBSolution, "Specify the Cap B solution as model or Automatic when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapBSolution -> {Automatic, Model[Sample, "id:P5ZnEj4P8qKE"]}
				],
				CapBSolution
			],
			{LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]], LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]]}
		],
		Example[
			{Options, CapBSolution, "Specify the Cap B solution as object or Automatic when all banks are used:"},
			Download[
				ExperimentDNASynthesis[
					ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
					CapBSolution -> {Automatic, Object[Sample, "Test Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]}],
				CapBSolution
			],
			{LinkP[Model[Sample, "id:P5ZnEj4P8qKE"]], LinkP[Object[Sample, "Test Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID]]}
		],
		Example[
			{Messages, "MismatchDeckReagentBanks", "Raise error when the number of specified CapB Solutions is not copacetic with teh number of banks used:"},
			ExperimentDNASynthesis[
				ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 40],
				CapBSolution -> {Model[Sample, "id:P5ZnEj4P8qKE"]}
			],
			$Failed,
			Messages :> {Error::MismatchDeckReagentBanks, Error::InvalidOption}
		],

		(* CapB Volume *)
		Example[
			{Options, CapBVolume, "Specify the volume of Cap B solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CapBVolume -> 200 Micro Liter], CapBVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapBVolume, "Automatic Cap B volume resolves to 20 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], CapBVolume],
			20 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapBVolume, "Automatic Cap B volume resolves to 30 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], CapBVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CapBVolume, "Automatic Cap B volume resolves to 80 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], CapBVolume],
			80 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Number of Cappings*)
		Example[
			{Options, NumberOfCappings, "Specify the number of cappings:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfCappings -> 3], NumberOfCappings],
			3
		],

		(* Cap Time *)
		Example[
			{Options, CapTime, "Specify the wait time between the cappings:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CapTime -> 30 Second], CapTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(*Oxidation Solution*)
		Example[
			{Options, OxidationSolution, "Specify the oxidation solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, OxidationSolution -> Model[Sample, "id:o1k9jAKOwwYE"]], OxidationSolution],
			{LinkP[Model[Sample, "id:o1k9jAKOwwYE"]]}
		],

		(* Oxidation Volume *)
		Example[
			{Options, OxidationVolume, "Specify the volume of oxidation solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, OxidationVolume -> 200 Micro Liter], OxidationVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationVolume, "Automatic oxidation volume resolves to 30 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], OxidationVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationVolume, "Automatic oxidation volume resolves to 60 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], OxidationVolume],
			60 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationVolume, "Automatic oxidation volume resolves to 150 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], OxidationVolume],
			150 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Number of Oxidations*)
		Example[
			{Options, NumberOfOxidations, "Specify the number of oxidations:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfOxidations -> 3], NumberOfOxidations],
			3
		],

		(* Oxidation Time *)
		Example[
			{Options, OxidationTime, "Specify the wait time between the oxidations:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, OxidationTime -> 30 Second], OxidationTime],
			30 Second,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationTime, "Automatic oxidation time resolves to 0 seconds:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}], OxidationTime],
			0 Second,
			EquivalenceFunction -> Equal
		],

		(* Number of Post-Oxidation Washes*)
		Example[
			{Options, NumberOfOxidationWashes, "Specify the number of post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfOxidationWashes -> 3], NumberOfOxidationWashes],
			3
		],

		(* Post-Oxidation Wash Time *)
		Example[
			{Options, OxidationWashTime, "Specify the wait time between the post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, OxidationWashTime -> 30 Second], OxidationWashTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(* Post-Oxidation Wash Volume *)
		Example[
			{Options, OxidationWashVolume, "Specify the volume of the post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, OxidationWashVolume -> 30 Micro Liter], OxidationWashVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationWashVolume, "Automatic post-oxidation wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], OxidationWashVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationWashVolume, "Automatic post-oxidation wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], OxidationWashVolume],
			250 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, OxidationWashVolume, "Automatic post-oxidation wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], OxidationWashVolume],
			280 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Secondary Oxidation Solution*)
		Example[
			{Options, SecondaryOxidationSolution, "Specify the secondary oxidation solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryCyclePositions -> {{1, 3, 4}, {2}}, SecondaryOxidationSolution -> Model[Sample, "id:o1k9jAKOwwYE"]], SecondaryOxidationSolution],
			LinkP[Model[Sample, "id:o1k9jAKOwwYE"]]
		],

		(* Secondary Oxidation Volume *)
		Example[
			{Options, SecondaryOxidationVolume, "Specify the volume of the secondary oxidation solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryOxidationVolume -> 200 Micro Liter], SecondaryOxidationVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationVolume, "Automatic secondary oxidation volume resolves to 30 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], SecondaryOxidationVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationVolume, "Automatic secondary oxidation volume resolves to 60 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], SecondaryOxidationVolume],
			60 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationVolume, "Automatic secondary oxidation volume resolves to 150 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], SecondaryOxidationVolume],
			150 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Number of Secondary Oxidations*)
		Example[
			{Options, SecondaryNumberOfOxidations, "Specify the number of secondary oxidations:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryNumberOfOxidations -> 3], SecondaryNumberOfOxidations],
			3
		],

		(* Secondary Oxidation Time *)
		Example[
			{Options, SecondaryOxidationTime, "Specify the wait time between the secondary oxidations:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryOxidationTime -> 30 Second], SecondaryOxidationTime],
			30 Second,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationTime, "Automatic secondary oxidation time resolves to 60 seconds:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}], SecondaryOxidationTime],
			60 Second,
			EquivalenceFunction -> Equal
		],

		(* Number of Post-Oxidation Washes*)
		Example[
			{Options, SecondaryNumberOfOxidationWashes, "Specify the number of secondary post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryNumberOfOxidationWashes -> 3], SecondaryNumberOfOxidationWashes],
			3
		],

		(* Post-Oxidation Wash Time *)
		Example[
			{Options, SecondaryOxidationWashTime, "Specify the wait time between the secondary post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryOxidationWashTime -> 30 Second], SecondaryOxidationWashTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(* Post-Oxidation Wash Volume *)
		Example[
			{Options, SecondaryOxidationWashVolume, "Specify the volume of the secondary post-oxidation washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryOxidationWashVolume -> 30 Micro Liter], SecondaryOxidationWashVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationWashVolume, "Automatic secondary post-oxidation wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], SecondaryOxidationWashVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationWashVolume, "Automatic secondary post-oxidation wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], SecondaryOxidationWashVolume],
			250 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, SecondaryOxidationWashVolume, "Automatic secondary post-oxidation wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], SecondaryOxidationWashVolume],
			280 Microliter,
			EquivalenceFunction -> Equal
		],

		(* Secondary Cycle Position *)
		Example[{Options, SecondaryCyclePositions, "Secondary cycle positions can be specified:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, SecondaryCyclePositions -> {{1, 3, 4}, {2}}],
				SecondaryCyclePositions
			],
			{{1, 3, 4}, {2}}
		],

		(* Number of Final Washes*)
		Example[
			{Options, NumberOfFinalWashes, "Specify the number of final washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, NumberOfFinalWashes -> 3], NumberOfFinalWashes],
			3
		],


		(* Final Wash Time *)
		Example[
			{Options, FinalWashTime, "Specify the wait time between the final washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, FinalWashTime -> 30 Second], FinalWashTime],
			30 Second,
			EquivalenceFunction -> Equal
		],

		(* Final Wash Volume *)
		Example[
			{Options, FinalWashVolume, "Specify the volume of the final washes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, FinalWashVolume -> 30 Micro Liter], FinalWashVolume],
			30 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, FinalWashVolume, "Automatic final wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 40 Nano Mole], FinalWashVolume],
			200 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, FinalWashVolume, "Automatic final wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 0.2 Micro Mole], FinalWashVolume],
			250 Microliter,
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, FinalWashVolume, "Automatic final wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micro Mole], FinalWashVolume],
			280 Microliter,
			EquivalenceFunction -> Equal
		],

		(*Phosphoramidites*)
		Example[
			{Options, Phosphoramidites, "Specify the phosphoramidite to use for each unique monomer:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "id:9RdZXv15D7rx"]}, {DNA["T"], Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]}, {Modification["Cy3"], Model[Sample, StockSolution, "id:54n6evLDD5X7"]}}], Phosphoramidites],
			{
				{DNA["A"], LinkP[Model[Sample, StockSolution, "id:9RdZXv15D7rx"]]},
				{DNA["T"], LinkP[Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]]},
				{Modification["Cy3"], LinkP[Model[Sample, StockSolution, "id:54n6evLDD5X7"]]}
			}
		],
		Example[
			{Options, Phosphoramidites, "If a phosphoramidite is specified for only some of the monomers, the rest of the monomers will use their associated default:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					Phosphoramidites -> {{Modification["Cy3"], Model[Sample, StockSolution, "id:54n6evLDD5X7"]}}], Phosphoramidites],
			{
				{DNA["A"], LinkP[Model[Sample, StockSolution, "id:L8kPEjnMxvRW"]]},
				{DNA["T"], LinkP[Model[Sample, StockSolution, "id:9RdZXv15D7rx"]]},
				{Modification["Cy3"], LinkP[Model[Sample, StockSolution, "id:54n6evLDD5X7"]]}
			}
		],
		Example[
			{Options, Phosphoramidites, "Mixed phosphoramidites can be created on the fly:"},
			Download[
				ExperimentDNASynthesis[{Strand[DNA["ATGCNNN"]]},
					Phosphoramidites -> {{DNA["N"], {{DNA["A"], 0.1}, {DNA["T"], 0.2}, {DNA["G"], 0.3}, {DNA["C"], 0.4}}}}], Phosphoramidites],
			OrderlessPatternSequence[{
				{DNA["A"], LinkP[Model[Sample, StockSolution, "id:L8kPEjnMxvRW"]]},
				{DNA["T"], LinkP[Model[Sample, StockSolution, "id:9RdZXv15D7rx"]]},
				{DNA["G"], LinkP[Model[Sample, StockSolution, "id:Vrbp1jKMoZLw"]]},
				{DNA["C"], LinkP[Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]]},
				{DNA["N"], LinkP[Model[Sample, StockSolution]]}
			}],
			TimeConstraint -> 300
		],
		Example[
			{Messages, "MonomerPhosphoramiditeConflict", "If a different phosphoramidite is specified for the same monomer, an error is given:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]}, {DNA["A"], Model[Sample, StockSolution, "dT-CE Phosphoramidite 0.1M in dry Acetonitrile"]}, {Modification["Cy3"], Model[Sample, StockSolution, "id:54n6evLDD5X7"]}}],
			$Failed,
			Messages :> {Error::MonomerPhosphoramiditeConflict, Error::InvalidOption}
		],

		Example[{Options, InSitu, "The same monomer can point to the same chemical multiple times:"},
			(*Test["The same monomer can point to the same chemical multiple times:",*)
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]}, {DNA["A"], Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]}, {Modification["Cy3"], Model[Sample, StockSolution, "id:54n6evLDD5X7"]}}],
				Phosphoramidites
			],
			{
				{DNA["A"], LinkP[Model[Sample, StockSolution, "id:bq9LA0JMXo3z"]]},
				{DNA["T"], ObjectP[Model[Sample, StockSolution, "dT-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
				{Modification["Cy3"], LinkP[Model[Sample, StockSolution, "id:54n6evLDD5X7"]]}
			}
		],

		(* PhosphoramiditeDesiccants *)
		Example[
			{Options, PhosphoramiditeDesiccants, "PhosphoramiditeDesiccants automatically set to False and the resources are not populated:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}], PhosphoramiditeDesiccants],
			ListableP[Null]
		],
		Example[
			{Options, PhosphoramiditeDesiccants, "PhosphoramiditeDesiccants can be set to True and resources are created:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, PhosphoramiditeDesiccants -> True], PhosphoramiditeDesiccants],
			ListableP[LinkP[Model[Item, Consumable, "id:wqW9BP7aB7oO"]]]
		],

		(*NumberOfCouplings*)
		Example[
			{Options, NumberOfCouplings, "Specify the number of couplings to use for all monomers:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "Test oligo ATGC" <> $SessionUUID], Model[Sample, "polyATCy3Test" <> $SessionUUID]}, NumberOfCouplings -> 3],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{DNA["A"], 3}, {DNA["T"], 3}, {DNA["G"], 3}, {DNA["C"], 3}, {Modification["Cy3"], 3}}
		],
		Example[
			{Options, NumberOfCouplings, "Specify the number of couplings for specific monomers. (Note that A/T/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, NumberOfCouplings -> {{Modification["Cy3"], 4}, {"Natural", 1}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{DNA["A"], 1}, {DNA["T"], 1}, {Modification["Cy3"], 4}}
		],
		Example[
			{Options, NumberOfCouplings, "If the number of couplings is specified for some but not all of the monomers, the unspecified monomers will use the default value for the synthesis scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID]},
					NumberOfCouplings -> {{Modification["Cy5"], 4}, {"Natural", 1}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{Modification["Cy3"], 2}, {DNA["G"], 1}, {DNA["T"], 1}, {DNA["C"], 1}, {DNA["A"], 1}, {Modification["Cy5"], 4}}
		],
		Example[
			{Messages, "MonomerNumberOfCouplingsConflict", "If the same monomer is specified more than once with different values, errors:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]},
				NumberOfCouplings -> {
					{Modification["Fluorescein"], 4},
					{"Natural", 1},
					{Modification["Fluorescein"], 1}
				}],
			$Failed,
			Messages :> {Error::MonomerNumberOfCouplingsConflict, Error::InvalidOption}
		],
		Example[
			{Options, NumberOfCouplings, "Automatic number of couplings resolves to 1 for the 40 nmole scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 40 Nano Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{DNA["A"], 1}, {DNA["T"], 1}, {Modification["Cy3"], 1}, {DNA["C"], 1}, {DNA["G"], 1}}
		],
		Example[
			{Options, NumberOfCouplings, "Automatic number of couplings resolves to 2 for the 0.2 umole scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 0.2 Micro Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{DNA["A"], 2}, {DNA["T"], 2}, {Modification["Cy3"], 2}, {DNA["C"], 2}, {DNA["G"], 2}}
		],
		Example[
			{Options, NumberOfCouplings, "Automatic number of couplings resolves to 3 for the 1 umole scale::"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 1 Micro Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][NumberOfCouplings]}
			]],
			{{DNA["A"], 3}, {DNA["T"], 3}, {Modification["Cy3"], 3}, {DNA["C"], 3}, {DNA["G"], 3}}
		],


		(*PhosphoramiditeVolume*)
		Example[
			{Options, PhosphoramiditeVolume, "Specify the volume to use for all monomers:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, PhosphoramiditeVolume -> 10 Micro Liter],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{
				{DNA["A"], Quantity[0.05, ("Milliliters") / ("Micromoles")]},
				{DNA["T"], Quantity[0.05, ("Milliliters") / ("Micromoles")]},
				{Modification["Cy3"], Quantity[0.05, ("Milliliters") / ("Micromoles")]},
				{DNA["C"], Quantity[0.05, ("Milliliters") / ("Micromoles")]},
				{DNA["G"], Quantity[0.05, ("Milliliters") / ("Micromoles")]}
			},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, PhosphoramiditeVolume, "Specify the volume for specific monomers. (Note that A/T/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentDNASynthesis[
					{Model[Sample, "polyATCy3Test" <> $SessionUUID]},
					PhosphoramiditeVolume -> {{Modification["Cy3"], 40Microliter}, {"Natural", 10Microliter}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{
				{DNA["A"], Quantity[50., ("Microliters") / ("Micromoles")]},
				{DNA["T"], Quantity[50., ("Microliters") / ("Micromoles")]},
				{Modification["Cy3"], Quantity[200., ("Microliters") / ("Micromoles")]}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, PhosphoramiditeVolume, "If the volume is specified for some but not all of the monomers, the unspecified monomers will use the default value for the synthesis scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID]}, PhosphoramiditeVolume -> {{Modification["Cy3"], 40Microliter}, {"Natural", 10Microliter}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{{Modification["Cy3"], Quantity[0.2`, ("Milliliters") / ("Micromoles")]},
				{DNA["G"], Quantity[0.05`, ("Milliliters") / ("Micromoles")]},
				{DNA["T"], Quantity[0.05`, ("Milliliters") / ("Micromoles")]},
				{DNA["C"], Quantity[0.05`, ("Milliliters") / ("Micromoles")]},
				{DNA["A"], Quantity[0.05`, ("Milliliters") / ("Micromoles")]},
				{Modification["Cy5"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Messages, "MonomerPhosphoramiditeVolumeConflict", "If the same monomer is specified more than once with different values, errors:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, PhosphoramiditeVolume -> {{Modification["Cy3"], 40Microliter}, {"Natural", 10 Microliter}, {Modification["Cy3"], 10Microliter}}],
			$Failed,
			Messages :> {Error::MonomerPhosphoramiditeVolumeConflict, Error::InvalidOption}
		],
		Example[
			{Messages, "MonomerPhosphoramiditeVolumeConflict", "If the same monomer is specified more than once with different values, errors:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, PhosphoramiditeVolume -> {{Modification["Cy3"], 40Microliter}, {"Natural", 10 Microliter}, {Modification["Cy3"], 10Microliter}}],
			$Failed,
			Messages :> {Error::MonomerPhosphoramiditeVolumeConflict, Error::InvalidOption}
		],
		Test["Works if the same monomer is specified multiple times with the same volume:",
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]},
					PhosphoramiditeVolume -> {{Modification["Cy3"], 100Microliter}, {Modification["Cy3"], 0.1Milliliter}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{
				{DNA["A"], Quantity[0.15, ("Milliliters") / ("Micromoles")]},
				{DNA["T"], Quantity[0.15, ("Milliliters") / ("Micromoles")]},
				{Modification["Cy3"], Quantity[0.5, ("Milliliters") / ("Micromoles")]}
			},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, PhosphoramiditeVolume, "Automatic phosphoramidite volume resolves to 20 uL for the 40 nmole scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 40 Nano Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{
				{DNA["A"], Quantity[0.5`, ("Milliliters") / ("Micromoles")]},
				{DNA["T"], Quantity[0.5`, ("Milliliters") / ("Micromoles")]},
				{Modification["Cy3"], Quantity[0.5`, ("Milliliters") / ("Micromoles")]},
				{DNA["C"], Quantity[0.5`, ("Milliliters") / ("Micromoles")]},
				{DNA["G"], Quantity[0.5`, ("Milliliters") / ("Micromoles")]}
			},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, PhosphoramiditeVolume, "Automatic phosphoramidite volume resolves to 30 uL for the 0.2 umol scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 0.2 Micro Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{{DNA["A"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}, {DNA["T"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}, {Modification["Cy3"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}, {DNA["C"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}, {DNA["G"], Quantity[0.15`, ("Milliliters") / ("Micromoles")]}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, PhosphoramiditeVolume, "Automatic phosphoramidite volume resolves to 75 uL for the 1 umol scale:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, Scale -> 1 Micro Mole],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][MonomerVolumeRatio]}
			]],
			{{DNA["A"], Quantity[0.075`, ("Milliliters") / ("Micromoles")]}, {DNA["T"], Quantity[0.075`, ("Milliliters") / ("Micromoles")]}, {Modification["Cy3"], Quantity[0.075`, ("Milliliters") / ("Micromoles")]}, {DNA["C"], Quantity[0.075`, ("Milliliters") / ("Micromoles")]}, {DNA["G"], Quantity[0.075`, ("Milliliters") / ("Micromoles")]}},
			EquivalenceFunction -> Equal
		],


		(*CouplingTime*)
		Example[
			{Options, CouplingTime, "Specify the coupling time to use for all monomers:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}, CouplingTime -> 10 Second],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
			]],
			{{DNA["A"], 10Second}, {DNA["T"], 10Second}, {Modification["Cy3"], 10Second}, {DNA["C"], 10Second}, {DNA["G"], 10Second}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CouplingTime, "Specify the coupling time for specific monomers. (Note that A/T/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, CouplingTime -> {{Modification["Cy3"], 100 Second}, {"Natural", 10 Second}}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
			]],
			{{DNA["A"], Quantity[10, "Seconds"]}, {DNA["T"], Quantity[10, "Seconds"]}, {Modification["Cy3"], Quantity[100, "Seconds"]}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CouplingTime, "If the coupling time is specified for some but not all of the monomers, the unspecified monomers will use the default value, 200 s:"},
			Transpose[Download[
				ExperimentDNASynthesis[
					{Model[Sample, "Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID]},
					CouplingTime -> {{Modification["Cy3"], 100 Second}, {"Natural", 10 Second}}
				],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
			]],
			{
				{Modification["Cy3"], Quantity[100., "Seconds"]},
				{DNA["G"], Quantity[10., "Seconds"]},
				{DNA["T"], Quantity[10., "Seconds"]},
				{DNA["C"], Quantity[10., "Seconds"]},
				{DNA["A"], Quantity[10., "Seconds"]},
				{Modification["Cy5"], Quantity[200., "Seconds"]}
			},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CouplingTime, "Automatic coupling time resolves to 200 seconds:"},
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]}],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
			]],
			{{DNA["A"], 200 Second}, {DNA["T"], 200 Second}, {Modification["Cy3"], 200 Second}, {DNA["C"], 200 Second}, {DNA["G"], 200 Second}},
			EquivalenceFunction -> Equal
		],
		Example[
			{Messages, "MonomerCouplingTimeConflict", "If the same monomer is specified more than once with different values, errors:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID]}, CouplingTime -> {{Modification["Cy3"], 40Second}, {"Natural", 80Second}, {Modification["Cy3"], 100Second}}],
			$Failed,
			Messages :> {Error::MonomerCouplingTimeConflict, Error::InvalidOption}
		],
		Test["The same monomer may be specified multiple times with the same time:",
			Transpose[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]},
					CouplingTime -> {{Modification["Cy3"], 60Second}, {Modification["Cy3"], 1Minute}}
				],
				{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
			]],
			{{DNA["A"], 200 Second}, {DNA["T"], 200 Second}, {DNA["C"], 200 Second}, {DNA["G"], 200 Second}, {Modification["Cy3"], 60 Second}},
			EquivalenceFunction -> Equal
		],
		Test["You may provide only a modification's coupling time without providing natural coupling time without error:",
			Module[{protocolObj},
				Transpose[Download[
					ExperimentDNASynthesis[{Model[Sample, "polyATCy3Test" <> $SessionUUID], Model[Sample, "id:6V0npvK7VWMe"]},
						CouplingTime -> {{Modification["Cy3"], 60Second}}
					],
					{SynthesisCycles[[All, 1]], SynthesisCycles[[All, 2]][CouplingTime]}
				]] /. timeX : TimeP :> Convert[timeX, Second]
			],
			{{DNA["A"], 200.` Second}, {DNA["T"], 200.` Second}, {DNA["C"], 200.` Second}, {DNA["G"], 200.` Second}, {Modification["Cy3"], 60.` Second}}
		],

		(* Cleavage *)

		Example[{Options, Cleavage, "Specify that none of the strands will be cleaved:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False],
				Cleavage
			],
			{False, False}
		],
		Example[{Options, Cleavage, "Specify that all of the strands will be cleaved:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True],
				Cleavage
			],
			{True, True}
		],
		Example[{Options, Cleavage, "Specify that some of the strands will be cleaved:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {False, True}],
				Cleavage
			],
			{False, True}
		],
		Example[
			{Options, Cleavage, "Automatic cleavage defaults to True if any cleavage-related options are specified as non-Null or if StorageSolvent and StorageSolventVolume are specified as Null or if all of these options are set to Automatic, and to False if StorageSolvent and StorageSolventVolume are specified as non-Null or if any cleavage-related options are specified as Null:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageTime -> {5Hour, Automatic, Null, Automatic, Automatic},
					StorageSolventVolume -> {Automatic, 1Milliliter, Automatic, Null, Automatic}],
				Cleavage
			],
			{True, False, False, True, True}
		],
		Example[{Options, SamplesOutStorageCondition, "SamplesOutStorageCondition can be specified:"},
			options = ExperimentDNASynthesis[
				Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
				SamplesOutStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Messages, "CleavageConflict", "CleavageSolution may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageSolution -> Model[Sample, "id:N80DNjlYwVnD"]],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageWashSolution may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageWashSolution -> Model[Sample, "id:vXl9j5qEnnRD"]],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageMethod may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageMethod -> Object[Method, Cleavage, "id:N80DNjlYwRnD"]],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],

		Example[{Messages, "CleavageConflict", "CleavageTime may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageTime -> 1 Hour],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageTemperature may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageTemperature -> 40 Celsius],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageSolutionVolume may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageSolutionVolume -> 0.5 Milli Liter],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageWashVolume may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, CleavageWashVolume -> 0.6 Milli Liter],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "StorageSolventVolume may only be specified as a non-Null value for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, StorageSolventVolume -> {1 Milliliter, 0.5 Milliliter}],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "StorageSolvent may only be specified as a non-Null value for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, StorageSolvent -> Model[Sample, "id:9RdZXvKBeelX"]],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],


		Example[{Messages, "CleavageConflict", "CleavageSolution may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageSolution -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageWashSolution may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageWashSolution -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Options, CleavageMethod, "CleavageMethod may be specified as Null even if Cleavage is True since it just is used as a template for the other cleavage options:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageMethod -> Null],
				{CleavageTimes, CleavageTemperatures, CleavageSolutionVolumes, CleavageSolutions, CleavageWashSolutions, CleavageWashVolumes}],
			{
				{Quantity[8., "Hours"], Quantity[8., "Hours"]},
				{Quantity[55., "DegreesCelsius"], Quantity[55., "DegreesCelsius"]},
				{Quantity[0.8, "Milliliters"], Quantity[0.8, "Milliliters"]},
				{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, "id:N80DNjlYwVnD"]]},
				{LinkP[Model[Sample, "id:8qZ1VWNmdLBD"]], LinkP[Model[Sample, "id:8qZ1VWNmdLBD"]]},
				{Quantity[0.5, "Milliliters"], Quantity[0.5, "Milliliters"]}
			}
		],
		Example[{Messages, "CleavageConflict", "CleavageTime may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageTime -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageTemperature may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageTemperature -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageSolutionVolume may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageSolutionVolume -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "CleavageWashVolume may only be specified as Null for strands where Cleavage is False:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True, CleavageWashVolume -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "StorageSolventVolume may only be specified as Null for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, StorageSolventVolume -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageConflict", "StorageSolvent may only be specified as Null for strands where Cleavage is True:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, StorageSolvent -> Null],
			$Failed,
			Messages :> {Error::CleavageConflict, Error::InvalidOption}
		],

		Example[{Messages, "CleavageOptionSetConflict", "A cleavage-related option and a non-cleavage related option may not both set to a non-Null value for the same strand:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTime -> 5Hour, StorageSolventVolume -> 0.5Milliliter],
			$Failed,
			Messages :> {Error::CleavageOptionSetConflict, Error::InvalidOption}
		],
		Test["A cleavage-related option and a non-cleavage related option may not both set to a non-Null or both to a Null value for the same strand:",
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				CleavageTime -> {5Hour, Null, 15Hour, Null},
				StorageSolventVolume -> {0.5Milliliter, 0.75Milliliter, Null, Null}
			],
			$Failed,
			Messages :> {Error::CleavageOptionSetConflict, Error::InvalidOption}
		],
		Example[{Messages, "CleavageOptionSetConflict", "A cleavage-related option and a non-cleavage related option may not both set to Null for the same strand:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTime -> Null, StorageSolventVolume -> Null],
			$Failed,
			Messages :> {Error::CleavageOptionSetConflict, Error::InvalidOption}
		],

		(*CleavageTime*)
		Example[{Options, CleavageTime, "Specify the cleavage time:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTime -> 1 Hour], CleavageTimes],
			{1 Hour, 1 Hour},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTime, "Specify the cleavage time for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTime -> {1 Hour, 2 Hour}], CleavageTimes],
			{1 Hour, 2 Hour},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTime, "If CleavageTime is Automatic and CleavageMethod is specified, defaults to the CleavageTime for the method:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Object[Method, Cleavage, "id:eGakldJ4rPEe"]}], CleavageTimes],
			{2 Hour, 4 Hour},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTime, "If CleavageTime is Automatic, defaults to 8 hour if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageTimes],
			{8 Hour, Null},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTime, "CleavageTime may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageTime -> {Automatic, 4Hour, Automatic, Automatic, Automatic, Automatic},
				CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null, Null, Null, Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.2Milliliter, Automatic, Automatic}

			], CleavageTimes],
			{2 Hour, 4Hour, Null, Null, 2Hour, 8Hour},
			EquivalenceFunction -> Equal
		],

		(*CleavageTemperature*)
		Example[{Options, CleavageTemperature, "Specify the cleavage temperature:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTemperature -> 40 Celsius], CleavageTemperatures],
			{40 Celsius, 40 Celsius},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTemperature, "Specify the cleavage temperature for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageTemperature -> {40 Celsius, 60 Celsius}], CleavageTemperatures],
			{40 Celsius, 60 Celsius},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTemperature, "If CleavageTemperature is Automatic and CleavageMethod is specified, defaults to the CleavageTemperature for the method:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageMethod -> {Object[Method, Cleavage, "id:xRO9n3vk15Ew"], Object[Method, Cleavage, "id:eGakldJ4rPEe"]}], CleavageTemperatures],
			{65Celsius, 25Celsius},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTemperature, "If CleavageTemperature is Automatic, defaults to 55C if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageTemperatures],
			{55Celsius, Null},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageTemperature, "CleavageTemperature may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageTemperature -> {Automatic, 40Celsius, Automatic, Automatic, Automatic, 50Celsius},
				CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null, Null, Null, Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.2Milliliter, Automatic, Automatic}

			], CleavageTemperatures],
			{25Celsius, 40Celsius, Null, Null, 25Celsius, 50Celsius},
			EquivalenceFunction -> Equal
		],


		(*CleavageSolutionVolume*)
		Example[{Options, CleavageSolutionVolume, "Specify the cleavage solution volume:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageSolutionVolume -> 0.5 Milli Liter], CleavageSolutionVolumes],
			{0.5 Milli Liter, 0.5 Milli Liter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageSolutionVolume, "Specify the cleavage solution volume for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageSolutionVolume -> {0.5 Milli Liter, 0.75 Milli Liter}], CleavageSolutionVolumes],
			{0.5 Milli Liter, 0.75 Milli Liter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageSolutionVolume, "If CleavageSolutionVolume is Automatic and CleavageMethod is specified, defaults to the CleavageSolutionVolume for the method:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageMethod -> {Object[Method, Cleavage, "id:xRO9n3vk15Ew"], Object[Method, Cleavage, "id:eGakldJ4rPEe"]}], CleavageSolutionVolumes],
			{Quantity[0.6, "Milliliters"], Quantity[0.2, "Milliliters"]}
		],
		Example[{Options, CleavageSolutionVolume, "If CleavageSolutionVolume is Automatic, defaults to 800 uL if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageSolutionVolumes],
			{Quantity[0.8, "Milliliters"], Null}
		],
		Example[{Options, CleavageSolutionVolume, "CleavageSolutionVolume may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageSolutionVolume -> {Automatic, 0.4Milliliter, Automatic, Automatic, Automatic, Automatic},
				CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null, Null, Null, Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.2Milliliter, Automatic, Automatic}

			], CleavageSolutionVolumes],
			{Quantity[0.2, "Milliliters"], Quantity[0.4, "Milliliters"], Null, Null, Quantity[0.2, "Milliliters"], Quantity[0.8, "Milliliters"]},
			EquivalenceFunction -> Equal
		],

		(*CleavageWashVolume*)
		Example[{Options, CleavageWashVolume, "Specify the cleavage wash volume:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageWashVolume -> 0.7 Milli Liter], CleavageWashVolumes],
			{0.7 Milli Liter, 0.7 Milli Liter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageWashVolume, "Specify the cleavage solution volume for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageWashVolume -> {0.4 Milli Liter, 0.75 Milli Liter}], CleavageWashVolumes],
			{0.4 Milli Liter, 0.75 Milli Liter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, CleavageWashVolume, "If CleavageWashVolume is Automatic and CleavageMethod is specified, defaults to the CleavageWashVolume for the method:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageMethod -> {Object[Method, Cleavage, "id:xRO9n3vk15Ew"], Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID]}],
				CleavageWashVolumes],
			{Quantity[0.5, "Milliliters"], Quantity[0.0004000000000000001`, "Milliliters"]}
		],
		Example[{Options, CleavageWashVolume, "If CleavageWashVolume is Automatic, defaults to 500 uL if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageWashVolumes],
			{Quantity[0.5, "Milliliters"], Null}
		],
		Example[{Options, CleavageWashVolume, "CleavageWashVolume may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageWashVolume -> {Automatic, 0.4Milliliter, Automatic, Automatic, Automatic, Automatic},
				CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null, Null, Null, Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.2Milliliter, Automatic, Automatic}

			], CleavageWashVolumes],
			{Quantity[0.5, "Milliliters"], Quantity[0.4, "Milliliters"], Null, Null, Quantity[0.0004, "Milliliters"], Quantity[0.5, "Milliliters"]},
			EquivalenceFunction -> Equal
		],

		(*CleavageSolution*)
		Example[{Options, CleavageSolution, "Specify the cleavage solution :"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageSolution -> Model[Sample, "id:N80DNjlYwVnD"]], CleavageSolutions],
			{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, "id:N80DNjlYwVnD"]]}
		],
		Example[{Options, CleavageSolution, "Specify the cleavage solution for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageSolution -> {Model[Sample, "id:N80DNjlYwVnD"], Model[Sample, StockSolution, "id:o1k9jAKOw6la"]}], CleavageSolutions],
			{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, StockSolution, "id:o1k9jAKOw6la"]]}
		],
		Example[{Options, CleavageSolution, "If CleavageSolution is Automatic and CleavageMethod is specified, defaults to the CleavageSolution for the method:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageMethod -> {Object[Method, Cleavage, "id:xRO9n3vk15Ew"], Object[Method, Cleavage, "id:dORYzZJVAWxR"]}
				], CleavageSolutions],
			{ObjectP[Model[Sample, StockSolution, "Diluted Tert-butylamine"]], ObjectP[Model[Sample, StockSolution, "0.05M Potassium Carbonate in Methanol/Water"]]}
		],
		Example[{Options, CleavageSolution, "If CleavageSolution is Automatic, defaults to ammonium hydroxide if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageSolutions],
			{ObjectP[Model[Sample, "Ammonium hydroxide"]], Null}
		],
		Example[{Options, CleavageSolution, "CleavageSolution may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageTemperature -> {Automatic, 40Celsius, Automatic, Automatic, Automatic, 50Celsius},
				CleavageMethod -> {Object[Method, Cleavage, "id:mnk9jOR0JWRO"], Null, Null, Null, Object[Method, Cleavage, "id:xRO9n3vk15Ew"], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.5Milliliter, Automatic, Automatic}

			], CleavageSolutions],
			{LinkP[Model[Sample, "Ammonium hydroxide"]], LinkP[Model[Sample, "Ammonium hydroxide"]], Null, Null, LinkP[Model[Sample, StockSolution, "Diluted Tert-butylamine"]], LinkP[Model[Sample, "Ammonium hydroxide"]]}
		],

		(*CleavageWashSolution*)
		Example[{Options, CleavageWashSolution, "Specify the cleavage wash solution:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageWashSolution -> Model[Sample, "id:vXl9j5qEnnRD"]], CleavageWashSolutions],
			{LinkP[Model[Sample, "id:vXl9j5qEnnRD"]], LinkP[Model[Sample, "id:vXl9j5qEnnRD"]]}
		],
		Example[{Options, CleavageWashSolution, "Specify the cleavage wash solution for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageWashSolution -> {Model[Sample, "id:vXl9j5qEnnRD"], Model[Sample, StockSolution, "id:o1k9jAKOw6la"]}], CleavageWashSolutions],
			{LinkP[Model[Sample, "id:vXl9j5qEnnRD"]], LinkP[Model[Sample, StockSolution, "id:o1k9jAKOw6la"]]}
		],
		Example[{Options, CleavageWashSolution, "If CleavageWashSolution is Automatic and CleavageMethod is specified, defaults to the CleavageWashSolution for the method:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageMethod -> {Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID], Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID]}
				], CleavageWashSolutions],
			{ObjectP[Model[Sample, "Ethanol, Reagent Grade"]], ObjectP[Model[Sample, "Ethanol, Reagent Grade"]]}
		],
		Example[{Options, CleavageWashSolution, "If CleavageWashSolution is Automatic, defaults to water if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], CleavageWashSolutions],
			{ObjectP[Model[Sample, "Milli-Q water"]], Null}
		],
		Example[{Options, CleavageWashSolution, "CleavageWashSolution may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, True, False, Automatic, Automatic, Automatic},
				CleavageWashSolution -> {Automatic, Model[Sample, "Methanol"], Automatic, Automatic, Automatic, Automatic},
				CleavageMethod -> {Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID], Null, Null, Null, Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID], Null},
				StorageSolventVolume -> {Automatic, Automatic, Automatic, 0.2Milliliter, Automatic, Automatic}

			], CleavageWashSolutions],
			{ObjectP[Model[Sample, "Ethanol, Reagent Grade"]], ObjectP[Model[Sample, "Methanol"]], Null, Null, ObjectP[Model[Sample, "Ethanol, Reagent Grade"]], ObjectP[Model[Sample, "Milli-Q water"]]}
		],


		(*CleavageMethod*)
		Example[{Options, CleavageMethod, "Specify a cleavage method to cleave the strands. CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageWashVolume, and CleavageSolution will be pulled from the specified cleavage method:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, CleavageMethod -> Object[Method, Cleavage, "id:N80DNjlYwRnD"]],
				{CleavageMethods, CleavageTimes, CleavageTemperatures, CleavageSolutions, CleavageSolutionVolumes, CleavageWashVolumes}
			],
			{
				{LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]], LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]]},
				{Quantity[1., "Hours"], Quantity[1., "Hours"]},
				{Quantity[55., "DegreesCelsius"], Quantity[55., "DegreesCelsius"]},
				{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, "id:N80DNjlYwVnD"]]},
				{Quantity[1.0, "Milliliters"], Quantity[1.0, "Milliliters"]},
				{Quantity[0.5, "Milliliters"], Quantity[0.5, "Milliliters"]}
			}
		],
		Example[{Options, CleavageMethod, "Specify a different cleavage method for each strand:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageMethod -> {Object[Method, Cleavage, "id:N80DNjlYwRnD"], Object[Method, Cleavage, "id:xRO9n3vk15Ew"]}],
				{CleavageMethods, CleavageTimes, CleavageTemperatures, CleavageSolutions, CleavageSolutionVolumes, CleavageWashVolumes}
			],
			{
				{LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]], LinkP[Object[Method, Cleavage, "id:xRO9n3vk15Ew"]]},
				{Quantity[1., "Hours"], Quantity[20., "Hours"]},
				{Quantity[55., "DegreesCelsius"], Quantity[65., "DegreesCelsius"]},
				{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, StockSolution, "id:o1k9jAKOw6la"]]},
				{Quantity[1.0, "Milliliters"], Quantity[0.6, "Milliliters"]},
				{Quantity[0.5, "Milliliters"], Quantity[0.5, "Milliliters"]}
			}
		],
		Example[{Options, CleavageMethod, "If both CleavageMethod and CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageWashVolume, or CleavageSolution are specified, any specified cleavage conditions will overwrite the conditions specified in the cleavage method:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					CleavageMethod -> Object[Method, Cleavage, "id:N80DNjlYwRnD"],
					CleavageTime -> {Automatic, 20. Hour}],
				{CleavageMethods, CleavageTimes, CleavageTemperatures, CleavageSolutions, CleavageSolutionVolumes, CleavageWashVolumes}],
			{
				{LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]], Except[LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]]]},
				{Quantity[1., "Hours"], Quantity[20., "Hours"]},
				{Quantity[55., "DegreesCelsius"], Quantity[55., "DegreesCelsius"]},
				{LinkP[Model[Sample, "id:N80DNjlYwVnD"]], LinkP[Model[Sample, "id:N80DNjlYwVnD"]]},
				{Quantity[1.0, "Milliliters"], Quantity[1.0, "Milliliters"]},
				{Quantity[0.5, "Milliliters"], Quantity[0.5, "Milliliters"]}
			}
		],
		(*			Test["An existing cleavage method will be used if one already exists that matches the specified cleavage conditions:",*)
		(*				Download[*)
		(*					ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test"<>  $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test"<>  $SessionUUID]},*)
		(*						CleavageTime -> {Quantity[1., "Hours"], Quantity[20., "Hours"]},*)
		(*						CleavageTemperature -> {Quantity[55., "DegreesCelsius"], Quantity[65., "DegreesCelsius"]},*)
		(*						CleavageSolution -> {Model[Sample, "id:N80DNjlYwVnD"], Model[Sample, StockSolution, "id:o1k9jAKOw6la"]},*)
		(*						CleavageSolutionVolume -> {Quantity[1.0, "Milliliters"], Quantity[0.6, "Milliliters"]},*)
		(*						CleavageWashVolume -> {Quantity[0.5, "Milliliters"], Quantity[0.5, "Milliliters"]}*)
		(*					],*)
		(*					CleavageMethods],*)
		(*				{LinkP[Object[Method, Cleavage, "id:N80DNjlYwRnD"]], LinkP[Object[Method, Cleavage, "id:xRO9n3vk15Ew"]]}*)
		(*			],*)
		(*			Test["If an existing cleavage method that matches the specified cleavage conditions does not already exist, makes a new method:",*)
		(*				Module[{existingMethods, usedMethod},*)

		(*					existingMethods=Search[Object[Method, Cleavage]];*)

		(*					usedMethod=Download[*)
		(*						ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test"<>  $SessionUUID]},*)
		(*							CleavageTime -> 1Minute,*)
		(*							CleavageTemperature -> 20Celsius,*)
		(*							CleavageSolution -> Model[Sample, "Acetonitrile, anhydrous, hermetically sealed"],*)
		(*							CleavageSolutionVolume -> 20Microliter,*)
		(*							CleavageWashVolume -> 10Microliter*)
		(*						],*)
		(*						CleavageMethods[Object]];*)

		(*					Intersection[existingMethods, usedMethod]*)
		(*				],*)
		(*				{}*)
		(*			],*)

		Test["An existing synthesis cycle method will be used if one already exists that matches the specified coupling conditions:",
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					NumberOfCouplings -> 2,
					PhosphoramiditeVolume -> 30Microliter,
					CouplingTime -> 40Second,
					Scale -> 0.2 Micromole
				],
				SynthesisCycles],
			{{DNA["A"], LinkP[Object[Method, SynthesisCycle, "id:8qZ1VW0Z6lGL"]]}, {DNA["T"], LinkP[Object[Method, SynthesisCycle, "id:8qZ1VW0Z6lGL"]]}}
		],
		Test["If an existing synthesis cycle method that matches the specified coupling conditions does not already exist, makes a new method:",
			Module[{existingMethods,newMethod,methodExistenceQ},

				existingMethods = Search[Object[Method, SynthesisCycle]];

				newMethod = Download[
					ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
						NumberOfCouplings -> 4,
						PhosphoramiditeVolume -> 1 Microliter,
						CouplingTime -> 1 Second,
						Scale -> 0.2 Micromole,
						NumberOfCappings -> 4,
						NumberOfDeprotectionWashes -> 1
					],
					SynthesisCycles[[All, 2]][Object]];

				methodExistenceQ=MemberQ[existingMethods, newMethod];
				EraseObject[newMethod,Force->True];
				methodExistenceQ
			],
			False
		],


		(* StorageSolventVolume *)
		Example[{Options, StorageSolventVolume, "Specify the volume of solvent that uncleaved resin is stored in:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, StorageSolventVolume -> 1 Milliliter], StorageSolventVolumes],
			{1 Milliliter, 1 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, StorageSolventVolume, "Automatic StorageSolventVolume resolves to 200 microliter when the scale is 40 nanomole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, Scale -> 40 Nanomole], StorageSolventVolumes],
			{200 Microliter, 200 Microliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, StorageSolventVolume, "Automatic StorageSolventVolume resolves to 400 microliter when the scale is 200 nanomole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, Scale -> 0.2 Micromole], StorageSolventVolumes],
			{400 Microliter, 400 Microliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, StorageSolventVolume, "Automatic StorageSolventVolume resolves to 1000 microliter when the scale is 1000 nanomole:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False, Scale -> 1 Micromole], StorageSolventVolumes],
			{1000 Microliter, 1000 Microliter},
			EquivalenceFunction -> Equal
		],

		Example[{Options, StorageSolventVolume, "Specify a different volume of solvent for each uncleaved resin:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, StorageSolventVolume -> {1 Milliliter, 0.5 Milliliter}], StorageSolventVolumes],
			{1 Milliliter, 0.5 Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, StorageSolventVolume, "Automatic StorageSolventVolume resolves to Null when Cleavage is True:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, True}], StorageSolventVolumes],
			{Null, Null}
		],
		Example[{Options, StorageSolventVolume, "StorageSolventVolume may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, Automatic, Automatic, Automatic, False},
				StorageSolventVolume -> {Automatic, 450Microliter, Automatic, Automatic, Automatic},
				StorageSolvent -> {Automatic, Automatic, Model[Sample, "id:9RdZXvKBeelX"], Automatic, Automatic},
				CleavageTime -> {Automatic, Automatic, Automatic, 4Hour, Automatic}

			], StorageSolventVolumes],
			{Null, 450Microliter, 400Microliter, Null, 400Microliter},
			EquivalenceFunction -> Equal
		],

		(* StorageSolvent *)
		Example[{Options, StorageSolvent, "Specify the solvent that uncleaved resin is stored in:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, StorageSolvent -> Model[Sample, "id:9RdZXvKBeelX"]], StorageSolvents],
			{LinkP[Model[Sample, "id:9RdZXvKBeelX"]], LinkP[Model[Sample, "id:9RdZXvKBeelX"]]}
		],
		Example[{Options, StorageSolvent, "Automatic resolves to Milli-Q Water when Cleavage is False and Null when Cleavage is True:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], StorageSolvents],
			{Null, LinkP[Model[Sample, "id:8qZ1VWNmdLBD"]]}
		],
		Example[{Options, StorageSolvent, "Specify a different solvent for each uncleaved resin:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, StorageSolvent -> {Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:9RdZXvKBeelX"]}], StorageSolvents],
			{LinkP[Model[Sample, "id:8qZ1VWNmdLBD"]], LinkP[Model[Sample, "id:9RdZXvKBeelX"]]}
		],
		Example[{Options, StorageSolvent, "StorageSolvent may be resolved uniquely for each strand:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
				Cleavage -> {True, Automatic, Automatic, Automatic, False},
				StorageSolventVolume -> {Automatic, 450Microliter, Automatic, Automatic, Automatic},
				StorageSolvent -> {Automatic, Automatic, Model[Sample, "id:9RdZXvKBeelX"], Automatic, Automatic},
				CleavageTime -> {Automatic, Automatic, Automatic, 4Hour, Automatic}

			], StorageSolvents],
			{Null, ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]], ObjectP[Model[Sample, "id:9RdZXvKBeelX"]], Null, ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]}
		],

		Example[{Options, Name, "Give the protocol a name:"},
			Download[
				ExperimentDNASynthesis[
					{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					Name -> "My DNA Synthesis" <> $SessionUUID],
				Name],
			"My DNA Synthesis" <> $SessionUUID
		],

		Example[{Messages, "DuplicateName", "If the name is already in use, throws an error:"},
			ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Name -> "Existing DNA synthesis" <> $SessionUUID],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],

		(* Resources *)
		Test["Makes the expected resources when cleaving all the strands:",
			With[{resourceFields = Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> True], RequiredResources][[All, 2]]},
				ContainsAll[resourceFields, {ResinContainers, Filters}]
			],
			True
		],
		Test["Makes the expected resources when cleaving none of the strands:",
			With[{resourceFields = Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> False], RequiredResources][[All, 2]]},
				MemberQ[resourceFields, ResinContainers] && !MemberQ[resourceFields, Filters]
			],
			True
		],
		Test["Makes the expected resources when cleaving some of the strands:",
			With[{resourceFields = Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], RequiredResources][[All, 2]]},
				ContainsAll[resourceFields, {ResinContainers, Filters}]
			],
			True
		],
		Test["If a strand is being cleaved, the resin container resource has Rent->True, otherwise it is not rented:",
			With[{resources = Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False}], RequiredResources]},
				Cases[resources, {_, ResinContainers, ___}][[All, 1]][Rent]
			],
			{True, Null}
		],
		Test["There is a filter resource for every cleaved strand, and a resin container for all strands regardless of cleavage:",
			With[{resources = Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Cleavage -> {True, False, True}], RequiredResources]},
				{Length[Cases[resources, {_, ResinContainers, ___}]], Length[Cases[resources, {_, Filters, ___}]]}
			],
			{3, 2}
		],
		Test["Makes the expected resources for synthesis when using 1 bank:",
			With[{resourceFields = Tally[Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}], RequiredResources][[All, 2]]]},
				ContainsAll[resourceFields, {
					{Instrument, 1},
					{Columns, 2},
					{WashSolution, 1},
					{WashSolutionDesiccants, 1},
					{DeprotectionSolution, 1},
					{ActivatorSolution, 1},
					{ActivatorSolutionDesiccants, 1},
					{Phosphoramidites, 2},
					{CapASolution, 1},
					{CapBSolution, 1},
					{OxidationSolution, 1}}
				]
			],
			True
		],
		Test["Makes the expected resources for synthesis when using 2 banks:",
			With[{resourceFields = Tally[Download[ExperimentDNASynthesis[ConstantArray[Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], 25]], RequiredResources][[All, 2]]]},
				ContainsAll[resourceFields, {
					{Instrument, 1},
					{Columns, 25},
					{WashSolution, 2},
					{WashSolutionDesiccants, 2},
					{DeprotectionSolution, 1},
					{ActivatorSolution, 2},
					{ActivatorSolutionDesiccants, 2},
					{Phosphoramidites, 4},
					{CapASolution, 2},
					{CapBSolution, 2},
					{OxidationSolution, 1}}
				]
			],
			True
		],

		(* TODO: Change this back *)
		Example[{Options, InSitu, "If columns are specified as objects, uses the amount of resin present in the column object even if it differes from what we would request for the synthesis scale:"},
			(*Test["If columns are specified as objects, uses the amount of resin present in the column object even if it differes from what we would request for the synthesis scale:",*)
			Download[Cases[Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]},
					Columns -> {Object[Sample, "Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID]}],
				RequiredResources], {_, Columns, ___}][[All, 1]], Amount],
			{0.03 Gram, 0.0012 Gram},
			Messages :> {Warning::ColumnLoadingsDiffer}
		],

		(*ImageSample*)
		Example[{Options, ImageSample, "Specify that the samples should be imaged after the protocol completes:"},
			Download[ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, ImageSample -> True], ImageSample],
			True
		],
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, MeasureVolume -> False],
				MeasureVolume
			],
			False,
			TimeConstraint -> 40
		],
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, MeasureWeight -> False],
				MeasureWeight
			],
			False,
			TimeConstraint -> 40
		],
		Example[{Options, Confirm, "If Confirm -> True, skip InCart protocol status and go directly to Processing:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Confirm -> True],
				Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options, Confirm, "If Confirm -> False, the protocol will be placed in the cart but will not start processing:"},
			Download[
				ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Confirm -> False],
				Status],
			InCart
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			(referenceProtocol = ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Scale -> 1 Micromole];
			Lookup[
				Download[
					ExperimentDNASynthesis[{Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID], Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID]}, Template -> referenceProtocol],
					ResolvedOptions],
				Scale]),
			Quantity[1, "Micromoles"],
			Variables :> {referenceProtocol}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False,
		$DeveloperUpload = True
	},
	SymbolSetUp :>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = {
				Model[Sample, "No MW chemical for ExperimentDNASynthesis test" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis No Loading" <> $SessionUUID],
				Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for GC resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Container, Vessel, "Test container for amidite for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test alternative resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test GC resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test amidite object for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, Vessel, "Test container for activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Container, Vessel, "Test container for Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Container, Vessel, "Test container for Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Product, "Test product for ExperimentDNASynthesis GC resin" <> $SessionUUID],
				Object[Product, "Test product for ExperimentDNASynthesis resin" <> $SessionUUID],
				Model[Sample, "Test model sample resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Protocol, DNASynthesis, "Test template protocol for ExperimentDNASynthesis testing" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo ATGC" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo GC" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test multi-strand oligo" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID],
				Model[Molecule, Oligomer, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID],
				Model[Sample, "Test oligo GC" <> $SessionUUID],
				Model[Sample, "Test oligo ATGC" <> $SessionUUID],
				Model[Sample, "Model oligomer for ExperimentVacuumEvaporation testing (2)" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID],
				Model[Sample, "Test multi-strand oligo" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID],
				Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
				Model[Sample, "polyATCy3Test" <> $SessionUUID],
				Model[Sample, "Test GC resin model for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Protocol, DNASynthesis, "Existing DNA synthesis" <> $SessionUUID],
				Model[Molecule, Oligomer, "polyATFluorescein Test" <> $SessionUUID],
				Model[Sample, "polyAUFluoresceinTest" <> $SessionUUID],
				Object[Instrument, DNASynthesizer, "Test DNA Synthesizer for ExperimentDNASynthesis" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force->True, Verbose->False]];
		];

		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force->True, Verbose->False];

		$CreatedObjects = {};

		Module[{
			dnaSynthIdModel1,dnaSynthIdModel2,dnaSynthIdModel3,dnaSynthIdModel4,dnaSynthIdModel5,dnaSynthIdModel6,dnaSynthIdModel7,dnaSynthIdModel8,
			oligomerNames,oligomerMolecules,oligomerPacket,oligomers,sampleModelNames,sampleModelsPacket,sampleModelIDs,gcModel},

			Upload[{
				<|
					Name -> "No MW chemical for ExperimentDNASynthesis test" <> $SessionUUID,
					Type -> Model[Sample],
					DeveloperObject -> True
				|>,
				<|
					Software -> "3900",
					Status -> Available,
					Replace[StatusLog] -> {
						{
							DateObject[{2021, 6, 13, 3, 25, 50.98828840255737}, "Instant", "Gregorian", -7.],
							Available,
							Link[Object[User, Emerald, Developer, "id:J8AY5jDGol1Z"]]
						}
					},
					Model -> Link[Model[Instrument, DNASynthesizer, "id:aXRlGnZmOOPB"], Objects],
					Type -> Object[Instrument, DNASynthesizer],
					WasteScale -> Link[Object[Sensor, Weight, "id:AEqRl951OLvl"], DevicesMonitored],
					DeveloperObject -> False,
					Site -> Link[$Site],
					Name -> "Test DNA Synthesizer for ExperimentDNASynthesis" <> $SessionUUID,
					DeveloperObject -> True
				|>
			}];

			(* Upload oligomers *)
			oligomerNames =
				{
					"ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID,
					"ExperimentDNASynthesis Test oligo ATGC" <> $SessionUUID,
					"ExperimentDNASynthesis Test oligo GC" <> $SessionUUID,
					"ExperimentDNASynthesis Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID,
					"ExperimentDNASynthesis Test multi-strand oligo" <> $SessionUUID,
					"ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID,
					"polyATTest ExperimentDNASynthesis Test" <> $SessionUUID,
					"polyATFluorescein Test" <> $SessionUUID
				};

			oligomerMolecules = {
				Structure[{Strand[Modification["Cy3"], DNA["GTCAATGCC"], Modification["Cy5"]]}, {}],
				Structure[{Strand[DNA["ATGC"]]}, {}],
				Structure[{Strand[DNA["GC"]]}, {}],
				Structure[{Strand[Modification["Cy3"], Modification["2-Aminopurine"], DNA["GTCAATGCC"], Modification["Cy5"], Modification["Fluorescein"]]}, {}],
				Structure[{Strand[DNA["ATGC"]], Strand[DNA["ATGC"]]}, {}],
				Structure[{Strand[Modification["Cy3"], DNA["GTCAATGCC"], Modification["Tamra"]]}, {}],
				Structure[{Strand[DNA["ATTAA"]]}, {}],
				Structure[{Strand[DNA["ATTAAATTAA"], Modification["Cy3"]]}, {}]
			};

			oligomerPacket = UploadOligomer[oligomerMolecules, ConstantArray[DNA, Length[oligomerNames]], oligomerNames, Upload->False];

			{
				dnaSynthIdModel1,
				dnaSynthIdModel2,
				dnaSynthIdModel3,
				dnaSynthIdModel4,
				dnaSynthIdModel5,
				dnaSynthIdModel6,
				dnaSynthIdModel7,
				dnaSynthIdModel8
			} = oligomers = Upload[oligomerPacket];

			(*Upload Samples for oligomers for tests*)
			sampleModelNames = {
				"Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID,
				"Test oligo ATGC" <> $SessionUUID,
				"Test oligo GC" <> $SessionUUID,
				"Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID,
				"Test multi-strand oligo" <> $SessionUUID,
				"Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID,
				"polyATTest ExperimentDNASynthesis Test" <> $SessionUUID,
				"polyATCy3Test" <> $SessionUUID
			};

			sampleModelsPacket = UploadSampleModel[
				sampleModelNames,
				Composition->Map[{{100 MassPercent, #}}&, oligomers],
				DefaultStorageCondition->Model[StorageCondition, "id:N80DNj1r04jW"], (* Model[StorageCondition, "Refrigerator"] *)
				Expires->False,
				ShelfLife->Null,
				UnsealedShelfLife->Null,
				MSDSRequired->False,
				Flammable->False,
				IncompatibleMaterials->{None},
				(* set the state of new oligomer mixture models to liquid for now because it's breaking computed volume and volume checks *)
				State->Liquid,
				BiosafetyLevel->"BSL-1",
				Upload->False
			];
			sampleModelIDs = Upload[sampleModelsPacket];

			(* Make these objects Developer *)
			Upload[Map[<|Object->#, DeveloperObject->True|>]&, Flatten[{oligomers, sampleModelIDs}]];

			Upload[<|
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				Name->"Test container for 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID,
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				Status->Available,
				Site->Link[$Site],
				DeveloperObject->True
			|>];

			Upload[<|
				Type->Object[Sample],
				Name->"Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID,
				Mass->Quantity[0.0012`, "Grams"],
				Model->Link[Model[Sample, "id:WNa4ZjRD0z3z"], Objects],
				Status->Available,
				Replace[Composition]->{{100 MassPercent, Link[Model[Resin, "id:9RdZXv1l7pX9"]]}},
				DeveloperObject->True,
				Site->Link[$Site],
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				Name->"Test container for 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID,
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				Status->Available,
				Site->Link[$Site],
				DeveloperObject->True
			|>];

			Upload[<|
				Type->Object[Sample],
				Name->"Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID,
				Model->Link[Model[Sample, "id:WNa4ZjRD0z3z"], Objects],
				Replace[Composition]->{{100 MassPercent, Link[Model[Resin, "id:9RdZXv1l7pX9"]]}},
				Mass->Quantity[0.0012`, "Grams"],
				Status->Available,
				DeveloperObject->True,
				Site->Link[$Site],
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				Type->Object[Sample],
				Name->"Test 40 nmol column for ExperimentDNASynthesis No Loading" <> $SessionUUID,
				Model->Link[Model[Sample, "id:WNa4ZjRD0z3z"], Objects],
				Replace[Composition]->{{Null, Null}},
				Mass->Quantity[0.0012`, "Grams"],
				Status->Available,
				Site->Link[$Site],
				DeveloperObject->True,
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				Status->Available,
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				DeveloperObject->True,
				Name->"Test container for 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID
			|>];

			Upload[<|
				Mass->Quantity[0.03`, "Grams"],
				Model->Link[Model[Sample, "id:WNa4ZjRD0z3z"], Objects],
				Status->Available,
				Type->Object[Sample],
				Site->Link[$Site],
				Name->"Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID,
				Replace[Composition]->{{100MassPercent, Link[Model[Resin, "id:9RdZXv1l7pX9"]]}},
				DeveloperObject->True,
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				CleavageSolution->Link[Model[Sample, "Ammonium hydroxide"]],
				CleavageSolutionVolume->Quantity[1.`, "Milliliters"],
				CleavageTemperature->Quantity[55.`, "DegreesCelsius"],
				CleavageTime->Quantity[1.`, "Hours"],
				CleavageWashSolution->Link[Model[Sample, "Ethanol, Reagent Grade"]],
				Name->"Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID,
				NumberOfCleavageCycles->1,
				Type->Object[Method, Cleavage],
				CleavageWashVolume->0.4Microliter
			|>];

			Upload[<|
				Type->Model[Resin],
				Linker->UnySupport,
				Replace[Loading]->Quantity[0.00003333333333333`, ("Moles") / ("Grams")],
				Name->"Test resin for ExperimentDNASynthesis" <> $SessionUUID,
				ProtectingGroup->DMT,
				ResinMaterial->ControlledPoreGlass,
				State->Solid
			|>];

			Upload[<|
				Type->Model[Sample],
				Name->"Test resin sample for ExperimentDNASynthesis" <> $SessionUUID,
				Replace[Composition]->{{100MassPercent, Link[Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID]]}}
			|>];

			Upload[<|
				Object->Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID],
				DefaultSampleModel->Link[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID]]
			|>];

			Upload[<|
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				Name->"Test container for alternative resin for ExperimentDNASynthesis" <> $SessionUUID,
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				Site->Link[$Site],
				DeveloperObject->True,
				Status->Available
			|>];

			Upload[<|
				Type->Object[Sample],
				Name->"Test alternative resin for ExperimentDNASynthesis" <> $SessionUUID,
				Mass->Quantity[0.006`, "Grams"],
				Site->Link[$Site],
				Model->Link[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID], Objects],
				Status->Available,
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis" <> $SessionUUID], Contents, 2],
				DeveloperObject->True,
				Position->"A1"
			|>];

			Upload[<|
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				Site->Link[$Site],
				Name->"Test container for alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID,
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				DeveloperObject->True,
				Status->Available
			|>];

			Upload[<|
				Type->Object[Sample],
				Site->Link[$Site],
				Name->"Test alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID,
				Mass->Quantity[0.006`, "Grams"],
				Model->Link[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID], Objects],
				Status->Available,
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				Type->Object[Product],
				Name->"Test product for ExperimentDNASynthesis resin" <> $SessionUUID,
				CatalogNumber->"NAN",
				EstimatedLeadTime->Quantity[1.`, "Days"],
				Packaging->Case,
				ProductModel->Link[Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID], Products],
				Amount->6 * Milligram,
				Stocked->True,
				NumberOfItems->96,
				SampleType->Cartridge,
				UsageFrequency->Low
			|>];


			Upload[<|
				Linker->Succinyl,
				Type->Model[Resin, SolidPhaseSupport],
				Name->"Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID,
				Replace[Loading]->Quantity[0.00003333333333333`, ("Moles") / ("Grams")],
				PreDownloaded->True,
				ProtectingGroup->DMT,
				ResinMaterial->ControlledPoreGlass,
				(*Reusability -> True,*)
				State->Solid,
				Strand->Link[dnaSynthIdModel3]
			|>];

			Upload[<|
				Model->Link[Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"], Objects],
				Status->Available,
				Type->Object[Container, ReactionVessel, SolidPhaseSynthesis],
				Site->Link[$Site],
				DeveloperObject->True,
				Name->"Test container for GC resin for ExperimentDNASynthesis" <> $SessionUUID
			|>];

			gcModel = Upload[<|
				DeveloperObject->True,
				Type->Model[Sample],
				Name->"Test GC resin model for ExperimentDNASynthesis" <> $SessionUUID,
				Replace[Synonyms]->{"Test GC resin model for ExperimentDNASynthesis" <> $SessionUUID},
				Replace[Composition]->{{100MassPercent, Link[Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID]]}}
			|>];

			Upload[<|
				Type->Object[Sample],
				Mass->Quantity[0.006`, "Grams"],
				Replace[Composition]->{{100MassPercent, Link[Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID]]}},
				Status->Available,
				Site->Link[$Site],
				DeveloperObject->True,
				Name->"Test GC resin for ExperimentDNASynthesis" <> $SessionUUID,
				Model->Link[gcModel, Objects],
				Container->Link[Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for GC resin for ExperimentDNASynthesis" <> $SessionUUID], Contents, 2],
				Position->"A1"
			|>];

			Upload[<|
				Type->Model[Sample],
				Replace[Composition]->{{100MassPercent, Link[Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID]]}},
				Name->"Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID
			|>];

			Upload[<|
				Object->Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID],
				DefaultSampleModel->Link[Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID]]
			|>];

			Upload[<|
				CatalogNumber->"NAN",
				EstimatedLeadTime->Quantity[1.`, "Days"],
				Packaging->Case,
				Name->"Test product for ExperimentDNASynthesis GC resin" <> $SessionUUID,
				ProductModel->Link[Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID], Products],
				Amount->6 * Milligram,
				Stocked->True,
				SampleType->Cartridge,
				Type->Object[Product],
				UsageFrequency->Low
			|>];


			Upload[<|
				Model->Link[Model[Container, Vessel, "id:Vrbp1jG800EE"], Objects],
				Status->Available,
				Type->Object[Container, Vessel],
				DeveloperObject->True,
				Name->"Test container for amidite for ExperimentDNASynthesis" <> $SessionUUID
			|>];

			Upload[<|
				Type->Object[Sample],
				Site->Link[$Site],
				Name->"Test amidite object for ExperimentDNASynthesis" <> $SessionUUID,
				Container->Link[Object[Container, Vessel,"Test container for amidite for ExperimentDNASynthesis" <> $SessionUUID],Contents, 2],
				Mass->Quantity[4.`, "Grams"],
				Model->Link[Model[Sample, "dT-CE Phosphoramidite"], Objects],
				Replace[Composition]->{{100 MassPercent, Link[Model[Molecule, "id:01G6nvwRWRLd"]]}},
				Position->"A1",
				Status->Stocked,
				DeveloperObject->True
			|>];

			Upload[<|
				Type->Object[Protocol, DNASynthesis],
				Name->"Existing DNA synthesis" <> $SessionUUID,
				Site->Link[$Site]
			|>];

			(* Create containers for test solution objects *)
			Upload[
				{
					<|
						Model->Link[Model[Container, Vessel, "450mL DNA Synthesizer Reagent Bottle"], Objects],
						Status->Available,
						Type->Object[Container, Vessel],
						Site->Link[$Site],
						DeveloperObject->True,
						Name->"Test container for activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID
					|>,
					<|
						Model->Link[Model[Container, Vessel, "450mL DNA Synthesizer Reagent Bottle"], Objects],
						Status->Available,
						Type->Object[Container, Vessel],
						Site->Link[$Site],
						DeveloperObject->True,
						Name->"Test container for Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID
					|>,
					<|
						Model->Link[Model[Container, Vessel, "450mL DNA Synthesizer Reagent Bottle"], Objects],
						Status->Available,
						Type->Object[Container, Vessel],
						Site->Link[$Site],
						DeveloperObject->True,
						Name->"Test container for Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID
					|>
				}
			];

			(* Create test solution objects *)
			Upload[
				{
					(* Doppelganger object of Object[Sample,"id:jLq9jXvRwrWZ"] *)
					<|
						Type->Object[Sample],
						Name->"Test activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID,
						Model->Link[Model[Sample, "id:E8zoYveRlKq5"], Objects],
						Container->Link[Object[Container, Vessel, "Test container for activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID], Contents, 2],
						Density->Quantity[0.786`, ("Grams") / ("Milliliters")],
						Expires->False,
						Mass->Quantity[353.7`, "Grams"],
						ShelfLife->Quantity[365.`, "Days"],
						State->Liquid,
						Status->Stocked,
						Site->Link[$Site],
						StorageCondition->Link[Model[StorageCondition, "id:vXl9j57YrPlN"]],
						Volume->Quantity[0.45`, "Liters"],
						Replace[Composition]->{{Quantity[3,
							IndependentUnit["MassPercent"]],
							Link[Model[Molecule, "id:J8AY5jD675Px"]]}, {Quantity[90,
							IndependentUnit["MassPercent"]],
							Link[Model[Molecule, "id:6V0npvmlWlvV"]]}},
						DeveloperObject->True
					|>,
					(* Doppelganger object of Object[Sample,"id:V0npvmanwx1"] *)
					<|
						Type->Object[Sample],
						Name->"Test Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID,
						Model->Link[Model[Sample, "id:4pO6dMWvnAKX"], Objects],
						Container->Link[Object[Container, Vessel, "Test container for Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID], Contents, 2],
						Density->Quantity[0.787`, ("Grams") / ("Milliliters")],
						Expires->False,
						Mass->Quantity[354.15000000000003`, "Grams"],
						State->Liquid,
						Status->Stocked,
						Site->Link[$Site],
						StorageCondition->Link[Model[StorageCondition, "id:vXl9j57YrPlN"]],
						Volume->Quantity[0.45`, "Liters"],
						Replace[Composition]->{{Quantity[10, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:WNa4ZjKVdVpL"]]},
							{Quantity[80, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:6V0npvmlWlvV"]]},
							{Quantity[10, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:lYq9jRxPaP7r"]]}
						},
						DeveloperObject->True
					|>,
					(* Doppelganger object of Object[Sample,"id:GmzlKjPdpz6p"] *)
					<|
						Type->Object[Sample], Name->Null,
						Name->"Test Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID,
						Model->Link[Model[Sample, "id:P5ZnEj4P8qKE"], Objects],
						Container->Link[Object[Container, Vessel, "Test container for Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID], Contents, 2],
						Density->Quantity[0.916, ("Grams") / ("Milliliters")],
						Expires->False,
						Mass->Quantity[412.2, "Grams"],
						State->Liquid,
						Status->Stocked,
						Site->Link[$Site],
						StorageCondition->Link[Model[StorageCondition, "id:vXl9j57YrPlN"]],
						Volume->Quantity[0.45, "Liters"],
						Replace[Composition]->{{Quantity[20,
							IndependentUnit["VolumePercent"]],
							Link[Model[Molecule, "id:AEqRl9K67lYa"]]}, {Quantity[80,
							IndependentUnit["VolumePercent"]],
							Link[Model[Molecule, "id:54n6evLm7mvv"]]}},
						DeveloperObject->True
					|>
				}
			];

		];
	),
	SymbolTearDown :>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = {
				Model[Sample, "No MW chemical for ExperimentDNASynthesis test" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test 1000 nmol column for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Method, Cleavage, "Test cleavage method that washes with ethanol for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test 40 nmol column for ExperimentDNASynthesis No Loading" <> $SessionUUID],
				Model[Resin, "Test resin for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Sample, "Test resin sample for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for GC resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container for alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Container, Vessel, "Test container for amidite for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test alternative resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test alternative resin for ExperimentDNASynthesis (2)" <> $SessionUUID],
				Object[Sample, "Test GC resin for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Sample, "Test amidite object for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Container, Vessel, "Test container for activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Container, Vessel, "Test container for Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Container, Vessel, "Test container for Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test activator solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test Cap A solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Sample, "Test Cap B solution for ExperimentDNASynthesis Unit Test " <> $SessionUUID],
				Object[Product, "Test product for ExperimentDNASynthesis GC resin" <> $SessionUUID],
				Object[Product, "Test product for ExperimentDNASynthesis resin" <> $SessionUUID],
				Model[Sample, "Test model sample resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Resin, SolidPhaseSupport, "Test model resin oligomer GC for ExperimentDNASynthesis" <> $SessionUUID],
				Object[Protocol, DNASynthesis, "Test template protocol for ExperimentDNASynthesis testing" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo ATGC" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo GC" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test multi-strand oligo" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentDNASynthesis Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID],
				Model[Molecule, Oligomer, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-GTCAATGCC-Cy5" <> $SessionUUID],
				Model[Sample, "Test oligo GC" <> $SessionUUID],
				Model[Sample, "Test oligo ATGC" <> $SessionUUID],
				Model[Sample, "Model oligomer for ExperimentVacuumEvaporation testing (2)" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-2AP-GTCAATGCC-Cy5-Fluorescein" <> $SessionUUID],
				Model[Sample, "Test multi-strand oligo" <> $SessionUUID],
				Model[Sample, "Test oligo Cy3-GTCAATGCC-Tamra" <> $SessionUUID],
				Model[Sample, "Test GC resin model sample for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Sample, "polyATTest ExperimentDNASynthesis Test" <> $SessionUUID],
				Model[Sample, "Test GC resin model for ExperimentDNASynthesis" <> $SessionUUID],
				Model[Sample, "polyATCy3Test" <> $SessionUUID],
				Object[Protocol, DNASynthesis, "Existing DNA synthesis" <> $SessionUUID],
				Model[Molecule, Oligomer, "polyATFluorescein Test" <> $SessionUUID],
				Model[Sample, "polyAUFluoresceinTest" <> $SessionUUID],
				Object[Instrument, DNASynthesizer, "Test DNA Synthesizer for ExperimentDNASynthesis" <> $SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjs, Force->True, Verbose->False]];
		];

		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force->True, Verbose->False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
]


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASynthesisOptions*)

DefineTests[ExperimentDNASynthesisOptions,
	{
		Example[
			{Basic, "Return the resolved options:"},
			ExperimentDNASynthesisOptions[{
				Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
				Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
				Model[Sample, "Test oligo GC for ExperimentDNASynthesisOptions"]}],
			Graphics_
		],
		Example[
			{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentDNASynthesisOptions[Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisOptions"]],
			Graphics_,
			Messages :> {Error::InvalidStrands, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns as many of the options as could be resolved:"},
			ExperimentDNASynthesisOptions[{Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "Test samples for ExperimentDNASynthesisOptions"]}, {DNA["A"], Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisOptions"]}}
			],
			Graphics_,
			Messages :> {Error::MonomerPhosphoramiditeConflict, Error::InvalidOption}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentDNASynthesisOptions[{
				Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
				Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
				Model[Sample, "Test oligo GC for ExperimentDNASynthesisOptions"]}, OutputFormat -> List],
			{_Rule ..}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisOptions"],
					Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
					Model[Sample, "Test oligo GC for ExperimentDNASynthesisOptions"],
					Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisOptions"],
					Model[Sample, StockSolution, "Test samples for ExperimentDNASynthesisOptions"],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo ATGC"],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo GC"],
					Model[Molecule, Oligomer, "DNASynthOptions Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyATTest DNASynthOptions Test"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{dnaSynthIdModel2, dnaSynthIdModel3, dnaSynthIdModel5, dnaSynthIdModel7},

			(* Upload identity models *)
			{
				dnaSynthIdModel2,
				dnaSynthIdModel3,
				dnaSynthIdModel5,
				dnaSynthIdModel7
			} = Upload[{
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthOptions Test oligo ATGC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["GC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthOptions Test oligo GC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]], Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthOptions Test multi-strand oligo", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATTAA"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "polyATTest DNASynthOptions Test", DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[{
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test oligo ATGC for ExperimentDNASynthesisOptions",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ExperimentDNASynthesisOptions",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "polyATTest for ExperimentDNASynthesisOptions",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ExperimentDNASynthesisOptions",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel5]}}
				|>,
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test samples for ExperimentDNASynthesisOptions"
				|>
			}];

			Off[Warning::SamplesOutOfStock]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisOptions"],
					Model[Sample, "polyATTest for ExperimentDNASynthesisOptions"],
					Model[Sample, "Test oligo GC for ExperimentDNASynthesisOptions"],
					Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisOptions"],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo ATGC"],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo GC"],
					Model[Molecule, Oligomer, "DNASynthOptions Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyATTest DNASynthOptions Test"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		])
];



(* ::Subsubsection::Closed:: *)
(*ExperimentDNASynthesisPreview*)

DefineTests[ExperimentDNASynthesisPreview,
	{
		Example[
			{Basic, "Returns Null:"},
			ExperimentDNASynthesisPreview[{
				Model[Sample, "polyATTest for ExperimentDNASynthesisPreview"],
				Model[Sample, "polyATTest for ExperimentDNASynthesisPreview"],
				Model[Sample, "Test oligo GC for ExperimentDNASynthesisPreview"]}],
			Null
		],
		Example[
			{Basic, "Even if an input is invalid, returns Null:"},
			ExperimentDNASynthesisPreview[Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisPreview"]],
			Null,
			Messages :> {Error::InvalidStrands, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns Null:"},
			ExperimentDNASynthesisPreview[{Model[Sample, "polyATTest for ExperimentDNASynthesisPreview"]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "Test samples for ExperimentDNASynthesisPreview"]}, {DNA["A"], Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisPreview"]}}
			],
			Null,
			Messages :> {Error::MonomerPhosphoramiditeConflict, Error::InvalidOption}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisPreview"],
					Model[Sample, "polyATTest for ExperimentDNASynthesisPreview"],
					Model[Sample, "Test oligo GC for ExperimentDNASynthesisPreview"],
					Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisPreview"],
					Model[Sample, StockSolution, "Test samples for ExperimentDNASynthesisPreview"],
					Model[Molecule, Oligomer, "DNASynthPreview Test oligo ATGC"],
					Model[Molecule, Oligomer, "DNASynthPreview Test oligo GC"],
					Model[Molecule, Oligomer, "DNASynthPreview Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyATTest DNASynthPreview Test"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{dnaSynthIdModel2, dnaSynthIdModel3, dnaSynthIdModel5, dnaSynthIdModel7},

			(* Upload identity models *)
			{
				dnaSynthIdModel2,
				dnaSynthIdModel3,
				dnaSynthIdModel5,
				dnaSynthIdModel7
			} = Upload[{
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthPreview Test oligo ATGC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["GC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthPreview Test oligo GC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]], Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "DNASynthPreview Test multi-strand oligo", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATTAA"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "polyATTest DNASynthPreview Test", DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[{
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test oligo ATGC for ExperimentDNASynthesisPreview",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ExperimentDNASynthesisPreview",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "polyATTest for ExperimentDNASynthesisPreview",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ExperimentDNASynthesisPreview",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel5]}}
				|>,
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test samples for ExperimentDNASynthesisPreview"
				|>
			}];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentDNASynthesisPreview"],
					Model[Sample, "polyATTest for ExperimentDNASynthesisPreview"],
					Model[Sample, "Test oligo GC for ExperimentDNASynthesisPreview"],
					Model[Sample, StockSolution, "Test oligo ATGC for ExperimentDNASynthesisPreview"],
					Model[Sample, StockSolution, "Test samples for ExperimentDNASynthesisPreview"],
					Model[Molecule, Oligomer, "DNASynthPreview Test oligo ATGC"],
					Model[Molecule, Oligomer, "DNASynthPreview Test oligo GC"],
					Model[Molecule, Oligomer, "DNASynthPreview Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyATTest DNASynthPreview Test"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		])
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentDNASynthesisQ*)

DefineTests[ValidExperimentDNASynthesisQ,
	{
		Example[
			{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidExperimentDNASynthesisQ[{
				Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID]}],
			True
		],
		Example[
			{Basic, "If an input is invalid, returns False:"},
			ValidExperimentDNASynthesisQ[Model[Sample, "Test multi-strand oligo for ValidExperimentDNASynthesisQ"<>$SessionUUID]],
			False
		],
		Example[
			{Basic, "If an option is invalid, returns False:"},
			ValidExperimentDNASynthesisQ[{Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, "NonExistingSample"]}}
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidExperimentDNASynthesisQ[{
				Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID]},
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentDNASynthesisQ[{
				Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
				Model[Sample, "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID]},
				Verbose -> True
			],
			BooleanP
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test oligo ATGC"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test oligo GC"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test multi-strand oligo"<>$SessionUUID],
					Model[Molecule, Oligomer, "polyATTest ValidDNASynthQ Test"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{dnaSynthIdModel2, dnaSynthIdModel3, dnaSynthIdModel5, dnaSynthIdModel7},

			(* Upload identity models *)
			{
				dnaSynthIdModel2,
				dnaSynthIdModel3,
				dnaSynthIdModel5,
				dnaSynthIdModel7
			} = Upload[{
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "ValidDNASynthQ Test oligo ATGC"<>$SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["GC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "ValidDNASynthQ Test oligo GC"<>$SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATGC"]], Strand[DNA["ATGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "ValidDNASynthQ Test multi-strand oligo"<>$SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[DNA["ATTAA"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "polyATTest ValidDNASynthQ Test"<>$SessionUUID, DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ValidExperimentDNASynthesisQ"<>$SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel5]}}
				|>
			];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "polyATTest for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "Test oligo GC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Sample, "Test oligo ATGC for ValidExperimentDNASynthesisQ"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test oligo ATGC"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test oligo GC"<>$SessionUUID],
					Model[Molecule, Oligomer, "ValidDNASynthQ Test multi-strand oligo"<>$SessionUUID],
					Model[Molecule, Oligomer, "polyATTest ValidDNASynthQ Test"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		])
];