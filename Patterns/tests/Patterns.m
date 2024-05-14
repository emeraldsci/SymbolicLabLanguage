(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Patterns: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Generic patterns*)


(* ::Subsubsection:: *)
(*DomainP*)


DefineTests[DomainP,{

	Example[{Basic,"A pattern that matches an integer domain:"},
		MatchQ[
			{1,2},
			DomainP[_Integer]
		],
		True
	],
	Example[{Basic,"Does not match if each element of the domain does not match given pattern:"},
		MatchQ[
			{2,4.5},
			DomainP[_Integer]
		],
		False
	],
	Example[{Basic,"Matches a domain whose first value is the same as the second:"},
		MatchQ[
			{1,1},
			DomainP[_Integer]
		],
		True
	],
	Example[{Basic,"Domain pattern for distances.  Note that the units can be different as long as they are compatible:"},
		MatchQ[
			{2Foot,1Meter},
			DomainP[UnitsP[Meter]]
		],
		True
	]


}];


(* ::Subsection:: *)
(*Locations*)


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*"NullP"*)


DefineTests[
	"NullP",
	{
		Example[{Basic,"Matches a single Null"},MatchQ[Null,NullP],True],
		Example[{Basic,"Matches a multidimensional list of Nulls"},MatchQ[{{Null,Null},Null},NullP],True],
		Example[{Basic,"No longer matches if non-Null items are added to the list"},MatchQ[{{Null,Null},Null,Rhymenoceros},NullP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"OptionCategoryP"*)


DefineTests[
	"OptionCategoryP",
	{
		Example[{Basic,"Matches a valid option category type."},MatchQ[General,OptionCategoryP],True],
		Example[{Basic,"Does not match an invalid option category type."},MatchQ[Beer,OptionCategoryP],False],
		Example[{Basic,"No longer matches if the input is a list"},MatchQ[{General,Protocol},OptionCategoryP],False],

		Test["Testing other valid option categories",
			MatchQ[Method,OptionCategoryP],
			True
		],
		Test["Testing other valid option categories",
			MatchQ[Protocol,OptionCategoryP],
			True
		],
		Test["Testing other valid option categories",
			MatchQ[Location,OptionCategoryP],
			True
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*"PlasticP"*)


DefineTests[
	"PlasticP",
	{
		Example[{Basic,"Matches a single plastic:"},MatchQ[Polypropylene,PlasticP],True],
		Example[{Basic,"Does not match an Taco:"},MatchQ[Taco,PlasticP],False],
		Example[{Basic,"Matches on FEP:"},MatchQ[FEP,PlasticP],True]
	}
];

(* ::Subsubsection::Closed:: *)
(*"DatabaseRefreshStatusP"*)


DefineTests[
	"DatabaseRefreshStatusP",
	{
		Example[{Basic,"Matches a specific pattern:"},MatchQ[Requested,DatabaseRefreshStatusP],True]
	}
];


(* ::Subsubsection::Closed:: *)
(*"WellTypeP"*)


DefineTests[
	"WellTypeP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[TransposedIndex,WellTypeP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",WellTypeP],False],
		Test["Testing correct Usage",MatchQ[StaggeredIndex,WellTypeP],True],
		Test["Testing incorrect integer input",MatchQ[5,WellTypeP],False],
		Test["Testing incorrect list input",MatchQ[{StaggeredIndex},WellTypeP],False]
	}
];



(* ::Subsubsection::Closed:: *)
(*"WellP"*)


DefineTests[
	"WellP",
	{
		Example[{Basic,"Correct Usage"},MatchQ["A1",WellP],True],
		Example[{Basic,"Correct Usage"},MatchQ[1,WellP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",WellP],False],
		Test["Testing incorrect input",MatchQ[{1,"A1"},WellP],False],
		Test["Testing incorrect list input",MatchQ[{"A1","A1","A1"},WellP],False]
	}
];


(* ::Subsection::Closed:: *)
(*Protocols*)


(* ::Subsubsection::Closed:: *)
(*"PeptideSynthesisStrategyP"*)


DefineTests[
	"PeptideSynthesisStrategyP",
	{
		Example[{Basic,"Matches on Fmoc"},
			MatchQ[Fmoc,PeptideSynthesisStrategyP],
			True
		],
		Example[{Basic,"Matches on Boc"},
			MatchQ[Boc,PeptideSynthesisStrategyP],
			True
		],
		Example[{Basic,"Does not match otherwise"},
			MatchQ[DNA,PeptideSynthesisStrategyP],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*"ProtectingGroupP"*)


DefineTests[
	"ProtectingGroupP",
	{
		Example[{Basic,"Matches on Fmoc"},
			MatchQ[Fmoc,ProtectingGroupP],
			True
		],
		Example[{Basic,"Matches on Boc"},
			MatchQ[Boc,ProtectingGroupP],
			True
		],
		Example[{Basic,"Matches on DMT"},
			MatchQ[DMT,ProtectingGroupP],
			True
		],
		Example[{Basic,"Does not match otherwise"},
			MatchQ[DNA,ProtectingGroupP],
			False
		]
	}
];


(* ::Subsection::Closed:: *)
(*SLL patterns*)


(* ::Subsubsection::Closed:: *)
(*"GradeP"*)


DefineTests[
	"GradeP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[Reagent,GradeP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",GradeP],False],
		Test["Testing correct Usage",MatchQ[HPLC,GradeP],True],
		Test["Testing incorrect integer input",MatchQ[5,GradeP],False],
		Test["Testing incorrect list input",MatchQ[{Reagent},GradeP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"FocusingElementP"*)


DefineTests[
	"FocusingElementP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[GuideWire,FocusingElementP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",FocusingElementP],False],
		Test["Testing correct Usage",MatchQ[ElectrostaticLens,FocusingElementP],True],
		Test["Testing incorrect integer input",MatchQ[5,FocusingElementP],False],
		Test["Testing incorrect list input",MatchQ[{ElectrostaticLens},FocusingElementP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"IonModeP"*)


DefineTests[
	"IonModeP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[Negative,IonModeP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",IonModeP],False],
		Test["Testing correct Usage",MatchQ[Positive,IonModeP],True],
		Test["Testing incorrect integer input",MatchQ[5,IonModeP],False],
		Test["Testing incorrect list input",MatchQ[{Positive},IonModeP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"IonSourceP"*)


DefineTests[
	"IonSourceP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[ESI,IonSourceP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",IonSourceP],False],
		Test["Testing correct Usage",MatchQ[MALDI,IonSourceP],True],
		Test["Testing incorrect integer input",MatchQ[5,IonSourceP],False],
		Test["Testing incorrect list input",MatchQ[{MALDI},IonSourceP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"AcquisitionModeP"*)


DefineTests[
	"AcquisitionModeP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[MS,AcquisitionModeP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",AcquisitionModeP],False],
		Test["Testing correct Usage",MatchQ[MSMS,AcquisitionModeP],True],
		Test["Testing incorrect integer input",MatchQ[5,AcquisitionModeP],False],
		Test["Testing incorrect list input",MatchQ[{MSMS},AcquisitionModeP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"NeedleGaugeP"*)


DefineTests[
	"NeedleGaugeP",
	{
		Example[{Basic,"Correct Usage"},MatchQ["7",NeedleGaugeP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ["Taco",NeedleGaugeP],False],
		Test["Testing correct Usage",MatchQ["22s",NeedleGaugeP],True],
		Test["Testing incorrect integer input",MatchQ[5,NeedleGaugeP],False],
		Test["Testing incorrect list input",MatchQ[{"22s"},NeedleGaugeP],False]
	}
];


(* ::Subsubsection::Closed:: *)
(*"SpottingMethodP"*)


DefineTests[
	"SpottingMethodP",
	{
		Example[{Basic,"Correct Usage"},MatchQ[Sandwich,SpottingMethodP],True],
		Example[{Basic,"Testing incorrect Usage"},MatchQ[Taco,SpottingMethodP],False],
		Test["Testing correct Usage",MatchQ[OpenFace,SpottingMethodP],True],
		Test["Testing incorrect integer input",MatchQ[5,SpottingMethodP],False],
		Test["Testing incorrect list input",MatchQ[{Sandwich},SpottingMethodP],False]
	}
];



(* ::Subsection::Closed:: *)
(*Files*)


(* ::Subsubsection::Closed:: *)
(*"ContextP"*)


DefineTests[
	"ContextP",
	{
		Example[{Basic,"Matches if file ends with `"},
			MatchQ["Core`",ContextP],
			True
		],
		Example[{Basic,"Does not match otherwise"},
			MatchQ["fake.txt",ContextP],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*"XmlFileP"*)


DefineTests[
	"XmlFileP",
	{
		Example[{Basic,"Matches if file ends with .xml"},
			MatchQ[FileNameJoin[{"PDFs","testLib.xml"}],XmlFileP],
			True
		],
		Example[{Basic,"Does not match otherwise"},
			MatchQ["fake.txt",XmlFileP],
			False
		]
	}
];


(* ::Subsection:: *)
(*Unit coordinate comparisons*)


(* ::Subsubsection::Closed:: *)
(*DateCoordinatesComparisonP*)


DefineTests[DateCoordinatesComparisonP,{

	Example[{Basic,"Check if y-values are greater than a certain temperature:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[GreaterP[0*Celsius]]],
		True
	],
	Example[{Basic,"Check if y-values are in a given temperature range:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[RangeP[0*Kelvin,50Celsius]]],
		True
	],

	Example[{Basic,"Does not match if y-values don't all satisfy comparison criteria:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[GreaterP[10000*Kelvin]]],
		False
	],
	Example[{Basic,"Does not match if y-values don't all lie in given range:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[RangeP[0*Kelvin,20Celsius]]],
		False
	],
	Test["Does not match quantities against numbers:",
		MatchQ[dateCoords,DateCoordinatesComparisonP[GreaterP[0]]],
		False
	],

	Example[{Basic,"Y-values can be numeric:"},
		MatchQ[{
			{Now-Week, 10},
			{Now-Day, 15.},
			{Now, 20},
			{Now+Day, 25},
			{Now+Week, 30}
		},DateCoordinatesComparisonP[GreaterP[0]]],
		True
	],
	Test["Unit pattern will not match numeric Y-values:",
		MatchQ[{
			{Now-Week, 10},
			{Now-Day, 15.},
			{Now, 20},
			{Now+Day, 25},
			{Now+Week, 30}
		},DateCoordinatesComparisonP[GreaterP[0*Meter]]],
		False
	],

	Example[{Additional,"This function applies the quantity comparison in a much faster way than a pattern that checks the y-values directly against the comparison:"},
		With[{bigDateCoords=Transpose[
			{
				DateObject/@Table[{2017, 1, 2, 3, 0 + min, 5.}, {min, 0, 60, 0.04}],
				Quantity[Table[n, {n, 0, 60, 0.04}], "Meters"]}]
			},
			{
				AbsoluteTiming[MatchQ[bigDateCoords,DateCoordinatesComparisonP[RangeP[0Meter,1Kilometer]]]],
				AbsoluteTiming[MatchQ[bigDateCoords,{{_?DateObjectQ,RangeP[0Meter,1Kilometer]}..}]]
			}
		],
		{{_Real,True},{_Real,True}}
	],

	Example[{Messages,"InvalidComparisonPattern","Comparison pattern must be an unevaluated comparison expression:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[123]],
		False,
		Messages:>{DateCoordinatesComparisonP::InvalidComparisonPattern}
	],

	Example[{Attributes,HoldFirst,"The comparison pattern is held so it can be parsed.  If it is evaluated, the function cannot properly interpret it:"},
		MatchQ[dateCoords,DateCoordinatesComparisonP[Evaluate[RangeP[0*Kelvin,20Celsius]]]],
		False,
		Messages:>{DateCoordinatesComparisonP::InvalidComparisonPattern}
	]

},
SetUp:>{
	dateCoords = {
		{Now-Week, 10Celsius},
		{Now-Day, 15Celsius},
		{Now, 20Celsius},
		{Now+Day, 25Celsius},
		{Now+Week, 30Celsius}
	}
}
];



(* ::Subsection:: *)
(*NA patterns*)


(* ::Subsubsection:: *)
(*ReactionP*)


DefineTests["ReactionP",{

	Test["Reaction 1-1 irrev:",	MatchQ[Reaction[{a},{b},kf],ReactionP],	True	],
	Test["Reaction 1-1 rev:",	MatchQ[Reaction[{a},{b},kf,kb],ReactionP],	True	],
	Test["Reaction 2-1 irrev:",	MatchQ[Reaction[{a,b},{c},kf],ReactionP],	True	],
	Test["Reaction 2-1 rev:",	MatchQ[Reaction[{a,b},{c},kf,kb],ReactionP],	True	],
	Test["Reaction 1-2 irrev:",	MatchQ[Reaction[{a},{b,c},kf],ReactionP],	True	],
	Test["Reaction 1-2 rev:",	MatchQ[Reaction[{a},{b,c},kf,kb],ReactionP],	True	],
	Test["Reaction 2-2 irrev:",	MatchQ[Reaction[{a,b},{c,d},kf],ReactionP],	True	],
	Test["Reaction 2-2 rev:",	MatchQ[Reaction[{a,b},{c,d},kf,kb],ReactionP],	True	],
	Test["Reaction 1-3 irrev:",	MatchQ[Reaction[{a},{b,c,d},kf],ReactionP],	True	],
	Test["Reaction 1-3 rev, no match:",	MatchQ[Reaction[{a},{b,c,d},kf,kb],ReactionP],	False	],
	Test["Reaction 1-7 irrev:",	MatchQ[Reaction[{a},{b,c,c,d,e,e,e},kf],ReactionP],	True	],
	Test["Reaction 1-7 rev, no match:",	MatchQ[Reaction[{a},{b,c,c,d,e,e,e},kf,kb],ReactionP],	False	],
	Test["Reaction 3-1 irrev, no match:",	MatchQ[Reaction[{a,b,c},{d},kf],ReactionP],	False	],
	Test["Reaction 3-1 rev, no match:",	MatchQ[Reaction[{a,b,c},{d},kf],ReactionP],	False	]
}];


(* ::Subsubsection:: *)
(*ImplicitReactionP*)


DefineTests["ImplicitReactionP",{

	Test["Reaction rev rate mismatch:",	MatchQ[{a->b,kf,kb},ImplicitReactionP],	False	],
	Test["Reaction irrev rate mismatch:",	MatchQ[{a \[Equilibrium] b,kf},ImplicitReactionP],	False	],
	Test["Reaction 1-1 irrev:",	MatchQ[{a->b,kf},ImplicitReactionP],	True	],
	Test["Reaction 1-1 rev:",	MatchQ[{a \[Equilibrium] b,kf,kb},ImplicitReactionP],	True	],
	Test["Reaction 2-1 irrev:",	MatchQ[{a+b->c,kf},ImplicitReactionP],	True	],
	Test["Reaction 2-1 rev:",	MatchQ[{a+b \[Equilibrium] c,kf,kb},ImplicitReactionP],	True	],
	Test["Reaction 1-2 irrev:",	MatchQ[{a->b+c,kf},ImplicitReactionP],	True	],
	Test["Reaction 1-2 rev:",	MatchQ[{a \[Equilibrium] b+c,kf,kb},ImplicitReactionP],	True	],
	Test["Reaction 2-2 irrev:",	MatchQ[{a+b->c+d,kf},ImplicitReactionP],	True	],
	Test["Reaction 2-2 rev:",	MatchQ[{a+b \[Equilibrium] c+d,kf,kb},ImplicitReactionP],	True	],
	Test["Reaction 1-3 irrev:",	MatchQ[{a->b+c+d,kf},ImplicitReactionP],	True	],
	Test["Reaction 1-3 rev, no match:",	MatchQ[{a\[Equilibrium]b+c+d,kf,kb},ImplicitReactionP],	False	],
	Test["Reaction 1-7 irrev:",	MatchQ[{a -> b+2c+d+3e,kf},ImplicitReactionP],	True	],
	Test["Reaction 1-7 rev, no match:",	MatchQ[{a \[Equilibrium] b+2c+d+3d,kf,kb},ImplicitReactionP],	False	],
	Test["Reaction 3-1 irrev, no match:",	MatchQ[{a+b+c -> d,kf},ImplicitReactionP],	False	],
	Test["Reaction 3-1 rev, no match:",	MatchQ[{a+b+c \[Equilibrium] d,kf,kb},ImplicitReactionP],	False	]
}];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskQ*)


DefineTests[
	RosettaTaskQ,
	{
		Example[{Basic,"Returns True when input association is a valid Rosetta Task definition:"},
			RosettaTaskQ[
				Association[
					"TaskType" -> ResourcePicking,
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Fields" -> {Field[SamplesIn],Field[ContainersOut]}
					]
				]
			],
			True
		],
		Example[{Basic,"Specify a specific TaskType that the input association must define:"},
			RosettaTaskQ[
				Association[
					"TaskType" -> Instruction,
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Template" -> {"Turn on the software on the ",Field[Instrument[Computer][Name]]," computer"},
						"Screenshots" -> {}
					]
				],
				Instruction
			],
			True
		],
		Example[{Basic,"Returns False if the input association is an invalid task definition:"},
			RosettaTaskQ[
				Association[
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Template" -> {"Turn on the software on the ",Field[Instrument[Computer][Name]]," computer"},
						"Screenshots" -> {}
					]
				]
			],
			False
		],
		Example[{Additional,"Returns False if the input association is a valid task definition but not of the specified TaskType:"},
			RosettaTaskQ[
				Association[
					"TaskType" -> Instruction,
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Template" -> {"Turn on the software on the ",Field[Instrument[Computer][Name]]," computer"},
						"Screenshots" -> {}
					]
				],
				ResourcePicking
			],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskP*)


DefineTests[
	RosettaTaskP,
	{
		Example[{Basic,"Returns pattern that matches a valid Rosetta Task definition:"},
			RosettaTaskP[],
			_KeyValuePattern
		],
		Example[{Basic,"Specify a specific TaskType that the task must define:"},
			MatchQ[
				Association[
					"TaskType" -> Instruction,
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Template" -> {"Turn on the software on the ",Field[Instrument[Computer][Name]]," computer"},
						"Screenshots" -> {}
					]
				],
				RosettaTaskP[Instruction]
			],
			True
		],
		Example[{Basic,"Returns False if the input association is an invalid task definition:"},
			MatchQ[
				Association[
					"ID" -> CreateUUID[],
					"Args" -> Association[
						"Template" -> {"Turn on the software on the ",Field[Instrument[Computer][Name]]," computer"},
						"Screenshots" -> {}
					]
				],
				RosettaTaskP[]
			],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PolymerQ*)

DefineTests[PolymerQ,
	{
		Example[{Basic,"Returns True for a publically known polymer type:"},
			PolymerQ[DNA],
			True,
			Stubs:>{
				(*Ensure AllPolymerP uses default values*)
				$PersonID={}
			}
		],

		Example[{Basic,"Returns True for the properly uploaded Model[Physics,Oligomer,\"XNAPolymerQ\"]:"},
			PolymerQ[Global`XNAPolymerQ],
			True,
			Stubs:>{
				(*Ensure AllPoymerP is repopulated with search*)
				$PersonID = Object[User,"TestUser"],
				$RequiredSearchName = "XNAPolymerQ",
				$DeveloperSearch =True
			}
		],

		Example[{Basic,"Returns False for an oligomer which is not uploaded:"},
			PolymerQ[NonExistent],
			False,
			Stubs:>{
				(*Ensure AllPolymerP uses default values*)
				$PersonID={}
			}
		]

	},

	SetUp:>{
		ClearMemoization[];

		(* Reset the ownvalues of AllPolymersP and reloading the file Pattern to update the ownvalue of AllPolymersP *)
		OwnValues[AllPolymersP]={};

		(* Generate all possible oligomers *)
		AllPolymersP:=Module[{defaultOligomers,availableOligomers},

			(* Default list of public oligomers *)
			defaultOligomers={DNA,RNA,RNAtom,RNAtbdms,LDNA,LRNA,LNAChimera,PNA,GammaLeftPNA,GammaRightPNA,Peptide,Modification};

			(* Removing all white spaces and numbers and taking the first 10 characters *)
			availableOligomers=If[MatchQ[$PersonID,ObjectP[Object[User]]],
				Join[
					(
						(* Add Global context head if there is a new symbol *)
						If[MemberQ[defaultOligomers,Symbol[#]],
							Symbol[#],
							Symbol["Global`"<>#]
						]& /@ (Map[#[Name]&, Search[Model[Physics, Oligomer]]])
					),
					{Modification}
				],
				defaultOligomers
			];

			(* If the user is logged-in, Memoize the result so we don't search/download each time this function is called *)
			If[MatchQ[$PersonID,ObjectP[Object[User]]],
				AllPolymersP=availableOligomers,
				availableOligomers
			]
		];
	},

	SymbolSetUp:>{

		(* Reset the exported variable $CreatedObjects *)
		$CreatedObjects={};

		(* Assigning the person ID *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"];

		(* Helper Function: to convert the rules for DegenerateAphabet to *)
		reformatDegenerateAlphabet[myRule_]:=Module[{first,lasts,firsts},
			first=First[myRule];
			lasts=Last[myRule];
			firsts=If[lasts==={},first,Repeat[first,Length[lasts]]];
			If[lasts==={},{{first,Null}},Transpose[{firsts,lasts}]]
		];

		(* <<< Generating the model physics object XNA which has a bad WildcardMonomer >>> *)

		(* Degenerate alphabet rules for XNA *)
		degenerateAlphabetXNA={"N"->{"A","G","T","C"},"B"->{"C","G","T"},"D"->{"A","G","T"},"H"->{"A","C","T"},"V"->{"A","C","G"},"W"->{"A","T"},"S"->{"C","G"},"M"->{"A","C"},"K"->{"G","T"},"R"->{"A","G"},"Y"->{"C","T"},"X"->{}};

		modelOligomerXNAPacket=
			<|
				Name->"XNAPolymerQ",
				Type->Model[Physics,Oligomer],
				Append[Authors]->Link[$PersonID],
				Replace[Alphabet]->{"P","G","T","C"},
				Replace[DegenerateAlphabet]->Join@@reformatDegenerateAlphabet/@degenerateAlphabetXNA,
				WildcardMonomer->"N",
				NullMonomer->"X",
				Replace[Complements]->{"T","C","A","G"},
				Replace[Pairing]->{{"T"},{"C"},{"A"},{"G"}},
				Replace[AlternativeEncodings]->{{"a"->"A","t"->"T","g"->"G","c"->"C","n"->"N","b"->"B","d"->"D","h"->"H","v"->"V","w"->"W","s"->"S","m"->"M","k"->"K","r"->"R","y"->"Y","x"->"X"}},
				Replace[MonomerMass]->{313.21` GramPerMole ,329.21` GramPerMole, 304.19 GramPerMole,289.18` GramPerMole},
				InitialMass->1.01` GramPerMole,
				TerminalMass->-62.97` GramPerMole,
				DeveloperObject->True
			|>;

		(* The object with first level parameters *)
		modelOligomerXNAObject=Upload[modelOligomerXNAPacket];

	},

	SymbolTearDown:>{
		(* Erasing the created model physics object *)
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];

		(* Reset the person ID so it emulates the condition that no one has logged-in yet *)
		$PersonID={};

		(* Reset the ownvalues of AllPolymersP and reloading the file Pattern to update the ownvalue of AllPolymersP *)
		OwnValues[AllPolymersP]={};

		(* Generate all possible oligomers normally*)
		AllPolymersP:=Module[{defaultOligomers,availableOligomers},

			(* Default list of public oligomers *)
			defaultOligomers={DNA,RNA,RNAtom,RNAtbdms,LDNA,LRNA,LNAChimera,PNA,GammaLeftPNA,GammaRightPNA,Peptide,Modification};

			(* Removing all white spaces and numbers and taking the first 10 characters *)
			availableOligomers=If[MatchQ[$PersonID,ObjectP[Object[User]]],
				Join[
					(
						(* Add Global context head if there is a new symbol *)
						If[MemberQ[defaultOligomers,Symbol[#]],
							Symbol[#],
							Symbol["Global`"<>#]
						]& /@ (Map[#[Name]&, Search[Model[Physics, Oligomer]]])
					),
					{Modification}
				],
				defaultOligomers
			];

			(* If the user is logged-in, Memoize the result so we don't search/download each time this function is called *)
			If[MatchQ[$PersonID,ObjectP[Object[User]]],
				AllPolymersP=availableOligomers,
				availableOligomers
			]
		];

		$PersonID=myPersonID;
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}

];


(* ::Subsubsection:: *)
(*AffinityLabelP*)


DefineTests[AffinityLabelP,{

	Example[{Basic,"A pattern that matches a molecule with AffinityLabel->True:"},
		MatchQ[
			Model[Molecule, "AffinityLabelP test object 1 " <> $SessionUUID],
			AffinityLabelP[]
		],
		True,
		SetUp:>{
			Upload[<|Type -> Model[Molecule], Name -> "AffinityLabelP test object 1 " <> $SessionUUID, AffinityLabel -> True, DetectionLabel -> False, DeveloperObject->True|>]
		},
		TearDown:>{
			Quiet[EraseObject[Model[Molecule,"AffinityLabelP test object 1 "<>$SessionUUID],Force->True,Verbose->False]]
		}
	],
	Example[{Basic,"Does not match if a molecule with AffinityLabel->False:"},
		MatchQ[
			Model[Molecule, "AffinityLabelP test object 2 " <> $SessionUUID],
			AffinityLabelP[]
		],
		False,
		SetUp:>{
			Upload[<|Type -> Model[Molecule], Name -> "AffinityLabelP test object 2 " <> $SessionUUID, AffinityLabel -> False, DetectionLabel -> False, DeveloperObject->True|>]
		},
		TearDown:>{
			Quiet[EraseObject[Model[Molecule, "AffinityLabelP test object 2 " <> $SessionUUID],Force->True,Verbose->False]]
		}
	],
	Example[{Basic,"Does not match if a type that is not Model[Molecule]:"},
		MatchQ[
			Model[Sample, "Milli-Q water"],
			AffinityLabelP[]
		],
		False
	]
	},
	Stubs:>{
		$DeveloperSearch = True
	}
];



(* ::Subsubsection:: *)
(*DetectionLabelP*)


DefineTests[DetectionLabelP,{

	Example[{Basic,"A pattern that matches a molecule with DetectionLabel->True:"},
		MatchQ[
			Model[Molecule, "DetectionLabelP test object 1 " <> $SessionUUID],
			DetectionLabelP[]
		],
		True,
		SetUp:>{
			Upload[<|Type -> Model[Molecule], Name -> "DetectionLabelP test object 1 " <> $SessionUUID, AffinityLabel -> True, DetectionLabel -> True, DeveloperObject->True|>]
		},
		TearDown:>{
			Quiet[EraseObject[Model[Molecule, "DetectionLabelP test object 1 " <> $SessionUUID],Force->True,Verbose->False]]
		}
	],
	Example[{Basic,"Does not match if a molecule with DetectionLabel->False:"},
		MatchQ[
			Model[Molecule, "DetectionLabelP test object 2 " <> $SessionUUID],
			DetectionLabelP[]
		],
		False,
		SetUp:>{
			Upload[<|Type -> Model[Molecule], Name -> "DetectionLabelP test object 2 " <> $SessionUUID, AffinityLabel -> False, DetectionLabel -> False, DeveloperObject->True|>]
		},
		TearDown:>{
			Quiet[EraseObject[Model[Molecule, "DetectionLabelP test object 2 " <> $SessionUUID],Force->True,Verbose->False]]
		}
	],
	Example[{Basic,"Does not match if a type that is not Model[Molecule]:"},
		MatchQ[
			Model[Sample, "Milli-Q water"],
			AffinityLabelP[]
		],
		False
	]
	},
	Stubs:>{
		$DeveloperSearch = True
	}
];

(* ::Subsubsection::Closed:: *)
(*AreaMeasurementAssociationQ*)


DefineTests[
	AreaMeasurementAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			AreaMeasurementAssociationQ[<|
					Count->0.9,
					Area->9.5,
					FilledCount->0.4,
					EquivalentDiskRadius->0.7,
					AreaRadiusCoverage->Null
				|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			AreaMeasurementAssociationQ[<|
				Count->0.9,
				AreaRadiusCoverage->Null,
				Area->9.5,
				FilledCount->0.4,
				EquivalentDiskRadius->0.7
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			AreaMeasurementAssociationQ[<|
				Count->0.9,
				Area->9.5,
				FilledCount->0.4,
				AreaRadiusCoverage->Null
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching GreaterEqualP[0]|Null:"},
			AreaMeasurementAssociationQ[<|
				Count->0.9,
				Area->9.5,
				FilledCount->0.4,
				EquivalentDiskRadius->6Second,
				AreaRadiusCoverage->Null
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*BestfitEllipseAssociationQ*)


DefineTests[
	BestfitEllipseAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			BestfitEllipseAssociationQ[<|
				Length->0.9,
				Width->0.7,
				SemiAxes->{0.9,0.7},
				Orientation->0.5Pi,
				Elongation->0.8,
				Eccentricity->0.5
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			BestfitEllipseAssociationQ[<|
				Length->Null,
				Width->0.7,
				SemiAxes->{0.9,0.7},
				Elongation->0.8,
				Eccentricity->0.5,
				Orientation->0.5Pi
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			BestfitEllipseAssociationQ[<|
				Length->0.9,
				Width->0.7,
				SemiAxes->{0.9,0.7},
				Elongation->0.8,
				Eccentricity->0.5
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			BestfitEllipseAssociationQ[<|
				Length->0.9,
				Width->0.7,
				SemiAxes->{0.9,0.7},
				Orientation->5Pi,
				Elongation->0.8,
				Eccentricity->0.5
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*BoundingboxPropertiesAssociationQ*)


DefineTests[
	BoundingboxPropertiesAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			BoundingboxPropertiesAssociationQ[<|
				Contours->{1,4,5},
				BoundingBox->Null,
				BoundingBoxArea->0.9,
				MinimalBoundingBox->{{1,2},{3,4.8}}
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			BoundingboxPropertiesAssociationQ[<|
				Contours->{1,4,5},
				BoundingBoxArea->0.9,
				BoundingBox->Null,
				MinimalBoundingBox->{{1,2},{3,4.8}}
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			BoundingboxPropertiesAssociationQ[<|
				Contours->{1,4,5},
				BoundingBox->Null,
				MinimalBoundingBox->{{1,2},{3,4.8}}
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			BoundingboxPropertiesAssociationQ[<|
				Contours->1,
				BoundingBox->Null,
				BoundingBoxArea->0.9,
				MinimalBoundingBox->{{1,2},{3,4.8}}
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*CellConcentrationQ*)


DefineTests[
	CellConcentrationQ,
	{
		Example[
			{Basic,"Association Matches pattern of cells per microliter:"},
			CellConcentrationQ[50Cell/Microliter],
			True
		],
		Example[
			{Basic,"Association Matches pattern of cells per milliliter:"},
			CellConcentrationQ[50Cell/Milliliter],
			True
		],
		Example[
			{Basic,"Association does not match pattern of cells per volume:"},
			CellConcentrationQ[50Gram/Milliliter],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*CFUConcentrationQ*)


DefineTests[
	CFUConcentrationQ,
	{
		Example[
			{Basic,"Association Matches pattern of CFU per microliter:"},
			CFUConcentrationQ[50 CFU/Microliter],
			True
		],
		Example[
			{Basic,"Association Matches pattern of CFU per milliliter:"},
			CFUConcentrationQ[50 CFU/Milliliter],
			True
		],
		Example[
			{Basic,"Association does not match pattern of CFU per volume:"},
			CFUConcentrationQ[50 Gram / Milliliter],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*BoundingboxPropertiesAssociationQ*)


DefineTests[
	CentroidPropertiesAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			CentroidPropertiesAssociationQ[<|
				Centroid->{1,0.9},
				Medoid->{8,9},
				MeanCentroidDistance->0.6,
				MaxCentroidDistance->0.9,
				MinCentroidDistance->Null
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			CentroidPropertiesAssociationQ[<|
				MeanCentroidDistance->0.6,
				Centroid->{1,0.9},
				Medoid->{8,9},
				MaxCentroidDistance->0.9,
				MinCentroidDistance->Null
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			CentroidPropertiesAssociationQ[<|
				Centroid->{1,0.9},
				Medoid->{8,9},
				MaxCentroidDistance->0.9,
				MinCentroidDistance->Null
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			CentroidPropertiesAssociationQ[<|
				Centroid->{1,0.9},
				Medoid->{8,9},
				MeanCentroidDistance->6Meter,
				MaxCentroidDistance->0.9,
				MinCentroidDistance->Null
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ImageIntensityAssociationQ*)


DefineTests[
	ImageIntensityAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			ImageIntensityAssociationQ[<|
				MinIntensity->0.1,
				MaxIntensity->0.9,
				MeanIntensity->0.8,
				MedianIntensity->0.7,
				StandardDeviationIntensity->0.1,
				TotalIntensity->7,
				Skew->Indeterminate,
				IntensityCentroid->{6,8}
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			ImageIntensityAssociationQ[<|
				MedianIntensity->0.7,
				MinIntensity->0.1,
				MaxIntensity->0.9,
				MeanIntensity->0.8,
				StandardDeviationIntensity->0.1,
				TotalIntensity->7,
				Skew->Indeterminate,
				IntensityCentroid->{6,8}
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			ImageIntensityAssociationQ[<|
				MinIntensity->0.1,
				MaxIntensity->0.9,
				MeanIntensity->0.8,
				MedianIntensity->0.7,
				StandardDeviationIntensity->0.1,
				TotalIntensity->7,
				IntensityCentroid->{6,8}
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			ImageIntensityAssociationQ[<|
				MinIntensity->1.1,
				MaxIntensity->0.9,
				MeanIntensity->0.8,
				MedianIntensity->0.7,
				StandardDeviationIntensity->0.1,
				TotalIntensity->7,
				Skew->Indeterminate,
				IntensityCentroid->{6,8}
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*PerimeterPropertiesAssociationQ*)


DefineTests[
	PerimeterPropertiesAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			PerimeterPropertiesAssociationQ[<|
				AuthalicRadius->6,
				MaxPerimeterDistance->8.9,
				OuterPerimeterCount->6.6,
				PerimeterCount->9.8,
				PerimeterLength->9.4,
				PerimeterPositions->Null,
				PolygonalLength->7.6
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			PerimeterPropertiesAssociationQ[<|
				PerimeterLength->9.4,
				AuthalicRadius->6,
				MaxPerimeterDistance->8.9,
				OuterPerimeterCount->6.6,
				PerimeterCount->9.8,
				PerimeterPositions->Null,
				PolygonalLength->7.6
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			PerimeterPropertiesAssociationQ[<|
				AuthalicRadius->6,
				MaxPerimeterDistance->8.9,
				OuterPerimeterCount->6.6,
				PerimeterCount->9.8,
				PerimeterPositions->Null,
				PolygonalLength->7.6
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			PerimeterPropertiesAssociationQ[<|
				AuthalicRadius->6Meter,
				MaxPerimeterDistance->8.9,
				OuterPerimeterCount->6.6,
				PerimeterCount->9.8,
				PerimeterLength->9.4,
				PerimeterPositions->Null,
				PolygonalLength->7.6
			|>],
			False
		]
	}
];

	(* ::Subsubsection::Closed:: *)
(*ShapeMeasurementsAssociationQ*)


DefineTests[
	ShapeMeasurementsAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			ShapeMeasurementsAssociationQ[<|
				Rectangularity->8.9,
				Circularity->7.8,
				FilledCircularity->9.8
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			ShapeMeasurementsAssociationQ[<|
				Circularity->7.8,
				FilledCircularity->9.8,
				Rectangularity->Null
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			ShapeMeasurementsAssociationQ[<|
				Rectangularity->8.9,
				Circularity->7.8
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			ShapeMeasurementsAssociationQ[<|
				Rectangularity->8.9,
				Circularity->7.8,
				FilledCircularity->9.8Meter
			|>],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*TopologicalPropertiesAssociationQ*)


DefineTests[
	TopologicalPropertiesAssociationQ,
	{
		Example[
			{Basic,"Association Matches pattern:"},
			TopologicalPropertiesAssociationQ[<|
				Fragmentation->8,
				Holes->5,
				Complexity->6,
				EulerNumber->Null,
				EmbeddedComponents->{8,7},
				EmbeddedComponentCount->0,
				EnclosingComponents->{9,9,7},
				EnclosingComponentCount->15
			|>],
			True
		],
		Example[
			{Basic,"Association Matches pattern with keys in different order:"},
			TopologicalPropertiesAssociationQ[<|
				Fragmentation->8,
				Holes->5,
				EmbeddedComponentCount->0,
				Complexity->6,
				EulerNumber->Null,
				EmbeddedComponents->{8,7},
				EnclosingComponents->{9,9,7},
				EnclosingComponentCount->15
			|>],
			True
		],
		Example[
			{Basic,"Association if missing a key:"},
			TopologicalPropertiesAssociationQ[<|
				Fragmentation->8,
				Holes->5,
				EmbeddedComponentCount->0,
				Complexity->6,
				EulerNumber->Null,
				EmbeddedComponents->{8,7},
				EnclosingComponents->{9,9,7}
			|>],
			False
		],
		Example[
			{Basic,"Association has a value not matching their patterns:"},
			TopologicalPropertiesAssociationQ[<|
				Fragmentation->8.9,
				Holes->5,
				EmbeddedComponentCount->0,
				Complexity->6,
				EulerNumber->Null,
				EmbeddedComponents->{8,7},
				EnclosingComponents->{9,9,7},
				EnclosingComponentCount->15
			|>],
			False
		]
	}
];
(* ::Subsection:: *)
(* Sample History Cards *)

(* ::Subsubsection:: *)
(*Initialized*)

DefineTests[Initialized,
	{
		Example[{Basic, "Initialized sample history card indicates when the sample object was first created:"},
			Initialized[
				Date -> Now,
				ResponsibleParty -> $PersonID,
				Amount -> 1 Milliliter,
				Composition -> {
					{100 VolumePercent, Model[Molecule, "Water"]}
				},
				Model -> Model[Sample, "Milli-Q water"],
				Container -> Object[Container, "Test container for Initialized tests"],
				ContainerModel -> Model[Container, Vessel, "2mL Tube"],
				Position -> "A1"
			],
			_Initialized
		],
		Example[{Basic, "Upload an Initialized sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Initialized[
							Date -> Now,
							ResponsibleParty -> $PersonID,
							Amount -> 1 Milliliter,
							Composition -> {
								{100 VolumePercent, Model[Molecule, "Water"]}
							},
							Model -> Model[Sample, "Milli-Q water"],
							Container -> Object[Container, "Test container for Initialized tests"],
							ContainerModel -> Model[Container, Vessel, "2mL Tube"],
							Position -> "A1"
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Initialized},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(*ExperimentStarted*)

DefineTests[ExperimentStarted,
	{
		Example[{Basic, "ExperimentStarted sample history card indicates when the sample object was first picked to use in a protocol:"},
			ExperimentStarted[
				Date -> Now,
				Protocol -> Object[Protocol, ManualSamplePreparation, "Test protocol for ExperimentStarted tests"],
				Subprotocol -> Object[Protocol, Transfer, "Test subprotocol for ExperimentStarted tests"],
				Role -> LabeledObjects
			],
			_ExperimentStarted
		],
		Example[{Basic, "Upload an ExperimentStarted sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						ExperimentStarted[
							Date -> Now,
							Protocol -> Object[Protocol, ManualSamplePreparation, "Test protocol for ExperimentStarted tests"],
							Subprotocol -> Object[Protocol, Transfer, "Test subprotocol for ExperimentStarted tests"],
							Role -> LabeledObjects
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_ExperimentStarted},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* ExperimentEnded *)

DefineTests[ExperimentEnded,
	{
		Example[{Basic, "ExperimentEnded sample history card indicates when the sample object was stored after being used in a protocol:"},
			ExperimentEnded[
				Date -> Now,
				Protocol -> Object[Protocol, ManualSamplePreparation, "Test protocol for ExperimentEnded tests"],
				Subprotocol -> Object[Protocol, Transfer, "Test subprotocol for ExperimentEnded tests"],
				StorageConditions -> Model[StorageCondition, "Ambient Storage"],
				Location -> Object[Container, Shelf, "Test shelf for ExperimentEnded tests"]
			],
			_ExperimentEnded
		],
		Example[{Basic, "Upload an ExperimentEnded sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						ExperimentEnded[
							Date -> Now,
							Protocol -> Object[Protocol, ManualSamplePreparation, "Test protocol for ExperimentEnded tests"],
							Subprotocol -> Object[Protocol, Transfer, "Test subprotocol for ExperimentEnded tests"],
							StorageCondition -> Model[StorageCondition, "Ambient Storage"],
							Location -> Object[Container, Vessel, "Test container for ExperimentEnded tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_ExperimentEnded},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Centrifuged *)

DefineTests[Centrifuged,
	{
		Example[{Basic, "Centrifuged sample history card indicates when the sample object was centrifuged:"},
			Centrifuged[
				Date -> Now,
				Protocol -> Object[Protocol, Centrifuge, "Test protocol for Centrifuged tests"],
				InstrumentModel -> Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"],
				Rate -> 1000 RPM,
				Time -> 5 Minute,
				Temperature -> Ambient
			],
			_Centrifuged
		],
		Example[{Basic, "Upload a Centrifuged sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Centrifuged[
							Date -> Now,
							Protocol -> Object[Protocol, Centrifuge, "Test protocol for Centrifuged tests"],
							InstrumentModel -> Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"],
							Rate -> 1000 RPM,
							Time -> 5 Minute,
							Temperature -> Ambient
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Centrifuged},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Incubated *)

DefineTests[Incubated,
	{
		Example[{Basic, "Incubated sample history card indicates when the sample object was incubated/mixed:"},
			Incubated[
				Date -> Now,
				Protocol -> Object[Protocol, Incubate, "Test protocol for Incubated tests"],
				InstrumentModel -> Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"],
				MixType -> Stir,
				Time -> 5 Minute,
				Temperature -> 70 Celsius,
				Rate -> 200 RPM
			],
			_Incubated
		],
		Example[{Basic, "Upload a Incubated sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Incubated[
							Date -> Now,
							Protocol -> Object[Protocol, Incubate, "Test protocol for Incubated tests"],
							InstrumentModel -> Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"],
							MixType -> Stir,
							Time -> 5 Minute,
							Temperature -> 70 Celsius,
							Rate -> 200 RPM
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Incubated},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Evaporated *)

DefineTests[Evaporated,
	{
		Example[{Basic, "Evaporated sample history card indicates when the sample object was evaporated:"},
			Evaporated[
				Date -> Now,
				Protocol -> Object[Protocol, Evaporate, "Test protocol for Evaporated tests"],
				InstrumentModel -> Model[Instrument, RotaryEvaporator, "RV10 Auto Prov V"],
				EvaporationType -> RotaryEvaporation,
				Temperature -> 40 Celsius,
				Time -> 30 Minute,
				RotationRate -> 200 RPM
			],
			_Evaporated
		],
		Example[{Basic, "Upload a Evaporated sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Evaporated[
							Date -> Now,
							Protocol -> Object[Protocol, Evaporate, "Test protocol for Evaporated tests"],
							InstrumentModel -> Model[Instrument, RotaryEvaporator, "RV10 Auto Prov V"],
							EvaporationType -> RotaryEvaporation,
							Temperature -> 40 Celsius,
							Time -> 30 Minute,
							RotationRate -> 200 RPM
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Evaporated},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* FlashFrozen *)

DefineTests[FlashFrozen,
	{
		Example[{Basic, "FlashFrozen sample history card indicates when the sample object was flash frozen:"},
			FlashFrozen[
				Date -> Now,
				Protocol -> Object[Protocol, FlashFreeze, "Test protocol for FlashFrozen tests"],
				InstrumentModel -> Model[Instrument, Dewar, "500mL Dewar Flask"],
				Time -> 5 Minute
			],
			_FlashFrozen
		],
		Example[{Basic, "Upload a FlashFrozen sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						FlashFrozen[
							Date -> Now,
							Protocol -> Object[Protocol, FlashFreeze, "Test protocol for FlashFrozen tests"],
							InstrumentModel -> Model[Instrument, Dewar, "500mL Dewar Flask"],
							Time -> 5 Minute
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_FlashFrozen},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Degassed *)

DefineTests[Degassed,
	{
		Example[{Basic, "Degassed sample history card indicates when the sample object was degassed:"},
			Degassed[
				Date -> Now,
				Protocol -> Object[Protocol, FlashFreeze, "Test protocol for Degassed tests"],
				InstrumentModel -> Model[Instrument, FreezePumpThawApparatus, "High Tech FreezePumpThaw Apparatus"],
				FreezeTime -> 5 Minute,
				PumpTime -> 5 Minute,
				ThawTime -> 15 Minute,
				NumberOfCycles -> 3
			],
			_Degassed
		],
		Example[{Basic, "Upload a Degassed sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Degassed[
							Date -> Now,
							Protocol -> Object[Protocol, FlashFreeze, "Test protocol for Degassed tests"],
							InstrumentModel -> Model[Instrument, FreezePumpThawApparatus, "High Tech FreezePumpThaw Apparatus"],
							FreezeTime -> 5 Minute,
							PumpTime -> 5 Minute,
							ThawTime -> 15 Minute,
							NumberOfCycles -> 3
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Degassed},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Filtered *)

DefineTests[Filtered,
	{
		Example[{Basic, "Filtered sample history card indicates when the sample object was filtered:"},
			Filtered[
				Date -> Now,
				Protocol -> Object[Protocol, FlashFreeze, "Test protocol for Filtered tests"],
				InstrumentModel -> Object[Instrument, PeristalticPump, "Big Jon"],
				Type -> PeristalticPump,
				PoreSize -> 22 Micrometer,
				MembraneMaterial -> PES,
				Temperature -> Ambient,
				Time -> 5 Minute
			],
			_Filtered
		],
		Example[{Basic, "Upload a Filtered sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Filtered[
							Date -> Now,
							Protocol -> Object[Protocol, FlashFreeze, "Test protocol for Filtered tests"],
							InstrumentModel -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
							Type -> PeristalticPump,
							PoreSize -> 22 Micrometer,
							MembraneMaterial -> PES,
							Temperature -> Ambient,
							Time -> 5 Minute
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Filtered},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];

(* ::Subsubsection:: *)
(* Restricted *)

DefineTests[Restricted,
	{
		Example[{Basic, "Restricted sample history card indicates when the sample object was Restricted:"},
			Restricted[
				Date -> Now,
				ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for Restricted tests"]
			],
			_Restricted
		],
		Example[{Basic, "Upload a Restricted sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Restricted[
							Date -> Now,
							ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for Restricted tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Restricted},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];

(* ::Subsubsection:: *)
(* Unrestricted *)

DefineTests[Unrestricted,
	{
		Example[{Basic, "Unrestricted sample history card indicates when the sample object was Unrestricted:"},
			Unrestricted[
				Date -> Now,
				ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for Unrestricted tests"]
			],
			_Unrestricted
		],
		Example[{Basic, "Upload a Unrestricted sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Unrestricted[
							Date -> Now,
							ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for Unrestricted tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Unrestricted},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* SetStorageCondition *)

DefineTests[SetStorageCondition,
	{
		Example[{Basic, "SetStorageCondition sample history card indicates when the sample object had its storage condition set:"},
			SetStorageCondition[
				Date -> Now,
				ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for SetStorageCondition tests"],
				StorageCondition -> Model[StorageCondition, "Refrigerator"]
			],
			_SetStorageCondition
		],
		Example[{Basic, "Upload a SetStorageCondition sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						SetStorageCondition[
							Date -> Now,
							ResponsibleParty -> Object[Protocol, Transfer, "Test protocol for SetStorageCondition tests"],
							StorageCondition -> Model[StorageCondition, "Refrigerator"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_SetStorageCondition},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Measured *)

DefineTests[Measured,
	{
		Example[{Basic, "Measured sample history card indicates when the sample object had various properties measured:"},
			Measured[
				Amount -> 200 Microliter,
				Data -> Object[Data,AcousticLiquidHandling, "Test Data for Measured tests"],
				Protocol -> Object[Protocol, AcousticLiquidHandling, "Test protocol for Measured tests"]
			],
			_Measured
		],
		Example[{Basic, "Upload a Measured sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Measured[
							Amount -> 200 Microliter,
							Data -> Object[Data,AcousticLiquidHandling, "Test Data for Measured tests"],
							Protocol -> Object[Protocol, AcousticLiquidHandling, "Test protocol for Measured tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Measured},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* StateChanged *)

DefineTests[StateChanged,
	{
		Example[{Basic, "StateChanged sample history card indicates when the sample's state changed:"},
			StateChanged[
				Date -> Now,
				Protocol -> Object[Protocol, FlashFreeze, "Test protocol for StateChanged tests"],
				State -> Solid
			],
			_StateChanged
		],
		Example[{Basic, "Upload a StateChanged sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						StateChanged[
							Date -> Now,
							Protocol -> Object[Protocol, FlashFreeze, "Test protocol for StateChanged tests"],
							State -> Solid
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_StateChanged},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Sterilized *)

DefineTests[Sterilized,
	{
		Example[{Basic, "Sterilized sample history card indicates when the sample was sterilized:"},
			Sterilized[
				Date -> Now,
				Protocol -> Object[Protocol, Autoclave, "Test protocol for Sterilized tests"]
			],
			_Sterilized
		],
		Example[{Basic, "Upload a Sterilized sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Sterilized[
							Date -> Now,
							Protocol -> Object[Protocol, Autoclave, "Test protocol for Sterilized tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Sterilized},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Transferred *)

DefineTests[Transferred,
	{
		Example[{Basic, "Transferred sample history card indicates when the sample was transferred in or out:"},
			Transferred[
				Date -> Now,
				Direction -> Out,
				Destination -> Object[Sample, "Test destination sample for Transferred tests"],
				Amount -> 100 Microliter,
				Protocol -> Object[Protocol, Transfer, "Test protocol for Transferred tests"]
			],
			_Transferred
		],
		Example[{Basic, "Upload multiple Transferred sample history cards to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Transferred[
							Date -> Now,
							Direction -> In,
							Source -> Object[Sample, "Test source sample for Transferred tests"],
							Amount -> 200 Microliter,
							Protocol -> Object[Protocol, Transfer, "Test protocol for Transferred tests"]
						],
						Transferred[
							Date -> Now,
							Direction -> Out,
							Destination -> Object[Sample, "Test destination sample for Transferred tests"],
							Amount -> 100 Microliter,
							Protocol -> Object[Protocol, Transfer, "Test protocol for Transferred tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Transferred, _Transferred},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* AcquiredData *)

DefineTests[AcquiredData,
	{
		Example[{Basic, "AcquiredData sample history card indicates when data of assorted types was acquired for a sample:"},
			AcquiredData[
				Date -> Now,
				Data -> Object[Data, LCMS, "Test LCMS Data for AcquiredData tests"],
				Protocol -> Object[Protocol, LCMS, "Test LCMS Protocol for AcquiredData tests"]
			],
			_AcquiredData
		],
		Example[{Basic, "Upload an AcquiredData sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						AcquiredData[
							Date -> Now,
							Data -> Object[Data, LCMS, "Test LCMS Data for AcquiredData tests"],
							Protocol -> Object[Protocol, LCMS, "Test LCMS Protocol for AcquiredData tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_AcquiredData},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Shipped *)

DefineTests[Shipped,
	{
		Example[{Basic, "Shipped sample history card indicates when a sample has been shipped to or from ECL:"},
			Shipped[
				Date -> Now,
				Source -> $Site,
				Destination -> Object[Container, Site, "Test site for Shipped tests"],
				ResponsibleParty -> $PersonID,
				Transaction -> Object[Transaction, ShipToUser, "Test transaction for Shipped tests"]
			],
			_Shipped
		],
		Example[{Basic, "Upload an Shipped sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						Shipped[
							Date -> Now,
							Source -> $Site,
							Destination -> Object[Container, Site, "Test site for Shipped tests"],
							ResponsibleParty -> $PersonID,
							Transaction -> Object[Transaction, ShipToUser, "Test transaction for Shipped tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Shipped},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* DefinedComposition *)

DefineTests[DefinedComposition,
	{
		Example[{Basic, "DefinedComposition sample history card indicates when a sample has had its composition set:"},
			DefinedComposition[
				Date -> Now,
				Composition -> {
					{100 MassPercent, Model[Molecule, "Sodium Chloride"]}
				},
				ResponsibleParty -> Object[Protocol, Lyophilize, "Test protocol for DefinedComposition tests"]
			],
			_DefinedComposition
		],
		Example[{Basic, "Upload an DefinedComposition sample history card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Replace[SampleHistory] -> {
						DefinedComposition[
							Date -> Now,
							Composition -> {
								{100 MassPercent, Model[Molecule, "Sodium Chloride"]}
							},
							ResponsibleParty -> Object[Protocol, Lyophilize, "Test protocol for DefinedComposition tests"]
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_DefinedComposition},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection:: *)
(* Lysed *)

DefineTests[Lysed,
	{
		Example[{Basic, "Lysed SampleHistory card indicates when and under which conditions the cells within a sample object were lysed:"},
			Lysed[
				Date -> Now,
				LysisSolution -> Link[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
				LysisTemperature -> 25 Celsius,
				LysisTime -> 5 Minute
			],
			_Lysed
		],
		Example[{Basic, "Upload a Lysed SampleHistory card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Site -> Link[$Site],
					Replace[SampleHistory] -> {
						Lysed[
							Date -> Now,
							LysisSolution -> Link[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
							LysisTemperature -> 25 Celsius,
							LysisTime -> 5 Minute
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Lysed},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];

(* ::Subsubsection:: *)
(* CASNumberQ and CASNumberP *)
DefineTests[CASNumberQ,
	{
		Example[{Basic,"Check if the CAS registry number for water is in the form of a valid CAS registry number."},
			CASNumberQ[
				"7732-18-5"
			],
			True
		],
		Example[{Basic,"Check if a Null input is in the form of a CAS registry number."},
			CASNumberQ[],
			False
		],
		Example[{Basic,"Check if \"10-10-1\" is in the form of a CAS registry number."},
			CASNumberQ["10-10-1"],
			False
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];
(* ::Subsubsection:: *)
(* Washed *)

DefineTests[Washed,
	{
		Example[{Basic, "Washed SampleHistory card indicates when and under which conditions the cells within a sample object were washed:"},
			Washed[
				Date -> Now,
				WashSolution -> Link[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
				WashTemperature -> 25 Celsius,
				WashMixTime -> 5 Minute
			],
			_Washed
		],
		Example[{Basic, "Upload a Washed SampleHistory card to the SampleHistory field of an object:"},
			sample = Upload[
				<|
					Type -> Object[Sample],
					DeveloperObject -> True,
					Site -> Link[$Site],
					Replace[SampleHistory] -> {
						Washed[
							Date -> Now,
							WashSolution -> Link[Model[Sample, StockSolution, "id:7X104vK9ZlWZ"]],
							WashTemperature -> 25 Celsius,
							WashMixTime -> 5 Minute
						]
					}
				|>
			];
			Download[sample, SampleHistory],
			{_Washed},
			Variables :> {sample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];

(* ::Subsubsection:: *)
(*Desiccated*)

DefineTests[Desiccated,
  {
    Example[{Basic, "Desiccated sample history card indicates when the sample was desiccated:"},
      desiccateProtocol = Upload[<|
        Type -> Object[Protocol, Desiccate],
        Name -> "Desiccated History Card Test Protocol" <> $SessionUUID,
        Desiccator -> Link[Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]],
        Method -> StandardDesiccant
      |>];
      {instrumentModel, desiccationMethod} = Download[desiccateProtocol, {Desiccator[Object], Method}];
      Desiccated[
        Association[
          Date -> Now,
          Protocol -> desiccateProtocol,
          InstrumentModel -> instrumentModel,
          Method -> desiccationMethod
        ]
      ],
      _Desiccated,
      Variables :> {desiccateProtocol, instrumentModel, desiccationMethod}
    ],
    Example[{Basic, "Upload a Desiccated history card to the SampleHistory field of an object:"},
      desiccateProtocol = Upload[<|
        Type -> Object[Protocol, Desiccate],
        Name -> "Desiccated History Card Test Protocol " <> $SessionUUID,
        Desiccator -> Link[Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]],
        Method -> StandardDesiccant
      |>];
      {instrumentModel, desiccationMethod} = Download[Object[Protocol, Desiccate, "Desiccated History Card Test Protocol " <> $SessionUUID], {Desiccator[Object], Method}];
      sample = Upload[
        <|
          Type -> Object[Sample],
          DeveloperObject -> True,
					Name -> "Test Sample For Desiccated History Card Tests " <> $SessionUUID,
          Replace[SampleHistory] -> {
            Desiccated[
              Association[
                Date -> Now,
                Protocol -> Object[Protocol, Desiccate, "Desiccated History Card Test Protocol" <> $SessionUUID],
                InstrumentModel -> instrumentModel,
                Method -> desiccationMethod
              ]
            ]
          }
        |>
      ];
      Download[sample, SampleHistory],
      {_Desiccated},
      Variables :> {desiccateProtocol, instrumentModel, desiccationMethod, sample}
    ]
  },

	SymbolSetUp :>(
		Module[{objects},

			(* list of test objects*)
			objects = {
				Object[Protocol, Desiccate, "Desiccated History Card Test Protocol" <> $SessionUUID],
				Object[Sample, "Test Sample For Desiccated History Card Tests " <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
		];
	),

  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  )
];


(* ::Subsection:: *)
(* Other *)
(* Have to define some dummy tests for the symbol OD600 as ValidPullRequestQ is complaining *)
DefineTests["OD600",
	{
		Example[
			{Basic,"Using OD600 returns a Quantity with OD600 units:"},
			5 OD600,
			Quantity[_,IndependentUnit["OD600s"]]
		],
		Example[
			{Basic,"Using OD600 returns a Quantity with OD600 units with the correct number of OD600s:"},
			5 OD600,
			Quantity[5,IndependentUnit["OD600s"]]
		],
		Example[
			{Basic,"You can add OD600s:"},
			5 OD600 + 6 OD600,
			Quantity[11,IndependentUnit["OD600s"]]
		]
	}
];

(* ::Subsection:: *)
(* DayObjectQ *)
DefineTests[
	DayObjectQ,
	{
		Example[{Basic, "Returns True when the expression represents a day:"},
			DayObjectQ[DateObject[{2024,01,01}]],
			True
		],
		Example[{Basic, "Returns False when the expression represents a date, including time:"},
			DayObjectQ[DateObject[{2024,01,01,00,00,00}]],
			False
		],
		Example[{Basic, "Returns False for other expressions:"},
			DayObjectQ["Test string"],
			False
		],
		Test["Returns False for an integer",
			DayObjectQ[1234],
			False
		],
		Test["Returns False for a string",
			DayObjectQ["Test string"],
			False
		],
		Test["Returns False for a symbol",
			DayObjectQ[TestSymbol],
			False
		],
		Test["Returns False for a Time",
			DayObjectQ[TimeObject[{1,2,3}]],
			False
		]
	}
];