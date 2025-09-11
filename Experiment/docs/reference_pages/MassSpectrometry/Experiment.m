DefineUsage[ExperimentMassSpectrometry,
	{
		BasicDefinitions->{
			{

				Definition->{"ExperimentMassSpectrometry[Samples]","Protocol"},
				Description->"generates a 'Protocol' object which can be used to determine the molecular weight of compounds by ionizing them and measuring their mass-to-charge ratio (m/z).",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using mass spectrometry.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
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
						Description->"The protocol objects generated to perform mass spectrometry on the provided samples.",
						Pattern:>ObjectP[Object[Protocol,MassSpectrometry]]
					}
				}
			}
		},
		MoreInformation->{
			"Any requested sample preparation will occur according to the following order: incubate/mix input samples, centrifuge input samples, filter input samples, prepare aliquot samples from the input samples.",
			"The two most commonly used ionization techniques are electrospray ionization (ESI) and matrix-assisted laser-desorption ionization (MALDI). They are so-called \"soft\" ionization methods that transfer charges to the molecules in the sample without causing its fragmentation.",
			"ESI produces ions using an electrospray in which a high voltage is applied to a liquid passing through a capillary tube to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. ESI produces mostly multiply protonated ions and has broad utility for the analysis of very small and large compounds and intact bio-molecules and protein structure.",
			"In MALDI, the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample. In MALDI, most molecules have a single charge, thus interpretation of acquired spectra is facilitated. MALDI is mostly used for characterization of large, thermally labile compounds, and is able to handle higher concentration of salt when compared to ESI, which is a great advantage when analyzing biological samples in situ.",
			"To optimize your mass spectrum in a MALDI experiment:
\tIf the signal intensity is too high, lower the max laser power,
\tIf the signal peak is too wide, adjust the delay time and the grid voltage,
\tIf the signal-to-noise ratio is low, adjust the acceleration voltage and the number of shots.",
			"To optimize your mass spectrum in an ESI experiment:
\tIf the signal intensity is too high, lower the capillary voltage and the injection flow rate, or dilute the samples,
\tIf the sensitivity is too low, adjust the capillary and sample cone voltage and temperature (see table below), or increase injected sample amount,
\tIf the signal-to-noise ratio is low, lower the scan rate and increase the injection flow rate, and inspect your buffer for contaminants that may cause an increased baseline.",
			"ESI source settings should be adjusted according to the flow rate used to infuse the sample into the mass spectrometer to ensure successful spray formation and solvent desolvation. This table provides recommended settings for typical flow rate ranges.",
			Grid[{
				{"Flow Rate [ml/min]","Source Temperature [\[Degree]C]","Desolvation Temperature [\[Degree]C]", "Desolvation Gas Flow [L/h]","Capillary Voltage [kV] (Positive/Negative)"},
				{"0.000-0.020",100,200,600,3.0 / 2.8},
				{"0.021-0.100",120,350,800,2.5},
				{"0.101-0.300",120,450,800,2.0},
				{"0.301-0.500",150,500,1000,1.5},
				{"> 0.500",150,600,1200,1}
			}],
			"The following table provides default mass ranges and their suitable calibrants in ESI measurements.",
			Grid[{
				{"Type of Sample","Ion Mode","Mass Range", "Calibrant"},
				{"Small molecules","Negative & Positive","100-1200 m/z","Sodium Formate ESI Calibrant"},
				{"Peptides", "Negative & Positive", "350-2000 m/z","Sodium Iodide ESI Calibrant"},
				{"Intact proteins, antibodies and nucleic acid oligomers","Positive","500-5000 m/z","Cesium iodide ESI Calibrant"},
				{"Other large molecules","Negative","500-5000 m/z","Sodium Iodide ESI Calibrant"}
			}],
			"For ESI mass spectrometry measurements, the sample has to be inside infusion-compatible containers which fit onto the fluidics deck of the instrument. Before the measurement,the syringe and sample lines are purged with ~500 Microliters of sample, before filling the syringe and infusing the sample directly into the mass spectrometer.
			The MinVolume in the table below refers to the combination of container dead volume (the liquid that can't be reached by the tubings), and the purge volume. The total amount of sample that is used by the experiment is the purge volume plus the volume pulled by the syringe which is approximately RunDuration * InfusionFlowRate, rounded up to increments of 50 Microliters.
			For example, for a run of 1 Minute and a flow rate of 50 Microliter / Minute, 500 Microliter (purge) plus 50 Microliter (injection) will be used from the sample, and the minimum volume of the sample inside the container needs to be 1 Milliliter.",
			Grid[{
				{"Type of Container","Container Model","Min Volume", "Max Volume"},
				{"2mL HPLC vial (high recovery)","Model[Container, Vessel, \"id:jLq9jXvxr6OZ\"]","1 mL","1.5 mL"},
				(* TODO investigate the 4mL glass vial. Consider also adding the 2mL snap cap vials since they fit better *)
				{"30mL Plastic Reservoir Bottle","Model[Container,Vessel,\"id:1ZA60vLx3RB5\"]", "2 mL","30 mL"}
			}]
		},
		SeeAlso->{
			"ValidExperimentMassSpectrometryQ",
			"ExperimentMassSpectrometryOptions",
			"ExperimentHPLC",
			"ExperimentPAGE"

		},
		Author->{"mohamad.zandian", "xu.yi", "weiran.wang", "waltraud.mair", "hayley"}
	}];