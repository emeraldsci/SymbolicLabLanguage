(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Shared items for nucleic acid synthesis: Source*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsubsection:: *)
(*NNASharedSet Options*)

DefineOptionSet[NNASharedSet :>
	{
		(*Category->General*)
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, DNASynthesizer, "ABI 3900"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[
					{
						Model[Instrument, DNASynthesizer],
						Object[Instrument, DNASynthesizer]
					}
				],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Solid Phase Synthesis",
						"DNA/RNA Synthesis"
					}
				}
			],
			Description -> "The instrument used to perform the synthesis.",
			Category -> "Protocol"
		},
		{
			OptionName -> Scale,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> (EqualP[40 Nanomole] | EqualP[0.2 Micromole] | EqualP[1 Micromole])
			],
			Description -> "The theoretical amount of reaction sites available for synthesis.",
			ResolutionDescription -> "If Column is specified as an object, automatically set to the amount of reaction sites on the resin. Otherwise, automatically set to 0.2 Micromole",
			Category -> "Protocol"
		},
		(* Phosphoramidite Preparation *)
		{
			OptionName -> Phosphoramidites,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Adder[
				{
					"Monomer" -> Widget[Type -> Expression, Pattern :> SequenceP, Size -> Word],
					"Phosphoramidite" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Model[Sample, StockSolution]]
						],
						Adder[{
							"Component"->Widget[
								Type->Object,
								Pattern:>ObjectP[Model[Sample, StockSolution]]
							],
							"Component fraction"->Widget[
								Type -> Number,
								Pattern :> RangeP[0.01`, 1.`]
							]
						}],
						Adder[{
							"Component"->Widget[
								Type -> Expression,
								Pattern :> SequenceP,
								Size -> Word
							],
							"Component fraction"->Widget[
								Type -> Number,
								Pattern :> RangeP[0.01`, 1.`]
							]
						}]
					]
				}
			],
			Description -> "The phosphoramidite solutions used for each monomer.",
			ResolutionDescription -> "Set to default Stock Solution specified in SyntheticMonomers field of Model[Physics, Oligomer] for this type of oligomer.",
			Category -> "Phosphoramidites"
		},
		(* Initial Wash *)
		{
			OptionName -> NumberOfInitialWashes,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of washes at the start of the synthesis.",
			Category -> "Initial Wash"
		},
		{
			OptionName -> InitialWashTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between the washes at the start of the synthesis.",
			Category -> "Initial Wash"
		},
		{
			OptionName -> InitialWashVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of each wash at the start of the synthesis.",
			ResolutionDescription -> "Automatically set to 200 uL for the 40 nmol scale, 250 uL for the 200 nmol scale, 280 uL for the 1 umol scale.",
			Category -> "Initial Wash"
		},

		(* Deprotection (Detritylation) *)
		{
			OptionName -> NumberOfDeprotections,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of times that the detritylation solution is added to the resin after each cycle.",
			ResolutionDescription -> "Automatically set to 2 for 40 nmol and 200 nmol scales; automatically set to 3 for 1 umol scale.",
			Category -> "Deprotection"
		},
		{
			OptionName -> DeprotectionTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each detritylation iteration.",
			Category -> "Deprotection"
		},
		{
			OptionName -> DeprotectionVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of detritylation solvent used in each detritylation iteration.",
			ResolutionDescription -> "automatically set to 60 uL for the 40 nmol scale, 140 uL for the 200 nmol scale, 180 uL for the 1 umol scale.",
			Category -> "Deprotection"
		},


		(* Post-Deprotection Wash *)
		{
			OptionName -> NumberOfDeprotectionWashes,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of times the resin is washed after detritylation.",
			Category -> "Deprotection"
		},
		{
			OptionName -> DeprotectionWashTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between the post-detritylation washes.",
			Category -> "Deprotection"
		},
		{
			OptionName -> DeprotectionWashVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of each post-detritylation wash.",
			ResolutionDescription -> "Automatically set to 200 uL for the 40 nmol scale, 250 uL for the 200 nmol scale, 280 uL for the 1 umol scale.",
			Category -> "Deprotection"
		},

		(* Coupling *)
		{
			OptionName -> ActivatorSolution,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Oligonucleotide Synthesis",
						"Reagents"
					}
				}
			],
				Adder[Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Oligonucleotide Synthesis",
								"Reagents"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					]
				]],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic]
				]
			],
			Description -> "The solution that interacts with the phosphoramidite prior to attaching next monomer by protonating the diisopropylamino group of the nucleoside phosphoramidite, increasing the coupling reaction efficiency, typically a tetrazole derivative dissolved in acetonitrile.",
			ResolutionDescription -> "Automatically set Model[Sample, \"Activator\"].",
			Category -> "Coupling"
		},
		{
			OptionName -> ActivatorVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of activator solution used to increase coupling reaction efficiency of the amidite prior to attaching next monomer.",
			ResolutionDescription -> "automatically set to 40 uL for the 40 nmol scale, 45 uL for the 200 nmol scale, 115 uL for the 1 umol scale.",
			Category -> "Coupling"
		},

		{
			OptionName -> PhosphoramiditeVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 280 Microliter],
					Units -> {Microliter, {Microliter}}
				],
				Adder[
					{
						"Monomer" -> Widget[Type -> Expression, Pattern :> Alternatives[Modification[_], "Natural"], Size -> Word],
						"Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Microliter, 280 Microliter],
							Units -> {Microliter, {Microliter}}
						]
					}
				]
			],
			Description -> "The volume of phosphoramidite solution used in each attaching next monomer iteration for each monomer. A,U,G,C (specified by \"Natural\") must use the same phosphoramidite volume.",
			ResolutionDescription -> "Automatically set to 20 uL for the 40 nmol scale, 30 uL for the 200 nmol scale, 75 uL for the 1 umol scale.",
			Category -> "Coupling"
		},
		{
			OptionName -> NumberOfCouplings,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Number,
					Pattern :> RangeP[1, 5, 1]
				],
				Adder[
					{
						"Monomer" -> Widget[Type -> Expression, Pattern :> Alternatives[Modification[_], "Natural"], Size -> Word],
						"Couplings" -> Widget[
							Type -> Number,
							Pattern :> RangeP[1, 5, 1]
						]
					}
				]
			],
			Description -> "The number of next monomer attachment iterations for each monomer type. A,U,G,C (specified by \"Natural\") must use the same number of couplings.",
			ResolutionDescription -> "Automatically set to 1 for the 40 nmol scale, 2 for the 200 nmol scale, 3 for the 1 umol scale.",
			Category -> "Coupling"
		},
		{
			OptionName -> CouplingTime,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 30 Minute],
					Units -> {Second, {Second, Minute}}
				],
				Adder[
					{
						"Monomer" -> Widget[Type -> Expression, Pattern :> Alternatives[Modification[_], "Natural"], Size -> Word],
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Second, $MaxExperimentTime],
							Units -> {Second, {Second, Minute}}
						]
					}
				]
			],
			Description -> "The wait time between each next monomer attachment iteration for each monomer. A,U,G,C (specified by \"Natural\") must use the same next monomer attachment time.",
			ResolutionDescription -> "Automatically set to 6 minutes.",
			Category -> "Coupling"
		},

		(* Capping *)
		{
			OptionName -> CapASolution,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Oligonucleotide Synthesis",
						"Reagents"
					}
				}
			],
				Adder[Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Oligonucleotide Synthesis",
								"Reagents"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					]
				]],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic]
				]
			],
			Description -> "The solution (used in conjunction with Cap B Solution) used to passivate unreacted sites by acetylating free hydroxy sites, typically a mixture of tetrahydrofuran, lutidine, and acid anhydride.",
			ResolutionDescription -> "For RNA defaults to Ultramild Cap A, otherwise, defaults Cap A (based on acetic anhydride).",
			Category -> "Capping"
		},
		{
			OptionName -> CapBSolution,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Oligonucleotide Synthesis",
						"Reagents"
					}
				}
			],
				Adder[Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Oligonucleotide Synthesis",
								"Reagents"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					]
				]],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic]
				]
			],
			Description -> "The solution (used in conjunction with Cap A Solution) used to passivate unreacted sites by acetylating free hydroxy sites, typically a solution of 1-methylimidazole in tetrahydrofuran.",
			ResolutionDescription -> "Automatically default to Model[Sample, \"Capping solution B\"].",
			Category -> "Capping"
		},

		{
			OptionName -> NumberOfCappings,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of passivation iterations on each synthesis cycle.",
			Category -> "Capping"
		},
		{
			OptionName -> CapTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each passivation iteration.",
			Category -> "Capping"
		},
		{
			OptionName -> CapAVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of Cap A solution used in each passivation iteration.",
			ResolutionDescription -> "Automatically set to 20 uL for the 40 nmol scale, 30 uL for the 200 nmol scale, 80 uL for the 1 umol scale.",
			Category -> "Capping"
		},
		{
			OptionName -> CapBVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of Cap B solution used in each passivation iteration.",
			ResolutionDescription -> "Automatically set to 20 uL for the 40 nmol scale, 30 uL for the 200 nmol scale, 80 uL for the 1 umol scale.",
			Category -> "Capping"
		},

		(* Oxidation *)
		{
			OptionName -> OxidationSolution,
			Default -> Model[Sample, "Oxidizer"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Oligonucleotide Synthesis",
						"Reagents"
					}
				}
			],
			Description -> "The solution used to oxidize phosphorus(III) linker into phosphate, typically a solution of Iodine in THF with Pyridine and water.",
			Category -> "Oxidation"
		},
		{
			OptionName -> NumberOfOxidations,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of oxidation iterations.",
			Category -> "Oxidation"
		},
		{
			OptionName -> OxidationTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each oxidation iteration.",
			Category -> "Oxidation"
		},
		{
			OptionName -> OxidationVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of oxidation solution used in each oxidation iteration.",
			ResolutionDescription -> "Automatically set to 30 uL for the 40 nmol scale, 60 uL for the 200 nmol scale, 150 uL for the 1 umol scale.",
			Category -> "Oxidation"
		},

		(* Post-Oxidation Wash *)
		{
			OptionName -> NumberOfOxidationWashes,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of washes following oxidation.",
			Category -> "Oxidation"
		},
		{
			OptionName -> OxidationWashTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each post-oxidation wash.",
			Category -> "Oxidation"
		},
		{
			OptionName -> OxidationWashVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of wash solution for each post-oxidation wash.",
			ResolutionDescription -> "Automatically set to 200 uL for the 40 nmol scale, 250 uL for the 200 nmol scale, 280 uL for the 1 umol scale.",
			Category -> "Oxidation"
		},

		(* Secondary Oxidation *)
		{
			OptionName -> SecondaryOxidationSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Oligonucleotide Synthesis",
						"Reagents"
					}
				}
			],
			Description -> "The solution used to oxidize phosphorus(III) linker after coupling in the secondary set of cycle parameters.",
			ResolutionDescription -> "If SecondaryCyclePositions is specified as Null, resolves to Null, otherwise resolves to Model[Sample, \"Oxidizer\"].",
			Category -> "Oxidation"
		},
		{
			OptionName -> SecondaryNumberOfOxidations,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of oxidation iterations in the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		{
			OptionName -> SecondaryOxidationTime,
			Default -> 60 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 20 Minute],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each oxidation iteration in the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		{
			OptionName -> SecondaryOxidationVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of oxidation solution used in each oxidation iteration in the secondary set of cycle parameters.",
			ResolutionDescription -> "Automatically set to 30 uL for the 40 nmol scale, 60 uL for the 200 nmol scale, 150 uL for the 1 umol scale.",
			Category -> "Oxidation"
		},


		(* Post-Oxidation Wash *)
		{
			OptionName -> SecondaryNumberOfOxidationWashes,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of washes following oxidation in the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		{
			OptionName -> SecondaryOxidationWashTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between each post-oxidation wash in the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		{
			OptionName -> SecondaryOxidationWashVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of wash solution for each post-oxidation wash in the secondary set of cycle parameters.",
			ResolutionDescription -> "Automatically set to 200 uL for the 40 nmol scale, 250 uL for the 200 nmol scale, 280 uL for the 1 umol scale.",
			Category -> "Oxidation"
		},

		(* Final Wash *)
		{
			OptionName -> NumberOfFinalWashes,
			Default -> 4,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 10, 1]
			],
			Description -> "The number of washes at the end of the synthesis.",
			Category -> "Final Wash"
		},
		{
			OptionName -> FinalWashTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, $MaxExperimentTime],
				Units -> {Second, {Second, Minute}}
			],
			Description -> "The wait time between the washes at the end of the synthesis.",
			Category -> "Final Wash"
		},
		{
			OptionName -> FinalWashVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 280 Microliter],
				Units -> {Microliter, {Microliter}}
			],
			Description -> "The volume of each wash at the start of the synthesis.",
			ResolutionDescription -> "Automatically set to 200 uL for the 40 nmol scale, 250 uL for the 200 nmol scale, 280 uL for the 1 umol scale.",
			Category -> "Final Wash"
		},


		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Columns,
				Default -> Model[Sample, "UnySupport"],
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample], Model[Resin]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Oligonucleotide Synthesis",
							"Resins"
						}
					}
				],
				Description -> "The solid support on which the synthesis is carried out.",
				Category -> "Protocol"
			},
			{
				OptionName -> FinalDeprotection,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if a final deprotection (detritylation) step is done following the last synthesis cycle.",
				Category -> "Deprotection"
			},
			{
				OptionName -> Cleavage,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if each oligomer should be cleaved and filtered from the resin after synthesis.",
				ResolutionDescription -> "Automatically set to True unless StorageSolvent or StorageSolventVolume are specified.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageMethod,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{Object[Method, Cleavage]}
					]
				],
				Description -> "The methods defining the cleavage conditions for each oligomer. If a provided method conflicts with the other cleavage options, the specified cleavage options overwrite the corresponding conditions specified by the method.",
				ResolutionDescription -> "If the strand is being cleaved, automatically set to a cleavage method based on the values of the other cleavage options.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Hour, $MaxExperimentTime],
					Units -> {Hour, {Second, Minute, Hour}}
				],
				Description -> "The length of time the strands are incubated in cleavage solution.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the time used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to 8 hours.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Celsius, 100 Celsius],
					Units -> {Celsius, {Celsius}}
				],
				Description -> "The temperature at which the strands are incubated in cleavage solution.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the temperature used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to 55C.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials"
						}
					}
				],
				Description -> "The cleavage solution in which the strands cleaved.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the cleavage solution used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to ammonium hydroxide.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageSolutionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 1 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "The volume of cleavage solution in which the strands are cleaved.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the cleavage solution volume used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to 800 uL.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageWashSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials"
						}
					}
				],
				Description -> "The solution used to wash the solid support following cleavage.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the cleavage wash solution used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to RNAse-free water.",
				Category -> "Cleavage"
			},
			{
				OptionName -> CleavageWashVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 0.8 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "The volume of solution used to wash the solid support following cleavage.",
				ResolutionDescription -> "If the strand is being cleaved and CleavageMethod is specified, automatically set based on the cleavage solution volume used in the specified method. If the strand is being cleaved and CleavageMethod is not specified, automatically set to 500 uL.",
				Category -> "Cleavage"
			},

			{
				OptionName -> StorageSolvent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials"
						}
					}
				],
				Description -> "The solution that uncleaved resin is stored in following synthesis.",
				ResolutionDescription -> "If the strand is not being cleaved, automatically set to water.",
				Category -> "Cleavage"
			},
			{
				OptionName -> StorageSolventVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 1 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "The amount of solvent that uncleaved resin is stored in post-synthesis.",
				ResolutionDescription -> "If the strand is not being cleaved, automatically set 200 uL for the 40 nmol scale, 400 uL for the 200 nmol scale, 1 mL for the 1 umol scale.",
				Category -> "Cleavage"
			},

			{
				OptionName -> SecondaryCyclePositions,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Expression,
					Pattern :> ListableP[_Integer],
					Size-> Line
				],
				Description -> "Positions that should use the secondary cycle parameters (Lower Case).",
				Category -> "Oxidation"
			},

			{
				OptionName -> FinalSequences,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Molecule, Oligomer]}]
				],
				Description -> "Sequences for the final samples.",
				Category -> "Hidden"
			}
		],

		{
			OptionName -> PhosphoramiditeDesiccants,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if desiccant packets should be added to the phosphoramidite bottles.",
			Category -> "Phosphoramidites"
		},

		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "Number of times each of the input strands should be synthesized using identical experimental parameters.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]]
		},


		(* Storage Conditions *)
		(* Currently there is no point in using these sotrage consitions as they are not relevant while Unsealed expiration is 1 day *)

		IndexMatching[
			IndexMatchingParent->Phosphoramidites,
			{
				OptionName->PhosphoramiditeStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Phosphoramidites of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Hidden"
			}
		],
		IndexMatching[
			IndexMatchingParent->ActivatorSolution,
			{
				OptionName->ActivatorSolutionStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for ActivatorSolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				(*Category->"Storage Conditions"*)
				Category->"Hidden"
			}
		],
		IndexMatching[
			IndexMatchingParent->CapASolution,
			{
				OptionName->CapASolutionStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CapASolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				(*Category->"Storage Conditions"*)
				Category->"Hidden"
			}
		],
		IndexMatching[
			IndexMatchingParent->CapBSolution,
			{
				OptionName->CapBSolutionStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CapBSolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				(*Category->"Storage Conditions"*)
				Category->"Hidden"
			}
		],
		{
			OptionName->OxidationSolutionStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for OxidationSolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			(*Category->"Storage Conditions"*)
			Category->"Hidden"
		},
		{
			OptionName->SecondaryOxidationSolutionStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for SecondaryOxidationSolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			(*Category->"Storage Conditions"*)
			Category->"Hidden"
		}
	}
];

(* ::Subsubsection:: *)
(*RNA-specific options Messages *)
DefineOptionSet[RNASynthesisOptions:>{
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> PostCleavageDesalting,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the oligomers are desalted after cleavage.",
			ResolutionDescription -> "Automatically set to False if none of the Desalting options are specified.",
			Category -> "Cleavage"
		},

		{
			OptionName -> PostCleavageDesaltingSampleLoadRate,
			Default -> Automatic,
			Description -> "The rate at which each oligomer sample is dispensed into the ExtractionCartridge.",
			ResolutionDescription -> "Automatically set to 3 Milliliter/Minute.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostCleavageDesaltingRinseAndReload,
			Default -> Automatic,
			Description -> "Indicates if each individual sample source well is rinsed with ConditioningSolution which is then transferred to the ExtractionCartridge that corresponds to the sample pool to improve sample recovery.",
			ResolutionDescription -> "Automatically set to True.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> PostCleavageDesaltingRinseAndReloadVolume,
			Default -> Automatic,
			Description -> "The volume of PostCleavageDesaltingEquilibrationBuffer added to the source well of each individual oligomer in order to recover more of the sample.",
			ResolutionDescription -> "Automatically set to 0.5*Milliliter if PostCleavageDesaltingRinseAndReload has been specified as True.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 2 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter}}}
			]
		},
		{
			OptionName -> PostCleavageDesaltingType,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[ReversePhase]
			],
			Description -> "The type of desalting separation that is used for each oligomer.",
			ResolutionDescription -> "Automatically set to ReversePhase."
		},
		{
			OptionName -> PostCleavageDesaltingCartridge,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Container, ExtractionCartridge], Model[Container, ExtractionCartridge]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Solid Phase Extraction (SPE)",
						"ExtractionCartridges"
					}
				}
			],
			Description -> "The sorbent-packed container that forms the stationary phase for desalting for each sample pool.",
			ResolutionDescription -> "Automatically set to Model[Container,ExtractionCartridge,\"500mg, 3cc, C18, Vac extraction cartridge\"].",
			Category -> "PostCleavageDesalting"
		},
		{
			OptionName -> PostCleavageDesaltingPreFlushVolume,
			Default -> Automatic,
			Description -> "The amount of PostCleavageDesaltingPreFlushBuffer with which each ExtractionCartridge is washed prior to oligomer loading. No flush is performed if set to Null.",
			ResolutionDescription -> "If neither the PostCleavageDesaltingPreFlushBuffer nor the corresponding PostCleavageDesaltingPreFlushRate have been specified as Null, the PostCleavageDesaltingPreFlushVolume is automatically set to 5 times of the MaxVolume of the selected ExtractionCartridge or 17.5 Milliliter (5 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller. Otherwise, the option is set to Null.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 520 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostCleavageDesaltingPreFlushRate,
			Default -> Automatic,
			Description -> "The rate at which the PostCleavageDesaltingPreFlushBuffer flows onto the column during the flush step of desalting.",
			ResolutionDescription -> "If neither the PostCleavageDesaltingPreFlushBuffer nor the corresponding PostCleavageDesaltingPreFlushVolume have been specified as Null, the PostCleavageDesaltingPreFlushRate is automatically set to 5 mL/min. Otherwise, the option is set to Null.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostCleavageDesaltingEquilibrationVolume,
			Default -> Automatic,
			Description -> "The amount of PostCleavageDesaltingEquilibrationBuffer with which each ExtractionCartridge is washed prior to oligomer loading.",
			ResolutionDescription -> "The PostCleavageDesaltingEquilibrationVolume is automatically set to 5 times of the MaxVolume of the selected ExtractionCartridge or 17.5 Milliliter (5 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 520 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostCleavageDesaltingEquilibrationRate,
			Default -> Automatic,
			Description -> "The rate at which the PostCleavageDesaltingEquilibrationBuffer flows onto the column during the equilibration step of desalting.",
			ResolutionDescription -> "Automatically set to 3 Milliliter/Minute",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostCleavageDesaltingElutionVolume,
			Default -> Automatic,
			Description -> "The volume of the PostCleavageDesaltingElutionBuffer that is used during the collection step of desalting.",
			ResolutionDescription -> "The PostCleavageDesaltingElutionVolume is automatically set to the MaxVolume of the selected ExtractionCartridge or 3.5 Milliliter (the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 3.5 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostCleavageDesaltingElutionRate,
			Default -> Automatic,
			Description -> "The rate at which the PostCleavageDesaltingElutionBuffer flows onto the column during the elution step of desalting.",
			ResolutionDescription -> "Automatically set to 5 Milliliter/Minute",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostCleavageDesaltingWashVolume,
			Default -> Automatic,
			Description -> "The volume of PostCleavageDesaltingWashBuffer that the cartridges are rinsed with after the oligomers are loaded.",
			ResolutionDescription -> "The PostCleavageDesaltingWashVolume is automatically set to 10 times of the MaxVolume of the selected ExtractionCartridge or 35 Milliliter (10 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 8000 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostCleavageDesaltingWashRate,
			Default -> Automatic,
			Description -> "The rate at which the PostCleavageDesaltingWashBuffer flows onto the column during the equilibration and wash step of desalting.",
			ResolutionDescription -> "Automatically set to 5 Milliliter/Minute.",
			AllowNull -> True,
			Category -> "PostCleavageDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostCleavageEvaporation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if each oligomer is dried after having 2-OH protective group removed.",
			ResolutionDescription -> "Automatically set to True if cleavage is happening.",
			Category -> "Cleavage"
		},

		{
			OptionName -> RNADeprotection,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if each oligomer has protection group from 2-OH removed.",
			ResolutionDescription -> "Automatically set to True if strands are being cleaved and no Deprotection options set as Null.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionMethod,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[
					{Object[Method, RNADeprotection]}
				]
			],
			Description -> "The 2-OH deprotection methods used to specify the 2-OH deprotection conditions for each oligomer. If a provided method conflicts with the other RNA Deprotection options, the specified RNA Deprotection options overwrites the corresponding conditions specified by the method.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed, automatically set to RNA Deprotection method based on the values of the other cleavage options.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, $MaxExperimentTime],
				Units -> {Hour, {Second, Minute, Hour}}
			],
			Description -> "The length of time the strands are incubated in the RNA Deprotection solution.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the time used in the specified method. If the strand is having 2-OH protection removed and RNADeprotectionMethod is not specified, automatically automatically set to 10 minutes.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Celsius, 65 Celsius],
				Units -> {Celsius, {Celsius}}
			],
			Description -> "The temperature at which the strands are incubated in RNA deprotection solution.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the temperature used in the specified method. If the strand is being cleaved and RNADeprotectionMethod is not specified, automatically set to 65C.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionResuspensionSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents"
					}
				}
			],
			Description -> "Solvent used to resuspend oligomers after the clevage.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the RNADeprotectionResuspensionSolution used in the specified method. If the strand is having 2-OH protection removed and RNADeprotectionMethod is not specified, automatically set to DMSO.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionResuspensionSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milliliter, 1 Milliliter],
				Units -> {Milliliter, {Microliter, Milliliter}}
			],
			Description -> "The volume of solvent used to resuspend oligomers after the clevage.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the value from the specified method. If the strand is being cleaved and RNADeprotectionMethod is not specified, automatically set to 100 uL.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionResuspensionTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, $MaxExperimentTime],
				Units -> {Hour, {Second, Minute, Hour}}
			],
			Description -> "The length of time the strands are incubated in the RNA Deprotection resuspension solution.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the time used in the specified method. If the strand is having 2-OH protection removed and RNADeprotectionMethod is not specified, automatically automatically set to 5 minutes.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionResuspensionTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Celsius, 65 Celsius],
				Units -> {Celsius, {Celsius}}
			],
			Description -> "The temperature at which the strands are incubated in RNA deprotection resuspension solution.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the temperature used in the specified method. If the strand is being cleaved and RNADeprotectionMethod is not specified, automatically set to 55C.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			],
			Description -> "The volume of RNA Deprotection solution used to remove 2-OH protective group.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the RNA Deprotection solution used in the specified method. If the strand is having 2-OH protection removed and RNADeprotectionMethod is not specified, automatically set to TEA with TEAx3HF in DMSO.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milliliter, 1 Milliliter],
				Units -> {Milliliter, {Microliter, Milliliter}}
			],
			Description -> "The volume of RNA Deprotection solution in which 2-OH protective group is being removed.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the value from the specified method. If the strand is being cleaved and RNADeprotectionMethod is not specified, automatically set to 125 uL.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionQuenchingSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents"
					}
				}
			],
			Description -> "The solution for quenching the 2-OH protective group deprotection reaction.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the RNADeprotectionQuenchingSolution used in the specified method. If the strand is having 2-OH protection removed and RNADeprotectionMethod is not specified, automatically set to TRIS buffer.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> RNADeprotectionQuenchingSolutionVolume,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milliliter, 1.75 Milliliter],
				Units -> {Milliliter, {Microliter, Milliliter}}
			],
			Description -> "The volume of RNA Deprotection Quenching solution used to stop the deprotection reaction.",
			ResolutionDescription -> "If the strand is having 2-OH protection removed and RNADeprotectionMethod is specified, automatically set based on the value from the specified method. If the strand is being cleaved and RNADeprotectionMethod is not specified, automatically set to 1750 uL.",
			Category -> "RNADeprotection"
		},

		{
			OptionName -> PostRNADeprotectionEvaporation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if each oligomer is dried after having 2-OH protective group removed.",
			ResolutionDescription -> "Automatically set to True if RNADeprotection is happening.",
			Category -> "RNADeprotection"
		},
		{
			OptionName -> PostRNADeprotectionDesalting,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the oligomers should be desalted after removing 2-OH protective group and drying.",
			ResolutionDescription -> "Automatically set to False unless related options are specified.",
			Category -> "RNADeprotection"
		},

		{
			OptionName -> PostRNADeprotectionDesaltingSampleLoadRate,
			Default -> Automatic,
			Description -> "The rate at which each oligomer sample is dispensed into the ExtractionCartridge.",
			ResolutionDescription -> "Automatically set to 3 Milliliter/Minute.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingRinseAndReload,
			Default -> Automatic,
			Description -> "Indicates if each individual sample source well is rinsed with ConditioningSolution which is then transferred to the ExtractionCartridge that corresponds to the sample pool to improve sample recovery.",
			ResolutionDescription -> "Automatically set to True.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingRinseAndReloadVolume,
			Default -> Automatic,
			Description -> "The volume of PostRNADeprotectionDesaltingEquilibrationBuffer added to the source well of each individual oligomer in order to recover more of the sample.",
			ResolutionDescription -> "Automatically set to 0.5*Milliliter if PostRNADeprotectionDesaltingRinseAndReload has been specified as True.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 2 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter}}}
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingType,
			Default -> Automatic,
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[ReversePhase]
			],
			Description -> "The type of desalting separation that is used for each oligomer.",
			ResolutionDescription -> "Automatically set to ReversePhase."
		},
		{
			OptionName -> PostRNADeprotectionDesaltingCartridge,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Container, ExtractionCartridge], Model[Container, ExtractionCartridge]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Solid Phase Extraction (SPE)",
						"ExtractionCartridges"
					}
				}
			],
			Description -> "The sorbent-packed container that forms the stationary phase for desalting for each sample pool.",
			ResolutionDescription -> "Automatically set to Model[Container,ExtractionCartridge,\"500mg, 3cc, C18, Vac extraction cartridge\"].",
			Category -> "PostRNADeprotectionDesalting"
		},
		{
			OptionName -> PostRNADeprotectionDesaltingPreFlushVolume,
			Default -> Automatic,
			Description -> "The amount of PostRNADeprotectionDesaltingPreFlushBuffer with which each ExtractionCartridge is washed prior to oligomer loading. No flush is performed if set to Null.",
			ResolutionDescription -> "If neither the PostRNADeprotectionDesaltingPreFlushBuffer nor the corresponding PostRNADeprotectionDesaltingPreFlushRate have been specified as Null, the PostRNADeprotectionDesaltingPreFlushVolume is automatically set to 5 times of the MaxVolume of the selected ExtractionCartridge or 17.5 Milliliter (5 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller. Otherwise, the option is set to Null.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 520 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingPreFlushRate,
			Default -> Automatic,
			Description -> "The rate at which the PostRNADeprotectionDesaltingPreFlushBuffer flows onto the column during the flush step of desalting.",
			ResolutionDescription -> "If neither the PostRNADeprotectionDesaltingPreFlushBuffer nor the corresponding PostRNADeprotectionDesaltingPreFlushVolume have been specified as Null, the PostRNADeprotectionDesaltingPreFlushRate is automatically set to 5 mL/min. Otherwise, the option is set to Null.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingEquilibrationVolume,
			Default -> Automatic,
			Description -> "The amount of PostRNADeprotectionDesaltingEquilibrationBuffer with which each ExtractionCartridge is washed prior to oligomer loading.",
			ResolutionDescription -> "The PostRNADeprotectionDesaltingEquilibrationVolume is automatically set to 5 times of the MaxVolume of the selected ExtractionCartridge or 17.5 Milliliter (5 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 520 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingEquilibrationRate,
			Default -> Automatic,
			Description -> "The rate at which the PostRNADeprotectionDesaltingEquilibrationBuffer flows onto the column during the equilibration step of desalting.",
			ResolutionDescription -> "Automatically set to 3 Milliliter/Minute",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingElutionVolume,
			Default -> Automatic,
			Description -> "The volume of the PostRNADeprotectionDesaltingElutionBuffer used during the collection step of desalting.",
			ResolutionDescription -> "The PostRNADeprotectionDesaltingElutionVolume is automatically set to the MaxVolume of the selected ExtractionCartridge or 3.5 Milliliter (the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 3.5 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingElutionRate,
			Default -> Automatic,
			Description -> "The rate at which the PostRNADeprotectionDesaltingElutionBuffer flows onto the column during the elution step of desalting.",
			ResolutionDescription -> "Automatically set to 5 Milliliter/Minute",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingWashVolume,
			Default -> Automatic,
			Description -> "The volume of PostRNADeprotectionDesaltingWashBuffer that the cartridges is rinsed with after the oligomers are loaded.",
			ResolutionDescription -> "The PostRNADeprotectionDesaltingWashVolume is automatically set to 10 times of the MaxVolume of the selected ExtractionCartridge or 35 Milliliter (10 times of the MaxVolume of Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"], the collection plate for eluted samples from SPE cartridges), whichever is smaller.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 * Milliliter, 8000 * Milliliter],
				Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
			]
		},
		{
			OptionName -> PostRNADeprotectionDesaltingWashRate,
			Default -> Automatic,
			Description -> "The rate at which the PostRNADeprotectionDesaltingWashBuffer flows onto the column during the equilibration and wash step of desalting.",
			ResolutionDescription -> "Automatically set to 5 Milliliter/Minute.",
			AllowNull -> True,
			Category -> "PostRNADeprotectionDesalting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.01 * Milliliter / Minute, 45 * Milliliter / Minute],
				Units -> CompoundUnit[{1, {Milliliter, {Milliliter, Liter}}}, {-1, {Minute, {Minute, Second}}}]
			]
		}
	],

	{
		OptionName -> PostCleavageDesaltingInstrument,
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{
				Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler],
				Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]
			}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"Instruments"
				}
			}
		],
		Description -> "The liquid handling instrument used for desalting after cleavage.",
		ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"GX-271 for Solid Phase Extraction\"].",
		Category -> "PostCleavageDesalting"
	},
	{
		OptionName -> PostRNADeprotectionDesaltingInstrument,
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{
				Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler],
				Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]
			}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"Instruments"
				}
			}
		],
		Description -> "The liquid handling instrument used for desalting after removing protection from 2-OH group.",
		ResolutionDescription -> "Automatically set to Model[Instrument, LiquidHandler, \"GX-271 for Solid Phase Extraction\"].",
		Category -> "PostRNADeprotectionDesalting"
	},
	{
		OptionName -> PostCleavageDesaltingPreFlushBuffer,
		Default -> Automatic,
		Description -> "The solution that is used to wash the sorbent in the ExtractionCartridge of any residues before adding the ConditioningSolution in desalting steps.",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"90% methanol\"] if PostCleavageDesaltingPreFlushVolume and PostCleavageDesaltingPreFlushRate are not both Null, and to Null otherwise",
		AllowNull -> True,
		Category -> "PostCleavageDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"PreFlushing Solution"
				}
			}
		]
	},
	{
		OptionName -> PostCleavageDesaltingEquilibrationBuffer,
		Default -> Automatic,
		Description -> "The solution that is used to wet and condition the sorbent in the ExtractionCartridge before oligomers are added to the corresponding ExtractionCartridge in order to ensure consistent interaction between the solid phase and the samples.",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"15 mM ammonium acetate\"].",
		AllowNull -> True,
		Category -> "PostCleavageDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)"
				}
			}
		]
	},
	{
		OptionName -> PostCleavageDesaltingWashBuffer,
		Default -> Automatic,
		Description -> "The wash solution that is used in desalting to elute any impurities present in the oligomers that do not stick to the sorbent off the cartridge prior to oligomer elution.",
		ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"].",
		AllowNull -> True,
		Category -> "PostCleavageDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)"
				},
				{
					Object[Catalog, "Root"],
					"Materials",
					"Reagents",
					"Water"
				}
			}
		]
	},
	{
		OptionName -> PostCleavageDesaltingElutionBuffer,
		Default -> Automatic,
		Description -> "The elution solution that is used to disrupt the interaction between the oligomers and the sorbet and elute it into the collection container (Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"]).",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"90% methanol\"].",
		AllowNull -> True,
		Category -> "PostCleavageDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"Elution Buffers"
				}
			}
		]
	},

	{
		OptionName -> PostRNADeprotectionDesaltingPreFlushBuffer,
		Default -> Automatic,
		Description -> "The solution that is used to wash the sorbent in the ExtractionCartridge of any residues before adding the ConditioningSolution in desalting steps.",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"90% methanol\"] if PostRNADeprotectionDesaltingPreFlushVolume and PostRNADeprotectionDesaltingPreFlushRate are not both Null, and to Null otherwise",
		AllowNull -> True,
		Category -> "PostRNADeprotectionDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)"
				}
			}
		]
	},
	{
		OptionName -> PostRNADeprotectionDesaltingEquilibrationBuffer,
		Default -> Automatic,
		Description -> "The solution that is used to wet and condition the sorbent in the ExtractionCartridge before oligomers are added to the corresponding ExtractionCartridge in order to ensure consistent interaction between the solid phase and the samples.",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"15 mM ammonium acetate\"].",
		AllowNull -> True,
		Category -> "PostRNADeprotectionDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)"
				}
			}
		]
	},
	{
		OptionName -> PostRNADeprotectionDesaltingWashBuffer,
		Default -> Automatic,
		Description -> "The wash solution that is used in desalting to elute any impurities present in the oligomers that do not stick to the sorbent off the cartridge prior to oligomer elution.",
		ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"].",
		AllowNull -> True,
		Category -> "PostRNADeprotectionDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)"
				},
				{
					Object[Catalog, "Root"],
					"Materials",
					"Reagents",
					"Water"
				}
			}
		]
	},
	{
		OptionName -> PostRNADeprotectionDesaltingElutionBuffer,
		Default -> Automatic,
		Description -> "The elution solution that is used to disrupt the interaction between the oligomers and the sorbet and elute it into the collection container (Model[Container, Plate, \"48-well Pyramid Bottom Deep Well Plate\"]).",
		ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"90% methanol\"].",
		AllowNull -> True,
		Category -> "PostRNADeprotectionDesalting",
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			OpenPaths -> {
				{
					Object[Catalog, "Root"],
					"Materials",
					"Solid Phase Extraction (SPE)",
					"Elution Buffers"
				}
			}
		]
	}
}];

DefineOptions[experimentNNASynthesis,
	Options :> {
		NNASharedSet,
		RNASynthesisOptions,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		ProtocolOptions,
		NonBiologyPostProcessingOptions,
		SamplesOutStorageOptions
	}
];

(* ::Subsubsection:: *)
(*experimentNNASynthesis Messages *)


Error::InvalidPolymer = "The provided models `1` contain non-`2` polymer types. Only models with `2` and Modification polymer types can be synthesized. To see the polymer type, run PolymerType[] on your inputs.";
Error::InvalidStrands = "The provided models `1` have more than one `2` strand per model. Only single stranded `2` can be synthesized. If you would like to synthesize a multi-strand model, please submit each strand as separate input and combine them after the synthesis.";
Error::TooManyModifications = "There are more unique modifiers in input models than can fit on the instrument. The MaxModifications for `1` is `2`. If your unique modifications are spread across strands, consider enqueuing multiple syntheses. Models with more than 3 unique modifications cannot be synthesized.";
Error::TooManyOligomers = "There are more inputs to synthesize than there are available spots on the instrument. The MaxColumns for `1` is `2`. Please submit fewer strands/replicates.";
Error::MonomerPhosphoramiditeConflict = "The monomers `1` were specified multiple times with different chemicals. Please check your Phosphoramidites option value and make sure that each unique monomer only points to one chemical.";
Warning::UnknownMonomer = "The phosphoramidite to use for the monomers `1` which are in the strands `2` could not be determined. Please specify the phosphoramidite to use for the monomer in the Phosphoramidites option, or synthesize oligomers that do not use this monomer.";
Error::NoAutomaticStock = "For the Phosphoramidite `1` StockSolution to be used was not specified and we were not able to create it automatically. Please specify the StockSolution for it manually.";
Error::MonomerNumberOfCouplingsConflict = "The monomers `1` were specified multiple times with different number of couplings. Please check your NumberOfCouplings option value and make sure that each unique monomer only points to one value.";
Error::MonomerPhosphoramiditeVolumeConflict = "The monomers `1` were specified multiple times with different volumes. Please check your PhosphoramiditeVolumes option value and make sure that each unique monomer only points to one volume.";
Error::MonomerCouplingTimeConflict = "The monomers `1` were specified multiple times with different times. Please check your CouplingTime option value and make sure that each unique monomer only points to one time.";
Error::InvalidResins = "The resins provided `1` are missing loading or mass information. Please ensure all Object[Sample]s provided as columns have a mass and point to a Model[Resin] with Loading information in their composition.";
Warning::MismatchedColumnAndScale = "The amount of active sites `1` available on `2` disagrees with the specified scale `3`. Be advised that options that automatically resolve based on scale may not be optimal for the amount of resin used. The experiment will proceed with the specified options.";
Warning::ColumnLoadingsDiffer = "The amount of active sites `1` available on `2` are not equal. Be advised that options that automatically resolve based on scale may not be optimal for the amount of resin used. The experiment will proceed with the specified options.";
Error::CleavageOptionSetConflict = "Option values for `1` and `2` were both specified as `3` values for the inputs `4`. The first set of options is used to cleave the oligomer from the solid support while the second set is used if the oligomer should remain the solid support. Please modify your options to specify only one of these option sets with `3` values.";
Error::CleavageConflict = "Cleavage is specified as `1` but the options `2` were specified as `3` values for the inputs `4`. These options may only be specified as `3` values if cleavage is `5`.";
Error::MismatchedColumnAndStrand = "The specified columns `1` are preloaded with the oligomer `2`, which doesn't match the 3' end of the oligomers being synthesized `3`. Please specify a different column or a different input oligomer, or allow the Columns option to resolve Automatically.";
Error::ReusedColumn = "The same column object was specified more than once. A unique column must be used for each strand. Please specify unique column objects or specify a column model or allow the Column option the be automatically resolved.";
Error::DeprotectionConflict = "RNADeprotection is specified as `1` but the options `2` were specified as `3` values for the inputs `4`. These options may only be specified as `3` values if RNADeprotection is `5`.";
Error::PostCleavageDesaltingSetConflict = "PostCleavageDesalting is specified as `1` but the options `2` were specified as `3` values for the inputs `4`. These options may only be specified as `3` values if cleavage is `5`.";
Error::DesaltingPriorToCleavage = "For input `1` PostCleavageDesalting was specified as `2` even though the Cleavage was specified or set to `3`";
Error::DeprotectingWithoutResuspension = "RNADeprotection is set as `1` while options for RNADeprotectionResuspension are set to `2` for the input `3`.";
Error::DesaltingPriorToDeprotection = "For input `1` PostRNADeprotectionDesalting was specified as `2` even though the RNADeprotection was specified or set to `3`";
Error::NoEvaporationDeprotection = "For input `1` RNADeprotection was specified as `2` but PostCleavageEvaporation was specified or set to `3`";
Error::MismatchDeckReagentBanks = "The specified `1` is not compatible with the number of banks that will be used in this experiment. The first 24 samples use Banks 1 and 3 and the subsequent 24 samples use Banks 2 and 4. The odd banks share one set of deck reagents as do the even banks. Pleae make sure sure to either specify the correct number of objects (`2`).";


(* ::Subsubsection:: *)
(*experimentNNASynthesis *)
(* joint experiment function for DNA and RNA synthesis *)

experimentNNASynthesis[myPolymer:(DNA|RNA), myStrands : ListableP[Alternatives[ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], SequenceP, StrandP, StructureP]], myOptions : OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, resolvedOptionsResult, resolvedOptions,
		resolvedOptionsTests, collapsedResolvedOptions, cacheBall, resourcePacketTests,
		protocolObject, specifiedSynthesizer, synthesizerFieldsToDownload, specifiedColumns, columnObjects, columnModels,
		amiditesModelsToDownload, amiditeObjectsToDownload, resourceFunctionPackets, listedInputs,
		cacheOp, downloadedStuff, sampleInputFields, columnObjectFields, columnModelFields,
		amiditesModelFieldsToDownload, amiditeObjectFieldsToDownload,
		nonModelInputs, moleculeInputs, hasNonModelInputs, structuredNonModelInputs, newIdentityModelPackets, newIdentityModels,
		newModelsForStrands, newModelsForMolecules, inputToModelLookup, inputWithGeneratedModels, newModelForStrandsCache,
		newModelForMoleculeCache, newCache, newModels, columnResinModelFields, columnResinModels, returnEarlyQ,
		inputRulesSMolecules, inputRulesSSamples, inputRulesSMoleculeToSample, inputMoleculesToModels, listedInputsNamed,
		listedOptionsNamed, safeOpsNamed, ruturnOptions
	},

	(* Make sure we're working with a list of options and inputs *)
	{listedInputsNamed, listedOptionsNamed} = removeLinks[ToList[myStrands], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[experimentNNASynthesis, listedOptionsNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[experimentNNASynthesis, listedOptionsNamed, AutoCorrect -> False], {}}
	];

	(* change named objects to IDs *)
	{listedInputs, safeOps, listedOptions} = sanitizeInputs[listedInputsNamed, safeOpsNamed, listedOptionsNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* before we go further, will need to make models for any non-model input creating a new oligomer sample *)
	(* pull out all the non model inputs*)
	nonModelInputs = Cases[listedInputs, Except[ObjectP[]]];
	moleculeInputs = Cases[listedInputs, ObjectP[Model[Molecule, Oligomer]]];
	hasNonModelInputs = Not[MatchQ[nonModelInputs, {}]];

	(* if there are any strands provided, convert them to structures (and delete duplicates so we only make one model each) *)
	structuredNonModelInputs = If[!MatchQ[nonModelInputs, {}], DeleteDuplicates[Map[ToStructure[#, Polymer -> myPolymer]&, nonModelInputs]]];

	(* we need to create new Identity Models for the oligomers that were provided as Strands *)
	(* For the names we need to do a StringJoin here for cases that have defined their strand as StrandJoin[strand1, strand2] *)
	(* such that the name reflects the joint sequence and not just the first *)
	(* otherwise we run the risk that we don't upload a new one when it's actually needed *)
	newIdentityModelPackets = If[MatchQ[nonModelInputs, Except[{}]],
		Module[
			{names, structures, polymerTypes, searchResult, existingBools, newNames, newStructures,
				newPackets, existingPositions, nonExistingPositions, resultList},

			(* get the inputs *)
			names = StringJoin /@ ToSequence[structuredNonModelInputs][[All, 1]];
			structures = structuredNonModelInputs;

			(* search for existing models for these structures *)
			searchResult = With[
				{searchConditions = Map[Molecule==#&, structures]},
				Search[
					ConstantArray[Model[Molecule, Oligomer], Length[structures]],
					searchConditions
				]
			];

			(* check which ones exist *)
			existingBools = (!MatchQ[#,{}]&)/@searchResult;
			existingPositions = Flatten@Position[existingBools, True];
			nonExistingPositions = Flatten@Position[existingBools, False];

			(* filter lists to have only values that have to be uploaded *)
			newNames = #<>ToString[CreateUUID[]]&/@PickList[names, existingBools, False];
			newStructures = PickList[structures, existingBools, False];
			polymerTypes = ConstantArray[myPolymer, Length[newStructures]];

			(* generate packets for new Oligomers *)
			newPackets = If[Length[newStructures] > 0,
				UploadOligomer[newStructures, polymerTypes, newNames, Upload -> False],
				{}
			];

			(* return a list of existing oligomers and packets for the new ones sorted in the order to match the inputs *)
			resultList = SortBy[
				Join[
					Transpose[{existingPositions, First/@DeleteCases[searchResult,{}]}],
					Transpose[{nonExistingPositions, newPackets}]
				],First][[All,2]];

			resultList
		],
		{}
	];

	(* we upload the identity model right now if we made new ones *)
	If[!MatchQ[nonModelInputs, {}], Upload[Flatten[Cases[newIdentityModelPackets, PacketP[]]]]];

	(* make a list of rules for input->Model[Molecule, Oligomer] *)
	inputRulesSMolecules = MapThread[If[MatchQ[#2, PacketP[]], #1 -> Lookup[#2, Object], #1->#2]&, {DeleteDuplicates[nonModelInputs], newIdentityModelPackets}];

	(* figure out the object IDs of the Identity Models that we're going to create new samples for *)
	newIdentityModels = If[!MatchQ[nonModelInputs, {}], Flatten[If[MatchQ[#, PacketP[]], Lookup[#, Object], #]& /@ newIdentityModelPackets, 1], Null];

	(* Now, create new oligomer model packets for the strands *)
	newModelsForStrands = If[MatchQ[nonModelInputs, Except[{}]],
		Module[
			{names, identityModels},

			(* get the inputs *)
			names = ("Strand with "<>#<>" "<>ToString[CreateUUID[]]&)/@(StringJoin /@ ToSequence[structuredNonModelInputs][[All, 1]]);
			identityModels = newIdentityModels;

			(* make packets for samples we are making *)
			UploadSampleModel[
				names,
				Composition -> Map[{{100 MassPercent, #}}&, identityModels],
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"], (* Model[StorageCondition, "Refrigerator"] *)
				Expires -> False,
				ShelfLife -> Null,
				UnsealedShelfLife -> Null,
				MSDSFile -> NotApplicable,
				Flammable -> False,
				IncompatibleMaterials -> {None},
				(* set the state of new oligomer mixture models to liquid for now because it's breaking computed volume and volume checks *)
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Upload -> False
			]
		],
		{}
	];

	(* make a replacement rule for the inputs -> Model[Sample] that we made *)
	inputRulesSMoleculeToSample = If[Length[newIdentityModels]>0,MapThread[#1->#2&, {newIdentityModels, Lookup[newModelsForStrands, Object]}],{}];
	inputRulesSSamples = inputRulesSMolecules/.inputRulesSMoleculeToSample;

	(* also create new samples for the input that was provided as Model[Molecule,Oligomer] *)
	newModelsForMolecules = If[MatchQ[moleculeInputs, Except[{}]],
		Module[
			{oligomers, searchResults, names, existingModelsMap, existingModels, newOligomers, newNames, newPackets,
				resultList, existingPositions, newPositions},

			(* form a list of oligomers we will be working with*)
			oligomers = DeleteDuplicates[moleculeInputs];

			(* form a list of names for the sample Models *)
			names = ToString /@ (DeleteDuplicates[moleculeInputs][[All, -1]]);

			(* check if there are models that contain only this oligomer *)
			searchResults = With[{
				searchTypes = ConstantArray[{Model[Sample]}, Length[oligomers]],
				searchConditions = Map[Hold[And[Composition[[2]] == Link[#], Length[Composition] == 1]]&, oligomers]},
				Search[searchTypes, searchConditions, MaxResults -> 1]
			];

			(* get a list of models that do exist in the DB *)
			existingModelsMap = Map[If[Length[#]>0, First[#], Null]&, searchResults];
			existingModels = DeleteCases[existingModelsMap, Null];

			(* get positions for existing models so we can reorder things later on *)
			existingPositions = Flatten@Position[existingModelsMap, _?(Length[#] > 0 &), 1];
			newPositions = Complement[Range[Length[existingModelsMap]], existingPositions];

			(* make a list of only new oligomers and names *)
			newOligomers = PickList[oligomers, existingModelsMap, Null];
			newNames = (StringRiffle[{"Sample for", #, ToString[CreateUUID[]]}] &) /@ PickList[names, existingModelsMap, Null];

			newPackets = If[Length[newOligomers] > 0,
				UploadSampleModel[
					newNames,
					Composition -> Map[{{100 MassPercent, #}}&, newOligomers],
					DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"], (*Model[StorageCondition, "Refrigerator"]*)
					Expires -> False,
					ShelfLife -> Null,
					UnsealedShelfLife -> Null,
					MSDSFile -> NotApplicable,
					Flammable -> False,
					IncompatibleMaterials -> {None},
					(* set the state of new oligomer mixture models to liquid for now because it's breaking computed volume and volume checks *)
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False],
				{}];

			(* return a list of existing oligomers and packets for the new ones sorted in the order to match the inputs *)
			resultList = SortBy[
				Join[
					Transpose[{existingPositions, existingModels}],
					Transpose[{newPositions, newPackets}]
				],First][[All,2]];

			resultList
		],
		Null
	];

	(* make a list of replacement rules for provided Model[Molecule, Oligomer] into Model[Sample] that we created *)
	(* if we had new Model[Sample] made, before making an association make a list of only Model[Sample] instead of packets *)
	inputMoleculesToModels = If[
		Length[moleculeInputs]>0,
		MapThread[
			#1->#2&,
			{
				DeleteDuplicates[moleculeInputs],
				Map[If[MatchQ[#, ObjectReferenceP[Model[Sample]]], #,Lookup[#, Object]]&, newModelsForMolecules]
			}],{}];

	(* combine rules for input to model conversion *)
	inputToModelLookup = Join[inputRulesSSamples,inputMoleculesToModels];

	(* update the input, will only use this internally *)
	inputWithGeneratedModels = listedInputs /. inputToModelLookup;

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[experimentNNASynthesis, {myPolymer, inputWithGeneratedModels}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[experimentNNASynthesis, {myPolymer, inputWithGeneratedModels}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[experimentNNASynthesis, {myPolymer, inputWithGeneratedModels}, listedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[experimentNNASynthesis, {myPolymer, inputWithGeneratedModels}, listedOptions], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[experimentNNASynthesis, {myPolymer, inputWithGeneratedModels}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(*  Extract the packets that we need from our downloaded cache. *)
	specifiedSynthesizer = Lookup[safeOps, Instrument];

	synthesizerFieldsToDownload = If[MatchQ[specifiedSynthesizer, ObjectP[Model[Instrument, DNASynthesizer]]],
		{Packet[MaxModifications, MaxColumns, Name, PhosphoramiditeDeadVolume, PhosphoramiditePrimeVolume, ReagentDeadVolume, ReagentPrimeVolume, ReagentSets, Sequence @@ SamplePreparationCacheFields[Object[Instrument]]]},
		{Packet[Model[{MaxModifications, MaxColumns, Name, PhosphoramiditeDeadVolume, PhosphoramiditePrimeVolume, ReagentDeadVolume, ReagentPrimeVolume, ReagentSets, Sequence @@ SamplePreparationCacheFields[Model[Instrument]]}]]}
	];

	sampleInputFields = {Packet[Name, Strand, Sequence @@ SamplePreparationCacheFields[Object[Sample]]]};

	columnObjectFields = {
		Packet[Name, Model, Mass, Sequence @@ SamplePreparationCacheFields[Object[Sample]]],
		Packet[Model[SamplePreparationCacheFields[Model[Sample]]]],
		Packet[Field[Composition[[All, 2]]][Loading]],
		Packet[Field[Composition[[All, 2]]][Strand]],
		Packet[Field[Composition[[All, 2]]][Strand][Molecule]]
	};

	columnModelFields = {
		Packet[Name, Composition, Sequence @@ SamplePreparationCacheFields[Model[Sample]]],
		Packet[Field[Composition[[All, 2]]][Strand]],
		Packet[Field[Composition[[All, 2]]][Strand][Molecule]],
		Packet[Field[Composition[[All, 2]]][Loading]]
	};

	columnResinModelFields = {
		Packet[Name, Loading, DefaultSampleModel, Sequence @@ SamplePreparationCacheFields[Model[Resin]]],
		Packet[Strand],
		Packet[Strand[Molecule]],
		Packet[DefaultSampleModel[Composition]]
	};

	specifiedColumns = ToList[Lookup[safeOps, Columns]];
	columnObjects = Cases[specifiedColumns, ObjectP[Object[Sample]]];
	columnModels = Cases[specifiedColumns, ObjectP[Model[Sample]]];
	columnResinModels = Cases[specifiedColumns, ObjectP[Model[Resin]]];

	(* We need to download stuff about the amidites specified and any amidites we might resolve to *)
	amiditesModelsToDownload = Join[
		Cases[Flatten[ToList[Lookup[safeOps, Phosphoramidites]]], ObjectP[Model[Sample]]],
		Values[
			Flatten@Physics`Private`lookupModelOligomer[{myPolymer,Modification},SyntheticMonomers,Head->True, SynthesisStrategy->Phosphoramidite]
		]
	];
	amiditesModelFieldsToDownload ={
		Packet[Composition],
		Packet[Field[Composition[[All, 2]]][MolecularWeight]],
		Packet[VolumeIncrements, Formula]
	};

	amiditeObjectsToDownload = Cases[Flatten[ToList[Lookup[safeOps, Phosphoramidites]]], ObjectP[Object[Sample]]];
	amiditeObjectFieldsToDownload = {
		Packet[Composition, Analytes],
		Packet[Field[Composition[[All, 2]]][{MolecularWeight, Molecule}]]
	};

	(* the upload packets for the new oligomer models have the Replace[x] so we need to strip that before passing it in as cache *)
	newModelForStrandsCache = If[!MatchQ[nonModelInputs, {}], Association /@ (Normal[newModelsForStrands] /. {Replace[x_] :> x}), {}];
	newModelForMoleculeCache = If[!MatchQ[moleculeInputs, {}], Association /@ (Normal[newModelsForMolecules] /. {Replace[x_] :> x}), {}];

	(* gather the new packets, if there are any. We have already uploaded the molecules, so this is only the Model[Sample] packets. *)
	newModels = Cases[Flatten[Join[ToList[newModelsForStrands], ToList[newModelsForMolecules]]], PacketP[]];

	(* Stash the Cache we were passed in *)
	cacheOp = Lookup[safeOps, Cache];

	(* Build a new cache with any models we just created the cache that we want to pass to the download call including the new model packet and new identity model packets *)
	newCache = FlattenCachePackets[{cacheOp, newModelForMoleculeCache, newModelForStrandsCache, newIdentityModelPackets}];

	(* Download dump *)
	downloadedStuff = Flatten[
		Quiet[
			Download[
				{
					(*1*)inputWithGeneratedModels,
					(*2*)inputWithGeneratedModels,
					(*3*){specifiedSynthesizer},
					(*4*)Lookup[expandedSafeOps, CleavageMethod],
					(*5*)columnObjects,
					(*6*)columnModels,
					(*7*)columnResinModels,
					(*8*)amiditesModelsToDownload,
					(*9*)amiditeObjectsToDownload,
					(*10*)ToList[ParentProtocol /. safeOps],
					(*11*)Lookup[expandedSafeOps, RNADeprotectionMethod],
					(*12*){Model[Physics, Oligomer, ToString[myPolymer]]}
				},
				{
					(*1*)(*sampleInputFields*){Packet[Field[Composition[[All, 2]]][{PolymerType, Molecule}]]},
					(*2*){Packet[Composition]},
					(*3*)synthesizerFieldsToDownload,
					(*4*){Packet[Name, CleavageSolution, CleavageSolutionVolume, CleavageTime, CleavageTemperature, CleavageWashSolution, CleavageWashVolume]},
					(*5*)columnObjectFields,
					(*6*)columnModelFields,
					(*7*)columnResinModelFields,
					(*8*)amiditesModelFieldsToDownload,
					(*9*)amiditeObjectFieldsToDownload,
					(*10*){Packet[ImageSample]},
					(*11*){Packet[Name, RNADeprotectionResuspensionSolution, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime, RNADeprotectionResuspensionTemperature, RNADeprotectionSolution, RNADeprotectionSolutionVolume, RNADeprotectionTemperature, RNADeprotectionTime, RNADeprotectionQuenchingSolution, RNADeprotectionQuenchingSolutionVolume]},
					(*12*){Packet[DegenerateAlphabet, SyntheticMonomers]}
				},
				Cache -> newCache
			],
			{Download::NotLinkField, Download::FieldDoesntExist}
		]
	];

	(* Generate the cache ball *)
	cacheBall = FlattenCachePackets[{newCache, downloadedStuff}];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentNNASynthesisOptions[myPolymer, inputWithGeneratedModels, expandedSafeOps, Cache -> cacheBall, Output -> {Result, Tests}],
			{resolveExperimentNNASynthesisOptions[myPolymer, inputWithGeneratedModels, expandedSafeOps, Cache -> cacheBall], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		experimentNNASynthesis,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* If we are working with DNA, return only relevant options *)
	ruturnOptions =If[MatchQ[myPolymer, RNA],
		RemoveHiddenOptions[experimentNNASynthesis, collapsedResolvedOptions],
		Cases[RemoveHiddenOptions[experimentNNASynthesis, collapsedResolvedOptions],
			_?(StringMatchQ[ToString[#[[1]]], Alternatives[Options[ExperimentDNASynthesis][[All, 1]]]] &)]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> ruturnOptions,
			Preview -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}]
		}]
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	(* Since the unknownMonomerInputs InvalidInput error prevents the user from inputting phosphoramidites for unknown monomers in CommandBuilder (CB blocks from entering the option resolution), we didn't hard error unless the function Result was asked for *)
	(* Therefore, don't call the resource packet function in this case, since it will error out if the Phosphoramidites option doesn't have a member for each monomer *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> ruturnOptions,
			Preview -> Null
		}]
	];

	(* Build packets with resources *)
	{resourceFunctionPackets, resourcePacketTests} = If[gatherTests,
		nnaSynthesisResourcePackets[myPolymer, inputWithGeneratedModels, templatedOptions, resolvedOptions, Cache -> cacheBall, Output -> {Result, Tests}],
		{nnaSynthesisResourcePackets[myPolymer, inputWithGeneratedModels, templatedOptions, resolvedOptions, Cache -> cacheBall, Output -> Result], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> ruturnOptions,
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[And[!MatchQ[resourceFunctionPackets, $Failed], !MatchQ[resolvedOptionsResult, $Failed]],

		Module[{protocolPacketWithResources, otherPackets},

			(* The resource packet function returns the protocol packet as well as any new methods it needed to make. Sort these out. *)
			protocolPacketWithResources = FirstCase[resourceFunctionPackets, ObjectP[{Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]}]];

			otherPackets = Join[
				Complement[resourceFunctionPackets, ToList[protocolPacketWithResources]],
				If[MatchQ[newModels, {PacketP[]..}], newModels, {}]
			];

			If[MatchQ[otherPackets, {}],
				UploadProtocol[
					protocolPacketWithResources,
					Upload -> Lookup[safeOps, Upload],
					Confirm -> Lookup[safeOps, Confirm],
					CanaryBranch -> Lookup[safeOps, CanaryBranch],
					ParentProtocol -> Lookup[safeOps, ParentProtocol],
					Priority -> Lookup[safeOps, Priority],
					StartDate -> Lookup[safeOps, StartDate],
					HoldOrder -> Lookup[safeOps, HoldOrder],
					QueuePosition -> Lookup[safeOps, QueuePosition],
					ConstellationMessage -> If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]],
					Cache -> cacheBall
				],
				UploadProtocol[
					protocolPacketWithResources,
					otherPackets,
					Upload -> Lookup[safeOps, Upload],
					Confirm -> Lookup[safeOps, Confirm],
					CanaryBranch -> Lookup[safeOps, CanaryBranch],
					ParentProtocol -> Lookup[safeOps, ParentProtocol],
					Priority -> Lookup[safeOps, Priority],
					StartDate -> Lookup[safeOps, StartDate],
					HoldOrder -> Lookup[safeOps, HoldOrder],
					QueuePosition -> Lookup[safeOps, QueuePosition],
					ConstellationMessage -> If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]],
					Cache -> cacheBall
				]
			]
		],

		(* Likely our resolver failed to resolve fulfillable resources so instead of throwing errors in UploadProtocol, just return $Failed *)
		$Failed
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> ruturnOptions,
		Preview -> Null
	}
];



(* ::Subsubsection:: *)
(* resolveExperimentNNASynthesisOptions *)

DefineOptions[
	resolveExperimentNNASynthesisOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveExperimentNNASynthesisOptions[myPolymer : (DNA | RNA), myStrands : {ObjectP[Model[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentNNASynthesisOptions]] := Module[
	{
		outputSpecification, output, gatherTests, cache, polymerTypes, polymerInvalidInputs, invalidPolymerTest, strandsPerModel,
		strandsInvalidInputs, invalidStrandsTests, strands, maxModifications, monomersByStrand, uniqueMonomers, uniqueModifications,
		tooManyModsInvalidInputs, tooManyModificationsTests, numberOfReplicates, numberOfStrands, maxStrands, tooManyStrandsInvalidInputs,
		tooManyStrandsTest, roundedOptions, precisionTests, polymerPacket,
		resolvedAmidites, unknownMonomers, unknownMonomerInputs,
		unknownMonomerTests, resolvedInitialWashVolume, resolvedNumberOfDeprotections, resolvedDeprotectionVolume, resolvedDeprotectionWashVolume,
		resolvedActivatorVolume, resolvedCapAVolume, resolvedCapBVolume, resolvedOxidationVolume, resolvedOxidationWashVolume,
		resolvedFinalWashVolume, specifiedPhosphoramidites, invalidOverspecifiedPhosphoramiditesOption, overspecifiedPhosphoramiditesTests,
		newSSPackets, newStockSolutions, allSyntheticMonomers, resolvedUnspecifiedAmiditesInitial,
		specifiedNumberOfCouplings, invalidOverspecifiedNumberOfCouplingsOption, overspecifiedNumberOfCouplingsTests,
		uniqueModsAndNatural, defaultNumberOfCouplings, resolvedNumberOfCouplings, specifiedPhosphoramiditeVolume,
		invalidOverspecifiedPhosphoramiditeVolumeOption, overspecifiedPhosphoramiditeVolumeTests, defaultPhosphoramiditeVolume,
		resolvedPhosphoramiditeVolume, specifiedCouplingTime, invalidOverspecifiedCouplingTimeOption, overspecifiedCouplingTimeTests,
		defaultCouplingTime, resolvedCouplingTime, emailOption, uploadOption, resolvedEmail, resolvedPostProcessingOptions,
		nameOption, nameValidBool, nameOptionInvalid, nameUniquenessTest, invalidInputs, invalidOptions, specifiedColumns, specifiedScales,
		columnSpecifiedScale, columnScaleMismatchTest, resolvedScale, cleavageOptions, nonCleavageOptions,
		cleavageOptionsSpecified, nonCleavageOptionsSpecified, cleavageOptionSetConflictBools, cleavageTrueConflictBools,
		cleavageFalseConflictBools, cleavageOptionsInvalid, cleavageOptionSetConflictTests, cleavageTrueConflictTests,
		cleavageFalseConflictTests, synthesizerModelPacket, convertedSpecifiedCouplingTime, specifiedCleavageMethod,
		strandPackets, cleavageMethodPackets,
		resolvedCleavages, resolvedCleavageTimes, resolvedCleavageTemperatures, resolvedCleavageSolutions, resolvedCleavageSolutionVolumes, resolvedCleavageWashSolutions, resolvedCleavageWashVolumes, resolvedStorageSolvents,
		optionsSpecifiedWithMonomers,
		numericExtractedOptions, numericUpdatedOptions, roundedOptionsWithExtractedPairs, roundedRepairedOptions, listedCleavageMethodPackets,
		cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools, cleavageTrueNullConflictBools,
		cleavageFalseNullConflictBools, cleavageOptionSetNullConflictTests, cleavageTrueNullConflictTests, cleavageFalseNullConflictTests,
		conflictingColumnLoadingTest, activeSitesS, columnModelPackets, resinMatchesBools, invalidColumnsOption, resinMatchingTests,
		repeatColumnTest, columnRepeatInvalid, cacheBall, phosphoramidtesToDownload, phosphoramiditesPacks, missingColumnLoadingTest,
		missingColumnLoadingOptions, badColumnObjects,
		listedRNADeprotectionMethodPackets, rnaDeprotectionMethodPackets,
		specifiedPostCleavageDesaltingSampleLoadRate, specifiedPostCleavageDesaltingRinseAndReload, specifiedPostCleavageDesaltingRinseAndReloadVolume, specifiedPostCleavageDesaltingType, specifiedPostCleavageDesaltingCartridge, specifiedPostCleavageDesaltingPreFlushVolume, specifiedPostCleavageDesaltingPreFlushRate, specifiedPostCleavageDesaltingEquilibrationVolume, specifiedPostCleavageDesaltingEquilibrationRate, specifiedPostCleavageDesaltingElutionVolume, specifiedPostCleavageDesaltingElutionRate, specifiedPostCleavageDesaltingWashVolume, specifiedPostCleavageDesaltingWashRate,
		specifiedRNADeprotectionMethod,
		specifiedPostRNADeprotectionDesaltingSampleLoadRate, specifiedPostRNADeprotectionDesaltingRinseAndReload, specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, specifiedPostRNADeprotectionDesaltingType, specifiedPostRNADeprotectionDesaltingCartridge, specifiedPostRNADeprotectionDesaltingPreFlushVolume, specifiedPostRNADeprotectionDesaltingPreFlushRate, specifiedPostRNADeprotectionDesaltingEquilibrationVolume, specifiedPostRNADeprotectionDesaltingEquilibrationRate, specifiedPostRNADeprotectionDesaltingElutionVolume, specifiedPostRNADeprotectionDesaltingElutionRate, specifiedPostRNADeprotectionDesaltingWashVolume, specifiedPostRNADeprotectionDesaltingWashRate,
		specifiedPostCleavageDesaltingInstruments, specifiedPostRNADeprotectionDesaltingInstruments, specifiedPostCleavageDesaltingPreFlushBuffer, specifiedPostCleavageDesaltingWashBuffer, specifiedPostCleavageDesaltingElutionBuffer, specifiedPostRNADeprotectionDesaltingPreFlushBuffer, specifiedPostRNADeprotectionDesaltingWashBuffer, specifiedPostRNADeprotectionDesaltingElutionBuffer, specifiedPostCleavageDesaltingEquilibrationBuffer,
		specifiedPostRNADeprotectionDesaltingEquilibrationBuffer,
		resolvedPostCleavageEvaporation, resolvedPostCleavageDesalting, resolvedPostCleavageDesaltingSampleLoadRate, resolvedPostCleavageDesaltingRinseAndReload, resolvedPostCleavageDesaltingRinseAndReloadVolume, resolvedPostCleavageDesaltingType, resolvedPostCleavageDesaltingCartridge, resolvedPostCleavageDesaltingPreFlushVolume, resolvedPostCleavageDesaltingPreFlushRate, resolvedPostCleavageDesaltingEquilibrationVolume, resolvedPostCleavageDesaltingEquilibrationRate, resolvedPostCleavageDesaltingElutionVolume, resolvedPostCleavageDesaltingElutionRate, resolvedPostCleavageDesaltingWashVolume, resolvedPostCleavageDesaltingWashRate,
		resolvedRNADeprotection, resolvedRNADeprotectionTime, resolvedRNADeprotectionTemperature, resolvedRNADeprotectionResuspensionSolution, resolvedRNADeprotectionResuspensionVolume, resolvedRNADeprotectionResuspensionTime, resolvedRNADeprotectionResuspensionTemperature, resolvedRNADeprotectionSolution, resolvedRNADeprotectionSolutionVolume, resolvedRNADeprotectionQuenchingSolution, resolvedRNADeprotectionQuenchingSolutionVolume,
		resolvedPostRNADeprotectionEvaporation, defaultCleavageTime, defaultCleavageTemperature, defaultCleavageSolution,
		resolvedPostRNADeprotectionDesalting, resolvedPostRNADeprotectionDesaltingSampleLoadRate, resolvedPostRNADeprotectionDesaltingRinseAndReload, resolvedPostRNADeprotectionDesaltingRinseAndReloadVolume, resolvedPostRNADeprotectionDesaltingType, resolvedPostRNADeprotectionDesaltingCartridge, resolvedPostRNADeprotectionDesaltingPreFlushVolume, resolvedPostRNADeprotectionDesaltingPreFlushRate, resolvedPostRNADeprotectionDesaltingEquilibrationVolume, resolvedPostRNADeprotectionDesaltingEquilibrationRate, resolvedPostRNADeprotectionDesaltingElutionVolume, resolvedPostRNADeprotectionDesaltingElutionRate, resolvedPostRNADeprotectionDesaltingWashVolume, resolvedPostRNADeprotectionDesaltingWashRate,
		resolvedPostCleavageDesaltingInstruments, resolvedPostCleavageDesaltingPreFlushBuffer, resolvedPostCleavageDesaltingEquilibrationBuffer, resolvedPostCleavageDesaltingWashBuffer, resolvedPostCleavageDesaltingElutionBuffer, resolvedPostRNADeprotectionDesaltingPreFlushBuffer, resolvedPostRNADeprotectionDesaltingEquilibrationBuffer, resolvedPostRNADeprotectionDesaltingWashBuffer, resolvedPostRNADeprotectionDesaltingElutionBuffer,
		specifiedPostCleavageDesaltingOptions, resolvedPostCleavageDesaltingOptions, specifiedPostRNADeprotectionDesaltingOptions, resolvedPostRNADeprotectionDesaltingOptions, postCleavageDesaltingTests, postRNADeprotectionDesaltingTests, simulatedSamplesPostCleavage, simulatedSamplesPostRNADeprotection,
		mapThreadFriendlyOptions, monomersSansResins, mapThreadOutput, postCleavageDesaltingOptions, rnaDeprotectionOptions, postRNADeprotectionDesaltingOptions,
		postCleavageDesaltingOptionsSpecified, postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools, postCleavageDesaltingFalseConflictBools,
		rnaDeprotectionOptionsSpecified, rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools, rnaDeprotectionFalseConflictBools, rnaDeprotectionResuspensionConflicts, cleavageDesaltingConflictBools, deprotectionDesaltingConflictBools, specifiedStorageSolventVolume,
		deprotectionOptionsInvalid, deprotectionFalseConflictTests, deprotectionTrueNullConflictTests, postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools, postRNADeprotectionDesaltingFalseConflictBools, postCleavageDesaltingTrueNullConflictTests, postCleavageDesaltingFalseConflictTests, postRNADeprotectionDesaltingFalseConflictTests, postRNADeprotectionDesaltingTrueNullConflictTests, rnaDeprotectionResuspensionConflictBools, resolvedStorageSolventVolume, cleavageDesaltingConflictTests, deprotectionDesaltingConflictTests, rnaDeprotectionResuspensionConflictTests,
		calculatedVolumePostCleavage, calculatedVolumePostRNADeprotection, cacheBallCleavage,
		resolvedPostCleavageDesaltingRules, resolvedPostRNADeprotectionDesaltingRules, resolvedPostRNADeprotectionDesaltingInstruments,
		rnaDeprotectionEvaporationConflictBools, rnaDeprotectionEvaporationConflictTests, desaltingOptionsInvalid, specifiedScale,
		cleavageDesaltingCount, cleavageDesaltingSampleIDs, filteredPostCleavageDesaltingOptionsRules, filteredPostCleavageDesaltingOptionsAssociation, filteredPostRNADeprotectionDesaltingOptionsRules, filteredPostRNADeprotectionDesaltingOptionsAssociation, rnaDeprotectionDesaltingSampleIDs, cacheBallRNADeprotection, rnaDeprotectionDesaltingCount, speOptionsDefaults, speOptionsNotList,
		resolvedRawPostRNADeprotectionDesaltingSampleLoadRate,
		resolvedRawPostRNADeprotectionDesaltingRinseAndReload, resolvedRawPostRNADeprotectionDesaltingRinseAndReloadVolume,
		resolvedRawPostRNADeprotectionDesaltingType, resolvedRawPostRNADeprotectionDesaltingCartridge,
		resolvedRawPostRNADeprotectionDesaltingPreFlushVolume, resolvedRawPostRNADeprotectionDesaltingPreFlushRate,
		resolvedRawPostRNADeprotectionDesaltingEquilibrationVolume, resolvedRawPostRNADeprotectionDesaltingEquilibrationRate,
		resolvedRawPostRNADeprotectionDesaltingElutionVolume, resolvedRawPostRNADeprotectionDesaltingElutionRate,
		resolvedRawPostRNADeprotectionDesaltingWashVolume, resolvedRawPostRNADeprotectionDesaltingWashRate,
		resolvedRawPostCleavageDesaltingSampleLoadRate,
		resolvedRawPostCleavageDesaltingRinseAndReload, resolvedRawPostCleavageDesaltingRinseAndReloadVolume,
		resolvedRawPostCleavageDesaltingType, resolvedRawPostCleavageDesaltingCartridge,
		resolvedRawPostCleavageDesaltingPreFlushVolume, resolvedRawPostCleavageDesaltingPreFlushRate,
		resolvedRawPostCleavageDesaltingEquilibrationVolume, resolvedRawPostCleavageDesaltingEquilibrationRate,
		resolvedRawPostCleavageDesaltingElutionVolume, resolvedRawPostCleavageDesaltingElutionRate,
		resolvedRawPostCleavageDesaltingWashVolume, resolvedRawPostCleavageDesaltingWashRate,
		resolvedSecondaryOxidationWashVolume, resolvedSecondaryOxidationVolume, resolvedSecondaryOxidationSolution,
		banksUsed, specifiedActivatorSolution, resolvedActivatorSolution, specifiedCapBSolution, resolvedCapBSolution,
		defaultCapASolution, specifiedCapASolution, resolvedCapASolution, defaultActivatorSolution,defaultCapBSolution,
		specifiedActivatorSolutionStorageCondition, resolvedActivatorSolutionStorageCondition, specifiedCapASolutionStorageCondition,
		resolvedCapASolutionStorageCondition, specifiedCapBSolutionStorageCondition, resolvedCapBSolutionStorageCondition,
		invalidOnDeckReagentsOption, invalidOnDeckReagentsTests,
		degenerateAlphabet, monomersNeedStockSolutions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache = Quiet[OptionValue[Cache]];

	(* Pull out the specified cleavage method if one was given so we can download on it *)
	specifiedCleavageMethod = Lookup[myOptions, CleavageMethod];

	(* Pull out the specified RNADeprotection method for RNA case and if one was given so we can download on it *)
	specifiedRNADeprotectionMethod = If[MatchQ[myPolymer, RNA],
		Lookup[myOptions, RNADeprotectionMethod],
		{}
	];

	(* We need to gather some info on our phosphoramidites *)
	phosphoramidtesToDownload = DeleteDuplicates[Download[Cases[
		Lookup[myOptions, Phosphoramidites],
		ObjectReferenceP[{Object[Sample], Model[Sample], Model[Molecule]}],
		Infinity
	], Object, Cache -> cache]];

	(* Extract the packets that we need from our downloaded cache for DNA and RNA cases. *)
	{strandPackets, listedCleavageMethodPackets, listedRNADeprotectionMethodPackets, phosphoramiditesPacks, {{polymerPacket}}} = Quiet[
		Download[
			{
				myStrands,
				specifiedCleavageMethod,
				specifiedRNADeprotectionMethod,
				phosphoramidtesToDownload,
				{Model[Physics, Oligomer, ToString[myPolymer]]}
			},
			{
				{Packet[Field[Composition[[All, 2]]][{PolymerType, Molecule}]]},
				{Packet[Name, CleavageSolution, CleavageSolutionVolume, CleavageTime, CleavageTemperature, CleavageWashSolution, CleavageWashVolume]},
				{Packet[Name, RNADeprotectionResuspensionSolution, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime, RNADeprotectionResuspensionTemperature, RNADeprotectionSolution, RNADeprotectionSolutionVolume, RNADeprotectionTemperature, RNADeprotectionTime, RNADeprotectionQuenchingSolution, RNADeprotectionQuenchingSolutionVolume]},
				{
					Packet[Composition, Analytes],
					Packet[Field[Composition[[All, 2]]][{MolecularWeight, Molecule}]]
				},
				{Packet[DegenerateAlphabet, SyntheticMonomers]}
			}, Cache -> cache
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::Part, Download::MissingCacheField}
	];

	cacheBall = If[MatchQ[myPolymer, DNA],
		FlattenCachePackets[{cache, {strandPackets, listedCleavageMethodPackets, phosphoramiditesPacks, polymerPacket}}],
		FlattenCachePackets[{cache, {strandPackets, listedCleavageMethodPackets, listedRNADeprotectionMethodPackets, phosphoramiditesPacks, polymerPacket}}]
	];

	(* construct the list of possible degenerate letters for myPolymer *)
	(* we need to remove monomers that are empty since the user needs to use Modification in their place to have a backbone present *)
	degenerateAlphabet=myPolymer[#]&/@DeleteDuplicates[DeleteCases[Lookup[polymerPacket, DegenerateAlphabet], {_, Null}][[All, 1]]];

	(* Given that information can be nested a view objects deep, we should go through each set of packets to determine which sequence to use *)
	strands = MapThread[
		Function[{strandExamined},
			Module[{trimmedCompositionPackets},

				(* Flatten the doubly-listed set of component packets and then delete Null, which we would've received in the case of a {Null, Null} composition element *)
				trimmedCompositionPackets = DeleteCases[Flatten[strandExamined], Null];

				(* Lookup the molecule field and find all instances of strands *)
				Cases[
					Lookup[trimmedCompositionPackets, Molecule, Null],
					StrandP,
					Infinity(* To pierce through structures *)
				]
			]
		],
		{strandPackets}
	];

	(* extract packets from out cache *)
	synthesizerModelPacket = FirstCase[cacheBall, ObjectP[Model[Instrument, DNASynthesizer]]];
	cleavageMethodPackets = Flatten[listedCleavageMethodPackets];
	rnaDeprotectionMethodPackets = If[
		MatchQ[myPolymer, RNA],
		Flatten[listedRNADeprotectionMethodPackets]
	];

	(*-- INPUT VALIDATION CHECKS --*)

	(* - If any of the input strands consist of monomers that are not DNA/RNA or Modification, throw error -*)

	(* Determine the polymer type(s) in each strand *)
	polymerTypes = Map[PolymerType[#]&, First /@ strands];

	(* Find any inputs that consist of anything that is not DNA or Modification *)
	polymerInvalidInputs = Switch[myPolymer,
		DNA,
		PickList[myStrands, polymerTypes, (_?(Not[MatchQ[Flatten[#], {Alternatives[DNA, LDNA, Modification] ..}]] &))],
		RNA,
		PickList[myStrands, polymerTypes, (_?(Not[MatchQ[Flatten[#], {Alternatives[RNA, LDNA, Modification] ..}]] &))]
	];

	(* If there are invalid inputs and we are throwing messages and we are not in Engine, throw an error message .*)
	If[Length[polymerInvalidInputs] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::InvalidPolymer, ObjectToString[polymerInvalidInputs, Cache -> cacheBall], myPolymer]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPolymerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[polymerInvalidInputs] == 0,
				Nothing,
				Test["The input models " <> ObjectToString[polymerInvalidInputs, Cache -> cacheBall] <> " consist only of " <> ToString[myPolymer] <> " and/or Modification polymer types:", True, False]
			];

			passingTest = If[Length[polymerInvalidInputs] == Length[myStrands],
				Nothing,
				Test["The input models " <> ObjectToString[Complement[myStrands, polymerInvalidInputs], Cache -> cacheBall] <> " consist only of " <> ToString[myPolymer] <> " and/or Modification polymer types:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* - If any of the input strands are not single stranded, error - *)

	(* Find the number of strands associated with each oligomer model. *)
	strandsPerModel = Map[Length, strands];

	(* Find any inputs that consist of more than one strand *)
	strandsInvalidInputs = PickList[myStrands, strandsPerModel, (_?(Not[MatchQ[#, 1]]&))];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[strandsInvalidInputs] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::InvalidStrands, ObjectToString[strandsInvalidInputs, Cache -> cacheBall], myPolymer]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidStrandsTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[strandsInvalidInputs] == 0,
				Nothing,
				Test["The input models " <> ObjectToString[strandsInvalidInputs, Cache -> cacheBall] <> " are single-stranded:", True, False]
			];

			passingTest = If[Length[strandsInvalidInputs] == Length[myStrands],
				Nothing,
				Test["The input models " <> ObjectToString[Complement[myStrands, strandsInvalidInputs], Cache -> cacheBall] <> " are single-stranded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* - If the number of modifications across the strands exceeds MaxModifications for the synthesizer, error - *)

	(* The max number of unique modifications that we can fit on the synthesizer *)
	maxModifications = Lookup[synthesizerModelPacket, MaxModifications];

	(* The monomers that are in each strand *)
	monomersByStrand = Monomers[strands];

	(* - If the number of strands is greater than the MaxColumns of the synthesizer, error - *)

	(* Find the number of replicates that was requested *)
	numberOfReplicates = Lookup[myOptions, NumberOfReplicates] /. Null -> 1;

	(* The number of strands that will be synthesized, counting replicates  *)
	numberOfStrands = numberOfReplicates * Length[myStrands];

	(* The max strands we can synthesize at once *)
	maxStrands = Lookup[synthesizerModelPacket, MaxColumns];

	(* If the collective number of strands is more than the allowed number of columns for the synthesizer, count all of the strands as invalid *)
	tooManyStrandsInvalidInputs = If[numberOfStrands > maxStrands,
		myStrands,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message*)
	If[Length[tooManyStrandsInvalidInputs] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::TooManyOligomers, ObjectToString[synthesizerOption, Cache -> cacheBall], maxStrands]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyStrandsTest = If[gatherTests,
		If[Length[tooManyStrandsInvalidInputs] > 0,
			Test["The inputs and number of replicates are less than the max number of strands that can be synthesized at once, " <> ToString[maxStrands] <> ":", True, False],
			Test["The inputs and number of replicates are less than the max number of strands that can be synthesized at once, " <> ToString[maxStrands] <> ":", True, True]
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* Some of the options can be specified as monomer-value pairs. For those, extract the values for option rounding *)
	optionsSpecifiedWithMonomers = Cases[myOptions, (_?(MatchQ[#[[2]], {{SequenceP | "Natural", _} ..}] &))];

	(* Get any options that were specified as monomer-value pairs to just have the numeric value portion of the pair *)
	numericExtractedOptions = Map[#[[1]] -> #[[2, All, 2]] &, optionsSpecifiedWithMonomers];

	(* Put these updates options into the options list*)
	numericUpdatedOptions = ReplaceRule[myOptions, numericExtractedOptions];

	(* Round option precision *)
	Switch[myPolymer,
		DNA,
		{roundedOptionsWithExtractedPairs, precisionTests} = If[gatherTests,
			RoundOptionPrecision[Association[numericUpdatedOptions],
				{
					CleavageTemperature,
					CleavageTime, InitialWashTime, DeprotectionTime, DeprotectionWashTime, CouplingTime, CapTime, OxidationTime, OxidationWashTime, FinalWashTime, SecondaryOxidationTime, SecondaryOxidationWashTime,
					InitialWashVolume, DeprotectionVolume, DeprotectionWashVolume, ActivatorVolume, PhosphoramiditeVolume, CapAVolume, CapBVolume, OxidationVolume, OxidationWashVolume, FinalWashVolume, SecondaryOxidationVolume, SecondaryOxidationWashVolume,
					CleavageSolutionVolume, StorageSolventVolume, CleavageWashVolume
				},
				{
					1 Celsius,
					1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second,
					1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1 Microliter,
					10 Microliter, 10 Microliter, 10 Microliter
				},
				Output -> {Result, Tests}],
			{RoundOptionPrecision[Association[numericUpdatedOptions],
				{
					CleavageTemperature,
					CleavageTime, InitialWashTime, DeprotectionTime, DeprotectionWashTime, CouplingTime, CapTime, OxidationTime, OxidationWashTime, FinalWashTime, SecondaryOxidationTime, SecondaryOxidationWashTime,
					InitialWashVolume, DeprotectionVolume, DeprotectionWashVolume, ActivatorVolume, PhosphoramiditeVolume, CapAVolume, CapBVolume, OxidationVolume, OxidationWashVolume, FinalWashVolume, SecondaryOxidationVolume, SecondaryOxidationWashVolume,
					CleavageSolutionVolume, StorageSolventVolume, CleavageWashVolume
				},
				{
					1 Celsius,
					1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second,
					1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1Microliter, 1 Microliter,
					10 Microliter, 10 Microliter, 10 Microliter
				}
			], Null}
		],
		RNA,
		{roundedOptionsWithExtractedPairs, precisionTests} = If[gatherTests,
			RoundOptionPrecision[Association[numericUpdatedOptions],
				{
					CleavageTemperature, RNADeprotectionResuspensionTemperature, RNADeprotectionTemperature,
					CleavageTime, InitialWashTime, DeprotectionTime, DeprotectionWashTime, CouplingTime, CapTime, OxidationTime, OxidationWashTime, SecondaryOxidationTime, SecondaryOxidationWashTime,RNADeprotectionTime, RNADeprotectionResuspensionTime, FinalWashTime,
					InitialWashVolume, DeprotectionVolume, DeprotectionWashVolume, ActivatorVolume, PhosphoramiditeVolume, CapAVolume, CapBVolume, OxidationVolume, OxidationWashVolume, SecondaryOxidationVolume, SecondaryOxidationWashVolume, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionSolutionVolume, FinalWashVolume,
					CleavageSolutionVolume, StorageSolventVolume, CleavageWashVolume, RNADeprotectionQuenchingSolutionVolume, PostRNADeprotectionDesaltingRinseAndReloadVolume, PostRNADeprotectionDesaltingPreFlushVolume, PostRNADeprotectionDesaltingEquilibrationVolume, PostRNADeprotectionDesaltingElutionVolume, PostRNADeprotectionDesaltingWashVolume, PostCleavageDesaltingRinseAndReloadVolume, PostCleavageDesaltingPreFlushVolume, PostCleavageDesaltingEquilibrationVolume, PostCleavageDesaltingElutionVolume, PostCleavageDesaltingWashVolume,
					PostCleavageDesaltingSampleLoadRate, PostCleavageDesaltingPreFlushRate, PostCleavageDesaltingEquilibrationRate, PostCleavageDesaltingElutionRate, PostCleavageDesaltingWashRate, PostRNADeprotectionDesaltingSampleLoadRate, PostRNADeprotectionDesaltingPreFlushRate, PostRNADeprotectionDesaltingEquilibrationRate, PostRNADeprotectionDesaltingElutionRate, PostRNADeprotectionDesaltingWashRate
				},
				{
					1 Celsius, 1 Celsius, 1 Celsius,
					1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second,
					1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
					10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter,
					0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute
				},
				Output -> {Result, Tests}],
			{RoundOptionPrecision[Association[numericUpdatedOptions],
				{
					CleavageTemperature, RNADeprotectionResuspensionTemperature, RNADeprotectionTemperature,
					CleavageTime, InitialWashTime, DeprotectionTime, DeprotectionWashTime, CouplingTime, CapTime, OxidationTime, OxidationWashTime, SecondaryOxidationTime, SecondaryOxidationWashTime,RNADeprotectionTime, RNADeprotectionResuspensionTime, FinalWashTime,
					InitialWashVolume, DeprotectionVolume, DeprotectionWashVolume, ActivatorVolume, PhosphoramiditeVolume, CapAVolume, CapBVolume, OxidationVolume, OxidationWashVolume, SecondaryOxidationVolume, SecondaryOxidationWashVolume, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionSolutionVolume, FinalWashVolume,
					CleavageSolutionVolume, StorageSolventVolume, CleavageWashVolume, RNADeprotectionQuenchingSolutionVolume, PostRNADeprotectionDesaltingRinseAndReloadVolume, PostRNADeprotectionDesaltingPreFlushVolume, PostRNADeprotectionDesaltingEquilibrationVolume, PostRNADeprotectionDesaltingElutionVolume, PostRNADeprotectionDesaltingWashVolume, PostCleavageDesaltingRinseAndReloadVolume, PostCleavageDesaltingPreFlushVolume, PostCleavageDesaltingEquilibrationVolume, PostCleavageDesaltingElutionVolume, PostCleavageDesaltingWashVolume,
					PostCleavageDesaltingSampleLoadRate, PostCleavageDesaltingPreFlushRate, PostCleavageDesaltingEquilibrationRate, PostCleavageDesaltingElutionRate, PostCleavageDesaltingWashRate, PostRNADeprotectionDesaltingSampleLoadRate, PostRNADeprotectionDesaltingPreFlushRate, PostRNADeprotectionDesaltingEquilibrationRate, PostRNADeprotectionDesaltingElutionRate, PostRNADeprotectionDesaltingWashRate
				},
				{
					1 Celsius, 1 Celsius, 1 Celsius,
					1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second, 1 Second,
					1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
					10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter, 10 Microliter,
					0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute, 0.01 Milliliter / Minute
				}
			], Null}
		];
	];

	(* If we took just the numeric portion of monomer-value pair options for rounding, remake the pairs *)
	roundedRepairedOptions = Map[
		#[[1]] -> Transpose[{
			#[[2]][[All, 1]],
			Lookup[
				roundedOptionsWithExtractedPairs,
				#[[1]]
			]
		}] &, optionsSpecifiedWithMonomers];

	(* Insert the remade pairs into the rounded options *)
	roundedOptions = ReplaceRule[Normal[roundedOptionsWithExtractedPairs], roundedRepairedOptions];

	(*-- Options checks and resolver for samples --*)

	specifiedColumns = Lookup[roundedOptions, Columns];

	(* Default scale-independent options *)
	defaultCouplingTime = If[MatchQ[myPolymer, RNA],
		360 Second,
		200 Second
	];

	defaultCleavageTime = If[MatchQ[myPolymer, RNA],
		0.75 Hour,
		8 Hour
	];

	defaultCleavageTemperature = If[MatchQ[myPolymer, RNA],
		65 Celsius,
		55 Celsius
	];

	defaultCleavageSolution = If[MatchQ[myPolymer, RNA],
		Model[Sample, StockSolution, "id:Vrbp1jK73WMm"], (*Model[Sample, StockSolution, "RNA Cleavage solution APA"]*)
		Model[Sample, "id:N80DNjlYwVnD"] (*Model[Sample, "Ammonium hydroxide"] *)
	];

	defaultCapASolution =If[MatchQ[myPolymer, RNA],
		Model[Sample, "id:WNa4ZjRr5lRz"], (* Ultramild CapA *)
		Model[Sample, "id:4pO6dMWvnAKX"] (* CapA with Ac2O *)
	];

	(* generating options that are map thread friendly *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[experimentNNASynthesis, roundedOptions];

	(* List the option symbols that will be used of the oligomer will be cleaved from the solid support and that will be used if the oligomer will remain bound to the solid support *)
	cleavageOptions = If[MatchQ[myPolymer, RNA],
		{CleavageMethod, CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageSolution, CleavageWashSolution, CleavageWashVolume, PostCleavageDesalting, PostCleavageEvaporation},
		{CleavageMethod, CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageSolution, CleavageWashSolution, CleavageWashVolume}
	];
	nonCleavageOptions = {StorageSolvent, StorageSolventVolume};

	(* List the options that will be used if the oligomer will go though the desalting after cleavage and RNA Deprotection *)
	postCleavageDesaltingOptions = {PostCleavageDesaltingSampleLoadRate, PostCleavageDesaltingRinseAndReload, PostCleavageDesaltingRinseAndReloadVolume,
		PostCleavageDesaltingType, PostCleavageDesaltingCartridge, PostCleavageDesaltingPreFlushVolume, PostCleavageDesaltingPreFlushRate,
		PostCleavageDesaltingEquilibrationVolume, PostCleavageDesaltingEquilibrationRate, PostCleavageDesaltingElutionVolume,
		PostCleavageDesaltingElutionRate, PostCleavageDesaltingWashVolume, PostCleavageDesaltingWashRate};

	postRNADeprotectionDesaltingOptions = {PostRNADeprotectionDesaltingSampleLoadRate, PostRNADeprotectionDesaltingRinseAndReload,
		PostRNADeprotectionDesaltingRinseAndReloadVolume, PostRNADeprotectionDesaltingType, PostRNADeprotectionDesaltingCartridge,
		PostRNADeprotectionDesaltingPreFlushVolume, PostRNADeprotectionDesaltingPreFlushRate, PostRNADeprotectionDesaltingEquilibrationVolume,
		PostRNADeprotectionDesaltingEquilibrationRate, PostRNADeprotectionDesaltingElutionVolume, PostRNADeprotectionDesaltingElutionRate,
		PostRNADeprotectionDesaltingWashVolume, PostRNADeprotectionDesaltingWashRate};

	rnaDeprotectionOptions = {RNADeprotectionMethod, RNADeprotectionTime, RNADeprotectionTemperature, RNADeprotectionResuspensionSolution,
		RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime, RNADeprotectionResuspensionTemperature,
		RNADeprotectionSolution, RNADeprotectionSolutionVolume, RNADeprotectionQuenchingSolution, RNADeprotectionQuenchingSolutionVolume,
		PostRNADeprotectionDesalting};

	(* for the case of DNA make an empty list instead of rnaDeprotectionMethodPackets so we can use it as an input for the MapThread function *)
	If[
		MatchQ[myPolymer, DNA],
		rnaDeprotectionMethodPackets = Table[Null, Length[strands]]
	];


	(* Because RNA and DNA will have different variables used in the MapThread and assigned as an output, we will do the assignment later *)
	mapThreadOutput = Transpose[MapThread[Function[{nextStrand, nextMapThreadOptions, nextCleavageMethodPacket, nextRNADeprotectionMethodPacket},
		Module[
			{
				specifiedCleavage, specifiedCleavageTime, specifiedCleavageTemperature, specifiedCleavageSolutionVolume,
				specifiedCleavageSolution, specifiedCleavageWashSolution, specifiedCleavageWashVolume, specifiedStorageSolvent, specifiedStorageSolventVolume,
				cleavageFalseConflictBool, cleavageTrueConflictBool, cleavageOptionSetConflictBool, cleavageMethodConflict, cleavageDesaltingSetConflictBool,
				mismatchedColumnAndStrand, mismatchedColumnAndScale, rnaDeprotectionOptionSetConflictBool,
				rnaDeprotectionMethodMismatch, rnaDeprotectionResuspensionRequired, desaltingFalseConflictBool, rnaDeprotectionFalseConflictBool,
				cleavageOptionsSpecified, cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecified, nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBool,
				cleavageTrueNullConflictBool, cleavageFalseNullConflictBool,
				columnModelPacket, monomersInStrand, resinMatchesBool, monomersSansResin,
				specifiedColumn, specifiedScale, activeSites,
				resolvedCleavage, resolvedCleavageTime, resolvedCleavageTemperature, resolvedCleavageSolution, resolvedCleavageSolutionVolume, resolvedCleavageWashSolution, resolvedCleavageWashVolume, resolvedStorageSolvent,
				allOutputDNA, allOutputRNA,
				postCleavageDesaltingOptionsSpecified, postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBool, postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBool,
				rnaDeprotectionOptionsSpecified, rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBool, cleavageDesaltingConflictBool, deprotectionDesaltingConflictBool, rnaDeprotectionResuspensionConflict, postCleavageDesaltingFalseConflictBool, postRNADeprotectionDesaltingFalseConflictBool,
				specifiedPostCleavageEvaporation, specifiedPostCleavageDesalting, specifiedPostCleavageDesaltingSampleLoadRate, specifiedPostCleavageDesaltingRinseAndReload, specifiedPostCleavageDesaltingRinseAndReloadVolume, specifiedPostCleavageDesaltingType, specifiedPostCleavageDesaltingCartridge, specifiedPostCleavageDesaltingPreFlushVolume, specifiedPostCleavageDesaltingPreFlushRate, specifiedPostCleavageDesaltingEquilibrationVolume, specifiedPostCleavageDesaltingEquilibrationRate, specifiedPostCleavageDesaltingElutionVolume, specifiedPostCleavageDesaltingElutionRate, specifiedPostCleavageDesaltingWashVolume, specifiedPostCleavageDesaltingWashRate,
				specifiedRNADeprotection, specifiedRNADeprotectionMethod, specifiedRNADeprotectionTime, specifiedRNADeprotectionTemperature, specifiedRNADeprotectionResuspensionSolution, specifiedRNADeprotectionResuspensionVolume, specifiedRNADeprotectionResuspensionTime, specifiedRNADeprotectionResuspensionTemperature, specifiedRNADeprotectionSolution, specifiedRNADeprotectionSolutionVolume, specifiedRNADeprotectionQuenchingSolution, specifiedRNADeprotectionQuenchingSolutionVolume,
				specifiedPostRNADeprotectionEvaporation,
				specifiedPostRNADeprotectionDesalting, specifiedPostRNADeprotectionDesaltingSampleLoadRate, specifiedPostRNADeprotectionDesaltingRinseAndReload, specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, specifiedPostRNADeprotectionDesaltingType, specifiedPostRNADeprotectionDesaltingCartridge, specifiedPostRNADeprotectionDesaltingPreFlushVolume, specifiedPostRNADeprotectionDesaltingPreFlushRate, specifiedPostRNADeprotectionDesaltingEquilibrationVolume, specifiedPostRNADeprotectionDesaltingEquilibrationRate, specifiedPostRNADeprotectionDesaltingElutionVolume, specifiedPostRNADeprotectionDesaltingElutionRate, specifiedPostRNADeprotectionDesaltingWashVolume, specifiedPostRNADeprotectionDesaltingWashRate,
				specifiedPostCleavageDesaltingInstrument, specifiedPostRNADeprotectionDesaltingInstrument, specifiedPostCleavageDesaltingPreFlushBuffer, specifiedPostCleavageDesaltingEquilibrationBuffer, specifiedPostCleavageDesaltingWashBuffer, specifiedPostCleavageDesaltingElutionBuffer, specifiedPostRNADeprotectionDesaltingPreFlushBuffer, specifiedPostRNADeprotectionDesaltingEquilibrationBuffer, specifiedPostRNADeprotectionDesaltingWashBuffer, specifiedPostRNADeprotectionDesaltingElutionBuffer, resolvedPostCleavageDesalting, resolvedPostRNADeprotectionDesalting, resolvedPostCleavageEvaporation, resolvedRNADeprotection,
				resolvedRNADeprotectionResuspensionVolume, resolvedRNADeprotectionResuspensionSolution, resolvedRNADeprotectionResuspensionTime, resolvedRNADeprotectionResuspensionTemperature, resolvedRNADeprotectionTime, resolvedRNADeprotectionTemperature, resolvedRNADeprotectionSolution, resolvedRNADeprotectionSolutionVolume, resolvedRNADeprotectionQuenchingSolution, resolvedRNADeprotectionQuenchingSolutionVolume, resolvedPostRNADeprotectionEvaporation, rnaDeprotectionResuspensionConflictBool,
				calculatedVolumePostCleavage, calculatedVolumePostRNADeprotection, deprotectionEvaporationConflictBool, resolvedPostCleavageDesaltingCorrected, resolvedPostRNADeprotectionDesaltingCorrected},

			(* Setup our error tracking variables *)
			{cleavageFalseConflictBool, cleavageTrueConflictBool, cleavageOptionSetConflictBool, cleavageMethodConflict, cleavageDesaltingSetConflictBool, mismatchedColumnAndStrand, mismatchedColumnAndScale, rnaDeprotectionOptionSetConflictBool, rnaDeprotectionMethodMismatch, rnaDeprotectionResuspensionRequired, desaltingFalseConflictBool, rnaDeprotectionFalseConflictBool, postCleavageDesaltingFalseConflictBool, postCleavageDesaltingTrueNullConflictBool, postRNADeprotectionDesaltingTrueNullConflictBool, postRNADeprotectionDesaltingFalseConflictBool} = ConstantArray[False, 16];

			(* Lookup the options we care about *)
			Switch[myPolymer,
				DNA,
				{
					specifiedCleavage, specifiedCleavageTime, specifiedCleavageTemperature, specifiedCleavageSolutionVolume,
					specifiedCleavageSolution, specifiedCleavageWashSolution, specifiedCleavageWashVolume, specifiedStorageSolvent, specifiedStorageSolventVolume,
					specifiedColumn, specifiedScale
				} = Lookup[nextMapThreadOptions,
					{
						Cleavage, CleavageTime, CleavageTemperature, CleavageSolutionVolume,
						CleavageSolution, CleavageWashSolution, CleavageWashVolume, StorageSolvent, StorageSolventVolume,
						Columns, Scale
					}],
				RNA,
				{
					specifiedCleavage, specifiedCleavageTime, specifiedCleavageTemperature, specifiedCleavageSolutionVolume,
					specifiedCleavageSolution, specifiedCleavageWashSolution, specifiedCleavageWashVolume, specifiedStorageSolvent, specifiedStorageSolventVolume,
					specifiedColumn, specifiedScale,
					specifiedPostCleavageEvaporation, specifiedPostCleavageDesalting, specifiedPostCleavageDesaltingSampleLoadRate, specifiedPostCleavageDesaltingRinseAndReload, specifiedPostCleavageDesaltingRinseAndReloadVolume, specifiedPostCleavageDesaltingType, specifiedPostCleavageDesaltingCartridge, specifiedPostCleavageDesaltingPreFlushVolume, specifiedPostCleavageDesaltingPreFlushRate, specifiedPostCleavageDesaltingEquilibrationVolume, specifiedPostCleavageDesaltingEquilibrationRate, specifiedPostCleavageDesaltingElutionVolume, specifiedPostCleavageDesaltingElutionRate, specifiedPostCleavageDesaltingWashVolume, specifiedPostCleavageDesaltingWashRate,
					specifiedRNADeprotection, specifiedRNADeprotectionMethod, specifiedRNADeprotectionTime, specifiedRNADeprotectionTemperature, specifiedRNADeprotectionResuspensionSolution, specifiedRNADeprotectionResuspensionVolume, specifiedRNADeprotectionResuspensionTime, specifiedRNADeprotectionResuspensionTemperature, specifiedRNADeprotectionSolution, specifiedRNADeprotectionSolutionVolume, specifiedRNADeprotectionQuenchingSolution, specifiedRNADeprotectionQuenchingSolutionVolume,
					specifiedPostRNADeprotectionEvaporation,
					specifiedPostRNADeprotectionDesalting, specifiedPostRNADeprotectionDesaltingSampleLoadRate, specifiedPostRNADeprotectionDesaltingRinseAndReload, specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, specifiedPostRNADeprotectionDesaltingType, specifiedPostRNADeprotectionDesaltingCartridge, specifiedPostRNADeprotectionDesaltingPreFlushVolume, specifiedPostRNADeprotectionDesaltingPreFlushRate, specifiedPostRNADeprotectionDesaltingEquilibrationVolume, specifiedPostRNADeprotectionDesaltingEquilibrationRate, specifiedPostRNADeprotectionDesaltingElutionVolume, specifiedPostRNADeprotectionDesaltingElutionRate, specifiedPostRNADeprotectionDesaltingWashVolume, specifiedPostRNADeprotectionDesaltingWashRate,
					specifiedPostCleavageDesaltingInstrument, specifiedPostRNADeprotectionDesaltingInstrument, specifiedPostCleavageDesaltingPreFlushBuffer, specifiedPostCleavageDesaltingEquilibrationBuffer, specifiedPostCleavageDesaltingWashBuffer, specifiedPostCleavageDesaltingElutionBuffer, specifiedPostRNADeprotectionDesaltingPreFlushBuffer, specifiedPostRNADeprotectionDesaltingEquilibrationBuffer, specifiedPostRNADeprotectionDesaltingWashBuffer, specifiedPostRNADeprotectionDesaltingElutionBuffer
				} = Lookup[nextMapThreadOptions,
					{
						Cleavage, CleavageTime, CleavageTemperature, CleavageSolutionVolume,
						CleavageSolution, CleavageWashSolution, CleavageWashVolume, StorageSolvent, StorageSolventVolume,
						Columns, Scale,
						PostCleavageEvaporation, PostCleavageDesalting, PostCleavageDesaltingSampleLoadRate, PostCleavageDesaltingRinseAndReload, PostCleavageDesaltingRinseAndReloadVolume, PostCleavageDesaltingType, PostCleavageDesaltingCartridge, PostCleavageDesaltingPreFlushVolume, PostCleavageDesaltingPreFlushRate, PostCleavageDesaltingEquilibrationVolume, PostCleavageDesaltingEquilibrationRate, PostCleavageDesaltingElutionVolume, PostCleavageDesaltingElutionRate, PostCleavageDesaltingWashVolume, PostCleavageDesaltingWashRate,
						RNADeprotection, RNADeprotectionMethod, RNADeprotectionTime, RNADeprotectionTemperature, RNADeprotectionResuspensionSolution, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime, RNADeprotectionResuspensionTemperature, RNADeprotectionSolution, RNADeprotectionSolutionVolume, RNADeprotectionQuenchingSolution, RNADeprotectionQuenchingSolutionVolume,
						PostRNADeprotectionEvaporation,
						PostRNADeprotectionDesalting, PostRNADeprotectionDesaltingSampleLoadRate, PostRNADeprotectionDesaltingRinseAndReload, PostRNADeprotectionDesaltingRinseAndReloadVolume, PostRNADeprotectionDesaltingType, PostRNADeprotectionDesaltingCartridge, PostRNADeprotectionDesaltingPreFlushVolume, PostRNADeprotectionDesaltingPreFlushRate, PostRNADeprotectionDesaltingEquilibrationVolume, PostRNADeprotectionDesaltingEquilibrationRate, PostRNADeprotectionDesaltingElutionVolume, PostRNADeprotectionDesaltingElutionRate, PostRNADeprotectionDesaltingWashVolume, PostRNADeprotectionDesaltingWashRate,
						PostCleavageDesaltingInstrument, PostRNADeprotectionDesaltingInstrument, PostCleavageDesaltingPreFlushBuffer, PostCleavageDesaltingEquilibrationBuffer, PostCleavageDesaltingWashBuffer, PostCleavageDesaltingElutionBuffer, PostRNADeprotectionDesaltingPreFlushBuffer, PostRNADeprotectionDesaltingEquilibrationBuffer, PostRNADeprotectionDesaltingWashBuffer, PostRNADeprotectionDesaltingElutionBuffer
					}]
			];

			(* we have to resolve cleavage Desalting for RNA first since if we are required to do it we would also require Cleavage *)
			If[MatchQ[myPolymer, RNA],

				Module[{},
					(* generate a list of symbols indicating what if any post cleavage desalting options were specified  *)
					postCleavageDesaltingOptionsSpecified = PickList[postCleavageDesaltingOptions, Lookup[nextMapThreadOptions, postCleavageDesaltingOptions], Except[Automatic | Null]];

					postCleavageDesaltingOptionsSpecifiedNull = PickList[postCleavageDesaltingOptions, Lookup[nextMapThreadOptions, postCleavageDesaltingOptions], Null];

					(* Generate a bool indicating indicating whether Desalting was specified as True but Desalting options were specified as Null*)
					postCleavageDesaltingTrueNullConflictBool = (TrueQ[specifiedPostCleavageDesalting] && Length[cleavageOptionsSpecifiedNull] > 0);

					(* Generate a bool indicating whether Desalting was specified as False but Desalting options were specified *)
					postCleavageDesaltingFalseConflictBool = (MatchQ[specifiedPostCleavageDesalting, False] && Length[postCleavageDesaltingOptionsSpecified] > 0);

					(* Resolve Post Cleavage Desalting *)
					resolvedPostCleavageDesalting =
						Which[
							(* If Cleavage is specified, use that *)
							MatchQ[specifiedPostCleavageDesalting, BooleanP],
							specifiedPostCleavageDesalting,

							(* If desalting options are a non-Null/non-Automatic value, resolve Automatic to True *)
							!MatchQ[postCleavageDesaltingOptionsSpecified, {}],
							True,

							(* If desalting options are Null, resolve Automatic to False *)
							!MatchQ[postCleavageDesaltingOptionsSpecifiedNull, {}],
							False,

							(*Otherwise, resolve Automatic to False*)
							True,
							False
						];

					(* postRNADeprotectionDesalting *)

					(* generate a list of symbols indicating what if any post cleavage desalting options were specified  *)
					postRNADeprotectionDesaltingOptionsSpecified = PickList[postRNADeprotectionDesaltingOptions, Lookup[nextMapThreadOptions, postRNADeprotectionDesaltingOptions], Except[Automatic | Null]];

					postRNADeprotectionDesaltingOptionsSpecifiedNull = PickList[postRNADeprotectionDesaltingOptions, Lookup[nextMapThreadOptions, postRNADeprotectionDesaltingOptions], Null];

					(* Generate a bool indicating indicating whether Desalting was specified as True but Desalting options were specified as Null*)
					postRNADeprotectionDesaltingTrueNullConflictBool = (TrueQ[specifiedPostRNADeprotectionDesalting] && Length[cleavageOptionsSpecifiedNull] > 0);

					(* Generate a bool indicating whether Desalting was specified as False but Desalting options were specified *)
					postRNADeprotectionDesaltingFalseConflictBool = (MatchQ[specifiedPostRNADeprotectionDesalting, False] && Length[postRNADeprotectionDesaltingOptionsSpecified] > 0);

					(* Resolve Post Deprotection Desalting *)
					resolvedPostRNADeprotectionDesalting =
						Which[
							(* If Desalting is specified, use that *)
							MatchQ[specifiedPostRNADeprotectionDesalting, BooleanP],
							specifiedPostRNADeprotectionDesalting,

							(* If desalting options are a non-Null/non-Automatic value, resolve Automatic to True *)
							!MatchQ[postRNADeprotectionDesaltingOptionsSpecified, {}],
							True,

							(* If desalting options are Null, resolve Automatic to False *)
							!MatchQ[postRNADeprotectionDesaltingOptionsSpecifiedNull, {}],
							False,

							(*Otherwise, resolve Automatic to False*)
							True,
							False
						]];

			];

			(** Cleavage conflicts check **)

			(* Generate a list of symbols indicating what any cleavage related options (if any) were specified as a non-Null value *)
			cleavageOptionsSpecified = PickList[cleavageOptions, Lookup[nextMapThreadOptions, cleavageOptions], Except[Automatic | Null]];

			(* Generate a list of symbols indicating what any cleavage related options (if any) were specified as Null. Disregard CleavageMethod. *)
			cleavageOptionsSpecifiedNull = PickList[DeleteCases[cleavageOptions, CleavageMethod], Lookup[nextMapThreadOptions, DeleteCases[cleavageOptions, CleavageMethod]], Null];

			(* Generate a list of symbols indicating what any non-cleavage related options (if any) were specified. *)
			nonCleavageOptionsSpecified = PickList[nonCleavageOptions, Lookup[nextMapThreadOptions, nonCleavageOptions], Except[Automatic | Null]];

			(* Generate a  list of symbols indicating what any non-cleavage related options (if any) were specified as Null. *)
			nonCleavageOptionsSpecifiedNull = PickList[nonCleavageOptions, Lookup[nextMapThreadOptions, nonCleavageOptions], Null];

			(* Generate a bool indicating whether both cleavage and non-cleavage options were specified as non-Null values. *)
			cleavageOptionSetConflictBool = (Length[cleavageOptionsSpecified] > 0 && Length[nonCleavageOptionsSpecified] > 0);

			(* Generate a bool indicating whether both cleavage and non-cleavage options were specified as Null for each input *)
			cleavageOptionSetNullConflictBool = (Length[cleavageOptionsSpecifiedNull] > 0 && Length[nonCleavageOptionsSpecifiedNull] > 0);

			(* Generate a bool indicating whether Cleavage was specified as True but non-cleavage options were specified *)
			cleavageTrueConflictBool = (TrueQ[specifiedCleavage] && Length[nonCleavageOptionsSpecified] > 0);

			(* Generate a bool indicating indicating whether Cleavage was specified as True but cleavage options were specified as Null*)
			cleavageTrueNullConflictBool = (TrueQ[specifiedCleavage] && Length[cleavageOptionsSpecifiedNull] > 0);

			(* Generate a bool indicating whether Cleavage was specified as False but cleavage options were specified *)
			cleavageFalseConflictBool = (MatchQ[specifiedCleavage, False] && Length[cleavageOptionsSpecified] > 0);

			(* Generate a bool indicating whether Cleavage was specified as False but non cleavage options were specified as Null *)
			cleavageFalseNullConflictBool = (MatchQ[specifiedCleavage, False] && Length[nonCleavageOptionsSpecifiedNull] > 0);


			(*- Resolve Cleavage -*)

			(* Resolve cleavage based on what cleavage-related options were specified *)
			resolvedCleavage =
				Which[
					(* If Cleavage is specified, use that *)
					MatchQ[specifiedCleavage, BooleanP],
					specifiedCleavage,

					(* If CleavageMethod, CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageSolution, CleavageWashVolume, or CleavageWashSolution are a non-Null/non-Automatic value, resolve Automatic to True *)
					!MatchQ[cleavageOptionsSpecified, {}],
					True,

					(* If StorageSolvent or StorageSolventVolume are a non-Null/non-Automatic value, resolve Automatic to False *)
					!MatchQ[nonCleavageOptionsSpecified, {}],
					False,

					(* If CleavageTime, CleavageTemperature, CleavageSolutionVolume, CleavageSolution, CleavageWashVolume, or CleavageWashSolution are Null, resolve Automatic to False *)
					!MatchQ[cleavageOptionsSpecifiedNull, {}],
					False,

					(* If StorageSolvent or StorageSolventVolume are Null, resolve Automatic to True *)
					!MatchQ[nonCleavageOptionsSpecifiedNull, {}],
					True,

					(*Otherwise, resolve Automatic to True*)
					True,
					True
				];

			(* Resolve cleavage time. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageTime =
				Which[
					MatchQ[specifiedCleavageTime, Except[Automatic]],
					specifiedCleavageTime,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageTime],

					True,
					defaultCleavageTime
				];

			(* Resolve cleavage temperature. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageTemperature =
				Which[
					MatchQ[specifiedCleavageTemperature, Except[Automatic]],
					specifiedCleavageTemperature,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageTemperature],

					True,
					defaultCleavageTemperature
				];

			(* Resolve cleavage solution. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageSolution =
				Which[
					MatchQ[specifiedCleavageSolution, Except[Automatic]],
					specifiedCleavageSolution,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageSolution],

					True,
					defaultCleavageSolution
				];

			(* Resolve cleavage solution volume. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageSolutionVolume =
				Which[
					MatchQ[specifiedCleavageSolutionVolume, Except[Automatic]],
					specifiedCleavageSolutionVolume,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageSolutionVolume],

					True,
					800 Microliter
				];


			(* Resolve cleavage wash solution. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageWashSolution =
				Which[
					MatchQ[specifiedCleavageWashSolution, Except[Automatic]],
					specifiedCleavageWashSolution,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageWashSolution],

					True,
					Model[Sample, "Milli-Q water"]
				];


			(* Resolve cleavage wash volume. If the option is specified, use it. If cleavage is False, default to Null. If CleavageMethod is specified, default to the value associated with the method. Otherwise, use the standard default value. *)
			resolvedCleavageWashVolume =
				Which[
					MatchQ[specifiedCleavageWashVolume, Except[Automatic]],
					specifiedCleavageWashVolume,

					MatchQ[resolvedCleavage, False],
					Null,

					MatchQ[nextCleavageMethodPacket, PacketP[]],
					Lookup[nextCleavageMethodPacket, CleavageWashVolume],

					True,
					500 Microliter
				];

			(* Resolve storage solvent. If the option is specified, use it. If cleavage is True, default to Null. Otherwise, use the standard default value. *)
			resolvedStorageSolvent =
				Which[
					MatchQ[specifiedStorageSolvent, Except[Automatic]],
					specifiedStorageSolvent,

					MatchQ[resolvedCleavage, True],
					Null,

					True,
					Model[Sample, "Milli-Q water"]
				];


			(** Columns check **)

			(* Get the packet for column model *)
			columnModelPacket =
				If[MatchQ[specifiedColumn, ObjectP[{Model[Sample], Model[Resin]}]],
					FirstCase[cacheBall, KeyValuePattern[Object -> Download[specifiedColumn, Object]]],
					FirstCase[cacheBall, KeyValuePattern[Object -> Download[Lookup[FirstCase[cacheBall, KeyValuePattern[Object -> Download[specifiedColumn, Object]]], Model], Object]]]
				];

			(* Monomers in the strand we are working with*)
			monomersInStrand = Monomers[nextStrand];

			(* For column and strand, confirm that the oligomer on the resin (if any) matches the first part of the strand being synthesized *)
			{resinMatchesBool, monomersSansResin} =
				Module[{componentObjs, componentPacks, resinPacket},

					resinPacket = If[MatchQ[Lookup[columnModelPacket, Object, Null], ObjectP[Model[Sample]]],

						(* Go through the column model's composition to find the resin *)
						(

							componentObjs = Lookup[
								FirstCase[cacheBall, AssociationMatchP[<|Object -> Lookup[columnModelPacket, Object], Composition -> _|>, AllowForeignKeys -> True]],
								Composition,
								{{Null, Null}}
							][[All, 2]];

							componentPacks = Map[
								Function[{nextComponent},
									FirstCase[cacheBall, AssociationMatchP[<|Object -> Download[nextComponent, Object]|>, AllowForeignKeys -> True]]
								],
								componentObjs
							];

							FirstCase[
								componentPacks,
								AssociationMatchP[<|Type -> Alternatives[Model[Resin, SolidPhaseSupport], Model[Resin]], Strand -> _|>, AllowForeignKeys -> True],
								{}
							]
						),

						(* Otherwise our packet is already a Model[Resin] or Null*)
						Lookup[columnModelPacket, Object, Null]
					];

					If[MatchQ[resinPacket, AssociationMatchP[<|Object -> ObjectP[Model[Resin, SolidPhaseSupport]]|>, AllowForeignKeys -> True]],

						Module[
							{resinOligomer, resinOligomerPacket, resinStrand, resinMonomers, resinSequenceLength, overlappingStrand, nonOverlappingStrand},

							(* Get the Model[Molecule, Oligomer[ on the resin *)
							resinOligomer = Lookup[resinPacket, Strand];

							(* Find the packet corresponding to this oligomer *)
							resinOligomerPacket = FirstCase[cacheBall, KeyValuePattern[{Object -> Download[resinOligomer, Object], Molecule -> _}]];

							(* Get the strand on the resin *)
							resinStrand = ToStrand[Lookup[resinOligomerPacket, Molecule]];

							(* the monomers of the oligomer on the resin, 5' to 3' *)
							resinMonomers = Flatten[Monomers[resinStrand]];

							(* the number of monomers on the resin. *)
							resinSequenceLength = Length[resinMonomers];

							(*Take monomers from the 3' end of the strand to be synthesized, equal to the length of the monomers that are on the resin*)
							overlappingStrand = Take[Flatten[monomersInStrand], -(resinSequenceLength)];

							(* Remaining strand to synthesize *)
							nonOverlappingStrand = Take[Flatten[monomersInStrand], {1, -(resinSequenceLength + 1)}];

							(* Return a bool indicating whether the monomer(s) on the resin match the monomer(s) on the 3' end of the strand being synthesized *)
							{MatchQ[resinMonomers, overlappingStrand], nonOverlappingStrand}
						],

						(* If there is no oligomer on the resin, return True *)
						{True, Flatten[monomersInStrand]}
					]
				];

			(* If any columns were given as objects, determine the amount of active sites on them *)
			activeSites = If[MatchQ[specifiedColumn, ObjectP[Object[Sample]]],
				Module[{columnObjectPacket, mass, loading},

					(* Get the packet of the column object *)
					columnObjectPacket = FirstCase[cacheBall, KeyValuePattern[{Object -> Download[specifiedColumn, Object], Composition -> _, Mass -> _}]];

					(* Get the packets of the corresponding column models *)
					loading = Module[{resinsFound, loadingFound},

						(* Find all the resins in the column packet we're examining *)
						resinsFound = Cases[
							Lookup[columnObjectPacket, Composition, {{Null, Null}}],
							ObjectReferenceP[Model[Resin]],
							Infinity
						];
						
						(* Get the highest loading of any resins found *)
						loadingFound =FirstOrDefault@Lookup[
							FirstCase[cacheBall, KeyValuePattern[{Object -> Download[#, Object], Loading -> _}]]& /@ resinsFound,
							Loading,
							Null
						];
						
						(* Pick the highest loading amount from the loadings found or return Null if no loading was found *)
						If[MemberQ[Flatten[loadingFound/.Null->{}], GreaterEqualP[(0 * Mole) / Gram]],
							FirstCase[Sort[Flatten[loadingFound]], GreaterEqualP[(0 * Mole) / Gram]],
							Null
						]
					];

					(* Get the masses of the columns *)
					mass = Lookup[columnObjectPacket, Mass];
					
					(* Determine the amount of resin active sites *)
					If[MatchQ[loading, {GreaterEqualP[(0 * Mole) / Gram]..}] && MatchQ[mass, {MassP..}],
						Convert[(mass * loading), Nanomole],

						(* The columns we were provided are invalid and we can't use them. Map across our loadings/masses and return Null if some info was missing *)
						If[MatchQ[loading, GreaterEqualP[(0 * Mole) / Gram]] && MatchQ[mass, MassP],
							Convert[(mass * loading), Nanomole],
							Null
						]
					]
				],
				{}
			];



			If[MatchQ[myPolymer, RNA],

				(* Resolve post-cleavage Evaporation *)
				resolvedPostCleavageEvaporation =
					Which[
						(* use user-specified if present *)
						TrueQ[resolvedCleavage] && MatchQ[specifiedPostCleavageEvaporation, BooleanP],
						specifiedPostCleavageEvaporation,

						(* if we are cleaving, default to True *)
						TrueQ[resolvedCleavage] && MatchQ[specifiedPostCleavageEvaporation, Automatic],
						True,

						(* if we are not cleaving, default to False *)
						!TrueQ[resolvedCleavage],
						False

					];

				(* RNA Deprotection error checking and resolving *)
				(* generate a list of symbols indicating what if any RNA deprotection options were specified  *)
				rnaDeprotectionOptionsSpecified = PickList[DeleteCases[rnaDeprotectionOptions, RNADeprotectionMethod], Lookup[nextMapThreadOptions, DeleteCases[rnaDeprotectionOptions, RNADeprotectionMethod]], Except[Automatic | Null]];

				rnaDeprotectionOptionsSpecifiedNull = PickList[DeleteCases[rnaDeprotectionOptions, RNADeprotectionMethod], Lookup[nextMapThreadOptions, DeleteCases[rnaDeprotectionOptions, RNADeprotectionMethod]], Null];

				(* Generate a bool indicating indicating whether Desalting was specified as True but Desalting options were specified as Null*)
				rnaDeprotectionTrueNullConflictBool = (TrueQ[specifiedRNADeprotection] && Length[rnaDeprotectionOptionsSpecifiedNull] > 0);

				(* Generate a bool indicating whether Desalting was specified as False but Desalting options were specified *)
				rnaDeprotectionFalseConflictBool = (MatchQ[specifiedRNADeprotection, False] && Length[rnaDeprotectionOptionsSpecified] > 0);

				(* Resolve deprotection: if user specified it, use it otherwise resolve based on the specified options for RNADeprotection *)
				resolvedRNADeprotection =
					Which[
						(* If RNA Deprotection is specified, use that *)
						MatchQ[specifiedRNADeprotection, BooleanP],
						specifiedRNADeprotection,

						(* if we do not cleave, we do not deprotect *)
						MatchQ[resolvedCleavage, False],
						False,

						(* If deprotection options are a non-Null/non-Automatic value, resolve Automatic to True *)
						!MatchQ[rnaDeprotectionOptionsSpecified, {}],
						True,

						(* If deprotection options are Null, resolve Automatic to False *)
						!MatchQ[rnaDeprotectionOptionsSpecifiedNull, {}],
						False,

						(*Otherwise, resolve Automatic to True*)
						True,
						True
					];

				(* resolve resuspension Volume *)
				resolvedRNADeprotectionResuspensionVolume =
					Which[
						MatchQ[specifiedRNADeprotectionResuspensionVolume, Except[Automatic]],
						specifiedRNADeprotectionResuspensionVolume,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionResuspensionSolutionVolume],

						True,
						100 Microliter
					];

				(* resolve resuspension solvent/solution *)
				resolvedRNADeprotectionResuspensionSolution =
					Which[
						MatchQ[specifiedRNADeprotectionResuspensionSolution, Except[Automatic]],
						specifiedRNADeprotectionResuspensionSolution,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionResuspensionSolution],

						True,
						Model[Sample, "DMSO, anhydrous"]
					];

				(* resolve resuspension time *)
				resolvedRNADeprotectionResuspensionTime =
					Which[
						MatchQ[specifiedRNADeprotectionResuspensionTime, Except[Automatic]],
						specifiedRNADeprotectionResuspensionTime,

						MatchQ[specifiedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionResuspensionTime],

						True,
						5 Minute
					];

				(* resolve resuspension temperature *)
				resolvedRNADeprotectionResuspensionTemperature =
					Which[
						MatchQ[specifiedRNADeprotectionResuspensionTemperature, Except[Automatic]],
						specifiedRNADeprotectionResuspensionTemperature,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionResuspensionTemperature],

						True,
						55 Celsius
					];

				(* resolve deprotection time *)
				resolvedRNADeprotectionTime =
					Which[
						MatchQ[specifiedRNADeprotectionTime, Except[Automatic]],
						specifiedRNADeprotectionTime,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionTime],

						True,
						2.5 Hour
					];

				(* resolve deprotection temperature *)
				resolvedRNADeprotectionTemperature =
					Which[
						MatchQ[specifiedRNADeprotectionTemperature, Except[Automatic]],
						specifiedRNADeprotectionTemperature,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionTemperature],

						True,
						65 Celsius
					];

				(* resolve deprotection solution *)
				resolvedRNADeprotectionSolution =
					Which[
						MatchQ[specifiedRNADeprotectionSolution, Except[Automatic]],
						specifiedRNADeprotectionSolution,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionSolution],

						True,
						Model[Sample, "id:XnlV5jK6jbk3"](*Model[Sample, "Triethylamine trihydrofluoride"]*)
					];

				(* resolve deprotection volume *)
				resolvedRNADeprotectionSolutionVolume =
					Which[
						MatchQ[specifiedRNADeprotectionSolutionVolume, Except[Automatic]],
						specifiedRNADeprotectionSolutionVolume,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionSolutionVolume],

						True,
						125 Microliter
					];

				(* resolve quenching solution *)
				resolvedRNADeprotectionQuenchingSolution =
					Which[
						MatchQ[specifiedRNADeprotectionQuenchingSolution, Except[Automatic]],
						specifiedRNADeprotectionQuenchingSolution,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionQuenchingSolution],

						True,
						Model[Sample, "RNA Deprotection Quenching buffer"]
					];

				(* resolve quenching solution *)
				resolvedRNADeprotectionQuenchingSolutionVolume =
					Which[
						MatchQ[specifiedRNADeprotectionQuenchingSolutionVolume, Except[Automatic]],
						specifiedRNADeprotectionQuenchingSolutionVolume,

						MatchQ[resolvedRNADeprotection, False],
						Null,

						MatchQ[nextRNADeprotectionMethodPacket, PacketP[]],
						Lookup[nextRNADeprotectionMethodPacket, RNADeprotectionQuenchingSolutionVolume],

						True,
						1.75 Milliliter
					];

				(* resolve post rna deprotection evaporation *)
				resolvedPostRNADeprotectionEvaporation =
					Which[
						(* use user-specified if present *)
						TrueQ[resolvedRNADeprotection] && MatchQ[specifiedPostRNADeprotectionEvaporation, BooleanP],
						specifiedPostRNADeprotectionEvaporation,

						(* if we are cleaving, default to True *)
						TrueQ[resolvedRNADeprotection] && MatchQ[specifiedPostRNADeprotectionEvaporation, Automatic],
						True,

						(* if we are not cleaving, default to False *)
						!TrueQ[resolvedRNADeprotection],
						False

					];

				(* prior to deprotection check that we are performing resuspension *)
				rnaDeprotectionResuspensionConflictBool = Not[(
					(TrueQ[resolvedRNADeprotection] && MatchQ[specifiedRNADeprotectionResuspensionVolume, VolumeP]) ||
						(MatchQ[resolvedRNADeprotection, False] && MatchQ[specifiedRNADeprotectionResuspensionVolume, Automatic]) ||
						(TrueQ[resolvedRNADeprotection] && MatchQ[specifiedRNADeprotectionResuspensionVolume, Automatic])
				)];

				(* check that we are performing evaporation prior to deprotection *)
				deprotectionEvaporationConflictBool = Not[((TrueQ[resolvedRNADeprotection] && TrueQ[resolvedPostCleavageEvaporation]) || MatchQ[resolvedRNADeprotection, False])];

				(* Desalting conflict checks *)
				cleavageDesaltingConflictBool = (MatchQ[resolvedCleavage, False] && TrueQ[resolvedPostCleavageDesalting]);
				deprotectionDesaltingConflictBool = (MatchQ[resolvedRNADeprotection, False] && TrueQ[resolvedPostRNADeprotectionDesalting]);

				(* now that we know that there are conflicts for desalting we can fix them while remembering that we had an issue *)
				resolvedPostCleavageDesaltingCorrected=Which[
					(* if we resolved desalting to false, return false *)
					MatchQ[resolvedPostCleavageDesalting, False],
					False,
					(* if desalting is true, but cleavage is false, return false *)
					TrueQ[resolvedPostCleavageDesalting] && MatchQ[resolvedCleavage, False],
					False,
					(* otherwise, return True *)
					True,
					True
				];
				resolvedPostRNADeprotectionDesaltingCorrected=Which[
					(* if we resolved desalting to false, return false *)
					MatchQ[resolvedPostRNADeprotectionDesalting, False],
					False,
					(* if desalting is true, but cleavage is false, return false *)
					TrueQ[resolvedPostRNADeprotectionDesalting] && MatchQ[resolvedRNADeprotection, False],
					False,
					(* otherwise, return True *)
					True,
					True
				];

				(* calculate volume of the samples after cleavage/deprotection *)
				calculatedVolumePostCleavage = resolvedCleavageSolutionVolume + resolvedCleavageWashVolume;
				calculatedVolumePostRNADeprotection = resolvedRNADeprotectionResuspensionVolume + resolvedRNADeprotectionSolutionVolume + resolvedRNADeprotectionQuenchingSolutionVolume;
			];



			(* setting up outputs specific for DNA and RNA *)
			allOutputDNA = {
				cleavageOptionsSpecified, nonCleavageOptionsSpecified, cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecifiedNull, nonCleavageOptionsSpecified,
				cleavageOptionSetConflictBool, cleavageOptionSetNullConflictBool, cleavageTrueConflictBool, cleavageFalseConflictBool, cleavageTrueNullConflictBool, cleavageFalseNullConflictBool,
				resolvedCleavage, resolvedCleavageTime, resolvedCleavageTemperature, resolvedCleavageSolution, resolvedCleavageSolutionVolume, resolvedCleavageWashSolution, resolvedCleavageWashVolume, resolvedStorageSolvent,
				specifiedScale, specifiedColumn, columnModelPacket, resinMatchesBool, monomersSansResin, activeSites
			};

			allOutputRNA = {
				cleavageOptionsSpecified, nonCleavageOptionsSpecified, cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecifiedNull, nonCleavageOptionsSpecified,
				cleavageOptionSetConflictBool, cleavageOptionSetNullConflictBool, cleavageTrueConflictBool, cleavageFalseConflictBool, cleavageTrueNullConflictBool, cleavageFalseNullConflictBool,
				resolvedCleavage, resolvedCleavageTime, resolvedCleavageTemperature, resolvedCleavageSolution, resolvedCleavageSolutionVolume, resolvedCleavageWashSolution, resolvedCleavageWashVolume, resolvedStorageSolvent,
				specifiedScale, specifiedColumn, columnModelPacket, resinMatchesBool, monomersSansResin, activeSites,
				resolvedPostCleavageEvaporation, postCleavageDesaltingOptionsSpecified, postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBool, postCleavageDesaltingFalseConflictBool,
				rnaDeprotectionOptionsSpecified, rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBool, rnaDeprotectionFalseConflictBool, resolvedRNADeprotection, resolvedRNADeprotectionResuspensionVolume, resolvedRNADeprotectionResuspensionSolution, resolvedRNADeprotectionResuspensionTime, resolvedRNADeprotectionResuspensionTemperature, resolvedRNADeprotectionTime, resolvedRNADeprotectionTemperature, resolvedRNADeprotectionSolution, resolvedRNADeprotectionSolutionVolume, resolvedRNADeprotectionQuenchingSolution, resolvedRNADeprotectionQuenchingSolutionVolume, resolvedPostRNADeprotectionEvaporation,
				rnaDeprotectionResuspensionConflict, cleavageDesaltingConflictBool, deprotectionDesaltingConflictBool, resolvedPostCleavageDesaltingCorrected, resolvedPostRNADeprotectionDesaltingCorrected, postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBool, postRNADeprotectionDesaltingFalseConflictBool, rnaDeprotectionResuspensionConflictBool, deprotectionEvaporationConflictBool,
				(* Specified PostCleavageDesalting parameters - will need them for the SPE resolver*)
				specifiedPostCleavageDesaltingInstrument, specifiedPostCleavageDesaltingPreFlushBuffer, specifiedPostCleavageDesaltingEquilibrationBuffer, specifiedPostCleavageDesaltingWashBuffer, specifiedPostCleavageDesaltingElutionBuffer, specifiedPostCleavageDesaltingSampleLoadRate, specifiedPostCleavageDesaltingRinseAndReload, specifiedPostCleavageDesaltingRinseAndReloadVolume, specifiedPostCleavageDesaltingType, specifiedPostCleavageDesaltingCartridge, specifiedPostCleavageDesaltingPreFlushVolume, specifiedPostCleavageDesaltingPreFlushRate, specifiedPostCleavageDesaltingEquilibrationVolume, specifiedPostCleavageDesaltingEquilibrationRate, specifiedPostCleavageDesaltingElutionVolume, specifiedPostCleavageDesaltingElutionRate, specifiedPostCleavageDesaltingWashVolume, specifiedPostCleavageDesaltingWashRate, calculatedVolumePostCleavage,
				(* Specified PostRNADeprotectionDesalting parameters - will need them for the SPE resolver*)
				specifiedPostRNADeprotectionDesaltingInstrument, specifiedPostRNADeprotectionDesaltingPreFlushBuffer, specifiedPostRNADeprotectionDesaltingEquilibrationBuffer, specifiedPostRNADeprotectionDesaltingWashBuffer, specifiedPostRNADeprotectionDesaltingElutionBuffer, specifiedPostRNADeprotectionDesaltingSampleLoadRate, specifiedPostRNADeprotectionDesaltingRinseAndReload, specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, specifiedPostRNADeprotectionDesaltingType, specifiedPostRNADeprotectionDesaltingCartridge, specifiedPostRNADeprotectionDesaltingPreFlushVolume, specifiedPostRNADeprotectionDesaltingPreFlushRate, specifiedPostRNADeprotectionDesaltingEquilibrationVolume, specifiedPostRNADeprotectionDesaltingEquilibrationRate, specifiedPostRNADeprotectionDesaltingElutionVolume, specifiedPostRNADeprotectionDesaltingElutionRate, specifiedPostRNADeprotectionDesaltingWashVolume, specifiedPostRNADeprotectionDesaltingWashRate, calculatedVolumePostRNADeprotection
			};

			Switch[myPolymer,
				DNA,
				allOutputDNA,
				RNA,
				allOutputRNA
			]
		]
	], {strands, mapThreadFriendlyOptions, cleavageMethodPackets, rnaDeprotectionMethodPackets}
	]];


	(* Assign the results of the MapThread over samples to the correct variables *)
	Switch[myPolymer,
		DNA,
		{
			cleavageOptionsSpecified, nonCleavageOptionsSpecified, cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecifiedNull, nonCleavageOptionsSpecified,
			cleavageOptionSetConflictBools, cleavageOptionSetNullConflictBools, cleavageTrueConflictBools, cleavageFalseConflictBools, cleavageTrueNullConflictBools, cleavageFalseNullConflictBools,
			resolvedCleavages, resolvedCleavageTimes, resolvedCleavageTemperatures, resolvedCleavageSolutions, resolvedCleavageSolutionVolumes, resolvedCleavageWashSolutions, resolvedCleavageWashVolumes, resolvedStorageSolvents,
			specifiedScales, specifiedColumns, columnModelPackets, resinMatchesBools, monomersSansResins, activeSitesS

		} = mapThreadOutput,
		RNA,
		{
			cleavageOptionsSpecified, nonCleavageOptionsSpecified, cleavageOptionsSpecifiedNull, nonCleavageOptionsSpecifiedNull, nonCleavageOptionsSpecified,
			cleavageOptionSetConflictBools, cleavageOptionSetNullConflictBools, cleavageTrueConflictBools, cleavageFalseConflictBools, cleavageTrueNullConflictBools, cleavageFalseNullConflictBools,
			resolvedCleavages, resolvedCleavageTimes, resolvedCleavageTemperatures, resolvedCleavageSolutions, resolvedCleavageSolutionVolumes, resolvedCleavageWashSolutions, resolvedCleavageWashVolumes, resolvedStorageSolvents,
			specifiedScales, specifiedColumns, columnModelPackets, resinMatchesBools, monomersSansResins, activeSitesS,
			resolvedPostCleavageEvaporation, postCleavageDesaltingOptionsSpecified, postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools, postCleavageDesaltingFalseConflictBools,
			rnaDeprotectionOptionsSpecified, rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools, rnaDeprotectionFalseConflictBools, resolvedRNADeprotection, resolvedRNADeprotectionResuspensionVolume, resolvedRNADeprotectionResuspensionSolution, resolvedRNADeprotectionResuspensionTime, resolvedRNADeprotectionResuspensionTemperature, resolvedRNADeprotectionTime, resolvedRNADeprotectionTemperature, resolvedRNADeprotectionSolution, resolvedRNADeprotectionSolutionVolume, resolvedRNADeprotectionQuenchingSolution, resolvedRNADeprotectionQuenchingSolutionVolume, resolvedPostRNADeprotectionEvaporation,
			rnaDeprotectionResuspensionConflicts, cleavageDesaltingConflictBools, deprotectionDesaltingConflictBools, resolvedPostCleavageDesalting, resolvedPostRNADeprotectionDesalting, postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools, postRNADeprotectionDesaltingFalseConflictBools, rnaDeprotectionResuspensionConflictBools, rnaDeprotectionEvaporationConflictBools,
			specifiedPostCleavageDesaltingInstruments, specifiedPostCleavageDesaltingPreFlushBuffer, specifiedPostCleavageDesaltingEquilibrationBuffer, specifiedPostCleavageDesaltingWashBuffer, specifiedPostCleavageDesaltingElutionBuffer, specifiedPostCleavageDesaltingSampleLoadRate, specifiedPostCleavageDesaltingRinseAndReload, specifiedPostCleavageDesaltingRinseAndReloadVolume, specifiedPostCleavageDesaltingType, specifiedPostCleavageDesaltingCartridge, specifiedPostCleavageDesaltingPreFlushVolume, specifiedPostCleavageDesaltingPreFlushRate, specifiedPostCleavageDesaltingEquilibrationVolume, specifiedPostCleavageDesaltingEquilibrationRate, specifiedPostCleavageDesaltingElutionVolume, specifiedPostCleavageDesaltingElutionRate, specifiedPostCleavageDesaltingWashVolume, specifiedPostCleavageDesaltingWashRate, calculatedVolumePostCleavage,
			specifiedPostRNADeprotectionDesaltingInstruments, specifiedPostRNADeprotectionDesaltingPreFlushBuffer, specifiedPostRNADeprotectionDesaltingEquilibrationBuffer, specifiedPostRNADeprotectionDesaltingWashBuffer, specifiedPostRNADeprotectionDesaltingElutionBuffer, specifiedPostRNADeprotectionDesaltingSampleLoadRate, specifiedPostRNADeprotectionDesaltingRinseAndReload, specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, specifiedPostRNADeprotectionDesaltingType, specifiedPostRNADeprotectionDesaltingCartridge, specifiedPostRNADeprotectionDesaltingPreFlushVolume, specifiedPostRNADeprotectionDesaltingPreFlushRate, specifiedPostRNADeprotectionDesaltingEquilibrationVolume, specifiedPostRNADeprotectionDesaltingEquilibrationRate, specifiedPostRNADeprotectionDesaltingElutionVolume, specifiedPostRNADeprotectionDesaltingElutionRate, specifiedPostRNADeprotectionDesaltingWashVolume, specifiedPostRNADeprotectionDesaltingWashRate, calculatedVolumePostRNADeprotection

		} = mapThreadOutput
	];

	(* since scale can not be inputed as a list, convert to a single value *)
	specifiedScale = Max[specifiedScales];

	(* Assign options we care about to variables *)
	{emailOption, uploadOption, nameOption, specifiedCouplingTime, specifiedStorageSolventVolume} = Lookup[myOptions, {
		Email, Upload, Name, CouplingTime, StorageSolventVolume}
	];


	(* Find any cleavage options that are in conflict *)
	cleavageOptionsInvalid = Flatten[{
		PickList[cleavageOptionsSpecified, cleavageOptionSetConflictBools],
		PickList[nonCleavageOptionsSpecified, cleavageOptionSetConflictBools],
		PickList[cleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools],
		PickList[nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools],
		PickList[nonCleavageOptionsSpecified, cleavageTrueConflictBools],
		PickList[cleavageOptionsSpecified, cleavageFalseConflictBools],
		PickList[cleavageOptionsSpecifiedNull, cleavageTrueNullConflictBools],
		PickList[nonCleavageOptionsSpecifiedNull, cleavageFalseNullConflictBools],
		If[MemberQ[Flatten[{cleavageTrueConflictBools, cleavageFalseConflictBools, cleavageTrueNullConflictBools, cleavageFalseNullConflictBools}], True], Cleavage, {}]
	}];

	(* If any cleavage option sets conflicted with non-Null values and we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageOptionSetConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageOptionSetConflict,
			PickList[cleavageOptionsSpecified, cleavageOptionSetConflictBools],
			PickList[nonCleavageOptionsSpecified, cleavageOptionSetConflictBools],
			"non-Null",
			ObjectToString[PickList[myStrands, cleavageOptionSetConflictBools], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageOptionSetConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageOptionSetConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecified, cleavageOptionSetConflictBools]] <> " (indicating that the oligomer should be cleaved from the solid support) and " <> ToString[PickList[nonCleavageOptionsSpecified, cleavageOptionSetConflictBools]] <> " (indicating that the oligomer should not be cleaved from the solid support) were not both specified as non-Null values for the inputs " <> ObjectToString[PickList[myStrands, cleavageOptionSetConflictBools], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageOptionSetConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecified, cleavageOptionSetConflictBools, False]] <> " (indicating that the oligomer should be cleaved from the solid support) and " <> ToString[PickList[nonCleavageOptionsSpecified, cleavageOptionSetConflictBools, False]] <> " (indicating that the oligomer should not be cleaved from the solid support) were not both specified as non-Null values for the inputs " <> ObjectToString[PickList[myStrands, cleavageOptionSetConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* If any cleavage option sets conflicted with Null values and we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageOptionSetNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageOptionSetConflict,
			PickList[cleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools],
			PickList[nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools],
			"Null",
			ObjectToString[PickList[myStrands, cleavageOptionSetNullConflictBools], Cache -> cacheBall]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageOptionSetNullConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageOptionSetNullConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools]] <> " (indicating that the oligomer should be cleaved from the solid support) and " <> ToString[PickList[nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools]] <> " (indicating that the oligomer should not be cleaved from the solid support) were not both specified as Null for the inputs " <> ObjectToString[PickList[myStrands, cleavageOptionSetNullConflictBools], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageOptionSetNullConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools, False]] <> " (indicating that the oligomer should be cleaved from the solid support) and " <> ToString[PickList[nonCleavageOptionsSpecifiedNull, cleavageOptionSetNullConflictBools, False]] <> " (indicating that the oligomer should not be cleaved from the solid support) were not both specified as Null for the inputs " <> ObjectToString[PickList[myStrands, cleavageOptionSetNullConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* If Cleavage was True and conflicted with any non-cleavage options and  we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageTrueConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageConflict,
			True,
			PickList[nonCleavageOptionsSpecified, cleavageTrueConflictBools],
			"non-Null",
			ObjectToString[PickList[myStrands, cleavageTrueConflictBools], Cache -> cacheBall],
			False
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageTrueConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageTrueConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[nonCleavageOptionsSpecified, cleavageTrueConflictBools, True]] <> " (indicating that the oligomer should not be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueConflictBools, False], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageTrueConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[nonCleavageOptionsSpecified, cleavageTrueConflictBools, False]] <> " (indicating that the oligomer should not be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* If Cleavage was False and conflicted with any cleavage options and  we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageFalseConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageConflict, False, PickList[cleavageOptionsSpecified, cleavageFalseConflictBools], "non-Null", ObjectToString[PickList[myStrands, cleavageFalseConflictBools], Cache -> cacheBall], True]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageFalseConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageFalseConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecified, cleavageFalseConflictBools, True]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageFalseConflictBools, False], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageFalseConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecified, cleavageFalseConflictBools, False]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageFalseConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* If Cleavage was True and conflicted with any Null cleavage options and we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageTrueNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageConflict, True, PickList[cleavageOptionsSpecifiedNull, cleavageTrueNullConflictBools], "Null", ObjectToString[PickList[myStrands, cleavageTrueNullConflictBools], Cache -> cacheBall], False]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageTrueNullConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageTrueNullConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecifiedNull, cleavageTrueNullConflictBools, True]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueNullConflictBools, True], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageTrueNullConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[cleavageOptionsSpecifiedNull, cleavageTrueNullConflictBools, False]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueNullConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* If Cleavage was True and conflicted with any Null cleavage options and we are throwing messages, throw an error message .*)
	If[MemberQ[cleavageFalseNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::CleavageConflict, False, PickList[nonCleavageOptionsSpecifiedNull, cleavageFalseNullConflictBools], "Null", ObjectToString[PickList[myStrands, cleavageFalseNullConflictBools], Cache -> cacheBall], True]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	cleavageFalseNullConflictTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cleavageFalseNullConflictBools, True],
				Nothing,
				Test["Option values for " <> ToString[PickList[nonCleavageOptionsSpecifiedNull, cleavageFalseNullConflictBools, True]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageFalseNullConflictBools, True], Cache -> cacheBall] <> ":", True, False]
			];

			passingTest = If[!MemberQ[cleavageFalseNullConflictBools, False],
				Nothing,
				Test["Option values for " <> ToString[PickList[nonCleavageOptionsSpecifiedNull, cleavageFalseNullConflictBools, False]] <> " (indicating that the oligomer should be cleaved from the solid support) do not disagree with the Cleavage option for the inputs " <> ObjectToString[PickList[myStrands, cleavageFalseNullConflictBools, False], Cache -> cacheBall] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* RNA-specific error-checking *)
	If[MatchQ[myPolymer, RNA],

		(* desalting invalid options *)
		desaltingOptionsInvalid = Flatten[{
			PickList[postCleavageDesaltingOptionsSpecified, cleavageDesaltingConflictBools],
			PickList[postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools],
			PickList[postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools],
			PickList[postRNADeprotectionDesaltingOptionsSpecified, deprotectionDesaltingConflictBools],
			If[MemberQ[Flatten[{postCleavageDesaltingTrueNullConflictBools, postCleavageDesaltingFalseConflictBools}], True], PostCleavageDesalting, {}],
			If[MemberQ[Flatten[{postRNADeprotectionDesaltingTrueNullConflictBools, postRNADeprotectionDesaltingFalseConflictBools}], True], PostRNADeprotectionDesalting, {}]
		}];

		(* Find any deprotection options that are in conflict *)
		deprotectionOptionsInvalid = Flatten[{
			PickList[rnaDeprotectionOptionsSpecified, rnaDeprotectionFalseConflictBools],
			PickList[rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools],
			If[MemberQ[Flatten[{rnaDeprotectionFalseConflictBools, rnaDeprotectionTrueNullConflictBools}], True], Cleavage, {}],
			If[MemberQ[rnaDeprotectionEvaporationConflictBools, True], PostCleavageEvaporation, {}]
		}];


		(* If Cleavage was False and conflicted with any cleavage options and  we are throwing messages, throw an error message .*)
		If[MemberQ[rnaDeprotectionFalseConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::DeprotectionConflict, False, PickList[rnaDeprotectionOptionsSpecified, rnaDeprotectionFalseConflictBools], "non-Null", ObjectToString[PickList[myStrands, rnaDeprotectionFalseConflictBools], Cache -> cacheBall], True]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		deprotectionFalseConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[rnaDeprotectionFalseConflictBools, True],
					Test["Option values for " <> ToString[PickList[rnaDeprotectionOptionsSpecified, rnaDeprotectionFalseConflictBools, True]] <> " (indicating that the oligomer should have 2-OH protective group removed) agree with the RNADeprotection option for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionFalseConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[rnaDeprotectionFalseConflictBools, False],
					Test["Option values for " <> ToString[PickList[rnaDeprotectionOptionsSpecified, rnaDeprotectionFalseConflictBools, False]] <> " (indicating that the oligomer should have 2-OH protective group removed) agree with the RNADeprotection option for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionFalseConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* If Cleavage was True and conflicted with any Null cleavage options and we are throwing messages, throw an error message .*)
		If[MemberQ[rnaDeprotectionTrueNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::DeprotectionConflict, True, Flatten[PickList[rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools]], "Null", ObjectToString[PickList[myStrands, rnaDeprotectionTrueNullConflictBools], Cache -> cacheBall], False]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		deprotectionTrueNullConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[rnaDeprotectionTrueNullConflictBools, True],
					Test["Option values for " <> ToString[PickList[rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools, True]] <> " (indicating that the oligomer should have 2-OH protection group removed) agree with the RNADeprotection option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueNullConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[rnaDeprotectionTrueNullConflictBools, False],
					Test["Option values for " <> ToString[PickList[rnaDeprotectionOptionsSpecifiedNull, rnaDeprotectionTrueNullConflictBools, False]] <> " (indicating that the oligomer should have 2-OH protection group removed) agree with the RNADeprotection option for the inputs " <> ObjectToString[PickList[myStrands, cleavageTrueNullConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* Desalting options checks *)
		If[MemberQ[postCleavageDesaltingTrueNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::PostCleavageDesaltingSetConflict, True, PickList[postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools], "Null", ObjectToString[PickList[myStrands, postCleavageDesaltingTrueNullConflictBools], Cache -> cacheBall], False]
		];

		(* if we are gathering tests, create passing/failing test with the appropriate result *)
		postCleavageDesaltingTrueNullConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[postCleavageDesaltingTrueNullConflictBools, True],
					Test["Option values for " <> ToString[PickList[postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools, True]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) agree with the PostCleavageDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postCleavageDesaltingTrueNullConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[postCleavageDesaltingTrueNullConflictBools, False],
					Test["Option values for " <> ToString[PickList[postCleavageDesaltingOptionsSpecifiedNull, postCleavageDesaltingTrueNullConflictBools, False]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) agree with the PostCleavageDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postCleavageDesaltingTrueNullConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* If PostCleavageDesalting was False and conflicted with any postCleavageDesalting options and  we are throwing messages, throw an error message .*)
		If[MemberQ[postCleavageDesaltingFalseConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::PostCleavageDesaltingSetConflict, False, PickList[postCleavageDesaltingOptionsSpecified, postCleavageDesaltingFalseConflictBools], "non-Null", ObjectToString[PickList[myStrands, postCleavageDesaltingFalseConflictBools], Cache -> cacheBall], True]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		postCleavageDesaltingFalseConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[postCleavageDesaltingFalseConflictBools, True],
					Test["Option values for " <> ToString[PickList[postCleavageDesaltingOptionsSpecified, postCleavageDesaltingFalseConflictBools, True]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) do not disagree with the PostCleavageDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postCleavageDesaltingFalseConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[postCleavageDesaltingFalseConflictBools, False],
					Test["Option values for " <> ToString[PickList[postCleavageDesaltingOptionsSpecified, postCleavageDesaltingFalseConflictBools, False]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) do not disagree with the PostCleavageDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postCleavageDesaltingFalseConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* Desalting options checks *)
		If[MemberQ[postRNADeprotectionDesaltingTrueNullConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::postRNADeprotectionDesaltingSetConflict, True, PickList[postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools], "Null", ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingTrueNullConflictBools], Cache -> cacheBall], False]
		];

		(* if we are gathering tests, create passing/failing test with the appropriate result *)
		postRNADeprotectionDesaltingTrueNullConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[postRNADeprotectionDesaltingTrueNullConflictBools, True],
					Test["Option values for " <> ToString[PickList[postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools, True]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) agree with the postRNADeprotectionDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingTrueNullConflictBools, False], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[postRNADeprotectionDesaltingTrueNullConflictBools, False],
					Test["Option values for " <> ToString[PickList[postRNADeprotectionDesaltingOptionsSpecifiedNull, postRNADeprotectionDesaltingTrueNullConflictBools, False]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) agree with the postRNADeprotectionDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingTrueNullConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* If postRNADeprotectionDesalting was False and conflicted with any postRNADeprotectionDesalting options and  we are throwing messages, throw an error message .*)
		If[MemberQ[postRNADeprotectionDesaltingFalseConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::postRNADeprotectionDesaltingSetConflict, False, PickList[postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingFalseConflictBools], "non-Null", ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingFalseConflictBools], Cache -> cacheBall], True]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		postRNADeprotectionDesaltingFalseConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[postRNADeprotectionDesaltingFalseConflictBools, True],
					Test["Option values for " <> ToString[PickList[postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingFalseConflictBools, True]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) do not disagree with the postRNADeprotectionDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingFalseConflictBools, False], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[postRNADeprotectionDesaltingFalseConflictBools, False],
					Test["Option values for " <> ToString[PickList[postRNADeprotectionDesaltingOptionsSpecified, postRNADeprotectionDesaltingFalseConflictBools, False]] <> " (indicating that the oligomer should go through desalting after cleavage from the solid support) do not disagree with the postRNADeprotectionDesalting option for the inputs " <> ObjectToString[PickList[myStrands, postRNADeprotectionDesaltingFalseConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

		(* Making sure that desalting is specified only when the parent switch is True *)
		If[MemberQ[cleavageDesaltingConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::DesaltingPriorToCleavage, ObjectToString[PickList[myStrands, cleavageDesaltingConflictBools], Cache -> cacheBall], True, False]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		cleavageDesaltingConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[cleavageDesaltingConflictBools, True],
					Test["PostCleavageDesalting and Cleavage options agree for the inputs " <> ObjectToString[PickList[myStrands, cleavageDesaltingConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[cleavageDesaltingConflictBools, False],
					Test["PostCleavageDesalting and Cleavage options agree for the inputs " <> ObjectToString[PickList[myStrands, cleavageDesaltingConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];


		(*  Making sure that desalting is specified only when the parent switch is True  *)
		If[MemberQ[deprotectionDesaltingConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::DesaltingPriorToDeprotection, ObjectToString[PickList[myStrands, deprotectionDesaltingConflictBools], Cache -> cacheBall], True, False]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		deprotectionDesaltingConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[deprotectionDesaltingConflictBools, True],
					Test["PostRNADeprotectionDesalting and RNADeprotection options agree for the inputs " <> ObjectToString[PickList[myStrands, deprotectionDesaltingConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[deprotectionDesaltingConflictBools, False],
					Test["PostRNADeprotectionDesalting and RNADeprotection options agree for the inputs " <> ObjectToString[PickList[myStrands, deprotectionDesaltingConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];
			],
			Nothing
		];

		(* Making sure that we are resuspending the samples prior to deprotection (after evaporating samples post cleavage) *)
		If[MemberQ[rnaDeprotectionResuspensionConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::DeprotectingWithoutResuspension, True, Null, ObjectToString[PickList[myStrands, rnaDeprotectionResuspensionConflictBools], Cache -> cacheBall]]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		rnaDeprotectionResuspensionConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[rnaDeprotectionResuspensionConflictBools, True],
					Test["Resuspension options are not Null if the RNADeprotection is True for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionResuspensionConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[rnaDeprotectionResuspensionConflictBools, True],
					Test["Resuspension options are not Null if the RNADeprotection is True for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionResuspensionConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];
			],
			Nothing
		];

		(*  Making sure that we evaporate samples prior to deprotection  *)
		If[MemberQ[rnaDeprotectionEvaporationConflictBools, True] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
			Message[Error::NoEvaporationDeprotection, ObjectToString[PickList[myStrands, rnaDeprotectionEvaporationConflictBools], Cache -> cacheBall], True, False]
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		rnaDeprotectionEvaporationConflictTests = If[gatherTests,
			Module[{failingTest, passingTest},
				failingTest = If[MemberQ[rnaDeprotectionEvaporationConflictBools, True],
					Test["RNADeprotection and PostCleavageEvaporation options agree for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionEvaporationConflictBools, True], Cache -> cacheBall] <> ":", True, False],
					Nothing
				];

				passingTest = If[MemberQ[rnaDeprotectionEvaporationConflictBools, False],
					Test["RNADeprotection and PostCleavageEvaporation options agree for the inputs " <> ObjectToString[PickList[myStrands, rnaDeprotectionEvaporationConflictBools, False], Cache -> cacheBall] <> ":", True, True],
					Nothing
				];

				{failingTest, passingTest}
			],
			Nothing
		];

	];


	(* If there are any column objects that were specified multiple times, error *)
	{repeatColumnTest, columnRepeatInvalid} = If[

		(* Check to make sure any column object provided only appears once *)
		MemberQ[
			Length /@ Gather[Download[Cases[specifiedColumns, ObjectP[Object[Sample]]], Object]],
			GreaterP[1]
		],

		(* If we're testing or in Engine, don't throw an error. Otherwise, tell user they can't do that *)
		Switch[{gatherTests, $ECLApplication},
			{True, _}, {Test["Any specified column objects are all unique:", True, False], {Column}},
			{_, Except[Engine]}, (Message[Error::ReusedColumn];{{}, {Column}}),
			{_, _}, {{}, {}}
		],

		If[gatherTests,
			{Test["Any specified column objects are all unique:", True, True], {Column}},
			{{}, {}}
		]
	];

	(*- Error checks related to columns,scale and monomers -*)

	(* Select any column objects that were missing resin loading information *)
	badColumnObjects = If[Length[activeSitesS] > 0,
		PickList[specifiedColumns, activeSitesS, Null],
		{}
	];

	(* If we found bad columns, stash the Columns option as an invalid option*)
	missingColumnLoadingOptions = If[Length[badColumnObjects] > 0,
		{Columns},
		Nothing
	];

	(* If any resins didn't match, pass it to the invalid options *)
	invalidColumnsOption = If[MemberQ[resinMatchesBools, False], {Columns}, Nothing];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[MemberQ[resinMatchesBools, False] && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::MismatchedColumnAndStrand,
			ObjectToString[PickList[specifiedColumns, resinMatchesBools, False], Cache -> cacheBall],
			ObjectToString[PickList[Download[specifiedColumns, Field[Composition[[All, 2]]][Strand][Molecule], Cache -> cacheBall], resinMatchesBools, False], Cache -> cacheBall],
			ObjectToString[PickList[myStrands, resinMatchesBools, False], Cache -> cacheBall]
		]
	];

	(* The unique monomers that are in the input strands. *)
	uniqueMonomers = DeleteDuplicates[Flatten[monomersSansResins]];

	(* The unique modifications that are in the input strands. We count degenerate positions as Modifications
	since they take up a slot on the synthesizer*)
	uniqueModifications = Cases[uniqueMonomers, Modification[___]|LDNA[___]|Alternatives@@degenerateAlphabet];

	(* If the collective number of unique modifications is more than the allowed number of mods for the synthesizer, find any inputs that have modifications *)
	tooManyModsInvalidInputs = If[Length[uniqueModifications] > maxModifications,
		PickList[myStrands, polymerTypes, (_?(MemberQ[Flatten[#], Modification|LDNA] &))],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message*)
	If[Length[tooManyModsInvalidInputs] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::TooManyModifications, ObjectToString[synthesizerOption, Cache -> cacheBall], maxModifications]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyModificationsTests = If[gatherTests,
		If[Length[tooManyModsInvalidInputs] > 0,
			Test["There are less than " <> ToString[maxModifications] <> " unique modifications in the inputs " <> ObjectToString[tooManyModsInvalidInputs, Cache -> cacheBall] <> ":", True, False],
			Test["There are less than " <> ToString[maxModifications] <> " unique modifications in the inputs:", True, True]
		],
		Nothing
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	resinMatchingTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[resinMatchesBools, False],
				Test["Any oligomer that is preloaded on the columns " <> ObjectToString[PickList[specifiedColumns, resinMatchesBools, False], Cache -> cacheBall] <> " matches the 3` end of the input oligomers " <> ObjectToString[PickList[myStrands, resinMatchesBools, False], Cache -> cacheBall] <> ":", True, False],
				Nothing
			];

			passingTest = If[MemberQ[resinMatchesBools, True],
				Test["Any oligomer that is preloaded on the columns " <> ObjectToString[PickList[specifiedColumns, resinMatchesBools, False], Cache -> cacheBall] <> " matches the 3` end of the input oligomers " <> ObjectToString[PickList[myStrands, resinMatchesBools, False], Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		{}
	];


	(* Check that, if we were given column objects, they all had loading information *)
	(* If the user specified column objects that have different loadings, warn them *)
	missingColumnLoadingTest = If[Length[badColumnObjects] > 0,
		Switch[{gatherTests, $ECLApplication},
			{True, _}, Test["The column objects provided (" <> ObjectToString[Cases[badColumnObjects, ObjectReferenceP[Object[Sample]]], Cache -> cacheBall] <> " have information regarding scale and possible loading.", True, False],
			{_, Except[Engine]}, (Message[Error::InvalidResins, ObjectToString[Cases[badColumnObjects, ObjectReferenceP[Object[Sample]]], Cache -> cacheBall]]; Nothing),
			{_, _}, Nothing
		],
		Test["The amount of active sites " <> ToString[activeSitesS] <> " available on " <> ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall] <> " are equivalent " <> ToString[specifiedScale] <> ".", True, True]
	];

	(* If the user specified column objects that have different loadings, warn them *)
	conflictingColumnLoadingTest = If[Length[DeleteDuplicates[activeSitesS]] > 1,
		Switch[{gatherTests, $ECLApplication},
			{True, _}, Warning["The amount of active sites " <> ToString[activeSitesS] <> " available on " <> ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall] <> " are equivalent  " <> ToString[specifiedScale] <> ".", True, False],
			{_, Except[Engine]}, (Message[Warning::ColumnLoadingsDiffer, ToString[activeSitesS], ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall], ToString[specifiedScale]];Nothing),
			{_, _}, Nothing
		],
		If[gatherTests && Length[DeleteDuplicates[activeSitesS]] == 1,
			Warning["The amount of active sites " <> ToString[activeSitesS] <> " available on " <> ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall] <> " are equivalent " <> ToString[specifiedScale] <> ".", True, True],
			Nothing
		]
	];

	(* If any columns were given as objects, determine the scale that we would use based on the column loading.
	DNA synthesis only allows 40, 200, and 1000 nmol scales. Round the amount of active sites up to the closest scale.
	Scale is a single, so only use the largest scale found. (We will throw an error if there were conflicting scales.) *)
	(* this is done because the instrument is not capable of injecting different volumes of reagents in different columns
	 (unless we want to play with Upper Case vs Lower Case specs which would theoretically allow us to make 2 different
	 scales in one experiment, but this is not really needed)*)
	columnSpecifiedScale = If[MemberQ[specifiedColumns, ObjectP[Object[Sample]]],
		Switch[Max[DeleteCases[activeSitesS, Null]],
			LessEqualP[40Nanomole],
			40 Nanomole,
			LessEqualP[200Nanomole],
			0.20 Micromole,
			_,
			1 Micromole
		],
		Null
	];

	(* If any columns were specified as objects and the amount of resin disagrees with the specified scale, throw a warning *)
	columnScaleMismatchTest = If[MatchQ[specifiedScale, Except[Automatic]] && MatchQ[columnSpecifiedScale, Except[Null]] && !Equal[specifiedScale, columnSpecifiedScale],
		Switch[{gatherTests, $ECLApplication},
			{True, _}, Warning["The amount of active sites " <> ToString[columnSpecifiedScale] <> " available on " <> ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall] <> " disagrees with the specified scale  " <> ToString[specifiedScale] <> ".", True, False],
			{_, Except[Engine]}, (Message[Warning::MismatchedColumnAndScale, columnSpecifiedScale, ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall], specifiedScale];Nothing),
			{_, _}, Nothing
		],
		(* Only give the passing warning if the user specified both scale and column objects *)
		If[gatherTests && MatchQ[specifiedScale, Except[Automatic]] && MatchQ[columnSpecifiedScale, Except[Null]],
			Warning["The amount of active sites " <> ToString[columnSpecifiedScale] <> " available on " <> ObjectToString[Cases[specifiedColumns, ObjectP[Object[Sample]]], Cache -> cacheBall] <> " disagrees with the specified scale  " <> ToString[specifiedScale] <> ".", True, True],
			Nothing
		]
	];

	(* If scale is specified, use that. If scale is not specified but any columns are specified as objects, use the column-derived scale. Otherwise, resolve to 200 nmol. *)
	resolvedScale = Which[
		MatchQ[specifiedScale, Except[Automatic]],
		specifiedScale,

		MatchQ[columnSpecifiedScale, Except[Null]],
		columnSpecifiedScale,

		True,
		0.2 Micromole
	];

	(* - Resolve Scale-Dependent options - *)

	(* Resolve storage solvent volume. If the option is specified, use it. If cleavage is True, default to Null. Otherwise, use the standard default value. This option technically should be resolved inside MapThread, but because we are resolving Scale outside we have to resolve this one outside as well*)
	resolvedStorageSolventVolume = MapThread[Function[{cleavage, storageSolventVolume},
		Which[
			MatchQ[storageSolventVolume, Except[Automatic]],
			storageSolventVolume,

			MatchQ[cleavage, True],
			Null,

			True,
			Which[
				Equal[resolvedScale, 40 Nanomole],
				200 Microliter,

				Equal[resolvedScale, 0.2 Micromole],
				400 Microliter,

				Equal[resolvedScale, 1Micromole],
				1000 Microliter
			]
		]
	], {resolvedCleavages, specifiedStorageSolventVolume}];

	(* Resolve InitialWashVolume based on scale *)
	resolvedInitialWashVolume = If[MatchQ[Lookup[roundedOptions, InitialWashVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			200 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			250 Microliter,

			Equal[resolvedScale, 1 Micromole],
			280 Microliter
		],
		Lookup[roundedOptions, InitialWashVolume]
	];

	(* Resolve NumberOfDeprotections based on scale *)
	resolvedNumberOfDeprotections = If[MatchQ[Lookup[roundedOptions, NumberOfDeprotections], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			2,

			Equal[resolvedScale, 0.2 Micromole],
			2,

			Equal[resolvedScale, 1 Micromole],
			3
		],
		Lookup[roundedOptions, NumberOfDeprotections]
	];

	(* Resolve DeprotectionVolume based on scale *)
	resolvedDeprotectionVolume = If[MatchQ[Lookup[roundedOptions, DeprotectionVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			60 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			140 Microliter,

			Equal[resolvedScale, 1 Micromole],
			180 Microliter
		],
		Lookup[roundedOptions, DeprotectionVolume]
	];

	(* Resolve DeprotectionWashVolume based on scale *)
	resolvedDeprotectionWashVolume = If[MatchQ[Lookup[roundedOptions, DeprotectionWashVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			200 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			250 Microliter,

			Equal[resolvedScale, 1 Micromole],
			280 Microliter
		],
		Lookup[roundedOptions, DeprotectionWashVolume]
	];

	(* Resolve ActivatorVolume based on scale *)
	resolvedActivatorVolume = If[MatchQ[Lookup[roundedOptions, ActivatorVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			40 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			45 Microliter,

			Equal[resolvedScale, 1 Micromole],
			115 Microliter
		],
		Lookup[roundedOptions, ActivatorVolume]
	];

	(* Resolve CapAVolume based on scale *)
	resolvedCapAVolume = If[MatchQ[Lookup[roundedOptions, CapAVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			20 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			30 Microliter,

			Equal[resolvedScale, 1 Micromole],
			80 Microliter
		],
		Lookup[roundedOptions, CapAVolume]
	];

	(* Resolve CapBVolume based on scale *)
	resolvedCapBVolume = If[MatchQ[Lookup[roundedOptions, CapBVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			20 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			30 Microliter,

			Equal[resolvedScale, 1 Micromole],
			80 Microliter
		],
		Lookup[roundedOptions, CapBVolume]
	];

	(* Resolve OxidationVolume based on scale *)
	resolvedOxidationVolume = If[MatchQ[Lookup[roundedOptions, OxidationVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			30 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			60 Microliter,

			Equal[resolvedScale, 1 Micromole],
			150 Microliter
		],
		Lookup[roundedOptions, OxidationVolume]
	];

	(* Resolve OxidationWashVolume based on scale *)
	resolvedOxidationWashVolume = If[MatchQ[Lookup[roundedOptions, OxidationWashVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			200 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			250 Microliter,

			Equal[resolvedScale, 1 Micromole],
			280 Microliter
		],
		Lookup[roundedOptions, OxidationWashVolume]
	];

	(* Resolve Secondary OxidationVolume based on scale *)
	resolvedSecondaryOxidationVolume = If[MatchQ[Lookup[roundedOptions, SecondaryOxidationVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			30 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			60 Microliter,

			Equal[resolvedScale, 1 Micromole],
			150 Microliter
		],
		Lookup[roundedOptions, SecondaryOxidationVolume]
	];

	(* Resolve Secondary OxidationWashVolume based on scale *)
	resolvedSecondaryOxidationWashVolume = If[MatchQ[Lookup[roundedOptions, SecondaryOxidationWashVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			200 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			250 Microliter,

			Equal[resolvedScale, 1 Micromole],
			280 Microliter
		],
		Lookup[roundedOptions, SecondaryOxidationWashVolume]
	];

	(* Resolve FinalWashVolume based on scale *)
	resolvedFinalWashVolume = If[MatchQ[Lookup[roundedOptions, FinalWashVolume], Automatic],
		Which[
			Equal[resolvedScale, 40 Nanomole],
			200 Microliter,

			Equal[resolvedScale, 0.2 Micromole],
			250 Microliter,

			Equal[resolvedScale, 1 Micromole],
			280 Microliter
		],
		Lookup[roundedOptions, FinalWashVolume]
	];

	(*- Resolve Phosphoramidites -*)

	resolvedSecondaryOxidationSolution=Which[
		MatchQ[Lookup[myOptions, SecondaryOxidationSolution], Except[Automatic]],
		Lookup[myOptions, SecondaryOxidationSolution],

		!MatchQ[Lookup[myOptions, SecondaryCyclePositions], Null],
		Model[Sample, "id:D8KAEvGOM1PL"], (*"0.05M Sulfurizing Reagent II in pyridine/acetonitrile"*)

		True,
		Null
	];

	(* Get the specified amidites and put them in object form. (This way, if they specified a monomer twice pointing to the same chemical, once by name and once by ID, we don't throw an error.) *)
	specifiedPhosphoramidites = Lookup[roundedOptions, Phosphoramidites] /. {x : ObjectP[] :> Download[x, Object, Cache -> cacheBall]};

	(* If any monomer is specified more than once with different phosphoramidites, throw Error::MonomerPhosphoramiditeConflict and Error::InvalidOption *)
	{invalidOverspecifiedPhosphoramiditesOption, overspecifiedPhosphoramiditesTests} = If[MatchQ[specifiedPhosphoramidites, {{SequenceP, ObjectP[{Model[Sample], Object[Sample]}]}..}],
		Module[{groupedAmidites, doublySpecifiedMonomers, tests},

			(* Group the amidites by monomer then by chemical *)
			groupedAmidites = GatherBy[specifiedPhosphoramidites, {First, Last}];

			(* Get any monomers that are specified multiple times with a different chemical *)
			doublySpecifiedMonomers = PickList[groupedAmidites[[All, 1]][[All, 1]][[All, 1]], Length /@ groupedAmidites, Except[1]];

			(* If there are invalid inputs and we are throwing messages, throw an error message .*)
			If[Length[doublySpecifiedMonomers] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
				Message[Error::MonomerPhosphoramiditeConflict, doublySpecifiedMonomers]
			];

			(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
			tests = If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[Length[doublySpecifiedMonomers] == 0,
						Nothing,
						Test["The monomers " <> ToString[doublySpecifiedMonomers] <> " are each specified with only one chemical in the Phosphoramidites option:", True, False]
					];

					passingTest = If[Length[doublySpecifiedMonomers] == Length[groupedAmidites],
						Nothing,
						Test["The monomers " <> ToString[DeleteDuplicates[specifiedPhosphoramidites[[All, 1]]]] <> " are each specified with only one chemical in the Phosphoramidites option:", True, True]
					];

					{failingTest, passingTest}
				],
				{}
			];

			(* Return the Phosphoramidites symbol if the option is invalid and return the tests *)
			{If[Length[doublySpecifiedMonomers] > 0, Phosphoramidites, {}], tests}
		],
		{{}, {}}
	];

	(* Resolve the amidite for any monomers that the user did not specify *)
	resolvedUnspecifiedAmiditesInitial = Map[Function[{monomer},
		Which[
			(* If the user specified an amidite for this monomer, don't do anything *)
			MemberQ[specifiedPhosphoramidites, {monomer, ObjectP[Model[Sample, StockSolution]]}],
			Nothing,

			(* if user specified a composition for the new Stock Solution, return Nothing here - we will take care of this later *)
			MemberQ[specifiedPhosphoramidites, {monomer, {{ObjectP[Model[Sample, StockSolution]], RangeP[0.`, 1.`]}..}}],
			Nothing,

			(* if user specified a composition for the new Stock Solution, return Nothing here - we will take care of this later *)
			MemberQ[specifiedPhosphoramidites, {monomer, {{SequenceP, RangeP[0.`, 1.`]}..}}],
			Nothing,

			(* If we don't know what amidite to use, don't do anything (we will error later) *)
			!KeyExistsQ[
				Association@Flatten@Physics`Private`lookupModelOligomer[{myPolymer, Modification}, SyntheticMonomers, Head -> True, SynthesisStrategy->Phosphoramidite],
				monomer],
			Nothing,

			(* Otherwise, use the amidite from the lookup for the monomer *)
			True,
			{
				monomer,
				Lookup[
					Association@Flatten@Physics`Private`lookupModelOligomer[{myPolymer, Modification}, SyntheticMonomers, Head -> True, SynthesisStrategy->Phosphoramidite],
					monomer]
			}
		]], uniqueMonomers];

	(* find all monomers that require StockSolution *)
	monomersNeedStockSolutions = Cases[specifiedPhosphoramidites, {SequenceP, {{ObjectP[Model[Sample, StockSolution]], RangeP[0.`, 1.`]}..}}| {SequenceP, {{SequenceP, RangeP[0.`, 1.`]}..}}];

	(* List of all Synthetic Monomers for this Polymer; we are replacing the defaults with user-specified Objects here *)
	allSyntheticMonomers = Append[
		Association@Flatten@Physics`Private`lookupModelOligomer[{myPolymer,Modification},SyntheticMonomers,Head->True, SynthesisStrategy->Phosphoramidite],
		Map[#[[1]]->#[[2]]&,Cases[specifiedPhosphoramidites, {SequenceP, ObjectP[Model[Sample, StockSolution]]}]]
	];

	(* we are collecting new StockSolution packets in this variable*)
	newSSPackets = {};

	(* calculate how much of 0.5M stock we would need to define new StockSolution using fractions we have*)
	(* for the formula we will calculate with 50mL in mind and let SS scale this in accordance with our Resources *)
	newStockSolutions = Module[{newSSNames},
		(* generate the names for our stock solutions *)
		newSSNames=StringRiffle[#[[2, All, 1, 1]], ":"]<>" "<>StringRiffle[#[[2, All, 2]], ":"]<>" "<>ToString[Unique[]]<>ToString[RandomInteger[10000000]]& /@ monomersNeedStockSolutions;

		MapThread[Function[{monomerSpecification,newSSName},Module[
			{
				totalFraction, newFractions, compositionByModel, compositionByPackets,
				volumeIncrementsOfComponents, volumeToMake, stockSolutionPrimitives,
				stockSolutionFormula, newSSpacket},

			(* make sure that we have Spec with total fraction of 1 *)
			totalFraction = Total[monomerSpecification[[2, All, 2]]];
			newFractions = {#[[1]], #[[2]]/totalFraction} & /@ monomerSpecification[[2]];

			(* make our composition of this StockSolution to be packet:fraction tuples *)
			compositionByModel = newFractions /. allSyntheticMonomers;
			compositionByPackets = compositionByModel /. x : ObjectReferenceP[Model[Sample, StockSolution]] :> Experiment`Private`fetchPacketFromCache[x, cacheBall];

			(* TODO if we ever support more than one container, change 50mL to a reasonable dependency of the container (NOT MaxVolume) *)
			volumeIncrementsOfComponents = Lookup[#[[1]], VolumeIncrements] & /@ compositionByPackets;
			volumeToMake = Min[Append[ MapThread[#1/#2[[2]] &, {volumeIncrementsOfComponents, compositionByPackets}], Quantity[50,"Milliliters"]]];

			(* create primitives for new StockSolution *)
			stockSolutionPrimitives = Module[{phosphoramiditeSolidLabels, containerLabel},
				phosphoramiditeSolidLabels = Table["Phosphoramidite Solid "<>ToString[Unique[]],Length[compositionByPackets]];
				containerLabel = "Phosphoramidite bottle "<>ToString[Unique[]];
				{
					(*50mL Phosphoramidite bottles are the only ones we have*)
					(* grab a bottle that the solution will be in *)
					LabelContainer[Label->containerLabel, Container->Model[Container, Vessel, "id:Z1lqpMGjee3W"]], (*"70mL Amber Glass Round Bottom Flask with ABI Septum-Cap"*)
					(* grab dry phosphoramidite samples *)
					LabelSample[
						Label->phosphoramiditeSolidLabels,
						Sample->Map[Download[FirstCase[Lookup[#,Formula],{MassP,_}][[2]], Object]&,compositionByPackets[[All,1]]],
						Amount->Map[FirstCase[Lookup[#,Formula],{MassP,_}][[1]]&,compositionByPackets[[All,1]]]
					],
					(* add acetonitrile to them *)
					Transfer[
						Source->ConstantArray[Model[Sample, "id:wqW9BP774kjw"],Length[phosphoramiditeSolidLabels]], (* Model[Sample,"Acetonitrile, anhydrous, hermetically sealed"] *)
						Destination->phosphoramiditeSolidLabels,
						Amount->Map[First@Lookup[#[[1]],VolumeIncrements]&,compositionByPackets]],
					(* mix *)
					Mix[Sample->phosphoramiditeSolidLabels, MixType->Invert, NumberOfMixes->50, MixUntilDissolved->True],
					(* combine phosphoramidite solutions to make a solution for degenerate base *)
					Transfer[
						Source->phosphoramiditeSolidLabels,
						Destination->ConstantArray[containerLabel,Length[phosphoramiditeSolidLabels]],
						Amount->Map[volumeToMake*#&,compositionByPackets[[All,2]]]],
					(* mix final solution *)
					Mix[Sample->containerLabel, MixType->Swirl]
				}
			];

			(* make a formula for the new StockSolution *)
			stockSolutionFormula = Transpose@{Map[volumeToMake*#&,compositionByPackets[[All,2]]], compositionByModel[[All,1]]};

			(* generate new StockSolution packet *)
			newSSpacket = UploadStockSolution[stockSolutionPrimitives,
				VolumeIncrements -> volumeToMake,
				Name->newSSName,
				Upload -> False
			];

			AppendTo[newSSPackets, newSSpacket];

			{monomerSpecification[[1]],Lookup[newSSpacket, Object]}
		]],{monomersNeedStockSolutions, newSSNames}]];

	(* TODO if frq can accept cache, update this *)
	(* Upload new StockSolutions; we have to do this since frq can not accept fake cache *)
	Upload[newSSPackets];

	(* Append the missing amidite values to any user-specified values. (Note that we put the objects into ID for when assigning it to the specifiedPhosphoramidites variable, so use the pure user-specified option when determining the resolved value.) *)
	resolvedAmidites = Join[
		If[MemberQ[specifiedPhosphoramidites, {SequenceP, ObjectReferenceP[Model[Sample, StockSolution]]}],
			Cases[Lookup[roundedOptions, Phosphoramidites],{SequenceP, ObjectReferenceP[Model[Sample, StockSolution]]},{1}],
			{}
		],
		resolvedUnspecifiedAmiditesInitial,
		newStockSolutions
	];

	(* If we could not resolve the amidite for any monomers, collect them here *)
	unknownMonomers = Complement[uniqueMonomers, resolvedAmidites[[All, 1]]];

	(* If we could not resolve the amidite for any monomers, collect input strands that contain those monomers *)
	unknownMonomerInputs = PickList[myStrands, Flatten /@ monomersSansResins, _?(MemberQ[#, Alternatives @@ unknownMonomers] &)];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[unknownMonomers] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
		Message[Warning::UnknownMonomer, unknownMonomers, unknownMonomerInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	unknownMonomerTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[unknownMonomers] == 0,
				Nothing,
				Warning["The phosphoramidite to use for " <> unknownMonomers <> "in the oligomers " <> ObjectToString[unknownMonomerInputs, Cache -> cacheBall] <> " could be determined:", True, False]
			];

			passingTest = If[Length[unknownMonomers] == Length[uniqueMonomers],
				Nothing,
				Warning["The phosphoramidite to use for " <> unknownMonomers <> "in the oligomers " <> ObjectToString[unknownMonomerInputs, Cache -> cacheBall] <> " could be determined:", True, True]
			];

			{failingTest, passingTest}
		],
		{}
	];

	(*- Resolve NumberOfCouplings -*)

	(* Get the specified NumberOfCouplings *)
	specifiedNumberOfCouplings = Lookup[roundedOptions, NumberOfCouplings];

	(* If any monomer is specified more than once with different NumberOfCouplings, error *)
	{invalidOverspecifiedNumberOfCouplingsOption, overspecifiedNumberOfCouplingsTests} = If[MatchQ[specifiedNumberOfCouplings, {{Alternatives[Modification[_], "Natural"], RangeP[1, 5, 1]}..}],
		Module[{groupedAmidites, doublySpecifiedMonomers, tests},

			(* Group the amidites by monomer then by NumberOfCouplings *)
			groupedAmidites = GatherBy[specifiedNumberOfCouplings, {First, Last}];

			(* Get any monomers that are specified multiple times with a different values *)
			doublySpecifiedMonomers = PickList[groupedAmidites[[All, 1]][[All, 1]][[All, 1]], Length /@ groupedAmidites, Except[1]];

			(* If there are invalid inputs and we are throwing messages, throw an error message .*)
			If[Length[doublySpecifiedMonomers] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
				Message[Error::MonomerNumberOfCouplingsConflict, doublySpecifiedMonomers]
			];

			(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
			tests = If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[Length[doublySpecifiedMonomers] == 0,
						Nothing,
						Test["The monomers " <> doublySpecifiedMonomers <> " are each specified with only one value in the NumberOfCouplings option:", True, False]
					];

					passingTest = If[Length[doublySpecifiedMonomers] == Length[groupedAmidites],
						Nothing,
						Test["The monomers " <> Complement[DeleteDuplicates[specifiedNumberOfCouplings[[All, 1]]], doublySpecifiedMonomers] <> " are each specified with only one value in the NumberOfCouplings option:", True, True]
					];

					{failingTest, passingTest}
				],
				{}
			];

			(* Return the option symbol if the option is invalid and return the tests *)
			{If[Length[doublySpecifiedMonomers] > 0, NumberOfCouplings, {}], tests}
		],
		{{}, {}}
	];

	(* Get the unique monomers with A/T/C/G specified as "Natural" *)
	uniqueModsAndNatural = Switch[myPolymer,
		DNA,
		DeleteDuplicates[uniqueMonomers /. {Alternatives[DNA["C"], DNA["T"], DNA["A"], DNA["G"]] -> "Natural"}],
		RNA,
		DeleteDuplicates[uniqueMonomers /. {Alternatives[RNA["C"], RNA["U"], RNA["A"], RNA["G"]] -> "Natural"}]
	];

	(* Get the default NumberOfCouplings for this scale *)
	defaultNumberOfCouplings = Which[
		Equal[resolvedScale, 40 Nanomole],
		1,

		Equal[resolvedScale, 0.2 Micromole],
		2,

		Equal[resolvedScale, 1 Micromole],
		3
	];

	(* If the specified NumberOfCouplings is Automatic, use the default coupling for this scale. If it is an integer, keep as is. If it is a list of monomer-integer pairs, fill in the values for any missing monomers. Keep in mind that A/T/C/G are grouped together as "Natural". *)
	resolvedNumberOfCouplings = Switch[Lookup[roundedOptions, NumberOfCouplings],
		Automatic,
		defaultNumberOfCouplings,

		RangeP[1, 5, 1],
		Lookup[roundedOptions, NumberOfCouplings],

		_,
		Join[
			Lookup[roundedOptions, NumberOfCouplings],
			Map[
				If[MemberQ[specifiedNumberOfCouplings[[All, 1]], #],
					Nothing,
					{#, defaultNumberOfCouplings}
				]&, uniqueModsAndNatural]
		]
	];

	(*- Resolve PhosphoramiditeVolume -*)

	(* Get the specified PhosphoramiditeVolume and scale them to the same value. (This way, if they specified a monomer twice pointing to the same volume but in different numerical forms, we don't throw an error.) *)
	specifiedPhosphoramiditeVolume = Lookup[roundedOptions, PhosphoramiditeVolume] /. {x : VolumeP :> N[Convert[x, Microliter]]};

	(* If any monomer is specified more than once with different NumberOfCouplings, error *)
	{invalidOverspecifiedPhosphoramiditeVolumeOption, overspecifiedPhosphoramiditeVolumeTests} = If[MatchQ[specifiedPhosphoramiditeVolume, {{Alternatives[Modification[_], LDNA[_], "Natural"], RangeP[0 Microliter, 280 Microliter]}..}],
		Module[{groupedAmidites, doublySpecifiedMonomers, tests},

			(* Group the amidites by monomer then by NumberOfCouplings *)
			groupedAmidites = GatherBy[specifiedPhosphoramiditeVolume, {First, Last}];

			(* Get any monomers that are specified multiple times with a different concentration *)
			doublySpecifiedMonomers = PickList[groupedAmidites[[All, 1]][[All, 1]][[All, 1]], Length /@ groupedAmidites, Except[1]];

			(* If there are invalid inputs and we are throwing messages, throw an error message .*)
			If[Length[doublySpecifiedMonomers] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
				Message[Error::MonomerPhosphoramiditeVolumeConflict, doublySpecifiedMonomers]
			];

			(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
			tests = If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[Length[doublySpecifiedMonomers] == 0,
						Nothing,
						Test["The monomers " <> doublySpecifiedMonomers <> " are each specified with only one value in the PhosphoramiditeVolume option:", True, False]
					];

					passingTest = If[Length[doublySpecifiedMonomers] == Length[groupedAmidites],
						Nothing,
						Test["The monomers " <> Complement[DeleteDuplicates[specifiedPhosphoramiditeVolume[[All, 1]]], doublySpecifiedMonomers] <> " are each specified with only one value in the PhosphoramiditeVolume option:", True, True]
					];

					{failingTest, passingTest}
				],
				{}
			];

			(* Return the option symbol if the option is invalid and return the tests *)
			{If[Length[doublySpecifiedMonomers] > 0, PhosphoramiditeVolume, {}], tests}
		],
		{{}, {}}
	];

	(* Get the default PhosphoramiditeVolume for this scale *)
	defaultPhosphoramiditeVolume = Which[
		Equal[resolvedScale, 40 Nanomole],
		20 Microliter,

		Equal[resolvedScale, 0.2 Micromole],
		30 Microliter,

		Equal[resolvedScale, 1 Micromole],
		75 Microliter
	];

	(* If the specified PhosphoramiditeVolume is Automatic, use the default coupling for this scale. If it is an volume, keep as is. If it is a list of monomer-volume pairs, fill in the values for any missing monomers. Keep in mind that A/T/C/G are grouped together as "Natural". *)
	resolvedPhosphoramiditeVolume = Switch[Lookup[roundedOptions, PhosphoramiditeVolume],
		Automatic,
		defaultPhosphoramiditeVolume,

		RangeP[0 Microliter, 280 Microliter],
		Lookup[roundedOptions, PhosphoramiditeVolume],

		_,
		Join[
			Lookup[roundedOptions, PhosphoramiditeVolume],
			Map[
				If[MemberQ[specifiedPhosphoramiditeVolume[[All, 1]], #],
					Nothing,
					{#, defaultPhosphoramiditeVolume}
				]&, uniqueModsAndNatural]
		]
	];


	(*- Resolve CouplingTime -*)

	(* Get the specified CouplingTime and scale them to the same value. (This way, if they specified a monomer twice pointing to the same time but in different numerical forms, we don't throw an error.) *)
	convertedSpecifiedCouplingTime = specifiedCouplingTime /. {x : TimeP :> N[Convert[x, Second]]};

	(* If any monomer is specified more than once with different CouplingTime, error *)
	{invalidOverspecifiedCouplingTimeOption, overspecifiedCouplingTimeTests} = If[MatchQ[convertedSpecifiedCouplingTime, {{Alternatives[Modification[_], LDNA[_], "Natural"], GreaterEqualP[0 Second]}..}],
		Module[{groupedAmidites, doublySpecifiedMonomers, tests},

			(* Group the amidites by monomer then by CouplingTime *)
			groupedAmidites = GatherBy[convertedSpecifiedCouplingTime, {First, Last}];

			(* Get any monomers that are specified multiple times with a different concentration *)
			doublySpecifiedMonomers = PickList[groupedAmidites[[All, 1]][[All, 1]][[All, 1]], Length /@ groupedAmidites, Except[1]];

			(* If there are invalid inputs and we are throwing messages, throw an error message .*)
			If[Length[doublySpecifiedMonomers] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
				Message[Error::MonomerCouplingTimeConflict, doublySpecifiedMonomers]
			];

			(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
			tests = If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[Length[doublySpecifiedMonomers] == 0,
						Nothing,
						Test["The monomers " <> doublySpecifiedMonomers <> " are each specified with only one value in the CouplingTime option:", True, False]
					];

					passingTest = If[Length[doublySpecifiedMonomers] == Length[groupedAmidites],
						Nothing,
						Test["The monomers " <> ToString[Complement[DeleteDuplicates[convertedSpecifiedCouplingTime[[All, 1]]], doublySpecifiedMonomers]] <> " are each specified with only one value in the CouplingTime option:", True, True]
					];

					{failingTest, passingTest}
				],
				{}
			];

			(* Return the option symbol if the option is invalid and return the tests *)
			{If[Length[doublySpecifiedMonomers] > 0, CouplingTime, {}], tests}
		],
		{{}, {}}
	];


	(* If the specified CouplingTime is Automatic, use the default coupling time. If it is a time, keep as is. If it is a list of monomer-time pairs, fill in the values for any missing monomers. Keep in mind that A/T/C/G are grouped together as "Natural". *)
	resolvedCouplingTime = Switch[specifiedCouplingTime,
		Automatic,
		defaultCouplingTime,

		GreaterEqualP[0 Second],
		specifiedCouplingTime,

		_,
		Join[
			specifiedCouplingTime,
			Map[
				If[MemberQ[specifiedCouplingTime[[All, 1]], #],
					Nothing,
					{#, defaultCouplingTime}
				]&, uniqueModsAndNatural]
		]
	];


	(* Resolve Email option *)
	resolvedEmail = If[!MatchQ[emailOption, Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* - Validate the Name option - *)

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameValidBool = TrueQ[DatabaseMemberQ[Append[If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]], nameOption]]];

	(* If the name is invalid, will add it to the list if invalid options later *)
	nameOptionInvalid = If[nameValidBool,
		Name,
		Nothing
	];

	nameUniquenessTest = If[nameValidBool,

		(* Give a failing test or throw a message if the user specified a name that is in use *)
		Switch[{gatherTests, $ECLApplication},
			{True, _}, Test["The specified name is unique.", False, True],
			{_, Except[Engine]}, (Message[Error::DuplicateName, If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]]];Nothing),
			{_, _}, Nothing
		],
		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[nameOption],
			Test["The specified name is unique.", False, True],
			Nothing
		]
	];

	(* Desalting Options for RNA *)
	If[MatchQ[myPolymer, RNA],

		speOptionsDefaults = SafeOptions[ExperimentSolidPhaseExtraction];
		(*list of fields that are not multiple*)
		speOptionsNotList = {ElutingSolution, ConditioningSolution, Instrument, PreFlushingSolution, WashingSolution};

		(* resolving post cleavage desalting options if we are doing desalting *)
		If[AnyTrue[resolvedPostCleavageDesalting, TrueQ],

			(* simulate some samples so we can use SPE resolver *)
			cleavageDesaltingCount = Count[resolvedPostCleavageDesalting, True];

			simulatedSamplesPostCleavage = SimulateSample[
				ConstantArray[Object[Sample, "id:jLq9jXYBoVl1"], cleavageDesaltingCount],
				"sample for SPE resolver cleavage",
				ConvertWell[Range[cleavageDesaltingCount], InputFormat -> Index, OutputFormat -> Position],
				Model[Container, Vessel, "id:xRO9n3vk11pw"],
				{Volume -> #}& /@ PickList[calculatedVolumePostCleavage, resolvedPostCleavageDesalting]];

			cacheBallCleavage = FlattenCachePackets[{cache, simulatedSamplesPostCleavage}];

			(*grab IDs of simulated samples*)
			cleavageDesaltingSampleIDs = Lookup[Cases[FlattenCachePackets[simulatedSamplesPostCleavage], KeyValuePattern[Type -> Object[Sample]]], Object];

			(* Making an association of all options that might go to ExperimentSolidPhaseExtraction for post cleavage desalting *)
			specifiedPostCleavageDesaltingOptions = {
				Instrument -> PickList[specifiedPostCleavageDesaltingInstruments, resolvedPostCleavageDesalting],
				PreFlushingSolution -> PickList[specifiedPostCleavageDesaltingPreFlushBuffer, resolvedPostCleavageDesalting],
				ConditioningSolution -> PickList[specifiedPostCleavageDesaltingEquilibrationBuffer, resolvedPostCleavageDesalting],
				WashingSolution -> PickList[specifiedPostCleavageDesaltingWashBuffer, resolvedPostCleavageDesalting],
				ElutingSolution -> PickList[specifiedPostCleavageDesaltingElutionBuffer, resolvedPostCleavageDesalting],
				LoadingSampleVolume -> All,
				LoadingSampleDispenseRate -> PickList[specifiedPostCleavageDesaltingSampleLoadRate, resolvedPostCleavageDesalting],
				QuantitativeLoadingSample -> PickList[specifiedPostCleavageDesaltingRinseAndReload, resolvedPostCleavageDesalting],
				QuantitativeLoadingSampleVolume -> PickList[specifiedPostCleavageDesaltingRinseAndReloadVolume, resolvedPostCleavageDesalting],
				ExtractionMode -> PickList[specifiedPostCleavageDesaltingType, resolvedPostCleavageDesalting],
				ExtractionCartridge -> PickList[specifiedPostCleavageDesaltingCartridge, resolvedPostCleavageDesalting],
				PreFlushingSolutionVolume -> PickList[specifiedPostCleavageDesaltingPreFlushVolume, resolvedPostCleavageDesalting],
				PreFlushingSolutionDispenseRate -> PickList[specifiedPostCleavageDesaltingPreFlushRate, resolvedPostCleavageDesalting],
				ConditioningSolutionVolume -> PickList[specifiedPostCleavageDesaltingEquilibrationVolume, resolvedPostCleavageDesalting],
				ConditioningSolutionDispenseRate -> PickList[specifiedPostCleavageDesaltingEquilibrationRate, resolvedPostCleavageDesalting],
				ElutingSolutionVolume -> PickList[specifiedPostCleavageDesaltingElutionVolume, resolvedPostCleavageDesalting],
				ElutingSolutionDispenseRate -> PickList[specifiedPostCleavageDesaltingElutionRate, resolvedPostCleavageDesalting],
				WashingSolutionVolume -> PickList[specifiedPostCleavageDesaltingWashVolume, resolvedPostCleavageDesalting],
				WashingSolutionDispenseRate -> PickList[specifiedPostCleavageDesaltingWashRate, resolvedPostCleavageDesalting]
			};

			(* dropping all options that are Automatic - SolidPhaseExtraction resolver would resolve those for us *)
			filteredPostCleavageDesaltingOptionsAssociation = KeyDrop[
				Association[specifiedPostCleavageDesaltingOptions],
				Keys[
					(* get association that has only keys that have Value of Automatic *)
					KeySelect[
						Association[specifiedPostCleavageDesaltingOptions],

						(* form an association with True/False as Value for Keys that are Automatic *)
						MatchQ[#, ListableP[Automatic]] & /@ Association[specifiedPostCleavageDesaltingOptions]
					]
				]
			];

			(* since not all Options for SPE can use Automatic we need to make sure that we switch all Options that can not be Automatic to their default values *)
			filteredPostCleavageDesaltingOptionsRules = KeyValueMap[Function[{optionName, optionValue},
				Module[{speDefault, checkedValue, newValue},

					(*check default option in the SPE for this option *)
					speDefault = Lookup[speOptionsDefaults, optionName];

					checkedValue = If[MatchQ[speDefault, Automatic],

						(*if default is Automatic, leave as it is*)
						optionValue,

						(*if default is Except[Automatic] grab the default*)
						(*check the values of the option and replace automatic with default*)
						Map[If[MatchQ[#, Automatic], speDefault, #]&, optionValue]
					];

					(*If we are working with one of the options that are not listable , make them a sequence out of it*)
					newValue = If[MemberQ[speOptionsNotList, optionName] && ListQ[checkedValue], Sequence @@ checkedValue, checkedValue];

					(*return new rule*)
					Rule[optionName, newValue]
				]], filteredPostCleavageDesaltingOptionsAssociation];

			(* resolving options for post cleavage desalting *)
			If[gatherTests,
				{resolvedPostCleavageDesaltingOptions, postCleavageDesaltingTests} = Quiet[ExperimentSolidPhaseExtraction[
					cleavageDesaltingSampleIDs,
					ReplaceRule[ToList[filteredPostCleavageDesaltingOptionsRules],
						{Cache -> cacheBallCleavage, Simulation -> Simulation[cacheBallCleavage], Upload -> False, Output -> {Options, Tests}}]],{Warning::TotalAliquotVolumeTooLarge, Warning::AliquotRequired}],

				{resolvedPostCleavageDesaltingOptions} = Quiet[ExperimentSolidPhaseExtraction[
					cleavageDesaltingSampleIDs,
					ReplaceRule[ToList[filteredPostCleavageDesaltingOptionsRules],
						{Cache -> cacheBallCleavage, Simulation -> Simulation[cacheBallCleavage], Upload -> False, Output -> {Options}}]],{Warning::TotalAliquotVolumeTooLarge, Warning::AliquotRequired}]
			];

			(* parse the resulting options *)
			{
				resolvedPostCleavageDesaltingInstruments, resolvedPostCleavageDesaltingPreFlushBuffer,
				resolvedPostCleavageDesaltingEquilibrationBuffer, resolvedPostCleavageDesaltingWashBuffer,
				resolvedPostCleavageDesaltingElutionBuffer, resolvedRawPostCleavageDesaltingSampleLoadRate,
				resolvedRawPostCleavageDesaltingRinseAndReload, resolvedRawPostCleavageDesaltingRinseAndReloadVolume,
				resolvedRawPostCleavageDesaltingType, resolvedRawPostCleavageDesaltingCartridge,
				resolvedRawPostCleavageDesaltingPreFlushVolume, resolvedRawPostCleavageDesaltingPreFlushRate,
				resolvedRawPostCleavageDesaltingEquilibrationVolume, resolvedRawPostCleavageDesaltingEquilibrationRate,
				resolvedRawPostCleavageDesaltingElutionVolume, resolvedRawPostCleavageDesaltingElutionRate,
				resolvedRawPostCleavageDesaltingWashVolume, resolvedRawPostCleavageDesaltingWashRate
			} = Lookup[resolvedPostCleavageDesaltingOptions, {
				Instrument, PreFlushingSolution, ConditioningSolution, WashingSolution, ElutingSolution, LoadingSampleDispenseRate, QuantitativeLoadingSample,
				QuantitativeLoadingSampleVolume, ExtractionMode, ExtractionCartridge, PreFlushingSolutionVolume, PreFlushingSolutionDispenseRate, ConditioningSolutionVolume, ConditioningSolutionDispenseRate,
				ElutingSolutionVolume, ElutingSolutionDispenseRate, WashingSolutionVolume, WashingSolutionDispenseRate
			}];

			(* if we are desalting not all of the bases, make sure that we return a list that is matching *)
			(* the length of the inputs for the index-matching options *)
			{
				resolvedPostCleavageDesaltingSampleLoadRate, resolvedPostCleavageDesaltingRinseAndReload,
				resolvedPostCleavageDesaltingRinseAndReloadVolume, resolvedPostCleavageDesaltingType,
				resolvedPostCleavageDesaltingCartridge, resolvedPostCleavageDesaltingPreFlushVolume,
				resolvedPostCleavageDesaltingPreFlushRate, resolvedPostCleavageDesaltingEquilibrationVolume,
				resolvedPostCleavageDesaltingEquilibrationRate, resolvedPostCleavageDesaltingElutionVolume,
				resolvedPostCleavageDesaltingElutionRate, resolvedPostCleavageDesaltingWashVolume,
				resolvedPostCleavageDesaltingWashRate
			} = If[MemberQ[resolvedPostCleavageDesalting, False],
				Module[{truePositions, falsePositions},

					truePositions = Flatten[Position[resolvedPostCleavageDesalting, True]];
					falsePositions = Complement[Range[Length[resolvedPostCleavageDesalting]], truePositions];

					Map[Function[{optionValue},
						Module[{expandedValue, truePairs, falsePairs, answer},

							(*Expand the option to match the number of samples we are desalting if it is not expanded*)
							expandedValue = If[
								MatchQ[Length[ToList[optionValue]], 1],
								ConstantArray[optionValue, Length[truePositions]],
								optionValue];

							(*form pairs {position in the samples list, optionValue}*)
							truePairs = MapThread[{#1, #2}&, {truePositions, expandedValue}];
							falsePairs = MapThread[{#1, #2}&, {falsePositions, ConstantArray[Null, Length[falsePositions]]}];

							(*get sorted option result with Null for samples that are not being desalted*)
							answer = Flatten[SortBy[Join[truePairs, falsePairs], First][[All, 2]]]
						]],
						{
							resolvedRawPostCleavageDesaltingSampleLoadRate, resolvedRawPostCleavageDesaltingRinseAndReload,
							resolvedRawPostCleavageDesaltingRinseAndReloadVolume, resolvedRawPostCleavageDesaltingType,
							resolvedRawPostCleavageDesaltingCartridge, resolvedRawPostCleavageDesaltingPreFlushVolume,
							resolvedRawPostCleavageDesaltingPreFlushRate, resolvedRawPostCleavageDesaltingEquilibrationVolume,
							resolvedRawPostCleavageDesaltingEquilibrationRate, resolvedRawPostCleavageDesaltingElutionVolume,
							resolvedRawPostCleavageDesaltingElutionRate, resolvedRawPostCleavageDesaltingWashVolume,
							resolvedRawPostCleavageDesaltingWashRate
						}]
				],

				(*if all samples are going though desalting, return options without nested lists*)
				Map[If[ListQ[#],Flatten[#],#]&,{
					resolvedRawPostCleavageDesaltingSampleLoadRate, resolvedRawPostCleavageDesaltingRinseAndReload,
					resolvedRawPostCleavageDesaltingRinseAndReloadVolume, resolvedRawPostCleavageDesaltingType,
					resolvedRawPostCleavageDesaltingCartridge, resolvedRawPostCleavageDesaltingPreFlushVolume,
					resolvedRawPostCleavageDesaltingPreFlushRate, resolvedRawPostCleavageDesaltingEquilibrationVolume,
					resolvedRawPostCleavageDesaltingEquilibrationRate, resolvedRawPostCleavageDesaltingElutionVolume,
					resolvedRawPostCleavageDesaltingElutionRate, resolvedRawPostCleavageDesaltingWashVolume,
					resolvedRawPostCleavageDesaltingWashRate
				}]
			];

			(*make a list of Rules for the output for the options*)
			resolvedPostCleavageDesaltingRules = {
				PostCleavageDesaltingInstrument -> resolvedPostCleavageDesaltingInstruments,
				PostCleavageDesaltingPreFlushBuffer -> resolvedPostCleavageDesaltingPreFlushBuffer,
				PostCleavageDesaltingEquilibrationBuffer -> resolvedPostCleavageDesaltingEquilibrationBuffer,
				PostCleavageDesaltingWashBuffer -> resolvedPostCleavageDesaltingWashBuffer,
				PostCleavageDesaltingElutionBuffer -> resolvedPostCleavageDesaltingElutionBuffer,
				PostCleavageDesaltingSampleLoadRate -> resolvedPostCleavageDesaltingSampleLoadRate,
				PostCleavageDesaltingRinseAndReload -> resolvedPostCleavageDesaltingRinseAndReload,
				PostCleavageDesaltingRinseAndReloadVolume -> resolvedPostCleavageDesaltingRinseAndReloadVolume,
				PostCleavageDesaltingType -> resolvedPostCleavageDesaltingType,
				PostCleavageDesaltingCartridge -> resolvedPostCleavageDesaltingCartridge,
				PostCleavageDesaltingPreFlushVolume -> resolvedPostCleavageDesaltingPreFlushVolume,
				PostCleavageDesaltingPreFlushRate -> resolvedPostCleavageDesaltingPreFlushRate,
				PostCleavageDesaltingEquilibrationVolume -> resolvedPostCleavageDesaltingEquilibrationVolume,
				PostCleavageDesaltingEquilibrationRate -> resolvedPostCleavageDesaltingEquilibrationRate,
				PostCleavageDesaltingElutionVolume -> resolvedPostCleavageDesaltingElutionVolume,
				PostCleavageDesaltingElutionRate -> resolvedPostCleavageDesaltingElutionRate,
				PostCleavageDesaltingWashVolume -> resolvedPostCleavageDesaltingWashVolume,
				PostCleavageDesaltingWashRate -> resolvedPostCleavageDesaltingWashRate
			},

			(* if we are not resolving options for Desalting, remove an empty list of rules *)
			resolvedPostCleavageDesaltingRules = {
				PostCleavageDesaltingInstrument -> Null,
				PostCleavageDesaltingPreFlushBuffer -> Null,
				PostCleavageDesaltingEquilibrationBuffer -> Null,
				PostCleavageDesaltingWashBuffer -> Null,
				PostCleavageDesaltingElutionBuffer -> Null,
				PostCleavageDesaltingSampleLoadRate -> Null,
				PostCleavageDesaltingRinseAndReload -> Null,
				PostCleavageDesaltingRinseAndReloadVolume -> Null,
				PostCleavageDesaltingType -> Null,
				PostCleavageDesaltingCartridge -> Null,
				PostCleavageDesaltingPreFlushVolume -> Null,
				PostCleavageDesaltingPreFlushRate -> Null,
				PostCleavageDesaltingEquilibrationVolume -> Null,
				PostCleavageDesaltingEquilibrationRate -> Null,
				PostCleavageDesaltingElutionVolume -> Null,
				PostCleavageDesaltingElutionRate -> Null,
				PostCleavageDesaltingWashVolume -> Null,
				PostCleavageDesaltingWashRate -> Null
			};
		];

		(* resolving post RNA Deprotection desalting options if we are doing desalting *)
		If[AnyTrue[resolvedPostRNADeprotectionDesalting, TrueQ],

			(* Making an association of all options that might go to ExperimentSolidPhaseExtraction for post rnaDeprotection desalting *)
			specifiedPostRNADeprotectionDesaltingOptions = {
				Instrument -> PickList[specifiedPostRNADeprotectionDesaltingInstruments, resolvedPostRNADeprotectionDesalting],
				PreFlushingSolution -> PickList[specifiedPostRNADeprotectionDesaltingPreFlushBuffer, resolvedPostRNADeprotectionDesalting],
				ConditioningSolution -> PickList[specifiedPostRNADeprotectionDesaltingEquilibrationBuffer, resolvedPostRNADeprotectionDesalting],
				WashingSolution -> PickList[specifiedPostRNADeprotectionDesaltingWashBuffer, resolvedPostRNADeprotectionDesalting],
				ElutingSolution -> PickList[specifiedPostRNADeprotectionDesaltingElutionBuffer, resolvedPostRNADeprotectionDesalting],
				LoadingSampleVolume -> All,
				LoadingSampleDispenseRate -> PickList[specifiedPostRNADeprotectionDesaltingSampleLoadRate, resolvedPostRNADeprotectionDesalting],
				QuantitativeLoadingSample -> PickList[specifiedPostRNADeprotectionDesaltingRinseAndReload, resolvedPostRNADeprotectionDesalting],
				QuantitativeLoadingSampleVolume -> PickList[specifiedPostRNADeprotectionDesaltingRinseAndReloadVolume, resolvedPostRNADeprotectionDesalting],
				ExtractionMode -> PickList[specifiedPostRNADeprotectionDesaltingType, resolvedPostRNADeprotectionDesalting],
				ExtractionCartridge -> PickList[specifiedPostRNADeprotectionDesaltingCartridge, resolvedPostRNADeprotectionDesalting],
				PreFlushingSolutionVolume -> PickList[specifiedPostRNADeprotectionDesaltingPreFlushVolume, resolvedPostRNADeprotectionDesalting],
				PreFlushingSolutionDispenseRate -> PickList[specifiedPostRNADeprotectionDesaltingPreFlushRate, resolvedPostRNADeprotectionDesalting],
				ConditioningSolutionVolume -> PickList[specifiedPostRNADeprotectionDesaltingEquilibrationVolume, resolvedPostRNADeprotectionDesalting],
				ConditioningSolutionDispenseRate -> PickList[specifiedPostRNADeprotectionDesaltingEquilibrationRate, resolvedPostRNADeprotectionDesalting],
				ElutingSolutionVolume -> PickList[specifiedPostRNADeprotectionDesaltingElutionVolume, resolvedPostRNADeprotectionDesalting],
				ElutingSolutionDispenseRate -> PickList[specifiedPostRNADeprotectionDesaltingElutionRate, resolvedPostRNADeprotectionDesalting],
				WashingSolutionVolume -> PickList[specifiedPostRNADeprotectionDesaltingWashVolume, resolvedPostRNADeprotectionDesalting],
				WashingSolutionDispenseRate -> PickList[specifiedPostRNADeprotectionDesaltingWashRate, resolvedPostRNADeprotectionDesalting]
			};

			(* dropping all options that are Automatic - SolidPhaseExtraction resolver would resolve those for us *)
			filteredPostRNADeprotectionDesaltingOptionsAssociation = KeyDrop[
				Association[specifiedPostRNADeprotectionDesaltingOptions],
				Keys[
					(* get association that has only keys that have Value of Automatic *)
					KeySelect[
						Association[specifiedPostRNADeprotectionDesaltingOptions],

						(* form an association with True/False as Value for Keys that are Automatic *)
						MatchQ[#, ListableP[Automatic]] & /@ Association[specifiedPostRNADeprotectionDesaltingOptions]
					]
				]
			];

			(* since not all Options for SPE can use Automatic we need to make sure that we switch all Options that can not be Automatic to their default values *)
			filteredPostRNADeprotectionDesaltingOptionsRules = KeyValueMap[Function[{optionName, optionValue},
				Module[{speDefault, checkedValue, newValue},

					(*check default option in the SPE for this option; have to make it string since Options returns strings and not Symbols*)
					speDefault = Lookup[speOptionsDefaults, ToString[optionName]];

					checkedValue = If[MatchQ[speDefault, Automatic],

						(*if default is Automatic, leave as it is*)
						optionValue,

						(*if default is Except[Automatic] grab the default*)
						(*check the values of the option and replace automatic with default*)
						Map[If[MatchQ[#, Automatic], speDefault, #]&, optionValue]
					];

					(*If we are working with one of the options that are not listable , make them a sequence out of it*)
					newValue = If[MemberQ[speOptionsNotList, optionName] && ListQ[checkedValue], Sequence @@ checkedValue, checkedValue];

					(*return new rule*)
					Rule[optionName, newValue]
				]], filteredPostRNADeprotectionDesaltingOptionsAssociation];


			(* shortcut to avoid using SPE resolver again if we have the same parameters *)
			If[
				MatchQ[filteredPostRNADeprotectionDesaltingOptionsRules, filteredPostCleavageDesaltingOptionsRules],
				(* copy results of the Cleavage Desalting resolver *)
				If[gatherTests,
					{
						resolvedPostRNADeprotectionDesaltingOptions,
						postRNADeprotectionDesaltingTests
					} = {
						resolvedPostCleavageDesaltingOptions,
						postCleavageDesaltingTests
					},
					resolvedPostRNADeprotectionDesaltingOptions = resolvedPostCleavageDesaltingOptions
				],

				(* make a separate call for Deprotection Desalting *)
				(* simulate some samples so we can use SPE resolver *)
				rnaDeprotectionDesaltingCount = Count[resolvedPostRNADeprotectionDesalting, True];

				simulatedSamplesPostRNADeprotection = SimulateSample[
					ConstantArray[Object[Sample, "id:jLq9jXYBoVl1"], rnaDeprotectionDesaltingCount],
					"sample for SPE resolver rnaDeprotection",
					ConvertWell[Range[rnaDeprotectionDesaltingCount], InputFormat -> Index, OutputFormat -> Position],
					Model[Container, Vessel, "id:xRO9n3vk11pw"],
					{Volume -> #}& /@ PickList[calculatedVolumePostRNADeprotection, resolvedPostRNADeprotectionDesalting]];

				cacheBallRNADeprotection = FlattenCachePackets[{cache, simulatedSamplesPostRNADeprotection}];

				(*grab IDs of simulated samples*)
				rnaDeprotectionDesaltingSampleIDs = Lookup[Cases[FlattenCachePackets[simulatedSamplesPostRNADeprotection], KeyValuePattern[Type -> Object[Sample]]], Object];

				(* resolving options for post rnaDeprotection desalting *)
				If[gatherTests,
					{resolvedPostRNADeprotectionDesaltingOptions, postRNADeprotectionDesaltingTests} = Quiet[ExperimentSolidPhaseExtraction[
						rnaDeprotectionDesaltingSampleIDs,
						ReplaceRule[ToList[filteredPostRNADeprotectionDesaltingOptionsRules],
							{Cache -> cacheBallRNADeprotection, Simulation -> Simulation[cacheBallRNADeprotection], Upload -> False, Output -> {Options, Tests}}]],{Warning::TotalAliquotVolumeTooLarge, Warning::AliquotRequired}],

					{resolvedPostRNADeprotectionDesaltingOptions} = Quiet[ExperimentSolidPhaseExtraction[
						rnaDeprotectionDesaltingSampleIDs,
						ReplaceRule[ToList[filteredPostRNADeprotectionDesaltingOptionsRules],
							{Cache -> cacheBallRNADeprotection, Simulation -> Simulation[cacheBallRNADeprotection], Upload -> False, Output -> {Options}}]],{Warning::TotalAliquotVolumeTooLarge, Warning::AliquotRequired}];
				];
			];

			(* parse the resulting options *)
			{
				resolvedPostRNADeprotectionDesaltingInstruments, resolvedPostRNADeprotectionDesaltingPreFlushBuffer,
				resolvedPostRNADeprotectionDesaltingEquilibrationBuffer, resolvedPostRNADeprotectionDesaltingWashBuffer,
				resolvedPostRNADeprotectionDesaltingElutionBuffer, resolvedRawPostRNADeprotectionDesaltingSampleLoadRate,
				resolvedRawPostRNADeprotectionDesaltingRinseAndReload, resolvedRawPostRNADeprotectionDesaltingRinseAndReloadVolume,
				resolvedRawPostRNADeprotectionDesaltingType, resolvedRawPostRNADeprotectionDesaltingCartridge,
				resolvedRawPostRNADeprotectionDesaltingPreFlushVolume, resolvedRawPostRNADeprotectionDesaltingPreFlushRate,
				resolvedRawPostRNADeprotectionDesaltingEquilibrationVolume, resolvedRawPostRNADeprotectionDesaltingEquilibrationRate,
				resolvedRawPostRNADeprotectionDesaltingElutionVolume, resolvedRawPostRNADeprotectionDesaltingElutionRate,
				resolvedRawPostRNADeprotectionDesaltingWashVolume, resolvedRawPostRNADeprotectionDesaltingWashRate
			} = Lookup[resolvedPostRNADeprotectionDesaltingOptions, {
				Instrument, PreFlushingSolution, ConditioningSolution, WashingSolution, ElutingSolution, LoadingSampleDispenseRate, QuantitativeLoadingSample,
				QuantitativeLoadingSampleVolume, ExtractionMode, ExtractionCartridge, PreFlushingSolutionVolume, PreFlushingSolutionDispenseRate, ConditioningSolutionVolume, ConditioningSolutionDispenseRate,
				ElutingSolutionVolume, ElutingSolutionDispenseRate, WashingSolutionVolume, WashingSolutionDispenseRate
			}];

			(* if we are desalting not all of the bases, make sure that we return a list that is matching *)
			(* the length of the inputs for the index-matching options *)
			{
				resolvedPostRNADeprotectionDesaltingSampleLoadRate, resolvedPostRNADeprotectionDesaltingRinseAndReload,
				resolvedPostRNADeprotectionDesaltingRinseAndReloadVolume, resolvedPostRNADeprotectionDesaltingType,
				resolvedPostRNADeprotectionDesaltingCartridge, resolvedPostRNADeprotectionDesaltingPreFlushVolume,
				resolvedPostRNADeprotectionDesaltingPreFlushRate, resolvedPostRNADeprotectionDesaltingEquilibrationVolume,
				resolvedPostRNADeprotectionDesaltingEquilibrationRate, resolvedPostRNADeprotectionDesaltingElutionVolume,
				resolvedPostRNADeprotectionDesaltingElutionRate, resolvedPostRNADeprotectionDesaltingWashVolume,
				resolvedPostRNADeprotectionDesaltingWashRate
			} = If[MemberQ[resolvedPostRNADeprotectionDesalting, False],
				Module[{truePositions, falsePositions},

					truePositions = Flatten[Position[resolvedPostRNADeprotectionDesalting, True]];
					falsePositions = Complement[Range[Length[resolvedPostRNADeprotectionDesalting]], truePositions];

					Map[Function[{optionValue},
						Module[{expandedValue, truePairs, falsePairs, answer},

							(*Expand the option to match the number of samples we are desalting if it is not expanded*)
							expandedValue = If[
								MatchQ[Length[ToList[optionValue]], 1],
								ConstantArray[optionValue, Length[truePositions]],
								optionValue];

							(*form pairs {position in the samples list, optionValue}*)
							truePairs = MapThread[{#1, #2}&, {truePositions, expandedValue}];
							falsePairs = MapThread[{#1, #2}&, {falsePositions, ConstantArray[Null, Length[falsePositions]]}];

							(*get sorted option result with Null for samples that are not being desalted*)
							answer = Flatten[SortBy[Join[truePairs, falsePairs], First][[All, 2]]]
						]],
						{
							resolvedRawPostRNADeprotectionDesaltingSampleLoadRate, resolvedRawPostRNADeprotectionDesaltingRinseAndReload,
							resolvedRawPostRNADeprotectionDesaltingRinseAndReloadVolume, resolvedRawPostRNADeprotectionDesaltingType,
							resolvedRawPostRNADeprotectionDesaltingCartridge, resolvedRawPostRNADeprotectionDesaltingPreFlushVolume,
							resolvedRawPostRNADeprotectionDesaltingPreFlushRate, resolvedRawPostRNADeprotectionDesaltingEquilibrationVolume,
							resolvedRawPostRNADeprotectionDesaltingEquilibrationRate, resolvedRawPostRNADeprotectionDesaltingElutionVolume,
							resolvedRawPostRNADeprotectionDesaltingElutionRate, resolvedRawPostRNADeprotectionDesaltingWashVolume,
							resolvedRawPostRNADeprotectionDesaltingWashRate
						}]
				],

				(*if all samples are going though desalting, return options as they are*)
				Map[If[ListQ[#],Flatten[#],#]&,{
					resolvedRawPostRNADeprotectionDesaltingSampleLoadRate, resolvedRawPostRNADeprotectionDesaltingRinseAndReload,
					resolvedRawPostRNADeprotectionDesaltingRinseAndReloadVolume, resolvedRawPostRNADeprotectionDesaltingType,
					resolvedRawPostRNADeprotectionDesaltingCartridge, resolvedRawPostRNADeprotectionDesaltingPreFlushVolume,
					resolvedRawPostRNADeprotectionDesaltingPreFlushRate, resolvedRawPostRNADeprotectionDesaltingEquilibrationVolume,
					resolvedRawPostRNADeprotectionDesaltingEquilibrationRate, resolvedRawPostRNADeprotectionDesaltingElutionVolume,
					resolvedRawPostRNADeprotectionDesaltingElutionRate, resolvedRawPostRNADeprotectionDesaltingWashVolume,
					resolvedRawPostRNADeprotectionDesaltingWashRate
				}]
			];

			(*make a list of Rules for the output for the options*)
			resolvedPostRNADeprotectionDesaltingRules = {
				PostRNADeprotectionDesaltingInstrument -> resolvedPostRNADeprotectionDesaltingInstruments,
				PostRNADeprotectionDesaltingPreFlushBuffer -> resolvedPostRNADeprotectionDesaltingPreFlushBuffer,
				PostRNADeprotectionDesaltingEquilibrationBuffer -> resolvedPostRNADeprotectionDesaltingEquilibrationBuffer,
				PostRNADeprotectionDesaltingWashBuffer -> resolvedPostRNADeprotectionDesaltingWashBuffer,
				PostRNADeprotectionDesaltingElutionBuffer -> resolvedPostRNADeprotectionDesaltingElutionBuffer,
				PostRNADeprotectionDesaltingSampleLoadRate -> resolvedPostRNADeprotectionDesaltingSampleLoadRate,
				PostRNADeprotectionDesaltingRinseAndReload -> resolvedPostRNADeprotectionDesaltingRinseAndReload,
				PostRNADeprotectionDesaltingRinseAndReloadVolume -> resolvedPostRNADeprotectionDesaltingRinseAndReloadVolume,
				PostRNADeprotectionDesaltingType -> resolvedPostRNADeprotectionDesaltingType,
				PostRNADeprotectionDesaltingCartridge -> resolvedPostRNADeprotectionDesaltingCartridge,
				PostRNADeprotectionDesaltingPreFlushVolume -> resolvedPostRNADeprotectionDesaltingPreFlushVolume,
				PostRNADeprotectionDesaltingPreFlushRate -> resolvedPostRNADeprotectionDesaltingPreFlushRate,
				PostRNADeprotectionDesaltingEquilibrationVolume -> resolvedPostRNADeprotectionDesaltingEquilibrationVolume,
				PostRNADeprotectionDesaltingEquilibrationRate -> resolvedPostRNADeprotectionDesaltingEquilibrationRate,
				PostRNADeprotectionDesaltingElutionVolume -> resolvedPostRNADeprotectionDesaltingElutionVolume,
				PostRNADeprotectionDesaltingElutionRate -> resolvedPostRNADeprotectionDesaltingElutionRate,
				PostRNADeprotectionDesaltingWashVolume -> resolvedPostRNADeprotectionDesaltingWashVolume,
				PostRNADeprotectionDesaltingWashRate -> resolvedPostRNADeprotectionDesaltingWashRate
			},

			(* if we are not resolving options for Desalting, remove an empty list of rules *)
			resolvedPostRNADeprotectionDesaltingRules = {
				PostRNADeprotectionDesaltingInstrument -> Null,
				PostRNADeprotectionDesaltingPreFlushBuffer -> Null,
				PostRNADeprotectionDesaltingEquilibrationBuffer -> Null,
				PostRNADeprotectionDesaltingWashBuffer -> Null,
				PostRNADeprotectionDesaltingElutionBuffer -> Null,
				PostRNADeprotectionDesaltingSampleLoadRate -> Null,
				PostRNADeprotectionDesaltingRinseAndReload -> Null,
				PostRNADeprotectionDesaltingRinseAndReloadVolume -> Null,
				PostRNADeprotectionDesaltingType -> Null,
				PostRNADeprotectionDesaltingCartridge -> Null,
				PostRNADeprotectionDesaltingPreFlushVolume -> Null,
				PostRNADeprotectionDesaltingPreFlushRate -> Null,
				PostRNADeprotectionDesaltingEquilibrationVolume -> Null,
				PostRNADeprotectionDesaltingEquilibrationRate -> Null,
				PostRNADeprotectionDesaltingElutionVolume -> Null,
				PostRNADeprotectionDesaltingElutionRate -> Null,
				PostRNADeprotectionDesaltingWashVolume -> Null,
				PostRNADeprotectionDesaltingWashRate -> Null
			};
		];
	];

	(* == Resolve on-deck reagents == *)
	(* many of our reagents depend on the number of banks used, so need to check this *)
	banksUsed = If[numberOfStrands>24,
		2,
		1
	];

	(* when resolving for on-deck reagents, a single specified model will be propagated to the correct number of banks,
	if any objects are specified we will check that the number of items matches the number of banks. if not, raise error *)

	(* Activator solution *)
	defaultActivatorSolution = Model[Sample, "id:E8zoYveRlKq5"]; (*Model[Sample, "Activator"]*)

	specifiedActivatorSolution = Lookup[myOptions, ActivatorSolution];

	resolvedActivatorSolution = Switch[specifiedActivatorSolution,
		(* if we are Automatic, use the default solution *)
		Automatic,
		ConstantArray[defaultActivatorSolution,banksUsed],

		(* user specified a single model, propegate to however many banks we need *)
		ObjectReferenceP[Model[Sample]],
		ConstantArray[specifiedActivatorSolution,banksUsed],

		(* user specified a single object, just make sure it is in a list *)
		ObjectReferenceP[Object[Sample]],
		ToList[specifiedActivatorSolution],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedActivatorSolution /. Automatic:>defaultActivatorSolution,

		(* if we somehow had some other value, use default *)
		True,
		ToList[defaultActivatorSolution]
	];

	(* resolve storage conditions *)
	specifiedActivatorSolutionStorageCondition = Lookup[myOptions, ActivatorSolutionStorageCondition];

	resolvedActivatorSolutionStorageCondition = Switch[specifiedActivatorSolutionStorageCondition,
		(* user specified a single setting, propegate to however many banks we need *)
		SampleStorageTypeP|Disposal|Null,
		ConstantArray[specifiedActivatorSolutionStorageCondition,banksUsed],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedActivatorSolution,

		(* if we somehow had some other value, use Null *)
		True,
		Null
	];
	
	(* Cap A solution *)
	specifiedCapASolution = Lookup[myOptions, CapASolution];

	resolvedCapASolution = Switch[specifiedCapASolution,
		(* if we are Automatic, use the default solution *)
		Automatic,
		ConstantArray[defaultCapASolution,banksUsed],

		(* user specified a single model, propegate to however many banks we need *)
		ObjectReferenceP[Model[Sample]],
		ConstantArray[specifiedCapASolution,banksUsed],

		(* user specified a single object, just make sure it is in a list *)
		ObjectReferenceP[Object[Sample]],
		ToList[specifiedCapASolution],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedCapASolution /. Automatic:>defaultCapASolution,

		(* if we somehow had some other value, use default *)
		True,
		ToList[defaultCapASolution]
	];

	(* resolve storage conditions *)
	specifiedCapASolutionStorageCondition = Lookup[myOptions, CapASolutionStorageCondition];

	resolvedCapASolutionStorageCondition = Switch[specifiedCapASolutionStorageCondition,
		(* user specified a single setting, propegate to however many banks we need *)
		SampleStorageTypeP|Disposal|Null,
		ConstantArray[specifiedCapASolutionStorageCondition,banksUsed],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedCapASolution,

		(* if we somehow had some other value, use Null *)
		True,
		Null
	];
	
	(* Cap B solution *)
	defaultCapBSolution = Model[Sample, "id:P5ZnEj4P8qKE"]; (*Model[Sample, "Capping solution B"]*)

	specifiedCapBSolution = Lookup[myOptions, CapBSolution];

	resolvedCapBSolution = Switch[specifiedCapBSolution,
		(* if we are Automatic, use the default solution *)
		Automatic,
		ConstantArray[defaultCapBSolution,banksUsed],

		(* user specified a single model, propegate to however many banks we need *)
		ObjectReferenceP[Model[Sample]],
		ConstantArray[specifiedCapBSolution,banksUsed],

		(* user specified a single object, just make sure it is in a list *)
		ObjectReferenceP[Object[Sample]],
		ToList[specifiedCapBSolution],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedCapBSolution /. Automatic:>defaultCapBSolution,

		(* if we somehow had some other value, use default *)
		True,
		ToList[defaultCapBSolution]
	];

	(* resolve storage conditions *)
	specifiedCapBSolutionStorageCondition = Lookup[myOptions, CapBSolutionStorageCondition];

	resolvedCapBSolutionStorageCondition = Switch[specifiedCapBSolutionStorageCondition,
		(* user specified a single setting, propegate to however many banks we need *)
		SampleStorageTypeP|Disposal|Null,
		ConstantArray[specifiedCapBSolutionStorageCondition,banksUsed],

		(* if User specified a list, use it but replace any Automatics with default*)
		_List,
		specifiedCapBSolution,

		(* if we somehow had some other value, use Null *)
		True,
		Null
	];
	
	(* If any on-deck reagent is specified in a length that does not agree with the number of banks used in the experiment, throw Error::MismatchDeckReagentBanks and Error::InvalidOption *)
	{invalidOnDeckReagentsOption, invalidOnDeckReagentsTests} =	Module[{OnDeckCompatibleLength, options, tests},

			(* check if the length of resolved activator agrees with the number of banks used *)
			OnDeckCompatibleLength = {
					Length[resolvedActivatorSolution]!=banksUsed,
					Length[resolvedCapASolution]!=banksUsed,
					Length[resolvedCapBSolution]!=banksUsed
			};

			options = PickList[{ActivatorSolution,CapASolution,CapBSolution}, OnDeckCompatibleLength];

			(* If there are invalid inputs and we are throwing messages, throw an error message .*)
			If[Length[options] > 0 && !gatherTests && MatchQ[$ECLApplication, Except[Engine]],
				Message[Error::MismatchDeckReagentBanks, options, banksUsed]
			];

			(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
			tests = If[gatherTests,
				Module[{failingTest, passingTest},
					failingTest = If[Length[options] == 0,
						Nothing,
						Test["All On-deck reagents (CapASolution, CapBSolution, and Activator) are each compatible with the number of banks that will be used in the synthesis:", True, False]
					];

					passingTest = If[Length[doublySpecifiedMonomers] == Length[groupedAmidites],
						Nothing,
						Test["All On-deck reagents (CapASolution, CapBSolution, and Activator) are each compatible with the number of banks that will be used in the synthesis:", True, True]
					];

					{failingTest, passingTest}
				],
				{}
			];

			(* Return invalid options and tests *)
			{options, tests}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	(* Since the unknownMonomerInputs InvalidInput error prevents the user from inputting phosphoramidites for unknown monomers in CommandBuilder (CB blocks from entering the option resolution), don't throw this error unless we are returning the Result *)
	invalidInputs = DeleteDuplicates[Flatten[{polymerInvalidInputs, strandsInvalidInputs, tooManyModsInvalidInputs, tooManyStrandsInvalidInputs, If[MemberQ[ToList[Lookup[myOptions, Output]], Result], unknownMonomerInputs, Nothing]}]];
	invalidOptions = Switch[myPolymer,
		DNA,
		DeleteDuplicates[Flatten[{invalidOverspecifiedPhosphoramiditesOption, invalidOverspecifiedNumberOfCouplingsOption, invalidOverspecifiedPhosphoramiditeVolumeOption,
			invalidOverspecifiedCouplingTimeOption, nameOptionInvalid, cleavageOptionsInvalid, invalidColumnsOption, missingColumnLoadingOptions, columnRepeatInvalid, invalidOnDeckReagentsOption}]],
		RNA,
		DeleteDuplicates[Flatten[{invalidOverspecifiedPhosphoramiditesOption, invalidOverspecifiedNumberOfCouplingsOption, invalidOverspecifiedPhosphoramiditeVolumeOption,
			invalidOverspecifiedCouplingTimeOption, nameOptionInvalid, cleavageOptionsInvalid, invalidColumnsOption, missingColumnLoadingOptions, columnRepeatInvalid, deprotectionOptionsInvalid, desaltingOptionsInvalid, invalidOnDeckReagentsOption}]]
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0 && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0 && MatchQ[$ECLApplication, Except[Engine]],
		Message[Error::InvalidOption, invalidOptions]
	];


	(* Return our resolved options and/or tests. *)
	Switch[myPolymer,
		DNA,

		(* DNA options and tests *)
		outputSpecification /. {
			Result -> ReplaceRule[Normal[roundedOptions],
				Join[{
					Scale -> resolvedScale,
					InitialWashVolume -> resolvedInitialWashVolume,
					NumberOfDeprotections -> resolvedNumberOfDeprotections,
					DeprotectionVolume -> resolvedDeprotectionVolume,
					DeprotectionWashVolume -> resolvedDeprotectionWashVolume,
					ActivatorSolution -> resolvedActivatorSolution,
					ActivatorVolume -> resolvedActivatorVolume,
					ActivatorSolutionStorageCondition -> resolvedActivatorSolutionStorageCondition,
					CapASolution -> resolvedCapASolution,
					CapAVolume -> resolvedCapAVolume,
					CapASolutionStorageCondition -> resolvedCapASolutionStorageCondition,
					CapBSolution -> resolvedCapBSolution,
					CapBVolume -> resolvedCapBVolume,
					CapBSolutionStorageCondition -> resolvedCapBSolutionStorageCondition,
					OxidationVolume -> resolvedOxidationVolume,
					OxidationWashVolume -> resolvedOxidationWashVolume,
					SecondaryOxidationSolution -> resolvedSecondaryOxidationSolution,
					SecondaryOxidationVolume -> resolvedSecondaryOxidationVolume,
					SecondaryOxidationWashVolume -> resolvedSecondaryOxidationWashVolume,
					FinalWashVolume -> resolvedFinalWashVolume,
					Phosphoramidites -> resolvedAmidites,
					NumberOfCouplings -> resolvedNumberOfCouplings,
					PhosphoramiditeVolume -> resolvedPhosphoramiditeVolume,
					CouplingTime -> resolvedCouplingTime,
					Cleavage -> resolvedCleavages,
					CleavageTime -> resolvedCleavageTimes,
					CleavageTemperature -> resolvedCleavageTemperatures,
					CleavageSolution -> resolvedCleavageSolutions,
					CleavageWashSolution -> resolvedCleavageWashSolutions,
					CleavageSolutionVolume -> resolvedCleavageSolutionVolumes,
					CleavageWashVolume -> resolvedCleavageWashVolumes,
					StorageSolvent -> resolvedStorageSolvents,
					StorageSolventVolume -> resolvedStorageSolventVolume,
					Email -> resolvedEmail
				},
					resolvedPostProcessingOptions
				]
			],
			Tests -> Flatten[{invalidPolymerTest, invalidStrandsTests, tooManyModificationsTests, tooManyStrandsTest, precisionTests,
				overspecifiedPhosphoramiditesTests, unknownMonomerTests,
				overspecifiedNumberOfCouplingsTests, overspecifiedPhosphoramiditeVolumeTests,
				overspecifiedCouplingTimeTests, nameUniquenessTest, columnScaleMismatchTest, cleavageOptionSetConflictTests,
				cleavageTrueConflictTests, cleavageFalseConflictTests, cleavageTrueNullConflictTests, cleavageFalseNullConflictTests,
				conflictingColumnLoadingTest, resinMatchingTests, repeatColumnTest, missingColumnLoadingTest,invalidOnDeckReagentsTests}]
		},
		RNA,

		(* RNA options and tests *)
		outputSpecification /. {
			Result -> ReplaceRule[Normal[roundedOptions],
				DeleteCases[Flatten[{{
					Scale -> resolvedScale,
					InitialWashVolume -> resolvedInitialWashVolume,
					NumberOfDeprotections -> resolvedNumberOfDeprotections,
					DeprotectionVolume -> resolvedDeprotectionVolume,
					DeprotectionWashVolume -> resolvedDeprotectionWashVolume,
					ActivatorSolution -> resolvedActivatorSolution,
					ActivatorSolutionStorageCondition -> resolvedActivatorSolutionStorageCondition,
					ActivatorVolume -> resolvedActivatorVolume,
					CapASolution -> resolvedCapASolution,
					CapASolutionStorageCondition -> resolvedCapASolutionStorageCondition,
					CapAVolume -> resolvedCapAVolume,
					CapBSolution -> resolvedCapBSolution,
					CapBSolutionStorageCondition -> resolvedCapBSolutionStorageCondition,
					CapBVolume -> resolvedCapBVolume,
					OxidationVolume -> resolvedOxidationVolume,
					OxidationWashVolume -> resolvedOxidationWashVolume,
					SecondaryOxidationSolution -> resolvedSecondaryOxidationSolution,
					SecondaryOxidationVolume -> resolvedSecondaryOxidationVolume,
					SecondaryOxidationWashVolume -> resolvedSecondaryOxidationWashVolume,
					FinalWashVolume -> resolvedFinalWashVolume,
					Phosphoramidites -> resolvedAmidites,
					NumberOfCouplings -> resolvedNumberOfCouplings,
					PhosphoramiditeVolume -> resolvedPhosphoramiditeVolume,
					CouplingTime -> resolvedCouplingTime,
					Cleavage -> resolvedCleavages,
					CleavageTime -> resolvedCleavageTimes,
					CleavageTemperature -> resolvedCleavageTemperatures,
					CleavageSolution -> resolvedCleavageSolutions,
					CleavageWashSolution -> resolvedCleavageWashSolutions,
					CleavageSolutionVolume -> resolvedCleavageSolutionVolumes,
					CleavageWashVolume -> resolvedCleavageWashVolumes,
					StorageSolvent -> resolvedStorageSolvents,
					StorageSolventVolume -> resolvedStorageSolventVolume,

					PostCleavageDesalting -> resolvedPostCleavageDesalting,

					PostCleavageEvaporation -> resolvedPostCleavageEvaporation,

					RNADeprotection -> resolvedRNADeprotection,
					RNADeprotectionTime -> resolvedRNADeprotectionTime,
					RNADeprotectionTemperature -> resolvedRNADeprotectionTemperature,
					RNADeprotectionResuspensionSolution -> resolvedRNADeprotectionResuspensionSolution,
					RNADeprotectionResuspensionSolutionVolume -> resolvedRNADeprotectionResuspensionVolume,
					RNADeprotectionResuspensionTime -> resolvedRNADeprotectionResuspensionTime,
					RNADeprotectionResuspensionTemperature -> resolvedRNADeprotectionResuspensionTemperature,
					RNADeprotectionSolution -> resolvedRNADeprotectionSolution,
					RNADeprotectionSolutionVolume -> resolvedRNADeprotectionSolutionVolume,
					RNADeprotectionQuenchingSolution -> resolvedRNADeprotectionQuenchingSolution,
					RNADeprotectionQuenchingSolutionVolume -> resolvedRNADeprotectionQuenchingSolutionVolume,

					PostRNADeprotectionDesalting -> resolvedPostRNADeprotectionDesalting,

					PostRNADeprotectionEvaporation -> resolvedPostRNADeprotectionEvaporation,

					Email -> resolvedEmail
				},
					(*They would need to be replaced by resolved values or Nulls*)
					resolvedPostCleavageDesaltingRules,
					resolvedPostRNADeprotectionDesaltingRules,

					resolvedPostProcessingOptions}
				],
					Null]
			],
			Tests -> Flatten[{invalidPolymerTest, invalidStrandsTests, tooManyModificationsTests, tooManyStrandsTest, precisionTests,
				overspecifiedPhosphoramiditesTests, unknownMonomerTests,
				overspecifiedNumberOfCouplingsTests, overspecifiedPhosphoramiditeVolumeTests,
				overspecifiedCouplingTimeTests, nameUniquenessTest, columnScaleMismatchTest, cleavageOptionSetConflictTests,
				cleavageTrueConflictTests, cleavageFalseConflictTests, cleavageTrueNullConflictTests, cleavageFalseNullConflictTests,
				conflictingColumnLoadingTest, resinMatchingTests, repeatColumnTest, missingColumnLoadingTest,
				deprotectionFalseConflictTests, deprotectionTrueNullConflictTests, postCleavageDesaltingTrueNullConflictTests,
				postCleavageDesaltingFalseConflictTests, postRNADeprotectionDesaltingTrueNullConflictTests,
				postRNADeprotectionDesaltingFalseConflictTests, cleavageDesaltingConflictTests, deprotectionDesaltingConflictTests,
				rnaDeprotectionResuspensionConflictTests, rnaDeprotectionEvaporationConflictTests,
				cleavageOptionSetNullConflictTests, If[MemberQ[resolvedPostCleavageDesalting, True], postCleavageDesaltingTests, Nothing], If[MemberQ[resolvedPostRNADeprotectionDesalting, True], postRNADeprotectionDesaltingTests, Nothing]}]
		}
	]


];



(* ::Subsubsection:: *)
(* rnaSynthesisResourcePackets *)


DefineOptions[
	nnaSynthesisResourcePackets,
	Options :> {HelperOutputOption, CacheOption}
];

(* private function to generate the list of protocol packets containing resource blobs *)
nnaSynthesisResourcePackets[myPolymer:(RNA | DNA), myStrands:{ObjectP[Model[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myResourceOptions:OptionsPattern[rnaSynthesisResourcePackets]] := Module[
	{resolvedOptionsNoHidden, outputSpecification, output, cache, gatherTests, messages, allResourceBlobs, protocolPacket,
		fulfillable, frqTests, testsRule, resultRule, phosphoramiditeVolumeOption, numberOfCouplingsOption, couplingTimeOption,
		numberOfCouplingsByMonomer, phosphoramiditeVolumeByMonomer, groupedMonomersAndCycleParameters, scaleOption,
		couplingTimeByMonomer, monomersGroupedByParameters, synthesisTimeEstimate, strandLengths, numberOfReagentSets,
		couplingTimesForUniqueCycles, numberOfCouplingsForUniqueCycles, phosphoramiditeVolumesForUniqueCycles,
		existingSynthesisCyclesByParameterSet, synthesisCycleObjectsByParameterSet, synthesisCyclePacketsToUpload,
		monomerCyclePairs, strandPackets, cleavageMethodPackets, strands, synthesizerModelPacket,
		monomersByStrand, uniqueMonomers, phosphoramiditeDeadVolume, phosphoramiditePrimeVolume, reagentDeadVolume,
		reagentPrimeVolume, cleavageMethodPacketBySet, cleavageBySet, cleavageTemperatureBySet, cleavageTimeBySet,
		cleavageSolutionBySet, cleavageWashSolutionBySet, cleavageSolutionVolumeBySet, updatedCleavageMethodPackets,
		groupedIndexesAndCleavageParameters, indexesGroupedByParameters, existingCleavageMethodsBySet, cleavageMethodObjectsBySet,
		cleavageMethodPacketsToUpload, indexedCleavageMethodObjects,
		maxColumns, maxReagentSets, strandPartitionNumber, numberOfReplicates, numberOfStrands, strandIndexByReagentSet,
		numberOfCyclesTotal, monomersByStrandByReagentSet, groupedMonomers, numberOfCouplingIterations, capAVolumePerCycle,
		capAVolumeEstimates, capBVolumePerCycle, capBVolumeEstimates, oxidationVolumePerCycle, oxidationVolumeEstimates,
		deprotectionVolumePerCycle, deprotectionVolumeEstimate, washVolumePerCycle, initialAndFinalWashVolumes,
		washVolumeEstimates, activatorVolumeEstimates, monomerVolumeEstimates, capASolutionResources, capBSolutionResources,
		oxidationSolutionResources, activatorSolutionResources, washSolutionResources, deprotectionSolutionResource,
		activatorSolutionDesiccantResources, washSolutionDesiccantResources, columnModelPackets, resinLoading,
		resinsMassNeeded, columnResources, synthesizerResource, phosphoramiditesByReagentSet, phosphoramiditeVolumesByReagentSet,
		phosphoramiditeChemicalsByReagentSet,
		phosphoramiditeResources, cleavageWashVolumeBySet,
		cleavageTimeEstimate, listedCleavageMethodPackets,
		columnObjectMasses, resinContainerResources, centrifugeFilterResources, expandedStrandInputs, monomersSansResin, expandedColumns,
		expandedFinalDeprotection, expandedCleavage, expandedCleavageMethod, expandedCleavageSolution, expandedCleavageSolutionVolume,
		expandedCleavageTemperature, expandedCleavageTime, expandedCleavageWashSolution, expandedCleavageWashVolume,
		expandedStorageSolvent, expandedStorageSolventVolume, cacheBall, unexpandedStrands, convertedColumnModelPacks,
		columnResourceTargets, maxWidth, allPhosphoramiditeVials,
		expandedInputs, expandedResolvedOptions, optionsWithReplicates,
		expandedPostCleavageEvaporation, expandedPostCleavageDesalting, expandedRNADeprotectionTime, expandedRNADeprotectionTemperature,
		expandedRNADeprotectionResuspensionVolume, expandedRNADeprotectionResuspensionTime,
		expandedRNADeprotectionResuspensionTemperature, expandedRNADeprotectionSolutionVolume,
		expandedRNADeprotectionQuenchingSolutionVolume, expandedPostRNADeprotectionEvaporation, expandedPostRNADeprotectionDesalting,
		expandedRNADeprotectionMethod, expandedRNADeprotectionResuspensionSolution, expandedRNADeprotectionSolution,
		expandedRNADeprotectionQuenchingSolution, listedRNADeprotectionMethodPackets, rnaDeprotectionMethodPackets,
		updatedRNADeprotectionMethodPackets, expandedRNADeprotection, groupedIndexesAndRNADeprotectionParameters,
		indexesGroupedByParametersDeprotection, rnaDeprotectionMethodPacketsBySet, rnaDeprotectionBySet,
		rnaDeprotectionTemperatureBySet, rnaDeprotectionTimeBySet, rnaDeprotectionSolutionBySet,
		rnaDeprotectionSolutionVolumeBySet, rnaDeprotectionResuspensionVolumeBySet,
		rnaDeprotectionResuspensionTimeBySet, rnaDeprotectionResuspensionTemperatureBySet,
		rnaDeprotectionResuspensionSolutionBySet, rnaDeprotectionQuenchingSolutionVolumeBySet,
		rnaDeprotectionQuenchingSolutionBySet, existingRNADeprotectionMethodsBySet, rnaDeprotectionMethodObjectsBySet,
		rnaDeprotectionMethodPacketsToUpload, indexedRNADeprotectionMethodObjects, rnaDeprotectionTimeEstimate,

		expandedPostCleavageDesaltingInstrument, expandedPostCleavageDesaltingPreFlushBuffer,
		expandedPostCleavageDesaltingEquilibrationBuffer, expandedPostCleavageDesaltingWashBuffer,
		expandedPostCleavageDesaltingElutionBuffer, expandedPostCleavageDesaltingSampleLoadRates,
		expandedPostCleavageDesaltingRinseAndReloads, expandedPostCleavageDesaltingRinseAndReloadVolumes,
		expandedPostCleavageDesaltingType, expandedPostCleavageDesaltingCartridges, expandedPostCleavageDesaltingPreFlushVolumes,
		expandedPostCleavageDesaltingPreFlushRates, expandedPostCleavageDesaltingEquilibrationVolumes,
		expandedPostCleavageDesaltingEquilibrationRates, expandedPostCleavageDesaltingElutionVolumes,
		expandedPostCleavageDesaltingElutionRates, expandedPostCleavageDesaltingWashVolumes,
		expandedPostCleavageDesaltingWashRates,

		expandedPostRNADeprotectionDesaltingInstrument, expandedPostRNADeprotectionDesaltingPreFlushBuffer,
		expandedPostRNADeprotectionDesaltingEquilibrationBuffer, expandedPostRNADeprotectionDesaltingWashBuffer,
		expandedPostRNADeprotectionDesaltingElutionBuffer, expandedPostRNADeprotectionDesaltingSampleLoadRates,
		expandedPostRNADeprotectionDesaltingRinseAndReloads, expandedPostRNADeprotectionDesaltingRinseAndReloadVolumes,
		expandedPostRNADeprotectionDesaltingType, expandedPostRNADeprotectionDesaltingCartridges, expandedPostRNADeprotectionDesaltingPreFlushVolumes,
		expandedPostRNADeprotectionDesaltingPreFlushRates, expandedPostRNADeprotectionDesaltingEquilibrationVolumes,
		expandedPostRNADeprotectionDesaltingEquilibrationRates, expandedPostRNADeprotectionDesaltingElutionVolumes,
		expandedPostRNADeprotectionDesaltingElutionRates, expandedPostRNADeprotectionDesaltingWashVolumes,
		expandedPostRNADeprotectionDesaltingWashRates,

		existingSynthesisCyclesByParameterSetCleaned, newSynthesisCycleIDs, missingSynthesisCyclePositions, existingSynthesisCyclesPositions,
		existingCleavageMethodByParameterSetCleaned, newCleavageMethodIDs, missingCleavageMethodPositions, existingCleavageMethodPositions,
		cleavageMethodsBySet,

		newRNADeprotectionMethodIDs, missingRNADeprotectionMethodPositions, existingRNADeprotectionMethodPositions, rnaDeprotectionMethodsBySet,
		existingRNADeprotectionMethodByParameterSetCleaned, hydrofluoricAcidSafetyAgentResource, sortedMonomers,
		expectedEvapInstReservationTime, expandedEvapInsts, expandedEvapResource, resolvedOptionsOutput,
		incubationInstrumentResourcePerBatch, incubationInstrumentsPerBatch, expandedCleavageInstruments,
		simulatedForCleavage, cleavageBatchLengths, groupedCleavageParameters, expandedDeprotectionInstruments,

		expandedSecondaryCyclePositions, oxidationVolumeEstimatesLC, oxidationVolumePerCycleLC, oxidationSolutionResourceLC,

		phosphoramiditeDesiccants, dessicantPhosphoramiditeLosses, realPhosphoramiditeVolumes,
		phosphoramiditeVolumeIncrements
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[experimentNNASynthesis, {myPolymer, myStrands}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		experimentNNASynthesis,
		RemoveHiddenOptions[experimentNNASynthesis, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[ToList[expandedResolvedOptions], Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Get the cache *)
	cache = Lookup[ToList[myResourceOptions], Cache];

	(* Get the number of replicates *)
	numberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
	{expandedStrandInputs, optionsWithReplicates} = expandNumberOfReplicates[experimentNNASynthesis, myStrands, expandedResolvedOptions];

	{
		expandedColumns, expandedFinalDeprotection, expandedCleavage, expandedCleavageSolutionVolume,
		expandedCleavageTemperature, expandedCleavageTime, expandedCleavageWashVolume, expandedStorageSolventVolume,
		expandedPostCleavageEvaporation, expandedPostCleavageDesalting, expandedRNADeprotection, expandedRNADeprotectionTime,
		expandedRNADeprotectionTemperature, expandedRNADeprotectionResuspensionVolume, expandedRNADeprotectionResuspensionTime,
		expandedRNADeprotectionResuspensionTemperature, expandedRNADeprotectionSolutionVolume,
		expandedRNADeprotectionQuenchingSolutionVolume, expandedPostRNADeprotectionEvaporation, expandedPostRNADeprotectionDesalting

	} = Lookup[optionsWithReplicates,
		{
			Columns, FinalDeprotection, Cleavage, CleavageSolutionVolume,
			CleavageTemperature, CleavageTime, CleavageWashVolume, StorageSolventVolume,
			PostCleavageEvaporation, PostCleavageDesalting, RNADeprotection, RNADeprotectionTime,
			RNADeprotectionTemperature, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime,
			RNADeprotectionResuspensionTemperature, RNADeprotectionSolutionVolume,
			RNADeprotectionQuenchingSolutionVolume, PostRNADeprotectionEvaporation, PostRNADeprotectionDesalting
		}
	];

	{
		expandedCleavageMethod,
		expandedCleavageSolution,
		expandedCleavageWashSolution,
		expandedStorageSolvent,
		expandedRNADeprotectionMethod,
		expandedRNADeprotectionResuspensionSolution,
		expandedRNADeprotectionSolution,
		expandedRNADeprotectionQuenchingSolution
	} =
		{
			Lookup[optionsWithReplicates, CleavageMethod],
			Lookup[optionsWithReplicates, CleavageSolution],
			Lookup[optionsWithReplicates, CleavageWashSolution],
			Lookup[optionsWithReplicates, StorageSolvent],
			Lookup[optionsWithReplicates, RNADeprotectionMethod, {}],
			Lookup[optionsWithReplicates, RNADeprotectionResuspensionSolution, {}],
			Lookup[optionsWithReplicates, RNADeprotectionSolution, {}],
			Lookup[optionsWithReplicates, RNADeprotectionQuenchingSolution, {}]
		};

	(* get expanded desalting options *)
	{
		expandedPostCleavageDesaltingInstrument, expandedPostCleavageDesaltingPreFlushBuffer,
		expandedPostCleavageDesaltingEquilibrationBuffer, expandedPostCleavageDesaltingWashBuffer,
		expandedPostCleavageDesaltingElutionBuffer, expandedPostCleavageDesaltingSampleLoadRates,
		expandedPostCleavageDesaltingRinseAndReloads, expandedPostCleavageDesaltingRinseAndReloadVolumes,
		expandedPostCleavageDesaltingType, expandedPostCleavageDesaltingCartridges,
		expandedPostCleavageDesaltingPreFlushVolumes, expandedPostCleavageDesaltingPreFlushRates,
		expandedPostCleavageDesaltingEquilibrationVolumes, expandedPostCleavageDesaltingEquilibrationRates,
		expandedPostCleavageDesaltingElutionVolumes, expandedPostCleavageDesaltingElutionRates,
		expandedPostCleavageDesaltingWashVolumes, expandedPostCleavageDesaltingWashRates

	} = Lookup[optionsWithReplicates,
		{
			PostCleavageDesaltingInstrument,
			PostCleavageDesaltingPreFlushBuffer,
			PostCleavageDesaltingEquilibrationBuffer,
			PostCleavageDesaltingWashBuffer,
			PostCleavageDesaltingElutionBuffer,
			PostCleavageDesaltingSampleLoadRate,
			PostCleavageDesaltingRinseAndReload,
			PostCleavageDesaltingRinseAndReloadVolume,
			PostCleavageDesaltingType,
			PostCleavageDesaltingCartridge,
			PostCleavageDesaltingPreFlushVolume,
			PostCleavageDesaltingPreFlushRate,
			PostCleavageDesaltingEquilibrationVolume,
			PostCleavageDesaltingEquilibrationRate,
			PostCleavageDesaltingElutionVolume,
			PostCleavageDesaltingElutionRate,
			PostCleavageDesaltingWashVolume,
			PostCleavageDesaltingWashRate
		},
		{}
	];

	{
		expandedPostRNADeprotectionDesaltingInstrument, expandedPostRNADeprotectionDesaltingPreFlushBuffer,
		expandedPostRNADeprotectionDesaltingEquilibrationBuffer, expandedPostRNADeprotectionDesaltingWashBuffer,
		expandedPostRNADeprotectionDesaltingElutionBuffer, expandedPostRNADeprotectionDesaltingSampleLoadRates,
		expandedPostRNADeprotectionDesaltingRinseAndReloads, expandedPostRNADeprotectionDesaltingRinseAndReloadVolumes,
		expandedPostRNADeprotectionDesaltingType, expandedPostRNADeprotectionDesaltingCartridges,
		expandedPostRNADeprotectionDesaltingPreFlushVolumes, expandedPostRNADeprotectionDesaltingPreFlushRates,
		expandedPostRNADeprotectionDesaltingEquilibrationVolumes, expandedPostRNADeprotectionDesaltingEquilibrationRates,
		expandedPostRNADeprotectionDesaltingElutionVolumes, expandedPostRNADeprotectionDesaltingElutionRates,
		expandedPostRNADeprotectionDesaltingWashVolumes, expandedPostRNADeprotectionDesaltingWashRates

	} = Lookup[optionsWithReplicates,
		{
			PostRNADeprotectionDesaltingInstrument,
			PostRNADeprotectionDesaltingPreFlushBuffer,
			PostRNADeprotectionDesaltingEquilibrationBuffer,
			PostRNADeprotectionDesaltingWashBuffer,
			PostRNADeprotectionDesaltingElutionBuffer,
			PostRNADeprotectionDesaltingSampleLoadRate,
			PostRNADeprotectionDesaltingRinseAndReload,
			PostRNADeprotectionDesaltingRinseAndReloadVolume,
			PostRNADeprotectionDesaltingType,
			PostRNADeprotectionDesaltingCartridge,
			PostRNADeprotectionDesaltingPreFlushVolume,
			PostRNADeprotectionDesaltingPreFlushRate,
			PostRNADeprotectionDesaltingEquilibrationVolume,
			PostRNADeprotectionDesaltingEquilibrationRate,
			PostRNADeprotectionDesaltingElutionVolume,
			PostRNADeprotectionDesaltingElutionRate,
			PostRNADeprotectionDesaltingWashVolume,
			PostRNADeprotectionDesaltingWashRate
		},
		{}
	];

	(* extract parameters for the secondary oxidation cycles *)
	expandedSecondaryCyclePositions = Lookup[optionsWithReplicates, SecondaryCyclePositions,{}];

	(* Extract the packets that we need from our downloaded cache. *)
	{strandPackets, listedCleavageMethodPackets, listedRNADeprotectionMethodPackets, phosphoramiditeVolumeIncrements} = Quiet[
		Download[
			{
				myStrands,
				expandedCleavageMethod,
				expandedRNADeprotectionMethod,
				Lookup[optionsWithReplicates, Phosphoramidites][[All,2]]
			},
			{
				{Packet[Field[Composition[[All, 2]]][{PolymerType, Molecule}]]},
				{Packet[Name, CleavageSolution, CleavageSolutionVolume, CleavageTime, CleavageTemperature, CleavageWashSolution, CleavageWashVolume]},
				{Packet[Name, RNADeprotectionResuspensionSolution, RNADeprotectionResuspensionSolutionVolume, RNADeprotectionResuspensionTime, RNADeprotectionResuspensionTemperature, RNADeprotectionSolution, RNADeprotectionSolutionVolume, RNADeprotectionTemperature, RNADeprotectionTime, RNADeprotectionQuenchingSolution, RNADeprotectionQuenchingSolutionVolume]},
				{Packet[VolumeIncrements]}
			}, Cache -> cache
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::Part}
	];

	cacheBall = FlattenCachePackets[{cache, {strandPackets, listedCleavageMethodPackets, listedRNADeprotectionMethodPackets}}];

	cleavageMethodPackets = Flatten[listedCleavageMethodPackets];

	rnaDeprotectionMethodPackets = Flatten[listedRNADeprotectionMethodPackets];

	(* Expand the strand inputs to account for number of replicates *)
	expandedStrandInputs = Flatten[ConstantArray[#, numberOfReplicates] & /@ myStrands];

	(* Given that information can be nested a view objects deep, we should go through each set of packets to determine which sequence to use *)
	unexpandedStrands = MapThread[
		Function[{strandExamined},
			Module[{trimmedCompositionPackets},

				(* Flatten the doubly-listed set of component packets and then delete Null, which we would've received in the case of a {Null, Null} composition element *)
				trimmedCompositionPackets = DeleteCases[Flatten[strandExamined], Null];

				(* Lookup the molecule field and find all instances of strands *)
				Cases[
					Lookup[trimmedCompositionPackets, Molecule, Null],
					StrandP,
					Infinity(* To pierce through structures *)
				]
			]
		],
		{strandPackets}
	];

	(* Expand the strand packets to account for number of replicates *)
	strands = Flatten[ConstantArray[#, numberOfReplicates] & /@ unexpandedStrands];

	(* The monomers that are in each strand *)
	monomersByStrand = Monomers[strands];

	(* Get the packet for each column model *)
	columnModelPackets = Map[
		If[MatchQ[#, ObjectP[{Model[Sample], Model[Resin]}]],
			FirstCase[cacheBall, KeyValuePattern[Object -> Download[#, Object]]],
			FirstCase[cacheBall, KeyValuePattern[Object -> Download[Lookup[FirstCase[cacheBall, KeyValuePattern[Object -> Download[#, Object]]], Model], Object]]]
		]&, expandedColumns];

	(* For each column and strand, confirm that the oligomer on the resin (if any) matches the first part of the strand being synthesized *)
	monomersSansResin = MapThread[Function[{columnModelPacket, strandMonomers},
		Module[{componentObjs, componentPacks, resinPacket},

			resinPacket = If[MatchQ[Lookup[columnModelPacket, Object, Null], ObjectP[Model[Sample]]],

				(* Go through the column model's composition to find the resin *)
				(

					componentObjs = Lookup[
						FirstCase[cacheBall, AssociationMatchP[<|Object -> Lookup[columnModelPacket, Object], Composition -> _|>, AllowForeignKeys -> True]],
						Composition,
						{{Null, Null}}
					][[All, 2]];

					componentPacks = Map[
						Function[{nextComponent},
							FirstCase[cacheBall, AssociationMatchP[<|Object -> Download[nextComponent, Object]|>, AllowForeignKeys -> True]]
						],
						componentObjs
					];

					FirstCase[
						componentPacks,
						AssociationMatchP[<|Type -> Alternatives[Model[Resin], Model[Resin, SolidPhaseSupport]], Strand -> _|>, AllowForeignKeys -> True],
						{}
					]
				),

				(* Otherwise our packet is already a Model[Resin] or Null*)
				Lookup[columnModelPacket, Object, Null]
			];

			If[MatchQ[resinPacket, AssociationMatchP[<|Object -> ObjectP[Model[Resin, SolidPhaseSupport]]|>, AllowForeignKeys -> True]],

				Module[{resinOligomer, resinOligomerPacket, resinStrand, resinMonomers, resinSequenceLength},

					(* the oligomer on the resin *)
					resinOligomer = Lookup[resinPacket, Strand];

					(* Find the packet corresponding to this oligomer *)
					resinOligomerPacket = FirstCase[cacheBall, KeyValuePattern[{Object -> Download[resinOligomer, Object], Molecule -> _}]];

					(* Get the strand on the resin *)
					resinStrand = ToStrand[Lookup[resinOligomerPacket, Molecule]];

					(* the monomers of the oligomer on the resin, 5' to 3' *)
					resinMonomers = Flatten[Monomers[resinStrand]];

					(* the number of monomers on the resin. *)
					resinSequenceLength = Length[resinMonomers];

					(* Remaining strand to synthesize *)
					Take[Flatten[strandMonomers], {1, -(resinSequenceLength + 1)}]
				],

				(* If there is no oligomer on the resin, return True *)
				Flatten[strandMonomers]
			]
		]
	], {columnModelPackets, monomersByStrand}];

	(* The unique monomers that are in the input strands. *)
	uniqueMonomers = DeleteDuplicates[Flatten[monomersSansResin]];

	(* Pull out details about the synthesizer *)
	synthesizerModelPacket = FirstCase[cacheBall, ObjectP[Model[Instrument, DNASynthesizer]]];
	{phosphoramiditeDeadVolume, phosphoramiditePrimeVolume, reagentDeadVolume, reagentPrimeVolume} = Lookup[synthesizerModelPacket, {PhosphoramiditeDeadVolume, PhosphoramiditePrimeVolume, ReagentDeadVolume, ReagentPrimeVolume}];

	scaleOption = Lookup[myResolvedOptions, Scale];

	(* --- Find or make SynthesisCycle packets -- *)

	(* Pull out relevant option values *)
	{phosphoramiditeVolumeOption, numberOfCouplingsOption, couplingTimeOption} = Lookup[myResolvedOptions, {PhosphoramiditeVolume, NumberOfCouplings, CouplingTime}];

	(* Figure out the coupling time for each monomer. *)
	couplingTimeByMonomer = Map[Function[monomer,
		Which[
			(* If the option value is a single value, use it for all monomers. *)
			MatchQ[couplingTimeOption, TimeP],
			couplingTimeOption,

			(* If the option value is a list of pairs and the monomer is A/U/G/C for RNA or ATGC for DNA, use the value for Natural. *)
			MatchQ[monomer, Alternatives[
				RNA["A"], RNA["U"], RNA["G"], RNA["C"],
				DNA["A"], DNA["T"], DNA["G"], DNA["C"]]],
			FirstCase[couplingTimeOption, {"Natural", ___}][[2]],

			(* Otherwise, use the corresponding value for the monomer in the pair-value list. *)
			True,
			FirstCase[couplingTimeOption, {monomer, ___}][[2]]
		]
	], uniqueMonomers];

	(* Figure out the numberOfCouplingsOption for each monomer. *)
	numberOfCouplingsByMonomer = Map[Function[monomer,
		Which[
			(* If the option value is a single value, use it for all monomers. *)
			MatchQ[numberOfCouplingsOption, _Integer],
			numberOfCouplingsOption,

			(* If the option value is a list of pairs and the monomer is A/U/G/C for RNA or ATGC for DNA, use the value for Natural. *)
			MatchQ[monomer, Alternatives[
				RNA["A"], RNA["U"], RNA["G"], RNA["C"],
				DNA["A"], DNA["T"], DNA["G"], DNA["C"]]],
			FirstCase[numberOfCouplingsOption, {"Natural", ___}][[2]],

			(* Otherwise, use the corresponding value for the monomer in the pair-value list. *)
			True,
			FirstCase[numberOfCouplingsOption, {monomer, ___}][[2]]
		]
	], uniqueMonomers];

	(* Figure out the phosphoramiditeVolume for each monomer. *)
	phosphoramiditeVolumeByMonomer = Map[Function[monomer,
		Which[
			(* If the option value is a single value, use it for all monomers. *)
			MatchQ[phosphoramiditeVolumeOption, VolumeP],
			phosphoramiditeVolumeOption,

			(* If the option value is a list of pairs and the monomer is A/U/G/C for RNA or ATGC for DNA, use the value for Natural. *)
			MatchQ[monomer, Alternatives[
				RNA["A"], RNA["U"], RNA["G"], RNA["C"],
				DNA["A"], DNA["T"], DNA["G"], DNA["C"]]],
			FirstCase[phosphoramiditeVolumeOption, {"Natural", ___}][[2]],

			(* Otherwise, use the corresponding value for the monomer in the pair-value list. *)
			True,
			FirstCase[phosphoramiditeVolumeOption, {monomer, ___}][[2]]
		]
	], uniqueMonomers];

	(* We want all monomers that use the same cycle parameters to point to the same cycle object. Group monomers that use the same parameters together, along with their parameters. *)
	groupedMonomersAndCycleParameters = GatherBy[Transpose[{uniqueMonomers, couplingTimeByMonomer, numberOfCouplingsByMonomer, phosphoramiditeVolumeByMonomer}], #[[2 ;; -1]] &];

	(* Get the monomers grouped by cycle parameters *)
	monomersGroupedByParameters = groupedMonomersAndCycleParameters[[All, All, 1]];

	(* Get the cycle parameters for each unique group of cycle parameters*)
	{couplingTimesForUniqueCycles, numberOfCouplingsForUniqueCycles, phosphoramiditeVolumesForUniqueCycles} = Transpose[groupedMonomersAndCycleParameters[[All, All, 2 ;; -1]][[All, 1]]];

	(* Find an existing synthesis cycle (if one exists) that matches each unique set of cycle parameters *)
	existingSynthesisCyclesByParameterSet = With[{
		searchTypes = ConstantArray[{Object[Method, SynthesisCycle]}, Length[monomersGroupedByParameters]],
		searchConditions = MapThread[
			And[
				SynthesisType == myPolymer,
				CouplingTime == #1,
				NumberOfCouplings == #2,
				MonomerVolumeRatio == (#3 / (scaleOption))
			] &, {couplingTimesForUniqueCycles, numberOfCouplingsForUniqueCycles, phosphoramiditeVolumesForUniqueCycles}]
	},
		Search[searchTypes, searchConditions, MaxResults -> 1]
	];

	(* Get the synthesis cycle object that we will use for each unique set of cycle parameters. If we found one from searching, use that. Otherwise, make one. *)
	(*make a list of positions that exist in the DB*)
	existingSynthesisCyclesPositions = Flatten@Position[existingSynthesisCyclesByParameterSet, _?(Length[#]>0&),1];
	(*make a list of positions that are fail *)
	missingSynthesisCyclePositions = Complement[Range[Length[existingSynthesisCyclesByParameterSet]], existingSynthesisCyclesPositions];
	(*create IDs for fails*)
	newSynthesisCycleIDs = CreateID[ConstantArray[Object[Method, SynthesisCycle],Length[missingSynthesisCyclePositions]]];
	(* make search results free of the non-existing SynthesisCycles *)
	existingSynthesisCyclesByParameterSetCleaned = First/@DeleteCases[existingSynthesisCyclesByParameterSet,{}];
	(*reassemble*)
	synthesisCycleObjectsByParameterSet = SortBy[
		Join[
			Transpose[{existingSynthesisCyclesPositions, existingSynthesisCyclesByParameterSetCleaned}],
			Transpose[{missingSynthesisCyclePositions, newSynthesisCycleIDs}]
		],First][[All,2]];

	(* If we couldn't find an existing method for any unique set of cycle parameters, make one *)
	synthesisCyclePacketsToUpload = MapThread[Function[{existing, object, time, number, volume},
		If[MatchQ[existing, {}],
			<|
				Type -> Object[Method, SynthesisCycle],
				Object -> object,
				SynthesisType -> myPolymer,
				CouplingTime -> time,
				NumberOfCouplings -> number,
				MonomerVolumeRatio -> (volume / (scaleOption))
			|>,
			Nothing
		]], {existingSynthesisCyclesByParameterSet, synthesisCycleObjectsByParameterSet, couplingTimesForUniqueCycles, numberOfCouplingsForUniqueCycles, phosphoramiditeVolumesForUniqueCycles}
	];

	(* Pair each monomer with the cycle object that it will use *)
	monomerCyclePairs = Partition[Flatten[Map[Function[monomersAndCycle, Map[{#, Link[monomersAndCycle[[2]]]} &, monomersAndCycle[[1]]]], Transpose[{monomersGroupedByParameters, synthesisCycleObjectsByParameterSet}]]], 2];

	(* --- Find or make CleavageMethod packets -- *)

	(* Get an updated list of cleavage methods, with Nulls replacing any indexes where the cleavage method will need to be replaced.
		(The cleavage method option is used as a template, so it is possible that other specified options overwrote some of the settings in the method.) *)
	updatedCleavageMethodPackets = MapThread[Function[{methodPacket, temperature, time, solution, wash, volume, washVolume},
		If[
			Or[
				NullQ[methodPacket],
				And[
					MatchQ[Lookup[methodPacket, CleavageTemperature], temperature],
					MatchQ[Lookup[methodPacket, CleavageTime], time],
					MatchQ[Download[Lookup[methodPacket, CleavageSolution], Object], solution],
					MatchQ[Download[Lookup[methodPacket, CleavageWashSolution], Object], wash],
					MatchQ[Lookup[methodPacket, CleavageSolutionVolume], volume],
					MatchQ[Lookup[methodPacket, CleavageWashVolume], washVolume]
				]
			],
			methodPacket,
			Null]
	], {cleavageMethodPackets, expandedCleavageTemperature, expandedCleavageTime, expandedCleavageSolution, expandedCleavageWashSolution, expandedCleavageSolutionVolume, expandedCleavageWashVolume}];


	(* We want all strands that use the same cleavage parameters to point to the same cleavage method object.
	Group indexes that use the same parameters together, along with their parameters.*)
	groupedIndexesAndCleavageParameters = GatherBy[Transpose[{Range[Length[expandedCleavage]], updatedCleavageMethodPackets, expandedCleavage, expandedCleavageTemperature, expandedCleavageTime, expandedCleavageSolution, expandedCleavageWashSolution, expandedCleavageSolutionVolume, expandedCleavageWashVolume}], #[[2 ;; -1]] &];

	(* Get the indexes grouped by cycle parameters *)
	indexesGroupedByParameters = groupedIndexesAndCleavageParameters[[All, All, 1]];

	(* Get the cycle parameters for each unique group of cycle parameters*)
	{cleavageMethodPacketBySet, cleavageBySet, cleavageTemperatureBySet, cleavageTimeBySet, cleavageSolutionBySet, cleavageWashSolutionBySet, cleavageSolutionVolumeBySet, cleavageWashVolumeBySet} = Transpose[groupedIndexesAndCleavageParameters[[All, All, 2 ;; -1]][[All, 1]]];

	(* For each set of cleavage parameters, search for  *)

	(* Find an existing synthesis cycle (if one exists) that matches each unique set of cycle parameters *)
	existingCleavageMethodsBySet = With[{
		searchTypes = ConstantArray[{Object[Method, Cleavage]}, Length[indexesGroupedByParameters]],
		searchConditions = MapThread[Function[{temperature, time, solution, wash, volume, washVolume},
			And[
				CleavageTemperature == temperature,
				CleavageTime == time,
				CleavageSolution == solution,
				CleavageWashSolution == wash,
				CleavageSolutionVolume == volume,
				CleavageWashVolume == washVolume
			]], {cleavageTemperatureBySet, cleavageTimeBySet, cleavageSolutionBySet, cleavageWashSolutionBySet, cleavageSolutionVolumeBySet, cleavageWashVolumeBySet}]
	},
		Search[searchTypes, searchConditions, MaxResults -> 1]
	];

	(* Create IDs for the missing cleavage methods *)
	(*make a list of positions that exist in the DB*)
	existingCleavageMethodPositions = Flatten@Position[existingCleavageMethodsBySet, _?(Length[#]>0&),1];
	(*make a list of positions that are fail *)
	missingCleavageMethodPositions = Complement[Range[Length[existingCleavageMethodsBySet]], existingCleavageMethodPositions];
	(*create IDs for fails*)
	newCleavageMethodIDs = CreateID[ConstantArray[Object[Method, Cleavage],Length[missingCleavageMethodPositions]]];
	(* make search results free of the non-existing CleavageMethod *)
	existingCleavageMethodByParameterSetCleaned = First/@DeleteCases[existingCleavageMethodsBySet,{}];
	(*reassemble*)
	cleavageMethodsBySet = SortBy[
		Join[
			Transpose[{existingCleavageMethodPositions, existingCleavageMethodByParameterSetCleaned}],
			Transpose[{missingCleavageMethodPositions, newCleavageMethodIDs}]
		],First][[All,2]];

	(* Get the cleavage method object that we will use for each unique set of cleavage parameters. *)
	cleavageMethodObjectsBySet = MapThread[Function[{existingMethod, specifiedMethod, cleavageBool},
		Which[
			(* If we aren't cleaving, the method is Null *)
			MatchQ[cleavageBool, False],
			Null,

			(* If a method was specified, use it. (We already validated that the given method agrees with all the other cleavage options.) *)
			MatchQ[specifiedMethod, ObjectP[]],
			Download[specifiedMethod, Object],

			(* If we found an existing method, use it *)
			True,
			existingMethod
		]
	], {cleavageMethodsBySet, cleavageMethodPacketBySet, cleavageBySet}];

	(* If we couldn't find an existing method for any unique set of cleavage, make one *)
	cleavageMethodPacketsToUpload = MapThread[Function[{existingMethod, object, cleavageBool, temperature, time, solution, wash, volume, washVolume},
		If[TrueQ[cleavageBool] && MatchQ[existingMethod, {}],
			<|
				Type -> Object[Method, Cleavage],
				Object -> object,
				CleavageTime -> time,
				CleavageTemperature -> temperature,
				CleavageSolution -> Link[solution],
				CleavageWashSolution -> Link[wash],
				CleavageSolutionVolume -> volume,
				CleavageWashVolume -> washVolume
			|>,
			Nothing
		]], {existingCleavageMethodsBySet, cleavageMethodObjectsBySet, cleavageBySet, cleavageTemperatureBySet, cleavageTimeBySet, cleavageSolutionBySet, cleavageWashSolutionBySet, cleavageSolutionVolumeBySet, cleavageWashVolumeBySet}
	];

	(* Get the cleavage methods back to an index matched list to the strands *)
	indexedCleavageMethodObjects = SortBy[Partition[Flatten[Map[Function[indexesAndMethod, Map[{#, indexesAndMethod[[2]]} &, indexesAndMethod[[1]]]], Transpose[{indexesGroupedByParameters, cleavageMethodObjectsBySet}]]], 2], First][[All, 2]];

	If[MatchQ[myPolymer, RNA],
		Module[{},
			(* --- Find or make RNADeprotection packets -- *)

			(* Get an updated list of rna deprotection methods, with Nulls replacing any indexes where the rna deprotection method will need to be replaced.
				(The rna deprotection method option is used as a template, so it is possible that other specified options overwrote some of the settings in the method.) *)
			updatedRNADeprotectionMethodPackets = MapThread[Function[{methodPacket, temperature, time, solution, volume, resuspensionVolume, resuspensionTime, resuspensionTemperature, resuspensionSolution, quenchingVolume, quenchingSolution},
				If[
					Or[
						NullQ[methodPacket],
						And[
							MatchQ[Lookup[methodPacket, RNADeprotectionTemperature], temperature],
							MatchQ[Lookup[methodPacket, RNADeprotectionTime], time],
							MatchQ[Download[Lookup[methodPacket, RNADeprotectionSolution], Object], solution],
							MatchQ[Lookup[methodPacket, RNADeprotectionSolutionVolume], volume],
							MatchQ[Lookup[methodPacket, RNADeprotectionResuspensionSolutionVolume], resuspensionVolume],
							MatchQ[Lookup[methodPacket, RNADeprotectionResuspensionTime], resuspensionTime],
							MatchQ[Lookup[methodPacket, RNADeprotectionResuspensionTemperature], resuspensionTemperature],
							MatchQ[Download[Lookup[methodPacket, RNADeprotectionResuspensionSolution], Object], resuspensionSolution],
							MatchQ[Lookup[methodPacket, RNADeprotectionQuenchingVolume], quenchingVolume],
							MatchQ[Download[Lookup[methodPacket, RNADeprotectionQuenchingSolution], Object], quenchingSolution]
						]
					],
					methodPacket,
					Null]
			], {rnaDeprotectionMethodPackets, expandedRNADeprotectionTemperature, expandedRNADeprotectionTime, expandedRNADeprotectionSolution, expandedRNADeprotectionSolutionVolume, expandedRNADeprotectionResuspensionVolume, expandedRNADeprotectionResuspensionTime, expandedRNADeprotectionResuspensionTemperature, expandedRNADeprotectionResuspensionSolution, expandedRNADeprotectionQuenchingSolutionVolume, expandedRNADeprotectionQuenchingSolution}];


			(* We want all strands that use the same rna deprotection parameters to point to the same rna deprotection method object.
			Group indexes that use the same parameters together, along with their parameters.*)
			groupedIndexesAndRNADeprotectionParameters = GatherBy[Transpose[{Range[Length[expandedRNADeprotection]], updatedRNADeprotectionMethodPackets, expandedRNADeprotection, expandedRNADeprotectionTemperature, expandedRNADeprotectionTime, expandedRNADeprotectionSolution, expandedRNADeprotectionSolutionVolume, expandedRNADeprotectionResuspensionVolume, expandedRNADeprotectionResuspensionTime, expandedRNADeprotectionResuspensionTemperature, expandedRNADeprotectionResuspensionSolution, expandedRNADeprotectionQuenchingSolutionVolume, expandedRNADeprotectionQuenchingSolution}], #[[2 ;; -1]] &];

			(* Get the indexes grouped by cycle parameters *)
			indexesGroupedByParametersDeprotection = groupedIndexesAndRNADeprotectionParameters[[All, All, 1]];

			(* Get the cycle parameters for each unique group of cycle parameters*)
			{rnaDeprotectionMethodPacketsBySet, rnaDeprotectionBySet, rnaDeprotectionTemperatureBySet, rnaDeprotectionTimeBySet, rnaDeprotectionSolutionBySet, rnaDeprotectionSolutionVolumeBySet, rnaDeprotectionResuspensionVolumeBySet, rnaDeprotectionResuspensionTimeBySet, rnaDeprotectionResuspensionTemperatureBySet, rnaDeprotectionResuspensionSolutionBySet, rnaDeprotectionQuenchingSolutionVolumeBySet, rnaDeprotectionQuenchingSolutionBySet} = Transpose[groupedIndexesAndRNADeprotectionParameters[[All, All, 2 ;; -1]][[All, 1]]];


			(* Find an existing synthesis cycle (if one exists) that matches each unique set of cycle parameters *)
			existingRNADeprotectionMethodsBySet = With[{
				searchTypes = ConstantArray[{Object[Method, RNADeprotection]}, Length[indexesGroupedByParametersDeprotection]],
				searchConditions = MapThread[Function[{temperature, time, solution, volume, resuspensionVolume, resuspensionTime, resuspensionTemperature, resuspensionSolution, quenchingVolume, quenchingSolution},
					And[
						RNADeprotectionTemperature == temperature,
						RNADeprotectionTime == time,
						RNADeprotectionSolution == solution,
						RNADeprotectionSolutionVolume == volume,
						RNADeprotectionResuspensionSolutionVolume == resuspensionVolume,
						RNADeprotectionResuspensionSolution == resuspensionSolution,
						RNADeprotectionResuspensionTime == resuspensionTime,
						RNADeprotectionResuspensionTemperature == resuspensionTemperature,
						RNADeprotectionQuenchingSolution == quenchingSolution,
						RNADeprotectionQuenchingSolutionVolume == quenchingVolume
					]], {rnaDeprotectionTemperatureBySet, rnaDeprotectionTimeBySet, rnaDeprotectionSolutionBySet, rnaDeprotectionSolutionVolumeBySet, rnaDeprotectionResuspensionVolumeBySet, rnaDeprotectionResuspensionTimeBySet, rnaDeprotectionResuspensionTemperatureBySet, rnaDeprotectionResuspensionSolutionBySet, rnaDeprotectionQuenchingSolutionVolumeBySet, rnaDeprotectionQuenchingSolutionBySet}]
			},
				Search[searchTypes, searchConditions, MaxResults -> 1]
			];

			(* Create IDs for the missing rNADeprotection methods *)
			(*make a list of positions that exist in the DB*)
			existingRNADeprotectionMethodPositions = Flatten@Position[existingRNADeprotectionMethodsBySet, _?(Length[#]>0&),1];
			(*make a list of positions that are fail *)
			missingRNADeprotectionMethodPositions = Complement[Range[Length[existingRNADeprotectionMethodsBySet]], existingRNADeprotectionMethodPositions];
			(*create IDs for fails*)
			newRNADeprotectionMethodIDs = CreateID[ConstantArray[Object[Method, RNADeprotection],Length[missingRNADeprotectionMethodPositions]]];
			(* make search results free of the non-existing RNADeprotectionMethod *)
			existingRNADeprotectionMethodByParameterSetCleaned = First/@DeleteCases[existingRNADeprotectionMethodsBySet,{}];
			(*reassemble*)
			rnaDeprotectionMethodsBySet = SortBy[
				Join[
					Transpose[{existingRNADeprotectionMethodPositions, existingRNADeprotectionMethodByParameterSetCleaned}],
					Transpose[{missingRNADeprotectionMethodPositions, newRNADeprotectionMethodIDs}]
				],First][[All,2]];

			(* Get the rna deprotection method object that we will use for each unique set of rna deprotection parameters. *)
			rnaDeprotectionMethodObjectsBySet = MapThread[Function[{existingMethod, specifiedMethod, deprotectionBool},
				Which[
					(* If we aren't deprotecting, the method is Null *)
					MatchQ[deprotectionBool, False],
					Null,

					(* If a method was specified, use it. (We already validated that the given method agrees with all the other deprotection options.) *)
					MatchQ[specifiedMethod, ObjectP[]],
					Download[specifiedMethod, Object],

					(* If we found an existing method, use it *)
					True,
					existingMethod
				]
			], {rnaDeprotectionMethodsBySet, rnaDeprotectionMethodPacketsBySet, rnaDeprotectionBySet}];


			(* If we couldn't find an existing method for any unique set of cleavage, make one *)
			rnaDeprotectionMethodPacketsToUpload = MapThread[Function[{existingMethod, object, rnaDeprotectionBool, temperature, time, solution, volume, resuspensionVolume, resuspensionTime, resuspensionTemperature, resuspensionSolution, quenchingVolume, quenchingSolution},
				If[TrueQ[rnaDeprotectionBool] && MatchQ[existingMethod, {}],
					<|
						Type -> Object[Method, RNADeprotection],
						Object -> object,
						RNADeprotectionTemperature -> temperature,
						RNADeprotectionTime -> time,
						RNADeprotectionSolution -> Link[solution],
						RNADeprotectionSolutionVolume -> volume,
						RNADeprotectionResuspensionSolutionVolume -> resuspensionVolume,
						RNADeprotectionResuspensionSolution -> Link[resuspensionSolution],
						RNADeprotectionResuspensionTime -> resuspensionTime,
						RNADeprotectionResuspensionTemperature -> resuspensionTemperature,
						RNADeprotectionQuenciongSolution -> Link[quenchingSolution],
						RNADeprotectionQuenchingVolume -> quenchingVolume
					|>,
					Nothing
				]], {existingRNADeprotectionMethodsBySet, rnaDeprotectionMethodObjectsBySet, rnaDeprotectionBySet, rnaDeprotectionTemperatureBySet, rnaDeprotectionTimeBySet, rnaDeprotectionSolutionBySet, rnaDeprotectionSolutionVolumeBySet, rnaDeprotectionResuspensionVolumeBySet, rnaDeprotectionResuspensionTimeBySet, rnaDeprotectionResuspensionTemperatureBySet, rnaDeprotectionResuspensionSolutionBySet, rnaDeprotectionQuenchingSolutionVolumeBySet, rnaDeprotectionQuenchingSolutionBySet}
			];

			(* Get the cleavage methods back to an index matched list to the strands *)
			indexedRNADeprotectionMethodObjects = SortBy[Partition[Flatten[Map[Function[indexesAndMethod, Map[{#, indexesAndMethod[[2]]} &, indexesAndMethod[[1]]]], Transpose[{indexesGroupedByParametersDeprotection, rnaDeprotectionMethodObjectsBySet}]]], 2], First][[All, 2]];

		]
	];
	(* --- Estimate times --- *)

	(* The number of strands that will be synthesized, counting replicates  *)
	numberOfStrands = Length[expandedStrandInputs];

	(* Find the length of each strand *)
	strandLengths = Map[Length[Flatten[#]] &, monomersSansResin];

	(* Find the number of ReagentSets that will be used *)
	maxColumns = Lookup[synthesizerModelPacket, MaxColumns];
	maxReagentSets = Lookup[synthesizerModelPacket, ReagentSets];
	strandPartitionNumber = maxColumns / maxReagentSets;
	numberOfReagentSets = Ceiling[numberOfStrands / strandPartitionNumber];

	(* Calculate the synthesis time estimates. *)
	synthesisTimeEstimate = Module[{longestStrand, volumeTimeConversion, timePerCycle, synthesisTime,
		initialWashTime, finalWashTime, totalTime
	},

		(* Find the length of the longest strand *)
		longestStrand = Max[strandLengths];

		(* Assume that it take this much time per unit volume used - updating this to help times get more realistic.. it might be smarter to grab these from the maintenance, once it is actually working *)
		volumeTimeConversion = ((500 Millisecond) / (1 Microliter));

		(* Estimate the time per cycle. For each step in the cycle, multiply the number of times that step is repeated times the sum of the wait time and the volume converted to time. *)
		timePerCycle = Plus[
			(Lookup[myResolvedOptions, NumberOfDeprotections] * (Lookup[myResolvedOptions, DeprotectionTime] + (Lookup[myResolvedOptions, DeprotectionVolume] * volumeTimeConversion))),
			(Lookup[myResolvedOptions, NumberOfDeprotectionWashes] * (Lookup[myResolvedOptions, DeprotectionWashTime] + (Lookup[myResolvedOptions, DeprotectionWashVolume] * volumeTimeConversion))),
			(Lookup[myResolvedOptions, NumberOfCappings] * (Lookup[myResolvedOptions, CapTime] + (Lookup[myResolvedOptions, CapAVolume] * volumeTimeConversion) + ((Lookup[myResolvedOptions, CapBVolume]) * volumeTimeConversion))),
			(Lookup[myResolvedOptions, NumberOfOxidations] * (Lookup[myResolvedOptions, OxidationTime] + (Lookup[myResolvedOptions, OxidationVolume] * volumeTimeConversion))),
			(Lookup[myResolvedOptions, NumberOfOxidationWashes] * (Lookup[myResolvedOptions, OxidationWashTime] + (Lookup[myResolvedOptions, OxidationWashVolume] * volumeTimeConversion))),
			(60 Second) (*Purge time*)
		];

		(* Calculate the synthesis time as well as the time for the washes at the start end end of the synthesis*)
		synthesisTime = (numberOfReagentSets * longestStrand * timePerCycle);
		initialWashTime = Lookup[myResolvedOptions, NumberOfInitialWashes] * Lookup[myResolvedOptions, InitialWashTime];
		finalWashTime = Lookup[myResolvedOptions, NumberOfFinalWashes] * Lookup[myResolvedOptions, FinalWashTime];

		(* Add all the time estimates together *)
		totalTime = synthesisTime + initialWashTime + finalWashTime;

		(* Return the total estimated time, in hours *)
		N[Convert[totalTime, Hour]]
	];


	(* Calculate the cleavage time estimate. Since the time estimate gets updated whenever there is a subprotocol added
	and since cleavage is mostly made up of subprotocols, start with an estimate of 10min per strand.
	 (Cleavage time includes suspension of non-cleaved strands as well.) *)
	cleavageTimeEstimate = 10Minute * Length[expandedStrandInputs];

	(* Calculate the rnaDeprotection time estimate. Since the time estimate gets updated whenever there is a subprotocol added
	and since cleavage is mostly made up of subprotocols, start with an estimate of 10min per strand. *)
	rnaDeprotectionTimeEstimate = If[MatchQ[myPolymer, RNA],
		10Minute * Length[expandedStrandInputs],
		Null
	];

	(* --- Estimate volumes --- *)

	(* If the number of strands exceeds strandPartitionNumber, split the strands into into multiple reaction sets. Make a list of indexes here to represent how the strands will be partitioned. *)
	strandIndexByReagentSet = If[numberOfStrands > strandPartitionNumber,
		Partition[Range[1, numberOfStrands], UpTo[strandPartitionNumber]],
		{Range[1, numberOfStrands]}];

	(* For each ReagentSet that will be used, the number of cycles (1 cycle per nucleotide) for all the strands in the ReagentSet *)
	numberOfCyclesTotal = Total /@ Unflatten[strandLengths, strandIndexByReagentSet];

	(* For each ReagentSet, the monomers that make up each strand *)
	monomersByStrandByReagentSet = If[Length[strandIndexByReagentSet] == 1,
		{Flatten[monomersSansResin, 1]},
		Unflatten[monomersSansResin, strandIndexByReagentSet]
	];

	(* For each ReagentSet, group all the monomers for all the strands by monomer *)
	groupedMonomers = Gather[Flatten[#]] & /@ monomersByStrandByReagentSet;

	(* For each ReagentSet, the total number of couplings. (Number of couplings for each monomer *  number of times each monomer is used) *)
	numberOfCouplingIterations = Map[Function[monomerSet,
		Total[
			Map[
				FirstCase[Transpose[{uniqueMonomers, numberOfCouplingsByMonomer}], {#[[1]], _}][[2]] * Length[#]&,
				monomerSet]
		]
	], groupedMonomers
	];

	(* total number of oxidation cycles in LC *)
	(* we can get the total number of iterations for secondary oxidation *)
	oxidationVolumePerCycleLC=(Lookup[myResolvedOptions, SecondaryOxidationVolume]) * (Lookup[myResolvedOptions, SecondaryNumberOfOxidations]);
	oxidationVolumeEstimatesLC=Length[DeleteCases[Flatten@expandedSecondaryCyclePositions, Null]] * oxidationVolumePerCycleLC;

	(* Estimate the total volume of CapA that we will need for each ReagentSet:
	Number of cycles * volume of reagent used per cycle + dead and prime volume + 10% extra volume *)
	capAVolumePerCycle = Lookup[myResolvedOptions, CapAVolume] * Lookup[myResolvedOptions, NumberOfCappings];
	capAVolumeEstimates = ((numberOfCyclesTotal * capAVolumePerCycle) + reagentDeadVolume + reagentPrimeVolume) * 1.1;

	(* Estimate the total volume of CapB that we will need for each ReagentSet:
	Number of cycles * volume of reagent used per cycle + dead and prime volume + 10% extra volume *)
	capBVolumePerCycle = Lookup[myResolvedOptions, CapBVolume] * Lookup[myResolvedOptions, NumberOfCappings];
	capBVolumeEstimates = ((numberOfCyclesTotal * capBVolumePerCycle) + reagentDeadVolume + reagentPrimeVolume) * 1.1;

	(* Estimate the total volume of Oxidator that we will need for the UC:
	Number of cycles * volume of reagent used per cycle + dead and prime volume + 10% extra volume *)
	oxidationVolumePerCycle = (Lookup[myResolvedOptions, OxidationVolume]) * (Lookup[myResolvedOptions, NumberOfOxidations]);
	oxidationVolumeEstimates = ((Total[numberOfCyclesTotal] * oxidationVolumePerCycle) + reagentDeadVolume + reagentPrimeVolume) * 1.1 - oxidationVolumeEstimatesLC;

	(* Estimate the total volume of deblock that we will need:
	 There is only one deblock bottle shared across all ReagentSets, so pool the volume used.
	Number of cycles * volume of reagent used per cycle + dead and prime volume + 10% extra volume *)
	deprotectionVolumePerCycle = Lookup[myResolvedOptions, DeprotectionVolume] * Lookup[myResolvedOptions, NumberOfDeprotections];
	deprotectionVolumeEstimate = Total[(((numberOfCyclesTotal * deprotectionVolumePerCycle) + reagentDeadVolume + reagentPrimeVolume) * 1.1)];

	(* Estimate the total volume of wash solution that we will need for each ReagentSet:
	Number of cycles * volume per cycle + initial/final wash volume * number strands + dead and prime volume + 10% extra. *)
	washVolumePerCycle = Lookup[myResolvedOptions, DeprotectionWashVolume] * Lookup[myResolvedOptions, NumberOfDeprotectionWashes] + (Lookup[myResolvedOptions, OxidationWashVolume] * Lookup[myResolvedOptions, NumberOfOxidationWashes]);
	initialAndFinalWashVolumes = (Lookup[myResolvedOptions, InitialWashVolume] * Lookup[myResolvedOptions, NumberOfInitialWashes]) + (Lookup[myResolvedOptions, FinalWashVolume] * Lookup[myResolvedOptions, NumberOfFinalWashes]);
	washVolumeEstimates = ((numberOfCyclesTotal * washVolumePerCycle) + (numberOfStrands * initialAndFinalWashVolumes) + reagentDeadVolume + reagentPrimeVolume) * 1.1;

	(* Estimate the total volume of Activator that we will need for each ReagentSet:
	(note that activator depends on the number of coupling steps, not just the number of cycles)
	Number of couplings * volume of reagent used per coupling + dead and prime volume + 10% extra volume *)
	activatorVolumeEstimates = (((Lookup[myResolvedOptions, ActivatorVolume] * numberOfCouplingIterations) + reagentDeadVolume + reagentPrimeVolume) * 1.1);

	(* re-group monomers to be in 3 groups: Natural bank 1/3, Natural bank 2/4 and Modifications (since they are shared) *)
	sortedMonomers = Join[
		DeleteCases[#,{(Modification[_]|LDNA[_])..}]&/@groupedMonomers,
		{Gather@Flatten[Cases[#, {(Modification[_]|LDNA[_])..}]& /@ groupedMonomers]}
	];

	(* if we are using phosphoramidites with desiccants, we need extra volume to account for the volume desiccants absorb *)
	dessicantPhosphoramiditeLosses = If[TrueQ[Lookup[myResolvedOptions, PhosphoramiditeDesiccants]], Quantity[2., "Milliliters"], Quantity[0., "Milliliters"]];

	(* For each ReagentSet, monomer-volume pairs for each unique monomer *)
	monomerVolumeEstimates = Map[
		Function[monomerSet,
			Map[
				{
					#[[1]],
					((FirstCase[Transpose[{uniqueMonomers, phosphoramiditeVolumeByMonomer}], {#[[1]], _}][[2]] * FirstCase[Transpose[{uniqueMonomers, numberOfCouplingsByMonomer}], {#[[1]], _}][[2]] * Length[#]) + reagentDeadVolume + reagentPrimeVolume) * 1.1 + dessicantPhosphoramiditeLosses
				}&,
				monomerSet
			]
		],
		sortedMonomers
	];

	(* --- Make the resources --- *)

	(* Make a CapA resource for each reaction set *)
	capASolutionResources = MapThread[
		Resource[
			Sample -> #1,
			Amount -> #2,
			RentContainer -> True,
			Name -> ToString[Unique[]]
		]&,
		{Lookup[myResolvedOptions, CapASolution],capAVolumeEstimates}
	];

	(* Make a CapB resource for each reaction set *)
	capBSolutionResources = MapThread[
		Resource[
			Sample -> #1,
			Amount -> #2,
			RentContainer -> True,
			Name -> ToString[Unique[]]
		]&,
		{Lookup[myResolvedOptions, CapBSolution],capBVolumeEstimates}
	];

	(* Make a Oxidizer resource for each reaction set *)
	oxidationSolutionResources={Resource[
		Sample -> Lookup[myResolvedOptions, OxidationSolution],
		Amount -> oxidationVolumeEstimates,
		RentContainer -> True
	]};

	(* Make a Secondary Oxidizer resource if we are doing secondary oxidation *)
	oxidationSolutionResourceLC=If[
		Length[DeleteCases[Flatten@expandedSecondaryCyclePositions, Null]] > 0,
		Resource[
			Sample -> Lookup[myResolvedOptions, SecondaryOxidationSolution],
			Amount -> oxidationVolumeEstimatesLC,
			RentContainer -> True
		],
		Null
	];

	(* Make a Activator resource for each reaction set *)
	activatorSolutionResources = MapThread[
		Resource[
			Sample -> #1,
			Amount -> #2,
			RentContainer -> True,
			Name -> ToString[Unique[]]
		]&,
		{Lookup[myResolvedOptions, ActivatorSolution], activatorVolumeEstimates}
	];

	(* Make a Wash resource for each reaction set.
	Note that we may not end up picking this resource if there is enough already installed on the instrument at run time.
	 If we don't use it, the parser will link the protocol to the actual object used and this resource will be canceled. *)
	washSolutionResources = Map[
		Resource[
			Sample -> Model[Sample, "id:o1k9jAKOw6D4"],
			Amount -> #,
			RentContainer -> True
		]&,
		washVolumeEstimates
	];

	(* Make a single deprotection resource that will be shared across the each reaction sets.
		Note that we may not end up picking this resource if there is enough already installed on the instrument at run time.
	 If we don't use it, the parser will link the protocol to the actual object used and this resource will be canceled. *)
	deprotectionSolutionResource = Resource[
		Sample -> Model[Sample, "id:kEJ9mqaVPPdB"],
		Amount -> deprotectionVolumeEstimate,
		RentContainer -> True,
		Container -> {Model[Container, Vessel, "id:xRO9n3BMrn8q"], Model[Container, Vessel, "id:Vrbp1jG800Zm"]}
	];


	(* Dessicant is used for activator ReagentSet 1/3, activator ReagentSet 2/4, wash ReagentSet 1/3, wash ReagentSet 2/4.
	We don't know until run time if the wash solutions will be replaced, so don't know if all the desiccants will be needed.
	The dessicants for these wash and activator solutions are separate fields, allowing them to be collected independently of each other. *)
	activatorSolutionDesiccantResources = Map[
		Resource[
			Sample -> Model[Item, Consumable, "id:O81aEBZO89nx"],
			Name -> ToString[Unique[]]
		]&,
		activatorVolumeEstimates
	];

	washSolutionDesiccantResources = Map[
		Resource[
			Sample -> Model[Item, Consumable, "id:O81aEBZO89nx"],
			Name -> ToString[Unique[]]
		]&,
		washVolumeEstimates
	];

	(* Get the packet for each column model *)
	columnModelPackets = Map[
		If[MatchQ[#, ObjectP[{Model[Sample], Model[Resin]}]],
			FirstCase[cacheBall, KeyValuePattern[Object -> Download[#, Object]]],
			FirstCase[cacheBall, KeyValuePattern[Object -> Download[Lookup[FirstCase[cacheBall, KeyValuePattern[Object -> Download[#, Object]]], Model], Object]]]
		]&,
		expandedColumns
	];

	(* Convert our list of Model[Sample]s and Model[Resin]s into only Model[Sample]s *)
	convertedColumnModelPacks = If[MatchQ[#, ObjectP[Model[Resin]]],
		FirstCase[cacheBall, AssociationMatchP[<|Object -> Download[Lookup[#, DefaultSampleModel], Object]|>, AllowForeignKeys -> True]],
		#
	]& /@ columnModelPackets;

	(* Get the mass of any columns that were specified as objects  *)
	columnObjectMasses = Map[
		If[MatchQ[#, ObjectP[{Model[Sample], Model[Resin]}]],
			Null,
			Lookup[FirstCase[cacheBall, KeyValuePattern[{Object -> Download[#, Object], Model -> _, Mass -> _}]], Mass]
		]&, expandedColumns];

	(* Pull out the loading on each column *)
	resinLoading = Map[
		Function[{columnPack},
			Module[{resinPercentPairs, resinPercents, resins, allResinLoadings},
				resinPercentPairs = If[
					MatchQ[columnPack, ObjectP[Model[Sample]]],
					Cases[Lookup[columnPack, Composition], {MassPercentP, LinkP[Model[Resin]]}],
					{{100MassPercent, Download[columnPack, Object]}}
				];
				resins = resinPercentPairs[[All, 2]];
				resinPercents = resinPercentPairs[[All, 1]];
				allResinLoadings = Lookup[FirstCase[cacheBall, KeyValuePattern[Object -> Download[#, Object]]], Loading]& /@ resins;
				Total@MapThread[
					Function[{resinLoading, percentContribution},
						resinLoading * (percentContribution / (100MassPercent))
					],
					{allResinLoadings, resinPercents}
				]
			]
		],
		convertedColumnModelPacks
	];

	(* Based on the scale and the loading, calculate the amount of resin needed. Make it so that resource picking doesn't get messed up by excessive precision. *)
	resinsMassNeeded = N[scaleOption / Rationalize[resinLoading]];

	(* Convert the our columns (particulary the Model[Resin] ones) into Model[Sample]s or Object[Sample]s that we can resource pick *)
	columnResourceTargets = If[MatchQ[#, ObjectP[Model[Resin]]],
		Download[
			Lookup[
				FirstCase[cacheBall, AssociationMatchP[<|Object -> Download[#, Object, Cache -> cacheBall], DefaultSampleModel -> _|>, AllowForeignKeys -> True]],
				DefaultSampleModel
			],
			Object
		],
		#
	]& /@ expandedColumns;

	(* Make the column resources. If column was specified as an object, specify that exact amount (we don't want to do a transfer, and we warned the user if the scale was off.) *)
	columnResources = MapThread[
		Resource[
			Sample -> #1,
			Amount -> If[MatchQ[#1, ObjectP[{Model[Sample], Model[Resin]}]], First[ToList[#2]], First[ToList[#3]]],
			RentContainer -> True,
			Container -> Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:zGj91aRlRYXb"] (*Model[Container, ReactionVessel, SolidPhaseSynthesis, "DNA Synthesis Column"]*)
		]&,
		{columnResourceTargets, resinsMassNeeded, columnObjectMasses}
	];
	
	(* A list of unique monomers in each ReagentSet *)
	phosphoramiditesByReagentSet = Map[First, monomerVolumeEstimates, {2}];

	(* A list of phosphoramadite volumes needed for each ReagentSet, index matched to the monomers in the ReagentSet *)
	phosphoramiditeVolumesByReagentSet = Flatten@Map[Last, monomerVolumeEstimates, {2}];

	(* A list of chemical models/samples, index matched to the monomers in the ReagentSet *)
	phosphoramiditeChemicalsByReagentSet = Map[Last[FirstCase[(Lookup[myResolvedOptions, Phosphoramidites]), {#1, _}]]&, phosphoramiditesByReagentSet, {2}];

	(* get the volume we would request - has to match the VolumeIncrments of the StockSolution if it is there *)
	realPhosphoramiditeVolumes = With[{allPAVolumeIncrements = Flatten@phosphoramiditeVolumeIncrements},
		MapThread[Module[{phosphoramiditeModel, phosphoramiditeRequestedVolume, phosphoramiditeVolumeIncrement, phosphoramiditeVolumeIncrementSafe},

			(* get the volume and Model for the phosphoramidite *)
			phosphoramiditeModel = #2;
			phosphoramiditeRequestedVolume = #1;

			(* get the downloaded volume *)
			phosphoramiditeVolumeIncrement = ToList@Lookup[FirstCase[allPAVolumeIncrements, KeyValuePattern[Object->phosphoramiditeModel],<||>],VolumeIncrements,{}];
			phosphoramiditeVolumeIncrementSafe = If[MatchQ[phosphoramiditeVolumeIncrement, {}], Null, First@phosphoramiditeVolumeIncrement];

			(* pick the volume if VolumeIncrements is populated for the StockSolution *)
			If[NullQ[phosphoramiditeVolumeIncrementSafe], phosphoramiditeRequestedVolume, phosphoramiditeVolumeIncrementSafe]
		]&,{phosphoramiditeVolumesByReagentSet,Flatten@phosphoramiditeChemicalsByReagentSet}]];

	(* Do a search for all phosphoramidite bottles with NeckType "PhosphoramiditeVial" which are compatible with the instrument and are lss than a MaxWidth.
		If we get a new bottle, make sure that it works with the tubing adaptors and make sure NeckType -> "PhosphoramiditeVial" *)
	(* this value for max width is based on the largest diameter of the compatible vial we have, which is currently 35 mm + a 5 mm margin *)
	maxWidth = 0.04 Meter;
	allPhosphoramiditeVials = With[
		{
			types = ConstantArray[Model[Container, Vessel], Length[realPhosphoramiditeVolumes]],
			searchConditions=Map[Hold[(NeckType == ("PhosphoramiditeVial" | "ABISeptumCappedVial") && Dimensions[[1]] <= maxWidth && MaxVolume >=#)]&,realPhosphoramiditeVolumes]
		},
		Search[types, Evaluate@searchConditions]
	];

	(* Make a resource for each amidite that will be used in the form {{Monomer, Resource}..} *)
	phosphoramiditeResources = Flatten[
		Unflatten[MapThread[
			{
				#1, (*the monomer*)
				Resource[
					Sample -> #2, (*the model chemical (or sample chemical) to use for that monomer*)
					Container -> #4,
					Amount -> #3, (*the volume needed *)
					RentContainer -> True
				]
			}&,
			Join[Flatten/@{phosphoramiditesByReagentSet, phosphoramiditeChemicalsByReagentSet}, {realPhosphoramiditeVolumes, allPhosphoramiditeVials}]
		], phosphoramiditesByReagentSet],
		1
	];

	(* For each phosphoramidite, build a resource for a mini trap pack to keep the solution dry *)
	phosphoramiditeDesiccants = If[
		TrueQ[Lookup[myResolvedOptions, PhosphoramiditeDesiccants]],
		Link@Table[Resource[Sample->Model[Item, Consumable, "id:wqW9BP7aB7oO"]], Length[phosphoramiditeResources]],
		ConstantArray[Null, Length[phosphoramiditeResources]]];

	(* Make a resource for the synthesizer *)
	synthesizerResource = Resource[
		Instrument -> Lookup[myResolvedOptions, Instrument],
		Time -> synthesisTimeEstimate
	];

	(* Make a resource for the Calcium Gluconate tue *)
	hydrofluoricAcidSafetyAgentResource = Resource[
		Sample ->Model[Item, Consumable, "id:KBL5DvwWVejk"], (* Model[Item, Consumable, "Calcium gluconate gel"] *)
		Rent -> True,
		Name -> CreateUUID[]
	];

	(* We need to resource pick an evaporation instrument prior to cleavage to make sure it's available at the time of cleavage completion
	 Build a resource and table it over every sample that will use it. Currently that's every sample but this may change if we make batching more
	 sophisticated. *)
	expectedEvapInstReservationTime = If[MemberQ[expandedCleavageTime,TimeP],
		Max@Cases[expandedCleavageTime,TimeP] + 6.667Hour, (*Evap method is presently 6.667hours long*)
		6.667Hour (*Evap method is presently 6.667hours long*)
	];

	expandedEvapResource = Resource[
		Instrument -> Model[Instrument,VacuumCentrifuge, "id:n0k9mGzRal4w"],
		Time -> expectedEvapInstReservationTime,
		Name -> ToString[CreateUUID[]]
	];
	expandedEvapInsts = Table[Link[expandedEvapResource],Length[expandedCleavageMethod]];

	(* Make a tube resource for every strand.
	This will be the final container for strands that are not being cleaved, so set Rent->False for those cases.
	Strands that are being cleaved will be transferred to a centrifuge filter, so set Rent->True for those cases. *)
	resinContainerResources = Map[
		Resource[
			Sample -> Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*Model[Container, Vessel, "2mL Tube"]*)
			Rent -> #
		]&, expandedCleavage
	];

	(* Make a filter resource for every cleaved strand *)
	centrifugeFilterResources = ConstantArray[
		Resource[
			Sample -> Model[Container, Vessel, Filter, "id:R8e1PjpBwDod"]
		], Length[Cases[expandedCleavage, True]]
	];

	(* --- Generate our protocol packet --- *)

	(* filter out resolved options so we output only relevant ones for DNA *)
	resolvedOptionsOutput =If[MatchQ[myPolymer, RNA],
		resolvedOptionsNoHidden,
		Cases[resolvedOptionsNoHidden,
			_?(StringMatchQ[ToString[#[[1]]], Alternatives[Options[ExperimentDNASynthesis][[All, 1]]]] &)]
	];

	(* == Add add reserving cleavage instrument == *)
	(* We need to resource pick a cleavage instrument prior to cleavage to make sure it's available at the time of cleavage and we can pre-heat it
	 Build a resource and table it over every sample that will use it. we have to run IncubationDevice one for each batch to make sure that we can do  *)

	(* we need to get cleavage batch length and temperatures in order to get cleavage devices *)
	groupedCleavageParameters = GatherBy[
		Transpose[
			{
				PickList[expandedCleavageTemperature, expandedCleavage], PickList[expandedCleavageTime, expandedCleavage]
			}],
		#[[{1, 2}]] &];

	cleavageBatchLengths = Length/@groupedCleavageParameters;

	(* make simulated sample so we can select a proper IncubationDevice *)
	simulatedForCleavage = SimulateSample[
		{Object[Sample, "id:jLq9jXYBoVl1"]},
		"sample for IncubationDevices for nucleic acid synthesis",
		{"A1"},
		Model[Container, Vessel, Filter, "id:R8e1PjpBwDod"], (* filter tube, 15mL tbe footprint *)
		{Volume -> 800 Microliter}];

	(* grab a list of instruments that can be used for the incubation *)
	(* we are using one instrument but checking the temperature once for every batch that we have *)
	incubationInstrumentsPerBatch = Map[IncubateDevices[First@Lookup[First@simulatedForCleavage, Object], Temperature->#, Cache->Flatten[simulatedForCleavage]]&, #[[1, 1]] & /@ groupedCleavageParameters];

	(* expand the incubation instrument to the full length of the samples *)
	incubationInstrumentResourcePerBatch = MapThread[Resource[
		Instrument -> #1,
		Time -> #2 + 3 Hour, (* overhead for SM calls in the cleavage *)
		Name -> ToString[Unique[]]
	]&,{incubationInstrumentsPerBatch, #[[1, 2]] & /@ groupedCleavageParameters}];

	(* expand the incubation instrument to the full length of the samples being cleaved *)
	expandedCleavageInstruments = Flatten@MapThread[Table[Link[#1], #2]&,{incubationInstrumentResourcePerBatch, cleavageBatchLengths}];

	expandedDeprotectionInstruments=If[MatchQ[myPolymer, RNA],
		Module[{
			groupedDeprotectionParameters, deprotectionBatchLengths, simulatedForDeprotection, incubationInstrumentsPerBatchDeprotection,
			incubationInstrumentResourcePerBatchDeprotection},
			(* == Add add reserving deprotection instrument == *)
			(* We need to resource pick a deprotection instrument prior to deprotection to make sure it's available at the time of deprotection and we can pre-heat it
			 Build a resource and table it over every sample that will use it. we have to run IncubationDevice one for each batch to make sure that we can do  *)

			(* we need to get deprotection batch length and temperatures in order to get deprotection devices *)
			groupedDeprotectionParameters = GatherBy[
				Transpose[
					{
						PickList[expandedRNADeprotectionTemperature, expandedRNADeprotection], PickList[expandedRNADeprotectionTime, expandedRNADeprotection]
					}],
				#[[{1, 2}]] &];

			deprotectionBatchLengths = Length/@groupedDeprotectionParameters;

			(* make simulated sample so we can select a proper IncubationDevice *)
			simulatedForDeprotection = SimulateSample[
				{Object[Sample, "id:jLq9jXYBoVl1"]},
				"sample for IncubationDevices for nucleic acid synthesis",
				{"A1"},
				Model[Container, Vessel, "id:3em6Zv9NjjN8"], (* 2mL tube *)
				{Volume -> 800 Microliter}];

			(* grab a list of instruments that can be used for the incubation *)
			(* we are using one instrument but checking the temperature once for every batch that we have *)
			incubationInstrumentsPerBatchDeprotection = Map[IncubateDevices[First@Lookup[First@simulatedForDeprotection, Object], Temperature->#, Cache->Flatten[simulatedForDeprotection]]&, #[[1, 1]] & /@ groupedDeprotectionParameters];

			(* expand the incubation instrument to the full length of the samples *)
			incubationInstrumentResourcePerBatchDeprotection = MapThread[Resource[
				Instrument -> #1,
				Time -> #2 + 3 Hour, (* overhead for SM calls in the deprotection *)
				Name -> ToString[Unique[]]
			]&,{incubationInstrumentsPerBatchDeprotection, #[[1, 2]] & /@ groupedDeprotectionParameters}];

			(* expand the incubation instrument to the full length of the samples being cleaved *)
			Flatten@MapThread[Table[Link[#1], #2]&,{incubationInstrumentResourcePerBatchDeprotection, deprotectionBatchLengths}]
		],
		{}
	];

	(* fill in the protocol packet with all the resources *)
	protocolPacket = Join[Sequence @@ {<|
		Type -> If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]],
		Object -> CreateID[If[MatchQ[myPolymer, RNA],Object[Protocol, RNASynthesis], Object[Protocol, DNASynthesis]]],
		Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsOutput,

		Replace[Strands] -> strands,
		Replace[StrandModels] -> Link[expandedStrandInputs],
		Scale -> Lookup[myResolvedOptions, Scale],
		Replace[FinalSequences] -> Link[Lookup[optionsWithReplicates, FinalSequences]],
		NumberOfInitialWashes -> Lookup[myResolvedOptions, NumberOfInitialWashes],
		InitialWashTime -> Lookup[myResolvedOptions, InitialWashTime],
		InitialWashVolume -> Lookup[myResolvedOptions, InitialWashVolume],
		NumberOfFinalWashes -> Lookup[myResolvedOptions, NumberOfFinalWashes],
		FinalWashTime -> Lookup[myResolvedOptions, FinalWashTime],
		FinalWashVolume -> Lookup[myResolvedOptions, FinalWashVolume],
		NumberOfDeprotections -> Lookup[myResolvedOptions, NumberOfDeprotections],
		DeprotectionTime -> Lookup[myResolvedOptions, DeprotectionTime],
		DeprotectionVolume -> Lookup[myResolvedOptions, DeprotectionVolume],
		NumberOfDeprotectionWashes -> Lookup[myResolvedOptions, NumberOfDeprotectionWashes],
		DeprotectionWashTime -> Lookup[myResolvedOptions, DeprotectionWashTime],
		DeprotectionWashVolume -> Lookup[myResolvedOptions, DeprotectionWashVolume],
		ActivatorVolume -> Lookup[myResolvedOptions, ActivatorVolume],
		NumberOfCappings -> Lookup[myResolvedOptions, NumberOfCappings],
		CapTime -> Lookup[myResolvedOptions, CapTime],
		CapAVolume -> Lookup[myResolvedOptions, CapAVolume],
		CapBVolume -> Lookup[myResolvedOptions, CapBVolume],
		NumberOfOxidations -> Lookup[myResolvedOptions, NumberOfOxidations],
		OxidationTime -> Lookup[myResolvedOptions, OxidationTime],
		OxidationVolume -> Lookup[myResolvedOptions, OxidationVolume],
		NumberOfOxidationWashes -> Lookup[myResolvedOptions, NumberOfOxidationWashes],
		OxidationWashTime -> Lookup[myResolvedOptions, OxidationWashTime],
		OxidationWashVolume -> Lookup[myResolvedOptions, OxidationWashVolume],
		SecondaryNumberOfOxidations -> Lookup[myResolvedOptions, SecondaryNumberOfOxidations],
		SecondaryOxidationTime -> Lookup[myResolvedOptions, SecondaryOxidationTime],
		SecondaryOxidationVolume -> Lookup[myResolvedOptions, SecondaryOxidationVolume],
		SecondaryNumberOfOxidationWashes -> Lookup[myResolvedOptions, SecondaryNumberOfOxidationWashes],
		SecondaryOxidationWashTime -> Lookup[myResolvedOptions, SecondaryOxidationWashTime],
		SecondaryOxidationWashVolume -> Lookup[myResolvedOptions, SecondaryOxidationWashVolume],
		Replace[FinalDeprotection] -> expandedFinalDeprotection,
		Replace[Cleavage] -> expandedCleavage,
		Replace[CleavageTimes] -> expandedCleavageTime,
		Replace[CleavageTemperatures] -> expandedCleavageTemperature,
		Replace[CleavageSolutionVolumes] -> expandedCleavageSolutionVolume,
		Replace[StorageSolventVolumes] -> expandedStorageSolventVolume,
		Replace[CleavageWashVolumes] -> expandedCleavageWashVolume,
		Replace[EvaporationInstruments] -> expandedEvapInsts,
		Replace[CleavageIncubationInstruments] -> expandedCleavageInstruments,

		(*Since there is no sample prep, we don't call populateSamplePrepFields, so we need to populate postprocessing on our own*)
		ImageSample -> Lookup[myResolvedOptions, ImageSample],
		MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
		MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],

		Replace[WashSolutionVolumeEstimate] -> washVolumeEstimates,
		DeblockSolutionVolumeEstimate -> deprotectionVolumeEstimate,
		EstimatedSynthesisTime -> synthesisTimeEstimate,

		Instrument -> Link[synthesizerResource],
		Replace[Columns] -> Map[Link[#]&, columnResources],
		SynthesizerWashSolution -> Link[Model[Sample, "id:o1k9jAKOw6D4"]], (* This is what the synthesizer will be washed with post-synthesis. We don't make a resource because sample manipulation will make one. If we made one, we would have to pick it way in advance of when it would be needed. *)
		Replace[WashSolution] -> Link /@ washSolutionResources, (* This is what the columns are washed with during the synthesis. *)
		Replace[WashSolutionDesiccants] -> Link /@ washSolutionDesiccantResources,
		DeprotectionSolution -> Link[deprotectionSolutionResource],
		Replace[ActivatorSolution] -> Link /@ activatorSolutionResources,
		Replace[ActivatorSolutionDesiccants] -> Link /@ activatorSolutionDesiccantResources,
		Replace[Phosphoramidites] -> Map[{#[[1]], Link[#[[2]]]} &, phosphoramiditeResources],
		Replace[PhosphoramiditeDesiccants] -> phosphoramiditeDesiccants,
		Replace[CapASolution] -> Link /@ capASolutionResources,
		Replace[CapBSolution] -> Link /@ capBSolutionResources,
		Replace[OxidationSolution] -> Link /@ oxidationSolutionResources,
		SecondaryOxidationSolution -> Link[oxidationSolutionResourceLC],
		Replace[SecondaryCyclePositions] -> (expandedSecondaryCyclePositions/.{{Null..}->{}}),

		Replace[ResinContainers] -> Link /@ resinContainerResources,
		Replace[Filters] -> Link /@ centrifugeFilterResources,
		Replace[CleavageSolutions] -> Link[Lookup[myResolvedOptions, CleavageSolution]],
		Replace[CleavageWashSolutions] -> Link[expandedCleavageWashSolution],
		Replace[StorageSolvents] -> Link[expandedStorageSolvent],
		Replace[CleavageMethods] -> Link[indexedCleavageMethodObjects],
		Replace[SynthesisCycles] -> monomerCyclePairs,

		Replace[ActivatorSolutionStorageConditions]->Link /@ Lookup[myResolvedOptions, ActivatorSolutionStorageCondition],
		Replace[CapASolutionStorageConditions]->Link /@ Lookup[myResolvedOptions, CapASolutionStorageCondition],
		Replace[CapBSolutionStorageConditions]->Link /@ Lookup[myResolvedOptions, CapBSolutionStorageCondition],
		Replace[OxidationSolutionStorageConditions]->Link @ Lookup[myResolvedOptions, OxidationSolutionStorageCondition],
		Replace[SecondaryOxidationSolutionStorageConditions]->Link @ Lookup[myResolvedOptions, SecondaryOxidationSolutionStorageCondition],

		Replace[Checkpoints] -> {
			{"Picking Resources", 1 Hour, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 1 Hour]]},
			{"Preparing Synthesizer", 4 Hour, "All required samples are placed on the synthesizer deck.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 4 Hour]]},
			{"Synthesizing", synthesisTimeEstimate, "DNA oligomers are synthesized.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> synthesisTimeEstimate]]},
			{"Collecting Samples", 0.5 Hour, "Synthesized oligomers are collected from the synthesizer.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 0.5 Hour]]},
			{"Cleaning Synthesizer", 2 Hour, "The synthesizer instrument is cleaned.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 2 Hour]]},
			{"Cleaving Strands", cleavageTimeEstimate, "The synthesized oligomers are cleaved from the solid supports.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> cleavageTimeEstimate]]},
			(* add RNA-specific checkpoints *)
			If[MatchQ[myPolymer, RNA],
				Sequence@@{If[AnyTrue[expandedPostCleavageDesalting, TrueQ], {"Desalting cleaved strands", 1 Hour, "The cleaved oligomers are being desalted.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 2 Hour]]}, Nothing],
					{"Removing 2-OH protection", rnaDeprotectionTimeEstimate, "The protection group of the 2-OH group is being removed from the cleaved oligomers.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> rnaDeprotectionTimeEstimate]]},
					If[AnyTrue[expandedPostRNADeprotectionDesalting, TrueQ], {"Desalting deprotected strands", 1 Hour, "The deprotected oligomers are being desalted.", Link[Resource[Operator -> Model[User, Emerald, Operator, "id:n0k9mG8PA8B6"](*Level 3*), Time -> 2 Hour]]}, Nothing]},
				Nothing
			]
		}
	|>,

		(* if we are working with RNA, add RNA options to the upload packet *)
		If[MatchQ[myPolymer, RNA], <|
			Replace[RNADeprotectionIncubationInstruments] -> expandedDeprotectionInstruments,
			Replace[PostCleavageDesalting] -> expandedPostCleavageDesalting,
			Replace[RNADeprotectionMethods] -> Link[indexedRNADeprotectionMethodObjects],
			Replace[RNADeprotectionSolutions] -> Link[Lookup[myResolvedOptions, RNADeprotectionSolution]],
			Replace[RNADeprotectionResuspensionSolutions] -> Link[Lookup[myResolvedOptions, RNADeprotectionResuspensionSolution]],
			Replace[RNADeprotectionQuenchingSolutions] -> Link[Lookup[myResolvedOptions, RNADeprotectionQuenchingSolution]],
			Replace[RNADeprotection] -> expandedRNADeprotection,
			Replace[RNADeprotectionTimes] -> expandedRNADeprotectionTime,
			Replace[RNADeprotectionTemperatures] -> expandedRNADeprotectionTemperature,
			Replace[RNADeprotectionSolutionVolumes] -> expandedRNADeprotectionSolutionVolume,
			Replace[RNADeprotectionResuspensionSolutionVolumes] -> expandedRNADeprotectionResuspensionVolume,
			Replace[RNADeprotectionResuspensionTimes] -> expandedRNADeprotectionResuspensionTime,
			Replace[RNADeprotectionResuspensionTemperatures] -> expandedRNADeprotectionResuspensionTemperature,
			Replace[RNADeprotectionQuenchingSolutionVolumes] -> expandedRNADeprotectionQuenchingSolutionVolume,
			Replace[PostCleavageEvaporation] -> expandedPostCleavageEvaporation,
			Replace[PostRNADeprotectionEvaporation] -> expandedPostRNADeprotectionEvaporation,
			Replace[PostRNADeprotectionDesalting] -> expandedPostRNADeprotectionDesalting,
			HydrofluoricAcidSafetyAgent -> Link[hydrofluoricAcidSafetyAgentResource]
		|>, Nothing],

		(* if we are doing desalting, add relevant options to the packet *)
		If[AnyTrue[expandedPostCleavageDesalting, TrueQ],
			<|
				PostCleavageDesaltingInstrument -> Link[First[ToList[expandedPostCleavageDesaltingInstrument]]],
				PostCleavageDesaltingPreFlushBuffer -> Link[First[ToList[expandedPostCleavageDesaltingPreFlushBuffer]]],
				PostCleavageDesaltingEquilibrationBuffer -> Link[First[ToList[expandedPostCleavageDesaltingEquilibrationBuffer]]],
				PostCleavageDesaltingWashBuffer -> Link[First[ToList[expandedPostCleavageDesaltingWashBuffer]]],
				PostCleavageDesaltingElutionBuffer -> Link[First[ToList[expandedPostCleavageDesaltingElutionBuffer]]],
				Replace[PostCleavageDesaltingSampleLoadRates] -> Flatten[expandedPostCleavageDesaltingSampleLoadRates],
				Replace[PostCleavageDesaltingRinseAndReloads] -> Flatten[expandedPostCleavageDesaltingRinseAndReloads],
				Replace[PostCleavageDesaltingRinseVolumes] -> Flatten[expandedPostCleavageDesaltingRinseAndReloadVolumes],
				Replace[PostCleavageDesaltingType] -> Flatten[expandedPostCleavageDesaltingType],
				Replace[PostCleavageDesaltingCartridges] -> Link[Flatten[expandedPostCleavageDesaltingCartridges]],
				Replace[PostCleavageDesaltingPreFlushVolumes] -> Flatten[expandedPostCleavageDesaltingPreFlushVolumes],
				Replace[PostCleavageDesaltingPreFlushRates] -> Flatten[expandedPostCleavageDesaltingPreFlushRates],
				Replace[PostCleavageDesaltingEquilibrationVolumes] -> Flatten[expandedPostCleavageDesaltingEquilibrationVolumes],
				Replace[PostCleavageDesaltingEquilibrationRates] -> Flatten[expandedPostCleavageDesaltingEquilibrationRates],
				Replace[PostCleavageDesaltingElutionVolumes] -> Flatten[expandedPostCleavageDesaltingElutionVolumes],
				Replace[PostCleavageDesaltingElutionRates] -> Flatten[expandedPostCleavageDesaltingElutionRates],
				Replace[PostCleavageDesaltingWashVolumes] -> Flatten[expandedPostCleavageDesaltingWashVolumes],
				Replace[PostCleavageDesaltingWashRates] -> Flatten[expandedPostCleavageDesaltingWashRates]
			|>, Nothing],

		If[AnyTrue[expandedPostRNADeprotectionDesalting, TrueQ],
			<|
				PostRNADeprotectionDesaltingInstrument -> Link[First[ToList[expandedPostRNADeprotectionDesaltingInstrument]]],
				PostRNADeprotectionDesaltingPreFlushBuffer -> Link[First[ToList[expandedPostRNADeprotectionDesaltingPreFlushBuffer]]],
				PostRNADeprotectionDesaltingEquilibrationBuffer -> Link[First[ToList[expandedPostRNADeprotectionDesaltingEquilibrationBuffer]]],
				PostRNADeprotectionDesaltingWashBuffer -> Link[First[ToList[expandedPostRNADeprotectionDesaltingWashBuffer]]],
				PostRNADeprotectionDesaltingElutionBuffer -> Link[First[ToList[expandedPostRNADeprotectionDesaltingElutionBuffer]]],
				Replace[PostRNADeprotectionDesaltingSampleLoadRates] -> Flatten[expandedPostRNADeprotectionDesaltingSampleLoadRates],
				Replace[PostRNADeprotectionDesaltingRinseAndReloads] -> Flatten[expandedPostRNADeprotectionDesaltingRinseAndReloads],
				Replace[PostRNADeprotectionDesaltingRinseVolumes] -> Flatten[expandedPostRNADeprotectionDesaltingRinseAndReloadVolumes],
				Replace[PostRNADeprotectionDesaltingType] -> Flatten[expandedPostRNADeprotectionDesaltingType],
				Replace[PostRNADeprotectionDesaltingCartridges] -> Link[Flatten[expandedPostRNADeprotectionDesaltingCartridges]],
				Replace[PostRNADeprotectionDesaltingPreFlushVolumes] -> Flatten[expandedPostRNADeprotectionDesaltingPreFlushVolumes],
				Replace[PostRNADeprotectionDesaltingPreFlushRates] -> Flatten[expandedPostRNADeprotectionDesaltingPreFlushRates],
				Replace[PostRNADeprotectionDesaltingEquilibrationVolumes] -> Flatten[expandedPostRNADeprotectionDesaltingEquilibrationVolumes],
				Replace[PostRNADeprotectionDesaltingEquilibrationRates] -> Flatten[expandedPostRNADeprotectionDesaltingEquilibrationRates],
				Replace[PostRNADeprotectionDesaltingElutionVolumes] -> Flatten[expandedPostRNADeprotectionDesaltingElutionVolumes],
				Replace[PostRNADeprotectionDesaltingElutionRates] -> Flatten[expandedPostRNADeprotectionDesaltingElutionRates],
				Replace[PostRNADeprotectionDesaltingWashVolumes] -> Flatten[expandedPostRNADeprotectionDesaltingWashVolumes],
				Replace[PostRNADeprotectionDesaltingWashRates] -> Flatten[expandedPostRNADeprotectionDesaltingWashRates]
			|>, Nothing]

	}];



	(* --- fulfillableResourceQ --- *)

	(* get all the resource blobs*)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = If[gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->cacheBall],
		{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->cacheBall], Null}
	];

	(* --- Output --- *)

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		Flatten[{synthesisCyclePacketsToUpload, cleavageMethodPacketsToUpload, protocolPacket}],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}

];
