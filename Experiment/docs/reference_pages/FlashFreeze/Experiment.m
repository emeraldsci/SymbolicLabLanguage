(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentFlashFreeze*)


(* ::Subsubsection:: *)
(*ExperimentFlashFreeze Usage*)

DefineUsage[ExperimentFlashFreeze,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFlashFreeze[Objects]","Protocol"},
				Description->"generates a 'Protocol' which can flash freeze 'objects' through immersion of sample containers in liquid nitrogen.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Objects",
							Description->"The samples to be flash frozen during the protocol.",
							Widget->Alternatives[
								"Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{Object[Container]->Field[Contents[[All,2]]]}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]},
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
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the flash freeze experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,FlashFreeze]]]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ValidExperimentFlashFreezeQ",
			"ExperimentFlashFreezeOptions",
			"ExperimentFlashFreezePreview",
			"ExperimentDegas",
			"ExperimentIncubate",
			"ExperimentLyophilize",
			"ExperimentEvaporate"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"ryan.bisbey", "axu", "steven", "adam.abushaer"}
	}
];


(* ::Subsubsection:: *)
(*uploadFlashFreezeNotFullyFrozen*)

DefineUsage[uploadFlashFreezeNotFullyFrozen,
	{
		BasicDefinitions->{
			{"uploadFlashFreezeNotFullyFrozen[protocol]","updatedMaintenance","updates the protocol's FullyFrozen field by appending False to it."}
		},
		Input:>{
			{"protocol",ObjectP[Object[Protocol,FlashFreeze]],"The protocol to update."}
		},
		Output:>{
			{"updatedProtocol",ObjectP[Object[Protocol,FlashFreeze]],"The object by this function."}
		},
		SeeAlso->{
			"ExperimentFlashFreeze"
		},
		Author->{"ryan.bisbey", "axu", "steven", "marie.wu"}
	}];

(* ::Subsubsection:: *)
(*uploadFlashFreezeFullyFrozen*)

DefineUsage[uploadFlashFreezeFullyFrozen,
	{
		BasicDefinitions->{
			{"uploadFlashFreezeFullyFrozen[protocol]","updatedMaintenance","updates the protocol's FullyFrozen field by appending True to it."}
		},
		Input:>{
			{"protocol",ObjectP[Object[Protocol,FlashFreeze]],"The protocol to update."}
		},
		Output:>{
			{"updatedProtocol",ObjectP[Object[Protocol,FlashFreeze]],"The object by this function."}
		},
		SeeAlso->{
			"ExperimentFlashFreeze"
		},
		Author->{"ryan.bisbey", "axu", "steven", "marie.wu"}
	}];