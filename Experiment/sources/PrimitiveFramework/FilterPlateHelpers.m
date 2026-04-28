(* ::Package:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Filter Plate Helpers*)

(* Shared helpers for building filter plate to holder plate relationships.
   Used by the RSP compiler (compileHamiltonWorkCell) and the qualification
   compiler (compileQualificationVerifyHamiltonLabware). *)


(* ::Subsubsection:: *)
(*buildFilterPlateStacks*)

(* Given a list of {filterPlate, holderPlate} pairs (links or objects), *)
(* return a list of rules filterPlateObject -> holderPlateObject. *)
buildFilterPlateStacks[filterPlatePlacements_List] := If[MatchQ[filterPlatePlacements, {__List}],
	Map[
		Rule[Download[#[[1]], Object], Download[#[[2]], Object]]&,
		filterPlatePlacements
	],
	{}
];


(* ::Subsubsection:: *)
(*buildFilterPlateDeckPlacements*)

(* Given filterPlateStacks (filter -> holder rules) and holderPlacements ({Link[holder], deckPosition} tuples), *)
(* return deck placements for filter plates at the same deck positions as their corresponding holders. *)
(* This allows hamiltonLabwarePositionNew to resolve filter plate positions for lid/cover operations. *)
buildFilterPlateDeckPlacements[filterPlateStacks_List, holderPlacements_List] := If[Length[filterPlateStacks] > 0,
	Map[
		Function[filterToHolder,
			Module[{holderPlacement},
				holderPlacement = SelectFirst[holderPlacements, MatchQ[Download[#[[1]], Object], filterToHolder[[2]]]&];
				{Link[filterToHolder[[1]]], holderPlacement[[2]]}
			]
		],
		filterPlateStacks
	],
	{}
];
