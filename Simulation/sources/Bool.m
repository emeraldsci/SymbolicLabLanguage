(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(**)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Bool*)

(* ::Subsubsection::Closed:: *)
(*Authors*)
Authors[BoolGreater]:={"scicomp", "brad"};
Authors[BoolGeq]:={"scicomp", "brad"};
Authors[BoolLess]:={"scicomp", "brad"};
Authors[BoolLeq]:={"scicomp", "brad"};
Authors[BoolEqual]:={"scicomp", "brad"};
Authors[BoolNot]:={"scicomp", "brad"};
Authors[BoolAnd]:={"scicomp", "brad"};
Authors[BoolOr]:={"scicomp", "brad"};
Authors[BoolXor]:={"scicomp", "brad"};
Authors[BoolFind]:={"scicomp", "brad"};
Authors[BoolMask]:={"scicomp", "brad"};

(* ::Subsubsection::Closed:: *)
(*listList*)


(* These functions return compiled functions *)
listList[op_, type_] := Core`Private`SafeCompile[{{x,type,1},{y,type,1}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			xy[[i]] = If[op[x[[i]], y[[i]]], 1, 0],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];


(* ::Subsubsection::Closed:: *)
(*listSingle*)


listSingle[op_, type_] := Core`Private`SafeCompile[{{x,type,1},{y,type}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			xy[[i]] = If[op[x[[i]], y], 1, 0],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];


(* ::Subsubsection::Closed:: *)
(*singleList*)


singleList[op_, type_] := Core`Private`SafeCompile[{{x,type},{y,type,1}},
	Module[{
		xy = Table[0,{Length[y]}]
	},
		Do[
			xy[[i]] = If[op[x, y[[i]]], 1, 0],
			{i,Length[y]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];


(* ::Subsubsection::Closed:: *)
(*helpers*)


re = _Real|_Integer;
packedReQ[x_] := PackedArrayQ[x,Real] || PackedArrayQ[x,Integer];

(* Create compiled functions *)
intListListGreater 			:= intListListGreater =			 	listList[Greater,_Integer];
intListSingleGreater 		:= intListSingleGreater =			listSingle[Greater,_Integer];
intSingleListGreater 		:= intSingleListGreater = 			singleList[Greater,_Integer];
intListListGreaterEqual 	:= intListListGreaterEqual = 		listList[GreaterEqual,_Integer];
intListSingleGreaterEqual 	:= intListSingleGreaterEqual = 		listSingle[GreaterEqual,_Integer];
intSingleListGreaterEqual 	:= intSingleListGreaterEqual = 		singleList[GreaterEqual,_Integer];
intListListEqual 			:= intListListEqual = 				listList[Equal,_Integer];
intListSingleEqual 			:= intListSingleEqual =				listSingle[Equal,_Integer];

realListListGreater 		:= realListListGreater = 			listList[Greater,_Real];
realListSingleGreater 		:= realListSingleGreater = 			listSingle[Greater,_Real];
realSingleListGreater 		:= realSingleListGreater = 			singleList[Greater,_Real];
realListListGreaterEqual 	:= realListListGreaterEqual =		listList[GreaterEqual,_Real];
realListSingleGreaterEqual 	:= realListSingleGreaterEqual =		listSingle[GreaterEqual,_Real];
realSingleListGreaterEqual 	:= realSingleListGreaterEqual =		singleList[GreaterEqual,_Real];
realListListEqual 			:= realListListEqual =				listList[Equal,_Real];
realListSingleEqual 		:= realListSingleEqual =			listSingle[Equal,_Real];



(* ::Subsubsection::Closed:: *)
(*BoolFind*)


findInt := findInt = Core`Private`SafeCompile[{{x,_Integer,1}},
	Module[{
		n = 0,
		idx,
		caret
	},
		Do[
			If[x[[i]]>0,
				n++
			],
			{i,Length[x]}
		];
		idx = Table[0,{n}];
		caret = 1;
		Do[
			If[x[[i]]>0,
				idx[[caret]] = i;
				caret++
			],
			{i,Length[x]}
		];
		idx
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];

findInt2 := findInt2 = Core`Private`SafeCompile[{{x,_Integer,2},{n,_Integer}},
	Module[{
		idx = Table[0,{n},{2}],
		caret = 1
	},
		Do[
			Do[
				If[x[[row,col]]>0,
					idx[[caret,All]] = {row,col};
					caret++
				],
				{col,Dimensions[x][[2]]}
			],
			{row,Dimensions[x][[1]]}
		];
		idx
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
BoolFind[x_] 				:= findInt[x] 						/; PackedArrayQ[x,Integer] && ArrayDepth[x]==1;
BoolFind[x_] 				:= findInt2[x, Total[BoolGreater[x,0], 2]] 	/; PackedArrayQ[x,Integer] && ArrayDepth[x]==2;
BoolFind[x_SparseArray]	:= Flatten[Cases[ArrayRules[x], (pos_->_?Positive) :> pos]]	/; ArrayDepth[x]==1;
BoolFind[x_List]		:= Flatten[Position[x,_?Positive]]							/; !PackedArrayQ[x] && ArrayDepth[x]==1;
BoolFind[x_SparseArray]	:= Cases[ArrayRules[x], (pos_->_?Positive) :> pos]			/; ArrayDepth[x]==2;
BoolFind[x_List]		:= Position[x,_?Positive]									/; !PackedArrayQ[x] && ArrayDepth[x]==2;



(* ::Subsubsection::Closed:: *)
(*BoolGreater*)


BoolGreater[x_,y_] 			:= intListListGreater[x,y] 			/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolGreater[x_,y_Integer] 	:= intListSingleGreater[x,y] 		/; PackedArrayQ[x,Integer];
BoolGreater[x_Integer,y_] 	:= intSingleListGreater[x,y] 		/; PackedArrayQ[y,Integer];
BoolGreater[x_,y_] 			:= realListListGreater[x,y] 		/; packedReQ[x] && packedReQ[y];
BoolGreater[x_,y:re] 		:= realListSingleGreater[x,y] 		/; packedReQ[x];
BoolGreater[x:re,y_] 		:= realSingleListGreater[x,y] 		/; packedReQ[y];
igreater[	x:Except[List], y:Except[List]] := 	If[x>y, 1, 0];
SetAttributes[igreater,{Listable}];
BoolGreater[x_, y_] 	:= igreater[x,y];
BoolGreater[x_, y_, others__] 	:= BoolAnd[BoolGreater[x,y], BoolGreater[y,others]];


(* ::Subsubsection::Closed:: *)
(*BoolGeq*)


BoolGeq[x_,y_] 				:= intListListGreaterEqual[x,y] 	/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolGeq[x_,y_Integer] 		:= intListSingleGreaterEqual[x,y] 	/; PackedArrayQ[x,Integer];
BoolGeq[x_Integer,y_] 		:= intSingleListGreaterEqual[x,y] 	/; PackedArrayQ[y,Integer];
BoolGeq[x_,y_] 				:= realListListGreaterEqual[x,y] 	/; packedReQ[x] && packedReQ[y];
BoolGeq[x_,y:re] 			:= realListSingleGreaterEqual[x,y] 	/; packedReQ[x];
BoolGeq[x:re,y_] 			:= realSingleListGreaterEqual[x,y] 	/; packedReQ[y];
igeq[		x:Except[List], y:Except[List]] := 	If[x>=y, 1, 0];
SetAttributes[igeq,{Listable}];
BoolGeq[x_, y_] 		:= igeq[x,y];
BoolGeq[x_, y_, others__] 		:= BoolAnd[BoolGeq[x,y], BoolGeq[y,others]];


(* ::Subsubsection::Closed:: *)
(*BoolEqual*)


BoolEqual[x_,y_] 			:= intListListEqual[x,y] 			/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolEqual[x_,y_Integer] 	:= intListSingleEqual[x,y] 			/; PackedArrayQ[x,Integer];
BoolEqual[x_Integer,y_] 	:= intListSingleEqual[y,x] 			/; PackedArrayQ[y,Integer];
BoolEqual[x_,y_] 			:= realListListEqual[x,y] 			/; packedReQ[x] && packedReQ[y];
BoolEqual[x_,y:re] 			:= realListSingleEqual[x,y] 		/; packedReQ[x];
BoolEqual[x:re,y_] 			:= realListSingleEqual[y,x] 		/; packedReQ[y];
ieq[		x:Except[List], y:Except[List]] := 	If[x==y, 1, 0];
SetAttributes[ieq,{Listable}];
BoolEqual[x_, y_] 		:= ieq[x,y];
BoolEqual[x_, y_, others__] 	:= BoolAnd[BoolEqual[x,y], BoolEqual[y,others]];


(* ::Subsubsection::Closed:: *)
(*BoolAnd*)


intAndListSingle := intAndListSingle = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[x[[i]] > 0 && y > 0,
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
(* These are special cases that aren't efficient in the above scheme *)
intAndListList := intAndListList = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer,1}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[x[[i]] > 0 && y[[i]] > 0,
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
BoolAnd[x_, y_] 			:= intAndListList[x,y] 				/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolAnd[x_, y_Integer] 		:= intAndListSingle[x,y] 			/; PackedArrayQ[x,Integer];
BoolAnd[x_Integer, y_] 		:= intAndListSingle[y,x] 			/; PackedArrayQ[y,Integer];
iand[		x:Except[List], y:Except[List]] := 	If[x>0 && y>0, 1, 0];
SetAttributes[iand,{Listable}];
BoolAnd[x_, y_] 		:= iand[x,y];
BoolAnd[x_, y_, others__] 		:= BoolAnd[BoolAnd[x,y], others];


(* ::Subsubsection::Closed:: *)
(*BoolOr*)


intOrListSingle := intOrListSingle = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[x[[i]] > 0 || y > 0,
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
intOrListList := intOrListList = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer,1}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[x[[i]] > 0 || y[[i]] > 0,
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
BoolOr[x_, y_] 				:= intOrListList[x,y] 				/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolOr[x_, y_Integer] 		:= intOrListSingle[x,y] 			/; PackedArrayQ[x,Integer];
BoolOr[x_Integer, y_] 		:= intOrListSingle[y,x] 			/; PackedArrayQ[y,Integer];
ior[		x:Except[List], y:Except[List]] := 	If[x>0 || y>0, 1, 0];
SetAttributes[ior,{Listable}];
BoolOr[x_, y_] 			:= ior[x,y];
BoolOr[x_, y_, others__] 		:= BoolOr[BoolOr[x,y], others];


(* ::Subsubsection::Closed:: *)
(*BoolXor*)


intXorListSingle := intXorListSingle = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[Xor[x[[i]] > 0, y > 0],
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
intXorListList := intXorListList = Core`Private`SafeCompile[{{x,_Integer,1},{y,_Integer,1}},
	Module[{
		xy = Table[0,{Length[x]}]
	},
		Do[
			If[Xor[x[[i]] > 0, y[[i]] > 0],
				xy[[i]] = 1
			],
			{i,Length[x]}
		];
		xy
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
BoolXor[x_, y_] 			:= intXorListList[x,y] 				/; PackedArrayQ[x,Integer] && PackedArrayQ[y,Integer];
BoolXor[x_, y_Integer] 		:= intXorListSingle[x,y] 			/; PackedArrayQ[x,Integer];
BoolXor[x_Integer, y_] 		:= intXorListSingle[y,x] 			/; PackedArrayQ[y,Integer];
ixor[		x:Except[List], y:Except[List]] := 	If[Xor[x>0, y>0], 1, 0];
SetAttributes[ixor,{Listable}];
BoolXor[x_, y_] 		:= ixor[x,y];


(* ::Subsubsection::Closed:: *)
(*BoolNot*)


intNot := intNot = Core`Private`SafeCompile[{{x,_Integer,1}},
	Module[{
		y = Table[0,{Length[x]}]
	},
		Do[
			y[[i]] = If[x[[i]]==0,1,0],
			{i,Length[x]}
		];
		y
	],
	CompilationTarget->"C",
	RuntimeAttributes->{Listable},
	Parallelization->True
];
BoolNot[x_] 				:= intNot[x] 						/; PackedArrayQ[x,Integer];
inot[		x:Except[List]] := 					If[x==0,1,0];
SetAttributes[inot,{Listable}];
BoolNot[x_] 			:= inot[x];


(* ::Subsubsection::Closed:: *)
(*BoolLess*)


BoolLess[x_, y_] := BoolGreater[y,x];


(* ::Subsubsection::Closed:: *)
(*BoolLeq*)


BoolLeq[x_, y_] := BoolGeq[y,x];



(* ::Subsubsection::Closed:: *)
(*BoolMask*)


BoolMask[x_?ArrayQ, m_?ArrayQ, y_?ArrayQ] :=
	Module[{xf},
		xf = Flatten[x];
		xf[[ BoolFind[Flatten[m]] ]] = Flatten[y];
		ArrayReshape[xf, Dimensions[x]]
	];

BoolMask[x_?ArrayQ, m_?ArrayQ, y_] :=
	Module[{xf},
		xf = Flatten[x];
		xf[[ BoolFind[Flatten[m]] ]] = y;
		ArrayReshape[xf, Dimensions[x]]
	];