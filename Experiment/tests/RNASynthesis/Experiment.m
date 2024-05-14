(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment RNASynthesis: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*RNASynthesis*)


(* ::Subsubsection:: *)
(*ExperimentRNASynthesis*)
DefineTests[
	ExperimentRNASynthesis,
	{
		(*-- Basic --*)
		Example[{Basic,"Generates a protocol to synthesize oligonucleotides of the provided sequences:"},
			ExperimentRNASynthesis[{"AUGCAGUGAC",Strand[RNA["GUAGACUGAU"]],Structure[{Strand[RNA["UUCAGACAAG"]]},{}]}],
			ObjectP[Object[Protocol,RNASynthesis]]
		],
		Example[{Basic,"Generates a protocol to synthesize oligonucleotides:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"Test oligo AUGC"<>$SessionUUID],Model[Sample,"Test oligo GC"<>$SessionUUID]}],
			ObjectP[Object[Protocol,RNASynthesis]]
		],
		Example[{Basic,"Generates a protocol to synthesize a single oligonucleotide:"},
			ExperimentRNASynthesis[Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]],
			ObjectP[Object[Protocol,RNASynthesis]]
		],

		(*-- Messages --*)
		Example[
			{Messages,"ColumnLoadingsDiffer","If Scale is automatic and Columns is specified as an object but the columns differ in the amount of active sites, a warning is given and Scale resolves to the amount of resin active sites available on the largest column:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->{Object[Sample,"Test 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID]}],Scale],
			1 Micromole,
			EquivalenceFunction->Equal,
			Messages:>{Warning::ColumnLoadingsDiffer}
		],
		Example[
			{Messages,"MismatchedColumnAndScale","If scale does not match the amount of active sites available on the specified sample resin, a warning is given:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->Object[Sample,"Test 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Scale->40 Nano Mole],Scale],
			40 Nanomole,
			EquivalenceFunction->Equal,
			Messages:>{Warning::MismatchedColumnAndScale}
		],
		Example[
			{Messages,"InvalidResins","If a resin was given without scale information, an error is thrown:"},
			ExperimentRNASynthesis[
				{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Columns->{Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis No Loading"<>$SessionUUID],Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID]},
				Scale->40 Nano Mole
			],
			$Failed,
			Messages:>{Error::InvalidResins,Warning::ColumnLoadingsDiffer,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedColumnAndStrand","Returns Failed if the preloaded sequence on the specified resin does not match the 3' bases in the model oligomer:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->Model[Sample,"Test GC resin model for ExperimentRNASynthesis"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::MismatchedColumnAndStrand,Error::InvalidOption},
			Variables:>{protocol}
		],
		Example[{Messages,"ReusedColumn","If Columns are specified as objects (as opposed to models), unique objects must be used:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->{Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID]}],
			$Failed,
			Messages:>{Error::ReusedColumn,Error::InvalidOption}
		],
		Example[
			{Messages,"MonomerPhosphoramiditeConflict","If a different phosphoramidite is specified for the same monomer, an error is given:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Phosphoramidites->{{RNA["A"],Model[Sample,StockSolution,"id:bq9LA0JMXo3z"]},{RNA["A"],Model[Sample,StockSolution,"dT-CE Phosphoramidite 0.1M in dry Acetonitrile"]},{Modification["Cy3"],Model[Sample,StockSolution,"id:54n6evLDD5X7"]}}],
			$Failed,
			Messages:>{Error::MonomerPhosphoramiditeConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"MonomerNumberOfCouplingsConflict","If the same monomer is specified more than once with different values, errors:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},NumberOfCouplings->{{Modification["Cy3"],4},{"Natural",1},{Modification["Cy3"],1}}],
			$Failed,
			Messages:>{Error::MonomerNumberOfCouplingsConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"MonomerPhosphoramiditeVolumeConflict","If the same monomer is specified more than once with different values, errors:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},PhosphoramiditeVolume->{{Modification["Cy3"],40Microliter},{"Natural",10 Microliter},{Modification["Cy3"],10Microliter}}],
			$Failed,
			Messages:>{Error::MonomerPhosphoramiditeVolumeConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"MonomerPhosphoramiditeVolumeConflict","If the same monomer is specified more than once with different values, errors:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},PhosphoramiditeVolume->{{Modification["Cy3"],40Microliter},{"Natural",10 Microliter},{Modification["Cy3"],10Microliter}}],
			$Failed,
			Messages:>{Error::MonomerPhosphoramiditeVolumeConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"MonomerCouplingTimeConflict","If the same monomer is specified more than once with different values, errors:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},CouplingTime->{{Modification["Cy3"],40Second},{"Natural",80Second},{Modification["Cy3"],100Second}}],
			$Failed,
			Messages:>{Error::MonomerCouplingTimeConflict,Error::InvalidOption}
		],

		Example[{Messages,"CleavageConflict","CleavageSolution may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageSolution->Model[Sample,"id:N80DNjlYwVnD"]],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageWashSolution may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageWashSolution->Model[Sample,"id:vXl9j5qEnnRD"]],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageMethod may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageMethod->Object[Method,Cleavage,"id:N80DNjlYwRnD"]],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],

		Example[{Messages,"CleavageConflict","CleavageTime may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageTime->1 Hour],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageTemperature may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageTemperature->40 Celsius],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageSolutionVolume may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageSolutionVolume->0.5 Milli Liter],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageWashVolume may only be specified as a non-Null value for strands where Cleavage is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,CleavageWashVolume->0.6 Milli Liter],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","StorageSolventVolume may only be specified as a non-Null value for strands where Cleavage is False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True,StorageSolventVolume->{1 Milliliter,0.5 Milliliter}],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","StorageSolvent may only be specified as a non-Null value for strands where Cleavage is False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True,StorageSolvent->Model[Sample,"id:9RdZXvKBeelX"]],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageOptionSetConflict","A cleavage-related option and a non-cleavage related option may not both set to a non-Null value for the same strand:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTime->5Hour,StorageSolventVolume->0.5Milliliter],
			$Failed,
			Messages:>{Error::CleavageOptionSetConflict,Error::InvalidOption}
		],
		Example[{Messages,"DuplicateName","If the name is already in use, throws an error:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Name->"Existing RNA synthesis"<>$SessionUUID],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageSolution may only be specified as Null for strands where Cleavage is False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True,CleavageSolution->Null],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageConflict","CleavageWashSolution may only be specified as Null for strands where Cleavage is False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True,CleavageWashSolution->Null],
			$Failed,
			Messages:>{Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"CleavageOptionSetConflict","A cleavage-related option and a non-cleavage related option may not both set to Null for the same strand:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTime->Null,StorageSolventVolume->Null],
			$Failed,
			Messages:>{Error::CleavageOptionSetConflict,Error::InvalidOption}
		],
		Example[{Messages,"DeprotectionConflict","Option values for RNADeprotection-related options agree with the RNADeprotection option:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},RNADeprotection->False,RNADeprotectionTime->{5 Hour,5 Hour}],
			$Failed,
			Messages:>{Error::DeprotectionConflict,Error::InvalidOption}
		],
		Example[{Messages,"PostCleavageDesaltingSetConflict","PostCleavageDesalting options can not be specified with PostCleavageDesalting False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},PostCleavageDesalting->False,PostCleavageDesaltingElutionVolume->{3 Milliliter,3 Milliliter}],
			$Failed,
			Messages:>{Error::PostCleavageDesaltingSetConflict,Error::InvalidOption}
		],
		Example[{Messages,"DesaltingPriorToCleavage","PostCleavageDesalting options can not be True with Cleavage specified as False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},PostCleavageDesalting->{True,True},Cleavage->{False,False}],
			$Failed,
			TimeConstraint->300,
			Messages:>{Error::DesaltingPriorToCleavage,Error::CleavageConflict,Error::InvalidOption}
		],
		Example[{Messages,"DeprotectingWithoutResuspension","RNADeprotectionResuspension have to be Automatic or specified if RNADeprotection is True:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},RNADeprotection->{True,True},RNADeprotectionResuspensionSolutionVolume->Null],
			$Failed,
			Messages:>{Error::DeprotectingWithoutResuspension,Error::DeprotectionConflict,Error::InvalidOption}
		],
		Example[{Messages,"DesaltingPriorToDeprotection","PostRNADeprotectionDesalting options can not be True with RNADeprotection specified as False:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},PostRNADeprotectionDesalting->{True,True},RNADeprotection->{False,False}],
			$Failed,
			TimeConstraint->300,
			Messages:>{Error::DesaltingPriorToDeprotection,Error::DeprotectionConflict,Error::InvalidOption}
		],
		Example[{Messages,"NoEvaporationDeprotection","Samples have to be evaporated prior to RNADeprotection:"},
			ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},PostCleavageEvaporation->{False,False},RNADeprotection->{True,True}],
			$Failed,
			Messages:>{Error::NoEvaporationDeprotection,Error::InvalidOption}
		],

		(*-- Options --*)

		(* Synthesizer *)
		Example[
			{Options,Instrument,"Specify synthesizer instrument to use as a model:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Instrument->Model[Instrument,DNASynthesizer,"id:Vrbp1jG3Ya1O"]],
				Instrument],
			LinkP[Model[Instrument,DNASynthesizer,"id:Vrbp1jG3Ya1O"]]
		],
		Example[
			{Options,Instrument,"Specify synthesizer instrument to use as an object:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Instrument->Object[Instrument,DNASynthesizer,"Test DNA Synthesizer for ExperimentRNASynthesis"<>$SessionUUID]],
				Instrument],
			LinkP[Object[Instrument,DNASynthesizer,"Test DNA Synthesizer for ExperimentRNASynthesis"<>$SessionUUID]]
		],

		(* Scale *)
		Example[
			{Options,Scale,"Synthesize DNA using 1 umole of resin active sites:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],Scale],
			1 Micromole,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Scale,"Synthesize DNA using 0.2 umole of resin active sites:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],Scale],
			0.2 Micromole,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Scale,"Synthesize DNA using 40 nmole of resin active sites:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],Scale],
			40 Nanomole,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Scale,"Automatic scale resolves to 0.2 umole of resin unless Columns is specified as an object:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],Scale],
			0.2 Micromole,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Scale,"If Scale is automatic and Columns is specified as an object, Scale resolves to the amount of resin active sites available on the column:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->{Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID]}],Scale],
			40 Nanomole,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Scale,"If the input is a string, Scale is automatic and no Column is specified, Scale resolves to 0.2 Micromole:"},
			Lookup[ExperimentRNASynthesis["AUGCAGUGAC",Output->Options],Scale],
			0.2 Micromole
		],

		(*NumberOfReplicates*)
		Example[
			{Options,NumberOfReplicates,"Specify that the strands should be synthesized multiple times:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUCy3Test"<>$SessionUUID]},NumberOfReplicates->3],
				StrandModels],
			{ObjectP[Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]],ObjectP[Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]],ObjectP[Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]],ObjectP[Model[Sample,"polyAUCy3Test"<>$SessionUUID]],ObjectP[Model[Sample,"polyAUCy3Test"<>$SessionUUID]],ObjectP[Model[Sample,"polyAUCy3Test"<>$SessionUUID]]}
		],

		(*Columns*)
		Example[
			{Options,Columns,"Synthesize RNA using a specified Model[Sample]:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->Model[Resin,"Test resin for ExperimentRNASynthesis"<>$SessionUUID]],Columns],
			{LinkP[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID]],LinkP[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID]]}
		],
		Example[
			{Options,Columns,"Synthesize RNA using a specified Model[Sample]:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"Test oligo AUGC"<>$SessionUUID]},Columns->Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID]],Columns],
			{LinkP[Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID]]}
		],
		Example[
			{Options,Columns,"Synthesize RNA using a specified Object[Sample]:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Columns->{Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID]}],Columns],
			{LinkP[Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID]],LinkP[Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID]]}
		],
		Example[
			{Options,Columns,"Synthesize RNA using a specified Object[Sample]:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"Test oligo AUGC"<>$SessionUUID]},Columns->Object[Sample,"Test GC resin for ExperimentRNASynthesis"<>$SessionUUID]],Columns],
			{LinkP[Object[Sample,"Test GC resin for ExperimentRNASynthesis"<>$SessionUUID]]}
		],
		Example[{Options,Columns,"Synthesize DNA using a different specified Model[Sample] or Model[Resin] for each oligomer:"},
			Download[
				ExperimentRNASynthesis[
					{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"Test oligo AUGC"<>$SessionUUID]},
					Columns->{Model[Sample,"UnySupport"],Model[Resin,"Test resin for ExperimentRNASynthesis"<>$SessionUUID]}
				],
				Columns
			],
			{LinkP[Model[Sample,"UnySupport"]],LinkP[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID]]}
		],
		Example[
			{Options,Columns,"When a column with oligomer already on it, if instances of a monomer do not occur in the portion of the desired sequence that does not overlap with the existing oligomer on the resin, those monomers are non considered during option resolution:"},
			MemberQ[Flatten[Download[ExperimentRNASynthesis[{Model[Sample,"Test oligo Cy3-GUCAAUGCC-Tamra"<>$SessionUUID]},Columns->Model[Sample,"3'Tamra CPG"]],{Phosphoramidites,SynthesisCycles}]],Modification["Tamra"]],
			False
		],

		(* Number of Initial Washes*)
		Example[
			{Options,NumberOfInitialWashes,"Specify the number of washes at the start of the synthesis:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfInitialWashes->3],
				NumberOfInitialWashes],
			3
		],
		Example[
			{Options,NumberOfInitialWashes,"Automatic number of initial washes resolves to 1:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],
				NumberOfInitialWashes],
			1
		],

		(* Initial Wash Time *)
		Example[
			{Options,InitialWashTime,"Specify the wait time between the washes at the start of the synthesis:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},InitialWashTime->30 Second],
				InitialWashTime],
			30 Second,
			EquivalenceFunction->Equal
		],


		(* Initial Wash Volume *)
		Example[
			{Options,InitialWashVolume,"Specify the volume of the washes at the start of the synthesis:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},InitialWashVolume->30 Micro Liter],
				InitialWashVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,InitialWashVolume,"Automatic initial wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],
				InitialWashVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,InitialWashVolume,"Automatic initial wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],
				InitialWashVolume],
			250 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,InitialWashVolume,"Automatic initial wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],
				InitialWashVolume],
			280 Microliter,
			EquivalenceFunction->Equal
		],

		(* Number of Deprotections*)
		Example[
			{Options,NumberOfDeprotections,"Specify the number of times that the deprotection solution is added to the resin after each cycle:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfDeprotections->4],NumberOfDeprotections],
			4
		],
		Example[
			{Options,NumberOfDeprotections,"Automatic number of deprotections resolves to 2 when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],NumberOfDeprotections],
			2
		],
		Example[
			{Options,NumberOfDeprotections,"Automatic number of deprotections resolves to 2 when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],NumberOfDeprotections],
			2
		],
		Example[
			{Options,NumberOfDeprotections,"Automatic number of deprotections resolves to 3 when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],NumberOfDeprotections],
			3
		],

		(* Deprotection Time *)
		Example[
			{Options,DeprotectionTime,"Specify the wait time between the deprotections:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},DeprotectionTime->30 Second],DeprotectionTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(* Deprotection Volume *)
		Example[
			{Options,DeprotectionVolume,"Specify the volume of deprotection solvent used in each deprotection iteration:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},DeprotectionVolume->30 Micro Liter],DeprotectionVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionVolume,"Automatic deprotection volume resolves to 60 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],DeprotectionVolume],
			60 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionVolume,"Automatic deprotection volume resolves to 140 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],DeprotectionVolume],
			140 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionVolume,"Automatic deprotection volume resolves to 180 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],DeprotectionVolume],
			180 Microliter,
			EquivalenceFunction->Equal
		],

		(* Final Deprotection *)
		Example[
			{Options,FinalDeprotection,"Specify whether the oligomers will be deprotected (detritylated) at the end of the synthesis:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},FinalDeprotection->False],FinalDeprotection],
			{False,False}
		],
		Example[
			{Options,FinalDeprotection,"Specify different final deprotection options for different oligomers:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},FinalDeprotection->{True,False}],FinalDeprotection],
			{True,False}
		],

		(* Number of Post-Deprotection Washes*)
		Example[
			{Options,NumberOfDeprotectionWashes,"Specify the number of times the resin is washed after deprotection:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfDeprotectionWashes->3],NumberOfDeprotectionWashes],
			3
		],

		(* Deprotection Wash Time *)
		Example[
			{Options,DeprotectionWashTime,"Specify the wait time between the post-deprotection washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},DeprotectionWashTime->30 Second],DeprotectionWashTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(* Deprotection Wash Volume *)
		Example[
			{Options,DeprotectionWashVolume,"Specify the volume of the post-deprotection washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},DeprotectionWashVolume->30 Micro Liter],DeprotectionWashVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionWashVolume,"Automatic deprotection wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],DeprotectionWashVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionWashVolume,"Automatic deprotection wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],DeprotectionWashVolume],
			250 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeprotectionWashVolume,"Automatic deprotection wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],DeprotectionWashVolume],
			280 Microliter,
			EquivalenceFunction->Equal
		],

		(*Activator Solution*)
		Example[
			{Options,ActivatorSolution,"Specify the activator solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},ActivatorSolution->Model[Sample,"id:E8zoYveRlKq5"]],ActivatorSolution],
			{LinkP[Model[Sample,"id:E8zoYveRlKq5"]]}
		],

		(* Activator Volume *)
		Example[
			{Options,ActivatorVolume,"Specify the volume of activator solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},ActivatorVolume->30 Micro Liter],ActivatorVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ActivatorVolume,"Automatic activator volume resolves to 40 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],ActivatorVolume],
			40 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ActivatorVolume,"Automatic activator volume resolves to 45 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],ActivatorVolume],
			45 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ActivatorVolume,"Automatic activator volume resolves to 115 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],ActivatorVolume],
			115 Microliter,
			EquivalenceFunction->Equal
		],

		(*CapA Solution*)
		Example[
			{Options,CapASolution,"Specify the Cap A solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CapASolution->Model[Sample,"id:4pO6dMWvnAKX"]],CapASolution],
			{LinkP[Model[Sample,"id:4pO6dMWvnAKX"]]}
		],
		Example[
			{Options,CapASolution,"Cap A automatically set to Ultramild cap A:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],CapASolution],
			{LinkP[Model[Sample,"Ultramild cap A"]]}
		],

		(* CapA Volume *)
		Example[
			{Options,CapAVolume,"Specify the volume of Cap A solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CapAVolume->200 Micro Liter],CapAVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapAVolume,"Automatic Cap A volume resolves to 40 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],CapAVolume],
			20 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapAVolume,"Automatic Cap A volume resolves to 30 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],CapAVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapAVolume,"Automatic Cap A volume resolves to 80 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],CapAVolume],
			80 Microliter,
			EquivalenceFunction->Equal
		],

		(*CapB Solution*)
		Example[
			{Options,CapBSolution,"Specify the Cap B solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CapBSolution->Model[Sample,"id:P5ZnEj4P8qKE"]],CapBSolution],
			{LinkP[Model[Sample,"id:P5ZnEj4P8qKE"]]}
		],

		(* CapB Volume *)
		Example[
			{Options,CapBVolume,"Specify the volume of Cap B solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CapBVolume->200 Micro Liter],CapBVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapBVolume,"Automatic Cap B volume resolves to 20 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],CapBVolume],
			20 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapBVolume,"Automatic Cap B volume resolves to 30 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],CapBVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,CapBVolume,"Automatic Cap B volume resolves to 80 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],CapBVolume],
			80 Microliter,
			EquivalenceFunction->Equal
		],

		(* Number of Cappings*)
		Example[
			{Options,NumberOfCappings,"Specify the number of cappings:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfCappings->3],NumberOfCappings],
			3
		],

		(* Cap Time *)
		Example[
			{Options,CapTime,"Specify the wait time between the cappings:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CapTime->30 Second],CapTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(*Oxidation Solution*)
		Example[
			{Options,OxidationSolution,"Specify the oxidation solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},OxidationSolution->Model[Sample,"id:o1k9jAKOwwYE"]],OxidationSolution],
			{LinkP[Model[Sample,"id:o1k9jAKOwwYE"]]}
		],

		(* Oxidation Volume *)
		Example[
			{Options,OxidationVolume,"Specify the volume of oxidation solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},OxidationVolume->200 Micro Liter],OxidationVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationVolume,"Automatic oxidation volume resolves to 30 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],OxidationVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationVolume,"Automatic oxidation volume resolves to 60 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],OxidationVolume],
			60 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationVolume,"Automatic oxidation volume resolves to 150 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],OxidationVolume],
			150 Microliter,
			EquivalenceFunction->Equal
		],

		(* Number of Oxidations*)
		Example[
			{Options,NumberOfOxidations,"Specify the number of oxidations:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfOxidations->3],NumberOfOxidations],
			3
		],

		(* Oxidation Time *)
		Example[
			{Options,OxidationTime,"Specify the wait time between the oxidations:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},OxidationTime->30 Second],OxidationTime],
			30 Second,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationTime,"Automatic oxidation time resolves to 0 seconds:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],OxidationTime],
			0 Second,
			EquivalenceFunction->Equal
		],

		(* Number of Post-Oxidation Washes*)
		Example[
			{Options,NumberOfOxidationWashes,"Specify the number of post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfOxidationWashes->3],NumberOfOxidationWashes],
			3
		],

		(* Post-Oxidation Wash Time *)
		Example[
			{Options,OxidationWashTime,"Specify the wait time between the post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},OxidationWashTime->30 Second],OxidationWashTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(* Post-Oxidation Wash Volume *)
		Example[
			{Options,OxidationWashVolume,"Specify the volume of the post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},OxidationWashVolume->30 Micro Liter],OxidationWashVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationWashVolume,"Automatic post-oxidation wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],OxidationWashVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationWashVolume,"Automatic post-oxidation wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],OxidationWashVolume],
			250 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,OxidationWashVolume,"Automatic post-oxidation wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],OxidationWashVolume],
			280 Microliter,
			EquivalenceFunction->Equal
		],

		(* Secondary Oxidation Solution*)
		Example[
			{Options,SecondaryOxidationSolution,"Specify the secondary oxidation solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryCyclePositions->{{1,3,4},{2}},SecondaryOxidationSolution->Model[Sample,"id:o1k9jAKOwwYE"]],SecondaryOxidationSolution],
			LinkP[Model[Sample,"id:o1k9jAKOwwYE"]]
		],

		(* Secondary Oxidation Volume *)
		Example[
			{Options,SecondaryOxidationVolume,"Specify the volume of the secondary oxidation solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryOxidationVolume->200 Micro Liter],SecondaryOxidationVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationVolume,"Automatic secondary oxidation volume resolves to 30 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],SecondaryOxidationVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationVolume,"Automatic secondary oxidation volume resolves to 60 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],SecondaryOxidationVolume],
			60 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationVolume,"Automatic secondary oxidation volume resolves to 150 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],SecondaryOxidationVolume],
			150 Microliter,
			EquivalenceFunction->Equal
		],

		(* Number of Secondary Oxidations*)
		Example[
			{Options,SecondaryNumberOfOxidations,"Specify the number of secondary oxidations:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryNumberOfOxidations->3],SecondaryNumberOfOxidations],
			3
		],

		(* Secondary Oxidation Time *)
		Example[
			{Options,SecondaryOxidationTime,"Specify the wait time between the secondary oxidations:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryOxidationTime->30 Second],SecondaryOxidationTime],
			30 Second,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationTime,"Automatic secondary oxidation time resolves to 60 seconds:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],SecondaryOxidationTime],
			60 Second,
			EquivalenceFunction->Equal
		],

		(* Number of Post-Oxidation Washes*)
		Example[
			{Options,SecondaryNumberOfOxidationWashes,"Specify the number of secondary post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryNumberOfOxidationWashes->3],SecondaryNumberOfOxidationWashes],
			3
		],

		(* Post-Oxidation Wash Time *)
		Example[
			{Options,SecondaryOxidationWashTime,"Specify the wait time between the secondary post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryOxidationWashTime->30 Second],SecondaryOxidationWashTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(* Post-Oxidation Wash Volume *)
		Example[
			{Options,SecondaryOxidationWashVolume,"Specify the volume of the secondary post-oxidation washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryOxidationWashVolume->30 Micro Liter],SecondaryOxidationWashVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationWashVolume,"Automatic secondary post-oxidation wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],SecondaryOxidationWashVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationWashVolume,"Automatic secondary post-oxidation wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],SecondaryOxidationWashVolume],
			250 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SecondaryOxidationWashVolume,"Automatic secondary post-oxidation wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],SecondaryOxidationWashVolume],
			280 Microliter,
			EquivalenceFunction->Equal
		],

		(* Secondary Cycle Position *)
		Example[{Options,SecondaryCyclePositions,"Secondary cycle positions can be specified:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},SecondaryCyclePositions->{{1,3,4},{2}}],
				SecondaryCyclePositions
			],
			{{1,3,4},{2}}
		],

		(* Number of Final Washes*)
		Example[
			{Options,NumberOfFinalWashes,"Specify the number of final washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},NumberOfFinalWashes->3],NumberOfFinalWashes],
			3
		],

		(* Final Wash Time *)
		Example[
			{Options,FinalWashTime,"Specify the wait time between the final washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},FinalWashTime->30 Second],FinalWashTime],
			30 Second,
			EquivalenceFunction->Equal
		],

		(* Final Wash Volume *)
		Example[
			{Options,FinalWashVolume,"Specify the volume of the final washes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},FinalWashVolume->30 Micro Liter],FinalWashVolume],
			30 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,FinalWashVolume,"Automatic final wash volume resolves to 200 microliter when scale is 40 nmole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->40 Nano Mole],FinalWashVolume],
			200 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,FinalWashVolume,"Automatic final wash volume resolves to 250 microliter when scale is 0.2 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->0.2 Micro Mole],FinalWashVolume],
			250 Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options,FinalWashVolume,"Automatic final wash volume resolves to 280 microliter when scale is 1 umole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micro Mole],FinalWashVolume],
			280 Microliter,
			EquivalenceFunction->Equal
		],

		(*Phosphoramidites*)
		(* TODO change tests *)
		(* yeah, this is not a U monomer, but we are testing that we totally inherit whatever user says to us *)
		Example[
			{Options,Phosphoramidites,"Specify the phosphoramidite to use for each unique monomer:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					Phosphoramidites->{
						{RNA["A"],Model[Sample,StockSolution,"Cy3 Phosphoramidite 0.1M in dry Acetonitrile"]},
						{RNA["U"],Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]},
						{Modification["Cy3"],Model[Sample,StockSolution,"U-CE Phosphoramidite 0.1M in dry Acetonitrile"]}}],
				Phosphoramidites
			],
			{
				OrderlessPatternSequence[
					{RNA["A"],LinkP[Model[Sample,StockSolution,"Cy3 Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{RNA["U"],LinkP[Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{Modification["Cy3"],LinkP[Model[Sample,StockSolution,"U-CE Phosphoramidite 0.1M in dry Acetonitrile"]]}]

			}
		],
		Example[
			{Options,Phosphoramidites,"If a phosphoramidite is specified for only some of the monomers, the rest of the monomers will use their associated default:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					Phosphoramidites->{{RNA["A"],Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]}}],Phosphoramidites],
			{
				OrderlessPatternSequence[
					{RNA["A"],LinkP[Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{RNA["U"],LinkP[Model[Sample,StockSolution,"U-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{Modification["Cy3"],LinkP[Model[Sample,StockSolution,"Cy3 Phosphoramidite 0.1M in dry Acetonitrile"]]}]

			}
		],

		(*			Example[*)
		(*				{Options, Phosphoramidites, "Phosphoramidites may be specified as objects as well as models:"},*)
		(*				Download[*)
		(*					ExperimentRNASynthesis[{Model[Sample, "polyAUCy3Test"<>$SessionUUID], Model[Sample, "polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},*)
		(*						Phosphoramidites -> {{RNA["A"], Model[Sample, StockSolution,  "Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]}, {RNA["U"], Model[Sample, "dT-CE Phosphoramidite"]}, {Modification["Cy3"], Model[Sample, "Cy3"]}}], Phosphoramidites],*)
		(*				{OrderlessPatternSequence[*)
		(*					{RNA["A"], LinkP[Object[Sample, "Test amidite object for ExperimentRNASynthesis"<>$SessionUUID]]},*)
		(*					{RNA["U"], LinkP[Model[Sample, "dT-CE Phosphoramidite"]]},*)
		(*					{Modification["Cy3"], LinkP[Model[Sample, "Cy3"]]}]*)
		(*				}*)
		(*			],*)

		Example[{Options,InSitu,"The same monomer can point to the same chemical multiple times:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Phosphoramidites->{
					{RNA["A"],Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]},
					{RNA["A"],Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]},
					{Modification["Cy3"],Model[Sample,StockSolution,"Cy3 Phosphoramidite 0.1M in dry Acetonitrile"]}}],
				Phosphoramidites
			],
			{
				OrderlessPatternSequence[
					{RNA["A"],LinkP[Model[Sample,StockSolution,"Ac-dC-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{RNA["U"],LinkP[Model[Sample,StockSolution,"U-CE Phosphoramidite 0.1M in dry Acetonitrile"]]},
					{Modification["Cy3"],LinkP[Model[Sample,StockSolution,"Cy3 Phosphoramidite 0.1M in dry Acetonitrile"]]}]

			}
		],

		(*NumberOfCouplings*)
		Example[
			{Options,NumberOfCouplings,"Specify the number of couplings to use for all monomers:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"Test oligo AUGC"<>$SessionUUID],Model[Sample,"polyAUCy3Test"<>$SessionUUID]},NumberOfCouplings->3],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{RNA["A"],3},{RNA["U"],3},{RNA["G"],3},{RNA["C"],3},{Modification["Cy3"],3}]}
		],
		Example[
			{Options,NumberOfCouplings,"Specify the number of couplings for specific monomers. (Note that A/T/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},NumberOfCouplings->{{Modification["Cy3"],4},{"Natural",1}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{RNA["A"],1},{RNA["U"],1},{Modification["Cy3"],4}]}
		],
		Example[
			{Options,NumberOfCouplings,"If the number of couplings is specified for some but not all of the monomers, the unspecified monomers will use the default value for the synthesis scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID]},NumberOfCouplings->{{"Natural",1}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{Modification["Cy3"],2},{RNA["G"],1},{RNA["U"],1},{RNA["C"],1},{RNA["A"],1}]}
		],
		Example[
			{Options,NumberOfCouplings,"Automatic number of couplings resolves to 1 for the 40 nmole scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->40 Nano Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{RNA["A"],1},{RNA["U"],1},{Modification["Cy3"],1},{RNA["C"],1},{RNA["G"],1}]}
		],
		Example[
			{Options,NumberOfCouplings,"Automatic number of couplings resolves to 2 for the 0.2 umole scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->0.2 Micro Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{RNA["A"],2},{RNA["U"],2},{Modification["Cy3"],2},{RNA["C"],2},{RNA["G"],2}]}
		],
		Example[
			{Options,NumberOfCouplings,"Automatic number of couplings resolves to 3 for the 1 umole scale::"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->1 Micro Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][NumberOfCouplings]}
			]],
			{OrderlessPatternSequence[{RNA["A"],3},{RNA["U"],3},{Modification["Cy3"],3},{RNA["C"],3},{RNA["G"],3}]}
		],


		(*PhosphoramiditeVolume*)
		Example[
			{Options,PhosphoramiditeVolume,"Specify the volume to use for all monomers:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},PhosphoramiditeVolume->10 Micro Liter],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[
				{RNA["A"],Quantity[0.05,("Milliliters") / ("Micromoles")]},
				{RNA["U"],Quantity[0.05,("Milliliters") / ("Micromoles")]},
				{Modification["Cy3"],Quantity[0.05,("Milliliters") / ("Micromoles")]},
				{RNA["C"],Quantity[0.05,("Milliliters") / ("Micromoles")]},
				{RNA["G"],Quantity[0.05,("Milliliters") / ("Micromoles")]}
			]
			}
		],
		Example[
			{Options,PhosphoramiditeVolume,"Specify the volume for specific monomers. (Note that A/U/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},PhosphoramiditeVolume->{{Modification["Cy3"],40Microliter},{"Natural",10Microliter}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[{RNA["A"],Quantity[0.05`,("Milliliters") / ("Micromoles")]},{RNA["U"],Quantity[0.05`,("Milliliters") / ("Micromoles")]},{Modification["Cy3"],Quantity[0.2`,("Milliliters") / ("Micromoles")]}]}
		],
		Example[
			{Options,PhosphoramiditeVolume,"If the volume is specified for some but not all of the monomers, the unspecified monomers will use the default value for the synthesis scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID]},PhosphoramiditeVolume->{{"Natural",10Microliter}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[{Modification["Cy3"],
				Quantity[0.15`,("Milliliters") / ("Micromoles")]},{RNA["G"],
				Quantity[0.05`,("Milliliters") / ("Micromoles")]},{RNA["U"],
				Quantity[0.05`,("Milliliters") / ("Micromoles")]},{RNA["C"],
				Quantity[0.05`,("Milliliters") / ("Micromoles")]},{RNA["A"],
				Quantity[0.05`,("Milliliters") / ("Micromoles")]}]}
		],
		Test["Works if the same monomer is specified multiple times with the same volume:",
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},
					PhosphoramiditeVolume->{{Modification["Cy3"],100Microliter},{Modification["Cy3"],0.1Milliliter}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[
				{RNA["A"],Quantity[0.15,("Milliliters") / ("Micromoles")]},
				{RNA["U"],Quantity[0.15,("Milliliters") / ("Micromoles")]},
				{Modification["Cy3"],Quantity[0.5,("Milliliters") / ("Micromoles")]}]
			}
		],
		Example[
			{Options,PhosphoramiditeVolume,"Automatic phosphoramidite volume resolves to 20 uL for the 40 nmole scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->40 Nano Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[{RNA["A"],Quantity[0.5`,("Milliliters") / ("Micromoles")]},{RNA["U"],Quantity[0.5`,("Milliliters") / ("Micromoles")]},{Modification["Cy3"],Quantity[0.5`,("Milliliters") / ("Micromoles")]},{RNA["C"],Quantity[0.5`,("Milliliters") / ("Micromoles")]},{RNA["G"],Quantity[0.5`,("Milliliters") / ("Micromoles")]}]}
		],
		Example[
			{Options,PhosphoramiditeVolume,"Automatic phosphoramidite volume resolves to 30 uL for the 0.2 umol scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->0.2 Micro Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[{RNA["A"],Quantity[0.15`,("Milliliters") / ("Micromoles")]},{RNA["U"],Quantity[0.15`,("Milliliters") / ("Micromoles")]},{Modification["Cy3"],Quantity[0.15`,("Milliliters") / ("Micromoles")]},{RNA["C"],Quantity[0.15`,("Milliliters") / ("Micromoles")]},{RNA["G"],Quantity[0.15`,("Milliliters") / ("Micromoles")]}]}
		],
		Example[
			{Options,PhosphoramiditeVolume,"Automatic phosphoramidite volume resolves to 75 uL for the 1 umol scale:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},Scale->1 Micro Mole],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][MonomerVolumeRatio]}
			]],
			{OrderlessPatternSequence[{RNA["A"],Quantity[0.075`,("Milliliters") / ("Micromoles")]},{RNA["U"],Quantity[0.075`,("Milliliters") / ("Micromoles")]},{Modification["Cy3"],Quantity[0.075`,("Milliliters") / ("Micromoles")]},{RNA["C"],Quantity[0.075`,("Milliliters") / ("Micromoles")]},{RNA["G"],Quantity[0.075`,("Milliliters") / ("Micromoles")]}]}
		],

		(* PhosphoramiditeDesiccants *)
		Example[
			{Options,PhosphoramiditeDesiccants,"PhosphoramiditeDesiccants automatically set to False and the resources are not populated:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],PhosphoramiditeDesiccants],
			ListableP[Null]
		],
		Example[
			{Options,PhosphoramiditeDesiccants,"PhosphoramiditeDesiccants can be set to True and resources are created:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},PhosphoramiditeDesiccants->True],PhosphoramiditeDesiccants],
			ListableP[LinkP[Model[Item,Consumable,"id:wqW9BP7aB7oO"]]]
		],


		(*CouplingTime*)
		Example[
			{Options,CouplingTime,"Specify the coupling time to use for all monomers:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]},CouplingTime->1 Minute],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][CouplingTime]}
			]],
			{OrderlessPatternSequence[{RNA["A"],1.` Minute},{RNA["U"],1.` Minute},{Modification["Cy3"],1.` Minute},{RNA["C"],1.` Minute},{RNA["G"],1.` Minute}]}
		],
		Example[
			{Options,CouplingTime,"Specify the coupling time for specific monomers. (Note that A/T/G/C, specified by \"Natural\", must use the same option value:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID]},CouplingTime->{{Modification["Cy3"],2 Minute},{"Natural",1 Minute}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][CouplingTime]}
			]],
			{OrderlessPatternSequence[{RNA["A"],Quantity[1.`,"Minutes"]},{RNA["U"],Quantity[1.`,"Minutes"]},{Modification["Cy3"],Quantity[2.`,"Minutes"]}]}
		],
		Example[
			{Options,CouplingTime,"If the coupling time is specified for some but not all of the monomers, the unspecified monomers will use the default value, 6 Minutes:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID]},CouplingTime->{ {"Natural",1 Minute}}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][CouplingTime]}
			]],
			{OrderlessPatternSequence[{Modification["Cy3"],6.` Minute},{RNA["G"],Quantity[1.,"Minutes"]},{RNA["U"],Quantity[1.,"Minutes"]},{RNA["C"],Quantity[1.,"Minutes"]},{RNA["A"],Quantity[1.,"Minutes"]}]}
		],
		Example[
			{Options,CouplingTime,"Automatic coupling time resolves to 6 Minutes:"},
			Transpose[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUCy3Test"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID]}],
				{SynthesisCycles[[All,1]],SynthesisCycles[[All,2]][CouplingTime]}
			]],
			{OrderlessPatternSequence[{RNA["A"],6.` Minute},{RNA["U"],6.` Minute},{Modification["Cy3"],6.` Minute},{RNA["C"],6.` Minute},{RNA["G"],6.` Minute}]}
		],

		(* Cleavage *)

		Example[{Options,Cleavage,"Specify that none of the strands will be cleaved:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False],
				Cleavage
			],
			{False,False}
		],
		Example[{Options,Cleavage,"Specify that all of the strands will be cleaved:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True],
				Cleavage
			],
			{True,True}
		],
		Example[{Options,Cleavage,"Specify that some of the strands will be cleaved:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{False,True}],
				Cleavage
			],
			{False,True}
		],
		Example[
			{Options,Cleavage,"Automatic cleavage defaults to True if any cleavage-related options are specified as non-Null or if StorageSolvent and StorageSolventVolume are specified as Null or if all of these options are set to Automatic, and to False if StorageSolvent and StorageSolventVolume are specified as non-Null or if any cleavage-related options are specified as Null:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageTime->{5Hour,Automatic,Null,Automatic,Automatic},
					StorageSolventVolume->{Automatic,1Milliliter,Automatic,Null,Automatic}],
				Cleavage
			],
			{True,False,False,True,True}
		],
		Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition can be specified:"},
			options=ExperimentRNASynthesis[
				Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],
				SamplesOutStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

		Example[{Options,CleavageMethod,"CleavageMethod may be specified as Null even if Cleavage is True since it just is used as a template for the other cleavage options:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True,CleavageMethod->Null],
				{CleavageTimes,CleavageTemperatures,CleavageSolutionVolumes,CleavageSolutions,CleavageWashSolutions,CleavageWashVolumes}],
			{
				{Quantity[0.75,"Hour"],Quantity[0.75,"Hour"]},
				{Quantity[65.,"DegreesCelsius"],Quantity[65.,"DegreesCelsius"]},
				{Quantity[0.8,"Milliliters"],Quantity[0.8,"Milliliters"]},
				{LinkP[Model[Sample,StockSolution,"RNA Cleavage solution APA"]],LinkP[Model[Sample,StockSolution,"RNA Cleavage solution APA"]]},
				{LinkP[Model[Sample,"id:8qZ1VWNmdLBD"]],LinkP[Model[Sample,"id:8qZ1VWNmdLBD"]]},
				{Quantity[0.5,"Milliliters"],Quantity[0.5,"Milliliters"]}
			}
		],

		(*CleavageTime*)
		Example[{Options,CleavageTime,"Specify the cleavage time:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTime->1 Hour],CleavageTimes],
			{1 Hour,1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTime,"Specify the cleavage time for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTime->{1 Hour,2 Hour}],CleavageTimes],
			{1 Hour,2 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTime,"If CleavageTime is Automatic and CleavageMethod is specified, defaults to the CleavageTime for the method:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Object[Method,Cleavage,"id:eGakldJ4rPEe"]}],CleavageTimes],
			{2 Hour,4 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTime,"If CleavageTime is Automatic, defaults to 45 minutes if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageTimes],
			{0.75 Hour,Null},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTime,"CleavageTime may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageTime->{Automatic,4Hour,Automatic,Automatic,Automatic,Automatic},
				CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null,Null,Null,Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.2Milliliter,Automatic,Automatic}

			],CleavageTimes],
			{2.` Hour,4.` Hour,Null,Null,2.` Hour,0.75` Hour},
			EquivalenceFunction->Equal
		],

		(*CleavageTemperature*)
		Example[{Options,CleavageTemperature,"Specify the cleavage temperature:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTemperature->40 Celsius],CleavageTemperatures],
			{40 Celsius,40 Celsius},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTemperature,"Specify the cleavage temperature for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageTemperature->{40 Celsius,60 Celsius}],CleavageTemperatures],
			{40 Celsius,60 Celsius},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTemperature,"If CleavageTemperature is Automatic and CleavageMethod is specified, defaults to the CleavageTemperature for the method:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageMethod->{Object[Method,Cleavage,"id:xRO9n3vk15Ew"],Object[Method,Cleavage,"id:eGakldJ4rPEe"]}],CleavageTemperatures],
			{65Celsius,25Celsius},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTemperature,"If CleavageTemperature is Automatic, defaults to 65C if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageTemperatures],
			{65Celsius,Null},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageTemperature,"CleavageTemperature may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageTemperature->{Automatic,40Celsius,Automatic,Automatic,Automatic,50Celsius},
				CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null,Null,Null,Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.2Milliliter,Automatic,Automatic}

			],CleavageTemperatures],
			{25Celsius,40Celsius,Null,Null,25Celsius,50Celsius},
			EquivalenceFunction->Equal
		],


		(*CleavageSolutionVolume*)
		Example[{Options,CleavageSolutionVolume,"Specify the cleavage solution volume:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageSolutionVolume->0.5 Milli Liter],CleavageSolutionVolumes],
			{0.5 Milli Liter,0.5 Milli Liter},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageSolutionVolume,"Specify the cleavage solution volume for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageSolutionVolume->{0.5 Milli Liter,0.75 Milli Liter}],CleavageSolutionVolumes],
			{0.5 Milli Liter,0.75 Milli Liter},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageSolutionVolume,"If CleavageSolutionVolume is Automatic and CleavageMethod is specified, defaults to the CleavageSolutionVolume for the method:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageMethod->{Object[Method,Cleavage,"id:xRO9n3vk15Ew"],Object[Method,Cleavage,"id:eGakldJ4rPEe"]}],CleavageSolutionVolumes],
			{Quantity[0.6,"Milliliters"],Quantity[0.2,"Milliliters"]}
		],
		Example[{Options,CleavageSolutionVolume,"If CleavageSolutionVolume is Automatic, defaults to 800 uL if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageSolutionVolumes],
			{Quantity[0.8,"Milliliters"],Null}
		],
		Example[{Options,CleavageSolutionVolume,"CleavageSolutionVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageSolutionVolume->{Automatic,0.4Milliliter,Automatic,Automatic,Automatic,Automatic},
				CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null,Null,Null,Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.2Milliliter,Automatic,Automatic}

			],CleavageSolutionVolumes],
			{Quantity[0.2,"Milliliters"],Quantity[0.4,"Milliliters"],Null,Null,Quantity[0.2,"Milliliters"],Quantity[0.8,"Milliliters"]},
			EquivalenceFunction->Equal
		],

		(*CleavageWashVolume*)
		Example[{Options,CleavageWashVolume,"Specify the cleavage wash volume:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageWashVolume->0.7 Milli Liter],CleavageWashVolumes],
			{0.7 Milli Liter,0.7 Milli Liter},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageWashVolume,"Specify the cleavage solution volume for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageWashVolume->{0.4 Milli Liter,0.75 Milli Liter}],CleavageWashVolumes],
			{0.4 Milli Liter,0.75 Milli Liter},
			EquivalenceFunction->Equal
		],
		Example[{Options,CleavageWashVolume,"If CleavageWashVolume is Automatic and CleavageMethod is specified, defaults to the CleavageWashVolume for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageMethod->{Object[Method,Cleavage,"id:xRO9n3vk15Ew"],Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID]}],
				CleavageWashVolumes],
			{Quantity[0.5,"Milliliters"],Quantity[0.0004000000000000001`,"Milliliters"]}
		],
		Example[{Options,CleavageWashVolume,"If CleavageWashVolume is Automatic, defaults to 500 uL if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageWashVolumes],
			{Quantity[0.5,"Milliliters"],Null}
		],
		Example[{Options,CleavageWashVolume,"CleavageWashVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageWashVolume->{Automatic,0.4Milliliter,Automatic,Automatic,Automatic,Automatic},
				CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null,Null,Null,Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.2Milliliter,Automatic,Automatic}

			],CleavageWashVolumes],
			{Quantity[0.5,"Milliliters"],Quantity[0.4,"Milliliters"],Null,Null,Quantity[0.0004,"Milliliters"],Quantity[0.5,"Milliliters"]},
			EquivalenceFunction->Equal
		],

		(*CleavageSolution*)
		Example[{Options,CleavageSolution,"Specify the cleavage solution :"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageSolution->Model[Sample,"id:N80DNjlYwVnD"]],CleavageSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]}
		],
		Example[{Options,CleavageSolution,"Specify the cleavage solution for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageSolution->{Model[Sample,"id:N80DNjlYwVnD"],Model[Sample,StockSolution,"id:o1k9jAKOw6la"]}],CleavageSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]}
		],
		Example[{Options,CleavageSolution,"If CleavageSolution is Automatic and CleavageMethod is specified, defaults to the CleavageSolution for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageMethod->{Object[Method,Cleavage,"id:xRO9n3vk15Ew"],Object[Method,Cleavage,"id:dORYzZJVAWxR"]}
				],CleavageSolutions],
			{ObjectP[Model[Sample,StockSolution,"Diluted Tert-butylamine"]],ObjectP[Model[Sample,StockSolution,"0.05M Potassium Carbonate in Methanol/Water"]]}
		],
		Example[{Options,CleavageSolution,"If CleavageSolution is Automatic, defaults to RNA Cleavage solution if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageSolutions],
			{ObjectP[Model[Sample,StockSolution,"RNA Cleavage solution APA"]],Null}
		],
		Example[{Options,CleavageSolution,"CleavageSolution may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageTemperature->{Automatic,40Celsius,Automatic,Automatic,Automatic,50Celsius},
				CleavageMethod->{Object[Method,Cleavage,"id:mnk9jOR0JWRO"],Null,Null,Null,Object[Method,Cleavage,"id:xRO9n3vk15Ew"],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.5Milliliter,Automatic,Automatic}

			],CleavageSolutions],
			{
				LinkP[Model[Sample,"Ammonium hydroxide"]],
				LinkP[Model[Sample,StockSolution,"RNA Cleavage solution APA"]],
				Null,
				Null,
				LinkP[Model[Sample,StockSolution,"Diluted Tert-butylamine"]],
				LinkP[Model[Sample,StockSolution,"RNA Cleavage solution APA"]]
			}
		],

		(*CleavageWashSolution*)
		Example[{Options,CleavageWashSolution,"Specify the cleavage wash solution:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageWashSolution->Model[Sample,"id:vXl9j5qEnnRD"]],CleavageWashSolutions],
			{LinkP[Model[Sample,"id:vXl9j5qEnnRD"]],LinkP[Model[Sample,"id:vXl9j5qEnnRD"]]}
		],
		Example[{Options,CleavageWashSolution,"Specify the cleavage wash solution for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageWashSolution->{Model[Sample,"id:vXl9j5qEnnRD"],Model[Sample,StockSolution,"id:o1k9jAKOw6la"]}],CleavageWashSolutions],
			{LinkP[Model[Sample,"id:vXl9j5qEnnRD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]}
		],
		Example[{Options,CleavageWashSolution,"If CleavageWashSolution is Automatic and CleavageMethod is specified, defaults to the CleavageWashSolution for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageMethod->{Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID]}
				],CleavageWashSolutions],
			{ObjectP[Model[Sample,"Ethanol, Reagent Grade"]],ObjectP[Model[Sample,"Ethanol, Reagent Grade"]]}
		],
		Example[{Options,CleavageWashSolution,"If CleavageWashSolution is Automatic, defaults to water if Cleavage is True and Null if Cleavage is False:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],CleavageWashSolutions],
			{ObjectP[Model[Sample,"Milli-Q water"]],Null}
		],
		Example[{Options,CleavageWashSolution,"CleavageWashSolution may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,True,False,Automatic,Automatic,Automatic},
				CleavageWashSolution->{Automatic,Model[Sample,"Methanol"],Automatic,Automatic,Automatic,Automatic},
				CleavageMethod->{Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID],Null,Null,Null,Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID],Null},
				StorageSolventVolume->{Automatic,Automatic,Automatic,0.2Milliliter,Automatic,Automatic}

			],CleavageWashSolutions],
			{ObjectP[Model[Sample,"Ethanol, Reagent Grade"]],ObjectP[Model[Sample,"Methanol"]],Null,Null,ObjectP[Model[Sample,"Ethanol, Reagent Grade"]],ObjectP[Model[Sample,"Milli-Q water"]]}
		],


		(*CleavageMethod*)
		Example[{Options,CleavageMethod,"Specify a cleavage method to cleave the strands. CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageWashVolume, and CleavageSolution will be pulled from the specified cleavage method:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},CleavageMethod->Object[Method,Cleavage,"id:N80DNjlYwRnD"]],
				{CleavageMethods,CleavageTimes,CleavageTemperatures,CleavageSolutions,CleavageSolutionVolumes,CleavageWashVolumes}
			],
			{
				{LinkP[Object[Method,Cleavage,"id:N80DNjlYwRnD"]],LinkP[Object[Method,Cleavage,"id:N80DNjlYwRnD"]]},
				{Quantity[1.,"Hours"],Quantity[1.,"Hours"]},
				{Quantity[55.,"DegreesCelsius"],Quantity[55.,"DegreesCelsius"]},
				{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]},
				{Quantity[1.0,"Milliliters"],Quantity[1.0,"Milliliters"]},
				{Quantity[0.5,"Milliliters"],Quantity[0.5,"Milliliters"]}
			}
		],
		Example[{Options,CleavageMethod,"Specify a different cleavage method for each strand:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageMethod->{Object[Method,Cleavage,"id:N80DNjlYwRnD"],Object[Method,Cleavage,"id:xRO9n3vk15Ew"]}],
				{CleavageMethods,CleavageTimes,CleavageTemperatures,CleavageSolutions,CleavageSolutionVolumes,CleavageWashVolumes}
			],
			{
				{LinkP[Object[Method,Cleavage,"id:N80DNjlYwRnD"]],LinkP[Object[Method,Cleavage,"id:xRO9n3vk15Ew"]]},
				{Quantity[1.,"Hours"],Quantity[20.,"Hours"]},
				{Quantity[55.,"DegreesCelsius"],Quantity[65.,"DegreesCelsius"]},
				{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]},
				{Quantity[1.0,"Milliliters"],Quantity[0.6,"Milliliters"]},
				{Quantity[0.5,"Milliliters"],Quantity[0.5,"Milliliters"]}
			}
		],
		Example[{Options,CleavageMethod,"If both CleavageMethod and CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageWashVolume, or CleavageSolution are specified, any specified cleavage conditions will overwrite the conditions specified in the cleavage method:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					CleavageMethod->Object[Method,Cleavage,"id:N80DNjlYwRnD"],
					CleavageTime->{Automatic,20. Hour}],
				{CleavageMethods,CleavageTimes,CleavageTemperatures,CleavageSolutions,CleavageSolutionVolumes,CleavageWashVolumes}],
			{
				{LinkP[Object[Method,Cleavage,"id:N80DNjlYwRnD"]],Except[LinkP[Object[Method,Cleavage,"id:N80DNjlYwRnD"]]]},
				{Quantity[1.,"Hours"],Quantity[20.,"Hours"]},
				{Quantity[55.,"DegreesCelsius"],Quantity[55.,"DegreesCelsius"]},
				{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]},
				{Quantity[1.0,"Milliliters"],Quantity[1.0,"Milliliters"]},
				{Quantity[0.5,"Milliliters"],Quantity[0.5,"Milliliters"]}
			}
		],


		(* StorageSolventVolume *)
		Example[{Options,StorageSolventVolume,"Specify the volume of solvent that uncleaved resin is stored in:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},StorageSolventVolume->1 Milliliter],StorageSolventVolumes],
			{1 Milliliter,1 Milliliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,StorageSolventVolume,"Automatic StorageSolventVolume resolves to 200 microliter when the scale is 40 nanomole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,Scale->40 Nanomole],StorageSolventVolumes],
			{200 Microliter,200 Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,StorageSolventVolume,"Automatic StorageSolventVolume resolves to 400 microliter when the scale is 200 nanomole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,Scale->0.2 Micromole],StorageSolventVolumes],
			{400 Microliter,400 Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,StorageSolventVolume,"Automatic StorageSolventVolume resolves to 1000 microliter when the scale is 1000 nanomole:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False,Scale->1 Micromole],StorageSolventVolumes],
			{1000 Microliter,1000 Microliter},
			EquivalenceFunction->Equal
		],

		Example[{Options,StorageSolventVolume,"Specify a different volume of solvent for each uncleaved resin:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},StorageSolventVolume->{1 Milliliter,0.5 Milliliter}],StorageSolventVolumes],
			{1 Milliliter,0.5 Milliliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,StorageSolventVolume,"Automatic StorageSolventVolume resolves to Null when Cleavage is True:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,True}],StorageSolventVolumes],
			{Null,Null}
		],
		Example[{Options,StorageSolventVolume,"StorageSolventVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,Automatic,Automatic,Automatic,False},
				StorageSolventVolume->{Automatic,450Microliter,Automatic,Automatic,Automatic},
				StorageSolvent->{Automatic,Automatic,Model[Sample,"id:9RdZXvKBeelX"],Automatic,Automatic},
				CleavageTime->{Automatic,Automatic,Automatic,4Hour,Automatic}

			],StorageSolventVolumes],
			{Null,450Microliter,400Microliter,Null,400Microliter},
			EquivalenceFunction->Equal
		],

		(* StorageSolvent *)
		Example[{Options,StorageSolvent,"Specify the solvent that uncleaved resin is stored in:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},StorageSolvent->Model[Sample,"id:9RdZXvKBeelX"]],StorageSolvents],
			{LinkP[Model[Sample,"id:9RdZXvKBeelX"]],LinkP[Model[Sample,"id:9RdZXvKBeelX"]]}
		],
		Example[{Options,StorageSolvent,"Automatic resolves to Milli-Q Water when Cleavage is False and Null when Cleavage is True:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],StorageSolvents],
			{Null,LinkP[Model[Sample,"id:8qZ1VWNmdLBD"]]}
		],
		Example[{Options,StorageSolvent,"Specify a different solvent for each uncleaved resin:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},StorageSolvent->{Model[Sample,"id:8qZ1VWNmdLBD"],Model[Sample,"id:9RdZXvKBeelX"]}],StorageSolvents],
			{LinkP[Model[Sample,"id:8qZ1VWNmdLBD"]],LinkP[Model[Sample,"id:9RdZXvKBeelX"]]}
		],
		Example[{Options,StorageSolvent,"StorageSolvent may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
				Cleavage->{True,Automatic,Automatic,Automatic,False},
				StorageSolventVolume->{Automatic,450Microliter,Automatic,Automatic,Automatic},
				StorageSolvent->{Automatic,Automatic,Model[Sample,"id:9RdZXvKBeelX"],Automatic,Automatic},
				CleavageTime->{Automatic,Automatic,Automatic,4Hour,Automatic}

			],StorageSolvents],
			{Null,ObjectP[Model[Sample,"id:8qZ1VWNmdLBD"]],ObjectP[Model[Sample,"id:9RdZXvKBeelX"]],Null,ObjectP[Model[Sample,"id:8qZ1VWNmdLBD"]]}
		],

		Example[{Options,Name,"Give the protocol a name:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Name->"My RNA Synthesis"<>$SessionUUID],Name],
			"My RNA Synthesis"<>$SessionUUID
		],

		(* Resources *)
		Test["Makes the expected resources when cleaving all the strands:",
			With[{resourceFields=Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->True],RequiredResources][[All,2]]},
				ContainsAll[resourceFields,{ResinContainers,Filters}]
			],
			True
		],
		Test["Makes the expected resources when cleaving none of the strands:",
			With[{resourceFields=Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->False],RequiredResources][[All,2]]},
				MemberQ[resourceFields,ResinContainers] && !MemberQ[resourceFields,Filters]
			],
			True
		],
		Test["Makes the expected resources when cleaving some of the strands:",
			With[{resourceFields=Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],RequiredResources][[All,2]]},
				ContainsAll[resourceFields,{ResinContainers,Filters}]
			],
			True
		],
		Test["If a strand is being cleaved, the resin container resource has Rent->True, otherwise it is not rented:",
			With[{resources=Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False}],RequiredResources]},
				Cases[resources,{_,ResinContainers,___}][[All,1]][Rent]
			],
			{True,Null}
		],
		Test["There is a filter resource for every cleaved strand, and a resin container for all strands regardless of cleavage:",
			With[{resources=Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Cleavage->{True,False,True}],RequiredResources]},
				{Length[Cases[resources,{_,ResinContainers,___}]],Length[Cases[resources,{_,Filters,___}]]}
			],
			{3,2}
		],
		Test["Makes the expected resources for synthesis when using 1 bank:",
			With[{resourceFields=Tally[Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]}],RequiredResources][[All,2]]]},
				ContainsAll[resourceFields,{
					{Instrument,1},
					{Columns,2},
					{WashSolution,1},
					{WashSolutionDesiccants,1},
					{DeprotectionSolution,1},
					{ActivatorSolution,1},
					{ActivatorSolutionDesiccants,1},
					{Phosphoramidites,2},
					{CapASolution,1},
					{CapBSolution,1},
					{OxidationSolution,1}}
				]
			],
			True
		],
		Test["Makes the expected resources for synthesis when using 2 banks:",
			With[{resourceFields=Tally[Download[ExperimentRNASynthesis[ConstantArray[Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],25]],RequiredResources][[All,2]]]},
				ContainsAll[resourceFields,{
					{Instrument,1},
					{Columns,25},
					{WashSolution,2},
					{WashSolutionDesiccants,2},
					{DeprotectionSolution,1},
					{ActivatorSolution,2},
					{ActivatorSolutionDesiccants,2},
					{Phosphoramidites,4},
					{CapASolution,2},
					{CapBSolution,2},
					{OxidationSolution,1}}
				]
			],
			True
		],

		Example[{Options,InSitu,"If columns are specified as objects, uses the amount of resin present in the column object even if it differes from what we would request for the synthesis scale:"},
			Download[Cases[Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},
					Columns->{Object[Sample,"Test 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID]}],
				RequiredResources],{_,Columns,___}][[All,1]],Amount],
			{0.03 Gram,0.0012 Gram},
			Messages:>{Warning::ColumnLoadingsDiffer}
		],

		(*ImageSample*)
		Example[{Options,ImageSample,"Specify that the samples should be imaged after the protocol completes:"},
			Download[ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},ImageSample->True],ImageSample],
			True
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},MeasureVolume->False],
				MeasureVolume
			],
			False,
			TimeConstraint->300
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},MeasureWeight->False],
				MeasureWeight
			],
			False,
			TimeConstraint->300
		],
		Example[{Options,Confirm,"If Confirm -> True, skip InCart protocol status and go directly to Processing:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Confirm->True],
				Status],
			Processing | ShippingMaterials | Backlogged
		],
		Example[{Options,Confirm,"If Confirm -> False, the protocol will be placed in the cart but will not start processing:"},
			Download[
				ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Confirm->False],
				Status],
			InCart
		],
		Example[{Options,Template,"Inherit the resolved options of a previous protocol:"},
			(referenceProtocol=ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Scale->1 Micromole];
			Lookup[
				Download[
					ExperimentRNASynthesis[{Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID]},Template->referenceProtocol],
					ResolvedOptions],
				Scale]),
			Quantity[1,"Micromoles"],
			Variables:>{referenceProtocol}
		],

		(*= RNA-specific options =*)
		(* RNA Deprotection *)
		Example[{Options,RNADeprotection,"Specify that none of the strands will be deprotected:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->False],
				RNADeprotection
			],
			{False,False,False}
		],
		Example[{Options,RNADeprotection,"Specify that all of the strands will be deprotected:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->True],
				RNADeprotection
			],
			{True,True,True}
		],
		Example[{Options,RNADeprotection,"Specify that some of the strands will be deprotected:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{False,True,Automatic}],
				RNADeprotection
			],
			{False,True,True}
		],
		Example[
			{Options,RNADeprotection,"Automatic deprotection defaults to True if any deprotection-related options are specified as non-Null or if all of these options are set to Automatic; resolves to False if option is specified as Null:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionTime->{5Hour,Automatic,Null}],
				RNADeprotection
			],
			{True,True,False}
		],

		(*RNADeprotectionMethod*)
		Example[{Options,RNADeprotectionMethod,"Specify a deprotection method touse for the strands. Deprotection parameters will be pulled from the specified cleavage method:"},
			Download[
					ExperimentRNASynthesis[
						{
							Model[Molecule, Oligomer, "Test Sample 1 for ExperimentRNASynthesis tests"<>ToString[$SessionUUID]],
							Model[Molecule, Oligomer, "Test Sample 2 for ExperimentRNASynthesis tests"<>ToString[$SessionUUID]]
						},
						RNADeprotectionMethod -> Object[Method, RNADeprotection, "Test deprotection method for ExperimentRNASynthesis"<>ToString[$SessionUUID]]
					],
				{RNADeprotectionMethods,RNADeprotectionTimes,RNADeprotectionSolutions}
			],
			{
				{LinkP[Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]],LinkP[Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]]},
					{EqualP[Quantity[0.37, "Hours"]], EqualP[Quantity[0.37, "Hours"]]},
				{LinkP[Model[Sample,"Acetone-d6"]],LinkP[Model[Sample,"Acetone-d6"]]}
			}
		],
		Example[{Options,RNADeprotectionMethod,"Specify a different deprotection method for each strand:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}],
				{RNADeprotectionMethods,RNADeprotectionTimes,RNADeprotectionSolutions}
			],
			{
				{LinkP[Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]],LinkP[Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]]},
					{EqualP[Quantity[0.37, "Hours"]], EqualP[Quantity[0.42, "Hours"]]},
				{LinkP[Model[Sample,"Acetone-d6"]],LinkP[Model[Sample,"Dimethyl sulfoxide-d6"]]}
			}
		],
		Example[{Options,RNADeprotectionMethod,"If both RNADeprotectionMethod and deprotection parameters are specified, any specified conditions will overwrite the conditions specified in the deprotection method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],
					RNADeprotectionTime->{Automatic,20. Hour}],
				{RNADeprotectionMethods,RNADeprotectionTimes,RNADeprotectionSolutions}
			],
			{
				{LinkP[Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]],Except[LinkP[Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]]]},
					{EqualP[Quantity[0.37, "Hours"]], EqualP[Quantity[20., "Hours"]]},
				{LinkP[Model[Sample,"Acetone-d6"]],LinkP[Model[Sample,"Acetone-d6"]]}
			}
		],

		(*RNADeprotectionSolution*)
		Example[{Options,RNADeprotectionSolution,"Specify the deprotection solution:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionSolution->Model[Sample,"id:N80DNjlYwVnD"]],RNADeprotectionSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]}
		],
		Example[{Options,RNADeprotectionSolution,"Specify the deprotection solution for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionSolution->{Model[Sample,"id:N80DNjlYwVnD"],Model[Sample,StockSolution,"id:o1k9jAKOw6la"]}],RNADeprotectionSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]}
		],
		Example[{Options,RNADeprotectionSolution,"If RNADeprotectionSolution is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionSolution for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionSolutions],
			{ObjectP[Model[Sample,"Acetone-d6"]],ObjectP[Model[Sample,"Dimethyl sulfoxide-d6"]]}
		],
		Example[{Options,RNADeprotectionSolution,"If RNADeprotectionSolution is Automatic, defaults to TEA x3HF if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionSolutions],
			{ObjectP[Model[Sample,"Triethylamine trihydrofluoride"]],Null}
		],
		Example[{Options,RNADeprotectionSolution,"RNADeprotectionSolution may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionTemperature->{Automatic,Automatic,40Celsius},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionSolutions],
			{LinkP[Model[Sample,"Triethylamine trihydrofluoride"]],Null,LinkP[Model[Sample,"Acetone-d6"]]}
		],

		(*RNADeprotectionSolutionVolume*)
		Example[{Options,RNADeprotectionSolutionVolume,"Specify the deprotection solution :"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionSolutionVolume->126 Microliter],RNADeprotectionSolutionVolumes],
			{126.` Microliter,126.` Microliter}
		],
		Example[{Options,RNADeprotectionSolutionVolume,"Specify the deprotection solution volume for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionSolutionVolume->{126 Microliter,305 Microliter}],RNADeprotectionSolutionVolumes],
			{126.` Microliter,305.` Microliter}
		],
		Example[{Options,RNADeprotectionSolutionVolume,"If RNADeprotectionSolutionVolume is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionSolutionVolume for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionSolutionVolumes],
			{73.` Microliter,71.` Microliter}
		],
		Example[{Options,RNADeprotectionSolutionVolume,"If RNADeprotectionSolutionVolume is Automatic, defaults to 140 Microliter for 0.2 Micromole scale if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False},Scale->0.2 Micromole],RNADeprotectionSolutionVolumes],
			{125.` Microliter,Null}
		],
		Example[{Options,RNADeprotectionSolutionVolume,"RNADeprotectionSolutionVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionSolutionVolume->{Automatic,Automatic,135 Microliter},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]},
				Scale->0.2 Micromole
			],RNADeprotectionSolutionVolumes],
			{125.` Microliter,Null,135.` Microliter}
		],

		(*RNADeprotectionTime*)
		Example[{Options,RNADeprotectionTime,"Specify the deprotection time:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionTime->1 Hour],RNADeprotectionTimes],
			{1.` Hour,1.` Hour}
		],
		Example[{Options,RNADeprotectionTime,"Specify the deprotection time for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionTime->{1 Hour,2 Hour}],RNADeprotectionTimes],
			{1.` Hour,2.` Hour}
		],
		Example[{Options,RNADeprotectionTime,"If RNADeprotectionTime is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionTime for the method:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}],RNADeprotectionTimes],
			{0.37` Hour,0.42` Hour}
		],
		Example[{Options,RNADeprotectionTime,"If RNADeprotectionTime is Automatic, defaults to 2.5 hours if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionTimes],
			{2.5` Hour,Null}
		],
		Example[{Options,RNADeprotectionTime,"RNADeprotectionTime may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionTime->{Automatic,Automatic,Automatic},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionTimes],
			{2.5` Hour,Null,0.37` Hour}
		],

		(*RNADeprotectionTemperature*)
		Example[{Options,RNADeprotectionTemperature,"Specify the deprotection temperature:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionTemperature->40 Celsius],RNADeprotectionTemperatures],
			{40.` Celsius,40.` Celsius}
		],
		Example[{Options,RNADeprotectionTemperature,"Specify the cleavage temperature for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionTemperature->{40 Celsius,60 Celsius}],RNADeprotectionTemperatures],
			{40.` Celsius,60.` Celsius}
		],
		Example[{Options,RNADeprotectionTemperature,"If RNADeprotectionTemperature is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionTemperature for the method:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}],RNADeprotectionTemperatures],
			{43.` Celsius,47.` Celsius}
		],
		Example[{Options,RNADeprotectionTemperature,"If RNADeprotectionTemperature is Automatic, defaults to 65C if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionTemperatures],
			{65.` Celsius,Null}
		],
		Example[{Options,RNADeprotectionTemperature,"RNADeprotectionTemperature may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionTemperature->{Automatic,Automatic,38 Celsius},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionTemperatures],
			{65.` Celsius,Null,38.` Celsius}
		],

		(*RNADeprotectionResuspensionSolution*)
		Example[{Options,RNADeprotectionResuspensionSolution,"Specify the deprotection resuspension solution:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionSolution->Model[Sample,"id:N80DNjlYwVnD"]],RNADeprotectionResuspensionSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]}
		],
		Example[{Options,RNADeprotectionResuspensionSolution,"Specify the deprotection resuspension solution for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionSolution->{Model[Sample,"id:N80DNjlYwVnD"],Model[Sample,StockSolution,"id:o1k9jAKOw6la"]}],RNADeprotectionResuspensionSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]}
		],
		Example[{Options,RNADeprotectionResuspensionSolution,"If RNADeprotectionResuspensionSolution is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionResuspensionSolution for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionResuspensionSolutions],
			{ObjectP[Model[Sample,"Dimethyl sulfoxide-d6"]],ObjectP[Model[Sample,"Deuterium oxide"]]}
		],
		Example[{Options,RNADeprotectionResuspensionSolution,"If RNADeprotectionResuspensionSolution is Automatic, defaults to DMSO if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionResuspensionSolutions],
			{ObjectP[Model[Sample,"DMSO, anhydrous"]],Null}
		],
		Example[{Options,RNADeprotectionResuspensionSolution,"RNADeprotectionResuspensionSolution may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionResuspensionSolutions],
			{LinkP[Model[Sample,"DMSO, anhydrous"]],Null,LinkP[Model[Sample,"Dimethyl sulfoxide-d6"]]}
		],

		(*RNADeprotectionResuspensionSolutionVolume*)
		Example[{Options,RNADeprotectionResuspensionSolutionVolume,"Specify the deprotection resuspension solution volume:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionSolutionVolume->126 Microliter],RNADeprotectionResuspensionSolutionVolumes],
			{126.` Microliter,126.` Microliter}
		],
		Example[{Options,RNADeprotectionResuspensionSolutionVolume,"Specify the deprotection resuspension solution volume for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionSolutionVolume->{126 Microliter,305 Microliter}],RNADeprotectionResuspensionSolutionVolumes],
			{126.` Microliter,305.` Microliter}
		],
		Example[{Options,RNADeprotectionResuspensionSolutionVolume,"If RNADeprotectionResuspensionSolutionVolume is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionResuspensionSolutionVolume for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionResuspensionSolutionVolumes],
			{123.` Microliter,124.` Microliter}
		],
		Example[{Options,RNADeprotectionResuspensionSolutionVolume,"If RNADeprotectionResuspensionSolutionVolume is Automatic, defaults to 100 Microliter if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionResuspensionSolutionVolumes],
			{100.` Microliter,Null}
		],
		Example[{Options,RNADeprotectionResuspensionSolutionVolume,"RNADeprotectionResuspensionSolutionVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionResuspensionSolutionVolume->{Automatic,Automatic,135 Microliter},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionResuspensionSolutionVolumes],
			{100.` Microliter,Null,135.` Microliter}
		],

		(*RNADeprotectionResuspensionTime*)
		Example[{Options,RNADeprotectionResuspensionTime,"Specify the deprotection time:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionTime->13 Minute],RNADeprotectionResuspensionTimes],
			{13.` Minute,13.` Minute}
		],
		Example[{Options,RNADeprotectionResuspensionTime,"Specify the deprotection time for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionTime->{13 Minute,22 Minute}],RNADeprotectionResuspensionTimes],
			{13.` Minute,22.` Minute}
		],
		Example[{Options,RNADeprotectionResuspensionTime,"If RNADeprotectionResuspensionTime is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionResuspensionTime for the method:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}],RNADeprotectionResuspensionTimes],
			{7.` Minute,11.` Minute}
		],
		Example[{Options,RNADeprotectionResuspensionTime,"If RNADeprotectionResuspensionTime is Automatic, defaults to 2.5 hours if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionResuspensionTimes],
			{5.` Minute,Null}
		],
		Example[{Options,RNADeprotectionResuspensionTime,"RNADeprotectionResuspensionTime may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionResuspensionTime->{Automatic,Automatic,Automatic},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionResuspensionTimes],
			{5.` Minute,Null,7.` Minute}
		],

		(*RNADeprotectionResuspensionTemperature*)
		Example[{Options,RNADeprotectionResuspensionTemperature,"Specify the deprotection resuspension temperature:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionTemperature->40 Celsius],RNADeprotectionResuspensionTemperatures],
			{40.` Celsius,40.` Celsius}
		],
		Example[{Options,RNADeprotectionResuspensionTemperature,"Specify the deprotection resuspension temperature for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionResuspensionTemperature->{40 Celsius,60 Celsius}],RNADeprotectionResuspensionTemperatures],
			{40.` Celsius,60.` Celsius}
		],
		Example[{Options,RNADeprotectionResuspensionTemperature,"If RNADeprotectionResuspensionTemperature is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionResuspensionTemperature for the method:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}],RNADeprotectionResuspensionTemperatures],
			{42.` Celsius,43.` Celsius}
		],
		Example[{Options,RNADeprotectionResuspensionTemperature,"If RNADeprotectionResuspensionTemperature is Automatic, defaults to 55C if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionResuspensionTemperatures],
			{55.` Celsius,Null}
		],
		Example[{Options,RNADeprotectionResuspensionTemperature,"RNADeprotectionResuspensionTemperature may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionResuspensionTemperature->{Automatic,Automatic,38 Celsius},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionResuspensionTemperatures],
			{55.` Celsius,Null,38.` Celsius}
		],

		(*RNADeprotectionQuenchingSolution*)
		Example[{Options,RNADeprotectionQuenchingSolution,"Specify the deprotection quenching solution:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionQuenchingSolution->Model[Sample,"id:N80DNjlYwVnD"]],RNADeprotectionQuenchingSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,"id:N80DNjlYwVnD"]]}
		],
		Example[{Options,RNADeprotectionQuenchingSolution,"Specify the deprotection quenching solution for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionQuenchingSolution->{Model[Sample,"id:N80DNjlYwVnD"],Model[Sample,StockSolution,"id:o1k9jAKOw6la"]}],RNADeprotectionQuenchingSolutions],
			{LinkP[Model[Sample,"id:N80DNjlYwVnD"]],LinkP[Model[Sample,StockSolution,"id:o1k9jAKOw6la"]]}
		],
		Example[{Options,RNADeprotectionQuenchingSolution,"If RNADeprotectionQuenchingSolution is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionQuenchingSolution for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionQuenchingSolutions],
			{ObjectP[Model[Sample,"Deuterium oxide"]],ObjectP[Model[Sample,"Acetone-d6"]]}
		],
		Example[{Options,RNADeprotectionQuenchingSolution,"If RNADeprotectionQuenchingSolution is Automatic, defaults to DMSO if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionQuenchingSolutions],
			{ObjectP[Model[Sample,"RNA Deprotection Quenching buffer"]],Null}
		],
		Example[{Options,RNADeprotectionQuenchingSolution,"RNADeprotectionQuenchingSolution may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionQuenchingSolutions],
			{LinkP[Model[Sample,"RNA Deprotection Quenching buffer"]],Null,LinkP[Model[Sample,"Deuterium oxide"]]}
		],

		(*RNADeprotectionQuenchingSolutionVolume*)
		Example[{Options,RNADeprotectionQuenchingSolutionVolume,"Specify the deprotection quenching solution volume:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionQuenchingSolutionVolume->200 Microliter],RNADeprotectionQuenchingSolutionVolumes],
			{0.2` Milliliter,0.2` Milliliter}
		],
		Example[{Options,RNADeprotectionQuenchingSolutionVolume,"Specify the deprotection quenching solution volume for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotectionQuenchingSolutionVolume->{200 Microliter,300 Microliter}],RNADeprotectionQuenchingSolutionVolumes],
			{0.2` Milliliter,0.3` Milliliter}
		],
		Example[{Options,RNADeprotectionQuenchingSolutionVolume,"If RNADeprotectionQuenchingSolutionVolume is Automatic and RNADeprotectionMethod is specified, defaults to the RNADeprotectionQuenchingSolutionVolume for the method:"},
			Download[
				ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
					Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
					RNADeprotectionMethod->{Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID]}
				],RNADeprotectionQuenchingSolutionVolumes],
			{0.7` Milliliter,0.8` Milliliter}
		],
		Example[{Options,RNADeprotectionQuenchingSolutionVolume,"If RNADeprotectionQuenchingSolutionVolume is Automatic, defaults to 100 Microliter if RNADeprotection is True and Null if RNADeprotection is False:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False}],RNADeprotectionQuenchingSolutionVolumes],
			{1.75` Milliliter,Null}
		],
		Example[{Options,RNADeprotectionQuenchingSolutionVolume,"RNADeprotectionQuenchingSolutionVolume may be resolved uniquely for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				RNADeprotection->{True,False,Automatic},
				RNADeprotectionQuenchingSolutionVolume->{Automatic,Automatic,140 Microliter},
				RNADeprotectionMethod->{Null,Null,Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID]}
			],RNADeprotectionQuenchingSolutionVolumes],
			{1.75` Milliliter,Null,0.14` Milliliter}
		],

		(* PostCleavageEvaporation *)
		Example[{Options,PostCleavageEvaporation,"Specify the post cleavage evaporation:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostCleavageEvaporation->True],PostCleavageEvaporation],
			{True,True,True}
		],
		Example[{Options,PostCleavageEvaporation,"Post Cleavage evaporation be specified for strands separately:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},RNADeprotection->{True,False,Automatic},PostCleavageEvaporation->{True,False,Automatic}],PostCleavageEvaporation],
			{True,False,True}
		],

		(*== Post Cleavage Desalting Options ==*)
		(* PostCleavageDesalting *)
		Example[{Options,PostCleavageDesalting,"PostCleavageDesalting automatically resolves to False, and all PostCleavageDesalting options are set to Null or {}:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostCleavageDesalting->Automatic],
				{PostCleavageDesalting,
					PostCleavageDesaltingInstrument, PostCleavageDesaltingPreFlushBuffer,
					PostCleavageDesaltingEquilibrationBuffer,
					PostCleavageDesaltingWashBuffer, PostCleavageDesaltingElutionBuffer,
					PostCleavageDesaltingSampleLoadRates,
					PostCleavageDesaltingRinseAndReloads,
					PostCleavageDesaltingRinseVolumes, PostCleavageDesaltingType,
					PostCleavageDesaltingCartridges, PostCleavageDesaltingPreFlushVolumes,
					PostCleavageDesaltingPreFlushRates,
					PostCleavageDesaltingEquilibrationVolumes,
					PostCleavageDesaltingEquilibrationRates,
					PostCleavageDesaltingElutionVolumes, PostCleavageDesaltingElutionRates,
					PostCleavageDesaltingWashVolumes, PostCleavageDesaltingWashRates}],
			{{False,False,False},(Null|{})..}
		],
		Example[{Options,PostCleavageDesalting,"PostCleavageDesalting can be specified for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostCleavageDesalting->{Automatic,True,True}],PostCleavageDesalting],
			{False,True,True},
			TimeConstraint->300
		],
		Example[{Options,PostCleavageDesalting,"PostCleavageDesalting can be specified for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostCleavageDesalting->{Automatic,True,False}],PostCleavageDesalting],
			{False,True,False},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingCartridge *)
		Example[{Options,PostCleavageDesaltingCartridge,"PostCleavageDesaltingCartridge can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingCartridge->{Automatic,Model[Container,ExtractionCartridge,"id:O81aEBZvdGMD"]}
			],PostCleavageDesaltingCartridges],
			{Null,LinkP[Model[Container,ExtractionCartridge,"id:O81aEBZvdGMD"]]},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingElutionBuffer *)
		Example[{Options,PostCleavageDesaltingElutionBuffer,"PostCleavageDesaltingElutionBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingElutionBuffer->Model[Sample,"Milli-Q water"]],PostCleavageDesaltingElutionBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostCleavageDesaltingWashBuffer *)
		Example[{Options,PostCleavageDesaltingWashBuffer,"PostCleavageDesaltingWashBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingWashBuffer->Model[Sample,"Milli-Q water"]],PostCleavageDesaltingWashBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostCleavageDesaltingElutionRate *)
		Example[{Options,PostCleavageDesaltingElutionRate,"PostCleavageDesaltingElutionRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingElutionRate->{Automatic,4 Milliliter / Minute}],PostCleavageDesaltingElutionRates],
			{Null,4. Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingElutionVolume *)
		Example[{Options,PostCleavageDesaltingElutionVolume,"PostCleavageDesaltingElutionVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingElutionVolume->{Automatic,2.5 Milliliter}],PostCleavageDesaltingElutionVolumes],
			{Null,2.5 Milliliter},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingEquilibrationBuffer *)
		Example[{Options,PostCleavageDesaltingEquilibrationBuffer,"PostCleavageDesaltingEquilibrationBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingEquilibrationBuffer->Model[Sample,"Milli-Q water"]],PostCleavageDesaltingEquilibrationBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostCleavageDesaltingEquilibrationRate *)
		Example[{Options,PostCleavageDesaltingEquilibrationRate,"PostCleavageDesaltingEquilibrationRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingEquilibrationRate->{Automatic,4 Milliliter / Minute}],PostCleavageDesaltingEquilibrationRates],
			{Null,4.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingEquilibrationVolume *)
		Example[{Options,PostCleavageDesaltingEquilibrationVolume,"PostCleavageDesaltingEquilibrationVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingEquilibrationVolume->{Automatic,2 Milliliter}],PostCleavageDesaltingEquilibrationVolumes],
			{Null,2.` Milliliter},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingInstrument *)
		Example[{Options,PostCleavageDesaltingInstrument,"PostCleavageDesaltingInstrument can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingInstrument->Model[Instrument,LiquidHandler,"id:o1k9jAKOwLl8"]],PostCleavageDesaltingInstrument],
			LinkP[Model[Instrument,LiquidHandler,"id:o1k9jAKOwLl8"]],
			TimeConstraint->300
		],

		(* PostCleavageDesaltingPreFlushBuffer *)
		Example[{Options,PostCleavageDesaltingPreFlushBuffer,"PostCleavageDesaltingPreFlushBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingPreFlushBuffer->Model[Sample,"Milli-Q water"]],PostCleavageDesaltingPreFlushBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostCleavageDesaltingPreFlushRate *)
		Example[{Options,PostCleavageDesaltingPreFlushRate,"PostCleavageDesaltingPreFlushRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingPreFlushRate->{Automatic,2 Milliliter / Minute}],PostCleavageDesaltingPreFlushRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingPreFlushVolume *)
		Example[{Options,PostCleavageDesaltingPreFlushVolume,"PostCleavageDesaltingPreFlushVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingPreFlushVolume->{Automatic,2 Milliliter}],PostCleavageDesaltingPreFlushVolumes],
			{Null,2.` Milliliter},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingRinseAndReload *)
		Example[{Options,PostCleavageDesaltingRinseAndReload,"PostCleavageDesaltingRinseAndReload can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True,True},
				PostCleavageDesaltingRinseAndReload->{Automatic,False,True}],PostCleavageDesaltingRinseAndReloads],
			{Null,False,True},
			TimeConstraint->400
		],

		(* PostCleavageDesaltingRinseAndReloadVolume *)
		Example[{Options,PostCleavageDesaltingRinseAndReloadVolume,"PostCleavageDesaltingRinseAndReloadVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingRinseAndReloadVolume->{Automatic,1 Milliliter}],PostCleavageDesaltingRinseVolumes],
			{Null,1.` Milliliter},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingSampleLoadRate *)
		Example[{Options,PostCleavageDesaltingSampleLoadRate,"PostCleavageDesaltingSampleLoadRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingSampleLoadRate->{Automatic,2 Milliliter / Minute}],PostCleavageDesaltingSampleLoadRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingType *)
		Example[{Options,PostCleavageDesaltingType,"PostCleavageDesaltingType can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingType->{Automatic,ReversePhase}],PostCleavageDesaltingType],
			{Null,ReversePhase},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingWashRate *)
		Example[{Options,PostCleavageDesaltingWashRate,"PostCleavageDesaltingWashRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingWashRate->{Automatic,2 Milliliter / Minute}],PostCleavageDesaltingWashRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostCleavageDesaltingWashVolume *)
		Example[{Options,PostCleavageDesaltingWashVolume,"PostCleavageDesaltingWashVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostCleavageDesalting->{Automatic,True},
				PostCleavageDesaltingWashVolume->{Automatic,3 Milliliter}],PostCleavageDesaltingWashVolumes],
			{Null,3.` Milliliter},
			TimeConstraint->300
		],


		(* PostRNADeprotectionEvaporation *)
		Example[{Options,PostRNADeprotectionEvaporation,"Specify the post deprotection evaporation:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionEvaporation->True],PostRNADeprotectionEvaporation],
			{True,True,True}
		],
		Example[{Options,PostRNADeprotectionEvaporation,"Post deprotection evaporation be specified for strands separately:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionEvaporation->{True,False,Automatic}],PostRNADeprotectionEvaporation],
			{True,False,True}
		],

		(*== Post RNA Deprotection Desalting Options ==*)
		(* PostRNADeprotectionDesalting *)
		Example[{Options,PostRNADeprotectionDesalting,"PostRNADeprotectionDesalting automatically resolves to False, all PostRNADeprotectionDesalting are set to Null or {}:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionDesalting->Automatic],
				{PostRNADeprotectionDesalting, PostRNADeprotectionDesaltingInstrument, PostRNADeprotectionDesaltingPreFlushBuffer, PostRNADeprotectionDesaltingEquilibrationBuffer, PostRNADeprotectionDesaltingWashBuffer, PostRNADeprotectionDesaltingElutionBuffer, PostRNADeprotectionDesaltingSampleLoadRates, PostRNADeprotectionDesaltingRinseAndReloads, PostRNADeprotectionDesaltingRinseVolumes, PostRNADeprotectionDesaltingType, PostRNADeprotectionDesaltingCartridges, PostRNADeprotectionDesaltingPreFlushVolumes, PostRNADeprotectionDesaltingPreFlushRates, PostRNADeprotectionDesaltingEquilibrationVolumes, PostRNADeprotectionDesaltingEquilibrationRates, PostRNADeprotectionDesaltingElutionVolumes, PostRNADeprotectionDesaltingElutionRates, PostRNADeprotectionDesaltingWashVolumes, PostRNADeprotectionDesaltingWashRates
				}],
			{{False,False,False},(Null|{}) ..}
		],

		Example[{Options,PostRNADeprotectionDesalting,"PostRNADeprotectionDesalting can be specified for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionDesalting->{Automatic,True,True}],PostRNADeprotectionDesalting],
			{False,True,True},
			TimeConstraint->300
		],
		Example[{Options,PostRNADeprotectionDesalting,"PostRNADeprotectionDesalting can be specified for each strand:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionDesalting->{Automatic,True,False}],PostRNADeprotectionDesalting],
			{False,True,False},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingCartridge *)
		Example[{Options,PostRNADeprotectionDesaltingCartridge,"PostRNADeprotectionDesaltingCartridge can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingCartridge->{Automatic,Model[Container,ExtractionCartridge,"id:O81aEBZvdGMD"]}
			],PostRNADeprotectionDesaltingCartridges],
			{Null,LinkP[Model[Container,ExtractionCartridge,"id:O81aEBZvdGMD"]]},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingElutionBuffer *)
		Example[{Options,PostRNADeprotectionDesaltingElutionBuffer,"PostRNADeprotectionDesaltingElutionBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingElutionBuffer->Model[Sample,"Milli-Q water"]],PostRNADeprotectionDesaltingElutionBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingWashBuffer *)
		Example[{Options,PostRNADeprotectionDesaltingWashBuffer,"PostRNADeprotectionDesaltingWashBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingWashBuffer->Model[Sample,"Milli-Q water"]],PostRNADeprotectionDesaltingWashBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingElutionRate *)
		Example[{Options,PostRNADeprotectionDesaltingElutionRate,"PostRNADeprotectionDesaltingElutionRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingElutionRate->{Automatic,4 Milliliter / Minute}],PostRNADeprotectionDesaltingElutionRates],
			{Null,4. Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingElutionVolume *)
		Example[{Options,PostRNADeprotectionDesaltingElutionVolume,"PostRNADeprotectionDesaltingElutionVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingElutionVolume->{Automatic,2.5 Milliliter}],PostRNADeprotectionDesaltingElutionVolumes],
			{Null,2.5 Milliliter},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingEquilibrationBuffer *)
		Example[{Options,PostRNADeprotectionDesaltingEquilibrationBuffer,"PostRNADeprotectionDesaltingEquilibrationBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingEquilibrationBuffer->Model[Sample,"Milli-Q water"]],PostRNADeprotectionDesaltingEquilibrationBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingEquilibrationRate *)
		Example[{Options,PostRNADeprotectionDesaltingEquilibrationRate,"PostRNADeprotectionDesaltingEquilibrationRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingEquilibrationRate->{Automatic,4 Milliliter / Minute}],PostRNADeprotectionDesaltingEquilibrationRates],
			{Null,4.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingEquilibrationVolume *)
		Example[{Options,PostRNADeprotectionDesaltingEquilibrationVolume,"PostRNADeprotectionDesaltingEquilibrationVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingEquilibrationVolume->{Automatic,2 Milliliter}],PostRNADeprotectionDesaltingEquilibrationVolumes],
			{Null,2.` Milliliter},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingInstrument *)
		Example[{Options,PostRNADeprotectionDesaltingInstrument,"PostRNADeprotectionDesaltingInstrument can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingInstrument->Model[Instrument,LiquidHandler,"id:o1k9jAKOwLl8"]],PostRNADeprotectionDesaltingInstrument],
			LinkP[Model[Instrument,LiquidHandler,"id:o1k9jAKOwLl8"]],
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingPreFlushBuffer *)
		Example[{Options,PostRNADeprotectionDesaltingPreFlushBuffer,"PostRNADeprotectionDesaltingPreFlushBuffer can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingPreFlushBuffer->Model[Sample,"Milli-Q water"]],PostRNADeprotectionDesaltingPreFlushBuffer],
			LinkP[Model[Sample,"Milli-Q water"]],
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingPreFlushRate *)
		Example[{Options,PostRNADeprotectionDesaltingPreFlushRate,"PostRNADeprotectionDesaltingPreFlushRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingPreFlushRate->{Automatic,2 Milliliter / Minute}],PostRNADeprotectionDesaltingPreFlushRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingPreFlushVolume *)
		Example[{Options,PostRNADeprotectionDesaltingPreFlushVolume,"PostRNADeprotectionDesaltingPreFlushVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingPreFlushVolume->{Automatic,2 Milliliter}],PostRNADeprotectionDesaltingPreFlushVolumes],
			{Null,2.` Milliliter},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingRinseAndReload *)
		Example[{Options,PostRNADeprotectionDesaltingRinseAndReload,"PostRNADeprotectionDesaltingRinseAndReload can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True,True},
				PostRNADeprotectionDesaltingRinseAndReload->{Automatic,False,True}],PostRNADeprotectionDesaltingRinseAndReloads],
			{Null,False,True},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingRinseAndReloadVolume *)
		Example[{Options,PostRNADeprotectionDesaltingRinseAndReloadVolume,"PostRNADeprotectionDesaltingRinseAndReloadVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingRinseAndReloadVolume->{Automatic,1 Milliliter}],PostRNADeprotectionDesaltingRinseVolumes],
			{Null,1.` Milliliter},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingSampleLoadRate *)
		Example[{Options,PostRNADeprotectionDesaltingSampleLoadRate,"PostRNADeprotectionDesaltingSampleLoadRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingSampleLoadRate->{Automatic,2 Milliliter / Minute}],PostRNADeprotectionDesaltingSampleLoadRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingType *)
		Example[{Options,PostRNADeprotectionDesaltingType,"PostRNADeprotectionDesaltingType can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingType->{Automatic,ReversePhase}],PostRNADeprotectionDesaltingType],
			{Null,ReversePhase},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingWashRate *)
		Example[{Options,PostRNADeprotectionDesaltingWashRate,"PostRNADeprotectionDesaltingWashRate can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingWashRate->{Automatic,2 Milliliter / Minute}],PostRNADeprotectionDesaltingWashRates],
			{Null,2.` Milliliter / Minute},
			TimeConstraint->300
		],

		(* PostRNADeprotectionDesaltingWashVolume *)
		Example[{Options,PostRNADeprotectionDesaltingWashVolume,"PostRNADeprotectionDesaltingWashVolume can be specified:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID]},
				PostRNADeprotectionDesalting->{Automatic,True},
				PostRNADeprotectionDesaltingWashVolume->{Automatic,3 Milliliter}],PostRNADeprotectionDesaltingWashVolumes],
			{Null,3.` Milliliter},
			TimeConstraint->300
		],


		(* PostRNADeprotectionEvaporation *)
		Example[{Options,PostRNADeprotectionEvaporation,"Specify the post deprotection evaporation:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionEvaporation->True],PostRNADeprotectionEvaporation],
			{True,True,True}
		],
		Example[{Options,PostRNADeprotectionEvaporation,"Post deprotection evaporation be specified for strands separately:"},
			Download[ExperimentRNASynthesis[{Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]},PostRNADeprotectionEvaporation->{True,False,Automatic}],PostRNADeprotectionEvaporation],
			{True,False,True}
		]
	},
	Stubs:>{
		$SPERoboticOnly=False,
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},
	Parallel->True,
	SetUp:>(With[{samples={Model[Sample,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Sample,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],Model[Sample,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID]}},EraseObject[PickList[samples,DatabaseMemberQ[samples]],Force->True,Verbose->False]]),
	TurnOffMessages:>{Warning::SamplesOutOfStock,Warning::InstrumentUndergoingMaintenance},
	SymbolSetUp:>{
		Module[{preExisting},
			preExisting={
				Model[Sample,"No MW chemical for ExperimentRNASynthesis test"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Method,Cleavage,"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID],
				Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID],
				Object[Sample,"Test 40 nmol column for ExperimentRNASynthesis No Loading"<>$SessionUUID],
				Model[Resin,"Test resin for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test resin for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for alternative resin for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for GC resin for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for alternative resin for ExperimentRNASynthesis (2)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for amidite for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test alternative resin for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test alternative resin for ExperimentRNASynthesis (2)"<>$SessionUUID],
				Object[Sample,"Test GC resin for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Sample,"Test amidite object for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Product,"Test product for ExperimentRNASynthesis GC resin"<>$SessionUUID],
				Object[Product,"Test product for ExperimentRNASynthesis resin"<>$SessionUUID],
				Model[Sample,"Test model sample resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Resin,SolidPhaseSupport,"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Protocol,RNASynthesis,"Test template protocol for ExperimentRNASynthesis testing"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test oligo AUGC"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test oligo GC"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test oligo Cy3-2AP-GUCAAUGCC-Cy5-Cy3"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test multi-strand oligo"<>$SessionUUID],
				Model[Molecule,Oligomer,"RNASynth Test oligo Cy3-GUCAAUGCC-Tamra"<>$SessionUUID],
				Model[Molecule,Oligomer,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Molecule,Oligomer,"polyAUCy3 Test"<>$SessionUUID],
				Model[Sample,"Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID],
				Model[Sample,"Test oligo GC"<>$SessionUUID],
				Model[Sample,"Test oligo AUGC"<>$SessionUUID],
				Model[Sample,"Test oligo Cy3-2AP-GUCAAUGCC-Cy5-Cy3"<>$SessionUUID],
				Model[Sample,"Test multi-strand oligo"<>$SessionUUID],
				Model[Sample,"Test oligo Cy3-GUCAAUGCC-Tamra"<>$SessionUUID],
				Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Sample,"polyAUTest ExpRNASynthesis Test"<>$SessionUUID],
				Model[Sample,"polyAUCy3Test"<>$SessionUUID],
				Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Sample,"Test GC resin model for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Sample,"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Sample,"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Model[Sample,"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID],
				Object[Protocol,RNASynthesis,"Existing RNA synthesis"<>$SessionUUID],
				Object[Protocol,RNASynthesis,"My RNA Synthesis"<>$SessionUUID],
				Object[Method,RNADeprotection,"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Method,RNADeprotection,"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID],
				Model[Sample,StockSolution,"Test cocktail for ExperimentRNASynthesis"<>$SessionUUID],
				Object[Instrument,DNASynthesizer,"Test DNA Synthesizer for ExperimentRNASynthesis"<>$SessionUUID]
			};
			EraseObject[PickList[preExisting,DatabaseMemberQ[preExisting]],Force->True,Verbose->False];
			EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
		];

		(* Test Objects set up *)

		Module[{oligomerNames,oligomers,oligomerStructures,oligomerPacket,gcModel,
			rnaSynthIdModel1,rnaSynthIdModel2,rnaSynthIdModel3,rnaSynthIdModel4,rnaSynthIdModel5,rnaSynthIdModel6,
			rnaSynthIdModel7,rnaSynthIdModel8,rnaSynthIdModel9,rnaSynthIdModel10,rnaSynthIdModel11,rnaSynthIdModel12,
			sampleModelNames,sampleModelIDs,sampleModelsPacket
		},

			$CreatedObjects={};

			(*Upload deprotection methods*)
			Upload[{
				<|
					Software->"3900",
					Status->Available,
					Replace[StatusLog]->{
						{
							DateObject[{2021,6,13,3,25,50.98828840255737},"Instant","Gregorian",-7.],
							Available,
							Link[Object[User,Emerald,Developer,"id:J8AY5jDGol1Z"]]
						}
					},
					Model->Link[Model[Instrument,DNASynthesizer,"id:aXRlGnZmOOPB"],Objects],
					Type->Object[Instrument,DNASynthesizer],
					WasteScale->Link[Object[Sensor,Weight,"id:AEqRl951OLvl"],DevicesMonitored],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"Test DNA Synthesizer for ExperimentRNASynthesis"<>$SessionUUID
				|>,
				<|
					Type->Object[Method,RNADeprotection],
					Name->"Test deprotection method for ExperimentRNASynthesis"<>$SessionUUID,
					RNADeprotectionResuspensionSolution->Link[Model[Sample,"Dimethyl sulfoxide-d6"]],
					RNADeprotectionResuspensionSolutionVolume->123 Microliter,
					RNADeprotectionResuspensionTime->7 Minute,
					RNADeprotectionResuspensionTemperature->42 Celsius,
					RNADeprotectionSolution->Link[Model[Sample,"Acetone-d6"]],
					RNADeprotectionSolutionVolume->73 Microliter,
					RNADeprotectionTemperature->43 Celsius,
					RNADeprotectionTime->0.37 Hour,
					RNADeprotectionQuenchingSolution->Link[Model[Sample,"Deuterium oxide"]],
					RNADeprotectionQuenchingSolutionVolume->700 Microliter
				|>,
				<|
					Type->Object[Method,RNADeprotection],
					Name->"Test deprotection method 2 for ExperimentRNASynthesis"<>$SessionUUID,
					RNADeprotectionResuspensionSolution->Link[Model[Sample,"Deuterium oxide"]],
					RNADeprotectionResuspensionSolutionVolume->124 Microliter,
					RNADeprotectionResuspensionTime->11 Minute,
					RNADeprotectionResuspensionTemperature->43 Celsius,
					RNADeprotectionSolution->Link[Model[Sample,"Dimethyl sulfoxide-d6"]],
					RNADeprotectionSolutionVolume->71 Microliter,
					RNADeprotectionTemperature->47 Celsius,
					RNADeprotectionTime->0.42 Hour,
					RNADeprotectionQuenchingSolution->Link[Model[Sample,"Acetone-d6"]],
					RNADeprotectionQuenchingSolutionVolume->800 Microliter
				|>,

				<|
					Name->"No MW chemical for ExperimentRNASynthesis test"<>$SessionUUID,
					Type->Model[Sample],
					DeveloperObject->True
				|>,

				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Name->"Test container for 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID,
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Status->Available,
					Site->Link[$Site],
					DeveloperObject->True
				|>,

				<|
					Name->"Test container for 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID,
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Status->Available,
					Site->Link[$Site],
					DeveloperObject->True
				|>,

				<|
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Status->Available,
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"Test container for 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID
				|>,

				<|
					CleavageSolution->Link[Model[Sample,"Ammonium hydroxide"]],
					CleavageSolutionVolume->Quantity[1.`,"Milliliters"],
					CleavageTemperature->Quantity[55.`,"DegreesCelsius"],
					CleavageTime->Quantity[1.`,"Hours"],
					CleavageWashSolution->Link[Model[Sample,"Ethanol, Reagent Grade"]],
					Name->"Test cleavage method that washes with ethanol for ExperimentRNASynthesis"<>$SessionUUID,
					NumberOfCleavageCycles->1,
					Type->Object[Method,Cleavage],
					CleavageWashVolume->0.4Microliter
				|>,

				<|
					Type->Model[Resin],
					Linker->UnySupport,
					Replace[Loading]->Quantity[0.00003333333333333`,("Moles") / ("Grams")],
					Name->"Test resin for ExperimentRNASynthesis"<>$SessionUUID,
					ProtectingGroup->DMT,
					ResinMaterial->ControlledPoreGlass,
					State->Solid
				|>,

				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Name->"Test container for alternative resin for ExperimentRNASynthesis"<>$SessionUUID,
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Site->Link[$Site],
					Status->Available
				|>
			}];

			(* Upload identity models *)
			oligomerNames={
				"RNASynth Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID,
				"RNASynth Test oligo AUGC"<>$SessionUUID,
				"RNASynth Test oligo GC"<>$SessionUUID,
				"RNASynth Test multi-strand oligo"<>$SessionUUID,
				"RNASynth Test oligo Cy3-GUCAAUGCC-Tamra"<>$SessionUUID,
				"polyAUTest ExpRNASynthesis Test"<>$SessionUUID,
				"Test Sample 1 for ExperimentRNASynthesis tests"<>$SessionUUID,
				"Test Sample 2 for ExperimentRNASynthesis tests"<>$SessionUUID,
				"Test Sample 3 for ExperimentRNASynthesis tests"<>$SessionUUID,
				"polyAUCy3 Test"<>$SessionUUID
			};
			oligomerStructures={
				Structure[{Strand[Modification["Cy3"],RNA["GUCAAUGCC"],Modification["Cy3"]]},{}],
				Structure[{Strand[RNA["AUGC"]]},{}],
				Structure[{Strand[RNA["GC"]]},{}],
				Structure[{Strand[RNA["AUGC"]],Strand[RNA["AUGC"]]},{}],
				Structure[{Strand[Modification["Cy3"],RNA["GUCAAUGCC"],Modification["Tamra"]]},{}],
				Structure[{Strand[RNA["AUUAA"]]},{}],
				Structure[{Strand[RNA["AGCAU"]]},{}],
				Structure[{Strand[RNA["GCAA"]]},{}],
				Structure[{Strand[RNA["CAAG"]]},{}],
				Structure[{Strand[RNA["AUUAAAUUAA"],Modification["Cy3"]]},{}]
			};
			oligomerPacket=Flatten[MapThread[Function[{name,molecule},UploadOligomer[molecule,RNA,name,Upload->False]],{oligomerNames,oligomerStructures}]];

			{
				rnaSynthIdModel1,
				rnaSynthIdModel2,
				rnaSynthIdModel3,
				rnaSynthIdModel5,
				rnaSynthIdModel6,
				rnaSynthIdModel7,
				rnaSynthIdModel8,
				rnaSynthIdModel9,
				rnaSynthIdModel10,
				rnaSynthIdModel11
			}=oligomers=Upload[oligomerPacket];

			sampleModelNames={
				"Test oligo Cy3-GUCAAUGCC-Cy3"<>$SessionUUID,
				"Test oligo AUGC"<>$SessionUUID,
				"Test oligo GC"<>$SessionUUID,
				"Test multi-strand oligo"<>$SessionUUID,
				"Test oligo Cy3-GUCAAUGCC-Tamra"<>$SessionUUID,
				"polyAUTest ExpRNASynthesis Test"<>$SessionUUID,
				"polyAUCy3Test"<>$SessionUUID
			};
			sampleModelsPacket=Flatten[MapThread[Function[{name,oligomer},
				UploadSampleModel[name,
					Composition->{{100 MassPercent,Link[oligomer]}},
					Expires->False,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					State->Solid,
					Upload->False]
			],
				{sampleModelNames,
					{
						rnaSynthIdModel1,
						rnaSynthIdModel2,
						rnaSynthIdModel3,
						rnaSynthIdModel5,
						rnaSynthIdModel6,
						rnaSynthIdModel7,
						rnaSynthIdModel11
					}
				}]];
			sampleModelIDs=Upload[sampleModelsPacket];

			Upload[Map[<|Object->#,DeveloperObject->True|>]&,Flatten[{oligomers,sampleModelIDs}]];

			Upload[<|
				Type->Model[Sample],
				Name->"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID,
				Replace[Composition]->{{100MassPercent,Link[Model[Resin,"Test resin for ExperimentRNASynthesis"<>$SessionUUID]]}}
			|>];

			Upload[{
				<|
					Type->Object[Sample],
					Name->"Test 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID,
					Mass->Quantity[0.0012`,"Grams"],
					Model->Link[Model[Sample,"id:WNa4ZjRD0z3z"],Objects],
					Status->Available,
					Replace[Composition]->{{100 MassPercent,Link[Model[Resin,"id:9RdZXv1l7pX9"]]}},
					DeveloperObject->True,
					Site->Link[$Site],
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>,

				<|
					Type->Object[Sample],
					Name->"Test 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID,
					Model->Link[Model[Sample,"id:WNa4ZjRD0z3z"],Objects],
					Replace[Composition]->{{100 MassPercent,Link[Model[Resin,"id:9RdZXv1l7pX9"]]}},
					Mass->Quantity[0.0012`,"Grams"],
					Status->Available,
					Site->Link[$Site],
					DeveloperObject->True,
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>,

				<|
					Type->Object[Sample],
					Name->"Test 40 nmol column for ExperimentRNASynthesis No Loading"<>$SessionUUID,
					Model->Link[Model[Sample,"id:WNa4ZjRD0z3z"],Objects],
					Replace[Composition]->{{Null,Null}},
					Mass->Quantity[0.0012`,"Grams"],
					Status->Available,
					Site->Link[$Site],
					DeveloperObject->True,
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis (2)"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>,

				<|
					Mass->Quantity[0.03`,"Grams"],
					Model->Link[Model[Sample,"id:WNa4ZjRD0z3z"],Objects],
					Status->Available,
					Type->Object[Sample],
					Name->"Test 1000 nmol column for ExperimentRNASynthesis"<>$SessionUUID,
					Replace[Composition]->{{100MassPercent,Link[Model[Resin,"id:9RdZXv1l7pX9"]]}},
					DeveloperObject->True,
					Site->Link[$Site],
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for 40 nmol column for ExperimentRNASynthesis"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>,

				<|
					Object->Model[Resin,"Test resin for ExperimentRNASynthesis"<>$SessionUUID],
					DefaultSampleModel->Link[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID]]
				|>,

				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Name->"Test container for alternative resin for ExperimentRNASynthesis (2)"<>$SessionUUID,
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Site->Link[$Site],
					Status->Available
				|>
			}];


			Upload[{
				<|
					Type->Object[Sample],
					Name->"Test alternative resin for ExperimentRNASynthesis"<>$SessionUUID,
					Mass->Quantity[0.006`,"Grams"],
					Model->Link[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID],Objects],
					Status->Available,
					Site->Link[$Site],
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for alternative resin for ExperimentRNASynthesis"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>,

				<|
					Type->Object[Sample],
					Name->"Test alternative resin for ExperimentRNASynthesis (2)"<>$SessionUUID,
					Mass->Quantity[0.006`,"Grams"],
					Model->Link[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID],Objects],
					Status->Available,
					Site->Link[$Site],
					Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for alternative resin for ExperimentRNASynthesis (2)"<>$SessionUUID],Contents,2],
					Position->"A1"
				|>
			}];


			Upload[{
				<|
					Type->Object[Product],
					Name->"Test product for ExperimentRNASynthesis resin"<>$SessionUUID,
					CatalogNumber->"NAN",
					EstimatedLeadTime->Quantity[1.`,"Days"],
					Packaging->Case,
					ProductModel->Link[Model[Sample,"Test resin sample for ExperimentRNASynthesis"<>$SessionUUID],Products],
					Amount->6 * Milligram,
					Stocked->True,
					NumberOfItems->96,
					SampleType->Cartridge,
					UsageFrequency->Low
				|>,

				<|
					Linker->Succinyl,
					Type->Model[Resin,SolidPhaseSupport],
					Name->"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID,
					Replace[Loading]->Quantity[0.00003333333333333`,("Moles") / ("Grams")],
					PreDownloaded->True,
					ProtectingGroup->DMT,
					ResinMaterial->ControlledPoreGlass,
					State->Solid,
					Strand->Link[rnaSynthIdModel3]
				|>,

				<|
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:zGj91aRlRYXb"],Objects],
					Status->Available,
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Site->Link[$Site],
					Name->"Test container for GC resin for ExperimentRNASynthesis"<>$SessionUUID
				|>,

				<|
					Type->Object[Protocol,RNASynthesis],
					Site->Link[$Site],
					Name->"Existing RNA synthesis"<>$SessionUUID
				|>,

				<|
					Model->Link[Model[Container,Vessel,"id:Vrbp1jG800EE"],Objects],
					Status->Available,
					Type->Object[Container,Vessel],
					Site->Link[$Site],
					Name->"Test container for amidite for ExperimentRNASynthesis"<>$SessionUUID
				|>
			}];

			gcModel=Upload[<|
				DeveloperObject->True,
				Type->Model[Sample],
				Name->"Test GC resin model for ExperimentRNASynthesis"<>$SessionUUID,
				Replace[Synonyms]->{"Test GC resin model for ExperimentRNASynthesis"<>$SessionUUID},
				Replace[Composition]->{{100MassPercent,Link[Model[Resin,SolidPhaseSupport,"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID]]}}
			|>];

			Upload[<|
				Type->Object[Sample],
				Mass->Quantity[0.006`,"Grams"],
				Replace[Composition]->{{100MassPercent,Link[Model[Resin,SolidPhaseSupport,"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID]]}},
				Status->Available,
				Site->Link[$Site],
				Name->"Test GC resin for ExperimentRNASynthesis"<>$SessionUUID,
				Model->Link[gcModel,Objects],
				Container->Link[Object[Container,ReactionVessel,SolidPhaseSynthesis,"Test container for GC resin for ExperimentRNASynthesis"<>$SessionUUID],Contents,2],
				Position->"A1"
			|>];

			Upload[<|
				Type->Model[Sample],
				Replace[Composition]->{{100MassPercent,Link[Model[Resin,SolidPhaseSupport,"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID]]}},
				Name->"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID
			|>];

			Upload[<|
				Object->Model[Resin,SolidPhaseSupport,"Test model resin oligomer GC for ExperimentRNASynthesis"<>$SessionUUID],
				DefaultSampleModel->Link[Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID]]
			|>];

			Upload[<|
				CatalogNumber->"NAN",
				EstimatedLeadTime->Quantity[1.`,"Days"],
				Packaging->Case,
				Name->"Test product for ExperimentRNASynthesis GC resin"<>$SessionUUID,
				ProductModel->Link[Model[Sample,"Test GC resin model sample for ExperimentRNASynthesis"<>$SessionUUID],Products],
				Amount->6 * Milligram,
				Stocked->True,
				NumberOfItems->96,
				SampleType->Cartridge,
				Type->Object[Product],
				UsageFrequency->Low
			|>];

			Upload[<|
				Container->Link[Object[Container,Vessel,"Test container for amidite for ExperimentRNASynthesis"<>$SessionUUID],Contents,2],
				Mass->Quantity[4.`,"Grams"],
				Model->Link[Model[Sample,"dT-CE Phosphoramidite"],Objects],
				Replace[Composition]->{{100 MassPercent,Link[Model[Molecule,"id:01G6nvwRWRLd"]]}},
				Position->"A1",
				Status->Stocked,
				Site->Link[$Site],
				Type->Object[Sample],
				Name->"Test amidite object for ExperimentRNASynthesis"<>$SessionUUID,
				DeveloperObject->True
			|>];
		];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
		Unset[$CreatedObjects];
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisOptions*)

DefineTests[ExperimentRNASynthesisOptions,
	{
		Example[
			{Basic, "Return the resolved options:"},
			ExperimentRNASynthesisOptions[{
				Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
				Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
				Model[Sample, "Test oligo GC for ExperimentRNASynthesisOptions" <> $SessionUUID]}],
			Graphics_
		],
		Example[
			{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentRNASynthesisOptions[Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisOptions" <> $SessionUUID]],
			Graphics_,
			Messages :> {Error::InvalidStrands, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns as many of the options as could be resolved:"},
			ExperimentRNASynthesisOptions[{Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "Test samples for ExperimentRNASynthesisOptions" <> $SessionUUID]}, {DNA["A"], Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisOptions" <> $SessionUUID]}}
			],
			Graphics_,
			Messages :> {Error::MonomerPhosphoramiditeConflict, Error::InvalidOption}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentRNASynthesisOptions[{
				Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
				Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
				Model[Sample, "Test oligo GC for ExperimentRNASynthesisOptions" <> $SessionUUID]}, OutputFormat -> List],
			{_Rule ..}
		]
	},


	(*  build test objects *)
	Stubs :> {
		$SPERoboticOnly = False,
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, "Test oligo GC for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, StockSolution, "Test samples for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthOptions Test oligo AUGC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthOptions Test oligo GC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthOptions Test multi-strand oligo" <> $SessionUUID],
					Model[Molecule, Oligomer, "polyAUUest RNASynthOptions Test" <> $SessionUUID]
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
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "RNASynthOptions Test oligo AUGC" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["GC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "RNASynthOptions Test oligo GC" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]], Strand[RNA["AUGC"]]}, {}], PolymerType -> DNA, State -> Solid, Name -> "RNASynthOptions Test multi-strand oligo" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUUAA"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "polyAUUest RNASynthOptions Test" <> $SessionUUID, DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[{
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test oligo AUGC for ExperimentRNASynthesisOptions" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ExperimentRNASynthesisOptions" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ExperimentRNASynthesisOptions" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel5]}}
				|>,
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test samples for ExperimentRNASynthesisOptions" <> $SessionUUID
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
					Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, "polyAUUest for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, "Test oligo GC for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisOptions" <> $SessionUUID],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo AUGC" <> $SessionUUID],
					Model[Molecule, Oligomer, "DNASynthOptions Test oligo GC" <> $SessionUUID],
					Model[Molecule, Oligomer, "DNASynthOptions Test multi-strand oligo" <> $SessionUUID],
					Model[Molecule, Oligomer, "polyAUUest DNASynthOptions Test" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		]
	)
];



(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisPreview*)

DefineTests[ExperimentRNASynthesisPreview,
	{
		Example[
			{Basic, "Returns Null:"},
			ExperimentRNASynthesisPreview[{
				Model[Sample, "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID],
				Model[Sample, "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID],
				Model[Sample, "Test oligo GC for ExperimentRNASynthesisPreview" <> $SessionUUID]}],
			Null
		],
		Example[
			{Basic, "Even if an input is invalid, returns Null:"},
			ExperimentRNASynthesisPreview[Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisPreview" <> $SessionUUID]],
			Null,
			Messages :> {Error::InvalidStrands, Error::InvalidInput}
		],
		Example[
			{Basic, "Even if an option is invalid, returns Null:"},
			ExperimentRNASynthesisPreview[{Model[Sample, "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID]},
				Phosphoramidites -> {{DNA["A"], Model[Sample, StockSolution, "Test samples for ExperimentRNASynthesisPreview" <> $SessionUUID]}, {DNA["A"], Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisPreview" <> $SessionUUID]}}
			],
			Null,
			Messages :> {Error::MonomerPhosphoramiditeConflict, Error::InvalidOption}
		]
	},


	(*  build test objects *)
	Stubs :> {
		$SPERoboticOnly = False,
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, "Test oligo GC for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, StockSolution, "Test samples for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test oligo AUGC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test oligo GC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test multi-strand oligo" <> $SessionUUID],
					Model[Molecule, Oligomer, "polyAUUest RNASynthPreview Test" <> $SessionUUID]
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
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "RNASynthPreview Test oligo AUGC" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["GC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "RNASynthPreview Test oligo GC" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]], Strand[RNA["AUGC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "RNASynthPreview Test multi-strand oligo" <> $SessionUUID, DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUUAA"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "polyAUUest RNASynthPreview Test" <> $SessionUUID, DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[{
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test oligo AUGC for ExperimentRNASynthesisPreview" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ExperimentRNASynthesisPreview" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ExperimentRNASynthesisPreview" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel5]}}
				|>,
				<|
					Type -> Model[Sample, StockSolution],
					Name -> "Test samples for ExperimentRNASynthesisPreview" <> $SessionUUID
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
					Model[Sample, "Test multi-strand oligo for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, "polyAUUest for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, "Test oligo GC for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, StockSolution, "Test oligo AUGC for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Sample, StockSolution, "Test samples for ExperimentRNASynthesisPreview" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test oligo AUGC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test oligo GC" <> $SessionUUID],
					Model[Molecule, Oligomer, "RNASynthPreview Test multi-strand oligo" <> $SessionUUID],
					Model[Molecule, Oligomer, "polyAUUest RNASynthPreview Test" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		])
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentRNASynthesisQ*)

DefineTests[ValidExperimentRNASynthesisQ,
	{
		Example[
			{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidExperimentRNASynthesisQ[{
				Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo AUGC for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo GC for ValidExperimentRNASynthesisQ"]}],
			True
		],
		Example[
			{Basic, "If an input is invalid, returns False:"},
			ValidExperimentRNASynthesisQ[Model[Sample, "Test multi-strand oligo for ValidExperimentRNASynthesisQ"]],
			False
		],
		Example[
			{Basic, "If an option is invalid, returns False:"},
			ValidExperimentRNASynthesisQ[{Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"]},
				Phosphoramidites -> {{RNA["A"], Model[Sample, "NonExistingSample"<>ToString[Unique[]]]}}
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidExperimentRNASynthesisQ[{
				Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo AUGC for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo GC for ValidExperimentRNASynthesisQ"]},
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentRNASynthesisQ[{
				Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo AUGC for ValidExperimentRNASynthesisQ"],
				Model[Sample, "Test oligo GC for ValidExperimentRNASynthesisQ"]},
				Verbose -> True
			],
			BooleanP
		]
	},


	(*  build test objects *)
	Stubs :> {
		$SPERoboticOnly = False,
		$PersonID=Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Model[Sample, "Test multi-strand oligo for ValidExperimentRNASynthesisQ"],
					Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"],
					Model[Sample, "Test oligo GC for ValidExperimentRNASynthesisQ"],
					Model[Sample, "Test oligo AUGC for ValidExperimentRNASynthesisQ"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test oligo AUGC"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test oligo GC"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyAUUest ValidRNASynthQ Test"]
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
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "ValidRNASynthQ Test oligo AUGC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["GC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "ValidRNASynthQ Test oligo GC", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUGC"]], Strand[RNA["AUGC"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "ValidRNASynthQ Test multi-strand oligo", DeveloperObject -> True|>,
				<|Type -> Model[Molecule, Oligomer], Molecule -> Structure[{Strand[RNA["AUUAA"]]}, {}], PolymerType -> RNA, State -> Solid, Name -> "polyAUUest ValidRNASynthQ Test", DeveloperObject -> True|>
			}];

			(* upload models *)
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test oligo AUGC for ValidExperimentRNASynthesisQ",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel2]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test oligo GC for ValidExperimentRNASynthesisQ",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel3]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "polyAUUest for ValidExperimentRNASynthesisQ",
					Replace[Composition] -> {{100 MassPercent, Link[dnaSynthIdModel7]}}
				|>
			];
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "Test multi-strand oligo for ValidExperimentRNASynthesisQ",
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
					Model[Sample, "Test multi-strand oligo for ValidExperimentRNASynthesisQ"],
					Model[Sample, "polyAUUest for ValidExperimentRNASynthesisQ"],
					Model[Sample, "Test oligo GC for ValidExperimentRNASynthesisQ"],
					Model[Sample, "Test oligo AUGC for ValidExperimentRNASynthesisQ"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test oligo AUGC"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test oligo GC"],
					Model[Molecule, Oligomer, "ValidRNASynthQ Test multi-strand oligo"],
					Model[Molecule, Oligomer, "polyAUUest ValidRNASynthQ Test"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
		])
];



(* ::Subsubsection:: *)
(*experimentNNASynthesis*)
DefineTests[
	experimentNNASynthesis,
	{
		(*-- Basic --*)
		Example[{Basic,"Generates a protocol to synthesize RNA oligonucleotides of the provided sequences:"},
			experimentNNASynthesis[RNA,{"AUGCAGUGAC",Strand[RNA["GUAGACUGAU"]],Structure[{Strand[RNA["UUCAGACAAG"]]},{}]}],
			ObjectP[Object[Protocol,RNASynthesis]]
		],
		Example[{Basic,"Generates a protocol to synthesize DNA oligonucleotides of the provided sequences:"},
			experimentNNASynthesis[DNA,{"ATGCAGTGAC",Strand[DNA["GTAGACTGAT"]],Structure[{Strand[DNA["TTCAGACAAG"]]},{}]}],
			ObjectReferenceP[Object[Protocol,DNASynthesis]]
		],
		Example[{Additional,"Generates a protocol to synthesize DNA oligonucleotides of the provided sequences with the specified instrument:"},
			experimentNNASynthesis[DNA,{"ATGCAGTGAC",Strand[DNA["GTAGACTGAT"]],Structure[{Strand[DNA["TTCAGACAAG"]]},{}]}, Instrument->Model[Instrument, DNASynthesizer, "id:aXRlGnZmOOPB"]],
			ObjectReferenceP[Object[Protocol,DNASynthesis]]
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	)
];
