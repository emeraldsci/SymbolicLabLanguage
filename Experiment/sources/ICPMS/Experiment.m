(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentICPMS*)

(* TODO a few option conflicts to add: no 2 or more kinds of gas, no standard/sample volume > 12 ml *)
(* ::Subsubsection:: *)
(*ExperimentICPMS Options*)
DefineOptions[ExperimentICPMS,
	Options:>{
		{
			OptionName->Instrument,
			Default->Model[Instrument,MassSpectrometer, "iCAP RQ ICP-MS"],
			Description->"Instrument which is used to atomize, ionize and analyze the elemental composition of the input analyte.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,MassSpectrometer],Object[Instrument,MassSpectrometer]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments", "Mass Spectrometer", "Inductively-Coupled Plasma Mass Spectrometry (ICP-MS)"
					}
				}
			],
			Category->"General"
		},
		(*Master switch for standard type*)
		{
			OptionName->StandardType,
			Default->Automatic,
			ResolutionDescription -> "Automatically set to External if any of ExternalStandard, ExternalStandardElement or StandardDilutionCurve is specified; otherwise, automatically set to StandardAddition if any of AdditionStandard, StandardAdditionElements, StandardAdditionCurve, StandardSpiledSample is specified; otherwise if QuantifyConcentration for any Elements is set to True, set to External. If all above doesn't hold, set to None.",
			Description->"Select whether external standard, standard addition or no standard will be used for quantification. StandardAddition are known concentrations of analytes at a given mass that are mixed into the sample prior to introduction into the instrument. External standards are secondary samples of known analytes and concentrations that are injected and measured separately with the instrument.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[External,StandardAddition,None]
			],
			Category->"Standards"
		},
		IndexMatching[

			(*Master switch for digestion*)
			{
				OptionName->Digestion,
				Default->Automatic,
				Description->"Indicates if microwave digestion is performed on the samples in order to fully dissolve the elements into the liquid matrix before injecting into the mass spectrometer.",
				ResolutionDescription->"Is automatically set to False for acidic aqueous samples and liquid organic non-biological samples, otherwise set to True.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Digestion"
			},
			{
				OptionName -> SampleAmount,
				Default -> 3000 Microliter,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[2000 Microliter, 10000 Microliter],
					Units -> Microliter
				],
				Description -> "The amount of sample that is loaded into the ICPMS instrument for measurement, after all sample preparation procedures but before adding any InternalStandard and/or AdditionStandard.",
				ResolutionDescription -> "The default sample amount is set to 3000 Microliter.",
				Category -> "Digestion"
			},
			{
				OptionName -> SampleLabel,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True,
				Description -> "A user defined word or phrase used to identify the Sample for use in downstream unit operations.",
				Category -> "General"
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Null,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being incubated, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},

			IndexMatchingInput->"experiment samples"
		],
		{
			OptionName -> InternalStandard,
			Default -> Automatic,
			Description -> "Standard sample that is added to all samples, including standards, blanks and user-provided samples. InternalStandard contains elements which do not exist in any other samples, and which its detector response is measured along with other Elements to account for matrix effects and instrument drift.",
			ResolutionDescription -> "If there exists any Element with InternalStandardElement set to True, automatically choose a standard that contains these elements but do not contain any other elements in Elements option. If no such element exists, will try to find one standard that do not contain any elements need quantification, and automatically add one element in Elements option as InternalStandardElement.",
			AllowNull -> True,
			Category -> "Standard",
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic, Null]],
				Widget[Type -> Object, Pattern:> ObjectP[{Model[Sample], Object[Sample]}]]
			]
		},
		{
			OptionName -> InternalStandardMixRatio,
			Default -> Automatic,
			Description -> "Volume ratio of InternalStandard to each sample.",
			ResolutionDescription -> "Automatically set to 0.111 if there's any InternalStandard, otherwise set to 0.",
			AllowNull -> False,
			Category -> "Standard",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			]
		},
		(*Blank and rinse options*)
		{
			OptionName->Blank,
			Default->Model[Sample, StockSolution, "id:R8e1PjeqG7WX"] (* "5% Nitric Acid, trace metal grade" *),
			Description->"Sample containing no analyte used to measure the background levels of any ions in the matrix.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials", "Inductively-Coupled Plasma Mass Spectrometry", "Standards and Blanks"
					}
				}
			],
			Category->"Blank"
		},
		(*Master switch for rinsing options*)
		{
			OptionName->Rinse,
			Default->True,
			Description->"Determine whether rinse of inlet line is performed after a set number of samples.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Flushing"
		},
		{
			OptionName->RinseSolution,
			Default->Automatic,
			Description->"Solution for the autosampler to draw between each run to flush the system.",
			ResolutionDescription->"Is automatically set to match with Blank if Rinse is set to True.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials", "Inductively-Coupled Plasma Mass Spectrometry", "Standards and Blanks"
					}
				}
			],
			Category->"Flushing"
		},
		{
			OptionName->RinseTime,
			Default->Automatic,
			Description->"Duration of time for each rinse.",
			ResolutionDescription->"Is automatically set to 240 seconds if Rinse is set to True.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Second, 300 Second],
				Units->Second
			],
			Category->"Flushing"
		},
		(*other general options*)
		(*IndexMatching options, matching to the input samples*)
		{
			OptionName->InjectionDuration,
			Default->240 Second,
			Description->"Duration of the input sample being continuously injected into the instrument for each measurement.",
			ResolutionDescription->"Automatically set to 240 seconds.",
			AllowNull->False,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Second, 300 Second],
				Units->{Second,{Second,Minute}}
			],
			Category->"Sample Loading"
		},
		{
			OptionName->ConeDiameter,
			Default-> 3.5 Millimeter,
			Description->"Indicates diameter of the opening of vacuum interface cone. High cone diameter will allow more plasma into the vacuum chamber for analysis. For higher concentration analyte low cone diameter should be used to block more interferences to minimize noise, while for lower concentration analyte high cone diameter should be used to allow more plasma in to maximize signal.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[(*2.8 Millimeter,*) 3.5 Millimeter(*, 4.5 Millimeter*)]
			],
			Category->"Analysis"
		},
		{
			OptionName -> IsotopeAbundanceThreshold,
			Default -> 20 Percent,
			Description -> "Select threshold so that isotopes whose abundance is above this value will be selected for detection besides the most abundant one. This option is only valid when Elements -> Automatic or a list of elements, will be ignored when list of isotopes is provided as entry for Elements option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 50 Percent],
				Units -> Percent
			],
			Category -> "Analysis"
		},
		{
			OptionName -> QuantifyElements,
			Default -> True,
			Description -> "Select if concentration of elements will be quantified in addition to each isotopes.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Analysis"
		},

		IndexMatching[
			IndexMatchingParent->Elements,
			{
				OptionName->Elements,
				Default->Automatic,
				Description->"Nuclei or element to be measured by tuning the quadrupole to select the mass of the element that matches the atomic weight. When elements are selected, only the most abundant isotope and isotopes above IsotopeAbundanceThreshold (default 20%) will be quantified. If Elements is set to Sweep then a full spectrum will be acquired. Should also include elements from InternalStandard.",
				ResolutionDescription->"Automatically set to elements matching the atomic metals that present in the molecules of the sample composition and InternalStandard composition plus Sweep.  If there are no metallic elements in the Composition and this option is unspecified, automatically set to Sweep.",
				AllowNull->False,
				Widget->Alternatives[
					"Elements (Most Abundant Isotope)"->Widget[
						Type->Enumeration,
						Pattern:>ICPMSElementP
					],
					"Isotopes"->Widget[
						Type->Enumeration,
						Pattern:>ICPMSNucleusP
					]
				],
				Category->"Analysis"
			},
			{
				OptionName->PlasmaPower,
				Default->Automatic,
				Description->"Electric power of the coil generating the Ar-ion plasma flowing through the torch.",
				ResolutionDescription->"Is automatically set to Low for light elements and Normal for other elements.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Low, Normal]
				],
				Category->"Ionization"
			},
			{
				OptionName->CollisionCellPressurization,
				Default->Automatic,
				ResolutionDescription -> "Is automatically set to True if CollisionCellGas is set to non-Null, or if CollisionCellGasFlowRate is set to non-zero.",
				Description->"Indicate if the collision cell should be pressurized. If the collision cell is pressurized, gas inside will collide with the analyte ions as the ion pass through it. Since polyatomic ions are larger than monoatomic ions they are more likely to collide with the gas, and therefore been blocked from entry of the quadrupole. See Figure 3.2 for more details.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->CollisionCellGas,
				Default->Automatic,
				Description->"Indicate which gas type collision cell should be pressurized.",
				ResolutionDescription->"Is automatically set to Helium if CollisionCellPressurization is set to True.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>ICPMSCollisionCellGasP
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->CollisionCellGasFlowRate,
				Default->Automatic,
				Description->"Indicates the flow rate of gas through collision cell. Refer to Figure 3.2.",
				ResolutionDescription->"Is automatically set to 4.5 ml/min if CollisionCellPressurization is set to True.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[(0*Milliliter)/Minute, (10*Milliliter)/Minute],
					Units->CompoundUnit[{1,{Milliliter,{Microliter,Milliliter,Liter}}},{-1, {Minute,{Second,Minute,Hour}}}]
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->CollisionCellBias,
				Default->Automatic,
				Description->"Indicates if bias voltage for collision cell is turned on. Refer to Figure 3.2.",
				ResolutionDescription->"Is automatically set to True if CollisionCellPressurization was set to True.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Data Acquisition"
			},

			{
				OptionName->DwellTime,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to 1 ms for Sweep and 10 ms for any other Elements.",
				Description->"Time spend to measure a single analyte of a single sample.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1 Millisecond, 5000 Millisecond],
					Units->{Millisecond, {Millisecond, Second}}
				],
				Category->"Analysis"
			},
			{
				OptionName->NumberOfReads,
				Default->1,
				Description->"Number of redundant readings by the instrument on each side the target mass, see Figure 3.3. This option is not valid for Sweep.",
				AllowNull->False,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,13,1]
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->ReadSpacing,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to 0.1 Gram/Mole for all Elements except Sweep, and set to 0.2 Gram/Mole for Sweep.",
				Description->"Distance of mass units between adjacent redundant readings. For Sweep, the minimum allowed value is 0.05 amu. See Figure 3.3.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.01 Gram / Mole,1 Gram / Mole],
					Units -> Gram / Mole
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->Bandpass,
				Default->Normal,
				Description->"Select the bandwidth of allowed m/z ratio for each reading by the quadrupole. Normal is 0.75 amu at 10% peak height, and High is 0.3 amu at 10% peak height. Set Resolution to High can better differentiate some isotopes, with a price of reduced signal level.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Normal, High]
				],
				Category->"Data Acquisition"
			},
			{
				OptionName->InternalStandardElement,
				Default->Automatic,
				Description->"Indicates if the particular element comes from InternalStandard, therefore should be measured but not quantified.",
				ResolutionDescription -> "Automatically set to False if InternalStandard is set to Null, otherwise will automatically read composition of InternalStandard and set to True for any elements that exist in the InternalStandard.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Analysis"
			},
			{
				OptionName->QuantifyConcentration,
				Default->Automatic,
				Description->"Indicates if concentrations of the particular element in all input samples are quantified.",
				ResolutionDescription->"Is automatically set to False when InternalStandardElement set to True, and automatically set to True when StandardType set to anything other than None, and such element can be found in at least one standard.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Analysis"
			}
		],
		{
			OptionName->MinMass,
			Default->Automatic,
			Description->"When Elements includes Sweep, sets the lower limit of the m/z value for the quadrupole mass scanning range.",
			ResolutionDescription->"Automatically set to 4.6 g/mol if Elements is set to Sweep.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1.0 Gram/Mole, 300.0 Gram/Mole],
				Units->Gram/Mole
			],
			Category->"Analysis"
		},
		{
			OptionName->MaxMass,
			Default->Automatic,
			Description->"When Elements is set to Sweep, sets the upper limit of the m/z value for the quadrupole mass scanning range.",
			ResolutionDescription->"Automatically set to 245 g/mol if Elements is set to Sweep.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1.0 Gram/Mole, 300.0 Gram/Mole],
				Units->Gram/Mole
			],
			Category->"Analysis"
		},
		(*IndexMatching to Standard, Valid only for StandardType->External*)
		IndexMatching[
			IndexMatchingParent->ExternalStandard,
			{
				OptionName->ExternalStandard,
				Default->Automatic,
				Description->"Calibration standard for quantification of analyte elements or nuclei.",
				ResolutionDescription->"Automatically selects one or more standards that contains all values in the Analyte option.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials", "Inductively-Coupled Plasma Mass Spectrometry", "Standards and Blanks"
					}
				}
				],
				Category->"Standard"
			},
			{
				OptionName -> StandardDilutionCurve,
				Default -> Automatic,
				Description -> "The collection of dilutions that are performed on the ExternalStandard prior to injecting the standard samples into the instrument.",
				AllowNull -> True,
				ResolutionDescription->"Automatically set to a list of 3 dilution factors such that highest concentration of the ExternalStandardElement becomes 1, 3 and 10 mg/ml. If the maximum concentration is below 10 mg/ml, set the dilution factor to be 1, 3 and 10 with 10 ml total volume after dilution.",
				Category -> "Standard",
				Widget-> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,Null]],
					"Fixed Dilution Volume"->Adder[
						{
							"Standard Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}]
						}
					],
					"Fixed Dilution Factor"->Adder[
						{
							"Standard Volume"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Microliter],Units->{1,{Microliter,{Liter,Milliliter,Microliter}}}],
							"Dilution Factors"->Widget[Type->Number,Pattern:>GreaterEqualP[1]]
						}
					]
				]
			},
			{
				OptionName->ExternalStandardElements,
				Default->Automatic,
				Description->"Nuclei or element present in the standard solution with known concentrations before dilution.",
				ResolutionDescription->"Automatically set to all elements present in the input standard's Composition field. If there are no elements in the Composition and this option is unspecified, an error is thrown.",
				AllowNull->True,
				Widget->Alternatives[
					(*Select element present in standard, concentration will be read automatically, assuming natural abundance*)
					"Manually select all elements and automatically reads concentration"->Widget[
						Type->MultiSelect,
						Pattern:>DuplicateFreeListableP[ICPMSElementP]
					],
					(*Select element or isotopes present in standard, and manually enter all concentrations*)
					"Manually select all elements and enter concentration"->Adder[
						Alternatives[
							"Enter mass concentration" -> {
								"Elements"->Widget[Type->Enumeration,Pattern:>ICPMSElementP],
								" Mass Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Milligram / Liter],Units->CompoundUnit[{1,{Milligram,{Nanogram,Microgram,Milligram,Gram}}},{-1,{Liter,{Microliter,Milliliter,Liter}}}]]
							},
							"Enter molar concentration" -> {
								"Elements"->Widget[Type->Enumeration,Pattern:>ICPMSElementP],
								"Molar Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micromolar],Units->{1,{Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}]
							}
						]
					],
					"Manually select all isotopes and enter concentration"->Adder[
						Alternatives[
							"Enter mass concentration" -> {
								"Isotope"->Widget[Type->Enumeration,Pattern:>ICPMSNucleusP],
								"Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Milligram / Liter],Units->CompoundUnit[{1,{Milligram,{Nanogram,Microgram,Milligram,Gram}}},{-1,{Liter,{Microliter,Milliliter,Liter}}}]]
							},
							"Enter molar concentration" -> {
								"Isotope"->Widget[Type->Enumeration,Pattern:>ICPMSNucleusP],
								"Molar Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micromolar],Units->{1,{Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}]
							}
						]
					],
					"No Elements In Standard" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[{}]
					]
				],
				Category->"Standards"
			}
		],
		(*IndexMatching to Input Samples, Valid only for StandardType->StandardAddition*)
		IndexMatching[
			{
				OptionName -> StandardAddedSample,
				Default -> False,
				Description -> "Indicate if the input sample has already been spiked with standard sample for concentration measurement via standard addition.",
				AllowNull -> False,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> AdditionStandard,
				Default -> Automatic,
				Description -> "Standard samples being added to the sample for standard addition.",
				ResolutionDescription -> "Automatically selects one standard that contains all Elements analytes in the input sample; if that's impossible, selects one standard that contains the first Elements in the input sample.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials", "Inductively-Coupled Plasma Mass Spectrometry", "Standards and Blanks"
						}
					}
				]
			},
			{
				OptionName -> StandardAdditionCurve,
				Default -> Automatic,
				Description -> "The collection of StandardAddition performed on the input sample prior to injecting the standard samples into the instrument. If StandardAddedSample is set to True for any sample, these samples will no longer be mixed with AdditionStandard again, and This option should be set to Null.",
				AllowNull -> True,
				ResolutionDescription->"Automatically set to a list of 3 volume ratios such that concentration of the first AdditionStandard's Analyte becomes 1, 3 and 10 mg/ml. If the standard concentration is below 20 mg/ml, will add to consist 20%, 40% and 100% of SampleAmount. If StandardAddedSample set to True, this option automatically set to Null.",
				Category -> "Standard",
				Widget-> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic,Null]],
					"Fixed ratio"->Adder[
						{
							"Standard : Digested Sample Volume Ratio"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
						}
					],
					"Fixed volume"->Adder[
						{
							"Standard Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Milliliter, 15 Milliliter],Units -> {Milliliter,{Microliter, Milliliter}}]
						}
					]
				]
			},
			{
				OptionName -> StandardAdditionElements,
				Default -> Automatic,
				Description -> "Nuclei or element present in the standard solution with known concentrations before dilution. For samples with StandardAddedSample set to True, concentration in this option instead refers to the value after dilution.",
				ResolutionDescription -> "Automatically set to all elements present in the input standard's Composition field if StandardAddedSample is set to False, or to all elements from monoatomic components in the input sample's Composition field if StandardAddedSample is set to True.  If there are no elements in the Composition and this option is unspecified, an error is thrown.",
				AllowNull->True,
				Category -> "Standard",
				Widget->Alternatives[
					(*Select element present in standard, concentration will be read automatically, assuming natural abundance*)
					"Manually select all elements and automatically reads concentration"->Widget[
						Type->MultiSelect,
						Pattern:>DuplicateFreeListableP[ICPMSElementP]
					],
					(*Select element or isotopes present in standard, and manually enter all concentrations*)
					"Manually select all elements and enter concentration"->Adder[
						Alternatives[
							"Enter mass concentration" -> {
								"Elements"->Widget[Type->Enumeration,Pattern:>ICPMSElementP],
								"Mass Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Milligram / Liter],Units->CompoundUnit[{1,{Milligram,{Nanogram,Microgram,Milligram,Gram}}},{-1,{Liter,{Microliter,Milliliter,Liter}}}]]
							},
							"Enter molar concentration" -> {
								"Elements"->Widget[Type->Enumeration,Pattern:>ICPMSElementP],
								"Molar Concentration"->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Micromolar],Units->{1,{Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}}}]
							}
						]
					]
				]
			},
			IndexMatchingInput->"experiment samples"
		],

		{
			OptionName -> ImageSample,
			Default -> True,
			Description -> "Indicates if any samples that are modified in the course of the experiment are imaged after running the experiment.",
			AllowNull -> False,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},

		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		AnalyticalNumberOfReplicatesOption,
		SimulationOption,
		ModifyOptions[MicrowaveDigestionOptions, {AllowNull -> True}]
	}


];

(* ::Subsubsection:: *)
(*ExperimentICPMS: Errors and Warnings*)


Error::ExternalStandardPresence="Option ExternalStandard is set to a non-Null list `1` while StandardType is not set to External. Consider changing StandardType or set ExternalStandard to empty set.";
Error::NonLiquidNonSolidSample="Physical state of the input samples `1` is neither liquid nor solid, thus cannot be measured via ICPMS. Please consider switch samples, perform sample preparation or correct its physical state information.";
Error::CollisionCellBiasOnWithoutGas="The following isotopes `1` has the CollisionCellBias set to True with CollisionCellPressurization set to False. Please either set CollisionCellPressurization to True or set CollisionCellBias to False.";
Error::CollisionCellGasConflict="The following isotopes `1` either has the CollisionCellPressurization set to True with CollisionCellGas set to Null, or CollisionCellPressurization set to False while CollisionCellGas set to nonNull. Please change options to resolve the conflict.";
Error::CannotQuantifyInternalStandardElement="The following isotopes `1` has both InternalStandardElement and QuantifyConcentration set to True. Concentration of internal standard elements should not be quantified. Please change either options to resolve the conflict.";
Error::ExternalStandardAbsence="The option ExternalStandard is set to {Null} while StandardType is set or resolved to External. Please change either options to resolve the conflict.";
Error::InvalidRinseOptions="The option Rinse is set to True, but one or more of the following options: {RinseTime, RinseSolution} is set to Null. Please change these options to non-Null to resolve the conflicts.";
Error::InternalStandardInvalidVolume="The internal standard was set or resolved to `1` while the InternalStandardMixRatio was set to 0. Please change either option to resolve the conflict.";
Error::MinMaxMassInversion="The specified MinMass (`1`) is greater than or equal to MaxMass (`2`). Please change the two options to resolve the conflict.";
Error::MissingMassRange="The options `1` are set to Null while sweep scan is enabled. Please either set the `1` options to non-Null or manually modify the Elements option to disable Sweep scan";
Error::CollisionCellGasFlowRateConflict="The following isotopes `1` either has the CollisionCellGasFlowRate set to non-zero with CollisionCellGas set to Null, or CollisionCellGasFlowRate set to 0 while CollisionCellGas set to nonNull. Please change options to resolve the conflict.";
Error::InvalidExternalStandardElements = "The option ExternalStandardElements cannot be specified as `2` while ExternalStandard specified as `1`. Please either manually specify an ExternalStandard, or set the ExternalStandardElement option to Automatic.";
Error::InvalidStandardAdditionElements = "The following input samples `1` has AdditionStandard set to Automatic or Null while StandardAdditionElements specified as `2`. Please either manully specify an AdditionStandard for each of `1`, or set the AdditionStandardElements option to Automatic.";
Error::DigestionNeededForNonLiquid = "The following non-liquid sample `1` must be digested before submitting to ICPMS instrument. Please set the Digestion Option to True, or if you believe the sample is liquid, please recheck the State field of the object.";
Error::AttemptToQuantifySweep="QuantifyConcentration for Sweep is set to True, which is not possible. No quantification will be performed on Sweep scan.";
Error::InvalidRinse="The option Rinse is set to False, but one or more of the following options: {RinseTime, RinseSolution} is set to non-Null. Experiment will continue with no Rinse.";
Error::InvalidMassRange="The options `1` are set to non-Null while Sweep scam is disabled. Experiment will continue without Sweep scan.";
Error::NoAvailableInternalStandard="No internal standard can be found to contain any of the listed elements/isotopes `1` that had InternalStandardElement set to True. Please change the InternalStandardElement settings or manually enter a sample as InternalStandard.";
Error::UnableToFindInternalStandard="No internal standard can be found from auto search. Please try manually specify one sample as InternalStandard, or remove it completely by setting InternalStadnard to Null.";
Error::UnsupportedElements="The following elements or isotopes `1` are not supported by the instrument specified. Please either remove these elements or select a different instrument. If the Element option was set to Automatic, please try manually specifying that option.";
Error::NoStandardNecessary="No external standard or standard addition can be resolved since no element requires quantifying concentration.";
Error::NoAbundantIsotopeForQuantification="No isotope above 0.1% abundance is configured to be detected for the following elements `1` that needs to be quantified. Please consider modifying QuantifyElements option to not quantify these elements, or modifying Elements option to manually specify more abundant isotope.";
Error::StandardVolumeOverflow="The StandardDilutionCuves option `1` for the following standards `2` results in more than 15 ml total volume, which exceeds the capability of containers compatible for our instrument. Please consider changing the StandardDilutionCurve option to ensure the total volume of each diluted standards are within 15 ml.";
Error::SampleVolumeOverflow="The resulted total volume of the following samples `1` exceeds 15 ml, which is the capability of containers compatible for our instrument. If StandardType was set to StandardAddition, please consider chaning the StandardAdditionCurve option to reduce the total volume, or switch to External.";
Error::MultipleCollisionCellGasTypes="The supplied CollisionCellGas option `1` contains more than one type of gas, which is currently not supported in our system. Please consider changing this option so only one type of gas is requested, or splitting into two individual ExperimentICPMS calls to request both types of gas separately.";

Warning::LowAbundanceIsotopes="Specified Elements options contains isotopes with less than 10% natural abundance: `1`. Signal level and accuracy may be affected.";
Warning::NoStandardNecessary="No external standard or standard addition is needed since no element requires quantifying concentration.";
Warning::StandardRecommended="StandardType was either set or resolved to None while there exists elements which concentration needs to be quantified. Quantifying concentration without standard is possible but less accurate.";
Warning::InternalStandardElementPresentInSample="The following isotopes `1` which are specified as InternalStandardElements are also present in at least one samples, which will result in potentially unwanted signal change across different samples. Please consider changing InternalStandardElements or InternalStandard options.";
Warning::NoAvailableStandard="The specified or resolved list of `2` options do not contain the following isotopes `1`. Experiment will continue. Please consider manually add standard for these isotopes.";
Warning::InvalidExternalStandard="The following list of external standard `1` contains no elements that needs quantification. Experiment will continue but please consider removing these standards.";
Warning::InternalStandardElementAbsent="The specified or resolved internal standard do not contain the following elements `1`. Experiment will continue with current options but please consider to change either InternalStandardElement or InternalStandard options.";
Warning::MassRangeNarrow="The difference between specified MinMass (`1`) and MaxMass (`2`) is below 10 g/mol. Experiment will continue with current setting but please consider expanding the range for sweep scan.";
Warning::NoAvailableAdditionStandard="The specified or resolved StandardAdditionElements `2` for sample `1` do not contain the following elements `3`. Experiment will continue with current options. If StandardAdditionElements option was entered manually please recheck your entry; if StandardAdditionElements was not specified please consider changing AdditionStandard `1`.";
Warning::MissingElementsInStandards="The following elements `2` cannot be found in the Composition field of `1`. Experiment will continue but please double check your entry. If you believe these elements should present in `1`, please either edit the Composition field of `1` or manually enter concentrations in `3` Option.";
Warning::InternalStanardUnwantedElement="The following elements/isotopes `1` which needs quantification also present in the specified internal standard, which will cause the quantification to be inaccurate. Please either change the internal standard or set QuantifyConcentration to False for those elements.";
Warning::BelowThresholdIsotopesIncluded="The following isotopes `1` is below user-specified threshold, but still be selected since they are the most abundant isotopes for their elements.";
Warning::NoInternalStandardElement="InternalStandardElement was set or resolved to False for all elements while InternalStandard is set to non-Null.";
Warning::ReadSpacingTooFineForSweep="The specified ReadSpacing value was below the mininum value for Sweep, which is 0.05 Gram/Mole. The ReadSpacing for Sweep has been changed to 0.05 Gram/Mole.";

(* ::Subsubsection:: *)
(*ExperimentICPMS Experiment function*)

(* Mixed Input *)
ExperimentICPMS[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult,containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentICPMS,
			ToList[myInputs],
			ToList[myOptions]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentICPMS,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentICPMS,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentICPMS[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* Sample input/core overload*)
ExperimentICPMS[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, samplesWithPreparedSamples,
		optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests, instruments,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, instrumentOption,
		instrumentObjects, allObjects, allInstruments, allContainers, objectSampleFields,modelSampleFields,objectContainerFields,
		modelContainerFields, packetObjectSample, updatedSimulation,
		upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, downloadedStuff, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, returnEarlyQ, performSimulationQ, protocolPacket, resourcePacketTests, simulatedProtocol,
		simulation, resolvedPreparation, result, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		safeOptionsNamed, allContainerModels,
		digestionInstruments, standards, allSampleModels, sampleOption, sampleObjects, elementDataIndex, elementData,
		sampleModelRequiredField, methodPackets, simulationWithMicrowaveDigestion, digestionPrimitives
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentICPMS,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentICPMS, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentICPMS, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentICPMS, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentICPMS, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentICPMS, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentICPMS, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)

	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentICPMS, {ToList[samplesWithPreparedSamples]}, inheritedOptions]];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)

	(* do a huge search to get everything we could need *)
	{
		instruments,
		digestionInstruments
	} = Search[
		{
			{Model[Instrument,MassSpectrometer]},
			{Model[Instrument,Reactor, Microwave]}

		},
		{
			Deprecated != True && DeveloperObject != True && IonSources == ICP,
			Deprecated != True && DeveloperObject != True
		}
	];

	standards = standardModelSearch["Memoization"];



	(* gather the instrument option *)
	instrumentOption = Lookup[expandedSafeOps, {Instrument, DigestionInstrument}];

	(* pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
	instrumentObjects = Cases[Flatten[{instrumentOption}], ObjectP[Object[Instrument]]];

	(* gather the sample option excluding input samples *)
	sampleOption = Lookup[expandedSafeOps, {ExternalStandard, InternalStandard, AdditionStandard, Blank, RinseSolution}];

	(* pull out any Object[Sample]s in the sampleOption *)
	sampleObjects = Cases[Flatten[{sampleOption}], ObjectP[{Object[Sample], Model[Sample]}]];


	(* split things into groups by types (since we'll be downloading different things from different types of objects) *)
	allObjects = DeleteDuplicates[Flatten[{instruments, digestionInstruments, standards, sampleObjects}]];
	allInstruments = Cases[allObjects, ObjectP[Model[Instrument]]];
	allContainerModels = Flatten[{
		Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, Plate]}]],
		Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[{Model[Container]}], Infinity]
	}];
	allContainers = Flatten[{Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[Object[Container]], Infinity]}];
	allSampleModels = Cases[allObjects, ObjectP[Model[Sample]]];

	(*articulate all the fields needed*)
	(* Solvent and UsedAsSolvent are important for resolution of the prewetting options *)
	sampleModelRequiredField = {
		Composition,
		Object
	};
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]], {Solvent, State, Tablet, Composition, Acid, Aqueous, Object}];
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {Solvent, UsedAsSolvent, Object}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]], {KitComponents, MinTemperature, MaxTemperature, Opaque, MaxVolume}];
	modelContainerFields = Union[
		SamplePreparationCacheFields[Model[Container]],
		{
			Name, Object, Sterile, InternalDepth, InternalDiameter, MinVolume, MaxVolume, Positions, Deprecated, Footprint, NumberOfWells, AspectRatio,
			SelfStanding, Dimensions, Aperture, OpenContainer, InternalDimensions, MaxTemperature, LiquidHandlerPrefix,
			Counterweights, FilterType, PoreSize, MolecularWeightCutoff, DestinationContainerModel, RetentateCollectionContainerModel, PrefilterPoreSize,
			Diameter, MembraneMaterial, PrefilterMembraneMaterial, InletConnectionType, OutletConnectionType, MaxPressure, RentByDefault, StorageBuffer, StorageBufferVolume,
			BuiltInCover, CompatibleCoverTypes, CompatibleCoverFootprints, Opaque, Reusable, EngineDefault
		}
	];


	(* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]]
	};


	(* In this function we will frequently call ECLElementData and ECLIsotopeData, which calls Download inside them. *)
	(* Therefore, download everything in advance and pass the Cache to those functions to speed things up *)
	elementDataIndex = Model[Physics, ElementData, "id:eGakldan7Xjz"] (* "Full Index" *);

	(* download all the things *)
	downloadedStuff = Quiet[Download[
		{
			(*1*)samplesWithPreparedSamples,
			(*2*)allSampleModels,
			(*3*)allInstruments,
			(*4*)instrumentObjects,
			(*5*)allContainerModels,
			(*6*)allContainers,
			(*7*){parentProtocol},
			(*8*){elementDataIndex},
			(*9*)elementDataIndex[Data][[All, 2]]
		},
		Evaluate[{
			(* samples *)
			(*1*)packetObjectSample,
			(*2*){Packet@@sampleModelRequiredField},

			(* instrument models *)
			(*3*)
			{Packet[Name, SupportedElements, SupportedIsotopes, LowPowerElements]},
			(* instrument objects *)
			(*4*)
			{Packet[Model, Name, SupportedElements, SupportedIsotopes, LowPowerElements]},
			(*5*)
			{
				Evaluate[Packet@@modelContainerFields]
			},
			(* all basic container models (from PreferredContainers) *)
			(*6*)
			{
				Packet[Name, Object, Model, Sterile, Status, Contents, TareWeight, RequestedResources],
				Packet[Model[modelContainerFields]]
			},

			(*7*)
			{Packet[ImageSample, ParentProtocol, Financers, Name]},
			(*8*)
			{Packet[Index, AbbreviationIndex, Data, Name]},
			(*9*)
			{Packet[Abbreviation, Element, IsotopeAbundance, IsotopeMasses, Isotopes, MolarMass, Name]}
		}],
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	(* get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	(* Use Catch - Throw to force abort option resolver in case unsupported elements are included. This is because unsupported elements can break option resolving of other options *)
	resolvedOptionsResult = Catch[Check[
		{{resolvedOptions, simulationWithMicrowaveDigestion, digestionPrimitives}, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentICPMSOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentICPMSOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	]];

	(* If resolvedOptionsResult == $Aborted, exit immediately. This is due to trying to include unsupported elements, which is impossible to resolve and will kill everything later *)
	(* If gathering test, make a test here to tell users this unsupported element problem *)
	If[MatchQ[resolvedOptionsResult, $Aborted],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{
				safeOpsTests, validLengthTests, templateTests,
				Test["The following elements or isotopes "<>ToString[Lookup[expandedSafeOps, Elements]]<>" are all supported by the specified instrument:", True, False]
			}],
			Options -> expandedSafeOps,
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentICPMS,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	(*performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];*)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentICPMS, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{{protocolPacket, methodPackets}, resourcePacketTests} = Which[
		returnEarlyQ,
		{{$Failed, $Failed}, Null},
		gatherTests,
		icpmsResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			Cache -> cacheBall,
			Output -> {Result, Tests},
			Simulation -> simulationWithMicrowaveDigestion
		],
		True,
		{
			icpmsResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> simulationWithMicrowaveDigestion
			],
			{}
		}
	];

	(* If we were asked for a simulation, also return a simulation *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacket, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentICPMS[
				protocolPacket,
				Null, (* Always set to Null for unit operation packet *)
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> simulationWithMicrowaveDigestion
			],
		True, {Null, simulationWithMicrowaveDigestion}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentICPMS,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	result = Which[
		(* If our resource packet failed, can't upload anything *)
		MatchQ[protocolPacket, $Failed], $Failed,
		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			{protocolPacket},
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,MassSpectrometry],
			Cache->cacheBall,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			Simulation -> simulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentICPMS,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}

];

(* ::Subsubsection:: *)
(*resolveExperimentICPMSOptions*)

DefineOptions[
	resolveExperimentICPMSOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentICPMSOptions[myInputSamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentFilterOptions]]:=Module[
	{
		outputSpecification, output, gatherTests, cache, simulation, samplePrepOptions,
		simulatedSamples, resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, samplePackets, sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls, cacheBall, sampleDownloads, fastAssoc, messages, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		missingVolumeInvalidInputs, missingVolumeTest, mapThreadFriendlyOptions, resolvedInstrument, allTests,
		resolvedOptions, resolvedAliquotOptions, aliquotTests, optionsForAliquot, allContainerPackets,
		icpmsOptions,retiredInstrumentQ,deprecatedInstrumentQ, discardedSampleQ, standardOptionsInconsistencyQ, missingStandardOptionsQ,
		invalidBlankQ, invalidRinseQ, invalidRinseOptionsQ, invalidCollisionCellOptionsQ, invalidCollisionCellQ, invalidMinMaxMassQ, invalidSampleStateQ,
		invalidStandardElementQ,invalidStandardConcentration, invalidStandardElementReadQ, invalidStandardPresentQ, noAvailableExternalStandardQ,
		 rareIsotopeQ, standardUnecessaryQ,
		quantifySweepQ,liquidSamplePackets,missingVolumeLiquidSamplePackets,solidSamplePackets,missingMassSolidSamplePackets,missingMassInvalidInputs,
		unresolvedElements,resolvedSweep,nucleusSpecifiedQ,resolvedElement,resolvedNuclei,nonLiquidNonSolidSamplePackets,nonLiquidNonSolidSampleInvalidInputs,nonLiquidNonSolidSampleTest,
		missingMassTest, resolvedStandardType, unresolvedStandardType,roundedOptionsAssociation, roundingTests, optionsAssociation,
		unresolvedPlasmaPowers, unresolvedCollisionCellPressurizations, unresolvedCollisionCellGases, unresolvedCollisionCellGasFlowRates,
		unresolvedCollisionCellBiases, unresolvedDwellTimes, unresolvedNumbersOfReads, unresolvedReadSpacings, unresolvedBandpasses, unresolvedInternalStandardElements, unresolvedQuantifyConcentrations,
		distributedPlasmaPowers, distributedCollisionCellPressurizations, distributedCollisionCellGases, distributedCollisionCellGasFlowRates,
		distributedCollisionCellBiases, distributedDwellTimes, distributedNumbersOfReads, distributedReadSpacings, distributedBandpasses,
		distributedInternalStandardElements, distributedQuantifyConcentrations, mapThreadFriendlyElementsOptions, resolvedPlasmaPowers,
		resolvedCollisionCellPressurizations, resolvedCollisionCellGases, resolvedCollisionCellGasFlowRates, resolvedCollisionCellBiases,
		resolvedDwellTimes, resolvedNumbersOfReads, resolvedReadSpacings, resolvedBandpasses, resolvedInternalStandardElements, resolvedQuantifyConcentrations,
		unresolvedExternalStandard, unresolvedStandardAddedSamples, unresolvedAdditionStandards, unresolvedStandardAdditionCurves, unresolvedStandardAdditionElements,
		unresolvedStandardDilutionCurves, unresolvedExternalStandardElements, needQuantificationElements, needQuantificationNuclei,
		externalStandardOptionsSpecifiedQ, standardAdditionOptionsSpecifiedQ, allPossibleStandards, possibleStandardPackets, unflattenedresolvedNuclei,
		semidistributedPlasmaPowers, semidistributedCollisionCellPressurizations, semidistributedCollisionCellGases, semidistributedCollisionCellGasFlowRates,
		semidistributedCollisionCellBiases, semidistributedDwellTimes, semidistributedNumbersOfReads, semidistributedReadSpacings,
		semidistributedBandpasses, semidistributedInternalStandardElements, semidistributedQuantifyConcentrations, resolvedIsotopeAbundanceThreshold, lowAbundanceIsotopes,
		abundantIsotopeTest, collisionCellBiasOnlyErrors, collisionCellGasErrors, collisionCellGasFlowRateErrors, quantifyInternalStandardElementErrors,
		allSampleElements, internalStandardElementWarnings, sweepQuantificationWarnings, quantifyInternalStandardElementTest, quantifyInternalStandardElementOptions,
		collisionCellBiasOnlyOptions, collisionCellBiasOnlyTest, collisionCellGasOptions, collisionCellGasTest, internalStandardElementOptions,
		internalStandardElementTest, sweepQuantificationWarningTest, collisionCellGasFlowRateOptions,
		collisionCellGasFlowRateTest, resolvedExternalStandard, allStandardElements, externalStandardSpecifiedQ, externalStandardUnfoundElements,
		externalStandardPresenceError, externalStandardPresenceOptions, externalStandardPresenceTest, externalStandardAbsenceError,
		externalStandardAbsenceOptions, externalStandardAbsenceTest, noAvailableExternalStandardOptions, noAvailableExternalStandardTest,
		standardUnnecessaryOptions, standardUnnecessaryTest, standardNecessaryQ, standardNecessaryOptions, standardNecessaryTest,
		semiresolvedStandard, distributedStandardDilutionCurve, distributedExternalStandardElements, mapThreadFriendlyExternalStandardOptions,
		resolvedStandardDilutionCurves, resolvedExternalStandardElements, resolvedExternalStandardPackets, autoReadExternalStandardElements,
		invalidExternalStandards, invalidExternalStandardOptions, invalidExternalStandardTest, resolvedBlank, resolvedRinse,
		unresolvedRinseSolution, resolvedRinseSolution, unresolvedRinseTime, resolvedRinseTime,guessedInternalStandardMixRatio,
		resolvedConeDiameter, internalStandardNucleiList, internalStandardElementList, nonInternalStandardElementList,
		allInternalStandardElements, unresolvedInternalStandard, resolvedInternalStandard, semiResolvedInternalStandard, unresolvedInternalStandardMixRatio,
		resolvedInternalStandardMixRatio, unresolvedDigestions, resolvedDigestions, digestionOptionNames, digestionOptionNamesMigrationRules,
		unresolvedDigestionOptions, resolvedDigestionOptions, invalidRinseOptions, invalidRinseOptionsTest,
		invalidRinseTest, unableToFindInternalStandardQ, unableToFindInternalStandardOptions,unableToFindInternalStandardTest, internalStandardAbsentElement, elementInResolvedInternalStandard,
		internalStandardElementAbsentOptions, internalStandardElementAbsentTest, internalStandardUnwantedElementOptions, internalStandardUnwantedElementTest,
		mapThreadFriendlyDigestionOptions, samplesToDigest, samplesToNotDigest, optionsToDigest, optionsToNotDigest, unresolvedDigestionInstrument,allResolvedDigestionOptions, digestionOptionsTests,
		preresolvedDigestionOptions, allResolvedDigestionOptionsSelected, resolvedDigestionInstrument,digestionOptionNamesReverseMigrationRules,
		resolvedMinMass, resolvedMaxMass, resolvedStandardAddedSamples, resolvedAdditionStandards, resolvedStandardAdditionCurves,
		resolvedStandardAdditionElements, unresolvedMinMass, unresolvedMaxMass, internalStandardZeroVolumeOptions, internalStandardInvalidVolumeOptions,
		internalStandardZeroVolumeTest, internalStandardInvalidVolumeTest, noDigestionErrors, minMaxMassInversionError, massRangeNarrowWarning, missingMassRangeError, invalidMassRangeError,
		minMaxMassInversionOptions, minMaxMassInversionTest, massRangeNarrowOptions, massRangeNarrowTest, missingMassRangeOptions,missingMassRangeTest,
		invalidMassRangeOptions, invalidMassRangeTest, unresolvedInstrument, unresolvedInjectionDuration, resolvedInjectionDuration,
		invalidExternalStandardElementQ, invalidExternalStandardElementOptions, invalidExternalStandardElementTest, invalidStandardAdditionElementErrors,
		invalidStandardAdditionElementOptions, invalidStandardAdditionElementTest, noDigestionOptions, noDigestionTest, standardToElementRules,
		elementToStandardRules, autoFoundStandards, userExternalStandardPackets, userExternalStandardElements, missingElementsInStandards, missingElementsInStandardsTest,
		missingElementsInStandardsOptions, roundedReadSpacingQs, readSpacingTooFineForSweepOptions, readSpacingTooFineForSweepTest,
		noAvailableAdditionStandardQs, noAvailableAdditionStandardWarning, invalidInputs, invalidOptions, AttemptToQuantifySweepOptions,
		AttemptToQuantifySweepTest, belowThresholdIsotopes, invalidElements, belowThresholdIsotopesTest, semiresolvedPlasmaPowers,
		semiresolvedCollisionCellPressurizations, semiresolvedCollisionCellGases, semiresolvedCollisionCellGasFlowRates, semiresolvedCollisionCellBiases,
		semiresolvedDwellTimes, semiresolvedNumbersOfReads, semiresolvedReadSpacings, semiresolvedBandpasses, semiresolvedInternalStandardElements,
		semiresolvedQuantifyConcentrations, semiresolvedElement, semiresolvedNuclei, internalStandardSpecifiedQ, userInternalStandardElementList,
		userInternalStandardNucleusList, InternalStandardElementSpecifiedQ, allOtherSamples, allOtherElements, allUndesiredElementsForInternalStandard,
		extraInternalStandardElement, allOtherPackets, noAvailableInternalStandardQ, noAvailableInternalStandardOptions, noAvailableInternalStandardTest,
		extraInternalStandardNuclei, extraInternalStandardNucleiCount, extraPlasmaPowers, extraCollisionCellPressurizations, extraCollisionCellGases,
		extraCollisionCellGasFlowRates, extraCollisionCellBiases, extraDwellTimes, extraNumbersOfReads, extraReadSpacings, extraBandpasses,
		extraInternalStandardElements, extraQuantifyConcentrations, instrumentPacket, supportedElements, supportedIsotopes, icpmsIsotopesList,
		unsupportedElements, unsupportedElementsOptions, unsupportedElementsTest, preroundresolvedOptions, noInternalStandardElementTest,
		unresolvedSampleAmounts, resolvedSampleAmounts, samplePrepOptionNames, unresolvedAliquotOptions, mapThreadFriendlyAliquotOptions, aliquotOptionsToDigest, aliquotOptionsToNotDigest,
		preresolvedAliquotOptionsToDigest, preresolvedAliquotOptionsToNotDigest, combinedMapThreadFriendlyDigestionOptions, lowPowerElements, lowPowerIsotopes,
		simulatedSamplesToDigest, simulatedSamplesToNotDigest, sampleAmountToNotDigest, sampleAmountToDigest, requiredAliquotContainers,
		additionStandardUnfoundElements, digestionSimulation, simulationWithMicrowaveDigestion, preresolvedAliquotOptions, requiredAliquotAmounts,
		digestionPrimitives, sweepPart, needQuantificationNucleiGrouped, isotopeAbundance, lowAbundanceIsotopesForQuantificationCheck,
		noAbundantIsotopeForQuantificationOptions, noAbundantIsotopeForQuantificationTest, standardVolumeOverflows, sampleVolumeOverflows,
		invalidSampleVolumeOptions, invalidSampleVolumeTest, invalidStandardVolumeOptions, invalidStandardVolumeTest, multipleGasQ, multipleGasOptions,
		multipleGasTest, defaultCCTGas, emptyNucleiQ, unflattenedSemiresolvedNuclei
	},
	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];


	(* Separate out our FilterNew options from our Sample Prep options. *)
	{samplePrepOptions, icpmsOptions} = splitPrepOptions[myOptions];


	{
		(*1*)retiredInstrumentQ,
		(*2*)deprecatedInstrumentQ,
		(*3*)discardedSampleQ,
		(*4*)standardOptionsInconsistencyQ,
		(*5*)missingStandardOptionsQ,
		(*6*)invalidBlankQ,
		(*7*)invalidRinseQ,
		(*8*)invalidRinseOptionsQ,
		(*9*)invalidCollisionCellOptionsQ,
		(*10*)invalidCollisionCellQ,
		(*11*)invalidMinMaxMassQ,
		(*12*)invalidSampleStateQ,
		(*13*)invalidStandardElementQ,
		(*14*)invalidStandardConcentration,
		(*15*)invalidStandardElementReadQ,
		(*16*)invalidStandardPresentQ,
		(*17*)noAvailableExternalStandardQ,
		(*18*)externalStandardPresenceError,
		(*19*)externalStandardAbsenceError,
		(*20*)unableToFindInternalStandardQ

	} = ConstantArray[False, 20];

	(*Set all warning-checking variables to False (ie: no warnings)*)
	{
		(*1*)rareIsotopeQ,
		(*2*)standardUnecessaryQ,
		(*3*)quantifySweepQ,
		(*4*)standardNecessaryQ
	} = ConstantArray[False, 4];


	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentICPMS, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentICPMS, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	optionsAssociation = Association[icpmsOptions];


	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads = Quiet[Download[
		simulatedSamples,
		{
			Packet[Name, Volume, Mass, State, Status, Container, Solvent, Position, Tablet, Composition, Acid, Aqueous],
			Packet[Container[{Object, Model}]],
			Packet[Container[Model[{MaxVolume}]]]
		},
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* pull some stuff out of the cache ball to speed things up below; unfortunately can't eliminate this 100%  *)
	allContainerPackets = Cases[cacheBall, PacketP[{Model[Container], Object[Container]}]];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	} = Transpose[sampleDownloads];

	(*Invalid input error checking*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(*If there are invalid inputs set notDiscardedSampleQ to False*)
	discardedSampleQ = If[Length[discardedInvalidInputs] > 0,
		True,
		False
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		], Nothing
	];

	(* NOTE: MAKE SURE THE SAMPLES HAVE A VOLUME IF THEY'RE a LIQUID - *)

	(* Gather all liquid samples *)
	liquidSamplePackets = Select[Flatten[samplePackets],MatchQ[Lookup[#, State], Liquid]&];
	(* Get the samples that do not have a volume but are liquid *)
	missingVolumeLiquidSamplePackets = Select[Flatten[liquidSamplePackets], NullQ[Lookup[#,Volume]]&];
	missingVolumeInvalidInputs = Lookup[missingVolumeLiquidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[missingVolumeInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MissingVolumeInformation, ObjectToString[missingVolumeInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingVolumeInvalidInputs] == 0,
				Nothing,
				Warning["Our input samples " <> ObjectToString[missingVolumeInvalidInputs, Cache -> cacheBall] <> " are not missing volume information:", True, False]
			];

			passingTest = If[Length[missingVolumeInvalidInputs] == Length[myInputSamples],
				Nothing,
				Warning["Our input samples " <> ObjectToString[Complement[myInputSamples, missingVolumeInvalidInputs], Cache -> cacheBall] <> " are not missing volume information:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*TODO: sample volumes*)

	(*NOTE: MAKE SURE SAMPLE HAS A MASS IF IT'S SOLID *)

	(*Gather all solid samples*)
	solidSamplePackets = Select[Flatten[samplePackets],MatchQ[Lookup[#, State], Solid]&];
	(* Get the samples that do not have a mass but are solid *)
	missingMassSolidSamplePackets = Select[Flatten[solidSamplePackets], NullQ[Lookup[#,Mass]]&];
	missingMassInvalidInputs = Lookup[missingMassSolidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[missingMassInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MissingMassInformation, ObjectToString[missingMassInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingMassTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingMassInvalidInputs] == 0,
				Nothing,
				Warning["Our input samples " <> ObjectToString[missingMassInvalidInputs, Cache -> cacheBall] <> " are not missing mass information:", True, False]
			];

			passingTest = If[Length[missingMassInvalidInputs] == Length[myInputSamples],
				Nothing,
				Warning["Our input samples " <> ObjectToString[Complement[myInputSamples, missingMassInvalidInputs], Cache -> cacheBall] <> " are not missing mass information:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* NOTE: MAKE SURE THE SAMPLES ARE LIQUID OR SOLID - *)
	(* Get the samples that are not liquids or solids, cannot process those *)
	nonLiquidNonSolidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Liquid | Solid]]&];

	(* Keep track of samples that are not liquid *)
	nonLiquidNonSolidSampleInvalidInputs = Lookup[nonLiquidNonSolidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidNonSolidSampleInvalidInputs] > 0 && messages,
		Message[Error::NonLiquidNonSolidSample, ObjectToString[nonLiquidNonSolidSampleInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidNonSolidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidNonSolidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonLiquidNonSolidSampleInvalidInputs, Cache -> cacheBall] <> " have a Liquid Or Solid State:", True, False]
			];

			passingTest = If[Length[nonLiquidNonSolidSampleInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, nonLiquidNonSolidSampleInvalidInputs], Cache -> cacheBall] <> " have a Liquid Or Solid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*Precision checks*)
	{roundedOptionsAssociation, roundingTests} = If[gatherTests,
		RoundOptionPrecision[optionsAssociation,
			{
				MinMass,
				MaxMass,
				ReadSpacing,
				InjectionDuration,
				RinseTime,
				CollisionCellGasFlowRate,
				DwellTime,
				SampleAmount
			},
			{
				0.01 Gram/Mole,
				0.01 Gram/Mole,
				0.01 Gram/Mole,
				1 Second,
				1 Second,
				0.1 Milliliter/Minute,
				0.1 Millisecond,
				0.1 Microliter
			},
			Output -> {Result, Tests}
		],
		{RoundOptionPrecision[optionsAssociation,
			{
				MinMass,
				MaxMass,
				ReadSpacing,
				InjectionDuration,
				RinseTime,
				CollisionCellGasFlowRate,
				DwellTime,
				SampleAmount
			},
			{
				0.01 Gram/Mole,
				0.01 Gram/Mole,
				0.01 Gram/Mole,
				1 Second,
				1 Second,
				0.1 Milliliter/Minute,
				0.1 Millisecond,
				0.1 Microliter
			}
		], {}}
	];

	(* Resolve Instrument - Currently no resolution needed *)
	unresolvedInstrument = Lookup[roundedOptionsAssociation, Instrument];
	resolvedInstrument = unresolvedInstrument;

	(*Resolve Elements-related options*)

	(* Step 0 - gather some preliminary information *)
	(* Read the supported element and isotope list from instrument packet *)
	instrumentPacket = fetchPacketFromFastAssoc[resolvedInstrument, fastAssoc];

	supportedElements = Lookup[instrumentPacket, SupportedElements];

	supportedIsotopes = Lookup[instrumentPacket, SupportedIsotopes];

	lowPowerElements = Lookup[instrumentPacket, LowPowerElements];

	(* Construct a list of rules to convert supportedElements to supportedIsotopes *)
	icpmsIsotopesList = Module[{allElementSymbols, isotopeListGrouped},
		(* Convert all element into abbreviated symbols in string form *)
		allElementSymbols = ECLElementData[supportedElements, Abbreviation, Cache -> cacheBall];
		(* Group the supported Isotopes by the elements *)
		isotopeListGrouped = Function[{elementSymbol},
			Select[supportedIsotopes, MatchQ[elementSymbol, StringDelete[#, DigitCharacter]]&]
		]/@allElementSymbols;
		(* Construct the list of rules from Element to Isotopes, also append Sweep -> Sweep *)
		Append[MapThread[#1 -> #2 &, {supportedElements, isotopeListGrouped}], Sweep -> Sweep]
	];

	lowPowerIsotopes = Flatten[lowPowerElements/.icpmsIsotopesList];

	(* Step 1 - Get the provided Elements option *)
	unresolvedElements = Lookup[roundedOptionsAssociation, Elements];
	(* resolve Sweep *)
	resolvedSweep = Which[
		(*If Elements is not specified, set to True*)
		MatchQ[unresolvedElements, Automatic], True,
		(*If Elements is specified, set to True if it contains Sweep, otherwise set to False*)
		True, MemberQ[unresolvedElements, Sweep]
	];

	(*Find whether Elements is list of nuclei or elements*)
	nucleusSpecifiedQ = Which[
		(*If Elements is not specified or empty, set to False*)
		MatchQ[unresolvedElements, {} | Automatic], False,
		(*If Elements is a list of element, not nuclei, set to False*)
		MatchQ[unresolvedElements, ListableP[ICPMSElementP]],False,
		(*If Elements is a list of nuclei, not element, set to True*)
		MatchQ[unresolvedElements, ListableP[ICPMSNucleusP]], True,
		(*All other cases return to False*)
		True, False
	];

	(* Extract IsotopeAbundanceThreshold option value for later resolving purposes. No resolution needed *)
	resolvedIsotopeAbundanceThreshold = Lookup[roundedOptionsAssociation, IsotopeAbundanceThreshold];

	(* Extract all elements  from sample for later checking purposes *)
	allSampleElements = findICPMSElements[samplePackets, Elements -> All, Cache -> cacheBall];

	(*Step 2 - Resolve Elements*)
	(* Reason why these variables named as semiresolvedBLAH is because some Elements and options index-matched to Elements *)
	(* Can be added after InternalStandard is resolved, if InternalStandard -> True and no Element has InternalStandardElement -> True *)
	{unflattenedSemiresolvedNuclei, belowThresholdIsotopes, invalidElements, unsupportedElements} = Which[
		(*If Element is specified and NucleusSpecifiedQ is False, semiresolvedElement set to input, semiresolvedNucleus set to semiresolvedElement replaced by mostAbundantIsotopes*)
		!MatchQ[unresolvedElements, {} | Automatic] && !nucleusSpecifiedQ,
		ICPMSDefaultIsotopes[unresolvedElements, Flatten -> False, IsotopeAbundanceThreshold -> resolvedIsotopeAbundanceThreshold, Message->False, Cache -> cacheBall, Instrument -> resolvedInstrument],
		(*If Element is specified and NucleusSpecifiedQ is True, semiresolvedNucleus set to a list of list where each inner list contains one nucleus from input, semiresolvedElement set to semiresolvedNucleus replaced by isotopeToElementList*)
		!MatchQ[unresolvedElements, {} | Automatic] && nucleusSpecifiedQ,
		(* It might look weird here, what I was trying to do is to split unresolvedElements into a list of list where inner list consists of one single isotope *)
		(* Reason to do that is to match pattern for unflattenedresolvedNuclei resolved under other conditions *)
		{Select[ToList /@ unresolvedElements, MemberQ[Append[supportedIsotopes, Sweep], #[[1]]]&], {}, {}, Select[ToList /@ unresolvedElements, !MemberQ[Append[supportedIsotopes, Sweep], #[[1]]]&]},
		(*If Element is not specified, find all metallic elements from the composition field and take union*)
		MatchQ[unresolvedElements, Automatic],
		ICPMSDefaultIsotopes[Append[findICPMSElements[samplePackets, Cache -> cacheBall], Sweep], Flatten -> False, IsotopeAbundanceThreshold -> resolvedIsotopeAbundanceThreshold, Message->False, Cache -> cacheBall, Instrument -> resolvedInstrument]
	];

	(* Qtegra does not allow an experiment without any elements. If the unflattenedSemiresolvedNuclei is {} or contains only Sweep, add a dummy isotope 208Pb *)
	emptyNucleiQ = MatchQ[unflattenedSemiresolvedNuclei, {} | {{Sweep}}];

	unflattenedresolvedNuclei = If[emptyNucleiQ,
		Join[{{"208Pb"}}, unflattenedSemiresolvedNuclei],
		unflattenedSemiresolvedNuclei
	];

	(* unflattenedresolvedNuclei is in the following format (N = nucleus, E = Element) : {{N1E1}, {N1E2, N2E2}, {N1E3}...} *)
	(* The reason to write it in this format is that if user input elements, not nuclei as option, and some element resolves into multiple nuclei *)
	(* Then options index-matched to elements cannot successfully index-match to nuclei automatically *)

	(* Since one element can correspond to multiple isotopes to measure, flatten the nuclei list to resolve the actual option *)
	semiresolvedNuclei = Flatten[unflattenedresolvedNuclei];

	semiresolvedElement = icpmsElementFromIsotopes[semiresolvedNuclei, Cache -> cacheBall];

	(* If user specified isotopes directly, find the isotopes in semiresolvedNuclei that is below 10% natural abundance *)

	lowAbundanceIsotopes = If[nucleusSpecifiedQ,

		(* If user specified isotopes, return the isotopes in semiresolvedNuclei that is below 10% natural abundance *)
		Select[DeleteCases[semiresolvedNuclei, Sweep], ECLIsotopeData[#, IsotopeAbundance] <= 0.1 &],

		(* If user did not specify isotopes, always return empty list *)
		{}
	];

	(*  Construct warning message and test for low abundance isotopes *)

	rareIsotopeQ = Length[lowAbundanceIsotopes] >= 1;

	If[rareIsotopeQ && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::LowAbundanceIsotopes, lowAbundanceIsotopes]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	abundantIsotopeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!rareIsotopeQ,
				Nothing,
				Warning["Our Element options " <> ToString[lowAbundanceIsotopes] <> " are sufficiently high in natural abundance (>= 10%):", True, False]
			];
			passingTest= If[rareIsotopeQ,
				Nothing,
				Warning["Our Element options " <> ToString[lowAbundanceIsotopes] <> " are sufficiently high in natural abundance (>= 10%):", True, True]
			];
		], Nothing
	];

	If[Length[belowThresholdIsotopes]>0 && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::BelowThresholdIsotopesIncluded, belowThresholdIsotopes]
	];

	belowThresholdIsotopesTest = If[gatherTests,
		Module[{failingTest, passingTest, failingIsotopes, passingIsotopes},
			failingIsotopes = belowThresholdIsotopes;
			passingIsotopes = Complement[semiresolvedNuclei, failingIsotopes];
			failingTest = If[Length[failingIsotopes] > 0,
				Nothing,
				Warning["The following isotopes " <> ToString[failingIsotopes] <> " are automatically selected since they are above the specified IsotopeAbundanceThreshold:", True, False]
			];
			passingTest= If[Length[passingIsotopes] > 0,
				Nothing,
				Warning["The following isotopes " <> ToString[passingIsotopes] <> " are automatically selected since they are above the specified IsotopeAbundanceThreshold:", True, True]
			];
		], Nothing
	];

	(* Error checking to see if Elements contains element or nuclei not supported by the instrument *)
	unsupportedElementsOptions = If[!gatherTests && Length[unsupportedElements]>0,
		(Message[Error::UnsupportedElements,
			unsupportedElements, ObjectToString[resolvedInstrument, Cache -> cacheBall]
		];
		{Elements, Instrument}),
		{}
	];

	unsupportedElementsTest = If[gatherTests,
		Module[{failingTest, passingTest, failingIsotopes, passingIsotopes},
			failingIsotopes = semiresolvedNuclei;
			passingIsotopes = unsupportedElements;
			failingTest = If[Length[failingIsotopes] > 0,
				Nothing,
				Test["The following elements or isotopes " <> ToString[failingIsotopes] <> " are supported by the specified instrument:", True, False]
			];
			passingTest= If[Length[passingIsotopes] > 0,
				Nothing,
				Test["The following elements or isotopes " <> ToString[passingIsotopes] <> " are supported by the specified instrument:", True, True]
			];
		], Nothing
	];

	(* Please note that if there's any unsupported Element/isotope, it will cause the MapThread to fail when trying to resolve *)
	(* Options index-matched to Elements. *)
	(* It will also cause everything else later to fail even if we return the unresolved options so far *)
	(* To avoid that, we throw a very specific variable to terminate the execution. Since Throw interrupts Return it output no  *)
	If[Length[unsupportedElements]>0,
		(If[messages, Message[Error::InvalidOption, {unsupportedElementsOptions}]];
		Return[Throw[$Aborted]])
	];

	(* Step 3 - Read all options that are index-matched to Elements *)

	{
		unresolvedPlasmaPowers,
		unresolvedCollisionCellPressurizations,
		unresolvedCollisionCellGases,
		unresolvedCollisionCellGasFlowRates,
		unresolvedCollisionCellBiases,
		unresolvedDwellTimes,
		unresolvedNumbersOfReads,
		unresolvedReadSpacings,
		unresolvedBandpasses,
		unresolvedInternalStandardElements,
		unresolvedQuantifyConcentrations
	} = Lookup[roundedOptionsAssociation,
		{
			PlasmaPower,
			CollisionCellPressurization,
			CollisionCellGas,
			CollisionCellGasFlowRate,
			CollisionCellBias,
			DwellTime,
			NumberOfReads,
			ReadSpacing,
			Bandpass,
			InternalStandardElement,
			QuantifyConcentration
		}
	];

	(* Step 4 - Make all above options MapThread friendly according to Length of semiresolvedNuclei *)

	(* Distribute options to match their length with unflattenedresolvedNuclei first*)
	{
		semidistributedPlasmaPowers,
		semidistributedCollisionCellPressurizations,
		semidistributedCollisionCellGases,
		semidistributedCollisionCellGasFlowRates,
		semidistributedCollisionCellBiases,
		semidistributedDwellTimes,
		semidistributedNumbersOfReads,
		semidistributedReadSpacings,
		semidistributedBandpasses,
		semidistributedInternalStandardElements,
		semidistributedQuantifyConcentrations
	} = Map[
		Which[
			(* If the option is already a list, and its length equal to unflattenedresolvedNuclei, keep it as is *)
			MatchQ[#, _List] && SameLengthQ[#, unflattenedresolvedNuclei], #,
			(* If the option is not a list, expand it into a list with repeated elements and make the length match unflattenedresolvedNuclei *)
			!MatchQ[#, _List], Table[#, Length[unflattenedresolvedNuclei]],
			(*If the option is a list with a single entry and semiresolvedNuclei has more than 1 members, expand the list to match the length of unflattenedresolvedNuclei *)
			MatchQ[#, _List] && TrueQ[Length[#] == 1], Table[#[[1]], Length[unflattenedresolvedNuclei]],
			(*Finally, for all other cases, return $Failed *)
			True, $Failed
		]&,
		{
			unresolvedPlasmaPowers,
			unresolvedCollisionCellPressurizations,
			unresolvedCollisionCellGases,
			unresolvedCollisionCellGasFlowRates,
			unresolvedCollisionCellBiases,
			unresolvedDwellTimes,
			unresolvedNumbersOfReads,
			unresolvedReadSpacings,
			unresolvedBandpasses,
			unresolvedInternalStandardElements,
			unresolvedQuantifyConcentrations
		}
	];

	(* Distribute options to match their length with semiresolvedNuclei *)

	{
		distributedPlasmaPowers,
		distributedCollisionCellPressurizations,
		distributedCollisionCellGases,
		distributedCollisionCellGasFlowRates,
		distributedCollisionCellBiases,
		distributedDwellTimes,
		distributedNumbersOfReads,
		distributedReadSpacings,
		distributedBandpasses,
		distributedInternalStandardElements,
		distributedQuantifyConcentrations
	} = Map[
		Function[{option},
			Flatten[
				(* For each inner list of unflattenednuclei, replicate the option value to match the length of that inner list *)
				MapThread[Table[#1, Length[#2]]&,
					{option, unflattenedresolvedNuclei}
				],
				(* Flatten only the first level to remove the excessive list nests while ensuring it have the same length as semiresolvedNuclei *)
				1
			]
		],
		{
			semidistributedPlasmaPowers,
			semidistributedCollisionCellPressurizations,
			semidistributedCollisionCellGases,
			semidistributedCollisionCellGasFlowRates,
			semidistributedCollisionCellBiases,
			semidistributedDwellTimes,
			semidistributedNumbersOfReads,
			semidistributedReadSpacings,
			semidistributedBandpasses,
			semidistributedInternalStandardElements,
			semidistributedQuantifyConcentrations
		}
	];

	(* Make MapThread-friendly association *)
	mapThreadFriendlyElementsOptions = Map[
		Function[{optionValues},
			Association[
				MapThread[#1 -> #2&,
					{
						(* Option names *)
						{
							PlasmaPower,
							CollisionCellPressurization,
							CollisionCellGas,
							CollisionCellGasFlowRate,
							CollisionCellBias,
							DwellTime,
							NumberOfReads,
							ReadSpacing,
							Bandpass,
							InternalStandardElement,
							QuantifyConcentration
						}, optionValues
					}
				]
			]
		],
		Transpose[
			(* Option values *)
			{
				distributedPlasmaPowers, distributedCollisionCellPressurizations, distributedCollisionCellGases,
				distributedCollisionCellGasFlowRates, distributedCollisionCellBiases, distributedDwellTimes, distributedNumbersOfReads,
				distributedReadSpacings, distributedBandpasses, distributedInternalStandardElements, distributedQuantifyConcentrations
			}
		]
	];

	(* Find whether InternalStandard is specified. Depending on the result, resolution of InternalStandardElements will be different *)

	(* Read InternalStandard from options *)
	unresolvedInternalStandard = Lookup[roundedOptionsAssociation, InternalStandard];

	internalStandardSpecifiedQ = MatchQ[unresolvedInternalStandard, ObjectP[]];

	(* If InternalStandard is specified, find out the list of Element contained in InternalStandard *)
	userInternalStandardElementList = If[internalStandardSpecifiedQ,
		(* Output of findICPMSStandardElements is a list of Model[Sample, xx] -> {List of elements} rules, take the [[1,2]] element extracts the list of elements *)
		(findICPMSStandardElements[fetchPacketFromFastAssoc[unresolvedInternalStandard, fastAssoc], Output -> Elements, Cache -> cacheBall])[[1,2]],
		{}
	];

	userInternalStandardNucleusList = Quiet[ICPMSDefaultIsotopes[userInternalStandardElementList, Flatten -> True, IsotopeAbundanceThreshold -> 0, Message -> True, Instrument -> resolvedInstrument, Cache -> cacheBall]];

	(* Specify a default type of CCT gas which will Automatic may resolve to *)
	defaultCCTGas = If[MemberQ[unresolvedCollisionCellGases, Oxygen],
		Oxygen,
		Helium
	];

	(* Step 5 - Small MapThread to resolve all options index-matched to Elements *)
	{
		(*1*)semiresolvedPlasmaPowers,
		(*2*)semiresolvedCollisionCellPressurizations,
		(*3*)semiresolvedCollisionCellGases,
		(*4*)semiresolvedCollisionCellGasFlowRates,
		(*5*)semiresolvedCollisionCellBiases,
		(*6*)semiresolvedDwellTimes,
		(*7*)semiresolvedNumbersOfReads,
		(*8*)semiresolvedReadSpacings,
		(*9*)semiresolvedBandpasses,
		(*10*)semiresolvedInternalStandardElements,
		(*11*)semiresolvedQuantifyConcentrations,
		(*12*)collisionCellBiasOnlyErrors,
		(*13*)collisionCellGasErrors,
		(*14*)collisionCellGasFlowRateErrors,
		(*15*)quantifyInternalStandardElementErrors,
		(*16*)internalStandardElementWarnings,
		(*17*)sweepQuantificationWarnings,
		(*18*)roundedReadSpacingQs
	} = Transpose[
		MapThread[
			Function[{nucleus, options},
				Module[
					{
						(*Error checking variables*)
						collisionCellBiasOnlyError, collisionCellGasError, collisionCellGasFlowRateError, quantifyInternalStandardElementError,internalStandardElementWarning,
						sweepQuantificationWarning, roundedReadSpacingQ,
						(*resolved option variables*)
						resolvedPlasmaPower, resolvedCollisionCellPressurization, resolvedCollisionCellGas,
						resolvedCollisionCellGasFlowRate, resolvedCollisionCellBias, resolvedDwellTime, resolvedNumberOfReads,
						resolvedReadSpacing, resolvedBandpass, resolvedInternalStandardElement, resolvedQuantifyConcentration,
						(*unresolved option variables*)
						unresolvedPlasmaPower, unresolvedCollisionCellPressurization, unresolvedCollisionCellGas,
						unresolvedCollisionCellGasFlowRate, unresolvedCollisionCellBias, unresolvedDwellTime, unresolvedNumberOfReads,
						unresolvedReadSpacing, unresolvedBandpass, unresolvedInternalStandardElement, unresolvedQuantifyConcentration,
						(*other variables*)
						roundedReadSpacing
					},

					(* error checking variables *)
					{
						collisionCellBiasOnlyError,
						collisionCellGasError,
						collisionCellGasFlowRateError,
						quantifyInternalStandardElementError,
						internalStandardElementWarning,
						sweepQuantificationWarning
					} = {
						False,
						False,
						False,
						False,
						False,
						False
					};

					(* Pull out all the relevant unresolved options *)
					{
						unresolvedPlasmaPower,
						unresolvedCollisionCellPressurization,
						unresolvedCollisionCellGas,
						unresolvedCollisionCellGasFlowRate,
						unresolvedCollisionCellBias,
						unresolvedDwellTime,
						unresolvedNumberOfReads,
						unresolvedReadSpacing,
						unresolvedBandpass,
						unresolvedInternalStandardElement,
						unresolvedQuantifyConcentration
					} = Lookup[
						options,
						{
							PlasmaPower,
							CollisionCellPressurization,
							CollisionCellGas,
							CollisionCellGasFlowRate,
							CollisionCellBias,
							DwellTime,
							NumberOfReads,
							ReadSpacing,
							Bandpass,
							InternalStandardElement,
							QuantifyConcentration
						}
					];

					(* Resolve InternalStandardElement: No resolution needed, cannot be Automatic anyway *)
					resolvedInternalStandardElement = Which[
						(* If option is specified, keep it as is *)
						BooleanQ[unresolvedInternalStandardElement], unresolvedInternalStandardElement,
						(* If option is not specified, and if InternalStandard is specified, find whether this element is a member of userInternalStandardNucleusList *)
						internalStandardSpecifiedQ, MemberQ[userInternalStandardNucleusList, nucleus],
						(* If both this option and InternalStandard is not specified, set to False *)
						True, False
					];

					(* Resolve QuantifyConcentration *)
					resolvedQuantifyConcentration = Which[
						(* If QuantifyConcentration is specified, keep it as is *)
						BooleanQ[unresolvedQuantifyConcentration], unresolvedQuantifyConcentration,
						(* If QuantifyConcentration is not specified and nucleus == Sweep, make it False *)
						MatchQ[unresolvedQuantifyConcentration, Automatic] && MatchQ[nucleus, Sweep], False,
						(* If we was not able to resolve any nucleus before and had to add dummy nuclei, set to False *)
						TrueQ[emptyNucleiQ], False,
						(* If QuantifyConcentration is not specified and nucleus != Sweep, make it opposite of InternalStandardElement *)
						MatchQ[unresolvedQuantifyConcentration, Automatic], !resolvedInternalStandardElement
					];

					(* Resolve PlasmaPower *)
					resolvedPlasmaPower = Which[
						(* If PlasmaPower is specified, keep it as is *)
						MatchQ[unresolvedPlasmaPower, Normal | Low], unresolvedPlasmaPower,
						(* If PlasmaPower is not specified, and Nucleus is Li, Na, K, Rb, Cs, set to low *)
						MatchQ[unresolvedPlasmaPower, Automatic] && MatchQ[nucleus, Alternatives @@ lowPowerIsotopes], Low,
						(* All other cases set to Normal *)
						True, Normal
					];

					(* Resolve CollisionCellPressurization *)
					resolvedCollisionCellPressurization = Which[
						(* If CollisionCellPressurization is specified, keep it as is *)
						BooleanQ[unresolvedCollisionCellPressurization], unresolvedCollisionCellPressurization,
						(* If CollisionCellGas is neither Null nor Automatic, set to True *)
						!MatchQ[unresolvedCollisionCellGas, Null|Automatic], True,
						(* If CollisionCellGasFlowRate is Automatic, set to False *)
						MatchQ[unresolvedCollisionCellGasFlowRate, Automatic], False,
						(* If CollisionCellGasFlowRate is non-zero, set to True *)
						TrueQ[unresolvedCollisionCellGasFlowRate > 0 Milliliter/Minute], True,
						(* Any other case set to False *)
						True, False
					];

					(* Resolve CollisionCellGas *)
					resolvedCollisionCellGas = Which[
						(*If option is specified, keep it as is *)
						MatchQ[unresolvedCollisionCellGas, ICPMSCollisionCellGasP], unresolvedCollisionCellGas,
						(* If option is not specified, and if CollisionCellPressurization set to False, set it to Null *)
						MatchQ[unresolvedCollisionCellGas, Automatic] && !resolvedCollisionCellPressurization, Null,
						(* If option is not specified, and if CollisionCellPressurization set to True, set it to defaultCCTGas *)
						MatchQ[unresolvedCollisionCellGas, Automatic] && resolvedCollisionCellPressurization, defaultCCTGas,
						(* Any other cases set to Null *)
						True, Null
					];

					(* Resolve CollisionCellGasFlowRate *)
					resolvedCollisionCellGasFlowRate = Which[
						(*If option is specified, keep it as is *)
						!MatchQ[unresolvedCollisionCellGasFlowRate, Automatic | Null], unresolvedCollisionCellGasFlowRate,
						(* If the option is not specified and resolvedCollisionCellGas is Null, set to 0 *)
						MatchQ[unresolvedCollisionCellGasFlowRate, Automatic] && NullQ[resolvedCollisionCellGas], 0 Milliliter / Minute,
						(* If the option is not specified and resolvedCollisionCellGas is not Null, set to 4.5 ml/min *)
						MatchQ[unresolvedCollisionCellGasFlowRate, Automatic] && !NullQ[resolvedCollisionCellGas], 4.5 Milliliter / Minute,
						(* All other cases set to 0 *)
						True, 0 Milliliter / Minute
					];

					(* Resolve CollisionCellBias *)
					resolvedCollisionCellBias = Which[
						(*If option is specified, keep it as is *)
						BooleanQ[unresolvedCollisionCellBias], unresolvedCollisionCellBias,
						(* If option is not specified, and if resolvedCollisionCellGas set to Helium, set it to True *)
						MatchQ[unresolvedCollisionCellBias, Automatic] && MatchQ[resolvedCollisionCellGas, Helium], True,
						(* Any other case set to False *)
						True, False
					];

					(* Resolve DwellTime *)
					resolvedDwellTime = Which[
						(* If option is specified, keep it as is *)
						!MatchQ[unresolvedDwellTime, Automatic | Null], unresolvedDwellTime,
						(* If the option is not specified and nucleus is Sweep, set to 1 ms *)
						MatchQ[unresolvedDwellTime, Automatic] && MatchQ[nucleus, Sweep], 1 Millisecond,
						(* Any other cases set to 10 ms *)
						True, 10 Millisecond
					];

					(* resolve Number of Reads: no resolution necessary *)
					resolvedNumberOfReads = unresolvedNumberOfReads;

					(* Resolve ReadSpacing *)
					(*Note that minimum allowed value of ReadSpacing for all actual elements is 0.01 amu, but for Sweep is 0.05 amu. One need to first modify that *)
					{roundedReadSpacing, roundedReadSpacingQ} = If[
						(* If option is specified, value below 0.05 g/mol and nucleus == Sweep, change to 0.05 Gram/Mole *)
						MatchQ[nucleus, Sweep] && MatchQ[unresolvedReadSpacing, UnitsP[Gram/Mole]] && unresolvedReadSpacing < 0.05 Gram/Mole,
						{0.05 Gram/Mole, True},
						{unresolvedReadSpacing, False}
					];

					resolvedReadSpacing = Which[
						(* If option is specified, keep it as is *)
						!MatchQ[roundedReadSpacing, Automatic], roundedReadSpacing,
						(* If option is not specified and nucleus == Sweep, set to 0.2 g/mol *)
						MatchQ[roundedReadSpacing, Automatic] && MatchQ[nucleus, Sweep], 0.2 Gram / Mole,
						(* Any other cases set to 0.1 g/mol *)
						True, 0.1 Gram / Mole
					];

					(* Resolve Bandpass: no resolution needed currently *)
					resolvedBandpass = unresolvedBandpass;

					(* Resolve error checking Booleans *)
					(* Check conflicts between CollisionCellGas and CollisionCellPressurization *)
					collisionCellGasError = Which[

						(* If CollisionCellPressurization is set to True, CollisionCellGas must not be Null *)
						resolvedCollisionCellPressurization && NullQ[resolvedCollisionCellGas], True,
						(* If CollisionCellPressurization is set to False, CollisionCellGas must be Null *)
						!resolvedCollisionCellPressurization && !NullQ[resolvedCollisionCellGas], True,
						(* All other cases goes to False *)
						True, False
					];

					(* Check conflicts between CollisionCellGas and CollisionCellGasFlowRate *)
					collisionCellGasFlowRateError = Which[

						(* If CollisionCellGas is set to Null, CollisionCellGasFlowRate must be 0 *)
						NullQ[resolvedCollisionCellGas] && resolvedCollisionCellGasFlowRate > 0 Milliliter / Minute, True,
						(* If CollisionCellPressurization is set to not Null, CollisionCellGasFlowRate must be greater than 0 *)
						!NullQ[resolvedCollisionCellGas] && resolvedCollisionCellGasFlowRate == 0 Milliliter / Minute, True,
						(* All other cases goes to False *)
						True, False
					];

					(* Check conflicts between CollisionCellPressurization and CollisionCellBias *)
					collisionCellBiasOnlyError = If[
						(* If CollisionCellBias is set to True, CollisionCellPressurization must be True *)
						!resolvedCollisionCellPressurization && resolvedCollisionCellBias,
						True,
						(* All other cases goes to False *)
						False
					];

					(* Check conflicts between InternalStandardElement and Elements *)
					(* If resolvedInternalStandardElement is set to True, and this element present in input sample, error goes to True *)
					internalStandardElementWarning = If[resolvedInternalStandardElement && Intersection[allSampleElements, icpmsElementFromIsotopes[nucleus, Cache -> cacheBall]]!={},
						True,
						False
					];

					(* When nucleus == Sweep, both InternalStandardElement and QuantifyConcentration should be False *)
					sweepQuantificationWarning = If[MatchQ[nucleus, Sweep] && Or[resolvedInternalStandardElement, resolvedQuantifyConcentration],
						True,
						(* Skip check if nucleus != Sweep *)
						False
					];

					(* Check conflicts between InternalStandardElement and QuantifyConcentration *)
					quantifyInternalStandardElementError = Which[
						(* If Element is Sweep, skip test *)
						MatchQ[nucleus, Sweep], False,
						(* If InternalStandardElement set to True, QuantifyConcentration must be False *)
						resolvedInternalStandardElement, resolvedQuantifyConcentration,
						(* All other cases go to False *)
						True, False
					];

					{
						(*1*)resolvedPlasmaPower,
						(*2*)resolvedCollisionCellPressurization,
						(*3*)resolvedCollisionCellGas,
						(*4*)resolvedCollisionCellGasFlowRate,
						(*5*)resolvedCollisionCellBias,
						(*6*)resolvedDwellTime,
						(*7*)resolvedNumberOfReads,
						(*8*)resolvedReadSpacing,
						(*9*)resolvedBandpass,
						(*10*)resolvedInternalStandardElement,
						(*11*)resolvedQuantifyConcentration,
						(*12*)collisionCellBiasOnlyError,
						(*13*)collisionCellGasError,
						(*14*)collisionCellGasFlowRateError,
						(*15*)quantifyInternalStandardElementError,
						(*16*)internalStandardElementWarning,
						(*17*)sweepQuantificationWarning,
						(*18*)roundedReadSpacingQ
					}

				]
			],
			{semiresolvedNuclei, mapThreadFriendlyElementsOptions}
		]
	];

	(* Generates test and error messages for options index-matched to Elements *)

	(* Only one type of CCT gas is allowed *)
	multipleGasQ = TrueQ[Length[DeleteDuplicates[DeleteCases[semiresolvedCollisionCellGases, Null]]] > 1];
	multipleGasOptions = If[multipleGasQ && messages,
		(
			Message[
				Error::MultipleCollisionCellGasTypes,
				unresolvedCollisionCellGases
			];
			{CollisionCellGas}
		),
		{}
	];

	multipleGasTest = Test["At most one type of gas is specified for CollisionCellGas option:", multipleGasQ, False];

	(* Make sure to turn off CollisionCellBias when CollisionCellPressurization is set to False *)
	collisionCellBiasOnlyOptions = If[MemberQ[collisionCellBiasOnlyErrors, True] && messages,
		(
			Message[
				Error::CollisionCellBiasOnWithoutGas,
				PickList[semiresolvedNuclei, collisionCellBiasOnlyErrors]
			];
			{CollisionCellBias, CollisionCellPressurization}
		),
		{}
	];
	collisionCellBiasOnlyTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, collisionCellBiasOnlyErrors];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these isotopes " <> ToString[passingOptions] <> " If CollisionCellBias set to True, then CollisionCellPressurization must also be True:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these isotopes " <> ToString[failingOptions] <> " If CollisionCellBias set to True, then CollisionCellPressurization must also be True:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Make sure to set CollisionCellGas to non-Null if CollisionCellPressurization is set to True, vice versa *)
	collisionCellGasOptions = If[MemberQ[collisionCellGasErrors, True] && messages,
		(
			Message[
				Error::CollisionCellGasConflict,
				PickList[semiresolvedNuclei, collisionCellGasErrors]
			];
			{CollisionCellGas, CollisionCellPressurization}
		),
		{}
	];
	collisionCellGasTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, collisionCellGasErrors];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these isotopes " <> ToString[passingOptions] <> " If CollisionCellPressurization set to True, then CollisionCellGas must be non-Null, vice versa:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these isotopes " <> ToString[failingOptions] <> " If CollisionCellBias set to True, then CollisionCellPressurization must also be True:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];
	(* Make sure that if CollisionCellGas is set or resolved to non-Null, CollisionCellGasFlowRate is set or resolved to non-zero, vice versa *)
	collisionCellGasFlowRateOptions = If[MemberQ[collisionCellGasFlowRateErrors, True] && messages,
		(
			Message[
				Error::CollisionCellGasFlowRateConflict,
				PickList[semiresolvedNuclei, collisionCellGasFlowRateErrors]
			];
			{CollisionCellGasFlowRate, CollisionCellGas}
		),
		{}
	];
	collisionCellGasFlowRateTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, collisionCellGasFlowRateErrors];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these isotopes " <> ToString[passingOptions] <> " If CollisionCellGas is non-Null, CollisionCellGasFlowRate must be above 0 ml/min, and vice versa:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these isotopes " <> ToString[failingOptions] <> " If CollisionCellGas is non-Null, CollisionCellGasFlowRate must be above 0 ml/min, and vice versa:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];
	(* Make sure that all QuantifyConcentration and InternalStandardElement for Sweep is set to False *)
	AttemptToQuantifySweepOptions = If[MemberQ[sweepQuantificationWarnings, True] && messages,
		(
			Message[
				Error::AttemptToQuantifySweep
			];
			{QuantifyConcentration}
		),
		{}
	];
	AttemptToQuantifySweepTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, sweepQuantificationWarnings];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these isotopes " <> ToString[passingOptions] <> " If it is Sweep, then both QuantifyConcentration and InternalStandardElement is True:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these isotopes " <> ToString[failingOptions] <> " If it is Sweep, then both QuantifyConcentration and InternalStandardElement is True:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];
	(* Make sure that all elements with InternalStandardElement -> True does not present in input samples *)
	internalStandardElementOptions = If[MemberQ[internalStandardElementWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InternalStandardElementPresentInSample,
				PickList[semiresolvedNuclei, internalStandardElementWarnings]
			];
			{InternalStandardElement}
		),
		{}
	];
	internalStandardElementTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, internalStandardElementWarnings];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Warning["For all of these isotopes " <> ToString[passingOptions] <> " If InternalStandardElement is set to True, then it must not present in any input samples:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["For all of these isotopes " <> ToString[failingOptions] <> " If InternalStandardElement is set to True, then it must not present in any input samples:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Make sure to not quantify concentrations for elements with InternalStandardElement -> True *)
	quantifyInternalStandardElementOptions = If[MemberQ[quantifyInternalStandardElementErrors, True] && messages,
		(
			Message[
				Error::CannotQuantifyInternalStandardElement,
				PickList[semiresolvedNuclei, quantifyInternalStandardElementErrors]
			];
			{QuantifyConcentration, InternalStandardElement}
		),
		{}
	];
	quantifyInternalStandardElementTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[semiresolvedNuclei, quantifyInternalStandardElementErrors];
			passingOptions = Complement[semiresolvedNuclei, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these isotopes " <> ToString[passingOptions] <> " InternalStandardElement and Quantify concentration cannot be both True:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these isotopes " <> ToString[failingOptions] <> " InternalStandardElement and Quantify concentration cannot be both True:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	readSpacingTooFineForSweepOptions = If[MemberQ[roundedReadSpacingQs, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::ReadSpacingTooFineForSweep
			];
			{ReadSpacing}
		),
		{}
	];

	readSpacingTooFineForSweepTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[MemberQ[roundedReadSpacingQs, True],
				Warning["ReadSpacing setting for Sweep is greater than or equal to 0.05 g/mol:", True, True],
				Nothing
			];
			failingTest = If[MemberQ[roundedReadSpacingQs, True],
				Warning["ReadSpacing setting for Sweep is greater than or equal to 0.05 g/mol:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	If[messages && internalStandardSpecifiedQ && !MemberQ[semiresolvedInternalStandardElements, True] && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::NoInternalStandardElement
		]
	];

	noInternalStandardElementTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[internalStandardSpecifiedQ && MemberQ[semiresolvedInternalStandardElements, True],
				Warning["If InternalStandard is specified, InternalStandardElement is set or resolved to contain at least one True:", True, True],
				Nothing
			];
			failingTest = If[internalStandardSpecifiedQ && !MemberQ[semiresolvedInternalStandardElements, True],
				Warning["If InternalStandard is specified, InternalStandardElement is set or resolved to contain at least one True:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Generates a list of nuclei/elements need to be quantified *)
	(* If QuantifyConcentration set to True for Sweep, ignore that *)
	needQuantificationNuclei = DeleteCases[PickList[semiresolvedNuclei, semiresolvedQuantifyConcentrations], Sweep];
	needQuantificationElements = icpmsElementFromIsotopes[needQuantificationNuclei, Cache -> cacheBall];

	(* If user wish to quantify elements, then each elements must contain at least one isotope which its natural abundance is above 0.1% *)
	(* Otherwise the accuracy will be greatly reduced. we should make it an error instead of warning because later in parser we will exclude *)
	(* isotopes below 0.1% for calculating element concentrations *)

	(* First group isotopes by elements *)
	needQuantificationNucleiGrouped = GatherBy[needQuantificationNuclei, StringDelete[#, DigitCharacter]&];

	(* Check abundance for all isotopes *)
	isotopeAbundance = Map[Function[{isotopes}, ECLIsotopeData[isotopes, IsotopeAbundance]], needQuantificationNucleiGrouped];

	(* For each element, returns True if none of the isotopes are >= 0.1% abundance *)
	lowAbundanceIsotopesForQuantificationCheck = (!MemberQ[#, GreaterEqualP[0.001]])& /@ isotopeAbundance;

	noAbundantIsotopeForQuantificationOptions = If[MemberQ[lowAbundanceIsotopesForQuantificationCheck, True] && messages,
		(
			Message[
				Error::NoAbundantIsotopeForQuantification,
				PickList[needQuantificationElements, lowAbundanceIsotopesForQuantificationCheck]
			];
			{Elements, QuantifyElements, QuantifyConcentration}
		),
		{}
	];

	noAbundantIsotopeForQuantificationTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[needQuantificationElements, lowAbundanceIsotopesForQuantificationCheck];
			passingOptions = Complement[needQuantificationElements, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Test["For all of these elements that need to be quantified" <> ToString[passingOptions] <> " at least one isotope with >0.1% abundance will be detected:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Test["For all of these elements that need to be quantified" <> ToString[failingOptions] <> " at least one isotope with >0.1% abundance will be detected:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Resolve Standard-related Options *)

	(* Step 1 - Read all relevant options *)
	{
		unresolvedStandardType,
		unresolvedExternalStandard,
		unresolvedStandardAddedSamples,
		unresolvedAdditionStandards,
		unresolvedStandardAdditionCurves,
		unresolvedStandardAdditionElements,
		unresolvedStandardDilutionCurves,
		unresolvedExternalStandardElements
	} = Lookup[roundedOptionsAssociation,
		{
			StandardType,
			ExternalStandard,
			StandardAddedSample,
			AdditionStandard,
			StandardAdditionCurve,
			StandardAdditionElements,
			StandardDilutionCurve,
			ExternalStandardElements

		}
	];



	(* Step 2 - Resolve StandardType *)
	(* Find out whether any of external-standard-related options are specified *)
	externalStandardOptionsSpecifiedQ = Or[
		MatchQ[unresolvedExternalStandard, ListableP[ObjectP[]]],
		!MatchQ[unresolvedStandardDilutionCurves, ListableP[Automatic|Null|{}]],
		!MatchQ[unresolvedExternalStandardElements, ListableP[Automatic|Null|{}]]
	];
	(* Find out whether any of standard-addition-related options are specified *)
	standardAdditionOptionsSpecifiedQ = Or[
		MatchQ[unresolvedAdditionStandards, ListableP[ObjectP[]]],
		!MatchQ[unresolvedStandardAdditionCurves, ListableP[Automatic|Null|{}]],
		!MatchQ[unresolvedStandardAdditionElements, ListableP[Automatic|Null|{}]],
		(* Note: If StandardAddedSample is a list of False, that count as not specified since it's the default value *)
		TrueQ[Or@@ToList[unresolvedStandardAddedSamples]]
	];

	resolvedStandardType = Which[
		(* If StandardType is specified, keep it as is *)
		!MatchQ[unresolvedStandardType, Automatic], unresolvedStandardType,
		(* If no element needs to be quantified, set to None *)
		Or @@ semiresolvedQuantifyConcentrations == False, None,
		(* Else, if externalStandardOptionsSpecifiedQ == True, set to External *)
		externalStandardOptionsSpecifiedQ, External,
		(* Else, if standardAdditionOptionsSpecifiedQ == True, set to StandardAddition *)
		standardAdditionOptionsSpecifiedQ, StandardAddition,
		(* Else, if there's at least one Element needs to be quantified, set to External *)
		Or @@ semiresolvedQuantifyConcentrations, External,
		(* Other cases set to None *)
		True, None
	];

	(* Tests and error-checking Booleans *)

	(* Return a warning if needQuantificationNuclei is empty but StandardType set or resolved to anything other than None *)
	standardUnecessaryQ = Length[needQuantificationNuclei] == 0 && !MatchQ[resolvedStandardType, None];

	standardUnnecessaryOptions = Which[
		(* If standardType set or resolved to External but External standard set to Automatic, throw error *)
		standardUnecessaryQ && MatchQ[resolvedStandardType, External] && MatchQ[unresolvedExternalStandard, ListableP[Automatic]] && messages,
		(
			Message[
				Error::NoStandardNecessary
			];
			{StandardType}
		),
		(* If standardType set or resolved to StandardAddition but AdditionStandard set to Automatic, throw error *)
		standardUnecessaryQ && MatchQ[resolvedStandardType, StandardAddition] && MemberQ[ToList[unresolvedAdditionStandards], Automatic] && messages,
		(
			Message[
				Error::NoStandardNecessary
			];
			{StandardType}
		),
		(* Otherwise, if standardUnecessaryQ is True, throw warning *)
		standardUnecessaryQ && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::NoStandardNecessary
			];
			{}
		),
		(* Otherwise, no message *)
		True, {}
	];

	standardUnnecessaryTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!standardUnecessaryQ,
				Warning["If no element needs to be quantified, StandardType should be set or resolved to empty set:", True, True],
				Nothing
			];
			failingTest = If[standardUnecessaryQ,
				Warning["If no element needs to be quantified, StandardType should be set or resolved to empty set:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Return a warning if needQuantificationNuclei is non-empty but StandardType set or resolved to None *)
	standardNecessaryQ = Length[needQuantificationNuclei] != 0 && MatchQ[resolvedStandardType, None];
	standardNecessaryOptions = If[standardNecessaryQ && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::StandardRecommended
			];
			{StandardType}
		)
	];
	standardNecessaryTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!standardNecessaryQ,
				Warning["If any element needs to be quantified, StandardType should not be set or resolved to None:", True, True],
				Nothing
			];
			failingTest = If[standardNecessaryQ,
				Warning["If any element needs to be quantified, StandardType should not be set or resolved to None:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Step 3 - Resolve ExternalStandard *)

	(* Find whether ExternalStandard option is specified if StandardType is set or resolved to External *)
	externalStandardSpecifiedQ = MatchQ[unresolvedExternalStandard, ListableP[ObjectP[]] | Null] || !MatchQ[resolvedStandardType, External];

	(* Resolve ExternalStandard and related error-checking variables *)

	(* Here, regardless of what the Options setting is, I will try to auto find 3 standards to use for External or StandardAddition later *)
	(* It's a bit more work computationally but much easier and cleaner to code *)
	(* Find all Standard Models that can be chosen from *)
	allPossibleStandards = standardModelSearch["Memoization"];

	(* Fetching the standard packets from cache *)
	possibleStandardPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ allPossibleStandards;

	(* Find all element that presents in the standard packets, and establish a rule between standard object and elements contained *)
	standardToElementRules = findICPMSStandardElements[possibleStandardPackets, Output -> Elements, Cache -> cacheBall];

	(* Extract all elements contained in each standard *)
	allStandardElements = Values[standardToElementRules];

	(* Find the reverse rule *)
	elementToStandardRules = MapThread[#1->#2&, {allStandardElements, Keys[standardToElementRules]}];

	(* Resolve ExternalStandard. Output from pickBestStandard is a nested list of elements contained in the standard *)
	semiresolvedStandard = pickBestStandard[needQuantificationElements, allStandardElements, MaxResults -> 3];

	(* Replace with elementToStandardRules to find up to 3 standards *)
	autoFoundStandards = Flatten[semiresolvedStandard/.elementToStandardRules];

	(* If ExternalStandard is user-specified, fetch its packet *)
	userExternalStandardPackets = If[MatchQ[unresolvedExternalStandard, ListableP[ObjectP[]]],
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ ToList[unresolvedExternalStandard],
		{}
	];

	(* Again, if ExternalStandard is user-specified, find the complete set of elements those standards cover *)
	userExternalStandardElements = If[MatchQ[unresolvedExternalStandard, ListableP[ObjectP[]]],
		Values[findICPMSStandardElements[userExternalStandardPackets, Output -> Elements, Cache -> cacheBall]],
		{}
	];

	(* Resolve ExternalStandard. If it resolves to {}, change that to {Null} *)
	resolvedExternalStandard = Which[
		(* If this option is specified, keep it as is, wrap it in a list if it's a single object *)
		MatchQ[unresolvedExternalStandard, ListableP[ObjectP[]|Null]], ToList[unresolvedExternalStandard],
		(* If resolvedStandardType != External, set to Null *)
		!MatchQ[resolvedStandardType, External], {Null},
		(* Otherwise, set it to autoFoundStandards *)
		True, autoFoundStandards
	]/.<|{}->{Null}|>;

	(* Find whether and which element is not covered by the choice of ExternalStandard *)
	externalStandardUnfoundElements = Which[
		(* If resolvedStandardType is not External, ignore it, don't track anything *)
		!MatchQ[resolvedStandardType, External], {},
		(* If resolvedStandardType is External but resolvedExternalStandard is {Null}, set to all of needQuantificationElements *)
		NullQ[resolvedExternalStandard], needQuantificationElements,
		(* Otherwise, if ExternalStandard is auto-resolved, find what elements are not covered from semiresolvedStandard *)
		MatchQ[unresolvedExternalStandard, Automatic], Complement[needQuantificationElements, DeleteDuplicates[Flatten[semiresolvedStandard]]],
		(* Lastly, if ExternalStandard is user-specified, find what elements are not covered from userExternalStandardElements *)
		True, Complement[needQuantificationElements, DeleteDuplicates[Flatten[userExternalStandardElements]]]
	];

	(* Construct a list of packets for all resolved ExternalStandard for future use *)
	resolvedExternalStandardPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ DeleteCases[ToList[resolvedExternalStandard], Null];

	(* Construct a list of elements and concentrations contained in the resolvedExternalStandard for future use*)
	autoReadExternalStandardElements = findICPMSStandardElements[resolvedExternalStandardPackets, Output -> {Elements, Concentrations}, Cache -> cacheBall];

	(* Error checking Booleans *)



	(* Make sure that if StandardType is not set or resolved to External, ExternalStandard should resolve to {Null} *)

	externalStandardPresenceError = (!MatchQ[resolvedStandardType, External]) && (!MatchQ[resolvedExternalStandard, {Null}]);

	externalStandardPresenceOptions = If[externalStandardPresenceError && messages,
		(
			Message[
				Error::ExternalStandardPresence,
				ObjectToString[resolvedExternalStandard]
			];
			{StandardType, ExternalStandard}
		),
		{}
	];

	externalStandardPresenceTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!externalStandardPresenceError,
				Test["ExternalStandard is set or resolved to empty set if StandardType is set or resolved to None or StandardAddition:", True, True],
				Nothing
			];
			failingTest = If[externalStandardPresenceError,
				Test["ExternalStandard is set or resolved to empty set if StandardType is set or resolved to None or StandardAddition:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Make sure that if StandardType is set or resolved to External, ExternalStandard should not be set to {Null} *)

	externalStandardAbsenceError = MatchQ[unresolvedExternalStandard, {Null}] && MatchQ[resolvedStandardType, External];

	externalStandardAbsenceOptions = If[externalStandardAbsenceError && messages,
		(
			Message[
				Error::ExternalStandardAbsence
			];
			{StandardType, ExternalStandard}
		),
		{}
	];

	externalStandardAbsenceTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!externalStandardAbsenceError,
				Test["ExternalStandard is not set to empty set if StandardType is set or resolved to External:", True, True],
				Nothing
			];
			failingTest = If[externalStandardAbsenceError,
				Test["ExternalStandard is not set to empty set if StandardType is set or resolved to External:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Make sure that the choice of standards covers every element that needs quantification *)
	noAvailableExternalStandardQ = Length[externalStandardUnfoundElements] != 0;

	noAvailableExternalStandardOptions = If[noAvailableExternalStandardQ && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::NoAvailableStandard,
				externalStandardUnfoundElements,
				"ExternalStandard"
			];
			{StandardType, ExternalStandard, QuantifyConcentration}
		),
		{}
	];

	noAvailableExternalStandardTest = If[gatherTests && MatchQ[resolvedStandardType, External],
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!noAvailableExternalStandardQ,
				Test["If StandardType is set or resolved to External, all elements needs quantification can be found in at least one of the ExternalStandard:", True, True],
				Nothing
			];
			failingTest = If[noAvailableExternalStandardQ,
				Test["If StandardType is set or resolved to External, all elements needs quantification can be found in at least one of the ExternalStandard:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Make sure that one don't specify ExternalStandardElement without specifying ExternalStandard; if that happens, throw an error *)
	invalidExternalStandardElementQ = If[MatchQ[unresolvedExternalStandard, Automatic|Null] && !MatchQ[unresolvedExternalStandardElements, Automatic|Null],
		True,
		False
	];

	invalidExternalStandardElementOptions = If[invalidExternalStandardElementQ && messages,
		(
			Message[
				Error::InvalidExternalStandardElements,
				unresolvedExternalStandard, unresolvedExternalStandardElements
			];
			{ExternalStandard, ExternalStandardElements}
		),
		{}
	];

	invalidExternalStandardElementTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!invalidExternalStandardElementQ,
				Test["If ExternalStandard is not specified or specified as Null, ExternalStandardElement must also not be specified:", True, True],
				Nothing
			];
			failingTest = If[invalidExternalStandardElementQ,
				Test["If ExternalStandard is not specified or specified as Null, ExternalStandardElement must also not be specified:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Step 4 - Resolve options index-matched to ExternalStandard: StandardDilutionCurve and ExternalStandardElements *)

	(* The reason why I don't use Map to distribute the following two options, like what I did for options index-matched to Elements *)
	(* Was that both of them can be a list of list or list of list of list, which cause bug due to unexpected index-matching *)
	(* For example, suppose I have two standards and I set my StandardDilutionCurve as {{1 ml, 9 ml}, {5 ml, 5ml}} *)
	(* What I intended to have is that both standards will share the same StandardDilutionCurve {{1 ml, 9 ml}, {5 ml, 5ml}} *)
	(* However, because my StandardDilutionCurve is a list with length 2, it will be mistakenly treated as already distributed *)
	(* So that my element 1 has StandardDilutionCurve set as {1 ml, 9 ml}, element 2 has {5 ml, 5ml} *)
	(* To avoid that, I wrote the code below to match the patterns more rigorously *)
	(* TODO the key here is to make sure you have lots of unit tests for these various cases because it is pretty complicated *)
	distributedStandardDilutionCurve = Which[
		(* If option is set to a list of list of list, and the length equal to resolvedExternalStandard, keep it as is *)
		ArrayDepth[unresolvedStandardDilutionCurves] == 3 && SameLengthQ[unresolvedStandardDilutionCurves, resolvedExternalStandard], unresolvedStandardDilutionCurves,
		(* If option is set to a list of list of list, but the length is 1, and resolvedExternalStandard has more than 1 members, expand the list to match the length of resolvedExternalStandard *)
		ArrayDepth[unresolvedStandardDilutionCurves] == 3 && TrueQ[Length[unresolvedStandardDilutionCurves] == 1], Table[unresolvedStandardDilutionCurves[[1]], Length[resolvedExternalStandard]],
		(* If option is not a list, distribute to a list of same members matching the length of resolvedExternalStandard *)
		!MatchQ[unresolvedStandardDilutionCurves, _List], Table[unresolvedStandardDilutionCurves, Length[resolvedExternalStandard]],
		(* If option is a list of Null or Automatic, and the length matches resolvedExternalStandard, keep it as is *)
		MatchQ[unresolvedStandardDilutionCurves, ListableP[Null|Automatic]] && SameLengthQ[unresolvedStandardDilutionCurves, resolvedExternalStandard], unresolvedStandardDilutionCurves,
		(* If the option is a list of one single element of Null or Automatic, expand it to match the length of resolvedExternalStandard *)
		MatchQ[unresolvedStandardDilutionCurves, {Null|Automatic}], Table[unresolvedStandardDilutionCurves[[1]], Length[resolvedExternalStandard]],
		(* If option is a list of volumes or numbers and length is 2, wrap it with another layer of list, then replicate to match length of resolvedExternalStandard *)
		MatchQ[unresolvedStandardDilutionCurves, ListableP[VolumeP|_?NumberQ]] && Length[unresolvedStandardDilutionCurves] == 2, Table[{unresolvedStandardDilutionCurves}, Length[resolvedExternalStandard]],
		(* If option is set to a list of list, replicate the list to match length of resolvedExternalStandard *)
		ArrayDepth[unresolvedStandardDilutionCurves] == 2, Table[unresolvedStandardDilutionCurves, Length[resolvedExternalStandard]],
		(* All other cases go to $Failed *)
		True, $Failed
	];
	distributedExternalStandardElements = Which[
		(* If option is set to a list of list of list, and the length equal to resolvedExternalStandard, keep it as is *)
		ArrayDepth[unresolvedExternalStandardElements] == 3 && SameLengthQ[unresolvedExternalStandardElements, resolvedExternalStandard], unresolvedExternalStandardElements,
		(* If option is set to a list of list of list, but the length is 1, expand the list to match the length of resolvedExternalStandard *)
		ArrayDepth[unresolvedExternalStandardElements] == 3 && TrueQ[Length[unresolvedExternalStandardElements] == 1], Table[unresolvedExternalStandardElements[[1]], Length[resolvedExternalStandard]],
		(* If option is not a list, distribute to a list of same members matching the length of resolvedExternalStandard *)
		!MatchQ[unresolvedExternalStandardElements, _List], Table[unresolvedExternalStandardElements, Length[resolvedExternalStandard]],
		(* If option is a list of Null or Automatic, and the length matches resolvedExternalStandard, keep it as is *)
		MatchQ[unresolvedExternalStandardElements, ListableP[Null|Automatic]] && SameLengthQ[unresolvedExternalStandardElements, resolvedExternalStandard], unresolvedExternalStandardElements,
		(* If the option is a list of one single element of Null or Automatic, expand it to match the length of resolvedExternalStandard *)
		MatchQ[unresolvedExternalStandardElements, {Null|Automatic}], Table[unresolvedExternalStandardElements[[1]], Length[resolvedExternalStandard]],
		(* If the option is a list of element - concentration pair, wrap it with another layer of list, then replicate *)
		MatchQ[unresolvedExternalStandardElements, {ICPMSElementP|ICPMSNucleusP, ConcentrationP|MassConcentrationP}], Table[{unresolvedExternalStandardElements}, Length[resolvedExternalStandard]],
		(* If the option is a list of one member, the member is a list of element - concentration pair, replicate *)
		MatchQ[unresolvedExternalStandardElements, {{ICPMSElementP | ICPMSNucleusP, ConcentrationP | MassConcentrationP}}], Table[unresolvedExternalStandardElements, Length[resolvedExternalStandard]],
		(* If the option is a list of elements, replicate this list to match the length of resolvedExternalStandard *)
		MatchQ[unresolvedExternalStandardElements, ListableP[ICPMSElementP | ICPMSNucleusP]], Table[unresolvedExternalStandardElements, Length[resolvedExternalStandard]],
		(* If the option is a list of one member, the member is a list of elements, expand the list *)
		MatchQ[unresolvedExternalStandardElements, {ListableP[ICPMSElementP | ICPMSNucleusP]}], Table[unresolvedExternalStandardElements[[1]], Length[resolvedExternalStandard]],
		(* If the option is a list of list of elements, and the length matches with resolvedExternalStandard, keep it as is *)
		MatchQ[Flatten[unresolvedExternalStandardElements], ListableP[ICPMSElementP | ICPMSNucleusP]] && SameLengthQ[unresolvedExternalStandardElements, resolvedExternalStandard], unresolvedExternalStandardElements,
		(* If the option is a list of element - concentration pairs, replicate it *)
		MatchQ[unresolvedExternalStandardElements, ListableP[{ICPMSElementP | ICPMSNucleusP, ConcentrationP | MassConcentrationP}]], Table[unresolvedExternalStandardElements, Length[resolvedExternalStandard]],
		(* All other cases go to $Failed *)
		True, $Failed

	];

	(* Make MapThread-friendly association *)

	mapThreadFriendlyExternalStandardOptions = Function[{optionValues},
		Association @@ MapThread[#1 -> #2&,
			{
				(* Option names *)
				{
					StandardDilutionCurve,
					ExternalStandardElements
				}, optionValues
			}
		]
	] /@ Transpose[
		(* Option values *)
		{
			distributedStandardDilutionCurve, distributedExternalStandardElements
		}
	];

	(* we have not yet resolved InternalStandard, but for volume checking purpose we'll make some guess on the mixing ratio *)
	unresolvedInternalStandardMixRatio = Lookup[roundedOptionsAssociation, InternalStandardMixRatio];

	guessedInternalStandardMixRatio = Which[
		(* If InternalStandard was specified as Null, we know the ratio is 0 *)
		!NullQ[unresolvedInternalStandard], 0,
		(* In any other case let's assume for now there is InternalStandard *)
		(* If InternalStandardMixRatio is specified, use that value *)
		MatchQ[unresolvedInternalStandardMixRatio, _?NumericQ], unresolvedInternalStandardMixRatio,
		(* Otherwise set to 0.111 *)
		True, 0.111
	];

	(* Tiny MapThread to resolve all options index-matched to ExternalStandard *)

	{
		(*1*)resolvedStandardDilutionCurves,
		(*2*)resolvedExternalStandardElements,
		(*3*)invalidExternalStandards,
		(*4*)missingElementsInStandards,
		(*5*)standardVolumeOverflows
	} = Transpose[
		MapThread[
			Function[{externalStandard, options},
				Module[
					{
						(* Error checking variables *)
						invalidStandard,
						(* resolved option variables *)
						resolvedStandardDilutionCurve, resolvedExternalStandardElement,
						(* unresolved option variables *)
						unresolvedStandardDilutionCurve, unresolvedExternalStandardElement,
						(* other variables *)
						standardElementSpecifiedQ, standardConcentrationSpecifiedQ, standardNucleusSpecifiedQ,
						elementAndConcentrationList, semiresolvedExternalStandardElement, missingIsotopes, missingElement,
						standardVolumeOverflow, totalStandardVolume
					},

					(* error checking variables *)
					{
						invalidStandard
					} = {
						False
					};

					(* Pull out all the relevant unresolved options *)
					{
						unresolvedStandardDilutionCurve,
						unresolvedExternalStandardElement
					} = Lookup[
						options,
						{
							StandardDilutionCurve,
							ExternalStandardElements
						}
					];

					(* Resolve ExternalStandardElement *)
					(* Step 1 - Find the whether element and/or concentration is specified *)
					{standardElementSpecifiedQ, standardNucleusSpecifiedQ, standardConcentrationSpecifiedQ} = {
						MatchQ[unresolvedExternalStandardElement, ListableP[ICPMSElementP]|ListableP[{ICPMSElementP, ConcentrationP|MassConcentrationP}]],
						MatchQ[unresolvedExternalStandardElement, ListableP[{ICPMSNucleusP, ConcentrationP|MassConcentrationP}]],
						MatchQ[unresolvedExternalStandardElement, ListableP[{ICPMSNucleusP, ConcentrationP|MassConcentrationP}]|ListableP[{ICPMSElementP, ConcentrationP|MassConcentrationP}]]
					};

					(* fetch the list of Elements and Concentrations for this particular external standard *)
					elementAndConcentrationList = MapThread[#1 -> #2&, Lookup[autoReadExternalStandardElements, externalStandard, {{},{}}]];

					(* Step 2 - resolve ExternalStandardElement *)
					semiresolvedExternalStandardElement = Which[
						(* If Isotopes and concentrations are specified, keep it as is. Use findICPMSIsotopeConcentrations function to convert all molar concentrations to mass concentrations *)
						standardNucleusSpecifiedQ, findICPMSIsotopeConcentrations[unresolvedExternalStandardElement, Cache -> cacheBall],
						(* If Elements and concentrations are specified, use findICPMSIsotopeConcentrations function to construct list of isotopes and concentrations *)
						standardElementSpecifiedQ && standardConcentrationSpecifiedQ, findICPMSIsotopeConcentrations[unresolvedExternalStandardElement, Cache -> cacheBall],
						(* If only elements are specified, first read the concentrations from standard, then construct list of isotopes and concentrations *)
						(* If any elements cannot be found, set their concentrations to Missing for now for the sake of error-ckecking *)
						standardElementSpecifiedQ && !standardConcentrationSpecifiedQ, findICPMSIsotopeConcentrations[Transpose[{unresolvedExternalStandardElement, Lookup[elementAndConcentrationList,unresolvedExternalStandardElement, Missing]}], Cache -> cacheBall],
						(* If ExternalStandardElement is not specified and externalStandard == Null, set to Null *)
						NullQ[externalStandard], Null,
						(* If ExternalStandardElement is not specified at all, use the full list of elements from elementAndConcentrationList *)
						MatchQ[unresolvedExternalStandardElement, Automatic], findICPMSIsotopeConcentrations[Transpose[{Keys[elementAndConcentrationList], Values[elementAndConcentrationList]}], Cache -> cacheBall],
						(* If ExternalStandardElement is set to Null, also return Null *)
						NullQ[unresolvedExternalStandardElement], Null,
						(* Any other case go to Null *)
						True, Null
					];

					(* If ExternalStandardElement is auto-resolved, select the ones that is included in semiresolvedNuclei, then set all Missing concentrations to 0 *)
					resolvedExternalStandardElement = If[
						(* Unless ExternalStandardElement was specified in {isotope, concentration} pair, or resolvedExternalStandardElement resolved to Null, select {isotope, concentration} pair that is in semiresolvedNuclei *)
						!standardNucleusSpecifiedQ && !NullQ[semiresolvedExternalStandardElement],
						Select[semiresolvedExternalStandardElement, MemberQ[semiresolvedNuclei, #[[1]]]&],
						(* In the other case don't change *)
						semiresolvedExternalStandardElement
					]/.{Missing -> 0 Gram/Liter};

					(* Error-checking variables *)
					missingIsotopes = PickList[Sequence @@ Transpose[semiresolvedExternalStandardElement], Missing];

					missingElement = icpmsElementFromIsotopes[missingIsotopes, Cache -> cacheBall];

					(* Resolve StandardDilutionCurve *)
					(* Step 3 - Resolve StandardDilutionCurve *)
					resolvedStandardDilutionCurve = Which[
						(* If StandardDilutionCurve is specified in terms of two volumes, keep it as is *)
						MatchQ[unresolvedStandardDilutionCurve, ListableP[{VolumeP, VolumeP}]], unresolvedStandardDilutionCurve,
						(* If StandardDilutionCurve is set to Null, keep it as is *)
						NullQ[unresolvedStandardDilutionCurve], Null,
						(* If StandardDilutionCurve is specified in terms of standard volume and dilution factor, convert dilution factor to diluent volume *)
						MatchQ[unresolvedStandardDilutionCurve, ListableP[{VolumeP, _?NumericQ}]], MapThread[{#1, #1 * (#2 - 1)}&,Transpose[unresolvedStandardDilutionCurve]],
						(* If StandardDilutionCurve is not specified, and externalStandard is Null, set to Null *)
						MatchQ[unresolvedStandardDilutionCurve, Automatic] && NullQ[externalStandard], Null,
						(* If StandardDilutionCurve is not specified, and highest concentration of resolvedExternalStandardElement is above 10 mg/l set to a list of 3 dilution factors such that highest concentration of the ExternalStandardElement becomes 1, 3 and 10 mg/l *)
						MatchQ[unresolvedStandardDilutionCurve, Automatic] && TrueQ[Quiet[Max[resolvedExternalStandardElement[[All,2]]] > 10 Milligram/Liter]],
						{
							{3 Microgram/Max[resolvedExternalStandardElement[[All,2]]], 3 Milliliter - 3 Microgram/Max[resolvedExternalStandardElement[[All,2]]]},
							{9 Microgram/Max[resolvedExternalStandardElement[[All,2]]], 3 Milliliter - 9 Microgram/Max[resolvedExternalStandardElement[[All,2]]]},
							{30 Microgram/Max[resolvedExternalStandardElement[[All,2]]], 3 Milliliter - 30 Microgram/Max[resolvedExternalStandardElement[[All,2]]]}
						},
						(* If StandardDilutionCurve is not specified, and highest concentration of resolvedExternalStandardElement is below 10 mg/l set to a list of 3 dilution factors of 1, 3, 10 *)
						MatchQ[unresolvedStandardDilutionCurve, Automatic],
						{
							{0.3333 Milliliter, 2.6667 Milliliter},
							{1 Milliliter, 2 Milliliter},
							{3 Milliliter, 0 Milliliter}
						},
						(* Any other case go to Null *)
						True, Null
					];

					(* Step 4 - Error checks *)
					(* Check whether resolvedExternalStandardElement include any isotopes in semiresolvedNuclei *)
					invalidStandard = If[NullQ[resolvedExternalStandardElement],
						False,
						Length[Intersection[semiresolvedNuclei, resolvedExternalStandardElement[[All, 1]]]] == 0
					];

					(* Check whether total volume of standard is above 15 ml *)
					(* Calculate the volume of standard per container *)
					totalStandardVolume = If[NullQ[resolvedStandardDilutionCurve],
						(* If there's no StandardDilutionCurve, resolve to 0 *)
						0 Milliliter,
						(* Otherwise use the maximum summed value from the DilutionCurve *)
						Max[Total/@resolvedStandardDilutionCurve]
					] * (guessedInternalStandardMixRatio+1);
					standardVolumeOverflow = totalStandardVolume >= 15 Milliliter;

					{
						(*1*)resolvedStandardDilutionCurve,
						(*2*)resolvedExternalStandardElement,
						(*3*)invalidStandard,
						(*4*)missingElement,
						(*5*)standardVolumeOverflow
					}

				]
			],
			{resolvedExternalStandard, mapThreadFriendlyExternalStandardOptions}
		]
	];

	invalidStandardVolumeOptions = If[MemberQ[standardVolumeOverflows, True] && messages,
		(
			Message[
				Error::StandardVolumeOverflow,
				PickList[resolvedStandardDilutionCurves, standardVolumeOverflows],
				PickList[resolvedExternalStandard, standardVolumeOverflows]
			];
			{StandardDilutionCurve}
		),
		{}
	];

	invalidStandardVolumeTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[resolvedExternalStandard, standardVolumeOverflows];
			passingOptions = Complement[resolvedExternalStandard, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Warning["Total volume of the following external standard:"<>ObjectToString[passingOptions]<>"is within 15 ml:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["Total volume of the following external standard:"<>ObjectToString[failingOptions]<>"is within 15 ml:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Error checking for options index-matched to ExternalStandard *)
	invalidExternalStandardOptions = If[MemberQ[invalidExternalStandards, True] && messages && MatchQ[resolvedStandardType, External] && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InvalidExternalStandard,
				PickList[resolvedExternalStandard, invalidExternalStandards]
			];
			{ExternalStandard, ExternalStandardElements}
		)
	];
	invalidExternalStandardTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[resolvedExternalStandard, invalidExternalStandards];
			passingOptions = Complement[resolvedExternalStandard, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Warning["For all of these external standards " <> ToString[passingOptions] <> " the ExternalStandardElement it contains covers at least one resolved Elements:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["For all of these external standards " <> ToString[failingOptions] <> " the ExternalStandardElement it contains covers at least one resolved Elements:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	missingElementsInStandardsOptions = If[messages && !NullQ[resolvedExternalStandard] && MemberQ[missingElementsInStandards, Except[{}]] && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::MissingElementsInStandards,
				ObjectToString[PickList[resolvedExternalStandard, missingElementsInStandards, Except[{}]],Cache->cacheBall],
				DeleteCases[missingElementsInStandards, {}],
				"ExternalStandardElements"
			];
			{ExternalStandard, ExternalStandardElements}
		)
	];
	missingElementsInStandardsTest = If[gatherTests,
		Module[{passingOptions, failingOptions, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingOptions = PickList[resolvedExternalStandard, missingElementsInStandards, Except[{}]];
			passingOptions = Complement[resolvedExternalStandard, failingOptions];
			(* Create a test for passing options *)
			passingTest = If[Length[passingOptions]>0,
				Warning["For all of these external standards " <> ToString[passingOptions] <> " If a list of Elements but not concentrations is specified as ExternalStandardElements, all the specified elements exist in the Composition field:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["For all of these external standards " <> ToString[failingOptions] <> " If a list of Elements but not concentrations is specified as ExternalStandardElements, all the specified elements exist in the Composition field:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];


	(* Resolve for Blank - No resolution needed *)
	resolvedBlank = Lookup[roundedOptionsAssociation, Blank];

	(* Resolve for Rinse - No resolution needed *)
	resolvedRinse = Lookup[roundedOptionsAssociation, Rinse];

	(* Resolve for RinseSolution *)
	unresolvedRinseSolution = Lookup[roundedOptionsAssociation, RinseSolution];

	resolvedRinseSolution = Which[
		(* If RinseSolution is specified, keep it as is *)
		!MatchQ[unresolvedRinseSolution, Automatic], unresolvedRinseSolution,
		(* If RinseSolution is not specified, set to resolvedBlank *)
		True, resolvedBlank
	];

	(* Resolve for RinseTime *)
	unresolvedRinseTime = Lookup[roundedOptionsAssociation, RinseTime];

	resolvedRinseTime = Which[
		(* If RinseTime is specified, keep it as is *)
		!MatchQ[unresolvedRinseTime, Automatic], unresolvedRinseTime,
		(* If RinseTime is not specified, and if Rinse == True, set to 240 Second *)
		resolvedRinse, 240 Second,
		(* Set to Null instead if resolvedRinse == False *)
		!resolvedRinse, Null,
		(* All other cases set to Null *)
		True, Null
	];

	(* Return error if Rinse is set or resolved to False, but some of the rinse-related options are not Null *)
	invalidRinseQ = !resolvedRinse && !(NullQ[resolvedRinseTime]);

	(* Return error if Rinse is set or resolved to True, but some of the rinse-related options are Null *)
	invalidRinseOptionsQ = resolvedRinse && (NullQ[resolvedRinseTime]);

	invalidRinseOptions = Which[
		invalidRinseQ && messages,
		(
			Message[
				Error::InvalidRinse
			];
			{Rinse, RinseTime, RinseSolution}
		),
		invalidRinseOptionsQ && messages,
		(
			Message[
				Error::InvalidRinseOptions
			];
			{Rinse, RinseTime, RinseSolution}
		),
		True, {}
	];

	invalidRinseTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!invalidRinseQ,
				Test["If Rinse is set or resolved to False, none of the rinse-related options is non-Null:", True, True],
				Nothing
			];
			failingTest = If[invalidRinseQ,
				Test["If Rinse is set or resolved to False, none of the rinse-related options is non-Null:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		]
	];

	invalidRinseOptionsTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!invalidRinseOptionsQ,
				Test["If Rinse is set or resolved to True, none of the rinse-related options is Null:", True, True],
				Nothing
			];
			failingTest = If[invalidRinseOptionsQ,
				Test["If Rinse is set or resolved to True, none of the rinse-related options is Null:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		]
	];

	(* Resolve for ConeDiameter - no resolution needed *)
	resolvedConeDiameter = Lookup[roundedOptionsAssociation, ConeDiameter];


	(* Resolve Injection duration - currently no resolution necessary *)

	unresolvedInjectionDuration = Lookup[roundedOptionsAssociation, InjectionDuration];

	resolvedInjectionDuration = unresolvedInjectionDuration;

	(* Read MinMass and MaxMass from user-defined options *)
	{unresolvedMinMass, unresolvedMaxMass} = Lookup[roundedOptionsAssociation, {MinMass, MaxMass}, Null];

	(* Resolve MinMass and MaxMass *)
	resolvedMinMass = Which[
		(* If MinMass is specified, keep it as is. Null counts as specified *)
		!MatchQ[unresolvedMinMass, Automatic], unresolvedMinMass,
		(* Otherwise, if Sweep is a member of resolvedElements, set to 4.6 g/mol (default of the ICPMS instrument TODO should this be hardcoded? should this live in the instrument model?) *)
		resolvedSweep, 4.6 Gram/Mole,
		(* Otherwise set to Null *)
		True, Null
	];

	resolvedMaxMass = Which[
		(* If MinMass is specified, keep it as is. Null counts as specified *)
		!MatchQ[unresolvedMaxMass, Automatic], unresolvedMaxMass,
		(* Otherwise, if Sweep is a member of resolvedElements, set to 245 g/mol (default of the ICPMS instrument TODO should this be hardcoded?) *)
		resolvedSweep, 245 Gram/Mole,
		(* Otherwise set to Null *)
		True, Null
	];

	(* Error-checking variable: MaxMass must be bigger than MinMass *)
	minMaxMassInversionError = Which[
		(* If any of MinMass or MaxMass is not quantity, set to False (no error) *)
		!(MatchQ[resolvedMinMass, UnitsP[Gram/Mole]] && MatchQ[resolvedMaxMass, UnitsP[Gram/Mole]]), False,
		(* Otherwise, If MinMass >= MaxMass, set to True *)
		True, resolvedMinMass >= resolvedMaxMass
	];

	minMaxMassInversionOptions = If[minMaxMassInversionError && messages,
		(
			Message[
				Error::MinMaxMassInversion,
				resolvedMinMass, resolvedMaxMass
			];
			{MinMass, MaxMass}
		),
		{}
	];

	minMaxMassInversionTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!minMaxMassInversionError,
				Test["If both MinMass and MaxMass is specified or resolved to non-Null, MaxMass must be higher than MinMass:", True, True],
				Nothing
			];
			failingTest = If[minMaxMassInversionError,
				Test["If both MinMass and MaxMass is specified or resolved to non-Null, MaxMass must be higher than MinMass:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Error-checking variable: warning if range of mass scan smaller than 10 g/mol *)
	massRangeNarrowWarning = Which[
		(* If any of MinMass or MaxMass is not quantity, set to False (no error) *)
		!(MatchQ[resolvedMinMass, _Quantity] && MatchQ[resolvedMaxMass, _Quantity]), False,
		(* Otherwise, If 0 < MaxMass - MinMass <= 10 g/mol, set to True *)
		True, 0 Gram/Mole < resolvedMaxMass - resolvedMinMass <= 10 Gram/Mole
	];

	massRangeNarrowOptions = If[massRangeNarrowWarning && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::MassRangeNarrow,
				resolvedMinMass, resolvedMaxMass
			];
			{MinMass, MaxMass}
		)
	];

	massRangeNarrowTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!massRangeNarrowWarning,
				Warning["If both MinMass and MaxMass is specified or resolved to non-Null, difference between MinMass and MaxMass should be greater than 10 g/mol:", True, True],
				Nothing
			];
			failingTest = If[massRangeNarrowWarning,
				Warning["If both MinMass and MaxMass is specified or resolved to non-Null, difference between MinMass and MaxMass should be greater than 10 g/mol:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Error-checking variable: If Sweep is on, both MinMass and MaxMass must be non-Null *)
	missingMassRangeError = If[resolvedSweep,
		!MatchQ[{resolvedMinMass, resolvedMaxMass}, {_Quantity, _Quantity}],
		False
	];

	missingMassRangeOptions = If[missingMassRangeError && messages,
		(
			Message[
				Error::MissingMassRange,
				PickList[{MinMass, MaxMass}, NullQ/@{resolvedMinMass, resolvedMaxMass}]
			];
			{MinMass, MaxMass, Elements}
		),
		{}
	];

	missingMassRangeTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!missingMassRangeError,
				Test["If Sweep is on, both MinMass and MaxMass must be non-Null:", True, True],
				Nothing
			];
			failingTest = If[missingMassRangeError,
				Test["If Sweep is on, both MinMass and MaxMass must be non-Null:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Error-checking variable: If Sweep is off, both MinMass and MaxMass must be Null *)
	invalidMassRangeError = If[!resolvedSweep,
		!MatchQ[{resolvedMinMass, resolvedMaxMass}, {Null, Null}],
		False
	];

	invalidMassRangeOptions = If[invalidMassRangeError && messages,
		(
			Message[
				Error::InvalidMassRange,
				PickList[{MinMass, MaxMass}, NullQ/@{resolvedMinMass, resolvedMaxMass}, False]
			];
			{MinMass, MaxMass, Elements}
		),
		{}
	];

	invalidMassRangeTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!invalidMassRangeError,
				Test["If Sweep is off, both MinMass and MaxMass must be Null:", True, True],
				Nothing
			];
			failingTest = If[invalidMassRangeError,
				Test["If Sweep is off, both MinMass and MaxMass must be Null:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Resolve for Digestion *)
	(* Read Digestion option from input *)
	unresolvedDigestions = Lookup[roundedOptionsAssociation, Digestion];

	(* Resolve for digestion-related options *)
	(* Define a list of option names that is related to digestion *)
	digestionOptionNames = {
		SampleType,
		SampleDigestionAmount,
		CrushSample,
		PreDigestionMix,
		PreDigestionMixTime,
		PreDigestionMixRate,
		PreparedPreDigestionSample,
		DigestionAgents,
		DigestionTemperature,
		DigestionDuration,
		DigestionRampDuration,
		DigestionTemperatureProfile,
		DigestionMixRateProfile,
		DigestionMaxPower,
		DigestionMaxPressure,
		DigestionPressureVenting,
		DigestionPressureVentingTriggers,
		DigestionTargetPressureReduction,
		DigestionOutputAliquot,
		DiluteDigestionOutputAliquot,
		PostDigestionDiluent,
		PostDigestionDiluentVolume,
		PostDigestionDilutionFactor,
		PostDigestionSampleVolume,
		DigestionContainerOut
	};

	(* Define a list of rules to convert option name defined in ExperimentICPMS to ExperimentMicrowaveDigestion *)
	digestionOptionNamesMigrationRules = {
		DigestionInstrument -> Instrument,
		SampleDigestionAmount -> SampleAmount,
		PreparedPreDigestionSample -> PreparedSample,
		DigestionPressureVenting -> PressureVenting,
		DigestionPressureVentingTriggers -> PressureVentingTriggers,
		DigestionTargetPressureReduction -> TargetPressureReduction,
		DigestionOutputAliquot -> OutputAliquot,
		DiluteDigestionOutputAliquot -> DiluteOutputAliquot,
		PostDigestionDiluent -> Diluent,
		PostDigestionDiluentVolume -> DiluentVolume,
		PostDigestionDilutionFactor -> DilutionFactor,
		PostDigestionSampleVolume -> TargetDilutionVolume,
		DigestionContainerOut -> ContainerOut
	};

	digestionOptionNamesReverseMigrationRules = Values[#] -> Keys[#]&/@digestionOptionNamesMigrationRules;

	(* Construct a list of digestion-related options. Unlike other options, this one will be a list of rules, not just the values *)
	unresolvedDigestionOptions = MapThread[#1 -> #2&,
		{digestionOptionNames, Lookup[roundedOptionsAssociation,digestionOptionNames]}
	];

	(* Read the SampleAmount option *)
	unresolvedSampleAmounts = Lookup[roundedOptionsAssociation, SampleAmount];

	(* Convert digestion options to MapThread Friendly version *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentICPMS,
		<|
			Digestion -> unresolvedDigestions, SampleAmount -> unresolvedSampleAmounts,
			StandardAddedSample -> unresolvedStandardAddedSamples, AdditionStandard -> unresolvedAdditionStandards,
			StandardAdditionCurve -> unresolvedStandardAdditionCurves, StandardAdditionElements -> unresolvedStandardAdditionElements
		|>
	];
	mapThreadFriendlyDigestionOptions = OptionsHandling`Private`mapThreadOptions[ExperimentICPMS, Association @@ unresolvedDigestionOptions];

	(* add the sample prep options to the options being passed into resolveAliquotOptions *)
	optionsForAliquot = ReplaceRule[myOptions, resolvedSamplePrepOptions];

	(* construct a list of aliquot-related options *)
	samplePrepOptionNames = ToExpression[Join[Keys[Options[SamplePrepOptions]], Keys[Options[AliquotOptions]]]];

	unresolvedAliquotOptions = MapThread[#1 -> #2&,
		{samplePrepOptionNames, Lookup[optionsForAliquot, samplePrepOptionNames]}
	];

	mapThreadFriendlyAliquotOptions = OptionsHandling`Private`mapThreadOptions[ExperimentICPMS, Association @@ unresolvedAliquotOptions];


	(* MapThread to resolve Digestion and other index-matching options *)
	{
		(*1*)resolvedDigestions,
		(*2*)resolvedStandardAddedSamples,
		(*3*)resolvedAdditionStandards,
		(*4*)resolvedStandardAdditionCurves,
		(*5*)resolvedStandardAdditionElements,
		(*6*)noDigestionErrors,
		(*7*)invalidStandardAdditionElementErrors,
		(*8*)noAvailableAdditionStandardQs,
		(*9*)resolvedSampleAmounts,
		(*10*)additionStandardUnfoundElements,
		(*11*)sampleVolumeOverflows
	} = Transpose[
		MapThread[
			Function[{samplePacket, options},
				Module[
					{
						unresolvedDigestion, resolvedDigestion,
						resolvedStandardAddedSample, resolvedAdditionStandard, resolvedStandardAdditionCurve,
						resolvedStandardAdditionElement,semiresolvedStandardAdditionElement,
						unresolvedStandardAddedSample, unresolvedAdditionStandard, unresolvedStandardAdditionCurve,
						unresolvedStandardAdditionElement, additionStandardFoundElements, unusedAdditionStandards,
						additionStandardUnfoundElement, additionStandardIterationNumber, additionStandardEarlyTerminateIterationQ,
						standardElementSpecifiedQ, standardConcentrationSpecifiedQ, resolvedStandardAdditionPacket,
						autoReadAdditionStandardElement, elementAndConcentrationList, semiresolvedAdditionStandard, noDigestionError,
						additionStandardPresenceError, additionStandardAbsenceError, noAvailableAdditionStandardQ, invalidStandardAdditionElementError,
						userAdditionStandardPacket, userStandardAdditionElements, resolvedSampleAmount, unresolvedSampleAmount, totalSampleVolume,
						sampleVolumeOverflow
					},
					(* read unresolved Digestion *)
					unresolvedDigestion = Lookup[options, Digestion];
					(* resolve Digestion *)
					resolvedDigestion = Which[
						(* If Digestion is specified, keep it as is *)
						BooleanQ[unresolvedDigestion], unresolvedDigestion,
						(* If sample is non-liquid or tablet, set to True *)
						!MatchQ[Lookup[samplePacket, State], Liquid], True,
						MatchQ[Lookup[samplePacket, Tablet], True], True,
						(* If sample contains any biological, polymer or non-molecule material, set to True *)
						Or @@ (MatchQ[ObjectP[
							DeleteCases[IdentityModelTypes, Model[Molecule]]
						]] /@ Lookup[samplePacket, Composition][[All,2]]), True,
						(* Else, if sample is acid and aqueous, set to False *)
						MatchQ[Lookup[samplePacket, {Acid, Aqueous}], {True,True}], False,
						(* All other cases set to True *)
						True, True
					];

					(* Error checking variable: All non-liquid sample must be digested *)
					noDigestionError = If[!MatchQ[Lookup[samplePacket, State], Liquid] && !resolvedDigestion,
						True,
						False
					];

					(* Resolve SampleAmount, currently no resolution needed *)
					unresolvedSampleAmount = Lookup[options, SampleAmount];
					resolvedSampleAmount = unresolvedSampleAmount;

					(* Resolve StandardAddedSample *)
					unresolvedStandardAddedSample = Lookup[options,StandardAddedSample];

					(* Currently no resolution needed *)
					resolvedStandardAddedSample = unresolvedStandardAddedSample;

					(* Read unresolved AdditionStandard from options *)
					unresolvedAdditionStandard = Lookup[options, AdditionStandard];

					(* Resolve AdditionStandard *)
					resolvedAdditionStandard = Which[
						(* If this option is already specified, keep it as is *)
						MatchQ[unresolvedAdditionStandard, ObjectP[]|Null], unresolvedAdditionStandard,
						(* Otherwise, if resolvedStandardType != StandardAddition, set to Null *)
						!MatchQ[resolvedStandardType, StandardAddition], Null,
						(* Otherwise, if StandardAddedSample is set to True, set to Null *)
						resolvedStandardAddedSample, Null,
						(* Otherwise, if autoFoundStandards is empty, set to Null *)
						Length[autoFoundStandards] == 0, Null,
						(* Otherwise, set to the first standard in autoFoundStandards *)
						True, autoFoundStandards[[1]]
					];

					(* Find whether all elements are covered *)

					(* If AdditionStandard is user-specified, fetch its packet *)
					userAdditionStandardPacket = If[MatchQ[unresolvedAdditionStandard, ObjectP[]],
						fetchPacketFromFastAssoc[resolvedAdditionStandard, fastAssoc],
						{}
					];

					(* Again, if AdditionStandard is user-specified, find the complete set of elements it covers *)
					userStandardAdditionElements = If[MatchQ[unresolvedAdditionStandard, ObjectP[]],
						Flatten[Values[findICPMSStandardElements[userAdditionStandardPacket, Output -> Elements, Cache -> cacheBall]]],
						{}
					];

					(* Find the list of elements not covered by specified or resolved standard *)
					(*additionStandardUnfoundElements = Which[
						(* If StandardType != StandardAddition, don't track anything *)
						!MatchQ[resolvedStandardType, StandardAddition], {},
						(* If resolvedStandardType is StandardAddition, but resolvedAdditionStandard is Null, set to all of needQuantificationElements *)
						NullQ[resolvedAdditionStandard], needQuantificationElements,
						(* Otherwise, if AdditionStandard is auto-resolved, find what elements are not covered from semiresolvedStandard *)
						MatchQ[unresolvedAdditionStandard, Automatic], Complement[needQuantificationElements, DeleteDuplicates[Flatten[semiresolvedStandard[[1]]]]],
						(* Lastly, if AdditionStandard is user-specified, find what elements are not covered from userExternalStandardElements *)
						True, Complement[needQuantificationElements, DeleteDuplicates[userStandardAdditionElements]]
					];*)


					(* Resolve StandardAdditionElement *)
					(* Read user input. Convert any Null to {} to allow functions to handle correctly *)
					unresolvedStandardAdditionElement = (Lookup[options, StandardAdditionElements, Null])/.{Null -> {}};

					(* Step 1 - Find the whether element and/or concentration is specified *)
					{standardElementSpecifiedQ, standardConcentrationSpecifiedQ} = {
						MatchQ[unresolvedStandardAdditionElement, ListableP[ICPMSElementP]|ListableP[{ICPMSElementP, ConcentrationP|MassConcentrationP}]],
						MatchQ[unresolvedStandardAdditionElement, ListableP[{ICPMSNucleusP, ConcentrationP|MassConcentrationP}]|ListableP[{ICPMSElementP, ConcentrationP|MassConcentrationP}]]
					};

					(* Find the packet of the resolved AdditionStandard. If StandardAddedSample -> True, treat the input sample as addition standard *)
					resolvedStandardAdditionPacket = Which[
						(* If StandardAddedSample -> True, set it to the input sample packet *)
						resolvedStandardAddedSample, samplePacket,
						(* If resolvedAdditionStandard is Null, set to empty set *)
						NullQ[resolvedAdditionStandard], {},
						(* Otherwise fetch the resolvedAdditionStandard packet from fastAssoc *)
						True, fetchPacketFromFastAssoc[resolvedAdditionStandard, fastAssoc]
					];

					(* Construct a list of elements and concentrations contained in the resolvedAdditionStandard for future use *)
					autoReadAdditionStandardElement = findICPMSStandardElements[resolvedStandardAdditionPacket, Output -> {Elements, Concentrations}, Cache -> cacheBall];

					(* Make the above results a list of rules from Element to Concentrations *)
					elementAndConcentrationList = MapThread[#1 -> #2&,
						Lookup[autoReadAdditionStandardElement,
							If[resolvedStandardAddedSample,
								Lookup[samplePacket, Object],
								resolvedAdditionStandard
							],
							{{},{}}
						]
					];

					(* Step 2 - resolve StandardAdditionElement *)
					semiresolvedStandardAdditionElement = Which[
						(* If Elements and concentrations are specified, use findICPMSIsotopeConcentrations function to convert any molar concentrations into mass concentrations *)
						standardElementSpecifiedQ && standardConcentrationSpecifiedQ, findICPMSIsotopeConcentrations[unresolvedStandardAdditionElement, Cache -> cacheBall, Output -> Elements],
						(* If only elements are specified, first read the concentrations from standard, then construct list of elements and concentrations *)
						standardElementSpecifiedQ && !standardConcentrationSpecifiedQ, findICPMSIsotopeConcentrations[Transpose[{unresolvedStandardAdditionElement, Lookup[elementAndConcentrationList,unresolvedStandardAdditionElement, 0 Gram/Liter]}], Cache -> cacheBall, Output -> Elements],
						(* If StandardAdditionElement is not specified at all, use the full list of elements from elementAndConcentrationList *)
						MatchQ[unresolvedStandardAdditionElement, Automatic], findICPMSIsotopeConcentrations[Transpose[{Keys[elementAndConcentrationList], Values[elementAndConcentrationList]}], Cache -> cacheBall, Output -> Elements],
						(* If StandardAdditionElement is set to Null, also return Null *)
						NullQ[unresolvedStandardAdditionElement], Null,
						(* Any other case go to Null *)
						True, Null
					];

					(* If StandardAdditionElement is auto-resolved, select the ones that is included in semiresolvedNuclei *)

					resolvedStandardAdditionElement = If[
						(* Unless semiresolvedStandardAdditionElement resolved to Null, select {element, concentration} pair that is in semiresolvedElement *)
						!NullQ[semiresolvedStandardAdditionElement],
						Select[semiresolvedStandardAdditionElement, MemberQ[semiresolvedElement, #[[1]]]&],
						(* In the other case don't change *)
						semiresolvedStandardAdditionElement

					];

					(* Step 3 - resolve StandardAdditionCurve *)

					unresolvedStandardAdditionCurve = Lookup[options, StandardAdditionCurve];

					resolvedStandardAdditionCurve = Which[
						(* If StandardAdditionCurve is specified in lists of volumes, keep it as is *)
						MatchQ[unresolvedStandardAdditionCurve, ListableP[{VolumeP}]], unresolvedStandardAdditionCurve,
						(* If StandardAdditionCurve is set to Null, keep it as is *)
						NullQ[unresolvedStandardAdditionCurve], Null,
						(* If StandardAdditionCurve is specified in lists of dilution factor, convert dilution factor to sample volume *)
						MatchQ[unresolvedStandardAdditionCurve, ListableP[{_?NumericQ}]], resolvedSampleAmount * unresolvedStandardAdditionCurve,
						(* If StandardAdditionCurve is not specified, and StandardAddedSample is True, set to {{0 Milliliter}} *)
						resolvedStandardAddedSample, {{0 Milliliter}},
						(* If StandardAdditionCurve is not specified, and resolvedAdditionStandard is Null, set to Null *)
						MatchQ[unresolvedStandardAdditionCurve, Automatic] && NullQ[resolvedAdditionStandard], Null,
						(* If StandardAdditionCurve is not specified, and highest concentration of resolvedStandardAdditionElement is above 20 mg/l set to a list of 4 dilution factors such that highest concentration of the StandardAdditionElement becomes 0, 1, 3 and 10 mg/l *)
						MatchQ[unresolvedStandardAdditionCurve, Automatic] && Max[resolvedStandardAdditionElement[[All,2]]] > 20 Milligram/Liter,
						{
							{0 Milliliter},
							{(1 Milligram / Liter * resolvedSampleAmount) / (Max[resolvedStandardAdditionElement[[All, 2]]] - 1 Milligram / Liter)},
							{(3 Milligram / Liter * resolvedSampleAmount) / (Max[resolvedStandardAdditionElement[[All, 2]]] - 3 Milligram / Liter)},
							{(10 Milligram / Liter * resolvedSampleAmount) / (Max[resolvedStandardAdditionElement[[All, 2]]] - 10 Milligram / Liter)}
						},
						(* If StandardAdditionCurve is not specified, and highest concentration of resolvedStandardAdditionElement is below 20 mg/ml set to a list of 4 dilution factors such that Volume of AdditionStandard:Sample is 0, 0.2, 0.4, 1 *)
						MatchQ[unresolvedStandardAdditionCurve, Automatic] && Max[resolvedStandardAdditionElement[[All,2]]] <= 20 Milligram/Liter, resolvedSampleAmount*{{0},{0.2}, {0.4}, {1}},
						(* Any other case go to Null *)
						True, Null
					];

					(* Calculate the total sample volume. If there's no StandardAddition, use the sample volume; otherwise, add the highest volume from the resolvedStandardAdditionCurve as well *)
					(* Then, multiply by (1+guessedInternalStandardMixRatio) *)
					totalSampleVolume = If[NullQ[resolvedStandardAdditionCurve],
						resolvedSampleAmount,
						resolvedSampleAmount + Max[Flatten[resolvedStandardAdditionCurve]]
					] * (1 + guessedInternalStandardMixRatio);

					(* Check if total sample volume is greater than 15 ml. This is hard coded for now but may need to be improved. *)
					sampleVolumeOverflow = totalSampleVolume >= 15 Milliliter;

					(* Error checking Booleans for AdditionStandard *)

					(* Make sure that if StandardType is not set or resolved to StandardAddition, AdditionStandard should resolve to Null *)

					additionStandardPresenceError = (!MatchQ[resolvedStandardType, StandardAddition]) && (!MatchQ[resolvedAdditionStandard, Null]);

					(* Make sure that if StandardType is set or resolved to StandardAddition, AdditionStandard should not be set to Null unless StandardAddedSample is set to True *)

					additionStandardAbsenceError = MatchQ[unresolvedAdditionStandards, ListableP[{}|Null]] && MatchQ[resolvedStandardType, StandardAddition] && !resolvedStandardAddedSample;

					(* Make sure that the specified or resolved StandardAdditionElements covers every element that needs quantification *)
					(* However, skip test if no elements need to be quantified *)
					additionStandardFoundElements = If[MatchQ[resolvedStandardType, StandardAddition] && !MatchQ[needQuantificationElements, {}],
						resolvedStandardAdditionElement[[All, 1]],
						{}
					];

					additionStandardUnfoundElement = If[MatchQ[resolvedStandardType, StandardAddition] && !MatchQ[needQuantificationElements, {}],
						Complement[needQuantificationElements, additionStandardFoundElements],
						{}
					];

					noAvailableAdditionStandardQ = Length[additionStandardUnfoundElement] != 0;

					(* User should not specify StandardAdditionElements without specifying AdditionStandard. Throw error if user did that. Exclude if standardAddedSample -> True *)
					invalidStandardAdditionElementError = If[MatchQ[unresolvedAdditionStandard, Automatic|Null] && !MatchQ[unresolvedStandardAdditionElement, Automatic|Null] &&!resolvedStandardAddedSample,
						True,
						False
					];

					{
						(*1*)resolvedDigestion,
						(*2*)resolvedStandardAddedSample,
						(*3*)resolvedAdditionStandard,
						(*4*)resolvedStandardAdditionCurve,
						(*5*)resolvedStandardAdditionElement,
						(*6*)noDigestionError,
						(*7*)invalidStandardAdditionElementError,
						(*8*)noAvailableAdditionStandardQ,
						(*9*)resolvedSampleAmount,
						(*10*)additionStandardUnfoundElement,
						(*11*)sampleVolumeOverflow
					}

				]
			],
			{samplePackets, mapThreadFriendlyOptions}
		]
	];

	invalidSampleVolumeOptions = If[MemberQ[sampleVolumeOverflows, True] && messages,
		(
			Message[
				Error::SampleVolumeOverflow,
				ObjectToString[PickList[myInputSamples, sampleVolumeOverflows], Cache -> cacheBall]
			];
			{SampleAmount, StandardType, StandardAdditionCurve}
		),
		{}
	];

	invalidSampleVolumeTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, sampleVolumeOverflows];
			passingInputs = PickList[myInputSamples, sampleVolumeOverflows, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The sample volume of the following samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " do not exceed 15 ml after digestion and adding standard:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The sample volume of the following samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " do not exceed 15 ml after digestion and adding standard:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	invalidStandardAdditionElementOptions = If[MemberQ[invalidStandardAdditionElementErrors, True] && messages,
		(
			Message[
				Error::InvalidStandardAdditionElements,
				ObjectToString[PickList[myInputSamples, invalidStandardAdditionElementErrors], Cache -> cacheBall],
				PickList[unresolvedStandardAdditionElements, invalidStandardAdditionElementErrors]
			];
			{AdditionStandard, StandardAdditionElements}
		),
		{}
	];

	invalidStandardAdditionElementTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, invalidStandardAdditionElementErrors];
			passingInputs = PickList[myInputSamples, invalidStandardAdditionElementErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " if their AdditionStandard is not specified or specified to Null, then StandardAdditionElements must also be Automatic or Null:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " if their AdditionStandard is not specified or specified to Null, then StandardAdditionElements must also be Automatic or Null:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	noDigestionOptions = If[MemberQ[noDigestionErrors, True] && messages,
		(
			Message[
				Error::DigestionNeededForNonLiquid,
				ObjectToString[PickList[myInputSamples, noDigestionErrors], Cache -> cacheBall]
			];
			{Digestion}
		),
		{}
	];

	noDigestionTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, noDigestionErrors];
			passingInputs = PickList[myInputSamples, noDigestionErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " if they are non-liquid, Digestion must set to True:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " if they are non-liquid, Digestion must set to True:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	If[MemberQ[noAvailableAdditionStandardQs, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::NoAvailableAdditionStandard,
			ObjectToString[PickList[myInputSamples, noAvailableAdditionStandardQs],Cache->cacheBall],
			PickList[resolvedStandardAdditionElements, noAvailableAdditionStandardQs],
			PickList[additionStandardUnfoundElements, noAvailableAdditionStandardQs]
		]
	];

	noAvailableAdditionStandardWarning = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, noAvailableAdditionStandardQs];
			passingInputs = PickList[myInputSamples, noAvailableAdditionStandardQs, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " the specified or resolved AdditionStandard was able to cover all elements that need quantification:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " the specified or resolved AdditionStandard was able to cover all elements that need quantification:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	(* Resolve for InternalStandard *)

	(* Find out whether user has already specified InternalStandardElement. How to resolve InternalStandard depend on this *)
	(* Only case we consider as specified is that user has manually entered True for at least one element *)
	InternalStandardElementSpecifiedQ = MemberQ[ToList[unresolvedInternalStandardElements], True];

	(* Generates a list of elements for internal standard *)
	internalStandardNucleiList = DeleteCases[PickList[semiresolvedNuclei, semiresolvedInternalStandardElements], Sweep];
	internalStandardElementList = icpmsElementFromIsotopes[internalStandardNucleiList, Cache -> cacheBall];


	(* Find a pool of standards that do not contain any elements in the resolvedElements besides internalStandardElementList *)
	nonInternalStandardElementList = Complement[semiresolvedElement, internalStandardElementList];
	allInternalStandardElements = Select[allStandardElements, Intersection[nonInternalStandardElementList, #] == {}&];

	(* construct a complete list of elements that appears in everything other than input sample and InternalStandard *)
	allOtherSamples = Cases[Flatten[{resolvedExternalStandard, resolvedAdditionStandards, resolvedBlank, resolvedRinseSolution}], ObjectP[{Object[Sample], Model[Sample]}]];

	allOtherPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ allOtherSamples;

	allOtherElements = findICPMSElements[allOtherPackets, Elements -> All, Cache -> cacheBall];

	(* Please note that this list of elements is undesired, not strictly forbidden, unlike nonInternalStandardElementList *)
	allUndesiredElementsForInternalStandard = Join[allSampleElements, allOtherElements];


	(* Resolve for InternalStandard *)
	{semiResolvedInternalStandard, extraInternalStandardElement} = Which[
		(* If InternalStandard is specified or set to Null, keep it as is *)
		!MatchQ[unresolvedInternalStandard, Automatic], {unresolvedInternalStandard, {}},
		(* If InternalStandard is not specified, and internalStandardElementList is empty, call pickBestInternalStandard function to find suitable internal standard and element *)
		Length[internalStandardElementList] == 0, pickBestInternalStandard[allUndesiredElementsForInternalStandard, allInternalStandardElements],
		(* Instead, if internalStandardElementList is non-empty, run pickBestStandard to find a proper internal standard *)
		Length[internalStandardElementList] > 0, {Flatten[pickBestStandard[internalStandardElementList, allInternalStandardElements, MaxResults -> 1]], {}}
	];

	(* Correct the format for semiResolvedInternalStandard *)
	resolvedInternalStandard = Which[
		(* If semiResolvedInternalStandard is an empty list or list of Null, change to Null *)
		MatchQ[semiResolvedInternalStandard, {}], Null,
		NullQ[semiResolvedInternalStandard], Null,
		(* If semiResolvedInternalStandard is a list, resolve the standard object *)
		MatchQ[semiResolvedInternalStandard, _List], semiResolvedInternalStandard/.elementToStandardRules,
		(* All other case do not change *)
		True, semiResolvedInternalStandard
	];

	(* resolve the extra list of isotopes from InternalStandard to be added to Elements option *)
	extraInternalStandardNuclei = Quiet[
		ICPMSDefaultIsotopes[extraInternalStandardElement,
			Flatten -> True, Message -> True, IsotopeAbundanceThreshold -> resolvedIsotopeAbundanceThreshold,
			Instrument -> resolvedInstrument, Cache -> cacheBall
		],
		{ICPMSDefaultIsotopes::BelowThresholdIsotopesIncluded}
	];

	extraInternalStandardNucleiCount = Length[extraInternalStandardNuclei];
	(* resolve the extra options index-matched to extraInternalStandardNuclei *)

	(* extraPlasmaPowers: by default, set to Low for light nuclei and Normal for other ones *)
	extraPlasmaPowers = If[MatchQ[extraInternalStandardNuclei, ListableP[lowPowerIsotopes]],
		Table[Low, extraInternalStandardNucleiCount],
		Table[Normal, extraInternalStandardNucleiCount]
	];

	(* extraCollisionCellPressurizations: by Default, set to False *)
	extraCollisionCellPressurizations = Table[False, extraInternalStandardNucleiCount];

	(* extraCollisionCellGases: by Default, set to Null *)
	extraCollisionCellGases = Table[Null, extraInternalStandardNucleiCount];

	(* extraCollisionCellGasFlowRates: by default, set to 0 *)
	extraCollisionCellGasFlowRates = Table[0 Milliliter/Minute, extraInternalStandardNucleiCount];

	(* extraCollisionCellBiases: by default, set to False *)
	extraCollisionCellBiases = Table[False, extraInternalStandardNucleiCount];

	(* extraDwellTimes: by default, set to 1 ms *)
	extraDwellTimes = Table[1 Millisecond, extraInternalStandardNucleiCount];

	(* extraNumbersOfReads: by default, set to 1 *)
	extraNumbersOfReads = Table[1, extraInternalStandardNucleiCount];

	(* extraReadSpacings: by default, set to 0.1 g/mol *)
	extraReadSpacings = Table[0.1 Gram/Mole, extraInternalStandardNucleiCount];

	(* extraBandpasses: by default set to Normal *)
	extraBandpasses = Table[Normal, extraInternalStandardNucleiCount];

	(* extraInternalStandardElements: set to True *)
	extraInternalStandardElements = Table[True, extraInternalStandardNucleiCount];

	(* extraQuantifyConcentrations: set to False *)
	extraQuantifyConcentrations = Table[False, extraInternalStandardNucleiCount];

	(* Add extra options into the semi-resolved ones *)

	{
		resolvedPlasmaPowers,
		resolvedCollisionCellPressurizations, resolvedCollisionCellGases, resolvedCollisionCellGasFlowRates, resolvedCollisionCellBiases,
		resolvedDwellTimes, resolvedNumbersOfReads, resolvedReadSpacings, resolvedBandpasses, resolvedInternalStandardElements,
		resolvedQuantifyConcentrations, resolvedElement, resolvedNuclei
	} = MapThread[
		Join[#1, #2]&,
		{
			{
				semiresolvedPlasmaPowers, semiresolvedCollisionCellPressurizations, semiresolvedCollisionCellGases,
				semiresolvedCollisionCellGasFlowRates, semiresolvedCollisionCellBiases, semiresolvedDwellTimes,
				semiresolvedNumbersOfReads, semiresolvedReadSpacings, semiresolvedBandpasses, semiresolvedInternalStandardElements,
				semiresolvedQuantifyConcentrations, semiresolvedElement, semiresolvedNuclei
			},
			{
				extraPlasmaPowers, extraCollisionCellPressurizations, extraCollisionCellGases,
				extraCollisionCellGasFlowRates, extraCollisionCellBiases, extraDwellTimes,
				extraNumbersOfReads, extraReadSpacings, extraBandpasses, extraInternalStandardElements,
				extraQuantifyConcentrations, extraInternalStandardElement, extraInternalStandardNuclei
			}
		}
	];


	(* Error test on InternalStandard *)
	(* Return error if there's at least one internalStandardElement, but no resolvedInternalStandard *)
	noAvailableInternalStandardQ = Length[internalStandardElementList] >0 && NullQ[resolvedInternalStandard];

	noAvailableInternalStandardOptions = If[noAvailableInternalStandardQ && messages,
		(
			Message[
				Error::NoAvailableInternalStandard,
				internalStandardElementList
			];
			{InternalStandard, InternalStandardElement, Elements}
		),
		{}
	];

	noAvailableInternalStandardTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!noAvailableInternalStandardQ,
				Test["If InternalStandardElement is set to True for any element, an internal standard should be set or resolved:", True, True],
				Nothing
			];
			failingTest = If[noAvailableInternalStandardQ,
				Test["If InternalStandardElement is set to True for any element, an internal standard should be set or resolved:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		]
	];

	(* Return error if InternalStandard wasn't set to Null but resolved to Null. Exclude the case above *)
	unableToFindInternalStandardQ = !noAvailableInternalStandardQ && !NullQ[unresolvedInternalStandard] && NullQ[resolvedInternalStandard];

	unableToFindInternalStandardOptions = If[unableToFindInternalStandardQ && messages,
		(
			Message[
				Error::UnableToFindInternalStandard,
				internalStandardElementList
			];
			{InternalStandard}
		),
		{}
	];

	unableToFindInternalStandardTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing options *)
			passingTest = If[!unableToFindInternalStandardQ,
				Test["If InternalStandard is set to non-Null, it should not resolve into Null", True, True],
				Nothing
			];
			failingTest = If[unableToFindInternalStandardQ,
				Test["If InternalStandard is set to non-Null, it should not resolve into Null", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		]
	];


	(* Construct a list of elements present in resolvedInternalStandard *)
	elementInResolvedInternalStandard = If[NullQ[resolvedInternalStandard],
		{},
		(Values[findICPMSStandardElements[fetchPacketFromFastAssoc[resolvedInternalStandard, fastAssoc], Output -> Elements, Cache -> cacheBall]])[[1]]
	];

	(* Construct a list of Booleans to indicate whether each element in internalStandardElementList is not included in elementInResolvedInternalStandard, i.e. True = absent *)
	internalStandardAbsentElement = (!MemberQ[elementInResolvedInternalStandard, #]&)/@internalStandardElementList;

	(* Return error if internal standard do not contain all elements required by user *)

	internalStandardElementAbsentOptions = If[Or@@internalStandardAbsentElement && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InternalStandardElementAbsent,
				PickList[internalStandardElementList, internalStandardAbsentElement]
			];
			{InternalStandardElement, InternalStandard}
		)
	];

	internalStandardElementAbsentTest = If[gatherTests,
		Module[{passingElements, failingElements, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingElements = PickList[internalStandardElementList, internalStandardAbsentElement];
			passingElements = Complement[internalStandardElementList, failingElements];
			(* Create a test for passing options *)
			passingTest = If[Length[passingElements]>0,
				Warning["For all of these elements " <> ToString[passingElements] <> " which InternalStandardElement is set to True present in the InternalStandard:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["For all of these elements " <> ToString[failingElements] <> " which InternalStandardElement is set to True present in the InternalStandard:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Return error if any element present in InternalStandard had option QuantifyConcentration -> True *)
	internalStandardUnwantedElementOptions = If[Intersection[needQuantificationElements, elementInResolvedInternalStandard] != {} && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InternalStanardUnwantedElement,
				Intersection[needQuantificationElements, elementInResolvedInternalStandard]
			];
			{InternalStandard}
		)
	];

	internalStandardUnwantedElementTest = If[gatherTests,
		Module[{passingElements, failingElements, passingTest, failingTest},
			(* Get the options that pass the test *)
			failingElements = Intersection[needQuantificationElements, elementInResolvedInternalStandard];
			passingElements = Complement[elementInResolvedInternalStandard, failingElements];
			(* Create a test for passing options *)
			passingTest = If[Length[passingElements]>0,
				Warning["For all of these elements " <> ToString[passingElements] <> " which InternalStandardElement is set to True present in the InternalStandard:", True, True],
				Nothing
			];
			failingTest = If[Length[failingOptions]>0,
				Warning["For all of these elements " <> ToString[failingElements] <> " which InternalStandardElement is set to True present in the InternalStandard:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	(* Resolve for InternalStandardMixRatio *)

	resolvedInternalStandardMixRatio = Which[
		(* If option specified, do not change *)
		!MatchQ[unresolvedInternalStandardMixRatio, Automatic], unresolvedInternalStandardMixRatio,
		(* If not specified, and if InternalStandard set or resolved to Null, set to 0 *)
		NullQ[resolvedInternalStandard], 0,
		(* Otherwise if InternalStandard is set or resolved to some object, set to 1/9 *)
		MatchQ[resolvedInternalStandard, ObjectP[]], 0.111,
		(* All other cases set to 0 *)
		True, 0
	];

	(* Error checking *)
	(* Return error if InternalStandard is not Null but mix ratio set to 0 *)
	internalStandardZeroVolumeOptions = If[!NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio == 0,
		(
			Message[
				Error::InternalStandardInvalidVolume,
				ObjectToString[resolvedInternalStandard, Cache -> cacheBall], 0
			];
			{InternalStandard, InternalStandardMixRatio}
		),
		{}
	];
	(* Simillarly, return error if InternalStandard is Null but mix ratio set to non-0 *)
	internalStandardInvalidVolumeOptions = If[NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio > 0,
		(
			Message[
				Error::InternalStandardInvalidVolume,
				"Nothing", resolvedInternalStandardMixRatio
			];
			{InternalStandard, InternalStandardMixRatio}
		),
		{}
	];

	internalStandardZeroVolumeTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing case *)
			passingTest = If[NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio == 0,
				Test["If InternalStandard is set or resolved to Null, InternalStandardMixRatio should be 0:", True, True],
				Nothing
			];
			failingTest = If[NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio > 0,
				Test["If InternalStandard is set or resolved to Null, InternalStandardMixRatio should be 0:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];

	internalStandardInvalidVolumeTest = If[gatherTests,
		Module[{passingTest, failingTest},
			(* Create a test for passing case *)
			passingTest = If[!NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio > 0,
				Test["If InternalStandard is set or resolved to non-Null, InternalStandardMixRatio should be non-zero:", True, True],
				Nothing
			];
			failingTest = If[!NullQ[resolvedInternalStandard] && resolvedInternalStandardMixRatio == 0,
				Test["If InternalStandard is set or resolved to non-Null, InternalStandardMixRatio should be non-zero:", True, False],
				Nothing
			];

			(* Return the created tests *)
			{passingTest, failingTest}
		],
		{}
	];



	(* OK here's what's going on *)
	(* 1. We need to split samples into two groups based on whether it needs digestion or not *)
	(* 2. For the list of samples which needs digestion, call ExperimentMicrowaveDigestion to resolve all options *)
	(* 3. For the other group we do nothing *)
	(* 4. We then need to combine them together and make sure the order is correct to get the resolved Options *)
	(* 5. We also do the same thing on resolveAliquotOptions since depending whether we digest or not, different volume of sample needs to be transfered *)

	(* Split samples according to whether it needs digestion *)
	{samplesToDigest, samplesToNotDigest} = {
		PickList[myInputSamples, resolvedDigestions],
		PickList[myInputSamples, resolvedDigestions, False]
	};

	{simulatedSamplesToDigest, simulatedSamplesToNotDigest} = {
		PickList[simulatedSamples, resolvedDigestions],
		PickList[simulatedSamples, resolvedDigestions, False]
	};

	(* Split digestion-related options in the same way, however for not digest ones, set all options to Null *)
	{optionsToDigest, optionsToNotDigest} = {
		PickList[mapThreadFriendlyDigestionOptions, resolvedDigestions],
		ConstantArray[AssociationMap[Function[{var}, Null], digestionOptionNames], Length[samplesToNotDigest]]
	};

	(* Split aliquot-related options in the same way *)
	{aliquotOptionsToDigest, aliquotOptionsToNotDigest} = {
		PickList[mapThreadFriendlyAliquotOptions, resolvedDigestions],
		PickList[mapThreadFriendlyAliquotOptions, resolvedDigestions, False]
	};

	(* Split SampleAmount option in the same way, need this information to resolve Aliquot options *)
	{sampleAmountToDigest, sampleAmountToNotDigest} = {
		PickList[resolvedSampleAmounts, resolvedDigestions],
		PickList[resolvedSampleAmounts, resolvedDigestions, False]
	};

	(* Get the only non-index-matched digestion-related option, which is DigestionInstrument *)
	unresolvedDigestionInstrument = Lookup[roundedOptionsAssociation, DigestionInstrument];

	(* For other digestion ones, construct a list of options, collapse index-matched ones and replace option names *)
	preresolvedDigestionOptions = Flatten[{
		Map[
			# -> Lookup[optionsToDigest, #, {}]&,
			digestionOptionNames
		],
		Instrument -> unresolvedDigestionInstrument
	}]/.digestionOptionNamesMigrationRules;

	(* resolve the options *)
	(* Note: Since I need to call ExperimentMicrowaveDigestion for simulation, I could instead just do it here to save time *)
	{allResolvedDigestionOptions, digestionSimulation, digestionOptionsTests} = Which[
		(* If no samples to digest, output empty set *)
		MatchQ[samplesToDigest, {}], {{},Simulation[],{}},
		(* Otherwise, launch ExperimentMicrowaveDigestion function to resolve the options *)
		gatherTests, ExperimentMicrowaveDigestion[samplesToDigest, Sequence@@preresolvedDigestionOptions, Output -> {Options, Simulation, Tests}, Simulation -> updatedSimulation],
		True, Append[ExperimentMicrowaveDigestion[samplesToDigest, Sequence@@preresolvedDigestionOptions, Output -> {Options, Simulation}, Simulation -> updatedSimulation],{}]
	];

	(* Update simulation with simulation from microwave digestion *)
	simulationWithMicrowaveDigestion = UpdateSimulation[updatedSimulation, digestionSimulation];

	(* Only pick the options listed in digestionOptionNames and make it MapThreadFriendly again *)
	allResolvedDigestionOptionsSelected= If[MatchQ[allResolvedDigestionOptions, {}],
		{},
		OptionsHandling`Private`mapThreadOptions[ExperimentICPMS, Select[allResolvedDigestionOptions/.digestionOptionNamesReverseMigrationRules, MemberQ[(digestionOptionNames), Keys[#]]&]]
	];

	resolvedDigestionInstrument = Lookup[allResolvedDigestionOptions, Instrument, Null];

	(* Merge options for digest and not digest samples *)

	combinedMapThreadFriendlyDigestionOptions = RiffleAlternatives[allResolvedDigestionOptionsSelected, optionsToNotDigest, resolvedDigestions];

	(* combine all options *)

	resolvedDigestionOptions = Join[Normal[Merge[combinedMapThreadFriendlyDigestionOptions, Join]], {DigestionInstrument -> resolvedDigestionInstrument}];


	(* Construct Primitives for Digestion *)
	digestionPrimitives = If[Length[samplesToDigest]>0,
		MicrowaveDigestion[Join[
			<|
				Sample -> samplesToDigest,
				Instrument -> resolvedDigestionInstrument
			|>,
			Association @@ (Select[allResolvedDigestionOptions, MemberQ[(digestionOptionNames/.digestionOptionNamesMigrationRules), Keys[#]]&])
		]]
	];



	(* Construct list of options and collapse index-matched ones for aliquot options separately for digesting and non-digesting samples *)
	preresolvedAliquotOptionsToDigest = Flatten[{
		Map[
			# -> Lookup[aliquotOptionsToDigest, #, {}]&,
			samplePrepOptionNames
		]
	}];

	preresolvedAliquotOptionsToNotDigest = Flatten[{
		Map[
			# -> Lookup[aliquotOptionsToNotDigest, #, {}]&,
			samplePrepOptionNames
		]
	}];

	preresolvedAliquotOptions = Flatten[{
		Map[
			# -> Lookup[unresolvedAliquotOptions, #, {}]&,
			samplePrepOptionNames
		]
	}];

	requiredAliquotAmounts = RiffleAlternatives[Table[Null, Length[samplesToDigest]], sampleAmountToNotDigest, resolvedDigestions];

	requiredAliquotContainers = RiffleAlternatives[Table[Automatic, Length[samplesToDigest]], Table[Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *), Length[samplesToNotDigest]], resolvedDigestions];

	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentICPMS,
			myInputSamples,
			simulatedSamples,
			preresolvedAliquotOptions,
			(* For samples with Digestion -> True, RequiredAliquotAmounts can be Null *)
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			(* For samples with Digestion -> True, RequiredAliquotContainers can be Automatic *)
			RequiredAliquotContainers -> requiredAliquotContainers,
			(* For samples with Digestion -> True, allow solids *)
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> simulationWithMicrowaveDigestion,
			Output -> {Result, Tests},
			AliquotWarningMessage -> "because the given samples are not compatible with ICPMS instrument or microwave digestion instrument."
		],
		{resolveAliquotOptions[
			ExperimentICPMS,
			myInputSamples,
			simulatedSamples,
			preresolvedAliquotOptions,
			(* For samples with Digestion -> True, RequiredAliquotAmounts can be Null *)
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			(* For samples with Digestion -> True, RequiredAliquotContainers can be Automatic *)
			RequiredAliquotContainers -> requiredAliquotContainers,
			(* For samples with Digestion -> True, allow solids *)
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> simulationWithMicrowaveDigestion,
			Output -> Result,
			AliquotWarningMessage -> "because the given samples are not compatible with ICPMS instrument or microwave digestion instrument."
		],{}}
	];
	(* All options index-matched to Elements must also be changed *)
	(* The reason is data from survey scans are very different from main scans so in parser they have to be treated differently *)
	(* And if we make sure that Sweep is the last member of Elements everything will be much simpler than if Sweep can be anywhere *)

	sweepPart = If[MemberQ[resolvedNuclei, Sweep],
		First[FirstPosition[resolvedNuclei, Sweep]],
		0
	];


	(* Gather all options. Still need to round it before output *)
	preroundresolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Instrument -> resolvedInstrument,
			Elements -> toEndOrNoAction[resolvedNuclei, sweepPart],
			StandardType -> resolvedStandardType,
			PlasmaPower -> toEndOrNoAction[resolvedPlasmaPowers, sweepPart],
			CollisionCellPressurization -> toEndOrNoAction[resolvedCollisionCellPressurizations, sweepPart],
			CollisionCellGas -> toEndOrNoAction[resolvedCollisionCellGases, sweepPart],
			CollisionCellGasFlowRate -> toEndOrNoAction[resolvedCollisionCellGasFlowRates, sweepPart],
			CollisionCellBias -> toEndOrNoAction[resolvedCollisionCellBiases, sweepPart],
			DwellTime -> toEndOrNoAction[resolvedDwellTimes, sweepPart],
			NumberOfReads -> toEndOrNoAction[resolvedNumbersOfReads, sweepPart],
			ReadSpacing -> toEndOrNoAction[resolvedReadSpacings, sweepPart],
			Bandpass -> toEndOrNoAction[resolvedBandpasses, sweepPart],
			InternalStandardElement -> toEndOrNoAction[resolvedInternalStandardElements, sweepPart],
			QuantifyConcentration -> toEndOrNoAction[resolvedQuantifyConcentrations, sweepPart],
			ExternalStandard -> resolvedExternalStandard,
			StandardDilutionCurve -> resolvedStandardDilutionCurves,
			ExternalStandardElements -> resolvedExternalStandardElements,
			Blank -> resolvedBlank,
			Rinse -> resolvedRinse,
			RinseSolution -> resolvedRinseSolution,
			RinseTime -> resolvedRinseTime,
			InjectionDuration -> resolvedInjectionDuration,
			ConeDiameter -> resolvedConeDiameter,
			InternalStandard -> resolvedInternalStandard,
			InternalStandardMixRatio -> resolvedInternalStandardMixRatio,
			IsotopeAbundanceThreshold -> resolvedIsotopeAbundanceThreshold,
			Digestion -> resolvedDigestions,
			MinMass -> resolvedMinMass,
			MaxMass -> resolvedMaxMass,
			StandardAddedSample -> resolvedStandardAddedSamples,
			AdditionStandard -> resolvedAdditionStandards,
			StandardAdditionCurve -> resolvedStandardAdditionCurves,
			StandardAdditionElements -> resolvedStandardAdditionElements,
			resolvedSamplePrepOptions,
			resolvedDigestionOptions,
			resolvedAliquotOptions
		}]
	];

	resolvedOptions = Normal[RoundOptionPrecision[Association[preroundresolvedOptions],
		{
			StandardDilutionCurve,
			StandardAdditionCurve,
			InternalStandardMixRatio
		},
		{
			0.1 Microliter,
			0.1 Microliter,
			0.001
		}
	]];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, nonLiquidNonSolidSampleInvalidInputs}]];

	(* gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		collisionCellBiasOnlyOptions,
		collisionCellGasOptions,
		collisionCellGasFlowRateOptions,
		AttemptToQuantifySweepOptions,
		quantifyInternalStandardElementOptions,
		externalStandardPresenceOptions,
		externalStandardAbsenceOptions,
		invalidExternalStandardElementOptions,
		invalidRinseOptions,
		unableToFindInternalStandardOptions,
		internalStandardZeroVolumeOptions,
		internalStandardInvalidVolumeOptions,
		minMaxMassInversionOptions,
		missingMassRangeOptions,
		invalidMassRangeOptions,
		invalidStandardAdditionElementOptions,
		noDigestionOptions,
		unableToFindInternalStandardOptions,
		noAvailableInternalStandardOptions,
		standardUnnecessaryOptions,
		noAbundantIsotopeForQuantificationOptions,
		multipleGasOptions,
		invalidSampleVolumeOptions,
		invalidStandardVolumeOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];


	(* gather all tests *)
	allTests = Cases[Flatten[{
		discardedTest,
		missingVolumeTest,
		missingMassTest,
		nonLiquidNonSolidSampleTest,
		roundingTests,
		abundantIsotopeTest,
		quantifyInternalStandardElementTest,
		collisionCellBiasOnlyTest,
		collisionCellGasTest,
		internalStandardElementTest,
		sweepQuantificationWarningTest,
		collisionCellGasFlowRateTest,
		standardUnnecessaryTest,
		standardNecessaryTest,
		externalStandardPresenceTest,
		externalStandardAbsenceTest,
		noAvailableExternalStandardTest,
		invalidExternalStandardTest,
		invalidRinseTest,
		invalidRinseOptionsTest,
		unableToFindInternalStandardTest,
		internalStandardElementAbsentTest,
		internalStandardUnwantedElementTest,
		internalStandardZeroVolumeTest,
		internalStandardInvalidVolumeTest,
		minMaxMassInversionTest,
		massRangeNarrowTest,
		missingMassRangeTest,
		invalidMassRangeTest,
		unableToFindInternalStandardTest,
		noAvailableInternalStandardTest,
		noInternalStandardElementTest,
		multipleGasTest,
		invalidSampleVolumeTest,
		invalidStandardVolumeTest
	}],TestP];


	outputSpecification /. {Result -> {resolvedOptions, simulationWithMicrowaveDigestion, digestionPrimitives}, Tests -> allTests}


];

(* ::Subsubsection:: *)
(*icpmsResourcePackets*)

DefineOptions[
	icpmsResourcePackets,
	Options:>{HelperOutputOption, CacheOption, SimulationOption}
];

icpmsResourcePackets[mySamples:{ObjectP[Object[Sample]]...},myUnresolvedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..}, ops:OptionsPattern[]]:=Module[
	{
		allResourceBlobs, cache, checkpoints, containersIn, dwellTimes, expandedInputs,
		expandedResolvedOptions, finalizedPacket, frqTests, fulfillable, gatherTests, instrumentDownload, instrumentModel, instrumentSetupTime, messages,
		numberOfContainersInvolved, numberOfReplicates, optionsRule,
		optionsWithReplicates, output, outputSpecification, previewRule,resolvedOptionsNoHidden, resourcePickingTime, resultRule,
		sampleContainers,sampleDownload, sampleObjects,sampleResourceLookup, sampleRunTime, samplesInResources,
		samplesWithReplicates, sharedFieldPacket, testsRule, modelStandards, objectStandards, modelStandardsDownload, objectStandardsDownload,
		collisionCellGas, collisionCellGasFlowRate, coneDiameter, numberOfReading, collisionCellPressurization, icpmsPacket, standardType,
		standardAdditionQ, standardAdditionMultiplicity, standardAdditionCurve, sampleAmount, sampleDigestionAmount, digestion, aliquotAmountsWithReplicates, amountPerSample,
		blank, blankResource, rinse, rinseSolution, rinseTime, rinseCount, externalStandard, rinseVolume, rinseResource, finalSampleAmount,
		blankVolume, additionStandard, additionStandardVolumes, volumePerAdditionStandard, additionStandardResourceLookup, additionStandardResources,
		standardAddedSample, standardSpikedSamplesAdditionStandard, standardAdditionElements, standardSpikedSamplesUploadable, externalStandardQ,
		externalStandardVolumes, standardDilutionCurve, volumePerExternalStandard, externalStandardResourceLookup, externalStandardResources,
		standardSpikedSampleStandardVolume, standardSpikedSamplesSampleVolume, standardSpikedSamplesTotalVolume, standardSpikedSamplesBlankVolume,
		standardSpikedSamplesTotalVolumes, standardSpikedSamplesPreDilutionSample, externalStandardMultiplicity, externalStandardPreDilutionSample,
		externalStandardStandardVolume, externalStandardBlankVolume, externalStandardUploadable, internalStandardQ, internalStandard, internalStandardVolume,
		internalStandardMixRatio, internalStandardResource, internalStandardUploadable, injectionDuration, runTimePerSample, elements,
		icpmsInstrumentResource, externalStandardElementsElement, externalStandardRatio, externalStandardElements, externalStandardElementsConcentration,
		externalStandardElementsMultiplied, externalStandardElementsUploadable, externalStandardLabel, externalStandardElementsLabel,
		standardAdditionElementsElements, standardAdditionElementsConcentration, standardAdditionElementsLabel, standardSpikedSamplesLabel,
		standardAdditionElementsUploadable, standardAdditionElementsElementsUnflattened, sampleResourceLookupUnidirection, samplesInResourcesUnidirection,
		simulationResourcePacket, coneObject, cone, standardSpikedSamplesContainer, externalStandardContainer,
		cctPres, cctBias, plasmaPower, needSTD, needKED, needCCT, needColdIons, measurementMethod, tuningStandardVolume, tuningStandard,
		externalstandardLabelToPreDilutionSample, externalStandardElementsStandard, externalStandardElementsStandardConcentration,
		standardSpikedSamplesLabelToPreDilutionSample, standardAdditionElementsStandard, standardAdditionElementsStandardConcentration,
		icpmsSampleContainers, standards, sweep, sweepParameters, elementsRelatedOptions, sweepOptions, rinseTimeForCalculation,
		blankDiluentResource, collisionCellGasSingle
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get our cache. *)
	cache=OptionValue[Cache];

	simulationResourcePacket = OptionValue[Simulation];

	(* Determine if we need to make replicate spots *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null -> 1};

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentICPMS, {mySamples}, myResolvedOptions];

	(* Do not repeat the inputs and options even if we have replicates; just have the instrument collect multiple scans *)
	{samplesWithReplicates,optionsWithReplicates} = {mySamples, myResolvedOptions};

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentICPMS,
		RemoveHiddenOptions[ExperimentICPMS, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* --- SET-UP DOWNLOAD --- *)

	(*get the ICPMS instrument model *)
	instrumentModel=If[MatchQ[Lookup[myResolvedOptions,Instrument],ObjectP[Object[Instrument]]],
		Download[Lookup[fetchPacketFromCache[Download[Lookup[myResolvedOptions,Instrument],Object],cache],Model],Object],
		Download[Lookup[myResolvedOptions,Instrument],Object]
	];

	(* Get the standard objects *)
	standards = Download[
		DeleteCases[Flatten[Lookup[optionsWithReplicates, {InternalStandard, AdditionStandard, ExternalStandard}]], Null],
		Object
	];

	(* Separate the standards into groups of model and objects *)
	modelStandards = Cases[standards, ObjectP[Model[Sample]]];
	objectStandards = Cases[standards, ObjectP[Object[Sample]]];

	(* --- SET-UP DOWNLOAD --- *)
	(* Download info needed to make packets *)
	{
		(*1*)sampleDownload,
		(*2*)instrumentDownload,
		(*3*)modelStandardsDownload,
		(*4*)objectStandardsDownload
	} = Quiet[
		Download[
			{
				(*1*)samplesWithReplicates,
				(*2*){instrumentModel},
				(*3*)modelStandards,
				(*4*)objectStandards
			},
			{
				(*1*){Object, Container[Object]},
				(*2*){SupportedElements},
				(*3*){Object},
				(*4*){Object, Model}
			},
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* - Extract downloaded values into relevant variables - *)
	(* sample related *)
	sampleObjects = sampleDownload[[All,1]];
	sampleContainers=sampleDownload[[All,2]];

	(* Lookup options needed below *)

	{
		(*1*)collisionCellGas,
		(*2*)collisionCellGasFlowRate,
		(*3*)coneDiameter,
		(*4*)dwellTimes,
		(*5*)numberOfReading,
		(*6*)collisionCellPressurization,
		(*7*)standardType,
		(*8*)standardAdditionCurve,
		(*9*)sampleAmount,
		(*10*)sampleDigestionAmount,
		(*11*)digestion,
		(*12*)standardDilutionCurve,
		(*13*)standardAddedSample,
		(*14*)standardAdditionElements,
		(*15*)injectionDuration,
		(*16*)elements,
		(*17*)externalStandardElements
	} = Lookup[
		optionsWithReplicates,
		{
			(*1*)CollisionCellGas,
			(*2*)CollisionCellGasFlowRate,
			(*3*)ConeDiameter,
			(*4*)DwellTimes,
			(*5*)NumberOfReading,
			(*6*)CollisionCellPressurization,
			(*7*)StandardType,
			(*8*)StandardAdditionCurve,
			(*9*)SampleAmount,
			(*10*)SampleDigestionAmount,
			(*11*)Digestion,
			(*12*)StandardDilutionCurve,
			(*13*)StandardAddedSample,
			(*14*)StandardAdditionElements,
			(*15*)InjectionDuration,
			(*16*)Elements,
			(*17*)ExternalStandardElements
		}
	];

	(* Find out whether StandardType is StandardAddition *)
	standardAdditionQ = MatchQ[standardType, StandardAddition];

	(* If doing StandardAddition, multiple identical samples is needed for each input *)
	(* Find out how many points of StandardAdditionCurve per input sample *)
	standardAdditionMultiplicity = Which[
		(* If StandardType is not StandardAddition, set to a list of 1 index matched to sampleObjects *)
		!standardAdditionQ, Table[1, Length[sampleObjects]],
		(* If StandardAdditionCurve is a list of list of list, read its length per second-level list *)
		Depth[standardAdditionCurve] == 5, Length/@(standardAdditionCurve/.<|Null -> {{}}|>),
		(* All other cases set to a list of 1 index matched to sampleObjects *)
		True, Table[1, Length[sampleObjects]]
	];

	(* Determine how much amount we need for each sample *)
	(* Essentially, for samples need Digestion, we look for SampleDigestionAmount *)
	(* For sample doesn't need Digestion, we look for SampleAmount *)
	aliquotAmountsWithReplicates = MapThread[
		If[#1,
			#2[[1]],
			#2[[2]]
		]&,
		{digestion, Transpose[{sampleDigestionAmount, sampleAmount}]}
	];

	(* Then, consider the effect of StandardAddition, sample amount need to be multiplied by standardAdditionMultiplicity *)
	finalSampleAmount = MapThread[#1 * #2&, {aliquotAmountsWithReplicates, standardAdditionMultiplicity}];

	(* Finally, we merge the amount needed for the same sample *)
	amountPerSample = Merge[MapThread[<|#1->#2|>&,{sampleObjects,finalSampleAmount}],Total];

	(* Create a lookup linking each unique sample to its resource *)
	sampleResourceLookup=KeyValueMap[
		If[!VolumeQ[#2] && !MassQ[#2],
			#1->Link[Resource[Sample->#1,Name->ToString[#1]], Protocols],
			#1->Link[Resource[Sample->#1,Amount->#2,Name->ToString[#1]], Protocols]
		]&,
		amountPerSample
	];

	(* Create a uni-directional version for StandardSpikedSamples *)
	sampleResourceLookupUnidirection=KeyValueMap[
		If[!VolumeQ[#2] && !MassQ[#2],
			#1->Link[Resource[Sample->#1,Name->ToString[#1]]],
			#1->Link[Resource[Sample->#1,Amount->#2,Name->ToString[#1]]]
		]&,
		amountPerSample
	];

	(* Get list of resources index-matched to the input samples - this is expanded according to NumberOfReplicates *)
	samplesInResources=Lookup[sampleResourceLookup,sampleObjects];

	(* Get unidirection link version *)
	samplesInResourcesUnidirection=Lookup[sampleResourceLookupUnidirection,sampleObjects];

	(* Get containers involved *)
	containersIn=DeleteDuplicates[sampleContainers];

	(* Get AdditionStandard object *)
	additionStandard = If[standardAdditionQ,
		Download[Lookup[optionsWithReplicates, AdditionStandard], Object]
	];

	(* Calculate how much volume needed for AdditionStandard *)
	additionStandardVolumes = If[standardAdditionQ,
		Total[Flatten[#]]&/@(standardAdditionCurve/.<|Null -> {{0 Milliliter}}|>),
		0 Milliliter
	];

	(* We merge the the volume needed for the same addition standard *)
	volumePerAdditionStandard = If[standardAdditionQ,
		Merge[MapThread[<|#1->#2|>&,{additionStandard,additionStandardVolumes}],Total]
	];

	(* Create a lookup linking each unique addition standard to its resource *)
	additionStandardResourceLookup = If[standardAdditionQ,
		KeyValueMap[
			If[NullQ[#1],
				Null -> Null,
				#1 -> Link[Resource[Sample -> #1, Name -> ToString[#1], Amount -> #2]]
			]&,
			volumePerAdditionStandard
		],
		{}
	];

	(* Get list of resources index-matched to the input samples - this is expanded according to NumberOfReplicates *)
	additionStandardResources = If[standardAdditionQ,
		Lookup[additionStandardResourceLookup,additionStandard, Null],
		Null
	];

	(* Construct the list of all info needed for StandardSpikedSamples field *)

	(* AdditionStandard field of StandardSpikedSamples. Replicate additionStandardResources to match standardAdditionMultiplicity for each sample *)
	standardSpikedSamplesAdditionStandard = If[standardAdditionQ,
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{additionStandardResources, standardAdditionMultiplicity}
			]
		]
	];

	(* Sample field of StandardSpikedSamples. Replicate samplesInResources to match standardAdditionMultiplicity for each sample *)
	standardSpikedSamplesPreDilutionSample = If[standardAdditionQ,
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{samplesInResourcesUnidirection, standardAdditionMultiplicity}
			]
		]
	];


	(* StandardVolume field of StandardSpikedSamples *)
	standardSpikedSampleStandardVolume = If[NullQ[standardAdditionCurve],
		{Null},
		Flatten[standardAdditionCurve]
	];

	(* SampleVolume field of StandardSpikedSamples *)
	standardSpikedSamplesSampleVolume = Which[
		standardAdditionQ && !NullQ[standardAdditionCurve],
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{sampleAmount, standardAdditionMultiplicity}
			],
			1
		],
		standardAdditionQ, Table[Null, Total[standardAdditionMultiplicity]],
		True, Null
	];

	(* Calculate total volume for each SamplesIn *)
	standardSpikedSamplesTotalVolume = If[standardAdditionQ && !NullQ[standardAdditionCurve],
		MapThread[#1 + Max[#2/.{Null -> 0 Milliliter}]&, {sampleAmount, standardAdditionCurve}],
		sampleAmount
	];

	(* Expand total volumes by standardAdditionMultiplicity to index-match the StandardSpikedSamples *)
	standardSpikedSamplesTotalVolumes = Flatten[Join[
		MapThread[
			Table[#1, #2]&,
			{standardSpikedSamplesTotalVolume, standardAdditionMultiplicity}
		]
	]];

	standardSpikedSamplesBlankVolume = If[standardAdditionQ,
		MapThread[
			If[NullQ[#1],
				0 Milliliter,
				#3-#2-#1
			]&,
			{standardSpikedSampleStandardVolume, standardSpikedSamplesSampleVolume, standardSpikedSamplesTotalVolumes}
		]
	];

	(* Make labels for StandardSpikedSamples *)
	standardSpikedSamplesLabel = If[standardAdditionQ,
		MapThread[#1 <> #2&,
			{
				Table["Sample ", Total[standardAdditionMultiplicity]],
				ToString/@Range[1, Total[standardAdditionMultiplicity]]
			}
		]
	];

	(* Populate Container field for StandardSpikedSamples *)
	standardSpikedSamplesContainer = If[standardAdditionQ,
		Table[Link[Resource[Sample -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *)]], Total[standardAdditionMultiplicity]]
	];

	standardSpikedSamplesUploadable = If[standardAdditionQ,
		MapThread[
			Function[{standard, preDilSpl, stdVolume, splVolume, blkVolume, label, container},
				Association[
					AdditionStandard -> standard,
					PreDilutionSample -> preDilSpl,
					StandardVolume -> stdVolume,
					SampleVolume -> splVolume,
					BlankVolume -> blkVolume,
					Sample -> Null,
					Container -> container,
					Label -> label,
					Data -> Null
				]
			],
			{standardSpikedSamplesAdditionStandard, standardSpikedSamplesPreDilutionSample, standardSpikedSampleStandardVolume, standardSpikedSamplesSampleVolume,standardSpikedSamplesBlankVolume, standardSpikedSamplesLabel, standardSpikedSamplesContainer}
		]
	];

	(* Elements field of StandardAdditionElements. Replicate StandardAdditionElements to match standardAdditionMultiplicity for each sample *)
	standardAdditionElementsElementsUnflattened = Which[
		standardAdditionQ && !NullQ[standardAdditionElements],
		Flatten[
			MapThread[
				Table[#1[[All, 1]], #2]&,
				{standardAdditionElements, standardAdditionMultiplicity}
			],
			1
		],
		standardAdditionQ, Table[Null, Total[standardAdditionMultiplicity]],
		True, Null
	];

	standardAdditionElementsElements = If[standardAdditionQ && !NullQ[standardAdditionElements],
		Flatten[standardAdditionElementsElementsUnflattened],
		standardAdditionElementsElementsUnflattened
	];

	(* Concentration field of StandardAdditionElements. Calculate from original concentration and StandardDilutionCurve. For samples with StandardAddedSample -> True, use original concentration *)
	standardAdditionElementsConcentration = Which[
		standardAdditionQ && !NullQ[standardAdditionElements],
		Flatten[
			MapThread[
				Function[{concentration, additionCurve, standardAddedSampleQ, sampleVolume},
					If[standardAddedSampleQ,
						{concentration},
						(* Multiply StandardAdditionCurve into original concentration *)
						Module[{dilutionFactor},
							(* convert StandardDilutionCurve into dilution factors *)
							dilutionFactor = (#/(#+sampleVolume))&/@Flatten[additionCurve];
							(* Calculate concentration after dilution*)
							concentration * #&/@dilutionFactor
						]
					]
				],
				{standardAdditionElements[[All, All, 2]], standardAdditionCurve, standardAddedSample, sampleAmount}
			]
		],
		standardAdditionQ, Table[Null, Total[standardAdditionMultiplicity]],
		True, Null
	];

	(* Make labels for StandardAdditionElements *)
	standardAdditionElementsLabel = If[standardAdditionQ && !NullQ[standardAdditionElements],
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{standardSpikedSamplesLabel, Length/@standardAdditionElementsElementsUnflattened}
			]
		]
	];


	(* Construct an association pointing from externalStandardLabel to externalStandardPreDilutionSample *)
	standardSpikedSamplesLabelToPreDilutionSample = If[standardAdditionQ,
		Association @@ MapThread[#1 -> #2&, {standardSpikedSamplesLabel, standardSpikedSamplesAdditionStandard}],
		<||>
	];
	(* find the Standard field of ExternalStandardElements field *)
	standardAdditionElementsStandard = standardAdditionElementsLabel /. standardSpikedSamplesLabelToPreDilutionSample;
	(* find the StandardConcentration field of ExternalStandardElements field *)
	standardAdditionElementsStandardConcentration = If[standardAdditionQ && !NullQ[standardAdditionElements],
		(* Replicate the concentration part of ExternalStandardElements by externalStandardMultiplicity, then multiply by externalStandardRatio *)
		Flatten[MapThread[Table[#1, #2]&,{standardAdditionElements[[All, All, 2]], standardAdditionMultiplicity}]],
		{}
	];


	standardAdditionElementsUploadable = If[standardAdditionQ && !NullQ[standardAdditionElements],
		MapThread[
			Association[
				Element -> #1,
				Sample -> Null,
				Label -> #3,
				Concentration -> #2,
				Standard -> #4,
				StandardConcentration -> #5
			]&,
			{standardAdditionElementsElements, standardAdditionElementsConcentration, standardAdditionElementsLabel, standardAdditionElementsStandard, standardAdditionElementsStandardConcentration}
		]
	];

	(* If doing StandardAddition, samples will be mixed with standards so no extra containers needed *)
	(* Otherwise 15 mL Tube needed for each input samples *)
	icpmsSampleContainers = If[standardAdditionQ,
		{},
		Table[Link[Resource[Sample -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *)]], Length[samplesWithReplicates]]
	];



	(* Construct resource for ExternalStandard *)

	(* Define a Boolean variable to indicate if we do External Standard, for convinience *)
	externalStandardQ = MatchQ[standardType, External];

	(* Get ExternalStandard object *)
	externalStandard = If[externalStandardQ,
		Download[Lookup[optionsWithReplicates, ExternalStandard], Object]
	];

	(* Calculate how much volume needed for ExternalStandard *)
	externalStandardVolumes = If[externalStandardQ,
		Total[Flatten[#[[All, 1]]]]&/@(standardDilutionCurve/.<|Null -> {{0 Milliliter, 0 Milliliter}}|>),
		0 Milliliter
	];

	(* Merge the volume needed for the same external standard *)
	volumePerExternalStandard = If[externalStandardQ,
		Merge[MapThread[<|#1->#2|>&,{externalStandard,externalStandardVolumes}],Total]
	];

	(* Create a lookup linking each unique addition standard to its resource *)
	externalStandardResourceLookup = If[externalStandardQ,
		KeyValueMap[
			If[NullQ[#1],
				Null -> Null,
				#1 -> Link[Resource[Sample -> #1, Name -> ToString[#1], Amount -> #2]]
			]&,
			volumePerExternalStandard
		],
		{}
	];

	(* Get list of resources of ExternalStandard *)
	externalStandardResources = If[externalStandardQ,
		Lookup[externalStandardResourceLookup,externalStandard, Null],
		Null
	];

	(* Find out how many actual external standards will be loaded per specified option *)
	externalStandardMultiplicity = If[externalStandardQ,
		(* If StandardType is ExternalStandard, read the length of StandardAdditionCurve per second-level list *)
		Length/@standardDilutionCurve,
		(* If StandardType is not ExternalStandard, set to {0} *)
		{0}
	];

	(* Construct the PreDilutionSample field of ExternalStandard *)
	externalStandardPreDilutionSample = If[externalStandardQ,
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{externalStandardResources, externalStandardMultiplicity}
			]
		]
	];

	(* Construct the StandardVolume field of ExternalStandard *)
	externalStandardStandardVolume = If[externalStandardQ,
		Flatten[standardDilutionCurve[[All, All, 1]]]
	];

	(* Construct the BlankVolume field of ExternalStandard *)
	externalStandardBlankVolume = If[externalStandardQ,
		Flatten[standardDilutionCurve[[All, All, 2]]]
	];

	(* Construct a list of string to label the diluted standards, in the form of "Standard #" to be simple *)
	externalStandardLabel = If[externalStandardQ,
		MapThread[#1 <> #2&,
			{
				Table["Standard ", Total[externalStandardMultiplicity]],
				ToString/@Range[1, Total[externalStandardMultiplicity]]
			}
		]
	];

	(* Construct a list of containers for diluting external standards *)
	externalStandardContainer = If[externalStandardQ,
		Table[Link[Resource[Sample -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *)]], Total[externalStandardMultiplicity]]
	];

	(* Construct the ExternalStandard field *)
	externalStandardUploadable = If[externalStandardQ,
		MapThread[
			Function[{predilutionSample, stdVolume, blkVolume, label, container},
				Association[
					PreDilutionSample -> predilutionSample,
					StandardVolume -> stdVolume,
					BlankVolume -> blkVolume,
					Label -> label,
					Sample -> Null,
					Container -> container,
					Data -> Null
				]
			],
			{externalStandardPreDilutionSample, externalStandardStandardVolume, externalStandardBlankVolume, externalStandardLabel, externalStandardContainer}
		]
	];

	(* Construct the ExternalStandardElements field *)

	(* Get the Element subfield *)

	(* Take the ExternalStandardElements field and replicate by externalStandardMultiplicity *)
	externalStandardElementsMultiplied = If[externalStandardQ && !NullQ[externalStandardElements],
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{externalStandardElements, externalStandardMultiplicity}
			],
			1
		]
	];

	(* Take the Elements field and replicate it by total number of external standards, after dilution *)
	externalStandardElementsElement = If[externalStandardQ && !NullQ[externalStandardElements],
		(* Replicate the Element part of ExternalStandardElements by externalStandardMultiplicity *)
		Flatten[externalStandardElementsMultiplied[[All, All, 1]]]
	];

	(* Calculate the ratio of ExternalStandard after dilution *)
	externalStandardRatio = If[externalStandardQ,
		MapThread[#1/(#1+#2)&,
			{externalStandardStandardVolume, externalStandardBlankVolume}
		]
	];

	(* calculate concentration of isotopes after dilution *)
	externalStandardElementsConcentration = If[externalStandardQ && !NullQ[externalStandardElements],
		(* Replicate the concentration part of ExternalStandardElements by externalStandardMultiplicity, then multiply by externalStandardRatio *)
		Flatten[
			MapThread[
				#1 * #2&,
				{externalStandardElementsMultiplied[[All, All, 2]], externalStandardRatio}
			]
		]
	];

	externalStandardElementsLabel = If[externalStandardQ && !NullQ[externalStandardElements],
		Flatten[
			MapThread[
				Table[#1, #2]&,
				{externalStandardLabel, Length/@externalStandardElementsMultiplied}
			]
		]
	];

	(* Construct an association pointing from externalStandardLabel to externalStandardPreDilutionSample *)
	externalstandardLabelToPreDilutionSample = If[externalStandardQ,
		Association @@ MapThread[#1 -> #2&, {externalStandardLabel, externalStandardPreDilutionSample}],
		<||>
	];
	(* find the Standard field of ExternalStandardElements field *)
	externalStandardElementsStandard = externalStandardElementsLabel /. externalstandardLabelToPreDilutionSample;
	(* find the StandardConcentration field of ExternalStandardElements field *)
	externalStandardElementsStandardConcentration = If[externalStandardQ && !NullQ[externalStandardElements],
		(* Replicate the concentration part of ExternalStandardElements by externalStandardMultiplicity, then multiply by externalStandardRatio *)
		Flatten[externalStandardElementsMultiplied[[All, All, 2]]],
		{}
	];


	externalStandardElementsUploadable = If[externalStandardQ && !NullQ[externalStandardElements],
		MapThread[
			Association[
				Element -> #1,
				Sample -> Null,
				Label -> #3,
				Concentration -> #2,
				Standard -> #4,
				StandardConcentration -> #5
			]&,
			{externalStandardElementsElement, externalStandardElementsConcentration, externalStandardElementsLabel, externalStandardElementsStandard, externalStandardElementsStandardConcentration}
		]
	];

	(* Get Blank object *)
	blank = Download[Lookup[optionsWithReplicates, Blank], Object];

	(* Make resources for Blank. We want to separate blank for measurement and blank for dilution, despite they are the same composition *)
	(* Reason to do this is the blank for measurement must be contained in 50 mL tube, but blank for dilution has no limitation *)
	(* Calculate Blank volume for dilution only *)
	blankVolume = Which[
		(* If StandardType is External, use 2 ml + total amount in externalStandardBlankVolume *)
		externalStandardQ, Total[externalStandardBlankVolume] + 2 Milliliter,
		(* If StandardType is StandardAddition, use 5 ml + total amount in standardSpikedSamplesBlankVolume *)
		standardAdditionQ, Total[standardSpikedSamplesBlankVolume] + 2 Milliliter,
		(* Otherwise, use none *)
		True, Null
	];

	(* Get Blank resource. Blank is only measured once so 10 ml would be more than enough *)
	blankResource = Link[Resource[Sample -> blank, Name -> "Blank: "<>ToString[blank], Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* "50mL Tube" *)]];
	blankDiluentResource = If[NullQ[blankVolume],
		Null,
		Link[Resource[Sample -> blank, Name -> "Blank for dilution: "<>ToString[blank], Amount -> blankVolume]]
	];

	(* Get Rinse-related options *)
	{rinse, rinseSolution, rinseTime} = Lookup[optionsWithReplicates, {Rinse, RinseSolution, RinseTime}];

	(* Calculate how many times rinse is needed for RinseSolution *)
	rinseCount = If[rinse,
		(* If Rinse set to True, Following samples needs to be run: input, blank and external standard *)
		(* Always rinse before 1st run and after last run *)
		1 + Ceiling[
			Plus[
				(* count how many rinse needed for input samples *)
				Length[sampleObjects],
				(* Count how many rinse needed for blank, which is always 1 *)
				1,
				(* Count how many rinse needed for external standard *)
				If[MatchQ[standardType, External],
					(* If StandardType -> External, count how many external standards are there *)
					Length[ToList[externalStandard]],
					(* Otherwise set to 0 *)
					0
				]
			]
		],
		(* If Rinse set to False, no rinse *)
		0
	];

	rinseTimeForCalculation = If[NullQ[rinseTime], 0 Second, rinseTime];

	(* Find out volume needed for Rinse Solution, but use at least 30 ml due to need for rinse in start up *)
	rinseVolume = 100 Milliliter + (rinseCount * rinseTimeForCalculation * 10 Milliliter/Minute);

	(* Construct Rinse Resource. Note we still need rinse solution for setting up spectrometer even if Rinse -> False *)
	rinseResource = Link[Resource[Sample -> rinseSolution, Amount -> rinseVolume, Name -> "Rinse: "<>ToString[rinseSolution]]];

	(* Download object for InternalStandard *)
	internalStandardQ = !NullQ[Lookup[optionsWithReplicates, InternalStandard]];
	internalStandard = If[internalStandardQ,
		Download[Lookup[optionsWithReplicates, InternalStandard], Object]
	];

	(* Find InternalStandardMixRatio *)
	internalStandardMixRatio = Lookup[optionsWithReplicates, InternalStandardMixRatio];

	(* Calculate how much volume needed for InternalStandard *)
	internalStandardVolume = Which[
		(* If not using InternalStandard, set volume to 0 *)
		!internalStandardQ, 0 Milliliter,
		(* If using InternalStandard, and StandardType is External, set to internalStandardMixRatio*(<total volume of input sample> + <total volume of diluted external standard>) *)
		externalStandardQ, internalStandardMixRatio * (Total[Flatten[{sampleAmount, externalStandardStandardVolume, externalStandardBlankVolume, 10 Milliliter}]]),
		(* If StandardType is StandardAddition, set to internalStandardMixRatio*(<total volume of standard spiked sample>) *)
		standardAdditionQ, internalStandardMixRatio * (Total[Flatten[{standardSpikedSamplesTotalVolumes, 10 Milliliter}]]),
		(* If StandardType is None, set to internalStandardMixRatio*(<total volume of input samples>). *)
		True, internalStandardMixRatio * (Total[Flatten[{sampleAmount, 10 Milliliter}]])
	];

	(* Construct resource packet of InternalStandard *)
	internalStandardResource = If[internalStandardQ,
		Link[Resource[Sample -> internalStandard, Amount -> internalStandardVolume * 1.2, Name -> ToString[internalStandard]]]
	];

	(* Construct the uploadable content for InternalStandard *)
	internalStandardUploadable = If[internalStandardQ,
		{internalStandardResource, internalStandardMixRatio}
	];

	(* Construct Cone resources *)
	coneObject = Which[
		coneDiameter == 2.8 Millimeter, Model[Item, "Skimmer Cone Insert 2.8 mm (High Sensitivity) for Thermo Fisher iCAP-RQ"],
		coneDiameter == 3.5 Millimeter, Model[Item, "Skimmer Cone Insert 3.5 mm (High Matrix) for Thermo Fisher iCAP-RQ"],
		coneDiameter == 4.5 Millimeter, Model[Item, "Skimmer Cone Insert 4.5 mm (Robust Plasma) for Thermo Fisher iCAP-RQ"],
		True, Null
	];

	cone = Resource[Sample -> Link[coneObject]];

	(* Determining the MeasurementMethod for start-up *)
	{cctPres, cctBias, plasmaPower} = Lookup[optionsWithReplicates, {CollisionCellPressurization, CollisionCellBias, PlasmaPower}];

	(* Find if STD, CCT and KED mode should be run *)
	needSTD = MemberQ[cctPres, False];
	needKED = MemberQ[cctBias, True];
	needCCT = MemberQ[MapThread[#1 && !#2&,{cctPres, cctBias}], True];

	(* Find if Cold_Ins should be run *)
	needColdIons = MemberQ[plasmaPower, Low];

	(* Determine MeasurementMethod based on CCT Pressurization and Bias settings *)
	measurementMethod = PickList[{"STD", "KED", "CCT"}, {needSTD, needKED, needCCT}];

	(* Change MeasurementMethod based on cone diameter *)
	measurementMethod = Switch[coneDiameter,
		2.8 Millimeter, StringJoin[#, "S"]& /@ measurementMethod,
		3.5 Millimeter, measurementMethod,
		4.5 Millimeter, StringJoin[#, "R"]& /@ measurementMethod
	];

	(* Append "Cold_Ins" if needColdIons is True *)
	measurementMethod = If[needColdIons,
		Append[measurementMethod, "Cold_Ins"],
		measurementMethod
	];

	(* Construct resource for tuning standard *)
	(* Calculate volume needed. Allocate 15 ml for each measurement method, but no more than 45 ml *)
	tuningStandardVolume = 15 Milliliter * Min[Length[measurementMethod], 3];
	(* Construct resource for tuning solution *)
	tuningStandard = Resource[Sample -> Link[Model[Sample, "id:aXRlGnReBqLm"] (* "iCAP Q/RQ Tune Solution" *)], Amount -> tuningStandardVolume, Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* "50mL Tube" *)];

	(* Construct UnitOperation object of digestion primitives *)

	(*digestionUnitOperationPacket = UploadUnitOperation[myDigestionPrimitives, Upload -> False];*)

	(*digestionUnitOperationObject = Upload[digestionUnitOperationPacket];*)


	(* calculate instrument time *)

	(* Consider 15 minute warm up, 10 minute start up and pump vacuum, etc. *)
	instrumentSetupTime = 25 Minute;

	(* Calculate acquisition time per sample *)
	runTimePerSample = injectionDuration + Length[elements] * 10 Second;

	(* Calculate total sample run time *)
	sampleRunTime = runTimePerSample * Total[Flatten[{
		(* Number of SamplesIn, or StandardSpikedSamples if StandardType -> StandardAddition *)
		standardAdditionMultiplicity,
		(* Number of diluted external standards *)
		externalStandardMultiplicity,
		(* Number of Blank *)
		1
	}]] + rinseCount * rinseTime;

	(* Create a resource for ICPMS instrument *)
	icpmsInstrumentResource = Resource[Instrument -> Lookup[optionsWithReplicates, Instrument], Time -> (sampleRunTime + instrumentSetupTime)];

	(* Estimate checkpoints *)
	numberOfContainersInvolved = (Length[containersIn]+Length[externalStandard]+Length[DeleteDuplicates[DeleteCases[ToList[additionStandard], Null]]]);
	resourcePickingTime = numberOfContainersInvolved * 5 Minute + 5 Minute;

	(* Create checkpoints *)
	checkpoints = {
		{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time ->resourcePickingTime]},
		{"Preparing Samples",0*Hour,"Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.",Resource[Operator->$BaselineOperator,Time -> 0*Minute]},
		{"Digesting Samples", 0*Hour(*TBD*), "Samples are digested with microwave reactor, if required.",Resource[Operator->Model[User,Emerald,Operator,"Level 3"],Time -> 0*Hour(*TBD*)]},
		{"Making dilutions", 0*Hour(*TBD*), "Samples and standards after digestion are diluted and mixed, as required by StandardDilutionCurve or StandardAdditionCurve.", Resource[Operator->Model[User,Emerald,Operator,"Level 3"],Time -> 0*Hour(*TBD*)]},
		{"Warmup and Tune Instrument",25 Minute, "Check if the instrument is warmedup and ready to run the sample.",Resource[Operator->$BaselineOperator,Time ->25 Minute]},
		{"Acquiring Data",sampleRunTime,"The instrument is calibrated, and samples are injected and measured.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+sampleRunTime)]},
		{"Sample Post-Processing",0*Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Resource[Operator->$BaselineOperator,Time ->0*Minute]},
		{"Turning off Instrument", 10 Minute, "Instrument is turned off.",Resource[Operator->$BaselineOperator,Time ->10*Minute]},
		{"Returning Materials", 20 Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Resource[Operator->$BaselineOperator,Time ->20*Minute]}
	};

	(* Now we need to separate parameters of sweep and main scans *)
	sweep = MemberQ[Lookup[optionsWithReplicates, Elements], Sweep];

	{elementsRelatedOptions, sweepOptions} = If[sweep,
		Transpose[Map[
			Module[{optionValue},
				optionValue = Lookup[optionsWithReplicates, #];
				{# -> Most[optionValue], # -> Last[optionValue]}
			]&,
			{
				Elements,
				QuantifyConcentration,
				InternalStandardElement,
				PlasmaPower,
				CollisionCellPressurization,
				CollisionCellGasFlowRate,
				CollisionCellBias,
				DwellTime,
				NumberOfReads,
				ReadSpacing,
				Bandpass
			}
		]],
		{optionsWithReplicates, {}}
	];

	sweepParameters = If[MatchQ[sweepOptions, {}],
		{},
		Transpose[{Keys[sweepOptions], Values[sweepOptions]}]
	];

	(* CollisionCellGas *)
	collisionCellGasSingle = Which[
		(* If CollisionCellGas from resolved option contains Helium, set it to helium *)
		MemberQ[collisionCellGas, Helium], Helium,
		(* If it contains Oxygen, set it to Oxygen *)
		MemberQ[collisionCellGas, Oxygen], Oxygen,
		(* otherwise set to Null *)
		True, Null
	];

	(* Finalize packets for ExperimentICPMS *)
	icpmsPacket = <|
		Object -> CreateID[Object[Protocol, ICPMS]],
		Replace[SamplesIn] -> samplesInResources,
		Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@containersIn,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden,
		ImageSample->Lookup[optionsWithReplicates,ImageSample],
		MeasureVolume -> False,(*TBD*)
		MeasureWeight -> False,(*TBD*)
		Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
		QuantifyElements -> Lookup[optionsWithReplicates,QuantifyElements],

		(* Mass Spectrometer options for ICP-MS *)
		IonSource->ICP,
		MassAnalyzer->SingleQuadrupole,
		IonMode -> Positive,
		MinMass -> Lookup[optionsWithReplicates, MinMass],
		MaxMass -> Lookup[optionsWithReplicates, MaxMass],
		WarmUpTime -> 15 Minute,
		ConeDiameter -> Lookup[optionsWithReplicates, ConeDiameter],
		Instrument -> icpmsInstrumentResource,
		Cone -> cone,
		Replace[MeasurementMethod] -> measurementMethod,
		TuningStandard -> tuningStandard,


		(* StandardOptions *)
		StandardType -> standardType,
		Replace[ExternalStandard] -> externalStandardUploadable,
		Replace[ExternalStandardElements] -> externalStandardElementsUploadable,
		Replace[StandardSpikedSamples] -> standardSpikedSamplesUploadable,
		Replace[StandardAdditionElements] -> standardAdditionElementsUploadable,
		InternalStandard -> internalStandardUploadable,
		Replace[ICPMSSampleContainers] -> icpmsSampleContainers,

		(* DigestionOptions *)
		Replace[Digestion] -> digestion,
		(*DigestionPrimitives -> If[!MatchQ[digestionUnitOperationObject, $Failed], Link[digestionUnitOperationObject]],*)
		DigestionInstrument -> Lookup[optionsWithReplicates, DigestionInstrument],
		Replace[SampleType] -> Lookup[optionsWithReplicates, SampleType],
		Replace[SampleDigestionAmount] -> Lookup[optionsWithReplicates, SampleDigestionAmount],
		Replace[CrushSample] -> Lookup[optionsWithReplicates, CrushSample],
		Replace[PreDigestionMix] -> Lookup[optionsWithReplicates, PreDigestionMix],
		Replace[PreDigestionMixTime] -> Lookup[optionsWithReplicates, PreDigestionMixTime],
		Replace[PreDigestionMixRate] -> Lookup[optionsWithReplicates, PreDigestionMixRate],
		Replace[PreparedPreDigestionSample] -> Lookup[optionsWithReplicates, PreparedPreDigestionSample],
		Replace[DigestionAgents] -> Lookup[optionsWithReplicates, DigestionAgents],
		Replace[DigestionTemperature] -> Lookup[optionsWithReplicates, DigestionTemperature],
		Replace[DigestionDuration] -> Lookup[optionsWithReplicates, DigestionDuration],
		Replace[DigestionRampDuration] -> Lookup[optionsWithReplicates, DigestionRampDuration],
		Replace[DigestionTemperatureProfile] -> Lookup[optionsWithReplicates, DigestionTemperatureProfile],
		Replace[DigestionMixRateProfile] -> Lookup[optionsWithReplicates, DigestionMixRateProfile],
		Replace[DigestionMaxPower] -> Lookup[optionsWithReplicates, DigestionMaxPower],
		Replace[DigestionMaxPressure] -> Lookup[optionsWithReplicates, DigestionMaxPressure],
		Replace[DigestionPressureVenting] -> Lookup[optionsWithReplicates, DigestionPressureVenting],
		Replace[DigestionPressureVentingTriggers] -> Lookup[optionsWithReplicates, DigestionPressureVentingTriggers],
		Replace[DigestionTargetPressureReduction] -> Lookup[optionsWithReplicates, DigestionTargetPressureReduction],
		Replace[DigestionOutputAliquot] -> Lookup[optionsWithReplicates, DigestionOutputAliquot],
		Replace[DiluteDigestionOutputAliquot] -> Lookup[optionsWithReplicates, DiluteDigestionOutputAliquot],
		Replace[PostDigestionDiluent] -> Lookup[optionsWithReplicates, PostDigestionDiluent],
		Replace[PostDigestionDiluentVolume] -> Lookup[optionsWithReplicates, PostDigestionDiluentVolume],
		Replace[PostDigestionDilutionFactor] -> Lookup[optionsWithReplicates, PostDigestionDilutionFactor],
		Replace[PostDigestionSampleVolume] -> Lookup[optionsWithReplicates, PostDigestionSampleVolume],
		Replace[DigestionContainerOut] -> Lookup[optionsWithReplicates, DigestionContainerOut],

		(* Blank and Rinse parameters *)
		Blank -> blankResource,
		BlankDiluent -> blankDiluentResource,
		Rinse -> rinse,
		RinseSolution -> rinseResource,
		RinseTime -> rinseTime,

		(* sample loading options *)
		Replace[SampleAmounts] -> sampleAmount,
		InjectionDuration -> Lookup[optionsWithReplicates, InjectionDuration],

		(* sweep parameters *)
		Sweep -> sweep,
		Replace[SweepParameters] -> sweepParameters,

		(* Elements related options *)
		Replace[Elements] -> Lookup[elementsRelatedOptions, Elements],
		Replace[QuantifyConcentration] -> Lookup[elementsRelatedOptions, QuantifyConcentration],
		Replace[InternalStandardElement] -> Lookup[elementsRelatedOptions, InternalStandardElement],
		Replace[NominalPlasmaPower] -> Lookup[elementsRelatedOptions, PlasmaPower]/.{Normal -> 1500 Watt, Low -> 350 Watt},
		Replace[CollisionCellPressurization] ->Lookup[elementsRelatedOptions, CollisionCellPressurization],
		Replace[CollisionCellGas] -> collisionCellGasSingle,
		Replace[CollisionCellGasFlowRate] -> Lookup[elementsRelatedOptions, CollisionCellGasFlowRate],
		Replace[CollisionCellBias] -> Lookup[elementsRelatedOptions, CollisionCellBias],
		Replace[DwellTime] -> Lookup[elementsRelatedOptions, DwellTime],
		Replace[NumberOfReads] -> Lookup[elementsRelatedOptions, NumberOfReads],
		Replace[ReadSpacing] -> Lookup[elementsRelatedOptions, ReadSpacing],
		Replace[Bandpass] -> Lookup[elementsRelatedOptions, Bandpass]/.{Normal -> 0.75 Gram/Mole, High -> 0.3 Gram/Mole},
		(* -- Checkpoints -- *)
		Replace[Checkpoints]->checkpoints,
		(* Operator *)
		Operator -> Link[Lookup[optionsWithReplicates, Operator]]
		|>;

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples,expandedResolvedOptions,Cache->cache, Simulation -> simulationResourcePacket];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, icpmsPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation -> simulationResourcePacket],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache, Simulation -> simulationResourcePacket],Null}
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
		{finalizedPacket,Null},
		{$Failed,Null}
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];

(* ::Subsubsection:: *)
(* resolveExperimentICPMSMethod *)
DefineOptions[resolveExperimentICPMSMethod,
	SharedOptions :> {
		ExperimentICPMS,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveExperimentICPMSMethod[
	mySamples: ListableP[Automatic|(ObjectP[{Object[Sample],Object[Container]}])],
	myOptions: OptionsPattern[resolveExperimentICPMSMethod]
] := Module[
	{outputSpecification, output, gatherTests, result, tests},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	result = Manual;
	tests = {};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];


(* ::Subsubsection:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentICPMS,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentICPMS[
	myProtocolPacket:(PacketP[Object[Protocol, ICPMS], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:(ListableP[PacketP[]]|$Failed|Null),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentICPMS]
] := Module[
	{
		mapThreadFriendlyOptions,resolvedPreparation,cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels,
		updatedSimulation, digestionProtocol, digestionSamplesIn, digestionSamplesOut, digestionSamplesInNoLink, digestionSamplesOutNoLink,
		digestionSampleRules, digestionSamplesOutField, simulationWithDigestion, digestion
	},

	(* Lookup our cache and simulation *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		mySamples,
		Packet[Container],
		Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
		Simulation->simulation
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[Object[Protocol,ICPMS]],
		Lookup[myProtocolPacket, Object]
	];


	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentICPMS,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=If[

		(* if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],

		(* Otherwise, our reosurce packets went fine and we have an Object[Protocol, ICPMS]. *)
		SimulateResources[
			myProtocolPacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	updatedSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* Special note here: supposingly I should first call ExperimentMicrowaveDigestion[mySamples, myOptions, Output -> Simulation] to simulate the microwaveDigestionProtocol *)
	(* However, since I had to call the same function in options resolver, I combined two calls into one to save computing time *)
	(* Therefore, this microwave digestion protocol is already simulated and included in the input Simulation option *)
	(* All I need to do now is just extract it out *)

	(* find the Microwave Digestion protocol *)
	digestionProtocol = If[MatchQ[myProtocolPacket, $Failed],
		(* If resource packet fail, set to Null *)
		Null,
		(* Otherwise, look for the first case of Object[Protocol, MicrowaveDigestion] in the simulation packet *)
		FirstCase[updatedSimulation[[1]][SimulatedObjects], ObjectP[Object[Protocol, MicrowaveDigestion]], Null]
	];

	(* find SamplesIn and SamplesOut in the protocol packet*)
	{digestionSamplesIn, digestionSamplesOut} = If[NullQ[digestionProtocol],
		{{}, {}},
		Download[digestionProtocol, {SamplesIn, SamplesOut}, Simulation -> updatedSimulation, Cache -> cache]
	];

	(* Remove links for above object *)
	digestionSamplesInNoLink = LinkedObject/@digestionSamplesIn;
	digestionSamplesOutNoLink = LinkedObject/@digestionSamplesOut;

	(* Make a rule from SamplesIn to SamplesOut *)
	digestionSampleRules = MapThread[#1 -> #2&, {digestionSamplesInNoLink, digestionSamplesOutNoLink}];

	(* extract index-matched digestion Boolean *)
	digestion = Lookup[mapThreadFriendlyOptions, Digestion, False];

	(* Construct the DigestionSamplesOut field of simulated ICPMS protocol *)
	digestionSamplesOutField = MapThread[
		(* If sample needs digestion, replace the input sample with corresponding SamplesOut, then create link *)
		If[#2,
			Link[#1/.digestionSampleRules],
			(* Otherwise set to Null *)
			Null
		]&,
		{mySamples, digestion}
	];

	simulationWithDigestion = UpdateSimulation[
		updatedSimulation,
		Simulation[<|Object -> protocolObject, DigestionProtocol -> digestionProtocol, Replace[DigestionSamplesOut] -> digestionSamplesOutField|>]
	];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[simulationWithDigestion, simulationWithLabels]
	}
];

(* ::Subsubsection:: *)
(*ExperimentICPMS general helper functions*)


(*ICPMSDefaultIsotopes*)
(*Core Overload*)
DefineOptions[ICPMSDefaultIsotopes,
	Options :> {
		{Flatten -> True, True | False, "Indicate if resulted list of isotopes should be flattened."},
		{IsotopeAbundanceThreshold -> 0.2, RangeP[0, 0.5], "Indicate the minimum abundance for an isotope to be included. However, the most abundant isotope will always be included."},
		{Message -> True, True | False, "Indicate if this function will output message by itself; when set to False it do not return any message but instead return two additional outputs."},
		{Instrument -> All, All|ObjectP[{Model[Instrument, MassSpectrometer], Object[Instrument, MassSpectrometer]}], "Specify the instrument ICPMSDefaultIsotopes with respect to. If all is selected, all Elements and Isotopes suppoorted by any instrument will be considered."},
		CacheOption
	}
];

ICPMSDefaultIsotopes[MyElements:{_Symbol ...}, ops:OptionsPattern[]] := Module[
	{
		listedOps, unflattenedlist, flatten, sanitizedInputs, invalidInputs, threshold, allIsotopes,
		aboveThresholdIsotopes, mostAbundantIsotopes, belowThresholdOutputs, unflattenedBelowThresholdOutputs, message,
		results, cache, instrument, instrumentInCacheQ, instrumentPacket, supportedElements, supportedIsotopes, icpmsIsotopesList,
		unsupportedInputs, supportedInputs
	},
	(* Extract all options *)
	listedOps = SafeOptions[ICPMSDefaultIsotopes, ToList[ops]];
	flatten = Lookup[listedOps, Flatten, True];
	threshold = Lookup[listedOps, IsotopeAbundanceThreshold];
	message = Lookup[listedOps, Message];
	cache = Lookup[listedOps, Cache];
	instrument = Lookup[listedOps, Instrument];

	(* Remove any inputs that are not part of ICPMSElementP *)
	sanitizedInputs = Cases[MyElements, ICPMSElementP];

	(* Select inputs that are not part of ICPMSElementP *)
	invalidInputs = Select[MyElements, !MatchQ[#, ICPMSElementP]&];

	(* find whether we need to download the instrument packet *)

	instrumentPacket = If[MatchQ[instrument, All],
		(* If instrument set to All, create a packet so that all Elements and Isotopes are supported *)
		<|SupportedElements -> DeleteCases[List@@ICPMSElementP, Sweep], SupportedIsotopes -> DeleteCases[List@@ICPMSNucleusP, Sweep] |>,
		(* Otherwise, download the packet of instrument *)
		Download[instrument, Packet[SupportedElements, SupportedIsotopes], Cache -> cache]
	];
	
	(* find the supported elements and isotopes *)
	supportedElements = Lookup[instrumentPacket, SupportedElements];
	supportedIsotopes = Lookup[instrumentPacket, SupportedIsotopes];

	(* Construct a list of rules to convert supportedElements to supportedIsotopes *)
	icpmsIsotopesList = Module[{allElementSymbols, isotopeListGrouped},
		(* Convert all element into abbreviated symbols in string form *)
		allElementSymbols = ECLElementData[supportedElements, Abbreviation, Output -> Values, Cache -> cache];
		
		(* Group the supported Isotopes by the elements *)
		isotopeListGrouped = Function[{elementSymbol},
			Select[supportedIsotopes, MatchQ[elementSymbol, StringDelete[#, DigitCharacter]]&]
		]/@allElementSymbols;
		
		(* Construct the list of rules from Element to Isotopes, also append Sweep -> Sweep *)
		Append[MapThread[#1 -> #2 &, {supportedElements, isotopeListGrouped}], Sweep -> Sweep]
	];

	(* Select inputs that are part of ICPMSElementP but not supported by the instrument *)
	unsupportedInputs = Select[sanitizedInputs, !MemberQ[Append[supportedElements, Sweep], #]&];

	(* Select inputs that are  supported by the instrument *)
	supportedInputs = Select[sanitizedInputs, MemberQ[Append[supportedElements, Sweep], #]&];

	(* Create a list of all supported isotopes based on input elements *)
	allIsotopes = supportedInputs/.icpmsIsotopesList;

	(* Remove isotopes which abundance is below threshold *)
	aboveThresholdIsotopes = Function[{isotopeList},
		Quiet[Select[isotopeList,ECLIsotopeData[#, IsotopeAbundance, Cache -> cache] >= threshold&]]
	]/@allIsotopes;

	(* Construct the list of most abundant isotopes *)
	mostAbundantIsotopes = supportedInputs/.MostAbundantIsotopesList;

	(* Combine aboveThresholdIsotopes and mostAbundantIsotopes. For each pair of entries in aboveThresholdIsotopes and mostAbundantIsotopes: *)
	{unflattenedlist, unflattenedBelowThresholdOutputs} = If[MatchQ[sanitizedInputs, {}] || MatchQ[supportedInputs, {}],
		{{},{}},
		Transpose[MapThread[
			Which[
				(* If element from mostAbundantIsotopes is Sweep, include it into the output *)
				MatchQ[#2, Sweep], {{Sweep}, {}},
				(* If element from mostAbundantIsotopes is already in aboveThresholdIsotopes, keep using aboveThresholdIsotopes *)
				MemberQ[#1, #2], {#1, {}},
				(* If element from mostAbundantIsotopes is not in aboveThresholdIsotopes, and this element is not Sweep, use only the element from mostAbundantIsotopes *)
				True, {{#2}, {#2}}
			]&,
			{aboveThresholdIsotopes, mostAbundantIsotopes}
		]]
	];

	(* Also record a list of isotopes that will be included in the output but below user-specified threshold *)
	belowThresholdOutputs = Flatten[unflattenedBelowThresholdOutputs];

	(* Message output for including isotopes below threshold *)
	If[message && Length[belowThresholdOutputs]>0,
		Message[
			ICPMSDefaultIsotopes::BelowThresholdIsotopesIncluded, belowThresholdOutputs
		]
	];

	(* Message output for invalid input *)
	If[message && Length[invalidInputs] >0,
		Message[
			ICPMSDefaultIsotopes::InvalidElement, invalidInputs
		]
	];
	results = If[flatten, Flatten[unflattenedlist], unflattenedlist];

	(* Message output for unsupported elements input *)
	If[message && Length[unsupportedInputs] >0,
		Message[
			ICPMSDefaultIsotopes::UnsupportedElement, unsupportedInputs
		]
	];

	If[message,
		results,
		{results, belowThresholdOutputs, invalidInputs, unsupportedInputs}
	]
];

(*Overload for one single input*)
ICPMSDefaultIsotopes[MyElement_Symbol, ops:OptionsPattern[]] := ICPMSDefaultIsotopes[{MyElement}, ops];

ICPMSDefaultIsotopes::InvalidElement = "The provided entry `1` is not a valid element supported by ICPMS and will be ignored. Please check your spelling or change your options.";
ICPMSDefaultIsotopes::BelowThresholdIsotopesIncluded = "The following isotopes `1` is below user-specified threshold, but still be selected since they are the most abundant isotopes for their elements.";
ICPMSDefaultIsotopes::UnsupportedElement = "The following elements `1` is not supported by the specified instrument and therefore ignored. Please consider switch to another instrument.";

(*Define list of rules from all ICPMS-supported elements to all ICPMS-supported isotopes *)
ICPMSIsotopesList = {Hydrogen -> {"1H", "2H", "3H"}, Helium -> {"3He", "4He"},
	Lithium -> {"6Li", "7Li"}, Beryllium -> {"9Be"},
	Boron -> {"10B", "11B"}, Carbon -> {"12C", "13C", "14C"},
	Nitrogen -> {"14N", "15N"}, Oxygen -> {"16O", "17O", "18O"},
	Fluorine -> {"19F"}, Neon -> {"20Ne", "21Ne", "22Ne"},
	Sodium -> {"23Na"}, Magnesium -> {"24Mg", "25Mg", "26Mg"},
	Aluminum -> {"27Al"}, Silicon -> {"28Si", "29Si", "30Si"},
	Phosphorus -> {"31P"}, Sulfur -> {"32S", "33S", "34S", "36S"},
	Chlorine -> {"35Cl", "37Cl"},
	Argon -> {"36Ar", "37Ar", "38Ar", "39Ar", "40Ar"},
	Potassium -> {"39K", "40K", "41K"},
	Calcium -> {"40Ca", "42Ca", "43Ca", "44Ca", "46Ca", "48Ca"},
	Scandium -> {"45Sc"},
	Titanium -> {"46Ti", "47Ti", "48Ti", "49Ti", "50Ti"},
	Vanadium -> {"50V", "51V"},
	Chromium -> {"50Cr", "52Cr", "53Cr", "54Cr"}, Manganese -> {"55Mn"},
	Iron -> {"54Fe", "56Fe", "57Fe", "58Fe"}, Cobalt -> {"59Co"},
	Nickel -> {"58Ni", "60Ni", "61Ni", "62Ni", "64Ni"},
	Copper -> {"63Cu", "65Cu"},
	Zinc -> {"64Zn", "66Zn", "67Zn", "68Zn", "70Zn"},
	Gallium -> {"69Ga", "71Ga"},
	Germanium -> {"70Ge", "72Ge", "73Ge", "74Ge", "76Ge"},
	Arsenic -> {"75As"},
	Selenium -> {"74Se", "76Se", "77Se", "78Se", "80Se", "82Se"},
	Bromine -> {"79Br", "81Br"},
	Krypton -> {"78Kr", "80Kr", "82Kr", "83Kr", "84Kr", "86Kr"},
	Rubidium -> {"85Rb", "87Rb"},
	Strontium -> {"84Sr", "86Sr", "87Sr", "88Sr"}, Yttrium -> {"89Y"},
	Zirconium -> {"90Zr", "91Zr", "92Zr", "94Zr", "96Zr"},
	Niobium -> {"93Nb"},
	Molybdenum -> {"92Mo", "94Mo", "95Mo", "96Mo", "97Mo", "98Mo",
		"100Mo"}, Technetium -> {"97Tc", "98Tc", "99Tc"},
	Ruthenium -> {"96Ru", "98Ru", "99Ru", "100Ru", "101Ru", "102Ru",
		"104Ru"}, Rhodium -> {"103Rh"},
	Palladium -> {"102Pd", "104Pd", "105Pd", "106Pd", "108Pd", "110Pd"},
	Silver -> {"107Ag", "109Ag"},
	Cadmium -> {"106Cd", "108Cd", "110Cd", "111Cd", "112Cd", "113Cd",
		"114Cd", "116Cd"}, Indium -> {"113In", "115In"},
	Tin -> {"112Sn", "114Sn", "115Sn", "116Sn", "117Sn", "118Sn",
		"119Sn", "120Sn", "122Sn", "124Sn"},
	Antimony -> {"121Sb", "123Sb"},
	Tellurium -> {"120Te", "122Te", "123Te", "124Te", "125Te", "126Te",
		"128Te", "130Te"}, Iodine -> {"127I"},
	Xenon -> {"124Xe", "126Xe", "128Xe", "129Xe", "130Xe", "131Xe",
		"132Xe", "134Xe", "136Xe"}, Cesium -> {"133Cs"},
	Barium -> {"130Ba", "132Ba", "134Ba", "135Ba", "136Ba", "137Ba",
		"138Ba"}, Lanthanum -> {"138La", "139La"},
	Cerium -> {"136Ce", "138Ce", "140Ce", "142Ce"},
	Praseodymium -> {"141Pr"},
	Neodymium -> {"142Nd", "143Nd", "144Nd", "145Nd", "146Nd", "148Nd",
		"150Nd"}, Promethium -> {"145Pm", "147Pm"},
	Samarium -> {"144Sm", "147Sm", "148Sm", "149Sm", "150Sm", "152Sm",
		"154Sm"}, Europium -> {"151Eu", "153Eu"},
	Gadolinium -> {"152Gd", "154Gd", "155Gd", "156Gd", "157Gd", "158Gd",
		"160Gd"}, Terbium -> {"159Tb"},
	Dysprosium -> {"156Dy", "158Dy", "160Dy", "161Dy", "162Dy", "163Dy",
		"164Dy"}, Holmium -> {"165Ho"},
	Erbium -> {"162Er", "164Er", "166Er", "167Er", "168Er", "170Er"},
	Thulium -> {"169Tm"},
	Ytterbium -> {"168Yb", "170Yb", "171Yb", "172Yb", "173Yb", "174Yb",
		"176Yb"}, Lutetium -> {"175Lu", "176Lu"},
	Hafnium -> {"174Hf", "176Hf", "177Hf", "178Hf", "179Hf", "180Hf"},
	Tantalum -> {"180Ta", "181Ta"},
	Tungsten -> {"180W", "182W", "183W", "184W", "186W"},
	Rhenium -> {"185Re", "187Re"},
	Osmium -> {"184Os", "186Os", "187Os", "188Os", "189Os", "190Os",
		"192Os"}, Iridium -> {"191Ir", "193Ir"},
	Platinum -> {"190Pt", "192Pt", "194Pt", "195Pt", "196Pt", "198Pt"},
	Gold -> {"197Au"},
	Mercury -> {"196Hg", "198Hg", "199Hg", "200Hg", "201Hg", "202Hg",
		"204Hg"}, Thallium -> {"203Tl", "205Tl"},
	Lead -> {"202Pb", "204Pb", "205Pb", "206Pb", "207Pb", "208Pb",
		"210Pb"}, Bismuth -> {"209Bi"}, Polonium -> {"209Po", "210Po"},
	Astatine -> {"210At", "211At"}, Radon -> {"211Rn", "220Rn", "222Rn"},
	Francium -> {"223Fr"},
	Radium -> {"223Ra", "224Ra", "226Ra", "228Ra"},
	Actinium -> {"227Ac"},
	Thorium -> {"228Th", "229Th", "230Th", "232Th"},
	Protactinium -> {"231Pa"},
	Uranium -> {"232U", "233U", "234U", "235U", "236U", "238U"},
	Neptunium -> {"237Np", "239Np"},
	Plutonium -> {"238Pu", "239Pu", "240Pu", "241Pu", "242Pu", "244Pu"},
	Americium -> {"241Am", "243Am"},
	Curium -> {"243Cm", "244Cm", "245Cm", "246Cm", "247Cm", "248Cm"},
	Berkelium -> {"247Bk", "249Bk"},
	Californium -> {"249Cf", "250Cf", "251Cf", "252Cf"},
	Einsteinium -> {"252Es"}, Fermium -> {"257Fm"},
	Mendelevium -> {"258Md", "260Md"}, Nobelium -> {"259No"},
	Lawrencium -> {"260Lr"}, Sweep -> {Sweep}, Rutherfordium -> {"267Rf"}};

MostAbundantIsotopesList = {Hydrogen -> "1H", Helium -> "4He", Lithium -> "7Li", Beryllium -> "9Be", Boron -> "11B", Carbon -> "12C",
	Nitrogen -> "14N", Oxygen -> "16O", Fluorine -> "19F", Neon -> "20Ne", Sodium -> "23Na", Magnesium -> "24Mg", Aluminum -> "27Al", Silicon -> "28Si",
	Phosphorus -> "31P", Sulfur -> "32S", Chlorine -> "35Cl", Argon -> "40Ar", Potassium -> "39K",
	Calcium -> "40Ca", Scandium -> "45Sc", Titanium -> "48Ti", Vanadium -> "51V", Chromium -> "52Cr", Manganese -> "55Mn",
	Iron -> "56Fe", Cobalt -> "59Co", Nickel -> "60Ni", Copper -> "63Cu", Zinc -> "64Zn", Gallium -> "69Ga", Germanium -> "74Ge",
	Arsenic -> "75As", Selenium -> "80Se", Bromine -> "79Br", Krypton -> "84Kr", Rubidium -> "85Rb", Strontium -> "88Sr", Yttrium -> "89Y",
	Zirconium -> "90Zr", Niobium -> "93Nb", Molybdenum -> "98Mo", Technetium -> "97Tc", Ruthenium -> "102Ru", Rhodium -> "103Rh", Palladium -> "106Pd",
	Silver -> "107Ag", Cadmium -> "114Cd", Indium -> "115In", Tin -> "120Sn", Antimony -> "121Sb", Tellurium -> "130Te", Iodine -> "127I",
	Xenon -> "132Xe", Cesium -> "133Cs", Barium -> "138Ba", Lanthanum -> "139La", Cerium -> "140Ce", Praseodymium -> "141Pr",
	Neodymium -> "144Nd", Promethium -> "145Pm", Samarium -> "152Sm", Europium -> "153Eu", Gadolinium -> "158Gd", Terbium -> "159Tb",
	Dysprosium -> "164Dy", Holmium -> "165Ho", Erbium -> "166Er", Thulium -> "169Tm", Ytterbium -> "174Yb", Lutetium -> "175Lu",
	Hafnium -> "178Hf", Tantalum -> "181Ta", Tungsten -> "184W", Rhenium -> "187Re", Osmium -> "192Os", Iridium -> "193Ir", Platinum -> "195Pt",
	Gold -> "197Au", Mercury -> "202Hg", Thallium -> "205Tl", Lead -> "208Pb", Bismuth -> "209Bi", Polonium -> "209Po", Astatine -> "210At", Radon -> "211Rn",
	Francium -> "223Fr", Radium -> "223Ra", Actinium -> "227Ac", Thorium -> "232Th", Protactinium -> "231Pa", Uranium -> "238U",
	Neptunium -> "237Np", Plutonium -> "238Pu", Americium -> "241Am", Curium -> "243Cm", Berkelium -> "247Bk", Californium -> "249Cf",
	Einsteinium -> "252Es", Fermium -> "257Fm", Mendelevium -> "258Md", Nobelium -> "259No", Lawrencium -> "260Lr", Sweep -> Sweep, Rutherfordium -> "267Rf"};

(*Define function to convert Isotope to Element*)
DefineOptions[icpmsElementFromIsotopes,
	Options :> {
		CacheOption
	}
];
icpmsElementFromIsotopes[MyIsotopes:ListableP[ICPMSNucleusP], ops:OptionsPattern[]] := Module[{elementSymbols, elementName, safeOps, cache},
	safeOps = SafeOptions[icpmsElementFromIsotopes, ToList[ops]];
	cache = Lookup[safeOps, Cache];
	(*Remove digit characters to convert isotope into element symbols, excluding Sweep and make it into list if not already so*)
	elementSymbols = StringDelete[DeleteCases[ToList[MyIsotopes], Sweep],DigitCharacter];
	(*Convert element symbols into name, and remove duplicates; add Sweep back if it presents in input*)
	elementName = If[MemberQ[ToList[MyIsotopes],Sweep],
		Append[DeleteDuplicates[ECLElementData[elementSymbols,Element, Cache -> cache]],Sweep],
		DeleteDuplicates[ECLElementData[elementSymbols,Element, Cache -> cache]]
	]

];

icpmsElementFromIsotopes[{}, ops:OptionsPattern[]] := {};

icpmsElementFromIsotopes[_, ops:OptionsPattern[]] := $Failed;



(*Define function to find all metallic element from a list of packages *)
DefineOptions[findICPMSElements,
	Options :> {
		{Elements -> ICPMS, ICPMS|All, "Indicate if output is all elements, or elements suitable for typical ICPMS."},
		CacheOption
	}
];

findICPMSElements[MyPackets:ListableP[PacketP[{Object[Sample], Model[Sample]}]], ops:OptionsPattern[]] := Module[
	{
		concentrations, moleculeLinks, allCompositions, AllMolecularCompositions, atomList, allMolecules, sanitizedAtomList,
		elementList, defaultElementList, listedOps, elementOption, cache
	},
	listedOps = SafeOptions[findICPMSElements, ToList[ops]];
	elementOption = Lookup[listedOps, Elements];
	cache = Lookup[listedOps, Cache];
	(*Find compositions from packets*)
	allCompositions = Lookup[ToList[MyPackets], Composition];

	(*Remove anything that's not Model[Moleucle]*)
	AllMolecularCompositions = Function[{composition},
		Select[composition, (MatchQ[#[[2]], ObjectP[Model[Molecule]]] &)]
	] /@ allCompositions;

	concentrations = AllMolecularCompositions[[All, All, 1]];
	moleculeLinks = AllMolecularCompositions[[All, All, 2]];
	(* Construct a flattened list of all molecules in Molecule[] form*)
	allMolecules = Download[Flatten[moleculeLinks], Molecule];

	(*Find all atoms from all molecules*)
	atomList = Select[Flatten[Quiet[Simulation`Private`applyDataPacletFix[alternateAtomList /@ allMolecules]]], MatchQ[#, _String] &];
	(*remove all extra information like formal charge, and delete duplicates*)
	sanitizedAtomList = DeleteDuplicates[atomList];

	(*Convert list of Mathematica atoms into element symbols*)
	elementList = ECLElementData[sanitizedAtomList, Element, Cache -> cache];
	defaultElementList = {Lithium,Beryllium,Sodium,Magnesium, Aluminum,Potassium,Calcium,Scandium,Titanium,Vanadium,
		Chromium,Manganese,Iron, Cobalt,Nickel,Copper,Zinc,Gallium,Germanium,Arsenic,Selenium,Rubidium,Strontium,Yttrium,
		Zirconium,Niobium, Molybdenum,Technetium,Ruthenium,Rhodium,Palladium,Silver,Cadmium,Indium,Tin,Antimony,Tellurium,
		Cesium,Barium, Lanthanum,Cerium,Praseodymium,Neodymium,Promethium,Samarium,Europium,Gadolinium,Terbium,Dysprosium,
		Holmium,Erbium,Thulium, Ytterbium,Lutetium,Hafnium,Tantalum,Tungsten,Rhenium,Osmium,Iridium,Platinum,Gold,Mercury,
		Thallium,Lead,Bismuth,Polonium,Francium,Radium,Actinium,Thorium,Protactinium,Uranium,Neptunium,Plutonium,Americium,
		Curium,Berkelium, Californium,Einsteinium,Fermium,Mendelevium,Nobelium,Lawrencium};
	If[MatchQ[elementOption, ICPMS],
		Select[elementList,MemberQ[defaultElementList,#]&],
		elementList
	]
];

(* Overload for empty set input *)
findICPMSElements[{}] := {};

(*Define set of light nuclei which low plasma power should be used *)
(*lightNuclei = Alternatives["6Li", "7Li", "23Na", "39K", "40K", "41K", "85Rb", "87Rb", "133Cs"];*)

(* Define function to find elements and concentrations *)

DefineOptions[findICPMSStandardElements,
	Options :> {
		{Output -> Elements, ListableP[Elements|Concentrations], "Indicates if list of elements or list of concentrations will be returned as output."},
		CacheOption
	}
];

findICPMSStandardElements[MyPackets:ListableP[PacketP[{Object[Sample], Model[Sample]}]], ops:OptionsPattern[]]:= Module[
	{
		concentrations, moleculeLinks, allCompositions, AllMolecularCompositions, atomList, allMolecules, sanitizedAtomList, elementList, cache,
		listedOps, objectList, allAtoms, monoatomicList, allElements, elementConcentrationList, output, objectToElementList, objectToConcentrationList
	},

	listedOps = SafeOptions[findICPMSStandardElements, ToList[ops]];
	output = Lookup[listedOps, Output];
	cache = Lookup[listedOps, Cache];
	(*Find compositions from packets*)
	allCompositions = Lookup[ToList[MyPackets], Composition];
	objectList = Lookup[ToList[MyPackets],Object];

	(*Remove anything that's not Model[Moleucle]*)
	AllMolecularCompositions = Function[{composition},
		Select[composition, (MatchQ[#[[2]], ObjectP[Model[Molecule]]] &)]
	] /@ allCompositions;

	concentrations = AllMolecularCompositions[[All, All, 1]];
	moleculeLinks = AllMolecularCompositions[[All, All, 2]];
	(* Construct a list of all molecules for eack packet in Molecule[] form*)
	allMolecules = Download[moleculeLinks, Molecule];
	(* find the list of atoms for each molecule *)
	allAtoms = (Simulation`Private`applyDataPacletFix[Map[alternateAtomList,#]]&)/@allMolecules;
	(* Construct a list of list of Boolean values indicating whether a molecule in allMolecues is monoatomic *)
	monoatomicList = (Map[
		Function[{molecule},
			Length[molecule] == 1
		], #
	]&) /@ allAtoms;
	(* Now, pick only atoms from monoatomic molecule *)
	allElements = Flatten[
		MapThread[
			PickList[#1,#2]&,
			{allAtoms, monoatomicList}
		]/.<|{}->{{}}|>,
		(* Some weird flatten here to shape allElements into list of list of atoms, outer list index match to sample packets *)
		{1,3}
	]/.<|{} -> {{}}|>;
	(*remove all extra information like formal charge *)
	sanitizedAtomList = allElements;
	
	elementList = ECLElementData[#, Element, Cache -> cache]& /@sanitizedAtomList;
	elementConcentrationList = MapThread[
		PickList[#1,#2]&,
		{concentrations, monoatomicList}
	];
	(* Defines output *)
	objectToElementList = MapThread[#1->#2 &, {objectList, elementList}];
	objectToConcentrationList = MapThread[#1->#2 &, {objectList, elementConcentrationList}];
	output/.{Elements -> objectToElementList, Concentrations -> objectToConcentrationList}
];

(* Overload for empty set input *)
findICPMSStandardElements[{}, ops:OptionsPattern[]] := Module[
	{listedOps, output},
	listedOps = SafeOptions[findICPMSStandardElements, ToList[ops]];
	output = Lookup[listedOps, Output];
	output/.{Elements -> {}, Concentrations -> {}}
];

standardModelSearch[fakeString_]:=standardModelSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`standardModelSearch],
		AppendTo[$Memoization, Experiment`Private`standardModelSearch]
	];
	Search[
		Model[Sample],
		Deprecated != True && DeveloperObject != True && StringContainsQ[Name, "ICP"] && StringContainsQ[Name, "standard", IgnoreCase -> True]
	]
];

DefineOptions[pickBestStandard, Options :>
	{
		{MaxResults -> 1, 0|1|2|3|4|5, "Indicate the maximum number of standards chosen as the output. Minimum number of standards will be chosen to cover all elements whenever possible."}
	}
];

pickBestStandard[desiredElements:{},availableStandards:{___List}, ops:OptionsPattern[]]:={};

pickBestStandard[desiredElements:ListableP[ICPMSElementP], availableStandards:{___List}, ops:OptionsPattern[]]:=Module[
	{
		listedOps, maxResults, allCounts, standardToUse, remainingStandards, remainingDesiredElements
	},
	(* Extract options *)
	listedOps = SafeOptions[pickBestStandard, ToList[ops]];
	maxResults = Lookup[listedOps, MaxResults];

	(* when maxResults == 0, Return empty set *)
	If[maxResults == 0,
		Return[{}]
	];

	(* Find how many desiredElements does each standard contain *)
	allCounts = Count[#, Alternatives@@desiredElements]& /@ availableStandards;

	(* If no standard contain at least one desired element, return empty set *)
	If[Max[allCounts]==0,
		Return[{}]
	];

	(* Find the standard *)
	standardToUse = FirstOrDefault[PickList[availableStandards, allCounts, Max[allCounts]]];

	remainingStandards = DeleteCases[availableStandards, standardToUse, {1}, 1];

	remainingDesiredElements = DeleteCases[desiredElements, Alternatives@@standardToUse];

	If[MatchQ[standardToUse, Null] || MatchQ[availableStandards, {}],
		{},
		{standardToUse, pickBestStandard[remainingDesiredElements, remainingStandards, MaxResults -> (maxResults -1)]}
	]

];

DefineOptions[findICPMSIsotopeConcentrations, Options :>
    {
		{Output -> Isotopes, Elements|Isotopes, "Indicate whether we will output Element/Concentration pair, or Isotope/Concentration pair."},
		CacheOption
	}
];

findICPMSIsotopeConcentrations[myElementAndConcentrationList:ListableP[{ICPMSElementP, ConcentrationP|MassConcentrationP|Missing}], ops:OptionsPattern[]]:= Module[
	{
		elementList, isotopeList, elementMassConcentrationList, isotopeMassConcentrationList, roundedIsotopeMassConcentrationList,
		concentrationList, molarMassList, listedOps, output, roundedElementMassConcentrationList, cache
	},

	listedOps = SafeOptions[findICPMSIsotopeConcentrations, ToList[ops]];
	output = Lookup[listedOps, Output];
	cache = Lookup[listedOps, Cache];

	(* Retrieve the list of elements input *)
	elementList = myElementAndConcentrationList[[All, 1]];
	concentrationList = myElementAndConcentrationList[[All, 2]];

	(* Calculate the molar masses of elements in one single run; this is to avoid mapping Download inside ECLElementData function *)
	molarMassList = ECLElementData[elementList, MolarMass, Cache -> cache];

	(* Convert all molar concentrations to mass concentrations *)
	elementMassConcentrationList = MapThread[
		If[MatchQ[#1, ConcentrationP],
			Convert[#2*#1, Gram/Liter],
			#1
		]&,
		{concentrationList, molarMassList}
	];

	(* Construct a list of isotopes supported by ICPMS, index-matched to elementList *)

	isotopeList = elementList/.ICPMSIsotopesList;

	(* Construct a list of isotope mass concentrations, index-matched to elementList *)
	isotopeMassConcentrationList = MapThread[
		Function[{isotopes, concentration},
			If[MatchQ[concentration, MassConcentrationP],
				Convert[ECLIsotopeData[isotopes, IsotopeAbundance, Cache -> cache] * concentration, Gram/Liter],
				Table[Missing, Length[isotopes]]
			]
		],
		{isotopeList, elementMassConcentrationList}
	];

	(* round output concentration to 5 sig figs *)
	roundedIsotopeMassConcentrationList = SetPrecision[isotopeMassConcentrationList, 5];
	roundedElementMassConcentrationList = SetPrecision[elementMassConcentrationList, 5];

	(* Flatten isotopeList and isotopeMassConcentrationList as output *)
	If[MatchQ[output, Elements],
		Transpose[{Flatten[elementList], Flatten[elementMassConcentrationList]}],
		Transpose[{Flatten[isotopeList], Flatten[isotopeMassConcentrationList]}]
	]
];
findICPMSIsotopeConcentrations[ListableP[{}|{{},{}}], ops:OptionsPattern[]]:= Null;
findICPMSIsotopeConcentrations[myElementAndConcentrationList:ListableP[{ICPMSNucleusP, ConcentrationP|MassConcentrationP|Missing}], ops:OptionsPattern[]]:= Module[
	{isotopeList, isotopeMassConcentrationList, roundedIsotopeMassConcentrationList, isotopeMolarMassList, listedOps, cache},
	(* Convert all molar concentrations to mass concentrations *)
	listedOps = SafeOptions[findICPMSIsotopeConcentrations, ToList[ops]];
	cache = Lookup[listedOps, Cache];
	isotopeList = myElementAndConcentrationList[[All, 1]];
	isotopeMolarMassList = ECLIsotopeData[isotopeList, IsotopeMasses, Cache -> cache];

	isotopeMassConcentrationList = MapThread[
		If[MatchQ[#1, ConcentrationP],
			Convert[#2*#1, Gram/Liter],
			#1
		]&,
		{myElementAndConcentrationList[[All,2]], isotopeMolarMassList}
	];

	(* round output concentration to 5 sig figs *)
	roundedIsotopeMassConcentrationList = SetPrecision[isotopeMassConcentrationList, 5];
	(* Flatten isotopeList and isotopeMassConcentrationList as output *)
	Transpose[{Flatten[isotopeList], Flatten[roundedIsotopeMassConcentrationList]}]
];

(* Define function pickBestInternalStandard *)
(* So, unlike pickBestStandard, this function try to find one single standard while try to avoid certain elements *)
(* It is worth noting that some elements, i.e., elements in Elements option with InternalStandardElement -> False, should be strictly avoided *)
(* That is enforced by filtering out standards containing those elements *)
(* The first input, on the other hand, are elements should be avoided when possible, but it's fine for the final output *)
(* to contain some of them, as long as it also contain at least one other element *)
pickBestInternalStandard[undesiredElements:ListableP[ICPMSElementP]|{}, availableStandards:{___List}]:=Module[
	{listedOps, goodCounts, standardToUse, elementForInternalStandardElement},

	(* Find out how many elements does each standard contain other than undesiredElements *)
	goodCounts = Length[Complement[#, undesiredElements]]& /@ availableStandards;

	(* If no standard contains any element other than undesiredElements, return {} *)
	If[Max[goodCounts]==0,
		Return[{Null, {}}]
	];

	(* Otherwise, find the standard *)
	standardToUse = FirstOrDefault[PickList[availableStandards, goodCounts, Max[goodCounts]]];

	(* Find an element as internal standard element, wrap it with {} to make it a list of a single member *)
	elementForInternalStandardElement = If[!NullQ[standardToUse],
		{RandomChoice[Complement[standardToUse, undesiredElements]]},
		{}
	];

	(* Return the result as {standard, elements} pair *)
	{standardToUse, elementForInternalStandardElement}
];

(* expandICPMSReplicates helper *)
expandICPMSReplicates[mySamples:{ObjectP[]...},options:{(_Rule|_RuleDelayed)..},numberOfReplicates:(_Integer|Null)]:= Module[
	{samplesWithReplicates,mapThreadOptions,optionsWithReplicates},

	(* Repeat the inputs if we have replicates *)
	samplesWithReplicates = If[MatchQ[numberOfReplicates, Null],
		mySamples,
		Flatten[Map[ConstantArray[#, numberOfReplicates]&, mySamples], 1]
	];

	(* Determine options index-matched to the input *)
	mapThreadOptions =Lookup[Select[OptionDefinition[ExperimentICPMS],MatchQ[Lookup[#,"IndexMatchingInput"],Except[Null]]&],"OptionSymbol"];

	(* Repeat MapThread options if we have replicates *)
	optionsWithReplicates=Map[
		If[MemberQ[mapThreadOptions,First[#]],
			First[#]->duplicateICPMSReplicates[Last[#],numberOfReplicates],
			First[#]->Last[#]
		]&,
		options
	];

	{samplesWithReplicates,optionsWithReplicates}
];

(* == duplicateICPMSReplicates HELPER == *)
(* Helper for expandICPMSReplicates. Given non-expanded sample input, and the numberOfReplicate, repeat the inputs if we have replicates *)
duplicateICPMSReplicates[value_,numberOfReplicates_]:=Module[{},
	If[MatchQ[numberOfReplicates,Null],
		value,
		Flatten[Map[ConstantArray[#,numberOfReplicates]&,value],1]
	]
];

(* toEndOrNoAction helper *)
(* Helper function to move all Sweep-related options to the end *)
toEndOrNoAction[myList_List, myPart_Integer]:=Module[{tempVar},
	tempVar = If[myPart == 0,
		Null,
		myList[[myPart]]
	];
	If[myPart == 0,
		myList,
		Append[Delete[myList, myPart], tempVar]
	]
];


alternateAtomList[myMolecule_Molecule] := Module[{elementCount, allElementCount, atomList},
	elementCount = Simulation`Private`getElementCount[myMolecule];
	allElementCount = elementCount[[1]];
	atomList = Table[#[[1]], #[[2]]]& /@ allElementCount;
	Flatten[atomList]
];