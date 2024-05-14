(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PrintStickers*)


(* ::Subsubsection::Closed:: *)
(*PrintStickers*)


DefineUsage[
	PrintStickers,
	{
		BasicDefinitions -> {
			{"PrintStickers[object]", "stickerSheet", "generates and prints a barcoded sticker for the specified 'object'."},
			{"PrintStickers[object, positions]", "stickerSheet", "generates and prints barcoded sticker(s) for the specified 'positions' within the specified 'object'."},
			{"PrintStickers[object, All]", "stickerSheet", "generates and prints barcoded sticker(s) for all positions within the specified 'object'."},
			{"PrintStickers[transaction]", "stickerSheet", "generates and prints a barcoded sticker for the all of the objects shipped in 'transaction'."}
		},
		MoreInformation -> {
			"THE APPROPRIATE COMPUTER (chem-1-pc) MUST BE USED AND THE APPROPRIATE PRINTER MUST BE SELECTED MANUALLY when printing anything other than Small Object stickers.",
			"The StickerSize option and the presence or absence of a 'positions' input determine the StickerModel that is used.",
			"If the StickerSize option and 'positions' input do not resolve to a sticker model that matches the specified StickerModel, an error is thrown.",
			"The presence or absence of a 'positions' input influences printing behavior and the contents of the sticker (see below).",
			Grid[{
				{"If 'positions' is NOT provided:"},
				{"- Prints stickers with the object's ID field encoded in the barcode (e.g. 'id:abcdefghijkl')."}
			}],
			Grid[{
				{"If 'positions' is provided:"},
				{"- Prints one sticker for each specified position that exists in the specified object."},
				{"- Prints stickers with individual positions' names appended to the object ID in the barcode (e.g. 'id:abcdefghijkl[Top Shelf Slot]')."},
				{"- If 'All' is provided as the 'positions' input, destination stickers are printed for all existing positions of the specified objects."}
			}]
		},
		Input :> {
			{"object", SLLObjectP[{sample, instrument, container, part, sensor, plumbing, wiring}], "The object or packet of a sample for which sticker(s) will be printed."},
			{"positions", _String | {_String..}, "A single position or a list of positions for which destination stickers will be printed."},
			{"transaction", ObjectP[Object[Transaction, ShipToECL]], "The transaction shipping objects for which stickers will be printed"}
		},
		Output :> {
			{"stickerSheet", Null | {_Notebook..}, "A list of notebooks containing the generated sticker sheets if Print->False; Null if Print->True."}
		},
		Behaviors -> {},
		SeeAlso -> {
			"GenerateAutomaticOrders"
		},
		Author -> {
			"ben",
			"srikant",
			"wyatt",
			"cheri"
		},
		Tutorials -> {}
	}
];

(* ::Subsection::Closed:: *)
(*generateNumberAndWord*)


(* ::Subsubsection::Closed:: *)
(*generateNumberAndWord*)


DefineUsage[
	generateNumberAndWord,
	{
		BasicDefinitions -> {
			{"generateNumberAndWord[objectID]", "hashphrase", "generates a 'hashphrase' consisting of a number followed by a word for an object ID."},
			{"generateNumberAndWord[{objectID..}]", "{hashphrase..}", "generates a 'hashphrase' consisting of a number followed by a word for each object ID in a list."}
		},
		MoreInformation -> {
			"Handles basic cases where an SLL ID is misformed, such as trailing whitespace and a trailing position designation, returning the hashphrase based only on the object ID itself.",
			"Other incorrect inputs return an error.",
			"The same hashphrase is generated for the same object each time the function is called. Hashphrases are not necessarily unique (~500,000 combinations)."
		},
		Input :> {
			{"objectID", _String, "The SLL ID of the object to generate the hashphrase for."}
		},
		Output :> {
			{"hashphrase", _String, "The hashphrase for the object."}
		},
		SeeAlso -> {
			"PrintStickers",
			"GenerateAutomaticOrders"
		},
		Author -> {
			"david.ascough",
			"thomas"
		}
	}
];

