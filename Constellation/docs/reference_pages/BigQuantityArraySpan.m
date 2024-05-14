

(* ::Section::Closed:: *)
(*BigQuantityArraySpan*)
DefineUsage[BigQuantityArraySpan,
	{
		BasicDefinitions -> {
			{"BigQuantityArraySpan[object, field, start, stop]", "quantityArray", "downloads a BigQuantityArray 'field' from an 'object' that is saved to disk, and the elements between 'start' and 'stop' (inclusive on both ends) parsed from disk and returned."}
		},
		Input :> {
			{"object", ObjectP[], "An object with a BigQuantityArray field."},
			{"field", _Symbol, "The field that stores the BigQuantityArray."},
			{"start", _Integer, "The index that represents the starting point of the span of elements returned from the BigQuantityArray."},
			{"stop", _Integer, "The index that represents the stopping point of the span."}
		},
		Output :> {
			{"quantityArray", _QuantityArray, "The output is a quantity array that is a subset of elements of the full quantity array."}
		},
		SeeAlso -> {"DownloadBigQuantityArraySpan"},
		Author -> {"tommy.harrelson", "li.gao"}
	}
];

(* ::Section::Closed:: *)
(*DownloadBigQuantityArraySpan*)
DefineUsage[DownloadBigQuantityArraySpan,
	{
		BasicDefinitions -> {
			{"DownloadBigQuantityArraySpan[object, field, start, stop]", "quantityArray", "requests a span of a BigQuantityArray, given by 'field', from its storage location on S3, without saving the entire file to disk."}
		},
		Input :> {
			{"object", ObjectP[], "An object with a BigQuantityArray field."},
			{"field", _Symbol, "The field that stores the BigQuantityArray."},
			{"start", _Integer, "The index that represents the starting point of the span of elements returned from the BigQuantityArray."},
			{"stop", _Integer, "The index that represents the stopping point of the span."}
		},
		Output :> {
			{"quantityArray", _QuantityArray, "The output is a quantity array that is a subset of elements of the full quantity array."}
		},
		SeeAlso -> {"BigQuantityArraySpan"},
		Author -> {"tommy.harrelson", "li.gao"}
	}
];