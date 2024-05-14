

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Loading Matrices*)


(* ::Subsubsection::Closed:: *)
(*loadInitialConditions*)


loadInitialConditions::usage="
DEFINITIONS
	loadInitialConditions[speciesList_List,initialConditions:{_Rule..}]
		Substitute the initial conditions into the species list, and set any non-specified species to zero.

INPUTS
	SpeciesList       - {(_Symbol|_String|_Structure|_Strand)..}
	initialConditions - {_Rule..}

OUTPUTS
	_List

EXAMPLEs
	loadInitialConditions[{a,b,c,d},{b\[Rule]1,c\[Rule]2}]

AUTHORS
	Brad
";
Authors[loadInitialConditions]:={"scicomp", "brad"};
loadInitialConditions[a_List, x0:{_?NumericQ..}] := x0;
loadInitialConditions[specs:{ReactionSpeciesP..}, x0:{_?NumericQ..}] := x0;
loadInitialConditions[reactions:{ImplicitReactionP..}, initial_] :=
	loadInitialConditions[SpeciesList[reactions,Sort->False], initial];
loadInitialConditions[reactions:{(_Rule|_Equilibrium)..}, initial_] :=
	loadInitialConditions[SpeciesList[reactions,Sort->False], initial];

loadInitialConditions[species:{ReactionSpeciesP..}, initial0:{Rule[ReactionSpeciesP, _?NumericQ|_?ConcentrationQ] ..}] :=
     Module[ {initial},
  		initial=If[Complement[initial0[[;; , 1]], species] =!= {},
				Message[loadInitialConditions::badic,Complement[initial0[[;; , 1]], species]];
   			Select[initial0,MemberQ[species,First[#]]&],
				initial0];
		species/.Dispatch[Join[unUnit[initial,Molar],Map[#->0&,Complement[species,initial[[;;,1]]]]]]
      ];



(* ::Subsubsection::Closed:: *)
(*degradationReactions*)


(* move to mechanism or sequenceAnalysis *)
degradationReactions[species_, numBreakPlaces_: 1, numProducts_: 2] :=
     Flatten[Table[Map[
        Rule[#, Total[Table [ Symbol[ToString[#] <> "$" <> ToString[i] <> "$waste$" <> ToString[j]], {j, 1, numProducts}]]] &, species],
       {i, 1, numBreakPlaces}]]


(* ::Section::Closed:: *)
(*End*)