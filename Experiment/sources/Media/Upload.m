(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Constants*)


DefineConstant[
	$MinMediaFilterVolume,
	2 Milliliter,
	"The minimum volume of media that can be filtered by supported filtration methods without unreasonable dead volume."
];

DefineConstant[
	$MinMediapHVolume,
	20 Milliliter,
	"The minimum volume of media that can be pH titrated using the available pH probes."
];

DefineConstant[
	$MinMediaSolventVolume,
	5 Milliliter,
	"The minimum total volume a fill-to-volume media can have to ensure accurate ultrasonic distance measurements during filling to volume."
];
DefineConstant[
	$MaxMediaSolventVolume,
	20 Liter,
	"The maximum total volume a fill-to-volume media can have to ensure accurate ultrasonic distance measurements during filling to volume."
];

DefineConstant[
	$MinMediaComponentVolume,
	0.1 Microliter,
	"The minimum volume of a component that will be included in a media."
];

DefineConstant[
	$MaxMediaComponentVolume,
	20 Liter,
	"The maximum volume of a component that will be included in a media."
];

DefineConstant[
	$MinMediaComponentMass,
	1.0 Milligram,
	"The minimum mass of a component that will be included in a media."
];

DefineConstant[
	$MaxMediaComponentMass,
	10 Kilogram,
	"The maximum mass of a component that will be included in a media."
];



(* ::Subsection:: *)
(*UploadMedia*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadMedia,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->StockSolutionTemplate,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Media]}]
				],
				Description->"The existing media model whose mixing, pH Titration, filtration, storage, and health/safety information should be used as defaults when creating a new media model.",
				Category->"Organizational Information"
			},
			{
				OptionName->MediaName,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern :> _String,
					Size->Line,
					BoxText->Null
				],
				Description->"The name that should be given to the media model generated from the provided formula.",
				Category->"Organizational Information"
			},
			{
				OptionName->Synonyms,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					Widget[
						Type->String,
						Pattern:>_String,
						Size->Word
					]
				],
				Description->"A list of possible alternate names that should be associated with this new media.",
				ResolutionDescription->"Automatically resolves to contain the Name of the media model, if one is provided.",
				Category->"Organizational Information"
			},
			{
				OptionName->Composition,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[{
					"Amount"->Alternatives[
						Widget[
							Type->Quantity,
							Pattern:>Alternatives[
								GreaterP[0 Molar],
								GreaterP[0 Gram/Liter],
								RangeP[0 VolumePercent,100 VolumePercent],
								RangeP[0 MassPercent,100 MassPercent],
								RangeP[0 PercentConfluency,100 PercentConfluency],
								GreaterP[0 Cell/Liter]
							],
							Units->Alternatives[
								{1,{Molar,{Micromolar,Millimolar,Molar}}},
								CompoundUnit[
									{1,{Gram,{Kilogram,Gram,Milligram,Microgram}}},
									{-1,{Liter,{Liter,Milliliter,Microliter}}}
								],
								{1,{VolumePercent,{VolumePercent}}},
								{1,{MassPercent,{MassPercent}}},
								{1,{PercentConfluency,{PercentConfluency}}},
								CompoundUnit[
									{1,{EmeraldCell,{EmeraldCell}}},
									{-1,{Milliliter,{Liter,Milliliter,Microliter}}}
								]
							]
						],
						Widget[
							Type->Enumeration,
							Pattern :> Alternatives[Null]
						]
					],
					"Identity Model"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[List@@IdentityModelTypeP]],
						Widget[
							Type->Enumeration,
							Pattern :> Alternatives[Null]
						]
					]
				}],
				Description->"The molecular composition of this model.",
				Category->"Organizational Information"
			},
			{
				OptionName->Supplements,
				Default->None,
				Description->"Additional substances that would traditionally appear in the name of the media, such as 2% Ampicillin in LB + 2% Ampicillin. These components will be added to the Formula field of the Model[Sample,Media] but are specially called out in the media name following the \"+\" symbol. For example, ExperimentMedia[Model[Sample,Media,\"Liquid LB\"], Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter}] will create a new Model[Sample,Media,\"Liquid LB + Ampicillin, 50*Microgam/Liter\"] with Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter} added to the Formula of the input media.",
				AllowNull->False,
				Category->"General",
				Widget->Alternatives[
					Adder[
						{
							"Amount"->Alternatives[
								Widget[
									Type->Quantity,
									Pattern:>RangeP[0.1*Microliter,20*Liter],
									Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
								],
								Widget[
									Type->Quantity,
									Pattern:>RangeP[1*Milligram,20*Kilogram],
									Units->{1,{Milligram,{Milligram,Gram,Kilogram}}}
								],
								Widget[
									Type->Quantity,
									Pattern:>RangeP[10*Milligram/Liter,10*Kilogram/Liter],
									Units->CompoundUnit[
										{1,{Milligram,{Microgram,Milligram,Gram,Kilogram}}},
										{-1,{Milliliter,{Microliter,Milliliter,Liter}}}
									]
								],
								Widget[
									Type->Number,
									Pattern:>GreaterP[0., 1.]
								]
							],
							"Supplement"->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
							]
						}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]
					]
				],
				ResolutionDescription->"Automatically set to None if media formula is provided as input."
			},
			{
				OptionName->DropOuts,
				Default->None,
				Description->"Substances from the Formula of ModelMedia that are completely excluded in the preparation of media. When specified, a new Model[Sample,Media] will be created with Formula that excludes these components from the Formula of the input media model. For example, if the user calls ExperimentMedia[Model[Sample,Media,\"Synthetic Complete Medium\"], DropOuts->Model[Molecule,\"Uracil\"], a new Model[Sample,Media,\"Synthetic Complete Medium - Uracil] will be created whose Formula corresponds to the Formula of Model[Sample,Media,\"Synthetic Complete Medium\"] lacking Uracil.",
				AllowNull->False,
				Widget->Alternatives[
					Adder[
						Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Molecule],Model[Sample]}]
						]
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]
					]
				]
			},
			{
				OptionName->GellingAgents,
				Default->Automatic,
				Description->"The types and amount by weight volume percentages of substances added to solidify the prepared media.",
				AllowNull->True,
				Category->"General",
				Widget->Alternatives[
					Adder[
						{
							"Amount"->Alternatives[
								Widget[
									Type->Quantity,
									Pattern:>RangeP[0.1*Microliter,20*Liter],
									Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
								],
								Widget[
									Type->Quantity,
									Pattern:>RangeP[1*Milligram,20*Kilogram],
									Units->{1,{Milligram,{Milligram,Gram,Kilogram}}}
								],
								Widget[
									Type->Quantity,
									Pattern:>RangeP[10*Milligram/Liter,10*Kilogram/Liter],
									Units->CompoundUnit[
										{1,{Milligram,{Microgram,Milligram,Gram,Kilogram}}},
										{-1,{Milliliter,{Microliter,Milliliter,Liter}}}
									]
								],
								Widget[
									Type->Number,
									Pattern:>GreaterP[0., 1.]
								]
							],
							"GellingAgent"->Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
							]
						}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				],
				ResolutionDescription->"Automatically set to {Model[Sample, \"Agar\"], 20*Gram/Liter} if MediaPhase is set to Solid and there is no GellingAgent present in the Formula field. If any GellingAgent is detected in the Formula field of Model[Sample,Media] and the GellingAgents option has been specified, the former will be removed from the Formula and replaced with GellingAgents."
			},
			{
				OptionName->MediaPhase,
				Default->Automatic,
				Description->"The physical state of the prepared media at ambient temperature and pressure." (*TODO update description to explain SemiSolid *),
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[MediaPhaseP]
				],
				ResolutionDescription->"Automatically set to Liquid if GellingAgents is not specified."
			},

			(* --- Incubation --- *)
			{
				OptionName->Incubate,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media should be incubated following component combination and filling to volume with solvent, either while mixing (if Mix->True) or without mixing (if Mix->False).",
				ResolutionDescription->"Automatically resolves to True if any other incubate options are specified, or, if a template model is provided, resolves based on whether that template has incubation parameters.",
				Category->"Incubation"
			},
			{
				OptionName->IncubationTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[22 Celsius,$MaxIncubationTemperature],
						Units->Alternatives[Fahrenheit, Celsius]
					],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				Description->"Temperature at which the media should be incubated for the duration of the IncubationTime following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to the maximum temperature allowed for the incubator and container. Resolves to 37 Celsius if the sample is being incubated, or Null if Incubate is set to False.",
				Category->"Incubation"
			},
			{
				OptionName->IncubationTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Minute, $MaxExperimentTime],
					Units->{1,{Minute,{Minute,Hour}}}
				],
				Description->"Duration for which the media should be incubated at the IncubationTemperature following component combination and filling to volume with solvent. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the MixTime option.",
				ResolutionDescription->"Automatically resolves to 0.5 Hour if Incubate is set to True and Mix is set to False, or Null otherwise.",
				Category->"Incubation"
			},

			(* --- Mixing --- *)
			{
				OptionName->Mix,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media should be mixed following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to True for a new formula, or, if a template model is provided, resolves based on whether that template has mixing parameters.",
				Category->"Mixing"
			},
			{
				OptionName->MixUntilDissolved,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if the media should be mixed in an attempt to completed dissolve any solid components following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to False if Mix is set to True, or to Null if Mix is set to False.",
				Category->"Mixing"
			},
			{
				OptionName->MixTime,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[
					Type->Quantity,
					Pattern :> GreaterEqualP[0 Minute],
					Units->{1,{Minute,{Minute,Hour}}}
				],
				Description-> "The duration for which the media should be mixed following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to 5 minutes for the Roll, Rock, Vortex, Sonicate, and Stir mix types; resolves to Null for Pipette and Invert mix types. Automatically resolves to Null if Mix is set to False. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the IncubationTime option.",
				Category->"Mixing"
			},
			{
				OptionName->MaxMixTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Second,$MaxExperimentTime],
					Units->{1,{Minute,{Second,Minute,Hour}}}
				],
				Description->"The maximum duration for which the media should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves based on whether MixUntilDissolved is set to True. If MixUntilDissolved is False, resolves to Null.",
				Category->"Mixing"
			},
			{
				OptionName->MixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> MixTypeP
				],
				Description->"The style of motion used to mix the media following component combination and filling to volume with solvent. If this media model is ever prepared at a volume such that this form of mixing is no longer possible, another mix type may be used instead.",
				ResolutionDescription->"Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
				Category->"Mixing"
			},
			{
				OptionName->Mixer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[MixInstrumentModels]
				],
				Description->"The instrument that should be used to mix the media following component combination and filling to volume with solvent. If this media model is ever prepared at a volume such that this mixer cannot properly mix the solution, another mixer may be used instead.",
				ResolutionDescription->"Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
				Category->"Mixing"
			},
			{
				OptionName->MixRate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[$MinMixRate, $MaxMixRate],
					Units->RPM
				],
				Description->"The frequency of rotation the mixing instrument should use to mix the medias following component combination and filling to volume with solvent. If this media model is ever prepared at a volume such that its mixer cannot mix and this rate, another rate may be chosen in accordance with the mixer used instead.",
				ResolutionDescription->"Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
				Category->"Mixing"
			},
			{
				OptionName->NumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description->"Number of times the samples should be mixed if MixType: Pipette or Invert, is chosen.",
				ResolutionDescription->"Automatically, resolves based on the MixType.",
				Category->"Mixing"
			},
			{
				OptionName->MaxNumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description->"Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
				ResolutionDescription->"Automatically resolves based on the MixType and container of the sample.",
				Category->"Mixing"
			},

			(* --- pH Titration ---  *)
			{
				OptionName->AdjustpH,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if the pH of this media should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set to True if any other pHing options are specified, or if NominalpH is specified in the template model, or False otherwise.",
				Category->"pH Titration"
			},
			{
				OptionName->NominalpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern :> RangeP[0,14]
				],
				Description->"The pH to which this media should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves based on the NominalpH of the template model, or 7 if AdjustpH is True, or to Null otherwise.",
				Category->"pH Titration"
			},
			{
				OptionName->MinpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern :> RangeP[0,14]
				],
				Description->"The minimum allowable pH this media should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent and/or mixing.",
				ResolutionDescription->"Automatically resolves to 0.1 below the NominalpH if specified, or to Null if NominalpH is Null.",
				Category->"pH Titration"
			},
			{
				OptionName->MaxpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern :> RangeP[0, 14]
				],
				Description->"The maximum allowable pH this media should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves to 0.1 above the NominalpH if specified, or to Null if NominalpH is Null.",
				Category->"pH Titration"
			},
			{
				OptionName->pHingAcid,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Model[Sample]]
				],
				Description->"The acid that should be used to adjust the pH of the solution downwards following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves to 2 M HCl if any pHing options are specified, or to Null if NominalpH is Null.",
				Category->"pH Titration"
			},
			{
				OptionName->pHingBase,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Sample]]
				],
				Description->"The base that should be used to adjust the pH of the solution upwards following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves to 1.85 M NaOH if any pHing options are is specified, or to Null if NominalpH is Null.",
				Category->"pH Titration"
			},
			{
				OptionName->MaxNumberOfpHingCycles,
				Default->Automatic,
				Description->"Indicates the maximum number of additions to make before stopping pH titrations during the course of titration before the experiment will continue, even if the nominalpH is not reached.",
				ResolutionDescription->"Automatically resolves to Null for a new formula, or to the same as the MaxNumberOfpHingCycles of a provided template model.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,50]
				]
			},
			{
				OptionName->MaxpHingAdditionVolume,
				Default->Automatic,
				Description->"Indicates the maximum volume of pHingAcid and pHingBase that can be added during the course of titration before the experiment will continue, even if the nominalpH is not reached.",
				ResolutionDescription->"Automatically resolves to Null for a new formula, or to the same as the MaxpHingAdditionVolume of a provided template model.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Microliter,20 Liter],
					Units->{Milliliter, {Microliter, Milliliter, Liter}}
				]
			},
			{
				OptionName->MaxAcidAmountPerCycle,
				Default->Automatic,
				Description->"Indicates the maximum amount of pHingAcid that can be added in a single titration cycle.",
				ResolutionDescription->"Automatically resolves to Null for a new formula, or to the same as the MaxAcidAmountPerCycle of a provided template model.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Alternatives[
					"Mass"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milligram, 1 Kilogram],
						Units->{Gram, {Milligram, Gram, Kilogram}}
					],
					"Volume"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milliliter, 20 Liter],
						Units->{Milliliter, {Microliter, Milliliter, Liter}}
					]
				]
			},
			{
				OptionName->MaxBaseAmountPerCycle,
				Default->Automatic,
				Description->"Indicates the maximum amount of pHingAcid that can be added in a single titration cycle.",
				ResolutionDescription->"Automatically resolves to Null for a new formula, or to the same as the MaxBaseAmountPerCycle of a provided template model.",
				AllowNull->True,
				Category->"pHing Limits",
				Widget->Alternatives[
					"Mass"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milligram, 1 Kilogram],
						Units->{Gram, {Milligram, Gram, Kilogram}}
					],
					"Volume"->Widget[
						Type->Quantity,
						Pattern :> RangeP[0 * Milliliter, 20 Liter],
						Units->{Milliliter, {Microliter, Milliliter, Liter}}
					]
				]
			},

			(* --- Filtration ---*)
			{
				OptionName->Filter,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or, if a template model is provided, resolves based on whether that template has filtration parameters.",
				Category->"Filtration"
			},
			{
				OptionName->FilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> FilterMembraneMaterialP
				],
				Description->"The material through which the media should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a material for which filters exist, or to Null if Filter is set to False.",
				Category->"Filtration"
			},
			{
				OptionName->FilterSize,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> FilterSizeP
				],
				Description->"The size of the membrane pores through which the media should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a membrane pore size for which filters exist, or to Null if Filter is set to False.",
				Category->"Filtration"
			},

			{
				OptionName->Autoclave,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates that this media should be autoclaved once all components are added.",
				Category->"Autoclaving"
			},
			{
				OptionName->AutoclaveProgram,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>AutoclaveProgramP
				],
				Description->"Indicates the type of autoclave cycle to run. Liquid cycle is recommended for liquid samples, and Universal cycle is recommended for everything else.",
				ResolutionDescription->"The AutoclaveProgram automatically resolves to Liquid if the Autoclave option is set to True for a given media",
				Category->"Autoclaving"
			},

			(* --- Storage Information --- *)
			{
				OptionName->OrderOfOperations,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					Widget[Type->Enumeration, Pattern:>Alternatives[FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration]]
				],
				Description->"The order in which the media should be created. By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped.",
				ResolutionDescription->"By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped.",
				Category->"Preparation Information"
			},
			{
				OptionName->FillToVolumeMethod,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> FillToVolumeMethodP
				],
				Description->"The method by which to add the Solvent to the bring the media up to the TotalVolume.",
				ResolutionDescription->"Resolves to Null if there is no Solvent/TotalVolume. Resolves to Ultrasonic if the Solvent is not UltrasonicIncompatible. Otherwise, will resolve to Volumetric. If Ultrasonic measurment is not possible, the solution will be prepared via VolumetricFlask.",
				Category->"Preparation Information"
			},
			{
				OptionName->VolumeIncrements,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern :> RangeP[$MinMediaComponentVolume,$MaxMediaComponentVolume],
						Units->Alternatives[Milliliter, Microliter, Liter]
					],
					Adder[
						Widget[
							Type->Quantity,
							Pattern :> RangeP[$MinMediaComponentVolume,$MaxMediaComponentVolume],
							Units->Alternatives[Milliliter, Microliter, Liter]
						]
					],
					Widget[
						Type->Enumeration,
						Pattern :> Alternatives[{}]
					]
				],
				Description->"A list of volumes at which this media can be prepared.  If specified, requested volume will be scaled up to the next highest VolumeIncrement (or multiple of the highest VolumeIncrement).",
				ResolutionDescription->"If using a fixed aliquot component, will resolve to total volume of the media model. If using a tablet component, resolves to the smallest volume that can be obtained without needing to divide a tablet.  Otherwise resolves to Null.",
				Category->"Preparation Information"
			},
			{
				OptionName->Resuspension,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if one of the components in the media is a sample which can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps.",
				ResolutionDescription->"Automatically resolves to True if one of the components is a FixedAmount sample. Otherwise, automatic resolves to False.",
				Category->"Preparation Information"
			},
			{
				OptionName->PrepareInResuspensionContainer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicate if the media should be prepared in the original container of the FixedAmount component in its formula. PrepareInResuspensionContainer cannot be True if there is no FixedAmount component in the formula, and it is not possible if the specified amount does not match the component's FixedAmount. PrepareInResuspensionContainer cannot be True if the MediaModel is specified by UnitOperations.",
				ResolutionDescription->"Automatically resolves to False unless otherwise specified.",
				Category->"Preparation Information"
			},
			(*TODO: right not fulfillment scale is not kept in the model (but we are downloading it). eventually we will want to add it. *)
			{
				OptionName->FulfillmentScale,
				Default->Dynamic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Dynamic,Fixed]
				],
				Description->"Indicates if the media should be dynamically scaled to any required scale, or restricted to the specified VolumeIncrements (or multiple of the highest VolumeIncrement).",
				ResolutionDescription->"Defaults to Dynamic if no VolumeIncrements are specified, or Fixed if VolumeIncrements are provided.",
				Category->"Hidden"
			},
			{
				OptionName->PreferredContainers,
				Default->Automatic,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern :> Alternatives[{}]
					],
					Adder[
						Widget[
							Type->Object,
							Pattern :> ObjectP[Model[Container,Vessel]]
						]
					]
				],
				Description->"A list of containers that should be selected from first, when choosing a container to store this media, as long as the volume involved is within the range of the PreferredContainer's Min and Max volumes.",
				ResolutionDescription->"Will default to any PreferredContainers found in StockSolutionTemplate, otherwise it will default to Null",
				Category->"Preparation Information"
			},
			{
				OptionName -> HeatSensitiveReagents,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
					]
				],
				Description -> "Indicates that the given component of the formula is heat-sensitive and therefore must be added after autoclave.",
				Category -> "Preparation Information"
			},
			{
				OptionName -> GraduationFilling,
				Default -> False,
				AllowNull -> False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the Solvent specified in the stock solution model is added to bring the stock solution model up to the TotalVolume based on the horizontal markings on the container indicating discrete volume levels, not necessarily in a volumetric flask.",
				Category -> "Preparation"
			},
			{
				OptionName->LightSensitive,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if the media contains components that may be degraded or altered by prolonged exposure to light, and thus should be prepared in light-blocking containers when possible.",
				ResolutionDescription->"Automatically resolves based on the light sensitivity of the formula components and solvent.",
				Category->"Storage Information"
			},
			{
				OptionName->Expires,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if media samples of this model expire after a given amount of time.",
				ResolutionDescription->"Automatically resolves based on the Expires property of the template model, or to True if no template is provided.",
				Category->"Storage Information"
			},
			{
				OptionName -> DiscardThreshold,
				Default -> 5 Percent,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent], Units -> {1, {Percent, {Percent}}}
				],
				Description -> "The percent of the total initial volume of samples of this media below which the stock solution will automatically marked as AwaitingDisposal.  For instance, if DiscardThreshold is set to 5% and the initial volume of the media was set to 100 mL, that media sample is automatically marked as AwaitingDisposal once its volume is below 5mL.",
				Category -> "Storage Information"
			},
			{
				OptionName->ShelfLife,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Day],Units->{1,{Month,{Hour,Day,Month,Year}}}
				],
				Description->"The length of time after preparation that medias of this model are recommended for use before they should be discarded.",
				ResolutionDescription->"If Expires is set to True, automatically resolves to the shortest of any shelf lives of the formula components and solvent, or 5 years if none of the formula components expire. If Expires is set to False, resolves to Null.",
				Category->"Storage Information"
			},
			{
				OptionName->UnsealedShelfLife,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Day],Units->{1,{Day,{Month,Day,Month,Year}}}
				],
				Description->"The length of time after DateUnsealed that medias of this model are recommended for use before they should be discarded.",
				ResolutionDescription->"If Expires is set to True, automatically resolves to the shortest of any unsealed shelf lives of the formula components and solvent, or Null if none of the formula components have recorded unsealed shelf lives. If Expires is set to False, resolves to Null.",
				Category->"Storage Information"
			},
			{
				OptionName->DefaultStorageCondition,
				Default->Refrigerator,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>(AmbientStorage|Refrigerator|Freezer|DeepFreezer)
					],
					Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
				],
				Description->"The condition in which medias of this model are stored when not in use by an experiment.",
				ResolutionDescription->"Automatically resolves based on the default storage conditions of the formula components and any safety information provided for this solution.",
				Category->"Storage Information"
			},
			{
				OptionName->TransportTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					"Transport Cold" -> Widget[Type -> Quantity, Pattern :> RangeP[-86 Celsius, 10 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
					"Transport Warmed" -> Widget[Type -> Quantity, Pattern :> RangeP[27 Celsius, 105 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}]
				],
				Description->"Indicates the temperature by which medias prepared according to the provided formula should be heated or chilled during transport when used in experiments.",
				Category->"Storage Information"
			},

			(* ExperimentPlateMedia options *)
			{
				OptionName->PlateMedia,
				Default->Automatic,
				Description->"Indicates if the prepared media is subsequently transferred to plates for future use for cell incubation and growth.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				ResolutionDescription->"Automatically set to True if MediaPhase is set to Solid or SemiSolid and/or if GellingAgents is specified."
			},

			(* Physical Properties *)
			{
				OptionName->Density,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[(0*Gram)/Milliliter],
					Units->CompoundUnit[
						{1,{Gram,{Kilogram,Gram}}},
						Alternatives[
							{-3,{Meter,{Centimeter,Meter}}},
							{-1,{Liter,{Milliliter,Liter}}}
						]
					]
				],
				Description->"Known density of this component mixture at room temperature.",
				ResolutionDescription->"Automatically resolves to the same density as the template model, or to Null if no template is provided.",
				Category->"Physical Properties"
			},
			{
				OptionName->ExtinctionCoefficients,
				Default->Null,
				AllowNull->True,
				Widget->Adder[
					{
						"Wavelength"->Widget[
							Type->Quantity,
							Pattern:>GreaterP[0*Nanometer],
							Units->{1,{Nanometer,{Nanometer}}}
						],
						"ExtinctionCoefficient"->Widget[
							Type->Quantity,
							Pattern:>GreaterP[0 Liter/(Centimeter*Mole)],
							Units->CompoundUnit[
								{1,{Liter,{Liter}}},
								{-1,{Centimeter,{Centimeter}}},
								{-1,{Mole,{Mole}}}
							]
						]
					}
				],
				Description->"A measure of how strongly this chemical absorbs light at a particular wavelength.",
				Category->"Physical Properties"
			},

			(* --- Health & Safety --- *)
			{
				OptionName->Ventilated,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if medias of this model must be handled in a ventilated enclosure.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or to the same as the Ventilated property of a provided template model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Flammable,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if medias of this model are easily set aflame under standard conditions.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or to the same as the Flammable property of a provided template model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Acid,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if medias of this model are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or to the same as the Acid property of a provided template model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Base,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if medias of this model are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or to the same as the Base property of a provided template model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Fuming,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if medias of this model emit fumes spontaneously when exposed to air.",
				ResolutionDescription->"Automatically resolves to False for a new formula, or to the same as the Fuming property of a provided template model.",
				Category->"Health & Safety"
			},

			(* --- Compatibility --- *)
			{
				OptionName->IncompatibleMaterials,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					With[{insertMe=Flatten[MaterialP]},Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[insertMe]]],
					Widget[Type->Enumeration, Pattern:>Alternatives[{None}]]
				],
				Description->"A list of materials that would be damaged if contacted by this model.",
				ResolutionDescription->"Automatically resolves to None for a new formula, or to the same as the IncompatibleMaterials listing of a provided template model.",
				Category->"Compatibility"
			},
			{
				OptionName->UltrasonicIncompatible,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if medias of this model cannot have their volumes measured via the ultrasonic distance method due to vapors interfering with the reading.",
				ResolutionDescription->"Automatically resolves to True if 50% or more of the volume consists of models that are also UltrasonicIncompatible, or to the same as the UltrasonicIncompatible listing of a provided template model.",
				Category->"Compatibility"
			},
			{
				OptionName->CentrifugeIncompatible,
				Default->False,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if centrifugation should be avoided for medias of this model.",
				Category->"Compatibility"
			},
			{
				OptionName->SafetyOverride,
				Default->False,
				Description-> "Indicates if the automatic safety checks should be overridden when making sure that the order of component additions does not present a laboratory hazard (e.g. adding acids to water vs water to acids). If this option is set to True, you are certifying that you are sure the order of component addition specified will not cause a safety hazard in the lab.",
				AllowNull->True,
				Category->"Compatibility",
				Widget->Widget[Type->Enumeration, Pattern :> BooleanP]
			},

			(* this option will be used only when UploadMedia is called in *)
			{
				OptionName->Preparable,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if the media can be prepared by ExperimentMedia.",
				Category->"Hidden"
			},

			(* Hidden option for when called via ExperimentMedia via Engine to ensure that a newly-generated model gets the author of the protocol *)
			{
				OptionName->Author,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Object[User]]
				],
				Description->"The author of the root protocol that who should be listed as author of a new media model created by this function. This option is intended to be passed from ExperimentMedia when it is called by ResourcePicking in Engine only.",
				Category->"Hidden"
			}
		],
		UploadOption,
		FastTrackOption,
		CacheOption,
		OutputOption,
		SimulationOption
	}
];

(* Helper function to establish if the target is present in the composition *)
targetPresentInComposition[KeyValuePattern[{Composition->list_}],target:ObjectP[Model[Molecule]]] := MemberQ[list,{CompositionP,ObjectP[target]}];

(* Helper function to establish if the target is present in the formula *)
targetPresentInFormula[KeyValuePattern[{Formula->list_}],{Alternatives[CompositionP,MassP,VolumeP,GreaterP[0,1.]],target:ObjectP[{Model[Sample],Object[Sample]}]}] := MemberQ[list,{_,ObjectP[target]}];

(* Helper function to specify any supplements that are not already present in the template formula *)
newSupplementToTemplateMediaFormula[formulaList:___Association, value_] :=
	If[!targetPresentInFormula[formulaList,value], value, Nothing];

(* Helper function to identify any dropouts that are not already present in the template formula *)
dropOutTargetsMissingFromTemplate[templatePacket:KeyValuePattern[{Composition->list_,Object->templateModel_}] | Null,targets:{ObjectP[Model[Molecule]]...}|None]:=Module[{},
	If[!NullQ[templatePacket] && !MatchQ[targets,None],
		Map[
			If[!MemberQ[list,{CompositionP,ObjectP[#]}],
				#,
				Nothing
			]&,targets
		],
		{}
	]
];

(* Helper function to get composition from concentrations into absolute amounts *)
convertCompositionToAmount[supplement:{composition:(MassConcentrationP|MassP|VolumeP),sample:ObjectP[Model[Sample]]},totalVolume:VolumeP]:=Module[{amount},
	amount = Which[
		MatchQ[composition,(MassP|VolumeP)],
		composition,

		MatchQ[composition,MassConcentrationP],
		composition*totalVolume
	];
	{amount,sample}
];

(* Helper function to add supplements to the template formula *)
addSupplementsToTemplateFormula[
	templatePacket:KeyValuePattern[{Formula->list_,TotalVolume->volume_}] | Null,
	templateFormula:{{VolumeP| MassP | NumericP | Null, ObjectP[{Model[Sample],Object[Sample]}]}..},
	supplements:{{_Quantity,ObjectP[{Model[Sample],Object[Sample]}]}...}|None
]:=Module[{supplementsWithAmount,supplementPresentInFormulaQs,redundantSupplements,newFormulaWithSupplements},
	supplementsWithAmount = If[!NullQ[templatePacket]&&!MatchQ[supplements,None],
		Map[convertCompositionToAmount[#,volume]&,supplements],
		{}
	];
	supplementPresentInFormulaQs = If[!NullQ[templatePacket],
		Map[targetPresentInFormula[templatePacket,#]&,supplementsWithAmount],
		ConstantArray[False,Length[supplementsWithAmount]]
	];
	redundantSupplements = PickList[supplementsWithAmount,supplementPresentInFormulaQs];
	newFormulaWithSupplements = If[!NullQ[templatePacket],
		First[removeLinks[Join[list,supplementsWithAmount],{}]],
		templateFormula
	];
	{newFormulaWithSupplements,redundantSupplements}
];

(* Helper function to spit out a final formula with supplements *)
finalFormulaWithSupplements[templatePacket:KeyValuePattern[{Formula->list_}]]:=Module[{groupedFormula,groupedFormulaBeforeAddition,groupedFormulaAfterAddition},
	groupedFormula=GatherBy[list,Last];
	groupedFormulaBeforeAddition=Map[Transpose[#]&,groupedFormula];
	groupedFormulaAfterAddition=Map[{Total[#[[1]]],Last[#[[2]]]}&,groupedFormulaBeforeAddition];
	groupedFormulaAfterAddition
];

(* Helper function to identify conflicts between GellingAgents and DropOuts *)
gellingAgentDropOutConflicts[compositionList:{___Association}, value_] :=
	{value,Select[compositionList,targetPresentInComposition[#,value]&]};

(* Helper function to identify conflicts between Supplements and DropOuts *)
supplementDropOutConflicts[compositionList:{___Association}, value_] :=
	{value,Select[compositionList,targetPresentInComposition[#,value]&]};

(* Helper function to identify Supplements/GellingAgents that contain DropOut targets *)
supplementsContainingDropOutTargets[supplementCompositionPacket:KeyValuePattern[{Composition->list_,Object->supplement_}],targets:{ObjectP[Model[Molecule]]...}|None]:=Module[{supplementsWithDropOuts},
	supplementsWithDropOuts=If[!MatchQ[targets,None],
		Map[
			If[MemberQ[list,{CompositionP,ObjectP[#]}],
				Sequence@@{#,supplement},
				Nothing
			]&,targets
		],
		{}
	]
];

(* Helper function to get the composition of the formula *)
extractFormulaComposition[{amount:_Quantity,KeyValuePattern[{Composition->originalComposition_,Object->component_}]}]:=Module[{},
	{amount,component,originalComposition}
];

(* Helper function to convert concentrations to moles/liter *)
convertToMoleLiter[components:{CompositionP...}]:=Map[
	If[MatchQ[#,ConcentrationP],
		Convert[#,Mole/Liter],
		#
	]&,components
];

(* Helper function to deliver new formula with dropouts removed *)
reviseFormulaWithDropOuts[
	totalVolume:VolumeP,
	originalFormulations:{{_Quantity,ObjectP[{Model[Sample],Object[Sample]}],{{(VolumePercentP|MassPercentP|ConcentrationP),ObjectP[Model[Molecule]]}...}}..},dropOutTargets:{ObjectP[Model[Molecule]]..}]:=Module[{newFormula},
	newFormula=MapThread[
		Function[{originalFormulation},
			Module[{originalComposition,containsDropOutQs,compositionNeedsRevisionQ,newFormulaMinusDropOut},
				originalComposition=originalFormulation[[3]];
				containsDropOutQs=Map[MemberQ[originalComposition,{_,ObjectP[#]}]&,dropOutTargets];
				compositionNeedsRevisionQ=MemberQ[containsDropOutQs,True];
				newFormulaMinusDropOut=If[!compositionNeedsRevisionQ,
					{originalFormulation[[1;;2]]},
					Module[{newComposition},
						newComposition=Select[originalComposition,!MemberQ[dropOutTargets,ObjectP[#[[2]]]]&];
						reviseComponents[totalVolume,originalFormulation[[1]],newComposition]
					]
				]
			]
		],{originalFormulations}
	];
	Flatten[newFormula,1]
];

(* Helper function to take relative amounts in components of stock solution and convert to absolutes for the new formula *)
reviseComponents[totalVolume:VolumeP,amount:(VolumeP|MassP),composition:{{(VolumePercentP|MassPercentP|ConcentrationP),ObjectP[Model[Molecule]]}...}]:=Module[{relativeAmounts,molecularWeights,defaultSampleModels,newFormula,convertedRelativeAmounts},
	relativeAmounts=composition[[All,1]];
	convertedRelativeAmounts = convertToMoleLiter[relativeAmounts];
	{molecularWeights,defaultSampleModels}=If[!MatchQ[composition,{}],
		Transpose[Download[composition[[All,2]],{MolecularWeight,DefaultSampleModel[Object]}]],
		{{},{}}
	];
	newFormula=MapThread[
		Function[{relativeAmount,molecularWeight,defaultSampleModel},
			Module[{newAmount},
				newAmount=Which[
					MatchQ[relativeAmount,VolumePercentP|MassPercentP],
					amount*relativeAmount/(100*Units[relativeAmount]),

					MatchQ[relativeAmount,ConcentrationP],
					amount*relativeAmount*molecularWeight,

					True,
					{}
				];
				{newAmount,defaultSampleModel}
			]
		],{convertedRelativeAmounts,molecularWeights,defaultSampleModels}
	]
];

(* Helper function to establish whether formulas are the same *)
sameFormulaQ[formula:{{_,ObjectP[{Model[Sample],Object[Sample]}]}..},targetFormula:{{_,ObjectP[{Model[Sample],Object[Sample]}]}..}]:=Module[{formulaWithoutLinks,targetFormulaWithoutLinks},
	{formulaWithoutLinks,targetFormulaWithoutLinks} = First[removeLinks[{formula,targetFormula},{}]];
	MatchQ[Sort[formulaWithoutLinks],Sort[targetFormulaWithoutLinks]]
];

Error::SupplementsForMediaFormula="The following `1` was specified for the \"Supplements\" option at positions `2` with a media formula input.";
Error::DropOutsForMediaFormula="The following `1` was specified for the \"DropOuts\" option at positions `2` with a media formula input. Instead, please ensure that the provided media formula is free of `1` in its components.";
Error::DropOutInSupplements="At position `1` for the template media model input `2`, the component `3` specified for the \"DropOuts\" option is simultaneously present in the composition of the following specified \"Supplements\" option: `4`.";
Error::DropOutInGellingAgents="At position `1` for the template media model input `2`, the component `3` specified for the \"DropOuts\" option is simultaneously present in the following specified for the \"GellingAgents\" option: `4`.";
Error::GellingAgentMissingMeltingPoint="At position `1` for the input `2`, the following `3` specified for the \"GellingAgents\" option are missing melting temperature information. Please update `3` with this information.";
Error::GellingAgentsForLiquidMedia="At position `1` for the template media model input `2`, the following `3` were specified the \"GellingAgents\" option while the \"MediaPhase\" option was set to Liquid. GellingAgents refer to materials such as Agar and Gelatin, which are added for the preparation of solid media. Please leave the \"GellingAgents\" option un-specified if you desire to prepare a liquid media.";
Warning::DropOutMissingFromTemplate="At position `1` for the template model input `2`, the following `3` specified for the \"DropOuts\" option are not present in the composition of `2`, which is `4`. DropOut options not present in the template media model will be ignored.";
Warning::RedundantSupplements="At position `1`, the specified Supplements `2` are already present in the Formula of the template model media `3`: `4`.";
Warning::RedundantGellingAgents="At position `1`, the specified GellingAgents `2` are already present in the Formula of `3`: `4`.";
Error::DuplicateNameForMedia="At position `1`, the specified name `2` already exists in the database. Please use another name.";

(* Singleton formula Overload with FillToVolumeSolvent & FillToVolume *)
UploadMedia[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[UploadMedia]
]:=UploadMedia[{myFormulaSpec},{mySolvent},{myFinalVolume},ToList[myOptions]];

(* UploadMedia overloads--all overloads will pass inputs & options into UploadStockSolution with the option "Type->Media" *)
UploadMedia[
	myFormulaSpecs:{{{MassP | VolumeP | GreaterP[0, 1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{ObjectP[{Model[Sample]}]..},
	myFinalVolumes:{VolumeP..},
	myOptions:OptionsPattern[UploadMedia]
]:=Module[{outputSpecification,listedOutput,gatherTests,formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,optionsWithoutTemporalLinks,safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests,safeOptionsUploadMedia,fastTrack,cache,upload,uploadStockSolutionOptions,myTemplateMediaModels,resolvedUploadMediaOptionsResult,resolvedUploadMediaTests,collapsedResolvedUploadMediaOptions,unexpandedUploadStockSolutionOptions,expandedUploadStockSolutionOptions,resolvedUploadMediaInputs,resolvedUploadMediaOptions,preliminaryUploadMediaPackets,uploadMediaOptions,finalUploadMediaPackets,allTests,result,options,tests},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];
	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks},optionsWithoutTemporalLinks} = removeLinks[{myFormulaSpecs, mySolvents},ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests} = If[gatherTests,
		SafeOptions[UploadMedia,optionsWithoutTemporalLinks,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[UploadMedia,optionsWithoutTemporalLinks,AutoCorrect->False],{}}
	];

	(* Replace the objects referenced by name to IDs, and expand the index-matched options *)
	safeOptionsUploadMedia = sanitizeInputs[safeOptionsUploadMediaWithNames];
	{fastTrack,cache,upload} = Lookup[safeOptionsUploadMedia,{FastTrack,Cache,Upload}];

	(* Trim down listedOptions such that only the UploadStockSolution options get passed to UploadStockSolution, which is used to generate the initial upload packet with the SS-relevant rules. *)
	uploadStockSolutionOptions = Normal[KeyTake[safeOptionsUploadMedia,Keys[SafeOptions[UploadStockSolution]]]];

	myTemplateMediaModels = ConstantArray[Null,Length[myFormulaSpecs]];
	(* Build the resolved options *)
	resolvedUploadMediaOptionsResult = Check[
		{{resolvedUploadMediaInputs,resolvedUploadMediaOptions}, resolvedUploadMediaTests} = If[gatherTests,
			resolveUploadMediaOptions[{myTemplateMediaModels, myFormulaSpecs, mySolvents, myFinalVolumes},ReplaceRule[safeOptionsUploadMedia,{Output->{Result,Tests}}]],
			{resolveUploadMediaOptions[{myTemplateMediaModels, myFormulaSpecs, mySolvents, myFinalVolumes},ReplaceRule[safeOptionsUploadMedia,{Output->Result}]], {}}
		],
		$Failed,
		{Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedUploadMediaOptions = CollapseIndexMatchedOptions[
		UploadMedia,
		resolvedUploadMediaOptions,
		Ignore->optionsWithoutTemporalLinks,
		Messages->False
	]/.{{{}}->Automatic};

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[MatchQ[resolvedUploadMediaOptionsResult,$Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOptionsUploadMediaTests,resolvedUploadMediaTests}],
			Options->collapsedResolvedUploadMediaOptions,
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	unexpandedUploadStockSolutionOptions = RemoveHiddenOptions[UploadStockSolution,resolvedUploadMediaOptions];
	expandedUploadStockSolutionOptions = padUploadStockSolutionOptions[unexpandedUploadStockSolutionOptions,Length[resolvedUploadMediaInputs]];

	(* We get the preliminary UploadMedia packets by getting our options from UploadStockSolution. *)
	{preliminaryUploadMediaPackets,uploadMediaOptions} = Transpose[MapThread[Function[{input,options},
		Module[{splitOptions,noNullOptions,nullOptions,initialUSSOutput,initialUSSOptions,finalUSSPacket,finalUSSOptions},

			(* Separate our options into null and non-null sections *)
			splitOptions = GatherBy[options,NullQ[Values[#]]&];
			If[MatchQ[splitOptions[[1]],{(_->Null)..}],
				{nullOptions,noNullOptions} = splitOptions,
				{noNullOptions,nullOptions} = splitOptions
			];

			(* We're going to do an UploadStockSolution call here just to get options, specifying Type->Media. *)
			(* We have to do this in a map because USS is not listable. *)
			{initialUSSOutput,initialUSSOptions} = If[MatchQ[input,ObjectP[Model[Sample,Media]]],
				UploadStockSolution[input,
					ReplaceRule[noNullOptions/.MediaName->Name,
						{
							Type->Media,
							Upload->False,
							Output->{Result,Options}
						}
					]
				],
				UploadStockSolution[Sequence@@input,
					ReplaceRule[noNullOptions/.MediaName->Name,
						{
							Type->Media,
							Upload->False,
							Output->{Result,Options}
						}
					]
				]
			];

			(* Since USS can come back either with a whole new Media packet or with just an existing Media object, we need to account for both possibilities *)
			finalUSSPacket = If[MatchQ[initialUSSOutput,KeyValuePattern[{Object->ObjectP[Model[Sample,Media]]}]],
				initialUSSOutput,
				<|Object->initialUSSOutput|>
			];

			(* Get preset Null options back into the options. *)
			finalUSSOptions = initialUSSOptions/.Map[(Keys[#]->_)->#&,nullOptions];
			{finalUSSPacket,finalUSSOptions/.Name->MediaName}
		]
	],{resolvedUploadMediaInputs,expandedUploadStockSolutionOptions}]];

	(* Garnishing the packets for UploadMedia with the field values for Supplements,DropOuts,GellingAgents,PlateMedia *)
	finalUploadMediaPackets = MapThread[
		Function[{packet,options},
			Module[{name,plateMedia,mediaPhase,gellingAgents,baseMedia,packetWithNewObject},
				{name,plateMedia,mediaPhase} = Lookup[options,{MediaName,PlateMedia,MediaPhase}];
				gellingAgents = Map[convertCompositionToAmount[#,Lookup[packet,TotalVolume]]&,Lookup[options,GellingAgents]];
				baseMedia = Which[
					MatchQ[Lookup[options,Supplements],{}] && MatchQ[Lookup[options,DropOuts],{ObjectP[Model[Molecule]]..}],
					Link[Lookup[packet,Object],DropOutMedia],

					MatchQ[Lookup[options,DropOuts],{}] && MatchQ[Lookup[options,Supplements],{{_,ObjectP[{Model[Sample],Object[Sample]}]}..}],
					Link[Lookup[packet,Object],SupplementedMedia]
				];

				(* Due to some weirdness with how the packets get spit out of USS, we need to make a new Object here if our base media is populated *)
				packetWithNewObject = If[!NullQ[baseMedia],
					Association[Normal[ReplaceRule[packet, Object -> CreateID[Model[Sample,Media]]], Association]],
					packet
				];

				Append[packetWithNewObject,
					{
						(* If Name or BaseMedia is Null, we are not going to change anything *)
						If[!NullQ[name],
							Name->name,
							Nothing
						],
						If[!NullQ[baseMedia],
							BaseMedia -> baseMedia,
							Nothing
						],
						PlateMedia -> plateMedia
					}
				]
			]
		],
		{preliminaryUploadMediaPackets,OptionsHandling`Private`mapThreadOptions[UploadMedia,resolvedUploadMediaOptions]}
	];

	allTests = Flatten[{safeOptionsUploadMediaTests,resolvedUploadMediaTests}];

	result = If[MemberQ[listedOutput,Result] && !MemberQ[preliminaryUploadMediaPackets, <|Object -> $Failed|>],
		If[upload,
			Upload[finalUploadMediaPackets],
			finalUploadMediaPackets
		],
		$Failed
	];

	options = If[MemberQ[listedOutput,Options],
		uploadMediaOptions,
		Null
	];

	tests = Flatten[{safeOptionsUploadMediaTests,resolvedUploadMediaTests}];

	outputSpecification/.{
		Result->result,
		Tests->tests,
		Options->options,
		Preview->Null
	}
];

(* UploadMedia overload that accepts a singleton media model *)
UploadMedia[
	myMediaModel:ObjectP[Model[Sample,Media]],
	myOptions:OptionsPattern[UploadMedia]
]:=UploadMedia[{myMediaModel},ToList[myOptions]];

(* UploadMedia overload that accepts a template media model *)
UploadMedia[
	myMediaModels:{ObjectP[Model[Sample,Media]]..},
	myOptions:OptionsPattern[UploadMedia]
]:=Module[{outputSpecification,listedOutput,gatherTests,messages,mediaModelsWithoutTemporalLinks,optionsWithoutTemporalLinks,safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests,safeOptionsUploadMedia,fastTrack,cache,upload,allDownloads,mediaSets,cacheBall,resolvedUploadMediaOptionsResult,resolvedUploadMediaTests,collapsedResolvedUploadMediaOptions,resolvedUploadMediaInputs,resolvedUploadMediaOptions,preliminaryUploadMediaPackets,uploadMediaOptions,unexpandedUploadStockSolutionOptions,expandedUploadStockSolutionOptions,finalUploadMediaPackets,allTests,result,options,tests,preResolvedNames},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	listedOutput = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[listedOutput, Tests];
	messages = Not[gatherTests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{mediaModelsWithoutTemporalLinks,optionsWithoutTemporalLinks} = removeLinks[myMediaModels,ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests} = If[gatherTests,
		SafeOptions[UploadMedia,optionsWithoutTemporalLinks,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[UploadMedia,optionsWithoutTemporalLinks,AutoCorrect->False],{}}
	];

	(* Replace the objects referenced by name to IDs *)
	safeOptionsUploadMedia = sanitizeInputs[safeOptionsUploadMediaWithNames];
	{fastTrack,cache,upload} = Lookup[safeOptionsUploadMedia,{FastTrack,Cache,Upload}];

	allDownloads = Download[myMediaModels,
		{
			Packet[Name,Deprecated,Composition,Formula,Solvent,TotalVolume,FillToVolumeSolvent,HeatSensitiveReagents],
			Packet[MediaPhase,GellingAgents,PlateMedia],
			Packet[Formula[[All,2]]]
		}
	];

	(* This satisfies the overload for the options resolver, which needs (1) media models, (2) formula, (3) solvent, and (4) total volume. *)
	mediaSets = Join[
		{myMediaModels},
		Transpose[
			Map[
				If[
					NullQ[Lookup[#[[1]],Solvent]],
					Lookup[#[[1]],{Formula,FillToVolumeSolvent,TotalVolume}],
					Lookup[#[[1]],{Formula,Solvent,TotalVolume}]
				]&,
				allDownloads
			]
		]
	];
	cacheBall = Cases[Flatten[allDownloads],PacketP[]];

	resolvedUploadMediaOptionsResult = Check[
		{{resolvedUploadMediaInputs,resolvedUploadMediaOptions},resolvedUploadMediaTests} = If[gatherTests,
			resolveUploadMediaOptions[mediaSets,ReplaceRule[safeOptionsUploadMedia,{Cache->cacheBall,Output->{Result,Tests}}]],
			{resolveUploadMediaOptions[mediaSets,ReplaceRule[safeOptionsUploadMedia,{Cache->cacheBall,Output->Result}]], {}}
		],
		$Failed,
		{Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedUploadMediaOptions = CollapseIndexMatchedOptions[
		UploadMedia,
		resolvedUploadMediaOptions,
		Ignore->optionsWithoutTemporalLinks,
		Messages->False
	];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[MatchQ[resolvedUploadMediaOptionsResult,$Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOptionsUploadMediaTests,resolvedUploadMediaTests}],
			Options->RemoveHiddenOptions[UploadMedia,collapsedResolvedUploadMediaOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	unexpandedUploadStockSolutionOptions = RemoveHiddenOptions[UploadStockSolution,resolvedUploadMediaOptions];
	expandedUploadStockSolutionOptions = padUploadStockSolutionOptions[unexpandedUploadStockSolutionOptions,Length[resolvedUploadMediaInputs]];

	(* We get the preliminary UploadMedia packets by getting our options from UploadStockSolution. *)
	{preliminaryUploadMediaPackets,uploadMediaOptions} = Transpose[MapThread[Function[{input,options},
		If[MatchQ[input,ObjectP[Model[Sample,Media]]],
			{<|Object -> input|>, options},

			(* Separate our options into null and non-null sections *)
			Module[{splitOptions,noNullOptions,nullOptions,initialUSSOutput,initialUSSOptions,finalUSSPacket,finalUSSOptions},
				splitOptions = GatherBy[options,NullQ[Values[#]]&];
				If[MatchQ[splitOptions[[1]],{(_->Null)..}],
					{nullOptions,noNullOptions} = splitOptions,
					{noNullOptions,nullOptions} = splitOptions
				];

				(* We're going to do an UploadStockSolution call here just to get options, specifying Type->Media. *)
				(* We have to do this in a map because USS is not listable. *)
				{initialUSSOutput,initialUSSOptions} = UploadStockSolution[
					Sequence@@input,
					ReplaceRule[
						Normal@KeyDrop[noNullOptions/.MediaName->Name,{Supplements,DropOuts}],
						{
							Type->Media,
							Upload->False,
							Output->{Result,Options}
						}
					]
				];

				(* Since USS can come back either with a whole new Media packet or with just an existing Media object, we need to account for both possibilities *)
				finalUSSPacket = If[MatchQ[initialUSSOutput,KeyValuePattern[{Object->ObjectP[Model[Sample,Media]]}]],
					initialUSSOutput,
					<|Object->initialUSSOutput|>
				];

				(* Get preset Null options back into the options. *)
				finalUSSOptions = initialUSSOptions/.Map[(Keys[#]->_)->#&,nullOptions];
				{finalUSSPacket,finalUSSOptions/.Name->MediaName}
			]
		]
	],{resolvedUploadMediaInputs,expandedUploadStockSolutionOptions}]];

	(* Garnishing the packets for UploadMedia with the field values for Supplements,DropOuts,PlateMedia *)
	finalUploadMediaPackets = MapThread[Function[{templateModel,packet,options},
		Module[{name,plateMedia,mediaPhase,baseMedia,packetWithNewObject},
			{name,plateMedia,mediaPhase} = Lookup[options,{MediaName,PlateMedia,MediaPhase}];
			baseMedia = Which[
				MatchQ[Lookup[options,Supplements],None] && MatchQ[Lookup[options,DropOuts],{ObjectP[Model[Molecule]]..}],
				Link[templateModel,DropOutMedia],

				MatchQ[Lookup[options,DropOuts],None] && MatchQ[Lookup[options,Supplements],{{_,ObjectP[{Model[Sample],Object[Sample]}]}..}],
				Link[templateModel,SupplementedMedia]
			];

			(* Due to some weirdness with how the packets get spit out of USS, we need to make a new Object here if our base media is populated *)
			packetWithNewObject = If[!NullQ[baseMedia],
				Association[Normal[ReplaceRule[packet, Object -> CreateID[Model[Sample,Media]]], Association]],
				packet
			];

			(* Re-return the basic <|Object->Model[Sample,Media,id]|> packet if not creating a new media model, aka not updating any fields from the template media model *)
			Append[packetWithNewObject,
				{
					(* If Name -> Null, we are not going to change anything *)
					If[!NullQ[name],
						Name->name,
						Nothing
					],
					If[!NullQ[baseMedia],
						BaseMedia -> baseMedia,
						Nothing
					],
					PlateMedia -> plateMedia
				}
			]
		]
	],{myMediaModels,preliminaryUploadMediaPackets,OptionsHandling`Private`mapThreadOptions[UploadMedia,resolvedUploadMediaOptions]}];

	allTests = Flatten[{safeOptionsUploadMediaTests,resolvedUploadMediaTests}];

	result = If[MemberQ[listedOutput,Result] && !MemberQ[preliminaryUploadMediaPackets, <|Object -> $Failed|>],
		If[upload,
			Upload[finalUploadMediaPackets],
			finalUploadMediaPackets
		],
		$Failed
	];

	options = If[MemberQ[listedOutput,Options],
		uploadMediaOptions,
		Null
	];

	tests = If[gatherTests,
		allTests,
		Null
	];

	outputSpecification/.{Result->result,Options->options,Tests->tests}
];

(* This function will be *)
resolveUploadMediaOptions[
	myMediaSets:{
		myTemplateMediaModels:{(ObjectP[Model[Sample,Media]] | Null)..},
		myOriginalFormulaSpecs:{{{VolumeP | MassP | NumericP | Null, ObjectP[{Model[Sample],Object[Sample]}]}..}..},
		mySolvents:{(ObjectP[Model[Sample]] | Null)..},
		myVolumes:{(VolumeP | Null)..}
	},
	myOptions:OptionsPattern[UploadMedia]
]:=Module[{outputSpecification,output,gatherTests,messages,fastTrack,cache,mediaModelsWithoutTemporalLinks,formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,optionsWithoutTemporalLinks,safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests,safeOptionsUploadMedia,expandedUnresolvedTemplatedOptionsUploadMedia,specifiedMediaNames,invalidNameQs,invalidMediaNamePositions,invalidMediaNames,invalidNameOptions,invalidNameTest,specifiedSupplements,specifiedDropOuts,specifiedGellingAgents,supplementsOptionSpecifiedQs,dropOutsOptionSpecifiedQs,invalidFormulaSupplementsQs,invalidFormulaDropOutsQs,invalidFormulaSupplementsPositions,invalidFormulaDropOutPositions,invalidFormulaSupplementsOption,invalidFormulaSupplementOptionTest,invalidFormulaDropOutsOption,invalidFormulaDropOutOptionsTest,supplementsForDownload,gellingAgentsForDownload,templateFormulaPackets,templateFormulaCompositionPackets,templateOriginalOptionPackets,supplementsCompositionPackets,gellingAgentsPackets,mapThreadFriendlyOptions,supplementDropOutConflictsErrorQs,gellingAgentsDropOutConflictsErrorQs,redundantSupplementInFormulaQs,redundantGellingAgentInFormulaQs,dropOutsMissingFromTemplateQs,gellingAgentsForLiquidMediaErrorQs,gellingAgentsMissingMeltingPointErrorQs,plateMediaFalseForSolidMediaWarningQs,finalFormulaCompositionPackets,uploadMediaInputs,resolvedSupplementsOptions,resolvedDropOutsOptions,resolvedGellingAgentsOptions,resolvedMediaPhaseOptions,resolvedPlateMediaOptions,resolvedMediaNameOptions,dropOutInSupplements,resolvedOptions,supplementDropOutConflictsErrorPositions,gellingAgentsDropOutConflictsErrorPositions,redundantSupplementInFormulaWarningPositions,dropOutsMissingFromTemplateWarningPositions,gellingAgentsForLiquidMediaErrorPositions,gellingAgentsMissingMeltingPointErrorPositions,redundantGellingAgentInFormulaWarningPositions,supplementDropOutConflictsErrorPackets,gellingAgentsDropOutConflictsErrorPackets,redundantSupplementInFormulaPackets,dropOutsMissingFromTemplatePackets,redundantGellingAgentInFormulaPackets,gellingAgentsForLiquidMediaErrorPackets,gellingAgentsMissingMeltingPointPackets,dropOutInSupplementsTest,supplementsInTemplateModelFormula,formulaPacketsWithRedundantSupplements,supplementsInTemplateModelFormulaTest,invalidSupplementsOption,invalidDropOutsOption,invalidGellingAgentsOption,invalidOptions,allTests,resolvedHeatSensitiveReagentsOptions},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{{mediaModelsWithoutTemporalLinks,formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks},optionsWithoutTemporalLinks} = removeLinks[{myTemplateMediaModels,myOriginalFormulaSpecs,mySolvents},ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsUploadMediaWithNames,safeOptionsUploadMediaTests} = If[gatherTests,
		SafeOptions[UploadMedia,optionsWithoutTemporalLinks,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[UploadMedia,optionsWithoutTemporalLinks,AutoCorrect->False],{}}
	];

	(* Replace the objects referenced by name to IDs, and expand the index-matched options *)
	safeOptionsUploadMedia = sanitizeInputs[safeOptionsUploadMediaWithNames];
	{fastTrack,cache} = Lookup[safeOptionsUploadMedia,{FastTrack,Cache}];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptionsUploadMedia, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->safeOptionsUploadMediaTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* When expanding the index-matched inputs, we need to provide the definition number (defaults to 1) of the input for UploadMedia (defined in the reference page) *)
	expandedUnresolvedTemplatedOptionsUploadMedia = If[MatchQ[myTemplateMediaModels, {Null..}],
		Last[ExpandIndexMatchedInputs[UploadMedia,{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,myVolumes},safeOptionsUploadMedia]],
		Last[ExpandIndexMatchedInputs[UploadMedia,{myTemplateMediaModels},safeOptionsUploadMedia,2]]
	];

	(*=====MEDIA OPTIONS CHECK=====*)

	(* Check #1: If the Name option was specified anywhere, make sure that these are unique & not used for any other Model[Sample,Media] type *)
	specifiedMediaNames = Lookup[expandedUnresolvedTemplatedOptionsUploadMedia,MediaName];
	invalidNameQs = Map[
		Module[{invalidNameQ},
			invalidNameQ = StringQ[#] && DatabaseMemberQ[Append[Model[Sample,Media],#]]
		]&,specifiedMediaNames
	];
	invalidMediaNamePositions = Flatten[Position[invalidNameQs,True]];
	invalidMediaNames = PickList[specifiedMediaNames,invalidNameQs];

	invalidNameOptions = If[Length[invalidMediaNames]>0 && messages && !fastTrack,
		(
			MapThread[Function[{position,name},
				Message[Error::DuplicateNameForMedia,
					position,
					name
				]
			],{invalidMediaNamePositions,invalidMediaNames}];
			{MediaName}
		),
		{}
	];

	invalidNameTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[Length[invalidMediaNames]==0,
				Nothing,
				Test["Model[Sample,Media] with the following names "<>ToString[invalidMediaNames]<>" already exist in the database:",
					True,
					False
				];
			];
			passingTest = If[Length[invalidMediaNames]==Length[specifiedMediaNames],
				Nothing,
				Test["The following names "<>ToString[Complement[specifiedMediaNames,invalidMediaNames]]<>"are unique for Model[Sample,Media] and may be used:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* Check #2: For a formula input, Supplements & DropOuts options should not be specified. They are not Automatic only when explicitly specified by the user. *)
	{specifiedSupplements,specifiedDropOuts,specifiedGellingAgents} = Lookup[expandedUnresolvedTemplatedOptionsUploadMedia,{Supplements,DropOuts,GellingAgents}];
	{supplementsOptionSpecifiedQs,dropOutsOptionSpecifiedQs} = Map[
		Function[{values},
			Map[!MatchQ[#, None|Automatic]&, values]
		],{specifiedSupplements,specifiedDropOuts}
	];

	(* Mark the Supplements and/or DropOuts options as invalid when specified for a formula input. *)
	{invalidFormulaSupplementsQs,invalidFormulaDropOutsQs} = Transpose[MapThread[
		Function[{myTemplateMediaModel,supplementsOptionSpecifiedQ,dropOutsOptionSpecifiedQ},
			Module[{invalidSup,invalidDrop},
				{invalidSup,invalidDrop}=If[!NullQ[myTemplateMediaModel],
					{False,False},
					{supplementsOptionSpecifiedQ,dropOutsOptionSpecifiedQ}
				]
			]
		],
		{myTemplateMediaModels,supplementsOptionSpecifiedQs,dropOutsOptionSpecifiedQs}
	]];

	invalidFormulaSupplementsPositions = Flatten[Position[invalidFormulaSupplementsQs,True]];
	invalidFormulaDropOutPositions = Flatten[Position[invalidFormulaDropOutsQs,True]];

	(* Throw hard error when Supplements is specified for a formula input for UploadMedia/ExperimentMedia *)
	{invalidFormulaSupplementsOption,invalidFormulaSupplementOptionTest} = If[!fastTrack,
		Module[{test,invalidOptions},
			test = If[gatherTests,
				Test["The Supplements option is not specified where a media formula is provided as input.",
					!MemberQ[invalidFormulaSupplementsQs,True],
					False
				],
				Nothing
			];
			invalidOptions = If[MemberQ[invalidFormulaSupplementsQs,True],{Supplements},{}];
			If[MemberQ[invalidFormulaSupplementsQs,True] && messages,
				Map[Message[Error::SupplementsForMediaFormula,
						specifiedSupplements[[#]],
						#
					]&,invalidFormulaSupplementsPositions
				]
			];
			{invalidOptions,{test}}
		],
		{{},{}}
	];

	(* Similarly, throw hard error when DropOuts is specified for a formula input for UploadMedia/ExperimentMedia *)
	{invalidFormulaDropOutsOption,invalidFormulaDropOutOptionsTest} = If[!fastTrack,
		Module[{positions,test,invalidOptions},
			positions = Flatten[Position[invalidFormulaSupplementsQs,True]];
			test = If[gatherTests,
				Test["The DropOuts option is not specified where a media formula is provided as input.",
					!MemberQ[invalidFormulaDropOutsQs,True],
					False
				],
				Nothing
			];
			invalidOptions = If[MemberQ[invalidFormulaDropOutsQs,True],{DropOuts},{}];
			If[MemberQ[invalidFormulaDropOutsQs,True] && messages,
				Map[Message[Error::DropOutsForMediaFormula,
						specifiedDropOuts[[#]],
						#
					]&,invalidFormulaDropOutPositions
				]
			];
			{invalidOptions,{test}}
		],
		{{},{}}
	];

	(* If we've made it to this point, then Supplements & DropOuts options were appropriately specified only for a StockSolutionTemplate input. *)
	(* Now onto checking the validity of Supplements/DropOuts/GellingAgents *)

	{supplementsForDownload,gellingAgentsForDownload} = Transpose[
		MapThread[
			Function[{supplements,gellingAgents},
				{
					If[!MatchQ[supplements,None],supplements[[All,2]],{}],
					If[!MatchQ[gellingAgents,None|Automatic],gellingAgents[[All,2]],{}]
				}
			],
			{specifiedSupplements,specifiedGellingAgents}
		]
	];

	(* We do need another download here because we might be using an existing media model *)
	{templateFormulaPackets,templateFormulaCompositionPackets,templateOriginalOptionPackets} = If[!MatchQ[myTemplateMediaModels,{Null..}],
		Transpose[Quiet[Download[myTemplateMediaModels,
			{
				Packet[Name,Deprecated,Formula,Composition,Solvent,TotalVolume,FillToVolumeSolvent,HeatSensitiveReagents],
				Packet[Formula[Composition]],
				Packet[MediaPhase,GellingAgents,PlateMedia]
			},
			Cache->cache],{Download::MissingCacheField}
		]],
		{myTemplateMediaModels,myTemplateMediaModels,myTemplateMediaModels}
	];
	supplementsCompositionPackets = Download[supplementsForDownload,Packet[Composition]];
	gellingAgentsPackets = Download[gellingAgentsForDownload,Packet[Composition,MeltingPoint]];

	(* MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[UploadMedia, expandedUnresolvedTemplatedOptionsUploadMedia];

	{
		(*1*)supplementDropOutConflictsErrorQs,
		(*2*)gellingAgentsDropOutConflictsErrorQs,
		(*3*)redundantSupplementInFormulaQs,
		(*4*)redundantGellingAgentInFormulaQs,
		(*5*)dropOutsMissingFromTemplateQs,
		(*6*)gellingAgentsForLiquidMediaErrorQs,
		(*7*)gellingAgentsMissingMeltingPointErrorQs,
		(*8*)plateMediaFalseForSolidMediaWarningQs,
		(*9*)finalFormulaCompositionPackets,
		(*10*)uploadMediaInputs,
		(*11*)resolvedSupplementsOptions,
		(*12*)resolvedDropOutsOptions,
		(*13*)resolvedGellingAgentsOptions,
		(*14*)resolvedPlateMediaOptions,
		(*15*)resolvedMediaPhaseOptions,
		(*16*)resolvedMediaNameOptions,
		(*17*)resolvedHeatSensitiveReagentsOptions
	} =

	Transpose[MapThread[Function[{options,myOriginalFormulaSpec,mySolvent,myVolume,templateFormulaPacket,supplementsCompositionPacket,gellingAgentsPacket,templateFormulaCompositionPacket},
		Module[{specifiedMediaName,specifiedSupplements,specifiedDropOuts,specifiedGellingAgents,specifiedMediaPhase,specifiedPlateMediaQ,originalFormula,solvent,totalVolume,supplementDropOutConflictsCheck,supplementDropOutConflictsErrorQ,gellingAgentsDropOutConflictsErrorQ,dropOutMissingFromTemplateCheck,dropOutPresentInTemplateCheck,templateFormulaWithSupplements,redundantSupplementsCheck,templateFormulaWithSupplementsAndGellingAgents,redundantGellingAgentsCheck,redundantSupplementInFormulaQ,templateFormulaPacketWithSupplements,redundantGellingAgentInFormulaQ,templateFormulaPacketWithSupplementsAndGellingAgents,dropOutsMissingFromTemplateQ,formulaWithSupplements,needRevisedFormulaQ,formulaWithSupplementsAndDropOuts,finalFormulaCompositionPacket, gellingAgentsForLiquidMediaErrorQ,plateMediaFalseForSolidMediaQ,plateMediaTrueForLiquidMediaQ,resolvedPlateMediaQ,resolvedGellingAgents,resolvedMediaPhase,gellingAgentsForLiquidMediaCheck,gellingAgentsMissingMeltingPointErrorQ,plateMediaFalseForSolidMediaWarningQ,gellingAgentDropOutConflictsCheck,gellingAgentsMissingMeltingPointCheck,templateFormulaPacketWithChecks,newModelUploadQ,uploadMediaInput,resolvedSupplements,resolvedDropOuts,resolvedHeatSensitiveReagents,specifiedHeatSensitiveReagents,resolvedGellingAgentsNotFromFormula},

			(* error checking variables here *)
			{
				(*1*)supplementDropOutConflictsErrorQ,
				(*2*)gellingAgentsDropOutConflictsErrorQ,
				(*3*)redundantSupplementInFormulaQ,
				(*4*)dropOutsMissingFromTemplateQ,
				(*5*)gellingAgentsForLiquidMediaErrorQ,
				(*6*)gellingAgentsMissingMeltingPointErrorQ,
				(*7*)plateMediaFalseForSolidMediaWarningQ
			} = {False,False,False,False,False,False,False};

			(* Options related to media formula *)
			{specifiedMediaName,specifiedSupplements,specifiedDropOuts,specifiedGellingAgents,specifiedHeatSensitiveReagents} = Lookup[options,{MediaName,Supplements,DropOuts,GellingAgents,HeatSensitiveReagents}]/.{Automatic->{}};

			(* How we get these values depend on the original inputs to the upstream UploadMedia function. *)
			(* If a template media model was provided, we can look them up in templateFormulaPacket. *)
			(* If a media formula was provided, then these correspond to the inputs themselves. *)
			(* We also need to account for the possibility of Solvent vs. FillToVolumeSolvent *)
			{originalFormula,solvent,totalVolume} = Which[
				!NullQ[templateFormulaPacket] && NullQ[Lookup[templateFormulaPacket,Solvent]],
					First[removeLinks[Lookup[templateFormulaPacket,{Formula,FillToVolumeSolvent,TotalVolume}],{}]],

				!NullQ[templateFormulaPacket],
					First[removeLinks[Lookup[templateFormulaPacket,{Formula,Solvent,TotalVolume}],{}]],

				True,
					{myOriginalFormulaSpec,mySolvent,myVolume}
			];

			(* Options related to media plating *)
			{specifiedMediaPhase,specifiedPlateMediaQ} = Lookup[options,{MediaPhase,PlateMedia}];

			(* Check #1: that PlateMedia is set to True if the MediaPhase is set to Solid. *)
			plateMediaFalseForSolidMediaQ = MatchQ[Lookup[options,{PlateMedia}],{False,Solid}];
			plateMediaTrueForLiquidMediaQ = MatchQ[Lookup[options,{PlateMedia,MediaPhase}],{True,Liquid}];

			(* If the user has not specifically set the PlateMedia option, automatically set to False since there is no harm in keeping around solid media in the bottle that it was originally prepared in. *)
			(* If the MediaPhase is specified as either Solid or SemiSolid but GellingAgents is not specified, default to the appropriate concentration of Agar for each MediaPhase. *)
			(* One last note here: if we are getting the gelling agents from the formula, it does not make sense to pass those back when we use addSupplementsToTemplateFormula. *)
			(* Therefore, we use a second variable to keep the gelling agents that are derived from the formula away from that route. *)
			resolvedPlateMediaQ = specifiedPlateMediaQ/.{Automatic->False};
			{resolvedGellingAgents, resolvedGellingAgentsNotFromFormula} = Which[
				(* If the user has specified, use that *)
				!MatchQ[specifiedGellingAgents,{}],
					ConstantArray[specifiedGellingAgents, 2],

				(* Importantly, if there are any GellingAgents present in the Formula, we use those *)
				MemberQ[myOriginalFormulaSpec, {_, GellingAgentsP}],
					{Cases[myOriginalFormulaSpec, {_, GellingAgentsP}], {}},

				MatchQ[specifiedGellingAgents,{}] && MatchQ[specifiedMediaPhase,Solid],
					ConstantArray[{{20*Gram/Liter,Model[Sample,"id:9RdZXvKBee1Z"]}}, 2] (* Agar *),

				MatchQ[specifiedGellingAgents,{}] && MatchQ[specifiedMediaPhase,SemiSolid],
					ConstantArray[{{10*Gram/Liter,Model[Sample,"id:9RdZXvKBee1Z"]}}, 2] (* Agar *),

				True,
					ConstantArray[specifiedGellingAgents/.{{}->None}, 2]
			];
			resolvedMediaPhase = specifiedMediaPhase/.{Automatic->If[
				MatchQ[specifiedGellingAgents,{}],
				Liquid,
				Solid
			]};

			(* Speaking of GellingAgents, check that any user-specified GellingAgents have the MeltingPoint field informed. *)
			gellingAgentsMissingMeltingPointCheck = PickList[
				Lookup[gellingAgentsPacket, Object, {}],
				Lookup[gellingAgentsPacket, MeltingPoint, {}],
				Null
			];
			gellingAgentsMissingMeltingPointErrorQ = !MatchQ[gellingAgentsMissingMeltingPointCheck,{}];

			(* In addition, check that the GellingAgents option is not specified for MediaPhase->Liquid. *)
			gellingAgentsForLiquidMediaCheck = If[!MatchQ[specifiedGellingAgents,{}] && MatchQ[Lookup[options,MediaPhase],Liquid], specifiedGellingAgents, {}];
			gellingAgentsForLiquidMediaErrorQ = !MatchQ[gellingAgentsForLiquidMediaCheck,{}];


			(***SUPPLEMENTS/DROPOUTS/GELLINGAGENTS OPTION VALIDITY CHECKS***)

			supplementDropOutConflictsCheck = DeleteCases[Map[supplementsContainingDropOutTargets[#,specifiedDropOuts]&,supplementsCompositionPacket],{}];
			supplementDropOutConflictsErrorQ = !MatchQ[supplementDropOutConflictsCheck,{}];

			gellingAgentDropOutConflictsCheck = DeleteCases[Map[supplementsContainingDropOutTargets[#,specifiedDropOuts]&,gellingAgentsPacket],{}];
			gellingAgentsDropOutConflictsErrorQ = !MatchQ[gellingAgentDropOutConflictsCheck,{}];

			dropOutMissingFromTemplateCheck = dropOutTargetsMissingFromTemplate[templateFormulaPacket,specifiedDropOuts];
			dropOutsMissingFromTemplateQ = If[!NullQ[templateFormulaPacket],
				!MatchQ[dropOutMissingFromTemplateCheck,{}],
				False
			];
			dropOutPresentInTemplateCheck = Select[specifiedDropOuts/.{None->{}},!MemberQ[dropOutMissingFromTemplateCheck,#]&];

			templateFormulaPacketWithChecks = Join[
				If[NullQ[templateFormulaPacket],
					<|Formula->originalFormula,TotalVolume->totalVolume|>,
					templateFormulaPacket
				],
				<|
					SupplementDropOutConflicts->supplementDropOutConflictsCheck,
					GellingAgentDropOutConflicts->gellingAgentDropOutConflictsCheck,
					ValidDropOuts->dropOutPresentInTemplateCheck,
					DropOutMissingFromTemplate->dropOutMissingFromTemplateCheck,
					GellingAgentsForLiquidMedia->gellingAgentsForLiquidMediaCheck,
					GellingAgentsMissingMeltingPoint->gellingAgentsMissingMeltingPointCheck
				|>
			];

			(* At this stage, GellingAgents will be treated the same way as Supplements, since it is just a special category Supplement *)
			{templateFormulaWithSupplements,redundantSupplementsCheck} = addSupplementsToTemplateFormula[templateFormulaPacketWithChecks,originalFormula,specifiedSupplements];
			redundantSupplementInFormulaQ = !MatchQ[redundantSupplementsCheck,{}];

			templateFormulaPacketWithSupplements = Association[Normal@templateFormulaPacketWithChecks/.{
				(Formula->_) -> (Formula -> templateFormulaWithSupplements)
			}];
			{templateFormulaWithSupplementsAndGellingAgents,redundantGellingAgentsCheck} = addSupplementsToTemplateFormula[templateFormulaPacketWithSupplements,templateFormulaWithSupplements,resolvedGellingAgentsNotFromFormula/.{None->{}}];
			redundantGellingAgentInFormulaQ = !MatchQ[redundantGellingAgentsCheck,{}];

			templateFormulaPacketWithSupplementsAndGellingAgents = Association[Normal@templateFormulaPacketWithChecks/.{
				(Formula->_) -> (Formula -> templateFormulaWithSupplementsAndGellingAgents)
			}];

			formulaWithSupplements = If[!NullQ[templateFormulaWithSupplementsAndGellingAgents],
				finalFormulaWithSupplements[Association[Normal@templateFormulaPacketWithSupplementsAndGellingAgents/.{(Formula->_) -> (Formula -> templateFormulaWithSupplementsAndGellingAgents)}]],
				originalFormula
			];

			(* At this point, we have checked the validity of the Supplements/DropOuts/GellingAgents options. *)
			(* Supplements option is easy, since we can just dump these values into the original formula of the template model, but DropOuts is more complicated since we need to check that the IDModelType specified here is not present as a composition in ALL the formula components. *)

			(* First things first, determine whether it is even worth trying to calculate the new formula based on option validity. Namely, there are no conflicts between DropOuts and Supplements/GellingAgents *)
			(* RedundantSupplements is okay, since this is not an irresolvable conflict like the DropOuts clashing with Supplements/GellingAgents *)

			needRevisedFormulaQ = And[
				!NullQ[templateFormulaPacket],
				MatchQ[dropOutPresentInTemplateCheck,{IdentityModelP..}],
				!MemberQ[{supplementDropOutConflictsErrorQ, gellingAgentsDropOutConflictsErrorQ},True]
			];

			(* Now, make a new formula that will produce the template media excluding all the components specified in DropOuts *)
			formulaWithSupplementsAndDropOuts = If[needRevisedFormulaQ,
				Module[{inputForFormulaRevision},
					inputForFormulaRevision = If[!NullQ[templateFormulaCompositionPacket],
						Map[extractFormulaComposition[#]&,templateFormulaCompositionPacket],
						originalFormula
					];
					reviseFormulaWithDropOuts[totalVolume,inputForFormulaRevision,dropOutPresentInTemplateCheck]
				],
				formulaWithSupplements
			];

			(* Determine whether we need to upload and create a new model, or whether we can simply return the original template model. *)
			newModelUploadQ = If[
				Or[
					!NullQ[specifiedMediaName],
					NullQ[templateFormulaPacket],
					!sameFormulaQ[originalFormula,formulaWithSupplementsAndDropOuts]
				],
				True,
				False
			];

			uploadMediaInput = If[newModelUploadQ,
				{formulaWithSupplementsAndDropOuts, solvent, totalVolume},
				Lookup[templateFormulaPacket,Object]
			];

			(* Organizing the resolved options (mainly the Media-specific fields, such as GellingAgents,MediaPhase. *)

			(* resolvedSupplements is whatever the user specifies *)
			(* resolvedDropOuts is the subset of user-specified values that actually exist in the template *)
			resolvedSupplements = specifiedSupplements/.{{}->None};
			resolvedDropOuts = dropOutPresentInTemplateCheck/.{{}->None};

			(* resolve the HeatSensitiveReagents *)
			resolvedHeatSensitiveReagents = Which[

				(* If user has specified heat sensitive reagents, accept it *)
				!MatchQ[specifiedHeatSensitiveReagents,{}],
					specifiedHeatSensitiveReagents,
				(* If we're coming from a model template, accept the heat sensitive reagents from there *)
				!NullQ[templateFormulaPacket],
					Lookup[templateFormulaPacket,HeatSensitiveReagents,Null],
				True,
					Null
			];

			(*8*)finalFormulaCompositionPacket = Join[templateFormulaPacketWithChecks,
				<|
					OriginalFormula->originalFormula,
					RevisedFormula->formulaWithSupplementsAndDropOuts,
					RedundantSupplements->redundantSupplementsCheck,
					RedundantGellingAgents->redundantGellingAgentsCheck
				|>
			];

			{
				(*1*)supplementDropOutConflictsErrorQ,
				(*2*)gellingAgentsDropOutConflictsErrorQ,
				(*3*)redundantSupplementInFormulaQ,
				(*4*)redundantGellingAgentInFormulaQ,
				(*5*)dropOutsMissingFromTemplateQ,
				(*6*)gellingAgentsForLiquidMediaErrorQ,
				(*7*)gellingAgentsMissingMeltingPointErrorQ,
				(*8*)plateMediaFalseForSolidMediaWarningQ,
				(*9*)finalFormulaCompositionPacket,
				(*10*)uploadMediaInput,
				(*11*)resolvedSupplements,
				(*12*)resolvedDropOuts,
				(*13*)resolvedGellingAgents,
				(*14*)resolvedPlateMediaQ,
				(*15*)resolvedMediaPhase,
				(*16*)specifiedMediaName,
				(*17*)resolvedHeatSensitiveReagents
			}
		]
	],{mapThreadFriendlyOptions,myOriginalFormulaSpecs,mySolvents,myVolumes,templateFormulaPackets,supplementsCompositionPackets,gellingAgentsPackets,templateFormulaCompositionPackets}]];

	resolvedOptions = ReplaceRule[
		expandedUnresolvedTemplatedOptionsUploadMedia,
		Flatten[{
			MediaName->resolvedMediaNameOptions,
			Supplements->resolvedSupplementsOptions,
			DropOuts->resolvedDropOutsOptions,
			GellingAgents->resolvedGellingAgentsOptions,
			PlateMedia->resolvedPlateMediaOptions,
			MediaPhase->resolvedMediaPhaseOptions,
			HeatSensitiveReagents->resolvedHeatSensitiveReagentsOptions
		}]
	];

	(* Time for the error messages *)
	{
		(*1*)supplementDropOutConflictsErrorPositions,
		(*2*)gellingAgentsDropOutConflictsErrorPositions,
		(*3*)redundantSupplementInFormulaWarningPositions,
		(*4*)dropOutsMissingFromTemplateWarningPositions,
		(*5*)gellingAgentsForLiquidMediaErrorPositions,
		(*6*)gellingAgentsMissingMeltingPointErrorPositions,
		(*7*)redundantGellingAgentInFormulaWarningPositions
	} = Map[
		Flatten[Position[#,True]]&,
		{
			(*1*)supplementDropOutConflictsErrorQs,
			(*2*)gellingAgentsDropOutConflictsErrorQs,
			(*3*)redundantSupplementInFormulaQs,
			(*4*)dropOutsMissingFromTemplateQs,
			(*5*)gellingAgentsForLiquidMediaErrorQs,
			(*6*)gellingAgentsMissingMeltingPointErrorQs,
			(*7*)redundantGellingAgentInFormulaQs
		}
	];

	(* Hard Errors, must be fixed by user *)
	(*1*)supplementDropOutConflictsErrorPackets = finalFormulaCompositionPackets[[supplementDropOutConflictsErrorPositions]];
	(*2*)gellingAgentsDropOutConflictsErrorPackets = finalFormulaCompositionPackets[[gellingAgentsDropOutConflictsErrorPositions]];
	(*5*)gellingAgentsForLiquidMediaErrorPackets = finalFormulaCompositionPackets[[gellingAgentsForLiquidMediaErrorPositions]];
	(*6*)gellingAgentsMissingMeltingPointPackets = finalFormulaCompositionPackets[[gellingAgentsMissingMeltingPointErrorPositions]];

	(* Soft Warnings, alert user *)
	(*3*)redundantSupplementInFormulaPackets = finalFormulaCompositionPackets[[redundantSupplementInFormulaWarningPositions]];
	(*4*)dropOutsMissingFromTemplatePackets = finalFormulaCompositionPackets[[dropOutsMissingFromTemplateWarningPositions]];
	(*5*)redundantGellingAgentInFormulaPackets = finalFormulaCompositionPackets[[redundantGellingAgentInFormulaWarningPositions]];

	(* 1. Error message about DropOut vs Supplement conflict *)
	If[messages && Length[supplementDropOutConflictsErrorPositions]>0,
		MapThread[Function[{position,supplementDropOutConflictsErrorPacket},
			Module[{templateModel,supplementDropOutConflictTuples},
				{templateModel,supplementDropOutConflictTuples} = Lookup[supplementDropOutConflictsErrorPacket,{Object,SupplementDropOutConflicts}];
				Map[Message[Error::DropOutInSupplements,
					position,
					templateModel,
					#[[1]],
					#[[2]]
				]&,supplementDropOutConflictTuples]
			]
		],{supplementDropOutConflictsErrorPositions,supplementDropOutConflictsErrorPackets}]
	];

	(* 2. Error message about DropOut vs GellingAgent conflict *)
	If[messages && Length[gellingAgentsDropOutConflictsErrorPositions]>0,
		MapThread[Function[{position,gellingAgentsDropOutConflictsErrorPacket},
			Module[{templateModel,gellingAgentsDropOutConflictTuples},
				{templateModel,gellingAgentsDropOutConflictTuples} = Lookup[gellingAgentsDropOutConflictsErrorPacket,{Object,GellingAgentDropOutConflicts}];
				Map[Message[Error::DropOutInGellingAgents,
					position,
					templateModel,
					#[[1]],
					#[[2]]
				]&,gellingAgentsDropOutConflictTuples]
			]
		],{gellingAgentsDropOutConflictsErrorPositions,gellingAgentsDropOutConflictsErrorPackets}]
	];

	(* 3. Error message about GellingAgents missing melting temperature *)
	If[messages && Length[gellingAgentsMissingMeltingPointErrorPositions]>0,
		MapThread[Function[{position,gellingAgentsMissingMeltingPointPacket},
			Module[{templateModel,inputFormula,gellingAgentsMissingMeltingPoint,erroneousInput},
				{templateModel,inputFormula,gellingAgentsMissingMeltingPoint} = Lookup[gellingAgentsMissingMeltingPointPacket,{Object,Formula,GellingAgentsMissingMeltingPoint},Null];
				erroneousInput = Which[
					NullQ[templateModel],
					inputFormula,

					NullQ[inputFormula],
					templateModel
				];
				Message[Error::GellingAgentMissingMeltingPoint,
					position,
					erroneousInput,
					gellingAgentsMissingMeltingPoint
				]
			]
		],{gellingAgentsMissingMeltingPointErrorPositions,gellingAgentsMissingMeltingPointPackets}]
	];

	(* 4. Error message about GellingAgents specified for MediaPhase->Liquid *)
	If[messages && Length[gellingAgentsForLiquidMediaErrorPositions]>0,
		MapThread[Function[{position,gellingAgentsForLiquidMediaErrorPacket},
			Module[{templateModel,gellingAgentsForLiquidMedia},
				{templateModel,gellingAgentsForLiquidMedia} = Lookup[gellingAgentsForLiquidMediaErrorPacket,{Object,GellingAgentsForLiquidMedia}];
				Message[Error::GellingAgentsForLiquidMedia,
					position,
					templateModel,
					gellingAgentsForLiquidMedia
				]
			]
		],{gellingAgentsForLiquidMediaErrorPositions,gellingAgentsForLiquidMediaErrorPackets}]
	];

	(* 5. Warning message about DropOuts that are not present in the template to begin with, will be ignored *)
	If[messages && Length[dropOutsMissingFromTemplateWarningPositions]>0,
		MapThread[Function[{position,dropOutsMissingFromTemplatePacket},
			Module[{templateModel,dropOutsNotPresentInTemplate,templateComposition},
				{templateModel,dropOutsNotPresentInTemplate,templateComposition} = Lookup[dropOutsMissingFromTemplatePacket,{Object,DropOutMissingFromTemplate,Composition}];
				Message[Warning::DropOutMissingFromTemplate,
					position,
					templateModel,
					dropOutsNotPresentInTemplate,
					templateComposition
				]
			]
		],{dropOutsMissingFromTemplateWarningPositions,dropOutsMissingFromTemplatePackets}]
	];

	(* 6. Warning message about Supplements that already present in the template *)
	If[messages && Length[redundantSupplementInFormulaWarningPositions]>0,
		MapThread[Function[{position,redundantSupplementInFormulaPacket},
			Module[{templateModel,redundantSupplementsFromTemplate,templateFormula},
				{templateModel,redundantSupplementsFromTemplate,templateFormula} = Lookup[redundantSupplementInFormulaPacket,{Object,RedundantSupplements,Formula}];
				Message[Warning::RedundantSupplements,
					position,
					redundantSupplementsFromTemplate,
					templateModel,
					templateFormula
				]
			]
		],{redundantSupplementInFormulaWarningPositions,redundantSupplementInFormulaPackets}]
	];


	(* 7. Warning message about GellingAgents that already present in the template *)
	If[messages && Length[redundantGellingAgentInFormulaWarningPositions]>0,
		MapThread[Function[{position,redundantGellingAgentInFormulaPacket},
			Module[{templateModel,redundantGellingAgentsFromTemplate,templateFormula},
				{templateModel,redundantGellingAgentsFromTemplate,templateFormula} = Lookup[redundantGellingAgentInFormulaPacket,{Object,RedundantGellingAgents,Formula}];
				Message[Warning::RedundantGellingAgents,
					position,
					redundantGellingAgentsFromTemplate,
					If[MatchQ[templateModel,ObjectP[]],templateModel,"the provided input"],
					templateFormula
				]
			]
		],{redundantGellingAgentInFormulaWarningPositions,redundantGellingAgentInFormulaPackets}]
	];

	invalidSupplementsOption = If[
		Or[
			MemberQ[supplementDropOutConflictsErrorQs,True],
			MemberQ[invalidFormulaSupplementsQs,True]
		],
		{Supplements},
		{}
	];
	invalidDropOutsOption = If[
		Or[
			MemberQ[supplementDropOutConflictsErrorQs,True],
			MemberQ[invalidFormulaDropOutsQs,True]
		],
		{DropOuts},
		{}
	];
	invalidGellingAgentsOption = If[
		Or[
			MemberQ[gellingAgentsDropOutConflictsErrorQs,True],
			MemberQ[gellingAgentsForLiquidMediaErrorQs,True],
			MemberQ[gellingAgentsMissingMeltingPointErrorQs,True]
		],
		{GellingAgents},
		{}
	];

	invalidOptions = DeleteDuplicates[Flatten[{
		invalidFormulaSupplementsOption,
		invalidFormulaDropOutsOption,
		invalidSupplementsOption,
		invalidDropOutsOption,
		invalidGellingAgentsOption
	}]];

	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption,invalidOptions]
	];

	dropOutInSupplementsTest = If[!fastTrack && gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[!MatchQ[dropOutInSupplements,{}],
				Map[
					Test["At position "<>ToString[#[[1]]]<> " , The following components {" <>ObjectToString[#[[3]]]<> "} specified for the DropOuts option is also present in the composition of "<>ObjectToString[#[[4]][[All,1]]]<>" specified for the Supplements option.",
						False,
						True
					]&,dropOutInSupplements
				],
				Nothing
			];
			passingTest = If[MatchQ[dropOutInSupplements,{}],
				Test["None of the components specified for the DropOuts option is present in the composition of samples specified for the Supplements Option.",
					True,
					True
				],
				Nothing
			];
			{failingTest,passingTest}
		],
		{}
	];

	supplementsInTemplateModelFormulaTest = If[!fastTrack && gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!MatchQ[formulaPacketsWithRedundantSupplements,{}],
				Map[
					Warning["At position "<>ToString[#[[1]]]<>", the specified supplement {"<>ToString[#[[3]][[2]]]<>"} is already present in the template model media {"<>ObjectToString[#[[2]]]<>"}, whose formula is "<>ToString[Lookup[#[[3]][[1]],Formula]],
						False,
						True
					]&,supplementsInTemplateModelFormula
				],
				Nothing
			];
			passingTest=If[MatchQ[supplementsInTemplateModelFormula,{}],
				Test["None of the specified Supplements are already present in the formulas of the provided template media models."],
				True,
				True
			];
			{failingTest,passingTest}
		],
		{{},{}}
	];

	(* Gather all tests *)
	allTests = Cases[Flatten[{
		invalidNameTest,
		invalidFormulaSupplementOptionTest,
		invalidFormulaDropOutOptionsTest,
		dropOutInSupplementsTest,
		supplementsInTemplateModelFormulaTest
	}], TestP];

	If[!gatherTests && Length[invalidOptions] > 0,
		outputSpecification/.{Result-> {$Failed, resolvedOptions},Tests->allTests},
		outputSpecification/.{Result-> {uploadMediaInputs, resolvedOptions},Tests->allTests}
	]
];

(* padUploadStockSolutionOptions helper *)
padUploadStockSolutionOptions[ops:OptionsPattern[],length:NumberP]:=Module[
	{range},
	range=Range[length];
	Map[
		Function[
			{inputNumber},
			Map[
				Function[
					{op},
					If[MatchQ[Values[op],_List],
						Keys[op]->Values[op][[inputNumber]],
						op
					]
				],
				ops
			]
		],
		range
	]
];