(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Options*)


DefineOptions[ExperimentDialysis,
	Options:>{
		{
			OptionName->DialysisMethod,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>DialysisMethodP
			],
			Description->"The type of dialysis method that should be used to separate the sample. In DynamicDialysis fresh Dialysate continuously flows across the sample and in StaticDialysis the Dialysate is stagnant. In EquilibiumDialysis, the dialsyate is retained and is used for the study of the binding of small molecules and ions by proteins.",
			ResolutionDescription->"Automatically set to StaticDialysis if the sample volume is less than 30 Milliliter and DynamicDialysis otherwise.",
			Category->"General"
		}, 
		{
			OptionName->Instrument,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Instrument,Dialyzer],
				Object[Instrument,Dialyzer],
				Model[Instrument,Vortex],
				Object[Instrument,Vortex],
				Model[Instrument,OverheadStirrer],
				Object[Instrument,OverheadStirrer],
				Model[Instrument, HeatBlock],
				Object[Instrument, HeatBlock]
			}]],
			Description->"The instrument that should be used to perform the dialysis.",
			ResolutionDescription->"Automatically set to an instrument appropriate for the DialysisMethod, DialysateContainer and DialysateTemperature (Model[Instrument,Dialyzer] for Dynamic Dialysis, Model[Instrument, HeatBlock] for dialysis with no mixing, Model[Instrument,Vortex] with a MaxTemperature and MinTemperature appropriate for the DialysateTemperature for EquilibriumDialysis, Model[Instrument,OverheadStirrer] for StaticDialysis)",
			Category->"General"
		},
		(* Options for dialysis by dynamic dialysis *)
		{
			OptionName->DynamicDialysisMethod,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Recirculation,SinglePass]
			],
			Category->"General",
			Description->"The mode the Instrument will be set up.",
			ResolutionDescription->"Automatically set to a SinglePass if the FlowRate multiplied by DialysisTime is greater than the DialysateVolume or Recirculation if the dialysis Method is Dynamic and Null otherwise."
		},
		{
			OptionName->FlowRate,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,
				Pattern :> RangeP[5 Milliliter/Minute, 184 Milliliter/Minute],
				Units->{Milliliter/Minute,{Milliliter/Minute}}
			],
			Category->"Equilibration",
			Description->"The average rate in which the Dialysate will be flowed across the sample, as controlled by a peristaltic pump during Dynamic Dialysis.",
			ResolutionDescription->"Automatically set to a flow rate appropriate for the DialysateVolume and DialysateTime if these options are given and the DynamicDialysisMethod is SinglePass, 25 Milliliter/Minute for all other cases of DynamicDialysis and Null otherwise."
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SampleVolume,
				Default -> Automatic,
				Description -> "The volume taken from each input sample and transferred into the DialysisMembrane.",
				ResolutionDescription -> "Is automatically set to All or the maximum recommended volume of the DialysisMembrane.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[10 Microliter, 130 Milliliter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			},
			{
				OptionName->DialysisMembrane,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container,Plate,Dialysis],Object[Container,Plate,Dialysis],
					Model[Container,Vessel,Dialysis],Object[Container,Vessel,Dialysis],
					Model[Item,DialysisMembrane]
				}]],
				Description->"The dialysis membrane that should be used to remove impurities from the sample.",
				ResolutionDescription->"Automatically set to a dialysis membrane appropriate for the DialysisMethod (Model[Item,DialysisMembrane] for DynamicDialysis, Model[Container,Vessel,Dialysis] or Model[Item,DialysisMembrane] for StaticDialysis, Model[Container,Plate,Dialysis] for EquilibriumDialysis) and the specified MolecularWeightCutoff and SampleVolume.",
				Category->"General"
			},
			{
				OptionName->MolecularWeightCutoff,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>DialysisMolecularWeightCutoffP],
				Description->"The molecular weight cutoff of the DialysisMembrane; all particles larger than this should be kept during dialysis.",
				ResolutionDescription->"Automatically set the MolecularWeightCutoff of DialysisMembrane.",
				Category->"General"
			},
			(*Membrane prep fields*)
			{
				OptionName->DialysisMembraneSoak,
				Default->Automatic,
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the DialysisMembrane should be soaked to remove the membrane's preservation solution.",
				ResolutionDescription->"Automatically set to True if the manufacturer of the DialysisMembrane recommends soaking.",
				Category->"Membrane Preparation"
			},
			{
				OptionName->DialysisMembraneSoakSolution,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{
						Model[Sample],Object[Sample]
					}]
				],
				Description->"The liquid the DialysisMembrane will soak in to remove the membrane's preservation solution.",
				ResolutionDescription->"Automatically set to the solution recommended by the manufacturer of the DialysisMembrane if DialysisMembraneSoak is True and Null otherwise.",
				Category->"Membrane Preparation"
			},
			{
				OptionName->DialysisMembraneSoakVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[0 Milliliter,2 Liter],
					Units->{Milliliter,{Milliliter, Liter}}
				],
				Description->"The volume of DialysisMembraneSoakSolution the DialysisMembrane will soak in to remove the membrane's preservation solution.",
				ResolutionDescription->"Automatically set to the volume of solution recommended by the manufacturer of the DialysisMembrane if DialysisMembraneSoak is True and Null otherwise.",
				Category->"Membrane Preparation"
			},
			{
				OptionName->DialysisMembraneSoakTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[0 Minute,2Hour],
					Units->{Second,{Second,Minute, Hour}}
				],
				Description->"The amount of time the DialysisMembrane should be soaked to remove the membrane's preservation solution.",
				ResolutionDescription->"Automatically set to the time recommended by the manufacturer of the DialysisMembrane if DialysisMembraneSoak is True and Null otherwise.",
				Category->"Membrane Preparation"
			}
		],
		{
			OptionName -> ShareDialysateContainer,
			Default -> Automatic,
			Description -> "Indicates if the samples should use the same DialysateContainer if possible. If set to true, multiple samples will use the same Dialysate.",
			ResolutionDescription -> "Automatically set to a True if DialysisMethod is StaticDialysis and Null otherwise.",
			AllowNull->False,
			Category -> "Equilibration",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> NumberOfDialysisRounds,
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1, 5, 1]
			],
			Description->"The amount of times the sample will dialyzed in fresh Dialysate. For example, if set to 3, the Dialysate will be changed twice during the experiment.",
			ResolutionDescription->"Automatically set to 3 for StaticDialysis and 1 EquilibriumDialysis and SinglePass DynamicDialysis.",
			Category->"Equilibration"
		},
		(*Imaging Options*)
		(*TODO:add in after it is possible*)
		{
			OptionName->ImageSystem,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the a dialysis set up should imaged before and after equilibration.",
			ResolutionDescription->"Automatically set to False if the DialysisMethod is DynamicDialysis and Null otherwise.",
			Category->"Equilibration"
		},
		(*{
			OptionName->ImagingInterval,
			Default->Automatic,
			AllowNull->True,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,18Hour],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The amount of time for between each image of the system.",
			ResolutionDescription->"Automatically set to a 1 hour if ImageSystem is True and Null otherwise."
		},
		*)
		{
			OptionName->DialysisTime,
			Default->Automatic,
			AllowNull->False,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The minimum duration of time for which the samples will be dialysed.",
			ResolutionDescription->"Automatically set to 2Hour for StaticDialysis, 4Hour for EquilibriumDialysis, 8Hour for Recirculating Dynamic Dialysis and 9Liter divided by the FlowRate for SinglePass DynamicDialysis."
		},
		{
			OptionName->SecondaryDialysisTime,
			Default->Automatic, 
			AllowNull->True,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The minimum duration of time for which the samples will be dialysed after the Dialysate is replaced with SecondaryDialysate.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than two, 16 hours if the NumberOfDialysisRounds is two and 2 hours otherwise."
		},
		{
			OptionName->TertiaryDialysisTime,
			Default->Automatic,
			AllowNull->True,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The minimum duration of time for which the samples will be dialysed after the Dialysate is replaced with TertiaryDialysate.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than three, 16 hours if the NumberOfDialysisRounds is three and 2 hours otherwise."
		},
		{
			OptionName->QuaternaryDialysisTime,
			Default->Automatic,
			AllowNull->True,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The minimum duration of time for which the samples will be dialysed after the Dialysate is replaced with QuaternaryDialysate.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than four, 16 hours if the NumberOfDialysisRounds is four and 2 hours otherwise."
		},
		{
			OptionName->QuinaryDialysisTime,
			Default->Automatic,
			AllowNull->True,
			Widget-> Widget[Type->Quantity,
				Pattern :> RangeP[0 Minute,$MaxExperimentTime],
				Units->{Second,{Second,Minute, Hour}}
			],
			Category->"Equilibration",
			Description->"The minimum duration of time for which the samples will be dialysed after the Dialysate is replaced with QuinaryDialysate.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than five and 16 hours if the NumberOfDialysisRounds otherwise."
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->Dialysate,
				Default->Model[Sample,"Milli-Q water"],
				AllowNull->False,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],Object[Sample]
				}]],
				Description->"The buffer the DialysisMembrane is put into to for small molecules to diffuse into.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryDialysate,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],Object[Sample]
				}]
				],
				Description->"The dialysis buffer the Dialysate is replaced with for the second round of dialysis.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than two and the Dialysate otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryDialysate,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],Object[Sample]
				}]
				],
				Description->"The dialysis buffer the SecondaryDialysate is replaced with for the third round of dialysis.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than three and the Dialysate otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryDialysate,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],Object[Sample]
				}]
				],
				Description->"The dialysis buffer the TertiaryDialysate is replaced with for the fourth round of dialysis.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than four and the Dialysate otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuinaryDialysate,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],Object[Sample]
				}]
				],
				Description->"The dialysis buffer the QuaternaryDialysate is replaced with for the fifth round of dialysis.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than five and the Dialysate otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->DialysateVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[300 Microliter,10 Liter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The volume of the Dialysate the DialysisMembrane is put into.",
				ResolutionDescription->"Automatically set a 10 liters if the DialysisMethod is DynamicDialysis, the SampleVolume*100 for StaticDialysis and the SampleVolume + 250 Microliters for EquilibriumDialysis.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryDialysateVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[300 Microliter,10 Liter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The volume of the SecondaryDialysate used by this experiment.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than two and the DialysateVolume or the recommended volume of the SecondaryDialysateContainer otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryDialysateVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[300 Microliter,10 Liter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The volume of the TertiaryDialysate used by this experiment.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than three and the DialysateVolume or the recommended volume of the TertiaryDialysateContainer otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryDialysateVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[300 Microliter,10 Liter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The volume of the QuaternaryDialysate used by this experiment.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than four and the DialysateVolume or the recommended volume of the QuaternaryDialysateContainer otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuinaryDialysateVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,
					Pattern :> RangeP[300 Microliter,10 Liter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The volume of the QuinaryDialysate used by this experiment.",
				ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than five and the DialysateVolume or the recommended volume of the QuinaryDialysateContainer otherwise.",
				Category->"Equilibration"
			}
		],
		{
			OptionName->DialysateTemperature,
			Default->Ambient,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 60 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
			Category->"Equilibration",
			Description->"The temperature at which the Dialysis system will be heated or cooled to during dialysis."
		},
		{
			OptionName->SecondaryDialysateTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 60 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
			Category->"Equilibration",
			Description->"The temperature at which the Dialysis system will be heated or cooled to during the second round of dialysis.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than two and the DialysateTemperature otherwise."
		},
		{
			OptionName->TertiaryDialysateTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 60 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
			Category->"Equilibration",
			Description->"The temperature at which the Dialysis system will be heated or cooled to during the third round of dialysis.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than three and the DialysateTemperature otherwise."
		},
		{
			OptionName->QuaternaryDialysateTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 60 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
			Category->"Equilibration",
			Description->"The temperature at which the Dialysis system will be heated or cooled to during the fourth round of dialysis.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than four and the DialysateTemperature otherwise."
		},
		{
			OptionName->QuinaryDialysateTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius, 60 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
			Category->"Equilibration",
			Description->"The temperature at which the Dialysis system will be heated or cooled to during the fifth round of dialysis.",
			ResolutionDescription->"Automatically set to Null if the NumberOfDialysisRounds is less than five and the DialysateTemperature otherwise."
		},
		{
			OptionName -> DialysisMixType,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Stir|Vortex],
			Description -> "The type rotation the mixing instrument should use to mix the Dialysate.",
			ResolutionDescription -> "Automatically set to resolves to Stir for StaticDialysis, Vortex for EquilibriumDialysis and Null for Dynamic dialysis methods.",
			Category->"Equilibration"
		},
		{
			OptionName -> DialysisMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
			Description -> "Frequency of rotation the mixing instrument should use to mix the Dialysate.",
			ResolutionDescription -> "Automatically set to 250RPM of the MixType is Stir, 500RPM if the MixType is Vortex and Null otherwise.",
			Category->"Equilibration"
		},
		{
			OptionName -> SecondaryDialysisMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
			Description -> "Frequency of rotation the mixing instrument should use to mix the SecondaryDialysate.",
			ResolutionDescription -> "Automatically set to Null if the NumberOfDialysisRounds is less than two and the DialysisMixRate otherwise.",
			Category->"Equilibration"
		},
		{
			OptionName -> TertiaryDialysisMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
			Description -> "Frequency of rotation the mixing instrument should use to mix the TertiaryDialysate.",
			ResolutionDescription -> "Automatically set to Null if the NumberOfDialysisRounds is less than three and the DialysisMixRate otherwise.",
			Category->"Equilibration"
		},
		{
			OptionName -> QuaternaryDialysisMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
			Description -> "Frequency of rotation the mixing instrument should use to mix the QuaternaryDialysate.",
			ResolutionDescription -> "Automatically set to Null if the NumberOfDialysisRounds is less than four and the DialysisMixRate otherwise.",
			Category->"Equilibration"
		},
		{
			OptionName -> QuinaryDialysisMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinMixRate, $MaxMixRate], Units->RPM],
			Description -> "Frequency of rotation the mixing instrument should use to mix the QuinaryDialysate.",
			ResolutionDescription -> "Automatically set to Null if the NumberOfDialysisRounds is less than five and the DialysisMixRate otherwise.",
			Category->"Equilibration"
		},
		{
			OptionName->DialysateContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Vessel],
				Object[Container,Vessel]
			}]],
			Description->"The container that should be used to hold the Dialysate and sample when using Static dialysis.",
			ResolutionDescription->"Automatically set to a beaker capable of holding the DialysateVolume and Null is the DialysisMethod is not StaticDialysis.",
			Category->"Equilibration"
		},
		{
			OptionName->SecondaryDialysateContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Vessel],
				Object[Container,Vessel]
			}]],
			Description->"The dialysis container that should be used to hold the SecondaryDialysate and sample when using Static dialysis.",
			ResolutionDescription->"Automatically set to the DialysateContainer or a container capable of holding the volume of SecondaryDialysate being used.",
			Category->"Equilibration"
		},
		{
			OptionName->TertiaryDialysateContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Vessel],
				Object[Container,Vessel]
			}]],
			Description->"The dialysis container that should be used to hold the TertiaryDialysate and sample when using Static dialysis.",
			ResolutionDescription->"Automatically set to the DialysateContainer or a container capable of holding the volume of TertiaryDialysate being used.",
			Category->"Equilibration"
		},
		{
			OptionName->QuaternaryDialysateContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Vessel],
				Object[Container,Vessel]
			}]],
			Description->"The dialysis container that should be used to hold the QuaternaryDialysate and sample when using Static dialysis.",
			ResolutionDescription->"Automatically set to the DialysateContainer or a container capable of holding the volume of QuaternaryDialysate being used.",
			Category->"Equilibration"
		},
		{
			OptionName->QuinaryDialysateContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Container,Vessel],
				Object[Container,Vessel]
			}]],
			Description->"The dialysis container that should be used to hold the QuinaryDialysate and sample when using Static dialysis.",
			ResolutionDescription->"Automatically set to the DialysateContainer or a container capable of holding the volume of QuinaryDialysate being used.",
			Category->"Equilibration"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->DialysateSampling,
				Default->Automatic,
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a sampling volume should be removed from the dialysate after the first round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True for EquilibriumDialysis or if any of the dialysate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryDialysateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a sampling volume should be removed from the dialysate after the second round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the secondary dialysate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryDialysateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a sampling volume should be removed from the dialysate after the third round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the tertiary dialysate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryDialysateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a sampling volume should be removed from the dialysate after the fouth round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the quaternary dialysate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuinaryDialysateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a sampling volume should be removed from the dialysate after the fifth round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the quinary dialysate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->DialysateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 2 Liter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of Dialysate that should be stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set as All for Equilibrium Dialysis or 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if DialysateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryDialysateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 2 Liter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of SecondaryDialysate that should stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if SecondaryDialysateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryDialysateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 2 Liter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of TertiaryDialysate that should stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if TertiaryDialysateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryDialysateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 2 Liter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of QuaternaryDialysate that should stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if QuaternaryDialysateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuinaryDialysateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 2 Liter],
						Units -> {Milliliter,{Microliter,Milliliter, Liter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description->"The amount of QuinaryDialysate that should stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if QuinaryDialysateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->DialysateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP
				],
				Description->"The non-default conditions under which the DialysateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryDialysateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the SecondaryDialysateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryDialysateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the TertiaryDialysateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryDialysateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the QuaternaryDialysateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->QuinaryDialysateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the QuinaryDialysateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->DialysateContainerOut,
				Default->Automatic,
				Description->"The container the DialysateSamplingVolume should be transferred into by the end of the experiment.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the DialysateSamplingVolume of the sample if the DialysateSamplingVolume is not Null, Model[Container, Plate, \"96-well 1mL Deep Well Plate\"] for equilibrium dialysis and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->SecondaryDialysateContainerOut,
				Default->Automatic,
				Description->"The container the SecondaryDialysateSamplingVolume should be transferred into by the end of the experiment.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the SecondaryDialysateSamplingVolume of the sample if the SecondaryDialysateSamplingVolume is not Null and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->TertiaryDialysateContainerOut,
				Default->Automatic,
				Description->"The container the TertiaryDialysateSamplingVolume should be transferred into by the end of the experiment.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the TertiaryDialysateSamplingVolume of the sample if the TertiaryDialysateSamplingVolume is not Null and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->QuaternaryDialysateContainerOut,
				Default->Automatic,
				Description->"The desired container QuaternaryDialysateSamplingVolume should be transferred into by the end of the experiment.",
				ResolutionDescription ->"Automatically set as the PreferredContainer for the QuaternaryDialysateSamplingVolume of the sample if the QuaternaryDialysateSamplingVolume is not Null and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->QuinaryDialysateContainerOut,
				Default->Automatic,
				Description->"The container the QuinaryDialysateSamplingVolume should be transferred into by the end of the experiment.",
				ResolutionDescription ->"Automatically set to Null if the NumberOfDialysisRounds is less than five and the QuinaryDialysateContainerOut or the PreferredContainer for the QuinaryDialysateSamplingVolume otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->RetentateSampling,
				Default->Automatic,
				AllowNull->False,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the a sampling volume should be removed from the sample after the first round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the retentate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryRetentateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the a sampling volume should be removed from the sample after the second round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the secondary retentate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryRetentateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the a sampling volume should be removed from the sample after the third round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the tertiary retentate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryRetentateSampling,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the a sampling volume should be removed from the sample after the fourth round of dialysis to be used for further analysis.",
				ResolutionDescription -> "Automatically set as True if any of the quaternary retentate sampling options are set and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->RetentateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 120 Milliliter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The amount of sample that should be removed from the sample after the first round of dialysis.",
				ResolutionDescription -> "Automatically set as 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if RetentateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->SecondaryRetentateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 120 Milliliter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The amount of sample that should be removed from the sample after the second round of dialysis.",
				ResolutionDescription -> "Automatically set as 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if SecondaryRetentateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryRetentateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 120 Milliliter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The amount of sample that should be removed from the sample after the third round of dialysis.",
				ResolutionDescription -> "Automatically set as 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if TertiaryRetentateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryRetentateSamplingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 120 Milliliter],
					Units -> {Milliliter,{Microliter,Milliliter, Liter}}
				],
				Description->"The amount of sample that should be removed from the sample after the fourth round of dialysis.",
				ResolutionDescription -> "Automatically set as 1 percent of the sample up to 1 Milliliter and down to 1 Microliter if QuaternaryRetentateSampling is True and Null otherwise.",
				Category->"Equilibration"
			},
			{
				OptionName->RetentateSamplingContainerOut,
				Default->Automatic,
				Description->"The desired container the RetentateSamplingVolume should be transferred into after the first round of dialysis.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the RetentateSamplingVolume of the sample if RetentateSampling is True and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->SecondaryRetentateSamplingContainerOut,
				Default->Automatic,
				Description->"The desired container the SecondaryRetentateSamplingVolume should be transferred into after the second round of dialysis.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the SecondaryRetentateSamplingVolume of the sample if SecondaryRetentateSampling is True and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->TertiaryRetentateSamplingContainerOut,
				Default->Automatic,
				Description->"The desired container the TertiaryRetentateSamplingVolume should be transferred into after the third round of dialysis.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the TertiaryRetentateSamplingVolume of the sample if TertiaryRetentateSampling is True and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
			{
				OptionName->QuaternaryRetentateSamplingContainerOut,
				Default->Automatic,
				Description->"The desired container the QuaternaryRetentateSamplingVolume should be transferred into after the fourth round of dialysis.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the QuaternaryRetentateSamplingVolume of the sample if QuaternaryRetentateSampling is True and Null otherwise.",
				AllowNull->True,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			},
		   {
			   	OptionName->RetentateSamplingStorageCondition,
			   	Default->Null,
			   AllowNull->True,
			   Widget->Widget[
				   Type -> Enumeration,
				   Pattern :> SampleStorageTypeP|Disposal
			   ],
			   Description->"The non-default conditions for which the RetentateSamplingVolume should be stored after the protocol is completed.",
			   Category->"Equilibration"
		   },
			{
				OptionName->SecondaryRetentateSamplingStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the SecondaryRetentateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->TertiaryRetentateSamplingStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the TertiaryRetentateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->QuaternaryRetentateSamplingStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the QuaternaryRetentateSamplingVolume should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->RetentateStorageCondition,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description->"The non-default conditions for which the sample should be stored after the protocol is completed.",
				Category->"Equilibration"
			},
			{
				OptionName->RetentateContainerOut,
				Default->Automatic,
				Description->"The container the sample should be transferred into by the end of the experiment.",
				ResolutionDescription -> "Automatically set to the PreferredContainer for the SampleVolume and Model[Container, Plate, \"96-well 1mL Deep Well Plate\"] for equilibrium dialysis.",
				AllowNull->False,
				Category->"Equilibration",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container]
				}]]
			}
		],
		AnalyticalNumberOfReplicatesOption,
		NonBiologyFuntopiaSharedOptionsPooled,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SimulationOption,
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True,
					ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]."
				}
			}
		]
	}
];

(*Errors*)
(*Conflicting Options*)
Error::ConflictingStaticDialysisOptions="The Dialysis Method is `1`, however the options, `2`, are only applicable to StaticDialysis. Please set these options to automatic or change the DialysisMethod to StaticDialysis.";
Error::ConflictingDynamicDialysisOptions="The Dialysis Method is `1`, however the options, `2`, are only applicable to DynamicDialysis. Please set these options to automatic or change the DialysisMethod to DynamicDialysis.";
Error::DialysisMethodInstrumentMismatch="The Instrument, `1`, is not appropriate for the DialysisMethod, `2`. Please pick a different Instrument";
Error::DialysateTemperatureInstrumentMismatch="The Instrument, `1`, cannot be control the temperature of the dialysate to `2`. Please pick a different Instrument or DialysateTemperature";
Error::SampleVolumeDialysisMembraneMismatch="The SampleVolume, `1`, cannot fit inside the DialysisMembrane `2`. Please choose a different SampleVolume or DialysisMembrane.";
Error::LargeDialysisSampleVolume="Is the SampleVolume `1` is larger than what can fit in the largest DialysisMembrane which is 130ml. Please input the sample multiple times with SampleVolumes lower than 130ml to split the sample into multiple dialysis membranes.";
(*Error  ConflictingImageSystem="Is the ImageSystem is `1` and the imaging option, ImagingInterval is `1`. Please set ImagingInterval if and only if ImageSystem to True.";
Error ConflictingImageSystem="The system can only be imaged when the DialysisMethod is DynamicDialysis. Please set ImageSystem to False.";*)
Error::IncompatibleDialysisMembraneTemperature="The DialysateTemperature, `1`, is not between the MinTemperature, `2`, and MaxTemperature, `3`, of the DialysisMembrane, `4`. Please change the DialysateTemperature or the DialysisMembrane.";
Error::DialysateContainerVolume="The DialysateVolume `1` plus the SampleVolume is not between the MinVolume, `2`, and MaxVolume, `3`, of the DialysisContainer `4`. Please change the DialysateVolume or the DialysateContainer.";
Error::DialysisMixTypeInstrumentMismatch="The Instrument, `1`, cannot support the DialysisMixType `2`. Please pick a different Instrument or DialysisMixType";
Error::DialysisMixRateInstrumentMismatch="The Instrument, `1`, cannot support the DialysisMixRate `2`. Please pick a different Instrument or DialysisMixRate between `3` and `4`.";
Error::ConflictingDialysateSamplingVolume="The DialysateSamplingVolume `1` is more than the DialysateVolume, `2`. Please choose a smaller DialysateSamplingVolume.";
Error::ConflictingRetentateSamplingVolume="The sampling volumes, `1` are `2`, and are larger than the SampleVolume, `3`. Please choose a smaller retentate sampleVolume.";
Error::ConflictingRetentateContainerOutPlate="The RetentateContainerOut `1` must be a Model[Container,Vessel] for when transferring out of a dialysis tubing. Please choose a vessel to use as RetentateContainerOut.";
Error::ConflictingRetentateSamplingContainerOutPlate="The RetentateSamplingContainerOut  must be a Model[Container,Vessel] for when transferring out of a dialysis tubing. Please choose a vessel to use as RetentateContainerOut.";
Error::ConflictingDialysateContainerOut="The maximum volume `1` of the DialysateContainerOut `2` is less than the DialysateSamplingVolume `3` Please choose a larger DialysateContainerOut.";
Error::ConflictingRetentateContainerOut="The maximum volume `1` of the RetentateContainerOut `2` is less than the RetentateSamplingVolume `3` Please choose a larger RetentateContainerOut.";
Error::RetentateSamplingMismatch="The retentate sampling,`1`, is `2` and the retentate sampling  options `3` are `4`. Please set these options if and only if retentate sampling is True.";
Error::DialysateSamplingMismatch="The dialysate sampling,`1`, is `2` and the dialysate sampling  options `3` are `4`. Please set these options if and only if dialysate sampling is True.";
Error::NumberOfDialysisRoundsMismatch="The NumberOfDialysisRounds is `1` however the dialysis options for rounds going beyond this number `2` are set. Please set these options to automatic or increase the NumberOfDialysisRounds.";
Error::DialysisMembraneMWCOMismatch="The MolecularWeightCutoff, `1`, does not match the MoleccularWeightCutoff, `2`, of the DialysisMembrane, `3`.";
Error::DialysisMembraneSoakMismatch="DialysisMembraneSoak is set to `1`, however the options for the dialysis membrane soak, `2`, are set to `3`. Please set these options if and only if DialysisMembraneSoak to True.";
Error::ConflictingDialysateContainerMixType="The DialysateContainer `1` cannot be used with the DialysisMixType `2`. Please choose a beaker as a container or set DialysisMixType to Null.";
Error::ConflictingDialysisMethodMixType="The DialysisMixType, `1`, is not supported with the DialysisMethod, `2`. Please choose another DialysisMixType.";
Error::ConflictingNullStaticDialysisOptions="The Dialysis Method is `1`, however the DialysateContainer is  `2`. Please set the DialysateContainer or change the DialysisMethod.";
Error::ConflictingNullDynamicDialysisOptions="The Dialysis Method is `1`, however the dynamic dialysis options, `2`, are set to Null. Please set these options or change the DialysisMethod.";
Error::NumberOfDialysisRoundsNullMismatch="The NumberOfDialysisRounds is `1` however the dialysis options for rounds `2` are Null. Please set these options or decrease the NumberOfDialysisRounds.";
Error::NumberOfDialysisRoundsEquilibriumMismatch="The NumberOfDialysisRounds is `1` however the DialysisMethod is EquilibriumDialysis. Please set these NumberOfDialysisRounds to 1.";
Error::InsufficientDialysateVolume="Due to the dead volume of the dynamic dialysis tank, the dialysate volume must be at least 1.7 Liters.";
(*)Error  DialysisSampleVolumeMismatch="The SampleVolume, `1`, is larger than the volume of the sample `2`.";*)
Error::LargeStaticDialysisSampleVolume="Is the SampleVolume `1` is larger than what can fit in the largest DialysisMembrane for Static dialysis, which is 30ml. Please either input the sample multiple times with SampleVolumes lower than 30ml to split the sample into multiple dialysis membranes or use DynamicDialysis.";
Error::ConfictingEquilibriumDialysateVolume="Is the DialysateVolume `1` is fit in the largest DialysisMembrane for Equilibrium dialysis, which is 750ul. Please use a smaller DialysateVolume.";
Error::DialysisInstrumentMismatch="The Instrument, `1`, is not compatible with dialysis experiments. Please pick a different Instrument.";
Warning::InsufficientStaticDialysateVolume="In order for the stir bar to move unimpeded, we recomemnd a dialysate volume of at least 1 Liter.";
Error::DialysisTooManySamples=" `1` input samples were provided as input, but only `2` can be processed in a single protocol. Please consider splitting into several protocols.";



(*Errors from resolving options*)
Error::UnachievableDialysisFlowRate="With a DynamicDialysisMethod of `1`, at the flow rate, `4`, the DialysateVolume, `3`, will run out before the end of the DialysisTime, `2`,. Please choose a lower DialysisTime or set the DynamicDialysisMethod to Recirculating.";
Error::NoAvailableDialysisMembrane="There are no available dialysis membranes with a molecular weight cut off of `1` that accept a volume of `2` for samples `3`.";
(*)Warning ConflictingDialysisMixType="The dialysis membranes `1` cannot be used with the same mix type. Please choose dialysis membranes with the same form factor if you want the dialysate to by mixed.";*)
Error::UnresolvableDialysisInstrument="There are no instruments that can support the DialysisMethod, `1`, the DialysisMixType, `2`, the DialysisTemperature, `3` and DialysisMixRate `4`. Please select a different DialysateTemerature or DialysisMixRate.";
Error::UnresolvableDialysateContainer="There are no beakers that can support the DialysateVolume, `1` Please select a different DialysateVolume.";


(* ::Subsubsection::Closed:: *)
(*ExperimentDialysis Experiment function*)
(* Overload for mixed input like {s1,{s2,s3}} -> We assume the first sample is going to be inside a pool and turn this into {{s1},{s2,s3}} *)
(*This overload also converts container inputs into sample inputs and expands options such that index matching is preserved.*)
ExperimentDialysis[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[Object[Sample]],ObjectP[Model[Sample]],ObjectP[Object[Container]],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedInputs,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,sampleCache,
		containerToSampleTests,samples,sampleOptions,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedCache,listedSamples,containers,preListedInputs,updatedSimulation,containerToSampleSimulation},

	{preListedInputs, listedOptions}={ToList[mySemiPooledInputs], ToList[myOptions]};

	(* Wrap a list around any single sample inputs except single plate objects to convert flat input into a nested list *)
	(* Leave any non-list plate objects as single inputs because wrapping list around a single plate object signals pooling of all samples in plate.
	In the case that a user wants to run every sample in a plate independently, the plate object is supplied as a single input.*)
	listedInputs=Map[
		If[
			Not[MatchQ[#, ObjectP[Object[Container,Plate]]]],
			ToList[#],#
		]&,
		preListedInputs
	];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation and check if MissingDefineNames, InvalidInput, InvalidOption error messages are thrown.
	If none of these messages are thrown, returns mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache*)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDialysis,
			listedInputs,
			listedOptions,
			DefaultPreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given MissingDefineNames, InvalidInput, InvalidOption error messages, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* For each group, map containerToSampleOptions over each sample or simulated sample group to get the object samples from the contents of the container *)
	(* ignoring the options, since we will use the ones from from ExpandIndexMatchedInputs *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=pooledContainerToSampleOptions[
			ExperimentDialysis,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::EmptyContainers. *)
		{
			Check[
				{containerToSampleOutput,containerToSampleSimulation}=pooledContainerToSampleOptions[
					ExperimentDialysis,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output->{Result, Simulation},
					Simulation -> updatedSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],
			{}
		}
	];

	(* If we were given an empty container,return early. *)
	If[ContainsAny[containerToSampleResult,{$Failed}],

		(* if containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions *)
		(* this way we'll end up index matching each grouping to an option *)
		ExperimentDialysisCore[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
ExperimentDialysisCore[mySamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDialysis]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOps, safeOpsTests, validLengths,
		safeOptionsNamed, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,
		validLengthTests, templatedOptions, templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol,
		cache, expandedSafeOps, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, objectContainerFields,
		collapsedResolvedOptions, resourcePackets, resourcePacketTests, floatingRacksObjects,
		allPackets, specifiedAliquotContainerObjects, optionsWithObjects,
		allObjects, messages, validSamplePreparationResult, mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		objectSamplePacketFields, modelSamplePacketFields, modelContainerFields,
		modelContainerObjects, instrumentObjects, modelInstrumentObjects, modelSampleObjects, sampleObjects, cacheBall,
		modelMembraneItemObjects, membraneItemObjects, containerObjects, possibleMembranes, possibleInstruments,
		possibleDialysisContainers,cacheOption, possibleStirBars,stirBarObjects, protocolObject, possibleFloatingRacks,
		possibleDialysisClips,listedSamples,updatedSimulation
	},

	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption = ToList[Lookup[listedOptions,Cache,{}]];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDialysis,
			listedSamples,
			ToList[listedOptions]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentDialysis, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentDialysis, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentDialysis, {mySamplesWithPreparedSamples},safeOps,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentDialysis,{mySamplesWithPreparedSamples},safeOps],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentDialysis, {mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentDialysis, {mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last@ExpandIndexMatchedInputs[ExperimentDialysis,{mySamplesWithPreparedSamples},inheritedOptions];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	
	(* Any options whose values could be an object *)
	optionsWithObjects = {
		DialysisMembrane,
		Instrument,
		Dialysate,
		SecondaryDialysate,
		TertiaryDialysate,
		QuaternaryDialysate,
		QuinaryDialysate,
		DialysisMembraneSoakSolution,
		DialysateContainer,
		SecondaryDialysateContainer,
		TertiaryDialysateContainer,
		QuaternaryDialysateContainer,
		QuinaryDialysateContainer,
		DialysateContainerOut,
		SecondaryDialysateContainerOut,
		TertiaryDialysateContainerOut,
		QuaternaryDialysateContainerOut,
		QuinaryDialysateContainerOut,
		RetentateSamplingContainerOut,
		SecondaryRetentateSamplingContainerOut,
		TertiaryRetentateSamplingContainerOut,
		QuaternaryRetentateSamplingContainerOut
	};

	(* all possible membranes the resolver might run into *)
	possibleMembranes=Search[
		{Model[Item,DialysisMembrane],Model[Container,Vessel,Dialysis],Model[Container,Plate,Dialysis]},
		Deprecated!=True
	];

	(* all possible instruments the resolver might run into *)
	possibleInstruments=Search[
			{Model[Instrument,Dialyzer], Model[Instrument,OverheadStirrer],Model[Instrument,HeatBlock],Model[Instrument, Vortex]},
			Deprecated!=True
		];

	(* all possible stir bars the resolver might run into *)
	possibleStirBars=Search[
		Model[Part,StirBar],
		Deprecated != True
	];

	(* all possible dialysis clips the resource function might run into *)
	possibleDialysisClips=Search[
		Model[Part,DialysisClip],
		Deprecated != True&&
		Magnetic != True
	];

	(* all possible dialysis containers the resolver might run into *)
	possibleDialysisContainers={Model[Container, Vessel, "id:BYDOjv1VAA8m"],Model[Container, Vessel, "id:R8e1PjRDbbOv"],Model[Container, Vessel, "id:O81aEB4kJJJo"],Model[Container, Vessel, "id:wqW9BP4Y0009"]};(*Search[
			Model[Container, Vessel],
			InternalBottomShape == FlatBottom &&
			Deprecated != True &&
			Aperture > 79 Millimeter &&
			TaperGroundJointSize == Null &&
			NeckType == Null &&
			SelfStanding == True &&
			InternalConicalDepth == Null &&
			HandPumpRequired != True &&
			Dropper != True &&
			Ampoule != True &&
			Hermetic != True &&
			CrossSectionalShape == Circle &&
			ProductsContained == {} &&
			Reusable == True,
			SubTypes -> False
	];*)

	(* all possible floating racks the resource packets might run into *)
	possibleFloatingRacks=Search[
		Model[Container,FloatingRack],
		Deprecated != True
	];

	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				possibleMembranes,
				possibleInstruments,
				possibleDialysisContainers,
				possibleStirBars,
				possibleFloatingRacks,
				possibleDialysisClips,
				(* Default objects *)
				{
					(* potential dialysate *)
					Model[Sample,"Milli-Q water"]
				},
				(* All options that could have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		],
		Object,
		Date->Now
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=Join[SamplePreparationCacheFields[Object[Container]], {VacuumCentrifugeCompatibility}];
	modelContainerFields=Join[SamplePreparationCacheFields[Model[Container]], {VacuumCentrifugeCompatibility}];

	(*separate the objects to download specific fields*)
	containerObjects= Cases[allObjects,ObjectP[Object[Container]]];
	modelContainerObjects= Cases[allObjects,ObjectP[Model[Container]]];
	instrumentObjects = Cases[allObjects,ObjectP[Object[Instrument]]];
	modelInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument]]];
	modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
	sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];
	membraneItemObjects=Cases[allObjects,ObjectP[Object[Item,DialysisMembrane]]];
	modelMembraneItemObjects=Cases[allObjects,ObjectP[Model[Item,DialysisMembrane]]];
	stirBarObjects=Cases[allObjects,ObjectP[Model[Part,StirBar]]];
	floatingRacksObjects=Cases[allObjects,ObjectP[Model[Container,FloatingRack]]];

	(* make the up front Download call *)
	allPackets=Quiet[Download[
		{
			sampleObjects,
			modelSampleObjects,
			instrumentObjects,
			modelInstrumentObjects,
			modelContainerObjects,
			containerObjects,
			membraneItemObjects,
			modelMembraneItemObjects,
			stirBarObjects,
			floatingRacksObjects,
			possibleDialysisClips,
			possibleDialysisContainers
		},
		{
			{
				objectSamplePacketFields,
				modelSamplePacketFields,
				Packet[Container[Model][modelContainerFields]]
			},
			{
				Packet[Object,Name,IncompatibleMaterials,Deprecated, Composition]
			},
			(*Instruments*)
			{
				Packet[Object,Name,Status,Model,DeveloperObject],
				Packet[Model[{Object,Name,Objects,WettedMaterials,MinTemperature, MaxTemperature,MinRotationRate,MaxRotationRate,MinStirBarRotationRate,MaxStirBarRotationRate,Positions,CompatibleImpellers,InternalDimensions, StirBarControl}]]
			},
			{
				Packet[Object,Name,Objects,WettedMaterials,MinTemperature, MaxTemperature,MinRotationRate,MaxRotationRate,MinStirBarRotationRate,MaxStirBarRotationRate,Positions,CompatibleImpellers,InternalDimensions, StirBarControl, Deprecated,Sterile,AspectRatio,NumberOfWells,Footprint,
					OpenContainer,Positions]
			},
			(*Containers*)
			{
				Packet[Object,MinVolume,MaxVolume,MolecularWeightCutoff,MembraneMaterial,PreSoak,RecommendedSoakTime,RecommendedSoakSolution,
					MinTemperature, MaxTemperature, MinpH, MaxpH, RecommendedSoakVolume, KitProducts, VacuumCentrifugeCompatibility, Dimensions,
					Name,Deprecated,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,
					OpenContainer,Positions],
				Packet[KitProducts[KitComponents]]
			},
			{
				Packet[Object,Name,Status,Model],
				Packet[Model[{Object,Name,MolecularWeightCutoff,MembraneMaterial,PreSoak,RecommendedSoakTime,RecommendedSoakSolution,
					MinTemperature, MaxTemperature, MinpH, MaxpH, RecommendedSoakVolume, MinVolume,MaxVolume, KitProducts, VacuumCentrifugeCompatibility, Dimensions,
					Deprecated,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,
					OpenContainer,Positions}]],
				Packet[Model[KitProducts[KitComponents]]]
			},
			{
				Packet[Object,Name,Status,Model],
				Packet[Model[{Object,Name,MolecularWeightCutoff,MembraneMaterial,PreSoak,RecommendedSoakTime,RecommendedSoakSolution,
					FlatWidth,VolumePerLength, MinTemperature, MaxTemperature, MinpH, MaxpH, MolecularWeightCutoff,KitProducts, Dimensions}]]
			},
			{
				Packet[Object,Name,Status,MolecularWeightCutoff,MembraneMaterial,PreSoak,RecommendedSoakTime,RecommendedSoakSolution,
					FlatWidth,VolumePerLength, MinTemperature, MaxTemperature, MinpH, MaxpH, MolecularWeightCutoff,KitProducts, Dimensions]
			},
			{
				Packet[Object,StirBarLength]
			},
			{
				Packet[Object,SlotDiameter,SlotShape,RackThickness,NumberOfSlots]
			},
			{
				Packet[Object,MaxWidth,LengthOffset,MembraneTypes,Weighted,Hanging]
			},
			{
				Packet[Object,Type,InternalBottomShape, Deprecated, Aperture, SelfStanding, CrossSectionalShape, Reusable,Dimensions]
			}
		},
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], Download::FieldDoesntExist];

	(* combine all the Download information together  *)
	cacheBall = FlattenCachePackets[{cache, allPackets}];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentDialysisOptions[mySamplesWithPreparedSamples, expandedSafeOps, Output -> {Result, Tests}, Cache -> cacheBall, Simulation -> updatedSimulation],
			{resolveExperimentDialysisOptions[mySamplesWithPreparedSamples, expandedSafeOps, Output -> Result, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentDialysis,
		resolvedOptions,
		Ignore->ToList[myOptionsWithPreparedSamples],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentDialysis,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		dialysisResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{dialysisResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentDialysis,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Upload -> upload,
			ParentProtocol -> parentProtocol,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage -> Object[Protocol, Dialysis],
			Cache->cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentDialysis,collapsedResolvedOptions],
		Preview -> Null
	}
];

(* ::Subsubsection::Closed:: *)
(*resolveExperimentDialysisOptions*)


(* ========== resolveExperimentDialysisOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)
(* the inputs are the sample packet, the model packet, and the input options (safeOptions) *)

DefineOptions[
	resolveExperimentDialysisOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveExperimentDialysisOptions[mySamples : ListableP[{ObjectP[Object[Sample]]...}], myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentDialysisOptions]] := Module[
	{outputSpecification, output, flatSampleList, gatherTests, messages, inheritedCache, samplePrepOptions, dialysisOptions,
		simulatedSamples, resolvedSamplePrepOptions, simulatedCache, samplePrepTests, flatSimulatedSamples,
		poolingLengths, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		instrument, compatibleMaterialsBool, compatibleMaterialsTests,
		compatibleMaterialsInvalidOption, allDownloadValues, samplePackets, containerPackets, sampleModelPackets,
		fastTrack, modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest,
		numberOfReplicates, name, parentProtocol,
		 roundedDialysisOptions, precisionTests, validNameQ, nameInvalidOptions, validNameTest,
		mapThreadFriendlyOptions, resolvedAliquotOptions, aliquotTests, invalidOptions, invalidInputs, allTests, confirm, canaryBranch,
		template, cache, operator, upload, outputOption, samplePreparation,
		email, resolvedPostProcessingOptions, resolvedOptions, testsRule, resultRule, specifiedAliquotContainerObjects,
		sampleDownloadValues, aliquotContainerPackets, numReplicatesNoNull, simulatedSamplesWithNumReplicates,
		imageSystem, volumeMeasurementInterval, dialysate, dialysateTemperature, allMembraneModelPackets,
		retentateSampling, secondaryDialysateSamplingVolume, secondaryRetentateSampling,
		tertiaryDialysateSamplingVolume, tertiaryRetentateSampling, quaternaryDialysateSamplingVolume,
		quaternaryRetentateSampling, quinaryDialysateSamplingVolume, resolvedsampleVolume,invalidStaticDialysisTests,invalidStaticDialysisOptions, conflictingStaticDialysisOptions,
		conflictingDynamicDialysisOptions,invalidDynamicDialysisOptions,invalidDynamicDialysisTests, dialysisMethodInstrumentMismatchOptions,
		invalidDialysisMethodInstrumentOptions, invalidDialysisMethodInstrumentTests,invalidDialysateTemperatureInstrumentOptions,
		invalidDialysateTemperatureInstrumentTests,dialysateTemperatureInstrumentMismatchOptions, instrumentModelPackets, instrumentModelObjects,
		instrumentObjects, instrumentPackets, allInstrumentModelPackets, instrumentMinTemp, instrumentMaxTemp,sampleVolumeDialysisMembraneOptions,
		invalidSampleVolumeDialysisMembraneOptions, invalidSampleVolumeDialysisMembraneTests,membranePackets, membraneObjects, minMembraneVolumes,
		maxMembraneVolumes,sampleVolumesAll, largeDialysisSampleVolumeOptions,invalidLargeDialysisSampleVolumeOptions,invalidLargeDialysisSampleVolumeTests,
		conflictingImageSystemOptions, invalidConflictingImageSystemOptions,invalidConflictingImageSystemTests,invalidDialysisMembraneTemperatureOptions,
		incompatibleDialysisMembraneTemperatureOptions,invalidDialysisMembraneTemperatureTests, minMembraneTemps,maxMembraneTemps, dialysateContainerVolumeOptions,
		invalidDialysateContainerVolumeOptions,invalidDialysateContainerVolumeTests, minContainerVolumes,maxContainerVolumes, dialysateContainerPackets,
		dialysateContainerObjects, dialysisMixTypeInstrumentMismatchOptions, invalidDialysisMixTypeInstrumentMismatchOptions,invalidDialysisMixTypeInstrumentMismatchTests,
		instrumentMinMixRate, instrumentMaxMixRate, invalidDialysisMixRateInstrumentMismatchTests,invalidDialysisMixRateInstrumentMismatchOptions,
		dialysisMixRateInstrumentMismatchOptions,  instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate, invalidConflictingDialysateSamplingVolumeOptions,
		invalidConflictingDialysateSamplingVolumeTests, conflictingDialysateSamplingVolumeOptions, conflictingRetentateSamplingVolumeOptions,
		invalidConflictingRetentateSamplingVolumeOptions,invalidConflictingRetentateSamplingVolumeTests,conflictingDialysateContainerOutOptions,
		invalidConflictingDialysateContainerOutOptions, invalidConflictingDialysateContainerOutTests, dialysateContainerOutPackets, dialysateContainerOutObjects,
		retentateContainerOutObjects, retentateContainerOutPackets, dialysateContainerOutMaxVolume, dialysateContainerOutMinVolume,
		retentateContainerOutMaxVolume, retentateContainerOutMinVolume, conflictingRetentateContainerOutOptions,invalidConflictingRetentateContainerOutOptions,
		invalidConflictingRetentateContainerOutTests, retentateSamplingMismatchOptions, invalidRetentateSamplingMismatchOptions,invalidRetentateSamplingMismatchTests,
		secondaryRetentateSamplingMismatchOptions,tertiaryRetentateSamplingMismatchOptions,quaternaryRetentateSamplingMismatchOptions,
		allRetentateSamplingMismatchOptions,numberOfDialysisRoundsMismatchOptions, invalidNumberOfDialysisRoundsMismatchOptions,invalidNumberOfDialysisRoundsMismatchTests,
		missingDialysisMembraneMWCOOptions,invalidMissingDialysisMembraneMWCOOptions,invalidMissingDialysisMembraneMWCOTests, membraneMWCO,
		dialysisMembraneSoakMismatchOptions,invalidDialysisMembraneSoakMismatchOptions,invalidDialysisMembraneSoakMismatchTests,resolveddialysisMethod,
		sampleVolumesAllReplaced, sampleVolumesAutomaticReplaced, resolveddynamicDialysisMethod, resolvednumberOfDialysisRounds, impossibleFlowRate,
		resolvedflowRate, invalidImpossibleFlowRateOptions,invalidImpossibleFlowRateTests, resolvedimagingInterval, resolvedimageSystem, resolvedshareDialysateContainer,
		resolveddialysisMembrane, noAvailableDialysisMembraneErrors, invalidNoAvailableDialysisMembraneErrorOptions, invalidNoAvailableDialysisMembraneErrorTests,
		resolvedmolecularWeightCutoff,resolveddialysisMembraneSoak, resolveddialysisMembraneSoakSolution,resolveddialysisMembraneSoakVolume, resolveddialysisMembraneSoakTime,
		resolveddialysisMixType, membraneKitComponents,membraneKitProducts, membraneKitComponentsPlateQ, conflictingMixTypeWarning,invalidConflictingMixTypeTests,
		invalidConflictingMixTypeOptions, resolvedinstrument, dialysisTemps, dialysisTempsNoAmbient,dialysisMixRatesNoNull, dialysisMixRates, unresolvableInstrumentError,
		invalidUnresolvableDialysisInstrumentOptions, invalidUnresolvableDialysisInstrumentTests, resolvedsecondaryDialysateTemperature,resolvedtertiaryDialysateTemperature,
		resolvedquaternaryDialysateTemperature,resolvedquinaryDialysateTemperature, resolveddialysisTime, resolvedsecondaryDialysisTime, resolvedtertiaryDialysisTime,
		resolvedquaternaryDialysisTime, resolvedquinaryDialysisTime, resolveddialysisMixRate, resolvedsecondaryDialysisMixRate,resolvedtertiaryDialysisMixRate,
		resolvedquaternaryDialysisMixRate,resolvedquinaryDialysisMixRate, resolvedsecondaryDialysate,resolvedtertiaryDialysate,resolvedquaternaryDialysate,
		resolvedquinaryDialysate, resolveddialysateVolume, resolvedsecondaryDialysateVolume, resolvedtertiaryDialysateVolume, resolvedquaternaryDialysateVolume,
		resolvedquinaryDialysateVolume, resolveddialysateContainer, resolvedsecondaryDialysateContainer,resolvedtertiaryDialysateContainer,resolvedquaternaryDialysateContainer,
		resolvedquinaryDialysateContainer, membraneKitComponentObjects, supportedDialysateContainers, membraneModelObjects,
		invalidunresolvableDialysateContainerTests,invalidunresolvableDialysateContainerOptions, resolveddialysateSamplingVolume,
		dialysateStorageCondition, secondaryDialysateStorageCondition, tertiaryDialysateStorageCondition, quaternaryDialysateStorageCondition,
		quinaryDialysateStorageCondition, resolveddialysateContainerOut,resolvedsecondaryDialysateContainerOut,resolvedtertiaryDialysateContainerOut,
		resolvedquaternaryDialysateContainerOut,resolvedquinaryDialysateContainerOut,resolvedretentateSamplingVolume,resolvedsecondaryRetentateSamplingVolume,
		resolvedtertiaryRetentateSamplingVolume,resolvedquaternaryRetentateSamplingVolume, resolvedretentateSamplingContainerOut,resolvedsecondaryRetentateSamplingContainerOut,
		resolvedtertiaryRetentateSamplingContainerOut,resolvedquaternaryRetentateSamplingContainerOut, retentateSamplingStorageCondition, secondaryRetentateSamplingStorageCondition,
		tertiaryRetentateSamplingStorageCondition, quaternaryRetentateSamplingStorageCondition,retentateStorageCondition,resolvedretentateContainerOut,
		resolvedvolumeMeasurementInterval, sampleContainerModelPackets, pooledSampleContainerModelPackets, pooledSampleContainerPackets, aliquotOpts,
		poolVolumes, pooledContainerModel, pooledContainerModelCleaned,poolContainerPackets, conflictingDialysateContainerMixOptions,invalidDialysateContainerMixOptions,
		invalidDialysateContainerMixTests,assayVolumes, minStirBarLength, unresolvableDialysateContainer, dialysateContainerVolume, membraneModelPackets,
		dialysateModelContainerObjects, dialysateModelContainerPackets, pooledSamplePackets, allDialysateContainerModelPackets, allMembraneObjects,allDialysateContainerObjects,
		conflictingDialysisMethodMixTypeOptions,invalidDialysisMethodMixTypeOptions,invalidDialysisMethodMixTypeTests, conflictingNullStaticDialysisOptions, invalidNullStaticDialysisOptions,
		invalidNullStaticDialysisTests, conflictingNullDynamicDialysisOptions, invalidNullDynamicDialysisOptions, invalidNullDynamicDialysisTests,numberOfDialysisRoundsNullMismatchOptions,
		invalidNumberOfDialysisRoundsNullMismatchOptions, invalidNumberOfDialysisRoundsNullMismatchTests,possibleSupportedDialysateContainers, possibleSupportedDialysateContainersInfo,
		membraneKitComponentsPlateVolume, subprotocolDescription, dialysateTemperatureAmbient, secondaryDialysateSampling, tertiaryDialysateSampling, quaternaryDialysateSampling,
		quinaryDialysateSampling,dialysateSampling, dialysateSamplingMismatchOptions,secondaryDialysateSamplingMismatchOptions,tertiaryDialysateSamplingMismatchOptions,
		quaternaryDialysateSamplingMismatchOptions, quinaryDialysateSamplingMismatchOptions, allDialysateSamplingMismatchOptions, invalidDialysateSamplingMismatchOptions,
		invalidDialysateSamplingMismatchTests,  resolvedsecondaryDialysateSamplingVolume, resolvedtertiaryDialysateSamplingVolume, resolvedquaternaryDialysateSamplingVolume,
		resolvedquinaryDialysateSamplingVolume, resolveddialysateSampling, resolvedsecondaryDialysateSampling, resolvedtertiaryDialysateSampling, resolvedquaternaryDialysateSampling,
		resolvedquinaryDialysateSampling, resolvedretentateSampling, resolvedsecondaryRetentateSampling, resolvedtertiaryRetentateSampling, resolvedquaternaryRetentateSampling,
		sampleDivisionFactors,largestNumberOfDialysisRounds,kitProducts,potentialInstruments,potentialContainers, invalidNumberOfDialysisRoundsEquilibriumlMismatchOptions,
		invalidNumberOfDialysisRoundsEquilibriumlMismatchTests,insufficientDialysateVolumeOptions,insufficientDialysateVolumeTests,samplesInStorage,validContainerStorageConditionBool,
		validContainerStorageConditionTests,validContainerStoragConditionInvalidOptions,maxSampleVolume,expandedSamplesInStorage,largeStaticDialysisSampleVolumeOptions,invalidLargeStaticDialysisSampleVolumeOptions,
		invalidLargeStaticDialysisSampleVolumeTests,staticDialysisOptionsBool,requiredAliquotAmounts,liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,potentialAliquotContainers,
		simulatedSamplesContainerModels,requiredAliquotContainers,targetContainers,hamiltonCompatibleContainers,sampleContainerModels,requiredSampleVolumes,hamiltonCompatibleContainerBools,
		compatibleContainers,possibleInstruments,instrumentModel,dialysateInstrumentMismatchOptions,invalidDialysateInstrumentMismatchOptions,invalidDialysateInstrumentTests,
		resolveSamplePrepOptionsWithoutAliquot,allInstrumentModels,invalidDialysateVolumeOptions,numberOfDialysisRoundsEquilibriumlMismatchOptions,confictingEquilibriumDialysateVolumeOptions,
		invalidConfictingEquilibriumDialysateVolumeOptions,invalidConfictingEquilibriumDialysateVolumeTests,insufficientStaticDialysateVolumeOptions,invalidStaticDialysateVolumeOptions,
		insufficientStaticDialysateVolumeTests,dialysateVolumes,conflictingRetentateSamplingContainerOutPlateOptions,conflictingRetentateContainerOutPlateOptions,invalidConflictingRetentateContainerOutPlateOptions,
		invalidConflictingRetentateContainerOutPlateTests, invalidConflictingRetentateSamplingContainerOutPlateOptions, invalidConflictingRetentateSamplingContainerOutPlateTests,
		numSamples,tooManySamples,tooManySamplesTest,tooManySamplesInputs,
		simulation, updatedSimulation
	},

	(* --- Setup our user specified options and cache --- *)
	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(*Make a flat list of samples*)
	flatSampleList = Flatten[mySamples];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* separate out our abs spece options from our sample prep options *)
	{samplePrepOptions, dialysisOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDialysis, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDialysis, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> Result], {}}
	];

	(* get the pooled samples flatter and also get the lengths of the pooled simulated samples*)
	flatSimulatedSamples = Flatten[simulatedSamples];
	poolingLengths = Length /@ simulatedSamples;

	(* pull out all the objects specified in the user given options *)
	instrumentModelObjects=DeleteDuplicates[Cases[ToList[Lookup[myOptions, Instrument]], ObjectP[Model[Instrument]]]];
	instrumentObjects=DeleteDuplicates[Cases[ToList[Lookup[myOptions, Instrument]], ObjectP[Object[Instrument]]]];

	allMembraneObjects=ToList[Lookup[myOptions, DialysisMembrane]]/.{Automatic->Null};
	membraneModelObjects=If[MatchQ[#,ObjectP[{Model[Container,Vessel,Dialysis],Model[Container,Plate,Dialysis],Model[Item, DialysisMembrane]}]],#,Null]&/@allMembraneObjects;
	membraneObjects=If[MatchQ[#,ObjectP[{Object[Container,Vessel,Dialysis],Object[Container,Plate,Dialysis],Object[Item, DialysisMembrane]}]],#,Null]&/@allMembraneObjects;

	allDialysateContainerObjects=ToList[Lookup[myOptions, {DialysateContainer,SecondaryDialysateContainer,TertiaryDialysateContainer,QuaternaryDialysateContainer,QuinaryDialysateContainer}]]/.{Automatic->Null};
	dialysateModelContainerObjects=If[MatchQ[#,ObjectP[Model[Container]]],#,Null]&/@allDialysateContainerObjects;
	dialysateContainerObjects=If[MatchQ[#,ObjectP[Object[Container]]],#,Null]&/@allDialysateContainerObjects;

	dialysateContainerOutObjects=ToList[Flatten[Lookup[myOptions, {DialysateContainerOut,SecondaryDialysateContainerOut,TertiaryDialysateContainerOut,QuaternaryDialysateContainerOut,QuinaryDialysateContainerOut}]]]/.{Automatic->Null};
	retentateContainerOutObjects=ToList[Flatten[Lookup[myOptions, {RetentateSamplingContainerOut,SecondaryRetentateSamplingContainerOut,TertiaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingContainerOut}]]]/.{Automatic->Null};

	(* find the smallest stir bar to see what is the smallest dialysatecontainer we can use *)
	minStirBarLength=Min[Lookup[DeleteDuplicates[Cases[inheritedCache,
		KeyValuePattern[
			{
				Type->Model[Part,StirBar]
			}
		]
	]],StirBarLength]];


	(* Supported dialysate containers *)
	(*)possibleSupportedDialysateContainers=Lookup[Cases[inheritedCache,
		KeyValuePattern[
			{
				Type->Model[Container, Vessel],
				CrossSectionalShape -> Circle,
				InternalBottomShape -> FlatBottom,
				Deprecated -> Except[True],
				Aperture -> GreaterP[minStirBarLength],
				SelfStanding -> True,
				Reusable -> True
			}
		]
	],Object];

	(*make sure the aperature is not too small, avoiding tapered containers*)
	possibleSupportedDialysateContainersInfo=Lookup[DeleteDuplicates[Cases[inheritedCache,
		KeyValuePattern[
			{
				Object->ObjectP[possibleSupportedDialysateContainers]
			}
		]
	]],{Aperture, Object, Dimensions}];


	supportedDialysateContainers=Select[possibleSupportedDialysateContainersInfo, First[#] > First[Last[#]]*0.8 &][[All,2]];*)

	supportedDialysateContainers={Model[Container, Vessel, "id:BYDOjv1VAA8m"],Model[Container, Vessel, "id:R8e1PjRDbbOv"],Model[Container, Vessel, "id:O81aEB4kJJJo"],Model[Container, Vessel, "id:wqW9BP4Y0009"]};(*Search[
		Model[Container, Vessel],
		InternalBottomShape == FlatBottom &&
			Deprecated != True &&
			Aperture > 50.8 Millimeter &&
			TaperGroundJointSize == Null &&
			NeckType == Null &&
			SelfStanding == True &&
			InternalConicalDepth == Null &&
			HandPumpRequired != True &&
			Dropper != True &&
			Ampoule != True &&
			Hermetic != True &&
			CrossSectionalShape == Circle &&
			ProductsContained == {} &&
			Reusable == True,
		SubTypes -> False
	];*)

	allInstrumentModels=Search[
			{Model[Instrument,Dialyzer], Model[Instrument,OverheadStirrer],Model[Instrument,HeatBlock],Model[Instrument, Vortex]},
			Deprecated!=True
	];

	(*all of these instruments should be footprint compatible, minus the vortex*)
	possibleInstruments=Join[
		PickList[
			Cases[allInstrumentModels,ObjectP[{Model[Instrument, Vortex],Model[Instrument,HeatBlock]}]],
			CompatibleFootprintQ[Cases[allInstrumentModels,ObjectP[{Model[Instrument, Vortex],Model[Instrument,HeatBlock]}]],Model[Container, Plate, "Rapid Equilibrium Dialysis Base Plates"],ExactMatch->False]
		],
		Cases[allInstrumentModels,Except[ObjectP[{Model[Instrument, Vortex],Model[Instrument,HeatBlock]}]]]
	];

	(* download everything we Downloaded from the parent function *)
	allDownloadValues = Quiet[
		Download[
			{
				Flatten[simulatedSamples],
				instrumentModelObjects,
				instrumentObjects,
				membraneModelObjects,
				membraneObjects,
				dialysateModelContainerObjects,
				dialysateContainerObjects,
				dialysateContainerOutObjects,
				retentateContainerOutObjects
			},
			{
				{
					Packet[Object, Type, Status, Container, Count, Volume, Model, Position, Name, Mass, Sterile, StorageCondition, ThawTime, ThawTemperature, IncompatibleMaterials],
					Packet[Container[{Model, StorageCondition, Name, Contents, TareWeight, Sterile, Status}]],
					(* sampleContainerModelPackets *)
					Packet[Container[Model[{MaxVolume,NumberOfWells,VacuumCentrifugeCompatibility,MaxTemperature,Name}]]],
					(*needed for the Error::DeprecatedModels testing*)
					Packet[Model[{Name, Deprecated}]]
				},
				(*Instrument*)
				{Packet[Object, MaxTemperature, MinTemperature, MinRotationRate,MaxRotationRate,MinStirBarRotationRate,MaxStirBarRotationRate]},
				{Packet[Model[{Object, MaxTemperature, MinTemperature,MinRotationRate,MaxRotationRate,MinStirBarRotationRate,MaxStirBarRotationRate}]]},
				(*Membranes*)
				{Packet[Object, MinVolume, MaxVolume, MinTemperature, MaxTemperature, MolecularWeightCutoff,VolumePerLength]},
				{Packet[Model[{Object, MinVolume, MaxVolume, MinTemperature, MaxTemperature, MolecularWeightCutoff,VolumePerLength}]]},
				(*Containers*)
				{Packet[Object, MinVolume, MaxVolume]},
				{Packet[Model[{Object, MinVolume, MaxVolume}]]},
				{Packet[Object, MinVolume, MaxVolume]},
				{Packet[Object, MinVolume, MaxVolume]}
			},
			Simulation -> updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* split out the information about the aliquot containers and the samples themselves *)
	{sampleDownloadValues, instrumentModelPackets, instrumentPackets,membraneModelPackets, membranePackets,dialysateModelContainerPackets, dialysateContainerPackets, dialysateContainerOutPackets, retentateContainerOutPackets} = allDownloadValues;

	(*join the separate model/object packets*)
	allInstrumentModelPackets=Flatten[Join[{instrumentModelPackets, instrumentPackets}]];
	allMembraneModelPackets=MapThread[If[MatchQ[#1,Null],#2,#1]&,{membraneModelPackets, membranePackets}];
	allDialysateContainerModelPackets=MapThread[If[MatchQ[#1,Null],#2,#1]&,{dialysateModelContainerPackets, dialysateContainerPackets}];

	(* split out the sample packets, container packets, and sample model packets *)
	samplePackets = sampleDownloadValues[[All, 1]];
	containerPackets = sampleDownloadValues[[All, 2]];
	sampleContainerModelPackets = sampleDownloadValues[[All, 3]];
	sampleModelPackets = sampleDownloadValues[[All, 4]];
	sampleContainerModels=Lookup[containerPackets,Model];

	(* Re-list the samplePackets in the form of the original listed, pooled sample input *)
	pooledSamplePackets = TakeList[samplePackets,Length[ToList[#]]&/@simulatedSamples];

	(* Figure out of aliquotting was specified *)
	aliquotOpts = If[
		MatchQ[Lookup[resolvedSamplePrepOptions,Aliquot,False],False],
		Table[False,Length[pooledSamplePackets]],
		Lookup[resolvedSamplePrepOptions,Aliquot,False]
		];

	(* the volumes of that aliquotting *)
	assayVolumes=If[
		MatchQ[Lookup[resolvedSamplePrepOptions,AssayVolume,False],False],
		Table[False,Length[pooledSamplePackets]],
		Lookup[resolvedSamplePrepOptions,AssayVolume,False]
	];

	(* In addition to each specific sample's volumes, look up the assay volume of each sample pool *)
	poolVolumes = MapThread[
		Function[{aliquotting,assayVol,sampList},
			If[MatchQ[aliquotting,True|{True}],
				If[MatchQ[assayVol, Except[Automatic]],
					(*If an aliquot volume is specified, use that*)
					assayVol,

					(*If no aliquot volume is specified, use the SampleVolume. We need this to resolve some options *)
					Total[ToList[Lookup[#,Volume]]&/@sampList]
				],
				(*If we're not aliquoting, just use the Sample Volume*)
				Total[ToList[Lookup[#,Volume]]&/@sampList]
			]
		],
		{
			aliquotOpts,
			assayVolumes,
			pooledSamplePackets
		}
	];

	(* pull out some of the options that are defaulted *)
	{
		numberOfReplicates,
		fastTrack} =
      Lookup[dialysisOptions,
		{
			NumberOfReplicates,
			FastTrack
		}
	];

	(* get NumberOfReplicates without Null so that math works below *)
	numReplicatesNoNull = numberOfReplicates /. {Null -> 1};

	(*-- INPUT VALIDATION CHECKS --*)
	(* --- Discarded samples are not ok --- *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, discardedInvalidInputs], Simulation -> updatedSimulation] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets = If[Not[fastTrack],
		Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Simulation -> updatedSimulation] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object,Date->Now], Simulation -> updatedSimulation] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* ensure that all the numerical options have the proper precision *)
	{roundedDialysisOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			Association[dialysisOptions],
			{
				FlowRate,
				SampleVolume, DialysisMembraneSoakVolume,DialysateVolume,DialysateSamplingVolume,RetentateSamplingVolume, SecondaryDialysateVolume,
				SecondaryDialysateSamplingVolume, SecondaryRetentateSamplingVolume, TertiaryDialysateVolume, TertiaryDialysateSamplingVolume,
				TertiaryRetentateSamplingVolume,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryRetentateSamplingVolume,
				QuinaryDialysateVolume,QuinaryDialysateSamplingVolume,
				DialysisMembraneSoakTime,DialysisTime,SecondaryDialysisTime,TertiaryDialysisTime,QuaternaryDialysisTime,QuinaryDialysisTime,
				DialysateTemperature,SecondaryDialysateTemperature,TertiaryDialysateTemperature,QuaternaryDialysateTemperature,QuinaryDialysateTemperature,
				DialysisMixRate, SecondaryDialysisMixRate,TertiaryDialysisMixRate, QuaternaryDialysisMixRate, QuinaryDialysisMixRate
			},
			{
				0.1 Milliliter/Minute,
				1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
				1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
				1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
				1 Microliter, 1 Microliter,
				1 Second, 1 Minute, 1 Minute, 1 Minute, 1 Minute, 1 Minute,
				1 Celsius, 1 Celsius, 1 Celsius, 1 Celsius, 1 Celsius,
				1 RPM, 1 RPM, 1 RPM, 1 RPM, 1 RPM
			},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				Association[dialysisOptions],
				{
					FlowRate,
					SampleVolume, DialysisMembraneSoakVolume,DialysateVolume,DialysateSamplingVolume,RetentateSamplingVolume, SecondaryDialysateVolume,
					SecondaryDialysateSamplingVolume, SecondaryRetentateSamplingVolume, TertiaryDialysateVolume, TertiaryDialysateSamplingVolume,
					TertiaryRetentateSamplingVolume,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryRetentateSamplingVolume,
					QuinaryDialysateVolume,QuinaryDialysateSamplingVolume,
					DialysisMembraneSoakTime,(*ImagingInterval,*)DialysisTime,SecondaryDialysisTime,TertiaryDialysisTime,QuaternaryDialysisTime,QuinaryDialysisTime,
					DialysateTemperature,SecondaryDialysateTemperature,TertiaryDialysateTemperature,QuaternaryDialysateTemperature,QuinaryDialysateTemperature,
					DialysisMixRate, SecondaryDialysisMixRate,TertiaryDialysisMixRate, QuaternaryDialysisMixRate, QuinaryDialysisMixRate
				},
				{
					0.1 Milliliter/Minute,
					1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
					1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
					1 Microliter, 1 Microliter, 1 Microliter, 1 Microliter,
					1 Microliter, 1 Microliter,
					1 Second, 1 Minute, 1 Minute, 1 Minute, 1 Minute, 1 Minute,
					1 Celsius, 1 Celsius, 1 Celsius, 1 Celsius, 1 Celsius,
					1 RPM, 1 RPM, 1 RPM, 1 RPM, 1 RPM
				}
			],
			{}
		}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* pull out the options that are defaulted *)
	{
		dialysateStorageCondition,
		secondaryDialysateStorageCondition,
		tertiaryDialysateStorageCondition,
		quaternaryDialysateStorageCondition,
		quinaryDialysateStorageCondition,
		retentateStorageCondition,
		retentateSamplingStorageCondition,
		secondaryRetentateSamplingStorageCondition,
		tertiaryRetentateSamplingStorageCondition,
		quaternaryRetentateSamplingStorageCondition,
		imageSystem,
		dialysate,
		dialysateTemperature,
		name,
		parentProtocol} =
		Lookup[roundedDialysisOptions,
			{
				DialysateStorageCondition,
				SecondaryDialysateStorageCondition,
				TertiaryDialysateStorageCondition,
				QuaternaryDialysateStorageCondition,
				QuinaryDialysateStorageCondition,
				RetentateStorageCondition,
				RetentateSamplingStorageCondition,
				SecondaryRetentateSamplingStorageCondition,
				TertiaryRetentateSamplingStorageCondition,
				QuaternaryRetentateSamplingStorageCondition,
				ImageSystem,
				Dialysate,
				DialysateTemperature,
				Name,
				ParentProtocol
			}
		];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, Dialysis, name]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "Dialysis protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a Dialysis object name:",
			validNameQ,
			True
		],
		Null
	];
	(*
	Error::ConflictingStaticDialysisOptions="The Dialysis Method is `1`, however the options, `2`, are only applicable to StaticDialysis. Please set these options to automatic or change the DialysisMethod to StaticDialysis.";
	*)
	(*check if there are Static dialysis options filled out but StaticDialysis is not selected*)
	conflictingStaticDialysisOptions=If[
		(*if the dialysis method is not static and any of the statis dialysis specific options are set*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],Except[StaticDialysis|Automatic]]&&
      MemberQ[Lookup[roundedDialysisOptions,{ShareDialysateContainer, DialysateContainer, SecondaryDialysateContainer, SecondaryDialysisMixRate, TertiaryDialysateContainer, TertiaryDialysisMixRate, QuaternaryDialysateContainer, QuaternaryDialysisMixRate, QuinaryDialysateContainer, QuinaryDialysisMixRate}],Except[Automatic | Null | {Null | Automatic ..}]],
		(*return a the method and a list of bools for the static options*)
		{Lookup[roundedDialysisOptions,DialysisMethod],MatchQ[#,Except[Automatic | Null | {Null | Automatic ..}]]&/@Lookup[roundedDialysisOptions,{ShareDialysateContainer, DialysateContainer, SecondaryDialysateContainer, SecondaryDialysisMixRate, TertiaryDialysateContainer, TertiaryDialysisMixRate, QuaternaryDialysateContainer, QuaternaryDialysisMixRate, QuinaryDialysateContainer, QuinaryDialysisMixRate}]},
		Nothing
	];

	(*give the corresponding error*)
	invalidStaticDialysisOptions=If[Length[conflictingStaticDialysisOptions]>0&&!gatherTests,
		Message[Error::ConflictingStaticDialysisOptions,First[conflictingStaticDialysisOptions],PickList[{
			ShareDialysateContainer, DialysateContainer,  SecondaryDialysateContainer,  SecondaryDialysisMixRate, TertiaryDialysateContainer, TertiaryDialysisMixRate, QuaternaryDialysateContainer, QuaternaryDialysisMixRate, QuinaryDialysateContainer,QuinaryDialysisMixRate
		},Last[conflictingStaticDialysisOptions]]];
		Flatten[Join[{{DialysisMethod},PickList[{ShareDialysateContainer, DialysateContainer,  SecondaryDialysateContainer, SecondaryDialysisMixRate, TertiaryDialysateContainer,  TertiaryDialysisMixRate, QuaternaryDialysateContainer,  QuaternaryDialysisMixRate, QuinaryDialysateContainer, QuinaryDialysisMixRate},Last[conflictingStaticDialysisOptions]]}]],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidStaticDialysisTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingStaticDialysisOptions]==0,
				Test["The static dialysis options are only set if the DialysisMethod is StaticDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingStaticDialysisOptions]>0,
				Test["The static dialysis options are only set if the DialysisMethod is StaticDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];
(*
Error::ConflictingNullStaticDialysisOptions="The Dialysis Method is `1`, however the DialysateContainer is  `2`. Please set the DialysateContainer or change the DialysisMethod.";
*)
	(*Check if the dialysis method is static and the dialysate container is null*)
	conflictingNullStaticDialysisOptions=If[
		(*if the dialysis method is static and the container is null*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],StaticDialysis]&&MatchQ[Lookup[roundedDialysisOptions,DialysateContainer],Null],
		(*return a the method and the container options*)
		{Lookup[roundedDialysisOptions,DialysisMethod],Lookup[roundedDialysisOptions,DialysateContainer]},
		Nothing
	];

	(*give the corresponding error*)
	invalidNullStaticDialysisOptions=If[Length[conflictingNullStaticDialysisOptions]>0&&!gatherTests,
		Message[Error::ConflictingNullStaticDialysisOptions,Lookup[roundedDialysisOptions,DialysisMethod],Lookup[roundedDialysisOptions,DialysateContainer]];
		{DialysisMethod,DialysateContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNullStaticDialysisTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingNullStaticDialysisOptions]==0,
				Test["The static dialysis options are not Null if the DialysisMethod is StaticDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingNullStaticDialysisOptions]>0,
				Test["The static dialysis options are not Null if the DialysisMethod is StaticDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

(*
Error::ConflictingDialysisMethodMixType="The DialysisMixType `1` is not supported with the DialysisMethod `2`. Please choose another MixType.";
*)
	(*check if the mix types are compatible with the dialysismethod*)
	conflictingDialysisMethodMixTypeOptions=If[
		Or[
			MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],EquilibriumDialysis|DynamicDialysis]&&MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Stir],
			MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],DynamicDialysis|StaticDialysis]&&MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Vortex]
		],
		{Lookup[roundedDialysisOptions,DialysisMethod],Lookup[roundedDialysisOptions,DialysisMixType]},
		Nothing
	];

	(*give the corresponding error*)
	invalidDialysisMethodMixTypeOptions=If[Length[conflictingDialysisMethodMixTypeOptions]>0&&!gatherTests,
		Message[Error::ConflictingDialysisMethodMixType,Lookup[roundedDialysisOptions,DialysisMethod],Lookup[roundedDialysisOptions,DialysisMixType]];
		{DialysisMethod,DialysisMixType},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMethodMixTypeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingDialysisMethodMixTypeOptions]==0,
				Test["The DialysisMixType is supported with the DialysisMethod:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDialysisMethodMixTypeOptions]>0,
				Test["The DialysisMixType is supported with the DialysisMethod:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*The total volume of all the samples in the pool, this is needed for if an All SampleVolume was given*)
	sampleVolumesAll=Total[ToList[#]]&/@poolVolumes;

	(*The inputted Sample volumes with All replaced with volume of the input sample*)
	sampleVolumesAllReplaced=MapThread[
		If[MatchQ[#1,All],#2,#1]&,
		{Lookup[roundedDialysisOptions,SampleVolume],sampleVolumesAll}
	];

	(*The inputted Sample volumes with All and Automatic replaced with volume of the input sample*)
	sampleVolumesAutomaticReplaced=MapThread[
		If[MatchQ[#1,Automatic],#2,#1]&,
		{sampleVolumesAllReplaced,sampleVolumesAll}
	];

	maxSampleVolume=Max[sampleVolumesAllReplaced/.{Automatic->0Milliliter}];

	(*If the sample is put in 3 times it should resolve to up to 1/3 the sample, not more*)
	sampleDivisionFactors=Count[simulatedSamples,#]&/@simulatedSamples;

	(*-- Switch Options--*)
	(*DialysisMethod*)
	resolveddialysisMethod=Which[
		(*Is DialysisMethod set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],Except[Automatic]],
		Lookup[roundedDialysisOptions,DialysisMethod],
		(*Are any of the Dynamic dialysis specific options set?*)
		Or[
			MatchQ[Lookup[roundedDialysisOptions,DynamicDialysisMethod],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,FlowRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,ImageSystem],True],
			MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Model[Instrument,Dialyzer],Object[Instrument,Dialyzer]}]]
		],
		DynamicDialysis,
		(*Are any of the options incompatible with Dynamic dialysis set?*)
		Or[
			MatchQ[Lookup[roundedDialysisOptions,DynamicDialysisMethod],Null],
			MatchQ[Lookup[roundedDialysisOptions,FlowRate],Null],
			MatchQ[Lookup[roundedDialysisOptions,ShareDialysateContainer],Except[Automatic|Null]],
			MatchQ[dialysateTemperature,Except[Automatic|Null|Ambient]],
			MemberQ[Lookup[roundedDialysisOptions,DialysateVolume],LessP[1.7Liter]],
			MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,DialysisMixRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysisMixRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysisMixRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysisMixRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysisMixRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,DialysateContainer],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateContainer],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateContainer],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateContainer],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,Instrument],Except[ObjectP[{Model[Instrument,Dialyzer],Object[Instrument,Dialyzer]}]|Automatic]]
		],
		StaticDialysis,
		(*Are all of the user provided SampleVolume over 30Milliliter and there is no membrane containers specifified?*)
		!MemberQ[sampleVolumesAutomaticReplaced/sampleDivisionFactors,LessP[30 Milliliter]]&&
			!MemberQ[Lookup[roundedDialysisOptions,DialysisMembrane],Except[Automatic|ObjectP[Model[Item,DialysisMembrane]]]],
		DynamicDialysis,
		True,
		StaticDialysis
	];

	(*Warning::InsufficientStaticDialysateVolume="In order for the stir bar to move unimpeded, we recomemnd a dialysate volume of at least 1 Liter.";*)
	(*check if the static dialysis options are set when the dialysismethod is set to a different method*)
	dialysateVolumes={
		Lookup[roundedDialysisOptions,DialysateVolume],
		Lookup[roundedDialysisOptions,SecondaryDialysateVolume],
		Lookup[roundedDialysisOptions,TertiaryDialysateVolume],
		Lookup[roundedDialysisOptions,QuaternaryDialysateVolume],
		Lookup[roundedDialysisOptions,QuinaryDialysateVolume]
	};

	insufficientStaticDialysateVolumeOptions=If[
		MatchQ[resolveddialysisMethod,StaticDialysis]&&MemberQ[Flatten[dialysateVolumes,1],LessP[1Liter]],
		{DialysisMethod,DialysateVolume},
		Nothing
	];

	invalidStaticDialysateVolumeOptions=If[Length[insufficientStaticDialysateVolumeOptions]>0&&!gatherTests,
		Message[Warning::InsufficientStaticDialysateVolume],
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	insufficientStaticDialysateVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[insufficientStaticDialysateVolumeOptions]==0,
				Test["The DialysateVolume is 1Liter or greater if the DialysisMethod is StaticDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[insufficientStaticDialysateVolumeOptions]>0,
				Test["The DialysateVolume is 1Liter or greater if the DialysisMethod is StaticDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*)Error::InsufficientDialysateVolume="Do to the dead volume of the dynamic dialysis tank, the dialysate volume must be at least 1.7 Liters.";*)
	(*check if the dynamic dialysis options are set when the dialysismethod is set to a different method*)
	insufficientDialysateVolumeOptions=If[
		Or[MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],DynamicDialysis],
			MatchQ[Lookup[roundedDialysisOptions,DynamicDialysisMethod],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,FlowRate],Except[Automatic|Null]],
			MatchQ[Lookup[roundedDialysisOptions,ImageSystem],True],
			MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Model[Instrument,Dialyzer],Object[Instrument,Dialyzer]}]]
		]&&MemberQ[Lookup[roundedDialysisOptions,DialysateVolume],LessP[1.7Liter]],
		{DialysisMethod,DialysateVolume},
		Nothing
	];

	invalidDialysateVolumeOptions=If[Length[insufficientDialysateVolumeOptions]>0&&!gatherTests,
		Message[Error::InsufficientDialysateVolume];
		{Dialysate},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	insufficientDialysateVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[insufficientDialysateVolumeOptions]==0,
				Test["The DialysateVolume is 1.7Liter or greater if the DialysisMethod is DynamicDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[insufficientDialysateVolumeOptions]>0,
				Test["The DialysateVolume is 1.7Liter or greater if the DialysisMethod is DynamicDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*
	"The Dialysis Method is `1`, however the options, `2`, are only applicable to DynamicDialysis. Please set these options to automatic or change the DialysisMethod to DynamicDialysis.";
	*)
	(*check if the dynamic dialysis options are set when the dialysismethod is set to a different method*)
	conflictingDynamicDialysisOptions=If[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],Except[DynamicDialysis|Automatic]]&&
			MemberQ[Lookup[roundedDialysisOptions,{DynamicDialysisMethod, FlowRate,ImageSystem}],Except[Automatic | Null | False|{Null | Automatic ..}]],
		{Lookup[roundedDialysisOptions,DialysisMethod],MatchQ[#,Except[Automatic | Null | {Null | Automatic ..}]]&/@Lookup[roundedDialysisOptions,{DynamicDialysisMethod, FlowRate,ImageSystem}]},
		{}
	];

	(*give the corresponding error*)
	invalidDynamicDialysisOptions=If[Length[conflictingDynamicDialysisOptions]>0&&!gatherTests,
		Message[Error::ConflictingDynamicDialysisOptions,First[conflictingDynamicDialysisOptions],PickList[{DynamicDialysisMethod, FlowRate,ImageSystem},Last[conflictingDynamicDialysisOptions]]];
		Flatten[Join[{{DialysisMethod},PickList[{DynamicDialysisMethod, FlowRate,ImageSystem},Last[conflictingDynamicDialysisOptions]]}]],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDynamicDialysisTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingDynamicDialysisOptions]==0,
				Test["The dynamic dialysis options are only set if the DialysisMethod is DynamicDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDynamicDialysisOptions]>0,
				Test["The dynamic dialysis options are only set if the DialysisMethod is DynamicDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

(*
	Error::ConflictingNullDynamicDialysisOptions="The Dialysis Method is `1`, however the dynamic dialysis options, `2`, are set to Null. Please set these options or change the DialysisMethod.";
	*)
	(*check if the dynamic dialysis options are set to Null when the dialysismethod Dynamic*)
	conflictingNullDynamicDialysisOptions=If[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],DynamicDialysis]&&
			MemberQ[Lookup[roundedDialysisOptions,{DynamicDialysisMethod, FlowRate}],Null],
		{Lookup[roundedDialysisOptions,DialysisMethod],MatchQ[#,Null]&/@Lookup[roundedDialysisOptions,{DynamicDialysisMethod, FlowRate}]},
		Nothing
	];

	(*give the corresponding error*)
	invalidNullDynamicDialysisOptions=If[Length[conflictingNullDynamicDialysisOptions]>0&&!gatherTests,
		Message[Error::ConflictingNullDynamicDialysisOptions,First[conflictingNullDynamicDialysisOptions],PickList[{DynamicDialysisMethod, FlowRate},Last[conflictingNullDynamicDialysisOptions]]];
		Flatten[Join[{{DialysisMethod},PickList[{DynamicDialysisMethod, FlowRate},Last[conflictingNullDynamicDialysisOptions]]}]],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNullDynamicDialysisTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingNullDynamicDialysisOptions]==0,
				Test["The dynamic dialysis options are not set to null if the DialysisMethod is DynamicDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingNullDynamicDialysisOptions]>0,
				Test["The dynamic dialysis options are are not set to null if the DialysisMethod is DynamicDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysisMethodInstrumentMismatch="The Instrument, `1`, is not appropriate for the DialysisMethod, `2`. Please pick a different Instrument";
	*)

	(*check if the instrument is compatible with the dialysis method*)
	dialysisMethodInstrumentMismatchOptions=Which[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],DynamicDialysis],
		If[MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[Object[Instrument,Dialyzer]|Model[Instrument,Dialyzer]]|Automatic],
			Nothing,
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMethod]}
		],
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],StaticDialysis],
		If[MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[Model[Instrument,OverheadStirrer]|Object[Instrument,OverheadStirrer]]|Model[Instrument,HeatBlock]|Object[Instrument,HeatBlock]|Automatic|Null],
			Nothing,
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMethod]}
		],
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],EquilibriumDialysis],
		If[MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[Model[Instrument,Vortex]| Object[Instrument,Vortex],Model[Instrument,HeatBlock]|Object[Instrument,HeatBlock]]|Automatic|Null],
			Nothing,
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMethod]}
		],
		True,
		Nothing
	];

	(*give the corresponding error*)
	invalidDialysisMethodInstrumentOptions=If[Length[dialysisMethodInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysisMethodInstrumentMismatch,Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMethod]];
		{Instrument,DialysisMethod},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMethodInstrumentTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysisMethodInstrumentMismatchOptions]==0,
				Test["The Instrument is appropriate for the DialysisMethod:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysisMethodInstrumentMismatchOptions]>0,
				Test["The Instrument is appropriate for the DialysisMethod:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysateTemperatureInstrumentMismatch="The Instrument, `1`, cannot be control the temperature of the dialysate to `2`. Please pick a different Instrument or DialysateTemperature";
	*)

	(*lookup the min and max temperature of the user provided instrument*)
	instrumentMinTemp=First[Lookup[allInstrumentModelPackets,MinTemperature]]/.$Failed->$AmbientTemperature;
	instrumentMaxTemp=First[Lookup[allInstrumentModelPackets,MaxTemperature]]/.$Failed->$AmbientTemperature;

	(*check if the instrument is compatible with the dialysate temperature*)
	dialysateTemperatureInstrumentMismatchOptions= If[
		MatchQ[Lookup[roundedDialysisOptions,Instrument],Except[Automatic|Null]]&&
			Or[
				!MatchQ[dialysateTemperature/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],
				!If[MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True]
			],
			{
				Lookup[roundedDialysisOptions,Instrument],
				PickList[
					{dialysateTemperature,Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Lookup[roundedDialysisOptions,TertiaryDialysateTemperature], Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature], Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]},
					{
						!MatchQ[dialysateTemperature/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],
						!If[MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
						!If[MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
						!If[MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
						!If[MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]]|$AmbientTemperature,True]
					}
				]
			},
			Nothing
		];

	(*give the corresponding error*)
	invalidDialysateTemperatureInstrumentOptions=If[Length[dialysateTemperatureInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysateTemperatureInstrumentMismatch,First[dialysateTemperatureInstrumentMismatchOptions],Last[dialysateTemperatureInstrumentMismatchOptions]];
		{Instrument,PickList[
			{DialysateTemperature, SecondaryDialysateTemperature, TertiaryDialysateTemperature, QuaternaryDialysateTemperature,QuinaryDialysateTemperature},
			{
				!MatchQ[dialysateTemperature/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],
				!If[MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]|$AmbientTemperature],True],
				!If[MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Null|Automatic]],MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]/. {Ambient|Null -> $AmbientTemperature},RangeP[instrumentMinTemp,instrumentMaxTemp]]|$AmbientTemperature,True]
			}
		]},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysateTemperatureInstrumentTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysateTemperatureInstrumentMismatchOptions]==0,
				Test["The Instrument can achieve the DialysateTemperature:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysateTemperatureInstrumentMismatchOptions]>0,
				Test["The Instrument can achieve the DialysateTemperature:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysisInstrumentMismatch="The Instrument, `1`, is not compatible with dialysis experiments. Please pick a different Instrument.";
	*)
	instrumentModel=First[Lookup[allInstrumentModelPackets,Object]];

	(*check if the instrument is compatible with the dialysate temperature*)
	dialysateInstrumentMismatchOptions= If[
		MatchQ[Lookup[roundedDialysisOptions,Instrument],Except[Automatic|Null]]&&!MemberQ[possibleInstruments,instrumentModel],
		{Instrument},
		Nothing
	];

	invalidDialysateInstrumentMismatchOptions= If[
		Length[dialysateInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysisInstrumentMismatch,Lookup[roundedDialysisOptions,Instrument]];
		{Instrument},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysateInstrumentTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysateInstrumentMismatchOptions]==0,
				Test["The Instrument can achieve be used with dialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysateInstrumentMismatchOptions]>0,
				Test["The Instrument can achieve be used with dialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*
	Error::SampleVolumeDialysisMembraneMismatch="The SampleVolume, `1`, cannot fit inside the DialysisMembrane `2`. Please choose a different SampleVolume or DialysisMembrane.";
	*)

	(*Find the min and max volumes of the user provided membranes. The tubing will fail (no min/max in object), setting it to to 2 to 130 Milliliter or based of the volume per length*)
	minMembraneVolumes=If[
		MatchQ[#,Null],
		#,
		If[
			MatchQ[Lookup[First[#],Object],ObjectP[Model[Item,DialysisMembrane]]],
			2Milliliter,
			Lookup[First[#],MinVolume]
		]
	]&/@allMembraneModelPackets/. {$Failed -> 0 Microliter};

	maxMembraneVolumes=If[
		MatchQ[#,Null],
		#,
		Which[
			(*equilibrium dialysis plates*)
			MatchQ[Lookup[First[#],Object],ObjectP[Model[Container,Plate,Dialysis]]],
			Lookup[First[#],MaxVolume]-(250*Microliter),
			(*vessels*)
			MatchQ[Lookup[First[#],Object],ObjectP[Model[Container,Vessel,Dialysis]]],
			Lookup[First[#],MaxVolume],
			(*tubes*)
			True,
			Min[Lookup[First[#],VolumePerLength]*(0.4Meter),130 Milliliter]
		]
	]&/@allMembraneModelPackets;


	(*check if the samples can fit in the provided membranes*)
	sampleVolumeDialysisMembraneOptions= MapThread[
		Which[
			(*if volume was given*)
			MatchQ[#1,Except[Automatic|All]]&&MatchQ[#3,Except[Automatic]],
			If[MatchQ[#1,RangeP[#4,#5]],
				Nothing,
				(*if it is out of range*)
				{#1,#3}
			],
			(*if all was given, check the volume of the sample*)
			MatchQ[#1,Except[Automatic]]&&MatchQ[#3,Except[Automatic]],
			If[
				MatchQ[#2,RangeP[#4,#5]],
				Nothing,
				(*if it is out of range*)
				{#2,#3}
			],
			(*if automatic*)
			True,
			Nothing
		]&,
		{Lookup[roundedDialysisOptions,SampleVolume],sampleVolumesAll,Lookup[roundedDialysisOptions,DialysisMembrane],minMembraneVolumes,maxMembraneVolumes}
	];

	(*give the corresponding error*)
	invalidSampleVolumeDialysisMembraneOptions=If[Length[sampleVolumeDialysisMembraneOptions]>0&&!gatherTests,
		Message[Error::SampleVolumeDialysisMembraneMismatch,sampleVolumeDialysisMembraneOptions[[All,1]],Lookup[roundedDialysisOptions,DialysisMembrane]];
		{SampleVolume,DialysisMembrane},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidSampleVolumeDialysisMembraneTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[sampleVolumeDialysisMembraneOptions]==0,
				Test["The SampleVolume can fit in the DialysisMembrane:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[sampleVolumeDialysisMembraneOptions]>0,
				Test["The SampleVolume can fit in the DialysisMembrane:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::LargeDialysisSampleVolume="Is the SampleVolume `1` is larger than what can fit in the largest DialysisMembrane which is 130ml. Please input the sample multiple times with SampleVolumes lower than 130ml to slit the sample into multiple dialysis membranes.";
	*)
	(*check if the sample volume is larger than the largest membrane capacity*)
	largeDialysisSampleVolumeOptions= MapThread[
		Which[
			(*if All was given*)
			MatchQ[#1,All],
			If[MatchQ[#2,GreaterP[130 Milliliter]],
				#2,
				Nothing
			],
			(*if automatic or a volume*)
			True,
			Nothing
		]&,
		{Lookup[roundedDialysisOptions,SampleVolume],sampleVolumesAll}
	];

	(*give the corresponding error*)
	invalidLargeDialysisSampleVolumeOptions=If[Length[largeDialysisSampleVolumeOptions]>0&&!gatherTests,
		Message[Error::LargeDialysisSampleVolume,largeDialysisSampleVolumeOptions];
		{SampleVolume},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidLargeDialysisSampleVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[largeDialysisSampleVolumeOptions]==0,
				Test["The SampleVolume can fit in the largest DialysisMembrane:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[largeDialysisSampleVolumeOptions]>0,
				Test["The SampleVolume can fit in the largest DialysisMembrane:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::ConfictingEquilibriumDialysateVolume="Is the DialysateVolume `1` is fit in the largest DialysisMembrane for Equilibrium dialysis, which is 750ul. Please use a smaller DialysateVolume.";*)
	(*check if the sample volume is larger than the largest membrane capacity for equillibrium*)
	confictingEquilibriumDialysateVolumeOptions= If[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],EquilibriumDialysis]&&MatchQ[#,GreaterP[750Microliter]],
		{#},
		Nothing
	]&/@Lookup[roundedDialysisOptions,DialysateVolume];

	(*give the corresponding error*)
	invalidConfictingEquilibriumDialysateVolumeOptions=If[Length[confictingEquilibriumDialysateVolumeOptions]>0&&!gatherTests,
		Message[Error::ConfictingEquilibriumDialysateVolume,confictingEquilibriumDialysateVolumeOptions];
		{DialysateVolume},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConfictingEquilibriumDialysateVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[confictingEquilibriumDialysateVolumeOptions]==0,
				Test["The Dialysate can fit in the largest DialysisMembrane allowed for EquilibriumDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[confictingEquilibriumDialysateVolumeOptions]>0,
				Test["The Dialysate can fit in the largest DialysisMembrane allowed for EquilibriumDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::LargeStaticDialysisSampleVolume="Is the SampleVolume `1` is larger than what can fit in the largest DialysisMembrane for Static dialysis, which is 30ml. Please either input the sample multiple times with SampleVolumes lower than 30ml to slit the sample into multiple dialysis membranes or use DynamicDialysis.";
	*)
	(*if they set static dialysis options*)
	staticDialysisOptionsBool=Or[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],StaticDialysis],
		MatchQ[Lookup[roundedDialysisOptions,DynamicDialysisMethod],Null],
		MatchQ[Lookup[roundedDialysisOptions,FlowRate],Null],
		MatchQ[Lookup[roundedDialysisOptions,ShareDialysateContainer],Except[Automatic|Null]],
		MatchQ[dialysateTemperature,Except[Automatic|Null|Ambient]],
		MemberQ[Lookup[roundedDialysisOptions,DialysateVolume],LessP[1.7Liter]],
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,DialysisMixRate],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysisMixRate],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysisMixRate],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysisMixRate],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysisMixRate],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,DialysateContainer],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateContainer],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateContainer],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateContainer],Except[Automatic|Null]],
		MatchQ[Lookup[roundedDialysisOptions,Instrument],Except[ObjectP[{Model[Instrument,Dialyzer],Object[Instrument,Dialyzer]}]|Automatic]]
	];
	(*check if the sample volume is larger than the largest membrane capacity for static*)
	largeStaticDialysisSampleVolumeOptions= MapThread[
		Which[
			(*if All was given*)
			MatchQ[#1,All],
			If[MatchQ[#2,RangeP[36 Milliliter,130Milliliter]]&&staticDialysisOptionsBool,
				#2,
				Nothing
			],
			(*if a volume was given*)
			MatchQ[#1,RangeP[36 Milliliter,130Milliliter]],
			If[staticDialysisOptionsBool,
				#2,
				Nothing
			],
			(*if automatic*)
			True,
			Nothing
		]&,
		{Lookup[roundedDialysisOptions,SampleVolume],sampleVolumesAll}
	];

	(*give the corresponding error*)
	invalidLargeStaticDialysisSampleVolumeOptions=If[Length[largeStaticDialysisSampleVolumeOptions]>0&&!gatherTests,
		Message[Error::LargeStaticDialysisSampleVolume,largeStaticDialysisSampleVolumeOptions];
		{SampleVolume},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidLargeStaticDialysisSampleVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[largeStaticDialysisSampleVolumeOptions]==0,
				Test["The SampleVolume can fit in the largest DialysisMembrane allowed for StaticDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[largeStaticDialysisSampleVolumeOptions]>0,
				Test["The SampleVolume can fit in the largest DialysisMembrane allowed for StaticDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];
(*
	(*Error ConflictingImageSystem="Is the ImageSystem is `1` and the imaging options `1` are set. Please set these options to automatic or change ImageSystem to True.";
	*)(*
	(*check if the imaginginterval conflicts with its ImageSystem Bool*)
	conflictingImageSystemOptions=If[
		Or[
			MatchQ[Lookup[roundedDialysisOptions,ImageSystem],False]&& MemberQ[Lookup[roundedDialysisOptions,ImagingInterval],Except[Automatic | Null]],
			MatchQ[Lookup[roundedDialysisOptions,ImageSystem],True]&& MemberQ[Lookup[roundedDialysisOptions,ImagingInterval],Null]
			],
		{Lookup[roundedDialysisOptions,ImageSystem],Lookup[roundedDialysisOptions,ImagingInterval]},
		Nothing
	];

	(*give the corresponding error*)
	invalidConflictingImageSystemOptions=If[Length[conflictingImageSystemOptions]>0&&!gatherTests,
		Message[Error ConflictingImageSystem,Lookup[roundedDialysisOptions,ImageSystem],Lookup[roundedDialysisOptions,ImagingInterval]];
		{ImageSystem,ImagingInterval},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingImageSystemTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[invalidConflictingImageSystemOptions]==0,
				Test["The options for imaging the system are only not Null if ImageSystem is True:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidConflictingImageSystemOptions]>0,
				Test["The options for imaging the system are only not Null if ImageSystem is True:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];*)
	(*check if the method conflicts with its ImageSystem Bool*)
	(*
	(*give the corresponding error*)
	invalidConflictingImageSystemOptions=If[MatchQ[Lookup[roundedDialysisOptions,ImageSystem],True]&&MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],Except[DynamicDialysis|Automatic]]&&!gatherTests,
		Message[Error ConflictingImageSystem];
		{ImageSystem},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingImageSystemTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[invalidConflictingImageSystemOptions]==0,
				Test["ImageSystem is only True if the DialysisMethod is DynamicDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidConflictingImageSystemOptions]>0,
				Test["ImageSystem is only True if the DialysisMethod is DynamicDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];*)
	*)

	(*Error::IncompatibleDialysisMembraneTemperature="The DialysateTemperature, `1`, is not between the MinTemperature, `2`, and MaxTemperature, `3`, of the DialysisMembrane, `4`. Please change the DialysateTemperature or the DialysisMembrane.";
	*)

	(*Find the Min and Max temps of the user selected membranes*)
	minMembraneTemps=If[MatchQ[#,Null],#,Lookup[First[#],MinTemperature]]&/@allMembraneModelPackets/. {Null -> -10000 Celsius};
	maxMembraneTemps=If[MatchQ[#,Null],#,Lookup[First[#],MaxTemperature]]&/@allMembraneModelPackets/. {Null -> 10000 Celsius};

	(*Check if the Min and Max temps of the user selected membranes conflict with the dialysate temperature*)
	incompatibleDialysisMembraneTemperatureOptions=MapThread[
		If[
			MemberQ[#1,Except[Automatic]]&&
       !MatchQ[{dialysateTemperature, Lookup[roundedDialysisOptions,SecondaryDialysateTemperature], Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]}/. {Ambient|Null|Automatic -> $AmbientTemperature},{RangeP[#2,#3]..}],
			{{dialysateTemperature, Lookup[roundedDialysisOptions,SecondaryDialysateTemperature], Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Lookup[roundedDialysisOptions,QuinaryDialysateTemperature]},#2,#3,#1},
			Nothing
		]&,
		{Lookup[roundedDialysisOptions,DialysisMembrane],minMembraneTemps,maxMembraneTemps}
		];

	(*give the corresponding error*)
	invalidDialysisMembraneTemperatureOptions=If[Length[incompatibleDialysisMembraneTemperatureOptions]>0&&!gatherTests,
		Message[Error::IncompatibleDialysisMembraneTemperature,dialysateTemperature,minMembraneTemps,maxMembraneTemps, Lookup[roundedDialysisOptions,DialysisMembrane]];
		{DialysateTemperature,DialysisMembrane},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMembraneTemperatureTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[incompatibleDialysisMembraneTemperatureOptions]==0,
				Test["The DialysateTemperature between the MinTemperature and MaxTemperature of the DialysisMembrane:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[incompatibleDialysisMembraneTemperatureOptions]>0,
				Test["The DialysateTemperature between the MinTemperature and MaxTemperature of the DialysisMembrane:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysateContainerVolume="The DialysateVolume `1` is not between the MinVolume, `2`, and MaxVolume, `3`, of the DialysisContainer `4` minus the sampleVolume. Please change the DialysateVolume or the DialysateContainer.";
	*)
	(*Check if the Min and Max volumes of the user selected dialysate containers*)
	minContainerVolumes=If[MatchQ[#,Null],Null,Lookup[First[#],MinVolume]]&/@allDialysateContainerModelPackets;
	maxContainerVolumes=If[MatchQ[#,Null],Null,Lookup[First[#],MaxVolume]]&/@allDialysateContainerModelPackets;


	(*Check if the dialysate containers can hold the dialysate volume*)
	dialysateContainerVolumeOptions=PickList[
		{{DialysateContainer,DialysateVolume,minContainerVolumes[[1]],maxContainerVolumes[[1]]}, {SecondaryDialysateContainer,SecondaryDialysateVolume,minContainerVolumes[[2]],maxContainerVolumes[[2]]}, {TertiaryDialysateContainer,TertiaryDialysateVolume,minContainerVolumes[[3]],maxContainerVolumes[[3]]}, {QuaternaryDialysateContainer,QuaternaryDialysateVolume,minContainerVolumes[[4]],maxContainerVolumes[[4]]}, {QuinaryDialysateContainer,QuinaryDialysateVolume,minContainerVolumes[[5]],maxContainerVolumes[[5]]}},
		MapThread[
			If[
				MemberQ[Lookup[roundedDialysisOptions,First[#1]],Except[Automatic|Null]]&&MemberQ[Lookup[roundedDialysisOptions,Last[#1]],Except[Automatic|Null]],
				MemberQ[Lookup[roundedDialysisOptions,Last[#1]],Except[RangeP[#2/.{Null->0Milliliter},#3-maxSampleVolume]]],
				False
			]
		&,
			{{{DialysateContainer, DialysateVolume}, {SecondaryDialysateContainer, SecondaryDialysateVolume}, {TertiaryDialysateContainer, TertiaryDialysateVolume}, {QuaternaryDialysateContainer, QuaternaryDialysateVolume}, {QuinaryDialysateContainer, QuinaryDialysateVolume}},
				minContainerVolumes,
				maxContainerVolumes
			}
		]
		];

	(*give the corresponding error*)
	invalidDialysateContainerVolumeOptions=If[Length[dialysateContainerVolumeOptions]>0&&!gatherTests,
		Message[Error::DialysateContainerVolume,Lookup[roundedDialysisOptions,#][[2]]&/@dialysateContainerVolumeOptions,dialysateContainerVolumeOptions[[All,3]],dialysateContainerVolumeOptions[[All,4]], Lookup[roundedDialysisOptions,#][[1]]&/@dialysateContainerVolumeOptions];
		Join[dialysateContainerVolumeOptions[[All,1]],dialysateContainerVolumeOptions[[All,2]]],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysateContainerVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysateContainerVolumeOptions]==0,
				Test["The DialysateVolume is between the MinVolume and MaxVolume of the Dialysis Container:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysateContainerVolumeOptions]>0,
				Test["The DialysateVolume is between the MinVolume and MaxVolume of the Dialysis Container:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*Error::DialysisMixTypeInstrumentMismatch="The Instrument, `1`, cannot support the DialysisMixType `2`. Please pick a different Instrument or DialysisMixType";
	*)
	(*Check if the user selected instrument conflicts with the mixtype*)
	dialysisMixTypeInstrumentMismatchOptions=Which[
		(*instruments that don't mix*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Object[Instrument,Dialyzer],Model[Instrument,Dialyzer],Model[Instrument,HeatBlock],Object[Instrument,HeatBlock]}]],
		If[MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic | Null]],
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMixType]},
			Nothing
		],
		(*shakers*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Object[Instrument,Vortex],Model[Instrument,Vortex]}]],
		If[MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic |Vortex]],
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMixType]},
			Nothing
		],
		(*stirers*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Object[Instrument,Stirrer],Model[Instrument,Strirrer]}]],
		If[MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic |Stir]],
			{Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMixType]},
			Nothing
		],
		(*Automatic or Null*)
		True,
		Nothing
	];

	(*give the corresponding error*)
	invalidDialysisMixTypeInstrumentMismatchOptions=If[Length[dialysisMixTypeInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysisMixTypeInstrumentMismatch,Lookup[roundedDialysisOptions,Instrument],Lookup[roundedDialysisOptions,DialysisMixType]];
		{Instrument,DialysisMixType},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMixTypeInstrumentMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysisMixTypeInstrumentMismatchOptions]==0,
				Test["The DialysisMixType is acheivable by the Instrument:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysisMixTypeInstrumentMismatchOptions]>0,
				Test["The DialysisMixType is acheivable by the Instrument:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysisMixRateInstrumentMismatch="The Instrument, `1`, cannot support the DialysisMixRate `2`. Please pick a different Instrument or DialysisMixRate between `3` and `4`.";
	*)
	(*Find the min and max MixRate of the provided instruments*)
	instrumentMinMixRate=First[Lookup[allInstrumentModelPackets,MinRotationRate]];
	instrumentMaxMixRate=First[Lookup[allInstrumentModelPackets,MaxRotationRate]];
	instrumentSitBarMinMixRate=First[Lookup[allInstrumentModelPackets,MinStirBarRotationRate]];
	instrumentSitBarMaxMixRate=First[Lookup[allInstrumentModelPackets,MaxStirBarRotationRate]];

	(*Check if the provided instruments can acheive the MixRate*)
	dialysisMixRateInstrumentMismatchOptions= Which[
		(*we are using a stir bar*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Object[Instrument,OverheadStirrer],Model[Instrument,OverheadStirrer]}]],
		PickList[{DialysisMixRate,SecondaryDialysisMixRate,TertiaryDialysisMixRate,QuaternaryDialysisMixRate,QuinaryDialysisMixRate},
		{
			If[MatchQ[Lookup[roundedDialysisOptions, DialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, DialysisMixRate], RangeP[instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate]], False],
			If[MatchQ[Lookup[roundedDialysisOptions, SecondaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, SecondaryDialysisMixRate], RangeP[instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate]], False],
			If[MatchQ[Lookup[roundedDialysisOptions, TertiaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, TertiaryDialysisMixRate], RangeP[instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate]], False],
			If[MatchQ[Lookup[roundedDialysisOptions, QuaternaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, QuaternaryDialysisMixRate], RangeP[instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate]], False],
			If[MatchQ[Lookup[roundedDialysisOptions, QuinaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, QuinaryDialysisMixRate], RangeP[instrumentSitBarMinMixRate, instrumentSitBarMaxMixRate]], False]
		}],
		(*we are using a shaker*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],ObjectP[{Object[Instrument,Vortex],Model[Instrument,Vortex]}]],
		PickList[{DialysisMixRate,SecondaryDialysisMixRate,TertiaryDialysisMixRate,QuaternaryDialysisMixRate,QuinaryDialysisMixRate},
			{
				If[MatchQ[Lookup[roundedDialysisOptions, DialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, DialysisMixRate], RangeP[instrumentMinMixRate, instrumentMaxMixRate]], False],
				If[MatchQ[Lookup[roundedDialysisOptions, SecondaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, SecondaryDialysisMixRate], RangeP[instrumentMinMixRate, instrumentMaxMixRate]], False],
				If[MatchQ[Lookup[roundedDialysisOptions, TertiaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, TertiaryDialysisMixRate], RangeP[instrumentMinMixRate, instrumentMaxMixRate]], False],
				If[MatchQ[Lookup[roundedDialysisOptions, QuaternaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, QuaternaryDialysisMixRate], RangeP[instrumentMinMixRate, instrumentMaxMixRate]], False],
				If[MatchQ[Lookup[roundedDialysisOptions, QuinaryDialysisMixRate], Except[Null | Automatic]], !MatchQ[Lookup[roundedDialysisOptions, QuinaryDialysisMixRate], RangeP[instrumentMinMixRate, instrumentMaxMixRate]], False]
			}],
		True,
		Nothing
	];

	(*give the corresponding error*)
	invalidDialysisMixRateInstrumentMismatchOptions=If[Length[dialysisMixRateInstrumentMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysisMixRateInstrumentMismatch,
			Lookup[roundedDialysisOptions,Instrument],
			Lookup[roundedDialysisOptions, #]&/@dialysisMixRateInstrumentMismatchOptions,
			Last[DeleteCases[{instrumentMinMixRate,instrumentSitBarMinMixRate},$Failed]],
			Last[DeleteCases[{instrumentMaxMixRate,instrumentSitBarMaxMixRate},$Failed]]
		];
		{Instrument,dialysisMixRateInstrumentMismatchOptions},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMixRateInstrumentMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysisMixRateInstrumentMismatchOptions]==0,
				Test["The Instrument can achieve the DialysisMixRate:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysisMixRateInstrumentMismatchOptions]>0,
				Test["The Instrument can achieve the DialysisMixRate:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*Error::ConflictingRetentateSamplingVolume="The sampling volumes, `1` are `2`, and are less than the SampleVolume, `3`. Please choose a smaller retentate sampleVolume.";
	*)
	(*Check if the retentate sampling volume is larger than the sample volume*)
	conflictingRetentateSamplingVolumeOptions= Flatten[MapThread[
		Function[{sampVol,samVolAll,retSamp1,retSamp2,retSamp3,retSamp4},
			Which[
				(*if volume was given*)
				MatchQ[sampVol,Except[Automatic|All]],
				MapThread[
					If[MatchQ[sampVol - #2, LessP[0 Milliliter]],
						{sampVol,#1,#2},
						Nothing
					]&,
					{{RetentateSamplingVolume,SecondaryRetentateSamplingVolume,TertiaryRetentateSamplingVolume,QuaternaryRetentateSamplingVolume},{retSamp1,retSamp2,retSamp3,retSamp4}}
				],
				(*if all or automatic was given, check the volume of the sample*)
				True,
				MapThread[
					If[MatchQ[samVolAll - #2, LessP[0 Milliliter]],
						{samVolAll,#1,#2},
						Nothing
					]&,
					{{RetentateSamplingVolume,SecondaryRetentateSamplingVolume,TertiaryRetentateSamplingVolume,QuaternaryRetentateSamplingVolume},{retSamp1,retSamp2,retSamp3,retSamp4}}
				]
			]
		],
		{Lookup[roundedDialysisOptions,SampleVolume],sampleVolumesAll,Lookup[roundedDialysisOptions,RetentateSamplingVolume] /. {Null -> 0Microliter},Lookup[roundedDialysisOptions,SecondaryRetentateSamplingVolume] /. {Null -> 0Microliter},Lookup[roundedDialysisOptions,TertiaryRetentateSamplingVolume] /. {Null -> 0Microliter},Lookup[roundedDialysisOptions,QuaternaryRetentateSamplingVolume] /. {Null -> 0Microliter}}
	],1];

	(*give the corresponding error*)
	invalidConflictingRetentateSamplingVolumeOptions=If[Length[conflictingRetentateSamplingVolumeOptions]>0&&!gatherTests,
		Message[Error::ConflictingRetentateSamplingVolume,
			conflictingRetentateSamplingVolumeOptions[[All,2]],
			conflictingRetentateSamplingVolumeOptions[[All,3]],
			conflictingRetentateSamplingVolumeOptions[[All,1]]
		];
		{SampleVolume, conflictingRetentateSamplingVolumeOptions[[All,2]]},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingRetentateSamplingVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingRetentateSamplingVolumeOptions]==0,
				Test["The RetentateSamplingVolume less than the SampleVolume:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingRetentateSamplingVolumeOptions]>0,
				Test["The RetentateSamplingVolume less than the SampleVolume:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];
	(*Error::ConflictingDialysateContainerOut="The maximum volume `1` of the DialysateContainerOut `2` is less than the DialysateSamplingVolume `3` Please choose a larger DialysateContainerOut.";
	*)

	(* Find the min and max volume of the dialysate container outs*)
	dialysateContainerOutMaxVolume=Map[
		If[MatchQ[#, Null],
			Null,
			Lookup[#, MaxVolume]] &,
		Partition[dialysateContainerOutPackets,Length[sampleVolumesAll]],
		{2}
	];

	dialysateContainerOutMinVolume=Map[
		If[MatchQ[#, Null],
			Null,
			Lookup[#, MinVolume]] &,
		Partition[dialysateContainerOutPackets,Length[sampleVolumesAll]],
		{2}
	];

	(*Check if the dialysate sampling volumes can fit in them*)
	conflictingDialysateContainerOutOptions=
		PickList[{{dialysateContainerOutMaxVolume[[1]],DialysateSamplingVolume,DialysateContainerOut},{dialysateContainerOutMaxVolume[[2]],SecondaryDialysateSamplingVolume,SecondaryDialysateContainerOut},{dialysateContainerOutMaxVolume[[3]], TertiaryDialysateSamplingVolume,TertiaryDialysateContainerOut},{dialysateContainerOutMaxVolume[[4]], QuaternaryDialysateSamplingVolume,QuaternaryDialysateContainerOut},{dialysateContainerOutMaxVolume[[5]], QuinaryDialysateSamplingVolume,QuinaryDialysateContainerOut}},
			{
				MemberQ[dialysateContainerOutMaxVolume[[1]] - Lookup[roundedDialysisOptions, DialysateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}],
				MemberQ[dialysateContainerOutMaxVolume[[2]] - Lookup[roundedDialysisOptions, SecondaryDialysateSamplingVolume] /. {Null -> 0 Mircoliter}, {LessP[0 Milliliter]}],
				MemberQ[dialysateContainerOutMaxVolume[[3]] - Lookup[roundedDialysisOptions, TertiaryDialysateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}],
				MemberQ[dialysateContainerOutMaxVolume[[4]] - Lookup[roundedDialysisOptions, QuaternaryDialysateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}],
				MemberQ[dialysateContainerOutMaxVolume[[5]] - Lookup[roundedDialysisOptions, QuinaryDialysateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}]
			}
		];

	(*give the corresponding error*)
	invalidConflictingDialysateContainerOutOptions=If[Length[conflictingDialysateContainerOutOptions]>0&&!gatherTests,
		Message[Error::ConflictingDialysateContainerOut,
			conflictingDialysateContainerOutOptions[[All,1]],
			Lookup[roundedDialysisOptions,#]&/@conflictingDialysateContainerOutOptions[[All,3]],
			Lookup[roundedDialysisOptions,#]&/@conflictingDialysateContainerOutOptions[[All,2]]
		];
		{conflictingDialysateContainerOutOptions[[All,2]],conflictingDialysateContainerOutOptions[[All,3]]},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingDialysateContainerOutTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingDialysateContainerOutOptions]==0,
				Test["The DialysateSamplingVolume less than the max volume of the DialysateContainerOut:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDialysateContainerOutOptions]>0,
				Test["The DialysateSamplingVolume less than the max volume of the DialysateContainerOut:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::ConflictingRetentateContainerOut="The maximum volume `1` of the RetentateContainerOut `2` is less than the RetentateSamplingVolume `3` Please choose a larger RetentateContainerOut.";
	*)
	(* Find the min and max volume of the retentate container outs*)
	retentateContainerOutMaxVolume=Map[
		If[MatchQ[#, Null],
			Null,
			Lookup[#, MaxVolume]] &,
		Partition[retentateContainerOutPackets,Length[sampleVolumesAll]],
		{2}
	];

	retentateContainerOutMinVolume=Map[
		If[MatchQ[#, Null],
			Null,
			Lookup[#, MinVolume]] &,
		Partition[retentateContainerOutPackets,Length[sampleVolumesAll]],
		{2}
	];

	(*Check if the retentate sampling volumes can fit in them*)
	conflictingRetentateContainerOutOptions=
		PickList[{{retentateContainerOutMaxVolume[[1]],RetentateSamplingVolume,RetentateSamplingContainerOut},{retentateContainerOutMaxVolume[[2]],SecondaryRetentateSamplingVolume,SecondaryRetentateSamplingContainerOut},{retentateContainerOutMaxVolume[[3]], TertiaryRetentateSamplingVolume,TertiaryRetentateSamplingContainerOut},{retentateContainerOutMaxVolume[[4]], QuaternaryRetentateSamplingVolume,QuaternaryRetentateSamplingContainerOut}},
			{
				MemberQ[retentateContainerOutMaxVolume[[1]] - Lookup[roundedDialysisOptions, RetentateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}],
				MemberQ[retentateContainerOutMaxVolume[[2]] - Lookup[roundedDialysisOptions, SecondaryRetentateSamplingVolume] /. {Null -> 0 Mircoliter}, {LessP[0 Milliliter]}],
				MemberQ[retentateContainerOutMaxVolume[[3]] - Lookup[roundedDialysisOptions, TertiaryRetentateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}],
				MemberQ[retentateContainerOutMaxVolume[[4]] - Lookup[roundedDialysisOptions, QuaternaryRetentateSamplingVolume] /. {Null -> 0 Microliter}, {LessP[0 Milliliter]}]
			}
		];

	(*give the corresponding error*)
	invalidConflictingRetentateContainerOutOptions=If[Length[conflictingRetentateContainerOutOptions]>0&&!gatherTests,
		Message[Error::ConflictingRetentateContainerOut,
			conflictingRetentateContainerOutOptions[[All,1]],
			Lookup[roundedDialysisOptions,#]&/@conflictingRetentateContainerOutOptions[[All,3]],
			Lookup[roundedDialysisOptions,#]&/@conflictingRetentateContainerOutOptions[[All,2]]
		];
		Join[conflictingRetentateContainerOutOptions[[All, 2]],conflictingRetentateContainerOutOptions[[All, 3]]],
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingRetentateContainerOutTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingRetentateContainerOutOptions]==0,
				Test["The RetentateSamplingVolume less than the max volume of the RetentateSamplingContainerOut:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingRetentateContainerOutOptions]>0,
				Test["The RetentateSamplingVolume less than the max volume of the RetentateSamplingContainerOut:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*Error::RetentateSamplingMismatch="The retentate sampling,`1`, is `2`` and the retentate sampling  options `3` are `4``. Please set these options if and only if retentate sampling is True.";
	*)
	(* check if the retentate sampling options match the Retentate sampling bool*)
	retentateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False],
			PickList[
				{{RetentateSampling,RetentateSamplingVolume},{RetentateSampling, RetentateSamplingContainerOut},{RetentateSampling, RetentateSamplingStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{RetentateSampling,RetentateSamplingVolume},{RetentateSampling, RetentateSamplingContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,RetentateSampling],Lookup[roundedDialysisOptions,RetentateSamplingVolume],Lookup[roundedDialysisOptions,RetentateSamplingContainerOut],Lookup[roundedDialysisOptions,RetentateSamplingStorageCondition]}
	];

	(* check if the retentate sampling options match the secondary Retentate sampling bool*)
	secondaryRetentateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False|Null],
			PickList[
				{{SecondaryRetentateSampling,SecondaryRetentateSamplingVolume},{SecondaryRetentateSampling, SecondaryRetentateSamplingContainerOut},{SecondaryRetentateSampling,SecondaryRetentateSamplingStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{SecondaryRetentateSampling,SecondaryRetentateSamplingVolume},{SecondaryRetentateSampling, SecondaryRetentateSamplingContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,SecondaryRetentateSampling],Lookup[roundedDialysisOptions,SecondaryRetentateSamplingVolume],Lookup[roundedDialysisOptions,SecondaryRetentateSamplingContainerOut],Lookup[roundedDialysisOptions,SecondaryRetentateSamplingStorageCondition]}
	];

	(* check if the tertiary retentate sampling options match the Retentate sampling bool*)
	tertiaryRetentateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False|Null],
			PickList[
				{{TertiaryRetentateSampling,TertiaryRetentateSamplingVolume},{TertiaryRetentateSampling, TertiaryRetentateSamplingContainerOut},{TertiaryRetentateSampling, TertiaryRetentateSamplingStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{TertiaryRetentateSampling,TertiaryRetentateSamplingVolume},{TertiaryRetentateSampling, TertiaryRetentateSamplingContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,TertiaryRetentateSampling],Lookup[roundedDialysisOptions,TertiaryRetentateSamplingVolume],Lookup[roundedDialysisOptions,TertiaryRetentateSamplingContainerOut],Lookup[roundedDialysisOptions,TertiaryRetentateSamplingStorageCondition]}
	];

	(* check if the quaternary retentate sampling options match the Retentate sampling bool*)
	quaternaryRetentateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False|Null],
			PickList[
				{{QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume},{QuaternaryRetentateSampling, QuaternaryRetentateSamplingContainerOut},{QuaternaryRetentateSampling, QuaternaryRetentateSamplingStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume},{QuaternaryRetentateSampling, QuaternaryRetentateSamplingContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,QuaternaryRetentateSampling],Lookup[roundedDialysisOptions,QuaternaryRetentateSamplingVolume],Lookup[roundedDialysisOptions,QuaternaryRetentateSamplingContainerOut],Lookup[roundedDialysisOptions,QuaternaryRetentateSamplingStorageCondition]}
	];

	(*put all the conflict togeather*)
	allRetentateSamplingMismatchOptions=Flatten[Join[{retentateSamplingMismatchOptions, secondaryRetentateSamplingMismatchOptions,tertiaryRetentateSamplingMismatchOptions,quaternaryRetentateSamplingMismatchOptions}],2];

	(*throw the error*)
	invalidRetentateSamplingMismatchOptions=If[Length[allRetentateSamplingMismatchOptions]>0&&!gatherTests,
		Message[Error::RetentateSamplingMismatch,
			Transpose[allRetentateSamplingMismatchOptions][[1]],
			Lookup[roundedDialysisOptions,#]&/@Transpose[allRetentateSamplingMismatchOptions][[1]],
			Transpose[allRetentateSamplingMismatchOptions][[2]],
			Lookup[roundedDialysisOptions,#]&/@Transpose[allRetentateSamplingMismatchOptions][[2]]
		];
		allRetentateSamplingMismatchOptions,
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidRetentateSamplingMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[allRetentateSamplingMismatchOptions]==0,
				Test["The RetentateSampling options are Null if the RetentateSampling is False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[allRetentateSamplingMismatchOptions]>0,
				Test["The RetentateSampling options are Null if the RetentateSampling is False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysateSamplingMismatch="The dialysate sampling,`1`, is `2`` and the dialysate sampling  options `3` are `4``. Please set these options if and only if dialysate sampling is True.";
	*)
		(* check if the dialysate sampling options match the dialysate sampling bool*)
	dialysateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False],
			PickList[
				{{DialysateSampling,DialysateSamplingVolume},{DialysateSampling, DialysateContainerOut},{DialysateSampling, DialysateStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{DialysateSampling,DialysateSamplingVolume},{DialysateSampling, DialysateContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,DialysateSampling],Lookup[roundedDialysisOptions,DialysateSamplingVolume],Lookup[roundedDialysisOptions,DialysateContainerOut],dialysateStorageCondition}
	];

	(* check if the secondary dialysate sampling options match the dialysate sampling bool*)
	secondaryDialysateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False],
			PickList[
				{{SecondaryDialysateSampling,SecondaryDialysateSamplingVolume},{SecondaryDialysateSampling, SecondaryDialysateContainerOut},{SecondaryDialysateSampling,SecondaryDialysateStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{SecondaryDialysateSampling,SecondaryDialysateSamplingVolume},{SecondaryDialysateSampling, SecondaryDialysateContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,SecondaryDialysateSampling],Lookup[roundedDialysisOptions,SecondaryDialysateSamplingVolume],Lookup[roundedDialysisOptions,SecondaryDialysateContainerOut],secondaryDialysateStorageCondition}
	];

	(* check if the tertiary dialysate sampling options match the dialysate sampling bool*)
	tertiaryDialysateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False],
			PickList[
				{{TertiaryDialysateSampling,TertiaryDialysateSamplingVolume},{TertiaryDialysateSampling, TertiaryDialysateContainerOut},{TertiaryDialysateSampling, TertiaryDialysateStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{TertiaryDialysateSampling,TertiaryDialysateSamplingVolume},{TertiaryDialysateSampling, TertiaryDialysateContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,TertiaryDialysateSampling],Lookup[roundedDialysisOptions,TertiaryDialysateSamplingVolume],Lookup[roundedDialysisOptions,TertiaryDialysateContainerOut],tertiaryDialysateStorageCondition}
	];

	(* check if the quaternary dialysate sampling options match the dialysate sampling bool*)
	quaternaryDialysateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False],
			PickList[
				{{QuaternaryDialysateSampling,QuaternaryDialysateSamplingVolume},{QuaternaryDialysateSampling, QuaternaryDialysateContainerOut},{QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{QuaternaryDialysateSampling,QuaternaryDialysateSamplingVolume},{QuaternaryDialysateSampling, QuaternaryDialysateContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,QuaternaryDialysateSampling],Lookup[roundedDialysisOptions,QuaternaryDialysateSamplingVolume],Lookup[roundedDialysisOptions,QuaternaryDialysateContainerOut],quaternaryDialysateStorageCondition}
	];

	(* check if the quinary dialysate sampling options match the dialysate sampling bool*)
	quinaryDialysateSamplingMismatchOptions=MapThread[
		Which[
			MatchQ[#1,False|Null],
			PickList[
				{{QuinaryDialysateSampling,QuinaryDialysateSamplingVolume},{QuinaryDialysateSampling, QuinaryDialysateContainerOut},{QuinaryDialysateSampling, QuinaryDialysateStorageCondition}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			MatchQ[#1,True],
			PickList[
				{{QuinaryDialysateSampling,QuinaryDialysateSamplingVolume},{QuinaryDialysateSampling, QuinaryDialysateContainerOut}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null]
				}
			],
			True,
			{}
		]&,
		{Lookup[roundedDialysisOptions,QuinaryDialysateSampling],Lookup[roundedDialysisOptions,QuinaryDialysateSamplingVolume],Lookup[roundedDialysisOptions,QuinaryDialysateContainerOut],quinaryDialysateStorageCondition}
	];

	(* group the conflict togeather*)
	allDialysateSamplingMismatchOptions=Flatten[Join[{dialysateSamplingMismatchOptions, secondaryDialysateSamplingMismatchOptions,tertiaryDialysateSamplingMismatchOptions,quaternaryDialysateSamplingMismatchOptions, quinaryDialysateSamplingMismatchOptions}],2];

	(*throw the error*)
	invalidDialysateSamplingMismatchOptions=If[Length[allDialysateSamplingMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysateSamplingMismatch,
			Transpose[allDialysateSamplingMismatchOptions][[1]],
			Lookup[roundedDialysisOptions,#]&/@Transpose[allDialysateSamplingMismatchOptions][[1]],
			Transpose[allDialysateSamplingMismatchOptions][[2]],
			Lookup[roundedDialysisOptions,#]&/@Transpose[allDialysateSamplingMismatchOptions][[2]]
		];
		allDialysateSamplingMismatchOptions,
		Nothing
	];


	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysateSamplingMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[allDialysateSamplingMismatchOptions]==0,
				Test["The DialysateSampling options are Null if the DialysateSampling is False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[allDialysateSamplingMismatchOptions]>0,
				Test["The DialysateSampling options are Null if the DialysateSampling is False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*Error::NumberOfDialysisRoundsMismatch="The NumberOfDialysisRounds is `1` however the dialysis options for rounds going beyond this number `2` are set. Please set these options to automatic or increase the NumberOfDialysisRounds.";
	*)

	(*check if there are options set past the user provided NumberOfDialysisRounds*)
	numberOfDialysisRoundsMismatchOptions=Which[
		(*4 rounds*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],4],
		PickList[
			{
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut
			},
			MemberQ[Flatten[ToList[Lookup[roundedDialysisOptions,#]]],Except[Automatic|Null|False]]&/@ {
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut
			}
		],
		(*3 rounds*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],3],
		PickList[
			{
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition
			},
			MemberQ[Flatten[ToList[Lookup[roundedDialysisOptions,#]]],Except[Automatic|Null|False]]&/@ {
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition
			}
		],
		(*2 rounds*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],2],
		PickList[
			{
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume, TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition
			},
			MemberQ[Flatten[ToList[Lookup[roundedDialysisOptions,#]]],Except[Automatic|Null|False]]&/@ {
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume,  TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition
			}
		],
		(*1 round*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],1],
		PickList[
			{
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume,  TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysisMixRate,SecondaryDialysateContainer,SecondaryDialysate,SecondaryDialysateVolume,SecondaryDialysateSamplingVolume, SecondaryDialysateSampling, SecondaryDialysateStorageCondition,SecondaryDialysateContainerOut,SecondaryRetentateSampling,SecondaryRetentateSamplingVolume, SecondaryRetentateSamplingContainerOut,SecondaryRetentateSamplingStorageCondition
			},
			MemberQ[Flatten[ToList[Lookup[roundedDialysisOptions,#]]],Except[Automatic|Null|False]]&/@ {
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume,  TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysisMixRate,SecondaryDialysateContainer,SecondaryDialysate,SecondaryDialysateVolume,SecondaryDialysateSamplingVolume, SecondaryDialysateSampling, SecondaryDialysateStorageCondition,SecondaryDialysateContainerOut,SecondaryRetentateSampling,SecondaryRetentateSamplingVolume, SecondaryRetentateSamplingContainerOut,SecondaryRetentateSamplingStorageCondition
			}
		],
		(*Automatic*)
		True,
		{}
	];

	(*throw the corresponding error*)
	invalidNumberOfDialysisRoundsMismatchOptions=If[Length[numberOfDialysisRoundsMismatchOptions]>0&&!gatherTests,
		Message[Error::NumberOfDialysisRoundsMismatch,Lookup[roundedDialysisOptions,NumberOfDialysisRounds],numberOfDialysisRoundsMismatchOptions];
		{NumberOfDialysisRounds,numberOfDialysisRoundsMismatchOptions},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNumberOfDialysisRoundsMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[numberOfDialysisRoundsMismatchOptions]==0,
				Test["The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[numberOfDialysisRoundsMismatchOptions]>0,
				Test["The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::NumberOfDialysisRoundsNullMismatch="The NumberOfDialysisRounds is `1` however the dialysis options for rounds `2` are Null. Please set these options or decrease the NumberOfDialysisRounds.";
	*)
	(*find user provoded dialysis round or the largest dialysis round that has user provided dialysis round option*)
	largestNumberOfDialysisRounds=Which[
		(*Is NumberOfDialysisRounds Set?*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],Except[Automatic]],
		Lookup[roundedDialysisOptions,NumberOfDialysisRounds],
		(*Are any of the options for round 5 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut}]],Except[Automatic|Null|False]],
		5,
		(*Are any of the options for round 4 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		4,
		(*Are any of the options for round 3 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume, TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		3,
		(*Are any of the options for round 2 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysisMixRate,SecondaryDialysateContainer,SecondaryDialysate,SecondaryDialysateVolume,SecondaryDialysateSamplingVolume, SecondaryDialysateSampling, SecondaryDialysateStorageCondition,SecondaryDialysateContainerOut,SecondaryRetentateSampling,SecondaryRetentateSamplingVolume, SecondaryRetentateSamplingContainerOut,SecondaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		2,
		True,
		1
	];

	(*check if required options are set to Null in and below the largestNumberOfDialysisRounds*)
	numberOfDialysisRoundsNullMismatchOptions=Which[
		(*5 rounds*)
		Or[MatchQ[largestNumberOfDialysisRounds,5],MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],5]],
		PickList[
			{
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysate,QuinaryDialysateVolume,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysate,QuaternaryDialysateVolume,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			},
			MemberQ[ToList[Lookup[roundedDialysisOptions,#]],Null]&/@ {
				QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysate,QuinaryDialysateVolume,
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysate,QuaternaryDialysateVolume,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			}
		],
		(*4 rounds*)
		Or[MatchQ[largestNumberOfDialysisRounds,4],MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],4]],
		PickList[
			{
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysate,QuaternaryDialysateVolume,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			},
			MemberQ[ToList[Lookup[roundedDialysisOptions,#]],Null]&/@ {
				QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysate,QuaternaryDialysateVolume,
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			}
		],
		(*3 rounds*)
		Or[MatchQ[largestNumberOfDialysisRounds,3],MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],3]],
		PickList[
			{
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			},
			MemberQ[ToList[Lookup[roundedDialysisOptions,#]],Null]&/@ {
				TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysate,TertiaryDialysateVolume,
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			}
		],
		(*2 rounds*)
		Or[MatchQ[largestNumberOfDialysisRounds,2],MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],2]],
		PickList[
			{
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			},
			MemberQ[ToList[Lookup[roundedDialysisOptions,#]],Null]&/@ {
				SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysate,SecondaryDialysateVolume
			}
		],
		(*Automatic*)
		True,
		{}
	];

	(*throw the corresponding error*)
	invalidNumberOfDialysisRoundsNullMismatchOptions=If[Length[numberOfDialysisRoundsNullMismatchOptions]>0&&!gatherTests,
		Message[Error::NumberOfDialysisRoundsNullMismatch,Lookup[roundedDialysisOptions,NumberOfDialysisRounds],numberOfDialysisRoundsNullMismatchOptions];
		{NumberOfDialysisRounds,numberOfDialysisRoundsNullMismatchOptions},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNumberOfDialysisRoundsNullMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[numberOfDialysisRoundsNullMismatchOptions]==0,
				Test["The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds by being Null:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[numberOfDialysisRoundsNullMismatchOptions]>0,
				Test["The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds by being Null:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::NumberOfDialysisRoundsEquilibriumMismatch="The NumberOfDialysisRounds is `1` however the DialysisMethod is EquilibriumDialysis. Please set these NumberOfDialysisRounds to 1.";*)
	(*If the number of dialysi rounds is greater than one and it is equilibrium dialysis throw the corresponding error*)
	numberOfDialysisRoundsEquilibriumlMismatchOptions=If[MatchQ[largestNumberOfDialysisRounds,GreaterP[1]]&&MatchQ[Lookup[roundedDialysisOptions,DialysisMethod],EquilibriumDialysis]&&!gatherTests,
		{NumberOfDialysisRounds},
		{}
	];

	invalidNumberOfDialysisRoundsEquilibriumlMismatchOptions=If[Length[numberOfDialysisRoundsEquilibriumlMismatchOptions]>0&&!gatherTests,
		Message[Error::NumberOfDialysisRoundsEquilibriumMismatch,largestNumberOfDialysisRounds];
		{NumberOfDialysisRounds},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNumberOfDialysisRoundsNullMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[numberOfDialysisRoundsEquilibriumlMismatchOptions]==0,
				Test["The NumberOfDialysisRounds is not greater than 1 if the DialysisMethod is EquilibriumDialysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[numberOfDialysisRoundsEquilibriumlMismatchOptions]>0,
				Test["The NumberOfDialysisRounds is not greater than 1 if the DialysisMethod is EquilibriumDialysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*Error::DialysisMembraneMWCOMismatch="The MolecularWeightCutoff, `1`, does not match the MoleccularWeightCutoff, `2`, of the DialysisMembrane, `3`.";
	*)

	(*lookup the MWCO of the provided membrane*)
	membraneMWCO=If[MatchQ[#,Null],#,Lookup[First[#],MolecularWeightCutoff]]&/@allMembraneModelPackets;

	(*check if the membranes MWCO matches the user provided MWCO*)
	missingDialysisMembraneMWCOOptions= MapThread[
		If[
			MatchQ[#1,Except[Automatic]]&&MatchQ[#2,Except[Automatic]]&&!MatchQ[#3,#2],
			{#2,#3,#1},
			Nothing
		]&,
		{Lookup[roundedDialysisOptions,DialysisMembrane],Lookup[roundedDialysisOptions,MolecularWeightCutoff], membraneMWCO}
	];

	(*throw the corresponding error*)
	invalidMissingDialysisMembraneMWCOOptions=If[Length[missingDialysisMembraneMWCOOptions]>0&&!gatherTests,
		Message[Error::DialysisMembraneMWCOMismatch,
			missingDialysisMembraneMWCOOptions[[All,1]],
			missingDialysisMembraneMWCOOptions[[All,2]],
			missingDialysisMembraneMWCOOptions[[All,3]]
		];
		{DialysisMembrane, MolecularWeightCutoff},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidMissingDialysisMembraneMWCOTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingDialysisMembraneMWCOOptions]==0,
				Test["The MolecularWeightCutoff of Dialysis membrane matches the specified MolecularWeightCutoff:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDialysisMembraneMWCOOptions]>0,
				Test["The MolecularWeightCutoff of Dialysis membrane matches the specified MolecularWeightCutoff:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::DialysisMembraneSoakMismatch="DialysisMembraneSoak is set to `1`, however the options for the dialysis membrane soak, `2`, are set to `3`. Please set these options if and only if DialysisMembraneSoak to True.";
*)
	(*check if the sock options conflict with the soak bool*)
	dialysisMembraneSoakMismatchOptions=Flatten[MapThread[
		If[
			MatchQ[#1,False],
			PickList[
				{{DialysisMembraneSoak,DialysisMembraneSoakTime},{DialysisMembraneSoak,DialysisMembraneSoakVolume},{DialysisMembraneSoak, DialysisMembraneSoakSolution}},
				{
					MatchQ[#2,Except[Null|Automatic]],
					MatchQ[#3,Except[Null|Automatic]],
					MatchQ[#4,Except[Null|Automatic]]
				}
			],
			PickList[
				{{DialysisMembraneSoak,DialysisMembraneSoakTime},{DialysisMembraneSoak,DialysisMembraneSoakVolume},{DialysisMembraneSoak, DialysisMembraneSoakSolution}},
				{
					MatchQ[#2,Null],
					MatchQ[#3,Null],
					MatchQ[#4,Null]
				}
			]
		]&,
		{Lookup[roundedDialysisOptions,DialysisMembraneSoak],Lookup[roundedDialysisOptions,DialysisMembraneSoakTime],Lookup[roundedDialysisOptions,DialysisMembraneSoakVolume],Lookup[roundedDialysisOptions,DialysisMembraneSoakSolution]}
	],1];

	(*throw the corrseponding error*)
	invalidDialysisMembraneSoakMismatchOptions=If[Length[dialysisMembraneSoakMismatchOptions]>0&&!gatherTests,
		Message[Error::DialysisMembraneSoakMismatch,
			Lookup[roundedDialysisOptions,DialysisMembraneSoak],
			dialysisMembraneSoakMismatchOptions[[All,2]],
			Lookup[roundedDialysisOptions,#]&/@dialysisMembraneSoakMismatchOptions[[All,2]]
		];
		dialysisMembraneSoakMismatchOptions,
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysisMembraneSoakMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dialysisMembraneSoakMismatchOptions]==0,
				Test["The DialysisMembraneSoak options are not populated if DialysisMembraneSoak is False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[dialysisMembraneSoakMismatchOptions]>0,
				Test["The DialysisMembraneSoak options are not populated if DialysisMembraneSoak is False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*)Error::ConflictingDialysateContainerMixType="The DialysateContainer `1` cannot be used with the DialysisMixType `2`. Please choose a beaker as a container of set DialysisMixType to Null.";
*)
	(*check if DialysateContainer can handle a stir bar if needed*)
	conflictingDialysateContainerMixOptions= If[
		MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Stir]&&
		  MemberQ[
			  {
				  Lookup[roundedDialysisOptions,DialysateContainer],
				  Lookup[roundedDialysisOptions,SecondaryDialysateContainer],
				  Lookup[roundedDialysisOptions,TertiaryDialysateContainer],
				  Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],
				  Lookup[roundedDialysisOptions,QuinaryDialysateContainer]
			  },
			  Except[ObjectP[supportedDialysateContainers]|Automatic]
		  ],
		PickList[
			{DialysateContainer,SecondaryDialysateContainer,TertiaryDialysateContainer,QuaternaryDialysateContainer,QuinaryDialysateContainer},
			MatchQ[Lookup[roundedDialysisOptions,#],Except[ObjectP[supportedDialysateContainers]|Automatic]]&/@ {DialysateContainer,SecondaryDialysateContainer,TertiaryDialysateContainer,QuaternaryDialysateContainer,QuinaryDialysateContainer}
		],
		{}
	];

	(*throw an error*)
	invalidDialysateContainerMixOptions=If[Length[conflictingDialysateContainerMixOptions]>0&&!gatherTests,
		Message[Error::ConflictingDialysateContainerMixType,Lookup[roundedDialysisOptions,conflictingDialysateContainerMixOptions], Lookup[roundedDialysisOptions,DialysisMixType]];
		{conflictingDialysateContainerMixOptions,DialysateContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidDialysateContainerMixTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingDialysateContainerMixOptions]==0,
				Test["The DialysateContainer is compatible with the DialysisMixType:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDialysateContainerMixOptions]>0,
				Test["The DialysateContainer is compatible with the DialysisMixType:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentDialysis, roundedDialysisOptions];

	(*-- Switch Options--*)

	(*NumberOfDialysisRounds*)
	resolvednumberOfDialysisRounds=Which[
		(*Is NumberOfDialysisRounds Set?*)
		MatchQ[Lookup[roundedDialysisOptions,NumberOfDialysisRounds],Except[Automatic]],
		Lookup[roundedDialysisOptions,NumberOfDialysisRounds],
		(*Are any of the options for round 5 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{QuinaryDialysisTime,QuinaryDialysateTemperature,QuinaryDialysisMixRate,QuinaryDialysateContainer,QuinaryDialysate,QuinaryDialysateVolume, QuinaryDialysateSamplingVolume, QuinaryDialysateSampling, QuinaryDialysateStorageCondition, QuinaryDialysateContainerOut}]],Except[Automatic|Null|False]],
		5,
		(*Are any of the options for round 4 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{QuaternaryDialysisTime,QuaternaryDialysateTemperature,QuaternaryDialysisMixRate,QuaternaryDialysateContainer,QuaternaryDialysate,QuaternaryDialysateVolume,QuaternaryDialysateSamplingVolume, QuaternaryDialysateSampling, QuaternaryDialysateStorageCondition,QuaternaryDialysateContainerOut,QuaternaryRetentateSampling,QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut,QuaternaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		4,
		(*Are any of the options for round 3 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{TertiaryDialysisTime,TertiaryDialysateTemperature,TertiaryDialysisMixRate,TertiaryDialysateContainer,TertiaryDialysate,TertiaryDialysateVolume,TertiaryDialysateSamplingVolume, TertiaryDialysateSampling, TertiaryDialysateStorageCondition,TertiaryDialysateContainerOut,TertiaryRetentateSampling,TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut,TertiaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		3,
		(*Are any of the options for round 2 set?*)
		MemberQ[Flatten[Lookup[roundedDialysisOptions,{SecondaryDialysisTime,SecondaryDialysateTemperature,SecondaryDialysisMixRate,SecondaryDialysateContainer,SecondaryDialysate,SecondaryDialysateVolume,SecondaryDialysateSamplingVolume, SecondaryDialysateSampling, SecondaryDialysateStorageCondition,SecondaryDialysateContainerOut,SecondaryRetentateSampling,SecondaryRetentateSamplingVolume, SecondaryRetentateSamplingContainerOut,SecondaryRetentateSamplingStorageCondition}]],Except[Automatic|Null|False]],
		2,
		(*Is DialysisMethod StaticDialysis?*)
		MatchQ[resolveddialysisMethod,StaticDialysis],
		3,
		True,
		1
	];

	(*DynamicDialysisMethod*)
	resolveddynamicDialysisMethod=Which[
		(*Is DynamicDialysisMethod Set?*)
		MatchQ[Lookup[roundedDialysisOptions,DynamicDialysisMethod],Except[Automatic]],
		Lookup[roundedDialysisOptions,DynamicDialysisMethod],
		(*Is DialysisMethod not DynamicDialysis?*)
		MatchQ[resolveddialysisMethod,Except[DynamicDialysis]],
		Null,
		(*Is FlowRate*DialysisTime>(DialysisVolume-Deadvolume(1.7L)) in any round?*)
		Or[
			MemberQ[MapThread[
				#1*#2>(#3-1.7Liter)&,
				{
					If[!MatchQ[#,Automatic],#,5Milliliter/Minute]&/@Lookup[mapThreadFriendlyOptions,FlowRate],
					If[!MatchQ[#,Automatic],#,1Minute]&/@Lookup[mapThreadFriendlyOptions,DialysisTime],
					If[!MatchQ[#,Automatic],#,10Liter]&/@Lookup[mapThreadFriendlyOptions,DialysateVolume]
				}
			],True],
			MemberQ[MapThread[
				#1*#2>#3&,
				{
					If[!MatchQ[#,Automatic],#,5Milliliter/Minute]&/@Lookup[mapThreadFriendlyOptions,FlowRate],
					If[!MatchQ[#,Automatic],#,1Minute]&/@Lookup[mapThreadFriendlyOptions,SecondaryDialysisTime],
					If[!MatchQ[#,Automatic],#,10Liter]&/@Lookup[mapThreadFriendlyOptions,SecondaryDialysateVolume]
				}
			],True],
			MemberQ[MapThread[
				#1*#2>#3&,
				{
					If[!MatchQ[#,Automatic],#,5Milliliter/Minute]&/@Lookup[mapThreadFriendlyOptions,FlowRate],
					If[!MatchQ[#,Automatic],#,1Minute]&/@Lookup[mapThreadFriendlyOptions,TertiaryDialysisTime],
					If[!MatchQ[#,Automatic],#,10Liter]&/@Lookup[mapThreadFriendlyOptions,TertiaryDialysateVolume]
				}
			],True],
			MemberQ[MapThread[
				#1*#2>#3&,
				{
					If[!MatchQ[#,Automatic],#,5Milliliter/Minute]&/@Lookup[mapThreadFriendlyOptions,FlowRate],
					If[!MatchQ[#,Automatic],#,1Minute]&/@Lookup[mapThreadFriendlyOptions,QuaternaryDialysisTime],
					If[!MatchQ[#,Automatic],#,10Liter]&/@Lookup[mapThreadFriendlyOptions,QuaternaryDialysateVolume]
				}
			],True],
			MemberQ[MapThread[
				#1*#2>#3&,
				{
					If[!MatchQ[#,Automatic],#,5Milliliter/Minute]&/@Lookup[mapThreadFriendlyOptions,FlowRate],
					If[!MatchQ[#,Automatic],#,1Minute]&/@Lookup[mapThreadFriendlyOptions,QuinaryDialysisTime],
					If[!MatchQ[#,Automatic],#,10Liter]&/@Lookup[mapThreadFriendlyOptions,QuinaryDialysateVolume]
				}
			],True]
		],
		Recirculation,
		True,
		SinglePass
	];

	(*FlowRate*)
	impossibleFlowRate=False;
	resolvedflowRate=Which[
		(*Is FlowRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,FlowRate],Except[Automatic]],
		(*check to see if the given flow rate will run out of dialysate*)
		impossibleFlowRate=If[
			Or[
				MemberQ[MapThread[
					(#2-1.7Liter)/#1<Lookup[roundedDialysisOptions,FlowRate]&,
					{
						Flatten[{Lookup[roundedDialysisOptions,DialysisTime]/.{Automatic->1Minute}}],
						Flatten[{Min[Lookup[mapThreadFriendlyOptions,DialysateVolume]/.{Automatic->10Liter}]}]
					}
				],True],
				MemberQ[MapThread[
					#2/#1<Lookup[roundedDialysisOptions,FlowRate]&,
					{
						Flatten[{
							Lookup[roundedDialysisOptions,SecondaryDialysisTime]/.{Automatic->1Minute},
							Lookup[roundedDialysisOptions,TertiaryDialysisTime]/.{Automatic->1Minute},
							Lookup[roundedDialysisOptions,QuaternaryDialysisTime]/.{Automatic->1Minute},
							Lookup[roundedDialysisOptions,QuinaryDialysisTime]/.{Automatic->1Minute}
						}],
						Flatten[{
							Min[Lookup[mapThreadFriendlyOptions,SecondaryDialysateVolume]/.{Automatic->10Liter}],
							Min[Lookup[mapThreadFriendlyOptions,TertiaryDialysateVolume]/.{Automatic->10Liter}],
							Min[Lookup[mapThreadFriendlyOptions,QuaternaryDialysateVolume]/.{Automatic->10Liter}],
							Min[Lookup[mapThreadFriendlyOptions,QuinaryDialysateVolume]/.{Automatic->10Liter}]
						}]
					}
				],True]
			]&&MatchQ[resolveddynamicDialysisMethod,SinglePass],
			True,
			False
		];
		Lookup[roundedDialysisOptions,FlowRate],
		(*Is DialysisMethod not Dynamic?*)
		!MatchQ[resolveddialysisMethod,DynamicDialysis],
		Null,
		(*Is DynamicDialysisMethod Recirculating?*)
		MatchQ[resolveddynamicDialysisMethod,Recirculating],
		25 Milliliter/Minute,
		(*Are both DialysisTime and DialysateVolume automatic?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisTime],Automatic]&&!MemberQ[Lookup[roundedDialysisOptions,DialysateVolume],Except[Automatic]],
		25 Milliliter/Minute,
		(*Is is possible to run out of DialysateVolume at the lowest FlowRate?*)
		Or[
			MemberQ[MapThread[
				(#2-1.7Liter)/#1<5 Milliliter/Minute&,
				{
					(*Time*)
					Flatten[{
						Lookup[roundedDialysisOptions,DialysisTime]/.{Automatic->1Minute}
					}],
					(*Volume*)
					Flatten[{
						Min[Lookup[mapThreadFriendlyOptions,DialysateVolume]/.{Automatic->10Liter}]
					}]
				}
			],True],
			MemberQ[MapThread[
				#2/#1<5 Milliliter/Minute&,
				{
					(*Time*)
					Flatten[{
						Lookup[roundedDialysisOptions,SecondaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,TertiaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,QuaternaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,QuinaryDialysisTime]/.{Automatic->1Minute}
					}],
					(*Volume*)
					Flatten[{
						Min[Lookup[mapThreadFriendlyOptions,SecondaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,TertiaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,QuaternaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,QuinaryDialysateVolume]/.{Automatic->10Liter}]
					}]
				}
			],True]
		],
		impossibleFlowRate=True;
		5 Milliliter/Minute,
		(*highest possible FlowRate under 25 Milliliter/Min?*)
		MemberQ[MapThread[
			(#2-1.7Liter)/#1<25 Milliliter/Minute&,
			{
				Flatten[{
					Lookup[roundedDialysisOptions,DialysisTime]/.{Automatic->1Minute},
					Lookup[roundedDialysisOptions,SecondaryDialysisTime]/.{Automatic->1Minute},
					Lookup[roundedDialysisOptions,TertiaryDialysisTime]/.{Automatic->1Minute},
					Lookup[roundedDialysisOptions,QuaternaryDialysisTime]/.{Automatic->1Minute},
					Lookup[roundedDialysisOptions,QuinaryDialysisTime]/.{Automatic->1Minute}
				}],
				Flatten[{
					Min[Lookup[mapThreadFriendlyOptions,DialysateVolume]/.{Automatic->10Liter}],
					Min[Lookup[mapThreadFriendlyOptions,SecondaryDialysateVolume]/.{Automatic->10Liter}],
					Min[Lookup[mapThreadFriendlyOptions,TertiaryDialysateVolume]/.{Automatic->10Liter}],
					Min[Lookup[mapThreadFriendlyOptions,QuaternaryDialysateVolume]/.{Automatic->10Liter}],
					Min[Lookup[mapThreadFriendlyOptions,QuinaryDialysateVolume]/.{Automatic->10Liter}]
				}]
			}
		],True],
		SafeRound[Convert[
			Min[MapThread[
				(#2-1.7Liter)/#1&,
				{
					Flatten[{
						Lookup[roundedDialysisOptions,DialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,SecondaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,TertiaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,QuaternaryDialysisTime]/.{Automatic->1Minute},
						Lookup[roundedDialysisOptions,QuinaryDialysisTime]/.{Automatic->1Minute}
					}],
					Flatten[{
						Min[Lookup[mapThreadFriendlyOptions,DialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,SecondaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,TertiaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,QuaternaryDialysateVolume]/.{Automatic->10Liter}],
						Min[Lookup[mapThreadFriendlyOptions,QuinaryDialysateVolume]/.{Automatic->10Liter}]
					}]
				}
			]],
			Milliliter/Minute],0.1 Milliliter/Minute],
		(*If not, set it to the max*)
		True,
		25 Milliliter/Minute
	];

	(*if the needed flow rate is not possible throw an error*)
	invalidImpossibleFlowRateOptions=If[impossibleFlowRate&&!gatherTests,
		Message[Error::UnachievableDialysisFlowRate,
			Lookup[roundedDialysisOptions,DynamicDialysisMethod],
			Lookup[roundedDialysisOptions,DialysisTime],
			Lookup[roundedDialysisOptions,DialysateVolume],
			Lookup[roundedDialysisOptions,FlowRate]
		];
		{DynamicDialysisMethod,DialysisTime,DialysateVolume,FlowRate},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidImpossibleFlowRateTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[!impossibleFlowRate,
				Test["It is possible to acheive a flow rate that will not runout of Dialysate for SinglePass DynmanicDyalysis:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[impossibleFlowRate,
				Test["It is possible to acheive a flow rate that will not runout of Dialysate for SinglePass DynmanicDyalysis:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*ImageSystem*)
	resolvedimageSystem=Which[
		(*Is ImageSystem Set?*)
		MatchQ[imageSystem,Except[Automatic]],
		imageSystem,
		(*Is DynamicDialysis Set?*)
		MatchQ[resolveddialysisMethod,DynamicDialysis],
		True,
		(*NA*)
		True,
		Null
	];
	(*
	(*ImagingInterval*)
	resolvedimagingInterval=Which[
		(*Is ImagingInterval Set?*)
		MatchQ[Lookup[roundedDialysisOptions,ImagingInterval],Except[Automatic]],
		Lookup[roundedDialysisOptions,ImagingInterval],
		(*Is ImageSystem True?*)
		MatchQ[resolvedimageSystem,True],
		1 Hour,
		True,
		Null
	];*)

	(*ShareDialysateContainer *)
	resolvedshareDialysateContainer=Which[
		(*Is ShareDialysateContainer Set?*)
		MatchQ[Lookup[roundedDialysisOptions,ShareDialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,ShareDialysateContainer],
		(*Is DialysisMethod StaticDialysis?*)
		MatchQ[resolveddialysisMethod,StaticDialysis],
		True,
		(* everything else*)
		True,
		False
	];

	(* do our first MapThread to resolve membrane specific options*)
	{
		resolveddialysisMembrane, noAvailableDialysisMembraneErrors, resolvedmolecularWeightCutoff, resolvedsampleVolume, resolveddialysisMembraneSoak, resolveddialysisMembraneSoakSolution,resolveddialysisMembraneSoakVolume, resolveddialysisMembraneSoakTime
	} = Transpose[MapThread[
		Function[{options, sampleVolumes, entiresampleVolumes, sample},
			Module[
				{dialysisMembrane, specifieddialysisMembrane, specifiedMWCO, noAvailableDialysisMembraneError, molecularWeightCutOff, sampleVolume,
					membraneMaxVolume, dialysisMembraneSoak, dialysisMembraneSoakSolution,dialysisMembraneSoakVolume, dialysisMembraneSoakTime,
					preSoak, recommendedSoakTime, recommendedSoakSolution, recommendedSoakVolume, sampleDivisionFactor,potentialMembranes},

				(* set our error checking variables *)
				noAvailableDialysisMembraneError = False;

				(* pull out what was specified *)
				{specifieddialysisMembrane, specifiedMWCO} = Lookup[options, {DialysisMembrane,MolecularWeightCutoff}];

				(*-------------------------------------------------- DialysisMembrane-----------------------------------------------------*)

				dialysisMembrane=Which[
					(*Is it set?*)
					MatchQ[specifieddialysisMembrane,Except[Automatic]],
					specifieddialysisMembrane,
					(*--Dynamic Dialysis--*)
					MatchQ[resolveddialysisMethod,DynamicDialysis],
					If[
						(*Was the MWCO specified?*)
						MatchQ[specifiedMWCO,Except[Automatic]],
						(*Is there a Model[Item,DialysisMembrane] with the specified MolecularWeightCutoff?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane],
								MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01],
								VolumePerLength->GreaterP[Min[sampleVolumes/.{Automatic->30Milliliter},130Milliliter]/(0.4Meter)]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							Lookup[First[potentialMembranes],Object],
							noAvailableDialysisMembraneError=True;
							Null
						],
						(*Is there any Model[Item,DialysisMembrane]?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane],
								VolumePerLength->GreaterP[Min[sampleVolumes/.{Automatic->30Milliliter},130Milliliter]/(0.4Meter)]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							(*take the largest flatwidth*)
							Lookup[First[
								Sort[
									potentialMembranes,
									Lookup[#1, FlatWidth] > Lookup[#2, FlatWidth] &]
							],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
					(*--Equilibrium Dialysis--*)
					(*If a volume is given*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis]&&MatchQ[sampleVolumes,Except[Automatic]],
					(*Is there a Model[Container,Plate, Dialysis] with the specified MolecularWeightCutoff?*)
					If[
						(*Was the MWCO specified?*)
						MatchQ[specifiedMWCO,Except[Automatic]],
						(*Is there a Model[Container,Plate,Dialysis] with the specified MolecularWeightCutoff?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Container,Plate,Dialysis],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01],MinVolume->LessP[sampleVolumes],MaxVolume->GreaterEqualP[(sampleVolumes-250*Microliter)]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							Lookup[First[potentialMembranes],Object],
							noAvailableDialysisMembraneError=True;
							Null
						],
						(*Is there any Model[Container,Dialysis]?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Container,Plate,Dialysis],MinVolume->Min[sampleVolumes],MaxVolume->GreaterEqualP[(sampleVolumes+250*Microliter)]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							(*take the smallest MWCO*)
							Lookup[First[
								Sort[
									potentialMembranes,
									Lookup[#1, MolecularWeightCutoff] < Lookup[#2, MolecularWeightCutoff] &]
							],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
					(*No volume is given*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					(*Is there a Model[Container,Plate, Dialysis] with the specified MolecularWeightCutoff?*)
					If[
						(*Was the MWCO specified?*)
						MatchQ[specifiedMWCO,Except[Automatic]],
						(*Is there a Model[Container,Plate,Dialysis] with the specified MolecularWeightCutoff?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Container,Plate,Dialysis],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							Lookup[First[potentialMembranes],Object],
							noAvailableDialysisMembraneError=True;
							Null
						],
						(*Is there a Model[Container,Dialysis]?*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Container,Plate,Dialysis]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							(*take the smallest MWCO*)
							Lookup[First[
								Sort[
									potentialMembranes,
									Lookup[#1, MolecularWeightCutoff] < Lookup[#2, MolecularWeightCutoff] &
								]
							],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
					(*--Static Dialysis--*)
					(*Was the MWCO and sample volume specified?*)
					MatchQ[resolveddialysisMethod,StaticDialysis]&&MatchQ[specifiedMWCO,Except[Automatic]]&&MatchQ[sampleVolumes,Except[Automatic]],
					(*Is there a Model[Container,Vessel, Dialysis] with the specified MolecularWeightCutoff and can fit the sample?*)
					potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Type->Model[Container,Vessel,Dialysis],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01],MinVolume->LessP[sampleVolumes],MaxVolume->GreaterP[sampleVolumes]
						}]
					]];
					If[
						Length[potentialMembranes]>0,
						(*take the smallest*)
						Lookup[First[
							Sort[
								potentialMembranes,
								Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &
							]
						],Object],
						(*look for a tube to fill it*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							Lookup[First[potentialMembranes],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
					(*Was the MWCO specified but not the sample volume?*)
					MatchQ[resolveddialysisMethod,StaticDialysis]&&MatchQ[specifiedMWCO,Except[Automatic]],
					(*Is there a Model[Container,Vessel, Dialysis] with the specified MolecularWeightCutoff and can fit the sample?*)
					potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Type->Model[Container,Vessel,Dialysis],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01],MinVolume->LessP[entiresampleVolumes],MaxVolume->GreaterP[entiresampleVolumes]
						}]
					]];
					If[
						Length[potentialMembranes]>0,
						(*take the smallest*)
						Lookup[First[
							Sort[
								potentialMembranes,
								Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &
							]
						],Object],
						(*look for a tube to fill it*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane],MolecularWeightCutoff->RangeP[specifiedMWCO*0.99,specifiedMWCO*1.01]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							Lookup[First[potentialMembranes],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
					(*Was the samplevolume specified but not the mwco?*)
					MatchQ[resolveddialysisMethod,StaticDialysis]&&MatchQ[sampleVolumes,Except[Automatic]],
					(*Can any vessel hold it*)
					potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Type->Model[Container,Vessel,Dialysis],MinVolume->LessP[sampleVolumes],MaxVolume->GreaterP[sampleVolumes]
						}]
					]];
					If[
						Length[potentialMembranes]>0,
						(*take the smallest one that can hold*)
						Lookup[First[
							Sort[
								potentialMembranes,
								Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &
							]
						],Object],
						(*look for a membrane tube*)
						(*look for a tube to fill it*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							(*take the largest flat width*)
							Lookup[First[
								Sort[
									potentialMembranes,
									Lookup[#1, FlatWidth] > Lookup[#2, FlatWidth] &
								]
							],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
					],
						(*Every other case*)
					True,
						(*just go by the samples full volume*)
					potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Type->Model[Container,Vessel,Dialysis],MinVolume->LessP[entiresampleVolumes],MaxVolume->GreaterP[entiresampleVolumes]
						}]
					]];
					If[
						Length[potentialMembranes]>0,
						(*take the smallest container*)
						Lookup[First[
							Sort[
								potentialMembranes,
								Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &
							]
						],Object],
						(*look for a membrane tube*)
						(*look for a tube to fill it*)
						potentialMembranes=DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Item,DialysisMembrane]
							}]
						]];
						If[
							Length[potentialMembranes]>0,
							(*take the largest flatwidth*)
							Lookup[First[
								Sort[
									potentialMembranes,
								Lookup[#1, FlatWidth] > Lookup[#2, FlatWidth] &]
							],Object],
							noAvailableDialysisMembraneError=True;
							Null
						]
						]

				];

				(*-------------------------------------------------- MolecularWeightCutoff -----------------------------------------------------*)
				molecularWeightCutOff=Which[
					(*Is it set?*)
					MatchQ[specifiedMWCO,Except[Automatic]],
					specifiedMWCO,
					(*did finding a membrane fail?*)
					MatchQ[dialysisMembrane,Null],
					Null,
					(*MWCO of resolved dialysisMembrane*)
					True,
					Nearest[
						(* Round to nearest DialysisMolecularWeightCutoffP because that is what our pattern DialysisMolecularWeightCutoffP allows for the option *)
						List@@DialysisMolecularWeightCutoffP,
						Lookup[
							First[
								DeleteDuplicates[
									Cases[
										inheritedCache,
										KeyValuePattern[{Object->ObjectP[dialysisMembrane]}]
									]
								]
							],
							MolecularWeightCutoff
						]
					][[1]]
				];

				(*Take out important info about our resolved membrane*)
				(*maxvolume*)
				membraneMaxVolume=Which[
					(*if it is a Null*)
					MatchQ[dialysisMembrane, Null],
					Null,
					(*if it is a tube and static*)
					MatchQ[dialysisMembrane, ObjectP[Model[Item,DialysisMembrane]]]&&MatchQ[resolveddialysisMethod,StaticDialysis],
					30Milliliter,
					(*if it is a tube and dynamic*)
					MatchQ[dialysisMembrane, ObjectP[Model[Item,DialysisMembrane]]]&&MatchQ[resolveddialysisMethod,DynamicDialysis],
					Min[Lookup[First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[dialysisMembrane]
						}]
					]]],VolumePerLength]*.4 Meter,130Milliliter],
					(*if it is a Equilibrium dialysis plate?*)
					MatchQ[dialysisMembrane, ObjectP[Model[Container,Plate,Dialysis]]],
					Lookup[First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[dialysisMembrane]
						}]
					]]],MaxVolume]-(250*Microliter),
					(*if it is a vessel*)
					True,
					Lookup[First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[dialysisMembrane]
						}]
					]]],MaxVolume]
				];

				(*soak instructions*)
				{preSoak, recommendedSoakTime, recommendedSoakSolution, recommendedSoakVolume}=If[
					MatchQ[dialysisMembrane,Null],
					{Null,Null,Null,Null},
					Lookup[First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[dialysisMembrane]
						}]
					]]],{PreSoak, RecommendedSoakTime, RecommendedSoakSolution, RecommendedSoakVolume},Null]
				];

				(*-------------------------------------------------- SampleVolume -----------------------------------------------------*)

				(*If the sample is put in 3 times it should resolve to up to 1/3 the sample, not more*)
				sampleDivisionFactor=Count[simulatedSamples,sample];

				sampleVolume=Which[
					(*Is it set?*)
					MatchQ[Lookup[options,SampleVolume],Except[Automatic|All]],
					Lookup[options,SampleVolume],
					(*Was it set to All, change it to the sample volume*)
					MatchQ[Lookup[options,SampleVolume],All],
					entiresampleVolumes,
					(*Is the sample's volume greater than the MaxVolume of the DialysisMembrane?*)
					MatchQ[SafeRound[entiresampleVolumes/sampleDivisionFactor,1Microliter],GreaterP[membraneMaxVolume]],
					membraneMaxVolume,
					(*use the entire sample up to the max volume for dialysis Type*)
					MatchQ[resolveddialysisMethod,DynamicDialysis],
					Min[SafeRound[entiresampleVolumes/sampleDivisionFactor,1Microliter],130Milliliter],
					MatchQ[resolveddialysisMethod,StaticDialysis],
					Min[SafeRound[entiresampleVolumes/sampleDivisionFactor,1Microliter],30Milliliter],
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					Min[SafeRound[entiresampleVolumes/sampleDivisionFactor,1Microliter],500Microliter]
				];
				(*-------------------------------------------------- DialysisMembraneSoak Options-----------------------------------------------------*)

				dialysisMembraneSoak=Which[
					(*Is it set*)
					MatchQ[Lookup[options,DialysisMembraneSoak],Except[Automatic]],
					Lookup[options,DialysisMembraneSoak],
					(*Are any of it's associated options set*)
					Or[
						MatchQ[Lookup[options,DialysisMembraneSoakSolution],Except[Automatic]],
						MatchQ[Lookup[options,DialysisMembraneSoakVolume],Except[Automatic]],
						MatchQ[Lookup[options,DialysisMembraneSoakTime],Except[Automatic]]
					],
					True,
					(*Is soaking reccomended by the manufacturer?*)
					MatchQ[preSoak,True],
					True,
					(*else*)
					True,
					False
				];

				dialysisMembraneSoakSolution=Which[
					(*Is it set*)
					MatchQ[Lookup[options,DialysisMembraneSoakSolution],Except[Automatic]],
					Lookup[options,DialysisMembraneSoakSolution],
					(*Is the soak switch Off*)
					MatchQ[dialysisMembraneSoak,False],
					Null,
					(*is there a recommended solution from the model?*)
					MatchQ[recommendedSoakSolution,Except[Null]],
					If[
						MatchQ[recommendedSoakSolution,Dialysate],
						Lookup[options,Dialysate],
						Model[Sample,"Milli-Q water"]
					],
					(*else*)
					True,
					Model[Sample,"Milli-Q water"]
				];

				dialysisMembraneSoakTime=Which[
					(*Is it set*)
					MatchQ[Lookup[options,DialysisMembraneSoakTime],Except[Automatic]],
					Lookup[options,DialysisMembraneSoakTime],
					(*Is the soak switch Off*)
					MatchQ[dialysisMembraneSoak,False],
					Null,
					(*is there a recommended time from the model?*)
					MatchQ[recommendedSoakTime,Except[Null]],
					recommendedSoakTime,
					(*else*)
					True,
					10 Minute
				];

				dialysisMembraneSoakVolume=Which[
					(*Is it set*)
					MatchQ[Lookup[options,DialysisMembraneSoakVolume],Except[Automatic]],
					Lookup[options,DialysisMembraneSoakVolume],
					(*Is the soak switch Off*)
					MatchQ[dialysisMembraneSoak,False],
					Null,
					(*is there a recommended Volume from the model?*)
					MatchQ[recommendedSoakVolume,Except[Null|$Failed]],
					recommendedSoakVolume,
					(*if it is tubing*)
					MatchQ[dialysisMembrane,ObjectP[Model[Item,DialysisMembrane]]],
					200 Milliliter,
					(*Else*)
					True,
					sampleVolume
				];

				(* return the resolved values and also the error *)
				{dialysisMembrane, noAvailableDialysisMembraneError, molecularWeightCutOff, sampleVolume, dialysisMembraneSoak, dialysisMembraneSoakSolution,dialysisMembraneSoakVolume, dialysisMembraneSoakTime}
			]
		],
		{mapThreadFriendlyOptions, sampleVolumesAllReplaced, sampleVolumesAutomaticReplaced, simulatedSamples}
	]];

	(*set the error tracker variable*)
	(*)conflictingMixTypeWarning=False;*)

	(*DialysisMixType*)
	resolveddialysisMixType=Which[
		(*Is DialysisMixType Set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisMixType],Except[Automatic]],
		Lookup[roundedDialysisOptions,DialysisMixType],
		(*Dynamic Dialysis*)
		MatchQ[resolveddialysisMethod,DynamicDialysis],
		Null,
		(*Equilibrim Dialysis*)
		MatchQ[resolveddialysisMethod,EquilibriumDialysis],
		Vortex,
		(*Are the membranes all dialysis tubes and can the dialysate container can handle stirring?*)
		!MemberQ[resolveddialysisMembrane,Except[ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]]]&&
			!MemberQ[
				{
					Lookup[roundedDialysisOptions,DialysateContainer],
					Lookup[roundedDialysisOptions,SecondaryDialysateContainer],
					Lookup[roundedDialysisOptions,TertiaryDialysateContainer],
					Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],
					Lookup[roundedDialysisOptions,QuinaryDialysateContainer]
				},
				Except[ObjectP[supportedDialysateContainers]|Automatic]
			],
		Stir,
		(*Are None in Plates and we can stir it?*)
		!MemberQ[
			{
				Lookup[roundedDialysisOptions,DialysateContainer],
				Lookup[roundedDialysisOptions,SecondaryDialysateContainer],
				Lookup[roundedDialysisOptions,TertiaryDialysateContainer],
				Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],
				Lookup[roundedDialysisOptions,QuinaryDialysateContainer]
			},
			Except[ObjectP[supportedDialysateContainers]|Automatic]
		],
		Stir,
		True,
		Null
	];

	(*In order to resolve the instrument we need the specified temperatures*)
	dialysisTemps=Flatten[Lookup[roundedDialysisOptions,{DialysateTemperature, SecondaryDialysateTemperature, TertiaryDialysateTemperature, QuaternaryDialysateTemperature, QuinaryDialysateTemperature}]];

	(*Remove Automatics,Nulls and Ambients for searching*)
	dialysisTempsNoAmbient=dialysisTemps/.{Automatic->Nothing, Null|Ambient->$AmbientTemperature};

	(*In order to resolve the instrument we need the specified MixRates*)
	dialysisMixRates=Flatten[Lookup[roundedDialysisOptions,{DialysisMixRate, SecondaryDialysisMixRate, TertiaryDialysisMixRate, QuaternaryDialysisMixRate, QuinaryDialysisMixRate}]];

	(*Remove Automatics and Nulls for searching*)
	dialysisMixRatesNoNull=dialysisMixRates/.{Automatic->Nothing, Null->Nothing};

	(*Instrument*)
	unresolvableInstrumentError=False;
	resolvedinstrument=Which[
		(*Is Instrument Set?*)
		MatchQ[Lookup[roundedDialysisOptions,Instrument],Except[Automatic]],
		Lookup[roundedDialysisOptions,Instrument],
		(*Is it Dynamic Dialysis*)
		MatchQ[resolveddialysisMethod,DynamicDialysis],
		Model[Instrument,Dialyzer,"SpectraFlo Process Dynamic Dialysis System"],
		(*Is it Equilibrium Dialysis or Static Dialysis with no mixing at Ambient*)
		MatchQ[resolveddialysisMethod,Except[DynamicDialysis]]&&MatchQ[resolveddialysisMixType,Null]&&MatchQ[DeleteDuplicates[dialysisTempsNoAmbient],{$AmbientTemperature}],
		Null,
		(*Is it Equilibrium Dialysis or static Dialysis with no mixing at nonambient*)
		MatchQ[resolveddialysisMethod,Except[DynamicDialysis]]&&MatchQ[resolveddialysisMixType,Null],
		potentialInstruments=DeleteDuplicates[Cases[inheritedCache, KeyValuePattern[
			{
				Type->Model[Instrument,HeatBlock],
				MaxTemperature->GreaterEqualP[Max[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],LessEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]],MinTemperature->LessEqualP[Min[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],GreaterEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]]
			}
		]]];
		If[
			(*If any instruments meet spec*)
			Length[potentialInstruments]>0,
			(*Take the one with the most real (non-testing, non-retired) instruments*)
			Lookup[Last[
				SortBy[
					potentialInstruments,
					Count[Transpose[Download[Lookup[#, Object], {Objects[DeveloperObject], Objects[Status]}, Simulation -> updatedSimulation]], {(Null|False), Except[Retired]}]&
				]
			],Object],
			(*Return an error*)
			unresolvableInstrumentError=True;
			Null
		],
		(*Is it shaking?*)
		MatchQ[resolveddialysisMixType,Vortex],
		potentialInstruments=DeleteDuplicates[Cases[inheritedCache, KeyValuePattern[
			{
				Type->Model[Instrument,Vortex],
				MaxTemperature->GreaterEqualP[Max[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],LessEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]],MinTemperature->LessEqualP[Min[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],GreaterEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]],
				MaxRotationRate->GreaterEqualP[Max[dialysisMixRatesNoNull/.{{} -> {500 RPM}}]], MinRotationRate->LessEqualP[Min[dialysisMixRatesNoNull/.{{} -> {500 RPM}}]]
			}
		]]];
		If[
			(*If any instruments meet spec*)
			Length[potentialInstruments]>0,
			(*Take the one with the most real (non-testing, non-retired) instruments*)
			Lookup[Last[
				SortBy[
					potentialInstruments,
					Count[Transpose[Download[Lookup[#, Object], {Objects[DeveloperObject], Objects[Status]}, Simulation -> updatedSimulation]], {(Null|False), Except[Retired]}]&
				]
			],Object],
			(*Return an error*)
			unresolvableInstrumentError=True;
			Null
		],
		(*Is with stirring*)
		MatchQ[resolveddialysisMixType,Stir],
		potentialInstruments=DeleteDuplicates[Cases[inheritedCache, KeyValuePattern[
			{
				Type->Model[Instrument,OverheadStirrer],
				MaxTemperature->GreaterEqualP[Max[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],LessEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]],MinTemperature->LessEqualP[Min[dialysisTempsNoAmbient]]|If[MatchQ[Max[dialysisTempsNoAmbient],GreaterEqualP[$AmbientTemperature]],Null|RangeP[-1000Celsius,5000Celsius]],
				MaxRotationRate->GreaterEqualP[Max[dialysisMixRatesNoNull/.{{} -> {500 RPM}}]], MinRotationRate->LessEqualP[Min[dialysisMixRatesNoNull/.{{} -> {500 RPM}}]]
			}
		]]];
		If[
			(*If any instruments meet spec*)
			Length[potentialInstruments]>0,
			(*Take the one with the most real (non-testing, non-retired) instruments*)
			Lookup[Last[
				SortBy[
					potentialInstruments,
					Count[Transpose[Download[Lookup[#, Object], {Objects[DeveloperObject], Objects[Status]}, Simulation -> updatedSimulation]], {(Null|False), Except[Retired]}]&
				]
			],Object],
			(*Return an error*)
			unresolvableInstrumentError=True;
			Null
		],
		True,
		unresolvableInstrumentError=True;
		Null
	];

	(*DialysateTemperature options*)
	(*the first one defaults to ambient*)
	resolvedsecondaryDialysateTemperature=Which[
		(*Is SecondaryDialysTemperaure Set?*)
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],Except[Automatic]],
		Lookup[roundedDialysisOptions,SecondaryDialysateTemperature],
		(*Is NumberOfDialysisRounds 2 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[2]],
		dialysateTemperature,
		True,
		Null
	];

	resolvedtertiaryDialysateTemperature=Which[
		(*Is TertiaryDialysateTemperature Set?*)
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],Except[Automatic]],
		Lookup[roundedDialysisOptions,TertiaryDialysateTemperature],
		(*Is NumberOfDialysisRounds 3 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[3]],
		dialysateTemperature,
		True,
		Null
	];

	resolvedquaternaryDialysateTemperature=Which[
		(*Is QuaternaryDialysateTemperature Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuaternaryDialysateTemperature],
		(*Is NumberOfDialysisRounds 4 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[4]],
		dialysateTemperature,
		True,
		Null
	];

	resolvedquinaryDialysateTemperature=Which[
		(*Is QuaternaryDialysateTemperature Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuinaryDialysateTemperature],
		(*Is NumberOfDialysisRounds 5 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[5]],
		dialysateTemperature,
		True,
		Null
	];

	(*DialysisTime options*)
	resolveddialysisTime=Which[
		(*Is SecondaryDialysTime Set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisTime],Except[Automatic]],
		Lookup[roundedDialysisOptions,DialysisTime],
		(*static dialysis method?*)
		MatchQ[resolveddialysisMethod,StaticDialysis],
		2 Hour,
		(*equilibrium dialysis method?*)
		MatchQ[resolveddialysisMethod,EquilibriumDialysis],
		4 Hour,
		(*dynamic dialysis method?*)
		(*Recirculating*)
		MatchQ[resolveddynamicDialysisMethod,Recirculation],
		8 Hour,
		(*Single Pass*)
		(*Is the dialysate volume set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysateVolume],Except[{Automatic..}]],
		SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,DialysateVolume]],Automatic]]-1.7*Liter)/resolvedflowRate,1Minute],
		True,
		SafeRound[(8.5 Liter)/resolvedflowRate,1Minute]
	];

	resolvedsecondaryDialysisTime=Which[
		(*Is SecondaryDialysTemperaure Set?*)
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysisTime],Except[Automatic]],
		Lookup[roundedDialysisOptions,SecondaryDialysisTime],
		(*Is NumberOfDialysisRounds less than 2*)
		MatchQ[resolvednumberOfDialysisRounds,1],
		Null,
		(*Is NumberOfDialysisRounds 2*)
		MatchQ[resolvednumberOfDialysisRounds,2],
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,SecondaryDialysateVolume]],Automatic]/. {{} -> 10 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			16*Hour
		],
		(*greater than two*)
		True,
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,SecondaryDialysateVolume]],Automatic]/. {{} -> 4.5 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			2*Hour
		]
	];

	resolvedtertiaryDialysisTime=Which[
		(*Is TertiaryDialysisTime Set?*)
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysisTime],Except[Automatic]],
		Lookup[roundedDialysisOptions,TertiaryDialysisTime],
		(*Is NumberOfDialysisRounds less than 3?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[3]],
		Null,
		(*Is NumberOfDialysisRounds 3*)
		MatchQ[resolvednumberOfDialysisRounds,3],
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,TertiaryDialysateVolume]],Automatic]/. {{} -> 10 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			16*Hour
		],
		(*greater than two*)
		True,
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,TertiaryDialysateVolume]],Automatic]/. {{} -> 4.5 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			2*Hour
		]
	];

	resolvedquaternaryDialysisTime=Which[
		(*Is QuaternaryDialysisTime Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysisTime],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuaternaryDialysisTime],
		(*Is NumberOfDialysisRounds less than 4?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[4]],
		Null,
		(*Is NumberOfDialysisRounds 4*)
		MatchQ[resolvednumberOfDialysisRounds,4],
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,QuaternaryDialysateVolume]],Automatic]/. {{} -> 10 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			16*Hour
		],
		(*greater than two*)
		True,
		If[
			MatchQ[resolveddynamicDialysisMethod,SinglePass],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,QuaternaryDialysateVolume]],Automatic]/. {{} -> 4.5 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			2*Hour
		]
	];

	resolvedquinaryDialysisTime=Which[
		(*Is QuaternaryDialysisTime Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysisTime],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuinaryDialysisTime],
		(*Is NumberOfDialysisRounds less than 5?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[5]],
		Null,
		True,
		If[
			MatchQ[resolveddynamicDialysisMethod,Recirculation],
			SafeRound[(Min[DeleteCases[Flatten[Lookup[roundedDialysisOptions,QuaternaryDialysateVolume]],Automatic]/. {{} -> 10 Liter}]-1.7*Liter)/resolvedflowRate,1Minute],
			16*Hour
		]
	];

	(*DialysisMixRate options*)
	(*DialysisMixRate*)
	resolveddialysisMixRate=Which[
		(*Is DialysisMixRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysisMixRate],Except[Automatic]],
		Lookup[roundedDialysisOptions,DialysisMixRate],
		(*Are we stirring?*)
		MatchQ[resolveddialysisMixType,Stir],
		250 RPM,
		(*Are we shaking?*)
		MatchQ[resolveddialysisMixType,Vortex],
		500 RPM,
		True,
		Null
	];

	(*SecondaryDialysisMixRate*)
	resolvedsecondaryDialysisMixRate=Which[
		(*Is DialysisMixRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysisMixRate],Except[Automatic]],
		Lookup[roundedDialysisOptions,SecondaryDialysisMixRate],
		(*Is the number of dialysis rounds 2 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterP[1]],
		resolveddialysisMixRate,
		True,
		Null
	];

	(*TertiaryDialysisMixRate*)
	resolvedtertiaryDialysisMixRate=Which[
		(*Is DialysisMixRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysisMixRate],Except[Automatic]],
		Lookup[roundedDialysisOptions,TertiaryDialysisMixRate],
		(*Is the number of dialysis rounds 3 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterP[2]],
		resolveddialysisMixRate,
		True,
		Null
	];

	(*SecondaryDialysisMixRate*)
	resolvedquaternaryDialysisMixRate=Which[
		(*Is DialysisMixRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysisMixRate],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuaternaryDialysisMixRate],
		(*Is the number of dialysis rounds 4 or greater?*)
		MatchQ[resolvednumberOfDialysisRounds,GreaterP[3]],
		resolveddialysisMixRate,
		True,
		Null
	];

	(*SecondaryDialysisMixRate*)
	resolvedquinaryDialysisMixRate=Which[
		(*Is DialysisMixRate Set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysisMixRate],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuinaryDialysisMixRate],
		(*Is the number of dialysis rounds 5?*)
		MatchQ[resolvednumberOfDialysisRounds,5],
		resolveddialysisMixRate,
		True,
		Null
	];

	(* do our second big MapThread now that we have the instrument reatated options sorted*)
	{
		resolvedsecondaryDialysate, resolvedtertiaryDialysate, resolvedquaternaryDialysate, resolvedquinaryDialysate,
		resolveddialysateVolume, resolvedsecondaryDialysateVolume, resolvedtertiaryDialysateVolume, resolvedquaternaryDialysateVolume, resolvedquinaryDialysateVolume,
		resolveddialysateSampling, resolvedsecondaryDialysateSampling, resolvedtertiaryDialysateSampling, resolvedquaternaryDialysateSampling, resolvedquinaryDialysateSampling,
		resolveddialysateSamplingVolume, resolvedsecondaryDialysateSamplingVolume, resolvedtertiaryDialysateSamplingVolume, resolvedquaternaryDialysateSamplingVolume, resolvedquinaryDialysateSamplingVolume,
		resolveddialysateContainerOut,resolvedsecondaryDialysateContainerOut,resolvedtertiaryDialysateContainerOut, resolvedquaternaryDialysateContainerOut,resolvedquinaryDialysateContainerOut,
		resolvedretentateSampling,resolvedsecondaryRetentateSampling, resolvedtertiaryRetentateSampling,resolvedquaternaryRetentateSampling,
		resolvedretentateSamplingVolume,resolvedsecondaryRetentateSamplingVolume, resolvedtertiaryRetentateSamplingVolume,resolvedquaternaryRetentateSamplingVolume,
		resolvedretentateSamplingContainerOut,resolvedsecondaryRetentateSamplingContainerOut, resolvedtertiaryRetentateSamplingContainerOut,resolvedquaternaryRetentateSamplingContainerOut,resolvedretentateContainerOut
	} = Transpose[MapThread[
		Function[{options,dialysates,sampleVolume},
			Module[
				{secondaryDialysate, tertiaryDialysate, quaternaryDialysate, quinaryDialysate, dialysateVolume, secondaryDialysateVolume, tertiaryDialysateVolume,
					quaternaryDialysateVolume, quinaryDialysateVolume,
					dialysateSampling, secondaryDialysateSampling, tertiaryDialysateSampling, quaternaryDialysateSampling, quinaryDialysateSampling,
					dialysateSamplingVolume,  secondaryDialysateSamplingVolume, tertiaryDialysateSamplingVolume, quaternaryDialysateSamplingVolume, quinaryDialysateSamplingVolume,
					dialysateContainerOut,secondaryDialysateContainerOut,tertiaryDialysateContainerOut, quaternaryDialysateContainerOut,quinaryDialysateContainerOut,
					retentateSampling,secondaryRetentateSampling, tertiaryRetentateSampling,quaternaryRetentateSampling,
					retentateSamplingVolume,secondaryRetentateSamplingVolume, tertiaryRetentateSamplingVolume,quaternaryRetentateSamplingVolume,
					retentateSamplingContainerOut,secondaryRetentateSamplingContainerOut, tertiaryRetentateSamplingContainerOut,quaternaryRetentateSamplingContainerOut,retentateContainerOut
				},

				(*Dialysate options*)
				secondaryDialysate=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryDialysate],Except[Automatic]],
					Lookup[options,SecondaryDialysate],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[2]],
					dialysates,
					True,
					Null
				];
				tertiaryDialysate=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryDialysate],Except[Automatic]],
					Lookup[options,TertiaryDialysate],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[3]],
					dialysates,
					True,
					Null
				];
				quaternaryDialysate=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryDialysate],Except[Automatic]],
					Lookup[options,QuaternaryDialysate],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[4]],
					dialysates,
					True,
					Null
				];
				quinaryDialysate=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuinaryDialysate],Except[Automatic]],
					Lookup[options,QuinaryDialysate],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[5]],
					dialysates,
					True,
					Null
				];

				(*DialysateVolume options*)
				dialysateVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,DialysateVolume],Except[Automatic]],
					Lookup[options,DialysateVolume],
					(*Is the dialysis method Dynamic?*)
					MatchQ[resolveddialysisMethod,DynamicDialysis],
					10 Liter,
					(*Is the dialysis method EquilibriumDialysis*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					sampleVolume + 250*Microliter,
					(*StaticDialysis*)
					(*Is the (Total[resolvedsampleVolume]*100>2Liter ?*)
					Total[resolvedsampleVolume]*100>(2Liter*.95-sampleVolume),
					SafeRound[(2Liter*.95-sampleVolume),10Milliliter],
					True,
					SafeRound[Max[
						Min[
							SafeRound[(2Liter*.95-sampleVolume),10Milliliter],
							Lookup[options,DialysateSamplingVolume]/.{Automatic->0Milliliter}
						],
						Total[resolvedsampleVolume]*100,
						(1Liter*.95-sampleVolume)
					],10Milliliter]
				];

				secondaryDialysateVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryDialysateVolume],Except[Automatic]],
					Lookup[options,SecondaryDialysateVolume],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[2]],
					dialysateVolume,
					True,
					Null
				];

				tertiaryDialysateVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryDialysateVolume],Except[Automatic]],
					Lookup[options,TertiaryDialysateVolume],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[3]],
					dialysateVolume,
					True,
					Null
				];

				quaternaryDialysateVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryDialysateVolume],Except[Automatic]],
					Lookup[options,QuaternaryDialysateVolume],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[4]],
					dialysateVolume,
					True,
					Null
				];

				quinaryDialysateVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuinaryDialysateVolume],Except[Automatic]],
					Lookup[options,QuinaryDialysateVolume],
					(*Is this round happening?*)
					MatchQ[resolvednumberOfDialysisRounds,GreaterEqualP[4]],
					dialysateVolume,
					True,
					Null
				];

				(*DialysateSampling*)

				dialysateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,DialysateSampling],Except[Automatic]],
					Lookup[options,DialysateSampling],
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{DialysateSamplingVolume, DialysateContainerOut, DialysateStorageCondition}],Except[Null|Automatic]],
					True,
					(*Is the DialysisMethod Equilibrim?*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					True,
					(*rest*)
					True,
					False
				];

				secondaryDialysateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryDialysateSampling],Except[Automatic]],
					Lookup[options,SecondaryDialysateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[2]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{SecondaryDialysateSamplingVolume, SecondaryDialysateContainerOut, SecondaryDialysateStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				tertiaryDialysateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryDialysateSampling],Except[Automatic]],
					Lookup[options,TertiaryDialysateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[3]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{TertiaryDialysateSamplingVolume, TertiaryDialysateContainerOut, TertiaryDialysateStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				quaternaryDialysateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryDialysateSampling],Except[Automatic]],
					Lookup[options,QuaternaryDialysateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[4]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{QuaternaryDialysateSamplingVolume, QuaternaryDialysateContainerOut, QuaternaryDialysateStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				quinaryDialysateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuinaryDialysateSampling],Except[Automatic]],
					Lookup[options,QuinaryDialysateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[5]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{QuinaryDialysateSamplingVolume, QuinaryDialysateContainerOut, QuinaryDialysateStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				(*DialysateSamplingVolume options*)
				dialysateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,DialysateSamplingVolume],Except[Automatic]],
					Lookup[options,DialysateSamplingVolume],
					(*Is DialysateSampling False?*)
					MatchQ[dialysateSampling,False],
					Null,
					(*Is the DialysisMethod Equilibrim?*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					dialysateVolume,
					(*Is the dialysateVolume*0.05>1ml*)
					dialysateVolume*0.05>1*Milliliter,
					1*Milliliter,
					(*Is the dialysateVolume*0.05<1ul*)
					dialysateVolume*0.05<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[dialysateVolume*0.05,1Microliter]
				];

				secondaryDialysateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryDialysateSamplingVolume],Except[Automatic]],
					Lookup[options,SecondaryDialysateSamplingVolume],
					(*Is DialysateSampling False?*)
					MatchQ[secondaryDialysateSampling,False|Null],
					Null,
					(*Is the dialysateVolume*0.05>1ml*)
					dialysateVolume*0.05>1*Milliliter,
					1*Milliliter,
					(*Is the dialysateVolume*0.05<1ul*)
					dialysateVolume*0.05<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[dialysateVolume*0.05,1Microliter]
				];

				tertiaryDialysateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryDialysateSamplingVolume],Except[Automatic]],
					Lookup[options,TertiaryDialysateSamplingVolume],
					(*Is DialysateSampling False?*)
					MatchQ[tertiaryDialysateSampling,False|Null],
					Null,
					(*Is the dialysateVolume*0.05>1ml*)
					dialysateVolume*0.05>1*Milliliter,
					1*Milliliter,
					(*Is the dialysateVolume*0.05<1ul*)
					dialysateVolume*0.05<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[dialysateVolume*0.05,1Microliter]
				];

				quaternaryDialysateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryDialysateSamplingVolume],Except[Automatic]],
					Lookup[options,QuaternaryDialysateSamplingVolume],
					(*Is DialysateSampling False?*)
					MatchQ[quaternaryDialysateSampling,False|Null],
					Null,
					(*Is the dialysateVolume*0.05>1ml*)
					dialysateVolume*0.05>1*Milliliter,
					1*Milliliter,
					(*Is the dialysateVolume*0.05<1ul*)
					dialysateVolume*0.05<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[dialysateVolume*0.05,1Microliter]
				];

				quinaryDialysateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuinaryDialysateSamplingVolume],Except[Automatic]],
					Lookup[options,QuinaryDialysateSamplingVolume],
					(*Is DialysateSampling False?*)
					MatchQ[quinaryDialysateSampling,False|Null],
					Null,
					(*Is the dialysateVolume*0.05>1ml*)
					dialysateVolume*0.05>1*Milliliter,
					1*Milliliter,
					(*Is the dialysateVolume*0.05<1ul*)
					dialysateVolume*0.05<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[dialysateVolume*0.05,1Microliter]
				];

				(*DialysateContainerOut options*)
				dialysateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,DialysateContainerOut],Except[Automatic]],
					Lookup[options,DialysateContainerOut],
					(*Are you not storing it?*)
					MatchQ[dialysateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					(*Is it equilibrium dialysis?*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					True,
					PreferredContainer[dialysateSamplingVolume]
				];

				secondaryDialysateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryDialysateContainerOut],Except[Automatic]],
					Lookup[options,SecondaryDialysateContainerOut],
					(*Are you not storing it?*)
					MatchQ[secondaryDialysateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[secondaryDialysateSamplingVolume]
				];

				tertiaryDialysateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryDialysateContainerOut],Except[Automatic]],
					Lookup[options,TertiaryDialysateContainerOut],
					(*Are you not storing it?*)
					MatchQ[tertiaryDialysateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[tertiaryDialysateSamplingVolume]
				];

				quaternaryDialysateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryDialysateContainerOut],Except[Automatic]],
					Lookup[options,QuaternaryDialysateContainerOut],
					(*Are you not storing it?*)
					MatchQ[quaternaryDialysateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[quaternaryDialysateSamplingVolume]
				];

				quinaryDialysateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuinaryDialysateContainerOut],Except[Automatic]],
					Lookup[options,QuinaryDialysateContainerOut],
					(*Are you not storing it?*)
					MatchQ[quinaryDialysateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[quinaryDialysateSamplingVolume]
				];

				(*RetentateSampling Options*)

				retentateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,RetentateSampling],Except[Automatic]],
					Lookup[options,RetentateSampling],
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{RetentateSamplingVolume, RetentateSamplingContainerOut, RetentateSamplingStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				secondaryRetentateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryRetentateSampling],Except[Automatic]],
					Lookup[options,SecondaryRetentateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[2]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{SecondaryRetentateSamplingVolume, SecondaryRetentateSamplingContainerOut, SecondaryRetentateSamplingStorageCondition}],Except[Null|Automatic]],
					True,
					(*Is there a secondary round?*)
					True,
					False
				];

				tertiaryRetentateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryRetentateSampling],Except[Automatic]],
					Lookup[options,TertiaryRetentateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[3]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{TertiaryRetentateSamplingVolume, TertiaryRetentateSamplingContainerOut, TertiaryRetentateSamplingStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				quaternaryRetentateSampling=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryRetentateSampling],Except[Automatic]],
					Lookup[options,QuaternaryRetentateSampling],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[4]],
					Null,
					(*Are any of the sampling options set?*)
					MemberQ[Lookup[options,{QuaternaryRetentateSamplingVolume, QuaternaryRetentateSamplingContainerOut, QuaternaryRetentateSamplingStorageCondition}],Except[Null|Automatic]],
					True,
					(*rest*)
					True,
					False
				];

				(*RetentateSamplingVolume Options*)
				retentateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,RetentateSamplingVolume],Except[Automatic]],
					Lookup[options,RetentateSamplingVolume],
					(*Is RetentateSampling False?*)
					MatchQ[retentateSampling,False|Null],
					Null,
					(*Is the SampleVolume*0.01>1ml*)
					sampleVolume*0.01>1*Milliliter,
					1*Milliliter,
					(*Is the SampleVolume*0.01<1ul*)
					sampleVolume*0.01<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[sampleVolume*0.01,1Microliter]
				];

				secondaryRetentateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryRetentateSamplingVolume],Except[Automatic]],
					Lookup[options,SecondaryRetentateSamplingVolume],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[2]],
					Null,
					(*Is RetentateSampling False?*)
					MatchQ[secondaryRetentateSampling,False|Null],
					Null,
					(*Is the SampleVolume*0.05>1ml*)
					sampleVolume*0.01>1*Milliliter,
					1*Milliliter,
					(*Is the SampleVolume*0.01<1ul*)
					sampleVolume*0.01<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[sampleVolume*0.01,1Microliter]
				];

				tertiaryRetentateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryRetentateSamplingVolume],Except[Automatic]],
					Lookup[options,TertiaryRetentateSamplingVolume],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[3]],
					Null,
					(*Is RetentateSampling False?*)
					MatchQ[tertiaryRetentateSampling,False|Null],
					Null,
					(*Is the SampleVolume*0.05>1ml*)
					sampleVolume*0.01>1*Milliliter,
					1*Milliliter,
					(*Is the SampleVolume*0.01<1ul*)
					sampleVolume*0.01<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[sampleVolume*0.01,1Microliter]
				];

				quaternaryRetentateSamplingVolume=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryRetentateSamplingVolume],Except[Automatic]],
					Lookup[options,QuaternaryRetentateSamplingVolume],
					(*Is this round not happening?*)
					MatchQ[resolvednumberOfDialysisRounds,LessP[4]],
					Null,
					(*Is RetentateSampling False?*)
					MatchQ[quaternaryRetentateSampling,False|Null],
					Null,
					(*Is the SampleVolume*0.05>1ml*)
					sampleVolume*0.01>1*Milliliter,
					1*Milliliter,
					(*Is the SampleVolume*0.01<1ul*)
					sampleVolume*0.01<1*Microliter,
					1*Microiliter,
					True,
					SafeRound[sampleVolume*0.01,1Microliter]
				];

				(*RetentateSamplingContainerOut options*)
				retentateSamplingContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,RetentateSamplingContainerOut],Except[Automatic]],
					Lookup[options,RetentateSamplingContainerOut],
					(*Are you not storing it?*)
					MatchQ[retentateSampling,False],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[retentateSamplingVolume]
				];
				secondaryRetentateSamplingContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,SecondaryRetentateSamplingContainerOut],Except[Automatic]],
					Lookup[options,SecondaryRetentateSamplingContainerOut],
					(*Are you not storing it?*)
					MatchQ[secondaryRetentateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[secondaryRetentateSamplingVolume]
				];
				tertiaryRetentateSamplingContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,TertiaryRetentateSamplingContainerOut],Except[Automatic]],
					Lookup[options,TertiaryRetentateSamplingContainerOut],
					(*Are you not storing it?*)
					MatchQ[tertiaryRetentateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[tertiaryRetentateSamplingVolume]
				];
				quaternaryRetentateSamplingContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,QuaternaryRetentateSamplingContainerOut],Except[Automatic]],
					Lookup[options,QuaternaryRetentateSamplingContainerOut],
					(*Are you not storing it?*)
					MatchQ[quaternaryRetentateSampling,False|Null],
					Null,
					(*Are we storing it?*)
					True,
					PreferredContainer[quaternaryRetentateSamplingVolume]
				];

				retentateContainerOut=Which[
					(*is it set?*)
					MatchQ[Lookup[options,RetentateContainerOut],Except[Automatic]],
					Lookup[options,RetentateContainerOut],
					(*Is it equilibrium dialysis?*)
					MatchQ[resolveddialysisMethod,EquilibriumDialysis],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					(*preferred container?*)
					True,
					PreferredContainer[sampleVolume]
				];

				(* return the resolved values and also any errors *)
				{
					secondaryDialysate, tertiaryDialysate, quaternaryDialysate, quinaryDialysate,
					dialysateVolume, secondaryDialysateVolume, tertiaryDialysateVolume, quaternaryDialysateVolume, quinaryDialysateVolume,
					dialysateSampling, secondaryDialysateSampling, tertiaryDialysateSampling, quaternaryDialysateSampling, quinaryDialysateSampling,
					dialysateSamplingVolume,secondaryDialysateSamplingVolume, tertiaryDialysateSamplingVolume, quaternaryDialysateSamplingVolume, quinaryDialysateSamplingVolume,
					dialysateContainerOut,secondaryDialysateContainerOut,tertiaryDialysateContainerOut, quaternaryDialysateContainerOut,quinaryDialysateContainerOut,
					retentateSampling,secondaryRetentateSampling, tertiaryRetentateSampling,quaternaryRetentateSampling,
					retentateSamplingVolume,secondaryRetentateSamplingVolume, tertiaryRetentateSamplingVolume,quaternaryRetentateSamplingVolume,
					retentateSamplingContainerOut,secondaryRetentateSamplingContainerOut, tertiaryRetentateSamplingContainerOut,quaternaryRetentateSamplingContainerOut,
					retentateContainerOut
				}
			]
		],
		{mapThreadFriendlyOptions, dialysate, resolvedsampleVolume}
	]];

	(*Error::ConflictingRetentateContainerOutPlate="The RetentateContainerOut `1` must be a Model[Container,Vessel] for when transferring out of a dialysis tubing. Please choose a vessel to use as RetentateContainerOut.";*)
	conflictingRetentateContainerOutPlateOptions=MapThread[
		If[
			MatchQ[#1,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]]&&MatchQ[#2,Except[ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]]],
			{#1,#2},
			Nothing
		]&,
		{resolveddialysisMembrane,resolvedretentateContainerOut}
	];

	invalidConflictingRetentateContainerOutPlateOptions=If[Length[conflictingRetentateContainerOutPlateOptions]>0&&!gatherTests,
		Message[Error::ConflictingRetentateContainerOutPlate,
			Lookup[roundedDialysisOptions,RetentateContainerOut]
		];
		{RetentateContainerOut},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingRetentateContainerOutPlateTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingRetentateContainerOutPlateOptions]==0,
				Test["The RetentateContainerOut of a sample in dialysis tubing is a vessel:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingRetentateContainerOutPlateOptions]>0,
				Test["The RetentateContainerOut of a sample in dialysis tubing is a vessel:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];
	(*Error::ConflictingRetentateSamplingContainerOutPlate="The RetentateSamplingContainerOut `1`  must be a Model[Container,Vessel] for when transferring out of a dialysis tubing. Please choose a vessel to use as RetentateContainerOut.";*)

	conflictingRetentateSamplingContainerOutPlateOptions=MapThread[
		If[
			MatchQ[#1,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]]&&Or[
				MatchQ[#2,Except[ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]|Null]],
				MatchQ[#3,Except[ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]|Null]],
				MatchQ[#4,Except[ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]|Null]],
				MatchQ[#5,Except[ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]|Null]]
			],
			{#1,#2},
			Nothing
		]&,
		{resolveddialysisMembrane,resolvedretentateSamplingContainerOut,resolvedsecondaryRetentateSamplingContainerOut,resolvedtertiaryRetentateSamplingContainerOut,resolvedquaternaryRetentateSamplingContainerOut}
	];

	invalidConflictingRetentateSamplingContainerOutPlateOptions=If[Length[conflictingRetentateSamplingContainerOutPlateOptions]>0&&!gatherTests,
		Message[Error::ConflictingRetentateSamplingContainerOutPlate];
		{RetentateSamplingContainerOut},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingRetentateSamplingContainerOutPlateTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingRetentateSamplingContainerOutPlateOptions]==0,
				Test["The RetentateSamplingContainerOut of a sample in dialysis tubing is a vessel:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingRetentateSamplingContainerOutPlateOptions]>0,
				Test["The RetentateSamplingContainerOut of a sample in dialysis tubing is a vessel:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*Error::ConflictingDialysateSamplingVolume="The DialysateSamplingVolume `1` less than the DialysateVolume, `2`. Please choose a smaller DialysateSamplingVolume.";
	*)

	(*Check if the dialysate sampling volume is larger than the dialysate volume*)
	conflictingDialysateSamplingVolumeOptions=
		PickList[{{DialysateSamplingVolume,DialysateVolume},{SecondaryDialysateSamplingVolume,SecondaryDialysateVolume},{TertiaryDialysateSamplingVolume,TertiaryDialysateVolume},{QuaternaryDialysateSamplingVolume,QuaternaryDialysateVolume},{QuinaryDialysateSamplingVolume,QuinaryDialysateVolume}},
			{
				MemberQ[resolveddialysateVolume - resolveddialysateSamplingVolume /. {Null -> 0Microliter}, LessP[0 Milliliter]],
				MemberQ[resolvedsecondaryDialysateVolume - resolvedsecondaryDialysateSamplingVolume /. {Null -> 0Microliter}, LessP[0 Milliliter]],
				MemberQ[resolvedtertiaryDialysateVolume - resolvedtertiaryDialysateSamplingVolume /. {Null -> 0Microliter}, LessP[0 Milliliter]],
				MemberQ[resolvedquaternaryDialysateVolume - resolvedquaternaryDialysateSamplingVolume /. {Null -> 0Microliter}, LessP[0 Milliliter]],
				MemberQ[resolvedquinaryDialysateVolume - resolvedquinaryDialysateSamplingVolume /. {Null -> 0Microliter}, LessP[0 Milliliter]]
			}
		];

	(*give the corresponding error*)
	invalidConflictingDialysateSamplingVolumeOptions=If[Length[conflictingDialysateSamplingVolumeOptions]>0&&!gatherTests,
		Message[Error::ConflictingDialysateSamplingVolume,
			Lookup[roundedDialysisOptions,#]&/@conflictingDialysateSamplingVolumeOptions[[All,1]],
			Lookup[roundedDialysisOptions,#]&/@conflictingDialysateSamplingVolumeOptions[[All,2]]
		];
		conflictingDialysateSamplingVolumeOptions,
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingDialysateSamplingVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingDialysateSamplingVolumeOptions]==0,
				Test["The DialysateSamplingVolume less than the DialysateVolume:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDialysateSamplingVolumeOptions]>0,
				Test["The DialysateSamplingVolume less than the DialysateVolume:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*DialysateContainer options*)
	unresolvableDialysateContainer=False;
	resolveddialysateContainer=Which[
		(*is it set?*)
		MatchQ[Lookup[roundedDialysisOptions,DialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,DialysateContainer],
		(*Is the dialysis method Static?*)
		MatchQ[resolveddialysisMethod,Except[StaticDialysis]],
		Null,
		(* Find a beaker big enough*)
		True,
		potentialContainers=DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[
				{
					Object->ObjectP[supportedDialysateContainers],
					MaxVolume->GreaterEqualP[Max[resolveddialysateVolume+resolvedsampleVolume]],
					MinVolume->LessEqualP[Min[resolveddialysateVolume]]|Null
				}
			]
		]];
		If[
			Length[potentialContainers]>0,
			Lookup[First[
				Sort[
					potentialContainers,
					Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &]
			],Object],
			unresolvableDialysateContainer=True;
			Null
		]
	];

	(*The max volume of the resolved container*)
	dialysateContainerVolume=If[MatchQ[resolveddialysateContainer,Null],
		Null,
		Lookup[First[
				DeleteDuplicates[Cases[inheritedCache,
					KeyValuePattern[
						{
							Object->ObjectP[resolveddialysateContainer]
						}
					]
				]]
		],
			MaxVolume]-Max[resolvedsampleVolume]
	];

	resolvedsecondaryDialysateContainer=Which[
		(*is it set?*)
		MatchQ[Lookup[roundedDialysisOptions,SecondaryDialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,SecondaryDialysateContainer],
		(*Is the dialysis method not Static?*)
		MatchQ[resolveddialysisMethod,Except[StaticDialysis]],
		Null,
		(*Is this round not happening?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[2]],
		Null,
		(*Can the dialysateContainer hold the volume?*)
		Max[resolvedsecondaryDialysateVolume]<dialysateContainerVolume,
		resolveddialysateContainer,
		(*find a bigger one then*)
		True,
		potentialContainers=DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[
				{
					Object->ObjectP[supportedDialysateContainers],
					MaxVolume->GreaterEqualP[Max[resolvedsecondaryDialysateVolume+resolvedsampleVolume]],
					MinVolume->LessEqualP[Min[resolvedsecondaryDialysateVolume]]|Null
				}
			]
		]];
		If[
			Length[potentialContainers]>0,
			Lookup[First[
				Sort[
					potentialContainers,
					Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &
				]
			],Object],
			unresolvableDialysateContainer=True;
			Null
		]
	];

	resolvedtertiaryDialysateContainer=Which[
		(*is it set?*)
		MatchQ[Lookup[roundedDialysisOptions,TertiaryDialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,TertiaryDialysateContainer],
		(*Is the dialysis method Static?*)
		MatchQ[resolveddialysisMethod,Except[StaticDialysis]],
		Null,
		(*Is this round not happening?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[3]],
		Null,
		(*Can the dialysateContainer hold the volume?*)
		Max[resolvedtertiaryDialysateVolume]<dialysateContainerVolume,
		resolveddialysateContainer,
		(*find a bigger one then*)
		True,
		potentialContainers=DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[
				{
					Object->ObjectP[supportedDialysateContainers],
					MaxVolume->GreaterEqualP[Max[resolvedtertiaryDialysateVolume+resolvedsampleVolume]],
					MinVolume->LessEqualP[Min[resolvedtertiaryDialysateVolume]]|Null
				}
			]
		]];
		If[
			Length[potentialContainers]>0,
			Lookup[First[
				Sort[potentialContainers, Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &]
			],Object],
			unresolvableDialysateContainer=True;
			Null
		]
	];
	resolvedquaternaryDialysateContainer=Which[
		(*is it set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuaternaryDialysateContainer],
		(*Is the dialysis method Static?*)
		MatchQ[resolveddialysisMethod,Except[StaticDialysis]],
		Null,
		(*Is this round not happening?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[4]],
		Null,
		(*Can the dialysateContainer hold the volume?*)
		Max[resolvedquaternaryDialysateVolume]<dialysateContainerVolume,
		resolveddialysateContainer,
		(*find a bigger one then*)
		True,
		potentialContainers=DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[
				{
					Object->ObjectP[supportedDialysateContainers],
					MaxVolume->GreaterEqualP[Max[resolvedquaternaryDialysateVolume+resolvedsampleVolume]],
					MinVolume->LessEqualP[Min[resolvedquaternaryDialysateVolume]]|Null
				}
			]
		]];
		If[
			Length[potentialContainers]>0,
			Lookup[First[
				Sort[potentialContainers, Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &]
			],Object],
			unresolvableDialysateContainer=True;
			Null
		]
	];
	resolvedquinaryDialysateContainer=Which[
		(*is it set?*)
		MatchQ[Lookup[roundedDialysisOptions,QuinaryDialysateContainer],Except[Automatic]],
		Lookup[roundedDialysisOptions,QuinaryDialysateContainer],
		(*Is the dialysis method Static?*)
		MatchQ[resolveddialysisMethod,Except[StaticDialysis]],
		Null,
		(*Is this round not happening?*)
		MatchQ[resolvednumberOfDialysisRounds,LessP[5]],
		Null,
		(*Can the dialysateContainer hold the volume?*)
		Max[resolvedquinaryDialysateVolume]<dialysateContainerVolume,
		resolveddialysateContainer,
		(*find a bigger one then*)
		True,
		potentialContainers=DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[
				{
					Object->ObjectP[supportedDialysateContainers],
					MaxVolume->GreaterEqualP[Max[resolvedquinaryDialysateVolume+resolvedsampleVolume]],
					MinVolume->LessEqualP[Min[resolvedquinaryDialysateVolume]]|Null
				}
			]
		]];
		If[
			Length[potentialContainers]>0,
			Lookup[First[
				Sort[potentialContainers, Lookup[#1, MaxVolume] < Lookup[#2, MaxVolume] &]
			],Object],
			unresolvableDialysateContainer=True;
			Null
		]
	];


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check for membrane errors *)
	invalidNoAvailableDialysisMembraneErrorOptions=If[Or@@noAvailableDialysisMembraneErrors&&!gatherTests,
		Module[{invalidSamples,mWCOs,volumes},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,noAvailableDialysisMembraneErrors];

			(* Get the invalid mwco and sample volumes *)
			mWCOs=PickList[Lookup[mapThreadFriendlyOptions,MolecularWeightCutoff],noAvailableDialysisMembraneErrors];
			volumes=PickList[Lookup[mapThreadFriendlyOptions,SampleVolume],noAvailableDialysisMembraneErrors];

			(* Throw the corresponding error. *)
			Message[Error::NoAvailableDialysisMembrane,ToString[mWCOs],ToString[volumes],ObjectToString[invalidSamples,Simulation -> updatedSimulation]];

			(* Return our invalid options. *)
			{DialysisMembrane}
		],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidNoAvailableDialysisMembraneErrorTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[!Or@@noAvailableDialysisMembraneErrors==0,
				Test["There are dialysis membranes that match the specified molecular weight cutoff and sample volumes:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Or@@noAvailableDialysisMembraneErrors>0,
				Test["There are dialysis membranes that match the specified molecular weight cutoff and sample volumes:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];
	(*)
	(* Check for mix type errors *)
	invalidConflictingMixTypeOptions=If[
		conflictingMixTypeWarning&&!gatherTests,
		(* Throw the corresponding warning. *)
		Message[Warning::ConflictingDialysisMixType,ObjectToString[resolveddialysisMembrane,Simulation -> updatedSimulation]];
		(* Return our invalid options. *)
		{DialysisMembrane, DialysisMixType},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidConflictingMixTypeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[!conflictingMixTypeWarning,
				Test["The dialysis membranes can all be used with the same mix type:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[conflictingMixTypeWarning,
				Test["The dialysis membranes can all be used with the same mix type:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];*)

	(* Check for instrument errors *)
	invalidUnresolvableDialysisInstrumentOptions=If[
		unresolvableInstrumentError&&!gatherTests,
		(* Throw the corresponding error. *)
		Message[Error::UnresolvableDialysisInstrument,resolveddialysisMethod,resolveddialysisMixType, dialysisTemps, dialysisMixRates];
		(* Return our invalid options. *)
		{Instrument,DialysisMethod,DialysisMixType,DialysisMixRate,DialysateTemperature},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidUnresolvableDialysisInstrumentTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[!unresolvableInstrumentError,
				Test["There is an instrument that can support the DialysisMethod, DialysisMixType, DialysisMixRate and DialysateTemperature:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[unresolvableInstrumentError,
				Test["There is an instrument that can support the DialysisMethod, DialysisMixType, DialysisMixRate and DialysateTemperature:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for unresolvableDialysateContainers errors *)
	invalidunresolvableDialysateContainerOptions=If[unresolvableDialysateContainer&&!gatherTests,
		Module[{invalidSamples,volumes},
			(* Get the invalid mwco and sample volumes *)
			volumes=resolveddialysateVolume;

			(* Throw the corresponding error. *)
			Message[Error::UnresolvableDialysateContainer,ToString[volumes]];

			(* Return our invalid options. *)
			{DialysateContainer}
		],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidunresolvableDialysateContainerTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[!unresolvableDialysateContainer,
				Test["There are containers that can hold the dialysate volumes:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[unresolvableDialysateContainer,
				Test["There are containers that can hold the dialysate volumes:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* --- Too many samples check --- *)

	(* get the number of samples that will go onto the protocol *)
	numSamples = If[NullQ[numberOfReplicates],
		Length[simulatedSamples],
		Length[simulatedSamples] * numberOfReplicates
	];

	(* this might not be necessary as it can batch, this is justa max to make sure the protocol doesn;t take way too much time *)
	tooManySamples = Which[
		MatchQ[resolveddialysisMethod,DynamicDialysis],
		If[numSamples > 5,5,Null],
		MatchQ[resolveddialysisMethod,StaticDialysis],
		If[numSamples > 45,45,Null], (*the 9 position floating rack times 5*)
		MatchQ[resolveddialysisMethod,EquilibriumDialysis],
		If[numSamples > 240,240,Null](*the 48 position rack times 5*)
	];

	(* if there are more than x samples, and we are throwing messages, throw an error message *)
	tooManySamplesInputs = Which[
		!NullQ[tooManySamples] && messages,
		(
			Message[Error::DialysisTooManySamples, numSamples, tooManySamples];
			Download[mySamples, Object]
		),
		TrueQ[tooManySamples], Download[mySamples, Object],
		True, {}
	];

	(* if we are gathering tests, create a test indicating whether we have too many samples or not *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided times NumberOfReplicates is not greater than the protocol can handle:",
			!NullQ[tooManySamples],
			False
		],
		Nothing
	];

	(* --- Resolve the aliquot options --- *)
	(* the equilibrium dialysis plates can only use the 50ul tips with the hamilitons, so the containers but be compatible with them*)
	hamiltonCompatibleContainers=If[
		MatchQ[resolveddialysisMethod,Except[EquilibriumDialysis]],
		Null,
		Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling]
	];

	hamiltonCompatibleContainerBools=If[
		MatchQ[resolveddialysisMethod,Except[EquilibriumDialysis]],
		Null,
		Experiment`Private`tipsReachContainerBottomQ[Model[Item, Tips, "50 uL Hamilton tips, non-sterile"], Download[#,Simulation->updatedSimulation], {Download[Model[Item, Tips, "50 uL Hamilton tips, non-sterile"],Cache->inheritedCache,Simulation->updatedSimulation]}] & /@ hamiltonCompatibleContainers
	];

	compatibleContainers=If[
		MatchQ[resolveddialysisMethod,Except[EquilibriumDialysis]],
		Null,
		PickList[hamiltonCompatibleContainers, hamiltonCompatibleContainerBools]
	];

	requiredSampleVolumes=If[
		MatchQ[resolveddialysisMethod,Except[EquilibriumDialysis]],
		SafeRound[resolvedsampleVolume,10^-1 Microliter],
		SafeRound[(resolvedsampleVolume+10Microliter),10^-1 Microliter]
	];

	targetContainers=MapThread[Function[{containers,volume},
		If[
			Or[MatchQ[containers, {ObjectP[compatibleContainers]}],MatchQ[resolveddialysisMethod,Except[EquilibriumDialysis]]],
			Null,
			PreferredContainer[volume, LiquidHandlerCompatible -> True]
		]
	],
		{TakeList[sampleContainerModels,poolingLengths],requiredSampleVolumes}
	];

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot = First[splitPrepOptions[resolvedSamplePrepOptions, PrepOptionSets -> {IncubatePrepOptionsNew, CentrifugePrepOptionsNew, FilterPrepOptionsNew}]];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentDialysis,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, resolveSamplePrepOptionsWithoutAliquot],
			Cache -> inheritedCache,
			Simulation -> updatedSimulation,
			RequiredAliquotContainers -> targetContainers,
			RequiredAliquotAmounts -> requiredSampleVolumes,
			Output -> {Result, Tests}
		],
		{resolveAliquotOptions[
			ExperimentDialysis,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, resolveSamplePrepOptionsWithoutAliquot],
			Cache -> inheritedCache,
			Simulation -> updatedSimulation,
			RequiredAliquotContainers -> targetContainers,
			RequiredAliquotAmounts -> requiredSampleVolumes,
			Output -> Result],
			{}}
	];

	(* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[resolvedinstrument, DeleteCases[Join[flatSimulatedSamples,dialysate, resolvedsecondaryDialysate, resolvedtertiaryDialysate, resolvedquaternaryDialysate, resolvedquinaryDialysate],Null], Output -> {Result, Tests}, Simulation -> updatedSimulation],
		{CompatibleMaterialsQ[resolvedinstrument, DeleteCases[Join[flatSimulatedSamples,dialysate, resolvedsecondaryDialysate, resolvedtertiaryDialysate, resolvedquaternaryDialysate, resolvedquinaryDialysate],Null], Messages -> messages, Simulation -> updatedSimulation], {}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messages,
		{Instrument},
		{}
	];

	(* get whether the SamplesInStorage option is ok *)
	samplesInStorage=Lookup[myOptions, SamplesInStorageCondition];

	expandedSamplesInStorage= Flatten[MapThread[
			Table[#1,Length[#2]]
			&,{samplesInStorage,simulatedSamples}
	],1];

	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
		ValidContainerStorageConditionQ[flatSimulatedSamples, expandedSamplesInStorage, Output -> {Result, Tests}, Simulation -> updatedSimulation],
		{ValidContainerStorageConditionQ[flatSimulatedSamples, expandedSamplesInStorage, Output -> Result, Simulation -> updatedSimulation], {}}
	];

	validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)

	(* combine the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		invalidStaticDialysisOptions,
		invalidDynamicDialysisOptions,
		invalidDialysisMethodInstrumentOptions,
		invalidDialysateTemperatureInstrumentOptions,
		invalidSampleVolumeDialysisMembraneOptions,
		invalidLargeDialysisSampleVolumeOptions,
		(*)invalidConflictingImageSystemOptions,*)
		invalidDialysisMembraneTemperatureOptions,
		invalidDialysateContainerVolumeOptions,
		invalidDialysisMixTypeInstrumentMismatchOptions,
		invalidDialysisMixRateInstrumentMismatchOptions,
		invalidConflictingDialysateSamplingVolumeOptions,
		invalidConflictingRetentateSamplingVolumeOptions,
		invalidConflictingDialysateContainerOutOptions,
		invalidConflictingRetentateContainerOutOptions,
		invalidRetentateSamplingMismatchOptions,
		invalidNumberOfDialysisRoundsMismatchOptions,
		invalidMissingDialysisMembraneMWCOOptions,
		invalidDialysisMembraneSoakMismatchOptions,
		invalidImpossibleFlowRateOptions,
		invalidNoAvailableDialysisMembraneErrorOptions,
		invalidUnresolvableDialysisInstrumentOptions,
		invalidunresolvableDialysateContainerOptions,
		invalidDialysateContainerMixOptions,
		invalidDialysisMethodMixTypeOptions,
		invalidNullStaticDialysisOptions,
		invalidNullDynamicDialysisOptions,
		invalidNumberOfDialysisRoundsNullMismatchOptions,
		invalidDialysateSamplingMismatchOptions,
		invalidNumberOfDialysisRoundsEquilibriumlMismatchOptions,
		invalidDialysateVolumeOptions,
		validContainerStoragConditionInvalidOptions,
		invalidLargeStaticDialysisSampleVolumeOptions,
		invalidDialysateInstrumentMismatchOptions,
		invalidConfictingEquilibriumDialysateVolumeOptions,
		invalidConflictingRetentateContainerOutPlateOptions,
		invalidConflictingRetentateSamplingContainerOutPlateOptions
	}]];

	(* combine the invalid input stogether *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInputs
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		invalidStaticDialysisTests,
		invalidDynamicDialysisTests,
		invalidDialysisMethodInstrumentTests,
		invalidDialysateTemperatureInstrumentTests,
		invalidSampleVolumeDialysisMembraneTests,
		invalidLargeDialysisSampleVolumeTests,
		invalidDialysisMembraneTemperatureTests,
		invalidDialysateContainerVolumeTests,
		invalidDialysisMixTypeInstrumentMismatchTests,
		invalidDialysisMixRateInstrumentMismatchTests,
		invalidConflictingDialysateSamplingVolumeTests,
		invalidConflictingRetentateSamplingVolumeTests,
		invalidConflictingDialysateContainerOutTests,
		invalidConflictingRetentateContainerOutTests,
		invalidRetentateSamplingMismatchTests,
		invalidNumberOfDialysisRoundsMismatchTests,
		invalidMissingDialysisMembraneMWCOTests,
		invalidDialysisMembraneSoakMismatchTests,
		invalidImpossibleFlowRateTests,
		invalidNoAvailableDialysisMembraneErrorTests,
		invalidUnresolvableDialysisInstrumentTests,
		invalidunresolvableDialysateContainerTests,
		invalidDialysateContainerMixTests,
		invalidDialysisMethodMixTypeTests,
		invalidNullStaticDialysisTests,
		invalidNullDynamicDialysisTests,
		invalidNumberOfDialysisRoundsNullMismatchTests,
		invalidDialysateSamplingMismatchTests,
		invalidNumberOfDialysisRoundsEquilibriumlMismatchTests,
		insufficientDialysateVolumeTests,
		aliquotTests,
		validContainerStorageConditionTests,
		invalidLargeStaticDialysisSampleVolumeTests,
		invalidDialysateInstrumentTests,
		invalidConfictingEquilibriumDialysateVolumeTests,
		insufficientStaticDialysateVolumeTests,
		invalidConflictingRetentateContainerOutPlateTests,
		invalidConflictingRetentateSamplingContainerOutPlateTests,
		tooManySamplesTest
	}], _EmeraldTest];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	(*Pull out the shared options*)
	{confirm,canaryBranch,template,cache,operator,upload,outputOption,subprotocolDescription,samplePreparation}=Lookup[myOptions,{Confirm,CanaryBranch,Template,Cache,Operator,Upload,Output,SubprotocolDescription,PreparatoryUnitOperations}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[Output -> Short]]], False,
		True, Lookup[myOptions, Email]
	];

	(* --- Do the final preparations --- *)
	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = Flatten[{
		DialysisMethod->resolveddialysisMethod,
		Instrument->resolvedinstrument,
		DynamicDialysisMethod->resolveddynamicDialysisMethod,
		FlowRate->resolvedflowRate,
		SampleVolume->resolvedsampleVolume,
		DialysisMembrane->resolveddialysisMembrane,
		MolecularWeightCutoff->resolvedmolecularWeightCutoff,
		DialysisMembraneSoak->resolveddialysisMembraneSoak,
		DialysisMembraneSoakSolution->resolveddialysisMembraneSoakSolution,
		DialysisMembraneSoakVolume->resolveddialysisMembraneSoakVolume,
		DialysisMembraneSoakTime->resolveddialysisMembraneSoakTime,
		ShareDialysateContainer->resolvedshareDialysateContainer,
		NumberOfDialysisRounds->resolvednumberOfDialysisRounds,
		ImageSystem->resolvedimageSystem,
		(*ImagingInterval->resolvedimagingInterval,*)
		DialysisTime->resolveddialysisTime,
		SecondaryDialysisTime->resolvedsecondaryDialysisTime,
		TertiaryDialysisTime->resolvedtertiaryDialysisTime,
		QuaternaryDialysisTime->resolvedquaternaryDialysisTime,
		QuinaryDialysisTime->resolvedquinaryDialysisTime,
		Dialysate->dialysate,
		SecondaryDialysate->resolvedsecondaryDialysate,
		TertiaryDialysate->resolvedtertiaryDialysate,
		QuaternaryDialysate->resolvedquaternaryDialysate,
		QuinaryDialysate->resolvedquinaryDialysate,
		DialysateVolume->resolveddialysateVolume,
		SecondaryDialysateVolume->resolvedsecondaryDialysateVolume,
		TertiaryDialysateVolume->resolvedtertiaryDialysateVolume,
		QuaternaryDialysateVolume->resolvedquaternaryDialysateVolume,
		QuinaryDialysateVolume->resolvedquinaryDialysateVolume,
		DialysateTemperature->dialysateTemperature,
		SecondaryDialysateTemperature->resolvedsecondaryDialysateTemperature,
		TertiaryDialysateTemperature->resolvedtertiaryDialysateTemperature,
		QuaternaryDialysateTemperature->resolvedquaternaryDialysateTemperature,
		QuinaryDialysateTemperature->resolvedquinaryDialysateTemperature,
		DialysisMixType->resolveddialysisMixType,
		DialysisMixRate->resolveddialysisMixRate,
		SecondaryDialysisMixRate->resolvedsecondaryDialysisMixRate,
		TertiaryDialysisMixRate->resolvedtertiaryDialysisMixRate,
		QuaternaryDialysisMixRate->resolvedquaternaryDialysisMixRate,
		QuinaryDialysisMixRate->resolvedquinaryDialysisMixRate,
		DialysateContainer->resolveddialysateContainer,
		SecondaryDialysateContainer->resolvedsecondaryDialysateContainer,
		TertiaryDialysateContainer->resolvedtertiaryDialysateContainer,
		QuaternaryDialysateContainer->resolvedquaternaryDialysateContainer,
		QuinaryDialysateContainer->resolvedquinaryDialysateContainer,
		DialysateSampling->resolveddialysateSampling,
		SecondaryDialysateSampling->resolvedsecondaryDialysateSampling,
		TertiaryDialysateSampling->resolvedtertiaryDialysateSampling,
		QuaternaryDialysateSampling->resolvedquaternaryDialysateSampling,
		QuinaryDialysateSampling->resolvedquinaryDialysateSampling,
		DialysateSamplingVolume->resolveddialysateSamplingVolume,
		SecondaryDialysateSamplingVolume->resolvedsecondaryDialysateSamplingVolume,
		TertiaryDialysateSamplingVolume->resolvedtertiaryDialysateSamplingVolume,
		QuaternaryDialysateSamplingVolume->resolvedquaternaryDialysateSamplingVolume,
		QuinaryDialysateSamplingVolume->resolvedquinaryDialysateSamplingVolume,
		DialysateStorageCondition->dialysateStorageCondition,
		SecondaryDialysateStorageCondition->secondaryDialysateStorageCondition,
		TertiaryDialysateStorageCondition->tertiaryDialysateStorageCondition,
		QuaternaryDialysateStorageCondition->quaternaryDialysateStorageCondition,
		QuinaryDialysateStorageCondition->quinaryDialysateStorageCondition,
		DialysateContainerOut->resolveddialysateContainerOut,
		SecondaryDialysateContainerOut->resolvedsecondaryDialysateContainerOut,
		TertiaryDialysateContainerOut->resolvedtertiaryDialysateContainerOut,
		QuaternaryDialysateContainerOut->resolvedquaternaryDialysateContainerOut,
		QuinaryDialysateContainerOut->resolvedquinaryDialysateContainerOut,
		RetentateSampling->resolvedretentateSampling,
		SecondaryRetentateSampling->resolvedsecondaryRetentateSampling,
		TertiaryRetentateSampling->resolvedtertiaryRetentateSampling,
		QuaternaryRetentateSampling->resolvedquaternaryRetentateSampling,
		RetentateSamplingVolume->resolvedretentateSamplingVolume,
		SecondaryRetentateSamplingVolume->resolvedsecondaryRetentateSamplingVolume,
		TertiaryRetentateSamplingVolume->resolvedtertiaryRetentateSamplingVolume,
		QuaternaryRetentateSamplingVolume->resolvedquaternaryRetentateSamplingVolume,
		RetentateSamplingContainerOut->resolvedretentateSamplingContainerOut,
		SecondaryRetentateSamplingContainerOut->resolvedsecondaryRetentateSamplingContainerOut,
		TertiaryRetentateSamplingContainerOut->resolvedtertiaryRetentateSamplingContainerOut,
		QuaternaryRetentateSamplingContainerOut->resolvedquaternaryRetentateSamplingContainerOut,
		RetentateSamplingStorageCondition->retentateSamplingStorageCondition,
		SecondaryRetentateSamplingStorageCondition->secondaryRetentateSamplingStorageCondition,
		TertiaryRetentateSamplingStorageCondition->tertiaryRetentateSamplingStorageCondition,
		QuaternaryRetentateSamplingStorageCondition->quaternaryRetentateSamplingStorageCondition,
		RetentateStorageCondition->retentateStorageCondition,
		RetentateContainerOut->resolvedretentateContainerOut,
		NumberOfReplicates -> numberOfReplicates,
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		Confirm -> confirm,
		CanaryBranch -> canaryBranch,
		Name -> name,
		Template -> template,
		Cache -> inheritedCache,
		Email -> email,
		FastTrack -> fastTrack,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		SubprotocolDescription->subprotocolDescription,
		Upload -> upload,
		PreparatoryUnitOperations->samplePreparation,
		SamplesInStorageCondition -> samplesInStorage
	}];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
];


	(* ::Subsubsection::Closed:: *)
(* dialysisResourcePackets (private helper)*)

DefineOptions[dialysisResourcePackets,
	Options :> {CacheOption,HelperOutputOption}
];

dialysisResourcePackets[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,messages,poolLengths,expandedInputs,expandedResolvedOptions,
		resolvedOptionsNoHidden, dialysisMethod,
		membraneKitProducts, membraneKitComponents,membraneKitComponentObjects,membraneKitComponentsPlateQ,
		batchingLength,runTimesGroup,secondaryRetentateSamplingContainersOutResources, tertiaryRetentateSamplingContainersOutResources,
		aliquotQs,dialysisContainerResource,quinaryDialysisContainerResource,
		aliquotVols,tertiaryDialysisContainerResource,quaternaryRetentateSamplingContainersOutResources,
		containerModelPackets, quaternaryDialysisContainerResource, retentateContainersOutResources,
		dialysisMembranes,secondaryDialysisContainerResource,
		inheritedCache, numReplicates, samplesInWithReplicates, pooledSamplesInWithReplicates,
		expandForNumReplicates, nestedSampleRequiredAmounts, runTime,
		pairedSamplesInAndVolumes, sampleVolumeRules, sampleResourceReplaceRules, containerObjs,
		protocolPacket, sharedFieldPacket, finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule,
		optionsRule, testsRule, resultRule, shareDialysateContainer,
		groupedBatches, samplesInResources, subGroupedBatches,
		sampleVolume, dialysisMembraneSoakSolution, dialysisMembraneSoakVolume,
		dialysisMembraneSoakTime, dialysate, secondaryDialysate, tertiaryDialysate,
		quaternaryDialysate, quinaryDialysate, dialysateVolume, secondaryDialysateVolume, retentateSamplingContainersOutResources,
		tertiaryDialysateVolume, quaternaryDialysateVolume, quinaryDialysateVolume, dialysateSamplingVolume,
		secondaryDialysateSamplingVolume, tertiaryDialysateSamplingVolume, quaternaryDialysateSamplingVolume, quinaryDialysateSamplingVolume,
		dialysateStorageCondition, secondaryDialysateStorageCondition, tertiaryDialysateStorageCondition, quaternaryDialysateStorageCondition,
		quinaryDialysateStorageCondition, dialysateContainerOut, secondaryDialysateContainerOut, tertiaryDialysateContainerOut,
		quaternaryDialysateContainerOut, quinaryDialysateContainerOut, retentateSamplingVolume, secondaryRetentateSamplingVolume,
		tertiaryRetentateSamplingVolume, quaternaryRetentateSamplingVolume, retentateSamplingContainerOut, secondaryRetentateSamplingContainerOut,
		tertiaryRetentateSamplingContainerOut, quaternaryRetentateSamplingContainerOut, retentateSamplingStorageCondition, secondaryRetentateSamplingStorageCondition,
		tertiaryRetentateSamplingStorageCondition, quaternaryRetentateSamplingStorageCondition, retentateStorageCondition, retentateContainerOut,
		runTimes, dialysisTime, secondaryDialysisTime, tertiaryDialysisTime, quaternaryDialysisTime,quinaryDialysisTime,
		dialysateContainersOutResources, secondaryDialysateContainersOutResources, tertiaryDialysateContainersOutResources,
		quaternaryDialysateContainersOutResources, quinaryDialysateContainersOutResources, dialysateObjVolPairs, groupedDialysateVolPairs,
		uniqueDialysateVolRequiredPairs, dialysateResourceMap, dialysateResources, secondaryDialysateResources,tertiaryDialysateResources,
		quaternaryDialysateResources, quinaryDialysateResources, subgroupedDialysateVolPairs, dialysateIDs, secondaryDialysateIDs,
		tertiaryDialysateIDs,quaternaryDialysateIDs,quinaryDialysateIDs, expandedDialysateResourceMap, flatDialysateResourceMap,
		dialysisMembraneSoakSolutionIDs, dialysisMembraneSoakSolutionResources, dialysateIDsNoNull,secondaryDialysateIDsNoNull,
		tertiaryDialysateIDsNoNull,quaternaryDialysateIDsNoNull,quinaryDialysateIDsNoNull, dialysisMembraneSoakSolutionIDsNoNull,
		dialysisMembraneResources, floatingRackResources, batchingIDs, groupFloats, subGroupedBatchesUnflat,groupFloatsUnflat,
		groupedIDs, groupFloatsExpanded, uniqueFloats,floatResourceMap, matchedFloats, topDialysisClips, membraneFlatWidths,membraneMaterials,
		bottomDialysisClips,dialysisClipResources, stirBarResources, stirBars, dialysisContainers,dialysisContainerAperatures,stirBarResourcesMap,
		dialysisMembraneLengths, membraneVolumePerLength, topDialysisClipLengthOffsets,bottomDialysisClipLengthOffsets,
		batchingParameters, batchingSingleParameters, numBatches, batchingMultipleParameters, groupdialysateIDsUnflat, groupdialysateIDs,
		matcheddialysateIDs, groupdialysateIDsUnflat2, groupdialysateIDsUnflat3, groupdialysateIDsUnflat4, groupdialysateIDsUnflat5,
		groupdsoakSolutionIDsUnFlat, groupdialysate2IDs, matcheddialysate2IDs,groupdialysate3IDs, matcheddialysate3IDs,groupdialysate4IDs,
		matcheddialysate4IDs, groupdialysate5IDs, matcheddialysate5IDs, groupdsoakSolutionIDs,matchedgroupdsoakSolutionIDs,
		batchdialysateIDsNoNull,batchsecondaryDialysateIDsNoNull,batchtertiaryDialysateIDsNoNull,batchquaternaryDialysateIDsNoNull,
		batchquinaryDialysateIDsNoNull,batchdialysisMembraneSoakSolutionIDsNoNull,batchdialysateResources,batchsecondaryDialysateResources,
		batchtertiaryDialysateResources,batchquaternaryDialysateResources,batchquinaryDialysateResources,batchdialysisMembraneSoakSolutionResources,
		membraneReplaceRules, dialysisMembraneSourceResources, dialysisMembraneSoakContainersResources, equilibriumDialysisPlateResources,
		groupInsertRacksUnflat, groupInsertRacks, groupSoakTimesUnflat, groupSoakTimes, batchingMultipleVolumes, batchingMultipleContainers,wasteContainerResource,
		loadingTipModels,pipetteTipResources,loadingTipResources,loadingPipettes, loadingPipetteResources,
		collectionTipResources,samplingTipModels,loadingTipRules,pipetteResource,samplingTipRules,samplingTipResources,secondarySamplingTipModels,
		tertiarySamplingTipModels,quaternarySamplingTipModels,secondarySamplingTipRules,tertiarySamplingTipRules,quaternarySamplingTipRules,
		secondarySamplingTipResources,tertiarySamplingTipResources, quaternarySamplingTipResources,kitProducts,containersOutResources,
		samplingPipettes,secondarySamplingPipettes,tertiarySamplingPipettes,quaternarySamplingPipettes,samplingPipetteResources,
		secondarySamplingPipetteResources, tertiarySamplingPipetteResources,quaternarySamplingPipetteResources,collectionPipetteResources,
		piptteBatching,batchingStorageConditions,samplesInStorageCondition,workSurface,stirBarRetriever,instrument, dialysisMixRate,dialysisMixRateSetting,
		secondaryDialysisMixRate,secondaryDialysisMixRateSetting,tertiaryDialysisMixRate,tertiaryDialysisMixRateSetting,
		quaternaryDialysisMixRate,quaternaryDialysisMixRateSetting,quinaryDialysisMixRate,quinaryDialysisMixRateSetting, collectionTipModels,
		collectionTipRules,collectionPipettes,cleaningSolutionResource,maxContainerVolume,hamiltonCompatibleContainers, hamiltonCompatibleContainerBools,
		compatibleContainers,equilibWasteContainer,potentailEquilibWasteContainers,numberOfSamples,uniqueContainerOutObjects,containerOutReplaceRules,
		downloadedContainerOutFields,dialysateContainersOutWells,gatheredDialysateContainerOut,groupedDialysateContainersOut,groupedDialysateContainersOutResources,
		gatheredsecondaryDialysateContainerOut, secondaryDialysateContainersOutWells, groupedsecondaryDialysateContainersOut,groupedsecondaryDialysateContainersOutResources,
		gatheredtertiaryDialysateContainerOut, tertiaryDialysateContainersOutWells,groupedtertiaryDialysateContainersOut,groupedtertiaryDialysateContainersOutResources,
		gatheredquaternaryDialysateContainerOut,quaternaryDialysateContainersOutWells,groupedquaternaryDialysateContainersOut,groupedquaternaryDialysateContainersOutResources,
		gatheredquinaryDialysateContainerOut, quinaryDialysateContainersOutWells, groupedquinaryDialysateContainersOut, groupedquinaryDialysateContainersOutResources,
		gatheredRetentateSamplingContainerOut,retentateSamplingContainersOutWells,groupedRetentateSamplingContainersOut, groupedRetentateSamplingContainersOutResources,
		gatheredsecondaryRetentateSamplingContainerOut, secondaryRetentateSamplingContainersOutWells,groupedsecondaryRetentateSamplingContainersOut, groupedsecondaryRetentateSamplingContainersOutResources,
		gatheredtertiaryRetentateSamplingContainerOut,tertiaryRetentateSamplingContainersOutWells,groupedtertiaryRetentateSamplingContainersOut,groupedtertiaryRetentateSamplingContainersOutResources,
		gatheredquaternaryRetentateSamplingContainerOut, quaternaryRetentateSamplingContainersOutWells, groupedquaternaryRetentateSamplingContainersOut, groupedquaternaryRetentateSamplingContainersOutResources,
		gatheredretentateContainerOut, retentateContainersOutWells, groupedretentateContainersOut,groupedretentateContainersOutResources,
		simulation
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentDialysis, {myPooledSamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentDialysis,
		RemoveHiddenOptions[ExperimentDialysis, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[myOptions], Cache];
	simulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	uniqueContainerOutObjects=DeleteDuplicates[Cases[Join[
		Lookup[myResolvedOptions,RetentateSamplingContainerOut],Lookup[myResolvedOptions,SecondaryRetentateSamplingContainerOut],Lookup[myResolvedOptions,TertiaryRetentateSamplingContainerOut],Lookup[myResolvedOptions,QuaternaryRetentateSamplingContainerOut],Lookup[myResolvedOptions,RetentateContainerOut],
		Lookup[myResolvedOptions,DialysateContainerOut],Lookup[myResolvedOptions,SecondaryDialysateContainerOut],Lookup[myResolvedOptions,TertiaryDialysateContainerOut],Lookup[myResolvedOptions,QuaternaryDialysateContainerOut],Lookup[myResolvedOptions,QuinaryDialysateContainerOut]
	],ObjectP[]]];

	(* Get the information we need via Download *)
	{
		containerObjs,
		containerModelPackets,
		downloadedContainerOutFields
	} = Quiet[Download[
		{
			Flatten[myPooledSamples],
			Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling],
			uniqueContainerOutObjects
		},
		{
			{Container[Object]},
			{Packet[MaxVolume]},
			{Packet[NumberOfWells]}
		},
		Simulation -> simulation,
		Date->Now
	]];

	containerOutReplaceRules=MapThread[
		(#1->#2[[1, 1]])&,
		{uniqueContainerOutObjects, downloadedContainerOutFields/.{$Failed -> 1}}
	];

	(* determine the pool lengths*)
	poolLengths = Length[#]& /@ myPooledSamples;

	(* get the number of replicates so that we can expand the fields (samplesIn etc.) accordingly  *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* == make the resources == *)

	(* get the SamplesIn accounting for the number of replicates *)
	(* note that we Flatten AFTER expanding so that we will have something like {s1,s2,s3,s1,2,s3,s4,s5,s4,s5} (from {{s1,s2,s3},{s4,s5}} *)
	pooledSamplesInWithReplicates = Join @@ Map[
		ConstantArray[#, numReplicates]&,
		Download[myPooledSamples, Object]
	];
	samplesInWithReplicates = Flatten[pooledSamplesInWithReplicates];

	(* we need to expand lots of the options to include number of replicates; making a function that just does this *)
	(* map over the provided option names; for each one, expand the value for it by the number of replicates*)
	expandForNumReplicates[myExpandedOptions:{__Rule}, myOptionNames:{__Symbol}, myNumberOfReplicates_Integer]:=Module[
		{},
		Map[
			Function[{optionName},
				(* need the Join @@ for this to work with pooled options *)
				Join @@ Map[
					ConstantArray[#, myNumberOfReplicates]&,
					Lookup[myExpandedOptions, optionName]
				]
			],
			myOptionNames
		]
	];

	(* Pull out important non index matched options*)
	{
		dialysisMethod,
		shareDialysateContainer,
		dialysisTime,
		secondaryDialysisTime,
		tertiaryDialysisTime,
		quaternaryDialysisTime,
		quinaryDialysisTime
	}= Lookup[expandedResolvedOptions,
		{
			DialysisMethod,
			ShareDialysateContainer,
			DialysisTime,
			SecondaryDialysisTime,
			TertiaryDialysisTime,
			QuaternaryDialysisTime,
			QuinaryDialysisTime
		}
	];

	(* expand all the important index matching fields for NumberOfReplicates *)
	{
		aliquotQs,
		aliquotVols,
		dialysisMembranes,
		sampleVolume,
		dialysisMembraneSoakSolution,
		dialysisMembraneSoakVolume,
		dialysisMembraneSoakTime,
		dialysate,
		secondaryDialysate,
		tertiaryDialysate,
		quaternaryDialysate,
		quinaryDialysate,
		dialysateVolume,
		secondaryDialysateVolume,
		tertiaryDialysateVolume,
		quaternaryDialysateVolume,
		quinaryDialysateVolume,
		dialysateSamplingVolume,
		secondaryDialysateSamplingVolume,
		tertiaryDialysateSamplingVolume,
		quaternaryDialysateSamplingVolume,
		quinaryDialysateSamplingVolume,
		dialysateStorageCondition,
		secondaryDialysateStorageCondition,
		tertiaryDialysateStorageCondition,
		quaternaryDialysateStorageCondition,
		quinaryDialysateStorageCondition,
		dialysateContainerOut,
		secondaryDialysateContainerOut,
		tertiaryDialysateContainerOut,
		quaternaryDialysateContainerOut,
		quinaryDialysateContainerOut,
		retentateSamplingVolume,
		secondaryRetentateSamplingVolume,
		tertiaryRetentateSamplingVolume,
		quaternaryRetentateSamplingVolume,
		retentateSamplingContainerOut,
		secondaryRetentateSamplingContainerOut,
		tertiaryRetentateSamplingContainerOut,
		quaternaryRetentateSamplingContainerOut,
		retentateSamplingStorageCondition,
		secondaryRetentateSamplingStorageCondition,
		tertiaryRetentateSamplingStorageCondition,
		quaternaryRetentateSamplingStorageCondition,
		retentateStorageCondition,
		retentateContainerOut,
		samplesInStorageCondition
	} = expandForNumReplicates[expandedResolvedOptions, {
		Aliquot,
		AliquotAmount,
		DialysisMembrane,
		SampleVolume,
		DialysisMembraneSoakSolution,
		DialysisMembraneSoakVolume,
		DialysisMembraneSoakTime,
		Dialysate,
		SecondaryDialysate,
		TertiaryDialysate,
		QuaternaryDialysate,
		QuinaryDialysate,
		DialysateVolume,
		SecondaryDialysateVolume,
		TertiaryDialysateVolume,
		QuaternaryDialysateVolume,
		QuinaryDialysateVolume,
		DialysateSamplingVolume,
		SecondaryDialysateSamplingVolume,
		TertiaryDialysateSamplingVolume,
		QuaternaryDialysateSamplingVolume,
		QuinaryDialysateSamplingVolume,
		DialysateStorageCondition,
		SecondaryDialysateStorageCondition,
		TertiaryDialysateStorageCondition,
		QuaternaryDialysateStorageCondition,
		QuinaryDialysateStorageCondition,
		DialysateContainerOut,
		SecondaryDialysateContainerOut,
		TertiaryDialysateContainerOut,
		QuaternaryDialysateContainerOut,
		QuinaryDialysateContainerOut,
		RetentateSamplingVolume,
		SecondaryRetentateSamplingVolume,
		TertiaryRetentateSamplingVolume,
		QuaternaryRetentateSamplingVolume,
		RetentateSamplingContainerOut,
		SecondaryRetentateSamplingContainerOut,
		TertiaryRetentateSamplingContainerOut,
		QuaternaryRetentateSamplingContainerOut,
		RetentateSamplingStorageCondition,
		SecondaryRetentateSamplingStorageCondition,
		TertiaryRetentateSamplingStorageCondition,
		QuaternaryRetentateSamplingStorageCondition,
		RetentateStorageCondition,
		RetentateContainerOut,
		SamplesInStorageCondition
	}, numReplicates];

	(* get the amount required of each sample in the correct nesting arrangement *)
	nestedSampleRequiredAmounts = MapThread[
		Function[{aliquotQ, aliquotAmount, sampVolume},
			If[aliquotQ,
				aliquotAmount,
				{sampVolume}
			]
		],
		{aliquotQs, aliquotVols, sampleVolume}
	];

	(* make a list of rules that connect the samples and the necessary amounts *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, Flatten[nestedSampleRequiredAmounts]}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources =samplesInWithReplicates/.sampleResourceReplaceRules;

	(* Checkout if a plate came with the membrane kit to see how to work with it*)
	membraneKitProducts= If[
		MatchQ[#,Null],
		Null,
		kitProducts=Lookup[First[DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[{
				Object->ObjectP[#]
			}]
		]]],KitProducts];
		If[
			MatchQ[Length[kitProducts],0],
			Null,
			First[kitProducts]
		]
	]&/@dialysisMembranes;

	(* extract the KitComponents from the kit products*)
	membraneKitComponents=If[
		MatchQ[#,Null],
		Null,
		Lookup[First[DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[{
				Object->ObjectP[#]
			}]
		]]],KitComponents]
	]&/@membraneKitProducts;

	(* get a list of the object models from the kit*)
	membraneKitComponentObjects=If[
		MatchQ[#, Null],
		Null,
		Lookup[#, ProductModel]]
		& /@membraneKitComponents;

	(* --- Membrane Related Resources -- *)
	(*Requests for the same tube type should be one resource, make a resource map so they can share*)
	membraneReplaceRules=#->Link[Resource[Sample->#,Name -> ToString[Unique[]]]]&/@
     DeleteDuplicates[DeleteCases[dialysisMembranes,
		Except[ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]]
	 ]];

	(*Make some new Object IDs for the membranes that will be cut to fufill these*)
	dialysisMembraneResources=If[
		MatchQ[#,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
		Link[CreateID[Object[Item,DialysisMembrane]]],
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]
	]&/@dialysisMembranes;

	(*Resources for the tubing rolls that will be cut*)
	dialysisMembraneSourceResources=If[
		MatchQ[#,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
		#,
		Null
	]&/@dialysisMembranes/.membraneReplaceRules;

	(* --- DialysisClips--- *)
	(*to find a clip we need the flat width of the tubing and material of tubing*)
	{membraneFlatWidths,membraneMaterials, membraneVolumePerLength}=Transpose[If[
		MatchQ[#,ObjectP[Model[Item,DialysisMembrane]]],
		(*if it is tubing*)
		Lookup[
		First[DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[{
				Object->ObjectP[#]
			}]
		]]],{FlatWidth,MembraneMaterial,VolumePerLength}],
		(*if it is not tubing*)
		{Null,Null,Null}
	]&/@dialysisMembranes];

	(*find the model for the top clip, this should be a regular clip for static dialysis, hanging for dynamic*)
	topDialysisClips=MapThread[
		Function[
			{dialysisMembrane, membraneFlatWidth,membraneMaterial},
			Which[
				(*hanging clip for dyanamic dialysis*)
				MatchQ[dialysisMembrane,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]]&&MatchQ[dialysisMethod,DynamicDialysis],
				Lookup[First[
					Sort[
						DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Part,DialysisClip],
								Hanging->True,
								Weighted->False,
								MaxWidth->GreaterEqualP[membraneFlatWidth],
								MembraneTypes->If[MatchQ[membraneMaterial,RegeneratedCellulose],membraneMaterial,Universal]
							}]
						]],
						Lookup[#1, MaxWidth] < Lookup[#2, MaxWidth]&]
				],Object],
				(*non-hanging clip for static dialysis*)
				MatchQ[dialysisMembrane,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
				Lookup[First[
					Sort[
						DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Part,DialysisClip],
								Weighted->False,
								Hanging->False,
								MaxWidth->GreaterEqualP[membraneFlatWidth],
								MembraneTypes->If[MatchQ[membraneMaterial,RegeneratedCellulose],membraneMaterial,Universal]
							}]
						]],
						Lookup[#1, MaxWidth] < Lookup[#2, MaxWidth]&]
				],Object],
				(*No need for this*)
				True,
				Null
			]
		],
		{dialysisMembranes, membraneFlatWidths,membraneMaterials}
	];

	(*the bottom ones should be weighted*)
	bottomDialysisClips=MapThread[
		Function[
			{dialysisMembrane, membraneFlatWidth,membraneMaterial},
			Which[
				(*weighted clip for all dialysis in tubes*)
				MatchQ[dialysisMembrane,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
				Lookup[First[
					Sort[
						DeleteDuplicates[Cases[inheritedCache,
							KeyValuePattern[{
								Type->Model[Part,DialysisClip],
								Weighted->True,
								MaxWidth->GreaterEqualP[membraneFlatWidth],
								MembraneTypes->If[MatchQ[membraneMaterial,RegeneratedCellulose],membraneMaterial,Universal]
							}]
						]],
						Lookup[#1, MaxWidth] < Lookup[#2, MaxWidth]&]
				],Object],
				(*No need for this*)
				True,
				Null
			]
		],
		{dialysisMembranes, membraneFlatWidths,membraneMaterials}
	];

	(*makes the resoucres for the DialysisClips*)
	dialysisClipResources=MapThread[If[
		MatchQ[#1,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
		{Link[Resource[Sample->#2,Name -> ToString[Unique[]],Rent->True]],Link[Resource[Sample->#3, Name -> ToString[Unique[]],Rent->True]]},
		{Null,Null}
	]&,{dialysisMembranes, bottomDialysisClips, topDialysisClips}];


	(*Make the resources for all the ContainersOut *)
	(*gather the same containers togeather*)
	gatheredDialysateContainerOut=Gather[retentateSamplingContainerOut];

	(*check how many wells are in the containers*)
	dialysateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredDialysateContainerOut;

	(*group like samples *)
	groupedDialysateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredDialysateContainerOut, dialysateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedDialysateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedDialysateContainersOut,1];

	(*expand that resource back to samples in*)
	dialysateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedDialysateContainersOutResources,groupedDialysateContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredsecondaryDialysateContainerOut=Gather[secondaryDialysateContainerOut];

	(*check how many wells are in the containers*)
	secondaryDialysateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredsecondaryDialysateContainerOut;

	(*group like samples *)
	groupedsecondaryDialysateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredsecondaryDialysateContainerOut, secondaryDialysateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedsecondaryDialysateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedsecondaryDialysateContainersOut,1];

	(*expand that resource back to samples in*)
	secondaryDialysateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedsecondaryDialysateContainersOutResources,groupedsecondaryDialysateContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredtertiaryDialysateContainerOut=Gather[tertiaryDialysateContainerOut];

	(*check how many wells are in the containers*)
	tertiaryDialysateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredtertiaryDialysateContainerOut;

	(*group like samples *)
	groupedtertiaryDialysateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredtertiaryDialysateContainerOut, tertiaryDialysateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedtertiaryDialysateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedtertiaryDialysateContainersOut,1];

	(*expand that resource back to samples in*)
	tertiaryDialysateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedtertiaryDialysateContainersOutResources,groupedtertiaryDialysateContainersOut}],1];


	(*gather the sane containers togeather*)
	gatheredquaternaryDialysateContainerOut=Gather[quaternaryDialysateContainerOut];

	(*check how many wells are in the containers*)
	quaternaryDialysateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredquaternaryDialysateContainerOut;

	(*group like samples *)
	groupedquaternaryDialysateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredquaternaryDialysateContainerOut, quaternaryDialysateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedquaternaryDialysateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedquaternaryDialysateContainersOut,1];

	(*expand that resource back to samples in*)
	quaternaryDialysateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedquaternaryDialysateContainersOutResources,groupedquaternaryDialysateContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredquinaryDialysateContainerOut=Gather[quinaryDialysateContainerOut];

	(*check how many wells are in the containers*)
	quinaryDialysateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredquinaryDialysateContainerOut;

	(*group like samples *)
	groupedquinaryDialysateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredquinaryDialysateContainerOut, quinaryDialysateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedquinaryDialysateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedquinaryDialysateContainersOut,1];

	(*expand that resource back to samples in*)
	quinaryDialysateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedquinaryDialysateContainersOutResources,groupedquinaryDialysateContainersOut}],1];
	retentateSamplingContainersOutResources=If[MatchQ[#,Null],
		Null,
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]]&/@retentateSamplingContainerOut;

	secondaryRetentateSamplingContainersOutResources=If[MatchQ[#,Null],
		Null,
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]]&/@secondaryRetentateSamplingContainerOut;

	tertiaryRetentateSamplingContainersOutResources=If[MatchQ[#,Null],
		Null,
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]]&/@tertiaryRetentateSamplingContainerOut;

	quaternaryRetentateSamplingContainersOutResources=If[MatchQ[#,Null],
		Null,
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]]&/@quaternaryRetentateSamplingContainerOut;

	retentateContainersOutResources=If[MatchQ[#,Null],
		Null,
		Link[Resource[Sample->#,Name -> ToString[Unique[]]]]]&/@retentateContainerOut;

	(*gather the same containers togeather*)
	gatheredRetentateSamplingContainerOut=Gather[dialysateContainerOut];

	(*check how many wells are in the containers*)
	retentateSamplingContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredRetentateSamplingContainerOut;

	(*group like samples *)
	groupedRetentateSamplingContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredRetentateSamplingContainerOut, retentateSamplingContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedRetentateSamplingContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedRetentateSamplingContainersOut,1];

	(*expand that resource back to samples in*)
	retentateSamplingContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedRetentateSamplingContainersOutResources,groupedRetentateSamplingContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredsecondaryRetentateSamplingContainerOut=Gather[secondaryRetentateSamplingContainerOut];

	(*check how many wells are in the containers*)
	secondaryRetentateSamplingContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredsecondaryRetentateSamplingContainerOut;

	(*group like samples *)
	groupedsecondaryRetentateSamplingContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredsecondaryRetentateSamplingContainerOut, secondaryRetentateSamplingContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedsecondaryRetentateSamplingContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedsecondaryRetentateSamplingContainersOut,1];

	(*expand that resource back to samples in*)
	secondaryRetentateSamplingContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedsecondaryRetentateSamplingContainersOutResources,groupedsecondaryRetentateSamplingContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredtertiaryRetentateSamplingContainerOut=Gather[tertiaryRetentateSamplingContainerOut];

	(*check how many wells are in the containers*)
	tertiaryRetentateSamplingContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredtertiaryRetentateSamplingContainerOut;

	(*group like samples *)
	groupedtertiaryRetentateSamplingContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredtertiaryRetentateSamplingContainerOut, tertiaryRetentateSamplingContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedtertiaryRetentateSamplingContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedtertiaryRetentateSamplingContainersOut,1];

	(*expand that resource back to samples in*)
	tertiaryRetentateSamplingContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedtertiaryRetentateSamplingContainersOutResources,groupedtertiaryRetentateSamplingContainersOut}],1];


	(*gather the sane containers togeather*)
	gatheredquaternaryRetentateSamplingContainerOut=Gather[quaternaryRetentateSamplingContainerOut];

	(*check how many wells are in the containers*)
	quaternaryRetentateSamplingContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredquaternaryRetentateSamplingContainerOut;

	(*group like samples *)
	groupedquaternaryRetentateSamplingContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredquaternaryRetentateSamplingContainerOut, quaternaryRetentateSamplingContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedquaternaryRetentateSamplingContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedquaternaryRetentateSamplingContainersOut,1];

	(*expand that resource back to samples in*)
	quaternaryRetentateSamplingContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedquaternaryRetentateSamplingContainersOutResources,groupedquaternaryRetentateSamplingContainersOut}],1];

	(*gather the sane containers togeather*)
	gatheredretentateContainerOut=Gather[retentateContainerOut];

	(*check how many wells are in the containers*)
	retentateContainersOutWells=If[
		MatchQ[First[#],Null],
		1,
		Lookup[containerOutReplaceRules,First[#]]
	]&/@gatheredretentateContainerOut;

	(*group like samples *)
	groupedretentateContainersOut = Flatten[MapThread[
		If[Length[#1] > #2, Partition[#1, UpTo[#2]], {#1}] &,
		{gatheredretentateContainerOut, retentateContainersOutWells}
	], 1];

	(*make a resource for each container*)
	groupedretentateContainersOutResources=Flatten[If[MatchQ[First[#],Null],
		Null,
		Link[Resource[Sample->First[#],Name -> ToString[Unique[]]]]
	]&/@groupedretentateContainersOut,1];

	(*expand that resource back to samples in*)
	retentateContainersOutResources=Flatten[MapThread[If[MatchQ[#,Null],
		Null,
		Table[#1,Length[#2]]
	]&,{groupedretentateContainersOutResources,groupedretentateContainersOut}],1];

	(* a container to put the tubing in to soak *)
	dialysisMembraneSoakContainersResources=MapThread[
		Which[
			(*no soaking, no container*)
			MatchQ[#2,Null],
			Null,
			(*tubing, fing a big enough container to hold the volume*)
			MatchQ[#1,ObjectP[Model[Item,DialysisMembrane]]],
			Link[Resource[Sample->Which[
				MatchQ[#2,RangeP[0,100Milliliter]], Model[Container, Vessel, "id:aXRlGnZmOOJk"],
				MatchQ[#2,RangeP[100Milliliter,600Milliliter]], Model[Container, Vessel, "id:R8e1PjRDbbOv"],
				MatchQ[#2,RangeP[600Milliliter,1000Milliliter]],Model[Container, Vessel, "id:O81aEB4kJJJo"],
				MatchQ[#2,RangeP[1000Milliliter,2000Milliliter]],Model[Container, Vessel, "id:wqW9BP4Y0009"]
			],Name -> ToString[Unique[]],Rent->True]],
			True,
			Null
		]
			&,{dialysisMembranes,dialysisMembraneSoakVolume}];

	(*If the cleaning is putting solution in the membrane and removing it, it should go in a waste container large enough to hold the waste,
	this happens for anything but the tubing.*)
	hamiltonCompatibleContainers=If[
		MatchQ[dialysisMethod,Except[EquilibriumDialysis]],
		Null,
		Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling]
	];

	hamiltonCompatibleContainerBools=If[
		MatchQ[dialysisMethod,Except[EquilibriumDialysis]],
		Null,
		Experiment`Private`tipsReachContainerBottomQ[Model[Item, Tips, "50 uL Hamilton tips, non-sterile"], Download[#,Cache->inheritedCache,Simulation->simulation], {Download[Model[Item, Tips, "50 uL Hamilton tips, non-sterile"],Cache->inheritedCache,Simulation->simulation]}] & /@ hamiltonCompatibleContainers
	];

	compatibleContainers=If[
		MatchQ[dialysisMethod,Except[EquilibriumDialysis]],
		Null,
		PickList[hamiltonCompatibleContainers, hamiltonCompatibleContainerBools]
	];

	potentailEquilibWasteContainers=PreferredContainer[
		Total[
			PickList[dialysisMembraneSoakVolume/.Null->0 Milliliter, dialysisMembranes, Except[ObjectP[Model[Item,DialysisMembrane]]]]
		],
		If[MatchQ[dialysisMethod,EquilibriumDialysis],LiquidHandlerCompatible -> True,Nothing],
		All->True
	];

	equilibWasteContainer=If[
		MatchQ[dialysisMethod,Except[EquilibriumDialysis]],
		Null,
		If[
			MatchQ[Intersection[potentailEquilibWasteContainers,compatibleContainers],{}],
			Model[Container, Plate, "id:54n6evLWKqbG"],
			First[Intersection[potentailEquilibWasteContainers,compatibleContainers]]
		]
	];



	wasteContainerResource=Which[
		(*If there is no waste to hold this is a Null resource*)
		Or[MatchQ[Total[dialysisMembraneSoakVolume/.Null->0 Milliliter],0Milliliter],MatchQ[dialysisMembranes,{ObjectP[Model[Item,DialysisMembrane]]..}]],
		Null,
		(*if it is a equilibrium it is the soak solution, it must be hamilton compatible with the plates*)
		MatchQ[dialysisMethod,EquilibriumDialysis],
		Link[Resource[Sample->PreferredContainer[
			Total[
				PickList[dialysisMembraneSoakVolume/.Null->0 Milliliter, dialysisMembranes, Except[ObjectP[Model[Item,DialysisMembrane]]]]
			]
		]]],
		(*if it is a vessel it is the soak solution*)
		True,
		Link[Resource[Sample->PreferredContainer[
			Total[
				PickList[dialysisMembraneSoakVolume/.Null->0 Milliliter, dialysisMembranes, Except[ObjectP[Model[Item,DialysisMembrane]]]]
		]
		],Rent->True]]
	];

	(*create resource IDs for the dialysates for sharing resources, this will come in handy after I batch the samples*)
	dialysateIDs=Table[CreateUUID[],Length[dialysate]];
	secondaryDialysateIDs=Table[CreateUUID[],Length[secondaryDialysate]];
	tertiaryDialysateIDs=Table[CreateUUID[],Length[tertiaryDialysate]];
	quaternaryDialysateIDs=Table[CreateUUID[],Length[quaternaryDialysate]];
	quinaryDialysateIDs=Table[CreateUUID[],Length[quinaryDialysate]];
	dialysisMembraneSoakSolutionIDs=Table[CreateUUID[],Length[dialysisMembraneSoakSolution]];

(* group the samples with an ID to make it easier to match after*)
	batchingIDs=Table[i,{i,Length[dialysisMembranes]}];

	(* ---- BATCHING CALCULATIONS ---- *)
	groupedBatches = GatherBy[
		Transpose[{
			(* Required Matching *)
			(* General *)
			(*1*)pooledSamplesInWithReplicates,

			(* membranes or grouping *)
			(*2*)dialysisMembranes,

			(*Others*)
			(*3*)membraneKitComponentObjects,
			dialysisMembraneSoakContainersResources,
			(*5*)sampleVolume,
			dialysisMembraneSoakSolution,
			dialysisMembraneSoakVolume,
			(*8*)dialysisMembraneSoakTime,
			dialysate,
			(*10*)secondaryDialysate,
			tertiaryDialysate,
			quaternaryDialysate,
			quinaryDialysate,
			dialysateVolume,
			(*15*)secondaryDialysateVolume,
			tertiaryDialysateVolume,
			quaternaryDialysateVolume,
			quinaryDialysateVolume,
			dialysateSamplingVolume,
			(*20*)secondaryDialysateSamplingVolume,
			tertiaryDialysateSamplingVolume,
			quaternaryDialysateSamplingVolume,
			quinaryDialysateSamplingVolume,
			dialysateStorageCondition,
			(*25*)secondaryDialysateStorageCondition,
			tertiaryDialysateStorageCondition,
			quaternaryDialysateStorageCondition,
			quinaryDialysateStorageCondition,
			dialysateContainersOutResources,
			(*30*)secondaryDialysateContainersOutResources,
			tertiaryDialysateContainersOutResources,
			quaternaryDialysateContainersOutResources,
			quinaryDialysateContainersOutResources,
			retentateSamplingVolume,
			(*35*)secondaryRetentateSamplingVolume,
			tertiaryRetentateSamplingVolume,
			quaternaryRetentateSamplingVolume,
			retentateSamplingContainersOutResources,
			secondaryRetentateSamplingContainersOutResources,
			(*40*)tertiaryRetentateSamplingContainersOutResources,
			quaternaryRetentateSamplingContainersOutResources,
			retentateSamplingStorageCondition,
			secondaryRetentateSamplingStorageCondition,
			tertiaryRetentateSamplingStorageCondition,
			quaternaryRetentateSamplingStorageCondition,
			retentateStorageCondition,
			retentateContainersOutResources,
			(*48*)batchingIDs,
			dialysisMembraneResources,
			dialysisClipResources,
			(*51*)dialysateIDs,
			secondaryDialysateIDs,
			tertiaryDialysateIDs,
			quaternaryDialysateIDs,
			quinaryDialysateIDs,
			(*56*)dialysisMembraneSoakSolutionIDs,
			samplesInStorageCondition
		}],

		(* Group by dialysis membranes and membrane soaktime*)
		{#[[4]], #[[8]]}&
	];

	(* For each grouping of batched parameters, they were just broke into the desired partition size based on membrane type and soak time*)
	(* this next grouping will subgroup them again based on capacity of the type/floating rack*)
{
	subGroupedBatchesUnflat,
	groupFloatsUnflat,
	groupdialysateIDsUnflat,
	groupdialysateIDsUnflat2,
	groupdialysateIDsUnflat3,
	groupdialysateIDsUnflat4,
	groupdialysateIDsUnflat5,
	groupdsoakSolutionIDsUnFlat,
	groupInsertRacksUnflat,
	groupSoakTimesUnflat
} =Transpose[Map[
		Function[{groupedBatch},
			Module[
				{
					groupDialysisMembrane, groupDialysisMembraneNumber, groupDialysisMembranePlateBool, groupMembraneKitComponentObjects,
					groupFloat, groupDialysisMembraneDiameter,groupFloatCapacity, subGroupedBatch, runTime, dialysatesIDs,
					secondarydialysatesIDs, tertiarydialysatesIDs, quaternarydialysatesIDs, quinarydialysatesIDs, soakSolutionIDs,groupInsertRack,groupSoakTime
				},
				(*The membrane of the group, they are grouped by membrane so one per group*)
				groupDialysisMembrane=First[ToList[#&/@groupedBatch[[ All, 2]]]];

				(*The width of the membrane vessel*)
				groupDialysisMembraneDiameter=If[
					MatchQ[groupDialysisMembrane,ObjectP[Model[Container,Vessel,Dialysis]]],
					First[Lookup[First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[groupDialysisMembrane]
						}]
					]]],Dimensions]],
					Null
				];

				(*the objects in the kit*)
				groupMembraneKitComponentObjects=First[ToList[#&/@groupedBatch[[ All, 3]]]];

				(*Find a floating rack for it to go in*)
				groupFloat=Which[
					(* If the membrane does not need a rack return Null *)
					MatchQ[groupDialysisMembrane,ObjectP[{Model[Item,DialysisMembrane],Model[Container,Plate,Dialysis]}]],
					Null,
					(* If there is a floating  rack in the kit, pick that one *)
					MemberQ[groupMembraneKitComponentObjects,ObjectP[Model[Container,FloatingRack]]],
					Cases[groupMembraneKitComponentObjects, ObjectP[Model[Container, FloatingRack]]][[1,1]],
					(* If not find a rack that fits *)
					True,
					First[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[Model[Container, FloatingRack]],
							(*the holes stretch to fit snuggly*)
							SlotDiameter->RangeP[groupDialysisMembraneDiameter*0.7,groupDialysisMembraneDiameter]
						}]
					]]]
				];

				(*how many vessels can the group hold*)
				groupFloatCapacity=If[
					MatchQ[groupFloat,Null],
					Null,
					Lookup[First[ToList[DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Object->ObjectP[groupFloat]
						}]
					]]]],NumberOfSlots]
				];

				(*Find a container for the equilibrium dialysis inserts to go in*)
				groupInsertRack=If[
					MatchQ[groupDialysisMembrane,ObjectP[{Model[Container,Plate,Dialysis],Object[Container,Plate,Dialysis]}]],
					Model[Container, Plate, "Rapid Equilibrium Dialysis Base Plates"],
					Null
				];

				(*The number of sample at a time for this membrane*)
				groupDialysisMembraneNumber=Which[
					(* Dynamic dialysis is 1 at a time*)
					MatchQ[dialysisMethod,DynamicDialysis],
					1,
					(*Equilibrium dialysis is 96/2=48*)
					MatchQ[dialysisMethod,EquilibriumDialysis],
					48,
					(*If it is in a vessel, how many tubes can the rack hold if we are sharing*)
					MatchQ[groupDialysisMembrane,ObjectP[Model[Container,Vessel,Dialysis]]],
					If[shareDialysateContainer,groupFloatCapacity,1],
					(*If it's in a membrane tube share they with two tubes if you are allowing sharing*)
					True,
					If[shareDialysateContainer,2,1]
				];

				(*preform the batch by these subgroups*)
				subGroupedBatch=If[Length[groupedBatch] > groupDialysisMembraneNumber, Partition[groupedBatch, UpTo[groupDialysisMembraneNumber]], {groupedBatch}];

				(*if we are going static dialysis and sharing, we only need one dialysate, so group them to one ID*)
				dialysatesIDs=If[
					MatchQ[dialysisMethod,StaticDialysis],
					(* If the dialysate is being shared only give it one resource ID*)
					Table[First[#[[ All, 51]]],Length[#]]&/@subGroupedBatch,
					#[[ All, 51]]&/@subGroupedBatch
				];

				secondarydialysatesIDs=If[
					MatchQ[dialysisMethod,StaticDialysis],
					(* If the dialysate is being shared only give it one resource ID*)
					Table[First[#[[ All, 52]]],Length[#]]&/@subGroupedBatch,
					#[[ All, 52]]&/@subGroupedBatch
				];

				tertiarydialysatesIDs=If[
					MatchQ[dialysisMethod,StaticDialysis],
					(* If the dialysate is being shared only give it one resource ID*)
					Table[First[#[[ All, 53]]],Length[#]]&/@subGroupedBatch,
					#[[ All, 53]]&/@subGroupedBatch
				];

				quaternarydialysatesIDs=If[
					MatchQ[dialysisMethod,StaticDialysis],
					(* If the dialysate is being shared only give it one resource ID*)
					Table[First[#[[ All, 54]]],Length[#]]&/@subGroupedBatch,
					#[[ All, 54]]&/@subGroupedBatch
				];

				quinarydialysatesIDs=If[
					MatchQ[dialysisMethod,StaticDialysis],
					(* If the dialysate is being shared only give it one resource ID*)
					Table[First[#[[ All, 55]]],Length[#]]&/@subGroupedBatch,
					#[[ All, 55]]&/@subGroupedBatch
				];

				soakSolutionIDs=#[[ All, 56]]&/@subGroupedBatch;

				(*the soak time for the subgroups*)
				groupSoakTime=First[#[[ All, 8]]]&/@subGroupedBatch;

				{
					subGroupedBatch,
					Table[groupFloat,Length[subGroupedBatch]],
					dialysatesIDs,
					secondarydialysatesIDs,
					tertiarydialysatesIDs,
					quaternarydialysatesIDs,
					quinarydialysatesIDs,
					soakSolutionIDs,
					groupInsertRack,
					groupSoakTime
				}
				]
		],

		(* We're mapping all the code above over our groupings to condense the batches for samples that can be dialyzed together *)
		groupedBatches
	]];

	(*Flatten the grouped variables*)
	subGroupedBatches=Flatten[subGroupedBatchesUnflat,1];
	groupFloats=Flatten[groupFloatsUnflat,1];
	groupInsertRacks=Flatten[groupInsertRacksUnflat,1];
	groupSoakTimes=Flatten[groupSoakTimesUnflat,1];
	groupedIDs=#[[All,48]]&/@subGroupedBatches;

	(*Flatten the grouped variables these will go into the batching field and their own separate field matched to pooledsamplesin*)
	groupdialysateIDs=Flatten[groupdialysateIDsUnflat,1];
	matcheddialysateIDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdialysateIDs]}]][[All,2]];
	groupdialysate2IDs=Flatten[groupdialysateIDsUnflat2,1];
	matcheddialysate2IDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdialysate2IDs]}]][[All,2]];
	groupdialysate3IDs=Flatten[groupdialysateIDsUnflat3,1];
	matcheddialysate3IDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdialysate3IDs]}]][[All,2]];
	groupdialysate4IDs=Flatten[groupdialysateIDsUnflat4,1];
	matcheddialysate4IDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdialysate4IDs]}]][[All,2]];
	groupdialysate5IDs=Flatten[groupdialysateIDsUnflat5,1];
	matcheddialysate5IDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdialysate5IDs]}]][[All,2]];
	groupdsoakSolutionIDs=Flatten[groupdsoakSolutionIDsUnFlat,1];
	matchedgroupdsoakSolutionIDs=Sort[MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupdsoakSolutionIDs]}]][[All,2]];

	groupFloatsExpanded=MapThread[Table[#1,Length[#2]]&,{groupFloats,groupedIDs}];

	(*return the floats that correspond to each sample in order*)
	matchedFloats=MapThread[{#1,#2}&,{Flatten[groupedIDs],Flatten[groupFloatsExpanded]}];

	(* Pull out the sample and total volume for each pair *)
	uniqueFloats=DeleteDuplicates[DeleteCases[Flatten[groupFloats],Null]];

	(* Generate resources for the solutions required, and combine resources of the same model up to 20 Liter*)
	floatResourceMap = Map[
			# -> Link[Resource[Sample -> #, Name -> ToString[Unique[]]]]&,
		uniqueFloats
	];

	(* Estimate how long the actual run will take *)
	runTimesGroup=Table[Total[{dialysisTime,secondaryDialysisTime, tertiaryDialysisTime, quaternaryDialysisTime, quinaryDialysisTime}/.{Null->0Minute}], Length[subGroupedBatches]];
	runTimes=Table[Total[{dialysisTime,secondaryDialysisTime, tertiaryDialysisTime, quaternaryDialysisTime, quinaryDialysisTime}/.{Null->0Minute}], Length[samplesInResources]];

	(*extract how many samples are in each batch*)
	batchingLength=Length[#]&/@subGroupedBatches;

	(*The tips are needed for the dialysis membrane tubing beacuse we can't use SM, the sample loading any retentate collection and retenate collection*)

	(*find the model of tip that will load the sample, I want to load by pipette-aid, so if it is over 50ml I will still use the 50ml tip and reuse it*)
	loadingTipModels=MapThread[
		If[
			MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:aXRlGnZmOJdv"]}})[[1,1]],
			Null
		]&,
		{sampleVolume,dialysisMembranes}
	];

	(*Same thing for all the removal of sample from the tubes, however the 50ml tip is too wide for the tubes so use 25ml max instead*)
	samplingTipModels=MapThread[
		If[
			MatchQ[#1,GreaterP[0Milliliter]]&&MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:kEJ9mqaVP6nV"]}})[[1,1]],
			Null
		]&,
		{retentateSamplingVolume,dialysisMembranes}
	]/.{Model[Item, Tips, "id:aXRlGnZmOJdv"]->Model[Item, Tips, "id:kEJ9mqaVP6nV"]};

	secondarySamplingTipModels=MapThread[
		If[
			MatchQ[#1,GreaterP[0Milliliter]]&&MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:kEJ9mqaVP6nV"]}})[[1,1]],
			Null
		]&,
		{secondaryRetentateSamplingVolume,dialysisMembranes}
	]/.{Model[Item, Tips, "id:aXRlGnZmOJdv"]->Model[Item, Tips, "id:kEJ9mqaVP6nV"]};

	tertiarySamplingTipModels=MapThread[
		If[
			MatchQ[#1,GreaterP[0Milliliter]]&&MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:kEJ9mqaVP6nV"]}})[[1,1]],
			Null
		]&,
		{tertiaryRetentateSamplingVolume,dialysisMembranes}
	]/.{Model[Item, Tips, "id:aXRlGnZmOJdv"]->Model[Item, Tips, "id:kEJ9mqaVP6nV"]};

	quaternarySamplingTipModels=MapThread[
		If[
			MatchQ[#1,GreaterP[0Milliliter]]&&MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:kEJ9mqaVP6nV"]}})[[1,1]],
			Null
		]&,
		{quaternaryRetentateSamplingVolume,dialysisMembranes}
	]/.{Model[Item, Tips, "id:aXRlGnZmOJdv"]->Model[Item, Tips, "id:kEJ9mqaVP6nV"]};

	collectionTipModels=MapThread[
		If[
			MatchQ[#1,GreaterP[0Milliliter]]&&MatchQ[#2,ObjectP[Model[Item]]],
			(TransferDevices[Model[Item,Tips],#1]/.{}->{{Model[Item, Tips, "id:kEJ9mqaVP6nV"]}})[[1,1]],
			Null
		]&,
		{sampleVolume,dialysisMembranes}
	]/.{Model[Item, Tips, "id:aXRlGnZmOJdv"]->Model[Item, Tips, "id:kEJ9mqaVP6nV"]};

	(*Make a resource rules for the tips, batched togeather*)
	loadingTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[loadingTipModels,batchingLength],
		{2}
	];

	(*same for the other tips*)
	samplingTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[samplingTipModels,batchingLength],
		{2}
	];

	secondarySamplingTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[secondarySamplingTipModels,batchingLength],
		{2}
	];

	tertiarySamplingTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[tertiarySamplingTipModels,batchingLength],
		{2}
	];

	quaternarySamplingTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[quaternarySamplingTipModels,batchingLength],
		{2}
	];

	collectionTipRules=Table[
		If[MatchQ[#,{Null..}],Null,Merge[#,Total]],
		Length[#]
	]&/@Map[
		If[
			MatchQ[#1,Null],
			Null,
			#->1
		]&,
		TakeList[collectionTipModels,batchingLength],
		{2}
	];

	loadingTipResources= If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[loadingTipRules,1];

	(* Should be the same volumes and batching as the loading*)
	collectionTipResources=If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[collectionTipRules,1];

	samplingTipResources=If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[samplingTipRules,1];

	secondarySamplingTipResources=If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[secondarySamplingTipRules,1];

	tertiarySamplingTipResources= If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[tertiarySamplingTipRules,1];

	quaternarySamplingTipResources= If[MatchQ[#,Null],Null,Link[Resource[Sample -> First[Keys[#]], Amount -> Last[Values[#]],Name->ToString[Unique[]]]]]&/@Flatten[quaternarySamplingTipRules,1];

	(*get the models of pipettes that match the tips*)

	loadingPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@loadingTipModels;

	collectionPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@collectionTipModels;

	samplingPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@samplingTipModels;

	secondarySamplingPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@secondarySamplingTipModels;

	tertiarySamplingPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@tertiarySamplingTipModels;

	quaternarySamplingPipettes=If[MatchQ[#,Null],Null,pipetForTips[#]]&/@quaternarySamplingTipModels;

	(*make resources for the pipettes*)
	loadingPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@loadingPipettes;

	samplingPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@samplingPipettes;

	secondarySamplingPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@secondarySamplingPipettes;

	tertiarySamplingPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@tertiarySamplingPipettes;

	quaternarySamplingPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@quaternarySamplingPipettes;

	collectionPipetteResources=If[MatchQ[#,Null],Null,Link[Resource[Instrument->#,Time->10 Minute,Name->ToString[Unique[]]]]]&/@collectionPipettes;

	(*make a field with the pipettes in batched order*)
	piptteBatching=MapThread[
		Association[
			LoadingPipette->#1,
			SamplingPipette->#2,
			SecondarySamplingPipette->#3,
			TertiarySamplingPipette->#4,
			QuaternarySamplingPipette->#5,
			CollectionPipette->#6,
			LoadingPipetteTip->#7,
			SamplingPipetteTip->#8,
			SecondarySamplingPipetteTip->#9,
			TertiarySamplingPipetteTip->#10,
			QuaternarySamplingPipetteTip->#11,
			CollectionPipetteTip->#12
		]&,
		{
			Flatten[TakeList[loadingPipetteResources,batchingLength]],
			Flatten[TakeList[samplingPipetteResources,batchingLength]],
			Flatten[TakeList[secondarySamplingPipetteResources,batchingLength]],
			Flatten[TakeList[tertiarySamplingPipetteResources,batchingLength]],
			Flatten[TakeList[quaternarySamplingPipetteResources,batchingLength]],
			Flatten[TakeList[collectionPipetteResources,batchingLength]],
			Flatten[TakeList[loadingTipResources,batchingLength]],
			Flatten[TakeList[samplingTipResources,batchingLength]],
			Flatten[TakeList[secondarySamplingTipResources,batchingLength]],
			Flatten[TakeList[tertiarySamplingTipResources,batchingLength]],
			Flatten[TakeList[quaternarySamplingTipResources,batchingLength]],
			Flatten[TakeList[collectionTipResources,batchingLength]]
		}
	];

	(* --- Dialysate Resources --- *)
	(* If equilibrium dialysis, the dialsate should be put in a container and added in small volumes to the plate wells*)
	(* If it is dynamic dialysis it will be put into a the instruments resevior *)
	(* If it is static dialysis it will be put into a becker that may be shared with another sample*)
	(* Build sets of {solution, volumeRequired, ID} for each sample pool delete any duplicate dialysate calls*)

	dialysateObjVolPairs = DeleteDuplicatesBy[DeleteCases[#,{Null,_,_}],Last]&@Join[
		Transpose[{dialysisMembraneSoakSolution,dialysisMembraneSoakVolume,Flatten[groupdsoakSolutionIDs]}],
		Transpose[{dialysate,dialysateVolume,Flatten[groupdialysateIDs]}],
		Transpose[{secondaryDialysate,secondaryDialysateVolume,Flatten[groupdialysate2IDs]}],
		Transpose[{tertiaryDialysate,tertiaryDialysateVolume,Flatten[groupdialysate3IDs]}],
		Transpose[{quaternaryDialysate,quaternaryDialysateVolume,Flatten[groupdialysate4IDs]}],
		Transpose[{quinaryDialysate,quinaryDialysateVolume,Flatten[groupdialysate5IDs]}]
	];

	(* Group the {solution, volumeRequired} pairs by the solution *)
	groupedDialysateVolPairs = GatherBy[dialysateObjVolPairs,First];

	(* sub group them to keep the total volume under 20L for macro or 2ml if we are doing equillibrium dialysis plates*)
	maxContainerVolume=If[
		MatchQ[dialysisMethod,Equilibrium],
		(2Milliliter-10Microliter),
		20*Liter
	];

	subgroupedDialysateVolPairs=Flatten[MapThread[
		Function[{groupedDialysateVolPair},
			Module[{folded,splitbools,splits},
				(* example: {9L,9L,9L,9L,9L}->{9L,18L,9L,18L,9L} *)
				folded=FoldList[If[#1+#2<=maxContainerVolume, #1+#2, #2] &, groupedDialysateVolPair[[All,2]]];
				(* ->{True,False,True,False,True} *)
				splitbools=MapThread[MatchQ[#1, #2] &, {groupedDialysateVolPair[[All,2]], folded}];
				(* ->{2,2} *)
				splits=Differences[Flatten[Position[splitbools, True]]];
				(* ->{{{water,9L},{water,9L}},{{water,9L},{water,9L}},{{water,9L}}} *)
				FoldPairList[TakeDrop, groupedDialysateVolPair, Join[splits,{Length[folded]-Total[splits]}]]
			]
		],
		{
			groupedDialysateVolPairs
		}
	],1];


	(* Pull out the sample and total volume for each pair *)
	uniqueDialysateVolRequiredPairs = {First[First[#]],Total[#[[All,2]]],#[[All,3]]} &/@subgroupedDialysateVolPairs;

	(* Generate resources for the solutions required, and combine resources of the same model up to maxContainerVolume*)
	dialysateResourceMap = Map[
		Function[
			{dialysateVolPair},
			Last[dialysateVolPair] -> Link[
				Resource[
					Sample -> First[dialysateVolPair],
					RentContainer -> True,
					Amount -> Min[(SafeRound[1.15 * dialysateVolPair[[2]],1Microliter]),maxContainerVolume],
					Container->If[
						MatchQ[dialysisMethod,EquilibriumDialysis],
						First[Intersection[PreferredContainer[Min[(SafeRound[1.15 * dialysateVolPair[[2]],1Microliter]),maxContainerVolume], All->True],compatibleContainers]],
						PreferredContainer[Min[(SafeRound[1.15 * dialysateVolPair[[2]],1Microliter]),maxContainerVolume], All->True]
					],
					Name -> ToString[Unique[]]
				]
			]
		],
		uniqueDialysateVolRequiredPairs
	];

	(* expand so each ID has a resource*)
	expandedDialysateResourceMap=Map[First[#] -> Table[Last[#], Length[First[#]]] &, dialysateResourceMap];

	(*flatten it into a single association*)
	flatDialysateResourceMap=Merge[AssociationThread[#] & /@ expandedDialysateResourceMap, Total];

	(* remove any IDs associated with Null resources *)
	dialysateIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matcheddialysateIDs;
	secondaryDialysateIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matcheddialysate2IDs;
	tertiaryDialysateIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matcheddialysate3IDs;
	quaternaryDialysateIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matcheddialysate4IDs;
	quinaryDialysateIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matcheddialysate5IDs;
	dialysisMembraneSoakSolutionIDsNoNull=If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&/@matchedgroupdsoakSolutionIDs;


	(* Build field values for the unbatched solutions, replacing each value with the required resource*)
	dialysateResources = dialysateIDsNoNull/.flatDialysateResourceMap;
	secondaryDialysateResources = secondaryDialysateIDsNoNull/.flatDialysateResourceMap;
	tertiaryDialysateResources = tertiaryDialysateIDsNoNull/.flatDialysateResourceMap;
	quaternaryDialysateResources = quaternaryDialysateIDsNoNull/.flatDialysateResourceMap;
	quinaryDialysateResources = quinaryDialysateIDsNoNull/.flatDialysateResourceMap;
	dialysisMembraneSoakSolutionResources = dialysisMembraneSoakSolutionIDsNoNull/.flatDialysateResourceMap;

	(* remove any IDs associated with Null resources *)
	batchdialysateIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdialysateIDs,{2}];
	batchsecondaryDialysateIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdialysate2IDs,{2}];
	batchtertiaryDialysateIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdialysate3IDs,{2}];
	batchquaternaryDialysateIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdialysate4IDs,{2}];
	batchquinaryDialysateIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdialysate5IDs,{2}];
	batchdialysisMembraneSoakSolutionIDsNoNull=Map[If[MemberQ[Flatten[dialysateObjVolPairs],#],#,Null]&,groupdsoakSolutionIDs,{2}];

	(* Build field values for the batched solutions, replacing each value with the required resource*)
	batchdialysateResources = batchdialysateIDsNoNull/.flatDialysateResourceMap;
	batchsecondaryDialysateResources = batchsecondaryDialysateIDsNoNull/.flatDialysateResourceMap;
	batchtertiaryDialysateResources = batchtertiaryDialysateIDsNoNull/.flatDialysateResourceMap;
	batchquaternaryDialysateResources = batchquaternaryDialysateIDsNoNull/.flatDialysateResourceMap;
	batchquinaryDialysateResources = batchquinaryDialysateIDsNoNull/.flatDialysateResourceMap;
	batchdialysisMembraneSoakSolutionResources = batchdialysisMembraneSoakSolutionIDsNoNull/.flatDialysateResourceMap;

	(* --- Membrane Related Resources -- *)
	(* in order to know how much tubing to cut we need the length taken up by each clip*)
	bottomDialysisClipLengthOffsets=If[
		MatchQ[#,Null],
		Null,
		Lookup[
			First[DeleteDuplicates[Cases[inheritedCache,
				KeyValuePattern[{
					Object->ObjectP[#]
				}]
			]]],LengthOffset]]&/@bottomDialysisClips;

	topDialysisClipLengthOffsets=If[
		MatchQ[#,Null],
		Null,
		Lookup[
			First[DeleteDuplicates[Cases[inheritedCache,
				KeyValuePattern[{
					Object->ObjectP[#]
				}]
			]]],LengthOffset]]&/@topDialysisClips;

	(*the membrane shoud be the clip offsets + dialyzer offset(It hangs over the side)+sampling shrinkage (5cm/sampling might be lost if the top dries with dynamic) + sampleVolume/membraneVolumePerLengthoffset*120% *)
	numberOfSamples=MapThread[Length[Cases[{#1,#2,#3,#4},GreaterP[0Milliliter]]]&,
		{retentateSamplingVolume,secondaryRetentateSamplingVolume,tertiaryRetentateSamplingVolume,quaternaryRetentateSamplingVolume}];

	dialysisMembraneLengths=MapThread[If[
		MatchQ[#1,ObjectP[{Model[Item,DialysisMembrane],Object[Item,DialysisMembrane]}]],
		SafeRound[#2/#3*1.2+#4+#5+If[MatchQ[dialysisMethod,DynamicDialysis],(40 Millimeter+(#6*50Millimeter)),0 Millimeter],1Millimeter],
		Null
	]&,{dialysisMembranes,sampleVolume,membraneVolumePerLength, bottomDialysisClipLengthOffsets, topDialysisClipLengthOffsets,numberOfSamples}];

	(*FloatingRacks*)
	floatingRackResources=Sort[matchedFloats][[All,2]]/.floatResourceMap;

	(* resource for the rack for equilibrium dialysis inserts*)
	equilibriumDialysisPlateResources=If[
		MatchQ[dialysisMethod,EquilibriumDialysis],
		Link[Resource[Sample->#]]&/@groupInsertRacks,
		Null
	];

	(*look up the dialysis containers so we know what stir bars to choose*)
	dialysisContainers={
		Lookup[myResolvedOptions, DialysateContainer],
		Lookup[myResolvedOptions, SecondaryDialysateContainer],
		Lookup[myResolvedOptions, TertiaryDialysateContainer],
		Lookup[myResolvedOptions, QuaternaryDialysateContainer],
		Lookup[myResolvedOptions, QuinaryDialysateContainer]
	};

	(*look up their apertures*)
	dialysisContainerAperatures=If[
		MatchQ[#,Null],
		Null,
		Lookup[
		First[DeleteDuplicates[Cases[inheritedCache,
			KeyValuePattern[{
				Object->ObjectP[#]
			}]
		]]],Aperture]]&/@dialysisContainers;


	(* pick the Stir Bar *)
	stirBars=If[MatchQ[Lookup[myResolvedOptions, DialysisMixType],Stir],
		If[
			MatchQ[dialysisContainers,NullP],
			Null,
			Lookup[First[
				Sort[
					DeleteDuplicates[Cases[inheritedCache,
						KeyValuePattern[{
							Type->Model[Part,StirBar],
							StirBarLength->LessP[Min[DeleteCases[dialysisContainerAperatures,Null]]]
						}]
					]],
					Lookup[#1, StirBarLength] > Lookup[#2, StirBarLength]&]
			],Object]
		],
		Null
	];

	(*map a resource for it*)
	stirBarResourcesMap=If[MatchQ[#,Null],(Null->Null),(#->Link[Resource[Sample->#,Rent->True]])]&/@DeleteDuplicates[ToList[stirBars]];

	stirBarResources=stirBars/.stirBarResourcesMap;

	(* --- Container Resources --- *)
	numBatches=Length[batchingLength];

	dialysisContainerResource=If[MatchQ[Lookup[myResolvedOptions, DialysateContainer],Null],
		Table[Null,numBatches],
		Table[Link[Resource[Sample->Lookup[myResolvedOptions, DialysateContainer], Rent->True, Name -> ToString[Unique[]]]],numBatches]
	];

	secondaryDialysisContainerResource=Which[
		MatchQ[Lookup[myResolvedOptions, SecondaryDialysateContainer],Null],
		Table[Null,numBatches],
		(*if is a model plate use the dialysate container*)
		MatchQ[Lookup[myResolvedOptions, SecondaryDialysateContainer],ObjectP[Model[Container,Plate]]],
		dialysisContainerResource,
		(*If not use a new container*)
		True,
		Table[Link[Resource[Sample->Lookup[myResolvedOptions, SecondaryDialysateContainer], Rent->True, Name -> ToString[Unique[]]]],numBatches]
	];

	tertiaryDialysisContainerResource=Which[
		MatchQ[Lookup[myResolvedOptions, TertiaryDialysateContainer],Null],
		Table[Null,numBatches],
		(*if is a model plate use the dialysate container*)
		MatchQ[Lookup[myResolvedOptions, TertiaryDialysateContainer],ObjectP[Model[Container,Plate]]],
		dialysisContainerResource,
		(*If not use a new container*)
		True,
		Table[Link[Resource[Sample->Lookup[myResolvedOptions, TertiaryDialysateContainer], Rent->True, Name -> ToString[Unique[]]]],numBatches]
	];

	quaternaryDialysisContainerResource=Which[
		MatchQ[Lookup[myResolvedOptions, QuaternaryDialysateContainer],Null],
		Table[Null,numBatches],
		(*if is a model plate use the dialysate container*)
		MatchQ[Lookup[myResolvedOptions, QuaternaryDialysateContainer],ObjectP[Model[Container,Plate]]],
		dialysisContainerResource,
		(*If not use a new container*)
		True,
		Table[Link[Resource[Sample->Lookup[myResolvedOptions, QuaternaryDialysateContainer], Rent->True, Name -> ToString[Unique[]]]],numBatches]
	];

	quinaryDialysisContainerResource=Which[
		MatchQ[Lookup[myResolvedOptions, QuinaryDialysateContainer],Null],
		Table[Null,numBatches],
		(*if is a model plate use the dialysate container*)
		MatchQ[Lookup[myResolvedOptions, QuinaryDialysateContainer],ObjectP[Model[Container,Plate]]],
		dialysisContainerResource,
		(*If not use a new container*)
		True,
		Table[Link[Resource[Sample->Lookup[myResolvedOptions, QuinaryDialysateContainer], Rent->True, Name -> ToString[Unique[]]]],numBatches]
	];

	(*batchingParameters, ones with one item per batch*)
	batchingSingleParameters=MapThread[
		Association[
			FloatingRack->#1,
			DialysateContainer->#2,
			SecondaryDialysateContainer -> #3,
			TertiaryDialysateContainer -> #4,
			QuaternaryDialysateContainer -> #5,
			QuinaryDialysateContainer -> #6,
			DialysisMembraneSoakTime -> #7
		]&,
		{
			groupFloats/.floatResourceMap,
			dialysisContainerResource,
			secondaryDialysisContainerResource,
			tertiaryDialysisContainerResource,
			quaternaryDialysisContainerResource,
			quinaryDialysisContainerResource,
			groupSoakTimes
		}
	];

	(*batchingParameters, ones with one item per sample*)
	batchingMultipleParameters=MapThread[
		Association[
			DialysisMembraneSoakSolution->#1,
			Dialysate->#2,
			SecondaryDialysate -> #3,
			TertiaryDialysate -> #4,
			QuaternaryDialysate -> #5,
			QuinaryDialysate -> #6,
			DialysisMembraneSoakContainers->#7,
			DialysisMembranes-> #8,
			SampleVolumes->#9,
			DialysisMembraneSoakVolumes->#10,
			BottomDialysisClip->First[#11],
			TopDialysisClip->Last[#11]
		]&,
		{
			Flatten[batchdialysisMembraneSoakSolutionResources],
			(*Dialysate*)
			Flatten[batchdialysateResources],
			Flatten[batchsecondaryDialysateResources],
			Flatten[batchtertiaryDialysateResources],
			Flatten[batchquaternaryDialysateResources],
			Flatten[batchquinaryDialysateResources],
			Flatten[#[[All,4]]&/@subGroupedBatches],
			Flatten[#[[All,49]]&/@subGroupedBatches],
			Flatten[#[[All,5]]&/@subGroupedBatches],
			Flatten[#[[All,7]]&/@subGroupedBatches],
			Flatten[#[[All,50]]&/@subGroupedBatches,1]
		}
	];

	(*batchingParameters, ones with one item per sample*)
	batchingMultipleVolumes=MapThread[
		Association[
			DialysateVolumes->#1,
			SecondaryDialysateVolumes->#2,
			TertiaryDialysateVolumes->#3,
			QuaternaryDialysateVolumes->#4,
			QuinaryDialysateVolumes->#5,
			DialysateSamplingVolumes->#6,
			SecondaryDialysateSamplingVolumes->#7,
			TertiaryDialysateSamplingVolumes->#8,
			QuaternaryDialysateSamplingVolumes->#9,
			QuinaryDialysateSamplingVolumes->#10,
			RetentateSamplingVolumes->#11,
			SecondaryRetentateSamplingVolumes->#12,
			TertiaryRetentateSamplingVolumes->#13,
			QuaternaryRetentateSamplingVolumes->#14
		]&,
		{
			(*DialysateVolumes*)
			Flatten[#[[All,14]]&/@subGroupedBatches],
			Flatten[#[[All,15]]&/@subGroupedBatches],
			Flatten[#[[All,16]]&/@subGroupedBatches],
			Flatten[#[[All,17]]&/@subGroupedBatches],
			Flatten[#[[All,18]]&/@subGroupedBatches],
			(*DialysateSamplingVolumes*)
			Flatten[#[[All,19]]&/@subGroupedBatches],
			Flatten[#[[All,20]]&/@subGroupedBatches],
			Flatten[#[[All,21]]&/@subGroupedBatches],
			Flatten[#[[All,22]]&/@subGroupedBatches],
			Flatten[#[[All,23]]&/@subGroupedBatches],
			(*RetentateSamplingVolmues*)
			Flatten[#[[All,34]]&/@subGroupedBatches],
			Flatten[#[[All,35]]&/@subGroupedBatches],
			Flatten[#[[All,36]]&/@subGroupedBatches],
			Flatten[#[[All,37]]&/@subGroupedBatches]
		}
	];

	(*batchingParameters, ones with one item per sample*)
	batchingMultipleContainers=MapThread[
		Association[
			DialysateContainersOut->#1,
			SecondaryDialysateContainersOut->#2,
			TertiaryDialysateContainersOut->#3,
			QuaternaryDialysateContainersOut->#4,
			QuinaryDialysateContainersOut->#5,
			RetentateSamplingContainersOut->#6,
			SecondaryRetentateSamplingContainersOut->#7,
			TertiaryRetentateSamplingContainersOut->#8,
			QuaternaryRetentateSamplingContainersOut->#9,
			RetentateContainersOut->#10
		]&,
		{
			(*DialysateContainersOut*)
			Flatten[#[[All,29]]&/@subGroupedBatches],
			Flatten[#[[All,30]]&/@subGroupedBatches],
			Flatten[#[[All,31]]&/@subGroupedBatches],
			Flatten[#[[All,32]]&/@subGroupedBatches],
			Flatten[#[[All,33]]&/@subGroupedBatches],
			(*RetentateSamplingContainersOut*)
			Flatten[#[[All,38]]&/@subGroupedBatches],
			Flatten[#[[All,39]]&/@subGroupedBatches],
			Flatten[#[[All,40]]&/@subGroupedBatches],
			Flatten[#[[All,41]]&/@subGroupedBatches],
			Flatten[#[[All,47]]&/@subGroupedBatches]
		}
	];

	(*batching storage parameters one condition per sample*)
	batchingStorageConditions=MapThread[
		Association[
			DialysateStorageCondition->#1,
			SecondaryDialysateStorageCondition->#2,
			TertiaryDialysateStorageCondition->#3,
			QuaternaryDialysateStorageCondition->#4,
			QuinaryDialysateStorageCondition->#5,
			RetentateSamplingStorageCondition->#6,
			SecondaryRetentateSamplingStorageCondition->#7,
			TertiaryRetentateSamplingStorageCondition->#8,
			QuaternaryRetentateSamplingStorageCondition->#9,
			RetentateStorageCondition->#10,
			SamplesInStorage->#11
		]&,
		{
			(*DialysateStorage*)
			Flatten[#[[All,24]]&/@subGroupedBatches],
			Flatten[#[[All,25]]&/@subGroupedBatches],
			Flatten[#[[All,26]]&/@subGroupedBatches],
			Flatten[#[[All,27]]&/@subGroupedBatches],
			Flatten[#[[All,28]]&/@subGroupedBatches],
			(*RetentateStorage*)
			Flatten[#[[All,42]]&/@subGroupedBatches],
			Flatten[#[[All,43]]&/@subGroupedBatches],
			Flatten[#[[All,44]]&/@subGroupedBatches],
			Flatten[#[[All,45]]&/@subGroupedBatches],
			Flatten[#[[All,46]]&/@subGroupedBatches],
			(*samplesin*)
			Flatten[#[[All,57]]&/@subGroupedBatches]
		}
	];

	workSurface=Link[RandomChoice[
		{
			Object[Container, Bench, "id:J8AY5jwzVVmK"](* "Cesar Chavez" *)
		}
	]];

	stirBarRetriever=If[
		MatchQ[stirBarResources,Null],
		Null,
		Link[Resource[Sample->Model[Part, StirBarRetriever, "id:eGakldJlXP1o"],Rent->True]]
	];

	instrument=Lookup[myResolvedOptions, Instrument];

	dialysisMixRate=Lookup[myResolvedOptions, DialysisMixRate];

	(*conversion fit with tachometer measurements of the stir bar*)
	dialysisMixRateSetting=If[MatchQ[dialysisMixRate,Except[Null]]&&MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
		Round[(QuantityMagnitude[dialysisMixRate]+76.3253)/290.415, 1],
		Null
	];

	secondaryDialysisMixRate=Lookup[myResolvedOptions, SecondaryDialysisMixRate];

	secondaryDialysisMixRateSetting=If[MatchQ[secondaryDialysisMixRate,Except[Null]]&&MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
		Round[(QuantityMagnitude[secondaryDialysisMixRate]+76.3253)/290.415, 1],
		Null
	];

	tertiaryDialysisMixRate=Lookup[myResolvedOptions, TertiaryDialysisMixRate];

	tertiaryDialysisMixRateSetting=If[MatchQ[tertiaryDialysisMixRate,Except[Null]]&&MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
		Round[(QuantityMagnitude[tertiaryDialysisMixRate]+76.3253)/290.415, 1],
		Null
	];

	quaternaryDialysisMixRate=Lookup[myResolvedOptions, QuaternaryDialysisMixRate];

	quaternaryDialysisMixRateSetting=If[MatchQ[quaternaryDialysisMixRate,Except[Null]]&&MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
		Round[(QuantityMagnitude[quaternaryDialysisMixRate]+76.3253)/290.415, 1],
		Null
	];

	quinaryDialysisMixRate=Lookup[myResolvedOptions, QuinaryDialysisMixRate];

	quinaryDialysisMixRateSetting=If[MatchQ[quinaryDialysisMixRate,Except[Null]]&&MatchQ[instrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
		Round[(QuantityMagnitude[quinaryDialysisMixRate]+76.3253)/290.415, 1],
		Null
	];

	cleaningSolutionResource=If[
		MatchQ[instrument, ObjectP[{Model[Instrument,Dialyzer], Object[Instrument,Dialyzer]}]],
		Link[
			Resource[
				Name->ToString[Unique[]],
				Sample->Model[Sample,"id:8qZ1VWNmdLBD"],(* "Milli-Q water" *)
				Amount->2.5 Liter,
				Container->PreferredContainer[2.5 Liter], (* "Amber Glass Bottle 4 L" *)
				RentContainer->True
			]
		],
		Null
	];

	(* assemble the protocol packet *)
	protocolPacket=Association[
		Type->Object[Protocol,Dialysis],
		Object->CreateID[Object[Protocol,Dialysis]],
		(*Basic*)
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden,
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ Flatten[containerObjs],
		Replace[PooledSamplesIn] -> pooledSamplesInWithReplicates,
		Replace[SamplesInStorage] -> samplesInStorageCondition,
		NumberOfReplicates -> numReplicates,
		ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
		MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
		MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
		Name -> Lookup[myResolvedOptions, Name],
		Operator -> Link[Lookup[myResolvedOptions, Operator]],
		SubprotocolDescription -> Lookup[myResolvedOptions, SubprotocolDescription],
		Replace[RunTimes] -> runTimes,

		(*Dialysis Specific*)
		(* Singles*)
		DialysisMethod->Lookup[myResolvedOptions, DialysisMethod],
		Instrument->If[MatchQ[instrument,Null],
			Null,
			Link[Resource[Instrument -> instrument, Time -> First[runTimes]]]
			],
		DialysateTemperature->Lookup[myResolvedOptions, DialysateTemperature]/.{Ambient->Null},
		SecondaryDialysateTemperature->Lookup[myResolvedOptions, SecondaryDialysateTemperature]/.{Ambient->Null},
		TertiaryDialysateTemperature->Lookup[myResolvedOptions, TertiaryDialysateTemperature]/.{Ambient->Null},
		QuaternaryDialysateTemperature->Lookup[myResolvedOptions, QuaternaryDialysateTemperature]/.{Ambient->Null},
		QuinaryDialysateTemperature->Lookup[myResolvedOptions, QuinaryDialysateTemperature]/.{Ambient->Null},
		DialysisTime->Lookup[myResolvedOptions, DialysisTime],
		SecondaryDialysisTime->Lookup[myResolvedOptions, SecondaryDialysisTime],
		TertiaryDialysisTime->Lookup[myResolvedOptions, TertiaryDialysisTime],
		QuaternaryDialysisTime->Lookup[myResolvedOptions, QuaternaryDialysisTime],
		QuinaryDialysisTime->Lookup[myResolvedOptions, QuinaryDialysisTime],
		Replace[DialysateContainer]->dialysisContainerResource,
		Replace[SecondaryDialysateContainer]->secondaryDialysisContainerResource,
		Replace[TertiaryDialysateContainer]->tertiaryDialysisContainerResource,
		Replace[QuaternaryDialysateContainer]->quaternaryDialysisContainerResource,
		Replace[QuinaryDialysateContainer]->quinaryDialysisContainerResource,
		DialysisMixRate->dialysisMixRate,
		DialysisMixRateSetting->dialysisMixRateSetting,
		SecondaryDialysisMixRate->secondaryDialysisMixRate,
		SecondaryDialysisMixRateSetting->secondaryDialysisMixRateSetting,
		TertiaryDialysisMixRate->tertiaryDialysisMixRate,
		TertiaryDialysisMixRateSetting->tertiaryDialysisMixRateSetting,
		QuaternaryDialysisMixRate->quaternaryDialysisMixRate,
		QuaternaryDialysisMixRateSetting->quaternaryDialysisMixRateSetting,
		QuinaryDialysisMixRate->quinaryDialysisMixRate,
		QuinaryDialysisMixRateSetting->quinaryDialysisMixRateSetting,
		FlowRate->Lookup[myResolvedOptions, FlowRate],
		DynamicDialysisMethod->Lookup[myResolvedOptions, DynamicDialysisMethod],
		ImageSystem->Lookup[myResolvedOptions, ImageSystem],
		(*)ImagingInterval->Lookup[myResolvedOptions, ImagingInterval],*)
		WasteContainer->wasteContainerResource,
		WorkSurface->Link[workSurface],
		StirBarRetriever->stirBarRetriever,
		StirBar->stirBarResources,
		CleaningSolution->cleaningSolutionResource,

		(*Multiples*)

		(*Sample Index matched*)
		Replace[SampleVolumes]->sampleVolume,
		Replace[DialysisMembranes]->dialysisMembraneResources,
		Replace[DialysisMembraneSources]->dialysisMembraneSourceResources,
		Replace[DialysisMembraneLengths]->dialysisMembraneLengths,
		Replace[LoadingPipettes]->loadingPipetteResources,
		Replace[SamplingPipettes]->samplingPipetteResources,
		Replace[SecondarySamplingPipettes]->secondarySamplingPipetteResources,
		Replace[TertiarySamplingPipettes]->tertiarySamplingPipetteResources,
		Replace[QuaternarySamplingPipettes]->quaternarySamplingPipetteResources,
		Replace[CollectionPipettes]->collectionPipetteResources,
		Replace[LoadingPipetteTips]->loadingTipResources,
		Replace[SamplingPipetteTips]->samplingTipResources,
		Replace[SecondarySamplingPipetteTips]->secondarySamplingTipResources,
		Replace[TertiarySamplingPipetteTips]->tertiarySamplingTipResources,
		Replace[QuaternarySamplingPipetteTips]->quaternarySamplingTipResources,
		Replace[CollectionPipetteTips]->collectionTipResources,
		Replace[DialysisClips]->dialysisClipResources,
		Replace[FloatingRacks]->floatingRackResources,
		Replace[EquilibriumDialysisRacks]->equilibriumDialysisPlateResources,
		Replace[DialysisMembraneSoakSolutions]->dialysisMembraneSoakSolutionResources,
		Replace[DialysisMembraneSoakVolumes]->dialysisMembraneSoakVolume,
		Replace[DialysisMembraneSoakTimes]->dialysisMembraneSoakTime,
		Replace[DialysisMembraneSoakContainers]->dialysisMembraneSoakContainersResources,
		Replace[Dialysates]->dialysateResources,
		Replace[SecondaryDialysates]->secondaryDialysateResources,
		Replace[TertiaryDialysates]->tertiaryDialysateResources,
		Replace[QuaternaryDialysates]->quaternaryDialysateResources,
		Replace[QuinaryDialysates]->quinaryDialysateResources,
		Replace[DialysateVolumes]->dialysateVolume,
		Replace[SecondaryDialysateVolumes]->secondaryDialysateVolume,
		Replace[TertiaryDialysateVolumes]->tertiaryDialysateVolume,
		Replace[QuaternaryDialysateVolumes]->quaternaryDialysateVolume,
		Replace[QuinaryDialysateVolumes]->quinaryDialysateVolume,
		Replace[DialysateSamplingVolumes]->dialysateSamplingVolume,
		Replace[SecondaryDialysateSamplingVolumes]->secondaryDialysateSamplingVolume,
		Replace[TertiaryDialysateSamplingVolumes]->tertiaryDialysateSamplingVolume,
		Replace[QuaternaryDialysateSamplingVolumes]->quaternaryDialysateSamplingVolume,
		Replace[QuinaryDialysateSamplingVolumes]->quinaryDialysateSamplingVolume,
		Replace[DialysateStorageConditions]->dialysateStorageCondition,
		Replace[SecondaryDialysateStorageConditions]->secondaryDialysateStorageCondition,
		Replace[TertiaryDialysateStorageConditions]->tertiaryDialysateStorageCondition,
		Replace[QuaternaryDialysateStorageConditions]->quaternaryDialysateStorageCondition,
		Replace[QuinaryDialysateStorageConditions]->quinaryDialysateStorageCondition,
		Replace[DialysateContainersOut]->dialysateContainersOutResources,
		Replace[SecondaryDialysateContainersOut]->secondaryDialysateContainersOutResources,
		Replace[TertiaryDialysateContainersOut]->tertiaryDialysateContainersOutResources,
		Replace[QuaternaryDialysateContainersOut]->quaternaryDialysateContainersOutResources,
		Replace[QuinaryDialysateContainersOut]->quinaryDialysateContainersOutResources,
		Replace[RetentateSamplingVolumes]->retentateSamplingVolume,
		Replace[SecondaryRetentateSamplingVolumes]->secondaryRetentateSamplingVolume,
		Replace[TertiaryRetentateSamplingVolumes]->tertiaryRetentateSamplingVolume,
		Replace[QuaternaryRetentateSamplingVolumes]->quaternaryRetentateSamplingVolume,
		Replace[RetentateSamplingContainersOut]->retentateSamplingContainersOutResources,
		Replace[SecondaryRetentateSamplingContainersOut]->secondaryRetentateSamplingContainersOutResources,
		Replace[TertiaryRetentateSamplingContainersOut]->tertiaryRetentateSamplingContainersOutResources,
		Replace[QuaternaryRetentateSamplingContainersOut]->quaternaryRetentateSamplingContainersOutResources,
		Replace[RetentateContainersOut]->retentateContainersOutResources,
		Replace[RetentateSamplingStorageConditions]->retentateSamplingStorageCondition,
		Replace[SecondaryRetentateSamplingStorageConditions]->secondaryRetentateSamplingStorageCondition,
		Replace[TertiaryRetentateSamplingStorageConditions]->tertiaryRetentateSamplingStorageCondition,
		Replace[QuaternaryRetentateSamplingStorageConditions]->quaternaryRetentateSamplingStorageCondition,
		Replace[RetentateStorageConditions]->retentateStorageCondition,

		(*Batching*)
		Replace[BatchingSingle]->batchingSingleParameters,
		Replace[BatchingMultiple]->batchingMultipleParameters,
		Replace[BatchingVolumes]->batchingMultipleVolumes,
		Replace[BatchingContainers]->batchingMultipleContainers,
		Replace[BatchingStorageConditions]->batchingStorageConditions,
		Replace[BatchLengths]->batchingLength,
		Replace[BatchingPipettes]->piptteBatching,
		Replace[BatchedSampleIndexes]->Flatten[groupedIDs],

		Replace[Checkpoints]->{
			{"Preparing Samples",0 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation,	filteration, and aliquoting, is performed.",
				Null},
			{"Picking Resources",5 Minute,"Samples required to execute this protocol are gathered from storage.",
				Link[Resource[Operator -> $BaselineOperator,Time -> 5 Minute]]},
			{"Dialyzing Samples",(10*Minute*Length[runTimesGroup]+Total[runTimesGroup]),"The samples are dialyzed to remove particulates smaller than the membrane's molecular weight cutoff.",
				Link[Resource[Operator -> $BaselineOperator,Time -> (10*Minute*Length[runTimesGroup]+Total[runTimesGroup])]]},
			{"Parsing Data",1 Minute,"The database is updated with new dialyzed samples.",
				Link[Resource[Operator -> $BaselineOperator,Time -> 1 Minute]]},
			{"Sample Post-Processing",1 Minute ,"Any measuring of volume, weight, or sample imaging post experiment is performed.",
				Link[Resource[Operator -> $BaselineOperator,Time -> 1 Minute]]},
			{"Returning Materials",3 Minute,"Samples are returned to storage.",
				Link[Resource[Operator -> $BaselineOperator,Time -> 3 Minute]]}
		}
	];

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFields[myPooledSamples, myResolvedOptions, Simulation->simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation],Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}
];

(* ::Subsection::Closed:: *)
(*ExperimentDialysisOptions*)


DefineOptions[ExperimentDialysisOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentDialysis}
];

(* --- Overloads --- *)
ExperimentDialysisOptions[mySample : ObjectP[{Object[Sample], Model[Sample]}], myOptions : OptionsPattern[ExperimentDialysisOptions]] := ExperimentDialysisOptions[{mySample}, myOptions];
ExperimentDialysisOptions[myContainer : ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentDialysisOptions]] := ExperimentDialysisOptions[{myContainer}, myOptions];
ExperimentDialysisOptions[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ExperimentDialysisOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDialysis *)
	options = ExperimentDialysis[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDialysis],
		options
	]

];

(* --- Overload for SemiPooledInputs --- *)
ExperimentDialysisOptions[myInputs : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Model[Sample]], ObjectP[Object[Container]]]]], myOptions : OptionsPattern[ExperimentDialysisOptions]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDialysis *)
	options = ExperimentDialysis[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDialysis],
		options
	]
];

(* --- Core Function for PooledSamples--- *)
ExperimentDialysisOptions[mySamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDialysisOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDialysis *)
	options = ExperimentDialysis[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDialysis],
		options
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentDialysisQ*)


DefineOptions[ValidExperimentDialysisQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentDialysis}
];


(* --- Overloads --- *)
ValidExperimentDialysisQ[mySample : ObjectP[{Object[Sample],Model[Sample]}], myOptions : OptionsPattern[ValidExperimentDialysisQ]] := ValidExperimentDialysisQ[{mySample}, myOptions];
ValidExperimentDialysisQ[myContainer : ObjectP[Object[Container]], myOptions : OptionsPattern[ValidExperimentDialysisQ]] := ValidExperimentDialysisQ[{myContainer}, myOptions];

ValidExperimentDialysisQ[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ValidExperimentDialysisQ]] := Module[
	{listedOptions, preparedOptions, dialysisTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDialysis *)
	dialysisTests = ExperimentDialysis[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[dialysisTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[myContainers, Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[myContainers, Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, dialysisTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDialysisQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDialysisQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDialysisQ"]

];

(* --- Overload for SemiPooledInputs --- *)
ValidExperimentDialysisQ[mySemiPooledInputs : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Model[Sample]], ObjectP[Object[Container]]]]], myOptions : OptionsPattern[ExperimentDialysisOptions]] := Module[
	{listedOptions, preparedOptions, dialysisTests, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDialysis *)
	dialysisTests = ExperimentDialysis[mySemiPooledInputs, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[Flatten[mySemiPooledInputs], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[mySemiPooledInputs], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{dialysisTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDialysisQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDialysisQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDialysisQ"]

];


(* --- Core Function --- *)
ValidExperimentDialysisQ[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ValidExperimentDialysisQ]] := Module[
	{listedOptions, preparedOptions, dialysisTests, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDialysis *)
	dialysisTests = ExperimentDialysis[myPooledSamples, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[Flatten[myPooledSamples], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[myPooledSamples], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{dialysisTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDialysisQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDialysisQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDialysisQ"]

];

(* ::Subsection::Closed:: *)
(*ExperimentDialysisPreview*)


DefineOptions[ExperimentDialysisPreview,
	SharedOptions :> {ExperimentDialysis}
];

(* --- Overloads --- *)
ExperimentDialysisPreview[mySample : ObjectP[{Object[Sample], Model[Sample]}], myOptions : OptionsPattern[ExperimentDialysisPreview]] := ExperimentDialysisPreview[{mySample}, myOptions];
ExperimentDialysisPreview[myContainer : ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentDialysisPreview]] := ExperimentDialysisPreview[{myContainer}, myOptions];
ExperimentDialysisPreview[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ExperimentDialysisPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDialysis *)
	ExperimentDialysis[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* SemiPooledInputs *)
ExperimentDialysisPreview[mySemiPooledInputs : ListableP[ListableP[Alternatives[ObjectP[Object[Sample]], ObjectP[Model[Sample]], ObjectP[Object[Container]]]]], myOptions : OptionsPattern[ExperimentDialysisPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDialysis *)
	ExperimentDialysis[mySemiPooledInputs, Append[noOutputOptions, Output -> Preview]]
];

(* --- Core Function --- *)
ExperimentDialysisPreview[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDialysisPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDialysis *)
	ExperimentDialysis[myPooledSamples, Append[noOutputOptions, Output -> Preview]]
];
