(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTranscript*)


DefineOptions[PlotTranscript,
	Options:>{OutputOption}
];


(* Model[Sample] *)
PlotTranscript[trans:ObjectP[Model[Sample]],ops:OptionsPattern[PlotTranscript]]:=Module[
	{molecule},

	(* Get the corresponding Model[Molecule,Transcript] from the composition field *)
	molecule = First[trans[Composition][[All,2]]];

	(* Pass to primary overload *)
	PlotTranscript[molecule,ops]
];

(* Primary overload; Model[Molecule,Transcript] *)
PlotTranscript[trans:ObjectP[Model[Molecule,Transcript]],ops:OptionsPattern[PlotTranscript]]:=Module[
	{originalOps,safeOps,struct,rna,downloadedStructRNA,result},

	(* Original options as a list *)
	originalOps=ToList[ops];

	(* Fill in missing options values with defaults *)
	safeOps=SafeOptions[PlotTranscript,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* extract the structure and sequence from the object *)
	downloadedStructRNA=Download[trans,{SimulatedStructure,Molecule}];
	struct=First[downloadedStructRNA];
	rna=Last[downloadedStructRNA];

	(* Visualize the structure if we have it, otherwise Visualize a raw strand, if we have it, otherwise return null *)
	result=If[MatchQ[struct,{}|$Failed],
		If[NullQ[rna],
			Null,
			ToStructure[rna,ops]
		],
		struct
	];

	(* Return the requested output. There are no extra options, so this is easy. *)
	output/.{
		Result->result,
		Options->safeOps,
		Preview->result,
		Tests->{}
	}
];

(* Existing structure overload *)
PlotTranscript[structs:ListableP[StructureP],ops:OptionsPattern[]]:=Module[
	{safeOps,output},

	(* Fill in missing options values with defaults *)
	safeOps=SafeOptions[PlotTranscript,ToList[ops]];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Return requested outputs only *)
	output/.{
		Result->structs,
		Preview->structs,
		Options->safeOps,
		Tests->{}
	}
];

(* Listable overload *)
PlotTranscript[in:{ObjectP[{Model[Sample],Model[Molecule,Transcript]}]..},ops:OptionsPattern[]]:=PlotTranscript[#,ops]&/@in;

(* Catch-all - if no previous overloads were matched return Null *)
PlotTranscript[_,ops:OptionsPattern[]]:=Module[
	{safeOps,output},

	(* Safe Options *)
	safeOps=SafeOptions[PlotTranscript,ToList[ops]];

	(* Output option *)
	output=Lookup[safeOps,Output];

	(* Return requested output *)
	output/.{
		Result->Null,
		Preview->Null,
		Options->safeOps,
		Tests->{}
	}
];
