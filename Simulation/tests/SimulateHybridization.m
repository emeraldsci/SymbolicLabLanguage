(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*SimulateHybridization: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Simulate*)


(* ::Subsubsection:: *)
(*SimulateHybridization*)

DefineTestsWithCompanions[SimulateHybridization,{

	Example[{Basic,"When providing a pair of sequences, SimulateHybridization predicts potentially high energy secondary structures the two sequences can form:"},
		SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}][HybridizedStructures],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 6 ;; 9}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 6}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]},
		Stubs :> {
			SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}, Upload->False]
		}
	],

	Example[{Basic,"SimulateHybridization can return all possible hybridization results even when the input pair of sequences are perfect Waston-Crick reverse complements:"},
		SimulateHybridization[{DNA["GACAGCGGGCTTTT"],DNA["AAAAGCCCGCTGTC"]}][HybridizedStructures],
		{Structure[{Strand[DNA["AAAAGCCCGCTGTC"]], Strand[DNA["GACAGCGGGCTTTT"]]}, {Bond[{1, 1 ;; 14}, {2, 1 ;; 14}]}], Structure[{Strand[DNA["AAAAGCCCGCTGTC"]], Strand[DNA["GACAGCGGGCTTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 11 ;; 13}], Bond[{1, 5 ;; 14}, {2, 1 ;; 10}]}], Structure[{Strand[DNA["AAAAGCCCGCTGTC"]], Strand[DNA["GACAGCGGGCTTTT"]]}, {Bond[{1, 2 ;; 4}, {2, 12 ;; 14}], Bond[{1, 5 ;; 14}, {2, 1 ;; 10}]}], Structure[{Strand[DNA["GACAGCGGGCTTTT"]], Strand[DNA["GACAGCGGGCTTTT"]]}, {Bond[{1, 4 ;; 6}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {2, 4 ;; 6}]}], Structure[{Strand[DNA["AAAAGCCCGCTGTC"]], Strand[DNA["AAAAGCCCGCTGTC"]]}, {Bond[{1, 4 ;; 6}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {2, 4 ;; 6}]}]},
		Stubs :> {
			SimulateHybridization[{DNA["GACAGCGGGCTTTT"],DNA["AAAAGCCCGCTGTC"]}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{DNA["GACAGCGGGCTTTT"],DNA["AAAAGCCCGCTGTC"]}, Upload->False]
		}
	],

	Example[{Basic,"Additionally, SimulateHybridization can handle strands with more than one sequence:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Upload->False]
		}
	],

	Example[{Basic,"SimulateHybridization can also handle complicate structures:"},
		SimulateHybridization[{Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}],Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]}][HybridizedStructures],
		{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}], Bond[{2, 4 ;; 6}, {3, 1 ;; 3}]}], Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}], Bond[{2, 5 ;; 7}, {3, 1 ;; 3}]}], Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 5 ;; 7}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}], Bond[{2, 5 ;; 7}, {3, 1 ;; 3}]}]},
		Stubs :> {
			SimulateHybridization[{Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}],Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}],Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]}, Upload->False]
		}
	],

	Example[{Basic,"SimulateHybridization can hybridize multiple input oligomers together, returns all possible intermediate and final structures:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}], Bond[{3, 1 ;; 3}, {4, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}]}]},
		Stubs:>{
			SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Upload->False]
		}
	],


	(* -------------------------- ADDITIONAL ------------------------- *)
	Example[{Additional,"SimulateHybridization can handle input with a list of oligomer lists:"},
		SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}], Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["ACCCA"], DNA["GGTCG"]]}}],
		{{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 6 ;; 9}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 6}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}, {Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}], Bond[{3, 1 ;; 3}, {4, 9 ;; 11}]}], Structure[{Strand[DNA["ACCCA"], DNA["GGTCG"]], Strand[DNA["ACCCA"], DNA["GGTCG"]]}, {Bond[{1, 1 ;; 3}, {2, 6 ;; 8}], Bond[{1, 6 ;; 8}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["ACCCA"], DNA["GGTCG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2 ;; 4}, {2, 9 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["ACCCA"], DNA["GGTCG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {2, 4 ;; 6}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["ACCCA"], DNA["GGTCG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2 ;; 4}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["ACCCA"], DNA["GGTCG"]], Strand[DNA["CCC"], DNA["ACCC"]]}, {Bond[{1, 6 ;; 8}, {2, 4 ;; 6}]}]}},
		Stubs :> {
			SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}], Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["ACCCA"], DNA["GGTCG"]]}}] =
			Append[HybridizedStructures] /. SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}], Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["ACCCA"], DNA["GGTCG"]]}}, Upload->False]
		}
	],

	Example[{Additional,"Return an empty list if two oligomers can not be paired nor can they fold themselves:"},
		SimulateHybridization[{"ATTA","CGGC"}][HybridizedStructures],
		{},
		Stubs :> {
			SimulateHybridization[{"ATTA","CGGC"}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"ATTA","CGGC"}, Upload->False]
		}
	],


	(* -------------------------- OPTIONS ------------------------- *)
	Example[{Options, Folding,"If Folding is turned on (by default), will do an interstrand folding to infinity depth after pairing:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->True][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->True][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->True, Upload->False]
		}
	],

	Example[{Options, Folding,"If Folding is turned on (by default), will only consider pairing:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->False][HybridizedStructures],
		{Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->False][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"],DNA["GGG"]],Strand[DNA["CCC"],DNA["ACCC"]]}, Folding->False, Upload->False]
		}
	],

	Example[{Options, Polymer,"Specify polymer type:"},
		SimulateHybridization[{"CGGGTACCTTAC","CTATGTATCCTT"} ,Polymer->DNA][HybridizedStructures],
		{Structure[{Strand[DNA["CGGGTACCTTAC"]], Strand[DNA["CGGGTACCTTAC"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["CGGGTACCTTAC"]], Strand[DNA["CGGGTACCTTAC"]]}, {Bond[{1, 4 ;; 6}, {2, 10 ;; 12}], Bond[{1, 10 ;; 12}, {2, 4 ;; 6}]}], Structure[{Strand[DNA["CGGGTACCTTAC"]], Strand[DNA["CTATGTATCCTT"]]}, {Bond[{1, 5 ;; 7}, {2, 5 ;; 7}]}], Structure[{Strand[DNA["CGGGTACCTTAC"]], Strand[DNA["CTATGTATCCTT"]]}, {Bond[{1, 10 ;; 12}, {2, 5 ;; 7}]}]},
		Stubs :> {
			SimulateHybridization[{"CGGGTACCTTAC","CTATGTATCCTT"}, Polymer->DNA][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"CGGGTACCTTAC","CTATGTATCCTT"} ,Polymer->DNA, Upload->False]
		}
	],

	Example[{Options, MinLevel,"Specify minimum number of consecutve bases in each hybridization:"},
		SimulateHybridization[{"GGTATGGTAGAA","GCGGGTCCGCCA"}, MinLevel->4][HybridizedStructures],
		{Structure[{Strand[DNA["GCGGGTCCGCCA"]], Strand[DNA["GCGGGTCCGCCA"]]}, {Bond[{1, 1 ;; 4}, {2, 7 ;; 10}], Bond[{1, 7 ;; 10}, {2, 1 ;; 4}]}]},
		Stubs :> {
			SimulateHybridization[{"GGTATGGTAGAA","GCGGGTCCGCCA"}, MinLevel->4][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"GGTATGGTAGAA","GCGGGTCCGCCA"}, MinLevel->4, Upload->False]
		}
	],

	Example[{Options, Consolidate,"If True, return the structures which cannot be further hybridized at current depth:"},
		SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->True][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{1, 7 ;; 11}, {2, 1 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 4 ;; 7}, {2, 4 ;; 7}], Bond[{1, 9 ;; 11}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["GCTAAACATAAA"]]}, {Bond[{1, 6 ;; 8}, {2, 4 ;; 6}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["GCTAAACATAAA"]]}, {Bond[{1, 6 ;; 8}, {2, 10 ;; 12}]}]},
		Stubs :> {
			SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->True][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->True, Upload->False]
		}
	],

	Example[{Options, Consolidate,"If False, return all possible intermediate structures which can be further hybridized at current depth:"},
		SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->False][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{1, 7 ;; 11}, {2, 1 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{1, 7 ;; 10}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 5}, {2, 7 ;; 10}], Bond[{1, 7 ;; 10}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}], Bond[{1, 7 ;; 11}, {2, 1 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}], Bond[{1, 8 ;; 11}, {2, 1 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 5}, {2, 7 ;; 10}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{1, 8 ;; 10}, {2, 2 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 7 ;; 11}, {2, 1 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}], Bond[{1, 7 ;; 10}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}], Bond[{1, 8 ;; 10}, {2, 2 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 7 ;; 10}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 4}, {2, 8 ;; 10}], Bond[{1, 7 ;; 10}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 4 ;; 6}, {2, 5 ;; 7}], Bond[{1, 9 ;; 11}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 4}, {2, 8 ;; 10}], Bond[{1, 8 ;; 10}, {2, 2 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 4 ;; 6}, {2, 5 ;; 7}], Bond[{1, 8 ;; 11}, {2, 1 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 4 ;; 7}, {2, 4 ;; 7}], Bond[{1, 9 ;; 11}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 4}, {2, 8 ;; 10}], Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 4}, {2, 8 ;; 11}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 4 ;; 6}, {2, 5 ;; 7}], Bond[{1, 8 ;; 10}, {2, 2 ;; 4}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 5}, {2, 7 ;; 10}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 2 ;; 4}, {2, 8 ;; 10}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 4 ;; 7}, {2, 4 ;; 7}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["GCTAAACATAAA"]]}, {Bond[{1, 6 ;; 8}, {2, 4 ;; 6}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["GCTAAACATAAA"]]}, {Bond[{1, 6 ;; 8}, {2, 10 ;; 12}]}], Structure[{Strand[DNA["CCCAATTTGGG"]], Strand[DNA["CCCAATTTGGG"]]}, {Bond[{1, 4 ;; 6}, {2, 5 ;; 7}]}]},
		Stubs :> {
			SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->False][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"CCCAATTTGGG","GCTAAACATAAA"}, Consolidate->False, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, Depth,"Return structures formed by 2 times of recursive hybridizations (including intermediately formed structures):"},
		SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"}, Depth->2][HybridizedStructures],
		{Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 7 ;; 9}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 7 ;; 9}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["ATAATCCAAA"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 8 ;; 10}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["ATAATCCAAA"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 1 ;; 3}], Bond[{3, 7 ;; 9}, {4, 8 ;; 10}]}]},
		Stubs :> {
			SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"}, Depth->2][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"},Depth->2, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, Depth,"Return structures formed by exactly 2 times of recursive hybridizations (not including intermediately formed structures):"},
		SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"}, Depth->{2}][HybridizedStructures],
		{Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 7 ;; 9}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 7 ;; 9}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["ATAATCCAAA"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 8 ;; 10}]}], Structure[{Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["AAACCCTTT"]], Strand[DNA["ATAATCCAAA"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{1, 7 ;; 9}, {3, 1 ;; 3}], Bond[{3, 7 ;; 9}, {4, 8 ;; 10}]}]},
		Stubs :> {
			SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"}, Depth->{2}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"AAACCCTTT","ATAATCCAAA"},Depth->{2}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, MaxMismatch,"Maximum number of mismatches allowed in any given duplex:"},
		SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}, MaxMismatch->1][HybridizedStructures],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}], Bond[{1, 8 ;; 8}, {2, 3 ;; 3}], Bond[{1, 9 ;; 9}, {2, 4 ;; 4}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}], Bond[{1, 11 ;; 11}, {2, 2 ;; 2}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}], Bond[{1, 7 ;; 8}, {2, 3 ;; 4}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}], Bond[{1, 8 ;; 8}, {2, 3 ;; 3}], Bond[{1, 9 ;; 9}, {2, 4 ;; 4}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}], Bond[{1, 11 ;; 11}, {2, 2 ;; 2}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 6 ;; 9}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 6}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 1 ;; 1}, {2, 5 ;; 5}], Bond[{1, 3 ;; 4}, {2, 3 ;; 4}], Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 2 ;; 2}, {2, 6 ;; 6}], Bond[{1, 3 ;; 4}, {2, 3 ;; 4}], Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 2 ;; 2}, {2, 6 ;; 6}], Bond[{1, 3 ;; 3}, {2, 4 ;; 4}], Bond[{1, 5 ;; 7}, {2, 7 ;; 9}], Bond[{1, 8 ;; 8}, {2, 3 ;; 3}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}]}]},
		Stubs :> {
			SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}, MaxMismatch->1][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"},MaxMismatch->1, Upload->False]
		}
	],

	Example[{Options, MinPieceSize,"Minimum number of consecutive paired bases required in a duplex containing mismatches:"},
		SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}, MaxMismatch->1, MinPieceSize->2][HybridizedStructures],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 6 ;; 9}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 6}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]},
		Stubs :> {
			SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"}, MaxMismatch->1, MinPieceSize->2][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"ATCGTAGCGTA","ATCGCGCGCTA"},MaxMismatch->1,MinPieceSize->2, Upload->False]
		}
	],

	Example[{Options, Temperature, "Specify temperature at which hybridization is simulated which will influence the computed free energy:"},
		SimulateHybridization[{"CATAGCTACGTCTTTA", "GTGAAACTAGAAT"}, Temperature->37 Celsius][HybridizedEnergies],
		{Quantity[-9.850000000000001, "KilocaloriesThermochemical"/"Moles"], Quantity[-3.4700000000000024, "KilocaloriesThermochemical"/"Moles"], Quantity[-0.7499999999999964, "KilocaloriesThermochemical"/"Moles"], Quantity[-0.5199999999999996, "KilocaloriesThermochemical"/"Moles"], Quantity[0.33999999999999986, "KilocaloriesThermochemical"/"Moles"], Quantity[0.639999999999997, "KilocaloriesThermochemical"/"Moles"]}, EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Options, Temperature, "Specify temperature at which hybridization is simulated which will influence the computed free energy:"},
		SimulateHybridization[{"CATAGCTACGTCTTTA", "GTGAAACTAGAAT"}, Temperature->100 Celsius][HybridizedEnergies],
		{Quantity[-1.1256730614218995, "KilocaloriesThermochemical"/"Moles"], Quantity[1.6900274060938258, "KilocaloriesThermochemical"/"Moles"], Quantity[2.9752361760438504, "KilocaloriesThermochemical"/"Moles"], Quantity[3.688336288892476, "KilocaloriesThermochemical"/"Moles"], Quantity[6.665390939867802, "KilocaloriesThermochemical"/"Moles"], Quantity[7.026329195550542, "KilocaloriesThermochemical"/"Moles"]}, EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Options, Template, "The options from a previous hybridization simulation (field reference) can be used as a template to create new hybridizations:"},
		SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID, ResolvedOptions]][HybridizedStructures],
		{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]], Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {Bond[{1, 5 ;; 10}, {2, 5 ;; 10}]}], Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]], Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {Bond[{1, 11 ;; 14}, {2, 11 ;; 14}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 3 ;; 6}, {2, 15 ;; 18}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 2 ;; 5}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 1 ;; 4}, {2, 1 ;; 4}]}]},
		Stubs :> {
			SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID, ResolvedOptions]][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID, ResolvedOptions], Upload->False]
		},
		SetUp :> (
			theTemplateObject = Upload[<|Type->Object[Simulation, Hybridization], UnresolvedOptions->{Folding->False, Method->Energy, Polymer->Null, Temperature->Quantity[37, "DegreesCelsius"], Depth->{1}, Consolidate->True, MaxMismatch->0, MinPieceSize->1, MinLevel->4, Upload->True}, ResolvedOptions->{Folding->False, Method->Energy, Polymer->Null, Temperature->Quantity[37, "DegreesCelsius"], Depth->{1}, Consolidate->True, MaxMismatch->0, MinPieceSize->1, MinLevel->4, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>
			];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Template, "The options from a previous hybridization simulation (object) can be used as a template to create new hybridizations:"},
		SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID]][HybridizedStructures],
		{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]], Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {Bond[{1, 5 ;; 10}, {2, 5 ;; 10}]}], Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]], Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {Bond[{1, 11 ;; 14}, {2, 11 ;; 14}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 3 ;; 6}, {2, 15 ;; 18}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 2 ;; 5}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]], Strand[DNA["TATATTGCGTCGGTAATA"]]}, {Bond[{1, 1 ;; 4}, {2, 1 ;; 4}]}]},
		Stubs :> {
			SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID]][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Structure[{Strand[DNA["GTGTGAATTCCTAGCGGC"]]}, {}], Structure[{Strand[DNA["TATATTGCGTCGGTAATA"]]}, {}]}, Template->Object[Simulation, Hybridization, theTemplateObjectID], Upload->False]
		},
		SetUp :> (
			theTemplateObject = Upload[<|Type->Object[Simulation, Hybridization], UnresolvedOptions->{Folding->False, Method->Energy, Polymer->Null, Temperature->Quantity[37, "DegreesCelsius"], Depth->{1}, Consolidate->True, MaxMismatch->0, MinPieceSize->1, MinLevel->4, Upload->True}, ResolvedOptions->{Folding->False, Method->Energy, Polymer->Null, Temperature->Quantity[37, "DegreesCelsius"], Depth->{1}, Consolidate->True, MaxMismatch->0, MinPieceSize->1, MinLevel->4, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>
			];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Method,"Sort the returned hybridized structures by ascending energy:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Energy][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}], Bond[{3, 1 ;; 3}, {4, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Energy][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Energy, Upload->False]
		}
	],

	Example[{Options, Method,"Sort the returned hybridized structures by descending number of bonds:"},
		SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Bonds][HybridizedStructures],
		{Structure[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}], Bond[{1, 9 ;; 11}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}], Bond[{3, 1 ;; 3}, {4, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}], Bond[{2, 1 ;; 3}, {3, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["TTACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {2, 9 ;; 11}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {2, 9 ;; 11}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Bonds][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]], Strand[DNA["CCC"], DNA["TTACCC"]]}, Method->Bonds, Upload->False]
		}
	],

	Example[{Messages,"InputTooLong","Input can be a maximum of two lists of oligomers.  Warning is shown when truncating input to first two inputs:"},
		SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}],  Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[	DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]]}, {Strand[DNA["ACCCA"], DNA["GGTCG"]]}}],
		{{ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGCGCGCTA"]]}, {Bond[{1, Span[4, 9]}, {2, Span[4,9]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGCGCGCTA"]]}, {Bond[{1, Span[3, 8]}, {2, Span[3, 8]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGCGCGCTA"]]}, {Bond[{1, Span[6, 9]}, {2, Span[6, 9]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGTAGCGTA"]]}, {Bond[{1, Span[7, 11]}, {2, Span[5, 9]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGCGCGCTA"]]}, {Bond[{1, Span[3, 6]}, {2, Span[3, 6]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGTAGCGTA"]]}, {Bond[{1, Span[3, 5]}, {2, Span[7, 9]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["ATCGCGCGCTA"]], ECL`Strand[ECL`DNA["ATCGTAGCGTA"]]}, {Bond[{1, Span[5, 7]}, {2, Span[7, 9]}]}]}, {ECL`Structure[{ECL`Strand[ECL`DNA["CCCAAAAA"], ECL`DNA["GGG"]], ECL`Strand[ECL`DNA["CCCAAAAA"], ECL`DNA["GGG"]]}, {Bond[{1, Span[1, 3]}, {2, Span[9, 11]}], Bond[{1, Span[9, 11]}, {2, Span[1, 3]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["CCC"], ECL`DNA["ACCC"]], ECL`Strand[ ECL`DNA["CCCAAAAA"], ECL`DNA["GGG"]]}, {Bond[{1, Span[1, 3]}, {2, Span[9, 11]}]}], ECL`Structure[{ECL`Strand[ECL`DNA["CCC"], ECL`DNA["ACCC"]], ECL`Strand[ECL`DNA["CCCAAAAA"], ECL`DNA["GGG"]]}, {Bond[{1, Span[5, 7]}, {2, Span[9, 11]}]}]}},
		Messages:>{Warning::InputTooLong},
		Stubs :> {
			SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}],  Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[	DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]]}, {Strand[DNA["ACCCA"], DNA["GGTCG"]]}}] =
			Append[HybridizedStructures] /. SimulateHybridization[{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}],  Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Strand[	DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["CCC"], DNA["ACCC"]]}, {Strand[DNA["ACCCA"], DNA["GGTCG"]]}}, Upload->False]
		}
	],

	(* -------------------------- TESTS ------------------------- *)
	Test["Hybridize two strands:",
		SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"]],Strand[DNA["ATCGCGCGCTA"]]}][HybridizedStructures],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 6 ;; 9}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]]}, {Bond[{1, 3 ;; 6}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"]],Strand[DNA["ATCGCGCGCTA"]]}][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"]],Strand[DNA["ATCGCGCGCTA"]]}, Upload->False]
		}
	],

	Test["Hybridize two strands with multiple motifs:",
		SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"],DNA["ATCGCGCGCTA"]],Strand[DNA["ATCGCGCGCTA","Z"],DNA["ATCGCGCGCTA", "Q"]]}, MinLevel->5][HybridizedStructures],
		{Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}], Bond[{1, 15 ;; 20}, {2, 15 ;; 20}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}], Bond[{1, 15 ;; 20}, {2, 15 ;; 20}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 4 ;; 9}, {2, 4 ;; 9}], Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 3 ;; 8}, {2, 3 ;; 8}], Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 4 ;; 9}, {2, 15 ;; 20}], Bond[{1, 15 ;; 20}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 3 ;; 8}, {2, 14 ;; 19}], Bond[{1, 14 ;; 19}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 3 ;; 8}, {2, 14 ;; 19}], Bond[{1, 15 ;; 20}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 7 ;; 11}], Bond[{1, 15 ;; 20}, {2, 15 ;; 20}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 7 ;; 11}], Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 18 ;; 22}], Bond[{1, 15 ;; 20}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], DNA["ATCGCGCGCTA", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 18 ;; 22}], Bond[{1, 14 ;; 19}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]]}, {Bond[{1, 5 ;; 9}, {2, 18 ;; 22}], Bond[{1, 18 ;; 22}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]]}, {Bond[{1, 15 ;; 20}, {2, 15 ;; 20}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]]}, {Bond[{1, 14 ;; 19}, {2, 14 ;; 19}]}]},
		Stubs :> {
			SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"],DNA["ATCGCGCGCTA"]],Strand[DNA["ATCGCGCGCTA","Z"],DNA["ATCGCGCGCTA", "Q"]]}, MinLevel->5][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{Strand[DNA["ATCGTAGCGTA"],DNA["ATCGCGCGCTA"]],Strand[DNA["ATCGCGCGCTA","Z"],DNA["ATCGCGCGCTA", "Q"]]},MinLevel->5, Upload->False]
		},
		TimeConstraint->1000
	],

	Test["Hybridize two sequences:",
		SimulateHybridization[{"TACCTGGAGCTTCCAGGCAG","TATGGAACTATGAAGCTCCCG"}, MinLevel->5][HybridizedStructures],
		{Structure[{Strand[DNA["TACCTGGAGCTTCCAGGCAG"]], Strand[DNA["TACCTGGAGCTTCCAGGCAG"]]}, {Bond[{1, 3 ;; 8}, {2, 12 ;; 17}], Bond[{1, 12 ;; 17}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["TACCTGGAGCTTCCAGGCAG"]], Strand[DNA["TATGGAACTATGAAGCTCCCG"]]}, {Bond[{1, 6 ;; 13}, {2, 12 ;; 19}]}], Structure[{Strand[DNA["TACCTGGAGCTTCCAGGCAG"]], Strand[DNA["TATGGAACTATGAAGCTCCCG"]]}, {Bond[{1, 6 ;; 10}, {2, 15 ;; 19}], Bond[{1, 11 ;; 15}, {2, 3 ;; 7}]}]},
		Stubs :> {
			SimulateHybridization[{"TACCTGGAGCTTCCAGGCAG","TATGGAACTATGAAGCTCCCG"}, MinLevel->5][HybridizedStructures] =
			Append[HybridizedStructures] /. SimulateHybridization[{"TACCTGGAGCTTCCAGGCAG","TATGGAACTATGAAGCTCCCG"},MinLevel->5, Upload->False]
		}
	],

	Test["Insert new object:",
		SimulateHybridization[{"CTATGGGGCCC","GAACCGTCTAT"}],
		ObjectReferenceP[Object[Simulation, Hybridization]],
		TimeConstraint->1000,
		Stubs :> {
			Print[_] := Null
		}
	]

},
	SetUp :> (
		$CreatedObjects = {};
	),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force->True, Verbose->False];
		Unset[$CreatedObjects];
	)
];



(* ::Section:: *)
(*End Test Package*)
