(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentPNASynthesis*)


DefineTests[
	ExperimentPNASynthesis,
	{
		Example[{Basic, "Synthesize a PNA oligomer at scales over 5 Micromole using a PeptideSynthesizer:"},
			ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model"]],
			ObjectP[Object[Protocol,PNASynthesis]],
			TimeConstraint -> 180
		],
		Example[{Basic, "Synthesize a PNA oligomer using sequence, strand or structure as inputs:"},
			ExperimentPNASynthesis[
				{
					"AGCTAA",
					PNA["AGCTAAT"],
					ToStrand[PNA["AGCTAATG"]],
					ToStructure["AGCTAATGC", Polymer -> PNA],
					Strand[PNA["A"], PNA["GGGGCTAATG"]]
				}
			],
			ObjectP[Object[Protocol,PNASynthesis]],
			TimeConstraint -> 360
		],
		Example[{Basic, "Synthesize multiple PNA oligomers at scales over 5 Micromole using a PeptideSynthesizer:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model 1"],
					Model[Sample,"PNA Test Oligomer Model 2"]
				}],
			ObjectP[Object[Protocol,PNASynthesis]]
		],
		Example[{Additional, "Synthesize a PNA oligomer using a Model[Molecule] as inputs:"},
			ExperimentPNASynthesis[{Model[Molecule,Oligomer,"Test Oligomer for Molecule Input testing 2"<>$SessionUUID]}],
			ObjectP[Object[Protocol,PNASynthesis]],
			TimeConstraint -> 360,
			TearDown:>
					EraseObject[
						{
						Model[Sample,"Test Oligomer for Molecule Input testing 2"<>$SessionUUID]
					},
						Force->True,
						Verbose->False
					]
		],
		Test["Synthesize a PNA oligomer using a all possible input variants:",
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Molecule,Oligomer,"Test Oligomer for Molecule Input testing 3"<>$SessionUUID],
					"AGCTAA",
					PNA["AGCTAAT"],
					ToStrand[PNA["AGCTAATG"]],
					ToStructure["AGCTAATGC", Polymer -> PNA]
				}
			],
			ObjectP[Object[Protocol,PNASynthesis]],
			TimeConstraint -> 360,
			TearDown:>
				EraseObject[{Model[Sample,"Test Oligomer for Molecule Input testing 3"<>$SessionUUID]},Force->True,Verbose->False]
		],
		Example[{Options,Instrument,"Instrument allows specification of the model or objects instrument that should be used for the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model 1"],
						Model[Sample,"PNA Test Oligomer Model 2"]
					},
					Instrument->Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer"],
					Output->Options
				],
				Instrument
			],
			ObjectP[Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer"]]
		],
		Example[{Options,SynthesisStrategy,"SynthesisStrategy allows specification of the type of synthesis strategy that should be used for the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SynthesisStrategy->Fmoc,
					Output->Options
				],
				SynthesisStrategy
			],
			Fmoc
		],

		(*NOTE: Washing*)
		Example[{Options,WashSolution,"WashSolution allows specification of model or sample object that should be used to wash the resin in between each reagent additions:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					WashSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				WashSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options,WashVolume,"WashVolume allows specification of the volume of WashSolution that should be used to wash the resin in between each reagent additions:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 15 Micromole},
					WashVolume->{2.5 Milliliter, Automatic,Automatic},
					Output->Options
				],
				WashVolume
			],
			{Quantity[2.5`, "Milliliters"], VolumeP, VolumeP}
		],

		(*NOTE: Monomer options*)
		Example[{Options,Monomers,"Monomers allows specification of model or sample object to use for each of the monomers in the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Monomers->{
						{PNA["A"], Model[Sample,StockSolution, "PNA Test Monomer - A"]},
						{PNA["T"], Model[Sample,StockSolution, "PNA Test Monomer - T"]}
					},
					Output->Options
				],
				Monomers
			],
			{
				{PNA["A"],ObjectP[Model[Sample,StockSolution, "PNA Test Monomer - A"]]},
				{PNA["T"],ObjectP[Model[Sample,StockSolution, "PNA Test Monomer - T"]]},
				{PNA["C"],ObjectP[Model[Sample,StockSolution]]},
				{PNA["G"],ObjectP[Model[Sample,StockSolution]]}
			}
		],

		Example[{Messages,"UnknownMonomer","Monomers automatic resolution will fail when novel monomers are used and therefore monomer solutions must be explicitly specified:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						StrandJoin[
							ToStrand[Peptide["Pyl"]],
							ToStrand[PNA["AGCTAATG"]]
						]
					},
					Output->Options
				],
				Monomers
			],
			{
				{Peptide["Pyl"], Null},
				{PNA["A"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-A Bhoc in NMP Coupling Solution"]]},
				{PNA["G"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-G Bhoc in NMP Coupling Solution"]]},
				{PNA["C"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-C Bhoc in NMP Coupling Solution"]]},
				{PNA["T"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-T in NMP Coupling Solution"]]}
			},
			Messages:>{Message[Error::UnknownMonomer],Message[Error::InvalidOption]}
		],

		Example[{Options,Monomers,"Monomers allows specification of novel monomers to be used for the synthesis of the bulk monomers:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model with novel monomers"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Monomers->{
						{GammaLeftPNA["A"],Model[Sample,StockSolution,"PNA Test GammLeftPNA[A] Stock Solution"]},
						{GammaLeftPNA["T"],Model[Sample,StockSolution,"PNA Test GammLeftPNA[T] Stock Solution"]},
						{GammaLeftPNA["C"],Model[Sample,StockSolution,"PNA Test GammLeftPNA[C] Stock Solution"]}
					},
					Output->Options
				],
				Monomers
			],
			{
				{GammaLeftPNA["A"],ObjectP[Model[Sample,StockSolution,"PNA Test GammLeftPNA[A] Stock Solution"]]},
				{GammaLeftPNA["T"],ObjectP[Model[Sample,StockSolution,"PNA Test GammLeftPNA[T] Stock Solution"]]},
				{GammaLeftPNA["C"],ObjectP[Model[Sample,StockSolution,"PNA Test GammLeftPNA[C] Stock Solution"]]},
				{PNA["A"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-A Bhoc in NMP Coupling Solution"]]},
				{PNA["T"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-T in NMP Coupling Solution"]]},
				{PNA["C"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-C Bhoc in NMP Coupling Solution"]]},
				{PNA["G"],ObjectP[Model[Sample, StockSolution,"100 mM Link Fmoc-G Bhoc in NMP Coupling Solution"]]}

			}
		],

		Example[{Options,MonomerVolume,"MonomerVolume allows specification of volume of monomer solution added for each reaction vessel to the preactivation vessel for a micromole scale synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole,5 Micromole,10 Micromole, 15 Micromole},
					MonomerVolume->{2.5 Milliliter, 5 Milliliter, Automatic, Automatic},
					Output->Options
				],
				MonomerVolume
			],
			{2.5 Milliliter, 5 Milliliter, GreaterEqualP[1Milliliter], GreaterEqualP[1Milliliter]},
			TimeConstraint -> 120
		],

		(*NOTE:DownloadMonomer*)
		Example[{Options,DownloadMonomer,"DownloadMonomer automatic resolution will fail when a novel download monomer is used and therefore must explicity specified:"},
			Lookup[
				ExperimentPNASynthesis[
					StrandJoin[
						ToStrand[PNA["AGCTAATGA"]],
						ToStrand[Peptide["Pyl"]]
					],
					DownloadResin->True,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::UnknownDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Options,DownloadMonomer,"DownloadMonomer allows specification of model or sample object to use for each of the monomers in the download:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadMonomer->{
						Model[Sample,StockSolution, "PNA Test Monomer - A"],
						Null,
						Automatic,
						Automatic
					},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadMonomer
			],
			{
				ObjectP[Model[Sample,StockSolution, "PNA Test Monomer - A"]],
				Null,
				Null,
				ObjectP[Model[Sample,StockSolution]]
			},
			TimeConstraint -> 120
		],

		Example[{Options,DownloadMonomer,"When using novel monomers for the download monomer, explicitly specify the model or sample object to use for that DownloadMonomer:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model with novel download monomer"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadMonomer->{
						Model[Sample,StockSolution,"PNA Test GammLeftPNA[G] Stock Solution"],
						Automatic
					},
					Output->Options
				],
				DownloadMonomer
			],
			{
				ObjectP[Model[Sample,StockSolution,"PNA Test GammLeftPNA[G] Stock Solution"]],
				ObjectP[Model[Sample,StockSolution]]
			}
		],

		Example[{Messages,DownloadMonomer,"DownloadMonomer cannot be set to Null, if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadMonomer->Null,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::UnknownDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadMonomer,"DownloadMonomer should only be specified if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadMonomer->Model[Sample,StockSolution, "PNA Test Monomer - A"],
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadMonomer
			],
			ObjectP[Model[Sample,StockSolution, "PNA Test Monomer - A"]],
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:DownloadMonomerVolume*)
		Example[{Options,DownloadMonomerVolume,"DownloadMonomerVolume allows specification volume of monomer solution added for each reaction vessel to the preactivation vessel per micromole of synthesis scale:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadMonomerVolume->{
						2.15 Milliliter,
						Null,
						Automatic,
						Automatic
					},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadMonomerVolume
			],
			{
				2.15 Milliliter,
				Null,
				Null,
				GreaterEqualP[1 Milliliter]
			},
			TimeConstraint -> 120
		],
		Example[{Options,DownloadMonomerVolume,"DownloadMonomerVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadMonomerVolume->Null,
					Output->Options
				],
				DownloadMonomerVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadMonomerVolume,"DownloadMonomerVolume should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadMonomerVolume->5.23 Milliliter,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadMonomerVolume
			],
			5.23 Milliliter,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: Activation options *)
		Example[{Options,ActivationSolution,"ActivationSolution allows specification of model or sample object that is a mix of preactivation and base solutions used to activate the monomers prior to coupling during a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					ActivationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				ActivationSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		(*NOTE: ActivationTime*)
		Example[{Options,ActivationTime,"ActivationTime allows specification of duration of the preactivation mixing:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					ActivationTime->{12 Minute, 5 Minute},
					Output->Options
				],
				ActivationTime
			],
			{12 Minute, 5 Minute}
		],
		(*NOTE:ActivationVolume*)
		Example[{Options,ActivationVolume,"ActivationVolume allows specification of volume of ActivationSolution added to each preactivation vessel:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 15 Micromole},
					ActivationVolume->{2.5 Milliliter, Automatic,Automatic},
					Output->Options
				],
				ActivationVolume
			],
			{Quantity[2.5`, "Milliliters"], VolumeP, VolumeP}
		],

		(*NOTE:DownloadActivationSolution*)
		Example[{Options,DownloadActivationSolution,"DownloadActivationSolution allows specification of model or sample object that should be used to activate the monomers for coupling when preloading the resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False},
					DownloadActivationSolution->Model[Sample, "Milli-Q water"],
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"]},
					Output->Options
				],
				{DownloadResin,DownloadActivationSolution}
			],
			{
				{True,False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			}
		],
		Example[{Messages,DownloadActivationSolution,"DownloadActivationSolution cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadActivationSolution->Null,
					Output->Options
				],
				DownloadActivationSolution
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadActivationSolution,"DownloadActivationSolution should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadActivationSolution->Model[Sample, "Milli-Q water"],
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadActivationSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]},
			TimeConstraint->180
		],

		(*NOTE:DownloadActivationTime*)
		Example[{Options,DownloadActivationTime,"DownloadActivationTime allows specification of duration of the preactivation mixing:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadActivationTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadActivationTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadActivationTime,"DownloadActivationTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadActivationTime->Null,
					Output->Options
				],
				DownloadActivationTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadActivationTime,"DownloadActivationTime should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadActivationTime->12 Minute,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadActivationTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],


		(*NOTE:DownloadActivationVolume*)
		Example[{Options,DownloadActivationVolume,"DownloadActivationVolume allows specification of volume of DownloadActivationSolution added to each preactivation vessel:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadActivationVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadActivationVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadActivationVolume,"DownloadActivationVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadActivationVolume->Null,
					Output->Options
				],
				DownloadActivationVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadActivationVolume,"DownloadActivationVolume should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadActivationVolume->2.5 Milliliter,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadActivationVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: CouplingTime*)
		Example[{Options,CouplingTime,"CouplingTime allows specification of amount of time that each reaction vessel is exposed to the coupling solution during each coupling step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					CouplingTime->{12 Minute, 5 Minute},
					Output->Options
				],
				CouplingTime
			],
			{12 Minute, 5 Minute}
		],
		(*NOTE: NumberOfCouplingWashes*)
		Example[{Options,NumberOfCouplingWashes,"NumberOfCouplingWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the coupling step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					NumberOfCouplingWashes->{2, 5},
					Output->Options
				],
				NumberOfCouplingWashes
			],
			{2, GreaterEqualP[1]}
		],

		(*NOTE:DownloadCouplingTime*)
		Example[{Options,DownloadCouplingTime,"DownloadCouplingTime allows specification of amount of time for which the resin mixed be mixed with coupling solution during a coupling step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadCouplingTime->{12 Minute,Automatic,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadCouplingTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadCouplingTime,"DownloadCouplingTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadCouplingTime->Null,
					Output->Options
				],
				DownloadCouplingTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],

		Example[{Messages,DownloadCouplingTime,"DownloadCouplingTime should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadCouplingTime->12 Minute,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadCouplingTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],


		(*NOTE:NumberOfDownloadCouplingWashes*)
		Example[{Options,NumberOfDownloadCouplingWashes,"NumberOfDownloadCouplingWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the coupling step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCouplingWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadCouplingWashes
			],
			{2, Null, Null,GreaterEqualP[1]},
			TimeConstraint -> 240
		],
		Example[{Messages,NumberOfDownloadCouplingWashes,"NumberOfDownloadCouplingWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadCouplingWashes->Null,
					Output->Options
				],
				NumberOfDownloadCouplingWashes
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadCouplingWashes,"NumberOfDownloadCouplingWashes should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadCouplingWashes->2,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadCouplingWashes
			],
			2,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: CappingSolution*)
		Example[{Options,CappingSolution,"CappingSolution allows specification of model or sample object that should be used to cap any remaining uncoupled sites from growing further during the synthesis to aid in later purification of the truncations:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					CappingSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				CappingSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],

		(*NOTE: CappingTime*)
		Example[{Options,CappingTime,"CappingTime allows specification length of time that the resin is incubated with the CappingSolution:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					CappingTime->{12 Minute, 5 Minute},
					Output->Options
				],
				CappingTime
			],
			{12 Minute, 5 Minute}
		],

		(*NOTE: CappingVolume*)
		Example[{Options,CappingVolume,"CappingVolume allows specification of he volume of CappingSolution added to each reaction vessel during the capping step of a main synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 15 Micromole},
					CappingVolume->{2.5 Milliliter, Automatic,Automatic},
					Output->Options
				],
				CappingVolume
			],
			{Quantity[2.5`, "Milliliters"], VolumeP, VolumeP}
		],

		(*NOTE: NumberOfCappings*)
		Example[{Options,NumberOfCappings,"NumberOfCappings allows specification of the number of times that each reaction vessel is capped during each capping step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					NumberOfCappings->{4,3,2},
					Output->Options
				],
				NumberOfCappings
			],
			{4, 3, 2}
		],
		(*NOTE:NumberOfCappingWashes*)
		Example[{Options,NumberOfCappingWashes,"NumberOfCappingWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the capping step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					NumberOfCappingWashes->{2, 5},
					Output->Options
				],
				NumberOfCappingWashes
			],
			{2, GreaterEqualP[1]}
		],

		(*NOTE:DownloadCappingTime*)
		Example[{Options,DownloadCappingTime,"DownloadCappingTime allows specification of amount of time for which the resin should be shaken with CappingSolution per capping step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadCappingTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadCappingTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadCappingTime,"DownloadCappingTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadCappingTime->Null,
					Output->Options
				],
				DownloadCappingTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadCappingTime,"DownloadCappingTime should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadCappingTime->12 Minute,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadCappingTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:DownloadCappingVolume*)
		Example[{Options,DownloadCappingVolume,"DownloadCappingVolume allows specification of CappingSolution added to each reaction vessel during the capping step of of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadCappingVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadCappingVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint -> 120
		],

		Example[{Messages,DownloadCappingVolume,"DownloadCappingVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadCappingVolume->Null,
					Output->Options
				],
				DownloadCappingVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadCappingVolume,"DownloadCappingVolume should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadCappingVolume->2.5 Milliliter,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadCappingVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfDownloadCappings*)
		Example[{Options,NumberOfDownloadCappings,"NumberOfDownloadCappings allows specification of the number of times that each reaction vessel is capped during each capping step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCappings->{3, Null, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadCappings
			],
			{3, Null, Null,2},
			TimeConstraint -> 180,
			Messages:>{}
		],
		Example[{Messages,NumberOfDownloadCappings,"NumberOfDownloadCappings cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadCappings->Null,
					Output->Options
				],
				NumberOfDownloadCappings
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadCappings,"NumberOfDownloadCappings should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadCappings->2,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadCappings
			],
			2,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],
		(*NOTE:NumberOfDownloadCappingWashes*)
		Example[{Options,NumberOfDownloadCappingWashes,"NumberOfDownloadCappingWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the capping step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCappingWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadCappingWashes
			],
			{2, Null, Null, 5},
			TimeConstraint -> 240,
			Messages:>{}
		],
		Example[{Messages,NumberOfDownloadCappingWashes,"NumberOfDownloadCappingWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadCappingWashes->Null,
					Output->Options
				],
				NumberOfDownloadCappingWashes
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadCappingWashes,"NumberOfDownloadCappingWashes should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadCappingWashes->2,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadCappingWashes
			],
			2,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: Deprotection options*)
		Example[{Options,DeprotectionSolution,"DeprotectionSolution allows specification of model or sample object that should be used to remove protecting groups from the growing strand during the deprotection step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DeprotectionSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				DeprotectionSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options,DeprotectionTime,"DeprotectionTime allows specification mount of time that each reaction vessel is exposed to the deprotection solution during each deprotection step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DeprotectionTime->{12 Minute, 5 Minute},
					Output->Options
				],
				DeprotectionTime
			],
			{12 Minute, 5 Minute}
		],
		Example[{Options,DeprotectionVolume,"DeprotectionVolume allows specification of volume of DeprotectionSolution added to each reaction vessel:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 15 Micromole},
					DeprotectionVolume->{2.5 Milliliter, Automatic,Automatic},
					Output->Options
				],
				DeprotectionVolume
			],
			{Quantity[2.5`, "Milliliters"], VolumeP, VolumeP}
		],
		Example[{Options,NumberOfDeprotections,"NumberOfDeprotections allows specification of the number of times that each reaction vessel should be deprotect during each deprotection step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					NumberOfDeprotections->{4, 3, 2},
					Output->Options
				],
				NumberOfDeprotections
			],
			{4, 3, 2}
		],
		Example[{Options,NumberOfDeprotectionWashes,"NumberOfDeprotectionWashes allows specification of the number of WashSolution washes each reaction vessel should undergo after the deprotection step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					NumberOfDeprotectionWashes->{2, 5},
					Output->Options
				],
				NumberOfDeprotectionWashes
			],
			{2, GreaterEqualP[1]}
		],

		(*NOTE: Download Deprotection options*)
		(*NOTE: DownloadDeprotectionTime*)
		Example[{Options,DownloadDeprotectionTime,"DownloadDeprotectionTime allows specification of amount of time for which the resin should be shaken with DeprotectionSolution per deprotection step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadDeprotectionTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadDeprotectionTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120,
			Messages:>{}
		],
		Example[{Messages,DownloadDeprotectionTime,"DownloadDeprotectionTime cannot be set to Null if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadDeprotectionTime->Null,
					Output->Options
				],
				DownloadDeprotectionTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadDeprotectionTime,"DownloadDeprotectionTime should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadDeprotectionTime->12 Minute,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadDeprotectionTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}

		],

		(*NOTE: DownloadDeprotectionVolume*)
		Example[{Options,DownloadDeprotectionVolume,"DownloadDeprotectionVolume allows specification of DeprotectionSolution added to each reaction vessel during the deprotection step of of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadDeprotectionVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadDeprotectionVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint -> 120,
			Messages :> {}
		],
		Example[{Messages,DownloadDeprotectionVolume,"DownloadDeprotectionVolume cannot be set to Null if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadDeprotectionVolume->Null,
					Output->Options
				],
				DownloadDeprotectionVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadDeprotectionVolume,"DownloadDeprotectionVolume should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadDeprotectionVolume->2.5 Milliliter,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadDeprotectionVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}

		],

		(*NOTE: NumberOfDownloadDeprotections*)
		Example[{Options,NumberOfDownloadDeprotections,"NumberOfDownloadDeprotections allows specification of the number of times that each reaction vessel is deprotected during each deprotection step of a download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotections->{4, Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotections
			],
			{4, Null, Null, 2},
			Messages :> {},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotections,"NumberOfDownloadDeprotections cannot be set to Null, if DownloadResin has been set to True:"
		},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadDeprotections->Null,
					Output->Options
				],
				NumberOfDownloadDeprotections
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadDeprotections,"NumberOfDownloadDeprotections should only be specified if DownloadResin has been set to True:"
		},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadDeprotections->4,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadDeprotections
			],
			4,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: NumberOfDownloadDeprotectionWashes*)
		Example[{Options,NumberOfDownloadDeprotectionWashes,"NumberOfDownloadDeprotectionWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the deprotection step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotectionWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotectionWashes
			],
			{2, Null, Null, 5},
			Messages :> {},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotectionWashes,"NumberOfDownloadDeprotectionWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadDeprotectionWashes->Null,
					Output->Options
				],
				NumberOfDownloadDeprotectionWashes
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadDeprotectionWashes,"NumberOfDownloadDeprotectionWashes should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadDeprotectionWashes->2,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadDeprotectionWashes
			],
			2,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:Deprotonation*)
		Example[{Options,Deprotonation,"Deprotonation specifies if an optional deprotonation step with DeprotonationSolution is performed between the deprotection and capping steps of synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->{True,False},
					Output->Options
				],
				Deprotonation
			],
			{True,False}
		],
		(*NOTE:DeprotonationSolution*)
		Example[{Options,DeprotonationSolution,"DeprotonationSolution allows specification of model or sample object that should be used to neutralize the resin prior to the coupling step:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->{True,False},
					DeprotonationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{Deprotonation,DeprotonationSolution}
			],
			{
				{True, False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			}
		],
		Example[{Messages,DeprotonationSolution,"DeprotonationSolution cannot be set to Null if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					Deprotonation->False,
					DeprotonationSolution->Null,
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{True,False,Null},
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DeprotonationSolution,"DeprotonationSolution cannot be set to Null if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					Deprotonation->True,
					DeprotonationSolution->Null,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{False,True,Null},
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DeprotonationSolution,"DeprotonationSolution should only be specified if DownloadResin or Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Deprotonation->False,
					DeprotonationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{False,False,ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:DeprotonationTime*)
		Example[{Options,DeprotonationTime,"DeprotonationTime allows specification amount of time that each reaction vessel is exposed to the deprotonation solution during each deprotection step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->{True,False,True},
					DeprotonationTime->{12 Minute, Automatic, Automatic},
					Output->Options
				],
				DeprotonationTime
			],
			{12 Minute, Null,5 Minute}
		],
		Example[{Messages,DeprotonationTime,"DeprotonationTime cannot be set to Null, if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->True,
					DeprotonationTime->Null,
					Output->Options
				],
				DeprotonationTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DeprotonationTime,"DeprotonationTime should only be specified if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->False,
					DeprotonationTime->12 Minute,
					Output->Options
				],
				DeprotonationTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],


		(*NOTE:DeprotonationVolume*)
		Example[{Options,DeprotonationVolume,"DeprotonationVolume allows specification of volume of DeprotonationSolution added to each reaction vessel during an optional deprotonation step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 15 Micromole},
					Deprotonation->{True,False,True},
					DeprotonationVolume->{2.5 Milliliter, Automatic,Automatic},
					Output->Options
				],
				DeprotonationVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, VolumeP}
		],
		Example[{Messages,DeprotonationVolume,"DeprotonationVolume cannot be set to Null, if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->True,
					DeprotonationVolume->Null,
					Output->Options
				],
				DeprotonationVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DeprotonationVolume,"DeprotonationVolume should only be specified if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->False,
					DeprotonationVolume->2.5 Milliliter,
					Output->Options
				],
				DeprotonationVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfDeprotonations*)
		Example[{Options,NumberOfDeprotonations,"NumberOfDeprotonations allows specification of the number of times that each reaction vessel is deprotonation during each deprotonation step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->{True,False,False,True},
					NumberOfDeprotonations->{4, Null,Automatic,Automatic},
					Output->Options
				],
				NumberOfDeprotonations
			],
			{4, Null, Null, 2},
			TimeConstraint -> 240
		],
		Example[{Messages,NumberOfDeprotonations,"NumberOfDeprotonations cannot be set to Null, if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->True,
					NumberOfDeprotonations->Null,
					Output->Options
				],
				NumberOfDeprotonations
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDeprotonations,"NumberOfDeprotonations should only be specified if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->False,
					NumberOfDeprotonations->4,
					Output->Options
				],
				NumberOfDeprotonations
			],
			4,
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]},
			TimeConstraint -> 120
		],

		(*NOTE:NumberOfDeprotonationWashes*)
		Example[{Options,NumberOfDeprotonationWashes,"NumberOfDeprotonationWashes allows specification of the number of WashSolution washes each reaction vessel undergoes after the deprotonation step of a synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Deprotonation->True,
					NumberOfDeprotonationWashes->{2, 5},
					Output->Options
				],
				NumberOfDeprotonationWashes
			],
			{2, GreaterEqualP[1]},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDeprotonationWashes,"NumberOfDeprotonationWashes cannot be set to Null, if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->True,
					NumberOfDeprotonationWashes->Null,
					Output->Options
				],
				NumberOfDeprotonationWashes
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDeprotonationWashes,"NumberOfDeprotonationWashes should only be specified if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Deprotonation->False,
					NumberOfDeprotonationWashes->5,
					Output->Options
				],
				NumberOfDeprotonationWashes
			],
			5,
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:DownloadDeprotonationTime*)
		Example[{Options,DownloadDeprotonationTime,"DownloadDeprotonationTime allows specification of amount of time for which the resin should be shaken with DeprotonationSolution per deprotonation step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					DownloadDeprotonationTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadDeprotonationTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotonationTime,"DownloadDeprotonationTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadDeprotonationTime->Null,
					Output->Options
				],
				DownloadDeprotonationTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadDeprotonationTime,"DownloadDeprotonationTime should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadDeprotonationTime->12 Minute,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadDeprotonationTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:DownloadDeprotonationVolume*)
		Example[{Options,DownloadDeprotonationVolume,"DownloadDeprotonationVolume allows specification of DeprotonationSolution added to each reaction vessel during the deprotonation step of of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadDeprotonationVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				DownloadDeprotonationVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,VolumeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotonationVolume,"DownloadDeprotonationVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadDeprotonationVolume->Null,
					Output->Options
				],
				DownloadDeprotonationVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadDeprotonationVolume,"DownloadDeprotonationVolume should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadDeprotonationVolume->2.5 Milliliter,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadDeprotonationVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfDownloadDeprotonationWashes*)
		Example[{Options,NumberOfDownloadDeprotonationWashes,"NumberOfDownloadDeprotonationWashes allows specification of the number of WashSolution washes each reaction vessel should undergo after the deprotonation step of a resin download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					NumberOfDownloadDeprotonationWashes->{2, Automatic, Automatic, Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotonationWashes
			],
			{2, Null, Null, 5},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotonationWashes,"NumberOfDownloadDeprotonationWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadDeprotonationWashes->Null,
					Output->Options
				],
				NumberOfDownloadDeprotonationWashes
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadDeprotonationWashes,"NumberOfDownloadDeprotonationWashes should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					NumberOfDownloadDeprotonationWashes->2,
					Output->Options
				],
				NumberOfDownloadDeprotonationWashes
			],
			2,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfDownloadDeprotonations*)
		Example[{Options,NumberOfDownloadDeprotonations,"NumberOfDownloadDeprotonations allows specification of the number of times that each reaction vessel is deprotonated during each deprotonation step of a download cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotonations->{4, Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"],Model[Sample,"PNA Test Downloaded Resin"],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotonations
			],
			{4, Null, Null, 2},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotonations,"NumberOfDownloadDeprotonations cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					NumberOfDownloadDeprotonations->Null,
					Output->Options
				],
				NumberOfDownloadDeprotonations
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfDownloadDeprotonations,"NumberOfDownloadDeprotections should only be specified if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					NumberOfDownloadDeprotonations->4,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				NumberOfDownloadDeprotonations
			],
			4,
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],


		(*NOTE: Cleavage options*)
		Example[{Options,Cleavage,"Cleavage specifies if the oligomers should be cleaved at the end of the synthesis using CleavageSolution or stored as a resin slurry in StorageBuffer:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					Output->Options
				],
				Cleavage
			],
			{True,False}
		],

		(*NOTE:CleavageSolution*)
		Example[{Options,CleavageSolution,"CleavageSolution allows specification of model or sample object that should be used to cleave the strands from the resins post synthesis resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					CleavageSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{Cleavage,CleavageSolution}
			],
			{
				{True,False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			}
		],
		Example[{Messages,CleavageSolution,"CleavageSolution cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					CleavageSolution->Null,
					Output->Options
				],
				CleavageSolution
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,CleavageSolution,"CleavageSolution should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					CleavageSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				CleavageSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:CleavageTime*)
		Example[{Options,CleavageTime,"CleavageTime specifies the length of time for which the strands should be cleaved in cleavage solution:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,True,False},
					CleavageTime->{15 Minute,Automatic,Null},
					Output->Options
				],
				CleavageTime
			],
			{15 Minute,TimeP,Null}
		],
		Example[{Messages,CleavageTime,"CleavageTime cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					CleavageTime->Null,
					Output->Options
				],
				CleavageTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,CleavageTime,"CleavageTime should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					CleavageTime->15 Minute,
					Output->Options
				],
				CleavageTime
			],
			15 Minute,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:CleavageVolume*)
		Example[{Options,CleavageVolume,"CleavageVolume specifies volume of cleavage cocktail that should be used to cleave the PNA strands from the resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,True,False},
					CleavageVolume->{15 Milliliter,Automatic,Null},
					Output->Options
				],
				CleavageVolume
			],
			{15 Milliliter,VolumeP,Null}
		],
		Example[{Messages,CleavageVolume,"CleavageVolume cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					CleavageVolume->Null,
					Output->Options
				],
				CleavageVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,CleavageVolume,"CleavageVolume should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					CleavageVolume->15 Milliliter,
					Output->Options
				],
				CleavageVolume
			],
			15 Milliliter,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfCleavageCycles*)
		Example[{Options,NumberOfCleavageCycles,"NumberOfCleavageCycles allows specification of the number of times the PNA strands on the resin should be incubated with the cleavage cocktail:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False,False,True},
					NumberOfCleavageCycles->{4, Null, Automatic, Automatic},
					Output->Options
				],
				NumberOfCleavageCycles
			],
			{4, Null, Null, GreaterEqualP[1]},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfCleavageCycles,"NumberOfCleavageCycles cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					NumberOfCleavageCycles->Null,
					Output->Options
				],
				NumberOfCleavageCycles
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfCleavageCycles,"NumberOfCleavageCycles should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					NumberOfCleavageCycles->4,
					Output->Options
				],
				NumberOfCleavageCycles
			],
			4,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],



		(*NOTE: Trituration options*)

		(*NOTE:TriturationSolution*)
		Example[{Options,TriturationSolution,"TriturationSolution allows specification of model or sample object that should be used to purify the PNA strands after cleavage from the resin by using the solubility differences between PNA strands, which should crash out of solution and impurities which remain soluble:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					TriturationSolution->Model[Sample, "PNA Test TriturationSolution"],
					Output->Options
				],
				{Cleavage,TriturationSolution}
			],
			{{True,False},ObjectP[Model[Sample, "PNA Test TriturationSolution"]]}
		],
		Example[{Messages,TriturationSolution,"TriturationSolution cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					TriturationSolution->Null,
					Output->Options
				],
				TriturationSolution
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,TriturationSolution,"TriturationSolution should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					TriturationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				TriturationSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:TriturationVolume*)
		Example[{Options,TriturationVolume,"TriturationVolume allows specification of volume of ether that should be used to triturate the PNA strands after cleavage from the resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					TriturationVolume->12 Milliliter,
					Output->Options
				],
				{Cleavage,TriturationVolume}
			],
			{{True,False},12 Milliliter}
		],
		Example[{Messages,TriturationVolume,"TriturationVolume cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					TriturationVolume->Null,
					Output->Options
				],
				TriturationVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,TriturationVolume,"TriturationVolume should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					TriturationVolume->12 Milliliter,
					Output->Options
				],
				TriturationVolume
			],
			12 Milliliter,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:TriturationTime*)
		Example[{Options,TriturationTime,"TriturationTime allows specification length of time for which the cleaved strands should be incubated in ether:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					TriturationTime->12 Minute,
					Output->Options
				],
				{Cleavage,TriturationTime}
			],
			{{True,False},12 Minute}
		],
		Example[{Messages,TriturationTime,"TriturationTime cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					TriturationTime->Null,
					Output->Options
				],
				TriturationTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,TriturationTime,"TriturationTime should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					TriturationTime->12 Minute,
					Output->Options
				],
				TriturationTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: TriturationTemperature*)
		Example[{Options,TriturationTemperature,"TriturationTemperature allows specification the temperature at which the cleaved strands should be incubated while in ether:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					TriturationTemperature->-80 Celsius,
					Output->Options
				],
				{Cleavage,TriturationTemperature}
			],
			{{True,False},-80 Celsius}
		],
		Example[{Messages,TriturationTemperature,"TriturationTemperature cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					TriturationTemperature->Null,
					Output->Options
				],
				TriturationTemperature
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,TriturationTemperature,"TriturationTemperature should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					TriturationTemperature->-80 Celsius,
					Output->Options
				],
				TriturationTemperature
			],
			-80 Celsius,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],


		(*NOTE:NumberOfTriturationCycles*)
		Example[{Options,NumberOfTriturationCycles,"NumberOfCleavageCycles allows specification number of times the cleaved PNA strands should be triturated with TriturationSolution:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False,False,True},
					NumberOfTriturationCycles->7,
					Output->Options
				],
				NumberOfTriturationCycles
			],
			7,
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfTriturationCycles,"NumberOfTriturationCycles cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					NumberOfTriturationCycles->Null,
					Output->Options
				],
				NumberOfTriturationCycles
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfTriturationCycles,"NumberOfTriturationCycles allows specification number of times the cleaved PNA strands should be triturated with TriturationSolution:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					NumberOfTriturationCycles->7,
					Output->Options
				],
				NumberOfTriturationCycles
			],
			7,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: Storage options*)
		Example[{Options,StorageBuffer,"StorageBuffer allows specification of model or sample object that should be used to store any uncleaved resin samples:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					StorageBuffer->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{Cleavage,StorageBuffer}
			],
			{
				{True,False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			}
		],
		Example[{Messages,StorageBuffer,"StorageBuffer cannot be set to Null, if Cleavage has been set to False:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					StorageBuffer->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				StorageBuffer
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededStorageOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,StorageBuffer,"StorageBuffer should only be specified if Cleavage has been set to False:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					StorageBuffer->Null,
					Output->Options
				],
				StorageBuffer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],

		(*NOTE:StorageVolume*)
		Example[{Options,StorageVolume,"StorageVolume allows specification of the desired volume of solution in which the uncleaved resin should be stored:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{False,True,True,False},
					StorageVolume->{10 Milliliter,Null,Automatic,Automatic},
					Output->Options
				],
				StorageVolume
			],
			{10 Milliliter,Null,Null,5 Milliliter},
			TimeConstraint->180
		],
		Example[{Messages,StorageVolume,"StorageVolume cannot be set to Null, if Cleavage has been set to False:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					StorageVolume->Null,
					Output->Options
				],
				StorageVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,StorageVolume,"StorageVolume should only be specified if Cleavage has been set to False:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					StorageVolume->10 Milliliter,
					Output->Options
				],
				StorageVolume
			],
			10 Milliliter,
			Messages:>{Message[Error::UnneededStorageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE: Resuspension options*)

		(*NOTE:ResuspensionBuffer*)
		Example[{Options,ResuspensionBuffer,"ResuspensionBuffer allows specification of model or sample object that should be used to resuspend the strands after cleavage from the resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False},
					ResuspensionBuffer->Model[Sample, "RO Water"],
					Output->Options
				],
				{Cleavage,ResuspensionBuffer}
			],
			{{True,False},ObjectP[Model[Sample, "RO Water"]]},
			TimeConstraint->180
		],
		Example[{Messages,ResuspensionBuffer,"ResuspensionBuffer cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					ResuspensionBuffer->Null,
					Output->Options
				],
				ResuspensionBuffer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,ResuspensionBuffer,"ResuspensionBuffer should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					ResuspensionBuffer->Model[Sample, "RO Water"],
					Output->Options
				],
				ResuspensionBuffer
			],
			ObjectP[Model[Sample, "RO Water"]],
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:ResuspensionVolume*)
		Example[{Options,ResuspensionVolume,"ResuspensionVolume allows specification of the volume of resuspension buffer that should be used to resuspend the PNA strands after cleavage from the resin:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False,False,True},
					ResuspensionVolume->{800 Microliter,Null,Automatic,Automatic},
					Output->Options
				],
				ResuspensionVolume
			],
			{800 Microliter,Null,Null,GreaterEqualP[1 Milliliter]},
			TimeConstraint->180
		],
		Example[{Messages,ResuspensionVolume,"ResuspensionVolume cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					ResuspensionVolume->Null,
					Output->Options
				],
				ResuspensionVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,ResuspensionVolume,"ResuspensionVolume should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					ResuspensionVolume->1 Milliliter,
					Output->Options
				],
				ResuspensionVolume
			],
			1 Milliliter,
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:NumberOfResuspensionMixes*)
		Example[{Options,NumberOfResuspensionMixes,"NumberOfResuspensionMixes allows specification number of times the resuspension buffer with the pellet should be mixed before transferring it to the final container:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{True,False,False,True},
					NumberOfResuspensionMixes->{4,Null,Automatic,Automatic},
					Output->Options
				],
				NumberOfResuspensionMixes
			],
			{4,Null,Null,10},
			TimeConstraint->180
		],

	(*NOTE:ResuspensionMixTime*)
		Example[{Options,ResuspensionMixTime,"ResuspensionMixTime allows specification of the duration that the cleaved and pelleted peptides should be mixed in resuspension buffer if mixing by sonication or vortexing:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{False,True,False,True},
					ResuspensionMixTime->{Null,5*Minute,Automatic,Automatic},
					ResuspensionMixType->{Null,Sonicate,Automatic,Automatic},
					Output->Options
				],
				{ResuspensionMixTime,ResuspensionMixType}
			],
			{{Null,5*Minute,Null,Null},{Null, Sonicate, Null, Pipette}},
			TimeConstraint->180
		],

	(*NOTE:ResuspensionMixType*)
		Example[{Options,ResuspensionMixType,"ResuspensionMixType allows specification of the type of mixing (either Pipetting, or Vortexing, or Sonication) that should be performed to resuspend the cleaved and pelleted peptides in resuspension buffer prior to transfer in final container:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->True,
					ResuspensionMixType->{Pipette,Sonicate,Vortex},
					Output->Options
				],
				ResuspensionMixType
			],
			{Pipette, Sonicate, Vortex},
			TimeConstraint->200
		],

		Example[{Options,ResuspensionMixType,"Depending on the specified ResuspensionMixType, other resuspension mixing options such as NumberOfResuspensionMixes and ResuspensionMixTime are automatically set, if they are not provided:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->True,
					ResuspensionMixType->{Pipette,Sonicate,Vortex},
					NumberOfResuspensionMixes->{5,Automatic,Automatic},
					ResuspensionMixTime->{Automatic,Automatic,10*Minute},
					Output->Options
				],
				{ResuspensionMixTime,NumberOfResuspensionMixes,ResuspensionMixType}
			],
			{{Null,5*Minute,10*Minute},{5,Null,Null},{Pipette, Sonicate, Vortex}},
			TimeConstraint->200
		],
	(*NOTE:ResuspensionMixPrimitives*)
		Example[{Options,ResuspensionMixPrimitives,"If Cleavage->True, the exact steps for mixing of the cleaved, pelleted peptide strands can be provided in the form of primitives:"},
			First/@Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->True,
					ResuspensionMixPrimitives->{
						Mix[MixType -> Pipette,NumberOfMixes -> 20]
					},
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{<|MixType -> Pipette, NumberOfMixes -> 20|>},
			TimeConstraint->200
		],
		Example[{Options,ResuspensionMixPrimitives,"When providing primitives for mixing of the cleaved, pelleted peptide strands in resuspension buffer, several mixing steps can be defined sequentially (for example, pipetting up and down 20 times, then vortexing for 5 minutes followed by sonication for 5 minutes:"},
			First/@Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->True,
					ResuspensionMixPrimitives->{
						Mix[MixType -> Pipette,NumberOfMixes -> 20],
						Mix[MixType -> Vortex,Time->5*Minute],
						Mix[MixType -> Sonicate,Time->10*Minute]
					},
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{<|MixType -> Pipette, NumberOfMixes -> 20|>,<|MixType -> Vortex, Time -> 5*Minute|>,<|MixType -> Sonicate, Time -> 10*Minute|>},
			TimeConstraint->200
		],
		Example[{Options,ResuspensionMixPrimitives,"Resuspension mix primitives can be provided for each strand separately (for example, the first strand can be mixed by pipetting, while the second strand is vortexed):"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->True,
					ResuspensionMixPrimitives->
							{
							(* mixing of the first strand *)
								{Mix[MixType->Pipette,NumberOfMixes->20]},
							(* mixing of the second strand *)
								{Mix[MixType->Vortex,Time->5*Minute],Mix[MixType->Sonicate,Time->6*Minute]}
							},
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{
				{
					Mix[Association[Rule[MixType,Pipette],Rule[NumberOfMixes,20]]]
				},
				{
					Mix[Association[Rule[MixType,Vortex],Rule[Time,Quantity[5,"Minutes"]]]],
					Mix[Association[Rule[MixType,Sonicate],Rule[Time,Quantity[6,"Minutes"]]]]
				}
			},
			TimeConstraint->200
		],
		Example[{Options,ResuspensionMixPrimitives,"ResuspensionMixPrimitives is automatically set to Mix by pipetting (10 times), if Cleavage->True, otherwise, is set to Null:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Cleavage->{False,True},
					ResuspensionMixPrimitives-> Automatic,
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{Null,{Mix[Association[Rule[MixType,Pipette],Rule[NumberOfMixes,10]]]}},
			TimeConstraint->200
		],

	(* MESSAGES *)
		Example[{Messages,"UnneededCleavageOptions","ResuspensionMixType should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[{Model[Sample,"PNA Test Oligomer Model"],Model[Sample,"PNA Test Oligomer Model"]},
					Cleavage->{False,True},
					ResuspensionMixType->{Vortex,Vortex},
					Output->Options
				],
				ResuspensionMixType
			],
			{Vortex,Vortex},
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnneededCleavageOptions","ResuspensionMixPrimitives should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[{Model[Sample,"PNA Test Oligomer Model"],Model[Sample,"PNA Test Oligomer Model"]},
					Cleavage->{False,True},
					ResuspensionMixPrimitives-> {Mix[MixType->Pipette,NumberOfMixes->20]},
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{Null,{Mix[Association[Rule[MixType,Pipette],Rule[NumberOfMixes,20]]]}},
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnneededResuspensionOptions","ResuspensionMixPrimitives and resuspension mixing options cannot be defined simultaneously:"},
			Lookup[
				ExperimentPNASynthesis[{Model[Sample,"PNA Test Oligomer Model"],Model[Sample,"PNA Test Oligomer Model"]},
					Cleavage->True,
					ResuspensionMixPrimitives-> {Mix[MixType->Pipette,NumberOfMixes->20]},
					ResuspensionMixType->{Pipette,Pipette},
					Output->Options
				],
				ResuspensionMixType
			],
			{Pipette,Pipette},
			Messages:>{Message[Error::UnneededResuspensionOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,"IncompatibleResuspensionMixPrimitives","Returns an error if resuspension mixing primitives are not properly defined:"},
			Lookup[
				ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					ResuspensionMixPrimitives-> {Mix[MixType->Vortex,NumberOfMixes->20]},
					Output->Options
				],
				ResuspensionMixPrimitives
			],
			{Mix[Association[Rule[MixType,Vortex],Rule[NumberOfMixes,20]]]},
			Messages:>{
				Message[Error::MixTypeNumberOfMixesMismatch],
				Message[Error::MixTypeIncorrectOptions],
				Message[Error::IncompatibleResuspensionMixPrimitives],
				Message[Error::InvalidOption]
			}
		],
		(* UP TODO *)

	(*NOTE: other options *)
		Example[{Options,Scale,"Scale allows specification of the scale at which the oligomers should be synthesized:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Scale->{5 Micromole, 15 Micromole},
					Output->Options
				],
				Scale
			],
			{5 Micromole, 15 Micromole}
		],
		Example[{Options,TargetLoading,"TargetLoading allows specification target loading of the resin that should be used for the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					TargetLoading->{70 (Micromole/Gram), 110 (Micromole/Gram)},
					Output->Options
				],
				TargetLoading
			],
			{70 (Micromole/Gram), 110 (Micromole/Gram)}
		],
		Example[{Options,DownloadResin,"Resin specifies if undownloaded resin should be used and resin download should be performed as the first cycle of the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"]},
					Output->Options
				],
				DownloadResin
			],
			{True,False}
		],

		Example[{Options,Resin,"Resin specifies the model or sample object of resin that should be used as the solid support for the synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,False},
					Resin->{Automatic,Model[Sample,"PNA Test Downloaded Resin"]},
					Output->Options
				],
				DownloadResin
			],
			{True,False}
		],

		(*NOTE: extra steps option switches *)
		Example[{Options,DoubleCoupling,"DoubleCoupling specifies at which cycles the coupling is repeated twice using freshly activated monomer:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DoubleCoupling->{12,Null},
					Output->Options
				],
				DoubleCoupling
			],
			{12,Null}
		],
		Example[{Options,InitialCapping,"InitialCapping specifies if an initial capping step should be done before the synthesis of the strand begins:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					DownloadResin->{True,True,True,False},
					Resin->{Automatic,Automatic,Automatic,Model[Sample,"PNA Test Downloaded Resin"]},
					InitialCapping->{True,False,Automatic,Automatic},
					Output->Options
				],
				InitialCapping
			],
			{True,False,False,True},
			TimeConstraint -> 120
		],
		Example[{Options,FinalCapping,"FinalCapping specifies if a final capping step should be done as part of the last synthesis cycle before the start of cleavage or resin storage:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					FinalCapping->{True,False},
					Output->Options
				],
				FinalCapping
			],
			{True,False}
		],
		Example[{Options,InitialDeprotection,"InitialDeprotection specifies if an initial deprotection step should be done as part of resin download:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					InitialDeprotection->{True,False},
					Output->Options
				],
				InitialDeprotection
			],
			{True,False}
		],
		Example[{Options,FinalDeprotection,"FinalDeprotection specifies if a final deprotection step should be done as part of the last synthesis cycle prior to the start of cleavage or resin storage:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					FinalDeprotection->{True,False},
					Output->Options
				],
				FinalDeprotection
			],
			{True,False}
		],

		(* Note: Resin Swell*)
		Example[{Options,SwellResin,"SwellResin indicates that the resin should be swelled using SwellSolution before the start of a synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->{True,False},
					Output->Options
				],
				SwellResin
			],
			{True,False}
		],
		Example[{Options,SwellSolution,"SwellSolution allows specification of model or sample object that should be used to swell the resin prior to the start of the synthesis or resin download:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->True,
					SwellSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SwellSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Messages,SwellSolution,"SwellSolution should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->False,
					SwellSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SwellSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededSwellOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,SwellTime,"SwellTime allows specification of the amount of time that the resin is swelled for (per cycle):"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->{True,False,False,True},
					SwellTime->{12 Minute, Null,Automatic, Automatic},
					Output->Options
				],
				SwellTime
			],
			{12 Minute,Null,Null,TimeP},
			TimeConstraint->180
		],
		Example[{Messages,SwellTime,"SwellTime should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SwellResin->False,
					SwellTime->12 Minute,
					Output->Options
				],
				SwellTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededSwellOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,SwellVolume,"SwellVolume allows specification the volume of SwellSolution that the samples are swelled with:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->{True,False,True},
					SwellVolume->{2.5 Milliliter,Automatic,Automatic},
					Output->Options
				],
				SwellVolume
			],
			{2.5 Milliliter, Null, 10 Milliliter},
			TimeConstraint->180
		],
		Example[{Messages,SwellVolume,"SwellVolume should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SwellResin->False,
					SwellVolume->2.5 Milliliter,
					Output->Options
				],
				SwellVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededSwellOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,NumberOfSwellCycles,"NumberOfSwellCycles allows specification of the number of the cycles of swelling of the resin before the start of a synthesis:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->{True,False,True},
					NumberOfSwellCycles->{7,Automatic, Automatic},
					Output->Options
				],
				NumberOfSwellCycles
			],
			{7,Null,3},
			TimeConstraint->180
		],
		Example[{Messages,NumberOfSwellCycles,"NumberOfSwellCycles should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SwellResin->False,
					NumberOfSwellCycles->7,
					Output->Options
				],
				NumberOfSwellCycles
			],
			7,
			Messages:>{Message[Error::UnneededSwellOptions],Message[Error::InvalidOption]}
		],

		(* Note: Primary/SecondaryResinShrink *)
		Example[{Options,PrimaryResinShrink,"PrimaryResinShrink specifies if the resin is shrunk with primary shrink solution prior to strand cleavage or storage:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					PrimaryResinShrink->{True,False},
					Output->Options
				],
				PrimaryResinShrink
			],
			{True,False},
			TimeConstraint->180
		],
		Example[{Options,SecondaryResinShrink,"SecondaryResinShrink specifies if the resin is shrunk with a secondary shrink solution prior to strand cleavage or storage::"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SecondaryResinShrink->{True,False},
					Output->Options
				],
				SecondaryResinShrink
			],
			{True,False},
			TimeConstraint->180
		],

		(*NOTE: Primary/SecondaryResinShrinkSolution*)
		Example[{Options,PrimaryResinShrinkSolution,"PrimaryResinShrinkSolution allows specification of model or sample object that should be used to wash and dry the resin after last coupling step:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					PrimaryResinShrink->{True,False},
					PrimaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{PrimaryResinShrink,PrimaryResinShrinkSolution}
			],
			{
				{True,False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			},
			TimeConstraint->180
		],
		Example[{Messages,PrimaryResinShrinkSolution,"PrimaryResinShrinkSolution cannot be set to Null, if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->True,
					PrimaryResinShrinkSolution->Null,
					Output->Options
				],
				PrimaryResinShrinkSolution
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,PrimaryResinShrinkSolution,"PrimaryResinShrinkSolution should only be specified if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->False,
					PrimaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				PrimaryResinShrinkSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,SecondaryResinShrinkSolution,"SecondaryResinShrinkSolution allows specification of model or sample object that should be used to wash and dry the resin after last coupling step:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SecondaryResinShrink->{True,False},
					SecondaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{SecondaryResinShrink,SecondaryResinShrinkSolution}
			],
			{
				{True,False},
				ObjectP[Model[Sample, "Milli-Q water"]]
			},
			TimeConstraint->180
		],
		Example[{Messages,SecondaryResinShrinkSolution,"SecondaryResinShrinkSolution cannot be set to Null, if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->True,
					SecondaryResinShrinkSolution->Null,
					Output->Options
				],
				SecondaryResinShrinkSolution
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,SecondaryResinShrinkSolution,"SecondaryResinShrinkSolution should only be specified if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->False,
					SecondaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SecondaryResinShrinkSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],


		(*NOTE:Primary/SecondaryResinShrinkWashTime*)
		Example[{Options,PrimaryResinShrinkTime,"PrimaryResinShrinkTime allows specification of the duration of the resin shrink wash at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					PrimaryResinShrink->{True,True,False},
					PrimaryResinShrinkTime->{12 Minute,Automatic,Null},
					Output->Options
				],
				PrimaryResinShrinkTime
			],
			{12 Minute,TimeP,Null},
			TimeConstraint->180
		],
		Example[{Messages,PrimaryResinShrinkTime,"PrimaryResinShrinkTime cannot be set to Null, if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->True,
					PrimaryResinShrinkTime->Null,
					Output->Options
				],
				PrimaryResinShrinkTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,PrimaryResinShrinkTime,"PrimaryResinShrinkTime should only be specified if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->False,
					PrimaryResinShrinkTime->12 Minute,
					Output->Options
				],
				PrimaryResinShrinkTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}		],

		Example[{Options,SecondaryResinShrinkTime,"SecondaryResinShrinkTime allows specification of the duration of the second resin shrink wash at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SecondaryResinShrink->{True,True,False},
					SecondaryResinShrinkTime->{12 Minute,Automatic,Null},
					Output->Options
				],
				SecondaryResinShrinkTime
			],
			{12 Minute,TimeP,Null},
			TimeConstraint->180
		],
		Example[{Messages,SecondaryResinShrinkTime,"SecondaryResinShrinkTime cannot be set to Null, if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->True,
					SecondaryResinShrinkTime->Null,
					Output->Options
				],
				SecondaryResinShrinkTime
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,SecondaryResinShrinkTime,"SecondaryResinShrinkTime should only be specified if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->False,
					SecondaryResinShrinkTime->12 Minute,
					Output->Options
				],
				SecondaryResinShrinkTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:Primary/SecondaryResinShrinkVolume*)
		Example[{Options,PrimaryResinShrinkVolume,"PrimaryResinShrinkVolume allows specification of the volume of primary shrink solution that should be used to wash the resin at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					PrimaryResinShrink->{True,True,False},
					PrimaryResinShrinkVolume->{15 Milliliter,Automatic,Null},
					Output->Options
				],
				PrimaryResinShrinkVolume
			],
			{15 Milliliter,VolumeP,Null},
			TimeConstraint->180
		],
		Example[{Messages,PrimaryResinShrinkVolume,"PrimaryResinShrinkVolume cannot be set to Null, if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->True,
					PrimaryResinShrinkVolume->Null,
					Output->Options
				],
				PrimaryResinShrinkVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,PrimaryResinShrinkVolume,"PrimaryResinShrinkVolume should only be specified if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->False,
					PrimaryResinShrinkVolume->15 Milliliter,
					Output->Options
				],
				PrimaryResinShrinkVolume
			],
			15 Milliliter,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,SecondaryResinShrinkVolume,"SecondaryResinShrinkVolume allows specification of the volume of secondary shrink resolution that should be used to wash the resin at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SecondaryResinShrink->{True,True,False},
					SecondaryResinShrinkVolume->{15 Milliliter,Automatic,Null},
					Output->Options
				],
				SecondaryResinShrinkVolume
			],
			{15 Milliliter,VolumeP,Null},
			TimeConstraint->180
		],
		Example[{Messages,SecondaryResinShrinkVolume,"SecondaryResinShrinkVolume cannot be set to Null, if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->True,
					SecondaryResinShrinkVolume->Null,
					Output->Options
				],
				SecondaryResinShrinkVolume
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,SecondaryResinShrinkVolume,"SecondaryResinShrinkVolume should only be specified if SecondaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					SecondaryResinShrink->False,
					SecondaryResinShrinkVolume->15 Milliliter,
					Output->Options
				],
				SecondaryResinShrinkVolume
			],
			15 Milliliter,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		(*NOTE:RecoupMonomers*)
		Example[{Options,RecoupMonomers,"RecoupMonomers specifies if any left over monomer solutions should be stored or discarded at the conclusion of a synthesis:"},
			Lookup[ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				RecoupMonomers->True,
				Output->Options
			],RecoupMonomers],
			True,
			TimeConstraint->180
		],
	(*NOTE:MonomerPreactivation*)
		Example[{Options,MonomerPreactivation,"Specify that preactivation of the monomers should happen ex situ (in a separate reaction vessel):"},
			Lookup[ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				MonomerPreactivation->ExSitu,
				Output->Options
			],MonomerPreactivation],
			ExSitu,
			TimeConstraint->180
		],

	(*NOTE: shared options *)
		Example[{Options,Name, "An object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					Name->"This is a test of the protocol naming system",
					Output->Options
				],
				Name
			],
			"This is a test of the protocol naming system"
		],
		Example[{Options,Confirm,"Confirm specifies if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Confirm->True,
				Output->Options
			],
			_
		],
		Example[{Options,Upload,"Upload specifies if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Upload->False,
				Output->Options
			],
			_
		],
		Example[{Options,FastTrack,"FastTrack specifies if validity checks on the provided input and options should be skipped for faster performance:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				FastTrack->True,
				Output->Options
			],
			_
		],
		Example[{Options,Email,"Email specifies if emails should be sent for any notifications relevant to the function's output:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Email->False,
				Output->Options
			],
			_
		],
		Example[{Options,ParentProtocol,"ParentProtocol specifies the protocol which is directly generating this experiment during execution:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				ParentProtocol->Object[Protocol, PNASynthesis, "PNA Test Parent Protocol"],
				Output->Options
			],
			_
		],
		Example[{Options,Cache,"Cache takes in a list of pre-downloaded packets that should be used before checking for session cached object or downloading any object information from the server:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Cache->{},
				Output->Options
			],
			_
		],
		Example[{Options,Template,"A template protocol whose methodology should be reproduced in running this experiment. Option values should be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Template->Object[Protocol, PNASynthesis, "PNA Test Template Protocol"],
				Output->Options
			],
			_
		],
		Example[{Options,Output,"Output specifies what the function should return:"},
			ExperimentPNASynthesis[
				{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				},
				Output->Options
			],
			_List
		],
		Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition allows specification of the non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples should be stored according to their Models' DefaultStorageCondition:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SamplesOutStorageCondition->{AmbientStorage,DeepFreezer},
					Output->Options
				],
				SamplesOutStorageCondition
			],
			{AmbientStorage,DeepFreezer}
		],
		(* MESSAGES GENERAL *)

		Example[{Messages,"TooManyMonomers", "Throws an error if a strand is being synthesized that requires more monomers than fit on the deck:"},
			ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model with crazy lots of non-default monomers"],
				Monomers-> {
					{Peptide["Tyr"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Tyr] Solution"]},
					{Peptide["Val"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Val] Solution"]},
					{Peptide["Ile"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Ile] Solution"]},
					{Peptide["Ala"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Ala] Solution"]},
					{Peptide["Met"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Met] Solution"]},
					{Peptide["His"], Model[Sample, StockSolution, "PNA Test Peptide Stock[His] Solution"]},
					{Peptide["Thr"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Thr] Solution"]},
					{Peptide["Ser"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Ser] Solution"]},
					{Peptide["Pro"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Pro] Solution"]},
					{Peptide["Trp"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Trp] Solution"]},
					{Peptide["Arg"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Arg] Solution"]},
					{Peptide["Asp"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Asp] Solution"]},
					{Peptide["Asn"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Asn] Solution"]},
					{Peptide["Glu"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Glu] Solution"]},
					{Peptide["Gly"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Gly] Solution"]},
					{Peptide["Gln"], Model[Sample, StockSolution, "PNA Test Peptide Stock[Gln] Solution"]}
				}
			],
			$Failed,
			Messages:>{Message[Error::TooManyMonomers]},
			TimeConstraint->200
		],

		Example[{Messages,"PolymerType", "Throws an error if a strand of a type other than PNA is being synthesized:"},
			ExperimentPNASynthesis[Model[Sample,"DNA Test Oligomer Model"]],
			$Failed,
			Messages:>{
				Message[Error::PolymerType],
				Message[Error::UnknownDownloadMonomer],
				Message[Error::UnknownMonomer],
				Message[Error::InvalidOption],
				Message[Error::InvalidInput]
			}
		],

		Example[{Messages,"NumberOfInputs","Throws an error if the number of oligomer(s) being synthesized in one protocol is outside the capability of the instrument:"},
				ExperimentPNASynthesis[{
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"],
					Model[Sample,"PNA Test Oligomer Model"]
				}],
			$Failed,
			Messages:>{Message[Error::NumberOfInputs],Message[Error::InvalidInput]},
			TimeConstraint->400
		],

		Example[{Messages,"InsufficientSolventVolume","Throws an error if we use more of a solvent than fits into the solvent container under the deck:"},
			Lookup[
				ExperimentPNASynthesis[{
					Model[Sample,"PNA Test Oligomer Model Superlong"],
					Model[Sample,"PNA Test Oligomer Model Superlong"],
					Model[Sample,"PNA Test Oligomer Model Superlong"]
				},
					WashVolume->18*Milliliter,
					Output->Options
				],
				WashVolume
			],
			18*Milliliter,
			Messages:>{Message[Error::InsufficientSolventVolume]},
			TimeConstraint->180
		],

		Example[{Messages,"UnneededSwellOptions","Swell related options should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					{
						Model[Sample,"PNA Test Oligomer Model"],
						Model[Sample,"PNA Test Oligomer Model"]
					},
					SwellResin->False,
					SwellSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SwellSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededSwellOptions],Message[Error::InvalidOption]}
		],

		Example[{Messages,"UnneededCleavageOptions","Cleavage related otpions should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->False,
					CleavageSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				CleavageSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededCleavageOptions],Message[Error::InvalidOption]}
		],

		Example[{Messages,"UnneededStorageOptions","Storage related options cannot be set to Null, if Cleavage has been set to False:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					Cleavage->True,
					StorageBuffer->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				StorageBuffer
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededStorageOptions],Message[Error::InvalidOption]}
		],

		Example[{Messages,"UnneededShrinkOptions","PrimaryResinShrink related options should only be specified if PrimaryResinShrink has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					PrimaryResinShrink->False,
					PrimaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				PrimaryResinShrinkSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		Example[{Messages,"UnneededDeprotonationOptions","Deprotonation related options should only be specified if DownloadResin or Deprotonation has been set to True:"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Deprotonation->False,
					DeprotonationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{False,False,ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnknownDownloadMonomer","DownloadMonomer automatic resolution will fail when a novel download monomer is used and therefore must explicity specified:"},
			Lookup[
				ExperimentPNASynthesis[
					StrandJoin[
						ToStrand[PNA["AGCTAATGA"]],
						ToStrand[Peptide["Pyl"]]
					],
					DownloadResin->True,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::UnknownDownloadMonomer],Message[Error::InvalidOption]}
		],
			Example[{Messages,"WrongResin","If DownloadResin is set to True, Resin cannot be specified to a downloaded resin (Object/Model[Sample]) since the first step in the synthesis will be the download of the resin:"},
			ExperimentPNASynthesis[
				Model[Sample,"PNA Test Oligomer Model"],
				DownloadResin->True,
				Resin->Model[Sample, "PNA Test Downloaded Resin"]
			],
			$Failed,
			Messages:>{Message[Error::WrongResin],Message[Error::InvalidOption]}
		],

		Example[{Messages,"ResinNeeded","If DownloadResin is set to False, an appropriate downloaded Resin has to be specified by the user via the Option Resin:"},
			ExperimentPNASynthesis[
				Model[Sample,"PNA Test Oligomer Model"],
				DownloadResin->False
			],
			$Failed,
			Messages:>{Message[Error::ResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,"DownloadedResinNeeded","If DownloadResin is set to False, the Resin specified by the user cannot be undownloaded:"},
			ExperimentPNASynthesis[
				Model[Sample,"PNA Test Oligomer Model"],
				DownloadResin->False,
				Resin->Model[Sample,"PNA Test Undownloaded Resin"]
			],
			$Failed,
			Messages:>{Message[Error::DownloadedResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,"MismatchedResinAndStrand","The specified downloaded Resin has to match the sequence of the 3' bases in the strand to be synthesized:"},
			ExperimentPNASynthesis[
				Model[Sample,"PNA Test Oligomer Model"],
				DownloadResin->False,
				Resin->Model[Sample, "PNA Test Downloaded Resin with Wrong Sequence"]
			],
			$Failed,
			Messages:>{Message[Error::MismatchedResinAndStrand],Message[Error::InvalidOption]}
		],


		Example[{Messages,"RequiredOption","Download related options cannot be set to Null, if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->True,
					DownloadMonomer->Null,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::UnknownDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnneededDownloadResinOptions","Download related options should only be specified if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPNASynthesis[
					Model[Sample,"PNA Test Oligomer Model"],
					DownloadResin->False,
					DownloadMonomer->Model[Sample,StockSolution, "PNA Test Monomer - A"],
					Resin->Model[Sample,"PNA Test Downloaded Resin"],
					Output->Options
				],
				DownloadMonomer
			],
			ObjectP[Model[Sample,StockSolution, "PNA Test Monomer - A"]],
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

	(* Resource packet function *)
		Module[{myProtocol},
			Test["The fields related to the download and synthesis cycle parameters are properly populated in the generated PNA protocol object:",
				myProtocol=ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model"]];
				Download[myProtocol,
					{
						Scale,
						TargetLoadings,
						RecoupMonomers,
						InitialCapping,
						FinalCapping,
						FinalDeprotection,
						Deprotonation,
						Cleavage,
						DownloadResins,
						SynthesisStrategy,
						RunTime,
						SwellResin,
						CleavageVolumes,
						CleavageTimes,
						NumbersOfCleavageCycles,
						SwellTimes,
						SwellVolumes,
						NumbersOfSwellCycles,
						PrimaryResinShrinks,
						PrimaryResinShrinkVolumes,
						PrimaryResinShrinkTimes,
						SecondaryResinShrinks,
						SecondaryResinShrinkVolumes,
						SecondaryResinShrinkTimes,
						NumbersOfResuspensionMixes,
						TriturationVolume,
						TriturationTime,
						TriturationTemperature,
						NumberOfTriturationCycles,
						TriturationCentrifugationTime,
						TriturationCentrifugationRate,
						TriturationCentrifugationForce,
						StorageVolumes,
						ResuspensionVolumes
					}
				],
				{
					{5.`Micromole},
					{0.00009`Mole/Gram},
					False,
					{False},
					{False},
					{True},
					{False},
					{True},
					{True},
					Fmoc,
					0.5`Day,
					{True},
					{5.`Milliliter},
					{30.`Minute},
					{3},
					{0.3333333333333333`Hour},
					{10.`Milliliter},
					{3},
					{True},
					{20.`Milliliter},
					{1.`Minute},
					{True},
					{20.`Milliliter},
					{1.`Minute},
					{10},
					35.`Milliliter,
					5.`Minute,
					-80.*Celsius,
					3,
					5.`Minute,
					3000.`Revolution/Minute,
					2050.`GravitationalAcceleration,
					{},
					{1.`Milliliter}
				}
			]
		],
		Module[{myProtocol},
			Test["The strand and synthesis cycle fields are properly populated in the generated PNA protocol object:",
				myProtocol=ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model"]];
				Download[myProtocol,
					{
						StrandModels,
						CleavedStrandModels,
						UncleavedStrandModels,
						DownloadedStrandModels
					}
				],
				{
					{ObjectP[Model[Sample]]},
					{ObjectP[Model[Sample]]},
					{},
					{ObjectP[Model[Sample]]}
				}
			]
		],
		Module[{myProtocol},
			Test["All the fields containing resources are properly populated in the generated PNA protocol object:",
				myProtocol=ExperimentPNASynthesis[Model[Sample,"PNA Test Oligomer Model"]];
				Download[myProtocol,
					{
						Resin,
						WashSolution,
						CappingSolution,
						DeprotectionSolution,
						DeprotonationSolution,

						ActivationSolution,
						DownloadActivationSolution,
						SwellSolution,
						CleavageSolution,
						PrimaryResinShrinkSolution,
						SecondaryResinShrinkSolution,
						TriturationSolution,
						SynthesisMonomers,
						DownloadMonomers,
						RecoupedMonomersContainers,

						Instrument,
						FumeHood,
						VacuumManifold,
						CollectionVessels,
						PreactivationVessels,
						Neutralizer,
						ReactionVessels,
						ReactionVesselRacks,
						UncleavedReactionVessels,
						CleavedReactionVessels,
						SeptumCaps,
						ReactionVesselStopcocks,
						StorageSolution,
						ResuspensionBuffer,
						TriturationBeaker,
						CleaningSolutions
					}
				],
				{
					{ObjectP[Model[Sample]]},
					ObjectP[Model[Sample]],
					ObjectP[Model[Sample,StockSolution]],
					ObjectP[Model[Sample,StockSolution]],
					ObjectP[Model[Sample,StockSolution]],

					ObjectP[Model[Sample,StockSolution]],
					ObjectP[Model[Sample,StockSolution]],
					ObjectP[Model[Sample]],
					ObjectP[Model[Sample,StockSolution]],
					ObjectP[Model[Sample]],

					ObjectP[Model[Sample]],
					ObjectP[Model[Sample]],
					(* there are all 4 monomers required for the synthesis of the strand (excluding the download monomer) *)
					{ObjectP[Model[Sample,StockSolution]],ObjectP[Model[Sample,StockSolution]],ObjectP[Model[Sample,StockSolution]],ObjectP[Model[Sample,StockSolution]]},
					{ObjectP[Model[Sample,StockSolution]]},
					{},

					ObjectP[Model[Instrument,PeptideSynthesizer]],
					ObjectP[Model[Instrument,FumeHood]],
					Null,
					{ObjectP[Model[Container,Vessel]]},
					{ObjectP[Model[Container,ReactionVessel]]},

					ObjectP[Model[Sample]],
					{ObjectP[Model[Container,ReactionVessel]]},
					{ObjectP[Model[Container,Rack]]},
					{},
					{ObjectP[Model[Container,ReactionVessel]]},

					{ObjectP[Model[Item,Cap]]..},
					{ObjectP[Model[Item,Consumable]]},
					Null,
					ObjectP[Model[Sample]],
					ObjectP[Model[Container,Vessel]],

					{ObjectP[Model[Sample]]..}
				}
			]
		]
	},
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{createdObjects,existsFilter},
			createdObjects={
				Model[Sample,"PNA Test Oligomer Model"],
				Model[Sample,"PNA Test Oligomer Model Superlong"],
				Model[Sample,"PNA Test Oligomer Model with crazy lots of non-default monomers"],
				Model[Sample,"PNA Test Oligomer Model 1"],
				Model[Sample,"PNA Test Oligomer Model 2"],
				Model[Sample,"PNA Test Oligomer Model 3"],
				Model[Sample,"DNA Test Oligomer Model"],
				Model[Sample,"PNA Test Oligomer Model with novel monomers"],
				Model[Sample,"PNA Test Oligomer Model with novel download monomer"],
				Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer"],
				Object[User, Emerald, "PNA Test Operator"],
				Object[Protocol,PNASynthesis,"PNA Test Template Protocol"],
				Object[Protocol,PNASynthesis,"PNA Test Parent Protocol"],
				Model[Sample,"PNA Test Undownloaded Resin"],
				Model[Sample,"PNA Test Downloaded Resin"],
				Model[Sample,"PNA Test Downloaded Resin with Wrong Sequence"],
				Model[Sample,"PNA Test Oligomer For Resin"],
				Model[Sample,"PNA Test Oligomer For Wrong Resin"],
				Model[Sample,StockSolution,"PNA Test Monomer - A"],
				Model[Sample,StockSolution,"PNA Test Monomer - T"],
				Object[Product,"PNA Test Product for Downloaded Resin"],
				Object[Sample,"PNA Test Downloaded Resin Sample"],
				Model[Sample,"PNA Test TriturationSolution"],
				Object[Product,"PNA Test Product for TriturationSolution"],
				Model[Sample,StockSolution,"PNA Test GammLeftPNA[A] Stock Solution"],
				Model[Sample,StockSolution,"PNA Test GammLeftPNA[T] Stock Solution"],
				Model[Sample,StockSolution,"PNA Test GammLeftPNA[C] Stock Solution"],
				Model[Sample,StockSolution,"PNA Test GammLeftPNA[G] Stock Solution"],
				Model[Sample,"AGCTAA"],
				Model[Sample,"AGGGGCTAATG"],
				Model[Sample,"AGCTAAT"],
				Model[Sample,"AGCTAATG"],
				Model[Sample,"AGCTAATGC"],
				Model[Sample,"Tyr"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Tyr] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Val] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Ile] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Ala] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Met] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[His] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Thr] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Ser] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Pro] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Trp] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Arg] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Asp] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Asn] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Glu] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Gly] Solution"],
				Model[Sample,StockSolution,"PNA Test Peptide Stock[Gln] Solution"],
				Model[Molecule,Oligomer,"Test Oligomer for Molecule Input testing 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Oligomer for Molecule Input testing 2"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Oligomer for Molecule Input testing 3"<>$SessionUUID],
				Model[Molecule,Oligomer,"ATCGATCG"<>$SessionUUID],
				Model[Molecule,Oligomer,"ATCGG"<>$SessionUUID],
				Model[Molecule,Oligomer,"ATCGATCGATCGATCGATCG"<>$SessionUUID],
				Model[Molecule,Oligomer,"ATTCG"<>$SessionUUID],
				Model[Molecule,Oligomer,"ATTTCG"<>$SessionUUID],
				Model[Molecule,Oligomer,"DNA ATTTCG"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Oligomer with novel monomer"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Oligomer with crazy monomers"<>$SessionUUID],
				Model[Molecule,Oligomer,"Test Oligomer with novel download monomer"<>$SessionUUID],
				Model[Molecule,Oligomer,"G"<>$SessionUUID],
				Model[Molecule,Oligomer,"A"<>$SessionUUID],
				Model[Sample, "Test Oligomer for Molecule Input testing 2"<>$SessionUUID],
				Model[Resin,SolidPhaseSupport,"PNA Test Resin SPS G"],
				Model[Resin,SolidPhaseSupport,"PNA Test Resin SPS A"],
				Model[Resin,"PNA Test Resin"],
				Model[Sample,"Test Oligomer for Molecule Input testing 3"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[createdObjects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[createdObjects,existsFilter],
				Force->True,
				Verbose->False
			]]
		];

		Module[{identityATCGATCG,identityATCGG,identityModelSuperLong,identityATTCG,identityATTTCG,
			identityATCGDNA,identityNovel,identityCrazy,identityNovelDownload,
			identityForResin,identityForResinWrong,identityForInput1,
			identityForInput2,identityForInput3,identityResinWithMonomer,
			identityResinWithWrongMonomer,identityResin,
			uploadOligomerModels,uploadResins,uploadSamples
		},

		(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identityATCGATCG,
				identityATCGG,
				identityModelSuperLong,
				identityATTCG,
				identityATTTCG,
				identityATCGDNA,
				identityNovel,
				identityCrazy,
				identityNovelDownload,
				identityForResin,
				identityForResinWrong,
				identityForInput1,
				identityForInput2,
				identityForInput3
			}=MapThread[Function[{newStructure,newPolymerType,newName},
				If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
					UploadOligomer[
						newStructure,
						newPolymerType,
						newName,
						Upload->True
					],
					Model[Molecule,Oligomer,newName]
				]
			],
				{
					{
						ToStructure[PNA["ATCGATCG"]],
						ToStructure[PNA["ATCGG"]],
						ToStructure[PNA["ATCGATCGATCGATCGATCG"]],
						ToStructure[PNA["ATTCG"]],
						ToStructure[PNA["ATTTCG"]],
						ToStructure[DNA["ATTTCG"]],
						ToStructure[{Strand[GammaLeftPNA["ATC"],PNA["G"]]}],
						ToStructure[
							{Strand[
								GammaLeftPNA["ATCG"],
								PNA["ATCG"],
								GammaRightPNA["ATCG"],
								Peptide["TyrValIleAlaMetHisThrSerProTrpArgAspAsnGluGlyHisGln"],
								Modification["5'-Azidopentyl"],
								Modification["Biotin"],
								Modification["Biocytin"]
							]}],
						ToStructure[{Strand[PNA["ATC"],GammaLeftPNA["G"]]}],
						ToStructure[PNA["G"]],
						ToStructure[PNA["A"]],
						ToStructure[PNA["TTTTT"]],
						ToStructure[PNA["AAAAA"]],
						ToStructure[PNA["GGGGG"]]
					},
					{PNA,PNA,PNA,PNA,PNA,DNA,PNA,PNA,PNA,PNA,PNA,PNA,PNA,PNA},
					{"ATCGATCG"<>$SessionUUID,"ATCGG"<>$SessionUUID,"ATCGATCGATCGATCGATCG"<>$SessionUUID,"ATTCG"<>$SessionUUID,"ATTTCG"<>$SessionUUID,"DNA ATTTCG"<>$SessionUUID,"Test Oligomer with novel monomer"<>$SessionUUID,
						"Test Oligomer with crazy monomers"<>$SessionUUID,"Test Oligomer with novel download monomer"<>$SessionUUID,"G"<>$SessionUUID,"A"<>$SessionUUID,
						"Test Oligomer for Molecule Input testing 1"<>$SessionUUID,
						"Test Oligomer for Molecule Input testing 2"<>$SessionUUID,
						"Test Oligomer for Molecule Input testing 3"<>$SessionUUID
					}
				}];

			{identityResinWithMonomer,identityResinWithWrongMonomer,identityResin}=Upload[{
				Association[Name -> "PNA Test Resin SPS G", DeveloperObject -> True, Type -> Model[Resin, SolidPhaseSupport], State -> Liquid, Strand-> Link[identityForResin]],
				Association[Name -> "PNA Test Resin SPS A", DeveloperObject -> True, Type -> Model[Resin, SolidPhaseSupport], State -> Liquid, Strand->Link[identityForResinWrong]],
				Association[Name -> "PNA Test Resin", DeveloperObject -> True, Type -> Model[Resin], State -> Liquid] (* we don't have a Strand *)
			}];

			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PNA Test Oligomer Model", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCGATCG]}}],
				Association[Name->"PNA Test Oligomer Model Superlong", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityModelSuperLong]}}],
				Association[Name->"PNA Test Oligomer Model 1", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCGG]}}],
				Association[Name->"PNA Test Oligomer Model 2", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTCG]}}],
				Association[Name->"PNA Test Oligomer Model 3", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTTCG]}}],
				Association[Name->"DNA Test Oligomer Model",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCGDNA]}}],
				Association[Name->"PNA Test Oligomer Model with novel monomers",DeveloperObject->True,Type->Model[Sample], State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityNovel]}}],
				Association[Name->"PNA Test Oligomer Model with crazy lots of non-default monomers",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityCrazy]}}],
				Association[Name->"PNA Test Peptide Stock[Tyr] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Val] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Ile] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Ala] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Met] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[His] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Thr] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Ser] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Pro] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Trp] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Arg] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Asp] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Asn] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Glu] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Gly] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Peptide Stock[Gln] Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Oligomer Model with novel download monomer",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityNovelDownload]}}],
				Association[Name->"Test PeptideSynthesizer",DeveloperObject->True,Type->Model[Instrument,PeptideSynthesizer],DeadVolume->15*Milliliter],
				Association[Name->"PNA Test Operator",DeveloperObject->True,Type->Object[User, Emerald]],
				Association[Name->"PNA Test Template Protocol",DeveloperObject->True,Type->Object[Protocol, PNASynthesis]],
				Association[Name->"PNA Test Parent Protocol",DeveloperObject->True,Type->Object[Protocol, PNASynthesis]],
				Association[Name->"PNA Test Oligomer For Resin",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityForResin]}}],
				Association[Name->"PNA Test Oligomer For Wrong Resin",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityForResinWrong]}}],
				Association[Name->"PNA Test Monomer - A",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test Monomer - T",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test TriturationSolution",DeveloperObject->True,Type->Model[Sample]],
				Association[Name->"PNA Test GammLeftPNA[A] Stock Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test GammLeftPNA[T] Stock Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test GammLeftPNA[C] Stock Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"PNA Test GammLeftPNA[G] Stock Solution",DeveloperObject->True,Type->Model[Sample,StockSolution]]
			}];
			(* upload download resin samples based on the strandmodels created above *)
			uploadResins=Upload[{
				Association[Name->"PNA Test Downloaded Resin",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResinWithMonomer]}}],
				Association[Name->"PNA Test Downloaded Resin with Wrong Sequence",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResinWithWrongMonomer]}}],
				Association[Name->"PNA Test Undownloaded Resin",DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResin]}}]
			}];
			(* upload a sample and a product based on the download resin model created above *)
			uploadSamples=Upload[{
				Association[Name->"PNA Test Product for Downloaded Resin",DeveloperObject->True,Type->Object[Product],ProductModel->Link[Model[Sample,"PNA Test Downloaded Resin"],Products],EstimatedLeadTime->5*Day],
				Association[Name->"PNA Test Product for TriturationSolution",DeveloperObject->True,Type->Object[Product],ProductModel->Link[Model[Sample,"PNA Test TriturationSolution"],Products],EstimatedLeadTime->5*Day],
				Association[Name->"PNA Test Downloaded Resin Sample",DeveloperObject->True,Type->Object[Sample],Model->Link[Model[Sample,"PNA Test Downloaded Resin"],Objects],Status->Liquid,Volume->20*Milliliter,Status->Available]
			}]
		];
	},
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force -> True,Verbose -> False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	}
];


(* ::Subsection::Closed:: *)
(* Sister functions *)


(* ::Subsubsection:: *)
(* ExperimentPNASynthesisOptions *)


DefineTests[
	ExperimentPNASynthesisOptions,
	{
		Example[{Basic, "Generate a table of resolved options for an ExperimentPNASynthesis call to synthesize a single strand:"},
			ExperimentPNASynthesisOptions[Model[Sample,"PNAOptions Test Oligomer Model"]],
			_Grid
		],
		Example[{Basic, "Generate a table of resolved options for an ExperimentPNASynthesis call to synthesize multiple strands:"},
			ExperimentPNASynthesisOptions[
				{
					Model[Sample,"PNAOptions Test Oligomer Model 1"],
					Model[Sample,"PNAOptions Test Oligomer Model 2"]
				}
			],
			_Grid
		],

		Example[
			{Options, OutputFormat, "Generate a list of resolved options for an ExperimentPNASynthesis call to synthesize multiple strands:"},
			ExperimentPNASynthesisOptions[
				{
					Model[Sample,"PNAOptions Test Oligomer Model 1"],
					Model[Sample,"PNAOptions Test Oligomer Model 2"]
				},
				OutputFormat->List
			],
			_?(MatchQ[
				Check[SafeOptions[ExperimentPNASynthesis, #], $Failed, {Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},

	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Module[{existsFilter,identityATCG,identityATTCG,identityATTTCG,uploadOligomerModels},

			$CreatedObjects={};
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PNAOptions Test Oligomer Model"],
					Model[Sample,"PNAOptions Test Oligomer Model 1"],
					Model[Sample,"PNAOptions Test Oligomer Model 2"]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PNAOptions Test Oligomer Model"],
						Model[Sample,"PNAOptions Test Oligomer Model 1"],
						Model[Sample,"PNAOptions Test Oligomer Model 2"],
						Model[Molecule,Oligomer,"ATCG for PNAOptions"],
						Model[Molecule,Oligomer,"ATTCG for PNAOptions"],
						Model[Molecule,Oligomer,"ATTTCG for PNAOptions"]

					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identityATCG,
				identityATTCG,
				identityATTTCG
			}=MapThread[Function[{newStructure,newPolymerType,newName},
				If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
					UploadOligomer[
						newStructure,
						newPolymerType,
						newName,
						Upload->True
					],
					Model[Molecule,Oligomer,newName]
				]
			],
				{
					{
						ToStructure[PNA["ATCG"]],
						ToStructure[PNA["ATTCG"]],
						ToStructure[PNA["ATTTCG"]]
					},
					{PNA,PNA,PNA},
					{"ATCG for PNAOptions","ATTCG for PNAOptions","ATTTCG for PNAOptions"}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PNAOptions Test Oligomer Model", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCG]}}],
				Association[Name->"PNAOptions Test Oligomer Model 1", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTCG]}}],
				Association[Name->"PNAOptions Test Oligomer Model 2", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTTCG]}}]
			}]
		]
	),
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force -> True,Verbose -> False];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];


(* ::Subsubsection:: *)
(*ExperimentPNASynthesisPreview*)

DefineTests[
	ExperimentPNASynthesisPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentPNASynthesis call to synthesize a single strand (will always be Null):"},
			ExperimentPNASynthesisPreview[Model[Sample,"PNAPreview Test Oligomer Model"]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentPNASynthesis call to synthesize multiple strand (will always be Null):"},
			ExperimentPNASynthesisPreview[
				{
					Model[Sample,"PNAPreview Test Oligomer Model 1"],
					Model[Sample,"PNAPreview Test Oligomer Model 2"]
				}
			],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentPeptideSynthesis call to synthesize multiple strands and specifying options (will always be Null):"},
			ExperimentPNASynthesisPreview[
				Model[Sample,"PNAPreview Test Oligomer Model"],
				DownloadResin->True
			],
			Null
		]
	},
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Module[{existsFilter,identityATCG,identityATTCG,identityATTTCG,uploadOligomerModels},

			$CreatedObjects={};
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PNAPreview Test Oligomer Model"],
					Model[Sample,"PNAPreview Test Oligomer Model 1"],
					Model[Sample,"PNAPreview Test Oligomer Model 2"],
					Model[Molecule,Oligomer,"ATCG for PNAPreview"],
					Model[Molecule,Oligomer,"ATTCG for PNAPreview"],
					Model[Molecule,Oligomer,"ATTTCG for PNAPreview"]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PNAPreview Test Oligomer Model"],
						Model[Sample,"PNAPreview Test Oligomer Model 1"],
						Model[Sample,"PNAPreview Test Oligomer Model 2"],
						Model[Molecule,Oligomer,"ATCG for PNAPreview"],
						Model[Molecule,Oligomer,"ATTCG for PNAPreview"],
						Model[Molecule,Oligomer,"ATTTCG for PNAPreview"]

					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identityATCG,
				identityATTCG,
				identityATTTCG
			}=MapThread[Function[{newStructure,newPolymerType,newName},
				If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
					UploadOligomer[
						newStructure,
						newPolymerType,
						newName,
						Upload->True
					],
					Model[Molecule,Oligomer,newName]
				]
			],
				{
					{
						ToStructure[PNA["ATCG"]],
						ToStructure[PNA["ATTCG"]],
						ToStructure[PNA["ATTTCG"]]
					},
					{PNA,PNA,PNA},
					{"ATCG for PNAPreview","ATTCG for PNAPreview","ATTTCG for PNAPreview"}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PNAPreview Test Oligomer Model", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCG]}}],
				Association[Name->"PNAPreview Test Oligomer Model 1", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTCG]}}],
				Association[Name->"PNAPreview Test Oligomer Model 2", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTTCG]}}]
			}]
		]
	),
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force -> True,Verbose -> False];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentPNASynthesisQ*)


DefineTests[
	ValidExperimentPNASynthesisQ,
	{
		Example[
			{Basic, "Validate an ExperimentPNASynthesis call to synthesize a single strand:"},
			ValidExperimentPNASynthesisQ[Model[Sample,"PNAValidQ Test Oligomer Model"]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentPNASynthesis call to synthesize multiple strands:"},
			ValidExperimentPNASynthesisQ[
				{
					Model[Sample,"PNAValidQ Test Oligomer Model 1"],
					Model[Sample,"PNAValidQ Test Oligomer Model 2"]
				}
			],
			True
		],
		Example[
			{Options, OutputFormat, "Validate an ExperimentPNASynthesis call to synthesize a single strand, returning an ECL Test Summary:"},
			ValidExperimentPNASynthesisQ[Model[Sample,"PNAValidQ Test Oligomer Model 1"], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentPNASynthesis call to synthesize a single strand, printing a verbose summary of tests as they are run:"},
			ValidExperimentPNASynthesisQ[Model[Sample,"PNAValidQ Test Oligomer Model 2"], Verbose->True],
			True,
			TimeConstraint->180
		]
	},
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		ValidObjectQ[x_]:=ConstantArray[True,Length[x]]
	},
	SymbolSetUp:>(
		Module[{existsFilter,identityATCG,identityATTCG,identityATTTCG,uploadOligomerModels},
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
			$CreatedObjects={};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PNAValidQ Test Oligomer Model"],
					Model[Sample,"PNAValidQ Test Oligomer Model 1"],
					Model[Sample,"PNAValidQ Test Oligomer Model 2"],
					Model[Molecule,Oligomer,"ATCG for PNAValidQ"],
					Model[Molecule,Oligomer,"ATTCG for PNAValidQ"],
					Model[Molecule,Oligomer,"ATTTCG for PNAValidQ"]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PNAValidQ Test Oligomer Model"],
						Model[Sample,"PNAValidQ Test Oligomer Model 1"],
						Model[Sample,"PNAValidQ Test Oligomer Model 2"],
						Model[Molecule,Oligomer,"ATCG for PNAValidQ"],
						Model[Molecule,Oligomer,"ATTCG for PNAValidQ"],
						Model[Molecule,Oligomer,"ATTTCG for PNAValidQ"]
					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identityATCG,
				identityATTCG,
				identityATTTCG
			}=MapThread[Function[{newStructure,newPolymerType,newName},
				If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
					UploadOligomer[
						newStructure,
						newPolymerType,
						newName,
						Upload->True
					],
					Model[Molecule,Oligomer,newName]
				]
			],
				{
					{
						ToStructure[PNA["ATCG"]],
						ToStructure[PNA["ATTCG"]],
						ToStructure[PNA["ATTTCG"]]
					},
					{PNA,PNA,PNA},
					{"ATCG for PNAValidQ","ATTCG for PNAValidQ","ATTTCG for PNAValidQ"}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PNAValidQ Test Oligomer Model", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATCG]}}],
				Association[Name->"PNAValidQ Test Oligomer Model 1", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTCG]}}],
				Association[Name->"PNAValidQ Test Oligomer Model 2", DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityATTTCG]}}]
			}]
		]
	),
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force -> True,Verbose -> False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	}
];




(* ::Subsection::Closed:: *)
(*Helpers*)


(* ::Subsubsection::Closed:: *)
(*partitionSynthesisMonomerVolumes*)


DefineTests[
	partitionSynthesisMonomerVolumes,
	{
		Test[
			"Test for partitionSynthesisMonomerVolumes for a PNASynthesis protocol:",
			partitionSynthesisMonomerVolumes[
				Table[
					{
						{
							Coupling[
								Monomer -> Model[Sample, "Milli-Q water"],
								MonomerVolume -> Quantity[1.`, "Milliliters"],
								Activator ->
										Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1, "Milliliters"],
								ActivationTime -> Quantity[10, "Minutes"],
								CouplingTime -> Quantity[60, "Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> True,
								NumberOfReplicates -> 1
							],
							Coupling[
								Monomer -> Model[Sample, "RO Water"],
								MonomerVolume -> Quantity[1.`, "Milliliters"],
								Activator ->
										Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1, "Milliliters"],
								ActivationTime -> Quantity[10, "Minutes"],
								CouplingTime -> Quantity[60, "Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> False,
								NumberOfReplicates -> 1
							],
							Coupling[
								Monomer -> Model[Sample, "Tap Water"],
								MonomerVolume -> Quantity[1.`, "Milliliters"],
								Activator ->
										Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1, "Milliliters"],
								ActivationTime -> Quantity[10, "Minutes"],
								CouplingTime -> Quantity[60, "Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> False,
								NumberOfReplicates -> 1
							]
						}
					},
					2
				],
				400 Milliliter,
				15 Milliliter
			],
			{
				{1, 1, False, "AA1", Quantity[17., "Milliliters"],Model[Sample, "RO Water"]},
				{2, 1, False, "AA1", Quantity[17., "Milliliters"],Model[Sample, "RO Water"]},
				{1, 2, False, "AA2", Quantity[17., "Milliliters"],Model[Sample, "Tap Water"]},
				{2, 2, False, "AA2", Quantity[17., "Milliliters"],Model[Sample, "Tap Water"]},
				{1, 0, True, "AA3", Quantity[1., "Milliliters"], Model[Sample, "Milli-Q water"]},
				{2, 0, True, "AA4", Quantity[1., "Milliliters"], Model[Sample, "Milli-Q water"]}
			}
		],
			Test["Test for partitionSynthesisMonomerVolumes for a PNASynthesis protocol using a much smaller volume per bottle should result in more bottles being used:",
				partitionSynthesisMonomerVolumes[
					Table[
						{
							{
								Coupling[
									Monomer -> Model[Sample, "Milli-Q water"],
									MonomerVolume -> Quantity[1.`, "Milliliters"],
									Activator ->
											Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
									ActivatorVolume -> Quantity[1, "Milliliters"],
									ActivationTime -> Quantity[10, "Minutes"],
									CouplingTime -> Quantity[60, "Minutes"],
									Preactivation -> ExSitu,
									SingleShot -> True,
									NumberOfReplicates -> 1
								],
								Coupling[
									Monomer -> Model[Sample, "RO Water"],
									MonomerVolume -> Quantity[1.`, "Milliliters"],
									Activator ->
											Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
									ActivatorVolume -> Quantity[1, "Milliliters"],
									ActivationTime -> Quantity[10, "Minutes"],
									CouplingTime -> Quantity[60, "Minutes"],
									Preactivation -> ExSitu,
									SingleShot -> False,
									NumberOfReplicates -> 1
								],
								Coupling[
									Monomer -> Model[Sample, "Tap Water"],
									MonomerVolume -> Quantity[1.`, "Milliliters"],
									Activator ->
											Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
									ActivatorVolume -> Quantity[1, "Milliliters"],
									ActivationTime -> Quantity[10, "Minutes"],
									CouplingTime -> Quantity[60, "Minutes"],
									Preactivation -> ExSitu,
									SingleShot -> False,
									NumberOfReplicates -> 1
								]
							}
						},
						4
					],
					20 Milliliter,
					15 Milliliter
				],
				{
					{1,1,False,"AA1",Quantity[19.`,"Milliliters"],Model[Sample, "RO Water"]},
					{2,1,False,"AA1",Quantity[19.`,"Milliliters"],Model[Sample, "RO Water"]},
					{3,1,False,"AA1",Quantity[19.`,"Milliliters"],Model[Sample, "RO Water"]},
					{4,1,False,"AA1",Quantity[19.`,"Milliliters"],Model[Sample, "RO Water"]},
					{1,2,False,"AA2",Quantity[19.`,"Milliliters"],Model[Sample, "Tap Water"]},
					{2,2,False,"AA2",Quantity[19.`,"Milliliters"],Model[Sample, "Tap Water"]},
					{3,2,False,"AA2",Quantity[19.`,"Milliliters"],Model[Sample, "Tap Water"]},
					{4,2,False,"AA2",Quantity[19.`,"Milliliters"],Model[Sample, "Tap Water"]},
					{1,0,True,"AA3",Quantity[1.`,"Milliliters"],Model[Sample, "Milli-Q water"]},
					{2,0,True,"AA4",Quantity[1.`,"Milliliters"],Model[Sample, "Milli-Q water"]},
					{3,0,True,"AA5",Quantity[1.`,"Milliliters"],Model[Sample, "Milli-Q water"]},
					{4,0,True,"AA6",Quantity[1.`,"Milliliters"],Model[Sample, "Milli-Q water"]}
				}
			],
			Test["Test for partitionSynthesisMonomerVolumes where not all strands use all of the monomer types:",
				partitionSynthesisMonomerVolumes[
					{
						{
							Coupling[
								Monomer -> Model[Sample,"Milli-Q water"],
								MonomerVolume -> Quantity[1.`,"Milliliters"],
								Activator ->
										Model[Sample,StockSolution,"90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1,"Milliliters"],
								ActivationTime -> Quantity[10,"Minutes"],
								CouplingTime -> Quantity[60,"Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> True,
								NumberOfReplicates -> 1
							],
							Coupling[
								Monomer -> Model[Sample,"RO Water"],
								MonomerVolume -> Quantity[1.`,"Milliliters"],
								Activator ->
										Model[Sample,StockSolution,"90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1,"Milliliters"],
								ActivationTime -> Quantity[10,"Minutes"],
								CouplingTime -> Quantity[60,"Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> False,
								NumberOfReplicates -> 1
							],
							Coupling[
								Monomer -> Model[Sample,"Tap Water"],
								MonomerVolume -> Quantity[1.`,"Milliliters"],
								Activator ->
										Model[Sample,StockSolution,"90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1,"Milliliters"],
								ActivationTime -> Quantity[10,"Minutes"],
								CouplingTime -> Quantity[60,"Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> False,
								NumberOfReplicates -> 1
							]
						},
						{
							Coupling[
								Monomer -> Model[Sample,"Milli-Q water"],
								MonomerVolume -> Quantity[1.`,"Milliliters"],
								Activator ->
										Model[Sample,StockSolution,"90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1,"Milliliters"],
								ActivationTime -> Quantity[10,"Minutes"],
								CouplingTime -> Quantity[60,"Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> True,
								NumberOfReplicates -> 1
							],
							Coupling[
								Monomer -> Model[Sample,"Tap Water"],
								MonomerVolume -> Quantity[1.`,"Milliliters"],
								Activator ->
										Model[Sample,StockSolution,"90 mM HBTU in NMP w/ 130 mM DIPEA"],
								ActivatorVolume -> Quantity[1,"Milliliters"],
								ActivationTime -> Quantity[10,"Minutes"],
								CouplingTime -> Quantity[60,"Minutes"],
								Preactivation -> ExSitu,
								SingleShot -> False,
								NumberOfReplicates -> 1
							]
						}
					},
					400 Milliliter,
					15 Milliliter
				],
				{
					{1, 1, False, "AA1", Quantity[16.`, "Milliliters"],Model[Sample, "RO Water"]},
					{1, 2, False, "AA2", Quantity[17.`, "Milliliters"],Model[Sample, "Tap Water"]},
					{2, 1, False, "AA2", Quantity[17.`, "Milliliters"],Model[Sample, "Tap Water"]},
					{1, 0, True, "AA3", Quantity[1.`, "Milliliters"],Model[Sample, "Milli-Q water"]},
					{2, 0, True, "AA4", Quantity[1.`, "Milliliters"],Model[Sample, "Milli-Q water"]}
				}
			]
	}
];


(* ::Subsection:: *)
(*ValidSynthesisStepQ*)


DefineTests[
	ValidSynthesisStepQ,
	{
		Example[
			{Basic,"Test whether a single synthesis primitives is valid:"},
			ValidSynthesisStepQ[
				Coupling[
					Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
					MonomerVolume->5 Milliliter,
					Activator->Model[Sample, "Dimethylformamide, Reagent Grade"],
					ActivatorVolume->5 Milliliter,
					ActivationTime->2 Minute,
					CouplingTime->2 Minute,
					Preactivation->True
				]],
			True
		],
		Example[
			{Basic,"Check if multiple primitives are valid:"},
			ValidSynthesisStepQ[{
				Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1]
			}],
			True
		],
		Example[
			{Options,Verbose, "Verbose->True dynamically prints results of each Test as they are run:"},
			ValidSynthesisStepQ[Cleaving[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],Verbose->True],
			True
		],
		Example[
			{Options,OutputFormat, "OutputFormat->Boolean when given a list of primitives, returns a list of results:"},
			ValidSynthesisStepQ[{
				Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Liter,Volume->5 Milliliter,NumberOfReplicates->1]
			},OutputFormat->Boolean],
			{True,False}
		]
	}
];

(*Deprotecting[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],*)
(**)
(* ::Subsection:: *)
(*Synthesis Step Primitives*)


(* ::Subsubsection:: *)
(*Wash*)


DefineTests[
	Washing,
	{
		Example[
			{Basic,"Create a primitve to wash the resin during the synthesis:"},
			Washing[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Washing
		],
		Test[
			"Create a primitve to wash the resin during the synthesis:",
			MatchQ[
				Washing[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Washing[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Washing
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Washing[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Washing[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Washing
		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Washing[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],


		Example[{Attributes,Protected,"The Washing Head is protected:"},
			Washing="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}
		]

	}
];


(* ::Subsubsection:: *)
(*Swell*)


DefineTests[Swelling,
	{
		Example[
			{Basic,"Create a primitve to swell the resin prior the synthesis:"},
			Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Swelling
		],
		Test[
			"Create a primitve to swell the resin prior the synthesis:",
			MatchQ[
				Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Swelling[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Swelling
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Swelling[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Swelling
		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Swelling[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Swelling Head is protected:"},
			Swelling="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}
		]
	}];


(* ::Subsubsection:: *)
(*Capping*)


DefineTests[Capping,
	{
		Example[
			{Basic,"Create a primitve to cap the strand during the synthesis:"},
			Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
			],
			_Capping
		],
		Test[
			"Create a primitve to cap the strand during the synthesis:",
			MatchQ[
				Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Capping[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Capping
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Capping[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Capping
		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Capping[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Capping Head is protected:"},
			Capping="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}

		]
	}
];


(* ::Subsubsection:: *)
(*Deprotecting*)


DefineTests[Deprotecting,
	{
		Example[
			{Basic,"Create a primitve to deprotect the strand during the synthesis:"},
			Deprotecting[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Deprotecting
		],
		Test[
			"Create a primitve to deprotect the strand during the synthesis:",
			MatchQ[
				Deprotecting[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Deprotecting[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Deprotecting
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Deprotecting[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Deprotecting[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Deprotecting
		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Deprotecting[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Deprotecting Head is protected:"},
			Deprotecting="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}

		]
	}
];


(* ::Subsubsection:: *)
(*Deprotonating*)


DefineTests[Deprotonating,
	{
		Example[
			{Basic,"Create a primitve to deprotonate the strand during the synthesis:"},
			Deprotonating[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Deprotonating
		],
		Test[
			"Create a primitve to deprotonate the strand during the synthesis:",
			MatchQ[
				Deprotonating[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Deprotonating[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Deprotonating
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Deprotonating[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Deprotonating[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Deprotonating

		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Deprotonating[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Deprotecting Head is protected:"},
			Deprotonating="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}

		]
	}
];


(* ::Subsubsection:: *)
(*Coupling*)


DefineTests[Coupling,
	{
		Example[
			{Basic,"Create a primitve to activate a monomer prior its coupling to the strand being synthesized:"},
			Coupling[
				Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
				MonomerVolume->5 Milliliter,
				Activator->Model[Sample, "Dimethylformamide, Reagent Grade"],
				ActivatorVolume->5 Milliliter,
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				NumberOfReplicates->1,
				Preactivation->True
			],
			_Coupling
		],
		Test[
			"Create a primitve to activate a monomer prior its coupling to the strand being synthesized:",
			MatchQ[
				Coupling[
					Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
					MonomerVolume->5 Milliliter,
					Activator->Model[Sample, "Dimethylformamide, Reagent Grade"],
					ActivatorVolume->5 Milliliter,
					ActivationTime->2 Minute,
					CouplingTime->2 Minute,
					Preactivation->True
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"Create a primitve to activate a monomer prior its coupling to the strand being synthesized using a monomer, a preactivation and base solutions:"},
			Coupling[
				Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
				MonomerVolume->5 Milliliter,
				Preactivator->Model[Sample, "Dimethylformamide, Reagent Grade"],
				PreactivatorVolume->5 Milliliter,
				Base->Model[Sample, "Dimethylformamide, Reagent Grade"],
				BaseVolume->5 Milliliter,
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				Preactivation->True
			],
			_Coupling
		],

		Example[
			{Basic,"Any samples (Monomer, Activator, Preactivator or Base) specified, must be liquids:"},
			Coupling[
				Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
				MonomerVolume->5 Milliliter,
				Activator->Model[Sample, "Sodium Chloride"],
				ActivatorVolume->5 Milliliter,
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				Preactivation->True
			],
			_Coupling
		],
		Test[
			"Any samples (Monomer, Activator, Preactivator or Base) specified, must be liquids:",
			MatchQ[
				Coupling[
					Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
					MonomerVolume->5 Milliliter,
					Activator->Model[Sample, "Sodium Chloride"],
					ActivatorVolume->5 Milliliter,
					ActivationTime->2 Minute,
					CouplingTime->2 Minute,
					Preactivation->True
				],SynthesisCycleStepP
			],
			False
		],

		Example[
			{Additional,"Monomer and MonomerVolume keys are required:"},
			Coupling[
				Activator->Model[Sample, "Sodium Chloride"],
				ActivatorVolume->5 Milliliter,
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				Preactivation->True
			],
			_Coupling
		],
		Test[
			"Monomer and MonomerVolume keys are required:",
			MatchQ[Coupling[
				Activator->Model[Sample, "Sodium Chloride"],
				ActivatorVolume->5 Milliliter,
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				Preactivation->True
			],SynthesisCycleStepP],
			False
		],

		Example[
			{Additional,"Either Activator/ActivatorVolume or Preactivator/Base/PreactivatorVolume/BaseVolume keys are required:"},
			Coupling[
				Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
				MonomerVolume->5 Milliliter,
				Activator->Model[Sample, "Dimethylformamide, Reagent Grade"],
				Time->2 Minute,
				Preactivation->True
			],
			_Coupling
		],
		Test[
			"Either Activator/ActivatorVolume or Preactivator/Base/PreactivatorVolume/BaseVolume keys are required:",
			MatchQ[Coupling[
				Monomer->Model[Sample, "Dimethylformamide, Reagent Grade"],
				MonomerVolume->5 Milliliter,
				Activator->Model[Sample, "Dimethylformamide, Reagent Grade"],
				ActivationTime->2 Minute,
				CouplingTime->2 Minute,
				Preactivation->True
			],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Coupling Head is protected:"},
			Coupling="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}

		]
	}
];


(* ::Subsubsection:: *)
(*Cleaving*)


DefineTests[Cleaving,
	{
		Example[
			{Basic,"Create a primitve to cleave the strand from the resin after the synthesis:"},
			Cleaving[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Cleaving
		],
		Test[
			"Create a primitve to cleave the strand from the resin after the synthesis:",
			MatchQ[
				Cleaving[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1
				],
				SynthesisCycleStepP],
			True
		],

		Example[
			{Basic,"The sample provided to the primitive must have a liquid state:"},
			Cleaving[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
			_Cleaving
		],
		Test[
			"The sample provided to the primitive must have a liquid state:",
			MatchQ[
				Cleaving[Sample->Model[Sample, "Sodium Chloride"],Time->2 Minute,Volume->5 Milliliter,NumberOfReplicates->1],
				SynthesisCycleStepP
			],
			False
		],

		Example[
			{Basic,"Sample, Time, Volume and NumberOfReplicates keys are all required:"},
			Cleaving[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],
			_Cleaving
		],
		Test[
			"Sample, Time, Volume and NumberOfReplicates keys are all required:",
			MatchQ[Cleaving[Sample->Model[Sample, "Dimethylformamide, Reagent Grade"]],SynthesisCycleStepP],
			False
		],

		Example[{Attributes,Protected,"The Cleaving Head is protected:"},
			Cleaving="taco",
			"taco",
			Messages:>{Message[Set::wrsym]}

		]
	}];


(*::Section::Closed::*)
(*End Test Package*)
