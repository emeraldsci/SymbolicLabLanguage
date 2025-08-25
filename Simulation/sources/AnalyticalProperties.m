(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(**)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Analytical Properties*)


(* ::Subsubsection:: *)
(*MolecularWeight*)


DefineOptions[MolecularWeight,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potential alphabet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Init -> True, BooleanP, "Include the polymer's Init correction in the calcuation."},
		{Term -> True, BooleanP, "Include the polymer's terminal correction in the calcuation."}
	}
];

(* Messages for MolecularWeight[] *)
Warning::MolecularWeightNotFound="Could not download field MolecularWeight from `1`. Please use Inspect to verify that MolecularWeight is defined for these inputs.";

(* --- Model[Molecule] object --- *)
MolecularWeight[model:ListableP[ObjectP[Model[Molecule]]],ops:OptionsPattern[MolecularWeight]]:=Module[
	{mws,nullIndices},

	(* This overload just downloads the molecular weight field from the input *)
	mws=Download[model,MolecularWeight];

	(* Indices of inputs which have a Null in their MolecularWeight field *)
	nullIndices=Flatten@Position[ToList[mws],Null|$Failed];

	(* Show a warning message if the MolecularWeight field was missing for any fields *)
	If[MemberQ[ToList@mws,Null|$Failed],
		Message[Warning::MolecularWeightNotFound,Flatten@Part[ToList@model,nullIndices]];
	];

	(* Return the Molecular Weights *)
	mws/.{Null->$Failed}
];

(* --- Molecule[] --- *)
MolecularWeight[mols:ListableP[_Molecule],ops:OptionsPattern[MolecularWeight]]:=Module[
	{rawMWs,convertedMWs},

	(* Fetch molecular weights from MM's internal database *)
	rawMWs=Quiet[
		MoleculeValue[#,"MolecularMass"]&/@ToList[mols],
		{MoleculeValue::mol}
	]/.{_MoleculeValue->$Failed};

	(* Convert atomic mass units to g/mol. They are the same, but technically have different dimensions. *)
	convertedMWs=Map[
		If[MatchQ[#,$Failed],
			$Failed,
			#*(1 Gram/Mole)
		]&,
		Unitless[rawMWs]
	];

	(* De-list the output if the input was not listed *)
	If[MatchQ[mols,_Molecule],
		First[convertedMWs],
		convertedMWs
	]
];

(* --- Lengths --- *)
MolecularWeight[length:GreaterP[0,1], ops:OptionsPattern[]]:=Module[
	{safeOps, type},

	safeOps = SafeOptions[MolecularWeight, ToList[ops]];

	(* Determine the type of the length of sequence from the options, assume DNA by default *)
	type = Switch[Polymer/.safeOps,
		Automatic, DNA,
		_, Polymer/.safeOps
	];

	If[MatchQ[type, Peptide | Modification],
		MolecularWeight[type[StringJoin[ConstantArray["Any", length]]], ops],
		MolecularWeight[type[StringJoin[ConstantArray["N", length]]], ops]
	]

];

MolecularWeight[sequence:PolymerP[length:GreaterP[0,1],___], ops:OptionsPattern[]]:= Module[
	{type},

	(* Extract the type of sequence *)
	type = PolymerType[sequence, PassOptions[MolecularWeight, PolymerType, ops]];

	(* Obtain the mass of a defined length *)
	MolecularWeight[length, Polymer->type, ops]

];

(* --- Sequences --- *)
MolecularWeight[sequence:_?SequenceQ, ops:OptionsPattern[]]:=Module[
	{
		safeOps, type, monos, massRules, degenerateRules, monoMasses, totalMonoMass, initMass, termMass,
		invalidMonoMasses,processedMassRules,monomerMass,initialMass,terminalMass
	},

	safeOps = SafeOptions[MolecularWeight, ToList[ops]];

	(* Extract the type of sequencce *)
	type = PolymerType[sequence, PassOptions[MolecularWeight, PolymerType, safeOps]];

	(* Determine the list of Monomers in the sequence *)
	monos = Monomers[sequence, ExplicitlyTyped->False, Polymer->type, PassOptions[MolecularWeight, Monomers, safeOps]];

	(* Monomer mass values associated with the type of polymer *)
	monomerMass=Physics`Private`lookupModelOligomer[type,MonomerMass];

	(* Initial and Terminal mass values associated with the type of polymer *)
	initialMass=safeInitialMass[type,monos];
	terminalMass=safeTerminalMass[type,monos];

	(* Extract the mass rules from polymer *)
	massRules=Join[monomerMass,{Init->initialMass,Term->terminalMass}];

	(* Generate rules for the degenerate Monomers if degeneracy is on *)
	degenerateRules = Module[{degenerateAlphabet,degenerates},

		(* DegenerateAlphabet associated with the type of polymer *)
		degenerates=Physics`Private`lookupModelOligomer[type,DegenerateAlphabet];

		degenerates/.{
				Rule[mono_String,members:{_String..}]:>Rule[mono,Mean[members/.massRules]],
				Rule[mono_String,members:{}|{Null}]:>Rule[mono,0]
			}
	];

	(* Combined replacement rules defining monomer masses *)
	processedMassRules=(QuantityMagnitude/@Association[Join[massRules, degenerateRules]]);

	(* Apply the rules to all monomers *)
	monoMasses=Lookup[processedMassRules,monos];

	(* Indices of any monomers missing masses *)
	invalidMonoMasses=Flatten@Position[monoMasses,_Missing];

	(* Error if any did not resolve *)
	If[Length[invalidMonoMasses]>0,
		Message[Error::UndefinedMass,DeleteDuplicates[Flatten@Part[monos,invalidMonoMasses]],sequence,MolecularWeight];
		Return[$Failed]
	];

	(* calculate the total masses of the Monomers *)
	totalMonoMass = Total[monoMasses]* Gram/Mole;

	(* calculate the mass adjustments for initial *)
	initMass = If[Init/.safeOps, Init/.massRules, 0];

	(* calculate the mass adjustments for the terminus *)
	termMass = If[Term/.safeOps, Term/.massRules, 0];

	(* Return the total mass *)
	totalMonoMass + initMass + termMass

];

(* --- Strands --- *)
MolecularWeight[strand_?StrandQ, ops:OptionsPattern[]]:= Module[
	{motifs, startSequence, endSequence, middleSequences, startMass, endMass, middleMass},

	motifs = strand[Motifs];

	(* Obtain the starting sequence in the strand *)
	startSequence = First[motifs];

	(* Obtain the final sequence in the strand*)
	endSequence = Last[motifs];

	(* Extract the central sequences in the strand *)
	middleSequences = If[Length[motifs]>2, Most[Rest[motifs]]];

	(* Calculate the mass of the first sequence, including the Init correction;
		If the length is less than 2, then count this as both the start and terminus *)
	startMass = If[Length[motifs]>1,
		MolecularWeight[startSequence, Init->True, Term->False],
		MolecularWeight[startSequence, Init->True, Term->True]
	];

	(* Calculate the mass of the last sequence, including the Term correction;
		If the length is less than 2, then ignore this mass *)
	endMass = If[Length[motifs]>1,
		MolecularWeight[endSequence, Init->False, Term->True],
		0
	];

	(* Calculate the mass of the internal sequences without any corrections;
		If the length is greater than 2 then get the mass of the middle seuence, otherwise ignore *)
	middleMass=If[Length[motifs]>2,
		Total[MolecularWeight[middleSequences, Init->False, Term->False]],
		0
	];

	(* Returned the combined mass of the strand *)
	startMass + middleMass + endMass

];

(* --- Structures --- *)
MolecularWeight[Structure_?StructureQ, ops:OptionsPattern[]]:=Module[
	{strands, strandMass},

	(* Extract a list of strands from the Structure *)
	strands = Structure[Strands];

	(* Get a list of the mass of each strand *)
	strandMass = MolecularWeight[strands];

	(* Tally the mass list of the strands to get the final mass *)
	Total[strandMass]

];

(*--- Objects ---*)
MolecularWeight[obj:ObjectP[Object[Sample]], ops:OptionsPattern[]]:= First[obj[MolecularWeight]];
MolecularWeight[inList:{(GreaterP[0,1] | PolymerP[GreaterP[0,1],___] | _?SequenceQ | _?StrandQ | _?StructureQ)..}, ops:OptionsPattern[]]:= Map[MolecularWeight[#, ops]&, inList];


(* A helper function to get an accurate initial mass *)
safeInitialMass[type:PolymerP,monos:{_String..}]:=
	Switch[type,
		(* For LNAChimera, if the initial monomer is any of the thiolate monomers with *, we should use PS2 instead of PO2 *)
		LNAChimera,
		If[StringContainsQ[monos[[1]],"*"],
			-Quantity[Unitless[MoleculeValue[Molecule["S=P[O-]"],"MolecularMass"]],GramPerMole],
			Physics`Private`lookupModelOligomer[type,InitialMass]
		],

		_,
		Physics`Private`lookupModelOligomer[type,InitialMass]
	];

(* A helper function to get an accurate terminal mass *)
safeTerminalMass[type:PolymerP,monos:{_String..}]:=
	Physics`Private`lookupModelOligomer[type,TerminalMass];

(* A helper function to get an accurate initial molecule *)
safeInitialMolecule[type:PolymerP,monos:{_String..}]:=
	Switch[type,
		(* For LNAChimera, if the initial monomer is any of the thiolate monomers with *, we should use PS2 instead of PO2 *)
		LNAChimera,
		If[StringContainsQ[monos[[1]],"*"],
			{None,Molecule["S=P[O-]"]},
			Physics`Private`lookupModelOligomer[type,InitialMolecule]
		],

		_,
		Physics`Private`lookupModelOligomer[type,InitialMolecule]
	];

(* A helper function to get an accurate terminal molecule *)
safeTerminalMolecule[type:PolymerP,monos:{_String..}]:=
	Physics`Private`lookupModelOligomer[type,TerminalMolecule];

(* ::Subsubsection:: *)
(*resolveMoleculeInputs*)


(* Resolution of various molecule inputs into counts of constituent atoms for MonoisotopicMass and ExactMass *)
resolveMoleculeInputs[inputs:ListableP[(ObjectP[Model,Molecule]|_Molecule|SequenceP|StrandP|StructureP)]]:=Module[
	{listedInputs,downloadedMols,mols,molsAndFormulas,invalidMolIndices,monoisotopicMasses},

	(* Convert the input into a list if it isn't already *)
	listedInputs=ToList[inputs];

	(* Download the molecule object from each object input *)
	downloadedMols=Quiet[
		Download[
			(* Skip non-object inputs by setting them to Null in the download *)
			Replace[listedInputs,{Except[ObjectP[Model,Molecule]]->Null},{1}],
			{Molecule,MolecularFormula}
		],
		{Download::FieldDoesntExist}
	];

	(* Replace Object inputs with their downloaded molecules *)
	mols=MapThread[
		If[MatchQ[#1,ObjectP[Model[Molecule]]],
			#2,
			#1
		]&,
		{listedInputs,FirstOrDefault/@downloadedMols}
	];

	(* If a molecule was not resolved but a formula is available, use that instead *)
	molsAndFormulas=MapThread[
		If[MatchQ[#1,Null|$Failed]&&MatchQ[#2,_String],
			Quiet@Check[formulaToTally[#2],$Failed],
			#1
		]&,
		{mols,LastOrDefault/@downloadedMols}
	];

	(* Get indices of any entries which are not valid Molecules[] *)
	invalidMolIndices=Flatten@Position[molsAndFormulas,Null|$Failed];

	(* Warn the user if there are one or more invalid inputs *)
	If[Length[invalidMolIndices]>0,
		Message[Warning::MoleculeInfoNotFound,Flatten@Part[listedInputs,invalidMolIndices]];
	];

	(* Return the molecules *)
	molsAndFormulas
];


(* Convert Tally back to string, needed for elegant recursive parentheses matching *)
tallyToFormula[tally:{{_String,_Integer}..}]:=StringJoin[MapThread[#1<>ToString[#2]&,Transpose@tally]];
tallyToFormula[{}]:="";

(* Recursive function for converting Hill notation to Element Tally *)
(* If no parentheses, then count the elements *)
formulaToTally[str:_String?(!StringContainsQ[#,"("|")"]&)]:=Module[
	{sanitizedStr,hydrationRemoved,rawCounts,groupedCountRules},

	(* Remove special characters which do not affect element counts *)
	sanitizedStr=StringDelete[str,"\""|"="|" "|"\[Congruent]"];

	(* Process hydration notation (.n(formula) )*)
	hydrationRemoved=StringReplace[sanitizedStr,
			{
				("."|"\[CenterDot]"~~n:NumberString~~rest:__):>tallyToFormula[
					{First[#],ToExpression[n]*Last[#]}&/@formulaToTally[rest]
				],
				("."|"\[CenterDot]"~~rest:__):>tallyToFormula[formulaToTally[rest]]
			}
	];

	(* Parse the string into atoms and counts *)
	rawCounts=StringSplit[hydrationRemoved,
		{
			(s_?UpperCaseQ~~n:NumberString):>{s,ToExpression[n]},
			(s_?UpperCaseQ~~u_?LowerCaseQ~~n:NumberString):>{s<>u,ToExpression[n]},
			(s_?UpperCaseQ~~u_?LowerCaseQ):>{s<>u,1},
			(s_?UpperCaseQ):>{s,1}
		}
	]/.{""->Nothing};

	(* Sum up the counts by atom *)
	groupedCountRules=Normal@Merge[Rule@@@rawCounts,Total];

	(* Convert rules back to lists *)
	List@@@groupedCountRules
];

(* If there are parentheses, then process those recursively *)
formulaToTally[str_String]:=Module[
	{oneStripString},

	(* Strip one layer of parentheses *)
	oneStripString=StringReplace[str,
		{
			(* Parentheses followed by a number should multiply tallies internal *)
			Shortest["("~~txt:Except["("|")"]...~~")"~~num:NumberString]:>tallyToFormula[
				{First[#],ToExpression[num]*Last[#]}&/@formulaToTally[txt]
			],
			(* Otherwise just strip the parentheses *)
			Shortest["("~~txt:Except["("|")"]...~~")"]:>tallyToFormula[formulaToTally[txt]]
		}
	];

	(* Recursive call - if parentheses remain, strip another layer, otherwise sum counts *)
	formulaToTally[oneStripString]
];


(* ::Subsubsection:: *)
(*MonoisotopicMass*)


DefineOptions[MonoisotopicMass,
	Options:>{
		(* MonoisotopicMass currently takes no options *)
	}
];

(* Messages for MonoisotopicMass *)
Warning::MoleculeInfoNotFound="Could not download a valid Molecule or MolecularFormula from `1`. Please use Inspect[] to verify that at least one of these fields are present in object(s).";

(* Primary overload is listable *)
MonoisotopicMass[inputs:ListableP[(ObjectP[Model[Molecule]]|_Molecule|StrandP|SequenceP|StructureP)],ops:OptionsPattern[MonoisotopicMass]]:=Module[
	{resolvedMols,elementCounts,monoisotopicMasses,convertedMasses},

	(* Resolve molecule inputs *)
	resolvedMols=resolveMoleculeInputs[inputs];

	(* Get a count of atoms in each molecule, plus a constant adjustment to the total molecular weight *)
	elementCounts=getElementCount/@resolvedMols;

	(* Use MoleculeValue to compute monoisotopic masses, skipping invalid molecules *)
	monoisotopicMasses=MapThread[
		If[MatchQ[#1,_Molecule],
			(* If a molecule resolved, pull the field directly *)
			Quiet[
				MoleculeValue[#1,"MonoIsotopicMolecularMass"]/.{_MoleculeValue->$Failed},
				{MoleculeValue::mol}
			],
			(* Otherwise, pass on to helper function *)
			tallyToMonoisotopicMass[#2]
		]&,
		{resolvedMols,elementCounts}
	];

	(* Convert atomic mass units to g/mol. They are the same, but technically have different dimensions. *)
	convertedMasses=Map[
		If[MatchQ[#,$Failed],
			$Failed,
			#*Dalton
		]&,
		Unitless[monoisotopicMasses]
	];

	(* De-list the output if the input was not a list *)
	If[MatchQ[inputs,_List],
		convertedMasses,
		First@convertedMasses
	]
];

(* Convert a count of elements into a monoisotopic mass using element data *)
tallyToMonoisotopicMass[{tally:{{_String,_Integer}..},adj:UnitsP[Dalton]}]:=Module[
	{mostAbundantIsotope,amuToDalton,monoMass},

	(* Extract the most abundant isotope from safeIsotopeData *)
	mostAbundantIsotope[{elem:_String,count:_Integer}]:=Last@Flatten@MaximalBy[
		Transpose@{safeIsotopeData[elem,"IsotopeAbundance"],safeIsotopeData[elem,"AtomicMass"]},
		First
	];

	(* Replace amu with Dalton *)
	amuToDalton[q:UnitsP["AtomicMassUnit"]]:=Quantity[Unitless[q,"AtomicMassUnit"],Dalton];

	(* Map the most abundant isotope over the tally to get the monoisotopic mass *)
	monoMass=Total@Map[
		Last[#]*amuToDalton[mostAbundantIsotope[#]]&,
		tally
	];

	(* Return monoisotopic mass with adjustment *)
	monoMass+adj
];

(* If pattern didn't match then return fail state *)
tallyToMonoisotopicMass[_]:=$Failed;


(* ::Subsubsection:: *)
(*ExactMass*)


DefineOptions[ExactMass,
	Options:>{
		{
			OptionName->ExactMassProbabilityThreshold,
			Description->"Exact masses with probability less than this threshold will be excluded from the exact mass distribution.",
			ResolutionDescription->"Lowering this threshold increases resolution but substantially increases computation time. Set threshold to zero to calculate the entire, un-pruned mass distribution.",
			Default->N[1*10^-9],
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>RangeP[0.0,0.5]],
			Category->"General"
		},
		{
			OptionName->ExactMassResolution,
			Description->"Exact masses which differ by less than ExactMassResolution will be replaced by their probability-weighted center of mass.",
			ResolutionDescription->"Set ExactMassResolution to zero to disable averaging of similar masses.",
			Default->(0.1 Dalton),
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Dalton],Units->Alternatives[Dalton]],
			Category->"General"
		},
		{
			OptionName->OutputFormat,
			Description->"Specify if the exact mass distribution should be returned as a distribution or a list of {probability, exact mass} pairs.",
			Default->MostProbableMass,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[MostProbableMass,Distribution,List]],
			Category->"General"
		},
		{
			OptionName->IsotopeDistribution,
			Description->"An association containing entries of the form \"atom\"->{{probability, mass}..} representing the isotopic distributions of one or more atoms.",
			ResolutionDescription->"Any atomic isotope distributions specified here will override the defaults for that atom. Defaults reflect the average isotopic distribution of atoms on the planet Earth.",
			Default->Null,
			AllowNull->True,
			Widget->Adder[
				Widget[Type->Expression,Pattern:>Rule[_String,{{NumericP,UnitsP[Dalton]}..}],Size->Line]
			],
			Category->"General"
		}
	}
];

(*** Messages ***)
Warning::UnknownComposition="No chemical formula or structure is defined for monomers `1` of type `2`. Isotopic variation will be ignored for these monomers and their average molecular weight will be used instead.";
Warning::DegenerateMassUncertain="Exact mass is not defined for degenerate monomers `1` of type `2`. Isotopic variation will be ignored for these monomers and their average molecular weight will be used instead.";
Error::UndefinedMass="One or more of the monomers `1` has neither a chemical formula nor a molecular mass defined, and may be deprecated. The `3` of sequence `2` cannot be calculated.";
Error::MoleculeNotRecognized="The input, `1`, is not a recognized molecule";

(*** TEMPORARY FIX for Unit Testing **)
(* IsotopeData[] does not currently package on Manifold, so hard-code the MM database entries needed for unit testing. *)
safeIsotopeData["C","IsotopeAbundance"]:={0.`, 0.`, 0.`, 0.`, 0.9889000000000000057`4., 0.0111000000000000009`3., 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`};
safeIsotopeData["H","IsotopeAbundance"]:={0.9998499999999999943`5., 0.0001500000000000003`4., 0.`, 0.`, 0.`, 0.`, 0.`};
safeIsotopeData["O","IsotopeAbundance"]:={0.`, 0.`, 0.`, 0.`, 0.9976200000000000045`5., 0.0003799999999999999`4., 0.0020000000000000001`4., 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`};
safeIsotopeData["N","IsotopeAbundance"]:={0.`, 0.`, 0.`, 0.`, 0.9963400000000000034`5., 0.00366`4., 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`};
safeIsotopeData["P","IsotopeAbundance"]:={0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 1.`1., 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`, 0.`};
safeIsotopeData["Cl","IsotopeAbundance"]:={0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.7576999999999999603`4.,0.`,0.2423000000000000043`4.,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`};
safeIsotopeData["S","IsotopeAbundance"]:={0.`,0.`,0.`,0.`,0.`,0.`,0.9501999999999999602`4.,0.0075`3.,0.0420999999999999996`3.,0.`,0.0001999999999999999`3.,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`};
safeIsotopeData["Si","IsotopeAbundance"]:={0.`,0.`,0.`,0.`,0.`,0.`,0.9223000000000000398`5.,0.0468299999999999983`4.,0.0308700000000000019`4.,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`};
safeIsotopeData["C","AtomicMass"]:={Quantity[8.037675025`10.,"AtomicMassUnit"],Quantity[9.031036689`10.,"AtomicMassUnit"],Quantity[10.016853228`11.,"AtomicMassUnit"],Quantity[11.011433613`11.,"AtomicMassUnit"],Quantity[12.`,"AtomicMassUnit"],Quantity[13.00335483778`13.,"AtomicMassUnit"],Quantity[14.0032419887`12.,"AtomicMassUnit"],Quantity[15.010599256`11.,"AtomicMassUnit"],Quantity[16.014701252`11.,"AtomicMassUnit"],Quantity[17.022586116`11.,"AtomicMassUnit"],Quantity[18.026759354`11.,"AtomicMassUnit"],Quantity[19.034805018`11.,"AtomicMassUnit"],Quantity[20.040319754`11.,"AtomicMassUnit"],Quantity[21.04934`8.,"AtomicMassUnit"],Quantity[22.0572`8.,"AtomicMassUnit"]};
safeIsotopeData["H","AtomicMass"]:={Quantity[1.00782503207`12.,"AtomicMassUnit"],Quantity[2.01410177785`12.,"AtomicMassUnit"],Quantity[3.01604927767`12.,"AtomicMassUnit"],Quantity[4.027806424`10.,"AtomicMassUnit"],Quantity[5.035311488`10.,"AtomicMassUnit"],Quantity[6.044942594`10.,"AtomicMassUnit"],Quantity[7.052749`7.,"AtomicMassUnit"]};
safeIsotopeData["O","AtomicMass"]:={Quantity[12.034404895`11.,"AtomicMassUnit"],Quantity[13.024812213`11.,"AtomicMassUnit"],Quantity[14.00859625`10.,"AtomicMassUnit"],Quantity[15.003065617`11.,"AtomicMassUnit"],Quantity[15.99491461956`13.,"AtomicMassUnit"],Quantity[16.999131703`11.,"AtomicMassUnit"],Quantity[17.999161001`11.,"AtomicMassUnit"],Quantity[19.00358013`10.,"AtomicMassUnit"],Quantity[20.004076742`11.,"AtomicMassUnit"],Quantity[21.008655886`11.,"AtomicMassUnit"],Quantity[22.009966947`11.,"AtomicMassUnit"],Quantity[23.015687659`11.,"AtomicMassUnit"],Quantity[24.020472917`11.,"AtomicMassUnit"],Quantity[25.02946`8.,"AtomicMassUnit"],Quantity[26.03834`8.,"AtomicMassUnit"],Quantity[27.04826`8.,"AtomicMassUnit"],Quantity[28.05781`8.,"AtomicMassUnit"]};
safeIsotopeData["N","AtomicMass"]:={Quantity[10.041653674`11.,"AtomicMassUnit"],Quantity[11.026090956`11.,"AtomicMassUnit"],Quantity[12.018613197`11.,"AtomicMassUnit"],Quantity[13.005738609`11.,"AtomicMassUnit"],Quantity[14.00307400478`13.,"AtomicMassUnit"],Quantity[15.00010889823`13.,"AtomicMassUnit"],Quantity[16.006101658`11.,"AtomicMassUnit"],Quantity[17.008450261`11.,"AtomicMassUnit"],Quantity[18.014078959`11.,"AtomicMassUnit"],Quantity[19.017028697`11.,"AtomicMassUnit"],Quantity[20.023365807`11.,"AtomicMassUnit"],Quantity[21.02710824`10.,"AtomicMassUnit"],Quantity[22.034394934`11.,"AtomicMassUnit"],Quantity[23.04122`8.,"AtomicMassUnit"],Quantity[24.05104`8.,"AtomicMassUnit"],Quantity[25.06066`8.,"AtomicMassUnit"]};
safeIsotopeData["P","AtomicMass"]:={Quantity[24.03435`8.,"AtomicMassUnit"],Quantity[25.02026`8.,"AtomicMassUnit"],Quantity[26.01178`8.,"AtomicMassUnit"],Quantity[26.999230236`11.,"AtomicMassUnit"],Quantity[27.992314761`11.,"AtomicMassUnit"],Quantity[28.981800606`11.,"AtomicMassUnit"],Quantity[29.978313789`11.,"AtomicMassUnit"],Quantity[30.973761629`11.,"AtomicMassUnit"],Quantity[31.973907274`11.,"AtomicMassUnit"],Quantity[32.971725543`11.,"AtomicMassUnit"],Quantity[33.973636257`11.,"AtomicMassUnit"],Quantity[34.973314117`11.,"AtomicMassUnit"],Quantity[35.97825968`10.,"AtomicMassUnit"],Quantity[36.979608946`11.,"AtomicMassUnit"],Quantity[37.984156827`11.,"AtomicMassUnit"],Quantity[38.986179475`11.,"AtomicMassUnit"],Quantity[39.991296951`11.,"AtomicMassUnit"],Quantity[40.994335435`11.,"AtomicMassUnit"],Quantity[42.001007913`11.,"AtomicMassUnit"],Quantity[43.00619`7.,"AtomicMassUnit"],Quantity[44.01299`8.,"AtomicMassUnit"],Quantity[45.01922`8.,"AtomicMassUnit"],Quantity[46.02738`8.,"AtomicMassUnit"]};
safeIsotopeData["Cl","AtomicMass"]:={Quantity[28.02851`8.,"AtomicMassUnit"],Quantity[29.01411`8.,"AtomicMassUnit"],Quantity[30.00477`8.,"AtomicMassUnit"],Quantity[30.992413086`11.,"AtomicMassUnit"],Quantity[31.985689901`11.,"AtomicMassUnit"],Quantity[32.977451887`11.,"AtomicMassUnit"],Quantity[33.973762819`11.,"AtomicMassUnit"],Quantity[34.968852682`11.,"AtomicMassUnit"],Quantity[35.968306981`11.,"AtomicMassUnit"],Quantity[36.965902591`11.,"AtomicMassUnit"],Quantity[37.968010425`11.,"AtomicMassUnit"],Quantity[38.968008164`11.,"AtomicMassUnit"],Quantity[39.970415472`11.,"AtomicMassUnit"],Quantity[40.970684525`11.,"AtomicMassUnit"],Quantity[41.973254804`11.,"AtomicMassUnit"],Quantity[42.974054403`11.,"AtomicMassUnit"],Quantity[43.978281071`11.,"AtomicMassUnit"],Quantity[44.980286886`11.,"AtomicMassUnit"],Quantity[45.98421004`10.,"AtomicMassUnit"],Quantity[46.98871`8.,"AtomicMassUnit"],Quantity[47.99495`8.,"AtomicMassUnit"],Quantity[49.00032`8.,"AtomicMassUnit"],Quantity[50.00784`8.,"AtomicMassUnit"],Quantity[51.01449`8.,"AtomicMassUnit"]};
safeIsotopeData["S","AtomicMass"]:={Quantity[26.02788`8.,"AtomicMassUnit"],Quantity[27.018833`8.,"AtomicMassUnit"],Quantity[28.004372763`11.,"AtomicMassUnit"],Quantity[28.996608049`11.,"AtomicMassUnit"],Quantity[29.984903249`11.,"AtomicMassUnit"],Quantity[30.979554728`11.,"AtomicMassUnit"],Quantity[31.972070999`11.,"AtomicMassUnit"],Quantity[32.971458759`11.,"AtomicMassUnit"],Quantity[33.967866902`11.,"AtomicMassUnit"],Quantity[34.969032161`11.,"AtomicMassUnit"],Quantity[35.96708076`10.,"AtomicMassUnit"],Quantity[36.971125567`11.,"AtomicMassUnit"],Quantity[37.971163317`11.,"AtomicMassUnit"],Quantity[38.975134306`11.,"AtomicMassUnit"],Quantity[39.975451728`11.,"AtomicMassUnit"],Quantity[40.979582149`11.,"AtomicMassUnit"],Quantity[41.981022419`11.,"AtomicMassUnit"],Quantity[42.98715479`10.,"AtomicMassUnit"],Quantity[43.99021339`10.,"AtomicMassUnit"],Quantity[44.996508112`11.,"AtomicMassUnit"],Quantity[46.00075`8.,"AtomicMassUnit"],Quantity[47.00859`8.,"AtomicMassUnit"],Quantity[48.01417`8.,"AtomicMassUnit"],Quantity[49.023619`8.,"AtomicMassUnit"]};
safeIsotopeData["Si","AtomicMass"]:={Quantity[22.03453`8.,"AtomicMassUnit"],Quantity[23.02552`8.,"AtomicMassUnit"],Quantity[24.011545616`11.,"AtomicMassUnit"],Quantity[25.004105574`11.,"AtomicMassUnit"],Quantity[25.992329921`11.,"AtomicMassUnit"],Quantity[26.986704905`11.,"AtomicMassUnit"],Quantity[27.97692653246`13.,"AtomicMassUnit"],Quantity[28.9764947`9.,"AtomicMassUnit"],Quantity[29.973770171`11.,"AtomicMassUnit"],Quantity[30.975363226999998`17.,"AtomicMassUnit"],Quantity[31.974148082`11.,"AtomicMassUnit"],Quantity[32.97800022`10.,"AtomicMassUnit"],Quantity[33.978575524`11.,"AtomicMassUnit"],Quantity[34.984583575`11.,"AtomicMassUnit"],Quantity[35.986599477`11.,"AtomicMassUnit"],Quantity[36.99293608`10.,"AtomicMassUnit"],Quantity[37.995633601`11.,"AtomicMassUnit"],Quantity[39.002070013`11.,"AtomicMassUnit"],Quantity[40.005869121`11.,"AtomicMassUnit"],Quantity[41.01456`7.,"AtomicMassUnit"],Quantity[42.01979`8.,"AtomicMassUnit"],Quantity[43.02866`8.,"AtomicMassUnit"],Quantity[44.03526`8.,"AtomicMassUnit"]};
(*
	use applyDataPacletFix wrapped around the IsotopeData call to upgrade paclets,
	otherwise it will return $Failed on Manifold for MM >= 12.2
*)
safeIsotopeData[elem:_String,prop:_String]:= First[applyDataPacletFix[{IsotopeData[elem,prop]}]];

ExactMass[held_, ops : OptionsPattern[ExactMass]] := Quiet[
   exactMass[ReleaseHold@held, ops],
   {Molecule::nintrp}
];

(* Primary overload is listable *)
exactMass[inputs:ListableP[(ObjectP[Model[Molecule]]|_Molecule|SequenceP|StrandP|StructureP)],ops:OptionsPattern[ExactMass]]:=Module[
	{safeOps,resolvedMols,elementCounts,massDistributions,formattedMassDistributions},

	If[MatchQ[#, Molecule[_String]],
    Message[Error::MoleculeNotRecognized, #]] & /@ ToList[inputs];

	(* Get safe defaulted options *)
	safeOps=SafeOptions[ExactMass,ToList[ops]];

	(* Resolve molecule inputs *)
	resolvedMols=resolveMoleculeInputs[inputs];

	(* Get a count of atoms in each molecule, plus a constant adjustment to the total molecular weight *)
	elementCounts=getElementCount/@resolvedMols;

	(* Compute the exact mass distribution for each molecule. Check the molecule is valid by seeing if MoleculeValue evaluates. *)
	massDistributions=computeMassDistribution[#,safeOps]&/@elementCounts;

	(* Format based on OutputFormat option *)
	formattedMassDistributions=Map[
		Which[
			(* Set $Failed if the input did not resolve *)
			MatchQ[#,$Failed],
				$Failed,

			(* Take the most probable mass only *)
			MatchQ[Lookup[safeOps,OutputFormat],MostProbableMass],
				LastOrDefault[FirstOrDefault[#,$Failed],$Failed],

			(* Throw results into quantity distribution if requested *)
			MatchQ[Lookup[safeOps,OutputFormat],Distribution],
				QuantityDistribution[
					EmpiricalDistribution[Rule@@Transpose[Unitless[#]]],
					Dalton
				],

			(* Return list as is if a list was requested *)
			MatchQ[Lookup[safeOps,OutputFormat],List],
				#,

			(* Catch-all is $Failed state *)
			_,$Failed
		]&,
		massDistributions
	];

	(* De-list the output if the input was not listed *)
	If[MatchQ[inputs,_List],
		formattedMassDistributions,
		First[formattedMassDistributions]
	]
];

(* Overload the function: when input for ExactMass is empty list, return as {}*)
ExactMass[{},ops:OptionsPattern[ExactMass]]:={};

(*Hold first arguments*)
SetAttributes[ExactMass, HoldFirst];

(* Get a count of the number of elements in input molecule, plus an adjustment to the total molecular mass *)
getElementCount[mol_Molecule]:=Quiet@Check[
	If[$VersionNumber>=12.2,
		{Tally[Map[First,AtomList@mol]],0.0 Dalton},
		{MoleculeValue[mol,"ElementTally"]/.{e:_Entity:>e["AtomicSymbol"]},0.0 Dalton}
	],
	$Failed,
	{MoleculeValue::mol,AtomList::mol}
];

(* Sequence without initial and terminal correction defaults both to True *)
getElementCount[seq:SequenceP]:=getElementCount[seq,True,True];

(* Sequences rely on lookup of oligomer properties *)
getElementCount[seq:SequenceP,initialCorr:BooleanP,terminalCorr:BooleanP]:=Module[
	{
		type,monomers,monomerMols,monomerElements,
		initMol,adjRules,adjMols,
		initMassCorr,termMassCorr,init,term,adjs,
		monomerElementCounts,cleanCounts,missingMonomers,massCorrection,
		monomerElementAssocs,initialCorrAssoc,terminalCorrAssoc,adjCorrAssoc,
		initCounts,correctedCounts,degenAlphabet,degens,nonDegenMissings
	},

	(* Extract the type and monomers from the sequence *)
	type=PolymerType[seq];

	(* If PolymerType fails to resolve, return $Failed *)
	If[MatchQ[type,$Failed],Return[$Failed]];

	monomers=Monomers[seq,ExplicitlyTyped->False,Polymer->type];

	(* List of rules associating monomers of type to Molecule[]s of their structure *)
	monomerMols=Select[
		Physics`Private`lookupModelOligomer[type,MonomerMolecule],
		(* Filter out any rules which don't point to a Molecule[], e.g. if molecule is missing an "key"->Null *)
		MatchQ[Last[#],_Molecule]&
	];
	
	(* Convert Molecules into element tallies *)
	monomerElements=If[$VersionNumber>=12.2,
		Rule[First[#], Tally[Map[First, AtomList@Last[#]]]] & /@ monomerMols,
		Rule[First[#], MoleculeValue[Last[#],"ElementTally"]/.{e : _Entity :> e["AtomicSymbol"]}]&/@monomerMols
	];


	(* Terminal mass corrections *)
	initMol=safeInitialMolecule[type,monomers];
	terminalMol=safeTerminalMolecule[type,monomers];

	(* Handle adjustments for modifications *)
	adjRules=Physics`Private`lookupModelOligomer[type,MoleculeAdjustment];
	adjMols=If[MatchQ[adjRules,Null],
		Null,
		monomers/.adjRules
	];

	(* Correction in case the terminal molecules are missing *)
	initMassCorr=If[initialCorr&&MatchQ[initMol,Null],
		safeInitialMass[type,monomers],
		0.0 Dalton
	];
	termMassCorr=If[terminalCorr&&MatchQ[terminalMol,Null],
		safeTerminalMass[type,monomers],
		0.0 Dalton
	];

	(* Terminal corrections *)
	init=getElementCountCorrection[initMol];
	term=getElementCountCorrection[terminalMol];
	adjs=getElementCountCorrection/@adjMols;

	(* Attempt to lookup an element tally for each monomer *)
	monomerElementCounts=Lookup[monomerElements,#]&/@monomers;

	(* Extract counts for all monomers for which an entry was found *)
	cleanCounts=DeleteCases[monomerElementCounts,_Missing];

	(* The monomer names from which Molecule[] and element counts could not be resolved *)
	missingMonomers=Last/@Cases[monomerElementCounts,_Missing];

	(* Get the degenerate alphabet of the given sequence type *)
	degenAlphabet=Physics`Private`lookupModelOligomer[type,DegenerateAlphabet];

	(* Get a list of degenerate monomers appearing in the sequence *)
	degens=Select[missingMonomers,(KeyExistsQ[degenAlphabet,#]&&Length[Lookup[degenAlphabet,#]]>1)&];
	nonDegenMissings=Complement[missingMonomers,degens];

	(* Return a warning if degenerates are present *)
	If[Length[degens]>0,
		Message[Warning::DegenerateMassUncertain,DeleteDuplicates[degens],type];
	];

	(* Error check for monomers missing structures *)
	If[Length[nonDegenMissings]>0,
		Message[Warning::UnknownComposition,DeleteDuplicates[nonDegenMissings],type];
	];

	(* The mass correction is the sum of the avg molecular weight of monomers with missing structures *)
	massCorrection=If[Length[missingMonomers]>0,
		Total[Quiet[MolecularWeight[#,Polymer->type,Init->False,Term->False]]&/@missingMonomers],
		Quantity[0.0,Dalton]
	];

	(* Throw an error if a molecular mass can't be found either *)
	If[!MatchQ[massCorrection,UnitsP[Dalton]],
		Message[Error::UndefinedMass,DeleteDuplicates[missingMonomers],seq,ExactMass];
		Return[$Failed]
	];

	(* Convert each monomer element count into an association mapping Element\[Rule]Count *)
	monomerElementAssocs=Map[
		Association@@(Rule@@@#)&,
		cleanCounts
	];

	(* Convert the terminal corrections into associations too *)
	initialCorrAssoc=If[initialCorr,Association@@(Rule@@@init),Nothing];
	terminalCorrAssoc=If[terminalCorr,Association@@(Rule@@@term),Nothing];
	adjCorrAssoc=If[MatchQ[adjs,{{{_String,_Integer}..}..}],
		Map[Association@@(Rule@@@#)&,adjs],
		Nothing
	];

	(* Add the associations together by key *)
	initCounts=Merge[monomerElementAssocs,Total];

	(* Add the terminal corrections *)
	correctedCounts=Merge[{initCounts,initialCorrAssoc,terminalCorrAssoc,adjCorrAssoc},Total];

	(* Convert back into ordered pairs *)
	{List@@@Normal[correctedCounts],massCorrection+initMassCorr+termMassCorr}
];

(* Strand overload calls the Sequence overload *)
getElementCount[strand:StrandP]:=Module[
	{
		motifs,startSeq,endSeq,middleSeqs,
		startCounts,middleCounts,endCounts,joinedCounts,
		joinedCountAssocs,combinedCounts,totalMassCorrection
	},

	(* Extract the motifs from the strand *)
	motifs=strand[Motifs];

	(* If there is only one motif then call the sequence overload directly *)
	If[Length[motifs]==1,
		Return[getElementCount[First[motifs]]]
	];

	(* Get first, last, and middle sequences in the strand *)
	startSeq=First[motifs];
	endSeq=Last[motifs];
	middleSeqs=If[Length[motifs]>1,Most[Rest[motifs]],{}];

	(* Call the sequence overload with appropriate end-of-chain corrections *)
	startCounts=getElementCount[startSeq,True,False];
	endCounts=getElementCount[endSeq,False,True];
	middleCounts=getElementCount[#,False,False]&/@middleSeqs;

	(* Join the counts together *)
	joinedCounts=Join[{startCounts},middleCounts,{endCounts},1];

	sumCountAssocs[joinedCounts]
];

(* Structures are collections of strands *)
getElementCount[struct:StructureP]:=Module[
	{strands,strandCounts},

	(* Extract the strands from the structure *)
	strands=struct[Strands];

	(* Map the strand overload on each strand *)
	strandCounts=getElementCount/@strands;

	(* COmbine the counts for each strand *)
	sumCountAssocs[strandCounts]
];

(* If already given a list of counts, just return the counts and zero correction *)
getElementCount[tally:{{_String,_Integer}..}]:={tally,0.0 Dalton};

(* Pass-through the $Failed state *)
getElementCount[Null|$Failed|ObjectP[]]:=$Failed;

(* Helper function sums element counts by key, and totals the mass correction*)
sumCountAssocs[joinedCounts:{{{{_String,_Integer}...},UnitsP[Dalton]}..}]:=Module[
	{joinedCountAssocs,combinedCounts,totalMassCorrection},

	(* Convert the counts into associations for adding *)
	joinedCountAssocs=Map[
		Association@@(Rule@@@#)&,
		First/@joinedCounts
	];

	(* Join the associations together, totaling up by key *)
	combinedCounts=Merge[joinedCountAssocs,Total];

	(* Sum up the mass corrections in each of joinedCounts *)
	totalMassCorrection=Total[Last/@joinedCounts];

	(* Convert the combined counts back to a list of ordered pairs *)
	{List@@@Normal[combinedCounts],totalMassCorrection}
];

(* Helper function processes the InitialMolecule and TerminalMolecule corrections into element tallies *)
getElementCountCorrection[Null]:=Nothing;
getElementCountCorrection[correctionMol:{Rule[_String,None|_Molecule]..}]:=Module[
	{addMol,removeMol,addTally,removeTally},

	(* Get the structures of the additions/removals at the end of a molecule *)
	addMol=Lookup[correctionMol,"Addition"];
	removeMol=Lookup[correctionMol,"Removal"];

	addTally=If[MatchQ[addMol,_Molecule],
		If[$VersionNumber >= 12.2,
			Tally[Map[First,AtomList@addMol]],
			MoleculeValue[addMol,"ElementTally"]/.{e:_Entity:>e["AtomicSymbol"]}
		],
		{}
	];

	removeTally=If[MatchQ[removeMol,_Molecule],
		If[$VersionNumber >= 12.2,
			{First[#],-Last[#]}&/@Tally[Map[First,AtomList@removeMol]],
			{First[#],-Last[#]}&/@(MoleculeValue[removeMol,"ElementTally"]/.{e:_Entity:>e["AtomicSymbol"]})
		],
		{}
	];

	(* Use the sumCountAssocs helper to combine the tallies *)
	First@sumCountAssocs[{{addTally,0.0 Dalton},{removeTally,0.0 Dalton}}]
];

(* Given a Molecule[] as input, compute the distribution of exact masses using the isoDalton algorithm *)
computeMassDistribution[
	{elementTally:{{_String,_Integer}..},massAdjustment:UnitsP[Dalton]},
	safeOps:OptionsPattern[ExactMass]
]:=Module[
	{
		resolution,userIsotopeDists,cleanIsotopeDistOption,cleanedUserDists,
		elements,elementCounts,elementList,globalThreshold,logStepThreshold,
		atomicMassDistributions,atomicDistRules,updatedDistRules,
		stateRules,groupEntries,nextState,finalStates,sortedFinalStates,
		adjustedSortedFinalStates,maxProb,inverseCount
	},

	(* Extract the list of elements and their counts from the molecule *)
	{elements,elementCounts}=Transpose@elementTally;

	(* Skip calculation if there are no elements *)
	If[Total[Abs[elementCounts]]===0,
		Return[{{1.0,Quantity[0.0,Dalton]}}]
	];

	(* Strip units from the mass resolution. Masses which differ by less than resolution will be combined *)
	resolution=Unitless[Lookup[safeOps,ExactMassResolution]];

	(* Any user-supplied atomic isotope disributions are loaded here *)
	userIsotopeDists=Lookup[safeOps,IsotopeDistribution];

	(* Helper function normalizes and logs probabilities and strips units *)
	cleanIsotopeDistOption[frqs:{{NumericP,UnitsP[]}..}]:=Transpose[{
		N@Log[(First/@frqs)/Total[First/@frqs]],
		Unitless[Last/@frqs]
	}];

	(* Clean the user-supplied isotope distributions *)
	cleanedUserDists=Map[
		Rule[
			First[#],
			cleanIsotopeDistOption[Last[#]]
		]&,
		userIsotopeDists
	];

	(* List of elements to iterate over for the exact mass algorithm *)
	elementList=MapThread[
		If[#2>=0,
			(Sequence@@Repeat[#1,#2]),
			(Sequence@@Repeat[inverseCount[#1],Abs[#2]])
		]&,
		{elements,elementCounts}
	];

	(* Overall proability threshold *)
	globalThreshold=Lookup[safeOps,ExactMassProbabilityThreshold];

	(* Log probability threshold to keep at each step *)
	logStepThreshold=If[MatchQ[globalThreshold,0.0|0],
		-\[Infinity],
		N@Log[1.0-(1.0-globalThreshold)^(1/Total[Abs[elementCounts]])]
	];

	(* Get a list of {log[probability],isotope} pairs for each element in the molecule *)
	atomicMassDistributions=Map[
		(* Delete entries with zero natural abundance *)
		DeleteCases[
			(* Use safeIsotopeData to get abundances and atomic masses *)
			Transpose[{N@Log[safeIsotopeData[#,"IsotopeAbundance"]],Unitless@safeIsotopeData[#,"AtomicMass"]}],
			{Indeterminate|-\[Infinity],_}
		]&,
		elements
	];

	(* Convert the list of mass distributions into a list of rules mapping element->mass distribution *)
	atomicDistRules=MapThread[
		#1->#2&,
		{elements,atomicMassDistributions}
	];

	(* Sub in any user-specified atomic isotope distributions *)
	updatedDistRules=ReplaceRule[atomicDistRules,cleanedUserDists,Append->False];

	(* Convert the element list into a list of state rules. Rules are used to avoid list depth issues. *)
	stateRules=Map[
		(* Flip the sign of the mass if the count is negative for some reason *)
		If[MatchQ[#,_inverseCount],
			Rule@@@Map[
				Function[{x},{1,-1}*x],
				Lookup[updatedDistRules,First[#]]
			],
			Rule@@@Lookup[updatedDistRules,#]
		]&,
		elementList
	];

	(* Helper function helps sum log probabilities and take probability-weighted center of mass when grouping *)
	groupEntries[Rule[logp1_,mass1_],Rule[logp2_,mass2_]]:=Module[{p1,p2},
		(* Need to use absolute probabilities and not logs for this calculation *)
		p1=Exp[logp1];
		p2=Exp[logp2];

		(* Return total probability and the probability-weighted center of mass *)
		Rule[
			Log[p1+p2],
			(p1*mass1+p2*mass2)/(p1+p2)
		]
	];

	(* Helper function computes next state from current state {{logp, mass}..} and an update {{logp,mass}}. *)
	nextState[currState:{_Rule..},update:{_Rule..}]:=Module[
		{rawNextState,groupedNextState,tmp},

		(* Compute the new probability distribution using a generalized outer product *)
		rawNextState=Flatten@Outer[Rule[First[#1]+First[#2],Last[#1]+Last[#2]]&,currState,update];

		(* Group states with masses which differ by less than resolution *)
		groupedNextState=FoldPairList[
			(* If masses of adjacent entries differ by less than resolution, group them, otherwise leave unchanged. *)
			If[MatchQ[#2,Null]||Abs[Last[#2]-Last[#1]]>resolution,
				{#1,#2},
				{Null,groupEntries[#1,#2]}
			]&,
			(* Sort by mass and append a Null to the end because FoldPairList reduces length by 1 *)
			Append[SortBy[rawNextState,Last],Null]
		]/.{Null->Nothing};

		(* Prune states with probability that fall under the iteration threshold *)
		DeleteCases[groupedNextState,Rule[_?(#<logStepThreshold&),_]]
	];

	(* Fold the nextState helper into the state rules to get the final states corresponding to molecular isotopes *)
	finalStates=Fold[nextState,stateRules];

	(* Convert back to absolute probabilities, add Dalton units, and sort by descending probability *)
	sortedFinalStates=ReverseSortBy[
		{Exp[First[#]],Last[#]*Dalton}&/@finalStates,
		First
	];

	(* Add the mass adjustment *)
	adjustedSortedFinalStates={First[#],Last[#]+massAdjustment}&/@sortedFinalStates;

	(* Maximum probability state *)
	maxProb=Max[First/@adjustedSortedFinalStates];

	(* Delete states with probabilities less than the global threshold *)
	DeleteCases[adjustedSortedFinalStates,{_?(#<Min[globalThreshold,maxProb]&),_}]
];

(* If no elemental structures could be resolved, then use the mass adjustment *)
computeMassDistribution[{{},massAdjustment:UnitsP[Dalton]},safeOps:OptionsPattern[ExactMass]]:={{1.0,massAdjustment}};

(* Pass through the $Failed state *)
computeMassDistribution[$Failed,OptionsPattern[ExactMass]]:=$Failed;



(* ::Subsubsection::Closed:: *)
(*Hyperchromicity260*)

DefineOptions[Hyperchromicity260,
	Options :> {
		{Polymer -> Automatic, Automatic | PolymerP, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExtinctionCoefficientsModel -> Automatic, Automatic | ObjectP[Model[Physics,ExtinctionCoefficients]], "The model that is used for extracting the extinction coefficient. Automatic will match the public one."}
	}
];

Error::InvalidExtinctionCoefficientsModel="The option ExtinctionCoefficientsModel does not match the correct pattern. Please check if the fields Wavelengths and MolarExtinctions are populated and if the MolarExtinctions have the {{_String->x LiterPerCentimeterMole}..} pattern.";

(* --- Integer --- *)
Hyperchromicity260[length_Integer,ops:OptionsPattern[Hyperchromicity260]]:= Module[
	{safeOps, type},

	safeOps = SafeOptions[MolecularWeight, ToList[ops]];

	type = Switch[Polymer/.safeOps,
		Automatic, DNA,
		_, Polymer/.safeOps
	];

	Hyperchromicity260[type[length]]
];


(* --- Sequences --- *)
Hyperchromicity260[sequence:_?SequenceQ, ops:OptionsPattern[Hyperchromicity260]]:= Module[
	{
		type, params, fracAT, fracGC, parAT, parGC,
		safeOptions,extinctionCoefficientsModelBase,modelOligomerExtinctionCoefficients,resolvedExtinctionCoefficietsModel,
		alphabetAT,alphabetGC
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[Hyperchromicity260, ToList[ops]];

	(* Extract the type of sequence *)
	type = PolymerType[sequence, PassOptions[Hyperchromicity260, PolymerType, ops]];

	(* <<< Resolving the ExtinctionCoefficientsModel >>> *)

	(* The base ExtinctionCoefficientsModel provided in the option *)
	extinctionCoefficientsModelBase=Lookup[safeOptions,ExtinctionCoefficientsModel];

	(* The ExtinctionCoefficients field in the model oligomer *)
	modelOligomerExtinctionCoefficients=Quiet[Download[Model[Physics,Oligomer,SymbolName[type]],ExtinctionCoefficients]];

	resolvedExtinctionCoefficietsModel=Which[
		(* If Automatic use the ExtinctionCoefficients field in the model oligomer *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && !MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		modelOligomerExtinctionCoefficients,

		(* If Automatic and there is no ExtinctionCoefficients field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		Null,

		(* If not Automatic and the model does not match the valid pattern for ExtinctionCoefficientsModel, throw an error *)
		!MatchQ[extinctionCoefficientsModelBase,Automatic] && !Physics`Private`validExtinctionCoefficientsModelQ[extinctionCoefficientsModelBase],
		(Message[Error::InvalidExtinctionCoefficientsModel];Return[$Failed]),

		(* If not Automatic and the model does match the valid pattern for ExtinctionCoefficientsModel, use the model provided *)
		True,
		extinctionCoefficientsModelBase
	];

	(* Lookup the HyperchromicityCorrections parameter *)
	params=Physics`Private`lookupModelExtinctionCoefficients[type,HyperchromicityCorrections, ExtinctionCoefficientsModel->resolvedExtinctionCoefficietsModel];

	(* Find all alphabets that contain A and T and U *)
	alphabetAT=Select[Physics`Private`lookupModelOligomer[type,Alphabet],StringContainsQ["A"|"T"|"U"]];

	(* Find all alphabets that contain G and C *)
	alphabetGC=Select[Physics`Private`lookupModelOligomer[type,Alphabet],StringContainsQ["G"|"C"]];

	(* Obtain the fraction AT pairs *)
	fracAT = Switch[type,

		DNA | PNA,
		FractionAT[sequence, Polymer->type, PassOptions[Hyperchromicity260, FractionAT, ops]],

		(* For RNA, take the AU fraction instead of AT *)
		RNA|RNAtom|RNAtbdms,
		FractionAU[sequence, Polymer->type, PassOptions[Hyperchromicity260, FractionAU, ops]],

		(* For LNAChimera we take any variant of A and T *)
		LNAChimera|LDNA|LRNA,
		FractionMono[sequence, {"mA*","fA*","+A*","mU*","fU*","+U*","+T*","mA","fA","+A","mU","fU","+U","+T"}, Polymer->type, PassOptions[Hyperchromicity260, FractionMono, ops]],

		(* No data avaible for Peptide and Modifications set it to zero *)
		Peptide,
		0,

		Modification,
		0,

		(* For other types of polymer that are user defined *)
		PolymerP,
		FractionMono[sequence, alphabetAT, Polymer->type, PassOptions[Hyperchromicity260, FractionMono, ops]]
	];

	(* Obtain the fraction GC pairs *)
	fracGC = Switch[type,

		(* No data available for Peptide and Modifications set it to zero *)
		Peptide, 0,
		Modification,0,

		(* Note that for LNAChimera, all variants of G and C are taken in the function FractionGC *)
		DNA|PNA|RNA|RNAtom|RNAtbdms|LNAChimera|LDNA|LRNA,
		FractionGC[sequence, Polymer->type, PassOptions[Hyperchromicity260, FractionGC, ops]],

		(* For other types of polymer that are user defined *)
		PolymerP,
		FractionMono[sequence, alphabetGC, Polymer->type, PassOptions[Hyperchromicity260, FractionMono, ops]]
	];

	(* Obtain the corrections *)
	{parAT, parGC}=Lookup[params,{HyperchromicityAT, HyperchromicityGC}];

	(** TODO: If there would a rule to calculate the hyperchromacity based on individual values, we can easily do that by taking the data from model oligomer **)
	(* Determine the hyperchromicity *)
	fracAT*parAT + fracGC*parGC

];


Hyperchromicity260[inList:{(SequenceP | _Integer)..}, ops:OptionsPattern[]]:= Map[Hyperchromicity260[#, ops]&, inList];


(* ::Subsubsection:: *)
(*ExtinctionCoefficient*)


DefineOptions[ExtinctionCoefficient,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Duplex -> False, BooleanP, "Calculates the expected extinction coefficent of a Duplex of the provided sequence and its reverse compliment if set to true."},
		{Units -> ExtinctionCoefficient, ExtinctionCoefficient | MassExtinctionCoefficient, "If MassExtinctionCoefficient, the function outputs the unit in mL/(mg cm). If ExtinctionCoefficient, the function outputs the regular extinction coefficient unit in L/(cm mol)."},
		{ExtinctionCoefficientsModel -> Automatic, Automatic | ObjectP[Model[Physics,ExtinctionCoefficients]], "The model that is used for extracting the extinction coefficient. Automatic will match the public one."}
	}
];


Options[deriveDegenerateParameters]:={
	PhysicalProperty->\[CapitalSigma],
	Parameter->(260 Nano Meter),
	ExtinctionCoefficientsModel -> Automatic
};

(** TODO: Options format can be changed to take correct pattern to make sure of proper behavior in case of a standalone usage of the function **)
deriveDegenerateParameters[type:PolymerP, ops:OptionsPattern[]]:= Module[
	{
		params,degenMonos,monomer\[CapitalSigma],allTranslations,combinations,degenDimers,dimer\[CapitalSigma],
		unitlessParams
	},

	(* Extract the paramaters used in the calculation *)
	params=
		Switch[OptionValue[PhysicalProperty],
			\[CapitalSigma],
			Physics`Private`lookupModelExtinctionCoefficients[type,ExtinctionCoefficients,ExtinctionCoefficientsModel->OptionValue[ExtinctionCoefficientsModel]]
		];

	(* Retreive all the degenerate Monomers *)
	degenMonos = Physics`Private`lookupModelOligomer[type,DegenerateAlphabet];

	(* Take the Monomers and generate the mean monomer extinction coefficents for each base *)
	monomer\[CapitalSigma] = degenMonos/.{
			Rule[base_String,matches:{_String..}]:>Rule[base,Mean[matches/.params]],
			Rule[base_String,{}|{Null}]:>Rule[base,0]
		};

	(* Alphabet associated with the type of polymer *)
	alphabet=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Generate a list of all translations from a monomer to its possible interperations *)
	allTranslations = Join[#->{#}&/@alphabet, degenMonos];

	(* Generate every possible dimer combination of Monomers including the degenerate alphabet *)
	combinations = Tuples[allTranslations[[All,1]],2];

	(* Generate a list of all possible degenerate Dimers as a rule pointing to the list of known Dimers (without any degeneracy) they could represent *)
	degenDimers = StringJoin[#]->Flatten[Outer[StringJoin,First[#]/.allTranslations,Last[#]/.allTranslations]]&/@combinations;

	(* To speed up the mean calculation of the quantity extinction coefficent *)
	unitlessParams=Unitless[params,LiterPerCentimeterMole];

	(* Conver the right hand side of the rules into mean values for the Dimers extinction coefficents *)
	dimer\[CapitalSigma] =
		degenDimers/.{
			Rule[base_String,matches:{_String..}]:>Rule[base,Mean[matches/.unitlessParams] LiterPerCentimeterMole],
			Rule[base_String,{}|{Null}]:>Rule[base,0]
		(* Rule[base_String,{}]:>Rule[base,0] *)
		};

	(* Memoize the resulting call *)
	deriveDegenerateParameters[type,ops] = Join[params,monomer\[CapitalSigma],dimer\[CapitalSigma]]

	(* Given the involved nature of this calculation but the minimal amount of storage needed to remember the result,
		It seemed wise to memoize all calls to in in case this ends up embeded in a calculation that has to call on it
		thousands of times. *)

];


(* download sample objects at once *)
resolveSampleInput[inList_List]:= Module[
	{downloadList, downloadedStructures, rules, allStructures, nonIdentityModels, identityModels,
		inListWithIdentityModels},

	(* get the non-identity-models *)
	nonIdentityModels = Cases[inList, ObjectP[{Object[Sample], Model[Sample]}]];

	(* get the identity model of note from the nonIdentityModels *)
	identityModels = If[MatchQ[nonIdentityModels, {}],
		{},
		Quiet[Experiment`Private`selectAnalyteFromSample[nonIdentityModels], Warning::AmbiguousAnalyte]
	];

	(* get the inList with identity models replaced *)
	inListWithIdentityModels = Replace[inList, AssociationThread[nonIdentityModels, identityModels], {1}];

	downloadList = Cases[inListWithIdentityModels, ObjectP[Model[Molecule, Oligomer]]];

	(* get the structures we want *)
	downloadedStructures = Flatten[Download[downloadList, Evaluate[ConstantArray[{Molecule}, Length[downloadList]]]]];

	rules = MapThread[
		#1 -> #2&,
		{downloadList, downloadedStructures}
	];

	(* use the replace rules to get all the structures *)
	allStructures = inListWithIdentityModels /. rules;

	(* If the structure information is null, throw a message *)
	MapThread[
		If[MatchQ[#1, {} | Null | $Failed],
			Message[ExtinctionCoefficient::NoStructure, #2],
			#1
		]&,
		{allStructures, inListWithIdentityModels}
	]

];


convertECUnit[results_List, seqsIn_]:= Module[
	{unitlessResult, massWeights},

	unitlessResult = Unitless[results, "Liters"/("Centimeters"*"Moles")];
	massWeights = Unitless[MolecularWeight[seqsIn],"Grams"/"Moles"];

	QuantityArray[unitlessResult/massWeights, "Milliliters"/("Milligrams"*"Centimeters")]

];


convertECUnit[result_, seqIn_]:= First[convertECUnit[{result}, {seqIn}]];


ExtinctionCoefficient[in_, ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{result},

	result = ExtinctionCoefficient[in, Sequence@@(ReplaceRule[ToList[ops], Units->ExtinctionCoefficient])];

	convertECUnit[result, in]

]/;MatchQ[OptionValue[Units], MassExtinctionCoefficient];


(* --- Typeless numbers --- *)
ExtinctionCoefficient[length:GreaterP[0,1], ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{safeOps, type},

	safeOps = SafeOptions[ExtinctionCoefficient, ToList[ops]];

	type = Switch[Polymer/.safeOps,
		Automatic, DNA,
		_, Polymer/.safeOps
	];

	If[MatchQ[type, Peptide | Modification],
		ExtinctionCoefficient[type[StringJoin[ConstantArray["Any", length]]], ops],
		ExtinctionCoefficient[type[StringJoin[ConstantArray["N", length]]], ops]
	]
];


(* --- Integer --- *)
ExtinctionCoefficient[sequence:PolymerP[length:GreaterP[0,1],___], ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{type, averageMono, averageDimer, params},

	(* Extract the polymer type *)
	type = PolymerType[sequence, PassOptions[ExtinctionCoefficient, PolymerType, ops]];

	ExtinctionCoefficient[length, Polymer -> type, ops]

]/;!OptionValue[Duplex];


(* --- Sequence FastTrack: monomer version --- *)
ExtinctionCoefficient[sequence:_?SequenceQ, ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{
		type, monos, params,
		safeOptions,extinctionCoefficientsModelBase,modelOligomerExtinctionCoefficients,resolvedExtinctionCoefficietsModel
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[ExtinctionCoefficient, ToList[ops]];

	(* Determine the polymer type *)
	type = PolymerType[sequence, PassOptions[ExtinctionCoefficient, PolymerType, ops]];

	(* Parse out the Monomers *)
	monos = Monomers[sequence, Polymer->type, ExplicitlyTyped->False, PassOptions[ExtinctionCoefficient, Monomers, ops]];

	(* <<< Resolving the ExtinctionCoefficientsModel >>> *)

	(* The base ExtinctionCoefficientsModel provided in the option *)
	extinctionCoefficientsModelBase=Lookup[safeOptions,ExtinctionCoefficientsModel];

	(* The ExtinctionCoefficients field in the model oligomer *)
	modelOligomerExtinctionCoefficients=Quiet[Download[Model[Physics,Oligomer,SymbolName[type]],ExtinctionCoefficients]];

	resolvedExtinctionCoefficietsModel=Which[
		(* If Automatic use the ExtinctionCoefficients field in the model oligomer *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && !MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		modelOligomerExtinctionCoefficients,

		(* If Automatic and there is no ExtinctionCoefficients field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		Null,

		(* If not Automatic and the model does not match the valid pattern for extinctionCoefficientsModel, throw an error *)
		!MatchQ[extinctionCoefficientsModelBase,Automatic] && !Physics`Private`validExtinctionCoefficientsModelQ[extinctionCoefficientsModelBase],
		(Message[Error::InvalidModel];Return[$Failed]),

		(* If not Automatic and the model does match the valid pattern for extinctionCoefficientsModel, use the model provided *)
		True,
		extinctionCoefficientsModelBase
	];

	(* Extract the extinction rules used in the calculation *)
	params=Switch[type,
		Modification,
		Physics`Private`lookupModelExtinctionCoefficients[type,monos],
		_,
		Physics`Private`lookupModelExtinctionCoefficients[type,ExtinctionCoefficients,ExtinctionCoefficientsModel->resolvedExtinctionCoefficietsModel]
	];

	(* Sum the individual Monomers to get the final estimated extinction coefficent *)
	Total[Flatten[{monos/.params}]]

]/;And[
	!OptionValue[Duplex],
	Or[
		SequenceLength[sequence]==1,
		ModificationQ[sequence],
		PeptideQ[sequence]
	] (* if the sequence is a monomer, Modification or Peptide *)
];


(* --- Sequence FastTrack: Nearest Neighbor Version --- *)
ExtinctionCoefficient[sequence:_?SequenceQ,ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{
		type, allMonos, monos, dimes, degenerateParams, params, wavelengthIndex, extinctions,
		safeOptions,extinctionCoefficientsModelBase,modelOligomerExtinctionCoefficients,resolvedExtinctionCoefficietsModel
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[ExtinctionCoefficient, ToList[ops]];

	(* Extract the type of sequencce *)
	type = PolymerType[sequence,PassOptions[ExtinctionCoefficient, PolymerType, ops]];

	(* Determine the list of Monomers in the sequence *)
	allMonos = Monomers[sequence,ExplicitlyTyped->False,Polymer->type,PassOptions[SequenceLast,Monomers,ops]];

	(* all but the first and last monomer are used in the accounting for extinction *)
	monos = Rest[Most[allMonos]];

	(* Determine the list of overlapping Dimers in the sequence *)
	dimes = Dimers[sequence, ExplicitlyTyped->False, Polymer->type, PassOptions[SequenceLast, Monomers, ops]];

	(* <<< Resolving the ExtinctionCoefficientsModel >>> *)

	(* The base ExtinctionCoefficientsModel provided in the option *)
	extinctionCoefficientsModelBase=Lookup[safeOptions,ExtinctionCoefficientsModel];

	(* The ExtinctionCoefficients field in the model oligomer *)
	modelOligomerExtinctionCoefficients=Quiet[Download[Model[Physics,Oligomer,SymbolName[type]],ExtinctionCoefficients]];

	resolvedExtinctionCoefficietsModel=Which[
		(* If Automatic use the ExtinctionCoefficients field in the model oligomer *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && !MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		modelOligomerExtinctionCoefficients,

		(* If Automatic and there is no ExtinctionCoefficients field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[extinctionCoefficientsModelBase,Automatic] && MatchQ[modelOligomerExtinctionCoefficients,$Failed|Null|{}]),
		Null,

		(* If not Automatic and the model does not match the valid pattern for extinctionCoefficientsModel, throw an error *)
		!MatchQ[extinctionCoefficientsModelBase,Automatic] && !Physics`Private`validExtinctionCoefficientsModelQ[extinctionCoefficientsModelBase],
		(Message[Error::InvalidModel];Return[$Failed]),

		(* If not Automatic and the model does match the valid pattern for extinctionCoefficientsModel, use the model provided *)
		True,
		extinctionCoefficientsModelBase
	];

	(* Extract the extinction rules used in the calculation *)
	params=Physics`Private`lookupModelExtinctionCoefficients[type,ExtinctionCoefficients,ExtinctionCoefficientsModel->resolvedExtinctionCoefficietsModel];

	(* Take a look through the list of all the degenerate bases and come up with mean paramaters for all monomer and dimer combinations *)
	degenerateParams = deriveDegenerateParameters[type, PhysicalProperty->\[CapitalSigma], Parameter-> 260 Nano Meter, PassOptions[ExtinctionCoefficient, deriveDegenerateParameters, ops]];

	(* Calculate the final extinction coefficent as the Dimers minus the Monomers *)
	Total[dimes/.degenerateParams] - Total[monos/.degenerateParams]

]/;!OptionValue[Duplex];


(* --- Duplex --- *)
ExtinctionCoefficient[sequence:_?SequenceQ, ops:OptionsPattern[ExtinctionCoefficient]]:=Module[
	{type, h260, seqExt, rc, rcExt},

	(* Determine the type *)
	type = PolymerType[sequence, PassOptions[ExtinctionCoefficient, PolymerType, ops]];

	(* Obtain the \[CapitalSigma]260 of the sequence *)
	seqExt = ExtinctionCoefficient[sequence, Sequence@@ReplaceRule[{ops},{Polymer->type,Duplex->False}]];

	(* obtain the reverse compliment of the sequence *)
	rc = ReverseComplementSequence[sequence, Polymer->type, PassOptions[ExtinctionCoefficient, ReverseComplementSequence, ops]];

	(* Obtain the \[CapitalSigma]260 of the sequence's reverse compliment *)
	rcExt = ExtinctionCoefficient[rc, Sequence@@ReplaceRule[{ops},{Polymer->type,Duplex->False}]];

	(* Obtain the hyperchromacity correction *)
	h260 = Hyperchromicity260[sequence, Polymer->type, PassOptions[ExtinctionCoefficient, Hyperchromicity260, ops]];

	(* Return the final extinction coefficent *)
	(1-h260)(seqExt+rcExt)

]/; OptionValue[Duplex];


(* --- Strands --- *)
ExtinctionCoefficient[strand_?StrandQ, ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{consolidated,sequencesExtinctions},

	(* merge the sequences if possible *)
	consolidated = StrandFlatten[strand][Motifs];

	(* determine the extinction coefficent *)
	sequencesExtinctions = ExtinctionCoefficient[#,ops]&/@consolidated;

	(* Add the extinction coefficents *)
	Total[sequencesExtinctions]
];


(* --- Structures --- *)
ExtinctionCoefficient[cmplx_?StructureQ, ops:OptionsPattern[ExtinctionCoefficient]]:=Module[
	{strands, totalExt, bondedStrds, rcbondedStrds, bondedExtList, hypChromList, strandExtinctions},

	strands = cmplx[Strands];

	(* Check if we'll need to correct for hypochromicity for bonded structures *)
	If[!MatchQ[cmplx[Bonds], {}],
		totalExt = Total[ExtinctionCoefficient[strands]];
		bondedStrds = Flatten[NucleicAcids`Private`structureBondsToStrands[cmplx]];
		rcbondedStrds = ReverseComplementSequence[bondedStrds, FastTrack->True];

		(* save for dot multiply later *)
		bondedExtList = ExtinctionCoefficient[bondedStrds] + ExtinctionCoefficient[rcbondedStrds];
		hypChromList = Hyperchromicity260[Flatten[bondedStrds[Sequences]]];

		(* bonded region should be substracted off in the rate of corresponding hyperchromicity *)
		Return[totalExt - hypChromList.bondedExtList]
	];


	(* determine the extinction coefficent of each strand *)
	strandExtinctions = ExtinctionCoefficient[strands, ops];

	(* Add the extinction coefficents of all the strands *)
	Total[strandExtinctions]

];


(* --- Oligo Samples --- *)
ExtinctionCoefficient[samp:(ObjectP[{Object[Sample], Model[Sample], Model[Molecule, Oligomer]}]), ops:OptionsPattern[ExtinctionCoefficient]]:= First[ExtinctionCoefficient[{samp}, ops]];


(* --- Antibody/Protein Models --- *)
ExtinctionCoefficient[obj:ObjectP[Model[Sample]] | ObjectP[Model[Sample]] | ObjectP[Model[Molecule, Protein]], ops:OptionsPattern[ExtinctionCoefficient]]:= ExtinctionCoefficient/.If[MatchQ[obj[ExtinctionCoefficients], {}], ExtinctionCoefficient -> Null, First[obj[ExtinctionCoefficients]]];


(* --- RNA Lysate Samples --- *)
ExtinctionCoefficient[(ObjectP[{Model[Lysate]}]|RNALysate),ops:OptionsPattern[ExtinctionCoefficient]]:=((25.` Liter)/(Centi Gram Meter));
ExtinctionCoefficient[in:{ObjectP[{Model[Lysate]}]..},ops:OptionsPattern[ExtinctionCoefficient]]:=Table[((25.` Liter)/(Centi Gram Meter)), Length[in]];

(* --- cDNA Samples --- *)
ExtinctionCoefficient[(ObjectP[{Model[Molecule, cDNA]}]|cDNA|DNALysate),ops:OptionsPattern[ExtinctionCoefficient]]:=((27.` Liter)/(Centi Gram Meter));
ExtinctionCoefficient[in:{ObjectP[{Model[Molecule, cDNA]}]..},ops:OptionsPattern[ExtinctionCoefficient]]:=Table[((27.` Liter)/(Centi Gram Meter)), Length[in]];

(* --- Listable --- *)
ExtinctionCoefficient[inList:{(GreaterP[0,1] | PolymerP[_Integer,___] | _?SequenceQ | _?StrandQ | _?StructureQ | ObjectP[Object[Sample]] | ObjectP[Model[Sample]] | ObjectP[{Model[Molecule, Oligomer], Model[Molecule, cDNA], Model[Lysate], Model[Molecule, Protein]}] | RNALysate | cDNA | DNALysate)..}, ops:OptionsPattern[ExtinctionCoefficient]]:= Module[
	{resList},

	resList = resolveSampleInput[inList];

	Map[ExtinctionCoefficient[#, ops]&, resList]

];

(* ::Subsubsection:: *)
(*ECLElementData*)

DefineOptions[ECLElementData,
	Options :> {
		{Output -> Values, ListableP[Values | Rules | Association], "The output format of this function. Values display the values only, Rules will be a list of rules of PropertyName -> PropertyValue, Association is similiar to Rules, but output association instead."},
		CacheOption
	}
];

Authors[ECLElementData]:={"hanming.yang"};

(* Object overload *)
ECLElementData[myObjects:ListableP[ObjectP[Model[Physics, ElementData]]], myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]]:=Module[
	{elementPackets, safeOps, cache},

	safeOps = SafeOptions[ECLElementData, ToList[ops]];
	cache = Lookup[safeOps, Cache];
	(* Download all fields *)
	elementPackets = Download[myObjects, Cache -> cache];
	(* Pass to main packet overload *)
	ECLElementData[elementPackets, myProperties, ops]
];

(* Symbol Overload *)
ECLElementData[myElements:ListableP[ElementP], myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]]:= Module[
	{elementObjects, elementObjectList, indexObject, allElementObjectPairs, allElementObjectIndex, dataAbsenceQ, elementPackets, safeOps, cache},

	(* Use the full index object *)
	indexObject = Model[Physics, ElementData, "Full Index"];
	safeOps = SafeOptions[ECLElementData, ToList[ops]];
	cache = Lookup[safeOps, Cache];

	allElementObjectPairs = Download[indexObject, Data, Cache -> cache];
	allElementObjectIndex = Map[#[[1]] -> #[[2]] &, allElementObjectPairs];
	elementObjects = myElements /. allElementObjectIndex;

	elementObjectList = ToList[elementObjects];

	dataAbsenceQ = MatchQ[#, Except[ObjectP[]]]&/@elementObjectList;

	If[MemberQ[dataAbsenceQ, True],
		Message[ECLElementData::MissingElementObjectInIndex, PickList[elementObjectList, dataAbsenceQ], indexObject];
		Return[$Failed]
	];

	(* Download all fields *)
	elementPackets = Download[elementObjects, Cache -> cache];

	(* pass to  main packet overload *)
	ECLElementData[elementPackets, myProperties, ops]
];

(* Abbreviation Overload *)
ECLElementData[myElements:ListableP[ElementAbbreviationP], myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]]:= Module[
	{elementObjects, elementObjectList, indexObject, allElementObjectPairs, allElementObjectIndex, dataAbsenceQ, elementPackets, safeOps, cache},

	(* Use the full index object *)
	indexObject = Model[Physics, ElementData, "Full Index"];
	safeOps = SafeOptions[ECLElementData, ToList[ops]];
	cache = Lookup[safeOps, Cache];

	allElementObjectPairs = Download[indexObject, AbbreviationIndex, Cache -> cache];
	allElementObjectIndex = Map[#[[1]] -> #[[2]] &, allElementObjectPairs];
	elementObjects = myElements /. allElementObjectIndex;

	elementObjectList = ToList[elementObjects];

	dataAbsenceQ = MatchQ[#, Except[ObjectP[]]]&/@elementObjectList;

	If[MemberQ[dataAbsenceQ, True],
		Message[ECLElementData::MissingElementObjectInIndex, PickList[elementObjectList, dataAbsenceQ], indexObject];
		Return[$Failed]
	];

	(* Download all fields *)
	elementPackets = Download[elementObjects, Cache -> cache];

	(* pass to  main packet overload *)
	ECLElementData[elementPackets, myProperties, ops]
];

(* Empty set overload *)
ECLElementData[{},myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]] := {};

(* Main packet overload *)
ECLElementData[myElementPackets:ListableP[PacketP[Model[Physics, ElementData]]], myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]]:= Module[
	{elementPackets, propertyList, safeOps, output, valueRule, association, associationRule, outputRules, lists, listRule},

	safeOps = SafeOptions[ECLElementData, ToList[ops]];

	output = Lookup[safeOps, Output];

	elementPackets = ToList[myElementPackets];
	propertyList = ToList[myProperties];

	valueRule = Values -> (myProperties/.myElementPackets);

	association = Function[{pac}, AssociationMap[#/.pac&, propertyList]]/@elementPackets;

	lists = Normal/@association;

	associationRule = If[MatchQ[myElementPackets, _List],
		Association -> association,
		Association -> First[association]
	];

	listRule = If[MatchQ[myElementPackets, _List],
		Rules -> lists,
		Rules -> First[lists]
	];

	outputRules = {valueRule, associationRule, listRule};

	output/.outputRules
];

(* Errors and warnings *)
ECLElementData::MissingElementObjectInIndex="The Model[Physics, ElementData] Object correspond to the given elements `1` does not exist in the Index object `2`. Please double check the Data field of the `2` object."

(* ::Subsubsection:: *)
(*ECLIsotopeData*)
DefineOptions[ECLIsotopeData,
	Options :> {
		CacheOption
	}
];

Authors[ECLIsotopeData]:={"hanming.yang"};

ECLIsotopeData[myIsotopes:ListableP[IsotopeP], myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]]:=Module[
	{isotopeList, elementAbbreviation, elementProperties, allData, propertyList, resultValues, safeOps, cache},
	isotopeList = ToList[myIsotopes];
	propertyList = ToList[myProperties];

	safeOps = SafeOptions[ECLIsotopeData, ToList[ops]];
	cache = Lookup[safeOps, Cache];

	elementAbbreviation = StringDelete[#, DigitCharacter]&/@isotopeList;

	elementProperties = ECLElementData[elementAbbreviation, {Abbreviation, Element, Isotopes, IsotopeAbundance, IsotopeMasses}, Output -> Association, Cache -> cache];

	allData = MapThread[
		Function[{isotope, packet},
			Module[{isotopeAbundance, isotopeMass, isotopesFromElement, isotopeExistQ, isotopeToAbundanceRule, isotopeToMassRule, requestedAbundance, requestedMass, requestedAbbreviation, requestedElement},
				isotopesFromElement = Lookup[packet, Isotopes];
				isotopeExistQ = MemberQ[isotopesFromElement, isotope];
				isotopeAbundance = Lookup[packet, IsotopeAbundance];
				isotopeMass = Lookup[packet, IsotopeMasses];
				isotopeToAbundanceRule = MapThread[#1 -> #2&, {isotopesFromElement, isotopeAbundance}];
				isotopeToMassRule = MapThread[#1 -> #2&, {isotopesFromElement, isotopeMass}];
				requestedAbundance = Lookup[isotopeToAbundanceRule, isotope, 0 Percent];
				requestedMass = If[isotopeExistQ, Lookup[isotopeToMassRule, isotope], ToExpression[StringDelete[isotope, LetterCharacter]]*1 Gram/Mole];
				requestedElement = Lookup[packet, Element];
				requestedAbbreviation = Lookup[packet, Abbreviation];
				<|Element -> requestedElement, Abbreviation -> requestedAbbreviation, IsotopeAbundance -> requestedAbundance, IsotopeMasses -> requestedMass|>
			]
		],
		{isotopeList, elementProperties}
	];

	resultValues = myProperties/.allData;

	If[MatchQ[myIsotopes, _List],
		resultValues,
		First[resultValues]
	]

];

(* Empty set overload *)
ECLIsotopeData[{},myProperties:ListableP[ElementPropertyP], ops:OptionsPattern[]] := {};

(* ::Subsubsection:: *)
(*updateElementData*)
DefineOptions[updateElementData,
	Options :> {
		{Upload -> False, False|True, "Indicate whether the changes should be uploaded into database."},
		{Preview -> True, True|False, "Indicate whether a tabled comparison of the object before and after update should be shown."},
		{Index -> {}, {}|ListableP[ObjectP[Model[Physics,ElementData]]], "Indicate which index objects the input object should be added to, if it's not already there. All new objects will be added to Full Index, even if it's not specified here."},
		{Abbreviation -> Automatic, ListableP[Automatic|_String], "The standard abbreviation of the element."},
		{MolarMass -> Automatic, ListableP[Automatic|GreaterP[0 Gram/Mole]], "The atomic mass of this element, weighted averaged across all isotopes."},
		{Period -> Automatic, ListableP[Automatic|GreaterP[0,1]], "Period of the element."},
		{Group -> Automatic, ListableP[Automatic|GreaterP[0,1]|"Lanthanide"|"Actinide"], "Group of the element."},
		{Fields -> All, All|{(Abbreviation|MolarMass|Period|Group)...}, "Indicate which fields should be updated for existing elements. This doesn't apply to new elements, all fields will be updated if for elements that doesn't exist in database yet."},
		FastTrackOption
	}
];

Authors[updateElementData]:={"hanming.yang"};

updateElementData::SymbolMissingInManifest="The following symbols `1` are not present in the following manifest: `2`. Please check your spelling, and if they were correct, please add them into these manifest first.";
updateElementData::SymbolMissingInElementP="The following symbols `1` are not present in ElementP. Please check your spelling, and if they were correct, Please add them into ElementP first.";
updateElementData::OptionLengthMismatch="The following options `1` have value `2`, which do not match the length of input. Please verify your input, or consider setting them to an unified non-list option.";
updateElementData::FunctionNotRunInMathematica="This function is only supposed to be run in Mathematica, while current $ECLApplication is `1`. Function will return $Failed.";
updateElementData::IndexNotExist="The specified index objects `1` do not exist in database. These objects were omitted and not updated.";
updateElementData::NotAnIndexObject="The specified object `1` as Index option does not have Index -> True. Please double check your entry.";
updateElementData::NotUpdatedByDeveloper="This function is only meant to be used by ECL developers to create or update Model[Physics, ElementData] object. Function will terminate without evaluation.";

updateElementData[myElementSymbols:ListableP[_Symbol], ops:OptionsPattern[]]:=Module[
	{
		safeOps, upload, preview, index, abbreviations, molarMasses, periods, groups, fastTrack, inputLength, listedInput, correctOptionLengthQ,
		fields, allPatternsSymbols, inputInPatternsQ, inputInElementPQ, returnEarlyQ, elementPropertyFields, developerQ,
		elementPropertyOptionValues, listedAbbreviations, listedMolarMass, listedPeriods, listedGroups, fullIndexObject, currentElementList,
		currentElementDataList, names, modelObjects, resolvedAbbreviations, resolvedMolarMasses, resolvedPeriods, resolvedGroups, existingElementsQ,
		previewTables, existingElements, newElements, existingElementModels, existingElementPackets, fieldsToUpdate, indexNeedsUpdate,
		indexUpdatePacket, indexExist, listedIndex, fullIndexUpdatePacket, newElementModels, newElementAbbreviations, elementUpdatePackets
	},
	safeOps = SafeOptions[updateElementData, ToList[ops]];

	elementPropertyFields = {Abbreviation, MolarMass, Period, Group};

	{upload, preview, index, fastTrack, fields} = Lookup[safeOps, {Upload, Preview, Index, FastTrack, Fields}];

	listedIndex = ToList[index];

	{abbreviations, molarMasses, periods, groups} = Lookup[safeOps, elementPropertyFields];

	elementPropertyOptionValues = {abbreviations, molarMasses, periods, groups};

	(* Check for index-matching *)
	listedInput = ToList[myElementSymbols];
	inputLength = Length[listedInput];
	(* Option length is correct if 1) it is non-list or 2) if its length matches input length *)
	correctOptionLengthQ = Or[MatchQ[#, Except[_List]], Length[#]==inputLength]& /@ elementPropertyOptionValues;
	If[MemberQ[correctOptionLengthQ, False],
		Message[updateElementData::OptionLengthMismatch, PickList[elementPropertyFields, correctOptionLengthQ, False], PickList[elementPropertyFields, correctOptionLengthQ, False]]
	];

	(* Check whether input elements is in Patterns` manifest, and in ElementP *)
	allPatternsSymbols = PackageSymbols["Patterns`"];
	inputInPatternsQ = MemberQ[allPatternsSymbols, ToString[#]]&/@listedInput;
	inputInElementPQ = MatchQ[#, ElementP]&/@listedInput;

	If[MemberQ[inputInPatternsQ, False],
		Message[updateElementData::SymbolMissingInManifest, PickList[listedInput, inputInPatternsQ, False], "Patterns`"]
	];
	If[MemberQ[inputInElementPQ, False],
		Message[updateElementData::SymbolMissingInElementP, PickList[listedInput, inputInElementPQ, False]]
	];

	(* Check if $ECLApplication is Mathematica *)
	If[MatchQ[$ECLApplication, Except[Mathematica]],
		Message[updateElementData::FunctionNotRunInMathematica, $ECLApplication]
	];

	(* Check if a developer is making this change *)
	developerQ = MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]];
	If[!developerQ,
		Message[updateElementData::NotUpdatedByDeveloper]
	];

	(* Fail early if any of the above checks fails *)
	returnEarlyQ = Or[
		MemberQ[correctOptionLengthQ, False],
		!developerQ,
		MemberQ[inputInPatternsQ, False]&&!fastTrack,
		MemberQ[inputInElementPQ, False]&&!fastTrack,
		MatchQ[$ECLApplication, Except[Mathematica]]
	];
	If[returnEarlyQ, Return[$Failed]];

	(* now proceed to obtain real data *)

	(* expand options *)
	{listedAbbreviations, listedMolarMass, listedPeriods, listedGroups} = If[!MatchQ[#, _List],
		Table[#, inputLength],
		#
	]& /@ elementPropertyOptionValues;

	(* Get a list of Elements and data objects we have now *)
	fullIndexObject = Download[Model[Physics, ElementData, "Full Index"], Object];
	{currentElementList, currentElementDataList} = Download[fullIndexObject, {Data[[All, 1]], Data[[All, 2]][Object]}];

	{
		names,
		modelObjects,
		resolvedAbbreviations,
		resolvedMolarMasses,
		resolvedPeriods,
		resolvedGroups,
		existingElementsQ
	} = Transpose@MapThread[
		Function[{elementSymbol, abbreviation, molarMass, period, group},
			Module[
				{elementString, resolvedAbbreviation, resolvedMolarMass, resolvedPeriod, resolvedGroup, dataObject, existingElementQ},
				elementString = ToString[elementSymbol];
				(* For Abbreviation, MolarMass and Period, if user supplied anything, use user-supplied value, otherwise try to fetch using MM function ElementData *)
				resolvedAbbreviation = If[MatchQ[abbreviation, Automatic],
					Entity["Element", elementString]["Abbreviation"],
					abbreviation
				];
				resolvedMolarMass = If[MatchQ[molarMass, Automatic],
					Convert[Entity["Element", elementString]["AtomicMass"]*AvogadroConstant, Gram/Mole],
					molarMass
				];
				resolvedPeriod = If[MatchQ[period, Automatic],
					Entity["Element", elementString]["Period"],
					period
				];
				(* For Group, MM ElementData doesn't work on Lanthanide and Actinide. Need to manually correct that *)
				resolvedGroup = Switch[{elementSymbol, group},
					{_, Except[Automatic]}, group,
					{Lanthanum|Cerium|Praseodymium|Neodymium|Promethium|Samarium|Europium|Gadolinium|Terbium|Dysprosium|Holmium|Erbium|Thulium|Ytterbium|Lutetium, Automatic}, "Lanthanide",
					{Actinium|Thorium|Protactinium|Uranium|Neptunium|Plutonium|Americium|Curium|Berkelium|Californium|Einsteinium|Fermium|Mendelevium|Nobelium|Lawrencium, Automatic}, "Actinide",
					{_, Automatic}, Entity["Element", elementString]["Group"]
				];
				(* Find whether this Element exists in full index *)
				existingElementQ = MemberQ[currentElementList, elementSymbol];
				(* Find the Model[Physics, ElementData] for this element *)
				dataObject = If[existingElementQ,
					Part[currentElementDataList, First[FirstPosition[currentElementList, elementSymbol]]],
					CreateID[Model[Physics, ElementData]]
				];
				{
					elementString,
					dataObject,
					resolvedAbbreviation,
					resolvedMolarMass,
					resolvedPeriod,
					resolvedGroup,
					existingElementQ
				}
			]
		],
		{listedInput, listedAbbreviations, listedMolarMass, listedPeriods, listedGroups}
	];

	existingElements = PickList[listedInput, existingElementsQ];
	newElements = PickList[listedInput, existingElementsQ, False];
	existingElementModels = PickList[modelObjects, existingElementsQ];
	existingElementPackets = Download[existingElementModels, Evaluate[Packet@@elementPropertyFields]];
	newElementModels = PickList[modelObjects, existingElementsQ, False];
	newElementAbbreviations = PickList[resolvedAbbreviations, existingElementsQ, False];
	fieldsToUpdate = fields /. <|All -> elementPropertyFields|>;

	(* Generate preview if Preview -> True*)
	If[preview,
		previewTables = Module[{existingElementsTable, newElementsTable, oldAbbreviation, oldMolarMass, oldPeriod, oldGroup},
			oldAbbreviation = Lookup[existingElementPackets, Abbreviation];
			oldMolarMass = Lookup[existingElementPackets, MolarMass];
			oldGroup = Lookup[existingElementPackets, Group];
			oldPeriod = Lookup[existingElementPackets, Period];
			existingElementsTable = Transpose[{
				Prepend[existingElements, "Element"],
				Prepend[existingElementModels, "Object"],
				If[MemberQ[fieldsToUpdate, Abbreviation],
					Sequence@@{Prepend[oldAbbreviation, "Old Abbreviation"], Prepend[PickList[resolvedAbbreviations, existingElementsQ], "New Abbreviation"]},
					Nothing
				],
				If[MemberQ[fieldsToUpdate, MolarMass],
					Sequence@@{Prepend[oldMolarMass, "Old Molar Mass"], Prepend[PickList[resolvedMolarMasses, existingElementsQ], "New Molar Mass"]},
					Nothing
				],
				If[MemberQ[fieldsToUpdate, Group],
					Sequence@@{Prepend[oldGroup, "Old Group"], Prepend[PickList[resolvedGroups, existingElementsQ], "New Group"]},
					Nothing
				],
				If[MemberQ[fieldsToUpdate, Period],
					Sequence@@{Prepend[oldPeriod, "Old Period"], Prepend[PickList[resolvedPeriods, existingElementsQ], "New Period"]},
					Nothing
				]
			}];
			newElementsTable = Prepend[Transpose[{
				newElements,
				PickList[modelObjects, existingElementsQ, False],
				PickList[resolvedAbbreviations, existingElementsQ, False],
				PickList[resolvedMolarMasses, existingElementsQ, False],
				PickList[resolvedGroups, existingElementsQ, False],
				PickList[resolvedPeriods, existingElementsQ, False]
			}],{"Element", "Object", "Abbreviation", "Molar Mass", "Group", "Period"}];
			Sequence@@{
				PlotTable[existingElementsTable, Title -> "Preview of existing elements before and after update"],
				PlotTable[newElementsTable, Title -> "Preview of new elements"]
			}
		];
		Print[previewTables]
	];

	(* Construct update packets for index objects *)
	indexExist = If[MatchQ[listedIndex, {}],
		{},
		PickList[listedIndex, DatabaseMemberQ[listedIndex]]
	];

	If[Length[PickList[listedIndex, DatabaseMemberQ[listedIndex], False]] > 0,
		Message[updateElementData::IndexNotExist, PickList[listedIndex, DatabaseMemberQ[listedIndex], False]]
	];

	indexNeedsUpdate = If[MatchQ[indexExist, {}],
		{},
		PickList[indexExist, Download[indexExist, Index]]
	];

	If[Length[Complement[indexExist, indexNeedsUpdate]] > 0,
		Message[updateElementData::NotAnIndexObject, Complement[indexExist, indexNeedsUpdate]]
	];

	indexUpdatePacket = If[Length[indexNeedsUpdate] > 0,
		Map[
			Function[{indexObject},
				Module[{currentIncludedElements, elementsNeedToBeAppended, elementIncludedFilter, dataObjectToBeAppended, abbreviationsNeedToBeAppended},
					currentIncludedElements = Download[indexObject, Data[[All, 1]]];
					elementIncludedFilter = MemberQ[currentIncludedElements, #]& /@ listedInput;
					elementsNeedToBeAppended = PickList[listedInput, elementIncludedFilter, False];
					dataObjectToBeAppended = PickList[modelObjects, elementIncludedFilter, False];
					abbreviationsNeedToBeAppended = PickList[resolvedAbbreviations, elementIncludedFilter, False];
					If[Length[elementsNeedToBeAppended] > 0,
						<|
							Object -> indexObject,
							Append[Data] -> Transpose[{elementsNeedToBeAppended, Link/@dataObjectToBeAppended}],
							Append[AbbreviationIndex] -> Transpose[{abbreviationsNeedToBeAppended, Link/@dataObjectToBeAppended}]
						|>,
						Nothing
					]
				]
			],
			Download[indexNeedsUpdate, Object]
		],
		{}
	];

	fullIndexUpdatePacket = If[Length[newElements] > 0,
		<|
			Object -> fullIndexObject,
			Append[Data] -> Transpose[{newElements, Link/@newElementModels}],
			Append[AbbreviationIndex] -> Transpose[{newElementAbbreviations, Link/@newElementModels}]
		|>,
		{}
	];

	elementUpdatePackets = MapThread[
		Function[{element, name, model, abbreviation, molarMass, period, group, existingelementQ},
			Join[
				<|Object -> model|>,
				If[MemberQ[fieldsToUpdate, Abbreviation]||!existingelementQ,
					<|Abbreviation -> abbreviation|>,
					<||>
				],
				If[MemberQ[fieldsToUpdate, MolarMass]||!existingelementQ,
					<|MolarMass -> molarMass|>,
					<||>
				],
				If[MemberQ[fieldsToUpdate, Period]||!existingelementQ,
					<|Period -> period|>,
					<||>
				],
				If[MemberQ[fieldsToUpdate, Group]||!existingelementQ,
					<|Group -> group|>,
					<||>
				],
				If[!existingelementQ,
					Association[Name -> name, Replace[Authors] -> {Link[$PersonID]}, CreatedBy -> Link[$PersonID], DateCreated -> Now, Element -> element, Index -> False],
					<||>
				]
			]
		],
		{
			listedInput,
			names,
			modelObjects,
			resolvedAbbreviations,
			resolvedMolarMasses,
			resolvedPeriods,
			resolvedGroups,
			existingElementsQ
		}
	];

	If[upload,
		Upload[Flatten[{elementUpdatePackets, fullIndexUpdatePacket, indexUpdatePacket}]],
		Flatten[{elementUpdatePackets, fullIndexUpdatePacket, indexUpdatePacket}]
	]

];

(* ::Subsubsection:: *)
(*updateIsotopeData*)
DefineOptions[updateIsotopeData,
	Options :> {
		{Upload -> False, False|True, "Indicate whether the changes should be uploaded into database."},
		{Preview -> True, True|False, "Indicate whether a tabled comparison of the object before and after update should be shown."},
		{MassNumbers -> Automatic, Automatic|{Automatic|{_Integer..}..}, "For each member of input element, indicate the list of mass numbers of the isotopes that needs to be updated. Option not valid when using list of isotopes as input."},
		{IncludeRareIsotopes -> False, ListableP[True|False], "For each member of input element, indicate whether more rare isotopes which is not included in MM function ElementData[element, \"IsotopeAbundance\" but exist in Wolfram database. Option not valid when using list of isotopes as input."},
		{MolarMass -> Automatic, Automatic|{Automatic|{_Quantity..}..}, "For each member of input isotope or mass numbers, indicate the atomic mass in units of g/mol."},
		{IsotopeAbundance -> Automatic, Automatic|{Automatic|{RangeP[0,1]..}..}, "For each member of input isotope or mass numbers, indicate the natural abundance."},
		FastTrackOption
	}
];

Authors[updateIsotopeData]:={"hanming.yang"};

updateIsotopeData::OptionLengthMismatch="The following options `1` have value `2`, which do not match the length of `3`. Please verify these option inputs, or consider setting them to an unified non-list option.";
updateIsotopeData::OptionLengthNotMatchMassNumberLength="`1`";
updateIsotopeData::FunctionNotRunInMathematica="This function is only supposed to be run in Mathematica, while current $ECLApplication is `1`. Function will return $Failed.";
updateIsotopeData::NotUpdatedByDeveloper="This function is only meant to be used by ECL developers to create or update Model[Physics, ElementData] object. Function will terminate without evaluation.";

(* Element Overload *)
updateIsotopeData[myElementList:ListableP[ElementP], ops:OptionsPattern[]]:=Module[
	{
		safeOps, upload, preview, massNumbers, includeRareIsotopes, molarMasses, isotopeAbundances, fastTrack, isotopeList,
		numberOfInputs, inputIndexMatchingQ, molarMassIndexMatchingQ, molarMassErrorMessage, isotopeAbundanceIndexMatchingQ, isotopeAbundanceErrorMessage,
		listedMassNumbers, listedInput, elementString, listedIncludeRareIsotopes, flattenedIsotopeList, expandedMolarMass,
		expandedIsotopeAbundances, existingIsotopeData, uploadPackets, elementAbbreviation, stringToAbbreviationRule, developerQ
	},

	safeOps = SafeOptions[updateIsotopeData, ToList[ops]];

	{upload, preview, massNumbers, includeRareIsotopes, molarMasses, isotopeAbundances, fastTrack} = Lookup[safeOps,
		{Upload, Preview, MassNumbers, IncludeRareIsotopes, MolarMass, IsotopeAbundance, FastTrack}
	];

	(* Check if $ECLApplication is Mathematica; if not, return $Failed *)
	If[MatchQ[$ECLApplication, Except[Mathematica]],
		Message[updateIsotopeData::FunctionNotRunInMathematica, $ECLApplication];
		Return[$Failed]
	];

	(* Check if a developer is making this change *)
	developerQ = MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]];
	If[!developerQ,
		Message[updateElementData::NotUpdatedByDeveloper];
		Return[$Failed]
	];

	(* Check for length *)
	numberOfInputs = Length[ToList[myElementList]];
	inputIndexMatchingQ = Map[
		(!MatchQ[#, _List])||(Length[#] == numberOfInputs)&,
		{massNumbers, includeRareIsotopes, molarMasses, isotopeAbundances}
	];

	If[MemberQ[inputIndexMatchingQ, False],
		Message[updateIsotopeData::OptionLengthMismatch,
			PickList[{MassNumbers, IncludeRareIsotopes, MolarMass, IsotopeAbundance}, inputIndexMatchingQ, False],
			PickList[{massNumbers, includeRareIsotopes, molarMasses, isotopeAbundances}, inputIndexMatchingQ, False],
			"Input element list: "<>ToString[ToList[myElementList]]
		];
		Return[$Failed]
	];

	{molarMassIndexMatchingQ, molarMassErrorMessage} = Which[
		(* If MolarMass is a singleton option, that's good *)
		MatchQ[molarMasses, Automatic], {True, Null},
		(* If MassNumber is a singleton option, MolarMass must also be *)
		MatchQ[massNumbers, Automatic], {MatchQ[molarMasses, Automatic], "Option MolarMass must be set to Automatic when option MassNumber -> Automatic. Please change the input option."},
		(* If MassNumber is a list, then length of inner lists must match *)
		True, {And @@ MapThread[MatchQ[#2, Automatic] || (MatchQ[#2, _List] && Length[#1] == Length[#2])&, {massNumbers, molarMasses}], "For each inner list of MassNumber, MolarMass must either be set to Automatic, or specified as a list index-matching to that inner list of MassNumber."}
	];

	{isotopeAbundanceIndexMatchingQ, isotopeAbundanceErrorMessage} = Which[
		(* If MolarMass is a singleton option, that's good *)
		MatchQ[isotopeAbundances, Automatic], {True, Null},
		(* If MassNumber is a singleton option, MolarMass must also be *)
		MatchQ[massNumbers, Automatic], {MatchQ[isotopeAbundances, Automatic], "Option MolarMass must be set to Automatic when option MassNumber -> Automatic. Please change the input option."},
		(* If MassNumber is a list, then length of inner lists must match *)
		True, {And @@ MapThread[MatchQ[#2, Automatic] || (MatchQ[#2, _List] && Length[#1] == Length[#2])&, {massNumbers, isotopeAbundances}], "For each inner list of MassNumber, IsotopeAbundance must either be set to Automatic, or specified as a list index-matching to that inner list of MassNumber."}
	];

	If[!molarMassIndexMatchingQ,
		Message[updateIsotopeData::OptionLengthNotMatchMassNumberLength, molarMassErrorMessage]
	];
	If[!isotopeAbundanceIndexMatchingQ,
		Message[updateIsotopeData::OptionLengthNotMatchMassNumberLength, isotopeAbundanceErrorMessage]
	];
	If[!(molarMassIndexMatchingQ&&isotopeAbundanceIndexMatchingQ),
		Return[$Failed]
	];

	(* Expand mass number into isotopes *)
	listedMassNumbers = If[MatchQ[massNumbers, Automatic],
		Table[Automatic, numberOfInputs],
		massNumbers
	];

	(* Find the abbreviated string form of all input elements in one run *)
	listedInput = ToList[myElementList];

	elementString = ToString/@listedInput;
	elementAbbreviation = EntityValue[Entity["Element", #]&/@elementString, "Abbreviation"];
	stringToAbbreviationRule = MapThread[#1 -> #2&, {elementString, elementAbbreviation}];

	listedIncludeRareIsotopes = If[MatchQ[includeRareIsotopes, _List],
		includeRareIsotopes,
		Table[includeRareIsotopes, numberOfInputs]
	];

	isotopeList = MapThread[
		Function[{element, massNumber, rareIsotopeQ},
			Switch[{massNumber, rareIsotopeQ},
				(* If mass number is specified as a list, combine each mass number with current element *)
				{_List, _}, element<>ToString[#]& /@ massNumber,
				(* If mass number is automatic and IncludeRareIsotopes is False, Run MM function ElementData to retrive property IsotopeAbundances, use that list *)
				{Automatic, False}, element<>ToString[#]& /@ EntityValue[Keys[Entity["Element", element]["IsotopeAbundances"]], "MassNumber"],
				(* If IncludeRareIsotopes is True, call the helper function below to try to find as many isotopes as possible *)
				{Automatic, True}, findAllPossibleIsotopes[element]
			]
		],
		{elementString, listedMassNumbers, listedIncludeRareIsotopes}
	];

	(* expand MolarMass and IsotopeAbundances option to index-match the isotope list *)
	expandedMolarMass = If[MatchQ[molarMasses, Automatic],
		Table[Automatic, Length[#]]&/@isotopeList,
		MapThread[
			If[MatchQ[#1, Automatic],
				Table[Automatic, Length[#2]],
				#1
			]&,
			{molarMasses, isotopeList}
		]
	];

	expandedIsotopeAbundances = If[MatchQ[isotopeAbundances, Automatic],
		Table[Automatic, Length[#]]&/@isotopeList,
		MapThread[
			If[MatchQ[#1, Automatic],
				Table[Automatic, Length[#2]],
				#1
			]&,
			{isotopeAbundances, isotopeList}
		]
	];

	existingIsotopeData = ECLElementData[listedInput, {Object, Isotopes, IsotopeAbundance, IsotopeMasses}, Output -> Association];

	uploadPackets = MapThread[
		Function[{oldIsotopeData, isotopes, abundances, isotopeMolarMasses},
			Module[{existingIsotopes, isotopeAlreadyExistQ, resolvedAbundances, resolvedMolarMasses, patternMatchingIsotopes},
				existingIsotopes = Lookup[oldIsotopeData, Isotopes];
				isotopeAlreadyExistQ = MemberQ[existingIsotopes, #]& /@ isotopes;
				resolvedAbundances = MapThread[
					If[MatchQ[#1, Automatic],
						Convert[Entity["Isotope", #2]["IsotopeAbundance"], Percent],
						Convert[#1, Percent]
					]&,
					{abundances, isotopes}
				];
				resolvedMolarMasses = MapThread[
					If[MatchQ[#1, Automatic],
						Convert[Entity["Isotope", #2]["AtomicMass"]*AvogadroConstant, Gram/Mole],
						#1
					]&,
					{isotopeMolarMasses, isotopes}
				];
				(* Isotopes accepted by MM Entity is not what we want, need to change *)
				(* Essentially change something like Sodium23 into 23Na *)
				patternMatchingIsotopes = Map[
					Function[{singleIsotope},
						StringDelete[singleIsotope, LetterCharacter]<>(StringReplace[StringDelete[singleIsotope, DigitCharacter], stringToAbbreviationRule])
					],
					isotopes
				];
				<|
					Object -> Lookup[oldIsotopeData, Object],
					Replace[Isotopes] -> patternMatchingIsotopes,
					Replace[IsotopeAbundance] -> resolvedAbundances,
					Replace[IsotopeMasses] -> resolvedMolarMasses
				|>
			]
		],
		{existingIsotopeData, isotopeList, expandedIsotopeAbundances, expandedMolarMass}
	];

	If[preview,
		Print[PlotTable[Transpose@MapThread[Prepend[#1, #2]&,
			{
				Transpose@MapThread[
					{
						#3,
						Lookup[#1, Object],
						Lookup[#1, Isotopes],
						Lookup[#2, Replace[Isotopes]],
						Lookup[#1, IsotopeAbundance],
						Lookup[#2, Replace[IsotopeAbundance]],
						Lookup[#1, IsotopeMasses],
						Lookup[#2, Replace[IsotopeMasses]]
					}&,
					{existingIsotopeData, uploadPackets, listedInput}
				],
				{
					"Element",
					"Data Object",
					"Isotopes (Previous)",
					"Isotopes (Updated)",
					"IsotopeAbundance (Previous)",
					"IsotopeAbundance (Updated)",
					"IsotopeMasses (Previous)",
					"IsotopeMasses (Updated)"
				}
			}
		]]]
	];

	If[upload,
		Upload[uploadPackets],
		uploadPackets
	]

];


findAllPossibleIsotopes[myElement_String]:=Module[
	{atomicNumber, averageAtomicMass, massNumberLowerLimit, massNumberHigherLimit, allGuessedIsotopeMassNumbers, allRealIsotopeMassNumbers},
	atomicNumber = Entity["Element", myElement]["AtomicNumber"];
	averageAtomicMass = Entity["Element", myElement]["AtomicMass"];
	massNumberLowerLimit = Max[
		0,
		Floor[Unitless[averageAtomicMass]/2],
		atomicNumber,
		Floor[Unitless[averageAtomicMass]] - 30
	];
	massNumberHigherLimit = Max[Min[
		Ceiling[Unitless[averageAtomicMass]*2],
		Ceiling[Unitless[averageAtomicMass]+30]
	], Unitless[averageAtomicMass]+10];

	allGuessedIsotopeMassNumbers = Quiet[Entity["Isotope", myElement<>ToString[#]]["MassNumber"]& /@ Range[massNumberLowerLimit, massNumberHigherLimit, 1], {IsotopeData::notent}];
	allRealIsotopeMassNumbers = Cases[allGuessedIsotopeMassNumbers, _Integer];

	(myElement<>ToString[#])&/@allRealIsotopeMassNumbers
];