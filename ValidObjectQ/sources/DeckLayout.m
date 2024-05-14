

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*validDeckLayoutQTests*)


validDeckLayoutQTests[packet:PacketP[Model[DeckLayout]]] := {
	(* General fields filled in *)
	NotNullFieldTest[packet,{Name,Author,Layout}],
	
	UniquelyInformedTest[packet,{InstrumentModel,ContainerModel}],
	
	Test["All positions in Layout are in the model's positions list:",
		Module[{instrumentPositions,containerPositions,positionsToUse,layoutPositions},
			
			(* download Positions from Instrument/Container Model *)
			{instrumentPositions,containerPositions}=Download[Lookup[packet,{InstrumentModel,ContainerModel}],Positions];
			
			(* determine which is actually populated *)
			positionsToUse=If[MatchQ[instrumentPositions,{}],
				containerPositions,
				instrumentPositions
			];
			
			(* get the layout field positions *)
			layoutPositions=Lookup[packet,Layout][[All,1]];
			
			(* do the check to make sure the names in Layout are consistent with allowed positions in the model *)
			ContainsAll[Lookup[positionsToUse,Name],layoutPositions]
		],
		True
	],
	
	Test["All positions in NestedLayout are in the model's positions list:",
		Module[{instrumentPositions,containerPositions,positionsToUse,layoutPositions},
			
			(* download Positions from Instrument/Container Model *)
			{instrumentPositions,containerPositions}=Download[Lookup[packet,{InstrumentModel,ContainerModel}],Positions];
			
			(* determine which is actually populated *)
			positionsToUse=If[MatchQ[instrumentPositions,{}],
				containerPositions,
				instrumentPositions
			];
			
			(* get the layout field positions *)
			layoutPositions=Lookup[packet,NestedLayout][[All,1]];
			
			(* do the check to make sure the names in NestedLayout are consistent with allowed positions in the model *)
			ContainsAll[Lookup[positionsToUse,Name],layoutPositions]
		],
		True
	],
	
	Test["Layout has no duplicated position names:",
		DuplicateFreeQ[Lookup[packet,Layout][[All,1]]],
		True
	],
	
	Test["NestedLayout has no duplicated position names:",
		DuplicateFreeQ[Lookup[packet,NestedLayout][[All,1]]],
		True
	],
	
	Test["If NestedLayout is populated, all positions are also present in Layout:",
		ContainsAll[Lookup[packet,Layout][[All,1]],Lookup[packet,NestedLayout][[All,1]]],
		True
	],
	
	Test["If NestedLayout is populated the nested layouts target the corresponding container model from the Layout field:",
		Module[{layout,nestedLayout,nestedLayoutContainerModels},
			
			(* pull out the layout and nested layout fields *)
			{layout,nestedLayout}=Lookup[packet,{Layout,NestedLayout}];
			
			(* if NestedLayout is empty, don't do the chekc *)
			If[MatchQ[nestedLayout,{}],
				Return[True]
			];
			
			(* download ContainerModel from NestedLayouts *)
			nestedLayoutContainerModels=Download[nestedLayout[[All,2]],ContainerModel[Object]];
			
			(* for each nested layout entry, make sure the container that the deck layout references is the same as what's in Layout *)
			allNestedLayoutChecks=MapThread[
				Function[{nestedLayoutPosition,nestedLayoutContainerModel},
					Module[{layoutEntryForPosition},
						
						(* try to find the Layout entry with the same position *)
						layoutEntryForPosition=SelectFirst[layout,MatchQ[First[#],nestedLayoutPosition]&];
						
						(* fail if this is missing entirely *)
						If[MissingQ[layoutForPosition],
							Return[False,Module]
						];
						
						(* see if the layout entry for the position has the same container model as the layout from NestedLayout *)
						MatchQ[Download[Last[layoutEntryForPosition],Object],nestedLayoutContainerModel]
					]
				],
				{nestedLayout[[All,1]],nestedLayoutContainerModels}
			];
			
			(* make sure all checks passed *)
			And@@allNestedLayoutChecks
		],
		True
	]
};


registerValidQTestFunction[Model[DeckLayout],validDeckLayoutQTests];
