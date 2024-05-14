(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Formats*)


(* ::Subsubsection::Closed:: *)
(*Patterns*)


RateFormatP=Except[_List|_Rule|_Equilibrium];


irreversibleImplicitReactionFormatP={_Rule,RateFormatP};
reversibleImplicitReactionFormatP={_Equilibrium,RateFormatP,RateFormatP};
implicitReactionFormatP=irreversibleImplicitReactionFormatP|reversibleImplicitReactionFormatP;

irreversibleReactionFormatP=Reaction[_List,_List,RateFormatP];
reversibleReactionFormatP=Reaction[_List,_List,RateFormatP,RateFormatP];
(*reactionFormatP=irreversibleReactionFormatP|reversibleReactionFormatP;*)
reactionFormatP = Reaction[_List,_List,Repeated[RateFormatP,{1,2}]];

interactionFormatP = Rule[_,Except[_?NumberQ|_Quantity]] | _Equilibrium;


(* ::Subsubsection::Closed:: *)
(*Evaluation*)


Reaction[interaction_Rule] := With[{temp = implicitReactionToReaction[{interaction}]}, Append[temp,ClassifyReaction@@temp]];
Reaction[interaction_Equilibrium] := With[{temp = implicitReactionToReaction[{interaction}]}, Append[Append[temp,ClassifyReaction@@temp],ClassifyReaction@@Reverse[temp]]];
Reaction[interaction_Rule, rate: RateFormatP] := implicitReactionToReaction[{interaction, rate}];
Reaction[interaction_Equilibrium, rate1: RateFormatP, rate2: RateFormatP] := implicitReactionToReaction[{interaction, rate1, rate2}];
Reaction[impReac: implicitReactionFormatP] := implicitReactionToReaction[impReac];


(* ::Subsection:: *)
(*Validity*)


(* ::Subsubsection:: *)
(*ReactionQ*)


DefineOptions[ReactionQ,
	SharedOptions:>{RunValidQTest}
];

(*
	Check that reaction has valid format, and rates are consistent with reaction type
*)
ReactionQ[rxn_,ops:OptionsPattern[]]:=Module[{},

	RunValidQTest[
		rxn,
		{formattedReactionTest,consistentReactionRateTests},
		ops
	]

];

(*
	Test checks if reaction is properly formatted
*)
formattedReactionTest[rxn_]:=Module[{},
	{Test["Reaction is properly formatted:",
		MatchQ[rxn,ReactionP],
		True
	]}
];

(*
	Tests check that rates are consistent with reaction type/order
*)
(* check that ClassifyReaction returns reaction type matching what was already in there *)
consistentReactionRateTests[rxn_]:= Module[{splitReactions,directions},

	splitReactions = SplitReaction[rxn];
	directions = {"forward","reverse"};
	(* using table b/c length of directions is always 2, but splitReactions could be 1 *)
	Table[
		consistentReactionRateTest[splitReactions[[ind]],directions[[ind]]],
		{ind,1,Length[splitReactions]}
	]

];

consistentReactionRateTest[Reaction[reactants_,products_,rate_Symbol],direction_String]:= With[
	{classification = ClassifyReaction[reactants,products]},
	Test["Symbolic rate of "<>direction<>" reaction is consistent with the reactants and products:",
		MatchQ[classification,rate],
		True
	]
];

consistentReactionRateTest[Reaction[reactants_,products_,rate:UnitsP[]],direction_String]:= With[
	{
		rateUnit = Units[rate],
		expectedUnit = Switch[Length[reactants],
			1, 1 / Second,
			2, 1 / Molar / Second,
			_, $Failed
		]
	},
	Test["Numeric rate of "<>direction<>" reaction is consistent with the reactants and products:",
		CompatibleUnitQ[rateUnit,expectedUnit],
		True
	]
];

consistentReactionRateTest[___]:=Nothing;


(* ::Subsection::Closed:: *)
(*Parsing*)


reactionToSpecies[Reaction[{reactants__},{products__},_,Repeated[_,{0,1}]]]:=DeleteDuplicates[{reactants,products}];
implicitReactionToSpecies[reac:implicitReactionFormatP]:=reactionToSpecies[implicitReactionToReaction[reac]];
interactionToSpecies[interaction:interactionFormatP]:=implicitReactionToSpecies[interactionToImplicitReaction[interaction]];


implicitReactionToRates[reac:implicitReactionFormatP]:=reac[[2;;]];


reactionToReactants[Reaction[{reactants__},{products__},_]]:={reactants};
reactionToReactants[Reaction[{reactants__},{products__},_,_]]:={reactants,products};
reactionToProducts[Reaction[{reactants__},{products__},_]]:={products};
reactionToProducts[Reaction[{reactants__},{products__},_,_]]:={reactants,products};


reactionDegree[Reaction[{reactants__},{products__},_,_]]:=Max[{Length[{reactants}],Length[{products}]}];
reactionDegree[Reaction[{reactants__},{products__},_]]:=Length[{reactants}];


(* ::Subsection::Closed:: *)
(*Transforming*)


implicitReactionHalfToReactionHalf[stuff_] := If[MatchQ[#, _Strand], Structure[#], #] & /@ Flatten[{stuff}/.{Plus->List,Times[x_,n_Integer]:>Table[x,n]}];

implicitReactionToReaction[{Rule[reactants_,products_]}]:=
    Reaction[implicitReactionHalfToReactionHalf[reactants],implicitReactionHalfToReactionHalf[products]];
implicitReactionToReaction[{Equilibrium[reactants_,products_]}]:=
    Reaction[implicitReactionHalfToReactionHalf[reactants],implicitReactionHalfToReactionHalf[products]];
implicitReactionToReaction[{Rule[reactants_,products_],forwardRate_}]:=
    Reaction[implicitReactionHalfToReactionHalf[reactants],implicitReactionHalfToReactionHalf[products],forwardRate];
implicitReactionToReaction[{Equilibrium[reactants_,products_],forwardRate_,reverseRate_}]:=
    Reaction[implicitReactionHalfToReactionHalf[reactants],implicitReactionHalfToReactionHalf[products],forwardRate,reverseRate];

reactionToImplicitReaction[Reaction[{reactants__},{products__},forwardRate_]]:={Rule[Plus[reactants],Plus[products]],forwardRate};
reactionToImplicitReaction[Reaction[{reactants__},{products__},forwardRate_,reverseRate_]]:={Equilibrium[Plus[reactants],Plus[products]],forwardRate,reverseRate};

interactionToImplicitReaction[interaction_Rule]:={interaction,Null};
interactionToImplicitReaction[interaction_Equilibrium]:={interaction,Null,Null};


(* ::Subsection::Closed:: *)
(*Manipulation*)


splitReaction[in:Reaction[_,_,_]]:=in;
splitReaction[Reaction[a_,b_,c_,d_]]:=Sequence[Reaction[a,b,c],Reaction[b,a,d]];


toFullImplicitReaction[in:(_Rule|_Equilibrium)]:={in};
toFullImplicitReaction[in:(irreversibleImplicitReactionFormatP|reversibleImplicitReactionFormatP|{_Rule}|{_Equilibrium})]:=in;


addSymbolicRatesToReaction[{r_Rule},ind_Integer]:={r,Unique @ Symbol["kf"<>ToString[ind]]};
addSymbolicRatesToReaction[in:{r_Rule,_},ind_Integer]:=in;
addSymbolicRatesToReaction[{r_Equilibrium},ind_Integer]:={r,Unique @ Symbol["kf"<>ToString[ind]], Unique @ Symbol["kb"<>ToString[ind]]};
addSymbolicRatesToReaction[in:{r_Equilibrium,_,_},ind_Integer]:=in;



(* ::Subsubsection::Closed:: *)
(*SplitReaction*)


SplitReaction[rxn:ReversibleReactionP]:={
	Reaction[rxn[Reactants],rxn[Products],First[rxn[Rates]]],
	Reaction[rxn[Products],rxn[Reactants],Last[rxn[Rates]]]
};
SplitReaction[rxn:IrreversibleReactionP]:={rxn};


(* ::Subsubsection::Closed:: *)
(*SubValues*)


OnLoad[
	Unprotect[Reaction];
	Reaction /: Keys[Reaction] := {Species,Reactants,Products,Interaction,Rates,Degree};
	Reaction /: Keys[_Reaction] := Keys[Reaction];
	(reac:reactionFormatP)["Properties"|Properties]:=Keys[Reaction];
	(reac:reactionFormatP)["Species"|Species]:=Union[reac[Reactants],reac[Products]];
	(reac:reactionFormatP)["ImplicitReaction"|ImplicitReaction]:=reactionToImplicitReaction[reac];
	(reac:reactionFormatP)["Reactants"|Reactants]:=reac[[1]];
	(reac:reactionFormatP)["Degree"|Degree]:=reactionDegree[reac];
	(reac:reactionFormatP)["Products"|Products]:=reac[[2]];
	(reac:reactionFormatP)["Rates"|Rates]:=(List@@reac)[[3;;]];
	(reac:reactionFormatP)["Interaction"|Interaction]:=reactionToImplicitReaction[reac][[1]];
];



(* ::Subsection:: *)
(*Classification*)


(* ::Subsubsection:: *)
(*ClassifyReaction*)


ClassifyReaction::UnknownStructure =  "Unable to interpret the provided structure. Please use StructureQ on the input for more information on the issue with the provided structure.";


ClassifyReaction[reactants: {StructureP..}, products: {StructureP..}] := Module[{
		reactantsParsed, productsParsed, strandsSameB,
		commonStructures, reactantsChange, productsChange,
		reactantStrands,productStrands
	},

	(* all reactants and products must be valid structures *)
	If[!AllTrue[Join[reactants, products], StructureQ],
		Message[ClassifyReaction::UnknownStructure];
		Return[$Failed]
	];

	reactantsParsed = Flatten[parseOneStructure /@ reactants];
	productsParsed = Flatten[parseOneStructure /@ products];

	(* find the structures that are identical on both sides *)
	commonStructures = Intersection[reactantsParsed,productsParsed];

	(* remove them from the reactant and product lists *)
	(* these are the structures that are involed in the reaction.  Only look at these *)
	reactantsChange = Select[reactantsParsed,!MemberQ[commonStructures,#]&]; (* can't use Complement b/c it deletes duplicates *)
	productsChange = Select[productsParsed,!MemberQ[commonStructures,#]&];

	(* Unchanged - if nothing changes on either side, then Unchanged reaction *)
	If[
		And[
			MatchQ[reactantsChange,{}],
			MatchQ[productsChange,{}]
		],
		Return[Unchanged]
	];

	(* Cannot have more than 2 reactants *)
	If[
		Length[reactantsChange]>2,
		Return[Unknown]
	];

	reactantStrands = #[Strands]&/@reactantsChange;
	productStrands = #[Strands]&/@productsChange;

	(* same strands must exist on both sides of the reaction *)
	If[
		UnsameQ[
			Sort[Flatten[reactantStrands]],
			Sort[Flatten[productStrands]]
		],
		Return[Unknown]
	];

	(* 1 to 1 reaction *)
	If[
		And[
			Length[reactantsChange]==1,
			Length[productsChange]==1
		],
		With[{temp = classifyReactionCoreOneToOne[reactantsChange, {#}] & /@ (bfStrandReorder[productsChange] /. bd_Bond :> Sort[bd])},
			Return[If[MatchQ[temp, {Unknown..}],
				Unknown,
				First[DeleteCases[temp, Unknown]]
			]]
		]
	];

	(* 2 to 1 reaction -- Hybridization or Unknown *)
	If[
		And[
			Length[reactantsChange]==2,
			Length[productsChange]==1
		],
		Return@If[
			singleMeltToDoubleQ[productsChange, reactantsChange],
			Hybridization,
			Unknown
		]
	];

	(* 1 to n (n\[GreaterEqual]2) reaction -- Dissociation or Unknown *)
	If[
		And[
			Length[reactantsChange]==1,
			Length[productsChange]>=2
		],
		Return @ If[
			singleMeltToMultipleQ[reactantsChange, productsChange],
			Dissociation,
			If[validDuplexExchangeQ[reactantsChange, productsChange],
				ToeholdMediatedDuplexExchange,
				Unknown
			]
		]
	];

	(* 2 to 2 reaction *)
	If[
		And[
			Length[reactantsChange]==2,
			Length[productsChange]==2
		],
		Return[classifyReactionCoreTwoToTwo[reactantsChange, productsChange]]
	];

	(* Shouldn't be able to hit this point, but if you do, Unknown *)
	Unknown

];

ClassifyReaction[_, _] := Unknown;


parseOneStructure[struct_] := consolidateBonds /@ reformatBonds[SplitStructure[struct], StrandBase];


(* ::Subsubsection:: *)
(*classifyReactionCore*)


(* 1 \[Rule] 1 *)
classifyReactionCoreOneToOne[reactant: {Structure[reactantStrands: {_Strand..}, reactantBonds: {_Bond...}]}, product: {Structure[productStrands: {_Strand..}, productBonds: {_Bond...}]}] := Module[
	{uniqueBondsBefore, uniqueBondsAfter},

	(* find bond changes *)
	uniqueBondsBefore = Complement[reactantBonds, productBonds];
	uniqueBondsAfter = Complement[productBonds, reactantBonds];

	(* no bond chnages, then Unchanged reaction *)
	If[
		And[
			Length[uniqueBondsBefore]==0,
			Length[uniqueBondsAfter]==0
		],
		Return[Unchanged]
	];

	(* only new product bonds, then folding *)
	If[
		And[
			Length[uniqueBondsBefore]==0,
			Length[uniqueBondsAfter]>0
		],
		Return[Folding]
	];

	(* only new reactant bonds, then Melting *)
	If[
		And[
			Length[uniqueBondsBefore]>0,
			Length[uniqueBondsAfter]==0
		],
		Return[Melting]
	];

	(* Zipping -- product bonds are continuation or reactant bonds *)
	If[
		And[
			Length[uniqueBondsBefore]>0,
			Length[uniqueBondsAfter]>0,
			bondContinuationQ[uniqueBondsBefore,uniqueBondsAfter]
		],
		Return[Zipping]
	];

	(* Unzipping -- reactant bonds are continuation of product bonds *)
	If[
		And[
			Length[uniqueBondsBefore]>0,
			Length[uniqueBondsAfter]>0,
			bondContinuationQ[uniqueBondsAfter,uniqueBondsBefore]
		],
		Return[Unzipping]
	];

	(* 1st order StrandExchange -- reactant bonds are switch of product bonds *)
	If[
		And[
			Length[uniqueBondsBefore] == 2,
			Length[uniqueBondsAfter] == 2,
			isExchange[uniqueBondsAfter, uniqueBondsBefore]
		],
		Return[StrandInvasion]
	];

	(* anything else *)
	Unknown

];



(* 2 \[Rule] 2 *)
classifyReactionCoreTwoToTwo[reactants: {_Structure, _Structure}, products: {_Structure, _Structure}] := Module[
	{beforeDict, afterDict, strandMappingRules, bondChanges, invasionStatus, toeStatus, toeStatusGeneral, fingerStatus,out},

	(* construct a strand mapping between strands in reactants and products *)
	{{beforeDict, afterDict}, strandMappingRules} = strandMapping[reactants, products];


	If[MatchQ[strandMappingRules, $Failed], Return[Unknown]];

	(* find bond changes *)
	bondChanges = Cases[
		Map[
			bondChange[beforeDict[#[[2]]], afterDict[#[[1]]], strandMappingRules, Reverse /@ strandMappingRules]&,
			strandMappingRules
		],
		Except[{_, {}, {}}]
	];

	(* cannot recognize reaction type if bond changes more than 4 *)
	If[
		Or[
			!MatchQ[Length[bondChanges], 3 | 4],
			!ContainsOnly[Flatten[(Length /@ (Rest[#])) & /@ bondChanges], {0, 1}]
		],
		Return[Unknown]
	];

	(* determine if the change is invasion *)
	invasionStatus = isInvasion[bondChanges];
	Switch[invasionStatus,
		1, Return[StrandInvasion],
		2, Return[DuplexInvasion]
	];

	(* determine if the bond change includes a toehold region *)
	toeStatus = isToe[#, strandMappingRules] & /@ bondChanges;
	If[MemberQ[toeStatus, $Failed], Return[Unknown]];
	toeStatusGeneral = First /@ toeStatus;

	(* if none of the bond changes are toeholds, Unknown type *)
	If[!(Or @@ toeStatusGeneral), Return[Unknown]];

	(* determine reaction type *)
	Switch[Sort[toeStatusGeneral],
		{True, True, True, True}, isDual[Transpose[{Last /@ toeStatus, bondChanges}]],
		{False, False, True}, ToeholdMediatedStrandExchange,
		{False, False, True, True}, isToeComp[bondChanges[[Flatten[Position[toeStatusGeneral, False]]]], strandMappingRules],
		_, Unknown
	]
];


(* ::Subsubsection::Closed:: *)
(*bfStrandReorder*)


bfStrandReorder[{structure: Structure[strands_List, bonds_List]}] := Module[
	{strandIndexDict, generateRule, bfRuleIndividual, bfRuleAll},

	strandIndexDict = GroupBy[Transpose[{ToString /@ Range[1, Length[strands]], strands}], Last -> First];
	generateRule[li_List] := MapThread[Rule, {li, Append[Rest[li], First[li]]}];
	bfRuleIndividual = Map[generateRule, #] & /@ (Subsets[#, {1, Infinity}] & /@ strandIndexDict);

	bfRuleAll = Flatten /@ Tuples[Values[bfRuleIndividual]];
	DeleteDuplicates[structure /. {tt_Integer, b_Span} :> {ToString[tt], b} /. bfRuleAll] /. {tt_String, b_Span} :> {ToExpression[tt], b}
];


(* ::Subsubsection::Closed:: *)
(*singleMeltToDoubleQ*)


singleMeltToDoubleQ[single: {Structure[singleStrands: {_Strand..}, singleBonds: {_Bond...}]}, doubleList_] := Module[
	{doubleSorted, out},

	doubleSorted = Sort[StructureSort /@ doubleList];

	(*
		Try removing each bond from the single 'before' structure,
		and check if the result matches the doubleList 'after' structures
	*)
	out = Catch[
		Do[
			If[
				MatchQ[
					StructureSort /@ SplitStructure[Structure[singleStrands, Delete[singleBonds, i]]],
					doubleSorted
				],
				Throw[True]
			],
			{i, 1, Length[singleBonds]}
		]
	];

	If[MatchQ[out, Null], False, out]

];
singleMeltToDoubleQ[_, _] := False;


(* ::Subsubsection::Closed:: *)
(*singleMeltToMultipleQ*)


singleMeltToMultipleQ[{single: Structure[singleStrands: {_Strand..}, singleBonds: {_Bond...}]}, multipleList_] := Module[
	{multipleSorted, out},

	multipleSorted = Sort[StructureSort /@ multipleList];

	out = Catch[tt[single, multipleSorted]];

	If[MatchQ[out, True], True, False]
];
singleMeltToMultipleQ[_, _] := False;


tt[single: Structure[singleStrands: {_Strand..}, singleBonds: {_Bond...}], multiple_] /; !isTT[single, multiple] := tt[#, multiple] & /@ Table[Structure[singleStrands, Delete[singleBonds, i]], {i, 1, Length[singleBonds]}];
tt[single: Structure[singleStrands: {_Strand..}, singleBonds: {_Bond...}], multiple_] /; isTT[single, multiple] := Throw[True];
isTT[left_, right_] := MatchQ[StructureSort /@ SplitStructure[left], right];


(* ::Subsubsection:: *)
(*validDuplexExchangeQ*)


validDuplexExchangeQ[{struct_}, prods_] := Module[
	{bonds, namings},
	bonds = struct[Bonds];
	If[Length[bonds] < 3, Return[False]];

	namings = Flatten[findTrunk[#, bonds] & /@ bonds];

	AnyTrue[namings, validDuplexExchangeSingleQ[struct, #, prods] &]
];


validDuplexExchangeSingleQ[struct_, naming_, prods_] := Module[
	{namedStrands, splitted, trunkAndBranch, folded, zipped, paired, flag1, flag2},

	namedStrands = MapAt[ReplaceAll[#, (h: PolymerP)[x_, y___] :> h[x, "Trunk"]] &, struct[Strands], List /@ naming["Trunk"]];
	splitted = SplitStructure[Structure[namedStrands, DeleteCases[struct[Bonds], Alternatives @@ naming["Bonds"]]]];
	If[Length[splitted] != 3, Return[False]];

	trunkAndBranch = GroupBy[splitted, MatchQ[#, Structure[{Strand[PolymerP[_, "Trunk"]]..}, ___]] &];
	If[Length[trunkAndBranch[True]] != 1, Return[False]];

	folded = Append[FoldedStructures] /. ECL`SimulateFolding[First @ trunkAndBranch[True], Upload->False];
	zipped =  Select[folded, MatchQ[NucleicAcids`Private`classifyReactionCoreOneToOne[trunkAndBranch[True], {#}], Zipping] &];
	paired = ECL`Pairing[Sequence @@ trunkAndBranch[False], MinLevel -> 3];

	flag1 = AnyTrue[prods /. (h: PolymerP)[x_, y___] :> h[x], MemberQ[zipped /. (h: PolymerP)[x_, y___] :> h[x], #] &];
	flag2 = AnyTrue[prods, MemberQ[paired, #] &];

	flag1 && flag2
];


findTrunk[bd: Bond[{a_, a1_;;a2_}, {b_, b1_;;b2_}], bonds_] := Module[
	{leftCand, rightCand, naming},

	leftCand = Flatten[locateNeighbour[#, bonds] & /@ {{a, a1 - 1}, {b, b2 + 1}}];
	rightCand = Flatten[locateNeighbour[#, bonds] & /@ {{a, a2 + 1}, {b, b1 - 1}}];

	naming = {
		If[Length[leftCand] == 2, <|"Trunk" -> {a, b}, "Branch" -> DeleteCases[(First /@ # & /@ leftCand) /. Bond -> Sequence, a | b], "Bonds" -> leftCand|>, Nothing],
		If[Length[rightCand] == 2, <|"Trunk" -> {a, b}, "Branch" -> DeleteCases[(First /@ # & /@ rightCand) /. Bond -> Sequence, a | b], "Bonds" -> rightCand|>, Nothing]
	}
];


locateNeighbour[pos_, bonds_] := bondExistsQ[pos, #] & /@ bonds;
bondExistsQ[{sb_, bs_}, bd: Bond[{sb_, bs_;;a2_}, {b_, b1_;;b2_}]] := bd;
bondExistsQ[{sb_, bs_}, bd: Bond[{sb_, a1_;;bs_}, {b_, b1_;;b2_}]] := bd;
bondExistsQ[{sb_, bs_}, bd: Bond[{a_, a1_;;a2_}, {sb_, bs_;;b2_}]] := bd;
bondExistsQ[{sb_, bs_}, bd: Bond[{a_, a1_;;a2_}, {sb_, b1_;;bs_}]] := bd;
bondExistsQ[___] := Nothing;


(* ::Subsubsection::Closed:: *)
(*strandMapping and helpers*)


(* construct a feasible and determined 1-1 mapping for strands in reactants to strands in products *)
strandMapping[reactants_, products_] := Module[
	{beforeLabeled, afterLabeled, globalIndex, globalIndexReverse, beforeDict, beforeDictRev, afterDict, afterDictRev, strandRules, groupedByStrand, neighbourRules, distinctRules, equalRules, maxFreedom, allPossibleMappings, inversedMapping, oneSol, ambCase, finalMapping},

	(* turn off this message that silently gets thrown and breaks tests and the help notebook *)
	Off[Developer`LinearExpressionToMatrix::obs];

	(* label Strands with respect to the order they appear *)
	{beforeLabeled, afterLabeled} = Flatten /@ MapThread[tagStrand, {{reactants, products}, {"A", "B"}}];

	(* construct a dictionary to store information for each strand *)
	{globalIndex, globalIndexReverse} = With[{temp = MapIndexed[Head[#1] -> First[#2] &, Join @@ (First /@ beforeLabeled)]}, {temp, Reverse /@ temp}];
	{beforeDict, afterDict} = <|Join[structureDictionaryOne /@ #]|> & /@ {beforeLabeled, afterLabeled};
	{beforeDictRev, afterDictRev} = GroupBy[#, First] & /@ (Join @@ (First /@ #) & /@ {beforeLabeled, afterLabeled});

	(* determin stranding mapping with respect to unique strand and neighbour constraints *)
	{groupedByStrand, strandRules} = Cases[Map[uniqueStrandConstraint[beforeDictRev[#], afterDictRev[#], beforeDict, afterDict] &, Keys[beforeDictRev]], #] & /@ {Except[_Rule], _Rule};
	neighbourRules = DeleteDuplicates[Join @@ (neighbourConstraint[#, strandRules] & /@ groupedByStrand)];

	(* construct domain for each variable *)
	distinctRules = Unequal @@ Keys[afterDict];
	equalRules = DeleteDuplicates[Flatten[Join[Map[#[[1]] == #[[2]] &, neighbourRules], Or @@@ Outer[Equal, Head /@ afterDictRev[#], Head /@ beforeDictRev[#]] & /@ Keys[beforeDictRev]]]];

	(* solve for viable solution for each variable *)
	maxFreedom = Times @@ (Length /@ beforeDictRev);
	allPossibleMappings = FindInstance[And @@ Append[equalRules, distinctRules] /. globalIndex, Keys[afterDict], Integers, maxFreedom];
	If[MatchQ[allPossibleMappings, {}], Return[{{Null, Null}, $Failed}]];

	(* resolve multiple solution case *)
	inversedMapping = Normal[GroupBy[(#[[1, 1]] -> Sort[DeleteDuplicates[Last /@ #]]) & /@ Transpose[allPossibleMappings], Last, Map[First, #] &]];
	While[!MatchQ[inversedMapping, {Rule[{_}, {_}]..}],
		ambCase = First[Cases[inversedMapping, Except[Rule[{_}, {_}]]]];
		oneSol = resolveMultipleSolution[ambCase, globalIndexReverse, beforeDict];
		If[MatchQ[oneSol, $Failed], Return[{{Null, Null}, $Failed}]];
		inversedMapping = Flatten[inversedMapping /. ambCase -> oneSol]
	];
	finalMapping = (inversedMapping /. Rule[{x_}, {y_}] :> Rule[y, x]) /. globalIndexReverse;

	(* turn back on the evil message *)
	On[Developer`LinearExpressionToMatrix::obs];

	{{beforeDict, afterDict}, finalMapping}
];


(* label Strands with respect to the order they appear *)
tagStrand[structureList_, symbol_String] := Module[
	{strands, labeledStrands, labeledBonds},

	strands = #[Strands] & /@ structureList;
	labeledStrands = MapIndexed[ToExpression[symbol <> ToString[#2[[1]]] <> ToLowerCase[symbol] <> ToString[#2[[2]]]][#1] &, strands, {2}];
	labeledBonds = MapIndexed[ReplaceAll[#1[Bonds], Bond[{x1_, y1_}, {x2_, y2_}] :> Bond[{ToExpression[symbol <> ToString[#2[[1]]] <> ToLowerCase[symbol] <> ToString[x1]], y1}, {ToExpression[symbol <> ToString[#2[[1]]] <> ToLowerCase[symbol] <> ToString[x2]], y2}]] &, structureList];
	MapThread[Structure[#1, #2] &, {labeledStrands, labeledBonds}]
];


(* construct a Dictionary of key: strand, value: involving bonds *)
structureDictionaryOne[oneStructure_] := Module[
	{strands, bonds},

	strands = First[oneStructure];
	bonds = Last[oneStructure];
	Head[#] -> {Head[#], First[#], Cases[bonds, Bond[{Head[#], _}, {_, _}] | Bond[{_, _}, {Head[#], _}]]} & /@ strands
];


uniqueStrandConstraint[{before_}, {after_}, beforeDict_, afterDict_] := Head[after] -> Head[before];
uniqueStrandConstraint[before: {__}, after: {__}, beforeDict_, afterDict_] := {beforeDict[Head[#]] & /@ before, afterDict[Head[#]] & /@ after};


neighbourConstraint[{before_, after_}, {}] := {};
neighbourConstraint[{before_, after_}, strandConstraint_] := Module[
	{counter, rulesOut, ruleTemp},

	rulesOut = strandConstraint;
	counter = 1;
	While[counter <= Length[rulesOut],
		ruleTemp = Flatten[neighbourOne[#, rulesOut[[counter]], Flatten[Last /@ before]] & /@ after];
		rulesOut = DeleteDuplicates[Join[rulesOut, ruleTemp]];
		If[!MatchQ[Length[rulesOut], Length[DeleteDuplicatesBy[rulesOut, First]]], Return[$Failed]];
		counter++
	];
	rulesOut
];


(* try to find mapping for one strand if it has a already identified neighbour *)
neighbourOne[afterOne_, ruleOne_, before_] := Module[
	{bonds, candidateBonds, bondPatternTest},

	bonds = Last[afterOne];
	candidateBonds = Cases[bonds, Bond[{First[ruleOne], _}, {_, _}] | Bond[{_, _}, {First[ruleOne], _}]] /. ruleOne;

	If[MatchQ[candidateBonds, {}], Return[{}]];

	bondPatternTest[a: Bond[{a11_, a12_}, {a21_, a22_}], b: Bond[{b11_, b12_}, {b21_, b22_}]] := Switch[a,
		Bond[{b11, b12}, {_, b22}], a21 -> b21,
		Bond[{_, b12}, {b21, b22}], a11 -> b11,
		_, Nothing
	];
	Map[Function[{beforeOne}, bondPatternTest[#, beforeOne]], before] & /@ candidateBonds
];


resolveMultipleSolution[Rule[key_, value_], indexReverse_, beforeDict_] := Module[
	{beforeStrandSymbols},

	If[!MatchQ[Length[key], Length[value]], Return[$Failed]];

	beforeStrandSymbols = key /. indexReverse;
	If[AllTrue[beforeDict[#] & /@ beforeStrandSymbols[[2;;]], SameQ[Rest[#], Rest[beforeDict[beforeStrandSymbols[[1]]]]] &], MapThread[{#1} -> {#2} &, {key, value}], Message[ClassifyReaction::AmbiguiousStructureChange]; Return[$Failed]]
];


(* ::Subsubsection::Closed:: *)
(*bondChange*)


bondChange[before_, after_, rules_, rulesReverse_] := Module[
	{strandInfo, beforeBonds, afterBonds},

	strandInfo = {before[[2]], First[before], First[after]};
	{beforeBonds, afterBonds} = Last /@ {before, after};

	{strandInfo, Complement[beforeBonds, afterBonds /. rules], Complement[afterBonds, beforeBonds /. rulesReverse]}
];


(* ::Subsubsection::Closed:: *)
(*isInvasion and isExchange*)


isInvasion[bondChanges_] /; Length[bondChanges] == 3 := Module[
	{types, sharedStrand, invadee, invader},
	types = strandInvasionType /@ bondChanges;
	If[MemberQ[types, $Failed], Return[0]];

	{sharedStrand, invadee, invader} = SortBy[types, First];

	If[sharedStrandUnchanged[sharedStrand], 1, 0]

];
isInvasion[bondChanges_] /; Length[bondChanges] == 4 := Module[
	{types},
	types = strandInvasionType /@ bondChanges;
	If[MemberQ[types, $Failed], Return[0]];

	If[AllTrue[types, sharedStrandUnchanged], 2, 0]
];
isInvasion[_] := 0;


strandInvasionType[{{strand_, beforeLabel_, afterLabel_}, {bond1_Bond}, {bond2_Bond}}] := {0, beforeLabel -> afterLabel, {bond1, bond2}};
strandInvasionType[{{strand_, beforeLabel_, afterLabel_}, {bond_Bond}, {}}] := {1, beforeLabel -> afterLabel, bond};
strandInvasionType[{{strand_, beforeLabel_, afterLabel_}, {}, {bond_Bond}}] := {2, beforeLabel -> afterLabel, bond};
strandInvasionType[_] := $Failed;


sharedStrandUnchanged[{0, Rule[labelBefore_, labelAfter_], {bondBefore_, bondAfter_}}] := Module[
	{spanBefore, spanAfter},
	spanBefore = Cases[bondBefore, {labelBefore, span_} -> span];
	spanAfter = Cases[bondAfter, {labelAfter, span_} -> span];
	SameQ[spanBefore, spanAfter]
];
sharedStrandUnchanged[___] := False;


isExchange[beforeBonds_, afterBonds_] := Module[
	{beforeTrunk, afterTrunk, trunk, beforeBranch, afterBranch},

	beforeTrunk = Keys[Select[Counts[First /@ (beforeBonds /. Bond -> Sequence)], # == 2 &]];
	afterTrunk = Keys[Select[Counts[First /@ (afterBonds /. Bond -> Sequence)], # == 2 &]];
	If[beforeTrunk != afterTrunk, Return[False]];
	If[Length[beforeTrunk] != 1, Return[False]];

	trunk = First[beforeTrunk];

	beforeBranch = Cases[beforeBonds /. Bond -> Sequence, Except[{trunk, ___}]];
	afterBranch = Cases[afterBonds /. Bond -> Sequence, Except[{trunk, ___}]];

	MatchQ[beforeBranch, afterBranch | Reverse @ afterBranch]
];


(* ::Subsubsection::Closed:: *)
(*isToe and isToeComp*)


isToe[{{strand_, beforeIndex_, afterIndex_}, {}, _}, rule_] := {False, {False, False}};
isToe[{{strand_, beforeIndex_, afterIndex_}, _, {}}, rule_] := {False, {False, False}};
isToe[{{strand_, beforeIndex_, afterIndex_}, {beforeBond_}, {afterBond_}}, rule_] := Module[
	{beforeRange, afterRange, leftFlag, rightFlag},

	If[MatchQ[Cases[beforeBond, Except[{beforeIndex, _}]][[1, 1]], Cases[afterBond, Except[{afterIndex, _}]][[1, 1]] /. rule], Return[$Failed]];

	beforeRange = Cases[beforeBond, {beforeIndex, _}][[1, 2]];
	afterRange = Cases[afterBond, {afterIndex, _}][[1, 2]];

	leftFlag = If[SubsetQ[Range @@ afterRange, {First[beforeRange] - 1, First[beforeRange]}], True, False];
	rightFlag = If[SubsetQ[Range @@ afterRange, {Last[beforeRange], Last[beforeRange] + 1}], True, False];

	{Or[leftFlag, rightFlag], {leftFlag, rightFlag}}
];


isToeComp[{{{strand1_, beforeIndex1_, afterIndex1_}, {beforeBond1_}, {afterBond1_}}, {{strand2_, beforeIndex2_, afterIndex2_}, {beforeBond2_}, {afterBond2_}}}, rule_] := If[
	And[
		MatchQ[Cases[afterBond1, Except[{afterIndex1, _}]][[1, 1]] /. rule, beforeIndex2],
		MatchQ[Cases[afterBond2, Except[{afterIndex2, _}]][[1, 1]] /. rule, beforeIndex1],
		With[{beforeRange1 = Cases[beforeBond1, {beforeIndex1, _}][[1, 2]], afterRange1 = Cases[afterBond1, {afterIndex1, _}][[1, 2]]}, Or[MemberQ[Range @@ afterRange1, First[beforeRange1]], MemberQ[Range @@ afterRange1, Last[beforeRange1]]]],
		With[{beforeRange2 = Cases[beforeBond2, {beforeIndex2, _}][[1, 2]], afterRange2 = Cases[afterBond2, {afterIndex2, _}][[1, 2]]}, Or[MemberQ[Range @@ afterRange2, First[beforeRange2]], MemberQ[Range @@ afterRange2, Last[beforeRange2]]]]
	],
	Unknown,
	Unknown
];


isDual[bondStatus_] := Module[
	{beforeGroup, afterGroup},
	beforeGroup = Map[First /@ # &, GroupBy[bondStatus, #[[2, 2]] &]];
	afterGroup = Map[First /@ # &, GroupBy[bondStatus, #[[2, 3]] &]];
	If[And @@ (isDualOnStructure /@ (Join @@ (Values /@ {beforeGroup, afterGroup}))), DualToeholdMediatedDuplexExchange, Unknown]
];
isDualOnStructure[{{True, _}, {_, True}}] := True;
isDualOnStructure[{{_, True}, {True, _}}] := True;
isDualOnStructure[_] := False;


(* ::Subsubsection::Closed:: *)
(*bondContinuationQ*)


(*
	Check if the 'after' bonds are continuations of the 'before' bonds,
	which would make the reaction Zipping or Unzipping.
	Every 'before' bond must go to an 'after' bond, and evey 'after' bond must be used
*)
bondContinuationQ[beforeBonds_List,afterBonds_List]:=Module[{checkMatrix},
	checkMatrix = Table[
		Table[
			bondContinuationQ[{bef,aft}],
			{aft,afterBonds}
		],
		{bef,beforeBonds}
	];
	MatrixRank[Boole[checkMatrix]]==Min[Length[beforeBonds],Length[afterBonds]]
];

(* Zipping to the rigth *)
bondContinuationQ[{
		before:Bond[{s1_,Span[b1_,c1_]},{s2_,Span[b2_,c2_]}],
		after:Bond[{s1_,Span[b1_,cx_]},{s2_,Span[bx_,c2_]}]
	}]/;And[cx>c1,bx<b2] := True;

(* Zipping to the left *)
bondContinuationQ[{
		before:Bond[{s1_,Span[b1_,c1_]},{s2_,Span[b2_,c2_]}],
		after:Bond[{s1_,Span[bx_,c1_]},{s2_,Span[b2_,cx_]}]
	}]/;And[b1>bx,c2<cx] := True;

(* Zipping both sides *)
bondContinuationQ[{
		before:Bond[{s1_,Span[b1_,c1_]},{s2_,Span[b2_,c2_]}],
		after:Bond[{s1_,Span[bx_,cy_]},{s2_,Span[by_,cx_]}]
	}]/;And[b1>bx,c2<cx,c1<cy,b2>by] := True;

(* else *)
bondContinuationQ[{before_Bond,after_Bond}]:=False;
