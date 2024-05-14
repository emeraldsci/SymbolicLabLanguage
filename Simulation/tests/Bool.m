

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*Bool: Tests*)


(* ::Section:: *)
(*Unit Tests*)


(* ::Subsection:: *)
(*Bool*)


(* ::Subsubsection:: *)
(*BoolGreater*)


DefineTests[BoolGreater,{
	Test[BoolGreater[3,4],0],
	Test[BoolGreater[6,4],1],
	Test[BoolGreater[3.3,4],0],
	Test[BoolGreater[6.3,4.2],1],
	Test[BoolGreater[3,3],0],
	Test[BoolGreater[3.,3],0]
}];


(* ::Subsubsection:: *)
(*BoolGeq*)


DefineTests[BoolGeq,{
	Test[BoolGeq[3,4],0],
	Test[BoolGeq[6,4],1],
	Test[BoolGeq[3.3,4],0],
	Test[BoolGeq[6.3,4.2],1],
	Test[BoolGeq[3,3],1],
	Test[BoolGeq[3.,3],1]
}];


(* ::Subsubsection:: *)
(*BoolLess*)


DefineTests[BoolLess,{
	Test[BoolLess[3,4],1],
	Test[BoolLess[6,4],0],
	Test[BoolLess[3.3,4],1],
	Test[BoolLess[6.3,4.2],0],
	Test[BoolLess[3,3],0],
	Test[BoolLess[3.,3],0]
}];


(* ::Subsubsection:: *)
(*BoolLeq*)


DefineTests[BoolLeq,{
	Test[BoolLeq[3,4],1],
	Test[BoolLeq[6,4],0],
	Test[BoolLeq[3.3,4],1],
	Test[BoolLeq[6.3,4.2],0],
	Test[BoolLeq[3,3],1],
	Test[BoolLeq[3.,3],1]
}];


(* ::Subsubsection:: *)
(*BoolEqual*)


DefineTests[BoolEqual,{
	Test[BoolEqual[3,4],0],
	Test[BoolEqual[6,4],0],
	Test[BoolEqual[3.3,4],0],
	Test[BoolEqual[6.3,4.2],0],
	Test[BoolEqual[3,3],1],
	Test[BoolEqual[3.,3],1]
}];


(* ::Subsubsection:: *)
(*BoolNot*)


DefineTests[BoolNot,{
	Test[BoolNot[0],1],
	Test[BoolNot[1],0],
	Test[BoolNot[2],0]
}];


(* ::Subsubsection:: *)
(*BoolAnd*)


DefineTests[BoolAnd,{
	Test[BoolAnd[1,1],1],
	Test[BoolAnd[1,0],0],
	Test[BoolAnd[0,1],0],
	Test[BoolAnd[0,0],0]
}];


(* ::Subsubsection:: *)
(*BoolOr*)


DefineTests[BoolOr,{
	Test[BoolOr[1,1],1],
	Test[BoolOr[1,0],1],
	Test[BoolOr[0,1],1],
	Test[BoolOr[0,0],0]
}];


(* ::Subsubsection:: *)
(*BoolXor*)


DefineTests[BoolXor,{
	Test[BoolXor[1,1],0],
	Test[BoolXor[1,0],1],
	Test[BoolXor[0,1],1],
	Test[BoolXor[0,0],0]
}];


(* ::Subsubsection:: *)
(*BoolFind*)


DefineTests[BoolFind,{
	Test[BoolFind[{-2,0,1,2,-7,3,4}],{3,4,6,7}]
}];


(* ::Subsubsection:: *)
(*BoolMask*)


DefineTests[BoolMask,{
	Test[BoolMask[{"a","b","c","d","e","f","g","h"},{1,0,0,1,0,1,1,1},"X"],{"X","b","c","X","e","X","X","X"}]
}];


(* ::Section:: *)
(*End Test Package*)
