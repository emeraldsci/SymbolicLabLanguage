(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCOVID19Test*)


DefineUsage[ExperimentCOVID19Test,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCOVID19Test[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for running coronavirus disease 2019 (COVID-19) tests on the provided 'Samples'.",
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
						Description->"The protocol object describing how to run the coronavirus disease 2019 (COVID-19) tests.",
						Pattern:>ObjectP[Object[Protocol,COVID19Test]]
					}
				}
			}
		},
		MoreInformation->{
			"Viral RNA is extracted from the specimens, then subjected to one-step reverse transcription quantitative polymerase chain reaction (RT-qPCR) for detecting severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) sequences."
		},
		SeeAlso->{
			"ExperimentqPCR",
			"ExperimentSampleManipulation"
		},
		Author->{"hayley", "mohamad.zandian", "eqian"}
	}
];