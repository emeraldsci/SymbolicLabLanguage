(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*AllWells*)


DefineOptions[AllWells,
	Options :> {
		{AspectRatio -> Automatic, Automatic | _?NumericQ, "The ratio of rows to columns that the plate could contain."},
		{NumberOfWells -> Automatic, Automatic | _Integer, "The maximum number of well the plate can contain."},
		{Model -> None, None | ObjectP[Model[Container,Plate]], "Plate Model to be used in determine the AspectRatio and NumberOfWells that plate could contain."},
		{InputFormat -> Automatic, Automatic | WellTypeP, "Well indexing format of incoming well information. Options include Automatic (which will attempt to decipher automatically), or anything in WellTypeP."},
		{OutputFormat -> Automatic, Automatic | WellTypeP, "Well indexing format of outgoing well information.  If set to Automatic, will match the InputFormat of the 'endWell'."},
		{MultiplePlates -> Automatic, Joined | Split | Wrap | Ignore | Strict | Automatic, "Instructions on how to handle wells that exceed the maximum NumberOfWells in the output.  \nOptions include Split (which breaks the well into a list of the form {plate number, well} e.g. {1,3}), \nWrap - (which wraps the position back around to the first position after exceeding the NumberOfWells e.g. 97->1), \nStrict - (which throws an error if the index crosses the boundary into more than one plate),\nJoined - (which fuses the plate to the position string and only works when the output format is a position), \nIgnore - (which allows the position to exceed the maximum NumberOfWells e.g. \"Z100\"),\nor Automatic - (which will match input well formats, or default to Ignore if no input wells are provided)."},
		{PlateOrientation -> Landscape, Portrait | Landscape | None, "If set to Portrait will return a matrix of wells with A1 in the upper left corner. If set to Landscape will return a matrix of wells with A1 in the lower left hand corner.  If set to None, a flat list of wells will be returned."},
		CacheOption
	}];


AllWells::BadOrder="Requested to generate a range of wells where the startWell `1` exceeds the position of the endWell `2`.  Please change the inputs such that the initial well comes before the end well.";
AllWells::MissingModel="The specified plate container `1` does not have a Model.  Please ensure that `1` is valid by running ValidObjectQ with Verbose -> Failures.";
AllWells::ObjectModelMismatch="The specified plate container `1` has a model that does not match the specified model `2`.  Please ensure that the model of `1` is the same as the specified model `2`.";
AllWells::ModelMismatch="The specified plate model argument `1` does not match the plate model option `2`.  Please note that if specifying a model both as an argument and an option, both these models must be the same object.";


(* --- Core Function, provided a full range --- *)
AllWells[startWell:WellP,endWell:WellP,ops:OptionsPattern[]]:=Module[
	{safeOps, startIndex, endIndex, range, outputFormat, wells, cache, model, newOps, optionAspectRatio,
		optionNumWells, modelAspectRatio, modelNumWells, convertWellOptions},

	(* Safely extract the options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],
		{Null, Null}
	];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}],
		safeOps
	];

	(* Determine the starting and ending index *)
	startIndex = ConvertWell[startWell, OutputFormat -> Index, MultiplePlates -> Ignore, PassOptions[AllWells, ConvertWell, newOps]];
	endIndex = ConvertWell[endWell, OutputFormat -> Index, MultiplePlates -> Ignore, PassOptions[AllWells, ConvertWell, newOps]];

	(* Check to ensure the endIndex is past the startIndex *)
	If[endIndex < startIndex,
		(
			Message[AllWells::BadOrder,startWell,endWell];
			Return[$Failed]
		)
	];

	(* Generate a list of indexes from start to end *)
	range = Range[startIndex, endIndex];

	(* Determine the output format on the basis of the input format if set to Automatic *)
	outputFormat=If[MatchQ[Lookup[newOps, OutputFormat], Automatic],
		If[MatchQ[Lookup[newOps, InputFormat],Automatic],
			Switch[endWell,
				_String|{_String..},Position,
				_Integer|{_Integer..},Index
			],
			Lookup[newOps, InputFormat]
		],
		Lookup[newOps, OutputFormat]
	];

	(* Convert the list of indexes back to the outputformat. Need to map over it because this removes the ambiguity of whether {1, 2} is an ordered pair or a listable input of two different indices *)
	convertWellOptions = PassOptions[AllWells, ConvertWell, newOps];
	If[Depth[range] <= 2,
		wells = ConvertWell[range, InputFormat -> Index, OutputFormat -> outputFormat, convertWellOptions],
		wells = ConvertWell[#, InputFormat -> Index, OutputFormat -> outputFormat, convertWellOptions]& /@ range;
	];

	(* If the Orientation is none, return the wells as they stand, otherwise determine the rows and cols, the negative padding, and partition the result *)
	Switch[Lookup[newOps, PlateOrientation],
		None,wells,
		_,Module[{rowColResults,numberOfWells,rows,cols,padding,partitioned},

			(* Determine the number of rows and columns *)
			rowColResults = rowCols[newOps];
			If[!MatchQ[rowColResults,{_,_,_}],Return[]];

			(* split up the row cols and number of wells *)
			{numberOfWells,rows,cols}=rowColResults;

			(* Determine the padding between the first column and the first well *)
			padding=Mod[cols-(Mod[startIndex,12,1]-1),cols];

			(* Partition up the results *)
			partitioned=PartitionRemainder[wells,cols,NegativePadding->padding];

			(* Partition the list of outputs into rows, cols, and plates based on the Plate orientation *)
			Switch[Lookup[newOps, PlateOrientation],
				Landscape,partitioned,
				Portrait,Module[{prePadded,transposed},

					(* Prepad before transposing *)
					prePadded=PadLeft[partitioned,{rows,cols}];

					(* Now transpose and reverse to produce the Portrat form *)
					transposed=Reverse[Transpose[prePadded]];

					(* Now strip off the padding we added *)
					Cases[#, Except[0]]& /@ transposed
				]
			]
		]
	]
];

(* --- Overload for a list of end wells --- *)
AllWells[myWells:{WellP..}, ops:OptionsPattern[]]:= AllWells[1, myWells, ops];

(* --- Overload for end wells only --- *)
AllWells[endWell:WellP,ops:OptionsPattern[]]:= AllWells[1, endWell, ops];

(* --- Overload for no input --- *)
AllWells[ops:OptionsPattern[]]:=Module[
	{safeOps, rowColResults, numberOfWells, rows, cols, outputFormat, cache, model, newOps, optionAspectRatio,
		optionNumWells, modelAspectRatio, modelNumWells},

	(* if just provided as AllWells[], with no options (or saying NumberOfWells -> 96), just return the 96 well configuration directly *)
	If[MatchQ[ToList[ops], {} | {NumberOfWells->96}],
		Return[{
			{"A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12"},
			{"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12"},
			{"C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"},
			{"D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12"},
			{"E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12"},
			{"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"},
			{"G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12"},
			{"H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "H11", "H12"}
		}]
	];
	(* Hardcode 384 or 1 AllWells for speed *)
	(* if just provided as AllWells[], with no options (or saying NumberOfWells -> 96), just return the 96 well configuration directly *)
	If[MatchQ[ToList[ops], {NumberOfWells->1}],
		Return[{
			{"A1"}
		}]
	];
	If[MatchQ[ToList[ops], {NumberOfWells->384}],
		Return[
			{
				{"A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11","A12", "A13", "A14", "A15", "A16", "A17", "A18", "A19", "A20","A21", "A22", "A23", "A24"},
				{"B1", "B2", "B3", "B4", "B5", "B6","B7", "B8", "B9", "B10", "B11", "B12", "B13", "B14", "B15", "B16","B17", "B18", "B19", "B20", "B21", "B22", "B23", "B24"},
				{"C1","C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12","C13", "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21","C22", "C23", "C24"},
				{"D1", "D2", "D3", "D4", "D5", "D6", "D7","D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17","D18", "D19", "D20", "D21", "D22", "D23", "D24"},
				{"E1", "E2", "E3","E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12", "E13","E14", "E15", "E16", "E17", "E18", "E19", "E20", "E21", "E22","E23", "E24"},
				{"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8","F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18","F19", "F20", "F21", "F22", "F23", "F24"},
				{"G1", "G2", "G3", "G4","G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12", "G13", "G14","G15", "G16", "G17", "G18", "G19", "G20", "G21", "G22", "G23","G24"},
				{"H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9","H10", "H11", "H12", "H13", "H14", "H15", "H16", "H17", "H18","H19", "H20", "H21", "H22", "H23", "H24"},
				{"I1", "I2", "I3", "I4","I5", "I6", "I7", "I8", "I9", "I10", "I11", "I12", "I13", "I14","I15", "I16", "I17", "I18", "I19", "I20", "I21", "I22", "I23","I24"},
				{"J1", "J2", "J3", "J4", "J5", "J6", "J7", "J8", "J9","J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18","J19", "J20", "J21", "J22", "J23", "J24"},
				{"K1", "K2", "K3", "K4","K5", "K6", "K7", "K8", "K9", "K10", "K11", "K12", "K13", "K14","K15", "K16", "K17", "K18", "K19", "K20", "K21", "K22", "K23","K24"},
				{"L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9","L10", "L11", "L12", "L13", "L14", "L15", "L16", "L17", "L18","L19", "L20", "L21", "L22", "L23", "L24"},
				{"M1", "M2", "M3", "M4","M5", "M6", "M7", "M8", "M9", "M10", "M11", "M12", "M13", "M14","M15", "M16", "M17", "M18", "M19", "M20", "M21", "M22", "M23","M24"},
				{"N1", "N2", "N3", "N4", "N5", "N6", "N7", "N8", "N9","N10", "N11", "N12", "N13", "N14", "N15", "N16", "N17", "N18","N19", "N20", "N21", "N22", "N23", "N24"},
				{"O1", "O2", "O3", "O4","O5", "O6", "O7", "O8", "O9", "O10", "O11", "O12", "O13", "O14","O15", "O16", "O17", "O18", "O19", "O20", "O21", "O22", "O23","O24"},
				{"P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9","P10", "P11", "P12", "P13", "P14", "P15", "P16", "P17", "P18","P19", "P20", "P21", "P22", "P23", "P24"}
			}

		]
	];


	(* Safely extract the options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],
		{Null, Null}
	];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}],
		safeOps
	];

	(* Determine the number of wells, rows, and columns (and return $Failed if it is wrong) *)
	rowColResults = rowCols[newOps];
	If[Not[MatchQ[rowColResults ,{_, _, _}]],
		Return[$Failed]
	];

	(* split up the row cols and number of wells *)
	{numberOfWells, rows, cols} = rowColResults;

	(* Resolve the output format as position if set to automatic *)
	outputFormat = If[MatchQ[Lookup[newOps, OutputFormat], Automatic],
		Position,
		Lookup[newOps, OutputFormat]
	];

	(* Now generate all of the wells *)
	AllWells[numberOfWells, OutputFormat -> outputFormat, PassOptions[AllWells, newOps]]

];

(* --- Overload for plate model --- *)
AllWells[myModel:ObjectP[Model[Container, Plate]], ops:OptionsPattern[]]:=Module[
	{safeOps, cache, opsModel, packet, newOps, optionAspectRatio, optionNumWells, modelAspectRatio, modelNumWells},

	(* get the safe options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, opsModel, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model given in the options doesn't match the options given as an input, return an error *)
	If[MatchQ[opsModel, ObjectP[Model[Container, Plate]]] && Download[myModel, Object] =!= Download[opsModel, Object],
		(
			Message[AllWells::ModelMismatch, myModel, opsModel];
			Return[$Failed]
		)
	];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = Download[myModel, {AspectRatio, NumberOfWells}, Cache -> cache];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, myModel, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, myModel, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* replace the AspectRatio and NumberOfWells in safeOps with those of the inputted model *)
	newOps = ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}];

	(* pass the new options to the core function *)
	AllWells[newOps]
];


(* --- Overload that takes in a plate object rather than a plate model --- *)
AllWells[myContainer:ObjectP[Object[Container, Plate]], ops:OptionsPattern[]]:=Module[
	{safeOps, cache, opsModel, newOps, modelValues, optionAspectRatio, optionNumWells, containerModel, modelAspectRatio,
		modelNumWells},

	(* get the safe options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* Pull out the model and cache options *)
	{cache, opsModel, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* Download the necessary information from the container *)
	modelValues = Download[myContainer, Model[{Object, AspectRatio, NumberOfWells}], Cache -> cache];

	(* if there is no model for the container, return an error *)
	If[NullQ[modelValues],
		(
			Message[AllWells::MissingModel, myContainer];
			Return[$Failed]
		)
	];

	(* pull out the values Downloaded from the model *)
	{containerModel, modelAspectRatio, modelNumWells} = modelValues;

	(* if the model given in the options doesn't match the options given as an input, return an error *)
	If[MatchQ[opsModel, ObjectP[Model[Container, Plate]]] && Download[opsModel, Object] =!= containerModel,
		(
			Message[AllWells::ObjectModelMismatch, myContainer, opsModel];
			Return[$Failed]
		)
	];

	(* if the aspect ratio was specified and it doesn't match the aspect ratio of the inputted object, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, opsModel, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if the number of wells was specified and it doesn't match the number of wells of the inputted object, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, opsModel, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}];

	(* Call all wells with the new safe options *)
	AllWells[newOps]

];

(* --- Overload taking in a container vessel rather than a plate --- *)
AllWells[myVessel:ObjectP[{Model[Container,Vessel],Object[Container,Vessel],Object[Container,Cuvette],Model[Container,Cuvette]}], ops:OptionsPattern[]]:=AllWells[AspectRatio -> 1, NumberOfWells -> 1, ops];

(* --- Overload with both a list of start wells and a list of end wells --- *)
AllWells[startWells:{WellP..},endWells:{WellP..},ops:OptionsPattern[]]:=Module[
	{safeOps, model, cache, newOps, mapThreadPair, optionAspectRatio, optionNumWells, modelAspectRatio,
		modelNumWells},

	(* get the safe options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],
		{Null, Null}
	];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}],
		safeOps
	];

	(* if the length of the start and end wells are the same, then we will just MapThread them *)
	(* if the length of the start and end wells are not the same, assume we want to get every combination of start and end wells and use Tuples to MapThread over *)
	mapThreadPair = If[SameLengthQ[startWells, endWells],
		{startWells, endWells},
		Transpose[Tuples[{startWells, endWells}]]
	];

	(* MapThread over the pairs of start and end wells, using the new options with the model packet included if originally specified *)
	MapThread[
		AllWells[#1, #2, newOps]&,
		mapThreadPair
	]

];

(* overload with a list of start wells but only one end well *)
AllWells[startWells:{WellP..}, endWell:WellP, ops:OptionsPattern[]]:=Module[
	{safeOps, cache, model, newOps, optionAspectRatio, optionNumWells, modelAspectRatio, modelNumWells},

	(* get the safe options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],
		{Null, Null}
	];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}],
		safeOps
	];

	(* map over every one of the start wells for the single specified end well, passing the pre-downloaded model packet to the core function each time*)
	Map[
		AllWells[#, endWell, newOps]&,
		startWells
	]
];

(* overload with a single starting well and a list of ending wells *)
AllWells[startWell:WellP, endWells:{WellP..}, ops:OptionsPattern[]]:=Module[
	{safeOps, cache, model, newOps, optionAspectRatio, optionNumWells, modelAspectRatio, modelNumWells},

	(* get the safe options *)
	safeOps = SafeOptions[AllWells, ToList[ops]];

	(* pull out the model and cache options *)
	{cache, model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Cache, Model, AspectRatio, NumberOfWells}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],
		{Null, Null}
	];

	(* if both the aspect ratio and the model were specified, and their aspect ratios conflict, return an error *)
	If[Not[MatchQ[optionAspectRatio, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionAspectRatio] == N[modelAspectRatio]],
		(
			Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio];
			Return[$Failed]
		)
	];

	(* if both the number of wells and the model were specified, and their number of wells conflict, return an error *)
	If[Not[MatchQ[optionNumWells, Automatic]] && MatchQ[model, ObjectP[Model[Container, Plate]]] && Not[N[optionNumWells] == N[modelNumWells]],
		(
			Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells];
			Return[$Failed]
		)
	];

	(* if the model was specified, then replace the AspectRatio and NumberOfWells in safeOps with those values, and set Model to None; otherwise, just use the safeOps *)
	newOps = If[MatchQ[model, ObjectP[Model[Container, Plate]]],
		ReplaceRule[safeOps, {Model -> None, AspectRatio -> modelAspectRatio, NumberOfWells -> modelNumWells}],
		safeOps
	];

	(* map over every one of the end wells for the single specified starting well, passing the pre-downloaded model packet to the core function each time *)
	Map[
		AllWells[startWell, #, newOps]&,
		endWells
	]
];



(* ::Subsection::Closed:: *)
(*ConvertWell*)


DefineOptions[ConvertWell,
	Options :> {
		{Model -> None, None | ObjectP[Model[Container,Plate]], "Plate Model to be used in determine the AspectRatio and NumberOfWells that plate could contain."},
		{AspectRatio -> Automatic, Automatic | _?NumericQ, "The ratio of rows to columns that the plate could contain."},
		{NumberOfWells -> Automatic, Automatic | _Integer, "The maximum number of well the plate can contain."},
		{MultiplePlates -> Automatic, Joined | Split | Wrap | Ignore | Strict | Automatic, "Instructions on how to handle wells that exceed the maximum NumberOfWells in the output.  \nOptions include Split (which breaks the well into a list of the form {plate number, well} e.g. {1,3}), \nWrap - (which wraps the position back around to the first position after exceeding the NumberOfWells e.g. 97->1), \nStrict - (which throws an error if the index crosses the boundary into more than one plate),\nJoined - (which fuses the plate to the position string and only works when the output format is a position), \nIgnore - (which allows the position to exceed the maximum NumberOfWells e.g. \"Z100\"),\nor Automatic - (which will match input well formats, or default to Ignore if no input wells are provided)."},
		{InputFormat -> Automatic, Automatic | WellTypeP, "Well indexing format of incoming well information. Options include Automatic (which will attempt to decipher automatically), or anything in WellTypeP."},
		{OutputFormat -> Automatic, Automatic | WellTypeP, "Well indexing format of outgoing well information. Options include Automatic (which will match the input format), or anything in WellTypeP."},
		CacheOption
	}];


ConvertWell::AspectRatioConflict="The aspect ratio of the provided model `1` (`2`) does not agree with the provided AspectRatio (`3`).  Please ensure that the AspectRatio you are specifying agrees with the AspectRatio of the Model plate you are specifying.";
ConvertWell::NumberOfWellsConflict="The number of wells of the provided model `1` (`2`) does not agree with the provided NumberOfWells (`3`).  Please ensure that the NumberOfWells you are specifying agrees with the NumberOfWells of the Model plate you are specifying.";
ConvertWell::InputFormatConflict="The provided InputFormat `1` did not match the input format that was resolved from the input wells `2`.  Please ensure that the input well is specified in such away that matches the InputFormat option.";
ConvertWell::BadRatio="The AspectRatio `1` and the NumberOfWells `2` would lead to an irregular shaped plate (not rectangular).  Please ensure that Sqrt[NumberOfWells*AspectRatio] and Sqrt[NumberOfWells/AspectRatio] are integers.";
ConvertWell::JoinedIndex="MultiplePlates is set to Joined but OutputFormat was specified as or resolved to `1`.  Please note that if MultiplePlates is set to Joined, OutputFormat must be set to Position.";
ConvertWell::Strict="When MultiplePlates is set to Strict, the input well must not exceed the maximum NumberOfWells.  Please set MultiplePlates to another option besides Strict, or change the input so as not to exceed NumberOfWells.";

(* singleton core function *)
ConvertWell[myWell:WellP,ops:OptionsPattern[]]:=Module[
	{safeOps, model, cache, optionAspectRatio, modelAspectRatio, modelNumWells, optionNumWells, aspectRatio,
		optionInputFormat, optionOutputFormat, wellFormat, inputFormat, outputFormat, newOps, numRows,numColumns,
		multiplePlates,numberOfWells,rawWell,rowColForm,finalForm},

	(* Safely extract the options *)
	safeOps = SafeOptions[ConvertWell, ToList[ops]];

	(* pull the model and cache out of the safe options *)
	{model, cache, optionAspectRatio, optionNumWells, optionInputFormat, optionOutputFormat} = Lookup[safeOps, {Model, Cache, AspectRatio, NumberOfWells, InputFormat, OutputFormat}];

	(* if a model is provided, extract out the AspectRatio and NumberOfWells *)
	{modelAspectRatio, modelNumWells} = Which[
		And[
			MatchQ[model,PacketP[]],
			KeyExistsQ[model, AspectRatio],
			KeyExistsQ[model, NumberOfWells]
		],
		Lookup[model, {AspectRatio, NumberOfWells}],

		MatchQ[model, ObjectP[]],
		Download[model, {AspectRatio, NumberOfWells}, Cache -> cache],

		True,
		{Null, Null}
	];

	(* resolve the aspect ratio for the plate in question given the options *)
	(* NOTE: AspectRatio MUST be rationalized in order to avoid ConvertWell::BadRatio below! *)
	(* if aspect ratio was not specified in the options, and neither was the plate model, assume 3/2 *)
	(* if the aspect ratio was not specified in the options but a plate model was specified, use the plate model's aspect ratio *)
	(* if the aspect ratio was specified but model was not specified, then use the specified aspect ratio *)
	(* if the aspect ratio was specified AND the model was specified, ensure that they are the same aspect ratio: if they are, then use that one, and if they are not, return a message *)
	aspectRatio = Which[
		MatchQ[optionAspectRatio, Automatic] && NullQ[modelAspectRatio], 3/2,
		MatchQ[optionAspectRatio, Automatic], Rationalize[modelAspectRatio],
		NullQ[modelAspectRatio], Rationalize[optionAspectRatio],
		optionAspectRatio == modelAspectRatio, Rationalize[modelAspectRatio],
		True, (Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio]; Return[$Failed])
	];
	
	(* resolve the number of wells for the plate in question given the options *)
	(* if the number of wells was not specified in the options, and neither was the plate model, assume a 96 well plate *)
	(* if the number of wells was not specified in the options but a plate model was specified, use the plate model's number of wells *)
	(* if the number of wells was specified but model was not specified, then use the specified number of wells *)
	(* if the number of wells was specified AND the model was specified, ensure that they are the same number of wells: if they are, then use that one, and if they are not, return a message *)
	numberOfWells = Which[
		MatchQ[optionNumWells, Automatic] && NullQ[modelNumWells], 96,
		MatchQ[optionNumWells, Automatic], modelNumWells,
		NullQ[modelNumWells], optionNumWells,
		optionNumWells == modelNumWells, modelNumWells,
		True, (Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells]; Return[$Failed])
	];

	(* construct new options that include the resolved NumberOfWells and AspectRatio values, and no longer has the Model *)
	newOps = ReplaceRule[
		safeOps,
		{NumberOfWells -> numberOfWells, AspectRatio -> aspectRatio, Model -> None}
	];

	(* check if the input matches {_Integer, _Integer} AND the optionInputFormat matches RowColumnIndex; if this is the case, then we are in the wrong overload and need to map over ConvertWell *)
	(* this is because {1,2} matches WellP AND {WellP..}, which causes some issues *)
	(* we wait until now to do this mapping to avoid having to Download twice *)
	If[MatchQ[myWell, {_Integer, _Integer}] && MatchQ[optionInputFormat, Index | TransposedIndex | SerpentineIndex | StaggeredIndex | TransposedSerpentineIndex | TransposedStaggeredIndex],
		Return[ConvertWell[#, newOps]& /@ myWell]
	];

	(* Determine the number of wells and the number of columns in each plate *)
	numRows = Sqrt[numberOfWells*(1/aspectRatio)];
	numColumns = Sqrt[numberOfWells*aspectRatio];
	
	(* Throw an error and exit if the rows and columns are not integers *)
	If[Not[IntegerQ[numRows] && IntegerQ[numColumns]],
		(
			Message[ConvertWell::BadRatio, aspectRatio, numberOfWells];
			Return[$Failed]
		)
	];

	(* See what format the explicit formating suggests the well is *)
	wellFormat = Switch[myWell,
		_String|{_String..},Position,
		_Integer|{_Integer..}|{_Integer, {_Integer, _Integer}}, Automatic
	];

	(* check the input format *)
	(* if the option InputFormat and wellFormat are BOTH Automatic, then assume the inputFormat of Index *)
	(* if the option InputFormat is Automatic and the wellFormat is not Automatic, then use whatever wellFormat resolved to *)
	(* if wellFormat resolved to Automatic, and the specified option InputFormat was anything but Position, use the option InputFormat *)
	(* if wellFormat and the specified option for InputFormat are the same, just use that one *)
	(* if the specified option input format conflicts with what wellFormat resolved to, return an error *)
	inputFormat = Which[
		MatchQ[optionInputFormat, Automatic] && MatchQ[wellFormat, Automatic], Index,
		MatchQ[optionInputFormat, Automatic] && Not[MatchQ[wellFormat, Automatic]], wellFormat,
		MatchQ[wellFormat, Automatic] && MatchQ[optionInputFormat, Except[Position]], optionInputFormat,
		MatchQ[wellFormat, optionInputFormat], optionInputFormat,
		True, (Message[ConvertWell::InputFormatConflict, optionInputFormat, myWell]; Return[$Failed])
	];


	(* Determine the output format *)
	(* if the option OutputFormat is Automatic and the resolved input format is Position, the output must be Index *)
	(* if the option OutputFormat is Automatic and the resolved input format is anything else, the output must be Position *)
	(* if the option OutputFormat is specified, use that *)
	outputFormat = Which[
		MatchQ[optionOutputFormat, Automatic] && MatchQ[inputFormat, Position], Index,
		MatchQ[optionOutputFormat, Automatic], Position,
		True, optionOutputFormat
	];

	(* Extract the raw well information, Convert it to uppercase *)
	rawWell = myWell /. x_String :> ToUpperCase[x];

	(* Determine how to handle indexes that run over into multiple plates *)
	multiplePlates=Switch[Lookup[safeOps, MultiplePlates],
		Joined,If[!MatchQ[outputFormat,Position],(Message[ConvertWell::JoinedIndex,outputFormat];Split),Joined],
		Automatic,Module[{primaryRow,primaryCol,wellIndex},

			(* Do a primary conversion to see if the inputed well exceeds one plate or not *)
			{primaryRow,primaryCol}=toRowCol[rawWell,numRows,numColumns,inputFormat,Ignore];

			(* if the well index exceeds the number of wells set the multi format to split or joined *)
			If[numberOfWells<(primaryCol+(primaryRow-1)*numColumns),
				If[MatchQ[outputFormat,Position],Joined,Split],
				Strict
			]
		],
		_, Lookup[safeOps, MultiplePlates]
	];

	(* Convert to row col format *)
	rowColForm = toRowCol[rawWell,numRows,numColumns,inputFormat,multiplePlates];

	(* Convert from row col format to whatever the outputformat requests *)
	finalForm = fromRowCol[rowColForm,numRows,numColumns,outputFormat,multiplePlates]

];


(* listable case is mapping *)
(* if a model is specified, get the information from it now  *)
ConvertWell[myWells:{WellP...},ops:OptionsPattern[]]:=Module[
	{safeOps, model, cache, packet, newOps},
	
	(* get the safe options *)
	safeOps = SafeOptions[ConvertWell, ToList[ops]];
	
	(* get the model from the safe options *)
	{cache, model} = Lookup[safeOps, {Cache, Model}];

	(* if the model is an object, then Download NumberOfWells and AspectRatio *)
	packet = Which[
		And[
			MatchQ[model, PacketP[Model[Container, Plate]]],
			KeyExistsQ[model, AspectRatio],
			KeyExistsQ[model, NumberOfWells]
		],
		model,

		MatchQ[model, ObjectP[Model[Container, Plate]]],
		Download[model, Packet[Object, AspectRatio, NumberOfWells], Cache -> cache],

		True,
		Nothing
	];

	(* if the model was a packet, then replace the object in safeOps with the model; otherwise, just use the safeOps *)
	newOps = If[MatchQ[packet, PacketP[]],
		ReplaceRule[safeOps, {Model -> packet}],
		safeOps
	];
	
	(* map over the wells to do ConvertWell, but with the Model as a packet if that was specified *)
	ConvertWell[#, newOps]& /@ myWells
];



rowCols[safeOps_List]:=Module[
	{model, modelInf, modelAspectRatio, modelNumWells, aspectRatio, numberOfWells, numRows, numColumns, optionAspectRatio,
		optionNumWells},

	(* pull the model, specified aspect ratio, and specified number of wells out of the safe options *)
	{model, optionAspectRatio, optionNumWells} = Lookup[safeOps, {Model, AspectRatio, NumberOfWells}];

	(* Extract the model's aspect ratio and Maximum number of wells if there is one; the model should be stored as a packet now since it was passed from above *)
	{modelAspectRatio, modelNumWells} = If[MatchQ[model, PacketP[Model[Container, Plate]]],
		Lookup[model, {AspectRatio, NumberOfWells}],
		{Null, Null}
	];

	(* resolve the aspect ratio for the plate in question given the options *)
	(* if aspect ratio was not specified in the options, and neither was the plate model, assume 3/2 *)
	(* if the aspect ratio was not specified in the options but a plate model was specified, use the plate model's aspect ratio *)
	(* if the aspect ratio was specified but model was not specified, then use the specified aspect ratio *)
	(* if the aspect ratio was specified AND the model was specified, ensure that they are the same aspect ratio: if they are, then use that one, and if they are not, return a message *)
	aspectRatio = Which[
		MatchQ[optionAspectRatio, Automatic] && NullQ[modelAspectRatio], 3/2,
		MatchQ[optionAspectRatio, Automatic], modelAspectRatio,
		NullQ[modelAspectRatio], optionAspectRatio,
		optionAspectRatio == modelAspectRatio, modelAspectRatio,
		True, (Message[ConvertWell::AspectRatioConflict, model, modelAspectRatio, optionAspectRatio]; Return[$Failed])
	];

	(* resolve the number of wells for the plate in question given the options *)
	(* if the number of wells was not specified in the options, and neither was the plate model, assume a 96 well plate *)
	(* if the number of wells was not specified in the options but a plate model was specified, use the plate model's number of wells *)
	(* if the number of wells was specified but model was not specified, then use the specified number of wells *)
	(* if the number of wells was specified AND the model was specified, ensure that they are the same number of wells: if they are, then use that one, and if they are not, return a message *)
	numberOfWells = Which[
		MatchQ[optionNumWells, Automatic] && NullQ[modelNumWells], 96,
		MatchQ[optionNumWells, Automatic], modelNumWells,
		NullQ[modelNumWells], optionNumWells,
		optionNumWells == modelNumWells, modelNumWells,
		True, (Message[ConvertWell::NumberOfWellsConflict, model, modelNumWells, optionNumWells]; Return[$Failed])
	];

	(* Determine the number of wells and the number of columns in each plate *)
	numRows = Sqrt[numberOfWells*(1/aspectRatio)];
	numColumns = Sqrt[numberOfWells*aspectRatio];

	(* Throw an error and exit if the rows and columns are not integers *)
	If[Not[IntegerQ[numRows] && IntegerQ[numColumns]],
		(
			Message[ConvertWell::BadRatio, aspectRatio, numberOfWells];
			Return[$Failed]
		)
	];

	(* return the result *)
	{numberOfWells, numRows, numColumns}

];


(* Helper function for generating the list of letter \[Rule] number for positions on the basis of its depth *)
rowNames[x_String]:=x<>#&/@CharacterRange["A","Z"];
rowNames[x:{_String..}]:=Flatten[rowNames/@x];
rowNames[depth_Integer]:=Module[{letterList},

	(* Generate the nested list of numbers *)
	letterList=Nest[Join[#,rowNames[#]]&,CharacterRange["A","Z"],depth-1];

	(* Turn it into a map of letter \[Rule] thing *)
	MapIndexed[#1->First[#2]&,letterList]

];
(* Inverse helper function for generating number \[Rule] letter positions on the basis of index number *)
nestSum[index_Integer]:=nestSum[index,1];
nestSum[index_Integer,n_Integer]:=nestSum[index,n+1]/;26/25 (-1+26^n)<index;
nestSum[index_Integer,n_Integer]:=n/;26/25 (-1+26^n)>=index;

nameRows[index_Integer]:=Module[{depth,letterList},

	(* Determine the maximum required depth *)
	depth=nestSum[index];
	(* This is actually a complicated expression since you need to determine n when 26/25 (-1+26^n)\[GreaterEqual]index,
	 * which I was unable to solve algebraically, so I did it using a recurence relation above
	*)

	(* Generate the nested list of numbers *)
	letterList=Nest[Join[#,rowNames[#]]&,CharacterRange["A","Z"],depth-1];

	(* Turn it into a map of thing \[Rule] letter *)
	MapIndexed[First[#2]->#1&,letterList]

];

(* --- Helper function, Handling multiple plaetes --- *)
toRowCol[{plateString_String,position_String},rows_Integer,columns_Integer,format_,multiplePlates_]:=Module[
{letters,plate,row,col,letterConversion,rowLetters},


	(* Pull out the letters in the position *)
	letters=First[StringCases[position,LetterCharacter..]];

	(* Generate the letter conversion rules for rows *)
	letterConversion=rowNames[StringLength[letters]];

	(* Pull out the plate number from a joined Position type *)
	plate=ToExpression[plateString];

	(* Pull out the letters defining the row *)
	rowLetters=First[StringCases[position,letters:LetterCharacter..:>Characters[letters]]];

	(* Convert the row letters to numbers *)
	row=letters/.letterConversion;

	(* Pull out the column information *)
	col=First[StringCases[position,LetterCharacter..~~(nums:NumberString):>ToExpression[nums]]];

	(* Continue with the conversion now that we've converted to RowColumnIndex form *)
	toRowCol[{plate,{row,col}},rows,columns,RowColumnIndex,multiplePlates]

];
toRowCol[position_String,rows_Integer,columns_Integer,format_,multiplePlates_]:=Module[
{letters,letterConversion,plate,row,col,rowLetters},

	(* Pull out the letters in the position *)
	letters=First[StringCases[position,LetterCharacter..]];

	(* Generate the letter conversion rules for rows *)
	letterConversion=rowNames[StringLength[letters]];

	(* Pull out the plate number from a joined Position type *)
	plate=StringCases[position,(nums:NumberString)~~LetterCharacter:>nums]/.{{x_String}:>ToExpression[x],{}->Null};

	(* Convert the row letters to numbers *)
	row=letters/.letterConversion;

	(* Pull out the column information *)
	col=First[StringCases[position,LetterCharacter..~~(nums:NumberString):>ToExpression[nums]]];

	(* Continue with the conversion now that we've converted to RowColumnIndex form *)
	If[MatchQ[plate,Null],
		toRowCol[{row,col},rows,columns,RowColumnIndex,multiplePlates],
		toRowCol[{plate,{row,col}},rows,columns,RowColumnIndex,multiplePlates]
	]

];

(* --- Helper function, getting to {Row,Column} format from anywhere --- *)
toRowCol[{plate_Integer,{row_Integer,col_Integer}},rows_Integer,columns_Integer,RowColumnIndex,multiplePlates_]:=toRowCol[{(plate-1)rows+row,col},rows,columns,RowColumnIndex,multiplePlates];
toRowCol[{plate_Integer,index_Integer},rows_Integer,columns_Integer,format_,multiplePlates_]:=toRowCol[(plate-1)rows*columns+index,rows,columns,format,multiplePlates];
toRowCol[index:{_Integer,_Integer},rows_Integer,columns_Integer,RowColumnIndex,multiplePlates_]:=index;
toRowCol[index_Integer,rows_Integer,columns_Integer,format_,multiplePlates_]:=Switch[format,
	Index,{Ceiling[index/columns],Mod[index,columns,1]},
	TransposedIndex,{Mod[index,rows,1],Ceiling[index/rows]},
	SerpentineIndex,Module[{row,col},
		row=Ceiling[index/columns];
		col=If[EvenQ[row],(columns+1)-Mod[index,columns,1],Mod[index,columns,1]];
		{row,col}
	],
	TransposedSerpentineIndex,Module[{row,col},
		col=Ceiling[index/rows];
		row=If[EvenQ[col],(rows+1)-Mod[index,rows,1],Mod[index,rows,1]];
		{row,col}
	],
	StaggeredIndex,Module[{row,col},
		col=If[Mod[index,columns,1]>Round[columns/2],
			2*Mod[index,columns/2,1],
			(2*Mod[index,columns,1])-1
		];
		row=Ceiling[index/columns];
		{row,col}
	],
	TransposedStaggeredIndex,Module[{row,col},
		row=If[Mod[index,rows,1]>Round[rows/2],
			2*Mod[index,rows/2,1],
			(2*Mod[index,rows,1])-1
		];
		col=Ceiling[index/rows];
		{row,col}
	]
];

(* --- Helper function, getting from {Row,Column} into any other format --- *)
fromRowCol[{row_Integer,col_Integer},rows_Integer,columns_Integer,format_,multiplePlates_]:=Switch[multiplePlates,
	Joined,If[MatchQ[format,Position],
		ToString[Ceiling[row/rows]]<>fromRowCol[{Mod[row,rows,1],Mod[col,columns,1]},rows,columns,format],
		Message[ConvertWell::JoinedIndex,format]
	],
	Split,If[MatchQ[format,Position],
		{ToString[Ceiling[row/rows]],fromRowCol[{Mod[row,rows,1],Mod[col,columns,1]},rows,columns,format]},
		{ToString[Ceiling[row/rows]],fromRowCol[{Mod[row,rows,1],Mod[col,columns,1]},rows,columns,format]}
	],
	Wrap,fromRowCol[{Mod[row,rows,1],Mod[col,columns,1]},rows,columns,format],
	Strict,If[row>rows||col>columns,(Message[ConvertWell::Strict];Return[$Failed]),fromRowCol[{row,col},rows,columns,format]],
	Ignore,fromRowCol[{row,col},rows,columns,format]
];

fromRowCol[{row_Integer,col_Integer},rows_Integer,columns_Integer,format_]:=Switch[format,
	RowColumnIndex,{row,col},
	Index,col+(row-1)*columns,
	TransposedIndex,(col-1)rows+row,
	SerpentineIndex,If[EvenQ[row],
		(row)*columns-(col-1),
		col+(row-1)*columns
	],
	TransposedSerpentineIndex,If[EvenQ[col],
		(rows-row+1)+rows*(col-1),
		row+rows*(col-1)
	],
	StaggeredIndex,If[EvenQ[col],
		Ceiling[columns/2]+Ceiling[col/2]+(row-1)*columns,
		Ceiling[col/2]+(row-1)*columns
	],
	TransposedStaggeredIndex,If[EvenQ[row],
		Ceiling[rows/2]+Ceiling[row/2]+(col-1)*rows,
		Ceiling[row/2]+(col-1)*rows
	],
	Position,Module[{letterConversion},

		(* Generate the leter conversio list to get from row number to row letter *)
		letterConversion=nameRows[row];

		(* Patch togeather the string position *)
		(row/.letterConversion)<>ToString[col]
	]
];


(* ::Subsection::Closed:: *)
(*centrifugeBalance*)


DefineOptions[centrifugeBalance,
	Options :> {
		{AllowedImbalance -> 0.5Gram, GreaterEqualP[0Gram] | RangeP[0*Percent, 100*Percent], "The maximum allowed mass difference between two paired containers, specified either as a mass or a percent of the heaviest input container's weight."},
		{ReturnMasses -> False, BooleanP, "Whether the paired and unpaired containers should be returned with or without their masses."}
	}];

(* - Resursive function to pair containers based on mass - *)

(* Wrapper function: Pass the initial arguments, an empty list to hold paired and unpaired containers, and the resolved options *)
centrifugeBalance[myContainerWeightPairs:{{ObjectP[Object[Container]],MassP,{_Integer..}}..}|{{ObjectP[Object[Container]],MassP}..},myOptions:OptionsPattern[centrifugeBalance]]:=Module[{safeOptions,specifiedAllowedImbalance,allowedImbalance,specifiedReturnMasses},

	(* Get the options *)
	safeOptions=SafeOptions[centrifugeBalance, ToList[myOptions]];
	{specifiedAllowedImbalance,specifiedReturnMasses}=Lookup[safeOptions,{AllowedImbalance,ReturnMasses}];

	(* Figure out the allowed imbalance as a mass. (If it was specified as a percent, determine the max container mass and multiply by the percent) *)
	allowedImbalance=If[MassQ[specifiedAllowedImbalance],
		specifiedAllowedImbalance,
		Max[myContainerWeightPairs[[All, 2]]]*specifiedAllowedImbalance
	];

	(* Pass the unpaired container input, and empty list of paired containers, and the resolved AllowedImbalance to the core recursive fuction *)
	(* Since OptionsPattern will recognize any number of empty lists, wrap the paired and unpaired container lists into a top level list so that the wrapper doesn't get stuck in a recursion of itself.
	 		Another option would be to do the first round of recursion in the wrapper. Chose the nested list route for code consolidation. *)
	centrifugeBalance[{myContainerWeightPairs,{}},AllowedImbalance->allowedImbalance,ReturnMasses->specifiedReturnMasses]
];

(* Recursive function: If there are multiple entries in the unpairedContainers list, pair containers where possible. *)
centrifugeBalance[{myUnpairedContainers:{Repeated[{ObjectP[Object[Container]],MassP,{_Integer..}},{2,Infinity}]|Repeated[{ObjectP[Object[Container]],MassP},{2,Infinity}]},myPairedContainers:{{{ObjectP[Object[Container]],MassP,{_Integer..}},{ObjectP[Object[Container]],MassP,{_Integer..}}}...}},myOptions:OptionsPattern[centrifugeBalance]]:=Module[{
	allowedImbalance,uniquePairs,minimalPair,massDifference
},

	(* Pull the allowed imbalance from the options. This has already ben resolved in the wrapper function. *)
	allowedImbalance=Lookup[ToList[myOptions],AllowedImbalance];

	(* Helper function to find the mass difference between two containers with given masses. *)
	massDifference[pair:{{ObjectP[Object[Container]],firstContainerMass:MassP,{_Integer..}}|{ObjectP[Object[Container]],firstContainerMass:MassP},{ObjectP[Object[Container]],secondContainerMass:MassP,{_Integer..}}|{ObjectP[Object[Container]],secondContainerMass:MassP}}]:=Abs[firstContainerMass-secondContainerMass];

	(* Find all the possible pairings between the unpaired containers. *)
	uniquePairs=Subsets[myUnpairedContainers,{2}];

	(* Find the possible pairings that have the lowest mass difference between the two containers, and take the first pair from this list. *)
	minimalPair=First[MinimalBy[uniquePairs,massDifference]];

	(* If the mass difference between these two containers is less than the allowable mass imbalance,
			move the containers from the unpaired list to the paired list, and continue recursion.
			Otherwise, return the lists of unpaired and paired containers here. *)
	If[massDifference[minimalPair]<=allowedImbalance,
		centrifugeBalance[
			{DeleteCases[myUnpairedContainers,Alternatives@@minimalPair],
			Append[myPairedContainers,minimalPair]},
			myOptions
		],
		If[TrueQ[Lookup[ToList[myOptions],ReturnMasses]],
			{myPairedContainers,myUnpairedContainers},
			{myPairedContainers[[All,All,1]],myUnpairedContainers[[All,1]]}
		]
	]
];

(* If no {Object, Weight} pairs are left, return the lists of paired and unpaired containers. *)
centrifugeBalance[{myUnpairedContainers:{},myPairedContainers:{{{ObjectP[Object[Container]],MassP,{_Integer..}}|{ObjectP[Object[Container]],MassP},{ObjectP[Object[Container]],MassP,{_Integer..}}|{ObjectP[Object[Container]],MassP}}...}},myOptions:OptionsPattern[centrifugeBalance]]:=If[TrueQ[Lookup[ToList[myOptions],ReturnMasses]],
	{myPairedContainers,myUnpairedContainers},
	{myPairedContainers[[All,All,1]],myUnpairedContainers[[All,1]]}
];

(* If only one {Container, Weight} pair is left, it must be left unpaired. *)
centrifugeBalance[{myUnpairedContainers:{{ObjectP[Object[Container]],MassP,{_Integer..}}|{ObjectP[Object[Container]],MassP}},myPairedContainers:{{{ObjectP[Object[Container]],MassP,{_Integer..}}|{ObjectP[Object[Container]],MassP},{ObjectP[Object[Container]],MassP,{_Integer..}}|{ObjectP[Object[Container]],MassP}}...}},myOptions:OptionsPattern[centrifugeBalance]]:=If[TrueQ[Lookup[ToList[myOptions],ReturnMasses]],
	{myPairedContainers,myUnpairedContainers},
	{myPairedContainers[[All,All,1]],myUnpairedContainers[[All,1]]}
];




(* ::Subsection:: *)
(*PreferredContainer*)
(* List any container model in preferred container hard coded lists here with 1 compatible cover model *)
(* Follow the format: container model -> cover model *)
(* This lookup is used in UploadSample when SimulationMode is True (for example when we call SimulateResources *)
$PreferredContainerCoverLookup = <|
	Model[Container, Plate, "id:O81aEBZjRXvx"]->Model[Item, Lid, "id:4pO6dM56Zpar"],(*Omni Tray Sterile Media Plate*)(*Model[Item, Lid, "Universal Clear Lid, Sterile"]*)
	Model[Container, Plate, "id:lYq9jRqw70m4"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*4-well V-bottom 10 mL Deep Well Plate Non-Sterile*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:AEqRl9qmr111"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*4-well V-bottom 75 mL Deep Well Plate Non-Sterile*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:R8e1PjeVbJ4X"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*4-well V-bottom 75 mL Deep Well Plate Serile*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:L8kPEjnY8dME"]->Model[Item, Lid, "id:qdkmxzqM8Gnx"],(*Nunc Non-Treated 6-well Plate*)(*Model[Item, Lid, "Nunc 6-well Plate Lid"]*)
	Model[Container, Plate, "id:eGakld01zzLx"]->Model[Item, Lid, "id:P5ZnEjdR84al"],(*6-well Tissue Culture Plate*)(*Model[Item, Lid, "Universal SBS Tissue Culture 6 Well Plate Lid"]*)
	Model[Container, Plate, "id:dORYzZJwOJb5"]->Model[Item, Lid, "id:O81aEBZqJv0D"],(*Nunc Non-Treated 12-well Plate*)(*Model[Item, Lid, "Nunc 12-well Plate Lid"]*)
	Model[Container, Plate, "id:GmzlKjY5EE8e"]->Model[Item, Lid, "id:BYDOjvGJAGZX"],(*12-well Tissue Culture Plate*)(*Model[Item, Lid, "Universal SBS Tissue Culture 12 Well Plate Lid"]*)
	Model[Container, Plate, "id:1ZA60vLlZzrM"]->Model[Item, Lid, "id:zGj91a7MdkXL"],(*Nunc Non-Treated 24-well Plate*)(*Model[Item, Lid, "Nunc 24-well Plate Lid"]*)
	Model[Container, Plate, "id:jLq9jXY4kkMq"]->Model[Item, PlateSeal, "id:vXl9j57mandN"],(*24-well Round Bottom Deep Well Plate, Steril*)(*Model[Item, PlateSeal, "AeraSeal Plate Seal, Breathable"]*)
	Model[Container, Plate, "id:qdkmxzkKwn11"]->Model[Item, Lid, "id:XnlV5jKj6AEN"],(*24-well V-bottom 10 mL Deep Well Plate Sterile*)(*Model[Item, Lid, "Universal Clear Lid"]*)
	Model[Container, Plate, "id:E8zoYveRlldX"]->Model[Item, Lid, "id:D8KAEvGrzKml"],(*"24-well Tissue Culture Plate",*)(*Model[Item, Lid, "Universal SBS Tissue Culture 24 Well Plate Lid"]*)
	Model[Container, Plate, "id:Y0lXejMW7NMo"]->Model[Item, Lid, "id:L8kPEjn4DO7P"],(*Nunc Non-Treated 48-well Plat*)(*Model[Item, Lid, "Nunc 48-well Plate Lid"]*)
	Model[Container, Plate, "id:Vrbp1jKw7W9q"]->Model[Item, Lid, "id:L8kPEjn4DO7P"],(*Corning, TC-Surface 48-well Plate*)(*Model[Item, Lid, "Nunc 48-well Plate Lid"]*)
	Model[Container, Plate, "id:E8zoYveRllM7"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*48-well Pyramid Bottom Deep Well Plate*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:P5ZnEjx9Zllk"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*48-well Pyramid Bottom Deep Well Plate, Sterile*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:jLq9jXY4kkKW"]->Model[Item, Lid, "id:xRO9n3BM1Oww"],(*96-well Greiner Tissue Culture Plate*)(*Model[Item, Lid, "96 Well Greiner Plate Lid"]*)
	Model[Container, Plate, "id:4pO6dMOqKBaX"]->Model[Item, Lid, "id:xRO9n3BM1Oww"],(*96-well flat bottom plate, Sterile*)(*Model[Item, Lid, "96 Well Greiner Plate Lid"]*)
	Model[Container, Plate, "id:L8kPEjno5XoE"]->Model[Item, Lid, "id:xRO9n3BM1Oww"],(*96-well Black Wall Tissue Culture Plate*)(*Model[Item, Lid, "96 Well Greiner Plate Lid"]*)
	Model[Container, Plate, "id:6V0npvK611zG"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*96-well Black Wall Plate*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:L8kPEjkmLbvW"]->Model[Item, PlateSeal, "id:pZx9jo8MJAXM"],(*96-well 2mL Deep Well Plate*)(*Model[Item, PlateSeal, "Plate Seal, 96-Well Square"]*)
	Model[Container, Plate, "id:n0k9mGkwbvG4"]->Model[Item, PlateSeal, "id:pZx9jo8MJAXM"],(*"96-well 2mL Deep Well Plate, Sterile"*)(*Model[Item, PlateSeal, "Plate Seal, 96-Well Square"]*)
	Model[Container, Plate, "id:4pO6dMmErzez"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*Sterile Deep Round Well, 2 mL*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:1ZA60vAn9RVP"]->Model[Item, Lid, "id:xRO9n3BM1Oww"],(*96-well Greiner Tissue Culture Plate, Untreated*)(*Model[Item, Lid, "96 Well Greiner Plate Lid"]*)
	Model[Container, Plate, "id:pZx9joxDA8Bj"]->Model[Item, PlateSeal, "id:dORYzZJMop8e"],(*Greiner MasterBlock 1.2ml Deep Well Plate*)(*Model[Item, PlateSeal, "Plate Seal, Aluminum"]*)
	Model[Container, Plate, "id:54n6evLWKqbG"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*200mL Polypropylene Robotic Reservoir*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:AEqRl9qm8rwv"]->Model[Item, PlateSeal, "id:1ZA60vLqbXO6"],(*200mL Polypropylene Robotic Reservoir, Sterile*)(*Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"]*)
	Model[Container, Plate, "id:01G6nvwNDARA"]->Model[Item, PlateSeal, "id:L8kPEjnvlDrN"],(*384-well Low Dead Volume Echo Qualified Plate*)(*Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]*)
	Model[Container, Plate, "id:7X104vn56dLX"]->Model[Item, PlateSeal, "id:L8kPEjnvlDrN"],(*384-well Polypropylene Echo Qualified Plate*)(*Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]*)
	Model[Container, Vessel, "id:AEqRl9KEBOXp"]->Model[Item, Cap, "id:9RdZXv1Ledza"],(*"1.2mL Cryogenic Vial"*)(*Model[Item, Cap, "Tube Cap, 14x15mm"]*)
	Model[Container, Vessel, "id:vXl9j5qEnnOB"]->Model[Item, Cap, "id:8qZ1VW0ldZAZ"],(*"2mL Cryogenic Vial"*)(*Model[Item, Cap, "Tube Cap, 13x17mm"]*)
	Model[Container, Vessel, "id:o1k9jAG1Nl57"]->Model[Item, Cap, "id:9RdZXv1Ledza"],(*"5mL Cryogenic Vial"*)(*Model[Item, Cap, "Tube Cap, 14x15mm"]*)
	Model[Container, Vessel, "id:jLq9jXvxr6OZ"]->Model[Item, Cap, "id:rea9jl1XXBae"],(*HPLC vial (high recovery)*)(*Model[Item, Cap, "2 mL glass CE vial cap"]*)
	Model[Container, Vessel, "id:GmzlKjznOxmE"]->Model[Item, Cap, "id:rea9jl1XXBae"],(*Amber HPLC vial (high recovery)*)(*Model[Item, Cap, "2 mL glass CE vial cap"]*)
	Model[Container, Vessel, "id:qdkmxzqEvPjV"]->Model[Item, Cap, "id:1ZA60vLqbAG5"],(*"2mL small clear glass HPLC vial"*)(*Model[Item, Cap, "Vial Crimp Cap, 11x6mm"]*)
	Model[Container, Vessel, "id:AEqRl9KmRnj1"]->Model[Item, Cap, "id:rea9jl1XXBae"],(*2 mL clear glass GC vial*)(*Model[Item, Cap, "2 mL glass CE vial cap"]*)
	Model[Container, Vessel, "id:01G6nvwz9ekA"]->Model[Item, Cap, "id:Vrbp1jKl0vVo"],(*T25 EasYFlask*)(*Model[Item, Cap, "Flask Cap, 26x16mm"]*)
	Model[Container, Vessel, "id:8qZ1VW0np53Z"]->Model[Item, Cap, "id:01G6nvwXrDeD"],(*T75 EasYFlask*)(*Model[Item, Cap, "Flask Cap, 32x20mm"]*)
	Model[Container, Vessel, "id:qdkmxzqXdJra"]->Model[Item, Cap, "id:eGakldJMze3n"],(*T175 EasYFlask*)(*Model[Item, Cap, "Flask Cap, 34x22mm"]*)
	Model[Container, Vessel, "id:o1k9jAG00e3N"]->Model[Item, Cap, "id:wqW9BP4Y06aR"],(*New 0.5mL Tube with 2mL Tube Skirt*)(*Model[Item, Cap, "2 mL tube cap, standard"]*)
	Model[Container, Vessel, "id:eGakld01zzpq"]->Model[Item, Cap, "id:wqW9BP4Y06aR"],(*"1.5mL Tube with 2mL Tube Skirt"*)(*Model[Item, Cap, "2 mL tube cap, standard"]*)
	Model[Container, Vessel, "id:3em6Zv9NjjN8"]->Model[Item, Cap, "id:wqW9BP4Y06aR"],(*2mL Tube*)(*Model[Item, Cap, "2 mL tube cap, standard"]*)
	Model[Container, Vessel, "id:M8n3rx03Ykp9"]->Model[Item, Cap, "id:wqW9BP4Y06aR"],(*2mL brown tube*)(*Model[Item, Cap, "2 mL tube cap, standard"]*)
	Model[Container, Vessel, "id:bq9LA0dBGGR6"]->Model[Item, Cap, "id:54n6evKx0oqq"],(*50mL Tube*)(*Model[Item, Cap, "50 mL tube cap"]*)
	Model[Container, Vessel, "id:bq9LA0dBGGrd"]->Model[Item, Cap, "id:54n6evKx0oqq"],(*50mL Light Sensitive Centrifuge Tube*)(*Model[Item, Cap, "50 mL tube cap"]*)
	Model[Container, Vessel, "id:jLq9jXvA8ewR"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*100 mL Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:01G6nvwPempK"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*150 mL Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:J8AY5jwzPPR7"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*250 mL Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:XnlV5jKRKBYZ"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*250 mL Glass Bottle, Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:J8AY5jwzPPex"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*250 mL Amber Glass Bottle *)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:4pO6dM5E5AaM"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*250 mL Amber Glass Bottle, Sterile *)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:aXRlGnZmOONB"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*500 mL Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:pZx9jo8A8lVp"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*500 mL Glass Bottle,Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:8qZ1VWNmddlD"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*500 mL Amber Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:Vrbp1jKoKz7E"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*500 mL Amber Glass Bottle, Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:zGj91aR3ddXJ"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*1L Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:XnlV5jKRKBqn"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*1L Glass Bottle, Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:3em6Zv9Njjbv"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*2L Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:O81aEBZpZODD"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*2L Glass Bottle, Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:Vrbp1jG800Zm"]->Model[Item, Cap, "id:D8KAEvGrzdLY"],(*"Amber Glass Bottle 4 L"*)(*Model[Item, Cap, "38-430 Bottle Cap"]*)
	Model[Container, Vessel, "id:7X104vnY15Z6"]->Model[Item, Cap, "id:D8KAEvGrzdLY"],(*"Amber Glass Bottle 4 L, Sterile"*)(*Model[Item, Cap, "38-430 Bottle Cap"]*)
	Model[Container, Vessel, "id:dORYzZJpO79e"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*5L Glass Bottle*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:4pO6dM5Epa87"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*5L Glass Bottle, Sterile*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:mnk9jOkn6oMZ"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*Corning Reusable Plastic Reagent Bottles with GL-45 PP Screw Cap*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:Vrbp1jG800lE"]->Model[Item, Cap, "id:jLq9jXvMkYPE"],(*5L Plastic Container*)(*Model[Item, Cap, "GL45 Bottle Cap"]*)
	Model[Container, Vessel, "id:aXRlGnZmOOB9"]->Model[Item, Cap, "id:P5ZnEj4P88aO"],(*"10L Polypropylene Carboy"*)(*Model[Item, Cap, "Nalgene carboy cap, 83 mm"]*)
	Model[Container, Vessel, "id:Vrbp1jKoKMmq"]->Model[Item, Cap, "id:P5ZnEj4P88aO"],(*"10L Polypropylene Carboy, Sterile"*)(*Model[Item, Cap, "Nalgene carboy cap, 83 mm"]*)
	Model[Container, Vessel, "id:3em6Zv9NjjkY"]->Model[Item, Cap, "id:P5ZnEj4P88aO"],(*"20L Polypropylene Carboy"*)(*Model[Item, Cap, "Nalgene carboy cap, 83 mm"]*)
	Model[Container, Vessel, "id:1ZA60vLXLRzw"]->Model[Item, Cap, "id:P5ZnEj4P88aO"],(*"20L Polypropylene Carboy, Sterile"*)(*Model[Item, Cap, "Nalgene carboy cap, 83 mm"]*)
	Model[Container, Vessel, "id:N80DNj0dwPBE"]->Model[Item, Cap, "id:01G6nvG9P0bm"],(*Membrane Aerated 50mL Tube*)(*Model[Item, Cap, "id:01G6nvG9P0bm"]*)
	Model[Container, Vessel, "id:N80DNjlYwwjo"]->Model[Item, Lid, "id:7X104v1N35pw"],(*125mL Erlenmeyer Flask*)(*Model[Item, Lid, "Aluminum Foil Cover"]*)
	Model[Container, Vessel, "id:jLq9jXY4kkXE"]->Model[Item, Lid, "id:7X104v1N35pw"],(*"250mL Erlenmeyer Flask"*)(*Model[Item, Lid, "Aluminum Foil Cover"]*)
	Model[Container, Vessel, "id:bq9LA0dBGG0b"]->Model[Item, Lid, "id:7X104v1N35pw"],(*500mL Erlenmeyer Flask*)(*Model[Item, Lid, "Aluminum Foil Cover"]*)
	Model[Container, Vessel, "id:8qZ1VWNmddWR"]->Model[Item, Lid, "id:7X104v1N35pw"],(*1000mL Erlenmeyer Flask*)(*Model[Item, Lid, "Aluminum Foil Cover"]*)
	Model[Container, Vessel, "id:AEqRl9KXBDoW"]->Model[Item, Cap, "id:WNa4ZjKL5MpR"],(*Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap*)(*Model[Item, Cap, "Tube Cap, 22x19mm"]*)
	Model[Container, Vessel, "id:GmzlKjPen8z4"]->Model[Item, Cap, "id:O81aEB1DnzWN"],(*8.9mL OptiSeal Centrifuge Tube*)(*Model[Item, Cap, "8.9mL OptiSeal Centrifuge Tube Cover"]*)
	Model[Container, Vessel, "id:KBL5DvwXoBx7"]->Null,(*32.4mL OptiSeal Centrifuge Tube*)
	Model[Container, Vessel, "id:KBL5DvwXoBMx"]->Null,(*"94mL UltraClear Centrifuge Tube"*)
	Model[Container, Vessel, "id:dORYzZJNGlVA"]->Null,(*125 mL Filter Flask*)
	Model[Container, Vessel, "id:eGakldJNAL4n"]->Null,(*500 mL Filter Flask*)
	Model[Container, Vessel, "id:pZx9jo8varzP"]->Null,(*1000 mL Filter Flask*)
	Model[Container, Vessel, "id:BYDOjv1VAAxz"]->Null,(*"5mL Tube"*)
	(* container does not require cover defined in storageCoverSubprotocolAssociation *)
	Model[Container, Plate, "id:P5ZnEjdmXJmE"]->Null,(* MicroQC Performance Testing Plate (Phosentix) *)
	Model[Container, Plate, "id:rea9jlaZGKnx"]->Null,(* Deck calibration plate for Hamilton *)
	Model[Container, Vessel, "id:9RdZXvKx1kAa"]->Null(* Built-in water reservoir in Cell Culture Incubator *)
|>;

(* ::Subsubsection::Closed:: *)
(*PreferredContainer Options and Messages*)


DefineOptions[
	PreferredContainer,
	Options:>{
		{Sterile->Automatic,ListableP[Alternatives[Automatic,BooleanP]],"Indicates if the container should be sterile."},
		{LightSensitive->Automatic,ListableP[Alternatives[Automatic,BooleanP]],"Indicates if the container should be suitable to contain light sensitive contents."},
		{Density->1(Gram/Milliliter),DensityP,"Specified density of the solid whose volume is being determined. This is ignored in the Volume overload."},
		{Messages->True,BooleanP,"Indicates if messages should be thrown."},
		{All->False,ListableP[BooleanP],"Indicates if all possible preferred containers should be returned, or just the container that is closest to the volume of the sample."},
		{Type->Vessel,ListableP[Alternatives[All,Plate,Vessel]],"Indicates if both plates and vessels, only plates, or only vessels should be returned."},
		{MaxTemperature->Automatic,ListableP[Automatic|TemperatureP],"Indicates the minimum MaxTemperature that the container must be able to reach."},
		{MinTemperature->Automatic,ListableP[Automatic|TemperatureP],"Indicates the maximum MinTemperature that the container must be able to reach."},
		{LiquidHandlerCompatible->Automatic,ListableP[Alternatives[Automatic,BooleanP]],"Indicates whether the containers returned must be compatible with the labs liquid handler robots."},
		{AcousticLiquidHandlerCompatible->Automatic,ListableP[Alternatives[Automatic,BooleanP]],"Indicates whether the containers returned must be compatible with the labs acoustic liquid handler instruments."},
		{VacuumFlask -> False, ListableP[BooleanP], "Indicates whether the containers returned should be vacuum flasks compatible with Buchner funnel vacuum filtration."},
		{UltracentrifugeCompatible->Automatic,ListableP[Alternatives[Automatic,BooleanP]],"Indicates whether the containers returned must be compatible with the ultracentrifuge instruments."},
		{CellType->Automatic,ListableP[Alternatives[CellTypeP,Null,Automatic]],"Indicates if the container should be compatible with tissue or bacterial cell cultures."},
		{CultureAdhesion->Automatic,ListableP[CultureAdhesionP | Null | Automatic],"Indicates if the container should be treated for adherent cells or untreated for suspension cells."},
		{IncompatibleMaterials -> Automatic, ListableP[(Automatic|{(None | MaterialP)...})], "Indicate if container of certain materials needs to be avoided."},
		CacheOption,
		SimulationOption
	}
];

PreferredContainer::ContainerTypeNotFound="For the given combination of options, there is no compatible container with type `1`. Please consider removing some specific options, or requesting the following container type: `2`.";
PreferredContainer::ContainerNotFound="For the given combination of options, the current range of volumes for which compatible containers exist is `2` to `3`; the requested volume `1` falls outside this range. Please consider removing some specific options, or requesting a volume in the possible range for the current options.";
PreferredContainer::NoContainerOfSpecifiedMaterials = "PreferredContainer failed to find a container that's not made of the following materials: `1` to hold `2` sample. ";


(* ::Subsubsection::Closed:: *)
(*PreferredContainer*)

(* ::Subsubsubsection::Closed:: *)
(*Empty List*)


PreferredContainer[{},myOptions:OptionsPattern[]]:={};
PreferredContainer[{},volume:{}|ListableP[(GreaterP[0 Milliliter]|All)],myOptions:OptionsPattern[]]:={};


(* ::Subsubsubsection::Closed:: *)
(*Model/Object*)

PreferredContainer[models:{ObjectP[{Model[Sample], Object[Sample]}]..},volume:(GreaterP[0 Milliliter]|All),myOptions:OptionsPattern[]]:=PreferredContainer[models,ConstantArray[volume,Length[models]],myOptions];

(* Listable version *)
PreferredContainer[models:{ObjectP[{Model[Sample], Object[Sample]}]..},volumes:{(GreaterP[0 Milliliter]|All)..},myOptions:OptionsPattern[]]:=Module[
	{listedOps,safeOps,cache,newCache,downloadFields,packets,resolvedLightSensitive,resolvedSterile,resolvedAllOption,resolvedTypeOption,
		resolvedMaxTemperatureOption,resolvedMinTemperatureOption, resolvedVacuumFlask, resolvedIncompatibleMaterials, simulation, resolvedCellType},

	listedOps = ToList[myOptions];
	safeOps = SafeOptions[PreferredContainer,listedOps];

	(* If the lengths of models and volumes are not equivalent, return $Failed *)
	If[!SameLengthQ[models,volumes],
		Message[Error::InputLengthMismatch,volumes,Length[volumes],models,Length[models]];
		Return[$Failed]
	];

	(* Expand options into a mapthreadable version *)
	{resolvedLightSensitive,resolvedSterile,resolvedAllOption,resolvedTypeOption,resolvedMaxTemperatureOption, resolvedMinTemperatureOption, resolvedVacuumFlask, resolvedIncompatibleMaterials, resolvedCellType} = Module[
		{optionDefaults,unresolvedLightSensitive,unresolvedSterile,unresolvedAllOption,unresolvedTypeOption,
			unresolvedMaxTemperatureOption,unresolvedMinTemperatureOption, unresolvedVacuumFlask, unresolvedIncompatibleMaterials, indexMatchingIncompatibleMaterials, unresolvedCellType},

		(* Save all the option defaults *)
		optionDefaults = SafeOptions[PreferredContainer];

		(* As we do this, we need to make sure ValidInputLengthsQ didn't return $Failed. If it did, just default the options *)
		{unresolvedLightSensitive,unresolvedSterile,unresolvedAllOption,unresolvedTypeOption,unresolvedMaxTemperatureOption,unresolvedMinTemperatureOption, unresolvedVacuumFlask, unresolvedCellType} = MapThread[
			If[Not[Length[ToList[#2]]==1]&&!SameLengthQ[models,#2],
				Lookup[optionDefaults,#1],
				#2
			]&,
			{
				{LightSensitive,Sterile,All,Type,MaxTemperature,MinTemperature, VacuumFlask, CellType},
				Lookup[safeOps,{LightSensitive,Sterile,All,Type,MaxTemperature,MinTemperature, VacuumFlask, CellType}]
			}
		];

		(* Make a special case for IncompatibleMaterials because this option can be List or List of List, can cause bug if interpreted incorrectly *)
		(* Also, samples should have their IncompatibleMaterials populated to pass VOQ, but there always are samples with IncompatibleMaterials == {}. In that case make it {None} *)
		unresolvedIncompatibleMaterials = Lookup[safeOps, IncompatibleMaterials];
		indexMatchingIncompatibleMaterials = Which[
			(* If option value is a single List or a single Automatic, duplicate that *)
			MatchQ[unresolvedIncompatibleMaterials, (Automatic|{(None | MaterialP)..})],
				Replace[ConstantArray[unresolvedIncompatibleMaterials, Length[models]], {} -> {None}, 1],
			(* If option value is the same length as models, use it *)
			SameLengthQ[unresolvedIncompatibleMaterials, models],
				Replace[unresolvedIncompatibleMaterials, {} -> {None}, 1],
			(* Finally, if the option value length mismatch, use default *)
			True,
				Lookup[optionDefaults, IncompatibleMaterials]
		];

		(* Expand any unlisted option to make them MapThread-able and return all, now-expanded, options *)
		MapThread[
			Function[
				{optionName,optionVal},
				Which[
					Length[ToList[optionVal]]==1,
						ConstantArray[optionVal,Length[models]],
					SameLengthQ[optionVal,models],
						optionVal
				]
			],
			{
				{LightSensitive,Sterile,All,Type,MaxTemperature,MinTemperature, VacuumFlask, IncompatibleMaterials, CellType},
				{unresolvedLightSensitive,unresolvedSterile,unresolvedAllOption,unresolvedTypeOption,unresolvedMaxTemperatureOption,unresolvedMinTemperatureOption, unresolvedVacuumFlask, indexMatchingIncompatibleMaterials, unresolvedCellType}
			}
		]
	];

	(* Store any cache we were passed *)
	cache = Lookup[safeOps,Cache];
	simulation = Lookup[safeOps, Simulation];

	(* If the sample we're handling is a StockSolution *)
	downloadFields = If[MatchQ[#,ObjectP[Model[Sample,StockSolution]]],

		(* Indicate we should download PreferredContainers in addition to the Model[Sample] fields *)
		{
			Packet[State,LightSensitive,Sterile,PreferredContainers, IncompatibleMaterials],
			Packet[PreferredContainers[{Object,Deprecated,Sterile,Opaque,MaxVolume,MinVolume, ContainerMaterials}]]
		},

		(* Otherwise, just get the Model[Sample] fields *)
		{
			Packet[State,LightSensitive,Sterile, IncompatibleMaterials],
			Packet[]
		}
	]&/@models;

	(* Pull the important information from the model *)
	packets = Flatten[Download[models,Evaluate[downloadFields],Cache->cache, Simulation -> simulation]];

	(* Join the new packets with the cache passed in *)
	newCache = Join[cache,packets];

	MapThread[
		Function[
			{model, volume, lightSentsitive, sterile, allOption, typeOption, maxTempOption, minTempOption, vacuumFlaskOption, incompatibleMaterials, cellType},
			PreferredContainer[
				model,
				volume,
				Cache -> newCache,
				LightSensitive -> lightSentsitive,
				Sterile -> sterile,
				All -> allOption,
				Type -> typeOption,
				MaxTemperature -> maxTempOption,
				MinTemperature -> minTempOption,
				VacuumFlask -> vacuumFlaskOption,
				IncompatibleMaterials -> incompatibleMaterials,
				CellType -> cellType
			]
		],
		{models, volumes, resolvedLightSensitive, resolvedSterile, resolvedAllOption, resolvedTypeOption, resolvedMaxTemperatureOption, resolvedMinTemperatureOption, resolvedVacuumFlask, resolvedIncompatibleMaterials, resolvedCellType}
	]
];

(* Single overload *)
PreferredContainer[model:ObjectP[{Model[Sample], Object[Sample]}],myVolume:(GreaterP[0 Milliliter]|All),myOptions:OptionsPattern[]]:=Module[
	{listedOps,safeOps,cache,downloadFields,modelPacket,containerPackets,resolvedLightSensitive,resolvedSterile,resolvedCellType,resolvedCultureAdhesion, resolvedIncompatibleMaterials, simulation},

	listedOps = ToList[myOptions];
	safeOps = SafeOptions[PreferredContainer,listedOps];

	(* Store any cache we were passed *)
	cache = Lookup[safeOps,Cache];
	simulation = Lookup[safeOps, Simulation];

	(* If the sample we're handling is a StockSolution *)
	downloadFields=If[MatchQ[model,ObjectP[Model[Sample,StockSolution]]],

		(* Indicate we should download PreferredContainers in addition to the Model[Sample] fields *)
		{
			Packet[State,LightSensitive,Sterile,PreferredContainers, IncompatibleMaterials],
			Packet[PreferredContainers[{Object,Deprecated,Sterile,Opaque,MaxVolume,MinVolume, Connectors, ContainerMaterials}]]
		},

		(* Otherwise, just get the Model[Sample] fields *)
		{
			Packet[State,LightSensitive,Sterile,CellType, IncompatibleMaterials],
			Packet[]
		}
	];

	(* Pull the important information from the model *)
	{modelPacket,containerPackets} = Quiet[Download[model,Evaluate[downloadFields],Cache->cache, Simulation -> simulation]];

	(* Determine if LightSensitive was provided and if not, determine how to resolve it *)
	resolvedLightSensitive = If[MatchQ[Lookup[safeOps,LightSensitive],Automatic],

		(* If LightSensitive -> Automatic, check if our model is LightSensitive *)
		TrueQ[Lookup[modelPacket,LightSensitive]],

		(* Otherwise use whatever was provided to use *)
		Lookup[safeOps,LightSensitive]
	];

	(* Determine if LightSensitive was provided and if not, determine how to resolve it *)
	resolvedSterile = If[MatchQ[Lookup[safeOps,Sterile],Automatic],

		(* If LightSensitive -> Automatic, check if our model is LightSensitive *)
		TrueQ[Lookup[modelPacket,Sterile]],

		(* Otherwise use whatever was provided to use *)
		Lookup[safeOps,Sterile]
	];

	(* Determine if CellType was provided and if not, determine how to resolve it *)
	resolvedCellType = If[MatchQ[Lookup[safeOps,CellType],Automatic],

		(* If CellType -> Automatic, check if our subtype of sample *)
		Lookup[modelPacket,CellType]/.$Failed->Null,

		(* Otherwise use whatever was provided to use *)
		Lookup[safeOps,CellType]/.$Failed->Null
	];

	(* Determine if CultureAdhesion was provided and if not, determine how to resolve it *)
	resolvedCultureAdhesion = If[MatchQ[Lookup[safeOps,CultureAdhesion],Automatic],

		(* If CellType -> Automatic, check if our subtype of sample *)
		Which[
			MatchQ[resolvedCellType,Mammalian],
			Adherent,
			True,
			Null
		],

		(* Otherwise use whatever was provided to use *)
		Lookup[safeOps,CultureAdhesion]
	];
	(* Determine if IncompatibleMaterials was provided; if not, determine how to resolve it *)
	resolvedIncompatibleMaterials = If[MatchQ[Lookup[safeOps, IncompatibleMaterials], Automatic],
		(* For automatic option, use the IncompatibleMaterials field from Model *)
		(* In case the IncompatibleMaterials == {} from model, correct it. This won't pass VOQ but it just happens sometimes *)
		Replace[Lookup[modelPacket, IncompatibleMaterials, {None}], {} -> {None}],
		(* If option is specified, COMBINE the option and IncompatibleMaterials from input Model. *)
		Module[{combinedIncompatibleMaterials},
			combinedIncompatibleMaterials = Union[
				Lookup[safeOps, IncompatibleMaterials],
				Lookup[modelPacket, IncompatibleMaterials, {None}],
				(* Always include a None into this list, in case the other two are both {} *)
				{None}
			];
			(* If only thing in combined materials is None, use that; otherwise remove the None from list *)
			If[MatchQ[combinedIncompatibleMaterials, {None}],
				{None},
				DeleteCases[combinedIncompatibleMaterials, None]
			]
		]
	];

	(* If the PreferredContainers were provided, check if we can use one of those containers *)
	If[MatchQ[containerPackets,{PacketP[Model[Container]]..}],

		(* Build a decision tree that will chose a preferred container if possible *)
		Module[{nonDeprecatedContainers,preferredContainersList,compatibleVolumeP,possibleContainersList,typeCompatibleContainers, materialFilteredPossibleContainerList},

			(* Remove any Deprecated models or any models whose MinVolume > myVolume from our list of possible containers *)
			nonDeprecatedContainers = DeleteCases[containerPackets,Alternatives[KeyValuePattern[Deprecated->True],KeyValuePattern[MinVolume->GreaterP[myVolume]]]];

			(* If they asked for plates or vessels only, remove any others from the list of possible containers *)
			typeCompatibleContainers = Switch[Lookup[safeOps,Type],
				All, nonDeprecatedContainers,
				Plate, Cases[nonDeprecatedContainers,ObjectP[Model[Container, Plate]]],
				Vessel, Cases[nonDeprecatedContainers,ObjectP[Model[Container, Vessel]]]
			];

			(* Generate a lookup table of the form: {Container, MaxVolume, Sterile, LightSensitive, ContainerMaterials} and sort it by MaxVolume *)
			preferredContainersList = SortBy[
				Lookup[typeCompatibleContainers,{Object,MaxVolume,Sterile,Opaque, ContainerMaterials}],
				#[[2]]&
			];

			(* Determine a pattern to eliminate any containers whose MaxVolume is insufficient to hold myVolume *)
			compatibleVolumeP = If[MatchQ[myVolume,VolumeP],

				(* Create a pattern to only accept volumes above the provided myVolume *)
				GreaterEqualP[myVolume],

				(* Else myVolume was All, so allow any volume *)
				VolumeP
			];

			(* Find all the lists that match our required container criteria *)
			(* If our container is Sterile or LightSensitive but it is not required, we should still be able to use it *)
			(* All our standard disposable tubes like 0.5/1.5/2/50 tubes are Sterile *)
			possibleContainersList = If[MatchQ[#,{_,compatibleVolumeP,(resolvedSterile|True),(resolvedLightSensitive|True), _}],
				#,
				Nothing
			]&/@preferredContainersList;

			(* Do another filter by ContainerMaterials and IncompatibleMaterials *)
			materialFilteredPossibleContainerList =If[MemberQ[resolvedIncompatibleMaterials, None],
				possibleContainersList,
				Map[
					If[MatchQ[Intersection[resolvedIncompatibleMaterials, #[[5]]], {}],
						#,
						Nothing
					]&,
					possibleContainersList
				]
			];

			(* If we found containers in PreferredContainers that would work *)
			If[!MatchQ[materialFilteredPossibleContainerList,{}],

				(* If myVolume -> All *)
				If[MatchQ[myVolume,All],

					(* Return all possible container models that would work by taking the first index of our lists *)
					Download[materialFilteredPossibleContainerList[[All,1]],Object],

					(* If it's a specific volume, pick the smallest of these valid types *)
					Download[First[First[materialFilteredPossibleContainerList]],Object]
				],

				(* Otherwise pass our resolved criteria down to PreferredContainer Volume overload *)
				PreferredContainer[myVolume, ReplaceRule[safeOps, {Sterile->resolvedSterile, LightSensitive->resolvedLightSensitive,CultureAdhesion->resolvedCultureAdhesion,CellType->resolvedCellType, IncompatibleMaterials -> resolvedIncompatibleMaterials}]]
			]
		],

		(* Otherewise take the resolved criteria from model and pass them to the volume overload *)
		PreferredContainer[myVolume, ReplaceRule[safeOps, {Sterile->resolvedSterile, LightSensitive->resolvedLightSensitive,CultureAdhesion->resolvedCultureAdhesion,CellType->resolvedCellType, IncompatibleMaterials -> resolvedIncompatibleMaterials}]]
	]
];

(* ::Subsubsubsection::Closed:: *)
(*Volume and Container List*)
PreferredContainer[myVolume:(GreaterP[0 Milliliter]|All),myContainer:{},myOptions:OptionsPattern[]]:=PreferredContainer[myVolume,myOptions];
PreferredContainer[myVolume:(GreaterP[0 Milliliter]|All),myContainer:ObjectP[Model[Container]],myOptions:OptionsPattern[]]:=PreferredContainer[myVolume,{myContainer},myOptions];
PreferredContainer[myVolume:(GreaterP[0 Milliliter]|All),myContainers:{ObjectP[Model[Container]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOps, safeOps, cache, vacuumFlask, containerPackets, sterile, lightSensitive, resolvedLightSensitive, resolvedSterile,
		cultureAdhesion,cellType,resolvedCultureAdhesion,resolvedCellType, resolvedIncompatibleMaterials, incompatibleMaterials},

	listedOps = ToList[myOptions];
	safeOps = SafeOptions[PreferredContainer,listedOps];

	(* Store any cache we were passed *)
	cache = Lookup[safeOps,Cache];

	(* Pull the important information from the model *)
	containerPackets = Download[myContainers,
		Packet[Deprecated,Sterile,Opaque,MaxVolume,MaxTemperature,MinTemperature, Connectors, ContainerMaterials],
		Cache->cache
	];

	(* Define sterility/light-sensitivity toggling booleans *)
	{sterile, lightSensitive, vacuumFlask, cultureAdhesion, cellType, incompatibleMaterials} = Lookup[safeOps, {Sterile, LightSensitive, VacuumFlask, CultureAdhesion,CellType, IncompatibleMaterials}];

	(* Resolve any Automatics to False *)
	{resolvedSterile,resolvedLightSensitive}=ReplaceAll[{sterile,lightSensitive}, Automatic -> False];

	(* Resolve any Automatics to Null *)
	{resolvedCultureAdhesion,resolvedCellType}=ReplaceAll[{cultureAdhesion,cellType}, Automatic -> Null];

	(* resolve IncompatibleMaterials. The option value allows list of Automatic or List of List of materials; however here it really should just be Automatic or single list *)
	resolvedIncompatibleMaterials = Switch[incompatibleMaterials,
		Automatic,
			{None},
		{(None | MaterialP)..},
			incompatibleMaterials,
		(* If the option pattern is incorrect, use the default value *)
		_,
			{None}
	];

	(* Build a decision tree that will chose a preferred container if possible *)
	Module[{nonDeprecatedContainers,preferredContainersList,compatibleVolumeP,possibleContainersList,typeCompatibleContainers,
		vacuumFlaskCompatibleContainers, materialFilteredPossibleContainerList},

		(* Remove any Deprecated models from our list of possible containers *)
		nonDeprecatedContainers = DeleteCases[containerPackets,AssociationMatchP[Association[Deprecated->True],AllowForeignKeys->True]];

		(* If they asked for plates or vessels only, remove any others from the list of possible containers *)
		typeCompatibleContainers = Switch[Lookup[safeOps,Type],
			All, nonDeprecatedContainers,
			Plate, Cases[nonDeprecatedContainers,ObjectP[Model[Container, Plate]]],
			Vessel, Cases[nonDeprecatedContainers,ObjectP[Model[Container, Vessel]]]
		];

		(* get the containers that are vacuum flasks (i.e., one entry to Connectors with "Vacuum Port" as the name, it being a Barbed fitting, and it having no threading the first three entries *)
		vacuumFlaskCompatibleContainers = If[TrueQ[vacuumFlask],
			Select[typeCompatibleContainers, MatchQ[Lookup[#, Connectors], {{"Vacuum Port", Barbed, None, ___}}]&],
			typeCompatibleContainers
		];

		(* Generate a lookup table of the form: {Container, MaxVolume, Sterile, LightSensitive, IncompatibleMaterials} and sort it by MaxVolume *)
		preferredContainersList = SortBy[
			Lookup[vacuumFlaskCompatibleContainers,{Object,MaxVolume,Sterile,Opaque, ContainerMaterials}],
			#[[2]]&
		];

		(* Determine a pattern to eliminate any containers whose MaxVolume is insufficient to hold myVolume *)
		compatibleVolumeP = If[MatchQ[myVolume,VolumeP],

			(* Create a pattern to only accept volumes above the provided myVolume *)
			GreaterEqualP[myVolume],

			(* Else myVolume was All, so allow any volume *)
			VolumeP
		];

		(* Find all the lists that match our required container criteria *)
		possibleContainersList = If[MatchQ[#,{_,compatibleVolumeP,resolvedSterile,resolvedLightSensitive, _}],
			#,
			Nothing
		]&/@preferredContainersList;

		(* Do another filter by ContainerMaterials and IncompatibleMaterials *)
		materialFilteredPossibleContainerList =If[MemberQ[resolvedIncompatibleMaterials, None],
			possibleContainersList,
			Map[
				If[MatchQ[Intersection[resolvedIncompatibleMaterials, #[[5]]], {}],
					#,
					Nothing
				]&,
				possibleContainersList
			]
		];

		(* If we found containers in PreferredContainers that would work *)
		If[!MatchQ[materialFilteredPossibleContainerList,{}],

			(* If myVolume -> All *)
			If[MatchQ[myVolume,All],

				(* Return all possible container models that would work by taking the first index of our lists *)
				Download[materialFilteredPossibleContainerList[[All,1]],Object],

				(* If it's a specific volume, pick the smallest of these valid types *)
				Download[First[First[materialFilteredPossibleContainerList]],Object]
			],

			(* Otherwise pass our resolved criteria down to PreferredContainer Volume overload *)
			PreferredContainer[myVolume, ReplaceRule[safeOps, {Sterile->resolvedSterile, LightSensitive->resolvedLightSensitive,CultureAdhesion->resolvedCultureAdhesion,CellType->resolvedCellType, IncompatibleMaterials -> resolvedIncompatibleMaterials}]]
		]
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Volume*)


PreferredContainer[myVolume:(GreaterEqualP[0 Milliliter]|All),myOptions:OptionsPattern[]]:=Module[
	{
		safeOptions,sterile,lightSensitive,resolvedSterile,resolvedLightSensitive,standardContainerLookup,sterileContainerLookup,
		lightSensitiveContainerLookup,lightSensitiveSterileContainerLookup,lookupToUse,typeCompatibleLookup,
		sortedContainerLookup,possibleContainers,minPossibleVolume,maxPossibleVolume,maxTemperatureCompatibleLookup,minTemperatureCompatibleLookup,
		liquidHandler,acousticLiquidHandler,ultracentrifuge,resolvedLiquidHandler,resolvedAcousticLiquidHandler,resolvedUltracentrifuge,liquidHandlerContainerLookup,
		acousticLiquidHandlerContainerLookup, containerTypesFromLookup,cultureAdhesion, cellType,resolvedCultureAdhesion,resolvedCellType,
		adherentNonMicrobialCellContainerLookup,adherentRoboticNonMicrobialCellContainerLookup,suspensionNonMicrobialCellContainerLookup,suspensionRoboticNonMicrobialCellContainerLookup,
		microbiologySolidMediaCellContainerLookup,microbiologyNonSolidMediaCellContainerLookup,microbiologyRoboticNonSolidMediaCellContainerLookup,vacuumFlask, vacuumFlaskContainerLookup,
		ultracentrifugeContainerLookup, liquidHandlerSterileContainerLookup, materialCompatibleLookup, lightSensitiveLiquidHandlerContainerLookup, lightSensitiveSterileLiquidHandlerContainerLookup
	},

	(* Validate input options *)
	safeOptions=SafeOptions[PreferredContainer, ToList[myOptions]];

	(* Define sterility/light-sensitivity toggling booleans *)
	{
		sterile,
		lightSensitive,
		liquidHandler,
		acousticLiquidHandler,
		vacuumFlask,
		ultracentrifuge,
		cultureAdhesion,
		cellType
	}= Lookup[safeOptions,{
		 Sterile,
		 LightSensitive,
		 LiquidHandlerCompatible,
		 AcousticLiquidHandlerCompatible,
		 VacuumFlask,
		 UltracentrifugeCompatible,
		 CultureAdhesion,
		 CellType
	 }];

	(* Resolve any Automatics to False *)
	{resolvedSterile,resolvedLightSensitive,resolvedLiquidHandler,resolvedAcousticLiquidHandler,resolvedUltracentrifuge}=ReplaceAll[{sterile,lightSensitive,liquidHandler,acousticLiquidHandler,ultracentrifuge}, Automatic -> False];

	(* Resolve any cell culture specs *)
	resolvedCellType=If[
		MatchQ[cellType,Automatic],
		If[MatchQ[cultureAdhesion,Adherent|Suspension],
			Mammalian,
			Null
		],
		cellType
	];

	resolvedCultureAdhesion=If[
		MatchQ[cultureAdhesion,Automatic],
		If[MatchQ[cellType,Mammalian],
			Adherent,
			Null
		],
		cultureAdhesion
	];


	(* define lookup tables that contain all information for selecting an appropriate container: {containerModel,volumeMin,volumeMax} *)
	(* Note: if updating PreferredContainer, remember to update cover lookup table $PreferredContainerCoverLookup as well *)
	standardContainerLookup={
		(* note that a 2mL tube can't actually hold 2mL so the limit is actually 1.9 mL *)
		{Model[Container, Vessel,"id:o1k9jAG00e3N"],0 Milliliter,0.5Milliliter,121 Celsius,-196 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:eGakld01zzpq"],0 Milliliter,1.5Milliliter, 121 Celsius,-196 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:3em6Zv9NjjN8"],0 Milliliter,1.9 Milliliter, 121 Celsius,-196 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:bq9LA0dBGGR6"],1.9 Milliliter,50 Milliliter, 80 Celsius, -196 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:jLq9jXvA8ewR"],0 Milliliter,100 Milliliter, 500 Celsius, -192 Celsius, {Glass}},
		{Model[Container,Vessel,"id:01G6nvwPempK"],100 Milliliter,150 Milliliter, 500 Celsius,-192 Celsius, {Glass}},
		{Model[Container,Vessel,"id:J8AY5jwzPPR7"],150 Milliliter,250 Milliliter, 500 Celsius,-192 Celsius, {Glass}},
		{Model[Container,Vessel,"id:aXRlGnZmOONB"],250 Milliliter,500 Milliliter, 140 Celsius,-80 Celsius, {Glass}},
		{Model[Container,Vessel,"id:zGj91aR3ddXJ"],500 Milliliter,1 Liter, 140 Celsius, 0 Celsius, {Glass}},
		{Model[Container,Vessel,"id:3em6Zv9Njjbv"],1 Liter,2 Liter, 140 Celsius, -80 Celsius, {Glass}},
		{Model[Container,Vessel,"id:Vrbp1jG800Zm"],2 Liter,4 Liter, 120 Celsius, 0 Celsius, {Glass}},
		{Model[Container,Vessel,"id:dORYzZJpO79e"],4 Liter,5 Liter, 140 Celsius, 0 Celsius, {Glass}},
		{Model[Container, Vessel, "id:mnk9jOkn6oMZ"], 50 Milliliter, 2 Liter, 80 Celsius, -50 Celsius, {Polypropylene}},
		{Model[Container, Vessel, "id:Vrbp1jG800lE"], 2 Liter, 5 Liter, 120 Celsius, -80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:aXRlGnZmOOB9"],5 Liter,10 Liter, 130 Celsius, 0 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:3em6Zv9NjjkY"],10 Liter,20 Liter, 130 Celsius, 0 Celsius, {Polypropylene}},
		{Model[Container,Plate,"id:L8kPEjkmLbvW"],0 Milliliter,2. Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}},
		{Model[Container,Plate,"id:E8zoYveRllM7"],2. Milliliter,3.5 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}},
		{Model[Container,Plate,"id:lYq9jRqw70m4"], 5 Microliter,10 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Non-Sterile *)
		{Model[Container, Plate, "id:AEqRl9qmr111"], 540 Microliter, 75 Milliliter, 121 Celsius, -195 Celsius, {Polypropylene}} (* 4-well V-bottom 75mL Deep Well Plate Non-Sterile*)
	};
	liquidHandlerContainerLookup={
		{Model[Container, Vessel, "id:o1k9jAG00e3N"],0 Milliliter,0.5 Milliliter,121 Celsius,-196 Celsius, {Polypropylene}}, (* "New 0.5mL Tube with 2mL Tube Skirt" *)
		(* note that a 2mL tube can't actually hold 2mL so the limit is actually 1.9 mL *)
		{Model[Container,Vessel,"id:3em6Zv9NjjN8"],0.5 Milliliter,1.9 Milliliter, 121 Celsius,-196 Celsius, {Polypropylene}}, (* "2mL Tube" *)
		{Model[Container,Vessel,"id:bq9LA0dBGGR6"],1.9 Milliliter,50 Milliliter, 80 Celsius, -196 Celsius, {Polypropylene}}, (* "50mL Tube" *)
		{Model[Container,Plate,"id:L8kPEjkmLbvW"],0 Milliliter, 2 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* "96-well 2mL Deep Well Plate" *)
		{Model[Container,Plate,"id:E8zoYveRllM7"],2 Milliliter,3.5 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* "48-well Pyramid Bottom Deep Well Plate" *)
		{Model[Container,Plate,"id:lYq9jRqw70m4"], 5 Microliter,10 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Non-Sterile *)
		{Model[Container, Plate, "id:AEqRl9qmr111"], 540 Microliter, 75 Milliliter, 121 Celsius, -195 Celsius, {Polypropylene}}, (* 4-well V-bottom 75mL Deep Well Plate Non-Sterile*)
		{Model[Container,Plate,"id:54n6evLWKqbG"],50 Milliliter,200 Milliliter, 121 Celsius,-196 Celsius, {Polypropylene}}, (* 200mL Polypropylene Robotic Reservoir, non-sterile *)
		{Model[Container, Plate, "id:L8kPEjno5XoE"], 50 Microliter, 300 Microliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Black Wall Tissue Culture Plate"]*)
		{Model[Container,Vessel,"id:jLq9jXvxr6OZ"], 0 Milliliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "HPLC vial (high recovery)" *)
		{Model[Container, Vessel, "id:qdkmxzqEvPjV"], 1.2 Milliliter, 2.0 Milliliter, 121 Celsius, -80 Celsius, {Glass}} (* "2mL small clear glass HPLC vial" *)
	};
	liquidHandlerSterileContainerLookup={
		{Model[Container, Vessel, "id:o1k9jAG00e3N"], 0 Milliliter, 0.5 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* "New 0.5mL Tube with 2mL Tube Skirt" *)
		(* note that a 2mL tube can't actually hold 2mL so the limit is actually 1.9 mL *)
		{Model[Container, Vessel, "id:3em6Zv9NjjN8"], 0.5 Milliliter, 1.9 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* "2mL Tube" *)
		{Model[Container, Vessel, "id:bq9LA0dBGGR6"], 1.9 Milliliter, 50 Milliliter, 80 Celsius, -196 Celsius, {Polypropylene}}, (* "50mL Tube" *)
		{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], 0 Milliliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "HPLC vial (high recovery)" *)
		{Model[Container, Vessel, "id:qdkmxzqEvPjV"], 1.2 Milliliter, 2.0 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "2mL small clear glass HPLC vial" *)
		{Model[Container, Plate, "id:4pO6dMOqKBaX"], 0 Milliliter, 0.2 Milliliter, 100 Celsius, -80 Celsius, {Polypropylene}}, (* 96-well flat bottom plate, Sterile, Nuclease-Free *)
		{Model[Container, Plate, "id:n0k9mGkwbvG4"], 0 Milliliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* 96-well 2mL Deep Well Plate, Sterile *)
		{Model[Container, Plate, "id:qdkmxzkKwn11"], 5 Microliter, 10 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:R8e1PjeVbJ4X"], 540 Microliter, 75 Milliliter, 121 Celsius, -195 Celsius, {Polypropylene}}, (* 4-well V-bottom 75mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:AEqRl9qm8rwv"], 50 Milliliter, 200 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (*200mL Polypropylene Robotic Reservoir, sterile*)
		{Model[Container, Plate, "id:eGakld01zzLx"], 0.2 Milliliter, 4 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "6-well Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:jLq9jXY4kkMq"], 2 Milliliter, 10 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}},(*Model[Container, Plate, "24-well Round Bottom Deep Well Plate, Sterile"]*)
		{Model[Container, Plate, "id:P5ZnEjx9Zllk"], 2 Milliliter, 3.5 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "48-well Pyramid Bottom Deep Well Plate, Sterile" *)
		{Model[Container, Plate, "id:jLq9jXY4kkKW"], 20 Microliter, 300 Microliter, 60 Celsius, -20 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:1ZA60vAn9RVP"], 20 Microliter, 300 Microliter, 60 Celsius, -20 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Greiner Tissue Culture Plate, Untreated"]*)
		{Model[Container, Plate, "id:L8kPEjno5XoE"], 50 Microliter, 300 Microliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Black Wall Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:pZx9joxDA8Bj"], 10 Microliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* Model[Container, Plate, "Greiner MasterBlock 1.2ml Deep Well Plate, Sterile"] *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}} (* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"] *)
	};
	acousticLiquidHandlerContainerLookup={
		{Model[Container,Plate,"id:01G6nvwNDARA"],2.5 Microliter,12 Microliter,121 Celsius,-80 Celsius, {Cycloolefine}},
		{Model[Container,Plate,"id:7X104vn56dLX"],15 Microliter,65 Microliter,121 Celsius,-80 Celsius, {Polypropylene}}
	};
	ultracentrifugeContainerLookup={
		{Model[Container,Vessel,"id:GmzlKjPen8z4"],0 Milliliter,8.9 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* "8.9mL OptiSeal Centrifuge Tube" *)
		{Model[Container,Vessel,"id:KBL5DvwXoBx7"],0 Milliliter,32.4 Milliliter,121 Celsius,-80 Celsius, {Polypropylene}}, (* "32.4mL OptiSeal Centrifuge Tube" *)
		{Model[Container,Vessel,"id:KBL5DvwXoBMx"],0 Milliliter,94 Milliliter,80 Celsius,-50 Celsius, {Polypropylene}} (* "94mL UltraClear Centrifuge Tube" *)
	};
	sterileContainerLookup={
		{Model[Container, Vessel, "id:o1k9jAG00e3N"], 0 Milliliter, 0.5Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}},(*Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]*)
		(* note that a 2mL tube can't actually hold 2mL so the limit is actually 1.9 mL *)
		{Model[Container, Vessel, "id:3em6Zv9NjjN8"], 0 Milliliter, 1.9 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}},(*Model[Container, Vessel, "2mL Tube"]*)
		{Model[Container, Vessel, "id:bq9LA0dBGGR6"], 1.9 Milliliter, 50 Milliliter, 80 Celsius, -196 Celsius, {Polypropylene}},(*Model[Container, Vessel, "50mL Tube"]*)
		{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], 0 Milliliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "HPLC vial (high recovery)" *)
		{Model[Container, Vessel, "id:qdkmxzqEvPjV"], 1.2 Milliliter, 2.0 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "2mL small clear glass HPLC vial" *)
		{Model[Container, Vessel, "id:XnlV5jKRKBYZ"], 50 Milliliter, 250 Milliliter, 140 Celsius, -20 Celsius, {Glass}},(*Model[Container, Vessel, "250mL Glass Bottle, Sterile"]*)
		{Model[Container, Vessel, "id:pZx9jo8A8lVp"], 250 Milliliter, 500 Milliliter, 140 Celsius, -80 Celsius, {Glass}},(*Model[Container, Vessel, "500mL Glass Bottle, Sterile"]*)
		{Model[Container, Vessel, "id:XnlV5jKRKBqn"], 500 Milliliter, 1 Liter, 140 Celsius, -80 Celsius, {Glass}},(*Model[Container, Vessel, "1L Glass Bottle, Sterile"]*)
		{Model[Container, Vessel, "id:O81aEBZpZODD"], 1 Liter, 2 Liter, 140 Celsius,-80 Celsius, {Glass}},(*Model[Container, Vessel, "2L Glass Bottle, Sterile"]*)
		{Model[Container, Vessel, "id:7X104vnY15Z6"], 2 Liter, 4 Liter, 121 Celsius,0 Celsius, {Glass}},(*Model[Container, Vessel, "Amber Glass Bottle 4 L, Sterile"]*)
		{Model[Container, Vessel, "id:4pO6dM5Epa87"], 4 Liter, 5 Liter, 140 Celsius,0 Celsius, {Glass}},(*Model[Container, Vessel, "5L Glass Bottle, Sterile"]*)
		{Model[Container, Vessel, "id:Vrbp1jKoKMmq"], 5 Liter, 10 Liter, 130 Celsius, 0 Celsius, {Polypropylene}},(*Model[Container, Vessel, "10L Polypropylene Carboy, Sterile"]*)
		{Model[Container, Vessel, "id:1ZA60vLXLRzw"], 10 Liter, 20 Liter, 130 Celsius, 0 Celsius, {Polypropylene}},(*Model[Container, Vessel, "20L Polypropylene Carboy, Sterile"]*)
		{Model[Container, Vessel, "id:AEqRl9KXBDoW"], 140 Milliliter, 14 Milliliter, 80 Celsius, -4 Celsius, {Polypropylene}},(*"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"*)

		{Model[Container, Plate, "id:4pO6dMOqKBaX"], 0 Milliliter, 0.2 Milliliter, 100 Celsius, -80 Celsius, {Polypropylene}}, (* 96-well flat bottom plate, Sterile, Nuclease-Free *)
		{Model[Container, Plate, "id:n0k9mGkwbvG4"], 0 Milliliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* 96-well 2mL Deep Well Plate, Sterile *)
		{Model[Container, Plate, "id:qdkmxzkKwn11"], 5 Microliter, 10 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:R8e1PjeVbJ4X"], 540 Microliter, 75 Milliliter, 121 Celsius, -195 Celsius, {Polypropylene}}, (* 4-well V-bottom 75mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:AEqRl9qm8rwv"], 50 Milliliter, 200 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (*200mL Polypropylene Robotic Reservoir, sterile*)
		{Model[Container, Plate, "id:eGakld01zzLx"], 0.2 Milliliter, 4 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "6-well Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:GmzlKjY5EE8e"], 0.1 Milliliter, 2 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "12-well Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:E8zoYveRlldX"], 50 Microliter, 1 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "24-well Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:jLq9jXY4kkMq"], 2 Milliliter, 10 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}},(*Model[Container, Plate, "24-well Round Bottom Deep Well Plate, Sterile"]*)
		{Model[Container, Plate, "id:P5ZnEjx9Zllk"], 2 Milliliter, 3.5 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "48-well Pyramid Bottom Deep Well Plate, Sterile" *)
		{Model[Container, Plate, "id:jLq9jXY4kkKW"], 20 Microliter, 300 Microliter, 60 Celsius, -20 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:1ZA60vAn9RVP"], 20 Microliter, 300 Microliter, 60 Celsius, -20 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Greiner Tissue Culture Plate, Untreated"]*)
		{Model[Container, Plate, "id:L8kPEjno5XoE"], 50 Microliter, 300 Microliter, 100 Celsius, -80 Celsius, {Polystyrene}},(*Model[Container, Plate, "96-well Black Wall Tissue Culture Plate"]*)
		{Model[Container, Plate, "id:pZx9joxDA8Bj"], 10 Microliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* Model[Container, Plate, "Greiner MasterBlock 1.2ml Deep Well Plate, Sterile"] *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}} (* Model[Container, Plate, "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom"] *)
	};
	lightSensitiveContainerLookup={
		(* note that a 2mL tube can't actually hold 2mL; the limit already set is 1.75 mL *)
		{Model[Container,Vessel,"id:M8n3rx03Ykp9"],0 Milliliter,1.75 Milliliter, 121 Celsius,-80 Celsius, {Polypropylene}},
		{Model[Container, Plate, "id:6V0npvK611zG"], 0.05 Milliliter, 0.3 Milliliter, 100 Celsius,-80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:bq9LA0dBGGrd"],1.75 Milliliter,50 Milliliter, 80 Celsius,-80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:GmzlKjznOxmE"], 0 Milliliter, 1.2 Milliliter, 121 Celsius, -80 Celsius, {Glass}}, (* "Amber HPLC vial (high recovery)" *)
		{Model[Container,Vessel,"id:J8AY5jwzPPex"],1.2 Milliliter,250 Milliliter, 121 Celsius,-40 Celsius, {Glass}},
		{Model[Container,Vessel,"id:8qZ1VWNmddlD"],250 Milliliter,500 Milliliter, 121 Celsius,-80 Celsius, {Glass}},
		{Model[Container,Vessel,"id:Vrbp1jG800Zm"],500 Milliliter,4 Liter, 120 Celsius, 0 Celsius, {Glass}}
	};
	lightSensitiveLiquidHandlerContainerLookup = {
		{Model[Container,Vessel,"id:M8n3rx03Ykp9"],0 Milliliter,1.75 Milliliter, 121 Celsius,-80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:bq9LA0dBGGrd"],1.75 Milliliter,50 Milliliter, 80 Celsius,-80 Celsius, {Polypropylene}}
	};
	lightSensitiveSterileLiquidHandlerContainerLookup = {
		{Model[Container,Vessel,"id:M8n3rx03Ykp9"],0 Milliliter,1.75 Milliliter, 121 Celsius,-80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:bq9LA0dBGGrd"],1.75 Milliliter,50 Milliliter, 80 Celsius,-80 Celsius, {Polypropylene}}
	};
	lightSensitiveSterileContainerLookup={
		{Model[Container,Vessel,"id:bq9LA0dBGGrd"],2 Milliliter,50 Milliliter, 80 Celsius, -80 Celsius, {Polypropylene}},
		{Model[Container,Vessel,"id:4pO6dM5E5AaM"],50 Milliliter,250 Milliliter, 121 Celsius, -40 Celsius, {Glass}},
		{Model[Container,Vessel,"id:Vrbp1jKoKz7E"],250 Milliliter,500 Milliliter, 121 Celsius, -80 Celsius, {Glass}},
		{Model[Container,Vessel,"id:7X104vnY15Z6"],500 Milliliter,4 Liter, 121 Celsius, 0 Celsius, {Glass}}
	};
	adherentNonMicrobialCellContainerLookup={
		{Model[Container, Plate, "id:jLq9jXY4kkKW"], 0 Milliliter,0.2 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "96-well Greiner Tissue Culture Plate" *)
		{Model[Container, Plate, "id:Vrbp1jKw7W9q"], 0.2 Milliliter,0.4 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Corning, TC-Surface 48-well Plate" *)
		{Model[Container, Plate, "id:E8zoYveRlldX"], 0.4 Milliliter,1 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "24-well Tissue Culture Plate" *)
		{Model[Container, Plate, "id:GmzlKjY5EE8e"], 1 Milliliter,2 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "12-well Tissue Culture Plate" *)
		{Model[Container, Plate, "id:eGakld01zzLx"], 2 Milliliter,3 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "6-well Tissue Culture Plate" *)
		{Model[Container, Vessel, "id:01G6nvwz9ekA"], 3 Milliliter,5 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "T25 EasYFlask, TC Surface, Filter Cap" *)
		{Model[Container, Vessel, "id:8qZ1VW0np53Z"], 5 Milliliter,15 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "T75 EasYFlask, TC Surface, Filter Cap" *)
		{Model[Container, Vessel, "id:qdkmxzqXdJra"], 15 Milliliter,53 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}} (* "T175 EasYFlask, TC Surface, Filter Cap" *)
	};
	adherentRoboticNonMicrobialCellContainerLookup={
		{Model[Container, Plate, "id:jLq9jXY4kkKW"], 0 Milliliter,0.2 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "96-well Greiner Tissue Culture Plate" *)
		{Model[Container, Plate, "id:Vrbp1jKw7W9q"], 0.2 Milliliter,0.4 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Corning, TC-Surface 48-well Plate" *)
		{Model[Container, Plate, "id:E8zoYveRlldX"], 0.4 Milliliter,1 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "24-well Tissue Culture Plate" *)
		{Model[Container, Plate, "id:GmzlKjY5EE8e"], 1 Milliliter,2 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "12-well Tissue Culture Plate" *)
		{Model[Container, Plate, "id:eGakld01zzLx"], 2 Milliliter,3 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}} (* "6-well Tissue Culture Plate" *)
	};
	suspensionNonMicrobialCellContainerLookup={
		{Model[Container, Plate, "id:Y0lXejMW7NMo"], 0 Milliliter,0.4 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 48-well Plate" *)
		{Model[Container, Plate, "id:1ZA60vLlZzrM"], 0.4 Milliliter,1 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 24-well Plate" *)
		{Model[Container, Plate, "id:dORYzZJwOJb5"], 1 Milliliter,2 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 12-well Plate" *)
		{Model[Container, Plate, "id:L8kPEjnY8dME"], 2 Milliliter,3 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 6-well Plate" *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom" *)
		{Model[Container, Vessel, "id:N80DNj0dwPBE"], 3 Milliliter, 35 Milliliter,80 Celsius, -196 Celsius, {Polystyrene}}, (* "Membrane Aerated 50mL Tube" *)
		{Model[Container, Vessel, "id:BYDOjv1VAAxz"], 500 Microliter, 5 Milliliter, 70 Celsius, -40 Celsius, {Polypropylene}}, (* "5mL Tube" *)
		{Model[Container, Vessel, "id:01G6nvwz9YqA"], 3 Milliliter,5 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "T25 EasYFlask, Non-Treated Surface, Filter Cap" *)
		{Model[Container, Vessel, "id:01G6nvwz9qLD"], 5 Milliliter,15 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "T75 EasYFlask, Non-Treated Surface, Filter Cap" *)
		{Model[Container, Vessel, "id:lYq9jRxdYVdl"], 15 Milliliter,53 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}} (* "T175 EasYFlask, Non-Treated Surface, Filter Cap" *)
	};
	suspensionRoboticNonMicrobialCellContainerLookup={
		{Model[Container, Plate, "id:qdkmxzkKwn11"], 5 Microliter, 10 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom" *)
		{Model[Container, Plate, "id:L8kPEjnY8dME"], 2 Milliliter,3 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 6-well Plate" *)
		{Model[Container, Vessel, "id:N80DNj0dwPBE"], 3 Milliliter, 35 Milliliter,80 Celsius, -196 Celsius, {Polypropylene}} (* "Membrane Aerated 50mL Tube" *)
	};
	microbiologySolidMediaCellContainerLookup={
		{Model[Container, Plate, "id:O81aEBZjRXvx"], 0 Milliliter, 80 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}}(*Model[Container, Plate, "Omni Tray Sterile Media Plate"]*)
	};
	microbiologyNonSolidMediaCellContainerLookup={
		{Model[Container, Vessel, "id:N80DNjlYwwjo"], 10 Milliliter, 25 Milliliter, 100 Celsius, -80 Celsius, {Glass}}, (* "125mL Erlenmeyer Flask" *)
		{Model[Container, Vessel, "id:jLq9jXY4kkXE"], 25 Milliliter, 50 Milliliter, 100 Celsius, -80 Celsius, {Glass}}, (* "250mL Erlenmeyer Flask" *)
		{Model[Container, Vessel, "id:bq9LA0dBGG0b"], 50 Milliliter,100 Milliliter,100 Celsius, -80 Celsius, {Glass}}, (* "500mL Erlenmeyer Flask" *)
		{Model[Container, Vessel, "id:8qZ1VWNmddWR"], 100 Milliliter, 200 Milliliter, 100 Celsius, -80 Celsius, {Glass}}, (* "1000mL Erlenmeyer Flask" *)
		{Model[Container, Vessel, "id:AEqRl9KXBDoW"], 140 Milliliter, 14 Milliliter, 80 Celsius, -4 Celsius, {Polypropylene}},(*"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"*)
		{Model[Container, Vessel, "id:N80DNj0dwPBE"], 3 Milliliter, 35 Milliliter, 80 Celsius, -196 Celsius, {Polypropylene}}, (* "Membrane Aerated 50mL Tube" *)
		{Model[Container, Vessel, "id:BYDOjv1VAAxz"], 500 Microliter, 5 Milliliter, 70 Celsius, -40 Celsius, {Polypropylene}}, (* "5mL Tube" *)
		{Model[Container, Plate, "id:qdkmxzkKwn11"], 5 Microliter, 10 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:E8zoYveRlldX"], 50 Microliter, 1 Milliliter, 100 Celsius, -80 Celsius, {Polypropylene}}, (* "24-well Tissue Culture Plate" *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom" *)
		{Model[Container, Plate, "id:Y0lXejMW7NMo"], 0 Milliliter, 0.4 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 48-well Plate" *)
		{Model[Container, Plate, "id:1ZA60vLlZzrM"], 0.4 Milliliter, 1 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 24-well Plate" *)
		{Model[Container, Plate, "id:dORYzZJwOJb5"], 1 Milliliter, 2 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 12-well Plate" *)
		{Model[Container, Plate, "id:L8kPEjnY8dME"], 2 Milliliter, 3 Milliliter, 100 Celsius, -80 Celsius, {Polystyrene}} (* "Nunc Non-Treated 6-well Plate" *)
	};
	microbiologyRoboticNonSolidMediaCellContainerLookup={
		{Model[Container, Plate, "id:qdkmxzkKwn11"], 5 Microliter, 10 Milliliter, 121 Celsius, -196 Celsius, {Polypropylene}}, (* 24-well V-bottom 10 mL Deep Well Plate Sterile *)
		{Model[Container, Plate, "id:4pO6dMmErzez"], 1 Microliter, 2 Milliliter, 121 Celsius, -80 Celsius, {Polypropylene}}, (* "Sterile Deep Round Well, 2 mL, Polypropylene, U-Bottom" *)
		{Model[Container, Plate, "id:L8kPEjnY8dME"], 2 Milliliter,3 Milliliter,100 Celsius, -80 Celsius, {Polystyrene}}, (* "Nunc Non-Treated 6-well Plate" *)
		{Model[Container, Vessel, "id:N80DNj0dwPBE"], 3 Milliliter, 35 Milliliter,80 Celsius, -196 Celsius, {Polypropylene}} (* "Membrane Aerated 50mL Tube" *)
	};
	vacuumFlaskContainerLookup={
		{Model[Container, Vessel, "id:dORYzZJNGlVA"], 0 Milliliter, 125 Milliliter, 230 Celsius, -230 Celsius, {Glass}},(*Model[Container, Vessel, "125 mL Filter Flask"]*)
		{Model[Container, Vessel, "id:eGakldJNAL4n"], 125 Milliliter, 500 Milliliter, 230 Celsius, -230 Celsius, {Glass}},(*Model[Container, Vessel, "500 mL Filter Flask"]*)
		{Model[Container, Vessel, "id:pZx9jo8varzP"], 500 Milliliter, 1000 Milliliter, 230 Celsius, -230 Celsius, {Glass}}(*Model[Container, Vessel, "1000 mL Filter Flask"]*)
	};

	(* based on the option values, choose the lookup we need to use to find an appropriately-compatible container *)
	lookupToUse = Switch[{resolvedSterile, resolvedLightSensitive, resolvedLiquidHandler, resolvedAcousticLiquidHandler, resolvedUltracentrifuge, resolvedCultureAdhesion, resolvedCellType, vacuumFlask},
		{False, False, True, False, False, Null, Null, False}, liquidHandlerContainerLookup,
		{False, True, True, False, False, Null, Null, False}, lightSensitiveLiquidHandlerContainerLookup,
		{True, True, True, False, False, Null, Null, False}, lightSensitiveSterileLiquidHandlerContainerLookup,
		{False, False, False, True, False, Null, Null, False}, acousticLiquidHandlerContainerLookup,
		{False, False, False, False, True, Null, Null, False},ultracentrifugeContainerLookup,
		{True, True, False, False, False, Null, Null, False}, lightSensitiveSterileContainerLookup,
		{True, False, False, False, False, Null, Null, False}, sterileContainerLookup,
		{True, False, True, False, False, Null, Null, False}, liquidHandlerSterileContainerLookup,
		{False, True, False, False, False, Null, Null, False}, lightSensitiveContainerLookup,
		{_, False, True, False, False, Adherent, NonMicrobialCellTypeP, False}, adherentRoboticNonMicrobialCellContainerLookup,
		{_, False, _, False, False, Adherent, NonMicrobialCellTypeP, False}, adherentNonMicrobialCellContainerLookup,
		{_, False, True, False, False, Suspension, NonMicrobialCellTypeP, False}, suspensionRoboticNonMicrobialCellContainerLookup,
		{_, False, _, False, False, Suspension, NonMicrobialCellTypeP, False}, suspensionNonMicrobialCellContainerLookup,
		{_, False, _, False, False, SolidMedia, MicrobialCellTypeP, False}, microbiologySolidMediaCellContainerLookup,
		{_, False, True, False, False, Except[SolidMedia], MicrobialCellTypeP, False}, microbiologyNonSolidMediaCellContainerLookup,
		{_, False, _, False, False, Except[SolidMedia], MicrobialCellTypeP, False}, microbiologyNonSolidMediaCellContainerLookup,
		{False, False, False, False, False, Null, Null, True}, vacuumFlaskContainerLookup,
		{False, False, False, False, False, Null, Null, False}, standardContainerLookup,
		(* we should never get here *)
		_, {}
	];

	(* If they asked for plates or vessels only, remove any others from the lookup list *)
	typeCompatibleLookup = Switch[Lookup[safeOptions,Type],
		All, lookupToUse,
		Plate, Cases[lookupToUse, {ObjectP[Model[Container, Plate]], _, _, _, _, _}],
		Vessel, Cases[lookupToUse, {ObjectP[Model[Container, Vessel]], _, _, _, _, _}]
	];

	(* it is possible that that our lookupToUse does not contain vessels. return a failure early here if typeCompatibleLookup is an empty list *)
	Switch[{typeCompatibleLookup,Lookup[safeOptions,Messages]},
		(* if typeCompatibleLookup is an empty list and Messages -> True, throw a message and return a failure *)
		{{}, True},
			(* get the existing container type from the lookup table to throw a message *)
			containerTypesFromLookup = DeleteDuplicates[lookupToUse[[All,1]] /. Model[Container, type_, _] :> type];
			Message[PreferredContainer::ContainerTypeNotFound, Lookup[safeOptions,Type], containerTypesFromLookup];
			Return[$Failed],
		(* if typeCompatibleLookup is an empty list and we're NOT throwing a message, return a failure *)
		{{}, False}, Return[$Failed],
		(* otherwise, do nothing *)
		_, Nothing
	];

	(* If they asked for a MaxTempreature, make sure that we filter out containers with a MaxTemperature below the one provided. *)
	maxTemperatureCompatibleLookup = If[MatchQ[Lookup[safeOptions, MaxTemperature], TemperatureP],
		Cases[typeCompatibleLookup, {_, _, _, GreaterP[Lookup[safeOptions, MaxTemperature]], _, _}],
		typeCompatibleLookup
	];

	(* If they asked for a MinTempreature, make sure that we filter out containers with a MinTemperature above the one provided. *)
	minTemperatureCompatibleLookup = If[MatchQ[Lookup[safeOptions, MinTemperature], TemperatureP],
		Cases[maxTemperatureCompatibleLookup, {_, _, _, _, LessP[Lookup[safeOptions,MinTemperature]], _}],
		maxTemperatureCompatibleLookup
	];

	(* Check ContainerMaterial *)
	materialCompatibleLookup = If[MatchQ[Lookup[safeOptions, IncompatibleMaterials], {MaterialP..}],
		Select[minTemperatureCompatibleLookup, !MemberQ[#[[6]], Alternatives@@Lookup[safeOptions, IncompatibleMaterials]]&],
		minTemperatureCompatibleLookup
	];

	If[Length[materialCompatibleLookup] == 0,
		If[Lookup[safeOptions,Messages],
			Message[PreferredContainer::NoContainerOfSpecifiedMaterials, Lookup[safeOptions, IncompatibleMaterials], myVolume]
		];
		Return[$Failed]
	];

	(* double-check that the lookup is sorted from smallest to largest volume (if we update the above lines well this should always be redundant) *)
	(*sortedContainerLookup=SortBy[materialCompatibleLookup,(#[[3]]&)];*)

	(* Don't sort the list anymore. Since now we added IncompatibleMaterials option, we also needed to add some less-common container options to cover more sample types *)
	(* Just let the function choose from top to bottom of the hard-coded list *)
	sortedContainerLookup = materialCompatibleLookup;

	(* select all entries in the lookup that match the volume/options provided *)
	possibleContainers=If[MatchQ[myVolume,All],
		sortedContainerLookup[[All,1]],
		(* Should we compute all possible containers that can hold our volume? *)
		If[Quiet[OptionValue[All]],
			Select[sortedContainerLookup,(myVolume<=#[[3]]&)][[All,1]],
			Select[sortedContainerLookup,Between[myVolume,#[[{2,3}]]]&][[All,1]]
		]
	];

	(* determine the min/max volume for the lookup we used; these will be helpful to report if we could not find a container with the given parameters *)
	{minPossibleVolume,maxPossibleVolume}= {Min[sortedContainerLookup[[All, 2]]], Max[sortedContainerLookup[[All, 3]]]};

	(* if we were looking for a single container, but didn't get one, return a failure; otherwise, return a list for All input, and a singleton for volume input *)
	Which[
		VolumeQ[myVolume]&&MatchQ[possibleContainers,{}],
			If[Lookup[safeOptions,Messages],
				Message[PreferredContainer::ContainerNotFound,myVolume,minPossibleVolume,maxPossibleVolume];
			];
			Return[$Failed],
		VolumeQ[myVolume],
			(* Should we return all possible containers, or just the first? *)
			If[Quiet[OptionValue[All]],
				possibleContainers,
				First[possibleContainers]
			],
		True,
			possibleContainers
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Solid*)


PreferredContainer[myMass:(GreaterEqualP[0 Gram]|All),myOptions:OptionsPattern[]]:=Module[
	{safeOptions,myDensity,myVolume,preferredContainer},

	(* Validate input options *)
	safeOptions=SafeOptions[PreferredContainer, ToList[myOptions]];

	(* Define sterility/light-sensitivity toggling booleans *)
	myDensity=Lookup[safeOptions,Density];

	(* Calculate the volume of the mass, given the provided density *)
	(* Currently, the Density option defaults to 1g/cm^3 so no density resolution needs to be done here *)
	myVolume=If[MatchQ[myMass,All],
		All,
		myMass/myDensity
	];

	(*
		Call the core, volume-based overload to resolve which model to use
		NOTE: If we decide later to use different default containers for solids and liquids, this will need to change
	*)
	preferredContainer=PreferredContainer[myVolume,safeOptions]
];
