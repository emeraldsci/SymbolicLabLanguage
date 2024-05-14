(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*UploadName*)


(* ::Subsubsection:: *)
(*UploadName*)


DefineUsage[UploadName,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadName[objects,names]", "namedObjects"},
				Description -> "returns the objects in 'objects' with their corresponding name in 'names'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description -> "Objects which will be named.",
							Widget -> With[{allTypes=Types[]}, Widget[Type -> Object, Pattern :> ObjectP[allTypes]]]
						},
						{
							InputName -> "names",
							Description -> "Names for each object.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word]
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "namedObjects",
						Description -> "Objects with their name.",
						Pattern :> ListableP[ObjectP[]]
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"UploadNameOptions",
			"UploadNamePreview",
			"ValidUploadNameQ"
		},
		Author -> {"malav.desai", "waseem.vali", "harrison.gronlund"}
	}
];


(* ::Subsubsection:: *)
(*UploadNameOptions*)


DefineUsage[UploadNameOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadNameOptions[objects,names]", "resolvedOptions"},
				Description -> "returns the resolved options for UploadName when it is called on 'objects' and 'names'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description -> "Objects which will be named.",
							Widget -> With[{allTypes=Types[]}, Widget[Type -> Object, Pattern :> ObjectP[allTypes]]]
						},
						{
							InputName -> "names",
							Description -> "Names for each object.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word]
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadName is called on the input objects and names.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to UploadName if it were called on these input objects and names."
		},
		SeeAlso -> {
			"UploadName",
			"UploadNamePreview",
			"ValidUploadNameQ"
		},
		Author -> {"malav.desai", "waseem.vali", "harrison.gronlund"}
	}
];



(* ::Subsubsection:: *)
(*UploadNamePreview*)


DefineUsage[UploadNamePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadNamePreview[objects,names]", "preview"},
				Description -> "returns the preview for UploadName when it is called on 'objects' and 'names'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description -> "Objects which will be named.",
							Widget -> With[{allTypes=Types[]}, Widget[Type -> Object, Pattern :> ObjectP[allTypes]]]
						},
						{
							InputName -> "names",
							Description -> "Names for each object.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word]
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of UploadName. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"UploadName",
			"UploadNameOptions",
			"ValidUploadNameQ"
		},
		Author -> {"malav.desai", "waseem.vali", "harrison.gronlund"}
	}
];



(* ::Subsubsection:: *)
(*ValidUploadNameQ*)


DefineUsage[ValidUploadNameQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadNameQ[objects,names]", "bools"},
				Description -> "checks whether the provided 'objects' and 'names' and specified options are valid for calling UploadName.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description -> "Objects which will be named.",
							Widget -> With[{allTypes=Types[]}, Widget[Type -> Object, Pattern :> ObjectP[allTypes]]]
						},
						{
							InputName -> "names",
							Description -> "Names for each object.",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word]
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the UploadName call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UploadName",
			"UploadNameOptions",
			"UploadNamePreview"
		},
		Author -> {"malav.desai", "waseem.vali", "harrison.gronlund"}
	}
];