(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*SafeRound*)

(* ::Subsubsection:: *)
(*Options and Errors*)

DefineOptions[
	SafeRound,
	Options :> {
		{RoundAmbiguous -> Up, ListableP[Up | Down], "Indicates if numbers that are exactly a multiple of optionPrecision/2 and not a multiple of optionPrecision should be rounded up or down."},
		{Round -> Null, ListableP[Null | Up | Down], "Indicates if numbers that are not a multiple of optionPrecision should be always rounded up or down."},
		{AvoidZero -> False, ListableP[True | False], "Indicates if numbers should not be rounded to zero (will be rounded up or down to avoid rounding to zero)."}
	}
];

Error::ValuesPrecisionLengthsMismatch="SafeRound was provided `1` values to round and `2` precisions to use. Please check that the length of the values and precisions are the same.";
Error::ValuesPrecisionDimensionsMismatch="SafeRound was provided the following values `1` which do not match the shape of their associated precisions (`2`). Please check that the dimenions of the values and precisions are the same.";

(* ::Subsubsection:: *)
(*Options Helpers*)

(* ::Subsubsubsection:: *)
(*mapThreadSafeRoundOptions*)

(* This is required because mapThreadOptions is at a lower level on the dependency stack, so we make our own *)
mapThreadSafeRoundOptions[nInputs_Integer, options:OptionsPattern[SafeRound]]:=Module[
	{listedOps, expandedOptions},

	(* List all the options *)
	listedOps={
		Round -> OptionDefault[OptionValue[Round]],
		RoundAmbiguous -> OptionDefault[OptionValue[RoundAmbiguous]],
		AvoidZero -> OptionDefault[OptionValue[AvoidZero]]
	};

	(* Expand the options of RoundOptionPrecision to make the length of the inputs *)
	expandedOptions=Map[
		Function[
			{optionRule},

			If[MatchQ[Last[optionRule], _List],

				(* if it's already been listed, leave it be *)
				optionRule,

				(* If it's not already listed, expand the value *)
				Rule[
					First[optionRule],
					Table[Last[optionRule], nInputs]
				]
			]
		],
		listedOps
	];

	(* Convert our options to the map-thread friendly version. *)
	Transpose[
		Module[{optionSymbol, optionValues, optionSymbolList},

			(* Seperate out the option symbol from the option values. *)
			optionSymbol=#[[1]];
			optionValues=ToList[#[[2]]];

			(* Get a list of optionSymbol that is the same length as optionValue. *)
			optionSymbolList=ConstantArray[optionSymbol, nInputs];

			MapThread[
				Rule,
				{optionSymbolList, optionValues}
			]
		]& /@ expandedOptions
	]
];

(* ::Subsubsubsection:: *)
(*toNonFraction*)

toNonFraction[listX_List]:=toNonFraction /@ listX;

toNonFraction[symX:_Symbol]:=symX;

toNonFraction[spanX:_Span]:=Span[
	toNonFraction[First[spanX]],
	toNonFraction[Last[spanX]]
];

toNonFraction[quant:_Quantity]:=If[MatchQ[First[quant], _Rational],
	N[Unitless@quant] * Units[quant],
	quant
];

toNonFraction[num:_?NumericQ]:=If[MatchQ[num, _Rational],
	N[num],
	num
];

(* ::Subsubsubsection:: *)
(*roundablePatternP*)

(* Symbol is included because Automatic is handled but ignored *)
roundablePatternP=Alternatives[_?NumericQ, _Quantity, _Symbol];

(* For cases like Automatic *)
toNonFraction[symX:_Symbol]:=symX;

(* ::Subsubsection:: *)
(*SafeRound - Symbol Overloads*)

SafeRound[symX:_Symbol, precision_, options:OptionsPattern[SafeRound]]:=symX;

SafeRound[symXList:{(_Symbol)..}, precision_, options:OptionsPattern[SafeRound]]:=symXList;

SafeRound[emptyList:{}, precision_, options:OptionsPattern[SafeRound]]:={};

(* ::Subsubsection:: *)
(*SafeRound - Quantity Overloads*)

(* Single quantity, single quantity precision overload*)
SafeRound[quant:_Quantity, precision:_Quantity, options:OptionsPattern[SafeRound]]:=Module[
	{convertedQuant, roundedVal},

	(* First, convert our quant into units of the precision *)
	convertedQuant=Convert[quant, Units[precision]];

	If[MatchQ[convertedQuant, $Failed],
		Return[$Failed]
	];

	(* Then round our value *)
	roundedVal=SafeRound[QuantityMagnitude[convertedQuant], QuantityMagnitude[precision], options];

	(* Then re-apply the units of the precision to our rounded value *)
	(* NOTE: We have to Rationalize[...] before we can do any more math because convertion of units can cause additional precision to be added again. *)
	toNonFraction@Convert[Rationalize[roundedVal] * Units[precision], Units[quant]]
];

(* Single quantity with unitless precision overload *)
SafeRound[quant:_Quantity, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=(SafeRound[Unitless[quant], precision, options] * Units[quant]);

(* Flat list of quantities with unitless precision overload *)
SafeRound[quants:{(_Quantity | _Symbol)..}, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=Module[
	{mappedOptions},

	(* Convert our options into mapthreadable option lists *)
	mappedOptions=mapThreadSafeRoundOptions[Length[quants], options];

	(* Now mapthread the quants and options *)
	MapThread[
		If[MatchQ[#1, _Quantity],
			SafeRound[Unitless[#1], precision, #2] * Units[#1],
			SafeRound[#1, precision, #2]
		]&,
		{quants, mappedOptions}
	]
];

(* Flat list of quantities with quantity precision overload *)
SafeRound[quants:{roundablePatternP..}, precision:_Quantity, options:OptionsPattern[SafeRound]]:=SafeRound[#, precision, options]& /@ quants;

(* Flat list of quantities and a flat list of quantity precisions overload *)
SafeRound[quants:{roundablePatternP..}, precisions:{(_Quantity)..}, options:OptionsPattern[SafeRound]]:=Module[
	{mappedOptions, roundedVals, convertedVals},

	(* Ensure the length of the vals and precisions is the same *)
	If[!MatchQ[Length[quants], Length[precisions]],

		(* Since we determined there was a length mismatch between our inputs, throw an error and return the vals *)
		(
			Message[Error::ValuesPrecisionLengthsMismatch, First@Length[quants], First@Length[precisions]];
			Return[quants];
		)
	];

	(* Convert our options into mapthreadable option lists *)
	mappedOptions=mapThreadSafeRoundOptions[Length[precisions], options];

	(* Map our SafeRound over untiless values then re-apply the units*)
	roundedVals=MapThread[
		Function[
			{quant, precision, optionSet},
			If[MatchQ[quant, _Quantity],
				SafeRound[Unitless[quant, Units[precision]], precision, optionSet] * Units[precision],
				SafeRound[quant, precision, optionSet]
			]
		],
		{quants, precisions, mappedOptions}
	];

	(* Because we wanted to convert in the units of the precision, we now need to convert back to the units given to us initially *)
	(* NOTE: We have to Rationalize[...] before we can do any more math because convertion of units can cause additional precision to be added again. *)
	convertedVals=Convert[Rationalize[roundedVals], Units[quants]];

	If[MatchQ[convertedVals, $Failed],
		$Failed,
		toNonFraction@convertedVals
	]
];

(* Flat list of quantities and a flat list of quantity precisions overload *)
SafeRound[nestedQuants:{{roundablePatternP..}..} | {{{roundablePatternP..}..}}, nestedPrecisions:{(_Quantity | _?NumericQ)..} | {{(_Quantity | _?NumericQ)..}}, options:OptionsPattern[SafeRound]]:=Module[
	{quants, precisions, quantDimenions, precisionDimensions, transposedValues, roundedTransposedValues},

	(* Conditionally add then strip off one list - this is because we know we're only handling one nested list but it may have been additionally listed already *)
	quants=If[
		(* If the input was three levels deep *)
		MatchQ[nestedQuants, List[List[(_List)..]]],

		(* We have to add back the additional layer we stripped off at the start *)
		First[nestedQuants],

		(* Otherwise leave the input as is *)
		nestedQuants
	];

	(* Conditionally add then strip off one list - this is because we know we're only handling one nested list but it may have been additionally listed already *)
	precisions=If[

		(* If the input a single flat list *)
		MatchQ[nestedPrecisions, {(_Quantity)..}],

		(* We have to add back the additional layer that's missing *)
		List[nestedPrecisions],

		(* Otherwise leave the input as is *)
		nestedPrecisions
	];

	(* Get the dimensions of the specific val and precision we're looking at *)
	quantDimenions=Dimensions[quants];
	precisionDimensions=Dimensions[precisions];

	(* Check that the dimensions of the nested list match the dimensions (in part) of our nested precisions *)
	If[
		!MatchQ[Last[quantDimenions], Last[precisionDimensions]],
		(
			Message[Error::ValuesPrecisionDimensionsMismatch, vals, precisions];
			Return[nestedQuants]
		)
	];

	(* Transpose our values so we have flat lists of values at each index of each sublist *)
	transposedValues=Transpose[quants];

	(* MapThread SafeRound over the flat lists and precisions associated with them *)
	roundedTransposedValues=MapThread[
		SafeRound[#1, #2, options]&,
		{
			transposedValues,
			Flatten[precisions]
		}
	];

	(* Then convert them back into the form we accepted the original nested vals in *)
	If[

		(* If the input was three levels deep *)
		MatchQ[nestedQuants, List[List[(_List)..]]],

		(* We have to add back the additional layer we stripped off at the start *)
		List[Transpose[roundedTransposedValues]],

		(* Otherwise a simple transpose gets it back in the original form *)
		Transpose[roundedTransposedValues]
	]
];


(* Span of quantities overload *)
SafeRound[quantSpan:{Span[_Quantity, _Quantity]}, precision:_Quantity, options:OptionsPattern[SafeRound]]:=List@SafeRound[First[quantSpan], precision, options];
SafeRound[quantSpans:{Span[_Quantity, _Quantity]..}, precision:_Quantity, options:OptionsPattern[SafeRound]]:=SafeRound[#, precision, options]& /@ quantSpans;
SafeRound[quantSpan:Span[_Quantity, _Quantity], precision:{_Quantity}, options:OptionsPattern[SafeRound]]:=SafeRound[quantSpan, First[precision], options];
SafeRound[quantSpan:Span[_Quantity, _Quantity], precision:_Quantity, options:OptionsPattern[SafeRound]]:=Module[
	{precisionUnits, lowerBound, upperBound},

	(* Stash the precision's units *)
	precisionUnits=Units[precision];

	(* NOTE: We have to Rationalize[...] before we can do any more math because convertion of units can cause additional precision to be added again. *)
	lowerBound=toNonFraction@If[MatchQ[First[quantSpan], _Quantity],
		Convert[
			Rationalize[SafeRound[Unitless[First[quantSpan], precisionUnits], Unitless[precision], options]] * precisionUnits,
			Units[First[quantSpan]]
		],

		SafeRound[First[quantSpan], precision, options]
	];

	(* NOTE: We have to Rationalize[...] before we can do any more math because convertion of units can cause additional precision to be added again. *)
	upperBound=toNonFraction@If[MatchQ[Last[quantSpan], _Quantity],
		Convert[
			Rationalize[SafeRound[Unitless[Last[quantSpan], precisionUnits], Unitless[precision], options]] * precisionUnits,
			Units[Last[quantSpan]]
		],
		SafeRound[Last[quantSpan], precision, options]
	];

	Span[lowerBound, upperBound]
];


(* ::Subsubsection:: *)
(*SafeRound - Unitless Overloads*)

(* Multiple values to round with a single precision *)
SafeRound[vals:{(_?NumericQ)..}, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=(SafeRound[#, precision, options]& /@ vals);

(* Multiple values to round with a single precision *)
SafeRound[vals:ListableP[_?NumericQ], precisions:{(_?NumericQ)..}, options:OptionsPattern[SafeRound]]:=Module[
	{listedVals, mappedOptions, roundedVals},

	(* Make sure to list vals incase we were provided multiple precisions but only one value *)
	listedVals=ToList[vals];

	(* Ensure the length of the vals and precisions is the same *)
	If[!MatchQ[Length[listedVals], Length[precisions]],

		(* Since we determined there was a length mismatch between our inputs, throw an error and return the vals *)
		(
			Message[Error::ValuesPrecisionLengthsMismatch, First@Length[listedVals], First@Length[precisions]];
			Return[vals];
		)
	];

	(* Convert our options into mapthreadable option lists *)
	mappedOptions=mapThreadSafeRoundOptions[Length[precisions], options];

	(* MapThread over our vals and precisions to round everything appropriately *)
	roundedVals=MapThread[SafeRound[#1, #2, #3]&, {listedVals, precisions, mappedOptions}];

	(* Then return the input as we were provided it *)
	If[
		MatchQ[vals, _List],
		roundedVals,
		First[roundedVals]
	]
];

(* Singled nested list *)
SafeRound[nestedVals:{{(_?NumericQ)..}..} | {{{(_?NumericQ)..}..}}, nestedPrecisions:{(_?NumericQ)..} | {{(_?NumericQ)..}}, options:OptionsPattern[SafeRound]]:=Module[
	{vals, precisions, valDimenions, precisionDimensions, transposedValues, roundedTransposedValues},

	(* Conditionally add then strip off one list - this is because we know we're only handling one nested list but it may have been additionally listed already *)
	vals=If[

		(* If the input was three levels deep *)
		MatchQ[nestedVals, List[List[(_List)..]]],

		(* We have to add back the additional layer we stripped off at the start *)
		First[nestedVals],

		(* Otherwise leave the input as is *)
		nestedVals
	];

	(* Conditionally add then strip off one list - this is because we know we're only handling one nested list but it may have been additionally listed already *)
	precisions=If[

		(* If the input was three levels deep *)
		MatchQ[nestedPrecisions, {(_?NumericQ)..}],

		(* We have to add back the additional layer that's missing *)
		List[nestedPrecisions],

		(* Otherwise leave the input as is *)
		nestedPrecisions
	];

	(* Get the dimensions of the specific val and precision we're looking at *)
	valDimenions=Dimensions[vals];
	precisionDimensions=Dimensions[precisions];

	(* Check that the dimensions of the nested list match the dimensions (in part) of our nested precisions *)
	If[
		!MatchQ[Last[valDimenions], Last[precisionDimensions]],
		(
			Message[Error::ValuesPrecisionDimensionsMismatch, vals, precisions];
			Return[vals]
		)
	];

	(* Transpose our values so we have flat lists of values at each index of each sublist *)
	transposedValues=Transpose[vals];

	(* MapThread SafeRound over the flat lists and precisions associated with them *)
	roundedTransposedValues=MapThread[
		SafeRound[#1, #2, options]&,
		{
			transposedValues,
			Flatten[precisions]
		}
	];

	(* Then convert them back into the form we accepted the original nested vals in *)
	If[

		(* If the input was three levels deep *)
		MatchQ[nestedVals, List[List[(_List)..]]],

		(* We have to add back the additional layer we stripped off at the start *)
		List[Transpose[roundedTransposedValues]],

		(* Otherwise a simple transpose gets it back in the original form *)
		Transpose[roundedTransposedValues]
	]
];

(* Span Input *)
SafeRound[valSpan:{_Span}, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=SafeRound[First[valSpan], precision, options];
SafeRound[valSpan:_Span, precision:{_?NumericQ}, options:OptionsPattern[SafeRound]]:=SafeRound[valSpan, First[precision], options];
SafeRound[valSpan:_Span, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=Span[
	SafeRound[First[valSpan], precision, options],
	SafeRound[Last[valSpan], precision, options]
];

(* Multiple inputs of different shapes overload - This overload must be below the multiple values/precisions overload that deal with flat lists or ListableP values *)
SafeRound[vals:{((_Span) | roundablePatternP | {roundablePatternP..} | {{roundablePatternP..}..})..}, precisions:{(((_?NumericQ) | _Quantity) | {((_?NumericQ) | _Quantity)..})..}, options:OptionsPattern[SafeRound]]:=Module[
	{correctShapeBools, mappedOptions},

	(* Ensure the length of the vals and precisions is the same *)
	If[!MatchQ[Length[vals], Length[precisions]],

		(* Since we determined there was a length mismatch between our inputs, throw an error and return the vals *)
		(
			Message[Error::ValuesPrecisionLengthsMismatch, First@Length[vals], First@Length[precisions]];
			Return[vals];
		)
	];

	(* Now we need to MapThread over our listed Vals and Precisions to make sure each index of each matches the proper dimenions *)
	correctShapeBools=MapThread[
		Function[{listableVal, listablePrecision},

			(* Walk through the list of allowable combinations. If the value and precision satsify any of the following we're ok *)
			Or[

				(* A single value that is being rounded by a single precision *)
				MatchQ[listableVal, (roundablePatternP)] && MatchQ[listablePrecision, ((_?NumericQ) | _Quantity)],

				(* A single span that is being rounded by a single precision *)
				MatchQ[listableVal, _Span] && MatchQ[listablePrecision, ((_?NumericQ) | _Quantity)],

				(* A flat list of values that is being rounded by a single precision *)
				MatchQ[listableVal, {roundablePatternP..}] && MatchQ[listablePrecision, ((_?NumericQ) | _Quantity)],

				(* A flat list of values and a flat list of precisions that have the same lengths and can be mapthreaded together *)
				And[
					MatchQ[listableVal, {roundablePatternP..}],
					MatchQ[listablePrecision, {((_?NumericQ) | _Quantity)..}],
					MatchQ[Length[listableVal], Length[listablePrecision]]
				],

				(* A nested list of values and a nested list of precisions where the dimensions of the values match the shape of precisions *)
				And[
					MatchQ[listableVal, {{roundablePatternP..}..}],
					MatchQ[listablePrecision, {((_?NumericQ) | _Quantity)..}],

					(* This checks that the length of each sublist of the listableVal is matches the length of the listablePrecision *)
					MatchQ[
						Last[Dimensions[listableVal]],
						Length[listablePrecision]
					]
				]
			]
		],

		{vals, precisions}
	];

	(* Make sure we didn't receive any flagged dimenions errors *)
	If[MemberQ[correctShapeBools, False],

		(* Since we discovered errors, through a message with the appropriately flagged indexes then return the vals as they were provided*)
		Module[
			{invalidVals, invalidPrecisions},

			(* Get all the invalid vals *)
			invalidVals=Extract[
				vals,
				Position[correctShapeBools, False]
			];

			(* Get all the invalid vals *)
			invalidPrecisions=Extract[
				precisions,
				Position[correctShapeBools, False]
			];

			(* Now throw a readable error message with the highlighted values and precisions *)
			Message[Error::ValuesPrecisionDimensionsMismatch, invalidVals, invalidPrecisions]
		];

		(* Lastly, return the provided value inputs *)
		Return[vals]
	];

	(* Convert our options into mapthreadable option lists *)
	mappedOptions=mapThreadSafeRoundOptions[Length[precisions], options];

	(* MapThread over our vals and precisions to round everything appropriately *)
	MapThread[SafeRound[#1, #2, #3]&, {vals, precisions, mappedOptions}]
];

(* ::Subsubsection:: *)
(*SafeRound - Core overload*)

(* Core overload - single value and precision *)
SafeRound[val:_?NumericQ, precision:_?NumericQ, options:OptionsPattern[SafeRound]]:=Module[
	{roundAmbiguous, rounding, avoidingZero, convertedValueMagnitude, roundedValRaw, roundedVal, roundedValTrimmed,
		numberOfDigits, roundedValZeroAdjusted},

	roundAmbiguous=OptionDefault[OptionValue[RoundAmbiguous]];
	rounding=OptionDefault[OptionValue[Round]];
	avoidingZero=OptionDefault[OptionValue[AvoidZero]];

	(* Get the magnitude of the converted value. *)
	convertedValueMagnitude=QuantityMagnitude[val];

	roundedValRaw=If[PossibleZeroQ[FractionalPart[convertedValueMagnitude / (precision / 2)]] && !PossibleZeroQ[FractionalPart[convertedValueMagnitude / precision]],

		(* It is ambiguous as to whether we should round up or down. Look at the Round option. *)
		If[MatchQ[roundAmbiguous, Down],
			(convertedValueMagnitude - (QuantityMagnitude[precision] / 2)),
			(convertedValueMagnitude + (QuantityMagnitude[precision] / 2))
		],

		(* Not ambiguous. *)
		Switch[rounding,

			Up,
			(* When we use the regular Round[] function, is it going to round it up for us? *)
			If[MatchQ[val, GreaterP[Round[val, precision]]],

				(* If not, force it to use Ceiling *)
				Ceiling[convertedValueMagnitude, QuantityMagnitude[precision]],

				(* We determined it will round up so we can use Round[]*)
				Round[val, precision]
			],

			Down,
			(* When we use the regular Round[...] function, is it going to round it down for us? *)
			If[MatchQ[val, LessP[Round[val, precision]]],

				(* If not, force it to use Floor *)
				Floor[convertedValueMagnitude, QuantityMagnitude[precision]],

				(* We determined it will round down so we can use Round[]*)
				Round[val, precision]
			],

			Null,
			Round[val, precision],

			_,
			Round[val, precision]
		]
	];

	(* If the result of our rounding left the value as a fraction, which MM will do to avoid floating point errors, run N on it to get it into a real *)
	roundedVal=toNonFraction[roundedValRaw];

	(* Stash how many decimal places (after the decimal) we want to round to - multiplying by -1 means that 10^-3 turns into 3 *)
	(* We also Round to 1 here to turn our log value into an integer, which RoundReals requires, in case we were given SafeRound[n, 3] *)
	numberOfDigits=Round[Ceiling@Log[10, Abs[roundedVal]], 1] + (-1 * Round[Floor@Log[10, Abs[precision]], 1]);

	(* Now use RoundReals to trim our value to the appropriate number of digits *)
	roundedValTrimmed=If[!PossibleZeroQ[roundedVal],

		(* Trim our rounded val to the number of digits we want*)
		RoundReals[
			roundedVal,
			numberOfDigits
		],

		(* Since we think the value is zero, RoundReals will choke so just return our roundedVal *)
		roundedVal
	];

	(* Now determine if we need to double check whether we rounded to zero *)
	roundedValZeroAdjusted=If[avoidingZero,

		(* We are avoiding rounding to zero so we have to make sure we didn't do that *)
		If[PossibleZeroQ[QuantityMagnitude[roundedValTrimmed]],

			(* Were we given a zero? *)
			If[MatchQ[val, roundedValTrimmed],

				(* Then don't change it, we didn't round the value. *)
				roundedValTrimmed,

				(* We did round the value to zero. *)
				If[roundedValTrimmed > val,

					(* We rounded up to zero. Subtract the optionPrecision to round down instead. *)
					roundedValTrimmed - precision,

					(* We rounded down to zero. Subtract the optionPrecision to round up instead. *)
					roundedValTrimmed + precision
				]
			],

			(* The rounded value is not zero so just return it *)
			roundedValTrimmed
		],

		(* We are not avoiding zeros so return whatever we rounded to *)
		roundedValTrimmed
	];

	(* Make sure we don't unnecessarily change the precision of the user's options (ex. 1. vs 1) *)
	If[Abs[N[QuantityMagnitude[val] - QuantityMagnitude[roundedValZeroAdjusted]]] < 1 * 10^-16,

		(* There's no difference between the rounded and user inputted values. *)
		(* Stick with the user's value. *)
		val,

		(* There is a difference between the rounded and user inputted values. *)
		(* Stick with the rounded value. *)
		roundedValZeroAdjusted
	]
];
