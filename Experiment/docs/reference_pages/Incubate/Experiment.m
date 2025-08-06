(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubate*)


DefineUsage[ExperimentIncubate,
{
	BasicDefinitions -> {
		{
			Definition -> {"ExperimentIncubate[Objects]","Protocol"},
			Description -> "creates a 'Protocol' to incubate the provided sample or container 'objects', with optional mixing while incubating.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "Objects",
						Description-> "The samples that should be incubated.",
						Widget->Alternatives[
							"Sample or Container"->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							"Container with Well Position"->{
								"Well Position" -> Alternatives[
									"A1 to P24" -> Widget[
										Type -> Enumeration,
										Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
										PatternTooltip -> "Enumeration must be any well from A1 to H12."
									],
									"Container Position" -> Widget[
										Type -> String,
										Pattern :> LocationPositionP,
										PatternTooltip -> "Any valid container position.",
										Size->Line
									]
								],
								"Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container]}]
								]
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials"
									}
								}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName -> "Protocol",
					Description -> "Protocol generated to incubate the input objects.",
					Pattern :> ListableP[ObjectP[Object[Protocol,Incubate]]]
				}
			}
		}
	},
	MoreInformation -> {
		"Based on the container(s) in the input 'objects', the protocol will automatically choose the optimal mixing and incubation technique.",
		"ExperimentMix simply calls ExperimentIncubate and is provided for the user's convenience. The two functions are the same."
	},
	SeeAlso -> {
		"ExperimentMix",
		"IncubateDevices",
		"MixDevices",
		"ExperimentMeasureVolume",
		"ExperimentCentrifuge",
		"ExperimentEvaporate",
		"ExperimentFilter"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"melanie.reschke", "yanzhe.zhu", "thomas"}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentMix*)


DefineUsage[ExperimentMix,
{
	BasicDefinitions -> {
		{
			Definition -> {"ExperimentMix[Objects]","Protocol"},
			Description -> "creates a 'Protocol' to mix the provided sample or container 'objects', with optional heating with mixing.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "Objects",
						Description-> "The samples that should be mixed.",
						Widget->Alternatives[
							"Sample or Container"->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							"Container with Well Position"->{
								"Well Position" -> Alternatives[
									"A1 to P24" -> Widget[
										Type -> Enumeration,
										Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
										PatternTooltip -> "Enumeration must be any well from A1 to H12."
									],
									"Container Position" -> Widget[
										Type -> String,
										Pattern :> LocationPositionP,
										PatternTooltip -> "Any valid container position.",
										Size->Line
									]
								],
								"Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container]}]
								]
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials"
									}
								}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName -> "Protocol",
					Description -> "Protocol generated to incubate the input objects.",
					Pattern :> ListableP[ObjectP[Object[Protocol,Incubate]]]
				}
			}
		}
	},
	MoreInformation -> {
		"Based on the container(s) in the input 'objects', the protocol will automatically choose the optimal mixing and incubation technique.",
		"ExperimentMix simply calls ExperimentIncubate and is provided for the user's convienence. The two functions are the same."
	},
	SeeAlso -> {
		"ExperimentIncubate",
		"IncubateDevices",
		"MixDevices",
		"ExperimentMeasureVolume",
		"ExperimentCentrifuge",
		"ExperimentEvaporate",
		"ExperimentFilter"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"tyler.pabst", "Yahya.Benslimane", "steven", "josh.kenchel", "thomas"}
}];

(* ::Subsubsection::Closed:: *)
(*MixDevices*)


DefineUsage[MixDevices,
{
	BasicDefinitions -> {
		{
			Definition -> {"MixDevices[Samples]","mixDevices"},
			Description -> "returns 'mixDevices' that can be used to mix 'Samples'.",
			Inputs :> {
				{
					InputName -> "Samples",
					Description-> "The sample that should be mixed.",
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Sample]]
					],
					Expandable->False
				}
			},
			Outputs:>{
				{
					OutputName -> "mixDevices",
					Description -> "The devices that can be used to mix 'mySample'.",
					Pattern :> {ObjectP[Model[Instrument]..]}
				}
			}
		},
		{
			Definition -> {"MixDevices[ContainerModel, SampleVolume]","mixDevices"},
			Description -> "returns 'mixDevices' that can be used to mix 'myContainerModel'.",
			Inputs :> {
				{
					InputName -> "ContainerModel",
					Description-> "The container model that will contain samples to be mixed.",
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Sample]]
					],
					Expandable->False
				},
				{
					InputName -> "SampleVolume",
					Description-> "The volume of the sample that will be contained in 'myContainerModel'.",
					Widget->Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Liter],
						Units->Alternatives[Microliter, Milliliter, Liter]
					],
					Expandable->False
				}
			},
			Outputs:>{
				{
					OutputName -> "mixDevices",
					Description -> "The devices that can be used to mix 'mySample'.",
					Pattern :> {ObjectP[Model[Instrument]..]}
				}
			}
		}
	},
	SeeAlso -> {
		"ExperimentIncubate",
		"IncubateDevices",
		"ExperimentCentrifuge",
		"ExperimentEvaporate",
		"ExperimentFilter"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"tyler.pabst", "Yahya.Benslimane", "steven", "josh.kenchel", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*IncubateDevices*)


DefineUsage[IncubateDevices,
{
	BasicDefinitions -> {
		{
			Definition -> {"IncubateDevices[Samples]","incubateDevices"},
			Description -> "returns 'incubateDevices' that can be used to mix 'mySample'.",
			Inputs :> {
				{
					InputName -> "mySample",
					Description-> "The sample that should be incubated.",
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Sample]]
					],
					Expandable->False
				}
			},
			Outputs:>{
				{
					OutputName -> "incubateDevices",
					Description -> "The devices that can be used to incubate 'mySample'.",
					Pattern :> {ObjectP[Model[Instrument]..]}
				}
			}
		}
	},
	SeeAlso -> {
		"ExperimentIncubate",
		"MixDevices",
		"ExperimentCentrifuge",
		"ExperimentEvaporate",
		"ExperimentFilter"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"melanie.reschke", "yanzhe.zhu", "thomas"}
}];

(* ::Subsubsection::Closed:: *)
(*EngineFunctions*)

DefineUsage[uploadInvertFullyDissolved,
	{
		BasicDefinitions -> {
			{"uploadInvertFullyDissolved[protocol]", "protocol", "appends a True to the InvertFullyDissolved field."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"This function is used at the end of a multiple choice question that asks the operator if the sample is fully dissolved."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "hanming.yang", "thomas"}
	}
];

DefineUsage[uploadSwirlFullyDissolved,
	{
		BasicDefinitions -> {
			{"uploadSwirlFullyDissolved[protocol]", "protocol", "appends a True to the SwirlFullyDissolved field."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"This function is used at the end of a multiple choice question that asks the operator if the sample is fully dissolved."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "hanming.yang", "thomas"}
	}
];

DefineUsage[uploadThawStartTime,
	{
		BasicDefinitions -> {
			{"uploadThawStartTime[protocol]", "protocol", "sets ThawStartTime to Now."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"The ThawStartTime field is used to track when the current thawing started in order to know if we've hit our MaxThawTime when doing our thawing check in task."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "hanming.yang", "thomas"}
	}
];

DefineUsage[uploadCurrentStartDate,
	{
		BasicDefinitions -> {
			{"uploadCurrentStartDate[protocol]", "protocol", "sets CurrentStartDate to Now."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"The CurrentStartDate field is used to track when the current mixing batch started in order to know if we've hit our MaxTime when doing our mix until dissolved check in task."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "hanming.yang", "thomas"}
	}
];

DefineUsage[uploadTemporaryMixUntilDissolvedFalse,
	{
		BasicDefinitions -> {
			{"uploadTemporaryMixUntilDissolvedFalse[protocol]", "protocol", "appends False to the TemporaryMixUntilDissolved field."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"tyler.pabst", "Yahya.Benslimane", "steven", "josh.kenchel", "thomas"}
	}
];

DefineUsage[uploadCurrentMixUntilDissolved,
	{
		BasicDefinitions -> {
			{"uploadCurrentMixUntilDissolved[protocol]", "protocol", "copies over the TemporaryMixUntilDissolved field into the CurrentMixUntilDissolved field."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"The CurrentMixUntilDissolved field is used to know when to stop mixing the batch if the batch is specified as MixUntilDissolved.",
			"CurrentMixUntilDissolved and TemporaryMixUntilDissolved are Developer fields.",
			"These two fields are indexed to the current incubation batches that are running. False means that the batch is fully dissolved and don't continue mixing, True means that the batch is not fully dissolved and we keep mixing."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"tyler.pabst", "Yahya.Benslimane", "steven", "josh.kenchel", "thomas"}
	}
];

DefineUsage[uploadPipetteFullyDissolvedFalse,
	{
		BasicDefinitions -> {
			{"uploadPipetteFullyDissolvedFalse[protocol]", "protocol", "appends False to the PipetteFullyDissolved field."}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"Note that pipette, swirl, and invert shaking don't use the common mix until dissolved logic since they happen in serial and never happen in parallel.",
			"This is because these mix methods are human intensive so there's no way to parallelize them."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "waseem.vali", "malav.desai", "thomas"}
	}
];

DefineUsage[clearPipetteFullyDissolved,
	{
		BasicDefinitions -> {
			{"clearPipetteFullyDissolved[protocol]", "protocol", "clears out the PipetteFullyDissolved field:"}
		},
		Input :> {
			{"protocol", ObjectP[Object[Protocol, Incubate]], "The protocol to upload to."}
		},
		Output :> {
			{"protocol", ObjectP, "The changed protocol."}
		},
		MoreInformation -> {
			"Note that pipette, swirl, and invert shaking don't use the common mix until dissolved logic since they happen in serial and never happen in parallel.",
			"This is because these mix methods are human intensive so there's no way to parallelize them."
		},
		SeeAlso -> {
			"ExperimentIncubate"
		},
		Author -> {"taylor.hochuli", "waseem.vali", "malav.desai", "thomas"}
	}
];
(* ::Subsubsection::Closed:: *)
(*TransportDevices*)


DefineUsage[TransportDevices,
	{
		BasicDefinitions -> {
			{
				Definition -> {"TransportDevices[Sample]","transportDevice"},
				Description -> "returns 'transportDevice' that can be used to transport 'Samples'.",
				Inputs :> {
					{
						InputName -> "Sample",
						Description-> "The sample that should be transported.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName -> "transportDevice",
						Description -> "The devices that can be used to transport 'Sample'.",
						Pattern :> ObjectP[{Model[Instrument]|Model[Sample]}]
					}
				}
			},
			{
				Definition -> {"TransportDevices[Sample, TransportCondition]","transportDevices"},
				Description -> "returns 'transportDevices' that can be used to transport 'Sample'.",
				Inputs :> {
					{
						InputName -> "Sample",
						Description-> "The Sample that will need to be transported.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
						],
						Expandable->False
					},
					{
						InputName->"TransportCondition",
						Description->"The condition under which Sample must be transported.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[TransportCondition]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName -> "transportDevice",
						Description -> "The devices that can be used to transport 'Sample'.",
						Pattern :> ObjectP[{Model[Instrument]|Model[Container]}]
					}
				}
			}
		},
		SeeAlso -> {
			"IncubateDevices",
			"MixDevices"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "waseem.vali", "malav.desai", "steven"}
	}];