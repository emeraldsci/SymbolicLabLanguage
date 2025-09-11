(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*SafeRound*)


DefineUsage[SafeRound,
	{
		BasicDefinitions ->
			{
				{"SafeRound[vals,precisions]", "roundedVal", "rounds `vals` to the specified `precisions`."},
				{"SafeRound[quantities,precisions]", "roundedVal", "rounds every `quantities` to the specified `precisions` and assigns the value the unit of the associated precision."}
			},
		Input :>
			{
				{"vals", ListableP[(_?NumericQ) | {(_?NumericQ)..} | {{(_?NumericQ)..}}], "Values that will be rounded to a given magnitude according to their corresponsding `precisions`."},
				{"quantities", ListableP[(_Quantity) | {(_Quantity)..} | {{(_Quantity)..}}], "Quantities with units that will be rounded to a given magnitude and unit according to their corresponsding `precisions`."},
				{"precisions", ListableP[(_Quantity) | (_?NumericQ) | {((_Quantity) | (_?NumericQ))..}], "The number(s) with which to round `vals` to a corresponding order of magnitude."}
			},
		Output :>
			{
				{"roundedVals", ListableP[(_?NumericQ) | {(_?NumericQ)..} | {{(_?NumericQ)..}}], "The result of trying to round the `vals` to the provided `precisions`."}
			},
		SeeAlso ->
			{
				"Round",
				"RoundReals",
				"RoundOptionPrecision"
			},
		Author -> {"xu.yi", "wyatt", "thomas"}
	}
];