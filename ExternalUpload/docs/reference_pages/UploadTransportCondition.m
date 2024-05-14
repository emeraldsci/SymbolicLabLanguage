(* ::Package:: *)

(* ::Section:: *)
(*Definition*)


(* ::Subsection::Closed:: *)
(*UploadTransportCondition*)


DefineUsage[UploadTransportCondition,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadTransportCondition[samples,transportConditions]", "modifiedSamples"},
				Description -> "returns the objects in 'samples' with their corresponding transport conditions in 'transportConditions'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "samples",
							Description -> "Samples which will have transport conditions uploaded to them.",
							Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
							Expandable -> False
						},
						{
							InputName -> "transportConditions",
							Description -> "Transport Conditions for each sample.",
							Widget -> Widget[Type -> Expression, Pattern :> TransportConditionP | RangeP[-86 Celsius, 105 Celsius], Size -> Word],
							Expandable -> True
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "modifiedSamples",
						Description -> "Samples with transport conditions uploaded.",
						Pattern :> ListableP[ObjectP[{Object[Sample], Model[Sample]}]]
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"UploadTransportConditionOptions",
			"UploadTransportConditionPreview",
			"ValidUploadTransportConditionQ"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "cgullekson", "harrison.gronlund"}
	}
];




(* ::Subsection:: *)
(*UploadTransportConditionOptions*)

DefineUsage[UploadTransportConditionOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadTransportConditionOptions[samples,transportConditions]", "resolvedOptions"},
				Description -> "returns the resolved options for UploadTransportCondition when it is called on 'samples' and 'transportConditions'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "samples",
							Description -> "Samples which will have transport conditions uploaded to them.",
							Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
							Expandable -> False
						},
						{
							InputName -> "transportConditions",
							Description -> "Transport Conditions for each sample.",
							Widget -> Widget[Type -> Expression, Pattern :> Chilled | RangeP[27 Celsius, 105 Celsius] | Ambient, Size -> Word],
							Expandable -> True
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UploadTransportConditionOptions is called on input samples and conditions. This value is always Null.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"UploadTransportConditionPreview",
			"ValidUploadTransportConditionQ"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "cgullekson", "harrison.gronlund"}
	}
];



(* ::Subsection:: *)
(*UploadTransportConditionPreview*)
DefineUsage[UploadTransportConditionPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadTransportConditionPreview[samples,transportConditions]", "preview"},
				Description -> "returns the preview for UploadTransportCondition when it is called on 'samples' and 'transportConditions'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "samples",
							Description -> "Samples which will have transport conditions uploaded to them.",
							Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
							Expandable -> False
						},
						{
							InputName -> "transportConditions",
							Description -> "Transport Conditions for each sample.",
							Widget -> Widget[Type -> Expression, Pattern :> Chilled | RangeP[27 Celsius, 105 Celsius] | Ambient, Size -> Word],
							Expandable -> True
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of UploadTransportCondition. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"UploadTransportConditionOptions",
			"ValidUploadTransportConditionQ"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "cgullekson", "harrison.gronlund"}
	}
];

(* ::Subsection:: *)
(*ValidUploadTransportConditionQ*)
DefineUsage[ValidUploadTransportConditionQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUploadTransportConditionQ[samples,transportConditions]", "bools"},
				Description -> "checks whether provided 'samples' and 'transportConditions' are valid for calling UploadTransportCondition.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "samples",
							Description -> "Samples which will have transport conditions uploaded to them.",
							Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
							Expandable -> False
						},
						{
							InputName -> "transportConditions",
							Description -> "Transport Conditions for each sample.",
							Widget -> Widget[Type -> Expression, Pattern :> Chilled | RangeP[27 Celsius, 105 Celsius] | Ambient, Size -> Word],
							Expandable -> True
						},
						IndexName -> "Inputs"
					]
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the UploadTransportCondition call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"Upload",
			"UploadTransportConditionOptions",
			"UploadTransportConditionPreview"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "cgullekson", "harrison.gronlund"}
	}
];