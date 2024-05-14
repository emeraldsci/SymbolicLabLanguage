(* ::Package:: *)
(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)
(* Gelling agents lookup list *)
gellingAgentsLookupList = {
	Model[Sample,"Agar"]
};

DefineOptions[ExperimentMedia,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"media",
			(* ExperimentMedia options *)
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
				]
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
				ResolutionDescription->"Automatically set to {Model[Sample, \"Agar\"], 20*Gram/Liter} if MediaPhase is set to Solid. If any GellingAgent is detected in the Formula field of Model[Sample,Media], it will be removed from the Formula and ."
			},
			{
				OptionName->MediaPhase,
				Default->Automatic,
				Description->"The physical state of the prepared media at ambient temperature and pressure. This may be Solid (for conventional plate media), liquid, or semisolid (with lower gelling agent concentration).",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[MediaPhaseP]
				],
				ResolutionDescription->"Automatically set to Liquid if GellingAgents is not specified."
			},
			(* sister options from ExperimentStockSolution *)
			{
				OptionName->OrderOfOperations,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					Widget[Type->Enumeration,Pattern:>Alternatives[FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration]]
				],
				Description->"The order in which solution preparation steps will be carried out to create the media. By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped.",
				ResolutionDescription->"By default, the order is {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration}. FixedReagentAddition must always be first, Incubation/Mixing must always occur after FillToVolume/pHTitration and Filtration must always occur last. The FillToVolume/pHTitration stages are allowed to be swapped. When using a UnitOperations input, set to Null.",
				Category->"Preparation"
			},
			{
				OptionName->Volume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$MinStockSolutionComponentVolume,$MaxStockSolutionComponentVolume],
					Units->{Liter,{Microliter, Milliliter, Liter}}
				],
				Description->"The volume of the media model that should be prepared. Formula component amounts will be scaled according to the TotalVolume specified in the media model if this Volume differs from the model's TotalVolume. This option is not be used with the direct formula definition.",
				ResolutionDescription->"Automatically set to the TotalVolume field of the media, or to the sum of the volumes of any liquid formula components if the TotalVolume is unknown for a first-time preparation of a media.",
				Category->"Preparation"
			},
			{
				OptionName->FillToVolumeMethod,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FillToVolumeMethodP
				],
				Description->"The method by which to add the Solvent specified in the media model to the bring the media up to the TotalVolume specified in the media model.",
				ResolutionDescription->"Automatically set to Null if there is no Solvent/TotalVolume. Otherwise, will resolved based on the FillToVolumeMethod in the given Model[Sample,Media].",
				Category->"Preparation"
			},
			{
				OptionName->PrepareInResuspensionContainer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicate if the media should be prepared in the original container of the FixedAmount component in its formula. PrepareInResuspensionContainer cannot be True if there is no FixedAmount component in the formula, and it is not possible if the specified amount does not match the component's FixedAmount.",
				ResolutionDescription->"Automatically set to False unless otherwise specified.",
				Category->"Preparation"
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
				Category -> "Preparation"
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

			(* --- Incubation --- *)
			{
				OptionName->Incubate,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media should be treated at a specified temperature following component combination and filling to volume with solvent.  May be used in conjunction with mixing.",
				ResolutionDescription->"Automatically set to True if any other incubate options are specified, or, if a template model is provided, set based on whether that template has incubation parameters.",
				Category->"Incubation"
			},
			{
				OptionName->Incubator,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
				],
				Description->"The instrument that should be used to treat the media at a specified temperature following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set to an appropriate instrument based on container model, or Null if Incubate is set to False.",
				Category->"Incubation"
			},
			{
				OptionName->IncubationTemperature,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[22 Celsius,$MaxIncubationTemperature],
					Units->Alternatives[Fahrenheit,Celsius]
				],
				Description->"Temperature at which the media should be treated for the duration of the IncubationTime following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set to the maximum temperature allowed for the incubator and container, 37 Celsius if the sample is being incubated, or Null if Incubate is set to False.",
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
				Description->"Duration for which the media should be treated at the IncubationTemperature following component combination and filling to volume with solvent.  Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the MixTime option.",
				ResolutionDescription->"Automatically set to 0.5 Hour if Incubate is set to True and Mix is set to False, or Null otherwise.",
				Category->"Incubation"
			},
			{
				OptionName->AnnealingTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute, $MaxExperimentTime],
					Units->{1,{Minute,{Minute,Hour}}}
				],
				Description->"Minimum duration for which the media should remain in the incubator allowing the solution and incubator to return to room temperature after the MixTime has passed if mixing while incubating.",
				ResolutionDescription->"Automatically set to 0 Minute, or Null if Incubate is set to False.",
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
				Description->"Indicates if the components of the media should be mechanically incorporated following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set to True if a new media formula is provided, to True if an existing media model with mixing parameters is provided, and to False if the provided media model has no mixing parameters.",
				Category->"Mixing"
			},
			{
				OptionName->MixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>MixTypeP
				],
				Description->"The style of motion used to mechanically incorporate the components of the media following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set based on the Volume option and size of the container in which the media is prepared.",
				Category->"Mixing"
			},
			{
				OptionName->MixUntilDissolved,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the complete dissolution of any solid components should be verified following component combination, filling to volume with solvent, and any specified mixing steps.",
				Category->"Mixing"
			},
			{
				OptionName->Mixer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
				],
				Description->"The instrument that should be used to mechanically incorporate the components of the media following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set based on the MixType and the size of the container in which the media is prepared.",
				Category->"Mixing"
			},
			{
				OptionName->MixTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Hour,$MaxExperimentTime],
					Units->{1,{Minute,{Second,Minute,Hour}}}
				],
				Description->"The duration for which the media should be mixed following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set from the MixTime field of the media model. If the model has no preferred time, set to 3 minutes. If MixType is Pipette or Invert, set to Null. 0 minutes indicates no mixing. Note that if you are mixing AND incubating and this option is specified, it must be the same as the specified value of the IncubationTime option.",
				Category->"Mixing"
			},
			{
				OptionName->MaxMixTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Second,$MaxExperimentTime],
					Units->{1,{Minute,{Second,Minute,Hour}}}
				],
				Description->"The maximum duration for which the liquid media should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set based on the MixType if MixUntilDissolved is set to True. If MixUntilDissolved is False, set to Null.",
				Category->"Mixing"
			},
			{
				OptionName->MixRate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$MinMixRate,$MaxMixRate],
					Units->RPM
				],
				Description->"The frequency of rotation the mixing instrument should use to mechanically incorporate the components of the media following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set based on the MixType and the size of the container in which the solution is prepared.",
				Category->"Mixing"
			},
			{
				OptionName->NumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>RangeP[1, 50, 1]],
				Description->"The number of times the media should be mixed by inversion or repeatedly aspirated and dispensed using a pipette following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set to 10 when MixType is Pipette, 3 when MixType is Invert, or Null otherwise.",
				Category->"Mixing"
			},
			{
				OptionName->MaxNumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1, 50, 1]
				],
				Description->"The maximum number of times the media should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set based on the MixType if MixUntilDissolved is set to True, and to Null otherwise.",
				Category->"Mixing"
			},
			{
				OptionName->MixPipettingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter, 5 Milliliter],
					Units:>{1,{Milliliter,{Microliter,Milliliter}}}
				],
				Description->"The volume of the media that should be aspirated and dispensed with a pipette to mix the solution following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically set to 50% of the total media volume if MixType is Pipette, and Null otherwise.",
				Category->"Mixing"
			},
			{
				OptionName -> StirBar,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Indicates which model stir bar to be inserted to mix the stock solution prior to autoclave when HeatSensitiveReagents is not Null.",
				Widget -> Widget[Type->Object,
					Pattern :> ObjectP[Model[Part,StirBar],Object[Part,StirBar]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments","Mixing Devices", "Stir Bars"
						}
					}
				],
				Category -> "Mixing"
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
				Category->"Hidden"
			},
			{
				OptionName->PostAutoclaveIncubator,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]
				],
				Description->"The instrument that should be used to treat the stock solution at a specified temperature following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to an appropriate instrument based on container model, or Null if Incubate is set to False.",
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
			},
			{
				OptionName->PostAutoclaveNumberOfMixes,
				Default->Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Number, Pattern:>RangeP[1, 50, 1]],
				Description->"The number of times the stock solution should be mixed by inversion or repeatedly aspirated and dispensed using a pipette following component combination and filling to volume with solvent.",
				ResolutionDescription->"Automatically resolves to 10 when MixType is Pipette, 3 when MixType is Invert, or Null otherwise.",
				Category->"Hidden"
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
				Category->"Hidden"
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
				Category->"Hidden"
			},

			(* --- pH Titration --- *)
			{
				OptionName->AdjustpH,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the pH (measure of acidity or basicity) of this media should be adjusted after component combination, filling to volume with solvent, and/or mixing.",
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
				Description->"The pH to which this media should be adjusted following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set from the NominalpH field in the media.",
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
				Description->"The minimum allowable pH this media should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent and/or mixing.",
				ResolutionDescription->"Automatically set to the MinpH field of the media, to 0.1 below the resolved pH value if the media has no MinpH, or to Null if the pH option set to Null.",
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
				Description->"The maximum allowable pH this media should have after pH adjustment, where pH adjustment occurs following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set to the MaxpH field of the media, to 0.1 above the resolved pH value if the media has no MaxpH, or to Null if the pH option set to Null.",
				Category->"pH Titration"
			},
			{
				OptionName->pHingAcid,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Sample]]
				],
				Description->"The acid that should be used to lower the pH of the solution following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set based on the pHingAcid field in the media, to 6N HCl if the pH option is specified but the media has no pHingAcid, or to Null if the pH option is unspecified.",
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
				Description->"The base that should be used to raise the pH of the solution following component combination, filling to volume with solvent, and/or mixing.",
				ResolutionDescription->"Automatically set based on the pHingBase field in the media, to 1.85M NaOH if the pH option is specified but the media has no pHingBase, or to Null if the pH option is unspecified.",
				Category->"pH Titration"
			},

			(* --- Filter --- *)
			{
				OptionName->Filter,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media should be passed through a porous medium to remove solids or impurities following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to False if a new media formula is provided, to True if an existing media model with filtration parameters is provided, and to False if the provided media model has no filtration parameters.",
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
				Description->"The method that will be used to pass this media through a porous medium to remove solids or impurities following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to a method with the lowest dead volume given the volume of media being prepared.",
				Category->"Filtration"
			},
			{
				OptionName->FilterMaterial,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FilterMembraneMaterialP
				],
				Description->"The composition of the medium through which the media should be passed following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set from the FilterMaterial field of the media.",
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
				Description->"The size of the membrane pores through which the media should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set from the FilterSize field of the media.",
				Category->"Filtration"
			},
			{
				OptionName->FilterInstrument,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument,Centrifuge],Model[Instrument,SyringePump],Model[Instrument,PeristalticPump],Model[Instrument,VacuumPump]}]
				],
				Description->"The instrument that should be used to filter the media following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to an instrument appropriate to the volume of sample being filtered.",
				Category->"Filtration"
			},
			{
				OptionName->FilterModel,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,Plate, Filter],Model[Container,Vessel, Filter],Model[Item, Filter]}]
				],
				Description->"The model of filter that should be used to filter the media following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to a model of filter compatible with the FilterInstrument/FilterSyringe being used for the filtration.",
				Category->"Filtration"
			},
			{
				OptionName->FilterSyringe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container,Syringe]]
				],
				Description->"The syringe that should be used to force the media through a filter following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to a syringe appropriate to the volume of media being filtered.",
				Category->"Filtration"
			},
			{
				OptionName->FilterHousing,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Instrument,FilterHousing],
						Model[Instrument,FilterBlock]
					}]
				],
				Description->"The instrument that should be used to hold the filter membrane through which the media is filtered following component combination, filling to volume with solvent, mixing, and/or pH titration.",
				ResolutionDescription->"Automatically set to a housing capable of holding the size of the filter membrane being used.",
				Category->"Filtration"
			},
			{
				OptionName->Autoclave,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates that this media should be treated at an elevated temperature and pressure (autoclaved) once all components are added.",
				Category->"Autoclaving"
			},
			{
				OptionName->AutoclaveProgram,
				Default->Liquid,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>AutoclaveProgramP
				],
				Description->"Indicates the type of autoclave cycle to run. Liquid cycle is recommended for liquid samples, and Universal cycle is recommended for everything else.",
				Category->"Autoclaving"
			},

			{
				OptionName->ContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container]]
				],
				Description->"The container model in which the newly-made media sample will reside following all preparative steps.",
				ResolutionDescription->"Automatically selected from ECL's stocked containers based on the volume of solution being prepared.",
				Category->"Storage Information"
			},

			(* --- Formula ONLY options (keep consistent with UploadMedia!!!) --- *)

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
				Category->"Hidden"
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
				Description->"A list of possible alternate names that should be associated with this new media.",
				ResolutionDescription->"Automatically set to contain the Name of the the new media model if generating a new media model from formula input with a provided MediaName, or Null otherwise. Note that if no model will be created (i.e., if a sample without a model is used in the formula overload), this option will be ignored.",
				Category->"Organizational Information"
			},
			{
				OptionName->LightSensitive,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the media contains components that may be degraded or altered by prolonged exposure to light, and thus should be prepared in light-blocking containers when possible.",
				ResolutionDescription->"Automatically set based on the light sensitivity of the formula components and solvent if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Description->"Indicates if media prepared according to the provided formula expire over time.",
				ResolutionDescription->"Automatically set to True if generating a new media model from formula input, or to Null if preparing an existing media model.",
				Category->"Storage Information"
			},
			{
				OptionName->ShelfLife,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Day],Units->{1,{Month,{Hour,Day,Month,Year}}}
				],
				Description->"The duration of time after preparation that media prepared according to the provided formula are recommended for use before they should be discarded.",
				ResolutionDescription->"Automatically set to the shortest of any shelf lives of the formula components and solvent, or 5 years if none of the formula components expire. If Expires is set to False, set to Null. If preparing an existing media model, set to Null.",
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
				Description->"The duration of time after first use that media prepared according to the provided formula are recommended for use before they should be discarded.",
				ResolutionDescription->"Automatically set to the shortest of any unsealed shelf lives of the formula components and solvent, or Null if none of the formula components have recorded unsealed shelf lives. If Expires is set to False, set to Null. If preparing an existing media model, set to Null.",
				Category->"Storage Information"
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
					Widget[Type->Object,Pattern:>ObjectP[Model[StorageCondition]]]
				],
				Description->"The condition in which media prepared according to the provided formula are stored when not in use by an experiment.",
				ResolutionDescription->"Automatically set based on the default storage conditions of the formula components and any safety information provided for this new formula. If preparing an existing media model, set to Null.",
				Category->"New Formulation"
			},
			{
				OptionName->TransportChilled,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if media prepared according to the provided formula should be refrigerated during transport when used in experiments.",
				ResolutionDescription->"Automatically set to True if the new media's DefaultStorageCondition set to Refrigerator or Freezer, or False for AmbientStorage, unless TransportWarmed is specified, whereupon it set to Null. If preparing an existing media model, set to Null.",
				Category->"Storage Information"
			},
			{
				OptionName->TransportWarmed,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[27*Celsius,105*Celsius],
					Units->{1,{Celsius,{Celsius,Fahrenheit,Kelvin}}}
				],
				Description->"Indicates the temperature by which media prepared according to the provided formula should be heated during transport when used in experiments.",
				Category->"Storage Information"
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
				Description->"Indicates if media prepared according to the provided formula must be handled in a ventilated enclosure.",
				ResolutionDescription->"Automatically set to False if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Description->"Indicates if media prepared according to the provided formula are easily set aflame under standard conditions.",
				ResolutionDescription->"Automatically set to False if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Description->"Indicates if media prepared according to the provided formula are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically set to False if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Description->"Indicates if media prepared according to the provided formula are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
				ResolutionDescription->"Automatically set to False if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Description->"Indicates if media prepared according to the provided formula emit fumes spontaneously when exposed to air.",
				ResolutionDescription->"Automatically set to False if generating a new media model from formula input, or to Null if preparing an existing media model.",
				Category->"Health & Safety"
			},
			{
				OptionName->IncompatibleMaterials,
				Default->Automatic,
				AllowNull->True,
				Widget->With[{insertMe=Flatten[MaterialP]},Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[insertMe]]],
				Description->"A list of materials that would be damaged if contacted by this formulation.",
				ResolutionDescription->"Automatically set to None if generating a new media model from formula input, or to Null if preparing an existing media model.",
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
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			},

			(* ExperimentPlateMedia options *)
			{
				OptionName->PlateMedia,
				Default->Automatic,
				Description->"Indicates if the prepared media is subsequently transferred to plates for future use for cell incubation and growth.",
				AllowNull->False,
				Category->"Plating",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				ResolutionDescription->"Automatically set to True if MediaPhase is set to Solid or SemiSolid and/or if GellingAgents is specified."
			},
			{
				OptionName->PlateOut,
				Default->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				Description->"The types of plates into which the prepared media will be transferred.",
				AllowNull->False,
				Category->"Plating",
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
				],
				ResolutionDescription->"Automatically set to Model[Container, Plate, Omni Tray Sterile Media Plate]."
			},
			{
				OptionName->NumberOfPlates,
				Default->1,
				Description->"The number of plates to which the prepared media should be transferred.",
				AllowNull->True,
				Category->"Plating",
				Widget->Alternatives[
					Widget[
						Type->Number,
						Pattern:>GreaterEqualP[0]
					]
				]
			},
			{
				OptionName->PrePlatingIncubationTime,
				Default->1*Hour,
				Description->"The duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature.",
				AllowNull->True,
				Category->"Plating",
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
				Default->3*Hour,
				Description->"The maximum duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature. If the media is not liquid after the PrePlatingIncubationTime, it will be allowed to incubate further and checked in cycles of PrePlatingIncubationTime up to the MaxIncubationTime to see if it has become liquid and can thus be poured. If the media is not liquid after MaxPrePlatingIncubationTime, the plates will not be poured, and this will be indicated in the PouringFailed field in the protocol object.",
				AllowNull->True,
				Category->"Plating",
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
				],
				ResolutionDescription->"Automatically set to three times the duration of the PrePlatingIncubationTime setting."
			},
			{
				OptionName->PrePlatingMixRate,
				Default->100*RPM,
				Description->"The rate at which the stir bar within the liquid media is rotated prior to pumping the media into incubation plates.",
				AllowNull->True,
				Category->"Plating",
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
				Category->"Plating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[$AmbientTemperature,$MaxTemperatureProfileTemperature],
					Units->{1,{Celsius,{Celsius,Fahrenheit}}}
				]
			},
			{
				OptionName->PlatingVolume,
				Default->Null,
				Description->"The volume of liquid media transferred from its source container into each incubation plate.",
				AllowNull->True,
				Category->"Plating",
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
				Default->1*Hour,
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
				OptionName->SolidificationTime,
				Default->Null,
				Description->"The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				AllowNull->True,
				Category->"Plating",
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
			{
				OptionName->PlatedMediaShelfLife,
				Default->1*Week,
				Description->"The duration of time after which the prepared plates are considered to be expired.",
				AllowNull->False,
				Category->"Storage Information",
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Day],
						Units->{1,{Week,{Hour,Day,Week,Month,Year}}}
					]
				]
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"Number of times each of the inputs should be made using identical experimental parameters.",
			AllowNull->True,
			Category->"Protocol",
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2,1]]
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
			Description->"Resources in the ParentProtocol that will be satisfied by preparation of the requested models and volumes of media.",
			Category->"Hidden"
		},
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
		PostProcessingOptions,
		SamplesOutStorageOption,
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		SimulationOption
	}
];

(* Singleton overload for ExperimentMedia *)
ExperimentMedia[myMediaModel:ObjectP[Model[Sample,Media]],myOptions:OptionsPattern[ExperimentMedia]]:=ExperimentMedia[{myMediaModel},myOptions];

ExperimentMedia[
	myMediaModels:{ObjectP[Model[Sample,Media]]..},
	myOptions:OptionsPattern[ExperimentMedia]
]:=Module[{outputSpecification,listedOutput,gatherTests,mediaModelsWithoutTemporalLinks,optionsWithoutTemporalLinks,safeOptionsMediaWithNames,safeOptionsMediaTests,safeOptionsMedia,fastTrack,upload,unresolvedOptionsMedia,validLengths,validLengthTests,stockSolutionHiddenOptionNames,stockSolutionNonHiddenOptionNames,stockSolutionNonHiddenOptions,collapsedStockSolutionNonHiddenOptions,allUploadMediaOptionNames,allExperimentMediaOptionNames,stockSolutionHiddenMediaOptions,unresolvedUploadMediaOptions,allDownloads,mediaSets,cacheBall,resolvedUploadMediaOptionsResult,resolvedMediaInputs,resolvedUploadMediaOptions,resolvedUploadMediaTests,mediaName,resolvedUploadMediaOptionsWithMediaName,partiallyResolvedExperimentMediaOptions,applyTemplateOptionTests,unresolvedTemplatedOptionsMedia,expandedUnresolvedTemplatedOptionsExperimentMedia,experimentMediaResult,experimentMediaOptions},

	(* Determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{mediaModelsWithoutTemporalLinks, optionsWithoutTemporalLinks} = removeLinks[myMediaModels,ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsMediaWithNames,safeOptionsMediaTests} = If[gatherTests,
		SafeOptions[ExperimentMedia,optionsWithoutTemporalLinks,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[ExperimentMedia,optionsWithoutTemporalLinks,AutoCorrect->False],{}}
	];

	(* Replace the objects referenced by name to IDs *)
	safeOptionsMedia = sanitizeInputs[safeOptionsMediaWithNames];
	{fastTrack,upload} = Lookup[safeOptionsMedia,{FastTrack,Upload}];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptionsMedia, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->safeOptionsMediaTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMedia, {mediaModelsWithoutTemporalLinks}, safeOptionsMedia, Output->{Result, Tests}],
		{ValidInputLengthsQ[ExperimentMedia, {mediaModelsWithoutTemporalLinks}, safeOptionsMedia], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /.{
			Result->$Failed,
			Tests->Flatten[{safeOptionsMediaTests, validLengthTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptionsMedia,applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentMedia,{mediaModelsWithoutTemporalLinks},safeOptionsMedia,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMedia,{mediaModelsWithoutTemporalLinks},safeOptionsMedia],{}}
	];

	unresolvedTemplatedOptionsMedia = ReplaceRule[safeOptionsMedia,unresolvedOptionsMedia];

	expandedUnresolvedTemplatedOptionsExperimentMedia = Last[ExpandIndexMatchedInputs[ExperimentMedia,{mediaModelsWithoutTemporalLinks},unresolvedTemplatedOptionsMedia]];

	(* Split the expanded options into shared options for UploadMedia & everything else, so that we can resolve the UploadMedia options first *)
	stockSolutionNonHiddenOptions = RemoveHiddenOptions[ExperimentStockSolution,expandedUnresolvedTemplatedOptionsExperimentMedia];

	(* Re-collapse the ExperimentStockSolution options that got expanded during ExperimentMedia *)
	collapsedStockSolutionNonHiddenOptions = CollapseIndexMatchedOptions[ExperimentStockSolution, stockSolutionNonHiddenOptions, Messages->False];

	allUploadMediaOptionNames = Keys[SafeOptions[UploadMedia]];
	stockSolutionHiddenMediaOptions = UnsortedComplement[expandedUnresolvedTemplatedOptionsExperimentMedia,stockSolutionNonHiddenOptions];
	unresolvedUploadMediaOptions = Normal@KeyTake[stockSolutionHiddenMediaOptions,allUploadMediaOptionNames];

	allDownloads = Download[myMediaModels,
		{
			Packet[Name,Deprecated,Composition,Formula,Solvent,TotalVolume],
			Packet[MediaPhase,GellingAgents,PlateMedia],
			Packet[Formula[[All,2]][{Name,Deprecated,State,Density,DefaultStorageCondition,ShelfLife,UnsealedShelfLife,LightSensitive,Tablet,FixedAmounts,SingleUse,Resuspension,UltrasonicIncompatible,Ventilated,Flammable,Sterile,Fuming,IncompatibleMaterials,Acid,Base,Composition,Solvent,DefaultStorageCondition}]]
		}
	];
	mediaSets = Join[
		{myMediaModels},
		Transpose[Map[Lookup[#[[1]],{Formula,Solvent,TotalVolume}]&,allDownloads]]
	];
	cacheBall = Cases[Flatten[allDownloads],PacketP[]];

	resolvedUploadMediaOptionsResult = Check[
		{{resolvedMediaInputs,resolvedUploadMediaOptions},resolvedUploadMediaTests} = If[gatherTests,
			resolveUploadMediaOptions[mediaSets,ReplaceRule[unresolvedUploadMediaOptions,{Cache->cacheBall,Output->{Result,Tests}}]],
			{resolveUploadMediaOptions[mediaSets,ReplaceRule[unresolvedUploadMediaOptions,{Cache->cacheBall,Output->Result}]], {}}
		],
		$Failed,
		{Error::InvalidOption}
	];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[MatchQ[resolvedUploadMediaOptionsResult,$Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOptionsMediaTests,resolvedUploadMediaTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* UploadMedia's Name is Media's MediaName, so we have to swap that. Also get the output back the way it was. *)
	mediaName = Lookup[resolvedUploadMediaOptions,Name];
	resolvedUploadMediaOptionsWithMediaName = resolvedUploadMediaOptions/.{(Name->_)->(MediaName->mediaName), (Output->_)->(Output->listedOutput)};

	(* Sticking all UploadMedia options back into the hidden set of StockSolutions options, along with certain options that are always true in ExperimentStockSolution *)
	(* Also deleting some options that belong to upload functions and not experiment ones *)
	partiallyResolvedExperimentMediaOptions = Normal[
		KeyDrop[
			ReplaceRule[
				stockSolutionHiddenMediaOptions,
				Flatten[{resolvedUploadMediaOptionsWithMediaName,{Type->Media, Autoclave->True}}]
			],
			{UltrasonicIncompatible, PreferredContainers, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle, MaxpHingAdditionVolume, MaxNumberOfpHingCycles}
		],
		Association
	];

	{experimentMediaResult,experimentMediaOptions} = Module[{stockSolutionOptions,result,stockSolutionInputs,stockSolutionSolvents,stockSolutionTotalVolumes,trimmedSSOptions},

		(* Now we combine back our hidden and non-hidden options *)
		stockSolutionOptions = ReplaceRule[collapsedStockSolutionNonHiddenOptions,partiallyResolvedExperimentMediaOptions];

		(* UploadMedia adds some options that don't exist in ExperimentStockSolution - drop those before passing to SS *)
		trimmedSSOptions = CollapseIndexMatchedOptions[
			ExperimentStockSolution,
			Normal@KeyDrop[stockSolutionOptions,{Author,Composition,FulfillmentScale,NominalpH,Preparable,Resuspension,VolumeIncrements,StockSolutionTemplate,UltrasonicIncompatible, PreferredContainers, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle, MaxpHingAdditionVolume, MaxNumberOfpHingCycles}]
		];
		result = If[MatchQ[resolvedMediaInputs,{ObjectP[Model[Sample,Media]]..}],
			ExperimentStockSolution[resolvedMediaInputs,trimmedSSOptions],

			{stockSolutionInputs,stockSolutionSolvents,stockSolutionTotalVolumes} = Transpose[resolvedMediaInputs];
			ExperimentStockSolution[stockSolutionInputs, stockSolutionSolvents, stockSolutionTotalVolumes, trimmedSSOptions]
		];
		Which[
			MemberQ[listedOutput,Result]&&MemberQ[listedOutput,Options],
			result,

			MemberQ[listedOutput,Result]&&!MemberQ[listedOutput,Options],
			{result,$Failed},

			!MemberQ[listedOutput,Result]&&MemberQ[listedOutput,Options],
			{$Failed,result},

			True,
			{$Failed,$Failed}
		]
	];
	outputSpecification/.{Result->experimentMediaResult,Options->experimentMediaOptions}
];

(* Singleton formula Overload with FillToVolumeSolvent & FillToVolume *)
ExperimentMedia[
	myFormulaSpec:{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample], Object[Sample]}]}..},
	mySolvent:ObjectP[{Model[Sample]}],
	myFinalVolume:VolumeP,
	myOptions:OptionsPattern[ExperimentMedia]
]:=Module[{listedOptions},
	listedOptions = SafeOptions[ExperimentMedia,ToList[myOptions]];
	ExperimentMedia[{myFormulaSpec},{mySolvent},{myFinalVolume},listedOptions]
];

(* Listable formula overload with FillToVolumeSolvent & FillToVolume *)
ExperimentMedia[
	myFormulaSpecs:{{{MassP|VolumeP|GreaterP[0,1.],ObjectP[{Model[Sample],Object[Sample]}]}..}..},
	mySolvents:{ObjectP[Model[Sample]]..},
	myFinalVolumes:{VolumeP..},
	myOptions:OptionsPattern[ExperimentMedia]
]:=Module[{outputSpecification,listedOutput,gatherTests,formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,optionsWithoutTemporalLinks,safeOptionsMediaWithNames,safeOptionsMediaTests,safeOptionsMedia,fastTrack,cache,validLengths,validLengthTests,unresolvedOptionsMedia,applyTemplateOptionTests,unresolvedTemplatedOptionsMedia,expandedUnresolvedTemplatedOptionsExperimentMedia,stockSolutionHiddenOptionNames,stockSolutionNonHiddenOptionNames,stockSolutionNonHiddenOptions,collapsedStockSolutionNonHiddenOptions,allUploadMediaOptionNames,allExperimentMediaOptionNames,stockSolutionHiddenMediaOptions,unresolvedUploadMediaOptions,templateMediaModels,resolvedUploadMediaOptionsResult,resolvedMediaInputs,resolvedUploadMediaOptions,resolvedUploadMediaTests,partiallyResolvedExperimentMediaOptions,experimentMediaOptions,experimentMediaResult},

	(* Determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks},optionsWithoutTemporalLinks} = removeLinks[{myFormulaSpecs, mySolvents},ToList[myOptions]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsMediaWithNames,safeOptionsMediaTests} = If[gatherTests,
		SafeOptions[ExperimentMedia,optionsWithoutTemporalLinks,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[ExperimentMedia,optionsWithoutTemporalLinks,AutoCorrect->False],{}}
	];

	(* Replace the objects referenced by name to IDs, and expand the index-matched options *)
	safeOptionsMedia = sanitizeInputs[safeOptionsMediaWithNames];
	{fastTrack,cache} = Lookup[safeOptionsMedia,{FastTrack,Cache}];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptionsMedia, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->safeOptionsMediaTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMedia,{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,myFinalVolumes}, safeOptionsMedia, 2, Output->{Result, Tests}],
		{ValidInputLengthsQ[ExperimentMedia,{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,myFinalVolumes}, safeOptionsMedia, 2], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /.{
			Result->$Failed,
			Tests->Flatten[{safeOptionsMediaTests, validLengthTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptionsMedia,applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentMedia,{formulaSpecsWithoutTemporalLinks},safeOptionsMedia,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMedia,{formulaSpecsWithoutTemporalLinks},safeOptionsMedia],{}}
	];

	unresolvedTemplatedOptionsMedia = ReplaceRule[safeOptionsMedia,unresolvedOptionsMedia];

	expandedUnresolvedTemplatedOptionsExperimentMedia = Last[ExpandIndexMatchedInputs[ExperimentMedia,{formulaSpecsWithoutTemporalLinks,solventsWithoutTemporalLinks,myFinalVolumes},unresolvedTemplatedOptionsMedia,2]];

	(* Split the expanded options into shared options for UploadMedia & everything else, so that we can resolve the UploadMedia options first *)
	stockSolutionNonHiddenOptions = RemoveHiddenOptions[ExperimentStockSolution,expandedUnresolvedTemplatedOptionsExperimentMedia];

	(* Re-collapse the ExperimentStockSolution options that got expanded during ExperimentMedia *)
	collapsedStockSolutionNonHiddenOptions = CollapseIndexMatchedOptions[ExperimentStockSolution, stockSolutionNonHiddenOptions, Messages->False];

	allUploadMediaOptionNames = Keys[SafeOptions[UploadMedia]];
	stockSolutionHiddenMediaOptions = UnsortedComplement[expandedUnresolvedTemplatedOptionsExperimentMedia,stockSolutionNonHiddenOptions];
	unresolvedUploadMediaOptions = Normal@KeyTake[stockSolutionHiddenMediaOptions,allUploadMediaOptionNames];

	templateMediaModels = ConstantArray[Null,Length[myFormulaSpecs]];

	resolvedUploadMediaOptionsResult = Check[
		{{resolvedMediaInputs,resolvedUploadMediaOptions},resolvedUploadMediaTests} = If[gatherTests,
			resolveUploadMediaOptions[{templateMediaModels,myFormulaSpecs,mySolvents,myFinalVolumes},ReplaceRule[unresolvedUploadMediaOptions,{Output->{Result,Tests}}]],
			{resolveUploadMediaOptions[{templateMediaModels,myFormulaSpecs,mySolvents,myFinalVolumes},ReplaceRule[unresolvedUploadMediaOptions,{Output->Result}]], {}}
		],
		$Failed,
		{Error::InvalidOption}
	];

	partiallyResolvedExperimentMediaOptions = ReplaceRule[stockSolutionHiddenMediaOptions,resolvedUploadMediaOptions];

	{experimentMediaResult,experimentMediaOptions} = Module[{stockSolutionInputs,stockSolutionSolvents,stockSolutionTotalVolumes,stockSolutionOptions,trimmedSSOptions},
		stockSolutionOptions = ReplaceRule[collapsedStockSolutionNonHiddenOptions,
			ReplaceRule[partiallyResolvedExperimentMediaOptions,
				{
					Type->Media,
					Autoclave->True,
					Output->{Result, Options}
				}
			]
		];
		(* UploadMedia adds some options that don't exist in ExperimentStockSolution - drop those before passing to SS *)
		trimmedSSOptions = CollapseIndexMatchedOptions[
			ExperimentStockSolution,
			Normal@KeyDrop[stockSolutionOptions,{Author,Composition,FulfillmentScale,NominalpH,Preparable,Resuspension,VolumeIncrements,StockSolutionTemplate,UltrasonicIncompatible, PreferredContainers, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle, MaxpHingAdditionVolume, MaxNumberOfpHingCycles}]
		];
		If[MatchQ[resolvedMediaInputs,{ObjectP[Model[Sample,Media]]..}],
			ExperimentStockSolution[resolvedMediaInputs,trimmedSSOptions],

			{stockSolutionInputs,stockSolutionSolvents,stockSolutionTotalVolumes} = Transpose[resolvedMediaInputs];
			ExperimentStockSolution[stockSolutionInputs, stockSolutionSolvents, stockSolutionTotalVolumes, trimmedSSOptions]
		]
	];

	outputSpecification/.{Result->experimentMediaResult,Options->experimentMediaOptions}
];
