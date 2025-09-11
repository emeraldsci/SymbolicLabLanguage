(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentPeptideSynthesis*)


DefineTests[
	ExperimentPeptideSynthesis,
	{
		Example[{Basic, "Synthesize a Peptide oligomer at scales over 5 Micromole using a PeptideSynthesizer:"},
			ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 120
		],
		Example[{Basic, "Synthesize multiple Peptide oligomers at scales over 5 Micromole using a PeptideSynthesizer:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model 2 "<>$SessionUUID]

				}],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 120
		],
		Example[{Basic, "Synthesize a peptide oligomer using sequence, strand or structure as inputs:"},
			ExperimentPeptideSynthesis[
				{
					"LysTyrValAla",
					Peptide["LysTyrValAlaMet"],
					ToStrand[Peptide["LysTyrValAlaMetTyr"]],
					ToStructure["LysTyrValAlaMetTyrAla", Polymer -> Peptide]
				}
			],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 180
		],
		Example[{Additional, "Synthesize a peptide oligomer using a Model[Molecule] as inputs:"},
			ExperimentPeptideSynthesis[
				{
					Model[Molecule,Oligomer,"LysLysIleIleLys"<>$SessionUUID],
					Model[Molecule,Oligomer,"LysLysIleIleTyrLys"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 180,
			SetUp:>Quiet[EraseObject[{Model[Sample,"LysLysIleIleLys"], Model[Sample,"LysLysIleIleTyrLys"]},Force->True,Verbose->False]],
			TearDown:> Quiet[EraseObject[{Model[Sample,"LysLysIleIleLys"], Model[Sample,"LysLysIleIleTyrLys"]},Force->True,Verbose->False]]
		],
		Example[{Additional,"Synthesize peptide oligomers using a all possible input variants:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysLysIleIleLys"<>$SessionUUID],
					Model[Molecule,Oligomer,"LysLysIleIleTyrLys"<>$SessionUUID],
					"LysTyrValAla",
					Peptide["LysTyrValAlaMet"],
					ToStrand[Peptide["LysTyrValAlaMetTyr"]],
					ToStructure["LysTyrValAlaMetTyrAla", Polymer -> Peptide]
				}
			],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 180,
			SetUp:>Quiet[EraseObject[{Model[Sample,"LysLysIleIleLys"], Model[Sample,"LysLysIleIleTyrLys"]},Force->True,Verbose->False]],
			TearDown:> Quiet[EraseObject[{Model[Sample,"LysLysIleIleLys"], Model[Sample,"LysLysIleIleTyrLys"]},Force->True,Verbose->False]]
		],
		Example[{Options,Instrument,"Instrument allows specification of the model or objects instrument that should be used for the synthesis:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model 2 "<>$SessionUUID]
					},
					Instrument->Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer for PeptideSynthesis "<>$SessionUUID],
					Output->Options
				],
				Instrument
			],
			ObjectP[Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer for PeptideSynthesis "<>$SessionUUID]]
		],
		Example[{Options,SynthesisStrategy,"SynthesisStrategy allows specification of the type of synthesis strategy that should be used for the synthesis:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Monomers->{
						{Peptide["Lys"], Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID]},
						{Peptide["Ile"], Model[Sample,StockSolution, "Peptide Test Monomer - Ile"<>$SessionUUID]}
					},
					Output->Options
				],
				Monomers
			],
			{
				{Peptide["Lys"],ObjectP[Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID]]},
				{Peptide["Ile"],ObjectP[Model[Sample,StockSolution, "Peptide Test Monomer - Ile"<>$SessionUUID]]}
			}
		],

		Example[{Options,MonomerVolume,"MonomerVolume allows specification of volume of monomer solution added for each reaction vessel to the preactivation vessel for a micromole scale synthesis:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
		Example[{Options,DownloadMonomer,"DownloadMonomer allows specification of model or sample object to use for each of the monomers in the download:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadMonomer->{
						Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID],
						Null,
						Automatic,
						Automatic
					},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadMonomer
			],
			{
				ObjectP[Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID]],
				Null,
				Null,
				ObjectP[Model[Sample,StockSolution]]
			},
			TimeConstraint -> 120
		],

		Example[{Messages,DownloadMonomer,"DownloadMonomer cannot be set to Null, if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->True,
					DownloadMonomer->Null,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::UnavailableDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Messages,DownloadMonomer,"DownloadMonomer should only be specified if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadMonomer->Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID],
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				DownloadMonomer
			],
			ObjectP[Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID]],
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

	(*NOTE:DownloadMonomerVolume*)
		Example[{Options,DownloadMonomerVolume,"DownloadMonomerVolume allows specification volume of monomer solution added for each reaction vessel to the preactivation vessel per micromole of synthesis scale:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadMonomerVolume->{
						2.15 Milliliter,
						Null,
						Automatic,
						Automatic
					},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadMonomerVolume->5.23 Milliliter,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False},
					DownloadActivationSolution->Model[Sample, "Milli-Q water"],
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID]},
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadActivationSolution->Model[Sample, "Milli-Q water"],
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadActivationTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadActivationTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadActivationTime,"DownloadActivationTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadActivationTime->12 Minute,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadActivationVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadActivationVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadActivationVolume,"DownloadActivationVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadActivationVolume->2.5 Milliliter,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadCouplingTime->{12 Minute,Automatic,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadCouplingTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadCouplingTime,"DownloadCouplingTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadCouplingTime->12 Minute,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCouplingWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadCouplingWashes
			],
			{2, Null, Null,GreaterEqualP[1]},
			TimeConstraint -> 240
		],
		Example[{Messages,NumberOfDownloadCouplingWashes,"NumberOfDownloadCouplingWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadCouplingWashes->2,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadCappingTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadCappingTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint->180
		],
		Example[{Messages,DownloadCappingTime,"DownloadCappingTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadCappingTime->12 Minute,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadCappingVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadCappingVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint -> 120
		],

		Example[{Messages,DownloadCappingVolume,"DownloadCappingVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadCappingVolume->2.5 Milliliter,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCappings->{3, Null, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadCappings
			],
			{3, Null, Null,2},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadCappings,"NumberOfDownloadCappings cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadCappings->2,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadCappingWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadCappingWashes
			],
			{2, Null, Null, 5},
			TimeConstraint -> 240
		],
		Example[{Messages,NumberOfDownloadCappingWashes,"NumberOfDownloadCappingWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadCappingWashes->2,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadDeprotectionTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadDeprotectionTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotectionTime,"DownloadDeprotectionTime cannot be set to Null if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadDeprotectionTime->12 Minute,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadDeprotectionVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadDeprotectionVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,	VolumeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotectionVolume,"DownloadDeprotectionVolume cannot be set to Null if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadDeprotectionVolume->2.5 Milliliter,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotections->{4, Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotections
			],
			{4, Null, Null, 2},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotections,"NumberOfDownloadDeprotections cannot be set to Null, if DownloadResin has been set to True:"
		},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadDeprotections->4,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotectionWashes->{2, Automatic, Automatic, Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotectionWashes
			],
			{2, Null, Null, 5},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotectionWashes,"NumberOfDownloadDeprotectionWashes cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadDeprotectionWashes->2,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					Deprotonation->True,
					DeprotonationSolution->Null,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{False,True,Null},
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,DeprotonationSolution,"DeprotonationSolution should only be specified if DownloadResin or Deprotonation has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Deprotonation->{True,False,False,True},
					NumberOfDeprotonations->{4, Null,Automatic,Automatic},
					Output->Options
				],
				NumberOfDeprotonations
			],
			{4, Null, Null, 2},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDeprotonations,"NumberOfDeprotonations cannot be set to Null, if Deprotonation has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					DownloadDeprotonationTime->{12 Minute,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadDeprotonationTime
			],
			{12 Minute, Null, Null, TimeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotonationTime,"DownloadDeprotonationTime cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadDeprotonationTime->12 Minute,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Scale->{5 Micromole, 10 Micromole, 50 Micromole, 100 Micromole},
					DownloadResin->{True,False,False,True},
					DownloadDeprotonationVolume->{2.5 Milliliter,Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				DownloadDeprotonationVolume
			],
			{Quantity[2.5`, "Milliliters"], Null, Null,VolumeP},
			TimeConstraint -> 120
		],
		Example[{Messages,DownloadDeprotonationVolume,"DownloadDeprotonationVolume cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadDeprotonationVolume->2.5 Milliliter,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False,False,True},
					NumberOfDownloadDeprotonations->{4, Null,Automatic,Automatic},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Automatic},
					Output->Options
				],
				NumberOfDownloadDeprotonations
			],
			{4, Null, Null, 2},
			TimeConstraint -> 120
		],
		Example[{Messages,NumberOfDownloadDeprotonations,"NumberOfDownloadDeprotonations cannot be set to Null, if DownloadResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					NumberOfDownloadDeprotonations->4,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,CleavageVolume,"CleavageVolume specifies volume of cleavage cocktail that should be used to cleave the Peptide strands from the resin:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,NumberOfCleavageCycles,"NumberOfCleavageCycles allows specification of the number of times the Peptide strands on the resin should be incubated with the cleavage cocktail:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,TriturationSolution,"TriturationSolution allows specification of model or sample object that should be used to purify the Peptide strands after cleavage from the resin by using the solubility differences between Peptide strands, which should crash out of solution and impurities which remain soluble:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Cleavage->{True,False},
					TriturationSolution->Model[Sample, "Peptide Test TriturationSolution"<>$SessionUUID],
					Output->Options
				],
				{Cleavage,TriturationSolution}
			],
			{{True,False},ObjectP[Model[Sample, "Peptide Test TriturationSolution"<>$SessionUUID]]}
		],
		Example[{Messages,TriturationSolution,"TriturationSolution cannot be set to Null, if Cleavage has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,TriturationVolume,"TriturationVolume allows specification of volume of ether that should be used to triturate the Peptide strands after cleavage from the resin:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,NumberOfTriturationCycles,"NumberOfCleavageCycles allows specification number of times the cleaved Peptide strands should be triturated with TriturationSolution:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Cleavage->True,
					NumberOfTriturationCycles->Null,
					Output->Options
				],
				NumberOfTriturationCycles
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::InvalidOption]}
		],
		Example[{Messages,NumberOfTriturationCycles,"NumberOfTriturationCycles allows specification number of times the cleaved Peptide strands should be triturated with TriturationSolution:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
		Example[{Options,ResuspensionVolume,"ResuspensionVolume allows specification of the volume of resuspension buffer that should be used to resuspend the Peptide strands after cleavage from the resin:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
		Example[{Options,ResuspensionMixPrimitives,"Resuspension mix primitives can be provided for each strand separately (for example, the first strand can be mixed by pipetting, while the second strand is vortexed and sonicated):"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
		Example[{Messages, "NoCappingSet", "Throws a warning if number of cappings is 0 while InitialCapping is set to True:"},
			ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],InitialCapping->True,NumberOfCappings->0],
			ObjectP[Object[Protocol,PeptideSynthesis]],
			TimeConstraint -> 150,
			Messages:>{Message[Warning::NoCappingSet]}
		],
		Example[{Messages,"UnneededCleavageOptions","ResuspensionMixType should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[{Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]},
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
				ExperimentPeptideSynthesis[{Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]},
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
				ExperimentPeptideSynthesis[{Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]},
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
				ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				Message[Error::InvalidInput],
				Message[Error::IncompatibleResuspensionMixPrimitives],
				Message[Error::InvalidOption]
			}
		],

	(*NOTE: other options *)
		Example[{Options,Scale,"Scale allows specification of the scale at which the oligomers should be synthesized:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID]},
					Output->Options
				],
				DownloadResin
			],
			{True,False}
		],

		Example[{Options,Resin,"Resin specifies the model or sample object of resin that should be used as the solid support for the synthesis:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,False},
					Resin->{Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID]},
					Output->Options
				],
				DownloadResin
			],
			{True,False}
		],

	(*NOTE: extra steps option switches *)
		Example[{Options,DoubleCoupling,"DoubleCoupling specifies at which cycles the coupling is repeated twice using freshly activated monomer:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					DownloadResin->{True,True,True,False},
					Resin->{Automatic,Automatic,Automatic,Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID]},
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->{True,False},
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				SwellResin
			],
			{True,False}
		],
		Example[{Options,SwellSolution,"SwellSolution allows specification of model or sample object that should be used to swell the resin prior to the start of the synthesis or resin download:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->False,
					SwellSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SwellSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededSwellOptions],Error::SwellResinNeeded,Message[Error::InvalidOption]}
		],

		Example[{Options,SwellTime,"SwellTime allows specification of the amount of time that the resin is swelled for (per cycle):"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->{True,False,False,True},
					SwellTime->{12 Minute, Null,Automatic, Automatic},
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				SwellTime
			],
			{12 Minute,Null,TimeP,TimeP},
			TimeConstraint->180
		],
		Example[{Messages,SwellTime,"SwellTime should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					SwellResin->False,
					SwellTime->12 Minute,
					Output->Options
				],
				SwellTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededSwellOptions],Error::SwellResinNeeded,Message[Error::InvalidOption]}
		],

		Example[{Options,SwellVolume,"SwellVolume allows specification the volume of SwellSolution that the samples are swelled with:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->{True,False,True},
					SwellVolume->{2.5 Milliliter,Automatic,Automatic},
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				SwellVolume
			],
			{2.5 Milliliter, 10 Milliliter,10 Milliliter},
			TimeConstraint->180
		],
		Example[{Messages,SwellVolume,"SwellVolume should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					SwellResin->False,
					SwellVolume->2.5 Milliliter,
					Output->Options
				],
				SwellVolume
			],
			2.5 Milliliter,
			Messages:>{Message[Error::UnneededSwellOptions],Error::SwellResinNeeded,Message[Error::InvalidOption]}
		],

		Example[{Options,NumberOfSwellCycles,"NumberOfSwellCycles allows specification of the number of the cycles of swelling of the resin before the start of a synthesis:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->{True,False,True},
					NumberOfSwellCycles->{7,Automatic, Automatic},
					DownloadResin->False,
					Resin->Model[Sample, "Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				NumberOfSwellCycles
			],
			{7,3,3},
			TimeConstraint->180
		],
		Example[{Messages,NumberOfSwellCycles,"NumberOfSwellCycles should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					SwellResin->False,
					NumberOfSwellCycles->7,
					Output->Options
				],
				NumberOfSwellCycles
			],
			7,
			Messages:>{Message[Error::UnneededSwellOptions],Error::SwellResinNeeded,Message[Error::InvalidOption]}
		],

	(* Note: PrimaryResinShrinkSolution/SecondaryResinShrink *)
		Example[{Options,PrimaryResinShrink,"PrimaryResinShrink specifies if the resin is shrunk with primary shrink solution prior to strand cleavage or storage:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					PrimaryResinShrink->{True,False},
					Output->Options
				],
				PrimaryResinShrink
			],
			{True,False},
			TimeConstraint->180
		],
		Example[{Options,SecondaryResinShrink,"SecondaryResinShrink specifies if the resin is shrunk with secondary shrink solution prior to strand cleavage or storage::"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SecondaryResinShrink->{True,False},
					Output->Options
				],
				SecondaryResinShrink
			],
			{True,False},
			TimeConstraint->180
		],

	(*NOTE: PrimaryResinShrinkSolution/SecondaryResinShrinkSolution*)
		Example[{Options,PrimaryResinShrinkSolution,"PrimaryResinShrinkSolution allows specification of model or sample object that should be used to wash and dry the resin after last coupling step:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					SecondaryResinShrink->False,
					SecondaryResinShrinkSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SecondaryResinShrinkSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],


	(*NOTE:PrimaryShrink/SecondaryShrink WashTime*)
		Example[{Options,PrimaryResinShrinkTime,"PrimaryResinShrinkTime allows specification of the duration of the resin shrink wash at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					PrimaryResinShrink->False,
					PrimaryResinShrinkTime->12 Minute,
					Output->Options
				],
				PrimaryResinShrinkTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}		],

		Example[{Options,SecondaryResinShrinkTime,"SecondaryResinShrinkTime allows specification of the duration of the secondary resin shrink wash at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					SecondaryResinShrink->False,
					SecondaryResinShrinkTime->12 Minute,
					Output->Options
				],
				SecondaryResinShrinkTime
			],
			12 Minute,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

	(*NOTE:PrimaryResinShrinkSolution/SecondaryResinShrinkSolution WashVolume*)
		Example[{Options,PrimaryResinShrinkVolume,"PrimaryResinShrinkVolume allows specification of the volume of primary shrink solution that should be used to wash the resin at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					PrimaryResinShrink->False,
					PrimaryResinShrinkVolume->15 Milliliter,
					Output->Options
				],
				PrimaryResinShrinkVolume
			],
			15 Milliliter,
			Messages:>{Message[Error::UnneededShrinkOptions],Message[Error::InvalidOption]}
		],

		Example[{Options,SecondaryResinShrinkVolume,"SecondaryResinShrinkVolume allows specification of the volume of secondary shrink solution that should be used to wash the resin at the end of the last synthesis cycle:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
			Lookup[ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				RecoupMonomers->True,
				Output->Options
			],RecoupMonomers],
			True,
			TimeConstraint->180
		],

	(*NOTE:MonomerPreactivation*)
		Example[{Options,MonomerPreactivation,"Specify that preactivation of the monomers should happen ex situ (in a separate reaction vessel):"},
			Lookup[ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				MonomerPreactivation->ExSitu,
				Output->Options
			],MonomerPreactivation],
			ExSitu,
			TimeConstraint->180
		],

		Example[{Options,MonomerPreactivation,"Specify that preactivation of the monomers should happen in situ (in the same reaction vessel):"},
			Lookup[ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				MonomerPreactivation->InSitu,
				Output->Options
			],MonomerPreactivation],
			InSitu,
			TimeConsuming->180
		],


	(*NOTE: shared options *)
		Example[{Options,Name, "An object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					Name->"This is a test of the protocol naming system",
					Output->Options
				],
				Name
			],
			"This is a test of the protocol naming system"
		],
		Example[{Options,Confirm,"Confirm specifies if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Confirm->True,
				Output->Options
			],
			_
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			Download[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"
				],
				CanaryBranch
			],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options,Upload,"Upload specifies if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Upload->False,
				Output->Options
			],
			_
		],
		Example[{Options,FastTrack,"FastTrack specifies if validity checks on the provided input and options should be skipped for faster performance:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				FastTrack->True,
				Output->Options
			],
			_
		],
		Example[{Options,Email,"Email specifies if emails should be sent for any notifications relevant to the function's output:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Email->False,
				Output->Options
			],
			_
		],
		Example[{Options,ParentProtocol,"ParentProtocol specifies the protocol which is directly generating this experiment during execution:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				ParentProtocol->Object[Protocol, PeptideSynthesis, "Peptide Test Parent Protocol "<>$SessionUUID],
				Output->Options
			],
			_
		],
		Example[{Options,Cache,"Cache takes in a list of pre-downloaded packets that should be used before checking for session cached object or downloading any object information from the server:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Cache->{},
				Output->Options
			],
			_
		],
		Example[{Options,Template,"A template protocol whose methodology should be reproduced in running this experiment. Option values should be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Template->Object[Protocol, PeptideSynthesis, "Peptide Test Template Protocol "<>$SessionUUID],
				Output->Options
			],
			_
		],
		Example[{Options,Output,"Output specifies what the function should return:"},
			ExperimentPeptideSynthesis[
				{
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
				},
				Output->Options
			],
			_List
		],
		Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition allows specification of the non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples should be stored according to their Models' DefaultStorageCondition:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SamplesOutStorageCondition->{AmbientStorage,DeepFreezer},
					Output->Options
				],
				SamplesOutStorageCondition
			],
			{AmbientStorage,DeepFreezer}
		],
		Example[{Messages,WrongResin,"If DownloadResin is set to True, Resin cannot be specified to a downloaded resin (Object/Model[Sample]) since the first step in the synthesis will be the download of the resin:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->True,
				Resin->Model[Sample, "Peptide Test Downloaded Resin"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::WrongResin],Message[Error::InvalidOption]}
		],

		Example[{Messages,ResinNeeded,"If DownloadResin is set to False, an appropriate downloaded Resin has to be specified by the user via the Option Resin:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False
			],
			$Failed,
			Messages:>{Message[Error::ResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,DownloadedResinNeeded,"If DownloadResin is set to False, the Resin specified by the user cannot be undownloaded:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False,
				Resin->Model[Sample,"Peptide Test Undownloaded Resin"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::DownloadedResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,"SwellResinNeeded","If DownloadResin is set to False and SwellResin is True, an error will be thrown:"},
		    ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin -> True,
				SwellResin -> False
			],
		    $Failed,
		    Messages :> {Error::SwellResinNeeded,Error::InvalidOption}
		],

		Example[{Messages,MismatchedResinAndStrand,"The specified downloaded Resin has to match the sequence of the 3' bases in the strand to be synthesized:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False,
				Resin->Model[Sample, "Peptide Test Downloaded Resin with Wrong Sequence"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::MismatchedResinAndStrand],Message[Error::InvalidOption]}
		],
	(* MESSAGES GENERAL *)
		Example[{Messages,"TooManyMonomers", "Throws an error if a strand is being synthesized that requires more monomers than fit on the deck:"},
			ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model with crazy lots of non-default monomers "<>$SessionUUID],
				Monomers-> {
					{PNA["A"],Model[Sample,StockSolution,"Peptide Test Stock[A] Solution"<>$SessionUUID]},
					{PNA["T"],Model[Sample,StockSolution,"Peptide Test Stock[T] Solution"<>$SessionUUID]},
					{PNA["C"],Model[Sample,StockSolution,"Peptide Test Stock[C] Solution"<>$SessionUUID]},
					{PNA["G"],Model[Sample,StockSolution,"Peptide Test Stock[G] Solution"<>$SessionUUID]},

					{GammaLeftPNA["A"],Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[A]] Solution"<>$SessionUUID]},
					{GammaLeftPNA["T"],Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[T]] Solution"<>$SessionUUID]},
					{GammaLeftPNA["C"],Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[C]] Solution"<>$SessionUUID]},
					{GammaLeftPNA["G"],Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[G]] Solution"<>$SessionUUID]},

					{GammaRightPNA["A"],Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[A]] Solution"<>$SessionUUID]},
					{GammaRightPNA["T"],Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[T]] Solution"<>$SessionUUID]},
					{GammaRightPNA["C"],Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[C]] Solution"<>$SessionUUID]},
					{GammaRightPNA["G"],Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[G]] Solution"<>$SessionUUID]}
				}
			],
			$Failed,
			Messages:>{Message[Error::TooManyMonomers]},
			TimeConstraint->200
		],

		Example[{Messages,"PolymerType", "Throws an error if a strand of a type other than Peptide is being synthesized:"},
			ExperimentPeptideSynthesis[Model[Sample,"DNA Test Oligomer Model for PeptideSynthesis "<>$SessionUUID]],
			$Failed,
			Messages:>{
				Message[Error::PolymerType],
				Message[Error::UnavailableDownloadMonomer],
				Message[Error::UnavailableMonomer],
				Message[Error::InvalidOption],
				Message[Error::InvalidInput]
			}
		],

		Example[{Messages,"NumberOfInputs","Throws an error if the number of oligomer(s) being synthesized in one protocol is outside the capability of the instrument:"},
			ExperimentPeptideSynthesis[{
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
			}],
			$Failed,
			Messages:>{Message[Error::NumberOfInputs],Message[Error::InvalidInput]},
			TimeConstraint->360
		],

		Example[{Messages,"InsufficientSolventVolume","Throws an error if we use more of a solvent than fits into the solvent container under the deck:"},
			Lookup[
				ExperimentPeptideSynthesis[{
					Model[Sample,"Peptide Test Oligomer Model Superlong "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model Superlong "<>$SessionUUID],
					Model[Sample,"Peptide Test Oligomer Model Superlong "<>$SessionUUID]
				},
					WashVolume->19*Milliliter,
					Output->Options
				],
				WashVolume
			],
			19*Milliliter,
			Messages:>{Message[Error::InsufficientSolventVolume]}
		],

		Example[{Messages,"UnneededSwellOptions","Swell related options should only be specified if SwellResin has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					{
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]
					},
					SwellResin->False,
					SwellSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				SwellSolution
			],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{Message[Error::UnneededSwellOptions],Error::SwellResinNeeded,Message[Error::InvalidOption]}
		],

		Example[{Messages,"UnneededCleavageOptions","Cleavage related options should only be specified if Cleavage has been set to True:"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
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
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Deprotonation->False,
					DeprotonationSolution->Model[Sample, "Milli-Q water"],
					Output->Options
				],
				{DownloadResin,Deprotonation,DeprotonationSolution}
			],
			{False,False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages:>{Message[Error::UnneededDeprotonationOptions],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnavailableDownloadMonomer","DownloadMonomer automatic resolution will fail when a novel (non-default) download monomer is used and therefore must be explicitly specified:"},
			Lookup[
				ExperimentPeptideSynthesis[
					StrandJoin[
						ToStrand[Peptide["TyrLysMet"]],
						ToStrand[PNA["A"]]
					],
					DownloadResin->True,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::UnavailableDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Messages,"WrongResin","If DownloadResin is set to True, Resin cannot be specified to a downloaded resin (Object/Model[Sample]) since the first step in the synthesis will be the download of the resin:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->True,
				Resin->Model[Sample, "Peptide Test Downloaded Resin"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::WrongResin],Message[Error::InvalidOption]}
		],

		Example[{Messages,"ResinNeeded","If DownloadResin is set to False, an appropriate downloaded Resin has to be specified by the user via the Option Resin:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False
			],
			$Failed,
			Messages:>{Message[Error::ResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,"DownloadedResinNeeded","If DownloadResin is set to False, the Resin specified by the user cannot be undownloaded:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False,
				Resin->Model[Sample,"Peptide Test Undownloaded Resin"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::DownloadedResinNeeded],Message[Error::InvalidOption]}
		],

		Example[{Messages,"MismatchedResinAndStrand","The specified downloaded Resin has to match the sequence of the 3' bases in the strand to be synthesized:"},
			ExperimentPeptideSynthesis[
				Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
				DownloadResin->False,
				Resin->Model[Sample, "Peptide Test Downloaded Resin with Wrong Sequence"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Message[Error::MismatchedResinAndStrand],Message[Error::InvalidOption]}
		],
		Example[{Messages,"RequiredOption","Download related options cannot be set to Null, if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->True,
					DownloadMonomer->Null,
					Output->Options
				],
				DownloadMonomer
			],
			Null,
			Messages:>{Message[Error::RequiredOption],Message[Error::UnavailableDownloadMonomer],Message[Error::InvalidOption]}
		],
		Example[{Messages,"UnneededDownloadResinOptions","Download related options should only be specified if DownloadResin has been set to True::"},
			Lookup[
				ExperimentPeptideSynthesis[
					Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
					DownloadResin->False,
					DownloadMonomer->Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID],
					Resin->Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
					Output->Options
				],
				DownloadMonomer
			],
			ObjectP[Model[Sample,StockSolution, "Peptide Test Monomer - Lys"<>$SessionUUID]],
			Messages:>{Message[Error::UnneededDownloadResinOptions],Message[Error::InvalidOption]}
		],

	(* Resource packet function *)
		Module[{myProtocol},
			Test["The fields related to the download and synthesis cycle parameters are properly populated in the generated Peptide protocol object:",
				myProtocol=ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]];
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
					0.3125`Day,
					{True},
					{5.`Milliliter},
					{180.`Minute},
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
			Test["The strand and synthesis cycle fields are properly populated in the generated Peptide protocol object:",
				myProtocol=ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]];
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
			Test["All the fields containing resources are properly populated in the generated Peptide protocol object:",
				myProtocol=ExperimentPeptideSynthesis[Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID]];
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
					{ObjectP[Model[Sample,StockSolution]],ObjectP[Model[Sample,StockSolution]]},
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
					{ObjectP[Model[Item,Cap]]},
					Null,
					ObjectP[Model[Sample]],
					ObjectP[Model[Container,Vessel]],

					{ObjectP[Model[Sample]]..}
				}
			]
		]
	},
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},
	SymbolSetUp:>{Module[{createdObjects,existsFilter},
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		createdObjects={
			Model[Sample,"Peptide Test Oligomer Model "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model Superlong "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model with crazy lots of non-default monomers "<>$SessionUUID],
			Model[Sample,"DNA Test Oligomer Model for PeptideSynthesis "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model 1 "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model 2 "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model 3 "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model with novel monomers "<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer Model with novel download monomer "<>$SessionUUID],
			Model[Instrument,PeptideSynthesizer,"Test PeptideSynthesizer for PeptideSynthesis "<>$SessionUUID],
			Object[User,Emerald,"Peptide Test Operator "<>$SessionUUID],
			Object[Protocol,PeptideSynthesis,"Peptide Test Template Protocol "<>$SessionUUID],
			Object[Protocol,PeptideSynthesis,"Peptide Test Parent Protocol "<>$SessionUUID],
			Model[Sample,"Peptide Test Undownloaded Resin"<>$SessionUUID],
			Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],
			Model[Sample,"Peptide Test Downloaded Resin with Wrong Sequence"<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer For Resin"<>$SessionUUID],
			Model[Sample,"Peptide Test Oligomer For Wrong Resin"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Monomer - Lys"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Monomer - Ile"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Monomer - Tyr"<>$SessionUUID],
			Object[Product,"Peptide Test Product for Downloaded Resin"<>$SessionUUID],
			Object[Sample,"Peptide Test Downloaded Resin Sample"<>$SessionUUID],
			Model[Sample,"Peptide Test TriturationSolution"<>$SessionUUID],
			Object[Product,"Peptide Test Product for TriturationSolution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[A] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[C] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[G] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[T] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[A]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[C]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[G]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaRightPNA[T]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[A]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[C]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[G]] Solution"<>$SessionUUID],
			Model[Sample,StockSolution,"Peptide Test Stock[GammaLeftPNA[T]] Solution"<>$SessionUUID],
			Model[Molecule,Oligomer,"LysLysIleIleLys"<>$SessionUUID],
			Model[Molecule,Oligomer,"DNA[ATCG]"<>$SessionUUID<>$SessionUUID],
			Model[Molecule,Oligomer,"SuperLong Test Peptide Oligomer"<>$SessionUUID],
			Model[Molecule,Oligomer,"LysLysIleIleTyrLys"<>$SessionUUID],
			Model[Molecule,Oligomer,"Test Peptide Oligomer with novel monomer"<>$SessionUUID],
			Model[Molecule,Oligomer,"Test Peptide Oligomer with crazy monomers"<>$SessionUUID],
			Model[Molecule,Oligomer,"Test Peptide Oligomer with novel download monomer"<>$SessionUUID],
			Model[Molecule,Oligomer,"Lys"<>$SessionUUID],
			Model[Molecule,Oligomer,"Ile"<>$SessionUUID],
			Model[Resin,SolidPhaseSupport,"Peptide Test Resin Lys"<>$SessionUUID],
			Model[Resin,SolidPhaseSupport,"Peptide Test Resin Ile"<>$SessionUUID],
			Model[Resin,"Peptide Test Resin"<>$SessionUUID],
			Object[Sample,"Dimethylformamide Test for ExperimentPeptideSynthesis"<>$SessionUUID],
			Object[Container,Vessel,"Dimethylformamide container for ExperimentPeptideSynthesis"<>$SessionUUID]
		};

		(* Check whether the names we want to ],give below already exist in the database *)
		existsFilter=DatabaseMemberQ[createdObjects];
		(* Erase any objects that we failed to erase in the last unit test. *)
		Quiet[EraseObject[
			PickList[createdObjects,existsFilter],
			Force->True,
			Verbose->False
		]];
	];
		Module[{identityATCG,identityModelSuperLong,identityATTCG,identityATTTCG,
			identity1,identityDNA,identitySuperLong,identity2,identityATCGDNA,identityNovel,identityCrazy,identityNovelDownload,dmfContainer,dmfSample,
			identityForResin,identityForResinWrong,identityResinWithMonomer,
			identityResinWithWrongMonomer,identityResin,
			uploadOligomerModels,uploadResins,uploadSamples
		},

			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identity1,
				identityDNA,
				identitySuperLong,
				identity2,
				identityCrazy,
				identityForResin,
				identityForResinWrong
			}=MapThread[Function[{newStructure,newPolymerType,newName},
				If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
					(UploadOligomer[
						newStructure,
						newPolymerType,
						newName,
						Upload->True
					];
					UploadNotebook[Model[Molecule,Oligomer,newName],Null]),
					Model[Molecule,Oligomer,newName]
				]
			],
				{
					{
						ToStructure[Peptide["LysLysIleIleLys"]],
						ToStructure[DNA["ATCG"]],
						ToStructure[Peptide["LysLysIleIleLysLysLysIleIleLysLysLysIleIleLysLysLysIleIleLys"]],
						ToStructure[PNA["LysLysIleIleTyrLys"]],
						ToStructure[
							{Strand[
								GammaLeftPNA["ATCG"],
								PNA["ATCG"],
								GammaRightPNA["ATCG"],
								Peptide["LysTyrValIleAlaMetHisThrSerProTrpArgAspAsnGluGlyHisGln"]
							]}],
						ToStructure[Peptide["Lys"]],
						ToStructure[Peptide["Ile"]]
					},
					{Peptide,DNA,Peptide,Peptide,Peptide,Peptide,Peptide},
					{"LysLysIleIleLys"<>$SessionUUID,"DNA[ATCG]"<>$SessionUUID,"SuperLong Test Peptide Oligomer"<>$SessionUUID,"LysLysIleIleTyrLys"<>$SessionUUID,"Test Peptide Oligomer with crazy monomers"<>$SessionUUID,"Lys"<>$SessionUUID,"Ile"<>$SessionUUID}
				}];

			{identityResinWithMonomer,identityResinWithWrongMonomer,identityResin}=Upload[{
				Association[Name->"Peptide Test Resin Lys"<>$SessionUUID,DeveloperObject->True,Type->Model[Resin,SolidPhaseSupport],State->Liquid,Strand->Link[identityForResin]],
				Association[Name->"Peptide Test Resin Ile"<>$SessionUUID,DeveloperObject->True,Type->Model[Resin,SolidPhaseSupport],State->Liquid,Strand->Link[identityForResinWrong]],
				Association[Name->"Peptide Test Resin"<>$SessionUUID,DeveloperObject->True,Type->Model[Resin],State->Liquid] (* we don't have a Strand *)
			}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"Peptide Test Oligomer Model "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"DNA Test Oligomer Model for PeptideSynthesis "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityDNA]}}],
				Association[Name->"Peptide Test Oligomer Model Superlong "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identitySuperLong]}}],
				Association[Name->"Peptide Test Oligomer Model 1 "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"Peptide Test Oligomer Model 2 "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity2]}}],
				Association[Name->"Peptide Test Oligomer Model 3 "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"Peptide Test Oligomer Model with crazy lots of non-default monomers "<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityCrazy]}}],
				Association[Name->"Test PeptideSynthesizer for PeptideSynthesis "<>$SessionUUID,DeveloperObject->True,Type->Model[Instrument,PeptideSynthesizer],DeadVolume->15*Milliliter],
				Association[Name->"Peptide Test Operator "<>$SessionUUID,DeveloperObject->True,Type->Object[User,Emerald]],
				Association[Name->"Peptide Test Template Protocol "<>$SessionUUID,DeveloperObject->True,Type->Object[Protocol,PeptideSynthesis]],
				Association[Name->"Peptide Test Parent Protocol "<>$SessionUUID,DeveloperObject->True,Type->Object[Protocol,PeptideSynthesis]],
				Association[Name->"Peptide Test Oligomer For Resin"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityForResin]}}],
				Association[Name->"Peptide Test Oligomer For Wrong Resin"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityForResinWrong]}}],
				Association[Name->"Peptide Test Monomer - Lys"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Monomer - Ile"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Monomer - Tyr"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[A] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[C] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[G] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[T] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaRightPNA[A]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaRightPNA[C]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaRightPNA[G]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaRightPNA[T]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaLeftPNA[A]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaLeftPNA[C]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaLeftPNA[G]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test Stock[GammaLeftPNA[T]] Solution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample,StockSolution]],
				Association[Name->"Peptide Test TriturationSolution"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample]]
			}];
			(* upload download resin samples based on the strandmodels created above *)
			uploadResins=Upload[{
				Association[Name->"Peptide Test Downloaded Resin"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResinWithMonomer]}}],
				Association[Name->"Peptide Test Downloaded Resin with Wrong Sequence"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResinWithWrongMonomer]}}],
				Association[Name->"Peptide Test Undownloaded Resin"<>$SessionUUID,DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identityResin]}}]
			}];
			(* upload a sample and a product based on the download resin model created above *)
			uploadSamples=Upload[{
				Association[Name->"Peptide Test Product for Downloaded Resin"<>$SessionUUID,DeveloperObject->True,Type->Object[Product],ProductModel->Link[Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Products],EstimatedLeadTime->5*Day],
				Association[Name->"Peptide Test Product for TriturationSolution"<>$SessionUUID,DeveloperObject->True,Type->Object[Product],ProductModel->Link[Model[Sample,"Peptide Test TriturationSolution"<>$SessionUUID],Products],EstimatedLeadTime->5*Day],
				Association[Name->"Peptide Test Downloaded Resin Sample"<>$SessionUUID,DeveloperObject->True,Type->Object[Sample],Model->Link[Model[Sample,"Peptide Test Downloaded Resin"<>$SessionUUID],Objects],Status->Liquid,Volume->20*Milliliter,Status->Available]
			}];

			{
				dmfContainer
			}=UploadSample[
				{Model[Container,Vessel,"id:3em6Zv9NjjkY"]},
				{{"Work Surface",Object[Container,Bench,"The Bench of Testing"]}},
				FastTrack->True,
				Name->"Dimethylformamide container for ExperimentPeptideSynthesis"<>$SessionUUID
			];
			{
				dmfSample
			}=UploadSample[
				{Model[Sample,"id:KBL5DvYl3ekv"]},
				{{"A1",dmfContainer}},
				FastTrack->True,
				Name->"Dimethylformamide Test for ExperimentPeptideSynthesis"<>$SessionUUID
			];
			Upload[<|Object->#,DeveloperObject->True|>&/@{dmfContainer,dmfSample}];
			UploadNotebook[Flatten[{dmfContainer,dmfSample,identity1,
				identityDNA, identitySuperLong, identity2, identityCrazy, identityForResin, identityForResinWrong,identityResinWithMonomer,identityResinWithWrongMonomer,identityResin,uploadOligomerModels,uploadResins,uploadSamples}],Null]
		];
	},
	SymbolTearDown:>{
		Quiet[EraseObject[$CreatedObjects,Force -> True,Verbose -> False]];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];


(* ::Subsection::Closed:: *)
(* Sister functions *)


(* ::Subsubsection:: *)
(* ExperimentPeptideSynthesisOptions *)


DefineTests[
	ExperimentPeptideSynthesisOptions,
	{
		Example[{Basic, "Generate a table of resolved options for an ExperimentPeptideSynthesis call to synthesize a single strand:"},
			ExperimentPeptideSynthesisOptions[Model[Sample,"PeptideOptions Test Oligomer Model "<>$SessionUUID]],
			_Grid
		],
		Example[{Basic, "Generate a table of resolved options for an ExperimentPeptideSynthesis call to synthesize multiple strands:"},
			ExperimentPeptideSynthesisOptions[
				{
					Model[Sample,"PeptideOptions Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptideOptions Test Oligomer Model 2 "<>$SessionUUID]
				}
			],
			_Grid
		],

		Example[
			{Options, OutputFormat, "Generate a list of resolved options for an ExperimentPeptideSynthesis call to synthesize multiple strands:"},
			ExperimentPeptideSynthesisOptions[
				{
					Model[Sample,"PeptideOptions Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptideOptions Test Oligomer Model 2 "<>$SessionUUID]
				},
				OutputFormat->List
			],
			_?(MatchQ[
				Check[SafeOptions[ExperimentPeptideSynthesis, #], $Failed, {Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},

	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Module[{existsFilter,identity1,identity2,identity3,uploadOligomerModels},

			$CreatedObjects={};
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PeptideOptions Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"PeptideOptions Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptideOptions Test Oligomer Model 2 "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAla for PeptideOptions "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAla for PeptideOptions "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptideOptions "<>$SessionUUID],
					Model[Sample,"LysLysIleIleLys"],
					Model[Sample,"LysLysIleIleTyrLys"]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PeptideOptions Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"PeptideOptions Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"PeptideOptions Test Oligomer Model 2 "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAla for PeptideOptions "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAla for PeptideOptions "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptideOptions "<>$SessionUUID],
						Model[Sample,"LysLysIleIleLys"],
						Model[Sample,"LysLysIleIleTyrLys"]
					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identity1,
				identity2,
				identity3
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
						ToStructure[Peptide["LysTyrAla"]],
						ToStructure[Peptide["LysTyrAlaAla"]],
						ToStructure[Peptide["LysTyrAlaAlaAla"]]
					},
					{Peptide,Peptide,Peptide},
					{"LysTyrAla for PeptideOptions "<>$SessionUUID,"LysTyrAlaAla for PeptideOptions "<>$SessionUUID,"LysTyrAlaAlaAla for PeptideOptions "<>$SessionUUID}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PeptideOptions Test Oligomer Model "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"PeptideOptions Test Oligomer Model 1 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity2]}}],
				Association[Name->"PeptideOptions Test Oligomer Model 2 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity3]}}]
			}]
		]
	),
	SymbolTearDown:>{
		Quiet[EraseObject[$CreatedObjects,Force -> True,Verbose -> False]];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];


(* ::Subsubsection:: *)
(*ExperimentPeptideSynthesisPreview*)

DefineTests[
	ExperimentPeptideSynthesisPreview,
		{
		(* --- Basic Examples --- *)
			Example[
				{Basic, "Generate a preview for an ExperimentPeptideSynthesis call to synthesize a single strand (will always be Null):"},
				ExperimentPeptideSynthesisPreview[Model[Sample,"PeptidePreview Test Oligomer Model "<>$SessionUUID]],
				Null
			],
			Example[
				{Basic, "Generate a preview for an ExperimentPeptideSynthesis call to synthesize multiple strands (will always be Null):"},
				ExperimentPeptideSynthesisPreview[
					{
						Model[Sample,"PeptidePreview Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"PeptidePreview Test Oligomer Model 2 "<>$SessionUUID]
					}
				],
				Null
			],
			Example[
				{Basic, "Generate a preview for an ExperimentPeptideSynthesis call to synthesize multiple strands and specifying options (will always be Null):"},
				ExperimentPeptideSynthesisPreview[
					{
						Model[Sample,"PeptidePreview Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"PeptidePreview Test Oligomer Model 2 "<>$SessionUUID]
					},
					DownloadResin->True
				],
				Null
			]
		},
		Stubs:>{
			$PersonID = Object[User, "Test user for notebook-less test protocols"],
			$EmailEnabled=False
		},
	SymbolSetUp:>(
		Module[{existsFilter,identity1,identity2,identity3,uploadOligomerModels},

			$CreatedObjects={};
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PeptidePreview Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"PeptidePreview Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptidePreview Test Oligomer Model 2 "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAla for PeptidePreview "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAla for PeptidePreview "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptidePreview "<>$SessionUUID]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PeptidePreview Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"PeptidePreview Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"PeptidePreview Test Oligomer Model 2 "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAla for PeptidePreview "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAla for PeptidePreview "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptidePreview "<>$SessionUUID]

					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identity1,
				identity2,
				identity3
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
						ToStructure[Peptide["LysTyrAla"]],
						ToStructure[Peptide["LysTyrAlaAla"]],
						ToStructure[Peptide["LysTyrAlaAlaAla"]]
					},
					{Peptide,Peptide,Peptide},
					{"LysTyrAla for PeptidePreview "<>$SessionUUID,"LysTyrAlaAla for PeptidePreview "<>$SessionUUID,"LysTyrAlaAlaAla for PeptidePreview "<>$SessionUUID}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PeptidePreview Test Oligomer Model "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"PeptidePreview Test Oligomer Model 1 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity2]}}],
				Association[Name->"PeptidePreview Test Oligomer Model 2 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity3]}}]
			}]
		]
	),
	SymbolTearDown:>{
		Quiet[EraseObject[$CreatedObjects,Force -> True,Verbose -> False]];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentPeptideSynthesisQ*)


DefineTests[
	ValidExperimentPeptideSynthesisQ,
	{
		Example[
			{Basic, "Validate an ExperimentPeptideSynthesis call to synthesize a single strand:"},
			ValidExperimentPeptideSynthesisQ[Model[Sample,"PeptideValidQ Test Oligomer Model "<>$SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentPeptideSynthesis call to synthesize multiple strands:"},
			ValidExperimentPeptideSynthesisQ[
				{
					Model[Sample,"PeptideValidQ Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptideValidQ Test Oligomer Model 2 "<>$SessionUUID]
				}
			],
			True
		],
		Example[
			{Options, OutputFormat, "Validate an ExperimentPeptideSynthesis call to synthesize a single strand, returning an ECL Test Summary:"},
			ValidExperimentPeptideSynthesisQ[Model[Sample,"PeptideValidQ Test Oligomer Model 1 "<>$SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentPeptideSynthesis call to synthesize a single strand, printing a verbose summary of tests as they are run:"},
			ValidExperimentPeptideSynthesisQ[Model[Sample,"PeptideValidQ Test Oligomer Model 2 "<>$SessionUUID], Verbose->True],
			True,
			TimeConstraint->180
		]
	},
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Module[{existsFilter,identity1,identity2,identity3,uploadOligomerModels},

			$CreatedObjects={};
			Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[
				{
					Model[Sample,"PeptideValidQ Test Oligomer Model "<>$SessionUUID],
					Model[Sample,"PeptideValidQ Test Oligomer Model 1 "<>$SessionUUID],
					Model[Sample,"PeptideValidQ Test Oligomer Model 2 "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAla for PeptideValidQ "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAla for PeptideValidQ "<>$SessionUUID],
					Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptideValidQ "<>$SessionUUID]
				}
			];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					{
						Model[Sample,"PeptideValidQ Test Oligomer Model "<>$SessionUUID],
						Model[Sample,"PeptideValidQ Test Oligomer Model 1 "<>$SessionUUID],
						Model[Sample,"PeptideValidQ Test Oligomer Model 2 "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAla for PeptideValidQ "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAla for PeptideValidQ "<>$SessionUUID],
						Model[Molecule,Oligomer,"LysTyrAlaAlaAla for PeptideValidQ "<>$SessionUUID]

					},
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
			(* create the identity models for the Model[Molecule,Oligomer]s *)
			{
				identity1,
				identity2,
				identity3
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
						ToStructure[Peptide["LysTyrAla"]],
						ToStructure[Peptide["LysTyrAlaAla"]],
						ToStructure[Peptide["LysTyrAlaAlaAla"]]
					},
					{Peptide,Peptide,Peptide},
					{"LysTyrAla for PeptidePreview "<>$SessionUUID,"LysTyrAlaAla for PeptideValidQ "<>$SessionUUID,"LysTyrAlaAlaAla for PeptideValidQ "<>$SessionUUID}
				}];


			(* Now that we have cleaned the database, let's make our test objects *)
			uploadOligomerModels=Upload[{
				Association[Name->"PeptideValidQ Test Oligomer Model "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity1]}}],
				Association[Name->"PeptideValidQ Test Oligomer Model 1 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity2]}}],
				Association[Name->"PeptideValidQ Test Oligomer Model 2 "<>$SessionUUID, DeveloperObject->True,Type->Model[Sample],State->Liquid,Replace[Composition]->{{100 MassPercent,Link[identity3]}}]
			}]
		]
	),
	SymbolTearDown:>{
		Quiet[EraseObject[$CreatedObjects,Force -> True,Verbose -> False]];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Unset[$CreatedObjects]
	}
];


(*::Section::Closed::*)
(*End Test Package*)
