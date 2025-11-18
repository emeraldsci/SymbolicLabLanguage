(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentStockSolution*)


(* ::Subsubsection:: *)
(*ExperimentStockSolution Options and Messages*)


DefineOptions[ExperimentStockSolution,
	Options :> {
		(* Index matching options *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* ExperimentPlateMedia options, hidden because they are used only when ExperimentStockSolution is called by ExperimentMedia in Engine, for plating out solid media *)
			{
				OptionName->Supplements,
				Default->None,
				Description->"Additional substances that would traditionally appear in the name of the media, such as 2% Ampicillin in LB + 2% Ampicillin. These components will be added to the Formula field of the Model[Sample,Media] but are specially called out in the media name following the \"+\" symbol. For example, ExperimentMedia[Model[Sample,Media,\"Liquid LB\"], Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter}] will create a new Model[Sample,Media,\"Liquid LB + Ampicillin, 50*Microgam/Liter\"] with Supplements->{Model[Molecule,\"Ampicillin\"], 50*Microgram/Liter} added to the Formula of the input media.",
				AllowNull->False,
				Category->"Hidden",
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
				Category->"Hidden",
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
				Category->"Hidden",
				Widget->Alternatives[
					Adder[
						{
							"Amount"->Widget[
								Type->Quantity,
								Pattern:>RangeP[0*Gram/Milliliter,100*Gram/Milliliter],
								Units->CompoundUnit[
									{1,{Gram,{Milligram,Gram,Kilogram}}},
									{-1,{Liter,{Milliliter,Liter}}}
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
						Pattern:>Alternatives[None,Automatic]
					]
				],
				ResolutionDescription->"Automatically set to {Model[Sample, \"Agar\"], 20*Gram/Liter} if MediaPhase is set to Solid. If any GellingAgent is detected in the Formula field of Model[Sample,Media], it will be removed from the Formula and listed separately."
			},
			{
				OptionName->MediaPhase,
				Default->Automatic,
				Description->"The physical state of the prepared media at ambient temperature and pressure." (*TODO update description to explain SemiSolid *),
				AllowNull->True,
				Category->"Hidden",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[MediaPhaseP]
				],
				ResolutionDescription->"Automatically set to Liquid if GellingAgents is not specified."
			},
			{
				OptionName->OrderOfOperations,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					Widget[Type->Enumeration, Pattern:>Alternatives[FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration,
						Autoclave, FixedHeatSensitiveReagentAddition, PostAutoclaveIncubation]]
				],
				Description->"The order in which solution preparation steps will be carried out to create the stock solution. By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration, Autoclave, FixedHeatSensitiveReagentAddition, PostAutoclaveIncubation}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration. Filtration, Autoclave, FixedHeatSensitiveReagentAddition, and PostAutoclaveIncubation must always occur last in that order. The FillToVolume/pHTitration stages are allowed to be swapped.",
				ResolutionDescription->"By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration, Autoclave, FixedHeatSensitiveReagentAddition,PostAutoclaveIncubation}. FixedReagentAddition must always be first and Incubation/Mixing must always occur after FillToVolume/pHTitration. Filtration, Autoclave, FixedHeatSensitiveReagentAddition, and PostAutoclaveIncubation must always occur last in that order. The FillToVolume/pHTitration stages are allowed to be swapped. When using a UnitOperations input, resolves to Null.",
				Category->"Preparation"
			},
			{
				OptionName->Volume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$MinStockSolutionComponentVolume,$MaxStockSolutionComponentVolume],
					Units -> {Liter, {Microliter, Milliliter, Liter}}
				],
				Description->"The volume of the stock solution model that should be prepared. Formula component amounts will be scaled according to the TotalVolume specified in the stock solution model if this Volume differs from the model's TotalVolume. This option may not be used with the direct formula definition.",
				ResolutionDescription->"Automatically resolves to the TotalVolume field of the stock solution, or to the sum of the volumes of any liquid formula components if the TotalVolume is unknown for a first-time preparation of a stock solution.",
				Category->"Preparation"
			},
			{
				OptionName->FillToVolumeMethod,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>FillToVolumeMethodP
				],
				Description->"The method by which to add the Solvent specified in the stock solution model to bring the stock solution up to the TotalVolume specified in the stock solution model.",
				ResolutionDescription->"Resolves to Null if there is no Solvent/TotalVolume. Otherwise, will resolved based on the FillToVolumeMethod in the given Model[Sample, StockSolution].",
				Category->"Preparation"
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
				OptionName->PrepareInResuspensionContainer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicate if the stock solution should be prepared in the original container of the FixedAmount component in its formula. PrepareInResuspensionContainer cannot be True if there is no FixedAmount component in the formula, and it is not possible if the specified amount does not match the component's FixedAmount.",
				ResolutionDescription->"Automatically resolves to False unless otherwise specified.",
				Category->"Preparation"
			},

			(* --- Incubation --- *)
			{
				OptionName->Incubate,
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
				OptionName->Incubator,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description->"The instrument that should be used to treat the stock solution at a specified temperature following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to an appropriate instrument based on container model, or Null if Incubate is set to False.",
				Category->"Incubation"
			},
			{
				OptionName->IncubationTemperature,
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
				OptionName->IncubationTime,
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
			{
				OptionName->AnnealingTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute, $MaxExperimentTime],
					Units->{1,{Minute,{Minute,Hour}}}
				],
				Description->"Minimum duration for which the stock solution should remain in the incubator allowing the solution and incubator to return to room temperature after the MixTime has passed if mixing while incubating.",
				ResolutionDescription->"Automatically resolves to 0 Minute, or Null if Incubate is set to False.",
				Category->"Incubation"
			},

			(* --- Mixing --- *)
			{
				OptionName->Mix,
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
				OptionName->MixType,
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
				OptionName->MixUntilDissolved,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the complete dissolution of any solid components should be verified following component combination, filling to volume with solvent, and any specified mixing steps.",
				ResolutionDescription->"Automatically set to False if Autoclave is True.",
				Category->"Mixing"
			},
			{
				OptionName->Mixer,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description->"The instrument that should be used to mechanically incorporate the components of the stock solution following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves based on the MixType and the size of the container in which the stock solution is prepared.",
				Category->"Mixing"
			},
			{
				OptionName->MixTime,
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
				OptionName->MaxMixTime,
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
				OptionName->MixRate,
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
				OptionName->NumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Number, Pattern:>RangeP[1, 50, 1]],
				Description->"The number of times the stock solution should be mixed by inversion or repeatedly aspirated and dispensed using a pipette following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to 10 when MixType is Pipette, 3 when MixType is Invert, or Null otherwise.",
				Category->"Mixing"
			},
			{
				OptionName->MaxNumberOfMixes,
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
			{
				OptionName->MixPipettingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter, 5 Milliliter],
					Units :> {1,{Milliliter,{Microliter,Milliliter}}}
				],
				Description->"The volume of the stock solution that should be aspirated and dispensed with a pipette to mix the solution following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to 50% of the total stock solution volume if MixType is Pipette, and Null otherwise.",
				Category->"Mixing"
			},
			{
				OptionName -> StirBar,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Indicates which model stir bar to be inserted to mix the stock solution prior to autoclave when HeatSensitiveReagents is not Null.",
				Widget -> Widget[Type->Object,
					Pattern :> ObjectP[{Model[Part,StirBar],Object[Part,StirBar]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments","Mixing Devices", "Stir Bars"
						}
					}
				],
				Category -> "Hidden"
			},

			(* --- Post-Autoclave Incubation --- *)
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
				OptionName->PostAutoclaveIncubator,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description->"The instrument that should be used to treat the stock solution at a specified temperature following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to an appropriate instrument based on container model, or Null if Incubate is set to False.",
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
			{
				OptionName->PostAutoclaveAnnealingTime,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute, $MaxExperimentTime],
					Units->{1,{Minute,{Minute,Hour}}}
				],
				Description->"Minimum duration for which the stock solution should remain in the incubator allowing the solution and incubator to return to room temperature after the MixTime has passed if mixing while incubating.",
				ResolutionDescription->"Automatically resolves to 0 Minute, or Null if Incubate is set to False.",
				Category->"Incubation"
			},

			(* --- Post-Autoclave Mixing --- *)
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
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
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
			{
				OptionName->PostAutoclaveMixPipettingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter, 5 Milliliter],
					Units :> {1,{Milliliter,{Microliter,Milliliter}}}
				],
				Description->"The volume of the stock solution that should be aspirated and dispensed with a pipette to mix the solution following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to 50% of the total stock solution volume if MixType is Pipette, and Null otherwise.",
				Category->"Mixing"
			},

			(* --- pH Titration --- *)
			{
				OptionName->AdjustpH,
				Default->Automatic,
				AllowNull->False,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the pH (measure of acidity or basicity) of this stock solution should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set to True if any other pHing options are specified, or if NominalpH is specified in the template model, or False otherwise.",
				Category->"pH Titration"
			},
			{
				OptionName->pH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0, 14]
				],
				Description->"The pH to which this stock solution should be adjusted following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves from the NominalpH field in the stock solution.",
				Category->"pH Titration"
			},
			{
				OptionName->MinpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,14]
				],
				Description->"The minimum allowable pH this stock solution should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent and/or mixing.",
				ResolutionDescription->"Automatically resolves to the MinpH field of the stock solution, to 0.1 below the resolved pH value if the stock solution has no MinpH, or to Null if the pH option resolves to Null.",
				Category->"pH Titration"
			},
			{
				OptionName->MaxpH,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0, 14]
				],
				Description->"The maximum allowable pH this stock solution should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves to the MaxpH field of the stock solution, to 0.1 above the resolved pH value if the stock solution has no MaxpH, or to Null if the pH option resolves to Null.",
				Category->"pH Titration"
			},
			{
				OptionName->pHingAcid,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Acids"
						}
					}
				],
				Description->"The acid that should be used to lower the pH of the solution following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves based on the pHingAcid field in the stock solution, to 6N HCl if the pH option is specified but the stock solution has no pHingAcid, or to Null if the pH option is unspecified.",
				Category->"pH Titration"
			},
			{
				OptionName->pHingBase,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Acids"
						}
					}
				],
				Description->"The base that should be used to raise the pH of the solution following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically resolves based on the pHingBase field in the stock solution, to 1.85M NaOH if the pH option is specified but the stock solution has no pHingBase, or to Null if the pH option is unspecified.",
				Category->"pH Titration"
			},


			(* --- Filter --- *)
			{
				OptionName->Filter,
				Default->Automatic,
				AllowNull->False,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the stock solution should be passed through a porous medium to remove solids or impurities following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to False if a new stock solution formula is provided, to True if an existing stock solution model with filtration parameters is provided, and to False if the provided stock solution model has no filtration parameters.",
				Category->"Filtration"
			},
			{
				OptionName->FilterType,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[
					Type->Enumeration,
					Pattern:>FiltrationTypeP
				],
				Description->"The method that will be used to pass this stock solution through a porous medium to remove solids or impurities following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a method with the lowest dead volume given the volume of stock solution being prepared.",
				Category->"Filtration"
			},
			{
				OptionName->FilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>FilterMembraneMaterialP
				],
				Description->"The composition of the medium through which the stock solution should be passed following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves from the FilterMaterial field of the stock solution.",
				Category->"Filtration"
			},
			{
				OptionName->FilterSize,
				Default->Automatic,
				AllowNull->True,
				Widget-> Widget[
					Type->Enumeration,
					Pattern:>FilterSizeP
				],
				Description->"The size of the membrane pores through which the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves from the FilterSize field of the stock solution.",
				Category->"Filtration"
			},
			{
				OptionName->FilterInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, Centrifuge], Model[Instrument, SyringePump], Model[Instrument, PeristalticPump], Model[Instrument, VacuumPump]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Pumps",
							"Vacuum Pumps"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Centrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Microcentrifuges"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Centrifugation",
							"Robotic Compatible Microcentrifuges"
						}
					}
				],
				Description->"The instrument that should be used to filter the stock solution following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to an instrument appropriate to the volume of sample being filtered.",
				Category->"Filtration"
			},
			{
				OptionName->FilterModel,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container, Plate, Filter], Model[Container, Vessel, Filter], Model[Item, Filter]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Filters"
						},
						{
							Object[Catalog, "Root"],
							"Labware",
							"Filters"
						}
					}
				],
				Description->"The model of filter that should be used to filter the stock solution following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a model of filter compatible with the FilterInstrument/FilterSyringe being used for the filtration.",
				Category->"Filtration"
			},
			{
				OptionName->FilterSyringe,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container, Syringe]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Syringes"
						}
					}
				],
				Description->"The syringe that should be used to force the stock solution through a filter following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a syringe appropriate to the volume of stock solution being filtered.",
				Category->"Filtration"
			},
			{
				OptionName->FilterHousing,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument, FilterHousing],
						Model[Instrument, FilterBlock]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						}
					}
				],
				Description->"The instrument that should be used to hold the filter membrane through which the stock solution is filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically resolves to a housing capable of holding the size of the filter membrane being used.",
				Category->"Filtration"
			},
			{
				OptionName->Autoclave,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates that this stock solution should be treated at an elevated temperature and pressure (autoclaved) once all components are added.",
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

			{
				OptionName->ContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description->"The container model in which the newly-made stock solution sample should reside following all preparative steps.",
				ResolutionDescription->"Automatically selected from ECL's stocked containers based on the volume of solution being prepared.",
				Category->"Storage Information"
			},

			(* --- Formula ONLY options (keep consistent with UploadStockSolution!!!) --- *)

			{
				OptionName->StockSolutionName,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size -> Line,
					BoxText -> Null
				],
				Description->"The name that should be given to the stock solution model generated from the provided formula. Note that if no model will be created (i.e., if a sample without a model is used in the formula overload), this option will be ignored.",
				Category->"Organizational Information"
			},
			{
				OptionName->MediaName,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line,
					BoxText->Null
				],
				Description->"The name that should be given to the media model generated from the provided formula. Note that if no model will be created (i.e., if a sample without a model is used in the formula overload), this option will be ignored.",
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
				ResolutionDescription->"Automatically resolves to contain the Name of the new stock solution model if generating a new stock solution model from formula input with a provided StockSolutionName, or Null otherwise. Note that if no model will be created (i.e., if a sample without a model is used in the formula overload), this option will be ignored.",
				Category->"Organizational Information"
			},
			{
				OptionName->LightSensitive,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the stock solution contains components that may be degraded or altered by prolonged exposure to light, and thus should be prepared in light-blocking containers when possible.",
				ResolutionDescription->"Automatically resolves based on the light sensitivity of the formula components and solvent if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Storage Information"
			},
			{
				OptionName->Expires,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula expire over time.",
				ResolutionDescription->"Automatically resolves to True if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Storage Information"
			},
			{
				OptionName->ShelfLife,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Day],Units->{1,{Month,{Hour,Day,Week,Month,Year}}}
				],
				Description->"The length of time after preparation that stock solutions prepared according to the provided formula are recommended for use before they should be discarded.",
				ResolutionDescription->"Automatically resolves to the shortest of any shelf lives of the formula components and solvent, or 5 years if none of the formula components expire. If Expires is set to False, resolves to Null. If preparing an existing stock solution model, resolves to Null.",
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
				Description->"The length of time after first use that stock solutions prepared according to the provided formula are recommended for use before they should be discarded.",
				ResolutionDescription->"Automatically resolves to the shortest of any unsealed shelf lives of the formula components and solvent, or Null if none of the formula components have recorded unsealed shelf lives. If Expires is set to False, resolves to Null. If preparing an existing stock solution model, resolves to Null.",
				Category->"Storage Information"
			},
			{
				OptionName -> DiscardThreshold,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent], Units -> {1, {Percent, {Percent}}}
				],
				Description -> "Indicates when samples of this stock solution are automatically discarded. Specifically, gives the percentage of the total initial volume below which samples of the stock solution will automatically be marked as AwaitingDisposal. For instance, if DiscardThreshold is set to 5% and the initial volume of the stock solution was set to 100 mL, that stock solution sample is automatically marked as AwaitingDisposal once its volume is below 5mL. Set DiscardThreshold -> 0 Percent if you never wish to auto-discard this stock solution.",
				ResolutionDescription -> "Automatically set to 5 Percent if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category -> "Storage Information"
			},
			{
				OptionName->DefaultStorageCondition,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>(AmbientStorage|Refrigerator|Freezer|DeepFreezer)
					],
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions"
							}
						}
					]
				],
				Description->"The condition in which stock solutions prepared according to the provided formula are stored when not in use by an experiment.",
				ResolutionDescription->"Automatically resolves based on the default storage conditions of the formula components and any safety information provided for this new formula. If preparing an existing stock solution model, resolves to Null.",
				Category->"New Formulation"
			},
			{
				OptionName->TransportTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					"Transport Cold" -> Widget[Type -> Quantity, Pattern :> RangeP[-86 Celsius, 10 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
					"Transport Warmed" -> Widget[Type -> Quantity, Pattern :> RangeP[27 Celsius, 105 Celsius],Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}]
				],
				Description->"Indicates the temperature by which stock solutions prepared according to the provided formula should be heated or chilled during transport when used in experiments.",
				Category->"Storage Information"
			},
			{
				OptionName -> HeatSensitiveReagents,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials"
								}
							}
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
				Description->"The known density of this component mixture at standard temperature and pressure.",
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
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula must be handled in a ventilated enclosure.",
				ResolutionDescription->"Automatically resolves to False if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Flammable,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula are easily set aflame under standard conditions.",
				ResolutionDescription->"Automatically resolves to False if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Acid,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically resolves to False if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Base,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically resolves to False if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Health & Safety"
			},
			{
				OptionName->Fuming,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if stock solutions prepared according to the provided formula emit fumes spontaneously when exposed to air.",
				ResolutionDescription->"Automatically resolves to False if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
				Category->"Health & Safety"
			},
			{
				OptionName->IncompatibleMaterials,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					With[{insertMe=Flatten[MaterialP]},Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[insertMe]]],
					Widget[Type->Enumeration, Pattern:>Alternatives[{None}]]
				],
				Description->"A list of materials that would be damaged if contacted by this formulation.",
				ResolutionDescription->"Automatically resolves to None if generating a new stock solution model from formula input, or to Null if preparing an existing stock solution model.",
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
				Description->"Indicates if centrifugation should be avoided for stock solutions of this model.",
				Category->"Compatibility"
			},
			{
				OptionName->SafetyOverride,
				Default->False,
				Description-> "Indicates if the automatic safety checks should be overridden when making sure that the order of component additions does not present a laboratory hazard (e.g. adding acids to water vs water to acids). If this option is set to True, you are certifying that you are sure the order of component addition specified will not cause a safety hazard in the lab.",
				AllowNull->True,
				Category->"Compatibility",
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
			},
			(* Index-matched hidden option for determining whether to output Model[Sample,StockSolution] or Model[Sample,Media] when a new model sample is created in the process of calling ExperimentStockSolution *)
			{
				OptionName->Type,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>StockSolutionSubtypeP
				],
				Description->"The Constellation type that the new model sample created from this protocol should have, Model[Sample,StockSolution] or Model[Sample,Media].",
				ResolutionDescription->"Automatically set to the type of the parent Upload function (i.e. UploadStockSolution, UploadMedia).",
				Category->"Hidden"
			},
			{
				OptionName->PlateMedia,
				Default->False,
				Description->"Indicates if the prepared media is subsequently transferred to plates for future use for cell incubation and growth.",
				AllowNull->False,
				Category->"Hidden",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			(*{
				OptionName->PlatingMethod,
				Default->Null,
				Description->"Indicates how the liquid media will be transferred from its preparatory container to the incubation plates. Pumping will be performed using a serial filler instrument, which utilizes a peristaltic pump device to transfer the media from a bottle into incubation plates. In Pouring, media will be transferred to incubation plates using a serological pipette.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>MediaPlatingMethodP
				]
			},
			{
				OptionName->PlatingInstrument,
				Default->Null,
				Description->"The instrument used to pump liquid media from its source container into incubation plates.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Instrument,PlatePourer],Object[Instrument,PlatePourer]}](*,
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Instruments",
								"Cell Culture",
								"Plate Pourer"
							}
						}*)
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			}, *)
			{
				OptionName->PrePlatingIncubationTime,
				Default->Null,
				Description->"The duration of time for which the media will be heated/cooled with optional stirring to reach the target PlatingTemperature.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,$MaxExperimentTime],
						Units->{1,{Minute,{Minute,Hour}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->MaxPrePlatingIncubationTime,
				Default->Null,
				Description->"The maximum duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature. If the media is not liquid after the PrePlatingIncubationTime, it will be allowed to incubate further and checked in cycles of PrePlatingIncubationTime up to the MaxIncubationTime to see if it has become liquid and can thus be poured. If the media is not liquid after MaxPrePlatingIncubationTime, the plates will not be poured, and this will be indicated in the PouringFailed field in the protocol object.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,$MaxExperimentTime],
						Units->{1,{Minute,{Minute,Hour}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->PrePlatingMixRate,
				Default->Null,
				Description->"The rate at which the stir bar within the liquid media is rotated prior to pumping the media into incubation plates.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[$MinMixRate,$MaxMixRate],
						Units->RPM
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->PlatingTemperature,
				Default->Null,
				Description->"The temperature at which the autoclaved media with gelling agents is incubated prior to and during the media plating process.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$AmbientTemperature,$MaxTemperatureProfileTemperature],
					Units->{1,{Celsius,{Celsius,Fahrenheit}}}
				],
				ResolutionDescription->"Automatically set to the lesser of 75 degrees Celsius or 5 degrees Celsius below the ContainersOut model's MaxTemperature if MediaPhase is set to Solid/SemiSolid and/or if GellingAgents is specified."
			},
			(* {
				OptionName->PumpFlowRate,
				Default->Null,
				Description->"The volume of liquid media pumped per unit time from its source container into PlateOut by the serial filler instrument.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Milliliter/Second,8*Milliliter/Second],
					Units->CompoundUnit[
						{1,{Milliliter,{Microliter,Milliliter,Liter}}},
						{-1,{Second,{Second,Minute,Hour}}}
					]
				]
			}, *)
			{
				OptionName->PlatingVolume,
				Default->Null,
				Description->"The volume of liquid media transferred from its source container into each ContainerOut.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Milliliter,$MaxTransferVolume],
						Units->Milliliter
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->CoolingTime,
				Default->Null,
				Description->"The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,1*Day],
						Units->{1,{Hour,{Hour,Day}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->PlatedMediaShelfLife,
				Default->Null,
				Description->"The duration of time after which the prepared plates are considered to be expired.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Day],
						Units->{1,{Week,{Hour,Day,Week,Month,Year}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None,Automatic]
					]
				]
			},
			{
				OptionName->SolidificationTime,
				Default->Null,
				Description->"The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,1*Day],
						Units->{1,{Hour,{Hour,Day}}}
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[None]
					]
				]
			},
			(* Hidden options from ExperimentMedia *)
			{
				OptionName->PlateOut,
				Default->Null,
				Description->"The types of plates into which the prepared media will be transferred.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					"New Plate"->Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Container,Plate]],
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Containers",
								"Plates",
								"Cell Incubation Plates"
							}
						}
					],
					"New Plate with Index"->{
						"Index"->Widget[
							Type->Number,
							Pattern:>GreaterEqualP[1,1]
						],
						"Plate"->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Container,Plate]]
						]
					},
					"Existing Plate"->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Container,Plate]]
					]
					(* list of Object[Container,Plate] *)
				]
			},
			{
				OptionName->NumberOfPlates,
				Default->Null,
				Description->"The number of plates to which the prepared media should be transferred.",
				AllowNull->True,
				Category->"Hidden",
				Widget->Alternatives[
					Widget[
						Type->Number,
						Pattern:>GreaterEqualP[0]
					]
				]
			}
		],
		{
			OptionName->PreFiltrationImage,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
			Description->"If filtration is being done indicates if the stock solutions being prepared should be imaged before filtration, otherwise this option must be set to False.",
			ResolutionDescription->"Defaults to True whenever a stock solution is being filtered.",
			Category->"Filtration"
		},

		(* --- Shared Standard Protocol Options --- *)
		ProtocolOptions,
		{
			OptionName->MaxNumberOfOverfillingRepreparations,
			Default->Automatic,
			Description->"The maximum number of times the StockSolution protocol can be repeated in the event of target volume overfilling in the FillToVolume step of the stock solution preparation. When a repreparation is triggered, the same inputs and options are used, and the value of MaxNumberOfOverfillingRepreparations is decreased by 1. If this value is set to Null, the protocol will complete normally, even if the final sample volume exceeds the target.",
			ResolutionDescription -> "For a new StockSolution protocol, automatically set to 3 if there is a FillToVolume step. When a repeat protocol is enqueued, the value is decremented by 1 from the current MaxNumberOfOverfillingRepreparations. For all other cases, set to Null.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,3]
			]
		},
		NonBiologyPostProcessingOptions,
		SamplesOutStorageOption,
		PrewetLabwareOptions,


		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"Number of times each of the inputs should be made using identical experimental parameters.",
			AllowNull->True,
			Category->"Protocol",
			Widget -> Widget[Type->Number, Pattern:>GreaterEqualP[2, 1]]
		},

		(* --- Hidden Options --- *)
		{
			OptionName->PreparedResources,
			Default->{},
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ListableP[ObjectP[Object[Resource,Sample]]],ObjectTypes->{Object[Resource,Sample]}],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			],
			Description->"Resources in the ParentProtocol that will be satisfied by preparation of the requested models and volumes of stock solution.",
			Category->"Hidden"
		},
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		SimulationOption
	}
];

Error::DeprecatedStockSolutions="The requested stock solution(s) (`1`) are marked as deprecated and thus are not available for preparation at this time. Please either remove these models from the input list, or check the AlternativePreparations to see if any other related models are stil available for preparation.";
Error::NonPreparableStockSolutions="The requested stock solution(s) (`1`) are marked as not preparable and thus cannot be prepared by ExperimentStockSolution.  These stock solutions are only generated by ExperimentSamplePreparation and cannot be prepared in ExperimentStockSolution.";
Error::StockSolutionTooManySamples = "The (number of input models/formulas * NumberOfReplicates) are above the maximum allowed in one StockSolution protocol. Please select fewer than `1` stock solutions to run this protocol, or split the requested protocol into multiple ExperimentStockSolution calls.";
Warning::FormulaOptionsUnused="The options `1` have been specifically set; however, these options only apply when a new stock solution formula is provided as input in order to upload and prepare a new stock solution model. Since existing stock solution models were provided as input, these options will be unused.";
Error::MultipleFixedAmountComponents="The formula `1` contains more than one FixedAmounts components that require resuspension in their original containers. Please make sure there is at most only one FixedAmounts component in a stock solution formula.";
Error::InvalidPreparationInResuspensionContainer="There is no FixedAmounts component in the formula `1`. If the stock solution is prepared in the original container of a FixedAmounts component (PreparationInResuspensionContainer -> True), please make sure there is a FixedAmounts component in the formula.";
Error::InvalidResuspensionAmounts="The requested amount `1` after scaling for `3` doesn't match to any allowed fixed amounts `2` of the component, when PrepareInResuspensionContainer is resolved to True. Please set PrepareInResuspensionContainer to False, or make sure that the requested amount of the FixedAmounts component after scaling is allowed for the sample.";
Error::VolumeNotInIncrements="The requested Volume of `1`, `2`, is not a member of the specific allowed volumes of this model that can be prepared due to one or more components having fixed quantities. These allowed volumes are `3`. Please either set the Volume option to one of these values, or leave it Automatic.";
Error::VolumeOverMaxIncrement="The requested Volume of `1`, `2`, is larger than the largest member of VolumeIncrements for that model (`3`). The resource `4` is requesting this invalid volume. This resource will need to be updated to request less volume in order to proceed.";
Error::ComponentsScaledOutOfRange="The requested Volumes of `1`, `2`, would require the components `3` to be measured in the amounts `4`. These amounts fall outside of the range for which accurate measurement is possible in ECL at this time (`5` to `6` for solids, and `7` to `8` for liquids). Please either adjust the requested Volume, or leave it Automatic so the stock solution can be prepared exactly according to its formula.";
Error::BelowFillToVolumeMinimum="The requested Volume(s) of `1`, `2`, are below the minimum fill-to volume that can ensure accurate empirical volume measurements (`3`) when filling to the requested volume with solvent. Please either set the volume to at least `3` or to Automatic.";
Error::AboveVolumetricFillToVolumeMaximum="The requested Volume(s) of `1`, `2`, are above the maximum volume of any volumetric flasks currently available`3`. Please lower the Volume or set it to Automatic.";
Error::BelowpHMinimum="The requested Volume of `1`, `2`, is below the minimum volume for a pH-titrated solution (`3`), due to pH probe size. Please either set the Volume option to at least `3` or to Automatic.";
Error::IncompatibleStockSolutionContainerOut="The following stock solution models(s) `1` are incompatible with the specified ContainerOut `2`. Please check the IncompatibleMaterials field of the stock solution model and the ContainerMaterials field of the containers to a compatible ContainerOut, or allow the ContainerOut to be determined automatically";
Error::DeprecatedContainerOut="The requested ContainerOut option (`1`) is marked as deprecated and thus not available to serve as a stock solution container at this time. Please either replace this container with a non-deprecated models (consider using the PreferredContainer function with your desired stock solution volume), or allow the ContainerOut to be determined automatically based on the Volume of stock solution(s) being prepared.";
Error::ContainerOutTooSmall="The provided ContainerOut option `1` for holding `2` has a MaxVolume of `3`. However, `4` of `2` was requested, so this ContainerOut will not be able to accommodate the volume of solution prepared. Additionally, the volume must be less than 3/4 of the MaxVolume of the container if this stock solution is also being autoclaved. Please request a smaller volume of this solution, request a larger ContainerOut, or allow one or both of the ContainerOut/Volume options to resolve automatically.";
Error::ContainerOutMaxTemperature="The provided ContainerOut option `1` for holding `2` has a MaxTemperature of `3`. However, a MaxTemperature of 120 Celsius (or higher) is required if the stock solution need to be autoclaved. Please choose another ContainerOut or let this option automatically resolve.";
Warning::VolumeOptionUnused="The Volume option was set to the specific volume `1`, but the provided formula has a total/fill-to volume of `2`. The Volume option will be unused and the stock solution prepared according to the provided formula.";
Error::MixOptionConflict="The Mix parameters `1` are specified for `2`; however, the overall Mix boolean is set to False. Please either do not specify any mixing parameters if Mix is set to False, or set Mix to True to enable specification of mixing parameters.";
Error::PostAutoclaveMixOptionConflict="The PostAutoclaveMix parameters `1` are specified for `2`; however, the overall PostAutoclaveMix boolean is set to False. Please either do not specify any mixing parameters if PostAutoclaveMix is set to False, or set PostAutoclaveMix to True to enable specification of mixing parameters.";
Error::IncubateOptionConflict="The Incubate parameters `1` are specified for `2`; however, the overall Incubate boolean is set to False. Please either do not specify any incubation parameters if Incubate is set to False, or set Incubate to True to enable specification of incubation parameters.";
Error::PostAutoclaveIncubateOptionConflict="The PostAutoclaveIncubate parameters `1` are specified for `2`; however, the overall PostAutoclaveIncubate boolean is set to False. Please either do not specify any incubation parameters if PostAutoclaveIncubate is set to False, or set PostAutoclaveIncubate to True to enable specification of incubation parameters.";
Error::FilterOptionConflict="The Filter parameters `1` are specified for `2`; however, the overall Filter boolean is set to False. Please either do not specify any filtration parameters if Filter is set to False, or set Filter to True to enable specification of filtration parameters.";
Error::VolumeBelowFiltrationMinimum="The volume of the provided stock solution(s) `1` (`2`) either the requested total volume after solvent addition, or, for a components-only formula, the sum of liquid component amounts), is lower than the minimum volume that can currently be filtered due to available filtration methods and their dead volumes (`3`). Please scale up the component amounts requested such that the total volume is at least `3`, or do not request filtration for this solution.";
Error::NoFiltrationImaging="Since none of the stock solutions being prepared are set to be filtered PreFiltrationImage must be set to False. Please set Filter to True or PreFiltrationImage to False.";
Error::VolumeBelowpHMinimum="The volume of the provided stock solution(s) `1` (`2`; either the requested total volume after solvent addition, or, for a components-only formula, the sum of liquid component amounts), is lower than the minimum volume that can currently be pH-titrated due to pH probe size (`3`). Please scale up the component amounts requested such that the total volume is at least `3`, or do not request pH titration for this solution.";
Error::NopH="The pH, MinpH, MaxpH, pHingAcid, and/or pHingBase options were specified for the following stock solution(s): `1`, but AdjustpH was set to False. Please set AdjustpH to True, or leave it blank to be set automatically.";
Error::pHOrderInvalid="The provided MinpH, NominalpH, and MaxpH options are not in increasing order for the following stock solution(s): `1`. Please ensure that, when providing 2 or more of MinpH, NominalpH, and MaxpH, the ordering MinpH < NominalpH < MaxpH is followed.";
Error::SynonymsNoName="The Synonyms option is set `1`, but no Name was provided for the corresponding solution(s). Please provide a main Name in order to associate Synonyms with these new formulation(s).";
Error::DuplicateNames="The StockSolutionName option contains duplicates. The name of each stock solution  model must be unique, and so if specifying a name for each input, please ensure that they are unique.";
Error::ComponentAmountOutOfRange="The requested amount of `1`, `2`, is outside of the allowed range of component amounts in new stock solutions (`3`, `4` for solids, `5`, `6` for liquids).  Please scale this formula up or down to stay within this range.";
Error::MixTimeIncubateTimeMismatch="MixTime `1` and IncubationTime `2` were both specified for `3`, but if these options are both specified, they must be the same.  Consider leaving one as Automatic, or changing them to be equal to each other.";
Error::PostAutoclaveMixTimeIncubateTimeMismatch="PostAutoclaveMixTime `1` and PostAutoclaveIncubationTime `2` were both specified for `3`, but if these options are both specified, they must be the same.  Consider leaving one as Automatic, or changing them to be equal to each other.";
Error::MixIncubateInstrumentMismatch="Mixer `1` and Incubator `2` were both specified for `3`, but if these options are both specified, they must be the same.  Consider leaving one as Automatic, or changing them to be equal to each other.";
Error::PostAutoclaveMixIncubateInstrumentMismatch="PostAutoclaveMixer `1` and PostAutoclaveIncubator `2` were both specified for `3`, but if these options are both specified, they must be the same.  Consider leaving one as Automatic, or changing them to be equal to each other.";
Error::IncompletelySpecifiedpHingOptions="If a pH is specified, MinpH, MaxpH, pHingAcid, and pHingBase must not be Null. Please make sure these options are not set to Null if a pH is specified.";
Error::ContainerOutCannotBeFound="A container cannot be found to prepare `1` with the required volume of `2`. The container cannot be more than 75% full for autoclaved stock solutions and 93% full for solutions whose pH needs to be adjusted.";
Error::AutoclaveHeatSensitiveConflict="`1` was specified for HeatSensitiveReagents, but this option must be set to {} or Null when Autoclave is set to False. Please either set Autoclave to True or do not set HeatSensitiveReagents.";
Error::InvalidUnitOperationsInput = "Currently the input only contains LabelContainer primitive(s), which is allowed for option-resolving purpose in CommandCenter Desktop, but will fail when attempt to generate a protocol. Please continue adding more primitives.";

(* formerly USSM messages, but now in the real experiment function *)
Error::AcidBaseConflict="The Acid and Base options have both been set to True. These options cannot simultaneously be true, as dedicated secondary containment for acids and bases are separated. Please make sure at most one of these options is set to True.";
Error::ComponentAmountInvalid="The amount of formula component `1` (`2`) is inconsistent with the component's recorded state (`3`; check the State field). Please provide liquid components with amounts in units of volume, and solid components with amounts in units of mass.";
Error::ComponentRequiresTabletCount="The formula component `1` is in tablet form. Please specify this formula component with an amount that is a count of tablets to include in the stock solution (i.e. a positive integer).";
Error::ComponentStateInvalid="The formula component `1` is neither a solid nor a liquid (check the State field, currently recorded as `2`). Please provide only solids and liquids as formula components.";
Error::DeprecatedComponents="The formula components `1` are deprecated and not available for inclusion in stock solutions (check the Deprecated field). Please provide components that are currently active for use in the ECL.";
Error::DuplicatedComponents="The formula components `1` are duplicated in the provided formula. Please provide a stock solution formula with unique components.";
Error::ExpirationShelfLifeConflict="The Expires option is set to False, but one or both of the ShelfLife/UnsealedShelfLife options have been set. Please only set shelf lives if the stock solution expires.";
Error::FormulaVolumeTooLarge="The total volume of formula components specified with amounts in units of volume (`1`) equals or exceeds the requested total volume of the solution (`2`). Please either increase the total volume, reduce the volumes of formula components, or do not specify a total volume and allow the calculated formula volume to be used.";
Error::SolventNotLiquid="The solvent `1` is not in the liquid state, and instead is recorded as having a state of `2` (check the State field). Please provide a solvent that is a liquid.";
Warning::ComponentStateUnknown="The formula component `1`'s State is unknown; the component's amount has not been validated.";
Warning::UnsealedShelfLifeLonger="The provided UnsealedShelfLife value(s) `1` are longer than the provided ShelfLife value(s) `2`.";
Error::ShelfLifeNotSpecified="The Expires option is resolved to be True based on the stock solution components, but one or both of the ShelfLife/UnsealedShelfLife options have been set to Null. Please be sure to specify the ShelfLife/UnsealedShelfLife of a sample if it expires. Long shelf lives are fine if you expect a stock solution to be stable.";
Error::TemplatesPreperationTypeConflict="The provided templates are both formula- and UnitOperations-based. Please split the ExperimentStockSolution calls to have a call for each preparation type (Formula-based: `1` ; UnitOperations-based: `2`).";
Error::InvalidModelFormulaForFillToVolume="For the input formula or the formula of the input stock solution model, `1`, the combined total volume of its components is `2`, which is equal to or exceeds the model's specified TotalVolume of `3`. The combined total volume of components must not exceed the TotalVolume, as the TotalVolume is meant to be achieved by adding the FillToVolumeSolvent `4` after combining all components in the formula. Please update the formula input or the relevant fields in the model.";
Warning::VolumeTooLowForAutoclave = "The provided stock solution(s) `1` has specified volumes of, `2`, which are lower than 100 Milliliter while Autoclave is True. Autoclaving small volumes may result in inaccurate prepared volume and compositions. Please consider scaling up the volume.";

(* These errors are specific to redirection to this function via ExperimentMedia *)
Error::FilterSolidMedia="Filtration options are specified, but MediaPhase is Solid. Please set Filtration options to Null or MediaPhase to Liquid.";
Error::NonSterileFilterWithoutAutoclave="For this Media experiment, FilterModel is not Sterile, but Autoclave is not True. Please specify a sterile FilterModel or set Autoclave to True.";
Warning::ModelStockSolutionMixRateNotSafe = "The specified stock solution model has a mix rate of `1`, which is larger than the maximum safe mix rate that can be reached by stir mixing. The max safe mix rate for the desired container model is `2`, so mix rate `2` will be used in this protocol instead."
Error::SpecifedMixRateNotSafe = "The specified mix rate (`1`) exceeds the MaxOverheadMixRate of the resolved container. Please consider about using a smaller mix rate to avoid overflow or spillage during mixing.";

(* Feature Flag *)
(* $ExperimentStockSolutionMedia - Indicates if we should allow ExperimentStockSolution to be used for preparing Model[Sample,Media]. This is temporarily allowed before ExperimentMedia is fully released *)
$ExperimentStockSolutionMedia=True;

(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolution*)


(* hard-code the model types that can be prepared via stock solution *)
stockSolutionModelTypes={Model[Sample,StockSolution],Model[Sample,Media],Model[Sample,Matrix]};


(*
	--- OVERLOAD 1: Single Model
		- Passes to OVERLOAD 2
*)
ExperimentStockSolution[myModelStockSolution:ObjectP[stockSolutionModelTypes],myOptions:OptionsPattern[ExperimentStockSolution]]:=ExperimentStockSolution[{myModelStockSolution},myOptions];


(*
	--- OVERLOAD 2 (MODELS CORE): List of Models
		- Resolves options
		- Calls USSM in case we need to make a new stock solution from it
*)
ExperimentStockSolution[myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..},myOptions:OptionsPattern[ExperimentStockSolution]]:=Module[
	{
		listedOptions, outputSpecification, listedOutput, gatherTests, unresolvedOptions, applyTemplateOptionTests,
		safeOptions, safeOptionTests, validLengths, validLengthTests, specifiedContainerOut, containerOutObjects,
		preparedResources, parentProtocol, stockSolutionDownloadTuples, containerOutDownloadTuples, combinedOptions,
		preparedResourceDownloadTuples, parentProtocolDownloadTuple, newCache, resolveOptionsResult,
		returnEarlyQ, resolvedPreparationVolumes, resolvedDensityScouts, resolvedOptionsNoPrepVolume, ussmExperimentSharedOptionNames,
		ussmOptionsPerModel, allUploadStockSolutionModelOutputs, stockSolutionModelsToPrepare, safeOpsWithNames, listedStockSolutions,
		ussmTests, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolutionTests, rootProtocolPacket,unitOpsQ,
		allDownloadValues, samplesIn, finalizedPackets, frqTests, uploadProtocolOptions, protocolPacket, extraPackets,
		allTests, validQ, expandedCombinedOptions, specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes,
		specifiedMaxNumMixes, optionalMixOptions, failedUSSQ, modelStockSolutionsWithoutTemporalLinks, optionsWithoutTemporalLinks,
		titrants,allEHSFields,allComponentFields,titrantsPackets, resolvedOptionsMixRateUpdate
	},

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{modelStockSolutionsWithoutTemporalLinks, optionsWithoutTemporalLinks} = removeLinks[myModelStockSolutions, ToList[myOptions]];

	(* set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentStockSolution, {modelStockSolutionsWithoutTemporalLinks}, optionsWithoutTemporalLinks, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentStockSolution, {modelStockSolutionsWithoutTemporalLinks}, optionsWithoutTemporalLinks, 1], {}}
	];

	(* If some hard error was encountered in getting template, return early with the requested output  *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> applyTemplateOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOpsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentStockSolution, optionsWithoutTemporalLinks, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentStockSolution, optionsWithoutTemporalLinks, AutoCorrect -> False], {}}
	];

	(* change all Names to objects *)
	{listedStockSolutions, safeOptions, listedOptions} = sanitizeInputs[modelStockSolutionsWithoutTemporalLinks, safeOpsWithNames, optionsWithoutTemporalLinks, Simulation -> Lookup[optionsWithoutTemporalLinks, Simulation, Null]];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* make sure options are the right length; we are in the index-matching case, first overload *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentStockSolution, {listedStockSolutions}, safeOptions, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentStockSolution, {listedStockSolutions}, safeOptions, 1], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[!validLengths,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests, validLengthTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* get the ContainerOut option; we need to download some stuff if anything was specified; Cases works even if ContainerOut is singleton, returns a list *)
	specifiedContainerOut = Lookup[combinedOptions, ContainerOut];
	containerOutObjects = Join[
		Cases[ToList[specifiedContainerOut], ObjectP[]],
		PreferredContainer[All],
		PreferredContainer[All, LightSensitive -> True]
	];
	(* get the PreparedResources option; this is hidden, ASSUME it is index-matched if present; sent in by Engine when doing ResourcePrep *)
	preparedResources = Lookup[combinedOptions, PreparedResources];

	(* find the parent protocol; may need it to resolve the ImageSample option *)
	parentProtocol = Lookup[combinedOptions, ParentProtocol];

	(* find the pHing acid and base specified and the ones we are defaulting too-- we need to know if the are solid or liquid *)
	titrants = Join[
		Cases[Lookup[combinedOptions,{pHingAcid,pHingBase}],ObjectP[{Object[Sample],Model[Sample]}]],
		{Model[Sample, StockSolution, "1.85 M NaOH"], Model[Sample, StockSolution, "2 M HCl"], Model[Sample, StockSolution,"6N hydrochloric acid"]}
	]//DeleteDuplicates;

	(* Get all of the EHS fields that need to be updated. *)
	allEHSFields=ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]]/.{StorageCondition->DefaultStorageCondition};
	allComponentFields=DeleteDuplicates[Flatten[{Name, Deprecated, State, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet, FixedAmounts, UltrasonicIncompatible, CentrifugeIncompatible, Acid, Base, Composition, Density, Solvent, allEHSFields}]];

	(* download required information from the models, containers, and prepared resources; Quiet for the Tablet field from the Formula *)
	allDownloadValues = Check[
		Quiet[
			Download[
				{
					listedStockSolutions,
					containerOutObjects,
					preparedResources,
					{parentProtocol},
					titrants
				},
				{
					{
						Packet[
							Name, Deprecated, Formula, FillToVolumeSolvent, FillToVolumeMethod, TotalVolume, Sterile, State, Tablet,

							MixUntilDissolved, MixTime, MaxMixTime, MixType, MixRate, Mixer, NumberOfMixes, MaxNumberOfMixes,
							PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixRate, PostAutoclaveMixType,
							PostAutoclaveMixer, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes,

							NominalpH, MinpH, MaxpH, pHingAcid, pHingBase, MaxNumberOfpHingCycles, MaxpHingAdditionVolume, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle,

							FilterMaterial, FilterSize,

							IncubationTime, IncubationTemperature,
							PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature,

							PreferredContainers, VolumeIncrements, FulfillmentScale, Preparable, Resuspension,

							LightSensitive, Expires, ShelfLife, UnsealedShelfLife, DiscardThreshold, DefaultStorageCondition,
							TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Pyrophoric,
							Fuming, IncompatibleMaterials, UltrasonicIncompatible, CentrifugeIncompatible,

							Autoclave, AutoclaveProgram,
							PrepareInResuspensionContainer, FillToVolumeParameterized,
							OrderOfOperations, UnitOperations, PreparationType, Composition, DefaultStorageCondition, HeatSensitiveReagents
						],
						Packet[DefaultStorageCondition[{StorageCondition}]],
						Packet[Formula[[All, 2]][allComponentFields]],
						Packet[Formula[[All, 2]][DefaultStorageCondition][{StorageCondition}]],
						Packet[FillToVolumeSolvent[allComponentFields]],
						Packet[FillToVolumeSolvent[DefaultStorageCondition][{StorageCondition}]],
						Packet[pHingAcid[State]],
						Packet[pHingBase[State]],
						Packet[PreferredContainers[{Name, Deprecated, MaxVolume, MinVolume, VolumeCalibrations, PreferredMixer, InternalDimensions, MaxTemperature, Dimensions, ContainerMaterials}]]
					},
					{
						Packet[Name, Deprecated, MaxVolume, MinVolume, VolumeCalibrations, PreferredMixer, InternalDimensions, MaxTemperature, Dimensions, Resolution, ContainerMaterials, MaxOverheadMixRate]
					},
					{
						Packet[RentContainer]
					},
					{
						Packet[Author, ImageSample, ParentProtocol],
						Packet[Repeated[ParentProtocol][{Author, ImageSample, ParentProtocol}]]
					},
					{
						Packet[State]
					}
				},
				Date -> Now
			],
			{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allDownloadValues, $Failed],
		Return[$Failed]
	];

	(* split out the values from the Download *)
	{stockSolutionDownloadTuples, containerOutDownloadTuples, preparedResourceDownloadTuples, {parentProtocolDownloadTuple},titrantsPackets} = allDownloadValues;

	(* get the root protocol packet *)
	rootProtocolPacket = If[NullQ[parentProtocol],
		Null,
		SelectFirst[Flatten[parentProtocolDownloadTuple], NullQ[Lookup[#, ParentProtocol]]&, Null]
	];

	(* we don't want to pull the formula if were handling unit-ops based stock solutions. so lets make sure thats not the case *)
	unitOpsQ =Map[MatchQ[#, KeyValuePattern[PreparationType->UnitOperations]]&, stockSolutionDownloadTuples[[All, 1]]];

	(* pull out the Formula components from the download tuples which will end up being the SamplesIn *)
	(* a little complicated but basically just get the formula specifically from the download tuple, and then pull out just the models from that *)
	(* need to include the solvent here if it exists *)
	samplesIn = DeleteCases[Flatten[Map[
		{Lookup[#, Formula][[All, 2]], Lookup[#, FillToVolumeSolvent]}&,
		PickList[stockSolutionDownloadTuples[[All, 1]],unitOpsQ, False]
	]], Null];

	(* combine the cache together *)
	newCache = FlattenCachePackets[{stockSolutionDownloadTuples,containerOutDownloadTuples,preparedResourceDownloadTuples,parentProtocolDownloadTuple,titrantsPackets}];

	(* resolve options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and will return early *)
	(* Note: If listedStockSolutions is a StockSolution model with mix rate larger than safe mix rate, we want to use MaxOverheadMixRate instead. But we do not give the resolvedMixRate as option here to prevent it from generating new StockSolution model. *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveStockSolutionOptions[listedStockSolutions, ReplaceRule[combinedOptions, {Output -> {Result, Tests}, Cache -> newCache}]],
			{resolveStockSolutionOptions[listedStockSolutions, ReplaceRule[combinedOptions, {Output -> Result, Cache -> newCache}]], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];
	(* figure out if we want to return early or not *)
	returnEarlyQ = If[gatherTests,
		Not[RunUnitTest[<|"Tests" -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests}]|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		MatchQ[resolveOptionsResult, $Failed]
	];

	(* modify mix rate if necessary *)
	resolvedOptionsMixRateUpdate = If[MatchQ[resolveOptionsResult, $Failed],
		resolvedOptions,
		Module[{safeMaxMixRates, resolvedMixRates, resolvedMixTypes, resolvedPostAutoclaveMixRates, resolvedPostAutoclaveMixTypes, postResolvedMixRates, postResolvedPostAutoclaveMixRates},
			(* We want to use safe mix rate for over head stirrer so if the model provided mix rate is over safe mix rate, we want to replace it and give warning *)
			(* find out the safe mix rate of resolved container out -- It is very unlikely that MaxOverheadMixRate is Null for PreferredContainer *)
			safeMaxMixRates = Lookup[fetchPacketFromCache[#1, Flatten[containerOutDownloadTuples]], MaxOverheadMixRate, Null] &/@ Lookup[resolvedOptions, ContainerOut];
			(* find out the mix rate, mix type, and post autoclave mix rate and mix type *)
			resolvedMixRates = ToList[Lookup[resolvedOptions, MixRate]];
			resolvedMixTypes = ToList[Lookup[resolvedOptions, MixType]];
			resolvedPostAutoclaveMixRates = ToList[Lookup[resolvedOptions, PostAutoclaveMixRate]];
			resolvedPostAutoclaveMixTypes = ToList[Lookup[resolvedOptions, PostAutoclaveMixType]];

			(* replace the mix rate to be a safe value if necessary *)
			postResolvedMixRates = MapThread[
				Which[
					MatchQ[#3, Except[Stir]],
					(* if we are not using Stir, keep the resolved mix rate *)
					#2,

					(NullQ[#1]||(#1 > #2)),
					(* if resolved mix rate from given stock solution model is safe, take it to use *)
					(* Note: we add NullQ check for safe mix rate to avoid crashing, but actually it is unlikely to have Null since this container is from PreferredContainer *)
					#2,

					True,
					(* otherwise, give a warning and resolve to max safe mix rate *)
					If[Not[MatchQ[$ECLApplication,Engine]],
						Message[Warning::ModelStockSolutionMixRateNotSafe, #2, #1]
					];
					(* we need to update the mix rate to use safe value *)
					#1
				]&,
				{safeMaxMixRates, resolvedMixRates, resolvedMixTypes}
			];
			(* do the same thing for post autoclave *)
			postResolvedPostAutoclaveMixRates = MapThread[
				Which[
					MatchQ[#3, Except[Stir]],
					(* if we are not using Stir, keep the resolved mix rate *)
					#2,

					(NullQ[#1]||(#1 > #2)),
					(* if resolved mix rate from given stock solution model is safe, take it to use *)
					(* Note: we add NullQ check for safe mix rate to avoid crashing, but actually it is unlikely to have Null since this container is from PreferredContainer *)
					#2,

					True,
					(* otherwise, give a warning and resolve to max safe mix rate *)
					If[Not[MatchQ[$ECLApplication,Engine]],
						Message[Warning::ModelStockSolutionMixRateNotSafe, #2, #1]
					];
					(* we need to update the mix rate to use safe value *)
					#1
				]&,
				{safeMaxMixRates, resolvedPostAutoclaveMixRates, resolvedPostAutoclaveMixTypes}
			];
			(* update resolved options *)
			ReplaceRule[resolvedOptions, {PostAutoclaveMixRate -> resolvedPostAutoclaveMixRates, MixRate -> postResolvedMixRates}]
		]
	];

	(* pull out the PreparatoryVolumes option from the resolved options, and get a resolved options list without it since it isn't _really_ an option *)
	(* Also pull out the 'Type' option *)
	resolvedPreparationVolumes = Lookup[resolvedOptionsMixRateUpdate, PreparatoryVolumes];
	resolvedDensityScouts = Lookup[resolvedOptionsMixRateUpdate, DensityScouts];
	resolvedOptionsNoPrepVolume = Select[resolvedOptionsMixRateUpdate, Not[MatchQ[Keys[#], Alternatives[PreparatoryVolumes,DensityScouts,Type]]]&];

	(* need to return early if something bad happened because we're FastTracking USSM below and that would trainwreck otherwise *)
	If[returnEarlyQ,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests}],
				Preview -> Null,
				Options -> resolvedOptionsNoPrepVolume
			}
		]
	];


	(* --- Generate the options we are actually going to pass to UploadStockSolution --- *)


	(* expand the combined options *)
	(* it doesn't matter if we are filling to volume or not; in either case, the index matching is the same, so just do it in the simpler way where it's not fill to volume *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution, {listedStockSolutions}, combinedOptions, 1]];

	(* pull out the specified values of MixType/Mixer/MixRate before resolution *)
	{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes} = Lookup[expandedCombinedOptions, {MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}];

	(* decide if we are going to pass the MixType/Mixer/MixRate down to UploadStockSolution *)
	(* basically, if MixType was specified, then pass down whichever of the three of MixType/Mixer/MixRate/NumberOfMixes/MaxNumberOfMixes was specified down to UploadStockSolution *)
	(* if it was not, then pass down nothing *)
	optionalMixOptions = MapThread[
		If[MatchQ[#1, MixTypeP],
			Flatten[{MixType, PickList[{Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}, {#2, #3, #4, #5}, Except[Automatic|Null]]}],
			{}
		]&,
		{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes}
	];


	(* assign the names of options that are identical between USSM and ExperimentStockSolution *)
	(* DO NOT include the formula-only options *)
	ussmExperimentSharedOptionNames = Map[
		Flatten[{
			Mix, MixUntilDissolved, MixTime, MaxMixTime, #,
			AdjustpH, MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize,
			Incubate, IncubationTemperature, IncubationTime, PostAutoclaveIncubate, PostAutoclaveIncubationTemperature,
			PostAutoclaveIncubationTime, OrderOfOperations, Autoclave, AutoclaveProgram,
			FillToVolumeMethod, PrepareInResuspensionContainer,
			Type, Supplements, DropOuts, GellingAgents, MediaPhase
		}]&,
		optionalMixOptions
	];

	(* also need to prune a bit the options that we send into UploadStockSolution; some name/default differences *)
	(* although we change the mix rate in model stock solution if it exceeds the max safe mix rate, it's not change by specified option, so MixRate will not be included in optionalMixOptions. *)
	ussmOptionsPerModel = MapIndexed[
		Function[{optionNames, indexNum},
			Join[
				(* different between USSM/ExpSS *)
				{
					Name->If[ListQ[Lookup[resolvedOptionsNoPrepVolume, StockSolutionName]],
						Extract[Lookup[resolvedOptionsNoPrepVolume, StockSolutionName], indexNum],
						Lookup[resolvedOptionsNoPrepVolume, StockSolutionName]
					],

					(* bit of name inconsistency here too *)
					NominalpH -> If[ListQ[Lookup[resolvedOptionsNoPrepVolume, pH]],
						Extract[Lookup[resolvedOptionsNoPrepVolume, pH], indexNum],
						Lookup[resolvedOptionsNoPrepVolume, pH]
					],

					SafetyOverride -> If[ListQ[Lookup[resolvedOptionsNoPrepVolume, SafetyOverride]],
						Extract[Lookup[resolvedOptionsNoPrepVolume, SafetyOverride], indexNum],
						Lookup[resolvedOptionsNoPrepVolume, SafetyOverride]
					],

					(* set Output option to send to USSM; depends on if we need tests, but we ALWAYS want Reult/Options *)
					Output -> If[gatherTests,
						{Result, Tests},
						{Result}
					],

					(* pass the Author of the parent protocol in if there is one *)
					Author -> If[NullQ[rootProtocolPacket],
						Null,
						Download[Lookup[rootProtocolPacket, Author], Object]
					],

					(* we always want to NOT upload yet *)
					Upload -> False,

					(* send in passed cache plus new download cache *)
					Cache -> newCache,
					(* at this point we've already done all our error checking that UploadStockSolution is also doing, so we don't need to do it again *)
					FastTrack -> True,
					
					PreferredContainers->Extract[Lookup[stockSolutionDownloadTuples[[All,1]],PreferredContainers],indexNum]
				},

				(* same between UploadStockSolution and ExpSS; pipe 'em innnn *)
				Map[
					If[MatchQ[Lookup[resolvedOptionsMixRateUpdate, #], _List],
						# -> Extract[Lookup[resolvedOptionsMixRateUpdate, #], indexNum],
						# -> Lookup[resolvedOptionsMixRateUpdate, #]
					]&,
					optionNames
				]
			]
		],
		ussmExperimentSharedOptionNames
	];

	(* pull out all the resolved options that we are going to pass to UploadStockSolution *)
	allUploadStockSolutionModelOutputs = Check[
		MapThread[
			(* quiet warning for unsafe mix rate since we have already given a message earlier in resolveStockSolutionOptions *)
			Quiet[UploadStockSolution[#1, Sequence @@ #2], {Warning::SpecifedMixRateNotSafe}]&,
			{listedStockSolutions, ussmOptionsPerModel}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* figure out if we had any more failures when running USS *)
	failedUSSQ = If[gatherTests,
		(* think these are the right tests to run, but may need to pull more tests out of USS somehow *)
		Not[RunUnitTest[<|"Tests" -> Cases[Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests}],_EmeraldTest]|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		MatchQ[allUploadStockSolutionModelOutputs, $Failed]
	];

	(* need to return early if USS returned a bad input/option error *)
	If[failedUSSQ,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests}],
				Preview -> Null,
				(* gave this the same options output as returnEarlyQ *)
				Options -> resolvedOptionsNoPrepVolume
			}
		]
	];


	(* pull out the stock solution results and the tests *)
	stockSolutionModelsToPrepare = allUploadStockSolutionModelOutputs[[All, 1]];
	ussmTests = If[gatherTests,
		allUploadStockSolutionModelOutputs[[All, 2]],
		{}
	];

	(* call the stockSolutionResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	(* we're okay to make some protocols! use a helper for that *)
	{finalizedPackets, frqTests} = If[gatherTests,
		stockSolutionResourcePackets[
			stockSolutionModelsToPrepare,
			resolvedPreparationVolumes,
			resolvedDensityScouts,
			preparedResourceDownloadTuples[[All, 1]],
			(* need to pass down SamplesIn even though it's just a list of models here *)
			samplesIn,
			ConstantArray[Null, Length[stockSolutionModelsToPrepare]],
			ConstantArray[Null, Length[stockSolutionModelsToPrepare]],
			ReplaceRule[resolvedOptionsNoPrepVolume, {Output -> {Result, Tests}}],
			unresolvedOptions
		],
		{stockSolutionResourcePackets[
			stockSolutionModelsToPrepare,
			resolvedPreparationVolumes,
			resolvedDensityScouts,
			preparedResourceDownloadTuples[[All, 1]],
			(* need to pass down SamplesIn even though it's just a list of models here *)
			samplesIn,
			ConstantArray[Null, Length[stockSolutionModelsToPrepare]],
			ConstantArray[Null, Length[stockSolutionModelsToPrepare]],
			ReplaceRule[resolvedOptionsNoPrepVolume, {Output -> Result}],
			unresolvedOptions
		], {}}
	];

	(* --- assembling outputs time!!!  --- *)

	(* get all the options for the UploadProtocol call *)
	uploadProtocolOptions = {
		Confirm -> Lookup[resolvedOptionsNoPrepVolume, Confirm],
		CanaryBranch -> Lookup[resolvedOptionsNoPrepVolume, CanaryBranch],
		ConstellationMessage -> Object[Protocol, StockSolution],
		ParentProtocol -> Lookup[resolvedOptionsNoPrepVolume, ParentProtocol],
		Upload -> Lookup[resolvedOptionsNoPrepVolume, Upload],
		Email -> Lookup[resolvedOptionsNoPrepVolume, Email],
		FastTrack -> Lookup[resolvedOptionsNoPrepVolume, FastTrack],
		Priority -> Lookup[combinedOptions, Priority],
		StartDate -> Lookup[combinedOptions, StartDate],
		HoldOrder -> Lookup[combinedOptions, HoldOrder],
		QueuePosition -> Lookup[combinedOptions, QueuePosition]
	};

	(* get the protocol packet and, if they exist, the extra packets *)
	(* also if finalizedPackets is $Failed, set protocolPacket to that value too *)
	{protocolPacket, extraPackets} = If[MatchQ[finalizedPackets, PacketP[Object[Protocol, StockSolution]]|$Failed],
		{finalizedPackets, {}},
		{First[finalizedPackets], Rest[finalizedPackets]}
	];

	(* combine all the tests together *)
	allTests = Cases[
		Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, ussmTests, resolutionTests, frqTests}],
		_EmeraldTest
	];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[protocolPacket, $Failed], False,
		gatherTests && MemberQ[listedOutput, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* assemble our options return rule; make sure to collapse indexed when possible, and remove hiddens depending on our parent experiment *)
	optionsRule = Options -> Which[
		MemberQ[listedOutput, Options] && !NullQ[Lookup[resolvedOptionsNoPrepVolume,MediaPhase,Null]],
			Module[{finalOptionsNoType},
				(* Don't send Type back to ExperimentMedia, it is not an option there *)
				finalOptionsNoType = Normal[KeyDrop[resolvedOptionsNoPrepVolume,Type],Association];

				(* Collapse and remove media hidden options *)
				RemoveHiddenOptions[ExperimentMedia,CollapseIndexMatchedOptions[ExperimentStockSolution, finalOptionsNoType, Messages -> False, Ignore -> listedOptions]]
			],
		MemberQ[listedOutput, Options],
			RemoveHiddenOptions[ExperimentStockSolution, CollapseIndexMatchedOptions[ExperimentStockSolution, resolvedOptionsNoPrepVolume, Messages -> False, Ignore -> listedOptions]],
		True,
			Null
	];

	(* generate the Preview rule as a Nul *)
	previewRule = Preview -> Null;

	(* assemble all tess we created; a couple of these variables are lists of lists of tests so just flatten it all up *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the result rule; don't do it if ANY of our invalidity checks above were tripped *)
	resultRule = Result -> Which[
		returnEarlyQ, $Failed,
		MemberQ[listedOutput, Result] && validQ && MatchQ[extraPackets, {}], UploadProtocol[protocolPacket, uploadProtocolOptions],
		MemberQ[listedOutput, Result] && validQ, UploadProtocol[protocolPacket, extraPackets, uploadProtocolOptions],
		True, $Failed
	];

	(* return everything asked for (with original listing/non-listing!!) *)
	outputSpecification/.{optionsRule,previewRule,testsRule,resultRule}
];



(*
	--- OVERLOAD 3: Complete Formula Overload (singleton)
		- Passes to FORMULA CORE
*)
ExperimentStockSolution[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[{myFormulaSpec},{Null},{Null},myOptions];


(*
	--- OVERLOAD 3.2: Complete Formula Overload (listable)
		- Passes to FORMULA CORE
*)
ExperimentStockSolution[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[myFormulaSpecs,ConstantArray[Null, Length[myFormulaSpecs]],ConstantArray[Null, Length[myFormulaSpecs]],myOptions];



(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume, singleton)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolution[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[{myFormulaSpec},{mySolvent},{myFinalVolume},myOptions];

(*
	--- OVERLOAD 4.2: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolution[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}] | Null)..},
	myFinalVolumes:{(VolumeP | Null)..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[myFormulaSpecs,mySolvents,myFinalVolumes,myOptions];

(*
	--- OVERLOAD 4.3: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable in formula only)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolution[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[myFormulaSpecs, ConstantArray[mySolvent, Length[myFormulaSpecs]], ConstantArray[myFinalVolume, Length[myFormulaSpecs]], myOptions];

(*
	--- OVERLOAD 5: UnitOperations Overload - singleton
		- Passes to ExperimentStockSolution
*)
ExperimentStockSolution[
	myUnitOperations:{SamplePreparationP..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[{myUnitOperations}, myOptions];


(*
	--- OVERLOAD 5: UnitOperations Overload - listable
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolution[
	myUnitOperations:{{SamplePreparationP..}..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=experimentStockSolutionFormula[myUnitOperations, myOptions];


(* ::Subsubsection::Closed:: *)
(*experimentStockSolutionFormula*)


(*
	--- FORMULA CORE: Formula and Volume (handles both combine-these-reagents and fill-to-volume versions)
		- Resolves formula-only options
		- Resolves all other options
		- Creates or finds model (via UploadStockSolution)
		- Passes model to core protocol/Result function to make protocols
*)
experimentStockSolutionFormula[
	myFormulaSpecs:{{{VolumeP|MassP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}]|Null)..},
	myFinalVolumes:{(VolumeP|Null)..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=Module[
	{listedOptions, outputSpecification, listedOutput, gatherTests, unresolvedOptions, applyTemplateOptionTests,
		safeOptions, safeOptionTests, formulaOptionsResult, formulaResolvedOptions,
		formulaOptionTests, components, componentAmounts, componentsAndSolvent,providedContainerOuts,containerOutObjects,
		passedCache,flatComponentAndSolventDownloadTuples, componentAndSolventDownloadTuples,containerOutDownloadTuples,componentDownloadTuples,
		solventDownloadTupleOrNull,componentPackets,componentSCPackets,solventPacketsOrNulls,solventSCPacketsOrNulls,
		newCache,fastTrack, expandedFormulas, fakePackets, resolveOptionsResult, returnEarlyQ, allDownloadValues,
		ussmExperimentSharedOptionNames, ussmReadyListyOptions, ussmReadyOptions,
		newModelChangePacketsOrExistingModels, ussmTests, optionsRule, previewRule, testsRule, resultRule,
		resolvedOptions, resolutionTests, resolvedOptionsNoPrepVolume, resolvedOptionsFinal, safeOptionsWithFakeAutomatics,
		modelOnlyComponentPackets, onlyModelFormulaSpecs, sampleModelComponentPackets, containsFakeModelQ,
		flatSamplesIn, samplesIn, specifiedMixType, specifiedMixer, specifiedMixRate, optionalMixOptions,
		specifiedNumMixes, specifiedMaxNumMixes, finalizedPackets, frqTests, uploadProtocolOptions, protocolPacket,
		extraPackets, allTests, validQ, newSamplesIn, orderedFormulaModels, componentsAndSolventPackets,
		validLengths, validLengthTests, flatComponentsAndSolvent, expandedCombinedOptions, fakePacketNames, fakePacketTypes,
		fakePacketSynonyms, fakePacketLightSensitive, fakePacketExpires, fakePacketShelfLife, fakePacketUnsealedShelfLife,
		fakePacketDefaultStorageCondition, fakePacketTransportTemperature, fakePacketDensity, fakePacketDiscardThreshold,
		fakePacketExtinctionCoefficients, fakePacketVentilated, fakePacketFlammable, fakePacketAcid, fakePacketBase,
		fakePacketFuming, fakePacketPyrophoric, fakePacketPyrophoricFixed, fakePacketIncompatibleMaterials, ssIDs,
		allUploadStockSolutionModelOutputs, notNewStockSolutionPositions, notNewStockSolutions, newStockSolutionPositions,
		newStockSolutions, notNewStockSolutionFormulasAndSolventsRaw, notNewStockSolutionFormulasAndSolvents,
		newStockSolutionFormulasAndSolvents, formulaReplacePartRules,fakeUltrasonicIncompatible,fakeUltrasonicIncompatibleFixed,fakePrepareInResuspensionContainer,
		resolvedDensityScouts, notNewStockSolutionOriginalComponents, notNewStockSolutionSolvents,finalSSModels, ftvMethods,
		densityScouts, reResolvedDensityScouts, updatedProtocolPacket, stockSolutionModelCache, safeOpsWithNames,
		formulaSpecWithoutTemporalLinks, optionsWithoutTemporalLinks, listedFormulaSpecs, combinedOptions,
		solventsWithoutTemporalLinks, listedSolvents, fakePacketHeatSensitiveReagents, formulaAndSamples},

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* remove all temporal links *)
	{{formulaSpecWithoutTemporalLinks, solventsWithoutTemporalLinks}, optionsWithoutTemporalLinks} = removeLinks[{myFormulaSpecs, mySolvents}, ToList[myOptions]];

	(* set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentStockSolution, {formulaSpecWithoutTemporalLinks}, optionsWithoutTemporalLinks, 3, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentStockSolution, {formulaSpecWithoutTemporalLinks}, optionsWithoutTemporalLinks, 3], {}}
	];

	(* If some hard error was encountered in getting template, return early with the requested output  *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> applyTemplateOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOpsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentStockSolution, optionsWithoutTemporalLinks, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentStockSolution, optionsWithoutTemporalLinks, AutoCorrect -> False], {}}
	];
	(* change all Names to objects *)
	{formulaAndSamples, safeOptions, listedOptions} = sanitizeInputs[{formulaSpecWithoutTemporalLinks, solventsWithoutTemporalLinks}, safeOpsWithNames, optionsWithoutTemporalLinks, Simulation -> Lookup[safeOpsWithNames, Simulation]];
	{listedFormulaSpecs, listedSolvents} = If[MatchQ[formulaAndSamples, $Failed],
		{$Failed, $Failed},
		formulaAndSamples
	];
	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* make sure options are the right length; we are in the index-,atching case, first overload *)
	(* ValidInputLengthsQ doesn't play nice with Nulls, so we need to gate our using inputs 2 or 3 based on whether we have Nulls or not *)
	{validLengths, validLengthTests} = Which[
		gatherTests && Not[MemberQ[listedSolvents, Null]] && Not[MemberQ[myFinalVolumes, Null]], ValidInputLengthsQ[ExperimentStockSolution, {listedFormulaSpecs, listedSolvents, myFinalVolumes}, safeOptions, 2, Output -> {Result, Tests}],
		gatherTests, ValidInputLengthsQ[ExperimentStockSolution, {listedFormulaSpecs}, safeOptions, 3, Output -> {Result, Tests}],
		Not[MemberQ[listedSolvents, Null]] && Not[MemberQ[myFinalVolumes, Null]], {ValidInputLengthsQ[ExperimentStockSolution, {listedFormulaSpecs, listedSolvents, myFinalVolumes}, safeOptions, 2], {}},
		True, {ValidInputLengthsQ[ExperimentStockSolution, {listedFormulaSpecs}, safeOptions, 3], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[!validLengths,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests, validLengthTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];


	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	(* it doesn't matter if we are filling to volume or not; in either case, the index matching is the same, so just do it in the simpler way where it's not fill to volume *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution, {listedFormulaSpecs}, combinedOptions, 3]];

	(* --- Big Download; need to put it all in Cache --- *)

	(* separate the formula components and amounts *)
	componentAmounts = listedFormulaSpecs[[All, All, 1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]};
	components = listedFormulaSpecs[[All, All, 2]];

	(* tack the solvent onto the components list for downloading; fine if this is Null, Download will handle, and we Cases out the packets *)
	componentsAndSolvent = MapThread[
		Append[#1, #2]&,
		{components, listedSolvents}
	];

	(* also look up the ContainerOut option; if we get there, will need to make sure it's big enough to hold the prep volume;
	 	assume given the custom validLengths check above that it is singleton *)
	providedContainerOuts = Lookup[combinedOptions, ContainerOut];
	containerOutObjects = If[MatchQ[providedContainerOuts, ObjectP[]],
		providedContainerOuts,
		Null
	];

	(* assign the passed cache *)
	passedCache = Lookup[combinedOptions, Cache];

	(* flatten the components and solvent; we're going to split it up again properly later *)
	flatComponentsAndSolvent = Flatten[componentsAndSolvent];

	(* download required information *)
	allDownloadValues = Check[
		Quiet[
			Download[
				{
					flatComponentsAndSolvent,
					ToList[containerOutObjects]
				},
				{
					{
						Packet[Name, Model, Deprecated, State, Density, StorageCondition, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet, FixedAmounts, SingleUse, Resuspension, Volume, UltrasonicIncompatible, CentrifugeIncompatible, Ventilated, Flammable, Sterile, Fuming, IncompatibleMaterials, Acid, Base, Composition, Solvent],
						Packet[DefaultStorageCondition[{StorageCondition}]],
						Packet[Model[{Name, Deprecated, State, Density, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet, FixedAmounts, SingleUse, Resuspension, UltrasonicIncompatible, CentrifugeIncompatible, Ventilated, Flammable, Sterile, Fuming, IncompatibleMaterials, Acid, Base, Composition, Solvent}]]
					},
					{Packet[Name, Deprecated, MaxVolume, MinVolume, MaxTemperature, Dimensions, Resolution, ContainerMaterials]}
				},
				Cache -> passedCache,
				Date -> Now
			],
			{Download::MissingField, Download::FieldDoesntExist, Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allDownloadValues, $Failed],
		Return[$Failed]
	];

	(* split out the Download values *)
	{flatComponentAndSolventDownloadTuples, containerOutDownloadTuples} = allDownloadValues;

	(* get the components and solvents split like they were before the Download again *)
	componentAndSolventDownloadTuples = TakeList[flatComponentAndSolventDownloadTuples, Length[#]& /@ componentsAndSolvent];

	(* get sensible local variables for our component/solvent inputs *)
	componentDownloadTuples = Most[#]& /@ componentAndSolventDownloadTuples;
	solventDownloadTupleOrNull = Last[#]& /@ componentAndSolventDownloadTuples;

	(* get the component + solvent packets *)
	componentsAndSolventPackets = MapThread[
		Function[{solventTuple, componentTuples, combinedTuples},
			If[NullQ[solventTuple],
				componentTuples[[All, 1]],
				combinedTuples[[All, 1]]
			]
		],
		{solventDownloadTupleOrNull, componentDownloadTuples, componentAndSolventDownloadTuples}
	];

	(* do some hokey stuff to re-create the formula spec to _only_ include the models (replacing the samples) *)
	componentPackets = componentDownloadTuples[[All, All, 1]];
	componentSCPackets = componentDownloadTuples[[All, All, 2]];
	sampleModelComponentPackets = componentDownloadTuples[[All, All, 3]];

	(* get the model-only component packet *)
	(* model could be a spoofed fake model so that we can still do the safety-field-error-checking *)
	modelOnlyComponentPackets = MapThread[
		Function[{components, componentModelPackets},
			MapThread[
				Which[
					(* if there is no model, spoof the model with the fields in the sample *)
					MatchQ[#1, PacketP[Object[Sample]]] && NullQ[#2],
						(* basically make a "fake" model component that inherits all the safety values that are in the sample *)
						Join[
							#1,
							<|
								Object -> SimulateCreateID[Model[Sample]],
								Type->Model[Sample],
								Name->"Simulated model for " <> ObjectToString[#1],
								DefaultStorageCondition -> Lookup[#1, StorageCondition],
								Deprecated -> Null,
								State -> Which[
									Not[NullQ[Lookup[#1, State]]], Lookup[#1, State],
									VolumeQ[Lookup[#1, Volume]], Liquid,
									True, Solid
								],
								FixedAmounts -> {}
							|>
						],
					(* if there _is_ model and we have the sample packet, just use it *)
					MatchQ[#1, PacketP[Object[Sample]]] && MatchQ[#2, PacketP[Model[Sample]]], #2,
					(* if we were just given a model in the first place, just use that *)
					True, #1
				]&,
				{components, componentModelPackets}
			]
		],
		{componentPackets, sampleModelComponentPackets}
	];

	(* get whether a given formula includes a spoofed model (and thus should not be sent into UploadStockSolutionModel) *)
	containsFakeModelQ = MapThread[
		Function[{components, componentModelPackets},
			MemberQ[PickList[componentModelPackets, components, ObjectP[Object[Sample]]], Null]
		],
		{componentPackets, sampleModelComponentPackets}
	];

	(* get the SamplesIn that we will populate at the end *)
	samplesIn = DeleteCases[#, Null]& /@ componentsAndSolventPackets;
	flatSamplesIn = Flatten[samplesIn];

	(* re-generate the formula spec with only models *)
	(* note that we _might_ end up with duplicates in here and for now the error checking in the resolver thinks this is bad and will throw an error.  We can let it do that for now and figure the rest out later *)
	onlyModelFormulaSpecs = MapThread[
		Transpose[{#1, Lookup[#2, Object, {}]}]&,
		{componentAmounts, modelOnlyComponentPackets}
	];

	(* split out the solvent information if we have a solvent *)
	(* since we had to Download a third entry for samples but we don't care about that for the solvent, just get [[1]] or [[2]] *)
	solventPacketsOrNulls = MapThread[
		If[MatchQ[#1, ObjectP[]],
			#2[[1]],
			Null
		]&,
		{listedSolvents, solventDownloadTupleOrNull}
	];
	solventSCPacketsOrNulls = MapThread[
		If[MatchQ[#1, ObjectP[]],
			#2[[2]],
			Null
		]&,
		{listedSolvents, solventDownloadTupleOrNull}
	];

	(* assemble a new cache *)
	(* need to add the fake models too to make sure the Downloading below works *)
	newCache = DeleteDuplicatesBy[Cases[FlattenCachePackets[{modelOnlyComponentPackets, passedCache, componentPackets, componentSCPackets, solventPacketsOrNulls, solventSCPacketsOrNulls}], PacketP[]], Lookup[#, Object]&];

	(* get fast track assigned, we will use it for controlling checks starting here *)
	fastTrack = Lookup[combinedOptions, FastTrack];

	(* --- Resolve all the options --- *)

	(* resolve the formula-only options *)
	formulaOptionsResult = Check[
		{formulaResolvedOptions, formulaOptionTests} = If[gatherTests,
			resolveStockSolutionOptionsFormula[myFormulaSpecs, listedSolvents, myFinalVolumes,ConstantArray[Null,Length[myFinalVolumes]], ReplaceRule[expandedCombinedOptions, {Output -> {Result, Tests}, Cache -> newCache}]],
			{resolveStockSolutionOptionsFormula[myFormulaSpecs, listedSolvents, myFinalVolumes,ConstantArray[Null,Length[myFinalVolumes]], ReplaceRule[expandedCombinedOptions, {Output -> Result, Cache -> newCache}]], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* expand the formulas to be what usually goes inside a packet *)
	expandedFormulas = Map[
		{
			If[MatchQ[Unitless[#[[1]]], #[[1]]],
				#[[1]]*Unit,
				#[[1]]
			],
			Link[#[[2]]]
		}&,
		myFormulaSpecs,
		{2}
	];

	(* pull out the options that are multiples that need to go into the fake packet *)
	{
		fakePacketNames,
		fakePacketSynonyms,
		fakePacketTypes,
		fakePacketLightSensitive,
		fakePacketExpires,
		fakePacketDiscardThreshold,
		fakePacketShelfLife,
		fakePacketUnsealedShelfLife,
		fakePacketDefaultStorageCondition,
		fakePacketTransportTemperature,
		fakePacketHeatSensitiveReagents,
		fakePacketDensity,
		fakePacketExtinctionCoefficients,
		fakePacketVentilated,
		fakePacketFlammable,
		fakePacketAcid,
		fakePacketBase,
		fakePacketFuming,
		fakePacketPyrophoric,
		fakePacketIncompatibleMaterials,
		fakeUltrasonicIncompatible,
		fakePrepareInResuspensionContainer
	} = Lookup[
		formulaResolvedOptions,
		{
			StockSolutionName,
			Synonyms,
			Type,
			LightSensitive,
			Expires,
			DiscardThreshold,
			ShelfLife,
			UnsealedShelfLife,
			DefaultStorageCondition,
			TransportTemperature,
			HeatSensitiveReagents,
			Density,
			ExtinctionCoefficients,
			Ventilated,
			Flammable,
			Acid,
			Base,
			Fuming,
			Pyrophoric,
			IncompatibleMaterials,
			UltrasonicIncompatible,
			PrepareInResuspensionContainer
		}
	];

	(* pyrophoric is special; if it is missing, change that to Null *)
	fakePacketPyrophoricFixed = If[MissingQ[fakePacketPyrophoric],
		ConstantArray[Null, Length[listedFormulaSpecs]],
		fakePacketPyrophoric
	];
	fakeUltrasonicIncompatibleFixed = If[MissingQ[fakeUltrasonicIncompatible],
		ConstantArray[Null, Length[listedFormulaSpecs]],
		fakeUltrasonicIncompatible
	];

	(* make all the stock solution ids *)
	ssIDs = CreateID[
		If[MatchQ[#,Automatic],
			Model[Sample,StockSolution],
			Model[Sample,#]
		]&/@fakePacketTypes
	];

	(* create a fake packet to pass into resolveStockSolutionOptions; populate all the fields as Null (except Formula, which should just have the formula) *)
	fakePackets = MapThread[
		Function[{id, type, formula, unitOps, solvent, finalVolume, name, synonym, lightSensitive, expires, discardThreshold, shelfLife, unsealedShelfLife, defaultSC, transportTemperature, heatSensitiveReagents, density, extinctionCoefficients, ventilated, flammable, acid, base, fuming, pyrophoric, incompatibleMat, ultrasonicIncompatible, prepareInResuspensionContainer},
			<|
				Object -> id,
				Type-> type,
				Formula -> formula,
				PreparationType->Formula,
				UnitOperations->Null,
				Deprecated -> Null,
				FillToVolumeSolvent -> Link[solvent],
				TotalVolume -> finalVolume,
				FillToVolumeMethod -> Null,
				VolumeIncrements -> {},
				Sterile -> Null,
				State -> Liquid,
				MixUntilDissolved -> Null,
				MixTime -> Null,
				MaxMixTime -> Null,
				MixType->Null,
				Mixer -> Null,
				MixRate -> Null,
				NumberOfMixes -> Null,
				MaxNumberOfMixes -> Null,
				PostAutoclaveMixUntilDissolved -> Null,
				PostAutoclaveMixTime -> Null,
				PostAutoclaveMaxMixTime -> Null,
				PostAutoclaveMixRate -> Null,
				PostAutoclaveMixType -> Null,
				PostAutoclaveMixer -> Null,
				PostAutoclaveNumberOfMixes -> Null,
				PostAutoclaveMaxNumberOfMixes -> Null,
				NominalpH -> Null,
				MinpH -> Null,
				MaxpH -> Null,
				pHingAcid -> Null,
				pHingBase -> Null,
				MaxNumberOfpHingCycles -> Null,
				MaxpHingAdditionVolume -> Null,
				MaxAcidAmountPerCycle -> Null,
				MaxBaseAmountPerCycle -> Null,
				FilterMaterial -> Null,
				FilterSize -> Null,
				IncubationTime -> Null,
				IncubationTemperature -> Null,
				PostAutoclaveIncubationTime -> Null,
				PostAutoclaveIncubationTemperature -> Null,
				FillToVolumeParameterized -> Null,
				PreferredContainers -> {},
				Preparable -> True,
				Tablet->False,
				StirBar -> Null,
				(* pretend the fake packet has all the formula-only values which we resolved above *)
				Name->name,
				(* Synonyms is a multiple field so Null needs to be empty list *)
				Synonyms -> (synonym /. {Null -> {}}),
				LightSensitive -> lightSensitive,
				Expires -> expires,
				DiscardThreshold -> discardThreshold,
				ShelfLife -> shelfLife,
				UnsealedShelfLife -> unsealedShelfLife,
				(* needs to be Null because defaultSC is a symbol and not an object, and this is a link field*)
				DefaultStorageCondition -> Null,
				TransportTemperature -> transportTemperature,
				HeatSensitiveReagents -> heatSensitiveReagents,
				Density -> density,
				ExtinctionCoefficients -> extinctionCoefficients,
				Ventilated -> ventilated,
				Flammable -> flammable,
				Acid -> acid,
				Base -> base,
				Fuming -> fuming,
				(* IncompatibleMaterials is a multiple that has {None} *)
				IncompatibleMaterials -> (incompatibleMat /. {Null -> {None}}),
				Pyrophoric -> pyrophoric,
				UltrasonicIncompatible -> ultrasonicIncompatible,
				OrderOfOperations->Null,
				Resuspension -> Null,
				Autoclave->Null,
				AutoclaveProgram->Null,
				PrepareInResuspensionContainer->prepareInResuspensionContainer
			|>
		],
		{
			ssIDs,
			fakePacketTypes,
			expandedFormulas,
			ConstantArray[Null, Length[ssIDs]],
			listedSolvents,
			myFinalVolumes,
			fakePacketNames,
			fakePacketSynonyms,
			fakePacketLightSensitive,
			fakePacketExpires,
			fakePacketDiscardThreshold,
			fakePacketShelfLife,
			fakePacketUnsealedShelfLife,
			fakePacketDefaultStorageCondition,
			fakePacketTransportTemperature,
			fakePacketHeatSensitiveReagents,
			fakePacketDensity,
			fakePacketExtinctionCoefficients,
			fakePacketVentilated,
			fakePacketFlammable,
			fakePacketAcid,
			fakePacketBase,
			fakePacketFuming,
			fakePacketPyrophoricFixed,
			fakePacketIncompatibleMaterials,
			fakeUltrasonicIncompatibleFixed,
			fakePrepareInResuspensionContainer
		}
	];

	(* put some fake Automatics into the formula-only options; this is admittedly a little weird but we're just going to do it *)
	safeOptionsWithFakeAutomatics = ReplaceRule[
		combinedOptions,
		{
			(* the resolved Volume option in this case _needs_ to be what the specified final volume is *)
			Volume -> Lookup[formulaResolvedOptions, Volume],
			(* the resolved Filter and Mix options need to be in there *)
			Mix -> Lookup[formulaResolvedOptions, Mix],
			Filter -> Lookup[formulaResolvedOptions, Filter],
			(* StockSolutionName, ExtinctionCoefficeints, and Density are all Null and can't be Automatic *)
			StockSolutionName->Null,
			ExtinctionCoefficients -> Null,
			Density -> Null,
			Synonyms -> Automatic,
			LightSensitive -> Automatic,
			Expires -> Automatic,
			DiscardThreshold -> Automatic,
			ShelfLife -> Automatic,
			UnsealedShelfLife -> Automatic,
			DefaultStorageCondition -> Automatic,
			TransportTemperature -> Automatic,
			Ventilated -> Automatic,
			Flammable -> Automatic,
			Acid -> Automatic,
			Base -> Automatic,
			Fuming -> Automatic,
			IncompatibleMaterials -> Automatic
		}
	];

	(* resolve options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and will return early *)
	(* note that we can't actually  *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = Quiet[
			If[gatherTests,
				resolveStockSolutionOptions[fakePackets, ReplaceRule[safeOptionsWithFakeAutomatics, {Output -> {Result, Tests}, Cache -> newCache}]],
				{resolveStockSolutionOptions[fakePackets, ReplaceRule[safeOptionsWithFakeAutomatics, {Output -> Result, Cache -> newCache}]], Null}
			],
			{
				(*Quiet this error message in formula overload as it is already checked in formula option resolver*)
				Error::InvalidModelFormulaForFillToVolume,
				(*Quiet this warninge in formula overload as the specified volume will not be used, and a warning is already thrown about that *)
				Warning::VolumeTooLowForAutoclave
			}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* figure out if we want to return early or not *)
	returnEarlyQ = If[gatherTests,
		Not[RunUnitTest[<|"Tests" -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, formulaOptionTests, resolutionTests}]|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		MatchQ[resolveOptionsResult, $Failed] || MatchQ[formulaOptionsResult, $Failed]
	];

	(* remove the PreparatoryVolume option from the resolved options since it isn't really an option *)
	resolvedDensityScouts = Lookup[resolvedOptions, DensityScouts];
	resolvedOptionsNoPrepVolume = Select[resolvedOptions, Not[MatchQ[Keys[#], Alternatives[PreparatoryVolumes,DensityScouts]]]&];

	(* add back the options that we resolved in the first resolver above *)
	resolvedOptionsFinal = ReplaceRule[
		resolvedOptionsNoPrepVolume,
		{
			StockSolutionName->Lookup[formulaResolvedOptions, StockSolutionName],
			Synonyms -> Lookup[formulaResolvedOptions, Synonyms],
			LightSensitive -> Lookup[formulaResolvedOptions, LightSensitive],
			Expires -> Lookup[formulaResolvedOptions, Expires],
			DiscardThreshold -> Lookup[formulaResolvedOptions, DiscardThreshold],
			ShelfLife -> Lookup[formulaResolvedOptions, ShelfLife],
			UnsealedShelfLife -> Lookup[formulaResolvedOptions, UnsealedShelfLife],
			DefaultStorageCondition -> Lookup[formulaResolvedOptions, DefaultStorageCondition],
			TransportTemperature -> Lookup[formulaResolvedOptions, TransportTemperature],
			Density -> Lookup[formulaResolvedOptions, Density],
			ExtinctionCoefficients -> Lookup[formulaResolvedOptions, ExtinctionCoefficients],
			Ventilated -> Lookup[formulaResolvedOptions, Ventilated],
			Flammable -> Lookup[formulaResolvedOptions, Flammable],
			Acid -> Lookup[formulaResolvedOptions, Acid],
			Base -> Lookup[formulaResolvedOptions, Base],
			Fuming -> Lookup[formulaResolvedOptions, Fuming],
			IncompatibleMaterials -> Lookup[formulaResolvedOptions, IncompatibleMaterials]
		}
	];

	(* need to return early if something bad happened because we're FastTracking USSM below and that would trainwreck otherwise *)
	If[returnEarlyQ,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, formulaOptionTests, resolutionTests}],
				Preview -> Null,
				Options -> resolvedOptionsFinal
			}
		]
	];

	(* --- Generate the options we are actually going to pass to UploadStockSolution *)

	(* pull out the specified values of MixType/Mixer/MixRate before resolution *)
	{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes} = Lookup[expandedCombinedOptions, {MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}];

	(* decide if we are going to pass the MixType/Mixer/MixRate down to UploadStockSolution *)
	(* basically, if MixType was specified, then pass down whichever of the three of MixType/Mixer/MixRate/NumberOfMixes/MaxNumberOfMixes was specified down to UploadStockSolution *)
	(* if it was not, then pass down nothing *)
	optionalMixOptions = MapThread[
		If[MatchQ[#1, MixTypeP],
			Flatten[{MixType, PickList[{Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}, {#2, #3, #4, #5}, Except[Automatic|Null]]}],
			{}
		]&,
		{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes}
	];


	(* assign the names of options that are identical between USSM and ExperimentStockSolution *)
	(* for each formula include the mix options or not *)
	ussmExperimentSharedOptionNames = Map[
		Flatten[{
			Synonyms,
			Mix, MixUntilDissolved, MixTime, MaxMixTime, #,
			MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize,
			LightSensitive, Expires, DiscardThreshold, ShelfLife,
			UnsealedShelfLife, DefaultStorageCondition, Density, ExtinctionCoefficients,TransportTemperature, HeatSensitiveReagents, Ventilated,
			Flammable, Acid, Base, Fuming, IncompatibleMaterials,
			Incubate, IncubationTemperature, IncubationTime, PostAutoclaveIncubate, PostAutoclaveIncubationTemperature,
			PostAutoclaveIncubationTime, OrderOfOperations,
			Autoclave, AutoclaveProgram, FillToVolumeMethod, PrepareInResuspensionContainer, Type,
			Supplements, DropOuts, GellingAgents, MediaPhase
		}]&,
		optionalMixOptions
	];

	(* make the listy options we are going to pass into USSM *)
	(* need to use MapIndexed to properly include the index *)
	ussmReadyListyOptions = MapIndexed[
		Function[{optionNames, indexNum},
			Join[
				(* different between USSM/ExpSS *)
				{
					Name->Extract[Lookup[resolvedOptionsFinal, StockSolutionName], indexNum],

					(* bit of name inconsistency here too *)
					NominalpH -> Extract[Lookup[resolvedOptionsFinal, pH], indexNum],

					SafetyOverride->Lookup[resolvedOptionsFinal, SafetyOverride],

					(* set Output option to send to USSM; depends on if we need tests, but we ALWAYS want Reult/Options *)
					Output -> If[gatherTests,
						{Result, Tests},
						Result
					],

					(* we always want to NOT upload yet *)
					Upload -> False,

					(* send in passed cache plus new download cache *)
					Cache -> newCache,
					(* at this point we've already done all our error checking that UploadStockSolution is also doing, so we don't need to do it again *)
					FastTrack -> True
				},

				(* same between UploadStockSolution and ExpSS; pipe 'em innnn *)
				Map[
					If[MatchQ[Lookup[resolvedOptionsFinal, #], _List] && !MatchQ[#,Supplements|DropOuts|HeatSensitiveReagents|GellingAgents],
						# -> Extract[Lookup[resolvedOptionsFinal, #], indexNum],
						# -> Lookup[resolvedOptionsFinal, #]
					]&,
					optionNames
				]
			]
		],
		ussmExperimentSharedOptionNames
	];

	(* change all the index matching options into just the singleton cases, and change some Nulls to necessary non-nuls  *)
	(* need to map at level {2} because we're mapping over individual option names in a list of list of options *)
	ussmReadyOptions = Map[
		Which[
			(* lots of Safety information can't be Null so make them False for USSM *)
			MatchQ[Keys[#], LightSensitive|Expires|Ventilated|Flammable|Acid|Base|Fuming], (# /. {Null -> False}),
			(* DefaultStorageCondition can't be Null so make it AmbientStorage for USSM *)
			MatchQ[Keys[#], DefaultStorageCondition], (# /. {Null -> AmbientStorage}),
			(* DiscardThreshold can't be Null so change to the default if we don't have anything *)
			MatchQ[Keys[#], DiscardThreshold], (# /. {Null -> 5 Percent}),
			(* IncompatibleMaterials, Synonyms, Cache, ExtinctionCoeffficients, and Output are all lists but not index matching options, so don't expand them; otherwise, expand all the index matching options *)
			MatchQ[Values[#], _List] && Not[MatchQ[Keys[#], Cache|Output|Synonyms|IncompatibleMaterials|ExtinctionCoefficients|OrderOfOperations|Supplements|DropOuts|HeatSensitiveReagents]], Keys[#] -> First[Values[#]],
			(*HeatSensitiveReagents needs to be either a single empty list or a list of reagents*)
			MatchQ[Keys[#], HeatSensitiveReagents] && MatchQ[Values[#], {{}..}], Keys[#] -> First[Values[#]],
			True, #
		]&,
		ussmReadyListyOptions,
		{2}
	];

	(* call USSM (appropriate overload) with our formula, solvent, and options;
	 	- it will return EITHER a change packet for a new model, or an existing model
		- the above set of ussmReadyOptions has Output option in it *)
	(* note that if we are using the Sample input and there is no model, then we are not going to call UploadStockSolution *)
	allUploadStockSolutionModelOutputs = Check[
		MapThread[
			Function[{formula, solvent, finalVolume, options},
				Which[
					gatherTests, {Null, {}},
					MatchQ[solvent, ObjectP[]], Quiet[UploadStockSolution[formula, solvent, finalVolume, Sequence @@ options], {Warning::SpecifedMixRateNotSafe}],
					True, Quiet[UploadStockSolution[formula, Sequence @@ options], {Warning::SpecifedMixRateNotSafe}]
				]
			],
			{expandedFormulas, listedSolvents, myFinalVolumes, ussmReadyOptions}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* need to return early if USS returned a bad input/option error *)
	If[MatchQ[allUploadStockSolutionModelOutputs, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests}],
				Preview -> Null,
				Options -> resolvedOptionsFinal
			}
		]
	];

	(* pull out the stock solution results and the tests *)
	newModelChangePacketsOrExistingModels = If[gatherTests,
		allUploadStockSolutionModelOutputs[[All, 1]],
		allUploadStockSolutionModelOutputs
	];
	ussmTests = If[gatherTests,
		allUploadStockSolutionModelOutputs[[All, 2]],
		{}
	];

	(*--- if we're making a new stock solution, then get the formula components in their designated order; otherwise it's just the models of the samples in models ---*)
	(* get the positions of the not-new-stock-solutions and the new ones at the first level, and then pull them out using Extract *)
	notNewStockSolutionPositions = Position[newModelChangePacketsOrExistingModels, ObjectReferenceP[] | Null, {1}];
	notNewStockSolutions = Extract[newModelChangePacketsOrExistingModels, notNewStockSolutionPositions];
	notNewStockSolutionOriginalComponents = Extract[componentPackets, notNewStockSolutionPositions];
	notNewStockSolutionSolvents = Extract[listedSolvents, notNewStockSolutionPositions];
	newStockSolutionPositions = Position[newModelChangePacketsOrExistingModels, PacketP[], {1}];
	newStockSolutions = Extract[newModelChangePacketsOrExistingModels, newStockSolutionPositions];

	(* need to download the formulas from the not-new-stock-solutions *)
	(* sorry about this Download, but we need to make sure the Formula order is correct and need to do this here even if the stock solution already exists since the order might be flipped *)
	(* I'm doing this splitting and recombining specifically to ensure I don't have to map over this Download so at least there's that? *)
	notNewStockSolutionFormulasAndSolventsRaw = Download[notNewStockSolutions, {Formula[[All, 2]][Object], FillToVolumeSolvent[Object]}, Date -> Now];
	notNewStockSolutionFormulasAndSolvents = MapThread[
		Which[
			NullQ[#1] && NullQ[#3], Download[DeleteCases[Flatten[#2], Null], Object],
			NullQ[#1], Download[DeleteCases[Flatten[{#2, #3}], Null], Object],
			True, Download[DeleteCases[Flatten[#1], Null], Object]
		]&,
		{notNewStockSolutionFormulasAndSolventsRaw, notNewStockSolutionOriginalComponents, notNewStockSolutionSolvents}
	];

	(* don't need to Download for new stock solutions since they're packets and we can just Lookup *)
	newStockSolutionFormulasAndSolvents = Map[
		Download[DeleteCases[Flatten[{Lookup[#, Replace[Formula]][[All, 2]], Lookup[#, FillToVolumeSolvent]}], Null], Object]&,
		newStockSolutions
	];

	(* make the ReplacePart replace rules to get the ordered formula models *)
	formulaReplacePartRules = MapThread[
		#1 -> #2&,
		{Join[notNewStockSolutionPositions, newStockSolutionPositions], Join[notNewStockSolutionFormulasAndSolvents, newStockSolutionFormulasAndSolvents]}
	];

	(* get the ordered formula models using the ReplacePart stuff we got above *)
	orderedFormulaModels = ReplacePart[newModelChangePacketsOrExistingModels, formulaReplacePartRules];

	(* doing SelectFirst is ok here because we don't allow multiple samples of the same model to be in the formula (if that were not enforced this would be broken because SelectFirst only takes the first and would never get the second) *)
	(* however, in order for that to work, we need to do a nested map.  Need to have nested Function calls too because otherwise the hashes in SelectFirst become ambiguous *)
	(* note that if the input sample has no model, then what I'm listing as 'model' in here actually might contain samples *)
	newSamplesIn = Flatten[MapThread[
		Function[{models, samplePackets, solventPacketOrNull},
			Download[MapIndexed[
				Function[{model, index},
					(* if we have the case where a specific sample was specified and it has the same model as the solvent, make sure we don't double-pick the sample *)
					(* we can do that by saying that if we have a solvent and we are on the last model we are looping over, then don't ever take the sample *)
					If[Not[NullQ[solventPacketOrNull]] && MatchQ[Flatten[index], {Length[models]}],
						model,
						SelectFirst[samplePackets, MatchQ[Lookup[#, Model], ObjectP[model]]&, model]
					]
				],
				models
			], Object]
		],
		{orderedFormulaModels, samplesIn, solventPacketsOrNulls}
	]];

	(* call the stockSolutionResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPackets, frqTests} = If[gatherTests,
		stockSolutionResourcePackets[
			newModelChangePacketsOrExistingModels,
			Lookup[resolvedOptionsFinal, Volume],
			resolvedDensityScouts,
			(* assuming Engine is never calling this overload, so no prepared resources *)
			{},
			(* need to pass SamplesIn down because it's sometimes Samples and sometimes Models *)
			newSamplesIn,
			(* need to pass the formula down because if there are Object[Sample]s in the formula that needs to be kept *)
			listedFormulaSpecs,
			listedSolvents,
			ReplaceRule[resolvedOptionsFinal, {Output -> {Result, Tests}}],
			unresolvedOptions
		],
		{stockSolutionResourcePackets[
			newModelChangePacketsOrExistingModels,
			Lookup[resolvedOptionsFinal, Volume],
			resolvedDensityScouts,
			(* assuming Engine is never calling this overload, so no prepared resources *)
			{},
			(* need to pass SamplesIn down because it's sometimes Samples and sometimes Models *)
			newSamplesIn,
			(* need to pass the formula down because if there are Object[Sample]s in the formula that needs to be kept *)
			listedFormulaSpecs,
			listedSolvents,
			ReplaceRule[resolvedOptionsFinal, {Output -> Result}],
			unresolvedOptions
		], {}}
	];

	(* --- assembling outputs time!!!  --- *)

	(* get all the options for the UploadProtocol call *)
	uploadProtocolOptions = Sequence[
		Confirm -> Lookup[resolvedOptionsFinal, Confirm],
		CanaryBranch -> Lookup[resolvedOptionsFinal, CanaryBranch],
		ConstellationMessage -> Object[Protocol, StockSolution],
		ParentProtocol -> Lookup[resolvedOptionsFinal, ParentProtocol],
		Upload -> Lookup[resolvedOptionsFinal, Upload],
		Email -> Lookup[resolvedOptionsFinal, Email],
		FastTrack -> Lookup[resolvedOptionsFinal, FastTrack],
		Priority -> Lookup[combinedOptions,Priority],
		StartDate -> Lookup[combinedOptions,StartDate],
		HoldOrder -> Lookup[combinedOptions,HoldOrder],
		QueuePosition -> Lookup[combinedOptions,QueuePosition]
	];

	(* get the protocol packet and, if they exist, the extra packets *)
	{protocolPacket, extraPackets} = Switch[finalizedPackets,
		PacketP[Object[Protocol, StockSolution]], {finalizedPackets, {}},
		$Failed, {$Failed, $Failed},
		_, {First[finalizedPackets], Rest[finalizedPackets]}
	];

	(* --- re-resolve the density scouting runs. --- *)
	(* this is really problematic because the density scouts that are resolved by the resolver in the formula case are generated from fakePackets and therefore correspond to nonexistent objects.
	 These objects, even when uploaded, are not valid, so the solution here was to figure out which SS models are created from the actual formulas, and then use those as the density scout models.
	 However, we also have to force the density scouting procedure to use Volumetric FillToVolume method, otherwise it's possible to create a recursive density scouting sub-protocol here. *)

	(* the resolved Density Scouts are now out of date because they don't exist in the database. we need to pull StockSolutionModels, FillToVolumeMethods *)
	{finalSSModels, ftvMethods, densityScouts} = Switch[
		protocolPacket,
		$Failed,
		{{},{},{}},
		_,
		Lookup[protocolPacket,{Replace[StockSolutionModels],Replace[FillToVolumeMethods],Replace[DensityScouts]},{}]];

	(* a priori it seems impossible to determine which stock solution models will be needed to create the call in question, so we will create a cache for the density of all the stock solutions.
	 To avoid duplicating cache packets, we will only download finalSSModels that are not present in the extraPackets *)
	stockSolutionModelCache = Join[
		Quiet[
			Download[Complement[Cases[finalSSModels, _Model, All],Lookup[extraPackets,Object,{}]],Packet[Density]],
			{Download::ObjectDoesNotExist}
		],
		extraPackets
	];

	(* re-determine whether we need to density scout *)
	reResolvedDensityScouts = Link/@MapThread[
		Function[{resolvedFillToVolumeMethod,stockSolutionModel},
			If[MatchQ[resolvedFillToVolumeMethod,Gravimetric]&&MatchQ[Lookup[fetchPacketFromCache[stockSolutionModel,stockSolutionModelCache],Density],(Null)],
				Download[stockSolutionModel,Object],
				Nothing
			]
		],
		{ftvMethods,finalSSModels}
	];

	(* replace the density scouts in the packet with the ones we just created *)
	updatedProtocolPacket = Join[protocolPacket,Association[Replace[DensityScouts]->reResolvedDensityScouts]];

	(* combine all the tests together *)
	allTests = Cases[
		Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, ussmTests, formulaOptionTests, resolutionTests, frqTests}],
		_EmeraldTest
	];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[updatedProtocolPacket, $Failed], False,
		gatherTests && MemberQ[listedOutput, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* asemble our options return rule; don't need to collapse indexed, we should have errored if we got any listed options *)
	optionsRule = Options -> Which[
		MemberQ[listedOutput, Options] && !NullQ[Lookup[resolvedOptionsFinal,MediaPhase,Null]],
			Module[{finalOptionsNoType},
				(* Don't send Type back to ExperimentMedia, it is not an option there *)
				finalOptionsNoType = Normal[KeyDrop[resolvedOptionsFinal,Type],Association];

				(* Collapse and remove media hidden options *)
				RemoveHiddenOptions[ExperimentMedia,CollapseIndexMatchedOptions[ExperimentStockSolution, finalOptionsNoType, Messages -> False, Ignore -> listedOptions]]
			],
		MemberQ[listedOutput, Options],
			RemoveHiddenOptions[ExperimentStockSolution, CollapseIndexMatchedOptions[ExperimentStockSolution, resolvedOptionsFinal, Messages -> False, Ignore -> listedOptions]],
		True,
			Null
	];

	(* generate the Preview rule as a Null *)
	previewRule = Preview -> Null;

	(* assemble all tess we created; a couple of these variables are lists of lists of tests so just flatten it all up *)
	testsRule = Tests -> If[gatherTests,
		allTests
	];

	(* generate the result rule; don't do it if ANY of our invalidity checks above were tripped *)
	resultRule = Result -> Which[
		MatchQ[newModelChangePacketsOrExistingModels, $Failed], $Failed,
		MemberQ[listedOutput, Result] && validQ && MatchQ[extraPackets, {}], UploadProtocol[updatedProtocolPacket, uploadProtocolOptions],
		MemberQ[listedOutput, Result] && validQ, UploadProtocol[updatedProtocolPacket, extraPackets, uploadProtocolOptions],
		True, $Failed
	];

	(* return everything asked for (with original listing/non-listing!!) *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}
];


(*
	--- unit operations CORE:
		- Resolves formula-only options to Null
		- Resolves all other options
		- Creates or finds model (via UploadStockSolution)
		- Passes model to core protocol/Result function to make protocols
*)
experimentStockSolutionFormula[
	myUnitOperations:{{SamplePreparationP..}..},
	myOptions:OptionsPattern[ExperimentStockSolution]
]:=Module[
	{listedOptions, outputSpecification, listedOutput, gatherTests,resolvedOptions,resolutionTests, unresolvedOptions, applyTemplateOptionTests,
		safeOptions, safeOptionTests, formulaOptionsResult, nullifiedOptions,
		updatedOptions,formulaResolvedOptions,experimentMSPOptions, simulatedSamplePackets,
		sampleSimulatedCompositions, finalVolumes,combinedSimulation,invalidLabelContainerPrimitives,invalidLabelContainerPrimitiveTest,
		unitOpsSpecifiedObjects,onlyModelsInUnitOpsQs,ModelsInUnitOpsTests,sampleSimulatedCompositionsNullAmount,
		formulaOptionTests, providedContainerOuts,containerOutObjects,
		passedCache,passedSimulation,containerOutDownloadTuples,
		newCache,fastTrack, expandedFormulas, fakePackets, safeOptionsWithFakeAutomatics, resolveOptionsResult, returnEarlyQ, allDownloadValues,
		ussmExperimentSharedOptionNames, ussmReadyListyOptions, ussmReadyOptions,
		newModelChangePacketsOrExistingModels, ussmTests, optionsRule, previewRule, testsRule, resultRule,
		specifiedMixType, specifiedMixer, specifiedMixRate, optionalMixOptions,
		specifiedNumMixes, specifiedMaxNumMixes, finalizedPackets, frqTests, uploadProtocolOptions, protocolPacket,
		extraPackets, allTests, validQ, sanitizedUnitOperations,
		validLengths, validLengthTests, expandedCombinedOptions, fakePacketNames, fakePacketDiscardThreshold,
		fakePacketSynonyms, fakePacketLightSensitive, fakePacketExpires, fakePacketShelfLife, fakePacketUnsealedShelfLife,
		fakePacketDefaultStorageCondition, fakePacketTransportTemperature, fakePacketDensity,
		fakePacketExtinctionCoefficients, fakePacketVentilated, fakePacketFlammable, fakePacketAcid, fakePacketBase, fakePacketHeatSensitiveReagents,
		fakePacketFuming, fakePacketPyrophoric, fakePacketPyrophoricFixed, fakePacketIncompatibleMaterials, ssIDs,
		allUploadStockSolutionModelFailure, allUploadStockSolutionModelOutputs, fakeUltrasonicIncompatible,fakeUltrasonicIncompatibleFixed,fakePrepareInResuspensionContainer,
		resolvedDensityScouts, finalSSModels, ftvMethods,
		densityScouts, reResolvedDensityScouts, updatedProtocolPacket, stockSolutionModelCache, safeOps,combinedOptions,
		listedSolvents,resolvedOptionsFinal,resolvedOptionsNoPrepVolume, invalidSubsequentUnitOperations, invalidSubsequentUnitOperationsTest},

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* make options listed *)
	listedOptions = ToList[myOptions];

	(* set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentStockSolution, {myUnitOperations}, listedOptions, 4, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentStockSolution, {myUnitOperations}, listedOptions, 4], {}}
	];

	(* If some hard error was encountered in getting template, return early with the requested output  *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> applyTemplateOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentStockSolution, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentStockSolution, listedOptions, AutoCorrect -> False], {}}
	];
	(* change all Names to objects *)
	{sanitizedUnitOperations, safeOptions} = sanitizeInputs[myUnitOperations, safeOps, Simulation -> Lookup[safeOps, Simulation, Null]];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* make sure options are the right length; we are in the index-,atching case, first overload *)
	(* ValidInputLengthsQ doesn't play nice with Nulls, so we need to gate our using inputs 2 or 3 based on whether we have Nulls or not *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentStockSolution, {sanitizedUnitOperations}, safeOptions, 4, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentStockSolution, {sanitizedUnitOperations}, safeOptions, 4], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[!validLengths,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[applyTemplateOptionTests, safeOptionTests, validLengthTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	(* it doesn't matter if we are filling to volume or not; in either case, the index matching is the same, so just do it in the simpler way where it's not fill to volume *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution, {sanitizedUnitOperations}, combinedOptions, 4]];


	(* before we ever start we should check that everything is valid here *)
	(* If given primitives, make sure that the first primitive is a LabelContainer primitive. *)
	invalidLabelContainerPrimitives=Map[Function[unitOps,
		Not[And[
			MatchQ[FirstOrDefault[unitOps], _LabelContainer],
			MatchQ[Lookup[FirstOrDefault[unitOps][[1]], Container], ObjectP[Model[Container]]]
		]]],
		sanitizedUnitOperations
	];

	If[!gatherTests && Or@@invalidLabelContainerPrimitives,
		Message[Error::InvalidLabelContainerUnitOperationInput];
		Message[Error::InvalidInput,PickList[sanitizedUnitOperations, invalidLabelContainerPrimitives]];
	];

	invalidLabelContainerPrimitiveTest=If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified UnitOperation `1` begins with a LabelContainer UnitOperations:"][#1],#2,True]&,
			{sanitizedUnitOperations, invalidLabelContainerPrimitives}
		],
		{}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[Or@@invalidLabelContainerPrimitives,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests, invalidLabelContainerPrimitiveTest],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	invalidSubsequentUnitOperations = Map[
		Function[unitOps,
			MatchQ[unitOps, {_LabelContainer..}]
		],
		sanitizedUnitOperations
	];

	If[!gatherTests && Or@@invalidSubsequentUnitOperations,
		Message[Error::InvalidUnitOperationsInput];
		Message[Error::InvalidInput,PickList[sanitizedUnitOperations, invalidSubsequentUnitOperations]]
	];

	invalidSubsequentUnitOperationsTest=If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified UnitOperation `1` begins with a LabelContainer UnitOperations:"][#1],#2,True]&,
			{sanitizedUnitOperations, invalidSubsequentUnitOperations}
		],
		{}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	(* However, make an exception if we are only doing option-resolving in CCD. This is because in CCD we have to add UOs one by one and each time we validate the function will evaluate *)
	(* we don't want function to error out, just throw a message telling user more UOs are needed *)
	If[Or@@invalidSubsequentUnitOperations && (!MatchQ[$ECLApplication, CommandCenter] || MemberQ[ToList[outputSpecification], Result]),
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[safeOptionTests, invalidLabelContainerPrimitiveTest],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* All unit operations related objects *)
	unitOpsSpecifiedObjects = Map[Cases[#, ObjectP[{Model[Sample], Model[Container],Object[Sample], Object[Container]}], Infinity]&,sanitizedUnitOperations];

	(*  bult tests for Objects specified in unit ops (we only take models) *)
	onlyModelsInUnitOpsQs = Map[
		Function[unitOpsObjs,
			Not[And@@(MatchQ[#, ObjectP[{Model[Sample], Model[Container]}]]&/@ unitOpsObjs)]],
		unitOpsSpecifiedObjects
	];

	(* Build tests for object existence *)
	ModelsInUnitOpsTests = If[gatherTests,
		MapThread[
			(* The boolean is True if we have object *)
			Test[StringTemplate["all sample/containers in specified UnitOperation `1` are Models:"][#1],#2,False]&,
			{sanitizedUnitOperations, onlyModelsInUnitOpsQs}
		],
		{}
	];


	(* If objects do not exist, return failure *)
	If[Or@@onlyModelsInUnitOpsQs,
		If[!gatherTests,
			Message[Error::UnitOperationsContainObject,PickList[sanitizedUnitOperations,onlyModelsInUnitOpsQs,True]];
			Message[Error::InvalidInput,PickList[sanitizedUnitOperations,onlyModelsInUnitOpsQs,True]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,ModelsInUnitOpsTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*  call ExperimentManualSamplePreparation on each of the unitOperations to see if there are any errors, also to simulate the sample we're generating. *)
	{experimentMSPOptions, simulatedSamplePackets} = Transpose@MapIndexed[Function[{unitOps, index},
		Module[{myMessageList, messageHandler, ops, simulation},
			myMessageList = {};

			messageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
				(* Keep track of the messages thrown during evaluation of the test. *)
				AppendTo[myMessageList, <|MessageName->Hold[msg],MessageArguments->ToList[args]|>];
			];

			{ops, simulation} = SafeAddHandler[{"MessageTextFilter", messageHandler},
				(* Block $Messages to stop message printing. *)
				Block[{$Messages},
					ExperimentManualSamplePreparation[
						unitOps,
						Output->{Options, Simulation}
					]
				]
			];

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
							newMessageTemplate="The following message was thrown when validating the given unit operations in index "<>ToString[index]<>" of the input]: "<>messageTemplate;
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
			{ops, simulation}
		]],
		sanitizedUnitOperations
	];

	(* see if we got a composition, if not simulate the samples and grab whatever's in the first container so the sample composition *)
	{sampleSimulatedCompositions, finalVolumes} = Transpose@MapThread[Function[{unitOps, simulation},
		Module[{labelOfInterest, simulatedContainer,simulatedSampleComposition, sanitizedSimulatedSampleComposition, volume, updatedSimulation},
			(*get the first label container unit operation,it should be the very first*)
			labelOfInterest = First[Cases[unitOps, _LabelContainer]][Label];
			(*figure out what is the container that was simulated for it and whats in it*)
			simulatedContainer =Lookup[Lookup[First[simulation], Labels],labelOfInterest];
			(* Here we need to do a work-around for CCD. In CCD user has to add UOs one by one and so when they add the first LabelSample UO, they have to calculate and verify *)
			(* However, that will break because there's no transfer into that labeled container, thus there's no Contents in this simulatedContainer *)
			(* Use the helper below to make a dummy sample *)
			updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, simulation];
			(*get the sample in that container and its volume*)
			{simulatedSampleComposition,volume} =  Download[simulatedContainer, {Contents[[1, 2]][Composition], Contents[[1, 2]][Volume]},Simulation -> updatedSimulation];

			(* make sure we're not dealing with links *)
			sanitizedSimulatedSampleComposition = {#[[1]], Download[#[[2]], Object]}& /@ simulatedSampleComposition;

			(* return composition and volume *)
			{sanitizedSimulatedSampleComposition,volume}
		]],
		{sanitizedUnitOperations, simulatedSamplePackets}
	];

	(* helper to combine simulations into one *)

	(* terminal case *)
	recursiveUpdateSimulation[lastSimulation : {SimulationP}] := First[lastSimulation];
	(* core case *)
	recursiveUpdateSimulation[simulations : {SimulationP ..}] :=
     UpdateSimulation[First[simulations],recursiveUpdateSimulation[Rest[simulations]]];

	combinedSimulation = recursiveUpdateSimulation[simulatedSamplePackets];

	(* --- Big Download; need to put it all in Cache --- *)

	(* also look up the ContainerOut option; if we get there, will need to make sure it's big enough to hold the prep volume;
	 	assume given the custom validLengths check above that it is singleton *)
	providedContainerOuts = Lookup[combinedOptions, ContainerOut];
	containerOutObjects = If[MatchQ[providedContainerOuts, ObjectP[]],
		providedContainerOuts,
		Null
	];

	(* assign the passed cache *)
	passedCache = Lookup[combinedOptions, Cache];
	passedSimulation = Lookup[combinedOptions, Simulation];

	(* download required information *)
	allDownloadValues = Check[
		Quiet[
			Download[
				{
					ToList[containerOutObjects]
				},
				{
					{Packet[Name, Deprecated, MaxVolume, MinVolume, MaxTemperature, Dimensions, Resolution, ContainerMaterials]}
				},
				Cache -> passedCache,
				Simulation->combinedSimulation,
				Date -> Now
			],
			{Download::MissingField, Download::FieldDoesntExist, Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allDownloadValues, $Failed],
		Return[$Failed]
	];

	(* split out the Download values *)
	{containerOutDownloadTuples} = allDownloadValues;

	(* assemble a new cache *)
	(* need to add the fake models too to make sure the Downloading below works *)
	newCache = DeleteDuplicatesBy[Cases[FlattenCachePackets[{passedCache, allDownloadValues}], PacketP[]], Lookup[#, Object]&];

	(* get fast track assigned, we will use it for controlling checks starting here *)
	fastTrack = Lookup[combinedOptions, FastTrack];

	(* --- Resolve all the options --- *)

	(* resolveStockSolutionOptionsFormula can also handle compositions instead of formula, but we need to remove the amounts *)
	sampleSimulatedCompositionsNullAmount = Map[Function[composition,
			Map[{Null, #[[2]]}&, composition]
		],
		sampleSimulatedCompositions
	];

	(* specify Null for all prep options (unless they are already specified to save trouble on the resolver *)
	nullifiedOptions = Module[{prepOps,boolPrepOps},

		(* prep options that are defined as conflicting for Error::ConflictingPrimitivesOptions *)
		prepOps = {
			Incubate, IncubationTemperature, IncubationTime, Mix, MixUntilDissolved, MixTime, MaxMixTime, MixType,
			Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes, AdjustpH, NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize, Autoclave, AutoclaveProgram, OrderOfOperations, FillToVolumeMethod
		};

		boolPrepOps = {Incubate, Mix, PostAutoclaveIncubate, PostAutoclaveMix, AdjustpH, Filter, Autoclave};

		(* mass resolve options *)
		Map[Function[option,
			If[
				MatchQ[Lookup[expandedCombinedOptions,option], Except[Automatic]],
				option->Lookup[expandedCombinedOptions,option],
				option->If[MemberQ[boolPrepOps, option], False, Null]
			]],
			prepOps
		]
	];

	(* replace Composition optionand  *)
	updatedOptions = ReplaceRule[expandedCombinedOptions,
		Join[nullifiedOptions,{
			UnitOperations->sanitizedUnitOperations
		}]];


	(* resolve the formula-only options - passing compositions rather than formula. the same resolver can handle both*)
	formulaOptionsResult = Check[
		{formulaResolvedOptions, formulaOptionTests} = If[gatherTests,
			resolveStockSolutionOptionsFormula[sampleSimulatedCompositionsNullAmount, ConstantArray[Null, Length[finalVolumes]], finalVolumes,sanitizedUnitOperations, ReplaceRule[updatedOptions, {Output -> {Result, Tests}, Cache -> newCache,Simulation->combinedSimulation}]],
			{resolveStockSolutionOptionsFormula[sampleSimulatedCompositionsNullAmount, ConstantArray[Null, Length[finalVolumes]], finalVolumes,sanitizedUnitOperations, ReplaceRule[updatedOptions, {Output -> Result, Cache -> newCache,Simulation->combinedSimulation}]], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];


	(* pull out the options that are multiples that need to go into the fake packet *)
	{
		fakePacketNames,
		fakePacketSynonyms,
		fakePacketLightSensitive,
		fakePacketExpires,
		fakePacketDiscardThreshold,
		fakePacketShelfLife,
		fakePacketUnsealedShelfLife,
		fakePacketDefaultStorageCondition,
		fakePacketTransportTemperature,
		fakePacketHeatSensitiveReagents,
		fakePacketDensity,
		fakePacketExtinctionCoefficients,
		fakePacketVentilated,
		fakePacketFlammable,
		fakePacketAcid,
		fakePacketBase,
		fakePacketFuming,
		fakePacketPyrophoric,
		fakePacketIncompatibleMaterials,
		fakeUltrasonicIncompatible,
		fakePrepareInResuspensionContainer
	} = Lookup[
		formulaResolvedOptions,
		{
			StockSolutionName,
			Synonyms,
			LightSensitive,
			Expires,
			DiscardThreshold,
			ShelfLife,
			UnsealedShelfLife,
			DefaultStorageCondition,
			TransportTemperature,
			HeatSensitiveReagents,
			Density,
			ExtinctionCoefficients,
			Ventilated,
			Flammable,
			Acid,
			Base,
			Fuming,
			Pyrophoric,
			IncompatibleMaterials,
			UltrasonicIncompatible,
			PrepareInResuspensionContainer
		}
	];

	(* pyrophoric is special; if it is missing, change that to Null *)
	fakePacketPyrophoricFixed = If[MissingQ[fakePacketPyrophoric],
		ConstantArray[Null, Length[sanitizedUnitOperations]],
		fakePacketPyrophoric
	];
	fakeUltrasonicIncompatibleFixed = If[MissingQ[fakeUltrasonicIncompatible],
		ConstantArray[Null, Length[sanitizedUnitOperations]],
		fakeUltrasonicIncompatible
	];

	expandedFormulas = ConstantArray[{{Null,Null}}, Length[sanitizedUnitOperations]];
	listedSolvents = ConstantArray[Null, Length[sanitizedUnitOperations]];

	(* make all the stock solution ids *)
	ssIDs = CreateID[ConstantArray[Model[Sample, StockSolution], Length[sanitizedUnitOperations]]];

	(* create a fake packet to pass into resolveStockSolutionOptions; populate all the fields as Null (except Formula, which should just have the formula) *)
	fakePackets = MapThread[
		Function[{id, formula, unitOps, solvent, finalVolume, name, synonym, lightSensitive, expires, discardThreshold, shelfLife, unsealedShelfLife, defaultSC, transportTemperature, heatSensitiveReagents, density, extinctionCoefficients, ventilated, flammable, acid, base, fuming, pyrophoric, incompatibleMat, ultrasonicIncompatible, prepareInResuspensionContainer},
			<|
				Object -> id,
				Type->Model[Sample, StockSolution],
				Formula -> formula,
				UnitOperations -> unitOps,
				PreparationType->UnitOperations,
				Deprecated -> Null,
				FillToVolumeSolvent -> Link[solvent],
				TotalVolume -> finalVolume,
				FillToVolumeMethod -> Null,
				VolumeIncrements -> {},
				Sterile -> Null,
				State -> Liquid,
				MixUntilDissolved -> Null,
				MixTime -> Null,
				MaxMixTime -> Null,
				MixType->Null,
				Mixer -> Null,
				MixRate -> Null,
				NumberOfMixes -> Null,
				MaxNumberOfMixes -> Null,
				PostAutoclaveMixUntilDissolved -> Null,
				PostAutoclaveMixTime -> Null,
				PostAutoclaveMaxMixTime -> Null,
				PostAutoclaveMixRate -> Null,
				PostAutoclaveMixType -> Null,
				PostAutoclaveMixer -> Null,
				PostAutoclaveNumberOfMixes -> Null,
				PostAutoclaveMaxNumberOfMixes -> Null,
				NominalpH -> Null,
				MinpH -> Null,
				MaxpH -> Null,
				pHingAcid -> Null,
				pHingBase -> Null,
				MaxNumberOfpHingCycles -> Null,
				MaxpHingAdditionVolume -> Null,
				MaxAcidAmountPerCycle -> Null,
				MaxBaseAmountPerCycle -> Null,
				FilterMaterial -> Null,
				FilterSize -> Null,
				IncubationTime -> Null,
				IncubationTemperature -> Null,
				PostAutoclaveIncubationTime -> Null,
				PostAutoclaveIncubationTemperature -> Null,
				FillToVolumeParameterized -> Null,
				PreferredContainers -> {},
				Preparable -> True,
				Tablet->False,
				StirBar -> Null,
				(* pretend the fake packet has all the formula-only values which we resolved above *)
				Name->name,
				(* Synonyms is a multiple field so Null needs to be empty list *)
				Synonyms -> (synonym /. {Null -> {}}),
				LightSensitive -> lightSensitive,
				Expires -> expires,
				DiscardThreshold -> discardThreshold,
				ShelfLife -> shelfLife,
				UnsealedShelfLife -> unsealedShelfLife,
				(* needs to be Null because defaultSC is a symbol and not an object, and this is a link field*)
				DefaultStorageCondition -> Null,
				TransportTemperature -> transportTemperature,
				HeatSensitiveReagents -> heatSensitiveReagents,
				Density -> density,
				ExtinctionCoefficients -> extinctionCoefficients,
				Ventilated -> ventilated,
				Flammable -> flammable,
				Acid -> acid,
				Base -> base,
				Fuming -> fuming,
				(* IncompatibleMaterials is a multiple that has {None} *)
				IncompatibleMaterials -> (incompatibleMat /. {Null -> {None}}),
				Pyrophoric -> pyrophoric,
				UltrasonicIncompatible -> ultrasonicIncompatible,
				OrderOfOperations->Null,
				Resuspension -> Null,
				Autoclave->Null,
				AutoclaveProgram->Null,
				PrepareInResuspensionContainer->prepareInResuspensionContainer
			|>
		],
		{
			ssIDs,
			expandedFormulas,
			sanitizedUnitOperations,
			listedSolvents,
			finalVolumes,
			fakePacketNames,
			fakePacketSynonyms,
			fakePacketLightSensitive,
			fakePacketExpires,
			fakePacketDiscardThreshold,
			fakePacketShelfLife,
			fakePacketUnsealedShelfLife,
			fakePacketDefaultStorageCondition,
			fakePacketTransportTemperature,
			fakePacketHeatSensitiveReagents,
			fakePacketDensity,
			fakePacketExtinctionCoefficients,
			fakePacketVentilated,
			fakePacketFlammable,
			fakePacketAcid,
			fakePacketBase,
			fakePacketFuming,
			fakePacketPyrophoricFixed,
			fakePacketIncompatibleMaterials,
			fakeUltrasonicIncompatibleFixed,
			fakePrepareInResuspensionContainer
		}
	];

	(* put some fake Automatics into the formula-only options; this is admittedly a little weird but we're just going to do it *)
	safeOptionsWithFakeAutomatics = ReplaceRule[
		combinedOptions,
		{
			(* the resolved Volume option in this case _needs_ to be what the specified final volume is *)
			Volume -> Lookup[formulaResolvedOptions, Volume],
			(* the resolved Filter and Mix options need to be in there *)
			Mix -> Lookup[formulaResolvedOptions, Mix],
			Filter -> Lookup[formulaResolvedOptions, Filter],
			(* StockSolutionName, ExtinctionCoefficeints, and Density are all Null and can't be Automatic *)
			StockSolutionName->Null,
			ExtinctionCoefficients -> Null,
			Density -> Null,
			Synonyms -> Automatic,
			LightSensitive -> Automatic,
			Expires -> Automatic,
			DiscardThreshold -> Automatic,
			ShelfLife -> Automatic,
			UnsealedShelfLife -> Automatic,
			DefaultStorageCondition -> Automatic,
			TransportTemperature -> Automatic,
			Ventilated -> Automatic,
			Flammable -> Automatic,
			Acid -> Automatic,
			Base -> Automatic,
			Fuming -> Automatic,
			IncompatibleMaterials -> Automatic
		}
	];

	(* resolve options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and will return early *)
	(* note that we can't actually  *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveStockSolutionOptions[fakePackets, ReplaceRule[safeOptionsWithFakeAutomatics, {Output -> {Result, Tests}, Cache -> newCache}]],
			{resolveStockSolutionOptions[fakePackets, ReplaceRule[safeOptionsWithFakeAutomatics, {Output -> Result, Cache -> newCache}]], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* figure out if we want to return early or not *)
	returnEarlyQ = If[gatherTests,
		Not[RunUnitTest[<|"Tests" -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, formulaOptionTests, resolutionTests}]|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		MatchQ[resolveOptionsResult, $Failed] || MatchQ[formulaOptionsResult, $Failed]
	];

	(* remove the PreparatoryVolume option from the resolved options since it isn't really an option *)
	resolvedDensityScouts = Lookup[resolvedOptions, DensityScouts];
	resolvedOptionsNoPrepVolume = Select[resolvedOptions, Not[MatchQ[Keys[#], Alternatives[PreparatoryVolumes,DensityScouts]]]&];

	(* add back the options that we resolved in the first resolver above *)
	resolvedOptionsFinal = ReplaceRule[
		resolvedOptionsNoPrepVolume,
		{
			StockSolutionName->Lookup[formulaResolvedOptions, StockSolutionName],
			Synonyms -> Lookup[formulaResolvedOptions, Synonyms],
			LightSensitive -> Lookup[formulaResolvedOptions, LightSensitive],
			Expires -> Lookup[formulaResolvedOptions, Expires],
			DiscardThreshold -> Lookup[formulaResolvedOptions, DiscardThreshold],
			ShelfLife -> Lookup[formulaResolvedOptions, ShelfLife],
			UnsealedShelfLife -> Lookup[formulaResolvedOptions, UnsealedShelfLife],
			DefaultStorageCondition -> Lookup[formulaResolvedOptions, DefaultStorageCondition],
			TransportTemperature -> Lookup[formulaResolvedOptions, TransportTemperature],
			Density -> Lookup[formulaResolvedOptions, Density],
			ExtinctionCoefficients -> Lookup[formulaResolvedOptions, ExtinctionCoefficients],
			Ventilated -> Lookup[formulaResolvedOptions, Ventilated],
			Flammable -> Lookup[formulaResolvedOptions, Flammable],
			Acid -> Lookup[formulaResolvedOptions, Acid],
			Base -> Lookup[formulaResolvedOptions, Base],
			Fuming -> Lookup[formulaResolvedOptions, Fuming],
			IncompatibleMaterials -> Lookup[formulaResolvedOptions, IncompatibleMaterials]
		}
	];

	(* need to return early if something bad happened because we're FastTracking USSM below and that would trainwreck otherwise *)
	If[returnEarlyQ,
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, formulaOptionTests, resolutionTests}],
				Preview -> Null,
				Options -> resolvedOptionsFinal
			}
		]
	];

	(* --- Generate the options we are actually going to pass to UploadStockSolution *)

	(* pull out the specified values of MixType/Mixer/MixRate before resolution *)
	{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes} = Lookup[resolvedOptionsFinal, {MixType, Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}];

	(* decide if we are going to pass the MixType/Mixer/MixRate down to UploadStockSolution *)
	(* basically, if MixType was specified, then pass down whichever of the three of MixType/Mixer/MixRate/NumberOfMixes/MaxNumberOfMixes was specified down to UploadStockSolution *)
	(* if it was not, then pass down nothing *)
	optionalMixOptions = MapThread[
		If[MatchQ[#1, MixTypeP],
			Flatten[{MixType, PickList[{Mixer, MixRate, NumberOfMixes, MaxNumberOfMixes}, {#2, #3, #4, #5}, Except[Automatic|Null]]}],
			{}
		]&,
		{specifiedMixType, specifiedMixer, specifiedMixRate, specifiedNumMixes, specifiedMaxNumMixes}
	];


	(* assign the names of options that are identical between USSM and ExperimentStockSolution *)
	(* for each formula include the mix options or not *)
	ussmExperimentSharedOptionNames = Map[
		Flatten[{
			Synonyms,
			Mix, MixUntilDissolved, MixTime, MaxMixTime, #,
			MinpH, MaxpH, pHingAcid, pHingBase,
			Filter, FilterMaterial, FilterSize,
			LightSensitive, Expires, DiscardThreshold, ShelfLife,
			UnsealedShelfLife, DefaultStorageCondition, Density, ExtinctionCoefficients, TransportTemperature, HeatSensitiveReagents, Ventilated,
			Flammable, Acid, Base, Fuming, IncompatibleMaterials,
			Incubate, IncubationTemperature, IncubationTime, PostAutoclaveIncubate, PostAutoclaveIncubationTemperature,
			PostAutoclaveIncubationTime, OrderOfOperations,	Autoclave, AutoclaveProgram, FillToVolumeMethod,
			PrepareInResuspensionContainer, Type,	Supplements, DropOuts, GellingAgents, MediaPhase
		}]&,
		optionalMixOptions
	];

	(* make the listy options we are going to pass into USSM *)
	(* need to use MapIndexed to properly include the index *)
	ussmReadyListyOptions = MapIndexed[
		Function[{optionNames, indexNum},
			Join[
				(* different between USSM/ExpSS *)
				{
					Name->Extract[Lookup[resolvedOptionsFinal, StockSolutionName], indexNum],

					(* bit of name inconsistency here too *)
					NominalpH -> Extract[Lookup[resolvedOptionsFinal, pH], indexNum],

					SafetyOverride->Lookup[resolvedOptionsFinal, SafetyOverride],

					(* set Output option to send to USSM; depends on if we need tests, but we ALWAYS want Reult/Options *)
					Output -> If[gatherTests,
						{Result, Tests},
						Result
					],

					(* we always want to NOT upload yet *)
					Upload -> False,

					(* send in passed cache plus new download cache *)
					Cache -> newCache,
					(* at this point we've already done all our error checking that UploadStockSolution is also doing, so we don't need to do it again *)
					FastTrack -> True
				},

				(* same between UploadStockSolution and ExpSS; pipe 'em innnn *)
				Map[
					If[MatchQ[Lookup[resolvedOptionsFinal, #], _List] && !MatchQ[#,Supplements|DropOuts|HeatSensitiveReagents|GellingAgents],
						# -> Extract[Lookup[resolvedOptionsFinal, #], indexNum],
						# -> Lookup[resolvedOptionsFinal, #]
					]&,
					optionNames
				]
			]
		],
		ussmExperimentSharedOptionNames
	];

	(* change all the index matching options into just the singleton cases, and change some Nulls to necessary non-nuls  *)
	(* need to map at level {2} because we're mapping over individual option names in a list of list of options *)
	ussmReadyOptions = Map[
		Which[
			(* lots of Safety information can't be Null so make them False for USSM *)
			MatchQ[Keys[#], LightSensitive|Expires|Ventilated|Flammable|Acid|Base|Fuming], (# /. {Null -> False}),
			(* DefaultStorageCondition can't be Null so make it AmbientStorage for USSM *)
			MatchQ[Keys[#], DefaultStorageCondition], (# /. {Null -> AmbientStorage}),
			(* DiscardThreshold can't be Null so make it 5 Percent for USSM *)
			MatchQ[Keys[#], DiscardThreshold], (# /. {Null -> 5 Percent}),
			(* IncompatibleMaterials, Synonyms, Cache, ExtinctionCoefficients, and Output are all lists but not index matching options, so don't expand them; otherwise, expand all the index matching options *)
			MatchQ[Values[#], _List] && Not[MatchQ[Keys[#], Cache|Output|Synonyms|IncompatibleMaterials|ExtinctionCoefficients|OrderOfOperations]], Keys[#] -> First[Values[#]],
			True, #
		]&,
		ussmReadyListyOptions,
		{2}
	];

	(* call USSM (appropriate overload) with our formula, solvent, and options;
	 	- it will return EITHER a change packet for a new model, or an existing model
		- the above set of ussmReadyOptions has Output option in it *)
	(* note that if we are using the Sample input and there is no model, then we are not going to call UploadStockSolution *)
	allUploadStockSolutionModelFailure = Check[
		allUploadStockSolutionModelOutputs = MapThread[
			Function[{unitOperations,options},
				Quiet[UploadStockSolution[unitOperations, Sequence @@ options], {Warning::SpecifedMixRateNotSafe}]
			],
			{sanitizedUnitOperations, ussmReadyOptions}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* pull out the stock solution results and the tests *)
	newModelChangePacketsOrExistingModels = If[gatherTests,
		allUploadStockSolutionModelOutputs[[All, 1]],
		allUploadStockSolutionModelOutputs
	];
	ussmTests = If[gatherTests,
		allUploadStockSolutionModelOutputs[[All, 2]],
		{}
	];

	(* need to return early if USS returned a bad input/option error *)
	If[MatchQ[allUploadStockSolutionModelFailure, $Failed|{$Failed}],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, resolutionTests, ussmTests}],
				Preview -> Null,
				Options -> resolvedOptionsFinal
			}
		]
	];



	(* call the stockSolutionResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPackets, frqTests} = If[gatherTests,
		stockSolutionResourcePackets[
			newModelChangePacketsOrExistingModels,
			Lookup[resolvedOptionsFinal, Volume],
			{},
			{},
			{},
			ConstantArray[Null, Length[newModelChangePacketsOrExistingModels]],
			ConstantArray[Null, Length[newModelChangePacketsOrExistingModels]],
			ReplaceRule[resolvedOptionsFinal, {Output -> {Result, Tests}}],
			unresolvedOptions
		],
		{stockSolutionResourcePackets[
			newModelChangePacketsOrExistingModels,
			Lookup[resolvedOptionsFinal, Volume],
			{},
			{},
			{},
			ConstantArray[Null, Length[newModelChangePacketsOrExistingModels]],
			ConstantArray[Null, Length[newModelChangePacketsOrExistingModels]],
			ReplaceRule[resolvedOptionsFinal, {Output -> Result}],
			unresolvedOptions
		], {}}
	];

	(* --- assembling outputs time!!!  --- *)

	(* get all the options for the UploadProtocol call *)
	uploadProtocolOptions = Sequence[
		Confirm -> Lookup[resolvedOptionsFinal, Confirm],
		CanaryBranch -> Lookup[resolvedOptionsFinal, CanaryBranch],
		ConstellationMessage -> Object[Protocol, StockSolution],
		ParentProtocol -> Lookup[resolvedOptionsFinal, ParentProtocol],
		Upload -> Lookup[resolvedOptionsFinal, Upload],
		Email -> Lookup[resolvedOptionsFinal, Email],
		FastTrack -> Lookup[resolvedOptionsFinal, FastTrack],
		Priority -> Lookup[combinedOptions,Priority],
		StartDate -> Lookup[combinedOptions,StartDate],
		HoldOrder -> Lookup[combinedOptions,HoldOrder],
		QueuePosition -> Lookup[combinedOptions,QueuePosition]
	];

	(* get the protocol packet and, if they exist, the extra packets *)
	{protocolPacket, extraPackets} = Switch[finalizedPackets,
		PacketP[Object[Protocol, StockSolution]], {finalizedPackets, {}},
		$Failed, {$Failed, $Failed},
		_, {First[finalizedPackets], Rest[finalizedPackets]}
	];

	(* --- re-resolve the density scouting runs. --- *)
	(* this is really problematic because the density scouts that are resolved by the resolver in the formula case are generated from fakePackets and therefore correspond to nonexistent objects.
	 These objects, even when uploaded, are not valid, so the solution here was to figure out which SS models are created from the actual formulas, and then use those as the density scout models.
	 However, we also have to force the density scouting procedure to use Volumetric FillToVolume method, otherwise it's possible to create a recursive density scouting sub-protocol here. *)

	(* the resolved Density Scouts are now out of date because they don't exist in the database. we need to pull StockSolutionModels, FillToVolumeMethods *)
	{finalSSModels, ftvMethods, densityScouts} = Switch[
		protocolPacket,
		$Failed,
		{{},{},{}},
		_,
		Lookup[protocolPacket,{Replace[StockSolutionModels],Replace[FillToVolumeMethods],Replace[DensityScouts]},{}]];

	(* a priori it seems impossible to determine which stock solution models will be needed to create the call in question, so we will create a cache for the density of all the stock solutions.
	 To avoid duplicating cache packets, we will only download finalSSModels that are not present in the extraPackets *)
	stockSolutionModelCache = Join[
		Quiet[
			Download[Complement[Cases[finalSSModels, _Model, All],Lookup[extraPackets,Object,{}]],Packet[Density]],
			{Download::ObjectDoesNotExist}
		],
		extraPackets
	];

	(* re-determine whether we need to density scout *)
	reResolvedDensityScouts = Link/@MapThread[
		Function[{resolvedFillToVolumeMethod,stockSolutionModel},
			If[MatchQ[resolvedFillToVolumeMethod,Gravimetric]&&MatchQ[Lookup[fetchPacketFromCache[stockSolutionModel,stockSolutionModelCache],Density],(Null)],
				Download[stockSolutionModel,Object],
				Nothing
			]
		],
		{ftvMethods,finalSSModels}
	];

	(* replace the density scouts in the packet with the ones we just created *)
	updatedProtocolPacket = Join[protocolPacket,Association[Replace[DensityScouts]->reResolvedDensityScouts]];

	(* combine all the tests together *)
	allTests = Cases[
		Flatten[{applyTemplateOptionTests, safeOptionTests, validLengthTests, ussmTests, formulaOptionTests, resolutionTests, frqTests}],
		_EmeraldTest
	];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[updatedProtocolPacket, $Failed], False,
		gatherTests && MemberQ[listedOutput, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* asemble our options return rule; don't need to collapse indexed, we should have errored if we got any listed options *)
	optionsRule = Options -> Which[
		MemberQ[listedOutput, Options] && !NullQ[Lookup[resolvedOptionsFinal,MediaPhase,Null]],
			Module[{finalOptionsNoType},
				(* Don't send Type back to ExperimentMedia, it is not an option there *)
				finalOptionsNoType = Normal[KeyDrop[resolvedOptionsFinal,Type],Association];

				(* Collapse and remove media hidden options *)
				RemoveHiddenOptions[ExperimentMedia,CollapseIndexMatchedOptions[ExperimentStockSolution, finalOptionsNoType, Messages -> False, Ignore -> listedOptions]]
			],
		MemberQ[listedOutput, Options],
			RemoveHiddenOptions[ExperimentStockSolution, CollapseIndexMatchedOptions[ExperimentStockSolution, resolvedOptionsFinal, Messages -> False, Ignore -> listedOptions]],
		True,
			Null
	];

	(* generate the Preview rule as a Nul *)
	previewRule = Preview -> Null;

	(* assemble all tess we created; a couple of these variables are lists of lists of tests so just flatten it all up *)
	testsRule = Tests -> If[gatherTests,
		allTests
	];

	(* generate the result rule; don't do it if ANY of our invalidity checks above were tripped *)
	resultRule = Result -> Which[
		MatchQ[newModelChangePacketsOrExistingModels, $Failed], $Failed,
		MemberQ[listedOutput, Result] && validQ && MatchQ[extraPackets, {}], UploadProtocol[updatedProtocolPacket, uploadProtocolOptions],
		MemberQ[listedOutput, Result] && validQ, UploadProtocol[updatedProtocolPacket, extraPackets, uploadProtocolOptions],
		True, $Failed
	];

	(* return everything asked for (with original listing/non-listing!!) *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}
];





(* ::Subsubsection::Closed:: *)
(* resolveStockSolutionOptions (options) *)


DefineOptions[resolveStockSolutionOptions,
	SharedOptions :> {ExperimentStockSolution}
];



(* ::Subsubsection:: *)
(* resolveStockSolutionOptions (template overload) *)


resolveStockSolutionOptions[myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..}, myResolutionOptions:OptionsPattern[resolveStockSolutionOptions]]:=Module[
	{combinedOptions, specifiedContainerOut, containerOutObjects, preparedResources, parentProtocol,
		stockSolutionDownloadTuples, containerOutDownloadTuples, preparedResourceDownloadTuples, resolvedAdjustpHBools,
		parentProtocolDownloadTuple, output, outputSpecification, gatherTests, messages, fastTrack,
		stockSolutionModelPackets,stockSolutionFormulaPackets, stockSolutionSolventPackets, solutionDeprecatedTests, formulaOnlyOptionNames,
		formulaOnlyOptionWarnings, multipleFixedAmountComponentsBools, invalidPreparationBools,invalidResuspensionAmountBools, multipleFixedAmountComponents,
		multipleFixedAmountComponentsTests,invalidPreparationOptions,invalidPreparationTests, invalidResuspensionAmountsOptions,invalidResuspensionAmounts,
		invalidResuspensionAmountsTests, expandedOptions, inEngine, rootProtocolPacket, specifiedContainerOutPackets,
		prepResourcesOrNulls, expandedVolumeOption, sanitizedExpandedVolumeOption, resolvedMixBools, resolvedIncubateBools,
		resolvedFilterBools, preFiltrationImage, preFiltrationError, preFiltrationTest, preFiltrationOptionFailure,
		resolvedPreFiltrationImage, formulaVolumes, prepVolumes, modelNumMixes, modelMaxNumMixes, modelMixUntilDissolveds,
		prepOptionNames, prepOptionsByModel, mixSubOptionNames, mixOptionsSetIncorrectly, mixSubOptionsSetIncorrectlyTests,
		resolvedLightSensitive, resolvedPrepContainers, resolvedPrepContainerPackets, mixedStockSolutionModels, mixedStockSolutionModelOptions,
		mixingTemperature, modelMixRates, modelMixTypes, modelMixers, potentialMixDevices, passModelValuesQ,
		mixedStockSolutionContainers, ssToMixOptionNameMap,
		renamedMixOptions, preResolvedMixOptions, mixResolveFailure, resMixOptions, mixResolvingTests,
		resolvedPreparationVolumes, resolvedVolumes, preResolvedPreparationVolumes, preResolvedVolumes, mixedStockSolutionPrepVolumes, mixOptionsByModel,
		mixToSSOptionNameMap, mixedResolvedMixOptionsWithExtras, mixedResolvedMixOptions, mixedResolvedMixOptionsPerModel,
		notMixedStockSolutionModels, notMixedStockSolutionModelOptions, notMixedResolvedMixOptionsPerModel,
		resolvedMixOptionsPerModel, resolvedMixOptions, mixedStockSolutionLightSensitives,
		filteredResolvedFilterOptionsPerModel, notFilteredStockSolutionModels,
		notFilteredStockSolutionModelOptions, notFilteredResolvedFilterOptionsPerModel,
		resolvedFilterOptionsPerModel, resolvedFilterOptions, filterResolveFailure, resFilterOptions, filterResolvingTests,
		filterToSSOptionNameMap, filteredResolvedFilterOptionsWithExtras, filteredResolvedFilterOptions, filterSubOptionNames,
		filterOptionsByModel, filterOptionsSetIncorrectly, filterSubOptionsSetIncorrectlyTests, filteredStockSolutionModels,
		filteredStockSolutionModelOptions, filteredStockSolutionContainers, filteredStockSolutionPrepVolumes,
		ssToFilterOptionNameMap, renamedFilterOptions, preResolvedFilterOptions, volumeTooLowForFiltration,
		filtrationVolumeTooLowTests, pHingSubOptionNames, pHingOptionsByModel, pHingOptionsSetIncorrectly,
		pHingOptionsSetIncorrectlyTests, volumeTooLowForpHing, pHVolumeTooLowTests, pHOptionOrderSetIncorrectly,
		pHOptionOrderSetIncorrectlyTests, resolvedpHingOptionsPerModel, resolvedpHingOptions,
		expandedContainerOutWithPackets, incompatibleContainerOutTest, incompatibleContainerOutOptions,
		containerOutDeprecated, deprecatedContainerOutTest, containerOutTooSmall,
		containerOutTooSmallTests, nameInUseTests, resolvedEmail, resolvedPostProcessingOptions, resolvedMaxNumberOfOverfillingRepreparations,
		resolvedContainerOut, containerOutIncompatibleMaterialQ,
		resolvedOrderOfOperations,expandedOrderOfOperations,expandedAutoclavePrograms,expandedAutoclaveBooleans,resolvedAutoclavePrograms,resolvedPrepareInResuspensionContainer,
		resolvedAutoclaveBooleans,containerOutTooLowMaxTemperature,containerOutTooLowMaxTemperatureTests, containerOutTooLowMaxTemperatureOptions,
		pseudoResolvedFormulaOnlyOptions, resolvedOptions, resultRule, testsRule, mixedPositions, notMixedPositions,
		mixedPositionReplaceRules, notMixedPositionReplaceRules, filteredPositions, notFilteredPositions,
		filteredPositionReplaceRules, notFilteredPositionReplaceRules, mixedMixUntilDissolveds, preResolvedMixOptionsPerModel,
		preResolvedFilterOptionsPerModel, mixSubSubOptionNames, volumetricFlasks, volumetricFlaskPackets,
		incubateSubSubOptionNames, relevantErrorCheckingMixOptionsByModel, mixedResolvedMixOptionsPerModelWithProperTemp,
		mixOrIncubateBools, allSimulatedSampleValues, mixSimulatedSamplePackets, mixSimulatedSampleContainers,
		mixSimulatedSamplePacketsWithExtraFields, mixIncubateTimeMismatchTests, preResolvedMixTimes,
		preResolvedIncubationTimes, mixedIncubations, mixedMixes, mixedMixTimes, allFilterSimulatedSampleValues,
		filterSimulatedSamplePackets, filterSimulatedSampleContainers,
		filterSimulatedSamplePacketsWithExtraFields, roundedExpandedOptions, precisionTests,
		componentsScaledOutOfRangeErrors, belowFillToVolumeMinimumErrors, aboveFillToVolumeMaximumErrors, belowpHMinimumErrors, belowFiltrationMinimumErrors,
		volumeOverMaxIncrementErrors, volumeNotInIncrementsErrors, expandedVolumeIncrements, badComponents,
		badScaledComponentAmounts, volumeNotInIncrementsTests, deprecatedInvalidInputs, prepFormulaInvalidInputs, prepFormulaTests,prepTypeInvalidInputs, prepTypeTests,
		componentsScaledOutOfRangeTests, volumeOverMaxIncrementTests, volumeOverMaxIncrementOptions, volumeNotInIncrementsOptions,
		pHOptionOrderSetIncorrectlyOptions, componentsScaledOutOfRangeOptions, belowFillToVolumeMinimumOptions, aboveFillToVolumeMaximumOptions,
		belowFillToVolumeMinimumTests, aboveVolumetricFillToVolumeMaximumTests, belowpHMinimumOptions, belowpHMinimumTests, pHingOptionsSetIncorrectlyOptions,
		mixIncubateTimeMismatchOptions, mixSubOptionsSetIncorrectlyOptions, filterSubOptionsSetIncorrectlyOptions,
		filtrationVolumeTooLowOptions, pHVolumeTooLowOptions, nameInvalidOptions, deprecatedContainerOutOptions,
		containerOutTooSmallOptions,containerOutFailed,containerOutFailedTests,containerOutFailedOptions, invalidOptions, invalidInputs, incubateOptionsSetIncorrectly,
		incubateSubOptionsSetIncorrectlyTests, incubateSubOptionsSetIncorrectlyOptions,
		preResolvedMixers, preResolvedIncubators, mixIncubateInstMismatchTests, mixIncubateInstMismatchOptions,
		mixedIncubationTimes, mixedMixers, mixedIncubators, filteredStockSolutionLightSensitives,resolvedFillToVolumeMethods,
		fillToVolumeMethodUltrasonicOptions, fillToVolumeMethodVolumetricOptions, fillToVolumeMethodNoSolventOptions, densityScouts, cache, invalidFillToVolumeMethodsUltrasonic,
		invalidFillToVolumeMethodsVolumetric, invalidFillToVolumeMethodsNoSolvent,
		formulaComponentTotalVolumes, totalVolumes, invalidModelFormulaForFillToVolumeErrors,
		InvalidModelFormulaForFillToVolumeInputs, validFormulaForFillToVolumeTests,
		volumeTooLowForAutoclaveWarnings, volumeTooLowForAutoclaveTests,
		automaticContainerOutAutoclaveBooleans,automaticContainerOutpHBooleans,compatibleVolumetricFlasksForSSModel,compatibleVolumetricFlaskVolumesForSSModel,maxCompatibleVolumetricFlaskVolumeForSSModel, numReplicates,
		numReplicatesNoNull, numSamples, tooManySamplesQ, tooManySamplesInputs, tooManySamplesTest,resolvedpH,resolvedMinpH,resolvedMaxpH,
		resolvedpHingAcid,resolvedpHingBase,incompletelySpecifiedpHingQ,incompletelySpecifiedpHingTests,
		nullpHingOptionsQ, unspecifiedMinpH,unspecifiedMaxpH,unspecifiedpHingAcid,unspecifiedpHingBase, incompletelySpecifiedpHingOptions,
		resolvedPrimitives, stockSolutionModelPrimitives, allDownloadValues, newCache, fastAssoc, expandedContainerOutWithPacketsWithAutomatics,
		expandedHeatSensitiveReagents, autoclaveHeatSensitiveBools, invalidAutoclaveHeatSensitiveOptions, autoclaveHeatSensitiveTests,
		postAutoclaveMixIncubateTimeMismatchTests,postAutoclaveMixIncubateTimeMismatchOptions,postAutoclaveMixIncubateInstMismatchTests,
		postAutoclaveMixIncubateInstMismatchOptions,postAutoclaveMixSubOptionsSetIncorrectlyTests,postAutoclaveMixSubOptionsSetIncorrectlyOptions,
		postAutoclaveIncubateSubOptionsSetIncorrectlyTests,postAutoclaveIncubateSubOptionsSetIncorrectlyOptions,postAutoclaveMixResolvingTests,
		resolvedPostAutoclaveMixOptions,resolvedPostAutoclaveIncubateBools,resolvedPostAutoclaveMixBools,resolvedGellingAgents,
		resolvedMediaPhases,solidMediaWithFilterBools,invalidSolidMediaWithFilterOptions,solidMediaWithFilterTests,mediaNoAutoclaveNonSterileBools,
		invalidMediaNoAutoclaveNonSterileOptions,mediaNoAutoclaveNonSterileTests,preResolvedFilterOptionsWithSterilePerModel,
		filteredStockSolutionSteriles,filterSterileBools,scaledUpVolumes, specifiedStirBars, resolvedStirBars, resolvedHeatSensitiveReagents,
		resolvedTypes, mixRateNotSafeTests, mixRateNotSafeOptions, mixRateNotSafe
	},

	(* make sure the input options are listed *)
	combinedOptions = ToList[myResolutionOptions];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get Cache and FastTrack, it will control error-checks after here *)
	{cache, fastTrack} = Lookup[combinedOptions, {Cache, FastTrack}];


	(* --- pull out information we need to Download from, and then Download it --- *)

	(* Do 2 downloads here to first get any containers included in the UnitOperations field of the stock solution model. *)
	stockSolutionModelPrimitives = Quiet[
		Download[myModelStockSolutions, UnitOperations, Cache -> cache],
		{Download::FieldDoesntExist}
	];

	(* get the ContainerOut option; we need to download some stuff if anything was specified; Cases works even if ContainerOut is singleton, returns a list *)
	specifiedContainerOut = Lookup[combinedOptions, ContainerOut];
	containerOutObjects = Join[
		Cases[ToList[specifiedContainerOut], ObjectP[]],
		Cases[Join[{Lookup[combinedOptions, UnitOperations], stockSolutionModelPrimitives}], ObjectReferenceP[{Model[Container], Object[Container]}], Infinity],
		PreferredContainer[All],
		PreferredContainer[All, LightSensitive -> True]
	];

	(* get the PreparedResources option; this is hidden, ASSUME it is index-matched if present; sent in by Engine when doing ResourcePrep *)
	preparedResources = Lookup[combinedOptions, PreparedResources];

	(* find the parent protocol; may need it to resolve the ImageSample option *)
	parentProtocol = Lookup[combinedOptions, ParentProtocol];

	(* find all the volumetric flasks if we have at least one volumetric fill to volume*)
	volumetricFlasks = Search[Model[Container, Vessel, VolumetricFlask], Deprecated != True && MaxVolume != Null && DeveloperObject != True];

	(* download required information from the models, containers, and prepared resources; Quiet for the Tablet field from the Formula *)
	allDownloadValues = Quiet[Download[
		{
			myModelStockSolutions,
			containerOutObjects,
			preparedResources,
			{parentProtocol},
			volumetricFlasks
		},
		{
			{
				Packet[
					Name, Deprecated, Formula, FillToVolumeSolvent, TotalVolume, FillToVolumeMethod, VolumeIncrements, Sterile, State, Tablet, Type,

					MixUntilDissolved, MixTime, MaxMixTime, MixRate, MixType, Mixer, NumberOfMixes, MaxNumberOfMixes,
					PostAutoclaveMixUntilDissolved, PostAutoclaveMixTime, PostAutoclaveMaxMixTime, PostAutoclaveMixRate, PostAutoclaveMixType,
					PostAutoclaveMixer, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes,

					NominalpH, MinpH, MaxpH, pHingAcid, pHingBase,

					FilterMaterial, FilterSize,

					IncubationTime, IncubationTemperature,
					PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature,

					PreferredContainers, Preparable, Resuspension,

					LightSensitive, Expires, DiscardThreshold, ShelfLife, UnsealedShelfLife, DefaultStorageCondition,
					TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Sterile, Acid, Base, Fuming, Pyrophoric, IncompatibleMaterials,
					FillToVolumeParameterized,UltrasonicIncompatible,OrderOfOperations,Autoclave,AutoclaveProgram,PrepareInResuspensionContainer, HeatSensitiveReagents,

					UnitOperations,PreparationType
				],
				Packet[DefaultStorageCondition[{StorageCondition}]],
				Packet[Formula[[All, 2]][{Deprecated, State, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, Tablet,Density, FixedAmounts}]],
				Packet[Formula[[All, 2]][DefaultStorageCondition][{StorageCondition}]],
				Packet[FillToVolumeSolvent[{Deprecated, State, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, LightSensitive, UltrasonicIncompatible}]],
				Packet[FillToVolumeSolvent[DefaultStorageCondition][{StorageCondition}]],
				Packet[PreferredContainers[{Name, Deprecated, MaxVolume, MinVolume, VolumeCalibrations, PreferredMixer, InternalDimensions, MaxTemperature, Dimensions, ContainerMaterials}]]
			},
			{
				Packet[Name, Deprecated, MaxVolume, MinVolume, VolumeCalibrations, PreferredMixer, InternalDimensions, MaxTemperature, Dimensions, Resolution, ContainerMaterials, MaxOverheadMixRate]
			},
			{
				Packet[RentContainer]
			},
			{
				Packet[Author, ImageSample],
				Packet[Repeated[ParentProtocol][{Author, ImageSample}]]
			},
			{
				Packet[Object, MaxVolume, ContainerMaterials, Opaque]
			}
		},
		Cache -> cache,
		Date -> Now
	], {Download::FieldDoesntExist, Download::NotLinkField}];
	{stockSolutionDownloadTuples, containerOutDownloadTuples, preparedResourceDownloadTuples, {parentProtocolDownloadTuple}, volumetricFlaskPackets} = allDownloadValues;

	(* combine what we've Downloaded here to make a new cache *)
	newCache = FlattenCachePackets[{cache, allDownloadValues}];

	(* make a fast association here for future use *)
	fastAssoc = makeFastAssocFromCache[newCache];

	(* get the packets for the input objects in index order *)
	stockSolutionModelPackets = stockSolutionDownloadTuples[[All, 1]];
	stockSolutionFormulaPackets = stockSolutionDownloadTuples[[All, 3]] /. {Null}->{};
	stockSolutionSolventPackets = stockSolutionDownloadTuples[[All, 5]];

	(* check for deprecated stock solution models *)
	{deprecatedInvalidInputs, solutionDeprecatedTests} = If[!fastTrack,
		Module[{deprecatedBools, tests},

			(* get bools for each object indicating deprecation *)
			deprecatedBools = TrueQ[Lookup[#, Deprecated]]& /@ stockSolutionModelPackets;

			(* make tests if we're on that grind *)
			tests = If[gatherTests,
				MapThread[
					Test["Stock solution " <> ToString[#1] <> " is active (not deprecated).",
						#2,
						False
					]&,
					{myModelStockSolutions, deprecatedBools}
				],
				{}
			];

			(* yell about deprecated if not tests *)
			If[Not[gatherTests] && MemberQ[deprecatedBools, True],
				Message[Error::DeprecatedStockSolutions, ObjectToString[PickList[myModelStockSolutions, deprecatedBools]]]
			];

			(*return overall check-tripped bool, and tests *)
			{PickList[Lookup[stockSolutionModelPackets, Object, {}], deprecatedBools], tests}
		],

		(*assume it's fine *)
		{{}, {}}
	];

	(*check for whether Preparable is set to False *)
	{prepFormulaInvalidInputs, prepFormulaTests} = If[!fastTrack,
		Module[{nonPreppableBools, tests},

			(* get bools for each object indicating that we can't prepare it *)
			nonPreppableBools = MatchQ[Lookup[#, Preparable], False]& /@ stockSolutionModelPackets;

			(* make tests for non-preparable solutions *)
			tests = If[gatherTests,
				MapThread[
					Test["Stock solution " <> ToString[#1] <> " does not have Preparable -> False.",
						#2,
						False
					]&,
					{myModelStockSolutions, nonPreppableBools}
				]
			];

			(* yell about deprecated if not tests *)
			If[Not[gatherTests] && MemberQ[nonPreppableBools, True],
				Message[Error::NonPreparableStockSolutions, ObjectToString[PickList[myModelStockSolutions, nonPreppableBools]]]
			];

			(*return overall check-tripped bool, and tests *)
			{PickList[Lookup[stockSolutionModelPackets, Object, {}], nonPreppableBools], tests}

		],

		(* assume it's fine *)
		{{}, {}}
	];

	(*checkthat we don't mix formula and unitops-based templates *)
	{prepTypeInvalidInputs, prepTypeTests} = If[!fastTrack,
		Module[{prepTypes, formula, unitOps, resolvedPrepTypes, tests, formulaModels,unitOpsModels,prepTypeInvalidInputsQ},

			(* get bools for each object indicating preparation type *)
			prepTypes = Lookup[#, PreparationType,Null]& /@ stockSolutionModelPackets;
			formula = Lookup[#, Formula,{}]& /@ stockSolutionModelPackets;
			unitOps = Lookup[#, UnitOperations, {}]& /@ stockSolutionModelPackets;

			(* just in case we have models with both formula and Unit Ops, we will relay on all three parameters *)
			resolvedPrepTypes = MapThread[Function[{prepType, populatedFormula, populatedUnitOperations},
				Which[
					MatchQ[prepType, Null]&&MatchQ[populatedUnitOperations, Except[Null|{}]],
						UnitOperations,
					MatchQ[prepType, Null]&&MatchQ[populatedFormula, Except[Null|{}]]&&!MatchQ[populatedUnitOperations, Except[Null|{}]],
						Formula,
					True,
						prepType
				]],
				{prepTypes, formula, unitOps}
			];

			(* split the models based on prep type *)
			formulaModels = PickList[Lookup[stockSolutionModelPackets, Object], resolvedPrepTypes, Formula];
			unitOpsModels = PickList[Lookup[stockSolutionModelPackets, Object], resolvedPrepTypes, UnitOperations];

			prepTypeInvalidInputsQ = Length[DeleteDuplicates[resolvedPrepTypes]]>1;

			(* make tests for non-preparable solutions *)
			tests = If[gatherTests,
					Test["All specified models have the same PreparationType.",
						prepTypeInvalidInputsQ,
						False
					]
			];

			(* yell about prepTypes if not tests *)
			If[Not[gatherTests] && prepTypeInvalidInputsQ,
				Message[Error::TemplatesPreperationTypeConflict, ObjectToString/@formulaModels,ObjectToString/@unitOpsModels]
			];

			(*return overall check-tripped bool, and tests *)
			{If[prepTypeInvalidInputsQ,Lookup[stockSolutionModelPackets, Object, {}],{}], tests}

		],

		(* assume it's fine *)
		{{}, {}}
	];

	(* make sure we don't have too many samples; if we're in engine we don't care *)

	(* set a bool indicating if we are in Engine doing Resource fulfilment; determine this if we were passed prepared resources *)
	inEngine = MatchQ[preparedResources, {ObjectP[Object[Resource, Sample]]..}];

	(* pull out the NumberOfReplicates option *)
	numReplicates = Lookup[combinedOptions, NumberOfReplicates];
	numReplicatesNoNull = numReplicates /. {Null -> 1};

	(* get the number of samples *)
	numSamples = If[NullQ[myModelStockSolutions],
		Length[myModelStockSolutions],
		Length[myModelStockSolutions] * numReplicatesNoNull
	];

	(* if we have more than 10 samples and we're not in engine, throw an error *)
	tooManySamplesQ = Not[inEngine] && numSamples > 10;

	(* if there are more than 96 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManySamplesInputs = Which[
		TrueQ[tooManySamplesQ] && messages,
		(
			Message[Error::StockSolutionTooManySamples, 10];
			Download[myModelStockSolutions, Object]
		),
		TrueQ[tooManySamplesQ], Download[myModelStockSolutions, Object],
		True, {}
	];

	(* if we are gathering tests, create a test indicating whether we have too many samples or not *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided times NumberOfReplicates is not greater than 10:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(* expand the index matched stuff; EIMI will give us inputs too, we don't want, just get the options *)
	expandedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution, {myModelStockSolutions}, combinedOptions, 1]];

	(* ensure that all the numerical options have the proper precision *)
	{roundedExpandedOptions, precisionTests} = If[gatherTests,
		Normal[RoundOptionPrecision[Association[expandedOptions], {Volume, pH, MinpH, MaxpH}, {10^-2*Microliter, 10^-2, 10^-2, 10^-2}, Output -> {Result, Tests}]],
		{Normal[RoundOptionPrecision[Association[expandedOptions], {Volume, pH, MinpH, MaxpH}, {10^-2*Microliter, 10^-2, 10^-2, 10^-2}]], {}}
	];

	(* set the option names that we are gonna ignore in this overload (formula only) *)
	formulaOnlyOptionNames = {
		StockSolutionName, Synonyms, LightSensitive, Expires, DiscardThreshold, ShelfLife, UnsealedShelfLife, DefaultStorageCondition,
		TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming,
		IncompatibleMaterials
	};

	(* warn about options set that are only accessible by the formula overload *)
	formulaOnlyOptionWarnings = If[!fastTrack,
		Module[{optionValues, optionSetBools, warning},

			(* get the option values for each of these formula-only options *)
			optionValues = Lookup[combinedOptions, #]& /@ formulaOnlyOptionNames;

			(* all of these are set if they are not Automatic; EXCEPT Density/StockSolutionName/ExtinctionCoefficients/TransportTemperature, which starts at Null *)
			optionSetBools = MapThread[
				If[MatchQ[#1, Density | StockSolutionName |  ExtinctionCoefficients],
					MatchQ[#2, Except[Null]],
					MatchQ[#2, Except[Automatic]]
				]&,
				{formulaOnlyOptionNames, optionValues}
			];

			(* make warnings for all of these options; pretty ridiculous to make one warning per *)
			warning = If[gatherTests,
				Warning["Options that are only used with the formula input definition are not set if stock solution models are provided as input.",
					MemberQ[optionSetBools, True],
					False
				],
				Nothing
			];

			(* yell about these (warn) *)
			If[Not[gatherTests]&& MemberQ[optionSetBools, True] && Not[MatchQ[$ECLApplication, Engine]],
				Message[Warning::FormulaOptionsUnused, PickList[formulaOnlyOptionNames, optionSetBools]]
			];

			(* return the warning we made for accumulation later *)
			{warning}
		],

		(* don't bother if on FastTrack *)
		{}
	];

	(* resolve the Name (for the protocol itself) option; just gotta check if it's in use already *)
	{nameInvalidOptions, nameInUseTests} = If[Not[fastTrack] && MatchQ[Lookup[combinedOptions, Name], _String],
		Module[{providedName, nameUsed, test},

			(* pull the desired name from the options *)
			providedName = Lookup[combinedOptions, Name];

			(* assign a bool indicating if this name is already in Constellation *)
			nameUsed = DatabaseMemberQ[Object[Protocol, StockSolution, providedName]];

			(* make a test *)
			test = If[gatherTests,
				Test["Name " <> providedName <> " is not already in use in Constellation for any Object[Protocol,StockSolution].",
					nameUsed,
					False
				],
				Nothing
			];

			(* hard error if the Name is in use *)
			If[nameUsed && messages,
				Message[Error::DuplicateName, Object[Protocol, StockSolution]]
			];

			(* return the boolean indciating the situation, and test if we made it *)
			{If[nameUsed, {Name}, {}], {test}}
		],

		(* screw it it's not in use!! *)
		{{}, {}}
	];


	(* identify the root protocol packet for the case we're in Engine; default to Null if not in Engine; will use to send protocol's Author to USSM, or resolving ImageSample option *)
	rootProtocolPacket = If[inEngine,
		Last[Prepend[Last[parentProtocolDownloadTuple], First[parentProtocolDownloadTuple]]],
		Null
	];

	(* get the ContainerOut and model ContainerOut packets *)
	specifiedContainerOutPackets = containerOutDownloadTuples[[All, 1]];

	(* set a list of prepared resources that we can use in MapThreads; make it Null if the option wasn't passed (i.e. we're not in Engine) *)
	prepResourcesOrNulls = If[MatchQ[preparedResources, {ObjectP[Object[Resource, Sample]]..}],
		preparedResources,
		ConstantArray[Null, Length[myModelStockSolutions]]
	];

	(* assign the passed-in volume option (some automatics/specific volums) *)
	expandedVolumeOption = Lookup[roundedExpandedOptions, Volume];

	(* Resolve the primitives option. *)
	resolvedPrimitives=Map[
		(* NOTE: When we download from the object, since it's a multiple field, since it's empty it'll download as {}. *)
		Lookup[#, UnitOperations] /. {{}->Null}&,
		stockSolutionModelPackets
	];

	(* Resolve the type option *)
	resolvedTypes = Map[
		Last[Lookup[#, Type]]&,
		stockSolutionModelPackets
	];

	(* Resolve heat sensitive reagents - need this for below *)
	resolvedHeatSensitiveReagents = Which[

		(* If this is an empty list or null, we want it to be nested for below *)
		MatchQ[Lookup[combinedOptions, HeatSensitiveReagents], {}],
		ConstantArray[{},Length[resolvedPrimitives]],
		MatchQ[Lookup[combinedOptions, HeatSensitiveReagents], Null],
		ConstantArray[Null,Length[resolvedPrimitives]],

		(* If user has specified HSR, take it *)
		!MatchQ[Lookup[combinedOptions, HeatSensitiveReagents], Automatic],
		Lookup[combinedOptions, HeatSensitiveReagents],

		(* If user has not specified HSR, we're going to get it from the stock solutions packet if it's there *)
		!MatchQ[Lookup[stockSolutionModelPackets,HeatSensitiveReagents], Automatic|{Automatic..}],
		Lookup[stockSolutionModelPackets,HeatSensitiveReagents],

		(* Lastly, if we've got no other info, we make this empty *)
		True,
		ConstantArray[{},Length[resolvedPrimitives]]
	];

	(* resolve the controlling Mix boolean; if it is still Automatic, check if our model has mix information *)
	resolvedMixBools = MapThread[
		Function[{primitives, mix, modelMixTime, modelMixType, modelMixUntilDissolved, modelNumberOfMixes, mixer, mixType, mixTime, mixUntilDissolved, maxMixTime, mixRate, numMixes, maxNumMixes, mixPipettingVolume, incubator},
			Which[
				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* if Mix is specified, use that *)
				MatchQ[mix, BooleanP], mix,

				(* if any mix parameter was specified, then definitely True *)
				MatchQ[{mixer, mixType, mixTime, mixUntilDissolved, maxMixTime, mixRate, numMixes, maxNumMixes, mixPipettingVolume}, Except[{(Automatic|Null)..}]], True,

				(* if Incubator is specified then resolve to False *)
				MatchQ[incubator, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]], False,

				(* if no mix options are specified, figure out if we are mixing from the model *)
				MatchQ[{mixer, mixType, mixTime, mixUntilDissolved, maxMixTime, mixRate, numMixes, maxNumMixes, mixPipettingVolume}, {(Automatic|Null)..}], MatchQ[modelMixTime, TimeP] || TrueQ[modelMixUntilDissolved] || NumericQ[modelNumberOfMixes] || MatchQ[modelMixType, MixTypeP],

				(* True otherwise (though we shouldn't get here) *)
				True, True
			]
		],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, Mix], Lookup[stockSolutionModelPackets, MixTime], Lookup[stockSolutionModelPackets, MixType], Lookup[stockSolutionModelPackets, MixUntilDissolved], Lookup[stockSolutionModelPackets, NumberOfMixes], Sequence @@ Lookup[roundedExpandedOptions, {Mixer, MixType, MixTime, MixUntilDissolved, MaxMixTime, MixRate, NumberOfMixes, MaxNumberOfMixes, MixPipettingVolume, Incubator}]}
	];

	(* resolve the controlling PostAutoclaveMix boolean; if it is still Automatic, check if our model has mix information *)
	resolvedPostAutoclaveMixBools = MapThread[
		Function[{primitives, postAutoclaveMix, autoclave, heatSensitiveReagents, modelMixTime, modelMixType, modelMixUntilDissolved, modelNumberOfMixes, postAutoclaveMixer, postAutoclaveMixType, postAutoclaveMixTime, postAutoclaveMixUntilDissolved, postAutoclaveMaxMixTime, postAutoclaveMixRate, postAutoclaveNumMixes,
			postAutoclaveMaxNumMixes, postAutoclaveMixPipettingVolume, postAutoclaveIncubator},
			Which[
				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* if Mix is specified, use that *)
				MatchQ[postAutoclaveMix, BooleanP], postAutoclaveMix,

				(* if HeatSensitiveReagents are specified, resolve to True *)
				MatchQ[heatSensitiveReagents,Except[Null | {}]], True,

				(* if Autoclave is False, resolve to False *)
				MatchQ[autoclave,False], False,

				(* if any mix parameter was specified, then definitely True *)
				MatchQ[{postAutoclaveMixer, postAutoclaveMixType, postAutoclaveMixTime, postAutoclaveMixUntilDissolved, postAutoclaveMaxMixTime,
					postAutoclaveMixRate, postAutoclaveNumMixes, postAutoclaveMaxNumMixes, postAutoclaveMixPipettingVolume}, Except[{(Automatic|Null)..}]], True,

				(* if Incubator is specified then resolve to False *)
				MatchQ[postAutoclaveIncubator, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]], False,

				(* if no mix options are specified, figure out if we are mixing from the model *)
				MatchQ[{postAutoclaveMixer, postAutoclaveMixType, postAutoclaveMixTime, postAutoclaveMixUntilDissolved, postAutoclaveMaxMixTime,
					postAutoclaveMixRate, postAutoclaveNumMixes, postAutoclaveMaxNumMixes, postAutoclaveMixPipettingVolume}, {(Automatic|Null)..}], MatchQ[modelMixTime, TimeP] || TrueQ[modelMixUntilDissolved] || NumericQ[modelNumberOfMixes] || MatchQ[modelMixType, MixTypeP],

				(* False otherwise (though we shouldn't get here) *)
				True, False
			]
		],
		{resolvedPrimitives, Sequence @@ Lookup[roundedExpandedOptions, {PostAutoclaveMix, Autoclave}], resolvedHeatSensitiveReagents, Lookup[stockSolutionModelPackets, PostAutoclaveMixTime], Lookup[stockSolutionModelPackets, PostAutoclaveMixType], Lookup[stockSolutionModelPackets, PostAutoclaveMixUntilDissolved], Lookup[stockSolutionModelPackets, PostAutoclaveNumberOfMixes], Sequence @@ Lookup[roundedExpandedOptions, {PostAutoclaveMixer, PostAutoclaveMixType, PostAutoclaveMixTime, PostAutoclaveMixUntilDissolved,
			PostAutoclaveMaxMixTime, PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes, PostAutoclaveMixPipettingVolume,
			PostAutoclaveIncubator}]}
	];

	(* resolve the controlling Incubate boolean; if it is still Automatic, check if our model has incubation information *)
	resolvedIncubateBools = MapThread[
		Function[{primitives, incubate, modelIncubationTime, incubator, temperature, time, annealingTime},
			Which[

				(* If incubate is specified, use that *)
				MatchQ[incubate, BooleanP], incubate,

				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* If no incubate options are specified, pull from the model *)
				MatchQ[{incubator, temperature, time, annealingTime}, {(Automatic | Null)..}], MatchQ[modelIncubationTime, TimeP],

				(* True otherwise *)
				True, True
			]],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, Incubate], Lookup[stockSolutionModelPackets, IncubationTime], Sequence @@ Lookup[roundedExpandedOptions, {Incubator, IncubationTemperature, IncubationTime, AnnealingTime}]}
	];

	(* resolve the controlling PostAutoclaveIncubate boolean; if it is still Automatic, check if our model has incubation information *)
	resolvedPostAutoclaveIncubateBools = MapThread[
		Function[{primitives, postAutoclaveIncubate, autoclave, heatSensitiveReagents},
			Which[

				(* If incubate is specified, use that *)
				MatchQ[postAutoclaveIncubate, BooleanP], postAutoclaveIncubate,

				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* if HeatSensitiveReagents are NOT specified, resolve to False *)
				MatchQ[heatSensitiveReagents, Null | {}], False,

				(* if Autoclave is False, resolve to False *)
				MatchQ[autoclave,False], False,

				(* That about covers it - if we have heat sensitive reagents and are autoclaving, then we're going to do a post-autoclave incubate *)
				True, True
			]],
		{resolvedPrimitives, Sequence @@ Lookup[roundedExpandedOptions, {PostAutoclaveIncubate, Autoclave}], resolvedHeatSensitiveReagents,
			Lookup[stockSolutionModelPackets, PostAutoclaveIncubationTime], Sequence @@ Lookup[roundedExpandedOptions, {PostAutoclaveIncubator,
			PostAutoclaveIncubationTemperature, PostAutoclaveIncubationTime, PostAutoclaveAnnealingTime}]}
	];


	(* resolve the AdjustpH option; if none of the pHing options are specified, check if our model has a NominalpH set *)
	resolvedAdjustpHBools = MapThread[
		Function[{primitives, specifiedAdjustpH, modelNominalpH, specifiedpH, specifiedMinpH, specifiedMaxpH, specifiedpHingAcid, specifiedpHingBase},
			Which[
				(* if AdjustpH is specified, just use that *)
				BooleanQ[specifiedAdjustpH], specifiedAdjustpH,

				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* if no pH options were specified, pull from the model *)
				MatchQ[{specifiedpH, specifiedMinpH, specifiedMaxpH, specifiedpHingAcid, specifiedpHingBase}, {(Automatic | Null)..}], NumericQ[modelNominalpH],

				(* True otherwise (i.e., some other pH options were set) *)
				True, True

			]
		],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, AdjustpH], Lookup[stockSolutionModelPackets, NominalpH], Sequence @@ Lookup[roundedExpandedOptions, {pH, MinpH, MaxpH, pHingAcid, pHingBase}]}
	];

	(* resolve the Filter option; if it is still Automatic, check if our model has a FilterMaterial set *)
	resolvedFilterBools = MapThread[
		Function[{primitives, filter, modelFilterMaterial, filterType, filterMaterial, filterSize, filterInstrument, filterModel, filterSyringe, filterHousing},
			Which[

				(* if Filter is specified, use that *)
				MatchQ[filter, BooleanP], filter,

				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]], False,

				(* if no filter options are specified, pull from the model *)
				MatchQ[{filterType, filterMaterial, filterSize, filterInstrument, filterModel, filterSyringe, filterHousing}, {(Automatic | Null)..}], MatchQ[modelFilterMaterial, FilterMembraneMaterialP],

				(* True otherwise (i.e., some filter option was specified *)
				True, True
			]
		],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, Filter], Lookup[stockSolutionModelPackets, FilterMaterial], Sequence @@ Lookup[roundedExpandedOptions, {FilterType, FilterMaterial, FilterSize, FilterInstrument, FilterModel, FilterSyringe, FilterHousing}]}
	];

	(* Look up the option *)
	preFiltrationImage=Lookup[roundedExpandedOptions,PreFiltrationImage];

	(* Error if requesting imaging but no filtration is being done *)
	preFiltrationError=MatchQ[preFiltrationImage,True]&&!(Or@@resolvedFilterBools);

	(* Create the PreFiltrationImage test *)
	preFiltrationTest=If[gatherTests,
		Test["Pre-filtration imaging is only requested if some of the stock solutions are set to be filtered:",preFiltrationError,False]
	];

	(* Create the PreFiltrationImage message and track the option failure *)
	preFiltrationOptionFailure=If[!gatherTests&&preFiltrationError,
		Message[Error::NoFiltrationImaging]; {PreFiltrationImage},
		{}
	];

	(* If we need to resolve, check the filter booleans - if any filtration is happening, set to True if none is happening set to False *)
	resolvedPreFiltrationImage=If[MatchQ[preFiltrationImage,Automatic],
		Or@@resolvedFilterBools,
		preFiltrationImage
	];

	(* --- Resolve Autoclave Options --- *)
	(* Note: We have to resolve the autoclave options before we can resolve the ContainerOut option. *)
	(* Expand the Autoclave option if it is not already. *)
	expandedAutoclaveBooleans=If[!MatchQ[Lookup[combinedOptions,Autoclave],{_List..}],
		ConstantArray[Lookup[combinedOptions,Autoclave], Length[myModelStockSolutions]],
		Lookup[combinedOptions,Autoclave]
	];

	(* Expand the AutoclaveProgram option if it is not already. *)
	expandedAutoclavePrograms=If[!MatchQ[Lookup[combinedOptions,AutoclaveProgram],{_List..}],
		ConstantArray[Lookup[combinedOptions,AutoclaveProgram], Length[myModelStockSolutions]],
		Lookup[combinedOptions,AutoclaveProgram]
	];

	(* Set the Autoclave boolean to True if AutoclaveProgram is set. *)
	resolvedAutoclaveBooleans=MapThread[
		Function[{primitives, autoclaveBoolean,autoclaveProgram,stockSolutionModelPacket},
			Which[

				(* Has the user set Autoclave? Take it *)
				MatchQ[autoclaveBoolean, Except[Automatic]],
				autoclaveBoolean,

				(* If we're using primitives, it's false *)
				MatchQ[primitives, Except[Null]],
				False,

				(* If we have an autoclave program, it's true *)
				MatchQ[autoclaveProgram, AutoclaveProgramP],
				True,

				MatchQ[Lookup[stockSolutionModelPacket, Autoclave], True],
				True,

				(* If we're doing media, this should be true *)
				MatchQ[Lookup[stockSolutionModelPacket, Type], Model[Sample, Media]],
				True,

				True,
				False
			]
		],
		{resolvedPrimitives, expandedAutoclaveBooleans, expandedAutoclavePrograms, stockSolutionModelPackets}
	];

	(* Set the AutoclaveProgram to Liquid if Autoclave->True. *)
	resolvedAutoclavePrograms=MapThread[
		Function[{autoclaveBoolean,autoclaveProgram,stockSolutionModelPacket},
			If[MatchQ[autoclaveProgram, Automatic],
				If[MatchQ[autoclaveBoolean, True],
					If[MatchQ[Lookup[stockSolutionModelPacket, AutoclaveProgram], AutoclaveProgramP],
						Lookup[stockSolutionModelPacket, AutoclaveProgram],
						Liquid
					],
					Null
				],
				autoclaveProgram
			]
		],
		{resolvedAutoclaveBooleans, expandedAutoclavePrograms, stockSolutionModelPackets}
	];

	(* for each stock solution, calculate the effective formula volume; just the TotalVolume, but for a first time solution, just use the sum of the form components that are liquid;
	 	assigning this here since we will re-use this value in a few places *)
	{
		formulaVolumes,
		totalVolumes,
		formulaComponentTotalVolumes,
		sanitizedExpandedVolumeOption,
		invalidModelFormulaForFillToVolumeErrors,
		volumeTooLowForAutoclaveWarnings
	} = Transpose@MapThread[
		Function[{stockSolutionModelPacket, stockSolutionFormulaPacket, autoclaveBool, preparedResource,specifiedVolume},
			(* if we're using unit operations, we dont care about the formula volumes *)
			If[MatchQ[Lookup[stockSolutionModelPacket, UnitOperations, {}], Except[{SamplePreparationP..}]],
				Module[{formula, totalVolume, formulaVolume, bumpedFormulaVolumeForAutoclave,
					componentAmounts, componentDensities, formulaComponentTotalVolume,
					invalidModelFormulaForFillToVolumeError, volumeTooLowForAutoclaveWarning,
					sanitizedExpandedVolume},

					(* get the formula information for the requested stock solution model; also get NominalpH, will use to see if we need to bump up to
						be over minimum thresholds for these methods, IN ENGINE ONLY *)
					{formula, totalVolume} = Lookup[stockSolutionModelPacket, {Formula, TotalVolume}];

					(* convert the formula amounts into useful unit-ed form; be consicious of tablet counts (Null unit) *)
					componentAmounts = formula[[All,1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]};

					(* obtain the density of all components *)
					componentDensities=MapThread[
						Function[{componentDensity,componentState},
							Which[
								MatchQ[componentState,Liquid] && MatchQ[componentDensity,Null],
								(* if density is missing for a liquid component, use density of water *)
								Quantity[0.997`, ("Grams")/("Milliliters")],
								(* otherwise, use whatever is stored for the liquid component component *)
								MatchQ[componentState,Liquid], componentDensity,
								(*Otherwise, don't put anything. If it is solid, the volume cannot be just added to the volume for dissolution *)
								True, Null
							]
						],
						{Lookup[stockSolutionFormulaPacket, Density],Lookup[stockSolutionFormulaPacket, State]}];

					(*Calculate the total volumes from the formula components*)
					formulaComponentTotalVolume = Total[Join[
						Cases[componentAmounts, VolumeP],
						Cases[componentAmounts/componentDensities, VolumeP]
					]];
					(* Throw an error if using FillToVolumeSolvent, which means there will be a FillToVolume primitive, but formula component total volume has already reached total volume to fill to. *)
					invalidModelFormulaForFillToVolumeError = And[
						MatchQ[Lookup[stockSolutionModelPacket,FillToVolumeSolvent],ObjectP[]],
						VolumeQ[totalVolume],
						VolumeQ[formulaComponentTotalVolume],
						GreaterEqualQ[formulaComponentTotalVolume,totalVolume]
					];

					(* determine the volume to use to scale against the requested volume; be aware that TotalVolume may not be populated for a first-time, components-only model  *)
					(* if we have liquid component transferred by mass, we need to calculate its volume *)
					(* if we actually have a solids-only mixture then we will have already thrown an error so just default the volume to 1*Liter so that the rest of the function can handle things *)
					formulaVolume = Which[
						VolumeQ[totalVolume], totalVolume,
						VolumeQ[formulaComponentTotalVolume], formulaComponentTotalVolume,
						True, 1 * Liter
					];

					(* Error checking: do one more round of volume resolving based on if we are doing autoclave, if volume is specified, and whether this is a resource prep protocol *)
					{bumpedFormulaVolumeForAutoclave, volumeTooLowForAutoclaveWarning, sanitizedExpandedVolume} = Which[
						(*If Autoclave → True and PreparedResources is populated, we quietly bump the volume to a minimum of 100mL, regardless of the volume option given*)
						And[
							TrueQ[autoclaveBool],
							MatchQ[preparedResource, ObjectP[Object[Resource, Sample]]]
						],
							{Max[formulaVolume, 100Milliliter], False, Max[specifiedVolume, 100Milliliter]},
						(*If Autoclave → True, this is not a spun-off resource prep protocol, and volume is specified to be <100mL, leave as is, it will remain as specified, and throw a warning*)
						TrueQ[autoclaveBool] && VolumeQ[specifiedVolume] && LessQ[specifiedVolume, 100Milliliter],
							{formulaVolume, True, specifiedVolume},
						TrueQ[autoclaveBool] && VolumeQ[specifiedVolume],
							{formulaVolume, False, specifiedVolume},
						(*If Autoclave → True, this is not a spun-off resource prep protocol, volume is not specified, we resolve to a minimum of 100mL, no need to throw warning*)
						TrueQ[autoclaveBool],
							{Max[formulaVolume, 100Milliliter], False, specifiedVolume},
						True,
						(* In all other cases, just use formula volume and no warning *)
						{formulaVolume, False, specifiedVolume}
					];


					{
						bumpedFormulaVolumeForAutoclave,
						(*Also return total volume and total volume of formula components*)
						totalVolume,
						formulaComponentTotalVolume,
						sanitizedExpandedVolume,
						invalidModelFormulaForFillToVolumeError,
						volumeTooLowForAutoclaveWarning
					}
				],
				(* if using unitops, just take the expected final volume. *)
				{First[ToList[Lookup[stockSolutionModelPackets, TotalVolume]]], Null, Null, specifiedVolume, False, False}
			]
		],
		{stockSolutionModelPackets,stockSolutionFormulaPackets,resolvedAutoclaveBooleans,prepResourcesOrNulls,expandedVolumeOption}
	];

	(* throw a warning if we have a volume too low for autoclave. Don't throw warning while in engine *)
	If[MemberQ[volumeTooLowForAutoclaveWarnings, True] && messages && !MatchQ[$ECLApplication, Engine],
		Message[Warning::VolumeTooLowForAutoclave, ObjectToString[
			PickList[Download[myModelStockSolutions,Object],volumeTooLowForAutoclaveWarnings], Cache -> cache], 	PickList[expandedVolumeOption,volumeTooLowForAutoclaveWarnings]]
	];

	(* generate a warning test if the volume specified is too low for autoclaving *)
	volumeTooLowForAutoclaveTests = If[gatherTests,
		Module[{failingModels, failingVolumes, test},

			(* get the models and volumes that fail this test *)
			failingModels = PickList[Download[myModelStockSolutions,Object],volumeTooLowForAutoclaveWarnings];
			failingVolumes = PickList[expandedVolumeOption,volumeTooLowForAutoclaveWarnings];

			(* volume too low for autoclave test unknown test *)
			test = If[Length[failingModels] > 0,
				Warning["Models " <> ObjectToString[failingModels, Cache -> cache] <> " have volumes specified as " <> failingVolumes <> " which are below 100mL while Autoclave is True:",
					False,
					True
				],
				Warning["All models are prepared at volume no smaller than 100mL when Autoclave is True:",
					True,
					True
				]
			]
		],
		Null
	];

	(* For each stock solution model, figure out the compatible volumetric flasks to prepare for FTV resolution, considering the light sensitive requirement and incompatible materials *)
	compatibleVolumetricFlasksForSSModel=Map[
		Module[
			{lightSensitive,incompatibleMaterials},
			{lightSensitive,incompatibleMaterials}=Lookup[#,{LightSensitive,IncompatibleMaterials}];
			If[TrueQ[lightSensitive],
				(* When the stock solution is light sensitive, require Opaque->True and no incompatible materials *)
				Cases[Flatten@volumetricFlaskPackets,KeyValuePattern[{Opaque->True,ContainerMaterials->Except[{___,Alternatives@@incompatibleMaterials,___}]}]],
				(* Otherwise just require no incompatible materials *)
				Cases[Flatten@volumetricFlaskPackets,KeyValuePattern[{ContainerMaterials->Except[{___,Alternatives@@incompatibleMaterials,___}]}]]
			]
		]&,
		stockSolutionModelPackets
	];

	(* Pull out volumetric flask volumes for each stock solution model *)
	compatibleVolumetricFlaskVolumesForSSModel = Map[
		Cases[Lookup[#,MaxVolume,Null],VolumeP]&,
		compatibleVolumetricFlasksForSSModel
	];

	(* Determine max volumetric flask volume *)
	maxCompatibleVolumetricFlaskVolumeForSSModel = Map[
		If[MatchQ[#,{VolumeP..}],
			Max[#],
			0*Liter
		]&,
		compatibleVolumetricFlaskVolumesForSSModel
	];


	(*
	  in order for Volumetric to resolve to True:
	  - the stock solution have to have a solvent (so it's a FTV model)
	  - the stock solution cannot be paramaterized for the FTV shortcut
	  - the stock solution has to be ultrasonic incompatible
	  - the stock solution cannot have density
	  - the stock solution cannot adjust pH - this will allow room for acid/base addition
	  - the amount being made is less then the larged volumetric there is (2L) or the TotalVolume of less the 2L (since that's the automatic resolution)

	  - if all are true except the last one, we'll keep track of that model and make a smaller scout sample to measure the density of off
	  so that by the time we're making the actual sample via stepwise ftv density will be know and gravimetric can be used to measure the volume
	  (though in reality because we've done a volumetric stock solution, we would have also parametized
	*)
	resolvedFillToVolumeMethods = MapThread[
		Function[{primitives, fillToVolumeMethod,volume,stockSolutionPacket,fillToVolumeSolventPacket, formulaVolume, maxVolumetricVolume},
			Which[
				(* If the user gave us the method, use it. *)
				MatchQ[fillToVolumeMethod,Except[Automatic|$Failed|Null]],
					fillToVolumeMethod,

				(* if primitives are specified, resolve the boolean to false. *)
				MatchQ[primitives, Except[Null]],
					Null,

				(* Do we have a FillToVolumeSolvent? *)
				MatchQ[Lookup[stockSolutionPacket,FillToVolumeSolvent],ObjectP[]],
					Which[
						(* If we've already parameterized, then we don't need a method, we just directly add. *)
						TrueQ[Lookup[stockSolutionPacket,FillToVolumeParameterized]],
							Null,
						(* Use the FillToVolumeMethod if the user gave us one. *)
						MatchQ[Lookup[stockSolutionPacket,FillToVolumeMethod],Except[Null|$Failed]],
							Lookup[stockSolutionPacket,FillToVolumeMethod],
						And[
							!TrueQ[Lookup[stockSolutionPacket,UltrasonicIncompatible]],
							!TrueQ[Lookup[fillToVolumeSolventPacket,UltrasonicIncompatible]],
							MatchQ[formulaVolume,GreaterEqualP[$MinStockSolutionUltrasonicSolventVolume]]
						],
							Ultrasonic,
						Or[
							MatchQ[volume,LessEqualP[maxVolumetricVolume]],
							And[
								MatchQ[volume, Automatic],
								MatchQ[formulaVolume, LessEqualP[maxVolumetricVolume]](* The largest VolumetricFlask compatible with the stock solution model *)
							]
						],
							Volumetric,
						True,
							Ultrasonic
					],

				True,
					Null
			]
		],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, FillToVolumeMethod],expandedVolumeOption,stockSolutionModelPackets,stockSolutionSolventPackets, formulaVolumes,maxCompatibleVolumetricFlaskVolumeForSSModel}
	];

	(* If we were given our FillToVolumeMethod, check it. *)
	invalidFillToVolumeMethodsUltrasonic = MapThread[
		Function[{fillToVolumeMethod, stockSolutionPacket, fillToVolumeSolventPacket},
			And[
				(* The user gave us the option. *)
				MatchQ[fillToVolumeMethod, Ultrasonic],
				(* stock solution or solvent are ultrasonic incompatible *)
				Or[
					TrueQ[Lookup[stockSolutionPacket, UltrasonicIncompatible]],
					TrueQ[Lookup[fillToVolumeSolventPacket, UltrasonicIncompatible]]
				]
			]
		],
		{Lookup[roundedExpandedOptions, FillToVolumeMethod], stockSolutionModelPackets, stockSolutionSolventPackets}
	];
	invalidFillToVolumeMethodsVolumetric = MapThread[
		Function[{fillToVolumeMethod, volume, maxVolumetricVolume},
			And[
				(* The user gave us the option. *)
				MatchQ[fillToVolumeMethod, Volumetric],
				Or[
					MatchQ[volume, GreaterP[maxVolumetricVolume]],  (* The largest VolumetricFlask compatible with the stock solution model *)
					MatchQ[volume, LessP[$MinStockSolutionSolventVolume]]
				 ]
			]
		],
		{Lookup[roundedExpandedOptions, FillToVolumeMethod], expandedVolumeOption, maxCompatibleVolumetricFlaskVolumeForSSModel}
	];
	invalidFillToVolumeMethodsNoSolvent = MapThread[
		Function[{fillToVolumeMethod, stockSolutionPacket},
			And[
				(* The user gave us the option. *)
				MatchQ[fillToVolumeMethod, FillToVolumeMethodP],
				(* No Solvent *)
				!MatchQ[Lookup[stockSolutionPacket, FillToVolumeSolvent], ObjectP[]]
			]
		],
		{Lookup[roundedExpandedOptions, FillToVolumeMethod], stockSolutionModelPackets}
	];

	(* Throw an error if the FillToVolumeMethod is invalid. *)
	fillToVolumeMethodUltrasonicOptions = If[MemberQ[invalidFillToVolumeMethodsUltrasonic, True],
		(
			(* adding the weird " " before the string because the way the message is formatted kind of necessitates it to make it look good but also work with UploadStockSolution *)
			Message[Error::InvalidUltrasonicFillToVolumeMethod, " " <> ObjectToString[Download[PickList[myModelStockSolutions, invalidFillToVolumeMethodsUltrasonic],Formula]]];
			{FillToVolumeMethod}
		),
		{}
	];
	fillToVolumeMethodVolumetricOptions = If[MemberQ[invalidFillToVolumeMethodsVolumetric, True],
		(
			(* we throw one message for each stock solution model because they may have different requirement for volumetric flasks *)
			(* adding the weird " " before the string because the way the message is formatted kind of necessitates it to make it look good but also work with UploadStockSolution *)
			MapThread[
				If[TrueQ[#2],
					Module[
						{lightSensitiveString,incompatibleMaterialsString,volumetricFlaskString},
						(* Provide a string for how volumetric flasks are being selected *)
						lightSensitiveString=If[TrueQ[Lookup[#4,LightSensitive]],
							"Opaque -> True (for light-sensitive stock solution model)",
							""
						];
						incompatibleMaterialsString=If[MatchQ[Lookup[#4,IncompatibleMaterials],{}],
							"",
							"not made from the stock solution model's incompatible materials "<>ToString[Lookup[#4,IncompatibleMaterials]]
						];
						volumetricFlaskString=Switch[
							{lightSensitiveString,incompatibleMaterialsString},
							{"",""},"",
							{Except[""],Except[""]},"that are "<>lightSensitiveString<>" and "<>incompatibleMaterialsString,
							_,"that are "<>lightSensitiveString<>incompatibleMaterialsString
						];
						Message[Error::InvalidVolumetricFillToVolumeMethod, " " <> ObjectToString[#1], ObjectToString[#3],volumetricFlaskString]
					]
				]&,
				{myModelStockSolutions,invalidFillToVolumeMethodsVolumetric,maxCompatibleVolumetricFlaskVolumeForSSModel,stockSolutionModelPackets}
			];
			{FillToVolumeMethod}
		),
		{}
	];
	fillToVolumeMethodNoSolventOptions = If[MemberQ[invalidFillToVolumeMethodsNoSolvent, True],
		(
			(* adding the weird " " before the string because the way the message is formatted kind of necessitates it to make it look good but also work with UploadStockSolution *)
			Message[Error::InvalidFillToVolumeMethodNoSolvent, Download[PickList[myModelStockSolutions, invalidFillToVolumeMethodsNoSolvent],Formula]];
			{FillToVolumeMethod}
		),
		{}
	];

	(* Throw an error if using FillToVolumeSolvent, which means there will be a FillToVolume primitive, but formula component total volume has already reached total volume to fill to. *)
	InvalidModelFormulaForFillToVolumeInputs = If[MemberQ[invalidModelFormulaForFillToVolumeErrors, True] && messages,
		Message[Error::InvalidModelFormulaForFillToVolume,
			ObjectToString[PickList[myModelStockSolutions, invalidModelFormulaForFillToVolumeErrors], Cache -> newCache],
			PickList[formulaComponentTotalVolumes, invalidModelFormulaForFillToVolumeErrors],
			PickList[totalVolumes, invalidModelFormulaForFillToVolumeErrors],
			ObjectToString[PickList[Lookup[stockSolutionSolventPackets,Object],invalidModelFormulaForFillToVolumeErrors],Cache -> newCache]
		];
		PickList[myModelStockSolutions, invalidModelFormulaForFillToVolumeErrors],
		{}
	];
	(*Make tests for FillToVolume vs formula volume*)
	(* make tests for the VolumeIncrements *)
	validFormulaForFillToVolumeTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, invalidModelFormulaForFillToVolumeErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, invalidModelFormulaForFillToVolumeErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the provided models " <> ObjectToString[failingModels] <> ", if FillToVolumeSolvent is specified, the combined volume of the components in the model's Formula is smaller than the model's TotalVolume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the provided models " <> ObjectToString[failingModels] <> ", if FillToVolumeSolvent is specified, the combined volume of the components in the model's Formula is smaller than the model's TotalVolume:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* Ask for a density scout if we're doing Gravimetric and we don't have a density. *)
	densityScouts=MapThread[
		Function[{resolvedFillToVolumeMethod,stockSolutionPacket},
			If[MatchQ[resolvedFillToVolumeMethod,Gravimetric]&&MatchQ[Lookup[stockSolutionPacket,Density],Null],
				Lookup[stockSolutionPacket,Object],
				Nothing
			]
		],
		{resolvedFillToVolumeMethods,stockSolutionModelPackets}
	];

	(* I blame cam for this massive MapThread-Which-Module-thing *)
	(* calculate the volume of solution we should prepare; we want to make sure that we won't scale the formula into a range where the components are measured weird;
	 	also could risk having the total volume be below FtV/filtration/pHing minimums, check for that;
		do some silent bump upping if we are in Engine *)
	{
		prepVolumes,
		expandedVolumeIncrements,
		badComponents,
		badScaledComponentAmounts,
		componentsScaledOutOfRangeErrors,
		belowFillToVolumeMinimumErrors,
		aboveFillToVolumeMaximumErrors,
		belowpHMinimumErrors,
		belowFiltrationMinimumErrors,
		volumeOverMaxIncrementErrors,
		volumeNotInIncrementsErrors
	} = Transpose@MapThread[
		Function[{originalModelInput, stockSolutionModelPacket, formulaVolume, volumeOption, fillToVolumeMethodOption, resolvedAdjustpH, filterBool, preparedResourceOrNull, volumetricFlaskVolumes},
			Module[{componentsScaledOutOfRangeError, volumeOverMaxIncrementError, volumeNotInIncrementsError,
				belowFillToVolumeMinimumError, aboveFillToVolumeMaximumError, belowpHMinimumError, belowFiltrationMinimumError},

				(* set these errors to False to start (and flip the switch in the big Which below if necessary) *)
				{
					componentsScaledOutOfRangeError,
					belowFillToVolumeMinimumError,
					aboveFillToVolumeMaximumError,
					belowpHMinimumError,
					belowFiltrationMinimumError,
					volumeOverMaxIncrementError,
					volumeNotInIncrementsError
				} = {False, False, False, False, False, False, False};

				(* get the prep volumes and the tests through this big Which *)
				Which[
					(* if this is a volumetric prep, then we need to make volume for which there is a volumetric flask*)
					MatchQ[fillToVolumeMethodOption, Volumetric],
					Module[{volIncrements,maxIncrement,expandedIncrements,volumetricFlaskVolumesIncrements,prepVolume},

						(* assign the volume increments of the solution *)
						volIncrements = If[MatchQ[Lookup[stockSolutionModelPacket, VolumeIncrements], {VolumeP..}],
							Lookup[stockSolutionModelPacket, VolumeIncrements],
							Null
						];

						(* get the maximum increment listed *)
						maxIncrement = If[NullQ[volIncrements],
							Null,
							Max[volIncrements]
						];

						(* have the volume increments be those listed in the object AND the highest volume increment listed times a reasonable number of integers (i.e., could do 8x but certainly not 100x) *)
						(* admittedly, up to 10x amount is an arbitrary decision *)
						(* can't go over maximum we can make *)
						expandedIncrements = If[NullQ[volIncrements],
							volumetricFlaskVolumes,
							Cases[Flatten[{volIncrements, maxIncrement * Range[$MaxNumberOfFulfillmentPreps]}], LessEqualP[$MaxStockSolutionComponentVolume]]
						];

						(* If our stock solution has an increment and we need volumetric flask, make sure we get the ones that are overlapping with the increments *)
						volumetricFlaskVolumesIncrements=Intersection[volumetricFlaskVolumes,expandedIncrements];

						prepVolume=FirstCase[
							volumetricFlaskVolumesIncrements,
							GreaterEqualP[
								If[MatchQ[volumeOption,Automatic],
									Lookup[stockSolutionModelPacket,TotalVolume],
									volumeOption
								]
							],
							$Failed
						];

						aboveFillToVolumeMaximumError=FailureQ[prepVolume] && VolumeQ[Lookup[stockSolutionModelPacket, TotalVolume]];

						{
							If[FailureQ[prepVolume],
								If[MatchQ[volumeOption,Automatic],
									Lookup[stockSolutionModelPacket,TotalVolume],
									volumeOption
								],
								prepVolume
							],
							{},
							{},
							{},
							componentsScaledOutOfRangeError,
							belowFillToVolumeMinimumError,
							aboveFillToVolumeMaximumError,
							belowpHMinimumError,
							belowFiltrationMinimumError,
							volumeOverMaxIncrementError,
							volumeNotInIncrementsError
						}
					],
					(* if the volume is just Automatic, word, that's fine, leave the prep amount automatic too *)
					MatchQ[volumeOption, Automatic],
						{
							volumeOption,
							{},
							{},
							{},
							componentsScaledOutOfRangeError,
							belowFillToVolumeMinimumError,
							aboveFillToVolumeMaximumError,
							belowpHMinimumError,
							belowFiltrationMinimumError,
							volumeOverMaxIncrementError,
							volumeNotInIncrementsError
						},

					(* otherwise if the model has VolumeIncrements, makes our life easy; just make sure a set volume is in there *)
					MatchQ[Lookup[stockSolutionModelPacket, VolumeIncrements], {VolumeP..}],
					Module[{volIncrements, requestedVolumeNotInIncrements, nextLargestIncrement, maxIncrement,
						expandedIncrements, prepVolume},

						(* assign the volume increments of the solution *)
						volIncrements = Lookup[stockSolutionModelPacket, VolumeIncrements];

						(* get the maximum increment listed *)
						maxIncrement = Max[volIncrements];

						(* have the volume increments be those listed in the object AND the highest volume increment listed times a reasonable number of integers (i.e., could do 8x but certainly not 100x) *)
						(* admittedly, up to 10x amount is an arbitrary decision *)
						(* can't go over maximum we can make *)
						expandedIncrements = Cases[Flatten[{volIncrements, maxIncrement * Range[$MaxNumberOfFulfillmentPreps]}], LessEqualP[$MaxStockSolutionComponentVolume]];

						(* set a bool to indicate if the requested volume is one of these increments *)
						requestedVolumeNotInIncrements = !MemberQ[expandedIncrements, _?(Equal[#, volumeOption]&)];

						(* yell an uh-oh if we have to; do NOT yell if we're in Engine yet, we will try to choose the next biggest *)
						volumeNotInIncrementsError = If[!gatherTests && !fastTrack && !inEngine && requestedVolumeNotInIncrements,
							True,
							volumeNotInIncrementsError
						];

						(* try to get the next-biggest increment that can be made that's bigger than the request *)
						nextLargestIncrement = SelectFirst[Sort[expandedIncrements], # > volumeOption&, $Failed];

						(* if we ARE in engine, return the next largest increment if one was found, if not, also throw an error;
							if we're not in Engine, just return the unchanged volume option, and indicate if it's legit of not, with our test *)
						{prepVolume, volumeOverMaxIncrementError} = If[inEngine,
							Which[
								(* if the requested volume was legit right on an increment, great, just do it *)
								!requestedVolumeNotInIncrements, {volumeOption, volumeNotInIncrementsError},

								(* we'll just make a bit more than asked automagically *)
								MatchQ[nextLargestIncrement, VolumeP], {nextLargestIncrement, volumeOverMaxIncrementError},

								(* the requested volume was too large for ALL volume increments *)
								True, {volumeOption, True}
							],

							(* not in Engine, so the prep volume can just be the requested Volume, but report if it's not legit *)
							{volumeOption, volumeOverMaxIncrementError}
						];

						{
							prepVolume,
							expandedIncrements,
							{},
							{},
							componentsScaledOutOfRangeError,
							belowFillToVolumeMinimumError,
							aboveFillToVolumeMaximumError,
							belowpHMinimumError,
							belowFiltrationMinimumError,
							volumeOverMaxIncrementError,
							volumeNotInIncrementsError
						}
					],

					(* otherwise gotta see if the scaling is okay at the most min/max worst cases *)
					True,
					Module[{formula, solvent, totalVolume, components, componentAmounts, scalingRatio, scaledComponentAmounts,
						scaledAmountOutOfRangeBools, minVolumeForComponentAmounts,
						volumeInvalid, volumeInvalidScaling, volumeInvalidpH,
						volumeInvalidFillToVolume, volumeInvalidFilter, minimumsInPlayForBumpUp,
						scaledAmountsOutOfRange, componentsOutOfRange},

						(* get the formula information for the requested stock solution model; also get NominalpH, will use to see if we need to bump up to
						  be over minimum thresholds for these methods, IN ENGINE ONLY *)
						{formula, solvent, totalVolume} = Lookup[stockSolutionModelPacket, {Formula, FillToVolumeSolvent, TotalVolume}];

						(* convert the formula amounts into useful unit-ed form; assuming that we do NOT have tablet counts in the formula since VolumeIncrements MUST Be populated in that case *)
						components = Download[formula[[All, 2]], Object];
						componentAmounts = #[[1]]& /@ formula;

						(* get the scaling ratio between the requested volumeOption and the formula volume (to which the formula component amounts correspond) *)
						scalingRatio = volumeOption / formulaVolume;

						(* scale the component amounts by this ratio to see how much we'd need to meausre to prepare this requested volume *)
						scaledComponentAmounts = componentAmounts * scalingRatio;

						(* set booleans indicating if each component amount is outside of legit range after scaling *)
						scaledAmountOutOfRangeBools = If[MassQ[#],
							!MatchQ[#, RangeP[$MinStockSolutionComponentMass, $MaxStockSolutionComponentMass]],
							!MatchQ[#, RangeP[$MinStockSolutionComponentVolume, $MaxStockSolutionComponentVolume]]
						]& /@ scaledComponentAmounts;

						(* get the scaled components and amounts that are bad *)
						componentsOutOfRange = PickList[components, scaledAmountOutOfRangeBools];
						scaledAmountsOutOfRange = PickList[scaledComponentAmounts, scaledAmountOutOfRangeBools];

						(* calculate the minimum volume we'd have to prepare to ensure that the components were above the minimum threshold;
							 we may use this if in Engine to prepare more and then aliquot *)
						minVolumeForComponentAmounts = If[Or @@ scaledAmountOutOfRangeBools,
							Module[{smallestOutOfRangeMass, smallestOutOfRangeVolume, scaleToMinRatioForMass,
								scaleToMinRatioForVolume, scaleUpRatioToUse},

								(* get the components that are out of range (could be too big here also) *)
								scaledAmountsOutOfRange = PickList[scaledComponentAmounts, scaledAmountOutOfRangeBools];

								(* get the smallest mass and volume from these; Min returns Infinity on an empty list, we'll work with that *)
								smallestOutOfRangeMass = Min[Cases[scaledAmountsOutOfRange, MassP]];
								smallestOutOfRangeVolume = Min[Cases[scaledAmountsOutOfRange, VolumeP]];

								(* get the ratios of the minimum global constant to these, if they aren't infinity *)
								scaleToMinRatioForMass = If[MassQ[smallestOutOfRangeMass],
									$MinStockSolutionComponentMass / smallestOutOfRangeMass,
									1
								];
								scaleToMinRatioForVolume = If[VolumeQ[smallestOutOfRangeVolume],
									$MinStockSolutionComponentVolume / smallestOutOfRangeVolume,
									1
								];

								(* the larger of these two ratios is the scale-up factor we will use to increase the requested Volume to a minimum where no component should be below threshold *)
								scaleUpRatioToUse = Max[scaleToMinRatioForMass, scaleToMinRatioForVolume];

								(* scale up the requested Volume by this ratio *)
								scaleUpRatioToUse * volumeOption
							],
							volumeOption
						];

						(* volume is invalid of any of the scaled amounts are out of range; flip the switch if that is true, or leave it as is if not *)
						volumeInvalidScaling = Or @@ scaledAmountOutOfRangeBools;

						(* also throw errors for this situation, if we're NOT in Engine (errors will actually be thrown later when not in the MapThread) *)
						componentsScaledOutOfRangeError = If[!gatherTests && !fastTrack && !inEngine && Or @@ scaledAmountOutOfRangeBools,
							True,
							componentsScaledOutOfRangeError
						];

						(* volume is invalid if it's below the FillToVolume minimum and we're using a FillToVolume case *)
						volumeInvalidFillToVolume = If[MatchQ[solvent, ObjectP[]],
							volumeOption < $MinStockSolutionUltrasonicSolventVolume,
							False
						];

						(* yell about this particular case; UNLLESS WE'RE IN ENGINE, there we'll just silently make more and aliquot (below and outside the MapThread; just tracking it here) *)
						belowFillToVolumeMinimumError = If[!gatherTests && !fastTrack && !inEngine && volumeInvalidFillToVolume,
							True,
							belowFillToVolumeMinimumError
						];

						(* if we're gonna pH, make sure the volume asked for isn't below THAT minimum *)
						volumeInvalidpH = If[TrueQ[resolvedAdjustpH],
							volumeOption < $MinStockSolutionpHVolume,
							False
						];

						(* yell about this particular case; UNLLESS WE'RE IN ENGINE, there we'll just silently make more and aliquot (below and outside the MapThread; just tracking it here) *)
						belowpHMinimumError = If[!gatherTests && !fastTrack && !inEngine && volumeInvalidpH,
							True,
							belowpHMinimumError
						];

						(* if we're gonna filter, make sure the volume asked for isn't below THAT minimum *)
						volumeInvalidFilter = If[filterBool,
							volumeOption < $MinStockSolutionFilterVolume,
							False
						];

						(* yell about this particular case; UNLLESS WE'RE IN ENGINE, there we'll just silently make more and aliquot (below and outside the MapThread; just tracking it here) *)
						belowFiltrationMinimumError = If[!gatherTests && !fastTrack && !inEngine && volumeInvalidFilter,
							True,
							belowFiltrationMinimumError
						];

						(* set an overall boolean indicating if we are not okay with this volume resolution *)
						volumeInvalid = Or[
							volumeInvalidScaling,
							volumeInvalidFillToVolume,
							volumeInvalidpH,
							volumeInvalidFilter
						];

						(* if we're in Engine, we may need to bump up the amount to some minimum; figure out what minimums are in play *)
						minimumsInPlayForBumpUp = PickList[
							{minVolumeForComponentAmounts, $MinStockSolutionUltrasonicSolventVolume, $MinStockSolutionpHVolume, $MinStockSolutionFilterVolume},
							{volumeInvalidScaling, volumeInvalidFillToVolume, volumeInvalidpH, volumeInvalidFilter}
						];

						(* if we ARE in Engine, we want to get a prep volume that is above the minimum; if we have tripped the volume invalid check,
							 take the MAXIMUM of the set MINIMUMS as our prep volume; report this prep volume as valid *)
						If[inEngine,
							(* if volume is invalid, assume one of our minimum checks tripped, so we have at least one thing in minimumsInPlayForBumpUp *)
							If[volumeInvalid,
								{
									Max[minimumsInPlayForBumpUp],
									{},
									componentsOutOfRange,
									scaledAmountsOutOfRange,
									componentsScaledOutOfRangeError,
									belowFillToVolumeMinimumError,
									aboveFillToVolumeMaximumError,
									belowpHMinimumError,
									belowFiltrationMinimumError,
									volumeOverMaxIncrementError,
									volumeNotInIncrementsError
								},
								{
									volumeOption,
									{},
									componentsOutOfRange,
									scaledAmountsOutOfRange,
									componentsScaledOutOfRangeError,
									belowFillToVolumeMinimumError,
									aboveFillToVolumeMaximumError,
									belowpHMinimumError,
									belowFiltrationMinimumError,
									volumeOverMaxIncrementError,
									volumeNotInIncrementsError
								}
							],
							(* otherwise we're not in engine, don't change the input Volume, but report if it's messed up, and return tests *)
							{
								volumeOption,
								{},
								componentsOutOfRange,
								scaledAmountsOutOfRange,
								componentsScaledOutOfRangeError,
								belowFillToVolumeMinimumError,
								aboveFillToVolumeMaximumError,
								belowpHMinimumError,
								belowFiltrationMinimumError,
								volumeOverMaxIncrementError,
								volumeNotInIncrementsError
							}
						]
					]
				]
			]
		],
		{myModelStockSolutions, stockSolutionModelPackets, formulaVolumes, sanitizedExpandedVolumeOption, resolvedFillToVolumeMethods, resolvedAdjustpHBools, resolvedFilterBools, prepResourcesOrNulls, compatibleVolumetricFlaskVolumesForSSModel}
	];

	(* --- Post MapThread error test and message throwing --- *)

	(* if the volume is not in the increments, throw an error *)
	volumeNotInIncrementsOptions = If[MemberQ[volumeNotInIncrementsErrors, True] && messages,
		(
			Message[Error::VolumeNotInIncrements, PickList[myModelStockSolutions, volumeNotInIncrementsErrors], PickList[prepVolumes, volumeNotInIncrementsErrors], PickList[expandedVolumeIncrements, volumeNotInIncrementsErrors]];
			{Volume}
		),
		{}
	];

	(* make tests for the VolumeIncrements *)
	volumeNotInIncrementsTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, volumeNotInIncrementsErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, volumeNotInIncrementsErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the provided models " <> ObjectToString[failingModels] <> ", if VolumeIncrements is populated, the requested volumes are in the VolumeIncrements, or a multiple of the highest one:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the provided models " <> ObjectToString[passingModels] <> ", if VolumeIncrements is populated, the requested volumes are in the VolumeIncrements, or a multiple of the highest one:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* if the volume is not in the increments, throw an error *)
	volumeOverMaxIncrementOptions = If[MemberQ[volumeOverMaxIncrementErrors, True] && messages,
		(
			Message[Error::VolumeOverMaxIncrement, PickList[myModelStockSolutions, volumeOverMaxIncrementErrors], PickList[prepVolumes, volumeOverMaxIncrementErrors], PickList[expandedVolumeIncrements, volumeOverMaxIncrementErrors], PickList[prepResourcesOrNulls, volumeOverMaxIncrementErrors]];
			{Volume}
		),
		{}
	];

	(* make tests for the VolumeIncrements *)
	volumeOverMaxIncrementTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, volumeOverMaxIncrementErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, volumeOverMaxIncrementErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the provided models " <> ObjectToString[failingModels] <> ", if VolumeIncrements is populated, the requested volumes are not more than 10x higher than the higest specified VolumeIncrement:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the provided models " <> ObjectToString[passingModels] <> ", if VolumeIncrements is populated, the requested volumes are not more than 10x higher than the higest specified VolumeIncrement:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* if scaling amounts and we're outside of the range of what we can do in the lab, throw an error *)
	componentsScaledOutOfRangeOptions = If[MemberQ[componentsScaledOutOfRangeErrors, True] && messages,
		(
			Message[
				Error::ComponentsScaledOutOfRange,
				PickList[myModelStockSolutions, componentsScaledOutOfRangeErrors], PickList[prepVolumes, componentsScaledOutOfRangeErrors], PickList[badComponents, componentsScaledOutOfRangeErrors], PickList[badScaledComponentAmounts, componentsScaledOutOfRangeErrors],
				$MinStockSolutionComponentMass, $MaxStockSolutionComponentMass, $MinStockSolutionComponentVolume, $MaxStockSolutionComponentVolume
			];
			{Volume}
		),
		{}
	];

	(* make tests for the VolumeIncrements *)
	componentsScaledOutOfRangeTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, componentsScaledOutOfRangeErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, componentsScaledOutOfRangeErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", ensures that all scaled component amounts do not fall outside the range that ensures accurate component transfers can be achieved (" <> UnitForm[$MinStockSolutionComponentMass, Brackets -> False] <> " to " <> UnitForm[$MaxStockSolutionComponentMass, Brackets -> False] <> " for solids, " <> UnitForm[$MinStockSolutionComponentMass, Brackets -> False] <> " to " <> UnitForm[$MaxStockSolutionComponentMass, Brackets -> False] <> " for liquids):",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[passingModels] <> ", ensures that all scaled component amounts do not fall outside the range that ensures accurate component transfers can be achieved (" <> UnitForm[$MinStockSolutionComponentMass, Brackets -> False] <> " to " <> UnitForm[$MaxStockSolutionComponentMass, Brackets -> False] <> " for solids, " <> UnitForm[$MinStockSolutionComponentMass, Brackets -> False] <> " to " <> UnitForm[$MaxStockSolutionComponentMass, Brackets -> False] <> " for liquids):",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{failingModelTests, passingModelTests}

		]
	];

	(* if we're below the FillToVolume minimum throw an error *)
	belowFillToVolumeMinimumOptions = If[MemberQ[belowFillToVolumeMinimumErrors, True] && messages,
		(
			Message[Error::BelowFillToVolumeMinimum, PickList[myModelStockSolutions, belowFillToVolumeMinimumErrors], PickList[prepVolumes, belowFillToVolumeMinimumErrors], $MinStockSolutionUltrasonicSolventVolume];
			{Volume}
		),
		{}
	];

	(* make tests for the VolumeIncrements *)
	belowFillToVolumeMinimumTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, belowFillToVolumeMinimumErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, belowFillToVolumeMinimumErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a fill-to-volume solution, is above the minimum threshold for a solvent fill-to volume to ensure accurate volume measurement: " <> ToString[UnitForm[$MinStockSolutionUltrasonicSolventVolume, Brackets -> False]] <> ".:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a fill-to-volume solution, is above the minimum threshold for a solvent fill-to volume to ensure accurate volume measurement: " <> ToString[UnitForm[$MinStockSolutionUltrasonicSolventVolume, Brackets -> False]] <> ".:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{failingModelTests, passingModelTests}

		]
	];

	(* if we're above the maximum volumetric FillToVolume flask available throw an error  *)
	aboveFillToVolumeMaximumOptions = If[MemberQ[aboveFillToVolumeMaximumErrors, True] && messages,
		(
			(* we throw one message for each stock solution model because they may have different requirement for volumetric flasks *)
			MapThread[
				If[TrueQ[#2],
					Module[
						{lightSensitiveString,incompatibleMaterialsString,volumetricFlaskString},
						(* Provide a string for how volumetric flasks are being selected *)
						lightSensitiveString=If[TrueQ[Lookup[#4,LightSensitive]],
							"Opaque -> True (for light-sensitive stock solution model)",
							""
						];
						incompatibleMaterialsString=If[MatchQ[Lookup[#4,IncompatibleMaterials],{}],
							"",
							"not made from the stock solution model's incompatible materials "<>ToString[Lookup[#4,IncompatibleMaterials]]
						];
						volumetricFlaskString=Switch[
							{lightSensitiveString,incompatibleMaterialsString},
							{"",""},"",
							{Except[""],Except[""]},"that are "<>lightSensitiveString<>" and "<>incompatibleMaterialsString,
							_,"that are "<>lightSensitiveString<>incompatibleMaterialsString
						];
						Message[Error::AboveVolumetricFillToVolumeMaximum, ObjectToString[#1], ObjectToString[#3],volumetricFlaskString]
					]
				]&,
				{myModelStockSolutions,aboveFillToVolumeMaximumErrors,prepVolumes,stockSolutionModelPackets}
			];
			{Volume}
		),
		{}
	];

	(* make tests for aboveFillToVolumeMaximum *)
	aboveVolumetricFillToVolumeMaximumTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, aboveFillToVolumeMaximumErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, aboveFillToVolumeMaximumErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a volumetric fill-to-volume solution, is less than or equal to the maximum volume of the largest volumetric flask that aligns with the stock solution model's LightSensitive and IncompatibleMaterials requirements:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a volumetric fill-to-volume solution, is less than or equal to the maximum volume of the largest volumetric flask that aligns with the stock solution model's LightSensitive and IncompatibleMaterials requirements:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{failingModelTests, passingModelTests}

		]
	];

	(* if we're below the pHing minimum throw an error *)
	belowpHMinimumOptions = If[MemberQ[belowpHMinimumErrors, True] && messages,
		(
			Message[Error::BelowpHMinimum, ObjectToString[PickList[myModelStockSolutions, belowpHMinimumErrors]], PickList[prepVolumes, belowpHMinimumErrors], $MinStockSolutionpHVolume];
			{Volume}
		),
		{}
	];

	(* make tests for the VolumeIncrements *)
	belowpHMinimumTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = PickList[myModelStockSolutions, belowpHMinimumErrors];

			(* get the models that will pass this test *)
			passingModels = PickList[myModelStockSolutions, belowpHMinimumErrors, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a pH-ed stock solution, is above the minimum threshold to ensure pH titration is possible given pH probe size: " <> ToString[UnitForm[$MinStockSolutionpHVolume, Brackets -> False]] <> ".:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["The requested volumes of " <> ObjectToString[failingModels] <> ", if a pH-ed stock solution, is above the minimum threshold to ensure pH titration is possible given pH probe size: " <> ToString[UnitForm[$MinStockSolutionpHVolume, Brackets -> False]] <> ".:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{failingModelTests, passingModelTests}

		]
	];

	(* we can now actually resolve the PreparatoryVolume and the Volume option; do this even if we had failures above *)
	{preResolvedPreparationVolumes, preResolvedVolumes}=Transpose@MapThread[
		Function[{prepVolume,volumeOption,formulaVolume},
			(* Automatic means we prepared the formula volume *)
			{prepVolume,volumeOption}/.{Automatic->formulaVolume}
		],
		{prepVolumes,sanitizedExpandedVolumeOption,formulaVolumes}
	];

	(* LightSensitive value resolves based on the LightSensitive field of the model *)
	resolvedLightSensitive = TrueQ[#]& /@ Lookup[stockSolutionModelPackets, LightSensitive, {}];

	(* get the PreferredContainers for the volumes (and models) *)
	(* it is absolutely necessary that we return _some_ container here and not $Failed *)
	(* this means that if we can't find a container that matches what we need, just pick something else; yes it's wrong but we will have thrown other error messages anyway on this front and at least if we do this the rest of the function doesn't trainwreck *)
	resolvedPrepContainers = MapThread[
		resolveStockSolutionPrepContainer[##, fastAssoc]&,
		{
			stockSolutionModelPackets, preResolvedPreparationVolumes,
			resolvedLightSensitive, resolvedAutoclaveBooleans, resolvedFillToVolumeMethods,
			Lookup[roundedExpandedOptions, ContainerOut], compatibleVolumetricFlasksForSSModel
		}
	];

	(* Identify pre-downloaded packets of the prep containers *)
	resolvedPrepContainerPackets=Map[
		Function[
			{resolvedPrepContainer},
			PickList[
				specifiedContainerOutPackets,
				MatchQ[Lookup[#,Object],ObjectP[resolvedPrepContainer]]&/@specifiedContainerOutPackets
			]
		],
		resolvedPrepContainers
	];

	(* We want to figure out the volume to scale up to when we're using a graduated cylinder in a media preparation - we want to be at a tick mark *)
	scaledUpVolumes = MapThread[
		Function[
			{modelStockSolution,formulaVolume,resolvedPrepContainerPacket},
			If[
				MatchQ[modelStockSolution,ObjectP[Model[Media]]] && MatchQ[Lookup[resolvedPrepContainerPacket,Object],ObjectP[{Model[Container,GraduatedCylinder],Object[Container,GraduatedCylinder]}]],
				RoundOptionPrecision[formulaVolume,Lookup[resolvedPrepContainerPacket,Resolution],Round->Up],
				formulaVolume
			]
		],
		{myModelStockSolutions,formulaVolumes,resolvedPrepContainerPackets}
	];

	(*Re-resolve these based on scaled-up volumes*)
	{resolvedPreparationVolumes, resolvedVolumes}=Transpose@MapThread[
		Function[{prepVolume,volumeOption,scaledUpVolume},
			(* Automatic means we prepared the formula volume *)
			{prepVolume,volumeOption}/.{Automatic->scaledUpVolume}
		],
		{prepVolumes,expandedVolumeOption,scaledUpVolumes}
	];

	(* now we need to resolve the prep options; do NOT include the "Controlling" options, i.e. Mix, pH, Filter, Incubate, that we already resolved above so that we could check the preparatory volumes *)
	prepOptionNames = {
		MixType, MixUntilDissolved, Mixer, MixTime, MaxMixTime, MixRate, NumberOfMixes, MaxNumberOfMixes, MixPipettingVolume, AnnealingTime,
		Incubator, IncubationTime, IncubationTemperature,
		PostAutoclaveMixType, PostAutoclaveMixUntilDissolved, PostAutoclaveMixer, PostAutoclaveMixTime, PostAutoclaveMaxMixTime,
		PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes, PostAutoclaveMixPipettingVolume, PostAutoclaveAnnealingTime,
		PostAutoclaveIncubator, PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature,
		pH, MinpH, MaxpH, pHingAcid, pHingBase,
		FilterType, FilterMaterial, FilterSize, FilterInstrument, FilterModel, FilterSyringe, FilterHousing,
		(* PlatingInstrument, *) HeatSensitiveReagents
	};

	(* make lists in the form {prepOptionName->singleValue..} for EACH of the stock solution model inputs *)
	prepOptionsByModel = Table[
		Map[
			# -> Lookup[roundedExpandedOptions, #][[index]]&,
			prepOptionNames
		],
		{index, Range[Length[myModelStockSolutions]]}
	];

	(* --- Resolve the pHing options --- *)


	(* assign the names of the pHing "sub-options" (things controlled by the pH option *)
	pHingSubOptionNames = {pH, MinpH, MaxpH, pHingAcid, pHingBase};

	(* pull out the pre-resolved pHing options per model *)
	pHingOptionsByModel = Map[
		Function[{prepOptions},
			Select[prepOptions, MemberQ[pHingSubOptionNames, Keys[#]]&]
		],
		prepOptionsByModel
	];

	(* check to make sure the pHing options are okay with the pH option for each input model *)
	pHingOptionsSetIncorrectly = If[Not[fastTrack],
		MapThread[
			Function[{prepOptions, pHBool},
				Not[TrueQ[pHBool]] && MemberQ[Lookup[prepOptions, pHingSubOptionNames], Except[Automatic|Null]]
			],
			{pHingOptionsByModel, resolvedAdjustpHBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* generate the tests for if the pHing options were set incorrectly or not, and throw the messages if necessary *)
	{pHingOptionsSetIncorrectlyTests, pHingOptionsSetIncorrectlyOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingpHingOptions,
			badOptions},

			(* get the inputs that have correspondingly-bad pH options *)
			failingInputs = PickList[myModelStockSolutions, pHingOptionsSetIncorrectly];

			(* get the failing incubate options *)
			failingpHingOptions = MapThread[
				If[TrueQ[#1],
					PickList[pHingSubOptionNames, Lookup[#2, pHingSubOptionNames], Except[Automatic|Null]],
					Nothing
				]&,
				{pHingOptionsSetIncorrectly, pHingOptionsByModel}
			];

			(* get the inputs whose pH options are fine *)
			passingInputs = PickList[myModelStockSolutions, pHingOptionsSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["pHing options are not specified for the following if AdjustpH is set to False: " <> ObjectToString[failingInputs],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["pHing options are not specified for the following if AdjustpH is set to False: " <> ObjectToString[passingInputs],
					True,
					True
				],
				Nothing
			];


			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				(
					Message[Error::NopH, failingInputs];
					Flatten[{AdjustpH, DeleteDuplicates[Flatten[failingpHingOptions]]}]
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* check to make sure the volume is not too low to pH for each input model *)
	volumeTooLowForpHing = If[Not[fastTrack],
		MapThread[
			Function[{prepVolume, adjustpH},
				TrueQ[adjustpH] && (prepVolume < $MinStockSolutionpHVolume)
			],
			{resolvedPreparationVolumes, resolvedAdjustpHBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* generate the tests for if the prep volumes are too low to pH, and throw the messages if necessary *)
	{pHVolumeTooLowTests, pHVolumeTooLowOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingpHVolumes, badOptions},

			(* get the inputs that have volumes too low to pH *)
			failingInputs = PickList[myModelStockSolutions, volumeTooLowForpHing];

			(* get the failing pH prep volume *)
			failingpHVolumes = PickList[resolvedPreparationVolumes, volumeTooLowForpHing];

			(* get the inputs whose pH volumes are fine *)
			passingInputs = PickList[myModelStockSolutions, volumeTooLowForpHing, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["If pH titration is requested, stock solution preparation volume of " <> ObjectToString[failingInputs] <> " is at least " <> ToString[UnitForm[$MinStockSolutionpHVolume,Brackets->False]] <> " to ensure that a pH probe can be inserted into the solution.",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["If pH titration is requested, stock solution preparation volume of " <> ObjectToString[passingInputs] <> " is at least " <> ToString[UnitForm[$MinStockSolutionpHVolume,Brackets->False]] <> " to ensure that a pH probe can be inserted into the solution.",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				(
					Message[Error::BelowpHMinimum, ObjectToString[failingInputs], failingpHVolumes, $MinStockSolutionpHVolume];
					{Volume}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* make sure that if any combination of MinpH, pH, and MaxpH are specified, MinpH < pH < MaxpH *)
	pHOptionOrderSetIncorrectly = Map[
		Function[{pHOptions},
			With[
				{pH = Lookup[pHOptions, pH], minpH = Lookup[pHOptions, MinpH], maxpH = Lookup[pHOptions, MaxpH]},
				Switch[{pH, minpH, maxpH},
					{Automatic, NumericP, NumericP}, Not[minpH < maxpH],
					{NumericP, Automatic, NumericP}, Not[pH < maxpH],
					{NumericP, NumericP, Automatic}, Not[minpH < pH],
					{NumericP, NumericP, NumericP}, Not[minpH < pH < maxpH],
					(* if pH wasn't specified at all, then we're fine (and if the other options were specified when pH was not, we already are throwing an error for that *)
					{_, _, _}, False
				]
			]
		],
		pHingOptionsByModel
	];

	(* generate the tests for if the pHing options were set incorrectly or not, and throw the messages if necessary *)
	{pHOptionOrderSetIncorrectlyTests, pHOptionOrderSetIncorrectlyOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingpHingOptions, badOptions},

			(* get the inputs that have correspondingly-bad pH/MinpH/MaxpH options *)
			failingInputs = PickList[myModelStockSolutions, pHOptionOrderSetIncorrectly];

			(* get the inputs whose pH/MinpH/MaxpH options are fine *)
			passingInputs = PickList[myModelStockSolutions, pHOptionOrderSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["If 2 or more of the options NominalpH, MinpH, and MaxpH are provided for : " <> ObjectToString[failingInputs] <> ", the values are consistent with the ordering MinpH < NominalpH < MaxpH.",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["If 2 or more of the options NominalpH, MinpH, and MaxpH are provided for : " <> ObjectToString[passingInputs] <> ", the values are consistent with the ordering MinpH < NominalpH < MaxpH.",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				(
					Message[Error::pHOrderInvalid, failingInputs];
					{pH, MinpH, MaxpH}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* resolve the MinpH, MaxpH, pHingAcid, and pHingBase options *)
	resolvedpHingOptionsPerModel = MapThread[
		Function[{adjustpHBool, pHOptions, modelPacket, pHingSampleVolume},
			Module[
				{specifiedMinpH, specifiedMaxpH, specifiedpHingAcid, specifiedpHingBase, resolvedMinpH, resolvedMaxpH,
					resolvedpHingAcid, resolvedpHingBase, specifiedpH, nominalpH},

				(* pull out the specified options *)
				{specifiedpH, specifiedMinpH, specifiedMaxpH, specifiedpHingAcid, specifiedpHingBase} =
        Lookup[pHOptions,{pH, MinpH, MaxpH, pHingAcid, pHingBase}];

				(* resolve the pH option; pull from the model; resolve to a value between the min and max pH if they are both specified; if only one of min and max pH are specified, pick 0.1 unit in the correct direction; if neither are specified, resolve to 7 *)
				nominalpH = Which[
					adjustpHBool && MatchQ[specifiedpH, Automatic] && NumericQ[Lookup[modelPacket, NominalpH]], Lookup[modelPacket, NominalpH],
					adjustpHBool && MatchQ[specifiedpH, Automatic] && NumericQ[specifiedMinpH] && NumericQ[specifiedMaxpH], Round[Mean[{specifiedMinpH, specifiedMaxpH}], 0.01],
					adjustpHBool && MatchQ[specifiedpH, Automatic] && NumericQ[specifiedMinpH], specifiedMinpH + 0.1,
					adjustpHBool && MatchQ[specifiedpH, Automatic] && NumericQ[specifiedMaxpH], specifiedMaxpH - 0.1,
					adjustpHBool && MatchQ[specifiedpH, Automatic], 7.,
					Not[adjustpHBool] && MatchQ[specifiedpH, Automatic], Null,
					True, specifiedpH
				];

				(* resolve the MinpH option; somewhat arbitrarily subtract 0.1 pH units *)
				resolvedMinpH = Which[
					NumericQ[nominalpH] && MatchQ[specifiedMinpH, Automatic] && NumericQ[Lookup[modelPacket, MinpH]], SafeRound[Lookup[modelPacket, MinpH], 0.01],
					NumericQ[nominalpH] && MatchQ[specifiedMinpH, Automatic], SafeRound[(nominalpH - 0.1), 0.01],
					NullQ[nominalpH] && MatchQ[specifiedMinpH, Automatic], Null,
					True, specifiedMinpH
				];

				(* resolve the MaxpH option; somewhat arbitrarily add 0.1 pH units *)
				resolvedMaxpH = Which[
					NumericQ[nominalpH] && MatchQ[specifiedMaxpH, Automatic] && NumericQ[Lookup[modelPacket, MaxpH]], SafeRound[Lookup[modelPacket, MaxpH], 0.01],
					NumericQ[nominalpH] && MatchQ[specifiedMaxpH, Automatic], SafeRound[(nominalpH + 0.1), 0.01],
					NullQ[nominalpH] && MatchQ[specifiedMaxpH, Automatic], Null,
					True, specifiedMaxpH
				];

				(* resolve the pHingAcid, where default essentially is HCl *)
				resolvedpHingAcid = Which[
					NumericQ[nominalpH] && MatchQ[specifiedpHingAcid, Automatic] && MatchQ[Lookup[modelPacket, pHingAcid], ObjectP[Model[Sample]]], Lookup[modelPacket, pHingAcid],
					NumericQ[nominalpH] && MatchQ[specifiedpHingAcid, Automatic], Model[Sample,StockSolution,"2 M HCl"],
					NullQ[nominalpH] && MatchQ[specifiedpHingAcid, Automatic], Null,
					True, specifiedpHingAcid
				];

				(* resolve the pHingBase, where default essentially is NaOH *)
				resolvedpHingBase = Which[
					NumericQ[nominalpH] && MatchQ[specifiedpHingBase, Automatic] && MatchQ[Lookup[modelPacket, pHingBase], ObjectP[Model[Sample]]], Lookup[modelPacket, pHingBase],
					NumericQ[nominalpH] && MatchQ[specifiedpHingBase, Automatic], Model[Sample,StockSolution,"1.85 M NaOH"],
					NullQ[nominalpH] && MatchQ[specifiedpHingBase, Automatic], Null,
					True, specifiedpHingBase
				];



				(* put the options together *)
				<|
					pH -> nominalpH,
					MinpH -> resolvedMinpH,
					MaxpH -> resolvedMaxpH,
					pHingAcid -> resolvedpHingAcid,
					pHingBase -> resolvedpHingBase
				|>

			]
		],
		{resolvedAdjustpHBools, pHingOptionsByModel, stockSolutionModelPackets, resolvedPreparationVolumes}
	];

	(* combine the pHing options back together *)
	resolvedpHingOptions = Normal[Merge[resolvedpHingOptionsPerModel, Join]];

	(* --- error check the resolved pHing options --- *)

	(* pull out the resolved ops *)
	{resolvedpH,resolvedMinpH,resolvedMaxpH,resolvedpHingAcid,resolvedpHingBase} = Lookup[resolvedpHingOptions,{pH,MinpH,MaxpH,pHingAcid,pHingBase}];

	(* figure out which options were bad *)
	nullpHingOptionsQ = MapThread[
		Function[
			{pH, minpH, maxpH, acid, base},
			If[MatchQ[pH,NumericP],
				NullQ/@{minpH, maxpH, acid, base},
				{False,False,False,False}
			]
		],
		{resolvedpH,resolvedMinpH,resolvedMaxpH,resolvedpHingAcid,resolvedpHingBase}
	];

	(* part slice to avoid tranpose errors *)
	{unspecifiedMinpH,unspecifiedMaxpH,unspecifiedpHingAcid,unspecifiedpHingBase} = {nullpHingOptionsQ[[All,1]],nullpHingOptionsQ[[All,2]],nullpHingOptionsQ[[All,3]],nullpHingOptionsQ[[All,4]]};

	(* if a pH is resolved, we can't allow the pHing options to be set to Null. make sure this doesn't happen *)
	incompletelySpecifiedpHingQ = Apply[Or,#]&/@nullpHingOptionsQ;

	(* create tests to that effect, and throw a message if appropriate *)
	{incompletelySpecifiedpHingOptions,incompletelySpecifiedpHingTests} = {
		MapThread[
			If[Or@@#1,
				#2,
				Nothing
			]&,
			{
				{unspecifiedMinpH,unspecifiedMaxpH,unspecifiedpHingAcid,unspecifiedpHingBase},
				{MinpH,MaxpH,pHingAcid,pHingBase}
			}
		],
		If[TrueQ[gatherTests],
			Map[
				Test["If a pH is specified, a MinpH, MaxpH, pHingAcid, and pHingBase are specified:",
					#,
					False
				]&,
				incompletelySpecifiedpHingQ
			],
		{}
	]};

	If[Or@@incompletelySpecifiedpHingQ && !gatherTests,
		Message[Error::IncompletelySpecifiedpHingOptions]
	];

	(* conflict check of mix rate -- if specified mix rate is smaller than the safe mix rate of resolved container *)
	mixRateNotSafe = If[Not[fastTrack],
		MapThread[
			Function[{resolvedMixBool, mixRate, mixType, containerPackets, container},
				If[resolvedMixBool && MatchQ[mixRate, Except[Automatic|Null]] && MatchQ[mixType, Stir],
					Module[{safeMixRate},
						(* get the safe mix rate of container model. *)
						safeMixRate = Lookup[fetchPacketFromCache[container, containerPackets], MaxOverheadMixRate];
						(* safeMixRate is very unlikely to be Null since resolvedPrepContainer is from PreferredContainer[]. Give this NullQ check just in case *)
						If[(!NullQ[safeMixRate])&&(safeMixRate < mixRate),
							True,
							False
						]
					],
					False
				]
			],
			{resolvedMixBools, Lookup[roundedExpandedOptions, MixRate], Lookup[roundedExpandedOptions, MixType], resolvedPrepContainerPackets, resolvedPrepContainers}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];
	(* generate the tests for if the specified mix rate is not safe, and throw the messages if necessary *)
	{mixRateNotSafeTests, mixRateNotSafeOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingMixRates, badOptions},

			(* get the inputs that have volumes too low to pH *)
			failingInputs = PickList[myModelStockSolutions, mixRateNotSafe];

			(* get the failing pH prep volume *)
			failingMixRates = PickList[Lookup[roundedExpandedOptions, MixRate], mixRateNotSafe];

			(* get the inputs whose pH volumes are fine *)
			passingInputs = PickList[myModelStockSolutions, mixRateNotSafe, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["If mix rate of " <> ObjectToString[failingInputs] <> " is specified, the requested mix rate should not exceed the safe maximum mix rate of resolved container.",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["If mix rate of " <> ObjectToString[failingInputs] <> " is specified, the requested mix rate should not exceed the safe maximum mix rate of resolved container.",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				Message[Error::SpecifedMixRateNotSafe, failingMixRates];
				{MixRate},
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* --- Resolve the Mix and Incubate options with our helper function --- *)
	{
		mixIncubateTimeMismatchTests,mixIncubateTimeMismatchOptions,mixIncubateInstMismatchTests,mixIncubateInstMismatchOptions,
		mixSubOptionsSetIncorrectlyTests,mixSubOptionsSetIncorrectlyOptions,incubateSubOptionsSetIncorrectlyTests,incubateSubOptionsSetIncorrectlyOptions,
		mixResolvingTests,resolvedMixOptions
	}=resolveMixIncubateStockSolutionOptions[
		Mix,resolvedMixBools,resolvedIncubateBools,resolvedAutoclaveBooleans,roundedExpandedOptions,fastTrack,myModelStockSolutions,gatherTests,
		prepOptionsByModel,stockSolutionModelPackets,messages,resolvedPrepContainers,resolvedPreparationVolumes,resolvedLightSensitive
	];

	(* --- Resolve the PostAutoclaveMix and PostAutoclaveIncubate options with our helper function --- *)
	{
		postAutoclaveMixIncubateTimeMismatchTests,postAutoclaveMixIncubateTimeMismatchOptions,postAutoclaveMixIncubateInstMismatchTests,
		postAutoclaveMixIncubateInstMismatchOptions,postAutoclaveMixSubOptionsSetIncorrectlyTests,postAutoclaveMixSubOptionsSetIncorrectlyOptions,
		postAutoclaveIncubateSubOptionsSetIncorrectlyTests,postAutoclaveIncubateSubOptionsSetIncorrectlyOptions,postAutoclaveMixResolvingTests,
		resolvedPostAutoclaveMixOptions
	}=resolveMixIncubateStockSolutionOptions[
		PostAutoclaveMix,resolvedPostAutoclaveMixBools,resolvedPostAutoclaveIncubateBools,ConstantArray[False,Length[resolvedPostAutoclaveMixBools]],
		roundedExpandedOptions,fastTrack,myModelStockSolutions,gatherTests,
		prepOptionsByModel,stockSolutionModelPackets,messages,resolvedPrepContainers,resolvedPreparationVolumes,resolvedLightSensitive
	];

	(* --- Resolve the Filter options --- *)

	(* assign the names of the Filter "sub-options" (things controlled by Filter bool) *)
	filterSubOptionNames = {FilterType, FilterMaterial, FilterSize, FilterInstrument, FilterModel, FilterSyringe, FilterHousing};

	(* pull out the pre-resolved filter options per model *)
	filterOptionsByModel = Map[
		Function[{prepOptions},
			Select[prepOptions, MemberQ[filterSubOptionNames, Keys[#]]&]
		],
		prepOptionsByModel
	];

	(* check to make sure the filter options are okay with the filter booleans for each input model *)
	filterOptionsSetIncorrectly = If[Not[fastTrack],
		MapThread[
			Function[{ssPacket, prepOptions, filterBool},
				MatchQ[filterBool, False] && MemberQ[Lookup[prepOptions, filterSubOptionNames], Except[Null|Automatic]]
			],
			{stockSolutionModelPackets, filterOptionsByModel, resolvedFilterBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* generate the tests for if the filter options were set incorrectly or not, and throw the messages if necessary *)
	{filterSubOptionsSetIncorrectlyTests, filterSubOptionsSetIncorrectlyOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingFilterOptions, badOptions},

		(* get the inputs that have correspondingly-bad filter options *)
			failingInputs = PickList[myModelStockSolutions, filterOptionsSetIncorrectly];

			(* get the failing filter options *)
			failingFilterOptions = MapThread[
				If[TrueQ[#1],
					PickList[filterSubOptionNames, Lookup[#2, filterSubOptionNames], Except[Automatic|Null]],
					Nothing
				]&,
				{filterOptionsSetIncorrectly, filterOptionsByModel}
			];

			(* get the inputs whose filter options are fine *)
			passingInputs = PickList[myModelStockSolutions, filterOptionsSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["Filter preparation options are not specified for the following if Filter is set to False: " <> ObjectToString[failingInputs],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["Filter preparation options are not specified for the following if Filter is set to False: " <> ObjectToString[passingInputs],
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				(
					Message[Error::FilterOptionConflict, failingInputs, failingFilterOptions];
					Flatten[{Filter, DeleteDuplicates[Flatten[failingFilterOptions]]}]
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* check to make sure the volume is not too low to filter for each input model *)
	volumeTooLowForFiltration = If[Not[fastTrack],
		MapThread[
			Function[{prepVolume, filterBool},
				filterBool && (prepVolume < $MinStockSolutionFilterVolume)
			],
			{resolvedPreparationVolumes, resolvedFilterBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* generate the tests for if the prep volumes are too low to filter, and throw the messages if necessary *)
	{filtrationVolumeTooLowTests, filtrationVolumeTooLowOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingFilterVolumes, badOptions},

		(* get the inputs that have volumes too low to filter *)
			failingInputs = PickList[myModelStockSolutions, volumeTooLowForFiltration];

			(* get the failing filter prep volume *)
			failingFilterVolumes = PickList[resolvedPreparationVolumes, volumeTooLowForFiltration];

			(* get the inputs whose filter volumes are fine *)
			passingInputs = PickList[myModelStockSolutions, volumeTooLowForFiltration, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["If filtration is requested, stock solution preparation volume of " <> ObjectToString[failingInputs] <> " is at least " <> ToString[UnitForm[$MinStockSolutionFilterVolume,Brackets->False]] <> " to ensure that a filtration method with low enough dead volume can be selected.",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["If filtration is requested, stock solution preparation volume of " <> ObjectToString[passingInputs] <> " is at least " <> ToString[UnitForm[$MinStockSolutionFilterVolume,Brackets->False]] <> " to ensure that a filtration method with low enough dead volume can be selected.",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingInputs] > 0 && messages,
				(
					Message[Error::VolumeBelowFiltrationMinimum, failingInputs, failingFilterVolumes, $MinStockSolutionFilterVolume];
					{Filter}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* Figure out if we need to do a sterile filtration (False here means that either there is no filtration or the filtration does not need to be sterile *)
	filterSterileBools=MapThread[
		Function[{autoclave,type},
			MatchQ[type,Media] && !autoclave
		],
		{resolvedAutoclaveBooleans,Lookup[roundedExpandedOptions,Type]}
	];

	(* get the models that we are going to pass to resolveFilterOptions, and their corresponding options, and the container they're going to be prepared in *)
	filteredStockSolutionModels = PickList[stockSolutionModelPackets, resolvedFilterBools];
	filteredStockSolutionModelOptions = PickList[filterOptionsByModel, resolvedFilterBools];
	filteredStockSolutionContainers = PickList[resolvedPrepContainers, resolvedFilterBools];
	filteredStockSolutionPrepVolumes = PickList[resolvedPreparationVolumes, resolvedFilterBools];
	filteredStockSolutionLightSensitives = PickList[resolvedLightSensitive, resolvedFilterBools];
	filteredStockSolutionSteriles = PickList[filterSterileBools, resolvedFilterBools];

	(* make the simulated samples that we are going to pass into resolveExperimentFilterOptionsNew *)
	allFilterSimulatedSampleValues = MapThread[
		SimulateSample[{Model[Sample, "Milli-Q water"]}, CreateUUID[], {"A1"}, #2, {State -> Liquid, LightSensitive -> #3, Volume -> #1, Mass -> Null, Count -> Null, Sterile -> #4}]&,
		{filteredStockSolutionPrepVolumes, filteredStockSolutionContainers, filteredStockSolutionLightSensitives, filteredStockSolutionSteriles}
	];

	(* get the simulated samples and the container values *)
	filterSimulatedSamplePackets = Flatten[allFilterSimulatedSampleValues[[All, 1]]];
	filterSimulatedSampleContainers = allFilterSimulatedSampleValues[[All, 2]];

	(* define a mapping between this function's filter option names and ExperimentFilter option names THAT ARE DIFFERENT *)
	ssToFilterOptionNameMap = {
		FilterType->FiltrationType,
		FilterMaterial -> MembraneMaterial,
		FilterSize -> PoreSize,
		FilterInstrument -> Instrument,
		FilterModel -> Filter,
		FilterSyringe -> Syringe
	};

	(* rename the filter options as ExperimentFilter knows them all by different names*)
	renamedFilterOptions = filteredStockSolutionModelOptions /. ssToFilterOptionNameMap;

	(* get the pre-resolved options per model; this is _kind of_ like using each model as a template, but I can't really use ApplyTemplateOptions here since it's the model as the template and not the protocol *)
	preResolvedFilterOptionsPerModel = MapThread[
		Function[{model, options},
			{
				FiltrationType->Lookup[options, FiltrationType],
				MembraneMaterial -> If[MatchQ[Lookup[options, MembraneMaterial], Automatic] && MatchQ[Lookup[model, FilterMaterial], FilterMembraneMaterialP],
					Lookup[model, FilterMaterial],
					Lookup[options, MembraneMaterial]
				],
				PoreSize -> If[MatchQ[Lookup[options, PoreSize], Automatic] && MatchQ[Lookup[model, FilterSize], FilterSizeP],
					Lookup[model, FilterSize],
					Lookup[options, PoreSize]
				],
				Instrument -> Lookup[options, Instrument],
				Filter -> Lookup[options, Filter],
				Syringe -> Lookup[options, Syringe],
				FilterHousing -> Lookup[options, FilterHousing]
			}
		],
		{filteredStockSolutionModels, renamedFilterOptions}
	];

	(* re-combine the filter options to be index matched again and no longer a list of lists (also Merge makes it an association which is nice for us) *)
	preResolvedFilterOptions = Merge[preResolvedFilterOptionsPerModel, Join];

	(* need to add all the other option names too with SafeOptions here (and also expand the options *)
	filterSimulatedSamplePacketsWithExtraFields = If[MatchQ[filterSimulatedSamplePackets, {}],
		{},
		Last[ExpandIndexMatchedInputs[ExperimentFilter, {filterSimulatedSamplePackets}, SafeOptions[ExperimentFilter, Normal[preResolvedFilterOptions]]]]
	];

	(* use Check to see if we got an error from filter options; still throw a message; ALWAYS assign the results even if messages are thrown  *)
	filterResolveFailure = Check[
		{resFilterOptions, filterResolvingTests} = Which[
			MatchQ[filterSimulatedSamplePackets, {}], {{}, {}},
			gatherTests, ExperimentFilter[Lookup[filterSimulatedSamplePackets, Object], ReplaceRule[filterSimulatedSamplePacketsWithExtraFields, {Cache -> Flatten[{allFilterSimulatedSampleValues}], Simulation -> Simulation[Flatten[{allFilterSimulatedSampleValues}]], OptionsResolverOnly -> True, Output -> {Options, Tests}}]],
			True, {ExperimentFilter[Lookup[filterSimulatedSamplePackets, Object], ReplaceRule[filterSimulatedSamplePacketsWithExtraFields, {Cache -> Flatten[{allFilterSimulatedSampleValues}], Simulation -> Simulation[Flatten[{allFilterSimulatedSampleValues}]], OptionsResolverOnly -> True, Output -> Options}]], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* reverse our earlier lookup to get a map back to our StockSolution options *)
	filterToSSOptionNameMap = Reverse /@ ssToFilterOptionNameMap;

	(* get the resolved filter options with StockSolution option names *)
	filteredResolvedFilterOptionsWithExtras = Map[
		(Keys[#] /. filterToSSOptionNameMap) -> Values[#]&,
		resFilterOptions
	];

	(* remove the filter options that we don't care about  *)
	filteredResolvedFilterOptions = Select[filteredResolvedFilterOptionsWithExtras, MemberQ[filterSubOptionNames, Keys[#]]&];

	(* split the filter options for the mixed samples again; going to join them back up once more *)
	filteredResolvedFilterOptionsPerModel = Table[
		Map[
			# -> Lookup[filteredResolvedFilterOptions, #][[index]]&,
			filterSubOptionNames
		],
		{index, Range[Length[filteredStockSolutionModels]]}
	];

	(* get the non-filter options and stock solution models *)
	notFilteredStockSolutionModels = PickList[stockSolutionModelPackets, resolvedFilterBools, False];
	notFilteredStockSolutionModelOptions = PickList[filterOptionsByModel, resolvedFilterBools, False];

	(* resolve the non-filter samples' incubate options (i.e., all Automatics become Null) *)
	notFilteredResolvedFilterOptionsPerModel = notFilteredStockSolutionModelOptions /. {Automatic -> Null};

	(* get the positions of the incubated and not-incubated models *)
	filteredPositions = Position[resolvedFilterBools, True];
	notFilteredPositions = Position[resolvedFilterBools, False];

	(* make replace rules for ReplacePart for the filtered and non-filtered resolved options we have *)
	filteredPositionReplaceRules = MapThread[#1 -> #2&, {filteredPositions, filteredResolvedFilterOptionsPerModel}];
	notFilteredPositionReplaceRules = MapThread[#1 -> #2&, {notFilteredPositions, notFilteredResolvedFilterOptionsPerModel}];

	(* get the resolved filter options per model *)
	resolvedFilterOptionsPerModel = ReplacePart[resolvedFilterBools, Flatten[{filteredPositionReplaceRules, notFilteredPositionReplaceRules}]];

	(* get the resolved filter options as a list of rules using Merge *)
	resolvedFilterOptions = Normal[Merge[resolvedFilterOptionsPerModel, Join]];

	(* HeatSensitiveReagents and Autoclave error checking *)
	autoclaveHeatSensitiveBools=MapThread[
		Function[{heatSensitiveReagents,autoclaveBool},
			!MatchQ[heatSensitiveReagents,Null | {}]&&!TrueQ[autoclaveBool]
		],
		{resolvedHeatSensitiveReagents,resolvedAutoclaveBooleans}
	];

	invalidAutoclaveHeatSensitiveOptions=If[MemberQ[autoclaveHeatSensitiveBools,True] && messages,
		(
			Message[Error::AutoclaveHeatSensitiveConflict,
				Lookup[#,HeatSensitiveReagents]&/@PickList[stockSolutionFormulaPackets,autoclaveHeatSensitiveBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, autoclaveHeatSensitiveBools]
		),
		{}
	];

	(* make tests for AutoclaveHeatSensitive conflicts *)
	autoclaveHeatSensitiveTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, autoclaveHeatSensitiveBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, autoclaveHeatSensitiveBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", HeatSensitiveReagents is not Null when Autoclave is False:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", HeatSensitiveReagents is not Null when Autoclave is False:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* --- Expand/resolve GellingAgents and MediaPhase --- *)
	resolvedGellingAgents=MapThread[
		Function[
			{suppliedGellingAgents,suppliedMediaPhase,stockSolutionModelPacket},
			Which[
				(* If GellingAgents is supplied, take it *)
				MatchQ[suppliedGellingAgents,Except[Automatic]],
					suppliedGellingAgents,

				(* If this is not coming from ExperimentMedia, resolve to Null *)
				!MatchQ[Lookup[stockSolutionModelPacket,Type],Media|ObjectP[Model[Sample,Media]]],
					Null,

				(* If MediaPhase is set to Solid, resolve to Model[Sample, "Agar"], 20*Gram/Liter *)
				MatchQ[suppliedMediaPhase,Solid],
					{20*Gram/Liter,Model[Sample, "id:zGj91a70m0lv"]},(*"Agar"*)

				(* Otherwise, resolve to Null *)
				True,
					Null
			]
		],
		{Lookup[roundedExpandedOptions,GellingAgents],Lookup[roundedExpandedOptions,MediaPhase],stockSolutionModelPackets}
	];

	resolvedMediaPhases=MapThread[
		Function[
			{gellingAgents,suppliedMediaPhase,stockSolutionModelPacket},
			Which[
				(* If MediaPhase is supplied, take it *)
				MatchQ[suppliedMediaPhase,Except[{Automatic}|Automatic]],
					suppliedMediaPhase,

				(* If this is not coming from ExperimentMedia, resolve to Null *)
				!MatchQ[Lookup[stockSolutionModelPacket,Type],Media|Model[Sample,Media]],
					Null,

				(* If GellingAgents is specified, resolve to Solid *)
				!NullQ[gellingAgents],
					Solid,

				(* Otherwise, we'll assume it's a liquid *)
				True,
					Liquid
			]
		],
		{resolvedGellingAgents,Lookup[roundedExpandedOptions,MediaPhase],stockSolutionModelPackets}
	];

	(* Error checking for media-specific options *)
	solidMediaWithFilterBools=MapThread[
		Function[{stockSolutionType,mediaPhase,filterBool},
			MatchQ[stockSolutionType,Media|Model[Sample,Media]]&&MatchQ[mediaPhase,Solid]&&TrueQ[filterBool]
		],
		{Lookup[roundedExpandedOptions,Type],resolvedMediaPhases,resolvedFilterBools}
	];

	invalidSolidMediaWithFilterOptions=If[MemberQ[solidMediaWithFilterBools,True] && messages,
		(
			Message[Error::FilterSolidMedia,
				Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, solidMediaWithFilterBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, solidMediaWithFilterBools]
		),
		{}
	];

	solidMediaWithFilterTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, solidMediaWithFilterBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, solidMediaWithFilterBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", MediaPhase is not Solid when Filter is True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", MediaPhase is not Solid when Filter is True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}
		]
	];

	mediaNoAutoclaveNonSterileBools=MapThread[
		Function[{stockSolutionType,resolvedFilterOption,autoclaveBool},
			MatchQ[stockSolutionType,Media|Model[Sample,Media]]&&!TrueQ[autoclaveBool]&&!MatchQ[Download[Lookup[resolvedFilterOption,FilterModel],Sterile],True|Null]
		],
		{Lookup[roundedExpandedOptions,Type],resolvedFilterOptionsPerModel,resolvedAutoclaveBooleans}
	];

	invalidMediaNoAutoclaveNonSterileOptions=If[MemberQ[mediaNoAutoclaveNonSterileBools,True] && messages,
		(
			Message[Error::NonSterileFilterWithoutAutoclave,
				Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, mediaNoAutoclaveNonSterileBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, mediaNoAutoclaveNonSterileBools]
		),
		{}
	];

	mediaNoAutoclaveNonSterileTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, mediaNoAutoclaveNonSterileBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, mediaNoAutoclaveNonSterileBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", the FilterModel is sterile when Type is Media and Autoclave is True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", the FilterModel is sterile when Type is Media and Autoclave is True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}
		]
	];

	(* --- Resolve resolvedPrepareInResuspensionContainer --- *)
	resolvedPrepareInResuspensionContainer=MapThread[
		Function[{stockSolutionModelPacket,prepareInResuspensionContainer},
			Which[
				(* if PrepareInResuspensionContainer is given, use it *)
				MatchQ[prepareInResuspensionContainer,Except[Automatic]],
				prepareInResuspensionContainer,
				(* take it from the stock solution model *)
				MatchQ[Lookup[stockSolutionModelPacket,PrepareInResuspensionContainer],BooleanP],
				Lookup[stockSolutionModelPacket,PrepareInResuspensionContainer],
				(* otherwise, default it to False *)
				True, False
			]
		],{stockSolutionModelPackets,Lookup[roundedExpandedOptions,PrepareInResuspensionContainer]}
	];

	(* --- FixedAmounts components and PrepareInResuspensionContainer error checking --- *)
	(* NOTE: we check this after we resolved the PrepareInResuspensionContainer *)
	(* Gotta check it for all the components in stock solution models *)
	{multipleFixedAmountComponentsBools,invalidPreparationBools,invalidResuspensionAmountBools, invalidResuspensionAmounts}=Transpose@MapThread[
		Function[{stockSolutionModelPacket,stockSolutionFormulaPacket,prepareInResuspensionContainer,formulaVolume,resolvedVolumeOption,prepVolume},
			If[MatchQ[Lookup[stockSolutionModelPacket, UnitOperations, {}], Except[{SamplePreparationP..}]],
				Module[{fixedAmountInfo,numberOfFixedAmountComponents,multipleFixedAmountComponentsBool,invalidPreparationBool,invalidResuspensionAmountBool,scalingRatio,formulaAmounts,scaledFormulaAmounts, specifiedFixedAmounts,allowedFixedAmounts,fixedAmountsComponents,invalidResuspensionAmount},
					(* get the fixed amounts information in the formula *)
					fixedAmountInfo=Lookup[stockSolutionFormulaPacket,FixedAmounts,{}];
					(* count how many fixed amount components are in the formula *)
					numberOfFixedAmountComponents=Count[fixedAmountInfo,{(MassP|VolumeP)..}];
					(* multiple FixedAmounts components check *)
					multipleFixedAmountComponentsBool=If[MatchQ[numberOfFixedAmountComponents,GreaterP[1]],
						True,
						False
					];

					(* PrepareInResuspensionContainer check *)
					(* if we are doing PrepareInResuspensionContainer and there is no FixedAmounts components, we assign the invalid bools *)
					invalidPreparationBool=If[MatchQ[prepareInResuspensionContainer,True]&&MatchQ[numberOfFixedAmountComponents,EqualP[0]],
						True,
						False
					];

					(* get the formula amount information and scale it *)
					(* if we have resolved prepVolume use it (happens in the Engine for resource Fulfillment) *)
					scalingRatio = If[MatchQ[prepVolume, Automatic],resolvedVolumeOption,prepVolume] / formulaVolume;
					formulaAmounts=Lookup[stockSolutionModelPacket,Formula][[All,1]];
					scaledFormulaAmounts=formulaAmounts*scalingRatio;
					(* get the specified component amount and allowed fixed amounts info *)
					specifiedFixedAmounts=PickList[scaledFormulaAmounts,fixedAmountInfo,{(MassP|VolumeP)..}];
					allowedFixedAmounts=PickList[fixedAmountInfo,fixedAmountInfo,{(MassP|VolumeP)..}];
					fixedAmountsComponents=PickList[Lookup[stockSolutionModelPacket,Formula][[All,2]],fixedAmountInfo,{(MassP|VolumeP)..}];

					(* track the invalid component *)
					(* skip this if we have more than one fixed amount components since it has been checked, or if not preparing in reference container *)
					(* check this for scaled formula amounts *)
					(* do this check only if we are doing PrepareInResuspensionContainer. Otherwise, we may do combination to reach the specified amounts *)
					(* We are also rounding to sensible numbers here. We can get some numbers with zillion digits from the specified amount calculations and it throws an error because the number is off by a femtogram from the allowed amount *)
					invalidResuspensionAmountBool=Which[
						Length[specifiedFixedAmounts]!=1 || Not[MatchQ[prepareInResuspensionContainer, True]],False,
						MatchQ[First[specifiedFixedAmounts],MassP],Not[MemberQ[Round[First[allowedFixedAmounts],1 Microgram],EqualP[Round[First[specifiedFixedAmounts],1 Microgram]]]],
						MatchQ[First[specifiedFixedAmounts],VolumeP],Not[MemberQ[Round[First[allowedFixedAmounts],0.1 Microliter],EqualP[Round[First[specifiedFixedAmounts],0.1 Microliter]]]],
						True,False
					];

					(* track the invalid amount and component for error message *)
					invalidResuspensionAmount=Flatten[{specifiedFixedAmounts,allowedFixedAmounts,fixedAmountsComponents},1];

					(* generate output *)
					{multipleFixedAmountComponentsBool,invalidPreparationBool,invalidResuspensionAmountBool,invalidResuspensionAmount}
				],
				(* skip this if we're using unitops *)
				{False, False, False, False}
			]
		],
		{stockSolutionModelPackets,stockSolutionFormulaPackets,resolvedPrepareInResuspensionContainer,formulaVolumes,resolvedVolumes,prepVolumes}
	];

	(* if any formula has more than one fix amount components, throw an error *)
	multipleFixedAmountComponents=If[MemberQ[multipleFixedAmountComponentsBools,True] && messages,
		(
			Message[Error::MultipleFixedAmountComponents,
				Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, multipleFixedAmountComponentsBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, multipleFixedAmountComponentsBools]
		),
		{}
	];

	(* make tests for multipleFixedAmountComponents *)
	multipleFixedAmountComponentsTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, multipleFixedAmountComponentsBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, multipleFixedAmountComponentsBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", there is at most one component that is FixedAmounts:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", there is at most one component that is FixedAmounts:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* if PrepareInResuspensionContainer sets to True without any fix amount components in the formula, throw an error *)
	invalidPreparationOptions=If[MemberQ[invalidPreparationBools,True] && messages,
		(
			Message[Error::InvalidPreparationInResuspensionContainer,
				Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidPreparationBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidPreparationBools]
		),
		{}
	];

	(* make tests for invalidPreparationOptions *)
	invalidPreparationTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidPreparationBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidPreparationBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", there is a FixedAmount component when PrepareInResuspensionContainer is True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", there is a FixedAmount component when PrepareInResuspensionContainer is True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* if we are doing PrepareInResuspensionContainer, the specified fixed amount component has to agree with what is allowed in the FixedAmounts field in the model. Otherwise, throw an error *)
	invalidResuspensionAmountsOptions=If[MemberQ[invalidResuspensionAmountBools,True] && messages,
		(
			Message[Error::InvalidResuspensionAmounts,
				PickList[invalidResuspensionAmounts[[All,1]],invalidResuspensionAmountBools],
				PickList[invalidResuspensionAmounts[[All,2]],invalidResuspensionAmountBools],
				PickList[invalidResuspensionAmounts[[All,3]],invalidResuspensionAmountBools]
			];
			Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidResuspensionAmountBools]
		),
		{}
	];

	(* make tests for invalidResuspensionAmountsOptions *)
	invalidResuspensionAmountsTests = If[gatherTests,
		Module[{failingModels, passingModels, failingModelTests, passingModelTests},

			(* get the models that will fail this test *)
			failingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidResuspensionAmountBools];

			(* get the models that will pass this test *)
			passingModels = Lookup[#, Object, {}]&/@PickList[stockSolutionFormulaPackets, invalidResuspensionAmountBools, False];

			(* create a test for the non-passing inputs *)
			failingModelTests = If[Length[failingModels] > 0,
				Test["For the formula used " <> ObjectToString[failingModels] <> ", the specified amount for the FixedAmounts component is allowed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingModelTests = If[Length[passingModels] > 0,
				Test["For the formula used " <> ObjectToString[passingModels] <> ", the specified amount for the FixedAmounts component is allowed:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingModelTests, failingModelTests}

		]
	];

	(* --- Resolve the ContainerOut option --- *)

	(* get the expanded ContainerOut option with the packet if it was specified as an object *)
	expandedContainerOutWithPacketsWithAutomatics = MapThread[
		Function[{primitives, containerOut, volume},
			Which[
				MatchQ[containerOut, ObjectP[]],
					SelectFirst[specifiedContainerOutPackets, MatchQ[Lookup[#, Object], ObjectReferenceP[Download[containerOut, Object]]] &, Null],
				(* this logic is admittedly weird *)
				(* if we have the Primitives option specified, and LabelContainer is the first primitive, and that container is an Object[Container], then pick that container *)
				(* if we have the Primitives option specified, and LabelContainer is the first primitive, and that container is a Model[Container], then pick that container only if it actually fits the volume *)
				(* note that this weird edge case happens because if you're using Primitives and are preparing a multiple of the VolumeIncrements that puts it above the MaxVolume of the LabelContainer container, we are still going to allow this because we're going to combine them at the end *)
				And[
					MatchQ[primitives, Except[Null]],
					MatchQ[FirstOrDefault[primitives], _LabelContainer],
					With[{container = Lookup[FirstOrDefault[primitives][[1]], Container]},
						Or[
							MatchQ[container, ObjectP[Object[Container]]],
							And[
								MatchQ[container, ObjectP[Model[Container]]],
								Lookup[fetchPacketFromFastAssoc[container, fastAssoc], MaxVolume] > volume
							]
						]
					]
				],
					SelectFirst[specifiedContainerOutPackets, MatchQ[Lookup[#, Object], ObjectReferenceP[Download[Lookup[FirstOrDefault[primitives][[1]], Container], Object]]] &, Null],
				True,
					containerOut
			]
		],
		{resolvedPrimitives, Lookup[roundedExpandedOptions, ContainerOut], resolvedVolumes}
	];

	(* get the models and volumes and light sensitivity that correspond with automatic ContainersOut *)
	automaticContainerOutAutoclaveBooleans = PickList[resolvedAutoclaveBooleans, expandedContainerOutWithPacketsWithAutomatics, Automatic];
	automaticContainerOutpHBooleans = PickList[resolvedAdjustpHBools, expandedContainerOutWithPacketsWithAutomatics, Automatic];

	(* resolve the ContainerOut the following way: *)
	(* Use PreferredContainer no matter what *)
	{resolvedContainerOut,containerOutIncompatibleMaterialQ} = Transpose[
		MapThread[
			Function[{modelPacket, volume, lightSensitive, autoclaveBoolean, pHBoolean, contOutPacket},
				If[MatchQ[contOutPacket,Automatic],
					(* Resolve Automatic ContainerOut *)
					Module[{volumeToHold, maxTemperature, potentialContainer},
						(* The preferred container can hold 4/3 (inverse of 3/4) of the volume of the stock solution if autoclaving. *)
						(* The preferred container can hold 1.075 of the volume of the stock solution if pHing to allow room for acid/base addition *)
						volumeToHold = Which[
							MatchQ[autoclaveBoolean, True], N[volume * (4/3)],
							TrueQ[pHBoolean], N[volume * 1.075],
							True, volume
						];

						(* If we are autoclaving, we need to reach a MaxTemperature of 120 Celsius. *)
						maxTemperature = If[MatchQ[autoclaveBoolean, True],
							120 Celsius,
							Automatic
						];

						(* Note: There is also a requirement that the container must be under 0.5 meters in length to fit in the autoclave. *)
						(* But, none of our supported containers are over this length right now. *)
						(* note that if we don't find any container, just quiet that message; if we got this far into the function and are getting that error message, we will have already caught it and don't want the redundancy *)
						(* PreferredContainer overload of model packet already considers the IncompatibleMaterials *)
						potentialContainer = FirstOrDefault[ToList[
							Quiet[PreferredContainer[modelPacket, volumeToHold, LightSensitive -> lightSensitive, Type->Vessel, MaxTemperature -> maxTemperature, All->True], PreferredContainer::ContainerNotFound]
						]] /. {$Failed -> Null};

						(* Resolved Container is compatible *)
						{Download[potentialContainer,Object],False}
					],
					(* Check incompatible materials if provided with a ContainerOut *)
					Module[
						{incompatibleMaterials,containerOutMaterials,incompatibleQ},
						(* Get the sample model's IncompatibleMaterials *)
						incompatibleMaterials=Flatten[{Lookup[modelPacket, IncompatibleMaterials]}]/.{None->Nothing};
						(* Get the specified containerOut's materials *)
						containerOutMaterials=Lookup[contOutPacket,ContainerMaterials];
						(* If the IncompatibleMaterials overlaps with ContainerMaterials, return a True incompatible boolean *)
						incompatibleQ=If[
							IntersectingQ[incompatibleMaterials,containerOutMaterials],
							True,
							False
						];
						{Lookup[contOutPacket,Object],incompatibleQ}
					]
				]
			],
			{stockSolutionModelPackets, resolvedVolumes, resolvedLightSensitive, resolvedAutoclaveBooleans, resolvedAdjustpHBools, expandedContainerOutWithPacketsWithAutomatics}
		]
	];

	expandedContainerOutWithPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ resolvedContainerOut;


	(* generate the tests for whether the ContainerOut is incompatible with the stock solution model *)
	{incompatibleContainerOutTest, incompatibleContainerOutOptions} = If[Not[fastTrack],
		Module[{failingContainersOut, failingStockSolutionModels, passingContainersOut, passingStockSolutionModels, failingInputTest, passingInputTest, badOptions},

			(* get the ContainersOut that are incompatible *)
			failingContainersOut = Lookup[PickList[expandedContainerOutWithPackets, containerOutIncompatibleMaterialQ], Object, {}];

			failingStockSolutionModels = Lookup[PickList[stockSolutionModelPackets, containerOutIncompatibleMaterialQ], Object, {}];

			(* get the inputs whose ContainerOut options are fine *)
			passingContainersOut = Lookup[Cases[PickList[expandedContainerOutWithPackets, containerOutIncompatibleMaterialQ, False], PacketP[Model[Container]]], Object, {}];

			passingStockSolutionModels = Lookup[PickList[stockSolutionModelPackets, containerOutIncompatibleMaterialQ, False], Object, {}];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingContainersOut] > 0 && gatherTests,
				Test["Specified containers in the ContainerOut option " <> ObjectToString[failingContainersOut] <> " are chemically compatible with the requested stock solution model " <> ObjectToString[failingStockSolutionModels] <> ".",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingContainersOut] > 0 && gatherTests,
				Test["Specified containers in the ContainerOut option " <> ObjectToString[passingContainersOut] <> " are chemically compatible with the requested stock solution model " <> ObjectToString[passingStockSolutionModels] <> ".",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingContainersOut] > 0 && messages,
				(
					Message[Error::IncompatibleStockSolutionContainerOut, failingStockSolutionModels, failingContainersOut];
					{ContainerOut}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* check if the ContainerOut is deprecated *)
	containerOutDeprecated = Map[
		If[MatchQ[#, Automatic|Null],
			False,
			TrueQ[Lookup[#, Deprecated]]
		]&,
		expandedContainerOutWithPackets
	];

	(* generate the tests for whether the ContainerOut is deprecated or not *)
	{deprecatedContainerOutTest, deprecatedContainerOutOptions} = If[Not[fastTrack],
		Module[{failingContainersOut, passingContainersOut, failingInputTest, passingInputTest, badOptions},

			(* get the ContainersOut that are deprecated *)
			failingContainersOut = Lookup[PickList[expandedContainerOutWithPackets, containerOutDeprecated], Object, {}];

			(* get the inputs whose ContainerOut options are fine *)
			passingContainersOut = Lookup[Cases[PickList[expandedContainerOutWithPackets, containerOutDeprecated, False], PacketP[Model[Container]]], Object, {}];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingContainersOut] > 0 && gatherTests,
				Test["Specified containers in the ContainerOut option " <> ObjectToString[failingContainersOut] <> " are active (not deprecated).",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingContainersOut] > 0 && gatherTests,
				Test["Specified containers in the ContainerOut option " <> ObjectToString[passingContainersOut] <> " are active (not deprecated).",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingContainersOut] > 0 && messages,
				(
					Message[Error::DeprecatedContainerOut, failingContainersOut];
					{ContainerOut}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* check if the ContainerOut is being autoclaved (MaxTemperature) *)
	containerOutTooLowMaxTemperature = MapThread[
		Function[{container, autoclaveBoolean},
			If[MatchQ[container, PacketP[Model[Container]]],
				(* Are we autoclaving? If so, the container must have a MaxTemperature over 120 Celsius. *)
				If[MatchQ[autoclaveBoolean, True],
					MatchQ[Lookup[container, MaxTemperature], LessP[120 Celsius]],
					False
				],
				False
			]
		],
		{expandedContainerOutWithPackets, resolvedAutoclaveBooleans}
	];

	(* generate the tests for if ContainerOut is too small *)
	{containerOutTooLowMaxTemperatureTests, containerOutTooLowMaxTemperatureOptions} = If[Not[fastTrack],
		Module[{failingContainersOut, passingContainersOut, failingInputTest, passingInputTest,
			failingInputs, failingMaxTemperatures, passingInputs, badOptions},

			(* get the ContainersOut that are deprecated and the corresponding stock solutions, MaxVolumes, and volumes *)
			failingInputs = PickList[myModelStockSolutions, containerOutTooLowMaxTemperature];
			failingContainersOut = Lookup[PickList[expandedContainerOutWithPackets, containerOutTooLowMaxTemperature], Object, {}];
			failingMaxTemperatures = Lookup[PickList[expandedContainerOutWithPackets, containerOutTooLowMaxTemperature], MaxTemperature, {}];

			(* get the inputs whose ContainerOut options are fine *)
			passingInputs = PickList[myModelStockSolutions, containerOutTooLowMaxTemperature, False];
			passingContainersOut = Lookup[Cases[PickList[expandedContainerOutWithPackets, containerOutTooLowMaxTemperature, False], PacketP[Model[Container]]], Object, {}];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingContainersOut] > 0 && gatherTests,
				Test[StringJoin["ContainerOut option ",ObjectToString[failingContainersOut]," has a MaxTemperature (", ToString[UnitForm[failingMaxTemperatures,Brackets->False]], ") over 120 Celsius if autoclaving is specified, for the input(s), ", ToString[failingInputs],"."],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingContainersOut] > 0 && gatherTests,
				Test["ContainerOut option " <> ObjectToString[passingContainersOut] <> " has a MaxTemperature over 120 Celsius if autoclaving is specified for inptu(s), " <> ObjectToString[passingInputs]<>".",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingContainersOut] > 0 && messages,
				(
					Message[Error::ContainerOutMaxTemperature, failingContainersOut, failingInputs, failingMaxTemperatures];
					{ContainerOut}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];


	(* check if the ContainerOut is too big for the specified Volume *)
	containerOutTooSmall = MapThread[
		Function[{container, volume, autoclaveBoolean},
			If[MatchQ[container, PacketP[Model[Container]]],
				(* Are we autoclaving? If so, the volume has to be less than 3/4 of the MaxVolume of the container. *)
				(* Otherwise, just < is good enough. *)
				If[MatchQ[autoclaveBoolean, True],
					TrueQ[N[(3/4) * Lookup[container, MaxVolume]] < volume],
					TrueQ[Lookup[container, MaxVolume] < volume]
				],
				False
			]
		],
		{expandedContainerOutWithPackets, resolvedVolumes, resolvedAutoclaveBooleans}
	];

	(* generate the tests for if ContainerOut is too small *)
	{containerOutTooSmallTests, containerOutTooSmallOptions} = If[Not[fastTrack],
		Module[{failingContainersOut, passingContainersOut, failingInputTest, passingInputTest,
			failingInputs, failingVolumes, failingMaxVolumes, passingInputs, badOptions},

			(* get the ContainersOut that are deprecated and the corresponding stock solutions, MaxVolumes, and volumes *)
			failingInputs = PickList[myModelStockSolutions, containerOutTooSmall];
			failingContainersOut = Lookup[PickList[expandedContainerOutWithPackets, containerOutTooSmall], Object, {}];
			failingVolumes = PickList[resolvedVolumes, containerOutTooSmall];
			failingMaxVolumes = Lookup[PickList[expandedContainerOutWithPackets, containerOutTooSmall], MaxVolume, {}];

			(* get the inputs whose ContainerOut options are fine *)
			passingInputs = PickList[myModelStockSolutions, containerOutTooSmall, False];
			passingContainersOut = Lookup[Cases[PickList[expandedContainerOutWithPackets, containerOutTooSmall, False], PacketP[Model[Container]]], Object, {}];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingContainersOut] > 0 && gatherTests,
				Test[StringJoin["ContainerOut option ",ObjectToString[failingContainersOut]," has a MaxVolume (", ToString[UnitForm[failingMaxVolumes,Brackets->False]], ") sufficient to hold the volume of stock solution ", ToString[failingInputs]," being prepared (", ToString[UnitForm[failingVolumes,Brackets->False]], "). Also, the volume must be less than 3/4 full if this stock solution is being autoclaved."],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingContainersOut] > 0 && gatherTests,
				Test["ContainerOut option " <> ObjectToString[passingContainersOut] <> " has a MaxVolume sufficient to hold the volume of stock solution(s) " <> ObjectToString[passingInputs],
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = If[Length[failingContainersOut] > 0 && messages,
				(
					Message[Error::ContainerOutTooSmall, failingContainersOut, failingInputs, failingMaxVolumes, failingVolumes];
					{ContainerOut}
				),
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];
	
	(* Check if we failed to find a ContainerOut -- we are checking nothing exceeds the max volume, because that has its own error. We don't want to also throw this error and confuse the user *)
	containerOutFailed=MapThread[
		NullQ[#1]&&MatchQ[#2,LessEqualP[$MaxStockSolutionComponentVolume]]&,
		{resolvedContainerOut,resolvedVolumes}
	];

	(* Generate the tests for if ContainerOut is too small *)
	{containerOutFailedTests,containerOutFailedOptions}=Module[{failingInputs,requiredVolumes,failingVolumes,passingInputs,passingVolumes,failingInputTest,passingInputTest},

		(* Get the ContainersOut that are Null and the corresponding stock solutions *)
		failingInputs=PickList[myModelStockSolutions,containerOutFailed];

		(* The preferred container can hold 4/3 (inverse of 3/4) of the volume of the stock solution if autoclaving or 1.075 of the volume of the stock solution if pHing to allow room for acid/base addition *)
		requiredVolumes=If[
			SameLengthQ[resolvedVolumes,automaticContainerOutAutoclaveBooleans,automaticContainerOutpHBooleans],
			MapThread[
				Function[{volume,autoclaveBoolean,pHBoolean},
					Which[
						MatchQ[autoclaveBoolean,True],N[volume*(4/3)],
						TrueQ[pHBoolean],N[volume*1.075],
						True,volume
					]
				],
				{resolvedVolumes,automaticContainerOutAutoclaveBooleans,automaticContainerOutpHBooleans}
			],
			resolvedVolumes
		];

		(* Get the ContainersOut that are Null and the corresponding volumes *)
		failingVolumes=PickList[requiredVolumes,containerOutFailed];

		(* Get the inputs whose ContainerOut is fine *)
		passingInputs=UnsortedComplement[myModelStockSolutions,failingInputs];
		passingVolumes=UnsortedComplement[requiredVolumes,failingVolumes];

		(* Create a test for the non-passing inputs *)
		failingInputTest=If[
			Length[failingInputs]>0&&gatherTests,
			Test[StringJoin["A container can be found to prepare ",ObjectToString[failingInputs]," with the required volume of ",ToString[UnitForm[failingVolumes,Brackets->False]],". The container cannot be more than 75% full for autoclaved stock solutions and 93% full for solutions whose pH needs to be adjusted."],
				True,
				False
			],
			Nothing
		];

		(* Create a test for the passing inputs *)
		passingInputTest=If[Length[passingInputs]>0&&gatherTests,
			Test[StringJoin["A container can be found to prepare ",ObjectToString[passingInputs]," with the required volume of ",ToString[UnitForm[passingVolumes,Brackets->False]],". The container cannot be more than 75% full for autoclaved stock solutions and 93% full for solutions whose pH needs to be adjusted."],
				True,
				True
			],
			Nothing
		];

		(* Throw an error if we need to do so and are throwing messages *)
		If[
			Length[failingInputs]>0&&messages,
			Message[Error::ContainerOutCannotBeFound,failingInputs,failingVolumes]
		];

		(* Return our created tests *)
		If[
			Length[failingInputs]>0,
			{{passingInputTest,failingInputTest},{Volume}},
			{{passingInputTest,failingInputTest},{}}
		]
	];

	(* Now that we've got ContainerOut, we can figure out our StirBar *)
	specifiedStirBars = Lookup[combinedOptions, StirBar];
	resolvedStirBars = Which[
		(* If this is for some odd reason specified, use it *)
		MatchQ[specifiedStirBars,Except[Automatic]],
			specifiedStirBars,

		(* If we're not in Media or we don't have heat sensitive reagents, toss this *)
		NullQ[resolvedMediaPhases] || NullQ[resolvedHeatSensitiveReagents],
			Null,

		(* Otherwise, resolve based on ContainerOut *)
		(* Note that compatibleStirBar is in Incubate/Experiment.m. It takes a container and finds a stir bar/impeller that fits it properly. *)
		True,
			compatibleStirBar/@resolvedContainerOut
	];

	(* Expand the OrderOfOperations option if it is not already. *)
	expandedOrderOfOperations=If[!MatchQ[Lookup[combinedOptions,OrderOfOperations],{_List..}],
		ConstantArray[Lookup[combinedOptions,OrderOfOperations], Length[myModelStockSolutions]],
		Lookup[combinedOptions,OrderOfOperations]
	];

	(* Resolve our order of operations based on if our prep stages are toggled. *)
	resolvedOrderOfOperations=MapThread[
		Function[{primitives, singleOrderOfOperations, resolvedIncubateBool, resolvedMixBool, resolvedFilterBool, adjustpH, solventPacket, stockSolutionModelPacket, resolvedAutoclaveBool, resolvedPostAutoclaveIncubateBool},
			If[MatchQ[singleOrderOfOperations, Automatic],
				Which[
					(* If primitives is specified, turn this option off. *)
					MatchQ[primitives, Except[Null]],
						Null,
					(* Use the value from the packet if present. *)
					MatchQ[Lookup[stockSolutionModelPacket, OrderOfOperations], {_Symbol..}],
						Lookup[stockSolutionModelPacket, OrderOfOperations],
					True,
						Flatten[
							{
								(* Always present *)
								FixedReagentAddition,

								If[MatchQ[solventPacket, ObjectP[]],
									FillToVolume,
									Nothing
								],

								If[TrueQ[adjustpH],
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
								],

								If[MatchQ[resolvedAutoclaveBool, True],
									Autoclave,
									Nothing
								],

								If[MatchQ[resolvedPostAutoclaveIncubateBool, True],
									{FixedHeatSensitiveReagentAddition,PostAutoclaveIncubation},
									Nothing
								]
							}
						]
				],
				singleOrderOfOperations
			]
		],
		{resolvedPrimitives, expandedOrderOfOperations, resolvedIncubateBools, resolvedMixBools, resolvedFilterBools, resolvedAdjustpHBools, stockSolutionSolventPackets, stockSolutionModelPackets, resolvedAutoclaveBooleans, resolvedPostAutoclaveIncubateBools}
	];

	(* --- Assorted other option resolutions --- *)

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[combinedOptions];

	(* Resolve MaxNumberOfOverfillingRepreparations *)
	resolvedMaxNumberOfOverfillingRepreparations = If[!MatchQ[Lookup[combinedOptions, MaxNumberOfOverfillingRepreparations],Automatic],
		(* Respect user input OR if we are doing re-preparation already, we have this option *)
		Lookup[combinedOptions, MaxNumberOfOverfillingRepreparations],
		(* If we have FillToVolume, set to 3; Otherwise Null *)
		If[MemberQ[resolvedFillToVolumeMethods,Except[Null]],
			3,
			Null
		]
	];

	(* Resolve Email option if Automatic; this is a Hidden option; don't send emails if subprotocol; hard-resolve *)
	resolvedEmail = Which[
		(* if we're in engine don't send an email *)
		inEngine, False,

		(* if it's a Boolean, just use that *)
		MatchQ[Lookup[combinedOptions, Email], BooleanP], Lookup[combinedOptions, Email],

		(* catch-all: If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		True,
		If[Lookup[combinedOptions, Upload] && MemberQ[output, Result],
			True,
			False
		]
	];

	(* for any of the formula-only options, just Null them out directly (because we are throwing a Warning and not an error in Warning::FormulaOptionsUnused, we must change whatever they specified to Null) *)
	(* this is okay in the context of the formula overload calling this one because it resolves these options separately and combines them later *)
	pseudoResolvedFormulaOnlyOptions = Normal[AssociationThread[formulaOnlyOptionNames, Null]];

	(* combine ALL the resolved options together *)
	(* add the hidden options in there too *)
	resolvedOptions = ReplaceRule[
		combinedOptions,
		Flatten[{
			Type -> resolvedTypes,
			Volume -> resolvedVolumes,
			Incubate -> resolvedIncubateBools,
			PostAutoclaveIncubate -> resolvedPostAutoclaveIncubateBools,
			Filter -> resolvedFilterBools,
			Mix -> resolvedMixBools,
			PostAutoclaveMix -> resolvedPostAutoclaveMixBools,
			AdjustpH -> resolvedAdjustpHBools,
			ContainerOut -> resolvedContainerOut,
			pseudoResolvedFormulaOnlyOptions,
			resolvedMixOptions,
			resolvedPostAutoclaveMixOptions,
			resolvedpHingOptions,
			resolvedFilterOptions,
			PreFiltrationImage -> resolvedPreFiltrationImage,
			resolvedPostProcessingOptions,
			MaxNumberOfOverfillingRepreparations -> resolvedMaxNumberOfOverfillingRepreparations,
			Email -> resolvedEmail,
			FillToVolumeMethod->resolvedFillToVolumeMethods,
			(* note that this isn't _really_ an option, but I am passing it around like it is an option because we need this in the resource packets function (but don't want users to tinker with it) *)
			PreparatoryVolumes -> resolvedPreparationVolumes,
			(* note this is also needed in the resource, these are the sample that we'll need to make a small volume of in volumetric flasks to get the density of*)
			DensityScouts -> DeleteCases[densityScouts,Null],
			OrderOfOperations -> resolvedOrderOfOperations,
			Autoclave->resolvedAutoclaveBooleans,
			AutoclaveProgram->resolvedAutoclavePrograms,
			PrepareInResuspensionContainer->resolvedPrepareInResuspensionContainer,
			GellingAgents -> resolvedGellingAgents,
			MediaPhase -> resolvedMediaPhases,
			StirBar -> resolvedStirBars,
			HeatSensitiveReagents -> resolvedHeatSensitiveReagents
		}]
	];

	(* --- Final stuff --- *)

	(* combine all the invalid options *)
	invalidOptions = DeleteDuplicates[Join[
		invalidAutoclaveHeatSensitiveOptions,
		multipleFixedAmountComponents,
		invalidPreparationOptions,
		invalidResuspensionAmountsOptions,
		nameInvalidOptions,
		volumeNotInIncrementsOptions,
		fillToVolumeMethodUltrasonicOptions,
		fillToVolumeMethodVolumetricOptions,
		fillToVolumeMethodNoSolventOptions,
		volumeOverMaxIncrementOptions,
		componentsScaledOutOfRangeOptions,
		belowFillToVolumeMinimumOptions,
		aboveFillToVolumeMaximumOptions,
		belowpHMinimumOptions,
		pHingOptionsSetIncorrectlyOptions,
		pHVolumeTooLowOptions,
		pHOptionOrderSetIncorrectlyOptions,
		invalidMediaNoAutoclaveNonSterileOptions,
		invalidSolidMediaWithFilterOptions,
		mixIncubateTimeMismatchOptions,
		postAutoclaveMixIncubateTimeMismatchOptions,
		mixIncubateInstMismatchOptions,
		postAutoclaveMixIncubateInstMismatchOptions,
		incubateSubOptionsSetIncorrectlyOptions,
		postAutoclaveIncubateSubOptionsSetIncorrectlyOptions,
		mixSubOptionsSetIncorrectlyOptions,
		postAutoclaveMixSubOptionsSetIncorrectlyOptions,
		filterSubOptionsSetIncorrectlyOptions,
		filtrationVolumeTooLowOptions,
		preFiltrationOptionFailure,
		deprecatedContainerOutOptions,
		incompatibleContainerOutOptions,
		containerOutTooSmallOptions,
		containerOutTooLowMaxTemperatureOptions,
		incompletelySpecifiedpHingOptions,
		containerOutFailedOptions,
		mixRateNotSafeOptions
	]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* throw InvalidOptions or InvalidInputs if necessary *)
	invalidInputs = DeleteDuplicates[Join[
		deprecatedInvalidInputs,
		prepFormulaInvalidInputs,
		prepTypeInvalidInputs,
		tooManySamplesInputs,
		InvalidModelFormulaForFillToVolumeInputs
	]];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, ObjectToString[invalidInputs]]
	];

	(* make the results rule *)
	resultRule = Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* combine all the tests here and make the tests rule *)
	testsRule = Tests -> If[gatherTests,
		Flatten[{
			solutionDeprecatedTests,
			prepFormulaTests,
			prepTypeTests,
			precisionTests,
			formulaOnlyOptionWarnings,
			multipleFixedAmountComponentsTests,
			invalidPreparationTests,
			invalidResuspensionAmountsTests,
			nameInUseTests,
			volumeNotInIncrementsTests,
			volumeOverMaxIncrementTests,
			componentsScaledOutOfRangeTests,
			belowFillToVolumeMinimumTests,
			aboveVolumetricFillToVolumeMaximumTests,
			belowpHMinimumTests,
			autoclaveHeatSensitiveTests,
			mediaNoAutoclaveNonSterileTests,
			solidMediaWithFilterTests,
			mixIncubateTimeMismatchTests,
			postAutoclaveMixIncubateTimeMismatchTests,
			mixIncubateInstMismatchTests,
			postAutoclaveMixIncubateInstMismatchTests,
			mixSubOptionsSetIncorrectlyTests,
			postAutoclaveMixSubOptionsSetIncorrectlyTests,
			incubateSubOptionsSetIncorrectlyTests,
			postAutoclaveIncubateSubOptionsSetIncorrectlyTests,
			mixResolvingTests,
			postAutoclaveMixResolvingTests,
			pHingOptionsSetIncorrectlyTests,
			pHVolumeTooLowTests,
			pHOptionOrderSetIncorrectlyTests,
			filterSubOptionsSetIncorrectlyTests,
			filtrationVolumeTooLowTests,
			filterResolvingTests,
			preFiltrationTest,
			deprecatedContainerOutTest,
			incompatibleContainerOutTest,
			containerOutTooSmallTests,
			containerOutTooLowMaxTemperatureTests,
			tooManySamplesTest,
			incompletelySpecifiedpHingTests,
			containerOutFailedTests,
			validFormulaForFillToVolumeTests,
			volumeTooLowForAutoclaveTests,
			mixRateNotSafeTests
		}],
		Null
	];

	(* return the values according to the output specification *)
	outputSpecification /. {resultRule, testsRule}

];

DefineOptions[
	resolveStockSolutionPrepContainer,
	Options :> {
		{PreferredContainers -> {}, ObjectP[{Object[Container], Model[Container]}] | {ObjectP[{Object[Container], Model[Container]}]...}, "Indicates the preferred containers if any."}
	}
];

(* extract a helper that resolves the prep container so resolver, resource packet, and USS all calls the same *)
resolveStockSolutionPrepContainer[
	(* if we are calling this helper in USS we would not have a model packet yet, so we just pass a list of option rules *)
	ssModelPacketOrOptionLookup:PacketP[Model[Sample]] | {___Rule},
	prepVolume:VolumeP,
	lightSensitive:(BooleanP|Null),
	autoclaveBool:(BooleanP|Null),
	ftvMethod_,
	containerOut:ObjectP[Model[Container]] | Automatic | Null,
	validVolumetricFlaskPackets_,
	fastCache_,
	ops: OptionsPattern[]
] := Module[{safeOps, preferredContainers},

	safeOps = SafeOptions[resolveStockSolutionPrepContainer, ToList[ops]];
	preferredContainers = Lookup[safeOps, PreferredContainers];

	If[MatchQ[ftvMethod, Volumetric],
		Module[{sortedVolumetricFlaskPackets, defaultMaxVolumeVolumetricFlask},

			(* Sort our flasks from smallest to largest since we're going to FirstCase later to get the smallest flask that can hold our volume. *)
			(* We also want to prefer non-opaque volumetric flasks if there are any available - Opaque->True should be put later in the list (sort will do False-Null-True, matching what we need *)
			sortedVolumetricFlaskPackets = SortBy[validVolumetricFlaskPackets, {Lookup[#, MaxVolume]&, Lookup[#, Opaque]&}];

			(* If there is nothing big enough, just pick the biggest one. we have thrown an error earlier for this case. Here we prefer non-opaque volumetric flask *)
			defaultMaxVolumeVolumetricFlask = Last[SortBy[validVolumetricFlaskPackets, {Lookup[#, MaxVolume]&, !Lookup[#, Opaque]&}]];

			(* get the volumetric flask we want *)
			Lookup[FirstCase[sortedVolumetricFlaskPackets, KeyValuePattern[{MaxVolume -> GreaterEqualP[N[prepVolume]]}], defaultMaxVolumeVolumetricFlask], Object]
		],
		Switch[prepVolume,
			GreaterP[$MaxStockSolutionSolventVolume],
				If[MatchQ[ssModelPacketOrOptionLookup, PacketP[]],
					(* pass the model packet if we have one *)
					PreferredContainer[
						ssModelPacketOrOptionLookup,
						$MaxStockSolutionSolventVolume,
						LightSensitive -> lightSensitive,
						MaxTemperature -> If[TrueQ[autoclaveBool], 121Celsius, Automatic],
						Type -> Vessel
					],
					(* otherwise we have a list of resolved options *)
					PreferredContainer[
						$MaxStockSolutionSolventVolume,
						preferredContainers,
						LightSensitive -> lightSensitive,
						MaxTemperature -> If[TrueQ[autoclaveBool], 121Celsius, Automatic],
						Type -> Vessel,
						All -> True,
						IncompatibleMaterials -> Lookup[ssModelPacketOrOptionLookup, IncompatibleMaterials, Automatic]
					]
				],
			LessP[$MinStockSolutionComponentVolume],
				If[MatchQ[ssModelPacketOrOptionLookup, PacketP[]],
					(* pass the model packet if we have one *)
					PreferredContainer[
						ssModelPacketOrOptionLookup,
						$MinStockSolutionComponentVolume,
						LightSensitive -> lightSensitive,
						MaxTemperature -> If[TrueQ[autoclaveBool], 121Celsius, Automatic],
						Type -> Vessel
					],
					(* otherwise we have a list of resolved options *)
					PreferredContainer[
						$MinStockSolutionComponentVolume,
						preferredContainers,
						LightSensitive -> lightSensitive,
						MaxTemperature -> If[TrueQ[autoclaveBool], 121Celsius, Automatic],
						Type -> Vessel,
						All -> True,
						IncompatibleMaterials -> Lookup[ssModelPacketOrOptionLookup, IncompatibleMaterials, Automatic]
					]
				],
			_,
				stockSolutionPrepContainer[ssModelPacketOrOptionLookup, prepVolume, containerOut, lightSensitive, autoclaveBool, fastCache]
		]
	]
];


(* stockSolutionPrepContainer: Determines the container the stock solution should actually be prepared in
	- This only applies to non-volumetric cases
	- cache must contain packets for all preferred containers and containers out
*)

DefineOptions[
	stockSolutionPrepContainer,
	Options :> {
		{PreferredContainers -> {}, {ObjectP[{Object[Container], Model[Container]}]...}, "Indicates the preferred containers if any."}
	}
];

stockSolutionPrepContainer[
	(* if we are calling this helper in USS we would not have a model packet yet, so we just pass a list of option rules *)
	ssModelPacketOrOptionLookup:PacketP[Model[Sample]] | {___Rule},
	prepVolume:VolumeP,
	containerOut:ObjectP[Model[Container]]|Automatic|Null,
	lightSensitive:(BooleanP|Null),
	autoclave:(BooleanP|Null),
	fastCache_,
	ops:OptionsPattern[]
]:=Module[
	{safeOps, preferredContainers, requiredVolume,preferredContainer,possibleContainers,inRangeContainers},

	safeOps = SafeOptions[stockSolutionPrepContainer, ToList[ops]];
	preferredContainers = Lookup[safeOps, PreferredContainers];

	(* If we're autoclaving, we need the container out to not be more than 3/4 full. Technically, the prep container might not *)
	(* be the same as the container out, but in most cases where we would autoclave (e.g. media), they will likely wind up being *)
	(* the same regardless. In order to prepare for that eventuality, we'll use 4/3 the prep volume if we're autoclaving here. *)
	requiredVolume = If[TrueQ[autoclave],
		4/3*prepVolume,
		prepVolume
	];

	preferredContainer = If[MatchQ[ssModelPacketOrOptionLookup, PacketP[]],
		(* pass the model packet if we have one *)
		PreferredContainer[
			ssModelPacketOrOptionLookup,
			requiredVolume,
			LightSensitive -> TrueQ[lightSensitive],
			MaxTemperature -> If[TrueQ[autoclave], 121Celsius, Automatic],
			Type -> Vessel
		],
		(* otherwise we have a list of resolved options *)
		PreferredContainer[
			requiredVolume,
			preferredContainers,
			LightSensitive -> TrueQ[lightSensitive],
			MaxTemperature -> If[TrueQ[autoclave], 121Celsius, Automatic],
			Type -> Vessel,
			All -> True,
			IncompatibleMaterials -> Lookup[ssModelPacketOrOptionLookup, IncompatibleMaterials, Automatic]
		]
	];

	If[MatchQ[containerOut,Automatic|Null],
		Return[preferredContainer]
	];

	(* - We have a requested ContainerOut, see if we can prepare our solution in it - *)

	(* Get all possible containers *)
	possibleContainers= If[MatchQ[ssModelPacketOrOptionLookup, PacketP[]],
		(* pass the model packet if we have one *)
		PreferredContainer[
			ssModelPacketOrOptionLookup,
			All,
			LightSensitive -> TrueQ[lightSensitive],
			MaxTemperature -> If[TrueQ[autoclave], 121Celsius, Automatic],
			Type -> Vessel
		],
		(* otherwise we have a list of resolved options *)
		PreferredContainer[
			All,
			preferredContainers,
			LightSensitive -> TrueQ[lightSensitive],
			MaxTemperature -> If[TrueQ[autoclave], 121Celsius, Automatic],
			Type -> Vessel,
			All -> True,
			IncompatibleMaterials -> Lookup[ssModelPacketOrOptionLookup, IncompatibleMaterials, Automatic]
		]
	];

	(* Get containers which can hold our volume *)
	inRangeContainers=Select[possibleContainers,RangeQ[requiredVolume,Lookup[fetchPacketFromFastAssoc[#, fastCache], {MinVolume, MaxVolume}]]&];

	(* If we can prepare in our ContainerOut, do so to save an unnecessary transfer *)
	If[MemberQ[inRangeContainers,Lookup[fetchPacketFromFastAssoc[containerOut, fastCache], Object]],
		Download[containerOut,Object],
		preferredContainer
	]
];

(* ::Subsubsection:: *)
(* resolveMixIncubateStockSolutionOptions *)

(* this is a helper function to sync the resolution for PostAutoclaveMix and PostAutoclaveIncubate with the standard versions of each *)
resolveMixIncubateStockSolutionOptions[
	mixOrPost:(Mix|PostAutoclaveMix),
	resolvedMixBools:{BooleanP...},
	resolvedIncubateBools:{BooleanP...},
	autoclaveAfterBools:{BooleanP...},
	roundedExpandedOptions:OptionsPattern[resolveStockSolutionOptions],
	fastTrack:BooleanP,
	myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..},
	gatherTests:BooleanP,
	prepOptionsByModel_,
	stockSolutionModelPackets:{ObjectP[stockSolutionModelTypes]..},
	messages:BooleanP,
	resolvedPrepContainers:{ObjectP[{Object[Container],Model[Container]}]..},
	resolvedPreparationVolumes:{VolumeP..},
	resolvedLightSensitive:{BooleanP..}
]:=Module[
	{
		mixOption, mixTypeOption, mixUntilDissolvedOption, mixerOption, mixTimeOption, maxMixTimeOption, mixRateOption, numberOfMixesOption,
		maxNumberOfMixesOption, mixPipettingVolumeOption,	annealingTimeOption, incubateOption, incubatorOption, incubationTemperatureOption,
		incubationTimeOption, mixSubOptionNames, mixSubSubOptionNames, incubateSubSubOptionNames, mixOptionsByModel, preResolvedMixTimes,
		preResolvedIncubationTimes,mixIncubateTimeMismatchTests,mixIncubateTimeMismatchOptions,preResolvedMixers,
		preResolvedIncubators,mixIncubateInstMismatchTests,mixIncubateInstMismatchOptions,relevantErrorCheckingMixOptionsByModel,
		mixOptionsSetIncorrectly,incubateOptionsSetIncorrectly,mixSubOptionsSetIncorrectlyTests,mixSubOptionsSetIncorrectlyOptions,
		incubateSubOptionsSetIncorrectlyTests,incubateSubOptionsSetIncorrectlyOptions,mixOrIncubateBools,mixedStockSolutionModels,
		mixedStockSolutionModelOptions,mixedStockSolutionContainers,mixedStockSolutionPrepVolumes,mixedStockSolutionLightSensitives,
		mixedMixUntilDissolveds,mixedMixes,mixedIncubations,mixedMixTimes,mixedIncubationTimes,mixedMixers,mixedIncubators,allSimulatedSampleValues,
		mixSimulatedSamplePackets,mixSimulatedSampleContainers,mixingTemperature,modelMixRates,modelMixTypes,modelMixers,modelNumMixes,
		modelMaxNumMixes,modelMixUntilDissolveds,modelMixTimes,potentialMixDevices,passModelValuesQ,ssToMixOptionNameMap,renamedMixOptions,
		preResolvedMixOptionsPerModel,preResolvedMixOptions,mixSimulatedSamplePacketsWithExtraFields,mixResolveFailure,mixToSSOptionNameMap,
		mixedResolvedMixOptionsWithExtras,mixedResolvedMixOptions,mixedResolvedMixOptionsPerModel,mixedResolvedMixOptionsPerModelWithProperTemp,
		notMixedStockSolutionModels,notMixedStockSolutionModelOptions,notMixedResolvedMixOptionsPerModel,mixedPositions,notMixedPositions,
		mixedPositionReplaceRules,notMixedPositionReplaceRules,resolvedMixOptionsPerModel,resolvedMixOptions,resMixOptions, mixResolvingTests, revisedAutoclaveAfterBools
	},

	(* Switch to determine which set of options we're working with *)
	{
		mixOption, mixTypeOption, mixUntilDissolvedOption, mixerOption, mixTimeOption, maxMixTimeOption, mixRateOption, numberOfMixesOption,
		maxNumberOfMixesOption, mixPipettingVolumeOption,	annealingTimeOption, incubateOption, incubatorOption, incubationTemperatureOption,
		incubationTimeOption
	}=If[
		MatchQ[mixOrPost,Mix],
		{
			Mix, MixType, MixUntilDissolved, Mixer, MixTime, MaxMixTime, MixRate, NumberOfMixes, MaxNumberOfMixes, MixPipettingVolume,
			AnnealingTime, Incubate, Incubator, IncubationTemperature, IncubationTime
		},
		{
			PostAutoclaveMix, PostAutoclaveMixType, PostAutoclaveMixUntilDissolved, PostAutoclaveMixer, PostAutoclaveMixTime,
			PostAutoclaveMaxMixTime, PostAutoclaveMixRate, PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes, PostAutoclaveMixPipettingVolume,
			PostAutoclaveAnnealingTime, PostAutoclaveIncubate, PostAutoclaveIncubator, PostAutoclaveIncubationTemperature, PostAutoclaveIncubationTime
		}
	];

	(* assign the names of the Mix "sub-options" (things controlled by Mix bool) *)
	mixSubOptionNames = {
		mixTypeOption, mixUntilDissolvedOption, mixerOption, mixTimeOption, maxMixTimeOption, mixRateOption, numberOfMixesOption,
		maxNumberOfMixesOption, mixPipettingVolumeOption,	annealingTimeOption, incubatorOption, incubationTemperatureOption,
		incubationTimeOption
	};

	(* assign the names of the Mix "sub-sub-options" (things that must not be specified if we are only heating and not mixing) *)
	mixSubSubOptionNames = {
		mixTypeOption, mixUntilDissolvedOption, mixerOption, mixTimeOption, maxMixTimeOption, mixRateOption, numberOfMixesOption,
		maxNumberOfMixesOption, mixPipettingVolumeOption,	annealingTimeOption
	};

	(* assign the names of the Incubate "sub-sub-options" (things that ONLY refer to incubating (i.e., heating and not mixing)) *)
	(* I also didn't include IncubationTime since it can technically be set if Mix -> True IF it is the same as MixTime *)
	incubateSubSubOptionNames = {incubatorOption, incubationTemperatureOption, incubationTimeOption};

	(* pull out the pre-resolved mix options per model *)
	mixOptionsByModel = Map[
		Function[{prepOptions},
			Select[prepOptions, MemberQ[mixSubOptionNames, Keys[#]]&]
		],
		prepOptionsByModel
	];

	(* get the pre-resolved MixTime *)
	(* if Mix -> True, Incubate -> True, IncubationTime is specified, and MixTime is Automatic, then resolve to the IncubationTime; otherwise just stick with what we have *)
	preResolvedMixTimes = MapThread[
		Function[{mix, incubate, mixTime, incubationTime},
			If[mix && incubate && MatchQ[mixTime, Automatic] && MatchQ[incubationTime, TimeP],
				incubationTime,
				mixTime
			]
		],
		{resolvedMixBools, resolvedIncubateBools, Lookup[roundedExpandedOptions, mixTimeOption], Lookup[roundedExpandedOptions, incubationTimeOption]}
	];

	(* get the pre-resolved IncubationTime *)
	(* if Mix -> True, Incubate -> True, MixTime is specified, and IncubationTime is Automatic, then resolve to the MixTime; otherwise just stick with what we have *)
	preResolvedIncubationTimes = MapThread[
		Function[{mix, incubate, mixTime, incubationTime},
			If[mix && incubate && MatchQ[mixTime, TimeP] && MatchQ[incubationTime, Automatic],
				mixTime,
				incubationTime
			]
		],
		{resolvedMixBools, resolvedIncubateBools, Lookup[roundedExpandedOptions, mixTimeOption], Lookup[roundedExpandedOptions, incubationTimeOption]}
	];

	(* make tests and throw an error if there is a mismatch *)
	{mixIncubateTimeMismatchTests, mixIncubateTimeMismatchOptions} = If[Not[fastTrack],
		Module[{mixAndIncubationTimeMismatchQ, failingInputs, passingInputs, failingInputTest, passingInputTest, badOptions},

			(* figure out if MixTime and IncubationTime are both specified, and if so, whether they are the same *)
			(* if True, then there is a mismatch for which we are throwing an error *)
			mixAndIncubationTimeMismatchQ = MapThread[
				Function[{mix, incubate, mixTime, incubationTime},
					If[mix && incubate && TimeQ[mixTime] && TimeQ[incubationTime],
						mixTime != incubationTime,
						False
					]
				],
				{resolvedMixBools, resolvedIncubateBools, preResolvedMixTimes, preResolvedIncubationTimes}
			];

			(* get the inputs that have mismatched MixTime and IncubationTime (and the passing ones) *)
			failingInputs = PickList[myModelStockSolutions, mixAndIncubationTimeMismatchQ, True];
			passingInputs = PickList[myModelStockSolutions, mixAndIncubationTimeMismatchQ, False];

			(* crete a test for the non-passing inputs *)
			failingInputTest = Which[
				Length[failingInputs] > 0 && gatherTests && MatchQ[mixOrPost,Mix],
				Test["If Incubate -> True and Mix -> True, if IncubationTime and MixTime are specified, they are the same for the following inputs: " <> ObjectToString[failingInputs],
					True,
					False
				],

				Length[failingInputs] > 0 && gatherTests,
				Test["If PostAutoclaveIncubate -> True and PostAutoclaveMix -> True, if PostAutoclaveIncubationTime and PostAutoclaveMixTime are specified, they are the same for the following inputs: " <> ObjectToString[failingInputs],
					True,
					False
				],

				True,
				Nothing
			];

			(* crete a test for the non-passing inputs *)
			passingInputTest = Which[
				Length[passingInputs] > 0 && gatherTests && MatchQ[mixOrPost,Mix],
				Test["If Incubate -> True and Mix -> True, if IncubationTime and MixTime are specified, they are the same for the following inputs: " <> ObjectToString[passingInputs],
					True,
					True
				],

				Length[passingInputs] > 0 && gatherTests,
				Test["If PostAutoclaveIncubate -> True and PostAutoclaveMix -> True, if PostAutoclaveIncubationTime and PostAutoclaveMixTime are specified, they are the same for the following inputs: " <> ObjectToString[passingInputs],
					True,
					True
				],

				True,
				Nothing
			];

			(* throw an error about this *)
			badOptions = Which[
				Not[gatherTests] && MemberQ[mixAndIncubationTimeMismatchQ, True] && MatchQ[mixOrPost,Mix],
				(
					Message[Error::MixTimeIncubateTimeMismatch, PickList[preResolvedMixTimes, mixAndIncubationTimeMismatchQ], PickList[preResolvedIncubationTimes, mixAndIncubationTimeMismatchQ], ObjectToString[failingInputs]];
					{MixTime, IncubationTime}
				),

				Not[gatherTests] && MemberQ[mixAndIncubationTimeMismatchQ, True],
				(
					Message[Error::PostAutoclaveMixTimeIncubateTimeMismatch, PickList[preResolvedMixTimes, mixAndIncubationTimeMismatchQ], PickList[preResolvedIncubationTimes, mixAndIncubationTimeMismatchQ], ObjectToString[failingInputs]];
					{PostAutoclaveMixTime, PostAutoclaveIncubationTime}
				),

				True,
				{}
			];

			{{failingInputTest, passingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* get the pre-resolved Mixer *)
	(* if Mix -> True, Incubate -> True, Incubator is specified, and Mixer is Automatic, then resolve to the Incubator; otherwise just stick with what we have *)
	preResolvedMixers = MapThread[
		Function[{mix, incubate, mixer, incubator},
			If[mix && incubate && MatchQ[mixer, Automatic] && MatchQ[incubator, ObjectP[]],
				incubator,
				mixer
			]
		],
		{resolvedMixBools, resolvedIncubateBools, Lookup[roundedExpandedOptions, mixerOption], Lookup[roundedExpandedOptions, incubatorOption]}
	];

	(* get the pre-resolved Incubator *)
	(* if Mix -> True, Incubate -> True, Mixer is specified, and Incubator is Automatic, then resolve to the Mixer; otherwise just stick with what we have *)
	preResolvedIncubators = MapThread[
		Function[{mix, incubate, mixer, incubator},
			If[mix && incubate && MatchQ[mixer, ObjectP[]] && MatchQ[incubator, Automatic],
				mixer,
				incubator
			]
		],
		{resolvedMixBools, resolvedIncubateBools, Lookup[roundedExpandedOptions, mixerOption], Lookup[roundedExpandedOptions, incubatorOption]}
	];

	(* make tests and throw an error if there is a mismatch *)
	{mixIncubateInstMismatchTests, mixIncubateInstMismatchOptions} = If[Not[fastTrack],
		Module[{mixAndIncubateInstMismatchQ, failingInputs, passingInputs, failingInputTest, passingInputTest, badOptions},

			(* figure out if MixTime and IncubationTime are both specified, and if so, whether they are the same *)
			(* if True, then there is a mismatch for which we are throwing an error *)
			mixAndIncubateInstMismatchQ = MapThread[
				Function[{mix, incubate, mixer, incubator},
					If[mix && incubate && MatchQ[mixer, ObjectP[]] && MatchQ[incubator, ObjectP[]],
						!SameObjectQ[mixer, incubator],
						False
					]
				],
				{resolvedMixBools, resolvedIncubateBools, preResolvedMixers, preResolvedIncubators}
			];

			(* get the inputs that have mismatched Mixer and Incubator (and the passing ones) *)
			failingInputs = PickList[myModelStockSolutions, mixAndIncubateInstMismatchQ, True];
			passingInputs = PickList[myModelStockSolutions, mixAndIncubateInstMismatchQ, False];

			(* crete a test for the non-passing inputs *)
			failingInputTest = Which[
				Length[failingInputs] > 0 && gatherTests && MatchQ[mixOrPost,Mix],
				Test["If Incubate -> True and Mix -> True, if Incubator and Mixer are specified, they are the same for the following inputs: " <> ObjectToString[failingInputs],
					True,
					False
				],

				Length[failingInputs] > 0 && gatherTests,
				Test["If PostAutoclaveIncubate -> True and PostAutoclaveMix -> True, if PostAutoclaveIncubator and PostAutoclaveMixer are specified, they are the same for the following inputs: " <> ObjectToString[failingInputs],
					True,
					False
				],

				True,
				Nothing
			];

			(* crete a test for the non-passing inputs *)
			passingInputTest = Which[
				Length[passingInputs] > 0 && gatherTests && MatchQ[mixOrPost,Mix],
				Test["If Incubate -> True and Mix -> True, if Incubator and Mixer are specified, they are the same for the following inputs: " <> ObjectToString[passingInputs],
					True,
					True
				],

				Length[passingInputs] > 0 && gatherTests,
				Test["If PostAutoclaveIncubate -> True and PostAutoclaveMix -> True, if PostAutoclaveIncubator and PostAutoclaveMixer are specified, they are the same for the following inputs: " <> ObjectToString[passingInputs],
					True,
					True
				],

				True,
				Nothing
			];

			(* throw an error about this *)
			badOptions = Which[
				Not[gatherTests] && MemberQ[mixAndIncubateInstMismatchQ, True] && MatchQ[mixOrPost,Mix],
				(
					Message[Error::MixIncubateInstrumentMismatch, PickList[preResolvedMixers, mixAndIncubateInstMismatchQ], PickList[preResolvedIncubators, mixAndIncubateInstMismatchQ], ObjectToString[failingInputs]];
					{Mixer, Incubator}
				),

				Not[gatherTests] && MemberQ[mixAndIncubateInstMismatchQ, True],
				(
					Message[Error::PostAutoclaveMixIncubateInstrumentMismatch, PickList[preResolvedMixers, mixAndIncubateInstMismatchQ], PickList[preResolvedIncubators, mixAndIncubateInstMismatchQ], ObjectToString[failingInputs]];
					{PostAutoclaveMixer, PostAutoclaveIncubator}
				),

				True,
				{}
			];

			{{failingInputTest, passingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* get the relevant mix options to check for each model for error checking *)
	relevantErrorCheckingMixOptionsByModel = MapThread[
		Function[{prepOptions, mix, incubate},
			Which[
				(* if Mix -> False and Incubate -> False, then all of the options are relevant *)
				MatchQ[mix, False] && MatchQ[incubate, False], Select[prepOptions, MemberQ[mixSubOptionNames, Keys[#]]&],
				(* if Mix -> False but Incubate -> True, then only the mix-specific options are what we want to check below *)
				MatchQ[mix, False] && TrueQ[incubate], Select[prepOptions, MemberQ[mixSubSubOptionNames, Keys[#]]&],
				(* if Mix -> True and Incubate -> False, then the incubate-specific options are the ones we want to check *)
				TrueQ[mix] && MatchQ[incubate, False], Select[prepOptions, MemberQ[incubateSubSubOptionNames, Keys[#]]&],
				(* otherwise, check everything *)
				True, Select[prepOptions, MemberQ[mixSubOptionNames, Keys[#]]&]
			]
		],
		{prepOptionsByModel, resolvedMixBools, resolvedIncubateBools}
	];

	(* check to make sure the mix options are okay with the mix booleans for each input model *)
	mixOptionsSetIncorrectly = If[Not[fastTrack],
		MapThread[
			Function[{ssPacket, prepOptions, mix, incubate},
				(* the following cases are bad *)
				Or[
					(* if Mix -> False and we are not Incubating, then none of the options can be set *)
					MatchQ[mix, False] && MatchQ[incubate, False] && MemberQ[Lookup[prepOptions, mixSubOptionNames], Except[Null|Automatic]],
					(* if Mix -> False but Incubate -> True, then the mixing-specific options cannot be set *)
					MatchQ[mix, False] && TrueQ[incubate] && MemberQ[Lookup[prepOptions, mixSubSubOptionNames], Except[Null|Automatic]]
				]
			],
			{stockSolutionModelPackets, mixOptionsByModel, resolvedMixBools, resolvedIncubateBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* check to make sure the incubat eoptions are okay with the incubate booleans for each input model *)
	incubateOptionsSetIncorrectly = If[Not[fastTrack],
		MapThread[
			Function[{prepOptions, incubate},
				(* if Incubate -> False, then none of the incubate options can be set *)
				MatchQ[incubate, False] && MemberQ[Lookup[prepOptions, incubateSubSubOptionNames], Except[Null|Automatic]]
			],
			{mixOptionsByModel, resolvedIncubateBools}
		],
		ConstantArray[False, Length[myModelStockSolutions]]
	];

	(* generate the tests for if the mix options were set incorrectly or not, and throw the messages if necessary *)
	{mixSubOptionsSetIncorrectlyTests, mixSubOptionsSetIncorrectlyOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingMixOptions, badOptions},

			(* get the inputs that have correspondingly-bad mix options *)
			failingInputs = PickList[myModelStockSolutions, mixOptionsSetIncorrectly];

			(* get the failing mix options *)
			failingMixOptions = MapThread[
				If[TrueQ[#1],
					(* the Lookup[#2, mixSubOptionNames, Null] is there because mixSubOptionNames includes everything, but #2 only includes the relevant ones, and so if the other ones are not there, they should be Null because they are irrelevant anyway *)
					PickList[mixSubOptionNames, Lookup[#2, mixSubOptionNames, Null], Except[Automatic|Null]],
					Nothing
				]&,
				{mixOptionsSetIncorrectly, relevantErrorCheckingMixOptionsByModel}
			];

			(* get the inputs whose mix options are fine *)
			passingInputs = PickList[myModelStockSolutions, mixOptionsSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["Mixing preparation options are not specified for the following if "<>ToString[mixOption]<>" is set to False: " <> ObjectToString[failingInputs],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["Mixing preparation options are not specified for the following if "<>ToString[mixOption]<>" is set to False: " <> ObjectToString[passingInputs],
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = Which[
				Length[failingInputs] > 0 && messages && MatchQ[mixOrPost,Mix],
				(
					Message[Error::MixOptionConflict, failingMixOptions, ObjectToString[failingInputs]];
					Flatten[{Mix, DeleteDuplicates[Flatten[failingMixOptions]]}]
				),

				Length[failingInputs] > 0 && messages,
				(
					Message[Error::PostAutoclaveMixOptionConflict, failingMixOptions, ObjectToString[failingInputs]];
					Flatten[{PostAutoclaveMix, DeleteDuplicates[Flatten[failingMixOptions]]}]
				),

				True,
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* generate the tests for if the incubate options were set incorrectly or not, and throw the messages if necessary *)
	{incubateSubOptionsSetIncorrectlyTests, incubateSubOptionsSetIncorrectlyOptions} = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingIncubateOptions, badOptions},

			(* get the inputs that have correspondingly-bad mix options *)
			failingInputs = PickList[myModelStockSolutions, incubateOptionsSetIncorrectly];

			(* get the failing mix options *)
			failingIncubateOptions = MapThread[
				If[TrueQ[#1],
					(* the Lookup[#2, mixSubOptionNames, Null] is there because mixSubOptionNames includes everything, but #2 only includes the relevant ones, and so if the other ones are not there, they should be Null because they are irrelevant anyway *)
					PickList[incubateSubSubOptionNames, Lookup[#2, incubateSubSubOptionNames, Null], Except[Automatic|Null]],
					Nothing
				]&,
				{incubateOptionsSetIncorrectly, relevantErrorCheckingMixOptionsByModel}
			];

			(* get the inputs whose mix options are fine *)
			passingInputs = PickList[myModelStockSolutions, incubateOptionsSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["Incubating preparation options are not specified for the following if "<>ToString[incubateOption]<>" is set to False: " <> ObjectToString[failingInputs],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["Incubating preparation options are not specified for the following if "<>ToString[incubateOption]<>" is set to False: " <> ObjectToString[passingInputs],
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			badOptions = Which[
				Length[failingInputs] > 0 && messages && MatchQ[mixOrPost,Mix],
				(
					Message[Error::IncubateOptionConflict, failingIncubateOptions, ObjectToString[failingInputs]];
					Flatten[{Incubate, DeleteDuplicates[Flatten[failingIncubateOptions]]}]
				),

				Length[failingInputs] > 0 && messages,
				(
					Message[Error::PostAutoclaveIncubateOptionConflict, failingIncubateOptions, ObjectToString[failingInputs]];
					Flatten[{PostAutoclaveIncubate, DeleteDuplicates[Flatten[failingIncubateOptions]]}]
				),

				True,
				{}
			];

			(* Return our created tests. *)
			{{passingInputTest, failingInputTest}, badOptions}
		],
		{{}, {}}
	];

	(* get a Boolean indicating if we are mixing OR incubating *)
	mixOrIncubateBools = MapThread[
		#1 || #2&,
		{resolvedMixBools, resolvedIncubateBools}
	];

	(* get the models that we are going to pass to resolveMixOptions, and their corresponding options, and the container they're going to be prepared in *)
	mixedStockSolutionModels = PickList[stockSolutionModelPackets, mixOrIncubateBools];
	mixedStockSolutionModelOptions = PickList[mixOptionsByModel, mixOrIncubateBools];
	mixedStockSolutionContainers = PickList[resolvedPrepContainers, mixOrIncubateBools];
	mixedStockSolutionPrepVolumes = PickList[resolvedPreparationVolumes, mixOrIncubateBools];
	mixedStockSolutionLightSensitives = PickList[resolvedLightSensitive, mixOrIncubateBools];
	mixedMixUntilDissolveds = PickList[Lookup[stockSolutionModelPackets, mixUntilDissolvedOption, {}], mixOrIncubateBools];
	mixedMixes = PickList[resolvedMixBools, mixOrIncubateBools];
	mixedIncubations = PickList[resolvedIncubateBools, mixOrIncubateBools];
	mixedMixTimes = PickList[preResolvedMixTimes, mixOrIncubateBools];
	mixedIncubationTimes = PickList[preResolvedIncubationTimes, mixOrIncubateBools];
	mixedMixers = PickList[preResolvedMixers, mixOrIncubateBools];
	mixedIncubators = PickList[preResolvedIncubators, mixOrIncubateBools];

	(* make the simulated samples that we are going to pass into resolveMixOptions *)
	(* If we didnt resolve a prep container, then this simulation can be skipped, and return an empty list *)
	allSimulatedSampleValues = If[Length[mixedStockSolutionContainers]>0,
		MapThread[
			(* If we have a stock solution model, we should use that for our simulation. else, use water *)
		If[ObjectQ[#4],
			SimulateSample[{#4}, CreateUUID[], {"A1"}, #2, {State -> Liquid, LightSensitive -> #3, Volume -> #1, Mass -> Null, Count -> Null}],
			SimulateSample[{Model[Sample, "Milli-Q water"]}, CreateUUID[], {"A1"}, #2, {State -> Liquid, LightSensitive -> #3, Volume -> #1, Mass -> Null, Count -> Null}]
		]&,
		{mixedStockSolutionPrepVolumes, mixedStockSolutionContainers, mixedStockSolutionLightSensitives,Lookup[mixedStockSolutionModels,Object]}
	], {}
	];
	(*	(* make the simulated samples that we are going to pass into resolveMixOptions *)
	allSimulatedSampleValues = MapThread[
		If[ObjectQ[#4],
			SimulateSample[{#4}, CreateUUID[], {"A1"}, #2, {State -> Liquid, LightSensitive -> #3, Volume -> #1, Mass -> Null, Count -> Null}],
			SimulateSample[{Model[Sample, "Milli-Q water"]}, CreateUUID[], {"A1"}, #2, {State -> Liquid, LightSensitive -> #3, Volume -> #1, Mass -> Null, Count -> Null}]
		]&,
			{mixedStockSolutionPrepVolumes, mixedStockSolutionContainers, mixedStockSolutionLightSensitives,Lookup[stockSolutionModelPackets,Object]}
	];*)
	(* get the simulated samples and the container values *)
	mixSimulatedSamplePackets = Flatten[allSimulatedSampleValues[[All, 1]]];
	mixSimulatedSampleContainers = allSimulatedSampleValues[[All, 2]];

	(* figure out our mixing temperature; need this for our MixDevices call *)
	(* if it's Automatic and we are NOT incubating, resolve the Automatic to Null right now because it's going to resolve to Ambient which we definitely don't want *)
	mixingTemperature = MapThread[
		Function[{model, options, incubateBool, mixBool},
			Which[
				MatchQ[Lookup[options, incubationTemperatureOption], TemperatureP|Null|Ambient], Lookup[options, incubationTemperatureOption],
				(* don't want to resolve to Ambient here so just jump straight to Null *)
				MatchQ[Lookup[options, incubationTemperatureOption], Automatic] && Not[incubateBool], Null,
				MatchQ[Lookup[options, incubationTemperatureOption], Automatic] && MatchQ[Lookup[model, incubationTemperatureOption], TemperatureP], Lookup[model, incubationTemperatureOption],
				(* if we are incubating but IncubationTemperature is not set and the field isn't populated in the model, resolve to 30 Celsius because we need to do this since ExpeirmentIncubate won't do it for us *)
				MatchQ[Lookup[options, incubationTemperatureOption], Automatic] && incubateBool, 30*Celsius,
				True, Automatic
			]
		],
		{mixedStockSolutionModels, mixedStockSolutionModelOptions, mixedIncubations, mixedMixes}
	];

	(* get all the model MixRate/MixType/Mixer from the stock solution models *)
	modelMixRates = Lookup[mixedStockSolutionModels, mixRateOption, {}];
	modelMixTypes = Lookup[mixedStockSolutionModels, mixTypeOption, {}];
	modelMixers = Download[Lookup[mixedStockSolutionModels, mixerOption, {}], Object];
	modelNumMixes = Lookup[mixedStockSolutionModels, numberOfMixesOption, {}];
	modelMaxNumMixes = Lookup[mixedStockSolutionModels, maxNumberOfMixesOption, {}];
	modelMixUntilDissolveds = Lookup[mixedStockSolutionModels, mixUntilDissolvedOption, {}];
	modelMixTimes = Lookup[mixedStockSolutionModels, mixTimeOption, {}];

	(* MapThread over the simulated sample values and get what the potential mix devices we can have based on what is stored in the model *)
	potentialMixDevices = MapThread[
		Function[{simulatedSamplePacket, mixType, mixRate, temperature},
			(* if MixType is Invert or Pipette (or Null) it's not going to have devices (and as of this comment's writing, it doesn't take those anyway) *)
			If[MatchQ[mixType, Null|Invert|Pipette|Swirl],
				{},
				MixDevices[simulatedSamplePacket, Types -> If[MatchQ[mixTypeOption,PostAutoclaveMixType],{Stir},{mixType}], Rate -> mixRate, Temperature -> (temperature /. {Automatic -> Null}), Cache -> Flatten[allSimulatedSampleValues]]
			]
		],
		{mixSimulatedSamplePackets, modelMixTypes, modelMixRates, mixingTemperature}
	];

	(* get a boolean for whether or not we pass down the MixRate/MixType/Mixer to the resolver; this depends on whether we have mix devices or not and if Mixer was specified, if it's in there *)
	(* if the model doesn't have a Mixer, then we pass down values if there are mix devices we can use; if it does have a mixer, make sure that mixer is in the mix devices list *)
	(* note that the exception is Invert or Pipette, which don't have to have a device to be successful *)
	passModelValuesQ = MapThread[
		If[NullQ[#2],
			Length[#1] > 0 || MatchQ[#3, Invert|Pipette],
			MemberQ[#1, ObjectP[#2]]
		]&,
		{potentialMixDevices, modelMixers, modelMixTypes}
	];

	(* define a mapping between this function's mix option names and ExperimentMix option names THAT ARE (or can be) DIFFERENT *)
	ssToMixOptionNameMap = {
		mixerOption -> Instrument,
		mixTimeOption -> Time,
		maxMixTimeOption -> MaxTime,
		mixPipettingVolumeOption -> MixVolume,
		incubationTemperatureOption -> Temperature,
		mixRateOption -> MixRate,
		mixTypeOption -> MixType,
		mixUntilDissolvedOption -> MixUntilDissolved,
		numberOfMixesOption -> NumberOfMixes,
		maxNumberOfMixesOption -> MaxNumberOfMixes,
		annealingTimeOption -> AnnealingTime,
		incubatorOption -> Incubator,
		incubationTimeOption -> IncubationTime
	};

	(* rename the mix options as ExperimentMix knows them all by different names*)
	renamedMixOptions = mixedStockSolutionModelOptions /. ssToMixOptionNameMap;

	(* Make sure we're not breaking anything with autoclaveAfterBool *)
	revisedAutoclaveAfterBools = PickList[autoclaveAfterBools, mixOrIncubateBools];

	(* get the pre-resolved options per model; this is _kind of_ like using each model as a template, but I can't really use ApplyTemplateOptions here since it's the model as the template and not the protocol *)
	preResolvedMixOptionsPerModel = MapThread[
		Function[{model, options, incubateBool, mixBool, mixTime, incubationTime, mixTemp, maybeMixRate, maybeMixType, maybeMixer, passModelValueQ, numMixes, maxNumMixes, modelMixUntilDissolved, container, modelMixTime, autoclaveAfterBool},
			{
				(* if we're not mixing, change an Automatic to Null because we don't want the resolver to think we actually are mixing *)
				(* if passModelValueQ is True and the mix type is not specified, then pass whatever the model's value is *)
				MixType->Which[
					MatchQ[Lookup[options, MixType], Automatic] && Not[mixBool], Null,
					MatchQ[Lookup[options, MixType], MixTypeP|Null], Lookup[options, MixType],
					MatchQ[container, ObjectP[Model[Container,Vessel,VolumetricFlask]]] && Not[TimeQ[modelMixTime]], Invert,
					passModelValueQ, maybeMixType,
					True, Automatic
				],
				MixUntilDissolved -> Which[
					MatchQ[Lookup[options, MixUntilDissolved], Automatic] && Not[mixBool], Automatic,
					MatchQ[Lookup[options, MixUntilDissolved], BooleanP], Lookup[options, MixUntilDissolved],
					MatchQ[modelMixUntilDissolved, BooleanP], modelMixUntilDissolved,
					MatchQ[autoclaveAfterBool, True], False,
					True, Automatic
				],
				(* since Mixer/Incubator are two options here but only one in ExperimentIncubate, need some complicated logic to decide which one to pass down *)
				(* if passModelValueQ is True and the mixer is not specified, then pass whatever the model's value is *)
				Instrument -> Which[
					MatchQ[Lookup[options, Instrument], ObjectP[]|Null], Lookup[options, Instrument],
					MatchQ[Lookup[options, Incubator], ObjectP[]|Null], Lookup[options, Incubator],
					passModelValueQ && Not[NullQ[maybeMixer]], maybeMixer,
					True, Automatic
				],
				(* since IncubationTime/MixTime are two options here but only one option in ExperimentIncubate, need some complicated logic to decide which one to pass down *)
				(* don't be dumb and resolve Time/MaxTime from the model if the specified mix type is Pipette or Inversion *)
				Time -> Which[
					TimeQ[mixTime] && mixBool, mixTime,
					TimeQ[incubationTime] && incubateBool, incubationTime,
					MatchQ[mixTime, Automatic] && Not[mixBool] && Not[incubateBool], Null,
					MatchQ[mixTime, Automatic] && MatchQ[Lookup[options, Type], Pipette|Invert], Automatic,
					MatchQ[mixTime, Automatic] && mixBool && TimeQ[Lookup[model, MixTime]], Lookup[model, MixTime],
					MatchQ[incubationTime, Automatic] && incubateBool && TimeQ[Lookup[model, incubationTimeOption]], Lookup[model, incubationTimeOption],
					True, Automatic
				],
				MaxTime -> Which[
					TimeQ[Lookup[options, MaxTime]], Lookup[options, MaxTime],
					MatchQ[Lookup[options, MaxTime], Automatic] && Not[mixBool] && Not[incubateBool], Null,
					MatchQ[Lookup[options, MaxTime], Automatic] && MatchQ[Lookup[options, Type], Pipette|Invert], Automatic,
					MatchQ[Lookup[options, MaxTime], Automatic] && mixBool && TimeQ[Lookup[model, maxMixTimeOption]], Lookup[model, maxMixTimeOption],
					True, Automatic
				],
				(* if passModelValueQ is True and the mix rate is not specified, then pass whatever the model's value is *)
				MixRate -> Which[
					MatchQ[Lookup[options, MixRate], RPMP|Null], Lookup[options, MixRate],
					passModelValueQ && Not[NullQ[maybeMixRate]], maybeMixRate,
					True, Automatic
				],
				NumberOfMixes -> Which[
					MatchQ[Lookup[options, NumberOfMixes], Automatic] && Not[mixBool], Null,
					MatchQ[Lookup[options, NumberOfMixes], GreaterP[0, 1]|Null], Lookup[options, NumberOfMixes],
					MatchQ[numMixes, GreaterP[0, 1]], numMixes,
					True, Automatic
				],
				MaxNumberOfMixes -> Which[
					MatchQ[Lookup[options, MaxNumberOfMixes], Automatic] && Not[mixBool], Null,
					MatchQ[Lookup[options, MaxNumberOfMixes], GreaterP[0, 1]|Null], Lookup[options, MaxNumberOfMixes],
					MatchQ[maxNumMixes, GreaterP[0, 1]], maxNumMixes,
					True, Automatic
				],
				MixVolume -> Lookup[options, MixVolume],
				AnnealingTime -> Lookup[options, AnnealingTime],
				Mix -> mixBool,
				(* this one we already resolved above *)
				Temperature -> mixTemp,
				(* Aliquot/Filter/Centrifuge is always False in StockSolution; don't even think about allowing it *)
				Aliquot -> False,
				Filtration -> False,
				Centrifuge ->False
			}
		],
		{mixedStockSolutionModels, renamedMixOptions, mixedIncubations, mixedMixes, mixedMixTimes, mixedIncubationTimes, mixingTemperature, modelMixRates, modelMixTypes, modelMixers, passModelValuesQ, modelNumMixes, modelMaxNumMixes, modelMixUntilDissolveds, mixedStockSolutionContainers, modelMixTimes, revisedAutoclaveAfterBools}
	];

	(* re-combine the mix options to be index matched again and no longer a list of lists (also Merge makes it an association which is nice for us) *)
	preResolvedMixOptions = Merge[preResolvedMixOptionsPerModel, Join];

	(* need to add all the other option names too with SafeOptions here (and also expand the options *)
	mixSimulatedSamplePacketsWithExtraFields = If[MatchQ[mixSimulatedSamplePackets, {}],
		{},
		Last[ExpandIndexMatchedInputs[ExperimentIncubate, {mixSimulatedSamplePackets}, SafeOptions[ExperimentIncubate, Normal[preResolvedMixOptions]]]]
	];

	(* use Check to see if we got an error from mix options; still throw those message; ALWAYS assign the results even if messages are thrown  *)
	mixResolveFailure = Check[
		{resMixOptions, mixResolvingTests} = Which[
			MatchQ[mixSimulatedSamplePackets, {}], {{}, {}},
			gatherTests, ExperimentIncubate[Lookup[mixSimulatedSamplePackets, Object], ReplaceRule[mixSimulatedSamplePacketsWithExtraFields, {Cache -> Flatten[allSimulatedSampleValues], Simulation -> Simulation[Flatten[allSimulatedSampleValues]], Output -> {Options, Tests}}]],
			True, {ExperimentIncubate[Lookup[mixSimulatedSamplePackets, Object], ReplaceRule[mixSimulatedSamplePacketsWithExtraFields, {Cache -> Flatten[allSimulatedSampleValues], Simulation -> Simulation[Flatten[allSimulatedSampleValues]], Output -> Options}]], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* reverse our earlier lookup to get a map back to our StockSolution options *)
	mixToSSOptionNameMap = Reverse /@ ssToMixOptionNameMap;

	(* get the resolved mix options with StockSolution option names *)
	mixedResolvedMixOptionsWithExtras = Map[
		(Keys[#] /. mixToSSOptionNameMap) -> Values[#]&,
		resMixOptions
	];

	(* remove the mix options that we don't care about  *)
	mixedResolvedMixOptions = Select[mixedResolvedMixOptionsWithExtras, MemberQ[mixSubOptionNames, Keys[#]]&];

	(* split the mix options for the mixed samples again; going to join them back up once more *)
	(* for IncubationTime and Incubator though, just always do Null; we will _actually_ resolve it properly in the next line since it is kind of weird *)
	mixedResolvedMixOptionsPerModel = Table[
		Map[
			If[MatchQ[#, incubationTimeOption|incubatorOption],
				# -> Null,
				# -> Lookup[mixedResolvedMixOptions, #][[index]]
			]&,
			mixSubOptionNames
		],
		{index, Range[Length[mixedStockSolutionModels]]}
	];

	(* get the proper IncubationTime and Incubator options *)
	mixedResolvedMixOptionsPerModelWithProperTemp = MapThread[
		Function[{options, mixBool, incubateBool, preResolvedMixTime, preResolvedIncubationTime, preResolvedMixer, preResolvedIncubator},
			Map[
				(* if we are incubating and mixing, then IncubationTime should be what we pre-resolved to (unless that was Automatic, in which case we change to what MixTime resolved to)*)
				(* if we are incubating and NOT mixing, then IncubationTime should be MixTime is currently (since "MixTime" is just what Time was in ExperimentIncubate *)
				(* if we are incubating and NOT mixing, then MixTime should actually be what we pre-resolved (unless that was Automatic, in which case we need it to be Null) *)
				(* if we are mixing and NOT incubating, then the IncubationTime should be waht we pre-resolved to (unless it was Automatic, in which case we need it to be Null) *)
				(* exact same logic as the above four except with Incubator/Mixer *)
				(* otherwise, keep the options the same *)
				Which[
					incubateBool && mixBool && MatchQ[Keys[#], incubationTimeOption], Keys[#] -> (preResolvedIncubationTime /. {Automatic -> Lookup[options, mixTimeOption]}),
					incubateBool && Not[mixBool] && MatchQ[Keys[#], incubationTimeOption], Keys[#] -> Lookup[options, mixTimeOption],
					incubateBool && Not[mixBool] && MatchQ[Keys[#], mixTimeOption], Keys[#] -> (preResolvedMixTime /. {Automatic -> Null}),
					mixBool && Not[incubateBool] && MatchQ[Keys[#], incubationTimeOption], Keys[#] -> (preResolvedIncubationTime /. {Automatic -> Null}),

					incubateBool && mixBool && MatchQ[Keys[#], incubatorOption], Keys[#] -> (preResolvedIncubator /. {Automatic -> Lookup[options, mixerOption]}),
					incubateBool && Not[mixBool] && MatchQ[Keys[#], incubatorOption], Keys[#] -> Lookup[options, mixerOption],
					incubateBool && Not[mixBool] && MatchQ[Keys[#], mixerOption], Keys[#] -> (preResolvedMixer /. {Automatic -> Null}),
					mixBool && Not[incubateBool] && MatchQ[Keys[#], incubatorOption], Keys[#] -> (preResolvedIncubator /. {Automatic -> Null}),

					True, #
				]&,
				options
			]
		],
		{mixedResolvedMixOptionsPerModel, mixedMixes, mixedIncubations, mixedMixTimes, mixedIncubationTimes, mixedMixers, mixedIncubators}
	];

	(* get the non-mixed options and stock solution models *)
	notMixedStockSolutionModels = PickList[stockSolutionModelPackets, mixOrIncubateBools, False];
	notMixedStockSolutionModelOptions = PickList[mixOptionsByModel, mixOrIncubateBools, False];

	(* resolve the non-mixed samples' mix options (i.e., all Automatics become Null) *)
	notMixedResolvedMixOptionsPerModel = notMixedStockSolutionModelOptions /. {Automatic -> Null};

	(* get the positions of the mixed and not-mixed models *)
	mixedPositions = Position[mixOrIncubateBools, True];
	notMixedPositions = Position[mixOrIncubateBools, False];

	(* make replace rules for ReplacePart for the mixed and non-mixed resolved options we have *)
	mixedPositionReplaceRules = MapThread[#1 -> #2&, {mixedPositions, mixedResolvedMixOptionsPerModelWithProperTemp}];
	notMixedPositionReplaceRules = MapThread[#1 -> #2&, {notMixedPositions, notMixedResolvedMixOptionsPerModel}];

	(* get the resolved mix options per model *)
	resolvedMixOptionsPerModel = ReplacePart[mixOrIncubateBools, Flatten[{mixedPositionReplaceRules, notMixedPositionReplaceRules}]];

	(* get the resolved mix options as a list of rules using Merge *)
	resolvedMixOptions = Normal[Merge[resolvedMixOptionsPerModel, Join]];

	(* Return the resolved mix/incubate options along with the invalid tests and options *)
	{
		mixIncubateTimeMismatchTests,mixIncubateTimeMismatchOptions,mixIncubateInstMismatchTests,mixIncubateInstMismatchOptions,
		mixSubOptionsSetIncorrectlyTests,mixSubOptionsSetIncorrectlyOptions,incubateSubOptionsSetIncorrectlyTests,incubateSubOptionsSetIncorrectlyOptions,
		mixResolvingTests,resolvedMixOptions
	}
];


(* ::Subsubsection:: *)
(* resolveStockSolutionOptionsFormula (options) *)


DefineOptions[resolveStockSolutionOptionsFormula,
	SharedOptions :> {ExperimentStockSolution}
];


(* ::Subsubsection::Closed:: *)
(* resolveStockSolutionOptionsFormula (formula overload) *)


(* this function is only called in the Formula overload of UploadStockSolution and ExperimentStockSolution *)
(* resolves the following options: {StockSolutionName, Synonyms, LightSensitive, Expires, DiscardThreshold, ShelfLife, UnsealedShelfLife, DefaultStorageCondition,TransportTemperature, Density, ExtinctionCoefficients, Ventilated, Flammable, Acid, Base, Fuming, IncompatibleMaterials} *)
resolveStockSolutionOptionsFormula[
	myModelFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.]|Null,ObjectP[{Model[Sample],Object[Sample],Model[Molecule]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}]|Null)..},
	myFinalVolumes:{(VolumeP|Null)..},
	myUnitOperations:{({SamplePreparationP...}|Null)..},
	myResolutionOptions:OptionsPattern[resolveStockSolutionOptionsFormula]
]:=Module[
	{combinedOptions, outputSpecification, output, gatherTests, messages, fastTrack,unitOperationsQ, unitOpsSourceSamples, components, allComponentAmounts,
		componentsAndSolvents, componentAndSolventDownloadTuples, unitOpsStorageConditions, componentDownloadTuples, solventDownloadTupleOrNull,
		allComponentPackets, allComponentSCPackets, allSolventPacketsOrNulls, allSolventSCPacketsOrNulls,
		allComponentAndSolventPackets, allComponentAndSolventSCPackets, allComponentModels, specifiedNames, namesAlreadyInUse,
		namesAlreadyInUseTest, specifiedSynonymses, resolvedSynonyms, resolvedExpires, resolvedDiscardThreshold, resolvedDefaultStorageCondition,
		acid, base, acidBaseTests, resolvedLightSensitive, formulaOnlyResolvedOptions, cache, resultRule, testsRule, allComponentModelPackets,
		volumeOptionUnusedWarnings, specifiedTransportTemperature, resolvedTransportTemperature, transportTemperatureTests,
		duplicateComponentsErrors, deprecatedComponentsErrors, solventNotLiquidErrors, componentStateUnknownWarnings,
		componentStateInvalidErrors, componentAmountOutOfRangeErrors, componentRequiresTabletCountErrors,
		componentAmountInvalidErrors, formulaVolumeTooLargeErrors, duplicatedComponentInvalidInputs,
		duplicatedComponentTest, deprecatedComponentInvalidInputs, deprecatedComponentTest, solventNotLiquidInvalidInputs,
		solventNotLiquidTest, componentStateUnknownTest, componentStateInvalidPackets, componentStateInvalidInputs,
		componentStateInvalidTest, componentAmountOutOfRangeInvalidInputs, componentAmountOutOfRangeTest,
		componentRequiresTabletCountInvalidInputs, componentRequiresTabletCountTest, formulaVolumeTooLargeInvalidOptions,
		formulaVolumeTooLargeTest, namesAlreadyInUseOptions, synonymsNoNames, synonymsNoNamesOptions, synonymsNoNamesTest,
		duplicateFreeNames, duplicateNameOptions, duplicateNameTest, providedShelfLives, providedUnsealedShelfLives,
		shelfLivesSetIncorrectly, unsealedShelfLifeLonger, shelfLifeSetToNull, shelfLivesSetIncorrectlyOptions, shelfLivesSetIncorrectlyTest,
		unsealedLongerWarning, shelfLifeError, shelfLivesSetProperlyOptions, allComponentShelfLives, componentShelfLives, shelfLifeToUse, allComponentUnsealedShelfLives,
		componentUnsealedShelfLives, unsealedShelfLifeToUse, specifiedStorageConditions, allComponentDefaultStorageConditions,
		potentialStorageConditionSymbols,
		acidAndBaseQ, acidAndBaseOptions, specifiedLightSensitive, formulaVolumes, volumeOptionDifferentQ,
		resolvedIncompatibleMaterials, allTests, invalidInputs, invalidOptions, volumeOption, actualVolume,preResolvedComposition,resolvedVentilated, resolvedFlammable, resolvedFuming,multipleMultipleExpandedOptions,multipleMultipleOptionLengths,lengthToExpandTo,expandedMultipleMultipleOptions, preResolvedSafetyPacket, formulaSpecsWithPackets,
		preparableQ, volumeInvalidFillToVolume, volumeInvalidFillToVolumeInvalidOptions, volumeInvalidFillToVolumeTest,
		orderOfOperationsTest,invalidOrderOfOperationOptions,validOrderOfOperations, resolvedUltrasonicIncompatible,
		requiredOrderOfOperations, fillToVolumeMethods
		},

	(* need to expand the combined options right here because sometimes they will not be expanded already (namely, when UploadStockSolution calls this) *)
	(* calling FastTrack -> True is fine here because if we got here already we're already fine *)
	combinedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution, {myModelFormulaSpecs}, ToList[myResolutionOptions], 3, FastTrack -> True, Messages -> False]];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get FastTrack, it will control error-checks after here, and also Preparable, which also controls error checks for some of the below *)
	(* also get the Cache option *)
	{cache, fastTrack} = Lookup[combinedOptions, {Cache, FastTrack}];
	preparableQ = Lookup[combinedOptions, Preparable, True] /. {Automatic -> True};
	fillToVolumeMethods=Lookup[combinedOptions,FillToVolumeMethod];

	(* are we working based on a formula/Template or based on UnitOperations?  *)
	unitOperationsQ = MatchQ[#, {SamplePreparationP..}]&/@myUnitOperations;

	(* if we're using unit operations, we will infer the storage conditions based on the source samples, so get these *)
	unitOpsSourceSamples = MapThread[Function[{unitOpsQ, unitOps},
		If[unitOpsQ,
			DeleteDuplicates[Cases[Lookup[unitOps[[All,1]], Source], ObjectP[{Object[Sample],Model[Sample]}]]],
			{}
		]],
		{unitOperationsQ, myUnitOperations}
	];

	(* assign the indices of the formula specification to separate local variables *)
	allComponentAmounts = myModelFormulaSpecs[[All, All, 1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]};
	components = myModelFormulaSpecs[[All, All, 2]];

	(* add the solvent onto the components list for Downloading (okay if solvent is Null, Download handles that) *)
	componentsAndSolvents = MapThread[
		Append[#1, #2]&,
		{components, mySolvents}
	];

	(* download the required information from the formula components/solvent; may have a Null if the solvent is Null;
	 	Quiet is specifically for the Tablet field, which is ONLY in Model[Sample] *)
	componentAndSolventDownloadTuples = Quiet[Download[
		componentsAndSolvents,
		{
			Packet[Name,Deprecated,State,Density,DefaultStorageCondition,ShelfLife,UnsealedShelfLife,LightSensitive,Tablet, FixedAmounts, SingleUse, Resuspension, UltrasonicIncompatible, CentrifugeIncompatible, Ventilated, Flammable, Sterile, Fuming, IncompatibleMaterials, Acid, Base, Composition, Solvent],
			Packet[DefaultStorageCondition[{StorageCondition}]],
			Packet[Model]
		},
		Cache -> cache,
		Date -> Now
	],{Download::MissingField, Download::FieldDoesntExist, Download::NotLinkField}];

	(* so this is very unfortunate, but it seems like  *)
	(* get sensible local variables for our component/solvent inputs *)
	componentDownloadTuples = Most[#]& /@ componentAndSolventDownloadTuples;
	solventDownloadTupleOrNull = Last[#]& /@ componentAndSolventDownloadTuples;
	allComponentPackets = componentDownloadTuples[[All, All, 1]];
	allComponentSCPackets = componentDownloadTuples[[All, All, 2]];

	(* We have to do this because we're working with both objects and models *)
	allComponentModelPackets = componentDownloadTuples[[All,All,3]];
	allComponentModels = Map[
		Function[
			{modelPacketGroup},
			Map[
				Function[
					{modelPacket},
					If[MatchQ[Lookup[modelPacket,Model],$Failed|Null],
						Lookup[modelPacket,Object],
						First[Lookup[modelPacket,Model]]
					]
				],
				modelPacketGroup
			]
		],
		allComponentModelPackets
	];

	(* split out the solvent information if we have a solvent *)
	(* since we had to Download a third entry for samples but we don't care about that for the solvent, just get [[1]] or [[2]] *)
	allSolventPacketsOrNulls = MapThread[
		If[MatchQ[#1, ObjectP[]],
			#2[[1]],
			Null
		]&,
		{mySolvents, solventDownloadTupleOrNull}
	];
	allSolventSCPacketsOrNulls = MapThread[
		If[MatchQ[#1, ObjectP[]],
			#2[[2]],
			Null
		]&,
		{mySolvents, solventDownloadTupleOrNull}
	];

	(* for convenience, assign a variable that is ALL component/solvent packets (depending on presence of solvent) *)
	allComponentAndSolventPackets = MapThread[
		If[MatchQ[#2, PacketP[]],
			Append[#1, #2],
			#1
		]&,
		{allComponentPackets, allSolventPacketsOrNulls}
	];
	allComponentAndSolventSCPackets = MapThread[
		If[MatchQ[#2, PacketP[]],
			Append[#1, #2],
			#1
		]&,
		{allComponentSCPackets, allSolventSCPacketsOrNulls}
	];

	(* make a list of the formulas with packets instead of models*)
	formulaSpecsWithPackets = MapThread[
		Function[{amounts, packets},
			Transpose[{amounts, packets}]
		],
		{allComponentAmounts, allComponentPackets}
	];

	(* figure out if the formula is invalid via a number of methods *)
	(* all of these values output are lists of lists; if they are empty lists, then that indicates nothing is wrong with those guys*)
	(* the length of these are equal to the number of formulae provided *)
	{
		duplicateComponentsErrors,
		deprecatedComponentsErrors,
		solventNotLiquidErrors,
		(* note that here I am including the component packet and the amount *)
		componentStateUnknownWarnings,
		componentStateInvalidErrors,
		(* note that here I am including the component packet and amount rather than just the component model itself *)
		componentAmountOutOfRangeErrors,
		componentRequiresTabletCountErrors,
		(* note that here I am including the component packet, amount, and state rather than just the component *)
		componentAmountInvalidErrors,
		(* note that this is just a pair of theoretical and final volume rather than anything with the components *)
		formulaVolumeTooLargeErrors,
		(* indicates if the FillToVolume is in RangeP[$MinStockSolutionUltrasonicSolventVolume,$MaxStockSolutionComponentVolume] if we are doing FillToVolume *)
		volumeInvalidFillToVolume
	} = If[fastTrack || Not[preparableQ],
		(* if on the fast track or making a non-preparable formula, just skip all of this error checking *)
		Transpose[ConstantArray[
			{{},{},{},{},{},{},{},{},{}, {}},
			Length[myModelFormulaSpecs]
		]],
		Transpose[MapThread[
			Function[{componentModels, componentPackets, solventPacketOrNull, componentAmounts, finalVolume, unitOpsQ, fillToVolumeMethod},
				Module[
					{duplicatedComponentObjs, deprecatedComponentModels, solventNotLiquid, componentStates,
						componentIsTablet, stateUnknown, componentStateUnknown, stateInvalid, componentStateInvalid,
						fixedAliquotComponentBools, componentAmountInRangeInvalidBools, componentAmountsOutOfRange,
						componentRequiresTabletCount, componentAmountInvalidBools, componentAmountInvalid,
						prereqsForComponentVolumesTooLargeBool, theoreticalFormulaVolume, formulaVolumeTooLarge,
						volumeInvalidFillToVolume},

					(* identify any models that are duplicated; use the Objects; assign these to duplicateComponentErrors if necessary *)
					duplicatedComponentObjs = Cases[Cases[Tally[componentModels], {_, GreaterP[1]}][[All, 1]],Except[$Failed]];

					(* check if any component models are deprecated; assign these to deprecatedComponentsError if necessary *)
					deprecatedComponentModels = Select[componentPackets, TrueQ[Lookup[#, Deprecated]]&];

					(* check to make sure the solvent is liquid if specified *)
					(* this is the faster way to pattern match ObjectP[{Model[Sample, "Methanol"], Model[Sample, "Milli-Q water"]}] *)
					(* basically if the solvent is methanol or water, just assume it's liquid; something on Manifold or with caching is making things think the state of these models is Null when it obviously is not; hard coding this isn't great but it's better than forever-failing unit tests *)
					solventNotLiquid = If[
						And[
							MatchQ[solventPacketOrNull, PacketP[]],
							Not[MatchQ[Lookup[solventPacketOrNull, State], Liquid]],
							Not[MatchQ[Lookup[solventPacketOrNull, Object], Model[Sample, "id:vXl9j5qEnnRD"] | Model[Sample, "id:8qZ1VWNmdLBD"]]]
						],
						{solventPacketOrNull},
						{}
					];

					(* --- do a variety of component checks here relating to amount --- *)

					(* pull out the recorded State of this component model; also get Tablet, this will trigger us into enforcing a Count *)
					componentStates = Lookup[componentPackets, State];
					componentIsTablet = TrueQ[#]& /@ Lookup[componentPackets, Tablet];

					(* set a bool indicating if we don't even know the state of this component *)
					(* have been having recurring issues in unit tests that are not reproducible where the state is coming up as Null and NOT as Liquid for water and Methanol (or solid for Sodium Chloride).  Not sure why this is happening (probably something caching-related somewhere?) *)
					(* in any event, obviously water and methanol are liquids and sodium chloride is a solid, and so hard coding some checks here for until I can actually figure this out so we don't have infinitely failing things *)
					stateUnknown = MapThread[
						NullQ[#1] && Not[MatchQ[Lookup[#2, Object], Model[Sample, "id:vXl9j5qEnnRD"] |  Model[Sample, "id:8qZ1VWNmdLBD"] | Model[Sample, "id:BYDOjv1VA88z"]]]&,
						{componentStates, componentPackets}
					];

					(* get the components that have null state *)
					componentStateUnknown = Transpose[{
						PickList[componentPackets, stateUnknown],
						PickList[componentAmounts, stateUnknown]
					}];

					(* get the components with an invalid state (not totally sure why we need this and the above; maybe in the cases of gases or plasma (?) *)
					stateInvalid = MapThread[
						Not[MatchQ[#1, Solid | Liquid]] && Not[MatchQ[Lookup[#2, Object], Model[Sample, "id:vXl9j5qEnnRD"] |  Model[Sample, "id:8qZ1VWNmdLBD"] | Model[Sample, "id:BYDOjv1VA88z"]]]&,
						{componentStates, componentPackets}
					];

					(* get the components that have non-solid-or-liquid state *)
					componentStateInvalid = PickList[componentPackets, stateInvalid];

					(* get booleans for which components are fixed aliquots *)
					fixedAliquotComponentBools = Map[
						MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}] || TrueQ[Lookup[#, SingleUse]]&,
						componentPackets
					];

					(* figure out if the component amounts are within the range; if not, then grab those components to throw the errors below *)
					componentAmountInRangeInvalidBools = MapThread[
						Function[{componentAmount, fixedAliquotComponentBool},
							Which[
								(* if we're using nit operations, we don't care about amounts - its for ExperimentMSP to handle *)
								unitOpsQ, False,
								(* fixed aliquots are an exception and are always okay even if technically too small *)
								fixedAliquotComponentBool, False,
								(* otherwise the mass or volume need to be in the acceptable range *)
								MassQ[componentAmount], Not[MatchQ[componentAmount, RangeP[$MinStockSolutionComponentMass, $MaxStockSolutionComponentMass]]],
								VolumeQ[componentAmount], Not[MatchQ[componentAmount, RangeP[$MinStockSolutionComponentVolume, $MaxStockSolutionComponentVolume]]],
								(* if we have tablets, then we are totally fine with things and are in range *)
								True, False
							]
						],
						{componentAmounts, fixedAliquotComponentBools}
					];

					(* note that in this case in particular we are doing the component AND its amount *)
					componentAmountsOutOfRange = PickList[Transpose[{componentPackets, componentAmounts}], componentAmountInRangeInvalidBools];

					(* get the components where we need a tablet count but didn't get it *)
					componentRequiresTabletCount = MapThread[
						If[!unitOpsQ && #3 && Not[NumericQ[#2]],
							#1,
							Nothing
						]&,
						{componentPackets, componentAmounts, componentIsTablet}
					];

					(* figure out if the componet amount is valid for the state of the sample *)
					(* note that here, False means everything is fine; if we're not a solid or liquid, we already will have handled this above so don't care about it here *)
					componentAmountInvalidBools = MapThread[
						Which[
							(* for unit ops the component amount is Null by definition, so just avoid this error *)
							unitOpsQ, False,
							MatchQ[#1, Liquid], Not[VolumeQ[#3]],
							MatchQ[#1, Solid] && Not[#2], Not[MassQ[#3]],
							True, False
						]&,
						{componentStates, componentIsTablet, componentAmounts}
					];

					(* note that in this case in particular we are doing the component AND its amount AND its state *)
					componentAmountInvalid = PickList[Transpose[{componentPackets, componentAmounts, componentStates}], componentAmountInvalidBools];

					(* the sum of components specified by volume should not exceed the total volume; only yell if we have no duplicates, a legit final volume, a solvent, the amounts are valid, and we have at least one liquid in the components *)
					(* honestly though this check is messed up; if someone wanted to make a stock solution of 50 mL water and 50 mL of ethanol and FtV to 99 mL,
						that SHOULD be allowed because the density changes and the mixture of water and will be down to 97, but then it gets bumped up again when filling to volume.
						However, since 100 > 99, this would freak out.  In the future I want to pull this test out entirely.  For now though we're going to leave it *)

					(* get the prerequisites for even doing this check *)
					prereqsForComponentVolumesTooLargeBool = And[
						!unitOpsQ, (* just to make sure we don't deal with this if using unit ops, but pretty sure it doesnt mater because the amounts are Null *)
						MatchQ[duplicatedComponentObjs, {}],
						VolumeQ[finalVolume],
						Not[NullQ[solventPacketOrNull]],
						Not[AnyTrue[componentAmountInvalidBools, TrueQ]],
						MemberQ[componentAmounts, VolumeP]
					];

					(* get the formula volume for this stock solution *)
					theoreticalFormulaVolume = Total[Cases[componentAmounts, VolumeP]];

					(* if the theoretical formula volume is greater than the fill to volume volume, then get that pair; otherwise make it {} *)
					formulaVolumeTooLarge = If[prereqsForComponentVolumesTooLargeBool && theoreticalFormulaVolume >= finalVolume,
						{theoreticalFormulaVolume, finalVolume},
						{}
					];
					

					(* the FillToVolume solvent is within RangeP[$MinStockSolutionUltrasonicSolventVolume,$MaxStockSolutionComponentVolume] *)
					volumeInvalidFillToVolume = If[And[
						MatchQ[solventPacketOrNull, ObjectP[]],
						Or[
							(*we use a lower limit for the volumetric method because we have 2mL voluemtric flasks*)
							And[
								MatchQ[fillToVolumeMethod,Volumetric],
								Not[MatchQ[finalVolume, RangeP[$MinStockSolutionSolventVolume,$MaxStockSolutionComponentVolume]]]
							],
							And[
								MatchQ[fillToVolumeMethod,Ultrasonic|Automatic],
								Not[MatchQ[finalVolume, RangeP[$MinStockSolutionUltrasonicSolventVolume,$MaxStockSolutionComponentVolume]]]
							]
						]
					],
						finalVolume,
						{}
					];


					(* return everything problematic here *)
					{
						duplicatedComponentObjs,
						deprecatedComponentModels,
						solventNotLiquid,
						componentStateUnknown,
						componentStateInvalid,
						componentAmountsOutOfRange,
						componentRequiresTabletCount,
						componentAmountInvalid,
						formulaVolumeTooLarge,
						volumeInvalidFillToVolume
					}
				]

			],
			{allComponentModels, allComponentPackets, allSolventPacketsOrNulls, allComponentAmounts, myFinalVolumes, unitOperationsQ, fillToVolumeMethods}
		]]
	];

	(* make errors and tests for the invalid input checks we made above *)

	(* get the invalid objects and throw messages if necessary for duplicated components *)
	duplicatedComponentInvalidInputs = If[Not[MatchQ[Flatten[duplicateComponentsErrors], {}]] && messages,
		(
			Message[Error::DuplicatedComponents, ObjectToString[Flatten[duplicateComponentsErrors], Cache -> cache]];
			Flatten[duplicateComponentsErrors]
		),
		Flatten[duplicateComponentsErrors]
	];

	(* generate tests for if there are duplicate components *)
	duplicatedComponentTest = If[gatherTests,
		Module[{failingSamples, test},

			(* get the inputs that fail this test *)
			failingSamples = Flatten[duplicateComponentsErrors];

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test["The provided components in the input formula(s) " <> ObjectToString[failingSamples, Cache -> cache] <> " are not duplicated in the same formula:",
					False,
					True
				],
				Test["Stock solution formula(s) do not contain any duplicated model components:",
					True,
					True
				]
			]
		],
		Null
	];

	(* get the invalid objects and throw messages if necessary for deprecated components *)
	deprecatedComponentInvalidInputs = If[Not[MatchQ[Flatten[deprecatedComponentsErrors], {}]] && messages,
		(
			Message[Error::DeprecatedComponents, ObjectToString[Flatten[deprecatedComponentsErrors], Cache -> cache]];
			Flatten[deprecatedComponentsErrors]
		),
		Flatten[deprecatedComponentsErrors]
	];

	(* generate tests for if there are deprecated components *)
	deprecatedComponentTest = If[gatherTests,
		Module[{failingSamples, test},

			(* get the inputs that fail this test *)
			failingSamples = Flatten[deprecatedComponentsErrors];

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test["The provided components in the input formula(s) " <> ObjectToString[failingSamples, Cache -> cache] <> " are not deprecated:",
					False,
					True
				],
				Test["Stock solution formula(s) do not contain any deprecated model components:",
					True,
					True
				]
			]
		],
		Null
	];

	(* get the invalid solvents that aren't liquid and throw messages if necessary *)
	solventNotLiquidInvalidInputs = If[Not[MatchQ[Flatten[solventNotLiquidErrors], {}]] && messages,
		(
			Message[Error::SolventNotLiquid, ObjectToString[Flatten[solventNotLiquidErrors], Cache -> cache], Lookup[Flatten[solventNotLiquidErrors], State]];
			Flatten[solventNotLiquidErrors]
		),
		Flatten[solventNotLiquidErrors]
	];

	(* generate tests for if there are non-liquid components *)
	solventNotLiquidTest = If[gatherTests,
		Module[{failingSamples, test},

			(* get the inputs that fail this test *)
			failingSamples = Flatten[solventNotLiquidErrors];

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test["The provided solvents " <> ObjectToString[failingSamples, Cache -> cache] <> " are liquid:",
					False,
					True
				],
				Test["The provided solvents are liquid:",
					True,
					True
				]
			]
		],
		Null
	];

	(* throw a warning if a component state is unknown *)
	If[Not[MatchQ[Flatten[componentStateUnknownWarnings], {}]] && messages,
		Message[Warning::ComponentStateUnknown, ObjectToString[Flatten[componentStateUnknownWarnings[[All, All, 1]]], Cache -> cache], Flatten[componentStateUnknownWarnings[[All, All, 2]]]]
	];

	(* generate a warning test if a component state is unknown *)
	componentStateUnknownTest = If[gatherTests,
		Module[{failingSamples, failingAmounts, test},

			(* get the inputs and amounts that fail this test *)
			failingSamples = Flatten[componentStateUnknownWarnings[[All, All, 1]]];
			failingAmounts = Flatten[componentStateUnknownWarnings[[All, All, 2]]];

			(* component state unknown test *)
			test = If[Length[failingSamples] > 0,
				Warning["Component(s) " <> ObjectToString[failingSamples, Cache -> cache] <> " have a recorded State for validation of component amount(s) " <> ObjectToString[failingAmounts, Cache -> cache] <> ":",
					False,
					True
				],
				Warning["All components have a recorded State for validation of component amount:",
					True,
					True
				]
			]
		],
		Null
	];

	(* get the samples where the component does not have a legit state (do some logic to not overlap with the warning above) *)
	componentStateInvalidPackets = Flatten[DeleteCases[componentStateInvalidErrors, Alternatives @@ (Flatten[componentStateUnknownWarnings[[All, All, 1]]])]];

	(* throw an error if we have component states that are invalid *)
	componentStateInvalidInputs = If[Not[MatchQ[componentStateInvalidPackets, {}]] && messages,
		(
			Message[Error::ComponentStateInvalid, ObjectToString[componentStateInvalidPackets, Cache -> cache], Lookup[componentStateInvalidPackets, State]];
			componentStateInvalidPackets
		),
		componentStateInvalidPackets
	];

	(* generate tests for if the component state is invalid *)
	componentStateInvalidTest = If[gatherTests,
		Module[{failingSamples, test},

			(* get the inputs that fail this test *)
			failingSamples = componentStateInvalidInputs;

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test["The provided component(s) " <> ObjectToString[failingSamples, Cache -> cache] <> " are solid or liquid:",
					False,
					True
				],
				Test["The provided component(s) are liquid or solid:",
					True,
					True
				]
			]
		],
		Null
	];

	(*throw an error if we have components that are out of range*)
	componentAmountOutOfRangeInvalidInputs = If[Not[MatchQ[Flatten[componentAmountOutOfRangeErrors], {}]] && messages,
		(
			Message[Error::ComponentAmountOutOfRange, ObjectToString[Flatten[componentAmountOutOfRangeErrors[[All, All, 1]]], Cache -> cache], ObjectToString[Flatten[componentAmountOutOfRangeErrors[[All, All, 2]]]], ToString[UnitForm[$MinStockSolutionComponentMass, Brackets -> False]], ToString[UnitForm[$MaxStockSolutionComponentMass, Brackets -> False]], ToString[UnitForm[$MinStockSolutionComponentVolume, Brackets -> False]], ToString[UnitForm[$MaxStockSolutionComponentVolume, Brackets -> False]]];
			Flatten[componentAmountOutOfRangeErrors[[All, All, 1]]]
		),
		Flatten[componentAmountOutOfRangeErrors[[All, All, 1]]]
	];

	(* generate tests for if the component amounts are too big or too small *)
	componentAmountOutOfRangeTest = If[gatherTests,
		Module[{failingSamples, failingAmounts, test},

			(* get the inputs that fail this test *)
			failingSamples = Flatten[componentAmountOutOfRangeErrors[[All, All, 1]]];
			failingAmounts = Flatten[componentAmountOutOfRangeErrors[[All, All, 2]]];

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test[
					StringJoin[
						"The specified amount(s) for component(s) ",
						ObjectToString[failingSamples, Cache -> cache],
						" do not fall outside the range that ensures accurate component transfers can be achieved: ",
						ToString[UnitForm[$MinStockSolutionComponentMass, Brackets -> False]],
						" to ",
						ToString[UnitForm[$MaxStockSolutionComponentMass, Brackets -> False]],
						" for solids, and ",
						ToString[UnitForm[$MinStockSolutionComponentVolume, Brackets -> False]],
						" to ",
						ToString[UnitForm[$MaxStockSolutionComponentVolume, Brackets -> False]],
						" for liquids:"
					],
					False,
					True
				],
				Test[
					StringJoin[
						"The specified amount(s) for all component(s) do not fall outside the range that ensures accurate component transfers can be achieved: ",
						ToString[UnitForm[$MinStockSolutionComponentMass, Brackets -> False]],
						" to ",
						ToString[UnitForm[$MaxStockSolutionComponentMass, Brackets -> False]],
						" for solids, and ",
						ToString[UnitForm[$MinStockSolutionComponentVolume, Brackets -> False]],
						" to ",
						ToString[UnitForm[$MaxStockSolutionComponentVolume, Brackets -> False]],
						" for liquids:"
					],
					True,
					True
				]
			]
		],
		Null
	];

	(* throw an error if we have components that must be tablets *)
	componentRequiresTabletCountInvalidInputs = If[Not[MatchQ[Flatten[componentRequiresTabletCountErrors], {}]] && messages,
		(
			Message[Error::ComponentRequiresTabletCount, ObjectToString[Flatten[componentRequiresTabletCountErrors], Cache -> cache]];
			Flatten[componentRequiresTabletCountErrors]
		),
		Flatten[componentRequiresTabletCountErrors]
	];

	(* generate tests if we have components that must be tablets *)
	componentRequiresTabletCountTest = If[gatherTests,
		Module[{failingSamples, test},

			(* get the inputs that fail this test *)
			failingSamples = componentRequiresTabletCountInvalidInputs;

			(* duplicate component test *)
			test = If[Length[failingSamples] > 0,
				Test["The provided tablet component(s) " <> ObjectToString[failingSamples, Cache -> cache] <> " have been provided with an amount that is a count of tablets:",
					False,
					True
				],
				Test["All provided component(s) that are tablets have been provided with an amount that is an integer count:",
					True,
					True
				]
			]
		],
		Null
	];

	(* throw an error if the formula volume is too large *)
	(* note that it isn't _really the Volume option that is the problem here; it is the Volume input, but that makes the message text weird so we're not doing that here *)
	formulaVolumeTooLargeInvalidOptions = If[Not[MatchQ[Flatten[formulaVolumeTooLargeErrors], {}]] && messages,
		(
			Message[Error::FormulaVolumeTooLarge, Flatten[formulaVolumeTooLargeErrors[[All, 1]]], Flatten[formulaVolumeTooLargeErrors[[All, 2]]]];
			{Volume}
		),
		{}
	];

	(* generate tests if the component amount is invalid *)
	formulaVolumeTooLargeTest = If[gatherTests,
		Module[{failingTheoreticalVolume, failingSpecifiedVolume, test},

			(* duplicate component test *)
			test = If[Length[Flatten[formulaVolumeTooLargeErrors]] > 0,
				(* get the inputs that fail this test *)
				failingTheoreticalVolume = Flatten[formulaVolumeTooLargeErrors[[All, 1]]];
				failingSpecifiedVolume = Flatten[formulaVolumeTooLargeErrors[[All, 2]]];
				Test["The provided volume(s) " <> ObjectToString[failingSpecifiedVolume] <> " are greater than or equal to the sum of the liquid component(s) " <> ObjectToString[failingTheoreticalVolume] <>  " for all inputs:",
					False,
					True
				],
				Test["The provided volume(s) are greater than or equal to the sum of the liquid component(s) for all inputs:",
					True,
					True
				]
			]
		],
		Null
	];

	(* throw an error if the solvent volume is not in RangeP[$MinStockSolutionUltrasonicSolventVolume, $MaxStockSolutionComponentVolume] *)
	volumeInvalidFillToVolumeInvalidOptions = If[Not[MatchQ[Flatten[volumeInvalidFillToVolume], {}]] && messages,
		(
			Message[Error::BelowFillToVolumeMinimum, "the input(s)", Flatten[volumeInvalidFillToVolume], $MinStockSolutionUltrasonicSolventVolume];
			{Volume}
		),
		{}
	];

	(* generate tests if the component amount is invalid *)
	volumeInvalidFillToVolumeTest = If[gatherTests,
		Module[{test},

			(* duplicate component test *)
			test = If[Length[Flatten[volumeInvalidFillToVolume]] > 0,
				Test["The provided solvent volume(s) " <> ObjectToString[Flatten[volumeInvalidFillToVolume]] <> " within the allowed range of fill-to-volume solvents, " <> ObjectToString[$MinStockSolutionUltrasonicSolventVolume] <>  " to " <> ObjectToString[$MaxStockSolutionSolventVolume] <> " for all inputs:",
					False,
					True
				],
				Test["The provided solvent volume(s) are within the allowed range of fill-to-volume solvents, " <> ObjectToString[$MinStockSolutionUltrasonicSolventVolume] <>  " to " <> ObjectToString[$MaxStockSolutionSolventVolume] <> " for all inputs:",
					True,
					True
				]
			]
		],
		Null
	];

	(* --- Resolve Formula-only stock solution options --- *)

	(* pull out the specified name and synonyms options for the stock solution *)
	{specifiedNames, specifiedSynonymses} = Lookup[combinedOptions, {StockSolutionName, Synonyms}];

	(* Check to make sure the stock solution name doesn't already exist *)
	namesAlreadyInUse = If[Not[fastTrack] && Not[MatchQ[specifiedNames, {Null..}]],
		Module[{namesAndUUIDs, inUseNames},

			(* replace all the Nulls for the names specified with UUIDs *)
			namesAndUUIDs = specifiedNames /. {Null -> CreateUUID[]};

			(* get the names that are already InUse *)
			inUseNames = PickList[specifiedNames, DatabaseMemberQ[Model[Sample, StockSolution, #]& /@ namesAndUUIDs]]
		],

		(* on fast track, just blast through *)
		{}
	];

	(* throw an error if there are names already in use *)
	namesAlreadyInUseOptions = If[Not[fastTrack] && Not[MatchQ[namesAlreadyInUse, {}]] && messages,
		(
			Message[Error::StockSolutionNameInUse, namesAlreadyInUse];
			{StockSolutionName}
		),
		{}
	];

	(* make tests for if the name is already in use *)
	namesAlreadyInUseTest = If[gatherTests,
		Module[{failingNames, test},

			(* get the inputs that fail this test *)
			failingNames = namesAlreadyInUse;

			(* duplicate component test *)
			test = If[Length[failingNames] > 0,
				Test["The provided name(s) " <> failingNames <> " are not already in use by existing stock solution model(s):",
					False,
					True
				],
				Test["The provided names(s) are not already in use by existing stock solution model(s):",
					True,
					True
				]
			]
		]
	];

	(* get the synonyms that are specified without a name *)
	synonymsNoNames = MapThread[
		If[NullQ[#1] && MatchQ[#2, {__String}],
			#2,
			Nothing
		]&,
		{specifiedNames, specifiedSynonymses}
	];

	(* throw an error if there are synonyms but no names *)
	synonymsNoNamesOptions = If[Not[fastTrack] && Not[MatchQ[synonymsNoNames, {}]] && messages,
		(
			Message[Error::SynonymsNoName, synonymsNoNames];
			{StockSolutionName, Synonyms}
		),
		{}
	];

	(* make a test for synonyms *)
	synonymsNoNamesTest = If[gatherTests,
		Module[{failingSynonyms, test},

			(* get the inputs that fail this test *)
			failingSynonyms = synonymsNoNames;

			(* duplicate component test *)
			test = If[Length[failingSynonyms] > 0,
				Test["The Synonyms option is specified only if a StockSolutionName is specified for the following synonym(s): " <> failingSynonyms,
					False,
					True
				],
				Test["The Synonyms option is specified only if a StockSolutionName is specified:",
					True,
					True
				]
			]
		]
	];

	(* resolve the Synonyms option; put in the resolved name if Automatic, or if list of strings, take that; add the StockSolutionName automatically anyways unless already there;
	 	if they gave Synonyms but no name, encourage to put in StockSolutionName *)
	resolvedSynonyms = MapThread[
		Function[{name, synonyms},
			Which[
				MatchQ[synonyms, Automatic | Null] && MatchQ[name, _String], {name},
				MatchQ[synonyms, Automatic | Null], Null,
				(* need to remove the Nulls specificaly in cases where we already have the SynonymsNoName error *)
				MatchQ[synonyms, {__String}] && Not[MemberQ[synonyms, name]], DeleteCases[Prepend[synonyms, name], Null],
				MatchQ[synonyms, {__String}], synonyms,
				Trye, synonyms

			]
		],
		{specifiedNames, specifiedSynonymses}
	];

	(* make sure there are no duplicates in the StockSolutionName option *)
	duplicateFreeNames = DuplicateFreeQ[DeleteCases[specifiedNames, Null]];

	(* throw an error if there duplicates in the StockSolutionName option *)
	duplicateNameOptions = If[Not[fastTrack] && Not[duplicateFreeNames] && messages,
		(
			Message[Error::DuplicateNames];
			{StockSolutionName}
		),
		{}
	];

	(* make a test for the duplicate names *)
	duplicateNameTest = If[gatherTests,
		Test["The StockSolutionName option does not have duplicates specified:",
			duplicateFreeNames,
			True
		],
		Null
	];

	(* Automatic defaults based on component shelf lives; make sure we don't have conflict of Expires->False but ShelfLife/UnsealedShelfLife set explicitly *)
	resolvedExpires = Lookup[combinedOptions, Expires] /. {Automatic -> True};

	(* Automatic defaults to 5 Percent if we don't have anything yet *)
	resolvedDiscardThreshold = Lookup[combinedOptions, DiscardThreshold] /. {Automatic -> 5 Percent};

	(* assign the initially-provided ShelfLife/UnsealedShelfLife options *)
	{providedShelfLives, providedUnsealedShelfLives} = Lookup[combinedOptions, {ShelfLife, UnsealedShelfLife}];

	(* get a boolean indicating if the shelf lives have been set incorrectly, and if UnsealedShelfLife is longer than ShelfLife *)
	{
		shelfLivesSetIncorrectly,
		unsealedShelfLifeLonger,
		shelfLifeSetToNull
	} = Transpose[MapThread[
		Function[{expires, shelfLife, unsealedShelfLife},
			{
				(* if the user says the things don't expire but set the shelf life/unsealed shelf life, then this is True *)
				MatchQ[expires, False] && (TimeQ[shelfLife] || TimeQ[unsealedShelfLife]),
				(* if both unsealed shelf life and shelf life are set but unsealed is longer, then this is True *)
				TimeQ[shelfLife] && TimeQ[unsealedShelfLife] && unsealedShelfLife > shelfLife,
				(* Both ShelfLife and UnsealedShelfLife must be set if the stock solution expires *)
				MatchQ[expires, True] && (NullQ[shelfLife] || NullQ[unsealedShelfLife])
			}
		],
		{resolvedExpires, providedShelfLives, providedUnsealedShelfLives}
	]];

	(* throw a message if the shelf lives are set incorrectly *)
	shelfLivesSetIncorrectlyOptions = If[Not[fastTrack] && MemberQ[shelfLivesSetIncorrectly, True] && messages,
		(
			Message[Error::ExpirationShelfLifeConflict];
			{Expires, ShelfLife, UnsealedShelfLife}
		),
		{}
	];

	(* make a test for the above check *)
	shelfLivesSetIncorrectlyTest = If[gatherTests,
		Test["ShelfLife and UnsealedShelfLife are only set if Expires is set to True:",
			MemberQ[shelfLivesSetIncorrectly, True],
			False
		],
		Null
	];

	(* throw a warning if unsealed shelf life is longer than shelf life *)
	If[Not[fastTrack] && MemberQ[unsealedShelfLifeLonger, True] && messages,
		Message[Warning::UnsealedShelfLifeLonger, PickList[providedUnsealedShelfLives, unsealedShelfLifeLonger], PickList[providedShelfLives, unsealedShelfLifeLonger]]
	];

	(* make a test for the above check *)
	unsealedLongerWarning = If[gatherTests,
		Warning["If both UnsealedShelfLife and ShelfLife are provided, ShelfLife is longer than UnsealedShelfLife:",
			MemberQ[unsealedShelfLifeLonger, True],
			False
		],
		Null
	];
	
	(* throw a warning if unsealed shelf life is set but shelf life is not *)
	shelfLivesSetProperlyOptions = If[Not[fastTrack] && MemberQ[shelfLifeSetToNull, True] && messages,
		(
			Message[Error::ShelfLifeNotSpecified];
			{ShelfLife, UnsealedShelfLife}
		),
		{}
	];

	(* make a test for the above check *)
	shelfLifeError = If[gatherTests,
		Test["If Expires is True, both ShelfLife and UnsealedShelfLife cannot be Null:",
			MemberQ[shelfLifeSetToNull, True],
			False
		],
		Null
	];

	(* get the shelf lives for all the components (including solvent if any); default to 5 year if none present *)
	allComponentShelfLives = Map[
		Cases[Lookup[#, ShelfLife], TimeP]&,
		allComponentAndSolventPackets
	];
	componentShelfLives = Map[
		If[MatchQ[#, {TimeP..}],
			UnitScale[Min[#]],
			5 Year
		]&,
		allComponentShelfLives
	];

	(* resolve the shelf life to use based on whether it expires or not *)
	shelfLifeToUse = MapThread[
		Function[{expires, providedValue, componentValue},
			If[expires,
				providedValue /. {Automatic -> componentValue},
				providedValue /. {Automatic -> Null}
			]
		],
		{resolvedExpires, providedShelfLives, componentShelfLives}
	];

	(* do the same as above for the UnsealedShelfLife expect go to Null instead of 5 years since we'll reconcile it with the shelf life below anyway *)
	allComponentUnsealedShelfLives = Map[
		Cases[Lookup[#, UnsealedShelfLife], TimeP]&,
		allComponentAndSolventPackets
	];
	componentUnsealedShelfLives = Map[
		If[MatchQ[#, {TimeP..}],
			UnitScale[Min[#]],
			Null
		]&,
		allComponentUnsealedShelfLives
	];

	(* resolve the unsealed shelf life to use based on whether it expires or not and what the shelf life is *)
	unsealedShelfLifeToUse = MapThread[
		Function[{expires, providedValue, componentValue, resolvedShelfLife},
			Which[
				expires && TimeQ[componentValue],
				providedValue /. {Automatic -> Min[DeleteCases[{resolvedShelfLife, componentValue},Null]]},
				expires && TimeQ[resolvedShelfLife],
				providedValue /. {Automatic -> resolvedShelfLife},
				True,
				providedValue /. {Automatic -> Null}
			]
		],
		{resolvedExpires, providedUnsealedShelfLives, componentUnsealedShelfLives, shelfLifeToUse}
	];

	(* get the specified storage conditions *)
	specifiedStorageConditions = Lookup[combinedOptions, DefaultStorageCondition];

	(* get the storage condition symbols of all the components; be a bit paranoid in case of deprecated stuff, maybe doesn't have SC *)
	allComponentDefaultStorageConditions = Map[
		Lookup[Cases[#, PacketP[]], StorageCondition]&,
		allComponentAndSolventSCPackets
	];

	(* get what we _would_ resolve to if specified storage condition is automatic *)
	(* don't freeze if not asked; just do Refrigerator if we have things colder than refrigerator *)
	potentialStorageConditionSymbols = Map[
		If[MemberQ[#, Refrigerator | Freezer | DeepFreezer | CryogenicStorage],
			Refrigerator,
			AmbientStorage
		]&,
		allComponentDefaultStorageConditions
	];

	(* get the resolved default storage condition *)
	resolvedDefaultStorageCondition = MapThread[
		If[MatchQ[#1, SampleStorageTypeP | Disposal | ObjectP[Model[StorageCondition]]],
			#1,
			#2
		]&,
		{specifiedStorageConditions, potentialStorageConditionSymbols}
	];

	(* pull out the specified TransportTemperature option *)
	specifiedTransportTemperature = Lookup[combinedOptions, TransportTemperature];

	(* Automatic resolves based on the resolvedDefaultStorageCondition and TransportTemperature options *)
	resolvedTransportTemperature = MapThread[
		Function[{transportTemp, storageCondition},
			Which[
				MatchQ[transportTemp,Except[Automatic]], transportTemp,
				MatchQ[storageCondition, Refrigerator], 4 Celsius,
				MatchQ[storageCondition,Freezer], -20 Celsius,
				MatchQ[storageCondition, DeepFreezer | CryogenicStorage], -80 Celsius,
				MatchQ[storageCondition, AmbientStorage], Null,
				True, Null
			]
		],
		{specifiedTransportTemperature, resolvedDefaultStorageCondition}
	];

	(* pull out the specified LightSensitive option *)
	specifiedLightSensitive = Lookup[combinedOptions, LightSensitive];

	(* Automatic defaults based on component light sensitivity *)
	resolvedLightSensitive = MapThread[
		If[BooleanQ[#2],
			#2,
			MemberQ[Lookup[#1, LightSensitive], True]
		]&,
		{allComponentAndSolventPackets, specifiedLightSensitive}
	];

	(* determine the volumes of solutions that will be prepared; be aware that the formula may have only solids (and since Total[{}] returns 0 and not 0 Liter, we need to account for this manually *)
	(* NOTE: if we have liquid components transferred by mass, we need to calculate the volumes *)
	formulaVolumes = MapThread[
		Function[{finalVolume, componentAmounts, allComponentPacket},
			Module[{density,calculatedVolumeList},
				density=Lookup[allComponentPacket,Density];
				calculatedVolumeList=Join[Cases[componentAmounts, VolumeP],Cases[componentAmounts/(density), VolumeP]];
				Which[
					VolumeQ[finalVolume], finalVolume,
					VolumeQ[Total[calculatedVolumeList]], Total[calculatedVolumeList],
					True, 0 Liter
				]
			]
		],
		{myFinalVolumes, allComponentAmounts, allComponentPackets}
	];

	(* if the Volume option isn't given to us, make it be Null *)
	volumeOption = If[MissingQ[Lookup[combinedOptions, Volume]],
		ConstantArray[Null, Length[myModelFormulaSpecs]],
		Lookup[combinedOptions, Volume]
	];

	(* figure out if the volume option is the same as the formula volumes *)
	volumeOptionDifferentQ = MapThread[
		Function[{formulaVol, volOption},
			VolumeQ[volOption] && Not[TrueQ[formulaVol == volOption]]
		],
		{formulaVolumes, volumeOption}
	];

	(* throw a warning if the volume option is different from the specified volume *)
	If[Not[fastTrack] && MemberQ[volumeOptionDifferentQ, True] && Not[MatchQ[$ECLApplication, Engine]] && messages,
		Message[Warning::VolumeOptionUnused, ToString[PickList[volumeOption, volumeOptionDifferentQ]], ToString[PickList[formulaVolumes, volumeOptionDifferentQ]]]
	];

	(* make a warning communicating that Volume option will be ignored *)
	volumeOptionUnusedWarnings = If[gatherTests,
		Warning["The Volume option, if specified, equals the volume of the stock solution to prepare according to the provided formula or fill-to volume. If the Volume option does not match the formula's volume, the Volume option will be unused.",
			MemberQ[volumeOptionDifferentQ, True],
			False
		],
		Null
	];

	(* get the actual volume that will be used *)
	actualVolume = MapThread[
		If[#1, #2, #3]&,
		{volumeOptionDifferentQ, formulaVolumes, volumeOption}
	];

	(* call UploadSampleTransfer to resolve safety options *)
	(* Use flattenFormula in USS: a helper function which simulates Transfer and output Composition and safety info packet *)
	(* we quiet the download message to avoid it when calling UploadSamlpeTransfer with a no-model sample *)
	{preResolvedComposition,preResolvedSafetyPacket}=Transpose@MapThread[
		(* don't use flattenFormula this if you are using unit ops.. *)
		If[!#4,
			Quiet[
				flattenFormula[
					#1,
					#2,
					#3,
					(* the last input is used to pass-in cache to the helper *)
					Cases[FlattenCachePackets[{cache}], PacketP[]]
				],{Download::ObjectDoesNotExist}
			],
			Module[
				{
					simulatedSamplePackets, labelOfInterest,simulatedContainer,simulatedSampleComposition,sanitizedSimulatedSampleComposition,
					allEHSFields,simulatedSamples,safetyPacket, updatedSimulation
				},
				(* so this is very unfortunate, because at this point we've already simulated the sample, but we're going to do it again to get the composition and safety *)
				(*simulate*)
				simulatedSamplePackets =ExperimentManualSamplePreparation[#5, Output -> Simulation, Simulation->Null, Cache->If[!MatchQ[cache, Missing[___]],cache,{Null}]];
				(*get the first label container unit operation,it should be the very first*)
				labelOfInterest = First[Cases[#5, _LabelContainer]][Label];
				(*figure out what is the container that was simulated for it and whats in it*)
				simulatedContainer =Lookup[Lookup[First[simulatedSamplePackets], Labels],labelOfInterest];
				updatedSimulation = stockSolutionCreateDummySamples[simulatedContainer, simulatedSamplePackets];
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
				{sanitizedSimulatedSampleComposition,{safetyPacket}}
			]
		]&,{formulaSpecsWithPackets,allSolventPacketsOrNulls,myFinalVolumes,unitOperationsQ,myUnitOperations}
	];

	(* when using unit ops, the safety packets have an extra list on them.. so clean that up *)
	preResolvedSafetyPacket = MapThread[
		If[#1,
			Flatten[#2, 1],
			#2
		]&,
		{unitOperationsQ, preResolvedSafetyPacket}
	];

	(* make sure Acid and Base are not BOTH set to True (that's not a thing, acids and bases stored separately); default these to False; only still Automatic if no Template provided;
	 defaulting Null to False also since if we got a template default, False is Null in the field *)
	(* resolve Acid *)
	acid = MapThread[
		If[MatchQ[#1, Except[Automatic]],
			#1,
			#2
		]&,
		{
			Lookup[combinedOptions, Acid],
			Lookup[preResolvedSafetyPacket, Acid, False]/.{Null->False}
		}
	];

	(* resolve base *)
	base = MapThread[
		If[MatchQ[#1, Except[Automatic]],
			#1,
			#2
		]&,
		{
			Lookup[combinedOptions, Base],
			Lookup[preResolvedSafetyPacket, Base, False]/.{Null->False}
		}
	];

	(* get boolean for if acid and base are both true *)
	acidAndBaseQ = MapThread[
		TrueQ[#1 && #2]&,
		{acid, base}
	];

	(* throw a message if we have both Acid and Base at the same time *)
	acidAndBaseOptions = If[Not[fastTrack] && MemberQ[acidAndBaseQ, True] && messages,
		(
			Message[Error::AcidBaseConflict];
			{Acid, Base}
		),
		{}
	];

	(* make a test for the above case *)
	acidBaseTests = If[gatherTests,
		Test["Acid and Base are not both set to True, as dedicated acid and base secondary containments are separate.",
			MemberQ[acidAndBaseQ, True],
			False
		],
		Null
	];

	(* get the resolved ventilated *)
	resolvedVentilated = MapThread[
		If[MatchQ[#1, Except[Automatic]],
			#1,
			#2
		]&,
		{
			Lookup[combinedOptions, Ventilated],
			Lookup[preResolvedSafetyPacket, Ventilated, False]/.{Null->False}
		}
	];

	(* get the resolved flammable *)
	resolvedFlammable = MapThread[
		If[MatchQ[#1, Except[Automatic]],
			#1,
			#2
		]&,
		{
			Lookup[combinedOptions, Flammable],
			Lookup[preResolvedSafetyPacket, Flammable, False]/.{Null->False}
		}
	];

	(* get the resolved fuming *)
	resolvedFuming = MapThread[
		If[MatchQ[#1, Except[Automatic]],
			#1,
			#2
		]&,
		{
			Lookup[combinedOptions, Fuming],
			Lookup[preResolvedSafetyPacket, Fuming, False]/.{Null->False}
		}
	];

	(* get the resolved incompatible materials option *)
	(* the IncompatibleMaterials field are multiple-multiple. Got expanded it if it is not expanded yet *)
	(* get the multiple multiple options *)
	multipleMultipleExpandedOptions = {
		IncompatibleMaterials
	};

	(* get the length of the multiple multiple options for each entry *)
	(* 0 means the options aren't nested yet *)
	multipleMultipleOptionLengths = Map[
		Function[{option},
			If[Not[ListQ[First[Lookup[combinedOptions, option]]]],
				ConstantArray[0, Length[myModelFormulaSpecs]],
				If[Not[ListQ[#]], 0, Length[#]]& /@ Lookup[combinedOptions, option]
			]
		],
		multipleMultipleExpandedOptions
	];

	(* get the length to expand to *)
	lengthToExpandTo = Map[
		If[Max[#] == 0,
			(* if _none_ of the options are specified as multiple multiple, just assume length 1; we can change this later if we want *)
			1,
			Max[#]
		]&,
		Transpose[multipleMultipleOptionLengths]
	];

	(* expand the options *)
	expandedMultipleMultipleOptions = MapThread[
		Function[{optionName, optionValue},
			Module[{semiExpandedOptionValue, expandedOptionValue},

				(* if a true singleton expand this to be index matching with samples; if it is Automatic, keep it as it is *)
				semiExpandedOptionValue = If[Not[ListQ[First[optionValue]]]&&Not[MatchQ[optionValue,{Automatic..}]], ConstantArray[optionValue, Length[myModelFormulaSpecs]], optionValue];

				(* expand the option if it's not expanded already *)
				expandedOptionValue = optionName->MapThread[
					If[ListQ[#1] || MatchQ[#1, Automatic],
						#1,
						ConstantArray[#1, #2]
					]&,
					{semiExpandedOptionValue, lengthToExpandTo}
				];

				expandedOptionValue
			]
		],
		{multipleMultipleExpandedOptions, Lookup[combinedOptions, multipleMultipleExpandedOptions]}
	];


	resolvedIncompatibleMaterials = MapThread[Function[{multipleMultiple, safetyPacketFlattenFormula, safetyPacketUniqOps, unitOpsQ},
		Which[
			(* could in theory be {None}, but that should just be Null for these purposes *)
			MatchQ[multipleMultiple, {None}],
			Null,
			(* if user gives us one, use it *)
			MatchQ[multipleMultiple, Except[Automatic]],
			multipleMultiple,
			(* otherwise, use the pre-resolved value *)
			True, If[unitOpsQ, safetyPacketUniqOps, safetyPacketFlattenFormula]
		]],
		{
			Lookup[expandedMultipleMultipleOptions, IncompatibleMaterials],
			Lookup[preResolvedSafetyPacket, Replace[IncompatibleMaterials], {None}],
			Lookup[preResolvedSafetyPacket, IncompatibleMaterials, {None}],
			unitOperationsQ
		}
	];

	(* Define a required order of operations for the last few *)
	requiredOrderOfOperations[FixedReagentAddition,Filtration]:=True;
	requiredOrderOfOperations[Filtration,FixedReagentAddition]:=False;
	requiredOrderOfOperations[FillToVolume,Filtration]:=True;
	requiredOrderOfOperations[Filtration,FillToVolume]:=False;
	requiredOrderOfOperations[pHTitration,Filtration]:=True;
	requiredOrderOfOperations[Filtration,pHTitration]:=False;
	requiredOrderOfOperations[Incubation,Filtration]:=True;
	requiredOrderOfOperations[Filtration,Incubation]:=False;
	requiredOrderOfOperations[Filtration,Autoclave]:=True;
	requiredOrderOfOperations[Autoclave,Filtration]:=False;
	requiredOrderOfOperations[Autoclave,FixedHeatSensitiveReagentAddition]:=True;
	requiredOrderOfOperations[FixedHeatSensitiveReagentAddition,Autoclave]:=False;
	requiredOrderOfOperations[FixedHeatSensitiveReagentAddition,PostAutoclaveIncubation]:=True;
	requiredOrderOfOperations[PostAutoclaveIncubation,FixedHeatSensitiveReagentAddition]:=False;

	(* Make sure that the OrderOfOperations given is valid - if we're running unit operations, just skip this because its irrelevant. *)
	validOrderOfOperations=Or[
		And@@unitOperationsQ,
		And@@Map[
			Function[{singleOrderOfOperations},
				If[MatchQ[singleOrderOfOperations,Automatic|{}|Null],
					True,
					And[
						(* There's at least 1 element. *)
						Length[singleOrderOfOperations] > 0,

						(* The first element is FixedReagentAddition. *)
						MatchQ[FirstOrDefault[singleOrderOfOperations, Null], FixedReagentAddition],

						(* Incubate is after FillToVolume and/or pHTitration, if it shows up. *)
						Or[
							(* if it doesn't show up, then that's fine *)
							Not[MemberQ[singleOrderOfOperations, Incubation]],
							(* if it does show up, then FillToVolume and/or pHTitration must be first and not after it *)
							MemberQ[singleOrderOfOperations, Incubation] && MatchQ[singleOrderOfOperations, {FixedReagentAddition, Repeated[FillToVolume | pHTitration, {0, 1}], Repeated[FillToVolume | pHTitration, {0, 1}], Incubation, Except[Incubation | pHTitration | FillToVolume] ...}]
						],

						(* We are properly in our custom order *)
						OrderedQ[singleOrderOfOperations,requiredOrderOfOperations],

						(* Steps cannot be duplicated. *)
						MatchQ[singleOrderOfOperations, DeleteDuplicates[singleOrderOfOperations]]
					]
				]
			],
			Lookup[combinedOptions, OrderOfOperations, {{}}]
		]
	];

	invalidOrderOfOperationOptions=If[!MatchQ[validOrderOfOperations, True],
		If[!gatherTests,
			Message[Error::InvalidOrderOfOperations];
		];

		OrderOfOperations,
		{}
	];

	orderOfOperationsTest=If[!validOrderOfOperations && gatherTests,
		{},
		Warning["The OrderOfOperations given is supported by ExperimentStockSolution:",validOrderOfOperations,True]
	];

	(* UltrasonicIncompatible resolves based on whether 50% or more of the volume is comprised of the UltrasonicIncompatible components *)
 	(* note that UltrasonicIncompatible is not actually an option to ExperimentStockSolution and so it's not getting passed in here so we are kind of fake-resolving it here *)
	resolvedUltrasonicIncompatible = MapThread[
		Function[{formula, solventPacket, finalVolume},
			Module[
				{ultrasonicIncompatibleFormula, expectedSolventVolume, solventUltrasonicIncompatibleQ,
					ultrasonicIncompatibleVolume, ultrasonicIncompatibleRatio, componentAmounts, effectiveStockSolutionVolume},

				(* get the Formula entries for UltrasonicIncompatible items *)
				ultrasonicIncompatibleFormula = Select[formula, TrueQ[Lookup[#[[2]], UltrasonicIncompatible]] && VolumeQ[#[[1]]]&];

				(* get the component amounts *)
				componentAmounts = formula[[All, 1]];

				(* set the effective volume of this solution; the fill-to volume if we have it, or the sum of volume components (be conscious that we might have a messed up formula without any volumes) *)
				effectiveStockSolutionVolume = Which[
					MatchQ[finalVolume, VolumeP], finalVolume,
					MemberQ[componentAmounts, VolumeP], Total[Cases[componentAmounts, VolumeP]],
					True, 1 Liter
				];

				(* get the expected FillToVolumeSolvent volume *)
				expectedSolventVolume = If[NullQ[solventPacket],
					0,
					finalVolume - Total[Cases[componentAmounts,VolumeP]]
				];

				(* figure out if the solvent is UltrasonicIncompatible *)
				solventUltrasonicIncompatibleQ = If[NullQ[solventPacket],
					False,
					TrueQ[Lookup[solventPacket, UltrasonicIncompatible]]
				];

				(* get the total volume of the UltrasonicIncompatible components; need to account for the FillToVolumeSolvent if that is a factor *)
				(* doing the ReplaceAll converting 0 to 0*Milliliter because that will make the math below work and Total[{}] will just be 0 and not have units *)
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
		],
		{formulaSpecsWithPackets, allSolventPacketsOrNulls, myFinalVolumes}
	];

	(* get the resolved options that are only allowed to be directly specified for the formula overload *)
	formulaOnlyResolvedOptions = {
		StockSolutionName->specifiedNames,
		Synonyms -> resolvedSynonyms,
		LightSensitive -> resolvedLightSensitive,
		Expires -> resolvedExpires,
		DiscardThreshold -> resolvedDiscardThreshold,
		ShelfLife -> shelfLifeToUse,
		UnsealedShelfLife -> unsealedShelfLifeToUse,
		DefaultStorageCondition -> resolvedDefaultStorageCondition,
		Acid -> acid,
		Base -> base,
		TransportTemperature -> resolvedTransportTemperature,
		Density -> (Lookup[combinedOptions, Density] /. {Automatic -> Null}),
		ExtinctionCoefficients -> Lookup[combinedOptions, ExtinctionCoefficients],
		Ventilated -> resolvedVentilated,
		Flammable -> resolvedFlammable,
		Fuming -> resolvedFuming,
		IncompatibleMaterials -> resolvedIncompatibleMaterials,
		(* when called in ExperimentStockSolution, we are passing in the Volume option and returning it resolved; when called in UploadStockSolution we don't pass in Volume so we don't give it back *)
		If[MatchQ[volumeOption, {VolumeP..}],
			Volume -> actualVolume,
			Nothing
		],
		(* If Mix is Automatic, then resolve it to True since that needs to happen when using the formula overload *)
		Which[
			MatchQ[Lookup[combinedOptions, Mix], {Automatic..}], Mix -> (Lookup[combinedOptions, Mix] /. {Automatic -> True}),
			KeyExistsQ[combinedOptions, Mix], Mix -> (Lookup[combinedOptions, Mix] /. {Automatic -> True}),
			True, Nothing
		],
		(* If Filter is Automatic, then resolve it to False since that needs to happen when using the formula overload *)
		Which[
			MatchQ[Lookup[combinedOptions, Filter], {Automatic..}], Filter -> (Lookup[combinedOptions, Filter] /. {Automatic -> False}),
			KeyExistsQ[combinedOptions, Filter], Filter -> (Lookup[combinedOptions, Filter] /. {Automatic -> False}),
			True, Nothing
		],
		(*Note that UltrasonicIncompatible isn't actually an option to ExperimentStockSolution but I need it for this resolver*)
		UltrasonicIncompatible -> resolvedUltrasonicIncompatible
	};

	(* get all the invalid inputs together *)
	invalidInputs = DeleteDuplicates[Download[Flatten[{
		duplicatedComponentInvalidInputs,
		deprecatedComponentInvalidInputs,
		solventNotLiquidInvalidInputs,
		componentStateInvalidInputs,
		componentAmountOutOfRangeInvalidInputs,
		componentRequiresTabletCountInvalidInputs
	}], Object]];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* get all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		formulaVolumeTooLargeInvalidOptions,
		volumeInvalidFillToVolumeInvalidOptions,
		namesAlreadyInUseOptions,
		synonymsNoNamesOptions,
		duplicateNameOptions,
		shelfLivesSetIncorrectlyOptions,
		shelfLivesSetProperlyOptions,
		acidAndBaseOptions,
		invalidOrderOfOperationOptions
	}]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* make the options rules  *)
	(* return the semi-resolved options that include all the options that can only be specified in the Formula overload, with the rest of the Automatics *)
	resultRule = Result -> If[MemberQ[output, Result],
		ReplaceRule[combinedOptions, formulaOnlyResolvedOptions],
		Null
	];

	(* gather the tests together *)
	allTests = Cases[Flatten[{
		duplicatedComponentTest,
		deprecatedComponentTest,
		solventNotLiquidTest,
		componentStateUnknownTest,
		componentStateInvalidTest,
		componentAmountOutOfRangeTest,
		componentRequiresTabletCountTest,
		formulaVolumeTooLargeTest,
		volumeInvalidFillToVolumeTest,
		namesAlreadyInUseTest,
		synonymsNoNamesTest,
		duplicateNameTest,
		shelfLivesSetIncorrectlyTest,
		unsealedLongerWarning,
		shelfLifeError,
		acidBaseTests,
		volumeOptionUnusedWarnings,
		orderOfOperationsTest
	}], _EmeraldTest];

	(* generate the test rules *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	outputSpecification /. {resultRule, testsRule}


];



(* ::Subsubsection:: *)
(*stockSolutionResourcePackets*)


(*
	--- RESULT Helper ---
		myStockSolutionModels: either existing stock solution models or new change packets that are returned from UploadStockSolution (or Null if we are explicitly not making a new stock solution model);
		myPreparationVolumes: volume of solution to prepare initially; might be more than final volume if in Engine, e.g.:
			- resource from Engine requests 5 mL of a pH-titrated solution, $MinStockSolutionpHVolume is 100mL, so we'll auto-make 100mL and then aliqot the 5 for the resource
		myDensityScouts: in some cases, we might need to make a temporary samples to get it's density, these are it
			- if a user asked for 5mL of such a solution, would just be an error
		myPreparedResourcePackets: again, if in Engine, the resources being prepared; their RentContainer property needs to be passed along to any container resources created
		myResolvedOptions: has the resolved options;
			HUGE CAVEAT: the preparative options are NOT LISTED if coming from the formula overload, gotta ExpandIndexMatchedInputs those,
		myUnresolvedOptions: initial passed options (including template (protocol template))
*)
stockSolutionResourcePackets[
	myStockSolutionModels:{(ObjectReferenceP[stockSolutionModelTypes]|PacketP[stockSolutionModelTypes]|Null)..},
	myPreparationVolumes:{VolumeP..},
	myDensityScouts:{ObjectP[]..}|{},
	myPreparedResourcePackets:{PacketP[Object[Resource,Sample]]...},
	mySamplesIn:{ObjectP[{Object[Sample], Model[Sample]}]..}|{},
	myFormulaSpecs:{({{VolumeP|MassP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..}|Null)..},
	mySolvents:{(ObjectP[Model[Sample]]|Null)..},
	myResolvedOptions:{_Rule..},
	myUnresolvedOptions:{_Rule...}
]:=Module[
	{expandedResolvedOptions,existingModelStockSolutions,newStockSolutionChangePackets,newStockSolutionFormulaModels,containersOut,volumetricFlasks,
		existingSolutionDownloadTuples,formulaModelDownloadTuples,containerOutDownloadTuples,preferredContainerPacketLists,preferredContainerPackets,uniqueExistingSolutionPackets,
		uniqueFormulaComponentPackets,containerOutPackets,stockSolutionModelPackets,rentContainerBools,resolvedMixBools,resolvedpHs,
		resolvedFilterBools,preparatoryContainerResources,finalContainerResources,mixOrIncubateBools,
		fixedAliquotComponents,fixedAliquotResources,mixedSolutionPackets,formulasWithUnitsAndPackets,
		pHingSolutionPackets,filteredSolutionPackets,filtrationParameters,pHIncrementMultiplier,pHVolumeIncrements,pHingSolutionVolumesRequired,
		pHingAcidsBypHingSolution,pHingBasesBypHingSolution,pHAcidAmountRules,pHBaseAmountRules,pHAdjustmentModelAmountRules,
		uniquepHModelAmountRules,pHingModelResources,pHModelResourceLookup,pHingAcidResources,pHingBaseResources,tipModelPackets,
		tipModelCountLookup,pipetteTipModels,allPipetteTipModels,uniqueTipsToUse,pipetteTipsWithCountedResources,acidBaseTipTuples,
		acidTips,baseTips,acidTipResources,baseTipResources,pHPipettes,pHPipetteResourceLookup,pHPipetteResources,pHMixer,pHPrepContainerResources,pHImpellerResources,volumeMeasurementSolutionPackets,fillToVolumeSolutionPackets,
		fillToVolumeSolvents,fillToVolumeMethods,resolvedOptionsForProtocol,protocolID,protocolPacket,resolvedIncubateBools,
		samplesOutStorage, extraPackets, numReplicatesExpander, noModelFormulaObjs, groupedFillToVolumeValues,
		formulasWithUnits, effectiveStockSolutionVolume, prepVolumeScalingFactor, resolvedTemperatures,
		mixParametersNew, allAmounts, samplesInResources, numReplicates, numReplicatesNoNull, formulaSpecsNoLinks,
		nominalpHs, minpHs, maxpHs, pHTols, pHVolumeMultipler, pHVolumes, dosingTime, combiningTime, allResourceBlobs, fulfillable, frqTests, previewRule,
		optionsRule, testsRule, resultRule, outputSpecification, output, gatherTests, messages,volumetricFlaskPackets,compatibleVolumetricFlasksForSSModel,
		resolvedAutoclaveBools, resolvedAutoclavePrograms, autoclaveSamples,autoclaveSampleContainerOut,autoclavePrograms,
		resolvedLightSensitive, resolvedIncompatibleMaterials,
		autoclaveSamplesWithArea,batchedAutoclaveSamples,autoclaveBatchLengths, fixedAliquotTotalAmounts,
		fixedAmountComponentAmountResources, singleUseComponentAmountRules,
		singleUseComponentAmountAssoc, uniqueSingleUseComponentResources,
		newRequestedVolumes,requestedVolumes, preparatoryVolumes,containerOutMaxVolumes,volumeAboveContainerOutMaxQ,resolvedAdjustpHBools,
		gellingAgentsResources,gellingAgents,mediaPhases,stirBarResource, heatSensitiveReagents, postAutoclaveMixedSolutionPackets,
		postAutoclaveMixOrIncubateBools, resolvedPostAutoclaveMixBools, resolvedPostAutoclaveIncubateBools, postAutoclaveMixParametersNew,
		newCache, fastAssoc
		},

	(* for the sometimes indexed options (all the prep stuff, Volume, ContainerOut), from here it will be good to have the expanded version; use overload 1, the index-matched one *)
	(* since the stock model _can_ be Null, but not in the input widgets and we don't want it to be that way in the input widgets, need to replace Nulls with a placeholder *)
	expandedResolvedOptions = Last[ExpandIndexMatchedInputs[ExperimentStockSolution,{myStockSolutionModels} /. {Null -> Model[Sample, StockSolution, "Fake model to make ExpandIndexMatchedInputs be happy"]},myResolvedOptions,1]];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the NumberOfReplicates option *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates];
	numReplicatesNoNull = numReplicates /. {Null -> 1};

	(* make a tiny function that expands index matching things with number of replicates *)
	numReplicatesExpander[myList_List]:=Module[{},
		Join @@ Map[
			ConstantArray[#, numReplicatesNoNull]&,
			myList
		]
	];

	(* we are in a weird situation right off the bat with the stock solution model inputs; since we are calling UploadStockSolution, we are getting back, in a way we can't predict,
	 	either totally new stock solution change packets (not in DB) or existing models that were found via search (basically can't assume these models have anything to do with
		the input models; as a result, we need to do a Download here to get some information about these solutions) *)

	(* get the stock solution models we're preparing that are existing models (i.e. object references); and also the change packets *)
	existingModelStockSolutions=Cases[myStockSolutionModels,ObjectReferenceP[]];
	newStockSolutionChangePackets=Cases[myStockSolutionModels,PacketP[]];

	(* get the formulas that correspond to the no-model stock solutions that will be created *)
	noModelFormulaObjs = Flatten[PickList[myFormulaSpecs, myStockSolutionModels, Null][[All, All, 2]]];

	(* also we're going to need to check if we have any fixed-aliquot compoments; gotta snag the formula models for the new stock solution change packets;
	 	just get a flast list, we'll use our "make a big packet pile" trick *)
	(* need to exempt UnitOps based stock solutions that don't have formulae *)
	newStockSolutionFormulaModels=Flatten[Map[
		If[MatchQ[Lookup[#,Replace[Formula]], Except[{}]],
			Lookup[#,Replace[Formula]][[All,2]],
			{}
		]&,newStockSolutionChangePackets
	]];

	(* similarly, we may have resolved ContainerOut options via PreferredContainer that we don't have packets for; might need to check if they're volume calibrated, so also want to download from these *)
	containersOut=Lookup[expandedResolvedOptions,ContainerOut];

	(* get the FillToVolumeMethod option *)
	fillToVolumeMethods=Lookup[expandedResolvedOptions,FillToVolumeMethod];

	volumetricFlasks=If[MemberQ[fillToVolumeMethods,Volumetric],
		Search[Model[Container, Vessel, VolumetricFlask], Deprecated != True && MaxVolume!=Null && DeveloperObject != True],
		{}
	];


	(* set up a download call for these two things we need to get due to being given object references via Search that we couldn't know in advance;
	 	gotta Quiet because only Model[Sample] has FixedAliquot *)
	{existingSolutionDownloadTuples,formulaModelDownloadTuples,containerOutDownloadTuples,preferredContainerPacketLists,volumetricFlaskPackets}=Quiet[Download[
		{
			existingModelStockSolutions,
			Flatten[{noModelFormulaObjs, newStockSolutionFormulaModels}],
			containersOut,
			PreferredContainer[All],
			volumetricFlasks
		},
		{
			{
				Packet[Formula,FillToVolumeSolvent,TotalVolume,LightSensitive,PreferredContainers,State,Sterile, UnitOperations, PreparationType, IncompatibleMaterials],
				Packet[Formula[[All,2]][{SingleUse, FixedAmounts, Resuspension}]]
			},
			{Packet[SingleUse, FixedAmounts, Resuspension]},
			{Packet[VolumeCalibrations, Dimensions, MaxVolume, ContainerMaterials]},
			{Packet[MinVolume, MaxVolume, ContainerMaterials]},
			{Packet[Object, MaxVolume, ContainerMaterials, Opaque]}
		},
		Date -> Now
	],{Download::FieldDoesntExist}];

	(* combine what we've Downloaded here to make a new cache *)
	newCache = FlattenCachePackets[{existingSolutionDownloadTuples,formulaModelDownloadTuples,containerOutDownloadTuples,preferredContainerPacketLists}];

	(* make a fast association here for future use *)
	fastAssoc = makeFastAssocFromCache[newCache];

	(* separate the existing packets out from these tuples; could be duplicates *)
	uniqueExistingSolutionPackets=DeleteDuplicatesBy[existingSolutionDownloadTuples[[All,1]],Lookup[#,Object]&];

	(* get a unique list of all formula compoments *)
	uniqueFormulaComponentPackets=DeleteDuplicatesBy[Flatten[{existingSolutionDownloadTuples[[All,2]],formulaModelDownloadTuples[[All,1]]}],Lookup[#,Object]&];

	(* get the ContainerOut packets; this is indexed to the resolved option *)
	containerOutPackets=containerOutDownloadTuples[[All,1]];

	preferredContainerPackets=Flatten[preferredContainerPacketLists,1];

	(* assemble a flat list in the order we got the model stock solutions in of just PacketP[];
		- if the original input was a change packet, strip off Append/Replace
		- if the original input was an existing model reference, find the packet we downloaded for it
		- if there is no model, put Null *)
	stockSolutionModelPackets=Map[
		Function[inputStockSolution,
			Which[
				MatchQ[inputStockSolution,PacketP[]],
					(* strip Append/Replace from the multiple fields *)
					<|KeyValueMap[
						If[MatchQ[#1,_Append|_Replace],
							First[#1]->#2,
							#1->#2
						]&,
						inputStockSolution
					]|>,
				MatchQ[inputStockSolution, ObjectReferenceP[]],
					(* grab the object packet we downloaded *)
					SelectFirst[uniqueExistingSolutionPackets,MatchQ[Lookup[#,Object],inputStockSolution]&],
				True, Null
			]
		],
		myStockSolutionModels
	];

	(* get the formulas with amounts and amount units combined *)
	(* need to do this If for the cases where we're dealing with tablets *)
	formulasWithUnits = MapThread[
		Function[{modelPacket, formula},
			Map[
				{#[[1]]/.{unit : UnitsP[Unit] :> QuantityMagnitude[unit]}, Download[#[[2]], Object]}&,
				If[NullQ[modelPacket], formula, Lookup[modelPacket, Formula]]
			]
		],
		{stockSolutionModelPackets, myFormulaSpecs}
	];

	(* get the effective formula volumes for all the stock solutions *)
	(* if TotalVolume is populated, use that; if not, take the sum of all the volumes in the formula *)
	(* if we don't have a model (i.e., we are using the formula overload with a model-free sample) then just use the prep volume *)
	effectiveStockSolutionVolume = MapThread[
		Which[
			NullQ[#1], #3,
			MatchQ[Lookup[#1, TotalVolume], VolumeP], Lookup[#1, TotalVolume],
			MemberQ[#2[[All, 1]],VolumeP], Total[Cases[#2[[All, 1]],VolumeP]],
			True, 1 Liter
		]&,
		{stockSolutionModelPackets, formulasWithUnits, myPreparationVolumes}
	];

	(* get the scaling factor between the prep volume and the formula volume *)
	(* used to use Quotient but it didn't behave nicely with units *)
	prepVolumeScalingFactor = myPreparationVolumes / effectiveStockSolutionVolume;

	(* from the prepared resources, get the RentContainer boolean; if we have no prepared resource packets, just set to False across the board *)
	rentContainerBools=If[MatchQ[myPreparedResourcePackets,{PacketP[]..}],
		TrueQ/@Lookup[myPreparedResourcePackets,RentContainer],
		ConstantArray[False,Length[stockSolutionModelPackets]]
	];

	(* look up whether we are doing any prep on  each of the solutions that will expect a nice ECL vessel *)
	resolvedMixBools=Lookup[expandedResolvedOptions,Mix];
	resolvedIncubateBools=Lookup[expandedResolvedOptions,Incubate];
	resolvedpHs=Lookup[expandedResolvedOptions,pH];
	resolvedFilterBools=Lookup[expandedResolvedOptions,Filter];
	resolvedAutoclaveBools=Lookup[expandedResolvedOptions,Autoclave];
	resolvedAutoclavePrograms=Lookup[expandedResolvedOptions,AutoclaveProgram];
	resolvedAdjustpHBools=Lookup[expandedResolvedOptions,AdjustpH];
	resolvedPostAutoclaveMixBools=Lookup[expandedResolvedOptions,PostAutoclaveMix];
	resolvedPostAutoclaveIncubateBools=Lookup[expandedResolvedOptions,PostAutoclaveIncubate];

	(* get the figure out the booleans for if we are mixing OR incubating *)
	mixOrIncubateBools = MapThread[#1 || #2&, {resolvedMixBools, resolvedIncubateBools}];
	postAutoclaveMixOrIncubateBools = MapThread[#1 || #2&, {resolvedPostAutoclaveMixBools, resolvedPostAutoclaveIncubateBools}];

	(* For each stock solution model, figure out the compatible volumetric flasks to prepare for FTV resolution, considering the light sensitive requirement and incompatible materials *)
	(* Use the value from model packet if we have an existing model, or from resolved options if we have formula input *)
	(* Note that we have to use model packet for model input since pseudoResolvedFormulaOnlyOptions Nulls out these options *)
	resolvedLightSensitive=MapThread[
		If[NullQ[#1],#2,Lookup[#1,LightSensitive]]&,
		{
			stockSolutionModelPackets,
			Lookup[expandedResolvedOptions,LightSensitive]
		}
	];
	resolvedIncompatibleMaterials=MapThread[
		If[NullQ[#1],#2,Lookup[#1,IncompatibleMaterials]]&,
		{
			stockSolutionModelPackets,
			Lookup[expandedResolvedOptions,IncompatibleMaterials]
		}
	];
	compatibleVolumetricFlasksForSSModel=MapThread[
		Function[
			{lightSensitive,incompatibleMaterials},
			If[TrueQ[lightSensitive],
				(* When the stock solution is light sensitive, require Opaque->True and no incompatible materials *)
				Cases[Flatten@volumetricFlaskPackets,KeyValuePattern[{Opaque->True,ContainerMaterials->Except[{___,Alternatives@@incompatibleMaterials,___}]}]],
				(* Otherwise just require no incompatible materials *)
				Cases[Flatten@volumetricFlaskPackets,KeyValuePattern[{ContainerMaterials->Except[{___,Alternatives@@incompatibleMaterials,___}]}]]
			]
		],
		{resolvedLightSensitive,resolvedIncompatibleMaterials}
	];


	(* determine the containers we want to do preparation of components in, and make resources for both these and ContainersOut *)
	(* this is the same logic as resolver *)
	{preparatoryContainerResources,finalContainerResources}=Transpose@MapThread[
		Function[
			{stockSolutionModelPacket, containerOutPacket, prepVolume, finalVolume,
				filterBool, autoclaveBool, rentContainerBool, fillToVolumeMethod, adjpHBool, orderOfOps,
				prepareInResuspensionContainerQ, lightSensitive, validVolumetricFlaskPackets},

			Module[{prepVolumeAdjusted,potentialPrepContainers,prepContainer},

				(* If we need to adjustpH, we want to leave an extra 7.5% of empty volume in our preparatory container for the arbitrary pHing addition volume -- we are making an exception here for Volumetric flasks with FtV after pHing *)
				prepVolumeAdjusted=Which[

					(* If we are not adjusting the pH, then do prep volume *)
					!adjpHBool,prepVolume,

					(* If we are adjusting the pH and doing a volumetric FillToVolume, do prep volume *)
					MatchQ[fillToVolumeMethod,Volumetric]&&SubsetQ[orderOfOps,{FillToVolume,pHTitration}],prepVolume,

					(* Otherwise, we are adjusting the pH so add 7.5% to the volume *)
					True,prepVolume*1.075
				];

				(* Get the container used to prepare our stock solution, in non Volumetric case *)
				prepContainer=stockSolutionPrepContainer[stockSolutionModelPacket, prepVolumeAdjusted, containerOutPacket, lightSensitive, autoclaveBool, fastAssoc];

				Which[
					(* if we are preparing in the original container of a fixed amounts components, just set PreparatoryContainers and ContainersOut to Null at this point. They will be populated at compile time when the fixed amounts samples are picked *)
					MatchQ[prepareInResuspensionContainerQ,True],
					{
						{},{}
					},
					(* if the StockSolution is defined by UnitOperations we assume we don't need to make resources for containers unless ContainerOut is different from the Model of the Container is the LabelContainer primitive *)
					(* TODO if we ever allow LabelSample instead of LabelContainer primitive to be the first one, this might break! *)
					(* we get away with the second Lookup for the case of no UnitOperations because And will return False once the first input if False *)
					And[
						Not[NullQ[stockSolutionModelPacket]],
						MatchQ[Lookup[stockSolutionModelPacket, UnitOperations, {}], Except[Null | {}]],
						MatchQ[
							Lookup[FirstCase[Lookup[stockSolutionModelPacket, UnitOperations], _LabelContainer, { <||> }][[1]], Container, Null],
							(* Need to account for both cases of Object and Model *)
							Which[
								MatchQ[Lookup[containerOutPacket, Object], ObjectReferenceP[Model[Container]]],
								Lookup[containerOutPacket, Object],
								True,
								Download[Lookup[containerOutPacket, Model], Object]
							]
						]
					],
					ConstantArray[
						Flatten[Table[
							Resource[Name->"My Favorite Happy Single Container Resource "<>ToString[Unique[]], Sample -> Lookup[containerOutPacket, Object], Rent -> rentContainerBool],
							numReplicatesNoNull
						]],
						2
					],
					(* several cases necessitate transferring to a new container after preparation *)
					And[
						(* if we have a Null model, then we will always only need one container resource *)
						Not[NullQ[stockSolutionModelPacket]],
						Or[
							(* if there are no preferred vessels that match the container out, we definitely need to make two resources *)
							!MatchQ[prepContainer,Lookup[containerOutPacket,Object]],

							(* if we're filtering, we definitely need to make two resources *)
							filterBool,

							(* if we're prepping the sample in a volumetric, we need to make two resources*)
							MatchQ[fillToVolumeMethod,Volumetric],

							(* if the volume needs to be measured either for a first-time direct formula solution, or for FtV, we definitely need to make two resources *)
							And[
								Or[
									MatchQ[Lookup[stockSolutionModelPacket,FillToVolumeSolvent],ObjectP[]],
									NullQ[Lookup[stockSolutionModelPacket,TotalVolume]]
								],
								MatchQ[Lookup[containerOutPacket,VolumeCalibrations],{}]
							]
						]
					],
					(* make different resources for the prep and final container; pass rent property; Rent the prep container IF THE CONTAINER IS REUSABLE (we'll discard it);
						this is cheating a bit since we're assuming that PreferredContainer returns reusable things above 50mL
						 DO NOT RENT if we're making more volume in Engine; keep that prep sample around *)
					{
						Flatten[
							If[MatchQ[fillToVolumeMethod,Volumetric],
								(* a volumetric flask*)
								(* NOTE that doing the Table[blah, numReplicatesNoNull] is important because Table iterates multiple times and the Unique[] will be different each time. *)
								(* DO NOT CHANGE THIS TO ConstantArray *)
								Module[
									{sortedVolumetricFlaskPackets},
									(* Sort our flasks from smallest to largest since we're going to FirstCase later to get the smallest flask that can hold our volume. *)
									(* The list validVolumetricFlaskPackets already considered light sensitive requirement and incompatible materials *)
									(* We also want to prefer non-opaque volumetric flasks if there are any available - Opaque->True should be put later in the list (sort will do False-Null-True, matching what we need *)
									sortedVolumetricFlaskPackets = SortBy[validVolumetricFlaskPackets, {Lookup[#, MaxVolume]&, Lookup[#,Opaque]&}];
									Table[
										Resource[
											(* find a volumetric flask of the right size *)
											Sample->Lookup[
												SelectFirst[sortedVolumetricFlaskPackets, Lookup[#, MaxVolume] >= N[prepVolumeAdjusted] &],
												Object
											],
											Rent->True,
											Name->ToString[Unique[]]
										],
										numReplicatesNoNull
									]
								],
								(* ELSE: normal preparatory container resource*)
								(* NOTE that doing the Table[blah, numReplicatesNoNull] is important because Table iterates multiple times and the Unique[] will be different each time. *)
								(* DO NOT CHANGE THIS TO ConstantArray *)
								Table[
									Resource[
										Sample->prepContainer,
										Rent->Which[
											(* if we were told to Rent the above, gotta rent down the stack *)
											rentContainerBool, True,

											(* we're making more in Engine, don't rent *)
											prepVolumeAdjusted>finalVolume, False,

											(* if we're making more than 50mL, assume PreferredContainer gives us a resuable thing; rent this *)
											prepVolumeAdjusted>50 Milliliter, True,

											(* otherwise, default to not rent it (ah the ol' True->False, deal with it) *)
											True, False
										],
										Name->ToString[Unique[]]
									],
									numReplicatesNoNull
								]
							]
						],
						(* this container will persistently hold the sample out, so nothing fancy here; just rent the container if we were told to from on high *)
						(* NOTE that doing the Table[blah, numReplicatesNoNull] is important because Table iterates multiple times and the Unique[] will be different each time. *)
						(* DO NOT CHANGE THIS TO ConstantArray *)
						Flatten[Table[Resource[Sample->Lookup[containerOutPacket,Object],Rent->rentContainerBool, Name->ToString[Unique[]]], numReplicatesNoNull]]
					},

					(* otherwise, we have a ContainerOut that's a nice PreferredContainer; we can just prepare directly in the final container, so make an identical resource *)
					(* NOTE that doing the Table[blah, numReplicatesNoNull] is important because Table iterates multiple times and the Unique[] will be different each time. *)
					(* DO NOT CHANGE THE INNER ONE TO ConstantArray *)
					True,
					ConstantArray[
						Flatten[Table[
							Resource[Name->"My Favorite Happy Single Container Resource "<>ToString[Unique[]],Sample->Lookup[containerOutPacket,Object],Rent->rentContainerBool],
							numReplicatesNoNull
						]],
						2
					]
				]
			]
		],
		{
			stockSolutionModelPackets,
			containerOutPackets,
			myPreparationVolumes,
			Lookup[expandedResolvedOptions,Volume],
			resolvedFilterBools,
			resolvedAutoclaveBools,
			rentContainerBools,
			fillToVolumeMethods,
			resolvedAdjustpHBools,
			Lookup[myResolvedOptions,OrderOfOperations],
			Lookup[myResolvedOptions,PrepareInResuspensionContainer],
			Lookup[expandedResolvedOptions,LightSensitive],
			compatibleVolumetricFlasksForSSModel
		}
	];

	(* get the formula with units and packets instead of objects and non-multiplied units *)
	formulasWithUnitsAndPackets = Map[
		Function[{formulaEntry},
			{formulaEntry[[1]], SelectFirst[uniqueFormulaComponentPackets, MatchQ[Lookup[#, Object], formulaEntry[[2]]]&]}
		],
		formulasWithUnits,
		{2}
	];

	(* get _only_ the fixed aliquot for each formula (and Null if none) *)
	fixedAliquotComponents = Map[
		Function[{formula},
			Select[formula[[All, 2]], MatchQ[Lookup[#, FixedAmounts],{(MassP|VolumeP)..}] || TrueQ[Lookup[#, SingleUse]]&]
		],
		formulasWithUnitsAndPackets
	];
	(* This total amount is actually just a scaled amount *)
	fixedAliquotTotalAmounts = MapThread[
		Function[{formula, scalingFactor},
			(*Round for a FixedAmounts because it's important for the scaling factor to be an integer and not a decimal.  For SingleUse though then it doesn't matter and so rounding can be dangerous*)
			If[MemberQ[Lookup[formula[[All, 2]], FixedAmounts, {}], {(MassP|VolumeP)..}],
				Select[formula, MatchQ[Lookup[#[[2]], FixedAmounts],{(MassP|VolumeP)..}]&][[All, 1]] * Round[scalingFactor],
				Select[formula, TrueQ[Lookup[#[[2]], SingleUse]]&][[All, 1]] * scalingFactor
			]
		],
		{formulasWithUnitsAndPackets, prepVolumeScalingFactor}
	];
	(* Samples with FixedAmount -> MassP|VolumeP needs one resource per unit of Model requested. *)
	(* Samples with SingleUse -> True can have consolidated resource with amount -> roundedUpAmount *)

	(* generate the fixed aliquot resources *)
	(* Starting with consolidating required amount for same component objects *)
	fixedAmountComponentAmountResources = Flatten[MapThread[
		Function[{faComponents, scalingFactor, totalAmountPerComponent},
			If[MatchQ[faComponents, {}],
				Nothing,
				MapThread[
					Function[{faComponent,requestedAmount},
						Module[{amountToPick,numberOfResources, component,fixedAmounts},
							component = Lookup[faComponent, Object];
							fixedAmounts = Lookup[faComponent, FixedAmounts];
							(* Convert Mass/Volume to integer times unit amount *)
							If[!MatchQ[fixedAmounts,{(MassP|VolumeP)..}],
	   							(* It is single use, we consolidated *)
								Nothing,
								(* Otherwise it is fixed amount, we need to create as many resource as the number we need to pick *)
								(* need to calculate the number and amount of resources to pick *)
								(* the amount of the fixed amount sample here can only be a member of FixedAmounts field *)
								(* Simple criteria: 1. pick the one that matches the requested amount. 2. if no matches, pick the closest one that is smaller than the requested amount. 3. if requesting less than the smallest FixedAmounts, use the smallest FixedAmounts. *)
								amountToPick=Which[
									(* pick the exact match *)
									MatchQ[SelectFirst[fixedAmounts,#==requestedAmount&],MassP|VolumeP],
									SelectFirst[fixedAmounts,#==requestedAmount&],
									(* if the requsted volume is larger than at least  one FixedAmounts, pick the one that is closest to the requested amount (need to be smaller) *)
									(* need to do the Sort and Last, because the FixedAmounts may not be sorted *)
									MatchQ[Cases[fixedAmounts,LessP[requestedAmount]],{(MassP|VolumeP)..}],
									Last[Sort[Cases[fixedAmounts,LessP[requestedAmount]]]],
									(* if the requested volume is smaller than any of the FixedAmounts, just pick the smallest fixed amount *)
									True, First[Sort[fixedAmounts]]
								];
								(* the number of the resources can only be integer here, since it is not possible to pick/prepare fraction of FixedAmounts samples. We have already checked and thrown an error if it is invalid *)
								(* SafeRound in this context *)
								numberOfResources=SafeRound[requestedAmount/amountToPick, 1, Round -> Up];

								(* Return resources for *)
								Table[Resource[Sample -> component, Amount -> amountToPick, Name->ToString[Unique[]], ExactAmount -> True], numberOfResources]
							]
						]
					],
					{faComponents, totalAmountPerComponent}
				]
			]
		],
		{fixedAliquotComponents, prepVolumeScalingFactor, fixedAliquotTotalAmounts}
	]];

	singleUseComponentAmountRules = Flatten[MapThread[
		Function[{faComponents, totalAmountPerComponent},
			If[MatchQ[faComponents, {}],
				Nothing,
				MapThread[
					Function[{faComponent,requestedAmount},
						If[MatchQ[Lookup[faComponent,FixedAmounts], {(MassP|VolumeP)..}],
							Nothing,
							Lookup[faComponent, Object] -> requestedAmount
						]
					],
					{faComponents, totalAmountPerComponent}
				]
			]
		],
		{fixedAliquotComponents, fixedAliquotTotalAmounts}
	]];

	(*Merge any entries with duplicate keys, totaling the values*)
	singleUseComponentAmountAssoc = Merge[singleUseComponentAmountRules, Total];

	(*Generate a resource for each unique sample, returning a lookup table of sample->resource*)
	uniqueSingleUseComponentResources = KeyValueMap[
		Function[{object, amount},
			Module[{objectRef, containers},
				(* make sure out object is in reference form *)
				objectRef = Download[object, Object];

				(* create resource *)
				If[MatchQ[objectRef, ObjectReferenceP[]] && MatchQ[amount, VolumeP | MassP | CountP],
					Resource[Sample -> objectRef, Amount -> amount, Name -> ToString[Unique[]]],
					(*If we somehow don't need to make a resource, return nothing *)
					Nothing
				]
			]
		],
		singleUseComponentAmountAssoc
	];
	(* Generate resources by replacing the flattened list of component objects with its corresponding resource *)
	(* For each component, generate as many times as the number of times required *)
	fixedAliquotResources = Join[
		fixedAmountComponentAmountResources,
		uniqueSingleUseComponentResources
	];

	(* identify the models that will be mixed *)
	mixedSolutionPackets=PickList[stockSolutionModelPackets, mixOrIncubateBools];
	postAutoclaveMixedSolutionPackets=PickList[stockSolutionModelPackets, postAutoclaveMixOrIncubateBools];

	(* get the Temperature *)
	resolvedTemperatures = Lookup[expandedResolvedOptions, IncubationTemperature];

	(* prepare the MixParameters field; only populated for indices where Mix -> True or Incubate -> True *)
	mixParametersNew = MapThread[
		Function[
			{mix, incubate, mixType, mixUntilDissolved, mixer, mixTime, maxMixTime, incubationTime, mixRate, numberOfMixes, maxNumberOfMixes, mixPipettingVolume, annealingTime, incubator, temp},
			If[mix || incubate,
				<|
					Type->mixType,
					MixUntilDissolved -> mixUntilDissolved,
					(* even though the incubator is by definition not a Mixer at this point, ExperimentIncubate has confusing options and so when we call it directly later we need to pass in the incubator in as the Instrument as well *)
					Mixer -> If[NullQ[mixer] && Not[NullQ[incubator]],
						Link[incubator],
						Link[mixer]
					],
					Time -> If[NullQ[mixTime] && Not[NullQ[incubationTime]],
						incubationTime,
						mixTime
					],
					MaxTime -> maxMixTime,
					Rate -> mixRate,
					NumberOfMixes -> numberOfMixes,
					MaxNumberOfMixes -> maxNumberOfMixes,
					PipettingVolume -> mixPipettingVolume,
					Temperature -> (temp /. {Ambient -> Null}),
					AnnealingTime -> annealingTime,
					(* these options are actually always going to be Null because the Thaw options don't do what I thought they did but also changing named multiple key names is hard/very hard *)
					ThawInstrument -> Null,
					ThawTemperature -> Null,
					ThawTime -> Null
				|>,
				Nothing
			]
		],
		{Sequence @@ Lookup[expandedResolvedOptions,{Mix,Incubate,MixType,MixUntilDissolved,Mixer,MixTime,MaxMixTime,IncubationTime,MixRate,NumberOfMixes,MaxNumberOfMixes,MixPipettingVolume, AnnealingTime, Incubator}], resolvedTemperatures}
	];

	(* prepare the MixParameters field; only populated for indices where Mix -> True or Incubate -> True *)
	postAutoclaveMixParametersNew = MapThread[
		Function[
			{mix, incubate, mixType, mixUntilDissolved, mixer, mixTime, maxMixTime, incubationTime, mixRate, numberOfMixes, maxNumberOfMixes, mixPipettingVolume, annealingTime, incubator, temp},
			If[mix || incubate,
				<|
					Type->mixType,
					MixUntilDissolved -> mixUntilDissolved,
					(* even though the incubator is by definition not a Mixer at this point, ExperimentIncubate has confusing options and so when we call it directly later we need to pass in the incubator in as the Instrument as well *)
					Mixer -> If[NullQ[mixer] && Not[NullQ[incubator]],
						Link[incubator],
						Link[mixer]
					],
					Time -> If[NullQ[mixTime] && Not[NullQ[incubationTime]],
						incubationTime,
						mixTime
					],
					MaxTime -> maxMixTime,
					Rate -> mixRate,
					NumberOfMixes -> numberOfMixes,
					MaxNumberOfMixes -> maxNumberOfMixes,
					PipettingVolume -> mixPipettingVolume,
					Temperature -> (temp /. {Ambient -> Null}),
					AnnealingTime -> annealingTime,
					(* these options are actually always going to be Null because the Thaw options don't do what I thought they did but also changing named multiple key names is hard/very hard *)
					ThawInstrument -> Null,
					ThawTemperature -> Null,
					ThawTime -> Null
				|>,
				Nothing
			]
		],
		{Sequence @@ Lookup[expandedResolvedOptions,{PostAutoclaveMix,PostAutoclaveIncubate,PostAutoclaveMixType,PostAutoclaveMixUntilDissolved,PostAutoclaveMixer,PostAutoclaveMixTime,PostAutoclaveMaxMixTime,PostAutoclaveIncubationTime,PostAutoclaveMixRate,PostAutoclaveNumberOfMixes,PostAutoclaveMaxNumberOfMixes,PostAutoclaveMixPipettingVolume, PostAutoclaveAnnealingTime, PostAutoclaveIncubator}], resolvedTemperatures}
	];

	(* identify models slated for pHing, we want to index to them *)
	pHingSolutionPackets = PickList[stockSolutionModelPackets, resolvedpHs, NumericP];

	(* identify models slated for filtering, we want to index to them *)
	filteredSolutionPackets = PickList[stockSolutionModelPackets, resolvedFilterBools];

	(* prepare the FiltrationParameters field; only poulate indexed fo the filtered solutions, based on Filter bool *)
	filtrationParameters = MapThread[
		Function[
			{filterBool, filterType, filterMaterial, filterSize, filterInstrument, filterModel, filterSyringe, filterHousing},
			If[filterBool,
				<|
					MembraneMaterial -> filterMaterial,
					PoreSize -> filterSize,
					Type->filterType,
					Instrument -> Link[filterInstrument],
					Filter -> Link[filterModel],
					Syringe -> Link[filterSyringe],
					FilterHousing -> Link[filterHousing]
				|>,
				Nothing
			]
		],
		Lookup[expandedResolvedOptions, {Filter, FilterType, FilterMaterial, FilterSize, FilterInstrument, FilterModel, FilterSyringe, FilterHousing}]
	];

	(* pull out the expanded resolved pHing values (MinpH, MaxpH, and NominalpH) *)
	nominalpHs = Cases[resolvedpHs, NumericP];
	minpHs = PickList[Lookup[expandedResolvedOptions, MinpH], resolvedpHs, NumericP];
	maxpHs = PickList[Lookup[expandedResolvedOptions, MaxpH], resolvedpHs, NumericP];


	(*
	(* get the pHing tolerance; basically, MonitorSensor needs a number around the target value that is acceptable; I'm taking whatever is the closer of the Min/MaxpH to NominalpH as that tolerance *)
	(* variable called pHTols because pHTolerances is the actual name of the field so we'd get some weirdness in making the packets below*)
	pHTols = MapThread[
		Round[Min[
			(* NominalpH - MinpH *)
			#1 - #2,
			(* MaxpH - NominalpH *)
			#3 - #1
		], 0.1]&,
		{nominalpHs, minpHs, maxpHs}
	];
	*)


	(* - Calculate the amount of volume that we should ask for for each of the pHing acids/bases - *)
	(* Never seen it take more than 5% of the volume of the stock solution to pH. Request a bit more than this to be safe *)
	pHVolumeMultipler = 0.075; (*NOTE: this number is connected to AdjustpH. If changing, change on both ends.*)
	pHVolumes=PickList[Lookup[expandedResolvedOptions,Volume],resolvedpHs,Except[Null]];
	pHingSolutionVolumesRequired = pHVolumeMultipler*pHVolumes;

	(* eliminate the Null entries from the pHingAcid/Base lists; make sure we're dealing with object references;
	 	assume that if we're pHing, UploadStockSolution way above has resolved these to actual things *)
	pHingAcidsBypHingSolution = Download[Cases[Lookup[expandedResolvedOptions, pHingAcid], ObjectP[]], Object];
	pHingBasesBypHingSolution = Download[Cases[Lookup[expandedResolvedOptions, pHingBase], ObjectP[]], Object];

	(* create a list of rules that relates both acids and bases to the volumes of them we will need *)
	pHAcidAmountRules = MapThread[Rule, {pHingAcidsBypHingSolution, pHingSolutionVolumesRequired}];
	pHBaseAmountRules = MapThread[Rule, {pHingBasesBypHingSolution, pHingSolutionVolumesRequired}];
	pHAdjustmentModelAmountRules = Join[pHAcidAmountRules, pHBaseAmountRules];

	(* merge the rules; this will combine like models, and we can specify we want to total the volumes *)
	uniquepHModelAmountRules = Merge[pHAdjustmentModelAmountRules, Total];

	(* create the necessary resources for each of the unique models; request particular standard container models based on volume so we can assume the pipette tips will fit *)
	pHingModelResources = KeyValueMap[
		Function[{model, amount},
			Module[{roundedAmount,containers},

				roundedAmount = AchievableResolution[amount, Messages -> False];

				(* Use any preferred container that's big enough to hold the amount needed,
				but make sure the container isn't so much bigger that it will dwarf our volume - arbitrarily set to 250 mL *)
				containers = Lookup[Select[preferredContainerPackets,#[MaxVolume]>roundedAmount&&(#[MaxVolume]-roundedAmount<=250 Milliliter||roundedAmount>500 Milliliter)&],Object];

				(* generate the resource and return it *)
				Resource[
					Sample -> model,
					Amount -> roundedAmount,
					Container -> containers,
					Name->ToString[Unique[]]
				]
			]
		],
		uniquepHModelAmountRules
	];

	(* create a lookup between the unique models we're using to adjust pH, and the resources we made for them *)
	pHModelResourceLookup = AssociationThread[Keys[uniquepHModelAmountRules], pHingModelResources];

	(* replace the resources into the pHingAcid and pHingBase lists *)
	pHingAcidResources = Lookup[pHModelResourceLookup, #]& /@ pHingAcidsBypHingSolution;
	pHingBaseResources = Lookup[pHModelResourceLookup, #]& /@ pHingBasesBypHingSolution;

	(*
	(* return all of the possible pipettes that TransferDevices can return; we want to download some info from the tip models; only do this if we're pHing at all *)
	tipModelPackets = If[MatchQ[pHingSolutionPackets, {PacketP[]..}],
		Download[
			TransferDevices[Model[Item,Tips], All][[All, 1]],
			Packet[NumberOfTips],
			Date -> Now
		],
		{}
	];

	(* create a lookup relating a tip model to its number of tips *)
	tipModelCountLookup = AssociationThread[Lookup[tipModelPackets, Object, {}], Lookup[tipModelPackets, NumberOfTips, {}]];

	(* TODO this is entirely to figure out what tips to use when pHing; this is kind of gross/arbitrary so maybe figure out a better way to do this later *)
	pHIncrementMultiplier = 0.0001;
	pHVolumeIncrements = MapThread[
		Function[{prepVolume, pH},
			If[MatchQ[pH, RangeP[0, 14]],
				prepVolume * pHIncrementMultiplier,
				Nothing
			]
		],
		{myPreparationVolumes, resolvedpHs}
	];

	(* for each of the volume increments, also need to decide what pipette tips to use
	 	we are using the smallest tips for off-book lower-than-TransferDevices allows amounts; allow this by bumping up any amounts below this min *)
	(* TransferDevices returns {{tip,minVolume,maxVolume}..} take the first tip since they are ordered by preference *)
	pipetteTipModels=Map[
		With[{devices=TransferDevices[Model[Item,Tips],#]},
			If[MatchQ[devices,{}],
				Last[TransferDevices[Model[Item,Tips],All]][[1]],
				devices[[1,1]]
			]
		]&,
		pHVolumeIncrements
	];

	(* create a list of ALL the tip models we will need, in the form {Acid,base,acid,base} so that we front-load re-using of counted tip bags *)
	allPipetteTipModels = Riffle[pipetteTipModels, pipetteTipModels];

	(* get the unique pipette tip models we need *)
	uniqueTipsToUse = DeleteDuplicates[allPipetteTipModels];

	(* move through the pipette tips list and, by unique tip model, replace models with resources based on count *)
	pipetteTipsWithCountedResources = Fold[
		Function[{currentTips, tipModel},
			Module[{tipsPerSample, countedTipPositions, totalCount, fullBoxRequests, remainderRequest,
				countsToRequest, tipResources, expandedTipResources, resourceReplacementRules},

				(* get the count of this tip model *)
				tipsPerSample = Lookup[tipModelCountLookup, tipModel];

				(* if we just have 1 tip per sample, return the current tip list unmodified; we will make resources fr any naked models later *)
				If[tipsPerSample == 1,
					Return[currentTips, Module]
				];

				(* get the positions of all instances of this model in the tip list *)
				countedTipPositions = Flatten[Position[currentTips, tipModel, {1}, Heads -> False],1];

				(* get the total count of this tip model we will need *)
				totalCount = Length[countedTipPositions];

				(* For each full box of tips we're using, repeat tipsPerObject - we will request a full box *)
				fullBoxRequests = ConstantArray[tipsPerSample, Floor[totalCount / tipsPerSample]];

				(* For the one partial box of tips we're using, request the remainder *)
				remainderRequest = Mod[totalCount, tipsPerSample];

				(* Join the count requests, accounting for the even box case *)
				countsToRequest = DeleteCases[Append[fullBoxRequests, remainderRequest], 0];

				(* make the necessary resources *)
				tipResources = Resource[
					Sample -> tipModel,
					Amount -> #,
					Name->ToString[Unique[]]
				]& /@ countsToRequest;

				(* expand out the resource list to index-match with the positions we need it in *)
				expandedTipResources = Flatten[Join[MapThread[ConstantArray, {tipResources, countsToRequest}]],1];

				(* make replacement rules for the original list using the positions of this tip model and the expanded resources *)
				resourceReplacementRules = MapThread[Rule, {countedTipPositions, expandedTipResources}];

				(* do the replacement and return the list updated with resources for this counted tip model *)
				ReplacePart[currentTips, resourceReplacementRules]
			]
		],
		allPipetteTipModels,
		uniqueTipsToUse
	];

	(* "un-Riffle" the list that now has resources; it's in the form {acidTips,baseTips,acidTips, etc.} and we want to separate *)
	acidBaseTipTuples = Partition[pipetteTipsWithCountedResources, 2];
	acidTips = acidBaseTipTuples[[All, 1]];
	baseTips = acidBaseTipTuples[[All, 2]];

	(* if the tips are not counted, we till don't have Resources on them; each model needs a new thing; just wrap resource if not there already  *)
	acidTipResources = If[!MatchQ[#, _Resource],
		Resource[Sample -> #, Name->ToString[Unique[]]],
		#
	]& /@ acidTips;
	baseTipResources = If[!MatchQ[#, _Resource],
		Resource[Sample -> #, Name->ToString[Unique[]]],
		#
	]& /@ baseTips;

	pHPipettes=pipetForTips/@pipetteTipModels;
	pHPipetteResourceLookup=Map[
		#->Resource[Instrument->#,Name->ToString[Unique[]]]&,
		DeleteDuplicates[pHPipettes]
	];
	pHPipetteResources=Lookup[pHPipetteResourceLookup,#]&/@pHPipettes;

	pHMixer=Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"];

	pHPrepContainerResources=PickList[preparatoryContainerResources, resolvedpHs, NumericP];
	pHImpellerResources=Map[
		(* Remove Link wrapper than pull out container (under Sample key) *)
		With[{impeller=compatibleImpeller[First[#][Sample],pHMixer]},
			If[MatchQ[impeller,Null],
				Null,
				Resource[Sample->impeller]
			]
		]&,
		numReplicatesExpander[pHPrepContainerResources]
	];
	*)

	(* if any stock solution models are being prepared for the first time, they will have no TotalVolume; put these in VolumeMeasurementSolutions to indicate we must measure them;
	 	things that are fill-to-volume will have total volume; they'll also get volume measured, but in a diff way *)
	volumeMeasurementSolutionPackets = Select[stockSolutionModelPackets, NullQ[#] || NullQ[Lookup[#, TotalVolume]]&];

	(* get the fill to volume models/method/solvent; this might include Nulls that will get populated with the sample later *)
	groupedFillToVolumeValues = MapThread[
		Which[
			NullQ[#1] && NullQ[#2], {Null, Null, Null},
			NullQ[#1] && MatchQ[#2, ObjectP[]], {Null, #2, #3},
			NullQ[Lookup[#1, FillToVolumeSolvent]], {Null, Null, Null},
			NullQ[#2] && Not[NullQ[#1]], {#1, Lookup[#1, FillToVolumeSolvent], #3},
			True, {#1, #2, #3}
		]&,
		{stockSolutionModelPackets, mySolvents, Lookup[expandedResolvedOptions, FillToVolumeMethod]}
	];
	{fillToVolumeSolutionPackets, fillToVolumeSolvents, fillToVolumeMethods} = Transpose[groupedFillToVolumeValues];


	(* -- Autoclave Batching -- *)
	autoclaveSamples=numReplicatesExpander[PickList[stockSolutionModelPackets, resolvedAutoclaveBools, True]];
	autoclaveSampleContainerOut=numReplicatesExpander[PickList[containerOutPackets, resolvedAutoclaveBools, True]];
	autoclavePrograms=numReplicatesExpander[PickList[resolvedAutoclavePrograms, resolvedAutoclaveBools, True]];

	(* Note: I could not find a way to do this functionally in MM so I am doing it imperatively. *)

	(* Get the list of our samples with their area. *)
	autoclaveSamplesWithArea=MapThread[
		Function[{sample, autoclaveProgram, containerOut},
			{sample, autoclaveProgram, Lookup[containerOut, Dimensions][[1]] * Lookup[containerOut, Dimensions][[2]]}
		],
		{autoclaveSamples, autoclavePrograms, autoclaveSampleContainerOut}
	];

	(* We will be popping off of autoclaveSamplesWithArea and pushing onto batchedAutoclaveSamples in lists of lists. *)
	(* We are trying to create batches that are under 0.25 Meter^2 is total *)
	batchedAutoclaveSamples = {};
	Module[{currentTotal, currentList, nextElement},
		currentTotal = 0 Meter^2;
		currentList = {};

		While[Length[autoclaveSamplesWithArea] > 0,

			nextElement = First[autoclaveSamplesWithArea];

			(* Note: 0.25 Meter^2 is also hardcoded in Autoclave so we copy the hardcoding here. *)
			If[currentTotal + nextElement[[3]] > 0.25 Meter^2,
				currentTotal = 0 Meter^2;
				AppendTo[batchedAutoclaveSamples, currentList];
				currentList = {},

				currentTotal = currentTotal + nextElement[[3]];
				autoclaveSamplesWithArea = Rest[autoclaveSamplesWithArea];
				AppendTo[currentList, {nextElement[[1]], nextElement[[2]]}];
			];
		];

		(* Catch any stragglers. *)
		If[!MatchQ[currentList, {}],
			AppendTo[batchedAutoclaveSamples, currentList]
		];
	];

	(* Get the batch lengths for these samples/programs. *)
	autoclaveBatchLengths=Length/@batchedAutoclaveSamples;

	(* generate the final ResolvedOptions for the protocol; collapse index-matched stuff for sure, and remove hiddens *)
	resolvedOptionsForProtocol = RemoveHiddenOptions[ExperimentStockSolution, CollapseIndexMatchedOptions[ExperimentStockSolution, myResolvedOptions, Messages -> False]];

	(* Before uploading the protocol, make sure that the storage condition given is valid. *)
	(* We resolve the storage condition to a symbol in order to upload it in the protocol object. *)
	samplesOutStorage = Lookup[expandedResolvedOptions, SamplesOutStorageCondition];

	(* get the units from all the formulas *)
	(* also if we have a solvent, just arbitrarily pick 1 Liter; this doesn't actually matter becasuse we're not making a resource for it directly anyway, but we need to distinguish from the case where we don't have any solvent *)
	(* need to do these NullQ shenanigans because if we have Null as the model, we don't want the messages that come with using Lookup on it *)
	allAmounts = Flatten[MapThread[
		If[(NullQ[#2] && MatchQ[#3, ObjectP[]]) || (Not[NullQ[#2]] && MatchQ[Lookup[#2, FillToVolumeSolvent], ObjectP[]]),
			{#1, 1 Liter},
			#1
		]&,
		{formulasWithUnits[[All, All, 1]], stockSolutionModelPackets, mySolvents}
	]];

	(* make resources _only_ for the Samples in SamplesIn (not the Models), and avoid it if you're using unitOperations (samplesIn will be empty) because MSP will take care of it all *)
	(* the reason for this is complicated, but the crux of it is that StockSolution doesn't make its own resources for components; SP sub does eventually.  Thus, we don't want to double-count *)
	(* we _need_ to double count for specified samples, though, because in those cases SP will otherwise _not_ make a resource for the specified sample because RequireResources doesn't make resources for sample objects if it's in a Subprotocol *)
	samplesInResources = If[Length[mySamplesIn]>0,
		MapThread[
			If[MatchQ[#1, ObjectP[Model[Sample]]],
				Link[#1, Protocols],
				Link[Resource[Sample -> #1, Amount -> #2, Name->ToString[Unique[]]], Protocols]
			]&,
			{mySamplesIn, allAmounts}
		]
	];

	(* calculate the length of time we're going to use in the Combining and Dosing checkpoints *)
	combiningTime = Total[Cases[Append[Lookup[expandedResolvedOptions,MixTime],5 Minute],GreaterP[0 Minute]]]+Total[Cases[Append[Join[Lookup[expandedResolvedOptions,IncubationTime],Lookup[expandedResolvedOptions,AnnealingTime]],5 Minute],GreaterP[0 Minute]]]+Length[filteredSolutionPackets]*15 Minute;
	dosingTime = Length[Flatten[MapThread[
		If[NullQ[#1],
			#2,
			Lookup[#1, Formula]
		]&,
		{stockSolutionModelPackets, myFormulaSpecs}
	][[All,All,2]]]]*15 Minute;

	(* Download the Object from the formula components so that we don't put links in *)
	formulaSpecsNoLinks = Map[
		{#[[1]], Download[#[[2]], Object]}&,
		myFormulaSpecs,
		{2}
	];

	(*logic to transfer out MaxVolume of the ContainersOut:*)
	(*get requested volumes*)
	requestedVolumes=numReplicatesExpander[Lookup[expandedResolvedOptions,Volume]];

	(*get preparatory volumes*)
	preparatoryVolumes=numReplicatesExpander[myPreparationVolumes];

	(*get MaxVolume of ContainersOut*)
	containerOutMaxVolumes=numReplicatesExpander@Lookup[containerOutPackets,MaxVolume];

	(*check if PreparatoryVolumes exceed max ContainersOut volume*)
	volumeAboveContainerOutMaxQ=MapThread[#1>#2&,{preparatoryVolumes,containerOutMaxVolumes}];

	(*Transfer max ContainerOut volume,if PreparatoryVolume exceeds it. Otherwise transfer requestedVolume*)
  	newRequestedVolumes=MapThread[If[#3,#2,#1]&,{requestedVolumes,containerOutMaxVolumes,volumeAboveContainerOutMaxQ}];

	(* Resource for GellingAgents *)
	gellingAgents = Lookup[expandedResolvedOptions,GellingAgents];

	gellingAgentsResources=
		If[NullQ[gellingAgents] || MatchQ[gellingAgents,ListableP[None]],
			Null,
			MapThread[
				Function[
					{gellingAgent,volume},
					Resource[
						Sample -> First[gellingAgent][[2]],
						Amount -> First[gellingAgent][[1]] * volume
					]
				],
			{gellingAgents,preparatoryVolumes}
		]
	];

	stirBarResource = Map[
		If[NullQ[#],
			Null,
			Resource[Sample->#, Name->ToString[Unique[]], Rent->True]
		]&,
		Lookup[expandedResolvedOptions, StirBar]
	];

	mediaPhases = Lookup[expandedResolvedOptions, MediaPhase];

	heatSensitiveReagents = First[Lookup[expandedResolvedOptions, HeatSensitiveReagents]];

	(* create the protocol packet *)
	protocolID=CreateID[Object[Protocol,StockSolution]];
	protocolPacket=<|
		(* organizational *)
		Object -> protocolID,
		Type->Object[Protocol, StockSolution],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsForProtocol,
		MaxNumberOfOverfillingRepreparations -> Lookup[myResolvedOptions, MaxNumberOfOverfillingRepreparations],
		(* UploadProtocol should probably handle this *)
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],

		(* core stock solution fields *)
		Replace[StockSolutionModels] -> numReplicatesExpander[Link[stockSolutionModelPackets]],
		Replace[DensityScouts]-> Link[numReplicatesExpander[myDensityScouts]],
		Replace[PreparatoryVolumes] -> preparatoryVolumes,
		Replace[RequestedVolumes] -> newRequestedVolumes,

		(* fill-to-volume *)
		(* note that this field is index matching with StockSolutionModels here, but will NOT be after the compiler (this is because we need the index matching for keeping track of the samples-without-models until the compiler, at which point we will know the sample ID, but thereafter can't have Nulls) *)
		Replace[FillToVolumeSamples] -> numReplicatesExpander[Link[fillToVolumeSolutionPackets]],
		Replace[FillToVolumeSolvents] -> numReplicatesExpander[Link[fillToVolumeSolvents]],
		Replace[FillToVolumeMethods] -> numReplicatesExpander[fillToVolumeMethods],

		(* containers; these are Resources;still need Link to avoid ambiguous relation for ContainersOut *)
		(* NOTE: if PrepareInResuspensionContainer->True, PreparatoryContainers and ContainersOut will be populated in compiler, which is the original container of the resource picked fixed amount components *)
		Replace[PreparatoryContainers] -> Flatten[preparatoryContainerResources],
		Replace[ContainersOut] -> (Link /@ Flatten[finalContainerResources]),

		(* mixing information *)
		Replace[MixedSolutions] -> numReplicatesExpander[Link[mixedSolutionPackets]],
		Replace[MixParameters] -> numReplicatesExpander[mixParametersNew],
		Replace[PostAutoclaveMixedSolutions] -> numReplicatesExpander[Link[postAutoclaveMixedSolutionPackets]],
		Replace[PostAutoclaveMixParameters] -> numReplicatesExpander[postAutoclaveMixParametersNew],

		(* pHing information *)
		Replace[pHingSamples] -> numReplicatesExpander[Link[pHingSolutionPackets]],
		Replace[NominalpHs] -> numReplicatesExpander[nominalpHs],
		Replace[MinpHs] -> numReplicatesExpander[minpHs],
		Replace[MaxpHs] -> numReplicatesExpander[maxpHs],

		(* Acids, Bases, Meters, Tips are all Resources, don't need Link *)
		Replace[pHingAcids] -> numReplicatesExpander[pHingAcidResources],
		Replace[pHingBases] -> numReplicatesExpander[pHingBaseResources],

		(* Autoclave Parameters *)
		(* Note: We expanded th autoclave things above to calculate the batch lengths. *)
		Replace[AutoclaveSamples] -> Link[autoclaveSamples],
		Replace[AutoclavePrograms] -> autoclavePrograms,
		Replace[AutoclaveBatchLengths] -> autoclaveBatchLengths,

		(* filtration stuff *)
		Replace[FiltrationSamples] -> numReplicatesExpander[Link[filteredSolutionPackets]],
		Replace[FiltrationParameters] -> numReplicatesExpander[filtrationParameters],
		PreFiltrationImage->Lookup[myResolvedOptions,PreFiltrationImage],

		(* miscellaneous method fields *)
		Replace[SamplesIn] -> numReplicatesExpander[samplesInResources/. Null->{}],
		Replace[FixedAmountsComponents] -> numReplicatesExpander[fixedAliquotResources],
		(* note that this field is index matching with StockSolutionModels here, but will NOT be after the compiler (this is because we need the index matching for keeping track of the samples-without-models until the compiler, at which point we will know the sample ID, but thereafter can't have Nulls) *)
		Replace[VolumeMeasurementSolutions] -> numReplicatesExpander[Link[volumeMeasurementSolutionPackets]],
		ImageSample -> Lookup[myResolvedOptions, ImageSample],
		MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
		MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
		Replace[SamplesOutStorage] -> numReplicatesExpander[samplesOutStorage],

		(* media stuff *)
		Replace[GellingAgents] -> Link/@gellingAgentsResources,
		Replace[HeatSensitiveReagents] -> Link/@heatSensitiveReagents,
		MediaPhase -> First[mediaPhases],
		Replace[StirBar] -> Link/@stirBarResource,

		(* hidden options *)
		(* this Preparation link is SUUUUUPER important for Engine to finish Resource Picking properly;
		 	assume that if prepared resources was sent in, it indexed to the models*)
		Replace[PreparedResources]->numReplicatesExpander[Link[myPreparedResourcePackets,Preparation]],

		(* put Operator option in last index? Cam's not sure how it works so leaving Null... *)
		Replace[Checkpoints]->{
			{"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 15*Minute]]},
			{"Dosing",dosingTime,"The component materials are measured out.",Link[Resource[Operator -> $BaselineOperator, Time -> dosingTime]]},
			{"Combining",combiningTime,"The components are mixed, incubated, pH-titrated, and filtered.",Link[Resource[Operator -> $BaselineOperator, Time -> combiningTime]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]}
		},

		(* populate NumberOfReplicates*)
		NumberOfReplicates -> numReplicates
	|>;

	(* get all the resource blo---sorry, "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site]],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Which[
		MemberQ[output, Options] && !NullQ[mediaPhases],
			Normal[KeyDrop[CollapseIndexMatchedOptions[ExperimentStockSolution, myResolvedOptions, Messages -> False], Cache],Association],
		MemberQ[output, Options],
			resolvedOptionsForProtocol,
		True,
			Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* get the packets to send to the second argument of UploadProtocol; delete duplicates and cases where it's not updating anything *)
	extraPackets = Cases[myStockSolutionModels, PacketP[]];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		Flatten[{protocolPacket, extraPackets}],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolutionOptions*)


DefineOptions[ExperimentStockSolutionOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>(Table|List)],
			Description->"Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentStockSolution}
];

(*
	--- OVERLOAD 1: Single Model
		- Passes to OVERLOAD 2
*)
ExperimentStockSolutionOptions[myModelStockSolution:ObjectP[stockSolutionModelTypes],myOptions:OptionsPattern[ExperimentStockSolutionOptions]]:=ExperimentStockSolutionOptions[{myModelStockSolution},myOptions];

(*
	--- OVERLOAD 2 (MODELS CORE): List of Models
*)
ExperimentStockSolutionOptions[myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..},myOptions:OptionsPattern[ExperimentStockSolutionOptions]]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=ExperimentStockSolution[myModelStockSolutions,Append[optionsWithoutOutput,Output->Options]];

	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions or valid lengths failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[Normal[resolvedOptions,Association],ExperimentStockSolution],
			resolvedOptions
		]
	]
];



(*
	--- OVERLOAD 3: Complete Formula Overload (singleton)
		- Passes to FORMULA CORE
*)
ExperimentStockSolutionOptions[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[{myFormulaSpec},{Null},{Null},myOptions];


(*
	--- OVERLOAD 3.2: Complete Formula Overload (listable)
		- Passes to FORMULA CORE
*)
ExperimentStockSolutionOptions[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[myFormulaSpecs,ConstantArray[Null, Length[myFormulaSpecs]],ConstantArray[Null, Length[myFormulaSpecs]],myOptions];



(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume, singleton)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionOptions[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[{myFormulaSpec},{mySolvent},{myFinalVolume},myOptions];

(*
	--- OVERLOAD 4.2: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionOptions[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}] | Null)..},
	myFinalVolumes:{(VolumeP | Null)..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[myFormulaSpecs,mySolvents,myFinalVolumes,myOptions];

(*
	--- OVERLOAD 4.3: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable in formula only)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionOptions[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[myFormulaSpecs, ConstantArray[mySolvent, Length[myFormulaSpecs]], ConstantArray[myFinalVolume, Length[myFormulaSpecs]], myOptions];


(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume)
*)
ExperimentStockSolutionOptions[
	myFormulaSpecs:{{{VolumeP|MassP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}]|Null)..},
	myFinalVolumes:{(VolumeP|Null)..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=ExperimentStockSolution[myFormulaSpecs,mySolvents,myFinalVolumes,Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions or valid lengths failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[Normal[resolvedOptions,Association],ExperimentStockSolution],
			resolvedOptions
		]
	]
];

(*
	--- OVERLOAD 5: UnitOperations Overload - singleton
		- Passes to ExperimentStockSolution
*)
ExperimentStockSolutionOptions[
	myUnitOperations:{SamplePreparationP..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=ExperimentStockSolutionOptions[{myUnitOperations}, myOptions];


(*
	--- OVERLOAD 5: UnitOperations Overload - listable
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionOptions[
	myUnitOperations:{{SamplePreparationP..}..},
	myOptions:OptionsPattern[ExperimentStockSolutionOptions]
]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=ExperimentStockSolution[myUnitOperations,Append[optionsWithoutOutput,Output->Options]];
	resolvedOptions = DeleteCases[resolvedOptions,(Cache->_)|(Simulation->_)];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions or valid lengths failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[Normal[resolvedOptions,Association],ExperimentStockSolution],
			resolvedOptions
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentStockSolutionQ*)


DefineOptions[ValidExperimentStockSolutionQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentStockSolution}
];

(*
	--- OVERLOAD 1: Single Model
		- Passes to OVERLOAD 2
*)
ValidExperimentStockSolutionQ[myModelStockSolution:ObjectP[stockSolutionModelTypes],myOptions:OptionsPattern[ValidExperimentStockSolutionQ]]:=ValidExperimentStockSolutionQ[{myModelStockSolution},myOptions];

(*
	--- OVERLOAD 2 (MODELS CORE): List of Models
*)
ValidExperimentStockSolutionQ[myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..},myOptions:OptionsPattern[ValidExperimentStockSolutionQ]]:=Module[
	{listedOptions,optionsWithoutOutput,tests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)|(Verbose->_)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests = ExperimentStockSolution[myModelStockSolutions,Append[optionsWithoutOutput,Output->Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose,outputFormat}=OptionValue[{Verbose,OutputFormat}];

	(* Run the tests as requested *)
	(* quieting LinkObject messages because for some reason we're getting phantom errors on unit tests and I can't reproduce why.  Quieting here to not get recurring error messages and will revisit later  *)
	(* see here for more information: https://app.asana.com/0/1107873226358239/1113414016713291 *)
	Lookup[RunUnitTest[<|"ValidExperimentStockSolutionQ"->tests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentStockSolutionQ"]
];

(*
	--- OVERLOAD 3: Complete Formula Overload (singleton)
		- Passes to FORMULA CORE
*)
ValidExperimentStockSolutionQ[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[{myFormulaSpec},{Null},{Null},myOptions];


(*
	--- OVERLOAD 3.2: Complete Formula Overload (listable)
		- Passes to FORMULA CORE
*)
ValidExperimentStockSolutionQ[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[myFormulaSpecs,ConstantArray[Null, Length[myFormulaSpecs]],ConstantArray[Null, Length[myFormulaSpecs]],myOptions];



(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume, singleton)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ValidExperimentStockSolutionQ[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[{myFormulaSpec},{mySolvent},{myFinalVolume},myOptions];

(*
	--- OVERLOAD 4.2: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ValidExperimentStockSolutionQ[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}] | Null)..},
	myFinalVolumes:{(VolumeP | Null)..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[myFormulaSpecs,mySolvents,myFinalVolumes,myOptions];

(*
	--- OVERLOAD 4.3: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable in formula only)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ValidExperimentStockSolutionQ[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[myFormulaSpecs, ConstantArray[mySolvent, Length[myFormulaSpecs]], ConstantArray[myFinalVolume, Length[myFormulaSpecs]], myOptions];

(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume)
*)
ValidExperimentStockSolutionQ[
	myFormulaSpecs:{{{VolumeP|MassP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}]|Null)..},
	myFinalVolumes:{(VolumeP|Null)..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=Module[
	{listedOptions,optionsWithoutOutput,tests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	tests = ExperimentStockSolution[myFormulaSpecs, mySolvents, myFinalVolumes, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat} = OptionValue[{Verbose, OutputFormat}];

	(* Run the tests as requested *)
	(* quieting LinkObject messages because for some reason we're getting phantom errors on unit tests and I can't reproduce why.  Quieting here to not get recurring error messages and will revisit later  *)
	Lookup[RunUnitTest[<|"ValidExperimentStockSolutionQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentStockSolutionQ"]
];


(*
	--- OVERLOAD 5: UnitOperations Overload - singleton
		- Passes to ExperimentStockSolution
*)
ValidExperimentStockSolutionQ[
	myUnitOperations:{SamplePreparationP..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=ValidExperimentStockSolutionQ[{myUnitOperations}, myOptions];


(*
	--- OVERLOAD 5: UnitOperations Overload - listable
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ValidExperimentStockSolutionQ[
	myUnitOperations:{{SamplePreparationP..}..},
	myOptions:OptionsPattern[ValidExperimentStockSolutionQ]
]:=Module[
	{listedOptions,optionsWithoutOutput,tests,verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* since Output option is in UploadStockSolution options, we want to ignore that if present somehow *)
	optionsWithoutOutput = DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	tests = ExperimentStockSolution[myUnitOperations, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat} = OptionValue[{Verbose, OutputFormat}];

	(* Run the tests as requested *)
	(* quieting LinkObject messages because for some reason we're getting phantom errors on unit tests and I can't reproduce why.  Quieting here to not get recurring error messages and will revisit later  *)
	Lookup[RunUnitTest[<|"ValidExperimentStockSolutionQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentStockSolutionQ"]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolutionPreview*)


DefineOptions[ExperimentStockSolutionPreview,
	SharedOptions:>{ExperimentStockSolution}
];

(*
	--- OVERLOAD 1: Single Model
		- Passes to OVERLOAD 2
*)
ExperimentStockSolutionPreview[myModelStockSolution:ObjectP[stockSolutionModelTypes],myOptions:OptionsPattern[ExperimentStockSolutionPreview]]:=ExperimentStockSolutionPreview[{myModelStockSolution},myOptions];

(*
	--- OVERLOAD 2 (MODELS CORE): List of Models
*)
ExperimentStockSolutionPreview[myModelStockSolutions:{ObjectP[stockSolutionModelTypes]..},myOptions:OptionsPattern[ExperimentStockSolutionPreview]]:=Module[
	{listedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* add back in explicitly just the Preview Output option for passing to core function to get just preview *)
	ExperimentStockSolution[myModelStockSolutions,Append[listedOptions,Output->Preview]]
];

(*
	--- OVERLOAD 3: Complete Formula Overload (singleton)
		- Passes to FORMULA CORE
*)
ExperimentStockSolutionPreview[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[{myFormulaSpec},{Null},{Null},myOptions];


(*
	--- OVERLOAD 3.2: Complete Formula Overload (listable)
		- Passes to FORMULA CORE
*)
ExperimentStockSolutionPreview[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[myFormulaSpecs,ConstantArray[Null, Length[myFormulaSpecs]],ConstantArray[Null, Length[myFormulaSpecs]],myOptions];


(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume, singleton)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionPreview[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[{myFormulaSpec},{mySolvent},{myFinalVolume},myOptions];

(*
	--- OVERLOAD 4.2: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionPreview[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}] | Null)..},
	myFinalVolumes:{(VolumeP | Null)..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[myFormulaSpecs,mySolvents,myFinalVolumes,myOptions];

(*
	--- OVERLOAD 4.3: Formula Overload with FillToVolumeSolvent (Fill to Volume, listable in formula only)
		- FillToVolumeSolvent is Required
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionPreview[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[myFormulaSpecs, ConstantArray[mySolvent, Length[myFormulaSpecs]], ConstantArray[myFinalVolume, Length[myFormulaSpecs]], myOptions];

(*
	--- OVERLOAD 4: Formula Overload with FillToVolumeSolvent (Fill to Volume)
*)
ExperimentStockSolutionPreview[
	myFormulaSpecs:{{{VolumeP|MassP|GreaterP[0,1.], ObjectP[{Model[Sample], Object[Sample]}]}..}..},
	mySolvents:{(ObjectP[{Model[Sample]}]|Null)..},
	myFinalVolumes:{(VolumeP|Null)..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=Module[
	{listedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* add back in explicitly just the Preview Output option for passing to core function to get just preview *)
	ExperimentStockSolution[myFormulaSpecs,mySolvents,myFinalVolumes,Append[listedOptions,Output->Preview]]
];


(*
	--- OVERLOAD 5: UnitOperations Overload - singleton
		- Passes to ExperimentStockSolution
*)
ExperimentStockSolutionPreview[
	myUnitOperations:{SamplePreparationP..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=ExperimentStockSolutionPreview[{myUnitOperations}, myOptions];


(*
	--- OVERLOAD 5: UnitOperations Overload - listable
		- Passes to FORMULA CORE (which does not require solvent because of Overload 3)
*)
ExperimentStockSolutionPreview[
	myUnitOperations:{{SamplePreparationP..}..},
	myOptions:OptionsPattern[ExperimentStockSolutionPreview]
]:=Module[
	{listedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* add back in explicitly just the Preview Output option for passing to core function to get just preview *)
	ExperimentStockSolution[myUnitOperations,Append[listedOptions,Output->Preview]]
];

(* helper function: stockSolutionCreateDummySamples *)
(* Purpose of this one is we need to do a work-around for CCD. In CCD user has to add UOs one by one and so when they add the first LabelSample UO, they have to calculate and verify *)
(* However, that will break because there's no transfer into that labeled container, thus there's no Contents in this simulatedContainer *)
(* Use the helper below to make a dummy sample *)
stockSolutionCreateDummySamples[mySimulatedContainer:ObjectP[Object[Container]], mySimulatedPackets_]:= Module[{samplePacket, maxVolume, contents, emptyContainerQ, volumeToUse, currentProtocol},

	(*get the sample in that container and its volume*)
	{contents, maxVolume, currentProtocol} =  Download[mySimulatedContainer, {Contents, Model[MaxVolume], CurrentProtocol[Object]},Simulation -> mySimulatedPackets];

	(* Here we need to do a work-around for CCD. In CCD user has to add UOs one by one and so when they add the first LabelSample UO, they have to calculate and verify *)
	(* However, that will break because there's transfer into that labeled container, thus there's no Contents in this simulatedContainer *)
	emptyContainerQ = MatchQ[$ECLApplication, CommandCenter] && MatchQ[contents, {}];

	If[!emptyContainerQ,
		Return[mySimulatedPackets]
	];

	volumeToUse = If[NullQ[maxVolume], Null, 0.01 * maxVolume];

	samplePacket = UploadSample[Model[Sample, "id:8qZ1VWNmdLBD"], {"A1", mySimulatedContainer}, Simulation -> mySimulatedPackets, InitialAmount -> volumeToUse, UpdatedBy -> currentProtocol, Upload -> False];

	UpdateSimulation[mySimulatedPackets, Simulation[samplePacket]]

];
