(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AnalyticalProperties: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Analytical Properties*)


(* ::Subsubsection::Closed:: *)
(*MolecularWeight*)


DefineTests[MolecularWeight,{
	Example[{Basic,"Return the MolecularWeight of a Model[Molecule]:"},
		MolecularWeight[Model[Molecule, "Glycine"]],
		Quantity[75.07`,("Grams")/("Moles")]
	],
	Example[{Basic,"Return the MolecularWeight of a Molecule[]:"},
		MolecularWeight[Molecule["benzene"]],
		Quantity[78.11399999999996`,("Grams")/("Moles")],
		EquivalenceFunction -> RoundMatchQ[6]
	],
	Example[{Basic,"Return the MolecularWeight of a sequence:"},
		MolecularWeight["ATGATGATG"],
		Quantity[2777.8700000000003`,("Grams")/("Moles")]
	],
	Example[{Basic,"Given an integer length, returns the molecular weight of an average sequence of that length:"},
		MolecularWeight[10,Polymer->DNA],
		Quantity[3027.5150000000003`,("Grams")/("Moles")]
	],
	Example[{Additional,"Works with any defined polymer type in PolymerP, e.g. peptides:"},
		MolecularWeight["LysArgArgLysHis"],
		Quantity[723.8799999999999`,("Grams")/("Moles")]
	],
	Example[{Additional,"Will attempt to automatically determine the polymer type if not provided:"},
		MolecularWeight["AUCUGUAU"],
		Quantity[2471.53`,("Grams")/("Moles")]
	],
	Example[{Additional,"Works with explicitly typed sequences:"},
		MolecularWeight[RNA["NNNN"]],
		(1223.81` Gram)/Mole
	],
	Test["Explicitly typed degeneracy:",
		MolecularWeight[RNA["NNNN"]],
		(1223.81` Gram)/Mole
	],
	Test["Testing modifiers:",
		MolecularWeight["DabcylDabcyl"],
		Quantity[1389.62, ("Grams")/("Moles")]
	],
	Test["Testing long sequences:",
		MolecularWeight[54],
		Quantity[16621.204999999994`,("Grams")/("Moles")]
	],
	Example[{Attributes,"MolecularWeight is listable:"},
		MolecularWeight[{"ATGATAGA",10,"UGCUAUGUC","LysHis"}],
		{Quantity[2457.6800000000003`,("Grams")/("Moles")],Quantity[3027.5150000000003`,("Grams")/("Moles")],Quantity[2792.7100000000005`,("Grams")/("Moles")],Quantity[283.3299999999999`,("Grams")/("Moles")]}
	],
	Test["Listable on Molecule heads:",
		MolecularWeight[{Molecule["benzene"], Molecule["COC"]}],
		{78.11399999999996`,46.06900000000002`}*(Gram/Mole),
    EquivalenceFunction->RoundMatchQ[5]
	],
	Test["Listable on constellation objects:",
		MolecularWeight[{
			Model[Molecule, "Ethylbenzene"],
 			Model[Molecule, "Water"],
			Model[Molecule, "Glycine"]
		}],
		{106.16`,18.01528`,75.07`}*(Gram/Mole)
	],
	Test["Testing that giberish remains unexecuted:",
		MolecularWeight["Fish"],
		_MolecularWeight
	],
	Example[{Options,"Degeneracy will assume the mean molecular weight of all possible resolutions:"},
		MolecularWeight["ATNC"],
		(1153.5674999999999` Gram)/Mole
	],
	Test["Nmers are the same as integers:",
		MolecularWeight["NNN"],
		MolecularWeight[3]
	],
	Test["Degeracy with peptides:",
		MolecularWeight["AnyAnyAny",Polymer->Peptide],
		Quantity[394.16428571428565, "Grams"/"Moles"]
	],
	Test["Degeneracy with polymer types:",
		MolecularWeight["NNNN",Polymer->PNA],
		(1102.05` Gram)/Mole
	],
	Test["Can handle really long lengths:",
		MolecularWeight[1000],
		Quantity[308885.54000000004`,("Grams")/("Moles")]
	],
	Test["Can handle really long lengths of explicitly typed polymers:",
		MolecularWeight[DNA[100]],
		(30832.79` Gram)/Mole
	],
	Example[{Additional,"Overloaded to work on strands:"},
		MolecularWeight[Strand[DNA["ATGATA"],Peptide["LysArgHis"]]],
		(2316.74` Gram)/Mole
	],
	Example[{Additional,"Overloaded to work on structures as well:"},
		MolecularWeight[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},{Bond[{1,1},{2,1}]}]],
		Quantity[5436.64`,("Grams")/("Moles")]
	],
	Example[{Options,"Degeneracy works with strands as well:"},
		MolecularWeight[Strand[DNA[5],DNA[5]]],
		(3027.515` Gram)/Mole
	],
	Example[{Options,Polymer,"If lengths are provided, the polymer option can be used to designate the polymer type:"},
		MolecularWeight[10,Polymer->RNA],
		Quantity[3152.4650000000006`,("Grams")/("Moles")]
	],
	Example[{Options,Polymer,"Polymer option:"},
		MolecularWeight["ACCGCAG",Polymer->RNA],
		Quantity[2202.4200000000005`,("Grams")/("Moles")]
	],
	Example[{Options,Init,"Init option:"},
		MolecularWeight["AUCUGUAU",Init->True, Term->False],
		Quantity[2534.5`,("Grams")/("Moles")]
	],
	Example[{Options,Term,"Term option:"},
		MolecularWeight["AUCUGUAU",Init->False, Term->True],
		Quantity[2470.52`,("Grams")/("Moles")]
	],
	Test["More degeneracy in strands of mixed type:",
		MolecularWeight[Strand[DNA[5],Peptide[5]]],
		Quantity[2189.664642857143, "Grams"/"Moles"]
	],
	Example[{Messages,"MolecularWeightNotFound","Show a warning if the MolecularWeight of an input SLL object cannot be found:"},
		MolecularWeight[Model[Molecule, Protein, Antibody, "id:3em6ZvLlWlPM"]],
		$Failed,
		Messages:>{Warning::MolecularWeightNotFound}
	],
	Example[{Messages,"nintrp","Return $Failed if an invalid Molecule[] is provided:"},
		MolecularWeight[Molecule["taco"]],
		$Failed,
		Messages:>{Molecule::nintrp}
	]
}];


(* ::Subsubsection::Closed:: *)
(*MonoisotopicMass*)


DefineTests[MonoisotopicMass,{
	Example[{Basic,"Compute the monoisotopic mass of a Model[Molecule]:"},
		MonoisotopicMass[Model[Molecule, "Ethylbenzene"]],
		Quantity[106.07825032`,Dalton],
		EquivalenceFunction -> RoundMatchQ[8]
	],
	Example[{Basic,"Compute the monoisotopic mass of a Molecule[]:"},
		MonoisotopicMass[Molecule["Caffeine"]],
		Quantity[194.08037556`,Dalton],
		EquivalenceFunction -> RoundMatchQ[8]
	],
	Example[{Basic,"MonoisotopicMass is listable:"},
		MonoisotopicMass[{Molecule["Ethanol"],Model[Molecule, "Ethylbenzene"], Molecule["C=CC=C"]}],
		{
			Quantity[46.041864812`,Dalton],
			Quantity[106.07825032`,Dalton],
			Quantity[54.046950192`,Dalton]
		},
		EquivalenceFunction -> RoundMatchQ[8]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a DNA sequence:"},
		MonoisotopicMass[DNA["CATCATCATCATCAT"]],
		Quantity[4468.794305531301`,Dalton],
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a peptide sequence:"},
		MonoisotopicMass["LysHisArg"],
		UnitsP[Dalton]
	],
	Test["Sequence type is determined automatically, and defaults to DNA over RNA (or PNA, etc.):",
		MonoisotopicMass[{"ACG", DNA["ACG"], RNA["ACG"]}],
		{
			Quantity[869.2007308001273`,Dalton],
			Quantity[869.2007308001273`,Dalton],
			Quantity[917.1854746588072`,Dalton]
		},
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a strand:"},
		MonoisotopicMass[Strand[RNA["GAGA"], DNA["ATCG"]]],
		Quantity[2521.4466764520403`,Dalton],
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a strand with a modification:"},
		MonoisotopicMass[Strand[RNA["GAGA"],Modification["Puromycin"]]],
		Quantity[1820.4307503528826`,Dalton],
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a structure:"},
		MonoisotopicMass[
			Structure[
				{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},
				{Bond[List[1,1],List[2,1]]}
			]
		],
		Quantity[5434.002246970111`,Dalton],
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass of a Model[Molecule,Oligomer]:"},
		MonoisotopicMass[Model[Molecule, Oligomer, "id:Z1lqpMzn48kz"]],
		Quantity[7816.35353760545`,Dalton],
		EquivalenceFunction->RoundMatchQ[9]
	],
	Example[{Additional,"Input Types","Monoisotopic mass is listable across all valid input types:"},
		MonoisotopicMass[
			{
				DNA["ATGATAGA"],
				Molecule["Caffeine"],
				Model[Molecule, "Ethylbenzene"],
				Strand[DNA["ATGATA"],Peptide["LysArgHis"]],
				"LysHisLysCys",
				Structure[
					{
						Strand[DNA["ATGCATGAC", "A'"]],
						Strand[DNA["GTCATGCAT", "A"]]
					},
					{
						Bond[{1, 1}, {2, 1}]
					}
				],
				Model[Molecule, Oligomer, "id:Z1lqpMzn48kz"]}
		],
		{UnitsP[Dalton]..}
	],
	Example[{Messages,"MoleculeInfoNotFound","Show a warning if the Molecule field of input SLL object is not a valid Molecule[]:"},
		MonoisotopicMass[Model[Molecule, Protein, "id:6V0npvmVleea"]],
		$Failed,
		Messages:>{Warning::MoleculeInfoNotFound}
	],
	Example[{Messages,"nintrp","Return $Failed if an invalid Molecule[] is provided:"},
		MonoisotopicMass[Molecule["taco"]],
		$Failed,
		Messages:>{Molecule::nintrp}
	],
	Test["Invalid inputs in listable input return $Failed, but valid inputs are still computed:",
		MonoisotopicMass[{Molecule["Ethanol"],Model[Molecule, Protein, "id:6V0npvmVleea"],Molecule["C=CC=C"]}],
		{
			Quantity[46.041864812`,Dalton],
			$Failed,
			Quantity[54.046950192`,Dalton]
		},
		Messages:>{Warning::MoleculeInfoNotFound},
		EquivalenceFunction -> RoundMatchQ[8]
	]
}];


(* ::Subsubsection::Closed:: *)
(*ExactMass*)


DefineTests[ExactMass,
	{
		Example[{Basic,"Compute the most probable exact mass of caffeine:"},
			ExactMass[Molecule["Caffeine"]],
			UnitsP[Dalton]
		],
		Example[{Basic,"List the probabilities and exact masses for caffeine:"},
			ExactMass[Molecule["Caffeine"],OutputFormat->List][[;;5]]//tabulateMasses,
			_Pane
		],
		Test["Exact masses for caffeine:",
			ExactMass[Molecule["Caffeine"],ExactMassProbabilityThreshold->(1*10^-5),ExactMassResolution->0.01 Dalton,OutputFormat->List],
			{
				{0.8956288691843327`,Quantity[194.08037557894002`,("Grams")/("Moles")]},
				{0.09561067570391435`,Quantity[195.0829077340963`,("Grams")/("Moles")]},
				{0.008218635687538911`,Quantity[196.0850243295488`,("Grams")/("Moles")]},
				{0.0005162328207668176`,Quantity[197.0872777424954`,("Grams")/("Moles")]},
				{0.000024111208968407265`,Quantity[198.08940434013311`,("Grams")/("Moles")]}
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Basic,"Compute the most probable exact mass of a Model[Molecule]:"},
			ExactMass[Model[Molecule, "Ethylbenzene"]],
			UnitsP[Dalton]
		],
		Test["Exact masses for Ethylbenzene:",
			ExactMass[Model[Molecule,"Ethylbenzene"],ExactMassProbabilityThreshold->(1*10^-5),ExactMassResolution->0.01 Dalton,OutputFormat->List],
			{
				{0.9132034100464932`, Quantity[106.07825032070002`, ("Grams")/("Moles")]},
				{0.08337270331777319`, Quantity[107.08165317233619`, ("Grams")/("Moles")]},
				{0.003345511359848214`, Quantity[108.08506905741302`, ("Grams")/("Moles")]},
				{0.00007723798226433983`,Quantity[109.0885039945533`, ("Grams")/("Moles")]}
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Basic,"ExactMass is listable:"},
			ExactMass[{Molecule["Caffeine"], Model[Molecule, "Ethylbenzene"], Molecule["CCOCC"]}],
			{UnitsP[Dalton]..}
		],
		Example[{Additional,"Large Molecules:","The monoisotopic mass of large molecules is often distinct from the most probable mass:"},
			MonoisotopicMass[Molecule["n-hectane"]],
			Quantity[1403.5806564640056`,Dalton],
			EquivalenceFunction -> RoundMatchQ[9]
		],
		Example[{Additional,"Large Molecules:","The monoisotopic mass of large molecules is often distinct from the most probable mass:"},
			ExactMass[Molecule["n-hectane"],OutputFormat->List][[;;5]]//tabulateMasses,
			_Pane
		],
		Example[{Additional,"Input Types","Exact mass of a DNA sequence:"},
			ExactMass[DNA["CATCATCATCATCAT"]],
			Quantity[4470.799766850811`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass of a peptide sequence:"},
			ExactMass["LysHisArg"],
			UnitsP[Dalton]
		],
		Test["Sequence type is determined automatically, and defaults to DNA over RNA (or PNA, etc.):",
			ExactMass[{"ACG", DNA["ACG"], RNA["ACG"]}],
			{
				Quantity[869.2007308001273`,Dalton],
				Quantity[869.2007308001273`,Dalton],
				Quantity[917.1854746588072`,Dalton]
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass of a strand:"},
			ExactMass[Strand[RNA["GAGA"], DNA["ATCG"]]],
			Quantity[2522.4493121864093`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass of a strand with a modification:"},
			ExactMass[Strand[RNA["GAGA"],Modification["Puromycin"]]],
			Quantity[1820.4307503528826`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["Exact mass of a modification with a mass adjustment:",
			ExactMass[Strand[Modification["2-Aminopurine"]]],
			Quantity[313.0576051355401`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass of a structure:"},
			ExactMass[
				Structure[
					{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},
					{Bond[List[1,1],List[2,1]]}
				]
			],
			Quantity[5436.007622787157`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass of a Model[Molecule,Oligomer]:"},
			ExactMass[Model[Molecule, Oligomer, "id:Z1lqpMzn48kz"]],
			Quantity[7819.361331656936`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Additional,"Input Types","Exact mass is listable across all valid input types:"},
			ExactMass[
				{
					DNA["ATGATAGA"],
					Molecule["Caffeine"],
					Model[Molecule, "Ethylbenzene"],
					Strand[DNA["ATGATA"],Peptide["LysArgHis"]],
					"LysHisLysCys",
					Structure[
						{
							Strand[DNA["ATGCATGAC", "A'"]],
							Strand[DNA["GTCATGCAT", "A"]]
						},
						{
							Bond[{1, 1}, {2, 1}]
						}
					],
					Model[Molecule, Oligomer, "id:Z1lqpMzn48kz"]}
			],
			{UnitsP[Dalton]..}
		],
		Test["ExactMass works with PNA sequences:",
			ExactMass[PNA["ACTGGATCGA"]],
			Quantity[2752.082883506497`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["ExactMass works with GammaLeftPNA sequences:",
			ExactMass[GammaLeftPNA["ACTGGATCGA"]],
			Quantity[3192.3451680150242,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["ExactMass works with GammaRightPNA sequences:",
			ExactMass[GammaRightPNA["ACTGGATCGA"]],
			Quantity[3192.3451680150242,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["ExactMass works with RNAtom sequences:",
			ExactMass[RNAtom["ACGUGA"]],
			Quantity[3016.17866012922`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["ExactMass works with RNAtbdms sequences:",
			ExactMass[RNAtbdms["ACGUGA"]],
			Quantity[2582.8318380808146`,Dalton],
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Options,ExactMassProbabilityThreshold,"Exclude exact masses which occur with probability less than 10^-3:"},
			ExactMass[Molecule["Tryptophan"],ExactMassProbabilityThreshold->0.001,OutputFormat->List]//tabulateMasses,
			_Pane
		],
		Test["Probability threshold 0.001 test:",
			ExactMass[Molecule["Tryptophan"],ExactMassProbabilityThreshold->0.001,ExactMassResolution->0.0001 Dalton,OutputFormat->List],
			{
				{0.8722476016252756`,Quantity[204.08987763352005`,Dalton]},
				{0.10769686738643568`,Quantity[205.0932324713`,Dalton]},
				{0.006408306846956878`,Quantity[205.08691252697002`,Dalton]},
				{0.00604426750930041`,Quantity[206.09658730908004`,Dalton]},
				{0.0034973140138540824`,Quantity[206.09412401496004`,Dalton]},
				{0.001570281225109266`,Quantity[205.0961543793001`,Dalton]}
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["Probability threshold number of states test:",
			Length/@Table[
				ExactMass[Molecule["Tryptophan"],
					OutputFormat->List,
					ExactMassResolution->0.0 Dalton,
					ExactMassProbabilityThreshold->cutoff],
					{cutoff, {0.1, 0.001, 0.000001, 0.0000000001, 0.0}}
			],
			{1,8,46,RangeP[254,260],RangeP[18840,19100]}
		],
		Example[{Options,ExactMassProbabilityThreshold,"Set the probability threshold and mass resolution to zero to do an exact calculation. Note that this can be computationally expensive, as even for small molecules there are a large number of possible exact masses:"},
			Length[ExactMass[Molecule["Tryptophan"],ExactMassProbabilityThreshold->0.0,ExactMassResolution->0.0 Dalton,OutputFormat->List]],
			RangeP[18840,19100]
		],
		Example[{Options,ExactMassResolution,"Combine the probability of exact masses which differ by less than ExactMassResolution, replacing these masses with their probability-weighted center of mass:"},
			ExactMass[Molecule["Tryptophan"],
				ExactMassResolution->0.1 Dalton,
				ExactMassProbabilityThreshold->0.001,
				OutputFormat->List
			]//tabulateMasses,
			_Pane
		],
		Test["Exact mass resolution quantitative test:",
			ExactMass[Molecule["Tryptophan"],ExactMassResolution->0.1 Dalton,ExactMassProbabilityThreshold->0.001,OutputFormat->List],
			{
				{0.8722476016252756`,Quantity[204.08987763352005`,Dalton]},
				{0.11633994512113416`,Quantity[205.09292871516638`,Dalton]},
				{0.010627783956143973`,Quantity[206.09536111142205`,Dalton]}
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["Probability threshold number of states test:",
			Length/@Table[
				ExactMass[Molecule["Tryptophan"],
					OutputFormat->List,
					ExactMassProbabilityThreshold->1*10^-9,
					ExactMassResolution->res],
					{res, {0.1 Dalton, 0.001 Dalton,0.0 Dalton}}
			],
			{8,40,177|178}
		],
		Example[{Options,ExactMassResolution,"Set the ExactMassResolution to 0.0 Dalton to disable averaging of similar masses. Note that this may generate a very large number of possible masses:"},
			Length[ExactMass[Molecule["Tryptophan"],ExactMassResolution->0.0 Dalton,OutputFormat->List]],
			177|178
		],
		Example[{Options,OutputFormat,"By default, only the most probable mass is returned:"},
			ExactMass[Molecule["Glucose"]],
			UnitsP[Dalton]
		],
		Example[{Options,OutputFormat,"Set OutputFormat to List to return a list of {{probability,exact mass}..} pairs representing the distribution of exact masses:"},
			ExactMass[Molecule["Glucose"],OutputFormat->List],
			{{NumericP,UnitsP[Dalton]}..}
		],
		Example[{Options,OutputFormat,"Set OutputFormat to Distribution to return a Mathematica distribution object representing the discrete distribution of exact masses:"},
			ExactMass[Molecule["Glucose"],OutputFormat->Distribution],
			_QuantityDistribution
		],
		Example[{Options,IsotopeDistribution,"Override the default isotope distribution of Carbon to be 100% Carbon-14:"},
			{
				ExactMass[Molecule["Decane"]],
				ExactMass[Molecule["Decane"],IsotopeDistribution->{"C" -> {{1.0, 14.0 Dalton}}}]
			},
			{UnitsP[Dalton]..}
		],
		Test["IsotopeDistribution calculation with C-14 instead of C-12:",
			{
				ExactMass[Molecule["Decane"]],
				ExactMass[Molecule["Decane"],IsotopeDistribution->{"C" -> {{1.0, 14.0 Dalton}}}]
			},
			{
				Quantity[142.17215070554005`,Dalton],
				Quantity[162.17215070554005`,Dalton]
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Test["IsotopeDistribution will automatically normalize probabilities:",
			{
				ExactMass[Molecule["Decane"],IsotopeDistribution->{"C"->{{0.25, 12.0 Dalton},{0.5,13.0 Dalton},{0.25, 14.0 Dalton}}}],
				ExactMass[Molecule["Decane"],IsotopeDistribution->{"C"->{{3.0, 12.0 Dalton},{6.0,13.0 Dalton},{3.0, 14.0 Dalton}}}]
			},
			{
				Quantity[152.1721695266048`,Dalton],
				Quantity[152.1721695266048`,Dalton]
			},
			EquivalenceFunction->RoundMatchQ[9]
		],
		Example[{Options,IsotopeDistribution,"Compute the ExactMass distribution of chloroform if the hydrogens are 99% deuterated:"},
			ExactMass[Molecule["Chloroform"],
				IsotopeDistribution->{
					"H"->{
						{0.99,2.0 Dalton},
						{0.01,1.0 Dalton}
					}
				}
			],
			UnitsP[Dalton]
		],
		Example[{Messages,"UnknownComposition","If the molecular composition of a Modification or Monomer is undefined, its averaged molecular weight will be used as an approximation when calculating exact mass:"},
			ExactMass[Strand[RNA["CCCGUUCAUA"],Modification["5'-IowaBlackFQ"]]],
			UnitsP[Dalton],
			Messages:>{Warning::UnknownComposition}
		],
		Test["If no molecule or composition is available for a Modification or Monomer, then use its avg. molecular weight as an approximation for exact mass:",
			ExactMass[Strand[RNA["CCCGUUCAUA"],Modification["5'-IowaBlackFQ"]]]-MolecularWeight[Modification["5'-IowaBlackFQ"]],
			ExactMass[RNA["CCCGUUCAUA"]]+ExactMass[Lookup[Physics`Private`lookupModelOligomer[RNA,TerminalMolecule],"Removal"]],
			EquivalenceFunction->RoundMatchQ[9],
			Messages:>{Warning::UnknownComposition}
		],
		Example[{Messages,"DegenerateMassUncertain","The exact mass of a degenerate monomer is not defined, and the average molecular weight of possible degenerate substitutions will be used instead:"},
			ExactMass["AUGNNNNNNNNNUAA"],
			UnitsP[Dalton],
			Messages:>{Warning::DegenerateMassUncertain}
		],
		Test["When degeneracy is encountered in sequences the average molecular mass is used instead, and a warning is returned:",
			(MolecularWeight["AUGNNNNNNNNNUAA"]-ExactMass["AUGNNNNNNNNNUAA"]),
			(MolecularWeight["AUGUAA"]-ExactMass["AUGUAA"]),
			EquivalenceFunction->RoundMatchQ[9],
			Messages:>{Warning::DegenerateMassUncertain}
		],
		Example[{Messages,"MoleculeInfoNotFound","Show a warning if the Molecule field of input SLL object is not a valid Molecule[]:"},
			ExactMass[Model[Molecule, Protein, "id:6V0npvmVleea"]],
			$Failed,
			Messages:>{Warning::MoleculeInfoNotFound}
		],
		Example[{Messages,"UndefinedMass","Show a warning if the Molecule field of input SLL object is not a valid Molecule[]:"},
			ExactMass[Model[Molecule, Protein, "id:6V0npvmVleea"]],
			$Failed,
			Messages:>{Warning::MoleculeInfoNotFound}
		],
		Example[{Messages,"InvalidExtinctionCoefficientsModel","Show a warning if the Molecule field of input SLL object is not a valid Molecule[]:"},
			ExactMass[Model[Molecule, Protein, "id:6V0npvmVleea"]],
			$Failed,
			Messages:>{Warning::MoleculeInfoNotFound}
		],
		Example[{Messages,"nintrp","Return $Failed if an invalid Molecule[] is provided:"},
			ExactMass[Molecule["taco"]],
			$Failed,
			Messages:>{Error::MoleculeNotRecognized}
		],
		Test["Listable failures:",
			ExactMass[{
				Molecule["Caffeine"],
				Molecule["taco"],
				Model[Molecule, Protein, "id:6V0npvmVleea"],
				Model[Molecule,"Ethylbenzene"]
			}],
			{UnitsP[Dalton],$Failed,$Failed,UnitsP[Dalton]},
			Messages:>{Warning::MoleculeInfoNotFound, Error::MoleculeNotRecognized}
		],
		Example[{Messages,"missMatchPolymer","Return $Failed if the input Strand could not be resolved to a valid type:"},
			ExactMass[DNA["Taco Fiesta"]],
			$Failed,
			Messages:>{PolymerType::missMatchPolymer}
		]
	},
	Variables:>{tabulateMasses},
	SetUp:>(
		tabulateMasses=Function[{lst},PlotTable[lst,TableHeadings->{None,{"Probability","Exact Mass"}}]];
	)
];

(* ::Subsubsection::Closed:: *)
(*Hyperchromicity260*)


DefineTests[Hyperchromicity260,
	{
		Example[{Basic,"Hyperchromicity of a sequence:"},
			Hyperchromicity260["ATGATA"],
			0.249`
		],
		Example[{Basic,"Hyperchromicity of a sequence length:"},
			Hyperchromicity260[10],
			0.173`
		],
		Example[{Basic,"Given list of sequence inputs:"},
			Hyperchromicity260[{"ATGATA","TTGATAGAGATTT",15}],
			{0.249`,0.23438461538461539`,0.173`}
		],
		Example[{Additional,"Given RNA:"},
			Hyperchromicity260["AUCUGUA"],
			0.22185714285714284`
		],
		Example[{Additional,"Explicitly typed length:"},
			Hyperchromicity260[DNA[10]],
			0.173`
		],
		Example[{Additional,"Peptides return 0:"},
			Hyperchromicity260[Peptide["Lys"]],
			0.0
		],
		Example[{Options,Polymer,"Polymer option:"},
			Hyperchromicity260["CGGCAG", Polymer->RNA],
			0.09699999999999999`
		],
		Example[{Options,ExtinctionCoefficientsModel,"Model ExtinctionCoefficients option:"},
			Hyperchromicity260["CGGCAG", Polymer->RNA, ExtinctionCoefficientsModel->modelExtinctionCoefficientsXNAPacket],
			0.09699999999999999`,
			Stubs:>{
				$DeveloperSearch=True,
				$RequiredSearch="XNA"
			}
		],
		Test["Degenerate example:",
			Hyperchromicity260[DNA["NNNNNNNNNN"]],
			0.173`
		],
		Test["Sequence with unknown bases:",
			Hyperchromicity260[DNA["NNNATGCATNNNNNNN"]],
			0.18724999999999997`
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{

		$CreatedObjects={};

		(* Creating the packet associated with the extinction coefficent properties of XNA *)
		modelExtinctionCoefficientsXNAPacket=
			<|
				Name->"XNAHyperchromicity260",
				Type->Model[Physics,ExtinctionCoefficients],
				Replace[Authors]->Link[$PersonID],
				Replace[Wavelengths]->{260. Nanometer},
				Replace[MolarExtinctions]->{{{"A",(15400 LiterPerCentimeterMole)},{"C",(7400 LiterPerCentimeterMole)},{"G",(11500 LiterPerCentimeterMole)},{"T",(8700 LiterPerCentimeterMole)},{"AA",(27400 LiterPerCentimeterMole)},{"AC",(21200 LiterPerCentimeterMole)},{"AG",(25000 LiterPerCentimeterMole)},{"AT",(22800 LiterPerCentimeterMole)},{"CA",(21200 LiterPerCentimeterMole)},{"CC",(14600 LiterPerCentimeterMole)},{"CG",(18000 LiterPerCentimeterMole)},
				{"CT",(15200 LiterPerCentimeterMole)},{"GA",(25200 LiterPerCentimeterMole)},{"GC",(17600 LiterPerCentimeterMole)},{"GG",(21600 LiterPerCentimeterMole)},{"GT",(20000 LiterPerCentimeterMole)},{"TA",(23400 LiterPerCentimeterMole)},{"TA",(23400 LiterPerCentimeterMole)},{"TC",(16200 LiterPerCentimeterMole)},{"TG",(19000 LiterPerCentimeterMole)},{"TT",(16800 LiterPerCentimeterMole)}}},
				Replace[HyperchromicityCorrections]->{{"A"->0.287,"T"->0.287,"G"->0.059,"C"->0.059}},
				DeveloperObject->True
			|>;

		(* Creating the XNA model extinction coefficients object *)
		modelExtinctionCoefficientsXNAObject=Upload[modelExtinctionCoefficientsXNAPacket];

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


(* ::Subsubsection:: *)
(*ExtinctionCoefficient*)


DefineTests[ExtinctionCoefficient,
	{
		Example[{Basic,"Compute extinction coefficient of a sequence:"},
			ExtinctionCoefficient["ATGATAGACCA"],
			(119000 Liter)/(Centimeter Mole)
		],
		Example[{Basic,"Given a strand:"},
			ExtinctionCoefficient[Strand[Modification["Fluorescein"],DNA["GTCTGCAGCGGCGAGGTCCTGCAGAC"],Modification["Bhqtwo"]]],
			(271200. Liter)/(Centimeter Mole)
		],
		Example[{Basic,"Given a structure:"},
			ExtinctionCoefficient[Structure[{Strand[DNA["TGCAACTCTCCGGTT", "D'"], DNA["AGGGTCGAGACGACACATGCCTGGG", "Y'"], DNA["ACAACGTACATTTGG", "F'"], Modification["Fluorescein"]]}, {}]],
			Quantity[547900., "Liters"/("Centimeters"*"Moles")]
		],
		Example[{Basic,"Compute extinction coefficient of the Structure in a sample:"},
			ExtinctionCoefficient[Object[Sample, "id:KBL5DvYOA1zx"]],
			Quantity[547900., "Liters"/("Centimeters"*"Moles")]
		],
		Example[{Additional,"Given RNA sequence:"},
			ExtinctionCoefficient["AUGUCUAUUG"],
			(103200 Liter)/(Centimeter Mole)
		],
		Test["Given a sequence length:",
			ExtinctionCoefficient[12],
			(116075 Liter)/(Centimeter Mole)
		],
		Example[{Basic,"Given list of sequence inputs:"},
			ExtinctionCoefficient[{12,"ATGATAGA","GGCAGGCAG"}],
			{(116075 Liter)/(Centimeter Mole),(92200 Liter)/(Centimeter Mole),(90700 Liter)/(Centimeter Mole)}
		],
		Example[{Additional,"Peptide input:"},
			ExtinctionCoefficient["ArgProProGlyPheSerPro"],
			143.` * LiterPerCentimeterMole
		],
		Example[{Additional,"Directly pull extinction coefficient from Models:"},
			ExtinctionCoefficient[Model[Sample,"id:XnlV5jKRKo5n"]],
			Quantity[1.42, "Milliliters"/("Centimeters"*"Milligrams")]
		],
		Example[{Options,Polymer,"Specify a polymer type:"},
			ExtinctionCoefficient["CCGAGGC", Polymer->RNA],
			Quantity[64100,("Liters")/("Centimeters" "Moles")]
		],
		Example[{Options,ExtinctionCoefficientsModel,"Specify a model for extinction coefficient -- In this case extinction coefficients of DNA is used:"},
			ExtinctionCoefficient["CCGAGGC", Polymer->RNA, ExtinctionCoefficientsModel->modelExtinctionCoefficientsXNAPacket],
			Quantity[64700,("Liters")/("Centimeters" "Moles")],
			Stubs:>{
				$DeveloperSearch=True,
				$RequiredSearch="XNA"
			}
		],
		Example[{Options,Duplex,"Also calculate the extinction coefficient of its reverse complement:"},
			ExtinctionCoefficient["AUGUCUAUUG", Duplex->True],
			Quantity[164719.12000000002`,("Liters")/("Centimeters" "Moles")]
		],
		Example[{Options,Units,"If True, the function outputs the unit in mL/(mg cm). If False, the function outputs the regular extinction coefficient unit in L/(cm mol):"},
			ExtinctionCoefficient["GGTGCGGGAATAACACGGGA", Units->MassExtinctionCoefficient],
			Quantity[33.0876535099287, "Milliliters"/("Centimeters"*"Milligrams")]
		],
		Test["N treated same a length:",
			ExtinctionCoefficient["NNNNN"]==ExtinctionCoefficient[5],
			True
		],
		Test["Given explicitly typed length:",
			ExtinctionCoefficient[DNA[5]],
			(49050 Liter)/(Centimeter Mole)
		],
		Test["Given explicitly typed length of RNA:",
			ExtinctionCoefficient[RNA[5]],
			(50350 Liter)/(Centimeter Mole)
		],
		Test["Sequence with N:",
			ExtinctionCoefficient[DNA["NNATGATNNN"]],
			(101975 Liter)/(Centimeter Mole)
		],
		Test["Sequence of all N:",
			ExtinctionCoefficient[DNA["NNNNN"]],
			(49050 Liter)/(Centimeter Mole)
		],
		Test["Modification:",
			ExtinctionCoefficient[Modification["Fluorescein"]],
			(20900. Liter)/(Centimeter Mole)
		],
		Test["Single base:",
			ExtinctionCoefficient[DNA["A"]],
			(15400 Liter)/(Centimeter Mole)
		],
		Example[{Additional,"Strand input:"},
			ExtinctionCoefficient[Strand[Modification["Fluorescein"],DNA["GTCTGCAGCGGCGAGGTCCTGCAGAC"],Modification["Bhqtwo"]]],
			(271200. Liter)/(Centimeter Mole)
		],
		Example[{Additional,"Given a bonded structure:"},
			ExtinctionCoefficient[Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 6}, {2, 5 ;; 8}], Bond[{1, 7 ;; 11}, {3, 5 ;; 9}]}]],
			(300841.14 Liter)/(Centimeter Mole)
		],
		Example[{Additional,"Given a structure with two modifications:"},
			ExtinctionCoefficient[
				Structure[
					{Strand[
						DNA["TAGCGTACCTACCG", "H'"],
						DNA["GCGATTATCAATACGCCAGTGTTAA", "Z'"],
						DNA["CAAGACG", "E'b7"],
						Modification["3'-DBCO-C6"],
						Modification["5'-Azidopentyl"],
   					PNA["TATAATG", "E'a7"]
					]},
				{}]],
			(533250. Liter)/(Centimeter Mole)
		],
		Test["Merges motif lengths in a strand:",
			ExtinctionCoefficient[Strand[DNA[5],DNA[5]]],
			ExtinctionCoefficient[Strand[DNA[10]]]
		],
		Test["Merges motifs in a strand:",
			ExtinctionCoefficient[Strand[DNA["ATGTACA"],DNA["GCAGAGA"]]],
			ExtinctionCoefficient[Strand[DNA["ATGTACAGCAGAGA"]]]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{

		$CreatedObjects={};

		(* Creating the packet associated with the extinction coefficent properties of XNA *)
		modelExtinctionCoefficientsXNAPacket=
			<|
				Name->"XNAExtinctionCoefficient",
				Type->Model[Physics,ExtinctionCoefficients],
				Replace[Authors]->Link[$PersonID],
				Replace[Wavelengths]->{260. Nanometer},
				Replace[MolarExtinctions]->{{{"A",(15400 LiterPerCentimeterMole)},{"C",(7400 LiterPerCentimeterMole)},{"G",(11500 LiterPerCentimeterMole)},{"T",(8700 LiterPerCentimeterMole)},{"AA",(27400 LiterPerCentimeterMole)},{"AC",(21200 LiterPerCentimeterMole)},{"AG",(25000 LiterPerCentimeterMole)},{"AT",(22800 LiterPerCentimeterMole)},{"CA",(21200 LiterPerCentimeterMole)},{"CC",(14600 LiterPerCentimeterMole)},{"CG",(18000 LiterPerCentimeterMole)},
				{"CT",(15200 LiterPerCentimeterMole)},{"GA",(25200 LiterPerCentimeterMole)},{"GC",(17600 LiterPerCentimeterMole)},{"GG",(21600 LiterPerCentimeterMole)},{"GT",(20000 LiterPerCentimeterMole)},{"TA",(23400 LiterPerCentimeterMole)},{"TA",(23400 LiterPerCentimeterMole)},{"TC",(16200 LiterPerCentimeterMole)},{"TG",(19000 LiterPerCentimeterMole)},{"TT",(16800 LiterPerCentimeterMole)}}},
				Replace[HyperchromicityCorrections]->{{"A"->0.287,"T"->0.287,"G"->0.059,"C"->0.059}},
				DeveloperObject->True
			|>;

		(* Creating the XNA model extinction coefficients object *)
		modelExtinctionCoefficientsXNAObject=Upload[modelExtinctionCoefficientsXNAPacket];

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


(* ::Subsubsection::Closed:: *)
(*ECLElementData*)

DefineTests[ECLElementData,{
	Example[{Basic, "Return the atomic mass and abbreviation of a Model[Physics, ElementData]:"},
		ECLElementData[Model[Physics, ElementData, "Sodium"], {MolarMass, Abbreviation}],
		{_Quantity, "Na"}
	],
	Example[{Basic, "Return the isotope list, isotope abundance and isotope mass of a Model[Physics, ElementData]:"},
		ECLElementData[Model[Physics, ElementData, "Sodium"], {Isotopes, IsotopeMasses, IsotopeAbundance}],
		{{"23Na"}, {_Quantity}, {EqualP[100 Percent]}}
	],
	Example[{Basic, "Return the atomic mass and abbreviation, using element symbol as input:"},
		ECLElementData[Sodium, {MolarMass, Abbreviation}],
		{_Quantity, "Na"}
	],
	Example[{Basic, "Return the atomic mass and abbreviation, using element abbreviation as input:"},
		ECLElementData["Na", {MolarMass, Abbreviation}],
		{_Quantity, "Na"}
	],
	Example[{Basic, "Accepts a list of symbols as input:"},
		ECLElementData[{Sodium, Helium, Copper}, {MolarMass, Abbreviation}],
		{{_Quantity, ElementAbbreviationP}..}
	],
	Example[{Basic, "Accepts a list of abbreviations as input:"},
		ECLElementData[{"K", "Ca", "Kr"}, {MolarMass, Abbreviation}],
		{{_Quantity, ElementAbbreviationP}..}
	],
	Example[{Basic, "Accepts a list of objects as input:"},
		ECLElementData[{Model[Physics, ElementData, "Sodium"], Model[Physics, ElementData, "Potassium"], Model[Physics, ElementData, "Hydrogen"]}, {MolarMass, Abbreviation}],
		{{_Quantity, ElementAbbreviationP}..}
	],
	Example[{Options, Output, "Will output list of property values by default:"},
		ECLElementData[{Sodium, Helium, Copper}, {MolarMass, Abbreviation}],
		{{_Quantity, ElementAbbreviationP}..}
	],
	Example[{Options, Output, "Will output list of rules if Output -> Rules:"},
		ECLElementData[{Sodium, Helium, Copper}, {MolarMass, Abbreviation}, Output -> Rules],
		{{_Rule..}..}
	],
	Example[{Options, Output, "Will output list of associations if Output -> Association:"},
		ECLElementData[{Sodium, Helium, Copper}, {MolarMass, Abbreviation}, Output -> Association],
		{_Association..}
	]
}];

(* ::Subsubsection::Closed:: *)
(*ECLIsotopeData*)
DefineTests[ECLIsotopeData,{
	Example[{Basic, "Return the molar mass and abundance of an isotope:"},
		ECLIsotopeData["23Na", {IsotopeMasses, IsotopeAbundance}],
		{_Quantity, EqualP[100 Percent]}
	],
	Example[{Basic, "Can take a list of isotopes as input:"},
		ECLIsotopeData[{"23Na", "39K"}, {IsotopeMasses, IsotopeAbundance}],
		{{_Quantity, EqualP[100 Percent]}, {_Quantity, EqualP[93.2581 Percent]}}
	]
}];

(* ::Subsubsection::Closed:: *)
(*updateElementData*)
DefineTests[updateElementData,
	{
		Example[{Basic, "Return the Model[Physics, ElementData] packet of the corresponding element:"},
			updateElementData[Sodium],
			{PacketP[Model[Physics, ElementData]]}
		],
		Example[{Options, Upload, "Upload option by default was set to False; to update the object in constellation, set Upload -> True manually:"},
			updateElementData[Sodium, Upload -> True],
			{ObjectP[Model[Physics, ElementData, "Sodium"]]}
		],
		Example[{Options, Preview, "A table preview will be generated when Preview -> True:"},
			Reap[updateElementData[Sodium, Preview -> True]],
			{{PacketP[Model[Physics, ElementData]]}, {{_Pane}}},
			Stubs :> {Print[x___]:=Sow[x]}
		],
		Example[{Options, Preview, "By default Preview is set to True; to disable preview table, manually set Preview -> False:"},
			Reap[updateElementData[Sodium, Preview -> False]],
			{{PacketP[Model[Physics, ElementData]]},{}},
			Stubs :> {Print[___]:=Sow[___]}
		],
		Example[{Options, Index, "One can specify any number of Model[Physics, ElementData] object with Index -> True, such that the new or updated element data objects will also be added into Data and AbbreviationData field of these index objects:"},
			Module[{oldField, newField},
				oldField = Download[Model[Physics, ElementData, "Test index"<>$SessionUUID], {Data, AbbreviationIndex}];
				updateElementData[Sodium, Index -> Model[Physics, ElementData, "Test index"<>$SessionUUID], Upload -> True];
				newField = Download[Model[Physics, ElementData, "Test index"<>$SessionUUID], {Data, AbbreviationIndex}];
				Upload[<|Object -> Model[Physics, ElementData, "Test index"<>$SessionUUID], Replace[Data] -> {}, Replace[AbbreviationIndex] -> {}|>];
				{oldField, newField}
			],
			{{{}, {}}, {{{Sodium, ObjectP[Model[Physics, ElementData, "Sodium"]]}}, {{"Na", ObjectP[Model[Physics, ElementData, "Sodium"]]}}}}
		],
		Example[{Options, Abbreviation, "One can manually specify the abbreviation of given input element, which will overwrite the result from Wolfram database:"},
			updateElementData[{Sodium}, Abbreviation -> {"So"}, Upload -> False],
			{KeyValuePattern[Abbreviation -> "So"]}
		],
		Example[{Options, Abbreviation, "When set to Automatic, function will fetch Abbreviation from Wolfram database:"},
			Download[updateElementData[{Sodium}, Abbreviation -> {Automatic}, Upload -> True], Abbreviation],
			{"Na"}
		],
		Example[{Options, MolarMass, "When set to Automatic, function will fetch MolarMass from Wolfram database:"},
			Download[updateElementData[{Sodium}, MolarMass -> {Automatic}, Upload -> True], MolarMass],
			{RangeP[22.989769 Gram/Mole, 22.989770 Gram/Mole]},
			SetUp :> {Upload[<|Object -> Model[Physics, ElementData, "Sodium"], MolarMass -> Null|>]}
		],
		Example[{Options, MolarMass, "One can manually specify the MolarMass of given input element, which will overwrite the result from Wolfram database:"},
			Download[updateElementData[{Sodium}, MolarMass -> {23 Gram/Mole}, Upload -> True], MolarMass],
			{EqualP[23 Gram/Mole]},
			TearDown :> {updateElementData[Sodium, Upload -> True, Preview -> False, Fields -> {MolarMass}]}
		],
		Example[{Options, Period, "One can manually specify the Period of given input element, which will overwrite the result from Wolfram database:"},
			updateElementData[{Sodium}, Period -> {5}, Upload -> False],
			{KeyValuePattern[Period -> 5]}
		],
		Example[{Options, Period, "When set to Automatic, function will fetch Period from Wolfram database:"},
			Download[updateElementData[{Sodium}, Period -> {Automatic}, Upload -> True], Period],
			{3}
		],
		Example[{Options, Group, "One can manually specify the Group of given input element, which will overwrite the result from Wolfram database:"},
			updateElementData[{Sodium}, Group -> {5}, Upload -> False],
			{KeyValuePattern[Group -> 5]}
		],
		Example[{Options, Group, "When set to Automatic, function will fetch Group from Wolfram database:"},
			Download[updateElementData[{Sodium}, Group -> {Automatic}, Upload -> True], Group],
			{1}
		],
		Example[{Options, Fields, "One can manually specify which fields to update. Fields not appearing in this option will not present in final upload packet:"},
			updateElementData[{Sodium}, Fields -> {Abbreviation, Group}, Upload -> False],
			{KeyValuePattern[{Object -> ObjectP[Model[Physics, ElementData, "Sodium"]], Abbreviation -> "Na", Group -> 1}]}
		],
		Example[{Options, FastTrack, "When FastTrack -> True, function will not check whether input element is in Patterns` package or in ElementP."},
			updateElementData["Hassium", FastTrack -> True, Upload -> False, Preview -> False],
			{PacketP[Model[Physics, ElementData]], PacketP[Model[Physics, ElementData, "Full Index"]]},
			Stubs :> {updateElementData[x_String, ops:OptionsPattern[]]:=updateElementData[ToExpression[x], ops]}
		],
		Example[{Additional, "When adding a new element that does not exist in Model[Physics, ElementData, \"Full Index\"], it will be added into full index when upload:"},
			updateElementData["Hassium", FastTrack -> True, Upload -> False, Preview -> False],
			{PacketP[Model[Physics, ElementData]], PacketP[Model[Physics, ElementData, "Full Index"]]},
			Stubs :> {updateElementData[x_String, ops:OptionsPattern[]]:=updateElementData[ToExpression[x], ops]}
		],
		Example[{Message, "SymbolMissingInManifest", "If any symbols in the input element list does not exist in Patterns` package, an error will be thrown and function will return $Failed:"},
			updateElementData[ICPMS],
			$Failed,
			Messages :> {updateElementData::SymbolMissingInManifest},
			Stubs :> {ElementP = Alternatives[ICPMS]}
		],
		Example[{Message, "SymbolMissingInElementP", "If any symbols in the input element list does not exist in ElementP, an error will be thrown and function will return $Failed:"},
			updateElementData[Absorbance],
			$Failed,
			Messages :> {updateElementData::SymbolMissingInElementP}
		],
		Example[{Message, "OptionLengthMismatch", "Any of the property-related option, if specified as a list, must match the length of input, otherwise an error will be thrown and function will return $Failed:"},
			updateElementData[{Sodium}, Abbreviation -> {"Na", "K"}],
			$Failed,
			Messages :> {updateElementData::OptionLengthMismatch}
		],
		Example[{Message, "FunctionNotRunInMathematica", "If $ECLApplication != Mathematica, function will return $Failed and an error message will be thrown:"},
			Block[{$ECLApplication = Engine}, updateElementData[Sodium]],
			$Failed,
			Messages :> {updateElementData::FunctionNotRunInMathematica}
		],
		Example[{Message, "IndexNotExist", "If any of the specified index object in Index option do not exist in database, an error will be thrown:"},
			updateElementData[Sodium, Index -> {Model[Physics, ElementData, "Non-existing fake index"<>$SessionUUID], Model[Physics, ElementData, "Test index"<>$SessionUUID]}],
			{ObjectP[Model[Physics, ElementData, "Sodium"]], ObjectP[Model[Physics, ElementData, "Test index"<>$SessionUUID]]},
			Messages :> {updateElementData::IndexNotExist}
		],
		Example[{Message, "NotAnIndexObject", "If any of the specified index object in Index option is not an index object (i.e., Index field is not True), an error will be thrown:"},
			updateElementData[Sodium, Index -> {Model[Physics, ElementData, "Potassium"], Model[Physics, ElementData, "Test index"<>$SessionUUID]}],
			{ObjectP[Model[Physics, ElementData, "Sodium"]], ObjectP[Model[Physics, ElementData, "Test index"<>$SessionUUID]]},
			Messages :> {updateElementData::NotAnIndexObject}
		]
	},
	SymbolSetUp :> {
		$CreatedObjects={};
		If[DatabaseMemberQ[Model[Physics, ElementData, "Test index"<>$SessionUUID]],
			EraseObject[Model[Physics, ElementData, "Test index"<>$SessionUUID], Verbose -> False, Force -> True]
		];
		Upload[<|
			Type -> Model[Physics, ElementData],
			Index -> True,
			Name -> "Test index"<>$SessionUUID
		|>];
	},
	SymbolTearDown :> {
		If[DatabaseMemberQ[Model[Physics, ElementData, "Test index"<>$SessionUUID]],
			EraseObject[Model[Physics, ElementData, "Test index"<>$SessionUUID], Verbose -> False, Force -> True]
		];
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},
	SetUp :> {
		Upload[<|
			Object -> Model[Physics, ElementData, "Test index"<>$SessionUUID],
			Replace[Data] -> {},
			Replace[AbbreviationIndex] -> {}
		|>]
	},
	Stubs :> {
		$ECLApplication=Mathematica,
		Print[___]:=Null
	}
];

(* ::Subsubsection::Closed:: *)
(*updateIsotopeData*)
DefineTests[updateIsotopeData,
	{
		Example[{Basic, "updateIsotopeData generate packets for given input elements to update isotope-related fields:"},
			updateIsotopeData[{Sodium}],
			{KeyValuePattern[{Object -> ObjectP[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID]], Replace[Isotopes] -> _List, Replace[IsotopeAbundance] -> _List, Replace[IsotopeMasses] -> _List}]}
		],
		Example[{Options, Upload, "By default Upload is set to False, only when Upload -> True the objects in constellation will be updated."},
			updateIsotopeData[{Sodium}, Upload -> True],
			{ObjectP[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID]]}
		],
		Example[{Options, Preview, "When Preview -> True, a table will be generated to show the difference before and after update:"},
			Reap[updateIsotopeData[Sodium, Preview -> True]],
			{{PacketP[Model[Physics, ElementData]]}, {{_Pane}}},
			Stubs :> {Print[x___]:=Sow[x]}
		],
		Example[{Options, Preview, "When Preview -> False, no preview will be generated:"},
			Reap[updateIsotopeData[Sodium, Preview -> False]],
			{{PacketP[Model[Physics, ElementData]]}, {}},
			Stubs :> {Print[x___]:=Sow[x]}
		],
		Example[{Options, MassNumbers, "When set to Automatic, a list of isotopes for each input element is auto-chosen:"},
			updateIsotopeData[Sodium, MassNumbers -> Automatic, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], Isotopes],
			{"23Na"}
		],
		Example[{Options, MassNumbers, "One can manually specify MassNumbers for each input elements to change which isotopes should be included:"},
			updateIsotopeData[Sodium, MassNumbers -> {{23, 24}}, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], Isotopes],
			{"23Na", "24Na"}
		],
		Example[{Options, IncludeRareIsotopes, "When MassNumbers -> Automatic and IncludeRareIsotopes -> True, more rare isotpes that doesn't exist naturally will also be included:"},
			updateIsotopeData[Sodium, MassNumbers -> Automatic, IncludeRareIsotopes -> True, Upload -> True];
			Length[Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], Isotopes]],
			GreaterEqualP[5]
		],
		Example[{Options, MolarMass, "When MolarMass -> Automatic, function will fetch MolarMass data from Wolfram database:"},
			updateIsotopeData[Sodium, MolarMass -> Automatic, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], IsotopeMasses],
			{RangeP[22.989769 Gram/Mole, 22.989770 Gram/Mole]}
		],
		Example[{Options, MolarMass, "One can manually specify MolarMass for each MassNumber, in that case user's input will overwrite Wolfram data:"},
			updateIsotopeData[{Sodium}, MassNumbers -> {{23}}, MolarMass -> {{23 Gram/Mole}}, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], IsotopeMasses],
			{EqualP[23 Gram/Mole]}
		],
		Example[{Options, IsotopeAbundance, "When IsotopeAbundance -> Automatic, function will fetch IsotopeAbundance data from Wolfram database:"},
			updateIsotopeData[Sodium, IsotopeAbundance -> Automatic, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], IsotopeAbundance],
			{EqualP[100 Percent]}
		],
		Example[{Options, IsotopeAbundance, "One can manually specify IsotopeAbundance for each MassNumber, in that case user's input will overwrite Wolfram data:"},
			updateIsotopeData[{Sodium}, MassNumbers -> {{23}}, IsotopeAbundance -> {{50 Percent}}, Upload -> True];
			Download[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], IsotopeAbundance],
			{EqualP[50 Percent]}
		],
		Example[{Message, "OptionLengthMismatch", "Input options {MassNumbers, IncludeRareIsotopes, MolarMass, IsotopeAbundance} must either be Automatic or all match the length of input element, otherwise an error will be thrown and function will return $Failed:"},
			updateIsotopeData[{Sodium}, MassNumbers -> {{23}, {24}}, IncludeRareIsotopes -> {False, False}, MolarMass -> {{23 Gram/Mole}, {24 Gram/Mole}}, IsotopeAbundance -> {{1 Percent}, {1 Percent}}],
			$Failed,
			Messages :> {Message[updateIsotopeData::OptionLengthMismatch, {MassNumbers, IncludeRareIsotopes, MolarMass, IsotopeAbundance}, {{{23}, {24}},{False, False}, {{EqualP[23 Gram/Mole]}, {EqualP[24 Gram/Mole]}},{{EqualP[1 Percent]}, {EqualP[1 Percent]}}}]}
		],
		Example[{Message, "OptionLengthNotMatchMassNumberLength", "Input options MolarMass and IsotopeAbundance must either be Automatic or their each inner list must match the length of inner lists of MassNumbers:"},
			updateIsotopeData[{Sodium}, MassNumbers -> {{23}}, MolarMass -> {{23 Gram/Mole, 24 Gram/Mole}}, IsotopeAbundance -> {{100 Percent, 0 Percent}}],
			$Failed,
			Messages :> {updateIsotopeData::OptionLengthNotMatchMassNumberLength}
		],
		Example[{Message, "OptionLengthNotMatchMassNumberLength", "When MassNumber was set to Automatic, the corresponding MolarMass and IsotopeAbundance must also be set to Automatic:"},
			updateIsotopeData[{Sodium}, MassNumbers -> {Automatic}, MolarMass -> {{23 Gram/Mole, 24 Gram/Mole}}, IsotopeAbundance -> {{100 Percent, 0 Percent}}],
			$Failed,
			Messages :> {updateIsotopeData::OptionLengthNotMatchMassNumberLength}
		],
		Example[{Message, "FunctionNotRunInMathematica", "If $ECLApplication != Mathematica, function will return $Failed and an error message will be thrown:"},
			Block[{$ECLApplication = Engine}, updateIsotopeData[Sodium]],
			$Failed,
			Messages :> {updateIsotopeData::FunctionNotRunInMathematica}
		]
	},
	Stubs :> {
		$ECLApplication=Mathematica,
		Print[___]:=Null,
		ECLElementData[{Sodium}, {Object, Isotopes, IsotopeAbundance, IsotopeMasses}, Output -> Association]:=Download[{Model[Physics, ElementData, "fake Sodium"<>$SessionUUID]}, Packet[Object, Isotopes, IsotopeAbundance, IsotopeMasses]]
			(* Somehow the above argument is causing the function run to fail, not sure why, I'll try to work around *)
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID]],
			EraseObject[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], Verbose -> False, Force -> True]
		];
		Upload[<|
			Type -> Model[Physics, ElementData],
			Name -> "fake Sodium"<>$SessionUUID,
			Element -> Sodium,
			Abbreviation -> "Na",
			Index -> False,
			Period -> 3,
			Group -> 1,
			MolarMass -> 23 Gram/Mole
		|>];
	},
	SymbolTearDown :> {
		If[DatabaseMemberQ[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID]],
			EraseObject[Model[Physics, ElementData, "fake Sodium"<>$SessionUUID], Verbose -> False, Force -> True]
		];
	},
	SetUp :> {
		Upload[<|
			Object -> Model[Physics, ElementData, "fake Sodium"<>$SessionUUID],
			Replace[Isotopes] -> {},
			Replace[IsotopeAbundance] -> {},
			Replace[IsotopeMasses] -> {}
		|>];
	}
];

(* ::Section:: *)
(*End Test Package*)
