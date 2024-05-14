(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(**)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Formats*)


(* ::Subsubsection:: *)
(*Patterns*)


RuleListFormatP={Rule[_,_?NumberQ|_Quantity]...};
pairedListFormatP={{_,_}...};
StateFormatP=State[{_,_}...];
speciesListP={Except[_Rule]...};


(* ::Subsubsection:: *)
(*StateQ*)


StateQ[State[{ReactionSpeciesP,_?NumericQ|_?ConcentrationQ}...]]:=True;
StateQ[State[{ReactionSpeciesP}...]]:=True;
StateQ[___]:=False;


(* ::Subsection:: *)
(*State*)


State[ruleList:RuleListFormatP]:=State@@List@@@ruleList;
State[ruleSequence:(Rule[_,_?NumberQ|_Quantity]..)]:=State[{ruleSequence}];


(* ::Subsection::Closed:: *)
(*Parsing*)


(* ::Subsubsection::Closed:: *)
(*stateToQuantities*)


stateToQuantities[st:StateFormatP]:=List@@st[[;;,2]];


(* ::Subsubsection::Closed:: *)
(*stateToUnits*)

Authors[stateToQuantities]:={"scicomp", "brad"};
stateToUnits[st:StateFormatP]:=Quantity/@QuantityUnit[stateToQuantities[st]];


(* ::Subsubsection::Closed:: *)
(*stateToMagnitudes*)


stateToMagnitudes[st:StateFormatP]:=QuantityMagnitude[stateToQuantities[st]];


stateToMagnitudes[st:StateFormatP,targetUnit_]:=Unitless[stateToQuantities[st],targetUnit];


(* ::Subsubsection::Closed:: *)
(*stateUnit*)


stateUnit[st:StateFormatP]:=With[{uns=stateToUnits[st]},Max[Abs[uns]]];


(* ::Subsubsection::Closed:: *)
(*stateToSpecies*)

Authors[stateToSpecies]:={"scicomp", "brad"};
stateToSpecies[st:StateFormatP]:=List@@st[[;;,1]];


(* ::Subsubsection::Closed:: *)
(*rulesToSpecies*)


rulesToSpecies[st:RuleListFormatP]:=st[[;;,1]];


(* ::Subsubsection::Closed:: *)
(*pairedToSpecies*)


pairedToSpecies[st:pairedListFormatP]:=st[[;;,1]];


(* ::Subsection:: *)
(*Transforming*)


(* ::Subsubsection:: *)
(*rulesToState*)

Authors[rulesToState]:={"scicomp", "brad"};

rulesToState[ruleList:RuleListFormatP]:=State@@List@@@ruleList;
rulesToState[partialRuleList:RuleListFormatP,specList:speciesListP]:=
	rulesToState[partialRuleList,specList,0.];
rulesToState[partialRuleList:RuleListFormatP,specList:speciesListP,defaultVal_]:=
	State@@Transpose[{specList,Replace[specList,Append[partialRuleList,_->defaultVal],{1}]}];


(* ::Subsubsection:: *)
(*pairedToState*)

Authors[pairedToState]:={"scicomp", "brad"};

pairedToState[pairedList:pairedListFormatP]:=State@@pairedList;
pairedToState[partialPairedList:pairedListFormatP,specList:speciesListP]:=
	pairedToState[partialPairedList,specList,0.];
pairedToState[partialPairedList:pairedListFormatP,specList:speciesListP,defaultVal_]:=
	rulesToState[Rule@@@partialPairedList,specList,defaultVal];


(* ::Subsubsection::Closed:: *)
(*stateToRules*)
Authors[stateToRules]:={"scicomp", "brad"};


stateToRules[st:StateFormatP]:=Rule@@@(List@@st);


(* ::Subsubsection::Closed:: *)
(*stateToPaired*)

Authors[stateToPaired]:={"scicomp", "brad"};

stateToPaired[st:StateFormatP]:=List@@st;



(* ::Subsection::Closed:: *)
(*Manipulation*)


(* ::Subsubsection::Closed:: *)
(*addUnitToState*)


addUnitToState[st:StateFormatP,Null]:=st;
addUnitToState[st:StateFormatP,un_]:=MapAt[#*un&,st,{;;,2}];



(* ::Subsubsection::Closed:: *)
(*addDefaultsToState*)


addDefaultsToState[st:StateFormatP,specs_List,default_]:=rulesToState[addDefaultsToRules[stateToRules[st],specs,default]];


addRulesToRules[ruleList1:RuleListFormatP,ruleList2:RuleListFormatP]:=GatherBy[Join[ruleList1,ruleList2],First][[;;,1]];
addDefaultsToRules[ruleList:RuleListFormatP,specs_List,default_]:=Rule@@@Transpose[{specs,Replace[specs,Append[ruleList,_->default],{1}]}];


(* ::Subsubsection::Closed:: *)
(*StateFirst*)


StateFirst[in_]:=First[in];


(* ::Subsubsection::Closed:: *)
(*StateLast*)


StateLast[in_]:=Last[in];


(* ::Subsubsection::Closed:: *)
(*StateMost*)


StateMost[in_]:=Most[in];


(* ::Subsubsection::Closed:: *)
(*StateRest*)


StateRest[in_]:=Rest[in];


(* ::Subsection:: *)
(*SubValues*)


OnLoad[
Unprotect[State];
State /: Keys[State] := {Species,Quantities,Magnitudes,"Unit",Units,Rules,Paired};
State /: Keys[_State] := Keys[State];
(st:StateFormatP)["Properties"|Properties]:=Keys[State];
(st:StateFormatP)["Species"|Species]:=stateToSpecies[st];
(st:StateFormatP)["Quantities"|Quantities]:=stateToQuantities[st];
(st:StateFormatP)["Magnitudes"|Magnitudes]:=stateToMagnitudes[st];
(st:StateFormatP)["Units"|Units]:=stateToUnits[st];
(st:StateFormatP)["Unit"]:=stateUnit[st];
(st:StateFormatP)["Rules"|Rules]:=stateToRules[st];
(st:StateFormatP)["Paired"|Paired]:=stateToPaired[st];
(* lookup specific species concentration *)
(st:StateFormatP)[spec:SpeciesP]:=Lookup[stateToRules[st],spec];
(st:StateFormatP)[specs:{SpeciesP..}]:=Lookup[stateToRules[st],specs];
];



(* ::Subsection::Closed:: *)
(*Summary Blob*)


(* ::Subsubsection::Closed:: *)
(*Icon*)


stateIcon[]:=stateIcon[]=Module[{},
	Row[{Graphics[{{ColorData[97][1],Disk[{0,0},1,{0,1.7Pi/3}]},{ColorData[97][2],Disk[{0,0},1,{1.7Pi/3,4Pi/3}]},{ColorData[97][3],Disk[{0,0},1,{4Pi/3,2Pi}]}},ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]}],"[\[Mu]M]"}]
];



(* ::Subsubsection::Closed:: *)
(*MakeStateBoxes*)


MakeStateBoxes[]:=Module[{},
	MakeBoxes[summary:State[{_,_}...], StandardForm] := BoxForm`ArrangeSummaryBox[
	    State,
	    summary,
	    stateIcon[],
	    {
				BoxForm`SummaryItem[{"Num species: ", Length[summary]}]
			},
	    {
		    ECL`PlotTable[summary[Paired], TableHeadings -> {None, {"Species", UnitDimension[summary["Unit"]]}},Alignment -> {Center, Center}]
		},
	    StandardForm
	]
];