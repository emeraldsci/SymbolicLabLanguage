(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCOVID19Test*)

DefineUsage[PrepareExperimentRoboticCOVID19Test,
	{
		BasicDefinitions->{
			{
				Definition->{"PrepareExperimentRoboticCOVID19Test[]","protocol"},
				Description->"provides an interface to enqueue a COVID-19 qPCR test on samples separated by operator shift (e.g. day shift)",
				Inputs:>{},
				Outputs:>{
					{
						OutputName->"protocol",
						Description->"The protocol object describing how to run the robotic COVID-19 tests.",
						Pattern:>ObjectP[Object[Protocol,RoboticCOVID19Test]]
					}
				}
			}
		},
		MoreInformation->{
			"In addition to creating a protocol, the function sends an email containing the container IDs of all the samples included in the test to a Human Resources liason."
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentRoboticSamplePreparation",
			"ExperimentRoboticCOVID19Test"
		},
		Author->{"hayley", "mohamad.zandian", "eqian"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCOVID19Test*)


DefineUsage[ExperimentRoboticCOVID19Test,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentRoboticCOVID19Test[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for running robotic coronavirus disease 2019 (COVID-19) tests on the provided 'Samples'.",
				Inputs:>{
						{
							InputName->"Samples",
							Description->"The specimens for testing.",
							Widget->Adder[
								Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{Object[Container]->Field[Contents[[All,2]]]}
								]
							]
						}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the robotic coronavirus disease 2019 (COVID-19) tests.",
						Pattern:>ObjectP[Object[Protocol,RoboticCOVID19Test]]
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentRoboticSamplePreparation",
			"PrepareExperimentRoboticCOVID19Test"
		},
		Author->{"hayley", "mohamad.zandian", "eqian"}
	}
];