(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*UploadMedia*)

(* ::Subsubsection::Closed:: *)
(*UploadMedia*)

DefineUsage[UploadMedia,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadMedia[Components,Solvent,TotalVolume]","MediaModel"},
				Description->"creates a new 'MediaModel' for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Components",
							Description->"A list of samples and amounts to combine before solvent addition, with each addition in the form {Amount, Sample}.",
							Widget->Adder[
								{
									"Amount"->Alternatives[
										"Mass" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0*Milligram],
											Units -> {Gram, {Milligram, Gram, Kilogram}}
										],
										"Volume" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0*Milliliter],
											Units -> {Milliliter,{Microliter, Milliliter, Liter}}
										],
										"Count" -> Widget[
											Type->Number,
											Pattern:>GreaterEqualP[1,1]
										]
									],
									"Sample"-> Widget[
										Type->Object,
										Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
									]
								},
								Orientation->Vertical
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName->"Solvent",
							Description->"The solvent used to bring up the volume to the solution's target volume after all other components have been added.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Sample]}]
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName->"TotalVolume",
							Description->"The total volume of solvent in which the provided components should be dissolved when this media model is prepared.",
							Widget->Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0*Milliliter],
								Units -> {Milliliter,{Microliter, Milliliter, Liter}}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"MediaModel",
						Description->"The newly-created media model.",
						Pattern:>ObjectP[Model[Sample,Media]]
					}
				}
			},
			{
				Definition->{"UploadMedia[Media]","MediaModel"},
				Description->"creates a new 'MediaModel' based on the existing 'Media' template.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Media",
							Description -> "The model of media to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample,Media]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"MediaModel",
						Description->"The newly-created media model.",
						Pattern:>ObjectP[Model[Sample,Media]]
					}
				}
			}
		},
		MoreInformation->{
			"If an existing stock solution model is found that matches all of the parameters specified for the new stock solution model, the existing model is returned in a simplified packet.",
			"However if a Name is explicitly provided, a new stock solution model will ALWAYS be uploaded.",
			"Media models generated with this function may be then prepared via ExperimentMedia.",
			"ExperimentMedia also has an overload that directly calls this function.",
			"Components will be combined in the following order: \n\t1.) All solids are combined first in the provided order\n\t2.) All liquids will be added in the provided order, except for acids and bases\n\t3.) (optional): Fill-to-volume additions will be made to the provided total volume\n\t4.) All liquids that are acids and bases will be added last."
		},
		SeeAlso->{
			"UploadMediaOptions",
			"ValidUploadMediaQ",
			"ExperimentMedia",
			"UploadSampleModel",
			"UploadProduct"
		},
		Author->{"daniel.shlian","eunbin.go"}
	}
]