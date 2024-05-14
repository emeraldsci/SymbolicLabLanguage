(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Formats*)


(* ::Subsubsection:: *)
(*Formats*)


ImplicitReactionsFormatP={implicitReactionFormatP...};
reactionsFormatP={reactionFormatP...};
MechanismFormatP=ReactionMechanism[reactionFormatP...];
interactionsFormatP = {interactionFormatP ...};



(* ::Subsubsection:: *)
(*ReactionMechanismQ*)


ReactionMechanismQ[ReactionMechanismP]:=True;
ReactionMechanismQ[_]:=False;



(* ::Subsection::Closed:: *)
(*Parsing*)


(* ::Subsubsection::Closed:: *)
(*reactionsToSpecies*)


reactionsToSpecies[rxs:reactionsFormatP]:=DeleteDuplicates[Flatten[Map[reactionToSpecies,rxs]]];


(* ::Subsubsection::Closed:: *)
(*implicitReactionsToSpecies*)


implicitReactionsToSpecies[reacs:ImplicitReactionsFormatP]:=reactionsToSpecies[implicitReactionsToReactions[reacs]];


(* ::Subsubsection::Closed:: *)
(*mechanismToSpecies*)


mechanismToSpecies[mech:MechanismFormatP]:=reactionsToSpecies[mechanismToReactions[mech]];


(* ::Subsubsection::Closed:: *)
(*interactionToSpecies*)


interactionToSpecies[interactions:interactionsFormatP]:=DeleteDuplicates[Flatten[Map[interactionToSpecies,interactions]]];


(* ::Subsubsection:: *)
(*mechanismToRates*)


mechanismToRates[mech:MechanismFormatP]:=Map[implicitReactionToRates,mechanismToImplicitReactions[mech]];



(* ::Subsection:: *)
(*Transforming*)


(* ::Subsubsection:: *)
(*reactionsToImplicitReactions*)


reactionsToImplicitReactions[rxs:reactionsFormatP]:=reactionToImplicitReaction/@rxs;


(* ::Subsubsection::Closed:: *)
(*implicitReactionsToReactions*)


implicitReactionsToReactions[reacs:ImplicitReactionsFormatP]:=implicitReactionToReaction/@reacs;


(* ::Subsubsection:: *)
(*reactionsToMechanism*)


reactionsToMechanism[rxs:reactionsFormatP]:=ReactionMechanism@@rxs;


(* ::Subsubsection::Closed:: *)
(*implicitReactionsToMechanism*)


implicitReactionsToMechanism[reacs:ImplicitReactionsFormatP]:=reactionsToMechanism[implicitReactionsToReactions[reacs]];


(* ::Subsubsection::Closed:: *)
(*implicitReactionsToInteractions*)


implicitReactionsToInteractions[reacs:ImplicitReactionsFormatP]:=reacs[[;;,1]];


(* ::Subsubsection::Closed:: *)
(*mechanismToReactions*)


mechanismToReactions[mech:MechanismFormatP]:=
	List@@mech;


(* ::Subsubsection::Closed:: *)
(*mechanismToImplicitReactions*)


mechanismToImplicitReactions[mech:MechanismFormatP]:=
	reactionsToImplicitReactions[List@@mech];



(* ::Subsubsection:: *)
(*mechanismToReactants*)


mechanismToReactants[mech:ReactionMechanismP]:=
	Map[reactionToReactants,mechanismToReactions[mech]];


(* ::Subsubsection:: *)
(*mechanismToProducts*)


mechanismToProducts[mech:ReactionMechanismP]:=
	Map[reactionToProducts,mechanismToReactions[mech]];


(* ::Subsubsection:: *)
(*MechansimToIntermediates*)


mechanismToIntermediates[mech:ReactionMechanismP]:=
	Intersection[Flatten[mechanismToReactants[mech]],Flatten[mechanismToProducts[mech]]];


(* ::Subsection:: *)
(*Manipulation*)


(* ::Subsubsection::Closed:: *)
(*splitReactions*)


splitReactions[rxs:reactionsFormatP]:=Map[splitReaction,rxs];


splitReactions[mech:MechanismFormatP]:=Map[splitReaction,mech];


(* ::Subsubsection::Closed:: *)
(*addSymbolicRatesToReactions*)


(*addSymbolicRatesToReactions[reactions:({interactionsFormatP..}|ImplicitReactionsFormatP)]:=MapIndexed[addSymbolicRatesToReaction[#1,First[#2]]&,reactions]*)
addSymbolicRatesToReactions[reactions_]:=MapIndexed[addSymbolicRatesToReaction[#1,First[#2]]&,reactions];



(* ::Subsubsection:: *)
(*toFullImplicitReactions*)

Authors[toFullImplicitReactions]:={"scicomp", "brad"};

toFullImplicitReactions[in:(irreversibleImplicitReactionFormatP|reversibleImplicitReactionFormatP|_Rule|_Equilibrium|{_Rule}|{_Equilibrium})]:=toFullImplicitReactions[{in}];


toFullImplicitReactions[in:{(irreversibleImplicitReactionFormatP|reversibleImplicitReactionFormatP|_Rule|_Equilibrium|{_Rule}|{_Equilibrium})..}]:=addSymbolicRatesToReactions[toFullImplicitReaction/@in];
toFullImplicitReactions[mech_ReactionMechanism]:=toFullImplicitReactions[mechanismToImplicitReactions[mech]];


(* ::Subsubsection:: *)
(*MechanismJoin*)


MechanismJoin[mech1:ReactionMechanismP,mech2:ReactionMechanismP,mechRest__ReactionMechanism]:=Fold[MechanismJoin[#1,#2]&,mech1,{mech2,mechRest}];
MechanismJoin[mech1:ReactionMechanismP,mech2:ReactionMechanismP]:=
ReactionMechanism@@DeleteDuplicates[List@@Join[
	splitReactions[mech1/.{comp_Structure:>adjustMotifPairs[reformatBonds[Quiet[StructureSort@comp],StrandMotifBase]]}],
	splitReactions[mech2/.{comp_Structure:>adjustMotifPairs[reformatBonds[Quiet[StructureSort@comp],StrandMotifBase]]}]],
	SameQ[{Sort[#1[[1]]],Sort[#1[[2]]],#1[[3;;]]},{Sort[#2[[1]]],Sort[#2[[2]]],#2[[3;;]]}]&];


(* ::Subsubsection:: *)
(*MechanismFirst*)


MechanismFirst[mech:ReactionMechanismP]:=First[mech];


(* ::Subsubsection:: *)
(*MechanismLast*)


MechanismLast[mech:ReactionMechanismP]:=Last[mech];


(* ::Subsubsection:: *)
(*MechanismMost*)


MechanismMost[mech:ReactionMechanismP]:=Most[mech];


(* ::Subsubsection:: *)
(*MechanismRest*)


MechanismRest[mech:ReactionMechanismP]:=Rest[mech];


(* ::Subsection:: *)
(*ReactionMechanism*)


(* ::Subsubsection:: *)
(*ReactionMechanism*)


ReactionMechanism[{in:((_Reaction|ImplicitReactionP)...)}]:=ReactionMechanism[in];
ReactionMechanism[in:((_Reaction|ImplicitReactionP)...)]/;MemberQ[{in},Except[_Reaction]]:=Module[{out},
	out = Map[oneReactionToReaction[#]&,{in}];
	ReactionMechanism@@out
];


oneReactionToReaction[r_Reaction]:=r;
oneReactionToReaction[r_List]:=implicitReactionToReaction[r];


(* ::Subsubsection:: *)
(*SubValues*)


OnLoad[
Unprotect[ReactionMechanism];
ReactionMechanism /: Keys[ReactionMechanism] := {Species,Reactions,Reactants,Products,Intermediates,Rates};
ReactionMechanism /: Keys[_ReactionMechanism] := Keys[ReactionMechanism];
(mech:MechanismFormatP)["Properties"|Properties]:=Keys[ReactionMechanism];
(mech:MechanismFormatP)["Species"|Species]:=mechanismToSpecies[mech];
(mech:MechanismFormatP)["Reaction"|"Reactions"|Reactions]:=mechanismToReactions[mech];
(mech:MechanismFormatP)["Reactants"|Reactants]:=mechanismToReactants[mech];
(mech:MechanismFormatP)["Products"|Products]:=mechanismToProducts[mech];
(mech:MechanismFormatP)["Rates"|Rates]:=mechanismToRates[mech];
(*(mech:MechanismFormatP)["Interactions"|Interactions]:=mechanismToImplicitReactions[mech][[;;,1]];*)
(mech:MechanismFormatP)["Intermediates"|Intermediates]:=mechanismToIntermediates[mech];
];



(* ::Subsection:: *)
(*Summary Blob*)


(* ::Subsubsection:: *)
(*Icon*)


mechanismIcon[]:=mechanismIcon[]=Module[{},
	Graphics[{Text["a +b \[Equilibrium] c\n    c \[Rule] d"]},ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]},Background->GrayLevel[0.95`]]
];


(* ::Subsubsection:: *)
(*MakeMechanismBoxes*)


MakeMechanismBoxes[]:=Module[{},
	MakeBoxes[summary:ReactionMechanism[Reaction[_List,_List,___]...], StandardForm] := BoxForm`ArrangeSummaryBox[
	    ReactionMechanism,
	    summary,
	    mechanismIcon[],
	    {
				BoxForm`SummaryItem[{"Num Reactions: ", Length[summary]}],
				BoxForm`SummaryItem[{"Num species: ", Length[SpeciesList[summary]]}]
			},
	    {
		},
	    StandardForm
	]
];



