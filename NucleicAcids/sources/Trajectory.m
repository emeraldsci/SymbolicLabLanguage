(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Formats*)


(* ::Subsubsection:: *)
(*TrajectoryFormatP*)


TrajectoryFormatP=Trajectory[_List,_List,_List,_List];


(* ::Subsection:: *)
(*Parsing*)


(* ::Subsubsection:: *)
(*trajectoryToSpecies*)


trajectoryToSpecies[Trajectory[specs_List,_List,_List,_List]]:=specs;


(* ::Subsubsection:: *)
(*trajectoryToConcentrations*)


trajectoryToConcentrations[Trajectory[_List,concs_List,_List,_List]]:=concs;


(* ::Subsubsection:: *)
(*trajectoryToTimes*)


trajectoryToTimes[Trajectory[specs_List,_List,ts_List,_List]]:=ts;


(* ::Subsubsection:: *)
(*trajectoryToUnits*)


trajectoryToUnits[Trajectory[_List,_List,_List,uns_List]]:=uns;


(* ::Subsubsection:: *)
(*trajectoryToXUnit*)


trajectoryToXUnit[Trajectory[_List,_List,_List,{xunit_,_}]]:=xunit;


(* ::Subsubsection:: *)
(*trajectoryToYUnit*)


trajectoryToYUnit[Trajectory[_List,_List,_List,{_,yunit_}]]:=yunit;




(* ::Subsubsection:: *)
(*trajectoryToConcentration*)


trajectoryToConcentration[tr_Trajectory]:=tr[[2]];


(* ::Subsection:: *)
(*Manipulations*)


(* ::Subsubsection::Closed:: *)
(*trajectoryToXY*)


trajectoryToXY[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],subspecs_List]:=With[
	{posList = Map[trajectorySpeciesPosition[tr,#]&,subspecs]},
	Map[Transpose[{ts,concs[[;;,#]]}]&,posList]
];
trajectoryToXY[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],subspec_]:=With[
	{pos = trajectorySpeciesPosition[tr,subspec]},
	Transpose[{ts,concs[[;;,pos]]}]
];
trajectoryToXY[tr:Trajectory[specs_List,_List,_List,_List]]:=trajectoryToXY[tr,specs];



(* ::Subsection:: *)
(*SubValues*)


(*
	TODO: consolide down the duplicated plurals (Time,Times and Concentration,Concentrations)
*)
OnLoad[
Trajectory /: Keys[Trajectory] := {Species,Concentrations,Concentration,Coordinates,Times,Time,Units,XUnit,YUnit};
Trajectory /: Keys[tr_Trajectory] := Keys[Trajectory];
(tr:TrajectoryFormatP)["Properties"]:=Keys[Trajectory];
(tr:TrajectoryFormatP)["Species"|Species]:=trajectoryToSpecies[tr];
(tr:TrajectoryFormatP)["Coordinates"|Coordinates]:=trajectoryToXY[tr];
(tr:TrajectoryFormatP)["Concentrations"|"Concentration"|Concentration|Concentrations]:=trajectoryToConcentrations[tr];
(tr:TrajectoryFormatP)["Times"|"Time"|Times|Time]:=trajectoryToTimes[tr];
(tr:TrajectoryFormatP)["Units"|Units]:=trajectoryToUnits[tr];
(tr:TrajectoryFormatP)["XUnit"|XUnit]:=trajectoryToXUnit[tr];
(tr:TrajectoryFormatP)["YUnit"|YUnit]:=trajectoryToYUnit[tr];
(tr:TrajectoryFormatP)[specs:{SpeciesP..}]:=QuantityArray[TrajectoryRegression[tr,specs,Output->{Time,Concentration}],trajectoryToUnits[tr]];
(tr:TrajectoryFormatP)[spec:SpeciesP]:=QuantityArray[TrajectoryRegression[tr,spec,Output->{Time,Concentration}],trajectoryToUnits[tr]];
(tr:TrajectoryFormatP)[spec:SpeciesP,t:TimeP]:=With[{un=trajectoryToYUnit[tr]},Quantity[TrajectoryRegression[tr,spec,t],un]];
(tr:TrajectoryFormatP)[t:TimeP]:=TrajectoryRegression[tr,t];
];



(* ::Subsection:: *)
(*Summary Blob*)


(* ::Subsubsection:: *)
(*Icon*)


(*
	Image is plot of data points samples from this simulation:
	sim = SimulateKinetics[{{a+b->c,15}},{a->1,b->0.7},1,Inform\[Rule]False];
	xys=TrajectoryRegression[sim,Range[0,1,0.1],Output->{Time,Concentration}];
	Graphics[
		MapIndexed[{ColorData[97][First[#2]],Line[#1]}&,xys],
		ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]},
		Background->GrayLevel[0.95`]
	]
*)

trajectoryIcon[]=Graphics[{{RGBColor[0.368417, 0.506779, 0.709798], Line[{{0., 1.}, {0.1, 0.5418496565515698}, {0.2, 0.4193451838319236}, {0.30000000000000004`, 0.36651114277451935`}, {0.4, 0.3392554988916695}, {0.5, 0.3238974498455319}, {0.6000000000000001, 0.3148102867899037}, {0.7000000000000001, 0.3092773757100911}, {0.8, 0.30585000793758305`}, {0.9, 0.3037038923129819}, {1., 0.3023513035436409}}]}, {RGBColor[0.880722, 0.611041, 0.142051], Line[{{0., 0.7}, {0.1, 0.2418496565515695}, {0.2, 0.11934518383192347`}, {0.30000000000000004`, 0.06651114277451904}, {0.4, 0.0392554988916692}, {0.5, 0.02389744984553159}, {0.6000000000000001, 0.014810286789903324`}, {0.7000000000000001, 0.009277375710090735}, {0.8, 0.005850007937582646}, {0.9, 0.003703892312981499}, {1., 0.0023513035436404667`}}]}, {RGBColor[0.560181, 0.691569, 0.194885], Line[{{0., 0.}, {0.1, 0.4581503434484303}, {0.2, 0.5806548161680765}, {0.30000000000000004`, 0.6334888572254808}, {0.4, 0.6607445011083307}, {0.5, 0.6761025501544682}, {0.6000000000000001, 0.6851897132100966}, {0.7000000000000001, 0.690722624289909}, {0.8, 0.6941499920624173}, {0.9, 0.6962961076870184}, {1., 0.6976486964563594}}]}}, Background -> GrayLevel[0.95], ImageSize -> {Automatic, Dynamic[3.5 CurrentValue["FontCapHeight"]]}];


(* ::Subsubsection:: *)
(*Boxes*)


MakeTrajectoryBoxes[]:=Module[{},
	MakeBoxes[summary:Trajectory[species_List,concs_List,times_List,units_List], StandardForm] := BoxForm`ArrangeSummaryBox[
	    Trajectory,
	    summary,
	    trajectoryIcon[],
	    {
				BoxForm`SummaryItem[{"Num Species: ", Length[species]}],
				BoxForm`SummaryItem[{"Time Span: ", times[[{1,-1}]]*First[units]}]
			},
	    {
				BoxForm`SummaryItem[{"Num Time Points: ", Length[times]}],
				BoxForm`SummaryItem[{"Units ", units}]
			},
	    StandardForm
	]
];




