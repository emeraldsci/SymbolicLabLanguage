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
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
									ObjectTypes -> {Model[Sample]}
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
		Author->{"hanming.yang", "steven"}
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