(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*CancelTransaction*)


(* ::Subsubsection::Closed:: *)
(*CancelTransaction*)


DefineUsage[CancelTransaction,
{
	BasicDefinitions -> {
		{
			Definition -> {"CancelTransaction[transaction]","transaction"},
			Description -> "cancels 'transaction' if it has not yet advanced to the point where it cannot be canceled.",
			Inputs :> {
				{
					InputName -> "transaction",
					Description -> "The transaction object to be canceled.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]],
						Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "transaction",
					Description -> "The transaction object that has been canceled.",
					Pattern :> ListableP[ObjectP[Object[Transaction]]]
				}
			}
		}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"CancelTransactionOptions",
		"CancelTransactionPreview",
		"ValidCancelTransactionQ",
		"OrderSamples",
		"DropShipSamples"
	},
	Author -> {"ben", "olatunde.olademehin", "juiyun", "steven", "srikant", "cheri"}
}];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionOptions*)


DefineUsage[CancelTransactionOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"CancelTransactionOptions[transaction]","resolvedOptions"},
			Description -> "returns the resolved options for CancelTransaction when it is called on 'transaction'.",
			Inputs :> {
				{
					InputName -> "transaction",
					Description -> "The transaction object to be canceled.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]],
						Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "resolvedOptions",
					Description -> "Resolved options when CancelTransaction is called on the input transaction object.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"CancelTransaction",
		"CancelTransactionPreview",
		"ValidCancelTransactionQ",
		"OrderSamples",
		"DropShipSamples"
	},
	Author -> {"ben", "olatunde.olademehin"}
}];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionPreview*)


DefineUsage[CancelTransactionPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"CancelTransactionPreview[transaction]","preview"},
			Description -> "returns Null, as there is no graphical preview of the output of CancelTransaction.",
			Inputs :> {
				{
					InputName -> "transaction",
					Description -> "The transaction object to be canceled.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]],
						Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "Graphical preview representing the output of CancelTransaction.  This value is always Null.",
					Pattern :> Null
				}
			}
		}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"CancelTransaction",
		"CancelTransactionOptions",
		"ValidCancelTransactionQ",
		"OrderSamples",
		"DropShipSamples"
	},
	Author -> {"ben", "olatunde.olademehin"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidCancelTransactionQ*)


DefineUsage[ValidCancelTransactionQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidCancelTransactionQ[transaction]","bools"},
			Description -> "checks whether the provided 'transaction' and specified options are valid for calling CancelTransaction.",
			Inputs :> {
				{
					InputName -> "transaction",
					Description -> "The transaction object to be canceled.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]],
						Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Transaction]], ObjectTypes -> Types[Object[Transaction]]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "bools",
					Description -> "Whether or not the CancelTransaction call is valid.  Return value can be changed via the OutputFormat option.",
					Pattern :> _EmeraldTestSummary | BooleanP
				}
			}
		}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"CancelTransaction",
		"CancelTransactionOptions",
		"CancelTransactionPreview",
		"OrderSamples",
		"DropShipSamples"
	},
	Author -> {"ben", "olatunde.olademehin"}
}];



(* ::Subsection::Closed:: *)
(*StoreSamples*)


(* ::Subsubsection::Closed:: *)
(*StoreSamples*)


DefineUsage[StoreSamples,
{
	BasicDefinitions -> {
		{
			Definition -> {"StoreSamples[sample,condition]","updatedSamples"},
			Description->"directs the ECL to store 'sample' under the provided 'condition'.",
			Inputs :> {
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Container],Object[Item]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					{
						InputName->"condition",
						Widget->Alternatives[
							Widget[Type->Enumeration,Pattern:>(SampleStorageTypeP|None)],
							Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
						],
						Description->"A genre of storage from which storage condition can be determined.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
				{
					OutputName->"updatedSamples",
					Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
					Description->"Samples updated to reflect the updated storage condition."
				}
			}
		},
		{
			Definition->{"StoreSamples[sample]","updatedSamples"},
			Description->"directs the ECL to store 'sample' based on the DefaultStorageCondition in 'sample''s model.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Container],Object[Item]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
				{
					OutputName->"updatedSamples",
					Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
					Description->"Samples updated to reflect the updated storage condition."
				}
			},
			CommandBuilder->False
		}
	},

	MoreInformation -> {
		"Storing a sample that are currently in use in an experiment will result in it being stored under the new condition at the end of the experiment.",
		"Storing a sample already in storage will trigger a maintenance to move the sample to the appropriate conditions as soon as possible.",
		"Storing a sample with Date specified will create a dedicated maintenance protocol to move the specified items to the target condition at the given time.",
		"Container's storage condition follows its contents' storage condition.",
		"Consult the following table for the default settings specified by each storage type:",
		Grid[
			{
				{"Storage Type","Temperature","ShakingRate","ShakingRadius","CarbonDioxide","Humidity","UVLightIntensity","VisibleLightIntensity"},
				{"AmbientStorage","25 Celsius","Null","Null","Null","Null","Null","Null"},
				{"Refrigerator","4 Celsius","Null","Null","Null","Null","Null","Null"},
				{"Freezer","-20 Celsius","Null","Null","Null","Null","Null","Null"},
				{"DeepFreezer","-80 Celsius","Null","Null","Null","Null","Null","Null"},
				{"CryogenicStorage","-165 Celsius","Null","Null","Null","Null","Null","Null"},
				{"BacterialIncubation","37 Celsius","Null","Null","Null","Null","Null","Null"},
				{"BacterialShakingIncubation","37 Celsius","400 RPM (Plates) / 250 RPM (Flasks)","25mm","Null","Null","Null","Null"},
				{"YeastIncubation","30 Celsius","Null","Null","Null","Null","Null","Null"},
				{"YeastShakingIncubation","30 Celsius","400 RPM (Plates) / 200 RPM (Flasks)","25mm","Null","Null","Null","Null"},
				{"MammalianIncubation","37 Celsius","Null","Null","5%","95%","Null","Null"},
				{"ViralIncubation","37 Celsius","Null","Null","5%","95%","Null","Null"},
				{"AcceleratedTesting","40 Celsius","Null","Null","Null","75%","Null","Null"},
				{"IntermediateTesting","30 Celsius","Null","Null","Null","65%","Null","Null"},
				{"LongTermTesting","25 Celsius","Null","Null","Null","50%","Null","Null"},
				{"UVLightIntensity","25 Celsius","Null","Null","Null","60%","36W/m^2","29klm/m^2"}
			}
		],
		"Specifying options in conjunction with a storage type will override these default settings."
	},
	SeeAlso -> {
		"DiscardSamples",
		"ClearSampleStorageSchedule",
		"ShipToECL",
		"OrderSamples",
		"ShipToUser"
	},
	Author -> {"mohamad.zandian", "axu", "cgullekson", "xiwei.shan", "steven", "juiyun"}
}];



(* ::Subsubsection::Closed:: *)
(*StoreSamplesOptions*)


DefineUsage[StoreSamplesOptions,
	{
		BasicDefinitions -> {
		{
			Definition -> {"StoreSamplesOptions[sample,condition]","resolvedOptions"},
			Description->"returns the resolve options when directing the ECL to store 'sample' under the provided 'condition'.",
			Inputs :> {
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					{
						InputName->"condition",
						Widget->Alternatives[
							Widget[Type->Enumeration,Pattern:>SampleStorageTypeP],
							Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
						],
						Description->"A genre of storage from which storage condition can be determined.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when StoreSamples is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
		{
			Definition->{"StoreSamplesOptions[sample]","resolvedOptions"},
			Description->"returns the resolve options when directing the ECL to store 'sample' based on the DefaultStorageCondition in 'sample''s model.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when StoreSamples is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
		}
	},

		MoreInformation -> {

		},
		SeeAlso -> {
		"DiscardSamples",
		"ShipToECL",
		"OrderSamples",
		"ShipToUser"
	},
		Author -> {"mohamad.zandian", "axu", "cgullekson", "xiwei.shan", "steven", "juiyun"}
	}
];


(* ::Subsubsection::Closed:: *)
(*StoreSamplesPreview*)


DefineUsage[StoreSamplesPreview,
	{
		BasicDefinitions -> {
		{
			Definition -> {"StoreSamplesPreview[sample,condition]","preview"},
			Description->"returns preview when directing the ECL to store 'sample' under the provided 'condition'.",
			Inputs :> {
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					{
						InputName->"condition",
						Widget->Alternatives[
							Widget[Type->Enumeration,Pattern:>SampleStorageTypeP],
							Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
						],
						Description->"A genre of storage from which storage condition can be determined.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of StoreSamples.",
						Pattern :> Null
					}
				}
			},
		{
			Definition->{"StoreSamplesPreview[sample]","preview"},
			Description->"returns preview when directing the ECL to store 'sample' based on the DefaultStorageCondition in 'sample''s model.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of StoreSamples.",
						Pattern :> Null
					}
				}
		}
	},

		MoreInformation -> {

		},
		SeeAlso -> {
			"DiscardSamples",
			"ShipToECL",
			"OrderSamples",
			"ShipToUser"
	},
		Author -> {"mohamad.zandian", "axu", "cgullekson", "xiwei.shan", "steven", "juiyun"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidStoreSamplesQ*)


DefineUsage[ValidStoreSamplesQ,
	{
		BasicDefinitions -> {
		{
			Definition -> {"ValidStoreSamplesQ[sample,condition]","bools"},
			Description->"checks whether the provided 'sample', 'condition' and specified options are valid for calling StoreSamples.",
			Inputs :> {
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					{
						InputName->"condition",
						Widget->Alternatives[
							Widget[Type->Enumeration,Pattern:>SampleStorageTypeP],
							Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
						],
						Description->"A genre of storage from which storage condition can be determined.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the StoreSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			},
		{
			Definition->{"ValidStoreSamplesQ[sample]","resolvedOptions"},
			Description->"checks whether the provided 'sample', and specified options are valid for calling StoreSamples.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"sample",
						Widget->Widget[
							Type->Object,
							Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container]}],
							PreparedSample->False
						],
						Description->"Sample to be stored under the provided condition.",
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the StoreSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
		}
	},

		MoreInformation -> {

		},
		SeeAlso -> {
			"DiscardSamples",
			"ShipToECL",
			"OrderSamples",
			"ShipToUser"
	},
		Author -> {"mohamad.zandian", "axu", "cgullekson", "xiwei.shan", "steven", "juiyun"}
	}
];

(* ::Subsection::Closed:: *)
(*ClearSampleStorageSchedule*)


DefineUsage[ClearSampleStorageSchedule,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ClearSampleStorageSchedule[sample]","updatedSamples"},
				Description->"Erase any entries in 'sample''s StorageSchedule (if possible), and set StorageCondition to the condition reflected by where the sample is currently located.",
				Inputs :> {
					IndexMatching[
						{
							InputName->"sample",
							Widget->Widget[
								Type->Object,
								Pattern:> ObjectP[{Object[Sample],Object[Container],Object[Item]}],
								PreparedSample->False
							],
							Description->"Sample to be cleard of its StorageSchedule.",
							Expandable->False
						},
						IndexName->"main input"
					]
				},
				Outputs :> {
					{
						OutputName->"updatedSamples",
						Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
						Description->"Samples updated to reflect the updated storage condition."
					}
				}
			}
		},

		MoreInformation -> {
			"Handles non-self-standing samples, their containers and the container's all contents simultaneously.",
			"Clears any entries of StorageSchedule except the StorageUpdate protocol that is currently running.",
			"Sets StorageCondition to the ProvidedStorageCondition of the sample's current location by default.",
			"If any StorageSchedule cannot be completely cleared, set the StorageCondition to one indicated in first entry of the StorageSchedule.",
			"Sets AwaitingStorageUpdate to False if no StorageSchedule is empty and there is no scheduled disposal.",
			"Sets AwaitingStorageUpdate to True if StorageSchedule is not empty or StorageSchedule is empty but disposal is scheduled in DisposalLog (also sets AwaitingDisposal to True).",
			"Throw an warning if the sample's status is not Available or Stocked."

		},
		SeeAlso -> {
			"StoreSamples",
			"DiscardSamples",
			"ShipToECL",
			"OrderSamples",
			"ShipToUser"
		},
		Author -> {"lige.tonggu", "gil.sharon", "xiwei.shan"}
	}];

(* ::Subsection::Closed:: *)
(*DiscardSamples*)


(* ::Subsubsection::Closed:: *)
(*DiscardSamples*)


DefineUsage[DiscardSamples,
{
	BasicDefinitions -> {
		{
			Definition->{"DiscardSamples[objects]","updatedObjects"},
			Description->"directs the ECL to permanently dispose of the provided 'objects' along with their containers or contents as appropriate during the next daily maintenance cycle.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "objects",
						Description-> "Samples or Containers to be marked for eventual disposal.",
						Widget-> Widget[Type->Object,Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container], Object[Part]}],PreparedSample->False],
						Expandable->False
					},
					IndexName->"main input"
				]
			},
			Outputs:>{
				{
					OutputName->"updatedObjects",
					Description->"Samples and containers updated to reflect them being marked for discarding.",
					Pattern:>{ObjectP[{Object[Sample],Object[Item],Object[Container], Object[Part]}]..}
				}
			}
		}
	},
	MoreInformation -> {
		"Providing a sample results in both the sample and its container being discarded.",
		"Samples can be un-marked for discarding up until the next daily maintenance cycle, using StoreSamples to reset the samples' storage condition:\n\te.g. StoreSamples[samples,Refrigerator]"
	},
	SeeAlso -> {
		"CancelDiscardSamples",
		"StoreSamples",
		"RestrictSamples",
		"UnrestrictSamples",
		"ShipToECL",
		"OrderSamples"
	},
	Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
}];


(* ::Subsubsection::Closed:: *)
(*DiscardSamplesOptions*)


DefineUsage[DiscardSamplesOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"DiscardSamplesOptions[objects]", "resolvedOptions"},
				Description -> "returns the resolved options for DiscardSamples when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "Samples or Containers to be marked for eventual disposal.",
							Widget-> Widget[Type->Object,Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container], Object[Part]}],PreparedSample->False],
							Expandable->False
						},
						IndexName->"main input"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when DiscardSamples is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to DiscardSamples if it were called on these input objects."
		},
		SeeAlso -> {
			"DiscardSamples",
			"DiscardSamplesPreview",
			"ValidDiscardSamplesQ"
		},
		Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
	}
];


(* ::Subsubsection::Closed:: *)
(*DiscardSamplesPreview*)


DefineUsage[DiscardSamplesPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"DiscardSamplesPreview[objects]", "preview"},
				Description -> "returns the preview for DiscardSamples when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "Samples or Containers to be marked for eventual disposal.",
							Widget-> Widget[Type->Object,Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container], Object[Part]}],PreparedSample->False],
							Expandable->False
						},
						IndexName->"main input"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of DiscardSamples.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"DiscardSamples",
			"DiscardSamplesOptions",
			"ValidDiscardSamplesQ"
		},
		Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidDiscardSamplesQ*)


DefineUsage[ValidDiscardSamplesQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidDiscardSamplesQ[objects]", "bools"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling DiscardSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "Samples or Containers to be marked for eventual disposal.",
							Widget-> Widget[Type->Object,Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container], Object[Part]}],PreparedSample->False],
							Expandable->False
						},
						IndexName->"main input"
					]
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the DiscardSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"DiscardSamples",
			"DiscardSamplesPreview",
			"DiscardSamplesOptions"
		},
		Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
	}
];


(* ::Subsection::Closed:: *)
(*CancelDiscardSamples*)


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamples*)


DefineUsage[CancelDiscardSamples,
{
	BasicDefinitions -> {
		{
			Definition ->{"CancelDiscardSamples[objects]","updatedObjects"},
			Description -> "cancels pending discard requests for 'objects' to ensure they will not be discarded as part of the regular maintenance schedule.",
			Inputs:>{
				{
					InputName -> "objects",
					Description-> "Samples or Containers to be marked for eventual disposal.",
					Widget-> Alternatives[
						Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False],
						Adder[Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False]]
					],
					Expandable->False
				}
			},
			Outputs:>{
				{
					OutputName->"updatedObjects",
					Description->"Samples and containers updated to reflect them being un-marked for discarding.",
					Pattern:>{ObjectP[Object[Sample]]|ObjectP[Object[Container]]..}
				}
			}
		}
	},
	MoreInformation -> {
		"This function cancels the pending disposal request initiated by the function DiscardSamples, provided the samples have not yet been physically discarded as part of regular maintenance schedule.",
		"StoreSamples may also be used to ensure that samples marked for disposal will not be disposed.",
		"This function will have no effect on samples that do not have a pending disposal request."
	},
	SeeAlso -> {
		"DiscardSamples",
		"StoreSamples",
		"RestrictSamples",
		"UnrestrictSamples",
		"ShipToECL",
		"OrderSamples"
	},
	Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
}];


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamplesOptions*)


DefineUsage[CancelDiscardSamplesOptions,
{
	BasicDefinitions -> {
		{
			Definition ->{"CancelDiscardSamplesOptions[objects]","resolvedOptions"},
			Description -> "returns the resolved options for CancelDiscardSamples when it is called on 'objects'.",
			Inputs:>{
				{
					InputName -> "objects",
					Description-> "Samples or Containers to be marked for eventual disposal.",
					Widget-> Alternatives[
						Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False],
						Adder[Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False]]
					],
					Expandable->False
				}
			},
			Outputs :> {
				{
					OutputName -> "resolvedOptions",
					Description -> "Resolved options when CancelDiscardSamples is called on the input objects.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}
	},
	MoreInformation -> {
		"This function returns the resolved options that would be fed to CancelDiscardSamples if it were called on these input objects."
	},
	SeeAlso -> {
		"CancelDiscardSamples",
		"CancelDiscardSamplesPreview",
		"ValidCancelDiscardSamplesQ"
	},
	Author -> {"lige.tonggu", "tim.pierpont", "steven", "hayley", "srikant"}
}];


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamplesPreview*)


DefineUsage[CancelDiscardSamplesPreview,
{
	BasicDefinitions -> {
		{
			Definition ->{"CancelDiscardSamplesPreview[objects]","updatedObjects"},
			Description -> "returns the preview for CancelDiscardSamples when it is called on 'objects'.",
			Inputs:>{
				{
					InputName -> "objects",
					Description-> "Samples or Containers to be marked for eventual disposal.",
					Widget-> Alternatives[
						Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False],
						Adder[Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False]]
					],
					Expandable->False
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "Graphical preview representing the output of CancelDiscardSamples. This value is always Null.",
					Pattern :> Null
				}
			}
		}
	},
	SeeAlso -> {
		"CancelDiscardSamples",
		"CancelDiscardSamplesOptions",
		"ValidCancelDiscardSamplesQ"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "steven", "hayley", "srikant"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidCancelDiscardSamplesQ*)


DefineUsage[ValidCancelDiscardSamplesQ,
{
	BasicDefinitions -> {
		{
			Definition ->{"ValidCancelDiscardSamplesQ[objects]","bools"},
			Description -> "checks whether the provided 'objects' and specified options are valid for calling CancelDiscardSamples.",
			Inputs:>{
				{
					InputName -> "objects",
					Description-> "Samples or Containers to be marked for eventual disposal.",
					Widget-> Alternatives[
						Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False],
						Adder[Widget[Type -> Object, Pattern:> ObjectP[{Object[Sample],Object[Item],Object[Container],Object[Part]}],PreparedSample->False]]
					],
					Expandable->False
				}
			},
			Outputs :> {
				{
					OutputName -> "bools",
					Description -> "Whether or not the CancelDiscardSamples call is valid. Return value can be changed via the OutputFormat option.",
					Pattern :> _EmeraldTestSummary| BooleanP
				}
			}
		}
	},
	SeeAlso -> {
		"CancelDiscardSamples",
		"CancelDiscardSamplesPreview",
		"CancelDiscardSamplesOptions"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "steven", "hayley", "srikant"}
}];


(* ::Subsection::Closed:: *)
(*OrderSamples*)


(* ::Subsubsection::Closed:: *)
(*OrderSamples*)


DefineUsage[OrderSamples,
	{
		BasicDefinitions->{{
			Definition->{"OrderSamples[objects,amounts]","transactions"},
			Description->"generates a new order transaction to purchase the specified quantity of a given object.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "objects",
						Description-> "The objects to be ordered.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Model[Container],Model[Part], Model[Sensor],Model[Item],Model[Plumbing],Model[Wiring],Object[Product]}]
						]
					},
					{
						InputName -> "amounts",
						Description-> "The quantity or amount to be ordered of each object.",
						Widget -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram],
								Units -> {Gram, {Milligram, Gram, Kilogram}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Liter],
								Units -> {Liter, {Microliter, Milliliter, Liter}}
							],
							Widget[
								Type -> Number,
								Pattern :> GreaterP[0,1]
							]
						]
					},
					IndexName -> "Input Block"
				]
			},
			Outputs:>{
				{
					OutputName->"transactions",
					Description->"A transaction object that tracks the initiated order of samples from a supplier.",
					Pattern:>ListableP[ObjectP[Object[Transaction,Order]]]
				}
			}
		}},
		MoreInformation->{
			"Placing an order for a given product or a model sample creates a transaction order to track its status through when the ordered item is received."
		},
		SeeAlso->{
			"CancelTransaction",
			"DropShipSamples"
		},
		Author->{"lige.tonggu", "wyatt", "robert"}
	}
];



(* ::Subsubsection::Closed:: *)
(*OrderSamplesOptions*)


DefineUsage[OrderSamplesOptions,
	{
		BasicDefinitions->{{
			Definition->{"OrderSamplesOptions[objects,amounts]","resolvedOptions"},
			Description->"returns the resolved options for OrderSamples when it is called on 'objects' and 'amounts'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "objects",
						Description-> "The objects to be ordered.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Model[Container],Model[Part], Model[Sensor],Model[Item],Model[Plumbing],Model[Wiring],Object[Product]}]
						]
					},
					{
						InputName -> "amounts",
						Description-> "The quantity or amount to be ordered of each object.",
						Widget -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram],
								Units -> {Gram, {Milligram, Gram, Kilogram}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Liter],
								Units -> {Liter, {Microliter, Milliliter, Liter}}
							],
							Widget[
								Type -> Number,
								Pattern :> GreaterP[0,1]
							]
						]
					},
					IndexName -> "Input Block"
				]
			},
			Outputs:>{
				{
					OutputName -> "resolvedOptions",
					Description -> "Resolved options when OrderSamples is called on the input objects.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}},
		MoreInformation->{
			"This function returns the resolved options that would be fed to OrderSamples if it were called on these input objects."
		},
		SeeAlso->{
			"OrderSamples",
			"ValidOrderSamplesQ",
			"OrderSamplesPreview"
		},
		Author->{"lige.tonggu", "wyatt", "robert", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*OrderSamplesPreview*)


DefineUsage[OrderSamplesPreview,
	{
		BasicDefinitions->{{
			Definition->{"OrderSamplesPreview[objects,amounts]","preview"},
			Description->"returns Null, as there is no graphical preview of the output of OrderSamples.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "objects",
						Description-> "The objects to be ordered.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Model[Container],Model[Part], Model[Sensor],Model[Item],Model[Plumbing],Model[Wiring],Object[Product]}]
						]
					},
					{
						InputName -> "amounts",
						Description-> "The quantity or amount to be ordered of each object.",
						Widget -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram],
								Units -> {Gram, {Milligram, Gram, Kilogram}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Liter],
								Units -> {Liter, {Microliter, Milliliter, Liter}}
							],
							Widget[
								Type -> Number,
								Pattern :> GreaterP[0,1]
							]
						]
					},
					IndexName -> "Input Block"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Graphical preview representing the output of CancelTransaction.  This value is always Null.",
					Pattern :> Null
				}
			}
		}},
		MoreInformation->{},
		SeeAlso->{
			"OrderSamples",
			"ValidOrderSamplesQ",
			"OrderSamplesOptions"
		},
		Author->{"lige.tonggu", "wyatt", "robert", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidOrderSamplesQ*)


DefineUsage[ValidOrderSamplesQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidOrderSamplesQ[samples]", "bools"},
				Description -> "checks whether the provided 'samples' and specified options are valid for calling OrderSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "The objects to be ordered.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Sample],Model[Container],Model[Part], Model[Sensor],Model[Item],Model[Plumbing],Model[Wiring],Object[Product]}]
							]
						},
						{
							InputName -> "amounts",
							Description-> "The quantity or amount to be ordered of each object.",
							Widget -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram],
									Units -> {Gram, {Milligram, Gram, Kilogram}}
								],
								Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Liter],
									Units -> {Liter, {Microliter, Milliliter, Liter}}
								],
								Widget[
									Type -> Number,
									Pattern :> GreaterP[0,1]
								]
							]
						},
						IndexName -> "Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the OrderSamples call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"OrderSamples",
			"OrderSamplesPreview",
			"OrderSamplesOptions"
		},
		Author -> {"lige.tonggu", "wyatt", "robert"}
	}
];



(* ::Subsection::Closed:: *)
(*DropShipSamples*)


(* ::Subsubsection::Closed:: *)
(*DropShipSamples*)


DefineUsage[DropShipSamples,
	{
		BasicDefinitions->{

			{
				Definition->{"DropShipSamples[OrderedItems, OrderNumber]","Transaction"},
				Description->"generates a 'Transaction' to track the user-initiated shipment of 'OrderedItems' from a third party company to ECL.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OrderedItems",
							Description-> "The products or models that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Product],Model[Sample],Model[Item]}],ObjectTypes->{Object[Product],Model[Sample],Model[Item]}],
							Expandable->False
						},
						{
							InputName->"OrderNumber",
							Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples being sent.",
							Widget->Widget[Type->String,Pattern:>_String,Size->Word]
						},
						IndexName->"Model Input Block"
					]
				},
				Outputs:>{
					{
						OutputName->"Transaction",
						Description->"A transaction object that tracks the user-initiated shipment of products from a supplier to ECL.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToECL]]]
					}
				}
			},

			{
				Definition->{"DropShipSamples[Transaction]","UpdatedTransaction"},
				Description->"update 'Transaction' to add shipping information (such as tracking number, shipper, date shipped, and expected delivery date) or amount information (such as mass, volume, concentration, and mass concentration).",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Transaction",
							Description-> "A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.",
							Widget->
								Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,DropShipping]],ObjectTypes->{Object[Transaction,DropShipping]}],
							Expandable->False
						},
						IndexName->"Transaction Input Block"
					]
				},
				Outputs:>{
					{
						OutputName->"UpdatedTransaction",
						Description->"The input transaction with newly added shipping information.",
						Pattern:>ListableP[ObjectP[Object[Transaction,DropShipping]]]
					}
				}
			}
		},
		MoreInformation->{
			"This function is intended to help you ship Products from Object[Company,Supplier]s or Models from Object[Company,Service]s.",
			"All Model input must have the Provider option specified, and Provider must be an Object[Company,Service].",
			"Product input is not required to have the Provider option specified. If it is specified, it must match the supplier of the product."
		},
		SeeAlso->{
			"OrderSamples",
			"ShipToUser",
			"ShipToECL",
			"UploadProduct",
			"UploadSampleModel",
			"UploadCompanyService",
			"UploadCompanySupplier"
		},
		Author->{"daniel.shlian", "tyler.pabst", "steven", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*DropShipSamplesOptions*)


DefineUsage[DropShipSamplesOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"DropShipSamplesOptions[orderedItems, orderNumber]","resolvedOptions"},
				Description->"returns the 'resolvedOptions' to track the user-initiated shipment of one of each 'products' from a third party company to ECL.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "orderedItems",
							Description-> "The products or models that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Product],Model[Sample],Model[Item]}],ObjectTypes->{Object[Product],Model[Sample],Model[Item]}],
							Expandable->False
						},
						{
							InputName->"orderNumber",
							Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->String,Pattern:>_String,Size->Word]
						},
						IndexName->"Model Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when DropShipSamples is called on the input sample(s).",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"DropShipSamplesOptions[transaction]","resolvedOptions"},
				Description->"returns 'resolvedOptions' to add shipping information (such as tracking number, shipper, date shipped, and expected delivery date) or amount information (such as mass, volume, concentration, and mass concentration) to an existing transaction.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "transaction",
							Description-> "The transaction object being modified.",
							Widget->
									Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,DropShipping]],ObjectTypes->{Object[Transaction,DropShipping]}],
							Expandable->False
						},
						IndexName->"Transaction Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when DropShipSamples is called on the input sample(s).",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"DropShipSamples",
			"DropShipSamplesPreview",
			"ValidDropShipSamplesQ",
			"OrderSamples",
			"ShipToECL"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven", "wyatt"}
	}];


(* ::Subsubsection::Closed:: *)
(*DropShipSamplesPreview*)


DefineUsage[DropShipSamplesPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"DropShipSamplesPreview[orderedItems, orderNumber]","preview"},
				Description -> "returns Null, as there is no graphical preview of the output of DropShipSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "orderedItems",
							Description-> "The products or models that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Product],Model[Sample],Model[Item]}],ObjectTypes->{Object[Product],Model[Sample],Model[Item]}],
							Expandable->False
						},
						{
							InputName->"orderNumber",
							Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->String,Pattern:>_String,Size->Word]
						},
						IndexName->"Model Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of DropShipSamples.  This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition->{"DropShipSamplesPreview[transaction]","preview"},
				Description -> "returns Null, as there is no graphical preview of the output of DropShipSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "transaction",
							Description-> "The transaction object being modified.",
							Widget->
								  Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,DropShipping]],ObjectTypes->{Object[Transaction,DropShipping]}],
							Expandable->False
						},
						IndexName->"Transaction Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of DropShipSamples.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
			MoreInformation -> {},
			SeeAlso -> {
				"DropShipSamples",
				"DropShipSamplesOptions",
				"ValidDropShipSamplesQ",
				"OrderSamples",
				"ShipToECL"
			},
			Author -> {"daniel.shlian", "tyler.pabst", "steven", "wyatt"}
		}];


(* ::Subsubsection::Closed:: *)
(*ValidDropShipSamplesQ*)


DefineUsage[ValidDropShipSamplesQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidDropShipSamplesQ[orderedItems, orderNumber]","boolean"},
				Description -> "checks whether the provided inputs and specified options are valid for calling DropShipSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "orderedItems",
							Description-> "The products or models that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Product],Model[Sample],Model[Item]}],ObjectTypes->{Object[Product],Model[Sample],Model[Item]}],
							Expandable->False
						},
						{
							InputName->"orderNumber",
							Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a third party company is shipping to ECL on behalf of the user.",
							Widget->Widget[Type->String,Pattern:>_String,Size->Word]
						},
						IndexName->"Model Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "Whether or not the DropShipSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			},
			{
				Definition->{"ValidDropShipSamplesQ[transaction]","boolean"},
				Description -> "checks whether the provided inputs and specified options are valid for calling DropShipSamples.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "transaction",
							Description-> "The transaction object being modified.",
							Widget->
									Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,DropShipping]],ObjectTypes->{Object[Transaction,DropShipping]}],
							Expandable->False
						},
						IndexName->"Transaction Input Block"
					]
				},
				Outputs :> {
					{
						OutputName -> "boolean",
						Description -> "Whether or not the DropShipSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"DropShipSamples",
			"DropShipSamplesOptions",
			"DropShipSamplesPreview",
			"OrderSamples",
			"ShipToECL"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven", "wyatt"}
	}];


(* ::Subsection::Closed:: *)
(*ShipToUser*)


(* ::Subsubsection::Closed:: *)
(*ShipToUser*)


DefineUsage[ShipToUser,
	{
		BasicDefinitions->{
			{
				Definition->{"ShipToUser[sample]","transaction"},
				Description->"sends a 'sample' from an ECL facility to your work location.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"transaction",
						Description->"The transaction object(s) that tracks the shipping of the samples from ECL to your location.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToUser]]]
					}
				}
			}
		},
		SeeAlso->{
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"lige.tonggu", "clayton.schwarz", "malav.desai", "steven", "wyatt"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ShipToUserOptions*)


DefineUsage[ShipToUserOptions,
	{
		BasicDefinitions->{
			{
				Definition -> {"ShipToUserOptions[sample]","resolvedOptions"},
				Description -> "returns the resolved options for ShipToUser when it is called on 'sample'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"Resolved options when ShipToUser is called on the input sample.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToUser]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipToUserPreview",
			"ValidShipToUserQ",
			"ShipToUser",
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"malav.desai", "waseem.vali", "steven", "wyatt"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ShipToUserPreview*)


DefineUsage[ShipToUserPreview,
	{
		BasicDefinitions->{
			{
				Definition -> {"ShipToUserPreview[sample]","preview"},
				Description -> "returns a graphical preview for ShipToUser when it is called on 'sample'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"Graphical preview of the transaction created when ShipToUser is called on the input sample.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToUser]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipToUserOptions",
			"ValidShipToUserQ",
			"ShipToUser",
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"malav.desai", "waseem.vali", "steven", "wyatt"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidShipToUserQ*)


DefineUsage[ValidShipToUserQ,
	{
		BasicDefinitions->{
			{
				Definition -> {"ValidShipToUserQ[sample]","bools"},
				Description -> "checks whether the provided 'sample' and specified otpions are valid for calling ShipToUser.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"bools",
						Description->"Returns a boolean for whether or not the ShipToUser call is valid. The return format can be specified via the OutputFormat option.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToUser]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipToUserOptions",
			"ShipToUserPreview",
			"ShipToUser",
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"malav.desai", "waseem.vali", "steven", "wyatt"}
	}
];



(* ::Subsection::Closed:: *)
(*ShipBetweenSites*)


(* ::Subsubsection::Closed:: *)
(*ShipBetweenSites*)


DefineUsage[ShipBetweenSites,
	{
		BasicDefinitions->{
			{
				Definition->{"ShipBetweenSites[sample, site]","transaction"},
				Description->"sends a 'sample' from an ECL facility to another ECL 'site'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped between ECL facilities.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item], Model[Sample], Model[Item], Model[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName -> "site",
						Description-> "The destination ECL facility.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container, Site]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"transaction",
						Description->"The transaction object(s) that tracks the shipping of the samples from ECL to another ECL facility.",
						Pattern:>ListableP[ObjectP[Object[Transaction,SiteToSite]]]
					}
				}
			}
		},
		MoreInformation->{
			"ShipBetweenSites is used for resource fulfillment in cases where a non-purchasable or high-cost Sample, Container, or Item is required by a protocol but located at a different site. This allows the customer to seamlessly perform experiments without worrying about the logistics of their sample locations.",
			"ShipBetweenSites can be called as a standalone function, allowing Users to allocate their resources appropriately between sites in anticipation of their material needs.",
			"When called on Model[Item], Model[Container] or Model[Sample], each requested items is given a unique transaction such that it can be fulfilled at the appropriate site.",
			"Object inputs are grouped into the same transaction when they are able to be shipped together, have the same source site, and are being shipped to the same destination.",
			"Sending of Object[Transaction, SiteToSite] is handled by MaintenanceShipping, and receiving at the destination site is performed in MaintenaceReceiveInventory."
		},
		SeeAlso->{
			"OrderSamples",
			"ShipToECL",
			"ShipToUser",
			"DropShipSamples"
		},
		Author->{"alou", "robert", "clayton.schwarz", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ShipBetweenSitesOptions*)


DefineUsage[ShipBetweenSitesOptions,
	{
		BasicDefinitions->{
			{
				Definition -> {"ShipBetweenSitesOptions[sample, site]","resolvedOptions"},
				Description -> "returns the resolved options for ShipBetweenSites when it is called on 'sample'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item], Model[Sample], Model[Item], Model[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName -> "site",
						Description-> "The destination ECL facility.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container, Site]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"Resolved options when ShipBetweenSites is called on the input sample.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipBetweenSites]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipBetweenSitesPreview",
			"ValidShipBetweenSitesQ",
			"ShipBetweenSites",
			"ShipToUser",
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"alou", "robert", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ShipBetweenSitesPreview*)


DefineUsage[ShipBetweenSitesPreview,
	{
		BasicDefinitions->{
			{
				Definition -> {"ShipBetweenSitesPreview[sample, site]","preview"},
				Description -> "returns a graphical preview for ShipBetweenSites when it is called on 'sample'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to the user.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item], Model[Sample], Model[Item], Model[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName -> "site",
						Description-> "The destination ECL facility.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container, Site]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"Graphical preview of the transaction created when ShipBetweenSites is called on the input sample.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipBetweenSites]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipBetweenSitesOptions",
			"ValidShipBetweenSitesQ",
			"ShipBetweenSites",
			"OrderSamples",
			"ShipToECL",
			"ShipToUser",
			"DropShipSamples"
		},
		Author->{"alou", "robert", "steven"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidShipBetweenSitesQ*)


DefineUsage[ValidShipBetweenSitesQ,
	{
		BasicDefinitions->{
			{
				Definition -> {"ValidShipBetweenSitesQ[sample, site]","bools"},
				Description -> "checks whether the provided 'sample' and specified options are valid for calling ShipBetweenSites.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped to a different ECL facility.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item], Model[Item], Model[Container], Model[Sample]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName -> "site",
						Description-> "The destination ECL facility.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Container, Site]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"bools",
						Description->"Returns a boolean for whether or not the ShipBetweenSites call is valid. The return format can be specified via the OutputFormat option.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipBetweenSites]]]
					}
				}
			}
		},
		SeeAlso->{
			"ShipBetweenSitesOptions",
			"ShipBetweenSitesPreview",
			"ShipBetweenSites",
			"OrderSamples",
			"ShipToECL",
			"DropShipSamples"
		},
		Author->{"malav.desai", "waseem.vali", "steven", "wyatt"}
	}
];



(* ::Subsection::Closed:: *)
(*shipFromECL*)


(* ::Subsubsection::Closed:: *)
(*shipFromECL*)


DefineUsage[shipFromECL,
	{
		BasicDefinitions->{
			{
				Definition->{"shipFromECL[sample, site]","transaction"},
				Description->"sends a 'sample' from an ECL facility to a user or ECL facility.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "sample",
							Description-> "The sample(s) being shipped.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Object[Item], Model[Sample], Model[Item], Model[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					],
					{
						InputName -> "parent function",
						Description-> "parent function calling this helper.",
						Widget->Widget[
							Type->Enumeration,
							Pattern:>Alternatives[ShipToUser, ShipBetweenSites]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"transaction",
						Description->"The transaction object(s) that tracks the shipping of the samples from ECL to another site.",
						Pattern:>ListableP[ObjectP[Object[Transaction,ShipToUser]]]
					}
				}
			}
		},
		SeeAlso->{
			"OrderSamples",
			"ShipToECL",
			"ShipToUser",
			"DropShipSamples"
		},
		Author->{"alou", "robert", "clayton.schwarz", "malav.desai", "steven"}
	}
];


(* ::Subsection::Closed:: *)
(*ShipToECL*)


(* ::Subsubsection::Closed:: *)
(*ShipToECL*)


DefineUsage[ShipToECL,
	{
		BasicDefinitions-> {

			{
				Definition -> {"ShipToECL[Model, ContainerLabel]","Transaction"},
				Description -> "send samples and items to ECL. After generating your transaction, you will be able to print ID stickers to label the items and sample containers.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description-> "A model object describing the parameters of the sample or item being shipped to an ECL facility.",
							Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Item],Model[Sample]}],ObjectTypes->Types[{Model[Item],Model[Sample]}]],
							Expandable->True
						},
						{
							InputName -> "ContainerLabel",
							Description-> "The name given to the sample's container or to the item being sent to an ECL facility.",
							Widget-> Widget[Type->String, Pattern :> _String, Size->Line],
							Expandable->True
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Transaction",
						Description-> "A transaction object that tracks the shipping of the samples and items.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}],
						Pattern:>ObjectP[Object[Transaction,ShipToECL]]
					}
				}
			},
			{
				Definition -> {"ShipToECL[Transaction]","UpdatedTransaction"},
				Description -> "update an existing 'Transaction' to add shipping information (such as tracking number, shipper, date shipped, and expected delivery date).",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Transaction",
							Description-> "The transaction object being modified.",
							Widget->Widget[
								Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}
							]
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "UpdatedTransaction",
						Description-> "The input transaction with newly added shipping information.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}],
						Pattern:>ObjectP[Object[Transaction,ShipToECL]]
					}
				}
			}
		},
		MoreInformation->{
			"Samples destined for ECL-2 (Austin, TX) should be addressed as follows:\n\n\tc/o SAMPLES\n\tEmerald Cloud Lab\n\tCustomer Receiving\n\t15404 Long Vista Drive\n\tAustin, TX 78728\n\nThe following phone number may be added for the recipient contact information: 512-226-3002."
		},
		SeeAlso->{
			"ShipToECLOptions",
			"ShipToECLPreview",
			"ValidShipToECLQ",
			"OrderSamples",
			"ShipToUser",
			"DropShipSamples"
		},
		Author->{"malav.desai", "waseem.vali", "steven", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ShipToECLOptions*)


DefineUsage[ShipToECLOptions,
	{
		BasicDefinitions-> {
			{
				Definition -> {"ShipToECLOptions[Model, ContainerLabel]","ResolvedOptions"},
				Description -> "returns the options to send samples and items to ECL, calculating values for any unspecified options as needed.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description-> "A model object describing the parameters of the sample or item being shipped to an ECL facility.",
							Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Item],Model[Sample]}],ObjectTypes->Types[{Model[Item],Model[Sample]}]],
							Expandable->False
						},
						{
							InputName -> "ContainerLabel",
							Description-> "The name given to the sample's container or to the item being sent to an ECL facility.",
							Widget-> Widget[Type->String, Pattern :> _String, Size->Line],
							Expandable->False
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The full set of options used by ShipToECL with default option values calculated.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition -> {"ShipToECLOptions[Transaction]","ResolvedOptions"},
				Description -> "returns the options to update shipping information (such as tracking number, shipper, date shipped, and expected delivery date) for an existing 'Transaction', calculating values for any unspecified options as needed.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Transaction",
							Description-> "The transaction object being modified.",
							Widget->Widget[
								Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}
							]
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The full set of options used by ShipToECL with default option values calculated.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ShipToECL",
			"ShipToECLPreview",
			"ValidShipToECLQ"
		},
		Author -> {"malav.desai", "waseem.vali", "steven", "alou"}
	}];




(* ::Subsubsection::Closed:: *)
(*ShipToECLPreview*)


DefineUsage[ShipToECLPreview,
	{
		BasicDefinitions-> {
			{
				Definition -> {"ShipToECLPreview[Model, ContainerLabel]","Preview"},
				Description -> "returns the preview for ShipToECL when trying to send samples and items to ECL.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description-> "A model object describing the parameters of the sample or item being shipped to an ECL facility.",
							Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Item],Model[Sample]}],ObjectTypes->Types[{Model[Item],Model[Sample]}]],
							Expandable->False
						},
						{
							InputName -> "ContainerLabel",
							Description-> "The name given to the sample's container or to the item being sent to an ECL facility.",
							Widget-> Widget[Type->String, Pattern :> _String, Size->Line],
							Expandable->False
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ShipToECL.  This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ShipToECLPreview[Transaction]","Preview"},
				Description -> "returns the preview for ShipToECL when trying to update shipping information (such as tracking number, shipper, date shipped, and expected delivery date) for an existing 'Transaction'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Transaction",
							Description-> "The transaction object being modified.",
							Widget->Widget[
								Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}
							]
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ShipToECL. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ShipToECL",
			"ShipToECLOptions",
			"ValidShipToECLQ"
		},
		Author -> {"malav.desai", "waseem.vali", "steven", "alou"}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidShipToECLQ*)


DefineUsage[ValidShipToECLQ,
	{
		BasicDefinitions-> {
			{
				Definition -> {"ValidShipToECLQ[Model, ContainerLabel]","Boolean"},
				Description -> "checks whether the provided input and specified options are valid for calling ShipToECL.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Model",
							Description-> "A model object describing the parameters of the sample or item being shipped to an ECL facility.",
							Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Item],Model[Sample]}],ObjectTypes->Types[{Model[Item],Model[Sample]}]],
							Expandable->False
						},
						{
							InputName -> "ContainerLabel",
							Description-> "The name given to the sample's container or to the item being sent to an ECL facility.",
							Widget-> Widget[Type->String, Pattern :> _String, Size->Line],
							Expandable->False
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "An indication of if the transaction can be created.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			},
			{
				Definition -> {"ValidShipToECLQ[Transaction]","Boolean"},
				Description -> "checks whether the provided 'transaction' and specified options are valid for calling ShipToECL.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Transaction",
							Description-> "The transaction object being modified.",
							Widget->Widget[
								Type->Object,Pattern:>ObjectP[Object[Transaction,ShipToECL]],ObjectTypes->{Object[Transaction,ShipToECL]}
							]
						},
						IndexName->"input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "An indication of if the transaction can be updated.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ShipToECL",
			"ShipToECLOptions",
			"ShipToECLPreview"
		},
		Author -> {"malav.desai", "waseem.vali", "steven", "wyatt"}
	}];


(* ::Subsection::Closed:: *)
(*RestrictSamples*)


(* ::Subsubsection::Closed:: *)
(*RestrictSamples*)


DefineUsage[RestrictSamples,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RestrictSamples[samples]", "updatedSamples"},
				Description -> "marks 'samples' as restricted from automatic use in any of your team's experiments that request the 'samples'' models. Samples marked as Restricted can only be used in experiments when specifically provided as input to the experiment functions by a team member.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as restricted from automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "updatedSamples",
						Description -> "Samples now restricted from automatic use in experiments.",
						Pattern :> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]]
					}
				}
			}
		},
		MoreInformation -> {
			"This function's action may be undone using UnrestrictSamples.",
			"Sets the Restricted field to True for the samples."
		},
		SeeAlso -> {
			"UnrestrictSamples",
			"StoreSamples",
			"DiscardSamples",
			"OrderSamples",
			"ShipToUser",
			"ShipToECL"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*RestrictSamplesOptions*)


DefineUsage[RestrictSamplesOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RestrictSamplesOptions[samples]", "resolvedOptions"},
				Description -> "returns the resolved options for RestrictSamples when it is called on 'samples'.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as restricted from automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container],Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when RestrictSamples is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to RestrictSamples if it were called on these input samples."
		},
		SeeAlso -> {
			"RestrictSamples",
			"RestrictSamplesPreview",
			"ValidRestrictSamplesQ"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*RestrictSamplesPreview*)


DefineUsage[RestrictSamplesPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"RestrictSamplesPreview[samples]", "preview"},
				Description -> "returns the graphical preview for RestrictSamples when it is called on 'samples'.  This output is always Null.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as restricted from automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of RestrictSamples.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"RestrictSamples",
			"RestrictSamplesOptions",
			"ValidRestrictSamplesQ"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidRestrictSamplesQ*)


DefineUsage[ValidRestrictSamplesQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidRestrictSamplesQ[samples]", "bools"},
				Description -> "checks whether the provided 'samples' and specified options are valid for calling RestrictSamples.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as restricted from automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container],Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the RestrictSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"RestrictSamples",
			"RestrictSamplesPreview",
			"RestrictSamplesOptions"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsection::Closed:: *)
(*UnrestrictSamples*)


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamples*)


DefineUsage[UnrestrictSamples,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UnrestrictSamples[samples]", "updatedSamples"},
				Description -> "allows 'samples' to be automatically utilized in your team's experiments if the models of the 'samples' are requested.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as available for automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "updatedSamples",
						Description -> "Samples now available for automatic use in experiments.",
						Pattern :> ListableP[ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Item], Object[Sensor], Object[Plumbing], Object[Wiring]}]]
					}
				}
			}
		},
		MoreInformation ->  {
			"This function unsets the Restricted flag in the samples.",
			"Protect samples from automatic use in experiments with RestrictSamples."
		},
		SeeAlso -> {
			"RestrictSamples",
			"StoreSamples",
			"DiscardSamples",
			"OrderSamples",
			"ShipToUser",
			"ShipToECL"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamplesOptions*)


DefineUsage[UnrestrictSamplesOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UnrestrictSamplesOptions[samples]", "resolvedOptions"},
				Description -> "returns the resolved options for UnrestrictSamples when it is called on 'samples'.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as available for automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Resolved options when UnrestrictSamples is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to UnrestrictSamples if it were called on these input samples."
		},
		SeeAlso -> {
			"UnrestrictSamples",
			"UnrestrictSamplesPreview",
			"ValidUnrestrictSamplesQ"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamplesPreview*)


DefineUsage[UnrestrictSamplesPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UnrestrictSamplesPreview[samples]", "preview"},
				Description -> "returns the graphical preview for UnrestrictSamples when it is called on 'samples'.  This output is always Null.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as available for automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of UnrestrictSamples.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"UnrestrictSamples",
			"UnrestrictSamplesOptions",
			"ValidUnrestrictSamplesQ"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUnrestrictSamplesQ*)


DefineUsage[ValidUnrestrictSamplesQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidUnrestrictSamplesQ[samples]", "bools"},
				Description -> "checks whether the provided 'samples' and specified options are valid for calling UnrestrictSamples.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples to be marked as available for automatic use in experiments.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container],Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False],
							Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ObjectTypes -> {Object[Sample], Object[Container], Object[Part], Object[Plumbing], Object[Wiring]},PreparedSample->False]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "bools",
						Description -> "Whether or not the UnrestrictSamples call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"UnrestrictSamples",
			"UnrestrictSamplesPreview",
			"UnrestrictSamplesOptions"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];