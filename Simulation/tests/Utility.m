(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Utility: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Utility*)


(* ::Subsubsection::Closed:: *)
(*linkageClasses*)


DefineTests[
	linkageClasses,
	{
		Test[Sort[Sort/@linkageClasses[{a->c,a->b+c,a->2h,2e->a,e+f->g,h\[Equilibrium]c,h+d->c+a}]],Sort[Sort/@{{a,c,b+c,2 h,2 e,h},{e+f,g},{d+h,a+c}}]]
	},
	Variables:>{a,b,c,d,e,f,g,h}
];



(* ::Subsubsection:: *)
(*stateSpaceMatrices*)


DefineTests[stateSpaceMatrices,{

	Test["Doesn't evaluate:",
		stateSpaceMatrices["horse"],
		$Failed,
		Messages:>{stateSpaceMatrices::BadModelFormat}
	],
	Test["1",Normal/@stateSpaceMatrices[{},{}],{{},{0},{{},{}},{}}],
	Test["2",Normal/@stateSpaceMatrices[{{a->b,1}}],{{{-1,0},{1,0}},{0},{{},{}},{a,b}}],
	Test["3",Normal/@stateSpaceMatrices[{{a->b+c,1}}],{{{-1,0,0},{1,0,0},{1,0,0}},{0},{{},{}},{a,b,c}}],
	Test["4",Normal/@stateSpaceMatrices[{{a+b->c,1}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{1}},{{1},{2}},{a,b,c}}],
	Test["5",Normal/@stateSpaceMatrices[{{a+b->c+d,1}}],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1},{-1},{1},{1}},{{1},{2}},{a,b,c,d}}],
	Test["6",Normal/@stateSpaceMatrices[{{2a->b,1}}],{{{0,0},{0,0}},{{-2},{1}},{{1},{1}},{a,b}}],
	Test["7",Normal/@stateSpaceMatrices[{{a->2b,1}}],{{{-1,0},{2,0}},{0},{{},{}},{a,b}}],
	Test["8",Normal/@stateSpaceMatrices[{{2a->b+c,1}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-2},{1},{1}},{{1},{1}},{a,b,c}}],
	Test["9",Normal/@stateSpaceMatrices[{{a->c+2d+3f,1}}],{{{-1, 0, 0, 0}, {1, 0, 0, 0}, {2, 0, 0, 0}, {3, 0, 0,	0}}, {0}, {{}, {}}, {a, c, d, f}}],
	Test["10",Normal/@stateSpaceMatrices[{{a+b->c+2d+3f,1}}],{{{0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0,		0}, {0, 0, 0, 0, 0}}, {{-1}, {-1}, {1}, {2}, {3}}, {{1}, {2}}, {a,		b, c, d, f}}],
	Test["11",Normal/@stateSpaceMatrices[{{a+b->2c,1}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{2}},{{1},{2}},{a,b,c}}],
	Test["12",Normal/@stateSpaceMatrices[{{a\[Equilibrium]b,1,2}}],{{{-1,2},{1,-2}},{0},{{},{}},{a,b}}],
	Test["13",Normal/@stateSpaceMatrices[{{a\[Equilibrium]b+c,1,2}}],{{{-1,0,0},{1,0,0},{1,0,0}},{{2},{-2},{-2}},{{2},{3}},{a,b,c}}],
	Test["14",Normal/@stateSpaceMatrices[{{a+b\[Equilibrium]c,1,2}}],{{{0,0,2},{0,0,2},{0,0,-2}},{{-1},{-1},{1}},{{1},{2}},{a,b,c}}],
	Test["15",Normal/@stateSpaceMatrices[{{a+b\[Equilibrium]c+d,1,2}}],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1,2},{-1,2},{1,-2},{1,-2}},{{1,3},{2,4}},{a,b,c,d}}],
	Test["16",Normal/@stateSpaceMatrices[{{2a\[Equilibrium]b,1,2}}],{{{0,4},{0,-2}},{{-2},{1}},{{1},{1}},{a,b}}],
	Test["17",Normal/@stateSpaceMatrices[{{a\[Equilibrium]2b,1,2}}],{{{-1,0},{2,0}},{{2},{-4}},{{2},{2}},{a,b}}],
	Test["18",Normal/@stateSpaceMatrices[{{2a\[Equilibrium]b+c,1,2}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-2,4},{1,-2},{1,-2}},{{1,2},{1,3}},{a,b,c}}],
	Test["19",Normal/@stateSpaceMatrices[{{a+b\[Equilibrium]2c,1,2}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1,2},{-1,2},{2,-4}},{{1,3},{2,3}},{a,b,c}}],

	Test["20",Normal/@stateSpaceMatrices[ReactionMechanism[]],{{},{0},{{},{}},{}}],
	Test["21",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1]]],{{{-1,0},{1,0}},{0},{{},{}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["22",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1]]],{{{-1,0,0},{1,0,0},{1,0,0}},{0},{{},{}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["23",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}]},1]]],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{1}},{{1},{2}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["24",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"D"]]},{}]},1]]],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1},{-1},{1},{1}},{{1},{2}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"D"]]},{}]}}],
	Test["25",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1]]],{{{0,0},{0,0}},{{-2},{1}},{{1},{1}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["26",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},1]]],{{{-1,0},{2,0}},{0},{{},{}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["27",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1]]],{{{0,0,0},{0,0,0},{0,0,0}},{{-2},{1},{1}},{{1},{1}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["28",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1]]],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{2}},{{1},{2}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["29",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1,2]]],{{{-1,2},{1,-2}},{0},{{},{}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["30",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1,2]]],{{{-1,0,0},{1,0,0},{1,0,0}},{{2},{-2},{-2}},{{2},{3}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["31",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}]},1,2]]],{{{0,0,2},{0,0,2},{0,0,-2}},{{-1},{-1},{1}},{{1},{2}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["32",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"D"]]},{}]},1,2]]],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1,2},{-1,2},{1,-2},{1,-2}},{{1,3},{2,4}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"D"]]},{}]}}],
	Test["33",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1,2]]],{{{0,4},{0,-2}},{{-2},{1}},{{1},{1}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["34",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},1,2]]],{{{-1,0},{2,0}},{{2},{-4}},{{2},{2}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]}}],
	Test["35",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1,2]]],{{{0,0,0},{0,0,0},{0,0,0}},{{-2,4},{1,-2},{1,-2}},{{1,2},{1,3}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],
	Test["36",Normal/@stateSpaceMatrices[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"C"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]},1,2]]],{{{0,0,0},{0,0,0},{0,0,0}},{{-1,2},{-1,2},{2,-4}},{{1,3},{2,3}},{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C"]]},{}]}}],

	Test["37",stateSpaceMatrices[{reactantMatrix["a"->"b"],productMatrix["a"->"b"],{1},{"a","b"}}],$Failed,Messages:>{stateSpaceMatrices::BadModelFormat}],
	Test["38",Normal/@stateSpaceMatrices[{reactantMatrix[{a->b}],productMatrix[{a->b}],{1},{a,b}}],{{{-1,0},{1,0}},{},{{},{}},{a,b}}],
	Test["39",Normal/@stateSpaceMatrices[{reactantMatrix[{a->b+c}],productMatrix[{a->b+c}],{1},{a,b,c}}],{{{-1,0,0},{1,0,0},{1,0,0}},{},{{},{}},{a,b,c}}],
	Test["40",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b->c}],productMatrix[{a+b->c}],{1},{a,b,c}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{1}},{{1},{2}},{a,b,c}}],
	Test["41",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b->c+d}],productMatrix[{a+b->c+d}],{1},{a,b,c,d}}],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1},{-1},{1},{1}},{{1},{2}},{a,b,c,d}}],
	Test["42",Normal/@stateSpaceMatrices[{reactantMatrix[{2a->b}],productMatrix[{2a->b}],{1},{a,b}}],{{{0,0},{0,0}},{{-2},{1}},{{1},{1}},{a,b}}],
	Test["43",Normal/@stateSpaceMatrices[{reactantMatrix[{a->2b}],productMatrix[{a->2b}],{1},{a,b}}],{{{-1,0},{2,0}},{},{{},{}},{a,b}}],
	Test["44",Normal/@stateSpaceMatrices[{reactantMatrix[{2a->b+c}],productMatrix[{2a->b+c}],{1},{a,b,c}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-2},{1},{1}},{{1},{1}},{a,b,c}}],
	Test["45",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b->2c}],productMatrix[{a+b->2c}],{1},{a,b,c}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1},{-1},{2}},{{1},{2}},{a,b,c}}],
	Test["46",Normal/@stateSpaceMatrices[{reactantMatrix[{a\[Equilibrium]b}],productMatrix[{a\[Equilibrium]b}],{1,2},{a,b}}],{{{-1,2},{1,-2}},{},{{},{}},{a,b}}],
	Test["47",Normal/@stateSpaceMatrices[{reactantMatrix[{a\[Equilibrium]b+c}],productMatrix[{a\[Equilibrium]b+c}],{1,2},{a,b,c}}],{{{-1,0,0},{1,0,0},{1,0,0}},{{2},{-2},{-2}},{{2},{3}},{a,b,c}}],
	Test["48",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b\[Equilibrium]c}],productMatrix[{a+b\[Equilibrium]c}],{1,2},{a,b,c}}],{{{0,0,2},{0,0,2},{0,0,-2}},{{-1},{-1},{1}},{{1},{2}},{a,b,c}}],
	Test["49",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b\[Equilibrium]c+d}],productMatrix[{a+b\[Equilibrium]c+d}],{1,2},{a,b,c,d}}],{{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{-1,2},{-1,2},{1,-2},{1,-2}},{{1,3},{2,4}},{a,b,c,d}}],
	Test["50",Normal/@stateSpaceMatrices[{reactantMatrix[{2a\[Equilibrium]b}],productMatrix[{2a\[Equilibrium]b}],{1,2},{a,b}}],{{{0,4},{0,-2}},{{-2},{1}},{{1},{1}},{a,b}}],
	Test["51",Normal/@stateSpaceMatrices[{reactantMatrix[{a\[Equilibrium]2b}],productMatrix[{a\[Equilibrium]2b}],{1,2},{a,b}}],{{{-1,0},{2,0}},{{2},{-4}},{{2},{2}},{a,b}}],
	Test["52",Normal/@stateSpaceMatrices[{reactantMatrix[{2a\[Equilibrium]b+c}],productMatrix[{2a\[Equilibrium]b+c}],{1,2},{a,b,c}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-2,4},{1,-2},{1,-2}},{{1,2},{1,3}},{a,b,c}}],
	Test["53",Normal/@stateSpaceMatrices[{reactantMatrix[{a+b\[Equilibrium]2c}],productMatrix[{a+b\[Equilibrium]2c}],{1,2},{a,b,c}}],{{{0,0,0},{0,0,0},{0,0,0}},{{-1,2},{-1,2},{2,-4}},{{1,3},{2,3}},{a,b,c}}]
},
	Variables:>{a,b,c,d}
];


(* ::Subsubsection::Closed:: *)
(*adjacencyMatrices*)


DefineTests[
	adjacencyMatrices,
	{
		Test[Normal/@adjacencyMatrices[reactantMatrix[{}]],{}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a->b}]],{{{1,0}},{{0,0,0,0}},{},{},{}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b->c}]],{{{0,0,0}},{{0,1,0,0,0,0,0,0,0}},{2},{1},{2}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a->b+c}]],{{{1,0,0}},{{0,0,0,0,0,0,0,0,0}},{},{},{}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{2a->b}]],{{{0,0}},{{1,0,0,0}},{1},{1},{1}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a->2b}]],{{{1,0}},{{0,0,0,0}},{},{},{}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{2a->b+c}]],{{{0,0,0}},{{1,0,0,0,0,0,0,0,0}},{1},{1},{1}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b->2c}]],{{{0,0,0}},{{0,1,0,0,0,0,0,0,0}},{2},{1},{2}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b->c+d}]],{{{0,0,0,0}},{{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0}},{2},{1},{2}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a->b}]],{{{1,0}},{{0,0,0,0}},{},{},{}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b\[Equilibrium]c}]],{{{0,0,0},{0,0,1}},{{0,1,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0}},{2},{1},{2}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a\[Equilibrium]b+c}]],{{{1,0,0},{0,0,0}},{{0,0,0,0,0,0,0,0,0},{0,0,0,0,0,1,0,0,0}},{6},{2},{3}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{2a\[Equilibrium]b}]],{{{0,0},{0,1}},{{1,0,0,0},{0,0,0,0}},{1},{1},{1}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a\[Equilibrium]2b}]],{{{1,0},{0,0}},{{0,0,0,0},{0,0,0,1}},{4},{2},{2}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{2a\[Equilibrium]b+c}]],{{{0,0,0},{0,0,0}},{{1,0,0,0,0,0,0,0,0},{0,0,0,0,0,1,0,0,0}},{1,6},{1,2},{1,3}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b\[Equilibrium]2c}]],{{{0,0,0},{0,0,0}},{{0,1,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,1}},{2,9},{1,3},{2,3}}],
		Test[Normal/@adjacencyMatrices[reactantMatrix[{a+b\[Equilibrium]c+d}]],{{{0,0,0,0},{0,0,0,0}},{{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0}},{2,12},{1,3},{2,4}}]
	},
	Variables:>{a,b,c,d}
];



(* ::Subsubsection::Closed:: *)
(*productMatrix*)


DefineTests[
	productMatrix,
	{
		Test[productMatrix["a"->"b"],_productMatrix],
		Test[productMatrix[{}],{}],
		Test[Normal[productMatrix[{a->b}]],{{0},{1}}],
		Test[Normal[productMatrix[{a+b->c}]],{{0},{0},{1}}],
		Test[Normal[productMatrix[{a->b+c}]],{{0},{1},{1}}],
		Test[Normal[productMatrix[{a+b->c+d}]],{{0},{0},{1},{1}}],
		Test[Normal[productMatrix[{2a->b}]],{{0},{1}}],
		Test[Normal[productMatrix[{a->2b}]],{{0},{2}}],
		Test[Normal[productMatrix[{a\[Equilibrium]b}]],{{0,1},{1,0}}],
		Test[Normal[productMatrix[{a+b\[Equilibrium]c}]],{{0,1},{0,1},{1,0}}],
		Test[Normal[productMatrix[{a\[Equilibrium]b+c}]],{{0,1},{1,0},{1,0}}],
		Test[Normal[productMatrix[{a+b\[Equilibrium]c+d}]],{{0,1},{0,1},{1,0},{1,0}}],
		Test[Normal[productMatrix[{2a\[Equilibrium]b}]],{{0,2},{1,0}}],
		Test[Normal[productMatrix[{a\[Equilibrium]2b}]],{{0,1},{2,0}}]
	},
	Variables:>{a,b,c,d}
];


(* ::Subsubsection::Closed:: *)
(*reactantMatrix*)


DefineTests[
	reactantMatrix,
	{
		Test[reactantMatrix["a"->"b"],_reactantMatrix],
		Test[reactantMatrix[{}],{}],
		Test[Normal[reactantMatrix[{a->b}]],{{1},{0}}],
		Test[Normal[reactantMatrix[{a+b->c}]],{{1},{1},{0}}],
		Test[Normal[reactantMatrix[{a->b+c}]],{{1},{0},{0}}],
		Test[Normal[reactantMatrix[{a+b->c+d}]],{{1},{1},{0},{0}}],
		Test[Normal[reactantMatrix[{2a->b}]],{{2},{0}}],
		Test[Normal[reactantMatrix[{a->2b}]],{{1},{0}}],
		Test[Normal[reactantMatrix[{a\[Equilibrium]b}]],{{1,0},{0,1}}],
		Test[Normal[reactantMatrix[{a+b\[Equilibrium]c}]],{{1,0},{1,0},{0,1}}],
		Test[Normal[reactantMatrix[{a\[Equilibrium]b+c}]],{{1,0},{0,1},{0,1}}],
		Test[Normal[reactantMatrix[{a+b\[Equilibrium]c+d}]],{{1,0},{1,0},{0,1},{0,1}}],
		Test[Normal[reactantMatrix[{2a\[Equilibrium]b}]],{{2,0},{0,1}}],
		Test[Normal[reactantMatrix[{a\[Equilibrium]2b}]],{{1,0},{0,2}}]
	},
	Variables:>{a,b,c,d}
];


(* ::Subsubsection::Closed:: *)
(*stoichiometricMatrix*)


DefineTests[
	stoichiometricMatrix,
	{
		Test[stoichiometricMatrix["a"->"b"],_stoichiometricMatrix],
		Test[stoichiometricMatrix[{}],{}],
		Test[Normal[stoichiometricMatrix[{a->b}]],{{-1},{1}}],
		Test[Normal[stoichiometricMatrix[{a+b->c}]],{{-1},{-1},{1}}],
		Test[Normal[stoichiometricMatrix[{a->b+c}]],{{-1},{1},{1}}],
		Test[Normal[stoichiometricMatrix[{a+b->c+d}]],{{-1},{-1},{1},{1}}],
		Test[Normal[stoichiometricMatrix[{2a->b}]],{{-2},{1}}],
		Test[Normal[stoichiometricMatrix[{a->2b}]],{{-1},{2}}],
		Test[Normal[stoichiometricMatrix[{a\[Equilibrium]b}]],{{-1,1},{1,-1}}],
		Test[Normal[stoichiometricMatrix[{a+b\[Equilibrium]c}]],{{-1,1},{-1,1},{1,-1}}],
		Test[Normal[stoichiometricMatrix[{a\[Equilibrium]b+c}]],{{-1,1},{1,-1},{1,-1}}],
		Test[Normal[stoichiometricMatrix[{a+b\[Equilibrium]c+d}]],{{-1,1},{-1,1},{1,-1},{1,-1}}],
		Test[Normal[stoichiometricMatrix[{2a\[Equilibrium]b}]],{{-2,2},{1,-1}}],
		Test[Normal[stoichiometricMatrix[{a\[Equilibrium]2b}]],{{-1,1},{2,-2}}]
	},
	Variables:>{a,b,c,d}
];




(* ::Subsubsection:: *)
(*reactionMatrices*)


DefineTests[reactionMatrices,{
	Test[Normal/@reactionMatrices[{{a->b,1}}],{{{1},{0}},{{0},{1}},{1},{a,b}}],
	Test[Normal/@reactionMatrices[{{a->b+c,1}}],{{{1},{0},{0}},{{0},{1},{1}},{1},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b->c,1}}],{{{1},{1},{0}},{{0},{0},{1}},{1},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b->c+d,1}}],{{{1},{1},{0},{0}},{{0},{0},{1},{1}},{1},{a,b,c,d}}],
	Test[Normal/@reactionMatrices[{{2a->b,1}}],{{{2},{0}},{{0},{1}},{1},{a,b}}],
	Test[Normal/@reactionMatrices[{{a->2b,1}}],{{{1},{0}},{{0},{2}},{1},{a,b}}],
	Test[Normal/@reactionMatrices[{{2a->b+c,1}}],{{{2},{0},{0}},{{0},{1},{1}},{1},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b->2c,1}}],{{{1},{1},{0}},{{0},{0},{2}},{1},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a\[Equilibrium]b,1,2}}],{{{1,0},{0,1}},{{0,1},{1,0}},{1,2},{a,b}}],
	Test[Normal/@reactionMatrices[{{a\[Equilibrium]b+c,1,2}}],{{{1,0},{0,1},{0,1}},{{0,1},{1,0},{1,0}},{1,2},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b\[Equilibrium]c,1,2}}],{{{1,0},{1,0},{0,1}},{{0,1},{0,1},{1,0}},{1,2},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b\[Equilibrium]c+d,1,2}}],{{{1,0},{1,0},{0,1},{0,1}},{{0,1},{0,1},{1,0},{1,0}},{1,2},{a,b,c,d}}],
	Test[Normal/@reactionMatrices[{{2a\[Equilibrium]b,1,2}}],{{{2,0},{0,1}},{{0,2},{1,0}},{1,2},{a,b}}],
	Test[Normal/@reactionMatrices[{{a\[Equilibrium]2b,1,2}}],{{{1,0},{0,2}},{{0,1},{2,0}},{1,2},{a,b}}],
	Test[Normal/@reactionMatrices[{{2a\[Equilibrium]b+c,1,2}}],{{{2,0},{0,1},{0,1}},{{0,2},{1,0},{1,0}},{1,2},{a,b,c}}],
	Test[Normal/@reactionMatrices[{{a+b\[Equilibrium]2c,1,2}}],{{{1,0},{1,0},{0,2}},{{0,1},{0,1},{2,0}},{1,2},{a,b,c}}]
}];



(* ::Subsubsection:: *)
(*revReactions*)


DefineTests[
	revReactions,
	{
		Test["1",revReactions[{a\[Equilibrium]b,c->d,d\[Equilibrium]a}],{a->b,b->a,c->d,d->a,a->d}],
		Test["2",revReactions[{{a\[Equilibrium]b,{1,2}},{c->d,{3}},{d\[Equilibrium]a,{4,5}}}],{{a->b,{1}},{b->a,{2}},{c->d,{3}},{d->a,{4}},{a->d,{5}}}],
		Test["3",revReactions[{{a\[Equilibrium]b,1,2},{c->d,3},{d\[Equilibrium]a,4,5}}],{{a->b,1},{b->a,2},{c->d,3},{d->a,4},{a->d,5}}],
		Test["4",revReactions[ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1,2],Reaction[{Structure[{Strand[DNA[20,"C"]]},{}]},{Structure[{Strand[DNA[20,"D"]]},{}]},3],Reaction[{Structure[{Strand[DNA[20,"D"]]},{}]},{Structure[{Strand[DNA[20,"A"]]},{}]},4,5]]],ReactionMechanism[Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"B"]]},{}]},1],Reaction[{Structure[{Strand[DNA[20,"B"]]},{}]},{Structure[{Strand[DNA[20,"A"]]},{}]},2],Reaction[{Structure[{Strand[DNA[20,"C"]]},{}]},{Structure[{Strand[DNA[20,"D"]]},{}]},3],Reaction[{Structure[{Strand[DNA[20,"D"]]},{}]},{Structure[{Strand[DNA[20,"A"]]},{}]},4],Reaction[{Structure[{Strand[DNA[20,"A"]]},{}]},{Structure[{Strand[DNA[20,"D"]]},{}]},5]]]
	},
	Variables:>{a,b,c,d}
];


(* ::Subsubsection::Closed:: *)
(*implicitReactionTable*)


DefineTests[implicitReactionTable,{
	Test["",implicitReactionTable[A->B],{_,_}],
	Test["",implicitReactionTable[{A->B}],{_,_}],
	Test["",implicitReactionTable[{{A->B}}],{_,_}],
	Test["",implicitReactionTable[A+B->C],{_,_,_}],
	Test["",implicitReactionTable[{A+B->C}],{_,_,_}],
	Test["",implicitReactionTable[{{A+B->C,1.}}],{_,_,_}],
	Test["",implicitReactionTable[{A->B,k}],{_,_}],
	Test["",implicitReactionTable[{A->B},{A->1.}],{_,_}],
	Test["",implicitReactionTable[{{A->B,k}},{A->1.,B->2.}],{_,_}],
	Test["",implicitReactionTable[{A+B\[Equilibrium]C+D,D+A->G}],{},Messages:>{implicitReactionTable::NoSolution,implicitReactionTable::BadSpeciesName}]

}];



(* ::Section:: *)
(*End Test Package*)
