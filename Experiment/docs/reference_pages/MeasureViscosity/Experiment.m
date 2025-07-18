(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureViscosity*)


DefineUsage[ExperimentMeasureViscosity,
	{
		BasicDefinitions->{
			{
				Definition -> {"ExperimentMeasureViscosity[Samples]","Protocol"},
				Description -> "generates a 'Protocol' for measuring the viscosity of the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample(s) for which viscosity measurements should be taken.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object or packet that will be used to measure the viscosity of the provided 'Sample'.",
						Pattern :> ListableP[ObjectP[Object[Protocol, MeasureViscosity]]]
					}
				}
			}
		},
		MoreInformation->{ (*This information may change depending on the configuration of the new viscometer*)
					"The viscometer can measure the dynamic (absolute) viscosity for samples.",
 					"The instrument can hold a maximum of 40 autosampler vials and 1 96-well plate per run.",
					"The viscometer uses a microfluidic rectangular slit to measure the pressure drop as the sample flows across the measurement channel. The pressure drop, along with the sample flow rate and channel dimensions, are used to calculate the sample viscosity.",
					"Three chips are available for measuring (1) low-medium viscosity samples, (2) high viscosity samples, and (3) measuring viscosities at high shear rates",
					"InjectionVolumes (volume of sample that is transferred into the injection syringe) can be either 26 (autosampler vials only), 35, 50, or 90 uL. The minimum InjectionVolume for samples in a 96-well plate is 35 uL.",
					"It is recommended to have at least 5-10 uL of sample additional in your sample container to account for pipetting dead volumes during autosampler handling on the viscometer.",
					"Since viscosity is temperature-dependent, the MeasurementTemperature should be specified for all measuruments.",
					"For samples that are Non-Newtonian, it is recommended to measure viscosity at multiple flow rates (shear rates).",
					"Samples may be optionally recouped after measurement. The recovery amount range is between 40 and 70% of the injected volume, depending on sample viscosity.",
					"For samples with unknown viscosity, it is recommended to run an Exploratory measurement method. The instrument will ramp up FlowRate and use the pressure drop reading to determine the appropriate measurement parameters to take a viscosity reading and repeat the reading 10 times."
		},
		SeeAlso->{
			"ValidExperimentMeasureViscosityQ",
			"ExperimentMeasureViscosityOptions",
			"ExperimentMeasureViscosityPreview",
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureDensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"daniel.shlian", "andrey.shur", "lei.tian", "jihan.kim", "axu", "stacey.lee"}
	}
];