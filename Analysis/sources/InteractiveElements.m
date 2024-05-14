

(* ::Subsection::Closed:: *)
(*Preview Framework*)


domainSliderEventActions = {
	{"MouseDown",2,None} -> domainDownNone,
	{"MouseDragged",2,None} -> domainDraggedNone,
	{"MouseUp",2, None} -> domainUpNone
};

(* find closest moveable bar *)
domainDownNone[dv_]:=With[{
		xpos=First[MousePosition["Graphics"],None],
		oldDomain = PreviewValue[dv,Domain,dv[XUnit]]
		},
		If[xpos===None,
			dv[{Domain,DragIndex}]=Null,
			dv[{Domain,DragIndex}] = First[Ordering[{
				Abs[oldDomain[[1]]-xpos],
				Abs[oldDomain[[2]]-xpos]
			}]];
	]];
domainDraggedNone[dv_]:=With[{xpos=First[MousePosition["Graphics"],None]},(
		If[MatchQ[dv[{Domain,DragIndex}],_Integer],
			dv[{Domain,dv[{Domain,DragIndex}]}] = xpos;
			With[{old=PreviewValue[dv,Domain], newPart = xpos*dv[XUnit]},
				UpdatePreview[dv,Domain -> ReplacePart[old,dv[{Domain,DragIndex}]-> newPart]];
			];
		];
		Null
	)];
domainUpNone[dv_]:= {Domain->PreviewValue[dv,Domain]}

domainSliderPrimitives[dv_Symbol]:= With[{
		domainRaw = PreviewValue[dv,Domain,XUnit],
		xunit = dv[XUnit],
		yMin = PreviewValue[dv,YMin,YUnit],
		yMax = PreviewValue[dv,YMax,YUnit]
	},
	Graphics[{
		Dashing[Large],
		Line[{{domainRaw[[1]],yMin},{domainRaw[[1]],yMax}}],
		Line[{{domainRaw[[2]],yMin},{domainRaw[[2]],yMax}}]
	}]
];

zoomablePrimitives[dv_]:= If[dv[{Zoomable,Dragging}]===True,
					{
						Opacity[0.25],EdgeForm[{Thin,Dashing[Small],Opacity[0.5]}],
						FaceForm[RGBColor[0.89013625`,0.8298584999999999`,0.762465`]],
						Rectangle[dv[{Zoomable,1}],dv[{Zoomable,2}]]
					},
					{}
];

zoomDownShift[dv_]:=(dv[{Zoomable,Before}]=MousePosition["Graphics"]/.None->First[dv[{Zoomable,Range}]])
zoomDownNone[dv_]:=(dv[{Zoomable,1}]=(MousePosition["Graphics"]));
zoomDragShift[dv_]:=(
	dv[{Zoomable,After}]=MousePosition["Graphics"];
	dv[{Zoomable,PlotRange}]=dv[{Zoomable,PlotRange}]+(dv[{Zoomable,Before}]-dv[{Zoomable,After}])
);
zoomDragNone[dv_]:=(
	dv[{Zoomable,Dragging}]=True;
	dv[{Zoomable,NewSecond}]=MousePosition["Graphics"];
	If[MatchQ[dv[{Zoomable,NewSecond}],None],
		dv[{Zoomable,Dragging}]=False,
		dv[{Zoomable,2}]=dv[{Zoomable,NewSecond}]
	]
);
zoomUpNone[dv_]:=If[dv[{Zoomable,Dragging}],
	(
		dv[{Zoomable,Dragging}]=False;
		dv[{Zoomable,PlotRange}]=Transpose@{dv[{Zoomable,1}],dv[{Zoomable,2}]};
	),
	dv[{Zoomable,PlotRange}] = dv[{Zoomable,Default}];
];
zoomableEventActions = {
	{"MouseDown",1,"ShiftKey"} ->  zoomDownShift,
	{"MouseDown",1,None} -> zoomDownNone,
	{"MouseDragged",1,"ShiftKey"} -> zoomDragShift,
	{"MouseDragged",1,None} -> zoomDragNone,
	{"MouseUp",1,None} -> zoomUpNone
};

formatEventActions[dv_Symbol, in_]:= Module[
	{inFlat, grouped},

	(* flatten, because some generic actions come in groups (zoomable, domainsliders, ...*)
	inFlat = Flatten[in];

	(* check for conflicting key commands *)
	If[Not[DuplicateFreeQ[inFlat[[;;,1]]]],
		Message[];
		Return[$Failed];
	];

	(* warn about overlapping (click vs down) *)


	(* group by the {"MouseAction,buttonNumber} pair *)
	grouped =  Map[ReverseSort,GatherBy[inFlat,#[[1,1;;2]]&]];

	Map[
		formatOneEventSet[dv,#]&,
		grouped
	]

];


formatOneEventSet[dv_Symbol, in:{ Rule[{_String,_Integer,___},_Symbol|_Function]...} ] := With[
	{
		clickSpec = in[[1,1,1;;2]],	(* {"MouseAction",buttonNumber} pair *)
		keys = in[[;;,1,3]], (* modifier keys *)
		actions = in[[;;,2]] (* functions that act on 'dv' *)
	},

	With[
		{
			(* construct the checks and actions for a 'Which' call.  keep everything unevaluated *)
			heldArgs = Join@@MapThread[Hold[keypressQ[#1],LogPreviewChanges[dv,#2[dv]]]&,{keys,actions}]
		},

		(* clickSpec :> Which[args] *)
		ReplacePart[
			RuleDelayed[clickSpec,heldArgs],
			{2,0} -> Which
		]
	]

];

keypressQ[None]:=SameQ[CurrentValue["ModifierKeys"],{}];
keypressQ[key_String]:=TrueQ[CurrentValue[key]]


setupPreviewSymbolXY[analysisFunction_, xy_, resolvedOps:{_Rule...}, internalVariables:{_Rule...},dvar_]:=
	With[
	{
		(*
			When the app is loaded in command center,dv must be stored as a \
			kernel variable and NOT a dynamicmodule variable for things to \
			work.However,this means the graphic will cease to function after a \
			kernel restart-Therefore,switch on $ECLApplication-If \
			$CommandCenter,then dv lives in the kernel-Otherwise,dv is a \
			DynamicModule variable
			^^^ From khou
			but this kills the dv link in mathematica.
			can we just use DynamicModule var in doc builder case so the figs don't go red?
		*)
		dv=Which[
			(* CommandCenter *)
			MatchQ[$ECLApplication, CommandCenter], Unique["dvar"],
			(* Mathematica *)
			MatchQ[$ECLApplication, Mathematica], Unique["dvar"],
			(* doc builder *)
			True, dvar
		]
	},

(* store the variable in a known place *)
	PreviewSymbol[analysisFunction] = dv;
	dvToFunction[dv] = analysisFunction;

	(* copy resolved options *)
	If[Length[resolvedOps]>0,
		With[{keys = resolvedOps[[;;,1]],vals=resolvedOps[[;;,2]]},
			MapThread[dv[#1]=#2; &, {keys,vals}]
		]
	];

	(* copy internal variables *)
	If[Length[internalVariables]>0,
		With[{keys = internalVariables[[;;,1]],vals=internalVariables[[;;,2]]},
			MapThread[dv[#1]=#2; &, {keys,vals}]
		]
	];

	If[ xy =!= Null,
		dv[XUnit] = Units[xy[[1,1]]];
		dv[YUnit] = Units[xy[[1,2]]];
		dv[XYBounds] = CoordinateBounds[xy];
		{{dv[XMin],dv[XMax]},{dv[YMin],dv[YMax]}} = dv[XYBounds];
		dv[DefaultPlotRange] = dv[XYBounds];
		dv[PlotRange] = dv[DefaultPlotRange];
		(* zoomable *)
		dv[{Zoomable,Default}] = { Unitless[First[dv[XYBounds]],dv[XUnit]], Unitless[Last[dv[XYBounds]],dv[YUnit]] };
		dv[{Zoomable,PlotRange}] = dv[{Zoomable,Default}];
		(* domain sliders *)
		dv[Domain] = {dv[XMin],dv[XMax]};
	];


	(* return the variable name *)
	dv
];

makeInteractivePreviewXY[analysisFunction_,xy_,fig_, resolvedOps_, internalVariables_, eventActions_, epilogPrimitives_]:=DynamicModule[{dvar},With[{
		dv = setupPreviewSymbolXY[analysisFunction, xy, resolvedOps, internalVariables,dvar]
	},
	Module[{formattedEventActions},

		formattedEventActions = formatEventActions[dv,eventActions];
If[$VerbosePreview,Print[formattedEventActions]];
		EventHandler[
			Dynamic[
				Show[
					fig,
					Graphics[#[dv]]&/@epilogPrimitives,
					PlotRange->dv[{Zoomable,PlotRange}]
				],
				TrackedSymbols:>{dv}
			],
			formattedEventActions
		]
	]]
];





zoomableInitialization[dv_,defaultPlotRange:{{xmin_,xmax_},{ymin_,ymax_}}]:=Module[{},
	dv[{Zoomable,Default}] = defaultPlotRange;
	dv[{Zoomable,PlotRange}] = defaultPlotRange;
];

zoomableActions[dv_] := Sequence[
(* zoomable interactions *)
			{"MouseDown",1}:>With[{mousePosition = MousePosition["Graphics"]},
				If[CurrentValue["ShiftKey"],
					(dv[{Zoomable,Before}]=mousePosition/.None->First[dv[{Zoomable,Range}]]),
					(dv[{Zoomable,1}]=(mousePosition/.None->dv[{Zoomable,1}]))
				]
			],

			{"MouseDragged",1}:>With[{mousePosition = MousePosition["Graphics"]},
				If[CurrentValue["ShiftKey"],
					(
						dv[{Zoomable,After}]=mousePosition;
						dv[{Zoomable,PlotRange}]=dv[{Zoomable,PlotRange}]+(dv[{Zoomable,Before}]-dv[{Zoomable,After}])
					),
					(
						dv[{Zoomable,Dragging}]=True;
						dv[{Zoomable,NewSecond}]=mousePosition;
						If[MatchQ[dv[{Zoomable,NewSecond}],None],
							dv[{Zoomable,Dragging}]=False,
							dv[{Zoomable,2}]=dv[{Zoomable,NewSecond}]
						]
					)
				]
			],
			{"MouseUp",1}:>With[{mousePosition = MousePosition["Graphics"]},
				If[CurrentValue["ShiftKey"],
					Null,
					If[dv[{Zoomable,Dragging}],
						(
							dv[{Zoomable,Dragging}]=False;
							dv[{Zoomable,PlotRange}]=Transpose@{dv[{Zoomable,1}],dv[{Zoomable,2}]};
						),
						dv[{Zoomable,PlotRange}] = dv[{Zoomable,Default}];
					]
				]
			]
		];

	zoomableGraphic[dv_]:= If[dv[{Zoomable,Dragging}]===True,
					Graphics[{
						Opacity[0.25],EdgeForm[{Thin,Dashing[Small],Opacity[0.5]}],
						FaceForm[RGBColor[0.89013625`,0.8298584999999999`,0.762465`]],
						Rectangle[dv[{Zoomable,1}],dv[{Zoomable,2}]]
					}],
					{}
];



domainSliderActions[dv_Symbol,xunit_]:=Sequence@@With[{

},
	{
(* find closest movable bar  *)
{"MouseDown",2} :> If[Not[TrueQ[CurrentValue["ShiftKey"]]],With[{
		xpos=First[MousePosition["Graphics"],None],
		oldDomain = PreviewValue[dv,Domain,xunit]
		},
		If[xpos===None,
			dv[{Domain,DragIndex}]=Null,
			dv[{Domain,DragIndex}] = First[Ordering[{
				Abs[oldDomain[[1]]-xpos],
				Abs[oldDomain[[2]]-xpos]
			}]];
	]]],
(* drag the bar *)
{"MouseDragged",2} :> If[Not[TrueQ[CurrentValue["ShiftKey"]]],With[{xpos=First[MousePosition["Graphics"],None]},(
		If[MatchQ[dv[{Domain,DragIndex}],_Integer],
			dv[{Domain,dv[{Domain,DragIndex}]}] = xpos;
			With[{old=PreviewValue[dv,Domain], newPart = xpos*xunit},
				UpdatePreview[dv,Domain -> ReplacePart[old,dv[{Domain,DragIndex}]-> newPart]];
			];
		]
	)]],
(* update option diff with final position *)
{"MouseUp",2} :> If[Not[TrueQ[CurrentValue["ShiftKey"]]],LogPreviewChanges[
		dv,
		{Domain->PreviewValue[dv,Domain]}
	]]
}];

domainSliderGraphic[dv_Symbol,{yMin_,yMax_},xunit_]:= With[{
		domainRaw = PreviewValue[dv,Domain,xunit]
	},
	Graphics[{
		Dashing[Large],
		Line[{{domainRaw[[1]],yMin},{domainRaw[[1]],yMax}}],
		Line[{{domainRaw[[2]],yMin},{domainRaw[[2]],yMax}}]
	}]
];

domainSliderInitialization[dv_,dom:{leftDefault_,rightDefault_}]:= (
	UpdatePreview[dv,Domain->{leftDefault,rightDefault}];
);




SetToMousePosition[clump_Clump,prop_,{ind_}]:= With[{mp=MousePosition["Graphics"]},
	If[mp=!=None,
		ClumpSet[Clumps`Private`toCP[clump,PointSpot,{ind}] ->  MousePosition["Graphics"]]
	]
]

SetToMousePositionX[clump_Clump,prop_,{indA_,indB_}]:= With[{mp=MousePosition["Graphics"]},
	If[mp=!=None,
		ClumpSet[Clumps`Private`toCP[clump,prop,{indA,indB}] ->  First@MousePosition["Graphics"]]
	]
]

DomainSliderPrimitives[clump_, prop_,{ind_}]:= {
	DomainSliderPrimitive[clump, prop,{ind,1}],
	DomainSliderPrimitive[clump, prop,{ind,2}]
};
DomainSliderPrimitive[clump_, prop_, {indA_,indB_}]:= With[{},{Thick,Dashed,Blue,Line[{
	{ClumpDynamic[clump,prop,{indA,indB} ], ClumpGet[clump,Range,{indA,1}]},
	{ClumpDynamic[clump,prop,{indA,indB} ],ClumpGet[clump,Range,{indA,2}]}
}]}];