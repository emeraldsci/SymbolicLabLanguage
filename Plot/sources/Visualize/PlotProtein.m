(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProtein*)


DefineOptions[PlotProtein,
	Options:>{
		ModifyOptions[ListPlotOptions,{ImageSize},Default->500],
		OutputOption
	}
];


(* --- Core Function --- *)
PlotProtein[pdbID_String,ops:OptionsPattern[]]:=Module[
	{safeOps,output,importPath,imported,result},

	(* Original options as a list *)
	originalOps=ToList[ops];

	(* Options with defaults subbed in for unspecified values *)
	safeOps = SafeOptions[PlotProtein, originalOps];

	(* Requested output for the command builder *)
	output=Lookup[safeOps,Output];

	(* string join the pdb id to the importing file path *)
	importPath ="https://files.rcsb.org/download/"<>pdbID<>".pdb";

	(* import as pdb, check for a bad connection *)
	imported = Quiet[
		(* Return FetchURL:conopen if a bad internet connection is detected. *)
		Check[
			Import[importPath,"PDB"],
			Return[Null],
			Utilities`URLTools`FetchURL::conopen
		],
		(* Quiet the 404 error message. In MM Version 12.2+, there is also an import error to quiet. More descriptive error is handled below. *)
		{Utilities`URLTools`FetchURL::httperr,Import::fmterr}
	];

	(* if the import failed, it must be because of a 404 error - return a message, otherwise return the graphic *)
	result=If[MatchQ[imported,$Failed],
		Message[PlotProtein::InvalidPDBID,pdbID];
		Message[Error::InvalidInput,pdbID];,
		Show[imported,ImageSize->Lookup[safeOps,ImageSize]]
	];

	(* Get the actual image dimensions *)
	resolvedOps=ReplaceRule[safeOps,
		If[MatchQ[imported,$Failed],{},{ImageSize->ImageDimensions[result]}]
	];

	(* Return the requested output *)
	output/.{
		Result->result,
		Preview->result/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Options->resolvedOps,
		Tests->{}
	}
];

(* Conditional error messages *)
PlotProtein[proteinData:PacketP[{Model[Sample]}],ops:OptionsPattern[]]:=Module[
	{originalOps,safeOps,output},

	(* Original options as a list *)
	originalOps=ToList[ops];

	(* Fill in missing options values with defaults *)
	safeOps=SafeOptions[PlotTranscript,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Throw an error message *)
	Message[PlotProtein::IncompleteInfo,Object/.(First[Download[proteinData[Composition][[All,2]]]])];
	Message[Error::InvalidInput,Lookup[proteinData,Object]];

	(* Return the requested outputs *)
	output/.{
		Result->Null,
		Preview->Null,
		Options->$Failed,
		Tests->{}
	}
]/;MatchQ[PDBIDs/.(First[Download[proteinData[Composition][[All,2]]]]),{Null}|{}|PDBIDs];


PlotProtein[proteinData:PacketP[{Model[Molecule],Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Molecule,Protein,Antibody]}],ops:OptionsPattern[]]:=Module[
	{originalOps,safeOps,output},

	(* Original options as a list *)
	originalOps=ToList[ops];

	(* Fill in missing options values with defaults *)
	safeOps=SafeOptions[PlotTranscript,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Throw an error message *)
	Message[PlotProtein::IncompleteInfo,Object/.proteinData];
	Message[Error::InvalidInput,Object/.proteinData];

	(* Return the requested outputs *)
	output/.{
		Result->Null,
		Preview->Null,
		Options->$Failed,
		Tests->{}
	}
]/;MatchQ[PDBIDs/.proteinData,{Null}|{}|PDBIDs];

(* SLL Object overloads (pass to main function) *)
PlotProtein[proteinData:PacketP[{Model[Sample]}],ops:OptionsPattern[]]:=
	PlotProtein[If[MatchQ[Length[PDBIDs/.(First[Download[proteinData[Composition][[All,2]]]])],1],First[PDBIDs/.(First[Download[proteinData[Composition][[All,2]]]])],PDBIDs/.(First[Download[proteinData[Composition][[All,2]]]])],ops];
PlotProtein[proteinData:PacketP[{Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Molecule,Protein,Antibody]}],ops:OptionsPattern[]]:=
		PlotProtein[If[MatchQ[Length[PDBIDs/.proteinData],1],First[PDBIDs/.proteinData],PDBIDs/.proteinData],ops];
PlotProtein[proteinData:(ObjectReferenceP[{Model[Sample]}]|LinkP[{Model[Sample]}]),ops:OptionsPattern[]]:=
	PlotProtein[(First[Download[proteinData[Composition][[All,2]]]]),ops];
PlotProtein[proteinData:(ObjectReferenceP[{Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Molecule,Protein,Antibody]}]|LinkP[{Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Molecule,Protein,Antibody]}]),ops:OptionsPattern[]]:=
		PlotProtein[Download[proteinData],ops];

(* Listable overloads *)
PlotProtein[proteinData:{(ObjectP[{Model[Sample]}]|ObjectP[{Model[Molecule]}]|_String)..},ops:OptionsPattern[]]:=
	PlotProtein[#,ops]&/@(
		Which[
			MatchQ[#,_String],#,
			MatchQ[#,ObjectP[{Model[Sample]}]],First[Download[#[Composition][[All,2]]]],
			MatchQ[#,ObjectP[{Model[Molecule]}]],Download[#]
		]&/@proteinData
	);
PlotProtein[proteinData:{(ObjectP[{Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Molecule,Protein,Antibody]}])..},ops:OptionsPattern[]]:=
		PlotProtein[#,ops]&/@Download[proteinData];
