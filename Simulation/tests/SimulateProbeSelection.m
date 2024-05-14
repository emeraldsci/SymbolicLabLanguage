(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*SimulateProbeSelection: Tests*)


(* ::Section:: *)
(*Unit Testing*)



(* ::Subsection::Closed:: *)
(*SimulateProbeSelection*)


(* ::Subsubsection::Closed:: *)
(*SimulateProbeSelection*)


SimulateProbeSelectionOutputPattern={
	ProbeStrands -> {StrandP..}
};

DefineTests[SimulateProbeSelection,
{
		Example[
			{Basic,"Test every site on the target sequence to find the best probe binding site, probe trands (ProbeStrands field) are returned by defauled sorted by the bounded concentrations in descending order:"},
			SimulateProbeSelection[DNA["GGTCTAGACGTACGACGAAGTAAGCGGTTATCAGGGCCTGGCGTCAAGCTATCCACGGCTCGCCCGAATTAGTCACGGGGTGCATTTTGCAGTGCCTAAT"]][[1;;10]],
			{Strand[DNA["CGGGCGAGCCGTGGATAGCT", "Probe"]], Strand[DNA["TCGGGCGAGCCGTGGATAGC", "Probe"]], Strand[DNA["AGCTTGACGCCAGGCCCTGA", "Probe"]], Strand[DNA["CGCCAGGCCCTGATAACCGC", "Probe"]], Strand[DNA["GCTTGACGCCAGGCCCTGAT", "Probe"]], Strand[DNA["GCCAGGCCCTGATAACCGCT", "Probe"]], Strand[DNA["AATTCGGGCGAGCCGTGGAT", "Probe"]], Strand[DNA["ACGCCAGGCCCTGATAACCG", "Probe"]], Strand[DNA["GGGCGAGCCGTGGATAGCTT", "Probe"]], Strand[DNA["TAGCTTGACGCCAGGCCCTG", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection[DNA["GGTCTAGACGTACGACGAAGTAAGCGGTTATCAGGGCCTGGCGTCAAGCTATCCACGGCTCGCCCGAATTAGTCACGGGGTGCATTTTGCAGTGCCTAAT"]] =
				SimulateProbeSelection[DNA["GGTCTAGACGTACGACGAAGTAAGCGGTTATCAGGGCCTGGCGTCAAGCTATCCACGGCTCGCCCGAATTAGTCACGGGGTGCATTTTGCAGTGCCTAAT"],Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],
		Example[
			{Basic,"Input can also be a valid nucleotide string:"},
			SimulateProbeSelection["UCACCUGAUUUCGCUAGGACACCCGUAAGGCAACGUUCCUGUUGCAGAGAUGUACUCGCACUCCGAUUUGCGUUAGAACGGGUCCAAUUGCUUGACUAGGAUUACCUAGG"][[1;;10]],
			{Strand[RNA["UCGGAGUGCGAGUACAUCUC", "Probe"]], Strand[RNA["GAGUGCGAGUACAUCUCUGC", "Probe"]], Strand[RNA["AGUGCGAGUACAUCUCUGCA", "Probe"]], Strand[RNA["GUGCGAGUACAUCUCUGCAA", "Probe"]], Strand[RNA["UGCGAGUACAUCUCUGCAAC", "Probe"]], Strand[RNA["GCGAGUACAUCUCUGCAACA", "Probe"]], Strand[RNA["UCUCUGCAACAGGAACGUUG", "Probe"]], Strand[RNA["UCUAACGCAAAUCGGAGUGC", "Probe"]], Strand[RNA["CGAGUACAUCUCUGCAACAG", "Probe"]], Strand[RNA["ACCCGUUCUAACGCAAAUCG", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection["UCACCUGAUUUCGCUAGGACACCCGUAAGGCAACGUUCCUGUUGCAGAGAUGUACUCGCACUCCGAUUUGCGUUAGAACGGGUCCAAUUGCUUGACUAGGAUUACCUAGG"] =
				SimulateProbeSelection["UCACCUGAUUUCGCUAGGACACCCGUAAGGCAACGUUCCUGUUGCAGAGAUGUACUCGCACUCCGAUUUGCGUUAGAACGGGUCCAAUUGCUUGACUAGGAUUACCUAGG",Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],
	Example[
		{Basic,"Test only on the explicitly specified sites on the target:"},
		SimulateProbeSelection[RNA["AUUCAAUUGUCCCAUGCGUAAGCACCGAAAAACAGGUUUUCGACCGGGCAUGUUUCGCCAUUGUGAACAGAGCCUCGAUAGUUUUAUCCAAUUUCACUGG"], {{1, 21}, {20, 40}, {70, 90}}],
		{Strand[RNA["UGGAUAAAACUAUCGAGGCUC", "Probe"]], Strand[RNA["UUACGCAUGGGACAAUUGAAU", "Probe"]], Strand[RNA["AAAACCUGUUUUUCGGUGCUU", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[RNA["AUUCAAUUGUCCCAUGCGUAAGCACCGAAAAACAGGUUUUCGACCGGGCAUGUUUCGCCAUUGUGAACAGAGCCUCGAUAGUUUUAUCCAAUUUCACUGG"], {{1, 21}, {20, 40}, {70, 90}}] =
				SimulateProbeSelection[RNA["AUUCAAUUGUCCCAUGCGUAAGCACCGAAAAACAGGUUUUCGACCGGGCAUGUUUCGCCAUUGUGAACAGAGCCUCGAUAGUUUUAUCCAAUUUCACUGG"], {{1, 21}, {20, 40}, {70, 90}}, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Basic,"Can be applied directly on a specific ribonuleic acid (RNA) transcript to find the best probe binding site:"},
		SimulateProbeSelection[Model[Sample,"id:xRO9n3vk11RO"]][[1;;10]],
		{StrandP...},
		Stubs :> {
				SimulateProbeSelection[Model[Sample,"id:xRO9n3vk11RO"]] =
				SimulateProbeSelection[Model[Sample,"id:xRO9n3vk11RO"],Upload->False]
			},
		TimeConstraint->4000
	],

	Example[
		{Additional, "PlotProbeConcentration can be used to plot the probe accessibility along the target sequence, indicating probe concentration vs. position:"},
		PlotProbeConcentration[SimulateProbeSelection[DNA["TAATCAACAAAACCTATCTTTGCTATACCACCTCCATCGGCTACATGGTGTTCCGCTTCTTTACACAGCGCTCACACGAAGTGGTGTGAGCTCTTGAAGC"],Output->Packet]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateProbeSelection[DNA["TAATCAACAAAACCTATCTTTGCTATACCACCTCCATCGGCTACATGGTGTTCCGCTTCTTTACACAGCGCTCACACGAAGTGGTGTGAGCTCTTGAAGC"],Output->Packet] =
			SimulateProbeSelection[DNA["TAATCAACAAAACCTATCTTTGCTATACCACCTCCATCGGCTACATGGTGTTCCGCTTCTTTACACAGCGCTCACACGAAGTGGTGTGAGCTCTTGAAGC"],Output->Packet, Upload->False]
		},
		TimeConstraint->4000
	],

		Example[
			{Options,ProbeLength,"Test multiple proble lengths:"},
			SimulateProbeSelection[DNA["CCTGTACACCACACGTTCAAGATGTAGTGGTAAATTAGCATGATCACTTCTCATAATTGGGACTGGTACACGCAGTGCCG"],ProbeLength->{19,20}][[1;;10]],
			{Strand[DNA["CGGCACTGCGTGTACCAGTC", "Probe"]], Strand[DNA["GGCACTGCGTGTACCAGTCC", "Probe"]], Strand[DNA["GCACTGCGTGTACCAGTCCC", "Probe"]], Strand[DNA["CGGCACTGCGTGTACCAGT", "Probe"]], Strand[DNA["CACTGCGTGTACCAGTCCCA", "Probe"]], Strand[DNA["ACTGCGTGTACCAGTCCCAA", "Probe"]], Strand[DNA["ACTGCGTGTACCAGTCCCA", "Probe"]], Strand[DNA["GGCACTGCGTGTACCAGTC", "Probe"]], Strand[DNA["GCACTGCGTGTACCAGTCC", "Probe"]], Strand[DNA["CACTGCGTGTACCAGTCCC", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection[DNA["CCTGTACACCACACGTTCAAGATGTAGTGGTAAATTAGCATGATCACTTCTCATAATTGGGACTGGTACACGCAGTGCCG"],ProbeLength->{19,20}] =
				SimulateProbeSelection[DNA["CCTGTACACCACACGTTCAAGATGTAGTGGTAAATTAGCATGATCACTTCTCATAATTGGGACTGGTACACGCAGTGCCG"],ProbeLength->{19,20}, Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],
	Example[
		{Options,Depth,"Speicfy the depth of folding and pairing interactions:"},
		SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Depth->1][[1;;10]],
		{Strand[DNA["CCCGAGGTGTGGAACCAAGG", "Probe"]], Strand[DNA["CCGAGGTGTGGAACCAAGGT", "Probe"]], Strand[DNA["TCCCGAGGTGTGGAACCAAG", "Probe"]], Strand[DNA["TTCCCGAGGTGTGGAACCAA", "Probe"]], Strand[DNA["ATTCCCGAGGTGTGGAACCA", "Probe"]], Strand[DNA["CGAGGTGTGGAACCAAGGTG", "Probe"]], Strand[DNA["GATTCCCGAGGTGTGGAACC", "Probe"]], Strand[DNA["GGTGTGGAACCAAGGTGTCA", "Probe"]], Strand[DNA["GAGGTGTGGAACCAAGGTGT", "Probe"]], Strand[DNA["AGGTGTGGAACCAAGGTGTC", "Probe"]]},
		Stubs :> {
			SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Time->1 Second] =
					SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Time->1 Second, Upload->False]
		},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
		Example[
			{Options,Time,"Speicfy the time of simulation on each site:"},
			SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Time->1 Second][[1;;10]],
			{Strand[DNA["CCCGAGGTGTGGAACCAAGG", "Probe"]], Strand[DNA["CCGAGGTGTGGAACCAAGGT", "Probe"]], Strand[DNA["TCCCGAGGTGTGGAACCAAG", "Probe"]], Strand[DNA["TTCCCGAGGTGTGGAACCAA", "Probe"]], Strand[DNA["ATTCCCGAGGTGTGGAACCA", "Probe"]], Strand[DNA["CGAGGTGTGGAACCAAGGTG", "Probe"]], Strand[DNA["GATTCCCGAGGTGTGGAACC", "Probe"]], Strand[DNA["GGTGTGGAACCAAGGTGTCA", "Probe"]], Strand[DNA["GAGGTGTGGAACCAAGGTGT", "Probe"]], Strand[DNA["AGGTGTGGAACCAAGGTGTC", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Time->1 Second] =
				SimulateProbeSelection["AACGTGACGTTCGCTATGGTTGAACGCATCTTTCTATTAAAATTTCCAGTGACACCTTGGTTCCACACCTCGGGAATCAA",Time->1 Second, Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],
		Example[
			{Options,BeaconStemLength,"Specify the beacon length:"},
			SimulateProbeSelection[DNA["TTTATGTCCTGAGTCCACATATGACGGACTGGAAGGTCCTAAGGTCCTATTACTGGGTCAACTTGCAAACGAATCTGGTGGCTTTCCCAC"], BeaconStemLength->5][[1;;10]],
			{Strand[DNA["TGGGAAAGCCACCAGATTCGTCCCA", "Probe"]], Strand[DNA["GCCACCAGATTCGTTTGCAAGTGGC", "Probe"]], Strand[DNA["CCTTAGGACCTTCCAGTCCGTAAGG", "Probe"]], Strand[DNA["GGGAAAGCCACCAGATTCGTTTCCC", "Probe"]], Strand[DNA["AGGACCTTCCAGTCCGTCATGTCCT", "Probe"]], Strand[DNA["TAGGACCTTCCAGTCCGTCATCCTA", "Probe"]], Strand[DNA["AGCCACCAGATTCGTTTGCATGGCT", "Probe"]], Strand[DNA["CTTAGGACCTTCCAGTCCGTCTAAG", "Probe"]], Strand[DNA["AAGCCACCAGATTCGTTTGCGGCTT", "Probe"]], Strand[DNA["CGTTTGCAAGTTGACCCAGTAAACG", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection[DNA["TTTATGTCCTGAGTCCACATATGACGGACTGGAAGGTCCTAAGGTCCTATTACTGGGTCAACTTGCAAACGAATCTGGTGGCTTTCCCAC"], BeaconStemLength->5] =
				SimulateProbeSelection[DNA["TTTATGTCCTGAGTCCACATATGACGGACTGGAAGGTCCTAAGGTCCTATTACTGGGTCAACTTGCAAACGAATCTGGTGGCTTTCCCAC"], BeaconStemLength->5, Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],
		Example[
			{Options,Temperature,"Specify the temperature at which simulations are running:"},
			SimulateProbeSelection["GGGAGACTATGTGACTTCGGTGTTCGGATGCAATCCCCAGATTGCATCTTCCATGTATTCGAGGTCCCTACATAGCATGACTCTCATTTAAGCGGGGCAT", Temperature->85 Celsius][[1;;10]],
			{Strand[DNA["GGGGATTGCATCCGAACACC", "Probe"]], Strand[DNA["GGGATTGCATCCGAACACCG", "Probe"]], Strand[DNA["TGGGGATTGCATCCGAACAC", "Probe"]], Strand[DNA["CTGGGGATTGCATCCGAACA", "Probe"]], Strand[DNA["GGATTGCATCCGAACACCGA", "Probe"]], Strand[DNA["TCTGGGGATTGCATCCGAAC", "Probe"]], Strand[DNA["TGCATCCGAACACCGAAGTC", "Probe"]], Strand[DNA["GCATCCGAACACCGAAGTCA", "Probe"]], Strand[DNA["TTGCATCCGAACACCGAAGT", "Probe"]], Strand[DNA["AATCTGGGGATTGCATCCGA", "Probe"]]},
			Stubs :> {
				SimulateProbeSelection["GGGAGACTATGTGACTTCGGTGTTCGGATGCAATCCCCAGATTGCATCTTCCATGTATTCGAGGTCCCTACATAGCATGACTCTCATTTAAGCGGGGCAT", Temperature->85 Celsius] =
				SimulateProbeSelection["GGGAGACTATGTGACTTCGGTGTTCGGATGCAATCCCCAGATTGCATCTTCCATGTATTCGAGGTCCCTACATAGCATGACTCTCATTTAAGCGGGGCAT", Temperature->85 Celsius, Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[7],
			TimeConstraint->2000
		],

	Example[
		{Options,ProbeConcentration,"Specify the concentration of the probe that will be binding to the target sequence:"},
		SimulateProbeSelection[DNA["TCCCGGTTTCGCTATCCCCTGTTCTGAGCATCGATATTGTAATAGCGTTATGTCGGTTTCGGTCCATGTCATACGACACCAGAAGCTGAGACTCTGCTGT"],ProbeConcentration->1 Micro Molar][[1;;10]],
		{Strand[DNA["AGGGGATAGCGAAACCGGGA", "Probe"]], Strand[DNA["CAGGGGATAGCGAAACCGGG", "Probe"]], Strand[DNA["ACAGGGGATAGCGAAACCGG", "Probe"]], Strand[DNA["TCGATGCTCAGAACAGGGGA", "Probe"]], Strand[DNA["AACAGGGGATAGCGAAACCG", "Probe"]], Strand[DNA["GCTCAGAACAGGGGATAGCG", "Probe"]], Strand[DNA["GACATGGACCGAAACCGACA", "Probe"]], Strand[DNA["TGACATGGACCGAAACCGAC", "Probe"]], Strand[DNA["ACCGAAACCGACATAACGCT", "Probe"]], Strand[DNA["ACATGGACCGAAACCGACAT", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["TCCCGGTTTCGCTATCCCCTGTTCTGAGCATCGATATTGTAATAGCGTTATGTCGGTTTCGGTCCATGTCATACGACACCAGAAGCTGAGACTCTGCTGT"],ProbeConcentration->1 Micro Molar] =
				SimulateProbeSelection[DNA["TCCCGGTTTCGCTATCCCCTGTTCTGAGCATCGATATTGTAATAGCGTTATGTCGGTTTCGGTCCATGTCATACGACACCAGAAGCTGAGACTCTGCTGT"],ProbeConcentration->1 Micro Molar, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,TargetConcentration,"Specify the concentration of the target sequence:"},
		SimulateProbeSelection[DNA["CTCAAGTAAAACATATTCTAGCAAATTTAGCCTCCCGTCCCTCTCGCTTCCAGCCCCCACAACTACGTATCCGTGCTGGAGGAGCGGAAAGGTATACTGCTACAATGATCGATACCCTTC"],TargetConcentration->1 Nano Molar][[1;;10]],
		{Strand[DNA["AGCGAGAGGGACGGGAGGCT", "Probe"]], Strand[DNA["GGGGGCTGGAAGCGAGAGGG", "Probe"]], Strand[DNA["TGGGGGCTGGAAGCGAGAGG", "Probe"]], Strand[DNA["AAGCGAGAGGGACGGGAGGC", "Probe"]], Strand[DNA["GGGGCTGGAAGCGAGAGGGA", "Probe"]], Strand[DNA["TGTGGGGGCTGGAAGCGAGA", "Probe"]], Strand[DNA["TTCCGCTCCTCCAGCACGGA", "Probe"]], Strand[DNA["TCCGCTCCTCCAGCACGGAT", "Probe"]], Strand[DNA["GCGAGAGGGACGGGAGGCTA", "Probe"]], Strand[DNA["AGTTGTGGGGGCTGGAAGCG", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["CTCAAGTAAAACATATTCTAGCAAATTTAGCCTCCCGTCCCTCTCGCTTCCAGCCCCCACAACTACGTATCCGTGCTGGAGGAGCGGAAAGGTATACTGCTACAATGATCGATACCCTTC"],TargetConcentration->1 Nano Molar] =
				SimulateProbeSelection[DNA["CTCAAGTAAAACATATTCTAGCAAATTTAGCCTCCCGTCCCTCTCGCTTCCAGCCCCCACAACTACGTATCCGTGCTGGAGGAGCGGAAAGGTATACTGCTACAATGATCGATACCCTTC"],TargetConcentration->1 Nano Molar, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,ProbeTarget,"Interactions to consider between probe and target. If All, consider all interactions. If Site, consider only interactions on sites:"},
		SimulateProbeSelection[DNA["GCGATCAGGGCCTCTTTGAGTTTCGCGCCTGTATCGATAACAAAGATGTAGCGTGTAGCAAGGCAGTACCGCATGGATCGCACCCCCGGACAGTCTCTTCCTGATTCTGT"],{{10, 30}, {45, 65}, {75, 95}}, ProbeTarget->All],
		{Strand[DNA["GACTGTCCGGGGGTGCGATCC", "Probe"]], Strand[DNA["AGGCGCGAAACTCAAAGAGGC", "Probe"]], Strand[DNA["TGCCTTGCTACACGCTACATC", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["GCGATCAGGGCCTCTTTGAGTTTCGCGCCTGTATCGATAACAAAGATGTAGCGTGTAGCAAGGCAGTACCGCATGGATCGCACCCCCGGACAGTCTCTTCCTGATTCTGT"],{{10, 30}, {45, 65}, {75, 95}}, ProbeTarget->All] =
				SimulateProbeSelection[DNA["GCGATCAGGGCCTCTTTGAGTTTCGCGCCTGTATCGATAACAAAGATGTAGCGTGTAGCAAGGCAGTACCGCATGGATCGCACCCCCGGACAGTCTCTTCCTGATTCTGT"],{{10, 30}, {45, 65}, {75, 95}}, ProbeTarget->All, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,ProbeFolding,"Do not model Probe folding:"},
		SimulateProbeSelection[DNA["CGACGGCCGTCAGCTAATGGCAAGTAGGTACGCCGTGGACTCTCTATGGGCCCAAGCTTTGCAGAGACTTCTACACGATAACTACAAGACGCCAGCTTAATGTGAGCAATCCGGCGGGAA"], ProbeFolding->False][[1;;10]],
		{Strand[DNA["TGCCATTAGCTGACGGCCGT", "Probe"]], Strand[DNA["TTCCCGCCGGATTGCTCACA", "Probe"]], Strand[DNA["TCCCGCCGGATTGCTCACAT", "Probe"]], Strand[DNA["CCCGCCGGATTGCTCACATT", "Probe"]], Strand[DNA["GCCATTAGCTGACGGCCGTC", "Probe"]], Strand[DNA["CTCTGCAAAGCTTGGGCCCA", "Probe"]], Strand[DNA["TTGCCATTAGCTGACGGCCG", "Probe"]], Strand[DNA["TCTCTGCAAAGCTTGGGCCC", "Probe"]], Strand[DNA["CCATTAGCTGACGGCCGTCG", "Probe"]], Strand[DNA["TCTGCAAAGCTTGGGCCCAT", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["CGACGGCCGTCAGCTAATGGCAAGTAGGTACGCCGTGGACTCTCTATGGGCCCAAGCTTTGCAGAGACTTCTACACGATAACTACAAGACGCCAGCTTAATGTGAGCAATCCGGCGGGAA"], ProbeFolding->False] =
				SimulateProbeSelection[DNA["CGACGGCCGTCAGCTAATGGCAAGTAGGTACGCCGTGGACTCTCTATGGGCCCAAGCTTTGCAGAGACTTCTACACGATAACTACAAGACGCCAGCTTAATGTGAGCAATCCGGCGGGAA"], ProbeFolding->False, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,ProbeHybridizing,"Do not model Probe-Probe pairing interactions:"},
		SimulateProbeSelection[DNA["GTGAATTACAAACAGGTTCTCTTTTTTCCAGAGTCAGCCTTAGACACGACCAATGCGGCACAGCGGTTTTACATCCACCTGACCAAATGACAATTGCACC"], ProbeHybridizing->False][[1;;10]],
		{Strand[DNA["CCGCTGTGCCGCATTGGTCG", "Probe"]], Strand[DNA["CGCTGTGCCGCATTGGTCGT", "Probe"]], Strand[DNA["ACCGCTGTGCCGCATTGGTC", "Probe"]], Strand[DNA["AACCGCTGTGCCGCATTGGT", "Probe"]], Strand[DNA["GCTGTGCCGCATTGGTCGTG", "Probe"]], Strand[DNA["AAACCGCTGTGCCGCATTGG", "Probe"]], Strand[DNA["CTGTGCCGCATTGGTCGTGT", "Probe"]], Strand[DNA["TGTGCCGCATTGGTCGTGTC", "Probe"]], Strand[DNA["TGTAAAACCGCTGTGCCGCA", "Probe"]], Strand[DNA["GTGCCGCATTGGTCGTGTCT", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["GTGAATTACAAACAGGTTCTCTTTTTTCCAGAGTCAGCCTTAGACACGACCAATGCGGCACAGCGGTTTTACATCCACCTGACCAAATGACAATTGCACC"], ProbeHybridizing->False] =
				SimulateProbeSelection[DNA["GTGAATTACAAACAGGTTCTCTTTTTTCCAGAGTCAGCCTTAGACACGACCAATGCGGCACAGCGGTTTTACATCCACCTGACCAAATGACAATTGCACC"], ProbeHybridizing->False, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,TargetFolding,"Do not model Target foldings:"},
		SimulateProbeSelection[DNA["ATATACGATCGACCAAATTAAGAACCTTTACTACGGGTTGAGATTTGAGCGATCGAGAGCACATTGCCGGTTGGATGGAGCGTTTTAGCTGTAAACCGCA"], TargetFolding->False][[1;;10]],
		{StrandP..},
		Stubs :> {
				SimulateProbeSelection[DNA["ATATACGATCGACCAAATTAAGAACCTTTACTACGGGTTGAGATTTGAGCGATCGAGAGCACATTGCCGGTTGGATGGAGCGTTTTAGCTGTAAACCGCA"], TargetFolding->False] =
				SimulateProbeSelection[DNA["ATATACGATCGACCAAATTAAGAACCTTTACTACGGGTTGAGATTTGAGCGATCGAGAGCACATTGCCGGTTGGATGGAGCGTTTTAGCTGTAAACCGCA"], TargetFolding->False, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,TargetHybridizing,"Do not model Target-Target pairing interactions:"},
		SimulateProbeSelection[DNA["CACCGTTTAGTAATAACATCTGGCCAAGGGCGCCACCTTTACCCATTTCTAAGGCGCCGAAACAGTGACCTGAGACCCTAAGATTGCTATATGGGGAAACCCACAACTCA"], TargetHybridizing->False][[1;;10]],
		{Strand[DNA["AGGTGGCGCCCTTGGCCAGA", "Probe"]], Strand[DNA["AAGGTGGCGCCCTTGGCCAG", "Probe"]], Strand[DNA["GGTGGCGCCCTTGGCCAGAT", "Probe"]], Strand[DNA["AAAGGTGGCGCCCTTGGCCA", "Probe"]], Strand[DNA["TGGCGCCCTTGGCCAGATGT", "Probe"]], Strand[DNA["GTGGCGCCCTTGGCCAGATG", "Probe"]], Strand[DNA["GGCGCCCTTGGCCAGATGTT", "Probe"]], Strand[DNA["TAAAGGTGGCGCCCTTGGCC", "Probe"]], Strand[DNA["TGGGTAAAGGTGGCGCCCTT", "Probe"]], Strand[DNA["ATGGGTAAAGGTGGCGCCCT", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection[DNA["CACCGTTTAGTAATAACATCTGGCCAAGGGCGCCACCTTTACCCATTTCTAAGGCGCCGAAACAGTGACCTGAGACCCTAAGATTGCTATATGGGGAAACCCACAACTCA"], TargetHybridizing->False] =
				SimulateProbeSelection[DNA["CACCGTTTAGTAATAACATCTGGCCAAGGGCGCCACCTTTACCCATTTCTAAGGCGCCGAAACAGTGACCTGAGACCCTAAGATTGCTATATGGGGAAACCCACAACTCA"], TargetHybridizing->False, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],

	Example[
		{Options,MinPairLevel,"Set the minimum number of base pairs to be considered in Pairing:"},
		SimulateProbeSelection["TGTATGGTTTGGAACCATTAGTTTGGGGAATCACCGAGCATCAATCCTGACTATTTGGTCGTGATAAAAGCCGAGCCTATAACCCTGGGG", MinPairLevel->8][[1;;10]],
		{Strand[DNA["CCCAGGGTTATAGGCTCGGC", "Probe"]], Strand[DNA["CCCCAGGGTTATAGGCTCGG", "Probe"]], Strand[DNA["TGATGCTCGGTGATTCCCCA", "Probe"]], Strand[DNA["CCAGGGTTATAGGCTCGGCT", "Probe"]], Strand[DNA["TGCTCGGTGATTCCCCAAAC", "Probe"]], Strand[DNA["GCTCGGTGATTCCCCAAACT", "Probe"]], Strand[DNA["TTGATGCTCGGTGATTCCCC", "Probe"]], Strand[DNA["GATGCTCGGTGATTCCCCAA", "Probe"]], Strand[DNA["ATGCTCGGTGATTCCCCAAA", "Probe"]], Strand[DNA["CAGGGTTATAGGCTCGGCTT", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection["TGTATGGTTTGGAACCATTAGTTTGGGGAATCACCGAGCATCAATCCTGACTATTTGGTCGTGATAAAAGCCGAGCCTATAACCCTGGGG", MinPairLevel->8] =
				SimulateProbeSelection["TGTATGGTTTGGAACCATTAGTTTGGGGAATCACCGAGCATCAATCCTGACTATTTGGTCGTGATAAAAGCCGAGCCTATAACCCTGGGG", MinPairLevel->8, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	Example[
		{Options,MinFoldLevel,"Set the minimum number of base pairs to be considered in Folding:"},
		SimulateProbeSelection["ACGGTCCTATTCGGCACCGTGAATTCCCATCCGCTAGGGTAGAAGATTCTAAGAATGGGTGGATTGTCGGTATGCTTAGGGTGATACTGT", MinFoldLevel->8][[1;;10]],
		{Strand[DNA["ACGGTGCCGAATAGGACCGT", "Probe"]], Strand[DNA["CACGGTGCCGAATAGGACCG", "Probe"]], Strand[DNA["TGGGAATTCACGGTGCCGAA", "Probe"]], Strand[DNA["ATGGGAATTCACGGTGCCGA", "Probe"]], Strand[DNA["AGCGGATGGGAATTCACGGT", "Probe"]], Strand[DNA["TCACGGTGCCGAATAGGACC", "Probe"]], Strand[DNA["GCGGATGGGAATTCACGGTG", "Probe"]], Strand[DNA["CGGATGGGAATTCACGGTGC", "Probe"]], Strand[DNA["GATGGGAATTCACGGTGCCG", "Probe"]], Strand[DNA["GGATGGGAATTCACGGTGCC", "Probe"]]},
		Stubs :> {
				SimulateProbeSelection["ACGGTCCTATTCGGCACCGTGAATTCCCATCCGCTAGGGTAGAAGATTCTAAGAATGGGTGGATTGTCGGTATGCTTAGGGTGATACTGT", MinFoldLevel->8] =
				SimulateProbeSelection["ACGGTCCTATTCGGCACCGTGAATTCCCATCCGCTAGGGTAGAAGATTCTAAGAATGGGTGGATTGTCGGTATGCTTAGGGTGATACTGT", MinFoldLevel->8, Upload->False]
			},
		EquivalenceFunction->RoundMatchQ[7],
		TimeConstraint->2000
	],
	(*(* An object on test Database *)
	Example[{Options, Options, "The options from a previous probe selection simulation can be used to current simulation:"},
		SimulateProbeSelection[DNA["CCTCATGCGTCGAAGCTATTCAGAGA"], Options -> Object[Simulation,ProbeSelection,"id:jLq9jXvpKn6q"]],
		{Strand[DNA["TCTCTGAATAGCTTCGACGC", "Probe"]], Strand[DNA["GAATAGCTTCGACGCATGAG", "Probe"]], Strand[DNA["AATAGCTTCGACGCATGAGG", "Probe"]], Strand[DNA["CTCTGAATAGCTTCGACGCA", "Probe"]], Strand[DNA["CTGAATAGCTTCGACGCATG", "Probe"]], Strand[DNA["TGAATAGCTTCGACGCATGA", "Probe"]], Strand[DNA["TCTGAATAGCTTCGACGCAT", "Probe"]]},
		Stubs :> {
			SimulateProbeSelection[DNA["CCTCATGCGTCGAAGCTATTCAGAGA"], Options -> Object[Simulation,ProbeSelection,"id:jLq9jXvpKn6q"]] =
			SimulateProbeSelection[DNA["CCTCATGCGTCGAAGCTATTCAGAGA"], Options -> Object[Simulation,ProbeSelection,"id:jLq9jXvpKn6q"], Upload->False]
		}
	],*)
	(* An object on Production Database *)
	(* Object[Simulation,ProbeSelection,"id:9RdZXv1W8AxK"] *)
	Example[
		{Options, Options, "The options from a previous probe selection simulation can be used to current simulation:"},
		SimulateProbeSelection["AATACGGTTTAATGGTCTGTCAACAAGAAGGCGTTGTACACCCCTACGCTAAATTGAGGGGTACTGGATACCGCGTTAAGCCAGAGGCATCGTCTGTCGA", Options -> Object[Simulation,ProbeSelection,"id:9RdZXv1W8AxK"]][[1;;10]],
		{Strand[DNA["TGCCTCTGGCTTAACGCGGT", "Probe"]], Strand[DNA["ACGCGGTATCCAGTACCCCT", "Probe"]], Strand[DNA["ATGCCTCTGGCTTAACGCGG", "Probe"]], Strand[DNA["GCGTAGGGGTGTACAACGCC", "Probe"]], Strand[DNA["CGACAGACGATGCCTCTGGC", "Probe"]], Strand[DNA["GCCTCTGGCTTAACGCGGTA", "Probe"]], Strand[DNA["AGCGTAGGGGTGTACAACGC", "Probe"]], Strand[DNA["ACAGACGATGCCTCTGGCTT", "Probe"]], Strand[DNA["AACGCGGTATCCAGTACCCC", "Probe"]], Strand[DNA["GACAGACGATGCCTCTGGCT", "Probe"]]},
		Stubs :> {
			SimulateProbeSelection["AATACGGTTTAATGGTCTGTCAACAAGAAGGCGTTGTACACCCCTACGCTAAATTGAGGGGTACTGGATACCGCGTTAAGCCAGAGGCATCGTCTGTCGA", Options -> Object[Simulation,ProbeSelection,"id:9RdZXv1W8AxK"]] =
			SimulateProbeSelection["AATACGGTTTAATGGTCTGTCAACAAGAAGGCGTTGTACACCCCTACGCTAAATTGAGGGGTACTGGATACCGCGTTAAGCCAGAGGCATCGTCTGTCGA", Options -> Object[Simulation,ProbeSelection,"id:9RdZXv1W8AxK"], Upload->False]
		},
		EquivalenceFunction->RoundMatchQ[30],
		TimeConstraint->2000
	],
	Example[{Options, Output, "Return specified fields (here are TargetPosition,  ProbeStrands):"},
		#[[1;;10]]&/@SimulateProbeSelection["ACUAUCGUUUAAGAACUUUUUCGUGACAAAGGCAAAUGAGUAUGAGGUCCAUCACAAUAUGUUAGAACACGUUACCGGGGAUCAACUCUGUCCGCCUGCA", Output -> {TargetPosition,  ProbeStrands}],
		{{{80, 99}, {81, 100}, {79, 98}, {29, 48}, {72, 91}, {58, 77}, {37, 56}, {47, 66}, {57, 76}, {78, 97}}, {Strand[RNA["GCAGGCGGACAGAGUUGAUC", "Probe"]], Strand[RNA["UGCAGGCGGACAGAGUUGAU", "Probe"]], Strand[RNA["CAGGCGGACAGAGUUGAUCC", "Probe"]], Strand[RNA["ACCUCAUACUCAUUUGCCUU", "Probe"]], Strand[RNA["ACAGAGUUGAUCCCCGGUAA", "Probe"]], Strand[RNA["CGGUAACGUGUUCUAACAUA", "Probe"]], Strand[RNA["UGUGAUGGACCUCAUACUCA", "Probe"]], Strand[RNA["UCUAACAUAUUGUGAUGGAC", "Probe"]], Strand[RNA["GGUAACGUGUUCUAACAUAU", "Probe"]], Strand[RNA["AGGCGGACAGAGUUGAUCCC", "Probe"]]}},
		Stubs :> {
			SimulateProbeSelection["ACUAUCGUUUAAGAACUUUUUCGUGACAAAGGCAAAUGAGUAUGAGGUCCAUCACAAUAUGUUAGAACACGUUACCGGGGAUCAACUCUGUCCGCCUGCA", Output -> {TargetPosition,  ProbeStrands}] =
			SimulateProbeSelection["ACUAUCGUUUAAGAACUUUUUCGUGACAAAGGCAAAUGAGUAUGAGGUCCAUCACAAUAUGUUAGAACACGUUACCGGGGAUCAACUCUGUCCGCCUGCA", Output -> {TargetPosition,  ProbeStrands}, Upload->False]
		},
		TimeConstraint->2000
	],

	Example[{Messages,"SiteShort","Throw a message and return $Failed when one of the input site length is shorter than MinPairLevel length:"},
		SimulateProbeSelection[RNA["AGGUCGACAGAUGCCAGCAGAUAAUAUCACCCUGUUCGAAAACGGCGUGGUGUAUACUGGUAGCCAGUAAGGUCCACGCACUCUGCCUAG"], {{1, 5}, {2, 6}, {3, 7}}],
		$Failed,
		Messages:>{SimulateProbeSelection::SiteShort,Error::InvalidOption},
		Stubs :> {
			SimulateProbeSelection[RNA["AGGUCGACAGAUGCCAGCAGAUAAUAUCACCCUGUUCGAAAACGGCGUGGUGUAUACUGGUAGCCAGUAAGGUCCACGCACUCUGCCUAG"], {{1, 5}, {2, 6}, {3, 7}}] =
			SimulateProbeSelection[RNA["AGGUCGACAGAUGCCAGCAGAUAAUAUCACCCUGUUCGAAAACGGCGUGGUGUAUACUGGUAGCCAGUAAGGUCCACGCACUCUGCCUAG"], {{1, 5}, {2, 6}, {3, 7}}, Upload->False]
		}
	],

	Example[{Messages,"ProbeShort","Throw a message and return $Failed when ProbeLength is less than MinPairLevel:"},
		SimulateProbeSelection[RNA["AGGUCGACAGAUGCCAGCAGAUAAUAUCACCCUGUUCGAAAACGGCGUGGUGUAUACUGGUAGCCAGUAAGGUCCACGCACUCUGCCUAG"],
			ProbeLength->10,MinPairLevel->15
		],
		$Failed,
		Messages:>{SimulateProbeSelection::ProbeShort,Error::InvalidOption}
	],

	Example[{Messages,"ProbeFoldFalse","Throw a message and return $Failed when ProbeFold is False but Beacon length is set to be nonzero:"},
		SimulateProbeSelection[RNA["CCAUCGGUGAAGAAGUAGCUCCAAGCGUAAGCUUCUUUGGUAGUGAAGAUCAUUAUUUUUGUCUUAGUGCGCGACUCAUUGGAGUCUCUG"],
			BeaconStemLength->3, ProbeFolding->False],
		$Failed,
		Messages:>{SimulateProbeSelection::ProbeFoldFalse,Error::InvalidOption}
	],

	Test["Insert new object:",
		SimulateProbeSelection[RNA["GUGAUUAGCUAUUUUAGUGGCUAAUGUAGUAAUAACAAAGCUAGGGCUAUUACGCUGCCAUAACAGAAGAUAAUGUUUGGGCCUCUCUGGACCCCGGUAGCAGGGUGACUAGAACUUUAGGAAGAGGGCCCAAAUCGAGUGGGCCAAGCUGAUGCUACGCGUUGUGGCUGGAAGUACUUAUUUUGCACUUGCCAUGAACG"], Upload->True, Output -> Object],
		ObjectReferenceP[Object[Simulation, ProbeSelection]],
		TimeConstraint->2000,
		Stubs :> {Print[_] := Null}
	]

}];


(* ::Section:: *)
(*End Test Package*)
