(* ::Package:: *)

(* ::Section:: *)
(* NephelometrySharedOptions *)


DefineOptionSet[NephelometrySharedOptions :> {

	(* Macro Primitive Options *)
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> SampleLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the samples for which nephelometry measurements are taken, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			UnitOperation -> True
		},
		{
			OptionName -> SampleContainerLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the containers of the samples for which nephelometry measurements are taken, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			UnitOperation -> True
		}
	],

	(* ------General------ *)
	{
		OptionName -> Instrument,
		Default -> Model[Instrument, Nephelometer, "NEPHELOstar Plus"],
		Description -> "The nephelometer used to measure scattered light from particles in solution in this experiment.",
		AllowNull -> False,
		Widget -> Widget[
			Type -> Object,
			Pattern :> ObjectP[{Model[Instrument, Nephelometer], Object[Instrument, Nephelometer]}]
		],
		Category->"General"
	},
	{
		OptionName->Method,
		Default->Automatic,
		Description->"The type of experiment nephelometric measurements are collected for. CellCount involves measuring the amount of scattered light from cells suspended in solution and using a Standard Curve that relates RNU (Relative Nephelometric Units) to Cells/mL in order to quantify the number of cells in solution. For Method -> Solubility, scattered light from suspended particles in solution will be measured, at a single time point or over a time period. Reagents can be injected into the samples to study their effects on solubility, and dilutions can be performed to determine the point of saturation.",
		ResolutionDescription->"Automatically set to CellCount if samples are cells and have a StandardCurve. Otherwise, Method is set to Solubility.",
		AllowNull->False,
		Widget-> Widget[Type->Enumeration, Pattern:>NephelometryMethodTypeP],
		Category->"General"
	},
	{
		OptionName->PreparedPlate,
		Default->False,
		Description->"Indicates if a prepared plate is provided for nephelometric measurement. The prepared plate contains the solutions that are ready for tubidity measurements in a plate reader. If 'PreparedPlate' is True, dilution options and Moat options must be Null.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"General"
	},
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> Analyte,
			Default -> Automatic,
			Description -> "If the Method->Solublity, the compound whose concentration should be determined during this experiment. If Method->CellCount, the strain of cells whose concentration will be determined during this experiment, based on a previously measured standard curve, ReferenceCellCountCurve in the Model[Cell] composing the sample.",
			ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample.",                                                                                   (* composition field of Object[Sample] contains cell line information *)
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[List @@ IdentityModelTypeP]
			],
			Category -> "General"
		}
	],
	{
		OptionName->RetainCover,
		Default->False,
		Description->"Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover. The cover must be clear, as the laser passes from the top of the plate through to the bottom of the plate.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"General"
	},


	(* ------Optics------ *)
	{
		OptionName->BeamAperture,
		Default->1.5Millimeter,
		Description->"The diameter of the opening allowing the source laser light to pass through to the sample. A larger BeamAperture allows more light to pass through to the sample, leading to a higher signal. A setting of 1.5 millimeters is recommended for all 384 and 96 well plates, and 2.5-3.5 millimeters for 48 or less well plates. For non-homogenous solutions, a higher BeamAperture is recommended, and for samples with a large meniscus effect, a smaller BeamAperture is recommended.",                (* make table showing settings *)
		AllowNull->False,
		Widget-> Widget[Type->Quantity,Pattern:>RangeP[1.5 Millimeter, 3.5 Millimeter],Units:>{1,{Millimeter,{Micrometer,Millimeter,Centimeter}}}
		],
		Category->"Optics"
	},
	{
		OptionName->BeamIntensity,
		Default->Automatic,
		Description->"The percentage of the total amount of the laser source light passed through to reach the sample. For Solubility experiments, 80% is recommended, and for experiments with highly concentrated or highly turbid samples, such as those involving cells, a BeamIntensity of 10% is recommended.",
		ResolutionDescription->"Automatically set to 80% if Method->Solubility, and 10% if Method->CellCount.",
		AllowNull->False,
		Widget-> Widget[Type -> Quantity, Pattern :> RangeP[0 Percent, 100 Percent], Units :> Percent],
		Category->"Optics"
	},



	(* ------Quantification------- *)
	IndexMatching[
		IndexMatchingInput -> "experiment samples",
		{
			OptionName -> QuantifyCellCount,
			Default -> Automatic,
			Description -> "Indicates if the number of cells in the sample is automatically converted from the measured RNU (Relative Nephelometric Unit) via a StandardCurve in the Model[Cell].",
			ResolutionDescription -> "Automatically set to True if Method->CellCount, and set to False if Method->Solubility.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Quantification"
		}
	],

	(* ------Dilution------- *)
	(* Sample Preparation *)
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName -> InputConcentration,
			Default -> Automatic,
			Description -> "The initial assumed concentrations of the experiment samples.",
			ResolutionDescription -> "Automatically determined from the concentration of the analyte in the original source sample.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
				Units -> Alternatives[
					{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
					CompoundUnit[
						{1, {Gram, {Gram, Microgram, Milligram}}},
						{-1, {Liter, {Liter, Microliter, Milliliter}}}
					]
				]
			],
			Category -> "Quantification"
		},
		{
			OptionName -> DilutionCurve,
			Default -> Automatic,
			Description -> "The collection of dilutions that will be performed on the samples before nephelometric measurements are taken. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that will be mixed with the Diluent Volume of the Diluent to create the desired concentration. For Fixed Dilution Factor Dilution Curves, the Sample Volume is the volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1M sample with a dilution factor of 0.7 will be diluted to a concentration 0.7M. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn.",
			ResolutionDescription->"This is automatically set Null if Diluent is set to Null or a Serial Dilution Curve is specified.",
			AllowNull -> True,
			Category -> "Sample Preparation",
			Widget->Alternatives[
				"Fixed Dilution Volume"->Adder[
					{
						"Sample Amount"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}]
					}
				],
				"Fixed Dilution Factor"->Adder[
					{
						"Sample Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Dilution Factors"->Widget[Type->Number,Pattern:>RangeP[0,1]]
					}
				]
			]
		},
		{
			OptionName -> SerialDilutionCurve,
			Default -> Automatic,
			Description -> "The collection of dilutions that will be performed on the samples before nephelometric measurements are taken. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: Because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. If dilutions and injections are specified, injection samples will be injected into every dilution in the curve corresponding to SamplesIn.",
			ResolutionDescription->"This is automatically set to Null if Diluent is set to Null or a non-serial Dilution Curve is specified. In all other cases it is automatically set to TransferVolume as one tenth of smallest of sample volume or container max volume, DiluentVolume as smallest of sample volume or container max volume, and Number of Dilutions as 3.",
			AllowNull -> True,
			Category -> "Sample Preparation",
			Widget->Alternatives[
				"Serial Dilution Volumes"->
					{
						"Transfer Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Number Of Dilutions"->Widget[Type -> Number,Pattern :> GreaterP[1,1]]
					},
				"Serial Dilution Factor"->
					{
						"Sample Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,300 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
						"Dilution Factors" ->
							Alternatives[
								"Constant" -> {
									"Constant Dilution Factor" ->
									Widget[Type -> Number, Pattern :> RangeP[0, 1]],
									"Number Of Dilutions" ->
										Widget[Type -> Number, Pattern :> GreaterP[1, 1]]
								},
								"Variable" ->
									Adder[Widget[Type -> Number, Pattern :> RangeP[0, 1]]]]
					}
			]
		},
		{
			OptionName -> Diluent,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]}
			],
			Description -> "The sample that is used to dilute the sample to make a DilutionCurve or SerialDilutionCurve.",
			ResolutionDescription->"If the measurement is to be performed with DilutionCurve Null, this is automatically set to Null. Otherwise, it is automatically set to the Solvent of the sample. If the Solvent field is not informed, Diluent is set to Model[Sample,\"Milli-Q water\"].",
			Category -> "Sample Preparation"
		}
	],


	(* ------Nephelometry Measurement------ *)
	{
		OptionName->Temperature,
		Default->Automatic,
		Description->"The temperature at which the plate reader chamber is held during the course of the reading.",
		ResolutionDescription->"Automatically set to Ambient if Method->Solubility or the average of the IncubationTemperatures of the Model[Cell] Analytes, or 37 Celsius if that field is not informed if Method->CellCount.",
		AllowNull->False,
		Widget->Alternatives[
			Widget[Type->Quantity,Pattern:>RangeP[$AmbientTemperature,65 Celsius],Units:>{1,{Celsius,{Celsius,Fahrenheit}}}],
			Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
		],
		Category->"Measurement"
	},
	{
		OptionName->EquilibrationTime,
		Default->Automatic,
		Description->"The length of time for which the assay plates equilibrate at the requested temperature in the plate reader before being read.",
		ResolutionDescription->"Automatically set to 0 second when Temperature is set to Ambient, or 5 minutes when Temperature is above Ambient.",
		AllowNull->False,
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0 Second, $MaxExperimentTime],
			Units:>{1,{Minute,{Second,Minute,Hour}}}
		],
		Category->"Measurement"
	},
	{
		OptionName->TargetCarbonDioxideLevel,
		Default->Automatic,
		Description->"The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
		ResolutionDescription->"Automatically set to 5% for mammalian cells, and Null otherwise.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0.1Percent,20 Percent],
			Units:>{Percent,{Percent}}
		],
		Category->"Measurement"
	},
	{
		OptionName->TargetOxygenLevel,
		Default->Null,
		Description->"The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0.1Percent,20 Percent],
			Units:>{Percent,{Percent}}
		],
		Category->"Measurement"
	},

	(* Mixing *)
	{
		OptionName->PlateReaderMix,
		Default->False,
		Description->"Indicates if samples should be mixed inside the plate reader chamber before the samples are read.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"Measurement"
	},
	{
		OptionName->PlateReaderMixTime,
		Default->Automatic,
		Description->"The amount of time samples should be mixed inside the plate reader chamber before the samples are read.",
		ResolutionDescription->"Automatically set to 30 second if PlateReaderMix is True or any other plate reader mix options are specified.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second,$MaxExperimentTime],Units:>{1,{Second,{Second,Minute,Hour}}}],
		Category->"Measurement"
	},
	{
		OptionName->PlateReaderMixRate,
		Default->Automatic,
		Description->"The rate at which the plate is agitated inside the plate reader chamber before the samples are read.",
		ResolutionDescription->"Automatically set to 700 RPM if PlateReaderMix is True or any other plate reader mix options are specified.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[100 RPM,700 RPM],Units:>RPM],
		Category->"Measurement"
	},
	{
		OptionName->PlateReaderMixMode,
		Default->Automatic,
		Description->"The pattern of motion which should be employed to shake the plate before the samples are read.",
		ResolutionDescription->"Automatically set to DoubleOrbital if PlateReaderMix is True or any other plate reader mix options are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>MechanicalShakingP],
		Category->"Measurement"
	},



	(* Moats *)
	{
		OptionName->MoatSize,
		Default->Automatic,
		Description->"Indicates the number of concentric perimeters of wells which should be filled with MoatBuffer in order to decrease evaporation from the assay samples during the run.",
		ResolutionDescription->"Automatically set to 1 if any other moat options are specified.",
		AllowNull->True,
		Widget->Widget[Type->Number,Pattern:>RangeP[1,7,1]],
		Category->"Measurement"
	},
	{
		OptionName->MoatVolume,
		Default->Automatic,
		Description->"Indicates the volume which should be added to each moat well.",
		ResolutionDescription->"Automatically set to the RecommendedFillVolume of the assay plate model, or if Null, then 75% of the maximum volume of the assay plate if any other moat options are specified.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter
		],
		Category->"Measurement"
	},
	{
		OptionName->MoatBuffer,
		Default->Automatic,
		Description->"Indicates the buffer which should be used to fill each moat well.",
		ResolutionDescription->"Automatically set to Model[Sample,\"Milli-Q water\"] if any other moat options are specified.",
		AllowNull->True,
		Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
		Category->"Measurement"
	},


	{
		OptionName->ReadDirection,
		Default->Row,
		Description->"Indicate the plate path the instrument will follow as it measures scattered light in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>ReadDirectionP],
		Category->"Measurement"
	},
	{
		OptionName->SettlingTime,
		Default->200 Millisecond,
		Description->"The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Second,1 Second],Units:>{1,{Second,{Millisecond,Second}}}],
		Category->"Measurement"
	},
	{
		OptionName->ReadStartTime,
		Default->0 Second,
		Description->"The time at which nephelometry measurement readings will begin, after the plate is in position and the SettlingTime has passed. If a pause is desired before readings begin, set this time to higher than the SettlingTime. For kinetic experiments, the ReadStartTime is the time at which the first cycle begins.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Second,1200 Second],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second,Minute}}}],
		Category->"Measurement"
	},
	{
		OptionName->IntegrationTime,
		Default->Automatic,
		Description->"The amount of time that scattered light is measured. Increasing the IntegrationTime leads to higher measurements.",
		ResolutionDescription->"Automatically set to 1 second if no SamplingPattern is specified, or if SamplingPattern->Matrix. If SamplingPattern->Ring or Spiral, IntegrationTime is set based on the SamplingDistance.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[20 Millisecond,10 Second],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second}}}],
		Category->"Measurement"
	},




	(* ------Injection------ *)
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName->PrimaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during measurement. The corresponding injection volumes can be set with PrimaryInjectionVolume. If DilutionCurve or SerialDilutionCurve is specified, PrimaryInjectionSample will be injected into all dilutions in the curve.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Injections"
		},
		{
			OptionName->PrimaryInjectionVolume,
			Default->Null,
			Description->"The amount of the primary sample injected in the first round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the second round of injections. Set the corresponding injection volumes with SecondaryInjectionVolume. If DilutionCurve or SerialDilutionCurve is specified, SecondaryInjectionSample will be injected into all dilutions in the curve.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionVolume,
			Default->Null,
			Description->"The amount of the secondary sample injected in the second round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Injections"
		}
	],
	{
		OptionName->PrimaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the first round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if primary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Injections"
	},
	{
		OptionName->SecondaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the second round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if secondary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Injections"
	},
	{
		OptionName->PrimaryInjectionSampleStorageCondition,
		Default->Null,
		Description->"The non-default conditions under which any injection samples used by this experiment are stored after the protocol is completed.",
		AllowNull->True,
		Category->"Injections",
		Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
	},
	{
		OptionName->SecondaryInjectionSampleStorageCondition,
		Default->Null,
		Description->"The non-default conditions under which any injection samples used by this experiment are stored after the protocol is completed.",
		AllowNull->True,
		Category->"Injections",
		Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
	},
	

	(* ------Data Processing------ *)
	{
		OptionName->BlankMeasurement,
		Default->True,
		Description->"Indicates if blank samples are prepared to account for the background signal when measuring scattered light from the assay samples.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"Data Processing"
	},
	IndexMatching[
		{
			OptionName->Blank,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
			Description->"The source used to generate a blank sample whose scattered light is subtracted as background from the scattered light readings of the input sample.",
			ResolutionDescription->"Automatically set to Null if BlankMeasurement is False. If BlankMeasurement->True, Blank is set to the Solvent field for each sample. If the Solvent field is not informed, Blank is set to Model[Sample,\"Milli-Q water\"].",
			Category->"Data Processing"
		},
		{
			OptionName->BlankVolume,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,4000*Microliter],Units:>{1,{Microliter,{Microliter,Milliliter}}}],
			Description->"The volume of the blank that should be transferred out and used for blank measurements. Set BlankVolume to Null to indicate blanks should be read inside their current containers.",
			ResolutionDescription->"If BlankMeasurement is True, automatically set to match the maximum of the volume of each sample or the recommended fill volume of the container. Otherwise set to Null.",
			Category->"Data Processing"
		},
		IndexMatchingInput->"experiment samples"
	],


	(* ------Sampling------- *)

	{
		OptionName -> SamplingDistance,
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Millimeter,6 Millimeter], Units :> {1,{Millimeter,{Micrometer,Millimeter}}}],
		Description -> "Indicates the outer limit of the SamplingPattern.",
		ResolutionDescription -> "Automatically set to 80% of the well diameter of the assay container if SamplingPattern is not Null.",
		Category -> "Sampling"
	},

	
	FuntopiaSharedOptions,
	SimulationOption,
	SamplesInStorageOptions,
	PreparationOption,
	WorkCellOption,
	BlankLabelOptions,
	{
		OptionName -> NumberOfReplicates,
		Default -> Automatic,
		Description -> "The number of times to repeat nephelometry reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
		AllowNull -> True,
		Widget -> Widget[
			Type -> Number,
			Pattern :> GreaterEqualP[2,1]
		],
		Category->"General"
	}
}];
