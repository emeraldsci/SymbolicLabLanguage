(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*KineticRates: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Rates*)


(* ::Subsubsection:: *)
(*KineticRates*)


DefineTests[
	KineticRates,
	{
		Example[{Basic,"Calculate kinetic rate for a 5p toehold-mediated strand exchange rate:"},
			KineticRates[Reaction[{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAATTT"]]}, {}]}, {Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 6}, {2, 4 ;; 9}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAAAATTTTT"]]}, {}]}, ToeholdMediatedStrandExchange]],
			Reaction[{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAATTT"]]}, {}]}, {Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 6}, {2, 4 ;; 9}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAAAATTTTT"]]}, {}]}, Quantity[237.32028840340152, 1/("Molar"*"Seconds")]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Basic,"Calculate kinetic rate for a folding reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {}]},
				{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
				Folding]],
			Reaction[{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]}, Quantity[14000., "Seconds"^(-1)]]
		],
		Example[{Basic,"Calculate kinetic rate for a hybridization reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;3}, {2, 7;;9}]}]},
				{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 2;;4}, {3, 6;;8}]}]},
				Hybridization
			]],
			Reaction[{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}]}]}, {Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}], Bond[{2, 2 ;; 4}, {3, 6 ;; 8}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")]]
		],
		Example[{Basic,"The function can take in reversible reaction and fill in kinetic rates for both directions:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 14 ;; 19}, {2, 1, 14 ;; 19}]}]},
				Hybridization, Dissociation
			]],
			Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")], Quantity[63.446096977555214, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Basic,"The function can take in reversible reaction and fill in kinetic rates for both directions:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 1, 8 ;; 11}, {1, 1, 17 ;; 20}]}]},
				Folding, Melting
			]],
			Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {Bond[{1, 8 ;; 11}, {1, 17 ;; 20}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[994.3911334535436, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		(** TODO: Generate better kinetics model once we have better data **)
		Example[{Options,KineticsModel,"Using a KineticsModel instead of the Kinetics field available in the public oligomer model:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]},
				{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{Bond[{1,4;;6},{1,11;;13}]}]},
				Folding],
			FoldingRate->(10^3*(NumberOfBonds[#[Products][[1]]] - NumberOfBonds[#[Reactants][[1]]])&),KineticsModel->Model[Physics,Kinetics,"DNA"]],
			Reaction[{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {}]}, {Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]}, Quantity[3000, "Seconds"^(-1)]]
		],
		Example[{Options,FoldingRate,"Instead of the default constant rate, the folding rate could also be a pure function of the input reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]},
				{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{Bond[{1,4;;6},{1,11;;13}]}]},
				Folding],
			FoldingRate->(10^3*(NumberOfBonds[#[Products][[1]]] - NumberOfBonds[#[Reactants][[1]]])&)],
			Reaction[{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {}]}, {Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]}, Quantity[3000, "Seconds"^(-1)]]
		],
		Example[{Options,HybridizationRate,"Instead of the default constant rate, the hybridization rate could also be a pure function of the input reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]},
				{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 5 ;; 7}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]},
				Hybridization],
			HybridizationRate->(10^4*(Total[NumberOfBonds[#[Products]]] -Total[ NumberOfBonds[#[Reactants]]])&)],
			Reaction[{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 4 ;; 6}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 4 ;; 6}, {2, 1 ;; 3}]}]}, {Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 5 ;; 7}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]}, Quantity[30000, 1/("Molar"*"Seconds")]]
		],
		Example[{Options,EquilibriumConstantFunction,"For reversible reactions, the Equilibrium Constant is need to be computed in detailed balance method, this option is defaulted to call SimulateEquilibriumConstant, or it can be input as a pure function of the reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]},
				{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]},
				Dissociation],
			EquilibriumConstantFunction->((Total[NumberOfBonds[#[Reactants]]] -Total[ NumberOfBonds[#[Products]]])&)
			],
			Reaction[{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]}, {Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 4 ;; 6}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 4 ;; 6}, {2, 1 ;; 3}]}]}, Quantity[1.050000000000002*^6, "Seconds"^(-1)]]
		],
		Example[{Options,Temperature,"Specify temperature for dissociation rate:"},
			KineticRates[
				Reaction[
						{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
						{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
						Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
						Dissociation
				],
				Temperature->75Celsius
			],
			Reaction[{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]}, {Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {}]}, Quantity[161.35015390799342, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Options,MonovalentSaltConcentration,"Specify the monovalent salt concentration in the pure function:"},
			KineticRates[Reaction[
					{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AAAAAAA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTTTTTCCCGGCCGG"]]}, {Bond[{1, 1, 1 ;; 3}, {2, 3, 1 ;; 3}], Bond[{1, 2, 1 ;; 6}, {2, 2, 1 ;; 6}], Bond[{1, 3, 1 ;; 2}, {2, 1, 1 ;; 2}]}]},
					{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AAAAAAA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTTTTTCCCGGCCGG"]]}, {}]},
					Dissociation],
				MonovalentSaltConcentration->0.5Molar],
			Reaction[{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AAAAAAA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTTTTTCCCGGCCGG"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]}, {Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AAAAAAA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTTTTTCCCGGCCGG"]]}, {}]}, Quantity[0.00023043484512934648, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Options,DivalentSaltConcentration,"Specify the divalent salt concentration in the pure function:"},
			KineticRates[Reaction[
					{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,5;;7},{1,16;;18}]}]},
					{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{}]},
					Melting],
				DivalentSaltConcentration->0.1Molar],
			Reaction[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {}]}, Quantity[10454.228714943833, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Options,BufferModel,"Specify buffer for calculating zipping kinetic rate:"},
			KineticRates[
				Reaction[
					{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1, 1 ;; 4}, {1, 3, 2 ;; 5}]}]},
					{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {}]},
					Melting],
				BufferModel->Model[Sample,StockSolution,"1X UV buffer"]
			],
			Reaction[{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]}, {Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {}]}, Quantity[47423.646544673116, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Messages,"UnrecognizedRateType","The reaction types `Unchanged` and `Unknown` are unrecognized for calculating a rate:"},
			KineticRates[Reaction[{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}]}, {Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}]}, Unchanged]],
			$Failed,
			Messages:>{KineticRates::UnrecognizedRateType}
		],
		Example[{Messages,"UnmatchingReaction","The input reaction does not match the given reaction type:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
				Melting
			]],
			$Failed,
			Messages:>{KineticRates::UnmatchingReaction}
		],
		Example[{Messages,"LowConcentration","The input salt concentration is too low (<10 nano molar) for the equation to accurately predict. Please increase the corresponding salt concentration to be greater than 10 nano molar:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1, 1 ;; 3}, {2, 3, 1 ;; 3}], Bond[{1, 2, 1 ;; 6}, {2, 2, 1 ;; 6}], Bond[{1, 3, 1 ;; 2}, {2, 1, 1 ;; 2}]}]},
				Hybridization, Dissociation],
				MonovalentSaltConcentration->10^-9 Molar
			],
			$Failed,
			Messages:>{KineticRates::LowConcentration}
		],
		Example[{Messages,"Extrapolated","For hybridization reactions, when monovalent salt concentration is below 0.25 Molar, reaction starts becoming more stringent as only perfectly matched hybrids will be stable thus it can hardly carried out, but the rate is extrapolated and a warning is thrown:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				Hybridization],
				MonovalentSaltConcentration->0.1 Molar
			],
			Reaction[{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]]}, {}], Structure[{Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {}]}, {Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]}, Quantity[35241.56150893461, 1/("Molar"*"Seconds")]],
			Messages:>{KineticRates::Extrapolated}
		],
		Example[{Messages,"SwitchedKineticsModel","Warning is thrown if other than DNA is used:"},
			KineticRates[Reaction[
				{Structure[{Strand[PNA["ACGTACGTACGT"]]}, {}]},
				{Structure[{Strand[PNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
				Folding]],
			Reaction[{Structure[{Strand[PNA["ACGTACGTACGT"]]}, {}]}, {Structure[{Strand[PNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]}, Quantity[14000., "Seconds"^(-1)]],
			Messages:>{Warning::SwitchedKineticsModel}
		],

		(*
			ADDITIONAL
		*)
		Example[{Additional,"Zipping","Calculate forward rate for a Zipping reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]}, {Bond[{1, 4 ;; 5}, {2, 7 ;; 8}]}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]},    {Bond[{1, 4 ;; 9}, {2, 3 ;; 8}]}]},
				Zipping
			]],
			Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]}, {Bond[{1, 4 ;; 5}, {2, 7 ;; 8}]}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]},    {Bond[{1, 4 ;; 9}, {2, 3 ;; 8}]}]},
				8000000/Second
			]
		],
		Example[{Additional,"Unzipping","Calculate forward rate for a Unzipping reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]},   {Bond[{1, 4 ;; 9}, {2, 3 ;; 8}]}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]}, {Bond[{1, 4 ;; 5}, {2, 7 ;; 8}]}]},
				Unzipping
			]],
			Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]},   {Bond[{1, 4 ;; 9}, {2, 3 ;; 8}]}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["AAGG"], DNA["GG"], DNA["GGAA"]]}, {Bond[{1, 4 ;; 5}, {2, 7 ;; 8}]}]},
				Quantity[52.10810799607288, "Seconds"^(-1)]
			],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Additional,"Folding","Calculate forward rate for a Folding reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]},
				Folding
			]],
			Reaction[
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]},
				Quantity[14000., "Seconds"^(-1)]
			]
		],
		Example[{Additional,"Melting","Calculate forward rate for a Melting reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]},
				{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
				Melting
			]],
			Reaction[{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]}, {Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {}]}, Quantity[47423.646544673116, "Seconds"^(-1)]],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Additional,"Hybridization","Calculate forward rate for a Hybridization reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				Hybridization
			]],
			Reaction[
				{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				Quantity[350000.0000000007, 1/("Molar"*"Seconds")]
			]
		],
		Example[{Additional,"Dissociation","Calculate forward rate for a Dissociation reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
				Dissociation
			]],
			Reaction[
				{Structure[{Strand[DNA["AAA"], DNA["CCCCCC"], DNA["AA"]], Strand[DNA["TT"], DNA["GGGGGG"], DNA["TTT"]]}, {Bond[{1, 1 ;; 11}, {2, 1 ;; 11}]}]},
				{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
				Quantity[0.00023043484512934648, "Seconds"^(-1)]
			],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Additional,"StrandInvasion","Calculate forward rate for a sequential displacement pathway based (second-order) StrandInvasion reaction:"},
			KineticRates[Reaction[
			{
				Structure[{Strand[DNA["CCCCCA"]]}, {}],
				Structure[{Strand[DNA["CCCCC"]],Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]
			},
			{
				Structure[{Strand[DNA["CCCCC"]]}, {}],
				Structure[{Strand[DNA["CCCCCA"]],Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]
			},
			StrandInvasion
		]],
			Reaction[{Structure[{Strand[DNA["CCCCCA"]]}, {}], Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]}, {Structure[{Strand[DNA["CCCCC"]]}, {}], Structure[{Strand[DNA["CCCCCA"]], Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]}, Quantity[7.052316164697305, 1/("Molar"*"Seconds")]]
		],
		Example[{Additional,"StrandInvasion","Calculate forward rate for a dissociative pathway based (first-order) StrandInvasion reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAAAAAAATTTTTAAAAAAAA"]],Strand[DNA["TTTTTTTTC"]],Strand[DNA["TTTTTTTTG"]]},{Bond[{1,1;;8},{2,1;;8}],Bond[{1,14;;21},{3,1;;8}]}]},
				{Structure[{Strand[DNA["AAAAAAAATTTTTAAAAAAAA"]],Strand[DNA["TTTTTTTTG"]],Strand[DNA["TTTTTTTTC"]]},{Bond[{1,1;;8},{2,1;;8}],Bond[{1,14;;21},{3,1;;8}]}]},
				StrandInvasion
			]],
			Reaction[{Structure[{Strand[DNA["AAAAAAAATTTTTAAAAAAAA"]], Strand[DNA["TTTTTTTTC"]], Strand[DNA["TTTTTTTTG"]]}, {Bond[{1, 1 ;; 8}, {2, 1 ;; 8}], Bond[{1, 14 ;; 21}, {3, 1 ;; 8}]}]}, {Structure[{Strand[DNA["AAAAAAAATTTTTAAAAAAAA"]], Strand[DNA["TTTTTTTTG"]], Strand[DNA["TTTTTTTTC"]]}, {Bond[{1, 1 ;; 8}, {2, 1 ;; 8}], Bond[{1, 14 ;; 21}, {3, 1 ;; 8}]}]}, Quantity[0.06653688058177594, "Seconds"^(-1)]]
		],
		Example[{Additional,"ToeholdMediatedDuplexExchange","Calculate forward rate for a ToeholdMediatedDuplexExchange reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTTAAAA"]]}, {Bond[{1, 7 ;; 11}, {2, 1 ;; 5}], Bond[{3, 5 ;; 8}, {4, 1 ;; 4}], Bond[{2, 6 ;; 9}, {3, 1 ;; 4}]}]},
				{Structure[{Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTTTAAAAAA"]]}, {Bond[{1, 1 ;; 8}, {2, 2 ;; 9}]}], Structure[{Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTAAAA"]]}, {Bond[{1, 3 ;; 10}, {2, 1 ;; 8}]}]},
				ToeholdMediatedDuplexExchange
			]],
			Reaction[{Structure[{Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTTAAAA"]]}, {Bond[{1, 7 ;; 11}, {2, 1 ;; 5}], Bond[{2, 6 ;; 9}, {3, 1 ;; 4}], Bond[{3, 5 ;; 8}, {4, 1 ;; 4}]}]}, {Structure[{Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTTTAAAAAA"]]}, {Bond[{1, 1 ;; 8}, {2, 2 ;; 9}]}], Structure[{Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTAAAA"]]}, {Bond[{1, 3 ;; 10}, {2, 1 ;; 8}]}]}, Quantity[0.00153, "Seconds"^(-1)]]
		],
		Example[{Additional,"ToeholdMediatedStrandExchange","Calculate forward rate for a ToeholdMediatedStrandExchange reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["AAAAA"]],Strand[DNA["AAAAAATTTTT"]]},{Bond[{1,1;;5},{2,7;;11}]}],Structure[{Strand[DNA["AAAAATTT"]]},{}]},
				{Structure[{Strand[DNA["AAAAATTT"]],Strand[DNA["AAAAAATTTTT"]]},{Bond[{1,1;;8},{2,4;;11}]}],Structure[{Strand[DNA["AAAAA"]]},{}]},
				ToeholdMediatedStrandExchange
			]],
			Reaction[
				{Structure[{Strand[DNA["AAAAA"]],Strand[DNA["AAAAAATTTTT"]]},{Bond[{1,1;;5},{2,7;;11}]}],Structure[{Strand[DNA["AAAAATTT"]]},{}]},
				{Structure[{Strand[DNA["AAAAATTT"]],Strand[DNA["AAAAAATTTTT"]]},{Bond[{1,1;;8},{2,4;;11}]}],Structure[{Strand[DNA["AAAAA"]]},{}]},
				Quantity[237.32028840340152, 1/("Molar"*"Seconds")]
			],
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Additional,"DuplexInvasion","Calculate forward rate for a DuplexInvasion reaction:"},
			KineticRates[Reaction[
			{Structure[{Strand[DNA["CCCCCA"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCC"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]},
			{Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCCA"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]},
			DuplexInvasion
		]],
			Reaction[
			{Structure[{Strand[DNA["CCCCCA"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCC"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]},
			{Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCCA"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]},
			Quantity[0, 1/("Molar"*"Seconds")]
			]
		],
		Example[{Additional,"DualToeholdMediatedDuplexExchange","Calculate forward rate for a DualToeholdMediatedDuplexExchange reaction:"},
			KineticRates[Reaction[
				{Structure[{Strand[DNA["GGGGGGAAAAAAAAAA"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["AAAAAAAAAAAAAAAA"]]}, {Bond[{2, 1 ;; 26}, {1, 17 ;; 42}]}],
				Structure[{Strand[DNA["TTTTTTTT"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["TTTTTTTT"]]}, {Bond[{2, 1 ;; 26}, {1, 9 ;; 34}]}]},
				{Structure[{Strand[DNA["GGGGGGAAAAAAAAAA"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["TTTTTTTT"]]}, {Bond[{1, 9 ;; 16}, {2, 27 ;; 34}], Bond[{2, 1 ;; 26}, {1, 17 ;; 42}]}],
				Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["AAAAAAAAAAAAAAAA"]], Strand[DNA["TTTTTTTT"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]]}, {Bond[{2, 1 ;; 34}, {1, 1 ;; 34}]}]},
				DualToeholdMediatedDuplexExchange
			]],
			Reaction[
				{Structure[{Strand[DNA["GGGGGGAAAAAAAAAA"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["AAAAAAAAAAAAAAAA"]]}, {Bond[{2, 1 ;; 26}, {1, 17 ;; 42}]}],
				Structure[{Strand[DNA["TTTTTTTT"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["TTTTTTTT"]]}, {Bond[{2, 1 ;; 26}, {1, 9 ;; 34}]}]},
				{Structure[{Strand[DNA["GGGGGGAAAAAAAAAA"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]], Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["TTTTTTTT"]]}, {Bond[{1, 9 ;; 16}, {2, 27 ;; 34}], Bond[{2, 1 ;; 26}, {1, 17 ;; 42}]}],
				Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCCCCC"], DNA["AAAAAAAAAAAAAAAA"]], Strand[DNA["TTTTTTTT"], DNA["GGGGGGGGGG"], DNA["TTTTTTTTTTTTTTTT"]]}, {Bond[{2, 1 ;; 34}, {1, 1 ;; 34}]}]},
				Quantity[172292.89528682406, 1/("Molar"*"Seconds")]
			]
		]

	}
]


(* ::Section:: *)
(*End Test Package*)
