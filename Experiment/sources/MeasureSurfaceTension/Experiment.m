(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureSurfaceTension*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[ExperimentMeasureSurfaceTension,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Tensiometer, "Kibron Delta 8 Tensiometer"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument,Tensiometer],Object[Instrument,Tensiometer]}]
			],
			Description -> "The tensiometer that is used to measure the surface tension of the sample.",
			Category -> "General"
		},
		{
			OptionName->NumberOfReplicates,
			Default-> Null,
			Description-> "The number of times the given dilution series should be replicated to obtain additional surface tension measurements.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[2,1]
			],
			Category -> "General"
		},
		{
			OptionName->PreparedPlate,
			Default->False,
			Description-> "Indicates if the input plates have been prepared prior to the start of the experiment. If True, the samples in column 12 of the plate will be used as a Calibrant.",
			AllowNull->False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
			Category -> "General"
		},
		{
			OptionName->SampleLoadingVolume,
			Default->50*Microliter,
			Description->"The volume of the sample and diluent mixture that is loaded into each well.",
			AllowNull->False,
			Category->"Protocol",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40*Microliter,60*Microliter],
				Units->Micro Liter
			]
		},
		(* Sample Preparation *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
				{
					OptionName -> DilutionCurve,
					Default -> Automatic,
					Description -> "The collection of dilutions that will be performed on sample before measuring surface tension. SampleLoadingVolume of each dilution will be transferred to the measurement plate. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that will be mixed the Diluent Volume of the Diluent to create a desired concentration.  For Fixed Dilution Factor Dilution Curves, the Sample Volume is the volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1M sample with a dilution factor of 0.7 will be diluted to a concentration 0.7M.",
					ResolutionDescription->"This is automatically set Null if Diluent is set to Null or a Serial Dilution Curve is specified.",
					AllowNull -> True,
					Category -> "Sample Preparation",
					Widget->Alternatives[
						"Fixed Dilution Volume"->Adder[
							{
							"Sample Amount"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}]
							}
						],
						"Fixed Dilution Factor"->Adder[
							{
							"Sample Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[40 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Dilution Factors"->Widget[Type->Number,Pattern:>RangeP[0,1]]
							}
						]
					]
				},
				{
					OptionName -> SerialDilutionCurve,
					Default -> Automatic,
					Description -> "The collection of dilutions that will be performed on sample before measuring surface tension. SampleLoadingVolume of each dilution will be transferred to the measurement plate. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100mM sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 100mM, 25mM, 6.25mM, 1.5625mM and 0mM with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step.",
					ResolutionDescription->"This is automatically set Null if Diluent is set to Null or a non-serial Dilution Curve is specified. In all other cases it is automatically set to a Sample Volume of 100 Microliters and a Constant Dilution Factor of 0.7. The Number Of Dilutions is automatically set to 21 if the Diluent is the same as the Calibrant and 20 if they are different.",
					AllowNull -> True,
					Category -> "Sample Preparation",
					Widget->Alternatives[
						"Serial Dilution Volumes"->
							{
								"Transfer Volume"->Widget[Type->Quantity,Pattern:>GreaterP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
								"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[40 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
								"Number Of Dilutions"->Widget[Type -> Number,Pattern :> GreaterP[1,1]]
							},
						"Serial Dilution Factor"->
								{
									"Sample Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[40 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
									"Dilution Factors" ->
											Alternatives[
												"Constant" -> {"Constant Dilution Factor" ->
														Widget[Type -> Number, Pattern :> RangeP[0, 1]],
													"Number Of Dilutions" ->
															Widget[Type -> Number, Pattern :> GreaterP[1, 1]]},
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
					Description -> "The sample that is used to dilute the sample to make a DilutionCurve.",
					ResolutionDescription->"If the measurement is to be performed with a DilutionCurve that has No Dilution, this is automatically set to Null. Otherwise, it is automatically set to Model[Sample, \"Milli-Q water\"].",
					Category -> "Sample Preparation"
				},
				{
					OptionName -> DilutionContainer,
					Default -> Automatic,
					AllowNull -> True,
					Widget->Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							ObjectTypes -> {Model[Container]}
						],
						{
							"Index" -> Alternatives[
								Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							],
							"Container" -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container]}],
									ObjectTypes -> {Model[Container]}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							]
						}
					],
					Description ->"The containers in which each sample is diluted with the Diluent to make the concentration series, with indices indicating specific grouping of samples if desired.",
					ResolutionDescription -> "Automatically set as Model[Container,Plate,\"96-well 2mL Deep Well Plate\"], grouping samples with the same container and DilutionStorageCondition.",
					Category -> "Sample Preparation"
				},
				{
					OptionName -> DilutionStorageCondition,
					Default ->Automatic,
					Description -> "The conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
					ResolutionDescription->"Automatically set Disposal if the sample is diluted and Null otherwise.",
					AllowNull -> True,
					Category -> "Sample Preparation",
					Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				},
				{
					OptionName -> DilutionMixVolume,
					Default ->Automatic,
					AllowNull -> True,
					Widget -> Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Microliter, 900 Microliter],
						Units->{1,{Liter,{Liter,Milliliter,Microliter}}}
						],
					Description -> "The volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
					ResolutionDescription->"Automatically set to the TransferVolume for serial dilutions, and 40 Microliters for fixed dilutions.",
					Category -> "Sample Preparation"
				},
				{
					OptionName -> DilutionNumberOfMixes,
					Default ->Automatic,
					AllowNull -> True,
					Widget -> Widget[
						Type -> Number,
						Pattern :> RangeP[0,20,1]
						],
					Description -> "The number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
					ResolutionDescription->"Automatically set 5 if the sample is diluted and Null otherwise.",
					Category -> "Sample Preparation"
				},
				{
					OptionName -> DilutionMixRate,
					Default ->Automatic,
					AllowNull -> True,
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.4 Microliter/Second,250 Microliter/Second],
						Units->CompoundUnit[{1, {Microliter, {Microliter}}}, {-1, {Second, {Second}}}]
						],
					Description -> "The speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
					ResolutionDescription->"Automatically set to 100 Microliter/Second if the sample is diluted and Null otherwise.",
					Category -> "Sample Preparation"
				}
		],
		{
			OptionName -> CleaningSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample], Object[Container, Vessel]}],
					ObjectTypes -> {Model[Sample], Object[Sample], Object[Container, Vessel]},
					Dereference -> {
						Object[Container, Vessel] -> Field[Contents[[All, 2]]]
					}
				],
			Description -> "The first solution used to clean the tensiometer probes. The probes are dipped into three solutions during the cleaning process.",
			ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"70% ethanol cleaning solution for	tensiometer\"] if the PreCleaningMethod or CleaningMethod involves Solution and Null otherwise.",
			Category -> "Cleaning"
		},
		{
			OptionName -> SecondaryCleaningSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Object[Container, Vessel]}],
				ObjectTypes -> {Model[Sample], Object[Sample], Object[Container, Vessel]},
				Dereference -> {
					Object[Container, Vessel] -> Field[Contents[[All, 2]]]
				}
			],
			Description -> "The second solution used to clean the tensiometer probes. The probes are dipped into three solutions during the cleaning process.",
			ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if the PreCleaningMethod or CleaningMethod involves Solution and Null otherwise.",
			Category -> "Cleaning"
		},
		{
			OptionName -> TertiaryCleaningSolution,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample], Object[Container, Vessel]}],
				ObjectTypes -> {Model[Sample], Object[Sample], Object[Container, Vessel]},
				Dereference -> {
					Object[Container, Vessel] -> Field[Contents[[All, 2]]]
				}
			],
			Description -> "The third solution used to clean the tensiometer probes. The probes are dipped into three solutions during the cleaning process.",
			Category -> "Cleaning"
		},
		{
			OptionName -> ImageDilutionContainers,
			Default -> False,
			Description -> "Indicates if the dilution container should be imaged.",
			AllowNull -> False,
			Category -> "Sample Preparation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SamplesOutStorageCondition,
				Default -> Disposal,
				Description -> "The conditions under which the samples in the assay plate should be stored after the protocol is completed. The samples in the plate will be transferred into ContainerOut.",
				AllowNull -> False,
				Category -> "Post Experiment",
				Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			}
		],
		{
			OptionName ->ContainerOut,
			Default -> Automatic,
			AllowNull -> True,
			Widget->Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]],
					ObjectTypes -> {Model[Container]}
				],
			Description -> "The container in which the samples in the assay plate are transferred into after the experiment.",
			ResolutionDescription -> "Automatically set to Null if the SamplesOutStorageCondition is set to Disposal and Model[Container,Plate,\"96-well 2mL Deep Well Plate\"] in all other cases.",
			Category -> "Post Experiment"
		},
		{
			OptionName -> SingleSamplePerProbe,
			Default -> Automatic,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
			Category -> "Sample Preparation",
			Description -> "Indicates if the samples should be arranged on the measurement plate so that there is only one input sample in each row. This will make sure only one sample will come into contact with each probe. The dilution curves of the samples will arranged so that they are measured with increasing concentration. If the dilution curves of the samples do not take up full rows, some of the wells will remain empty. If this is set to False, the samples will arranged in columns 1-11 of the plate without skipping any wells. Column 12 is taken up by the calibrant. The plate is read right to left, starting with column 12.",
			ResolutionDescription -> "Automatically set to False if there are no dilution curves, a CleaningMethod is specified and there are more than eight samples. It is set to True in all other cases."
		},
				(* Calibration *)
		{
			OptionName ->NumberOfCalibrationMeasurements,
			Default -> 3 ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1,20,1]
			],
			Description -> "The number of times surface tension of the calibration liquid is measured before taking the sample measurements. The average of these measurements is used in the calibration.",
			Category -> "Calibration"
		},
		{
			OptionName -> Calibrant,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
				ObjectTypes->{Model[Sample],Object[Sample]}
			],
			Description -> "The sample that is used to measure a calibration factor used to convert the readings from the balances to surface tension values. Each probe is calibrated before the surface tensions of a sample's dilution curve is measured. A sample with a known surface tension is needed for this calibration.",
			ResolutionDescription->"Automatically set to the Diluent if the Diluent has a populated SurfaceTension field or Model[Sample, \"Milli-Q water\"] in all other cases.",
			Category -> "Calibration"
		},
		{
			OptionName ->CalibrantSurfaceTension,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Milli Newton/Meter,100 Milli Newton/Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			],
			Description -> "The surface tension value of the calibrant that is used to perform the calibration.",
			ResolutionDescription-> "Automatically set to be the SurfaceTension value stored in the model of the selected Calibrant.",
			Category -> "Calibration"
		},
		{
			OptionName ->MaxCalibrationNoise,
			Default -> 0.05 Milli Newton/Meter ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			],
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the air before the probes are moved into the calibration sample.",
			Category -> "Calibration"
		},
		(* Measurement *)
		{
			OptionName -> EquilibrationTime,
			Default -> 5 Minute,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,120 Minute],
				Units -> Minute
			],
			Description -> "The minimum amount of time, after being plated but before readings begin, used for the sample to equilibrate.",
			Category -> "Measurement"
		},
		{
			OptionName ->NumberOfSampleMeasurements,
			Default -> 1 ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1,20,1]
			],
			Description -> "The number of times the surface tension of each dilution of the sample is measured. These measurements are taken consecutively before moving to the next column of the plate.",
			Category -> "Measurement"
		},
		{
			OptionName ->ProbeSpeed,
			Default -> 100. Percent,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[30 Percent,100 Percent],
				Units -> Percent
			],
			Description -> "The percentage of the default speed that is used to move the measurement table down, pulling the probe out of the liquid. Smaller settings improve accuracy of samples with higher viscosities. A probe speed of 100% is appropriate for samples with viscosities in the 0-40 cP range. A probe speed of 30% can measure samples with viscosities up to 100 cP.",
			Category -> "Measurement"
		},
		{
			OptionName ->MaxDryNoise,
			Default -> 0.2 Milli Newton/Meter ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			],
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the air before the probes are moved into the sample.",
			Category -> "Measurement"
		},
		{
			OptionName ->MaxWetNoise,
			Default -> 0.05 Milli Newton/Meter ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			],
			Description -> "The maximum noise (probe vibration) accepted while the probes are in the sample liquid before the probes are pulled out of the liquid to take the measurement.",
			Category -> "Measurement"
		},
		(* Cleaning *)
		{
			OptionName -> PreCleaningMethod,
			Default -> {Solution,Burn},
			AllowNull -> False,
			Widget -> Widget[
				Type -> MultiSelect,
				Pattern :> DuplicateFreeListableP[Burn|Solution]
			],
			Description -> "The method used to clean the tensiometer probes before measurements begin. If Burn is selected, the probes will be cleaned with an internal probe cleaner designed to heat off contaminants. This probe cleaning process involves the probes coming into contact with a hot surface for three short preheating pulses, followed by a long burning pulse and a cooling off time. If Solution is selected the probes will be dipped in and out of a cleaning solution. If both are selected, the probes will be cleaned with the solution then burned with the probe cleaner.",
			Category -> "Cleaning"
		},
		{
			OptionName -> CleaningMethod,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> MultiSelect,
				Pattern :> DuplicateFreeListableP[Burn|Solution]
			],
			Description -> "The method used to clean the tensiometer probes between all measurements within a single dilution curve. The probes are always cleaned before a new set of measurements and the samples in dilution series are measured starting with the most dilute samples. If Burn is selected, the probes will be cleaned with an internal probe cleaner designed to heat off contaminants. This probe cleaning process involves the probes coming into contact with a hot surface for three short preheating pulses, followed by a long burning pulse and a cooling off time. If Solution is selected the probes will be dipped in and out of a cleaning solution. If both are selected, the probes will be cleaned with the solution then burned with the probe cleaner.",
			Category -> "Cleaning"
		},
		{
			OptionName ->PreheatingTime,
			Default -> 0.8 Second ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 2 Second],
				Units -> Second
			],
			Description -> "The duration of one of three short heating pulses used by the instrument's internal probe cleaner to preheat the probes before the primary cleaning pulse.",
			Category -> "Cleaning"
		},
		{
			OptionName ->BurningTime,
			Default -> 10 Second ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 20 Second],
				Units -> Second
			],
			Description -> "The duration of the primary cleaning pulse used by the instrument's internal probe cleaner to burn contaminants off the probes before a new plate is measured.",
			Category -> "Cleaning"
		},
		{
			OptionName ->CoolingTime,
			Default -> 10 Second ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 20 Second],
				Units -> Second
			],
			Description -> "The duration of the cooling period after the instrument's internal probe cleaner issues a primary cleaning pulse and before a new plate is measured.",
			Category -> "Cleaning"
		},
		{
			OptionName ->BetweenMeasurementBurningTime,
			Default -> 5 Second ,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 10 Second],
				Units -> Second
			],
			Description -> "The duration of the primary cleaning pulse used by the instrument's internal probe cleaner to burn contaminants off the probes between all measurements within a single dilution curve (of the same sample).",
			Category -> "Cleaning"
		},
		{
			OptionName ->BetweenMeasurementCoolingTime,
			Default -> 5 Second ,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 10 Second],
				Units -> Second
			],
			Description -> "The duration of the cooling period between measurements after the instrument's internal probe cleaner issues a primary cleaning pulse and before a new measurement within a single dilution curve (of the same sample).",
			Category -> "Cleaning"
		},
		{
			OptionName ->MaxCleaningNoise,
			Default -> 0.05 Milli Newton/Meter ,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.05 Milli Newton/Meter,0.2 Milli Newton/Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			],
			Description -> "The maximum noise accepted before the probes are brought into contact with the instrument's internal probe cleaner.",
			Category -> "Cleaning"
		},
		FuntopiaSharedOptions,
		SamplesInStorageOptions
	}
];

Warning::DilutionCurveExcessVolume="There will be some leftover dilution volume from samples `3` after making the curve `1` because the instrument only takes `2` volume samples. If you want to keep the leftover dilution set the DilutionStorageCondition option.";
Warning::MissingDilutionCurve="A Diluent `1` is specified, but no DilutionCurve is given `2` for the samples `3`.";
Warning::ConflictingDilutionMixVolume="DilutionMixVolume `1` is specified but no there is no dilution in the DilutionCurve `2` for the samples `3`.";
Warning::MissingDilutionMixVolume="A DilutionCurve is specified `1`, but no DilutionMixVolume is given `2` for the samples `3`. The dilution curve will be prepared without mixing.";
Warning::MissingDilutionNumberOfMixes="A DilutionCurve is specified `1`, but no DilutionNumberOfMixes is given `2` for the samples `3`. The dilution curve will be prepared without mixing.";
Warning::MissingDilutionMixRate="A DilutionCurve is specified `1`, but no DilutionMixRate is given `2` for the samples `3`. The dilution curve will be prepared without mixing.";
Error::ConflictingDilutionMixSettings="At least one, but not all of DilutionMixVolume `1`, DilutionNumberOfMixes `2` or DilutionMixRate `3` is Null for samples `4`. Please provide all of these or set them all to Null.";
Warning::CalibrantSurfaceTensionMismatch="The SurfaceTension field of the calibrant `1` does not match the value of the specified CalibrantSurfaceTension `2`.";
Warning::MissingCleaningMethod="The CleaningMethod for the probes `1` is Null, while SingleSamplePerProbe is `2`. This may result in contamination of the samples as the probes will not be cleaned between measurements.";
Warning::PreparedPlateFalse="The samples `1` are already in a tensiometer assay plate `2` and PreparedPlate is set to `3`. If you would like to measure the plate without any extra sample manipulation, set PreparedPlate to True.";
Warning::ConflictingPreparedPlateCalibrants="A PreparedPlate is specified `1` and the samples in the calibrant wells `2` do not have the same composition.";
Warning::MultipleAssayPlates="Samples `1` with no dilution `2`, `3` are specified with a True SingleSamplePerProbe `4`. Since there are more than 8 samples and the samples are not sharing probes, this will take multiple assay plates. If you would like the samples to share probes and all be on the same plate, set SingleSamplePerProbe to False.";
Warning::SamplesOutStorageConditionMismatch="The SamplesOutStorageCondition is set to `1` but ContainerOut is specified `2`. If you would like to store your samples, please specify a SamplesOutStorageCondition.";
Error::ContainerOutMismatch="The SamplesOutStorageCondition `1` is specified as not Disposal but ContainerOut is `2`, the samples in the assay plates cannot be stored without transferring them.";
Error::DiscardedSamples="The samples `1` are discarded.";
Error::MustSpecifyDiluent="A DilutionCurve is specified `1` but no Diluent is given `2` for samples `3`.";
Error::MustSpecifyCleaningSolution="A CleaningMethod that uses a Solution is specified `1` but no CleaningSolution is given `2`.";
Warning::ConflictingCleaningSolution="A CleaningSolution is given `2` but no CleaningMethod that uses a Solution is specified.";
Error::CannotSpecifyBothDilutionCurveAndSerialDilutionCurve="A DilutionCurve `1` and SerialDilutionCurve `2` are specified for samples `3`. Only one type of dilution can be specified.";
Error::InsufficientDilutionCurveVolume="The total volume of the of dilutions `1`,`2` given in the dilution curve are not greater than `3` for samples `4`.";
Error::MissingCalibrantSurfaceTension="The Calibrant specified `1` does not have a SurfaceTension value in its object. Please provide the Calibrant's surface tension in the CalibrantSurfaceTension option";
Error::MissingDilutionContainer="A DilutionCurve is specified `1` but no DilutionContainer is given `2` for samples `3`.";
Error::DilutionContainerInsufficientVolume="The specified DilutionContainer `1` has a max volume of `2` when the dilution requires a volume of `3` for samples `4`. Please choose a container with a larger volume.";
Error::DilutionContainerConflictingStorage="The specified DilutionContainer index `1` has samples with conflicting DilutionStorageConditions `2`. Please choose a make sure they all have the same storage condition or dilute them in different containers.";
Error::MeasureSurfaceTesnsionContainerOutConflictingStorage="The specified SamplesOutStorageCondition `1` must be the same for each sample as they will share a ContainerOut. Please make sure samples all have the same storage condition.";
Error::ConflictingPreparedPlateDilution="The options `1`,`2` are required to be Null if the PreparedPlate option is selected.";
Error::InvalidAssayPlate="The PreparedPlate option is specified as `1`, but the samples are not in an appropriate container. Please make sure they are in a DynePlate 96-well plate.";
Error::NoCalibrantProvided="The PreparedPlate option is specified as `1`, but the plate is missing samples in the calibrant wells `2`. Please add a calibrant to all the wells in column 12.";
Error::ConflictingDilutionContainer= "The dilution containers `1` share the same index. Please change the DilutionContainer option so that different dilution containers have different indices.";
Error::IncompatableDilutionContainer= "The containers `1` are not compatible with our liquid handler. Please choose another dilution container.";

(* ::Subsubsection::Closed:: *)
(*Experiment*)


ExperimentMeasureSurfaceTension[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult, resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		 optionsWithObjects, allObjects, objectSamplePacketFields, modelSamplePacketFields, modelContainerObjects, instrumentObjects, modelSampleObjects, sampleObjects, modelInstrumentObjects, containerObjects,
		objectContainerFields,modelContainerFields,messages,listedSamples,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
	},



	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentMeasureSurfaceTension,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureSurfaceTension,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureSurfaceTension,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureSurfaceTension,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureSurfaceTension,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureSurfaceTension,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureSurfaceTension,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasureSurfaceTension,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects = {
		Diluent,
		Calibrant,
		DilutionContainer,
		Instrument
	};

	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				(* Default objects *)
				{
					(* potential calibrant *)
					Model[Sample,"Milli-Q water"]
				},
				(* All options that _could_ have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		],
		Object,
		Date->Now
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{SurfaceTension,Composition,IncompatibleMaterials,Well,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{SurfaceTension,IncompatibleMaterials,Products,Composition,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];

 	modelContainerObjects= Cases[allObjects,ObjectP[Model[Container]]];
	instrumentObjects = Cases[allObjects,ObjectP[Object[Instrument,Tensiometer]]];
	modelInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument,Tensiometer]]];
	modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
	sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];

	cacheBall=Quiet[FlattenCachePackets[{samplePreparationCache,Download[
		{sampleObjects,
			modelSampleObjects,
			instrumentObjects,
			modelInstrumentObjects,
			modelContainerObjects
		},
		{
			{
				objectSamplePacketFields,
				modelSamplePacketFields,
				Packet[Container[objectContainerFields]],
				Packet[Container[Model][modelContainerFields]]
			},
			{
			Packet[Object,Name,IncompatibleMaterials,SurfaceTension,Deprecated, Composition]
			},
			{
			Packet[Object,Name,Status,Model],
			Packet[Model[{Object,Name}]]
			},
			{
			Packet[Object,Name,WettedMaterials]
			},
			{
			Packet[Object,MinVolume,MaxVolume,AspectRatio,NumberOfWells,Name,Deprecated,Sterile,Footprint,OpenContainer,Dimensions,
				MaxTemperature,Positions,TransportWarmed,Sterile,
				LiquidHandlerIncompatible,Tablet,TabletWeight,State]
			}
		},
		Cache->samplePreparationCache,
		Date->Now
	]}],Download::FieldDoesntExist];


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)

		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureSurfaceTensionOptions[ToList[listedSamples],expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureSurfaceTensionOptions[ToList[listedSamples],expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureSurfaceTension,
		resolvedOptions,
		Ignore->ToList[listedOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureSurfaceTension,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)

	{resourcePackets,resourcePacketTests} = If[gatherTests,
		mstResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{mstResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureSurfaceTension,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,MeasureSurfaceTension],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMeasureSurfaceTension,collapsedResolvedOptions],
		Preview -> Null
	}
];

(* container overload *)
ExperimentMeasureSurfaceTension[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
		{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,sampleCache,
		samplePreparationCache,containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests, safeOptions, safeOptionTests,listedContainers},


		(* Determine the requested return value from the function *)
		outputSpecification=Quiet[OptionValue[Output]];
		output=ToList[outputSpecification];

		(* Determine if we should keep a running list of tests *)
		gatherTests=MemberQ[output,Tests];

		{listedContainers, listedOptions}=removeLinks[ToList[myContainers], ToList[myOptions]];

		(* First, simulate our sample preparation. *)
		validSamplePreparationResult=Check[
			(* Simulate sample preparation. *)
			{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
				ExperimentMeasureSurfaceTension,
				ToList[listedContainers],
				ToList[listedOptions]
			],
			$Failed,
			{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
		];

		(* If we are given an invalid define name, return early. *)
		If[MatchQ[validSamplePreparationResult,$Failed],
			(* Return early. *)
			(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
			ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
		];


		(* Convert our given containers into samples and sample index-matched options. *)
		containerToSampleResult=If[gatherTests,
			(* We are gathering tests. This silences any messages being thrown. *)
			{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
				ExperimentMeasureSurfaceTension,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Tests},
				Cache->samplePreparationCache
			];

			(* Therefore, we have to run the tests to see if we encountered a failure. *)
			If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
				Null,
				$Failed
			],

			(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
			Check[
				containerToSampleOutput=containerToSampleOptions[
					ExperimentMeasureSurfaceTension,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output->Result,
					Cache->samplePreparationCache
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		];

		(* Update our cache with our new simulated values. *)
		(* It is important the sample preparation cache appears first in the cache ball. *)
		updatedCache=Flatten[{
			samplePreparationCache,
			Lookup[listedOptions,Cache,{}]
		}];

		(* If we were given an empty container, return early. *)
		If[MatchQ[containerToSampleResult,$Failed],
			(* containerToSampleOptions failed - return $Failed *)
			outputSpecification/.{
				Result -> $Failed,
				Tests -> containerToSampleTests,
				Options -> $Failed,
				Preview -> Null
			},
			(* Split up our containerToSample result into the samples and sampleOptions. *)
			{samples,sampleOptions, sampleCache}=containerToSampleOutput;

			(* Call our main function with our samples and converted options. *)
			ExperimentMeasureSurfaceTension[samples,ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]]
		]
];



(* ::Subsubsection:: *)
(*Resolver*)


DefineOptions[
	resolveExperimentMeasureSurfaceTensionOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentMeasureSurfaceTensionOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureSurfaceTensionOptions]]:=Module[
		{outputSpecification,output,gatherTests,cache,samplePrepOptions,measureSurfaceTensionOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
	measureSurfaceTensionOptionsAssociation,invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests, samplePackets,sampleModelPackets, preparedPlateFalseOptions,
	discardedSamplePackets,discardedInvalidInputs,discardedTest,missingDiluent,missingDiluentOptions,missingDiluentInputs, missingDiluentInvalidOptions,missingDiluentTest,missingDilutionCurve,missingDilutionCurveOptions,missingDilutionCurveInputs,missingDilutionCurveTest,missingDilutionMixVolumeOptions,missingDilutionMixVolumeInputs,
	missingDilutionMixVolume,missingDilutionMixVolumeTest,conflictingDilutionMixVolumeOptions, conflictingDilutionMixVolumeInputs,conflictingDilutionMixVolume, conflictingDilutionMixVolumeTest,
	missingDilutionNumberofMixesOptions,missingDilutionNumberofMixesInputs,missingDilutionNumberofMixes,missingDilutionNumberofMixesTest, missingDilutionMixRateOptions,missingDilutionMixRateInputs,missingDilutionMixRate,missingDilutionMixRateTest,
	calibrantSurfaceTensionMismatch,calibrantSurfaceTensionMismatchTest,missingDilutionContainerOptions,missingDilutionContainerInputs,missingDilutionContainer, assayStorageCondition, dilutionStorageCondition,
	missingDilutionContainerTest,missingDilutionContainerInvalidOptions,roundedMeasureSurfaceTensionOptions,mapThreadFriendlyOptions,resolveddiluents,resolvedCalibrant,missingCalibrantSurfaceTensionError,
	resolvedcalibrantSurfaceTension,allDownloadValues,resolveddilutionCurve,dilutionCurveVolumeErrors,dilutionCurveExcessVolumeWarnings, resolveddilutionMixVolume,requiredSampleVolumes, missingCalibrantSurfaceTensionInvalidOptions,missingCalibrantSurfaceTensionTest,
	dilutionCurveVolumeInvalidOptions,dilutionCurveVolumeTest,dilutionCurveExcessVolumeTest,hamiltonCompatibleContainers,resolvedPostProcessingOptions, resolvedOptions,allTests,simulatedSampleContainers,
	resolvedcalibrantSTfield,precisionTests,calibrantinput,calibrantinputST,potentialCalibrant,potentialCalibrantST,allDiluents,simulatedContainersPackets,instrument, dilutionNumberOfMixes, dilutionMixRate,
	dilutionContainer, numberOfReplicates,  numberOfCalibrationMeasurements, maxCalibrationNoise, equilibrationTime, numberOfSampleMeasurements, probeSpeed, maxDryNoise, cleaningMethod,
	maxWetNoise, preCleaningMethod, cleaningSolution, preheatingTime, burningTime, coolingTime, betweenMeasurementBurningTime, betweenMeasurementCoolingTime, maxCleaningNoise,name,template, containersOutMismatch, containersOutMismatchTest,
			confirm, samplesInStorage, upload,email, fastTrack, operator, parentProtocol, outputOption,resolvedserialdilutionCurve, missingCleaningSolutionInvalidOptions, resolvedcontainersOut,
			conflictingDilutionCurveInvalidOptions,missingCleaningSolutionOptions,conflictingDilutionCurveOptions,conflictingDilutionCurveInputs,conflictingDilutionCurveTest,conflictingDilutionCurve,missingCleaningSolutionTest,dilutionsamplevolumes,
			compatibleMaterialsInvalidInputs,singleSamplePerProbe,dilutionContainerInvalidOptions,dilutionContainerTest,dilutionContainerErrors,maxvolumes, resolvedcleaningMethod, missingCleaningMethodTest, missingCleaningMethodOptions,
			uniqueCalibrantObjects, downloadedSurfaceTensions, calibrantSurfaceTensionReplaceRules, uniqueDilutionContainersObjects,  downloadedDilutionContainerFields, dilutionContainerReplaceRules, numberOfDilutionWells,
			 dilutionContainerGrouping,mergedContainerOptions,gatheredmergedContainerOptions,newgroupingindices,newgroupings,newGroupingRules,resolveddilutionContainerGrouping, containersOutTest,
			indexedStorageConditions, dilutionContainerStorageTest, dilutioncontainerStorageInValidOptions, dilutionContainerWellsInValidOptions, dilutionContainerWellsTest, calibrantCompositionReplaceRules, downloadedCompositions,
			mismatchedDilutionContainerStorage, groupedStorageConditions, halfresolveddilutionContainer, dilutionContainerObjects, conflictingCleaningSolutionInvalidOptions, conflictingCleaningSolutionTest, conflictingCleaningSolutionOptions,
			safeIndex, resolveddilutionContainer, requiredWells, availableWells, groupedContainerOptions, filledUpContainers, unresolvedDilutionContainerGrouping, insufficientDilutionContainerWells, unresolvedDilutionContainer,
			roundedOtherMeasureSurfaceTensionOptions, roundedDilutionCurveOptions, roundedDilutionCurveOption, separatedUnroundedDilutionCurve, unroundedDilutionCurve, halfroundedSerialDilutionCurveOption,
			roundedSerialDilutionCurveOptions, roundedSerialDilutionCurveOption, separatedUnroundedSerialDilutionCurve, unroundedSerialDilutionCurve, halfroundedSerialDilutionCurveOptions,
			otherprecisionTests, serialDilutionprecisionTests, dilutionprecisionTests, preparedPlate, conflictingPreparedPlateDilutionInvalidOptions, conflictingPreparedPlateDilution, simulatedSampleWells, invalidAssayPlateOptions,
			invalidAssayPlateTest, noCalibrantProvidedInvalidOptions, noCalibrantProvidedTest, conflictingPreparedPlateDilutionTest, sampleLoadingVolume, imageDilutionContainers, samplesOutMismatch, samplesOutMismatchTest,
			samplesInCalibrantWells, invalidPreparedPlateCleaningSolutionOptions, invalidPreparedPlateCleaningSolutionTest, preparedPlateCleaningSolutionOptions, assayPlateOptions, requiredRows,
			noCalibrantProvidedOptions, samplesInCalibrantWellsComposition, conflictingPreparedPlateCalibrantsOptions, preparatoryPrimitives, conflictingDilutionMixInvalidOptions, conflictingDilutionMixOptions, conflictingDilutionMixInputs,
			conflictingDilutionMix, conflictingDilutionMixTest, multipleAssayPatesTest, multipleAssayPatesOptions, primaryCleaningSolution, secondaryCleaningSolution, containerObjects, containersOutWells,
			tertiaryCleaningSolution, resolvedsingleSamplePerProbe, containersOutMismatchInvalidOptions,resolveddilutionMixRate,resolvednumberOfMixes,resolveddilutionStorageCondition, conflictingDilutionContainers,
      conflictingDilutionContainerInValidOptions, conflictingDilutionContainerTest, simulatedSampleContainerObjects,  preResolvedAliquotBool, liquidHandlingWarningContainers, liquidHandlingWarningContainersTest,
			incompatibleDilutionContainers, incompatibleDilutionContainersOptions, incompatibleDilutionContainersTest, compatibleMaterialsBool, compatibleMaterialsTests,messages,mismatchedContainerOutStorage,
			containerOutStorageInValidOptions,containerOutStorageTest,calibrantWells,targetVolumes
		},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Seperate out our MeasureSurfaceTension options from our Sample Prep options. *)
	{samplePrepOptions,measureSurfaceTensionOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentMeasureSurfaceTension,mySamples,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentMeasureSurfaceTension,mySamples,samplePrepOptions,Cache->cache,Output->Result],{}}
	];


	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	(* Convert probe speed from inputs like 0.5 to 50% *)
	measureSurfaceTensionOptionsAssociation = Join[Association[measureSurfaceTensionOptions],<|ProbeSpeed -> Convert[Lookup[measureSurfaceTensionOptions, ProbeSpeed], Percent]|>];

	(*get unique values from objects in fields to avoid fetchfrompacket*)
	uniqueCalibrantObjects=DeleteDuplicates[Join[Cases[ToList[Lookup[measureSurfaceTensionOptionsAssociation,Calibrant,{}]],ObjectP[]],Cases[Lookup[measureSurfaceTensionOptionsAssociation,Diluent,{}],ObjectP[]],{Model[Sample, "Milli-Q water"]},simulatedSamples]];
	uniqueDilutionContainersObjects=DeleteDuplicates[Join[Cases[If[ListQ[#],#[[2]],#]&/@Lookup[measureSurfaceTensionOptionsAssociation, DilutionContainer, {}], ObjectP[]],{Model[Container,Plate,"id:L8kPEjkmLbvW"]},
		Cases[Lookup[measureSurfaceTensionOptionsAssociation, ContainerOut, {}], ObjectP[]],{Model[Container,Plate,"id:L8kPEjkmLbvW"]}
	]];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	{
		allDownloadValues, downloadedSurfaceTensions,  downloadedDilutionContainerFields, downloadedCompositions
	} = Quiet[Download[
		{ (*Inputs*)
			simulatedSamples,
			uniqueCalibrantObjects,
			uniqueDilutionContainersObjects,
      uniqueCalibrantObjects
		},
		{
			{
			Packet[Model,Status,Container,Well],
			Packet[Model[{Deprecated, Name}]],
			Packet[Container[{Model}]]
			},
			{SurfaceTension},
			{MaxVolume, NumberOfWells},
      {Composition}
		},
		Cache -> simulatedCache,
		Date->Now
	], Download::FieldDoesntExist];


	(* split out the sample and model packets *)
	samplePackets = allDownloadValues[[All, 1]];
	sampleModelPackets = allDownloadValues[[All, 2]];
	simulatedContainersPackets=allDownloadValues[[All, 3]];
	simulatedSampleContainers=Lookup[simulatedContainersPackets,Model];
	simulatedSampleWells=Lookup[samplePackets,Well];
  	simulatedSampleContainerObjects=Lookup[samplePackets,Container];

	calibrantSurfaceTensionReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueCalibrantObjects,Flatten[downloadedSurfaceTensions]}
	];

  calibrantCompositionReplaceRules=MapThread[
    (#1->#2)&,
    {uniqueCalibrantObjects,downloadedCompositions}
  ];

	(*Some of the containers will by vessels with no NumberOfWellsFields*)
	dilutionContainerReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueDilutionContainersObjects, Replace[downloadedDilutionContainerFields, $Failed -> 1, {2}]}
	];


	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)
	(*-- INPUT VALIDATION CHECKS --*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(*get the unrounded dilution curve values*)
	unroundedDilutionCurve=Lookup[measureSurfaceTensionOptionsAssociation,DilutionCurve];

	(*make a list of associations*)
	separatedUnroundedDilutionCurve=Map[Association[DilutionCurve -> #] &, unroundedDilutionCurve];

	(*round each association*)
	{roundedDilutionCurveOption, dilutionprecisionTests} = Transpose[If[gatherTests,
		MapThread[RoundOptionPrecision[#1, DilutionCurve, If[MatchQ[#2, {{VolumeP, VolumeP} ..}], {10^-1 Microliter, 10^-1 Microliter}, { 10^-1 Microliter, 10^-2}], Output -> {Result, Tests}]
				&,{separatedUnroundedDilutionCurve,unroundedDilutionCurve}],
		MapThread[{RoundOptionPrecision[#1, DilutionCurve, If[MatchQ[#2, {{VolumeP, VolumeP} ..}], {10^-1 Microliter, 10^-1 Microliter}, { 10^-1 Microliter, 10^-2}]],{}}&,
			{separatedUnroundedDilutionCurve,unroundedDilutionCurve}]
	]];


	(*put them back togeather*)
	roundedDilutionCurveOptions = Which[
		MatchQ[Flatten[Values[#], 1],{Automatic}], Automatic,
		MatchQ[Flatten[Values[#], 1],{Null}], Null,
		True,Flatten[Values[#], 1]] & /@ roundedDilutionCurveOption;

	(*get the unrounded serial dilution curve values*)
	unroundedSerialDilutionCurve=If[MatchQ[Lookup[measureSurfaceTensionOptionsAssociation,SerialDilutionCurve],{VolumeP,VolumeP,_Integer}|Automatic|{VolumeP,{_Real,_Integer}}|{VolumeP,{_Real..}}],
		{Lookup[measureSurfaceTensionOptionsAssociation,SerialDilutionCurve]},
		Lookup[measureSurfaceTensionOptionsAssociation,SerialDilutionCurve]
		];

	(*round the volume portion of each curve*)
	roundedSerialDilutionCurveOptions=Which[MatchQ[#,Automatic|Null],#,
		MatchQ[#,{VolumeP, VolumeP, _Integer}],
		RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1 Microliter];
		Join[{SafeRound[First[#],10^-1Microliter]},{SafeRound[#[[2]],10^-1Microliter]},{Last[#]}],
		True,
		RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1 Microliter];
		Join[{SafeRound[First[#],10^-1Microliter]},Rest[#]]
		]&/@unroundedSerialDilutionCurve;

	(*gather the tests*)
	serialDilutionprecisionTests=Which[MatchQ[#,Automatic|Null],{},
		MatchQ[#,{VolumeP, VolumeP, _Integer}],
	If[gatherTests,
		Last[RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1 Microliter,Output->{Result,Tests}]],
		{}],
		True,
	If[gatherTests,
		Last[RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1 Microliter,Output->{Result,Tests}]],
		{}]
	]&/@unroundedSerialDilutionCurve;

	(*all the non dilution curve rounding*)
	{roundedOtherMeasureSurfaceTensionOptions, otherprecisionTests} = If[gatherTests,
		RoundOptionPrecision[measureSurfaceTensionOptionsAssociation, {CalibrantSurfaceTension, MaxCalibrationNoise, MaxDryNoise, MaxWetNoise, MaxCleaningNoise,EquilibrationTime, PreheatingTime, BurningTime, CoolingTime, BetweenMeasurementBurningTime, BetweenMeasurementCoolingTime,DilutionMixVolume,DilutionMixRate,ProbeSpeed, SampleLoadingVolume},
			{10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,1 Minute, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1Microliter,10^-1 Microliter/Second,1Percent, 10^-1Microliter}, Output -> {Result, Tests}],
		{RoundOptionPrecision[measureSurfaceTensionOptionsAssociation, {CalibrantSurfaceTension, MaxCalibrationNoise, MaxDryNoise, MaxWetNoise, MaxCleaningNoise,EquilibrationTime, PreheatingTime, BurningTime, CoolingTime, BetweenMeasurementBurningTime, BetweenMeasurementCoolingTime,DilutionMixVolume,DilutionMixRate,ProbeSpeed,  SampleLoadingVolume},
			{10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,10^-2Milli Newton/Meter,1 Minute, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1 Second, 10^-1Microliter,10^-1 Microliter/Second,1Percent, 10^-1Microliter}], {}}
	];

	(*all the rounding togeather*)
	roundedMeasureSurfaceTensionOptions=Join[roundedOtherMeasureSurfaceTensionOptions,<|DilutionCurve->roundedDilutionCurveOptions|>,<|SerialDilutionCurve->roundedSerialDilutionCurveOptions|>];


	(* Join all tests together *)
	precisionTests = Join[
		otherprecisionTests,
		serialDilutionprecisionTests,
		dilutionprecisionTests
	];

	(* pull out the options that are defaulted *)
	{
		instrument,
		numberOfReplicates,
		assayStorageCondition,
		numberOfCalibrationMeasurements,
		maxCalibrationNoise,
		equilibrationTime,
		numberOfSampleMeasurements,
		probeSpeed,
		maxDryNoise,
		maxWetNoise,
		preCleaningMethod,
		cleaningMethod,
		tertiaryCleaningSolution,
		preheatingTime,
		burningTime,
		coolingTime,
		betweenMeasurementBurningTime,
		betweenMeasurementCoolingTime,
		maxCleaningNoise,
		name,
		template,
		confirm,
		samplesInStorage,
		upload,
		email,
		fastTrack,
		operator,
		parentProtocol,
		outputOption,
		singleSamplePerProbe,
		dilutionContainer,
		preparedPlate,
		sampleLoadingVolume,
		imageDilutionContainers,
		preparatoryPrimitives
	} = Lookup[roundedMeasureSurfaceTensionOptions, {Instrument, NumberOfReplicates, SamplesOutStorageCondition, NumberOfCalibrationMeasurements,
		MaxCalibrationNoise, EquilibrationTime, NumberOfSampleMeasurements, ProbeSpeed, MaxDryNoise, MaxWetNoise, PreCleaningMethod, CleaningMethod, TertiaryCleaningSolution, PreheatingTime, BurningTime, CoolingTime,
		BetweenMeasurementBurningTime, BetweenMeasurementCoolingTime, MaxCleaningNoise,Name,Template,Confirm,SamplesInStorageCondition,Upload,Email, FastTrack, Operator, ParentProtocol,
		Output,SingleSamplePerProbe,DilutionContainer,PreparedPlate, SampleLoadingVolume,ImageDilutionContainers, PreparatoryUnitOperations}];


	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* Invalid Assay Plate*)
	assayPlateOptions=If[MemberQ[simulatedSampleContainers, Except[ObjectP[Model[Container, Plate, "DynePlate 96-well plate"]]]]&&preparedPlate,
		{preparedPlate},
		Nothing
	];

	invalidAssayPlateOptions=If[MemberQ[simulatedSampleContainers, Except[ObjectP[Model[Container, Plate, "DynePlate 96-well plate"]]]]&&preparedPlate,
		{preparedPlate},
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	invalidAssayPlateOptions=If[Length[assayPlateOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::InvalidAssayPlate,invalidAssayPlateOptions];
		{PreparedPlate},
		Nothing
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidAssayPlateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[invalidAssayPlateOptions]>0,
				Test["If a PreparedPlate specified, the samples are in a DynePlate 96-well plate:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[invalidAssayPlateOptions]>0,
				Test["If a PreparedPlate specified, the samples are in a DynePlate 96-well plate:",True,False],
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

	(*Prepared Plate False*)
	(* Invalid Assay Plate*)
	preparedPlateFalseOptions=MapThread[If[MemberQ[#1, ObjectP[Model[Container, Plate, "DynePlate 96-well plate"]]]&&!preparedPlate,
		{#1,#2},
		Nothing
	]&,{simulatedSampleContainers,simulatedSamples}];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[preparedPlateFalseOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::PreparedPlateFalse,ObjectToString[preparedPlateFalseOptions[[All,2]]],ObjectToString[preparedPlateFalseOptions[[All,1]]],preparedPlate]
	];


	(*Check if the prepared plate option conflicts with other options*)
	(*ConflictingPreparedPlate*)
	conflictingPreparedPlateDilution=
			(* If there there a dilution options set and prepared plate is true, return the options that mismatch. *)
			{
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions, DilutionCurve]], Except[Null | Automatic]],
					{"DilutionCurve",Lookup[roundedMeasureSurfaceTensionOptions, DilutionCurve]},
					Nothing
				],
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions, SerialDilutionCurve]], Except[Null | Automatic]],
					{"SerialDilutionCurve",Lookup[roundedMeasureSurfaceTensionOptions, SerialDilutionCurve]},
					Nothing
				],
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions, Diluent]], Except[Null | Automatic]],
					{"Diluent",Lookup[roundedMeasureSurfaceTensionOptions, Diluent]},
					Nothing
				],
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MatchQ[Lookup[roundedMeasureSurfaceTensionOptions, NumberOfReplicates], Except[Null | 1]],
					{"NumberOfReplicates",Lookup[roundedMeasureSurfaceTensionOptions, NumberOfReplicates]},
					Nothing
				],
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions, DilutionContainer]], Except[Null | Automatic]],
					{"DilutionContainer",Lookup[roundedMeasureSurfaceTensionOptions, DilutionContainer]},
					Nothing
				],
				If[
					Lookup[roundedMeasureSurfaceTensionOptions, PreparedPlate] && MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions, DilutionMixVolume]], Except[Null | Automatic]],
					{"DilutionMixVolume",Lookup[roundedMeasureSurfaceTensionOptions, DilutionMixVolume]},
					Nothing
				]
			};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	conflictingPreparedPlateDilutionInvalidOptions=If[Length[conflictingPreparedPlateDilution]>0&&!gatherTests,
		Message[Error::ConflictingPreparedPlateDilution,conflictingPreparedPlateDilution[[All,1]],conflictingPreparedPlateDilution[[All,2]]];
		Join[ToExpression[#]&/@conflictingPreparedPlateDilution[[All,1]],{PreparedPlate}],
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingPreparedPlateDilutionTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[conflictingPreparedPlateDilution]>0,
				Test["If a PreparedPlate specified, the dilution fields are Null:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingPreparedPlateDilution]>0,
				Test["If a PreparedPlate specified, the dilution fields are Null:",True,False],
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

	(*MissingCleaningMethod*)
	missingCleaningMethodOptions=If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod],Null]&&MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe],False],
		{Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod],Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe]},
		Nothing
	];
	(* If there are invalid options and we are throwing messages, throw an error message*)
	If[Length[missingCleaningMethodOptions]>0&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MissingCleaningMethod,First[missingCleaningMethodOptions],Last[missingCleaningMethodOptions]]
	];
	(* If we are gathering tests, create tests with the appropriate results. *)
	missingCleaningMethodTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingCleaningMethodOptions]==0,
				Warning["If SingleSamplePerProbe is False, a CleaningMethod is specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingCleaningMethodOptions]>0,
				Warning["If SingleSamplePerProbe is False, a CleaningMethod is specified:",True,False],
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

	(* Missing Diluent *)
	missingDiluent=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,diluent,sampleObject},
			(* If there there a dilution in DilutionCurve and Diluent is Null, return the options that mismatch and the input for which they mismatch. *)
			If[Or[MatchQ[dilutionCurve,Except[Null|Automatic]],MatchQ[serialdilutionCurve,Except[Null|Automatic]]]&&MatchQ[diluent,Null],
				{{dilutionCurve,serialdilutionCurve,diluent},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,Diluent],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDiluentOptions,missingDiluentInputs}=If[MatchQ[missingDiluent,{}],
		{{},{}},
		Transpose[missingDiluent]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	missingDiluentInvalidOptions=If[Length[missingDiluentOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::MustSpecifyDiluent,Join[missingDiluentOptions[[All,1]],missingDiluentOptions[[All,2]]],missingDiluentOptions[[All,3]],ObjectToString[missingDiluentInputs,Cache->simulatedCache]];
		{DilutionCurve,SerialDilutionCurve, Diluent},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDiluentTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDiluentInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a Dilution is specified, Diluent is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDiluentInputs]>0,
				Test["If a Dilution is specified, Diluent is not Null, for the inputs "<>ObjectToString[missingDiluentInputs,Cache->simulatedCache]<>" :",True,False],
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

	(*Warning::MultipleAssayPlates="Samples `1` with no dilution `2`,`3` are specified with a True SingleSamplePerProbe `4`. Since there are more than 8 samples, this will take multiple assay plates. If you would like then to all be on the same plate set SingleSamplePerProbe to False."*)
	multipleAssayPatesOptions=If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe],True]
			&&MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,PreparedPlate],False]
			&&Or[
		!MemberQ[Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Except[Null]]&&!MemberQ[Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Except[Null|Automatic]],
		!MemberQ[Lookup[roundedMeasureSurfaceTensionOptions,Diluent],Except[Null|Automatic]],
		!MemberQ[Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],Except[Null|Automatic]]
	] &&Length[simulatedSamples]>8,
		{simulatedSamples,Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe]},
		Nothing
	];


	(* If there are invalid options and we are throwing messages, throw an error message*)
	If[Length[multipleAssayPatesOptions]>0&&!gatherTests&& Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MultipleAssayPlates,ObjectToString[multipleAssayPatesOptions[[1]],Cache->simulatedCache],multipleAssayPatesOptions[[2]],multipleAssayPatesOptions[[3]],multipleAssayPatesOptions[[4]]]
		];

	(* If we are gathering tests, create tests with the appropriate results. *)
	multipleAssayPatesTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[multipleAssayPatesOptions]==0,
				Warning["If SingleSamplePerProbe is True and there is no dilution, there are 8 or less samples:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[multipleAssayPatesOptions]>0,
				Warning["If SingleSamplePerProbe is True and there is no dilution, there are 8 or less samples:",True,False],
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

	(* Missing Cleaning Solution *)
	missingCleaningSolutionOptions= If[MatchQ[{Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,TertiaryCleaningSolution]},{Null,Null,Null}]&&
     Or[MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod]],Solution],MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]],Solution]],
		{
			{Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,TertiaryCleaningSolution]},
			Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod],
			Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]
		},
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	missingCleaningSolutionInvalidOptions=If[Length[missingCleaningSolutionOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::MustSpecifyCleaningSolution,Rest[missingCleaningSolutionOptions],First[missingCleaningSolutionOptions]];
		{CleaningSolution,SecondaryCleaningSolution,TertiaryCleaningSolution,PreCleaningMethod,CleaningMethod},
		{}
	];
	(* If we are gathering tests, create tests with the appropriate results. *)
	missingCleaningSolutionTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingCleaningSolutionOptions]==0,
				Test["If a Cleaning Method with solution is specified, CleaningSolutions are not Null:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingCleaningSolutionOptions]>0,
				Test["If a Cleaning Method with solution is specified, CleaningSolutions are not Null:",True,False],
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

	(* Cleaning Solution given but no cleaning by solution given *)
	conflictingCleaningSolutionOptions= If[MemberQ[{Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,TertiaryCleaningSolution]},Except[Null|Automatic]]&&
			!Or[MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod]],Solution],MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]],Solution]],
		{
			{Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],Lookup[roundedMeasureSurfaceTensionOptions,TertiaryCleaningSolution]},
			Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod],
			Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]
		},
		Nothing
	];

	(* If we are throwing messages, throw an warning message *)
	If[Length[conflictingCleaningSolutionOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::ConflictingCleaningSolution,Rest[conflictingCleaningSolutionOptions],First[conflictingCleaningSolutionOptions]]
		];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingCleaningSolutionTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingCleaningSolutionOptions]==0,
				Warning["If CleaningSolutions are not Null, a Cleaning Method with solution is specified:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingCleaningSolutionOptions]>0,
				Warning["If CleaningSolutions are not Null, a Cleaning Method with solution is specified:",True,False],
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

	(* Two DilutionCurves *)
	conflictingDilutionCurve=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,sampleObject},
			(* If both DilutionCurve and SerialDilutionCurve are specified to not Null, return the options that mismatch and the input for which they mismatch. *)
			If[MatchQ[dilutionCurve,Except[Null|Automatic]]&&MatchQ[serialdilutionCurve,Except[Null|Automatic]],
				{{dilutionCurve,serialdilutionCurve},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{conflictingDilutionCurveOptions,conflictingDilutionCurveInputs}=If[MatchQ[conflictingDilutionCurve,{}],
		{{},{}},
		Transpose[conflictingDilutionCurve]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	conflictingDilutionCurveInvalidOptions=If[Length[conflictingDilutionCurveOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::CannotSpecifyBothDilutionCurveAndSerialDilutionCurve,First[#]&/@conflictingDilutionCurveOptions,Last[#]&/@conflictingDilutionCurveOptions,ObjectToString[conflictingDilutionCurveInputs,Cache->simulatedCache]];
		{DilutionCurve, SerialDilutionCurve},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
conflictingDilutionCurveTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,conflictingDilutionCurveInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a DilutionCurve is specified, SerialDilutionCurve is not specified, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDiluentInputs]>0,
				Test["If a DilutionCurve is specified, SerialDilutionCurve is not specified, for the inputs "<>ObjectToString[missingDiluentInputs,Cache->simulatedCache]<>" :",True,False],
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

	(* Missing Dilution Curve *)
	missingDilutionCurve=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,diluent,sampleObject},
			(* If the Diluant is set and DiluentCurve is Null?, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[diluent,Except[Null|Automatic]],MatchQ[dilutionCurve,Null|Automatic],MatchQ[serialdilutionCurve,Null]],
				{{dilutionCurve,serialdilutionCurve,diluent},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,Diluent],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionCurveOptions,missingDilutionCurveInputs}=If[MatchQ[missingDilutionCurve,{}],
		{{},{}},
		Transpose[missingDilutionCurve]
	];
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[missingDilutionCurveOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::MissingDilutionCurve,Last[#]&/@missingDilutionCurveOptions,Most[#]&/@missingDilutionCurveOptions,ObjectToString[missingDilutionCurveInputs,Cache->simulatedCache]]
	];
	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionCurveTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionCurveInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["If a Diluent is specified, DilutionCurve is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionCurveInputs]>0,
				Warning["If a Diluent is specified, DilutionCurve is not Null, for the inputs "<>ObjectToString[missingDilutionCurveInputs,Cache->simulatedCache]<>" :",True,False],
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

	(*ConflictingDilutionMixSettings*)
	(*Error::ConflictingDilutionMixSettings="One or two, but not all of DilutionMixVolume `1`, DilutionNumberOfMixes `2` or DilutionMixRate `3` is Null for samples `4`. Please inform all of these are set them all to Null."*)

	conflictingDilutionMix=MapThread[
		Function[{dilutionMixVolume,dilutionNumberOfMixes, dilutionMixRate,sampleObject},
			(* If the Dilution Mix Volume is Null and there is diluting in DilutionCurve, return the options that mismatch and the input for which they mismatch. *)
			If[MemberQ[{dilutionMixVolume,dilutionNumberOfMixes, dilutionMixRate},Null]&&MemberQ[{dilutionMixVolume,dilutionNumberOfMixes, dilutionMixRate},Except[Null]],
				{{dilutionMixVolume,dilutionNumberOfMixes, dilutionMixRate},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionMixVolume],Lookup[roundedMeasureSurfaceTensionOptions,DilutionNumberOfMixes],Lookup[roundedMeasureSurfaceTensionOptions,DilutionMixRate],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{conflictingDilutionMixOptions,conflictingDilutionMixInputs}=If[MatchQ[conflictingDilutionMix,{}],
		{{},{}},
		Transpose[conflictingDilutionMix]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	conflictingDilutionMixInvalidOptions=If[
		Length[conflictingDilutionMixOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::ConflictingDilutionMixSettings,#[[1]]&/@conflictingDilutionMixOptions, #[[2]]&/@conflictingDilutionMixOptions, #[[3]]&/@conflictingDilutionMixOptions,ObjectToString[conflictingDilutionMixInputs,Cache->simulatedCache]];
		{DilutionMixVolume,DilutionNumberOfMixes, DilutionMixRate},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDilutionMixTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,conflictingDilutionMixInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If at least one but not all of DilutionMixVolume , DilutionNumberOfMixes or DilutionMixRate  is Null, all must be Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionCurveInputs]>0,
				Test["If at least one but not all of DilutionMixVolume , DilutionNumberOfMixes or DilutionMixRate  is Null, all must be Null, for the inputs "<>ObjectToString[missingDilutionCurveInputs,Cache->simulatedCache]<>" :",True,False],
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


	(* Missing Dilution Mix Volume *)
	missingDilutionMixVolume=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,dilutionMixVolume,sampleObject},
			(* If the Dilution Mix Volume is Null and there is diluting in DilutionCurve, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[dilutionMixVolume,Null],Or[MatchQ[dilutionCurve,Except[Null]],MatchQ[serialdilutionCurve,Except[Null]]]],
				{{dilutionCurve,serialdilutionCurve,dilutionMixVolume},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionMixVolume],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionMixVolumeOptions,missingDilutionMixVolumeInputs}=If[MatchQ[missingDilutionMixVolume,{}],
		{{},{}},
		Transpose[missingDilutionMixVolume]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[missingDilutionMixVolumeOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::MissingDilutionMixVolume,Most[#]&/@missingDilutionMixVolumeOptions,Last[#]&/@missingDilutionMixVolumeOptions,ObjectToString[missingDilutionMixVolumeInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionMixVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionMixVolumeInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionMixVolume is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionCurveInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionMixVolume is not Null, for the inputs "<>ObjectToString[missingDilutionCurveInputs,Cache->simulatedCache]<>" :",True,False],
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

	(* Conflicting Dilution Mix Volume *)
	conflictingDilutionMixVolume=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,dilutionMixVolume,sampleObject},
			(* If the Dilution Mix Volume is not Null and the is no diluting in DilutionCurve, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[dilutionMixVolume,Except[Null|Automatic]], MatchQ[dilutionCurve,Null|Automatic],MatchQ[serialdilutionCurve,Null]],
				{{dilutionCurve,serialdilutionCurve,dilutionMixVolume},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionMixVolume],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{conflictingDilutionMixVolumeOptions, conflictingDilutionMixVolumeInputs}=If[MatchQ[conflictingDilutionMixVolume,{}],
		{{},{}},
		Transpose[conflictingDilutionMixVolume]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[conflictingDilutionMixVolume]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::ConflictingDilutionMixVolume,Last[#]&/@conflictingDilutionMixVolumeOptions,Most[#]&/@conflictingDilutionMixVolumeOptions,ObjectToString[conflictingDilutionMixVolumeInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDilutionMixVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,conflictingDilutionMixVolumeInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["If there is no diluting in  DilutionCurve, DilutionMixVolume is Null: for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDilutionMixVolumeInputs]>0,
				Warning["If there is no diluting in  DilutionCurve, DilutionMixVolume is Null: for the inputs "<>ObjectToString[conflictingDilutionMixVolumeInputs,Cache->simulatedCache]<>" :",True,False],
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

	(* Missing Dilution Number of mixes *)
	missingDilutionNumberofMixes=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,dilutionNumberOfMixes,sampleObject},
			(* If the Dilution number of mixes is Null and the is diluting in DilutionCurve, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[dilutionNumberOfMixes,Null],Or[MatchQ[dilutionCurve,Except[Null]],MatchQ[serialdilutionCurve,Except[Null]]]],
				{{dilutionCurve,serialdilutionCurve,dilutionNumberOfMixes},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionNumberOfMixes],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionNumberofMixesOptions,missingDilutionNumberofMixesInputs}=If[MatchQ[missingDilutionNumberofMixes,{}],
		{{},{}},
		Transpose[missingDilutionNumberofMixes]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[missingDilutionNumberofMixesOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::MissingDilutionNumberOfMixes,Most[#]&/@missingDilutionNumberofMixesOptions,Last[#]&/@missingDilutionNumberofMixesOptions,ObjectToString[missingDilutionNumberofMixesInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionNumberofMixesTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionNumberofMixesInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionNumberOfMixes is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionNumberofMixesInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionNumberOfMixes is not Null, for the inputs "<>ObjectToString[missingDilutionNumberofMixesInputs,Cache->simulatedCache]<>" :",True,False],
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

	(* Missing Dilution MixRate *)
	missingDilutionMixRate=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,dilutionMixRate,sampleObject},
			(* If the Dilution MixRate is Null and the is diluting in DilutionCurve, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[dilutionMixRate,Null],MatchQ[dilutionCurve,Except[Null]],MatchQ[serialdilutionCurve,Except[Null]]],
				{{dilutionCurve,serialdilutionCurve,dilutionMixRate},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionMixRate],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionMixRateOptions,missingDilutionMixRateInputs}=If[MatchQ[missingDilutionMixRate,{}],
		{{},{}},
		Transpose[missingDilutionMixRate]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[missingDilutionMixRateOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::MissingDilutionMixRate,Most[#]&/@missingDilutionMixRateOptions,Last[#]&/@missingDilutionMixRateOptions,ObjectToString[missingDilutionMixRateInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionMixRateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionMixRateInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionMixRate is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionMixRateInputs]>0,
				Warning["If there is diluting in DilutionCurve, DilutionMixRate is not Null, for the inputs "<>ObjectToString[missingDilutionMixRateInputs,Cache->simulatedCache]<>" :",True,False],
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

	(*If a prepared plate was given, check the samples in the calibrant wells, any well ending with 12*)
	samplesInCalibrantWells=If[preparedPlate,
		PickList[simulatedSamples, MatchQ[StringDrop[#, 1], "12"] & /@ simulatedSampleWells],
		Nothing];

	calibrantWells=If[
		preparedPlate,
		Select[simulatedSampleWells, MatchQ[StringDrop[#, 1], "12"]&],
		Nothing
	];

	samplesInCalibrantWellsComposition=If[preparedPlate,
		Lookup[calibrantCompositionReplaceRules,#]&/@samplesInCalibrantWells/.{x:LinkP[]:>Link[x]},
		Nothing];



	(*ConflictingPreparedPlateCalibrants*)
	conflictingPreparedPlateCalibrantsOptions=If[!MatchQ[samplesInCalibrantWellsComposition,{}]&&preparedPlate&&MemberQ[samplesInCalibrantWellsComposition,Except[First[samplesInCalibrantWellsComposition]]],
		Message[Warning::ConflictingPreparedPlateCalibrants, preparedPlate,samplesInCalibrantWells],
		Nothing
	];

	(*Get the plate objects inputted to the function*)
	containerObjects=DeleteDuplicates[Lookup[simulatedContainersPackets, Object]];

	(*if there are none, throw an error*)
	noCalibrantProvidedOptions=If[preparedPlate&&Length[samplesInCalibrantWells]<8*Length[containerObjects],
		{preparedPlate},
		{}
	];

	noCalibrantProvidedInvalidOptions=If[Length[noCalibrantProvidedOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::NoCalibrantProvided,preparedPlate,Complement[{"A12", "B12", "C12", "D12", "E12", "F12", "G12", "H12"},calibrantWells]];
		{PreparedPlate},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	noCalibrantProvidedTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[noCalibrantProvidedOptions]>0,
				Test["If a PreparedPlate was given, the calibrant wells are filled:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[noCalibrantProvidedOptions]>0,
				Test["If a PreparedPlate was given, the calibrant wells are filled:",True,False],
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

	calibrantinput=If[preparedPlate,
		If[Length[samplesInCalibrantWells]>0,samplesInCalibrantWells,Null],
		Lookup[roundedMeasureSurfaceTensionOptions,Calibrant]
	];

	calibrantinputST=Which[
		MatchQ[calibrantinput,Automatic],Null,
		preparedPlate,If[MatchQ[samplesInCalibrantWells,{}],Null,Lookup[calibrantSurfaceTensionReplaceRules,First[samplesInCalibrantWells]]],
		True,Lookup[calibrantSurfaceTensionReplaceRules,calibrantinput]
	];


	(* Calibrant Surface Tension Mismatch*)
	calibrantSurfaceTensionMismatch=If[MatchQ[calibrantinput,Except[Automatic]]&&MatchQ[calibrantinputST,Except[Null]]&&!MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,CalibrantSurfaceTension],calibrantinputST|Automatic],
		{calibrantinputST, Lookup[roundedMeasureSurfaceTensionOptions,CalibrantSurfaceTension]},
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[calibrantSurfaceTensionMismatch]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::CalibrantSurfaceTensionMismatch,First[calibrantSurfaceTensionMismatch],Last[calibrantSurfaceTensionMismatch]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	calibrantSurfaceTensionMismatchTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[calibrantSurfaceTensionMismatch]>0,
				Warning["If a Calibrant and CalibrantSurfaceTension are specified, the value Calibrant's SurfaceTension Field matches the CalibrantSurfaceTension "<>ObjectToString[calibrantSurfaceTensionMismatch,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[calibrantSurfaceTensionMismatch]>0,
				Warning["If a Calibrant and CalibrantSurfaceTension are specified, the value Calibrant's SurfaceTension Field matches the CalibrantSurfaceTension "<>ObjectToString[calibrantSurfaceTensionMismatch,Cache->simulatedCache]<>" :",True,False],
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


	(*SamplesOutStorageConditionMismatch*)
	samplesOutMismatch=If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition],{Disposal ..}]&&MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut],Except[Null|Automatic]],
		{Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition], Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut]},
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[samplesOutMismatch]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Warning::SamplesOutStorageConditionMismatch,First[samplesOutMismatch],Last[samplesOutMismatch]]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	samplesOutMismatchTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[samplesOutMismatch]>0,
				Warning["If a ContainersOut is provided, SamplesOutStorageCondition is not disposal "<>ObjectToString[containersOutMismatch,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[samplesOutMismatch]>0,
				Warning["If a ContainersOut is provided, SamplesOutStorageCondition is not disposal "<>ObjectToString[containersOutMismatch,Cache->simulatedCache]<>":",True,False],
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
	(* ContainersOut Mismatch*)
	containersOutMismatch=If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition],Except[{Disposal ..}]]&&MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut],Null],
		{Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition], Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut]},
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	containersOutMismatchInvalidOptions=If[Length[containersOutMismatch]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::ContainerOutMismatch,First[containersOutMismatch],Last[containersOutMismatch]];
		{SamplesOutStorageCondition,ContainerOut},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	containersOutMismatchTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputsTest},
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[containersOutMismatch]>0,
				Test["If a ContainersOut is set to Null, SamplesOutStorageCondition is disposal "<>ObjectToString[containersOutMismatch,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[containersOutMismatch]>0,
				Test["If a ContainersOut is set to Null, SamplesOutStorageCondition is disposal "<>ObjectToString[containersOutMismatch,Cache->simulatedCache]<>":",True,False],
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

	(* Missing Dilution Container *)
	(*If there a dilution in DilutionCurve and DilutionContainer is Null, return conflicting options *)
	missingDilutionContainer=MapThread[
		Function[{dilutionCurve,serialdilutionCurve,dilutionContainer,sampleObject},
			(* If there there a dilution in DilutionCurve and Diluent is Null, return the options that mismatch and the input for which they mismatch. *)
			If[Or[MatchQ[dilutionCurve,Except[Null|Automatic]],MatchQ[serialdilutionCurve,Except[Null|Automatic]]]&&MatchQ[dilutionContainer,Null],
				{{dilutionCurve,serialdilutionCurve,dilutionContainer},sampleObject},
				Nothing
			]
		],
		{Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionContainerOptions,missingDilutionContainerInputs}=If[MatchQ[missingDilutionContainer,{}],
		{{},{}},
		Transpose[missingDilutionContainer]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	missingDilutionContainerInvalidOptions=If[Length[missingDilutionContainerOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::MissingDilutionContainer,Most[#]&/@missingDilutionContainerOptions,Last[#]&/@missingDilutionContainerOptions,ObjectToString[missingDilutionContainerInputs,Cache->simulatedCache]];
		{DilutionCurve, DilutionContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionContainerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionContainerInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a Dilution is specified, DilutionContainer is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionContainerInputs]>0,
				Test["If a Dilution is specified, DilutionContainer is not Null, for the inputs "<>ObjectToString[missingDilutionContainerInputs,Cache->simulatedCache]<>" :",True,False],
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

  (*ConflictingDilutionContainer, if different dilution containters share the same index*)
  (*check if all the storage conditions with the same index are the same*)
  conflictingDilutionContainers=Module[{expandedDilutionContainers, gatheredDilutionContainers},
    (*only keep the containers were both a container and index is given*)
    expandedDilutionContainers=If[
      Length[ToList[#]] >1 && !MemberQ[ToList[#], Null|Automatic],
      #,
      Nothing] & /@ Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer];

    gatheredDilutionContainers=GatherBy[expandedDilutionContainers,First];

    (*Find the groupings that have different containers*)
    Flatten[If[MemberQ[#, Except[First[#]]], #, Nothing] & /@ gatheredDilutionContainers,1]
  ];


  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
  conflictingDilutionContainerInValidOptions=If[Length[conflictingDilutionContainers]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
    Message[Error::ConflictingDilutionContainer,conflictingDilutionContainers];
    {DilutionContainer},
    {}
  ];

  (* Create the corresponding test for the storage error. *)
  conflictingDilutionContainerTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputTest},
      (* Create a test for the non-passing inputs. *)
      failingInputTest=If[Length[conflictingDilutionContainerInValidOptions]>0,
        Test["The dilution container groupings "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],Cache->simulatedCache]<>" do not have different containers sharing the same index:",True,False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingDilutionContainerInValidOptions]==0,
        Test["The dilution container groupings "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],Cache->simulatedCache]<>" do not have different containers sharing the same index:",True,True],
        Nothing
      ];

      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

	(*DilutionContainerConflictingStorage- check if any of the user provided groupings don't match storage conditions*)
	unresolvedDilutionContainerGrouping=If[ListQ[#],#[[1]],Automatic]&/@Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer];

	(*Match the storage conditions with the dilution container indices*)
	indexedStorageConditions=MapThread[{#1, #2} &, {unresolvedDilutionContainerGrouping, Lookup[roundedMeasureSurfaceTensionOptions,DilutionStorageCondition]}];

	(*If they match and the indices are not automatic, group them*)
	groupedStorageConditions=Gather[If[!MatchQ[First[#], Automatic], #, Nothing] & /@indexedStorageConditions, First[#1] == First[#2] &];

	(*check if all the storage conditions with the same index are the same*)
	mismatchedDilutionContainerStorage=If[ContainsOnly[#, {First[#]}],Nothing,#]&/@groupedStorageConditions;

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	dilutioncontainerStorageInValidOptions=If[Length[mismatchedDilutionContainerStorage]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::DilutionContainerConflictingStorage,mismatchedDilutionContainerStorage[[All, 1]][[All, 1]],#[[All, 2]]&/@mismatchedDilutionContainerStorage];
		mismatchedDilutionContainerStorage,
		{}
	];

	(* Create the corresponding test for the storage error. *)
	dilutionContainerStorageTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputTest},
			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[dilutioncontainerStorageInValidOptions]>0,
				Test["The inputted dilution storage condition, "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionStorageCondition],Cache->simulatedCache]<>" does not conflict with the dilution container groupings "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],Cache->simulatedCache]<>":",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[dilutioncontainerStorageInValidOptions]==0,
				Test["The inputted dilution storage condition, "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionStorageCondition],Cache->simulatedCache]<>" does not conflict with the dilution container groupings "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer],Cache->simulatedCache]<>":",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	mismatchedContainerOutStorage=!MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition], {First[ToList[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition]]]..}];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	containerOutStorageInValidOptions=If[mismatchedContainerOutStorage&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::MeasureSurfaceTesnsionContainerOutConflictingStorage,Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition]];
		{SamplesOutStorageCondition},
		{}
	];

	(* Create the corresponding test for the storage error. *)
	containerOutStorageTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputTest},
			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[mismatchedContainerOutStorage,
				Test["The inputted samples out storage condition, "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition],Cache->simulatedCache]<>" does not conflict with the container groupings:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[mismatchedContainerOutStorage,
				Test["The inputted samples out storage condition, "<>ObjectToString[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition],Cache->simulatedCache]<>" does not conflict with the container groupings:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	primaryCleaningSolution=Which[
		(*specified by user*)
		MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],Except[Automatic]],
		Lookup[roundedMeasureSurfaceTensionOptions,CleaningSolution],
		(*solution is needed*)
		Or[MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod]],Solution],MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]],Solution]],
		Model[Sample, StockSolution, "70% ethanol cleaning solution for tensiometer"],
		(*none needed*)
		True,
		Null
	];

	secondaryCleaningSolution=Which[
		(*specified by user*)
		MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],Except[Automatic]],
		Lookup[roundedMeasureSurfaceTensionOptions,SecondaryCleaningSolution],
		(*solution is needed*)
		Or[MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,PreCleaningMethod]],Solution],MemberQ[ToList[Lookup[roundedMeasureSurfaceTensionOptions,CleaningMethod]],Solution]],
		Model[Sample, "Milli-Q water"],
		(*none needed*)
		True,
		Null
	];

	cleaningSolution={primaryCleaningSolution, secondaryCleaningSolution, tertiaryCleaningSolution};

	resolvedcontainersOut=Which[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut],Except[Automatic]],Lookup[roundedMeasureSurfaceTensionOptions,ContainerOut],
		MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SamplesOutStorageCondition],{Disposal ..}], Null,
		True, Model[Container,Plate,"id:L8kPEjkmLbvW"]
	];

	(*Make the dilution container field of te forn {{_,_},{_,_}..} to make mapThreadOptions run smoothly*)
	unresolvedDilutionContainer=If[ListQ[#],#,{Automatic,#}]&/@Lookup[roundedMeasureSurfaceTensionOptions,DilutionContainer];

	(* Convert our index matched options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureSurfaceTension,roundedMeasureSurfaceTensionOptions];
	(*First resolve all the diluents, because the calibrant is not index matched and depends on all the diluents used *)

	resolveddiluents=Flatten[Transpose[MapThread[Function[{myMapThreadOptions},
			Module[{diluent},
				diluent=Which[
					(*is a diluent given?*)
					MatchQ[Lookup[myMapThreadOptions,Diluent],Except[Automatic]], Lookup[myMapThreadOptions,Diluent],
					(*is it a prepared plate?*)
					preparedPlate,Null,
					(*will there be no diluting?*)
					MatchQ[Lookup[myMapThreadOptions,DilutionCurve],Null|Automatic]&&MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve],Null], Null,
					True, Model[Sample,"Milli-Q water"]
				];
				(* Gather MapThread results *)
				{diluent}
			]
		],
		{mapThreadFriendlyOptions}
	]]];

	allDiluents=Cases[resolveddiluents,Except[Null]];
	potentialCalibrant=If[Length[allDiluents]>0,
		First[allDiluents],
		Nothing
	];

	potentialCalibrantST=If[Length[allDiluents]>0,
		Lookup[calibrantSurfaceTensionReplaceRules,First[allDiluents]],
		Nothing
	];

	(*Next find the calibrant from the resolved diluents*)
	resolvedCalibrant=Which[MatchQ[calibrantinput,Except[Automatic]],calibrantinput,
		(*Are all the diluents Null?*)
		Length[allDiluents]==0, Model[Sample,"Milli-Q water"],
		(*Is the same diluent used for all samples and has a populated surface tension field?*)
		Length[Tally[allDiluents]]==1&&MatchQ[potentialCalibrantST,Except[Null]],potentialCalibrant,
		True,Model[Sample,"Milli-Q water"]
	];


	resolvedcalibrantSTfield=If[preparedPlate,
		calibrantinputST,
		Lookup[calibrantSurfaceTensionReplaceRules,resolvedCalibrant,Null]
	];

	(*Use the resolved calbrant to get the calibrant's surface tension*)
	missingCalibrantSurfaceTensionError=False;
	resolvedcalibrantSurfaceTension=Which[
		(* Don't need to throw this if calibrant is Null *)
		NullQ[resolvedCalibrant],
			Null,
		MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,CalibrantSurfaceTension],Except[Automatic]],
			Lookup[roundedMeasureSurfaceTensionOptions,CalibrantSurfaceTension],
		(*Is the resolved calibrant's SurfaceTension Field not populated?*)
		MatchQ[resolvedcalibrantSTfield,Null],
			missingCalibrantSurfaceTensionError=True; Null,
		True,
			resolvedcalibrantSTfield
	];

	(* Set up another Mapthread to resolve the rest of the index matched options *)
	{resolveddilutionCurve,resolvedserialdilutionCurve,dilutionCurveVolumeErrors,dilutionCurveExcessVolumeWarnings,resolveddilutionMixVolume,requiredSampleVolumes, dilutionContainerErrors, maxvolumes, numberOfDilutionWells, halfresolveddilutionContainer,requiredWells,requiredRows, resolveddilutionMixRate,resolvednumberOfMixes,resolveddilutionStorageCondition}=
	Transpose[MapThread[Function[{myMapThreadOptions,myDiluents, myDilutionContainer},
			Module[{dilutionCurve,serialdilutionCurve,dilutionCurveVolumeError,dilutionMixVolume,dilutionCurveExcessVolumeWarning,requiredSampleVolume,maxvolume, numberOfDilutionWell, dilutionContainerError,dilutionContainer,requiredWell,requiredRow, dilutionMixRate,numberOfMixes,dilutionStorageCondition},
				(* Set more error tracking variables *)
				{dilutionCurveVolumeError,dilutionCurveExcessVolumeWarning, dilutionContainerError}={False,False,False};
				(* Resolving DilutionCurve and SerialDilutionCurve Option *)
				{dilutionCurve,serialdilutionCurve}=Which[
					MatchQ[Lookup[myMapThreadOptions,DilutionCurve],Automatic|Null]&&MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve],Automatic],Which[
						(*Is the Diluent or Dilution container set to Null by the user or is preparedplate true?*)
						MatchQ[Lookup[myMapThreadOptions,Diluent],Null]||MatchQ[myDilutionContainer[[2]],Null]||preparedPlate,{Null,Null},
						(*Does Diluant = Calibrant?*)
						MatchQ[resolvedCalibrant,ObjectP[myDiluents]],{Null,{100 Microliter,{0.7,21}}},
						True,{Null,{100 Microliter,{0.7,20}}}
					],
					(*No dilution*)
					MatchQ[Lookup[myMapThreadOptions,DilutionCurve],Automatic|Null]&&MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve],Null],{Null,Null},
					(*Is a serial Dilution specified?*)
					MatchQ[Lookup[myMapThreadOptions,DilutionCurve],Automatic|Null]&&MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve],Except[Null|Automatic]],Which[
						(*TransferVolume or samplevolume>loadingvolume?*)
						MatchQ[Which[MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve], {VolumeP, VolumeP, _Integer}], Lookup[myMapThreadOptions,SerialDilutionCurve][[2]],
							True, First[Lookup[myMapThreadOptions,SerialDilutionCurve]]
						],GreaterP[sampleLoadingVolume+100*Microliter]]&&MatchQ[Lookup[myMapThreadOptions,DilutionStorageCondition],Automatic|Disposal],dilutionCurveExcessVolumeWarning=True; {Null,Lookup[myMapThreadOptions,SerialDilutionCurve]},
						(*TransferVolume or samplevolume<loadingvolume?*)
						MatchQ[Which[MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve], {VolumeP, VolumeP, _Integer}], Lookup[myMapThreadOptions,SerialDilutionCurve][[2]],
							True, First[Lookup[myMapThreadOptions,SerialDilutionCurve]]
						],LessP[sampleLoadingVolume]],dilutionCurveVolumeError=True; {Null,Lookup[myMapThreadOptions,SerialDilutionCurve]},
						(*not too little, not too much*)
						True,{Null,Lookup[myMapThreadOptions,SerialDilutionCurve]}
					],
						(*Is a Fixed Dilution specified?*)
					MatchQ[Lookup[myMapThreadOptions,DilutionCurve],Except[Automatic|Null]]&&MatchQ[Lookup[myMapThreadOptions,SerialDilutionCurve],Automatic|Null],
						dilutionsamplevolumes=Which[MatchQ[Lookup[myMapThreadOptions,DilutionCurve], {VolumeP, VolumeP} | {{VolumeP, VolumeP} ..}],
							Total[#] & /@ Lookup[myMapThreadOptions,DilutionCurve],
							True, First[#] & /@ Lookup[myMapThreadOptions,DilutionCurve]
						];
						Which[
							(*Is (SampleAmount + DiluentVolume)<sampleLoadingVolume*)
							AnyTrue[dilutionsamplevolumes,MatchQ[#,LessP[sampleLoadingVolume]] &], dilutionCurveVolumeError=True; {Lookup[myMapThreadOptions,DilutionCurve],Null},
						(*Is (SampleAmount + DiluentVolume)>sampleLoadingVolume*)
						AnyTrue[dilutionsamplevolumes,MatchQ[#,GreaterP[sampleLoadingVolume+100*Microliter]] &]&&MatchQ[Lookup[myMapThreadOptions,DilutionStorageCondition],Automatic|Disposal],dilutionCurveExcessVolumeWarning=True; {Lookup[myMapThreadOptions,DilutionCurve],Null},
							(*Is not too little, not too much*)
						True, {Lookup[myMapThreadOptions,DilutionCurve],Null}
					],
						True,{Lookup[myMapThreadOptions,DilutionCurve],Lookup[myMapThreadOptions,SerialDilutionCurve]}
				];
				(* Resolving DilutionMixVolume Option *)
				dilutionMixVolume=Which[
					MatchQ[Lookup[myMapThreadOptions,DilutionMixVolume],Except[Automatic]], Lookup[myMapThreadOptions,DilutionMixVolume],
					(*Is the DilutionCurve set to No Dilution or Null by the user?*)
					MatchQ[serialdilutionCurve,Null]&&MatchQ[dilutionCurve,Null], Null,
					(*Is it a serial dilution with a given transfer volume*)
					MatchQ[serialdilutionCurve,Except[Null]], Which[
						MatchQ[serialdilutionCurve, {VolumeP, VolumeP, _Integer}], serialdilutionCurve[[2]],
						True, First[serialdilutionCurve]
						],
					True,40 Microliter
				];
				requiredSampleVolume=Which[
					(*Is a serial Dilution specified?*)
					MatchQ[serialdilutionCurve,Except[Null]],First[First[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]],
					(*Is a custom Dilution specified?*)
					MatchQ[dilutionCurve,Except[Null]],Total[First[calculatedDilutionCurveVolumes2[dilutionCurve]]],
					True,sampleLoadingVolume
				];
				(*Find the max volume to see if the dilution container is too small*)
				maxvolume=Which[
					(*Is a serial Dilution specified?*)
					(*the transfer volume plus the diluent volume*)
					MatchQ[serialdilutionCurve,Except[Null]], Max[First[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]+Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]],
					(*Is a custom Dilution specified?*)
					MatchQ[dilutionCurve,Except[Null]],Max[First[calculatedDilutionCurveVolumes2[dilutionCurve]]+Last[calculatedDilutionCurveVolumes2[dilutionCurve]]],
					True,sampleLoadingVolume
				];
				(*resolve all the container object/model parts of the dilution curve by if there is diluting, the container indices will be resolved later*)
				dilutionContainer=Which[
					(*user specified*)
					MatchQ[myDilutionContainer[[2]],Except[Automatic]],
						(*check if the dilution fits in the container*)
						If[
							MatchQ[myDilutionContainer[[2]],Except[Null]]&&maxvolume>First[Lookup[dilutionContainerReplaceRules, myDilutionContainer[[2]]]],
							dilutionContainerError=True
						];
						(*return the user given container*)
						myDilutionContainer,
					(*Automatic*)
					True, If[
						(*check if there needs to be a container;If there is any diluting*)
						MatchQ[dilutionCurve, Null]&&MatchQ[serialdilutionCurve, Null],
						{First[myDilutionContainer],Null},
						(*If there is diluting, check if it will fit on a the default plate*)
						If[
							MatchQ[myDilutionContainer[[2]],Except[Null]]&&maxvolume>2*Milliliter,
							dilutionContainerError=True
						];
						(*Return the default plate*)
						{First[myDilutionContainer],Model[Container, Plate, "id:L8kPEjkmLbvW"]}
					]
				];

				numberOfDilutionWell=Which[
					(*Is a serial Dilution specified?*)
					MatchQ[serialdilutionCurve,Except[Null]], Length[First[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]],
					(*Is a custom Dilution specified?*)
					MatchQ[dilutionCurve,Except[Null]], Length[First[calculatedDilutionCurveVolumes2[dilutionCurve]]],
					True,0
				];

				{requiredWell,requiredRow}=Which[
					(*Is a serial Dilution specified?*)
					MatchQ[serialdilutionCurve,Except[Null]],{
						(*wells taken up by the curve excluding the calibrant*)
						Length[Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]],
						(*rows taken up by the curve*)
						Ceiling[(Length[Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[resolvedCalibrant,ObjectP[myDiluents]]]]])/11]
					},
					(*Is a custom Dilution specified?*)
					MatchQ[dilutionCurve,Except[Null]],{
						(*length of the curve*)
						Length[dilutionCurve],
						(*rows taken up by the curve*)
						Ceiling[Length[dilutionCurve]/11]
					},
					(*Is the plate prepared plate or do diluting*)
					True,{1,1}
				];

				dilutionMixRate=If[MatchQ[Lookup[myMapThreadOptions,DilutionMixRate],Automatic],
					If[MatchQ[dilutionCurve,Null]&&MatchQ[serialdilutionCurve,Null],
						Null,
						100 Microliter/Second
					],
					Lookup[myMapThreadOptions,DilutionMixRate]
				];

				numberOfMixes=If[MatchQ[Lookup[myMapThreadOptions,DilutionNumberOfMixes],Automatic],
					If[MatchQ[dilutionCurve,Null]&&MatchQ[serialdilutionCurve,Null],
						Null,
						5
					],
					Lookup[myMapThreadOptions,DilutionNumberOfMixes]
				];

				dilutionStorageCondition=If[MatchQ[Lookup[myMapThreadOptions,DilutionStorageCondition],Automatic],
					If[MatchQ[dilutionCurve,Null]&&MatchQ[serialdilutionCurve,Null],
						Null,
						Disposal
					],
					Lookup[myMapThreadOptions,DilutionStorageCondition]
				];

				(* Gather MapThread results *)
				{dilutionCurve,serialdilutionCurve,dilutionCurveVolumeError,dilutionCurveExcessVolumeWarning,dilutionMixVolume,requiredSampleVolume,dilutionContainerError, maxvolume, numberOfDilutionWell, dilutionContainer,requiredWell,requiredRow,dilutionMixRate,numberOfMixes,dilutionStorageCondition}
			]
		],
		{mapThreadFriendlyOptions,resolveddiluents, unresolvedDilutionContainer}
	]];


	(*Check to see if there is any dilution to resolve singlesampleperprobe*)
	resolvedsingleSamplePerProbe=If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe],Except[Automatic]],
		Lookup[roundedMeasureSurfaceTensionOptions,SingleSamplePerProbe],
		If[!Or[MemberQ[resolveddilutionCurve,Except[Null]],MemberQ[resolvedserialdilutionCurve,Except[Null]]]
				&&!MatchQ[cleaningMethod,Null]&&Length[simulatedSamples]>8,
			(*There is some no dilution, there is cleaning between measurements and there are more than eight samples*)
			False,
			(*else*)
			True]
	];

	(*separated dilution container into its objects and indices*)
	dilutionContainerGrouping=halfresolveddilutionContainer[[All,1]];
	dilutionContainerObjects=halfresolveddilutionContainer[[All,2]];

	(*get how many dilution wells are needed for the dilution of the sample be multiplying the required wells for the curve by the number of replicates*)
	requiredWells=numberOfDilutionWells*If[MatchQ[numberOfReplicates,Null],1,numberOfReplicates];

	(*check how many wells are in the dilution containers*)
	availableWells=If[MatchQ[Lookup[dilutionContainerReplaceRules,#][[2]],Null],
		0,
		Lookup[dilutionContainerReplaceRules,#][[2]]
	]&/@dilutionContainerObjects;


	(*merge all the container options so we can look for samples that can share containers*)
	(*{grouping,object,storageconditions,index,requiredwells, availablewells*)
	mergedContainerOptions=MapThread[{#1, #2, #3, #4, #5, #6} &, {dilutionContainerGrouping, dilutionContainerObjects, resolveddilutionStorageCondition, Range[Length[dilutionContainerGrouping]], requiredWells,availableWells}];

	(*Gather all the options based on if their grouping number is the same, their dilution container is the same, and if the storage container is the same*)
	gatheredmergedContainerOptions = Gather[mergedContainerOptions, #1[[1;;3]] == #2[[1;;3]] &];

	(*Divide the grouped samples into multiple containers if needed.*)
	(*For example if there are 3 samples with with automatic grouping that need 10 wells each in 20 well containers, put two samples in one 20 well container and one sample in a second container*)

	(*fold the gathered list so the there are not too many samples in a container*)
	filledUpContainers=MapThread[
		Function[
			{availablewells, requiredwells},
			Module[{increasingWells,groupedwells},
				(*For each grouping add the required wells up till they hit the available wells*)
				(*From the earlier example:{10,10,10}->{10,20,10}*)
				increasingWells=FoldList[If[#1 + #2 < availablewells, #1 + #2, #2] &,
					requiredwells];
				(*Find were a new plate starts with this list*)
				(*From the earlier example:{10,20,10}->{1,0,1}->{{1,1},{2}}*)
				groupedwells=Gather[Accumulate[
					(*From the earlier example:{10,20,10}->{1,0,1}*)
					MapThread[If[#1 == #2, 1, 0] &,
					{requiredwells, increasingWells}]
				]]
				]
			],
		{#[[1, 6]] & /@ gatheredmergedContainerOptions, #[[All, 5]] & /@ gatheredmergedContainerOptions}];

	(*use this groupings to regroup the gathered container options {Automatic, Automatic, Automatic}->{{Automatic, Automatic}, {Automatic}}*)
	groupedContainerOptions=TakeList[Flatten[gatheredmergedContainerOptions, 1], Length[#]&/@Flatten[filledUpContainers,1]];

	(*Find the indices of all automatics that need to be changed {1,2,3}*)
	newgroupingindices =
			Which[
				MatchQ[#[[1, 1]], Automatic], #[[All, 4]],
				MatchQ[#[1], Automatic], #[[4]],
				True, Nothing
			] & /@ groupedContainerOptions;

	(*Find the first new index that won't conflict with existing user provided indices *)
	safeIndex=If[MemberQ[dilutionContainerGrouping,_Integer],
		Max[DeleteCases[Flatten[#[[All, 1]] & /@groupedContainerOptions], Automatic | Null]],
		0
	] + 1;

	(*Find the grouping numbers to change these automatics to {1,2}*)
	newgroupings=Range[safeIndex, safeIndex-1 + Length[newgroupingindices]];

	(*Find the rules to change all the automatics {1->1,2->1,3->2}*)
	newGroupingRules=MapThread[
		#1 -> #2 &,
		{
			Flatten[newgroupingindices],
			Flatten[MapThread[ConstantArray[#2, Length[#1]] &, {newgroupingindices, newgroupings}]]
		}
	];

	(*Change all the automatics to the new groupings {1,1,2}*)
	resolveddilutionContainerGrouping=ReplacePart[dilutionContainerGrouping, newGroupingRules];

	(*put the dilution container objects and indices back togeather*)
	resolveddilutionContainer=MapThread[{#1,#2}&,
		{resolveddilutionContainerGrouping,dilutionContainerObjects}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check for a missing surface tension error *)
	missingCalibrantSurfaceTensionInvalidOptions=If[TrueQ[missingCalibrantSurfaceTensionError]&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		(* Throw the corresponding error. *)
		Message[Error::MissingCalibrantSurfaceTension,ObjectToString[resolvedCalibrant, Cache -> simulatedCache]],
		{}
	];

	(* Create the corresponding test for the missing surface tension error. *)
	missingCalibrantSurfaceTensionTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputTest},
			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[missingCalibrantSurfaceTensionInvalidOptions]>0,
				Test["The inputted calibrant, "<>ObjectToString[resolvedCalibrant,Cache->simulatedCache]<>" has a populated SurfaceTension field in its model.:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[missingCalibrantSurfaceTensionInvalidOptions]==0,
				Test["The inputted calibrant, "<>ObjectToString[resolvedCalibrant,Cache->simulatedCache]<>" has a populated SurfaceTension field in its model.:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
{}
];


		(* Check for dilution container errors *)
	dilutionContainerInvalidOptions=If[Or@@dilutionContainerErrors&&!gatherTests,
		Module[{dilutionCurveVolumeInvalidSamples,dilutionContainers,containerVolumes,neededcontainerVolumes},
			(* Get the samples that correspond to this error. *)
			dilutionCurveVolumeInvalidSamples=PickList[simulatedSamples,dilutionContainerErrors];

			(* Get the containers of these samples. *)
			dilutionContainers=PickList[resolveddilutionContainer,dilutionContainerErrors];
			(* Get the volume needed for these containers. *)
			containerVolumes=PickList[First[Lookup[dilutionContainerReplaceRules, #]]&/@resolveddilutionContainer[[All,2]],dilutionContainerErrors];
			(* Get the volume needed for these containers of these samples. *)
			neededcontainerVolumes=PickList[maxvolumes,dilutionContainerErrors];

			(* Throw the corresponding error. *)
			Message[Error::DilutionContainerInsufficientVolume,ToString[dilutionContainers],containerVolumes,neededcontainerVolumes,ObjectToString[dilutionCurveVolumeInvalidSamples,Cache->simulatedCache]];

			(* Return our invalid options. *)
			{DilutionContainer}
		],
		{}
	];

	(* Create the corresponding test for the dilution container error. *)
	dilutionContainerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,dilutionContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The dilution containers, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>" are large enough to dilute the sample:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The dilution containers, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" are large enough to dilute the sample:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for dilution curve volume errors *)
	dilutionCurveVolumeInvalidOptions=If[Or@@dilutionCurveVolumeErrors&&!gatherTests,
		Module[{dilutionCurveVolumeInvalidSamples,serialdilutionVolumes,customdilutionVolumes},
			(* Get the samples that correspond to this error. *)
			dilutionCurveVolumeInvalidSamples=PickList[simulatedSamples,dilutionCurveVolumeErrors];

			(* Get the volumes of these dilutions that are too small. *)
			serialdilutionVolumes=PickList[resolvedserialdilutionCurve,dilutionCurveVolumeErrors];
			customdilutionVolumes=PickList[resolveddilutionCurve,dilutionCurveVolumeErrors];

			(* Throw the corresponding error. *)
			Message[Error::InsufficientDilutionCurveVolume,ToString[customdilutionVolumes],ToString[serialdilutionVolumes],ToString[sampleLoadingVolume],ObjectToString[dilutionCurveVolumeInvalidSamples,Cache->simulatedCache]];

			(* Return our invalid options. *)
			{DilutionCurve}
		],
		{}
	];



	(* Create the corresponding test for the dilution curve volume error. *)
	dilutionCurveVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,dilutionCurveVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The volumes of the following dilutions, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>" are the SampleLoadingVolume or larger:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The volumes of the following dilutions, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" are SampleLoadingVolume  or larger:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check for dilution curve volume warnings *)
	If[Or@@dilutionCurveExcessVolumeWarnings&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Module[{dilutionCurveExcessVolumeSamples,dilutionVolumes},
			(* Get the samples that correspond to this error. *)
			dilutionCurveExcessVolumeSamples=PickList[simulatedSamples,dilutionCurveExcessVolumeWarnings];
			(* Get the volumes of these dilutions that are too small. *)
			dilutionVolumes=PickList[If[MatchQ[Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve],Null],Lookup[roundedMeasureSurfaceTensionOptions,DilutionCurve],Lookup[roundedMeasureSurfaceTensionOptions,SerialDilutionCurve]],dilutionCurveExcessVolumeWarnings];
			(* Throw the corresponding error. *)
			Message[Warning::DilutionCurveExcessVolume,ToString[dilutionVolumes],ToString[sampleLoadingVolume],ObjectToString[dilutionCurveExcessVolumeSamples]]
		]
	];
	(* Create the corresponding test for the dilution curve volume error. *)
	dilutionCurveExcessVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingTest,failingTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,dilutionCurveVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingTest=If[Length[failingInputs]>0,
				Warning["The volumes of the following dilutions, "<>ObjectToString[failingInputs,Cache->simulatedCache]<>" are the SampleLoadingVolume  or larger:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingTest=If[Length[passingInputs]>0,
				Warning["The volumes of the following dilutions, "<>ObjectToString[passingInputs,Cache->simulatedCache]<>" are the SampleLoadingVolume  or larger:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingTest,
				failingTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	hamiltonCompatibleContainers=Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling];


	(*Tell the user if the sample manipulation will can not be done on the liquid handler*)
	incompatibleDilutionContainers= Complement[
		If[MatchQ[#, Null],
			Nothing,
			#[Object]
		]& /@ resolveddilutionContainer[[All, 2]],
		hamiltonCompatibleContainers];


	incompatibleDilutionContainersOptions=If[Length[incompatibleDilutionContainers]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[Error::IncompatableDilutionContainer,ObjectToString[incompatibleDilutionContainers]];
		DilutionContainers,
		Nothing
	];

	(* Create the corresponding test for the container waring. *)
	incompatibleDilutionContainersTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest,failingInputTest},

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[incompatibleDilutionContainers]>0,
				Test["The dilution containers, are compatible with our liquid handler:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[incompatibleDilutionContainers]==0,
				Test["The dilution containers, are compatible with our liquid handler:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* ---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[Model[Part, TensiometerProbe, "DyneProbe"], DeleteCases[Join[simulatedSamples,resolveddiluents,ToList[resolvedCalibrant],ToList[cleaningSolution]],Null], Cache -> simulatedCache, Output -> {Result, Tests}],
		{CompatibleMaterialsQ[Model[Part, TensiometerProbe, "DyneProbe"], DeleteCases[Join[simulatedSamples,resolveddiluents,ToList[resolvedCalibrant],ToList[cleaningSolution]],Null], Cache -> simulatedCache, Messages -> messages], {}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
		Download[mySamples, Object],
		{}
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,compatibleMaterialsInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{missingDiluentInvalidOptions, missingCleaningSolutionInvalidOptions, conflictingDilutionCurveInvalidOptions, missingDilutionContainerInvalidOptions,
		missingCalibrantSurfaceTensionInvalidOptions, dilutionCurveVolumeInvalidOptions,dilutionContainerInvalidOptions, dilutioncontainerStorageInValidOptions,
		 conflictingPreparedPlateDilutionInvalidOptions, invalidAssayPlateOptions, noCalibrantProvidedInvalidOptions, conflictingDilutionMixInvalidOptions, containersOutMismatchInvalidOptions,
    conflictingDilutionContainerInValidOptions, incompatibleDilutionContainersOptions,containerOutStorageInValidOptions}]];


	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
		(* Resolve RequiredAliquotContainers *)
(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

	targetVolumes=Quiet[AchievableResolution[#],{Error::MinimumAmount,Warning::AmountRounded}]&/@(requiredSampleVolumes*1.1);


targetContainers=MapThread[Function[{container,volume},
	If[
		MatchQ[container, ObjectP[hamiltonCompatibleContainers]],
		Null,
		PreferredContainer[volume, LiquidHandlerCompatible -> True]
	]
],
	{simulatedSampleContainers,targetVolumes}
];

{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
	resolveAliquotOptions[
		ExperimentMeasureSurfaceTension,
		Lookup[samplePackets, Object],
		simulatedSamples,
		ReplaceRule[myOptions, resolvedSamplePrepOptions],
		Cache->simulatedCache,
		RequiredAliquotContainers->Download[targetContainers,Object],
		RequiredAliquotAmounts->targetVolumes,
		Output->{Result,Tests}
	],
	{
		resolveAliquotOptions[
			ExperimentMeasureSurfaceTension,
			Lookup[samplePackets, Object],
			simulatedSamples,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			Cache->simulatedCache,
			RequiredAliquotContainers->Download[targetContainers,Object],
			RequiredAliquotAmounts->targetVolumes,
			Output->Result
		],
		{}
	}
];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	resolvedOptions = Flatten[{
		NumberOfReplicates -> numberOfReplicates,
		Instrument->instrument,
		DilutionCurve->resolveddilutionCurve,
		SerialDilutionCurve->resolvedserialdilutionCurve,
		Diluent->resolveddiluents,
		DilutionMixVolume->resolveddilutionMixVolume,
		DilutionNumberOfMixes->resolvednumberOfMixes,
		DilutionMixRate->resolveddilutionMixRate,
		DilutionContainer->resolveddilutionContainer,
		DilutionStorageCondition->resolveddilutionStorageCondition,
		SamplesOutStorageCondition->assayStorageCondition,
		NumberOfCalibrationMeasurements->numberOfCalibrationMeasurements,
		Calibrant->resolvedCalibrant,
		CalibrantSurfaceTension->resolvedcalibrantSurfaceTension,
		MaxCalibrationNoise->maxCalibrationNoise,
		EquilibrationTime->equilibrationTime,
		NumberOfSampleMeasurements->numberOfSampleMeasurements,
		ProbeSpeed->probeSpeed,
		MaxDryNoise->maxDryNoise,
		MaxWetNoise->maxWetNoise,
		PreCleaningMethod->preCleaningMethod,
		CleaningMethod->cleaningMethod,
		CleaningSolution->primaryCleaningSolution,
		SecondaryCleaningSolution->secondaryCleaningSolution,
		TertiaryCleaningSolution->tertiaryCleaningSolution,
		PreheatingTime->preheatingTime,
		BurningTime->burningTime,
		CoolingTime->coolingTime,
		BetweenMeasurementBurningTime->betweenMeasurementBurningTime,
		BetweenMeasurementCoolingTime->betweenMeasurementCoolingTime,
		MaxCleaningNoise->maxCleaningNoise,
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		Confirm -> confirm,
		Name -> name,
		Template -> template,
		Cache -> cache,
		Email -> email,
		FastTrack -> fastTrack,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		Upload -> upload,
		SamplesInStorageCondition -> samplesInStorage,
		SingleSamplePerProbe-> resolvedsingleSamplePerProbe,
		PreparedPlate->preparedPlate,
		SampleLoadingVolume->sampleLoadingVolume,
		ImageDilutionContainers->imageDilutionContainers,
		PreparatoryUnitOperations->preparatoryPrimitives,
		PreparatoryPrimitives->Lookup[roundedMeasureSurfaceTensionOptions,PreparatoryPrimitives],
		ContainerOut->resolvedcontainersOut
	}];


	allTests={
		samplePrepTests,
		aliquotTests,
		discardedTest,
		missingDiluentTest,
		missingDilutionCurveTest,
		missingDilutionMixVolumeTest,
		conflictingDilutionMixVolumeTest,
		missingDilutionNumberofMixesTest,
		missingDilutionMixRateTest,
		calibrantSurfaceTensionMismatchTest,
		missingDilutionContainerTest,
		missingCalibrantSurfaceTensionTest,
		dilutionCurveVolumeTest,
		dilutionCurveExcessVolumeTest,
		dilutionContainerTest,
		missingCleaningMethodTest,
		dilutionContainerStorageTest,
		otherprecisionTests,
		serialDilutionprecisionTests,
		dilutionprecisionTests,
		invalidAssayPlateTest,
		noCalibrantProvidedTest,
		conflictingPreparedPlateDilutionTest,
		conflictingDilutionMixTest,
		multipleAssayPatesTest,
		conflictingCleaningSolutionTest,
		samplesOutMismatchTest,
		conflictingDilutionContainerTest,
		incompatibleDilutionContainersTest,
		containerOutStorageTest
	};

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Flatten[{allTests}]
	}
];

DefineOptions[
	mscResourcePackets,
	Options:>{OutputOption,CacheOption}
];


mstResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[mscResourcePackets]]:=Module[
		{
			outputSpecification,output,gatherTests,messages,inheritedCache,numReplicates, samplesInStorage,assayPlates,measurementPlates,
			expandedSamplesWithNumReplicates,pairedSamplesInAndVolumes,sampleVolumeRules, cleaningSolutionVolume, recoveryResources,
			sampleResourceReplaceRules,samplesInResources,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
			allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,requiredSampleVolumes,requiredDiluentVolumes,requiredCalibrantVolumes,requiredRows,
			requirednumberOfPlates,expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,liquidHandlerContainers,pairedDiluentsAndVolumes, serialdilutionCurves,
			dilutionCurves, diluents, calibrant, diluentVolumeRules,requiredCleaningSolutionVolume, calibrantVolumeRule, sampleDownload,
			cleanerVolumeRule, allVolumeRules, uniqueResources,listedSampleContainers,liquidHandlerContainerDownload, sampleContainersIn, liquidHandlerContainerMaxVolumes,
			uniqueObjectResourceReplaceRules, uniqueObjects, diluentResources, calibrantResource,cleaningsolutionResource,  dilutioncontainers,
			requiredWells, measurementPlateResources, maxvolumes,optionsWithReplicates,singleSamplePerProbe, imageDilutionContainers, containersOut,
			dilutionMixVolumes,dilutionNumberOfMixes, dilutionMixRates,calibrantSurfaceTension, cleaningSolutionContainerResource, solutionRows, requirednumberOfContainersOut, containersOutWells,
			numberOfCalibrationMeasurements, maxCalibrationNoise, equilibrationTime, numberOfSampleMeasurements, preparedPlate, sampleWells,cleaningsolution1,cleaningsolution2,cleaningsolution3,
			probeSpeed, maxDryNoise, maxWetNoise, preCleaningMethod, downloadedDilutionContainerFields, assayStorageConditions, dilutionStorageConditions, lidResources,
			cleaningMethod, preheatingTime, burningTime, coolingTime, uniqueDilutionContainersObjects, dilutionContainerReplaceRules, cleaningsolution, sampleLoadingVolume,
			maxCleaningNoise, betweenMeasurementBurningTime, betweenMeasurementCoolingTime, serialDilutionCurveVolumes, dilutionCurveVolumes, dilutionContainer,
			dilutionContainerResources, uniqueDilutionContainerResources, dilutionContainerRules, numberOfDilutionWells, availableDilutionWells,
			dilutionContainerObjects, requiredContainerNumbers, expandeddilutionContainerRules, olduniqueDilutionContainerResources,oldDilutionContainerResources,
			dilutionContainerIndices, availabledilutionWellsrules, dilutionWellsrules
		},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureSurfaceTension, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMeasureSurfaceTension,
		RemoveHiddenOptions[ExperimentMeasureSurfaceTension,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[myResolvedOptions, Cache];

	(* Pull out the number of replicates; make sure all Nulls become 1 *)
	numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
	(* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
	liquidHandlerContainers=Experiment`Private`hamiltonAliquotContainers["Memoization"];

	(*Look at the dilution containers given by the user*)
	dilutioncontainers= ToList[Lookup[myResolvedOptions,DilutionContainer]][[All,2]];

	(*Look at the containers out given by the user*)
	containersOut= Lookup[myResolvedOptions,ContainerOut];

	(* Expand the samples according to the number of replicates *)
	{expandedSamplesWithNumReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentMeasureSurfaceTension,mySamples,expandedResolvedOptions];

	uniqueDilutionContainersObjects=DeleteDuplicates[Cases[Join[dilutioncontainers,{containersOut}],ObjectP[]]];

	(* Make a Download call to get the containers of the input samples *)
	{sampleDownload,liquidHandlerContainerDownload, downloadedDilutionContainerFields}=Quiet[
		Download[
			{
				mySamples,
				liquidHandlerContainers,
				uniqueDilutionContainersObjects
			},
			{
				{Container[Object],Well},
				{MaxVolume},
				{MaxVolume,NumberOfWells}
			},
			Cache->inheritedCache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	listedSampleContainers=sampleDownload[[All,1]];
	sampleWells=sampleDownload[[All,2]];


	(*Some of the containers will by vessels with no NumberOfWellsFields*)
	dilutionContainerReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueDilutionContainersObjects, Replace[downloadedDilutionContainerFields, $Failed -> 1, {2}]}
	];

	(* Find the list of input sample and antibody containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* Pull out relevant options from the re-expanded options *)
	{
		serialdilutionCurves,dilutionCurves,calibrant,diluents,singleSamplePerProbe,dilutionMixVolumes,dilutionNumberOfMixes, dilutionMixRates,
		assayStorageConditions, dilutionStorageConditions, calibrantSurfaceTension,
		numberOfCalibrationMeasurements, maxCalibrationNoise, equilibrationTime, numberOfSampleMeasurements,
		probeSpeed, maxDryNoise, maxWetNoise, preCleaningMethod,
		cleaningMethod, preheatingTime, burningTime, coolingTime,
		maxCleaningNoise, betweenMeasurementBurningTime, betweenMeasurementCoolingTime, dilutionContainer, cleaningsolution1,cleaningsolution2,cleaningsolution3,preparedPlate,
		sampleLoadingVolume, imageDilutionContainers, samplesInStorage
	}=
			Lookup[optionsWithReplicates,
				{
					SerialDilutionCurve,DilutionCurve,Calibrant,Diluent,SingleSamplePerProbe,DilutionMixVolume, DilutionNumberOfMixes, DilutionMixRate,
					SamplesOutStorageCondition, DilutionStorageCondition, CalibrantSurfaceTension,
					NumberOfCalibrationMeasurements, MaxCalibrationNoise, EquilibrationTime, NumberOfSampleMeasurements,
					ProbeSpeed, MaxDryNoise, MaxWetNoise, PreCleaningMethod,
					CleaningMethod, PreheatingTime, BurningTime, CoolingTime,
					MaxCleaningNoise, BetweenMeasurementBurningTime, BetweenMeasurementCoolingTime, DilutionContainer, CleaningSolution,SecondaryCleaningSolution,TertiaryCleaningSolution,PreparedPlate,
					SampleLoadingVolume, ImageDilutionContainers, SamplesInStorageCondition
				},
				Null
			];

	cleaningsolution={cleaningsolution1,cleaningsolution2,cleaningsolution3};
	(* --- Make all the resources needed in the experiment --- *)
	(* Set up a Mapthread to determine required volumes and other resources like containers*)
	{requiredSampleVolumes,requiredDiluentVolumes,requiredWells,requiredRows,maxvolumes}=
     Transpose[MapThread[Function[{serialdilutionCurve,dilutionCurve, diluent},
		Module[{requiredSampleVolume,requiredDiluentVolume,requiredWell,requiredRow,maxvolume},
			(*Determine the liquid volumes needed *)
			{requiredSampleVolume,requiredDiluentVolume}=Which[
				(*Is a serial Dilution specified?*)
				MatchQ[serialdilutionCurve,Except[Null]], {
						(*the first curve volume*)
						First[First[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]],
						(*all the diluent volumes used for mixing*)
						Total[Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]]
						(* the number of calibrants needed will depend on the number of rows taken up*)
					},
				(*Is a custom Dilution specified?*)
				MatchQ[dilutionCurve,Except[Null]],{
						(*all the sample volumes added togeather*)
						Total[First[calculatedDilutionCurveVolumes2[dilutionCurve]]],
						(*all the diluent volumes added togeather*)
						Total[Last[calculatedDilutionCurveVolumes2[dilutionCurve]]]
					},
				(*Is the plate prepared*)
				preparedPlate, {0Microliter,0Microliter},
				(*Is there no diluting*)
				True,{sampleLoadingVolume,0Microliter}
			];
			{requiredWell,requiredRow,maxvolume}=Which[
				(*Is a serial Dilution specified?*)
				MatchQ[serialdilutionCurve,Except[Null]],{
						(*wells taken up by the curve excluding the calibrant*)
						Length[Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]],
						(*rows taken up by the curve*)
						(Ceiling[(Length[Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]])/11]),
						(*the transfer volume plus the diluent volume*)
						Max[First[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]+Last[calculatedDilutionCurveVolumes2[serialdilutionCurve,!MatchQ[calibrant, ObjectP[diluent]]]]]
					},
				(*Is a custom Dilution specified?*)
				MatchQ[dilutionCurve,Except[Null]],{
						(*length of the curve*)
						Length[dilutionCurve],
						(*rows taken up by the curve*)
						Ceiling[Length[dilutionCurve]/11],
						(*largest sample volume*)
						Max[First[calculatedDilutionCurveVolumes2[dilutionCurve]]+Last[calculatedDilutionCurveVolumes2[dilutionCurve]]]
					},
				(*Is the plate prepared*)
				preparedPlate, {1,1,0 Microliter},
				(*Is there no diluting*)
				True,{1,1,sampleLoadingVolume}
			];
			{requiredSampleVolume,requiredDiluentVolume,requiredWell,requiredRow,maxvolume}
		]
	],
		{serialdilutionCurves,dilutionCurves, diluents}
	]];

		(* plates needed by getting the total number of rows used, there are 8 rows per plate*)
	requirednumberOfPlates=If[preparedPlate,
		0,
		If[singleSamplePerProbe,Ceiling[Total[requiredRows]/8],Ceiling[Total[requiredWells]/88]]
	];

	(*Look at the dilution containers given by the user*)
	dilutionContainerRules= Association[
		Map[First[#]->Last[#]&,dilutionContainer]
	];

	(*check to see how many containers are needed for each container. Multiple dilution containers may be needed especially for vessels *)

	(*get how many dilution wells are needed for the dilution of the sample*)
	numberOfDilutionWells=MapThread[
		Which[
			(*Is a serial Dilution specified?*)
			MatchQ[#1,Except[Null]], Length[First[calculatedDilutionCurveVolumes2[#1,!MatchQ[calibrant, ObjectP[#3]]]]],
			(*Is a custom Dilution specified?*)
			MatchQ[#2,Except[Null]], Length[First[calculatedDilutionCurveVolumes2[#2]]],
			True,0
		]&,
		{serialdilutionCurves,dilutionCurves,diluents}
	];

	dilutionContainerIndices=dilutionContainer[[All,1]];

	dilutionContainerObjects=dilutionContainer[[All,2]];

	dilutionWellsrules = Merge[
	MapThread[
		#1 -> #2 &,
		{dilutionContainerIndices, numberOfDilutionWells}],
	Total];

	(*check how many wells are in the dilution containers*)
	availableDilutionWells=If[MatchQ[Lookup[dilutionContainerReplaceRules,#][[2]],Null],
		0,
		Lookup[dilutionContainerReplaceRules,#][[2]]
	]&/@dilutionContainerObjects;

	availabledilutionWellsrules = DeleteDuplicates[MapThread[
		#1 -> #2 &,
		{dilutionContainerIndices, availableDilutionWells}]
	];

	uniqueDilutionContainerResources=If[MatchQ[dilutionContainerRules,<||>],
		{Null},
		MapThread[
		Function[{key, cont, needed, available},
			key ->If[
				MatchQ[needed, 0],
				Null,
				(Link[Resource[Sample -> #, Name -> ToString[Unique[]]]] & /@ Table[cont, Ceiling[needed/available]])
			]
		],
		{Keys[dilutionContainerRules], Values[dilutionContainerRules], Values[dilutionWellsrules],Values[availabledilutionWellsrules]}]
		];


	(* - Use this association to make Resources for each unique Object or Model Key - *)
	dilutionContainerResources =If[MatchQ[dilutionContainerRules,<||>],
		{Null},
		Replace[#,uniqueDilutionContainerResources]&/@ dilutionContainer[[All,1]]
	];

	(*If prepared plate, check what rows are occupied to see what cleaning wells need to be filled.*)
	solutionRows=If[preparedPlate,DeleteDuplicates[StringTake[#, 1] & /@ sampleWells],Nothing];

	(* Cleaning solution needed *)
	cleaningSolutionVolume=If[
		(*if any is needed*)
		Or[MemberQ[ToList[Lookup[myResolvedOptions,PreCleaningMethod]],Solution],MemberQ[ToList[Lookup[myResolvedOptions,CleaningMethod]],Solution]],
			Which[preparedPlate,
		(*If a prepared plate is given*)
		Map[If[MemberQ[solutionRows, #], {cleaningsolution[[1]]->1.4*Milliliter,cleaningsolution[[2]]->1.4*Milliliter,cleaningsolution[[3]]->1.4*Milliliter}, Null->0*Milliliter]&, Flatten[ConstantArray[{"A", "B", "C", "D", "E", "F", "G", "H"},Length[sampleContainersIn]]]],
		(*If a non prepared plate is given with no probe sharing*)
		singleSamplePerProbe,
		Flatten[Map[
			ConstantArray[{cleaningsolution[[1]]->1.4*Milliliter,cleaningsolution[[2]]->1.4*Milliliter,cleaningsolution[[3]]->1.4*Milliliter},#]&,requiredRows
		],1],
		(*probe sharing*)
		True,
		ConstantArray[{cleaningsolution[[1]]->1.4*Milliliter,cleaningsolution[[2]]->1.4*Milliliter,cleaningsolution[[3]]->1.4*Milliliter},Ceiling[Total[requiredWells]/11]]
			],
		{{Null->0Microliter,Null->0Microliter,Null->0Microliter}}];

	(*only take the first 8 because there are 8 probes and the solution can be reused between plates*)
	requiredCleaningSolutionVolume=Take[cleaningSolutionVolume,UpTo[8]];

	(* -- Generate resources for the SamplesIn -- *)
	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		#1 -> SafeRound[#2*1.1,1 Microliter]&,
		{expandedSamplesWithNumReplicates, requiredSampleVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
			]
		],
		sampleVolumeRules
	];

		(* Use the replace rules to get the sample resources *)
		samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* -- Generate resources for the Diluents, Calibrants and Cleaning solution -- *)
	(* Pair the diluents and their Volumes *)
	pairedDiluentsAndVolumes = MapThread[
		#1 -> SafeRound[#2*1.1,10^-1 Microliter]&,
		{diluents, requiredDiluentVolumes}
	];

	(* Merge the diluent volumes together to get the total volume of each sample's resource *)
	diluentVolumeRules = Merge[pairedDiluentsAndVolumes, Total];

	requiredCalibrantVolumes=If[
		preparedPlate,
		0*Microliter,
		requirednumberOfPlates*8*270*Microliter
	];

	(*Pair the calibrant and its volumes*)
	calibrantVolumeRule=Association[{calibrant->requiredCalibrantVolumes}];

	(*Pair the cleaning solution and its volume*)
	cleanerVolumeRule=Merge[requiredCleaningSolutionVolume, Total];


	(* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
	allVolumeRules=DeleteCases[KeyDrop[
		Merge[{diluentVolumeRules,calibrantVolumeRule,cleanerVolumeRule},Total],
		Null],
		0*Microliter
	];

	(* - Use this association to make Resources for each unique Object or Model Key - *)
	uniqueResources= KeyValueMap[
			Module[{amount,containers},
				(*If it is in a tray it needs a 30ml dead volume*)
				amount=If[MatchQ[#2,GreaterP[50Milliliter]],#2+30Milliliter,#2];
				containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
				Link[Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[Unique[]]]]
			]&,
			allVolumeRules
	];

	(* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique Object/Model Keys - *)
	uniqueObjects=Keys[allVolumeRules];

	(* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
	uniqueObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueObjects,uniqueResources}
	];

	(* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{
		diluentResources
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
		{
			diluents
		}
	];

	(* - For the options that are single objects, Map over replacing the option with the replace rules to get the corresponding resources - *)
	calibrantResource=If[preparedPlate,
		(Resource[Sample->#]&)/@calibrant,
		Replace[calibrant,uniqueObjectResourceReplaceRules]
	];

	cleaningsolutionResource= First[
		Map[If[KeyMemberQ[uniqueObjectResourceReplaceRules,#],
		Replace[#,uniqueObjectResourceReplaceRules],
		Null
	]&,Keys[requiredCleaningSolutionVolume],{2}]
		];



	cleaningSolutionContainerResource=If[!MatchQ[cleaningsolutionResource,{Null,Null,Null}],
		Link[Resource[
			Name -> ToString[Unique[]],
			Sample->Model[Container, Plate, "id:eGakldJ5M44n"],
			Rent->True
			]
		],
		Null
	];


	measurementPlates=ConstantArray[Model[Container, Plate, "id:8qZ1VW06z9Zp"],requirednumberOfPlates];

	measurementPlateResources=Link@Resource[Sample->#,Name -> ToString[Unique[]]]&/@measurementPlates;

	assayPlates=If[preparedPlate,Link[DeleteDuplicates[sampleContainersIn]],measurementPlateResources];

	containersOutWells=If[MatchQ[Lookup[dilutionContainerReplaceRules,containersOut][[2]],$Failed],
		1,
		Lookup[dilutionContainerReplaceRules,containersOut][[2]]
	];

	(* plates needed by getting the total number of rows used, there are 8 rows per plate*)
	requirednumberOfContainersOut=If[MatchQ[containersOutWells,96],
		(*96 well plate, preserve plate order*)
		If[preparedPlate,
			Length[DeleteDuplicates[sampleContainersIn]],
			If[singleSamplePerProbe,Ceiling[Total[requiredRows]/8],Ceiling[Total[requiredWells]/88]]
		],
		(*else, fit in efficiently*)
		If[containersOutWells>0,Ceiling[Total[requiredWells]/containersOutWells],Nothing]
	];


	recoveryResources=If[MatchQ[containersOut,Null],
		{},
		Link@Resource[Sample->#,Name -> ToString[Unique[]]]&/@ConstantArray[containersOut,requirednumberOfContainersOut]
	];

	lidResources=Link@Resource[Sample->#,Name -> ToString[Unique[]]]&/@ConstantArray[Model[Item,Lid,"Universal Black Lid"],Length[assayPlates]];


	(* -- Generate instrument resources -- *)
	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	instrumentTime = (10*Minute+If[MatchQ[ToList[cleaningMethod],{Null}],0Minute,10Minute])*requirednumberOfPlates+10*Minute;
	instrumentResource= Link[Resource[Instrument -> Lookup[myResolvedOptions,Instrument], Time -> instrumentTime, Name -> ToString[Unique[]]]];

	dilutionCurveVolumes=If[
		MatchQ[#,Null],
		Null,
		Transpose[calculatedDilutionCurveVolumes2[#]]
	]&/@dilutionCurves;

	serialDilutionCurveVolumes=MapThread[
		 If[
			MatchQ[#1,Null],
			Null,
			Transpose[calculatedDilutionCurveVolumes2[#1,!MatchQ[calibrant, ObjectP[#2]]]]
		]&,
		{serialdilutionCurves,diluents}
];


	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Type -> Object[Protocol,MeasureSurfaceTension],
		Object -> CreateID[Object[Protocol,MeasureSurfaceTension]],
		Replace[SamplesIn] -> (Link[#,Protocols]&/@samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[sampleContainersIn],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> myResolvedOptions,
		NumberOfReplicates -> numReplicates,
		Instrument -> instrumentResource,
		Replace[Checkpoints] -> {
			{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
			{"Preparing Plate",2*Hour,"The measurement plates are loaded with the diluted samples and calibrants.",Null},
			{"Acquiring Data",instrumentTime,"The surface tensions of the samples in the plate are acquired.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> instrumentTime]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1*Hour]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10*Minute]]}
		},
		Replace[AssayPlates]->If[preparedPlate,Null,assayPlates],
		Replace[AssayPlateLids]->lidResources,
		Replace[DilutionContainers]->Flatten[dilutionContainerResources,1],
		Replace[SampleAmounts]->requiredSampleVolumes,
		Replace[CalibrantVolume]->requiredCalibrantVolumes,
		Replace[Calibrant]->ToList@calibrantResource,
		Replace[CleaningSolutions]->cleaningsolutionResource,
		CleaningSolutionContainer->cleaningSolutionContainerResource,
		Replace[CleaningSolutionPlacements]->If[MatchQ[cleaningSolutionContainerResource,Null],Null,{{cleaningSolutionContainerResource,{"Wash Tray Slot"}}}],
		Replace[Diluents]->diluentResources,
		Replace[DilutionMixVolumes]->dilutionMixVolumes,
		Replace[DilutionNumberOfMixes]->dilutionNumberOfMixes,
		Replace[DilutionMixRates]->dilutionMixRates,
		Replace[Dilutions]->dilutionCurveVolumes,
		Replace[SerialDilutions]->serialDilutionCurveVolumes,
		Replace[SamplesOutStorage]->ConstantArray[First[assayStorageConditions],Length[recoveryResources]],
		Replace[DilutionStorageConditions]->Flatten[MapThread[If[MatchQ[#1, Null], Null, Table[#2,Length[#1]]] &, {dilutionContainerResources, dilutionStorageConditions}],1], (*makes sure the storage is Null if the container is Null *)
		CalibrantSurfaceTension->calibrantSurfaceTension,
		NumberOfCalibrationMeasurements->numberOfCalibrationMeasurements,
		MaxCalibrationNoise->maxCalibrationNoise,
		EquilibrationTime->equilibrationTime,
		NumberOfSampleMeasurements->numberOfSampleMeasurements,
		ProbeSpeed->probeSpeed,
		MaxDryNoise->maxDryNoise,
		MaxWetNoise->maxWetNoise,
		Replace[PreCleaningMethod]->ToList[preCleaningMethod],
		Replace[CleaningMethod]->ToList[cleaningMethod],
		PreheatingTime->preheatingTime,
		BurningTime->burningTime,
		CoolingTime->coolingTime,
		MaxCleaningNoise->maxCleaningNoise,
		BetweenMeasurementBurningTime->betweenMeasurementBurningTime,
		BetweenMeasurementCoolingTime->betweenMeasurementCoolingTime,
		SingleSamplePerProbe->singleSamplePerProbe,
		SampleLoadingVolume->sampleLoadingVolume,
		PreparedPlate->preparedPlate,
		ImageDilutionContainers->imageDilutionContainers,
		Replace[ContainersOut]->recoveryResources,
		Replace[SamplesInStorage] -> samplesInStorage,
		Operator -> Link[Lookup[myResolvedOptions, Operator]],
		Name -> Lookup[myResolvedOptions, Name],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->inheritedCache], Null}
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
	outputSpecification /. {resultRule, testsRule}
];
(* ::Subsection::Closed:: *)
(*ExperimentMeasureSurfaceTensionPreview*)

(* ::Subsubsection:: *)
(*ExperimentMeasureSurfaceTensionPreview*)


DefineOptions[ExperimentMeasureSurfaceTensionPreview,
SharedOptions :> {ExperimentMeasureSurfaceTension}
];

Authors[ExperimentMeasureSurfaceTensionPreview] := {"waseem.vali", "malav.desai", "cgullekson"};

(* --- Core Function --- *)
ExperimentMeasureSurfaceTensionPreview[myObjects:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[Object[Sample]]|_String)],myOptions:OptionsPattern[]]:=Module[
{listedOptions, noOutputOptions},

(* get the options as a list *)
listedOptions = ToList[myOptions];

(* remove the Output option before passing to the core function because it doens't make sense here *)
noOutputOptions = DeleteCases[listedOptions, Output -> _];

(* return only the preview for ExperimentMeasureSurfaceTension *)
ExperimentMeasureSurfaceTension[myObjects, Append[noOutputOptions, Output -> Preview]]
];

(* ::Subsection::Closed:: *)
(*ExperimentMeasureSurfaceTensionOptions*)

(* ::Subsubsection:: *)
(*ExperimentMeasureSurfaceTensionOptions*)

DefineOptions[ExperimentMeasureSurfaceTensionOptions,
Options:>{
  {
    OptionName -> OutputFormat,
    Default -> Table,
    AllowNull -> False,
    Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
    Description -> "Determines whether the function returns a table or a list of the options.",
    Category->"Protocol"
  }
},
SharedOptions :> {ExperimentMeasureSurfaceTension}
];

Authors[ExperimentMeasureSurfaceTensionOptions] := {"waseem.vali", "malav.desai", "cgullekson"};

ExperimentMeasureSurfaceTensionOptions[myObjects:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[Object[Sample]]|_String)],myOptions:OptionsPattern[]]:=Module[
{listedOptions, noOutputOptions, options},

(* get the options as a list *)
listedOptions = ToList[myOptions];

(* remove the Output option before passing to the core function because it doens't make sense here *)
noOutputOptions = DeleteCases[listedOptions, (Output -> _) | (OutputFormat->_)];

(* return only the preview for ExperimentMeasureSurfaceTension *)
options = ExperimentMeasureSurfaceTension[myObjects, Append[noOutputOptions, Output -> Options]];

(* If options fail, return failure *)
If[MatchQ[options,$Failed],
  Return[$Failed]
];

(* Return the option as a list or table *)
If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
  LegacySLL`Private`optionsToTable[options,ExperimentMeasureSurfaceTension],
  options
]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureSurfaceTensionQ*)

(* ::Subsubsection:: *)
(*ValidExperimentMeasureSurfaceTensionQ*)


DefineOptions[ValidExperimentMeasureSurfaceTensionQ,
Options :> {
  VerboseOption,
  OutputFormatOption
},
SharedOptions :> {ExperimentMeasureSurfaceTension}
];

Authors[ValidExperimentMeasureSurfaceTensionQ] := {"waseem.vali", "malav.desai", "cgullekson"};

(* --- Overloads --- *)

ValidExperimentMeasureSurfaceTensionQ[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentMeasureSurfaceTensionQ]] := ValidExperimentMeasureSurfaceTensionQ[{myContainer}, myOptions];

ValidExperimentMeasureSurfaceTensionQ[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ValidExperimentMeasureSurfaceTensionQ]] := Module[
{listedOptions, preparedOptions, mstTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
listedOptions = ToList[myOptions];

(* remove the Output option before passing to the core function because it doens't make sense here *)
preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

(* return only the tests for ExperimentMeasureSurfaceTension *)
mstTests = ExperimentMeasureSurfaceTension[myContainers, Append[preparedOptions, Output -> Tests]];

(* define the general test description *)
initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

(* make a list of all the tests, including the blanket test *)
allTests = If[MatchQ[mstTests, $Failed],
  {Test[initialTestDescription, False, True]},
  Module[
    {initialTest, validObjectBooleans, voqWarnings},

    (* generate the initial test, which we know will pass if we got this far (?) *)
    initialTest = Test[initialTestDescription, True, True];

    (* create warnings for invalid objects *)
    validObjectBooleans = ValidObjectQ[Download[DeleteCases[myContainers, _String], Object,Date->Now], OutputFormat -> Boolean];
    voqWarnings = MapThread[
      Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
        #2,
        True
      ]&,
      {Download[DeleteCases[myContainers, _String], Object,Date->Now], validObjectBooleans}
    ];

    (* get all the tests/warnings *)
    Flatten[{initialTest, mstTests, voqWarnings}]
  ]
];

(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureSurfaceTensionQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

(* run all the tests as requested *)
Lookup[RunUnitTest[<|"ValidExperimentMeasureSurfaceTensionQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureSurfaceTensionQ"]

];


ValidExperimentMeasureSurfaceTensionQ[myObject:(ObjectP[Object[Sample]]|_String),myOptions:OptionsPattern[]]:=ValidExperimentMeasureSurfaceTensionQ[{myObject},myOptions];

ValidExperimentMeasureSurfaceTensionQ[myObjects:{(ObjectP[Object[Sample]]|_String)...},myOptions:OptionsPattern[]]:=Module[
{listedOptions,preparedOptions,measuresurfacetensionTests,validObjectBooleans,voqWarnings,
  allTests,verbose,outputFormat},

(* get the options as a list *)
listedOptions = ToList[myOptions];

(* remove the Output option before passing to the core function because it doens't make sense here *)
preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

(* return only the tests for ExperimentMeasureSurfaceTension *)
measuresurfacetensionTests = ExperimentMeasureSurfaceTension[myObjects, Append[preparedOptions, Output -> Tests]];

(* Create warnings for invalid objects *)
validObjectBooleans = ValidObjectQ[DeleteCases[myObjects,_String], OutputFormat -> Boolean];
voqWarnings = MapThread[
  Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
    #2,
    True
  ]&,
  {DeleteCases[myObjects,_String], validObjectBooleans}
];

(* Make a list of all the tests *)
allTests = Join[measuresurfacetensionTests,voqWarnings];

(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureSurfaceTensionQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

(* run all the tests as requested *)
Lookup[RunUnitTest[<|"ValidExperimentMeasureSurfaceTensionQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureSurfaceTensionQ"]
];

(* ::Subsubsection::Closed:: *)
(* calculatedDilutionCurveVolumes *)
(*Find the series of transfer volumes and diluent volumes needed to create the serial dilution curves*)
(*for non constant dilution factors*)
calculatedDilutionCurveVolumes[myCurve : {VolumeP, {RangeP[0, 1] ..}}] :=
  Module[{transferVolumes, diluentVolumes, sampleVolume,
    dilutionFactorCurve, lastTransferVolume, recTransferVolumeFunction},
    (*Get the volume each sample fave after the transfers*)
    sampleVolume = First[myCurve];
    (*Get the list of dilution factors*)
    dilutionFactorCurve = Last[myCurve];
    (*Calculate the last transfer volume performed DilutionFactors=transferIn/Totalvolume*)
    lastTransferVolume = SafeRound[Last[dilutionFactorCurve]*sampleVolume,10^-1 Microliter];
    (*Calculate the rest of the transfers with recursion TotalVolume=TransferIn+Diluent-transferOut, Dilutionfactor=transferin/(tranferIn+diluent)*)
    recTransferVolumeFunction[{_Real | _Integer}] :=
        {lastTransferVolume};
    recTransferVolumeFunction[factorList_List] := Join[
      {SafeRound[First[factorList]*(sampleVolume + First[recTransferVolumeFunction[Rest[factorList]]]),10^-1 Microliter]},
      recTransferVolumeFunction[Rest[factorList]]
    ];
    transferVolumes = recTransferVolumeFunction[dilutionFactorCurve];
    (*calculate the corresponding diluent volumes, DilutionFactors=transferIn/(transferIn + diluent*)
    diluentVolumes =
        SafeRound[
          MapThread[
            If[MatchQ[#1, 0],
              sampleVolume,
              #2*(1 - #1)/#1] &,
            {dilutionFactorCurve, transferVolumes}
          ],
          10^-1 Microliter];
    (*return the transfer volumes and diluentvolumes*)
    {transferVolumes, diluentVolumes}
  ];

(*constant dilution factors, this could be an overload to the function above, but it is computationally faster to use this function*)
calculatedDilutionCurveVolumes[myCurve : {VolumeP, {RangeP[0, 1], GreaterP[1, 1]}}] :=
  Module[{sampleVolume, dilutionFactor, dilutionNumber, transferVolumes, diluentVolumes},
    (*Get the final volume after transfers*)
    sampleVolume = First[myCurve];
    (*Get the dilution volume*)
    dilutionFactor = First[Last[myCurve]];
    (*Get the number of dilutions*)
    dilutionNumber = Last[Last[myCurve]];
    (*Get the transfer volume, DilutionFactor=transferin/(transferin+
    diluent), sampleVolume=transferin+dilunent-transfer out=diluent*)
    transferVolumes = If[MatchQ[dilutionFactor, 1],
      Reverse[Table[sampleVolume + i*sampleVolume, {i, dilutionNumber}]],
      ConstantArray[
        SafeRound[
          dilutionFactor*sampleVolume/(1 - dilutionFactor),
          10^-1 Microliter]
        , dilutionNumber]
    ];
    diluentVolumes = If[MatchQ[dilutionFactor, 1],
      ConstantArray[0 Microliter, dilutionNumber],
      ConstantArray[sampleVolume, dilutionNumber]
    ];
    (*return the transfer volumes and diluentvolumes*)
    {transferVolumes, diluentVolumes}
  ];

(*for constant dilution volumes*)
calculatedDilutionCurveVolumes[myCurve : {VolumeP, VolumeP, GreaterP[1, 1]}] :=
  Module[{transferVolumes, diluentVolumes},
    (*make arrays of all the volumes*)
    transferVolumes = ConstantArray[First[myCurve], Last[myCurve]];
    diluentVolumes = ConstantArray[myCurve[[2]], Last[myCurve]];
    (*return the transfer volumes and diluentvolumes*)
    {transferVolumes, diluentVolumes}
  ];

(*for a non-serial dilution with volumes given*)
calculatedDilutionCurveVolumes[myCurve : {{VolumeP, VolumeP}...}] :=
  Module[{sampleVolumes, diluentVolumes},
    (*make arrays of all the volumes*)
    sampleVolumes = First[#]&/@myCurve;
    diluentVolumes = Last[#]&/@myCurve;
    (*return the transfer volumes and diluentvolumes*)
    {sampleVolumes, diluentVolumes}
  ];

(*for a non-serial dilution with dilution factors given*)
calculatedDilutionCurveVolumes[myCurve : {{VolumeP, RangeP[0,1]}...}] :=
  Module[{sampleVolumes, diluentVolumes},
    (*make arrays of all the volumes*)
    (*DF=sample /sample +diluent, Volume=sample+diluent*)
    sampleVolumes = SafeRound[First[#]*Last[#],10^-1 Microliter]&/@myCurve;
    diluentVolumes = SafeRound[First[#]*(1 - Last[#]), 10^-1 Microliter] & /@ myCurve;
    (*return the transfer volumes and diluentvolumes*)
    {sampleVolumes, diluentVolumes}
  ];

calculatedDilutionCurveVolumes[Null] :={Null,Null};

(* ::Subsubsection::Closed:: *)
(* calculatedDilutionCurveVolumes2 *)
(*Find the series of transfer volumes and diluent volumes needed to create the serial dilution curves with a pure sample included in serialdilutions*)
(*for non constant dilution factors*)
calculatedDilutionCurveVolumes2[myCurve : {VolumeP, {RangeP[0, 1] ..}},extraDiluent:BooleanP] :=
	Module[{transferVolumes, diluentVolumes, sampleVolume,
		dilutionFactorCurve, lastTransferVolume, recTransferVolumeFunction},
		(*Get the volume each sample fave after the transfers*)
		sampleVolume = First[myCurve];
		(*Get the list of dilution factors*)
		dilutionFactorCurve = Last[myCurve];
		(*Calculate the last transfer volume performed DilutionFactors=transferIn/Totalvolume*)
		lastTransferVolume = SafeRound[Last[dilutionFactorCurve]*sampleVolume,10^-1 Microliter];
		(*Calculate the rest of the transfers with recursion TotalVolume=TransferIn+Diluent-transferOut, Dilutionfactor=transferin/(tranferIn+diluent)*)
		recTransferVolumeFunction[{_Real | _Integer}] :=
			{lastTransferVolume};
		recTransferVolumeFunction[factorList_List] := Join[
			{SafeRound[First[factorList]*(sampleVolume + First[recTransferVolumeFunction[Rest[factorList]]]),10^-1 Microliter]},
			recTransferVolumeFunction[Rest[factorList]]
		];
		transferVolumes = recTransferVolumeFunction[dilutionFactorCurve];
		(*calculate the corresponding diluent volumes, DilutionFactors=transferIn/(transferIn + diluent*)
		diluentVolumes =
			SafeRound[
				MapThread[
					If[MatchQ[#1, 0],
						sampleVolume,
						#2*(1 - #1)/#1] &,
					{dilutionFactorCurve, transferVolumes}
				],
				10^-1 Microliter];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{sampleVolume+First[transferVolumes]},transferVolumes,If[extraDiluent,{0Microliter},{}]],
			Join[{0 Microliter},diluentVolumes,If[extraDiluent,{sampleVolume},{}]]
		}
	];

(*constant dilution factors, this could be an overload to the function above, but it is computationally faster to use this function*)
calculatedDilutionCurveVolumes2[myCurve : {VolumeP, {RangeP[0, 1], GreaterP[1, 1]}},extraDiluent:BooleanP] :=
	Module[{sampleVolume, dilutionFactor, dilutionNumber, transferVolumes, diluentVolumes},
		(*Get the final volume after transfers*)
		sampleVolume = First[myCurve];
		(*Get the dilution volume*)
		dilutionFactor = First[Last[myCurve]];
		(*Get the number of dilutions*)
		dilutionNumber = Last[Last[myCurve]];
		(*Get the transfer volume, DilutionFactor=transferin/(transferin+
		diluent), sampleVolume=transferin+dilunent-transfer out=diluent*)
		transferVolumes = If[MatchQ[dilutionFactor, 1],
			Reverse[Table[sampleVolume + i*sampleVolume, {i, dilutionNumber}]],
			ConstantArray[
				SafeRound[
					dilutionFactor*sampleVolume/(1 - dilutionFactor),
					10^-1 Microliter]
				, dilutionNumber]
		];
		diluentVolumes = If[MatchQ[dilutionFactor, 1],
			ConstantArray[0 Microliter, dilutionNumber],
			ConstantArray[sampleVolume, dilutionNumber]
		];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{sampleVolume+First[transferVolumes]},transferVolumes,If[extraDiluent,{0 Microliter},{}]],
			Join[{0 Microliter},diluentVolumes,If[extraDiluent,{sampleVolume},{}]]
		}
	];

(*for constant dilution volumes*)
calculatedDilutionCurveVolumes2[myCurve : {VolumeP, VolumeP, GreaterP[1, 1]},extraDiluent:BooleanP] :=
	Module[{transferVolumes, diluentVolumes},
		(*make arrays of all the volumes*)
		transferVolumes = ConstantArray[First[myCurve], Last[myCurve]];
		diluentVolumes = ConstantArray[myCurve[[2]], Last[myCurve]];
		(*return the transfer volumes and diluentvolumes*)
		{
			Join[{myCurve[[2]]+First[transferVolumes]},transferVolumes,If[extraDiluent,{0Microliter},{}]],
			Join[{0 Microliter},diluentVolumes,If[extraDiluent,{First[diluentVolumes]},{}]]
		}
	];

(*for a non-serial dilution with volumes given*)
calculatedDilutionCurveVolumes2[myCurve : {{VolumeP, VolumeP}...}] :=
	Module[{sampleVolumes, diluentVolumes},
		(*make arrays of all the volumes*)
		sampleVolumes = First[#]&/@myCurve;
		diluentVolumes = Last[#]&/@myCurve;
		(*return the transfer volumes and diluentvolumes*)
		{sampleVolumes, diluentVolumes}
	];

(*for a non-serial dilution with dilution factors given*)
calculatedDilutionCurveVolumes2[myCurve : {{VolumeP, RangeP[0,1]}...}] :=
	Module[{sampleVolumes, diluentVolumes},
		(*make arrays of all the volumes*)
		(*DF=sample /sample +diluent, Volume=sample+diluent*)
		sampleVolumes = SafeRound[First[#]*Last[#],10^-1 Microliter]&/@myCurve;
		diluentVolumes = SafeRound[First[#]*(1 - Last[#]), 10^-1 Microliter] & /@ myCurve;
		(*return the transfer volumes and diluentvolumes*)
		{sampleVolumes, diluentVolumes}
	];

calculatedDilutionCurveVolumes2[Null] :={Null,Null};