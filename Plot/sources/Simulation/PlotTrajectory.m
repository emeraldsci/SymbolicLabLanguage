(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTrajectory*)


DefineOptions[PlotTrajectory,
	Options :> {
		{
			OptionName -> TotalConcentration,
			Default -> False,
			Description -> "Whether to plot a single trajectory corresponding to the sum of concentrations over all species.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
		},

		(* Primary data *)
		ModifyOptions[
			PrimaryDataOption,
			Default->Trajectory,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Trajectory|Automatic],
				Widget[Type->Expression,Pattern:>_,Size->Line]
			],
			Category->"Hidden"
		],

		{
			OptionName->Draw,
			Description->"Specifies which species form is displayed on mouseover.",
			Default->Structure,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Structure|Motif|String],
				Widget[Type->Expression,Pattern:>Automatic|Structure|Motif|String|Base|"Structure"|"Motif"|"String"|"Base"|0|2|3,Size->Line]
			],
			Category->"Plot Labeling"
		},

		(* Secondary data *)
		ModifyOptions[
			SecondaryDataOption,
			Default->Automatic,
			Description->"Data to plot on secondary y-axis. If Automatic, Temperature and Volume are shown if they are varying with time.",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Automatic|None|Temperature|Volume],
				Widget[Type->Expression,Pattern:>Automatic|None|ListableP[Temperature|Volume],Size->Line]
			],
			Category->"Secondary Data"
		],

		{
			OptionName->Temperature,
			Description->"The temperature profile to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				"Enter Individual Points:"->Adder[
					{
						"Time:"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Picosecond|Nanosecond|Millisecond|Second|Minute|Hour],
						"Temperature:"->Widget[Type->Quantity,Pattern:>RangeP[-Infinity Celsius,Infinity Celsius],Units->Celsius|Fahrenheit|Kelvin]
					}
				],
				"Enter Profile:"->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph]
			],
			Category->"Hidden"
		},

		{
			OptionName->Volume,
			Description->"The volume profile to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				"Enter Individual Points:"->Adder[
					{
						"Time:"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Second],Units->Picosecond|Nanosecond|Microsecond|Millisecond|Second|Minute|Hour],
						"Volume:"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Liter],Units->Picoliter|Nanoliter|Microliter|Milliliter|Liter]
					}
				],
				"Enter Profile:"->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph]
			],
			Category->"Hidden"
		},

		(* Default Zoomable to True *)
		ModifyOptions[ZoomableOption,Default->True],

		(* Default ImageSize to 550 *)
		ModifyOptions[ListPlotOptions,{ImageSize},Default->500],

		(* Legend options *)
		ModifyOptions[EmeraldListLinePlot,{Legend},Default->None],
		ModifyOptions[EmeraldListLinePlot,{LegendPlacement},Default->Right],

		(* Tooltip option *)
		ModifyOptions[EmeraldListLinePlot,
			{
				{
					OptionName->Tooltip,
					Default->Automatic,
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
						Widget[Type->Expression, Pattern:>Automatic|Null|_List,Size->Line]
					]
				}
			}
		],

		(* Hide irrelevant options *)
		ModifyOptions[EmeraldListLinePlot,{InterpolationOrder,Reflected},Category->"Hidden"],
		ModifyOptions[EmeraldListLinePlot,{Peaks,PeakLabels,PeakLabelStyle,Fractions,FractionColor,FractionHighlightColor},Category->"Hidden"],
		ModifyOptions[EmeraldListLinePlot,{FrameUnits,ErrorBars,ErrorType},Category->"Hidden"]

	},

	SharedOptions :> {
		EmeraldListLinePlot
	}
];


PlotTrajectory::BadSpecies="The following species are not present in the Trajectory: `1`";
PlotTrajectory::NoSpecies="There are no valid species to plot";
Error::InvalidIndices="Some of the specified indices (`1`) do not match the input. Please check that the indices are correct.";
Warning::InvalidNumberOfSpecies="`1` species were requested but only `2` are present in the input data. Please check that the requested number is correct. Defaulting to n=`2`.";


speciesToPlotP=Alternatives[{ReactionSpeciesP..},{_Integer..},_Integer];


PlotTrajectory[Null,___]:=Null;
PlotTrajectory[$Failed,___]:=$Failed;

PlotTrajectory[objs:ListableP[ObjectReferenceP[Object[Simulation,Kinetics]]|LinkP[Object[Simulation,Kinetics]]],ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[Download[objs],ops];

PlotTrajectory[objs:ListableP[ObjectReferenceP[Object[Simulation,Kinetics]]|LinkP[Object[Simulation,Kinetics]]],speciesToPlot:(ListableP[ReactionSpeciesP,2]|ListableP[_Integer,2]),ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[Download[objs],speciesToPlot,ops];


PlotTrajectory[inf:(PacketP[Object[Simulation,Kinetics]]|PacketP[Object[Simulation,Kinetics]]),ops:OptionsPattern[PlotTrajectory]]:=
	Module[{passingOptions},

		(* Removing the duplicated options before passing *)
		passingOptions=ReplaceRule[
			{ops},
			{
				Temperature->(If[MatchQ[#,Null],Null,#]&@(TemperatureProfile/.inf)),
				Volume->(If[MatchQ[#,Null],Null,#]&@(VolumeProfile/.inf)),
				InterpolationOrder->resolveInterpolationOrder[Lookup[inf,Method]]
			}
		];
		PlotTrajectory[Trajectory/.inf,
			Sequence@@passingOptions
		]
	];

PlotTrajectory[inf:(PacketP[Object[Simulation,Kinetics]]|PacketP[Object[Simulation,Kinetics]]),speciesToPlot:(ListableP[ReactionSpeciesP,2]|ListableP[_Integer,2]), ops:OptionsPattern[PlotTrajectory]]:=
	Module[{passingOptions},
		(* Removing the duplicated options before passing *)
		passingOptions=ReplaceRule[
			{ops},
			{
				Temperature->(If[MatchQ[#,Null],Null,#]&@(TemperatureProfile/.inf)),
				Volume->(If[MatchQ[#,Null],Null,#]&@(VolumeProfile/.inf)),
				InterpolationOrder->resolveInterpolationOrder[Lookup[inf,Method]]
			}
		];
		PlotTrajectory[Trajectory/.inf,speciesToPlot,
			Sequence@@passingOptions
		]
	];

PlotTrajectory[infs:{(PacketP[Object[Simulation,Kinetics]]|PacketP[Object[Simulation,Kinetics]])..},ops:OptionsPattern[PlotTrajectory]]:=
	Module[{passingOptions},
		(* Removing the duplicated options before passing *)
		passingOptions=ReplaceRule[
			{ops},
			{
				Temperature->Map[If[MatchQ[#,Null],Null,#]&,(TemperatureProfile/.infs)],
				Volume->Map[If[MatchQ[#,Null],Null,#]&,(VolumeProfile/.infs)],
				InterpolationOrder->resolveInterpolationOrder[Lookup[infs,Method]]
			}
		];
		PlotTrajectory[Trajectory/.infs,
			Sequence@@passingOptions
		]
	];

PlotTrajectory[infs:{(PacketP[Object[Simulation,Kinetics]]|PacketP[Object[Simulation,Kinetics]])..},speciesToPlot:(ListableP[ReactionSpeciesP,2]|ListableP[_Integer,2]),ops:OptionsPattern[PlotTrajectory]]:=
	Module[{passingOptions},
		(* Removing the duplicated options before passing *)
		passingOptions=ReplaceRule[
			{ops},
			{
				Temperature->Map[If[MatchQ[#,Null],Null,#]&,(TemperatureProfile/.infs)],
				Volume->Map[If[MatchQ[#,Null],Null,#]&,(VolumeProfile/.infs)],
				InterpolationOrder->resolveInterpolationOrder[Lookup[infs,Method]]
			}
		];
		PlotTrajectory[Trajectory/.infs,speciesToPlot,
			Sequence@@passingOptions
		]
	];


(* Convert data to a Trajectory *)
PlotTrajectory[x:{{_?NumericQ..}..},t:{_?NumericQ..},rest___,opts:OptionsPattern[PlotTrajectory]]:=PlotTrajectory[ToTrajectory[x,t],rest,opts];

PlotTrajectory[input:{sol_InterpolatingFunction,specs_List,__},rest___,opts:OptionsPattern[PlotTrajectory]]:=PlotTrajectory[ToTrajectory[specs,sol],rest,opts];
PlotTrajectory[input:{specs_List,sol_InterpolatingFunction,__},rest___,opts:OptionsPattern[PlotTrajectory]]:=PlotTrajectory[ToTrajectory[specs,sol],rest,opts];


(* plot subset of species *)
PlotTrajectory[trajs:{TrajectoryP..},speciesToPlot:{{ReactionSpeciesP..}..},ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[MapThread[Trajectory[#1,NucleicAcids`Private`sortAndReformatStructures/@#2]&,{trajs,speciesToPlot}],ops];

PlotTrajectory[traj:TrajectoryP,speciesToPlot:{Null},ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[traj,ops];

PlotTrajectory[traj:TrajectoryP,speciesToPlot:{ReactionSpeciesP..},ops:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[Trajectory[traj,NucleicAcids`Private`sortAndReformatStructures/@speciesToPlot],ops];

(* plot based on index number *)
PlotTrajectory[traj:TrajectoryP,indiciesToPlot:{_Integer..},ops:OptionsPattern[PlotTrajectory]]:=Module[
	{invalidIndices},

	(* If any invalid indices were specified, throw an error and return $Failed *)
	invalidIndices=Complement[indiciesToPlot,Range[Length@traj[Species]]];
	If[Length@invalidIndices>0,Message[Error::InvalidIndices,invalidIndices];Return[$Failed]];

	PlotTrajectory[Trajectory[traj,indiciesToPlot],ops]

];

(* plot largest or smallest only *)
PlotTrajectory[traj:TrajectoryP,numToPlot_Integer,opts:OptionsPattern[PlotTrajectory]]:=Module[
	{n,ranking,selected},

	(* If too many species were requested, throw a warning and return all species *)
	n=If[
		Abs[numToPlot]>Length@traj[Species],
		Message[Warning::InvalidNumberOfSpecies,Abs[numToPlot],Length@traj[Species]];
		Sign[numToPlot]*Length@traj[Species],
		numToPlot
	];

	(* Sort species in reverse order by final concentration *)
	ranking=Reverse[Ordering[TrajectoryRegression[traj,End]]];

	(* Select n most or least abundant species  *)
	selected=Part[ranking,Span[If[n<=0,n,All],If[n>0,n,All]]];

	(* Plot the selected species *)
	PlotTrajectory[Trajectory[traj,selected],opts]

];

PlotTrajectory[traj:TrajectoryP,opts:OptionsPattern[PlotTrajectory]]:=Module[ {
		qas,overlap,pics,unresolvedLegend,effectiveTraj, safeOps,secondaryDataSets,temps,vols,
		plots,dataTooltip,d,visualizationFunction,allSpecies,targetUnits,yUnit,xUnit,
		secondaryDataOption,output,outputTable,ellpOutput,ellpOutputTable,secondaryData
	},

	safeOps = SafeOptions[PlotTrajectory, ToList[opts]];

	effectiveTraj = If[OptionValue[TotalConcentration],
		trajectoryConcentrationSum[traj],
		traj
	];

	allSpecies = effectiveTraj[Species];

	temps = If[MatchQ[#,CoordinatesP|QuantityArrayP[]],{#},#]&[Lookup[safeOps,Temperature]];
	vols = If[MatchQ[#,CoordinatesP|QuantityArrayP[]],{#},#]&[Lookup[safeOps,Volume]];
	secondaryData=Lookup[safeOps,SecondaryData];
	secondaryDataOption = If[SameQ[secondaryData,None],{},resolveSecondaryDataOption[secondaryData,Unitless[temps],Unitless[vols]]];
	secondaryDataSets = DeleteCases[DeleteCases[secondaryDataOption/.{Volume->vols,Temperature->temps},Null,2],{},{1}];
	secondaryDataSets = If[MatchQ[secondaryDataSets,Null|{Null..}|{}],
		Null,
		PadRight[Transpose[secondaryDataSets],Length[allSpecies],Null]
	];

	(* picture for tooltips *)
    visualizationFunction=Switch[OptionValue[Draw],
		Automatic,StructureForm,
		String|"String"|0, ToString,
		Motif|"Motif"|2, MotifForm,
		Base|"Base", StructureForm,
		Structure|"Structure"|3, StructureForm
	];

	pics = Replace[allSpecies,s:(_?SequenceQ|StrandP|StructureP):>visualizationFunction[s],{1}];

	(* convert the trajectories into QA lists *)
	qas = Map[
			Function[cvals,
				QuantityArray[
					Transpose[{effectiveTraj["Times"],cvals}],
					effectiveTraj["Units"]
				]
			],
			Transpose[effectiveTraj["Concentrations"]]
		];

	(* get target Y-unit from max data point *)
	yUnit = UnitScale[Max[Flatten[qas[[;;,;;,2]]]]];
	xUnit = UnitScale[Max[Flatten[qas[[;;,;;,1]]]]];

	targetUnits = resolveTargetUnitsPlotTrajectory[Lookup[safeOps,TargetUnits],{xUnit,yUnit}];

	(* --- Legend --- *)
	unresolvedLegend=Switch[
		OptionValue[Legend],
		_List,Flatten[OptionValue[Legend]],
		Automatic,ToString/@allSpecies,
		Null|None,Null
	];

	(* make plot *)
	ellpOutput= EmeraldListLinePlot[
		qas,
		TargetUnits->targetUnits,
		SecondYCoordinates->secondaryDataSets,
		PassOptions[PlotTrajectory,EmeraldListLinePlot,Legend->unresolvedLegend,Tooltip->Replace[Lookup[safeOps,Tooltip],Automatic->pics],opts]
	];

	(* Construct table of ELLP outputs *)
	output=Lookup[safeOps,Output];
	ellpOutputTable=MapThread[Rule,If[MatchQ[output,_List],{output,ellpOutput},{{output},{ellpOutput}}]];

	(* Merge resolved ELLP options (excluding Epilog) with safe options *)
	outputTable=ellpOutputTable/. HoldPattern[Options->ellpOps_]:>(Options->ReplaceRule[safeOps,FilterRules[ellpOps,Except[Epilog]]]);

	(* Return the result, according to the output option *)
	output/.outputTable

];

PlotTrajectory[trajList:{_Trajectory..},sub:(_Integer|{_Integer..}|{ReactionSpeciesP..}),opts:OptionsPattern[PlotTrajectory]]:=
	PlotTrajectory[Trajectory[#,sub]&/@trajList,opts];


(* main function *)
PlotTrajectory[trajList:{_Trajectory..},opts:OptionsPattern[PlotTrajectory]] :=
    Module[ {qas,overlap,pics,unresolvedLegend,safeOps,safeOpsFinal,yUnit,secondaryDataSets,temps,vols,targetUnits,
	speciesList,plots,effectiveTrajList,dataTooltip,d,visualizationFunctions,speciesListList,allSpecies,
	    specPosListList,rawColorListList,colorListList, maxNumSpecs, xUnit, secondaryDataOption,
	    output,outputTable,ellpOutput,ellpOutputTable,secondaryData
    },

	safeOps = SafeOptions[PlotTrajectory, ToList[opts]];

	temps = If[MatchQ[#,CoordinatesP|QuantityArrayP[]],{#},#]&[Lookup[safeOps,Temperature]];
	vols = If[MatchQ[#,CoordinatesP|QuantityArrayP[]],{#},#]&[Lookup[safeOps,Volume]];

	effectiveTrajList = If[OptionValue[TotalConcentration],
		trajectoryConcentrationSum /@ trajList,
		trajList
	];

	secondaryData=Lookup[safeOps,SecondaryData];
	secondaryDataOption = If[SameQ[secondaryData,None],{},resolveSecondaryDataOption[secondaryData,Unitless[temps],Unitless[vols]]];
	secondaryDataSets = DeleteCases[DeleteCases[secondaryDataOption/.{Volume->vols,Temperature->temps},Null,2],{},{1}];
	secondaryDataSets = If[MatchQ[secondaryDataSets,Null|{Null..}|{}],
		Null,
		Transpose[secondaryDataSets]
	];

	speciesListList = Map[#[Species]&,effectiveTrajList];

	maxNumSpecs = Max[Length/@speciesListList];
	allSpecies = DeleteDuplicates[Flatten[speciesListList,1]];

	specPosListList = Function[specList,First[First[Position[allSpecies,#,1]]]&/@specList]/@speciesListList;

	(* Get a list of shaded colors for each species *)
	rawColorListList=Table[ColorFade[ColorData[97][i],Length[Position[speciesListList,allSpecies[[i]]]]],{i,Length[allSpecies]}];
	(* Reorganize the colors *)
	colorListList=reorganizeColors[rawColorListList,allSpecies,speciesListList];

	(* picture for tooltips *)
    visualizationFunctions=Table[
		Switch[OptionValue[Draw],
			Automatic,StructureForm,
			String|"String"|0, ToString,
			Motif|"Motif"|2, MotifForm,
			Base|"Base", StructureForm,
			Structure|"Structure"|3, StructureForm
		],
		{speciesList,speciesListList}
	];
	pics = MapThread[
		Replace[allSpecies,s:(_?SequenceQ|StrandP|StructureP):>#1[s],{1}]&,
		{visualizationFunctions,speciesListList}
	];

	(* convert the trajectories into QA lists *)
	qas = Map[
		Thread[Rule[#[Species],Map[
			Function[cvals,
				QuantityArray[
					Transpose[{#["Times"],cvals}],
					#["Units"]
				]
			],
			Transpose[#["Concentrations"]]
		]]]&,
		effectiveTrajList
	];

	(* get target Y-unit from max data point *)
	yUnit = Quantity[QuantityUnit[UnitScale[Max[Map[Max[#[[;;,2]]]&,Flatten[qas[[;;,;;,2]],1]]]]]];
	xUnit = Quantity[QuantityUnit[UnitScale[Max[Map[Max[#[[;;,1]]]&,Flatten[qas[[;;,;;,2]],1]]]]]];

	(* if trajs are the results from SimulateMeltingCurve, then add a Prolog with arrows *)
	safeOpsFinal = If[Length[effectiveTrajList]==2 && TemperatureQ[effectiveTrajList[[1]][XUnit]],
				ReplaceRule[safeOps, {Prolog->prologMeltingCurve[effectiveTrajList, yUnit]}],
				safeOps
			];

	(* pad with Null the species that don't exist in some trajs *)
	qas = Map[Replace[allSpecies,Append[#,_->Null],{1}]&,qas];

	targetUnits = resolveTargetUnitsPlotTrajectory[Lookup[safeOpsFinal,TargetUnits],{xUnit,yUnit}];

	(* --- Legend --- *)
	unresolvedLegend=Switch[
		OptionValue[Legend],
		_List,Flatten[OptionValue[Legend]],
		Automatic,Flatten[ToString/@Flatten[#[Species]&/@effectiveTrajList]],
		Null|None,Null
	];

	(* make plot *)
	ellpOutput=EmeraldListLinePlot[
		DeleteCases[Transpose[qas],{Null..}],
		TargetUnits->targetUnits,
		PassOptions[PlotTrajectory,EmeraldListLinePlot,
			Legend->unresolvedLegend,
			Tooltip->Replace[Lookup[safeOps,Tooltip],Automatic->Transpose[pics]],
			Sequence@@safeOpsFinal
		]
	];

	(* Construct table of ELLP outputs *)
	output=Lookup[safeOps,Output];
	ellpOutputTable=MapThread[Rule,If[MatchQ[output,_List],{output,ellpOutput},{{output},{ellpOutput}}]];

	(* Merge resolved ELLP options (excluding Epilog) with safe options *)
	outputTable=ellpOutputTable/.HoldPattern[Options->ellpOps_]:>(Options->ReplaceRule[safeOps,FilterRules[ellpOps,Except[Epilog]]]);

	(* Return the result, according to the output option *)
	output/.outputTable

];

PlotTrajectory::BadSpecies="The following species are not present in the Trajectory: `1`";
PlotTrajectory::NoSpecies="There are no valid species to plot";

trajectoryConcentrationSum[Trajectory[specs_List,concs_List,ts_List,uns_List]] :=
	Trajectory[{"ConcentrationSum"}, (List@*Total) /@ concs, ts, uns];

resolveSecondaryDataOption[op:Automatic,temps_,vols_]:=Module[{out={}},
	If[
		AnyTrue[temps,nonConstantSecondaryData],
		AppendTo[out,Temperature]
	];
	If[
		AnyTrue[vols,nonConstantSecondaryData],
		AppendTo[out,Volume]
	];
	out
];
resolveSecondaryDataOption[op_,temps_,vols_]:=ToList[op];
nonConstantSecondaryData[in_List]:= Length[DeleteDuplicates[in[[;;,2]]]]>1;
nonConstantSecondaryData[in_]:= False;



(* this identifies connected groups given an adjacency matrix *)
splitA[A_] :=
	Module[{AAt,connected},
		AAt = Simulation`Private`BoolOr[A,Transpose[A]];
		connected = NestWhile[Simulation`Private`BoolOr[#, AAt.#]&, IdentityMatrix[Length[A]], UnsameQ, 2];

		Gather[Range[Length[A]], connected[[#1,#2]]>0&]
	];

resolveInterpolationOrder[Stochastic]:=0;
resolveInterpolationOrder[{Stochastic..}]:=0;
resolveInterpolationOrder[other_]:=None;

reorganizeColors[rawColorListList:_List,allSpecies:_List,speciesListList:_List]:=Module[{inputColors,outputColors},
inputColors=rawColorListList;
outputColors=Table[
		Module[{positions,colors},
			positions=Function[
				curSpecies,
				Flatten[Position[allSpecies,curSpecies],1]
			]/@speciesListList[[i]];
			colors=First/@Extract[inputColors,positions];
			inputColors=Delete[inputColors,Append[#,1]&/@positions];
			colors
		],
	{i,1,Length[speciesListList]}
];
outputColors
];


resolveTargetUnitsPlotTrajectory[Automatic|{Automatic,Automatic},{xUnit_,yUnit_}]:={xUnit,yUnit};
resolveTargetUnitsPlotTrajectory[{Automatic,y_},{xUnit_,yUnit_}]:={xUnit,y};
resolveTargetUnitsPlotTrajectory[{x_,Automatic},{xUnit_,yUnit_}]:={x,yUnit};
resolveTargetUnitsPlotTrajectory[other_,{xUnit_,yUnit_}]:=other;


(* plot trajectories for SimulateMeltingCurve only *)
prologMeltingCurve[{trajMelt_, trajCool_}, yUnit_]:= Module[
	{amp, xyMelt, xyCool, colors},

	(* extract coordinates to create arrows *)
	(* Tried to use UnitConvert, and while tests passed locally, failed on Manifold. *)
	amp = UnitSimplify[trajMelt[YUnit]/Last[yUnit]];
	{xyMelt, xyCool} = {N[trajMelt[Coordinates]], N[trajCool[Coordinates]]}/.{a_Real,b_Real}:> {a, b*amp};

	(* assign colors to each species *)
	colors=Table[ColorFade[ColorData[97][i],2],{i, Length[xyMelt]}];

	(* plot curves with arrows *)
	Flatten[MapThread[
				{First[#1], Arrowheads[Medium], #2, Last[#1], Arrowheads[Medium], #3}&,
				{colors, Map[Arrow,Partition[#,2]&/@xyMelt,{2}], Map[Arrow,Partition[#,2]&/@xyCool,{2}]}
			], 1
		]

];
