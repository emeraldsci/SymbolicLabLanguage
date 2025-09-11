DefineUsage[ExperimentPrepareTransporter,
	{
		BasicDefinitions->{
			{

				Definition->{"ExperimentPrepareTransporter[Samples]","Protocol"},
				Description->"generates a 'Protocol' object which can be used to prepare portable chillers or heaters to transport 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be transported under non-ambient temperature.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container], Object[Item], Model[Container], Model[Item], Model[Sample]}]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol objects generated to prepare portable chillers or heaters.",
						Pattern:>ObjectP[Object[Protocol, PrepareTransporter]]
					}
				}
			}
		},
		SeeAlso->{
			"ProcedureFramework`Private`resolveTransporterPacking"
		},
		Author->{"hanming.yang"}
	}
];