(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Thermodynamics: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* to handle unit mismatches between 12.0 and 12.2 *)
If[$VersionNumber>=12.2,
	 (
		 kilocaloriePerMoleString="ThermochemicalKilocalories" / "Moles";
		 caloriePerMoleKelvinString = "ThermochemicalCalories" / ("Kelvins" * "Moles");
	 ),
	 (
		 kilocaloriePerMoleString="KilocaloriesThermochemical"/"Moles";
		 caloriePerMoleKelvinString="CaloriesThermochemical" / ("Kelvins" * "Moles");
	 )
 ];

(* ::Subsection::Closed:: *)
(*Faces*)


(* ::Subsubsection::Closed:: *)
(*StructureFaces*)




DefineTests[StructureFaces,{
	Example[{Basic,"Faces of simple single stranded structure:"},
		StructureFaces[Structure[List[Strand[RNA["AAAGGGGUUUU"]]],List[Bond[List[1,1,Span[1,3]],List[1,1,Span[9,11]]]]]],
		{{"HairpinLoop",{3,9}},{"StackingLoop",{1,11},{2,10}},{"StackingLoop",{2,10},{3,9}}}
	],
	Example[{Basic,"Faces of a slightly more complicated single stranded structure:"},
		StructureFaces[Structure[List[Strand[RNA["GACUACUGAUCGGUAUCGUACGU"]]],List[Bond[List[1,1,Span[17,17]],List[1,1,Span[1,1]]],Bond[List[1,1,Span[16,16]],List[1,1,Span[2,2]]],Bond[List[1,1,Span[15,15]],List[1,1,Span[4,4]]],Bond[List[1,1,Span[14,14]],List[1,1,Span[5,5]]],Bond[List[1,1,Span[13,13]],List[1,1,Span[6,6]]],Bond[List[1,1,Span[12,12]],List[1,1,Span[7,7]]],Bond[List[1,1,Span[7,7]],List[1,1,Span[12,12]]],Bond[List[1,1,Span[6,6]],List[1,1,Span[13,13]]],Bond[List[1,1,Span[5,5]],List[1,1,Span[14,14]]],Bond[List[1,1,Span[4,4]],List[1,1,Span[15,15]]],Bond[List[1,1,Span[2,2]],List[1,1,Span[16,16]]],Bond[List[1,1,Span[1,1]],List[1,1,Span[17,17]]]]]],
		{{"HairpinLoop",{7,12}},{"BulgeLoop",{2,16},{4,15}},{"StackingLoop",{1,17},{2,16}},{"StackingLoop",{4,15},{5,14}},{"StackingLoop",{5,14},{6,13}},{"StackingLoop",{6,13},{7,12}}}
	],
	Example[{Basic,"Faces of a complicated single stranded structure with multiloops:"},
		StructureFaces[Structure[List[Strand[RNA["UAACGGCGGAUUAUUAAAUUUCAAGCACGAGCAGAAAACUAAUCCGCGUUUAGACGGCUAGACUAAAUAUAGCCGGCAGGCACAUUUGUAUGAUACCCCG"]]],List[Bond[List[1,1,Span[4,5]],List[1,1,Span[99,100]]],Bond[List[1,1,Span[6,13]],List[1,1,Span[40,47]]],Bond[List[1,1,Span[19,22]],List[1,1,Span[34,37]]],Bond[List[1,1,Span[25,26]],List[1,1,Span[31,32]]],Bond[List[1,1,Span[48,49]],List[1,1,Span[95,96]]],Bond[List[1,1,Span[55,60]],List[1,1,Span[70,75]]],Bond[List[1,1,Span[77,78]],List[1,1,Span[91,92]]],Bond[List[1,1,Span[80,82]],List[1,1,Span[87,89]]]]]],
		{{"HairpinLoop",{26,31}},{"HairpinLoop",{60,70}},{"HairpinLoop",{82,87}},{"InternalLoop",{13,40},{19,37}},{"InternalLoop",{22,34},{25,32}},{"InternalLoop",{78,91},{80,89}},{"StackingLoop",{4,100},{5,99}},{"StackingLoop",{6,47},{7,46}},{"StackingLoop",{7,46},{8,45}},{"StackingLoop",{8,45},{9,44}},{"StackingLoop",{9,44},{10,43}},{"StackingLoop",{10,43},{11,42}},{"StackingLoop",{11,42},{12,41}},{"StackingLoop",{12,41},{13,40}},{"StackingLoop",{19,37},{20,36}},{"StackingLoop",{20,36},{21,35}},{"StackingLoop",{21,35},{22,34}},{"StackingLoop",{25,32},{26,31}},{"StackingLoop",{48,96},{49,95}},{"StackingLoop",{55,75},{56,74}},{"StackingLoop",{56,74},{57,73}},{"StackingLoop",{57,73},{58,72}},{"StackingLoop",{58,72},{59,71}},{"StackingLoop",{59,71},{60,70}},{"StackingLoop",{77,92},{78,91}},{"StackingLoop",{80,89},{81,88}},{"StackingLoop",{81,88},{82,87}},{"MultipleLoop",{5,99},{6,47},{48,96}},{"MultipleLoop",{49,95},{55,75},{77,92}}}
	],
	Example[{Basic,"Faces of a simple multi-stranded structure:"},
		StructureFaces[Structure[List[Strand[Modification["Dabcyl",""],DNA["AGGACTGATGTG","A"],DNA["ATCAACATGCAG","B"]],Strand[RNA["UUUUUU","D"],DNA["ATCGATCGTCAG","E"],RNA["UGUGUGUGUG","F"]]],List[Bond[List[1,3,Span[4,8]],List[2,2,Span[2,6]]]]]],
		{{"StackingLoop",{17,37},{18,36}},{"StackingLoop",{18,36},{19,35}},{"StackingLoop",{19,35},{20,34}},{"StackingLoop",{20,34},{21,33}}}
	],
	Example[{Basic,"Faces of a slightly more complicated multi stranded structure:"},
		StructureFaces[Structure[List[Strand[RNA["AACGCGGCGCC","X"],RNA["CGGCGCC","Y"],RNA["AAAAGCGGCGCCU","Z"]],Strand[RNA["AACGCGGCGCC","X"],RNA["CGGCGCC","Y"],RNA["AACGCGGCGCCU","Z"]],Strand[RNA["AACGCGGCGCC","X"],RNA["CGGCGCC","Y"],RNA["UUUUUUUUUU","D"]]],List[Bond[List[1,3,Span[5,6]],List[2,1,Span[4,5]]],Bond[List[2,3,Span[3,4]],List[1,2,Span[1,2]]],Bond[List[1,3,Span[1,3]],List[3,3,Span[6,8]]]]]],
		{{"InternalLoop",{13,52},{23,36}},{"StackingLoop",{12,53},{13,52}},{"StackingLoop",{19,87},{20,86}},{"StackingLoop",{20,86},{21,85}},{"StackingLoop",{23,36},{24,35}}}
	],
	Example[{Additional,"Perfect Binding","Faces of two perfectly bound strands:"},
		StructureFaces[Structure[{Strand[RNA["CCCC"]],Strand[RNA["GGGG"]]},{Bond[{1,1,1;;4},{2,1,1;;4}]}]],
		{{"StackingLoop",{1,8},{2,7}},{"StackingLoop",{2,7},{3,6}},{"StackingLoop",{3,6},{4,5}}}
	]
}];



(* ::Subsection::Closed:: *)
(*Enthalpy*)

(* ::Subsubsection:: *)
(*SimulateEnthalpy*)

DefineTestsWithCompanions[SimulateEnthalpy,
	{

		Example[{Basic,"Compute the enthalpy of a hybridization reaction between given strand and its reverse complement:"},
			SimulateEnthalpy["GGACTGACGCGTTGA"][Enthalpy],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["GGACTGACGCGTTGA"] =
				SimulateEnthalpy["GGACTGACGCGTTGA",Upload->False]
			}
		],

		Test["Preview shows energy when computing the enthalpy of a hybridization reaction between given strand and its reverse complement:",
			SimulateEnthalpy["GGACTGACGCGTTGA", Output->Preview],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Compute the enthalpy of a hybridization reaction between given strand and its reverse complement:",
			SimulateEnthalpy["GGACTGACGCGTTGA",Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-119.1, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic, "Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the change in enthalpy:"},
			SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"]][Enthalpy],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"]] =
				SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],Upload->False]
			}
		],

		Test["Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the change in enthalpy:",
			SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-119.1, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]][Enthalpy],
			Quantity[-23.999999999999996, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]] =
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-23.999999999999996, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateEnthalpy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]][Enthalpy],
			Quantity[-23.999999999999996, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]] =
				SimulateEnthalpy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateEnthalpy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-23.999999999999996, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Compute the enthalpy from a simple ReactionMechanism contains only one reaction:"},
			SimulateEnthalpy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]][Enthalpy],
			Quantity[-191.9, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]] =
				SimulateEnthalpy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],Upload->False]
			}
		],

		Test["Compute the enthalpy from a simple ReactionMechanism contains only one reaction:",
			SimulateEnthalpy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		Test["Compute the enthalpy from a simple Reaction contains only one reaction:",
			SimulateEnthalpy[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		(*
			ADDITIONAL
		*)
		Example[{Additional, "Pull strand from given sample:"},
			SimulateEnthalpy[Object[Sample, "id:jLq9jXY0ZXra"]][Enthalpy],
			Quantity[-151.5, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Object[Sample, "id:jLq9jXY0ZXra"]] =
				SimulateEnthalpy[Object[Sample, "id:jLq9jXY0ZXra"],Upload->False]
			}
		],

		Test["Pull strand from given sample:",
			SimulateEnthalpy[Object[Sample, "id:jLq9jXY0ZXra"],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-151.5, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]}, {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				Round->5
			]
		],

		Example[{Additional, "Pull strand from given model:"},
			SimulateEnthalpy[Model[Sample,"F dsRed1"]][Enthalpy],
			Quantity[-151.5, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Sample,"F dsRed1"]] =
				SimulateEnthalpy[Model[Sample,"F dsRed1"],Upload->False][[1]]
			}
		],

		Test["Pull strand from given model:",
			SimulateEnthalpy[Model[Sample,"F dsRed1"],Upload->False][[1]],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-151.5, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]}, {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				Round->5
			]
		],

		Example[{Additional, "Given reaction model:"},
			SimulateEnthalpy[testReaction][Enthalpy],
			Quantity[-151.5, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Reaction,"Hybridization test"<>rxnUUID]] =
				SimulateEnthalpy[Model[Reaction,"Hybridization test"<>rxnUUID],Upload->False]
			}
		],

		Test["Given reaction model:",
			SimulateEnthalpy[testReaction,Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-151.5, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]}, {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]}, Hybridization],
					ReactionModel->Link[Model[Reaction,_String],EnthalpySimulations],
					Append[ProductModels]->{LinkP[Model[Molecule, Oligomer]]}
				},
				Round->5
			]
		],

		Example[{Additional, "Given structure, computes enthalpy of all bonded regions:"},
			SimulateEnthalpy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]][Enthalpy],
			Quantity[-111.8, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]] =
				SimulateEnthalpy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],Upload->False]
			}
		],

		Test["Given structure, computes enthalpy of all bonded regions:",
			SimulateEnthalpy[Structure[{Strand[DNA["AAAAA"]],Strand[DNA["TTTTT"]]},{Bond[{1,1},{2,1}]}],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-27.000000000000004, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["AAAAA"]]}, {}], Structure[{Strand[DNA["TTTTT"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["AAAAA"]], Strand[DNA["TTTTT"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AAAAA"]]}, {}], Structure[{Strand[DNA["TTTTT"]]}, {}]}, {Structure[{Strand[DNA["AAAAA"]], Strand[DNA["TTTTT"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Additional, "Given a strand:"},
			SimulateEnthalpy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]]][Enthalpy],
			Quantity[-108.485, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]]] =
				SimulateEnthalpy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],Upload->False]
			}
		],
		
		Example[{Additional, "Given an oligomer molecule model:"},
			SimulateEnthalpy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID]][Enthalpy],
			Quantity[-76.6, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID]] =
					SimulateEnthalpy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID],Upload->False]
			}
		],

		Test["Given a strand:",
			SimulateEnthalpy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-108.485, kilocaloriePerMoleString]
				},
				Round->5
			]
		],

		Example[{Additional, "Given a typed sequence:"},
			SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]][Enthalpy],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[DNA["GGACTGACGCGTTGA"]] =
				SimulateEnthalpy[DNA["GGACTGACGCGTTGA"],Upload->False]
			}
		],

		Test["Given a typed sequence:",
			SimulateEnthalpy[DNA["GGACTGACGCGTTGA"],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-119.1, kilocaloriePerMoleString]
				},
				Round->5
			]
		],

		Example[{Additional, "Compute the distribution of Enthalpy of all DNA 15-mer hybridization reactions with their reverse complements:"},
			SimulateEnthalpy[DNA[15]][EnthalpyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[DNA[15]] =
				SimulateEnthalpy[DNA[15],Upload->False]
			}
		],

		Test["Preview shows energy distribution when computing the distribution of Enthalpy of all DNA 15-mer hybridization reactions with their reverse complements:",
			SimulateEnthalpy[DNA[15], Output->Preview],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Compute the distribution of Enthalpy of all DNA 15-mer hybridization reactions with their reverse complements:",
			SimulateEnthalpy[DNA[15],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					EnthalpyDistribution->DistributionP[KilocaloriePerMole],
					Append[Reactants]->{Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]]}, {}], Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]], Strand[DNA["NNNNNNNNNNNNNNN"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]]}, {}], Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]]}, {}]}, {Structure[{Strand[DNA["NNNNNNNNNNNNNNN"]], Strand[DNA["NNNNNNNNNNNNNNN"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Additional, "Given untyped length:"},
			SimulateEnthalpy[15][EnthalpyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[15] =
				SimulateEnthalpy[15, Upload->False]
			}
		],

		Test["Given untyped length:",
			SimulateEnthalpy[15, Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					EnthalpyDistribution->DistributionP[KilocaloriePerMole]
				},
				Round->5
			]
		],

		Example[{Additional, "Structure with no bonds returns zero:"},
			SimulateEnthalpy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]][Enthalpy],
			N@Quantity[0, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]] =
				SimulateEnthalpy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False]
			}
		],

		Test["Structure with no bonds returns zero:",
			SimulateEnthalpy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->N@Quantity[0, kilocaloriePerMoleString]
				},
				Round->5
			]
		],

		Example[{Additional,"Can handle degenerate sequence:"},
			SimulateEnthalpy["ATCNNNATNNN"][EnthalpyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["ATCNNNATNNN"] =
				SimulateEnthalpy["ATCNNNATNNN",Upload->False]
			}
		],

		Test["Can handle degenerate sequence:",
			SimulateEnthalpy["ATCNNNATNNN",Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
				}
			]
		],

		Test["Given oligomer sample packet:",
			SimulateEnthalpy[<|Object->Object[Sample, "id:jLq9jXY0ZXra"], Type->Object[Sample], Composition->{{Quantity[100, IndependentUnit["MassPercent"]], ECL`Link[ECL`Model[Molecule, ECL`Oligomer, "id:Z1lqpMzRZlWW"], "R8e1PjVdpNOv"]}, {Null, Null}}, Model->Model[Sample,"F dsRed1"],Strand->{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}|>,Upload->False],
			validSimulationPacketP[Object[Simulation, Enthalpy],
				{
					Enthalpy->Quantity[-151.5, kilocaloriePerMoleString],
					Append[ReactantModels]->{LinkP[Model[Molecule,Oligomer],Simulations]}
				},
				Round->5
			]
		],

		Test["Oligomer model gets updated correctly:",
			SimulateEnthalpy[Model[Sample, "id:KBL5DvYOlGPj"],Upload->False],
			{
				validSimulationPacketP[Object[Simulation, Enthalpy],
					{
						Enthalpy->Quantity[-73.6, kilocaloriePerMoleString],
						Append[ReactantModels]->{LinkP[Model[Molecule,Oligomer],Simulations]}
					},
					Round->5
				],
				<|
					Object->Model[Molecule, Oligomer, "id:N80DNj16KvAo"],
					Enthalpy ->Quantity[-73.6, kilocaloriePerMoleString]
				|>
			},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Additional, "Return enthalpy distribution instead of mean:"},
			SimulateEnthalpy["GGACTGACGCGTTGA"][EnthalpyDistribution],
			DataDistribution["Empirical", {{1.}, {-119.1}, False}, 1, 1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["GGACTGACGCGTTGA"] =
				SimulateEnthalpy["GGACTGACGCGTTGA", Upload->False]
			}
		],

		(*
			OPTIONS
		*)
		Example[{Options,Polymer,"Specify polymer for untyped sequences:"},
			{
				SimulateEnthalpy["CGCGCG",Polymer->DNA][Enthalpy],
				SimulateEnthalpy["CGCGCG",Polymer->RNA][Enthalpy]
			},
			{Quantity[-51.199999999999996, kilocaloriePerMoleString], Quantity[-58.07000000000001, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["CGCGCG",Polymer->DNA] = SimulateEnthalpy["CGCGCG",Upload->False,Polymer->DNA],
				SimulateEnthalpy["CGCGCG",Polymer->RNA] = SimulateEnthalpy["CGCGCG",Upload->False,Polymer->RNA]
			}
		],

		Example[{Options,ReactionType,"Given an object, specify if the strands should be hybridized or the structure melted:"},
			SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting][Enthalpy],
			Quantity[0., kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting] = SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			{
				SimulateEnthalpy["CGCGCG",Polymer->DNA,Upload->False][Enthalpy],
				SimulateEnthalpy["CGCGCG",Polymer->DNA,ThermodynamicsModel->modelThermodynamicsXNASimulateEnthalpyPacket,Upload->False][Enthalpy]
			},
			{Quantity[-51.199999999999996, kilocaloriePerMoleString], Quantity[-19.400000000000002`, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,AlternativeParameterization,"Using AlternativeParameterization to specially useful if there is no thermo properties in the original polymer:"},
			SimulateEnthalpy["mAmU",Polymer->LNAChimera,AlternativeParameterization->True,Upload->False][Enthalpy],
			Quantity[1.67, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options, Template, "The Options from a previous enthalpy simulation (object reference) can be used to preform an identical simulation on new oligomer:"},
			SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID,ResolvedOptions]][Enthalpy],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID,ResolvedOptions]] =
				SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID,ResolvedOptions], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Enthalpy], UnresolvedOptions->{}, ResolvedOptions->{Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Template, "The Options from a previous enthalpy simulation (object) can be used to preform an identical simulation on new oligomer:"},
			SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID]][Enthalpy],
			Quantity[-119.1, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID]] =
				SimulateEnthalpy["GGACTGACGCGTTGA", Template->Object[Simulation,Enthalpy,theTemplateObjectID], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Enthalpy], UnresolvedOptions->{}, ResolvedOptions->{Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		(*
			OVERLOADS
		*)
		Test["Maps over input and preview shows either energy or energy distribution as appropriate:",
			SimulateEnthalpy[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["GGACTGACGCGTTGA"]],Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]}, Output->Preview],
			{Quantity[-119.1, kilocaloriePerMoleString], DistributionP[KilocaloriePerMole], Quantity[-119.1, kilocaloriePerMoleString], Quantity[-23.999999999999996, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Maps over input:",
			SimulateEnthalpy[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["GGACTGACGCGTTGA"]],Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]},Upload->False],
			{
				validSimulationPacketP[Object[Simulation, Enthalpy],
					{
					},
					Round->5
				],
				validSimulationPacketP[Object[Simulation, Enthalpy],
					{
					},
					Round->5
				],
				validSimulationPacketP[Object[Simulation, Enthalpy],
					{
					},
					Round->5
				],
				validSimulationPacketP[Object[Simulation, Enthalpy],
					{
					},
					Round->5
				]
			}
		],

		(*
			MESSAGES
		*)
		Example[{Messages,"InvalidStrand","Given an invalid strand:"},
			SimulateEnthalpy[Strand[DNA["AFTCG"]]],
			$Failed,
			Messages:>{Error::InvalidStrand,Error::InvalidInput}
		],

		(** TODO: remove this all polymers should be supported now **)
		(* Example[{Messages,"UnsupportedPolymers","Given strand with unsupported polymers:"},
			SimulateEnthalpy[Strand[DNA["ATCG"],PNA["ATCG"],Modification["Fluorescein"]]],
			$Failed,
			Messages:>{Error::UnsupportedPolymers,Error::InvalidInput}
		], *)

		Example[{Messages,"BadPolymerType","Specified polymer type does not match input:"},
			SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide][Enthalpy],
			Quantity[-23.999999999999996, kilocaloriePerMoleString],
			Messages:>{Warning::BadPolymerType},
			Stubs :> {
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide] =
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide, Upload->False]
			}
		],

		Example[{Messages,"InvalidThermoInput","Given structure with bad polymers:"},
			SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]],
			$Failed,
			Messages:>{Error::InvalidThermoInput,Error::InvalidInput},
			Stubs :> {
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]] =
				SimulateEnthalpy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}], Upload->False]
			}
		],

		Example[{Messages,"InvalidSequence","Given invalid sequence:"},
			SimulateEnthalpy["FFFF"],
			$Failed,
			Messages:>{Error::InvalidSequence,Error::InvalidInput}
		],

		Example[{Messages,"LengthExceedMax", "Given sequence that is too long:"},
			SimulateEnthalpy[500000],
			$Failed,
			Messages:>{Error::LengthExceedMax,Error::InvalidInput}
		],

		Example[{Messages,"InvalidPolymerType", "With vague integer-type polymer and polymer option Null, a warning is shown and polymer option switches to Automatic:"},
			SimulateEnthalpy[15, Polymer->Null][EnthalpyDistribution],
			DistributionP[kilocaloriePerMoleString],
			Messages:>{Warning::InvalidPolymerType,Warning::BadPolymerType},
			Stubs :> {
				SimulateEnthalpy[15, Polymer->Null] = SimulateEnthalpy[15, Polymer->Null, Upload->False]
			}
		],

		Example[{Messages, "UnsupportedMechanism", "Given ReactionMechanism that is too complicated:"},
			SimulateEnthalpy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]],
			$Failed,
			Messages :> {Error::UnsupportedMechanism,Error::InvalidInput}
		],

		Example[{Messages,"ReactionTypeNull","Given an object and ReactionType set to Null:"},
			SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Null][Enthalpy],
			Quantity[-151.5, kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeNull},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Null] = SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Null, Upload->False][[1]]
			}
		],

		Example[{Messages,"ReactionTypeWarning","Given an object with no bonds and ReactionType set to Melting:"},
			SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting][Enthalpy],
			Quantity[0., kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting] = SimulateEnthalpy[Model[Sample, "F dsRed1"], ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct	pattern:"},
		 SimulateEnthalpy["GGACTGACGCGTTGA", ThermodynamicsModel -> Null],
		 $Failed,
		 Messages :> {Error::InvalidThermodynamicsModel,
		   Error::InvalidOption}],

		Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
		 SimulateEnthalpy["GGACTGACGCGTTGA", AlternativeParameterization -> True][Enthalpy],
		 Quantity[-119.1, kilocaloriePerMoleString],
		 EquivalenceFunction -> RoundMatchQ[5],
		 Messages :> {Warning::AlternativeParameterizationNotAvailable}],

		Test["UnresolvedOptions or undefined options causes failure:",
			SimulateEnthalpy["ATCG",Upload->False,Plus->True,Polymer->"string"],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
		],

		Test["Degenerate sequence distribution calculation:",
			SimulateEnthalpy["NNNN", Upload->False][EnthalpyDistribution],
			DataDistribution["Empirical", {{0.00390625, 0.00390625, 0.0234375, 0.0078125, 0.015625, 0.015625, 0.02734375, 0.0078125, 0.015625, 0.0078125, 0.01953125, 0.015625, 0.0234375, 0.0078125, 0.03125, 0.015625, 0.015625, 0.01171875, 0.015625, 0.04296875, 0.015625, 0.0078125, 0.00390625, 0.0234375, 0.015625, 0.0078125, 0.0078125, 0.00390625, 0.01171875, 0.01171875, 0.01171875, 0.01171875, 0.0234375, 0.00390625, 0.03125, 0.0390625, 0.015625, 0.0078125, 0.015625, 0.0078125, 0.0078125, 0.0078125, 0.015625, 0.015625, 0.03125, 0.015625, 0.0078125, 0.015625, 0.00390625, 0.0078125, 0.0234375, 0.0078125, 0.0078125, 0.0234375, 0.0078125, 0.015625, 0.0078125, 0.0078125, 0.03125, 0.0078125, 0.03125, 0.0078125, 0.015625, 0.015625, 0.0234375, 0.0234375, 0.0078125}, {-30.8, -30.000000000000004, -28.200000000000003, -27.3, -27., -26.500000000000004, -26.400000000000002, -26.2, -25.900000000000002, -25.8, -25.6, -24.7, -24.6, -24.5, -24.400000000000002, -24.3, -24.1, -24., -23.900000000000002, -23.8, -23.7, -23.6, -23.4, -23.200000000000003, -23.1, -23., -22.9, -22.799999999999997, -22.700000000000003, -22.699999999999996, -22.6, -22.400000000000002, -22.3, -22.2, -22.1, -22., -21.9, -21.800000000000004, -21.799999999999997, -21.700000000000003, -21.6, -21.5, -21.4, -21.3, -21.200000000000003, -21.1, -21., -20.9, -20.8, -20.6, -20.5, -20.400000000000002, -20.299999999999997, -20.200000000000003, -20.1, -20., -19.8, -19.6, -19.5, -19.4, -19.3, -19.1, -18.799999999999997, -18.6, -18.4, -17.700000000000003, -17.}, False}, 1, 256, kilocaloriePerMoleString],
			EquivalenceFunction -> RoundMatchQ[5]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {testReaction, rxnUUID},
	SymbolSetUp:>{

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allDataObjects,allObjects,existingObjects,
				testReactionObject, testOligomerObject
			},

			(* create a new reaction model object for testing *)
			rxnUUID = CreateUUID[];
			testReactionObject = Model[Reaction, "Hybridization test"<>rxnUUID];
			testOligomerObject = Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID];

			(* All data objects generated for unit tests *)
			allDataObjects=
				{
					testReactionObject,
					testOligomerObject
				};

			allObjects=allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNASimulateEnthalpyPacket=
			<|
				Name->"XNASimulateEnthalpy"<>rxnUUID,
				Type->Model[Physics,Thermodynamics],
				Replace[Authors]->Link[$PersonID],
				Replace[StackingEnergy]->Join[stackingEnergy,stackingEnergyRNA],
				Replace[StackingEnthalpy]->Join[stackingEnthalpy,stackingEnthalpyRNA],
				Replace[StackingEntropy]->Join[stackingEntropy,stackingEntropyRNA],
				Replace[InitialEnergyCorrection]->{{DNA,DNA,1.96` KilocaloriePerMole},{DNA,RNA,3.1` KilocaloriePerMole}},
				Replace[InitialEnthalpyCorrection]->{{DNA,DNA,0.2` KilocaloriePerMole},{DNA,RNA,1.9` KilocaloriePerMole}},
				Replace[InitialEntropyCorrection]->{{DNA,DNA,-5.6` CaloriePerMoleKelvin},{DNA,RNA,-3.9` CaloriePerMoleKelvin}},
				Replace[TerminalEnergyCorrection]->{{DNA,DNA,0.05` KilocaloriePerMole}},
				Replace[TerminalEnthalpyCorrection]->{{DNA,DNA,2.2` KilocaloriePerMole}},
				Replace[TerminalEntropyCorrection]->{{DNA,DNA,6.9` CaloriePerMoleKelvin}},
				Replace[SymmetryEnergyCorrection]->{{DNA,DNA,0.43` KilocaloriePerMole}},
				Replace[SymmetryEntropyCorrection]->{{DNA,DNA,-1.4` CaloriePerMoleKelvin}},
				DeveloperObject->True
			|>;

		testReactionPacket = <|
			Type->Model[Reaction],
			Name->"Hybridization test"<>rxnUUID,
			Replace[ProductModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[ReactantModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[Reactants] -> {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			Replace[Reaction] -> Reaction[
				{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			  {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
			  Hybridization],
			Replace[ReactionProducts] -> {
				Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]},
		    {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]
			},
			Replace[ReactionType] -> Hybridization,
			Replace[ReverseRate] -> Null
		|>;
		
		testOligomerPacket = <|
			Type -> Model[Molecule,Oligomer],
			Molecule -> Strand["ATTATACGCTT"],
			Name -> "Oligomer test"<>rxnUUID
		|>;

		(* Creating the XNA model thermodynamics object *)
		{modelThermodynamicsXNASimulateEnthalpyObject, testReaction, testOligomerObject}=Upload[
			{modelThermodynamicsXNASimulateEnthalpyPacket, testReactionPacket, testOligomerPacket}
		];

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}


	(* SetUp :> ($CreatedObjects = {};),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	) *)
];

(* ::Subsection::Closed:: *)
(*Entropy*)

(* ::Subsubsection:: *)
(*SimulateEntropy*)

DefineTestsWithCompanions[SimulateEntropy,
	{

		Example[{Basic, "Compute the entropy of a hybridization reaction between given sequence and its reverse complement:"},
			SimulateEntropy["GGACTGACGCGTTGA"][Entropy],
			(* Quantity[-335.23401267335015`,caloriePerMoleKelvinString],*)
			Quantity[-335.23401267335015`,  caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy["GGACTGACGCGTTGA"] =
				SimulateEntropy["GGACTGACGCGTTGA", Upload->False]
			}
		],

		Test["Preview shows energy when computing the entropy of a hybridization reaction between given sequence and its reverse complement:",
			SimulateEntropy["GGACTGACGCGTTGA", Output->Preview],
			(* Quantity[-335.23401267335015`,caloriePerMoleKelvinString],*)
			Quantity[-335.23401267335015`,  caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Compute the entropy of a hybridization reaction between given sequence and its reverse complement:",
			SimulateEntropy["GGACTGACGCGTTGA", Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
					Entropy->Quantity[-335.23401267335015`, caloriePerMoleKelvinString],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic, "Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the change in entropy:"},
			SimulateEntropy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"]][Entropy],
			Quantity[-335.23401267335015`, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"]] =
				SimulateEntropy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], Upload->False]
			}
		],

		Test["Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the change in entropy:",
			SimulateEntropy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Entropy],
				{
					Entropy->Quantity[-335.23401267335015`, caloriePerMoleKelvinString],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic,"Specify reaction from one structure to another:"},
			SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]][Entropy],
			Quantity[-69.90166048686118, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]] =
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}], Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
					Entropy->Quantity[-69.90166048686118, caloriePerMoleKelvinString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic,"Specify reaction from one structure to another:"},
			SimulateEntropy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]][Entropy],
			Quantity[-69.90166048686118, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]] =
				SimulateEntropy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding], Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateEntropy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
					Entropy->Quantity[-69.90166048686118, caloriePerMoleKelvinString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Compute the entropy from a simple ReactionMechanism contains only one reaction:"},
			SimulateEntropy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]][Entropy],
			Quantity[-524.6493632113494, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]] =
				SimulateEntropy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]], Upload->False]
			}
		],

		Test["Compute the entropy from a simple ReactionMechanism contains only one reaction:",
			SimulateEntropy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Entropy],
				{
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		Test["Compute the entropy from a simple Reaction contains only one reaction:",
			SimulateEntropy[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Entropy],
				{
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		(*
			ADDITIONAL
		*)
		Example[{Additional,"Pull strand from given sample:"},
			SimulateEntropy[Object[Sample, "id:jLq9jXY0ZXra"]][Entropy],
			Quantity[-421.2437305800216`, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Object[Sample, "id:jLq9jXY0ZXra"]] =
				SimulateEntropy[Object[Sample, "id:jLq9jXY0ZXra"], Upload->False]
			}
		],

		Test["Pull strand from given sample:",
			SimulateEntropy[Object[Sample, "id:jLq9jXY0ZXra"],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{}
			]
		],

		Example[{Additional, "Pull strand from given model:"},
			SimulateEntropy[Model[Sample,"F dsRed1"]][Entropy],
			Quantity[-421.2437305800216`, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Sample,"F dsRed1"]] =
				SimulateEntropy[Model[Sample,"F dsRed1"], Upload->False][[1]]
			}
		],

		Test["Pull strand from given model:",
			SimulateEntropy[Model[Sample,"F dsRed1"], Upload->False][[1]],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Example[{Additional, "Given reaction model:"},
			SimulateEntropy[Model[Reaction,"Hybridization test"<>rxnUUID]][Entropy],
			Quantity[-421.2437305800216`,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Reaction,"Hybridization test"<>rxnUUID]] =
				SimulateEntropy[Model[Reaction,"Hybridization test"<>rxnUUID], Upload->False]
			}
		],

		Example[{Additional,"Given structure, computes entropy of all bonded regions:"},
			SimulateEntropy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]][Entropy],
			Quantity[-300.91891020473963, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]] =
				SimulateEntropy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}], Upload->False]
			}
		],

		Test["Given structure, computes entropy of all bonded regions:",
			SimulateEntropy[Structure[{Strand[DNA["CC"],DNA["AAAAA"],DNA["CC"]],Strand[DNA["AT"],DNA["TTTTT"],DNA["AT"]]},{Bond[{1,2},{2,2}]}],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{}
			]
		],

		Example[{Additional, "Given a strand:"},
			SimulateEntropy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]]][Entropy],
			Quantity[-314.0315831966823`,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]]] =
				SimulateEntropy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]], Upload->False]
			}
		],

		Test["Given a strand:",
			SimulateEntropy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Example[{Additional, "Given a typed sequence:"},
			SimulateEntropy[DNA["GGACTGACGCGTTGA"]][Entropy],
			Quantity[-335.23401267335015`,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[DNA["GGACTGACGCGTTGA"]] =
				SimulateEntropy[DNA["GGACTGACGCGTTGA"], Upload->False]
			}
		],

		Test["Given a typed sequence:",
			SimulateEntropy[DNA["GGACTGACGCGTTGA"],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],
		
		Example[{Additional, "Given an oligomer molecule model:"},
			SimulateEntropy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID]][Entropy],
			Quantity[-225.624, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID]] =
					SimulateEntropy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID],Upload->False]
			}
		],

		Example[{Additional,"Compute the distribution of Entropy of all DNA 15-mer hybridization reactions with their reverse complements:"},
			SimulateEntropy[DNA[15]][EntropyDistribution],
			DistributionP[CaloriePerMoleKelvin],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[DNA[15]] =
				SimulateEntropy[DNA[15], Upload->False]
			}
		],

		Test["Preview shows energy distribution when computing the distribution of Entropy of all DNA 15-mer hybridization reactions with their reverse complements:",
			SimulateEntropy[DNA[15], Output->Preview],
			DistributionP[CaloriePerMoleKelvin],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Compute the distribution of Entropy of all DNA 15-mer hybridization reactions with their reverse complements:",
			SimulateEntropy[DNA[15],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{}
			]
		],

		Example[{Additional, "Given untyped length:"},
			SimulateEntropy[15][EntropyDistribution],
			DistributionP[CaloriePerMoleKelvin],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[15] =
				SimulateEntropy[15, Upload->False]
			}
		],

		Test["Given untyped length:",
			SimulateEntropy[15, Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Example[{Additional, "Structure with no bonds returns zero:"},
			SimulateEntropy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]][Entropy],
			N@Quantity[0,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]] =
				SimulateEntropy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}], Upload->False]
			}
		],

		Test["Structure with no bonds returns zero:",
			SimulateEntropy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Test["Given oligomer sample packet:",
			SimulateEntropy[<|Object->Object[Sample, "id:jLq9jXY0ZXra"], Composition->{{Quantity[100, IndependentUnit["MassPercent"]], ECL`Link[ECL`Model[Molecule, ECL`Oligomer, "id:Z1lqpMzRZlWW"], "R8e1PjVdpNOv"]}, {Null, Null}}, Type->Object[Sample], Model->Model[Sample,"F dsRed1"],Strand->{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}|>,Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
					Entropy->Quantity[-421.2437305800216`,caloriePerMoleKelvinString],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				NullFields->{ReactionModel},
				Round->5
			]
		],

		Example[{Additional, "Can handle degenerate sequence:"},
			SimulateEntropy["ATCNNNATNNN"][EntropyDistribution],
			DistributionP[CaloriePerMoleKelvin],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy["ATCNNNATNNN"] =
				SimulateEntropy["ATCNNNATNNN", Upload->False]
			}
		],

		Test["Can handle degenerate sequence:",
			SimulateEntropy["ATCNNNATNNN",Upload->False],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
					EntropyDistribution->DistributionP[CaloriePerMoleKelvin]
				},
				Round->5
			]
		],

		Test["Oligomer model gets updated correctly:",
			SimulateEntropy[Model[Sample, "id:KBL5DvYOlGPj"], Upload->False],
			{
				validSimulationPacketP[Object[Simulation, Entropy],
					{
						Entropy ->	Quantity[-211.3218652900108, caloriePerMoleKelvinString],
						Append[ReactantModels]->{LinkP[Model[Molecule, Oligomer],Simulations]}
					},
					Round->5
				],
				<|
					Object->Model[Molecule, Oligomer, "id:N80DNj16KvAo"],
					Entropy ->	Quantity[-211.3218652900108, caloriePerMoleKelvinString]
				|>
			},
			EquivalenceFunction->RoundMatchQ[5]
		],



		(*
			OPTIONS
		*)
		Example[{Options,Polymer,"Specify polymer for untyped sequences:"},
			{
				SimulateEntropy["CGCGCG",Polymer->DNA][Entropy],
				SimulateEntropy["CGCGCG",Polymer->RNA][Entropy]
			},
			{Quantity[-142.91214738333935`,caloriePerMoleKelvinString], Quantity[-162.31214738333935`,caloriePerMoleKelvinString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy["CGCGCG",Polymer->DNA] = SimulateEntropy["CGCGCG", Polymer->DNA, Upload->False],
				SimulateEntropy["CGCGCG",Polymer->RNA] = SimulateEntropy["CGCGCG", Polymer->RNA, Upload->False]
			}
		],

		Example[{Options,ReactionType,"Given an object, specify if the strands should be hybridized or the structure melted:"},
			SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting][Entropy],
			Quantity[0.,caloriePerMoleKelvinString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting] = SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			{
				SimulateEntropy["CGCGCG",Polymer->DNA, Upload->False][Entropy],
				SimulateEntropy["CGCGCG",Polymer->DNA, ThermodynamicsModel->modelThermodynamicsXNASimulateEntropyPacket, Upload->False][Entropy]
			},
			{
				Quantity[-142.91214738333935`,caloriePerMoleKelvinString],
				Quantity[-61.31214738333934`,caloriePerMoleKelvinString]
			},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,AlternativeParameterization,"Using AlternativeParameterization to specially useful if there is no thermo properties in the original polymer:"},
			SimulateEntropy["mAmU",Polymer->LNAChimera,AlternativeParameterization->True,Upload->False][Entropy],
			Quantity[-9.70243, caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,MonovalentSaltConcentration,"Specify concentration monovalent salt ions in buffer:"},
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], MonovalentSaltConcentration->100Millimolar][Entropy],
			Quantity[-331.6629183991053,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], MonovalentSaltConcentration->100Millimolar] =
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], MonovalentSaltConcentration->100Millimolar, Upload->False]
			}
		],

		Test["Specify concentration monovalent salt ions in buffer:",
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], Upload->False, MonovalentSaltConcentration->100Millimolar],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Example[{Options,DivalentSaltConcentration,"Specify concentration of divalent salt ions in buffer:"},
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], DivalentSaltConcentration->100Millimolar][Entropy],
			Quantity[-306.20357663782215,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], DivalentSaltConcentration->100Millimolar] =
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]],  DivalentSaltConcentration->100Millimolar, Upload->False]
			}
		],

		Test["Specify concentration of divalent salt ions in buffer:",
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], Upload->False, DivalentSaltConcentration->100Millimolar],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				},
				Round->5
			]
		],

		Example[{Options,BufferModel,"Specify a specific buffer, from which salt concentration will be computed:"},
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], BufferModel->Model[Sample,StockSolution,"1X UV buffer"]][Entropy],
			Quantity[-334.17550499282754,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], BufferModel->Model[Sample,StockSolution,"1X UV buffer"]] =
				SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], BufferModel->Model[Sample,StockSolution,"1X UV buffer"], Upload->False]
			}
		],

		Test["Specify a specific buffer, from which salt concentration will be computed:",
			SimulateEntropy[Strand[DNA["GGACTGACGCGTTGA"]], Upload->False, BufferModel->Model[Sample,StockSolution,"1X UV buffer"]],
			validSimulationPacketP[Object[Simulation, Entropy],
				{
				}
			]
		],

		Example[{Options, Template, "The Options from a previous entropy simulation (object reference) can be used to preform an identical simulation on new oligomer:"},
			SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID, ResolvedOptions]][Entropy],
			Quantity[-335.23401267335015,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID, ResolvedOptions]] =
				SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID, ResolvedOptions], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Entropy], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Template, "The Options from a previous entropy simulation (object) can be used to preform an identical simulation on new oligomer:"},
			SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID]][Entropy],
			Quantity[-335.23401267335015,caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID]] =
				SimulateEntropy["GGACTGACGCGTTGA", Template->Object[Simulation, Entropy, theTemplateObjectID], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Entropy], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		(*
			OVERLOADS
		*)
		Test["Maps over input and preview shows either energy or energy distribution as appropriate:",
			SimulateEntropy[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["ATGCAGTC"]]}, Output->Preview],
			{Quantity[-335.23401267335015`,caloriePerMoleKelvinString], DistributionP[CaloriePerMoleKelvin], Quantity[-162.21700633667507`,caloriePerMoleKelvinString]},
			EquivalenceFunction->RoundMatchQ[5]
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"InvalidStrand","Given invalid strand:"},
			SimulateEntropy[Strand[DNA["AFTCG"]]],
			$Failed,
			Messages:>{Error::InvalidStrand,Error::InvalidInput}
		],

		Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct pattern:"},
		 SimulateEntropy["GGACTGACGCGTTGA", ThermodynamicsModel -> Null],
		 $Failed,
		 Messages :> {Error::InvalidThermodynamicsModel, Error::InvalidOption}],

		Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
		 SimulateEntropy["GGACTGACGCGTTGA", AlternativeParameterization -> True][Entropy],
		 Quantity[-335.23401267335015`,  caloriePerMoleKelvinString],
			EquivalenceFunction->RoundMatchQ[5],
		 Messages :> {Warning::AlternativeParameterizationNotAvailable}],

		(** TODO: remove this all polymers should be supported now **)
		(* Example[{Messages,"UnsupportedPolymers","Given strand with unsupported polymers:"},
			SimulateEntropy[Strand[DNA["ATCG"],PNA["ATCG"],Modification["Fluorescein"]]],
			$Failed,
			Messages:>{Error::UnsupportedPolymers,Error::InvalidInput}
		], *)

		Example[{Messages,"BadPolymerType","Specified polymer type does not match input:"},
			SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide][Entropy],
			Quantity[-69.90166048686118,caloriePerMoleKelvinString],
			Messages:>{Warning::BadPolymerType},
			Stubs :> {
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide] =
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide, Upload->False]
			}
		],

		Example[{Messages,"InvalidThermoInput","Given structure with bad polymers:"},
			SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]],
			$Failed,
			Messages:>{Error::InvalidThermoInput,Error::InvalidInput},
			Stubs :> {
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]] =
				SimulateEntropy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}], Upload->False]
			}
		],

		Example[{Messages,"InvalidSequence","Given invalid sequence:"},
			SimulateEntropy["FFFF"],
			$Failed,
			Messages:>{Error::InvalidSequence,Error::InvalidInput}
		],

		Example[{Messages,"LengthExceedMax", "Given sequence that is too long:"},
			SimulateEntropy[500000],
			$Failed,
			Messages:>{Error::LengthExceedMax,Error::InvalidInput}
		],

		Example[{Messages,"InvalidPolymerType", "With vague integer-type polymer and polymer option Null, a warning is shown and polymer option switches to Automatic:"},
			SimulateEntropy[15, Polymer->Null][EntropyDistribution],
			DistributionP["ThermochemicalCalories"/("Kelvins"*"Moles")],
			Messages:>{Warning::InvalidPolymerType,Warning::BadPolymerType},
			Stubs :> {
				SimulateEntropy[15, Polymer->Null] = SimulateEntropy[15, Polymer->Null, Upload->False]
			}
		],

		Example[{Messages,"InvalidSaltConcentration", "MonovalentSaltConcentration and DivalentSaltConcentration cannot both be 0 Molar:"},
			SimulateEntropy["ATCG",MonovalentSaltConcentration->0 Molar, DivalentSaltConcentration->0 Molar],
			$Failed,
			Messages:>{Error::InvalidSaltConcentration,Error::InvalidOption}
		],

		Example[{Messages, "UnsupportedReactionType", "Given unknown reaction type:"},
			SimulateEntropy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1,11 ;; 14}, {1, 1, 20 ;; 23}]}]},{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Unknown]],
			$Failed,
			Messages:>{Error::UnsupportedReactionType,Error::UnsupportedMechanism,Error::InvalidInput}
		],

		Example[{Messages, "UnsupportedReactionType", "Given too many reactants:"},
			SimulateEntropy[DNA["ATGTATAG"]+DNA["TACATATC"]+DNA["GTCAGTC"]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::ValueDoesNotMatchPattern}
		],

		Example[{Messages, "ReactionTypeNull", "Given an object with ReactionType option set to Null:"},
			SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Null][Entropy],
			Quantity[-421.2437305800216,caloriePerMoleKelvinString],
			Messages:>{Warning::ReactionTypeNull},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Null] = SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Null, Upload->False][[1]]
			}
		],

		Example[{Messages, "ReactionTypeWarning", "Given an object with no structure bonds and ReactionType option set to Melting:"},
			SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting][Entropy],
			Quantity[0.,caloriePerMoleKelvinString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting] = SimulateEntropy[Model[Sample, "F dsRed1"], ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Messages, "UnsupportedMechanism", "Given ReactionMechanism that is too complicated:"},
			SimulateEntropy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]]],
			$Failed,
			Messages :> {Error::UnsupportedMechanism,Error::InvalidInput}
		],

		Test["Nominal value check:",
			SimulateEntropy[Strand[DNA["ATCG"]], Upload->False][Entropy],
			Quantity[-71.80728843000361`,caloriePerMoleKelvinString]
		],

		Test["Check value at different MonovalentSaltConcentration:",
			SimulateEntropy[Strand[DNA["ATCG"]], MonovalentSaltConcentration->100.Millimolar, Upload->False][Entropy],
			Quantity[-71.04205394266543,caloriePerMoleKelvinString]
		],

		Test["Check value at MonovalentSaltConcentration computed from model:",
			SimulateEntropy[Strand[DNA["ATCG"]], BufferModel->Model[Sample,StockSolution,"1X UV buffer"], Upload->False][Entropy],
			Quantity[-71.5804653556059,caloriePerMoleKelvinString]
		],

		Test["Sequence and strand input return same value:",
			SimulateEntropy["ATCG", Upload->False][Entropy],
			SimulateEntropy[Strand[DNA["ATCG"]], Upload->False][Entropy]
		],

		Test["UnresolvedOptions or undefined options causes failure:",
			SimulateEntropy["ATCG", Plus->True, Polymer->"string"],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
		],

		Test["Degenerate sequence distribution calculation:",
			SimulateEntropy["NNNN", Upload->False][EntropyDistribution],
			DataDistribution["Empirical", {{0.00390625, 0.00390625, 0.0078125, 0.015625, 0.0234375, 0.0078125, 0.0078125, 0.00390625, 0.015625, 0.0078125, 0.00390625, 0.0078125, 0.0078125, 0.00390625, 0.0078125, 0.0078125, 0.0078125, 0.0078125, 0.00390625, 0.0078125, 0.0078125, 0.00390625, 0.0078125, 0.0078125, 0.015625, 0.0078125, 0.01953125, 0.015625, 0.0078125, 0.0078125, 0.015625, 0.015625, 0.0078125, 0.015625, 0.0234375, 0.0078125, 0.0078125, 0.015625, 0.0234375, 0.0078125, 0.015625, 0.0078125, 0.0078125, 0.015625, 0.00390625, 0.02734375, 0.0390625, 0.0234375, 0.015625, 0.03125, 0.0078125, 0.0234375, 0.0234375, 0.0078125, 0.01171875, 0.0078125, 0.0078125, 0.0078125, 0.0078125, 0.0078125, 0.0078125, 0.0078125, 0.015625, 0.015625, 0.0078125, 0.0078125, 0.00390625, 0.0078125, 0.015625, 0.01953125, 0.0078125, 0.0078125, 0.00390625, 0.00390625, 0.00390625, 0.015625, 0.0078125, 0.015625, 0.015625, 0.0078125, 0.015625, 0.015625, 0.0078125, 0.00390625, 0.0234375, 0.0078125, 0.00390625, 0.0078125, 0.0078125}, {-89.1072884300036, -86.30728843000361, -81.2072884300036, -80.7072884300036, -80.4072884300036, -79.30728843000361, -78.4072884300036, -77.30728843000361, -77.0072884300036, -76.5072884300036, -76.4072884300036, -76.30728843000361, -76.2072884300036, -76.10728843000359, -76.0072884300036, -75.9072884300036, -75.80728843000361, -75.7072884300036, -75.10728843000359, -74.80728843000361, -74.6072884300036, -74.5072884300036, -74.30728843000361, -74.2072884300036, -73.9072884300036, -73.80728843000361, -73.6072884300036, -73.4072884300036, -73.1072884300036, -72.9072884300036, -72.5072884300036, -72.0072884300036, -71.80728843000361, -71.5072884300036, -71.30728843000361, -69.80728843000361, -69.6072884300036, -69.50728843000361, -69.30728843000361, -69.1072884300036, -69.0072884300036, -68.80728843000361, -68.7072884300036, -68.6072884300036, -68.5072884300036, -68.1072884300036, -67.9072884300036, -67.6072884300036, -67.40728843000362, -67.30728843000361, -66.9072884300036, -66.80728843000361, -66.5072884300036, -66.4072884300036, -66.30728843000361, -66.20728843000362, -66.1072884300036, -65.9072884300036, -65.6072884300036, -65.1072884300036, -65.0072884300036, -64.7072884300036, -64.50728843000361, -64.2072884300036, -64.00728843000361, -63.2072884300036, -62.907288430003604, -62.80728843000361, -62.407288430003604, -62.2072884300036, -61.7072884300036, -61.5072884300036, -61.307288430003595, -60.80728843000361, -60.807288430003595, -60.7072884300036, -60.60728843000361, -60.5072884300036, -60.407288430003604, -60.10728843000361, -59.907288430003604, -59.807288430003595, -59.60728843000361, -59.50728843000361, -59.0072884300036, -58.7072884300036, -58.60728843000361, -58.407288430003604, -58.2072884300036}, False}, 1, 256,caloriePerMoleKelvinString],
			EquivalenceFunction -> RoundMatchQ[5]
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {rxnUUID},
	SymbolSetUp:>{

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allDataObjects,allObjects,existingObjects,
				testReactionObject, testOligomerObject
			},

			(* create a test reaction model object *)
			rxnUUID = CreateUUID[];
			testReactionObject = Model[Reaction, "Hybridization test"<>rxnUUID];
			testOligomerObject = Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID];
			(* All data objects generated for unit tests *)
			allDataObjects=
				{
					testReaction,
					testOligomerObject
				};

			allObjects=allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNASimulateEntropyPacket=
			<|
				Name->"XNASimulateEntropy"<>rxnUUID,
				Type->Model[Physics,Thermodynamics],
				Replace[Authors]->Link[$PersonID],
				Replace[StackingEnergy]->Join[stackingEnergy,stackingEnergyRNA],
				Replace[StackingEnthalpy]->Join[stackingEnthalpy,stackingEnthalpyRNA],
				Replace[StackingEntropy]->Join[stackingEntropy,stackingEntropyRNA],
				Replace[InitialEnergyCorrection]->{{DNA,DNA,1.96` KilocaloriePerMole},{DNA,RNA,3.1` KilocaloriePerMole}},
				Replace[InitialEnthalpyCorrection]->{{DNA,DNA,0.2` KilocaloriePerMole},{DNA,RNA,1.9` KilocaloriePerMole}},
				Replace[InitialEntropyCorrection]->{{DNA,DNA,-5.6` CaloriePerMoleKelvin},{DNA,RNA,-3.9` CaloriePerMoleKelvin}},
				Replace[TerminalEnergyCorrection]->{{DNA,DNA,0.05` KilocaloriePerMole}},
				Replace[TerminalEnthalpyCorrection]->{{DNA,DNA,2.2` KilocaloriePerMole}},
				Replace[TerminalEntropyCorrection]->{{DNA,DNA,6.9` CaloriePerMoleKelvin}},
				Replace[SymmetryEnergyCorrection]->{{DNA,DNA,0.43` KilocaloriePerMole}},
				Replace[SymmetryEntropyCorrection]->{{DNA,DNA,-1.4` CaloriePerMoleKelvin}},
				DeveloperObject->True
			|>;

		testReactionPacket = <|
			Type->Model[Reaction],
			Name->"Hybridization test"<>rxnUUID,
			Replace[ProductModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[ReactantModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[Reactants] -> {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			Replace[Reaction] -> Reaction[
				{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			  {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
			  Hybridization],
			Replace[ReactionProducts] -> {
				Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]},
		    {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]
			},
			Replace[ReactionType] -> Hybridization,
			Replace[ReverseRate] -> Null
		|>;
		
		testOligomerPacket = <|
			Type -> Model[Molecule,Oligomer],
			Molecule -> Strand["ATTATACGCTT"],
			Name -> "Oligomer test"<>rxnUUID
		|>;

		(* Creating the XNA model thermodynamics object *)
		{testReaction, modelThermodynamicsXNASimulateEntropyObject, testOligomerObject}=Upload[
			{testReactionPacket, modelThermodynamicsXNASimulateEntropyPacket, testOligomerPacket}
		];

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}
];

(* ::Subsection::Closed:: *)
(*Free Energy*)

(* ::Subsubsection:: *)
(*SimulateFreeEnergy*)

DefineTestsWithCompanions[SimulateFreeEnergy,
	{
		Example[{Basic,"Compute the Gibbs free energy of a hybridization reaction between given sequence and its reverse complement:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius][FreeEnergy],
			Quantity[-15.12717096936045`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Upload->False]
			}
		],

		Test["Preview shows energy when computing the Gibbs free energy of a hybridization reaction between given sequence and its reverse complement:",
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Output->Preview],
			Quantity[-15.12717096936045`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Compute the Gibbs free energy of a hybridization reaction between given sequence and its reverse complement:",
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-15.12717096936045`, kilocaloriePerMoleString],
					Temperature->Quantity[37., "DegreesCelsius"],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic, "Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the Gibbs free energy:"},
			SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius][FreeEnergy],
			Quantity[-15.12717096936045`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius] =
				SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius, Upload->False]
			}
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]][FreeEnergy],
			Quantity[-2.320000000000004, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]] =
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}], Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-2.320000000000004, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]][FreeEnergy],
			Quantity[-2.320000000000004, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]] =
				SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-2.320000000000004, kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic,"Compute the Gibbs free energy from entropy and enthalpy:"},
			SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37*Celsius][FreeEnergy],
			Quantity[-8.477500000000006, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37*Celsius] =
				SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37*Celsius, Upload->False]
			}
		],

		Test["Compute the Gibbs free energy from entropy and enthalpy:",
			SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37*Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-8.477500000000001, kilocaloriePerMoleString],
					Temperature->Quantity[37., "DegreesCelsius"]
				},
				Round->5
			]
		],


		(*
			ADDITIONAL
		*)
		Example[{Additional, "Input temperature as a distribution:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[30, 2], Celsius]][FreeEnergyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[30, 2], Celsius]] =
				SimulateFreeEnergy["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[30, 2], Celsius],Upload->False]
			}
		],

		Test["Preview shows input temperature as a distribution:",
			SimulateFreeEnergy["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[30, 2], Celsius], Output->Preview],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Input temperature as a distribution:",
			SimulateFreeEnergy["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[30, 2], Celsius],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					Temperature->Quantity[30., "DegreesCelsius"],
					TemperatureStandardDeviation->Quantity[2., "DegreesCelsius"],
					TemperatureDistribution->QuantityDistribution[NormalDistribution[30., 2.], "DegreesCelsius"],
					FreeEnergyDistribution->DistributionP[KilocaloriePerMole],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Additional, "Input enthalpy, entropy and temperature as distributions:"},
			SimulateFreeEnergy[QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole],QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin],QuantityDistribution[NormalDistribution[37,5],Celsius]][FreeEnergyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole],QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin],QuantityDistribution[NormalDistribution[37,5],Celsius]] =
				SimulateFreeEnergy[QuantityDistribution[EmpiricalDistribution[{-55}],KilocaloriePerMole],QuantityDistribution[NormalDistribution[-150,5],CaloriePerMoleKelvin],QuantityDistribution[NormalDistribution[37,5],Celsius],Upload->False]
			}
		],

		Example[{Additional, "Compute the free energy from a simple ReactionMechanism contains only one reaction:"},
			SimulateFreeEnergy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit][FreeEnergy],
			Quantity[-38.97345477994514, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit] =
				SimulateFreeEnergy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit, Upload->False]
			}
		],

		Test["Compute the free energy from a simple ReactionMechanism contains only one reaction:",
			SimulateFreeEnergy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					Temperature->Quantity[18.333333333333396, "DegreesCelsius"],
					FreeEnergy->Quantity[-38.97345477994514, kilocaloriePerMoleString],
					FreeEnergyStandardDeviation->Quantity[0, kilocaloriePerMoleString],
					FreeEnergyDistribution->QuantityDistribution[DataDistribution["Empirical", {{1.}, {-38.97345477994514}, False}, 1, 1], kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		Test["Compute the free energy from a simple Reaction contains only one reaction:",
			SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation],65Fahrenheit, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					Temperature->Quantity[18.333333333333396, "DegreesCelsius"],
					FreeEnergy->Quantity[-38.97345477994514, kilocaloriePerMoleString],
					FreeEnergyStandardDeviation->Quantity[0, kilocaloriePerMoleString],
					FreeEnergyDistribution->QuantityDistribution[DataDistribution["Empirical", {{1.}, {-38.97345477994514}, False}, 1, 1], kilocaloriePerMoleString],
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		Example[{Additional,"Pull strand from given sample:"},
			SimulateFreeEnergy[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius][FreeEnergy],
			Quantity[-20.85125696060632`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius] =
				SimulateFreeEnergy[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius, Upload->False]
			}
		],
		
		Example[{Additional, "Given an oligomer molecule model:"},
			SimulateFreeEnergy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 300 Kelvin][FreeEnergy],
			Quantity[-8.91271, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 300 Kelvin] =
					SimulateFreeEnergy[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 300 Kelvin,Upload->False]
			}
		],

		Test["Pull strand from given sample:",
			SimulateFreeEnergy[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Pull strand from given model:"},
			SimulateFreeEnergy[Model[Sample,"F dsRed1"],37*Celsius][FreeEnergy],
			Quantity[-20.85125696060632`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Sample,"F dsRed1"],37*Celsius] =
				SimulateFreeEnergy[Model[Sample,"F dsRed1"],37*Celsius, Upload->False][[1]]
			}
		],

		Test["Pull strand from given model:",
			SimulateFreeEnergy[Model[Sample,"F dsRed1"],37*Celsius, Upload->False][[1]],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Given reaction model:"},
			SimulateFreeEnergy[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius][FreeEnergy],
			Quantity[-20.85125696060632`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius] =
				SimulateFreeEnergy[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius, Upload->False]
			}
		],

		Test["Pull strand from given model:",
			SimulateFreeEnergy[Model[Sample,"F dsRed1"], 37 Celsius, Upload->False][[1]],
			Simulation`Private`validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Given structure, computes free energy of all bonded regions:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37.0*Celsius][FreeEnergy],
			Quantity[-18.47, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37.0*Celsius] =
				SimulateFreeEnergy[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37.0*Celsius, Upload->False]
			}
		],

		Test["Given structure, computes free energy of all bonded regions:",
			SimulateFreeEnergy[Structure[{Strand[DNA["CC"],DNA["AAAAA"],DNA["CC"]],Strand[DNA["AT"],DNA["TTTTT"],DNA["AT"]]},{Bond[{1,2},{2,2}]}],37.0*Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Compute the distribution of free energy of all 15-mer hybridization reactions with their reverse complements:"},
			SimulateFreeEnergy[DNA[15],37*Celsius][FreeEnergyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[DNA[15],37*Celsius] =
				SimulateFreeEnergy[DNA[15],37*Celsius, Upload->False]
			}
		],

		Test["Compute the distribution of free energy of all 15-mer hybridization reactions with their reverse complements:",
			SimulateFreeEnergy[DNA[15],37*Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Specify a temperature:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",65Fahrenheit][FreeEnergy],
			Quantity[-21.384872539262943`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",65Fahrenheit] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",65Fahrenheit, Upload->False]
			}
		],

		Test["Specify a temperature:",
			SimulateFreeEnergy["GGACTGACGCGTTGA",65Fahrenheit, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-21.384872539262943`, kilocaloriePerMoleString],
					Temperature->Quantity[18.333333333333396, "DegreesCelsius"],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Additional, "Given a strand:"},
			SimulateFreeEnergy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],37*Celsius][FreeEnergy],
			Quantity[-11.088104471549002`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],37*Celsius] =
				SimulateFreeEnergy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],37*Celsius, Upload->False]
			}
		],

		Test["Given a strand:",
			SimulateFreeEnergy[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],37*Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Given a typed sequence:"},
			SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"],37Celsius][FreeEnergy],
			Quantity[-15.12717096936045`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"],37Celsius] =
				SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"],37Celsius, Upload->False]
			}
		],

		Test["Given a typed sequence:",
			SimulateFreeEnergy[DNA["GGACTGACGCGTTGA"],37Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional, "Given untyped length:"},
			SimulateFreeEnergy[15,37*Celsius][FreeEnergyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[15,37*Celsius] =
				SimulateFreeEnergy[15,37*Celsius, Upload->False]
			}
		],

		Test["Given untyped length:",
			SimulateFreeEnergy[15,37*Celsius, Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Additional,"Temperature defaults to 37 Celsius:"},
			SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin][{FreeEnergy, Temperature}],
			SimulateFreeEnergy[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37.0*Celsius][{FreeEnergy, Temperature}],
			EquivalenceFunction->RoundMatchQ[8]
		],

		Example[{Additional,"Temperature defaults to 37 Celsius:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA"][{FreeEnergy, Temperature}],
			SimulateFreeEnergy["GGACTGACGCGTTGA",37*Celsius][{FreeEnergy, Temperature}],
			EquivalenceFunction->RoundMatchQ[8]
		],

		Example[{Additional, "Structure with no bonds returns zero:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]][FreeEnergy],
			Quantity[0., kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]] =
				SimulateFreeEnergy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False]
			}
		],

		Test["Structure with no bonds returns zero:",
			SimulateFreeEnergy[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[0., kilocaloriePerMoleString],
					Temperature->Quantity[37., "DegreesCelsius"],
					Append[Reactants]->{Structure[{Strand[DNA["AAACCCTTTGGG"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["AAACCCTTTGGG"]]}, {}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AAACCCTTTGGG"]]}, {}]}, {Structure[{Strand[DNA["AAACCCTTTGGG"]]}, {}]}, Unchanged]
				},
				Round->5
			]
		],

		Test["Given oligomer sample packet:",
			SimulateFreeEnergy[<|Object->Object[Sample, "id:jLq9jXY0ZXra"], Composition->{{Quantity[100, IndependentUnit["MassPercent"]], ECL`Link[ECL`Model[Molecule, ECL`Oligomer, "id:Z1lqpMzRZlWW"], "R8e1PjVdpNOv"]}, {Null, Null}}, Type->Object[Sample], Model->Model[Sample,"F dsRed1"],Strand->{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}|>,Upload->False],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-20.85125696060632`, kilocaloriePerMoleString],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				Round->5
			]
		],

		Example[{Additional, "Can handle degenerate sequence and return a distribution:"},
			SimulateFreeEnergy["ATCNNNNNNATA",37*Celsius][FreeEnergyDistribution],
			DistributionP[KilocaloriePerMole],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["ATCNNNNNNATA",37*Celsius] =
				SimulateFreeEnergy["ATCNNNNNNATA",37*Celsius, Upload->False]
			}
		],

		Example[{Additional, "Return free energy distribution instead of mean:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius][FreeEnergyDistribution],
			QuantityDistribution[DataDistribution["Empirical", {{1.}, {-15.12717096936045}, False}, 1, 1], kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Upload->False]
			}
		],

		Test["Oligomer model gets updated correctly:",
			SimulateFreeEnergy[Model[Sample, "id:KBL5DvYOlGPj"],Upload->False],
			{
				validSimulationPacketP[Object[Simulation, FreeEnergy],
					{
						FreeEnergy ->	Quantity[-8.058523480303137, kilocaloriePerMoleString],
						Append[ReactantModels]->{LinkP[Model[Molecule,Oligomer],Simulations]}
					},
					Round->5
				],
				<|
					Object->Model[Molecule, Oligomer, "id:N80DNj16KvAo"],
					FreeEnergy ->	Quantity[-8.058523480303137, kilocaloriePerMoleString]
				|>
			},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Additional, "Return free energy of a structure for which the thermodynamic parameters for mismatch is not available:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"],
		   DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}],37Celsius,Upload->False][FreeEnergy],
			Quantity[0.751963, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		(*
			OPTIONS
		*)
		Example[{Options,Polymer,"Specify polymer for untyped sequences:"},
			{SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->DNA][FreeEnergy], SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->RNA][FreeEnergy]},
			{Quantity[-6.875797489057298`, kilocaloriePerMoleString], Quantity[-7.728887489057314`, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->DNA] = SimulateFreeEnergy["CGCGCG",37.0*Celsius, Upload->False,Polymer->DNA],
				SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->RNA] = SimulateFreeEnergy["CGCGCG",37.0*Celsius, Upload->False,Polymer->RNA]
			}
		],

		Example[{Options,ReactionType,"Given an object, specify if the strands should be hybridized or the structure melted:"},
			SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting][FreeEnergy],
			Quantity[0., kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting] = SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			{
				SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->DNA,Upload->False][FreeEnergy],
				SimulateFreeEnergy["CGCGCG",37.0*Celsius,Polymer->DNA,ThermodynamicsModel->modelThermodynamicsXNASimulateFreeEnergyPacket,Upload->False][FreeEnergy]
			},
			{Quantity[-6.875797489057298`, kilocaloriePerMoleString], Quantity[-0.3840374890573095`, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,AlternativeParameterization,"Using AlternativeParameterization to specially useful if there is no thermo properties in the original polymer:"},
			SimulateFreeEnergy["mAmU",Polymer->LNAChimera,AlternativeParameterization->True,Upload->False][FreeEnergy],
			Quantity[4.67921, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,MonovalentSaltConcentration,"Specify monovalent salt concentration in buffer:"},
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,MonovalentSaltConcentration->100.Millimolar][FreeEnergy],
			Quantity[-16.234745858517485, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,MonovalentSaltConcentration->100.Millimolar] =
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar]
			}
		],

		Test["Specify monovalent salt concentration in buffer:",
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-16.234745858517485, kilocaloriePerMoleString],
					Temperature->Quantity[37., "DegreesCelsius"],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				ResolvedOptions->{
					MonovalentSaltConcentration->Quantity[100., "Millimolar"],
					DivalentSaltConcentration->Quantity[0., "Molar"]
				},
				Round->5
			]
		],

		Example[{Options,DivalentSaltConcentration,"Specify divalent salt concentration in buffer:"},
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,DivalentSaltConcentration->100.Millimolar][FreeEnergy],
			Quantity[-24.130960705779458, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,DivalentSaltConcentration->100.Millimolar] =
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,DivalentSaltConcentration->100.Millimolar]
			}
		],

		Test["Specify divalent salt concentration in buffer:",
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,DivalentSaltConcentration->100.Millimolar],
			validSimulationPacketP[Object[Simulation, FreeEnergy],
				{
					FreeEnergy->Quantity[-24.130960705779458, kilocaloriePerMoleString],
					Temperature->Quantity[37., "DegreesCelsius"],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				ResolvedOptions->{
					MonovalentSaltConcentration->Quantity[0., "Molar"],
					DivalentSaltConcentration->Quantity[100., "Millimolar"]
				},
				Round->5
			]
		],

		Example[{Options,BufferModel,"Specify a specific buffer, from which salt concentration will be computed:"},
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]][FreeEnergy],
			Quantity[-15.455467126474531, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]] =
				SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]]
			}
		],

		Test["Specify a specific buffer, from which salt concentration will be computed:",
			SimulateFreeEnergy[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]],
			validSimulationPacketP[Object[Simulation, FreeEnergy], {}]
		],

		Example[{Options, Template, "The Options from a previous free energy simulation (object reference) can be used to preform an identical simulation on new oligomer:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID, ResolvedOptions]][FreeEnergy],
			Quantity[-15.12717096936045, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID, ResolvedOptions]] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID, ResolvedOptions], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, FreeEnergy], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Template, "The Options from a previous free energy simulation (object) can be used to preform an identical simulation on new oligomer:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID]][FreeEnergy],
			Quantity[-15.12717096936045, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID]] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, Template->Object[Simulation,FreeEnergy,theTemplateObjectID], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, FreeEnergy], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		(*
			OVERLOADS
		*)
		Example[{Overloads,Maps,"Maps over enthalpy input:"},
			SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius][FreeEnergy],
			{Quantity[-9.52075, kilocaloriePerMoleString],
			Quantity[0.4792500000000004, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius] =
				SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius, Upload->False]
			}
		],

		Test["Maps over enthalpy input:",
			SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius, Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}], validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Example[{Overloads,Maps,"Maps over entropy input:"},
			SimulateFreeEnergy[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius][FreeEnergy],
			{Quantity[-9.52075, kilocaloriePerMoleString], Quantity[-21.926750000000006, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius] =
				SimulateFreeEnergy[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False]
			}
		],

		Test["Maps over entropy input:",
			SimulateFreeEnergy[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}], validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Example[{Overloads,Maps,"MapThread over enthalpy and entropy input:"},
			SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius][FreeEnergy],
			{Quantity[-9.52075, kilocaloriePerMoleString], Quantity[-11.926750000000006, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius] =
				SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False]
			}
		],

		Test["MapThread over enthalpy and entropy input:",
			SimulateFreeEnergy[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}], validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Test["Maps over oligomer input and preview shows either energy or energy distribution as appropriate:",
			SimulateFreeEnergy[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["GGACTGACGCGTTGA"]]},37.0*Celsius, Output->Preview],
			{Quantity[-15.12717096936045`, kilocaloriePerMoleString], DistributionP[KilocaloriePerMole], Quantity[-15.12717096936045`, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Maps over oligomer input:",
			SimulateFreeEnergy[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["GGACTGACGCGTTGA"]]},37.0*Celsius, Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}],validSimulationPacketP[Object[Simulation, FreeEnergy], {}],validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Test["Maps over structure input:",
			SimulateFreeEnergy[{Structure[{Strand[DNA["CC"], DNA["AAAAA"], DNA["CC"]], Strand[DNA["AT"], DNA["TTTTT"], DNA["AT"]]}, {Bond[{1, 2}, {2, 2}]}], Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]}, 37.0*Celsius, Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}],validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Example[{Overloads,Maps,"Maps over temperature input:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}][FreeEnergy],
			{Quantity[-15.12717096936045`, kilocaloriePerMoleString], Quantity[-12.445298867973648`, kilocaloriePerMoleString]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}] =
				SimulateFreeEnergy["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius},Upload->False]
			}
		],

		Test["Maps over temperature input:",
			SimulateFreeEnergy["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius},Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}], validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		Test["MapThread over both inputs and preview shows either energy or energy distribution as appropriate:",
			SimulateFreeEnergy[{"GGACTGACGCGTTGA",DNA[15]},{37.0*Celsius,45.0*Celsius}, Output->Preview],
			{Quantity[-15.12717096936045`, kilocaloriePerMoleString], DistributionP[KilocaloriePerMole]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["MapThread over both inputs:",
			SimulateFreeEnergy[{"GGACTGACGCGTTGA",DNA[15]},{37.0*Celsius,45.0*Celsius},Upload->False],
			{validSimulationPacketP[Object[Simulation, FreeEnergy], {}],validSimulationPacketP[Object[Simulation, FreeEnergy], {}]}
		],

		(*
			MESSAGES
		*)
		Example[{Messages,"InvalidStrand","Given an invalid strand:"},
			SimulateFreeEnergy[Strand[DNA["AFTCG"]],37.0*Celsius],
			$Failed,
			Messages:>{Error::InvalidStrand,Error::InvalidInput}
		],

		(** TODO: remove this all polymers should be supported now **)
		(* Example[{Messages,"UnsupportedPolymers","Given strand with unsupported polymers:"},
			SimulateFreeEnergy[Strand[DNA["ATCG"],PNA["ATCG"],Modification["Fluorescein"]],37.0*Celsius],
			$Failed,
			Messages:>{Error::UnsupportedPolymers,Error::InvalidInput}
		], *)

		Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct pattern:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, ThermodynamicsModel -> Null][FreeEnergy],
			$Failed,
			Messages :> {Error::InvalidThermodynamicsModel,Error::InvalidOption}
		],

		Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
			SimulateFreeEnergy["GGACTGACGCGTTGA",37Celsius, AlternativeParameterization -> True][FreeEnergy],
			Quantity[-15.12717096936045`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5],
			Messages :> {Warning::AlternativeParameterizationNotAvailable}
		],

		Example[{Messages,"BadPolymerType","Specified polymer type does not match input:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide][FreeEnergy],
			Quantity[-2.320000000000004, kilocaloriePerMoleString],
			Messages:>{Warning::BadPolymerType},
			Stubs :> {
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide] =
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],Polymer->Peptide, Upload->False]
			}
		],

		Example[{Messages,"InvalidThermoInput","Given structure with bad polymers:"},
			SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]],
			$Failed,
			Messages:>{Error::InvalidThermoInput,Error::InvalidInput},
			Stubs :> {
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]] =
				SimulateFreeEnergy[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGUUGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}] \[Equilibrium] Structure[{Strand[ DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}], Upload->False]
			}
		],

		Example[{Messages,"InvalidSequence","Given invalid sequence:"},
			SimulateFreeEnergy["FFFF",37*Celsius],
			$Failed,
			Messages:>{Error::InvalidSequence,Error::InvalidInput}
		],

		Example[{Messages,"LengthExceedMax", "Given sequence that is too long:"},
			SimulateFreeEnergy[500000, 37 Celsius],
			$Failed,
			Messages:>{Error::LengthExceedMax,Error::InvalidInput}
		],

		Example[{Messages,"InvalidPolymerType", "With vague integer-type polymer and polymer option Null, a warning is shown and polymer option switches to Automatic:"},
			SimulateFreeEnergy[15, Polymer->Null][FreeEnergyDistribution],
			DistributionP[kilocaloriePerMoleString],
			Messages:>{Warning::InvalidPolymerType,Warning::BadPolymerType},
			Stubs :> {
				SimulateFreeEnergy[15, Polymer->Null] = SimulateFreeEnergy[15, Polymer->Null, Upload->False]
			}
		],

		Example[{Messages,"InvalidSaltConcentration", "MonovalentSaltConcentration and DivalentSaltConcentration cannot both be 0 Molar:"},
			SimulateFreeEnergy["ATCG",37 Celsius,MonovalentSaltConcentration->0 Molar, DivalentSaltConcentration->0 Molar],
			$Failed,
			Messages:>{Error::InvalidSaltConcentration,Error::InvalidOption}
		],

		Example[{Messages, "UnsupportedReactionType", "Given unknown reaction type:"},
			SimulateFreeEnergy[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1,11 ;; 14}, {1, 1, 20 ;; 23}]}]},{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Unknown]],
			$Failed,
			Messages:>{Error::UnsupportedReactionType,Error::InvalidInput}
		],

		Example[{Messages, "UnsupportedReactionType", "Given too many reactants:"},
			SimulateFreeEnergy[DNA["ATGTATAG"]+DNA["TACATATC"]+DNA["GTCAGTC"], 37 Celsius],
			$Failed,
			Messages:>{Error::InvalidInput,Error::ValueDoesNotMatchPattern}
		],

		Example[{Messages, "ReactionTypeNull", "Given an object with ReactionType option set to Null:"},
			SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null][FreeEnergy],
			Quantity[-20.85125696060632, kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeNull},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null] = SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null, Upload->False][[1]]
			}
		],

		Example[{Messages, "ReactionTypeWarning", "Given an object with no structure bonds and ReactionType option set to Melting:"},
			SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting][FreeEnergy],
			Quantity[0., kilocaloriePerMoleString],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting] = SimulateFreeEnergy[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting, Upload->False][[1]]
			}
		],

		Example[{Messages, "UnsupportedMechanism", "Given ReactionMechanism that is too complicated:"},
			SimulateFreeEnergy[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]], 25 Celsius],
			$Failed,
			Messages :> {Error::UnsupportedMechanism,Error::InvalidInput}
		],

		(*
			OTHER
		*)
		Test["Nominal value check:",
			SimulateFreeEnergy[Strand[DNA["ATCG"]],37Celsius, Upload->False][FreeEnergy],
			Quantity[-1.328969493434382`, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Check value at different MonovalentSaltConcentration:",
			SimulateFreeEnergy[Strand[DNA["ATCG"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar][FreeEnergy],
			Quantity[-1.5663069696823158, kilocaloriePerMoleString],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["UnresolvedOptions or undefined options causes failure:",
			SimulateFreeEnergy["ATCG",Upload->False,Plus->True,Polymer->"string"],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
		],

		Test["Handles modification in middle of a loop without errors:",
		SimulateFreeEnergy[Structure[{Strand[DNA["AAAAAT"], DNA["TTTTT"], 	Modification["Tamra"]]}, {Bond[{1, 1 ;; 3}, {1, 7 ;; 9}]}],Upload->False][FreeEnergy],
			_?EnergyQ
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {rxnUUID},
	SymbolSetUp:>{

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allDataObjects,allObjects,existingObjects,
				testReactionObject, testOligomerObject
			},

			(* create a test reaction model object *)
			rxnUUID = CreateUUID[];
			testReactionObject = Model[Reaction, "Hybridization test"<>rxnUUID];
			testOligomerObject = Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID];

			(* All data objects generated for unit tests *)
			allDataObjects=
				{
					testReactionObject,
					testOligomerObject
				};

			allObjects=allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNASimulateFreeEnergyPacket=
			<|
				Name->"XNASimulateFreeEnergy"<>rxnUUID,
				Type->Model[Physics,Thermodynamics],
				Replace[Authors]->Link[$PersonID],
				Replace[StackingEnergy]->Join[stackingEnergy,stackingEnergyRNA],
				Replace[StackingEnthalpy]->Join[stackingEnthalpy,stackingEnthalpyRNA],
				Replace[StackingEntropy]->Join[stackingEntropy,stackingEntropyRNA],
				Replace[InitialEnergyCorrection]->{{DNA,DNA,1.96` KilocaloriePerMole},{DNA,RNA,3.1` KilocaloriePerMole}},
				Replace[InitialEnthalpyCorrection]->{{DNA,DNA,0.2` KilocaloriePerMole},{DNA,RNA,1.9` KilocaloriePerMole}},
				Replace[InitialEntropyCorrection]->{{DNA,DNA,-5.6` CaloriePerMoleKelvin},{DNA,RNA,-3.9` CaloriePerMoleKelvin}},
				Replace[TerminalEnergyCorrection]->{{DNA,DNA,0.05` KilocaloriePerMole}},
				Replace[TerminalEnthalpyCorrection]->{{DNA,DNA,2.2` KilocaloriePerMole}},
				Replace[TerminalEntropyCorrection]->{{DNA,DNA,6.9` CaloriePerMoleKelvin}},
				Replace[SymmetryEnergyCorrection]->{{DNA,DNA,0.43` KilocaloriePerMole}},
				Replace[SymmetryEntropyCorrection]->{{DNA,DNA,-1.4` CaloriePerMoleKelvin}},
				DeveloperObject->True
			|>;

		testReactionPacket = <|
			Type->Model[Reaction],
			Name->"Hybridization test"<>rxnUUID,
			Replace[ProductModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[ReactantModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[Reactants] -> {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			Replace[Reaction] -> Reaction[
				{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			  {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
			  Hybridization],
			Replace[ReactionProducts] -> {
				Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]},
		    {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]
			},
			Replace[ReactionType] -> Hybridization,
			Replace[ReverseRate] -> Null
		|>;
		
		testOligomerPacket = <|
			Type -> Model[Molecule,Oligomer],
			Molecule -> Strand["ATTATACGCTT"],
			Name -> "Oligomer test"<>rxnUUID
		|>;

		(* Creating the XNA model thermodynamics object *)
		{testReaction, modelThermodynamicsXNASimulateFreeEnergyObject, testOligomerObject}=Upload[
			{testReactionPacket, modelThermodynamicsXNASimulateFreeEnergyPacket, testOligomerPacket}
		];

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}

];



(* ::Subsection::Closed:: *)
(*Melting Temperature*)

(* ::Subsubsection:: *)
(*SimulateMeltingTemperature*)

DefineTestsWithCompanions[SimulateMeltingTemperature,
	{

		Example[{Basic, "Compute the melting temperature of a hybridization reaction between given sequence and its reverse complement:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar][MeltingTemperature],
			Quantity[64.15451825303857`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar] =
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar,Upload->False]
			}
		],

		Test["Compute the melting temperature of a hybridization reaction between given sequence and its reverse complement:",
			SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperatureDistribution->QuantityDistribution[DataDistribution["Empirical", {{1.}, {64.15451825303857`}, False}, 1, 1], "DegreesCelsius"],
					Append[ConcentrationDistribution]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], QuantityDistribution[DataDistribution["Empirical", {{1.}, {0.00025}, False}, 1, 1], "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], QuantityDistribution[DataDistribution["Empirical", {{1.}, {0.00025}, False}, 1, 1], "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Basic, "Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the melting temperature:"},
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],250.0*Micromolar][MeltingTemperature],
			Quantity[64.15451825303857`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],250.0*Micromolar] =
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],250.0*Micromolar,Upload->False]
			}
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],250 Micromolar][MeltingTemperature],
			Quantity[70.18948339483404, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],250 Micromolar] =
				SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],250 Micromolar,Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],250 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[70.18948339483404, "DegreesCelsius"],
					Append[Concentration]->{{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}], Quantity[0.00025, "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Specify reaction from one structure to another:"},
			SimulateMeltingTemperature[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],250 Micromolar][MeltingTemperature],
			Quantity[70.18948339483404, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],250 Micromolar] =
				SimulateMeltingTemperature[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],250 Micromolar,Upload->False]
			}
		],

		Test["Specify reaction from one structure to another:",
			SimulateMeltingTemperature[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],250 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[70.18948339483404, "DegreesCelsius"],
					Append[Concentration]->{{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}], Quantity[0.00025, "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
				},
				Round->5
			]
		],

		Example[{Basic, "Compute the melting temperature of a bimolecular reaction from its enthalpy and entropy:"},
			SimulateMeltingTemperature[-70*KilocaloriePerMole,-195*CaloriePerMoleKelvin,100 Micromolar][MeltingTemperature],
			Quantity[55.02193667783877, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[-70*KilocaloriePerMole,-195*CaloriePerMoleKelvin,100 Micromolar] =
				SimulateMeltingTemperature[-70*KilocaloriePerMole,-195*CaloriePerMoleKelvin,100 Micromolar,Upload->False]
			}
		],

		Test["Compute the melting temperature of a bimolecular reaction from its enthalpy and entropy:",
			SimulateMeltingTemperature[-70*KilocaloriePerMole,-195*CaloriePerMoleKelvin,100 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[55.02193667783877, "DegreesCelsius"],
					Append[Concentration]->{{Null, Quantity[0.0001, "Molar"]}}
				},
				Round->4
			]
		],

		(*
			ADDITIONAL
		*)
		Example[{Additional, "Input concentration as a distribution:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[250, 10], Micromolar]][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[250, 10], Micromolar]] =
				SimulateMeltingTemperature["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[250, 10], Micromolar],Upload->False]
			}
		],

		Test["Input concentration as a distribution:",
			SimulateMeltingTemperature["GGACTGACGCGTTGA", QuantityDistribution[NormalDistribution[250, 10], Micromolar],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					Append[Concentration]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Quantity[1/4000, "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], Quantity[1/4000, "Molar"]}},
					Append[ConcentrationStandardDeviation]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Quantity[1/100000, "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], Quantity[1/100000, "Molar"]}},
					Append[ConcentrationDistribution]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], QuantityDistribution[NormalDistribution[1/4000, 1/100000], "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], QuantityDistribution[NormalDistribution[1/4000, 1/100000], "Molar"]}},
					MeltingTemperatureDistribution->DistributionP[Celsius],
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				Round->5
			]
		],

		Example[{Additional, "Two reactants have different concentrations:"},
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> 100 Micromolar, DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}][MeltingTemperature],
			Quantity[63.47878295148908`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> 100 Micromolar, DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}] =
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> 100 Micromolar, DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}, Upload->False]
			}
		],

		Example[{Additional, "Two reactants have different concentrations and one of them is specified as a distribution:"},
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[3],
			Stubs :> {
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}] =
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}, Upload->False]
			}
		],

		Example[{Additional, "Two reactants have different concentrations as distributions:"},
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->QuantityDistribution[NormalDistribution[150, 10], Micromolar]}][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->QuantityDistribution[NormalDistribution[150, 10], Micromolar]}] =
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->QuantityDistribution[NormalDistribution[150, 10], Micromolar]}, Upload->False]
			}
		],

		Test["Two reactants have different concentrations:",
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"], {DNA["GGACTGACGCGTTGA"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TCAACGCGTCAGTCC"]->25 Micro Molar}, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}],Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, Span[1, 15]}, {2, Span[1, 15]}]}]},Hybridization],
					MeltingTemperatureDistribution->DistributionP[Celsius],
					Append[Concentration]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Quantity[1/10000, "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], Quantity[0.000024999999999999998, "Molar"]}},
					Append[ConcentrationStandardDeviation]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Quantity[1/200000, "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], Quantity[0, "Molar"]}},
					Append[ConcentrationDistribution]->{{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], QuantityDistribution[NormalDistribution[1/10000, 1/200000], "Molar"]}, {Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}], QuantityDistribution[DataDistribution["Empirical", {{1.}, {0.000024999999999999998}, False}, 1, 1], "Molar"]}}
				},
				Round->3
			]
		],

		Example[{Additional, "Input enthalpy, entropy and concentration as distributions:"},
			SimulateMeltingTemperature[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[250, 5], Micromolar]][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[250, 5], Micromolar]] =
				SimulateMeltingTemperature[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[250, 5], Micromolar],Upload->False]
			}
		],

		Example[{Additional, "Compute the melting temperature from a simple ReactionMechanism contains only one reaction:"},
			SimulateMeltingTemperature[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],100 Micromolar][MeltingTemperature],
			Quantity[79.3937469566884, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],100 Micromolar] =
				SimulateMeltingTemperature[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],100 Micromolar,Upload->False]
			}
		],

		Test["Compute the melting temperature from a simple ReactionMechanism contains only one reaction:",
			SimulateMeltingTemperature[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],100 Micromolar,Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[79.3937469566884, "DegreesCelsius"],
					Append[Concentration]->{{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Quantity[0.00009999999999999999, "Molar"]}, {Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}], Quantity[0.00009999999999999999, "Molar"]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}], Quantity[0.00009999999999999999, "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
					Append[Products]->{ Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
				},
				Round->5
			]
		],

		Example[{Additional, "Pull strand from given sample:"},
			SimulateMeltingTemperature[Object[Sample, "id:jLq9jXY0ZXra"],100 Micromolar][MeltingTemperature],
			Quantity[70.44664717182559, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Object[Sample, "id:jLq9jXY0ZXra"],100 Micromolar] =
				SimulateMeltingTemperature[Object[Sample, "id:jLq9jXY0ZXra"],100 Micromolar,Upload->False]
			}
		],
		
		Example[{Additional, "Given an oligomer molecule model:"},
			SimulateMeltingTemperature[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 0.1 Molar][MeltingTemperature],
			Quantity[57.6249, Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 0.1 Molar] =
					SimulateMeltingTemperature[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 0.1 Molar, Upload -> False]
			}
		],

		Test["Pull strand from given sample:",
			SimulateMeltingTemperature[Object[Sample, "id:jLq9jXY0ZXra"],100 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Pull strand from given model:"},
			SimulateMeltingTemperature[Model[Sample,"F dsRed1"],250 Micromolar][MeltingTemperature],
			Quantity[71.87146076514423`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Sample,"F dsRed1"],250 Micromolar] =
				SimulateMeltingTemperature[Model[Sample,"F dsRed1"],250 Micromolar,Upload->False]
			}
		],

		Test["Pull strand from given model:",
			SimulateMeltingTemperature[Model[Sample,"F dsRed1"],250.0*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Given reaction model:"},
			SimulateMeltingTemperature[Model[Reaction,"Hybridization test"<>rxnUUID], 250.0*Micromolar][MeltingTemperature],
			Quantity[71.87146076514423`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Reaction,"Hybridization test"<>rxnUUID], 250.0*Micromolar] =
				SimulateMeltingTemperature[Model[Reaction,"Hybridization test"<>rxnUUID], 250.0*Micromolar,Upload->False]
			}
		],

		Example[{Additional, "Given structure, computes melting temperature of all bonded regions:"},
			SimulateMeltingTemperature[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],10Millimolar][MeltingTemperature],
			Quantity[98.37866173791927, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],10Millimolar] =
				SimulateMeltingTemperature[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],10Millimolar,Upload->False]
			}
		],

		Test["Given structure, computes melting temperature of all bonded regions:",
			SimulateMeltingTemperature[Structure[{Strand[DNA["CC"],DNA["AAAAA"],DNA["CC"]],Strand[DNA["AT"],DNA["TTTTT"],DNA["AT"]]},{Bond[{1,2},{2,2}]}],10Millimolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Compute the distribution of melting temperature of all 15-mer hybridization reactions with their reverse complements:"},
			SimulateMeltingTemperature[DNA[15],100 Micromolar][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[DNA[15],100 Micromolar] =
				SimulateMeltingTemperature[DNA[15],100 Micromolar,Upload->False]
			}
		],

		Test["Compute the distribution of melting temperature of all 15-mer hybridization reactions with their reverse complements:",
			SimulateMeltingTemperature[DNA[15],100 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Given a strand:"},
			SimulateMeltingTemperature[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],100 Micromolar][MeltingTemperature],
			Quantity[51.93586905996736`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],100 Micromolar] =
				SimulateMeltingTemperature[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],100 Micromolar,Upload->False]
			}
		],

		Test["Given a strand:",
			SimulateMeltingTemperature[Strand[DNA["ATGTATAG"],RNA["AGUCUA"]],100 Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Given a typed sequence:"},
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"],250.0*Micromolar][MeltingTemperature],
			Quantity[64.15451825303857`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"],250.0*Micromolar] =
				SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"],250.0*Micromolar,Upload->False]
			}
		],

		Test["Given a typed sequence:",
			SimulateMeltingTemperature[DNA["GGACTGACGCGTTGA"],250.0*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Given untyped length:"},
			SimulateMeltingTemperature[15,250.0*Micromolar][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[15,250.0*Micromolar] =
				SimulateMeltingTemperature[15,250.0*Micromolar,Upload->False]
			}
		],

		Test["Given untyped length:",
			SimulateMeltingTemperature[15,250.0*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Structure with no bonds returns 0K:"},
			SimulateMeltingTemperature[Structure[{Strand[DNA["ATCG"]]},{}],10.0 Millimolar][MeltingTemperature],
			Quantity[-273.15, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Structure[{Strand[DNA["ATCG"]]},{}],10.0 Millimolar] =
				SimulateMeltingTemperature[Structure[{Strand[DNA["ATCG"]]},{}],10.0 Millimolar,Upload->False]
			}
		],

		Test["Structure with no bonds returns 0K:",
			SimulateMeltingTemperature[Structure[{Strand[DNA["ATCG"]]},{}],10.0 Millimolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Additional, "Can handle degenerate sequence:"},
			SimulateMeltingTemperature["ACNCATGGNCCGA",250.0*Micromolar][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["ACNCATGGNCCGA",250.0*Micromolar] =
				SimulateMeltingTemperature["ACNCATGGNCCGA",250.0*Micromolar,Upload->False]
			}
		],

		Example[{Additional, "Return melting temperature distribution instead of mean:"},
			SimulateMeltingTemperature["GGACTGANNCGCGTTGA",250.0*Micromolar][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGANNCGCGTTGA",250.0*Micromolar] =
				SimulateMeltingTemperature["GGACTGANNCGCGTTGA",250.0*Micromolar, Upload->False]
			}
		],

		(*
			OPTIONS
		*)
		Example[{Options,Polymer,"Specify polymer for untyped sequences:"},
			{
				SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Polymer->DNA][MeltingTemperature],
				SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Polymer->RNA][MeltingTemperature]
			},
			{Quantity[48.066381061459744`, "DegreesCelsius"], Quantity[51.63698077671961`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Polymer->DNA] = SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Upload->False,Polymer->DNA],
				SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Polymer->RNA] = SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,Upload->False,Polymer->RNA]
			}
		],

		Example[{Options,ReactionType,"Given an object, specify if the strands should be hybridized or the structure melted:"},
			SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting][MeltingTemperature],
			Quantity[-273.15, "DegreesCelsius"],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting] = SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting, Upload->False]
			}
		],

		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			SimulateMeltingTemperature["CGCGCG",250.0*Micromolar,ThermodynamicsModel->Model[Physics,Thermodynamics,"DNA"],Upload->False][MeltingTemperature],
			Quantity[48.066369803363614`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Example[{Options,AlternativeParameterization,"Using AlternativeParameterization that is used if there is missing information in the thermo properties of the original polymer:"},
			SimulateMeltingTemperature[LNAChimera["mUmG"],250.0*Micromolar,AlternativeParameterization->True,Upload->False][MeltingTemperature],
			Quantity[-188.78087348340878`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options, MonovalentSaltConcentration, "Specify monovalent salt concentration in buffer:"},
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,MonovalentSaltConcentration->100.Millimolar][MeltingTemperature],
			Quantity[55.797069444376625, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,MonovalentSaltConcentration->100.Millimolar] =
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,Upload->False,MonovalentSaltConcentration->100.Millimolar]
			}
		],

		Test["Specify monovalent salt concentration in buffer:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,Upload->False,MonovalentSaltConcentration->100.Millimolar],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[55.797069444376625, "DegreesCelsius"],
					Append[Concentration]->{{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Quantity[0.00025, "Molar"]}, {Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}], Quantity[0.00025, "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["ATCGATCGATCG"]], Strand[DNA["CGATCGATCGAT"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}]}, {Structure[{Strand[DNA["ATCGATCGATCG"]], Strand[DNA["CGATCGATCGAT"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				ResolvedOptions->{
					MonovalentSaltConcentration->Quantity[100., "Millimolar"],
					DivalentSaltConcentration->Quantity[0., "Molar"]
				},
				Round->5
			]
		],

		Example[{Options, DivalentSaltConcentration, "Specify divalent salt concentration in buffer:"},
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,DivalentSaltConcentration->100.Millimolar][MeltingTemperature],
			Quantity[81.13698814240743, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,DivalentSaltConcentration->100.Millimolar] =
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,Upload->False,DivalentSaltConcentration->100.Millimolar]
			}
		],

		Test["Specify divalent salt concentration in buffer:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],250*Micromolar,Upload->False,DivalentSaltConcentration->100.Millimolar],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[81.13698814240743, "DegreesCelsius"],
					Append[Concentration]->{{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Quantity[0.00025, "Molar"]}, {Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}], Quantity[0.00025, "Molar"]}},
					Append[Reactants]->{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}]},
					Append[Products]->{Structure[{Strand[DNA["ATCGATCGATCG"]], Strand[DNA["CGATCGATCGAT"]]}, {Bond[{1, 1}, {2, 1}]}]},
					Reaction->Reaction[{Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}], Structure[{Strand[DNA["CGATCGATCGAT"]]}, {}]}, {Structure[{Strand[DNA["ATCGATCGATCG"]], Strand[DNA["CGATCGATCGAT"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
				},
				ResolvedOptions->{
					MonovalentSaltConcentration->Quantity[0., "Molar"],
					DivalentSaltConcentration->Quantity[100., "Millimolar"]
				},
				Round->5
			]
		],

		Example[{Options, BufferModel, "Specify a specific buffer, from which salt concentration will be computed:"},
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]][MeltingTemperature],
			Quantity[51.39328356411088, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]] =
				SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,Upload->False,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]]
			}
		],

		Test["Specify a specific buffer, from which salt concentration will be computed:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,Upload->False,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]],
			validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]
		],

		Example[{Options, Template, "The Options from a previous melting temperature simulation (object reference) can be used to preform an identical simulation on new oligomer:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID, ResolvedOptions]][MeltingTemperature],
			Quantity[64.15451825303857, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID, ResolvedOptions]] =
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID, ResolvedOptions], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, MeltingTemperature], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Template, "The Options from a previous melting temperature simulation (object) can be used to preform an identical simulation on new oligomer:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID]][MeltingTemperature],
			Quantity[64.15451825303857, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID]] =
				SimulateMeltingTemperature["GGACTGACGCGTTGA",250.0*Micromolar, Template->Object[Simulation,MeltingTemperature,theTemplateObjectID], Upload->False]
			},
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, MeltingTemperature], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		(*
			OVERLOADS
		*)
		Example[{Overloads, Maps, "Maps over enthalpy input:"},
			SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60 KilocaloriePerMole},-60 CaloriePerMoleKelvin,250.0*Micromolar][MeltingTemperature],
			{Quantity[642.098448906051, "DegreesCelsius"], Quantity[511.34867049090076, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60 KilocaloriePerMole},-60 CaloriePerMoleKelvin,250.0*Micromolar] =
				SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60 KilocaloriePerMole},-60 CaloriePerMoleKelvin,250.0*Micromolar,Upload->False]
			}
		],

		Test["Maps over enthalpy input:",
			SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60 KilocaloriePerMole},-60 CaloriePerMoleKelvin,250.0*Micromolar,Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Example[{Overloads, Maps, "Maps over entropy input:"},
			SimulateMeltingTemperature[-70 KilocaloriePerMole,{-90 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar][MeltingTemperature],
			{Quantity[384.2383181238471, "DegreesCelsius"], Quantity[239.73827727412856, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[-70 KilocaloriePerMole,{-90 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar] =
				SimulateMeltingTemperature[-70 KilocaloriePerMole,{-90 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar,Upload->False]
			}
		],

		Test["Maps over entropy input:",
			SimulateMeltingTemperature[-70 KilocaloriePerMole,{-90 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar,Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Example[{Overloads, Maps, "MapThread over enthalpy and entropy input:"},
			SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-60 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar][MeltingTemperature],
			{Quantity[642.098448906051, "DegreesCelsius"], Quantity[166.4685233778244, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-60 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar] =
				SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-60 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar,Upload->False]
			}
		],

		Test["MapThread over enthalpy and entropy input:",
			SimulateMeltingTemperature[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-60 CaloriePerMoleKelvin,-120 CaloriePerMoleKelvin},250.0*Micromolar,Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Test["Maps over oligomer input and preview shows either temperature or distribution as appropriate:",
			SimulateMeltingTemperature[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["ATGCATTGAGTC"]]},200.0*Micromolar, Output->Preview],
			{Quantity[63.73144634149608`, "DegreesCelsius"], DistributionP[Celsius], Quantity[49.1351610693901`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Maps over oligomer input:",
			SimulateMeltingTemperature[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["ATGCATTGAGTC"]]},200.0*Micromolar,Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Test["Maps over structure input:",
			SimulateMeltingTemperature[{Structure[{Strand[DNA["CC"], DNA["AAAAA"], DNA["CC"]], Strand[DNA["AT"], DNA["TTTTT"], DNA["AT"]]}, {Bond[{1, 2}, {2, 2}]}], Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]}, 200.0*Micromolar, Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}],validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Example[{Overloads, Maps, "Maps over concentration input:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA",{2.0*Micromolar,200.0*Micromolar}][MeltingTemperature],
			{Quantity[55.2311971103532`, "DegreesCelsius"], Quantity[63.73144634149608`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature["GGACTGACGCGTTGA",{2.0*Micromolar,200.0*Micromolar}] =
				SimulateMeltingTemperature["GGACTGACGCGTTGA",{2.0*Micromolar,200.0*Micromolar},Upload->False]
			}
		],

		Test["Maps over concentration input:",
			SimulateMeltingTemperature["GGACTGACGCGTTGA",{2.0*Micromolar,200.0*Micromolar},Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		Test["MapThread over both inputs and preview shows either temperature or distribution as appropriate:",
			SimulateMeltingTemperature[{"GGACTGACGCGTTGA",DNA[15]},{2.0*Micromolar,200.0*Micromolar}, Output->Preview],
			{Quantity[55.2311971103532`, "DegreesCelsius"], DistributionP[Celsius]},
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["MapThread over both inputs:",
			SimulateMeltingTemperature[{"GGACTGACGCGTTGA",DNA[15]},{2.0*Micromolar,200.0*Micromolar},Upload->False],
			{validSimulationPacketP[Object[Simulation, MeltingTemperature], {}], validSimulationPacketP[Object[Simulation, MeltingTemperature], {}]}
		],

		(*
			MESSAGES
		*)
		Example[{Messages,"InvalidStrand","Given an invalid strand:"},
			SimulateMeltingTemperature[Strand[DNA["AFTCG"]],1.0*Micromolar],
			$Failed,
			Messages:>{Error::InvalidStrand,Error::InvalidInput}
		],

		(** TODO: remove this all polymers should be supported now **)
		(* Example[{Messages,"UnsupportedPolymers","Given strand with unsupported polymers:"},
			SimulateMeltingTemperature[Strand[DNA["ATCG"],PNA["ATCG"],Modification["Fluorescein"]],200.0*Micromolar],
			$Failed,
			Messages:>{Error::UnsupportedPolymers,Error::InvalidInput}
		], *)

		Example[{Messages,"BadPolymerType","Specified polymer type does not match input:"},
			SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}], 200 Micromolar, Polymer->Peptide][MeltingTemperature],
			Quantity[70.18948339483404, "DegreesCelsius"],
			Messages:>{Warning::BadPolymerType},
			Stubs :> {
				SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}], 200 Micromolar, Polymer->Peptide] =
				SimulateMeltingTemperature[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}], 200 Micromolar, Polymer->Peptide,Upload->False]
			}
		],

		Example[{Messages,"InvalidSequence","Given invalid sequence:"},
			SimulateMeltingTemperature["FFFF",250.0*Micromolar],
			$Failed,
			Messages:>{Error::InvalidSequence,Error::InvalidInput}
		],

		Example[{Messages,"LengthExceedMax", "Given sequence that is too long:"},
			SimulateMeltingTemperature[500000, 250.0*Micromolar],
			$Failed,
			Messages:>{Error::LengthExceedMax,Error::InvalidInput}
		],

		Example[{Messages,"InvalidPolymerType", "With vague integer-type polymer and polymer option Null, a warning is shown and polymer option switches to Automatic:"},
			SimulateMeltingTemperature[15,250.0*Micromolar, Polymer->Null][MeltingTemperatureDistribution],
			DistributionP[Celsius],
			Messages:>{Warning::InvalidPolymerType,Warning::BadPolymerType},
			Stubs :> {
				SimulateMeltingTemperature[15, Polymer->Null] = SimulateMeltingTemperature[15, Polymer->Null, Upload->False]
			}
		],

		Example[{Messages,"InvalidSaltConcentration", "MonovalentSaltConcentration and DivalentSaltConcentration cannot both be 0 Molar:"},
			SimulateMeltingTemperature["ATCG",250.0*Micromolar,MonovalentSaltConcentration->0 Molar, DivalentSaltConcentration->0 Molar],
			$Failed,
			Messages:>{Error::InvalidSaltConcentration,Error::InvalidOption}
		],

		Example[{Messages, "UnsupportedReactionType", "Given unknown reaction type:"},
			SimulateMeltingTemperature[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1,11 ;; 14}, {1, 1, 20 ;; 23}]}]},{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Unknown], 50 Micro Molar, ReactionType -> Hybridization],
			$Failed,
			Messages:>{Error::UnsupportedReactionType,Error::InvalidInput}
		],

		Example[{Messages, "UnsupportedReactionType", "Given too many reactants:"},
			SimulateMeltingTemperature[DNA["ATGTATAG"]+DNA["TACATATC"]+DNA["GTCAGTC"], 250.0*Micromolar],
			$Failed,
			Messages:>{Error::InvalidInput,Error::ValueDoesNotMatchPattern}
		],

		Example[{Messages, "ReactionTypeNull", "Given an object with ReactionType option set to Null:"},
			SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Null][MeltingTemperature],
			Quantity[69.37661108305201, "DegreesCelsius"],
			Messages:>{Warning::ReactionTypeNull},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Null] = SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Null, Upload->False]
			}
		],

		Example[{Messages, "ReactionTypeWarning", "Given an object with no structure bonds and ReactionType option set to Melting:"},
			SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting][MeltingTemperature],
			Quantity[-273.15, "DegreesCelsius"],
			Messages:>{Warning::ReactionTypeWarning},
			EquivalenceFunction->RoundMatchQ[5],
			Stubs :> {
				SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting] = SimulateMeltingTemperature[Model[Sample, "F dsRed1"], 50 Micro Molar, ReactionType -> Melting, Upload->False]
			}
		],

		Example[{Messages,"IncorrectConcentration","Given concentration is not in the input reaction:"},
			SimulateMeltingTemperature[DNA["ATGTATAG"], {DNA["ATGTATAG"]-> QuantityDistribution[NormalDistribution[100, 5], Micromolar], DNA["TACATATC"]->25 Micro Molar}],
			$Failed,
			Messages:>{Error::IncorrectConcentration,Error::InvalidInput}
		],

		Example[{Messages, "UnsupportedMechanism", "Given ReactionMechanism that is too complicated:"},
			SimulateMeltingTemperature[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]], 25 Micromolar],
			$Failed,
			Messages :> {Error::UnsupportedMechanism,Error::InvalidInput}
		],

		Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct pattern:"},
			SimulateMeltingTemperature[LNAChimera["mUmG"], 100 Micromolar, ThermodynamicsModel -> Null][MeltingTemperature],
			$Failed,
			Messages :> {Error::InvalidThermodynamicsModel,Error::InvalidOption}
		],

		Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
			SimulateMeltingTemperature["GGACTGACGCGTTGA", 250.0*Micromolar, AlternativeParameterization -> True][MeltingTemperature],
			Quantity[64.15451825303857`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5],
			Messages :> {Warning::AlternativeParameterizationNotAvailable}
		],

		(*
			OTHER
		*)
		Test["Given oligomer sample packet:",
			SimulateMeltingTemperature[<|Object->Object[Sample, "id:jLq9jXY0ZXra"], Composition->{{Quantity[100, IndependentUnit["MassPercent"]], ECL`Link[ECL`Model[Molecule, ECL`Oligomer, "id:Z1lqpMzRZlWW"], "R8e1PjVdpNOv"]}, {Null, Null}}, Type->Object[Sample], Model->Model[Sample,"F dsRed1"],Strand->{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}|>,250.*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[71.87146076514423`, "DegreesCelsius"],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				NullFields->{ReactionModel},
				Round->5
			]
		],

		Test["Given oligomer sample link:",
			SimulateMeltingTemperature[Link[Model[Sample, "id:6V0npvK61zBe"], Objects, "XnlV5jKldxpP"],250.*Micromolar,Upload->False],
			validSimulationPacketP[Object[Simulation, MeltingTemperature],
				{
					MeltingTemperature->Quantity[71.87146076514423`, "DegreesCelsius"],
					Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
				},
				NullFields->{ReactionModel},
				Round->5
			]
		],

		Test["Nominal value check:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,Upload->False][MeltingTemperature],
			Quantity[50.443895468702436`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Check value at different MonovalentSaltConcentration:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,Upload->False,MonovalentSaltConcentration->100.Millimolar][MeltingTemperature],
			Quantity[53.66931471202648, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[5]
		],

		Test["Upload object if Upload->true:",
			SimulateMeltingTemperature[Strand[DNA["ATCGATCGATCG"]],100Micromolar,Upload->True],
			ObjectReferenceP[Object[Simulation, MeltingTemperature]],
			Stubs :> {Print[_] := Null}
		],

		Test["UnresolvedOptions or undefined options causes failure:",
			SimulateMeltingTemperature["ATCG",100Micromolar,Upload->False,Plus->True,Polymer->"string"],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {rxnUUID},
	SymbolSetUp:>{

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allDataObjects,allObjects,existingObjects,
				testReactionObject, testOligomerObject
			},

			(* create a test reaction model object *)
			rxnUUID = CreateUUID[];
			testReactionObject = Model[Sample, "Hybridization test"<>rxnUUID];
			testOligomerObject = Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID];
			(* All data objects generated for unit tests *)
			allDataObjects=
				{
					testReactionObject,
					testOligomerObject
				};

			allObjects=allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNASimulateMeltingTemperaturePacket=
			<|
				Name->"XNASimulateMeltingTemperature"<>rxnUUID,
				Type->Model[Physics,Thermodynamics],
				Replace[Authors]->Link[$PersonID],
				Replace[StackingEnergy]->Join[stackingEnergy,stackingEnergyRNA],
				Replace[StackingEnthalpy]->Join[stackingEnthalpy,stackingEnthalpyRNA],
				Replace[StackingEntropy]->Join[stackingEntropy,stackingEntropyRNA],
				Replace[InitialEnergyCorrection]->{{DNA,DNA,1.96` KilocaloriePerMole},{DNA,RNA,3.1` KilocaloriePerMole}},
				Replace[InitialEnthalpyCorrection]->{{DNA,DNA,0.2` KilocaloriePerMole},{DNA,RNA,1.9` KilocaloriePerMole}},
				Replace[InitialEntropyCorrection]->{{DNA,DNA,-5.6` CaloriePerMoleKelvin},{DNA,RNA,-3.9` CaloriePerMoleKelvin}},
				Replace[TerminalEnergyCorrection]->{{DNA,DNA,0.05` KilocaloriePerMole}},
				Replace[TerminalEnthalpyCorrection]->{{DNA,DNA,2.2` KilocaloriePerMole}},
				Replace[TerminalEntropyCorrection]->{{DNA,DNA,6.9` CaloriePerMoleKelvin}},
				Replace[SymmetryEnergyCorrection]->{{DNA,DNA,0.43` KilocaloriePerMole}},
				Replace[SymmetryEntropyCorrection]->{{DNA,DNA,-1.4` CaloriePerMoleKelvin}},
				DeveloperObject->True
			|>;

		testReactionPacket = <|
			Type->Model[Reaction],
			Name->"Hybridization test"<>rxnUUID,
			Replace[ProductModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[ReactantModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[Reactants] -> {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			Replace[Reaction] -> Reaction[
				{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			  {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
			  Hybridization],
			Replace[ReactionProducts] -> {
				Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]},
		    {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]
			},
			Replace[ReactionType] -> Hybridization,
			Replace[ReverseRate] -> Null
		|>;
		
		testOligomerPacket = <|
			Type -> Model[Molecule,Oligomer],
			Molecule -> Strand["ATTATACGCTT"],
			Name -> "Oligomer test"<>rxnUUID
		|>;

		(* Creating the XNA model thermodynamics object *)
		{testReaction, modelThermodynamicsXNASimulateMeltingTemperatureObject, testOligomerObject}=Upload[
			{testReactionPacket, modelThermodynamicsXNASimulateMeltingTemperaturePacket, testOligomerPacket}
		];

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}

];



(* ::Subsection::Closed:: *)
(*Equilibrium Constant*)

(* ::Subsubsection:: *)
(*SimulateEquilibriumConstant*)

DefineTestsWithCompanions[SimulateEquilibriumConstant,{

	Example[{Basic, "Compute the equilibrium constant of a hybridization reaction between given sequence and its reverse complement:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius][EquilibriumConstant],
		4.563312527183258`*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius] =
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Upload->False]
		}
	],

	Test["Preview shows energy when computing the equilibrium constant of a hybridization reaction between given sequence and its reverse complement:",
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Output->Preview],
		4.563312527183258`*^10,
		EquivalenceFunction->RoundMatchQ[5]
	],

	Test["Compute the equilibrium constant of a hybridization reaction between given sequence and its reverse complement:",
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				EquilibriumConstant->4.563312527183258`*^10,
				Temperature->Quantity[37., "DegreesCelsius"],
				Append[Reactants]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]},
				Append[Products]->{Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]},
				Reaction->Reaction[{Structure[{Strand[DNA["GGACTGACGCGTTGA"]]}, {}], Structure[{Strand[DNA["TCAACGCGTCAGTCC"]]}, {}]}, {Structure[{Strand[DNA["GGACTGACGCGTTGA"]], Strand[DNA["TCAACGCGTCAGTCC"]]}, {Bond[{1, 1}, {2, 1}]}]}, Hybridization]
			},
			Round->5
		]
	],

	Example[{Basic, "Find the product of DNA['GGACTGACGCGTTGA']+DNA['TCAACGCGTCAGTCC'], then compute the  equilibrium constant:"},
		SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius][EquilibriumConstant],
		4.563312527183258`*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius] =
			SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"]+DNA["TCAACGCGTCAGTCC"],37*Celsius, Upload->False]
		}
	],

	Example[{Basic, "Specify reaction from one structure to another:"},
		SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]][EquilibriumConstant],
		43.12961748457293`,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}]] =
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False]
		}
	],

	Test["Specify reaction from one structure to another:",
		SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,11;;14},{1,1,20;;23}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,3;;6},{1,1,29;;32}],Bond[{1,1,11;;14},{1,1,20;;23}]}],Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				EquilibriumConstant->43.12961748457293`,
				Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
				Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
				Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
			},
			Round->5
		]
	],

	Example[{Basic, "Compute the equilibrium constant from entropy and enthalpy:"},
		SimulateEquilibriumConstant[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37.0*Celsius][EquilibriumConstant],
		941072.4572623547`,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37.0*Celsius] =
			SimulateEquilibriumConstant[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37.0*Celsius, Upload->False]
		}
	],

	Test["Compute the equilibrium constant from entropy and enthalpy:",
		N[SimulateEquilibriumConstant[-55*KilocaloriePerMole,-150*CaloriePerMoleKelvin,37.0*Celsius, Upload->False],5],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				EquilibriumConstant->941072.4572623547`,
				Temperature->Quantity[37., "DegreesCelsius"]
			},
			Round->5
		]
	],

	Example[{Basic, "Compute the equilibrium constant from free energy:"},
		SimulateEquilibriumConstant[-6*KilocaloriePerMole,37.0*Celsius][EquilibriumConstant],
		16899.270112342034`,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[-6*KilocaloriePerMole,37.0*Celsius] =
			SimulateEquilibriumConstant[-6*KilocaloriePerMole,37.0*Celsius, Upload->False]
		}
	],

	Test["Compute the equilibrium constant from free energy:",
		SimulateEquilibriumConstant[-6*KilocaloriePerMole,37.0*Celsius,Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
		{
				EquilibriumConstant->16899.270112342034`,
				Temperature->Quantity[37., "DegreesCelsius"]
			},
			Round->5
		]
	],

	(* --- Additional --- *)
	Example[{Additional, "Temperature is defaulted to 37 Celsius if not specified:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA"][{EquilibriumConstant, Temperature}],
		{4.563312527183258`*^10, Quantity[37., "DegreesCelsius"]},
		EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Additional, "Input enthalpy and entropy as distributions:"},
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], 37 Celsius][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], 37 Celsius] =
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], 37 Celsius, Upload->False]
		}
	],

	Test["Preview shows energy distribution when input enthalpy and entropy as distributions:",
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], 37 Celsius, Output->Preview],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Additional, "Input enthalpy, entropy and temperature as distributions:"},
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[37, 5], Celsius]][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[37, 5], Celsius]] =
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[37, 5], Celsius],Upload->False]
		}
	],

	Test["Input enthalpy, entropy and temperature as distributions:",
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-55}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[-150, 10], CaloriePerMoleKelvin], QuantityDistribution[NormalDistribution[37, 5], Celsius],Upload->False],
		Simulation`Private`validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				Temperature->Quantity[37., "DegreesCelsius"],
				TemperatureStandardDeviation->Quantity[5., "DegreesCelsius"],
				TemperatureDistribution->QuantityDistribution[NormalDistribution[37., 5.], "DegreesCelsius"],
				EquilibriumConstantDistribution->DistributionP[]
			},
			Round->5
		]
	],

	Example[{Additional, "Input free energy as a distribution:"},
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], 37 Celsius][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], 37 Celsius] =
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], 37 Celsius,Upload->False]
		}
	],

	Example[{Additional, "Input free energy and temperature as distributions:"},
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[37, 5], Celsius]][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[37, 5], Celsius]] =
			SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[37, 5], Celsius],Upload->False]
		}
	],

	Test["Input free energy and temperature as distributions:",
		SimulateEquilibriumConstant[QuantityDistribution[EmpiricalDistribution[{-6}], KilocaloriePerMole], QuantityDistribution[NormalDistribution[37, 5], Celsius],Upload->False],
		Simulation`Private`validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				Temperature->Quantity[37., "DegreesCelsius"],
				TemperatureStandardDeviation->Quantity[5., "DegreesCelsius"],
				TemperatureDistribution->QuantityDistribution[NormalDistribution[37., 5.], "DegreesCelsius"],
				EquilibriumConstantDistribution->DistributionP[]
			},
			Round->5
		]
	],

	Example[{Additional, "Specify reaction from one structure to another:"},
		SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]][EquilibriumConstant],
		43.12961748457293`,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]] =
			SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False]
		}
	],

	Test["Specify reaction from one structure to another:",
		SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding],Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				EquilibriumConstant->43.12961748457293`,
				Append[Reactants]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
				Append[Products]->{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]},
				Reaction->Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, {Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Folding]
			},
			Round->5
		]
	],

	Example[{Additional, "Compute the equilibrium constant from a simple ReactionMechanism contains only one reaction:"},
		SimulateEquilibriumConstant[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit][EquilibriumConstant],
		1.66394179733061*^29,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit] =
			SimulateEquilibriumConstant[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit, Upload->False]
		}
	],

	Test["Compute the equilibrium constant from a simple ReactionMechanism contains only one reaction:",
		SimulateEquilibriumConstant[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]],65Fahrenheit, Upload->False],
		Simulation`Private`validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				Temperature->Quantity[18.333333333333396, "DegreesCelsius"],
				EquilibriumConstant->1.66394179733061*^29,
				EquilibriumConstantStandardDeviation->0,
				EquilibriumConstantDistribution->DataDistribution["Empirical", {{1.}, {1.66394179733061*^29}, False}, 1, 1],
				Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
				Append[Products]->{ Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
				Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
			},
			Round->5
		]
	],

	Test["Compute the equilibrium constant from a simple Reaction contains only one reaction:",
		SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation],65Fahrenheit, Upload->False],
		Simulation`Private`validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				Temperature->Quantity[18.333333333333396, "DegreesCelsius"],
				EquilibriumConstant->1.66394179733061*^29,
				EquilibriumConstantStandardDeviation->0,
				EquilibriumConstantDistribution->DataDistribution["Empirical", {{1.}, {1.66394179733061*^29}, False}, 1, 1],
				Append[Reactants]->{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]},
				Append[Products]->{ Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},
				Reaction->Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]
			},
			Round->5
		]
	],

	Example[{Additional, "Pull strand from given sample:"},
		SimulateEquilibriumConstant[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius][EquilibriumConstant],
		4.928636949664236`*^14,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius] =
			SimulateEquilibriumConstant[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius, Upload->False]
		}
	],

	Test["Pull strand from given sample:",
		SimulateEquilibriumConstant[Object[Sample, "id:jLq9jXY0ZXra"],37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Test["Given oligomer sample packet:",
		SimulateEquilibriumConstant[<|Object->Object[Sample, "id:jLq9jXY0ZXra"], Composition->{{Quantity[100, IndependentUnit["MassPercent"]], ECL`Link[ECL`Model[Molecule, ECL`Oligomer, "id:Z1lqpMzRZlWW"], "R8e1PjVdpNOv"]}, {Null, Null}}, Type->Object[Sample], Model->Model[Sample,"F dsRed1"],Strand->{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}|>,Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],
			{
				EquilibriumConstant->4.928636949664236`*^14,
				Append[ReactantModels]->{Link[Model[Molecule, Oligomer, _String],Simulations]}
			},
			NullFields->{ReactionModel},
			Round->5
		]
	],

	Example[{Additional, "Pull strand from given model:"},
		SimulateEquilibriumConstant[Model[Sample,"F dsRed1"],37*Celsius][EquilibriumConstant],
		4.928636949664236`*^14,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Sample,"F dsRed1"],37*Celsius] =
			SimulateEquilibriumConstant[Model[Sample,"F dsRed1"],37*Celsius, Upload->False][[1]]
		}
	],
	
	Example[{Additional, "Given an oligomer molecule model:"},
		SimulateEquilibriumConstant[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 37 Celsius][EquilibriumConstant],
		46408.3,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 37 Celsius][EquilibriumConstant] =
				SimulateEquilibriumConstant[Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID], 37 Celsius, Upload -> False][EquilibriumConstant]
		}
	],

	Test["Pull strand from given model:",
		SimulateEquilibriumConstant[Model[Sample,"F dsRed1"],37*Celsius, Upload->False][[1]],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Given a reaction model:"},
		SimulateEquilibriumConstant[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius][EquilibriumConstant],
		4.928636949664236`*^14,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius] =
			SimulateEquilibriumConstant[Model[Reaction,"Hybridization test"<>rxnUUID], 37 Celsius, Upload->False]
		}
	],

	Example[{Additional, "Given structure, computes equilibrium constant of all bonded regions:"},
		SimulateEquilibriumConstant[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37*Celsius][EquilibriumConstant],
		1.0346342050888123`*^13,
		EquivalenceFunction->RoundMatchQ[3],
		Stubs :> {
			SimulateEquilibriumConstant[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37*Celsius] =
			SimulateEquilibriumConstant[Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}],37*Celsius, Upload->False]
		}
	],

	Test["Given structure, computes equilibrium constant of all bonded regions:",
		SimulateEquilibriumConstant[Structure[{Strand[DNA["CC"],DNA["AAAAA"],DNA["CC"]],Strand[DNA["AT"],DNA["TTTTT"],DNA["AT"]]},{Bond[{1,2},{2,2}]}],37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Compute the distribution of equilibrium constant of all 15-mer hybridization reactions with their reverse complements:"},
		SimulateEquilibriumConstant[DNA[15],37*Celsius][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[DNA[15],37*Celsius] =
			SimulateEquilibriumConstant[DNA[15],37*Celsius, Upload->False]
		}
	],

	Test["Compute the distribution of  equilibrium constant of all 15-mer hybridization reactions with their reverse complements:",
		SimulateEquilibriumConstant[DNA[15],37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Given a strand:"},
		SimulateEquilibriumConstant[Strand[DNA["ATCGATCGATCG"]],37*Celsius][EquilibriumConstant],
		9.870019429428227`*^6,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Strand[DNA["ATCGATCGATCG"]],37*Celsius] =
			SimulateEquilibriumConstant[Strand[DNA["ATCGATCGATCG"]],37*Celsius, Upload->False]
		}
	],

	Test["Given a strand:",
		SimulateEquilibriumConstant[Strand[DNA["ATCGATCGATCG"]],37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Given a typed sequence:"},
		SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"],37*Celsius][EquilibriumConstant],
		4.563312527183258`*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"],37*Celsius] =
			SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"],37*Celsius, Upload->False]
		}
	],

	Test["Given a typed sequence:",
		SimulateEquilibriumConstant[DNA["GGACTGACGCGTTGA"],37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Given untyped length:"},
		SimulateEquilibriumConstant[15,37*Celsius][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[15,37*Celsius] =
			SimulateEquilibriumConstant[15,37*Celsius, Upload->False]
		}
	],

	Test["Given untyped length:",
		SimulateEquilibriumConstant[15,37*Celsius, Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Structure with no bonds returns 1:"},
		SimulateEquilibriumConstant[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]][EquilibriumConstant],
		1.,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}]] =
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False]
		}
	],

	Test["Structure with no bonds returns one:",
		SimulateEquilibriumConstant[Structure[{Strand[DNA["AAACCCTTTGGG"]]},{}],Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Additional, "Can handle degenerate sequence and return a distribution:"},
		SimulateEquilibriumConstant["ACNCATGGNCCGA"][EquilibriumConstantDistribution],
		DistributionP[],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["ACNCATGGNCCGA"] =
			SimulateEquilibriumConstant["ACNCATGGNCCGA",Upload->False]
		}
	],

	Test["Can handle degenerate sequence and return a distribution:",
		SimulateEquilibriumConstant["ACNCATGGNCCGA",Upload->False],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	(*
		OPTIONS
	*)
	Example[{Options,Polymer,"Specify polymer for untyped sequences:"},
		{SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->DNA][EquilibriumConstant], SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->RNA][EquilibriumConstant]},
		{69983.22786164557`, 279331.0931542792`},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->DNA] = SimulateEquilibriumConstant["CGCGCG",37.0*Celsius, Upload->False,Polymer->DNA],
			SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->RNA] = SimulateEquilibriumConstant["CGCGCG",37.0*Celsius, Upload->False,Polymer->RNA]
		}
	],

	Example[{Options,ReactionType,"Given an object, specify if the strands should be hybridized or the structure melted:"},
		SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting][EquilibriumConstant],
		1.,
		Messages:>{Warning::ReactionTypeWarning},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting] = SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting, Upload->False][[1]]
		}
	],

	Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
		{
			SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->DNA,Upload->False][EquilibriumConstant],
			SimulateEquilibriumConstant["CGCGCG",37.0*Celsius,Polymer->DNA,ThermodynamicsModel->modelThermodynamicsXNASimulateEquilibriumConstantPacket,Upload->False][EquilibriumConstant]
		},
		{69983.22786164557`, 1.8647038752929364`},
		EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Options,AlternativeParameterization,"Using AlternativeParameterization if there is no thermo properties in the original polymer:"},
		SimulateEquilibriumConstant[LNAChimera["mUmG"],37.0*Celsius,AlternativeParameterization->True,Upload->False][EquilibriumConstant],
		0.0109282,
		EquivalenceFunction->RoundMatchQ[5]
	],

	Example[{Options, MonovalentSaltConcentration, "Specify monovalent salt concentration in buffer:"},
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,MonovalentSaltConcentration->100.Millimolar][EquilibriumConstant],
		2.7524975570485474*^11,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,MonovalentSaltConcentration->100.Millimolar] =
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar]
		}
	],

	Test["Specify monovalent salt concentration in buffer:",
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Options, DivalentSaltConcentration, "Specify divalent salt concentration in buffer:"},
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,DivalentSaltConcentration->100.Millimolar][EquilibriumConstant],
		1.0086780083452877*^17,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,DivalentSaltConcentration->100.Millimolar] =
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,DivalentSaltConcentration->100.Millimolar]
		}
	],

	Test["Specify divalent salt concentration in buffer:",
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,DivalentSaltConcentration->100.Millimolar],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Options, BufferModel, "Specify a specific buffer, from which salt concentration will be computed:"},
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]][EquilibriumConstant],
		7.773423816465753*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]] =
			SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False,BufferModel->Model[Sample,StockSolution,"1X UV buffer"]]
		}
	],

	Test["Specify a specific buffer, from which salt concentration will be computed:",
		SimulateEquilibriumConstant[Strand[DNA["GGACTGACGCGTTGA"]],37Celsius, Upload->False, BufferModel->Model[Sample,StockSolution,"1X UV buffer"]],
		validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]
	],

	Example[{Options, Template, "The Options from a previous equilibrium constant simulation (object reference) can be used to preform an identical simulation on new oligomer:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID,ResolvedOptions]][EquilibriumConstant],
		4.563312527183258*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID,ResolvedOptions]] =
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID,ResolvedOptions], Upload->False]
		},
		SetUp :> (
			theTemplateObject = Upload[<|Type->Object[Simulation, EquilibriumConstant], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Template, "The Options from a previous equilibrium constant simulation (object) can be used to preform an identical simulation on new oligomer:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID]][EquilibriumConstant],
		4.563312527183258*^10,
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID]] =
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Template->Object[Simulation,EquilibriumConstant,theTemplateObjectID], Upload->False]
		},
		SetUp :> (
			theTemplateObject = Upload[<|Type->Object[Simulation, EquilibriumConstant], UnresolvedOptions->{}, ResolvedOptions->{MonovalentSaltConcentration->Quantity[0.05, "Molar"], DivalentSaltConcentration->Quantity[0., "Molar"], BufferModel->Null, Polymer->DNA, Template->Null, Output->Result, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Output, "Return equilibrium constant distribution instead of mean:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius][EquilibriumConstantDistribution],
		DataDistribution["Empirical", {{1.}, {4.563312527183258*^10}, False}, 1, 1],
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius] =
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, Upload->False]
		}
	],

	(*
		OVERLOADS
	*)
	Example[{Overloads, Maps, "Maps over Free Energy input:"},
		N[SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-80 KilocaloriePerMole},37 Celsius][EquilibriumConstant]],
		{2.1140211946928783`*^49, 2.3526294444341576`*^56},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-80 KilocaloriePerMole},37 Celsius] =
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-80 KilocaloriePerMole},37 Celsius, Upload->False]
		}
	],

	Test["Maps over Free Energy input:",
		SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-80 KilocaloriePerMole},37 Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Example[{Overloads, Maps, "Maps over enthalpy input:"},
		SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius][EquilibriumConstant],
		{5.113822233996058*^6, 0.4595143175499234},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius] =
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius, Upload->False]
		}
	],

	Test["Maps over enthalpy input:",
		SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},-195 CaloriePerMoleKelvin,37 Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Example[{Overloads, Maps, "Maps over entropy input:"},
		SimulateEquilibriumConstant[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius][EquilibriumConstant],
		{5.11379545884539`*^6, 2.822032535950516`*^15},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius] =
			SimulateEquilibriumConstant[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False]
		}
	],

	Test["Maps over entropy input:",
		SimulateEquilibriumConstant[-70 KilocaloriePerMole,{-195 CaloriePerMoleKelvin,-155CaloriePerMoleKelvin},37 Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Example[{Overloads, Maps, "MapThread over enthalpy and entropy input:"},
		SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,155CaloriePerMoleKelvin},37 Celsius][EquilibriumConstant],
		{5.11379545884539`*^6, 1.4230247928280983`*^76},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,155CaloriePerMoleKelvin},37 Celsius] =
			SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,155CaloriePerMoleKelvin},37 Celsius, Upload->False]
		}
	],

	Test["MapThread over enthalpy and entropy input:",
		SimulateEquilibriumConstant[{-70 KilocaloriePerMole,-60KilocaloriePerMole},{-195 CaloriePerMoleKelvin,155CaloriePerMoleKelvin},37 Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Test["Maps over oligomer input and preview shows either energy or energy distribution as appropriate:",
		SimulateEquilibriumConstant[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["ATGCAGTC"]]},37*Celsius, Output->Preview],
		{4.563312527183258`*^10, DistributionP[], 10192.893593677594`},
		EquivalenceFunction->RoundMatchQ[5]
	],

	Test["Maps over oligomer input:",
		SimulateEquilibriumConstant[{"GGACTGACGCGTTGA",DNA[15],Strand[DNA["ATGCAGTC"]]},37*Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Test["Maps over structure input:",
		SimulateEquilibriumConstant[{Structure[{Strand[DNA["CC"], DNA["AAAAA"], DNA["CC"]], Strand[DNA["AT"], DNA["TTTTT"], DNA["AT"]]}, {Bond[{1, 2}, {2, 2}]}], Structure[{Strand[DNA["GGACTGACGCGTCGCAAGACGCGTCAGTCC"]]}, {Bond[{1, 1 ;; 13}, {1, 18 ;; 30}]}]}, 37.0*Celsius, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant], {}],validSimulationPacketP[Object[Simulation, EquilibriumConstant], {}]}
	],

	Example[{Overloads, Maps, "Maps over temperature input:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}][EquilibriumConstant],
		{4.563312527183258`*^10, 3.539979041435941`*^8},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}] =
			SimulateEquilibriumConstant["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}, Upload->False]
		}
	],

	Test["Maps over temperature input:",
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",{37.0*Celsius,45.0*Celsius}, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	Test["MapThread over both inputs and preview shows either energy or energy distribution as appropriate:",
		SimulateEquilibriumConstant[{"GGACTGACGCGTTGA",DNA[15]},{37.0*Celsius,45.0*Celsius}, Output->Preview],
		{4.563312527183258`*^10, DistributionP[]},
		EquivalenceFunction->RoundMatchQ[5]
	],

	Test["MapThread over both inputs:",
		SimulateEquilibriumConstant[{"GGACTGACGCGTTGA",DNA[15]},{37.0*Celsius,45.0*Celsius}, Upload->False],
		{validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}], validSimulationPacketP[Object[Simulation, EquilibriumConstant],{}]}
	],

	(*
		MESSAGES
	*)
	Example[{Messages,"InvalidStrand","Given an invalid strand:"},
		SimulateEquilibriumConstant[Strand[DNA["AFTCG"]],37.0*Celsius],
		$Failed,
		Messages:>{Error::InvalidStrand,Error::InvalidInput}
	],

	Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct pattern:"},
		SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, ThermodynamicsModel -> Null][EquilibriumConstant],
		$Failed,
	 	Messages :> {Error::InvalidThermodynamicsModel, Error::InvalidOption}],

	Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
	SimulateEquilibriumConstant["GGACTGACGCGTTGA",37*Celsius, AlternativeParameterization -> True][EquilibriumConstant],
	4.563312527183258`*^10,
	EquivalenceFunction->RoundMatchQ[5],
	Messages :> {Warning::AlternativeParameterizationNotAvailable}],

	Example[{Messages,"BadPolymerType","Specified polymer type does not match input:"},
		SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],37.0*Celsius,Polymer->Peptide][EquilibriumConstant],
		43.12956245709781`,
		Messages:>{Warning::BadPolymerType},
		Stubs :> {
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],37.0*Celsius,Polymer->Peptide] =
			SimulateEquilibriumConstant[Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}]\[Equilibrium]Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]},{Bond[{1,1,Span[3,6]},{1,1,Span[29,32]}],Bond[{1,1,Span[11,14]},{1,1,Span[20,23]}]}],37.0*Celsius,Polymer->Peptide, Upload->False]
		}
	],

	Example[{Messages,"InvalidSequence","Given invalid sequence:"},
		SimulateEquilibriumConstant["FFFF"],
		$Failed,
		Messages:>{Error::InvalidSequence,Error::InvalidInput}
	],

	Example[{Messages,"LengthExceedMax", "Given sequence that is too long:"},
		SimulateEquilibriumConstant[500000, 37.0*Celsius],
		$Failed,
		Messages:>{Error::LengthExceedMax,Error::InvalidInput}
	],

	Example[{Messages,"InvalidPolymerType", "With vague integer-type polymer and polymer option Null, a warning is shown and polymer option switches to Automatic:"},
		SimulateEquilibriumConstant[15, Polymer->Null][EquilibriumConstantDistribution],
		DistributionP[],
		Messages:>{Warning::InvalidPolymerType,Warning::BadPolymerType},
		Stubs :> {
			SimulateEquilibriumConstant[15, Polymer->Null] = SimulateEquilibriumConstant[15, Polymer->Null, Upload->False]
		}
	],

	Example[{Messages, "InvalidSaltConcentration", "MonovalentSaltConcentration and DivalentSaltConcentration cannot both be 0 Molar:"},
		SimulateEquilibriumConstant["ATCG", 37.0*Celsius, Upload->False,MonovalentSaltConcentration->0 Molar, DivalentSaltConcentration->0 Molar],
		$Failed,
		Messages:>{Error::InvalidSaltConcentration,Error::InvalidOption}
	],

	Example[{Messages, "UnsupportedReactionType", "Given unknown reaction type:"},
		SimulateEquilibriumConstant[Reaction[{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1,11 ;; 14}, {1, 1, 20 ;; 23}]}]},{Structure[{Strand[DNA["AACCCCATAACCCCAACAAGGGGAAGAAGGGG"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 29 ;; 32}], Bond[{1, 1, 11 ;; 14}, {1, 1, 20 ;; 23}]}]}, Unknown], 37 Celsius, ReactionType -> Hybridization],
		$Failed,
		Messages:>{Error::UnsupportedReactionType,Error::InvalidInput}
	],

	Example[{Messages, "UnsupportedReactionType", "Given too many reactants:"},
		SimulateEquilibriumConstant[DNA["ATGTATAG"]+DNA["TACATATC"]+DNA["GTCAGTC"], 37.0*Celsius],
		$Failed,
		Messages:>{Error::InvalidInput,Error::ValueDoesNotMatchPattern}
	],

	Example[{Messages, "ReactionTypeNull", "Given an object with ReactionType option set to Null:"},
		SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null][EquilibriumConstant],
		4.928636949664236*^14,
		Messages:>{Warning::ReactionTypeNull},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null] = SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Null, Upload->False][[1]]
		}
	],

	Example[{Messages, "ReactionTypeWarning", "Given an object with no structure bonds and ReactionType option set to Melting:"},
		SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting][EquilibriumConstant],
		1.,
		Messages:>{Warning::ReactionTypeWarning},
		EquivalenceFunction->RoundMatchQ[5],
		Stubs :> {
			SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting] = SimulateEquilibriumConstant[Model[Sample, "F dsRed1"], 37 Celsius, ReactionType -> Melting, Upload->False][[1]]
		}
	],

	Example[{Messages, "UnsupportedMechanism", "Given ReactionMechanism that is too complicated:"},
		SimulateEquilibriumConstant[ReactionMechanism[Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]]}, {}], Structure[{Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {}]}, {Structure[{Strand[DNA["GGATTAGTCTGTACTGCAGAAGCTA"]], Strand[DNA["TAGCTTCTGCAGTACAGACTAATCC"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]}, Hybridization, Dissociation]], 25 Celsius],
		$Failed,
		Messages :> {Error::UnsupportedMechanism,Error::InvalidInput}
	],

	(*
		OTHER
	*)
	Test["Nominal value check:",
		SimulateEquilibriumConstant[Strand[DNA["ATCG"]],37Celsius, Upload->False][EquilibriumConstant],
		8.638756924904797,
		EquivalenceFunction->RoundMatchQ[5]
	],

	Test["Check value at different MonovalentSaltConcentration:",
		SimulateEquilibriumConstant[Strand[DNA["ATCG"]],37Celsius, Upload->False,MonovalentSaltConcentration->100.Millimolar][EquilibriumConstant],
		12.696670202275849,
		EquivalenceFunction->RoundMatchQ[5]
	],

	Test["UnresolvedOptions or undefined options causes failure:",
		SimulateEquilibriumConstant["ATCG",Upload->False,Plus->True,Polymer->"string"],
		$Failed,
		Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
	]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {rxnUUID, modelThermodynamicsXNASimulateEquilibriumConstantPacket},
	SymbolSetUp:>{

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allDataObjects,allObjects,existingObjects,
				testReactionObject, testOligomerObject
			},

			(* create a test reaction model object *)
			rxnUUID = CreateUUID[];
			testReactionObject = Model[Reaction, "Hybridization test"<>rxnUUID];
			testOligomerObject = Model[Molecule, Oligomer, "Oligomer test"<>rxnUUID];
			(* All data objects generated for unit tests *)
			allDataObjects=
				{
					testReactionObject,
					testOligomerObject
				};

			allObjects=allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNASimulateEquilibriumConstantPacket=
			<|
				Name->"XNASimulateEquilibriumConstant" <> rxnUUID,
				Type->Model[Physics,Thermodynamics],
				Replace[Authors]->Link[$PersonID],
				Replace[StackingEnergy]->Join[stackingEnergy,stackingEnergyRNA],
				Replace[StackingEnthalpy]->Join[stackingEnthalpy,stackingEnthalpyRNA],
				Replace[StackingEntropy]->Join[stackingEntropy,stackingEntropyRNA],
				Replace[InitialEnergyCorrection]->{{DNA,DNA,1.96` KilocaloriePerMole},{DNA,RNA,3.1` KilocaloriePerMole}},
				Replace[InitialEnthalpyCorrection]->{{DNA,DNA,0.2` KilocaloriePerMole},{DNA,RNA,1.9` KilocaloriePerMole}},
				Replace[InitialEntropyCorrection]->{{DNA,DNA,-5.6` CaloriePerMoleKelvin},{DNA,RNA,-3.9` CaloriePerMoleKelvin}},
				Replace[TerminalEnergyCorrection]->{{DNA,DNA,0.05` KilocaloriePerMole}},
				Replace[TerminalEnthalpyCorrection]->{{DNA,DNA,2.2` KilocaloriePerMole}},
				Replace[TerminalEntropyCorrection]->{{DNA,DNA,6.9` CaloriePerMoleKelvin}},
				Replace[SymmetryEnergyCorrection]->{{DNA,DNA,0.43` KilocaloriePerMole}},
				Replace[SymmetryEntropyCorrection]->{{DNA,DNA,-1.4` CaloriePerMoleKelvin}}
			|>;

		testReactionPacket = <|
			Type->Model[Reaction],
			Name->"Hybridization test"<>rxnUUID,
			Replace[ProductModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[ReactantModels] -> {Link[Model[Molecule, Oligomer, "id:Z1lqpMzRZlWW"], Reactions]},
			Replace[Reactants] -> {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			Replace[Reaction] -> Reaction[
				{Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]]}, {}], Structure[{Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {}]},
			  {Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]}, {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]},
			  Hybridization],
			Replace[ReactionProducts] -> {
				Structure[{Strand[DNA["GCCCTTGGTCACCTGCAGC"]], Strand[DNA["GCTGCAGGTGACCAAGGGC"]]},
		    {Bond[{1, 1, 1 ;; 19}, {2, 1, 1 ;; 19}]}]
			},
			Replace[ReactionType] -> Hybridization,
			Replace[ReverseRate] -> Null
		|>;
		
		testOligomerPacket = <|
			Type -> Model[Molecule,Oligomer],
			Molecule -> Strand["ATTATACGCTT"],
			Name -> "Oligomer test"<>rxnUUID
		|>;

		(* Creating the XNA model thermodynamics object *)
		{modelThermodynamicsXNASimulateEquilibriumConstantObject, testReaction, testOligomerObject}=Upload[
			{modelThermodynamicsXNASimulateEquilibriumConstantPacket, testReactionPacket, testOligomerPacket}
		];

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}
];


(* ::Subsection::Closed:: *)
(**)


(* ::Subsubsection::Closed:: *)
(*strandJunctions*)


DefineTests[strandJunctions,{
	Test["No junctions returns empty list:",
		strandJunctions[Strand[DNA["ATCG"]]],
		{}
	],
	Test["One DNA-DNA junction:",
		strandJunctions[Strand[DNA["AAAA"],DNA["GGGG"]]],
		{{DNA,"AG",DNA}}
	],
	Test["One DNA-RNA junction:",
		strandJunctions[Strand[DNA["AAAA"],RNA["GGGG"]]],
		{{DNA,"AG",RNA}}
	],
	Test["Multiple junctions:",
		strandJunctions[Strand[DNA["AAAA"],RNA["GGGG"],PNA["CCCC"]]],
		{{DNA,"AG",RNA},{RNA,"GC",PNA}}
	]
}];



(* ::Section:: *)
(*End Test Package*)
