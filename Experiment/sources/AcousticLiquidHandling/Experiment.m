(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* Source Code *)


(* ::Subsection:: *)
(* ExperimentAcousticLiquidHandling *)


(* ::Subsubsection::Closed:: *)
(* ExperimentAcousticLiquidHandling Options*)


DefineOptions[ExperimentAcousticLiquidHandling,
	Options:>{
		{
			(* This Instrument option is a placeholder in case we have multiple acoustic liquid handlers in the future *)
			OptionName->Instrument,
			Default->Model[Instrument,LiquidHandler,AcousticLiquidHandler,"Labcyte Echo 650"],
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,LiquidHandler,AcousticLiquidHandler],Object[Instrument,LiquidHandler,AcousticLiquidHandler]}]
			],
			Description->"The acoustic liquid handler that is used to transfer, aliquot, or consolidate the samples.",
			Category->"General"
		},
		{
			OptionName->OptimizePrimitives,
			Default->OptimizeThroughput,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>AcousticLiquidHandlingOptimizationTypeP
			],
			Description->"Indicates that order of manipulations provided in the input liquid-handling primitives can be modified to be most efficient for the acoustic liquid handler executing the liquid transfers. Optimization will not modify the source(s), destination(s), and amount(s) of the primitives. OptimizeThroughput rearranges the manipulation sequence such that the overall throughput is maximized. SourcePlateCentric minimizes the number of times the source plates need to be changed in and out of the instrument during the course of transfer. DestinationPlateCentric minimizes the number of times the destination plates need to be changed in and out of the instrument during the course of transfer. PreserveTransferOrder leaves the original sequence of manipulations defined in the input primitives unchanged.",
			Category->"General"
		},
		{
			OptionName->ResolvedManipulations,
			Default->Null,
			AllowNull->True,
			Widget->sampleManipulationWidget,
			Description->"A hidden option to store the resolved input primitives to be used in resource packets.",
			Category->"Hidden"
		},

		(* These following options are IndexMatched to the input primitives *)
		IndexMatching[
			IndexMatchingInput->"experiment primitives",

			(* ---------- Pre-processing Measurement Options ---------- *)
			{
				OptionName->FluidAnalysisMeasurement,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Glycerol,DMSO,AcousticImpedance]
				],
				Description->"Indicates if the Glycerol concentration, DMSO concentration, or Acoustic Impedance is measured from the source samples by an acoustic liquid handler. If Glycerol is selected the concentration of Glycerol in the sample will be measured as volume percent. If DMSO is selected the concentration of DMSO in the sample will be measured as volume percent. If AcousticImpedance is selected, the acoustic impedance of the sample will be measured in megaRayls.",
				ResolutionDescription->"Will automatically set based on the FluidTypeCalibration Option value and the solvent the composition of the sample.",
				Category->"Pre-processing Measurement"
			},

			(* ---------- Instrument Setup ---------- *)
			{
				OptionName->FluidTypeCalibration,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>AcousticLiquidHandlerCalibrationTypeP
				],
				Description->"Indicates the calibration type for each input primitive to be used by the acoustic liquid handler. DMSO is recommended for reagents with 70 - 100% DMSO. Glycerol is recommended for reagents with up to 50% glycerol that may contain DNA or proteins. AqueousWithSurfactant is recommended for reagents with surfactants such as Triton X-100, Tween-20, or SDS. AqueousWithoutSurfactant is recommended for any liquid sample without surfactants.",
				ResolutionDescription->"Will automatically set to calibration based on the source plate's model and the composition of the sample.",
				Category->"Dispensing"
			},
			{
				(* Lets the users choose whether the droplets transferred from different samples into the same destination well are spatially separated *)
				OptionName->InWellSeparation,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets are targeted to be spatially separated to avoid mixing with each other until additional volume is added to the well.",
				ResolutionDescription->"Will automatically set based on the InWellSeparation Key in the input primitives if supplied by the user. Otherwise, will be set to False",
				Category->"Dispensing"
			}
		],

		IndexMatching[
			IndexMatchingParent->SamplesIn,

			(* ---------- Helper Options to be used in option resolver ---------- *)
			(* The user can specify SamplesIn and SamplesVolume if they so choose but will need to do thorough check with samples specified in the primitives *)
			{
				OptionName->SamplesIn,
				Default->Automatic,
				AllowNull->False,
				Widget->objectSpecificationWidgetPattern,
				Description->"The samples that are specified as the source in the input primitives.",
				Category->"Hidden"
			},
			{
				OptionName->SamplesVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Liter],
					Units->Liter*Micro
				],
				Description->"The transfer amount of the samples that are specified as the source in the input primitives.",
				Category->"Hidden"
			},

			(* Note: we need to define all sample prep options manually because we use SamplesIn hidden option as our index-matching parent *)
			(* ----------Aliquot options---------- *)
			{
				OptionName->Aliquot,
				Default->Automatic,
				Description->"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified).",
				AllowNull->False,
				Category->"Aliquoting",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			(* NOTE: This is only used in the primitive framework and is hidden in the standalone functions. *)
			{
				OptionName->AliquotSampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the samples, after they are aliquotted, for use in downstream unit operations.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->AliquotAmount,
				Default->Automatic,
				Description->"The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription->"Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Alternatives[
					"Volume"->Widget[
						Type->Quantity,
						Pattern:>RangeP[1 Microliter,20 Liter],
						Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
					],
					"All"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				]
			},
			{
				OptionName->TargetConcentration,
				Default->Automatic,
				Description->"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment.",
				ResolutionDescription->"Automatically calculated based on aliquot and buffer volumes.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar]|GreaterP[0 Gram/Liter],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				]
			},
			{
				OptionName->TargetConcentrationAnalyte,
				Default->Automatic,
				Description->"The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription->"Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[IdentityModelTypes],
					ObjectTypes->IdentityModelTypes,
					PreparedSample->False,
					PreparedContainer->False
				]
			},
			{
				OptionName->AssayVolume,
				Default->Automatic,
				Description->"The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription->"Automatically determined based on Volume and TargetConcentration option values.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,20 Liter],
					Units->{Liter,{Microliter,Milliliter,Liter}}
				]
			},
			{
				OptionName->ConcentratedBuffer,
				Default->Automatic,
				Description->"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BufferDilutionFactor,
				Default->Automatic,
				Description->"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume.",
				ResolutionDescription->"Automatically resolves to 1 if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[Type->Number,Pattern:>GreaterEqualP[1,1]]
			},
			{
				OptionName->BufferDiluent,
				Default->Automatic,
				Description->"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume.",
				ResolutionDescription->"Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->AssayBuffer,
				Default->Automatic,
				Description->"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume.",
				ResolutionDescription->"Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise, resolves to Null.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->AliquotSampleStorageCondition,
				Default->Automatic,
				Description->"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed.",
				AllowNull->True,
				Category->"Aliquoting",
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			},

			(* ----------Incubate prep options---------- *)
			{
				OptionName->Incubate,
				Default->Automatic,
				Description->"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription->"Resolves to True if any of the corresponding Incubation options are set. Otherwise, resolves to False.",
				AllowNull->False,
				Category->"Preparatory Incubation",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName->IncubationTemperature,
				Default->Automatic,
				Description->"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity,Pattern:>RangeP[$MinIncubationTemperature,$MaxIncubationTemperature],Units->{Celsius,{Fahrenheit,Celsius}}]
				]
			},
			{
				OptionName->IncubationTime,
				Default->Automatic,
				Description->"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute,$MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName->Mix,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if this sample should be mixed while incubated, prior to starting the experiment.",
				ResolutionDescription->"Automatically resolves to True if any Mix related options are set. Otherwise, resolves to False.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName->MixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>MixTypeP],
				Description->"Indicates the style of motion used to mix the sample, prior to starting the experiment.",
				ResolutionDescription->"Automatically resolves based on the container of the sample and the Mix option.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName->MixUntilDissolved,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>(BooleanP)],
				Description->"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment.",
				ResolutionDescription->"Automatically resolves to True if MaxIncubationTime or MaxNumberOfMixes is set.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName->MaxIncubationTime,
				Default->Automatic,
				Description->"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment.",
				ResolutionDescription->"Automatically resolves based on MixType, MixUntilDissolved, and the container of the given sample.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute,$MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName->IncubationInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
				],
				Description->"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment.",
				ResolutionDescription->"Automatically resolves based on the options Mix, Temperature, MixType and container of the sample.",
				Category->"Preparatory Incubation"
			},
			{
				OptionName->AnnealingTime,
				Default->Automatic,
				Description->"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Minute,$MaxExperimentTime],Units->{Hour,{Hour,Minute,Second}}]
			},
			{
				OptionName->IncubateAliquotContainer,
				Default->Automatic,
				Description->"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container]],ObjectTypes->{Model[Container]}],
					{
						"Index"->Alternatives[
							Widget[
								Type->Number,
								Pattern:>GreaterEqualP[1,1]
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						],
						"Container"->Alternatives[
							Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Container],Object[Container]}],
								ObjectTypes->{Model[Container],Object[Container]}
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						]
					}
				]
			},
			{
				OptionName->IncubateAliquotDestinationWell,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern:>WellPositionP,
					Size->Word,
					PatternTooltip->"Must be any well from A1 to P24."
				],
				Category->"Preparatory Incubation",
				Description->"The desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription->"Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName->IncubateAliquot,
				Default->Automatic,
				Description->"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation.",
				ResolutionDescription->"Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull->True,
				Category->"Preparatory Incubation",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1 Microliter,20 Liter],
						Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				]
			},

			(* ----------Centrifuge prep options---------- *)
			{
				OptionName->Centrifuge,
				Default->Automatic,
				Description->"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription->"Resolves to True if any of the corresponding Centrifuge options are set. Otherwise, resolves to False.",
				AllowNull->False,
				Category->"Preparatory Centrifugation",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName->CentrifugeInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
				Category->"Preparatory Centrifugation",
				Description->"The centrifuge that will be used to spin the provided samples prior to starting the experiment."
			},
			{
				OptionName->CentrifugeIntensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterP[0 RPM],Units->Alternatives[RPM]],
					Widget[Type->Quantity,Pattern:>GreaterP[0 GravitationalAcceleration],Units->Alternatives[GravitationalAcceleration]]
				],
				Category->"Preparatory Centrifugation",
				Description->"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment."
			},
			{
				OptionName->CentrifugeTime,
				Default->Automatic,
				Description->"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment.",
				AllowNull->True,
				Category->"Preparatory Centrifugation",
				Widget->Widget[Type->Quantity,Pattern:>GreaterP[0 Minute],Units->{Minute,{Minute,Second}}]
			},
			{
				OptionName->CentrifugeTemperature,
				Default->Automatic,
				Description->"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment.",
				AllowNull->True,
				Category->"Preparatory Centrifugation",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity,Pattern:>RangeP[-10 Celsius,40Celsius],Units->{Celsius,{Fahrenheit,Celsius,Kelvin}}]
				]
			},
			{
				OptionName->CentrifugeAliquotContainer,
				Default->Automatic,
				Description->"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull->True,
				Category->"Preparatory Centrifugation",
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container]],ObjectTypes->{Model[Container]}],
					{
						"Index"->Alternatives[
							Widget[
								Type->Number,
								Pattern:>GreaterEqualP[1,1]
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						],
						"Container"->Alternatives[
							Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Container],Object[Container]}],
								ObjectTypes->{Model[Container],Object[Container]}
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						]
					}
				]
			},
			{
				OptionName->CentrifugeAliquotDestinationWell,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern:>WellPositionP,
					Size->Word,
					PatternTooltip->"Must be any well from A1 to P24."
				],
				Category->"Preparatory Centrifugation",
				Description->"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription->"Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName->CentrifugeAliquot,
				Default->Automatic,
				Description->"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation.",
				ResolutionDescription->"Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull->True,
				Category->"Preparatory Centrifugation",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1 Microliter,20 Liter],
						Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				]
			},

			(* ----------Filter prep options---------- *)
			{
				OptionName->Filtration,
				Default->Automatic,
				Description->"Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified).",
				ResolutionDescription->"Resolves to True if any of the corresponding Filter options are set. Otherwise, resolves to False.",
				AllowNull->False,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName->FiltrationType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FiltrationTypeP],
				Category->"Preparatory Filtering",
				Description->"The type of filtration method that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolve to a filtration type appropriate for the volume of sample being filtered."
			},
			{
				OptionName->FilterInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Instrument,FilterBlock],
					Object[Instrument,FilterBlock],
					Model[Instrument,PeristalticPump],
					Object[Instrument,PeristalticPump],
					Model[Instrument,VacuumPump],
					Object[Instrument,VacuumPump],
					Model[Instrument,Centrifuge],
					Object[Instrument,Centrifuge],
					Model[Instrument,SyringePump],
					Object[Instrument,SyringePump]
				}]],
				Description->"The instrument that should be used to perform the filtration.",
				ResolutionDescription->"Will automatically resolved to an instrument appropriate for the filtration type.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName->Filter,
				Default->Automatic,
				Description->"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"Will automatically resolve to a filter appropriate for the filtration type and instrument.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container,Plate,Filter],
					Model[Container,Vessel,Filter],
					Model[Item,Filter]
				}]]
			},
			{
				OptionName->FilterMaterial,
				Default->Automatic,
				Description->"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"Resolves to an appropriate filter material for the given sample is Filtration is set to True.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP]
			},
			{
				OptionName->PrefilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterMembraneMaterialP],
				Description->"The material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName->FilterPoreSize,
				Default->Automatic,
				Description->"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment.",
				ResolutionDescription->"Resolves to an appropriate filter pore size for the given sample is Filtration is set to True.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP]
			},
			{
				OptionName->PrefilterPoreSize,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>FilterSizeP],
				Description->"The pore size of the filter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription->"By default, no prefiltration is performed on samples, even when Filter->True.",
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by syringe *)
			{
				OptionName->FilterSyringe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Container,Syringe],
					Object[Container,Syringe]
				}]],
				Description->"The syringe used to force that sample through a filter.",
				ResolutionDescription->"Resolves to an syringe appropriate to the volume of sample being filtered, if Filtration is set to True.",
				Category->"Preparatory Filtering"
			},
			{
				OptionName->FilterHousing,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Instrument, FilterHousing],
					Object[Instrument, FilterHousing],
					Model[Instrument, FilterBlock],
					Object[Instrument, FilterBlock]
				}]],
				Description->"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane.",
				ResolutionDescription->"Resolve to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used and Filtration is set to True.",
				Category->"Preparatory Filtering"
			},
			(* Options for filtering by centrifuge *)
			{
				OptionName->FilterIntensity,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterP[0 RPM],Units->Alternatives[RPM]],
					Widget[Type->Quantity,Pattern:>GreaterP[0 GravitationalAcceleration],Units->Alternatives[GravitationalAcceleration]]
				],
				Category->"Preparatory Filtering",
				Description->"The rotational speed or force at which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 2000 GravitationalAcceleration if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>GreaterP[0 Minute],Units->{Hour,{Hour,Minute,Second}}],
				Category->"Preparatory Filtering",
				Description->"The amount of time for which the samples will be centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 5 Minute if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>GreaterEqualP[4 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}]
				],
				Category->"Preparatory Filtering",
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
				ResolutionDescription->"Will automatically resolve to 22 Celsius if FiltrationType is Centrifuge and Filtration is True."
			},
			{
				OptionName->FilterContainerOut,
				Default->Automatic,
				Description->"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription->"Automatically set as the PreferredContainer for the Volume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Container],Object[Container]}],
						ObjectTypes->{Model[Container],Object[Container]}
					],
					{
						"Index"->Alternatives[
							Widget[
								Type->Number,
								Pattern:>GreaterEqualP[1,1]
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic]
							]
						],
						"Container"->Alternatives[
							Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Container],Object[Container]}],
								ObjectTypes->{Model[Container],Object[Container]}
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic]
							]
						]
					}
				]
			},
			{
				OptionName->FilterAliquotDestinationWell,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern:>WellPositionP,
					Size->Word,
					PatternTooltip->"Must be any well from A1 to P24."
				],
				Category->"Preparatory Filtering",
				Description->"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
				ResolutionDescription->"Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName->FilterAliquotContainer,
				Default->Automatic,
				Description->"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container]],ObjectTypes->{Model[Container]}],
					{
						"Index"->Alternatives[
							Widget[
								Type->Number,
								Pattern:>GreaterEqualP[1,1]
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						],
						"Container"->Alternatives[
							Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Container],Object[Container]}],
								ObjectTypes->{Model[Container],Object[Container]}
							],
							Widget[
								Type->Enumeration,
								Pattern:>Alternatives[Automatic,Null]
							]
						]
					}
				]
			},
			{
				OptionName->FilterAliquot,
				Default->Automatic,
				Description->"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration.",
				ResolutionDescription->"Automatically set as the smaller between the current sample volume and the maximum volume of the destination container.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1 Microliter,20 Liter],
						Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				]
			},
			{
				OptionName->FilterSterile,
				Default->Automatic,
				Description->"Indicates if the filtration of the samples should be done in a sterile environment.",
				ResolutionDescription->"Resolve to False if Filtration is indicated. If sterile filtration is desired, this option must manually be set to True.",
				AllowNull->True,
				Category->"Preparatory Filtering",
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},

			(* ----------SamplesIn storage condition options---------- *)
			{
				OptionName->SamplesInStorageCondition,
				Default->Null,
				Description->"The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition.",
				AllowNull->True,
				Category->"Post Experiment",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
				]
			}
		],

		(* ----------Non-index matching aliquot options---------- *)

		{
			OptionName->DestinationWell,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type->String,
					Pattern:>WellPositionP,
					Size->Word,
					PatternTooltip->"Must be any well from A1 to P24."
				],
				Adder[
					Widget[
						Type->String,
						Pattern:>WellPositionP,
						Size->Word,
						PatternTooltip->"Must be any well from A1 to P24."
					]
				]
			],
			Category->"Aliquoting",
			Description->"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			ResolutionDescription->"Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
		},
		{
			OptionName->AliquotContainer,
			Default->Automatic,
			Description->"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired. This option will resolve to be Model[Container, Plate, \"384-well Polypropylene Echo Qualified Plate\"] if the Source Samples are required to be aliquoted.",
			ResolutionDescription->"Automatically set as Model[Container, Plate, \"384-well Polypropylene Echo Qualified Plate\"]. For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next.",
			AllowNull->True,
			Category->"Aliquoting",
			Widget->Alternatives[
				Widget[
					Type->Object,
					Pattern:>ObjectP[Flatten[{PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True],Object[Container,Plate]}]],
					ObjectTypes->{Model[Container,Plate],Object[Container,Plate]}
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Automatic,Null]
				],
				{
					"Index"->Alternatives[
						Widget[
							Type->Number,
							Pattern:>GreaterEqualP[1,1]
						],
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Automatic,Null]
						]
					],
					"Container"->Alternatives[
						Widget[
							Type->Object,
							Pattern:>ObjectP[Flatten[{PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True],Object[Container,Plate]}]],
							ObjectTypes->{Model[Container,Plate],Object[Container,Plate]}
						],
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Automatic,Null]
						]
					]
				},
				Adder[
					Alternatives[
						Widget[
							Type->Object,
							Pattern:>ObjectP[Flatten[{PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True],Object[Container,Plate]}]],
							ObjectTypes->{Model[Container,Plate],Object[Container,Plate]}
						],
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Automatic,Null]
						]
					]
				],
				Adder[
					Alternatives[
						{
							"Index"->Alternatives[
								Widget[
									Type->Number,
									Pattern:>GreaterEqualP[1,1]
								],
								Widget[
									Type->Enumeration,
									Pattern:>Alternatives[Automatic,Null]
								]
							],
							"Container"->Alternatives[
								Widget[
									Type->Object,
									Pattern:>ObjectP[Flatten[{PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True],Object[Container,Plate]}]],
									ObjectTypes->{Model[Container,Plate],Object[Container,Plate]}
								],
								Widget[
									Type->Enumeration,
									Pattern:>Alternatives[Automatic,Null]
								]
							]
						},
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Automatic,Null]
						]
					]
				]
			]
		},
		{
			OptionName->AliquotPreparation,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>PreparationMethodP],
			Description->"Indicates the desired scale at which liquid handling used to generate aliquots will occur.",
			ResolutionDescription->"Automatic resolution will occur based on manipulation volumes and container types.",
			Category->"Aliquoting"
		},
		{
			OptionName->ConsolidateAliquots,
			Default->Automatic,
			Description->"Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull->True,
			Category->"Aliquoting",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},

		(* ----------Non-index matching sample prep options---------- *)
		PreparatoryUnitOperationsOption,
		PreparatoryPrimitivesOption,

		(* ----------SamplesOut storage condition options---------- *)
		{
			OptionName->SamplesOutStorageCondition,
			Default->Null,
			Description->"The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
			AllowNull->True,
			Category->"Post Experiment",
			(* Null indicates the storage conditions will be inherited from the model *)
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			]
		},

		(* ----------MeasureVolume option ---------- *)
		(* Note: re-define this because we want to default it to False as the volume is already measured by an acoustic liquid handler *)
		(* the user can set it to True and have the samples' volumes measured by liquid level detector after manipulation is done by an acoustic liquid handler *)
		{
			OptionName->MeasureVolume,
			Default->False,
			Description->"Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment.",
			AllowNull->False,
			Category->"Post Experiment",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},

		(* We would normally include FuntopiaSharedOptions here but our inputs are not samples *)
		(* We need to work around this by populating SamplesIn options with samples we extract from the input primitives *)
		(* We then use SamplesIn as index matching parent *)
		ProtocolOptions,
		ImageSampleOption
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAcousticLiquidHandling Messages*)


Error::InvalidPrimitiveType="The given input primitives at index `1` do not have the manipulation type Transfer, Aliquot, or Consolidation. Please check the definition of the primitives in question.";
Warning::PrimitivesWithIncompatibleKeys="The primitive at index `1` has a key(s) that is not supported by ExperimentAcousticLiquidHandling. Keys that are not Source/Sources/Destination/Destinations/Amount/Amounts/InWellSeparation will be ignored.";
Error::InvalidPrimitiveKeyValue="The value of the following key(s) defined in the primitive at index `1` does not match the expected pattern: `2`. Please check the definition of the primitive in question and correct the primitive's key value.";
Error::InvalidAmountLength="The Amount(s) specified in the primitive at index `1` have invalid lengths that do not match with Sources or Destinations. Please check the definition of the primitive in question and specify amounts with correct lengths";
Error::InvalidSourceObjectType="The specified Source object(s) `1` from input primitives at index `2` is not an object with type Object[Sample]. Please check the source definition in the input primitives and specify a sample object. The PreparatoryUnitOperations option can be used to create a new sample from a desired Model[Sample]. An example call is provided in the help file.";
Error::InvalidDestinationDefinition="The specified Destination `1` from input primitives at index `2` is not an object with type supported by ExperimentAcousticLiquidHandling. Please specify Destination that has the type plate-containing Object[Sample], Object[Container,Plate], or Model[Container,Plate].";
Error::AliquotContainerOccupied="The following specified AliquotContainer objects are not empty: `1`. If specifying an aliquot container object directly, it must be empty. Please specify an empty container, a model, or leave the option to be set automatically.";
Error::TotalAliquotVolumeTooLarge="The required aliquot amount `1` of the following sample(s) `2` exceed the volume `3` of these sample(s). The required aliquot amount is determined by adding the dead volume of the source plate well to the amount needed to perform all manipulations specified in the input primitives. Please check the available volume of these sample(s), or provide an alternative sample.";
Error::MultipleSourceContainerModels="The provided source samples are not in containers that share the same model. Please provide samples that are located in containers of the same model. Otherwise, leave the Aliquot option to be set automatically so that the samples can be aliquoted into appropriate containers.";
Warning::ContainerWithNonInputSamples="The following containers also contain samples other than the input samples for the experiment: `1`. These samples may be affected while performing manipulation in an acoustic liquid handler.";
Error::MultipleDestinationContainerModels="Multiple destination container types are supplied in the input primitives. Please provide only destination containers that share the same container model.";
Error::DiscardedSourceSamples="The provided source samples `1` from primitives at index `2` are discarded and thereby cannot be used for the experiment.";
Error::DeprecatedSourceModels="The provided source sample's `1` from primitives at index `2` have models `3` that are deprecated and thereby cannot be used for the experiment.";
Error::NonLiquidSourceSamples="The provided source samples `1` from primitives at index `2` are not liquid and thereby cannot be used for the experiment.";
Error::PrimitivesWithContainerlessSamples="The provided source samples `1` from primitives at index `2` are not in a container. Please make sure their containers are accurately uploaded.";
Error::IncompatibleSourceContainer="The provided source samples `1` from primitives at index `2` are not in containers that are compatible with an acoustic liquid handler. Please provide samples that are located in a compatible container or leave the Aliquot option to be set automatically. Call PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True] for a list of compatible container models.";
Error::DiscardedDestinationContainer="The provided destination containers `1` from primitives at index `2` are discarded and thereby cannot be used for the experiment.";
Error::DeprecatedDestinationContainerModel="The provided destination container model `1` from primitives at index `2` are deprecated and thereby cannot be used for the experiment.";
Error::IncompatibleDestinationContainer="The container models of the provided destination object `1` from primitives at index `2` have values in the Fields `3` that are not compatible with the acoustic liquid handler. Please see ExperimentAcousticLiquidHandling help file for more information on compatible destination containers.";
Error::MissingLabwareDefinitionFields="The container models of the provided destination object `1` from primitives at index `2` have Fields `3` that are not populated. Labware definition for the acoustic liquid handler cannot be created unless the value in Fields `3` are provided.";
Error::UnsafeDestinationVolume="The containers of the provided destination object `1` from primitives at index `2` have occupied wells that may spill when the plate is inverted during acoustic liquid handling. If the destination container is required to be occupied, please use a 384-well plate that is pre-filled up to half of the maximum well volume.";
Error::AmountOutOfRange="The Amount(s) `1` supplied in primitives at index `2` are outside of range supported by the instrument `3`. Please check the definition of the primitives in question and supply the Amount(s) between `4` and `5`.";
Error::InsufficientSourceVolume="The volumes of source samples `1` are not sufficient to perform the manipulation defined in primitives at index `2`. Note that the samples `1` have dead volumes of `3` which cannot be used in any manipulations. Please check the volume of the sample in question and provide a sample with sufficient amount.";
Error::SamePlateTransfer="The input primitives at index `1` contain manipulations that involve transfer between source and destination wells within the same container which is not supported by the acoustic liquid handler. Please correct the definition of the primitive in question.";
Error::InvalidDestinationWellAcousticLiquidHandling="The destination wells `1` defined in primitives at index `2` are not allowed for containers `3`. Please check the primitive in question and supply destination wells that are included in AllowedPositions of the container.";
Error::OverFilledDestinationVolume="The volume of destination location `1` will be overfilled in primitives at index `2`. Note that the destination location `1` have maximum well volumes of `3`. Please correct the Amount or Destination of the primitive in question.";
Error::InvalidInWellSeparationKey="The input primitives at index `1` have their InWellSeparation Key set to True when physical separation of droplets in the destination well is not possible to achieve. Please see ExperimentAcousticLiquidHandling help file for more information.";
Error::InWellSeparationKeyOptionMismatch="The value of InWellSeparation Key specified in the input primitives at index `1` does not match the InWellSeparation Option value. Please check the definition of the primitives in question or leave the Key and Option to be set automatically.";
Error::InvalidInWellSeparationOption="The input primitives at index `1` have their InWellSeparation Option set to True when physical separation of droplets in the destination well is not possible to achieve. Please see ExperimentAcousticLiquidHandling help file for more information.";
Error::GlycerolConcentrationTooHigh="The glycerol concentrations of source samples `1` from primitives at index `2` are higher than the maximum concentration supported by the acoustic liquid handler. Please provide a new sample with glycerol concentration below or equal to `3`.";
Error::CalibrationAndMeasurementTypeMismatch="The options FluidTypeCalibration and FluidAnalysisMeasurement conflict for the primitives at index `1`. If one of the options is set to DMSO or Glycerol, the other must have the same value. Otherwise, FluidAnalysisMeasurement must be set to AcousticImpedance for all other values of FluidTypeCalibration. Please correct the options in question or leave them to be set automatically.";
Error::InvalidFluidTypeCalibration="The option FluidTypeCalibration for the primitives at index `1` is invalid. FluidTypeCalibration cannot be set to Glycerol when a low-dead-volume plate is used as a source. Please correct the options in question or leave them to be set automatically.";
Error::InvalidFluidAnalysisMeasurement="The option FluidAnalysisMeasurement for the primitives at index `1` is invalid. FluidAnalysisMeasurement cannot be set to Glycerol when a low-dead-volume plate is used as a source. Please correct the options in question or leave them to be set automatically.";
Warning::FluidTypeCalibrationMismatch="The option FluidTypeCalibration for the primitives at index `1` is set to a value not intended for the composition of samples `2`. The option can be left as is or if desired, can be left to be set automatically according to the sample's composition.";
Warning::FluidAnalysisMeasurementMismatch="The option FluidAnalysisMeasurement for the primitives at index `1` is set to a value not intended for the composition of samples `2`. The option can be left as is or if desired, can be left to be set automatically according to the sample's composition.";


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling*)

(* single primitive overload *)
ExperimentAcousticLiquidHandling[myPrimitive:SampleManipulationP,myOptions:OptionsPattern[]]:=ExperimentAcousticLiquidHandling[{myPrimitive},myOptions];

(* core overload *)
ExperimentAcousticLiquidHandling[myPrimitives:{SampleManipulationP..},myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,allPackets,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		upload,confirm,fastTrack,parentProtocol,cache,safeOpsNamed,

		(* sample prep variables *)
		myDefinedSampleInputs,myDefinedSamples,validSamplePreparationResult,myPreparedSamplesNamed,myPreparedSamples,myOptionsWithPreparedSamplesNamed,myOptionsWithPreparedSamples,samplePreparationCache,
		updatedSamplePreparationCache,defineNameRules,updatedPrimitives,

		(* pre-download primitive validation check variables *)
		invalidManipulationTypeBools,invalidPrimitivePosition,validPrimitivePosition,primitivesWithInvalidType,
		invalidManipulationTypeTest,expandVolume,primitivesWithExpandedAmount,incompatibleKeysLookup,primitivesWithIncompatibleKeysPositions,
		primitivesWithCompatibleKeysPositions,primitivesWithIncompatibleKeysTest,primitivesWithCompatibleKeys,primitiveKeyValidityRules,
		invalidKeyValuesPickList,primitivesWithInvalidKeys,primitivesWithInvalidKeysTest,primitivesWithConvertedTransfers,
		mismatchedAmountLengthBools,invalidAmountPositions,invalidAmountLengthTest,

		(* download variables *)
		allObjectsFromPrimitives,suppliedObjectsFromOptions,userSpecifiedObjects,simulatedObjectQ,objectsToCheck,objectsExistQ,
		nonExistingObjects,objectsExistenceTest,specifiedAliquotContainerObjects,specifiedInstrument,preferredAliquotContainersModels,
		sampleFields,modelSampleFields,objectContainerFields,modelContainerFields,objectInstrumentFields,modelInstrumentFields,
		defaultInstrumentModel,rawObjectsToDownload,objectsToDownload,allFields,

		(* pre-resolver validation variables *)
		primitivesInTransferForm,specifiedUpdatedPrimitives,specifiedSourceSamples,rawSources,invalidSources,
		primitiveWithInvalidSourceIndices,invalidSourceObjectTypeTests,splitPrimitives,validDestinations,invalidDestinations,
		primitiveWithInvalidDestinationIndices,invalidDestinationDefinitionTests,sampleUsageAssociation,samplesIn,samplesVolume,
		updatedOptions

	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* ---------------------------------------- *)
	(* ---MANIPULATION TYPE VALIDATION CHECK--- *)
	(* ---------------------------------------- *)

	(* check early if the input primitive has a valid manipulation type *)
	(* ExperimentAcousticLiquidHandling only supports Transfer/Aliquot/Consolidation Primitives *)
	invalidManipulationTypeBools=Map[
		!MatchQ[#,Alternatives[_Transfer,_Aliquot,_Consolidation]]&,
		myPrimitives
	];

	(* get the positions of the invalid input primitives *)
	invalidPrimitivePosition=Flatten[Position[invalidManipulationTypeBools,True]];

	(* get the positions of the valid input primitives *)
	validPrimitivePosition=Flatten[Position[invalidManipulationTypeBools,False]];

	(* get the invalid primitives *)
	primitivesWithInvalidType=PickList[myPrimitives,invalidManipulationTypeBools,True];

	(* if there are invalid primitives and we are throwing messages, throw an error message *)
	If[Or@@invalidManipulationTypeBools&&!gatherTests,
		Message[Error::InvalidPrimitiveType,invalidPrimitivePosition];
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	invalidManipulationTypeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[primitivesWithInvalidType,{}],
					Nothing,
					Test["The input primitives at index "<>ToString[invalidPrimitivePosition]<>" have the manipulation types that are supported by ExperimentAcousticLiquidHandling:",True,False]];

			passingTest=
				If[Length[primitivesWithInvalidType]==Length[myPrimitives],
					Nothing,
					Test["The input primitives at index "<>ToString[validPrimitivePosition]<>" have the manipulation types that are supported by ExperimentAcousticLiquidHandling:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* if at least one primitive with invalid manipulation type is given, return $Failed *)
	If[!MatchQ[primitivesWithInvalidType,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->invalidManipulationTypeTest,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* ------------------------------------- *)
	(* ---EXPAND VALUES OF THE AMOUNT KEY--- *)
	(* ------------------------------------- *)

	(* a helper function to expand values under Amount key to match the length sources or destinations *)
	expandVolume[amount_,input_]:=Switch[{amount,Length[amount]},
		{_List,EqualP[1]},Table[First[amount],Length[input]],
		{_List,_},amount,
		_,Table[amount,Length[input]]
	];

	(* expand amounts in Transfer/Aliquot/Consolidation primitives *)
	primitivesWithExpandedAmount=Map[
		Switch[#,
			_Transfer,
				If[!MissingQ[#[Volume]],
					Transfer[Append[KeyDrop[First[#],Volume],Amount->#[Volume]]],
					#
				],
			_Aliquot,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Destinations]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Destinations]]]]
				],
			_Consolidation,
				If[!MissingQ[#[Volumes]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Volumes],#[Sources]]]],
					Head[#][Append[KeyDrop[First[#],Volumes],Amounts->expandVolume[#[Amounts],#[Sources]]]]
				],
			_,
				#
		]&,
		myPrimitives
	];

	(* -------------------------------------- *)
	(* ---PRIMITIVE INCOMPATIBLE KEY CHECK--- *)
	(* -------------------------------------- *)

	(* get the incompatible keys for each of the supported manipulation types *)
	incompatibleKeysLookup=Map[
		#->Complement[Keys[Experiment`Private`manipulationKeyPatterns[#]],{Source,Sources,Destination,Destinations,Amount,Amounts,InWellSeparation}]&,
		{Transfer,Aliquot,Consolidation}
	];

	(* check if each of the input primitives is defined with keys other than Source/Destination/Amount/InWellSeparation *)
	primitivesWithIncompatibleKeysPositions=Flatten[MapIndexed[
		If[Intersection[Keys[Association@@#1],Lookup[incompatibleKeysLookup,Head[#1]]]!={},
			#2,
			Nothing
		]&,
		primitivesWithExpandedAmount
	]];

	(* get the positions of the primitive with compatible keys *)
	primitivesWithCompatibleKeysPositions=Complement[Range[Length[primitivesWithExpandedAmount]],primitivesWithIncompatibleKeysPositions];

	(* if there are primitives with incompatible keys and we are throwing messages, throw a warning message *)
	If[!MatchQ[primitivesWithIncompatibleKeysPositions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::PrimitivesWithIncompatibleKeys,primitivesWithIncompatibleKeysPositions];
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	primitivesWithIncompatibleKeysTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[primitivesWithIncompatibleKeysPositions,{}],
					Nothing,
					Warning["The input primitives at index "<>ToString[primitivesWithIncompatibleKeysPositions]<>" have keys that are supported by ExperimentAcousticLiquidHandling:",True,False]];

			passingTest=
				If[Length[primitivesWithIncompatibleKeysPositions]==Length[primitivesWithExpandedAmount],
					Nothing,
					Warning["The input primitives at index "<>ToString[primitivesWithCompatibleKeysPositions]<>" have keys that are supported by ExperimentAcousticLiquidHandling:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* drop incompatible keys from the primitives *)
	primitivesWithCompatibleKeys=Flatten[MapIndexed[
		If[Intersection[Keys[Association@@#1],Lookup[incompatibleKeysLookup,Head[#1]]]!={},
			Head[#1][KeyDrop[Association@@#1,Lookup[incompatibleKeysLookup,Head[#1]]]],
			#1
		]&,
		primitivesWithExpandedAmount
	]];

	(* -------------------------------------------------- *)
	(* ---PRIMITIVE KEY VALUE PATTERN VALIDATION CHECK--- *)
	(* -------------------------------------------------- *)

	(* check the patterns of the keys in the provided manipulations to ensure validity *)
	(* Return a list of rules. Key that points to False has value with invalid pattern *)
	primitiveKeyValidityRules=Map[
		Function[primitive,
			Map[
				Switch[primitive,
					_Transfer,
						#->MatchQ[primitive[#],ListableP[Lookup[Experiment`Private`manipulationKeyPatterns[Head[primitive]],#]]],
					_,
						#->MatchQ[primitive[#],Lookup[Experiment`Private`manipulationKeyPatterns[Head[primitive]],#]]
				]&,
				Keys[Association@@primitive]
			]
		],
		primitivesWithCompatibleKeys
	];

	(* create a pick list to select primitives that have at least one invalid key value *)
	invalidKeyValuesPickList=Map[And@@Values[#]&,primitiveKeyValidityRules];

	(* get the list of primitives with invalid key value *)
	primitivesWithInvalidKeys=PickList[primitivesWithCompatibleKeys,invalidKeyValuesPickList,False];

	(* throw a message if invalid key value patterns exist in our input primitives *)
	If[!MatchQ[primitivesWithInvalidKeys,{}]&&!gatherTests,
		MapThread[
			Function[{bool,rules,index},
				If[Not[bool],
					Message[Error::InvalidPrimitiveKeyValue,
						{index},
						PickList[rules[[All,1]],rules[[All,2]],False]
					]
				]
			],
			{invalidKeyValuesPickList,primitiveKeyValidityRules,Range[Length[primitivesWithCompatibleKeys]]}
		]
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	primitivesWithInvalidKeysTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[primitivesWithInvalidKeys,{}],
					Nothing,
					Test["The input primitives at index "<>ToString[Flatten[Position[invalidKeyValuesPickList,False]]]<>" have keys that match the expected patterns:",True,False]];

			passingTest=
				If[Length[primitivesWithInvalidKeys]==Length[primitivesWithCompatibleKeys],
					Nothing,
					Test["The input primitives at index "<>ToString[Flatten[Position[invalidKeyValuesPickList,True]]]<>" have keys that match the expected patterns:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* if at least one primitive with invalid key pattern is given, return $Failed *)
	If[!MatchQ[primitivesWithInvalidKeys,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* -------------------------------------------------- *)
	(* ----------AMOUNT LENGTH VALIDATION CHECK---------- *)
	(* -------------------------------------------------- *)

	(* call convertTransferPrimitive as a mean to check matching amount length with Source or Destination *)
	(* convertTransfer works with all valid input format except Transfer primitive with amount length mismatch *)
	(* we simply check if MapThread error message is thrown from convertTransfer primitive *)
	primitivesWithConvertedTransfers=Map[
		Switch[#,
			_Transfer,
				Quiet[Check[
					Experiment`Private`convertTransferPrimitive[#],
					$Failed,
					{MapThread::mptc}
				]],
			_,
				#
		]&,
		primitivesWithExpandedAmount
	];

	(* check if the length of amount after expansion matches the length of sources or destinations *)
	mismatchedAmountLengthBools=Map[
		Switch[#,
			$Failed,
				True,
			_Aliquot,
				!MatchQ[Length[#[Destinations]],Length[#[Amounts]]],
			_Consolidation,
				!MatchQ[Length[#[Sources]],Length[#[Amounts]]],
			_,
				False
		]&,
		primitivesWithConvertedTransfers
	];

	(* get the positions of the input primitives with invalid amount length *)
	invalidAmountPositions=Flatten[Position[mismatchedAmountLengthBools,True]];

	(* if we are throwing messages, throw an error message indicating the index of primitives with Amount length mismatch *)
	If[Not[MatchQ[invalidAmountPositions,{}]]&&!gatherTests,
		Message[Error::InvalidAmountLength,invalidAmountPositions]
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	invalidAmountLengthTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[invalidAmountPositions,{}],
					Nothing,
					Test["The Amount(s) specified in the input primitive at index "<>ToString[invalidAmountPositions]<>" have lengths that match with Sources or Destinations:",True,False]];

			passingTest=
				If[Length[invalidAmountPositions]==Length[myPrimitives],
					Nothing,
					Test["The Amount(s) specified in the input primitive at index "<>ToString[Complement[Range[Length[myPrimitives]],invalidAmountPositions]]<>" have lengths that match with Sources or Destinations:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* if at least one primitive with invalid key pattern is given, return $Failed *)
	If[!MatchQ[invalidAmountPositions,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* --------------------------------- *)
	(* ---SIMULATE SAMPLE PREPARATION--- *)
	(* --------------------------------- *)

	(* get source/destination from the primitives that are defined as string names and pass into sample prep simulation *)
	(* for any primitives that use a name, extract the referenced name *)
	myDefinedSampleInputs=DeleteDuplicates[Flatten[Map[
		Switch[#,
			_Transfer,
				Cases[{#[Source],#[Destination]},(name_String|{name_String,WellPositionP}):>name,{1}],

			_Aliquot,
				Cases[Append[#[Destinations],#[Source]],(name_String|{name_String,WellPositionP}):>name,{1}],

			_Consolidation,
				Cases[Append[#[Sources],#[Destination]],(name_String|{name_String,WellPositionP}):>name,{1}],
			_,
				{}
		]&,
		primitivesWithCompatibleKeys
	]]];

	(* Remove temporal links. *)
	{myDefinedSamples, listedOptions} = removeLinks[myDefinedSampleInputs, ToList[myOptions]];

	(* simulate our sample preparation for DEFINED samples in our input primitives and options *)
	(* FIXME: what if any option is specified as string name? it is tricky because the user may not specify Object[Sample] as Source *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=If[MatchQ[myDefinedSamples,{}],

			(* if we don't have any defined source samples, don't simulate SM *)
			{{},listedOptions,{}},

			(* otherwise, simulate as usual but with on defined sample names as input *)
			simulateSamplePreparationPackets[
				ExperimentAcousticLiquidHandling,
				myDefinedSamples,
				listedOptions
			]
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* if we are given an invalid define name, return $Failed *)
	(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Name key in the simulated prepared sample packet is Null. we populate it with DefineName manually so that we can use it in the resolver *)
	(* update prepared samples packets in samplePreparationCache by assigning DefineName to Name Key *)
	updatedSamplePreparationCache=Map[
		Function[preparedPacket,
			If[KeyExistsQ[preparedPacket,DefineName],
				(* if Key DefineName exist in the packet, update Name Key with DefineName Value *)
				Module[{packetToUpdate},
					packetToUpdate=preparedPacket;
					AssociateTo[packetToUpdate,Name->Lookup[preparedPacket,DefineName]]
				],
				(* otherwise, return the packet as is *)
				preparedPacket
			]
		],
		samplePreparationCache
	];

	(* create replace rules for defined name lookup *)
	(* Note: for all simulated objects, DefineName key is added to the packet in the simulated cache *)
	defineNameRules=Map[
		If[KeyExistsQ[#,DefineName],
			#[DefineName]->#[Object],
			Nothing
		]&,
		samplePreparationCache
	];

	(* replace all defined names in the input primitives *)
	updatedPrimitives=primitivesWithCompatibleKeys/.defineNameRules;

	(* --------------------------- *)
	(* ---OPTIONS PATTERN CHECK--- *)
	(* --------------------------- *)

	(* call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentAcousticLiquidHandling,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentAcousticLiquidHandling,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Call sanitize-inputs to clean any named objects *)
	{myPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[myPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* -------------------------- *)
	(* ---OPTIONS LENGTH CHECK--- *)
	(* -------------------------- *)

	(* call ValidOptionLengthsQ to make sure all options are the right length *)
	(* TODO: this always returns True. Need to check if it is because our weird input format and index matching parent *)
	(* did not pass valid length test when options with string are specified. results of valid length -> Failed but passed all valid length tests. works fine if specified with the correct pattern *)
	(* there might be an issue with index-matching parent *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentAcousticLiquidHandling,{myPrimitives},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentAcousticLiquidHandling,{myPrimitives},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* --------------------------- *)
	(* ---GET TEMPLATED OPTIONS--- *)
	(* --------------------------- *)

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentAcousticLiquidHandling,{myPrimitives},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentAcousticLiquidHandling,{myPrimitives},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	(* Note: remove inherited hidden options ResolvedManipulations, SamplesIn, and SamplesVolume because they are required to be populated by the current experiment call only *)
	inheritedOptions=ReplaceRule[safeOps,Normal@KeyDrop[templatedOptions,{ResolvedManipulations,SamplesIn,SamplesVolume}]];

	(* ------------------------ *)
	(* ---GET HIDDEN OPTIONS--- *)
	(* -------------------------*)

	(* get assorted hidden options *)
	{upload,confirm,fastTrack,parentProtocol,cache}=Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(* --------------------------- *)
	(* ---OBJECT EXISTENCE TEST--- *)
	(* --------------------------- *)

	(* get all objects from our input primitives *)
	allObjectsFromPrimitives=Cases[updatedPrimitives,ObjectP[],Infinity];

	(* get all user-specified objects from our options *)
	(* Note: Cache option is removed from the inherited options to exclude objects that exist in the packets *)
	suppliedObjectsFromOptions=Cases[KeyDrop[inheritedOptions,Cache],ObjectP[],Infinity];

	(* combine all the user-specified primitive and option objects *)
	userSpecifiedObjects=DeleteDuplicates@Flatten[{allObjectsFromPrimitives,suppliedObjectsFromOptions}];

	(* filter out the simulated objects from the user-specified objects *)
	simulatedObjectQ=Lookup[fetchPacketFromCache[#,updatedSamplePreparationCache],Simulated,False]&/@userSpecifiedObjects;
	objectsToCheck=PickList[userSpecifiedObjects,simulatedObjectQ,False];

	(* check if the user-specified objects exist on the database *)
	objectsExistQ=DatabaseMemberQ[objectsToCheck];
	nonExistingObjects=PickList[objectsToCheck,objectsExistQ,False];

	(* if any object doesn't exist and we are throwing messages, throw an error message *)
	If[Not[MatchQ[nonExistingObjects,{}]]&&!gatherTests,
		Message[Error::ObjectDoesNotExist,nonExistingObjects];
		Message[Error::InvalidInput,nonExistingObjects]
	];

	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	objectsExistenceTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=
				If[MatchQ[nonExistingObjects,{}],
					Nothing,
					Test["The specified objects "<>ToString[nonExistingObjects]<>" exist in the database:",True,False]];

			passingTest=
				If[Length[nonExistingObjects]==Length[objectsToCheck],
					Nothing,
					Test["The specified objects "<>ObjectToString[Complement[objectsToCheck,nonExistingObjects],Cache->updatedSamplePreparationCache]<>" exist in the database:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* Return early if any object does not exist does not exist in the database. *)
	If[Not[MatchQ[nonExistingObjects,{}]],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests,
				objectsExistenceTest
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* -------------- *)
	(* ---DOWNLOAD--- *)
	(* -------------- *)

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* ---GATHER ALL OBJECTS TO DOWNLOAD--- *)

	(* pull out all the objects specified in the AliquotContainer option *)
	specifiedAliquotContainerObjects=Cases[Flatten[{Lookup[inheritedOptions,AliquotContainer]}],ObjectP[]];

	(* get the preferred aliquot containers *)
	preferredAliquotContainersModels=PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True];

	(* get the specified Instrument option *)
	specifiedInstrument=Lookup[inheritedOptions,Instrument];

	(* get the default instrument from our experiment option *)
	(* do the following so that we don't have to change the default in multiple locations when needed *)
	defaultInstrumentModel=Lookup[Options[ExperimentAcousticLiquidHandling],"Instrument"];

	(* define Fields to download for each object type *)
	sampleFields=Sequence@@SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields=Sequence@@SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields=Sequence@@SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=Sequence@@Union[{AllowedPositions,Columns,CrossSectionalShape,FlangeHeight,HorizontalMargin,HorizontalPitch,
		Rows,VerticalMargin,VerticalPitch,WellBottom,ConnectionType},SamplePreparationCacheFields[Model[Container]]];
	objectInstrumentFields=Sequence[Name,Status,Model,MinPlateHeight,MaxPlateHeight,MaxFlangeHeight,MinVolume,MaxVolume,DropletTransferResolution,SampleHandlingCategories,MaxTime,MaxTemperature,MinTemperature,
		SpeedResolution,MaxRotationRate,MinRotationRate,CentrifugeType,
		Positions,RequestedResources];
	modelInstrumentFields=Sequence[Name,Deprecated,MinPlateHeight,MaxPlateHeight,MaxFlangeHeight,MinVolume,MaxVolume,DropletTransferResolution,SampleHandlingCategories,MaxTime,MaxTemperature,MinTemperature,
		SpeedResolution,MaxRotationRate,MinRotationRate,CentrifugeType,
		Positions,RequestedResources,InternalDimensions];

	(* combine all objects to download *)
	(* Note: make sure to convert all object references to ID form to remove all duplicates efficiently before downloading *)
	rawObjectsToDownload=Flatten[{
		allObjectsFromPrimitives,
		suppliedObjectsFromOptions,
		specifiedAliquotContainerObjects,
		preferredAliquotContainersModels,
		specifiedInstrument,
		defaultInstrumentModel
	}]/.x:ObjectReferenceP[]:>Download[x,Object];

	(* create a list of all to objects to download *)
	objectsToDownload=DeleteDuplicates@Cases[rawObjectsToDownload,ObjectP[]];

	(* get the fields to download according to the object type *)
	allFields=Map[
		Switch[#,
			ObjectP[Object[Sample]],
				{
					Packet[sampleFields],
					Packet[Model[List@modelSampleFields]],
					Packet[Container[List@objectContainerFields]],
					Packet[Container[Model][List@modelContainerFields]]
				},
			ObjectP[Object[Container]],
				{
					Packet[objectContainerFields],
					Packet[Model[List@modelContainerFields]],
					Packet[Field[Contents[[All,2]]][List@sampleFields]]
				},
			ObjectP[Model[Container]],
				{
					Packet[modelContainerFields]
				},
			ObjectP[Object[Instrument]],
				{
					Packet[objectInstrumentFields],
					Packet[Model[List@modelInstrumentFields]]
				},
			ObjectP[Model[Instrument]],
				{
					Packet[modelInstrumentFields]
				},
			_,
				{}
		]&,
		objectsToDownload
	];

	(* make the big download call *)
	allPackets=Flatten[Quiet[
		Download[
			objectsToDownload,
			Evaluate[allFields],
			Date->Now,
			Cache->Flatten[{cache,updatedSamplePreparationCache}]
		],
		Download::FieldDoesntExist
	]];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=Experiment`Private`FlattenCachePackets[{updatedSamplePreparationCache,allPackets}];

	(* --------------------------- *)
	(* ---SPECIFY MANIPULATIONS--- *)
	(* --------------------------- *)

	(* convert Aliquot and Consolidation primitives to low-level Transfer syntax
	and returns Transfer primitives with expanded Source/Destination/Amount key values *)
	primitivesInTransferForm=Map[Experiment`Private`convertTransferPrimitive,updatedPrimitives];

	(* specify our primitives to resolve source samples *)
	specifiedUpdatedPrimitives=Map[
		Experiment`Private`specifyManipulation[#,Cache->cacheBall]&,
		primitivesInTransferForm
	];

	(* ------------------------------------- *)
	(* ---SOURCE SAMPLE OBJECT TYPE CHECK--- *)
	(* ------------------------------------- *)

	(* up to this point, SourceSample in our 'specified' primitives should be populated as Object[Sample] if they were defined correctly by the user *)
	(* Flag the primitives that have Null under SourceSample key as that indicates Source being specified as a Model *)
	(* we don't allow source sample to be specified as a model directly as it would mess up sample simulation *)
	(* check here and return early if source samples from the input primitives contain any thing that's not Object[Sample] *)

	(* get the Source objects from the primitives. Maintain nested list structure for identifying primitive index *)
	specifiedSourceSamples=Flatten[#[SourceSample]]&/@specifiedUpdatedPrimitives;

	(* extract the raw sources from the input primitives *)
	(* call convertTransferPrimitive so that everything is expanded and indexmatched to specifiedSourceSamples *)
	rawSources=Map[
		Experiment`Private`convertTransferPrimitive[#][Source]&,
		myPrimitives
	];

	(* get the invalid source and the index of the corresponding input primitive *)
	{invalidSources,primitiveWithInvalidSourceIndices}=If[MemberQ[Flatten[specifiedSourceSamples],Null],
		Transpose[
			Flatten[MapIndexed[
				Function[{sourceTuple,primitiveIndex},
					MapThread[
						Switch[#1,
							Null,{#2,primitiveIndex},
							_,Nothing
						]&,
						sourceTuple
					]
				],
				Transpose[{specifiedSourceSamples,rawSources}]
			],1]
		],

		{{},{}}
	];

	(* if a specified non-Object[Sample] exists in our input primitives and we are throwing messages, throw an error message *)
	(* TODO: the message should also cover when {Object[Container,Plate], "A1"} cannot resolve to Object[Sample] *)
	If[!MatchQ[invalidSources,{}]&&!gatherTests,
		Message[Error::InvalidSourceObjectType,Flatten[invalidSources],Flatten[primitiveWithInvalidSourceIndices]];
	];
	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	invalidSourceObjectTypeTests=If[gatherTests,
		Module[{flatInvalidSources,flatValidSources,failingTest,passingTest},

			flatInvalidSources=DeleteDuplicates[Flatten[invalidSources]];

			flatValidSources=DeleteDuplicates[Cases[specifiedSourceSamples,ObjectP[],Infinity]];

			failingTest=
				If[MatchQ[flatInvalidSources,{}],
					Nothing,
					Test["The specified source objects "<>ObjectToString[flatInvalidSources,Cache->cacheBall]<>" have the type Object[Sample]:",True,False]];

			passingTest=
				If[MatchQ[flatValidSources,NullP],
					Nothing,
					Test["The specified source objects "<>ObjectToString[flatValidSources,Cache->cacheBall]<>" have the type Object[Sample]:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!MatchQ[invalidSources,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests,
				invalidSourceObjectTypeTests
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* ---------------------- *)
	(* ---SPLIT PRIMITIVES--- *)
	(* ---------------------- *)

	(* split primitives to individual Transfer primitives and add Index key to store the indices of their parent primitives *)
	splitPrimitives=Flatten[MapIndexed[
		Function[{primitive,primitiveIndex},
			Map[
				(* call convertTransferPrimitive on split primitive again to keep all key values in the correct format *)
				Experiment`Private`convertTransferPrimitive[Transfer[
					Append[
						AssociationThread[Keys[Association@@primitive],#],
						(* include Index key in the split primitive to store original index of its parent primitive *)
						Index->First[primitiveIndex]
					]
				]]&,
				Transpose[Values[Association@@primitive]]
			]
		],
		specifiedUpdatedPrimitives
	]];

	(* ----------------------------------- *)
	(* ---DESTINATION OBJECT TYPE CHECK--- *)
	(* ----------------------------------- *)

	(* we only allow Destination to be specified as Model[Container, Plate], Object[Container, Plate], or Object[Sample] that is in a plate *)
	(* we will return early if the user-specified Destination is invalid *)
	(* we will perform a more thorough check on the plate model/object in the resolver *)
	{validDestinations,invalidDestinations,primitiveWithInvalidDestinationIndices}=Transpose[Map[
		Function[primitive,
			Module[{rawDestination,destinationLocation},
				(* get the raw Destination and location from our split Transfer primitive *)
				(* Note: Destination is now in a nested {{value}} format *)
				rawDestination=First@First@primitive[Destination];
				(* Note: ResolvedDestinationLocation is in the form {value} *)
				destinationLocation=First@primitive[ResolvedDestinationLocation];

				Switch[{destinationLocation,rawDestination},
					(* specified as Object[Sample] in a plate or {plate, well} format *)
					(* for this case, DestinationLocation is specified as PlateWellP *)
					{PlateAndWellP,_},
						{ToString[rawDestination],{},{}},
					(* specified in {{tag, plateModel}, well} format *)
					{Null,{{_,ObjectReferenceP[Model[Container,Plate]]},WellPositionP}},
						{ToString[rawDestination],{},{}},
					(* specified in {tag, plateModel} format *)
					{Null,{_,ObjectReferenceP[Model[Container,Plate]]}},
						{ToString[rawDestination],{},{}},
					(* specified in {plateModel, well} format *)
					{Null,{ObjectReferenceP[Model[Container,Plate]],WellPositionP}},
						{ToString[rawDestination],{},{}},
					(* specified as a plate model *)
					{Null,ObjectReferenceP[Model[Container,Plate]]},
						{ToString[rawDestination],{},{}},
					(* we don't allow all other cases. return the value in String form and primitive index *)
					_,
						{{},ToString[rawDestination],primitive[Index]}
				]
			]
		],
		splitPrimitives
	]];

	(* if an invalid destination object exists in our input primitives and we are throwing messages, throw an error message *)
	If[!MatchQ[Flatten[invalidDestinations],{}]&&!gatherTests,
		Message[Error::InvalidDestinationDefinition,Flatten[invalidDestinations],Flatten[primitiveWithInvalidDestinationIndices]];
	];
	(* if we are gathering tests,create a passing and/or failing test with the appropriate result *)
	invalidDestinationDefinitionTests=If[gatherTests,
		Module[{flatInvalidDestinations,flatValidDestinations,failingTest,passingTest},

			flatInvalidDestinations=DeleteDuplicates[Flatten[invalidDestinations]];

			flatValidDestinations=DeleteDuplicates[Flatten[validDestinations]];

			failingTest=
				If[MatchQ[flatInvalidDestinations,{}],
					Nothing,
					Test["The specified Destination value "<>ObjectToString[flatInvalidDestinations]<>" have the type non-self-contained Object[Sample], Object[Container,Plate], or Model[Container,Plate]:",True,False]];

			passingTest=
				If[MatchQ[flatValidDestinations,{}],
					Nothing,
					Test["The specified Destination value "<>ObjectToString[flatValidDestinations]<>" have the type non-self-contained Object[Sample], Object[Container,Plate], or Model[Container,Plate]:",True,True]];

			{failingTest,passingTest}
		],

		Nothing
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!MatchQ[Flatten[invalidDestinations],{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests,
				invalidSourceObjectTypeTests,
				invalidDestinationDefinitionTests
			}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* ----------------------------------- *)
	(* ---DETERMINE SOURCE SAMPLE USAGE--- *)
	(* ----------------------------------- *)

	(* pull out all Source objects and usage volume from the input primitives by calling the SampleUsage function *)
	(* we don't care about the messages thrown by SampleUsage since we handle all the checks here *)
	sampleUsageAssociation=Quiet[SampleUsage[updatedPrimitives,OutputFormat->Association,Cache->cacheBall]];

	(* assign the sample objects from SampleUsage result as our samples in *)
	samplesIn=Lookup[sampleUsageAssociation,Sample];

	(* assign the usage amount from SampleUsage result as our samples' volume *)
	samplesVolume=Lookup[sampleUsageAssociation,Usage];

	(* add SamplesIn, SamplesVolume to listedOptions, before calling SafeOptions. *)
	(* safeOptions will then check if the user input valid source objects *)
	(* by comparing SampleIn/SamplesVolume with the defined option patterns *)
	updatedOptions=ReplaceRule[
		inheritedOptions,
		{
			SamplesIn->samplesIn,
			SamplesVolume->samplesVolume,
			ResolvedManipulations->splitPrimitives
		}
	];

	(* ----------------------------------- *)
	(* ---EXPAND INDEX-MATCHING OPTIONS--- *)
	(* ----------------------------------- *)

	(* Expand index-matching options *)
	(* FIXME: Options are expanded properly but shows 'input not expanded' warning because we have primitives as input instead of samples. *)
	expandedSafeOps=Quiet[
		Last[ExpandIndexMatchedInputs[ExperimentAcousticLiquidHandling,{myPrimitives},updatedOptions]],
		Warning::UnableToExpandInputs
	];

	(* -------------------------------- *)
	(* ---RESOLVE EXPERIMENT OPTIONS--- *)
	(* ---------------------------------*)

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentAcousticLiquidHandlingOptions[myPrimitives,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentAcousticLiquidHandlingOptions[myPrimitives,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentAcousticLiquidHandling,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests,
				invalidSourceObjectTypeTests,
				invalidDestinationDefinitionTests,
				resolvedOptionsTests
			}],
			Options->RemoveHiddenOptions[ExperimentAcousticLiquidHandling,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		experimentAcousticLiquidHandlingResourcePackets[ToList[myPrimitives],expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{experimentAcousticLiquidHandlingResourcePackets[ToList[myPrimitives],expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{
				invalidManipulationTypeTest,
				primitivesWithIncompatibleKeysTest,
				primitivesWithInvalidKeysTest,
				invalidAmountLengthTest,
				safeOpsTests,
				validLengthTests,
				templateTests,
				invalidSourceObjectTypeTests,
				invalidDestinationDefinitionTests,
				resolvedOptionsTests,
				resourcePacketTests
			}],
			Options->RemoveHiddenOptions[ExperimentAcousticLiquidHandling,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,AcousticLiquidHandling],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{
			invalidManipulationTypeTest,
			primitivesWithIncompatibleKeysTest,
			primitivesWithInvalidKeysTest,
			invalidAmountLengthTest,
			safeOpsTests,
			validLengthTests,
			templateTests,
			invalidSourceObjectTypeTests,
			invalidDestinationDefinitionTests,
			resolvedOptionsTests,
			resourcePacketTests
		}],
		Options->RemoveHiddenOptions[ExperimentAcousticLiquidHandling,collapsedResolvedOptions],
		Preview->Null
	}

];


(* ::Subsubsection::Closed:: *)
(* ExperimentAcousticLiquidHandling Option Resolver *)


DefineOptions[
	resolveExperimentAcousticLiquidHandlingOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentAcousticLiquidHandlingOptions[myPrimitives:{SampleManipulationP...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentAcousticLiquidHandlingOptions]]:=Module[
	{
		(* boilerplate variables *)
		outputSpecification,output,gatherTests,cache,samplePrepOptions,AcousticLiquidHandlingOptions,mapThreadFriendlyOptions,
		fastTrack,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,invalidInputs,invalidOptions,
		resolveSamplePrepOptionsWithoutAliquot,resolvedAliquotOptions,resolvedPostProcessingOptions,allTests,resolvedOptions,

		(* sample prep / aliquot resolution variables *)
		expandedPrepOptions,expandedSamplesIn,preferredAliquotContainers,samplesInContainerModels,allPossibleContainersInModels,
		compatibleContainersInModels,resolvedTargetContainer,expandedTargetContainers,indexMatchingAliquotOptions,
		resolvedAliquotBools,preresolvedAliquotContainer,expandedPreresolvedAliquot,expandedPreresolvedAliquotContainer,
		expandedAliquotAmounts,expandedAssayVolumes,updatedUsageVolumes,updatedPrepOptions,aliquotContainerPackets,
		requiredAliquotContainers,targetContainerDeadVolume,requiredAliquotAmounts,aliquotMessage,rawAliquotOptions,
		rawIndexMatchinAliquotOptions,fullyExpandedAliquotOptions,samplesInToVolumeTuples,groupedSamplesInVolumes,
		samplesInRequiredVolumes,tooLargeAliquotVolumeTuples,tooLargeAliquotAmounts,insufficientSampleVolumes,


		(* pre-MapThread check variables *)
		sourceSamplePackets,discardedSamplePackets,sourceSampleModels,sourceModelPacketsNoNull,sourceModelPackets,
		sourceModelStates,sourceContainers,sourceSamplesWithContainer,sourceContainersNoNull,sourceContainerPackets,
		sourceContainerModels,sourceContainerModelNoDupes,sourceContainerContents,containerWithNonInputSamples,

		(* primitives handling *)
		splitPrimitives,destinationValues,suppliedDestinationContainerModels,modelContainerTagLookup,primitivesWithResolvedDest,
		plateObjectsWithEmptyWells,plateModelAndWellTuples,plateModelAndWellTuplesNoDupes,plateToWellsAssociation,
		plateModelToWellsAssociation,simulatedDestSamplePackets,simulatedDestContainerPackets,destPlateReplaceRules,
		updatedPackets,primitivesWithSimulatedDest,updatedSimulatedCache,

		(* destination check variables *)
		resolvedDestinationLocations,specifiedDestContainerObjects,destContainerPackets,destinationContainers,
		discardedDestContainerPackets,suppliedDestContainerModelPackets,deprecatedDestContainerModelPackets,destContainerObjModels,
		destContainerObjModelPackets,allDestContainerModelPackets,specifiedInstrument,defaultInstrumentModel,instrumentModelToUse,
		instrumentModelPacket,minAllowedPlateHeight,maxAllowedPlateHeight,maxAllowedFlangeHeight,requiredCompatibilityFields,
		requiredLabwareFields,compatibleDestContainerQ,labWareQ,incompatibleDestContainerFieldsLookup,nulledRequiredFieldsLookup,
		destContainerModels,occupiedDestContainerPackets,

		(* conflicting options *)
		nameOption,validNameQ,notEmptyAliquotContainers,

		(* pre-MapThread variables *)
		specifiedPrimitives,destLocationAndAmountTuples,destLocationToAmountsAssoc,destWithMultipleSourcesAssoc,
		AcousticLiquidHandlingOptionsAssociation,optionDefinitions,indexMatchingInputOptionNames,indexMatchingInputOptions,
		primitiveExpandingFactor,expandedIndexMatchingInputOptions,allSamplePackets,allSamplesInContainerPackets,
		allSamplesContainerPackets,allSamplesContainerModelPackets,allSamplesDeadVolumes,allSamplesMaxVolumes,
		allSamplesDeadVolumesAssoc,allSamplesMaxVolumesAssoc,sampleToVolumeAssociation,volumePrecision,instrumentsMinAllowedVolume,
		instrumentsMaxAllowedVolume,dropletResolution,glycerolMolecule,dmsoMolecule,surfactantMoleculesLookup,
		surfactantWithoutMoleculeLookup,destinationObjsModelLookup,

		(* ---MapThread variables--- *)
		(* warning/error checking booleans *)
		amountPrecisionWarnings,outOfRangeAmountErrors,insufficientSourceAmountErrors,samePlateTransferErrors,
		invalidDestinationWellErrors,overFillingDestErrors,inWellSeparationNotAllowedKeyErrors,inWellSeparationConflictErrors,
		inWellSeparationNotAllowedOptionErrors,glycerolPercentageErrors,calibrationMeasurementMismatchErrors,
		calibrationInvalidOptionErrors,measurementInvalidOptionErrors,calibrationInvalidOptionWarnings,measurementInvalidOptionWarnings,
		discardedSourceSampleErrors,deprecatedSourceModelErrors,sourceStateErrors,containerlessSourceErrors,invalidSourceContainerErrors,
		discardedDestContainerErrors,deprecatedDestContainerErrors,invalidDestContainerErrors,destLabwareDefinitionErrors,
		unsafeDestVolumeErrors,invalidPrimitiveBools,indexMatchedSourceSamples,indexMatchedDestinationSamples,indexMatchedRawDestinations,

		(* resolved options *)
		resolvedFluidTypeCalibrations,resolvedFluidAnalysisMeasurements,suppliedAmounts,roundedAmounts,
		resolvedInWellSeparationOptions,expandedResolvedCalibrations,expandedResolvedMeasurements,expandedInWellSeparationOptions,
		resolvedEmailOption,

		(* defaulted options *)
		emailOption,uploadOption,confirmOption,parentProtocolOption,templateOption,samplesInStorageOption,samplesOutStorageOption,
		operatorOption,prepPrimitives,subprotocolDescriptionOption,outputOption,collapsedSamplesInStorageConditionOption,
		expandedSamplesInStorageOption,

		(* updated primitives *)
		specifiedUpdatedPrimitives,sourceToDestTuples,parentPrimitiveIndices,flatSpecifiedUpdatedPrimitives,
		samplePrepReplaceRules,allPrimitiveReplaceRules,primitivesToReturn,

		(* post-mapthread checks *)
		invalidParentPrimitiveLookup,invalidParentPrimtiveIndices,precisionWarningIndices,overlyPreciseAmounts,
		roundedOverlyPreciseAmounts,discardedSourceIndices,undiscardedSourceIndices,deprecatedSourceModelIndices,
		undeprecatedSourceModelIndices,nonLiquidSourceIndices,liquidSourceIndices,containerlessSourceIndices,
		sourceWithContainerIndices,invalidSourceContainerIndices,validSourceContainerIndices,discardedDestinationIndices,
		primitivesWithSuppliedDestObjects,undiscardedDestinationIndices,deprecatedDestinationModelIndices,
		primitivesWithSuppliedDestModels,undeprecatedDestinationIndices,indexMatchedSuppliedDestinations,incompatibleDestinationIndices,
		incompatibleDestinationObjects,compatibleDestinationIndices,compatibleDestinationObjects,invalidFieldsOfSuppliedDestObjects,
		invalidLabwareDestinationIndices,invalidLabwareDestinationObjects,validLabwareDestinationIndices,validLabwareDestinationObjects,
		nulledFieldsOfSuppliedDestObjects,unsafeDestVolumeIndices,unsafeDestVolumeObjects,safeDestVolumeTuples,safeDestVolumeObjects,
		safeDestVolumeIndices,outOfRangeAmountIndices,outOfRangeAmounts,samplesWithInsufficientVolume,samplesWithInsufficientVolumeIndices,
		samplesWithSufficientVolume,samplesWithSufficientVolumeIndices,insufficientSamplesIndexLookup,samePlateTransferIndices,
		differentPlateTransferIndices,primitivesWithInvalidDestWell,invalidDestLocationTuples,invalidDestinationWells,
		containersWithInvalidWells,primitivesWithInvalidDestWellIndices,overFilledDestSamples,overFilledSuppliedDestinations,
		overFilledSampleToSuppliedDestLookup,overFilledDestIndices,overFilledDestTuples,groupedOverFilled,overFilledDestNoDupes,
		overFilledSuppliedDestNoDupes,invalidInWellSeparationKeyIndices,validInWellSeparationKeyIndices,inWellSeparationConflictIndices,
		invalidInWellSeparationOptionIndices,validInWellSeparationOptionIndices,highGlycerolSamples,highGlycerolSamplesIndices,
		validGlycerolSamples,validGlycerolSamplesIndices,highGlycerolSamplesIndexLookup,calibrationMeasurementMismatchIndices,
		invalidCalibrationIndices,invalidMeasurementIndices,calibrationWarningSamples,calibrationWarningIndices,goodCalibrationSamples,
		goodCalibrationSamplesIndices,calibrationWarningSamplesIndexLookup,calibrationWarningSamplesNoDupes,measurementWarningSamples,
		measurementWarningIndices,goodMeasurementSamples,goodMeasurementSamplesIndices,measurementWarningSamplesIndexLookup,
		measurementWarningSamplesNoDupes,validSampleStorageConditionQ,

		(* optimize primitives variables *)
		allContainersNoDupes,optimizableQ,optimizePrimitivesOption,optimizationWarningBool,platePairs,optimizedPlatePairs,
		platePairsNoDupes,optimizedPrimitiveOrder,optimizedPrimitives,sortedInWellSeparationOptions,sortedResolvedCalibrations,
		sortedResolvedMeasurements,

		(* ---test variables--- *)
		samplePrepTests,aliquotTests,nonEmptyAliquotContainerTests,discardedSourceSampleTest,deprecatedTest,nonLiquidSourceTest,
		containerlessSampleTest,multipleSourceContainerModelTest,containerWithNonInputSampleTest,multipleDestContainerModelTest,
		validNameTest,discardedDestinationContainerTest,deprecatedDestinationContainerModelTest,invalidDestinationContainerTest,
		invalidLabwareTest,unsafeDestVolumeTest,precisionTests,outOfRangeAmountTest,insufficientSourceSampleVolumeTest,
		samePlateTransferTest,invalidDestinationWellTest,overFilledDestinationVolumeTest,invalidInWellSeparationKeyTest,
		inWellSeparationKeyOptionTest,invalidInWellSeparationOptionTest,samplesWithTooHighGlycerolTest,calibrationMeasurementMismatchTest,
		invalidFluidTypeCalibrationTest,invalidFluidAnalysisMeasurementTest,fluidTypeCalibrationWarningTest,fluidAnalysisMeasurementWarningTest,
		validSampleStorageTests,tooLargeAliquotVolumeTest,

		(* invalid input variables *)
		discardedSourceInvalidInputs,deprecatedInvalidInputs,sourceWithDeprecatedModels,sourceWithInvalidStates,
		containerlessSamples,sourceWithInvalidContainers,multipleSourceContainerTypes,discardedDestContainers,
		deprecatedDestContainerModels,incompatibleDestContainerModels,failedLabwareDestContainerModels,
		multipleDestContainerTypes,occupiedDestWithUnsafeVolume,invalidPrimitivesString,insufficientSamplesNoDupes,
		highGlycerolSamplesNoDupes,tooLargeAliquotVolSamples,

		(* invalid options variables *)
		invalidAliquotContainerOption,nameInvalidOptions,inWellSeparationConflictOption,inWellSeparationNotAllowedOption,
		calibrationMeasurementMismatchOptions,fluidTypeCalibrationErrorOption,fluidAnalysisMeasurementErrorOption,
		invalidStorageConditionOptions,notEmptyAliquotContainersOptionName
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Separate out our AcousticLiquidHandling options from our Sample Prep options. *)
	{samplePrepOptions,AcousticLiquidHandlingOptions}=Experiment`Private`splitPrepOptions[myOptions];

	(* pull out the FastTrack option *)
	fastTrack=Lookup[AcousticLiquidHandlingOptions,FastTrack];

	(* ---------------------- *)
	(* ---EXPAND SamplesIn--- *)
	(* ---------------------- *)

	(* it is possible that each specified source sample may need multiple aliquots in the actual source plate *)
	(* although the sample's volume may be enough to perform all specified manipulations, *)
	(* single source well of Echo plate may not be able to accommodate the required usage volume *)
	(* we have to mapthread over SamplesIn and SamplesVolume to check and expand SamplesIn if necessary *)
	(* we do this upfront so that we have an accurate list of SamplesIn to simulate our samples *)

	(* re-expand our SamplePrepOptions *)
	(* do this because some options are not expanded properly as we indexmatch them with SamplesIn option instead of the inputs *)
	(* TODO: AliquotContainer only get expanded if specified as a Model. Not sure why Object[Container] doesn't get expanded *)
	expandedPrepOptions=Last[ExpandIndexMatchedInputs[Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions,{Lookup[myOptions,SamplesIn]},samplePrepOptions]];

	(* set the preferred aliquot container *)
	preferredAliquotContainers=ToList[PreferredContainer[All,Type->All,AcousticLiquidHandlerCompatible->True]]/.x:ObjectReferenceP[]:>Download[x,Object];

	(* get the model of each sample's container *)
	(* also handles samples with Container -> Null which can happen for Discarded samples *)
	samplesInContainerModels=Map[
		Module[{container},
			container=Lookup[fetchPacketFromCache[#,cache],Container];
			(* return Null for container-less sample *)
			Switch[container,
				ObjectP[],Download[Lookup[fetchPacketFromCache[container,cache],Model],Object],
				_,Null
			]
		]&,
		Lookup[myOptions,SamplesIn]
	];

	(* get all the containers that the source samples are in or will be in *)
	allPossibleContainersInModels=DeleteDuplicates[MapThread[
		Function[{samplesContainerModel,aliquotContainer},
			Switch[{samplesContainerModel,aliquotContainer},
				(* return Nothing for container-less sample *)
				{Null,_},
					Nothing,

				(* if AliquotContainer is specified by the user as a container model, return the as is *)
				{_,ObjectP[Model[Container]]},
					aliquotContainer,

				(* if AliquotContainer is specified by the user as a container object, return the container's model *)
				{_,ObjectP[Object[Container]]},
					Download[Lookup[fetchPacketFromCache[aliquotContainer,cache],Model],Object],

				(* Otherwise, return the sample's current container model *)
				_,
					samplesContainerModel
			]
		],
		{samplesInContainerModels,Lookup[expandedPrepOptions,AliquotContainer]}
	]];

	(* get the compatible ContainersIn model *)
	compatibleContainersInModels=Cases[allPossibleContainersInModels,ObjectP[preferredAliquotContainers]];

	(* resolve our target container for aliquot option resolution *)
	(* we cannot allow multiple types of Echo Qualified plates in a single protocol so we will need to find the best target container here *)
	resolvedTargetContainer=Module[{maxWellVolumeTuples},
		Which[
			(* if only one compatible container exist, return that object *)
			Length[compatibleContainersInModels]==1,
			First[compatibleContainersInModels],

			(* if more than one type of compatible containers exist, select the one with the lowest max well volume *)
			Length[compatibleContainersInModels]>1,
			maxWellVolumeTuples=Lookup[fetchPacketFromCache[#,cache],{Object,MaxVolume}]&/@compatibleContainersInModels;
			First@First@SortBy[maxWellVolumeTuples,Last],

			(* if none of the samples are in compatible containers, set to preferred container with largest well volume *)
			True,
			Last[preferredAliquotContainers]
		]
	];

	(* expand target container to match SamplesIn *)
	(* normally resolveAliquotOptions will handle this but we want to get resolved Aliquot bool to resolved some options before sample simulation *)
	expandedTargetContainers=Map[
		If[MatchQ[#,ObjectP[resolvedTargetContainer]],
			(* return Null if our sample's container model matches resolved target container *)
			Null,
			(* otherwise, return the resolved target container *)
			resolvedTargetContainer
		]&,
		samplesInContainerModels
	];

	(* get the index matching shared aliquot options *)
	indexMatchingAliquotOptions={
		Aliquot,AliquotAmount,TargetConcentration,TargetConcentrationAnalyte,AssayVolume,AliquotContainer,DestinationWell,
		ConcentratedBuffer,BufferDilutionFactor,BufferDiluent,AssayBuffer,AliquotSampleStorageCondition
	};

	(* --- Manually resolve a few options --- *)
	(* get the resolved Aliquot bool; this is True if anything is specified, and false if nothing is specified*)
	(* It is important to note that the RequiredAliquotAmount option does not switch on our aliquotting ability. We will only use it in pre-resolving if we decided here that we're going to aliquot. *)
	resolvedAliquotBools=MapThread[
		Function[{aliquot,aliquotAmount,targetConc,targetConcAnalyte,assayVolume,aliquotContainer,destinationWell,concBuffer,bufferDilutionFactor,bufferDiluent,assayBuffer,storageCondition,targetContainer},
			Which[
				(* if Aliquot is specified, use that *)
				MatchQ[aliquot,BooleanP],aliquot,

				(* if any of the other aliquot options are anything besides Null or Automatic, then resolve aliquot to True *)
				MemberQ[Flatten[{aliquotAmount,targetConc,targetConcAnalyte,assayVolume,aliquotContainer,destinationWell,concBuffer,bufferDilutionFactor,bufferDiluent,assayBuffer,storageCondition,targetContainer}],Except[Null|Automatic]],True,

				(* otherwise resolve to False *)
				True,False
			]
		],
		(* Lookup our aliquot index-matching options and append our target containers to it. *)
		{Sequence@@Lookup[expandedPrepOptions,indexMatchingAliquotOptions],expandedTargetContainers}
	];

	(* pre-resolve AliquotContainer to make our simulated sample accurate *)
	(* it is important to properly simulate our samples so that we can resolve/check correctly downstream *)
	preresolvedAliquotContainer=MapThread[
		Function[{aliquotBool,aliquotContainer},
			Switch[{aliquotBool,aliquotContainer},
				(* if Aliquot -> False, set to Null *)
				{False,_},Null,
				(* if Aliquot -> True and AliquotContainer -> Automatic, set to our preferred aliquot container *)
				{True,Automatic},resolvedTargetContainer,
				(* Otherwise, return as is *)
				_,aliquotContainer
			]
		],
		{resolvedAliquotBools,Lookup[expandedPrepOptions,AliquotContainer]}
	];

	(* expand SamplesIn if needed *)
	(* TODO: check if we can handle specified AliquotAmount/AssayAmount *)
	{
		expandedSamplesIn,
		expandedPreresolvedAliquot,
		expandedPreresolvedAliquotContainer,
		expandedAliquotAmounts,
		expandedAssayVolumes,
		updatedUsageVolumes
	}=Transpose[MapThread[
		Function[{sample,usage,aliquot,aliquotContainer,aliquotAmount,assayVolume},
			If[!TrueQ[aliquot],
				(* return unexpanded sample if Aliquot -> False *)
				{sample,aliquot,aliquotContainer,aliquotAmount,assayVolume,usage},

				If[!MatchQ[resolvedTargetContainer,aliquotContainer],
					(* return unexpanded sample if AliquotContainer is not one of the preferred containers *)
					{sample,aliquot,aliquotContainer,aliquotAmount,assayVolume,usage},

					Switch[{aliquotAmount,assayVolume},
						(* if both AliquotAmount and AssayVolume are Automatic, we are good to aliquot according to the usage volume *)
						{Automatic,Automatic},
							Module[{minWellVolume,maxWellVolume,usableVolume,expandFactor,updatedUsage},
								(* get the min and max well volume from the container model packet *)
								{minWellVolume,maxWellVolume}=Lookup[fetchPacketFromCache[aliquotContainer,cache],{MinVolume,MaxVolume}];

								(* calculate usable volume in each well *)
								usableVolume=maxWellVolume-minWellVolume;

								(* calculate the number of wells we need to aliquot the sample into to satisfy the usage volume *)
								expandFactor=Ceiling[usage/usableVolume];

								(* calculate updated usage volume for each of the expanded sample *)
								updatedUsage=Append[ConstantArray[maxWellVolume,(expandFactor-1)],(Mod[usage,usableVolume]+minWellVolume)];

								(* expand the sample according the number of wells needed to satisfy the usage volume *)
								{
									ConstantArray[sample,expandFactor],
									ConstantArray[aliquot,expandFactor],
									ConstantArray[aliquotContainer,expandFactor],
									ConstantArray[aliquotAmount,expandFactor],
									(* also return updated assay volume for each of the expanded sample. we're using the updated usage here *)
									updatedUsage,
									updatedUsage
								}
							],
						(* Otherwise, we will have to stick with the defined AliquotAmount and AssayVolume option value *)
						_,
							{sample,aliquot,aliquotContainer,aliquotAmount,assayVolume,usage}
					]
				]
			]
		],
		(* lists that we are mapthreading over *)
		{
			Lookup[myOptions,SamplesIn],
			Lookup[myOptions,SamplesVolume],
			resolvedAliquotBools,
			preresolvedAliquotContainer,
			Sequence@@Lookup[expandedPrepOptions,{AliquotAmount,AssayVolume}]
		}
	]];

	(* ---further expand our raw aliquot options that are index-matched to SamplesIn if any samples got expanded.
	the rest of the non-aliquot sample prep options will be fully expanded in sample prep options resolver--- *)

	(* separate out our AliquotOptions from our Sample Prep options. *)
	rawAliquotOptions=First[Experiment`Private`splitPrepOptions[expandedPrepOptions,PrepOptionSets->{AliquotOptions}]];

	(* select only the index-matching aliquot options *)
	(* Note: at this point AliquotContainer and DestinationWell are treated as index-matching options *)
	rawIndexMatchinAliquotOptions=Select[rawAliquotOptions,MatchQ[Last[#],_List]&];

	(* fully expand our raw aliquot options *)
	fullyExpandedAliquotOptions=If[Length[Lookup[myOptions,SamplesIn]]==Length[Flatten[expandedSamplesIn]],
		(* return as is if we didn't expand any SamplesIn further *)
		rawIndexMatchinAliquotOptions,
		(* we have expanded SamplesIn so we have to expande raw aliquot options for those samples *)
		Module[{mapThreadAliquotOptions,expandedMapThreadOps},
			(* convert raw aliquot options into mapthread-friendly format *)
			(* Note: raw aliquot options is currently expanded and index-matched to un-expanded SamplesIn *)
			mapThreadAliquotOptions=Transpose[KeyValueMap[
				Function[{key,value},
					Map[(key->#)&,value]
				],
				Association@rawIndexMatchinAliquotOptions
			]];

			(* duplicate mapthread options for SamplesIn that were expanded *)
			expandedMapThreadOps=Flatten[MapThread[
				Switch[#1,
					(* expanded samples are in a nested list, if encounter a list duplicate based on number of expanded sample *)
					_List,ConstantArray[#2,Length[#1]],
					(* return as is for un-expanded samples *)
					_,#2
				]&,
				{expandedSamplesIn,mapThreadAliquotOptions}
			]];

			(* convert the option list back into its original format by grouping based on option name *)
			(* Note: values of each option are now index-matched to the expanded SamplesIn *)
			Normal@GroupBy[expandedMapThreadOps,First->Last]
		]
	];

	(* update sample prep options with pre-resolved Aliquot and AliquotContainer options *)
	updatedPrepOptions=ReplaceRule[expandedPrepOptions,
		{
			Aliquot->Flatten[expandedPreresolvedAliquot],
			AliquotContainer->Flatten[expandedPreresolvedAliquotContainer],
			AliquotAmount->Flatten[expandedAliquotAmounts],
			AssayVolume->Flatten[expandedAssayVolumes]
		}
	];

	(* --------------------------------- *)
	(* ---RESOLVE SAMPLE PREP OPTIONS--- *)
	(* --------------------------------- *)

	(* resolveSamplePrepOptions is not happy with our input format using primitives instead of samples *)
	(* defined a private function here to work around this issue where we can use SamplesIn option that we populated in the main experiment function as 'experiment samples' and use the normal index-matching prep option definitions *)
	(* TODO: samplePrepTests seems to be returned as {}. double check if this happens in every cases *)
	{
		{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests
	}=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[
		Flatten[expandedSamplesIn],
		Sequence@@updatedPrepOptions,
		Cache->cache,
		Output->output
	];

	(* ----------------------------- *)
	(* ---RESOLVE ALIQUOT OPTIONS--- *)
	(* ----------------------------- *)

	(* get the specified aliquot container packets from our cache *)
	aliquotContainerPackets=fetchPacketFromCache[#,simulatedCache]&/@DeleteDuplicates[Cases[Lookup[samplePrepOptions,AliquotContainer],ObjectP[Object[Container]],Infinity]];

	(* pick the specified aliquot containers that are not empty *)
	{notEmptyAliquotContainers,notEmptyAliquotContainersOptionName}=If[MatchQ[aliquotContainerPackets,{}],
		{{},{}},
		{Lookup[Select[Flatten[aliquotContainerPackets],Not[MatchQ[Lookup[#,Contents],{}]]&],Object],{AliquotContainer}}
	];

	(* if there are any occupied containers, throw an error *)
	If[Not[MatchQ[notEmptyAliquotContainers,{}]]&&!gatherTests,
		Message[Error::AliquotContainerOccupied,ObjectToString[notEmptyAliquotContainers,Cache->simulatedCache]];
	];

	(* if we are gathering tests, create a test for the AliquotContainer option *)
	nonEmptyAliquotContainerTests=If[gatherTests,
		Test["The AliquotContainer option does not include already-occupied container objects:",
			MatchQ[notEmptyAliquotContainers,{}],
			True
		],
		Nothing
	];

	(* stash the invalid option *)
	invalidAliquotContainerOption=If[MatchQ[notEmptyAliquotContainers,{}],
		{},
		AliquotContainer
	];

	(* ---resolve aliquot container and amount for each sample--- *)

	(* get the RequiredAliquotContainers from the target container that we resolved above. this list is index-matched to simulated samples *)
	requiredAliquotContainers=Map[
		Switch[#,
			Alternatives[Automatic,True],resolvedTargetContainer,
			(* if Aliquot -> False, set to Null *)
			_,Null
		]&,
		Lookup[fullyExpandedAliquotOptions,Aliquot]
	];

	(* get the dead volume of the target container *)
	targetContainerDeadVolume=Lookup[fetchPacketFromCache[resolvedTargetContainer,simulatedCache],MinVolume];

	(* get the RequiredAliquotAmount from the usage amount of each of our expanded SamplesIn *)
	(* note that expandedAssayVolume and updatedUsageVolumes are index-matched to expandedSamplesIn *)
	requiredAliquotAmounts=MapThread[
		Function[{assayVolume,usage},
			(* update the usage volume to account for the target container's dead volume *)
			Switch[assayVolume,
				(* if AssayVolume is still Automatic at this point, we didn't expand that sample. we need to update it by padding with target container's dead volume *)
				Automatic,SafeRound[(usage+targetContainerDeadVolume),10^-1 Microliter,Round->Up],
				(* otherwise, AssayVolume already reflects the updated usage volume *)
				_,assayVolume
			]
		],
		{Flatten[expandedAssayVolumes],Flatten[updatedUsageVolumes]}
	];

	(* define a warning message to throw if we must aliquot the user's sample for container compatibility reason *)
	aliquotMessage=Which[
		ContainsOnly[allPossibleContainersInModels,preferredAliquotContainers],
			"because the provided samples are located in compatible containers with different models. The model of the provided compatible container with the lowest dead volume is selected as the required target container to minimize the unusable amount of the aliquoted samples.",
		ContainsNone[allPossibleContainersInModels,preferredAliquotContainers],
			"because the provided samples are not in a container that is compatible with the instrument. The default compatible container model is chosen as the required target container.",
		True,
			"because the provided samples are not in a container that is compatible with the instrument, or in the same container Model as the other samples. The model of the provided compatible container with the lowest dead volume is selected as the required target container to minimize the unusable amount of the aliquoted samples."
	];

	(* Resolve Aliquot Options *)
	(* Note: we quiet Warning::TotalAliquotVolumeTooLarge in aliquot resolver because we're will throw an ERROR below *)
	{resolvedAliquotOptions,aliquotTests}=Quiet[If[gatherTests,
		(* we don't allow solid samples here *)
		resolveAliquotOptions[
			resolveAcousticLiquidHandlingSamplePrepOptions,
			Flatten[expandedSamplesIn],
			simulatedSamples,
			ReplaceRule[myOptions,Flatten[{fullyExpandedAliquotOptions,resolvedSamplePrepOptions}]],
			Cache->simulatedCache,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AllowSolids->False,
			AliquotWarningMessage->aliquotMessage,
			Output->{Result,Tests}
		],
		{resolveAliquotOptions[
			resolveAcousticLiquidHandlingSamplePrepOptions,
			Flatten[expandedSamplesIn],
			simulatedSamples,
			ReplaceRule[myOptions,Flatten[{fullyExpandedAliquotOptions,resolvedSamplePrepOptions}]],
			Cache->simulatedCache,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AllowSolids->False,
			AliquotWarningMessage->aliquotMessage,
			Output->Result],{}
		}
	],{Warning::TotalAliquotVolumeTooLarge,Warning::InsufficientVolume}];

	(* -------------------------- *)
	(* ---ALIQUOT AMOUNT CHECK--- *)
	(* -------------------------- *)

	(* simulated samples can have the volumes that exceed the actual pre-aliquoted volume of the input sample.
	we need to check here and throw a hard error because the aliquot resolver will only throw a warning *)
	(* Note: only check this if Aliquot -> True for each source sample *)

	(* create tuples in the from {sample,requiredAliquitAmount} for source samples that Aliquot resolved to True *)
	samplesInToVolumeTuples=MapThread[
		Function[{sampleIn,requiredVol,aliquotBool},
			If[TrueQ[aliquotBool],
				{sampleIn,requiredVol},
				Nothing
			]
		],
		{Flatten[expandedSamplesIn],requiredAliquotAmounts,Lookup[resolvedAliquotOptions,Aliquot]}
	];

	(* group the required aliquot amount by the source samples *)
	groupedSamplesInVolumes=GroupBy[samplesInToVolumeTuples,First->Last];

	(* fine the total required aliquot amount for each source sample *)
	samplesInRequiredVolumes=Total/@groupedSamplesInVolumes;

	(* create tuples for invalid source samples in the form {{invalidSamples},{tooLargeAliquotAmounts},{invalidSamplesVolumes}} *)
	tooLargeAliquotVolumeTuples=KeyValueMap[
		Function[{sample,requiredVolume},
			With[{
				samplesVolume=Lookup[fetchPacketFromCache[sample,cache],Volume]
			},
				If[MatchQ[requiredVolume,GreaterP[samplesVolume]],
					(* if the required aliquot amount is larger than the sample's volume, return
					{sample,requiredVol,samplesVolume *)
					{sample,requiredVolume,samplesVolume},
					(* otherwise, return an empty list *)
					{{},{},{}}
				]
			]
		],
		samplesInRequiredVolumes
	];

	(* separate out the invalid samples, required aliquot amounts, and samples' volumes *)
	{tooLargeAliquotVolSamples,tooLargeAliquotAmounts,insufficientSampleVolumes}=If[MatchQ[tooLargeAliquotVolumeTuples,{}],
		{{},{},{}},
		Map[Flatten,Transpose@tooLargeAliquotVolumeTuples]
	];

	(* throw an error message for any of the source samples with volume not enough to aliquot *)
	If[Not[MatchQ[tooLargeAliquotVolSamples,{}]]&&!gatherTests,
		Message[Error::TotalAliquotVolumeTooLarge,
			tooLargeAliquotAmounts,
			ObjectToString[tooLargeAliquotVolSamples,Cache->simulatedCache],
			insufficientSampleVolumes
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooLargeAliquotVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooLargeAliquotVolSamples]==0,
				Nothing,
				Test["The provided source samples "<>ObjectToString[tooLargeAliquotVolSamples,Cache->simulatedCache]<>" have enough volumes to satisfy the required aliquot amount:",True,False]
			];

			passingTest=If[Length[tooLargeAliquotVolSamples]==Length[Keys[samplesInRequiredVolumes]],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[Keys[samplesInRequiredVolumes],tooLargeAliquotVolSamples],Cache->simulatedCache]<>" have enough volumes to satisfy the required aliquot amount:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* ----------------------------- *)
	(* ---INPUT VALIDATION CHECKS--- *)
	(* ----------------------------- *)

	(* ---1. DISCARDED SOURCE SAMPLE CHECK--- *)

	(* get the source sample packets from cache *)
	sourceSamplePackets=fetchPacketFromCache[#,simulatedCache]&/@simulatedSamples;

	(* Get the samples from sourceSamplePackets that are discarded. *)
	discardedSamplePackets=Cases[sourceSamplePackets,KeyValuePattern[Status->Discarded]];

	(* check if any of the source samples are discarded *)
	discardedSourceInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* ---2. DEPRECATED SOURCE SAMPLE MODEL CHECK--- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	sourceSampleModels=Download[Lookup[sourceSamplePackets,Model],Object];

	(* get the model packets from cache *)
	sourceModelPackets=fetchPacketFromCache[#,simulatedCache]&/@sourceSampleModels;

	(* get only the packets to ensure there's no Null from model-less sample *)
	sourceModelPacketsNoNull=Cases[sourceModelPackets,PacketP[]];

	(* get the model packets that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedInvalidInputs=If[Not[fastTrack],
		Flatten[Lookup[Cases[sourceModelPacketsNoNull,KeyValuePattern[Deprecated->True]],Object,{}]],
		{}
	];

	(* get the source samples with deprecated models *)
	sourceWithDeprecatedModels=Cases[sourceSamplePackets,packet:KeyValuePattern[Model->ObjectP[deprecatedInvalidInputs]]:>packet[Object]];

	(* ---3. SOURCE SAMPLE STATE CHECK--- *)
	(* we only allow liquid samples *)

	(* get the state from each sample's model packet *)
	sourceModelStates=Map[
		Switch[#,
			(* packets from model-less sample can be Null, but we want to maintain index, so return Null *)
			Null,Null,
			_,Lookup[#,State]
		]&,
		sourceModelPackets
	];

	(* get the source samples with non-liquid state. don't bother checking if we're on FastTrack *)
	sourceWithInvalidStates=If[Not[fastTrack],
		MapThread[
			Function[{sourceSample,sourceState,sourceModelState},
				Switch[{sourceState,sourceModelState},
					{Liquid,_},Nothing,
					{_,Liquid},Nothing,
					_,sourceSample
				]
			],
			{simulatedSamples,Lookup[sourceSamplePackets,State],sourceModelStates}
		],
		{}
	];

	(* ---4. CONTAINER-LESS SAMPLE CHECK--- *)

	(* get the containers of our source samples *)
	sourceContainers=Download[Lookup[sourceSamplePackets,Container],Object];

	(* get the samples that are not in a container *)
	containerlessSamples=PickList[simulatedSamples,sourceContainers,Null];

	(* ---5. SOURCE PLATE COMPATIBILITY CHECK--- *)
	(* now that we have simulated all the source samples, we check if they are in containers that are compatible with our instrument*)

	(* get the samples that are in a container *)
	sourceSamplesWithContainer=PickList[simulatedSamples,sourceContainers,Except[Null]];

	(* remove Null from the list of our source containers *)
	sourceContainersNoNull=Cases[sourceContainers,Except[Null]];

	(* get the packet of each container *)
	sourceContainerPackets=fetchPacketFromCache[#,simulatedCache]&/@sourceContainersNoNull;

	(* get the model of each container *)
	sourceContainerModels=Download[Lookup[sourceContainerPackets,Model,{}],Object];

	(* get the source samples with incompatible containers. combine with container-less samples since we consider them as having invalid containers *)
	sourceWithInvalidContainers=Flatten[{
		PickList[sourceSamplesWithContainer,sourceContainerModels,Except[ObjectP[preferredAliquotContainers]]],
		containerlessSamples
	}];

	(* ---6. CHECK IF ALL SOURCE PLATES HAVE THE SAME MODEL--- *)
	(* although we allow multiple source containers, they all need to share the same model *)

	(* delete duplicates from the source container model list *)
	sourceContainerModelNoDupes=DeleteDuplicates[sourceContainerModels];

	(* throw an error message if all the source containers do not share the same model *)
	If[(Length[sourceContainerModelNoDupes]>1)&&!gatherTests,
		Message[Error::MultipleSourceContainerModels]
	];

	(* if we are gathering tests, create a test for multiple source container models *)
	multipleSourceContainerModelTest=If[gatherTests,
		Test["All the source containers share the same container model:",
			Length[sourceContainerModelNoDupes]==1,
			True
		],
		Nothing
	];

	(* stash the containers to return as invalid inputs if multiple types were supplied by the user *)
	multipleSourceContainerTypes=If[Length[sourceContainerModelNoDupes]>1,
		sourceContainerModelNoDupes,
		{}
	];

	(* ---7. SOURCE PLATE WITH NON-INPUT SAMPLES CHECK--- *)

	(* get all the samples located in the source containers *)
	sourceContainerContents=Lookup[sourceContainerPackets,Contents,{}];

	(* get the source containers that have non-input samples. skip this check if we are on FastTrack *)
	containerWithNonInputSamples=If[fastTrack,
		{},
		DeleteDuplicates[MapThread[
			Function[{container,contents},
				Module[{contentSamples,nonInputSamples},
					(* get the content samples *)
					contentSamples=Download[contents[[All,2]],Object];
					(* get the non-input samples in the container if any *)
					nonInputSamples=Complement[contentSamples,simulatedSamples];
					(* if non-input sample exists, return that container *)
					If[MatchQ[nonInputSamples,{}],
						Nothing,
						container
					]
				]
			],
			{sourceContainersNoNull,sourceContainerContents}
		]]
	];

	(* throw a warning message if the source container have non-input sample *)
	If[Not[MatchQ[containerWithNonInputSamples,{}]]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::ContainerWithNonInputSamples,ObjectToString[containerWithNonInputSamples,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerWithNonInputSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[containerWithNonInputSamples,{}],
				Nothing,
				Warning["The provided source containers "<>ObjectToString[containerWithNonInputSamples,Cache->simulatedCache]<>" do not contain samples that are not inputs to our experiment:",True,False]
			];

			passingTest=If[Length[containerWithNonInputSamples]==Length[DeleteDuplicates[sourceContainersNoNull]],
				Nothing,
				Warning["The provided source containers "<>ObjectToString[Complement[sourceContainersNoNull,containerWithNonInputSamples],Cache->simulatedCache]<>" do not contain samples that are not inputs to our experiment:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --------------------------------------------- *)
	(* ---RESOLVE AND SIMULATE DESTINATION SAMPLE--- *)
	(* --------------------------------------------- *)

	(* get our split primitives (individual Transfer primitives) from the options *)
	(* these primitives were converted to Transfer and specified in the main function *)
	splitPrimitives=Lookup[myOptions,ResolvedManipulations];

	(* get the user specified Destination Value from our primitives *)
	destinationValues=Map[#[Destination]& splitPrimitives];

	(* get only the specified container model from the Destination Values *)
	suppliedDestinationContainerModels=DeleteDuplicates[Cases[destinationValues,ObjectP[Model[Container]],Infinity]]/.x:ObjectReferenceP[]:>Download[x,Object];

	(* create lookup table with a unique tag for each container model *)
	modelContainerTagLookup=Map[
		#->Unique[]&,
		suppliedDestinationContainerModels
	];

	(* simulate destination samples *)
	(* we only need an actual object in the specified plate model here so that we can re-specify primitives and use to resolve/check options downstream *)
	{primitivesWithResolvedDest,plateModelAndWellTuples}=Transpose[Map[
		Function[primitive,
			Module[{rawDestination,destinationLocation,plateWellTuple,updatedPrimitive},
				(* get the raw Destination and location from our split Transfer primitive *)
				(* Note: Destination is now in a nested {{value}} format *)
				rawDestination=First@First@primitive[Destination]/.x:ObjectReferenceP[]:>Download[x,Object];
				(* Note: ResolvedDestinationLocation is in the form {value} *)
				destinationLocation=First@primitive[ResolvedDestinationLocation];

				plateWellTuple=Switch[{destinationLocation,rawDestination},
					(* specified as Object[Sample] in a plate or {plate, well} format *)
					(* for this case, DestinationLocation is already resolved to PlateWellP *)
					(* we will also need to simulate sample for an empty well, so check for that *)
					{PlateAndWellP,_},
						If[NullQ[primitive[DestinationSample]],
							(* if DestinationSample is still Null, we have an empty well. return the information to use for simulation *)
							destinationLocation,
							(* otherwise, return Null so we can filter it out from the list later *)
							Null
						],
					(* specified in {{tag, plateModel}, well} format *)
					{Null,{{_,ObjectReferenceP[Model[Container,Plate]]},WellPositionP}},
						{
							rawDestination[[1]],
							rawDestination[[2]]
						},
					(* specified in {tag, plateModel} format *)
					{Null,{_,ObjectReferenceP[Model[Container,Plate]]}},
						{
							rawDestination,
							"A1"
						},
					(* specified in {plateModel, well} format *)
					{Null,{ObjectReferenceP[Model[Container,Plate]],WellPositionP}},
						{
							{(rawDestination[[1]]/.modelContainerTagLookup),rawDestination[[1]]},
							rawDestination[[2]]
						},
					(* specified as a plate model *)
					{Null,ObjectReferenceP[Model[Container,Plate]]},
						{
							{(rawDestination/.modelContainerTagLookup),rawDestination},
							"A1"
						}
				]/.x:ObjectReferenceP[]:>Download[x,Object];

				(* update Destination value of the primitive *)
				updatedPrimitive=If[NullQ[plateWellTuple],
					primitive,
					Transfer[
						(* put updated destination into the same nested list format as converted Transfer primitive *)
						Append[KeyDrop[Association@@primitive,Destination],Destination->{{plateWellTuple}}]
					]
				];

				(* return the results *)
				{updatedPrimitive,plateWellTuple}
			]
		],
		splitPrimitives
	]];

	(* --this section is a work around to simulate samples for empty wells in container specified as object--- *)
	(* Note: we do this so that we can perform volume tracking easily in the mapthread below *)

	(* get the plates specified as objects from the tuples list  *)
	plateObjectsWithEmptyWells=DeleteDuplicates[Cases[plateModelAndWellTuples,ObjectP[Object[Container]],Infinity]];

	(* delete duplicates from the plateModelAndWellTuples and remove Null from the list *)
	(* also replace container object with its container model and an assigned unique tag *)
	plateModelAndWellTuplesNoDupes=Cases[DeleteDuplicates[plateModelAndWellTuples],Except[Null]];

	(* create an association with unique plates as keys and each one point to wells to be occupied with new samples *)
	plateToWellsAssociation=Map[#[[All,2]]&,GroupBy[plateModelAndWellTuplesNoDupes,First]];

	(* replace keys that are still container object with its model with unique tags *)
	plateModelToWellsAssociation=KeyMap[
		Switch[#,
			ObjectP[],{Unique[],Download[Lookup[fetchPacketFromCache[#,simulatedCache],Model],Object]},
			_,#
		]&,
		plateToWellsAssociation
	];

	(* simulate destination samples for destination container specified as models *)
	{simulatedDestSamplePackets,simulatedDestContainerPackets}=If[MatchQ[plateModelToWellsAssociation,<||>],
		(* if we don't have any model container as a destination, return empty lists *)
		{{},{}},
		(* otherwise, simulate destination samples *)
		Transpose[KeyValueMap[
			Function[{plateModelWithTag,wells},
				SimulateSample[
					ConstantArray[Model[Sample,"Milli-Q water"],Length[wells]],
					"simulated destination",
					wells,
					plateModelWithTag[[2]],
					ConstantArray[{Volume->0 Liter},Length[wells]]
				]
			],
			plateModelToWellsAssociation
		]]
	];

	(* create replace rules to update our primitives with simulated destination plate *)
	destPlateReplaceRules=MapThread[
		#1->#2&,
		{Keys[plateModelToWellsAssociation],Lookup[simulatedDestContainerPackets,Object,{}]}
	];

	(* manually update the container packet and destination sample packet if we simulated a new sample into a container that is specified as an object *)
	updatedPackets=Flatten[MapThread[
		Function[{container,simulatedPacket},
			(* select container that is specified as an object *)
			If[MatchQ[container,ObjectP[Object[Container]]],
				Module[{rawContainerPacket,rawContents,simulatedContents,updatedContainerPacket,newSamples,updatedSimulatedSamplePackets},
					(* get the raw container packet *)
					rawContainerPacket=fetchPacketFromCache[container,simulatedCache];
					(* get the contents from the raw container packets *)
					rawContents=Lookup[rawContainerPacket,Contents];
					(* get the contents from the simulated destination container packet *)
					simulatedContents=Lookup[simulatedPacket,Contents];
					(* update the contents of the raw container packet with simulated samples *)
					updatedContainerPacket=AssociateTo[rawContainerPacket,Contents->Join[rawContents,simulatedContents]];
					(* get the simulated samples from the contents *)
					newSamples=Cases[simulatedContents,ObjectReferenceP[Object[Sample]],Infinity];
					(* update Container Field in the simulated sample to have the corect container *)
					updatedSimulatedSamplePackets=Map[
						Module[{packet},
							packet=fetchPacketFromCache[#,Flatten[simulatedDestSamplePackets]];
							AssociateTo[packet,Container->Link[container]]
						]&,
						newSamples
					];
					(* return the updated container and simulated sample packets *)
					{updatedContainerPacket,updatedSimulatedSamplePackets}

				],
				Nothing
			]
		],
		{Keys@plateToWellsAssociation,simulatedDestContainerPackets}
	]];

	(* update our primitives with the simulated destination plate *)
	primitivesWithSimulatedDest=primitivesWithResolvedDest/.destPlateReplaceRules;

	(* update our simulatedCache with newly created destination sample/container packets *)
	updatedSimulatedCache=Experiment`Private`FlattenCachePackets[{updatedPackets,simulatedCache,simulatedDestSamplePackets,simulatedDestContainerPackets}];

	(* ----------------------------------- *)
	(* ---DESTINATION VALIDATION CHECKS--- *)
	(* ----------------------------------- *)

	(* ---1. DISCARDED DESTINATION CONTAINER CHECK--- *)

	(* get the ResolvedDestinationLocation from the primitives *)
	(* if specified as Object[Sample], or Object[Container, Plate] by the user, it would have been populated already when we specified primitives in the main function *)
	resolvedDestinationLocations=Map[#[ResolvedDestinationLocation]&,splitPrimitives];

	(* get only the Object[Container] from ResolvedDestinationLocation values *)
	specifiedDestContainerObjects=DeleteDuplicates[Cases[resolvedDestinationLocations,ObjectP[Object[Container]],Infinity]];

	(* get the destination container packets from cache *)
	destContainerPackets=fetchPacketFromCache[#,simulatedCache]&/@specifiedDestContainerObjects;

	(* get the destination container objects *)
	destinationContainers=Flatten[Lookup[destContainerPackets,Object,{}]];

	(* get the discarded container packets *)
	discardedDestContainerPackets=Cases[destContainerPackets,KeyValuePattern[Status->Discarded]];

	(* get the discarded container objects *)
	(* we are not creating test/throwing error here. we will check against this list as we map over our primitives below *)
	discardedDestContainers=If[MatchQ[discardedDestContainerPackets,{}],
		{},
		Lookup[discardedDestContainerPackets,Object]
	];

	(* ---2. DEPRECATED DESTINATION CONTAINER MODEL CHECK--- *)
	(* if Destination is specified as a model, check if it is deprecated *)

	(* get the packet for each destination container model *)
	suppliedDestContainerModelPackets=fetchPacketFromCache[#,simulatedCache]&/@suppliedDestinationContainerModels;

	(* get the deprecated container model packets *)
	deprecatedDestContainerModelPackets=Cases[suppliedDestContainerModelPackets,KeyValuePattern[Deprecated->True]];

	(* get the deprecated container model *)
	(* we are not creating test/throwing error here. we will check against this list as we map over our primitives below *)
	deprecatedDestContainerModels=If[MatchQ[deprecatedDestContainerModelPackets,{}],
		{},
		Lookup[deprecatedDestContainerModelPackets,Object]
	];

	(* ---3. DESTINATION PLATE COMPATIBILITY CHECK--- *)

	(* get the model packet for the destination container specified as container object if any *)
	destContainerObjModels=Lookup[destContainerPackets,Model,{}];

	(* get the model packets *)
	destContainerObjModelPackets=fetchPacketFromCache[#,simulatedCache]&/@destContainerObjModels;

	(* combine with the destination container model packets we already collected. Call FlattenCachePackets to make sure we don't have multiple packets per mode *)
	allDestContainerModelPackets=Experiment`Private`FlattenCachePackets[{suppliedDestContainerModelPackets,destContainerObjModelPackets}];

	(* pull out all the objects specified in the Instrument option *)
	specifiedInstrument=Lookup[myOptions,Instrument];

	(* get the default instrument from our experiment option *)
	(* do the following so that we don't have to change the default in multiple locations when needed *)
	defaultInstrumentModel=Lookup[Options[ExperimentAcousticLiquidHandling],"Instrument"];

	(* get the instrument model that we are going to use *)
	(* don't have to worry about link stripping here. we'll let fetchPacketFromCache handel it *)
	instrumentModelToUse=Switch[specifiedInstrument,
		ObjectP[defaultInstrumentModel],defaultInstrumentModel,
		ObjectP[Model[Instrument]],specifiedInstrument,
		_,Lookup[fetchPacketFromCache[specifiedInstrument,simulatedCache],Model]
	];

	(* get the instrument model packet from cache *)
	instrumentModelPacket=fetchPacketFromCache[instrumentModelToUse,simulatedCache];

	(* get the destination plate parameters from the instrument model *)
	{minAllowedPlateHeight,maxAllowedPlateHeight,maxAllowedFlangeHeight}=Lookup[instrumentModelPacket,{MinPlateHeight,MaxPlateHeight,MaxFlangeHeight}];

	(* get all the Field names required for checking compatibility with our instrument *)
	requiredCompatibilityFields={Footprint,NumberOfWells,Dimensions,FlangeHeight};

	(* get all the Field names required for creating a labware definition for our instrument *)
	requiredLabwareFields={HorizontalMargin,VerticalMargin,NumberOfWells,Rows,Columns,HorizontalPitch,VerticalPitch,FlangeHeight,MaxVolume};

	(* create booleans to indicate if destination plate model is compatible with our instrument and whether labware definition can be created *)
	{compatibleDestContainerQ,incompatibleDestContainerFieldsLookup,labWareQ,nulledRequiredFieldsLookup}=Transpose[Map[
		Function[platePacket,
			Module[{plateModel,footprint,wellNumber,dimensions,flangeHeight,compatibleBools,incompatibleParameters,
				wellDiameter,labwareFieldValues,labWareBool,nullFields},

				(* get the plate model *)
				plateModel=Lookup[platePacket,Object];

				(* get all the parameters required for compatibility check from the packet *)
				{footprint,wellNumber,dimensions,flangeHeight}=Lookup[platePacket,requiredCompatibilityFields];

				(* determine if the plate model is compatible with our instrument *)
				compatibleBools={
					(* check if the destination container has Plate footprint *)
					MatchQ[footprint,Plate],
					(* check if well numbers are compatible with our instrument. we only allow plates with 96 or 384 wells *)
					MatchQ[wellNumber,Alternatives[96,384]],
					(* check if the plate height is compatible *)
					And[
						MatchQ[dimensions[[3]],LessEqualP[maxAllowedPlateHeight]],
						MatchQ[dimensions[[3]],GreaterEqualP[minAllowedPlateHeight]]
					],
					(* check if the flange height is compatible *)
					MatchQ[flangeHeight,LessEqualP[maxAllowedFlangeHeight]]
				};

				(* get the Fields name with incompatible values *)
				incompatibleParameters=PickList[requiredCompatibilityFields,compatibleBools,False];

				(* lookup well diameter *)
				wellDiameter=Switch[Lookup[platePacket,{WellDimensions,WellDiameter}],
					{Null,Null},Null,
					{_,Null},First@Lookup[platePacket,WellDimensions],
					{Null,_},Lookup[platePacket,WellDiameter]
				];

				(* lookup the other Fields required for creating labware definition *)
				labwareFieldValues=Flatten[{wellDiameter,Lookup[platePacket,requiredLabwareFields]}];

				(* create a boolean which is False when any of the Fields required to create labware definition is not populated *)
				labWareBool=!MemberQ[labwareFieldValues,Null];

				(* get the required Field that were not populated *)
				nullFields=PickList[Flatten[{WellDiameter,requiredLabwareFields}],labwareFieldValues,Null];

				(* return our results *)
				{And@@compatibleBools,plateModel->incompatibleParameters,labWareBool,plateModel->nullFields}
			]
		],
		allDestContainerModelPackets
	]];

	(* get the incompatible destination models *)
	incompatibleDestContainerModels=Lookup[PickList[allDestContainerModelPackets,compatibleDestContainerQ,False],Object,{}];

	(* get the models that we cannot create labware definition *)
	failedLabwareDestContainerModels=Lookup[PickList[allDestContainerModelPackets,labWareQ,False],Object,{}];

	(* ---4. CHECK IF ALL DESTINATION PLATES HAVE THE SAME MODEL--- *)
	(* although we allow multiple destination containers, they all need to share the same model *)

	(* delete duplicates from the  container model list *)
	destContainerModels=DeleteDuplicates[Lookup[allDestContainerModelPackets,Object]];

	(* throw an error message if all the source containers do not share the same model *)
	If[(Length[destContainerModels]>1)&&!gatherTests,
		Message[Error::MultipleDestinationContainerModels]
	];

	(* if we are gathering tests, create a test for multiple source container models *)
	multipleDestContainerModelTest=If[gatherTests,
		Test["All the destination containers share the same container model:",
			Length[destContainerModels]==1,
			True
		],
		Nothing
	];

	(* stash the destination containers to return as invalid inputs if multiple types were supplied by the user *)
	multipleDestContainerTypes=If[Length[destContainerModels]>1,
		destContainerModels,
		{}
	];

	(* ---5. PRE-FILLED DESTINATION PLATE CHECK--- *)
	(* check if the existing samples in the destination have unsafe volume *)
	(* during manipulation destination plates will be inverted so we need to make sure the well fluid doesn't spill out *)
	(* it is difficult to determine the fill volume threshold since because of diverse fluid properties *)
	(* we may be able to use IntensiveProperites to determine volume threshold in the future, but for now we use half of max volume *)

	(* get the packets of the plates that have samples in them *)
	occupiedDestContainerPackets=Cases[destContainerPackets,Except[KeyValuePattern[Contents->{}]]];

	(* determine which plates have content volumes that exceeds our threshold *)
	occupiedDestWithUnsafeVolume=Map[
		Function[occupiedPacket,
			Module[{occupiedModel,occupiedModelPacket,numberOfWells,maxWellVolume,allowedFilledVolume,
				contentsSamples,contentsVolumes,maxContentVolume},

				(* get the model of the occupied plate *)
				occupiedModel=Lookup[occupiedPacket,Model];

				(* get the model packet *)
				occupiedModelPacket=fetchPacketFromCache[occupiedModel,simulatedCache];

				(* get number of wells/max volume from the model packet *)
				{numberOfWells,maxWellVolume}=Lookup[occupiedModelPacket,{NumberOfWells,MaxVolume}];

				(* check number of wells. we only allow plate with more than 96 wells to be pre-filled *)
				If[MatchQ[numberOfWells,LessP[384]],
					Lookup[occupiedPacket,Object],
					(* check the contents volumes against allowed fill volume *)
					(* TODO: currently set at half of max volume. may need to change if too high or too low *)
					(
						allowedFilledVolume=maxWellVolume/2;
						(* get all the contents samples from the packet *)
						contentsSamples=Lookup[occupiedPacket,Contents][[All,2]];
						(* get the volumes of all contents samples *)
						contentsVolumes=Lookup[Map[fetchPacketFromCache[#,simulatedCache]&,contentsSamples],Volume];
						(* find the max content volume. only compare quantity elements *)
						maxContentVolume=Max[Cases[contentsVolumes,_Quantity]];
						(* compare max volume against our allowed fill volume *)
						If[MatchQ[maxContentVolume,GreaterP[allowedFilledVolume]],
							(* return the plate object if max content volume exceeds allowed fill volume *)
							Lookup[occupiedPacket,Object],
							(* otherwise, return nothing *)
							Nothing
						]
					)
				]
			]
		],
		occupiedDestContainerPackets
	];

	(* -------------------------------- *)
	(* ---CONFLICTING OPTIONS CHECKS--- *)
	(* -------------------------------- *)

	(* ---PROTOCOL NAME CHECK--- *)
	(* get the specified Name *)
	nameOption=Lookup[myOptions,Name];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[nameOption,_String],
		!DatabaseMemberQ[Object[Protocol,AcousticLiquidHandling,nameOption]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"AcousticLiquidHandling protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[nameOption,_String],
		Test["If specified, Name is not already a AcousticLiquidHandling object name:",
			validNameQ,
			True
		],
		Null
	];

	(* -------------------------------- *)
	(* ---RESOLVE EXPERIMENT OPTIONS--- *)
	(* -------------------------------- *)

	(* specify our most updated primitives again to make sure all relevant keys are populated correctly *)
	specifiedPrimitives=Experiment`Private`specifyManipulation[#,Cache->updatedSimulatedCache]&/@primitivesWithSimulatedDest;

	(* ---identify destination locations that receive transfer from multiple sources--- *)
	(* Note: duplicate sources of a single destination location is considered multiple sources *)

	(* extract resolved destination location and amount from the primitives. make sure to unwrap from nested list format *)
	(* Note: at this point ResolvedDestinationLocation Key should be populated *)
	destLocationAndAmountTuples=Flatten[{#[ResolvedDestinationLocation],#[Amount]},2]&/@specifiedPrimitives;

	(* group the destination-to-amount tuples by their location. extract only the amount (last element) from the values *)
	destLocationToAmountsAssoc=GroupBy[destLocationAndAmountTuples,First->Last];

	(* select the destination locations with multiple amounts *)
	(* Note: we will use this in mapthread to resolve/check InWellSeparation option *)
	(* TODO: we may not need this *)
	destWithMultipleSourcesAssoc=Select[destLocationToAmountsAssoc,(Length[#]>1)&];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	AcousticLiquidHandlingOptionsAssociation=Association[AcousticLiquidHandlingOptions];

	(* ---re-expand index-matching options--- *)

	(* Get the full list of option definitions for this function *)
	optionDefinitions=OptionDefinition[ExperimentAcousticLiquidHandling];

	(* get the names options that are index-matched to the input primitives *)
	indexMatchingInputOptionNames=Lookup[Cases[optionDefinitions,KeyValuePattern["IndexMatchingInput"->Except[Null]]],"OptionName"];

	(* extract the options that are index-matched to the input primitives *)
	indexMatchingInputOptions=KeyValueMap[
		If[MemberQ[indexMatchingInputOptionNames,ToString[#1]],
			#1->#2,
			Nothing
		]&,
		AcousticLiquidHandlingOptionsAssociation
	];

	(* get the number of times each raw input primitive have been expanded *)
	primitiveExpandingFactor=SortBy[Tally[#[Index]&/@splitPrimitives],First][[All,2]];

	(* further expand our options that are index-matched to input primitives now that we split the inputs into individual Transfer primitives *)
	expandedIndexMatchingInputOptions=Rule@@@Map[
		Function[option,
			{
				option[[1]],
				MapThread[
					If[#2>1,Sequence@@ConstantArray[#1,#2],#1]&,
					{option[[2]],primitiveExpandingFactor}
				]
			}
		],
		indexMatchingInputOptions
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentAcousticLiquidHandling,Association@expandedIndexMatchingInputOptions];

	(* --volume tracking variable setup--- *)
	(* pre-mapthread: setup variables for volume tracking. include both source and destination samples *)

	(* get all of Object[Sample] packets. all potential source and destination sample should already be included at this point *)
	allSamplePackets=Cases[updatedSimulatedCache,PacketP[Object[Sample]]];

	(* we have to remove samples without containers because they won't work with the volume tracking system in mapthread *)
	allSamplesInContainerPackets=Cases[allSamplePackets,KeyValuePattern[Container->Except[Null]]];

	(* get the dead volume and max volume of each sample's container *)
	(* 1. get all the SamplesIn container packets *)
	allSamplesContainerPackets=fetchPacketFromCache[#,updatedSimulatedCache]&/@Lookup[allSamplesInContainerPackets,Container];
	(* 2. get all the model packet for each SamplesIn container *)
	allSamplesContainerModelPackets=fetchPacketFromCache[#,updatedSimulatedCache]&/@Lookup[allSamplesContainerPackets,Model];
	(* 3. get the dead volume and max volume from the container models *)
	{allSamplesDeadVolumes,allSamplesMaxVolumes}=Transpose@Lookup[allSamplesContainerModelPackets,{MinVolume,MaxVolume},0 Liter];
	(* 4. create an association that store dead volume for each container OBJECT *)
	allSamplesDeadVolumesAssoc=AssociationThread[Lookup[allSamplesInContainerPackets,Object],allSamplesDeadVolumes];
	(* 5. create an association that store max well volume for each container OBJECT *)
	allSamplesMaxVolumesAssoc=AssociationThread[Lookup[allSamplesInContainerPackets,Object],allSamplesMaxVolumes];

	(* create an association that for each sample, store (sample -> sample's volume) *)
	sampleToVolumeAssociation=AssociationThread@@Transpose[Lookup[allSamplesInContainerPackets,{Object,Volume}]];

	(* ---precision check variables setup--- *)

	(* set volume precision to use with SafeRound multiple times below. set it here so that we are required to change only one location when needed *)
	volumePrecision=10^-1 Nanoliter;

	(* get the instrument's min/max allowed transfer volumes and droplet resolution *)
	{instrumentsMinAllowedVolume,instrumentsMaxAllowedVolume,dropletResolution}=Lookup[instrumentModelPacket,{MinVolume,MaxVolume,DropletTransferResolution}];

	(* ---fluid type calibration variables setup--- *)
	(* Note: setup some variables that we will use to resolve FluidTypeCalibration and FluidAnalysisMeasurement options in the mapthread here *)

	(* store all the models we need to resolve FluidAnalysisMeasurement and FluidTypeCalibration in variables *)
	glycerolMolecule=Model[Molecule,"id:WNa4ZjKVdbW7"];
	dmsoMolecule=Model[Molecule,"id:01G6nvwRWRJ4"];

	(* create a list of known surfactants at ECL *)
	surfactantMoleculesLookup={
		Model[Molecule,"id:bq9LA0JmomlA"],(* Triton X-100 *)
		Model[Molecule,"id:zGj91a70m1RL"],(* Tween 20 *)
		Model[Molecule,"id:wqW9BP7JmJe9"],(* SDS *)
		Model[Molecule,"id:Vrbp1jKO57lW"],(* CTAB *)
		Model[Molecule,"id:n0k9mG8PJmN1"] (* Nonoxinol *)
	};

	(* some surfactants do not have Model[Molecule] in their composition. store them as Model[Sample] for now *)
	surfactantWithoutMoleculeLookup={
		Model[Sample,"id:Vrbp1jKKOmVe"],(* BRIJ-35 *)
		Model[Sample,"id:GmzlKjY5E044"] (* NP-40 *)
	};

	(* create a lookup table for container model of each supplied destination object so that we don't have to go through multiple packets *)
	(* create a look up to conveniently find model of destination supplied as sample or container object  *)
	destinationObjsModelLookup=DeleteDuplicates[Map[
		Module[{destination,container},
			(* get only the destination object from the primitive *)
			destination=First@Cases[#[Destination],ObjectP[],Infinity]/.x:ObjectReferenceP[]:>Download[x,Object];
			(* lookup the object's model *)
			Switch[destination,
				ObjectP[Object[Container]],
					destination->Lookup[fetchPacketFromCache[destination,updatedSimulatedCache],Model],
				ObjectP[Object[Sample]],
					container=Lookup[fetchPacketFromCache[destination,updatedSimulatedCache],Container];
					Sequence@@{
						container->Lookup[fetchPacketFromCache[container,updatedSimulatedCache],Model],
						destination->Lookup[fetchPacketFromCache[container,updatedSimulatedCache],Model]
					},
				_,
					Nothing
			]
		]&,
		primitivesWithSimulatedDest
	]]/.link_Link:>Download[link,Object];

	(* ---MAPTHREAD--- *)
	{
		(* warning/error checking booleans *)
		(*1*)amountPrecisionWarnings,
		(*2*)outOfRangeAmountErrors,
		(*3*)insufficientSourceAmountErrors,
		(*4*)samePlateTransferErrors,
		(*5*)invalidDestinationWellErrors,
		(*6*)overFillingDestErrors,
		(*7*)inWellSeparationNotAllowedKeyErrors,
		(*8*)inWellSeparationConflictErrors,
		(*9*)inWellSeparationNotAllowedOptionErrors,
		(*10*)glycerolPercentageErrors,
		(*11*)calibrationMeasurementMismatchErrors,
		(*12*)calibrationInvalidOptionErrors,
		(*13*)measurementInvalidOptionErrors,
		(*14*)calibrationInvalidOptionWarnings,
		(*15*)measurementInvalidOptionWarnings,
		(*16*)discardedSourceSampleErrors,
		(*17*)deprecatedSourceModelErrors,
		(*18*)sourceStateErrors,
		(*19*)containerlessSourceErrors,
		(*20*)invalidSourceContainerErrors,
		(*21*)discardedDestContainerErrors,
		(*22*)deprecatedDestContainerErrors,
		(*23*)invalidDestContainerErrors,
		(*24*)destLabwareDefinitionErrors,
		(*25*)unsafeDestVolumeErrors,
		(*26*)invalidPrimitiveBools,

		(* option values *)
		resolvedFluidTypeCalibrations,
		resolvedFluidAnalysisMeasurements,
		suppliedAmounts,
		roundedAmounts,
		resolvedInWellSeparationOptions,

		(* updated primitives *)
		specifiedUpdatedPrimitives,
		sourceToDestTuples,
		parentPrimitiveIndices,
		indexMatchedSourceSamples,
		indexMatchedDestinationSamples,
		indexMatchedRawDestinations
	}=Transpose@MapThread[
		Function[{myMapThreadFriendlyOptions,myPrimitive,rawPrimitive},
			Module[
				{
					(* supplied option values *)
					fluidAnalysisMeasurementOption,
					fluidTypeCalibrationOption,
					inWellSeparationOption,

					(* primitive information variables *)
					sourceSample,
					destinationSample,
					destinationLocation,
					inWellSeparationKey,
					suppliedAmount,
					parentPrimitiveIndex,
					rawDestination,
					roundedAmount,
					sourceSampleToUse,
					updatedSourceLocations,
					primitivesWithUpdatedSource,
					specifiedUpdatedPrimitive,
					destContainer,
					sourceToDestTuple,

					(* error checking booleans *)
					amountPrecisionWarning,
					outOfRangeAmountError,
					insufficientSourceAmountError,
					samePlateTransferError,
					invalidDestinationWellError,
					overFillingDestError,
					inWellSeparationNotAllowedKeyError,
					inWellSeparationConflictError,
					inWellSeparationNotAllowedOptionError,
					glycerolPercentageError,
					calibrationMeasurementMismatchError,
					calibrationInvalidOptionError,
					measurementInvalidptionError,
					calibrationInvalidOptionWarning,
					measurementInvalidOptionWarning,
					discardedSourceSampleError,
					deprecatedSourceModelError,
					sourceStateError,
					containerlessSourceError,
					invalidSourceContainerError,
					discardedDestContainerError,
					deprecatedDestContainerError,
					invalidDestContainerError,
					destLabwareDefinitionError,
					unsafeDestVolumeError,
					invalidPrimitiveBool,

					(* volume tracking variables *)
					usableVolume,
					potentialSamplePackets,
					potentialSampleToVolumeAssociation,
					potentialSamplesUsableVolumeLookup,
					totalUsableVolume,
					sourceVolumeUpdateAssoc,
					adjustedAmountAssoc,
					updatedDestVolume,
					destWellMaxVolume,

					(* misc variables *)
					tempAmount,
					destContainerModel,
					allowedDestinationWells,
					samplesComposition,
					samplesModel,
					compositionObjects,
					sourceWellMaxVolume,
					surfactantQ,
					proteinQ,
					glycerolPercent,
					dmsoPercent,

					(* resolved options *)
					resolvedCalibration,
					resolvedMeasurement,
					resolvedInWellSeparationOption
				},

				(* initialize our error tracking variables *)
				{
					amountPrecisionWarning,
					outOfRangeAmountError,
					insufficientSourceAmountError,
					samePlateTransferError,
					invalidDestinationWellError,
					overFillingDestError,
					inWellSeparationNotAllowedKeyError,
					inWellSeparationConflictError,
					inWellSeparationNotAllowedOptionError,
					glycerolPercentageError,
					calibrationMeasurementMismatchError,
					calibrationInvalidOptionError,
					measurementInvalidptionError,
					calibrationInvalidOptionWarning,
					measurementInvalidOptionWarning,
					discardedSourceSampleError,
					deprecatedSourceModelError,
					sourceStateError,
					containerlessSourceError,
					invalidSourceContainerError,
					discardedDestContainerError,
					deprecatedDestContainerError,
					invalidDestContainerError,
					destLabwareDefinitionError,
					unsafeDestVolumeError,
					invalidPrimitiveBool
				}=ConstantArray[False,26];

				(* store use-specified option Values in their variables *)
				{
					inWellSeparationOption,
					fluidAnalysisMeasurementOption,
					fluidTypeCalibrationOption
				}=Lookup[myMapThreadFriendlyOptions,
					{
						InWellSeparation,
						FluidAnalysisMeasurement,
						FluidTypeCalibration
					}
				];

				(* ---0. extract key values from each split primitive and make sure they are in Object Reference format--- *)
				sourceSample=First@Cases[myPrimitive[SourceSample],(x:ObjectReferenceP[]:>Download[x,Object]),Infinity];
				destinationSample=First@Cases[myPrimitive[DestinationSample],(x:ObjectReferenceP[]:>Download[x,Object]),Infinity];
				destinationLocation=First@Cases[myPrimitive[ResolvedDestinationLocation],({container:ObjectReferenceP[],well_}:>{Download[container,Object],well}),Infinity];
				suppliedAmount=First@Cases[myPrimitive[Amount],_Quantity,Infinity];
				parentPrimitiveIndex=myPrimitive[Index];
				rawDestination=First@First@rawPrimitive[Destination]/.x:ObjectReferenceP[]:>Download[x,Object];

				(* ---1. transfer amount precision check--- *)

				(* get the rounded amounts *)
				(* Note: have to work around to make sure the values are multiples of 2.5 Nanoliter *)
				roundedAmount=RoundOptionPrecision[suppliedAmount/dropletResolution,1]*dropletResolution;

				(* return True if a precision is off. We will use the boolean assigned here to create test and throw a message outside of mapthread *)
				amountPrecisionWarning=Not[MatchQ[roundedAmount,EqualP[suppliedAmount]]];

				(* ---2. out-of-range amount check--- *)

				(* check after rounding if our amount is out of the instrument's transfer range *)
				outOfRangeAmountError=Not[MatchQ[roundedAmount,RangeP[instrumentsMinAllowedVolume,instrumentsMaxAllowedVolume,dropletResolution]]];

				(* ---3. source volume sufficiency test (over-aspiration test)--- *)

				(* also store replacement rule for use later *)
				(* Note: if source sample is not a member of simulated sample, find replacement sample *)
				{sourceSampleToUse,insufficientSourceAmountError}=If[MemberQ[simulatedSamples,sourceSample],
					(* if the current source sample is already in the simulated sample list, don't replace it *)
					(* but check if the volume is sufficient for this manipulation *)
					(
						usableVolume=SafeRound[(Lookup[sampleToVolumeAssociation,sourceSample]-Lookup[allSamplesDeadVolumesAssoc,sourceSample,0 Liter]),volumePrecision];
						{ToList[sourceSample],MatchQ[usableVolume,LessP[roundedAmount]]}
					),
					(* otherwise, find the appropriate simulated sample to replace *)
					(
						(* get all the packets that have our current sample as SimulationParent *)
						potentialSamplePackets=Cases[allSamplesInContainerPackets,KeyValuePattern[SimulationParent->sourceSample]];

						(* create an association for our potential samples in the form sample -> volume *)
						(* Note: select only the samples of interest from the main association we created before mapthread *)
						potentialSampleToVolumeAssociation=KeyTake[sampleToVolumeAssociation,Lookup[potentialSamplePackets,Object]];

						(* from all potential samples, select only the ones that have positive usable volume *)
						potentialSamplesUsableVolumeLookup=Association@KeyValueMap[
							Function[{sample,volume},
								(* calculate usable volume by subtracting the sample's container's dead volume *)
								With[{usableVolume=SafeRound[(volume-Lookup[allSamplesDeadVolumesAssoc,sample,0 Liter]),volumePrecision]},
									(* return only the samples with positive usable volume *)
									If[MatchQ[usableVolume,GreaterP[0 Liter]],
										sample->usableVolume,
										Nothing
									]
								]
							],
							potentialSampleToVolumeAssociation
						];

						(* calculate the total usable volume from our potential samples *)
						totalUsableVolume=If[MatchQ[potentialSamplesUsableVolumeLookup,<||>],
							0 Liter,
							Total[potentialSamplesUsableVolumeLookup]
						];

						(* check if the total usable volume is sufficient for this manipulation *)
						If[MatchQ[totalUsableVolume,LessP[roundedAmount]],
							(* return one of the potential samples and set volume tracking boolean to True *)
							{ToList[First@Keys@potentialSampleToVolumeAssociation],True},
							(* otherwise, check if we can use a single sample to satisfy the primitive's amount *)
							If[Select[potentialSamplesUsableVolumeLookup,MatchQ[#,GreaterEqualP[roundedAmount]]&]==<||>,
								(* if there's no individual sample with sufficient volume, return all samples *)
								{Keys@potentialSamplesUsableVolumeLookup,False},
								(* otherwise, select ONE sample with the closest volume to satisfy the primitive's amount *)
								With[{canUseSamples=Select[potentialSamplesUsableVolumeLookup,MatchQ[#,GreaterEqualP[roundedAmount]]&]},
									{
										ToList[First@Nearest[canUseSamples,roundedAmount]],
										False
									}
								]
							]
						]
					)
				];

				(* ---4. source volume update--- *)

				(* create an association to update the volumes of the samples used by this primitive *)
				sourceVolumeUpdateAssoc=If[Length[sourceSampleToUse]==1,
					(* if a single sample is sufficient for this primitive, return its current volume subtracted by the primitive's amount *)
					SafeRound[(#-roundedAmount),volumePrecision]&/@KeyTake[sampleToVolumeAssociation,sourceSampleToUse],

					(* if multiple samples are needed, update each one according to the amount used by this primitive *)
					(
						(* first set a temporary variable to the rounded amount *)
						tempAmount=roundedAmount;
						Fold[
							Module[{deadVol,usableVol},
								(* get the dead volume for each sample *)
								deadVol=Lookup[allSamplesDeadVolumesAssoc,Keys@#2,0 Liter];
								(* get the usable volume for each sample *)
								usableVol=SafeRound[(Values@#2-deadVol),volumePrecision];

								Append[#1,If[MatchQ[tempAmount,GreaterP[usableVol]],
									(* if amount is higher than the current sample, subtract sample's volume from the amount, and set sample's volume to 0 *)
									tempAmount=SafeRound[(tempAmount-usableVol),volumePrecision];
									Keys@#2->deadVol,
									(* if amount is below sample's volume, updated the volume by subtracting amount and set tempAmount to 0 *)
									With[{updatedVolume=Keys@#2->SafeRound[(Values@#2-tempAmount),volumePrecision]},
										tempAmount=0 Liter;
										updatedVolume
									]
								]]
							]&,
							<||>,
							(* convert association to list so that it works with Fold *)
							Normal@KeyTake[sampleToVolumeAssociation,sourceSampleToUse]
						]
					)
				];

				(* if the multiple sample are used in the current primitive, we will split the primitive accordingly *)
				(* we will also need to split amount properly, so we calculate adjusted amount here and store in an association *)
				adjustedAmountAssoc=MapThread[
					Function[{preTransferAmount,postTransferAmount},
						preTransferAmount-postTransferAmount
					],
					{KeyTake[sampleToVolumeAssociation,Keys@sourceVolumeUpdateAssoc],sourceVolumeUpdateAssoc}
				];

				(* update source sample's volume in the volume tracking association we defined outside of mapthread *)
				AssociateTo[sampleToVolumeAssociation,sourceVolumeUpdateAssoc];

				(* ---5. same plate transfer check--- *)
				(* Note: transfer between wells in the same plate is not supported *)

				(* get the most up-to-date source locations from the samples we are using *)
				updatedSourceLocations=Lookup[(fetchPacketFromCache[#,allSamplesInContainerPackets]&/@sourceSampleToUse),{Container,Position}]/.x:ObjectP[]:>Download[x,Object];

				(* check if the current primitive include transfer between wells in the same container *)
				samePlateTransferError=Or@@Map[MatchQ[#,First@destinationLocation]&,updatedSourceLocations[[All,1]]];

				(* ---6. destination well validity check--- *)

				(* get the destination container's model *)
				destContainerModel=Lookup[destinationObjsModelLookup,First@destinationLocation];

				(* get the list of allowed wells from the destination model packet *)
				allowedDestinationWells=Lookup[fetchPacketFromCache[destContainerModel,updatedSimulatedCache],AllowedPositions];

				(* check if the destination well defined in the primitive a valid position in its container *)
				invalidDestinationWellError=Not[MatchQ[destinationLocation[[2]],Alternatives@@allowedDestinationWells]];

				(* ---7. destination volume update--- *)

				(* calculate the updated destination sample's volume *)
				updatedDestVolume=SafeRound[(Lookup[sampleToVolumeAssociation,destinationSample]+roundedAmount),volumePrecision];

				(* update destination sample's volume in the volume tracking association we defined outside of mapthread *)
				AssociateTo[sampleToVolumeAssociation,(destinationSample->updatedDestVolume)];

				(* ---8. over-filling destination test--- *)
				(* throw an error if updated volume exceeds max allowed volume *)

				(* get the destination well's max volume *)
				(* FIXME: may need to adjust the over-filling limit if max well volume is too high *)
				destWellMaxVolume=Lookup[allSamplesMaxVolumesAssoc,destinationSample,Infinity];

				(* get if the updated destination volume exceeds the well's max volume *)
				overFillingDestError=MatchQ[updatedDestVolume,GreaterP[destWellMaxVolume]];

				(* ---9. resolve InWellSeparation key/option if not specified--- *)

				{inWellSeparationKey,resolvedInWellSeparationOption}=Switch[{myPrimitive[InWellSeparation],inWellSeparationOption},
					(* set to option value is the key is missing *)
					{_Missing,Except[Automatic]},{inWellSeparationOption,inWellSeparationOption},
					(* if the option is not supplied by the user, resolved to the key value *)
					{Except[_Missing],Automatic},ConstantArray[First@myPrimitive[InWellSeparation],2],
					(* if both are supplied, return unchanged *)
					{Except[_Missing],Except[Automatic]},{First@myPrimitive[InWellSeparation],inWellSeparationOption},
					(* if none were supplied, set both key and option to False *)
					_,{False,False}
				];

				(* 10. ---check if InWellSeparation is allowed--- *)

				inWellSeparationNotAllowedKeyError=If[Not[inWellSeparationKey],
					(* if the key is already set to False, there won't be any error *)
					False,
					(* if the key is set to True, we will check plate type, number of sources, and amount *)
					Module[{allAmounts,numberOfSources,maxAmount,wellBottom,wellShape,wellDiameter},
						(* get all the amounts to be transferred into our current destination well *)
						allAmounts=destLocationToAmountsAssoc[destinationLocation];
						(* get the number of sources going into our current destination well *)
						numberOfSources=Length[allAmounts];
						(* get the well bottom and well shape *)
						{wellBottom,wellShape}=Lookup[fetchPacketFromCache[destContainerModel,updatedSimulatedCache],{WellBottom,CrossSectionalShape}];

						(* check if setting destination well offset is allowed based on multiple criteria below *)
						If[(numberOfSources<=1)||MatchQ[wellBottom,Except[FlatBottom]]||MatchQ[wellShape,Except[Circle|Rectangle]],
							(* if there's only one source going into the same well or well shape is not flat, InWellSeparation is not allowed *)
							True,
							(* otherwise, we will check further *)
							(* get the max volume from the amount list *)
							maxAmount=Max[allAmounts];
							(* get the well diameter according to the well shape *)
							wellDiameter=If[NullQ[Lookup[fetchPacketFromCache[destContainerModel,updatedSimulatedCache],WellDimensions]],
								Lookup[fetchPacketFromCache[destContainerModel,updatedSimulatedCache],WellDiameter],
								First@Lookup[fetchPacketFromCache[destContainerModel,updatedSimulatedCache],WellDimensions]
							];

							(* in order to separate target locations of multiple sources in the destination well, we need to make sure that *)
							(* 1. well is large enough to accommodate multiple sources *)
							(* 2. droplet size is not too large *)
							(* 3. they are not too many sources converging into one destination well *)
							Switch[{wellDiameter,maxAmount,numberOfSources},
								(* for well diameter between 3-5mm, amount higher than 50nL and more than 4 sources are not allowed *)
								{RangeP[3 Millimeter,5 Millimeter],LessEqualP[50 Nanoliter],LessEqualP[4]},False,
								(* for well diameter larger than 5mm, amount higher than 100nL and more than 5 sources are not allowed *)
								{GreaterP[5 Millimeter],LessEqualP[100 Nanoliter],LessEqualP[5]},False,
								(* all other cases are not allowed *)
								_,True
							]
						]
					]
				];

				(* check for InWellSeparation Key and Option mismatch *)
				inWellSeparationConflictError=Not[MatchQ[resolvedInWellSeparationOption,inWellSeparationKey]];

				(* option and key may be different, so check the option value based on the key error *)
				(* Note: we won't throw an error if InWellSeparation Option is Automatic *)
				inWellSeparationNotAllowedOptionError=Which[
					MatchQ[inWellSeparationOption,Automatic],False,
					inWellSeparationConflictError,Not[inWellSeparationNotAllowedKeyError],
					True,inWellSeparationNotAllowedKeyError
				];

				(* ---11. FluidAnalysisMeasurement and FluidTypeCalibration check/resolution--- *)
				(* Note: we don't allow Glycerol calibration to be specified for 384LDV plate *)

				(* get the sample's composition and model (if any) *)
				(* Note: we select the first sample from our list of samples to use since they all share the sample composition *)
				{samplesComposition,samplesModel}=Lookup[fetchPacketFromCache[First@sourceSampleToUse,updatedSimulatedCache],{Composition,Model}];

				(* extract the objects from the sample's composition *)
				compositionObjects=Cases[samplesComposition,{_,x:ObjectP[]}:>Download[x,Object]];

				(* get the max well volume of the sample's container *)
				(* Note: we will need to identify if it is a low-dead-volume plate for valid calibration type check *)
				(* Note: for container-less sample, set to Null *)
				sourceWellMaxVolume=Lookup[allSamplesMaxVolumesAssoc,First@sourceSampleToUse,Null];

				(* check if there's any surfactant in the sample's composition *)
				surfactantQ=Or[
					ContainsAny[compositionObjects,surfactantMoleculesLookup],
					MemberQ[surfactantWithoutMoleculeLookup,Download[samplesModel,Object]]
				];

				(* check if there's any protein in the sample's composition *)
				proteinQ=!MatchQ[Cases[compositionObjects,ObjectP[Model[Molecule,Protein]]],{}];

				(* get the glycerol percentage if any *)
				glycerolPercent=With[{percent=FirstCase[samplesComposition,{percentage_,ObjectP[glycerolMolecule]}:>percentage]},
					Switch[percent,
						_Missing,0 VolumePercent,
						_,percent
					]
				];

				(* get the DMSO percentage if any *)
				dmsoPercent=With[{percent=FirstCase[samplesComposition,{percentage_,ObjectP[dmsoMolecule]}:>percentage]},
					Switch[percent,
						_Missing,0 VolumePercent,
						_,percent
					]
				];

				(* ---glycerol percentage check--- *)
				(* our instrument only allows <= 50% glycerol *)
				glycerolPercentageError=MatchQ[glycerolPercent,GreaterP[50 VolumePercent]];

				(* resolve FluidAnalysisMeasurement and FluidTypeCalibration Options *)
				{
					resolvedCalibration,
					resolvedMeasurement,
					calibrationMeasurementMismatchError,
					calibrationInvalidOptionError,
					measurementInvalidptionError,
					calibrationInvalidOptionWarning,
					measurementInvalidOptionWarning
				}=Switch[{fluidTypeCalibrationOption,fluidAnalysisMeasurementOption},
					(* cases 1: calibration supplied by the user *)
					{Except[Automatic],_},
						Module[{resMeas,mismatchError,calibError,measError,calibWarning,measWarning},

							(* resolve the measurement type *)
							resMeas=If[MatchQ[fluidAnalysisMeasurementOption,Except[Automatic]],
								(* if set by the user, return as is *)
								fluidAnalysisMeasurementOption,
								(* resolve according to calibration if not supplied by the user *)
								Switch[fluidTypeCalibrationOption,
									Alternatives[DMSO,Glycerol],fluidTypeCalibrationOption,
									_,AcousticImpedance
								]
							];

							(* if both are supplied by the user, check if they agree with each other *)
							mismatchError=Not[Switch[fluidTypeCalibrationOption,
								Alternatives[DMSO,Glycerol],MatchQ[resMeas,fluidTypeCalibrationOption],
								_,MatchQ[resMeas,AcousticImpedance]
							]];

							(* check if Glycerol is supplied when the source sample's container is a low-dead-volume plate *)
							(* Note: the only other error case we can have is when Glycerol is supplied for a low-dead-volume plate *)
							(* Note: hard code to 12 Microliter for now as that would determine if our plate is an Echo low-dead-volume plate *)
							(* we don't check resolved fluidAnalysisMeasurementOption here in case it was automatically set to Glycerol *)
							{calibError,measError}=If[MatchQ[sourceWellMaxVolume,LessEqualP[12 Microliter]],
								{MatchQ[fluidTypeCalibrationOption,Glycerol],MatchQ[fluidAnalysisMeasurementOption,Glycerol]},
								{False,False}
							];

							(* although any calibration works with any liquid type, we will throw a warning if the sample does not contain the intended composition *)
							(* Note: sourceWellMaxVolime determines if our sample is in Echo low-dead-volume plate which deal with calibration differently *)
							calibWarning=Not[Switch[{fluidTypeCalibrationOption,sourceWellMaxVolume,glycerolPercent,dmsoPercent,surfactantQ,proteinQ},
								(* catch all glycerol cases for low-dead-volume first. we don't care about this case here since
								we don't allow Glycerol to be set for low-dead-volume plate and would have thrown an error already *)
								{Glycerol,LessEqualP[12 Microliter],_,_,_,_},
									True,
								(* sample contains DMSO and glycerol concentration is lower than DMSO *)
								{_,_,LessP[dmsoPercent],GreaterP[0 VolumePercent],_,_},
									MatchQ[fluidTypeCalibrationOption,DMSO],
								(* all low-dead-volume cases with surfactant but no proteins *)
								{_,LessEqualP[12 Microliter],_,_,True,False},
									MatchQ[fluidTypeCalibrationOption,AqueousWithSurfactant],
								(* catch all other cases for low-dead-volume plate *)
								{_,LessEqualP[12 Microliter],_,_,_,_},
									MatchQ[fluidTypeCalibrationOption,AqueousWithoutSurfactant],
								(* all cases with surfactant. having protein is fine here *)
								{_,_,_,_,True,_},
									MatchQ[fluidTypeCalibrationOption,AqueousWithSurfactant],
								(* sample contains glycerol *)
								{_,_,GreaterP[0 VolumePercent],_,_,_},
									MatchQ[fluidTypeCalibrationOption,Glycerol],
								(* all the remaining cases *)
								_,
									MatchQ[fluidTypeCalibrationOption,AqueousWithoutSurfactant]
							]];

							(* although any measurement type works with any liquid type, we will throw a warning if the sample does not contain the intended composition *)
							measWarning=If[MatchQ[fluidAnalysisMeasurementOption,Automatic],
								(* we won't throw any warning if FluidAnalysisMeasurement option was not set by the user *)
								False,
								(* otherwise, check with the same criteria as FluidTypeCalibration *)
								Not[Switch[{fluidAnalysisMeasurementOption,sourceWellMaxVolume,glycerolPercent,dmsoPercent,surfactantQ,proteinQ},
									(* catch all glycerol cases for low-dead-volume first. we don't care about this case here since
									we don't allow Glycerol to be set for low-dead-volume plate and would have thrown an error already *)
									{Glycerol,LessEqualP[12 Microliter],_,_,_,_},
										True,
									(* sample contains DMSO and glycerol concentration is lower than DMSO *)
									{_,_,LessP[dmsoPercent],GreaterP[0 VolumePercent],_,_},
										MatchQ[fluidAnalysisMeasurementOption,DMSO],
									(* all cases with surfactant but no proteins *)
									{_,LessEqualP[12 Microliter],_,_,True,False},
										MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
									(* catch Glycerol cases for low-dead-volume plate *)
									(* Note: we don't care about Glycerol here since we don't allow Glycerol to be set for low-dead-volume plate and would have thrown an error already *)
									{_,LessEqualP[12 Microliter],GreaterP[0 VolumePercent],_,_,_},
										MatchQ[fluidAnalysisMeasurementOption,Alternatives[Glycerol,AcousticImpedance]],
									(* catch all other cases for low-dead-volume plate *)
									{_,LessEqualP[12 Microliter],_,_,_,_},
										MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
									(* all cases with surfactant. having protein is fine here *)
									{_,_,_,_,True,_},
										MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
									(* sample contains glycerol *)
									{_,_,GreaterP[0 VolumePercent],_,_,_},
										MatchQ[fluidAnalysisMeasurementOption,Glycerol],
									(* all the remaining cases *)
									_,
										MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance]
								]]
							];

							(* return our resolved options, errors, and warnings *)
							{fluidTypeCalibrationOption,resMeas,mismatchError,calibError,measError,calibWarning,measWarning}
						],

					(* cases 2: measurement type supplied by the user *)
					{Automatic,Except[Automatic]},
						Module[{resCalib,mismatchError,calibError,measError,calibWarning,measWarning},

							(* resolve the calibration option *)
							(* Note: if Glycerol is supplied as measurement type when our sample is in low-dead-volume plate we still resolve calibration to Glycerol here. we will throw an error below instred *)
							resCalib=If[MatchQ[fluidAnalysisMeasurementOption,Alternatives[DMSO,Glycerol]],
								fluidAnalysisMeasurementOption,
								If[surfactantQ,AqueousWithSurfactant,AqueousWithoutSurfactant]
							];

							(* calibration is automatic and is resolved according to measurement type so this is always False *)
							mismatchError=False;

							(* check if Glycerol is supplied when the source sample's container is a low-dead-volume plate *)
							(* Note: the only other error case we can have is when Glycerol is supplied for a low-dead-volume plate *)
							(* Note: hard code to 12 Microliter for now as that would determine if our plate is an Echo low-dead-volume plate *)
							(* we don't check resolved fluidTypeCalibrationOption here in case it was automatically set to Glycerol *)
							{calibError,measError}=If[MatchQ[sourceWellMaxVolume,LessEqualP[12 Microliter]],
								{MatchQ[fluidTypeCalibrationOption,Glycerol],MatchQ[fluidAnalysisMeasurementOption,Glycerol]},
								{False,False}
							];

							(* warning for FluidTypeCalibration is always False here since it was not set by the user *)
							calibWarning=False;

							(* although any measurement type works with any liquid type, we will throw a warning if the sample does not contain the intended composition *)
							measWarning=Not[Switch[{fluidAnalysisMeasurementOption,sourceWellMaxVolume,glycerolPercent,dmsoPercent,surfactantQ,proteinQ},
								(* catch all glycerol cases for low-dead-volume first. we don't care about this case here since
								we don't allow Glycerol to be set for low-dead-volume plate and would have thrown an error already *)
								{Glycerol,LessEqualP[12 Microliter],_,_,_,_},
									True,
								(* sample contains DMSO and glycerol concentration is lower than DMSO *)
								{_,_,LessP[dmsoPercent],GreaterP[0 VolumePercent],_,_},
									MatchQ[fluidAnalysisMeasurementOption,DMSO],
								(* all cases with surfactant but no proteins *)
								{_,LessEqualP[12 Microliter],_,_,True,False},
									MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
								(* catch all other cases for low-dead-volume plate *)
								{_,LessEqualP[12 Microliter],_,_,_,_},
									MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
								(* all cases with surfactant. having protein is fine here *)
								{_,_,_,_,True,_},
									MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance],
								(* sample contains glycerol *)
								{_,_,GreaterP[0 VolumePercent],_,_,_},
									MatchQ[fluidAnalysisMeasurementOption,Glycerol],
								(* all the remaining cases *)
								_,
									MatchQ[fluidAnalysisMeasurementOption,AcousticImpedance]
							]];

							(* return our resolved options, errors, and warnings *)
							{resCalib,fluidAnalysisMeasurementOption,mismatchError,calibError,measError,calibWarning,measWarning}
						],

					(* cases 3: both are automatic *)
					{Automatic,Automatic},
						Module[{resCalib,resMeas,mismatchError,calibError,measError,calibWarning,measWarning},

							(* resolve the calibration first *)
							(* calibration for low-dead-volume plate can only be resolved to DMSO, AqueousWithSurfactant, AqueousWithoutSurfactant *)
							resCalib=Switch[{sourceWellMaxVolume,glycerolPercent,dmsoPercent,surfactantQ,proteinQ},
								(* sample contains DMSO and glycerol concentration is lower than DMSO *)
								{_,LessP[dmsoPercent],GreaterP[0 VolumePercent],_,_},
									DMSO,
								(* all cases with surfactant but no proteins *)
								{LessEqualP[12 Microliter],_,_,True,False},
									AqueousWithSurfactant,
								(* catch all other cases for low-dead-volume plate *)
								{LessEqualP[12 Microliter],_,_,_,_},
									AqueousWithoutSurfactant,
								(* all cases with surfactant. having protein is fine here *)
								{_,_,_,True,_},
									AqueousWithSurfactant,
								(* sample contains glycerol *)
								{_,GreaterP[0 VolumePercent],_,_,_},
									Glycerol,
								(* all the remaining cases *)
								_,
									AqueousWithoutSurfactant
							];

							(* resolve the measurement type according to our resolved calibration *)
							resMeas=Switch[resCalib,
								Alternatives[DMSO,Glycerol],resCalib,
								_,AcousticImpedance
							];

							(* no need to throw any errors or warning for this case since the user didn't supply anything *)
							{mismatchError,calibError,measError,calibWarning,measWarning}=ConstantArray[False,5];

							(* return our resolved options, errors, and warnings *)
							{resCalib,resMeas,mismatchError,calibError,measError,calibWarning,measWarning}
						]
				];

				(* 12. ---check source/destination against invalid lists we created above--- *)
				(* Note: we only need to collect the indices of primitive with invalid source/destination here to use in messages/tests outside of mapthread *)

				(* ---DISCARDED SOURCE SAMPLE CHECK--- *)
				discardedSourceSampleError=ContainsAny[sourceSampleToUse,discardedSourceInvalidInputs];

				(* ---DEPRECATED SOURCE SAMPLE MODEL CHECK--- *)
				deprecatedSourceModelError=ContainsAny[sourceSampleToUse,sourceWithDeprecatedModels];

				(* ---SOURCE SAMPLE STATE CHECK--- *)
				sourceStateError=ContainsAny[sourceSampleToUse,sourceWithInvalidStates];

				(* ---CONTAINER-LESS SAMPLE CHECK--- *)
				containerlessSourceError=ContainsAny[sourceSampleToUse,containerlessSamples];

				(* ---SOURCE PLATE COMPATIBILITY CHECK--- *)
				invalidSourceContainerError=ContainsAny[sourceSampleToUse,sourceWithInvalidContainers];

				(* get the destination container from the primitive's resolved destination location *)
				destContainer=First[destinationLocation];

				(* ---DISCARDED DESTINATION CONTAINER CHECK--- *)
				discardedDestContainerError=MemberQ[discardedDestContainers,destContainer];

				(* ---DEPRECATED DESTINATION CONTAINER MODEL CHECK--- *)
				deprecatedDestContainerError=MemberQ[deprecatedDestContainerModels,destContainerModel];

				(* ---DESTINATION PLATE COMPATIBILITY CHECK--- *)
				invalidDestContainerError=MemberQ[incompatibleDestContainerModels,destContainerModel];
				destLabwareDefinitionError=MemberQ[failedLabwareDestContainerModels,destContainerModel];

				(* ---PRE-FILLED DESTINATION PLATE CHECK--- *)
				unsafeDestVolumeError=MemberQ[occupiedDestWithUnsafeVolume,destContainer];

				(* ---13. replace source sample with simulated sample and update amount --- *)

				(* update Source/Amount/InWellSeparation Keys in the primitive *)
				(* Note: the current primitive will be split to multiple primitives if we use multiple samples in the current iteration *)
				(* Important: we add hidden SamplesIn Key to store the position in SamplesIn Field of the sample that we used.
					we will use this position in the compiler to replace the source samples with working samples correctly *)
				primitivesWithUpdatedSource=Map[
					If[MatchQ[#,sourceSample],
						(* if the sample we're using is already in the primitive, only update the amount *)
						Transfer[
							(* put updated amount into the same nested list format as converted Transfer primitive *)
							Append[KeyDrop[Association@@myPrimitive,{Amount,InWellSeparation}],{
								Amount->{{roundedAmount}},
								InWellSeparation->{inWellSeparationKey},
								SamplesIn->First@First@Position[simulatedSamples,#]
							}]
						],

						Transfer[
							(* put updated source and amount into the same nested list format as converted Transfer primitive *)
							(* Note: we lookup the adjusted amount we calculated above when the primitive is split *)
							Append[KeyDrop[Association@@myPrimitive,{Source,Amount,InWellSeparation}],{
								Source->{{#}},
								Amount->{{Lookup[adjustedAmountAssoc,#]}},
								InWellSeparation->{inWellSeparationKey},
								SamplesIn->First@First@Position[simulatedSamples,#]
							}]
						]
					]&,
					sourceSampleToUse
				];

				(* ---14. re-specify the primitive--- *)
				(* re-specify our primitives to keep the ResolvedSourceLocation up-to-date *)
				specifiedUpdatedPrimitive=specifyManipulation[#,Cache->updatedSimulatedCache]&/@primitivesWithUpdatedSource;

				(* ---15. create transfer tuples--- *)
				(* create tuples to use in the from {sourceLocation, destinationLocation} for optimizing transfer sequence after mapthread *)
				sourceToDestTuple=Flatten[Map[
					{
						#[ResolvedSourceLocation],
						#[ResolvedDestinationLocation]
					}&,
					specifiedUpdatedPrimitive
				],3];

				(* 16. flag primitive as invalid if any of the Source/Destination/Key errors is True *)
				invalidPrimitiveBool={parentPrimitiveIndex,
					Or@@{outOfRangeAmountError,
						insufficientSourceAmountError,
						samePlateTransferError,
						invalidDestinationWellError,
						overFillingDestError,
						inWellSeparationNotAllowedKeyError,
						glycerolPercentageError,
						discardedSourceSampleError,
						deprecatedSourceModelError,
						sourceStateError,
						containerlessSourceError,
						invalidSourceContainerError,
						discardedDestContainerError,
						deprecatedDestContainerError,
						invalidDestContainerError,
						destLabwareDefinitionError,
						unsafeDestVolumeError}
				};

				(* gather MapThread results *)
				{
					(* warning/error checking booleans *)
					amountPrecisionWarning,
					outOfRangeAmountError,
					insufficientSourceAmountError,
					samePlateTransferError,
					invalidDestinationWellError,
					overFillingDestError,
					inWellSeparationNotAllowedKeyError,
					inWellSeparationConflictError,
					inWellSeparationNotAllowedOptionError,
					glycerolPercentageError,
					calibrationMeasurementMismatchError,
					calibrationInvalidOptionError,
					measurementInvalidptionError,
					calibrationInvalidOptionWarning,
					measurementInvalidOptionWarning,
					discardedSourceSampleError,
					deprecatedSourceModelError,
					sourceStateError,
					containerlessSourceError,
					invalidSourceContainerError,
					discardedDestContainerError,
					deprecatedDestContainerError,
					invalidDestContainerError,
					destLabwareDefinitionError,
					unsafeDestVolumeError,
					invalidPrimitiveBool,

					(* option values *)
					resolvedCalibration,
					resolvedMeasurement,
					suppliedAmount,
					roundedAmount,
					resolvedInWellSeparationOption,

					(* updated primitives *)
					specifiedUpdatedPrimitive,
					sourceToDestTuple,
					parentPrimitiveIndex,
					sourceSampleToUse,
					destinationSample,
					rawDestination
				}
			]
		],
		{mapThreadFriendlyOptions,specifiedPrimitives,splitPrimitives}
	];

	(* expand options for primitives that were expanded in mapthread *)
	{expandedResolvedCalibrations,expandedResolvedMeasurements,expandedInWellSeparationOptions}=Flatten/@Transpose[MapThread[
		Function[{primitives,calibration,measurement,inWellSeparation},
			If[Length[primitives]>1,
				Map[ConstantArray[#,Length[primitives]]&,{calibration,measurement,inWellSeparation}],
				{calibration,measurement,inWellSeparation}
			]
		],
		{specifiedUpdatedPrimitives,resolvedFluidTypeCalibrations,resolvedFluidAnalysisMeasurements,resolvedInWellSeparationOptions}
	]];

	(* flatten our list of updated primitives *)
	flatSpecifiedUpdatedPrimitives=Flatten[specifiedUpdatedPrimitives];

	(* ---PRIMITIVES WITH INVALID INPUT CHECK--- *)
	(* since we did all the check on split primitives, figure out which parent primitives are invalid *)

	(* group the invalid primitive bools from our mapthread by the index *)
	invalidParentPrimitiveLookup=Map[(Or@@#)&,GroupBy[invalidPrimitiveBools,First->Last]];

	(* get the indices of invalid parent primitives *)
	invalidParentPrimtiveIndices=Keys@Select[invalidParentPrimitiveLookup,TrueQ];

	(* create string to indicate indices of invalid primitives to return all other invalid inputs *)
	invalidPrimitivesString=If[MatchQ[invalidParentPrimtiveIndices,{}],
		{},
		{"primitive at index: "<>ToString[DeleteDuplicates[invalidParentPrimtiveIndices]]}
	];

	(* --------------------------------- *)
	(* ---GENERATE MESSAGES AND TESTS--- *)
	(* --------------------------------- *)

	(* ---SOURCE SAMPLE CHECK--- *)

	(* 16. discarded source sample error *)

	(* get the primitive indices with discarded source sample *)
	discardedSourceIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,discardedSourceSampleErrors]];

	(* get the primitive indices with undiscarded source sample *)
	undiscardedSourceIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,discardedSourceSampleErrors,False]];

	(* throw an error message for any of the source samples is discarded *)
	If[Not[MatchQ[discardedSourceInvalidInputs,{}]]&&!gatherTests,
		Message[Error::DiscardedSourceSamples,ObjectToString[discardedSourceInvalidInputs,Cache->simulatedCache],discardedSourceIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedSourceSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[discardedSourceInvalidInputs,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[discardedSourceInvalidInputs,Cache->simulatedCache]<>" from primitives at index "<>ToString[discardedSourceIndices]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedSourceSampleTest]==Length[simulatedSamples],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[simulatedSamples,discardedSourceInvalidInputs],Cache->simulatedCache]<>" from primitives at index "<>ToString[undiscardedSourceIndices]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 17. deprecated source sample's model error *)

	(* get the primitive indices with deprecated source sample's model *)
	deprecatedSourceModelIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,deprecatedSourceModelErrors]];

	(* get the primitive indices with undeprecated source sample's model *)
	undeprecatedSourceModelIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,deprecatedSourceModelErrors,False]];

	(* throw an error message for any of the source samples has a deprecated model *)
	If[Not[MatchQ[deprecatedInvalidInputs,{}]]&&!gatherTests,
		Message[Error::DeprecatedSourceModels,sourceWithDeprecatedModels,deprecatedSourceModelIndices,deprecatedInvalidInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[deprecatedInvalidInputs]==0,
				Nothing,
				Test["The provided source sample models "<>ObjectToString[deprecatedInvalidInputs,Cache->simulatedCache]<>" from primitives at index "<>ToString[deprecatedSourceModelIndices]<>" are not deprecated:",True,False]
			];

			passingTest=If[Length[deprecatedInvalidInputs]==Length[sourceModelPacketsNoNull],
				Nothing,
				Test["The provided source sample models "<>ObjectToString[Complement[Cases[sourceSampleModels,ObjectP[]],deprecatedInvalidInputs],Cache->simulatedCache]<>" from primitives at index "<>ToString[undeprecatedSourceModelIndices]<>" are not deprecated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 18. non-liquid source error *)

	(* get the primitive indices with non-liquid source samples *)
	nonLiquidSourceIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,sourceStateErrors]];

	(* get the primitive indices with liquid source samples *)
	liquidSourceIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,sourceStateErrors,False]];

	(* throw an error message for any of the source samples is not liquid *)
	If[Not[MatchQ[sourceWithInvalidStates,{}]]&&!gatherTests,
		Message[Error::NonLiquidSourceSamples,ObjectToString[sourceWithInvalidStates,Cache->simulatedCache],nonLiquidSourceIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonLiquidSourceTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[sourceWithInvalidStates]==0,
				Nothing,
				Test["The provided source samples "<>ObjectToString[sourceWithInvalidStates,Cache->simulatedCache]<>" from primitives at index "<>ToString[nonLiquidSourceIndices]<>" are in a liquid state:",True,False]
			];

			passingTest=If[Length[sourceWithInvalidStates]==Length[simulatedSamples],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[simulatedSamples,sourceWithInvalidStates],Cache->simulatedCache]<>" from primitives at index "<>ToString[liquidSourceIndices]<>" are in a liquid state:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 19. container-less source sample error *)

	(* get the primitive indices with container-less source samples *)
	containerlessSourceIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,containerlessSourceErrors]];

	(* get the primitive indices without container-less source samples *)
	sourceWithContainerIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,containerlessSourceErrors,False]];

	(* if there are container-less samples and we are throwing messages, throw an error message *)
	If[Not[MatchQ[containerlessSamples,{}]]&&!gatherTests,
		Message[Error::PrimitivesWithContainerlessSamples,ObjectToString[containerlessSamples,Cache->simulatedCache],containerlessSourceIndices]
	];

	(* if we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessSamples]==0,
				Nothing,
				Test["The provided source samples "<>ObjectToString[containerlessSamples,Cache->simulatedCache]<>" from primitives at index "<>ToString[containerlessSourceIndices]<>" are in a container:",True,False]
			];

			passingTest=If[Length[containerlessSamples]==Length[simulatedSamples],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[simulatedSamples,containerlessSamples],Cache->simulatedCache]<>" from primitives at index "<>ToString[sourceWithContainerIndices]<>" are in a container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 20. invalid source container error *)

	(* get the primitive indices with incompatible source containers *)
	invalidSourceContainerIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,invalidSourceContainerErrors]];

	(* get the primitive indices with compatible source containers *)
	validSourceContainerIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,invalidSourceContainerErrors,False]];

	(* throw an error message if the source container is incompatible *)
	If[Not[MatchQ[sourceWithInvalidContainers,{}]]&&!gatherTests,
		Message[Error::IncompatibleSourceContainer,ObjectToString[sourceWithInvalidContainers,Cache->simulatedCache],invalidSourceContainerIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	compatibleSourceContainerTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[sourceWithInvalidContainers,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[sourceWithInvalidContainers,Cache->simulatedCache]<>" from primitives at index "<>ToString[invalidSourceContainerIndices]<>" are located in containers that are compatible with an acoustic liquid handler:",True,False]
			];

			passingTest=If[Length[sourceWithInvalidContainers]==Length[simulatedSamples],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[sourceSamplesWithContainer,sourceWithInvalidContainers],Cache->simulatedCache]<>" from primitives at index "<>ToString[validSourceContainerIndices]<>" are located in containers that are compatible with an acoustic liquid handler:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* ---DESTINATION CONTAINER CHECK--- *)

	(* 21. discarded destination container error *)

	(* get the primitive indices with discarded destination container *)
	discardedDestinationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,discardedDestContainerErrors]];

	(* get the index of all primitives with supplied destination container objects *)
	primitivesWithSuppliedDestObjects=Map[
		If[Cases[#[Destination],ObjectP[Object[Container]],Infinity]=={},
			Nothing,
			#[Index]
		]&,
		splitPrimitives
	];

	(* get the primitive indices with undiscarded destination container *)
	undiscardedDestinationIndices=Intersection[PickList[parentPrimitiveIndices,discardedDestContainerErrors,False],primitivesWithSuppliedDestObjects];

	(* throw an error message for any of the destination containers is discarded *)
	If[Not[MatchQ[discardedDestContainers,{}]]&&!gatherTests,
		Message[Error::DiscardedDestinationContainer,ObjectToString[discardedDestContainers,Cache->simulatedCache],discardedDestinationIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedDestinationContainerTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[discardedDestContainers,{}],
				Nothing,
				Test["The provided destination container "<>ObjectToString[discardedDestContainers,Cache->simulatedCache]<>" from primitives at index "<>ToString[discardedDestinationIndices]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedDestContainers]==Length[destinationContainers],
				Nothing,
				Test["The provided destination container "<>ObjectToString[Complement[destinationContainers,discardedDestContainers],Cache->simulatedCache]<>" from primitives at index "<>ToString[undiscardedDestinationIndices]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 22. deprecated destination container's model error *)

	(* get the primitive indices with deprecated destination container model *)
	deprecatedDestinationModelIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,deprecatedDestContainerErrors]];

	(* get the index of all primitives with supplied destination container models *)
	primitivesWithSuppliedDestModels=Map[
		If[Cases[#[Destination],ObjectP[Model[Container]],Infinity]=={},
			Nothing,
			#[Index]
		]&,
		splitPrimitives
	];

	(* get the primitive indices with undeprecated destination container model *)
	undeprecatedDestinationIndices=Intersection[PickList[parentPrimitiveIndices,deprecatedDestContainerErrors,False],primitivesWithSuppliedDestModels];

	(* throw an error message for any of the destination container models is deprecated *)
	If[Not[MatchQ[deprecatedDestContainerModels,{}]]&&!gatherTests,
		Message[Error::DeprecatedDestinationContainerModel,ObjectToString[deprecatedDestContainerModels,Cache->simulatedCache],deprecatedDestinationModelIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedDestinationContainerModelTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[deprecatedDestContainerModels,{}],
				Nothing,
				Test["The provided destination container model "<>ObjectToString[deprecatedDestContainerModels,Cache->simulatedCache]<>" from primitives at index "<>ToString[deprecatedDestinationModelIndices]<>" are not deprecated:",True,False]
			];

			passingTest=If[Length[deprecatedDestContainerModels]==Length[suppliedDestinationContainerModels],
				Nothing,
				Test["The provided destination container model "<>ObjectToString[Complement[suppliedDestinationContainerModels,deprecatedDestContainerModels],Cache->simulatedCache]<>" from primitives at index "<>ToString[undeprecatedDestinationIndices]<>" are not deprecated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 23. invalid destination container error *)
	(* since either container model or object can be supplied by the user as destination, we need to make sure we put the correct object in the message/test *)

	(* get the user-supplied destination OBJECTS from the primitives. can be either Object[Sample], Object[Container] or Model[Container] *)
	indexMatchedSuppliedDestinations=Map[
		Switch[#,
			ObjectP[],#,
			_,First@Cases[#,ObjectP[],Infinity]
		]&,
		indexMatchedRawDestinations
	];

	(* get the primitive indices with incompatible destination container *)
	incompatibleDestinationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,invalidDestContainerErrors]];

	(* get the incompatible, user-supplied destination objects *)
	incompatibleDestinationObjects=DeleteDuplicates[PickList[indexMatchedSuppliedDestinations,invalidDestContainerErrors]];

	(* get the primitive indices with compatible destination container *)
	compatibleDestinationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,invalidDestContainerErrors,False]];

	(* get the compatible, user-supplied destination objects *)
	compatibleDestinationObjects=DeleteDuplicates[PickList[indexMatchedSuppliedDestinations,invalidDestContainerErrors,False]];

	(* get the invalid Fields of each the incompatible destination object *)
	invalidFieldsOfSuppliedDestObjects=Lookup[incompatibleDestContainerFieldsLookup,(incompatibleDestinationObjects/.destinationObjsModelLookup)];

	(* throw an error message for any of the incompatible destination containers *)
	If[Not[MatchQ[incompatibleDestinationObjects,{}]]&&!gatherTests,
		Message[Error::IncompatibleDestinationContainer,
			ObjectToString[incompatibleDestinationObjects,Cache->simulatedCache],
			incompatibleDestinationIndices,
			invalidFieldsOfSuppliedDestObjects
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidDestinationContainerTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[incompatibleDestinationObjects,{}],
				Nothing,
				Test["The container models of the provided destination object "<>ObjectToString[incompatibleDestinationObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[incompatibleDestinationIndices]<>" are compatible with the acoustic liquid handler:",True,False]
			];

			passingTest=If[MatchQ[compatibleDestinationObjects,{}],
				Nothing,
				Test["The container models of the provided destination object "<>ObjectToString[compatibleDestinationObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[compatibleDestinationIndices]<>" are compatible with the acoustic liquid handler:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 24. unable to create labware definition error *)

	(* get the primitive indices with missing labware definition required Fields *)
	invalidLabwareDestinationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,destLabwareDefinitionErrors]];

	(* get the invalid, user-supplied destination objects *)
	invalidLabwareDestinationObjects=DeleteDuplicates[PickList[indexMatchedSuppliedDestinations,destLabwareDefinitionErrors]];

	(* get the primitive indices with complete labware definition required Fields *)
	validLabwareDestinationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,destLabwareDefinitionErrors,False]];

	(* get the valid, user-supplied destination objects *)
	validLabwareDestinationObjects=DeleteDuplicates[PickList[indexMatchedSuppliedDestinations,destLabwareDefinitionErrors,False]];

	(* get the Nulled Fields required for creating labware definition for each destination object *)
	nulledFieldsOfSuppliedDestObjects=Lookup[nulledRequiredFieldsLookup,(invalidLabwareDestinationObjects/.destinationObjsModelLookup)];

	(* throw an error message for any of the destination objects missing labware definition required Fields *)
	If[Not[MatchQ[invalidLabwareDestinationObjects,{}]]&&!gatherTests,
		Message[Error::MissingLabwareDefinitionFields,
			ObjectToString[invalidLabwareDestinationObjects,Cache->simulatedCache],
			invalidLabwareDestinationIndices,
			nulledFieldsOfSuppliedDestObjects
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidLabwareTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[invalidLabwareDestinationObjects,{}],
				Nothing,
				Test["The container models of the provided destination object "<>ObjectToString[invalidLabwareDestinationObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[invalidLabwareDestinationIndices]<>" have all required Fields to create labware definition for the instrument:",True,False]
			];

			passingTest=If[MatchQ[validLabwareDestinationObjects,{}],
				Nothing,
				Test["The container models of the provided destination object "<>ObjectToString[validLabwareDestinationObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[validLabwareDestinationIndices]<>" have all required Fields to create labware definition for the instrument:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 25. pre-filled destination plate with unsafe volume error *)

	(* get the primitive indices with unsafe pre-filled volume *)
	unsafeDestVolumeIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,unsafeDestVolumeErrors]];

	(* get the invalid, user-supplied destination objects *)
	unsafeDestVolumeObjects=DeleteDuplicates[PickList[indexMatchedSuppliedDestinations,unsafeDestVolumeErrors]];

	(* get valid supplied objects and their corresponding primitive indices *)
	safeDestVolumeTuples=MapThread[
		Function[{destObj,primitiveIndex},
			If[MemberQ[unsafeDestVolumeObjects,destObj]||MatchQ[destObj,ObjectP[Model[Container]]],
				(* return nothing if destination object is in unsafe list or supplied as a model *)
				Nothing,
				(* otherwise, check if it's a sample or a plate *)
				Switch[destObj,
					(* if the object is a sample, return the object and the primitive index *)
					ObjectP[Object[Sample]],
						{destObj,primitiveIndex},
					(* if the object is a plate, only return if it is not empty *)
					_,
						If[Lookup[fetchPacketFromCache[destObj,simulatedCache],Contents]=={},
							Nothing,
							{destObj,primitiveIndex}
						]
				]
			]
		],
		{indexMatchedSuppliedDestinations,parentPrimitiveIndices}
	];

	(* separate the objects from the indices and delete duplicates *)
	{safeDestVolumeObjects,safeDestVolumeIndices}=If[MatchQ[safeDestVolumeTuples,{}],
		{{},{}},
		DeleteDuplicates/@Transpose[safeDestVolumeTuples]
	];

	(* throw an error message for any of the destination container models is deprecated *)
	If[Not[MatchQ[unsafeDestVolumeObjects,{}]]&&!gatherTests,
		Message[Error::UnsafeDestinationVolume,
			ObjectToString[unsafeDestVolumeObjects,Cache->simulatedCache],
			unsafeDestVolumeIndices
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	unsafeDestVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[unsafeDestVolumeObjects,{}],
				Nothing,
				Test["The containers of the provided destination object "<>ObjectToString[unsafeDestVolumeObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[unsafeDestVolumeIndices]<>" have occupied wells that will not spill when the plate is inverted during acoustic liquid handling:",True,False]
			];

			passingTest=If[MatchQ[safeDestVolumeObjects,{}],
				Nothing,
				Test["The containers of the provided destination object "<>ObjectToString[safeDestVolumeObjects,Cache->simulatedCache]<>" from primitives at index "<>ToString[safeDestVolumeIndices]<>" have occupied wells that will not spill when the plate is inverted during acoustic liquid handling:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* ---AMOUNT PRECISION CHECK--- *)

	(* 1. amount precision warning *)

	(* get the primitive indices with amount precision warning *)
	precisionWarningIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,amountPrecisionWarnings]];

	(* get the overly precise supplied amounts and their rounded values *)
	overlyPreciseAmounts=PickList[suppliedAmounts,amountPrecisionWarnings];
	roundedOverlyPreciseAmounts=PickList[roundedAmounts,amountPrecisionWarnings];

	(* throw a warning message if we have too precise primitive amount *)
	If[Not[MatchQ[precisionWarningIndices,{}]]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::InstrumentPrecision,
			(*1*)"Amount(s) Key of primitive at index: "<>ToString[precisionWarningIndices],
			(*2*)EmeraldUnits`Private`quantityToSymbol[N[dropletResolution]],
			(*3*)EmeraldUnits`Private`quantityToSymbol[N[overlyPreciseAmounts]],
			(*4*)EmeraldUnits`Private`quantityToSymbol[N[overlyPreciseAmounts]],
			(*5*)EmeraldUnits`Private`quantityToSymbol[N[roundedOverlyPreciseAmounts]]
		]
	];

	(* If we are gathering tests, create tests with the appropriate result. *)
	precisionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[precisionWarningIndices,{}],
				Nothing,
				Warning["The precision of the user-supplied Amount(s) in primitives at index "<>ToString[precisionWarningIndices]<>" is compatible with instrumental precision:",True,False]
			];

			passingTest=If[Length[precisionWarningIndices]==Length[DeleteDuplicates[parentPrimitiveIndices]],
				Nothing,
				Warning["The precision of the user-supplied Amount(s) in primitives at index "<>ToString[Complement[parentPrimitiveIndices,precisionWarningIndices]]<>" is compatible with instrumental precision:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 2. amount out of instrument range error *)

	(* get the primitive indices with out-of-range amount *)
	outOfRangeAmountIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,outOfRangeAmountErrors]];

	(* get the out-of-range amount *)
	outOfRangeAmounts=DeleteDuplicates[PickList[suppliedAmounts,outOfRangeAmountErrors]];

	(* throw an error message for any of the primitives out-of-range amount *)
	If[Not[MatchQ[outOfRangeAmounts,{}]]&&!gatherTests,
		Message[Error::AmountOutOfRange,
			(*1*)EmeraldUnits`Private`quantityToSymbol[N[outOfRangeAmounts]],
			(*2*)outOfRangeAmountIndices,
			(*3*)ObjectToString[specifiedInstrument,Cache->simulatedCache],
			(*4*)EmeraldUnits`Private`quantityToSymbol[N[instrumentsMinAllowedVolume]],
			(*5*)EmeraldUnits`Private`quantityToSymbol[N[instrumentsMaxAllowedVolume]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	outOfRangeAmountTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[outOfRangeAmounts,{}],
				Nothing,
				Test["The Amount(s) supplied in primitives at index "<>ToString[outOfRangeAmountIndices]<>" are within the instrument's range:",True,False]
			];

			passingTest=If[Length[outOfRangeAmountIndices]==Length[DeleteDuplicates[parentPrimitiveIndices]],
				Nothing,
				Test["The Amount(s) supplied in primitives at index "<>ToString[Complement[parentPrimitiveIndices,outOfRangeAmountIndices]]<>" are within the instrument's range:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 3. insufficient sample volume error *)

	(* get the source samples with insufficient volume *)
	samplesWithInsufficientVolume=Flatten[PickList[indexMatchedSourceSamples,insufficientSourceAmountErrors]];

	(* get the index of primitives with samples that have insufficient volume *)
	samplesWithInsufficientVolumeIndices=Flatten[PickList[parentPrimitiveIndices,insufficientSourceAmountErrors]];

	(* get the source samples with sufficient volume *)
	samplesWithSufficientVolume=DeleteDuplicates[Flatten[PickList[indexMatchedSourceSamples,insufficientSourceAmountErrors,False]]];

	(* get the index of primitives with samples that have insufficient volume *)
	samplesWithSufficientVolumeIndices=DeleteDuplicates[Flatten[PickList[parentPrimitiveIndices,insufficientSourceAmountErrors,False]]];

	(* group by source samples to get index of primitives that we cannot perform *)
	insufficientSamplesIndexLookup=DeleteDuplicates/@GroupBy[Transpose[{samplesWithInsufficientVolume,samplesWithInsufficientVolumeIndices}],First->Last];

	(* get the insufficient samples without duplicates *)
	insufficientSamplesNoDupes=Keys[insufficientSamplesIndexLookup];

	(* throw an error message for any source samples with insufficient volume  *)
	If[Not[MatchQ[insufficientSamplesNoDupes,{}]]&&!gatherTests,
		Message[Error::InsufficientSourceVolume,
			ObjectToString[insufficientSamplesNoDupes,Cache->simulatedCache],
			Values[insufficientSamplesIndexLookup],
			EmeraldUnits`Private`quantityToSymbol[N[Lookup[allSamplesDeadVolumesAssoc,insufficientSamplesNoDupes]]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	insufficientSourceSampleVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[insufficientSamplesNoDupes,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[insufficientSamplesNoDupes,Cache->simulatedCache]<>" have sufficient volume to perform all manipulations defined in the primitives:",True,False]
			];

			passingTest=If[MatchQ[samplesWithSufficientVolume,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[samplesWithSufficientVolume,Cache->simulatedCache]<>" have sufficient volume to perform all manipulations defined in the primitives:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 4. same plate transfer error *)

	(* get the primitive indices with same-plate transfer *)
	samePlateTransferIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,samePlateTransferErrors]];

	(* get the primitive indices without same-plate transfer *)
	differentPlateTransferIndices=Complement[parentPrimitiveIndices,samePlateTransferIndices];

	(* if there are primitives with same-plate transfer and we are throwing messages, throw an error message *)
	If[Not[MatchQ[samePlateTransferIndices,{}]]&&!gatherTests,
		Message[Error::SamePlateTransfer,samePlateTransferIndices]
	];

	(* if we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	samePlateTransferTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[samePlateTransferIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[samePlateTransferIndices]<>" do not contain manipulations that involve transfer between source and destination wells within the same container:",True,False]
			];

			passingTest=If[MatchQ[differentPlateTransferIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[differentPlateTransferIndices]<>" do not contain manipulations that involve transfer between source and destination wells within the same container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 5. invalid destination well error *)

	(* get the primitives with invalid destination well *)
	primitivesWithInvalidDestWell=PickList[splitPrimitives,invalidDestinationWellErrors];

	(* get the invalid locations and their parent primitive index in the form {well, container, index} *)
	invalidDestLocationTuples=Map[
		{
			First@Cases[#[Destination],WellPositionP,Infinity],
			First@Cases[#[Destination],ObjectP[],Infinity],
			#[Index]
		}&,
		primitivesWithInvalidDestWell
	];

	(* consolidate wells, container, and indices into separate index-matching lists *)
	{invalidDestinationWells,containersWithInvalidWells,primitivesWithInvalidDestWellIndices}=If[MatchQ[invalidDestLocationTuples,{}],
		{{},{},{}},
		Transpose[DeleteDuplicates[invalidDestLocationTuples]]
	];

	(* throw an error message if there's any invalid destination wells *)
	If[Not[MatchQ[primitivesWithInvalidDestWellIndices,{}]]&&!gatherTests,
		Message[Error::InvalidDestinationWellAcousticLiquidHandling,invalidDestinationWells,primitivesWithInvalidDestWellIndices,containersWithInvalidWells]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidDestinationWellTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[primitivesWithInvalidDestWellIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[DeleteDuplicates[primitivesWithInvalidDestWellIndices]]<>" have valid destination wells:",True,False]
			];

			passingTest=If[Complement[parentPrimitiveIndices,primitivesWithInvalidDestWellIndices]=={},
				Nothing,
				Test["The input primitives at index "<>ToString[Complement[parentPrimitiveIndices,primitivesWithInvalidDestWellIndices]]<>" have valid destination wells:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 6. over-filling destination well error *)

	(* get the over-filled destination samples *)
	(* Note: some of the samples are simulated ones that we created for volume tracking *)
	overFilledDestSamples=PickList[indexMatchedDestinationSamples,overFillingDestErrors];

	(* get the over-filled user-supplied destination key value *)
	overFilledSuppliedDestinations=PickList[indexMatchedRawDestinations,overFillingDestErrors];

	(* create a supplied destination replace rule for destination samples *)
	overFilledSampleToSuppliedDestLookup=Rule@@@Transpose[{overFilledDestSamples,overFilledSuppliedDestinations}];

	(* get the index of primitives with samples that have insufficient volume *)
	overFilledDestIndices=PickList[parentPrimitiveIndices,overFillingDestErrors];

	(* consolidate supplied destination and primitive indices into {destSample, index} *)
	overFilledDestTuples=Transpose[{overFilledDestSamples,overFilledDestIndices}];

	(* group by destination samples to get index of primitives with over-filled destination *)
	groupedOverFilled=DeleteDuplicates/@GroupBy[overFilledDestTuples,First->Last];

	(* get the over-filled destination sample without duplicates *)
	overFilledDestNoDupes=Keys[groupedOverFilled];

	(* get the over-filled supplied destinations *)
	overFilledSuppliedDestNoDupes=Lookup[overFilledSampleToSuppliedDestLookup,overFilledDestNoDupes];

	(* throw an error message for any destination with over-filled volume  *)
	If[Not[MatchQ[overFilledSuppliedDestNoDupes,{}]]&&!gatherTests,
		Message[Error::OverFilledDestinationVolume,
			ObjectToString[overFilledSuppliedDestNoDupes,Cache->simulatedCache],
			Values[groupedOverFilled],
			EmeraldUnits`Private`quantityToSymbol[N[Lookup[allSamplesMaxVolumesAssoc,overFilledDestNoDupes]]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	overFilledDestinationVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[overFilledDestIndices,{}],
				Nothing,
				Test["The manipulation to be performed in input primitives at index "<>ToString[DeleteDuplicates[overFilledDestIndices]]<>" do not overfill destination wells:",True,False]
			];

			passingTest=If[Complement[parentPrimitiveIndices,overFilledDestIndices]=={},
				Nothing,
				Test["The manipulation to be performed in input primitives at index "<>ToString[Complement[parentPrimitiveIndices,overFilledDestIndices]]<>" do not overfill destination wells:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 7. InWellSeparation not allowed Key error *)

	(* get the primitive indices with invalid InWellSeparation Key *)
	invalidInWellSeparationKeyIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,inWellSeparationNotAllowedKeyErrors]];

	(* get the primitive indices with valid InWellSeparation Key *)
	validInWellSeparationKeyIndices=Complement[parentPrimitiveIndices,invalidInWellSeparationKeyIndices];

	(* if there are primitives with invalid InWellSeparation Key and we are throwing messages, throw an error message *)
	If[Not[MatchQ[invalidInWellSeparationKeyIndices,{}]]&&!gatherTests,
		Message[Error::InvalidInWellSeparationKey,invalidInWellSeparationKeyIndices]
	];

	(* if we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidInWellSeparationKeyTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[invalidInWellSeparationKeyIndices,{}],
				Nothing,
				Test["The InWellSeparation Key of the input primitives at index "<>ToString[invalidInWellSeparationKeyIndices]<>" is set to False when physical separation of droplets in the destination well is not possible:",True,False]
			];

			passingTest=If[MatchQ[validInWellSeparationKeyIndices,{}],
				Nothing,
				Test["The InWellSeparation Key of the input primitives at index "<>ToString[validInWellSeparationKeyIndices]<>" is set to False when physical separation of droplets in the destination well is not possible:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 8. conflicting InWellSeparation option/key error *)

	(* we allow 2 ways of specifying InWellSeparation *)
	(* 1. by including InWellSeparation Key in the input primitive *)
	(* 2. by specifying InWellSeparation Option that is index-matched to the raw input primitives *)
	(* we check here if there's a mismatch between Key and Option values *)

	(* get the primitive indices with InWellSeparation Key and Option conflict *)
	inWellSeparationConflictIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,inWellSeparationConflictErrors]];

	(* throw an error message if there's any conflict between InWellSeparation Key and Option *)
	If[Not[MatchQ[inWellSeparationConflictIndices,{}]]&&!gatherTests,
		Message[Error::InWellSeparationKeyOptionMismatch,inWellSeparationConflictIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	inWellSeparationKeyOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[inWellSeparationConflictIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[inWellSeparationConflictIndices]<>" have matching InWellSeparation Key and Option values:",True,False]
			];

			passingTest=If[Length[inWellSeparationConflictIndices]==Length[myPrimitives],
				Nothing,
				Test["The input primitives at index "<>ToString[Complement[parentPrimitiveIndices,inWellSeparationConflictIndices]]<>" have matching InWellSeparation Key and Option values:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* stash the InWellSeparation option if there's a conflict *)
	inWellSeparationConflictOption=If[MemberQ[inWellSeparationConflictErrors,True],
		{InWellSeparation},
		{}
	];

	(* 9. InWellSeparation not allowed Option error *)

	(* get the primitive indices with invalid InWellSeparation Option *)
	invalidInWellSeparationOptionIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,inWellSeparationNotAllowedOptionErrors]];

	(* get the primitive indices with valid InWellSeparation Option *)
	validInWellSeparationOptionIndices=Complement[parentPrimitiveIndices,invalidInWellSeparationOptionIndices];

	(* if there are primitives with invalid InWellSeparation Option and we are throwing messages, throw an error message *)
	If[Not[MatchQ[invalidInWellSeparationOptionIndices,{}]]&&!gatherTests,
		Message[Error::InvalidInWellSeparationOption,invalidInWellSeparationOptionIndices]
	];

	(* if we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidInWellSeparationOptionTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[invalidInWellSeparationOptionIndices,{}],
				Nothing,
				Test["The InWellSeparation Option of the input primitives at index "<>ToString[invalidInWellSeparationOptionIndices]<>" is set to False when physical separation of droplets in the destination well is not possible:",True,False]
			];

			passingTest=If[MatchQ[validInWellSeparationOptionIndices,{}],
				Nothing,
				Test["The InWellSeparation Option of the input primitives at index "<>ToString[validInWellSeparationOptionIndices]<>" is set to False when physical separation of droplets in the destination well is not possible:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* stash the InWellSeparation option if set to True when not allowed *)
	inWellSeparationNotAllowedOption=If[MemberQ[inWellSeparationNotAllowedOptionErrors,True],
		{InWellSeparation},
		{}
	];

	(* 10. glycerol percentage out of range error *)

	(* get the source samples with too high glycerol concentration *)
	highGlycerolSamples=Flatten[PickList[indexMatchedSourceSamples,glycerolPercentageErrors]];

	(* get the index of primitives with with too high glycerol *)
	highGlycerolSamplesIndices=Flatten[PickList[parentPrimitiveIndices,glycerolPercentageErrors]];

	(* get the source samples with valid glycerol concentration *)
	validGlycerolSamples=DeleteDuplicates[Flatten[PickList[indexMatchedSourceSamples,glycerolPercentageErrors,False]]];

	(* get the index of primitives with valid glycerol concentration *)
	validGlycerolSamplesIndices=DeleteDuplicates[Flatten[PickList[parentPrimitiveIndices,glycerolPercentageErrors,False]]];

	(* group by source samples to get index of primitives with too high glycerol *)
	highGlycerolSamplesIndexLookup=DeleteDuplicates/@GroupBy[Transpose[{highGlycerolSamples,highGlycerolSamplesIndices}],First->Last];

	(* get the invalid samples without duplicates *)
	highGlycerolSamplesNoDupes=Keys[highGlycerolSamplesIndexLookup];

	(* throw an error message for any source samples with too high glycerol concentration  *)
	If[Not[MatchQ[highGlycerolSamplesNoDupes,{}]]&&!gatherTests,
		Message[Error::GlycerolConcentrationTooHigh,
			ObjectToString[highGlycerolSamplesNoDupes,Cache->simulatedCache],
			Values[highGlycerolSamplesIndexLookup],
			EmeraldUnits`Private`quantityToSymbol[N[50 VolumePercent]]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	samplesWithTooHighGlycerolTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[highGlycerolSamplesNoDupes,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[highGlycerolSamplesNoDupes,Cache->simulatedCache]<>" have glycerol concentration of 50% or less:",True,False]
			];

			passingTest=If[MatchQ[validGlycerolSamples,{}],
				Nothing,
				Test["The provided source samples "<>ObjectToString[validGlycerolSamples,Cache->simulatedCache]<>" have glycerol concentration of 50% or less:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 11. FluidTypeCalibration/FluidAnalysisMeasurement options mismatch error *)

	(* get the primitive indices with FluidTypeCalibration/FluidAnalysisMeasurement option value mismatch *)
	calibrationMeasurementMismatchIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,calibrationMeasurementMismatchErrors]];

	(* throw an error message if there's any conflict between FluidTypeCalibration/FluidAnalysisMeasurement options *)
	If[Not[MatchQ[calibrationMeasurementMismatchIndices,{}]]&&!gatherTests,
		Message[Error::CalibrationAndMeasurementTypeMismatch,calibrationMeasurementMismatchIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	calibrationMeasurementMismatchTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[calibrationMeasurementMismatchIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[calibrationMeasurementMismatchIndices]<>" have matching FluidTypeCalibration and FluidAnalysisMeasurement Option values:",True,False]
			];

			passingTest=If[Length[calibrationMeasurementMismatchIndices]==Length[myPrimitives],
				Nothing,
				Test["The input primitives at index "<>ToString[Complement[parentPrimitiveIndices,calibrationMeasurementMismatchIndices]]<>" have matching FluidTypeCalibration and FluidAnalysisMeasurement Option values:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* stash both options if there's a conflict *)
	calibrationMeasurementMismatchOptions=If[MemberQ[calibrationMeasurementMismatchErrors,True],
		{FluidTypeCalibration,FluidAnalysisMeasurement},
		{}
	];

	(* 12. invalid FluidTypeCalibration option error *)

	(* get the primitive indices with FluidTypeCalibration option error *)
	invalidCalibrationIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,calibrationInvalidOptionErrors]];

	(* throw an error message for primitives with invalid FluidTypeCalibration option  *)
	If[Not[MatchQ[invalidCalibrationIndices,{}]]&&!gatherTests,
		Message[Error::InvalidFluidTypeCalibration,invalidCalibrationIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidFluidTypeCalibrationTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[invalidCalibrationIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[invalidCalibrationIndices]<>" have valid FluidTypeCalibration Option value:",True,False]
			];

			passingTest=If[Length[invalidCalibrationIndices]==Length[myPrimitives],
				Nothing,
				Test["The input primitives at index "<>ToString[Complement[parentPrimitiveIndices,invalidCalibrationIndices]]<>" have valid FluidTypeCalibration Option value:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* stash the FluidTypeCalibration option if there's any error *)
	fluidTypeCalibrationErrorOption=If[MemberQ[calibrationInvalidOptionErrors,True],
		{FluidTypeCalibration},
		{}
	];

	(* 13. invalid FluidAnalysisMeasurement option error *)

	(* get the primitive indices with FluidAnalysisMeasurement option error *)
	invalidMeasurementIndices=DeleteDuplicates[PickList[parentPrimitiveIndices,measurementInvalidOptionErrors]];

	(* throw an error message for primitives with invalid FluidAnalysisMeasurement option  *)
	If[Not[MatchQ[invalidMeasurementIndices,{}]]&&!gatherTests,
		Message[Error::InvalidFluidAnalysisMeasurement,invalidMeasurementIndices]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidFluidAnalysisMeasurementTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[invalidMeasurementIndices,{}],
				Nothing,
				Test["The input primitives at index "<>ToString[invalidMeasurementIndices]<>" have valid FluidAnalysisMeasurement Option value:",True,False]
			];

			passingTest=If[Length[invalidMeasurementIndices]==Length[myPrimitives],
				Nothing,
				Test["The input primitives at index "<>ToString[Complement[parentPrimitiveIndices,invalidMeasurementIndices]]<>" have valid FluidAnalysisMeasurement Option value:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* stash the FluidAnalysisMeasurement option if there's any error *)
	fluidAnalysisMeasurementErrorOption=If[MemberQ[measurementInvalidOptionErrors,True],
		{FluidAnalysisMeasurement},
		{}
	];

	(* 14. invalid FluidTypeCalibration option warning *)

	(* get the source samples with FluidTypeCalibration option warning *)
	calibrationWarningSamples=PickList[indexMatchedSourceSamples,calibrationInvalidOptionWarnings];

	(* get the primitive indices with FluidTypeCalibration option warning *)
	calibrationWarningIndices=PickList[parentPrimitiveIndices,calibrationInvalidOptionWarnings];

	(* get the source samples with appropriate FluidTypeCalibration *)
	goodCalibrationSamples=DeleteDuplicates[Flatten[PickList[indexMatchedSourceSamples,calibrationInvalidOptionWarnings,False]]];

	(* get the index of primitives with appropriate FluidTypeCalibration *)
	goodCalibrationSamplesIndices=DeleteDuplicates[Flatten[PickList[parentPrimitiveIndices,calibrationInvalidOptionWarnings,False]]];

	(* group by source samples to get index of primitives with FluidTypeCalibration option warning *)
	calibrationWarningSamplesIndexLookup=DeleteDuplicates/@GroupBy[Transpose[{calibrationWarningSamples,calibrationWarningIndices}],First->Last];

	(* get the samples with warning without duplicates *)
	calibrationWarningSamplesNoDupes=Keys[calibrationWarningSamplesIndexLookup];

	(* throw a warning message for primitives with inappropriate FluidTypeCalibration option *)
	If[Not[MatchQ[calibrationWarningSamplesNoDupes,{}]]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::FluidTypeCalibrationMismatch,
			Values[calibrationWarningSamplesIndexLookup],
			ObjectToString[calibrationWarningSamplesNoDupes,Cache->simulatedCache]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	fluidTypeCalibrationWarningTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[calibrationWarningIndices,{}],
				Nothing,
				Warning["The input primitives at index "<>ToString[DeleteDuplicates[calibrationWarningIndices]]<>" have the FluidTypeCalibration Option set to the intended value for the composition of samples "<>ObjectToString[calibrationWarningSamplesNoDupes,Cache->simulatedCache]<>" :",True,False]
			];

			passingTest=If[MatchQ[goodCalibrationSamplesIndices,{}],
				Nothing,
				Warning["The input primitives at index "<>ToString[goodCalibrationSamplesIndices]<>" have the FluidTypeCalibration Option set to the intended value for the composition of samples "<>ObjectToString[goodCalibrationSamples,Cache->simulatedCache]<>" :",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* 15. invalid FluidAnalysisMeasurement option warning *)

	(* get the source samples with FluidAnalysisMeasurement option warning *)
	measurementWarningSamples=PickList[indexMatchedSourceSamples,measurementInvalidOptionWarnings];

	(* get the primitive indices with FluidAnalysisMeasurement option warning *)
	measurementWarningIndices=PickList[parentPrimitiveIndices,measurementInvalidOptionWarnings];

	(* get the source samples with appropriate FluidAnalysisMeasurement *)
	goodMeasurementSamples=DeleteDuplicates[Flatten[PickList[indexMatchedSourceSamples,measurementInvalidOptionWarnings,False]]];

	(* get the index of primitives with appropriate FluidAnalysisMeasurement *)
	goodMeasurementSamplesIndices=DeleteDuplicates[Flatten[PickList[parentPrimitiveIndices,measurementInvalidOptionWarnings,False]]];

	(* group by source samples to get index of primitives with FluidAnalysisMeasurement option warning *)
	measurementWarningSamplesIndexLookup=DeleteDuplicates/@GroupBy[Transpose[{measurementWarningSamples,measurementWarningIndices}],First->Last];

	(* get the samples with warning without duplicates *)
	measurementWarningSamplesNoDupes=Keys[measurementWarningSamplesIndexLookup];

	(* throw a warning message for primitives with inappropriate FluidAnalysisMeasurement option *)
	If[Not[MatchQ[measurementWarningSamplesNoDupes,{}]]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::FluidAnalysisMeasurementMismatch,
			Values[measurementWarningSamplesIndexLookup],
			ObjectToString[measurementWarningSamplesNoDupes,Cache->simulatedCache]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	fluidAnalysisMeasurementWarningTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[measurementWarningIndices,{}],
				Nothing,
				Warning["The input primitives at index "<>ToString[DeleteDuplicates[measurementWarningIndices]]<>" have the FluidAnalysisMeasurement Option set to the intended value for the composition of samples "<>ObjectToString[measurementWarningSamplesNoDupes,Cache->simulatedCache]<>" :",True,False]
			];

			passingTest=If[MatchQ[goodMeasurementSamplesIndices,{}],
				Nothing,
				Warning["The input primitives at index "<>ToString[goodMeasurementSamplesIndices]<>" have the FluidAnalysisMeasurement Option set to the intended value for the composition of samples "<>ObjectToString[goodMeasurementSamples,Cache->simulatedCache]<>" :",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* ------------------------- *)
	(* ---OPTIMIZE PRIMITIVES--- *)
	(* ------------------------- *)

	(* optimize based on option value *)
	(* 1. OptimizeThroughput: rearrange primitive sequence to minimize plate changes *)
	(* 2. SourcePlateCentric: minimize source plate change only (group similar source plates together) *)
	(* 3. DestinationPlateCentric: minimize destination plate change only (group similar destination plates together) *)
	(* 4. PreserveTransferOrder: leave the primitive sequence untouched *)

	(* check if there's only one pair of source-destination plates. throw a warning if needed *)
	(* Note: nothing to optimize if that is the case *)
	allContainersNoDupes=DeleteDuplicates[Cases[sourceToDestTuples,ObjectP[],Infinity]];
	optimizableQ=Length[allContainersNoDupes]>2;

	(* get the OptimizePrimitives Option value *)
	optimizePrimitivesOption=Lookup[myOptions,OptimizePrimitives];

	(* check if the user supplied option value agrees with optimizableQ *)
	optimizationWarningBool=Not[optimizableQ]&&MatchQ[optimizePrimitivesOption,Except[PreserveTransferOrder]];

	(* get the index-matched source-destination plate pairs. set level to infinity because we may have mixed nested lists *)
	platePairs=Cases[sourceToDestTuples,{{source:ObjectP[],_},{dest:ObjectP[],_}}:>{source,dest},Infinity];

	(* compute the optimized sequence of the primitives based on the option value *)
	optimizedPlatePairs=If[optimizationWarningBool||MatchQ[optimizePrimitivesOption,PreserveTransferOrder],
		(* return a list of original primitive index if optimization is not possible or the user want to preserve the sequence *)
		platePairs,

		(* otherwise, optimize based on option value *)
		platePairsNoDupes=DeleteDuplicates[platePairs];

		Switch[optimizePrimitivesOption,
			OptimizeThroughput,
				Module[{sourceList,destList,transferGraph,connectedGraphsList,postmanTours,reducedTours},
					(* create a list of source plates *)
					sourceList=DeleteDuplicates[platePairsNoDupes[[All,1]]];
					(* create a list of destination plates *)
					destList=DeleteDuplicates[platePairsNoDupes[[All,2]]];
					(* create a graph with plates as vertices and each transfer between plates as an edge *)
					transferGraph=Graph[UndirectedEdge[Sequence@@#]&/@platePairsNoDupes];

					(* separate graph into connected components if any *)
					connectedGraphsList=ConnectedGraphComponents[transferGraph];

					(* find the shortest path that visits all the edges for each subgraph *)
					postmanTours=Map[FindPostmanTour,connectedGraphsList];

					(* for each path, flip all pairs to (source - dest) format and delete duplicates *)
					reducedTours=Map[
						Function[tour,
							DeleteDuplicates[Map[
								(* for each edge, reverse if the left edge is not in source list *)
								If[MemberQ[sourceList,First@#],#,Reverse[#]]&,
								tour[[1]]
							]]
						],
						postmanTours
					];

					(* flatten all edges in case we have multiple subgraphs and return reordered plate pairs *)
					Flatten[reducedTours]/.UndirectedEdge[x_,y_]:>{x,y}
				],
			SourcePlateCentric,
				(* gather plate pairs by source plates *)
				Flatten[GatherBy[platePairsNoDupes,First],1],
			DestinationPlateCentric,
				(* gather plate pairs by source plates *)
				Flatten[GatherBy[platePairsNoDupes,Last],1]
		]
	];

	(* get the optimized order of the primitives *)
	optimizedPrimitiveOrder=If[MatchQ[optimizedPlatePairs,platePairs],
		(* if optimization did not occur, return original sequence *)
		Range[Length[platePairs]],
		(* otherwise, get the new sequence *)
		OrderingBy[platePairs,Position[optimizedPlatePairs,#]&]
	];

	(* rearrange our primitives based on the optimized order *)
	optimizedPrimitives=flatSpecifiedUpdatedPrimitives[[optimizedPrimitiveOrder]];

	(* rearrange all input primitives index-matching options with our optimized sequence *)
	{sortedInWellSeparationOptions,sortedResolvedCalibrations,sortedResolvedMeasurements}=Map[
		#[[optimizedPrimitiveOrder]]&,
		{expandedInWellSeparationOptions,expandedResolvedCalibrations,expandedResolvedMeasurements}
	];

	(* -------------------------------- *)
	(* ---PULL OUT DEFAULTED OPTIONS--- *)
	(* -------------------------------- *)

	(* --- pull out all the shared options from the input options --- *)
	{emailOption,uploadOption,confirmOption,parentProtocolOption,templateOption,samplesInStorageOption,samplesOutStorageOption,operatorOption,prepPrimitives,subprotocolDescriptionOption,outputOption}=
		Lookup[myOptions,{Email,Upload,Confirm,ParentProtocol,Template,SamplesInStorageCondition,SamplesOutStorageCondition,Operator,PreparatoryUnitOperations,SubprotocolDescription,Output}];

	(* --------------------------------- *)
	(* ---SamplesIn STORAGE CONDITION--- *)
	(* --------------------------------- *)

	(* collapse and re-expand SamplesIn storage condition since we may have expanded our SamplesIn *)
	(* FIXME: need to handle uncollapsable option values if the user decide to supply a non-singleton *)
	collapsedSamplesInStorageConditionOption=CollapseIndexMatchedOptions[
		ExperimentAcousticLiquidHandling,
		{SamplesInStorageCondition->samplesInStorageOption},
		Messages->False
	];

	(* expand SamplesInStorageCondition option *)
	expandedSamplesInStorageOption=ConstantArray[Lookup[collapsedSamplesInStorageConditionOption,SamplesInStorageCondition],Length[simulatedSamples]];

	(* check if the provided sampleStorageCondition is valid*)
	{validSampleStorageConditionQ,validSampleStorageTests}=If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples,expandedSamplesInStorageOption,Cache->simulatedCache,Output->{Result,Tests}],
		{ValidContainerStorageConditionQ[simulatedSamples,expandedSamplesInStorageOption,Cache->simulatedCache,Output->Result],{}}
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(* --------------------------------------- *)
	(* ---GATHER INVALID INPUTS AND OPTIONS--- *)
	(* --------------------------------------- *)

	(* check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedSourceInvalidInputs,deprecatedInvalidInputs,sourceWithDeprecatedModels,sourceWithInvalidStates,
		containerlessSamples,sourceWithInvalidContainers,discardedDestContainers,deprecatedDestContainerModels,
		incompatibleDestContainerModels,failedLabwareDestContainerModels,occupiedDestWithUnsafeVolume,
		invalidPrimitivesString,insufficientSamplesNoDupes,highGlycerolSamplesNoDupes,multipleDestContainerTypes,
		tooLargeAliquotVolSamples,multipleSourceContainerTypes
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		notEmptyAliquotContainersOptionName,nameInvalidOptions,inWellSeparationConflictOption,inWellSeparationNotAllowedOption,
		calibrationMeasurementMismatchOptions,fluidTypeCalibrationErrorOption,fluidAnalysisMeasurementErrorOption,
		invalidStorageConditionOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->updatedSimulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* ---------------------- *)
	(* ---GATHER ALL TESTS--- *)
	(* ---------------------- *)

	(* gather all the tests together *)
	allTests=Cases[Flatten[{
		samplePrepTests,aliquotTests,nonEmptyAliquotContainerTests,discardedSourceSampleTest,deprecatedTest,nonLiquidSourceTest,
		containerlessSampleTest,multipleSourceContainerModelTest,containerWithNonInputSampleTest,multipleDestContainerModelTest,
		validNameTest,discardedDestinationContainerTest,deprecatedDestinationContainerModelTest,invalidDestinationContainerTest,
		invalidLabwareTest,unsafeDestVolumeTest,precisionTests,outOfRangeAmountTest,insufficientSourceSampleVolumeTest,
		samePlateTransferTest,invalidDestinationWellTest,overFilledDestinationVolumeTest,invalidInWellSeparationKeyTest,
		inWellSeparationKeyOptionTest,invalidInWellSeparationOptionTest,samplesWithTooHighGlycerolTest,
		calibrationMeasurementMismatchTest,invalidFluidTypeCalibrationTest,invalidFluidAnalysisMeasurementTest,
		fluidTypeCalibrationWarningTest,fluidAnalysisMeasurementWarningTest,validSampleStorageTests,tooLargeAliquotVolumeTest
	}],_EmeraldTest];

	(* resolve Email option *)
	resolvedEmailOption=If[Not[MatchQ[emailOption,Automatic]],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot=First[splitPrepOptions[resolvedSamplePrepOptions,PrepOptionSets->{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew}]];

	(* ----------------------------- *)
	(* ---PRIMITIVES PREPARATIONS--- *)
	(* ----------------------------- *)
	(* we need to replace all the simulated samples/containers in the primitives back to their original forms so that it makes sense for the user *)

	(* create replace rules for objects that were prepared via sample preparation *)
	samplePrepReplaceRules=Rule@@@Cases[updatedSimulatedCache,KeyValuePattern[{Simulated->True,SimulationParent->parent_,Object->object_,Type->Object[Sample]}]:>{object,parent}];

	(* combine all replace rules *)
	(* Note: destPlateReplaceRules is where we assigned unique ID to untagged Model[Container]. we will use this info to generate resources *)
	allPrimitiveReplaceRules=Flatten[{samplePrepReplaceRules,Reverse[destPlateReplaceRules,{2}]}];

	(* change all prepared samples and simulated destination containers in the primitives back to their original forms *)
	primitivesToReturn=optimizedPrimitives/.allPrimitiveReplaceRules;

	(* ------------------------ *)
	(* ---FINAL PREPARATIONS--- *)
	(* ------------------------ *)

	(* all resolved options *)
	resolvedOptions=ReplaceRule[
		myOptions,
		Join[
			resolveSamplePrepOptionsWithoutAliquot,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				Instrument->specifiedInstrument,
				OptimizePrimitives->optimizePrimitivesOption,
				ResolvedManipulations->primitivesToReturn,
				FluidAnalysisMeasurement->sortedResolvedMeasurements,
				FluidTypeCalibration->sortedResolvedCalibrations,
				InWellSeparation->sortedInWellSeparationOptions,
				(* expandedSamplesIn contains all prepared sample and is index-matched to simulatedSamples *)
				SamplesIn->Flatten[expandedSamplesIn],
				(* requiredAliquotAmounts is index-matched to expandedSamplesIn. we will need this when making resources *)
				SamplesVolume->requiredAliquotAmounts,
				SamplesInStorageCondition->expandedSamplesInStorageOption,
				SamplesOutStorageCondition->samplesOutStorageOption,
				Cache->cache,
				FastTrack->fastTrack,
				Template->templateOption,
				ParentProtocol->parentProtocolOption,
				Operator->operatorOption,
				Confirm->confirmOption,
				Name->nameOption,
				Upload->uploadOption,
				Output->outputOption,
				Email->resolvedEmailOption,
				SubprotocolDescription->subprotocolDescriptionOption,
				PreparatoryUnitOperations->prepPrimitives
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}
];


(* ::Subsubsection::Closed:: *)
(* ExperimentAcousticLiquidHandling Resource Packets *)

DefineOptions[experimentAcousticLiquidHandlingResourcePackets,
	Options:>{CacheOption,HelperOutputOption}
];


experimentAcousticLiquidHandlingResourcePackets[myPrimitives:{SampleManipulationP..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,
		inheritedCache,samplesInResources,instrument,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,
		finalizedPacket,allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,samplesWithPreparedSamples,samplesInStorage,
		aliquotQ,aliquotAmounts,requiredAmounts,sampleRequiredAmounts,defineNameReplaceRules,resolvedPrimitives,primitiveAmounts,
		suppliedDestinations,destinationSamples,destinationSamplePackets,suppliedDestinationLocations,destinationContainerSpecs,
		destinationResources,measureVolumeOption,imageSampleOption,fluidTypeCalibOption,inWellSeparationOption,requiredObjects,
		transferRate,transferTime,numberOfBatches,softwareSetupTime,numberOfPlateChanges,plateChangeTime,runTime,containerObjects,
		primtivesToReturn,sourceToDestTuples,platePairs,resolvedOptionsWithListedSamplesOutStorage
	},
	(* expand the resolved options if they weren't expanded already *)
	(* FIXME: Options are expanded properly but shows 'input not expanded' warning because we have primitives as input instead of samples. *)
	{expandedInputs,expandedResolvedOptions}=Quiet[
		ExpandIndexMatchedInputs[ExperimentAcousticLiquidHandling,{myPrimitives},myResolvedOptions],
		Warning::UnableToExpandInputs
	];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentAcousticLiquidHandling,
		RemoveHiddenOptions[ExperimentAcousticLiquidHandling,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[ops],Cache];

	(* get all the option values we need *)
	{
		samplesWithPreparedSamples,requiredAmounts,samplesInStorage,aliquotQ,aliquotAmounts,resolvedPrimitives,
		instrument,measureVolumeOption,imageSampleOption,fluidTypeCalibOption,inWellSeparationOption
	}=
		Lookup[expandedResolvedOptions,{
			SamplesIn,SamplesVolume,SamplesInStorageCondition,Aliquot,AliquotAmount,ResolvedManipulations,Instrument,
			MeasureVolume,ImageSample,FluidTypeCalibration,InWellSeparation
		}];

	(* get the user-supplied destinations and Amount from ResolvedManipulations that we passed down from the resolver *)
	{suppliedDestinations,primitiveAmounts}=Transpose[Map[
		{
			First@First@#[Destination],
			First@First@#[Amount]
		}&,
		resolvedPrimitives
	]];

	(* get the destination samples without duplicates *)
	destinationSamples=DeleteDuplicates[Cases[suppliedDestinations,ObjectP[Object[Sample]]]];

	(* --- Make our one big Download call --- *)
	(* Get the information we need via Download *)
	{
		(* get container information to populate ContainersIn Field *)
		containerObjects,
		(* get the volume of destination samples *)
		destinationSamplePackets
	}=Download[
		{
			samplesWithPreparedSamples,
			destinationSamples
		},
		{
			{Container[Object]},
			{Packet[Volume]}
		},
		Cache->inheritedCache,
		Date->Now
	];

	(* ------------------------ *)
	(* ---GENERATE RESOURCES--- *)
	(* ------------------------ *)

	(* ---1. generate resources for the SamplesIn--- *)

	(* get the amount required of each sample *)
	(* Note: if Aliquot -> False, we will use the required amount calculated in the option resolver *)
	sampleRequiredAmounts=MapThread[
		Function[{aliquotBool,aliquotAmount,requiredAmount},
			If[aliquotBool,
				aliquotAmount,
				requiredAmount
			]
		],
		{aliquotQ,aliquotAmounts,requiredAmounts}
	];

	(* create resource blobs for our SamplesIn *)
	samplesInResources=MapThread[
		Function[{sample,volume},
			Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume]
		],
		{samplesWithPreparedSamples,sampleRequiredAmounts}
	];

	(* ---2. generate resources for destination objects--- *)

	(* get the user-supplied destination locations without sample objects *)
	suppliedDestinationLocations=Complement[suppliedDestinations,destinationSamples];

	(* get only the destination container specifier *)
	destinationContainerSpecs=DeleteDuplicates[suppliedDestinationLocations[[All,1]]];

	(* create resource blobs for the destination containers *)
	(* make resources for destination containers based on the specified prefix of the model *)
	destinationResources=Map[
		Switch[#,
			(* if specified as a container object, use that directly *)
			ObjectP[Object[Container]],
				Resource[
					Name->ToString[Unique[]],
					Sample->#
				],
			(*if specified as a sample object, also lookup its volume *)
			PacketP[Object[Sample]],
				Resource[
					Name->ToString[Unique[]],
					Sample->Lookup[#,Object],
					Amount->Lookup[#,Volume]
				],
			(* if specified as {Integer, Model}, use only the object (last position) *)
			{_,ObjectP[]},
				Resource[
					Name->ToString[Unique[]],
					Sample->Last[#]
				],
			_,
				Nothing
		]&,
		Join[destinationContainerSpecs,Flatten[destinationSamplePackets]]
	];

	(* create tuples to populate our protocol's RequiredObjects Field in the form {ObjectSpecificationP, Link[Resource]} *)
	requiredObjects=MapThread[
		{
			#1,
			Link[#2]
		}&,
		{Join[destinationContainerSpecs,destinationSamples],destinationResources}
	];
	(* --3. generate instrument resources -- *)

	(* calculate instrument time based on the manipulations to be performed *)
	(* Note: create a lookup table since throughput varies across different calibrations and plate types *)
	transferRate=(10 Microliter)/(1 Minute);
	transferTime=(Total[primitiveAmounts]/transferRate);

	(* get the software setup time (multiple by number of batches which is 1 for now until we support batch looping) *)
	numberOfBatches=1;
	softwareSetupTime=10 Minute*numberOfBatches;

	(* get the time needed for plate changes (includes scanning object/position and placement) *)
	(* create tuples in the from {sourceLocation, destinationLocation} *)
	sourceToDestTuples=Map[
		{
			First@First@#[ResolvedSourceLocation],
			First@First@#[ResolvedDestinationLocation]
		}&,
		resolvedPrimitives
	];

	(* get the index-matched source-destination plate pairs *)
	platePairs=Cases[sourceToDestTuples,{{source_,_},{dest_,_}}:>{source,dest}];

	(* get the number of plate changes from our primitives *)
	(* start with 4 since we first put 2 plates in and at the end takes 2 plates out *)
	numberOfPlateChanges=4;
	(* use Fold to track how many times we need to change the plates based on our optimized sequence *)
	Fold[
		Module[{source,dest},
			(* get the previous source and destination plates *)
			source=#1[[-1]][[1]];
			dest=#1[[-1]][[2]];
			(* compare as we loop over the entire sequence *)
			Switch[#2,
				(* if both are similar to previous ones, don't add count *)
				{source,dest},Nothing,
				(* if either one is the same as previous, we have to change one plate *)
				{source,_},numberOfPlateChanges=(numberOfPlateChanges+1),
				{_,dest},numberOfPlateChanges=(numberOfPlateChanges+1),
				(* both are different, we need to change 2 plates *)
				_,numberOfPlateChanges=(numberOfPlateChanges+2)
			];
			(* add new pairs to the list *)
			Append[#1,#2]
		]&,
		{First@platePairs},
		Rest@platePairs
	];

	(* calculate time needed for all plate changes *)
	(* each change involves taking a plate our and replace with a new one. this is roughly 1 minute including barcode scanning *)
	plateChangeTime=1 Minute*numberOfPlateChanges;

	(* calculate to time for the instrument *)
	instrumentTime=Total[{transferTime,softwareSetupTime,plateChangeTime}];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->instrumentTime,
		Name->ToString[Unique[]]
	];

	(* get the total run time by combining the sample run time and plate change time *)
	runTime=(transferTime+plateChangeTime);

	(* ---replace prepared samples in resolved primitives with user-defined string name if any--- *)
	(* create replace rules for objects that were prepared via preparatory primitives *)
	defineNameReplaceRules=Rule@@@Cases[inheritedCache,KeyValuePattern[{Object->object_,DefineName->name_}]:>{object,name}];

	(* replace prepared objects with their original string names *)
	primtivesToReturn=resolvedPrimitives/.defineNameReplaceRules;

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Object->CreateID[Object[Protocol,AcousticLiquidHandling]],
		Type->Object[Protocol,AcousticLiquidHandling],
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@Flatten[DeleteDuplicates@containerObjects],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		Replace[Checkpoints]->{
			{"Preparing Samples",45 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Minute]]},
			{"Picking Resources",30 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->10 Minute]]},
			{"Manipulation",instrumentTime,"The manipulation of samples by an acoustic liquid handler is performed and data is collected.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->(runTime+30*Minute)]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, or sample imaging post experiment is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1*Hour]]},
			{"Returning Materials",20 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->10*Minute]]}
		},
		RunTime->runTime,
		(* shared options/fields *)
		MeasureVolume->measureVolumeOption,
		ImageSample->imageSampleOption,
		Replace[SamplesInStorage]->samplesInStorage,
		(* acoustic liquid handling options/fields *)
		LiquidHandler->Link[instrumentResource],
		Replace[Manipulations]->myPrimitives,
		Replace[ResolvedManipulations]->primtivesToReturn,
		Replace[RequiredObjects]->requiredObjects,
		Replace[FluidTypeCalibration]->fluidTypeCalibOption,
		Replace[InWellSeparation]->inWellSeparationOption
	|>;

	(* make sure SamplesOutStorageCondition is in a list before passing the options to populateSamplePrepFields *)
	(* Note: normally ExpandIndexedMatchInput would take care of this but our input is not sample so we do this manually here *)
	resolvedOptionsWithListedSamplesOutStorage=ReplaceRule[expandedResolvedOptions,SamplesOutStorageCondition->ToList[Lookup[expandedResolvedOptions,SamplesOutStorageCondition]]];

	(* generate a packet with the shared fields *)
	sharedFieldPacket=Experiment`Private`populateSamplePrepFields[Lookup[resolvedOptionsWithListedSamplesOutStorage,SamplesIn],resolvedOptionsWithListedSamplesOutStorage,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];