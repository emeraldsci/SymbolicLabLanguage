(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Physics: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*lookupModelOligomer*)


DefineTests[lookupModelOligomer,

	{

		Example[{Basic,"Lookup the alphabets for DNA:"},
			lookupModelOligomer[DNA,Alphabet],
			{"A","G","T","C"}
		],

		Example[{Basic,"Lookup the degenerate alphabet for RNA:"},
			lookupModelOligomer[RNA,DegenerateAlphabet],
			{Rule[_String,{_String..}|{}]..}
		],

		Example[{Basic,"Lookup the monomer mass for Peptide:"},
			lookupModelOligomer[Peptide,MonomerMass],
			{Rule[_String,UnitsP[GramPerMole]]..}
		],

		Example[{Additional,"Monomer mass for LNAChimera:"},
			lookupModelOligomer[LNAChimera,MonomerMass],
			{Rule[_String,UnitsP[GramPerMole]]..}
		],

		Example[{Additional,"Monomer mass for modifications:"},
			lookupModelOligomer[Modification,MonomerMass],
			{Rule[_String,UnitsP[GramPerMole]]..}
		],

		Example[{Additional,"Using the model physics object instead of the ones publically available:"},
			lookupModelOligomer[Model[Physics,Oligomer,"DNA"],Alphabet],
			{"A","G","T","C"}
		],

		Example[{Options,Product,"For returning only the modification where the model sample has a non-empty Product field:"},
			lookupModelOligomer[Modification,SyntheticMonomers,Product->True],
			{Rule[_String,ObjectP[Model[Sample]]]...}
		],

		Example[{Options,Head,"Showing the head of the alphabet when constructing the lookup table:"},
			lookupModelOligomer[DNA,SyntheticMonomers,Head->True],
			{Rule[DNA[_String],ObjectP[Model[Sample]]]..}
		],

		Example[{Options,SynthesisStrategy,"Searching for a specific synthesis strategy used for PNA synthesis:"},
			lookupModelOligomer[PNA,DownloadMonomers,SynthesisStrategy-> Fmoc, Head->True],
			{Rule[PNA[_String],ObjectP[Model[Sample]]]..}
		],

		Example[{Messages,"ObjectDoesNotExist","The model physics object does not exist:"},
			lookupModelOligomer[Model[Physics,Oligomer,"Object does not exist"],Alphabet],
			$Failed,
			Messages:>{Error::ObjectDoesNotExist}
		],

		Example[{Messages,"Deprecated","Display a warning if the model physics object is deprecated:"},
			lookupModelOligomer[Model[Physics, Oligomer, "id:Z1lqpMzWamD5"], MonomerMass],
			{Rule[_String,UnitsP[Dalton]]..},
			Messages:>{Warning::DeprecatedModel}
		],

		Example[{Messages,"ModelDoesNotExist","Display an error message if the model sample associated with the selected synthesis options does not exist:"},
			lookupModelOligomer[PNA,SyntheticMonomers,SynthesisStrategy-> Boc, Head->True],
			{$Failed..},
			Messages:>{Error::ModelDoesNotExist,General::stop}
		]


	}

];

(* ::Subsubsection::Closed:: *)
(*lookupModelExtinctionCoefficients*)


DefineTests[lookupModelExtinctionCoefficients,

	{

		Example[{Basic,"Lookup the ExtinctionCoefficients for DNA:"},
			lookupModelExtinctionCoefficients[DNA,ExtinctionCoefficients],
			{Rule[_String,UnitsP[LiterPerCentimeterMole]]..}
		],

		Example[{Basic,"Lookup the HyperchromicityCorrections for DNA:"},
			lookupModelExtinctionCoefficients[DNA,HyperchromicityCorrections],
			{Rule[_String|_Symbol,UnitsP[LiterPerCentimeterMole]|_?NumericQ]..}
		],

		Example[{Basic,"Lookup the HyperchromicityCorrections for PNA:"},
			lookupModelExtinctionCoefficients[PNA,HyperchromicityCorrections],
			{Rule[_String|_Symbol,UnitsP[LiterPerCentimeterMole]|_?NumericQ]..}
		],

		Example[{Additional,"Using the model physics object instead of the symbol of the polymers that are publically available:"},
			lookupModelExtinctionCoefficients[Model[Physics,Oligomer,"DNA"],ExtinctionCoefficients],
			{Rule[_String,UnitsP[LiterPerCentimeterMole]]..}
		],

		Example[{Messages,"ObjectDoesNotExist","The model physics object does not exist:"},
			lookupModelExtinctionCoefficients[Model[Physics,Oligomer,"Object does not exist"],ExtinctionCoefficients],
			$Failed,
			Messages:>{Error::ObjectDoesNotExist}
		]

	}

];



(* ::Subsubsection::Closed:: *)
(*lookupModelThermodynamics*)


DefineTests[lookupModelThermodynamics,

	{

		Example[{Basic,"Lookup the StackingEnergy for DNA:"},
			lookupModelThermodynamics[DNA,\[CapitalDelta]G,Stacking],
			{{{DNA[_String],DNA[_String]|RNA[_String],UnitsP[KilocaloriePerMole]}..},Null}
		],

		Example[{Basic,"Lookup the StackingEntropy for RNA:"},
			lookupModelThermodynamics[RNA,\[CapitalDelta]S,Stacking],
			{{{RNA[_String],RNA[_String]|DNA[_String],UnitsP[CaloriePerMoleKelvin]}..},Null}
		],

		Example[{Basic,"Lookup the hairpin loop enthalpy for DNA:"},
			lookupModelThermodynamics[DNA,\[CapitalDelta]G,HairpinLoop],
			{{{_Integer,UnitsP[KilocaloriePerMole]}..},_Function}
		],

		Example[{Additional,"Using the model physics object instead of the symbol of the polymers that are publically available:"},
			lookupModelThermodynamics[Model[Physics,Oligomer,"DNA"],\[CapitalDelta]G,Stacking],
			{{{DNA[_String],DNA[_String]|RNA[_String],UnitsP[KilocaloriePerMole]}..},Null}
		],

		Example[{Additional,"Lookup the StackingEnergy for LNAChimera:"},
			lookupModelThermodynamics[LNAChimera,\[CapitalDelta]G,Stacking],
			{{{LNAChimera[_String],LNAChimera[_String]|RNA[_String],UnitsP[KilocaloriePerMole]}..},Null}
		],

		Example[{Messages,"ObjectDoesNotExist","The model physics object does not exist:"},
			lookupModelThermodynamics[Model[Physics,Oligomer,"Object does not exist"],\[CapitalDelta]G,Stacking],
			{$Failed,$Failed},
			Messages:>{Error::ObjectDoesNotExist}
		]

	}

];


(* ::Subsubsection::Closed:: *)
(*lookupModelThermodynamicsCorrection*)


DefineTests[lookupModelThermodynamicsCorrection,

	{

		Example[{Basic,"Lookup the Initial correction to the free energy for DNA:"},
			lookupModelThermodynamicsCorrection[DNA,\[CapitalDelta]G,Initial],
			1.96 KilocaloriePerMole
		],

		Example[{Basic,"Lookup the Symmetry correction to the free energy for PNA:"},
			lookupModelThermodynamicsCorrection[PNA,\[CapitalDelta]G,Symmetry],
			0. KilocaloriePerMole
		],

		Example[{Basic,"Lookup the Terminal correction to the free energy for RNA:"},
			lookupModelThermodynamicsCorrection[RNA,\[CapitalDelta]G,Terminal],
			0.45 KilocaloriePerMole
		],

		Example[{Basic,"Lookup the Symmetry correction to the enthalpy for LNAChimera:"},
			lookupModelThermodynamicsCorrection[LNAChimera,\[CapitalDelta]H,Initial],
			3.61 KilocaloriePerMole
		]

	}

];


(* ::Subsubsection::Closed:: *)
(*thermodynamicParameters*)


DefineTests[thermodynamicParameters,

	{

		Example[{Basic,"Lookup entropy stacking parameters for DNA:"},
			thermodynamicParameters[DNA,\[CapitalDelta]S,Stacking],
			{(Rule[_String,{Rule[_,NumericP]..}] | Rule[_String,{Rule[_, DistributionP[]]..}] | Rule[Init|Term|Symmetry,NumericP])..}
		],

		Example[{Basic,"Lookup entropy stacking parameters for RNA:"},
			thermodynamicParameters[RNA,\[CapitalDelta]S,Stacking],
			{(Rule[_String,{Rule[_,NumericP]..}] | Rule[_String,{Rule[_, DistributionP[]]..}] | Rule[Init|Term|Symmetry,NumericP])..}
		],

		Example[{Basic,"Lookup mismatch energy parameters for RNA:"},
			thermodynamicParameters[RNA,\[CapitalDelta]G,Mismatch],
			{__Rule}
		],

		Example[{Options,Degeneracy,"If True, degenerate parameters are computed as averages of nominal parameters:"},
			"NN"/.Lookup[thermodynamicParameters[DNA,\[CapitalDelta]S,Stacking,Degeneracy->True],"NN"],
			DataDistribution["Empirical", {{0.0625, 0.0625, 0.125, 0.125, 0.25, 0.0625, 0.125, 0.0625, 0.125}, {-27.2, -24.4, -22.7, -22.4, -22.2, -21.3, -21., -20.4, -19.9}, False}, 1, 16],
			EquivalenceFunction->RoundMatchQ[12]
		],
		Example[{Options,Degeneracy,"If False, degenerate parameters are all returned as 0:"},
			"NN"/.Lookup[thermodynamicParameters[DNA,\[CapitalDelta]S,Stacking,Degeneracy->False],"NN"],
			0.0
		],

		Example[{Options,Unitless,"Convert to standard unit and strip them off:"},
			Lookup[thermodynamicParameters[DNA,\[CapitalDelta]G,Stacking,Unitless->Automatic],"CC"],
			{Rule[_String|Verbatim[_String],NumericP]..}
		],
		Example[{Options,Unitless,"Convert to standard unit and strip them off:"},
			Lookup[thermodynamicParameters[DNA,\[CapitalDelta]G,Stacking,Unitless->Automatic],"CC"],
			{Rule[_String|Verbatim[_String],NumericP]..}
		],
		Example[{Options,Unitless,"Leave units on parameters:"},
			Lookup[thermodynamicParameters[DNA,\[CapitalDelta]G,Stacking,Unitless->False],"CC"],
			{Rule[_String|Verbatim[_String],EnergyP]..}
		],
		Test["Make sure Unitless conversion works:",
			Lookup[Lookup[thermodynamicParameters[RNA,\[CapitalDelta]G,Mismatch,Unitless->(Calorie/Mole)],"G-C"],"A-A"]/Lookup[Lookup[thermodynamicParameters[RNA,\[CapitalDelta]G,Mismatch,Unitless->(Kilo*Calorie/Mole)],"G-C"],"A-A"],
			1000.
		],
		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			Lookup[thermodynamicParameters[DNA,\[CapitalDelta]G,Stacking,Unitless->False,ThermodynamicsModel->modelThermodynamicsXNAObject],"GC"],
			{Rule[_String|Verbatim[_String],EnergyP]..},
			Stubs:>{
				$DeveloperSearch=True,
				$RequiredSearchName = "XNA"
			}
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{

		$CreatedObjects={};

		(* Adding Thermo properties for XNA *)
		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

		(* Creating the packet associated with the thermodyanmic properties of XNA *)
		modelThermodynamicsXNAPacket=
			<|
				Name->"XNAThermodynamicsParameters",
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

		(* Creating the XNA model thermodynamics object *)
		modelThermodynamicsXNAObject=Upload[modelThermodynamicsXNAPacket];

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
(*lookupModelKinetics*)


DefineTests[lookupModelKinetics,

	{

		(** TODO: Quanity should be specified explicitely once the kinetic models for all polymers are populated **)

		Example[{Basic,"Lookup the ForwardHybridization for DNA:"},
			lookupModelKinetics[DNA,ForwardHybridization],
			_?QuantityQ
		],

		Example[{Basic,"Lookup the DuplexExchange for DNA:"},
			lookupModelKinetics[DNA,DuplexExchange],
			_?QuantityQ
		],

		Example[{Basic,"Lookup the StrandExchange for DNA:"},
			lookupModelKinetics[DNA,StrandExchange],
			_Function
		],

		Example[{Additional,"Using the model physics object instead of the symbol of the polymers that are publically available:"},
			lookupModelKinetics[Model[Physics,Oligomer,"DNA"],ForwardHybridization],
			_?QuantityQ
		],

		Example[{Messages,"ObjectDoesNotExist","The model physics object does not exist:"},
			lookupModelKinetics[Model[Physics,Oligomer,"Object does not exist"],ForwardHybridization],
			$Failed,
			Messages:>{Error::ObjectDoesNotExist}
		]

	}

];



(* ::Subsubsection::Closed:: *)
(*UploadModification*)


DefineTests[UploadModification,

	{

		Example[{Basic, "Uploading a test modification with the molecular weight equivalent to Tamra:"},
			UploadModification["Modification 1", Mass -> 713.13 GramPerMole],
			_?Physics`Private`validModificationQ
		],

		Example[{Basic, "Uploading a test modification with the molecular weight and extinction coefficient equivalent to Fluorescein:"},
			UploadModification["Modification 2", Mass -> 504.51 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 20900. Liter / Centimeter / Mole}}],
			_?Physics`Private`validModificationQ
		],

		Example[{Basic, "Uploading a test modification with the molecular weight, extinction coefficient, and lambdaMax equivalent to BHQ-1:"},
			UploadModification["Modification 3", Mass -> 962.91 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 8000. Liter / Centimeter / Mole}}, LambdaMax -> (534. Nanometer)],
			_?Physics`Private`validModificationQ
		],

		(* Additional *)

		Example[{Additional, "Changing a field for a pre existing modification:"},
			UploadModification[Model[Physics, Modification, "Modification for Pre-exisiting Test"], Mass -> 962.91 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 8000. Liter / Centimeter / Mole}}, LambdaMax -> (534. Nanometer)],
			_?Physics`Private`validModificationQ
		],

		Example[{Additional, "Changing a field for a pre existing modification with package format:"},
			UploadModification[Model[Physics, Modification, "Modification for Pre-exisiting Test"], Mass -> 962.91 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 8000. Liter / Centimeter / Mole}}, LambdaMax -> (534. Nanometer), Upload -> False],
			_?Physics`Private`validModificationQ
		],

		(* Options *)

		Example[{Options, SyntheticMonomer, "Uploading the synthetic monomer (Model[Sample,StockSolution]) for a test modification with Puromycin structure:"},
			UploadModification["Test Puromycin", SyntheticMonomer -> {Phosphoramidite, Null}],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, SyntheticMonomer, "Uploading the synthetic monomer (Model[Sample,StockSolution]) for a test modification with Biotin structure:"},
			UploadModification["Test Biotin", SyntheticMonomer -> {Fmoc, Model[Sample, StockSolution, "100 mM Biotin in NMP"]}],
			_?Physics`Private`validModificationQ
		],
		Example[{Options, DownloadMonomer, "Uploading the download monomer (Model[Sample,StockSolution]) for a test modification with Biotin structure:"},
			UploadModification["Test Biotin", DownloadMonomer -> {Fmoc, Model[Sample, StockSolution, "5 mM Biotin in NMP"]}],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, Molecule, "Uploading the molecular structure for a test modification with Puromycin structure:"},
			UploadModification["Test Puromycin", Molecule -> Molecule["COc1ccc(CC(N)C(=O)NC2C(CO)OC(n3cnc4c(N(C)C)ncnc43)C2O)cc1"], Mass -> 471.518 GramPerMole],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, MoleculeAdjustment, "Uploading the molecular structure for a test modification with Puromycin structure:"},
			UploadModification["Test Puromycin", Molecule -> Molecule["COc1ccc(CC(N)C(=O)NC2C(CO)OC(n3cnc4c(N(C)C)ncnc43)C2O)cc1"], MoleculeAdjustment -> {None, Molecule["[OH-]"]}, Mass -> 471.518 GramPerMole],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, Mass, "Uploading a test modification the molecular weight that is equivalent to Tamra:"},
			UploadModification["Modification 4", Mass -> 713.13 GramPerMole],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, ExtinctionCoefficients, "Uploading a test modification with the extinction coefficient that is equivalent to Tamra:"},
			UploadModification["Modification 6", Mass -> 713.13 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 31980.0 Liter / Centimeter / Mole}}],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, LambdaMax, "Uploading a test modification with the properties that are equivalent to those of Tamra:"},
			UploadModification["Modification 5", Mass -> 713.13 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 31980.0 Liter / Centimeter / Mole}}, LambdaMax -> (556. Nanometer)],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, QuantumYield, "Uploading a test modification with specifying the QuantumYield (0 in this case as the information is not available but any value between 0 and 1 is acceptable):"},
			UploadModification["Modification 5", Mass -> 713.13 GramPerMole, QuantumYield -> {{260 Nanometer, 280 Nanometer, 0}}],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, Oligomers, "Specifying the model oligomer that the modification should be attached to:"},
			UploadModification["Modification 7", Mass -> 713.13 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 31980.0 Liter / Centimeter / Mole}}, LambdaMax -> (556. Nanometer), Oligomers -> DNA],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, Upload, "Returning the modification as a packet instead of uploading to the Constellation:"},
			UploadModification["Modification 7", Mass -> 713.13 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 31980.0 Liter / Centimeter / Mole}}, Upload -> False],
			_?Physics`Private`validModificationQ
		],

		Example[{Options, Name, "Renaming a preexisting model modification and change the fields:"},
			UploadModification["Modification 7", Name -> "Changed Modification", Mass -> 713.13 GramPerMole, ExtinctionCoefficients -> {{260.0 Nanometer, 31980.0 Liter / Centimeter / Mole}}, Upload -> False],
			_?Physics`Private`validModificationQ
		],

		Example[{Messages, "ModificationDoesNotExist", "The object does not exist (not available in the database):"},
			UploadModification[Model[Physics, Modification, "Not Exist"]],
			$Failed,
			Messages :> {Error::ModificationDoesNotExist}
		]

	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},

	SymbolSetUp :> {

		$CreatedObjects = {};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				modelModificationTest1Object,
				modelModificationTest2Object,
				modelModificationTest3Object,
				modelModificationTest4Object,
				modelModificationTest5Object,
				modelModificationTest6Object,
				modelModificationTest7Object,
				modelModificationTestPuromycin,
				modelModificationTestBiotin,
				modelModificationTestPreExisting,
				allDataObjects, allObjects, existingObjects
			},

			(* All objects for XNA *)
			modelModificationTest1Object = Model[Physics, Modification, "Modification 1"];
			modelModificationTest2Object = Model[Physics, Modification, "Modification 2"];
			modelModificationTest3Object = Model[Physics, Modification, "Modification 3"];
			modelModificationTest4Object = Model[Physics, Modification, "Modification 4"];
			modelModificationTest5Object = Model[Physics, Modification, "Modification 5"];
			modelModificationTest6Object = Model[Physics, Modification, "Modification 6"];
			modelModificationTest7Object = Model[Physics, Modification, "Modification 7"];
			modelModificationTestPuromycin = Model[Physics, Modification, "Test Puromycin"];
			modelModificationTestBiotin = Model[Physics, Modification, "Test Biotin"];
			modelModificationTestPreExisting = Model[Physics, Modification, "Modification for Pre-exisiting Test"];

			(* All data objects generated for unit tests *)
			allDataObjects =
				{
					modelModificationTest1Object,
					modelModificationTest2Object,
					modelModificationTest3Object,
					modelModificationTest4Object,
					modelModificationTest5Object,
					modelModificationTest6Object,
					modelModificationTest7Object,
					modelModificationTestPuromycin,
					modelModificationTestBiotin,
					modelModificationTestPreExisting
				};

			allObjects = allDataObjects;

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		modelModificationTestPreExisting = Upload[
			<|
				Type -> Model[Physics, Modification],
				Name -> "Modification for Pre-exisiting Test",
				Mass -> 0 GramPerMole,
				Replace[ExtinctionCoefficients] -> {{260. Nanometer, 0. LiterPerCentimeterMole}}
			|>
		];
	},

	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
	},

	Stubs :> {
		getTestNotebook[] := If[MatchQ[invisibleTestNotebook, _NotebookObject],
			invisibleTestNotebook = CreateNotebook[Visible -> False],
			invisibleTestNotebook
		],
		Print[___] := Null,
		NotebookWrite[___] := Null
	}

];

(* ::Subsubsection::Closed:: *)
(*DNAPhosphoramiditeMolecularWeights*)


DefineTests[DNAPhosphoramiditeMolecularWeights,{
	Example[{Basic,"Correct format:"},
		DNAPhosphoramiditeMolecularWeights[],
		List[Rule[__,__]..](*,
		EquivalenceFunction->MatchQ*)],
	Example[{Basic,"Molecular weight of A phosphoramidite:"},
		"A"/.DNAPhosphoramiditeMolecularWeights[],
		(857.85 Gram)/Mole],
	Example[{Basic,"Molecular weight of G phosphoramidite:"},
		"G"/.DNAPhosphoramiditeMolecularWeights[],
		(824.92 Gram)/Mole]
}];


(* ::Subsubsection::Closed:: *)
(*ModifierPhosphoramiditeMolecularWeights*)


DefineTests[ModifierPhosphoramiditeMolecularWeights,{
	Example[{Basic,"Testing general format:"},
		ModifierPhosphoramiditeMolecularWeights[],
		List[Rule[__,__]..],
		EquivalenceFunction->MatchQ
	],
	Example[{Basic,"Fluorescein molecular weight:"},
		"Fluorescein"/.ModifierPhosphoramiditeMolecularWeights[],
		(1176.35 Gram)/Mole],
	Example[{Basic,"Dabcyl molecular weight:"},
		"Dabcyl"/.ModifierPhosphoramiditeMolecularWeights[],
		(568.69 Gram)/Mole]
}];


(* ::Subsubsection::Closed:: *)
(*PNAMolecularWeights*)


DefineTests[PNAMolecularWeights,{
	Example[{Basic, "Boc molecular weights:"},
		PNAMolecularWeights[Boc],
		{"Boc-A(Cbz)"->(527.53` Gram)/Mole,
		"Boc-G(Cbz)"->(543.53` Gram)/Mole,
		"Boc-C(Cbz)"->(503.51` Gram)/Mole,
		"Boc-T"->(384.38` Gram)/Mole,"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli),
		"Boc-Lys(2-Cl-Cbz)"->(414.88` Gram)/Mole,
		"Fmoc-Lys(Cbz)"->(502.56` Gram)/Mole}
	],
	Example[{Basic,"Fmoc molecular weights:"},
		PNAMolecularWeights[Fmoc],
		{"Fmoc-A(Bhoc)"->(725.75` Gram)/Mole,
		"Fmoc-G(Bhoc)"->(741.75` Gram)/Mole,
		"Fmoc-C(Bhoc)"->(701.72` Gram)/Mole,
		"Fmoc-T"->(506.51` Gram)/Mole,
		"Fmoc-Lys(Boc)"->(468.54` Gram)/Mole,
		"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli)}
	],
	Example[{Basic, "Gamma PNA molecular weights:"},
		PNAMolecularWeights[Gamma],
		{"Boc-gammaA(Cbz)"->(659.69` Gram)/Mole,
		"Boc-gammaG(Cbz)"->(675.69` Gram)/Mole,
		"Boc-gammaC(Cbz)"->(635.66` Gram)/Mole,
		"Boc-gammaT"->(516.54` Gram)/Mole,
		"Boc-Lys(2-Cl-Cbz)"->(414.88` Gram)/Mole,
		"Fmoc-Lys(Cbz)"->(502.56` Gram)/Mole,
		"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli)}
	],
	Example[{Basic, "All PNA molecular weights:"},
		PNAMolecularWeights[],
		{"Boc-A(Cbz)"->(527.53` Gram)/Mole,
		"Boc-G(Cbz)"->(543.53` Gram)/Mole,
		"Boc-C(Cbz)"->(503.51` Gram)/Mole,
		"Boc-T"->(384.38` Gram)/Mole,
		"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli),
		"Boc-Lys(2-Cl-Cbz)"->(414.88` Gram)/Mole,
		"Fmoc-Lys(Cbz)"->(502.56` Gram)/Mole,
		"Fmoc-A(Bhoc)"->(725.75` Gram)/Mole,
		"Fmoc-G(Bhoc)"->(741.75` Gram)/Mole,
		"Fmoc-C(Bhoc)"->(701.72` Gram)/Mole,
		"Fmoc-T"->(506.51` Gram)/Mole,
		"Fmoc-Lys(Boc)"->(468.54` Gram)/Mole,
		"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli),
		"Boc-gammaA(Cbz)"->(659.69` Gram)/Mole,
		"Boc-gammaG(Cbz)"->(675.69` Gram)/Mole,
		"Boc-gammaC(Cbz)"->(635.66` Gram)/Mole,
		"Boc-gammaT"->(516.54` Gram)/Mole,
		"Boc-Lys(2-Cl-Cbz)"->(414.88` Gram)/Mole,
		"Fmoc-Lys(Cbz)"->(502.56` Gram)/Mole,
		"HBTU"->(379.24` Gram)/Mole,
		"HATU"->(380.2` Gram)/Mole,
		"NMM"->(101.15` Gram)/Mole,
		"NMMDensity"->(0.92` Gram)/(Liter Milli)}
	]
}];


(* ::Subsubsection::Closed:: *)
(*ValidPolymerQ*)


DefineTests[ValidPolymerQ,
	{
		Example[{Basic,"Returns True if the info contained in Parameters[polymer] is of correct construction:"},
			ValidPolymerQ[DNA],
			True
		],

		Example[{Basic,"Returns False if the info contained in Parameters[polymer] is of incorrect construction:"},
			ValidPolymerQ[XNAOligomerValidPolymerQ],
			False
		],

		Example[{Options,Verbose,"Only display failing tests:"},
			ValidPolymerQ[XNAOligomerValidPolymerQ,Verbose->Failures],
			False
		],
		Example[{Options,Verbose,"Display every test, regardless of result:"},
			ValidPolymerQ[XNAOligomerValidPolymerQ,Verbose->True],
			False
		],

		Example[{Options,OutputFormat,"Return single boolean, only True if all polymers are valid:"},
			ValidPolymerQ[{DNA,XNAOligomerValidPolymerQ},OutputFormat->SingleBoolean],
			False
		],

		Example[{Options,OutputFormat,"Return list with one boolean for each polymer:"},
			ValidPolymerQ[{DNA,XNAOligomerValidPolymerQ},OutputFormat->Boolean],
			{True,False}
		],

		Example[{Options,OutputFormat,"Return EmeraldTestSummary object:"},
			ValidPolymerQ[DNA,OutputFormat->TestSummary],
			_EmeraldTestSummary
		],

		Test["Model[Physics,Oligomer,RNA] is of correct construction:",
			ValidPolymerQ[RNA],
			True
		],

		Test["Model[Physics,Oligomer,PNA] is of correct construction:",
			ValidPolymerQ[PNA],
			True
		],

		Test["Model[Physics,Oligomer,Peptide] is of correct construction:",
			ValidPolymerQ[Peptide],
			True
		],

		Test["Model[Physics,Oligomer,LNAChimera] is of correct construction:",
			ValidPolymerQ[LNAChimera],
			True,
			TimeConstraint -> 500
		],

		Test["All Model[Physics,Modification] objects are of correct construction:",
			ValidPolymerQ[Modification],
			True
		],

		Test["Required fields catches missing fields:",
			ValidPolymerQ[PolymerMissingFields],
			False
		],
		Test["Bad Complements:",
			ValidPolymerQ[PolymerBadComplements],
			False
		],
		Test["Bad NullMonomer:",
			ValidPolymerQ[PolymerBadNullMonomer],
			False
		],
		Test["Bad WildcardMonomer:",
			ValidPolymerQ[PolymerBadWildcardMonomer],
			False
		],

		Example[{Messages,"ObjectDoesNotExist","The model physics object does not exist:"},
			ValidPolymerQ[Model[Physics,Oligomer,"Object does not exist"]],
			{False},
			Messages:>{Error::ObjectDoesNotExist}
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch=True,
		RequiredSearch="Polymer"
	},

	SymbolSetUp:>{

		$CreatedObjects={};

		$PersonID=Object[User,"Test user for notebook-less test protocols"];

		(* Helper Function: to convert the rules for DegenerateAphabet to *)
		reformatDegenerateAlphabet[myRule_]:=Module[{first,lasts,firsts},
			first=First[myRule];
			lasts=Last[myRule];
			firsts=If[lasts==={},first,Repeat[first,Length[lasts]]];
			If[lasts==={},{{first,Null}},Transpose[{firsts,lasts}]]
		];

		(* <<< Generating the model physics object XNA which has a bad WildcardMonomer >>> *)

		(* Degenerate alphabet rules for XNA *)
		degenerateAlphabetXNA={"N"->{"A","G","T","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{}};

		modelOligomerXNAPacket=
			<|
				Name->"XNAOligomerValidPolymerQ",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"P","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetXNA,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","A","G"},
				Replace[Pairing]->{{"T"},{"C"},{"A"},{"G"}},
				Replace[AlternativeEncodings]->{{"a"->"A","t"->"T","g"->"G","c"->"C","n"->"N","b"->"B","d"->"D","h"->"H","v"->"V","w"->"W","s"->"S","m"->"M","k"->"K","r"->"R","y"->"Y","x"->"X"}},
				Replace[MonomerMass]->{313.21` GramPerMole ,329.21` GramPerMole, 304.19 GramPerMole,289.18` GramPerMole},
				InitialMass->1.01` GramPerMole,
				TerminalMass->-62.97` GramPerMole,
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerXNAObject=Upload[modelOligomerXNAPacket];

		(* <<< Generating the model physics object PolymerMissingFields >>> *)

		(* Degenerate alphabet rules for PolymerMissingFields *)
		degenerateAlphabetPolymerMissingFields={"N"->{"A","G","T","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{}};

		modelOligomerPolymerMissingFieldsPacket=
			<|
				Name->"PolymerMissingFields",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"A","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetPolymerMissingFields,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","A","G"},
				Replace[Pairing]->{{"T"},{"C"},{"A"},{"G"}},
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerPolymerMissingFieldsObject=Upload[modelOligomerPolymerMissingFieldsPacket];

		(* <<< Generating the model physics object PolymerBadComplements >>> *)

		(* Degenerate alphabet rules for PolymerBadComplements *)
		degenerateAlphabetPolymerBadComplements={"N"->{"A","G","T","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{}};

		modelOligomerPolymerBadComplementsPacket=
			<|
				Name->"PolymerBadComplements",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"A","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetPolymerBadComplements,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","G","X"},
				Replace[Pairing]->{{"T"},{"C"},{"G"},{"G"}},
				Replace[AlternativeEncodings]->{{"a"->"A","t"->"T","g"->"G","c"->"C","n"->"N","b"->"B","d"->"D","h"->"H","v"->"V","w"->"W","s"->"S","m"->"M","k"->"K","r"->"R","y"->"Y","x"->"X"}},
				Replace[MonomerMass]->{275.27` GramPerMole , 291.27` GramPerMole,266.25` GramPerMole, 251.24` GramPerMole},
				InitialMass->1.01` GramPerMole,
				TerminalMass->17.01` GramPerMole,
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerPolymerBadComplementsObject=Upload[modelOligomerPolymerBadComplementsPacket];

		(* <<< Generating the model physics object PolymerBadNullMonomer >>> *)

		(* Degenerate alphabet rules for PolymerBadNullMonomer *)
		degenerateAlphabetPolymerBadNullMonomer={"N"->{"A","G","T","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{"A"}};

		modelOligomerPolymerBadNullMonomerPacket=
			<|
				Name->"PolymerBadNullMonomer",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"A","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetPolymerBadNullMonomer,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","A","G"},
				Replace[Pairing]->{{"T"},{"C"},{"G"},{"G"}},
				Replace[AlternativeEncodings]->{{"a"->"A","t"->"T","g"->"G","c"->"C","n"->"N","b"->"B","d"->"D","h"->"H","v"->"V","w"->"W","s"->"S","m"->"M","k"->"K","r"->"R","y"->"Y","x"->"X"}},
				Replace[MonomerMass]->{275.27` GramPerMole , 291.27` GramPerMole,266.25` GramPerMole, 251.24` GramPerMole},
				InitialMass->1.01` GramPerMole,
				TerminalMass->17.01` GramPerMole,
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerPolymerBadNullMonomerObject=Upload[modelOligomerPolymerBadNullMonomerPacket];

		(* <<< Generating the model physics object PolymerBadWildcardMonomer >>> *)

		(* Degenerate alphabet rules for PolymerBadWildcardMonomer *)
		degenerateAlphabetPolymerBadWildcardMonomer={"N"->{"A","G","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{}};

		modelOligomerPolymerBadWildcardMonomerPacket=
			<|
				Name->"PolymerBadWildcardMonomer",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"A","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetPolymerBadWildcardMonomer,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","G","G"},
				Replace[Pairing]->{{"T"},{"C"},{"G"},{"G"}},
				Replace[AlternativeEncodings]->{{"a"->"A","t"->"T","g"->"G","c"->"C","n"->"N","b"->"B","d"->"D","h"->"H","v"->"V","w"->"W","s"->"S","m"->"M","k"->"K","r"->"R","y"->"Y","x"->"X"}},
				Replace[MonomerMass]->{275.27` GramPerMole , 291.27` GramPerMole,266.25` GramPerMole, 251.24` GramPerMole},
				InitialMass->1.01` GramPerMole,
				TerminalMass->17.01` GramPerMole,
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerPolymerBadWildcardMonomerObject=Upload[modelOligomerPolymerBadWildcardMonomerPacket];


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


(* ::Section:: *)
(*End Test Package*)
