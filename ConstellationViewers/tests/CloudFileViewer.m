(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
	getCloudFrontURL,
	{
		Test["Generates a URL from a cloudfile:",
			getCloudFrontURL[
				Download[First@Search[Object[EmeraldCloudFile], FileType=="\"MP4\"", MaxResults -> 1], CloudFile]
			],
			URLP
		]
	}
];
