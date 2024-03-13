(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* map a function over the elements (holding each one) of a held form *)
levelspecP=_Integer | {_Integer} | {_Integer, _Integer} | Infinity;
holdingMap[fn_, xs_, levelspec:levelspecP:{1}]:=Map[fn, Unevaluated[xs], levelspec];
SetAttributes[holdingMap, HoldRest];

(* mapthread a function over the elements (holding each one) of a two-dimensional held form *)
levelP=_Integer?GreaterEqualThan[0];
holdingMapThread[fn_, xss_, level:levelP:1]:=ReleaseHold[MapThread[
	fn,
	holdingMap[Hold, xss, {2}],
	level
]];
SetAttributes[holdingMapThread, HoldRest];

(* Given an expression, and a list of sequential, optional arguments, expand out the possible alternatives:
	 for example, Banana[a] and {b,c} becomes Banana[a]|Banana[a,b]|Banana[a,c]|Banana[a,b,c].
	 This is a way to replace things like Banana[a, Repeated[b,{0,1}], Repeated[c,{0,1}]]. *)
optionalArgsP[expr_, patterns_List]:=Apply[
	Alternatives,
	Map[
		Join[expr, Apply[Head[expr], #]] &,
		Subsets[patterns]
	]
];

(* 
	While this is not currently called anywhere, it is a very helpful fuction for fixing broken BigQuantityArray fields, 
	Please do not remove in a cleanup until talking with Engineering
*)
binaryReadBigQuantityArrayFile::Error="There was an error reading the BigData file: `1`";
binaryReadBigQuantityArrayFile[filename_String]:=Module[
	{
		inStream,
		headerData,
		header,

		encodingVersion,
		binaryRowFormat,

		rawData
	},


	inStream=OpenRead[filename, BinaryFormat -> True];
	If[Not@MatchQ[inStream, _InputStream],
		Message[binaryReadBigQuantityArrayFile::Error, "opening input stream"];
		Return[$Failed]
	];

	(* reader the header, which should be JSON *)
	headerData=binaryReadBigQAHeader[inStream, $bigQuantityArrayBinaryEncodeMaxHeaderSize];
	If[Not@MatchQ[headerData, _String],
		Message[binaryReadBigQuantityArrayFile::Error, "reading header from in stream"];
		Return[$Failed]
	];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];
	If[Not@MatchQ[header, bigQABinaryHeaderP],
		Message[binaryReadBigQuantityArrayFile::Error, "header not correctly formated: "<>ToString[header, InputForm]];
		Return[$Failed]
	];

	encodingVersion=header["version"];
	If[Not@MatchQ[encodingVersion, bigQAValidVersionP],
		Message[binaryReadBigQuantityArrayFile::Error, "header version not supported: "<>ToString[header, InputForm]];
		Return[$Failed]
	];

	(* read rest of the file in with BinaryReadList *)
	binaryRowFormat=header["binaryRowFormat"];
	rawData=BinaryReadList[inStream, binaryRowFormat];
	Close[inStream];

	(* decode the units, and construct the quantity array from this *)
	QuantityArray[rawData, decodeExpressionB64[header["mathematicaUnits"]]]

];
