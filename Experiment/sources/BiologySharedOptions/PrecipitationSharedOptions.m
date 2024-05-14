(* ::Package::*)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* ExtractionPrecipitationSharedOptions *)

(***** Explanation of choices for what was modified:*****
This is a shared option set for ExperimentPrecipitate.

The OptionNames are modified to include Precipitation, unless the original OptionName already contains it (Like PrecipitationReagent).
The Descriptions are only modified if they needed to be updated to reference an OptionName that is modified in this shared option set (Like if it mentions PrecipitationTargetPhase).
The ResolutionDescriptions have all been updated to reflect the use of the Method. The sentence structures are changed, and any OptionNames are updated to match this OptionSet, but the content is the same as in ExperimentPrecipitate.
AllowNull->True, and Category->"Precipitation" are modified for every option, even though many Options already have the same setting in ExperimentPrecipitate. This was to ensure if these things are ever changed in the Experiment, it won't break experiments that use this shared OptionSet.
*)

DefineOptions[ExtractionPrecipitationSharedOptions,
	Options:>{

		ModifyOptions[ExperimentPrecipitate,
			TargetPhase,
			{
				OptionName->PrecipitationTargetPhase,
				AllowNull->True,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to the PrecipitationTargetPhase specified by the selected Method. If Method is set to Custom then PrecipitationTargetPhase is automatically set to Solid.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			SeparationTechnique,
			{
				OptionName->PrecipitationSeparationTechnique,
				AllowNull->True,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to the PrecipitationSeparationTechnique specified by the selected Method. If Method is set to Custom then PrecipitationSeparationTechnique is automatically set to Filter if any Filtration options are set, otherwise PrecipitationSeparationTechnique is set to Pellet.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationReagent,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationReagent specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid, then PrecipitationReagent is automatically set to Model[Sample, StockSolution, \"5M Sodium Chloride\"]. Otherwise PrecipitationReagent is set to Model[Sample, \"Isopropanol\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationReagentVolume,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationReagentVolume specified by the selected Method. If Method is set to Custom then PrecipitationReagentVolume is automatically set to the lesser of 50% of the input sample's volume or 80% of the maximum volume of the container minus the volume of input samples in order to not overflow the container. PrecipitationReagentVolume will resolve to a minimum of 1 Microliter.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationReagentTemperature,
			{
				AllowNull->True,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to the PrecipitationReagentTemperature specified by the selected Method. If Method is set to Custom then PrecipitationReagentTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationReagentEquilibrationTime,
			{
				AllowNull->True,
				Default->Automatic,
				ResolutionDescription-> "Automatically set to the PrecipitationReagentEquilibrationTime specified by the selected Method. If Method is set to Custom then PrecipitationReagentEquilibrationTime is automatically set to 5 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixType,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixType specified by the selected Method. If Method is set to Custom and any corresponding Pipette mixing options are set (PrecipitationMixVolume, NumberOfPrecipitationMixes) then PrecipitationMixType is automatically set to Pipette. Otherwise PrecipitationMixType is set to Shake.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixInstrument,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixInstrument specified by the selected Method. If Method is set to Custom then PrecipitationMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationMixType is set to Shake and PrecipitationMixTemperature is greater than 70 Celsius. Otherwise PrecipitationMixInstrument is set to Model[Instrument,HeatBlock,\"Hamilton Heater Cooler\"] if PrecipitationMixType is set to Shake.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixRate,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixRate specified by the selected Method. If Method is set to Custom and PrecipitationMixType is set to Shake then PrecipitationMixRate is automatically set to 300 RPM or the lowest speed PrecpitationMixInstrument is capable of.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixTemperature,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixTemperature specified by the selected Method. If Method is set to Custom and PrecipitationMixType is set to Shake then PrecipitationMixTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixTime,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixTime specified by the selected Method. If Method is set to Custom and PrecipitationMixType is set to Shake then PrecipitationMixTime is automatically set to 15 Minutes.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			NumberOfPrecipitationMixes,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the NumberOfPrecipitationMixes specified by the selected Method. If Method is set to Custom and PrecipitationMixType is set to Pipette then NumberOfPrecipitationMixes is automatically set to 10.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationMixVolume,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMixVolume specified by the selected Method. If Method is set to Custom and PrecipitationMixType is set to Pipette then PrecipitationMixVolume is automatically set to the lesser of 50% of the sample volume plus PrecipitationReagentVolume, or the maximum pipetting volume of Instrument.",
				Category->"Precipitation"(*TODO this has a reference to Instrument, and will probably need to be altered*)
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationTime,
			{
				AllowNull->True,
				Default->Automatic,
				ResolutionDescription->"Automatically set to the PrecipitationTargetPhase specified by the selected Method. If Method is set to Custom then PrecipitationTime is automatically set to 15 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationInstrument,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationInstrument specified by the selected Method. If Method is set to Custom then PrecipitationInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationTime is greater than 0 Minute, and PrecipitationTemperature is greater than 70 Celsius. Otherwise PrecipitationInstrument is set to Model[Instrument,HeatBlock,\"Hamilton Heater Cooler\"] if PrecipitationTime is greater than 0 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitationTemperature,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationTemperature specified by the selected Method. If Method is set to Custom and PrecipitationTime is greater than 0 Minute then PrecipitationTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FiltrationInstrument,
			{
				OptionName->PrecipitationFiltrationInstrument,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationFiltrationInstrument specified by the selected Method. If Method is set to Custom and FiltrationTechnique is set to Centrifuge then FiltrationInstrument is set to Model[Instrument, Centrifuge, \"VSpin\"] if RoboticInstrument is set to STAR, or Model[Instrument, Centrifuge, \"HiG4\"] if RoboticInstrument is not set to STAR. Otherwise, if FiltrationTechnique is set to AirPressure then FiltrationInstrument is set to Model[Instrument, PressureManifold, \"MPE2\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FiltrationTechnique,
			{
				OptionName->PrecipitationFiltrationTechnique,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationFiltrationTechnique specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationFiltrationTechnique is automatically set to AirPressure.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			Filter,
			{
				OptionName->PrecipitationFilter,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationFilter specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationFilter is automatically set to a filter that fits on the filtration instrument (either the centrifuge or pressure manifold) and matches PrecipitationMembraneMaterial and PrecipitationPoreSize if they are set. If the sample is already in a filter then PrecipitationFilter is automatically set to that filter and the sample will not be transferred to a new filter unless this option is explicitly changed to a new filter.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrefilterPoreSize,
			{
				OptionName->PrecipitationPrefilterPoreSize,
				AllowNull->True,
				Description->"The pore size of the prefilter membrane, which is placed above PrecipitationFilter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
				ResolutionDescription->"Automatically set to the PrecipitationPrefilterPoreSize specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationPrefilterPoreSize is automatically set to .45 Micron if PrecipitationPrefilterMembraneMaterial is set.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrefilterMembraneMaterial,
			{
				OptionName->PrecipitationPrefilterMembraneMaterial,
				AllowNull->True,
				Description->"The material from which the prefilter filtration membrane, which is placed above PrecipitationFilter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
				ResolutionDescription->"Automatically set to the PrecipitatePrefilterMembraneMaterial specified by the selected Method. If Method is set to Custom and PrecipitationPrefilterPoreSize is specified then PrecipitationPrefilterMembraneMaterial is automatically set to PES if PrecipitationSeparationTechnique is set to Filter.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PoreSize,
			{
				OptionName->PrecipitationPoreSize,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationPoreSize specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationPoreSize is automatically set to the PoreSize of PrecipitationFilter, if it is specified. Otherwise, PrecipitationPoreSize is set to .22 Micron if PrecipitationMembraneMaterial is set.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			MembraneMaterial,
			{
				OptionName->PrecipitationMembraneMaterial,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationMembraneMaterial specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationMembraneMaterial is automatically set to the MembraneMaterial of PrecipitationFilter, if it is specified. Otherwise, PrecipitationMembraneMaterial is automatically set to PES if PrecipitationPoreSize size is set.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FilterPosition,
			{
				OptionName->PrecipitationFilterPosition,
				AllowNull->True,
				Description->"The desired position in the PrecipitationFilter in which the samples are placed to be filtered.",
				ResolutionDescription->"Automatically set to the PrecipitationFilterPosition specified by the selected Method. If Method is set to Custom, PrecipitationSeparationTechnique is set to Filter, and the input sample is already in a filter, then PrecipitationFilterPosition is automatically set to the current position.  Otherwise, PrecipitationFilterPosition is set to the first empty position in PrecipitationFilter based on the search order of A1, A2, A3 ... P22, P23, P24.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FilterCentrifugeIntensity,
			{
				OptionName->PrecipitationFilterCentrifugeIntensity,
				AllowNull->True,
				Description->"The rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
				ResolutionDescription->"Automatically set to the PrecipitationFilterCentrifugeIntensity specified by the selected Method. If Method is set to Custom and PrecipitationFiltrationTechnique is set to Centrifuge then PrecipitationFilterCentrifugeIntensity is automatically set to either 3600 GravitationalAcceleration if PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2880 GravitationalAcceleration if PrecipitationFiltrationInstrument is set to Model[Instrument, Centrifuge, \"VSpin\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FiltrationPressure,
			{
				OptionName->PrecipitationFiltrationPressure,
				AllowNull->True,
				Description->"The pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
				ResolutionDescription->"Automatically set to the PrecipitationFiltrationPressure specified by the selected Method. If Method is set to Custom and PrecipitationFiltrationTechnique is set to AirPressure then PrecipitationFiltrationPressure is automatically set to 40 PSI.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FiltrationTime,
			{
				OptionName->PrecipitationFiltrationTime,
				AllowNull->True,
				Description->"The duration for which the samples will be exposed to either PrecipitationFiltrationPressure or PrecipitationFilterCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
				ResolutionDescription->"Automatically set to the PrecipitationFiltrationTime specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Filter then PrecipitationFiltrationTime is automatically set to 10 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FiltrateVolume,
			{
				OptionName->PrecipitationFiltrateVolume,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationFiltrateVolume specified by the selected Method. If Method is set to Custom then PrecipitationFiltrateVolume is automatically set to 100% of PrecipitationReagentVolume plus the sample volume.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			FilterStorageCondition,
			{
				OptionName->PrecipitationFilterStorageCondition,
				AllowNull->True,
				Description->"When PrecipitationFilterStorageCondition is not set to Disposal, PrecipitationFilterStorageCondition is the set of parameters that define the environmental conditions under which the filter used by this experiment will be stored after the protocol is completed.",
				ResolutionDescription->"Automatically set to the PrecipitationFilterStorageCondition specified by the selected Method. If Method is set to Custom, PrecipitationTargetPhase is set to Solid, PrecipitationResuspensionBuffer is not set to None, and PrecipitationSeparationTechnique is set to Filter, then PrecipitationFilterStorageCondition is automatically set to the StorageCondition of the sample. Otherwise, if PrecipitationSeparationTechnique is set to Filter, then PrecipitationFilterStorageCondition is automatically set to Disposal.",
				Category->"Precipitation"
			}
		],
			ModifyOptions[ExperimentPrecipitate,
				PelletVolume,
				{
					OptionName->PrecipitationPelletVolume,
					AllowNull->True,
					Description->"The expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of PrecipitationPelletVolume will result in less buffer being aspirated while underestimation of PrecipitationPelletVolume will risk aspiration of the pellet.",
					ResolutionDescription->"Automatically set to the PrecipitationPelletVolume specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Pellet then PrecipitationPelletVolume is automatically set to 1 Microliter.",
					Category->"Precipitation"
				}
			],
		ModifyOptions[ExperimentPrecipitate,
			PelletCentrifuge,
			{
				OptionName->PrecipitationPelletCentrifuge,
				AllowNull->True,
				Description->"The centrifuge that will be used to apply centrifugal force to the samples at PrecipitationPelletCentrifugeIntensity for PrecipitationPelletCentrifugeTime in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
				ResolutionDescription->"Automatically set to the PrecipitationPelletCentrifuge specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Pellet then PrecipitationPelletCentrifuge is automatically set to Centrifuge Model[Instrument, Centrifuge, \"HiG4\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PelletCentrifugeIntensity,
			{
				OptionName->PrecipitationPelletCentrifugeIntensity,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationPelletCentrifugeIntensity specified by the selected Method. If Method is set to Custom and then PelletCentrifugeIntensity is automatically set to 3600 GravitationalAcceleration if PrecipitationPelletCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2880 GravitationalAcceleration if PrecipitationPelletCentrifuge is set to Model[Instrument, Centrifuge, \"VSpin\"]",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PelletCentrifugeTime,
			{
				OptionName->PrecipitationPelletCentrifugeTime,
				AllowNull->True,
				Description->"The duration for which the samples will be centrifuged at PrecipitationPelletCentrifugeIntensity in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
				ResolutionDescription->"Automatically set to the PrecipitationPelletCentrifugeTime specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Pellet then PrecipitationPelletCentrifugeTime is automatically set to 10 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			SupernatantVolume,
			{
				OptionName->PrecipitationSupernatantVolume,
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitationSupernatantVolume specified by the selected Method. If Method is set to Custom and PrecipitationSeparationTechnique is set to Pellet then PrecipitationSupernatantVolume is automatically set to 90% of the PrecipitationReagentVolume plus the sample volume.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			NumberOfWashes,
			{
				OptionName->PrecipitationNumberOfWashes,
				AllowNull->True,
				Description->"The number of times PrecipitationWashSolution is added to the solid, mixed, and then separated again by either pelleting and aspiration if PrecipitationSeparationTechnique is set to Pellet, or by filtration if PrecipitationSeparationTechnique is set to Filter. The wash steps are performed in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationNumberOfWashes specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid then PrecipitationNumberOfWashes is automatically set to 0. Otherwise, PrecipitationNumberOfWashes is automatically set to 3.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashSolution,
			{
				OptionName->PrecipitationWashSolution,
				AllowNull->True,
				Description->"The solution used to help further wash impurities from the solid after the liquid phase has been removed. If PrecipitationSeparationTechnique is set to Filter, then the PrecipitationWashSolution will be added to the filter containing the retentate. If PrecipitationSeparationTechnique is set to Pellet, then the PrecipitationWashSolution will be added to the container containing the pellet.",
				ResolutionDescription->"Automatically set to the PrecipitationWashSolution specified by the selected Method. If Method is set to Custom and PrecipitationNumberOfWashes is set to a number greater than 0 then PrecipitationWashSolution is automatically set to Model[Sample, StockSolution, \"70% Ethanol\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashSolutionVolume,
			{
				OptionName->PrecipitationWashSolutionVolume,
				AllowNull->True,
				Description->"The volume of PrecipitationWashSolution which will used to help further wash impurities from the solid after the liquid phase has been separated from it. If PrecipitationSeparationTechnique is set to Filter, then this amount of PrecipitationWashSolution will be added to the filter containing the retentate. If PrecipitationSeparationTechnique is set to Pellet, then this amount of PrecipitationWashSolution will be added to the container containing the pellet.",
				ResolutionDescription->"Automatically set to the PrecipitationWashSolutionVolume specified by the selected Method. If Method is set to Custom and PrecipitationNumberOfWashes is set to a number greater than 0 then PrecipitationWashSolutionVolume is automatically set to 100% of the sample starting volume.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashSolutionTemperature,
			{
				OptionName->PrecipitationWashSolutionTemperature,
				AllowNull->True,
				Description->"The temperature at which PrecipitationWashSolution is incubated at during the PrecipitationWashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashSolutionTemperature specified by the selected Method. If Method is set to Custom and PrecipitationNumberOfWashes is set to a number greater than 0 then PrecipitationWashSolutionTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashSolutionEquilibrationTime,
			{
				OptionName->PrecipitationWashSolutionEquilibrationTime,
				AllowNull->True,
				Description->"The minimum duration for which the PrecipitationWashSolution will be kept at PrecipitationWashSolutionTemperature before being used to help further wash impurities from the solid after the liquid phase has been separated from it.",
				ResolutionDescription->"Automatically set to the PrecipitationWashSolutionEquilibrationTime specified by the selected Method. If Method is set to Custom and PrecipitationNumberOfWashes is set to a number greater than 0 then PrecipitationWashSolutionEquilibrationTime is automatically set to 10 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixType,
			{
				OptionName->PrecipitationWashMixType,
				AllowNull->True,
				Description->"The manner in which the sample is agitated following addition of PrecipitationWashSolution, in order to help further wash impurities from the solid. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationWashMixRate for PrecipitationWashMixTime, while Pipette indicates that PrecipitationWashMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationWashMixes. None indicates that no mixing occurs before incubation.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixType specified by the selected Method. If Method is set to Custom, then PrecipitationWashMixType is automatically set to Pipette if TargetPhase is set to Solid, PrecipitationNumberOfWashes is greater than 0, and any pipetting options are set (PrecipitationWashMixVolume and PrecipitationNumberOfWashMixes) or PrecipitationSeparationTechnique is set to Filter. If PrecipitationTargetPhase is set to Solid and PrecipitationNumberOfWashes is greater than 0, then WashMixType is automatically set to Shake if Pipette mixing options are not set and PrecipitationSeparationTechnique is set to Pellet. Otherwise, PrecipitationWashMixType is set to None.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixInstrument,
			{
				OptionName->PrecipitationWashMixInstrument,
				AllowNull->True,
				Description->"The instrument used agitate the sample following the addition of PrecipitationWashSolution in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixInstrument specified by the selected Method. If Method is set to Custom then PrecipitationWashMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashMixType is set to Shake and PrecipitationWashMixTemperature is greater than 70 Celsius. Otherwise PrecipitationWashMixInstrument is set to Model[Instrument,HeatBlock,\"Hamilton Heater Cooler\"] if PrecipitationWashMixType is set to Shake.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixRate,
			{
				OptionName->PrecipitationWashMixRate,
				AllowNull->True,
				Description->"The rate at which the solid and PrecipitationWashSolution are mixed, for the duration of PrecipitationWashMixTime, in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixRate specified by the selected Method. If Method is set to Custom and PrecipitationWashMixType is set to Shake then PrecipitationWashMixRate is automatically set to 300 RPM or the lowest speed PrecpitationWashMixInstrument is capable of.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixTemperature,
			{
				OptionName->PrecipitationWashMixTemperature,
				AllowNull->True,
				Description->"The temperature at which the mixing device's heating/cooling block is maintained for the duration of PrecipitationWashMixTime in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixTemperature specified by the selected Method. If Method is set to Custom and PrecipitationWashMixType is set to Shake then PrecipitationWashMixTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixTime,
			{
				OptionName->PrecipitationWashMixTime,
				AllowNull->True,
				Description->"The duration for which the solid and PrecipitationWashSolution are mixed at PrecipitationWashMixRate in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixTime specified by the selected Method. If Method is set to Custom and PrecipitationWashMixType is set to Shake then PrecipitationWashMixTime is automatically set to 1 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			NumberOfWashMixes,
			{
				OptionName->PrecipitationNumberOfWashMixes,
				AllowNull->True,
				Description->"The number of times PrecipitationWashMixVolume of the PrecipitationWashSolution is mixed by pipetting up and down in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationNumberOfWashMixes specified by the selected Method. If Method is set to Custom and PrecipitationWashMixType is set to Pipetting then PrecipitationNumberOfWashMixes is automatically set to 3.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashMixVolume,
			{
				OptionName->PrecipitationWashMixVolume,
				AllowNull->True,
				Description->"The volume of PrecipitationWashSolution that is displaced by pipette during each wash mix cycle, for which the number of cycles are defined by NumberOfWashMixes.",
				ResolutionDescription->"Automatically set to the PrecipitationWashMixVolume specified by the selected Method. If Method is set to Custom and PrecipitationWashMixType is set to Pipette then PrecipitationWashMixVolume is automatically set to the lesser of 50% of PrecipitationWashSolutionVolume, or the maximum pipetting volume of Instrument.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashPrecipitationTime,
			{
				OptionName->PrecipitationWashPrecipitationTime,
				AllowNull->True,
				Description->"The duration for which the samples remain in PrecipitationWashSolution after any mixing has occurred, held at PrecipitationWashPrecipitationTemperature, in order to allow the solid to precipitate back out of solution before separation of WashSolution from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashPrecipitationTime specified by the selected Method. If Method is set to Custom and PrecipitationWashSolutionTemperature is higher than PrecipitationReagentTemperature then PrecipitationWashPrecipitationTime is automatically set to 1 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashPrecipitationInstrument,
			{
				OptionName->PrecipitationWashPrecipitationInstrument,
				AllowNull->True,
				Description->"The instrument used to maintain the sample and PrecipitationWashSolution at PrecipitationWashPrecipitationTemperature for the PrecipitationWashPrecipitationTime prior to separation.",
				ResolutionDescription->"Automatically set to the PrecipitationWashPrecipitationInstrument specified by the selected Method. If Method is set to Custom, then PrecipitationWashPrecipitationInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationWashPrecipitationTime is greater than 0 Minute and WashPrecipitationTemperature is greater than 70 Celsius. Otherwise, PrecipitationWashPrecipitationInstrument is set to Model[Instrument, HeatBlock, \"Inheco ThermoshakeAC\"] if PrecipitationWashPrecipitationTime is greater than 0 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashPrecipitationTemperature,
			{
				OptionName->PrecipitationWashPrecipitationTemperature,
				AllowNull->True,
				Description->"The temperature which the samples in PrecipitationWashSolution are held at for the duration of PrecipitationWashPrecipitationTime in order to help further wash impurities from the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashPrecipitationTemperature specified by the selected Method. If Method is set to Custom and PrecipitationWashPrecipitationTime is greater than 0 Minute then PrecipitationWashPrecipitationTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashCentrifugeIntensity,
			{
				OptionName->PrecipitationWashCentrifugeIntensity,
				AllowNull->True,
				Description->"The rotational speed or the force that will be applied to the sample in order to separate the PrecipitationWashSolution from the solid after any mixing and incubation steps have been performed. If PrecipitationSeparationTechnique is set to Filter, then the force is applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and further wash impurities from the solid. If PrecipitationSeparationTechnique is set to Pellet, then the force is applied to the container containing the pellet and PrecipitationWashSolution in order to encourage the repelleting of the solid.",
				ResolutionDescription->"Automatically set to the PrecipitationWashCentrifugeIntensity specified by the selected Method. If Method is set to Custom, and PrecipitationNumberOfWashes is set to a number greater than 0 then PrecipitationWashCentrifugeIntensity is automatically set to 3600 GravitationalAcceleration if either PrecipitationPelletCentrifuge or PrecipitationFiltrationCentrifuge is set to Model[Instrument, Centrifuge, \"HiG4\"] or 2880 GravitationalAcceleration if either PrecipitationPelletCentrifuge or PrecipitationFiltrationCentrifuge is set to Model[Instrument, Centrifuge, \"VSpin\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashPressure,
			{
				OptionName->PrecipitationWashPressure,
				AllowNull->True,
				Description->"The target pressure applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and help further wash impurities from the retentate.",
				ResolutionDescription->"Automatically set to the PrecipitationWashPressure specified by the selected Method. If Method is set to Custom, PrecipitationFiltrationTechnique is set to AirPressure, and NumberOfWashes is set to a number greater than 0, then PrecipitationWashPressure is automatically set to 40 PSI.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			WashSeparationTime,
			{
				OptionName->PrecipitationWashSeparationTime,
				AllowNull->True,
				Description->"The duration for which the samples are exposed to PrecipitationWashPressure or PrecipitationWashCentrifugeIntensity in order to separate the PrecipitationWashSolution from the solid. If PrecipitationSeparationTechnique is set to Filter, then this separation is performed by passing the PrecipitationWashSolution through PrecipitationFilter by applying force of either PrecipitationWashPressure (if PrecipitationFiltrationTechnique is set to AirPressure) or PrecipitationWashCentrifugeIntensity (if PrecipitationFiltrationTechnique is set to Centrifuge). If PrecipitationSeparationTechnique is set to Pellet, then centrifugal force of PrecipitationWashCentrifugeIntensity is applied to encourage the solid to remain as, or return to, a pellet at the bottom of the container.",
				ResolutionDescription->"Automatically set to the PrecipitationWashSeparationTime specified by the selected Method. If Method is set to Custom and NumberOfWashes greater than 0 then PrecipitationWashSeparationTime is automatically set to 3 Minute if PrecipitationFiltrationTechnique is set to a AirPressure, otherwise PrecipitationWashSeparationTime is set to 20 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			DryingTemperature,
			{
				OptionName->PrecipitationDryingTemperature,
				AllowNull->True,
				Description->"The temperature at which the incubation device's heating/cooling block is maintained for the duration of PrecipitationDryingTime after removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
				ResolutionDescription->"Automatically set to the PrecipitationDryingTemperature specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitationDryingTemperature is automatically set to Ambient if .",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			DryingTime,
			{
				OptionName->PrecipitationDryingTime,
				AllowNull->True,
				Description->"The amount of time for which the solid will be exposed to open air at PrecipitationDryingTemperature following final removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
				ResolutionDescription->"Automatically set to the PrecipitationDryingTime specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitationDryingTime is automatically set to 20 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionBuffer,
			{
				OptionName->PrecipitationResuspensionBuffer,
				AllowNull->True,
				Description->"The solution into which the target molecules of the solid will be resuspended or redissolved. Setting PrecipitationResuspensionBuffer to None indicates that the sample will not be resuspended and that it will be stored as a solid, after any wash steps have been performed.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionBuffer specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitationResuspensionBuffer is automatically set to Model[Sample, StockSolution, \"1x TE Buffer\"].",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionBufferVolume,
			{
				OptionName->PrecipitationResuspensionBufferVolume,
				AllowNull->True,
				Description->"The volume of PrecipitationResuspensionBuffer that will be added to the solid and mixed in an effort to resuspend or redissolve the solid into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionBufferVolume specified by the selected Method. If Method is set to Custom and a buffer is specified for PrecipitationResuspensionBuffer then PrecipitationResuspensionBufferVolume is automatically set to the greater of 25% of the original sample volume, or 10 Microliter.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionBufferTemperature,
			{
				OptionName->PrecipitationResuspensionBufferTemperature,
				AllowNull->True,
				Description->"The temperature that the PrecipitationResuspensionBuffer is incubated at during the PrecipitationResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionBufferTemperature specified by the selected Method. If Method is set to Custom and a buffer is specified for PrecipitationResuspensionBuffer then PrecipitationResuspensionBufferTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionBufferEquilibrationTime,
			{
				OptionName->PrecipitationResuspensionBufferEquilibrationTime,
				AllowNull->True,
				Description->"The minimum duration for which the PrecipitationResuspensionBuffer will be kept at PrecipitationResuspensionBufferTemperature before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionBufferEquilibrationTime specified by the selected Method. If Method is set to Custom and a buffer is specified for PrecipitationResuspensionBuffer then PrecipitationResuspensionBufferEquilibrationTime is automatically set to 10 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixType,
			{
				OptionName->PrecipitationResuspensionMixType,
				AllowNull->True,
				Description->"The manner in which the sample is agitated following addition of PrecipitationResuspensionBuffer in order to encourage the solid phase to resuspend or redissolve into the buffer. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationResuspensionMixRate for PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, while Pipette indicates that PrecipitationResuspensionMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationResuspensionMixes. None indicates that no mixing occurs after adding PrecipitationResuspensionBuffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixType specified by the selected Method. If Method is set to Custom and a buffer is specified for PrecipitationResuspensionBuffer then PrecipitationResuspensionMixType is automatically set to Pipette if any corresponding Pipette mixing options are set (ResuspensionMixVolume, NumberOfPrecipitationResuspensionMixes) or if PrecipitationSeparationTechnique is set to Filter. Otherwise PrecipitationResuspensionMixType is automatically set to Shake.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixInstrument,
			{
				OptionName->PrecipitationResuspensionMixInstrument,
				AllowNull->True,
				Description->"The instrument used agitate the sample following the addition of PrecipitationResuspensionBuffer, in order to encourage the solid to redissolve or resuspend into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixInstrument specified by the selected Method. If Method is set to Custom then PrecipitationResuspensionMixInstrument is automatically set to Model[Instrument, Shaker, \"Inheco Incubator Shaker DWP\"] if PrecipitationResuspensionMixType is set to Shake and PrecipitationResuspensionMixTemperature is greater than 70 Celsius. Otherwise PrecipitationResuspensionMixInstrument is set to Model[Instrument,HeatBlock,\"Inheco ThermoshakeAC\"] if PrecipitationResuspensionMixType is set to Shake.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixRate,
			{
				OptionName->PrecipitationResuspensionMixRate,
				AllowNull->True,
				Description->"The rate at which the solid and PrecipitationResuspensionBuffer are shaken, for the duration of PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, in order to encourage the solid to redissolve or resuspend into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixRate specified by the selected Method. If Method is set to Custom and PrecipitationResuspensionMixType is set to Shake then PrecipitationResuspensionMixRate is automatically set to 300 RPM or the lowest speed PrecipitationResuspensionMixInstrument is capable of.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixTemperature,
			{
				OptionName->PrecipitationResuspensionMixTemperature,
				AllowNull->True,
				Description->"The temperature at which the sample and PrecipitationResuspensionBuffer are held at for the duration of PrecipitationResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixTemperature specified by the selected Method. If Method is set to Custom and PrecipitationResuspensionMixType is set to Shake then PrecipitationResuspensionMixTemperature is automatically set to Ambient.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixTime,
			{
				OptionName->PrecipitationResuspensionMixTime,
				AllowNull->True,
				Description->"The duration of time that the solid and PrecipitationResuspensionBuffer is shaken for, at the specified PrecipitationResuspensionMixRate, in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixTime specified by the selected Method. If Method is set to Custom and PrecipitationResuspensionMixType is set to Shake then PrecipitationResuspensionMixTime is automatically set to 15 Minute.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			NumberOfResuspensionMixes,
			{
				OptionName->PrecipitationNumberOfResuspensionMixes,
				AllowNull->True,
				Description->"The number of times that the PrecipitationResuspensionMixVolume of the PrecipitationResuspensionBuffer and solid are mixed pipetting up and down in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
				ResolutionDescription->"Automatically set to the PrecipitationNumberOfResuspensionMixes specified by the selected Method. If Method is set to Custom and PrecipitationResuspensionMixType is set to Pipette then PrecipitationNumberOfResuspensionMixes is automatically set to 10.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			ResuspensionMixVolume,
			{
				OptionName->PrecipitationResuspensionMixVolume,
				AllowNull->True,
				Description->"The volume of PrecipitationResuspensionBuffer that is displaced during each cycle of mixing by pipetting up and down, which is repeated for the number of times defined by NumberOfPrecipitationResuspensionMixes, in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
				ResolutionDescription->"Automatically set to the PrecipitationResuspensionMixVolume specified by the selected Method. If Method is set to Custom and PrecipitationResuspensionMixType is set to Pipette then PrecipitationResuspensionMixVolume is automatically set to the lesser of 50% of PrecipitationResuspensionBufferVolume, or the maximum pipetting volume of Instrument.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitatedSampleContainerOut,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the PrecipitatedSampleContainerOut specified by the selected Method. If Method is set to Custom, then PrecipitatedSampleContainerOut is automatically set to a container selected by PreferredContainer[...] based on having sufficient capacity to not overflow when the PrecipitationResuspensionBufferVolume is added if a PrecipitationResuspensionBuffer is specified, PrecipitationTargetPhase is set to Solid, and PrecipitationSeparationTechnique is set to Filter.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitatedSampleStorageCondition,
			{
				AllowNull->True,
				Description->"The set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if a buffer is specified for PrecipitationResuspensionBuffer.",
				ResolutionDescription->"Automatically set to the PrecipitatedSampleStorageCondition specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitatedSampleStorageCondition is automatically set to StorageCondition of SampleIn.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitatedSampleLabel,
			{
				AllowNull->True,
				Description->"A user defined word or phrase used to identify the solid isolated after precipitation is completed, either as a solid, or as a solution if a buffer is specified for PrecipitationResuspensionBuffer. If PrecipitationSeparationTechnique is set to Filter, then the sample is the retentate comprised of molecules too large to pass through the filter after precipitation. If PrecipitationSeparationTechnique is set to Pellet, then the sample is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
				ResolutionDescription->"Automatically set to the PrecipitationSampleLabel specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitationSampleLabel is automatically set to \"precipitated solid sample #\".",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			PrecipitatedSampleContainerLabel,
			{
				AllowNull->True,
				Description->"A user defined word or phrase used to identify the container that will contain the solid isolated after precipitation completed, either as a solid, or as a solution if a buffer is specified for PrecipitationResuspensionBuffer. If PrecipitationSeparationTechnique is set to Filter, then the sample contained in the container is the retentate comprised of molecules too large to pass through the filter after precipitation. If PrecipitationSeparationTechnique is set to Pellet, then the sample contained in the container is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
				ResolutionDescription->"Automatically set to the PrecipitationSampleOutContainerLabel specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Solid then PrecipitationSampleOutContainerLabel is automatically set to \"precipitated solid container #\".",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			UnprecipitatedSampleContainerOut,
			{
				AllowNull->True,
				ResolutionDescription->"Automatically set to the UnprecipitatedSampleContainerOut specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid, then UnprecipitatedSampleContainerOut is automatically set to a container selected by PreferredContainer[...] based on having sufficient capacity to not overflow when the the volume of the liquid phase is added.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			UnprecipitatedSampleStorageCondition,
			{
				AllowNull->True,
				Description->"The set of parameters that define the environmental conditions under which the liquid phase that is isolated during precipitation will be stored.",
				ResolutionDescription->"Automatically set to the PrecipitationStorageCondition specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid then UnprecipitatedSampleStorageCondition is automatically set to StorageCondition of SampleIn.",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			UnprecipitatedSampleLabel,
			{
				AllowNull->True,
				Description->"A user defined word or phrase used to identify the liquid phase that is separated during this protocol. If PrecipitationSeparationTechnique is set to Filter, then the sample is the filtrate after it is separated from the molecules too large to pass through the filter. If PrecipitationSeparationTechnique is set to Pellet, then the sample is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
				ResolutionDescription->"Automatically set to the PrecipitationLiquidSampleLabel specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid then PrecipitationLiquidSampleLabel is automatically set to \"precipitated liquid phase sample #\".",
				Category->"Precipitation"
			}
		],
		ModifyOptions[ExperimentPrecipitate,
			UnprecipitatedSampleContainerLabel,
			{
				AllowNull->True,
				Description->"A user defined word or phrase used to identify the container that contains the liquid phase that is separated during this protocol. If PrecipitationSeparationTechnique is set to Filter, then the sample contained in the container is the filtrate after it is separated from the molecules too large to pass through the filter. If PrecipitationSeparationTechnique is set to Pellet, then the sample contained in the container is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
				ResolutionDescription->"Automatically set to the PrecipitationLiquidSampleContainerLabel specified by the selected Method. If Method is set to Custom and PrecipitationTargetPhase is set to Liquid then PrecipitationLiquidSampleContainerLabel is automatically set to \"precipitated liquid phase container #\".",
				Category->"Precipitation"
			}
		]
	}
];

$PrecipitationSharedOptionMap={
	PrecipitationTargetPhase->TargetPhase,
	PrecipitationSeparationTechnique->SeparationTechnique,
	PrecipitationReagent->PrecipitationReagent,
	PrecipitationReagentVolume->PrecipitationReagentVolume,
	PrecipitationReagentTemperature->PrecipitationReagentTemperature,
	PrecipitationReagentEquilibrationTime->PrecipitationReagentEquilibrationTime,
	PrecipitationMixType->PrecipitationMixType,
	PrecipitationMixInstrument->PrecipitationMixInstrument,
	PrecipitationMixRate->PrecipitationMixRate,
	PrecipitationMixTemperature->PrecipitationMixTemperature,
	PrecipitationMixTime->PrecipitationMixTime,
	NumberOfPrecipitationMixes->NumberOfPrecipitationMixes,
	PrecipitationMixVolume->PrecipitationMixVolume,
	PrecipitationTime->PrecipitationTime,
	PrecipitationInstrument->PrecipitationInstrument,
	PrecipitationTemperature->PrecipitationTemperature,
	PrecipitationFiltrationInstrument->FiltrationInstrument,
	PrecipitationFiltrationTechnique->FiltrationTechnique,
	PrecipitationFilter->Filter,
	PrecipitationPrefilterPoreSize->PrefilterPoreSize,
	PrecipitationPrefilterMembraneMaterial->PrefilterMembraneMaterial,
	PrecipitationPoreSize->PoreSize,
	PrecipitationMembraneMaterial->MembraneMaterial,
	PrecipitationFilterPosition->FilterPosition,
	PrecipitationFilterCentrifugeIntensity->FilterCentrifugeIntensity,
	PrecipitationFiltrationPressure->FiltrationPressure,
	PrecipitationFiltrationTime->FiltrationTime,
	PrecipitationFiltrateVolume->FiltrateVolume,
	PrecipitationPelletVolume->PelletVolume,
	PrecipitationFilterStorageCondition->FilterStorageCondition,
	PrecipitationPelletCentrifuge->PelletCentrifuge,
	PrecipitationPelletCentrifugeIntensity->PelletCentrifugeIntensity,
	PrecipitationPelletCentrifugeTime->PelletCentrifugeTime,
	PrecipitationSupernatantVolume->SupernatantVolume,
	PrecipitationNumberOfWashes->NumberOfWashes,
	PrecipitationWashSolution->WashSolution,
	PrecipitationWashSolutionVolume->WashSolutionVolume,
	PrecipitationWashSolutionTemperature->WashSolutionTemperature,
	PrecipitationWashSolutionEquilibrationTime->WashSolutionEquilibrationTime,
	PrecipitationWashMixType->WashMixType,
	PrecipitationWashMixInstrument->WashMixInstrument,
	PrecipitationWashMixRate->WashMixRate,
	PrecipitationWashMixTemperature->WashMixTemperature,
	PrecipitationWashMixTime->WashMixTime,
	PrecipitationNumberOfWashMixes->NumberOfWashMixes,
	PrecipitationWashMixVolume->WashMixVolume,
	PrecipitationWashPrecipitationTime->WashPrecipitationTime,
	PrecipitationWashPrecipitationInstrument->WashPrecipitationInstrument,
	PrecipitationWashPrecipitationTemperature->WashPrecipitationTemperature,
	PrecipitationWashCentrifugeIntensity->WashCentrifugeIntensity,
	PrecipitationWashPressure->WashPressure,
	PrecipitationWashSeparationTime->WashSeparationTime,
	PrecipitationDryingTemperature->DryingTemperature,
	PrecipitationDryingTime->DryingTime,
	PrecipitationResuspensionBuffer->ResuspensionBuffer,
	PrecipitationResuspensionBufferVolume->ResuspensionBufferVolume,
	PrecipitationResuspensionBufferTemperature->ResuspensionBufferTemperature,
	PrecipitationResuspensionBufferEquilibrationTime->ResuspensionBufferEquilibrationTime,
	PrecipitationResuspensionMixType->ResuspensionMixType,
	PrecipitationResuspensionMixInstrument->ResuspensionMixInstrument,
	PrecipitationResuspensionMixRate->ResuspensionMixRate,
	PrecipitationResuspensionMixTemperature->ResuspensionMixTemperature,
	PrecipitationResuspensionMixTime->ResuspensionMixTime,
	PrecipitationNumberOfResuspensionMixes->NumberOfResuspensionMixes,
	PrecipitationResuspensionMixVolume->ResuspensionMixVolume,
	PrecipitatedSampleContainerOut->PrecipitatedSampleContainerOut,
	PrecipitatedSampleStorageCondition->PrecipitatedSampleStorageCondition,
	PrecipitatedSampleLabel->PrecipitatedSampleLabel,
	PrecipitatedSampleContainerLabel->PrecipitatedSampleContainerLabel,
	UnprecipitatedSampleContainerOut->UnprecipitatedSampleContainerOut,
	UnprecipitatedSampleStorageCondition->UnprecipitatedSampleStorageCondition,
	UnprecipitatedSampleLabel->UnprecipitatedSampleLabel,
	UnprecipitatedSampleContainerLabel->UnprecipitatedSampleContainerLabel
};


(* ::Subsection::Closed:: *)
(*preResolvePrecipitationSharedOptions*)

DefineOptions[
	preResolvePrecipitationSharedOptions,
	Options:>{
		CacheOption,
		SimulationOption
	}
];

preResolvePrecipitationSharedOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myMethods:{(ObjectP[Object[Method]]|Custom)..},
	myOptionMap_List,
	myOptions_List,
	myMapThreadOptions:{_Association..},
	myResolutionOptions:OptionsPattern[preResolvePrecipitationSharedOptions]
]:=Module[
	{
		resolvedPrecipitationTargetPhase, resolvedPrecipitationSeparationTechnique,	resolvedPrecipitationReagent, resolvedPrecipitationReagentVolume,
		resolvedPrecipitationReagentTemperature, resolvedPrecipitationReagentEquilibrationTime, resolvedPrecipitationMixType, resolvedPrecipitationMixInstrument, resolvedPrecipitationMixRate,
		resolvedPrecipitationMixTemperature, resolvedPrecipitationMixTime, resolvedNumberOfPrecipitationMixes, resolvedPrecipitationMixVolume, resolvedPrecipitationTime, resolvedPrecipitationInstrument,
		resolvedPrecipitationTemperature, resolvedPrecipitationFiltrationInstrument, resolvedPrecipitationFiltrationTechnique, resolvedPrecipitationFilter, resolvedPrecipitationPrefilterPoreSize,
		resolvedPrecipitationPrefilterMembraneMaterial,	resolvedPrecipitationPoreSize, resolvedPrecipitationMembraneMaterial, resolvedPrecipitationFilterPosition, resolvedPrecipitationFilterCentrifugeIntensity,
		resolvedPrecipitationFiltrationPressure, resolvedPrecipitationFiltrationTime, resolvedPrecipitationFiltrateVolume, resolvedPrecipitationFilterStorageCondition, resolvedPrecipitationPelletVolume,
		resolvedPrecipitationPelletCentrifuge, resolvedPrecipitationPelletCentrifugeIntensity, resolvedPrecipitationPelletCentrifugeTime, resolvedPrecipitationSupernatantVolume,	resolvedPrecipitationNumberOfWashes,
		resolvedPrecipitationWashSolution, resolvedPrecipitationWashSolutionVolume, resolvedPrecipitationWashSolutionTemperature, resolvedPrecipitationWashSolutionEquilibrationTime, resolvedPrecipitationWashMixType,
		resolvedPrecipitationWashMixInstrument, resolvedPrecipitationWashMixRate, resolvedPrecipitationWashMixTemperature, resolvedPrecipitationWashMixTime, resolvedPrecipitationNumberOfWashMixes,
		resolvedPrecipitationWashMixVolume, resolvedPrecipitationWashPrecipitationTime, resolvedPrecipitationWashPrecipitationInstrument, resolvedPrecipitationWashPrecipitationTemperature,
		resolvedPrecipitationWashCentrifugeIntensity, resolvedPrecipitationWashPressure, resolvedPrecipitationWashSeparationTime, resolvedPrecipitationDryingTemperature, resolvedPrecipitationDryingTime,
		resolvedPrecipitationResuspensionBuffer, resolvedPrecipitationResuspensionBufferVolume,	resolvedPrecipitationResuspensionBufferTemperature, resolvedPrecipitationResuspensionBufferEquilibrationTime,
		resolvedPrecipitationResuspensionMixType, resolvedPrecipitationResuspensionMixInstrument,	resolvedPrecipitationResuspensionMixRate, resolvedPrecipitationResuspensionMixTemperature,
		resolvedPrecipitationResuspensionMixTime, resolvedPrecipitationNumberOfResuspensionMixes,	resolvedPrecipitationResuspensionMixVolume,	resolvedPrecipitatedSampleContainerOut, resolvedPrecipitatedSampleStorageCondition,
		resolvedPrecipitatedSampleLabel, resolvedPrecipitatedSampleContainerLabel, resolvedUnprecipitatedSampleContainerOut, resolvedUnprecipitatedSampleStorageCondition, resolvedUnprecipitatedSampleLabel,
		resolvedUnprecipitatedSampleContainerLabel,

		optionMapToPass, safeOptions, cache, simulation, sampleFields, samplePacketFields, methodFields, methodPacketFields, samplePackets, methodPackets,
		simplePreResolveOption, simplePreResolveOptionNoMethod
	},

	(* Get our safe options. *)
	safeOptions=SafeOptions[preResolvePrecipitationSharedOptions, ToList[myResolutionOptions]];

	(* Lookup our cache and simulation. *)
	cache = Lookup[safeOptions, Cache];
	simulation = Lookup[safeOptions, Simulation];

	(* If an optionMap is provided, use it, if not, then use the $PrecipitationSharedOptionMap *)
	(* optionMapToPass is the option map that will actually get passed to the sharedOptionResolver *)
	optionMapToPass=If[
		Length[myOptionMap]>0,
		myOptionMap,
		$PrecipitationSharedOptionMap
	];

	(* Download fields from samples that are required.*)
	(* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
	sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, (*Living,*) CultureAdhesion, Volume, Analytes, Density, Container, Position}]];
	samplePacketFields = Packet@@sampleFields;
	methodFields = DeleteDuplicates[Flatten[{PrecipitationTargetPhase,PrecipitationSeparationTechnique,PrecipitationReagent,PrecipitationReagentTemperature,PrecipitationReagentEquilibrationTime,PrecipitationMixType,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,NumberOfPrecipitationMixes,PrecipitationTime,PrecipitationTemperature,PrecipitationFiltrationTechnique,PrecipitationFilter,PrecipitationPrefilterPoreSize,PrecipitationPrefilterMembraneMaterial,PrecipitationPoreSize,PrecipitationMembraneMaterial,PrecipitationFilterCentrifugeIntensity,PrecipitationFiltrationPressure,PrecipitationFiltrationTime,PrecipitationPelletCentrifugeIntensity,PrecipitationPelletCentrifugeTime,PrecipitationNumberOfWashes,PrecipitationWashSolution,PrecipitationWashSolutionTemperature,PrecipitationWashSolutionEquilibrationTime,PrecipitationWashMixType,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationNumberOfWashMixes,PrecipitationWashPrecipitationTime,PrecipitationWashPrecipitationTemperature,PrecipitationWashCentrifugeIntensity,PrecipitationWashPressure,PrecipitationWashSeparationTime,PrecipitationDryingTemperature,PrecipitationDryingTime,PrecipitationResuspensionBuffer,PrecipitationResuspensionBufferTemperature,PrecipitationResuspensionBufferEquilibrationTime,PrecipitationResuspensionMixType,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationNumberOfResuspensionMixes}]];
	methodPacketFields = Packet@@methodFields;

	{
		samplePackets,
		methodPackets
	} = Download[
		{
			mySamples,
			Replace[myMethods, {Custom -> Null}, 2]
		},
		{
			{samplePacketFields},
			{methodPacketFields}
		},
		Cache -> cache,
		Simulation -> simulation
	];

	{
		samplePackets,
		methodPackets
	}=Flatten/@{
		samplePackets,
		methodPackets
	};

	(* helper function that does simple pre-resolution logic:*)
	simplePreResolveOption[myOptionName_Symbol, mapThreadedOptions_Association, myMethodPacket_, myMethodSpecifiedQ:BooleanP, myPrecipitationUsedQ:BooleanP]:=Which[
		(* If specified by the user, set to user-specified value *)
		MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]],
			Lookup[mapThreadedOptions, myOptionName],
		(* NOTE: Empty single fields are Null, but empty multiple fields are {}, so we check for both. *)
		myMethodSpecifiedQ && MatchQ[Lookup[myMethodPacket, myOptionName, Null], Except[Null|{}]],
			Lookup[myMethodPacket, myOptionName],
		(* If Precipitation is not used and the option is not specified, it is set to Null. *)
		!myPrecipitationUsedQ,
			Null,
		True,
			Automatic
	];

	(* helper function that does simple pre-resolution logic with no method:*)
	simplePreResolveOptionNoMethod[myOptionName_Symbol, mapThreadedOptions_Association, myPrecipitationUsedQ:BooleanP]:=Which[
		(* If specified by the user, set to user-specified value *)
		MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]], Lookup[mapThreadedOptions, myOptionName],
		(* If Precipitation is not used and the option is not specified, it is set to Null. *)
		!myPrecipitationUsedQ, Null,
		True, Automatic
	];

	{
		resolvedPrecipitationTargetPhase,
		resolvedPrecipitationSeparationTechnique,
		resolvedPrecipitationReagent,
		resolvedPrecipitationReagentVolume,
		resolvedPrecipitationReagentTemperature,
		resolvedPrecipitationReagentEquilibrationTime,
		resolvedPrecipitationMixType,
		resolvedPrecipitationMixInstrument,
		resolvedPrecipitationMixRate,
		resolvedPrecipitationMixTemperature,
		resolvedPrecipitationMixTime,
		resolvedNumberOfPrecipitationMixes,
		resolvedPrecipitationMixVolume,
		resolvedPrecipitationTime,
		resolvedPrecipitationInstrument,
		resolvedPrecipitationTemperature,
		resolvedPrecipitationFiltrationInstrument,
		resolvedPrecipitationFiltrationTechnique,
		resolvedPrecipitationFilter,
		resolvedPrecipitationPrefilterPoreSize,
		resolvedPrecipitationPrefilterMembraneMaterial,
		resolvedPrecipitationPoreSize,
		resolvedPrecipitationMembraneMaterial,
		resolvedPrecipitationFilterPosition,
		resolvedPrecipitationFilterCentrifugeIntensity,
		resolvedPrecipitationFiltrationPressure,
		resolvedPrecipitationFiltrationTime,
		resolvedPrecipitationFiltrateVolume,
		resolvedPrecipitationFilterStorageCondition,
		resolvedPrecipitationPelletVolume,
		resolvedPrecipitationPelletCentrifuge,
		resolvedPrecipitationPelletCentrifugeIntensity,
		resolvedPrecipitationPelletCentrifugeTime,
		resolvedPrecipitationSupernatantVolume,
		resolvedPrecipitationNumberOfWashes,
		resolvedPrecipitationWashSolution,
		resolvedPrecipitationWashSolutionVolume,
		resolvedPrecipitationWashSolutionTemperature,
		resolvedPrecipitationWashSolutionEquilibrationTime,
		resolvedPrecipitationWashMixType,
		resolvedPrecipitationWashMixInstrument,
		resolvedPrecipitationWashMixRate,
		resolvedPrecipitationWashMixTemperature,
		resolvedPrecipitationWashMixTime,
		resolvedPrecipitationNumberOfWashMixes,
		resolvedPrecipitationWashMixVolume,
		resolvedPrecipitationWashPrecipitationTime,
		resolvedPrecipitationWashPrecipitationInstrument,
		resolvedPrecipitationWashPrecipitationTemperature,
		resolvedPrecipitationWashCentrifugeIntensity,
		resolvedPrecipitationWashPressure,
		resolvedPrecipitationWashSeparationTime,
		resolvedPrecipitationDryingTemperature,
		resolvedPrecipitationDryingTime,
		resolvedPrecipitationResuspensionBuffer,
		resolvedPrecipitationResuspensionBufferVolume,
		resolvedPrecipitationResuspensionBufferTemperature,
		resolvedPrecipitationResuspensionBufferEquilibrationTime,
		resolvedPrecipitationResuspensionMixType,
		resolvedPrecipitationResuspensionMixInstrument,
		resolvedPrecipitationResuspensionMixRate,
		resolvedPrecipitationResuspensionMixTemperature,
		resolvedPrecipitationResuspensionMixTime,
		resolvedPrecipitationNumberOfResuspensionMixes,
		resolvedPrecipitationResuspensionMixVolume,
		resolvedPrecipitatedSampleContainerOut,
		resolvedPrecipitatedSampleStorageCondition,
		resolvedPrecipitatedSampleLabel,
		resolvedPrecipitatedSampleContainerLabel,
		resolvedUnprecipitatedSampleContainerOut,
		resolvedUnprecipitatedSampleStorageCondition,
		resolvedUnprecipitatedSampleLabel,
		resolvedUnprecipitatedSampleContainerLabel
	}=Transpose@MapThread[
		Function[{samplePacket, methodPacket, options},
			Module[
				{precipitationUsedQ, precipitationTargetPhase, precipitationSeparationTechnique, precipitationReagent, precipitationReagentVolume, precipitationReagentTemperature, precipitationReagentEquilibrationTime, precipitationMixType,
					precipitationMixInstrument, precipitationMixRate, precipitationMixTemperature, precipitationMixTime, numberOfPrecipitationMixes, precipitationMixVolume, precipitationTime,
					precipitationInstrument, precipitationTemperature, precipitationFiltrationInstrument, precipitationFiltrationTechnique, precipitationFilter, precipitationPrefilterPoreSize,
					precipitationPrefilterMembraneMaterial, precipitationPoreSize, precipitationMembraneMaterial, precipitationFilterPosition, precipitationFilterCentrifugeIntensity, precipitationFiltrationPressure,
					precipitationFiltrationTime, precipitationFiltrateVolume, precipitationFilterStorageCondition, precipitationPelletVolume, precipitationPelletCentrifuge, precipitationPelletCentrifugeIntensity,
					precipitationPelletCentrifugeTime, precipitationSupernatantVolume, precipitationNumberOfWashes, precipitationWashSolution, precipitationWashSolutionVolume, precipitationWashSolutionTemperature,
					precipitationWashSolutionEquilibrationTime, precipitationWashMixType, precipitationWashMixInstrument, precipitationWashMixRate, precipitationWashMixTemperature, precipitationWashMixTime,
					precipitationNumberOfWashMixes, precipitationWashMixVolume, precipitationWashPrecipitationTime, precipitationWashPrecipitationInstrument, precipitationWashPrecipitationTemperature, precipitationWashCentrifugeIntensity,
					precipitationWashPressure, precipitationWashSeparationTime, precipitationDryingTemperature, precipitationDryingTime, precipitationResuspensionBuffer, precipitationResuspensionBufferVolume,
					precipitationResuspensionBufferTemperature, precipitationResuspensionBufferEquilibrationTime, precipitationResuspensionMixType, precipitationResuspensionMixInstrument, precipitationResuspensionMixRate,
					precipitationResuspensionMixTemperature, precipitationResuspensionMixTime, precipitationNumberOfResuspensionMixes, precipitationResuspensionMixVolume, precipitatedSampleContainerOut,
					precipitatedSampleStorageCondition, precipitatedSampleLabel, precipitatedSampleContainerLabel, unprecipitatedSampleContainerOut, unprecipitatedSampleStorageCondition, unprecipitatedSampleLabel,
					unprecipitatedSampleContainerLabel, methodSpecifiedQ
				},

				(* Determine if Precipitation is used for this sample. *)
				precipitationUsedQ = MemberQ[ToList[Lookup[options, Purification]], Precipitation];

				(* Setup a boolean to determine if there is a method set or not. *)
				methodSpecifiedQ = MatchQ[Lookup[options,Method], ObjectP[Object[Method]]];

				(* Pre-resolve options that do not rely on the Methods *)
				{
					(*1*)precipitationReagentVolume,
					(*2*)precipitationMixVolume,
					(*3*)precipitationFiltrateVolume,
					(*4*)precipitationPelletVolume,
					(*5*)precipitationSupernatantVolume,
					(*6*)precipitationWashSolutionVolume,
					(*7*)precipitationWashMixVolume,
					(*8*)precipitationResuspensionBufferVolume,
					(*9*)precipitationResuspensionMixVolume
				} = Map[
					simplePreResolveOptionNoMethod[#, options, precipitationUsedQ]&,
					{
						(*1*)PrecipitationReagentVolume,
						(*2*)PrecipitationMixVolume,
						(*3*)PrecipitationFiltrateVolume,
						(*4*)PrecipitationPelletVolume,
						(*5*)PrecipitationSupernatantVolume,
						(*6*)PrecipitationWashSolutionVolume,
						(*7*)PrecipitationWashMixVolume,
						(*8*)PrecipitationResuspensionBufferVolume,
						(*9*)PrecipitationResuspensionMixVolume
					}
				];

				(* Pre-resolve options that do rely on the Methods *)
				{
					(*1*)precipitationReagent,
					(*2*)precipitationMixType,
					(*3*)precipitationMixInstrument,
					(*4*)precipitationMixRate,
					(*5*)precipitationMixTemperature,
					(*6*)precipitationMixTime,
					(*7*)numberOfPrecipitationMixes,
					(*8*)precipitationInstrument,
					(*9*)precipitationTemperature,
					(*10*)precipitationFiltrationInstrument,
					(*11*)precipitationFiltrationTechnique,
					(*12*)precipitationFilter,
					(*13*)precipitationPrefilterPoreSize,
					(*14*)precipitationPrefilterMembraneMaterial,
					(*15*)precipitationFilterPosition,
					(*16*)precipitationFilterCentrifugeIntensity,
					(*17*)precipitationFiltrationPressure,
					(*18*)precipitationFiltrationTime,
					(*19*)precipitationFilterStorageCondition,
					(*20*)precipitationPelletCentrifuge,
					(*21*)precipitationPelletCentrifugeIntensity,
					(*22*)precipitationPelletCentrifugeTime,
					(*23*)precipitationNumberOfWashes,
					(*24*)precipitationWashSolution,
					(*25*)precipitationWashSolutionTemperature,
					(*26*)precipitationWashSolutionEquilibrationTime,
					(*27*)precipitationWashMixType,
					(*28*)precipitationWashMixInstrument,
					(*29*)precipitationWashMixRate,
					(*30*)precipitationWashMixTemperature,
					(*31*)precipitationWashMixTime,
					(*32*)precipitationNumberOfWashMixes,
					(*33*)precipitationWashPrecipitationTime,
					(*34*)precipitationWashPrecipitationInstrument,
					(*35*)precipitationWashPrecipitationTemperature,
					(*36*)precipitationWashCentrifugeIntensity,
					(*37*)precipitationWashPressure,
					(*38*)precipitationWashSeparationTime,
					(*39*)precipitationDryingTemperature,
					(*40*)precipitationDryingTime,
					(*41*)precipitationResuspensionBuffer,
					(*42*)precipitationResuspensionBufferTemperature,
					(*43*)precipitationResuspensionBufferEquilibrationTime,
					(*44*)precipitationResuspensionMixType,
					(*45*)precipitationResuspensionMixInstrument,
					(*46*)precipitationResuspensionMixRate,
					(*47*)precipitationResuspensionMixTemperature,
					(*48*)precipitationResuspensionMixTime,
					(*49*)precipitationNumberOfResuspensionMixes,
					(*50*)precipitatedSampleContainerOut,
					(*51*)precipitatedSampleStorageCondition,
					(*52*)precipitatedSampleLabel,
					(*53*)precipitatedSampleContainerLabel,
					(*54*)unprecipitatedSampleContainerOut,
					(*55*)unprecipitatedSampleStorageCondition,
					(*56*)unprecipitatedSampleLabel,
					(*57*)unprecipitatedSampleContainerLabel
				} = Map[
					simplePreResolveOption[#, options, methodPacket, methodSpecifiedQ, precipitationUsedQ]&,
					{
						(*1*)PrecipitationReagent,
						(*2*)PrecipitationMixType,
						(*3*)PrecipitationMixInstrument,
						(*4*)PrecipitationMixRate,
						(*5*)PrecipitationMixTemperature,
						(*6*)PrecipitationMixTime,
						(*7*)NumberOfPrecipitationMixes,
						(*8*)PrecipitationInstrument,
						(*9*)PrecipitationTemperature,
						(*10*)PrecipitationFiltrationInstrument,
						(*11*)PrecipitationFiltrationTechnique,
						(*12*)PrecipitationFilter,
						(*13*)PrecipitationPrefilterPoreSize,
						(*14*)PrecipitationPrefilterMembraneMaterial,
						(*15*)PrecipitationFilterPosition,
						(*16*)PrecipitationFilterCentrifugeIntensity,
						(*17*)PrecipitationFiltrationPressure,
						(*18*)PrecipitationFiltrationTime,
						(*19*)PrecipitationFilterStorageCondition,
						(*20*)PrecipitationPelletCentrifuge,
						(*21*)PrecipitationPelletCentrifugeIntensity,
						(*22*)PrecipitationPelletCentrifugeTime,
						(*23*)PrecipitationNumberOfWashes,
						(*24*)PrecipitationWashSolution,
						(*25*)PrecipitationWashSolutionTemperature,
						(*26*)PrecipitationWashSolutionEquilibrationTime,
						(*27*)PrecipitationWashMixType,
						(*28*)PrecipitationWashMixInstrument,
						(*29*)PrecipitationWashMixRate,
						(*30*)PrecipitationWashMixTemperature,
						(*31*)PrecipitationWashMixTime,
						(*32*)PrecipitationNumberOfWashMixes,
						(*33*)PrecipitationWashPrecipitationTime,
						(*34*)PrecipitationWashPrecipitationInstrument,
						(*35*)PrecipitationWashPrecipitationTemperature,
						(*36*)PrecipitationWashCentrifugeIntensity,
						(*37*)PrecipitationWashPressure,
						(*38*)PrecipitationWashSeparationTime,
						(*39*)PrecipitationDryingTemperature,
						(*40*)PrecipitationDryingTime,
						(*41*)PrecipitationResuspensionBuffer,
						(*42*)PrecipitationResuspensionBufferTemperature,
						(*43*)PrecipitationResuspensionBufferEquilibrationTime,
						(*44*)PrecipitationResuspensionMixType,
						(*45*)PrecipitationResuspensionMixInstrument,
						(*46*)PrecipitationResuspensionMixRate,
						(*47*)PrecipitationResuspensionMixTemperature,
						(*48*)PrecipitationResuspensionMixTime,
						(*49*)PrecipitationNumberOfResuspensionMixes,
						(*50*)PrecipitatedSampleContainerOut,
						(*51*)PrecipitatedSampleStorageCondition,
						(*52*)PrecipitatedSampleLabel,
						(*53*)PrecipitatedSampleContainerLabel,
						(*54*)UnprecipitatedSampleContainerOut,
						(*55*)UnprecipitatedSampleStorageCondition,
						(*56*)UnprecipitatedSampleLabel,
						(*57*)UnprecipitatedSampleContainerLabel
					}
				];

				(* Resolve the TargetPhase. *)
				precipitationTargetPhase = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationTargetPhase], Except[Automatic]], KeyExistsQ[options, PrecipitationTargetPhase]],
						Lookup[options, PrecipitationTargetPhase],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationTargetPhase, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationTargetPhase],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(*Otherwise, set to Solid.*)
					True,
						Solid
				];

				(* Resolve the SeparationTechnique. *)
				precipitationSeparationTechnique = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationSeparationTechnique], Except[Automatic]], KeyExistsQ[options, PrecipitationSeparationTechnique]],
						Lookup[options, PrecipitationSeparationTechnique],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationSeparationTechnique, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationSeparationTechnique],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(*If any Filtration options are set and no Pellet options are set, set PrecipitationSeparationTechnique to Filter*)
					And[
						Or[
							!MatchQ[Lookup[options, PrecipitationFiltrationInstrument],(Automatic | Null)],
							!MatchQ[Lookup[options, PrecipitationFiltrationTechnique],(Automatic | Null)],
							!MatchQ[Lookup[options, PrecipitationFilter],(Automatic | Null)],
							!MatchQ[Lookup[options, PrecipitationFilterPosition],(Automatic | Null)],
							MatchQ[Lookup[options, PrecipitationFiltrationTime],GreaterP[0 Minute]]
						],
						MatchQ[Lookup[options, PrecipitationPelletVolume],(Automatic | Null)],
						MatchQ[Lookup[options, PrecipitationPelletCentrifuge],(Automatic | Null)],
						MatchQ[Lookup[options, PrecipitationPelletCentrifugeIntensity],(Automatic | Null)],
						MatchQ[Lookup[options, PrecipitationPelletCentrifugeTime],(Automatic | Null)],
						!MatchQ[Lookup[options, PrecipitationSupernatantVolume],GreaterP[0 Milliliter]]
					],
						Filter,
					(*Otherwise, set to Pellet.*)
					True,
						Pellet
				];

				(* Resolve the PrecipitationReagentTemperature. *)
				precipitationReagentTemperature = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationReagentTemperature], Except[Automatic]], KeyExistsQ[options, PrecipitationReagentTemperature]],
						Lookup[options, PrecipitationReagentTemperature],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationReagentTemperature, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationReagentTemperature],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(*Otherwise, set to Automatic.*)
					True,
						Ambient
				];

				(* Resolve the PrecipitationReagentEquilibrationTime. *)
				precipitationReagentEquilibrationTime = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationReagentEquilibrationTime], Except[Automatic]], KeyExistsQ[options, PrecipitationReagentEquilibrationTime]],
						Lookup[options, PrecipitationReagentEquilibrationTime],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationReagentEquilibrationTime, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationReagentEquilibrationTime],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(*Otherwise, set to Automatic.*)
					True,
						5 Minute
				];

				(* Resolve the PrecipitationTime. *)
				precipitationTime = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationTime], Except[Automatic]], KeyExistsQ[options, PrecipitationTime]],
						Lookup[options, PrecipitationTime],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationTime, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationTime],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(*Otherwise, set to Automatic.*)
					True,
						15 Minute
				];

				(* Resolve the PrecipitationPoreSize. *)
				precipitationPoreSize = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationPoreSize], Except[Automatic]], KeyExistsQ[options, PrecipitationPoreSize]],
						Lookup[options, PrecipitationPoreSize],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationPoreSize, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationPoreSize],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(* NOTE: ExperimentPrecipitation and ExperimentFilter doesn't actually resolve this correctly, so we'll do so here instead for now. *)
					(* If a filter is not specified, but a membrane material is specified, then set to 0.22 micrometer. *)
					And[
						MatchQ[Lookup[options,PrecipitationMembraneMaterial], Except[Automatic|Null]],
						MatchQ[Lookup[options, PrecipitationFilter], Automatic]
					],
						0.22 Micrometer,
					(*Otherwise, set to Automatic.*)
					True,
						Automatic
				];

				(* Resolve the PrecipitationMembraneMaterial. *)
				precipitationMembraneMaterial = Which[
					(*If user-set, then use set value.*)
					And[MatchQ[Lookup[options, PrecipitationMembraneMaterial], Except[Automatic]], KeyExistsQ[options, PrecipitationMembraneMaterial]],
						Lookup[options, PrecipitationMembraneMaterial],
					(* If a Method is used, then set to the value from the Method if it is specified. *)
					And[methodSpecifiedQ, MatchQ[Lookup[methodPacket, PrecipitationMembraneMaterial, Null], Except[Null]]],
						Lookup[methodPacket, PrecipitationMembraneMaterial],
					(*If Precipitation is not used and the option is not specified, it is set to Null.*)
					!precipitationUsedQ,
						Null,
					(* NOTE: ExperimentPrecipitation and ExperimentFilter doesn't actually resolve this correctly, so we'll do so here instead for now. *)
					(* If a filter is not specified, but a pore size is specified, then set to PES. *)
					And[
						MatchQ[Lookup[options,PrecipitationPoreSize], Except[Automatic|Null]],
						MatchQ[Lookup[options, PrecipitationFilter], Automatic]
					],
						PES,
					(*Otherwise, set to Automatic.*)
					True,
						Automatic
				];

				{
					precipitationTargetPhase,
					precipitationSeparationTechnique,
					precipitationReagent,
					precipitationReagentVolume,
					precipitationReagentTemperature,
					precipitationReagentEquilibrationTime,
					precipitationMixType,
					precipitationMixInstrument,
					precipitationMixRate,
					precipitationMixTemperature,
					precipitationMixTime,
					numberOfPrecipitationMixes,
					precipitationMixVolume,
					precipitationTime,
					precipitationInstrument,
					precipitationTemperature,
					precipitationFiltrationInstrument,
					precipitationFiltrationTechnique,
					precipitationFilter,
					precipitationPrefilterPoreSize,
					precipitationPrefilterMembraneMaterial,
					precipitationPoreSize,
					precipitationMembraneMaterial,
					precipitationFilterPosition,
					precipitationFilterCentrifugeIntensity,
					precipitationFiltrationPressure,
					precipitationFiltrationTime,
					precipitationFiltrateVolume,
					precipitationFilterStorageCondition,
					precipitationPelletVolume,
					precipitationPelletCentrifuge,
					precipitationPelletCentrifugeIntensity,
					precipitationPelletCentrifugeTime,
					precipitationSupernatantVolume,
					precipitationNumberOfWashes,
					precipitationWashSolution,
					precipitationWashSolutionVolume,
					precipitationWashSolutionTemperature,
					precipitationWashSolutionEquilibrationTime,
					precipitationWashMixType,
					precipitationWashMixInstrument,
					precipitationWashMixRate,
					precipitationWashMixTemperature,
					precipitationWashMixTime,
					precipitationNumberOfWashMixes,
					precipitationWashMixVolume,
					precipitationWashPrecipitationTime,
					precipitationWashPrecipitationInstrument,
					precipitationWashPrecipitationTemperature,
					precipitationWashCentrifugeIntensity,
					precipitationWashPressure,
					precipitationWashSeparationTime,
					precipitationDryingTemperature,
					precipitationDryingTime,
					precipitationResuspensionBuffer,
					precipitationResuspensionBufferVolume,
					precipitationResuspensionBufferTemperature,
					precipitationResuspensionBufferEquilibrationTime,
					precipitationResuspensionMixType,
					precipitationResuspensionMixInstrument,
					precipitationResuspensionMixRate,
					precipitationResuspensionMixTemperature,
					precipitationResuspensionMixTime,
					precipitationNumberOfResuspensionMixes,
					precipitationResuspensionMixVolume,
					precipitatedSampleContainerOut,
					precipitatedSampleStorageCondition,
					precipitatedSampleLabel,
					precipitatedSampleContainerLabel,
					unprecipitatedSampleContainerOut,
					unprecipitatedSampleStorageCondition,
					unprecipitatedSampleLabel,
					unprecipitatedSampleContainerLabel
				}
			]
		],
		{samplePackets,methodPackets,myMapThreadOptions}
	];

	{
		PrecipitationTargetPhase->resolvedPrecipitationTargetPhase,
		PrecipitationSeparationTechnique->resolvedPrecipitationSeparationTechnique,
		PrecipitationReagent->resolvedPrecipitationReagent,
		PrecipitationReagentVolume->resolvedPrecipitationReagentVolume,
		PrecipitationReagentTemperature->resolvedPrecipitationReagentTemperature,
		PrecipitationReagentEquilibrationTime->resolvedPrecipitationReagentEquilibrationTime,
		PrecipitationMixType->resolvedPrecipitationMixType,
		PrecipitationMixInstrument->resolvedPrecipitationMixInstrument,
		PrecipitationMixRate->resolvedPrecipitationMixRate,
		PrecipitationMixTemperature->resolvedPrecipitationMixTemperature,
		PrecipitationMixTime->resolvedPrecipitationMixTime,
		NumberOfPrecipitationMixes->resolvedNumberOfPrecipitationMixes,
		PrecipitationMixVolume->resolvedPrecipitationMixVolume,
		PrecipitationTime->resolvedPrecipitationTime,
		PrecipitationInstrument->resolvedPrecipitationInstrument,
		PrecipitationTemperature->resolvedPrecipitationTemperature,
		PrecipitationFiltrationInstrument->resolvedPrecipitationFiltrationInstrument,
		PrecipitationFiltrationTechnique->resolvedPrecipitationFiltrationTechnique,
		PrecipitationFilter->resolvedPrecipitationFilter,
		PrecipitationPrefilterPoreSize->resolvedPrecipitationPrefilterPoreSize,
		PrecipitationPrefilterMembraneMaterial->resolvedPrecipitationPrefilterMembraneMaterial,
		PrecipitationPoreSize->resolvedPrecipitationPoreSize,
		PrecipitationMembraneMaterial->resolvedPrecipitationMembraneMaterial,
		PrecipitationFilterPosition->resolvedPrecipitationFilterPosition,
		PrecipitationFilterCentrifugeIntensity->resolvedPrecipitationFilterCentrifugeIntensity,
		PrecipitationFiltrationPressure->resolvedPrecipitationFiltrationPressure,
		PrecipitationFiltrationTime->resolvedPrecipitationFiltrationTime,
		PrecipitationFiltrateVolume->resolvedPrecipitationFiltrateVolume,
		PrecipitationFilterStorageCondition->resolvedPrecipitationFilterStorageCondition,
		PrecipitationPelletVolume->resolvedPrecipitationPelletVolume,
		PrecipitationPelletCentrifuge->resolvedPrecipitationPelletCentrifuge,
		PrecipitationPelletCentrifugeIntensity->resolvedPrecipitationPelletCentrifugeIntensity,
		PrecipitationPelletCentrifugeTime->resolvedPrecipitationPelletCentrifugeTime,
		PrecipitationSupernatantVolume->resolvedPrecipitationSupernatantVolume,
		PrecipitationNumberOfWashes->resolvedPrecipitationNumberOfWashes,
		PrecipitationWashSolution->resolvedPrecipitationWashSolution,
		PrecipitationWashSolutionVolume->resolvedPrecipitationWashSolutionVolume,
		PrecipitationWashSolutionTemperature->resolvedPrecipitationWashSolutionTemperature,
		PrecipitationWashSolutionEquilibrationTime->resolvedPrecipitationWashSolutionEquilibrationTime,
		PrecipitationWashMixType->resolvedPrecipitationWashMixType,
		PrecipitationWashMixInstrument->resolvedPrecipitationWashMixInstrument,
		PrecipitationWashMixRate->resolvedPrecipitationWashMixRate,
		PrecipitationWashMixTemperature->resolvedPrecipitationWashMixTemperature,
		PrecipitationWashMixTime->resolvedPrecipitationWashMixTime,
		PrecipitationNumberOfWashMixes->resolvedPrecipitationNumberOfWashMixes,
		PrecipitationWashMixVolume->resolvedPrecipitationWashMixVolume,
		PrecipitationWashPrecipitationTime->resolvedPrecipitationWashPrecipitationTime,
		PrecipitationWashPrecipitationInstrument->resolvedPrecipitationWashPrecipitationInstrument,
		PrecipitationWashPrecipitationTemperature->resolvedPrecipitationWashPrecipitationTemperature,
		PrecipitationWashCentrifugeIntensity->resolvedPrecipitationWashCentrifugeIntensity,
		PrecipitationWashPressure->resolvedPrecipitationWashPressure,
		PrecipitationWashSeparationTime->resolvedPrecipitationWashSeparationTime,
		PrecipitationDryingTemperature->resolvedPrecipitationDryingTemperature,
		PrecipitationDryingTime->resolvedPrecipitationDryingTime,
		PrecipitationResuspensionBuffer->resolvedPrecipitationResuspensionBuffer,
		PrecipitationResuspensionBufferVolume->resolvedPrecipitationResuspensionBufferVolume,
		PrecipitationResuspensionBufferTemperature->resolvedPrecipitationResuspensionBufferTemperature,
		PrecipitationResuspensionBufferEquilibrationTime->resolvedPrecipitationResuspensionBufferEquilibrationTime,
		PrecipitationResuspensionMixType->resolvedPrecipitationResuspensionMixType,
		PrecipitationResuspensionMixInstrument->resolvedPrecipitationResuspensionMixInstrument,
		PrecipitationResuspensionMixRate->resolvedPrecipitationResuspensionMixRate,
		PrecipitationResuspensionMixTemperature->resolvedPrecipitationResuspensionMixTemperature,
		PrecipitationResuspensionMixTime->resolvedPrecipitationResuspensionMixTime,
		PrecipitationNumberOfResuspensionMixes->resolvedPrecipitationNumberOfResuspensionMixes,
		PrecipitationResuspensionMixVolume->resolvedPrecipitationResuspensionMixVolume,
		PrecipitatedSampleContainerOut->resolvedPrecipitatedSampleContainerOut,
		PrecipitatedSampleStorageCondition->resolvedPrecipitatedSampleStorageCondition,
		PrecipitatedSampleLabel->resolvedPrecipitatedSampleLabel,
		PrecipitatedSampleContainerLabel->resolvedPrecipitatedSampleContainerLabel,
		UnprecipitatedSampleContainerOut->resolvedUnprecipitatedSampleContainerOut,
		UnprecipitatedSampleStorageCondition->resolvedUnprecipitatedSampleStorageCondition,
		UnprecipitatedSampleLabel->resolvedUnprecipitatedSampleLabel,
		UnprecipitatedSampleContainerLabel->resolvedUnprecipitatedSampleContainerLabel
	}

];
