(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Constants*)


DefineConstant[
	$MinStockSolutionFilterVolume,
	2 Milliliter,
	"The minimum volume of a stock solution that can be filtered by supported filtration methods without unreasonable dead volume."
];

DefineConstant[
	$MinStockSolutionpHVolume,
	20 Milliliter,
	"The minimum volume of a stock solution that can be pH titrated using the available pH probes."
];
DefineConstant[
	$MinStockSolutionSolventVolume,
	2 Milliliter,
	"The minimum total volume a fill-to-volume stock solution can have to ensure accurate volumetric measurement during filling to volume."
];
DefineConstant[
	$MinStockSolutionUltrasonicSolventVolume,
	5 Milliliter,
	"The minimum total volume a fill-to-volume stock solution can have to ensure accurate ultrasonic distance measurements during filling to volume."
];
DefineConstant[
	$MaxStockSolutionSolventVolume,
	20 Liter,
	"The maximum total volume a fill-to-volume stock solution can have to ensure accurate ultrasonic distance measurements during filling to volume."
];

DefineConstant[
	$MinStockSolutionComponentVolume,
	0.1 Microliter,
	"The minimum volume of a component that will be included in a stock solution."
];

DefineConstant[
	$MaxStockSolutionComponentVolume,
	20 Liter,
	"The maximum volume of a component that will be included in a stock solution."
];

DefineConstant[
	$MinStockSolutionComponentMass,
	1.0 Milligram,
	"The minimum mass of a component that will be included in a stock solution."
];

DefineConstant[
	$MaxStockSolutionComponentMass,
	10 Kilogram,
	"The maximum mass of a component that will be included in a stock solution."
];

(* ::Subsection:: *)
(*Patterns*)


(* ::Subsection:: *)
(*UploadStockSolution*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadStockSolution,
	Options:>{
		(* --- Shared Fields --- *)
		(* Organizational Information *)
		{
			OptionName->StockSolutionTemplate,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
			],
			Description->"The existing stock solution model whose mixing, pH Titration, filtration, storage, and health/safety information should be used as defaults when creating a new stock solution model.",
			Category->"Organizational Information"
		},
		{
			OptionName->Name,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line,
				BoxText -> Null
			],
			Description->"The name that should be given to the stock solution model generated from the provided formula.",
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
			Description->"A list of possible alternate names that should be associated with this new stock solution.",
			ResolutionDescription->"Automatically resolves to contain the Name of the stock solution model, if one is provided.",
			Category->"Organizational Information"
		},
		{
			OptionName->Type,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>StockSolutionSubtypeP
			],
			Description->"The Constellation type that the new stock solution model should have, i.e. Model[Sample, <Type>].",
			ResolutionDescription->"Automatically resolves to the type of the provided template stock solution, or to StockSolution if no template is provided.",
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
							GreaterP[0 Cell/Liter],
							GreaterP[0 CFU / Liter],
							GreaterP[0 OD600]
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
							],
							CompoundUnit[
								{1, {CFU, {CFU}}},
								{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
							],
							{1, {OD600, {OD600}}}
						]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				],
				"Identity Model"->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[List@@IdentityModelTypeP]],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]
			}],
			Description->"The molecular composition of this model.",
			Category->"Organizational Information"
		},

		(* --- Incubation --- *)
		{
			OptionName -> Incubate,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description -> "Indicates if the stock solution should be incubated following component combination and filling to volume with solvent, either while mixing (if Mix -> True) or without mixing (if Mix -> False).",
			ResolutionDescription -> "Automatically resolves to True if any other incubate options are specified, or, if a template model is provided, resolves based on whether that template has incubation parameters.",
			Category->"Incubation"
		},
		{
			OptionName -> IncubationTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type->Quantity,
					Pattern:>RangeP[22 Celsius,$MaxIncubationTemperature],
					Units->Alternatives[Fahrenheit, Celsius]
				],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Description -> "Temperature at which the stock solution should be incubated for the duration of the IncubationTime following component combination and filling to volume with solvent.",
			ResolutionDescription -> "Automatically resolves to the maximum temperature allowed for the incubator and container. Resolves to 37 Celsius if the sample is being incubated, or Null if Incubate is set to False.",
			Category -> "Incubation"
		},
		{
			OptionName -> IncubationTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, $MaxExperimentTime],
				Units->{1,{Minute,{Minute,Hour}}}
			],
			Description -> "Duration for which the stock solution should be incubated at the IncubationTemperature following component combination and filling to volume with solvent. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the MixTime option.",
			ResolutionDescription -> "Automatically resolves to 0.5 Hour if Incubate is set to True and Mix is set to False, or Null otherwise.",
			Category -> "Incubation"
		},

		(* --- PostAutoclaveIncubation --- *)

		{
			OptionName->PostAutoclaveIncubate,
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the stock solution should be treated at a specified temperature following component combination and filling to volume with solvent.  May be used in conjunction with mixing.",
			ResolutionDescription->"Automatically resolves to True if any other incubate options are specified, or, if a template model is provided, resolves based on whether that template has incubation parameters.",
			Category->"Incubation"
		},
		{
			OptionName->PostAutoclaveIncubationTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[22 Celsius,$MaxIncubationTemperature],
				Units->Alternatives[Fahrenheit, Celsius]
			],
			Description->"Temperature at which the stock solution should be treated for the duration of the IncubationTime following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves to the maximum temperature allowed for the incubator and container. Resolves to 37 Celsius if the sample is being incubated, or Null if Incubate is set to False.",
			Category->"Incubation"
		},
		{
			OptionName->PostAutoclaveIncubationTime,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, $MaxExperimentTime],
				Units->{1,{Minute,{Minute,Hour}}}
			],
			Description->"Duration for which the stock solution should be treated at the IncubationTemperature following component combination and filling to volume with solvent.  Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the MixTime option.",
			ResolutionDescription->"Automatically resolves to 0.5 Hour if Incubate is set to True and Mix is set to False, or Null otherwise.",
			Category->"Incubation"
		},

		(* --- Mixing --- *)
		{
			OptionName -> Mix,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description -> "Indicates if the stock solution should be mixed following component combination and filling to volume with solvent.",
			ResolutionDescription -> "Automatically resolves to True for a new formula, or, if a template model is provided, resolves based on whether that template has mixing parameters.",
			Category->"Mixing"
		},
		{
			OptionName -> MixUntilDissolved,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the stock solution should be mixed in an attempt to completed dissolve any solid components following component combination and filling to volume with solvent.",
			ResolutionDescription -> "Automatically resolves to False if Mix is set to True, or to Null if Mix is set to False.",
			Category->"Mixing"
		},
		{
			OptionName->MixTime,
			Default->Automatic,
			AllowNull->True,
			Widget-> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {1,{Minute,{Minute,Hour}}}
			],
			Description-> "The duration for which the stock solution should be mixed following component combination and filling to volume with solvent.",
			ResolutionDescription -> "Automatically resolves to 5 minutes for the Roll, Rock, Vortex, Sonicate, and Stir mix types; resolves to Null for Pipette and Invert mix types. Automatically resolves to Null if Mix is set to False. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the IncubationTime option.",
			Category->"Mixing"
		},
		{
			OptionName -> MaxMixTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Second,$MaxExperimentTime],
				Units->{1,{Minute,{Second,Minute,Hour}}}
			],
			Description -> "The maximum duration for which the stock solution should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
			ResolutionDescription -> "Automatically resolves based on whether MixUntilDissolved is set to True. If MixUntilDissolved is False, resolves to Null.",
			Category->"Mixing"
		},
		{
			OptionName -> MixType,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> MixTypeP
			],
			Description -> "The style of motion used to mix the stock solution following component combination and filling to volume with solvent. If this stock solution model is ever prepared at a volume such that this form of mixing is no longer possible, another mix type may be used instead.",
			ResolutionDescription -> "Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
			Category -> "Mixing"
		},
		{
			OptionName -> Mixer,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type->Object,
				Pattern :> ObjectP[MixInstrumentModels]
			],
			Description -> "The instrument that should be used to mix the stock solution following component combination and filling to volume with solvent. If this stock solution model is ever prepared at a volume such that this mixer cannot properly mix the solution, another mixer may be used instead.",
			ResolutionDescription -> "Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
			Category -> "Mixing"
		},
		{
			OptionName -> MixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinMixRate, $MaxMixRate],
				Units->RPM
			],
			Description -> "The frequency of rotation the mixing instrument should use to mix the stock solutions following component combination and filling to volume with solvent. If this stock solution model is ever prepared at a volume such that its mixer cannot mix and this rate, another rate may be chosen in accordance with the mixer used instead.",
			ResolutionDescription -> "Automatically resolves based on the provided model or template's value; if none is provided, resolves to Null.",
			Category -> "Mixing"
		},
		{
			OptionName -> NumberOfMixes,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 50, 1]],
			Description -> "Number of times the samples should be mixed if MixType: Pipette or Invert, is chosen.",
			ResolutionDescription -> "Automatically, resolves based on the MixType.",
			Category -> "Mixing"
		},
		{
			OptionName -> MaxNumberOfMixes,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
			Description -> "Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
			ResolutionDescription -> "Automatically resolves based on the MixType and container of the sample.",
			Category -> "Mixing"
		},

		(* --- PostAutoclaveMix --- *)
		{
			OptionName->PostAutoclaveMix,
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the components of the stock solution should be mechanically incorporated following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves to True if a new stock solution formula is provided, to True if an existing stock solution model with mixing parameters is provided, and to False if the provided stock solution model has no mixing parameters.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMixType,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>MixTypeP
			],
			Description->"The style of motion used to mechanically incorporate the components of the stock solution following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves based on the Volume option and size of the container in which the stock solution is prepared.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMixUntilDissolved,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the complete dissolution of any solid components should be verified following component combination, filling to volume with solvent, and any specified mixing steps.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMixer,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Object,
				Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
			],
			Description->"The instrument that should be used to mechanically incorporate the components of the stock solution following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves based on the MixType and the size of the container in which the stock solution is prepared.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMixTime,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Hour,$MaxExperimentTime],
				Units->{1,{Minute,{Second,Minute,Hour}}}
			],
			Description->"The duration for which the stock solution should be mixed following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves from the MixTime field of the stock solution model. If the model has no preferred time, resolves to 3 minutes. If MixType is Pipette or Invert, resolves to Null. 0 minutes indicates no mixing. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the IncubationTime option.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMaxMixTime,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Second,$MaxExperimentTime],
				Units->{1,{Minute,{Second,Minute,Hour}}}
			],
			Description->"The maximum duration for which the stock solutions should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves based on the MixType if MixUntilDissolved is set to True. If MixUntilDissolved is False, resolves to Null.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMixRate,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Quantity,
				Pattern:>RangeP[$MinMixRate, $MaxMixRate],
				Units->RPM
			],
			Description->"The frequency of rotation the mixing instrument should use to mechanically incorporate the components of the stock solutions following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves based on the MixType and the size of the container in which the solution is prepared.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveNumberOfMixes,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[Type->Number, Pattern:>RangeP[1, 50, 1]],
			Description->"The number of times the stock solution should be mixed by inversion or repeatedly aspirated and dispensed using a pipette following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves to 10 when MixType is Pipette, 3 when MixType is Invert, or Null otherwise.",
			Category->"Mixing"
		},
		{
			OptionName->PostAutoclaveMaxNumberOfMixes,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type->Number,
				Pattern:>RangeP[1, 50, 1]
			],
			Description->"The maximum number of times the stock solutions should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
			ResolutionDescription->"Automatically resolves based on the MixType if MixUntilDissolved is set to True, and to Null otherwise.",
			Category->"Mixing"
		},

		(* --- pH Titration ---  *)
		{
			OptionName -> AdjustpH,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the pH of this stock solution should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
			ResolutionDescription -> "Automatically set to True if any other pHing options are specified, or if NominalpH is specified in the template model, or False otherwise.",
			Category -> "pH Titration"
		},
		{
			OptionName->NominalpH,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Number,
				Pattern :> RangeP[0,14]
			],
			Description -> "The pH to which this stock solution should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
			ResolutionDescription -> "Automatically resolves based on the NominalpH of the template model, or 7 if AdjustpH is True, or to Null otherwise.",
			Category->"pH Titration"
		},
		{
			OptionName->MinpH,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Number,
				Pattern :> RangeP[0,14]
			],
			Description -> "The minimum allowable pH this stock solution should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent and/or mixing.",
			ResolutionDescription->"Automatically resolves to 0.1 below the NominalpH if specified, or to Null if NominalpH is Null.",
			Category->"pH Titration"
		},
		{
			OptionName->MaxpH,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Number,
				Pattern :> RangeP[0, 14]
			],
			Description -> "The maximum allowable pH this stock solution should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent, and/or mixing.",
			ResolutionDescription->"Automatically resolves to 0.1 above the NominalpH if specified, or to Null if NominalpH is Null.",
			Category->"pH Titration"
		},
		{
			OptionName->pHingAcid,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Object,
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
				Type -> Object,
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
			ResolutionDescription -> "Automatically resolves to Null for a new formula, or to the same as the MaxNumberOfpHingCycles of a provided template model.",
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
			Description->"Indicates the maximum volume of pHingAcid and pHingBase that can be added during the course of titration before the experiment will continue, even if the NominalpH is not reached.",
			ResolutionDescription -> "Automatically resolves to Null for a new formula, or to the same as the MaxpHingAdditionVolume of a provided template model.",
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
			ResolutionDescription -> "Automatically resolves to Null for a new formula, or to the same as the MaxAcidAmountPerCycle of a provided template model.",
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
			ResolutionDescription -> "Automatically resolves to Null for a new formula, or to the same as the MaxBaseAmountPerCycle of a provided template model.",
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
			OptionName -> Filter,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description -> "Indicates if the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or, if a template model is provided, resolves based on whether that template has filtration parameters.",
			Category->"Filtration"
		},
		{
			OptionName->FilterMaterial,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> FilterMembraneMaterialP
			],
			Description->"The material through which the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
			ResolutionDescription->"Automatically resolves to a material for which filters exist, or to Null if Filter is set to False.",
			Category->"Filtration"
		},
		{
			OptionName->FilterSize,
			Default->Automatic,
			AllowNull->True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> FilterSizeP
			],
			Description->"The size of the membrane pores through which the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
			ResolutionDescription->"Automatically resolves to a membrane pore size for which filters exist, or to Null if Filter is set to False.",
			Category->"Filtration"
		},

		{
			OptionName->Autoclave,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"Indicates that this stock solution should be autoclaved once all components are added.",
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
			ResolutionDescription->"The AutoclaveProgram automatically resolves to Liquid if the Autoclave option is set to True for a given stock solution",
			Category->"Autoclaving"
		},

		(* --- Storage Information --- *)
		{
			OptionName->OrderOfOperations,
			Default->Automatic,
			AllowNull->True,
			Widget->Adder[
				Widget[Type->Enumeration, Pattern:>Alternatives[FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration,
					Autoclave, FixedHeatSensitiveReagentAddition, PostAutoclaveIncubation]]
			],
			Description->"The order in which the stock solution should be created. By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped.",
			ResolutionDescription->"By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped.",
			Category->"Preparation Information"
		},
		{
			OptionName -> FillToVolumeMethod,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> FillToVolumeMethodP
			],
			Description -> "The method by which to add the Solvent to the bring the stock solution up to the TotalVolume.",
			ResolutionDescription -> "Resolves to Null if there is no Solvent/TotalVolume. Resolves to Ultrasonic if the Solvent is not UltrasonicIncompatible. Otherwise, will resolve to Volumetric. If Ultrasonic measurement is not possible, the solution will be prepared via VolumetricFlask.",
			Category -> "Preparation Information"
		},
		{
			OptionName->GraduationFilling,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the Solvent specified in the stock solution model is added to bring the stock solution model up to the TotalVolume based on the horizontal markings on the container indicating discrete volume levels, not necessarily in a volumetric flask.",
			Category->"Hidden"
		},
		{
			OptionName -> VolumeIncrements,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinStockSolutionComponentVolume,$MaxStockSolutionComponentVolume],
					Units -> Alternatives[Milliliter, Microliter, Liter]
				],
				Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinStockSolutionComponentVolume,$MaxStockSolutionComponentVolume],
						Units -> Alternatives[Milliliter, Microliter, Liter]
					]
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[{}]
				]
			],
			Description -> "A list of volumes at which this stock solution can be prepared.  If specified, requested volume will be scaled up to the next highest VolumeIncrement (or multiple of the highest VolumeIncrement).",
			ResolutionDescription -> "If using a fixed aliquot component, will resolve to total volume of the stock solution model. If using a tablet component, resolves to the smallest volume that can be obtained without needing to divide a tablet.  Otherwise resolves to Null.",
			Category -> "Preparation Information"
		},
		{
			OptionName -> Resuspension,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if one of the components in the stock solution is a sample which can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps.",
			ResolutionDescription -> "Automatically resolves to True if one of the components is a FixedAmount sample. Otherwise, automatic resolves to False.",
			Category -> "Preparation Information"
		},
		{
			OptionName->PrepareInResuspensionContainer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicate if the stock solution should be prepared in the original container of the FixedAmount component in its formula. PrepareInResuspensionContainer cannot be True if there is no FixedAmount component in the formula, and it is not possible if the specified amount does not match the component's FixedAmount. PrepareInResuspensionContainer cannot be True if the StockSolutionModel is specified by UnitOperations.",
			ResolutionDescription->"Automatically resolves to False unless otherwise specified.",
			Category->"Preparation Information"
		},
		(*TODO: right not fulfillment scale is not kept in the model (but we are downloading it). eventually we will want to add it. *)
		{
			OptionName -> FulfillmentScale,
			Default -> Dynamic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Dynamic,Fixed]
			],
			Description -> "Indicates if the stock solution should be dynamically scaled to any required scale, or restricted to the specified VolumeIncrements (or multiple of the highest VolumeIncrement).",
			ResolutionDescription -> "Defaults to Dynamic if no VolumeIncrements are specified, or Fixed if VolumeIncrements are provided.",
			Category->"Hidden"
		},
		{
			OptionName->PreferredContainers,
			Default->Automatic,
			AllowNull->False,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[{}]
				],
				Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Container,Vessel]]
					]
				]
			],
			Description->"A list of containers that should be selected from first, when choosing a container to store this stock solution, as long as the volume involved is within the range of the PreferredContainer's Min and Max volumes.",
			ResolutionDescription->"Will default to any PreferredContainers found in StockSolutionTemplate, otherwise it will default to Null",
			Category->"Preparation Information"
		},
		{
			OptionName->LightSensitive,
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicates if the stock solution contains components that may be degraded or altered by prolonged exposure to light, and thus should be prepared in light-blocking containers when possible.",
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
			Description->"Indicates if stock solution samples of this model expire after a given amount of time.",
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
			Description -> "The percent of the total initial volume of samples of this stock solution below which the stock solution will automatically marked as AwaitingDisposal.  For instance, if DiscardThreshold is set to 5% and the initial volume of the stock solution was set to 100 mL, that stock solution sample is automatically marked as AwaitingDisposal once its volume is below 5mL.",
			Category -> "Storage Information"
		},
		{
			OptionName->ShelfLife,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0*Day],Units->{1,{Month,{Hour,Day,Week,Month,Year}}}
			],
			Description->"The length of time after preparation that stock solutions of this model are recommended for use before they should be discarded.",
			ResolutionDescription->"If Expires is set to True, automatically resolves to the shortest of any shelf lives of the formula components and solvent, or 5 years if none of the formula components expire. If Expires is set to False, resolves to Null.",
			Category->"Storage Information"
		},
		{
			OptionName->UnsealedShelfLife,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0*Day],Units->{1,{Day,{Month,Day,Week,Month,Year}}}
			],
			Description->"The length of time after DateUnsealed that stock solutions of this model are recommended for use before they should be discarded.",
			ResolutionDescription->"If Expires is set to True, automatically resolves to the shortest of any unsealed shelf lives of the formula components and solvent, or Null if none of the formula components have recorded unsealed shelf lives. If Expires is set to False, resolves to Null.",
			Category->"Storage Information"
		},
		{
			OptionName->DefaultStorageCondition,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>(AmbientStorage|Refrigerator|Freezer|DeepFreezer)
				],
				Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
			],
			Description->"The condition in which stock solutions of this model are stored when not in use by an experiment.",
			ResolutionDescription->"Automatically resolves based on the default storage conditions of the formula components and any safety information provided for this solution.",
			Category->"Storage Information"
		},
		{
			OptionName -> TransportTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Transport Cold" -> Widget[Type -> Quantity, Pattern :> RangeP[-86 Celsius, 10 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
				"Transport Warmed" -> Widget[Type -> Quantity, Pattern :> RangeP[27 Celsius, 105 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}]
			],
			Description -> "Indicates the temperature by which stock solutions of this model should be heated or chilled during transport when used in experiments.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the TransportTemperature property of a provided template model.",
			Category->"Storage Information"
		},
		(* ExperimentPlateMedia options *)
		{
			OptionName->PlateMedia,
			Default->Automatic,
			Description->"Indicates if the prepared stock solution or media is subsequently transferred to plates for future use for cell incubation and growth.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			ResolutionDescription->"Automatically set to True if MediaPhase is set to Solid or SemiSolid and/or if GellingAgents is specified."
		},
		{
			OptionName -> HeatSensitiveReagents,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
					]
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[{}]
				]
			],
			Description -> "Indicates that the given component of the formula is heat-sensitive and therefore must be added after autoclave.",
			Category -> "Preparation"
		},
		{
			OptionName->Supplements,
			Default->None,
			Description->"Additional substances that would traditionally appear in the name of the media, such as 2% Ampicillin in LB + 2% Ampicillin. These components will be added to the Formula field of the Model[Sample,Media] but are specially called out in the media name following the \"+\" symbol. For example, ExperimentMedia[Model[Sample,Media,\"Liquid LB\"], Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter}] will create a new Model[Sample,Media,\"Liquid LB + Ampicillin, 50*Microgam/Liter\"] with Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter} added to the Formula of the input media.",
			AllowNull->False,
			Category->"Preparation",
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
			]
		},
		{
			OptionName->DropOuts,
			Default->None,
			Description->"Substances from the Formula of ModelMedia that are completely excluded in the preparation of media. When specified, a new Model[Sample,Media] will be created with Formula that excludes these components from the Formula of the input media model. For example, if the user calls ExperimentMedia[Model[Sample,Media,\"Synthetic Complete Medium\"], DropOuts->Model[Molecule,\"Uracil\"], a new Model[Sample,Media,\"Synthetic Complete Medium - Uracil] will be created whose Formula corresponds to the Formula of Model[Sample,Media,\"Synthetic Complete Medium\"] lacking Uracil.",
			AllowNull->False,
			Category->"Preparation",
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
			Default->Null,
			Description->"The types and amount by weight volume percentages of substances added to solidify the prepared media.",
			AllowNull->True,
			Category->"Preparation",
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
							Pattern:>ObjectP[{Model[Sample],Object[Sample],Model[Molecule]}]
						]
					}
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[None,Automatic,{None}]
				]
			],
			ResolutionDescription->"Automatically set to {Model[Sample, \"Agar\"], 20*Gram/Liter} if MediaPhase is set to Solid. If any GellingAgent is detected in the Formula field of Model[Sample,Media], it will be removed from the Formula and ."
		},
		{
			OptionName->MediaPhase,
			Default->Null,
			Description->"The physical state of the prepared media at ambient temperature and pressure." (*TODO update description to explain SemiSolid *),
			AllowNull->True,
			Category->"Preparation",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[MediaPhaseP]
			],
			ResolutionDescription->"Automatically set to Liquid if GellingAgents is not specified."
		},

		(* Physical Properties *)
		{
			OptionName->Density,
			Default->Automatic,
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
			ResolutionDescription -> "Automatically resolves to the same density as the template model, or to Null if no template is provided.",
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
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if stock solutions of this model must be handled in a ventilated enclosure.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the Ventilated property of a provided template model.",
			Category->"Health & Safety"
		},
		{
			OptionName->Flammable,
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if stock solutions of this model are easily set aflame under standard conditions.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the Flammable property of a provided template model.",
			Category->"Health & Safety"
		},
		{
			OptionName->Acid,
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if stock solutions of this model are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the Acid property of a provided template model.",
			Category->"Health & Safety"
		},
		{
			OptionName->Base,
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if stock solutions of this model are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the Base property of a provided template model.",
			Category->"Health & Safety"
		},
		{
			OptionName->Fuming,
			Default -> Automatic,
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if stock solutions of this model emit fumes spontaneously when exposed to air.",
			ResolutionDescription -> "Automatically resolves to False for a new formula, or to the same as the Fuming property of a provided template model.",
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
			ResolutionDescription -> "Automatically resolves to None for a new formula, or to the same as the IncompatibleMaterials listing of a provided template model.",
			Category->"Compatibility"
		},
		{
			OptionName -> UltrasonicIncompatible,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if stock solutions of this model cannot have their volumes measured via the ultrasonic distance method due to vapors interfering with the reading.",
			ResolutionDescription -> "Automatically resolves to True if 50% or more of the volume consists of models that are also UltrasonicIncompatible, or to the same as the UltrasonicIncompatible listing of a provided template model.",
			Category -> "Compatibility"
		},
		{
			OptionName -> CentrifugeIncompatible,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if centrifugation should be avoided for stock solutions of this model.",
			Category -> "Compatibility"
		},
		{
			OptionName -> SafetyOverride,
			Default -> False,
			Description ->  "Indicates if the automatic safety checks should be overridden when making sure that the order of component additions does not present a laboratory hazard (e.g. adding acids to water vs water to acids). If this option is set to True, you are certifying that you are sure the order of component addition specified will not cause a safety hazard in the lab.",
			AllowNull -> True,
			Category -> "Compatibility",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},

		(* this option will be used only when UploadStockSolution is called in *)
		{
			OptionName->Preparable,
			Default->Automatic,
			AllowNull->False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicates if the stock solution can be prepared by ExperimentStockSolution.",
			Category->"Hidden"
		},

		(* Hidden option for when called via ExperimentStockSolution via Engine to ensure that a newly-generated model gets the author of the protocol *)
		{
			OptionName->Author,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[Object[User]]
			],
			Description->"The author of the root protocol that who should be listed as author of a new stock solution model created by this function. This option is intended to be passed from ExperimentStockSolution when it is called by ResourcePicking in Engine only.",
			Category->"Hidden"
		},

		UploadOption,
		FastTrackOption,
		CacheOption,
		OutputOption,
		SimulationOption
	}
];

Warning::TemplateOptionUnused="The provided StockSolutionTemplate option `1` is not the same object as the template input `2`. The input `2` will be used as the template.";
Error::InvalidResuspensionOption="The Resuspension option needs to be True if there is a FixedAmounts component, and False if there is no FixedAmounts components in the formula.";
Warning::NoVolumeIncrementsProvided="The provided FulfillmentScale option was specified as `1`, but no VolumeIncrements were specified. Please provide VolumeIncrements if you would like to specify Fixed increments for fulfillment.";
Error::DeprecatedTemplate="The provided template input `1` is deprecated and not available to serve as a template for creation of a new stock solution model (check the Deprecated field). Please either provide a non-deprecated stock solution model to use as a template, or a new formula.";
Warning::DeprecatedTemplate="The provided StockSolutionTemplate option `1` is deprecated; it will not be used for default option resolution.";
Error::StockSolutionNameInUse="The provided Name `1` is already in use in Constellation. Please choose a different Name for this new stock solution model, or consider using the existing stock solution model with this name.";
Error::NoNominalpH="The MinpH, MaxpH, pHingAcid, and/or pHingBase options were specified, but no NominalpH was provided. Please explicitly provide a NominalpH in order to define these additional pHing options.";
Error::pHOrderInvalidUSS="The provided MinpH, NominalpH, and MaxpH options are not in increasing order. Please ensure that, when providing 2 or more of MinpH, NominalpH, and MaxpH, the ordering MinpH < NominalpH < MaxpH is followed.";
Error::FilterOptionConflictUSS="The Filter parameters `1` are specified; however, the overall Filter boolean was not set to True. Please either do not specify any filtration parameters if Filter is not set to True, or set Filter to True to enable specification of filtration parameters.";
Error::StorageCombinationUnsupported="The DefaultStorageCondition resolved to `1`; however, in combination with the provided Flammable, Acid, and Base options, this storage condition combination is not currently supported by ECL. Please contact ECL to inquire as to when this combination of storage conditions will be available";
Warning::ComponentOrder="In the provided formula, at the time of addition of the acids, `1`, the combined acid volumes are `2` of the combined volume of solvents already added, which are above 20%. Without a manual override, the component addition order will be changed to `3` such that the acids are added after other liquid components. If you are certain that adding the components in the order you have specified will not present a safety hazard, you may certify that this is a true statement using the SafetyOverride->True argument, which will then revert back to the order of additions as you have specified it.";
Error::MixTypeRequired="If any of the following option(s) are provided: `1`, MixType must also be provided.  Please specify MixType or leave MixType, Mixer, MixRate, NumberOfMixes, and MaxNumberOfMixes all as their default values.";
Error::InvalidUltrasonicFillToVolumeMethod = "The given FillToVolumeMethod option is invalid for the input(s)`1`. Fill to volume stock solutions cannot be generated via Ultrasonic measurement if the resulting stock solution is UltrasonicIncompatible.  Please change FillToVolumeMethod, or use a stock solution that is not ultrasonic incompatible.";
Error::InvalidVolumetricFillToVolumeMethod = "The given FillToVolumeMethod option is invalid for the input(s)`1`. Stock solutions cannot be generated via Volumetric measurement if the requested volume is over `2` (the largest volumetric flask`3`). Please change this option to create a valid stock solution.";
Error::InvalidFillToVolumeMethodNoSolvent = "The given FillToVolumeMethod option is invalid for the input(s)`1`. Fill to volume stock solutions must specify a fill to volume solvent in the input.  Please specify one to create a valid stock solution.";
Error::InvalidOrderOfOperations="The given option OrderOfOperations is not valid for the given input(s). FixedReagentAddition must occur first. Incubation (if present) must occur after any pHTitration/FillToVolume and Filtration must occur last (if present). Steps may not be repeated. Please fix the order of this option in order to generate a valid stock solution.";
Error::ConflictingUnitOperationsOptions="The following option(s), `1`, are set to a value that is not Null or False. The UnitOperations input cannot be specified with other formula preparation options. Please allow these formula options to automatically resolve to False or Null in order for the UnitOperations input to be used.";
Error::InvalidLabelContainerUnitOperationInput="The UnitOperations input must begin with a LabelContainer UnitOperation, if specified. Please set the first UnitOperation of the input to be a LabelContainer UnitOperation, that represents the ContainerOut that the stock solution will be created in.";
Error::UnitOperationsContainObject="The specified UnitOperations contain Object[Sample]/Object[Container](s) (`1`) that may not be available in future experiments. Please make sure to specify samples and containers exclusively by Models.";
Error::InvalidOrderOfOperationsForpH="The given option OrderOfOperations is not valid for the given inputs. Following this order, pHTitration happens before any liquid component is added to the stock solution. pHTitration cannot be performed on solid sample. Please consider performing FillToVolume before pHTitration or adding a fixed amount of solvent into the stock solution formula.";
Warning::NewModelCreation="A new model (`3`) will be created when using `2` as input template model, because the options `1` are different from the ones in the input template model `2`.";
Warning::ExistingModelReplacesInput="An existing model (`1`) fulfills the input template model (`2`) with specified options. The existing model (`1`) will be used as the alternative preparation template for this stock solution.";
Error::UnitOperationInvalidVolumeIncrement="The specified VolumeIncrement(s) (`1`) is not compatible with the total volume (`2`) made by this stock solution. Please consider setting VolumeIncrement to Automatic, or to the total volume made by this set of UnitOperations.";
Warning::SpecifedMixRateNotSafe = "The specified mix rate exceeds the MaxOverheadMixRate of the resolved ContainerOut (`1`). Please consider about using a smaller mix rate to avoid overflow or spillage during mixing.";

(* ::Subsubsection::Closed:: *)
(*UploadStockSolution*)


(* --- OVERLOAD 1: Plain Formula Overload --- *)
(*
	- Pass to the core overload
	- Send Null for solvent, total volume, and template model inputs
*)
UploadStockSolution[myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample],Object[Sample]}]}..},myOptions:OptionsPattern[UploadStockSolution]]:=uploadStockSolutionModel[myFormulaSpec,Null,Null,Null,myOptions];


(* --- OVERLOAD 2: Formula Overload with FillToVolumeSolvent (Fill to Volume) --- *)
(*
	- Pass to the core overload
	- Send Null as the template model input
*)
UploadStockSolution[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample],Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[UploadStockSolution]
]:=uploadStockSolutionModel[myFormulaSpec,mySolvent,myFinalVolume,Null,myOptions];

(* --- OVERLOAD 3: Existing StockSolutionTemplate Model Overload --- *)
(*
	- Download the formula and all information required for option defaulting
	- send into core overload that assumes validated formula and resolves options
	- make sure we didn't ALSO get a StockSolutionTemplate
*)
UploadStockSolution[
	myTemplateModel:ObjectP[{Model[Sample,StockSolution],Model[Sample,Media],Model[Sample,Matrix]}],
	myOptions:OptionsPattern[UploadStockSolution]
]:=Module[
	{listedOptions,outputSpecification,listedOutput,gatherTests,safeOptions,safeOptionTests,author,notebookDownload,templateModelPacket,
		userSpecifiedObjects,objectsExistQs,objectsExistTests,unitOperationsQ,templateUnitOps,unitOpsCompositionComponentPackets,
		unitOpsCompositionComponentSCPackets,templateSCPackets,
		formulaComponentPackets,formulaComponentSCPackets,solventPacketOrNull,solventSCPacketOrNull,authorNotebooks,componentAmounts,
		allComponentAndSolventSCPackets,fastTrack,templateOption,templateWarnings,templateDeprecated,templateDeprecatedTests,resolvedOptions,
		optionResolutionTests,defaultStorageConditionObject,defaultSCObjectTests,optionsRule,previewRule,testsRule,
		resultRule, unitOpsSimulation, simulation, templateTotalVolume, allTestTestResults, optionResolutionResult, allTests, defaultSCBool, allEHSFields,
		allComponentFields, allPreparatoryFormulaPackets, allPreparatoryFormulaPacketsWithFailed, safeOptionsWithTemplate, potentialContainerDownload, potentialContainers,
		volumetricFlasks, volumetricFlaskPackets},

	(* get the listed form of the options provided, for option helpers to chew on *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* default all unspecified or incorrectly-specified options *)
	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadStockSolution, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadStockSolution, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> safeOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* get the FastTrack option value assigned so we can skip the next checks if on the fast zone *)
	fastTrack = Lookup[safeOptions, FastTrack];

	(* pseudo-resolve the hidden Author option; either it's Null (meaning we're being called by a User, so they are the author); or it's passed via Engine, and is a root protocol Author *)
	author = If[MatchQ[Lookup[safeOptions, Author], ObjectP[Object[User]]],
		Lookup[safeOptions, Author],
		$PersonID
	];

	(* Check if the provided objects exist before we try to resolve anything *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[myTemplateModel],Values[listedOptions]],
		ObjectP[]
	];

	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests&&!fastTrack,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects,objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs)&&!fastTrack,
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Get all of the EHS fields that need to be updated. *)
	allEHSFields=ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]]/.{StorageCondition->DefaultStorageCondition};
	allComponentFields=DeleteDuplicates[Flatten[{Name, Deprecated, State, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet, FixedAmounts, UltrasonicIncompatible, CentrifugeIncompatible, Acid, Base, Composition, Density, Solvent, allEHSFields}]];
	potentialContainers=Intersection[Search[Model[Container, Vessel], Deprecated != True && DeveloperObject != True], PreferredContainer[All]];

	(* find all the volumetric flasks if we have at least one volumetric fill to volume*)
	volumetricFlasks = Search[Model[Container, Vessel, VolumetricFlask], Deprecated != True && MaxVolume != Null && DeveloperObject != True];

	(* download required information from the template model input and author; Quiet is JUST for the Tablet field from formula components (only in ObjectP[{Model[Sample],Object[Sample]}]) *)
	{
		{{
			templateModelPacket,
			formulaComponentPackets,
			unitOpsCompositionComponentPackets,
			formulaComponentSCPackets,
			unitOpsCompositionComponentSCPackets,
			templateSCPackets,
			allPreparatoryFormulaPacketsWithFailed,
			solventPacketOrNull,
			solventSCPacketOrNull
		}},
		notebookDownload,
		potentialContainerDownload,
		volumetricFlaskPackets
	} = Quiet[Download[
		{
			{myTemplateModel},
			{author},
			potentialContainers,
			volumetricFlasks
		},
		{
			{
				Packet[
					Name, Deprecated, Formula, FillToVolumeSolvent, FillToVolumeMethod, TotalVolume, Sterile, State, Tablet,

					MixUntilDissolved, MixTime, MaxMixTime, MixRate, MixType, Mixer, NumberOfMixes, MaxNumberOfMixes,

					NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,

					FilterMaterial, FilterSize,

					IncubationTime, IncubationTemperature,

					PreferredContainers, VolumeIncrements, FulfillmentScale, Preparable, Resuspension,

					LightSensitive, Expires, ShelfLife, UnsealedShelfLife, DefaultStorageCondition, DiscardThreshold,
					TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Pyrophoric,
					Fuming, IncompatibleMaterials, UltrasonicIncompatible, CentrifugeIncompatible,

					Autoclave, AutoclaveProgram,
					PrepareInResuspensionContainer, FillToVolumeParameterized,
					OrderOfOperations, UnitOperations, PreparationType, Composition, DefaultStorageCondition
				],
				Packet[Formula[[All, 2]][allComponentFields]],
				Packet[Composition[[All, 2]][allComponentFields]],
				Packet[Formula[[All, 2]][DefaultStorageCondition][{StorageCondition}]],
				Packet[Composition[[All, 2]][DefaultSampleModel][DefaultStorageCondition][{StorageCondition}]],
				Packet[DefaultStorageCondition[{StorageCondition}]],
				Packet[Formula[[All,2]][allComponentFields]],
				Packet[FillToVolumeSolvent[allComponentFields]],
				Packet[FillToVolumeSolvent[DefaultStorageCondition][{StorageCondition}]]
			},
			{
				FinancingTeams[Notebooks][Object],
				SharingTeams[Notebooks][Object]
			},
			{
				Packet[MaxOverheadMixRate]
			},
			{
				Packet[Object, MaxVolume, ContainerMaterials, Opaque]
			}
		},
		Cache->Lookup[safeOptions,Cache,{}],
		Simulation->Lookup[safeOptions,Simulation,Null]
	], {Download::FieldDoesntExist,Download::NotLinkField,Download::MissingField}];


	(* before we do anything, we should check that this template is based on UnitOperations *)
	unitOperationsQ = Length[Lookup[templateModelPacket, UnitOperations]]>0&&MatchQ[Lookup[templateModelPacket, PreparationType], UnitOperations];
	templateUnitOps = Lookup[templateModelPacket, UnitOperations, {}];

	(* Filter out any $Failed from our repeated traversal. *)
	allPreparatoryFormulaPackets=Cases[allPreparatoryFormulaPacketsWithFailed,PacketP[]];

	(* flatten out the notebooks; we will use these when generating the Result to look for AlternativePreparations *)
	authorNotebooks = DeleteDuplicates[Cases[Flatten[notebookDownload], ObjectReferenceP[Object[LaboratoryNotebook]]]];

	(* get the actual amount versions of the Formula from the template; be aware of tablet counts (Null unit) *)
	componentAmounts = If[!unitOperationsQ,
		Lookup[templateModelPacket, Formula][[All, 1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]},
		Lookup[templateModelPacket, Composition][[All, 1]]/.{unit : UnitsP[] :>Null}
	];

	(* assemble all default SC packets (used for some option resolution) *)
	allComponentAndSolventSCPackets = If[MatchQ[solventSCPacketOrNull, PacketP[]],
		Append[formulaComponentSCPackets, solventSCPacketOrNull],
		formulaComponentSCPackets
	];

	(* check that if we ALSO have the StockSolutionTemplate OPTION, it's the same as the input; make a warning if not *)
	templateOption = Lookup[safeOptions, StockSolutionTemplate];
	templateWarnings = If[!fastTrack,
		Module[{templateOptionDifferent, warning},

			(* set a boolean indicating if the template option is different than the input *)
			templateOptionDifferent = And[
				MatchQ[templateOption, ObjectP[]],
				!MatchQ[Download[templateOption, Object], Lookup[templateModelPacket, Object]]
			];

			(* make a warning for the situation *)
			warning = If[gatherTests,
				Warning["StockSolutionTemplate option, if provided, is the same object as template input. If StockSolutionTemplate option differs, it will be ignored and template input used.",
					templateOptionDifferent,
					False
				],
				Nothing
			];

			(* throw message warning *)
			If[!gatherTests && templateOptionDifferent,
				Message[Warning::TemplateOptionUnused, templateOption, myTemplateModel]
			];

			(* return the warning *)
			{warning}
		],

		(* on fast track, blast ahead *)
		{}
	];

	(* make a safeOptions with the StockSolutionTemplate option replaced with the input; this will help us when deciding whether to make a new stock solution or not *)
	safeOptionsWithTemplate = ReplaceRule[safeOptions, StockSolutionTemplate -> myTemplateModel];

	(* if the template is deprecated, this is a HARD error since it is the input where we're supposed to get the formula from *)
	{templateDeprecated, templateDeprecatedTests} = If[!fastTrack,
		Module[{deprecatedBool, test},

			(* determine indeed if it is *)
			deprecatedBool = TrueQ[Lookup[templateModelPacket, Deprecated]];

			(* make a test for it *)
			test = If[gatherTests,
				Test["StockSolutionTemplate model input " <> ToString[myTemplateModel] <> " is active (not deprecated).",
					deprecatedBool,
					False
				],
				Nothing
			];

			(* throw a message if not test *)
			If[!gatherTests && deprecatedBool,
				Message[Error::DeprecatedTemplate, myTemplateModel];
				Message[Error::InvalidInput, myTemplateModel]
			];

			(* return bool, test *)
			{deprecatedBool, {test}}
		],

	(* fast track, it's chilin *)
		{False, {}}
	];

	(* get the total volume from the template; could be Null *)
	templateTotalVolume = Lookup[templateModelPacket, TotalVolume, Null];

	(* resolve all options using the resolver *)
	(* unfortunately, resolveUploadStockSolutionOptions and newStockSolution both require a simulation if we're using unit ops, so lets get that done *)
	unitOpsSimulation = If[unitOperationsQ,
		ExperimentManualSamplePreparation[templateUnitOps, Output->Simulation],
		Null
	];

	(* make sure to take any simulation that was passed into account as well *)
	simulation = If[unitOperationsQ,
		UpdateSimulation[Lookup[safeOptionsWithTemplate, Simulation, Null]/. Null|{}->Simulation[], unitOpsSimulation],
		Lookup[safeOptionsWithTemplate, Simulation]
	];

	(* need to do this Check to know whether to return something or not *)
	optionResolutionResult = Check[
		{resolvedOptions, optionResolutionTests} = 	resolveUploadStockSolutionOptions[
			If[Not[unitOperationsQ],
				Transpose[{componentAmounts,formulaComponentPackets}],
				Transpose[{componentAmounts,unitOpsCompositionComponentPackets}]
			],
			solventPacketOrNull,
			templateTotalVolume,
			templateUnitOps,
			templateModelPacket,
			allPreparatoryFormulaPackets,
			If[unitOperationsQ,
				ReplaceRule[safeOptionsWithTemplate, Simulation->simulation],
				safeOptionsWithTemplate
			],
			Flatten[potentialContainerDownload],
			Flatten[volumetricFlaskPackets]
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* have to figure out the exact storage condition object - including safety information - to use; do a quick search; if we hit the Acid/base conflict, we won't get anything;
	 	don't bother, that is already being reported *)
	{defaultStorageConditionObject, defaultSCBool, defaultSCObjectTests} = Module[{rawStorageCondition, scObjectToUseOrFailed, test},

		(* Get the raw storage condition *)
		rawStorageCondition = Lookup[resolvedOptions, DefaultStorageCondition];

		(* Is the raw storage condition a Model[StorageCondition] or a symbol? *)
		scObjectToUseOrFailed = If[MatchQ[rawStorageCondition, _Symbol],
			(* We are dealing with a symbol. Lookup a suitable storage condition. *)
			First[Search[Model[StorageCondition],
				And[
					StorageCondition == Lookup[resolvedOptions, DefaultStorageCondition],
					Flammable == If[TrueQ[Lookup[resolvedOptions, Flammable]], True],
					Acid == If[TrueQ[Lookup[resolvedOptions, Acid]], True],
					Base == If[TrueQ[Lookup[resolvedOptions, Base]], True],
					Pyrophoric == Null,
					DeveloperObject != True
				]
			], $Failed],

			(* We are given a Model[StorageCondition]. Make sure that it matches the safety information. *)
			If[!ValidStorageConditionQ[
				TrueQ[Lookup[resolvedOptions, Flammable]],
				TrueQ[Lookup[resolvedOptions, Acid]],
				TrueQ[Lookup[resolvedOptions, Base]],
				False,
				rawStorageCondition
			],
				(* The storage condition is not valid. $Failed *)
				$Failed,
				(* The storage condition is valid, simply return it. *)
				rawStorageCondition
			]
		];

		(* make a test to see if we got one *)
		test = If[gatherTests,
			Test["The provided combination of Storage options corresponds to a supported ECL storage condition.",
				scObjectToUseOrFailed,
				ObjectP[Model[StorageCondition]]
			],
			Nothing
		];

		If[MatchQ[$UnitTestObject, ObjectP[]],
			Echo[scObjectToUseOrFailed, "scObjectToUseOrFailed"];
			Echo[rawStorageCondition, "scObjectToUseOrFailed"];
			Echo[resolvedOptions,"resolvedOptions"];
			Echo[{
				formulaComponentSCPackets,
				unitOpsCompositionComponentSCPackets,
				templateSCPackets,
				solventSCPacketOrNull
			}, "packets"];
		];

		(* yell if we didn't get one *)
		If[!gatherTests && MatchQ[scObjectToUseOrFailed, $Failed],
			Message[Error::StorageCombinationUnsupported, Lookup[resolvedOptions, DefaultStorageCondition]];
			Message[Error::InvalidOption, {DefaultStorageCondition, Flammable, Acid, Base}]
		];

		(* return the object-or-failed, and the test *)
		{scObjectToUseOrFailed, MatchQ[scObjectToUseOrFailed, ObjectP[Model[StorageCondition]]], {test}}
	];

	(* gather all the tests we've generated together *)
	allTests = Join[safeOptionTests, templateWarnings, templateDeprecatedTests, optionResolutionTests, defaultSCObjectTests];

	(* run the tests that we have generated to make sure we can go on *)
	allTestTestResults = If[gatherTests,
		RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		Not[TrueQ[templateDeprecated]] && TrueQ[defaultSCBool] && MatchQ[optionResolutionResult, Except[$Failed]]
	];

	(* prepare the options return rule; no index-matched options currently, so don't bother collapsing *)
	optionsRule = Options -> If[MemberQ[listedOutput, Options],
		RemoveHiddenOptions[UploadStockSolution, resolvedOptions],
		Null
	];

	(* function doesn't have a preview *)
	previewRule = Preview -> Null;

	(* accrue all of the Tests we generated *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* prepare the Result rule if asked; do not bother if we hit a failure on any of our above checks *)
	resultRule = Result -> If[MemberQ[listedOutput, Result],
		If[Not[TrueQ[allTestTestResults]],
			$Failed,
			If[!unitOperationsQ,
				newStockSolution[
					Transpose[{componentAmounts,formulaComponentPackets}],
					solventPacketOrNull,
					templateTotalVolume,
					Download[defaultStorageConditionObject, Object],
					!MatchQ[Lookup[safeOptionsWithTemplate, Name], _String],
					(* pass our hidden option for new model creation warning *)
					(* myTemplateModel is ObjectP[], if the input is model; Null, if the input is formula *)
					myTemplateModel,
					(* pass our hidden Author option and allowed notebooks separately *)
					author,
					authorNotebooks,
					resolvedOptions
				],
				newStockSolution[
					templateUnitOps,
					Download[defaultStorageConditionObject, Object],
					!MatchQ[Lookup[safeOptions, Name], _String],
					(* myTemplateModel is ObjectP[], if the input is model; Null, if the input is unitOps *)
					myTemplateModel,
					author,
					authorNotebooks,
					resolvedOptions,
					simulation
				]
			]
		],
		Null
	];

	(* return the requested outputs per the non-listed Output option *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}
];

(* --- OVERLOAD 4: UnitOperation Overload with Composition (specified or inferred) --- *)
(*
	- resolve all prep options to Null
	- Pass to the Core overload
	- Send Null as the solvent, final volume, and template model input
*)
UploadStockSolution[
	myUnitOperations:{ManualSamplePreparationP..}, myOptions:OptionsPattern[UploadStockSolution]
]:=Module[
	{
		listedOptions,safeOptions,safeOptionTests,outputSpecification,listedOutput,gatherTests,validLabelContainerPrimitive,unitOpsSpecifiedObjects,
		validLabelContainerPrimitiveTest,onlyModelsInUnitOpsQs,ModelsInUnitOpsTests,experimentMSPOptions,simulatedSamplePackets,experimentMSPTests,
		sampleComposition,validVolumeIncrementsQ,validVolumeIncrementsTests,volumeIncrements,updatedOptions,nullifiedOptions,finalVolume,uploadStockSolutionModelReturn,uploadStockSolutionModelReturnRule
	},

	(* get the listed form of the options provided, for option helpers to chew on *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadStockSolution, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadStockSolution, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* before we ever start we should check that everything is valid here *)
	(* If given primitives, make sure that the first primitive is a LabelContainer primitive. *)
	validLabelContainerPrimitive=And[
		MatchQ[FirstOrDefault[myUnitOperations], _LabelContainer],
		MatchQ[Lookup[FirstOrDefault[myUnitOperations][[1]], Container], ObjectP[Model[Container]]]
	];

	If[!gatherTests && !validLabelContainerPrimitive,
		Message[Error::InvalidLabelContainerUnitOperationInput];
		Message[Error::InvalidInput,myUnitOperations];
	];

	validLabelContainerPrimitiveTest=If[gatherTests,
		{Test["UnitOperation input begins with a LabelContainer UnitOperations:",validLabelContainerPrimitive,True]},
		{}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[!validLabelContainerPrimitive,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests, validLabelContainerPrimitiveTest],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* All unit operations related objects *)
	unitOpsSpecifiedObjects = Cases[myUnitOperations, ObjectP[{Model[Sample], Model[Container],Object[Sample], Object[Container]}], Infinity];

	(*  bult tests for Objects specified in unit ops (we only take models) *)
	onlyModelsInUnitOpsQs = MatchQ[#, ObjectP[{Model[Sample], Model[Container]}]]&/@ unitOpsSpecifiedObjects;

	(* Build tests for object existence *)
	ModelsInUnitOpsTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Unit Operation-Specified sample/container `1` is a Model:"][#1],#2,True]&,
			{unitOpsSpecifiedObjects,onlyModelsInUnitOpsQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@onlyModelsInUnitOpsQs),
		If[!gatherTests,
			Message[Error::UnitOperationsContainObject,PickList[unitOpsSpecifiedObjects,onlyModelsInUnitOpsQs,False]];
			Message[Error::InvalidInput,myUnitOperations]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLabelContainerPrimitiveTest,ModelsInUnitOpsTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*  call ExperimentManualSamplePreparation to see if there are any errors, also to simulate the sample we're generating. *)
	{experimentMSPOptions, simulatedSamplePackets, experimentMSPTests} = Module[{myMessageList, messageHandler, ops, simulation, tests, mspReturn},
		myMessageList = {};

		messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
			(* Keep track of the messages thrown during evaluation of the test. *)
			AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
		];

		(* Block $Messages to stop message printing. *)
		mspReturn=SafeAddHandler[{"MessageTextFilter", messageHandler},
			Block[{$Messages},
				ExperimentManualSamplePreparation[
					myUnitOperations,
					Output->If[gatherTests,
						{Options, Simulation, Tests},
						{Options, Simulation}
					],
					Simulation->Null
				]
			]
		];

		{ops, simulation, tests} = {mspReturn[[1]],mspReturn[[2]],If[gatherTests,mspReturn[[3]],{}]};

		Map[
			Function[messageAssociation,
				(* Only bother throwing the message if it's not Error::InvalidInput or Error::InvalidOption. *)
				(* NOTE: Also silence Warning::UnknownOption since we're collecting all messages that would normally not show up if they're *)
				(* usually inside of a Quiet[...]. *)
				If[!MatchQ[Lookup[messageAssociation, MessageName], Hold[Warning::UnknownOption]],
					Module[{messageTemplate, numberofMessageArguments, specialHoldHead, messageSymbol, messageTag, newMessageTemplate},
						(* Get the text of our message template. *)
						messageTemplate=ReleaseHold[Lookup[messageAssociation, MessageName]];
						(* Get the number of arguments that we have. *)
						numberofMessageArguments=Length[Lookup[messageAssociation, MessageArguments]];
						(* Create a special hold head that we will replace our Hold[messageName] with. *)
						SetAttributes[specialHoldHead, HoldAll];
						(* Extract the message symbol and tag. *)
						messageSymbol=Extract[Lookup[messageAssociation, MessageName], {1,1}];
						messageTag=Extract[Lookup[messageAssociation, MessageName], {1,2}];
						(* Create a new message template string. *)
						newMessageTemplate="The following message was thrown when validating the given UnitOperations for the stock solution: "<>messageTemplate;
						(* Block our the head of our message name. This prevents us from overwriting in the real codebase since *)
						(* message name information is stored in the LanguageDefinition under the head (see Language`ExtendedDefinition *)
						(* if you're interested). *)
						With[{insertedMessageSymbol=messageSymbol},
							Block[{insertedMessageSymbol},
								Module[{messageNameWithSpecialHoldHead, heldMessageSet},
									(* Replace the hold around the message name with our special hold head. *)
									messageNameWithSpecialHoldHead=Lookup[messageAssociation, MessageName]/.{Hold->specialHoldHead};
									(* Create a held set that will overwrite the message name. *)
									heldMessageSet=With[{insertMe1=messageNameWithSpecialHoldHead, insertMe2=newMessageTemplate},
										Hold[insertMe1=insertMe2]
									]/.{specialHoldHead[sym_]:>sym};
									(* Do the set. *)
									ReleaseHold[heldMessageSet];
									(* Throw the message that has been modified. *)
									With[{insertMe=messageTag},
										Message[
											MessageName[insertedMessageSymbol, insertMe],
											Sequence@@Lookup[messageAssociation, MessageArguments]
										]
									]
								]
							]
						]
					]
				]
			],
			myMessageList
		];
		{ops, simulation, Flatten[tests]}
	];

	(* see if we got a composition, if not simulate the samples and grab whatever's in the first container so the sample composition *)
	{sampleComposition, finalVolume} = If[MatchQ[Lookup[safeOptions, Composition], Except[Automatic]],
		{Lookup[safeOptions, Composition],Null},
		Module[{labelOfInterest, simulatedContainer,simulatedSampleComposition, sanitizedSimulatedSampleComposition, volume, updatedSimulation},
			(*simulate*)
			(*get the first label container unit operation,it should be the very first*)
			labelOfInterest = First[Cases[myUnitOperations, _LabelContainer]][Label];
			(*figure out what is the container that was simulated for it and whats in it*)
			simulatedContainer =Lookup[Lookup[First[simulatedSamplePackets], Labels],labelOfInterest];
			(* Here we need to do a work-around for CCD. In CCD user has to add UOs one by one and so when they add the first LabelSample UO, they have to calculate and verify *)
			(* However, that will break because there's transfer into that labeled container, thus there's no Contents in this simulatedContainer *)
			(* Use the helper below to make a dummy sample *)
			updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, simulatedSamplePackets];
			(*get the sample in that container and its volume*)
			{simulatedSampleComposition,volume} =  Download[simulatedContainer, {Contents[[1, 2]][Composition], Contents[[1, 2]][Volume]},Simulation -> updatedSimulation];
			(* make sure we're not dealing with links *)
			sanitizedSimulatedSampleComposition = {#[[1]], Download[#[[2]], Object]}& /@ simulatedSampleComposition;

			(* return composition and volume *)
			{sanitizedSimulatedSampleComposition,volume}
		]
	];

	(* now that we've simulated we can check if the VolumeIncrement, if specified, is compatible with the total volume *)
	volumeIncrements = ToList[Lookup[safeOptions,VolumeIncrements, {}]/. {Automatic->{}, Null->{}}];
	validVolumeIncrementsQ = Map[Function[increment, Mod[increment,finalVolume]<1Microliter], volumeIncrements];

	(* Build tests for object existence *)
	validVolumeIncrementsTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified VolumeIncrements `1` are compatible with the Unit Operations' final volume:"][#1],#2,True]&,
			{volumeIncrements, validVolumeIncrementsQ}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@validVolumeIncrementsQ),
		If[!gatherTests,
			Message[Error::UnitOperationInvalidVolumeIncrement,ToString[PickList[volumeIncrements ,validVolumeIncrementsQ,False]], finalVolume];
			Message[Error::InvalidOption,VolumeIncrements]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLabelContainerPrimitiveTest,ModelsInUnitOpsTests,validVolumeIncrementsTests,experimentMSPTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];


	(* specify Null for all prep options (unless they are already specified to save trouble on the resolver *)
	nullifiedOptions = Module[{prepOps,boolPrepOps},

		(* prep options that are defined as conflicting for Error::ConflictingUnitOperationsOptions *)
		prepOps = {
			Incubate, IncubationTemperature, IncubationTime, Mix, MixUntilDissolved, MixTime, MaxMixTime, MixType,
			Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes, AdjustpH, NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize, Autoclave, AutoclaveProgram, OrderOfOperations, FillToVolumeMethod,
			PrepareInResuspensionContainer
		};

		boolPrepOps = {Incubate, Mix, AdjustpH, Filter, Autoclave};

		(* mass resolve options *)
		Map[Function[option,
			If[
				MatchQ[Lookup[safeOptions,option], Except[Automatic]],
				option->Lookup[safeOptions,option],
				option->If[MemberQ[boolPrepOps, option], False, Null]
			]],
			prepOps
		]
	];

	(* replace Composition optionand  *)
	updatedOptions = ReplaceRule[safeOptions,
		Join[nullifiedOptions,{
			Composition->sampleComposition,
			Simulation->simulatedSamplePackets
		}]];

	(* call the unit ops overload - specify finalVolume so it resolves VolumeIncrements accordingly *)
	uploadStockSolutionModelReturn=uploadStockSolutionModel[{{Null,Null}},Null,finalVolume,myUnitOperations, updatedOptions];

	uploadStockSolutionModelReturnRule=If[MatchQ[outputSpecification,_List],
		MapThread[(#1->#2)&,{outputSpecification,uploadStockSolutionModelReturn}],
		outputSpecification->uploadStockSolutionModelReturn
	];

	(* Make sure we return everything including tests properly *)

	Return[outputSpecification/.{
		Result -> (Result/.uploadStockSolutionModelReturnRule),
		Tests -> Join[safeOptionTests, validLabelContainerPrimitiveTest,ModelsInUnitOpsTests,validVolumeIncrementsTests,experimentMSPTests,(Tests/.uploadStockSolutionModelReturnRule)],
		Options -> (Options/.uploadStockSolutionModelReturnRule),
		Preview -> (Preview/.uploadStockSolutionModelReturnRule)
	}]
];

(* --- FORMULA CORE: Formula and Volume Overload (handles both combine these reagents and fill to volume versions) --- *)
(*
	- does Formula validity checks, and calls resolver/new packet creator
*)
uploadStockSolutionModel[
	myFormulaSpec:{{VolumeP|MassP|GreaterP[0,1.]|Null,ObjectP[{Model[Sample],Object[Sample]}]|Null}..},
	mySolvent:(ObjectP[{Model[Sample]}]|Null),
	myFinalVolume:(VolumeP|Null),
	myUnitOperations:({SamplePreparationP..}|Null),
	myOptions:OptionsPattern[UploadStockSolution]
]:=Module[
	{listedOptions,outputSpecification,listedOutput,gatherTests,safeOptions,cache, simulation, safeOptionTests,userSpecifiedObjects,objectsExistQs,objectsExistTests,
		fastTrack,unitOperationsQ,components,componentAmounts,unitOpsSpecifiedObjects,
		componentsAndSolvent,templateOption,author,componentAndSolventDownloadTuples,storageConditionsFromUnitOps,templateModelDownloadTuple,notebookDownload,
		componentDownloadTuples,solventDownloadTupleOrNull,componentPackets,componentSCPackets,solventPacketOrNull,solventSCPacketOrNull,
		allComponentAndSolventPackets,allComponentAndSolventSCPackets,templateModelPacket,authorNotebooks,
		templateOptionDeprecated,templateOptionWarnings,resolvedOptions,optionResolutionTests,defaultStorageConditionObject,
		defaultSCObjectTests,optionsRule,previewRule,testsRule,resultRule, allTests,
		allTestTestResults, optionResolutionResult, defaultSCBool, formulaBeforeReorder, liquidAcidFormulaEntries,
		usedAsSolventComponentBool, allComponentVolumes, allAcidPositions, acidAdditionVolumePercents, liquidAfterAcidQs, componentOrderWarnings,
		reorderedFormula, componentVolumes, predictedFillToVolumeAmount, solventFormulaComponent, reorderedFormulaTests,
		allEHSFields, allComponentFields, componentsAndSolventFields, finalFormula, solventIsFormulaComponentQ, potentialContainers, potentialContainerDownload,
		volumetricFlasks, volumetricFlaskPackets},

	(* get the listed form of the options provided, for option helpers to chew on *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* default all unspecified or incorrectly-specified options *)
	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadStockSolution, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadStockSolution, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> safeOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* get cache and simulation *)
	cache = Lookup[safeOptions, Cache, {}];
	simulation = Lookup[safeOptions, Simulation, Null];

	(* get the FastTrack option value assigned so we can skip the next checks if on the fast zone *)
	fastTrack = Lookup[safeOptions, FastTrack];

	(* All unit operations related objects *)
	unitOpsSpecifiedObjects = Cases[myUnitOperations, ObjectP[{Model[Sample], Model[Container],Object[Sample], Object[Container]}], Infinity];

	(* Check if the provided objects exist before we try to resolve anything *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[myFormulaSpec],ToList[mySolvent],Values[listedOptions], unitOpsSpecifiedObjects],
		ObjectP[]
	];

	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests&&!fastTrack,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects,objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs)&&!fastTrack,
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* are we working based on a formula/StockSolutionTemplate or based on UnitOperations?  *)
	unitOperationsQ = MatchQ[myUnitOperations, {SamplePreparationP..}];

	(* assign the indices of the formula specification to separate local variables (or from composition if we're working based on unit operations *)
	componentAmounts = If[!unitOperationsQ,
		myFormulaSpec[[All, 1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]},
		Lookup[safeOptions, Composition][[All, 1]]/.{unit : UnitsP[] :>Null}
	];

	components = If[!unitOperationsQ,
		myFormulaSpec[[All, 2]],
		Lookup[safeOptions, Composition][[All, 2]]
	];

	(* add the solvent onto the components list for Downloading (okay if solvent is Null, Download handles that) *)
	componentsAndSolvent = Append[components, mySolvent];

	(* determine if we have a template to deal with; we want to download from this template to get defaultingh information *)
	templateOption = Lookup[safeOptions, StockSolutionTemplate];

	(* pseudo-resolve the hidden Author option; either it's Null (meaning we're being called by a User, so they are the author); or it's passed via Engine, and is a root protocol Author *)
	author = If[MatchQ[Lookup[safeOptions, Author], ObjectP[Object[User]]],
		Lookup[safeOptions, Author],
		$PersonID
	];

	(* Get all of the EHS fields that need to be updated. *)
	allEHSFields=ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]]/.{StorageCondition->DefaultStorageCondition};
	allComponentFields=Packet@@DeleteDuplicates[Flatten[{Name, Deprecated, State, DefaultStorageCondition, StorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet, FixedAmounts, UltrasonicIncompatible, CentrifugeIncompatible, Acid, Base, UsedAsSolvent, Composition, Density, Solvent, allEHSFields}]];
	componentsAndSolventFields = {Evaluate[Sequence@@If[!unitOperationsQ,
		{
			allComponentFields,
			Packet[DefaultStorageCondition[{StorageCondition}]]
		},
		{
			allComponentFields,
			Nothing
		}
	]]};
	potentialContainers=Intersection[Search[Model[Container, Vessel], Deprecated != True && DeveloperObject != True], PreferredContainer[All]];

	(* find all the volumetric flasks if we have at least one volumetric fill to volume*)
	volumetricFlasks = Search[Model[Container, Vessel, VolumetricFlask], Deprecated != True && MaxVolume != Null && DeveloperObject != True];

	(* download the required information from the formula components/solvent; may have a Null if the solvent is Null;
	 	Quiet is specifically for the Tablet field, which is ONLY in ObjectP[{Model[Sample],Object[Sample]}] *)
	{volumetricFlaskPackets, componentAndSolventDownloadTuples, {templateModelDownloadTuple}, notebookDownload, potentialContainerDownload} = Quiet[Download[
		{
			volumetricFlasks,
			componentsAndSolvent,
			{templateOption},
			{author},
			potentialContainers
		},
		{
			{Packet[Object, MaxVolume, ContainerMaterials, Opaque]},
			componentsAndSolventFields,
			{
				Packet[
					Name, Deprecated,

					MixUntilDissolved, MixTime, MaxMixTime, MixType, MixRate, Mixer, NumberOfMixes, MaxNumberOfMixes,

					NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,

					FilterMaterial, FilterSize,

					IncubationTime, IncubationTemperature,

					PreferredContainers, VolumeIncrements,FulfillmentScale, Preparable, Resuspension,

					LightSensitive, Expires, ShelfLife, UnsealedShelfLife, DefaultStorageCondition,
					TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming, IncompatibleMaterials,
					UltrasonicIncompatible, CentrifugeIncompatible, FillToVolumeMethod,

					Autoclave, AutoclaveProgram,
					PrepareInResuspensionContainer,
					UnitOperations
				]
			},
			{
				FinancingTeams[Notebooks][Object],
				SharingTeams[Notebooks][Object]
			},
			{
				Packet[MaxOverheadMixRate]
			}
		},
		Cache->cache,
		Simulation->simulation
	], {Download::FieldDoesntExist,Download::MissingField,Download::MissingCacheField}];

	(* if we're using unit operations, we will infer the storage conditions based on the simulated resulting samples, so get these. we assume the first labeled container is the container out *)
	storageConditionsFromUnitOps = If[unitOperationsQ,
		Module[
			{
				labelOfInterest,simulatedContainer,simulatedSampleSC,defaultAmbient, updatedSimulation
			},
			(*get the first label container unit operation,it should be the very first*)
			labelOfInterest = First[Cases[myUnitOperations, _LabelContainer]][Label];
			(*figure out what is the container that was simulated for it and whats in it*)
			simulatedContainer =Lookup[Lookup[First[Lookup[listedOptions, Simulation]], Labels],labelOfInterest];
			updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, Lookup[listedOptions, Simulation]];
			(*get the sample in that container and its volume*)
			simulatedSampleSC =  Download[simulatedContainer, Packet[Contents[[1, 2]][Model][DefaultStorageCondition][StorageCondition]],Simulation -> updatedSimulation];
			(* if there's no default storage condition, replace it with ambient *)
			defaultAmbient = Download[Model[StorageCondition, "Ambient Storage"], Packet[StorageCondition]];
			(* replace any nulls with the default *)
			simulatedSampleSC /. Null -> defaultAmbient
		],
		Null
	];

		(* get sensible local variables for our component/solvent inputs - make sure to account for the missing storage conditions when working with unit ops*)
	componentDownloadTuples = If[!unitOperationsQ,
		Most[componentAndSolventDownloadTuples],
		MapThread[Append[#1,#2]&,{Most[componentAndSolventDownloadTuples],ConstantArray[storageConditionsFromUnitOps,Length[Most[componentAndSolventDownloadTuples]]]}]
	];

	solventDownloadTupleOrNull = Last[componentAndSolventDownloadTuples];
	{componentPackets, componentSCPackets} = Transpose[componentDownloadTuples];
	{solventPacketOrNull, solventSCPacketOrNull} = If[MatchQ[mySolvent, ObjectP[]],
		solventDownloadTupleOrNull,
		{Null, Null}
	];

	(* for convenience, assign a variable that is ALL component/solvent packets (depending on presence of solvent) *)
	allComponentAndSolventPackets = If[MatchQ[solventPacketOrNull, PacketP[]],
		Append[componentPackets, solventPacketOrNull],
		componentPackets
	];
	allComponentAndSolventSCPackets = If[MatchQ[solventSCPacketOrNull, PacketP[]],
		Append[componentSCPackets, solventSCPacketOrNull],
		Flatten@componentSCPackets
	];

	(* Download isn't super nice with the Null template, so get a singelton model if the option is non null *)
	templateModelPacket = If[MatchQ[templateOption, ObjectP[]],
		templateModelDownloadTuple[[1]],
		Null
	];

	(* flatten out the notebooks; we will use these when generating the Result to look for AlternativePreparations *)
	authorNotebooks = DeleteDuplicates[Cases[Flatten[notebookDownload], ObjectReferenceP[Object[LaboratoryNotebook]]]];

	(* make a WARNING about the template option; it it's deprecated, we're not gonna use it at all *)
	{templateOptionDeprecated, templateOptionWarnings} = If[!fastTrack && MatchQ[templateModelPacket, PacketP[]],
		Module[{deprecatedBool, warning},

			(* determine indeed if it is *)
			deprecatedBool = TrueQ[Lookup[templateModelPacket, Deprecated]];

			(* make a warning for it *)
			warning = If[gatherTests,
				Warning["StockSolutionTemplate option " <> ToString[templateOption] <> " is active (not deprecated). A deprecated template will not be used for option defaults.",
					deprecatedBool,
					False
				],
				Nothing
			];

			(* throw a message if not test *)
			If[!gatherTests && deprecatedBool,
				Message[Warning::DeprecatedTemplate, templateOption]
			];

			(* return bool, test *)
			{deprecatedBool, {warning}}
		],

		(* Don't do error checking if on FastTrack *)
		{False, {}}
	];

	(* put the formula together before reordering it *)
	formulaBeforeReorder = Transpose[{componentAmounts, componentPackets}];

	(* select the liquid acids of the components *)
	liquidAcidFormulaEntries = If[!unitOperationsQ,Select[formulaBeforeReorder, MatchQ[Lookup[#[[2]], State], Liquid] && TrueQ[Lookup[#[[2]], Acid]]&],Null];

	(* get the component volumes *)
	componentVolumes = If[!unitOperationsQ,Total[Cases[componentAmounts, VolumeP]],Null];

	(* get the predicted amount of fill-to-volume amount with the solvent *)
	predictedFillToVolumeAmount = If[NullQ[solventPacketOrNull],
		Null,
		myFinalVolume - componentVolumes
	];


	(* make a formula component of the solvent itself that should be added _before_ the acid is added to ensure we aren't adding water to acid (and instead doing acid -> water)*)
	(* by default making it only 1/3 of the predicted FillToVolume amount since we don't want to overshoot the FillToVolume amount *)
	solventFormulaComponent = If[NullQ[solventPacketOrNull],
		Null,
		{{predictedFillToVolumeAmount / 3, solventPacketOrNull}}
	];

	(* determine if the solvent is already one of the formula components *)
	solventIsFormulaComponentQ = If[NullQ[solventPacketOrNull],
		False,
		MemberQ[formulaBeforeReorder[[All, 2]], ObjectP[Lookup[solventPacketOrNull, Object]]]
	];
	(* Grab all packets of the components, including the supplied solvent, that can possibly be considered as solvent, for calculating potential reordering for acid dilution *)
	usedAsSolventComponentBool = Lookup[allComponentAndSolventPackets, UsedAsSolvent, Null];

	(* Construct a list of the amount of all components in VolumeP or Null, this should be the same length as allComponentsPackets *)
	(* Solvent packet and predicted FTV amount does not matter here as it will not be added before the acid without reordering, if it is not also part of the component *)
	allComponentVolumes = MapThread[
		Function[{packet, amount},
			Module[{density, waterDensity, volume},
				(* Get the density of the component *)
				density = Lookup[packet, Density, Null];
				(* Define water density as a backup *)
				waterDensity = 0.997 Gram / Milliliter;
				(* If a Volume is provided, keep it, if a mass is provided use density to convert (default to water density) *)
				volume = Which[
					MatchQ[amount, VolumeP],
					amount,
					MatchQ[amount, MassP] && MatchQ[density, DensityP],
					amount / density,
					MatchQ[amount, MassP],
					amount / waterDensity,
					True,
					0 Liter
				];

				If[MatchQ[Lookup[packet, State, Null], Liquid],
					volume,
					Null
				]
			]
		],
		{componentPackets, componentAmounts}
	];

	(* Calculate the volume percent of acid/combinedSolventComponents, at the time of the each acid addition *)
	allAcidPositions = If[!NullQ[liquidAcidFormulaEntries],
		Flatten[(Position[allComponentAndSolventPackets, #]& /@ liquidAcidFormulaEntries[[All, 2]])],
		(* If we don't have an acid, leave it blank *)
		{}
	];
	{acidAdditionVolumePercents, liquidAfterAcidQs} = If[Length[allAcidPositions] > 0,
		Transpose@Map[
			Function[acidIndex,
				Module[{acidVolumes, volumesAtAcidAddition, solventVolumesAtAcidAddition,
					totalAcidVolumesAtAcidAddition, totalSolventVolumesAtAcidAddition,
					acidVolumePercent,liquidAfterAcidQ
				},
					acidVolumes = Extract[allComponentVolumes, #] &/@ Flatten[TakeList[allAcidPositions, ToList@acidIndex]];
					(* Get a truncated list of component volumes at the time of this acid addition*)
					volumesAtAcidAddition = Flatten[TakeList[allComponentVolumes, ToList@allAcidPositions[[acidIndex]]]];
					(* Get a list of volumes of only those used as solvent *)
					solventVolumesAtAcidAddition = PickList[
						PadRight[volumesAtAcidAddition, Length[usedAsSolventComponentBool], Null],
						usedAsSolventComponentBool, True
					];
					(* Sum up the solvent volume at this addition *)
					totalSolventVolumesAtAcidAddition = Total[Cases[solventVolumesAtAcidAddition, VolumeP]];
					(* Sum up the acid volume at this addition *)
					totalAcidVolumesAtAcidAddition = Total[Cases[acidVolumes, VolumeP]];
					(* Calculate the ratio *)
					acidVolumePercent = totalAcidVolumesAtAcidAddition / (totalAcidVolumesAtAcidAddition + totalSolventVolumesAtAcidAddition) * 100. Percent;
					(* Bool indicating whether there is more liquid component to add after this acid*)
					liquidAfterAcidQ = MemberQ[
						Flatten[Position[allComponentAndSolventPackets, KeyValuePattern[State -> Liquid]]],
						GreaterP[allAcidPositions[[acidIndex]]]
					];
					(* Return the calculated pair*)
					{acidVolumePercent, liquidAfterAcidQ}
				]
			],
			Range[Length@allAcidPositions]
		],
		(* Not applicable since we don't have acid *)
		{{},{}}
	];
	componentOrderWarnings = MatchQ[#, {GreaterP[0.2], True}]& /@ Transpose[{acidAdditionVolumePercents, liquidAfterAcidQs}];

	(* reorder the formula with the acids and bases at the end *)
	(* for non-fill-to-volume, join all the formula entries that are NOT acids with the acid entries *)
	(* for fill-to-volume, it's more complicated because we need to add _some_ of the solvent in first before adding in any acid, and then can add the rest later (but only if there _is_ any acid) *)
	reorderedFormula = Which[
		unitOperationsQ,
			formulaBeforeReorder,
		NullQ[solventPacketOrNull],
			Join[
				Select[formulaBeforeReorder, Not[MemberQ[liquidAcidFormulaEntries, #]]&],
				liquidAcidFormulaEntries
			],
		(* Conditions that we are okay not to re-order: *)
		(* 1. We don't have liquid acid entry *)
		(* 2. We have liquid acid entry but our all of the acidAdditionVolumePercents are no greater than 20% *)
		(* 3. We have liquid acid entry, there is acidAdditionVolumePercent greater than 20%, but we are not adding more liquid to it afterwards *)
		Or[
			MatchQ[liquidAcidFormulaEntries, {}],
			Length[liquidAcidFormulaEntries] > 0 && !MemberQ[componentOrderWarnings, True]
		],
			formulaBeforeReorder,
		True,
			Join[
				Select[formulaBeforeReorder, Not[MemberQ[liquidAcidFormulaEntries, #]]&],
				solventFormulaComponent,
				liquidAcidFormulaEntries
			]
	];

	(* if the reordered formula is the same as the original formula, then we're good; if not, throw a warning saying we're changing the formula for safety purposes *)
	(* do NOT get rid of this on fast track. *)
	reorderedFormulaTests = Module[{differentFormula, warning},

		(* determine if we have a different formula than the input and we're not using unit operations Q*)
		differentFormula = !unitOperationsQ&&(reorderedFormula =!= formulaBeforeReorder);

		(* make a warning saying that you're changing the order *)
		warning = If[gatherTests,
			Warning["If applicable, the provided formula is ordered such that acid is added to water and not vice-versa:",
				differentFormula,
				False
			],
			Nothing
		];

		(* throw a message if not gathering tests *)
		If[!gatherTests && differentFormula && !MatchQ[$ECLApplication,Engine],
			Message[
				Warning::ComponentOrder,
				ObjectToString[Lookup[PickList[liquidAcidFormulaEntries[[All,2]], componentOrderWarnings], Object]],
				PickList[acidAdditionVolumePercents, componentOrderWarnings],
				(reorderedFormula/.{packet:PacketP[]:>Lookup[packet,Object]})];
		];

		(* return the test as a list*)
		{warning}
	];

	(* If we were told to override any automatic reordering, then override it. *)
	finalFormula=If[MatchQ[Lookup[safeOptions,SafetyOverride],True],
		formulaBeforeReorder,
		reorderedFormula
	];

	(* resolve all of the options using a helper (it will handle template also) *)
	(* need to do this Check to know whether to return something or not *)
	optionResolutionResult = Check[
		{resolvedOptions, optionResolutionTests} = resolveUploadStockSolutionOptions[
			finalFormula,
			solventPacketOrNull,
			myFinalVolume,
			myUnitOperations,
			(* don't send template if deprecated *)
			If[templateOptionDeprecated,
				Null,
				templateModelPacket
			],
			{},
			safeOptions,
			Flatten[potentialContainerDownload],
			Flatten[volumetricFlaskPackets]
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* have to figure out the exact storage condition object - including safety information - to use; do a quick search; if we hit the Acid/base conflict, we won't get anything;
	 	don't bother, that is already being reported *)
	{defaultStorageConditionObject, defaultSCBool, defaultSCObjectTests} = Module[{scObjectToUseOrFailed, test, rawStorageCondition},

		(* Get the raw storage condition *)
		rawStorageCondition = Lookup[resolvedOptions, DefaultStorageCondition];

		(* Is the raw storage condition a Model[StorageCondition] or a symbol? *)
		scObjectToUseOrFailed = If[MatchQ[rawStorageCondition, _Symbol],
			(* We are dealing with a symbol. Lookup a suitable storage condition. *)
			First[Search[Model[StorageCondition],
				And[
					StorageCondition == Lookup[resolvedOptions, DefaultStorageCondition],
					Flammable == If[TrueQ[Lookup[resolvedOptions, Flammable]], True],
					Acid == If[TrueQ[Lookup[resolvedOptions, Acid]], True],
					Base == If[TrueQ[Lookup[resolvedOptions, Base]], True],
					Pyrophoric == Null,
					DeveloperObject != True
				]
			], $Failed],

			(* We are given a Model[StorageCondition]. Make sure that it matches the safety information. *)
			If[!ValidStorageConditionQ[
				TrueQ[Lookup[resolvedOptions, Flammable]],
				TrueQ[Lookup[resolvedOptions, Acid]],
				TrueQ[Lookup[resolvedOptions, Base]],
				False,
				rawStorageCondition
			],
			(* The storage condition is not valid. $Failed *)
				$Failed,
			(* The storage condition is valid, simply return it. *)
				rawStorageCondition
			]
		];

		(* make a test to see if we got one *)
		test = If[gatherTests,
			Test["The provided combination of Storage options corresponds to a supported ECL storage condition.",
				scObjectToUseOrFailed,
				ObjectP[Model[StorageCondition]]
			],
			Nothing
		];

		(* yell if we didn't get one *)
		If[!gatherTests && MatchQ[scObjectToUseOrFailed, $Failed],
			Message[Error::StorageCombinationUnsupported, Lookup[resolvedOptions, DefaultStorageCondition]];
			Message[Error::InvalidOption, {DefaultStorageCondition, Flammable, Acid, Base}]
		];

		(* return the object-or-failed, and the test *)
		{scObjectToUseOrFailed, MatchQ[scObjectToUseOrFailed, ObjectP[Model[StorageCondition]]], {test}}
	];

	(* gather all the tests we've generated together *)
	allTests = Join[safeOptionTests, templateOptionWarnings, optionResolutionTests, defaultSCObjectTests, reorderedFormulaTests];

	(* run the tests that we have generated to make sure we can go on *)
	allTestTestResults = If[gatherTests,
		RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		TrueQ[defaultSCBool] && MatchQ[optionResolutionResult, Except[$Failed]]
	];

	(* prepare the options return rule; no index-matched optinos currently, so don't bother collapsing *)
	optionsRule = Options -> If[MemberQ[listedOutput, Options],
		RemoveHiddenOptions[UploadStockSolution, resolvedOptions],
		Null
	];

	(* function doesn't have a preview *)
	previewRule = Preview -> Null;

	(* accrue all of the Tests we generated *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* prepare the Result rule if asked; do not bother if we hit a failure on any of our above checks *)
	resultRule = Result -> If[MemberQ[listedOutput, Result],
		If[Not[TrueQ[allTestTestResults]],
			$Failed,
			(* make sure to send unit operations to the right overload of newStockSolutions *)
			If[!unitOperationsQ,
				newStockSolution[
					finalFormula,
					mySolvent,
					myFinalVolume,
					Download[defaultStorageConditionObject, Object],
					!MatchQ[Lookup[safeOptions, Name], _String],
					(* pass our hidden option for new model creation warning *)
					(* for the formula input, this hidden option is Null *)
					Null,
					author,
					authorNotebooks,
					resolvedOptions
				],
				newStockSolution[
					myUnitOperations,
					Download[defaultStorageConditionObject, Object],
					!MatchQ[Lookup[safeOptions, Name], _String],
					Null,
					author,
					authorNotebooks,
					resolvedOptions,
					simulation
				]
			]
		],
		Null
	];

	(* return the requested outputs per the non-listed Output option *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*resolveUploadStockSolutionOptions*)


(*
	RESOLVER
		- resolves all UploadStockSolution options
		- accepts:
			original inputs
			plus template (which is assumed to be the option at this point; we may have downloaded input template formula earlier)
		- returns resolved options
		and resolving validity bool
		and maybe tests with Output option
*)
resolveUploadStockSolutionOptions[
	myFormulaSpecWithPackets:{{VolumeP|MassP|NumericP|Null,PacketP[{Model[Sample],Object[Sample],Model[Molecule]}]|Null}..},
	mySolventPacket:(PacketP[{Model[Sample]}]|Null),
	myFinalVolume:(VolumeP|Null),
	myUnitOperations:({SamplePreparationP...}|Null),
	myTemplateModelPacket:(PacketP[{Model[Sample,StockSolution],Model[Sample,Media],Model[Sample,Matrix]}]|Null),
	myPreparatoryFormulaPackets:{PacketP[]...},
	mySafeOptions:{_Rule..},
	myContainerPackets:{PacketP[Model[Container]]...},
	myVolumetricFlaskPackets:{PacketP[Model[Container]]...}
]:=Module[
	{
		gatherTests,fastTrack,unitOpsQ,componentPackets,componentAmounts,effectiveStockSolutionVolume,allComponentAndSolventPackets,safeOptionsTemplateReplaced,
		resolvedType, mixSubOptionNames, incubateSubOptionsSetIncorrectlyTests, resolvedAdjustpHBool,mixSubOptionsSetIncorrectlyTests,
		resolvedMixBool,resolvedMixOptions,mixOptionResolutionTests,nominalpH,volumeTooLowForpHing,pHVolumeTooLowTests,resolvedMinpH,
		resolvedMaxpH,resolvedPreferredpHingAcid,resolvedPreferredpHingBase,resolvedMaxNumberOfpHingCycles,resolvedMaxpHingAdditionVolume,
		resolvedMaxAcidAmountPerCycle,resolvedMaxBaseAmountPerCycle,pHOptionsInvalid,pHOptionValidityTests,filterSubOptionNames,
		filterSubOptionsSetIncorrectly,filterSubOptionsSetIncorrectlyTests,volumeTooLowForFiltration,filtrationVolumeTooLowTests,
		resolvedFilterBool,resolvedFilterOptions,filterResolutionInvalid,filterOptionResolutionTests,resolvedLightSensitive,resolvedIncompatibleMaterials,
		resolvedPreferredContainers, mixAndIncubateSubOptionNames,resolvedOptions,allOptionResolutionTests, fakePreferredContainerVolume,
		resolvedIncubateBool, incubateSubOptionNames, resolvedContainerOut, componentDensity,fakeTotalVolume, preparableQ,
		resolvedUltrasonicIncompatible, formulaOnlyOptionNames, formulaOnlyOptions, formulaOnlyOptionsExpSSNames, resolvedFormulaOnlyOptions,
		resolvedFormulaOnlyOptionsExpSSNames, formulaOnlyTests, preResolvedMixTime, preResolvedIncubationTime, preferredContainerIncompatibleMaterials, safeOptionsTemplateWithMixAndIncubateTimes, mixIncubateTimeMismatchTests, invalidPreparationTests,invalidResuspensionAmountsTests, roundedOptions, precisionTests,
		collapsedResolvedFormulaOnlyOptionsExpSSNames, preResolvedVolumeIncrements,preResolvedFulfillmentScale, resolvedFulfillmentScale,
		fixedAmountsBool, resolvedResuspension, invalidResuspensionBool, invalidResuspensionTest, resolvedPrepareInResuspensionContainer,
		prepareInResuspensionContainerQ,fixedAmountInfo,numberOfFixedAmountComponents,specifiedFixedAmounts,allowedFixedAmounts,
		fixedAmountsComponents,invalidPreparationBool,invalidResuspensionAmountBool,resolvedVolumeIncrements,fulfillmentScaleVolIncrementsMismatchTests,
		resolvedComposition,preResolvedComposition,preResolvedSafetyPacket, resolvedFillToVolumeMethod,
		validOrderOfOperations,orderOfOperationsTest, validOrderOfOperationsForpH,orderOfOperationsForpHTest,invalidFillToVolumeMethodUltrasonic,
		invalidFillToVolumeMethodVolumetric, invalidFillToVolumeMethodNoSolvent,resolvedOrderOfOperations, effectiveStockSolutionVolumeConsideringAutoclaving,
		resolvedAutoclaveProgram, resolvedAutoclaveBoolean,compatibleVolumetricFlaskPackets,volumetricFlaskVolumes,maxVolumetricFlaskVolume,
		specifiedNominalpH, specifiedMinpH, specifiedMaxpH,invalidPrimitivesOptions,invalidPrimitivesOptionsTest,specifiedPreferredContainers,
		postAutoclaveMixIncubateTimeMismatchTests,postAutoclaveMixSubOptionsSetIncorrectlyTests,postAutoclaveIncubateSubOptionsSetIncorrectlyTests,
		postAutoclaveResolvedMixOptions,postAutoclaveMixOptionResolutionTests,postAutoclaveResolvedMixBool,postAutoclaveResolvedIncubateBool,
		postAutoclavePreResolvedMixTime,postAutoclavePreResolvedIncubationTime,postAutoclaveMixAndIncubateSubOptionNames,postAutoclaveMixSubOptionNames,
		postAutoclaveIncubateSubOptionNames, preResolvedMixRate, postAutoclavePreResolvedMixRate, preResolvedMixRateReplaceQ, postAutoclavePreResolvedMixRateReplaceQ, specifiedMixRate, specifiedPostAutoclaveMixRate, preResolvedMixOptions, postAutoclavePreResolvedMixOptions,
		resolvedPrepContainer
	},

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[ToList[Lookup[mySafeOptions, Output]], Tests];

	(* determine if we're on the fast track *)
	fastTrack = Lookup[mySafeOptions, FastTrack];

	(* are we working based on a formula/StockSolutionTemplate or based on UnitOperations?  *)
	unitOpsQ = MatchQ[myUnitOperations, {SamplePreparationP..}];

	(* re-separate the formula into component packets and amounts *)
	componentAmounts = myFormulaSpecWithPackets[[All, 1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]};
	componentPackets = myFormulaSpecWithPackets[[All, 2]];

	(* Fetch the PreferredContainers option *)
	specifiedPreferredContainers=Lookup[mySafeOptions,PreferredContainers];

	(* set the effective volume of this solution; the fill-to volume if we have it, or the sum of volume components (be conscious that we might have a humorous formula without any volumes) *)
	effectiveStockSolutionVolume = Which[
		MatchQ[myFinalVolume, VolumeP], myFinalVolume,
		MemberQ[componentAmounts, VolumeP], Total[Cases[componentAmounts, VolumeP]],
		MatchQ[specifiedPreferredContainers,ListableP[ObjectP[Model[Container,Vessel]]]],First[ToList[Download[specifiedPreferredContainers,MaxVolume]]],
		True, 1 Liter
	];

	(* also for convenience staple together the component and solvent packets if the solvent packet is a thing *)
	allComponentAndSolventPackets = If[MatchQ[mySolventPacket, PacketP[]],
		Append[componentPackets, mySolventPacket],
		componentPackets
	];

	(* round the options specified *)
	{roundedOptions, precisionTests} = If[gatherTests,
		Normal[RoundOptionPrecision[Association[mySafeOptions], {NominalpH, MinpH, MaxpH}, {10^-2, 10^-2, 10^-2}, Output -> {Result, Tests}]],
		{Normal[RoundOptionPrecision[Association[mySafeOptions], {NominalpH, MinpH, MaxpH}, {10^-2, 10^-2, 10^-2}]], {}}
	];

	(* replace the template values into the safe options; assume either overload has already checked if it is deprecated *)
	safeOptionsTemplateReplaced = If[MatchQ[myTemplateModelPacket, PacketP[]],
		Module[{applyTemplateOption},

			(* make a quick function that will let us conditionally replace an option value with a template if it's automatic;
				if no explicit value from template provided, just direct look up the value from the template *)
			applyTemplateOption[myOptionName_Symbol] := myOptionName -> If[MatchQ[Lookup[roundedOptions, myOptionName], Automatic],
				Module[{templateValue},

					(* get the template value from the template packet *)
					templateValue = Lookup[myTemplateModelPacket, myOptionName];

					(* be convenient and turn links to objects; leave Automatic if the template value is Null *)
					Which[
						MatchQ[templateValue, ObjectP[]], Download[templateValue, Object],
						NullQ[templateValue], Automatic,
						True, templateValue
					]
				],
				Lookup[roundedOptions, myOptionName]
			];
			(* PreferredContainers option gets a special resolution case *)
			applyTemplateOption[PreferredContainers] := PreferredContainers -> If[MatchQ[Lookup[roundedOptions, PreferredContainers], Automatic],
				(* Since PreferredContainers->Automatic, resolve it from the template or default to {} *)
				Module[{templateValue},

					(* get the template value from the template packet *)
					templateValue = Lookup[myTemplateModelPacket, PreferredContainers];

					(* be convenient and turn links to objects; if the template has no PreferredContainers, resolve to Automatic->{} *)
					If[MatchQ[templateValue, {ObjectP[]..}],
						Download[templateValue, Object],
						{}
					]
				],
				(* Since PreferredContainers was provided, use it *)
				Lookup[roundedOptions, PreferredContainers]
			];
			(* Basic version that just defaults to the Templates version *)
			applyTemplateOption[myOptionName_Symbol, myTemplateValue_] := myOptionName -> If[MatchQ[Lookup[roundedOptions, myOptionName], Automatic],
				myTemplateValue,
				Lookup[roundedOptions, myOptionName,Automatic]
			];

			(* replace all the template options using the above helpers *)
			ReplaceRule[roundedOptions,
				Join[
					{
						applyTemplateOption[Type, Last[Lookup[myTemplateModelPacket, Type]]],
						applyTemplateOption[Mix, MemberQ[Lookup[myTemplateModelPacket, {MixTime, MaxMixTime}], TimeP] || MatchQ[Lookup[myTemplateModelPacket, MixType], MixTypeP]],
						applyTemplateOption[Filter, MatchQ[Lookup[myTemplateModelPacket, FilterMaterial], FilterMembraneMaterialP] || MatchQ[Lookup[myTemplateModelPacket, FilterSize], FilterSizeP]],
						applyTemplateOption[PrepareInResuspensionContainer, Lookup[myTemplateModelPacket, PrepareInResuspensionContainer]],
						applyTemplateOption[TransportTemperature, Lookup[myTemplateModelPacket, TransportTemperature]]
					},
					applyTemplateOption /@ {
						MixUntilDissolved, MixTime, MaxMixTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes,
						NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
						MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,
						FilterMaterial, FilterSize,
						LightSensitive, Expires, ShelfLife, DiscardThreshold,
						IncubationTime, IncubationTemperature,
						UnsealedShelfLife, Density, ExtinctionCoefficients, Ventilated, Flammable,
						Acid, Base, Fuming, IncompatibleMaterials, UltrasonicIncompatible, CentrifugeIncompatible,
						PreferredContainers, VolumeIncrements, Preparable, FillToVolumeMethod,
						Autoclave, AutoclaveProgram,
						FulfillmentScale
					}
				]
			]
		],
		roundedOptions
	];

	(* if Preparable -> Automatic at this point, go to True *)
	preparableQ = Lookup[safeOptionsTemplateReplaced, Preparable] /. {Automatic -> True};

	(* these are the list of option names that UploadStockSolution resolves in exactly the same way as ExperimentStockSolution *)
	formulaOnlyOptionNames = {
		Name, Synonyms, LightSensitive, Expires, DiscardThreshold, ShelfLife, UnsealedShelfLife, DefaultStorageCondition,
		TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming, IncompatibleMaterials,
		FillToVolumeMethod
	};

	(* get the options that we are going to resolve in the exact same way as ExperimentStockSolution does for its formula overload *)
	formulaOnlyOptions = Normal[KeySelect[safeOptionsTemplateReplaced, MemberQ[formulaOnlyOptionNames, #]&]];

	(* change the name of Name to StockSolutionName because for ExperimentStockSolution, Name refers to the protocol, not the model *)
	formulaOnlyOptionsExpSSNames = Map[
		If[MatchQ[Keys[#], Name],
			StockSolutionName -> Values[#],
			#
		]&,
		formulaOnlyOptions
	];

	(* resolve all the options that go with the formula overload *)
	{resolvedFormulaOnlyOptionsExpSSNames, formulaOnlyTests} = If[gatherTests,
		resolveStockSolutionOptionsFormula[{myFormulaSpecWithPackets}, {mySolventPacket}, {myFinalVolume},{myUnitOperations}, ReplaceRule[formulaOnlyOptionsExpSSNames, {Output -> {Result, Tests}, FastTrack -> fastTrack, Preparable -> preparableQ}]],
		{resolveStockSolutionOptionsFormula[{myFormulaSpecWithPackets}, {mySolventPacket}, {myFinalVolume},{myUnitOperations}, ReplaceRule[formulaOnlyOptionsExpSSNames, {Output -> Result, FastTrack -> fastTrack, Preparable -> preparableQ}]], {}}
	];

	(* collapse the index matched options back down as if it were in ExperimentStockSolution *)
	collapsedResolvedFormulaOnlyOptionsExpSSNames = CollapseIndexMatchedOptions[ExperimentStockSolution, Normal[KeyDrop[resolvedFormulaOnlyOptionsExpSSNames, {Preparable, UltrasonicIncompatible}]]];

	(* action 1. change the name of the resolved options back to the proper USSM names (i.e., StockSolutionName becomes Name) *)
	(* action 2. we need to manually collapse IncompatibleMaterials options (if it is not Null) from ExperimentStockSolution resolver if it is multiple-multiple;
	 Because UploadStockSolution is always called with singleton, we just do a Flatten on the IncompatibleMaterials option value
	 *)
	resolvedFormulaOnlyOptions = Map[
		Which[
			(* action 1 *)
			MatchQ[Keys[#], StockSolutionName],
			Name -> Values[#],
			(* action 2 *)
			MatchQ[Keys[#], IncompatibleMaterials] && Not[NullQ[Values[#]]],
			Module[{value},
				value = Flatten[Values[#]];
				IncompatibleMaterials -> If[Length[value]>1, DeleteCases[value, None], value]
			],
			(* otherwise, keep it *)
			True, #
		]&,
		collapsedResolvedFormulaOnlyOptionsExpSSNames
	];

	(* pull out the light sensitivity and incompatible materials from the resolved options above *)
	resolvedLightSensitive = Lookup[resolvedFormulaOnlyOptions, LightSensitive];
	resolvedIncompatibleMaterials = DeleteCases[ToList[Lookup[resolvedFormulaOnlyOptions, IncompatibleMaterials]],None];


	(* Pull out and resolve the PreferredContainers option *)
	(* NOTE: Resolve PreferredContainers to the LabelContainer primitive, if given primitives. *)
	resolvedPreferredContainers = If[And[
			MatchQ[myUnitOperations, {SamplePreparationP..}],
			MatchQ[FirstOrDefault[myUnitOperations], _LabelContainer]
		],
		Lookup[FirstOrDefault[myUnitOperations][[1]], Container, {}],
		Replace[Lookup[safeOptionsTemplateReplaced,PreferredContainers],Automatic->{}]
	];

	(* get the density info for all the components *)
	componentDensity=Map[
		Function[{componentPacket},
			If[MatchQ[Lookup[componentPacket,State],Liquid]&&MatchQ[Lookup[componentPacket,Density],Null],
				(* if density is missing for a liquid component, use density of water *)
				Quantity[0.997`, ("Grams")/("Milliliters")],
				(* otherwise, use whatever is stored for the component *)
				Lookup[componentPacket,Density]
			]
		],componentPackets];

	(* get the fake final volume (need this to populate the VolumeIncrements field) *)
	fakeTotalVolume = Which[
		(*if user specified a fill-to volume, use it*)
		MatchQ[myFinalVolume, VolumeP],
		myFinalVolume,

		(*if the components in formula have liquid states, use the total volume of all liquid*)
		(*NOTE: since we support mass transfer for liquid components, we need to consider both cases. e.g. add original volume inputs and calculated volume inputs (mass/density)*)
		MemberQ[Lookup[componentPackets,State],Liquid],
			Total[Join[Cases[componentAmounts, VolumeP],Cases[componentAmounts/componentDensity,VolumeP]]],

		(*if all the components are solid, set to Null*)
		True,Null
	];

	(* get the pre-resolved volume increments (n.b. this could still be Automatic) *)
	preResolvedVolumeIncrements = Lookup[safeOptionsTemplateReplaced, VolumeIncrements];
	(* get the pre-resolved FulfillmentScale option (to set VolumeIncrements to Automatic if it is Fixed & VolumeIncrements is Null) *)
	preResolvedFulfillmentScale = Lookup[safeOptionsTemplateReplaced, FulfillmentScale];
	(* Resolve the FulfillmentScale *)

	resolvedFulfillmentScale=Which[
		(*If the user provided FulfillmentScale, use that*)
		MatchQ[preResolvedFulfillmentScale,Except[Automatic]],
			preResolvedFulfillmentScale,
		(* If we have primitives, set it to Fixed. *)
		unitOpsQ,
			Fixed,
		MatchQ[Lookup[safeOptionsTemplateReplaced, FulfillmentScale], Except[Null]],
			Fixed,
		(* Otherwise, set it to Dynamic. *)
		True,
			Dynamic
	];

	(* indicate if we are dealing with a fixed amount situation *)
	fixedAmountsBool = MemberQ[Lookup[componentPackets, FixedAmounts, {}], {(MassP|VolumeP)..}];

	(* resolve the Resuspension field *)
	(* if any of the components are FixedAmounts, resolve to True *)
	resolvedResuspension = Which[
		(* If the user provided Resuspension, use it *)
		MatchQ[Lookup[safeOptionsTemplateReplaced,Resuspension],Except[Automatic]],
		Lookup[safeOptionsTemplateReplaced,Resuspension],

		(* If there is fixedAmounts components, resolve to True *)
		fixedAmountsBool,
		True,

		(* Otherwise, resolve to False *)
		True, False
	];

	(* generate a boolean to check if the Resuspension is specified without fixed amount components *)
	invalidResuspensionBool= (MatchQ[Lookup[safeOptionsTemplateReplaced,Resuspension],True]&&Not[fixedAmountsBool]) || (MatchQ[Lookup[safeOptionsTemplateReplaced,Resuspension],False]&&fixedAmountsBool);

	(* throw message *)
	If[!gatherTests && MatchQ[invalidResuspensionBool,True],
		Message[Error::InvalidResuspensionOption];
		Message[Error::InvalidOption, Resuspension];
	];

	invalidResuspensionTest=If[gatherTests,
		Test["The Resuspension option needs to be True if there is a FixedAmounts component, and False if there is no FixedAmounts components in the formula:",!MatchQ[invalidResuspensionBool,True],True],
		{}
	];

	(* resolve the PrepareInResuspensionContainer field *)
	(* if any of the components are FixedAmounts, resolve to True *)
	resolvedPrepareInResuspensionContainer = Which[
		(* If the user provided Resuspension, use it *)
		MatchQ[Lookup[safeOptionsTemplateReplaced,PrepareInResuspensionContainer],Except[Automatic]],
		Lookup[safeOptionsTemplateReplaced,PrepareInResuspensionContainer],

		(* Otherwise, resolve to False *)
		True, False
	];

	(* obtain fixed amounts info for the error checks *)
	prepareInResuspensionContainerQ = Lookup[safeOptionsTemplateReplaced,PrepareInResuspensionContainer];
	fixedAmountInfo = Lookup[componentPackets,FixedAmounts,{}];
	numberOfFixedAmountComponents = Count[fixedAmountInfo,{(MassP|VolumeP)..}];
	specifiedFixedAmounts = PickList[componentAmounts,fixedAmountInfo,{(MassP|VolumeP)..}];
	allowedFixedAmounts = PickList[fixedAmountInfo,fixedAmountInfo,{(MassP|VolumeP)..}];
	fixedAmountsComponents = PickList[Lookup[componentPackets,Object],fixedAmountInfo,{(MassP|VolumeP)..}];

	(* generate a boolean to check if the PrepareInResuspensionContainer is specified without fixed amount components (unit ops are exempt) *)
	invalidPreparationBool = !unitOpsQ&&(MatchQ[prepareInResuspensionContainerQ,True]&&MatchQ[numberOfFixedAmountComponents,EqualP[0]]);

	(* if PrepareInResuspensionContainer sets to True without any fix amount components in the formula, throw an error *)
	If[!gatherTests && MatchQ[invalidPreparationBool,True],
		Message[Error::InvalidPreparationInResuspensionContainer,Lookup[componentPackets,Object]];
		Message[Error::InvalidOption, PrepareInResuspensionContainer];
	];

	invalidPreparationTests=If[gatherTests,
		Test["For the formula used, there is a FixedAmount component when PrepareInResuspensionContainer is True:",!MatchQ[invalidPreparationBool,True],True],
		{}
	];

	(* track the invalid component *)
	(* skip this if we have more than one fixed amount components, since it has been checked *)
	(* do this check only if we are doing PrepareInResuspensionContainer. Otherwise, we may do combination to reach the specified amounts *)
	invalidResuspensionAmountBool = Length[specifiedFixedAmounts]==1&&MatchQ[prepareInResuspensionContainerQ,True]&&Not[MemberQ[First[allowedFixedAmounts],EqualP[First[specifiedFixedAmounts]]]];

	(* if we are doing PrepareInResuspensionContainer, the specified fixed amount component has to agree with what is allowed in the FixedAmounts field in the model. Otherwise, throw an error *)
	(* if PrepareInResuspensionContainer sets to True without any fix amount components in the formula, throw an error *)
	If[!gatherTests && MatchQ[invalidResuspensionAmountBool,True],
		Message[Error::InvalidResuspensionAmounts,specifiedFixedAmounts,allowedFixedAmounts,fixedAmountsComponents];
		Message[Error::InvalidOption, PrepareInResuspensionContainer];
	];

	invalidResuspensionAmountsTests=If[gatherTests,
		Test["For the formula used , the specified amount for the FixedAmounts component is allowed:",!MatchQ[invalidResuspensionAmountBool,True],True],
		{}
	];

	(* Pull out and resolve the VolumeIncrements field *)
	(* if any of the components are tablets or something of the sort, we want to automatically set the increments in which this solution can be prepared;
		don't ever scale UP, but if there are multiple tablets, presumably we can make less with fewer tablet components;
		therefore here we want the LOWEST of any tablet counts (these are numerics, already validated as legit) *)
	(* separately, if we are using a FixedAmounts component in this stock solution, then the VolumeIncrements field is only going to be populated with the volume we're making itself *)
	resolvedVolumeIncrements = Which[
		(*If the user provided VolumeIncrements, use those*)
		MatchQ[preResolvedVolumeIncrements, VolumeP | {VolumeP...}],
			Lookup[safeOptionsTemplateReplaced, VolumeIncrements],

		(*If all solid components, no volume increments are needed*)
		NullQ[fakeTotalVolume],
			{},

		(* If we have primitives, set it to fakeTotalVolume (since there is no scaling). *)
		MatchQ[myUnitOperations, {SamplePreparationP..}] && VolumeQ[fakeTotalVolume],
			fakeTotalVolume,

		(*If the user left VolumeIncrements Null, but informed FulfillmentScale as Fixed, treat it the same as Automatic *)
		NullQ[preResolvedVolumeIncrements]&&MatchQ[resolvedFulfillmentScale,Fixed]&&MemberQ[componentAmounts,NumericP]&&VolumeQ[fakeTotalVolume],
			Module[{lowestTabletCount,volumeScalingFactors},

				(* get the min of the tablet counts *)
				lowestTabletCount=Min[Cases[componentAmounts,NumericP]];

				(* get the scaling factors for each integer from 1 to lowestTabletCount to scale the formula volume (this scaling is fine for either a fill-to or theoretical);
					if lowest tablet count IS one, we just have the one increment *)
				volumeScalingFactors=Range[lowestTabletCount]/lowestTabletCount;

				(* multiple the final volume by this to get the increments we will ever prepare *)
				volumeScalingFactors*fakeTotalVolume
			],

		(*If the user left VolumeIncrements Null, but informed FulfillmentScale as Dynamic, no volume increments are needed *)
		NullQ[preResolvedVolumeIncrements]&&MatchQ[resolvedFulfillmentScale,Dynamic],
			{},

		(*If the user left VolumeIncrements as Automatic, calculate the volume increments *)
		MatchQ[preResolvedVolumeIncrements, Automatic] && MemberQ[componentAmounts,NumericP],
			Module[{lowestTabletCount,volumeScalingFactors},

				(* get the min of the tablet counts *)
				lowestTabletCount=Min[Cases[componentAmounts,NumericP]];

				(* get the scaling factors for each integer from 1 to lowestTabletCount to scale the formula volume (this scaling is fine for either a fill-to or theoretical);
					if lowest tablet count IS one, we just have the one increment *)
				volumeScalingFactors=Range[lowestTabletCount]/lowestTabletCount;

				(* multiple the final volume by this to get the increments we will ever prepare *)
				volumeScalingFactors*fakeTotalVolume
			],

		MatchQ[preResolvedVolumeIncrements, Automatic] && fixedAmountsBool && MatchQ[fakeTotalVolume, VolumeP],
			{fakeTotalVolume},

		True,
			{}
	];

	(* make tests and throw a warning if the fulfillmentScale was specified without VolumeIncrements *)
	fulfillmentScaleVolIncrementsMismatchTests = If[!fastTrack,
		Module[{fulfillmentScaleVolIncrementsMismatchQ, test},

			(* figure out if FullfillmentScale is specified as Fixed and if VolumeIncrements is not informed.  *)
			(* if True, then there is a mismatch for which we are throwing an error *)
			fulfillmentScaleVolIncrementsMismatchQ = If[MatchQ[resolvedFulfillmentScale,Fixed] &&!MatchQ[preResolvedVolumeIncrements, VolumeP | {VolumeP...}],
				True,
				False
			];

			(* make a test for this mismatch *)
			test = If[gatherTests,
				Test["If FulfillmentScale-> Fixed, VolumeIncrements are provided:",
					fulfillmentScaleVolIncrementsMismatchQ,
					False
				]
			];

			(* throw an error about this *)
			If[Not[gatherTests] && fulfillmentScaleVolIncrementsMismatchQ,
				Message[Warning::NoVolumeIncrementsProvided, preResolvedFulfillmentScale];
			];

			{test}
		],
		{}
	];

	(* --- Resolve Autoclave Options --- *)

	(* Set the Autoclave boolean to True if AutoclaveProgram is set. *)
	resolvedAutoclaveBoolean=Which[
		MatchQ[Lookup[safeOptionsTemplateReplaced, Autoclave], Except[Automatic]],
			Lookup[safeOptionsTemplateReplaced, Autoclave],

		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		MatchQ[Lookup[safeOptionsTemplateReplaced, AutoclaveProgram], AutoclaveProgramP],
			True,

		(* We generally want an autoclave if our type is Media *)
		MatchQ[Lookup[safeOptionsTemplateReplaced, Type], Media],
			True,

		True,
			False
	];

	(* Set the AutoclaveProgram to Liquid if Autoclave->True. *)
	resolvedAutoclaveProgram=If[MatchQ[Lookup[safeOptionsTemplateReplaced, AutoclaveProgram], Automatic],
		If[MatchQ[resolvedAutoclaveBoolean, True],
			Liquid,
			Null
		],
		Lookup[safeOptionsTemplateReplaced, AutoclaveProgram]
	];

	(* Take into account autoclaving when dealing with the effective volume (the container must be less than 3/4 full). *)
	effectiveStockSolutionVolumeConsideringAutoclaving=If[TrueQ[resolvedAutoclaveBoolean],
		N[4/3 * effectiveStockSolutionVolume],
		effectiveStockSolutionVolume
	];

	(* get the fake volume to send into this PreferredContainer call in case we're outside the range; we don't want PreferredContainer to return $Failed *)
	fakePreferredContainerVolume = Switch[effectiveStockSolutionVolumeConsideringAutoclaving,
		GreaterP[$MaxStockSolutionSolventVolume], $MaxStockSolutionSolventVolume,
		LessP[$MinStockSolutionComponentVolume], $MinStockSolutionComponentVolume,
		_, effectiveStockSolutionVolumeConsideringAutoclaving
	];

	(* pull out the specified incompatible materials and convert them to a format for PreferredContainer *)
	preferredContainerIncompatibleMaterials = If[MatchQ[resolvedIncompatibleMaterials, {(MaterialP|None)..}],
		resolvedIncompatibleMaterials,
		Automatic
	];

	(* get the preferred container for the given effective volume AND whether the thing is light sensitive*)
	resolvedContainerOut = FirstOrDefault[ToList[PreferredContainer[
		fakePreferredContainerVolume,
		resolvedPreferredContainers,
		LightSensitive -> resolvedLightSensitive,
		MaxTemperature -> If[MatchQ[resolvedAutoclaveBoolean, True],
			120 Celsius,
			Automatic
		],
		Type->Vessel,
		All->True,
		IncompatibleMaterials -> preferredContainerIncompatibleMaterials
	]]];

	(* figure out what the type should be for the new stock solution; first go with what was specified, then go with what the template model was, then resolve to StockSolution if still nothing *)
	resolvedType = Which[
		MatchQ[Lookup[safeOptionsTemplateReplaced, Type], StockSolutionSubtypeP], Lookup[safeOptionsTemplateReplaced, Type],
		Not[NullQ[myTemplateModelPacket]], Last[Lookup[myTemplateModelPacket, Type]],
		True, StockSolution
	];

	(* assign the names of the Mix "sub-options" (things controlled by Mix bool) *)
	mixSubOptionNames = {MixUntilDissolved, MixTime, MaxMixTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes};

	(* assign the names of the Incubate "sub-options" (things controlled by Incubate bool) *)
	(* I also didn't include IncubationTime since it can technically be set if Mix -> True IF it is the same as MixTime *)
	incubateSubOptionNames = {IncubationTemperature};

	(* get all the mix and incubate sub option names *)
	mixAndIncubateSubOptionNames = {MixUntilDissolved, MixTime, MaxMixTime, IncubationTemperature, IncubationTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes};

	(* Now do the same for PostAutoclave versions of above *)
	postAutoclaveMixSubOptionNames = {
		PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixType, PostAutoclaveMixer,
		PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes
	};
	postAutoclaveIncubateSubOptionNames = {PostAutoclaveIncubationTemperature};
	postAutoclaveMixAndIncubateSubOptionNames = {
		PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveIncubationTemperature, PostAutoclaveIncubationTime,
		PostAutoclaveMixType, PostAutoclaveMixer, PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes
	};

	(* resolve the mix boolean *)
	resolvedMixBool = Which[
		(* If mix is specified, use that *)
		!MatchQ[Lookup[safeOptionsTemplateReplaced, Mix], Automatic],
			Lookup[safeOptionsTemplateReplaced, Mix],

		(* If given primitives, set it to False. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		True,
			True
	];

	(* Resolve the PostAutoclaveMix boolean. Not just a copy paste. *)
	postAutoclaveResolvedMixBool = Which[
		(* If mix is specified, use that *)
		!MatchQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveMix], Automatic],
			Lookup[safeOptionsTemplateReplaced, PostAutoclaveMix],

		(* If given primitives, set it to False. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		(* If HeatSensitiveReagents is populated, we should be doing a post-autoclave mix *)
		MatchQ[Lookup[safeOptionsTemplateReplaced,HeatSensitiveReagents], Except[{}|Null|Automatic]],
			True,

		(* If any PostAutoclave options are specified, we should do the post-autoclave mix *)
		MemberQ[Lookup[safeOptionsTemplateReplaced, postAutoclaveMixSubOptionNames], Except[{}|Null|Automatic]],
			True,

		(* Standard position is to not do this *)
		True,
			False
	];

	(* Resolve the incubate bool to False unless any of the incubation options are specified *)
	resolvedIncubateBool = Which[
		(* If incubate is specified, use that *)
		MatchQ[Lookup[safeOptionsTemplateReplaced, {Incubate, IncubationTemperature, IncubationTime}], {BooleanP, _, _}],
			Lookup[safeOptionsTemplateReplaced, Incubate],

		(* If given primitives, set it to False. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		(* If no incubate options are specified, false *)
		MatchQ[Lookup[safeOptionsTemplateReplaced, {Incubate, IncubationTemperature, IncubationTime}], {(Automatic | Null)..}],
			False,

		(* True otherwise *)
		True,
			True
	];

	(* Resolve the PostAutoclaveIncubate bool. This is also not just a copy-paste. *)
	postAutoclaveResolvedIncubateBool = Which[
		(* If incubate is specified, use that *)
		MatchQ[Lookup[safeOptionsTemplateReplaced, {PostAutoclaveIncubate, PostAutoclaveIncubationTemperature, PostAutoclaveIncubationTime}], {BooleanP, _, _}],
			Lookup[safeOptionsTemplateReplaced, PostAutoclaveIncubate],

		(* If given primitives, set it to False. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		(* If no incubate options are specified, false *)
		MatchQ[Lookup[safeOptionsTemplateReplaced, {PostAutoclaveIncubate, PostAutoclaveIncubationTemperature, PostAutoclaveIncubationTime}], {(Automatic | Null)..}],
			False,

		(* If HeatSensitiveReagents is not populated, we should not be doing a post-autoclave mix *)
		MatchQ[Lookup[safeOptionsTemplateReplaced,HeatSensitiveReagents], {}|Null|Automatic],
			False,

		(* True otherwise *)
		True,
			True
	];

	(* get the pre-resolved MixTime *)
	(* if Mix -> True, Incubate -> True, IncubationTime is specified, and MixTime is Automatic, then resolve to the IncubationTime; otherwise just stick with what we have *)
	preResolvedMixTime = If[resolvedMixBool && resolvedIncubateBool && TimeQ[Lookup[safeOptionsTemplateReplaced, IncubationTime]] && MatchQ[Lookup[safeOptionsTemplateReplaced, MixTime], Automatic],
		Lookup[safeOptionsTemplateReplaced, IncubationTime],
		Lookup[safeOptionsTemplateReplaced, MixTime]
	];

	(* get the pre-resolved IncubationTime *)
	(* if Mix -> True, Incubate -> True, MixTime is specified, and IncubationTime is Automatic, then resolve to the MixTime; otherwise just stick with what we have *)
	preResolvedIncubationTime = If[resolvedMixBool && resolvedIncubateBool && TimeQ[Lookup[safeOptionsTemplateReplaced, MixTime]] && MatchQ[Lookup[safeOptionsTemplateReplaced, IncubationTime], Automatic],
		Lookup[safeOptionsTemplateReplaced, MixTime],
		Lookup[safeOptionsTemplateReplaced, IncubationTime]
	];

	(* Now do the same for the post-autoclave versions *)
	postAutoclavePreResolvedMixTime = If[postAutoclaveResolvedMixBool && postAutoclaveResolvedIncubateBool &&
     TimeQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveIncubationTime]] && MatchQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixTime], Automatic],
		Lookup[safeOptionsTemplateReplaced, PostAutoclaveIncubationTime],
		Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixTime]
	];
	postAutoclavePreResolvedIncubationTime = If[postAutoclaveResolvedMixBool && postAutoclaveResolvedIncubateBool &&
     TimeQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixTime]] && MatchQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveIncubationTime], Automatic],
		Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixTime],
		Lookup[safeOptionsTemplateReplaced, PostAutoclaveIncubationTime]
	];

	(* if mix rate exceeds the safe mix rate of resolvedContainerOut, replace it to Automatic otherwise it will fail ExperimentIncubate *)
	(* get the pre-resolved MixRate *)
	(* if Mix -> True, and MixType is Stir, check if the specified rate is safe *)
	{preResolvedMixRate, preResolvedMixRateReplaceQ} = If[resolvedMixBool && MatchQ[Lookup[safeOptionsTemplateReplaced, MixRate], Except[Automatic|Null]] && MatchQ[Lookup[safeOptionsTemplateReplaced, MixType], Stir],
		Module[{safeMixRate},
			(* get the safe mix rate of container model. *)
			safeMixRate = Lookup[fetchPacketFromCache[resolvedContainerOut, myContainerPackets], MaxOverheadMixRate];
			specifiedMixRate = Lookup[safeOptionsTemplateReplaced, MixRate];
			(* safeMixRate is very unlikely to be Null since resolvedContainerOut is from PreferredContainer[]. Give this NullQ check just in case *)
			If[NullQ[safeMixRate]||(safeMixRate > specifiedMixRate),
				(* if specified mix rate is safe, take it and do not need to update after ExperimentIncubate *)
				(* or if safeMixRate is not populated, a hard error will be thrown in ExperimentIncubate so take the specified mix rate *)
				{specifiedMixRate, False},
				(* otherwise, give a warning and resolve to Automatic so ExperimentIncubate will not error out for the specified mix rate *)
				Message[Warning::SpecifedMixRateNotSafe, ObjectToString[resolvedContainerOut]];
				(* we need to update the mix rate to use specified value *)
				{Automatic, True}
			]
		],
		(* keep Null or Automatic *)
		{Lookup[safeOptionsTemplateReplaced, MixRate], False}
	];
	(*do the same thing for post autoclave mix rate*)
	{postAutoclavePreResolvedMixRate, postAutoclavePreResolvedMixRateReplaceQ} = If[postAutoclaveResolvedMixBool && MatchQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixRate], Except[Automatic|Null]] && MatchQ[Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixType], Stir],
		Module[{safeMixRate},
			(* get the safe mix rate of container model. *)
			safeMixRate = Lookup[fetchPacketFromCache[resolvedContainerOut, myContainerPackets], MaxOverheadMixRate];
			specifiedPostAutoclaveMixRate = Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixRate];
			(* safeMixRate is very unlikely to be Null since resolvedContainerOut is from PreferredContainer[]. Give this NullQ check just in case *)
			If[NullQ[safeMixRate]||(safeMixRate > specifiedMixRate),
				(* if specified mix rate is safe, take it and do not need to update after ExperimentIncubate *)
				(* or if safeMixRate is not populated, a hard error will be thrown in ExperimentIncubate so take the specified mix rate *)
				{specifiedMixRate, False},
				(* otherwise, give a warning and resolve to Automatic so ExperimentIncubate will not error out for the specified mix rate *)
				Message[Warning::SpecifedMixRateNotSafe, ObjectToString[resolvedContainerOut]];
				(* we need to update the mix rate to use specified value *)
				{Automatic, True}
			]
		],
		(* keep Null or Automatic *)
		{Lookup[safeOptionsTemplateReplaced, PostAutoclaveMixRate], False}
	];

	(* get the safe options template replaced except with the pre-resolved incubation options *)
	safeOptionsTemplateWithMixAndIncubateTimes = ReplaceRule[safeOptionsTemplateReplaced, {
		MixTime -> preResolvedMixTime, IncubationTime -> preResolvedIncubationTime,
		PostAutoclaveMixTime -> postAutoclavePreResolvedMixTime, PostAutoclaveIncubationTime -> postAutoclavePreResolvedIncubationTime,
		MixRate -> preResolvedMixRate, PostAutoclaveMixRate -> postAutoclavePreResolvedMixRate
	}];

	(* UltrasonicIncompatible resolves based on whether 50% or more of the volume is comprised of the UltrasonicIncompatible components *)
	resolvedUltrasonicIncompatible = If[MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, UltrasonicIncompatible], BooleanP|Null],
		Lookup[safeOptionsTemplateWithMixAndIncubateTimes, UltrasonicIncompatible],
		Module[
			{ultrasonicIncompatibleFormula, expectedSolventVolume, solventUltrasonicIncompatibleQ,
				ultrasonicIncompatibleVolume, ultrasonicIncompatibleRatio},

			(* get the Formula entries for UltrasonicIncompatible items *)
			ultrasonicIncompatibleFormula = Select[myFormulaSpecWithPackets, TrueQ[Lookup[#[[2]], UltrasonicIncompatible]] && MatchQ[#[[1]], VolumeP]&];

			(* get the expected FillToVolumeSolvent volume *)
			expectedSolventVolume = If[NullQ[mySolventPacket],
				0,
				myFinalVolume - Total[Cases[componentAmounts,VolumeP]]
			];

			(* figure out if the solvent is UltrasonicIncompatible *)
			solventUltrasonicIncompatibleQ = If[NullQ[mySolventPacket],
				False,
				TrueQ[Lookup[mySolventPacket, UltrasonicIncompatible]]
			];

			(* get the total volume of the UltrasonicIncompatible components; need to account for the FillToVolumeSolvent if that is a factor *)
			ultrasonicIncompatibleVolume = If[solventUltrasonicIncompatibleQ,
				expectedSolventVolume + Total[ultrasonicIncompatibleFormula[[All, 1]]],
				Total[ultrasonicIncompatibleFormula[[All, 1]]]
			];

			(* get the ratio of the ultrasonic incompatible volume and the total volume *)
			(* need to watch out for if ultrasonicIncompatibleVolume is 0 because then what we really want is 0*Milliliter *)
			ultrasonicIncompatibleRatio = If[MatchQ[ultrasonicIncompatibleVolume, UnitsP[Milliliter]],
				ultrasonicIncompatibleVolume / effectiveStockSolutionVolume,
				(ultrasonicIncompatibleVolume*Milliliter) / effectiveStockSolutionVolume
			];

			(* if the ratio is 0.5 or greater, then UltrasonicIncompatible -> True, otherwise UltrasonicIncompatible -> Null *)
			If[ultrasonicIncompatibleRatio >= 0.5,
				True,
				Null
			]
		]
	];

	(* Figure out the compatible volumetric flasks to prepare for FTV resolution, considering the light sensitive requirement and incompatible materials *)
	compatibleVolumetricFlaskPackets=If[TrueQ[resolvedLightSensitive],
		(* When the stock solution is light sensitive, require Opaque->True and no incompatible materials *)
		Cases[Flatten@myVolumetricFlaskPackets,KeyValuePattern[{Opaque->True,ContainerMaterials->Except[{___,Alternatives@@resolvedIncompatibleMaterials,___}]}]],
		(* Otherwise just require no incompatible materials *)
		Cases[Flatten@myVolumetricFlaskPackets,KeyValuePattern[{ContainerMaterials->Except[{___,Alternatives@@resolvedIncompatibleMaterials,___}]}]]
	];

	(* Pull out volumetric flask volumes *)
	volumetricFlaskVolumes = Cases[Lookup[compatibleVolumetricFlaskPackets,MaxVolume],VolumeP];

	(* Determine max volumetric flask volume *)
	maxVolumetricFlaskVolume = If[MatchQ[volumetricFlaskVolumes,{VolumeP..}],
		Max[volumetricFlaskVolumes],
		0*Liter
	];

	(* Resolve our FillToVolumeMethod if we aren't given a method already. *)
	resolvedFillToVolumeMethod = Which[
		MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, FillToVolumeMethod], FillToVolumeMethodP],
			Lookup[safeOptionsTemplateWithMixAndIncubateTimes, FillToVolumeMethod],

		(* If given primitives, set it to Null. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			Null,

		(* Do we have a FillToVolumeSolvent? *)
		MatchQ[mySolventPacket, ObjectP[]],
			If[!TrueQ[resolvedUltrasonicIncompatible],
				Ultrasonic,
				Volumetric
			],

		True,
			Null
	];

	(* figure out the preparatory container as this is the container that would be in during mixing - definitely not the final container *)
	resolvedPrepContainer = FirstOrDefault[ToList[resolveStockSolutionPrepContainer[
		{IncompatibleMaterials -> preferredContainerIncompatibleMaterials},
		fakePreferredContainerVolume,
		resolvedLightSensitive,
		resolvedAutoclaveBoolean,
		resolvedFillToVolumeMethod,
		resolvedContainerOut,
		compatibleVolumetricFlaskPackets,
		Experiment`Private`makeFastAssocFromCache[myContainerPackets],
		PreferredContainers -> resolvedPreferredContainers
	]]];

	{
		mixIncubateTimeMismatchTests,mixSubOptionsSetIncorrectlyTests,incubateSubOptionsSetIncorrectlyTests,preResolvedMixOptions,
		mixOptionResolutionTests
	}=resolveMixIncubateUSSOptions[
		Mix,resolvedMixBool,resolvedIncubateBool,preResolvedMixTime,preResolvedIncubationTime,gatherTests,safeOptionsTemplateWithMixAndIncubateTimes,
		mixAndIncubateSubOptionNames,mixSubOptionNames,incubateSubOptionNames,fastTrack,mySolventPacket,resolvedPrepContainer,resolvedLightSensitive,
		effectiveStockSolutionVolume
	];

	{
		postAutoclaveMixIncubateTimeMismatchTests,postAutoclaveMixSubOptionsSetIncorrectlyTests,postAutoclaveIncubateSubOptionsSetIncorrectlyTests,
		postAutoclavePreResolvedMixOptions,postAutoclaveMixOptionResolutionTests
	}=resolveMixIncubateUSSOptions[
		PostAutoclaveMix,postAutoclaveResolvedMixBool,postAutoclaveResolvedIncubateBool,postAutoclavePreResolvedMixTime,postAutoclavePreResolvedIncubationTime,
		gatherTests,safeOptionsTemplateWithMixAndIncubateTimes,postAutoclaveMixAndIncubateSubOptionNames,postAutoclaveMixSubOptionNames,
		postAutoclaveIncubateSubOptionNames,fastTrack,mySolventPacket,resolvedPrepContainer,resolvedLightSensitive,effectiveStockSolutionVolume
	];

	(* replace the MixRate in resolvedMixOptions if specified rate is over safe rates *)
	resolvedMixOptions = If[preResolvedMixRateReplaceQ,
		ReplaceRule[preResolvedMixOptions, MixRate -> specifiedMixRate],
		preResolvedMixOptions
	];
	(* replace the PostAutoclaveMixRate in postAutoclaveResolvedMixOptions if specified rate is over safe rates *)
	postAutoclaveResolvedMixOptions = If[postAutoclavePreResolvedMixRateReplaceQ,
		ReplaceRule[postAutoclavePreResolvedMixOptions, PostAutoclaveMixRate -> specifiedPostAutoclaveMixRate],
		postAutoclavePreResolvedMixOptions
	];

	(* resolve the pH boolean *)
	resolvedAdjustpHBool = Which[
		BooleanQ[Lookup[safeOptionsTemplateReplaced, AdjustpH]],
			Lookup[safeOptionsTemplateReplaced, AdjustpH],
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,
		MatchQ[Lookup[safeOptionsTemplateReplaced, {NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle}], {(Null | Automatic)..}],
			False,
		True,
			True
	];

	(* pull out the specified NominalpH, MinpH, and MaxpH options *)
	{specifiedNominalpH, specifiedMinpH, specifiedMaxpH} = Lookup[safeOptionsTemplateReplaced, {NominalpH, MinpH, MaxpH}];

	(* if the NominalpH is STILL automatic, then resolve to a value between the min and max, or if only one of min or max is specified, 0.1 in the correct direction, or 7 otherwise, and Null otherwise *)
	nominalpH = Which[
		resolvedAdjustpHBool && MatchQ[specifiedNominalpH, Automatic] && NumericQ[specifiedMinpH] && NumericQ[specifiedMaxpH], Round[Mean[{specifiedMinpH, specifiedMaxpH}], 0.01],
		resolvedAdjustpHBool && MatchQ[specifiedNominalpH, Automatic] && NumericQ[specifiedMinpH], specifiedMinpH + 0.1,
		resolvedAdjustpHBool && MatchQ[specifiedNominalpH, Automatic] && NumericQ[specifiedMaxpH], specifiedMaxpH - 0.1,
		resolvedAdjustpHBool && MatchQ[specifiedNominalpH, Automatic], 7.,
		Not[resolvedAdjustpHBool] && MatchQ[specifiedNominalpH, Automatic], Null,
		True, specifiedNominalpH
	];

	(* if pH option has been resolved, there's a minimum solution volume we are willing to pH; don't let a formula get made that makes under this minimum *)
	{volumeTooLowForpHing, pHVolumeTooLowTests} = If[!fastTrack && preparableQ,
		Module[{volumeTooLow, test},

			(* is our effective volume under the min, AND we're pHing *)
			volumeTooLow = And[
				MatchQ[nominalpH, NumericP],
				effectiveStockSolutionVolume < $MinStockSolutionpHVolume
			];

			(* make test for this case *)
			test = If[gatherTests,
				Test[
					StringJoin[
						"If pH titration is requested, stock solution preparation volume is at least ",
						ToString[UnitForm[$MinStockSolutionpHVolume, Brackets -> False]],
						" to ensure that a pH probe can be inserted into the solution."
					],
					volumeTooLow,
					False
				],
				Nothing
			];

			(* yell if the volume is too low *)
			If[!gatherTests && volumeTooLow,
				Message[Error::VolumeBelowpHMinimum, "", effectiveStockSolutionVolume, $MinStockSolutionpHVolume];
				Message[Error::InvalidOption, NominalpH]
			];

			(* return bool and test *)
			{volumeTooLow, {test}}
		],

		(* it's fine, keepin going, don't worry about it yo *)
		{False, {}}
	];





	(* resolve the pHing options, recording if we had any problems *)
	{{resolvedMinpH, resolvedMaxpH, resolvedPreferredpHingAcid, resolvedPreferredpHingBase, resolvedMaxNumberOfpHingCycles, resolvedMaxpHingAdditionVolume, resolvedMaxAcidAmountPerCycle,resolvedMaxBaseAmountPerCycle}, pHOptionsInvalid, pHOptionValidityTests} = Module[
		{providedMinpH, providedMaxpH, providedPreferredpHingAcid, providedpReferredpHingBase, subOptionsSpecifiedIncorrectly,
			subOptionsTest, resolvedMin, resolvedMax, minMaxResolveInvalid, minMaxTests, resolvedAcid, resolvedBase,
			providedMaxNumberOfpHingCycles,providedMaxpHingAdditionVolume, providedMaxAcidAmountPerCycle,providedMaxBaseAmountPerCycle},

		(* get the specified option values *)
		{providedMinpH, providedMaxpH, providedPreferredpHingAcid, providedpReferredpHingBase, providedMaxNumberOfpHingCycles, providedMaxpHingAdditionVolume, providedMaxAcidAmountPerCycle,providedMaxBaseAmountPerCycle} = Lookup[
			safeOptionsTemplateWithMixAndIncubateTimes,
			{MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle}];

		(* check up front to make sure we haven't specified some of the sub-options without pH *)
		subOptionsSpecifiedIncorrectly = Or[
			And[
			Not[resolvedAdjustpHBool],
			!MatchQ[
				{nominalpH, providedMinpH, providedMaxpH, providedPreferredpHingAcid, providedpReferredpHingBase,providedMaxNumberOfpHingCycles,providedMaxpHingAdditionVolume,providedMaxAcidAmountPerCycle,providedMaxBaseAmountPerCycle},
				{Repeated[(Automatic | Null), {9}]}
			]
		],
			(* if a nominal pH is specified, don't allow us to Null out these other options for some reason (MaxNumberOfpHingCycles,MaxpHingAdditionVolume,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle can be Null) *)
			(MatchQ[nominalpH,NumericP]&&MemberQ[{providedMinpH, providedMaxpH, providedPreferredpHingAcid, providedpReferredpHingBase},Null])
		];

		(* make a test for this case *)
		subOptionsTest = If[gatherTests,
			Test["NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle are only specified if a pH is not set to False.",
				subOptionsSpecifiedIncorrectly,
				False
			],
			Nothing
		];

		(* yell about this case *)
		If[!gatherTests && !fastTrack && subOptionsSpecifiedIncorrectly,
			Message[Error::NoNominalpH];
			Message[Error::InvalidOption, {NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, providedMaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle}]
		];

		(* do some additional checking in order to resolve the min/max corerctly *)
		{{resolvedMin, resolvedMax}, minMaxResolveInvalid, minMaxTests} = If[subOptionsSpecifiedIncorrectly,
			{
				{providedMinpH, providedMaxpH} /. {Automatic -> Null},
				True,
				{}
			},
			Switch[{nominalpH, providedMinpH, providedMaxpH},

				(* if the NominalpH is unset, and the others are left Automatic or Nulled for some reason, can just resolve them to Null too, no problem *)
				{Null, Automatic|Null, Automatic|Null},
				{
					{Null, Null},
					False,
					{}
				},

				(* if the NominalpH is SET, and the others are left Automatic, can just resolve them using our 5 percent rule *)
				{NumericP, Automatic, Automatic},
				{
					{nominalpH - 0.1, nominalpH + 0.1},
					False,
					{}
				},

				(* NominalpH AND the others are set; make sure to resolve the automatic and that min<nominal<max *)
				{NumericP, Automatic, NumericP} | {NumericP, NumericP, Automatic} | {NumericP, NumericP, NumericP},
				Module[{pHOrderInvalid, orderInvalidTest, resMin, resMax},

					(* make sure the provided values are all in the right numeric order *)
					pHOrderInvalid = Switch[{nominalpH, providedMinpH, providedMaxpH},
						{NumericP, Automatic, NumericP},
						!(providedMaxpH > nominalpH),
						{NumericP, NumericP, Automatic},
						!(providedMinpH < nominalpH),
						{NumericP, NumericP, NumericP},
						!(providedMinpH < nominalpH < providedMaxpH)
					];

					(* make a test for the range being right *)
					orderInvalidTest = If[gatherTests,
						Test["If 2 or more of the options NominalpH, MinpH, and MaxpH are provided, the values are consistent with the ordering MinpH < NominalpH < MaxpH.",
							pHOrderInvalid,
							False
						],
						Nothing
					];

					(* yell a message if this ordering got messed up *)
					If[!fastTrack && !gatherTests && pHOrderInvalid,
						Message[Error::pHOrderInvalidUSS];
						Message[Error::InvalidOption, {MinpH, MaxpH}]
					];

					(* if the order is not in shambles, we can resolve in the case where one or the other was unspecified *)
					{resMin, resMax} = Switch[{providedMinpH, providedMaxpH},
						{NumericP, NumericP}, {providedMinpH, providedMaxpH},
						{Automatic, NumericP}, {nominalpH - 0.1, providedMaxpH},
						{NumericP, Automatic}, {providedMinpH, nominalpH + 0.1}
					];

					(* return the resolved values, the bool indicating if they are invalid, and the tests *)
					{
						{resMin, resMax},
						pHOrderInvalid,
						{orderInvalidTest}
					}
				],
				(* if a NominalpH is specified and other options are Null for some reason, we still need to return something here *)
				{NumericP, Null, _} | {NumericP, _, Null},
				{
					{
						If[MatchQ[providedMinpH,Automatic],
							nominalpH - 0.1,
							providedMinpH
						],
						If[MatchQ[providedMaxpH,Automatic],
							nominalpH + 0.1,
							providedMaxpH
						]
					},
					True,
					{}
				},
				(* if everything is Null then everything is Null and we're good *)
				{Null, Null, Null},
				{
					{Null, Null},
					False,
					{}
				}
			]
		];

		(* we can pretty easily "resolve" the phIng Acid/Base automatics now; may not be "legit" per above check, but just sub in the things aither way *)
		resolvedAcid = providedPreferredpHingAcid /. {Automatic -> If[NumericQ[nominalpH], Model[Sample, StockSolution,"2 M HCl"]]};
		resolvedBase = providedpReferredpHingBase /. {Automatic -> If[NumericQ[nominalpH], Model[Sample, StockSolution, "1.85 M NaOH"]]};

		(* return all of the resolve values, and an overall boolean indicating if this resolving should be considered valid *)
		{
			Join[
				{resolvedMin, resolvedMax, resolvedAcid, resolvedBase},
				{providedMaxNumberOfpHingCycles, providedMaxpHingAdditionVolume, providedMaxAcidAmountPerCycle,providedMaxBaseAmountPerCycle}/.{Automatic->Null}
			],
			And[
				!fastTrack,
				Or[
					subOptionsSpecifiedIncorrectly,
					minMaxResolveInvalid
				]
			],
			Flatten[{subOptionsTest, minMaxTests}]
		}
	];



	(* resolve the Filtration bool; if it is still Automatic, make it False (means we had no template and it wasn't specified explicitly) *)
	resolvedFilterBool = Which[
		(* If mix is specified, use that *)
		!MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, Filter], Automatic],
			Lookup[safeOptionsTemplateWithMixAndIncubateTimes, Filter],

		(* If given primitives, set it to False. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			False,

		True,
			False
	];

	(* assign the names of the Filter "sub-options" (things controlled by Filter bool) *)
	filterSubOptionNames = {FilterMaterial, FilterSize};

	(* now resolve the Filter options; if Filter controlling boolean is set to False but any sub-options are non-Automatic/Null, we can yell about that *)
	{filterSubOptionsSetIncorrectly, filterSubOptionsSetIncorrectlyTests} = If[!fastTrack,
		Module[{incorrectFilterSubOptions, invalidBool, test},

			(* identify incorrectly-specified sub options *)
			incorrectFilterSubOptions = If[MatchQ[resolvedFilterBool, False],
				PickList[filterSubOptionNames, Lookup[safeOptionsTemplateWithMixAndIncubateTimes, filterSubOptionNames], Except[Null | Automatic]],
				{}
			];

			(* we will re-use the boolean check if there are symbols in here; make a variable for that *)
			invalidBool = MatchQ[incorrectFilterSubOptions, {_Symbol..}];

			(* make a test for reporting mix options that are set without the parent bool *)
			test = If[gatherTests,
				Test["If any specific filtration options are specified, the Filter boolean option is specifically set to True:",
					invalidBool,
					False
				],
				Nothing
			];

			(* throw an error about this *)
			If[!gatherTests && invalidBool,
				Message[Error::FilterOptionConflictUSS, incorrectFilterSubOptions];
				Message[Error::InvalidOption, incorrectFilterSubOptions]
			];

			(* report a boolean indicating if we tripped this check, and the test *)
			{invalidBool, {test}}
		],
		{False, {}}
	];

	(* if Filter option has been resolved to True, there's a minimum solution volume we are willing to filter; don't let a formula get made that makes under this minimum *)
	{volumeTooLowForFiltration, filtrationVolumeTooLowTests} = If[!fastTrack && preparableQ,
		Module[{volumeTooLow, test},

			(* is our effective volume under the min, AND we're pHing *)
			volumeTooLow = And[
				resolvedFilterBool,
				effectiveStockSolutionVolume < $MinStockSolutionFilterVolume
			];

			(* make test for this case *)
			test = If[gatherTests,
				Test[
					StringJoin[
						"If filtration is requested, stock solution preparation volume is at least ",
						ToString[UnitForm[$MinStockSolutionFilterVolume, Brackets -> False]],
						" to ensure that a filtration method with low enough dead volume can be selected."
					],
					volumeTooLow,
					False
				],
				Nothing
			];

			(* yell if the volume is too low *)
			If[!gatherTests && volumeTooLow,
				Message[Error::VolumeBelowFiltrationMinimum, "", effectiveStockSolutionVolume, $MinStockSolutionFilterVolume];
				Message[Error::InvalidOption, Filter]
			];

			(* return bool and test *)
			{volumeTooLow, {test}}
		],

		(* it's fine, keepin going, don't worry about it yo *)
		{False, {}}
	];

	(* resolve the filtration options; need to use ExperimentFilter blob helper resolveFilterOptions; gonna have to dance around some odd cases *)
	{resolvedFilterOptions, filterResolutionInvalid, filterOptionResolutionTests} = If[resolvedFilterBool,
		Module[{justFilterOptions, ussmToFilterOptionNameMap, renamedFilterOptions, filterResolveFailure, resFilterOptions,
			filterResolvingTests, filterToUSSMOptionNameMap, resolvedUSSMFilterOptionsAssociation,
			resolvedUSSMFilterOptionsSingleValues, sampleModelForSimulation, simulatedSamplePackets, simulatedContainer,
			expandedFilterOptions, allSimulatedPackets},

			(* set a model to use as the "fake" model for Mix; want it to be a liquid, so either use the solvent model, or Milli-Q water if we don't have that *)
			sampleModelForSimulation = If[MatchQ[mySolventPacket, PacketP[]],
				Lookup[mySolventPacket, Object],
				Model[Sample, "Milli-Q water"]
			];

			(* need to make a simulated sample to give to mix for resolution; we don't even have a stock solution model yet though; just send Mix the solvent, or water *)
			(* need to quiet the SimulateSample error that tells me I can't pass MolecularWeight in things that don't have that field (like StockSolution etc).  However I need to simulate with it for now because Aliquot downloads it in either case  *)
			{simulatedSamplePackets, simulatedContainer} = Quiet[
				SimulateSample[{sampleModelForSimulation}, "stock solution sample 1", {"A1"}, resolvedPrepContainer, {State -> Liquid, LightSensitive -> resolvedLightSensitive, Volume -> effectiveStockSolutionVolume, Mass -> Null, Count -> Null}],
				SimulateSample::InvalidPacket
			];

			(* take JUST the filtration options; BEWARE this output is an association not a list of rules; make list for easy option name replacing *)
			justFilterOptions = Normal@KeyTake[safeOptionsTemplateWithMixAndIncubateTimes, filterSubOptionNames];

			(* define a mapping between this function's filter option names and ExperimentFilter option names THAT ARE DIFFERENT *)
			ussmToFilterOptionNameMap = {
				FilterMaterial -> MembraneMaterial,
				FilterSize -> PoreSize
			};

			(* rename the filter options as ExperimentFilter knows them all by different names; ReplaceAll doesn't work on assoc keys; default to sanme name if not different *)
			renamedFilterOptions = SafeOptions[ExperimentFilter, Map[
				(First[#] /. ussmToFilterOptionNameMap) -> Last[#]&,
				justFilterOptions
			]];

			(* expand the filter options *)
			expandedFilterOptions = Last[ExpandIndexMatchedInputs[ExperimentFilter, {Lookup[simulatedSamplePackets, Object]}, renamedFilterOptions]];

			(* group the simulated packets together *)
			allSimulatedPackets = Flatten[{simulatedSamplePackets, simulatedContainer}];

			(* use Check to see if we got an error from mix options; still throw those mssage;
			 	ALWAYS assign the results even if messages are thrown  *)
			filterResolveFailure = Check[
				{resFilterOptions, filterResolvingTests} = If[gatherTests,
					ExperimentFilter[Lookup[simulatedSamplePackets, Object], ReplaceRule[expandedFilterOptions, {Cache -> allSimulatedPackets, Simulation -> Simulation[allSimulatedPackets], OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
					{ExperimentFilter[Lookup[simulatedSamplePackets, Object], ReplaceRule[expandedFilterOptions, {Cache -> allSimulatedPackets, Simulation -> Simulation[allSimulatedPackets], OptionsResolverOnly -> True, Output -> Options}]], {}}
				],
				$Failed,
				{Error::InvalidInput, Error::InvalidOption}
			];

			(* reverse our earlier lookup to get a map back to our USSM option names *)
			filterToUSSMOptionNameMap = Reverse /@ ussmToFilterOptionNameMap;

			(* we are assuming that this resolver ALWAYS retrusn resolved otpions; get those back; resolveFilterOptions spits out list of rules, make association for ease of next step *)
			resolvedUSSMFilterOptionsAssociation = <|Map[
				(First[#] /. filterToUSSMOptionNameMap) -> Last[#]&,
				resFilterOptions
			]|>;

			(* the filter resolve gives us listed options; we want the first of any list since we for sure gave just one sample blob *)
			resolvedUSSMFilterOptionsSingleValues = KeyValueMap[
				#1 -> If[ListQ[#2] && Length[#2] == 1,
					First[#2],
					#2
				]&,
				resolvedUSSMFilterOptionsAssociation
			];

			(* we're ready to spit back out the resolve filter options with the right names, whether the resolving went smoothly, and thet tests generated *)
			{resolvedUSSMFilterOptionsSingleValues, MatchQ[filterResolveFailure, $Failed], filterResolvingTests}
		],

		(* otherwise we're not filtering; everything is Null (if it was specified, we already yelled about it above, so claim that this resolution was fine) *)
		{Normal[KeyTake[<|safeOptionsTemplateWithMixAndIncubateTimes|>, filterSubOptionNames]] /. {Automatic -> Null}, False, {}}
	];




	(* If we were given our FillToVolumeMethod, check it. *)
	(* have different error booleans for if we're invalid with ultrasonics and if we're invalid because of fill to volume *)
	invalidFillToVolumeMethodUltrasonic = And[
		(* The user gave us the option. *)
		MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, FillToVolumeMethod], Ultrasonic],
		TrueQ[resolvedUltrasonicIncompatible]
	];
	invalidFillToVolumeMethodVolumetric = And[
		(* The user gave us the option. *)
		MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, FillToVolumeMethod], Volumetric],
		MatchQ[myFinalVolume, GreaterP[maxVolumetricFlaskVolume]] (* The largest VolumetricFlask we have. *)
	];
	invalidFillToVolumeMethodNoSolvent = And[
		(* The user gave us the option. *)
		MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, FillToVolumeMethod], FillToVolumeMethodP],
		(* No Solvent *)
		Not[MatchQ[mySolventPacket, ObjectP[]]]
	];

	(* note that I"m using "" here as the first input because UploadStockSolution does not have good way to represent the inputs in line *)
	If[!gatherTests && invalidFillToVolumeMethodUltrasonic,
		Message[Error::InvalidUltrasonicFillToVolumeMethod, ""];
		Message[Error::InvalidOption, FillToVolumeMethod]
	];
	If[!gatherTests && invalidFillToVolumeMethodVolumetric,
		Module[
			{lightSensitiveString,incompatibleMaterialsString,volumetricFlaskString},
			(* Provide a string for how volumetric flasks are being selected *)
			lightSensitiveString=If[TrueQ[resolvedLightSensitive],
				"Opaque -> True (for light-sensitive stock solution model)",
				""
			];
			incompatibleMaterialsString=If[MatchQ[resolvedIncompatibleMaterials,{}],
				"",
				"not made from the stock solution model's incompatible materials "<>ToString[resolvedIncompatibleMaterials]
			];
			volumetricFlaskString=Switch[
				{lightSensitiveString,incompatibleMaterialsString},
				{"",""},"",
				{Except[""],Except[""]},"that are "<>lightSensitiveString<>" and "<>incompatibleMaterialsString,
				_,"that are "<>lightSensitiveString<>incompatibleMaterialsString
			];
			Message[Error::InvalidVolumetricFillToVolumeMethod, "", ObjectToString[maxVolumetricFlaskVolume],volumetricFlaskString];
			Message[Error::InvalidOption, FillToVolumeMethod]
		]
	];
	If[!gatherTests && invalidFillToVolumeMethodNoSolvent,
		Message[Error::InvalidFillToVolumeMethodNoSolvent, ""];
		Message[Error::InvalidOption, FillToVolumeMethod]
	];

	(* Resolve composition and several safety fields *)
	(* we quiet the download message to avoid it when calling UploadSamlpeTransfer with a no-model sample *)
	{preResolvedComposition,preResolvedSafetyPacket}=If[!unitOpsQ,
			Quiet[flattenFormula[
				myFormulaSpecWithPackets,
				mySolventPacket,
				myFinalVolume,
				(* Join our packets together. *)
				Flatten[{myPreparatoryFormulaPackets,myFormulaSpecWithPackets[[All,2]]}]
			],{Download::ObjectDoesNotExist}
		],
		Module[
			{
				labelOfInterest,simulatedContainer,simulatedSampleComposition,sanitizedSimulatedSampleComposition,
				allEHSFields,simulatedSamples,safetyPacket, updatedSimulation
			},
			(*get the first label container unit operation,it should be the very first*)
			labelOfInterest = First[Cases[myUnitOperations, _LabelContainer]][Label];
			(*figure out what is the container that was simulated for it and whats in it*)
			simulatedContainer =Lookup[Lookup[First[Lookup[mySafeOptions, Simulation]], Labels],labelOfInterest];
			updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, Lookup[mySafeOptions, Simulation]];

			(*get the sample in that container and its volume*)
			simulatedSampleComposition =  Download[simulatedContainer, Contents[[1, 2]][Composition],Simulation -> updatedSimulation];
			(* make sure we're not dealing with links *)
			sanitizedSimulatedSampleComposition = {#[[1]], Download[#[[2]], Object]}& /@ simulatedSampleComposition;

			(* Get all of the EHS fields that need to be updated. *)
			allEHSFields=Cases[ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]],Except[StorageCondition]];

			(* safety packet *)
			simulatedSamples = Download[simulatedContainer, Contents[[1, 2]],Simulation -> updatedSimulation];
			safetyPacket = KeyValueMap[#1->#2&,Download[Download[simulatedSamples,Object], Evaluate[Packet[Sequence@@allEHSFields]],Simulation -> updatedSimulation]/. {link_Link :> Download[link, Object]}];

			(* return values *)
			{sanitizedSimulatedSampleComposition,safetyPacket}
		]
	];

	(* Resolve our full formula if the user hasn't given it to us. *)
	resolvedComposition=If[MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes,Composition],Except[Automatic]],
		Lookup[safeOptionsTemplateWithMixAndIncubateTimes,Composition],
		(* The automatically calculated composition might container very long numbers, that roundPrecisionBeforeFinalJSON will throw a warning *)
		preResolvedComposition /. value_Quantity :> SafeRound[value, 10^-3]
	];

	(* Resolve our order of operations based on if our prep stages are toggled. *)
	resolvedOrderOfOperations=Which[
		!MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes,OrderOfOperations], Automatic],
			Lookup[safeOptionsTemplateWithMixAndIncubateTimes,OrderOfOperations],
		(* If given primitives, set it to Null. *)
		MatchQ[myUnitOperations, {SamplePreparationP..}],
			Null,
		True,
			{
				(* Always present *)
				FixedReagentAddition,

				(* don't resolve to FTV if the formula already specified the whole volume.  *)
				If[MatchQ[myFinalVolume, VolumeP]&&!NullQ[mySolventPacket],
					FillToVolume,
					Nothing
				],

				If[MatchQ[nominalpH, RangeP[0, 14]],
					pHTitration,
					Nothing
				],

				If[MatchQ[resolvedIncubateBool, True] || MatchQ[resolvedMixBool, True],
					Incubation,
					Nothing
				],

				If[MatchQ[resolvedFilterBool, True],
					Filtration,
					Nothing
				]
		}
	];

	(* Make sure that the OrderOfOperations given is valid. *)
	validOrderOfOperations=Or[
		MatchQ[resolvedOrderOfOperations, Null],

		(* if we're using unit operations, Order of operations will cause an error anyway down the line *)
		unitOpsQ,

		And[
			(* There's at least 1 element. *)
			Length[resolvedOrderOfOperations] > 0,

			(* The first element is FixedReagentAddition. *)
			MatchQ[FirstOrDefault[resolvedOrderOfOperations, Null], FixedReagentAddition],

			(* Filter is at the end, if it shows up. *)
			If[MemberQ[resolvedOrderOfOperations, Filtration], MatchQ[resolvedOrderOfOperations, {__, Filtration}], True],

			(* Incubate is after FillToVolume and/or pHTitration, if it shows up. *)
			Or[
				(* if it doesn't show up, then that's fine *)
				Not[MemberQ[resolvedOrderOfOperations, Incubation]],
				(* if it does show up, then FillToVolume and/or pHTitration must be first and not after it *)
				MemberQ[resolvedOrderOfOperations, Incubation] && MatchQ[resolvedOrderOfOperations, {FixedReagentAddition, Repeated[FillToVolume | pHTitration, {0, 1}], Repeated[FillToVolume | pHTitration, {0, 1}], Incubation, Except[Incubation | pHTitration | FillToVolume] ...}]
			],

			(* Steps cannot be duplicated. *)
			MatchQ[resolvedOrderOfOperations, DeleteDuplicates[resolvedOrderOfOperations]],

			(* Steps must contain everything specified by other options *)
			And[
				(* pH *)
				Or[
					MatchQ[resolvedAdjustpHBool,True]&&MemberQ[resolvedOrderOfOperations,pHTitration],
					!MatchQ[resolvedAdjustpHBool,True]&&!MemberQ[resolvedOrderOfOperations,pHTitration]
				],
				(* FTV *)
				(* We are using FTV method as the criteria here since myFinalVolume can be a volume even we don't do FTV when called by ExperimentSS. ExperimentSS preresolves OrderOfOperations and FinalVolume, based on the requested total volume. *)
				Or[
					MatchQ[resolvedFillToVolumeMethod, Except[Null]]&&MemberQ[resolvedOrderOfOperations,FillToVolume],
					NullQ[resolvedFillToVolumeMethod]&&!MemberQ[resolvedOrderOfOperations,FillToVolume]
				],
				(* Incubation *)
				Or[
					(MatchQ[resolvedIncubateBool, True]||MatchQ[resolvedMixBool, True])&&MemberQ[resolvedOrderOfOperations,Incubation],
					!MatchQ[resolvedIncubateBool, True]&&!MatchQ[resolvedMixBool, True]&&!MemberQ[resolvedOrderOfOperations,Incubation]
				],
				(* Filtration *)
				Or[
					MatchQ[resolvedFilterBool,True]&&MemberQ[resolvedOrderOfOperations,Filtration],
					!MatchQ[resolvedFilterBool,True]&&!MemberQ[resolvedOrderOfOperations,Filtration]
				]
			]
		]
	];

	If[!gatherTests && !validOrderOfOperations,
		Message[Error::InvalidOrderOfOperations];
		Message[Error::InvalidOption, OrderOfOperations];
	];

	orderOfOperationsTest=If[gatherTests,
		Test["The OrderOfOperations given is supported by ExperimentStockSolution:",validOrderOfOperations,True],
		{}
	];

	(* Make sure that the OrderOfOperations given is valid for pHing. If we are doing pHTitration before FillToVolume, we must make sure we have liquid in the formula. We cannot pHTitration on solid. *)
	(* Only need to check this when our OrderOfOperations is valid (otherwise we already threw an error) AND we do pHTitration before FTV or no FTV (after FTV it is guaranteed to be a liquid *)
	validOrderOfOperationsForpH=If[
		And[
			validOrderOfOperations,
			!unitOpsQ,
			Or[
				MatchQ[resolvedOrderOfOperations,{___,pHTitration,___,FillToVolume,___}],
				!MemberQ[resolvedOrderOfOperations,FillToVolume]&&MemberQ[resolvedOrderOfOperations,pHTitration]
			]
		],
		!MatchQ[Lookup[myFormulaSpecWithPackets[[All,2]],State,Null],{Solid...}],
		True
	];

	If[!gatherTests && !validOrderOfOperationsForpH,
		Message[Error::InvalidOrderOfOperationsForpH];
		Message[Error::InvalidOption, OrderOfOperations];
	];

	orderOfOperationsForpHTest=If[gatherTests,
		Test["The OrderOfOperations given is supported by ExperimentStockSolution that pHTitration is not performed on Solid sample:",validOrderOfOperationsForpH,True],
		{}
	];

	(* generate the resolved options; we have set these up to always get values, even if not "legit" resolution (have bools indicating this) *)
	resolvedOptions = ReplaceRule[safeOptionsTemplateWithMixAndIncubateTimes,
		Join[
			{
				Type -> resolvedType,
				Mix -> resolvedMixBool,
				AdjustpH -> resolvedAdjustpHBool,
				NominalpH -> nominalpH,
				MinpH -> resolvedMinpH,
				MaxpH -> resolvedMaxpH,
				pHingAcid -> resolvedPreferredpHingAcid,
				pHingBase -> resolvedPreferredpHingBase,
				Filter -> resolvedFilterBool,
				UltrasonicIncompatible -> resolvedUltrasonicIncompatible,
				Incubate -> resolvedIncubateBool,
				PreferredContainers -> resolvedPreferredContainers,
				Resuspension -> resolvedResuspension,
				PrepareInResuspensionContainer -> resolvedPrepareInResuspensionContainer,
				VolumeIncrements -> resolvedVolumeIncrements,
				FulfillmentScale->resolvedFulfillmentScale,
				Preparable -> preparableQ,
				Composition->resolvedComposition,
				FillToVolumeMethod->resolvedFillToVolumeMethod,
				OrderOfOperations->resolvedOrderOfOperations,
				Autoclave->resolvedAutoclaveBoolean,
				AutoclaveProgram->resolvedAutoclaveProgram,
				MaxAcidAmountPerCycle->resolvedMaxAcidAmountPerCycle,
				MaxBaseAmountPerCycle->resolvedMaxBaseAmountPerCycle,
				MaxNumberOfpHingCycles->resolvedMaxNumberOfpHingCycles,
				MaxpHingAdditionVolume->resolvedMaxpHingAdditionVolume,
				PostAutoclaveMix->postAutoclaveResolvedMixBool,
				PostAutoclaveIncubate->postAutoclaveResolvedIncubateBool
			},
			(* only want the options from here that we even have *)
			Normal@KeyTake[<|resolvedMixOptions|>, mixAndIncubateSubOptionNames],
			Normal@KeyTake[<|postAutoclaveResolvedMixOptions|>, postAutoclaveMixAndIncubateSubOptionNames],
			Normal@KeyTake[<|resolvedFilterOptions|>, filterSubOptionNames],
			resolvedFormulaOnlyOptions
		]
	];

	(* Make sure that if the Primitives option is set, other preparation related options cannot be set. *)
	invalidPrimitivesOptions=If[!MatchQ[myUnitOperations, {SamplePreparationP..}],
		{},
		Select[
			{
				Incubate, IncubationTemperature, IncubationTime, Mix, MixUntilDissolved, MixTime, MaxMixTime, MixType,
				Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes, AdjustpH, NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
				Filter, FilterMaterial, FilterSize, Autoclave, AutoclaveProgram, OrderOfOperations, FillToVolumeMethod
			},
			(!MatchQ[Lookup[resolvedOptions, #], False|Null]&)
		]
	];

	If[!gatherTests && Length[invalidPrimitivesOptions]>0,
		Message[Error::ConflictingUnitOperationsOptions, invalidPrimitivesOptions];
		Message[Error::InvalidOption, invalidPrimitivesOptions];
	];

	invalidPrimitivesOptionsTest=If[gatherTests,
		Test["The preparation related options (Incubate, Mix, Filter, pH, etc.) cannot be set if the UnitOperations override option is given:",Length[invalidPrimitivesOptions]==0,True],
		{}
	];

	(* assemble all tests generated during resolution *)
	allOptionResolutionTests = Flatten[{
		precisionTests,
		formulaOnlyTests,
		invalidResuspensionTest,
		mixSubOptionsSetIncorrectlyTests,
		postAutoclaveMixSubOptionsSetIncorrectlyTests,
		incubateSubOptionsSetIncorrectlyTests,
		postAutoclaveIncubateSubOptionsSetIncorrectlyTests,
		mixOptionResolutionTests,
		postAutoclaveMixOptionResolutionTests,
		pHVolumeTooLowTests,
		pHOptionValidityTests,
		filterSubOptionsSetIncorrectlyTests,
		filtrationVolumeTooLowTests,
		filterOptionResolutionTests,
		mixIncubateTimeMismatchTests,
		postAutoclaveMixIncubateTimeMismatchTests,
		invalidPreparationTests,
		invalidResuspensionAmountsTests,
		fulfillmentScaleVolIncrementsMismatchTests,
		orderOfOperationsTest,
		orderOfOperationsForpHTest,
		invalidPrimitivesOptionsTest
	}];

	(* return the options and the tests (if any) *)
	{resolvedOptions, allOptionResolutionTests}
];


(* ::Subsubsection::Closed:: *)
(*flattenFormula*)


flattenFormula[
	myFormulaSpecWithPackets:{{VolumeP|MassP|NumericP,PacketP[{Model[Sample],Object[Sample]}]}..},
	mySolventPacket:(PacketP[{Model[Sample]}]|Null),
	myFinalVolume:(VolumeP|Null),
	myPreparatoryFormulaPackets:{PacketP[]...}
]:=Module[{allEHSFields,formulaWithSolventPackets,simulatedSamplePackets,destinationSample,sourceSamples,uploadSampleTransferPackets,resultPacket,resultSafetyPacket,destinationComposition,destinationSafetyPacket},

	(* Get all of the EHS fields that need to be updated. *)
	allEHSFields=Cases[ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]],Except[StorageCondition]];

	(* Add our solvent to our formula. *)
	(* This is so that our FTV solvent is simulated in our UploadSampleTransfer call. *)
	formulaWithSolventPackets=If[MatchQ[mySolventPacket,Except[Null]]&&MatchQ[myFinalVolume,VolumeP],
		Module[{formulaVolume},

			(* Calculate the total volume of the formula (converting masses to volumes when possible) *)
			(* TODO: Leave comment about why we are doing this/what UST is doing *)
			formulaVolume = Total[
				Map[Function[{formulaComponent},
					Module[{componentSpecPacket,amount,componentDensity,waterDensity},
						(* Extract the component and amount *)
						amount = formulaComponent[[1]];
						componentSpecPacket = formulaComponent[[2]];

						(* Get the density of the component *)
						componentDensity = Lookup[componentSpecPacket,Density,Null];

						(* Define water density as a backup *)
						waterDensity = 0.997 Gram / Milliliter;

						(* If a Volume is provided, keep it, if a mass is provided use density to convert (default to water density) *)
						Which[
							MatchQ[amount,VolumeP],
							amount,
							MatchQ[amount,MassP] && MatchQ[componentDensity,DensityP],
							amount / componentDensity,
							MatchQ[amount,MassP],
							amount / waterDensity,
							True,
							0 Liter
						]
					]
				],
					myFormulaSpecWithPackets
				]
			];

			(* Add the correct volume to the formula *)
			Append[
				myFormulaSpecWithPackets,
				(* need to do this Max thing here because if we have formula volume greater than total volume, we don't want to trainwreck and have a negative volume (we are are already throwing an error if we are in that situation elsewhere in the function) *)
				{Max[myFinalVolume-formulaVolume, 0 Liter],mySolventPacket}
			]
		],
		myFormulaSpecWithPackets
	];

	(* Create our simulated samples. *)
	simulatedSamplePackets=Map[
		Function[{formulaEntry},

			(* SimulateSample returns a {samplePackets, containerPackets}. We only care about the first sample packet. *)
			First@First@SimulateSample[
				{Lookup[formulaEntry[[2]],Object]},
				CreateUUID[],
				{"A1"},
				(* We don't actually care what container we're in. Pick the largest one. *)
				Model[Container,Vessel,"10L Polypropylene Carboy"],
				(* Pass in the correct override options. *)
				Flatten[{
					Switch[{formulaEntry[[1]], Lookup[formulaEntry[[2]],State]},
						(* if it is a liquid given by volume *)
						{VolumeP, Liquid},
							{
								State->Liquid,
								Volume->formulaEntry[[1]],
								Mass->Null,
								Count->Null
							},
						(* if it is a liquid given by mass, calculate its volume from density *)
						(* if no density is found, use the density of water *)
						{MassP, Liquid},
						{
							State->Liquid,
							Volume->formulaEntry[[1]]/Replace[Lookup[formulaEntry[[2]],Density],Null->Quantity[0.997`, ("Grams")/("Milliliters")]],
							Mass->Null,
							Count->Null
						},
						(* if it is a solid given by mass *)
						{MassP, Solid},
							{
								State->Solid,
								Volume->Null,
								Mass->formulaEntry[[1]],
								Count->Null
							},
						(* if it is given by count *)
						(* CountP is just _Integer so if I want something like 4. to be an integer then I need to do the GreaterP thing; note that I need to do 0. and not just 0 because that won't work *)
						{CountP | GreaterP[0., 1], _},
							{
								State->Liquid,
								Volume->Null,
								Mass->Null,
								(* need to use Round to ensure 4. doesn't trip us up *)
								Count->Round[formulaEntry[[1]]]
							},
						(* in other rare cases, for example, the state is a gas, just default the input here based on the unit of the amount provided. It should be ok since we have thrown error for this before. It will make sure the SimulateSample is execuated without any problem. *)
						{VolumeP,_},
							{
								State->Liquid,
								Volume->formulaEntry[[1]],
								Mass->Null,
								Count->Null
							},
						{MassP,_},
							{
								State->Solid,
								Volume->Null,
								Mass->formulaEntry[[1]],
								Count->Null
							}
					],
					{
						Composition->Lookup[formulaEntry[[2]],Composition],
						Density->Lookup[formulaEntry[[2]],Density],
						Solvent->Lookup[formulaEntry[[2]],Solvent],
						StorageCondition->Lookup[formulaEntry[[2]],DefaultStorageCondition],
						VolumeLog->{},
						MassLog->{},
						CountLog->{}
					},
					(* doing this to make sure all the links do not have backlinks; this is mainly important for the PipettingMethod field, which has a backlink in the Model but not in the Object and so we don't want the backlink here *)
					(* some EHS fields end up being $Failed instead of Null here and we don't want that to be an issue here so just ignore those *)
					Map[
						With[{value = Lookup[formulaEntry[[2]], #]},
							If[MatchQ[value, $Failed],
								Nothing,
								# -> value
							]
						]&,
						allEHSFields
					] /. {x:LinkP[] :> Link[x]}
				}]
			]
		],
		formulaWithSolventPackets
	];

	(* if we have only one component, just return the data from it, no need to go further *)
	If[Length[simulatedSamplePackets]==1,
		Return[
			{
				Lookup[simulatedSamplePackets[[1]], Composition] /. {link_Link :> Download[link, Object]},
				simulatedSamplePackets[[1]] /. {link_Link :> Download[link, Object]}
			},
			Module]
	];

	(* Pretend that the first line item in our formula is the destination sample. *)
	destinationSample=Lookup[First[simulatedSamplePackets],Object];
	sourceSamples=Lookup[Rest[simulatedSamplePackets],Object];

	(* Call UploadSampleTransfer to get our final Composition and resolved safety fields. *)
	uploadSampleTransferPackets=UploadSampleTransfer[
		sourceSamples,
		ConstantArray[destinationSample,Length[sourceSamples]],
		ConstantArray[All,Length[sourceSamples]],
		Cache->FlattenCachePackets[{simulatedSamplePackets,myPreparatoryFormulaPackets}],
		Upload->False,
		UpdateSolventAndMedia->False
	];

	(* Look for the resulting packet of the destination sample with the Composition field. *)
	resultPacket=FirstCase[uploadSampleTransferPackets,KeyValuePattern[{Object->destinationSample,Replace[Composition]->_}],<||>];

	(* Obtain packet that have safety info. Use Flammable field for the case selection. It should contain all the other safety related fields. *)
	resultSafetyPacket=FirstCase[uploadSampleTransferPackets,KeyValuePattern[{Object->destinationSample,Flammable->_}],<||>];

	(* If UploadSampleTransfer failed, we weren't able to resolve the Composition and safety fields. *)
	{destinationComposition,destinationSafetyPacket}=If[MatchQ[resultPacket,<||>],
		{
			{{Null, Null}},
			<||>
		},
		(* the resulted composition need to be sanitized to 1) remove link, and 2) not include the date object *)
		Module[{resultedComposition, sanitizedDestinationComposition},
			(* Look up the composition from the result packet *)
			resultedComposition = Lookup[resultPacket, Replace[Composition]];
			(* Only the include the amount and link-ripped object *)
			sanitizedDestinationComposition = {#[[1]], Download[#[[2]], Object]}& /@ resultedComposition;
			(* Return the sanitized composition and safety packet *)
			{
				sanitizedDestinationComposition,
				resultSafetyPacket /. {link_Link :> Download[link, Object]}
			}
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*newStockSolution*)


(*
	PACKET CREATOR - core overload (not for unit operations)
		- turns the formula and resolved options into a new stock solution model packet
		- ALSO looks for an existing model with EXACTLY the same prep parameters (not safety)
			- a specified Name overrides this behavior
			*)
newStockSolution[
	myFormulaSpec:{{VolumeP|MassP|NumericP,ObjectP[{Model[Sample],Object[Sample]}]}..},
	mySolvent:(ObjectP[{Model[Sample]}]|Null),
	myFinalVolume:(VolumeP|Null),
	myDefaultStorageConditionObject:ObjectReferenceP[Model[StorageCondition]],
	myReturnExistingModelBool:BooleanP,
	myModelTemplateInput:(ObjectP[Model[Sample]]|Null),
	myAuthor:ObjectP[Object[User]],
	myAuthorNotebooks:{ObjectReferenceP[Object[LaboratoryNotebook]]...},
	myResolvedOptions:{_Rule..}
]:=Module[
	{
		componentTuples, components, componentAmounts, componentsStates, componentsSteriles, solventTuple, solventSterile,
		newModelType, altPrepSearchConditions, sameFormulaComponentModels,
		alternativePreparationPackets, uploadReadyFormula, fieldRule, checkFieldsList, newStockSolutionPacket, existingMatchingModel,
		modelTemplateInputObject, mismatchFields, resolvedSterile, resolvedAsepticHandling, upload, resolvedOptionsNoAmbient,
		state, gatherTests, fastTrack, sameFormulaComponentDownloadValues, sameFormulaComponentModelPacketsWithObjects,
		sameFormulaComponentComponentModelPackets, massFormulas, componentMassAmounts
	},

	(* pull out the Upload option *)
	upload = Lookup[myResolvedOptions,Upload];

	(* change all Ambients into Null right away since it messes with fields *)
	resolvedOptionsNoAmbient = myResolvedOptions /. {Ambient -> Null};

	(* turn the formula into components/amounts *)
	componentAmounts=myFormulaSpec[[All,1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]};

	(* get the formula amounts converted to mass whenever possible (i.e., if we have volume and density); we need this for comparing whether an existing stock solution already exists *)
	componentMassAmounts = MapThread[
		Function[{componentPacket, componentAmount},
			If[VolumeQ[componentAmount] && DensityQ[Lookup[componentPacket, Density]],
				componentAmount * Lookup[componentPacket, Density],
				componentAmount
			]
		],
		{myFormulaSpec[[All, 2]], componentAmounts}
	];

	(* we download the component object and state in one download call *)
	{componentTuples, solventTuple}=Quiet[
		Download[
			{
				myFormulaSpec[[All, 2]],
				ToList[mySolvent]
			},
			{
				{Object, State, Sterile},
				{Object, Sterile}
			}
		],
		{Download::FieldDoesNotExist}
	];

	components = componentTuples[[All, 1]];
	componentsStates = componentTuples[[All, 2]];
	componentsSteriles = componentTuples[[All, 3]];

	(* generate the full type we're going to make; standard is a subtype of StockSolution so needs to be handled a little differently *)
	newModelType = If[MatchQ[Lookup[resolvedOptionsNoAmbient,Type], Standard],
		Model[Sample, StockSolution, Standard],
		Model[Sample, Lookup[resolvedOptionsNoAmbient,Type]]
	];

	(* we need to find all the AlternativePreparations of the stock solution we are making
	 	Search is rather a bore and doesn't let you use just one And to see if a Formula has model A AND model B; use map-thread search to do this in one db hit;
		include all notebooks of the "author" (either the $PersonID, or, if we're in Engine, the root prot author) and public stuff *)
	altPrepSearchConditions=And[
		Field[Formula[[2]]]==#,
		If[MatchQ[mySolvent,ObjectP[]],
			FillToVolumeSolvent==Download[mySolvent,Object],
			FillToVolumeSolvent==Null
		],
		(* just in case somehow we got no notebooks *)
		If[Not[MatchQ[myAuthorNotebooks,{ObjectP[]..}]],
			Or[
				Notebook==Null
			],
			Or[
				Notebook==Alternatives@@myAuthorNotebooks,
				Notebook==Null
			]
		],
		Deprecated!=True,
		If[MatchQ[$StockSolutionUnitTestFilterOutNewlyCreatedObjects, True],
			(DateCreated<(Now-48Hour) || DateCreated==Null),
			True
		]
	]&/@components;

	(* do the Search for the solutions that have the same formula length and solvent as the one we're gonna upload; if we intersect, we get the solutions
	 	that have EXACTLY the same components, which we also want as a start point for even considering something as an alternative prep;
		the Length part of the query is particular narsty and likes to evaluate; with it in;
		TODO can this be done in one Search? the length query doesn't play nice with mapthread *)

	sameFormulaComponentModels=Which[
		MatchQ[$StockSolutionUnitTestSearchName, _String] && MatchQ[$StockSolutionUnitTestFilterOutNewlyCreatedObjects, True],
			Block[{$RequiredSearchName=$StockSolutionUnitTestSearchName},
				Intersection@@Join[
					{
						With[
							{formulaLength=Length[myFormulaSpec]},
							Search[newModelType,Length[Formula]==formulaLength&&Deprecated!=True&&(DateCreated<(Now-48Hour) || DateCreated==Null)]
						]
					},
					Search[ConstantArray[newModelType,Length[altPrepSearchConditions]],Evaluate@altPrepSearchConditions]
				]
			],
		MatchQ[$StockSolutionUnitTestSearchName, _String],
			Block[{$RequiredSearchName=$StockSolutionUnitTestSearchName},
				Intersection@@Join[
					{
						With[
							{formulaLength=Length[myFormulaSpec]},
							Search[newModelType,Length[Formula]==formulaLength&&Deprecated!=True]
						]
					},
					Search[ConstantArray[newModelType,Length[altPrepSearchConditions]],Evaluate@altPrepSearchConditions]
				]
			],
		MatchQ[$StockSolutionUnitTestFilterOutNewlyCreatedObjects, True],
			Intersection@@Join[
				{
					With[
						{formulaLength=Length[myFormulaSpec]},
						Search[newModelType,Length[Formula]==formulaLength&&Deprecated!=True&&(DateCreated<(Now-48Hour) || DateCreated==Null)]
					]
				},
				Search[ConstantArray[newModelType,Length[altPrepSearchConditions]],Evaluate@altPrepSearchConditions]
			],
		True,
			Intersection@@Join[
				{
					With[
						{formulaLength=Length[myFormulaSpec]},
						Search[newModelType,Length[Formula]==formulaLength&&Deprecated!=True]
					]
				},
				Search[ConstantArray[newModelType,Length[altPrepSearchConditions]],Evaluate@altPrepSearchConditions]
			]
	];

	(* need to actually download from these search results to see if they are indeed the same RATIO in addition to having the same exact components;
	 	also, since we have the behavior of returning an existing model if it's an EXACT match across all prep fields, gotta download those too *)
	sameFormulaComponentDownloadValues = Quiet[Download[
		sameFormulaComponentModels,
		{
			Packet[
				Formula, FillToVolumeSolvent, TotalVolume, MixUntilDissolved, Preparable,
				MixTime, MaxMixTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes,
				NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
				MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,
				FilterMaterial, FilterSize,
				IncubationTime, IncubationTemperature,
				OrderOfOperations, Autoclave, AutoclaveProgram,
				FillToVolumeMethod, UnitOperations, TransportTemperature, PrepareInResuspensionContainer,
				TransportTemperature, PostAutoclaveMixUntilDissolved,
				PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixType,
				PostAutoclaveMixer, PostAutoclaveMixRate, PostAutoclaveNumberOfMixes,
				PostAutoclaveMaxNumberOfMixes, PostAutoclaveIncubationTime,
				PostAutoclaveIncubationTemperature,
				Expires, ShelfLife, UnsealedShelfLife
			],
			Packet[Formula[[All, 2]][Density]]
		}
	], {Download::FieldDoesntExist}];
	{sameFormulaComponentModelPacketsWithObjects, sameFormulaComponentComponentModelPackets} = If[MatchQ[sameFormulaComponentDownloadValues, {}],
		{{}, {}},
		Transpose[sameFormulaComponentDownloadValues]
	];

	(* convert the formula to be all mass, if possible (i.e., we have a density and were provided a volume) *)
	massFormulas = MapThread[
		Function[{normalFormula, componentPackets},

			(* map over each component; if we have a liquid and a density, convert that volume to a mass *)
			MapThread[
				Function[{formulaEntry, componentPacket},

					If[VolumeQ[formulaEntry[[1]]] && DensityQ[Lookup[componentPacket, Density]],
						{formulaEntry[[1]] * Lookup[componentPacket, Density], formulaEntry[[2]]},
						formulaEntry
					]
				],
				{normalFormula, componentPackets}
			]
		],
		{Lookup[sameFormulaComponentModelPacketsWithObjects, Formula, {}], sameFormulaComponentComponentModelPackets}
	];

	(* identify bona-fide alternative preparations; formula ratios need to be the same as new formula *)
	(* also need ALL prep conditions to be the same; really, the only case where we even find any of these is if the Name is different but everything else is the same *)
	alternativePreparationPackets=MapThread[
		Function[{possibleModelPacket, massFormula},
			Module[{possibleFormulaAmounts,providedAmountsWTotalVolume,
				formulaComponentRatios, equalRatios, allPrepConditionsSample},

				(* pull out the ordered amounts from the possible formula; CRITICAL, add the solvent total volume also for ratio comparison *)
				(* need to dot his Unitless[x, Unit] shenanigans because the formula could have been specified as a 4 Unit or just 4 and we need to compare like with like *)
				possibleFormulaAmounts=If[MatchQ[Lookup[possibleModelPacket,FillToVolumeSolvent],ObjectP[]],
					Append[massFormula[[All,1]],Lookup[possibleModelPacket,TotalVolume]],
					massFormula[[All,1]]
				] /. {x:UnitsP[Unit] :> Unitless[x, Unit]};

				(* make sure to add the solvent amount to our provided formula too *)
				(* this is only if we have a solvent; remember, the TotalVolume _can_ be specified without a FillToVolumeSolvent (mainly only when calling USSM from ExperimentStockSolution) *)
				(* need to dot his Unitless[x, Unit] shenanigans because the formula could have been specified as a 4 Unit or just 4 and we need to compare like with like *)
				providedAmountsWTotalVolume = If[MatchQ[myFinalVolume, VolumeP] && Not[NullQ[mySolvent]],
					Append[componentMassAmounts, myFinalVolume],
					componentMassAmounts
				] /. {x:UnitsP[Unit] :> Unitless[x, Unit]};

				(* take the ratios of each component amount in the provided formula to the component amounts in the possible formula;
				 	the above sorting by model ensures we're in the right order*)
				formulaComponentRatios=(providedAmountsWTotalVolume/possibleFormulaAmounts);

				(* figure out if the formulas are the same (but have different absolute amounts), then the ratios for each component will all agree *)
				(* make sure that we are actually comparing like units though; if we're not then they can't be the same because then we're de-facto saying {{1 Gram, Model[Sample, "Milli-Q water"]}, {1 Gram, Model[Sample, "Methanol"]}} is the same ratio as {{1 Milliliter, Model[Sample, "Milli-Q water"]}, {1 Milliliter, Model[Sample, "Methanol"]}} which we can't assume because of densities *)
				(* note that the above case we can just get around via converting with densities.  But if that is not possible because we don't know the density, this will make sure we assume that all mass-to-volume comparisons are always apples-to-oranges and thus must be different *)
				equalRatios = Quiet[Check[Equal@@formulaComponentRatios && MatchQ[formulaComponentRatios, {NumberP..}], False]];

				(* figure out if all the other prep conditions are _also_ the same *)
				allPrepConditionsSample = And[
					(* NOTE: Null is downloaded as {}. *)
					Download[Lookup[possibleModelPacket, FillToVolumeSolvent], Object] === Download[mySolvent, Object],
					Lookup[possibleModelPacket, FillToVolumeMethod] === Lookup[resolvedOptionsNoAmbient, FillToVolumeMethod],

					(* mix options *)
					(* need to use TrueQ on both sides because a Null and False are the same here *)
					TrueQ[Lookup[possibleModelPacket, MixUntilDissolved]] === TrueQ[Lookup[resolvedOptionsNoAmbient, MixUntilDissolved]],
					Lookup[possibleModelPacket, MixType] === Lookup[resolvedOptionsNoAmbient, MixType],
					Download[Lookup[possibleModelPacket, Mixer], Object] === Download[Lookup[resolvedOptionsNoAmbient, Mixer], Object],
					(* need to use TrueQ around the whole thing because we're using == which we have to use for numbers/units *)
					TrueQ[Lookup[possibleModelPacket, MixTime] == Lookup[resolvedOptionsNoAmbient, MixTime]],
					TrueQ[Lookup[possibleModelPacket, MaxMixTime] == Lookup[resolvedOptionsNoAmbient, MaxMixTime]],
					TrueQ[Lookup[possibleModelPacket, MixRate] == Lookup[resolvedOptionsNoAmbient, MixRate]],
					TrueQ[Lookup[possibleModelPacket, NumberOfMixes] == Lookup[resolvedOptionsNoAmbient, NumberOfMixes]],
					TrueQ[Lookup[possibleModelPacket, MaxNumberOfMixes] == Lookup[resolvedOptionsNoAmbient, MaxNumberOfMixes]],

					(* pHing options *)
					TrueQ[Lookup[possibleModelPacket, NominalpH] == Lookup[resolvedOptionsNoAmbient, NominalpH]],
					TrueQ[Lookup[possibleModelPacket, MinpH] == Lookup[resolvedOptionsNoAmbient, MinpH]],
					TrueQ[Lookup[possibleModelPacket, MaxpH] == Lookup[resolvedOptionsNoAmbient, MaxpH]],
					Download[Lookup[possibleModelPacket, pHingAcid], Object] === Download[Lookup[resolvedOptionsNoAmbient, pHingAcid], Object],
					Download[Lookup[possibleModelPacket, pHingBase], Object] === Download[Lookup[resolvedOptionsNoAmbient, pHingBase], Object],

					TrueQ[Lookup[possibleModelPacket, MaxNumberOfpHingCycles] == Lookup[resolvedOptionsNoAmbient, MaxNumberOfpHingCycles]],
					TrueQ[Lookup[possibleModelPacket, MaxpHingAdditionVolume] == Lookup[resolvedOptionsNoAmbient, MaxpHingAdditionVolume]],
					TrueQ[Lookup[possibleModelPacket, MaxAcidAmountPerCycle] == Lookup[resolvedOptionsNoAmbient, MaxAcidAmountPerCycle]],
					TrueQ[Lookup[possibleModelPacket, MaxBaseAmountPerCycle] == Lookup[resolvedOptionsNoAmbient, MaxBaseAmountPerCycle]],

					TrueQ[Lookup[possibleModelPacket, TransportTemperature]==Lookup[resolvedOptionsNoAmbient, TransportTemperature]],

					(* PrepareInResuspensionContainer: Null is like False *)
					TrueQ[Lookup[possibleModelPacket, PrepareInResuspensionContainer]]===TrueQ[TrueQ[Lookup[resolvedOptionsNoAmbient, PrepareInResuspensionContainer]]],

					(* filter options *)
					Lookup[possibleModelPacket, FilterMaterial] === Lookup[resolvedOptionsNoAmbient, FilterMaterial],
					TrueQ[Lookup[possibleModelPacket, FilterSize] == Lookup[resolvedOptionsNoAmbient, FilterSize]],

					(* incubation options *)
					TrueQ[Lookup[possibleModelPacket, IncubationTime] == Lookup[resolvedOptionsNoAmbient, IncubationTime]],
					TrueQ[Lookup[possibleModelPacket, IncubationTemperature] == Lookup[resolvedOptionsNoAmbient, IncubationTemperature]],

					(* other preparation options *)
					(* having this Or call ensures that we don't need to back populate everything that doesn't have Preparable populated, but if it is populated it needs to match *)
					Or[
						NullQ[Lookup[possibleModelPacket, Preparable]],
						Lookup[possibleModelPacket, Preparable] === Lookup[resolvedOptionsNoAmbient, Preparable]
					],

					(* Expiration options *)
					Lookup[possibleModelPacket, Expires] === Lookup[resolvedOptionsNoAmbient, Expires],
					TrueQ[Lookup[possibleModelPacket, ShelfLife] == Lookup[resolvedOptionsNoAmbient, ShelfLife]],
					TrueQ[Lookup[possibleModelPacket, UnsealedShelfLife] == Lookup[resolvedOptionsNoAmbient, UnsealedShelfLife]],

					(* Autoclaving *)
					TrueQ[Lookup[possibleModelPacket, Autoclave]] === TrueQ[Lookup[resolvedOptionsNoAmbient, Autoclave]],
					Lookup[possibleModelPacket, AutoclaveProgram] === Lookup[resolvedOptionsNoAmbient, AutoclaveProgram],

					(* PostAutoclave stuff *)
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveMixUntilDissolved]] === TrueQ[Lookup[resolvedOptionsNoAmbient, PostAutoclaveMixUntilDissolved]],
					Lookup[possibleModelPacket, PostAutoclaveMixType] === Lookup[resolvedOptionsNoAmbient, PostAutoclaveMixType],
					Download[Lookup[possibleModelPacket, Mixer], Object] === Download[Lookup[resolvedOptionsNoAmbient, Mixer], Object],
					(* need to use TrueQ around the whole thing because we're using == which we have to use for numbers/units *)
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveMixTime] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveMixTime]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveMaxMixTime] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveMaxMixTime]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveMixRate] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveMixRate]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveNumberOfMixes] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveNumberOfMixes]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveMaxNumberOfMixes] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveMaxNumberOfMixes]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveIncubationTime] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveIncubationTime]],
					TrueQ[Lookup[possibleModelPacket, PostAutoclaveIncubationTemperature] == Lookup[resolvedOptionsNoAmbient, PostAutoclaveIncubationTemperature]]
				];

				(* if the formulas are the same (but different absolute amounts), then the ratios for each component will all agree *)
				If[equalRatios && allPrepConditionsSample,
					possibleModelPacket,
					Nothing
				]
			]
		],
		{sameFormulaComponentModelPacketsWithObjects, massFormulas}
	];

	(* format the provided formula to be ready for uploading; make sure to handle tablet counts (these are legit if we made it here, early-returned if not) *)
	uploadReadyFormula=MapThread[
		{
			If[MatchQ[Unitless[#1],#1],
				#1*Unit,
				#1
			],
			Link[#2]
		}&,
		{componentAmounts,components}
	];

	(* make a quick function that looks up an option value from the resolved options and makes a rule for the field;
	 	if option value is Boolean, make False be Null *)
	fieldRule[myFieldName_Symbol]:=Module[{optionValue, resolvedExtinctionCoefficients},

		(* get the option value for this field name *)
		optionValue=Lookup[resolvedOptionsNoAmbient,myFieldName];

		(* convert the extinction coefficient to the named multiple it needs to be *)
		resolvedExtinctionCoefficients = If[MatchQ[myFieldName, ExtinctionCoefficients] && Not[NullQ[optionValue]],
			Map[
				<|Wavelength -> #[[1]], ExtinctionCoefficient -> #[[2]]|>&,
				optionValue
			],
			{}
		];


		(* if the option value is specifically False, make it Null; if it's a multiple field (currently only ExtinctionCoefficients) be sure to add replace *)
		If[MatchQ[myFieldName, ExtinctionCoefficients],
			Replace[ExtinctionCoefficients]->resolvedExtinctionCoefficients,
			myFieldName->Which[
				MatchQ[optionValue,False], Null,
				MatchQ[optionValue,ObjectP[]], Link[optionValue],
				True, optionValue
			]
		]
	];

	(* figure out what the state of the new stock solution is going to be *)
	state = Which[
		(*If all components are solid, then it is a solid*)
		NullQ[mySolvent] && MatchQ[componentsStates, {Solid..}], Solid,

		(*In case that any State field is Null, if any component is liquid, then it is a liquid*)
		NullQ[mySolvent] && MemberQ[componentsStates, Liquid], Liquid,

		(*In case that any State field is Null, if all the component amounts are mass, then it is a solid*)
		NullQ[mySolvent] && MatchQ[componentAmounts, {MassP..}], Solid,

		(*For media: if MediaPhase is specified, use it*)
		!MatchQ[Lookup[myResolvedOptions,MediaPhase], Null|Automatic], Lookup[myResolvedOptions,MediaPhase],

		(*Otherwise, it is a liquid*)
		True, Liquid
	];

	(* figure out whether the new stock solution is sterile based on Autoclave and Filtersize options, or all components are sterile *)
	(* If we have a solvent, check if it is sterile. If theres no solvent, put true as it does not affect final sterility *)
	solventSterile = If[MatchQ[solventTuple,{{ObjectP[],_}}],
		solventTuple[[1,2]],
		True
	];

	resolvedSterile = If[Or[
		TrueQ[Lookup[resolvedOptionsNoAmbient, Autoclave]],
		MatchQ[Lookup[resolvedOptionsNoAmbient, FilterSize], LessEqualP[0.22 * Micrometer]],
		AllTrue[Flatten[{componentsSteriles,solventSterile}],TrueQ]
	],
		(* The stock solution is sterile if it is autoclaved, or filtered with pores at or below 0.22 microns *)
		True,
		Null
	];

	(* figure out whether the new stock solution requires AsepticHandling based on Sterile options *)
	resolvedAsepticHandling = If[TrueQ[resolvedSterile],
		(* The stock solution is AsepticHandling->True if it is sterile *)
		True,
		Null
	];


	(* prepare the upload packet for the new stock solution *)
	newStockSolutionPacket=KeyDrop[<|Join[
		{
			(* auto-added *)
			Object->CreateID[newModelType],
			Type->newModelType,
			Replace[Authors]->Link[{myAuthor}],
			State->state,
			MSDSRequired->False,
			BiosafetyLevel->"BSL-1",

			(* based on inputs *)
			Replace[Formula]->uploadReadyFormula,
			PreparationType->Formula,
			FillToVolumeSolvent->Link[mySolvent],
			TotalVolume->myFinalVolume,
			FillToVolumeMethod->Lookup[myResolvedOptions,FillToVolumeMethod],

			Replace[Composition]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,Composition],_List],
				({#[[1]],If[MatchQ[#[[2]],ObjectP[]],Link[#[[2]]],#[[2]]]}&)/@Lookup[resolvedOptionsNoAmbient,Composition],
				Lookup[resolvedOptionsNoAmbient,Composition]
			],

			Replace[OrderOfOperations] -> Lookup[myResolvedOptions,OrderOfOperations],

			Replace[UnitOperations] ->{},

			Replace[Autoclave] -> Lookup[myResolvedOptions,Autoclave],
			Replace[AutoclaveProgram] -> Lookup[myResolvedOptions,AutoclaveProgram],

			(* --- based on options and not EXACT match betwen field name and option --- *)
			Replace[Synonyms]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,Synonyms],{_String..}],
				Lookup[resolvedOptionsNoAmbient,Synonyms],
				{}
			],
			Replace[IncompatibleMaterials]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,IncompatibleMaterials],Null],
				{None},
				ToList[Lookup[resolvedOptionsNoAmbient,IncompatibleMaterials]]
			],
			DefaultStorageCondition->Link[myDefaultStorageConditionObject],
			Replace[VolumeIncrements]->Lookup[resolvedOptionsNoAmbient, VolumeIncrements],

			(* here we want False instead of Null for Preparable *)
			Preparable -> Lookup[resolvedOptionsNoAmbient, Preparable],

			(* If we're making a StockSolution (and not a Matrix/Media), provide the resolved PreferredContainers *)
			If[MatchQ[newModelType,TypeP[Model[Sample, StockSolution]]],
				Replace[PreferredContainers]->Link[Lookup[resolvedOptionsNoAmbient,PreferredContainers]],
				Nothing
			],

			(* If we're making a media, put in GellingAgents here *)
			If[MatchQ[newModelType,TypeP[Model[Sample, Media]]],
				Replace[GellingAgents] -> Lookup[resolvedOptionsNoAmbient, GellingAgents]/.{{x_, y:ObjectP[{Object[Sample],Model[Sample]}]}:>{x,Link[y]},None->Null,{None}->Null,Automatic->Null},
				Nothing
			],

			Replace[HeatSensitiveReagents] -> Lookup[resolvedOptionsNoAmbient, HeatSensitiveReagents]/.{x:ObjectP[{Object[Sample],Model[Sample]}]:>Link[x],None->Null,{None}->Null,Automatic->Null},


			(* If we're making a Media, set UsedAsMedia to True *)
			If[MatchQ[newModelType,TypeP[Model[Sample,Media]]],
				UsedAsMedia->True,
				Nothing
			],

			(* can't use boolean Null-is-False thing, this field is REQUIRED either way *)
			Expires->Lookup[resolvedOptionsNoAmbient,Expires],
			Replace[AlternativePreparations]->Link[Lookup[alternativePreparationPackets,Object,{}],AlternativePreparations],
			(* currently we don't have a way to mark something as Pyrophoric, possibly (?) by design since we don't have a reliable way to store it *)
			(* also need to directly specify this because ValidStorageConditionQ needs it *)
			Pyrophoric -> Null,
			(* need to specify this directly because PreferredContainer needs it. Also need to resolve it correctly based on Autoclave and FilterSize *)
			Sterile -> resolvedSterile,
			AsepticHandling -> resolvedAsepticHandling
		},

		(* for ALL of these options, the field name is the same as the option name; use a helper to churn out rules  *)
		fieldRule/@ {
			Name, MixUntilDissolved, MixTime, MaxMixTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes,
			NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,
			FilterMaterial, FilterSize,
			LightSensitive, ShelfLife, UnsealedShelfLife, TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming,
			IncubationTime, IncubationTemperature,
			DiscardThreshold,
			UltrasonicIncompatible, CentrifugeIncompatible,
			Resuspension, PrepareInResuspensionContainer,
			PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixType, PostAutoclaveMixer,
			PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes, PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature
		}
	]|>,
		If[MatchQ[newModelType, Model[Sample, StockSolution]], Nothing, PrepareInResuspensionContainer]];

	(* see if one of the existing alternative preparation packets is an EXACT prep match; if we are allowed to return an existing model, that is;
	 	if we get the template model back, preferentially return that *)


	(* list all the field names that we want to check *)
	checkFieldsList=If[MatchQ[newModelType, Model[Sample, StockSolution]],
		{MixUntilDissolved,MixTime,MaxMixTime,MixType,Mixer,MixRate,NumberOfMixes, MaxNumberOfMixes,
		NominalpH,MinpH,MaxpH,pHingAcid,pHingBase,
		FilterMaterial,FilterSize,
		IncubationTime,IncubationTemperature,PrepareInResuspensionContainer,TransportTemperature,PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime,
			PostAutoclaveMaxMixTime, PostAutoclaveMixType, PostAutoclaveMixer,PostAutoclaveMixRate, PostAutoclaveNumberOfMixes,
			PostAutoclaveMaxNumberOfMixes, PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature},
		{MixUntilDissolved,MixTime,MaxMixTime,MixType,Mixer,MixRate,NumberOfMixes, MaxNumberOfMixes,
			NominalpH,MinpH,MaxpH,pHingAcid,pHingBase,
			FilterMaterial,FilterSize,
			IncubationTime,IncubationTemperature,TransportTemperature,
			PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixType, PostAutoclaveMixer,
			PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes, PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature}
	];

	existingMatchingModel=If[myReturnExistingModelBool,
		Module[{fieldMatchesOptionQ,prepFieldsMatchQ,templateModel,allExactMatchPackets},

			(* write a helper that will check packet fields for a match *)
			fieldMatchesOptionQ[myFieldName_Symbol,myPacket:PacketP[]]:=Module[
				{fieldValue,fieldValueToCheck,optionValue,equivalenceFunction},

				(* get the field value from the packet *)
				fieldValue=Lookup[myPacket,myFieldName];

				(* prune the field value in a couple of cases; want object reference, or for certain option values, the field is Null if option is false  *)
				fieldValueToCheck=Which[
					MatchQ[fieldValue,ObjectP[]],
						Download[fieldValue,Object],
					(* this case is super weird; if we have resolved to Mix, we will have MixUntilDissolved as True/False;
					 	the field will have Null for False though, so in this specific case, prune it to be False *)
					And[
						MatchQ[myFieldName,MixUntilDissolved],
						NullQ[fieldValue],
						Lookup[resolvedOptionsNoAmbient,Mix]
					],
						False,
					(* another specific case for PrepareInResuspensionContainer: the field PrepareInResuspensionContainer can be Null, if the option is resolved to False. so in this specific case, prune it to be False to avoid creation of new model *)
					And[
						MatchQ[myFieldName,PrepareInResuspensionContainer],
						NullQ[fieldValue],
						MatchQ[Lookup[resolvedOptionsNoAmbient,PrepareInResuspensionContainer],False]
					],
						False,
					True,
						fieldValue
				];

				(* get the option value for the same field name *)
				optionValue=Lookup[resolvedOptionsNoAmbient,myFieldName];

				(* see if they're the same; use different equality functions depending on situation *)
				equivalenceFunction=Which[
					(* if at least one of the values is Null, use SameQ to ensure we evaluate; either they're not both Null, so def not the same, or they are, and it's fine *)
					MemberQ[{fieldValueToCheck,optionValue},Null],
						SameQ,
					(* okay so there are no Nulls; if one is a numeric or quantity, use Equal *)
					MatchQ[fieldValueToCheck,UnitsP[]],
						Equal,
					(* if both of the values are objects, need to use SameObjectQ *)
					MatchQ[{fieldValueToCheck,optionValue}, {ObjectP[], ObjectP[]}],
						SameObjectQ,
					(* okay otherwise we want a nice actual match, use MatchQ *)
					True,
						MatchQ
				];

				(* use the equivalence function determined above to asses sameness for the field/option value *)
				equivalenceFunction[fieldValueToCheck,optionValue]
			];

			(* write a helper that checks the right list of fields for a given packet *)
			prepFieldsMatchQ[myPossibleMatchingPacket:PacketP[]]:=And@@(fieldMatchesOptionQ[#,myPossibleMatchingPacket]&/@checkFieldsList);

			(* get our template model, and also all of our alt prep packets that are exact prep matches *)
			templateModel=Download[Lookup[resolvedOptionsNoAmbient,StockSolutionTemplate],Object];
			allExactMatchPackets=Select[alternativePreparationPackets,prepFieldsMatchQ];

			(* determine if we have an existing matching model, with template pref *)
			Which[
				(* if the template is still an exact match, nice! return it preferentially *)
				MemberQ[Lookup[allExactMatchPackets,Object,{}],templateModel], templateModel,

				(* we got some matchers; just grab the first? TODO is this dumb? *)
				MatchQ[allExactMatchPackets,{PacketP[]..}], Lookup[First[allExactMatchPackets],Object],

				(* otherwise we got nada; just return a Null *)
				True, Null
			]
		],
		Null
	];

	(* -- New model creation warning -- *)

	(* We will throw the warning, only if we are using template Model overload. The assumption is that the user does want to create new model if they give formula. *)

	(* Throw warning only if, *)
	(* 1. the user uses model overload for UploadStockSolution *)
	(* 2. a specified Name is NOT given *)
	gatherTests=MemberQ[ToList[Lookup[resolvedOptionsNoAmbient, Output]], Tests];

	fastTrack=Lookup[resolvedOptionsNoAmbient, FastTrack];

	(* if we are creating new model, keep track the potential mismatched fields when comparing to the input model *)
	{modelTemplateInputObject,mismatchFields}=If[myReturnExistingModelBool&&MatchQ[myModelTemplateInput,ObjectP[]],
		Module[{fieldMismatchesOptionQ,modelTemplateInputPacket,prepFieldsMismatchTracker},

			(* write a helper that will check potential mismatched fields in the template model *)
			fieldMismatchesOptionQ[myFieldName_Symbol,myPacket:PacketP[]]:=Module[
				{fieldValue,fieldValueToCheck,optionValue,equivalenceFunction},

				(* get the field value from the packet *)
				fieldValue=Lookup[myPacket,myFieldName];

				(* prune the field value in a couple of cases; want object reference, or for certain option values, the field is Null if option is false  *)
				fieldValueToCheck=Which[
					MatchQ[fieldValue,ObjectP[]],
					Download[fieldValue,Object],
					(* this case is super weird; if we have resolved to Mix, we will have MixUntilDissolved as True/False;
					 	the field will have Null for False though, so in this specific case, prune it to be False *)
					And[
						MatchQ[myFieldName,MixUntilDissolved],
						NullQ[fieldValue],
						Lookup[resolvedOptionsNoAmbient,Mix]
					],
					False,
					True,
					fieldValue
				];

				(* get the option value for the same field name *)
				optionValue=Lookup[resolvedOptionsNoAmbient,myFieldName];

				(* see if they're the same; use different equality functions depending on situation *)
				equivalenceFunction=Which[
					(* if at least one of the values is Null, use SameQ to ensure we evaluate; either they're not both Null, so def not the same, or they are, and it's fine *)
					MemberQ[{fieldValueToCheck,optionValue},Null],
					SameQ,
					(* okay so there are no Nulls; if one is a numeric or quantity, use Equal *)
					MatchQ[fieldValueToCheck,UnitsP[]],
					Equal,
					(* if both of the values are objects, need to use SameObjectQ *)
					MatchQ[{fieldValueToCheck,optionValue}, {ObjectP[], ObjectP[]}],
					SameObjectQ,
					(* okay otherwise we want a nice actual match, use MatchQ *)
					True,
					MatchQ
				];

				(* use the equivalence function determined above to asses DIFFERENCE for the field/option value *)
				Not[equivalenceFunction[fieldValueToCheck,optionValue]]
			];

			(* download our template model input packet *)
			(* we cannot assume it is included in the sameFormulaComponentModelPackets because of the same components during the search? The assumption is not valid somehow in a unit test with input model Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water"]. *)
			modelTemplateInputPacket=Quiet[Download[myModelTemplateInput,
				Packet[
					Formula,FillToVolumeSolvent,TotalVolume,MixUntilDissolved,Preparable,
					MixTime,MaxMixTime,MixType,Mixer,MixRate,NumberOfMixes, MaxNumberOfMixes,
					NominalpH,MinpH,MaxpH,pHingAcid,pHingBase,
					MaxNumberOfpHingCycles,MaxpHingAdditionVolume,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle,
					FilterMaterial,FilterSize,
					IncubationTime,IncubationTemperature,
					OrderOfOperations,Autoclave,AutoclaveProgram,
					FillToVolumeMethod,UnitOperations,PrepareInResuspensionContainer
				]
			], {Download::FieldDoesntExist}];

			(* write a helper that tracks the mismatched fields in our template model input packet *)
			prepFieldsMismatchTracker[myMatchingPacket:PacketP[]]:=(
				If[fieldMismatchesOptionQ[#,myMatchingPacket],
					#,
					Nothing
				]&/@checkFieldsList);

			(* return potential mismatch fields *)
			{Lookup[modelTemplateInputPacket,Object],prepFieldsMismatchTracker[modelTemplateInputPacket]}
		],
		{Null,{}}
	];

	If[!fastTrack,
		Module[{newModelWarningQ, warning},

			(* set a boolean indicating if we want to throw a warning when creating new model *)
			newModelWarningQ = And[
				MatchQ[myModelTemplateInput,ObjectP[]], (* Model input overload *)
				myReturnExistingModelBool, (* No specified name *)
				Not[MatchQ[existingMatchingModel,ObjectReferenceP[]]] (* Creating new model *)
			];

			(* make a warning for the situation *)
			warning = If[gatherTests,
				Warning["When using template model input , a new model is created because the options " <> ToString[mismatchFields] <>" are different from the ones in the template " <> ToString[myModelTemplateInput] <> ".",
					newModelWarningQ,
					False
				],
				Nothing
			];

			(* throw message warning *)
			If[!gatherTests && newModelWarningQ,
				Message[Warning::NewModelCreation, mismatchFields, myModelTemplateInput,Lookup[newStockSolutionPacket,Object]]
			];

			(* return the warning *)
			{warning}
		],

		(* on fast track, blast ahead *)
		{}
	];

	(* -- Existing model usage warning -- *)
	(* We will throw the warning, only if we are using template Model overload with some specified options, and an alternative Model will be used instead. In this case, the alternative Model fulfills the input template Model plus all the specified options. *)

	(* Throw warning only if, *)
	(* 1. the user uses model overload for UploadStockSolution *)
	(* 2. a specified Name is NOT given *)
	(* 3&4. the existingMatchingModel exists and it is NOT the input template Model *)

	If[!fastTrack,
		Module[{existingModelWarningQ, warning},

			(* set a boolean indicating if we want to throw a warning when an existing model is used instead *)
			existingModelWarningQ = And[
				MatchQ[myModelTemplateInput,ObjectP[]], (* Model input overload *)
				myReturnExistingModelBool, (* No specified name *)
				MatchQ[existingMatchingModel,ObjectReferenceP[]], (* Creating new model *)
				!MatchQ[existingMatchingModel,modelTemplateInputObject] (* The existingMatchingModel is not the same as the input template Model *)
			];

			(* make a warning for the situation *)
			warning = If[gatherTests,
				Warning["When using template model input, the existing model " <> ToString[existingMatchingModel] <> " fulfills the template model input " <> ToString[modelTemplateInputObject] <>  " with specified options, and the existing model " <> ToString[existingMatchingModel] <> " will be used as the alternative preparation template for this stock solution.",
					existingModelWarningQ,
					False
				],
				Nothing
			];

			(* throw message warning *)
			If[!gatherTests && existingModelWarningQ,
				Message[Warning::ExistingModelReplacesInput, existingMatchingModel, modelTemplateInputObject]
			];

			(* return the warning *)
			{warning}
		],

		(* on fast track, blast ahead *)
		{}
	];

	(* either return the new packet/object (depending on Upload) if we don't have an existing, or just return the existing if we have it *)
	If[MatchQ[existingMatchingModel,ObjectReferenceP[]],
		existingMatchingModel,
		If[Lookup[resolvedOptionsNoAmbient,Upload],
			Upload[newStockSolutionPacket],
			newStockSolutionPacket
		]
	]
];


(*
	PACKET CREATOR - unitOperations overload
		- relies on unitOps and resolved options
		- DOES NOT look for an existing model with the same prep parameters
		*)
newStockSolution[
	myUnitOperations:({SamplePreparationP..}|Null),
	myDefaultStorageConditionObject:ObjectReferenceP[Model[StorageCondition]],
	myReturnExistingModelBool:BooleanP,
	myModelTemplateInput:(ObjectP[Model[Sample]]|Null),
	myAuthor:ObjectP[Object[User]],
	myAuthorNotebooks:{ObjectReferenceP[Object[LaboratoryNotebook]]...},
	myResolvedOptions:{_Rule..},
	mySampleSimulation_Simulation
]:=Module[
	{newModelType,simulatedSampleLookupPackets,simulatedSampleCompositionComponents,altPrepSearchConditions,
		sameFormulaComponentModels,sameFormulaComponentModelPackets,alternativePreparationPackets,fieldRule,
		checkFieldsList,newStockSolutionPacket,existingMatchingModel,templateModel,
		upload, resolvedOptionsNoAmbient, state, resolvedSterile, resolvedAsepticHandling,
		gatherTests, fastTrack,modelTemplateInputObject,mismatchFields},

	(* pull out the Upload option *)
	upload = Lookup[myResolvedOptions,Upload];

	(* change all Ambients into Null right away since it messes with fields *)
	resolvedOptionsNoAmbient = myResolvedOptions /. {Ambient -> Null};

	(* generate the full type we're going to make; standard is a subtype of StockSolution so needs to be handled a little differently *)
	newModelType = If[MatchQ[Lookup[resolvedOptionsNoAmbient,Type], Standard],
		Model[Sample, StockSolution, Standard],
		Model[Sample, Lookup[resolvedOptionsNoAmbient,Type]]
	];

	(* grab the simulated sample out of simulation and make a packet for lookups *)
	simulatedSampleLookupPackets = Module[{labelOfInterest,simulatedContainer,simulatedSample,packets, updatedSimulation},
		(*get the first label container unit operation,it should be the very first*)
		labelOfInterest = First[Cases[myUnitOperations, _LabelContainer]][Label];
		(*figure out what is the container that was simulated for it and whats in it*)
		simulatedContainer =Lookup[Lookup[First[mySampleSimulation], Labels],labelOfInterest];
		updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, mySampleSimulation];
		(*get the sample in that container and its volume*)
		simulatedSample =  Download[simulatedContainer, Contents[[1, 2]],Simulation -> updatedSimulation];
		(* This gives us all samples in the unitOperations. we're assuming the first one is the one we're interested in so will return that one only*)
		packets = Download[simulatedSample, All, Simulation->updatedSimulation]
	];

	simulatedSampleCompositionComponents = Lookup[simulatedSampleLookupPackets, Composition][[All,2]];

	(* to look for alternative preps, we are going to search by length of UnitOps and then composition, then we will download whatever's left and match to out UnitOps
	Can't just search for unit ops directly because they are an Expression. and uploading wont help much either becuase they will just be different. so yea, this is what we need to do*)
	altPrepSearchConditions=And[
		Field[Composition[[2]]]==#,
		(* just in case somehow we got no notebooks *)
		If[Not[MatchQ[myAuthorNotebooks,{ObjectP[]..}]],
			Or[
				Notebook==Null
			],
			Or[
				Notebook==Alternatives@@myAuthorNotebooks,
				Notebook==Null
			]
		],
		Deprecated!=True
	]&/@simulatedSampleCompositionComponents;

	sameFormulaComponentModels=	Intersection@@Join[
		{
			With[
				{formulaLength=Length[myUnitOperations]},
				Search[newModelType,Length[UnitOperations]==formulaLength&&Deprecated!=True]
			]
		},
		Search[ConstantArray[newModelType,Length[simulatedSampleCompositionComponents]],Evaluate@altPrepSearchConditions]
	];

	(* Download to make sure it is indeed the same. Technically, it is enough for a label to be different to constitute
	a new StockSolution.  *)
	sameFormulaComponentModelPackets=Quiet[Download[sameFormulaComponentModels,
		Packet[
			Formula,FillToVolumeSolvent,TotalVolume,MixUntilDissolved,PreparationType,
			MixTime,MaxMixTime,MixType,Mixer,MixRate,NumberOfMixes, MaxNumberOfMixes,
			NominalpH,MinpH,MaxpH,pHingAcid,pHingBase,
			MaxNumberOfpHingCycles,MaxpHingAdditionVolume,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle,
			FilterMaterial,FilterSize,
			IncubationTime,IncubationTemperature,
			OrderOfOperations,Autoclave,AutoclaveProgram,
			FillToVolumeMethod,UnitOperations, TransportTemperature,PrepareInResuspensionContainer
		]
	], {Download::FieldDoesntExist}];

	(* identify bona-fide alternative preparations; technically, we could just check UnitOps and call it a day, but we need to make sure everything else is null so this is one way of doing it. *)
	(* also need ALL prep conditions to be the same (hopefully Null/False); really, the only case where we even find any of these is if the Name is different but everything else is the same *)
	alternativePreparationPackets=Map[
		Function[possibleModelPacket,
			Module[{unitOpsConditions, equalRatios, allPrepConditionsSample},

				(* check if the unit ops are the same *)
				unitOpsConditions = And[
					MatchQ[Lookup[possibleModelPacket, UnitOperations],myUnitOperations],
					(* accept Nulls in case they were not populated appropriately (since having primitives is essentailly a master switch *)
					MatchQ[Lookup[possibleModelPacket, PreparationType],UnitOperations|Null]
				];

				(* figure out if all the other prep conditions are _also_ the same *)
				allPrepConditionsSample = And[
					(* mix options *)
					(* need to use TrueQ on both sides because a Null and False are the same here *)
					TrueQ[Lookup[possibleModelPacket, MixUntilDissolved]] === TrueQ[Lookup[resolvedOptionsNoAmbient, MixUntilDissolved]],
					Lookup[possibleModelPacket, MixType] === Lookup[resolvedOptionsNoAmbient, MixType],
					Download[Lookup[possibleModelPacket, Mixer], Object] === Download[Lookup[resolvedOptionsNoAmbient, Mixer], Object],
					(* need to use TrueQ around the whole thing because we're using == which we have to use for numbers/units *)
					TrueQ[Lookup[possibleModelPacket, MixTime] == Lookup[resolvedOptionsNoAmbient, MixTime]],
					TrueQ[Lookup[possibleModelPacket, MaxMixTime] == Lookup[resolvedOptionsNoAmbient, MaxMixTime]],
					TrueQ[Lookup[possibleModelPacket, MixRate] == Lookup[resolvedOptionsNoAmbient, MixRate]],
					TrueQ[Lookup[possibleModelPacket, NumberOfMixes] == Lookup[resolvedOptionsNoAmbient, NumberOfMixes]],
					TrueQ[Lookup[possibleModelPacket, MaxNumberOfMixes] == Lookup[resolvedOptionsNoAmbient, MaxNumberOfMixes]],

					(* pHing options *)
					TrueQ[Lookup[possibleModelPacket, NominalpH] == Lookup[resolvedOptionsNoAmbient, NominalpH]],
					TrueQ[Lookup[possibleModelPacket, MinpH] == Lookup[resolvedOptionsNoAmbient, MinpH]],
					TrueQ[Lookup[possibleModelPacket, MaxpH] == Lookup[resolvedOptionsNoAmbient, MaxpH]],
					Download[Lookup[possibleModelPacket, pHingAcid], Object] === Download[Lookup[resolvedOptionsNoAmbient, pHingAcid], Object],
					Download[Lookup[possibleModelPacket, pHingBase], Object] === Download[Lookup[resolvedOptionsNoAmbient, pHingBase], Object],

					Lookup[possibleModelPacket, MaxNumberOfpHingCycles] === Lookup[resolvedOptionsNoAmbient, MaxNumberOfpHingCycles],
					Lookup[possibleModelPacket, MaxpHingAdditionVolume] === Lookup[resolvedOptionsNoAmbient, MaxpHingAdditionVolume],
					Lookup[possibleModelPacket, MaxAcidAmountPerCycle] === Lookup[resolvedOptionsNoAmbient, MaxAcidAmountPerCycle],
					Lookup[possibleModelPacket, MaxBaseAmountPerCycle] === Lookup[resolvedOptionsNoAmbient, MaxBaseAmountPerCycle],

					Lookup[possibleModelPacket, TransportTemperature]===Lookup[resolvedOptionsNoAmbient, TransportTemperature],

					(* PrepareInResuspensionContainer: Null is like False *)
					TrueQ[Lookup[possibleModelPacket, PrepareInResuspensionContainer]]===TrueQ[TrueQ[Lookup[resolvedOptionsNoAmbient, PrepareInResuspensionContainer]]],

					(* filter options *)
					Lookup[possibleModelPacket, FilterMaterial] === Lookup[resolvedOptionsNoAmbient, FilterMaterial],
					Lookup[possibleModelPacket, FilterSize] === Lookup[resolvedOptionsNoAmbient, FilterSize],

					(* incubation options *)
					TrueQ[Lookup[possibleModelPacket, IncubationTime] == Lookup[resolvedOptionsNoAmbient, IncubationTime]],
					TrueQ[Lookup[possibleModelPacket, IncubationTemperature] == Lookup[resolvedOptionsNoAmbient, IncubationTemperature]],

					(* Autoclaving *)
					TrueQ[Lookup[possibleModelPacket, Autoclave]] === TrueQ[Lookup[resolvedOptionsNoAmbient, Autoclave]],
					Lookup[possibleModelPacket, AutoclaveProgram] === Lookup[resolvedOptionsNoAmbient, AutoclaveProgram]
				];

				(* if the formulas are the same (but different absolute amounts), then the ratios for each component will all agree *)
				If[unitOpsConditions && allPrepConditionsSample,
					possibleModelPacket,
					Nothing
				]
			]
		],
		sameFormulaComponentModelPackets
	];

	(* make a quick function that looks up an option value from the resolved options and makes a rule for the field;
	 	if option value is Boolean, make False be Null *)
	fieldRule[myFieldName_Symbol]:=Module[{optionValue, resolvedExtinctionCoefficients},

		(* get the option value for this field name *)
		optionValue=Lookup[resolvedOptionsNoAmbient,myFieldName];

		(* convert the extinction coefficient to the named multiple it needs to be *)
		resolvedExtinctionCoefficients = If[MatchQ[myFieldName, ExtinctionCoefficients] && Not[NullQ[optionValue]],
			Map[
				<|Wavelength -> #[[1]], ExtinctionCoefficient -> #[[2]]|>&,
				optionValue
			],
			{}
		];

		(* if the option value is specifically False, make it Null; if it's a multiple field (currently only ExtinctionCoefficients) be sure to add replace *)
		If[MatchQ[myFieldName, Alternatives[ExtinctionCoefficients]],
			Replace[ExtinctionCoefficients]->resolvedExtinctionCoefficients,
			myFieldName->Which[
				MatchQ[optionValue,False], Null,
				MatchQ[optionValue,ObjectP[]], Link[optionValue],
				True, optionValue
			]
		]
	];

	(* figure out what the state of the new stock solution is going to be *)
	state = Which[
		(* If simulation has a state (it should) use it *)
		MatchQ[Lookup[simulatedSampleLookupPackets, State],Except[Null]], Lookup[simulatedSampleLookupPackets, State],

		(*Otherwise, it is a liquid*)
		True, Liquid
	];

	(* figure out whether the new stock solution is sterile based on Autoclave and Filtersize options, or if simulated sample is sterile *)
	resolvedSterile = If[Or[
		TrueQ[Lookup[myResolvedOptions, Autoclave]],
		MatchQ[Lookup[resolvedOptionsNoAmbient, FilterSize], LessEqualP[0.22 * Micrometer]],
		TrueQ[Lookup[simulatedSampleLookupPackets, Sterile]]
	],
		(* The stock solution is sterile if it is autoclaved, or filtered with pores at or below 0.22 microns *)
		True,
		Null
	];

	(* figure out whether the new stock solution requires AsepticHandling based on Sterile options *)
	resolvedAsepticHandling = If[TrueQ[resolvedSterile],
		(* The stock solution is AsepticHandling->True if it is sterile *)
		True,
		Null
	];

	(* prepare the upload packet for the new stock solution *)
	newStockSolutionPacket=KeyDrop[<|Join[
		{
			(* auto-added *)
			Object->CreateID[newModelType],
			Type->newModelType,
			Replace[Authors]->Link[{myAuthor}],
			State->state,
			MSDSRequired->False,
			BiosafetyLevel->Lookup[simulatedSampleLookupPackets, BiosafetyLevel],

			(* based on inputs *)
			Replace[Formula]->{},
			Replace[UnitOperations]->myUnitOperations,
			PreparationType->UnitOperations,
			FillToVolumeSolvent->Null,
			TotalVolume->Lookup[simulatedSampleLookupPackets, Volume],
			FillToVolumeMethod->Null,

			Replace[Composition]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,Composition],_List],
				{#[[1]], Link[#[[2]]]}&/@ Lookup[resolvedOptionsNoAmbient,Composition],
				Lookup[simulatedSampleLookupPackets, Composition]
			],
			Replace[OrderOfOperations] ->{},

			Replace[Autoclave] -> Lookup[myResolvedOptions,Autoclave],
			Replace[AutoclaveProgram] -> Lookup[myResolvedOptions,AutoclaveProgram],

			(* --- based on options and not EXACT match between field name and option --- *)
			Replace[Synonyms]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,Synonyms],{_String..}],
				Lookup[resolvedOptionsNoAmbient,Synonyms],
				{}
			],
			Replace[IncompatibleMaterials]->If[MatchQ[Lookup[resolvedOptionsNoAmbient,IncompatibleMaterials],ListableP[Null]],
				{None},
				ToList[Lookup[resolvedOptionsNoAmbient,IncompatibleMaterials]]
			],
			DefaultStorageCondition->Link[myDefaultStorageConditionObject],
			Replace[VolumeIncrements]->Lookup[resolvedOptionsNoAmbient, VolumeIncrements],

			(* here we want False instead of Null for Preparable *)
			Preparable -> Lookup[resolvedOptionsNoAmbient, Preparable],

			(* If we're making a StockSolution (and not a Matrix/Media), provide the resolved PreferredContainers *)
			If[MatchQ[newModelType,TypeP[Model[Sample, StockSolution]]],
				Replace[PreferredContainers]->Link[Lookup[resolvedOptionsNoAmbient,PreferredContainers]],
				Nothing
			],

			(* If we're making a Media, set UsedAsMedia to True *)
			If[MatchQ[newModelType,TypeP[Model[Sample,Media]]],
				UsedAsMedia->True,
				Nothing
			];

			(* can't use boolean Null-is-False thing, this field is REQUIRED either way *)
			Expires->Lookup[resolvedOptionsNoAmbient,Expires],
			(* no alternative preps for unit operations  *)
			Replace[AlternativePreparations]->{},
			(* currently we don't have a way to mark something as Pyrophoric, possibly (?) by design since we don't have a reliable way to store it *)
			(* also need to directly specify this because ValidStorageConditionQ needs it *)
			Pyrophoric -> Null,
			(* need to specify this directly because PreferredContainer needs it. Also need to resolve it correctly based on Autoclave and FilterSize *)
			Sterile -> resolvedSterile,
			AsepticHandling -> resolvedAsepticHandling
		},

		(* for ALL of these options, the field name is the same as the option name; use a helper to churn out rules  *)
		fieldRule/@ {
			Name, MixUntilDissolved, MixTime, MaxMixTime, MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes,
			NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,
			FilterMaterial, FilterSize,
			LightSensitive, ShelfLife, UnsealedShelfLife, TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming,
			IncubationTime, IncubationTemperature,
			DiscardThreshold,
			UltrasonicIncompatible, CentrifugeIncompatible,
			Resuspension, PrepareInResuspensionContainer
		}
	]|>,
		If[MatchQ[newModelType, Model[Sample, StockSolution]], Nothing, PrepareInResuspensionContainer]

	];

	(* get our template model, and also all of our alt prep packets that are exact prep matches *)
	templateModel=Download[Lookup[resolvedOptionsNoAmbient,StockSolutionTemplate],Object];

	(* Existing models are by definition the same (since preparation options are Flase/Null), just return the first *)
	existingMatchingModel=If[myReturnExistingModelBool,
		Which[
			(* if the template is still an exact match, nice! return it preferentially *)
			MemberQ[Lookup[alternativePreparationPackets,Object,{}],templateModel], templateModel,
			(* Got alternatives? return the first *)
			MatchQ[alternativePreparationPackets,{PacketP[]..}], Lookup[First[alternativePreparationPackets],Object],
			(* otherwise we got nada; just return a Null *)
			True, Null
		],
		Null
	];

	(* -- New model creation warning -- *)

	(* We will throw the warning, only if we are using template Model overload. The assumption is that the user does want to create new model if they give formula. *)

	(* Throw warning only if, *)
	(* 1. the user uses model overload for UploadStockSolution *)
	(* 2. a specified Name is NOT given *)

	gatherTests=MemberQ[ToList[Lookup[resolvedOptionsNoAmbient, Output]], Tests];

	fastTrack=Lookup[resolvedOptionsNoAmbient, FastTrack];

	(* if we are creating new model, keep track the potential mismatched fields when comparing to the input model *)
	{modelTemplateInputObject,mismatchFields}=If[myReturnExistingModelBool&&MatchQ[myModelTemplateInput,ObjectP[]],
		Module[{fieldMismatchesOptionQ,modelTemplateInputPacket,prepFieldsMismatchTracker},

			(* write a helper that will check potential mismatched fields in the template model *)
			fieldMismatchesOptionQ[myFieldName_Symbol,myPacket:PacketP[]]:=Module[
				{fieldValue,fieldValueToCheck,optionValue,equivalenceFunction},

				(* get the field value from the packet *)
				fieldValue=Lookup[myPacket,myFieldName];

				(* prune the field value in a couple of cases; want object reference, or for certain option values, the field is Null if option is false  *)
				fieldValueToCheck=Which[
					MatchQ[fieldValue,ObjectP[]],
					Download[fieldValue,Object],
					(* this case is super weird; if we have resolved to Mix, we will have MixUntilDissolved as True/False;
					 	the field will have Null for False though, so in this specific case, prune it to be False *)
					And[
						MatchQ[myFieldName,MixUntilDissolved],
						NullQ[fieldValue],
						Lookup[resolvedOptionsNoAmbient,Mix]
					],
					False,
					True,
					fieldValue
				];

				(* get the option value for the same field name *)
				optionValue=Lookup[resolvedOptionsNoAmbient,myFieldName];

				(* see if they're the same; use different equality functions depending on situation *)
				equivalenceFunction=Which[
					(* if at least one of the values is Null, use SameQ to ensure we evaluate; either they're not both Null, so def not the same, or they are, and it's fine *)
					MemberQ[{fieldValueToCheck,optionValue},Null],
					SameQ,
					(* okay so there are no Nulls; if one is a numeric or quantity, use Equal *)
					MatchQ[fieldValueToCheck,UnitsP[]],
					Equal,
					(* if both of the values are objects, need to use SameObjectQ *)
					MatchQ[{fieldValueToCheck,optionValue}, {ObjectP[], ObjectP[]}],
					SameObjectQ,
					(* okay otherwise we want a nice actual match, use MatchQ *)
					True,
					MatchQ
				];

				(* use the equivalence function determined above to asses DIFFERENCE for the field/option value *)
				Not[equivalenceFunction[fieldValueToCheck,optionValue]]
			];

			(* download our template model input packet *)
			(* we cannot assume it is included in the sameFormulaComponentModelPackets because of the same components during the search? The assumption is not valid somehow in a unit test with input model Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol \
in Water"]. *)
			modelTemplateInputPacket=Quiet[Download[myModelTemplateInput,
				Packet[
					UnitOperations,PreparationType
				]
			], {Download::FieldDoesntExist}];

			(* write a helper that tracks the mismatched fields in our template model input packet *)
			prepFieldsMismatchTracker[myMatchingPacket:PacketP[]]:=(
				If[fieldMismatchesOptionQ[#,myMatchingPacket],
					#,
					Nothing
				]&/@checkFieldsList);

			(* return potential mismatch fields *)
			{Lookup[modelTemplateInputPacket,Object],prepFieldsMismatchTracker[modelTemplateInputPacket]}
		],
		{Null,{}}
	];

	If[!fastTrack,
		Module[{newModelWarningQ, warning},

			(* set a boolean indicating if we want to throw a warning when creating new model *)
			newModelWarningQ = And[
				MatchQ[myModelTemplateInput,ObjectP[]], (* Model input overload *)
				myReturnExistingModelBool, (* No specified name *)
				Not[MatchQ[existingMatchingModel,ObjectReferenceP[]]] (* Creating new model *)
			];

			(* make a warning for the situation *)
			warning = If[gatherTests,
				Warning["When using template model input , a new model is created because the options " <> ToString[mismatchFields] <>" are different from the ones in the template " <> ToString[myModelTemplateInput] <> ".",
					newModelWarningQ,
					False
				],
				Nothing
			];

			(* throw message warning *)
			If[!gatherTests && newModelWarningQ,
				Message[Warning::NewModelCreation, mismatchFields, myModelTemplateInput,Lookup[newStockSolutionPacket,Object]]
			];

			(* return the warning *)
			{warning}
		],

		(* on fast track, blast ahead *)
		{}
	];

	(* -- Existing model usage warning -- *)
	(* We will throw the warning, only if we are using template Model overload with some specified options, and an alternative Model will be used instead. In this case, the alternative Model fulfills the input template Model plus all the specified options. *)

	(* Throw warning only if, *)
	(* 1. the user uses model overload for UploadStockSolution *)
	(* 2. a specified Name is NOT given *)
	(* 3&4. the existingMatchingModel exists and it is NOT the input template Model *)

	If[!fastTrack,
		Module[{existingModelWarningQ, warning},

			(* set a boolean indicating if we want to throw a warning when an existing model is used instead *)
			existingModelWarningQ = And[
				MatchQ[myModelTemplateInput,ObjectP[]], (* Model input overload *)
				myReturnExistingModelBool, (* No specified name *)
				MatchQ[existingMatchingModel,ObjectReferenceP[]], (* Creating new model *)
				!MatchQ[existingMatchingModel,modelTemplateInputObject] (* The existingMatchingModel is not the same as the input template Model *)
			];

			(* make a warning for the situation *)
			warning = If[gatherTests,
				Warning["When using template model input, the existing model " <> ToString[existingMatchingModel] <> " fulfills the template model input " <> ToString[modelTemplateInputObject] <>  " with specified options, and the existing model " <> ToString[existingMatchingModel] <> " will be used as the alternative preparation template for this stock solution.",
					existingModelWarningQ,
					False
				],
				Nothing
			];

			(* throw message warning *)
			If[!gatherTests && existingModelWarningQ,
				Message[Warning::ExistingModelReplacesInput, existingMatchingModel, modelTemplateInputObject]
			];

			(* return the warning *)
			{warning}
		],

		(* on fast track, blast ahead *)
		{}
	];


	(* either return the new packet/object (depending on Upload) if we don't have an existing, or just return the existing if we have it *)
	If[MatchQ[existingMatchingModel,ObjectReferenceP[]],
		existingMatchingModel,
		If[Lookup[resolvedOptionsNoAmbient,Upload],
			Upload[newStockSolutionPacket],
			newStockSolutionPacket
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*UploadStockSolutionOptions*)


DefineOptions[UploadStockSolutionOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>(Table|List)],
			Description->"Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{UploadStockSolution}
];


(* Overload 1 - Explicit Formula *)
UploadStockSolutionOptions[myFormula:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample],Object[Sample]}]}..},myOptions:OptionsPattern[UploadStockSolutionOptions]]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=UploadStockSolution[myFormula,Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadStockSolution],
			resolvedOptions
		]
	]
];

(* Overload 2 - Fill to Volume *)
UploadStockSolutionOptions[
	myFormula:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample],Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[UploadStockSolutionOptions]
]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=UploadStockSolution[myFormula,mySolvent,myFinalVolume,Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadStockSolution],
			resolvedOptions
		]
	]
];

(* Overload 3 - StockSolutionTemplate Model *)
UploadStockSolutionOptions[
	myTemplateModel:ObjectP[{Model[Sample,StockSolution],Model[Sample,Media],Model[Sample,Matrix]}],
	myOptions:OptionsPattern[UploadStockSolutionOptions]
]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=UploadStockSolution[myTemplateModel,Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadStockSolution],
			resolvedOptions
		]
	]
];

(* --- OVERLOAD 4: UnitOperation Overload with Composition (specified or inferred) --- *)

UploadStockSolutionOptions[
	myUnitOperations:{ManualSamplePreparationP..}, myOptions:OptionsPattern[UploadStockSolution]
]:=Module[{listedOptions,safeOptions,sampleComposition,simulatedSamplePackets,updatedOptions,nullifiedOptions,finalVolume,optionsWithoutOutput,resolvedOptions},

	(* get the listed form of the options provided, for option helpers to chew on *)
	listedOptions = ToList[myOptions];

	(* call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[UploadStockSolution, listedOptions, AutoCorrect -> False];

	(* see if we got a composition, if not simulate the samples and grab whatever's in the first container so the sample composition *)
	{sampleComposition, simulatedSamplePackets, finalVolume} = If[MatchQ[Lookup[safeOptions, Composition], Except[Automatic]],
		{Lookup[safeOptions, Composition],Null,Null},
		Module[{mspSimulatedPackets, labelOfInterest, simulatedContainer,simulatedSampleComposition, sanitizedSimulatedSampleComposition, volume, updatedSimulation},
			(*simulate*)
			mspSimulatedPackets =ExperimentManualSamplePreparation[myUnitOperations, Output -> Simulation];
			(*get the first label container unit operation,it should be the very first*)
			labelOfInterest = First[Cases[myUnitOperations, _LabelContainer]][Label];
			(*figure out what is the container that was simulated for it and whats in it*)
			simulatedContainer =Lookup[Lookup[First[mspSimulatedPackets], Labels],labelOfInterest];
			updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, mspSimulatedPackets];
			(*get the sample in that container and its volume*)
			{simulatedSampleComposition,volume} =  Download[simulatedContainer, {Contents[[1, 2]][Composition],Contents[[1, 2]][Volume]},Simulation -> updatedSimulation];
			(* make sure we're not dealing with links *)
			sanitizedSimulatedSampleComposition = {#[[1]], Download[#[[2]], Object]}& /@ simulatedSampleComposition;

			(* return composition and volume *)
			{sanitizedSimulatedSampleComposition,updatedSimulation,volume}
		]
	];

	(* specify Null for all prep options (unless they are already specified to save trouble on the resolver *)
	nullifiedOptions = Module[{prepOps,boolPrepOps},

		(* prep options that are defined as conflicting for Error::InvalidLabelContainerUnitOperationOption *)
		prepOps = {
			Incubate, IncubationTemperature, IncubationTime, Mix, MixUntilDissolved, MixTime, MaxMixTime, MixType,
			Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes, AdjustpH, NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize, Autoclave, AutoclaveProgram, OrderOfOperations, FillToVolumeMethod
		};

		boolPrepOps = {Incubate, Mix, AdjustpH, Filter, Autoclave};

		(* mass resolve options *)
		Map[Function[option,
			If[
				MatchQ[Lookup[safeOptions,option], Except[Automatic]],
				option->Lookup[safeOptions,option],
				option->If[MemberQ[boolPrepOps, option], False, Null]
			]],
			prepOps
		]
	];

	(* replace Composition optionand  *)
	updatedOptions = ReplaceRule[safeOptions, Join[nullifiedOptions,{Composition->sampleComposition,Simulation->simulatedSamplePackets}]];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[updatedOptions,(OutputFormat->_)|(Output->_)];

	(* call the unit ops overload *)
	resolvedOptions = uploadStockSolutionModel[{{Null,Null}},Null,finalVolume,myUnitOperations, Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadStockSolution],
			resolvedOptions
		]
	]
];

(* ::Subsubsection::Closed:: *)
(*ValidUploadStockSolutionQ*)


DefineOptions[ValidUploadStockSolutionQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{UploadStockSolution}
];


(* Overload 1 - Explcit Formula *)
ValidUploadStockSolutionQ[myFormula:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..},myOptions:OptionsPattern[ValidUploadStockSolutionQ]]:=Module[
	{listedOptions,optionsWithoutOutput,tests,verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)|(Verbose->_)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests=UploadStockSolution[myFormula,Append[optionsWithoutOutput,Output->Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadStockSolutionQ"->tests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidUploadStockSolutionQ"]
];


(* Overload 2 - Fill to Volume *)
ValidUploadStockSolutionQ[
	myFormula : {{MassP | VolumeP | GreaterP[0, 1.],ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent : ObjectP[{Model[Sample]}],
	myFinalVolume : VolumeP,
	myOptions : OptionsPattern[ValidUploadStockSolutionQ]
] := Module[
	{listedOptions, optionsWithoutOutput, tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests = UploadStockSolution[myFormula, mySolvent, myFinalVolume, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadStockSolutionQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadStockSolutionQ"]
];

(* Overload 3 - StockSolutionTemplate Model *)
ValidUploadStockSolutionQ[
	myTemplateModel : ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix]}],
	myOptions : OptionsPattern[ValidUploadStockSolutionQ]
] := Module[
	{listedOptions, optionsWithoutOutput, tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests = UploadStockSolution[myTemplateModel, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadStockSolutionQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadStockSolutionQ"]
];

(* --- OVERLOAD 4: UnitOperation Overload with Composition (specified or inferred) --- *)

ValidUploadStockSolutionQ[
	myUnitOperations:{ManualSamplePreparationP..}, myOptions:OptionsPattern[ValidUploadStockSolutionQ]
]:=Module[
	{listedOptions, optionsWithoutOutput, tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests = UploadStockSolution[myUnitOperations, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadStockSolutionQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadStockSolutionQ"]
];

(* --- Helper function to resolve mix and incubate options, whether pre- or post-autoclave --- *)
resolveMixIncubateUSSOptions[
	mixOrPost:(Mix|PostAutoclaveMix),
	resolvedMixBool:(BooleanP|Null),
	resolvedIncubateBool:(BooleanP|Null),
	preResolvedMixTime:(TimeP|Null|Automatic),
	preResolvedIncubationTime:(TimeP|Null|Automatic),
	gatherTests:(BooleanP|Null),
	safeOptionsTemplateWithMixAndIncubateTimes:OptionsPattern[resolveUploadStockSolutionOptions],
	mixAndIncubateSubOptionNames:{_Symbol...},
	mixSubOptionNames:{_Symbol...},
	incubateSubOptionNames:{_Symbol...},
	fastTrack:(BooleanP|Null),
	mySolventPacket:(PacketP[]|Null),
	resolvedPrepContainer:(ObjectP[]|Null),
	resolvedLightSensitive:(BooleanP|Null),
	effectiveStockSolutionVolume:(VolumeP|Null)
]:=Module[{
	mixIncubateTimeMismatchTests,relevantErrorCheckingMixOptions,mixSubOptionsSetIncorrectly,mixSubOptionsSetIncorrectlyTests,
	mixTypeRequiredError,mixTypeRequiredTests,incubateSubOptionsSetIncorrectly,incubateSubOptionsSetIncorrectlyTests,resolvedMixOptions,
	mixResolutionInvalid,mixOptionResolutionTests,mixTimeOption,incubationTimeOption,mixerOption,mixRateOption,mixTypeOption,
	numMixesOption,maxNumMixesOption,maxMixTimeOption,incubationTemperatureOption,mixUntilDissolvedOption,
	incubateOption
},
	(* To start off, we need to key relevant option names off of whether we're dealing with pre- or post-autoclave *)
	{
		mixTimeOption,incubationTimeOption,mixerOption,mixRateOption,mixTypeOption,numMixesOption,maxNumMixesOption,maxMixTimeOption,
		incubationTemperatureOption,mixUntilDissolvedOption,incubateOption
	}=If[MatchQ[mixOrPost,Mix],
		{
			MixTime,IncubationTime,Mixer,MixRate,MixType,NumberOfMixes,MaxNumberOfMixes,MaxMixTime,IncubationTemperature,MixUntilDissolved,Incubate
		},
		{
			PostAutoclaveMixTime,PostAutoclaveIncubationTime,PostAutoclaveMixer,PostAutoclaveMixRate,PostAutoclaveMixType,PostAutoclaveNumberOfMixes,
			PostAutoclaveMaxNumberOfMixes,PostAutoclaveMaxMixTime,PostAutoclaveIncubationTemperature,PostAutoclaveMixUntilDissolved,PostAutoclaveIncubate
		}
	];


	(* make tests and throw an error if there is a mismatch in the Times *)
	mixIncubateTimeMismatchTests = If[!fastTrack,
		Module[{mixAndIncubationTimeMismatchQ, test},

			(* figure out if MixTime and IncubationTime are both specified, and if so, whether they are the same *)
			(* if True, then there is a mismatch for which we are throwing an error *)
			mixAndIncubationTimeMismatchQ = If[resolvedMixBool && resolvedIncubateBool && TimeQ[preResolvedMixTime] && TimeQ[preResolvedIncubationTime],
				preResolvedMixTime != preResolvedIncubationTime,
				False
			];

			(* make a test for this mismatch *)
			test = If[gatherTests,
				Test["If " <> ToString@incubateOption <> " -> True and " <> ToString@mixOrPost <> " -> True, if " <> ToString@incubationTimeOption <> " and " <> ToString@mixTimeOption <> " are specified, they are the same:",
					mixAndIncubationTimeMismatchQ,
					False
				]
			];

			(* throw an error about this *)
			If[Not[gatherTests] && mixAndIncubationTimeMismatchQ,
				Message[Error::MixTimeIncubateTimeMismatch, preResolvedMixTime, preResolvedIncubationTime, "the input"];
				Message[Error::InvalidOption, {mixTimeOption, incubationTimeOption}]
			];

			{test}
		],
		{}
	];

	(* get the relevant option names we need to check depending on whether we are incubating, mixing, both at the same time, or neither *)
	relevantErrorCheckingMixOptions = Which[
		(* if Mix -> False and Incubate -> False, then we need to check all the options *)
		MatchQ[resolvedMixBool, False] && MatchQ[resolvedIncubateBool, False], Select[safeOptionsTemplateWithMixAndIncubateTimes, MemberQ[mixAndIncubateSubOptionNames, Keys[#]]&],
		(* if Mix -> False but Incubate -> True, then only the mix-specific options are what we want to check below *)
		MatchQ[resolvedMixBool, False] && TrueQ[resolvedIncubateBool], Select[safeOptionsTemplateWithMixAndIncubateTimes, MemberQ[mixSubOptionNames, Keys[#]]&],
		(* if Mix -> True and Incubate -> False, then the incubate-specific options are the ones we want to check *)
		TrueQ[resolvedMixBool] && MatchQ[resolvedIncubateBool, False], Select[safeOptionsTemplateWithMixAndIncubateTimes, MemberQ[incubateSubOptionNames, Keys[#]]&],
		(* if Mix -> True AND Incubate -> True, then we're not actually going to check anything because all of them should be specified*)
		TrueQ[resolvedMixBool] && TrueQ[resolvedIncubateBool], {}
	];

	(* now resolve the Mix options; if Mix controlling boolean is set to False but any sub-options are non-Automatic/Null, we can yell about that *)
	{mixSubOptionsSetIncorrectly, mixSubOptionsSetIncorrectlyTests} = If[!fastTrack,
		Module[{incorrectMixSubOptions, invalidBool, test},

			(* identify incorrectly-specified sub options *)
			incorrectMixSubOptions = PickList[mixSubOptionNames, Lookup[relevantErrorCheckingMixOptions, mixSubOptionNames, Null], Except[Automatic|Null]];

			(* we will re-use the boolean check if there are symbols in here; make a variable for that *)
			invalidBool = MatchQ[incorrectMixSubOptions, {_Symbol..}];

			(* make a test for reporting mix options that are set without the parent bool *)
			test = If[gatherTests,
				Test[ToString@mixOrPost<>"ing preparation options are not specified if "<>ToString@mixOrPost<>" is set to False:",
					invalidBool,
					False
				],
				Nothing
			];

			(* throw an error about this *)
			If[!gatherTests && invalidBool,
				(* MixOptionConflict is also a message for ExperimentStockSolution where the second input is the stock solution being made; since we can only make one at a time here anyway, we can just say "the input" *)
				Message[Error::MixOptionConflict, incorrectMixSubOptions, "the input"];
				Message[Error::InvalidOption, incorrectMixSubOptions]
			];

			(* report a boolean indicating if we tripped this check, and the test *)
			{invalidBool, {test}}
		],
		{False, {}}
	];

	(* If Mixer, MixRate, NumberOfMixes, or MaxNumberOfMixes are specified, MixType must be specified *)
	{mixTypeRequiredError, mixTypeRequiredTests} = If[!fastTrack,
		Module[{mixer, mixRate, mixType, invalidOptions, invalidBool, test, numMixes, maxNumMixes},

			(*  pull out the Mixer/MixRate/MixType options *)
			{mixer, mixRate, mixType, numMixes, maxNumMixes} = Lookup[safeOptionsTemplateWithMixAndIncubateTimes, {mixerOption,mixRateOption,mixTypeOption,numMixesOption,maxNumMixesOption}];

			(* if Mixer or MixRate or NumberOfMixes or MaxNumberOfMixes is specified, MixType must be specified *)
			invalidBool = If[MatchQ[mixer, ObjectP[Model[Instrument]]] || RPMQ[mixRate] || MatchQ[numMixes, Except[Null|Automatic]] || MatchQ[maxNumMixes, Except[Null|Automatic]],
				Not[MatchQ[mixType, MixTypeP]],
				False
			];

			(* get the invalid options *)
			invalidOptions = If[invalidBool,
				Flatten[{mixTypeOption, PickList[{mixerOption, mixRateOption, numMixesOption, maxNumMixesOption}, {mixer, mixRate, numMixes, maxNumMixes}, Except[Null]]}],
				{}
			];

			(* make a test for reporting mix options that are set without the parent bool *)
			test = If[gatherTests,
				Test["If "<>ToString@mixerOption<>", "<>ToString@mixRateOption<>", "<>ToString@numMixesOption<>", or "<>ToString@maxNumMixesOption<>" is specified, "<>ToString@mixTypeOption<>" is also specified:",
					invalidBool,
					False
				],
				Nothing
			];

			(* throw an error about this *)
			If[!gatherTests && invalidBool,
				Message[Error::MixTypeRequired, invalidOptions];
				Message[Error::InvalidOption, invalidOptions]
			];

			(* report a boolean indicating if we tripped this check, and the test *)
			{invalidBool, {test}}
		],
		{False, {}}
	];


	(* if the resolved Incubate controlling boolean is set to False but any incubation sub options are set we yell (or if Mix -> False, there are more we can yell about) *)
	{incubateSubOptionsSetIncorrectly, incubateSubOptionsSetIncorrectlyTests} = If[!fastTrack,
		Module[{incorrectIncubateSubOptions, invalidBool, test},

			(* identify incorrectly-specified sub options *)
			incorrectIncubateSubOptions = PickList[incubateSubOptionNames, Lookup[relevantErrorCheckingMixOptions, incubateSubOptionNames, Null], Except[Automatic|Null]];

			(* we will re-use the boolean check if there are symbols in here; make a variable for that *)
			invalidBool = MatchQ[incorrectIncubateSubOptions, {_Symbol..}];

			(* make a test for reporting mix options that are set without the parent bool *)
			test = If[gatherTests,
				Test["Relevant incubation preparation options are not specified if "<>ToString@incubateOption<>" is set to False:",
					invalidBool,
					False
				],
				Nothing
			];

			(* throw an error about this *)
			If[!gatherTests && invalidBool,
				(* IncubateOptionConflict is also a message for ExperimentStockSolution where the second input is the stock solution being made; since we can only make one at a time here anyway, we can just say "the input" *)
				Message[Error::IncubateOptionConflict, incorrectIncubateSubOptions, "the input"];
				Message[Error::InvalidOption, incorrectIncubateSubOptions]
			];

			(* report a boolean indicating if we tripped this check, and the test *)
			{invalidBool, {test}}
		],
		{False, {}}
	];

	(* resolve the mix options; need to use SimulateSample to pass into the ExperimentIncubate; if Mix is False AND Incubate is False, just set all the options to Null *)
	{resolvedMixOptions, mixResolutionInvalid, mixOptionResolutionTests} = If[resolvedMixBool || resolvedIncubateBool,
		Module[
			{simulatedSamplePackets, simulatedContainer, sampleModelForSimulation, justMixOptions,
				ussmToMixOptionNameMap, renamedMixOptions, mixResolveFailure, resMixOptions,
				mixResolvingTests, mixToUSSMOptionNameMap, resolvedUSSMMixOptionAssociation, resolvedUSSMMixOptionsSingleValues,
				expandedMixOptionsWithSafeOptions, resolvedUSSMmixOptionsWithIncubationTime, renamedMixOptionsOptionalsRemoved,
				preResolvedMixType, preResolvedMixRate, preResolvedMixer, resolvedUSSMMixOptionsOptionalsRemoved,
				incubateSafeOps, allSimulatedPackets
			},

			(* set a model to use as the "fake" model for Mix; want it to be a liquid, so either use the solvent model, or Milli-Q water if we don't have that *)
			sampleModelForSimulation = If[MatchQ[mySolventPacket, PacketP[]],
				Lookup[mySolventPacket, Object],
				Model[Sample, "Milli-Q water"]
			];

			(* need to make a simulated sample to give to mix for resolution; we don't even have a stock solution model yet though; just send Mix the solvent, or water *)
			(* need to quiet the SimulateSample error that tells me I can't pass MolecularWeight in things that don't have that field (like StockSolution etc).  However I need to simulate with it for now because Aliquot downloads it in either case  *)
			{simulatedSamplePackets, simulatedContainer} = Quiet[
				SimulateSample[{sampleModelForSimulation}, "stock solution sample 1", {"A1"}, resolvedPrepContainer, {State -> Liquid, LightSensitive -> resolvedLightSensitive, Volume -> effectiveStockSolutionVolume, Mass -> Null, Count -> Null}],
				SimulateSample::InvalidPacket
			];

			(* take JUST the mix options (and the incubate options because they are together); BEWARE this output is an association not a list of rules; turn to list of rules for easy replacing *)
			justMixOptions = Normal[KeyTake[safeOptionsTemplateWithMixAndIncubateTimes, mixAndIncubateSubOptionNames], Association];

			(* get the pre-resolved MixType/MixRate/Mixer *)
			(* need to change the Automatics to Null if they haven't already been template-replaced *)
			{preResolvedMixType, preResolvedMixRate, preResolvedMixer} = Lookup[justMixOptions, {mixTypeOption, mixRateOption, mixerOption}] /. {Automatic -> Null};

			(* define a mapping between this function's mix option names and ExperimentIncubate option names THAT ARE DIFFERENT *)
			ussmToMixOptionNameMap = {
				mixTimeOption -> Time,
				maxMixTimeOption -> MaxTime,
				mixerOption -> Instrument,
				incubationTemperatureOption -> Temperature,
				mixRateOption -> MixRate,
				mixTypeOption -> MixType,
				mixUntilDissolvedOption -> MixUntilDissolved,
				numMixesOption -> NumberOfMixes,
				maxNumMixesOption -> MaxNumberOfMixes,
				incubationTimeOption -> IncubationTime
			};

			(* rename the mix options as ExperimentMix knows them all by different names *)
			(* also remove all instances of the IncubationTime option; we can put it back after the resolution *)
			renamedMixOptions = Select[justMixOptions /. ussmToMixOptionNameMap, Not[MatchQ[Keys[#], IncubationTime]]&];

			(* remove the Mixer/MixType/MixRate options if they are not specified because they will resolve automatically *)
			(* also remove MixTime or IncubateTime since we already have Time *)
			renamedMixOptionsOptionalsRemoved = Map[
				Which[
					MatchQ[#[[1]], Rate|Type|Instrument] && NullQ[#[[2]]], Nothing,
					MatchQ[#1[[1]], mixTimeOption|incubationTimeOption], Nothing,
					True, #[[1]] -> #[[2]]
				]&,
				renamedMixOptions
			];

			(* get the safe options that we are going to expand/replace below  *)
			incubateSafeOps = SafeOptions[ExperimentIncubate, renamedMixOptionsOptionalsRemoved];

			(* need to add all the other option names too with SafeOptions here (and also expand the options) *)
			expandedMixOptionsWithSafeOptions = Last[ExpandIndexMatchedInputs[
				ExperimentIncubate,
				{simulatedSamplePackets},
				ReplaceRule[
					incubateSafeOps,
					{
						Mix -> resolvedMixBool,
						(* if we are NOT mixing then auto-resolve Type to Null; otherwise it should be Automatic *)
						MixType -> Which[
							resolvedMixBool && MatchQ[preResolvedMixType, MixTypeP], preResolvedMixType,
							resolvedMixBool, Automatic,
							True, Null
						],
						(* need to set the Time to be the pre-resolved Mix time *)
						(* note that this will only really be an issue if they explicitly set these values to be different but this way it fails more sensibly *)
						Time -> If[resolvedIncubateBool,
							preResolvedIncubationTime,
							preResolvedMixTime
						],
						(* if Incubate -> True and Temperature is Automatic, pre-resolve it to 30*Celsius because it will get resolved to Null by ExperimentIncubate otherwise since it doesn't have its own Incubate option *)
						If[resolvedIncubateBool && MatchQ[Lookup[incubateSafeOps, Temperature], Automatic],
							Temperature -> 30*Celsius,
							Nothing
						]
					}]
			]];

			(* group the simulated packets together *)
			allSimulatedPackets = Flatten[{simulatedSamplePackets, simulatedContainer}];

			(* use Check to see if we got an error from mix options; still throw those message;
			 	ALWAYS assign the results even if messages are thrown  *)
			mixResolveFailure = Check[
				{resMixOptions, mixResolvingTests} = If[gatherTests,
					ExperimentIncubate[Lookup[simulatedSamplePackets, Object], ReplaceRule[expandedMixOptionsWithSafeOptions, {Cache -> allSimulatedPackets, Simulation -> Simulation[allSimulatedPackets], OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
					{ExperimentIncubate[Lookup[simulatedSamplePackets, Object], ReplaceRule[expandedMixOptionsWithSafeOptions, {Cache -> allSimulatedPackets, Simulation -> Simulation[allSimulatedPackets], OptionsResolverOnly -> True, Output -> Options}]], {}}
				],
				$Failed,
				{Error::InvalidInput, Error::InvalidOption}
			];

			(* reverse our earlier lookup to get a map back to our USSM option names *)
			mixToUSSMOptionNameMap = Reverse /@ ussmToMixOptionNameMap;

			(* we are assuming that this resolver ALWAYS returns resolved options; get those back; resolveMixOptions spits out list of rules, make association for next step *)
			resolvedUSSMMixOptionAssociation = Association[KeyValueMap[
				(#1 /. mixToUSSMOptionNameMap) -> #2&,
				KeySelect[resMixOptions, MemberQ[Keys[renamedMixOptions], #]&]
			]];

			(* the mix resolve gives us listed options; we want the first of any list since we for sure gave just one sample blob *)
			resolvedUSSMMixOptionsSingleValues = Association[KeyValueMap[
				#1 -> If[ListQ[#2] && Length[#2] == 1,
					First[#2],
					#2
				]&,
				resolvedUSSMMixOptionAssociation
			]];

			(* change the MixType/MixRate/Mixer back to what was specified because they are optional and can be Null otherwise *)
			resolvedUSSMMixOptionsOptionalsRemoved = KeyValueMap[
				Which[
					MatchQ[#1, mixTypeOption], #1 -> preResolvedMixType,
					MatchQ[#1, mixRateOption], #1 -> preResolvedMixRate,
					MatchQ[#1, mixerOption], #1 -> preResolvedMixer,
					True, #1 -> #2
				]&,
				resolvedUSSMMixOptionsSingleValues
			];

			(* add the IncubationTime option back in if necessary *)
			resolvedUSSMmixOptionsWithIncubationTime = Which[
				(* if IncubationTime was set, then just use what it was set to *)
				MatchQ[Lookup[safeOptionsTemplateWithMixAndIncubateTimes, incubationTimeOption], Except[Automatic]], Append[resolvedUSSMMixOptionsOptionalsRemoved,
					incubationTimeOption -> Lookup[safeOptionsTemplateWithMixAndIncubateTimes, incubationTimeOption]],
				(* if we are mixing and incubating (and IncubationTime was set to Automatic), resolve it to whatever MixTime was resolved to *)
				resolvedMixBool && resolvedIncubateBool, Append[resolvedUSSMMixOptionsOptionalsRemoved,
					incubationTimeOption -> Lookup[resolvedUSSMMixOptionsOptionalsRemoved, mixTimeOption]],
				(* if we are mixing and NOT incubating, IncubationTime resolves to Null*)
				resolvedMixBool && Not[resolvedIncubateBool], Append[resolvedUSSMMixOptionsOptionalsRemoved, incubationTimeOption -> Null],
				(* if we are not mixing but we ARE incubating, then Time actually corresponds to IncubationTime, and MixTime should be or whatever was specified before *)
				Not[resolvedMixBool] && resolvedIncubateBool, ReplaceRule[resolvedUSSMMixOptionsOptionalsRemoved, {MixTime -> (Lookup[safeOptionsTemplateWithMixAndIncubateTimes, mixTimeOption] /. {Automatic -> Null}), incubationTimeOption -> Lookup[resolvedUSSMMixOptionsOptionalsRemoved, mixTimeOption]}],
				(* if we are not mixing or incubating (or however we got here), IncubationTime resolves to Null *)
				True, Append[resolvedUSSMMixOptionsOptionalsRemoved, incubationTimeOption -> Null]
			];

			(* we're ready to spit back out the resolve mix options with the right names, whether the resolving went smoothly, and thet tests generated *)
			(* need to add Incubate back in because we kind of replaced it before the ExperimentIncubate call *)
			{ReplaceRule[resolvedUSSMmixOptionsWithIncubationTime, incubateOption -> resolvedIncubateBool], MatchQ[mixResolveFailure, $Failed], mixResolvingTests}
		],

		(* otherwise we're not mixing; everything is Null (if it was specified, we already yelled about it above, so claim that this resolution was fine) *)
		{Normal[KeyTake[<|safeOptionsTemplateWithMixAndIncubateTimes|>, mixAndIncubateSubOptionNames]] /. {Automatic -> Null}, False, {}}
	];

	(* Finally, return what we came here to do *)
	{mixIncubateTimeMismatchTests,mixSubOptionsSetIncorrectlyTests,incubateSubOptionsSetIncorrectlyTests,resolvedMixOptions,mixOptionResolutionTests}
];
