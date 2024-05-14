DefineUsage[ExperimentICPMS,
	{
		BasicDefinitions->{
			{

				Definition->{"ExperimentICPMS[Samples]","Protocol"},
				Description->"generates a 'Protocol' object which can be used to determine the atomic composition of 'Samples' by ionizing them into monoatomic ions via inductively coupled plasma (ICP) and measuring their mass-to-charge ratio (m/z).",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be ionized and analyzed using ICP-MS, which can be predigested or digested as part of the experiment.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol objects generated to perform ICP-MS on the provided samples.",
						Pattern:>ObjectP[Object[Protocol,ICPMS]]
					}
				}
			}
		},
		SeeAlso->{
			"ValidExperimentICPMSQ",
			"ExperimentICPMSOptions",
			"ExperimentMassSpectrometry",
			"ExperimentMicrowaveDigestion",
			"ICPMSDefaultIsotopes"

		},
		Author->{"hanming.yang","steven"}
	}];

DefineUsage[ICPMSDefaultIsotopes,
	{
		BasicDefinitions -> {
			{"ICPMSDefaultIsotopes[Elements]", "Isotopes", "returns all 'Isotopes' of the given 'Elements' that will be measured by ICP-MS experiment."}
		},
		MoreInformation -> {

		},
		Input :> {
			{"Elements", ICPMSElementP, "Elements of interest to be measured by ICP-MS."}
		},
		Output :> {
			{"Isotopes", ICPMSNucleusP, "A list of isotopes that will be measured by ICP-MS given the specified elements input."}
		},
		SeeAlso -> {"ExperimentICPMS", "ElementData"},
		Author -> {"hanming.yang"}
	}
];

