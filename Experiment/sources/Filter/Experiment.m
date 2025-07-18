(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Options *)

DefineOptions[ExperimentFilter,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			(* --- STANDARD LABEL OPTIONS --- *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the sample that goes into the filter, for use in downstream unit operations.",
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
				Description -> "A user defined word or phrase used to identify the sample's container that goes into the filter, for use in downstream unit operations.",
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
				OptionName -> FiltrateLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample that has gone through the filter, for use in downstream unit operations.",
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
				OptionName -> FiltrateContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the sample that has gone through the filter, for use in downstream unit operations.",
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
				OptionName -> RetentateLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample that was retained on the filter and subsequently collected, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> RetentateContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the sample that was retained on the filter and subsequently collected, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample collected at the end of the filtration (either the Filtrate or Retentate), for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to the value of RetentateLabel if Target -> Retentate, or FiltrateLabel if Target -> Filtrate.",
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
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the sample collected at the end of the filtration (either the Filtrate or Retentate), for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to the value of RetentateContainerLabel if Target -> Retentate, or FiltrateContainerLabel if Target -> Filtrate.",
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
				OptionName -> FilterLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the filter through which the sample is forced, for use in downstream unit operations.",
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
				OptionName -> CollectionContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the label of the container that will be used to accumulate the filtrate when filtering by Centrifuge or Vacuum and Buchner funnel (if applicable), for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ResuspensionBufferLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample in which the retentate is resuspended prior to being transferred to RetentateDestinationWell of RetentateContainerOut, for use in downstream unit operations",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ResuspensionBufferContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample in which the retentate is resuspended prior to being transferred to RetentateDestinationWell of RetentateContainerOut.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> RetentateWashBufferLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different buffers per input sample.",
				Category -> "General",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					Adder[Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					]]
				],
				UnitOperation -> True
			},
			{
				OptionName -> RetentateWashBufferContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container holding the sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different buffers per input sample.",
				Category -> "General",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					Adder[Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					]]
				],
				UnitOperation -> True
			},

			(* want General options to show up before Method options in command builder and all the ones above are hidden so put it here *)
			{
				OptionName -> CollectionContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "The container that will be used to accumulate the filtrate when filtering by Centrifuge or Vacuum and Buchner funnel (if applicable).",
				Category -> "General"
			},
			{
				OptionName -> RetentateCollectionContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]}
				],
				Description -> "The container that will be used to accumulate the retentate after filtering by Centrifuge and centrifuging the inverted container.",
				Category -> "Hidden"
			},

			(* --- General Method options that matter for everything --- *)
			(* information about the filtration method *)
			{
				OptionName -> FiltrationType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> FiltrationTypeP], (* PeristalticPump | Centrifuge | Vacuum | Syringe | AirPressure *)
				Description -> "The type of dead-end filtration method that should be used to perform the filtration. This option can only be set to AirPressure if Preparation->Robotic.",
				ResolutionDescription -> "Will be automatically set to a filtration type appropriate for the volume of sample being filtered.",
				Category -> "Method"
			},
			{
				OptionName -> Time,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
				Category -> "Method",
				Description -> "The amount of time for which the samples will be filtered.",
				ResolutionDescription -> "For Syringe filtration, automatically set to the MaxVolume of the syringe divided by the desired flow rate. This option may be overwritten if both FlowRate and Time options are provided. For other filtration types, automatically set to 5 minutes, or the value of MaxTime, whichever is shorter."
			},
			{
				OptionName -> FilterUntilDrained,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Method",
				Description -> "Indicates if the filtration should be continued until the sample has all been filtered, or up to the MaxTime, in an attempt to filter the entire sample.",
				ResolutionDescription -> "Automatically set to True if MaxTime is specified, or if Type is set to PeristalticPump or Vacuum.  Automatically set to False otherwise."
			},
			{
				OptionName -> MaxTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
				Category -> "Method",
				Description -> "Maximum duration of time for which the samples will be filtered, if the FilterUntilDrained option is chosen. Note this option only applies for filtration types: PeristalticPump or Vacuum.",
				ResolutionDescription -> "Automatically set to 3 * Time if Type is PeristalticPump or Vacuum, or Null otherwise."
			},
			{
				OptionName -> Intensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
					"Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
				],
				Category -> "Protocol",
				Description -> "The rotational speed or force at which the samples will be centrifuged during filtration.",
				ResolutionDescription -> "Will be automatically set to 2000 GravitationalAcceleration if filtering type is Centrifuge."
			},
			{
				OptionName -> CounterbalanceWeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Gram, 500 Gram], Units -> Alternatives[Gram, Milligram]],
				Description -> "The weight of the item used as a counterweight for the centrifuged container, its contents, and the associated collection container (if applicable).",
				Category -> "Hidden"
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, PeristalticPump],
						Object[Instrument, PeristalticPump],
						Model[Instrument, VacuumPump],
						Object[Instrument, VacuumPump],
						Model[Instrument, Centrifuge],
						Object[Instrument, Centrifuge],
						Model[Instrument, SyringePump],
						Object[Instrument, SyringePump],
						(* MPE2s *)
						Model[Instrument, PressureManifold],
						Object[Instrument, PressureManifold]
					}],
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
				Description -> "The instrument that should be used to perform the filtration. This option can only be set to pressure filter if Preparation->Robotic.",
				ResolutionDescription -> "Will be automatically set to an instrument appropriate for the filtration type.",
				Category -> "Method"
			},
			{
				OptionName -> Syringe,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Container, Syringe],
						Object[Container, Syringe]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Syringes"
						}
					}
				],
				Description -> "The syringe used to force that sample through a filter.",
				ResolutionDescription -> "Automatically set to an syringe appropriate to the volume of sample being filtered.",
				Category -> "Method"
			},
			{
				OptionName -> FlowRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,
					Pattern :> RangeP[0.1 Milliliter / Minute, 20 Milliliter / Minute],
					Units -> {Milliliter / Minute, {Milliliter / Minute}}
				],
				Category -> "Method",
				Description -> "The rate at which the syringe pump will dispense liquid from the syringe and through the filter.",
				ResolutionDescription -> "Automatically set to the 0.2 * MaxVolume of the syringe per minute."
			},
			{
				OptionName -> Sterile,
				Default -> Automatic,
				Description -> "Indicates if the filtration of the samples should be done in a sterile environment.",
				ResolutionDescription -> "Automatically set to True if WorkCell is set to bioSTAR, or if Instrument is set to Model[Instrument, Centrifuge, \"HiG4\"].",
				AllowNull -> False,
				Category -> "Method",
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
			},
			(* giant metal thing for peristaltic pump, or the filter block that holds the things that will be vacuumed *)
			{
				OptionName -> FilterHousing,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, FilterHousing],
						Object[Instrument, FilterHousing],
						Model[Instrument, FilterBlock],
						Object[Instrument, FilterBlock]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Dead-End Filtering Devices"
						}
					}
				],
				Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane on peristaltic pump.",
				ResolutionDescription -> "Automatically set to a housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used.",
				Category -> "Method"
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[-10 Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
				Category -> "Method",
				Description -> "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration.",
				ResolutionDescription -> "Will be automatically set to $AmbientTemperature if filtering type is Centrifuge."
			},

			(* options about the type of filter material *)
			{
				OptionName -> Filter,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Container, Plate, Filter], Object[Container, Plate, Filter],
							(* bottle top filter *)
							Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
							(* paper that goes in peristaltic pumps, or syringe filters *)
							Model[Item, Filter], Object[Item, Filter],
							Model[Item, ExtractionCartridge], Object[Item, ExtractionCartridge]
						}
					],
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
				Description -> "The filter that should be used to remove impurities from the sample.",
				ResolutionDescription -> "Will be automatically set to a filter appropriate for the filtration type and instrument. If the sample is already in a filter, it will not be moved to a new one unless explicitly specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> FilterPosition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size -> Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Description -> "The desired position in the Filter in which the samples should be placed for the filtering.",
				ResolutionDescription -> "If the input sample is already in a filter, automatically set to the current position.  Otherwise, selects the first empty position in the Filter according to the order indicated in Flatten[AllWells[]] if using container filters, or Null otherwise.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> Volume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]],
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter, 10 Milliliter],
						Units -> {Milliliter, {Microliter, Milliliter, Liter}}
					]
				],
				Description -> "The amount of sample to be transferred into the filter (if it is not already there) prior to its filtration. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to All if the filtering robotically, or Null otherwise."
			},
			{
				OptionName -> Pressure,
				Default -> Automatic,
				Description -> "The target pressure applied to the filter. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to 40 PSI if Method -> AirPressure or Null otherwise.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 PSI],
					Units -> {PSI, {PSI, Bar, Pascal}}
				]
			},
			{
				OptionName -> MembraneMaterial,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
				Description -> "The material from which the filtration membrane should be made of.",
				ResolutionDescription -> "Will be automatically set to PES or to the MembraneMaterial of Filter if it is specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> PrefilterMembraneMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
				Description -> "The material from which the prefilter filtration membrane should be made of.",
				ResolutionDescription -> "Will be automatically set to GxF if a prefilter pore size is specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> PoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
				Description -> "The pore size of the filter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription -> "Will be automatically set to .22 Micron or to the PoreSize of Filter if it is specified. Will be automatically set to Null if MolecularWeightCutoff is specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> MolecularWeightCutoff,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> FilterMolecularWeightCutoffP],
				Description -> "The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription -> "Will be automatically set to Null or to the MolecularWeightCutoff of Filter if it is specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> PrefilterPoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
				Description -> "The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
				ResolutionDescription -> "Will be automatically set to .45 Micron if a prefilter membrane material is specified.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> FilterStorageCondition,
				Default -> Disposal,
				AllowNull -> True,
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Disposal
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						PreparedSample -> False,
						PreparedContainer -> False,
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions"
							}
						}
					]
				],
				Description -> "The conditions under which any filters used by this experiment should be stored after the protocol is completed.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> Counterweight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern:>ObjectP[{Model[Item, Counterweight], Object[Item, Counterweight]}],
					PreparedSample -> True
				],
				Description -> "The counterweight to the input container. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to the appropriate model for the weight of the samples if FiltrationType -> Centrifuge, or Null otherwise.",
				Category -> "Method"
			},
			(* retentate-related options *)
			{
				OptionName -> Target,
				Default -> Filtrate,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> Filtrate | Retentate],
				Description -> "Indicates if the filtrate samples or retentate samples should populate SamplesOut.  Note that if set to Retentate, Filtrate will still be collected as well, just not populated in SamplesOut.",
				Category -> "Protocol"
			},
			{
				OptionName -> CollectRetentate,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the retentate captured by the filter should be retrieved by direct transfer or resuspension in a new buffer. Note that the Filtrate will always be collected as well, and whether the Filtrate or Retentate are the SamplesOut is dictated by the Target option.",
				ResolutionDescription -> "Automatically set to True if RetentateContainerOut, RetentateDestinationWell, ResuspensionVolume, ResuspensionBuffer, RetentateCollectionMethod, ResuspensionCentrifugeIntensity, or ResuspensionCentrifugeTime are specified, or False otherwise.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> RetentateCollectionMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Resuspend | Centrifuge | Transfer (* Transfer could be liquid or solid *)
				],
				Description -> "Indicates how resuspended retentate should be transferred into RetentateContainerOut.",
				ResolutionDescription -> "Automatically set to Centrifuge if CollectRetentate -> True and using centrifuge filters that can be inverted inside a new tube and centrifuged again in order to collect retentate.  In all other cases, if CollectRetentate is True then set to Resuspend, or Null otherwise.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> RetentateContainerOut,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
						]
					}
				],
				Description -> "The desired container retentate samples should be transferred into after filtering, with indices indicating grouping of samples in the same plates.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the ResuspensionVolume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one. If not collecting the retentate, automatically set to Null.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> RetentateDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size -> Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Description -> "The desired position in the corresponding RetentateContainerOut in which the retentate samples will be placed.",
				ResolutionDescription -> "Automatically set to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells. If not collecting the retentate, automatically set to Null.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> CollectOccludingRetentate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates that if the filter becomes occluded or clogged during the course of filtration, all retentate that cannot be passed through the filter should be collected into the OccludingRetentateContainer.  Note that this is currently only done during syringe filtering; for all other filtration types, use the CollectRetentate boolean directly.",
				ResolutionDescription -> "Automatically set to True if FiltrationType is set to Syringe or if OccludingRetentateContainer or OccludingRetentateContainerLabel are specified, and False otherwise.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> OccludingRetentateContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "Indicates the container into which the retentate should be transferred if the filter becomes clogged.",
				ResolutionDescription -> "Automatically set to Null if CollectOccludingRetentate is False, and set to the PreferredContainer of the input sample volume if CollectOccludingRetentate is True",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> OccludingRetentateDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size -> Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Description -> "The desired position in the corresponding OccludingRetentateContainer in which the occluding retentate samples will be placed.",
				ResolutionDescription -> "Automatically set to Null if CollectOccludingRetentate is False.  Automatically set to A1 in containers with only one positionFor plates, fills wells in the order provided by the function AllWells. If not collecting the retentate, automatically set to Null.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> OccludingRetentateContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the sample that clogged a filter and was subsequently collected, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> WashRetentate, (* Not allowed for thing where retentate can't be washed (Syringe) *)
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the retentate captured by the filter should be washed with a buffer prior to collection.",
				ResolutionDescription -> "Automatically set to True if RetentateWashBuffer, RetentateWashVolume, NumberOfRetentateWashes, RetentateWashTime, or RetentateWashCentrifugeIntensity is specified, or False otherwise.",
				Category -> "Retentate Washing"
			},
			(* all of the RetentateWash options below need to be multiple multiple *)
			{
				OptionName -> RetentateWashBuffer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes -> {Model[Sample], Object[Sample]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Water"
							}
						}
					],
					Adder[Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							ObjectTypes -> {Model[Sample], Object[Sample]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials",
									"Reagents",
									"Water"
								}
							}
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different buffers per input sample.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if collecting retentate, or Null if not.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> RetentateWashVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Microliter, 20 Liter],
							Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The amount of RetentateWashBuffer that is run through the retentate and filter after initial filtration prior to retentate collection.",
				ResolutionDescription -> "Automatically set to the initial volume of the input sample if WashRetentate -> True, or Null otherwise.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> NumberOfRetentateWashes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]],
					Adder[Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]]],
					Adder[Widget[Type -> Enumeration,Pattern :> Alternatives[Null, Automatic]]]
				],
				Description -> "The number of times to run RetentateWashBuffer through the retentate and filter after initial filtration prior to retentate collection. Note that if this number is greater than 1, all those washes will go into the same WashFlowThroughContainer.",
				ResolutionDescription -> "Automatically set to 1 if WashRetentate -> True, or Null otherwise.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> RetentateWashDrainTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
					Adder[Alternatives[
						Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
						Widget[Type -> Enumeration,Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Category -> "Protocol",
				Description -> "The amount of time for which the samples will be washed with RetentateWashBuffer after initial filtration and prior to retentate collection.",
				ResolutionDescription -> "Automatically set to the value of the Time option if WashRetentate -> True, or Null otherwise.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> RetentateWashCentrifugeIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Speed" -> Alternatives[
						Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
						Adder[Alternatives[
							Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
							Widget[Type -> Enumeration,Pattern :> Alternatives[Null, Automatic]]
						]]
					],
					"Force" -> Alternatives[
						Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}],
						Adder[Alternatives[
							Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}],
							Widget[Type -> Enumeration,Pattern :> Alternatives[Null, Automatic]]
						]]
					]
				],
				Category -> "Retentate Washing",
				Description -> "The rotational speed or force at which the retentate that has been washed with RetentateWashBuffer after initial filtration and prior to retentate collection.",
				ResolutionDescription -> "Will be automatically set to CentrifugeIntensity if Method -> Centrifuge and WashRetentate -> True, or Null otherwise."
			},
			{
				OptionName -> RetentateWashMix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "Indicates if after RetentateWashBuffer is added to the retentate, the retentate should be mixed prior to filtering wash buffer out.",
				ResolutionDescription -> "Automatically set to False if CollectRetentate -> True, or Null otherwise.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> NumberOfRetentateWashMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]],
					Adder[Alternatives[
						Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "Number of times the retentate should be pipetted if WashRetentate -> True and RetentateWashMix -> True.",
				ResolutionDescription -> "Automatically set to 10 if WashRetentate -> True and RetentateWashMix -> True, or Null otherwise.",
				Category -> "Retentate Washing"
			},
			{
				OptionName -> RetentateWashPressure,
				Default -> Automatic,
				Description -> "The target pressure applied to the retentate that has been washed with RetentateWashBuffer after initial filtration and prior to retentate collection. This option can only be set if Preparation->Robotic.",
				ResolutionDescription -> "Automatically set to the value of the Pressure option if Method -> AirPressure and WashRetentate -> True, or Null otherwise.",
				AllowNull -> True,
				Category -> "Retentate Washing",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 PSI],
						Units -> {PSI, {PSI, Bar, Pascal}}
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 PSI],
							Units -> {PSI, {PSI, Bar, Pascal}}
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				]
			},
			{
				OptionName -> WashFlowThroughLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					Adder[Alternatives[
						Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The label of the sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different labels for flow through samples per input sample.",
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> WashFlowThroughContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Line
					],
					Adder[Alternatives[
						Widget[
							Type -> String,
							Pattern :> _String,
							Size -> Line
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The label of the container holding sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different labels for containers of flow through samples per input sample.",
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> WashFlowThroughContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					Adder[Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The container holding sample that is run through the retentate and filter after initial filtration prior to retentate collection. This value can contain one or multiple different containers of flow through samples per input sample.",
				ResolutionDescription -> "Automatically set to the same value as FiltrateContainerOut if WashRetentate -> True, or Null otherwise.",
				Category -> "General"
			},
			{
				OptionName -> WashFlowThroughDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> String,
						Pattern :> WellPositionP,
						Size -> Line,
						PatternTooltip -> "Enumeration must be any well from A1 to H12."
					],
					Adder[Alternatives[
						Widget[
							Type -> String,
							Pattern :> WellPositionP,
							Size -> Line,
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
					]]
				],
				Description -> "The position in the container holding sample that is run through the retentate and filter after initial filtration prior to retentate collection.",
				ResolutionDescription -> "Automatically set to the same value as FiltrateContainerOut if WashRetentate -> True, or Null otherwise.",
				Category -> "General"
			},
			{
				OptionName -> WashFlowThroughStorageCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Storage Type" -> Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> SampleStorageTypeP | Disposal
						],
						Adder[Alternatives[
							Widget[
								Type -> Enumeration,
								Pattern :> SampleStorageTypeP | Disposal
							],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
						]]
					],
					"Storage Object" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Model[StorageCondition]],
							PreparedSample -> False,
							PreparedContainer -> False,
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Storage Conditions"
								}
							}
						],
						Adder[Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[StorageCondition]],
								PreparedSample -> False,
								PreparedContainer -> False,
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Storage Conditions"
									}
								}
							],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Null, Automatic]]
						]]
					]
				],
				Description -> "The conditions under which any retentate wash flow through generated by this experiment should be stored after the protocol is completed.",
				ResolutionDescription -> "Automatically set to the same value as SamplesOutStorageCondition if WashRetentate -> True, or Null otherwise.",
				Category -> "Filter Properties"
			},
			{
				OptionName -> ResuspensionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				],
				Description -> "The volume of ResuspensionBuffer to be added to the retentate.  This amount will subsequently be resuspended and transferred to RetentateDestinationWell of RetentateContainerOut.",
				ResolutionDescription -> "Automatically set to smaller of the MaxVolume of the RetentateContainerOut and the initial volume of the sample. If not collecting the retentate, automatically set to Null.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> ResuspensionBuffer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					ObjectTypes -> {Model[Sample], Object[Sample]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				Description -> "The desired sample in which the retentate is resuspended prior to being transferred to RetentateDestinationWell of RetentateContainerOut.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if collecting retentate, or Null if not.",
				Category -> "Retentate Collection"
			},
			{
				OptionName -> NumberOfResuspensionMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 50, 1]],
				Description -> "Number of times the retentate should be pipetted if RetentateCollectionMethod -> Transfer.",
				ResolutionDescription -> "Automatically set to 10 if RetentateCollectionMethod -> Transfer, or Null otherwise.",
				Category -> "Retentate Collection"
			},

			{
				OptionName -> PrewetFilter,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if the filter should be pre-wet with PrewetFilterBuffer before the input sample is run through it.",
				ResolutionDescription -> "Automatically set to True if any of the other prewetting options are specified or if the filter has StorageBuffer -> True, or False otherwise.",
				Category -> "Prewetting"
			},
			{
				OptionName -> NumberOfFilterPrewettings,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					(* Note that setting the maximum to 5 here is significant because the procedure only allows you to do it that many times; if you change that you have to change the procedure too *)
					Pattern :> RangeP[1, 5, 1]
				],
				Description -> "Number of times the filter should be pre-wet with PrewetFilterBuffer before the input sample is run through it.  Note that if there is liquid already in the filter, the first iteration will NOT add any buffer.",
				ResolutionDescription -> "Automatically set to 3 if PrewetFilter -> True and the Filter has StorageBuffer -> True, or 1 if PrewetFilter -> True otherwise, or Null if PrewetFilter -> False.",
				Category -> "Prewetting"
			},
			{
				OptionName -> PrewetFilterTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
				Description -> "Indicates the length of time the PrewetFilterBuffer is run through the filter to pre-wet it.",
				ResolutionDescription -> "Automatically set to 5 Minute if FiltrationType is set to Centrifuge, or Null otherwise.",
				Category -> "Prewetting"
			},
			{
				OptionName -> PrewetFilterBufferVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				],
				Description -> "Indicates the amount of PrewetFilterBuffer to run through the filter prior to running the sample through.",
				ResolutionDescription -> "If the filter has StorageBuffer -> True, automatically set to the filter's StorageBufferVolume.  If PrewetFilter -> True otherwise, automatically set to the lesser of 5% of the input sample's volume and the MaxVolume of the filter.  Otherwise set to Null.",
				Category -> "Prewetting"
			},
			{
				OptionName -> PrewetFilterCentrifugeIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
					"Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
				],
				Category -> "Protocol",
				Description -> "The rotational speed or force at which the PrewetFilterBuffer will be centrifuged prior to filtration.",
				ResolutionDescription -> "Will be automatically set to the value of Intensity of centrifuging, or Null otherwise."
			},
			{
				OptionName -> PrewetFilterBuffer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					ObjectTypes -> {Model[Sample], Object[Sample]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				],
				Description -> "Indicates the sample to run through the filter prior to running the input sample through the filter.  Note that this is only supported if Preparation -> Manual.",
				ResolutionDescription -> "Automatically set to the Solvent field of the input sample, or the model of the input sample if it exists and UsedAsSolvent is set to True, or Milli-Q water if it is not, or Null if PrewetFilter is False.",
				Category -> "Prewetting"
			},
			{
				OptionName -> PrewetFilterBufferLabel,
				Default -> Automatic,
				Description -> "The label of the sample run through the fitler prior to running the input sample through the filter.",
				AllowNull -> True,
				Category -> "Prewetting",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> PrewetFilterContainerOut,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "The container that is be used to accumulate the filtrate during the prewetting step.",
				ResolutionDescription -> "Automatically set to Null if PrewetFilter is set to False.  Otherwise, automatically set to the same container model as the CollectionContainer if it is specified, or the same model as the FiltrateContainerOut otherwise.",
				Category -> "Prewetting"
			},
			{
				OptionName -> PrewetFilterContainerLabel,
				Default -> Automatic,
				Description -> "The label of the container that is be used to accumulate the filtrate during the prewetting step.",
				AllowNull -> True,
				Category -> "Prewetting",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			(* Old SM needs this; new framework does _not_ need this  *)
			{
				OptionName -> SampleOut,
				Default -> Null,
				Description -> "Indicates that the final sample out has already been created in the container out therefore a new sample will not be created.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Sample]]]
			},
			{
				OptionName -> FiltrateContainerOut,
				Default -> Automatic,
				Description -> "The desired container generated samples should be produced in or transferred into by the end of the experiment, with indices indicating grouping of samples in the same plates.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the Volume of the sample. For plates, attempts to fill all wells of a single plate with the same model before using another one.",
				AllowNull -> False,
				Category -> "Protocol",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Water"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[Type -> Number, Pattern :> GreaterEqualP[1, 1]],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials",
										"Reagents",
										"Water"
									}
								}
							],
							Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]]
						]
					}
				]
			},
			{
				OptionName -> FiltrateDestinationWell,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Protocol",
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size -> Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Description -> "The desired position in the corresponding FiltrateContainerOut in which the filtrate samples will be placed.",
				ResolutionDescription -> "Automatically set to A1 in containers with only one position.  For plates, automatically set to the corresponding value of the FilterPosition option if the CollectionContainer and FiltrateContainerOut are the same.  Otherwise, fills wells in the order provided by the function AllWells."
			},
			TransferTipOptions,
			TransferRoboticTipOptions
		],
		{
			OptionName -> WashAndResuspensionTips,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Adder[Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Item, Tips],
						Object[Item, Tips]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips"
						}
					}
				]],
				Widget[Type -> Enumeration, Pattern :> Alternatives[{}]]
			],
			Description -> "The pipette tips used to aspirate and dispense the retentate wash and resuspension buffers.",
			Category -> "Hidden"
		},
		{
			OptionName -> FiltrateContainerOutTips,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Adder[Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Item, Tips],
						Object[Item, Tips]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Labware",
							"Pipette Tips"
						}
					}
				]],
				Widget[Type -> Enumeration, Pattern :> Alternatives[{}]]
			],
			Description -> "The pipette tips used to aspirate and dispense the filtrate into the FiltrateContainerOut and WashFlowThroughContainer.",
			Category -> "Hidden"
		},
		{
			OptionName -> EnableSamplePreparation,
			Default -> True,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the sample preparation options for this function should be resolved. This option is set to False when an experiment is called within resolveSamplePrepOptions to avoid an infinite loop.",
			Category -> "Hidden"
		},
		IncubatePrepOptionsNew,
		CentrifugePrepOptionsNew,
		AliquotOptions,
		PreparatoryUnitOperationsOption,
		ModelInputOptions,

		WorkCellOption,
		ProtocolOptions,
		SimulationOption, (* TODO: Remove this and add to ProtocolOptions when it is time to blitz. Also add SimulateProcedureOption. *)
		SamplesOutStorageOption, (* TODO actually populate this field *)
		NonBiologyPostProcessingOptions,
		PrimitiveOutputOption,
		CacheOption,
		PreparationOption
	}
];


(* ::Subsection:: *)
(*ExperimentFilter*)


(* Mixed Input *)
ExperimentFilter[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions: OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult,containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make the inputs and options a list *)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFilter,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentFilter,
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
				ExperimentFilter,
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
		ExperimentFilter[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* Sample input/core overload *)
ExperimentFilter[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, samplesWithPreparedSamples,
		optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests, instruments, filters, rotors,
		buckets, adapters, syringes, filterHousings, templatedOptions, templateTests, inheritedOptions, expandedSafeOpsWithoutMultipleMultiples,
		preferredContainers, containerOutObjects, containerOutModels, collectionFilters, sampleOutObjects, instrumentOption,
		instrumentObjects, allObjects, allInstruments, allContainers, allSyringes, objectSampleFields,modelSampleFields,objectContainerFields,
		modelContainerFields, packetObjectSample, specifiedCollectionContainerModels, specifiedCollectionContainerObjs,
		specifiedCollectionContainerModelFields, specifiedCollectionContainerObjFields, specifiedBufferModels, specifiedBufferObjs,
		updatedSimulation, centrifugeRotorFields, filterHousingOption, centrifugeBucketFields, centrifugeAdapterFields,
		filterOption, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, tipFields, downloadedStuff, cacheBall, resolvedOptionsResult,
		vesselFilters, nonVesselFilters, filterObjects, filterModels, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		performSimulationQ, filterModelFields, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ,
		multipleMultipleExpandedOptions, allCounterweights, protocolPacketWithResources, resourcePacketTests, simulatedProtocol,
		simulation, resolvedPreparation, resolvedWorkCell, result, buchnerFunnels, filterAdapters, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		safeOptionsNamed, allContainerModels, transferRequiredField, transferModelContainerRequiredField, transferObjectContainerRequiredField,
		postProcessingOptions, times, filterLabel, uniqueTimes, totalTimesEstimate, allTips
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFilter,
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
		SafeOptions[ExperimentFilter, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentFilter, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Replace all objects referenced by Name to ID *)
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
		ValidInputLengthsQ[ExperimentFilter, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentFilter, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
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
		ApplyTemplateOptions[ExperimentFilter, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFilter, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
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

	(* Get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	(* going to redo how we did multiple multiples next in the resolver, so the ones that are multiple multiple/nested index matching should be ignored *)

	(* Get the multiple multiple options *)
	multipleMultipleExpandedOptions = {
		RetentateWashBuffer,
		RetentateWashVolume,
		NumberOfRetentateWashes,
		RetentateWashDrainTime,
		RetentateWashCentrifugeIntensity,
		RetentateWashMix,
		NumberOfRetentateWashMixes,
		RetentateWashPressure,
		RetentateWashBufferLabel,
		RetentateWashBufferContainerLabel,
		WashFlowThroughLabel,
		WashFlowThroughContainerLabel,
		WashFlowThroughContainer,
		WashFlowThroughDestinationWell,
		WashFlowThroughStorageCondition
	};

	expandedSafeOpsWithoutMultipleMultiples = ReplaceRule[
		Last[ExpandIndexMatchedInputs[ExperimentFilter, {ToList[samplesWithPreparedSamples]}, inheritedOptions]],
		Select[inheritedOptions, MemberQ[multipleMultipleExpandedOptions, Keys[#]]&]
	];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)
	(* Use memoized search for centrifuge counterweights *)
	allCounterweights = allCounterweightsSearch["Memoization"];
	(* Do a huge search to get everything we could need *)
	{
		(*1*)instruments,
		(*2*)nonVesselFilters,
		(*3*)vesselFilters,
		(*4*)rotors,
		(*5*)buckets,
		(*6*)adapters,
		(*7*)syringes,
		(*8*)filterHousings,
		(*9*)buchnerFunnels,
		(*10*)filterAdapters
	} = Search[
		{
			(*1*){Model[Instrument, SyringePump], Model[Instrument, VacuumPump], Model[Instrument, PeristalticPump], Model[Instrument, Centrifuge], Model[Instrument, PressureManifold]},
			(*2*){Model[Item, Filter], Model[Container, Plate, Filter], Model[Item, ExtractionCartridge]},
			(*3*){Model[Container, Vessel, Filter]},
			(*4*){Model[Container, CentrifugeRotor]},
			(*5*){Model[Container, CentrifugeBucket]},
			(*6*){Model[Part, CentrifugeAdapter]},
			(*7*){Model[Container, Syringe]},
			(*8*){Model[Instrument, FilterBlock], Model[Instrument, FilterHousing]},
			(*9*){Model[Part, Funnel]},
			(*10*){Model[Part, FilterAdapter]}
		},
		{
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			(* only get the filters that have a destination that goes with them *)
			Deprecated != True && DestinationContainerModel != Null && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			(* only get the funnels that are for filter flasks (i.e., buchner funnels) *)
			Deprecated != True && FunnelType == Filter && FunnelMaterial == Porcelain && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True
		}
	];

	(* All possible tips that the resolver might use; we only care about hamilton tips for the purposes of this resolver *)
	allTips = TransferDevices[Model[Item, Tips], All, PipetteType -> Hamilton];

	(* All possible containers that the resolver might use *)
	preferredContainers = DeleteDuplicates[
		Flatten[{
			PreferredContainer[All, Type -> All],
			PreferredContainer[All, Sterile -> True, Type -> All],
			PreferredContainer[All, LightSensitive -> True, Type -> All],
			PreferredContainer[2 Milliliter, Type -> Plate], (* want the deep well plate, which at the time of writing this is the value PreferredContainer returns *)
			PreferredContainer[All, Sterile -> True, LiquidHandlerCompatible -> True, Type -> All],(* want the sterile deep well plate *)
			PreferredContainer[All, VacuumFlask -> True]
		}]
	];

	(* Any container the user provided (in case it's not on the PreferredContainer list) *)
	containerOutObjects = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOpsWithoutMultipleMultiples, {FiltrateContainerOut, RetentateContainerOut}]],
		ObjectP[Object]
	]];
	containerOutModels = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOpsWithoutMultipleMultiples, {FiltrateContainerOut, RetentateContainerOut}]],
		ObjectP[Model]
	]];
	sampleOutObjects = DeleteDuplicates[Cases[Flatten[{Lookup[templatedOptions, SampleOut]}], ObjectP[Object]]];

	(* Any filter that the user provided *)
	filterOption = Cases[Flatten[{Lookup[templatedOptions, Filter]}], ObjectP[]];

	(* Combine the vessel and non vessel filters *)
	filters = Flatten[{nonVesselFilters, vesselFilters}];

	(* Get the filter objects vs filter models *)
	filterObjects = Cases[filterOption, ObjectP[{Object[Item], Object[Container]}]];
	filterModels = Flatten[{
		phytipColumnModels[],
		Cases[filterOption, ObjectP[{Model[Item], Model[Container]}]]
	}];

	(* Separate out the collection filters from the list of all filters we found *)
	collectionFilters = Cases[filters, ObjectP[Model[Container, Vessel, Filter]]];

	(* Gather the instrument option *)
	instrumentOption = Lookup[expandedSafeOpsWithoutMultipleMultiples, Instrument];
	filterHousingOption = Lookup[expandedSafeOpsWithoutMultipleMultiples, FilterHousing];

	(* Pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
	instrumentObjects = Cases[Flatten[{instrumentOption, filterHousingOption}], ObjectP[Object[Instrument]]];

	(* Split things into groups by types (since we'll be downloading different things from different types of objects) *)
	allObjects = DeleteDuplicates[Flatten[{instruments, filterHousings, syringes, preferredContainers}]];
	allInstruments = Cases[allObjects, ObjectP[Model[Instrument]]];
	allContainerModels = Flatten[{
		Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, Plate]}]],
		Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[{Model[Container]}], Infinity]
	}];
	allContainers = Flatten[{Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[Object[Container]], Infinity]}];
	allSyringes = Cases[allObjects, ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]];

	(* Articulate all the fields needed *)
	(* Solvent and UsedAsSolvent are important for resolution of the prewetting options *)
	transferRequiredField = {
		RequestedResources,
		AsepticHandling,
		Pyrophoric,
		IncompatibleMaterials,
		RNaseFree,
		PipettingMethod,
		TransferTemperature,
		TransportCondition,
		Well,
		Density,
		ReversePipetting,
		ParticleWeight,
		Fuming,
		Ventilated,
		InertHandling,
		Parafilm,
		AluminumFoil,
		Anhydrous
	};
	transferModelContainerRequiredField = {
		Ampoule,
		Columns,
		Hermetic,
		HorizontalPitch,
		MultiProbeHeadIncompatible,
		Squeezable,
		TareWeight,
		VerticalPitch,
		VolumeCalibrations,
		Products
	};
	transferObjectContainerRequiredField = {
		RequestedResources,
		RNaseFree,
		Squeezable,
		TareWeight,
		Hermetic,
		Parafilm,
		AluminumFoil
	};
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]],transferRequiredField, {Solvent}];
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], transferRequiredField, {Solvent, UsedAsSolvent}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]], {KitComponents, MinTemperature, MaxTemperature, Opaque, MaxVolume, Notebook}, transferObjectContainerRequiredField];
	modelContainerFields = Union[
		SamplePreparationCacheFields[Model[Container]],
		{
			Name, Object, Sterile, InternalDepth, InternalDiameter, MinVolume, MaxVolume, Positions, Deprecated, Footprint, NumberOfWells, AspectRatio,
			SelfStanding, Dimensions, Aperture, OpenContainer, InternalDimensions, MaxTemperature, LiquidHandlerPrefix,
			Counterweights, FilterType, PoreSize, MolecularWeightCutoff, DestinationContainerModel, RetentateCollectionContainerModel, PrefilterPoreSize,
			Diameter, MembraneMaterial, PrefilterMembraneMaterial, InletConnectionType, OutletConnectionType, MaxPressure, RentByDefault, StorageBuffer, StorageBufferVolume,
			BuiltInCover, CoverTypes, CoverFootprints, Opaque, Reusable, EngineDefault, KitProducts, Products, Graduations, GraduationLabels, GraduationTypes, CrossSectionalShape
		},
		transferRequiredField,
		transferModelContainerRequiredField
	];
	(* Add Sterile and AsepticHandling for filter download fields in addition to modelContainerFields *)
	filterModelFields = Union[
		{Sterile, AsepticHandling},
		modelContainerFields
	];

	(* In the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Container[KitComponents][{Name, Object, Model, Sterile, Status, Contents, TareWeight, RequestedResources}]],
		Packet[Container[KitComponents][Model][{Name, FilterType, Sterile, InternalDepth, InternalDiameter, MinVolume, MaxVolume, Positions, Deprecated, Footprint, NumberOfWells, AspectRatio, SelfStanding, Dimensions, Aperture, DestinationContainerModel, RetentateCollectionContainerModel, OpenContainer, InternalDimensions, MaxTemperature, PoreSize, MolecularWeightCutoff, PrefilterPoreSize, MembraneMaterial, PrefilterMembraneMaterial}]],
		Packet[Model[modelSampleFields]]
	};

	(* Get the specified collection container objects and models *)
	specifiedCollectionContainerModels = Flatten[{
		Model[Container, Plate, "96-well UV-Star Plate"],
		Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
		Model[Container, Plate, "96-well 2mL Deep Well Plate"],
		Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
		Cases[ToList[Lookup[expandedSafeOpsWithoutMultipleMultiples, CollectionContainer]], ObjectP[Model]],
		Cases[ToList[Lookup[expandedSafeOpsWithoutMultipleMultiples, RetentateCollectionContainer]], ObjectP[Model]]
	}];
	specifiedCollectionContainerObjs = Flatten[{
		Cases[ToList[Lookup[expandedSafeOpsWithoutMultipleMultiples, CollectionContainer]], ObjectP[Object]],
		Cases[ToList[Lookup[expandedSafeOpsWithoutMultipleMultiples, RetentateCollectionContainer]], ObjectP[Object]]
	}];

	(* Get the specified collection container object and model Download fields *)
	specifiedCollectionContainerModelFields = {
		Packet[Sequence @@ modelContainerFields],
		Packet[Counterweights[{Weight, Footprint}]]
	};
	specifiedCollectionContainerObjFields = {
		Packet[Sequence @@ objectContainerFields],
		Packet[Model[modelContainerFields]],
		Packet[Model[Counterweights][{Weight, Footprint}]],
		Packet[Field[Contents[[All, 2]][{Volume, Mass, Model}]]]
	};

	(* Get the specified buffer objects and models *)
	specifiedBufferModels = Flatten[{
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, RetentateWashBuffer]}], ObjectP[Model]],
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, ResuspensionBuffer]}], ObjectP[Model]],
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, PrewetFilterBuffer]}], ObjectP[Model]]
	}];
	specifiedBufferObjs = Flatten[{
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, RetentateWashBuffer]}], ObjectP[Object]],
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, ResuspensionBuffer]}], ObjectP[Object]],
		Cases[Flatten[{Lookup[expandedSafeOpsWithoutMultipleMultiples, PrewetFilterBuffer]}], ObjectP[Object]]
	}];

	(* Get values necessary from tip models.  Only need a few fields *)
	tipFields = {
		Packet[AspirationDepth, Diameter3D]
	};


	(* Define Centrifuge download fields *)
	centrifugeRotorFields = centrifugeRotorDownloadFields[];
	centrifugeBucketFields = centrifugeBucketDownloadFields[];
	centrifugeAdapterFields = centrifugeAdapterDownloadFields[];

	(* Download all the things *)
	downloadedStuff = Quiet[Download[
		{
			(*1*)samplesWithPreparedSamples,
			(*2*)containerOutObjects,
			(*3*)containerOutModels,
			(*4*)sampleOutObjects,
			(*5*)sampleOutObjects,
			(*6*)sampleOutObjects,
			(*7*)allInstruments,
			(*8*)instrumentObjects,
			(*9*)allContainerModels,
			(*10*)allContainers,
			(*11*)allSyringes,
			(*12*)filterModels,
			(*13*)filterObjects,
			(*14*)filters,
			(*15*)collectionFilters,
			(*16*){parentProtocol},
			(*17*)rotors,
			(*18*)buckets,
			(*19*)adapters,
			(*20*)allCounterweights,
			(*21*)buchnerFunnels,
			(*22*)filterAdapters,
			(*23*)specifiedCollectionContainerModels,
			(*24*)specifiedCollectionContainerObjs,
			(*25*)specifiedBufferObjs,
			(*26*)specifiedBufferModels,
			(*27*)allTips[[All, 1]]
		},
		Evaluate[{
			(* samples *)
			(*1*)
			packetObjectSample,
			(* containerOut *)
			(*2*)
			{
				Packet[Name, Object, Model, Sterile, Status, Contents, TareWeight, RequestedResources],
				Packet[Model[modelContainerFields]]
			},
			(* containerOut models *)
			(*3*)
			{Evaluate[Packet@@modelContainerFields]},
			(* sampleOut *)
			(*4*)
			{Packet[Name, Volume, Container, Model, Mass, Count, Sterile, Status, Position, StorageCondition]},
			(* sampleOut container*)
			(*5*)
			{Packet[Container[{Name, Object, Model, Sterile, Status, Contents, TareWeight, RequestedResources}]]},
			(* sampleOut container model *)
			(*6*)
			{Packet[Container[Model][modelContainerFields]]},

			(* instrument models *)
			(*7*)
			{Packet[Name, AsepticHandling, MaxTime, MaxTemperature, MinTemperature, SpeedResolution, MaxRotationRate, MinRotationRate, CentrifugeType, Positions, Footprint, RequestedResources,MaxStackHeight,MaxWeight,WettedMaterials]},
			(* instrument objects *)
			(*8*)
			{Packet[Model,RequestedResources, Name]},
			(*9*)
			{Evaluate[Packet@@modelContainerFields]},
			(* all basic container models (from PreferredContainers) *)
			(*10*)
			{
				Evaluate[Packet @@ objectContainerFields],
				Packet[Model[modelContainerFields]]
			},
			(* syringes models *)
			(*11*)
			{
				Packet[Name, MaxVolume, Sterile, ConnectionType, Model],
				Packet[Model[{Name, MaxVolume, Sterile, ConnectionType}]]
			},
			(* filter inputs *)
			(*12*)
			{
				Evaluate[Packet @@ filterModelFields],
				Packet[KitProducts[KitComponents]]
			},
			(*13*)
			{
				Evaluate[Packet @@ objectContainerFields],
				Packet[Model[filterModelFields]],
				Packet[Field[Contents[[All, 2]][{Volume, Mass, Model, Name}]]],
				Field[Model[KitProducts][KitComponents]]
			},
			(* all possible filters *)
			(*14*)
			{
				Evaluate[Packet @@ filterModelFields],
				Packet[KitProducts[KitComponents]]
			},
			(*15*)
			{
				(* Grab the destination model container packets too *)
				Packet[DestinationContainerModel[modelContainerFields]],
				Packet[RetentateCollectionContainerModel[modelContainerFields]]
			},
			(*16*)
			{Packet[ImageSample, ParentProtocol, Financers, Name, Site]},
			(* Rotor/Bucket/Adapter *)
			(*17*)
			{Evaluate[Packet[Sequence @@ centrifugeRotorFields]]},
			(*18*)
			{Evaluate[Packet[Sequence @@ centrifugeBucketFields]]},
			(*19*)
			{Evaluate[Packet[Sequence @@ centrifugeAdapterFields]]},
			(*20*)
			{Packet[Footprint, Weight, Name, RentByDefault, Dimensions]},
			(*21*)
			{Packet[FunnelMaterial, FunnelType, MouthDiameter, StemDiameter, Name]},
			(*22*)
			{Packet[OuterDiameter, InnerDiameter, Name]},
			(*23*)
			specifiedCollectionContainerModelFields,
			(*24*)
			specifiedCollectionContainerObjFields,
			(*25*)
			(* buffer samples object *)
			packetObjectSample,
			(*26*)
			(* buffer samples model *)
			{Packet[Sequence @@ modelSampleFields]},
			(*27*)
			tipFields
		}],
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	(* Get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentFilterOptions[samplesWithPreparedSamples, expandedSafeOpsWithoutMultipleMultiples, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentFilterOptions[samplesWithPreparedSamples, expandedSafeOpsWithoutMultipleMultiples, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption, Error::ConflictingUnitOperationMethodRequirements}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentFilter,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* Lookup our resolved Preparation option. *)
	{resolvedPreparation, resolvedWorkCell} = Lookup[resolvedOptions, {Preparation, WorkCell}];

	(* Lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* If Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentFilter, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		gatherTests,
			filterResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> {Result, Tests}
			],
		True,
		{
			filterResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> Result
			],
			{}
		}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentFilter[
				protocolPacketWithResources[[1]], (* protocolPacket *)
				Flatten[ToList[protocolPacketWithResources[[2]]]], (* unitOperationPackets *)
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True, {Null, Null}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentFilter, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	postProcessingOptions = Map[
		If[
			MatchQ[Lookup[resolvedOptions, #], Except[Automatic]],
			# -> Lookup[resolvedOptions, #],
			Nothing
		]&,
		{ImageSample, MeasureVolume, MeasureWeight}
	];

	(* Get an estimated run time for robotic prep. Manual prep uses 25 min/sample place holder since we don't need this value. Our resources are created correctly *)
	{times, filterLabel} = Lookup[resolvedOptions, {Time, FilterLabel}];

	uniqueTimes = DeleteDuplicatesBy[Transpose[{times, filterLabel}], Last][[All, 1]];

	totalTimesEstimate = 1.2 * Total[uniqueTimes/.{Null -> 1 Minute}];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps, Upload], False],
			protocolPacketWithResources[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions, samplesMaybeWithModels, experimentFunction},

				(* convert the samples to models if we had model inputs originally *)
				(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
				(* NOTE: this is important. Need to use updatedSimulation here and not simulation.  This is because mySamples needs to get converted to model via the simulation _before_ SimulateResources is called in simulateExperimentFilter *)
				(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
				samplesMaybeWithModels = If[NullQ[updatedSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
					mySamples,
					simulatedSamplesToModels[
						Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
						updatedSimulation,
						mySamples
					]
				];

				(* Create our filter primitive to feed into RoboticSamplePreparation. *)
				primitive = Filter @@ Join[
					{
						Sample -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[Filter, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentFilter, resolvedOptions];

				(* Memoize the value of ExperimentFilter so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentFilter, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentFilter] = {};

					ExperimentFilter[___, options: OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> protocolPacketWithResources[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> totalTimesEstimate
						}
					];

					(* pick the corresponding function from the association above *)
					experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

					(* Run the experiment *)
					experimentFunction[
						{primitive},
						Join[
							{
								Name -> Lookup[nonHiddenOptions, Name],
								Upload -> Lookup[safeOps, Upload],
								Confirm -> Lookup[safeOps, Confirm],
								CanaryBranch -> Lookup[safeOps, CanaryBranch],
								ParentProtocol -> Lookup[safeOps, ParentProtocol],
								Priority -> Lookup[safeOps, Priority],
								StartDate -> Lookup[safeOps, StartDate],
								HoldOrder -> Lookup[safeOps, HoldOrder],
								QueuePosition -> Lookup[safeOps, QueuePosition],
								Cache -> cacheBall
							},
							postProcessingOptions
						]
					]
				]
			],

		(* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualSamplePreparation, generate an *)
		(* Object[Protocol, ManualSamplePreparation]. *)
		And[
			!MatchQ[Lookup[safeOps, ParentProtocol], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]],
			MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], Null|{}],
			MatchQ[Lookup[resolvedOptions, Incubate], {False..}],
			MatchQ[Lookup[resolvedOptions, Centrifuge], {False..}],
			(* NOTE: No Filter prep for Filter. *)
			MatchQ[Lookup[resolvedOptions, Aliquot], {False..}]
		],
			Module[{primitive, nonHiddenOptions, experimentFunction},
				(* Create our filter primitive to feed into RoboticSamplePreparation. *)
				primitive = Filter@@Join[
					{
						Sample -> mySamples
					},
					RemoveHiddenPrimitiveOptions[Filter, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentFilter, ReplaceAll[resolvedOptions, {{Null..} -> Null}]];

				(* Memoize the value of ExperimentFilter so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentFilter, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					DownValues[ExperimentFilter] = {};

					ExperimentFilter[___, options:OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> (Length[mySamples] * 25 Minute)
						}
					];

					(* Resolve the experiment function (MSP/MCP) to call using the shared helper function *)
					experimentFunction = resolveManualFrameworkFunction[mySamples, nonHiddenOptions, Cache -> cacheBall, Simulation -> simulation, Output -> Function];

					experimentFunction[
						{primitive},
						Join[
							{
								Name -> Lookup[nonHiddenOptions, Name],
								Upload -> Lookup[safeOps, Upload],
								Confirm -> Lookup[safeOps, Confirm],
								CanaryBranch -> Lookup[safeOps, CanaryBranch],
								ParentProtocol -> Lookup[safeOps, ParentProtocol],
								Priority -> Lookup[safeOps, Priority],
								StartDate -> Lookup[safeOps, StartDate],
								HoldOrder -> Lookup[safeOps, HoldOrder],
								QueuePosition -> Lookup[safeOps, QueuePosition],
								Cache -> cacheBall
							},
							postProcessingOptions
						]
					]
				]
			],

		(* Actually upload our protocol object. We are being called as a subprotocol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				(* protocol packet *)
				protocolPacketWithResources[[1]],
				(* unit operation packets *)
				protocolPacketWithResources[[2]],
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> {Object[Protocol, Filter]},
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> If[MatchQ[resolvedPreparation, Robotic],
			collapsedResolvedOptions,
			RemoveHiddenOptions[ExperimentFilter, collapsedResolvedOptions]
		],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> totalTimesEstimate
	}

];


(* ::Subsection:: *)
(*resolveExperimentFilterOptions *)


DefineOptions[
	resolveExperimentFilterOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentFilterOptions[myInputSamples:{ObjectP[Object[Sample]]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentFilterOptions]] := Module[
	{
		outputSpecification, output, gatherTests, cache, simulation, samplePrepOptions, filterOptionsWithoutMultipleMultiples,
		multipleMultipleExpandedOptions, multipleMultipleOptionLengths, lengthToExpandTo, expandedMultipleMultipleOptions,
		multipleMultipleInvalidOptionsWithNulls, multipleMultipleInvalidOptions, multipleMultipleInvalidTest, simulatedSamples,
		resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, filterOptions, specifiedFiltrationType,
		specifiedFilter, specifiedMembraneMaterial, specifiedPrefilterMembraneMaterial, specifiedPoreSize,
		specifiedMolecularWeightCutoff, specifiedPrefilterPoreSize, specifiedSterile, specifiedInstrument,
		specifiedFilterHousing, specifiedSyringe, specifiedFiltrateContainerOut, specifiedRetentateContainerOut,
		specifiedSampleOut, specifiedIntensity, specifiedTime, specifiedFilterUntilDrained, specifiedMaxTime,
		specifiedTemperature, specifiedParentProtocol, samplePackets, sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls, centrifugeInstrumentPackets, centrifugeRotorPackets,
		centrifugeBucketPackets, centrifugeAdapterPackets, cacheBall, sampleDownloads, fastAssoc,
		sampleContainerModelPackets, sampleContainerPackets, allFootprints, allFootprintCentrifugeEquipment,
		footprintCentrifugeEquipmentLookup, messages, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		missingVolumeSamplePackets, missingVolumeInvalidInputs, missingVolumeTest, sampleVolumes, nonLiquidSamplePackets,
		nonLiquidSampleInvalidInputs, nonLiquidSampleTest, typeInstrumentInvalidOptions, allBuchnerFunnels,
		widestBuchnerFunnelDiameteter, typeInstrumentTest, typeAndSyringeInvalidOptions, typeAndSyringeTest, centrifugePackets,
		allProvidedFilters, possibleAutomaticFilters, allCentrifugeDevicesFilters, expandedCentrifugeDevicesTime,
		expandedCentrifugeDevicesTemperatures, expandedCentrifugeDevicesIntensities, centrifugeTuples, uniqueCentrifugeTuples,
		centrifugeReturnPosition, centrifugeDevicesReturn, centrifugeDevicesReplaceRule, centrifugeDevicesNonUnique,
		centrifugesAndContainersByOptionSet, mapThreadFriendlyOptions, instrumentMismatchTypes, instrumentMismatchInstruments,
		instrumentMismatchSamples, resolvedFiltrationType, resolvedInstrument, resolvedSyringe, resolvedPoreSize,
		resolvedMolecularWeightCutoff, resolvedPrefilterPoreSize, resolvedMembraneMaterial, resolvedPrefilterMembraneMaterial,
		resolvedFilter, resolvedFilterHousing, semiResolvedTaggedFiltrateContainerOut, resolvedSampleOut, semiResolvedFiltrateDestinationWell,
		resolvedSamplesOutStorageCondition, resolvedIntensity, resolvedTime, resolvedTemperature, resolvedSterile,
		resolvedCollectionContainer, filterTypeMismatchErrors, filterMembraneMaterialMismatchErrors,filterPoreSizeMismatchErrors,
		noFilterAvailableErrors, filterMaxVolumeMismatchErrors, filterInletConnectionTypeMismatchErrors, badCentrifugeErrors,
		noUsableCentrifugeErrors, typeAndInstrumentMismatchErrors, syringeMismatchTypes, syringeMismatchSyringes,
		syringeMismatchSamples, invalidOptions, nameInvalidOption, confirm, canaryBranch, fastTrack, unresolvedOperator, parentProtocol,
		upload, unresolvedEmail, unresolvedName, resolvedEmail, nameInvalidBool, nameInvalidTest, template, allTests,
		resolvedOperator, resolvedPostProcessingOptions, invalidInputs, resolvedOptions, typeAndSyringeMismatchErrors,
		filterTypeMismatchInvalidOptions, filterTypeMismatchInvalidTests, filterMaterialMismatchInvalidOptions,
		filterMaterialMismatchInvalidTests, filterOptionMismatchFunction, filterPoreSizeMismatchInvalidOptions,
		filterPoreSizeMismatchInvalidTests, filterMaxVolumeMismatchInvalidOptions, filterMaxVolumeMismatchInvalidTests,
		filterInletConnectionTypeMismatchInvalidOptions, filterInletConnectionTypeMismatchInvalidTests, allComptibleMaterialsBools,
		allCompatibleMaterialsTests, badCentrifugeErrorsOptions, badCentrifugeErrorTests, noUsableCentrifugeErrorsOptions, resolvedFiltrateDestinationWell,
		noUsableCentrifugeErrorsTests, noFilterAvailableInvalidOptions, noFilterAvailableInvalidTest, moreSemiResolvedFiltrateDestinationWell,
		resolvedAliquotOptions, aliquotTests, groupedFiltrateContainersOut, resolvedFiltrateContainerOutGroupedByIndex,
		numFiltrateContainersPerIndex, invalidFiltrateContainerOutSpecs, filtrateContainerOutMismatchedIndexOptions,
		filtrateContainerOutMismatchedIndexTest, filtrateContainerToWellRules, overOccupiedFiltrateContainerOutTrio,
		filtrateContainerOverOccupiedOptions, filtrateContainerOverOccupiedTest, invalidFiltrateDestWellPositionOptions,
		invalidFiltrateDestWellPositionTest, filtrateContainerOutModelPackets, filtrateContainerOutAllowedPositions,
		invalidFiltrateDestWellPositionQ, collectRetentateErrors, resolvedCollectRetentate, resolvedWashRetentate,
		resolvedRetentateWashMix, resolvedRetentateCollectionMethod, resolvedResuspensionVolume, resolvedRetentateCollectionContainer,
		resolvedResuspensionBuffer, resolvedResuspensionNumberOfMixes, resolvedFlowRate, flowRateNullErrors,
		semiResolvedRetentateContainerOut, semiResolvedRetentateDestinationWell, retentateCollectionMethodErrors,
		transferCollectionMethodErrors, transferCollectionMethodInvalidOptions, transferCollectionMethodInvalidTest,
		collectRetentateInvalidOptions, retentateCollectionMethodInvalidOptions, collectRetentateInvalidTest,
		retentateCollectionMethodInvalidTest, resolvedRetentateContainersOut, resolvedRetentateDestinationWell,
		resolvedRetentateContainerOutGroupedByIndex, numRetentateContainersPerIndex, invalidRetentateContainerOutSpecs,
		retentateContainerOutMismatchedIndexOptions, retentateContainerOutMismatchedIndexTest, retentateContainerToWellRules,
		overOccupiedRetentateContainerOutTrio, retentateContainerOverOccupiedOptions, retentateContainerOverOccupiedTest,
		retentateContainerOutModelPackets, retentateContainerOutAllowedPositions, invalidRetentateDestWellPositionQ,
		invalidRetentateDestWellPositionOptions, invalidRetentateDestWellPositionTest, resolvedFilterUntilDrained,
		resolvedMaxTime, poreSizeAndMWCOMismatchErrors, prefilterOptionMismatchErrors, poreSizeandMWCOInvalidOptions,
		poreSizeandMWCOInvalidTest, prefilterOptionMismatchInvalidOptions, prefilterOptionMismatchTests,
		filterMolecularWeightMismatchErrors, filterMWCOMismatchInvalidOptions, filterMWCOMismatchInvalidTests,
		incompatibleFilterTimeWithTypeErrors, incompatibleFilterTimeOptionsErrors, incompatibleFilterTimeWithTypeOptions,
		incompatibleFilterTimeOptions, incompatibleFilterTimeWithTypeTests, incompatibleFilterTimeTests,
		resolvedRetentateWashBuffer, resolvedRetentateWashVolume, resolvedNumberOfRetentateWashes,
		retentateContainerOutPlateInvalidOptions, retentateContainerOutPlateInvalidTest,
		resolvedRetentateWashDrainTime, resolvedRetentateWashCentrifugeIntensity, resolvedNumberOfRetentateWashMixes,
		optionsForAliquot, typeAndFilterHousingMismatchErrors, centrifugeCollectionMethodErrors, centrifugeContainerDestErrors,
		filterHousingMismatchTypes, filterHousingMismatchSyringes, filterHousingMismatchSamples, totalCollectionVolumes,
		filterHousingMismatchOptions, filterHousingMismatchTest, sterileInstrumentMismatchTypes, retentateContainerOutPlateErrors,
		intensityTooHighErrors, typePressureMismatchErrors, pressureTooHighErrors, transferringToNewFilterQs,
		sterileInstrumentMismatchSterile, sterileInstrumentMismatchSamples, sterileInstrumentMismatchOptions,
		sterileInstrumentMismatchTest, sterileInstrumentMismatchErrors, typeAndCentrifugeIntensityMismatchErrors,
		typeCentrifugeIntensityMismatchTypes, typeCentrifugeIntensityMismatchIntensities,
		typeCentrifugeIntensityMismatchSamples, typeCentrifugeMismatchOptions, typeCentrifugeMismatchTest,
		sterileContainerOutMismatchErrors, sterileFiltrateContainerOutErrorSamples, sterileFiltrateContainerOutErrorContainers,
		sterileContainerOutMismatchTest, filtrateContainerOutMaxVolumeErrors, filtrateContainerOutMaxVolumes,
		filtrateContainerOutMaxVolumeOptions, filtrateContainerOutMaxVolumeTest, syringeMaxVolumeErrors,
		syringeMaxVolumes, syringeMaxVolumeOptions, syringeMaxVolumeTest, syringeConnectionTypes, resolvedPressure,
		resolvedRetentateWashPressure,resolvedVolumes, resolvedPrewetFilter, resolvedPrewetFilterTime,
		resolvedPrewetFilterBufferVolume, resolvedPrewetFilterCentrifugeIntensity, resolvedPrewetFilterBuffer,
		resolvedPrewetFilterBufferLabel, resolvedPrewetFilterContainerOut, resolvedPrewetFilterContainerLabel,
		incorrectSyringeConnectionErrors, incorrectSyringeConnectionOptions, incorrectSyringeConnectionTest,
		intensityTooHighErrorOptions, intensityTooHighErrorTests, typePressureMismatchErrorOptions,
		typePressureMismatchErrorTests, filterModelPackets, pressureTooHighErrorOptions, pressureTooHighErrorTests,
		temperatureInvalidErrors, typeTemperatureMismatchTypes, typeTemperatureMismatchIntensities,
		typeTemperatureMismatchSamples, temperatureInvalidOptions, temperatureInvalidTest,
		retentateWashCentrifugeIntensityTypeErrors, washRetentateTypeErrors, retentateWashMixErrors,
		washRetentateConflictErrors, resuspensionVolumeTooHighErrors, retentateWashCentrifugeIntensityTypeOptions,
		retentateWashCentrifugeIntensityTypeTest, washRetentateTypeOptions, washRetentateTypeTest,
		retentateWashMixInvalidOptions, retentateWashMixInvalidTest, retentateWashInvalidOptions,
		retentateWashInvalidTest, resuspensionVolumeTooHighOptions, resuspensionVolumeTooHighTest,
		resolvedSampleLabel, resolvedSampleContainerLabel, resolvedFiltrateLabel, resolvedFiltrateContainerLabel,
		filtrateContainerLabelLookup, resolvedRetentateLabel, resolvedRetentateContainerLabel, resolvedSampleOutLabel,
		resolvedContainerOutLabel, specifiedFiltrateContainerOutIntegers, specifiedRetentateContainerOutIntegers,
		availableFiltrateContainerOutIntegers, availableRetentateContainerOutIntegers, filtrateContainerLabelReplaceRules,
		retentateContainerLabelReplaceRules, preparationResult, allowedPreparation, preparationTest,resolvedPreparation,
		semiResolvedFiltrateContainerLabel, semiResolvedRetentateContainerLabel, semiResolvedContainerOutLabel,
		containerLabelMismatchErrors, sampleLabelMismatchErrors, containerLabelMismatchOptions,filterLabelLookup,
		sampleLabelMismatchOptions, containerLabelMismatchTest, sampleLabelMismatchTest, collectionContainerModelPackets,
		groupedFilterParameters, runningTallyOfFilterParameters, allNumberOfWells, filterLabelNumber, resolvedFilterLabel,
		uniqueCollectionContainerToLabelRule, resolvedCollectionContainerLabel, groupedSamplesAndOptions, overOccupiedNumWells,
		overOccupiedFilters, overOccupiedErrorOptions, overOccupiedErrorTests, newMassesPerFilter, resolvedCounterweight,
		noCounterweightsErrors, noCounterweightCollectionContainers, noCounterweightOptions, noCounterweightTest,
		sameFilterConflictingOptions, sameFilterConflictingFilters, sameFilterConflictingSamples, filtrateContainerLabelToIndexReplaceRules,
		sameFilterConflictingErrorOptions, sameFilterConflictingErrorTests, collectionContainerPlateMismatchErrorSamples,
		collectionContainerPlateMismatchErrorOptions, collectionContainerPlateMismatchErrorTests,
		pipettingOptionNames, pipettingOptionsToPass, mapThreadFriendlyPreResolvedPipettingParameterOptions, samplesToTransfer,
		samplesToNotTransfer, filtersToTransfer, filtersToNotTransfer, volumesToTransfer, volumesToNotTransfer, optionsToTransfer,
		optionsToNotTransfer, samplesToTransferSterile, samplesToNotTransferSterile, filterLabelsToTransfer,
		resolvedOptionsToNotTransfer, optionsWithInvalidTransferOptions, invalidPipettingParameterOptions,
		invalidPipettingParameterTests, nestedSamplesToTransfer, nestedFiltersToTransfer, nestedVolumesToTransfer,
		nestedMapThreadOptionsToTransfer, destWellsToTransferTo, preResolvedPipettingParameterOptions,
		preResolvedPipettingParameterSafeOptions, allResolvedTransferOptions, transferTests, resolvedFilterPosition,
		mapThreadFriendlyPartialResolvedTransferOptions, mapThreadFriendlyPartialResolvedTransferOptionsCorrectAmount,
		combinedMapThreadFriendlyOptions, resolvedPipettingParameters, preResolvedFilterPosition,
		filterPositionDoesNotExistErrors, filterPositionDoesNotExistOptions, filterPositionDoesNotExistTest,
		filterPositionInvalidErrors, filterPositionInvalidOptions, filterPositionInvalidTest,
		filterLabelsToIntegerOrAutomaticRules, existingIntegers, nextInteger, filterLabelsToIntegerRules,
		moreSemiResolvedFiltrateContainerOut, retentateContainerLabelToIndexReplaceRules, mergedFiltrateContainerLabelToIndexReplaceRules,
		mergedRetentateContainerLabelToIndexReplaceRules, filtrateContainerLabelToIndexMismatchQ,
		retentateContainerLabelToIndexMismatchQ, filtrateContainerLabelIndexMismatchOptions,
		filtrateContainerLabelIndexMismatchTest, retentateContainerLabelIndexMismatchOptions,
		retentateContainerLabelIndexMismatchTest, flowRateMismatchTypes, flowRateMismatchFlowRates,
		flowRateMismatchSamples, flowRateMismatchOptions, flowRateMismatchTest, semiResolvedPrewetFilterContainerLabel,
		retentateCollectionContainerInvalidOptions, retentateCollectionContainerInvalidTest,
		centrifugeContainerDestInvalidOptions, centrifugeContainerDestInvalidTest, resolvedWorkCell,
		resolvedResuspensionBufferLabel, resolvedResuspensionBufferContainerLabel, resolvedRetentateWashBufferLabel,
		resolvedRetentateWashBufferContainerLabel, prewetFilterMismatchErrors, prewetFilterCentrifugeIntensityTypeErrors,
		prewetFilterMismatchOptions, prewetFilterMismatchTests, prewetFilterCentrifugeIntensityTypeOptions,
		prewetFilterCentrifugeIntensityTypeTest, allContainerPackets, allFilterPackets,
		resolvedWashFlowThroughStorageCondition, resolvedWashFlowThroughContainer, semiResolvedWashFlowThroughDestinationWell,
		resolvedWashFlowThroughLabel, semiResolvedWashFlowThroughContainerLabel, washFlowThroughSameAsFiltrateQs,
		inheritedSemiResolvedWashFlowThroughDestinationWell, fakeTaggedWashFlowThroughContainers,
		groupedWashFlowThroughContainers, flatResolvedWashFlowThroughDestinationWell, resolvedWashFlowThroughDestinationWell,
		washFlowThroughContainerLabelLookup, resolvedWashFlowThroughContainerLabel, groupedWashFlowThroughContainersCorrectLength,
		collectionContainerPlateMismatchErrors, resolvedFilterStorageCondition, retentateWashTips, resuspensionTips,
		allCounterweightPackets, resolvedCollectOccludingRetentate, filtrateContainerOutTips, groupedBuffersAndVolumes,
		buffersAndContainers, retentateWashBufferContainers, resuspensionBufferContainers, resolvedOccludingRetentateContainer,
		preResolvedOccludingRetentateDestWell, resolvedOccludingRetentateDestWell, resolvedOccludingRetentateContainerLabel,
		occludingRetentateMismatchErrors, occludingRetentateNotSupportedErrors, occludingRetentateMismatchOptions,
		occludingRetentateMismatchTest, occludingRetentateNotSupportedOptions, occludingRetentateNotSupportedTest,
		resolvedOccludingRetentateContainerWithIndices, unresolvedOccludingRetentateContainerLabel,
		resuspensionBufferLabelGrouping, retentateWashingBufferLabelGrouping, prewetFilterBufferLabelGrouping,
		finalResolvedResuspensionBufferLabel, finalResolvedResuspensionBufferContainerLabel, finalResolvedRetentateWashBufferLabel,
		finalResolvedRetentateWashBufferContainerLabel, finalResolvedPrewetFilterBufferLabel, roboticQ, allowedWorkCells, workCellsBySampleProperties,
		filterAirPressureDimensionsErrors, filterAirPressureDimensionsErrorsOptions, filterAirPressureDimensionsErrorTests,
		resolvedNumberOfFilterPrewettings, numberOfFilterPrewettingsTooHighErrors, prewettingTypeMismatchErrors,
		numberOfFilterPrewettingsTooHighOptions, numberOfFilterPrewettingsTooHighTest, prewettingTypeMismatchOptions,
		prewettingTypeMismatchTest, destWellPositionConflict, destWellPositionErrorOptions, destWellPositionErrorTest,
		collectionContainerMaxVolumeErrors, collectionContainerMaxVolumeOptions, collectionContainerMaxVolumeTest, collectionContainerMaxVolumes,
		equivalentFilterLookup, parentProtocolSite
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

	(* Get all the centrifuge packets from the cache *)
	centrifugePackets = Select[cache, MatchQ[Lookup[#, Type], Model[Container, CentrifugeRotor] | Model[Container, CentrifugeBucket] | Model[Part, CentrifugeAdapter]]&];

	(* Get all counterweight packets out *)
	allCounterweightPackets = Select[cache, MatchQ[Lookup[#,Type],Model[Item,Counterweight]]&];

	(* Separate out our FilterNew options from our Sample Prep options. *)
	{samplePrepOptions, filterOptionsWithoutMultipleMultiples} = splitPrepOptions[myOptions, PrepOptionSets -> {CentrifugePrepOptionsNew, IncubatePrepOptionsNew, AliquotOptions}];

	(* Expand index-matching options *)
	(* Get the multiple multiple options *)
	multipleMultipleExpandedOptions = {
		RetentateWashBuffer,
		RetentateWashVolume,
		NumberOfRetentateWashes,
		RetentateWashDrainTime,
		RetentateWashCentrifugeIntensity,
		RetentateWashMix,
		NumberOfRetentateWashMixes,
		RetentateWashPressure,
		RetentateWashBufferLabel,
		RetentateWashBufferContainerLabel,
		WashFlowThroughLabel,
		WashFlowThroughContainerLabel,
		WashFlowThroughContainer,
		WashFlowThroughDestinationWell,
		WashFlowThroughStorageCondition
	};

	(* Get the length of the multiple multiple options for each entry *)
	(* 0 means the options aren't nested yet *)
	multipleMultipleOptionLengths = Map[
		Function[{option},
			Which[
				(* If option value is not nested and not index-matched to samples, then whole value should be used for each *)
				(* sample. Ex. for {"sample1", "sample2"}, the option is {"value1"}, then should be {{"value1"},{"value1"}} *)
				(* when fully expanded, so is {1, 1} here. *)
				And[
					ListQ[Lookup[myOptions, option]],
					!MemberQ[ListQ/@Lookup[myOptions, option], True],
					!MatchQ[Length[Lookup[myOptions,option]], Length[myInputSamples]]
				],
					ConstantArray[Length[Lookup[myOptions,option]], Length[myInputSamples]],
				(* If option value is a singleton, then needs to be expanded to each sample and is length 0. *)
				(* Ex. for {"sample1", "sample2"}, the option is "value1", then should be {{"value1"},{"value1"}} *)
				(* when fully expanded, so is {0, 0} here. *)
				Not[ListQ[Lookup[myOptions, option]]],
					ConstantArray[0, Length[myInputSamples]],
				(* Otherwise, just check the length of each index-matched value. Ex. {{"value1}, {"value2", "value3"}} will *)
				(* be {1, 2} *)
				True,
					If[Not[ListQ[#]], 0, Length[#]]& /@ Lookup[myOptions, option]
			]
		],
		multipleMultipleExpandedOptions
	];

	(* Get the length to expand to *)
	lengthToExpandTo = Map[
		If[Max[#] == 0,
			(* If _none_ of the options are specified as multiple multiple, just assume length 1; we can change this later if we want *)
			1,
			Max[#]
		]&,
		Transpose[multipleMultipleOptionLengths]
	];

	(* Expand the options *)
	(* also toss in the option names that are the wrong length (so that we can throw a sensible error message) *)
	{expandedMultipleMultipleOptions, multipleMultipleInvalidOptionsWithNulls} = Transpose[MapThread[
		Function[{optionName, optionValue},
			Module[{expandedQ, semiExpandedOptionValue, expandedOptionValue, invalidOption},

				(* Check if the option has been expanded already *)
				(* For example: *)
				(* Expanded: {sample 1, sample 2} and {buffer 1, {buffer 1, buffer 2}} *)
				(* not expanded: {sample 1, sample 2} and {buffer 1, buffer 2} *)
				expandedQ = MatchQ[Length[myInputSamples], Length[optionValue]] && MemberQ[optionValue, _List];

				(* If a true singleton or single value (not singleton, but not index-matching nor nested), *)
				(* expand this to be index matching with samples. *)
				semiExpandedOptionValue = If[
					Or[
						Not[ListQ[optionValue]],
						And[
							ListQ[optionValue],
							!MemberQ[ListQ/@optionValue, True],
							!MatchQ[Length[optionValue], Length[myInputSamples]]
						]
					],
					ConstantArray[optionValue, Length[myInputSamples]],
					optionValue
				];

				(* Expand the option if it's not expanded already *)
				expandedOptionValue = optionName -> MapThread[
					Which[ListQ[#1],
						#1,
						expandedQ,
						ToList[#1],
						True, ConstantArray[#1, #2]
					]&,
					{semiExpandedOptionValue, lengthToExpandTo}
				];

				(* If option is not invalid then just say Null; otherwise say the option in question *)
				invalidOption = If[(Length /@ Last[expandedOptionValue]) == lengthToExpandTo,
					Null,
					optionName
				];

				{expandedOptionValue, invalidOption}
			]
		],
		{multipleMultipleExpandedOptions, Lookup[myOptions, multipleMultipleExpandedOptions]}
	]];

	(* Delete the nulls from the error options *)
	multipleMultipleInvalidOptions = DeleteCases[multipleMultipleInvalidOptionsWithNulls, Null];

	(* Make sure all the multiple multiple options are index matched to each other *)
	multipleMultipleInvalidTest = If[gatherTests,
		Test["All RetentateWash options are properly index matched to both the input samples and each other:",
			MatchQ[multipleMultipleInvalidOptions, {}],
			True
		]
	];

	(* Throw messages of there if the multiple multiple options are not index matching *)
	If[Not[MatchQ[multipleMultipleInvalidOptions, {}]],
		If[Not[gatherTests],
			(
				Message[Error::NestedIndexMatchingRequired, multipleMultipleInvalidOptions, lengthToExpandTo];
				Message[Error::InvalidOption, multipleMultipleInvalidOptions];
			)
		]
	];

	(* Combine the expanded options all together *)
	filterOptions = ReplaceRule[filterOptionsWithoutMultipleMultiples, expandedMultipleMultipleOptions];

	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentFilter, myInputSamples, samplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentFilter, myInputSamples, samplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Pull out the relevant options *)
	{
		specifiedFiltrationType,
		specifiedFilter,
		specifiedMembraneMaterial,
		specifiedPrefilterMembraneMaterial,
		specifiedPoreSize,
		specifiedMolecularWeightCutoff,
		specifiedPrefilterPoreSize,
		specifiedSterile,
		specifiedInstrument,
		specifiedFilterHousing,
		specifiedSyringe,
		specifiedFiltrateContainerOut,
		specifiedRetentateContainerOut,
		specifiedSampleOut,
		specifiedIntensity,
		specifiedTime,
		specifiedFilterUntilDrained,
		specifiedMaxTime,
		specifiedTemperature,
		specifiedParentProtocol
	} = Lookup[
		filterOptions,
		{
			FiltrationType,
			Filter,
			MembraneMaterial,
			PrefilterMembraneMaterial,
			PoreSize,
			MolecularWeightCutoff,
			PrefilterPoreSize,
			Sterile,
			Instrument,
			FilterHousing,
			Syringe,
			FiltrateContainerOut,
			RetentateContainerOut,
			SampleOut,
			Intensity,
			Time,
			FilterUntilDrained,
			MaxTime,
			Temperature,
			ParentProtocol
		}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads = Quiet[Download[
		simulatedSamples,
		{
			Packet[Name, Volume, State, Status, Container, LiquidHandlerIncompatible, Solvent, Position],
			Packet[Container[{Object, Model, KitComponents}]],
			Packet[Container[Model[{MaxVolume, DestinationContainerModel, RetentateCollectionContainerModel, Graduations, GraduationTypes, GraduationLabels, CrossSectionalShape}]]]
		},
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* Combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* Generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Pull some stuff out of the cache ball to speed things up below; unfortunately can't eliminate this 100%  *)
	allContainerPackets = Cases[cacheBall, PacketP[{Model[Container], Object[Container]}]];
	allFilterPackets = Cases[cacheBall, PacketP[{Model[Item, Filter], Object[Item, Filter], Model[Item, ExtractionCartridge], Object[Item, ExtractionCartridge], Model[Container, Vessel, Filter], Object[Container, Vessel, Filter], Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	} = Transpose[sampleDownloads];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
			Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls, {Null -> {}}, 1];
	sampleContainerPackets = Replace[sampleContainerPacketsWithNulls, {Null -> {}}, 1];

	(* Pull out footprints for input containers *)
	(* inputContainerFootprints = Lookup[sampleContainerModelPackets, Footprint, Null]; *)
	allFootprints = List @@ CentrifugeableFootprintP;

	(* Get centrifuge equipment ensembles (i.e., instrument/rotor(/bucket) combos for all possible footprints (must account for the possibility of container change) *)
	(* Note: We don't have any collection containers resolved at this point, so we pass this input as Null down to the footprint function. *)
	allFootprintCentrifugeEquipment = centrifugesForFootprint[
		allFootprints,
		ConstantArray[Null, Length[allFootprints]],
		ConstantArray[Null, Length[allFootprints]],
		Flatten[{centrifugeInstrumentPackets, centrifugeRotorPackets, centrifugeBucketPackets, centrifugeAdapterPackets}]
	];

	(* Generate a lookup table from footprint to centrifuge equipment *)
	footprintCentrifugeEquipmentLookup = AssociationThread[allFootprints, allFootprintCentrifugeEquipment];

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

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
	(* Get the samples that do not have a volume but are a liquid *)
	missingVolumeSamplePackets = Select[Flatten[samplePackets], NullQ[Lookup[#, Volume]]&];

	(* Keep track of samples that do not have volume but are a liquid *)
	missingVolumeInvalidInputs = Lookup[missingVolumeSamplePackets, Object, {}];

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


	(* Make sure we have a volume to work with (either volume of the sample or if that is not possible than the max volume
	 of container the sample is in,this is here just for the map threader portion of the resolver,currently we cannot proceed without a volume *)
	sampleVolumes = MapThread[
		If[NullQ[#1], #2, #1]&,
		{
			Lookup[samplePackets, Volume],
			Lookup[sampleContainerModelPackets, MaxVolume]
		}
	];

	(* NOTE: MAKE SURE THE SAMPLES ARE LIQUID - *)

	(* Get the samples that are not liquids,cannot filter those *)
	nonLiquidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Liquid | Null]]&];

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs = Lookup[nonLiquidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs] > 0 && messages,
		Message[Error::NonLiquidSample, ObjectToString[nonLiquidSampleInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonLiquidSampleInvalidInputs, Cache -> cacheBall] <> " have a Liquid State:", True, False]
			];

			passingTest = If[Length[nonLiquidSampleInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, nonLiquidSampleInvalidInputs], Cache -> cacheBall] <> " have a Liquid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* -- CONFLICTING OPTIONS CHECKS -- *)


	(* Call CentrifugeDevices before MapThread to speed up things *)
	(* Step 1 - Get the provided Filter option - This is index matching to input samples *)
	allProvidedFilters = Lookup[filterOptions, Filter];

	(* Step 2 - If we were given a Filter object, go with it when calling CentrifugeDevices. Otherwise we may resolve to any of the possible Filters in the main MapThread *)
	possibleAutomaticFilters = Lookup[
		Select[
			allFilterPackets,
			And[
				Not[MatchQ[#, Null|$Failed]],
				MatchQ[Lookup[#, {Type, FilterType}], {Model[Container, Vessel, Filter], Centrifuge} | {Model[Container, Plate, Filter], _}]
			]&
		],
		Object,
		{}
	];
	allCentrifugeDevicesFilters = Map[
		If[MatchQ[#, Automatic | ObjectP[{Model[Item, Filter], Object[Item, Filter], Model[Item, ExtractionCartridge], Object[Item, ExtractionCartridge]}]],
			possibleAutomaticFilters,
			{Download[#, Object]}
		]&,
		allProvidedFilters
	];

	(* Step 3 - Expand the options for CentrifugeDevices *)
	expandedCentrifugeDevicesTime = MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[filterOptions, Time], allCentrifugeDevicesFilters}
	];
	expandedCentrifugeDevicesTemperatures = MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[filterOptions, Temperature], allCentrifugeDevicesFilters}
	];
	expandedCentrifugeDevicesIntensities = MapThread[
		ConstantArray[#1, Length[#2]]&,
		{Lookup[filterOptions, Intensity], allCentrifugeDevicesFilters}
	];

	(* Combine the input and conditions into one list so that CentrifugeDevices is faster *)
	centrifugeTuples = Transpose[{
		Flatten[allCentrifugeDevicesFilters],
		Flatten[expandedCentrifugeDevicesTime],
		Flatten[expandedCentrifugeDevicesTemperatures],
		Flatten[expandedCentrifugeDevicesIntensities]
	}];

	(* Get the unique Tuple for CentrifugeDevices *)
	uniqueCentrifugeTuples = DeleteDuplicates[centrifugeTuples];

	(* Get the position of each Tuple in the unique Tuple list so we can get a Replace rule *)
	centrifugeReturnPosition = Flatten[FirstPosition[uniqueCentrifugeTuples, #]& /@ centrifugeTuples];

	(* Call Centrifuge Devices *)
	centrifugeDevicesReturn = CentrifugeDevices[
		Flatten[uniqueCentrifugeTuples[[All, 1]]],
		Time -> Flatten[uniqueCentrifugeTuples[[All, 2]]] /. {Null -> Automatic},
		Temperature -> Flatten[uniqueCentrifugeTuples[[All, 3]]] /. {RangeP[24.999 Celsius, 25.001 Celsius] -> Ambient, Null -> Automatic},
		Intensity -> Flatten[uniqueCentrifugeTuples[[All, 4]]] /. {Null -> Automatic},
		Cache -> Flatten[{cacheBall, centrifugePackets}],
		Simulation -> updatedSimulation
	];

	(* Get the replacement rule *)
	centrifugeDevicesReplaceRule = MapThread[
		(#1 -> #2)&,
		{Range[Length[uniqueCentrifugeTuples]], centrifugeDevicesReturn}
	];
	centrifugeDevicesNonUnique = ReplaceAll[centrifugeReturnPosition, centrifugeDevicesReplaceRule];

	(* Get the centrifuges and containers in the proper shape in preparation for our big MapThread *)
	centrifugesAndContainersByOptionSet = TakeList[centrifugeDevicesNonUnique, Length /@ allCentrifugeDevicesFilters];

	(* Pull out the buchner funnel packets we Downloaded previously *)
	allBuchnerFunnels = Cases[cacheBall, PacketP[Model[Part, Funnel]]];

	(* Get the widest buchner funnel diameter *)
	widestBuchnerFunnelDiameteter = Max[Lookup[allBuchnerFunnels, MouthDiameter, Null]];

	(* --- Do some weird stuff corresponding the label options with the indices in the FiltrateContainerOut and RetentateContainerOut options --- *)


	(* Get all the unique integers that were specified in the FiltrateContainerOut and RetentateContainerOut option *)
	specifiedFiltrateContainerOutIntegers = DeleteDuplicates[Cases[Flatten[Lookup[filterOptions, FiltrateContainerOut]], _Integer]];
	specifiedRetentateContainerOutIntegers = DeleteDuplicates[Cases[Flatten[Lookup[filterOptions, RetentateContainerOut]], _Integer]];

	(* Get integers available to resolve to that haven't already been specified *)
	(* Note that this is going to be index matching to the length of myInputSamples; it's admittedly a little bit weird that I'm doing it this way but I didn't know an easier way to make a list of unique integers of the same length as myInputSamples that excludes all the ones that already existed *)
	availableFiltrateContainerOutIntegers = Take[
		DeleteCases[
			Range[Length[myInputSamples] + Length[specifiedFiltrateContainerOutIntegers]],
			Alternatives @@ specifiedFiltrateContainerOutIntegers
		],
		Length[myInputSamples]
	];
	availableRetentateContainerOutIntegers = Take[
		DeleteCases[
			Range[Length[myInputSamples] + Length[specifiedRetentateContainerOutIntegers]],
			Alternatives @@ specifiedRetentateContainerOutIntegers
		],
		Length[myInputSamples]
	];

	(* Make replace rules correlating any specified labels with unique integers *)
	filtrateContainerLabelReplaceRules = Association[MapThread[
		Function[{filtrateContainerOut, filtrateContainerLabel, potentialIndex},
			Which[
				MatchQ[filtrateContainerOut, {_Integer, _}] && StringQ[filtrateContainerLabel], filtrateContainerLabel -> First[filtrateContainerOut],
				StringQ[filtrateContainerLabel], filtrateContainerLabel -> potentialIndex,
				True, Nothing
			]
		],
		{Lookup[filterOptions, FiltrateContainerOut], Lookup[filterOptions, FiltrateContainerLabel], availableFiltrateContainerOutIntegers}
	]];
	retentateContainerLabelReplaceRules = Association[MapThread[
		Function[{retentateContainerOut, retentateContainerLabel, potentialIndex},
			Which[
				MatchQ[retentateContainerOut, {_Integer, _}] && StringQ[retentateContainerLabel], retentateContainerLabel -> First[retentateContainerOut],
				StringQ[retentateContainerLabel], retentateContainerLabel -> potentialIndex,
				True, Nothing
			]
		],
		{Lookup[filterOptions, RetentateContainerOut], Lookup[filterOptions, RetentateContainerLabel], availableRetentateContainerOutIntegers}
	]];

	(* Resolve our preparation option. *)
	preparationResult = Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveFilterMethod[myInputSamples, ReplaceRule[filterOptionsWithoutMultipleMultiples, {Cache->cacheBall, Simulation -> simulation, Output->Result}]],
				{}
			},
			resolveFilterMethod[myInputSamples, ReplaceRule[filterOptionsWithoutMultipleMultiples, {Cache->cacheBall, Simulation -> simulation, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation = If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];
	(* Build a short hand for robotic primitive *)
	roboticQ = MatchQ[resolvedPreparation, Robotic];

	(* Check which work cells are preferred for these samples. We use this to pre-resolve Sterile option (whether we are robotic or manual) and also to constrain the possible work cells later if we're Robotic. *)
	workCellsBySampleProperties = resolvePotentialWorkCells[simulatedSamples, ReplaceRule[filterOptionsWithoutMultipleMultiples, Preparation -> resolvedPreparation], Cache -> cacheBall, Simulation -> updatedSimulation];

	(* Get some non-index-matching options directly from SafeOptions. *)
	{
		confirm,
		canaryBranch,
		template,
		fastTrack,
		unresolvedOperator,
		parentProtocol,
		upload,
		unresolvedEmail,
		unresolvedName
	} = Lookup[myOptions, {Confirm, CanaryBranch, Template, FastTrack, Operator, ParentProtocol, Upload, Email, Name}];

	parentProtocolSite = If[MatchQ[$ECLApplication, Engine] && !NullQ[parentProtocol],
		Download[Lookup[fetchPacketFromFastAssoc[parentProtocol, fastAssoc], Site], Object],
		$Site
	];

	(* Define some equivalent filters *)
	equivalentFilterLookup = Switch[parentProtocolSite,
		Object[Container, Site, "id:kEJ9mqJxOl63"] (* ECL-2 *),
		{
			Model[Container, Vessel, Filter, "id:kEJ9mqJAD4NV"] -> Model[Item, Filter, "id:9RdZXv1ojx89"]
		},
		Object[Container, Site, "id:P5ZnEjZpRlK4"] (* ECL-CMU *),
		{
			Model[Item, Filter, "id:9RdZXv1ojx89"] -> Model[Container, Vessel, Filter, "id:kEJ9mqJAD4NV"]
		},
		_,
		{}
	];


	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFilter, filterOptions];

	(* Big MapThread to get all the options resolved *)
	{
		(*1*)resolvedFiltrationType,
		(*2*)resolvedInstrument,
		(*3*)resolvedSyringe,
		(*4*)resolvedFlowRate,
		(*5*)resolvedPoreSize,
		(*6*)resolvedMolecularWeightCutoff,
		(*7*)resolvedPrefilterPoreSize,
		(*8*)resolvedMembraneMaterial,
		(*9*)resolvedPrefilterMembraneMaterial,
		(*10*)resolvedFilter,
		(*11*)resolvedFilterHousing,
		(*12*)semiResolvedTaggedFiltrateContainerOut,
		(*13*)semiResolvedFiltrateDestinationWell,
		(*14*)resolvedSampleOut,
		(*15*)resolvedSamplesOutStorageCondition,
		(*16*)resolvedIntensity,
		(*17*)resolvedTime,
		(*18*)resolvedFilterUntilDrained,
		(*19*)resolvedMaxTime,
		(*20*)resolvedTemperature,
		(*21*)resolvedSterile,
		(*22*)resolvedCollectionContainer,
		(*23*)resolvedRetentateCollectionContainer,
		(*24*)resolvedCollectRetentate,
		(*25*)resolvedWashRetentate,
		(*26*)resolvedRetentateWashMix,
		(*27*)resolvedRetentateCollectionMethod,
		(*28*)resolvedResuspensionVolume,
		(*29*)resolvedResuspensionBuffer,
		(*30*)resolvedResuspensionNumberOfMixes,
		(*31*)semiResolvedRetentateContainerOut,
		(*32*)semiResolvedRetentateDestinationWell,
		(*33*)resolvedRetentateWashBuffer,
		(*34*)resolvedRetentateWashVolume,
		(*35*)resolvedNumberOfRetentateWashes,
		(*36*)resolvedRetentateWashDrainTime,
		(*37*)resolvedRetentateWashCentrifugeIntensity,
		(*38*)resolvedNumberOfRetentateWashMixes,
		(*39*)resolvedSampleLabel,
		(*40*)resolvedSampleContainerLabel,
		(*41*)resolvedFiltrateLabel,
		(*42*)semiResolvedFiltrateContainerLabel,
		(*43*)resolvedRetentateLabel,
		(*44*)semiResolvedRetentateContainerLabel,
		(*45*)resolvedSampleOutLabel,
		(*46*)semiResolvedContainerOutLabel,
		(*47*)resolvedResuspensionBufferLabel,
		(*48*)resolvedResuspensionBufferContainerLabel,
		(*49*)resolvedRetentateWashBufferLabel,
		(*50*)resolvedRetentateWashBufferContainerLabel,
		(*51*)filtrateContainerOutMaxVolumes,
		(*52*)syringeMaxVolumes,
		(*53*)syringeConnectionTypes,
		(*54*)resolvedPressure,
		(*55*)resolvedRetentateWashPressure,
		(*56*)filterTypeMismatchErrors,
		(*57*)filterMembraneMaterialMismatchErrors,
		(*58*)filterPoreSizeMismatchErrors,
		(*59*)noFilterAvailableErrors,
		(*60*)filterMaxVolumeMismatchErrors,
		(*61*)filterInletConnectionTypeMismatchErrors,
		(*62*)badCentrifugeErrors,
		(*63*)noUsableCentrifugeErrors,
		(*64*)typeAndInstrumentMismatchErrors,
		(*65*)typeAndSyringeMismatchErrors,
		(*66*)collectRetentateErrors,
		(*67*)retentateCollectionMethodErrors,
		(*68*)transferCollectionMethodErrors,
		(*69*)poreSizeAndMWCOMismatchErrors,
		(*70*)prefilterOptionMismatchErrors,
		(*71*)filterMolecularWeightMismatchErrors,
		(*72*)incompatibleFilterTimeWithTypeErrors,
		(*73*)incompatibleFilterTimeOptionsErrors,
		(*74*)typeAndFilterHousingMismatchErrors,
		(*75*)sterileInstrumentMismatchErrors,
		(*76*)typeAndCentrifugeIntensityMismatchErrors,
		(*77*)sterileContainerOutMismatchErrors,
		(*78*)filtrateContainerOutMaxVolumeErrors,
		(*79*)syringeMaxVolumeErrors,
		(*80*)incorrectSyringeConnectionErrors,
		(*81*)temperatureInvalidErrors,
		(*82*)retentateWashCentrifugeIntensityTypeErrors,
		(*83*)washRetentateTypeErrors,
		(*84*)retentateWashMixErrors,
		(*85*)washRetentateConflictErrors,
		(*86*)resuspensionVolumeTooHighErrors,
		(*87*)flowRateNullErrors,
		(*88*)centrifugeContainerDestErrors,
		(*89*)centrifugeCollectionMethodErrors,
		(*90*)retentateContainerOutPlateErrors,
		(*91*)intensityTooHighErrors,
		(*92*)typePressureMismatchErrors,
		(*93*)pressureTooHighErrors,
		(*94*)transferringToNewFilterQs,
		(*95*)resolvedVolumes,
		(*96*)resolvedPrewetFilter,
		(*97*)resolvedPrewetFilterTime,
		(*98*)resolvedPrewetFilterBufferVolume,
		(*99*)resolvedPrewetFilterCentrifugeIntensity,
		(*100*)resolvedPrewetFilterBuffer,
		(*101*)resolvedPrewetFilterBufferLabel,
		(*102*)resolvedPrewetFilterContainerOut,
		(*103*)semiResolvedPrewetFilterContainerLabel,
		(*104*)prewetFilterMismatchErrors,
		(*105*)prewetFilterCentrifugeIntensityTypeErrors,
		(*106*)resolvedWashFlowThroughStorageCondition,
		(*107*)resolvedWashFlowThroughContainer,
		(*108*)semiResolvedWashFlowThroughDestinationWell,
		(*109*)resolvedWashFlowThroughLabel,
		(*110*)semiResolvedWashFlowThroughContainerLabel,
		(*111*)washFlowThroughSameAsFiltrateQs,
		(*112*)collectionContainerPlateMismatchErrors,
		(*113*)resolvedFilterStorageCondition,
		(*114*)resolvedCollectOccludingRetentate,
		(*115*)resolvedOccludingRetentateContainer,
		(*116*)preResolvedOccludingRetentateDestWell,
		(*117*)occludingRetentateMismatchErrors,
		(*118*)occludingRetentateNotSupportedErrors,
		(*119*)filterAirPressureDimensionsErrors,
		(*120*)resolvedNumberOfFilterPrewettings,
		(*121*)numberOfFilterPrewettingsTooHighErrors,
		(*122*)prewettingTypeMismatchErrors,
		(*123*)collectionContainerMaxVolumeErrors,
		(*124*)collectionContainerMaxVolumes
	} = Transpose[
		MapThread[
			Function[{samplePacket, volume, options, sampleContainerPacket ,sampleContainerModelPacket},
				Module[
					{
						typeBasedOnFilter, typeBasedOnInstrument, typeBasedOnOtherOptions, typeBasedOnCentrifugeOptions,
						membraneBasedOnFilter, poreSizeBasedOnFilter, molecularWeightCutoffBasedOnFilter, unresolvedType, type,
						typeBasedOnSyringeOption, unresolvedInstrument, unresolvedInstrumentModel, instrument, semiResolvedInstrument,
						unresolvedSyringe, syringe, unresolvedFlowRate, flowRate, unresolvedPoreSize, poreSize, maxRotationRate,
						unresolvedVolume, unresolvedMolecularWeightCutoff, molecularWeightCutoff, unresolvedSterile, unresolvedSterileFromOptions, sterile, filter,
						resolvedFilterModelPacket, unresovledPrefilterPoreSize, prefilterPoreSize, prefilterPoreSizeBasedOnFilter,
						unresolvedMembraneMaterial, membraneMaterial, filtrateDestinationWell, unresolvedPrefilterMembraneMaterial,
						prefilterMembraneMaterial, prefilterMembraneMaterialBasedOnFilter, unresolvedFilter, possibleFilters, vettedFilter,
						resolvedFilterPacket, buchnerFunnelQ, filterModelPacket, sterileFilterQ, centrifugeContainerDestError, filterContents,
						unresolvedFilterHousing, filterHousing, plateFilterQ, resolvedFilterFilterType, filtrateContainerTag, unTaggedContainer,
						taggedFiltrateContainerOut, filtrateContainerOut, samplesOutStorageCondition, filterUntilDrained, defaultModelDestinationContainer,
						unresolvedIntensity, intensity, washRetentate, maxTime, unresolvedTime, time, retentateCollectionOptions,
						retentateWashOptions, retentateWashMixOptions, collectRetentate, unresolvedTemperature, temperature,
						sampleOut, temperatureInvalidError, filterTypeMismatchError, filterMembraneMaterialMismatchError,
						filterPoreSizeMismatchError, filterMolecularWeightMismatchError, noFilterAvailableError, unresolvedRetentateContainerOut,
						unresolvedFiltrateContainerOut, filterMaxVolumeMismatchError, filterInletConnectionTypeMismatchError, instrumentModel,
						semiResolvedSterile, backupManualCentrifuge, backupRoboticCentrifuge, sampleContainerModelDestination,
						unresolvedRetentateDestinationWell, unresolvedFiltrateDestinationWell, possibleCentrifuges, filteredPossibleCentrifuges,
						badCentrifugeError, noUsableCentrifugeError, unresolvedCollectionContainer, collectionContainer, collectionContainerModelPacket,
						unresolvedFilterUntilDrained, unresolvedMaxTime, target, unresolvedRetentateCollectionContainer, retentateCollectionContainer,
						unresolvedCollectRetentate, unresolvedRetentateCollectionMethod, unresolvedWashRetentate, unresolvedRetentateWashBuffer,
						retentateWashMix, retentateCollectionMethod, typePressureMismatchError, pressureTooHighError, unresolvedRetentateWashVolume,
						unresolvedNumberOfRetentateWashes, unresolvedRetentateWashDrainTime, unresolvedRetentateWashCentrifugeIntensity,
						preResolvedFilter, unresolvedRetentateWashMix, unresolvedNumberOfRetentateWashMixes, centrifugeCollectionMethodError,
						unresolvedResuspensionVolume, unresolvedResuspensionBuffer, unresolvedResuspensionNumberOfMixes, resuspensionBuffer,
						resuspensionNumberOfMixes, retentateCollectionContainerModelQ, poreSizeAndMWCOMismatchQ, prefilterOptionMismatchQ,
						incompatibleFilterTimeWithTypeError, incompatibleFilterTimeOptionsError, unresolvedFilterModelPacket,
						typeAndInstrumentMismatchError, typeAndSyringeMismatchError, collectRetentateError, unresolvedRetentateContainerOutModelPacket,
						resuspensionVolume, retentateContainerOut, retentateDestinationWell, transferCollectionMethodError,
						retentateCollectionMethodError, retentateWashBuffer, retentateWashVolume, numberOfRetentateWashes, retentateWashDrainTime,
						retentateWashCentrifugeIntensity, numberOfRetentateWashMixes, typeAndFilterHousingMismatchError, sterileInstrumentMismatchError,
						totalRetentateWashVolume, typeAndCentrifugeIntensityMismatchError, sterileContainerOutMismatchError, actualSampleVolume,
						filtrateContainerOutMaxVolume, filtrateContainerOutSampleVolume, filtrateContainerOutMaxVolumeError, syringeMaxVolume,
						syringeMaxVolumeError, storageBufferQ, syringeConnectionType, incorrectSyringeConnectionError, totalCollectedVolume,
						vacuumType, vacuCapQ, retentateWashBufferWithListyNulls, retentateWashVolumeWithListyNulls, numberOfRetentateWashesWithListyNulls,
						numberOfRetentateWashMixesWithListyNulls,resolvedVolume, maxVolumePerCycle, retentateWashDrainTimeWithListyNulls,
						retentateWashCentrifugeIntensityWithListyNulls, retentateWashCentrifugeIntensityTypeError, washRetentateTypeError,
						retentateWashMixError, washRetentateConflictError, resuspensionVolumeTooHighError, unresolvedSampleLabel,
						unresolvedSampleContainerLabel, unresolvedFiltrateLabel, unresolvedFiltrateContainerLabel, unresolvedRetentateLabel,
						unresolvedRetentateContainerLabel, unresolvedSampleOutLabel, unresolvedContainerOutLabel, sampleLabel,
						sampleContainerLabel, filtrateLabel, filtrateContainerLabel, retentateLabel, retentateContainerLabel, sampleOutLabel,
						containerOutLabel, potentialPoreSize, potentialMolecularWeightCutoff, potentialMembraneMaterial,
						potentialPrefilterPoreSize, potentialPrefilterMembraneMaterial, flowRateNullError, retentateContainerOutPlateError,
						intensityTooHighError, pressure, retentateWashPressure, unresolvedPressure, unresolvedRetentateWashPressure,
						unresolvedResuspensionBufferLabel, unresolvedResuspensionBufferContainerLabel, unresolvedRetentateWashBufferLabel,
						unresolvedRetentateWashBufferContainerLabel, resuspensionBufferLabel, resuspensionBufferContainerLabel,
						retentateWashBufferLabel, retentateWashBufferContainerLabel, transferringToNewFilterQ, alreadyInFilterQ,
						prewetFilter, prewetFilterTime, prewetFilterBufferVolume, prewetFilterCentrifugeIntensity, prewetFilterBuffer,
						prewetFilterBufferLabel, prewetFilterContainerOut, prewetFilterContainerLabel, unresolvedPrewetFilter,
						unresolvedPrewetFilterTime, unresolvedPrewetFilterBufferVolume, numberOfFilterPrewettings,
						unresolvedPrewetFilterCentrifugeIntensity, unresolvedPrewetFilterBuffer, unresolvedPrewetFilterBufferLabel,
						unresolvedPrewetFilterContainerOut, unresolvedPrewetFilterContainerLabel, prewetFilterMismatchError,
						prewetFilterCentrifugeIntensityTypeError, unresolvedWashFlowThroughLabel, unresolvedWashFlowThroughContainerLabel,
						unresolvedWashFlowThroughContainer, unresolvedWashFlowThroughDestinationWell, unresolvedWashFlowThroughStorageCondition,
						washThroughSameAsFiltrateQs, washFlowThroughStorageCondition, washFlowThroughContainer, washFlowThroughDestinationWell,
						washFlowThroughLabel, washFlowThroughContainerLabel, collectionContainerPlateMismatchError,
						filterStorageCondition, unresolvedCollectionContainerLabel, maybeWashThroughSameAsFiltrateQs, occludingRetentateMismatchError,
						occludingRetentateNotSupportedError, unresolvedCollectOccludingRetentate, unresolvedOccludingRetentateContainer,
						unresolvedOccludingRetentateDestWell, unresolvedOccludingRetentateContainerLabel, collectOccludingRetentate,
						occludingRetentateContainer, occludingRetentateDestinationWell, unresolvedNumberOfFilterPrewettings,
						numberOfFilterPrewettingsTooHighError, prewettingTypeMismatchError, semiResolvedInstrumentFilterPosition,
						semiResolvedInstrumentFilterDimensions,semiResolvedInstrumentFilterDimensionPattern,filterAirPressureDimensionsError,
						collectOccludingRetentateBool,collectionContainerMaxVolumeError, collectionContainerMaxVolume
					},

					(* Error checking variables *)
					{
						poreSizeAndMWCOMismatchQ,
						prefilterOptionMismatchQ,
						noFilterAvailableError,
						filterTypeMismatchError,
						incompatibleFilterTimeWithTypeError,
						incompatibleFilterTimeOptionsError,
						badCentrifugeError,
						noUsableCentrifugeError,
						filterMembraneMaterialMismatchError,
						filterMolecularWeightMismatchError,
						filterPoreSizeMismatchError,
						filterMaxVolumeMismatchError,
						filterInletConnectionTypeMismatchError,
						typeAndInstrumentMismatchError,
						typeAndSyringeMismatchError,
						typeAndFilterHousingMismatchError,
						collectRetentateError,
						retentateCollectionMethodError,
						transferCollectionMethodError,
						sterileInstrumentMismatchError,
						typeAndCentrifugeIntensityMismatchError,
						sterileContainerOutMismatchError,
						filtrateContainerOutMaxVolumeError,
						syringeMaxVolumeError,
						incorrectSyringeConnectionError,
						temperatureInvalidError,
						retentateWashCentrifugeIntensityTypeError,
						washRetentateTypeError,
						retentateWashMixError,
						washRetentateConflictError,
						resuspensionVolumeTooHighError,
						flowRateNullError,
						centrifugeContainerDestError,
						centrifugeCollectionMethodError,
						retentateContainerOutPlateError,
						intensityTooHighError,
						typePressureMismatchError,
						pressureTooHighError,
						prewetFilterMismatchError,
						prewetFilterCentrifugeIntensityTypeError,
						collectionContainerPlateMismatchError,
						occludingRetentateMismatchError,
						occludingRetentateNotSupportedError,
						filterAirPressureDimensionsError,
						numberOfFilterPrewettingsTooHighError,
						prewettingTypeMismatchError,
						collectionContainerMaxVolumeError
					} = ConstantArray[False, 47];

					(* Pull out all the relevant unresolved options *)
					{
						unresolvedType,
						unresolvedInstrument,
						unresolvedSyringe,
						unresolvedFlowRate,
						unresolvedPoreSize,
						unresolvedMolecularWeightCutoff,
						unresovledPrefilterPoreSize,
						unresolvedMembraneMaterial,
						unresolvedPrefilterMembraneMaterial,
						unresolvedFilter,
						unresolvedFilterHousing,
						unresolvedRetentateContainerOut,
						unresolvedRetentateDestinationWell,
						unresolvedFiltrateContainerOut,
						unresolvedFiltrateDestinationWell,
						sampleOut,
						samplesOutStorageCondition,
						unresolvedIntensity,
						unresolvedTime,
						unresolvedTemperature,
						unresolvedSterileFromOptions,
						unresolvedCollectionContainer,
						unresolvedRetentateCollectionContainer,
						unresolvedFilterUntilDrained,
						unresolvedMaxTime,
						target,
						unresolvedCollectRetentate,
						unresolvedRetentateCollectionMethod,
						unresolvedWashRetentate,
						unresolvedRetentateWashBuffer,
						unresolvedRetentateWashVolume,
						unresolvedNumberOfRetentateWashes,
						unresolvedRetentateWashDrainTime,
						unresolvedRetentateWashCentrifugeIntensity,
						unresolvedRetentateWashMix,
						unresolvedNumberOfRetentateWashMixes,
						unresolvedResuspensionVolume,
						unresolvedResuspensionBuffer,
						unresolvedResuspensionNumberOfMixes,
						unresolvedSampleLabel,
						unresolvedSampleContainerLabel,
						unresolvedFiltrateLabel,
						unresolvedFiltrateContainerLabel,
						unresolvedRetentateLabel,
						unresolvedRetentateContainerLabel,
						unresolvedCollectionContainerLabel,
						unresolvedSampleOutLabel,
						unresolvedContainerOutLabel,
						unresolvedResuspensionBufferLabel,
						unresolvedResuspensionBufferContainerLabel,
						unresolvedRetentateWashBufferLabel,
						unresolvedRetentateWashBufferContainerLabel,
						unresolvedPressure,
						unresolvedRetentateWashPressure,
						unresolvedVolume,
						unresolvedPrewetFilter,
						unresolvedPrewetFilterTime,
						unresolvedNumberOfFilterPrewettings,
						unresolvedPrewetFilterBufferVolume,
						unresolvedPrewetFilterCentrifugeIntensity,
						unresolvedPrewetFilterBuffer,
						unresolvedPrewetFilterBufferLabel,
						unresolvedPrewetFilterContainerOut,
						unresolvedPrewetFilterContainerLabel,
						unresolvedWashFlowThroughLabel,
						unresolvedWashFlowThroughContainerLabel,
						unresolvedWashFlowThroughContainer,
						unresolvedWashFlowThroughDestinationWell,
						unresolvedWashFlowThroughStorageCondition,
						filterStorageCondition,
						unresolvedCollectOccludingRetentate,
						unresolvedOccludingRetentateContainer,
						unresolvedOccludingRetentateDestWell,
						unresolvedOccludingRetentateContainerLabel
					} = Lookup[
						options,
						{
							FiltrationType,
							Instrument,
							Syringe,
							FlowRate,
							PoreSize,
							MolecularWeightCutoff,
							PrefilterPoreSize,
							MembraneMaterial,
							PrefilterMembraneMaterial,
							Filter,
							FilterHousing,
							RetentateContainerOut,
							RetentateDestinationWell,
							FiltrateContainerOut,
							FiltrateDestinationWell,
							SampleOut,
							SamplesOutStorageCondition,
							Intensity,
							Time,
							Temperature,
							Sterile,
							CollectionContainer,
							RetentateCollectionContainer,
							FilterUntilDrained,
							MaxTime,
							Target,
							CollectRetentate,
							RetentateCollectionMethod,
							WashRetentate,
							RetentateWashBuffer,
							RetentateWashVolume,
							NumberOfRetentateWashes,
							RetentateWashDrainTime,
							RetentateWashCentrifugeIntensity,
							RetentateWashMix,
							NumberOfRetentateWashMixes,
							ResuspensionVolume,
							ResuspensionBuffer,
							NumberOfResuspensionMixes,
							SampleLabel,
							SampleContainerLabel,
							FiltrateLabel,
							FiltrateContainerLabel,
							RetentateLabel,
							RetentateContainerLabel,
							CollectionContainerLabel,
							SampleOutLabel,
							ContainerOutLabel,
							ResuspensionBufferLabel,
							ResuspensionBufferContainerLabel,
							RetentateWashBufferLabel,
							RetentateWashBufferContainerLabel,
							Pressure,
							RetentateWashPressure,
							Volume,
							PrewetFilter,
							PrewetFilterTime,
							NumberOfFilterPrewettings,
							PrewetFilterBufferVolume,
							PrewetFilterCentrifugeIntensity,
							PrewetFilterBuffer,
							PrewetFilterBufferLabel,
							PrewetFilterContainerOut,
							PrewetFilterContainerLabel,
							WashFlowThroughLabel,
							WashFlowThroughContainerLabel,
							WashFlowThroughContainer,
							WashFlowThroughDestinationWell,
							WashFlowThroughStorageCondition,
							FilterStorageCondition,
							CollectOccludingRetentate,
							OccludingRetentateContainer,
							OccludingRetentateDestinationWell,
							OccludingRetentateContainerLabel
						}
					];

					(* We may be able to resolve Sterile to True based on the value of workCellsBySampleProperties resolved above. *)
					unresolvedSterile = Which[
						(* Don't change the user input. *)
						BooleanQ[unresolvedSterileFromOptions], unresolvedSterileFromOptions,
						(* If STAR is not viable but (micro)bioSTAR is, resolve to True *)
						MemberQ[workCellsBySampleProperties, bioSTAR|microbioSTAR] && !MemberQ[workCellsBySampleProperties, STAR], True,
						(* Otherwise, keep this in its unresolved state for now. *)
						True, unresolvedSterileFromOptions
					];

					(* Pull out the instrument model *)
					unresolvedInstrumentModel = Which[
						MatchQ[unresolvedInstrument, ObjectP[Object]], Download[Lookup[fetchPacketFromFastAssoc[unresolvedInstrument, fastAssoc], Model], Object],
						(* This still has to be an object, cannot be a link *)
						MatchQ[unresolvedInstrument, ObjectP[]], Download[unresolvedInstrument, Object],
						(* If still Automatic, or Null *)
						True, unresolvedInstrument
					];

					(* Group relevant options together (not counting the master switches) *)
					retentateCollectionOptions = {
						unresolvedRetentateCollectionMethod,
						unresolvedResuspensionVolume,
						unresolvedResuspensionBuffer,
						unresolvedResuspensionNumberOfMixes,
						unresolvedRetentateContainerOut,
						unresolvedRetentateDestinationWell
					};
					retentateWashOptions = {
						unresolvedRetentateWashBuffer,
						unresolvedRetentateWashVolume,
						unresolvedNumberOfRetentateWashes,
						unresolvedRetentateWashDrainTime,
						unresolvedRetentateWashCentrifugeIntensity,
						unresolvedRetentateWashMix,
						unresolvedNumberOfRetentateWashMixes,
						unresolvedWashFlowThroughLabel,
						unresolvedWashFlowThroughContainerLabel,
						unresolvedWashFlowThroughContainer,
						unresolvedWashFlowThroughDestinationWell,
						unresolvedWashFlowThroughStorageCondition
					};
					retentateWashMixOptions = {
						unresolvedNumberOfRetentateWashMixes
					};

					(* First resolved Volume for the robotic primitive *)
					resolvedVolume = Which[
						(* If we already have a volume value specified besides Automatic/All, then just go with that *)
						MatchQ[unresolvedVolume, VolumeP | Null], unresolvedVolume,
						(* If we're doing Manual, this option is moot anyway *)
						Not[roboticQ], Null,
						(* If sample volume is 0 Liter, convert that to All *)
						MatchQ[volume, EqualP[0 Liter]], All,
						(* Otherwise, if they specified All or Automatic, convert that to the sample volume *)
						True, volume
					];

					(* Resolve the master switch options *)

					(* Resolve whether CollectRetentate is True or False *)
					collectRetentate = Which[
						(* If it's set then it's set *)
						BooleanQ[unresolvedCollectRetentate], unresolvedCollectRetentate,
						(* If it's not set, but any of the retentate collection or retentate wash (or the retentate wash Boolean which is not included in retentateWashOptions), then resolve to True *)
						MemberQ[Flatten[{retentateCollectionOptions, retentateWashOptions, unresolvedWashRetentate}], Except[Automatic | Null | False]], True,
						MatchQ[target, Retentate], True,
						True, False
					];

					(* Figure out whether WashRetentate is True or False *)
					washRetentate = Which[
						(* If it's set then it's set *)
						BooleanQ[unresolvedWashRetentate], unresolvedWashRetentate,
						(* If it's not set but any of the retentate wash options are specified, resolve to True *)
						MemberQ[Flatten[retentateWashOptions], Except[Automatic | Null | False]], True,
						(* If it's not set but we are not collecting retentate, automatically set to False *)
						MatchQ[collectRetentate, False], False,
						(* If we are collecting retentate but none of the wash options have been specified, resolve to False *)
						True, False
					];

					(* Figure out whether RetentateWashMix is True or False *)
					retentateWashMix = Map[
						Which[
							(* If it's set then it's set *)
							BooleanQ[#], #,
							(* If it's not set but any of the retentate wash mix options are specified, resolve to True *)
							MemberQ[Flatten[retentateWashMixOptions], Except[Automatic | Null | False]], True,
							(* If it's not set but we are not retentate washing, resolve to Null *)
							MatchQ[washRetentate, False | Null], Null,
							(* If we are retentate washing, still resolve to False *)
							True, False
						]&,
						unresolvedRetentateWashMix
					];

					(* Get the destination model if there is one *)
					(* Note that this field only exists in Model[Container, Vessel, Filter] and so can only be an object if the sample container model packet is a filter *)
					sampleContainerModelDestination = Lookup[sampleContainerModelPacket, DestinationContainerModel, Null];

					(* Pre-resolve the filter if it is specified or if the sample is already in a filter; otherwise stick with what we had already *)
					preResolvedFilter = Which[
						And[
							MatchQ[unresolvedFilter, ObjectP[{Model[Container, Plate, Filter], Model[Container, Vessel, Filter]}]],
         			MatchQ[Lookup[sampleContainerModelPacket, Object], ObjectP[unresolvedFilter]]
						],
							(* If user has specified the model of filter in Filter option and the samples are in the same filter, update the filter option from model to object *)
							Lookup[sampleContainerPacket, Object],
						And[
							MatchQ[unresolvedFilter, ObjectP[Object[Container]]],
							MatchQ[Lookup[sampleContainerPacket, Object], Object[unresolvedFilter]]
						],
							(* If user has specified the filter object in Filter option and the samples are in the same filter, resolve to the sample container *)
							Lookup[sampleContainerPacket, Object],
						Or[
							MatchQ[unresolvedFilter, Automatic] && MatchQ[sampleContainerModelDestination, ObjectP[]],
							MatchQ[unresolvedFilter, Automatic] && MatchQ[Lookup[sampleContainerPacket, Type], Object[Container, Plate, Filter]]
						],
							(* If we are given a Filter via option, then get the packet for the model of that guy *)
							Lookup[sampleContainerPacket, Object],
						True,
							(* Even if the sample is in a filter plate, if the model of the filter plate is different than specified filter option, use the filter option *)
							unresolvedFilter
					];

					(* If we are given a Filter via option, then get the packet for the model of that guy *)
					unresolvedFilterModelPacket = Which[
						MatchQ[preResolvedFilter, ObjectP[Object]], fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, preResolvedFilter, Model], fastAssoc],
						MatchQ[preResolvedFilter, ObjectP[Model]], fetchPacketFromFastAssoc[preResolvedFilter, fastAssoc],
						True, preResolvedFilter
					];

					(* If a filter was provided, then that also implies some other options (filtration type, membrane material and pore size).
						 - pull out those values from the filter model and stash them
						 - when resolving, override any automatics or provided options with the ones from the model
						 - do the usual message/error complaining that there is incongruity if they provide both a filter AND an option,
						 - then keep on rolling through it, it will error check further down
					*)
					typeBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresolvedType, Automatic] && Not[roboticQ],
						ReplaceAll[
							Lookup[unresolvedFilterModelPacket, {FilterType, Diameter}],
							(* assume if we have a membrane filter small enough to go onto a buchner funnel, then we're doing that; otherwise it needs to be a PeristalticPump *)
							{{Disk, _} -> Syringe, {BottleTop, _} -> Vacuum, {Membrane, LessEqualP[widestBuchnerFunnelDiameteter]} -> Vacuum, {Membrane, _} -> PeristalticPump, {Centrifuge, _} -> Centrifuge, {$Failed, _} | {_, $Failed} | $Failed -> Automatic, Null -> Automatic}
						],
						unresolvedType
					];
					membraneBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresolvedMembraneMaterial, Automatic],
						Lookup[unresolvedFilterModelPacket, MembraneMaterial],
						unresolvedMembraneMaterial
					];
					poreSizeBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresolvedPoreSize, Automatic],
						Lookup[unresolvedFilterModelPacket, PoreSize],
						unresolvedPoreSize
					];
					molecularWeightCutoffBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresolvedMolecularWeightCutoff, Automatic],
						Lookup[unresolvedFilterModelPacket, MolecularWeightCutoff],
						unresolvedMolecularWeightCutoff
					];
					prefilterMembraneMaterialBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresolvedPrefilterMembraneMaterial, Automatic],
						Lookup[unresolvedFilterModelPacket, PrefilterMembraneMaterial],
						unresolvedPrefilterMembraneMaterial
					];
					prefilterPoreSizeBasedOnFilter = If[MatchQ[preResolvedFilter, ObjectP[]] && MatchQ[unresovledPrefilterPoreSize, Automatic],
						Lookup[unresolvedFilterModelPacket, PrefilterPoreSize],
						unresovledPrefilterPoreSize
					];

					(* If user has provided an instrument, it can also imply the type of instrument to use *)
					(* it is possible that typeBasedOnFilter and typeBasedOnInstrument are mismatched, but there is a check for that soon *)
					(* for resolution, we'll go by the filter *)
					(* also look at the FilterHousing option *)
					typeBasedOnInstrument = Switch[{unresolvedInstrument, unresolvedFilterHousing},
						{Automatic, Automatic|Null}, Automatic,
						{ObjectP[{Model[Instrument, PeristalticPump], Object[Instrument, PeristalticPump]}], _}, PeristalticPump,
						{ObjectP[{Model[Instrument, VacuumPump], Object[Instrument, VacuumPump]}], _}, Vacuum,
						{ObjectP[{Model[Instrument, SyringePump], Object[Instrument, SyringePump]}], _}, Syringe,
						{ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}], _}, Centrifuge,
						{_, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]}, Vacuum,
						{_, ObjectP[{Model[Instrument, FilterHousing], Object[Instrument, FilterHousing]}]}, PeristalticPump,
						{ObjectP[{Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}], _}, AirPressure,
						{_, _}, Automatic
					];

					(* If Intensity or Temperature option is specified, then we're assuming that means centrifuge filtration *)
					typeBasedOnCentrifugeOptions = Which[
						MatchQ[unresolvedIntensity, GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]] || TemperatureQ[unresolvedTemperature],
							Centrifuge,
						(* If we are using robotic preparation and not specifying any centrifuge options, resolves it to AirPressure *)
						roboticQ,
							AirPressure,
						(* Otherwise, leave it automatic *)
						True, Automatic
					];

					(* If Syringe is specified, then type is going to be Syringe *)
					typeBasedOnSyringeOption = If[MatchQ[unresolvedSyringe, ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]],
						Syringe,
						Automatic
					];

					(* If both filter and instrument were provided, make sure to account for cases where they could be different *)
					(* also accounting if any centrifuge, air pressure, or syringe options were provided *)
					(* priority goes Filter > Instrument > Centrifuge > Syringe options *)
					typeBasedOnOtherOptions = Switch[
						{typeBasedOnFilter, typeBasedOnInstrument, typeBasedOnCentrifugeOptions, typeBasedOnSyringeOption},
						(* If they didn't provide any type, instrument, centrifuge, syringe, or pressure options, then keep on keeping on *)
						{Automatic, Automatic, Automatic, Automatic}, Automatic,

						(* If they provide a type via filter, then go with that, regardless of what else *)
						{Except[Automatic], _, _, _}, typeBasedOnFilter,

						(* If they provided an instrument but not a type via filter, then resolve type based on that regardless of anything else *)
						{Automatic, Except[Automatic], _, _}, typeBasedOnInstrument,

						(* If they provided some centrifuge option but not the filter or instrument, then assume the type they want is centrifugation *)
						{Automatic, Automatic, Except[Automatic], _}, typeBasedOnCentrifugeOptions,

						(* If they provided the Syringe option but not the filter, instrument, or centrifuge options, then assume the type they want is Syringe *)
						{Automatic, Automatic, Automatic, Except[Automatic]}, typeBasedOnSyringeOption,

						(* shouldn't ever get this far, but at the end of the day default to typeBasedOnFilter *)
						{_, _, _, _}, typeBasedOnFilter
					];


					(* Resolve the rest of the retentate wash options *)
					(* Note that this does _not_ include the RetentateWashCentrifugeIntensity, RetentateWashDrainTime or RetentateWashPressure options *)
					(* because those need the Intensity, Time and Pressure options resolved first *)
					(* also does not include WashFlowThroughLabel, WashFlowThroughContainerLabel, WashFlowThroughContainer, WashFlowThroughDestinationWell, or WashFlowThroughStorageCondition, *)
					(* because those require the other label options, the FiltrateContainerOut, FiltrateDestinationWell, and SamplesOutStorageCondition to be resolved *)
					{
						retentateWashBufferWithListyNulls,
						retentateWashVolumeWithListyNulls,
						numberOfRetentateWashesWithListyNulls,
						numberOfRetentateWashMixesWithListyNulls
					} = Transpose[MapThread[
						Function[{washBuffer, washVolume, numWashes, numWashMixes, singleRetentateWashMix},
							Module[
								{singleRetentateWashBuffer, singleWashVolume, singleNumWashes, singleNumWashMixes},

								(* Resolve wash buffer to Water if WashRetentate is True and not specified, or Null if not washing *)
								singleRetentateWashBuffer = Which[
									Not[MatchQ[washBuffer, Automatic]], washBuffer,
									Not[TrueQ[washRetentate]], Null,
									True, Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
								];

								(* Resolve wash volume to initial volume of input sample if not set and we are washing *)
								singleWashVolume = Which[
									Not[MatchQ[washVolume, Automatic]], washVolume,
									Not[TrueQ[washRetentate]], Null,
									True, volume
								];

								(* Resolve number of washes to 1 if not set and we're washing *)
								singleNumWashes = Which[
									Not[MatchQ[numWashes, Automatic]], numWashes,
									Not[TrueQ[washRetentate]], Null,
									True, 1
								];

								(* Resolve number of wash mixes to 10 if washing and mixing *)
								singleNumWashMixes = Which[
									Not[MatchQ[numWashMixes, Automatic]], numWashMixes,
									Not[TrueQ[washRetentate]] || Not[TrueQ[singleRetentateWashMix]], Null,
									True, 10
								];

								{
									singleRetentateWashBuffer,
									singleWashVolume,
									singleNumWashes,
									singleNumWashMixes
								}
							]
						],
						{
							unresolvedRetentateWashBuffer,
							unresolvedRetentateWashVolume,
							unresolvedNumberOfRetentateWashes,
							unresolvedNumberOfRetentateWashMixes,
							retentateWashMix
						}
					]];

					(* Make the listy nulls into flat nulls so that the command builder works nicely *)
					retentateWashBuffer = retentateWashBufferWithListyNulls /. {{Null..} :> Null};
					retentateWashVolume = retentateWashVolumeWithListyNulls /. {{Null..} :> Null};
					numberOfRetentateWashes = numberOfRetentateWashesWithListyNulls /. {{Null..} :> Null};
					numberOfRetentateWashMixes = numberOfRetentateWashMixesWithListyNulls /. {{Null..} :> Null};

					(* Get the total retentate wash volume *)
					(* the ToList is important if we have Null instead of a list here *)
					totalRetentateWashVolume = If[SameLengthQ[retentateWashVolume, numberOfRetentateWashes] && MatchQ[retentateWashVolume, {VolumeP..}] && MatchQ[numberOfRetentateWashes, {NumberP..}],
						retentateWashVolume * numberOfRetentateWashes,
						ToList[retentateWashVolume]
					];

					(* Get the actual sample volume so we don't have to do this If call a lot below *)
					actualSampleVolume = If[MatchQ[resolvedVolume, All|Null],
						volume,
						resolvedVolume
					];

					(* Get the total sample volume + retentate wash volumes *)
					totalCollectedVolume = Total[Cases[Flatten[{actualSampleVolume, totalRetentateWashVolume}], VolumeP]];

					(* Get the maximum volume of one iteration of sample or retentate washing (because it's fine for sample + retentate wash to be over MaxVolume, just not any one instance) *)
					(* Make sure we end up with a volume and not negative infinity like Max[{}] gives you *)
					maxVolumePerCycle = Replace[
						Max[Cases[Flatten[{actualSampleVolume, retentateWashVolume}], VolumeP]],
						Except[VolumeP] -> 0 Milliliter
					];

					(* The sterile part can be mostly ignored, since the limiting step is going to be finding a sterile filter *)
					type = Switch[{resolvedPreparation, unresolvedSterile, typeBasedOnOtherOptions, totalCollectedVolume},
						{Manual, _, Automatic, LessP[2. Milliliter]}, Centrifuge, (* under 2mL, goes through a plate *)
						{Manual, True, Automatic, RangeP[2 Milliliter, 5 Milliliter]}, Centrifuge, (* 5mL or under and sterile, goes in centrifuge tube *)
						{Manual, Automatic | False, Automatic, RangeP[2 Milliliter, 50 Milliliter]}, Syringe, (* between 2mL and 50mL use a syringe *)
						{Manual, True, Automatic, RangeP[5 Milliliter, 4 Liter, Inclusive -> Right]}, Vacuum, (* 55mL to 4L sterile,uses a sterile VacCap *)
						{Manual, Automatic | False, Automatic, RangeP[50 Milliliter, 1 Liter, Inclusive -> Left]}, Vacuum, (* 50mL to 1L not sterile, still use bottle tops or buchner funnel (though don't actually include 1L; that should roll over onto PeristalticPump) *)
						{Manual, Automatic | False, Automatic, RangeP[1 Liter, 20 Liter, Inclusive -> All]}, PeristalticPump, (* over 4L user the filter housing and PP*)
						{Manual, True, Automatic, RangeP[4 Liter, 20 Liter, Inclusive -> Right]}, PeristalticPump, (* over 4L user the filter housing and PP*)
						_, typeBasedOnOtherOptions
					];

					(* Get the semi-resolved instrument object *)
					(* calling it semi-resolved because depending on what CentrifugeDevices says, it's possible *)
					semiResolvedInstrument = Switch[{resolvedPreparation, unresolvedSterile, type, unresolvedInstrument, volume, preResolvedFilter},
						{_, _, _, ObjectP[], _, _}, unresolvedInstrument, (* take the user option no matter what *)
						{Manual, Automatic | False, PeristalticPump, Automatic, _, _}, Model[Instrument, PeristalticPump, "id:n0k9mG8KZlb6"],(*"VWR Peristaltic Variable Pump PP3400"*)
						(* If Filter is unspecified or specified to a plate filter and the volume is right then go with the vacuum for plate filtering *)
						{Manual, Automatic | False, Vacuum, Automatic, LessEqualP[2 Milliliter], Automatic | ObjectP[Model[Container, Plate, Filter]]}, Model[Instrument, VacuumPump, "id:01G6nvkKr3oA"], (* "Welch 2030B-01"Model" this is the filter pump that goes with Model[Instrument, FilterBlock, "Filter Block"] *)
						{Manual, Automatic | False, Vacuum, Automatic, _, ObjectP[{Model[Item, Filter], Object[Item, Filter]}]}, Model[Instrument, VacuumPump, "id:N80DNj18E15W"],(*"VACSTAR Control"]*)
						{Manual, True, Vacuum, Automatic, _, _}, Model[Instrument, VacuumPump, "id:GmzlKjPepoxE"],(*"Rocker 300 for Filtration, Sterile"*)
						{Manual, Automatic | False, Vacuum, Automatic, _, _}, Model[Instrument, VacuumPump, "id:lYq9jRzZjNmA"],(*"Rocker 300 for Filtration, Non-sterile"*)
						{Manual, _, Syringe, Automatic, _, _}, Model[Instrument, SyringePump, "id:GmzlKjPzN9l4"],(*"NE-1010 Syringe Pump"*)
						{Manual, _, Centrifuge, Automatic, _, ObjectP[{Object[Container, Plate, Filter], Model[Container, Plate, Filter]}]}, Model[Instrument, Centrifuge, "id:eGakldJEz14E"], (* "Eppendorf 5920R" If it's a plate filter then we have to resolve to this centrifuge *)
						{Robotic, _, Centrifuge, Automatic, _, _}, unresolvedInstrument,(* For robotic centrifuge, can be HiG or VSpin, deal with it later *)
						{Robotic, True, AirPressure, Automatic, _, _}, Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*"MPE2 Sterile"*)
						{Robotic, _, AirPressure, Automatic, _, _}, Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"],(*"MPE2"*)
						(* All other cases, just stick with the unresolved value and deal with it later *)
						{_, _, _, _, _, _}, unresolvedInstrument
					];

					(* Based on the semi-resolved instrument, check for the dimension requirements for AirPressure - MPE2 as not all plates fit in there *)
					semiResolvedInstrumentFilterPosition = If[Or[
						MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]}]],
						MatchQ[unresolvedInstrumentModel, ObjectP[{Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]}]]
					],
						FirstCase[
							Lookup[fetchPacketFromFastAssoc[FirstCase[{unresolvedInstrumentModel, semiResolvedInstrument}, ObjectP[Model]], fastAssoc], Positions, {}],
							KeyValuePattern[Name -> "Filter Plate Slot"],
							<||>
						],
						<||>
					];

					semiResolvedInstrumentFilterDimensions = {Lookup[semiResolvedInstrumentFilterPosition, MaxWidth, Null], Lookup[semiResolvedInstrumentFilterPosition, MaxDepth, Null], Null};

					semiResolvedInstrumentFilterDimensionPattern = semiResolvedInstrumentFilterDimensions/.{length:(GreaterP[0 Millimeter]) :> LessEqualP[length], Null -> (_)};

					(* Get the syringe based on the smallest LuerLock syringe that fits the volume *)
					syringe = Switch[{resolvedPreparation, unresolvedSyringe, type},
						{Manual, Except[Automatic], _}, unresolvedSyringe,
						{Manual, Automatic, Syringe},
							Lookup[
								FirstCase[allContainerPackets, KeyValuePattern[{Type -> Model[Container, Syringe], ConnectionType -> LuerLock, MaxVolume -> GreaterEqualP[volume]}], <||>],
								Object,
								Null
							],
						{_, _, _}, Null
					];

					(* Get the syringe MaxVolume *)
					syringeMaxVolume = Which[
						NullQ[syringe], Null,
						MatchQ[syringe, ObjectP[Model[Container, Syringe]]], fastAssocLookup[fastAssoc, syringe, MaxVolume],
						MatchQ[syringe, ObjectP[Object[Container, Syringe]]], fastAssocLookup[fastAssoc, syringe, {Model, MaxVolume}],
						True, Null
					];

					(* Resolve the flow rate *)
					flowRate = Which[
						Not[MatchQ[unresolvedFlowRate, Automatic]], unresolvedFlowRate,
						Not[MatchQ[type, Syringe]], Null,
						MatchQ[unresolvedTime, TimeP], (syringeMaxVolume/unresolvedTime),
						VolumeQ[syringeMaxVolume], syringeMaxVolume * 0.2 / Minute,
						True, Null
					];

					(* Flip error switch if FlowRate is specified when FiltrationType is not Syringe *)
					flowRateNullError = Or[
						NullQ[flowRate] && MatchQ[type, Syringe],
						Not[NullQ[flowRate]] && Not[MatchQ[type, Syringe]]
					];

					(* Determine whether we are collecting the occluding retentate *)
					collectOccludingRetentate = Which[
						Not[MatchQ[unresolvedCollectOccludingRetentate, Automatic]], unresolvedCollectOccludingRetentate,
						MatchQ[type, Syringe], True,
						(* note that it can be Null if we're not doing Syringe; seemingly it looks better in the command builder if this is Null and not False for non-syringe filtering *)
						True, Null
					];

					(* need a variable that is always a Boolean here *)
					collectOccludingRetentateBool = TrueQ[collectOccludingRetentate];

					(* Determine the container we're going to put the occluding retentate into *)
					occludingRetentateContainer = Which[
						Not[MatchQ[unresolvedOccludingRetentateContainer, Automatic]], unresolvedOccludingRetentateContainer,
						Not[collectOccludingRetentateBool], Null,
						True, PreferredContainer[actualSampleVolume](* Note if we use volume which could be All, PreferredContainer will return a list of containers instead of 1. *)
					];

					(* Semi-resolve the OccludingRetentateDestinationWell because if it's a plate then keep it as Automatic or what was specified; otherwise set to A1 *)
					occludingRetentateDestinationWell = Which[
						Not[MatchQ[unresolvedOccludingRetentateDestWell, Automatic]], unresolvedOccludingRetentateDestWell,
						NullQ[occludingRetentateContainer], Null,
						Not[MatchQ[occludingRetentateContainer, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]], "A1",
						True, Automatic
					];

					(* Flip the occluding retentate conflict error switch if CollectOccludingRetentate -> True and the other options are Null, or it's True and the other options are unspecified *)
					occludingRetentateMismatchError = Or[
						collectOccludingRetentateBool && (NullQ[occludingRetentateContainer] || NullQ[occludingRetentateDestinationWell] || NullQ[unresolvedOccludingRetentateContainerLabel]),
						Not[collectOccludingRetentateBool] && (Not[NullQ[occludingRetentateContainer]] || Not[NullQ[occludingRetentateDestinationWell]] || Not[MatchQ[unresolvedOccludingRetentateContainerLabel, Null | Automatic]])
					];

					(* flip the occluding retentate not supported error switch if we're trying to do this with any type of filtering besides syringe filtering *)
					occludingRetentateNotSupportedError = collectOccludingRetentateBool && Not[MatchQ[type, Syringe]];

					(* Get the potential option values; if Automatic, then it becomes _ because we let anything be in there for the pattern *)
					{
						potentialPoreSize,
						potentialMolecularWeightCutoff,
						potentialMembraneMaterial,
						potentialPrefilterPoreSize,
						potentialPrefilterMembraneMaterial
					} = {
						(* Convert expression to numerical value *)
						N[poreSizeBasedOnFilter],
						N[molecularWeightCutoffBasedOnFilter],
						membraneBasedOnFilter,
						N[prefilterPoreSizeBasedOnFilter],
						prefilterMembraneMaterialBasedOnFilter
					} /. {Automatic -> _};

					(* Get the possible filters and filter types given the options we have *)
					possibleFilters = Switch[
						{resolvedPreparation, type, unresolvedSterile},

						{Manual, PeristalticPump, _},
							Cases[allFilterPackets,
								KeyValuePattern[{
									Type -> Model[Item, Filter], PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff,
									MembraneMaterial -> potentialMembraneMaterial, PrefilterPoreSize -> potentialPrefilterPoreSize,
									PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, FilterType -> Membrane,
									MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
									Diameter -> RangeP[142. Millimeter, 142. Millimeter]
								}]
							],
						{Manual, Vacuum, False|Automatic},
							If[maxVolumePerCycle > 2 Milliliter,
								(* bottle top + membrane (i.e., Buchner funnel) *)
								Flatten[{
									Cases[allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Item, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
											FilterType -> Membrane,
											(* this is super hard-code-y I admit, but I can't come up with another way to distinguish the Whatman filters for the buchner funnels (which will be way smaller than 142 Millimeter) and the peristaltic pump filters, which definitely won't work with vacuum *)
											Diameter -> LessP[142. Millimeter]
										}]],
									Cases[allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Container, Vessel, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
											FilterType -> BottleTop
										}]
									],
									Cases[allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Item, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
											FilterType -> BottleTop
										}]
									]
								}],
								(* membrane filtering; allow buchner funnels but not bottle tops here  *)
								Flatten[{
									Cases[allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Container, Plate, Filter],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial, MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP
										}]
									],
									Cases[allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Item, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
											FilterType -> Membrane
										}]]
								}]
							],
						{Manual, Vacuum, True},
							Flatten[{
								Cases[allFilterPackets,
									KeyValuePattern[{
										Type -> Model[Item, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
										PoreSize -> potentialPoreSize, MembraneMaterial -> potentialMembraneMaterial,
										PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
										FilterType -> BottleTop, Sterile -> True
									}]
								],
								Cases[allFilterPackets,
									KeyValuePattern[{
										Type -> Model[Container, Vessel, Filter], MinVolume -> LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
										PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
										PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
										FilterType -> BottleTop, Sterile -> True
									}]
								]
							}],

						{Manual, Syringe, _},
							Flatten[{
								Cases[allFilterPackets,
									KeyValuePattern[{
										Type -> Model[Item, Filter], MinVolume -> LessEqualP[volume], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
										PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
										PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
										FilterType -> Disk, InletConnectionType -> LuerLock
									}]
								],
								Cases[allFilterPackets,
									KeyValuePattern[{
										Type -> Model[Item, ExtractionCartridge], MinVolume -> LessEqualP[volume], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
										PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
										PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial,
										FilterType -> Disk, InletConnectionType -> LuerLock
									}]
								]
							}],
						{Manual, Centrifuge, _},
							(* If the samples are already in filter plates, it would make sense to use the filter plate as the centrifuge plate, right? *)
							(* Only exception is when the Filter option is set differently *)
							Which[
								MatchQ[Lookup[sampleContainerModelPacket, Type], Model[Container, Plate, Filter]] && MatchQ[preResolvedFilter, ObjectP[Lookup[sampleContainerPacket, Object]]],
									{sampleContainerModelPacket},
								(* We should eventually remove this hard-code, but if the user specifically requests the plate centrifuge, resolve to using filter plates *)
								(* {Model[Instrument, Centrifuge, "Eppendorf 5920R"], Object[Instrument, Centrifuge, "Eppendorf 5920R"]}*)
								(* also if you have a plate centrifuge but you need to collect retentate via centrifuge, then you're hosed already so just give up *)
								MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, Centrifuge, "id:eGakldJEz14E"], Object[Instrument, Centrifuge, "id:KBL5Dvw93km7"]}]] && MatchQ[unresolvedRetentateCollectionMethod, Centrifuge],
									{},
								MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, Centrifuge, "id:eGakldJEz14E"], Object[Instrument, Centrifuge, "id:KBL5Dvw93km7"]}]],
									Cases[
										allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Container, Plate, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP, If[TrueQ[unresolvedSterile], Sterile -> True, Nothing]
										}]
									],
								True,
									(* Otherwise, if we're a RetentateCollectionMethod -> Centrifuge, resolve only to the tubes that can do that and not any plates or any other tubes *)
									Flatten[{
										If[MatchQ[unresolvedRetentateCollectionMethod, Centrifuge],
											{},
											Cases[
												allFilterPackets,
												KeyValuePattern[{
													Type -> Model[Container, Plate, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
													PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
													PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP, If[TrueQ[unresolvedSterile], Sterile -> True, Nothing]
												}]
											]
										],
										(* Else: get a filter from cache ball that matches our initial criteria *)
										Module[{potentialCentrifugeFilterPackets, destinationContainerModels, destinationContainerCounterweights},
											(* Get packets that match our criteria from the cache ball *)
											potentialCentrifugeFilterPackets = Cases[allFilterPackets,
												KeyValuePattern[{
													Type -> Model[Container, Vessel, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
													PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
													PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP,
													FilterType -> Centrifuge,
													DestinationContainerModel -> ObjectP[Model[Container, Vessel]],
													If[MatchQ[unresolvedRetentateCollectionMethod, Centrifuge], RetentateCollectionContainerModel -> ObjectP[Model[Container, Vessel]], Nothing],
													If[TrueQ[unresolvedSterile], Sterile -> True, Nothing]
												}]
											];

											(* Get the DestinationContainerModel from the packets *)
											destinationContainerModels = Download[Lookup[potentialCentrifugeFilterPackets, DestinationContainerModel, {}], Object];

											(* Get the conterweights of the DestinationContainerModel *)
											destinationContainerCounterweights = Lookup[fetchPacketFromFastAssoc[#, fastAssoc]& /@ destinationContainerModels, Counterweights, {}];

											(* Vetted further to return only the filter packets with DestinationContainer models that have counterweights *)
											PickList[potentialCentrifugeFilterPackets,destinationContainerCounterweights,Except[{}]]
										]
									}]
							],

						{Robotic, Centrifuge, _},
							(* If the samples are already in filter plates, it would make sense to use the filter plate as the centrifuge plate, right? *)
							(* Only exception is when the Filter option is set differently *)
							Which[
								MatchQ[Lookup[sampleContainerModelPacket, Type], Model[Container, Plate, Filter]] && MatchQ[preResolvedFilter, ObjectP[Lookup[sampleContainerPacket, Object]]],
									{sampleContainerModelPacket},
								(* We should eventually remove this hard-code, but if the user specifically requests the plate centrifuge, resolve to using filter plates *)
								(* {Model[Instrument, Centrifuge, "HiG4"], Object[Instrument, Centrifuge, "HiG4 Method Man"],Object[Instrument, Centrifuge, "HiG4 Johnny Five"], Model[Instrument, Centrifuge, "VSpin"],Object[Instrument, Centrifuge, "VSpin Lin Manuel"]}*)
								(* also if you have a plate centrifuge but you need to collect retentate via centrifuge, then you're hosed already so just give up *)
								MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], Object[Instrument, Centrifuge, "id:Vrbp1jG80PPE"], Object[Instrument, Centrifuge, "id:lYq9jRzX3DDp"], Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"],Object[Instrument, Centrifuge, "id:R8e1Pjpk3k1a"]}]] && MatchQ[unresolvedRetentateCollectionMethod, Centrifuge],
									{},
								MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"], Object[Instrument, Centrifuge, "id:Vrbp1jG80PPE"], Object[Instrument, Centrifuge, "id:lYq9jRzX3DDp"], Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"],Object[Instrument, Centrifuge, "id:R8e1Pjpk3k1a"]}]],
									Cases[
										allFilterPackets,
										KeyValuePattern[{
											Type -> Model[Container, Plate, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
											PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
											PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP,
											If[TrueQ[unresolvedSterile], Sterile -> True, Nothing], LiquidHandlerPrefix -> Except[Null]
										}]
									],
								True,
									(* Otherwise, if we're a RetentateCollectionMethod -> Centrifuge, resolve only to the filter plates that can do that in robot *)
									If[MatchQ[unresolvedRetentateCollectionMethod, Centrifuge],
										{},
										Cases[
											allFilterPackets,
											KeyValuePattern[{
												Type -> Model[Container, Plate, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
												PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
												PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP,
												If[TrueQ[unresolvedSterile], Sterile -> True, Nothing], LiquidHandlerPrefix -> Except[Null]
											}]
										]
									]
							],

						{Robotic, AirPressure, _},
						(* If the samples are already in filter plates, it would make sense to use the filter plate as the centrifuge plate, right? *)
						(* Only exception is when the Filter option is set differently *)
						If[
							MatchQ[Lookup[sampleContainerModelPacket, Type], Model[Container, Plate, Filter]] && MatchQ[preResolvedFilter, ObjectP[Lookup[sampleContainerPacket, Object]]],
								{sampleContainerModelPacket},
							(* Otherwise, resolve only to the filter plates that can do that in robot *)
							Cases[
								allFilterPackets,
								KeyValuePattern[{
									Type -> Model[Container, Plate, Filter], MinVolume -> Null|LessEqualP[maxVolumePerCycle], MaxVolume -> GreaterEqualP[maxVolumePerCycle],
									PoreSize -> potentialPoreSize, MolecularWeightCutoff -> potentialMolecularWeightCutoff, MembraneMaterial -> potentialMembraneMaterial,
									PrefilterPoreSize -> potentialPrefilterPoreSize, PrefilterMembraneMaterial -> potentialPrefilterMembraneMaterial, Footprint -> FootprintP,
									If[TrueQ[unresolvedSterile], Sterile -> True, Nothing], LiquidHandlerPrefix -> Except[Null],
									Dimensions -> semiResolvedInstrumentFilterDimensionPattern
								}]
							]
						],

						{_, _, _},
						{}
					];

					(* Double check the filters *)
					(*
						If the option was automatic and some filters were found then use the first
						If the option was automatic and none were found,then errors and such, set the option to None
						If the option was not automatic and the selected filter is on the list of found ones, then that's ok
						If the option was not automatic and the selected filter is not on the list, then error and such
					*)

					(* This indicates that no viable filter could be found, whether that's because there is no filter period, or because the filter the user provides
					doesn't fulfill one of the criteria that makes a good filter or we couldn't even find a good backup filter (that doesn't quite fit ideal resolution) *)
					(* we'll show either an error that says no filter could be found at all, or that the relevant error saying the they filter they picked it bad *)
					noFilterAvailableError = MatchQ[possibleFilters, {}];

					(* Pick the filter we need based on potential filters *)
					vettedFilter = Switch[{noFilterAvailableError, preResolvedFilter, possibleFilters, sampleContainerModelDestination},
						(* If the container in is a filter and has a destination, then use that model of the container holding the sample *)
						{False, Automatic, _, ObjectP[]}, Lookup[sampleContainerModelPacket, Object],
						(* awesome, we found a usable filter *)
						{False, Automatic, Except[{}], _},
							(* this is admittedly rather silly, but we probably want to prefer certain kinds of filters over others rather than just totally randomly picking some *)
							(* to mimic the previous values, going to prefer PES filters to no-PES ones, and 0.22 Micron filters to non-0.22 Micron filters *)
							(* If not told to do so, probably better to focus on BottleTop over Membrane for Vacuum *)
							(* If in the future we want to prefer certain kinds of filters first then do that here *)
							Which[
								MatchQ[type, Vacuum] && MemberQ[Lookup[possibleFilters, FilterType], BottleTop],
									Lookup[SelectFirst[possibleFilters, MatchQ[Lookup[#, FilterType], BottleTop]&], Object],

								MatchQ[type, AirPressure] && MemberQ[Lookup[possibleFilters, Object], ObjectP[Model[Container,Plate,Filter]]] && MemberQ[Lookup[possibleFilters, LiquidHandlerPrefix,Null], Except[Null]],
									Lookup[
										SelectFirst[
											possibleFilters,
											(And[
												MatchQ[Lookup[#, Object], ObjectP[Model[Container, Plate, Filter]]],
												MatchQ[Lookup[#, LiquidHandlerPrefix, Null], Except[Null]],
												MatchQ[Lookup[#, MaxVolume], GreaterP[resolvedVolume]]
											])&
										],
										Object
									],

								MemberQ[Lookup[possibleFilters, MembraneMaterial], PES],
									Lookup[SelectFirst[possibleFilters, MatchQ[Lookup[#, MembraneMaterial], PES]&], Object],

								MemberQ[Lookup[possibleFilters, PoreSize], EqualP[0.22 Micron]],
									Lookup[SelectFirst[possibleFilters, MatchQ[Lookup[#, PoreSize], EqualP[0.22 Micron]]&], Object],

								True, Lookup[First[possibleFilters], Object]
							],
						(* Whether it's usable or not, we'll go with their selection, and complain about it if it's stupid *)
						{False, _, _, _}, preResolvedFilter,
						(* no usable filter, we'll pick a rando one, and then complain about it later *)
						{True, _, _, _},
							Switch[{type, resolvedPreparation},
								{PeristalticPump, Manual}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Item, Filter], FilterType -> Membrane}], <||>], Object, Null],
								(* given no other information, just pick the bottle top filters since we're hosed anyway at this point *)
								{Vacuum, Manual}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Container, Vessel, Filter], FilterType -> BottleTop}], <||>], Object, Null],
								{Syringe, Manual}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Item, Filter], FilterType -> Disk}], <||>], Object, Null],
								{Centrifuge, Manual}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Container, Vessel, Filter], FilterType -> Centrifuge, MaxVolume -> GreaterP[volume]}], <||>], Object, Null],
								{Centrifuge, Robotic}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Container, Vessel, Filter], FilterType -> Centrifuge, MaxVolume -> GreaterP[resolvedVolume]}], <||>], Object, Null],
								{AirPressure, Robotic}, Lookup[FirstCase[allFilterPackets, KeyValuePattern[{Type -> Model[Container, Plate, Filter], MaxVolume -> GreaterP[resolvedVolume]}], <||>], Object, Null]
							] (* Couldn't find one, so pick a dummy one *)
					];

					(* If there the sample is already in the filter, then that's the filter to actually use. otherwise use the vetted *)
					filter = If[MatchQ[preResolvedFilter, Automatic],
						vettedFilter,
						preResolvedFilter
					] /. equivalentFilterLookup;

					(* Get the packet for the model of this filter  *)
					filterModelPacket = If[MatchQ[filter, ObjectP[Object]],
						fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, filter, Model], fastAssoc],
						fetchPacketFromFastAssoc[filter, fastAssoc]
					];
					filterModelPacket = If[MatchQ[filterModelPacket, Null],
						<||>,
						filterModelPacket
					];

					(* Determine if we have a sterile filter or not *)
					sterileFilterQ = Lookup[filterModelPacket, Sterile, False];

					(* Now we have the filter. decide if the filter is too large for the tolerance of MPE2 for AirPressure *)
					(* we do not want to transfer stuff into another filter plate on deck as the current filter plate is only too large if provided from the user in RSP. need to hard-error on that *)
					filterAirPressureDimensionsError = If[MatchQ[type, AirPressure],
						!MatchQ[
							Lookup[filterModelPacket, Dimensions],
							semiResolvedInstrumentFilterDimensionPattern
						],
						False
					];

					(* Determine if we are already in the filter or not *)
					alreadyInFilterQ = Or[
						MatchQ[Lookup[samplePacket, Container], ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter], Model[Container, Vessel, Filter], Object[Container, Vessel, Filter]}]] && MatchQ[preResolvedFilter, ObjectP[Lookup[sampleContainerPacket, Object]]],
						MatchQ[fastAssocLookup[fastAssoc, Lookup[samplePacket, Container], Model], ObjectP[phytipColumnModels[]]]
					];

					(* This is for pipetting transfer which is only for Robotic preparation *)
					(* default it to False, if we are doing Manual *)
					transferringToNewFilterQ = Which[
						Not[roboticQ], False,
						Not[MatchQ[unresolvedFilter, Automatic]] && Not[MatchQ[Lookup[samplePacket, Container], ObjectP[unresolvedFilter]]], True,
						alreadyInFilterQ, False,
						True, True
					];

					(* Determine if preResolvedFilter is a plate filter *)
					plateFilterQ = MatchQ[filter, ObjectP[{Object[Container, Plate, Filter], Model[Container, Plate, Filter]}]];

					(* Get the filter type from the unresolved filter *)
					resolvedFilterFilterType = Which[
						MatchQ[filter, ObjectP[Object]],
							fastAssocLookup[fastAssoc, filter, {Model, FilterType}],
						MatchQ[filter, ObjectP[Model]],
							Lookup[fetchPacketFromFastAssoc[filter, fastAssoc], FilterType, Null],
						True,
							Null
					];

					(* Flip an error switch if we're dealing with a Centrifuge filter without DestinationContainerModel populated *)
					centrifugeContainerDestError = And[
						MatchQ[resolvedFilterFilterType, Centrifuge],
						MatchQ[Lookup[filterModelPacket, Object], ObjectP[Model[Container, Vessel, Filter]]],
						Not[MatchQ[Lookup[filterModelPacket, DestinationContainerModel], ObjectP[Model[Container, Vessel]]]]
					];

					(* Get the filter contents *)
					filterContents = If[MatchQ[filter, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, filter, Contents][[All, 2]],
						{}
					];

					(* Figure out what kind of vacuuming we're actually doing *)
					(* If not vacuuming then we're just Null *)
					(* If we're using a plate filter then it's a plate *)
					(* If we're not using a plate but we are using membrane it is a VacuumFlask *)
					(* Otherwise it's a BottleTop *)
					vacuumType = Which[
						Not[MatchQ[type, Vacuum]], Null,
						MatchQ[filter, ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]], Plate,
						MatchQ[Lookup[filterModelPacket, FilterType], Membrane], VacuumFlask,
						True, BottleTop
					];

					(* Determine if we are using a VacuCap filter or a non-VacuCap filter *)
					(* this is if we have a BottleTop filter that is also an Object/Model[Item, Filter] *)
					vacuCapQ = MatchQ[vacuumType, BottleTop] && MatchQ[filter, ObjectP[{Model[Item, Filter], Object[Item, Filter]}]];

					(* Resolve to Cellulose if Automatic and using a Buchner funnel, or PES otherwise for membrane material *)
					membraneMaterial = If[MatchQ[membraneBasedOnFilter, Automatic],
						Lookup[filterModelPacket, MembraneMaterial, Null],
						membraneBasedOnFilter
					];

					(* Resolve PoreSize/MolecularWeightCutoff here; if both are specified or both Null then that's a problem but we will throw an error for it below so flip the error checking variable here  *)
					poreSize = N[
						If[MatchQ[poreSizeBasedOnFilter, Automatic],
							Lookup[filterModelPacket, PoreSize, Null],
							poreSizeBasedOnFilter
						]
					];
					molecularWeightCutoff = N[
						If[MatchQ[molecularWeightCutoffBasedOnFilter, Automatic],
							Lookup[filterModelPacket, MolecularWeightCutoff, Null],
							molecularWeightCutoffBasedOnFilter
						]
					];

					(* Note that this is equivalent to Not[Xor[NullQ[poreSize], NullQ[molecularWeightCutoff]]] but I think what I wrote is less confusing *)
					(* PoreSize and MWCO can't both be null if the filter needs to be resolved, i.e. it is neither specified by the user nor is the sample already in a filter. This will need to be changed in future if we ever resolve to non-size-based plates, e.g. affinity plates.*)
					(* PoreSize and MWCO can't both be specified *)
					poreSizeAndMWCOMismatchQ = Or[
						NullQ[poreSize] && NullQ[molecularWeightCutoff] && !MatchQ[preResolvedFilter, ObjectP[]],
						Not[NullQ[poreSize]] && Not[NullQ[molecularWeightCutoff]]
					];

					(* Resolve the PrefilterMembraneMaterial and PrefilterPoreSize *)
					prefilterMembraneMaterial = If[MatchQ[prefilterMembraneMaterialBasedOnFilter, Automatic],
						Lookup[filterModelPacket, PrefilterMembraneMaterial, Null],
						prefilterMembraneMaterialBasedOnFilter
					];
					prefilterPoreSize = N[
						If[MatchQ[prefilterPoreSizeBasedOnFilter, Automatic],
							Lookup[filterModelPacket, PrefilterPoreSize, Null],
							prefilterPoreSizeBasedOnFilter
						]
					];

					(* PrefilterMembraneMaterial and PrefilterPoreSize must be specified together; one can't be Null without the other one *)
					prefilterOptionMismatchQ = Or[
						NullQ[prefilterMembraneMaterial] && Not[NullQ[prefilterPoreSize]],
						Not[NullQ[prefilterMembraneMaterial]] && NullQ[prefilterPoreSize]
					];

					(* Do one more sets of checks to make sure the resolved FiltrationType option gels with the resolved filter's FilterType *)
					filterTypeMismatchError = Which[
						(* can't use filter plates with peristaltic pumps *)
						plateFilterQ && MatchQ[type, PeristalticPump], True,
						(* can vacuum filter plates fine yes I think? *)
						plateFilterQ && MatchQ[type, Vacuum], False,
						(* it should be fine to use the centrifuge *)
						plateFilterQ && MatchQ[type, Centrifuge], False,
						(* we can't syringe filter plates *)
						plateFilterQ && MatchQ[type, Syringe], True,
						(* it should be fine to use the air-pressure *)
						plateFilterQ && MatchQ[type, AirPressure], False,
						(* If we're dealing with a non-plate filter, just make sure the filter's type match the filtration type *)
						(* membrane filters are ok with peristaltic pumps or vacuum *)
						MatchQ[resolvedFilterFilterType, Membrane] && MatchQ[type, PeristalticPump | Vacuum], False,
						(* bottle top are only vacuum *)
						MatchQ[resolvedFilterFilterType, BottleTop] && MatchQ[type, Vacuum], False,
						(* disk are only syringe *)
						MatchQ[resolvedFilterFilterType, Disk] && MatchQ[type, Syringe], False,
						(* centrifuge are only centrifuge *)
						MatchQ[resolvedFilterFilterType, Centrifuge] && MatchQ[type, Centrifuge], False,
						(* Add any other filter types in here though I don't think there's any other filter types *)
						True, True
					];

					(* Resolve the FilterHousing option; if we're using PeristalticPump or Vacuum then this will be something; otherwise nothing *)
					filterHousing = Which[
						Not[MatchQ[unresolvedFilterHousing, Automatic]], unresolvedFilterHousing,
						MatchQ[type, PeristalticPump] && MatchQ[semiResolvedInstrument, ObjectP[{Model[Instrument, PeristalticPump], Object[Instrument, PeristalticPump]}]], Model[Instrument, FilterHousing, "id:mnk9jORXjM4Z"],(*"Filter Membrane Housing, 142 mm"*)
						(* If doing vacuum and using the plate (i.,e., not the bottle tops) then set to the filter block *)
						MatchQ[type, Vacuum] && MatchQ[vacuumType, Plate], Model[Instrument, FilterBlock, "id:rea9jl1orrGr"],(*"Filter Block"*)
						True, Null
					];

					(* Decide if we're using a Buchner funnel setup or not *)
					(* If doing Vacuum and we're using a membrane filter *)
					buchnerFunnelQ = MatchQ[type, Vacuum] && MatchQ[resolvedFilterFilterType, Membrane] && Not[MatchQ[filterHousing, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]]];

					(* Resolve FilterUntilDrained; automatically True if MaxTime is specified, or if FiltrationType -> PeristalticPump/Vacuum; False otherwise *)
					filterUntilDrained = Which[
						BooleanQ[unresolvedFilterUntilDrained], unresolvedFilterUntilDrained,
						TimeQ[unresolvedMaxTime], True,
						NullQ[unresolvedMaxTime], False,
						MatchQ[type, PeristalticPump | Vacuum], True,
						True, False
					];

					(* Figure out if we have a retentate collection model container *)
					retentateCollectionContainerModelQ = MatchQ[Lookup[filterModelPacket, RetentateCollectionContainerModel], ObjectP[Model[Container, Vessel]]];

					(* Time: if it's set it's set *)
					(* If MaxTime is set then we have to be the lesser of MaxTime and 5 Minutes *)
					(* If we're centrifuging and using a MWCO or concentrator filter, default to 20 minutes *)
					(* If we're centrifuging otherwise, default to 5 minutes *)
					(* Resolving to 5 minutes here for PeristalticPump/Vacuum *)
					time = Which[
						TimeQ[unresolvedTime] && !MatchQ[type, Syringe], unresolvedTime,
						TimeQ[unresolvedMaxTime] && !MatchQ[type, Syringe], Min[unresolvedMaxTime, 5 Minute],
						MatchQ[type, Centrifuge] && (Not[NullQ[molecularWeightCutoff]] || retentateCollectionContainerModelQ), 20 Minute,
						MatchQ[type, Centrifuge], 5 Minute,
						(* For Syringe, estimate how long it takes to push all liquid with the max volume and the flow rate *)
						(* Time can be overwritten in this case if FlowRate is also provided *)
						MatchQ[type, Syringe] && MatchQ[unresolvedFlowRate, Automatic] && TimeQ[unresolvedTime],
							unresolvedTime,
						MatchQ[type, Syringe],
							If[MatchQ[flowRate, GreaterP[0 Milliliter/Minute]] && MatchQ[syringeMaxVolume, VolumeP],
								Round[syringeMaxVolume/flowRate, 1 Minute],
								(* We should already have complained about missing info, default to 5 Minute here *)
								5 Minute
							],
						MatchQ[type, PeristalticPump | Vacuum | AirPressure], 5 Minute,
						True, Null
					];

					(* MaxTime: if it's set it's set *)
					(* If Time is set and FilterUntilDrained -> True, set it to 3 * Time *)
					(* Otherwise Null *)
					maxTime = Which[
						Not[MatchQ[unresolvedMaxTime, Automatic]], unresolvedMaxTime,
						TimeQ[time] && TrueQ[filterUntilDrained], 3 * time,
						True, Null
					];

					(* Also can only set Time for Centrifuge, PeristalticPump, Vacuum *)
					(* in addition to to that, if FilterUntilDrained, can't do Centrifuge with that *)
					(* Syringe can have time since we resolve time for Syringe. People may have run SPInputs to get options and feed the options back to Filter again *)
					incompatibleFilterTimeWithTypeError = Or[
						filterUntilDrained && MatchQ[type, Centrifuge],
						TimeQ[time] && Not[MatchQ[type, PeristalticPump | Centrifuge | Vacuum | Syringe | AirPressure]]
					];

					(* Figure out if the time options are incompatible with each other *)
					(* If FilterUntilDrained is True then Time and MaxTime can't be specified *)
					(* If FilterUntilDrained is False then MaxTime can't be specified *)
					(* If Time and MaxTime are both specified, MaxTime can't be less than Time *)
					incompatibleFilterTimeOptionsError = Or[
						TrueQ[filterUntilDrained] && (NullQ[time] || NullQ[maxTime]),
						Not[TrueQ[filterUntilDrained]] && TimeQ[maxTime],
						TimeQ[time] && TimeQ[maxTime] && maxTime < time
					];

					(* Temperature: for centrifuge allow $AmbientTemperature, or Null for everything else *)
					{temperature, temperatureInvalidError} = Switch[{type, unresolvedTemperature},
						{Centrifuge, Automatic}, {$AmbientTemperature, False},
						{Centrifuge, _}, {unresolvedTemperature, False},
						{_, Automatic|Null}, {Null, False},
						{_, _}, {unresolvedTemperature, True}
					];

					(* Semi-resolve the Sterile option to True or False based on the WorkCell option, or if the filter is Sterile -> True *)
					semiResolvedSterile = Which[
						BooleanQ[unresolvedSterile], unresolvedSterile,
						MatchQ[Lookup[options, WorkCell], bioSTAR | microbioSTAR], True,
						MatchQ[Lookup[options, WorkCell], STAR], False,
						TrueQ[fastAssocLookup[fastAssoc, filterModelPacket, Sterile]], True,
						True, unresolvedSterile
					];

					(* Resolve the collection container option *)
					collectionContainer = Which[
						(* If it's set, it's set *)
						Not[MatchQ[unresolvedCollectionContainer, Automatic]], unresolvedCollectionContainer,
						(* If we're using a Buchner funnel, set this to the PreferredContainer of the indicated volume that works with Buchner funnels *)
						(* allowing $Failed -> Null because we want the messages to still get thrown but don't want to trainwreck everything else *)
						buchnerFunnelQ, PreferredContainer[totalCollectedVolume, VacuumFlask -> True] /. {$Failed -> Null},
						(* If we're not doing Centrifuge or AirPressure otherwise then it's Null *)
						Not[MatchQ[type, Centrifuge] || MatchQ[type, AirPressure] || MatchQ[filterHousing, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]]], Null,
						(* If we're doing Centrifuge in vessels then go with the DestinationContainerModel  *)
						MatchQ[type, Centrifuge] && MatchQ[filter, ObjectP[{Model[Container, Vessel, Filter], Object[Container, Vessel, Filter]}]], Download[Lookup[filterModelPacket, DestinationContainerModel], Object],
						(* is the sample in a filter container that has a Plate footprint? *)
						(* If Sterile is set to True, the collection container should be the Sterile, Nuclease-free plate for centrifuges using robotic preparation because of height restrictions *)
						MatchQ[type, Centrifuge] && roboticQ && MatchQ[semiResolvedSterile, True], Model[Container, Plate, "id:4pO6dMOqKBaX"],(*"96-well flat bottom plate, Sterile, Nuclease-Free"*)
						(* If Sterile is not set to True collection container should be the UV-Star plate for centrifuges using robotic preparation because of height restrictions *)
						MatchQ[type, Centrifuge] && roboticQ, Model[Container, Plate, "id:n0k9mGzRaaBn"],(*"96-well UV-Star Plate"*)
						(* If yes, then set the collection container to be a DWP *)
						(* Note: we distinguish between unique plates later in the ExperimentCentrifuge resource packets function. *)
						MatchQ[sampleContainerModelPacket, PacketP[Model[Container, Plate, Filter]]] && MatchQ[Lookup[sampleContainerModelPacket, Footprint], Plate], Model[Container, Plate, "id:L8kPEjkmLbvW"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
						(* is the Filter a plate and Sterile is set to True? If yes then also set the collection container to be a sterile DWP *)
						MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]] && MatchQ[Lookup[filterModelPacket, Footprint], Plate] && MatchQ[semiResolvedSterile, True], Model[Container, Plate, "id:n0k9mGkwbvG4"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
						(* is the Filter a plate? If yes then set the collection container to be a non-sterile DWP *)
						MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]] && MatchQ[Lookup[filterModelPacket, Footprint], Plate], Model[Container, Plate, "id:L8kPEjkmLbvW"], (*Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
						True, Null
					];

					(* Get the packet for the model of this collection Container. similar logic to filter *)
					collectionContainerModelPacket = If[MatchQ[collectionContainer, ObjectP[Object]],
						fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, collectionContainer, Model], fastAssoc],
						fetchPacketFromFastAssoc[collectionContainer, fastAssoc]
					];
					collectionContainerModelPacket = If[MatchQ[collectionContainerModelPacket, Null],
						<||>,
						collectionContainerModelPacket
					];

					(* If Filter is a plate, collection container must also be a plate *)
					(* If Filter is not a plate, collection container cannot also be a plate *)
					collectionContainerPlateMismatchError = Or[
						(* Plate Case 1 - Filter Plate with non-Plate Collection Container *)
						MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]] && Not[MatchQ[collectionContainer, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]],
						(* Plate Case 2 - Filter Plate with Plate Collection Container but Mismatching positions *)
						(* Note that we should not allow a collection plate with different number of positions as they will not fit *)
						MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]] && MatchQ[collectionContainer, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]] && Not[MatchQ[Lookup[filterModelPacket, NumberOfWells, Null], Lookup[collectionContainerModelPacket, NumberOfWells, Null]]],
						Not[MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]]] && MatchQ[collectionContainer, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]
					];


					(* Use CentrifugeDevices to find what centrifuge to use, if doing centrifuge filtration *)
					(* I don't love calling CentrifugeDevices in this MapThread but I kind of need to have it to resolve the option here; could totally overhaul everything to put it outside the MapThread but having trouble figuring out how to do it *)
					(* also we should be saved by caching/memoization here???*)
					(* also don't call this if we're in a bad error state where the filter is not a container but we've set centrifuge because then it'll trainwreck *)
					possibleCentrifuges = Which[
						MatchQ[type, Centrifuge] && MatchQ[filterModelPacket, ObjectP[Model[Container]]],
							Flatten[CentrifugeDevices[
								Lookup[filterModelPacket, Object],
								Time -> time /. {Null -> Automatic},
								Temperature -> temperature /. {RangeP[24.999 Celsius, 25.001 Celsius] -> Ambient, Null -> Automatic},
								(* Resolve intensity based on what we choose here so can't have it resolved yet *)
								Intensity -> unresolvedIntensity /. {Null -> Automatic},
								CollectionContainer -> collectionContainer,
								WorkCell -> Lookup[options, WorkCell, Automatic],
								Preparation -> resolvedPreparation,
								Cache -> Flatten[{cacheBall, centrifugePackets}],
								Simulation -> updatedSimulation
							]],
						True, {}
					];
					(* Filter the centrifuge based on sterility option *)
					filteredPossibleCentrifuges = Map[
						Module[{instrumentAsepticQ},
							instrumentAsepticQ = fastAssocLookup[fastAssoc, #, AsepticHandling];
							If[
								Or[
									(TrueQ[unresolvedSterile] || sterileFilterQ) && TrueQ[instrumentAsepticQ],
									(MatchQ[unresolvedSterile, False] || Not[sterileFilterQ]) && !TrueQ[instrumentAsepticQ],
									MatchQ[unresolvedSterile, Automatic]
								],
								#,
								Nothing
							]
						]&,
						possibleCentrifuges
					];

					(* In case none are found, we'll pick a random one *)
					backupManualCentrifuge = Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"]; (* Model[Instrument, Centrifuge, "Avanti J-15R"] *)
					backupRoboticCentrifuge = Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]; (* Model[Instrument, Centrifuge, "HiG4"] *)

					(* Now that we know what centrifuge we might be using, update the instrument resolution  *)
					{instrument, badCentrifugeError, noUsableCentrifugeError} = Which[
						(* If user gave an option and we got some objects from CentrifugeDevices.  Let's see if their option is on the list *)
						MatchQ[filteredPossibleCentrifuges, {ObjectP[]..}] && MatchQ[unresolvedInstrument, ObjectP[]] && MemberQ[filteredPossibleCentrifuges, unresolvedInstrumentModel], {unresolvedInstrument, False, False},
						MatchQ[filteredPossibleCentrifuges, {ObjectP[]..}] && MatchQ[unresolvedInstrument, ObjectP[]], {unresolvedInstrument, True, False},
						(* If the user specified not a centrifuge, then take what the user specified *)
						MatchQ[semiResolvedInstrument, _?(And[MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]], MatchQ[#, Except[ObjectP[{Model[Instrument ,Centrifuge], Object[Instrument, Centrifuge]}]]]]&)], {semiResolvedInstrument, False, False},
						(* CentrifugeDevices gave nothing back, and the user didn't provide an option, go with backup and throw no usable centrifuge error *)
						MatchQ[filteredPossibleCentrifuges, {}] && MatchQ[unresolvedInstrument, Automatic] && Not[roboticQ], {backupManualCentrifuge, False, True},
						MatchQ[filteredPossibleCentrifuges, {}] && MatchQ[unresolvedInstrument, Automatic] && roboticQ, {backupRoboticCentrifuge, False, True},

						(* CentrifugeDevices gave nothing back, but the user did provided a centrifuge, so go with the user option and throw a bad user option (and even worse there isn't one we could use) *)
						MatchQ[filteredPossibleCentrifuges, {}] && MatchQ[unresolvedInstrument, ObjectP[]], {unresolvedInstrument, True, True},
						(* If we have Sterile specified then don't pick an instrument that conflicts with that if you can avoid it *)
						(* If we got this far and semiResolvedSterile is still Automatic, prefer to go to the non-sterile version first *)
						MatchQ[filteredPossibleCentrifuges, {ObjectP[]..}] && TrueQ[semiResolvedSterile], {SelectFirst[filteredPossibleCentrifuges, Or[TrueQ[fastAssocLookup[fastAssoc, #, AsepticHandling]], TrueQ[fastAssocLookup[fastAssoc, #, Sterile]]]&, First[filteredPossibleCentrifuges]], False, False},
						MatchQ[filteredPossibleCentrifuges, {ObjectP[]..}] && MatchQ[semiResolvedSterile, False|Automatic], {SelectFirst[filteredPossibleCentrifuges, And[!TrueQ[fastAssocLookup[fastAssoc, #, AsepticHandling]], !TrueQ[fastAssocLookup[fastAssoc, #, Sterile]]]&, First[filteredPossibleCentrifuges]], False, False},

						(* Otherwise we just have to pick something *)
						MatchQ[filteredPossibleCentrifuges, {ObjectP[]..}], {First[filteredPossibleCentrifuges], False, False}
					];

					(* Get the instrument model if it's not one already *)
					instrumentModel = If[MatchQ[instrument, ObjectP[Model[Instrument]]],
						instrument,
						fastAssocLookup[fastAssoc, instrument, Model]
					];

					(* If the instrument is the HiG, or if WorkCell was set to bioSTAR or microbioSTAR, then set sterile to True *)
					(* Otherwise False; open to making this more elaborate going forward, but until I added this it was just always False so this is at least something *)
					sterile = Which[
						BooleanQ[unresolvedSterile], unresolvedSterile,
						TrueQ[fastAssocLookup[fastAssoc, instrumentModel, AsepticHandling]] || TrueQ[fastAssocLookup[fastAssoc, instrumentModel, Sterile]], True,
						MatchQ[Lookup[options, WorkCell], bioSTAR | microbioSTAR], True,
						True, False
					];

					(* Get the max rotation rate if we have a centrifuge *)
					maxRotationRate = If[MatchQ[instrumentModel, ObjectP[Model[Instrument, Centrifuge]]],
						fastAssocLookup[fastAssoc, instrumentModel, MaxRotationRate],
						Null
					];

					(* centrifuge options, these should only be resolved to non-null if FiltrationType is Centrifuge *)
					(* If we're using plate centrifuges, hard coding the lesser of 4000 RPM and 0.95 * MaxRotationRate (hard to exactly say without calling ExperimentCentrifuge directly, which we definitely could do but I don't really want to because it's so slow) *)
					(* we can revisit in the future as necessary *)
					(* for Intensity: if it's set it's set; if not but we're centrifuging, use 0.95 * the max rotation rate of the instrument or 4000 RPM, whichever is less.  Otherwise it's Null *)
					intensity = Which[
						Not[MatchQ[unresolvedIntensity, Automatic]], unresolvedIntensity,
						NullQ[maxRotationRate], Null,
						MatchQ[type, Centrifuge] && MatchQ[filterModelPacket, PacketP[Model[Container, Plate, Filter]]], Min[{0.95 * maxRotationRate, 4000. RPM}],
						MatchQ[type, Centrifuge], Min[{0.95 * maxRotationRate, 4000. RPM}],
						True, Null
					];

					(* Flip the error switch if the intensity is an RPM and above the max rotation rate of the instrument *)
					intensityTooHighError = And[
						MatchQ[type, Centrifuge],
						RPMQ[intensity],
						MatchQ[instrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
						MemberQ[maxRotationRate, LessP[intensity]]
					];

					(* Resolve the pressure from the filters  *)
					pressure = Which[
						Not[MatchQ[unresolvedPressure, Automatic]], unresolvedPressure,
						(* set to Null for manual preparation *)
						Not[roboticQ], Null,
						(* Do 0.9 * MaxPressure of the filter if that's what we're doing *)
						MatchQ[type, AirPressure] && PressureQ[Lookup[filterModelPacket, MaxPressure]], 0.9 * Lookup[filterModelPacket, MaxPressure],
						(* If we don't have a MaxPressure in the objects, default to 40 PSI *)
						MatchQ[type, AirPressure], 40 PSI,
						(* Otherwise it's going to be Null *)
						True, Null
					];

					(* If we are washing retentate and going by pressure, then resolve to the resolved value of the Pressure option *)
					retentateWashPressure = unresolvedRetentateWashPressure /. {Automatic :> If[washRetentate, pressure, Null]};

					(* RetentateCollectionMethod is Resuspend if the other resuspend options are specified, or if we are doing anything besides non-vacucap filtering, buchner funnel, or centrifuge tubes  *)
					(* it's Centrifuge if we're using the special tube filters that need centrifugation to collect *)
					(* If we're collecting otherwise, it's Transfer *)
					(* Otherwise it's Null *)
					retentateCollectionMethod = Which[
						Not[MatchQ[unresolvedRetentateCollectionMethod, Automatic]], unresolvedRetentateCollectionMethod,
						TrueQ[collectRetentate] && (VolumeQ[unresolvedResuspensionVolume] || MatchQ[unresolvedResuspensionBuffer, ObjectP[]] || IntegerQ[unresolvedResuspensionNumberOfMixes]), Resuspend,
						TrueQ[collectRetentate] && Not[Or[
							Not[vacuCapQ] && MatchQ[resolvedFilterFilterType, BottleTop],
							buchnerFunnelQ,
							Not[plateFilterQ] && MatchQ[resolvedFilterFilterType, Centrifuge]
						]], Resuspend,
						TrueQ[collectRetentate] && MatchQ[type, Centrifuge] && retentateCollectionContainerModelQ, Centrifuge,
						TrueQ[collectRetentate], Transfer,
						True, Null
					];

					(* Flip an error switch if RetentateWashPressure or Pressure are specified but FiltrationType is not AirPressure *)
					(* or if Pressure is Null but FiltrationType is AirPressure *)
					typePressureMismatchError = Or[
						MatchQ[type, AirPressure] && NullQ[pressure],
						Not[MatchQ[type, AirPressure]] && (PressureQ[pressure] || MatchQ[retentateWashPressure, ListableP[PressureP]])
					];

					(* Flip an error switch if Pressure or RetentateWashPressure are higher than the MaxPressure of the filter *)
					pressureTooHighError = And[
						MatchQ[type, AirPressure],
						Or[
							TrueQ[pressure > Lookup[filterModelPacket, MaxPressure]],
							AnyTrue[retentateWashPressure, TrueQ[# > Lookup[filterModelPacket, MaxPressure]]&]
						]
					];

					(* If RetentateContainerOut is specified, get the packet and model packet *)
					unresolvedRetentateContainerOutModelPacket = Which[
						MatchQ[unresolvedRetentateContainerOut, ObjectP[Model[Container]]], fetchPacketFromFastAssoc[unresolvedRetentateContainerOut, fastAssoc],
						MatchQ[unresolvedRetentateContainerOut, {_, ObjectP[Model[Container]]}], fetchPacketFromFastAssoc[unresolvedRetentateContainerOut[[2]], fastAssoc],
						MatchQ[unresolvedRetentateContainerOut, ObjectP[Object[Container]]], fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, unresolvedRetentateContainerOut, Model], fastAssoc],
						MatchQ[unresolvedRetentateContainerOut, {_, ObjectP[Object[Container]]}], fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, unresolvedRetentateContainerOut[[2]], Model], fastAssoc],
						True, Null
					];

					(* ResuspensionVolume resolves to the Volume option, or the smaller of the MaxVolume of RetentateContainerOut or the volume of the initial sample *)
					(* Null if not collecting retentate, or if RetentateCollectionMethod is not Resuspend *)
					resuspensionVolume = Which[
						Not[MatchQ[unresolvedResuspensionVolume, Automatic]], unresolvedResuspensionVolume,
						Not[collectRetentate] || Not[MatchQ[retentateCollectionMethod, Resuspend]], Null,
						VolumeQ[resolvedVolume], resolvedVolume,
						MatchQ[unresolvedRetentateContainerOutModelPacket, ObjectP[Model[Container]]], Min[{volume, Lookup[unresolvedRetentateContainerOutModelPacket, MaxVolume]}],
						True, volume
					];

					(* ResuspensionnBuffer defaults to water if we're collecting retentate via resuspension and it's not specified, or Null otherwise *)
					resuspensionBuffer = Which[
						Not[MatchQ[unresolvedResuspensionBuffer, Automatic]], Download[unresolvedResuspensionBuffer, Object],
						TrueQ[collectRetentate] && MatchQ[retentateCollectionMethod, Resuspend], Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
						True, Null
					];

					(* NumberOfResuspensionMixes defaults to 10 if we're collecting retentate and via resuspension *)
					resuspensionNumberOfMixes = Which[
						Not[MatchQ[unresolvedResuspensionNumberOfMixes, Automatic]], unresolvedResuspensionNumberOfMixes,
						TrueQ[collectRetentate] && MatchQ[retentateCollectionMethod, Resuspend], 10,
						True, Null
					];

					(* Get the default DestinationContainerModel of the resolved filter; this might just be Null if this field doesn't exist for the filter type *)
					defaultModelDestinationContainer = Lookup[filterModelPacket, DestinationContainerModel, Null] /. x_Link :> Download[x, Object];

					(* Resolve the ContainerOut for the retentate; this is easy for if we have ResuspensionVolume, and extremely arbitrary if we don't *)
					(* just going to pick a 50mL tube if RetentateCollectionMethod -> Transfer because it seems hard to imagine a case where we're collecting solid and it won't fit in there *)
					(* Note that if we specified the same label for multiple entries then we already know we cannot use a vessel so pick a plate instead *)
					retentateContainerOut = {
						(* this is just the index *)
						Which[
							IntegerQ[FirstOrDefault[unresolvedRetentateContainerOut]], FirstOrDefault[unresolvedRetentateContainerOut],
							Not[collectRetentate], Null,
							Not[MatchQ[unresolvedRetentateContainerLabel, Automatic|Null]], unresolvedRetentateContainerLabel /. retentateContainerLabelReplaceRules,
							True, Automatic
						],
						(* the actual container *)
						Which[
							MatchQ[unresolvedRetentateContainerOut, ObjectP[]], unresolvedRetentateContainerOut,
							MatchQ[unresolvedRetentateContainerOut, {_, ObjectP[]}], unresolvedRetentateContainerOut[[2]],
							Not[collectRetentate], Null,
							(* basically if the label was specified multiple times for different samples we want to put it in a plate and not a vessel *)
							MatchQ[retentateCollectionMethod, Resuspend] && VolumeQ[resuspensionVolume] && StringQ[unresolvedRetentateContainerLabel] && Count[Lookup[mapThreadFriendlyOptions, RetentateContainerLabel], unresolvedRetentateContainerLabel] >= 2,
								PreferredContainer[resuspensionVolume, Type -> Plate],
							MatchQ[retentateCollectionMethod, Resuspend] && VolumeQ[resuspensionVolume], PreferredContainer[resuspensionVolume],
							MatchQ[retentateCollectionMethod, Transfer], PreferredContainer[50 Milliliter],
							MatchQ[retentateCollectionMethod, Centrifuge], defaultModelDestinationContainer,
							(* Should not get here *)
							True, Null
						]
					};

					(* Semi-resolve the RetentateDestinationWell because if it's a plate then keep it as Automatic or what was specified; otherwise set to A1 (unless retentateContainerOut is Null/{Null, Null} in which case also go to Null) *)
					retentateDestinationWell = Which[
						Not[MatchQ[unresolvedRetentateDestinationWell, Automatic]], unresolvedRetentateDestinationWell,
						NullQ[retentateContainerOut], Null,
						Not[MatchQ[retentateContainerOut, {_, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]}]], "A1",
						True, Automatic
					];

					(* Error switch for collect retentate options agreeing with each other *)
					collectRetentateError = Or[
						(* If CollectRetentate -> False, RetentateCollectionMethod, RetentateContainerOut, RetentateDestinationWell, ResuspensionVolume, ResuspensionBuffer, NumberOfResuspensionMixes all need to be Null *)
						Not[collectRetentate] && Not[NullQ[retentateCollectionMethod] || NullQ[retentateContainerOut] || MemberQ[retentateContainerOut, Null] || NullQ[retentateDestinationWell] || NullQ[resuspensionVolume] || NullQ[resuspensionBuffer] || NullQ[resuspensionNumberOfMixes]],
						(* If CollectRetentate -> True, then RetentateCollectionMethod/RetentateContainerOut/RetentateDestinationWell can't be Null *)
						collectRetentate && (NullQ[retentateCollectionMethod] || NullQ[retentateContainerOut] || MemberQ[retentateContainerOut, Null] || NullQ[retentateDestinationWell])
					];

					(* Error switch for if RetentateCollectionMethod is Transfer or Null or Centrifuge but the resuspension options are specified (or it is Resuspend and they are Null) *)
					retentateCollectionMethodError = Or[
						MatchQ[retentateCollectionMethod, Transfer | Null | Centrifuge] && Not[NullQ[resuspensionVolume] && NullQ[resuspensionBuffer] && NullQ[resuspensionNumberOfMixes]],
						MatchQ[retentateCollectionMethod, Resuspend] && (NullQ[resuspensionVolume] || NullQ[resuspensionBuffer] || NullQ[resuspensionNumberOfMixes])
					];

					(* Error switch for if RetentateCollectionMethod is Transfer but filter is not BottleTop (non-VacuCap), Buchner Funnel, or Centrifuge tubes *)
					transferCollectionMethodError = And[
						MatchQ[retentateCollectionMethod, Transfer],
						Not[Or[
							Not[vacuCapQ] && MatchQ[resolvedFilterFilterType, BottleTop],
							buchnerFunnelQ,
							Not[plateFilterQ] && MatchQ[resolvedFilterFilterType, Centrifuge]
						]]
					];

					(* Error switch for if RetentateCollectionMethod is Transfer but RetentateContainerOut is a plate *)
					retentateContainerOutPlateError = And[
						MatchQ[retentateCollectionMethod, Transfer],
						MatchQ[LastOrDefault[retentateContainerOut], ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]
					];

					(* Resolve the RetentateWashDrainTime and RetentateWashCentrifugeIntensity options to mirror what the Time and Intensity options are *)
					(* also do a bunch of error checking on the retentate wash options *)
					{
						retentateWashDrainTimeWithListyNulls,
						retentateWashCentrifugeIntensityWithListyNulls
					} = Transpose[MapThread[
						Function[{washDrainTime, washCentrifugeIntensity},
							Module[{singleDrainTime, singleCentrifugeIntensity},

								(* Resolve wash drain time to the Time option if not set and we're washing *)
								singleDrainTime = Which[
									Not[MatchQ[washDrainTime, Automatic]], washDrainTime,
									Not[TrueQ[washRetentate]], Null,
									True, time
								];

								(* Resolve centrifuge intensity to Intensity option if not set and we're washing *)
								singleCentrifugeIntensity = Which[
									Not[MatchQ[washCentrifugeIntensity, Automatic]], washCentrifugeIntensity,
									Not[TrueQ[washRetentate]], Null,
									True, intensity
								];

								{
									singleDrainTime,
									singleCentrifugeIntensity
								}
							]
						],
						{unresolvedRetentateWashDrainTime, unresolvedRetentateWashCentrifugeIntensity}
					]];

					(* Make the listy nulls into flat nulls so that the command builder works nicely *)
					retentateWashDrainTime = retentateWashDrainTimeWithListyNulls /. {{Null..} :> Null};
					retentateWashCentrifugeIntensity = retentateWashCentrifugeIntensityWithListyNulls /. {{Null..} :> Null};

					(* Resolve the retentate collection container option; this is a hidden option only relevant to centrifuging using the goofy invert-in-new-tube method but whatever *)
					retentateCollectionContainer = Which[
						(* If it's set, it's set *)
						Not[MatchQ[unresolvedRetentateCollectionContainer, Automatic]], unresolvedRetentateCollectionContainer,
						(* If we're doing centrifuge in vessels then go with the RetentateCollectionContainerModel *)
						MatchQ[type, Centrifuge] && MatchQ[filter, ObjectP[{Model[Container, Vessel, Filter], Object[Container, Vessel, Filter]}]], Download[Lookup[filterModelPacket, RetentateCollectionContainerModel], Object],
						(* Otherwise just Null *)
						True, Null
					];

					(* Error switch for RetentateCollectionMethod being Centrifuge but the filter not being a centrifugable-collection-filter *)
					centrifugeCollectionMethodError = MatchQ[retentateCollectionMethod, Centrifuge] && Not[MatchQ[retentateCollectionContainer, ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]]];

					(* Keep a record of the tag if there is one *)
					(* Make sure this is kept in sync with specified labels if possible *)
					filtrateContainerTag = Which[
						IntegerQ[FirstOrDefault[unresolvedFiltrateContainerOut]], FirstOrDefault[unresolvedFiltrateContainerOut],
						Not[MatchQ[unresolvedFiltrateContainerLabel, Automatic]], unresolvedFiltrateContainerLabel /. filtrateContainerLabelReplaceRules,
						True, Automatic
					];
					unTaggedContainer = If[ListQ[unresolvedFiltrateContainerOut],
						Last[unresolvedFiltrateContainerOut],
						unresolvedFiltrateContainerOut
					];

					(* Determine if the WashFlowThrough stuff is going to be in a different container than the Filtrate *)
					(* importantly, this is True if we're not washing retentate  *)
					maybeWashThroughSameAsFiltrateQs = MapThread[
						Function[{singleLabel, singleContainerLabel, singleContainer, singleDestWell, singleStorageCondition},
							Or[
								Not[washRetentate],
								And[
									MatchQ[singleLabel, Automatic | unresolvedFiltrateLabel],
									MatchQ[singleContainerLabel, Automatic | unresolvedFiltrateContainerLabel | unresolvedCollectionContainerLabel],
									MatchQ[singleContainer, Automatic | ObjectP[unTaggedContainer] | ObjectP[collectionContainer]],
									MatchQ[singleDestWell, Automatic | unresolvedFiltrateDestinationWell],
									MatchQ[singleStorageCondition, Automatic | samplesOutStorageCondition]
								]
							]
						],
						{
							unresolvedWashFlowThroughLabel,
							unresolvedWashFlowThroughContainerLabel,
							unresolvedWashFlowThroughContainer,
							unresolvedWashFlowThroughDestinationWell,
							unresolvedWashFlowThroughStorageCondition
						}
					];

					(* Resolve the container out for the filtrate *)
					(* Note that if we specified the same label for multiple entries then we already know we cannot use a vessel so pick a plate instead *)
					filtrateContainerOut = Switch[{type, sterile, unTaggedContainer, instrument, totalCollectedVolume, sampleOut, sampleContainerModelDestination, filterHousing, collectionContainer},
						(* If we have container out, then use the container out option *)
						{_, _, ObjectP[], _, _, _, _, _, _}, unTaggedContainer,
						(* If we have samples out but container out is automatic, use the container of the sample out *)
						{_, _, Automatic, _, _, ObjectP[], _, _, _}, Download[Lookup[fetchPacketFromFastAssoc[sampleOut, fastAssoc], Container], Object],
						(* If the sample is already within the filter top, then the container out is the bottom part object *)
						{_, _, _, _, _, _, ObjectP[], _, _},
							(* If this filter top is part of a kit, take the correct kit component. otherwise, just request a model. *)
							(* Note that this is specifically for kits with only one other thing (these are special filters that always have two things; I guess we could make this even more sensible by checking what kind of kit it is, but I'm not totally sure how to do that so for now just doing this) *)
							If[Length[Lookup[sampleContainerPacket, KitComponents, {}]] == 1,
								Download[First[Lookup[sampleContainerPacket, KitComponents]], Object],
								Download[sampleContainerModelDestination, Object]
							],
						(* normal resolution *)
						{Centrifuge, _, Automatic, _, _, Null, _, _, _},
							(* If we already know wash flow through container is different from the container out then skip other checks *)
							(* If the centrifuge filter has a destination container that can fit everything at once, just default to that before picking something else (assuming it can fit everything) *)
							Which[
								Not[MatchQ[maybeWashThroughSameAsFiltrateQs, {True..}]] && MatchQ[Download[filter, Type], Object[Container, Plate, Filter] | Model[Container, Plate, Filter]] && MatchQ[resolvedPreparation, Robotic],
									PreferredContainer[actualSampleVolume, Sterile -> sterile, Type -> Plate, LiquidHandlerCompatible -> True],
								Not[MatchQ[maybeWashThroughSameAsFiltrateQs, {True..}]] && MatchQ[Download[filter, Type], Object[Container, Plate, Filter] | Model[Container, Plate, Filter]],
									PreferredContainer[actualSampleVolume, Sterile -> sterile, Type -> Plate],
								Not[MatchQ[maybeWashThroughSameAsFiltrateQs, {True..}]],
									PreferredContainer[actualSampleVolume, Sterile -> sterile],
								MatchQ[defaultModelDestinationContainer, ObjectP[Model[Container]]] && fastAssocLookup[fastAssoc, defaultModelDestinationContainer, MaxVolume] >= totalCollectedVolume,
									defaultModelDestinationContainer,
								MatchQ[collectionContainer, ObjectP[Model[Container]]] && fastAssocLookup[fastAssoc, collectionContainer, MaxVolume] >= totalCollectedVolume,
									collectionContainer,
								MatchQ[collectionContainer, ObjectP[Object[Container]]] && fastAssocLookup[fastAssoc, collectionContainer, {Model, MaxVolume}] >= totalCollectedVolume,
									collectionContainer,
								(* in this specific case, if we're filtering multiple samples using the same filter plate, we want to make sure we don't transfer the filtrate into a bunch of tubes; just use another plate *)
								MatchQ[Download[filter, Type], Object[Container, Plate, Filter] | Model[Container, Plate, Filter]] && StringQ[unresolvedFiltrateContainerLabel] && Count[Lookup[mapThreadFriendlyOptions, FiltrateContainerLabel], unresolvedFiltrateContainerLabel] >= 2 && MatchQ[resolvedPreparation, Robotic],
									PreferredContainer[totalCollectedVolume, Sterile -> sterile, Type -> Plate, LiquidHandlerCompatible -> True],
								MatchQ[Download[filter, Type], Object[Container, Plate, Filter] | Model[Container, Plate, Filter]] && StringQ[unresolvedFiltrateContainerLabel] && Count[Lookup[mapThreadFriendlyOptions, FiltrateContainerLabel], unresolvedFiltrateContainerLabel] >= 2,
									PreferredContainer[totalCollectedVolume, Sterile -> sterile, Type -> Plate],
								True,
									PreferredContainer[totalCollectedVolume, Sterile -> sterile]
							],
						(* If we have a collection container, just use that as long as it can actually hold it, and if the wash flow through could be the same as the filtrate *)
						{Vacuum, _, Automatic, ObjectP[{Model[Instrument, VacuumPump], Object[Instrument, VacuumPump]}], _, Null, _, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}], ObjectP[]},
							Which[
								Not[MatchQ[maybeWashThroughSameAsFiltrateQs, {True..}]], PreferredContainer[actualSampleVolume, Type -> Plate],
								MatchQ[collectionContainer, ObjectP[Model[Container]]] && fastAssocLookup[fastAssoc, collectionContainer, MaxVolume] >= totalCollectedVolume, collectionContainer,
								MatchQ[collectionContainer, ObjectP[Object[Container]]] && fastAssocLookup[fastAssoc, collectionContainer, {Model, MaxVolume}] >= totalCollectedVolume, collectionContainer,
								True, PreferredContainer[totalCollectedVolume, Type -> Plate]
							],
						{Vacuum, _, Automatic, ObjectP[{Model[Instrument, VacuumPump], Object[Instrument, VacuumPump]}], _, Null, _, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}], _},
							Model[Container, Plate, "id:L8kPEjkmLbvW"],(*"96-well 2mL Deep Well Plate"*)
						(* some bottle top filters come with a container attached, the ones that have container in their type *)
						{Vacuum, _, Automatic, _, _, Null, _, _, _},
							If[MatchQ[Lookup[fetchPacketFromFastAssoc[filter, fastAssoc], FilterType], BottleTop] && MatchQ[filter, ObjectP[{Model[Container, Vessel, Filter]}]] && MatchQ[defaultModelDestinationContainer, ObjectP[]] && fastAssocLookup[fastAssoc, defaultModelDestinationContainer, MaxVolume] >= totalCollectedVolume,
								defaultModelDestinationContainer,
								PreferredContainer[totalCollectedVolume, Sterile -> sterile]
							],
						(* If we have a collection container, just use that *)
						{AirPressure, _, Automatic, _, _, _, _, _, ObjectP[]},
							collectionContainer,
						{_, _, Automatic, _, _, Null, _, _, _}, PreferredContainer[totalCollectedVolume, Sterile -> sterile],
						{_, _, _, _, _, Null, _, _, _}, unTaggedContainer
					];
					taggedFiltrateContainerOut = {filtrateContainerTag, filtrateContainerOut};

					(* Semi-resolve the FiltrateDestinationWell because if it's a plate then keep it as Automatic or what was specified; otherwise set to A1 *)
					filtrateDestinationWell = Which[
						Not[MatchQ[unresolvedFiltrateDestinationWell, Automatic]], unresolvedFiltrateDestinationWell,
						Not[MatchQ[filtrateContainerOut, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]], "A1",
						(* If our sample is already in a filter plate to start with and we are not switching filter, we need to use the sample position as our filter destination well *)
						MatchQ[Lookup[sampleContainerPacket, Type], Object[Container, Plate, Filter]] && MatchQ[preResolvedFilter, ObjectP[Lookup[sampleContainerPacket, Object]]], Lookup[samplePacket, Position, Null],
						True, Automatic
					];

					(* Get the resolved filter packet *)
					resolvedFilterPacket = fetchPacketFromFastAssoc[filter, fastAssoc];

					(* Get the resolved filter model packet (this might be the same as resolvedFilterPacket *)
					resolvedFilterModelPacket = Which[
						MatchQ[resolvedFilterPacket, ObjectP[Model]],
							resolvedFilterPacket,
						MatchQ[resolvedFilterPacket, ObjectP[Object]],
							fetchPacketFromFastAssoc[Download[Lookup[resolvedFilterPacket, Model], Object], fastAssoc],
						True,
							<||>
					];

					(* Resolve the label options *)
					(* for Sample/ContainerLabel options, automatically resolve to Null *)
					(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
					(* labels if we have duplicates. *)
					sampleLabel = Which[
						Not[MatchQ[unresolvedSampleLabel, Automatic]], unresolvedSampleLabel,
						MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All,2]], Lookup[samplePacket, Object]],
							Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
						True, "filter source " <> StringDrop[Lookup[samplePacket, ID], 3]
					];
					sampleContainerLabel = Which[
						Not[MatchQ[unresolvedSampleContainerLabel, Automatic]], unresolvedSampleContainerLabel,
						MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[sampleContainerPacket, Object]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[sampleContainerPacket, Object]],
						(* In case we have a container-less sample, use sample ID *)
						True, "filter source container " <> StringDrop[Lookup[sampleContainerPacket, ID, Lookup[samplePacket, ID]], 3]
					];

					(* For Filtrate/ContainerLabel, automatically resolve to something; if SampleOutLabel is specified and Target -> Filtrate, resolve to that label *)
					filtrateLabel = Which[
						Not[MatchQ[unresolvedFiltrateLabel, Automatic]], unresolvedFiltrateLabel,
						Not[MatchQ[unresolvedSampleOutLabel, Automatic]] && MatchQ[target, Filtrate], unresolvedSampleOutLabel,
						True, CreateUniqueLabel["filtrate sample"]
					];
					filtrateContainerLabel = Which[
						Not[MatchQ[unresolvedFiltrateContainerLabel, Automatic]], unresolvedFiltrateContainerLabel,
						Not[MatchQ[unresolvedContainerOutLabel, Automatic]] && MatchQ[target, Filtrate], unresolvedContainerOutLabel,
						True, Automatic
					];

					(* For Retentate/ContainerLabel, resolve to something if we are collecting retentate *)
					retentateLabel = Which[
						Not[MatchQ[unresolvedRetentateLabel, Automatic]], unresolvedRetentateLabel,
						Not[MatchQ[unresolvedSampleOutLabel, Automatic]] && MatchQ[target, Retentate], unresolvedSampleOutLabel,
						Not[collectRetentate], Null,
						True, CreateUniqueLabel["retentate sample"]
					];
					retentateContainerLabel = Which[
						Not[MatchQ[unresolvedRetentateContainerLabel, Automatic]], unresolvedRetentateContainerLabel,
						Not[MatchQ[unresolvedContainerOutLabel, Automatic]] && MatchQ[target, Retentate], unresolvedContainerOutLabel,
						Not[collectRetentate], Null,
						True, Automatic
					];

					(* For ResuspensionBuffer/ContainerLabel, resolve to something if we are resuspending *)
					resuspensionBufferLabel = Which[
						Not[MatchQ[unresolvedResuspensionBufferLabel, Automatic]],
							unresolvedResuspensionBufferLabel,
						NullQ[resuspensionBuffer],
							Null,
						MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[resuspensionBuffer, Object]], _String],
							LookupObjectLabel[simulation, Download[resuspensionBuffer, Object]],
						True,
							"resuspension buffer " <> ToString[resuspensionBuffer] <> ToString[Unique[]]
					];
					resuspensionBufferContainerLabel = Which[
						Not[MatchQ[unresolvedResuspensionBufferContainerLabel, Automatic]], unresolvedResuspensionBufferContainerLabel,
						NullQ[resuspensionBuffer], Null,
						NullQ[resuspensionBufferLabel], Null,
						MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, fastAssocLookup[fastAssoc, resuspensionBuffer, Container]], _String],
							LookupObjectLabel[simulation, fastAssocLookup[fastAssoc, resuspensionBuffer, Container]],
						True, ToString[resuspensionBufferLabel] <> " container " <> ToString[Unique[]]
					];

					(* Resolve the retentate wash buffer label and its container.  This is pretty simple; if it was specified go for it; if not just ToString the resolved value *)
					retentateWashBufferLabel = If[NullQ[retentateWashBuffer],
						Null,
						MapThread[
							Which[
								Not[MatchQ[#2, Automatic]], #2,
								NullQ[#1] || NullQ[#2], Null,
								MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[#1, Object]], _String],
									LookupObjectLabel[simulation, Download[#1, Object]],
								True, "retentate buffer " <> ToString[#1] <> ToString[Unique[]]
							]&,
							{
								retentateWashBuffer,
								Replace[unresolvedRetentateWashBufferLabel, x:Except[_List] :> ConstantArray[x, Length[retentateWashBuffer]], {0}]
							}
						]
					];
					retentateWashBufferContainerLabel = If[NullQ[retentateWashBuffer],
						Null,
						MapThread[
							Which[
								Not[MatchQ[#3, Automatic]], #3,
								NullQ[#1] || NullQ[#2] || NullQ[#3], Null,
								MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, fastAssocLookup[fastAssoc, #1, Container]], _String],
									LookupObjectLabel[simulation, fastAssocLookup[fastAssoc, #1, Container]],
								True, #2 <> " container " <> ToString[Unique[]]
							]&,
							{retentateWashBuffer, retentateWashBufferLabel, Replace[unresolvedRetentateWashBufferContainerLabel, x:Except[_List] :> ConstantArray[x, Length[retentateWashBuffer]], {0}]}
						]
					];

					(* For Sample/ContainerOutLabel, resolve to either the rentate or filtrate labels, depending on the Target option *)
					sampleOutLabel = Which[
						Not[MatchQ[unresolvedSampleOutLabel, Automatic]], unresolvedSampleOutLabel,
						MatchQ[target, Filtrate], filtrateLabel,
						MatchQ[target, Retentate], retentateLabel
					];
					containerOutLabel = Which[
						Not[MatchQ[unresolvedContainerOutLabel, Automatic]], unresolvedContainerOutLabel,
						MatchQ[target, Filtrate], filtrateContainerLabel,
						MatchQ[target, Retentate], retentateContainerLabel
					];

					(* Determine if the WashFlowThrough stuff is going to be in a different container than the Filtrate *)
					(* this list of booleans is assuming that we're actually washing the retentate; if we aren't we're going to deal with that below *)
					washThroughSameAsFiltrateQs = MapThread[
						Function[{singleLabel, singleContainerLabel, singleContainer, singleDestWell, singleStorageCondition},
							And[
								MatchQ[singleLabel, Automatic | filtrateLabel],
								MatchQ[singleContainerLabel, Automatic | filtrateContainerLabel],
								MatchQ[singleContainer, Automatic | ObjectP[filtrateContainerOut]],
								MatchQ[singleDestWell, Automatic | filtrateDestinationWell],
								MatchQ[singleStorageCondition, Automatic | samplesOutStorageCondition]
							]
						],
						{
							unresolvedWashFlowThroughLabel,
							unresolvedWashFlowThroughContainerLabel,
							unresolvedWashFlowThroughContainer,
							unresolvedWashFlowThroughDestinationWell,
							unresolvedWashFlowThroughStorageCondition
						}
					];

					(* Resolve the flow through storage condition; this one is easy because it's Null if we're not washing retentate, or if it's Automatic but we are different from the filtrate *)
					washFlowThroughStorageCondition = MapThread[
						Which[
							Not[MatchQ[#1, Automatic]], #1,
							TrueQ[#2] && washRetentate, samplesOutStorageCondition,
							True, Null
						]&,
						{unresolvedWashFlowThroughStorageCondition, washThroughSameAsFiltrateQs}
					];

					(* Resolve the flow through container *)
					(* this is going to be the same container as the filtrateContainerOut if we are washing retentate and the wash through is the same as the filtrate *)
					(* If we are washing but going into a different container than the filtrate, use PreferredContainer, and do a Plate if the filtrate container is a plate (or vessel otherwise) *)
					washFlowThroughContainer = MapThread[
						Function[{specifiedFlowThroughContainer, sameQ, washVolume},
							Which[
								Not[MatchQ[specifiedFlowThroughContainer, Automatic]], specifiedFlowThroughContainer,
								TrueQ[sameQ] && washRetentate, filtrateContainerOut,
								Not[washRetentate], Null,
								MatchQ[filtrateContainerOut, ObjectP[{Object[Container, Plate], Model[Container, Plate]}]], PreferredContainer[washVolume, Type -> Plate],
								True, PreferredContainer[washVolume]
							]
						],
						{unresolvedWashFlowThroughContainer, washThroughSameAsFiltrateQs, totalRetentateWashVolume}
					];

					(* Semi-resolve the WashFlowThroughDestinationWell because if it's a plate then keep it as Automatic or what was specified; otherwise set to what FiltrateDestinationWell is, or A1 *)
					washFlowThroughDestinationWell = MapThread[
						Function[{specifiedFlowThroughDestWell, sameQ, flowThroughContainer},
							Which[
								Not[MatchQ[specifiedFlowThroughDestWell, Automatic]], specifiedFlowThroughDestWell,
								TrueQ[sameQ] && washRetentate, filtrateDestinationWell,
								Not[washRetentate], Null,
								Not[MatchQ[flowThroughContainer, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]]], "A1",
								True, Automatic
							]
						],
						{unresolvedWashFlowThroughDestinationWell, washThroughSameAsFiltrateQs, washFlowThroughContainer}
					];

					(* For WashFlowThrough(Container)Label, automatically resolve to something; if we are the same as the the filtrate then just use that *)
					washFlowThroughLabel = MapThread[
						Function[{specifiedWashFlowThroughLabel, sameQ},
							Which[
								Not[MatchQ[specifiedWashFlowThroughLabel, Automatic]], specifiedWashFlowThroughLabel,
								TrueQ[sameQ] && washRetentate, filtrateLabel,
								Not[washRetentate], Null,
								True, CreateUniqueLabel["wash flow through sample"]
							]
						],
						{unresolvedWashFlowThroughLabel, washThroughSameAsFiltrateQs}
					];
					washFlowThroughContainerLabel = MapThread[
						Function[{specifiedWashFlowThroughContainerLabel, sameQ},
							Which[
								Not[MatchQ[specifiedWashFlowThroughContainerLabel, Automatic]], specifiedWashFlowThroughContainerLabel,
								TrueQ[sameQ] && washRetentate, filtrateContainerLabel,
								Not[washRetentate], Null,
								True, Automatic
							]
						],
						{unresolvedWashFlowThroughContainerLabel, washThroughSameAsFiltrateQs}
					];

					(* For the below MisMatch errors, do not throw the error if we didn't fine available filter. This is to avoid showing them the vetted filter that they didn't specify, with an option they specify *)
					(* Check to make sure the membrane material of the filter membrane matches the option *)
					(* both filter and membrane material were provided by user *)
					filterMembraneMaterialMismatchError = Not[MatchQ[Lookup[resolvedFilterModelPacket, MembraneMaterial], membraneMaterial]]&&!noFilterAvailableError;

					(* Check to make sure the pore size of the filter membrane matches the option *)
					filterPoreSizeMismatchError = Not[MatchQ[Lookup[resolvedFilterModelPacket, PoreSize], poreSize]]&&!noFilterAvailableError;

					(* Check to make sure the pore size of the filter membrane matches the option *)
					filterMolecularWeightMismatchError = Not[MatchQ[Lookup[resolvedFilterModelPacket, MolecularWeightCutoff], molecularWeightCutoff]]&&!noFilterAvailableError;

					(* Make sure if we're not using LuerLock, filters can't be Disk filters *)
					filterInletConnectionTypeMismatchError = MatchQ[Lookup[resolvedFilterModelPacket, {InletConnectionType, FilterType}], {Except[LuerLock], Disk}];

					(* Get the ConnectionType of the Syringe *)
					syringeConnectionType = Switch[syringe,
						ObjectP[Object[Container, Syringe]], fastAssocLookup[fastAssoc, syringe, {Model, ConnectionType}],
						ObjectP[Model[Container, Syringe]], fastAssocLookup[fastAssoc, syringe, ConnectionType],
						_, Null
					];

					(* Make sure the syringe is also a LuerLock *)
					incorrectSyringeConnectionError = Not[NullQ[syringeConnectionType]] && Not[MatchQ[syringeConnectionType, LuerLock]];

					(* TYPE <> INSTRUMENT *)
					(* PeristalticPump <> PeristalticPump | Automatic *)
					(* Centrifuge <> Centrifuge | Automatic *)
					(* Syringe <> SyringePump | Null | Automatic (allowed to be Null for hand-syringing) *)
					(* Vacuum <>  VacuumPump | Automatic *)
					typeAndInstrumentMismatchError = Switch[type,
						PeristalticPump, Not[MatchQ[instrument, ObjectP[{Object[Instrument, PeristalticPump], Model[Instrument, PeristalticPump]}]]],
						Centrifuge, Not[MatchQ[instrument, ObjectP[{Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]}]]],
						Syringe, Not[MatchQ[instrument, Null | ObjectP[{Object[Instrument, SyringePump], Model[Instrument, SyringePump]}]]],
						Vacuum, Not[MatchQ[instrument, ObjectP[{Object[Instrument, VacuumPump], Model[Instrument, VacuumPump]}]]],
						_, False
					];

					(* NOTE: Make sure that if FiltrationType is Syringe that a Syringe isn't set to Null*)
					(* NOTE: Make sure that if Syringe is not Null,that FiltrationType is not set to not Syringe *)
					typeAndSyringeMismatchError = Or[
						MatchQ[type, Syringe] && NullQ[syringe],
						Not[MatchQ[type, Syringe]] && MatchQ[syringe, ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]]
					];

					(* If FiltrationType is PeristalticPump, FilterHousing must not be Null (except when using the bottle top filters or a buchner funnel) *)
					(* If FiltrationType is Centrifuge or Syringe, FilterHousing must not be specified *)
					(* If FiltrationType is Vaccum, FilterHousing must be Null if using a Buchner funnel or bottle top, and can't be Null if using a filter plate *)
					typeAndFilterHousingMismatchError = Or[
						MatchQ[type, PeristalticPump] && Not[MatchQ[filterHousing, ObjectP[{Model[Instrument, FilterHousing], Object[Instrument, FilterHousing]}]]],
						MatchQ[type, Centrifuge | Syringe] && Not[NullQ[filterHousing]],
						MatchQ[type, Vacuum] && ((Not[NullQ[filterHousing]] && MatchQ[vacuumType, VacuumFlask | BottleTop]) || (NullQ[filterHousing] && MatchQ[vacuumType, Plate]))
					];

					(* Make sure that if Sterile -> True and Instrument -> ObjectP[], that the AsepticHandling of the instrument is True *)
					sterileInstrumentMismatchError = Module[{instrumentAsepticQ},
						instrumentAsepticQ = fastAssocLookup[fastAssoc, instrumentModel, AsepticHandling];
						And[
							MatchQ[instrument, ObjectP[]],
							Or[
								(* If sterile -> true, then instrument has to have AsepticHandling of the instrument set to True *)
								And[MatchQ[sterile,True], !TrueQ[instrumentAsepticQ]],
								(* If sterile -> false*, then instrument cannot have AsepticHandling of the instrument set to True (or you might risk contamination) *)
								And[MatchQ[sterile,False], TrueQ[instrumentAsepticQ]]
							]
						]
					];

					(* Make sure that if the FiltrationType is Centrifuge, Intensity is not Null *)
					typeAndCentrifugeIntensityMismatchError = Or[
						MatchQ[type, Centrifuge] && NullQ[intensity],
						Not[MatchQ[type, Centrifuge]] && Not[NullQ[intensity]]
					];

					(* Flip an error switch if RetentateWashCentrifugeIntensity is populated but FiltrationType is not Centrifuge *)
					(* importantly, do NOT flip this switch if typeAndCentrifugeIntensityMismatchError has already been flipped because that error is redundant *)
					retentateWashCentrifugeIntensityTypeError = And[
						Not[MatchQ[type, Centrifuge]],
						Not[NullQ[retentateWashCentrifugeIntensity]],
						Not[typeAndCentrifugeIntensityMismatchError]
					];

					(* Flip an error switch if WashRetentate is True but it's a type that doesn't support washing *)
					washRetentateTypeError = TrueQ[washRetentate] && Not[MatchQ[type, Centrifuge | Vacuum | AirPressure]];

					(* Flip an error switch if any of the retentate wash mix options are turned on but we are not retentate wash mixing (or vice versa) *)
					retentateWashMixError = Or[
						MemberQ[retentateWashMix, True] && NullQ[numberOfRetentateWashMixes],
						Not[MemberQ[retentateWashMix, True]] && Not[NullQ[numberOfRetentateWashMixes]]
					];

					(* Flip an error switch if any of the retentate wash options are Null when RetentateWash is True, or not Null when RetentateWash is False for Manual preparation *)
					(* Flip an error switch if RetentateWashPressure is Null when RetentateWash is True (if we're doing AirPressure), or not Null when RetentateWash is False for Robotic preparation *)
					washRetentateConflictError =If[Not[roboticQ],
						Or[
							TrueQ[washRetentate] && (NullQ[retentateWashBuffer] || NullQ[retentateWashVolume] || NullQ[numberOfRetentateWashes] || NullQ[retentateWashDrainTime]),
							Not[TrueQ[washRetentate]] && (Not[NullQ[retentateWashBuffer]] || Not[NullQ[retentateWashVolume]] || Not[NullQ[numberOfRetentateWashes]] || Not[NullQ[retentateWashDrainTime]] || Not[NullQ[retentateWashCentrifugeIntensity]] || Not[NullQ[numberOfRetentateWashMixes]])
						],
						Or[
							TrueQ[washRetentate] && MatchQ[type, AirPressure] && NullQ[retentateWashPressure],
							Not[TrueQ[washRetentate]] && Not[NullQ[retentateWashPressure]]
						]
					];

					(* Flip an error switch if the ResuspensionVolume is greater than the MaxVolume of the filter *)
					resuspensionVolumeTooHighError = And[
						VolumeQ[resuspensionVolume],
						VolumeQ[Lookup[resolvedFilterModelPacket, MaxVolume]],
						resuspensionVolume > Lookup[resolvedFilterModelPacket, MaxVolume]
					];

					(* If Sterile -> True and FiltrateContainerOut -> ObjectP[], then that object/model is sterile *)
					sterileContainerOutMismatchError = sterile && Not[TrueQ[fastAssocLookup[fastAssoc, filtrateContainerOut, Sterile]]];

					(* Get the MaxVolume of the FiltrateContainerOut *)
					filtrateContainerOutMaxVolume = If[MatchQ[filtrateContainerOut, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, filtrateContainerOut, {Model, MaxVolume}],
						fastAssocLookup[fastAssoc, filtrateContainerOut, MaxVolume]
					];

					(* Get the volume that is going into the FiltrateContainerOut *)
					filtrateContainerOutSampleVolume = actualSampleVolume + Total[MapThread[
						If[washRetentate && TrueQ[#1],
							#2,
							0 Milliliter
						]&,
						{washThroughSameAsFiltrateQs, totalRetentateWashVolume}
					]];

					(* Make sure the MaxVolume of the FiltrateContainerOut is greater than the sample volume + any retentate washes *)
					filtrateContainerOutMaxVolumeError = filtrateContainerOutSampleVolume > 1.06 * filtrateContainerOutMaxVolume;

					(* Make sure the MaxVolume of the CollectionContainer is greater than the sample volume or any retentate washes instance *)
					collectionContainerMaxVolume = Lookup[collectionContainerModelPacket, MaxVolume, Null];
					collectionContainerMaxVolumeError = TrueQ[maxVolumePerCycle > 1.06 * collectionContainerMaxVolume];

					(* Get the MaxVolume of the Syringe *)
					syringeMaxVolume = Switch[syringe,
						ObjectP[Object[Container, Syringe]], fastAssocLookup[fastAssoc, syringe, {Model, MaxVolume}],
						ObjectP[Model[Container, Syringe]], fastAssocLookup[fastAssoc, syringe, MaxVolume],
						_, Null
					];

					(* Make sure the MaxVolume of the Syringe is greater than the sample volume *)
					syringeMaxVolumeError = VolumeQ[syringeMaxVolume] && volume > syringeMaxVolume;

					(* Get whether we have a storage buffer or not *)
					storageBufferQ = TrueQ[Lookup[filterModelPacket, StorageBuffer]];

					(* Resolve the PrewetFilter option; if nothing is set go to False, otherwise True *)
					prewetFilter = Which[
						Not[MatchQ[unresolvedPrewetFilter, Automatic]], unresolvedPrewetFilter,
						(* If it's a filter tha thas a StorageBuffer, then this goes to True *)
						storageBufferQ, True,
						MatchQ[
							{
								unresolvedPrewetFilterTime,
								unresolvedNumberOfFilterPrewettings,
								unresolvedPrewetFilterBufferVolume,
								unresolvedPrewetFilterCentrifugeIntensity,
								unresolvedPrewetFilterBuffer,
								unresolvedPrewetFilterBufferLabel,
								unresolvedPrewetFilterContainerOut,
								unresolvedPrewetFilterContainerLabel
							},
							{(Automatic | Null)..}
						],
							False,
						True, True
					];

					(* Resolve the NumberOfFilterPrewettings *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If the filter has a StorageBuffer then it's 3 *)
					(* Otherwise it's 1 *)
					numberOfFilterPrewettings = Which[
						Not[MatchQ[unresolvedNumberOfFilterPrewettings, Automatic]], unresolvedNumberOfFilterPrewettings,
						Not[prewetFilter], Null,
						storageBufferQ, 3,
						True, 1
					];

					(* Don't let NumberOfFilterPrewettings > 1 for BottleTop or PeristalticPump *)
					numberOfFilterPrewettingsTooHighError = And[
						MatchQ[numberOfFilterPrewettings, GreaterP[1]],
						Or[
							MatchQ[vacuumType, BottleTop],
							MatchQ[type, PeristalticPump]
						]
					];

					(* Don't do prewetting at all if we're doing Syringe or FilterBlock *)
					prewettingTypeMismatchError = And[
						prewetFilter,
						Or[
							MatchQ[type, Syringe],
							MatchQ[vacuumType, Plate]
						]
					];

					(* Resolve the prewetting time *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If we are doing centrifuge it is 5 Minute *)
					(* Otherwise it's Null *)
					prewetFilterTime = Which[
						Not[MatchQ[unresolvedPrewetFilterTime, Automatic]], unresolvedPrewetFilterTime,
						Not[prewetFilter], Null,
						MatchQ[type, Centrifuge], 5 Minute,
						True, Null
					];

					(* Resolve the prewetting buffer volume *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If there is a StorageBuffer in the filter, the StorageBufferVolume of the filter *)
					(* If we've set the PrewetFilterBuffer to a sample, then that sample's volume *)
					(* If we are aliquoting it's 5% of the aliquot amount *)
					(* If we're not aliquoting it's 5% of the input sample's volume *)
					(* If we don't have that then something is wrong so we're just picking Null *)
					prewetFilterBufferVolume = Which[
						Not[MatchQ[unresolvedPrewetFilterBufferVolume, Automatic]], unresolvedPrewetFilterBufferVolume,
						Not[prewetFilter], Null,
						storageBufferQ && VolumeQ[Lookup[filterModelPacket, StorageBufferVolume]], Lookup[filterModelPacket, StorageBufferVolume],
						MatchQ[unresolvedPrewetFilterBuffer, ObjectP[Object[Sample]]], fastAssocLookup[fastAssoc, unresolvedPrewetFilterBuffer, Volume],
						VolumeQ[Lookup[options, AliquotAmount]], 0.05 * Lookup[options, AliquotAmount],
						VolumeQ[Lookup[samplePacket, Volume]], 0.05 * Lookup[samplePacket, Volume],
						True, Null
					];

					(* Resolve the prewetting centrifuge intensity *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If we are centrifuging then it is the same as the resolved centrifuge intensity *)
					(* Otherwise Null *)
					prewetFilterCentrifugeIntensity = Which[
						Not[MatchQ[unresolvedPrewetFilterCentrifugeIntensity, Automatic]], unresolvedPrewetFilterCentrifugeIntensity,
						Not[prewetFilter], Null,
						MatchQ[type, Centrifuge], intensity,
						True, Null
					];

					(* Resolve the prewetting buffer *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If the input sample has the Solvent field populated, it is set to that *)
					(* If the input sample is UsedAsSolvent -> True and the model exists (i.e., is not Null), it is set to the model *)
					(* Otherwise, set to water *)
					prewetFilterBuffer = Which[
						Not[MatchQ[unresolvedPrewetFilterBuffer, Automatic]],
							unresolvedPrewetFilterBuffer,
						Not[prewetFilter],
							Null,
						MatchQ[Lookup[samplePacket, Solvent], ObjectP[Model[Sample]]],
							Download[Lookup[samplePacket, Solvent], Object],
						MatchQ[Lookup[samplePacket, Model], ObjectP[Model[Sample]]] && TrueQ[fastAssocLookup[fastAssoc, Lookup[samplePacket, Object], {Model, UsedAsSolvent}]],
							Download[Lookup[samplePacket, Model], Object],
						True,
							Model[Sample, "Milli-Q water"]
					];

					(* Resolve the container to drain into *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If CollectionContainer is not Null and a Model, then use that model *)
					(* If CollectionContainer is not Null and an Object, then use the model of that object *)
					(* If CollectionContainer is Null and FiltrateContainerOut is a Model, then use that model *)
					(* If CollectionContainer is Null and FiltrateContainerOut is an object, then use the model of that object *)
					(* othewise, Null *)
					prewetFilterContainerOut = Which[
						Not[MatchQ[unresolvedPrewetFilterContainerOut, Automatic]], unresolvedPrewetFilterContainerOut,
						Not[prewetFilter], Null,
						MatchQ[collectionContainer, ObjectP[Model[Container]]], collectionContainer,
						MatchQ[collectionContainer, ObjectP[Object[Container]]], Download[fastAssocLookup[fastAssoc, collectionContainer, Model], Object],
						NullQ[collectionContainer] && MatchQ[filtrateContainerOut, ObjectP[Model[Container]]], filtrateContainerOut,
						NullQ[collectionContainer] && MatchQ[filtrateContainerOut, ObjectP[Object[Container]]], Download[fastAssocLookup[fastAssoc, filtrateContainerOut, Model], Object],
						True, Null
					];

					(* Resolve the label of the prewetting buffer *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* If prewetFilterBuffer is an Object[Sample] that is already labeled, go with that label *)
					(* Otherwise, make a new label *)
					prewetFilterBufferLabel = Which[
						Not[MatchQ[unresolvedPrewetFilterBufferLabel, Automatic]], unresolvedPrewetFilterBufferLabel,
						Not[prewetFilter], Null,
						MatchQ[simulation, SimulationP] && MatchQ[prewetFilterBuffer, ObjectP[Object[Sample]]] && MatchQ[LookupObjectLabel[simulation, Download[prewetFilterBuffer, Object]], _String],
							LookupObjectLabel[simulation, Download[prewetFilterBuffer, Object]],
						True,
							"prewetting buffer " <> ToString[prewetFilterBuffer]
					];

					(* Resolve the label of the container the prewetting will drain to *)
					(* If it's set it's set *)
					(* If we're not prewetting it's Null *)
					(* Otherwise leave as automatic because we'll figure it out at the end *)
					prewetFilterContainerLabel = Which[
						Not[MatchQ[unresolvedPrewetFilterContainerLabel, Automatic]], unresolvedPrewetFilterContainerLabel,
						Not[prewetFilter], Null,
						True, Automatic
					];

					(* Flip an error switch if PrewetFilter -> True and any of the other options are Null, or if PrewetFilter -> False and any option isn't Null *)
					(* Note that PrewetFilterTime and PrewetFilterCentrifugeIntensity can be Null with PrewetFilter being True, though it can't be specified if PrewetFilter is False *)
					prewetFilterMismatchError = Or[
						prewetFilter && MemberQ[
							{
								prewetFilterBufferVolume,
								prewetFilterBuffer,
								prewetFilterBufferLabel,
								prewetFilterContainerOut,
								prewetFilterContainerLabel,
								numberOfFilterPrewettings
							},
							Null
						],
						Not[prewetFilter] && Not[MatchQ[
							{
								prewetFilterTime,
								prewetFilterBufferVolume,
								prewetFilterCentrifugeIntensity,
								prewetFilterBuffer,
								prewetFilterBufferLabel,
								prewetFilterContainerOut,
								prewetFilterContainerLabel,
								numberOfFilterPrewettings
							},
							{(Automatic | Null) ..}
						]]
					];

					(* Flip an error switch if PrewetFilterCentrifugeIntensity is populated but FiltrationType is not Centrifuge *)
					(* importantly, do NOT flip this switch if typeAndCentrifugeIntensityMismatchError or retentateWashCentrifugeIntensityTypeError have already been flipped because that error is redundant *)
					prewetFilterCentrifugeIntensityTypeError = And[
						Not[MatchQ[type, Centrifuge]],
						Not[NullQ[prewetFilterCentrifugeIntensity]],
						Not[typeAndCentrifugeIntensityMismatchError],
						Not[retentateWashCentrifugeIntensityTypeError]
					];

					(* check to make sure that the volume of the sample is less then the max volume of the filter, If it has storage buffer in it account for the storage buffer *)
					(* only worry about storage buffer if we're not getting rid fo it during the Prewetting step *)
					filterMaxVolumeMismatchError = And[
						VolumeQ[Lookup[resolvedFilterModelPacket, MaxVolume]],
						Or[
							Not[prewetFilter] && Not[maxVolumePerCycle <= (Lookup[resolvedFilterModelPacket, MaxVolume]-If[VolumeQ[Lookup[resolvedFilterModelPacket, StorageBufferVolume]],Lookup[resolvedFilterModelPacket, StorageBufferVolume],0 Milliliter])],
							Not[maxVolumePerCycle <= Lookup[resolvedFilterModelPacket, MaxVolume]]
						]
					];

					{
						(*1*)type,
						(*2*)instrument,
						(*3*)syringe,
						(*4*)flowRate,
						(*5*)poreSize,
						(*6*)molecularWeightCutoff,
						(*7*)prefilterPoreSize,
						(*8*)membraneMaterial,
						(*9*)prefilterMembraneMaterial,
						(*10*)filter,
						(*11*)filterHousing,
						(*12*)taggedFiltrateContainerOut,
						(*13*)filtrateDestinationWell,
						(*14*)sampleOut,
						(*15*)samplesOutStorageCondition,
						(*16*)intensity,
						(*17*)time,
						(*18*)filterUntilDrained,
						(*19*)maxTime,
						(*20*)temperature,
						(*21*)sterile,
						(*22*)collectionContainer,
						(*23*)retentateCollectionContainer,
						(*24*)collectRetentate,
						(*25*)washRetentate,
						(*26*)retentateWashMix/. {{Null..} :> Null},
						(*27*)retentateCollectionMethod,
						(*28*)resuspensionVolume,
						(*29*)resuspensionBuffer,
						(*30*)resuspensionNumberOfMixes,
						(*31*)retentateContainerOut,
						(*32*)retentateDestinationWell,
						(*33*)retentateWashBuffer,
						(*34*)retentateWashVolume,
						(*35*)numberOfRetentateWashes,
						(*36*)retentateWashDrainTime,
						(*37*)retentateWashCentrifugeIntensity,
						(*38*)numberOfRetentateWashMixes,
						(*39*)sampleLabel,
						(*40*)sampleContainerLabel,
						(*41*)filtrateLabel,
						(*42*)filtrateContainerLabel,
						(*43*)retentateLabel,
						(*44*)retentateContainerLabel,
						(*45*)sampleOutLabel,
						(*46*)containerOutLabel,
						(*47*)resuspensionBufferLabel,
						(*48*)resuspensionBufferContainerLabel,
						(*49*)retentateWashBufferLabel,
						(*50*)retentateWashBufferContainerLabel,
						(*51*)filtrateContainerOutMaxVolume,
						(*52*)syringeMaxVolume,
						(*53*)syringeConnectionType,
						(*54*)pressure,
						(*55*)retentateWashPressure,
						(*56*)filterTypeMismatchError,
						(*57*)filterMembraneMaterialMismatchError,
						(*58*)filterPoreSizeMismatchError,
						(*59*)noFilterAvailableError,
						(*60*)filterMaxVolumeMismatchError,
						(*61*)filterInletConnectionTypeMismatchError,
						(*62*)badCentrifugeError,
						(*63*)noUsableCentrifugeError,
						(*64*)typeAndInstrumentMismatchError,
						(*65*)typeAndSyringeMismatchError,
						(*66*)collectRetentateError,
						(*67*)retentateCollectionMethodError,
						(*68*)transferCollectionMethodError,
						(*69*)poreSizeAndMWCOMismatchQ,
						(*70*)prefilterOptionMismatchQ,
						(*71*)filterMolecularWeightMismatchError,
						(*72*)incompatibleFilterTimeWithTypeError,
						(*73*)incompatibleFilterTimeOptionsError,
						(*74*)typeAndFilterHousingMismatchError,
						(*75*)sterileInstrumentMismatchError,
						(*76*)typeAndCentrifugeIntensityMismatchError,
						(*77*)sterileContainerOutMismatchError,
						(*78*)filtrateContainerOutMaxVolumeError,
						(*79*)syringeMaxVolumeError,
						(*80*)incorrectSyringeConnectionError,
						(*81*)temperatureInvalidError,
						(*82*)retentateWashCentrifugeIntensityTypeError,
						(*83*)washRetentateTypeError,
						(*84*)retentateWashMixError,
						(*85*)washRetentateConflictError,
						(*86*)resuspensionVolumeTooHighError,
						(*87*)flowRateNullError,
						(*88*)centrifugeContainerDestError,
						(*89*)centrifugeCollectionMethodError,
						(*90*)retentateContainerOutPlateError,
						(*91*)intensityTooHighError,
						(*92*)typePressureMismatchError,
						(*93*)pressureTooHighError,
						(*94*)transferringToNewFilterQ,
						(*95*)resolvedVolume,
						(*96*)prewetFilter,
						(*97*)prewetFilterTime,
						(*98*)prewetFilterBufferVolume,
						(*99*)prewetFilterCentrifugeIntensity,
						(*100*)prewetFilterBuffer,
						(*101*)prewetFilterBufferLabel,
						(*102*)prewetFilterContainerOut,
						(*103*)prewetFilterContainerLabel,
						(*104*)prewetFilterMismatchError,
						(*105*)prewetFilterCentrifugeIntensityTypeError,
						(*106*)washFlowThroughStorageCondition/. {{Null..} :> Null},
						(*107*)washFlowThroughContainer/. {{Null..} :> Null},
						(*108*)washFlowThroughDestinationWell/. {{Null..} :> Null},
						(*109*)washFlowThroughLabel/. {{Null..} :> Null},
						(*110*)washFlowThroughContainerLabel/. {{Null..} :> Null},
						(*111*)washThroughSameAsFiltrateQs,
						(*112*)collectionContainerPlateMismatchError,
						(*113*)filterStorageCondition,
						(*114*)collectOccludingRetentate,
						(*115*)occludingRetentateContainer,
						(*116*)occludingRetentateDestinationWell,
						(*117*)occludingRetentateMismatchError,
						(*118*)occludingRetentateNotSupportedError,
						(*119*)filterAirPressureDimensionsError,
						(*120*)numberOfFilterPrewettings,
						(*121*)numberOfFilterPrewettingsTooHighError,
						(*122*)prewettingTypeMismatchError,
						(*123*)collectionContainerMaxVolumeError,
						(*124*)collectionContainerMaxVolume
					}

				]
			],
			{samplePackets, sampleVolumes, mapThreadFriendlyOptions, sampleContainerPackets, sampleContainerModelPackets}
		]
	];

	(* figure out the work cell after the resolution here *)
	(* If we are doing a centrifugal filtration, use the centrifuge workcell resolver *)
	allowedWorkCells = If[roboticQ,
		resolveExperimentFilterWorkCell[
			Null,
			ReplaceRule[
				myOptions,
				{
					Instrument -> resolvedInstrument,
					FiltrationType -> resolvedFiltrationType,
					Intensity -> resolvedIntensity,
					PrewetFilterCentrifugeIntensity -> resolvedPrewetFilterCentrifugeIntensity,
					RetentateWashCentrifugeIntensity -> resolvedRetentateWashCentrifugeIntensity,
					Cache -> cacheBall,
					Output -> Result
				}
			]
		],
		{STAR}
	];

	(* Use the centrifuge resolver to pick a workcell. We might need to do bioSTAR if we need to spin too fast or something; if Preparation->Robotic. *)
	resolvedWorkCell = Which[
		(* Choose user selected workcell if the user selected one *)
		MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]], Lookup[myOptions, WorkCell],
		(* If we are doing the protocol by hand, then there is no robotic workcell *)
		Not[roboticQ], Null,
		(* If there's only one allowed WorkCell, use that one. *)
		EqualQ[Length[allowedWorkCells], 1], First[allowedWorkCells],
		(* If we're still not sure, take the first acceptable work cell based on the sample properties. *)
		(* Set STAR to the default just in case we don't end up with any overlap here. *)
		True, First[UnsortedIntersection[allowedWorkCells, workCellsBySampleProperties], STAR]
	];

	(* Final Label Processing to use the same source for same buffers *)
	(* This is done for ResuspensionBuffer, RetentateWashingBuffer and PrewetFilterBuffer *)
	(* If the sample label and container label are automatically resolved, share the same model of buffer, merge them together to use the same label as the first one. In resource packets, we will find samples with the same buffer AND model and combine their resources together *)
	(* Step 1 - Establish a Rule to point from model to labels *)
	resuspensionBufferLabelGrouping=Merge[
		MapThread[
			Function[
				{options,resuspensionBuffer,resuspensionBufferLabel,resuspensionBufferContainerLabel},
				If[MatchQ[Lookup[options,ResuspensionBufferLabel],Automatic]&&MatchQ[Lookup[options,ResuspensionBufferContainerLabel],Automatic]&&MatchQ[resuspensionBuffer,ObjectP[Model[Sample]]],
					{Lookup[options,ResuspensionBufferLabel],Lookup[options,ResuspensionBufferContainerLabel],resuspensionBuffer} -> {resuspensionBufferLabel,resuspensionBufferContainerLabel},
					Nothing
				]
			],
			{
				mapThreadFriendlyOptions,
				resolvedResuspensionBuffer,
				resolvedResuspensionBufferLabel,
				resolvedResuspensionBufferContainerLabel
			}
		],
		First
	];

	retentateWashingBufferLabelGrouping=Merge[
		Flatten@MapThread[
			Function[
				{options,retentateWashBuffer,retentateWashBufferLabel,retentateWashBufferContainerLabel},
				If[MatchQ[Lookup[options,RetentateWashBufferLabel],ListableP[Automatic]]&&MatchQ[Lookup[options,RetentateWashBufferContainerLabel],ListableP[Automatic]]&&MatchQ[retentateWashBuffer,ListableP[ObjectP[Model[Sample]]]],
					MapThread[
						({Automatic,Automatic,#1} -> {#2,#3})&,
						{
							ToList[retentateWashBuffer],
							ToList[retentateWashBufferLabel],
							ToList[retentateWashBufferContainerLabel]
						}
					],
					Nothing
				]
			],
			{
				mapThreadFriendlyOptions,
				resolvedRetentateWashBuffer,
				resolvedRetentateWashBufferLabel,
				resolvedRetentateWashBufferContainerLabel
			}
		],
		First
	];

	prewetFilterBufferLabelGrouping=Merge[
		MapThread[
			Function[
				{options,prewetFilterBuffer,prewetFilterBufferLabel},
				If[MatchQ[Lookup[options,PrewetFilterBufferLabel],Automatic]&&MatchQ[prewetFilterBuffer,ObjectP[Model[Sample]]],
					{Lookup[options,PrewetFilterBufferLabel],prewetFilterBuffer} -> prewetFilterBufferLabel,
					Nothing
				]
			],
			{
				mapThreadFriendlyOptions,
				resolvedPrewetFilterBuffer,
				resolvedPrewetFilterBufferLabel
			}
		],
		First
	];


	(* Step 2 - Replace the same model with the same labels *)
	{
		finalResolvedResuspensionBufferLabel,
		finalResolvedResuspensionBufferContainerLabel,
		finalResolvedRetentateWashBufferLabel,
		finalResolvedRetentateWashBufferContainerLabel,
		finalResolvedPrewetFilterBufferLabel
	}=Transpose[
		MapThread[
			Function[
				{options,resuspensionBuffer,resuspensionBufferLabel,resuspensionBufferContainerLabel,retentateWashBuffer,retentateWashBufferLabel,retentateWashBufferContainerLabel,prewetFilterBuffer,prewetFilterBufferLabel},
				(* If the combination of the label + buffer is in our rule, look up to get the merged label. If not, keep the resolved label *)
				Join[
					If[MemberQ[Keys[resuspensionBufferLabelGrouping],{Lookup[options,ResuspensionBufferLabel],Lookup[options,ResuspensionBufferContainerLabel],resuspensionBuffer}],
						Lookup[resuspensionBufferLabelGrouping,Key[{Lookup[options,ResuspensionBufferLabel],Lookup[options,ResuspensionBufferContainerLabel],resuspensionBuffer}]],
						{resuspensionBufferLabel,resuspensionBufferContainerLabel}
					],
					If[MatchQ[retentateWashBuffer,_List],
						Transpose@MapThread[
							If[MemberQ[Keys[retentateWashingBufferLabelGrouping],{Automatic,Automatic,#1}],
								Lookup[retentateWashingBufferLabelGrouping,Key[{Automatic,Automatic,#1}]],
								{#2,#3}
							]&,
							{
								retentateWashBuffer,
								retentateWashBufferLabel,
								retentateWashBufferContainerLabel
							}
						],
						If[MemberQ[Keys[retentateWashingBufferLabelGrouping],{Lookup[options,RetentateWashBufferLabel],Lookup[options,RetentateWashBufferContainerLabel],retentateWashBuffer}],
							Lookup[retentateWashingBufferLabelGrouping,Key[{Lookup[options,RetentateWashBufferLabel],Lookup[options,RetentateWashBufferContainerLabel],retentateWashBuffer}]],
							{retentateWashBufferLabel,retentateWashBufferContainerLabel}
						]
					],
					ToList[
						If[MemberQ[Keys[prewetFilterBufferLabelGrouping],{Lookup[options,PrewetFilterBufferLabel],prewetFilterBuffer}],
							Lookup[prewetFilterBufferLabelGrouping,Key[{Lookup[options,PrewetFilterBufferLabel],prewetFilterBuffer}]],
							prewetFilterBufferLabel
						]
					]
				]
			],
			{
				mapThreadFriendlyOptions,
				resolvedResuspensionBuffer,
				resolvedResuspensionBufferLabel,
				resolvedResuspensionBufferContainerLabel,
				resolvedRetentateWashBuffer,
				resolvedRetentateWashBufferLabel,
				resolvedRetentateWashBufferContainerLabel,
				resolvedPrewetFilterBuffer,
				resolvedPrewetFilterBufferLabel
			}
		]
	];

	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[unresolvedEmail, Automatic],
		unresolvedEmail,
		upload && MemberQ[output, Result]
	];

	(* Resolve the operator option *)
	resolvedOperator = If[NullQ[unresolvedOperator], $BaselineOperator, unresolvedOperator];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* do the relevant CompatibleMaterialsQ checks *)
	(* for this, we need to MapThread over the samples, instrument, and filter housing *)
	(* we can MapThread; inside it uses the cache/fastAssoc if it can (which it should be able to) *)
	{allComptibleMaterialsBools, allCompatibleMaterialsTests} = If[gatherTests,
		Transpose[MapThread[
			Function[{sample, instrument, filterHousing},
				CompatibleMaterialsQ[
					Cases[Flatten[{instrument, filterHousing}], ObjectP[]],
					sample,
					Output -> {Result, Tests},
					Cache -> cacheBall,
					Simulation -> updatedSimulation
				]
			],
			{myInputSamples, resolvedInstrument, resolvedFilterHousing}
		]],
		{
			MapThread[
				Function[{sample, instrument, filterHousing},
					CompatibleMaterialsQ[
						Cases[Flatten[{instrument, filterHousing}], ObjectP[]],
						sample,
						Output -> Result,
						Cache -> cacheBall,
						Simulation -> updatedSimulation
					]
				],
				{myInputSamples, resolvedInstrument, resolvedFilterHousing}
			],
			{}
		}
	];


	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool = StringQ[unresolvedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, Filter], unresolvedName]]];

	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list if invalid options later *)
	nameInvalidOption = If[nameInvalidBool && messages,
		(
			Message[Error::DuplicateName, Object[Protocol, Filter]];
			{Name}
		),
		{}
	];
	nameInvalidTest = If[gatherTests,
		Test["The specified Name is unique:", False, nameInvalidBool],
		Nothing
	];

	(* Get the variables that have mismatches between type and instrument *)
	instrumentMismatchTypes = PickList[resolvedFiltrationType, typeAndInstrumentMismatchErrors, True];
	instrumentMismatchInstruments = PickList[resolvedInstrument, typeAndInstrumentMismatchErrors, True];
	instrumentMismatchSamples = PickList[simulatedSamples, typeAndInstrumentMismatchErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeInstrumentInvalidOptions = If[MemberQ[typeAndInstrumentMismatchErrors, True] && messages,
		(
			Message[Error::FiltrationTypeAndInstrumentMismatch, instrumentMismatchTypes, instrumentMismatchInstruments, ObjectToString[instrumentMismatchSamples, Cache -> cacheBall]];
			{Type, Instrument}
		),
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	typeInstrumentTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = If[MatchQ[instrumentMismatchSamples, {}], {}, instrumentMismatchSamples];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The options Instrument and FiltrationType match, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The options Instrument and FiltrationType match, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the variables that have mismatches between type and instrument *)
	syringeMismatchTypes = PickList[resolvedFiltrationType, typeAndSyringeMismatchErrors, True];
	syringeMismatchSyringes = PickList[resolvedSyringe, typeAndSyringeMismatchErrors, True];
	syringeMismatchSamples = PickList[simulatedSamples, typeAndSyringeMismatchErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeAndSyringeInvalidOptions = If[Length[syringeMismatchTypes] > 0 && messages,
		(
			Message[Error::FiltrationTypeAndSyringeMismatch, syringeMismatchTypes, syringeMismatchSyringes, ObjectToString[syringeMismatchSamples, Cache -> cacheBall]];
			{FiltrationType, Syringe}
		),
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	typeAndSyringeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = If[MatchQ[syringeMismatchTypes, {}], {}, syringeMismatchSamples];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The options Syringe and FiltrationType match, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The options Syringe and FiltrationType match, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the variables that have mismatches between type and instrument *)
	filterHousingMismatchTypes = PickList[resolvedFiltrationType, typeAndFilterHousingMismatchErrors, True];
	filterHousingMismatchSyringes = PickList[resolvedFilterHousing, typeAndFilterHousingMismatchErrors, True];
	filterHousingMismatchSamples = PickList[simulatedSamples, typeAndFilterHousingMismatchErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	filterHousingMismatchOptions = If[Length[filterHousingMismatchTypes] > 0 && messages,
		(
			Message[Error::FiltrationTypeAndFilterHousingMismatch, filterHousingMismatchTypes, filterHousingMismatchSyringes, ObjectToString[filterHousingMismatchSamples, Cache -> cacheBall]];
			{FiltrationType, FilterHousing}
		),
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	filterHousingMismatchTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = If[MatchQ[filterHousingMismatchSamples, {}], {}, filterHousingMismatchSamples];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The options FilterHousing and FiltrationType match, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The options FilterHousing and FiltrationType match, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the variables that have mismatches between type and instrument *)
	sterileInstrumentMismatchTypes = PickList[resolvedInstrument, sterileInstrumentMismatchErrors, True];
	sterileInstrumentMismatchSterile = PickList[resolvedSterile, sterileInstrumentMismatchErrors, True];
	sterileInstrumentMismatchSamples = PickList[simulatedSamples, sterileInstrumentMismatchErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	sterileInstrumentMismatchOptions = If[Length[sterileInstrumentMismatchTypes] > 0 && messages,
		(
			Message[Error::SterileOptionMismatch, ObjectToString[sterileInstrumentMismatchTypes, Cache -> cacheBall], sterileInstrumentMismatchSterile, ObjectToString[sterileInstrumentMismatchSamples, Cache -> cacheBall]];
			{Sterile, Instrument}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	sterileInstrumentMismatchTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = If[MatchQ[sterileInstrumentMismatchSamples, {}], {}, sterileInstrumentMismatchSamples];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The AsepticHandling of Instrument, if supplied by the user, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be True if sterile filtration is being performed:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The AsepticHandling of Instrument, if supplied by the user, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be True if sterile filtration is being performed:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* If RetentateWashCentrifugeIntensity is specififed, FiltrationType must be Centrifuge *)
	retentateWashCentrifugeIntensityTypeOptions = If[MemberQ[retentateWashCentrifugeIntensityTypeErrors, True] && messages,
		(
			Message[
				Error::RetentateWashCentrifugeIntensityTypeMismatch,
				PickList[resolvedFiltrationType, retentateWashCentrifugeIntensityTypeErrors],
				PickList[resolvedRetentateWashCentrifugeIntensity, retentateWashCentrifugeIntensityTypeErrors],
				ObjectToString[PickList[simulatedSamples, retentateWashCentrifugeIntensityTypeErrors], Cache -> cacheBall]
			];
			{FiltrationType, RetentateWashCentrifugeIntensity}
		),
		{}
	];
	retentateWashCentrifugeIntensityTypeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, retentateWashCentrifugeIntensityTypeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The RetentateWashCentrifugeIntensity option is specified only if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The RetentateWashCentrifugeIntensity option is specified only if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* If WashRetentate is True but it's a type that doesn't support washing *)
	washRetentateTypeOptions = If[MemberQ[washRetentateTypeErrors, True] && messages,
		(
			Message[
				Error::WashRetentateTypeMismatch,
				PickList[resolvedFiltrationType, washRetentateTypeErrors],
				PickList[resolvedWashRetentate, washRetentateTypeErrors],
				ObjectToString[PickList[simulatedSamples, washRetentateTypeErrors], Cache -> cacheBall]
			];
			{FiltrationType, WashRetentate}
		),
		{}
	];
	washRetentateTypeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, washRetentateTypeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The WashRetentate option is specified only if FiltrationType -> Vacuum | Centrifuge for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The WashRetentate option is specified only if FiltrationType -> Vacuum | Centrifuge for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* If RetentateWashMix is True but the RetentateWashMix options are Null (or False + specified) *)
	retentateWashMixInvalidOptions = If[MemberQ[retentateWashMixErrors, True] && messages,
		(
			Message[
				Error::RetentateWashMixMismatch,
				ObjectToString[PickList[simulatedSamples, retentateWashMixErrors], Cache -> cacheBall]
			];
			{RetentateWashMix, NumberOfRetentateWashes}
		),
		{}
	];
	retentateWashMixInvalidTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, retentateWashMixErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If RetentateWashMix -> True, then NumberOfRetentateWashes are not Null; if RetentateWashMix -> False, these option(s) are not specified for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If RetentateWashMix -> True, then NumberOfRetentateWashes are not Null; if RetentateWashMix -> False, these option(s) are not specified for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* If WashRetentate is True but any of the retentate options are False, or vice versa *)
	(* only bother throwing this message if we didn't already throw the WashRetentateTypeMismatch error since they overlap a lot *)
	retentateWashInvalidOptions = If[MemberQ[washRetentateConflictErrors, True] && Not[MemberQ[washRetentateTypeErrors, True]] && messages,
		(
			Message[
				Error::WashRetentateMismatch,
				ObjectToString[PickList[simulatedSamples, washRetentateConflictErrors], Cache -> cacheBall],
				If[Not[roboticQ],
					{RetentateWashBuffer, RetentateWashVolume, NumberOfRetentateWashes, RetentateWashDrainTime, RetentateWashCentrifugeIntensity, NumberOfRetentateWashMixes},
					{RetentateWashPressure}
				]
			];
			If[Not[roboticQ],
				{WashRetentate, RetentateWashBuffer, RetentateWashVolume, NumberOfRetentateWashes, RetentateWashDrainTime, RetentateWashCentrifugeIntensity, NumberOfRetentateWashMixes},
				{RetentateWashPressure}]
		),
		{}
	];
	retentateWashInvalidTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, washRetentateConflictErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If WashRetentate -> True, then in manual preparation: RetentateWashBuffer, RetentateWashVolume, NumberOfRetentateWashes, RetentateWashDrainTime, RetentateWashCentrifugeIntensity, and NumberOfRetentateWashMixes are not Null; in robotic preparation: RetentateWashPressure cannot be Null when FiltrationType -> AirPressure; if WashRetentate -> False, these options are not specified for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If WashRetentate -> True, then in manual preparation: RetentateWashBuffer, RetentateWashVolume, NumberOfRetentateWashes, RetentateWashDrainTime, RetentateWashCentrifugeIntensity, and NumberOfRetentateWashMixes are not Null; in robotic preparation: RetentateWashPressure cannot be Null when FiltrationType -> AirPressure; if WashRetentate -> False, these options are not specified for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure ResuspensionVolume is not greater than the MaxVolume of the filters *)
	resuspensionVolumeTooHighOptions = If[MemberQ[resuspensionVolumeTooHighErrors, True] && messages,
		(
			Message[
				Error::ResuspensionVolumeTooHigh,
				PickList[resolvedResuspensionVolume, resuspensionVolumeTooHighErrors],
				ObjectToString[PickList[simulatedSamples, resuspensionVolumeTooHighErrors], Cache -> cacheBall],
				ObjectToString[PickList[resolvedFilter, resuspensionVolumeTooHighErrors], Cache -> cacheBall]
			];
			{Filter, ResuspensionVolume}
		),
		{}
	];
	resuspensionVolumeTooHighTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, resuspensionVolumeTooHighErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If specified, ResuspensionVolume is less than the MaxVolume of the filter for inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If specified, ResuspensionVolume is less than the MaxVolume of the filter for inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the variables that have mismatches between type and instrument *)
	typeCentrifugeIntensityMismatchTypes = PickList[resolvedFiltrationType, typeAndCentrifugeIntensityMismatchErrors, True];
	typeCentrifugeIntensityMismatchIntensities = PickList[resolvedIntensity, typeAndCentrifugeIntensityMismatchErrors, True];
	typeCentrifugeIntensityMismatchSamples = PickList[simulatedSamples, typeAndCentrifugeIntensityMismatchErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	typeCentrifugeMismatchOptions = If[Length[typeCentrifugeIntensityMismatchTypes] > 0 && messages,
		(
			Message[
				Error::FiltrationTypeMismatch,
				typeCentrifugeIntensityMismatchTypes,
				typeCentrifugeIntensityMismatchIntensities,
				ObjectToString[typeCentrifugeIntensityMismatchSamples, Cache -> cacheBall],
				Intensity,
				"Centrifuge"
			];
			{FiltrationType, Intensity}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	typeCentrifugeMismatchTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = typeCentrifugeIntensityMismatchSamples;
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The options Intensity and FiltrationType match, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The options Intensity and FiltrationType match, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the variables that have mismatches between type and temperature *)
	typeTemperatureMismatchTypes = PickList[resolvedFiltrationType, temperatureInvalidErrors, True];
	typeTemperatureMismatchIntensities = PickList[resolvedTemperature, temperatureInvalidErrors, True];
	typeTemperatureMismatchSamples = PickList[simulatedSamples, temperatureInvalidErrors, True];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	temperatureInvalidOptions = If[Length[typeTemperatureMismatchTypes] > 0 && messages,
		(
			Message[
				Error::FiltrationTypeMismatch,
				typeTemperatureMismatchTypes,
				typeTemperatureMismatchIntensities,
				ObjectToString[typeTemperatureMismatchSamples, Cache -> cacheBall],
				Temperature,
				"Centrifuge"
			];
			{FiltrationType, Temperature}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	temperatureInvalidTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = typeTemperatureMismatchSamples;
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The Temperature option is only specified if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The Temperature option is only specified if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Get the samples, filtration types, and flow rates for if there is a mismatch between flow rate and type *)
	flowRateMismatchTypes = PickList[resolvedFiltrationType, flowRateNullErrors];
	flowRateMismatchFlowRates = PickList[resolvedFlowRate, flowRateNullErrors];
	flowRateMismatchSamples = PickList[simulatedSamples, flowRateNullErrors];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	flowRateMismatchOptions = If[Length[flowRateMismatchTypes] > 0 && messages,
		(
			Message[
				Error::FiltrationTypeMismatch,
				flowRateMismatchTypes,
				flowRateMismatchFlowRates,
				ObjectToString[flowRateMismatchSamples, Cache -> cacheBall],
				FlowRate,
				"Syringe"
			];
			{FiltrationType, FlowRate}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	flowRateMismatchTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = flowRateMismatchSamples;
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The FlowRate option is only specified if FiltrationType -> Syringe for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The FlowRate option is only specified if FiltrationType -> Syringe for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* error checking for filterAirPressureDimensionsErrors - filter plates being too large for MPE2 AirPressure filtration *)
	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	filterAirPressureDimensionsErrorsOptions = If[MemberQ[filterAirPressureDimensionsErrors, True] && messages,
		Module[{invalidSamples, invalidFilter, airPressureInstrument},
			invalidSamples = PickList[simulatedSamples, filterAirPressureDimensionsErrors];
			invalidFilter = PickList[resolvedFilter, filterAirPressureDimensionsErrors];
			airPressureInstrument = PickList[resolvedInstrument, filterAirPressureDimensionsErrors][[1]];
			Message[
				Error::FilterPlateDimensionsExceeded,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				ObjectToString[invalidFilter, Cache -> cacheBall],
				ObjectToString[airPressureInstrument, Cache -> cacheBall]
			];
			{Filter}
		],
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	filterAirPressureDimensionsErrorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, filterAirPressureDimensionsErrors, True];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The Dimensions of the filter plates(s) used for " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " are within the size limit of the Filter Plate Slot on the AirPressure instrument:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The Dimensions of the filter plates(s) used for " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " are within the size limit of the Filter Plate Slot on the AirPressure instrument:", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];


	(* Make an internal function that throws the FilterOptionMismatch error for different mismatch errors *)
	(* set of checks to make sure that a user specified filter matches any other options they provided *)
	filterOptionMismatchFunction[myMismatchBools:{BooleanP..}, myFieldName_Symbol, myOptionName_Symbol, myComparisonOptionValue:{__}]:=Module[
		{filterMismatchFilters, filterMismatchFieldValues, filterMismatchOptionValue, filterMismatchInvalidOptions,
			filterMismatchInvalidTests},

		(* Get the filters that are mismatched with the given options *)
		filterMismatchFilters = PickList[resolvedFilter, myMismatchBools];

		(* Get the value of the relevant option within the filter *)
		filterMismatchFieldValues = Map[
			Which[
				MatchQ[#, ObjectP[Object]],
					fastAssocLookup[fastAssoc, #, {Model, myFieldName}],
				MatchQ[#, ObjectP[Model]],
					Lookup[fetchPacketFromFastAssoc[#, fastAssoc], myFieldName, {}],
				True,
					Null
			]&,
			filterMismatchFilters
		];

		(* Get the value of the option itself *)
		filterMismatchOptionValue = PickList[myComparisonOptionValue, myMismatchBools];

		(* checks to make sure that the resolved filter matches the specified option *)
		filterMismatchInvalidOptions = If[MemberQ[myMismatchBools, True] && messages,
			(
				Message[
					Error::FilterOptionMismatch,
					myFieldName,
					ObjectToString[filterMismatchFilters, Cache -> cacheBall],
					filterMismatchFieldValues,
					filterMismatchOptionValue,
					myOptionName
				];
				{Filter, myOptionName}
			),
			{}
		];

		(* If we are gathering tests,create a test with the appropriate result. *)
		filterMismatchInvalidTests = If[gatherTests,
			(* We're gathering tests. Create the appropriate tests. *)
			Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
				(* Get the inputs that pass this test. *)
				nonPassingInputs = PickList[simulatedSamples, myMismatchBools, True];
				passingInputs = Complement[simulatedSamples, nonPassingInputs];

				(* Create a test for the passing inputs. *)
				passingInputsTest = If[Length[passingInputs] > 0,
					Test["The options Filter and " <> ToString[myOptionName] <> " match, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
					Nothing
				];

				(* Create a test for the non-passing inputs. *)
				nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
					Test["The options Filter and " <> ToString[myOptionName] <> " match, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
					Nothing
				];

				(* Return our created tests. *)
				{passingInputsTest, nonPassingInputsTest}
			],
			{}
		];

		(* return the options and tests *)
		{filterMismatchInvalidOptions, filterMismatchInvalidTests}
	];

	(* Get the filters that are mismatched with the FiltrationType *)
	{filterTypeMismatchInvalidOptions, filterTypeMismatchInvalidTests} = filterOptionMismatchFunction[
		filterTypeMismatchErrors,
		FilterType,
		FiltrationType,
		resolvedFiltrationType
	];

	(* Get the filters that are mismatched with the membrane material *)
	{filterMaterialMismatchInvalidOptions, filterMaterialMismatchInvalidTests} = filterOptionMismatchFunction[
		filterMembraneMaterialMismatchErrors,
		MembraneMaterial,
		MembraneMaterial,
		resolvedMembraneMaterial
	];

	(* Get the filters that are mismatched with the pore size *)
	{filterPoreSizeMismatchInvalidOptions, filterPoreSizeMismatchInvalidTests} = filterOptionMismatchFunction[
		filterPoreSizeMismatchErrors,
		PoreSize,
		PoreSize,
		resolvedPoreSize
	];

	(* Get the filters that are mismatched with the molecular weight cutoff *)
	{filterMWCOMismatchInvalidOptions, filterMWCOMismatchInvalidTests} = filterOptionMismatchFunction[
		filterMolecularWeightMismatchErrors,
		MolecularWeightCutoff,
		MolecularWeightCutoff,
		resolvedMolecularWeightCutoff
	];


	(* Get the total volume collected for each sample *)
	totalCollectionVolumes = MapThread[
		With[
			{
				sampleVolume = If[VolumeQ[#2],
					#2,
					fastAssocLookup[fastAssoc, #1, Volume]
				],
				(* SameLengthQ is mainly so that if we have an error state already at this point don't trainwreck further *)
				retentateVolume = If[SameLengthQ[#3, #4],
					#3 * #4,
					#3
				]
			},
			Replace[
				Total[Cases[Flatten[{sampleVolume, retentateVolume}], VolumeP]],
				0 -> 0 Milliliter
			]
		]&,
		{simulatedSamples, resolvedVolumes, resolvedRetentateWashVolume, resolvedNumberOfRetentateWashes}
	];

	(* If the volume is above the MaxVolume *)
	filterMaxVolumeMismatchInvalidOptions = If[MemberQ[filterMaxVolumeMismatchErrors, True] && messages,
		Module[{invalidFilters, invalidVolumes},
			invalidFilters = PickList[resolvedFilter, filterMaxVolumeMismatchErrors];
			invalidVolumes = PickList[totalCollectionVolumes, filterMaxVolumeMismatchErrors];
			Message[
				Error::FilterMaxVolume,
				ObjectToString[invalidFilters, Cache -> cacheBall],
				Map[
					If[MatchQ[#, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, #, {Model, MaxVolume}],
						fastAssocLookup[fastAssoc, #, MaxVolume]
					]&,
					invalidFilters
				],
				invalidVolumes
			];
			{Filter}
		],
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	filterMaxVolumeMismatchInvalidTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, filterMaxVolumeMismatchErrors, True];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The MaxVolume of the specified Filters are not less than the volume of the provied sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The MaxVolume of the specified Filters are not less than the volume of the provied sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure LuerLock connections are used *)
	filterInletConnectionTypeMismatchInvalidOptions = If[MemberQ[filterInletConnectionTypeMismatchErrors, True] && messages,
		(
			Message[
				Error::FilterInletConnectionType,
				ObjectToString[PickList[resolvedFilter, filterInletConnectionTypeMismatchErrors], Cache -> cacheBall],
				Lookup[fetchPacketFromFastAssoc[#, fastAssoc], InletConnectionType]& /@ resolvedFilter
			];
			{Filter}
		),
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	filterInletConnectionTypeMismatchInvalidTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, filterInletConnectionTypeMismatchErrors, True];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If doing syringe filtering, LuerLock connections are used for the provided sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If doing syringe filtering, LuerLock connections are used for the provided sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Throw an error if a centrifuge can't be used *)
	badCentrifugeErrorsOptions = If[MemberQ[badCentrifugeErrors, True] && messages,
		Module[{invalidInstruments, invalidSamples, invalidFilter},
			invalidInstruments = PickList[resolvedInstrument, badCentrifugeErrors];
			invalidSamples = PickList[simulatedSamples, badCentrifugeErrors];
			invalidFilter = PickList[resolvedFilter, badCentrifugeErrors];
			Message[
				Error::UnusableCentrifuge,
				ObjectToString[invalidInstruments, Cache -> cacheBall],
				ObjectToString[invalidSamples, Cache -> cacheBall],
				ObjectToString[invalidFilter, Cache -> cacheBall]
			];
			{Instrument, Filter}
		],
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	badCentrifugeErrorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, badCentrifugeErrors, True];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified centrifuges and specified filters are compatible for the provided sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The specified centrifuges and specified filters are compatible for the provided sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Throw an error if there is no useable centrifuge given the constraints specified *)
	noUsableCentrifugeErrorsOptions = If[MemberQ[noUsableCentrifugeErrors, True] && messages,
		Module[{invalidSamples, invalidFilters},
			invalidSamples = PickList[simulatedSamples, noUsableCentrifugeErrors];
			invalidFilters = PickList[resolvedFilter, noUsableCentrifugeErrors];
			Message[
				Error::NoUsableCentrifuge,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				ObjectToString[invalidFilters, Cache -> cacheBall]
			];
			{Instrument}
		],
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	noUsableCentrifugeErrorsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, noUsableCentrifugeErrors, True];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["A centrifuge exists that can centrifuge the provided sample(s) according to the specified conditions " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["A centrifuge exists that can centrifuge the provided sample(s) according to the specified conditions " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Throw an error if CollectRetentate-related options are conflicting *)
	collectRetentateInvalidOptions = If[MemberQ[collectRetentateErrors, True] && messages,
		(
			Message[Error::CollectRetentateMismatch, ObjectToString[PickList[simulatedSamples, collectRetentateErrors], Cache -> cacheBall]];
			{CollectRetentate, RetentateCollectionMethod, RetentateContainerOut, RetentateDestinationWell, ResuspensionVolume, ResuspensionBuffer, NumberOfResuspensionMixes}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	collectRetentateInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, collectRetentateErrors];
			passingInputs = PickList[simulatedSamples, collectRetentateErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must have the retentate collection options unspecified if CollectRetentate -> False, or not set to Null if CollectRetentate -> True.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must have the retentate collection options unspecified if CollectRetentate -> False, or not set to Null if CollectRetentate -> True.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if RetentateCollectionMethod-related options are conflicting *)
	retentateCollectionMethodInvalidOptions = If[MemberQ[retentateCollectionMethodErrors, True] && messages,
		(
			Message[Error::RetentateCollectionMethodMismatch, ObjectToString[PickList[simulatedSamples, retentateCollectionMethodErrors], Cache -> cacheBall]];
			{RetentateCollectionMethod, ResuspensionVolume, ResuspensionBuffer, NumberOfResuspensionMixes}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	retentateCollectionMethodInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, retentateCollectionMethodErrors];
			passingInputs = PickList[simulatedSamples, retentateCollectionMethodErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must have ResuspensionVolume, NumberOfResuspensionMixes, and ResuspensionBuffer unspecified if RetentateCollectionMethod -> Transfer | Null, or not Null if RetentateCollectionMethod -> Resuspend.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must have ResuspensionVolume, NumberOfResuspensionMixes, and ResuspensionBuffer unspecified if RetentateCollectionMethod -> Transfer | Null, or not Null if RetentateCollectionMethod -> Resuspend.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(* Throw an error if RetentateCollectionMethod is Transfer but sample can't be transferred out of the filter that way *)
	transferCollectionMethodInvalidOptions = If[MemberQ[transferCollectionMethodErrors, True] && messages,
		(
			Message[
				Error::RetentateCollectionMethodTransferMismatch,
				ObjectToString[PickList[simulatedSamples, transferCollectionMethodErrors], Cache -> cacheBall]
			];
			{RetentateCollectionMethod, FiltrationType, Filter}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	transferCollectionMethodInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, transferCollectionMethodErrors];
			passingInputs = PickList[simulatedSamples, transferCollectionMethodErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " only have RetentateCollectionMethod if performing filtration via centrifuge tubes, buchner funnel membrane filters, or non-VacuCap BottleTop filters:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " only have RetentateCollectionMethod if performing filtration via centrifuge tubes, buchner funnel membrane filters, or non-VacuCap BottleTop filters:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if RetentateCollectionMethod is Transfer but RetentateContainerOut is a plate *)
	retentateContainerOutPlateInvalidOptions = If[MemberQ[retentateContainerOutPlateErrors, True] && messages,
		(
			Message[
				Error::RetentateCollectionMethodPlateError,
				ObjectToString[PickList[simulatedSamples, retentateContainerOutPlateErrors], Cache -> cacheBall]
			];
			{RetentateCollectionMethod, RetentateContainerOut}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	retentateContainerOutPlateInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, retentateContainerOutPlateErrors];
			passingInputs = PickList[simulatedSamples, retentateContainerOutPlateErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must not have RetentateContainerOut set to a plate model or object if RetentateCollectionMethod -> Transfer:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must not have RetentateContainerOut set to a plate model or object if RetentateCollectionMethod -> Transfer:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if CollectOccludingRetentate is True/False but the other collect occluding retentate options are Null/specified *)
	occludingRetentateMismatchOptions = If[MemberQ[occludingRetentateMismatchErrors, True] && messages,
		(
			Message[Error::OccludingRetentateMismatch, ObjectToString[PickList[simulatedSamples, occludingRetentateMismatchErrors], Cache -> cacheBall]];
			{CollectOccludingRetentate, OccludingRetentateContainer, OccludingRetentateDestionationWell, OccludingRetentateContainerLabel}
		),
		{}
	];
	occludingRetentateMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, occludingRetentateMismatchErrors];
			passingInputs = PickList[simulatedSamples, occludingRetentateMismatchErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must not have CollectOccludingRetentate set to False if the other collect occluding retentate options are specified, and must not have CollectOccludingRetentate set to True if the other collect occluding retentate options are Null:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must not have CollectOccludingRetentate set to False if the other collect occluding retentate options are specified, and must not have CollectOccludingRetentate set to True if the other collect occluding retentate options are Null:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if we're trying to collect the occluding retentate when we're not doing syringe *)
	occludingRetentateNotSupportedOptions = If[MemberQ[occludingRetentateNotSupportedErrors, True] && messages,
		(
			Message[Error::OccludingRetentateNotSupported, ObjectToString[PickList[simulatedSamples, occludingRetentateNotSupportedErrors], Cache -> cacheBall]];
			{CollectOccludingRetentate, FiltrationType}
		),
		{}
	];
	occludingRetentateNotSupportedTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, occludingRetentateNotSupportedErrors];
			passingInputs = PickList[simulatedSamples, occludingRetentateNotSupportedErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must not have CollectOccludingRetentate set to True if Filtration Type is not Syringe:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must not have CollectOccludingRetentate set to True if Filtration Type is not Syringe:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if we're doing Centrifuge filtering in tubes but don't have a collection container *)
	centrifugeContainerDestInvalidOptions = If[MemberQ[centrifugeContainerDestErrors, True] && messages,
		(
			Message[Error::CentrifugeFilterDestinationRequired, ObjectToString[PickList[resolvedFilter, centrifugeContainerDestErrors], Cache -> cacheBall]];
			{Filter}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	centrifugeContainerDestInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[resolvedFilter, centrifugeContainerDestErrors];
			passingInputs = PickList[resolvedFilter, centrifugeContainerDestErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If the following filters are Centrifuge tube filters, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", the DestinationContainerModel field is populated for the filter's model:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If the following filters are Centrifuge tube filters, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", the DestinationContainerModel field is populated for the filter's model:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if RetentateCollectionMethod-related options are conflicting *)
	retentateCollectionContainerInvalidOptions = If[MemberQ[centrifugeCollectionMethodErrors, True] && messages,
		(
			Message[Error::RetentateCollectionContainerMismatch, ObjectToString[PickList[simulatedSamples, centrifugeCollectionMethodErrors], Cache -> cacheBall]];
			{RetentateCollectionMethod, RetentateCollectionContainer}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	retentateCollectionContainerInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, centrifugeCollectionMethodErrors];
			passingInputs = PickList[simulatedSamples, centrifugeCollectionMethodErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", if RetentateCollectionMethod -> Centrifuge, RetentateCollectionContainer must be unspecified, a Model[Container, Vessel], or an Object[ContainerVessel]:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", if RetentateCollectionMethod -> Centrifuge, RetentateCollectionContainer must be unspecified, a Model[Container, Vessel], or an Object[ContainerVessel]:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	poreSizeandMWCOInvalidOptions = If[MemberQ[poreSizeAndMWCOMismatchErrors, True] && messages,
		Message[Error::PoreSizeAndMolecularWeightCutoff,
			PickList[resolvedPoreSize, poreSizeAndMWCOMismatchErrors],
			PickList[resolvedMolecularWeightCutoff, poreSizeAndMWCOMismatchErrors],
			ObjectToString[PickList[simulatedSamples, poreSizeAndMWCOMismatchErrors], Cache -> cacheBall]
		];
		{PoreSize, MolecularWeightCutoff},
		{}
	];

	(* If we are gathering tests,create a test with the appropriate result. *)
	poreSizeandMWCOInvalidTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, poreSizeAndMWCOMismatchErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The options PoreSize and MolecularWeightCutoff cannot be both or, or both specified, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The options PoreSize and MolecularWeightCutoff cannot be both or, or both specified, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " if supplied by the user:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		], {}
	];

	(* If there are invalid options and we are throwing messages,throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	prefilterOptionMismatchInvalidOptions = If[MemberQ[prefilterOptionMismatchErrors, True] && messages,
		Message[Error::PrefilterOptionsMismatch];
		{PrefilterPoreSize, PrefilterMembraneMaterial},
		{}
	];

	prefilterOptionMismatchTests = If[gatherTests,
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, prefilterOptionMismatchErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If specifying a prefilter, neither PrefilterPoreSize nor PrefilterMembraneMaterial for " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " can be set to Null:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If specifying a prefilter, neither PrefilterPoreSize nor PrefilterMembraneMaterial for " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " can be set to Null:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	incompatibleFilterTimeWithTypeOptions = If[MemberQ[incompatibleFilterTimeWithTypeErrors, True] && messages,
		Message[Error::FilterUntilDrainedIncompatibleWithFilterType, ObjectToString[PickList[simulatedSamples, incompatibleFilterTimeWithTypeErrors], Cache -> cacheBall]];
		{FiltrationType, FilterUntilDrained, MaxTime},
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	incompatibleFilterTimeWithTypeTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, incompatibleFilterTimeWithTypeErrors];
			passingInputs = PickList[simulatedSamples, incompatibleFilterTimeWithTypeErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " has Time specified if FiltrationType -> Centrifuge, Vacuum, or PeristalticPump.  Furthermore, it only has FilterUntilDrained -> True if FiltrationType -> Vacuum or PeristalticPump.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has Time specified if FiltrationType -> Centrifuge, Vacuum, or PeristalticPump.  Furthermore, it only has FilterUntilDrained -> True if FiltrationType -> Vacuum or PeristalticPump.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];


	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	incompatibleFilterTimeOptions = If[MemberQ[incompatibleFilterTimeOptionsErrors, True] && messages,
		Message[Error::IncompatibleFilterTimes, ObjectToString[PickList[simulatedSamples, incompatibleFilterTimeOptionsErrors], Cache -> cacheBall]];
		{Time, FilterUntilDrained, MaxTime},
		{}
	];


	(* Create appropriate tests if gathering them, or return {} *)
	incompatibleFilterTimeTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, incompatibleFilterTimeOptionsErrors];
			passingInputs = PickList[simulatedSamples, incompatibleFilterTimeOptionsErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " has Time and MaxTime specified if FilterUntilDrained -> True, and has MaxTime unspecified if FilterUntilDrained -> False.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has Time and MaxTime specified if FilterUntilDrained -> True, and has MaxTime unspecified if FilterUntilDrained -> False.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Get the containers and samples that correspond to the sterile FiltrateContainerOut mismatch error *)
	sterileFiltrateContainerOutErrorSamples = PickList[simulatedSamples, sterileContainerOutMismatchErrors];
	sterileFiltrateContainerOutErrorContainers = PickList[semiResolvedTaggedFiltrateContainerOut[[All, 2]], sterileContainerOutMismatchErrors];

	(* Throw warning if sterile container is recommended but not being used *)
	If[MemberQ[sterileContainerOutMismatchErrors, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::SterileContainerRecommended,
			ObjectToString[sterileFiltrateContainerOutErrorSamples, Cache -> cacheBall],
			ObjectToString[sterileFiltrateContainerOutErrorContainers, Cache -> cacheBall]
		]
	];

	(* Make warning tests if sterile container is recommended but not being used *)
	sterileContainerOutMismatchTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = sterileFiltrateContainerOutErrorSamples;
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The ContainerOut, if supplied by the user, for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be Sterile if sterile filtration is being performed:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Warning["The ContainerOut, if supplied by the user, for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be Sterile if sterile filtration is being performed:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure the filtrate container out can hold all the volume *)
	filtrateContainerOutMaxVolumeOptions = If[MemberQ[filtrateContainerOutMaxVolumeErrors, True] && messages,
		(
			Message[
				Error::VolumeTooLargeForContainerOut,
				PickList[totalCollectionVolumes, filtrateContainerOutMaxVolumeErrors],
				PickList[filtrateContainerOutMaxVolumes, filtrateContainerOutMaxVolumeErrors],
				ObjectToString[PickList[simulatedSamples, filtrateContainerOutMaxVolumeErrors], Cache -> cacheBall]
			];
			{FiltrateContainerOut}
		),
		{}
	];
	filtrateContainerOutMaxVolumeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, filtrateContainerOutMaxVolumeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The MaxVolume of FiltrateContainerOut for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample + any RetentateWashVolumes:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The MaxVolume of FiltrateContainerOut for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample + any RetentateWashVolumes:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure CollectionContainer can hold all the volume *)
	collectionContainerMaxVolumeOptions = If[MemberQ[collectionContainerMaxVolumeErrors, True] && messages,
		(
			Message[
				Error::VolumeTooLargeForCollectionContainer,
				PickList[totalCollectionVolumes, collectionContainerMaxVolumeErrors],
				PickList[collectionContainerMaxVolumes, collectionContainerMaxVolumeErrors],
				ObjectToString[PickList[simulatedSamples, collectionContainerMaxVolumeErrors], Cache -> cacheBall]
			];
			{CollectionContainer}
		),
		{}
	];
	collectionContainerMaxVolumeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, collectionContainerMaxVolumeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The MaxVolume of CollectionContainer for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample + any RetentateWashVolumes:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The MaxVolume of CollectionContainer for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample + any RetentateWashVolumes:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure the syringe out can hold all the volume *)
	syringeMaxVolumeOptions = If[MemberQ[syringeMaxVolumeErrors, True] && messages,
		(
			Message[
				Error::VolumeTooLargeForSyringe,
				PickList[sampleVolumes, syringeMaxVolumeErrors],
				PickList[syringeMaxVolumes, syringeMaxVolumeErrors],
				ObjectToString[PickList[simulatedSamples, syringeMaxVolumeErrors], Cache -> cacheBall]
			];
			{Syringe}
		),
		{}
	];
	syringeMaxVolumeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, syringeMaxVolumeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The MaxVolume of Syringe for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The MaxVolume of Syringe for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be greater then the volume of the sample:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Make sure the Syringe is LuerLock *)
	incorrectSyringeConnectionOptions = If[MemberQ[incorrectSyringeConnectionErrors, True] && messages,
		(
			Message[
				Error::IncorrectSyringeConnection,
				PickList[resolvedSyringe, incorrectSyringeConnectionErrors],
				ObjectToString[PickList[simulatedSamples, incorrectSyringeConnectionErrors], Cache -> cacheBall]
			];
			{Syringe}
		),
		{}
	];
	incorrectSyringeConnectionTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, incorrectSyringeConnectionErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The ConnectionType of Syringe for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " has to be LuerLock:", True, True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The ConnectionType of Syringe for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> " has to be LuerLock:", True, False],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* Throw a message if the intensity is too high for the instrument *)
	intensityTooHighErrorOptions = If[MemberQ[intensityTooHighErrors, True] && messages,
		(
			Message[
				Error::CentrifugeIntensityAboveMaximum,

				ObjectToString[PickList[myInputSamples, intensityTooHighErrors], Cache -> cacheBall],
				PickList[resolvedIntensity, intensityTooHighErrors],
				ObjectToString[PickList[resolvedInstrument, intensityTooHighErrors], Cache -> cacheBall]
			];
			{Intensity, Instrument}
		),
		{}
	];
	intensityTooHighErrorTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, intensityTooHighErrors];
			passingInputs = PickList[myInputSamples, intensityTooHighErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", the specified Intensity does not exceed the MaxRotationRate of the specified or resolved Instrument:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", the specified Intensity does not exceed the MaxRotationRate of the specified or resolved Instrument:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	(* Throw a message if Pressure or RetentateWashPressure are specified but FiltrationType is not set to AirPressure (or if they are Null and FiltrationType is AirPressure) *)
	typePressureMismatchErrorOptions = If[MemberQ[typePressureMismatchErrors, True] && messages,
		(
			Message[Error::TypePressureMismatch, ObjectToString[PickList[myInputSamples, typePressureMismatchErrors], Cache -> cacheBall]];
			{FiltrationType, Pressure, RetentateWashPressure}
		),
		{}
	];
	typePressureMismatchErrorTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, typePressureMismatchErrors];
			passingInputs = PickList[myInputSamples, typePressureMismatchErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", if FiltrationType -> AirPressure, then Pressure cannot be Null.  If FiltrationType -> Centrifuge | Gravity, Pressure and RetentateWashPressure cannot be specified", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", if FiltrationType -> AirPressure, then Pressure cannot be Null.  If FiltrationType -> Centrifuge | Gravity, Pressure and RetentateWashPressure cannot be specified", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	(* Get the packet for the model of this filter  *)
	filterModelPackets = Which[
		MatchQ[#, ObjectP[Object]],
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Model], fastAssoc],
		MatchQ[#, ObjectP[Model]],
			fetchPacketFromFastAssoc[#, fastAssoc],
		True,
			<||>
	]&/@resolvedFilter;

	(* Throw a message if Pressure or RetentateWashPressure are higher than the MaxPressure of the specified or resolved Filter *)
	pressureTooHighErrorOptions = If[MemberQ[pressureTooHighErrors, True] && messages,
		(
			Message[
				Error::PressureTooHigh,
				ObjectToString[PickList[myInputSamples, pressureTooHighErrors], Cache -> cacheBall],
				ObjectToString[PickList[resolvedFilter, pressureTooHighErrors], Cache -> cacheBall],
				ObjectToString[PickList[Lookup[filterModelPackets, MaxPressure], pressureTooHighErrors]]
			];
			{Filter, Pressure, RetentateWashPressure}
		),
		{}
	];
	pressureTooHighErrorTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[myInputSamples, pressureTooHighErrors];
			passingInputs = PickList[myInputSamples, pressureTooHighErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", the specified Pressure is below the allowed MaxPressure of the specified or automatically set Filter:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", the specified Pressure is below the allowed MaxPressure of the specified or automatically set Filter:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];


	(* Final error chceks *)
	(* Check that we found a filter that matches all of the criteria *)
	noFilterAvailableInvalidOptions = If[MemberQ[noFilterAvailableErrors, True] && Not[gatherTests],
		(
			Message[Error::NoFilterAvailable, ObjectToString[PickList[simulatedSamples, noFilterAvailableErrors], Cache -> cacheBall]];
			{Filter}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	noFilterAvailableInvalidTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, noFilterAvailableErrors];
			passingInputs = PickList[simulatedSamples, noFilterAvailableErrors, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must have a resolved Filter capable of filtering them.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must have a resolved Filter capable of filtering them.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* If PrewetFilter is True but any of the prewetting options are Null, or vice versa *)
	prewetFilterMismatchOptions = If[MemberQ[prewetFilterMismatchErrors, True] && messages,
		(
			Message[
				Error::PrewetFilterMismatch,
				ObjectToString[PickList[simulatedSamples, prewetFilterMismatchErrors], Cache -> cacheBall],
				{PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterCentrifugeIntensity, PrewetFilterBuffer, PrewetFilterBufferLabel, PrewetFilterContainerOut, PrewetFilterContainerLabel, NumberOfFilterPrewettings}
			];
			{PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterCentrifugeIntensity, PrewetFilterBuffer, PrewetFilterBufferLabel, PrewetFilterContainerOut, PrewetFilterContainerLabel, NumberOfFilterPrewettings}
		),
		{}
	];
	prewetFilterMismatchTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, prewetFilterMismatchErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If PrewetFilter -> True, then PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterCentrifugeIntensity, PrewetFilterBuffer, PrewetFilterBufferLabel, PrewetFilterContainerOut, NumberOfFilterPrewettings, and PrewetFilterContainerLabel are not Null; if PrewetFilter -> False, these options are not specified for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If PrewetFilter -> True, then PrewetFilterTime, PrewetFilterBufferVolume, PrewetFilterCentrifugeIntensity, PrewetFilterBuffer, PrewetFilterBufferLabel, PrewetFilterContainerOut, NumberOfFilterPrewettings, and PrewetFilterContainerLabel are not Null; if PrewetFilter -> False, these options are not specified for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* If PrewetFiltercentrifugeIntensity is specififed, FiltrationType must be Centrifuge *)
	prewetFilterCentrifugeIntensityTypeOptions = If[MemberQ[prewetFilterCentrifugeIntensityTypeErrors, True] && messages,
		(
			Message[
				Error::PrewetFilterCentrifugeIntensityTypeMismatch,
				PickList[resolvedFiltrationType, prewetFilterCentrifugeIntensityTypeErrors],
				PickList[resolvedPrewetFilterCentrifugeIntensity, prewetFilterCentrifugeIntensityTypeErrors],
				ObjectToString[PickList[simulatedSamples, prewetFilterCentrifugeIntensityTypeErrors], Cache -> cacheBall]
			];
			{FiltrationType, PrewetFilterCentrifugeIntensity}
		),
		{}
	];
	prewetFilterCentrifugeIntensityTypeTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, prewetFilterCentrifugeIntensityTypeErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The PrewetFilterCentrifugeIntensity option is specified only if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["The PrewetFilterCentrifugeIntensity option is specified only if FiltrationType -> Centrifuge for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		],
		{}
	];

	(* NumberOfFilterPrewettings can't be greater than 1 if we're doing BottleTop or PeristalticPump filtering *)
	numberOfFilterPrewettingsTooHighOptions = If[MemberQ[numberOfFilterPrewettingsTooHighErrors, True] && messages,
		(
			Message[
				Error::NumberOfFilterPrewettingsTooHigh,
				ObjectToString[PickList[resolvedFilter, numberOfFilterPrewettingsTooHighErrors], Cache -> cacheBall],
				PickList[resolvedNumberOfFilterPrewettings, numberOfFilterPrewettingsTooHighErrors]
			];
			{NumberOfFilterPrewettings, Filter, FiltrationType}
		),
		{}
	];
	numberOfFilterPrewettingsTooHighTest = If[gatherTests,
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, numberOfFilterPrewettingsTooHighErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["NumberOfFilterPrewettings are not > 1 if performing PeristalticPump or BottleTop filtering for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["NumberOfFilterPrewettings are not > 1 if performing PeristalticPump or BottleTop filtering for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		]
	];

	(* we can't prewet filter for FilterBlock and Syringe filtering *)
	prewettingTypeMismatchOptions = If[MemberQ[prewettingTypeMismatchErrors, True] && messages,
		(
			Message[
				Error::PrewetFilterIncompatibleWithFilterType,
				ObjectToString[PickList[resolvedFilter, prewettingTypeMismatchErrors], Cache -> cacheBall]
			];
			{PrewetFilter, Filter}
		),
		{}
	];
	prewettingTypeMismatchTest = If[gatherTests,
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, prewettingTypeMismatchErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["Filter prewetting is not enabled if using syringe or filter plate filters for the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["Filter prewetting is not enabled if using syringe or filter plate filters for the inputs " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		]
	];

	(* transpose the filter, type, instrument, pressure, intensity, time, temperature, and collection containertogether *)
	groupedFilterParameters = Transpose[{resolvedFilter, resolvedFiltrationType, resolvedInstrument, resolvedPressure, resolvedIntensity, resolvedTime, resolvedTemperature, resolvedCollectionContainer}];

	(* Get a running tally of the different groupings *)
	runningTallyOfFilterParameters = runningTally[groupedFilterParameters];

	(* Get the number of wells for each entry *)
	allNumberOfWells = If[!MatchQ[#, PacketP[]] || !MatchQ[Lookup[#, NumberOfWells], _Integer], 1, Lookup[#, NumberOfWells]]& /@ filterModelPackets;

	(* figure out what number to append to the label based on the running tally and the number of wells for each filter *)
	(* need to subtract 1 because (basically) runningTally is 1-indexed and Quotient is 0 indexed *)
	filterLabelNumber = MapThread[
		Quotient[#1 - 1, #2]&,
		{runningTallyOfFilterParameters, allNumberOfWells}
	];

	(* Resolve the label option based on if we are using the same filter/using an object instead of a model *)
	filterLabelLookup = (# -> CreateUniqueLabel["filter"]&) /@ DeleteDuplicates[
		Transpose[{resolvedFilter, groupedFilterParameters[[All, 3 ;; 8]], filterLabelNumber}] /. {object : ObjectP[] :> Download[object, Object]}
	];
	resolvedFilterLabel = MapThread[
		Function[{specifiedFilterLabel, filter, filterParams, labelNumber},
			Which[
				Not[MatchQ[specifiedFilterLabel, Automatic | Null]],
				specifiedFilterLabel,
				MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[filter, Object]], _String],
				LookupObjectLabel[simulation, Download[filter, Object]],
				MatchQ[filter, ObjectP[Object[]]], "filter " <> ToString[filter],
				True,
				Lookup[filterLabelLookup, Key[{filter, filterParams[[3;;8]], labelNumber}/.{object:ObjectP[]:>Download[object, Object]}]]
			]
		],
		{Lookup[filterOptions, FilterLabel], resolvedFilter, groupedFilterParameters, filterLabelNumber}
	];

	(* pre resolve the FilterPosition *)
	(* a.) If it's specified, it's specified *)
	(* b.) If it's in a filter already and we're not moving it, pick the current position *)
	(* c.) If it's a non-container filter, set it to Null *)
	(* d.) If it's a non-plate container filter, set it to "A1" *)
	(* e.) If it's a plate otherwise, keep Automatic *)
	preResolvedFilterPosition = MapThread[
		Function[{sample, filter, specifiedPosition},
			Which[
				Not[MatchQ[specifiedPosition, Automatic]], specifiedPosition,
				MatchQ[fastAssocLookup[fastAssoc, sample, Container], ObjectP[filter]], fastAssocLookup[fastAssoc, sample, Position],
				Not[MatchQ[filter, ObjectP[{Object[Container], Model[Container]}]]], Null,
				Not[MatchQ[filter, ObjectP[{Object[Container, Plate], Model[Container, Plate]}]]], "A1",
				True, specifiedPosition
			]
		],
		{simulatedSamples, resolvedFilter, Lookup[myOptions, FilterPosition, {}]}
	];

	(* Resolve the filter position using calculateDestWells *)
	resolvedFilterPosition = calculateDestWells[resolvedFilter, Simulation -> simulation, DestinationContainerLabel -> resolvedFilterLabel, Positions -> preResolvedFilterPosition];

	(* quick FilterPosition error checking detour *)

	(* Flip error switch if FilterPosition does not exist in the resolved filter *)
	filterPositionDoesNotExistErrors = MapThread[
		Or[
			(* If FilterPosition is set but we have a non-container filter, then that's immediately an error *)
			Not[NullQ[#1]] && Not[MatchQ[#2, ObjectP[Model[Container]]]],
			(* If FilterPosition is set to something besides A1 and it's a vessel filter, also an error *)
			Not[MatchQ[#1, "A1"]] && MatchQ[#2, ObjectP[Model[Container, Vessel]]],
			(* If FilterPosition is set to something that is not in the Positions of the plate filter, also an error *)
			ListQ[Lookup[#2, Positions]] && Not[MemberQ[Lookup[Lookup[#2, Positions], Name, {}], #1]]
		]&,
		{resolvedFilterPosition, filterModelPackets}
	];

	(* Throw an error message if above error switch is flipped *)
	filterPositionDoesNotExistOptions = If[messages && MemberQ[filterPositionDoesNotExistErrors, True],
		(
			Message[
				Error::FilterPositionDoesNotExist,
				PickList[resolvedFilterPosition, filterPositionDoesNotExistErrors],
				ObjectToString[PickList[resolvedFilter, filterPositionDoesNotExistErrors], Cache -> cacheBall]
			];
			{Filter, FilterPosition}
		),
		{}
	];

	(* Make an error checking tests for if the filter position does not exist *)
	filterPositionDoesNotExistTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[filterPositionDoesNotExistErrors, True],
				Test["The indicated FilterPosition(s) " <> ToString[PickList[resolvedFilterPosition, filterPositionDoesNotExistErrors]] <> " exist in the indicated Filter(s) " <> ObjectToString[PickList[resolvedFilter, filterPositionDoesNotExistErrors], Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			passingTest = If[MemberQ[filterPositionDoesNotExistErrors, False],
				Test["The indicated FilterPosition(s) " <> ToString[PickList[resolvedFilterPosition, filterPositionDoesNotExistErrors, False]] <> " exist in the indicated Filter(s) " <> ObjectToString[PickList[resolvedFilter, filterPositionDoesNotExistErrors, False], Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			{failingTest, passingTest}
		]
	];

	(* Flip an error switch if the sample is already in the filter container, but the position does not match what its current position is *)
	filterPositionInvalidErrors = MapThread[
		And[
			(* sample has to be in the filter already *)
			MatchQ[fastAssocLookup[fastAssoc, #1, Container], ObjectP[#2]],
			(* filter position does not match current position *)
			Not[MatchQ[fastAssocLookup[fastAssoc, #1, Position], #3]]
		]&,
		{simulatedSamples, resolvedFilter, resolvedFilterPosition}
	];

	(* Throw an error message if above error switch is flipped *)
	filterPositionInvalidOptions = If[messages && MemberQ[filterPositionInvalidErrors, True],
		(
			Message[
				Error::FilterPositionInvalid,
				PickList[resolvedFilterPosition, filterPositionInvalidErrors],
				ObjectToString[PickList[simulatedSamples, filterPositionInvalidErrors], Cache -> cacheBall],
				ObjectToString[PickList[resolvedFilter, filterPositionInvalidErrors], Cache -> cacheBall]
			];
			{Filter, FilterPosition}
		),
		{}
	];

	(* Make an error checking tests for if the filter position is not the same as the position we're already in *)
	filterPositionInvalidTest = If[gatherTests,
		Module[{failingTest},
			(* a passing test here is kind of nonsense so not going to put it in *)
			failingTest = If[MemberQ[filterPositionInvalidErrors, True],
				Test["If the following sample(s) " <> ObjectToString[PickList[simulatedSamples, filterPositionInvalidErrors], Cache -> cacheBall] <> " are already in their specified Filter(s), then indicated FilterPosition(s) " <> PickList[resolvedFilterPosition, filterPositionInvalidErrors] <> " are the same as the samples' current positions:", True, False],
				Nothing
			];
			{failingTest}
		]
	];

	(* need to ensure that if the following are true, then the filtrate container labels do not resolve to be the same as each other *)
	(* 1.) The filters are different from each other *)
	(* 2.) The filters are plates *)
	(* 3.) The FiltrateContainerLabel option is not manually specified *)
	(* 4.) The FiltrateContainerOut option is not set to an object *)
	(* 5.) The FiltrateContainerOut option is a plate (if they are vessels, then we shouldn't resolve two things to go into the same place even if they share the same filter plate) *)
	filterLabelsToIntegerOrAutomaticRules = DeleteDuplicates[MapThread[
		Function[{semiFiltrateContainerOut, filterLabel, filter, semiFiltrateContainerLabel},
			If[
				And[
					MatchQ[filter, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]],
					Not[StringQ[semiFiltrateContainerLabel]],
					Not[MatchQ[Last[semiFiltrateContainerOut], ObjectP[Object[Container, Plate]]]],
					MatchQ[Last[semiFiltrateContainerOut], ObjectP[Model[Container, Plate]]]
				],
				{filterLabel, Last[semiFiltrateContainerOut]} -> First[semiFiltrateContainerOut],
				Nothing
			]
		],
		{semiResolvedTaggedFiltrateContainerOut, resolvedFilterLabel, resolvedFilter, semiResolvedFiltrateContainerLabel}
	]];

	(* Get all the integers that exist already, and add the absolute values together. This guarantees that going up from that value doesn't hit anything we don't have already *)
	existingIntegers = Cases[semiResolvedTaggedFiltrateContainerOut[[All, 1]], _Integer];
	nextInteger = Total[Abs[existingIntegers]];

	(* Make label to integer replace rules (because we have some automatics already) *)
	filterLabelsToIntegerRules = MapIndexed[
		Function[{labelAndContainer, index},
			labelAndContainer -> Switch[Lookup[filterLabelsToIntegerOrAutomaticRules, Key[labelAndContainer]],
				(* case where this doesn't apply from above (not a plate filter, or filtrate container out specified directly, or filtrate container label specified directly) *)
				_?MissingQ, Automatic,
				(* case where it was already an integer, just take that *)
				_?IntegerQ, Lookup[filterLabelsToIntegerOrAutomaticRules, Key[labelAndContainer]],
				(* actually make the integer *)
				Automatic, First[index] + nextInteger
			]
		],
		DeleteDuplicates[Transpose[{resolvedFilterLabel, semiResolvedTaggedFiltrateContainerOut[[All, 2]]}]]
	];

	(* Put all of this together to get the more-semi-resolved filtrate container out that ensures different filter plates don't get the same FiltrateContainerOut unless the user really wants it *)
	moreSemiResolvedFiltrateContainerOut = MapThread[
		{Lookup[filterLabelsToIntegerRules, Key[{#1, #2[[2]]}]], #2[[2]]}&,
		{resolvedFilterLabel, semiResolvedTaggedFiltrateContainerOut}
	];

	(* NOTE: make sure container grouping is ok - two different models of container cannot be given the same index *)
	(* Do this for FiltrateContainerOut and RetentateContainerOut *)

	(* Make sure if applicable, we mirror what the FilterPosition is if we have that value IF we know that CollectionContainer and FiltrateContainerOut are the same container *)
	(* Resolve the FiltrateDestinationWell to the same as FilterPosition under the following circumstances *)
	(* 1.) resolved FilterPosition matches LocationPositionP *)
	(* 2.) FiltrateDestinationWell is not resolved yet *)
	(* EITHER OF THESE TWO *)
	(* 3a.) CollectionContainer and FiltrateContainer are objects and the same *)
	(* 3b.) CollectionContainer and FiltrateContainer are models and the same *)
	(* 3b.) AND we're either not washing retentate, OR if we are, the WashFlowThroughContainers are the same as FiltrateContainerOut *)
	(* Note that this logic MUST MIRROR the logic below for figuring out resolvedFiltrateContainerLabel *)
	moreSemiResolvedFiltrateDestinationWell = MapThread[
		Function[{semiResolvedDestWell, filterPosition, collectionContainer, semiResolvedFiltrateCont, washRetentate, washFlowThroughContainers},
			Which[
				(* If we already have the destination well, just use that *)
				Not[MatchQ[semiResolvedDestWell, Automatic]], semiResolvedDestWell,
				(* If we don't have a FilterPosition, then don't bother *)
				Not[MatchQ[filterPosition, LocationPositionP]], semiResolvedDestWell,
				(* If FiltrateContainerOut and CollectionContainer are both Object[Container]s and they are the same object, then we must use FilterPosition *)
				And[
					MatchQ[collectionContainer, ObjectP[Object[Container]]],
					MatchQ[semiResolvedFiltrateCont[[2]], ObjectP[Object[Container]]],
					MatchQ[semiResolvedFiltrateCont[[2]], ObjectP[collectionContainer]]
				],
					filterPosition,
				(* If FiltrateContainerOut and CollectionContainer are both Model[Container]s and they are the same model *)
				(* AND we're not washing retentante, or the WashFlowThrougHContainers are the same a FiltrateContainerOut *)
				And[
					MatchQ[collectionContainer, ObjectP[Model[Container]]],
					MatchQ[semiResolvedFiltrateCont[[2]], ObjectP[Model[Container]]],
					MatchQ[semiResolvedFiltrateCont[[2]], ObjectP[collectionContainer]],
					Or[
						Not[washRetentate],
						MatchQ[washFlowThroughContainers, {ObjectP[semiResolvedFiltrateCont[[2]]]..}]
					]
				],
					filterPosition,
				(* Otherwise, just stick with what we have *)
				True, semiResolvedDestWell

			]
		],
		{semiResolvedFiltrateDestinationWell, resolvedFilterPosition, resolvedCollectionContainer, moreSemiResolvedFiltrateContainerOut, resolvedWashRetentate, resolvedWashFlowThroughContainer}
	];


	(* Group the container outs *)
	{groupedFiltrateContainersOut, resolvedFiltrateDestinationWell} = groupContainersOut[cacheBall, moreSemiResolvedFiltrateContainerOut, DestinationWell -> moreSemiResolvedFiltrateDestinationWell, SamplesIn -> simulatedSamples, FastAssoc -> fastAssoc];

	(* Resolve the FiltrateContainerLabel option based on the indices for the FiltrateContainerOut option *)
	(* If the following are true then resolve it to CollectionContainerLabel *)
	(* 1.) CollectionContainerLabel is specified *)
	(* EITHER OF THESE TWO *)
	(* 2a.) CollectionContainer and FiltrateContainer are objects and the same *)
	(* 2b.) CollectionContainer and FiltrateContainer are models and the same *)
	(* 2b.) AND we're either not washing retentate, OR if we are, the WashFlowThroughContainers are the same as FiltrateContainerOut *)
	(* IF YOU CHANGE THIS LOGIC YOU MUST CHANGE THE LOGIC ABOVE FOR PRE RESOLVING DESSTINATION WELL *)
	filtrateContainerLabelLookup = (# -> CreateUniqueLabel["filtrate container"]&) /@ DeleteDuplicates[groupedFiltrateContainersOut /. {link_Link :> Download[link, Object]}];
	resolvedFiltrateContainerLabel = MapThread[
		Function[{groupedFiltrateContainerOut, filtrateContainerLabel, specifiedCollectionContainerLabel, collectionContainer, washRetentate, washFlowThroughContainers},
			Which[
				Not[MatchQ[filtrateContainerLabel, Automatic]], filtrateContainerLabel,
				And[
					StringQ[specifiedCollectionContainerLabel],
					MatchQ[groupedFiltrateContainerOut[[2]], ObjectP[collectionContainer]],
					MatchQ[groupedFiltrateContainerOut[[2]], ObjectP[Object[Container]]]
				],
					specifiedCollectionContainerLabel,
				And[
					StringQ[specifiedCollectionContainerLabel],
					MatchQ[groupedFiltrateContainerOut[[2]], ObjectP[collectionContainer]],
					Or[
						Not[washRetentate],
						MatchQ[washFlowThroughContainers, {ObjectP[groupedFiltrateContainerOut[[2]]]..}]
					]
				],
					specifiedCollectionContainerLabel,
				True, Lookup[filtrateContainerLabelLookup, Key[groupedFiltrateContainerOut]]
			]
		],
		{groupedFiltrateContainersOut, semiResolvedFiltrateContainerLabel, Lookup[filterOptions, CollectionContainerLabel], resolvedCollectionContainer, resolvedWashRetentate, resolvedWashFlowThroughContainer}
	];

	(* Resolve the WashFlowThroughDestinationWell option; first we need to inherit things from the FiltrateContainerOut if applicable *)
	inheritedSemiResolvedWashFlowThroughDestinationWell = MapThread[
		Function[{washThroughDestWells, sameQs, filtrateDestWell},
			MapThread[
				If[TrueQ[#2] && MatchQ[#1, Automatic],
					filtrateDestWell,
					#1
				]&,
				{ToList@washThroughDestWells, sameQs}
			]
		],
		{semiResolvedWashFlowThroughDestinationWell, washFlowThroughSameAsFiltrateQs, resolvedFiltrateDestinationWell}
	];

	(* GroupContainersOut needs the indices so get those from groupedFiltrateContainersOut if we're doing that *)
	fakeTaggedWashFlowThroughContainers = MapThread[
		Function[{washThroughContainers, sameQs, filtrateContainerOut},
			MapThread[
				If[TrueQ[#2],
					{First[filtrateContainerOut], #1},
					{Automatic, #1}
				]&,
				{ToList@washThroughContainers, sameQs}
			]
		],
		{resolvedWashFlowThroughContainer, washFlowThroughSameAsFiltrateQs, groupedFiltrateContainersOut}
	];

	(* Get the actual destination wells *)
	{groupedWashFlowThroughContainers, flatResolvedWashFlowThroughDestinationWell} = groupContainersOut[cacheBall, Join @@ fakeTaggedWashFlowThroughContainers, DestinationWell -> Join @@ inheritedSemiResolvedWashFlowThroughDestinationWell, FastAssoc -> fastAssoc];

	(* Get the resolved destination wells in the correct format (and the grouped wash flow through containers too) *)
	resolvedWashFlowThroughDestinationWell = TakeList[flatResolvedWashFlowThroughDestinationWell, Length /@ inheritedSemiResolvedWashFlowThroughDestinationWell]/.{{Null..} :> Null};
	groupedWashFlowThroughContainersCorrectLength = TakeList[groupedWashFlowThroughContainers, Length /@ inheritedSemiResolvedWashFlowThroughDestinationWell];

	(* Resolve the WashFlowThroughContainerLabel option based on the indices for the WashFlowThroughContainer option *)
	(* 1.) If the label was specified, just pick that label *)
	(* 2.) If the label was not specified, the container is the same object or same model, and the destination well is the same, use the same label as the filtrate container *)
	(* 3.) Otherwise, use the label we generated *)
	(* the consequence of this is if left unset, all of these should resolve to be the same container as the filtrate container, and if one or more things are different, then all washes go into different containers *)
	washFlowThroughContainerLabelLookup = (# -> CreateUniqueLabel["wash flow through container"]&) /@ DeleteDuplicates[groupedWashFlowThroughContainers /. {link_Link :> Download[link, Object]}];
	resolvedWashFlowThroughContainerLabel = MapThread[
		Function[{flowThroughContainersWithIndex, flowThroughDestWells, semiResolvedLabels, filtrateContainer, filtrateContainerLabel, filtrateDestWell, sameQs},
			MapThread[
				Which[
					Not[MatchQ[#3, Automatic]], #3,
					And[
						MatchQ[#3, Automatic],
						MatchQ[LastOrDefault[#1], ObjectP[LastOrDefault[filtrateContainer]]],
						MatchQ[#2, filtrateDestWell],
						#4
					],
						filtrateContainerLabel,
					True,
						Lookup[washFlowThroughContainerLabelLookup, Key[#1]]
				]&,
				{flowThroughContainersWithIndex, ToList@flowThroughDestWells, ToList@semiResolvedLabels, sameQs}
			]/.{{Null..} :> Null}
		],
		{groupedWashFlowThroughContainersCorrectLength, resolvedWashFlowThroughDestinationWell, semiResolvedWashFlowThroughContainerLabel, groupedFiltrateContainersOut, resolvedFiltrateContainerLabel, resolvedFiltrateDestinationWell, washFlowThroughSameAsFiltrateQs}
	];

	(* Group the resolved containers out by index *)
	resolvedFiltrateContainerOutGroupedByIndex = GatherBy[groupedFiltrateContainersOut, #[[1]]&];

	(* Get the number of unique containers in the second index for each grouping *)
	numFiltrateContainersPerIndex = Map[
		Function[{containersByIndex},
			Length[DeleteDuplicatesBy[containersByIndex, Download[#[[2]], Object]&]]
		],
		resolvedFiltrateContainerOutGroupedByIndex
	];

	(* Get the ContainerOut specifications that are invalid *)
	invalidFiltrateContainerOutSpecs = PickList[resolvedFiltrateContainerOutGroupedByIndex, numFiltrateContainersPerIndex, Except[1]];

	(* Throw an error if there are any indices with multiple different containers *)
	filtrateContainerOutMismatchedIndexOptions = If[Not[MatchQ[invalidFiltrateContainerOutSpecs, {}]] && messages,
		(
			Message[Error::ContainerOutMismatchedIndex, invalidFiltrateContainerOutSpecs];
			{FiltrateContainerOut}
		),
		{}
	];

	(* Make a test making sure the ContainerOut indices are set properly *)
	filtrateContainerOutMismatchedIndexTest = If[gatherTests,
		Test["The specified FiltrateContainerOut indices do not refer to multiple containers at once:",
			MatchQ[invalidFiltrateContainerOutSpecs, {}],
			True
		]
	];

	(* NOTE: make sure container grouping is ok - *)

	(* Make rules pointing the resolved FiltrateContainerOut to the FiltrateDestinationWell, then merge those together *)
	filtrateContainerToWellRules = Merge[MapThread[#1 -> #2&, {groupedFiltrateContainersOut, resolvedFiltrateDestinationWell}], Join];

	(* Determine if we have any over-occupied filtrate containers out; if this happens then we will have Nulls in the DestinationWell but not in the ContainerOut *)
	overOccupiedFiltrateContainerOutTrio = KeyValueMap[
		If[Not[NullQ[#1]] && MemberQ[#2, Null],
			(* this is the container that's over occupied, how many spots are available, and how many spots were requested *)
			{#1[[2]], Length[#2], Length[DeleteCases[#2, Null]]},
			Nothing
		]&,
		filtrateContainerToWellRules
	];

	(* Throw an error if there are any over-occupied containers out *)
	filtrateContainerOverOccupiedOptions = If[Not[MatchQ[overOccupiedFiltrateContainerOutTrio, {}]] && messages,
		(
			Message[Error::ContainerOverOccupied, overOccupiedFiltrateContainerOutTrio[[All, 1]], overOccupiedFiltrateContainerOutTrio[[All, 2]], overOccupiedFiltrateContainerOutTrio[[All, 3]]];
			{FiltrateContainerOut}
		),
		{}
	];

	(* Make a test making sure the ContainerOut is not overspecified *)
	filtrateContainerOverOccupiedTest = If[gatherTests,
		Test["The requested filtrate containers out have enough positions to hold all requested samples:",
			MatchQ[overOccupiedFiltrateContainerOutTrio, {}],
			True
		]
	];

	(* Get the positions that actually exist in the resolved filtrate container out model *)
	filtrateContainerOutModelPackets = Map[
		Function[{containerOrModel},
			If[MatchQ[containerOrModel, ObjectP[Model[Container]]],
				fetchPacketFromFastAssoc[containerOrModel, fastAssoc],
				fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, containerOrModel, Model], fastAssoc]
			]
		],
		groupedFiltrateContainersOut[[All, 2]]
	];
	filtrateContainerOutAllowedPositions = Lookup[#, Name]& /@ Lookup[filtrateContainerOutModelPackets, Positions];

	(* Determine if the position is actually allowed *)
	invalidFiltrateDestWellPositionQ = MapThread[
		And[
			Not[MemberQ[#1, #2]],
			(* If our collection container does not match our filter, we may have non-existing wells here. We are going to through a different error later so quiet the error here. *)
			!TrueQ[#3]
		]&,
		{filtrateContainerOutAllowedPositions, resolvedFiltrateDestinationWell, collectionContainerPlateMismatchErrors}
	];

	(* Throw an error if any position doesn't actually exist *)
	invalidFiltrateDestWellPositionOptions = If[MemberQ[invalidFiltrateDestWellPositionQ, True] && messages,
		(
			Message[
				Error::DestinationWellDoesntExist,
				FiltrateDestinationWell,
				PickList[resolvedFiltrateDestinationWell, invalidFiltrateDestWellPositionQ],
				FiltrateContainerOut,
				PickList[groupedFiltrateContainersOut, invalidFiltrateDestWellPositionQ]
			];
			{FiltrateDestinationWell}
		),
		{}
	];

	(* Make a test for if the position doesn't actually exist *)
	invalidFiltrateDestWellPositionTest = If[gatherTests,
		Test["The specified FiltrateDestinationWell values exist for all specified or resolved FiltrateContainerOut values:",
			MemberQ[invalidFiltrateDestWellPositionQ, True],
			False
		]
	];

	(* Group the retentate container outs *)
	{resolvedRetentateContainersOut, resolvedRetentateDestinationWell} = groupContainersOut[cacheBall, semiResolvedRetentateContainerOut, DestinationWell -> semiResolvedRetentateDestinationWell, FastAssoc -> fastAssoc];

	(* Resolve the RetentateContainerLabel option based on the indices for the RetentateContainerOut option *)
	resolvedRetentateContainerLabel = MapThread[
		Which[
			Not[MatchQ[#2, Automatic]], #2,
			(* since this doesn't have to be specified, unlike the filtrate one *)
			NullQ[#1], Null,
			True, "Retentate Container " <> ToString[#1[[1]]] <> ToString[#1[[2]]]
		]&,
		{resolvedRetentateContainersOut, semiResolvedRetentateContainerLabel}
	];

	(* Resolve the ContainerOut label option depending on if the Target is the Retentate or Filtrate *)
	resolvedContainerOutLabel = MapThread[
		Function[{retentateContainerLabel, filtrateContainerLabel, containerOutLabel, target},
			Which[
				Not[MatchQ[containerOutLabel, Automatic]], containerOutLabel,
				MatchQ[target, Filtrate], filtrateContainerLabel,
				True, retentateContainerLabel
			]
		],
		{resolvedRetentateContainerLabel, resolvedFiltrateContainerLabel, semiResolvedContainerOutLabel, Lookup[filterOptions, Target]}
	];

	(* Group the resolved containers out by index *)
	resolvedRetentateContainerOutGroupedByIndex = GatherBy[resolvedRetentateContainersOut, If[NullQ[#], #, #[[1]]]&];

	(* Get the number of unique containers in the second index for each grouping *)
	numRetentateContainersPerIndex = Map[
		Function[{containersByIndex},
			Length[DeleteDuplicatesBy[containersByIndex, If[NullQ[#], Null, Download[#[[2]], Object]]&]]
		],
		resolvedRetentateContainerOutGroupedByIndex
	];

	(* Get the ContainerOut specifications that are invalid *)
	invalidRetentateContainerOutSpecs = PickList[resolvedRetentateContainerOutGroupedByIndex, numRetentateContainersPerIndex, Except[1]];

	(* Throw an error if there are any indices with multiple different containers *)
	retentateContainerOutMismatchedIndexOptions = If[Not[MatchQ[invalidRetentateContainerOutSpecs, {}]] && messages,
		(
			Message[Error::ContainerOutMismatchedIndex, invalidRetentateContainerOutSpecs];
			{RetentateContainerOut}
		),
		{}
	];

	(* Make a test making sure the ContainerOut indices are set properly *)
	retentateContainerOutMismatchedIndexTest = If[gatherTests,
		Test["The specified RetentateContainerOut indices do not refer to multpile containers at once:",
			MatchQ[invalidRetentateContainerOutSpecs, {}],
			True
		]
	];

	(* NOTE: make sure container grouping is ok - *)

	(* Make rules pointing the resolved RetentateContainerOut to the RetentateDestinationWell, then merge those together *)
	retentateContainerToWellRules = Merge[MapThread[#1 -> #2&, {resolvedRetentateContainersOut, resolvedRetentateDestinationWell}], Join];

	(* Determine if we have any over-occupied retentate containers out; if this happens then we will have Nulls in the DestinationWell but not in the ContainerOut *)
	overOccupiedRetentateContainerOutTrio = KeyValueMap[
		If[Not[NullQ[#1]] && MemberQ[#2, Null],
			(* this is the container that's over occupied, how many spots are available, and how many spots were requested *)
			{#1[[2]], Length[#2], Length[DeleteCases[#2, Null]]},
			Nothing
		]&,
		retentateContainerToWellRules
	];

	(* Throw an error if there are any over-occupied containers out *)
	retentateContainerOverOccupiedOptions = If[Not[MatchQ[overOccupiedRetentateContainerOutTrio, {}]] && messages,
		(
			Message[Error::ContainerOverOccupied, overOccupiedRetentateContainerOutTrio[[All, 1]], overOccupiedRetentateContainerOutTrio[[All, 2]], overOccupiedRetentateContainerOutTrio[[All, 3]]];
			{RetentateContainerOut}
		),
		{}
	];

	(* Make a test making sure the ContainerOut is not overspecified *)
	retentateContainerOverOccupiedTest = If[gatherTests,
		Test["The requested retentate containers out have enough positions to hold all requested samples:",
			MatchQ[overOccupiedRetentateContainerOutTrio, {}],
			True
		]
	];

	(* Get the positions that actually exist in the resolved retentate container out model *)
	retentateContainerOutModelPackets = Map[
		Function[{retentateContainerOutValue},
			With[{containerOrModel = If[NullQ[retentateContainerOutValue], Null, retentateContainerOutValue[[2]]]},
				Which[
					MatchQ[containerOrModel, ObjectP[Model[Container]]], fetchPacketFromFastAssoc[containerOrModel, fastAssoc],
					MatchQ[containerOrModel, ObjectP[Object[Container]]], fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, containerOrModel, Model], fastAssoc],
					(* this will only happen if containerOrModel is itself Null *)
					True, Null
				]
			]
		],
		resolvedRetentateContainersOut
	];
	retentateContainerOutAllowedPositions = Map[
		If[NullQ[#],
			Null,
			Lookup[Lookup[#, Positions, {}], Name, {}]
		]&,
		retentateContainerOutModelPackets
	];

	(* Determine if the position is actually allowed *)
	invalidRetentateDestWellPositionQ = MapThread[
		Not[NullQ[#1]] && Not[MemberQ[#1, #2]]&,
		{retentateContainerOutAllowedPositions, resolvedRetentateDestinationWell}
	];

	(* Throw an error if any position doesn't actually exist *)
	invalidRetentateDestWellPositionOptions = If[MemberQ[invalidRetentateDestWellPositionQ, True] && messages,
		(
			Message[
				Error::DestinationWellDoesntExist,
				RetentateDestinationWell,
				PickList[resolvedRetentateDestinationWell, invalidRetentateDestWellPositionQ],
				RetentateContainerOut,
				PickList[resolvedRetentateContainersOut, invalidRetentateDestWellPositionQ]
			];
			{RetentateDestinationWell}
		),
		{}
	];

	(* Make a test for if the position doesn't actually exist *)
	invalidRetentateDestWellPositionTest = If[gatherTests,
		Test["The specified RetentateDestinationWell values exist for all specified or resolved RetentateContainerOut values:",
			MemberQ[invalidRetentateDestWellPositionQ, True],
			False
		]
	];

	(* Make the final FiltrateContainerLabel-to-index replace rules *)
	filtrateContainerLabelToIndexReplaceRules = MapThread[
		#1 -> FirstOrDefault[#2]&,
		{resolvedFiltrateContainerLabel, groupedFiltrateContainersOut}
	];

	(* Make the final RetentateContainerLabel-to-index replace rules *)
	retentateContainerLabelToIndexReplaceRules = MapThread[
		#1 -> FirstOrDefault[#2]&,
		{resolvedRetentateContainerLabel, resolvedRetentateContainersOut}
	];

	(* merge the filtrate container label to index replace rules so that we can tell if we have mismatches or not *)
	(* basically if we have a single value then it's correctly matched; if it's a list then we have a mismatch *)
	mergedFiltrateContainerLabelToIndexReplaceRules = Merge[
		filtrateContainerLabelToIndexReplaceRules,
		If[Length[DeleteDuplicates[#]] == 1,
			First[#],
			DeleteDuplicates[#]
		]&
	];

	(* merge the retentate container label to index replace rules so that we can tell if we have mismatches or not *)
	(* basically if we have a single value then it's correctly matched; if it's a list then we have a mismatch *)
	mergedRetentateContainerLabelToIndexReplaceRules = Merge[
		retentateContainerLabelToIndexReplaceRules,
		If[Length[DeleteDuplicates[#]] == 1,
			First[#],
			DeleteDuplicates[#]
		]&
	];

	(* decide if we have a filtrate or retentate to index mismatch *)
	filtrateContainerLabelToIndexMismatchQ = MemberQ[Values[mergedFiltrateContainerLabelToIndexReplaceRules], _List];
	retentateContainerLabelToIndexMismatchQ = MemberQ[Values[mergedRetentateContainerLabelToIndexReplaceRules], _List];

	(* Throw a message if there is a mismatch for FiltrateContainerLabel and FiltrateContainerOut *)
	filtrateContainerLabelIndexMismatchOptions = If[filtrateContainerLabelToIndexMismatchQ && messages,
		(
			Message[Error::LabelContainerOutIndexMismatch, FiltrateContainerLabel, FiltrateContainerOut];
			{FiltrateContainerLabel, FiltrateContainerOut}
		),
		{}
	];

	(* Make a test for if the FiltrateContainerLabel and FiltrateContainerOut options are mismatched *)
	filtrateContainerLabelIndexMismatchTest = If[gatherTests,
		Test["For all values of FiltrateContainerLabel that are replicated, the corresponding integer indices in FiltrateContainerOut are also be replicated in the same positions:",
			filtrateContainerLabelToIndexMismatchQ,
			False
		]
	];

	(* Throw a message if there is a mismatch for RetentateContainerLabel and RetentateContainerOut *)
	retentateContainerLabelIndexMismatchOptions = If[retentateContainerLabelToIndexMismatchQ && messages,
		(
			Message[Error::LabelContainerOutIndexMismatch, RetentateContainerLabel, RetentateContainerOut];
			{RetentateContainerLabel, RetentateContainerOut}
		),
		{}
	];

	(* Make a test for if the RetentateContainerLabel and RetentateContainerOut options are mismatched *)
	retentateContainerLabelIndexMismatchTest = If[gatherTests,
		Test["For all values of RetentateContainerLabel that are replicated, the corresponding integer indices in RetentateContainerOut are also be replicated in the same positions:",
			retentateContainerLabelToIndexMismatchQ,
			False
		]
	];

	(* Get some error checking switches out of this MapThread regarding labeling *)
	{
		containerLabelMismatchErrors,
		sampleLabelMismatchErrors
	} = Transpose[MapThread[
		Function[{filtrateContainerLabel, retentateContainerLabel, containerOutLabel, filtrateLabel, retentateLabel, sampleOutLabel, target},
			Module[{containerLabelMismatchError, sampleLabelMismatchError},

				(* Make sure either FiltrateContainerLabel or RetentateContainerLabel is the same as the ContainerOutLabel option *)
				containerLabelMismatchError = If[MatchQ[target, Filtrate],
					Not[MatchQ[filtrateContainerLabel, containerOutLabel]],
					Not[MatchQ[retentateContainerLabel, containerOutLabel]]
				];

				(* Make sure either FiltrateLabel or RetentateLabel is the same as the SampleOutLabel option *)
				sampleLabelMismatchError = If[MatchQ[target, Filtrate],
					Not[MatchQ[filtrateLabel, sampleOutLabel]],
					Not[MatchQ[retentateLabel, sampleOutLabel]]
				];

				{
					containerLabelMismatchError,
					sampleLabelMismatchError
				}
			]
		],
		{resolvedFiltrateContainerLabel, resolvedRetentateContainerLabel, resolvedContainerOutLabel, resolvedFiltrateLabel, resolvedRetentateLabel, resolvedSampleOutLabel, Lookup[filterOptions, Target]}
	]];

	(* Throw an error if the ContainerOutLabel doesn't correspond with the corresponding FiltrateContainerLabel or RetentateContainerLabel *)
	containerLabelMismatchOptions = If[MemberQ[containerLabelMismatchErrors, True] && messages,
		(
			Message[
				Error::TargetLabelMismatch,
				ContainerOutLabel,
				RetentateContainerLabel,
				FiltrateContainerLabel,
				ObjectToString[PickList[simulatedSamples, containerLabelMismatchErrors], Cache -> cacheBall]
			];
			{ContainerOutLabel, RetentateContainerLabel, FiltrateContainerLabel}
		),
		{}
	];

	(* Make a test for if the position doesn't actually exist *)
	containerLabelMismatchTest = If[gatherTests,
		Test["If Target -> Retentate, then the ContainerOutLabel and RetentateContainerLabel options must be the same value or be unspecified.  If Target -> Filtrate, then the ContainerOutLabel and FiltrateContainerLabel options must be the same value or be unspecified:",
			MemberQ[containerLabelMismatchErrors, True],
			False
		]
	];

	(* Throw an error if the SampleOutLabel doesn't correspond with the corresponding FiltrateLabel or RetentateLabel *)
	sampleLabelMismatchOptions = If[MemberQ[sampleLabelMismatchErrors, True] && messages,
		(
			Message[
				Error::TargetLabelMismatch,
				SampleOutLabel,
				RetentateLabel,
				FiltrateLabel,
				ObjectToString[PickList[simulatedSamples, sampleLabelMismatchErrors], Cache -> cacheBall]
			];
			{SampleOutLabel, RetentateLabel, FiltrateLabel}
		),
		{}
	];

	(* Make a test for if the position doesn't actually exist *)
	sampleLabelMismatchTest = If[gatherTests,
		Test["If Target -> Retentate, then the SampleOutLabel and RetentateLabel options must be the same value or be unspecified.  If Target -> Filtrate, then the SampleOutLabel and FiltrateLabel options must be the same value or be unspecified:",
			MemberQ[sampleLabelMismatchErrors, True],
			False
		]
	];

	(* Get the collection container model packets *)
	collectionContainerModelPackets = Map[
		Which[
			NullQ[#], Null,
			MatchQ[#, ObjectP[Model[Container]]], fetchPacketFromFastAssoc[#, fastAssoc],
			True, fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Model], fastAssoc]
		]&,
		resolvedCollectionContainer
	];

	(* If the following are true, then CollectionContainerLabel is the same as FiltrateContainerLabel *)
	(* 0.) CollectionContainer is same as FiltrateContainerOut as objects, OR: *)
	(* the following 3 are true:*)
	(* 1.) CollectionContainer is same as FiltrateContainerOut as models *)
	(* 2.) EITHER FiltrateContainerLabel is the same as CollectionContainerLabel OR CollectionContainerLabel is Automatic *)
	(* 3.) We are either not washing retentate, OR if we are, the WashFlowThroughContainers are the same as FiltrateContainerOut *)
	(* then CollectionContainerLabel is the same as FiltrateContainerLabel *)
	(* Otherwise prepend "collection container " to the FilterLabel *)
	(* If our input are samples, we may have multiple samples sharing the sample collection container and filter since they are going to be processed together. We only need one unique label for one unique collection container *)
	uniqueCollectionContainerToLabelRule=Map[
		(#1->StringTake[Unique[] // ToString, 2 ;;])&,
		DeleteDuplicates@Download[resolvedCollectionContainer,Object]
	];
	resolvedCollectionContainerLabel = MapThread[
		Function[{filterLabel, collectionContainer, filtrateContainerOut, filtrateContainerLabel, specifiedCollectionContainerLabel, washFlowThroughContainerLabels, washRetentate},
			Which[
				Not[MatchQ[specifiedCollectionContainerLabel, Automatic | Null]], specifiedCollectionContainerLabel,
				NullQ[collectionContainer], Null,
				Or[
					And[
						MatchQ[collectionContainer, ObjectP[filtrateContainerOut]],
						MatchQ[collectionContainer, ObjectP[Object[Container]]]
					],
					And[
						MatchQ[collectionContainer, ObjectP[filtrateContainerOut]],
						(MatchQ[filtrateContainerLabel, specifiedCollectionContainerLabel] || MatchQ[specifiedCollectionContainerLabel, Automatic]),
						Or[
							Not[washRetentate],
							MatchQ[washFlowThroughContainerLabels, {filtrateContainerLabel..}]
						]
					]
				],
					filtrateContainerLabel,
				(*
					we are using Unique here in order work around the case when user is trying to use the same
					filter multiple times. Since we will resolve to use different CollectionContainer, without
					Unique[] we will try to apply identical labels to different containers. In the case when the user
					is referencing CollectionContainer by label we will just end up with a double labeled item which is not an issue
				*)
				True, StringJoin["collection container ", filterLabel, " ", Download[collectionContainer,Object]/.uniqueCollectionContainerToLabelRule]
			]
		],
		{
			resolvedFilterLabel,
			resolvedCollectionContainer,
			semiResolvedTaggedFiltrateContainerOut[[All, 2]],
			resolvedFiltrateContainerLabel,
			Lookup[filterOptions, CollectionContainerLabel],
			resolvedWashFlowThroughContainerLabel,
			resolvedWashRetentate
		}
	];

	(* Resolve the prewet container label; want to have a one-to-one correlation between the collection container/filtrate container out and the prewet container (i.e., if we're filtering into a plate, do the same number of plates for the prewetting, etc) *)
	resolvedPrewetFilterContainerLabel = MapThread[
		Function[{specifiedPrewetLabel, collectionContLabel, filtrateContLabel},
			Which[
				Not[MatchQ[specifiedPrewetLabel, Automatic]], specifiedPrewetLabel,
				StringQ[collectionContLabel], "prewet filter container " <> (StringReplace[collectionContLabel, "collection container " -> ""]),
				StringQ[filtrateContLabel], "prewet filter container " <> (StringReplace[filtrateContLabel, "filtrate container " -> ""]),
				(* shouldn't get here because there should always be a filtrate container label *)
				True, CreateUniqueLabel["prewet filter container"]
			]
		],
		{semiResolvedPrewetFilterContainerLabel, resolvedCollectionContainerLabel, resolvedFiltrateContainerLabel}
	];

	(* Group the Sample/Filter/FiltrationType/Instrument/Pressure/Intensity/Time/Temperature/CollectionContainer/FilterLabel by filter; if you have the same filter then Instrument/Pressure/Intensity/Time/Temperature/CollectionContainer need to be the same *)
	groupedSamplesAndOptions = GroupBy[
		MapThread[
			Function[{sample, params, label},
				Join[{sample}, params, {label}]
			],
			{myInputSamples, groupedFilterParameters, resolvedFilterLabel}
		],
		#[[2]]&
	];

	(* Get the samples and filters that over-occupy the filter *)
	(* this can only happen with objects and not for models (since then we'll just get another one) *)
	overOccupiedNumWells = MapThread[
		(* Note that if we are using a centrifuge filter and SamplesIn is in the same filter, skip this check since we are only doing multiple centrifuges after all *)
		If[(#2 > #3 && MatchQ[#1, ObjectP[Object]] && !MatchQ[#1, ObjectP[Lookup[#4, Object]]]),
			#3,
			Nothing
		]&,
		{resolvedFilter, runningTallyOfFilterParameters, allNumberOfWells, sampleContainerPackets}
	];
	overOccupiedFilters = MapThread[
		(* Note that if we are using a centrifuge filter and SamplesIn is in the same filter, skip this check since we are only doing multiple centrifuges after all *)
		If[(#2 > #3 && MatchQ[#1, ObjectP[Object]] && !MatchQ[#1, ObjectP[Lookup[#4, Object]]]),
			#1,
			Nothing
		]&,
		{resolvedFilter, runningTallyOfFilterParameters, allNumberOfWells, sampleContainerPackets}
	];

	(* Throw a message if you are trying to filter more than the filter can fit *)
	overOccupiedErrorOptions = If[Not[MatchQ[overOccupiedFilters, {}]] && messages,
		(
			Message[Error::OverOccupiedFilter, ObjectToString[overOccupiedFilters, Cache -> cacheBall], overOccupiedNumWells];
			{Filter}
		),
		{}
	];
	overOccupiedErrorTests = If[gatherTests,
		Test["No filters have more samples than available number of wells in the filter:",
			MatchQ[overOccupiedNumWells, {}],
			True
		]
	];


	(* Get the masses to be transferred into each filter *)
	newMassesPerFilter = Merge[
		MapThread[
			Function[{volume, filterLabel, transferringToNewFilterQ},
				If[transferringToNewFilterQ && VolumeQ[volume],
					filterLabel -> (volume * 0.997 Gram / Milliliter),
					Nothing
				]
			],
			{sampleVolumes, resolvedFilterLabel, transferringToNewFilterQs}
		],
		Total
	];

	(* Pull out the specified occluding retentate container label *)
	unresolvedOccludingRetentateContainerLabel = Lookup[mapThreadFriendlyOptions, OccludingRetentateContainerLabel];

	(* Resolve the destination well of the occluding retentate container, and with the indices of the container, get the label too *)
	{resolvedOccludingRetentateContainerWithIndices, resolvedOccludingRetentateDestWell} = groupContainersOut[
		cacheBall,
		Transpose[{unresolvedOccludingRetentateContainerLabel, resolvedOccludingRetentateContainer}],
		DestinationWell -> preResolvedOccludingRetentateDestWell,
		FastAssoc -> fastAssoc
	];
	resolvedOccludingRetentateContainerLabel = MapThread[
		Which[
			Not[MatchQ[#2, Automatic]], #2,
			(* since this doesn't have to be specified *)
			NullQ[#1[[2]]], Null,
			True, "Occluding Retentate Container " <> ToString[#1[[1]]] <> " " <> ToString[#1[[2]]]
		]&,
		{resolvedOccludingRetentateContainerWithIndices, unresolvedOccludingRetentateContainerLabel}
	];

	(* If the CollectionContainerLabel and FiltrateContainerLabel are the same but FilterPosition and FiltrateDestinationWell are different, then throw an error *)
	destWellPositionConflict = MapThread[
		Function[{filterPosition, filtrateWell, collectionContainerLabel, filtrateContainerLabel},
			If[collectionContainerLabel === filtrateContainerLabel && MatchQ[filterPosition, LocationPositionP] && MatchQ[filtrateWell, LocationPositionP],
				filterPosition =!= filtrateWell,
				False
			]
		],
		{resolvedFilterPosition, resolvedFiltrateDestinationWell, resolvedCollectionContainerLabel, resolvedFiltrateContainerLabel}
	];
	destWellPositionErrorOptions = If[MemberQ[destWellPositionConflict, True] && messages,
		(
			Message[
				Error::FilterPositionDestinationWellConflict,
				PickList[resolvedFilterPosition, destWellPositionConflict, True],
				PickList[resolvedFiltrateDestinationWell, destWellPositionConflict, True]
			];
			{FilterPosition, FiltrateDestinationWell}
		),
		{}
	];
	destWellPositionErrorTest = If[gatherTests,
		Test["If CollectionContainer and FiltrateContainerOut are the same, then FilterPosition and FiltrateContainerOut must be the same:",
			MemberQ[destWellPositionConflict, True],
			False
		]
	];

	{
		resolvedCounterweight,
		noCounterweightsErrors
	} = Transpose[MapThread[
		Function[{specifiedOptions, filter, filterModelPacket, collectionContainerModelPacket, type, resolvedExperimentOptions, filterLabel},
			Module[
				{requiredCounterweight, collectionContainerHeight, filterHeight, stackHeight, noCounterweightsError,
				counterweight, filterContentsSamples, filterContentsMass, filterTareWeight, collectionContainerTareWeight},

				noCounterweightsError = False;

				(* Get the mass of all the samples that are already in the filter *)
				filterContentsSamples = Join[
					If[MatchQ[filter, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, filter, Contents][[All, 2]],
						{}
					],
					If[MatchQ[Lookup[resolvedExperimentOptions, CollectionContainer], ObjectP[Object]],
						fastAssocLookup[fastAssoc, Lookup[resolvedExperimentOptions, CollectionContainer], Contents][[All, 2]],
						{}
					]
				];
				filterContentsMass = Cases[
					Map[
						fastAssocLookup[fastAssoc, #, Volume] * (0.997 Gram / Milliliter) &,
						filterContentsSamples
					],
					MassP
				];

				(* Get the tare weights of the filter and collection container.  If the Filter's is not populated (which it normally is not) then just use half the weight of the collection container (which is definitely weird but is better than assuming zero) *)
				collectionContainerTareWeight = If[NullQ[collectionContainerModelPacket],
					Null,
					Lookup[collectionContainerModelPacket, TareWeight]
				];
				filterTareWeight = If[NullQ[Lookup[filterModelPacket, TareWeight]],
					If[NullQ[collectionContainerTareWeight],Null,collectionContainerTareWeight / 2],
					Lookup[filterModelPacket, TareWeight]
				];

				(* Determine the counterbalance weights we need *)
				(* to do this, we need to add the weight of the collection container, the filter, and all the samples that are or will be in the container *)
				(* only resolving this for robotic *)
				requiredCounterweight = If[MatchQ[type, Centrifuge] && roboticQ,
					collectionContainerTareWeight + filterTareWeight + Total[filterContentsMass] + Total[Cases[ToList[(filterLabel /. newMassesPerFilter)], MassP]],
					Null
				];

				(* Get the heights of the collection container and filter container *)
				collectionContainerHeight = If[!NullQ[collectionContainerModelPacket],LastOrDefault[Lookup[collectionContainerModelPacket, Dimensions]]];
				filterHeight = If[!NullQ[filterModelPacket],LastOrDefault[Lookup[filterModelPacket, Dimensions]]];

				(* Get the height of the collection container and filter stack *)
				stackHeight = collectionContainerHeight + filterHeight;

				{
					counterweight,
					noCounterweightsError
				} = If[NullQ[requiredCounterweight]||Not[roboticQ],
						{Null,False},
						Experiment`Private`getProperCounterweight[requiredCounterweight,
							stackHeight,
							Lookup[specifiedOptions, Counterweight],
							Lookup[collectionContainerModelPacket,Footprint],
							Flatten@allCounterweightPackets
						]
					];
				{
					counterweight,
					noCounterweightsError
				}

			]
		],
		{mapThreadFriendlyOptions, resolvedFilter, filterModelPackets, collectionContainerModelPackets, resolvedFiltrationType, mapThreadFriendlyOptions, resolvedFilterLabel}
	]];

	(* Throw a message if there is no counterweight *)
	noCounterweightCollectionContainers = PickList[resolvedCollectionContainer, noCounterweightsErrors];
	noCounterweightOptions = If[messages && MemberQ[noCounterweightsErrors, True],
		(
			Message[Error::CollectionContainerNoCounterweights, ObjectToString[noCounterweightCollectionContainers, Cache -> cacheBall]];
			{CollectionContainer}
		),
		{}
	];

	(* Make a test if there are no counterweights *)
	noCounterweightTest = If[gatherTests,
		Test["All specified CollectionContainer(s) have their Counterweights field populated if performing filtering by centrifuge:",
			noCounterweightsErrors,
			{False..}
		]
	];

	(* Throw a message if a filter plate is being used but collection container is not a plate *)
	collectionContainerPlateMismatchErrorSamples = PickList[simulatedSamples, collectionContainerPlateMismatchErrors, True];
	collectionContainerPlateMismatchErrorOptions = If[MemberQ[collectionContainerPlateMismatchErrors, True] && messages,
		(
			Message[Error::CollectionContainerPlateMismatch, ObjectToString[collectionContainerPlateMismatchErrorSamples, Cache -> cacheBall]];
			{CollectionContainer, Filter}
		),
		{}
	];

	(* mkae a test if we have a mismatch between Filter and CollectionContainer *)
	collectionContainerPlateMismatchErrorTests = If[gatherTests,
		Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
			(* Get the inputs that pass this test. *)
			nonPassingInputs = PickList[simulatedSamples, collectionContainerPlateMismatchErrors];
			passingInputs = Complement[simulatedSamples, nonPassingInputs];
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If Filter and CollectionContainer are both specified for sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", both are plates or neither are plates:", True, True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
				Test["If Filter and CollectionContainer are both specified for sample(s) " <> ObjectToString[nonPassingInputs, Cache -> cacheBall] <> ", both are plates or neither are plates:", True, True],
				Nothing
			];
			(* Return our created tests. *)
			{passingInputsTest, nonPassingInputsTest}
		]
	];


	(* Get the options that are different within the groupings *)
	{sameFilterConflictingOptions, sameFilterConflictingFilters, sameFilterConflictingSamples} = Transpose[KeyValueMap[
		Function[{filter, options},
			Module[{typeSameQ, instrumentSameQ, pressureSameQ, intensitySameQ, temperatureSameQ, collectionContainerSameQ,
				problemOptions, problemSamples, problemFilters, filterLabelSameQ},

				(* If we're using models, who cares *)
				If[MatchQ[filter, ObjectP[Model]],
					Return[{{}, {}, {}}, Module]
				];

				(* Determine if everything is the same thing for FiltrationType/Instrument/Pressure/Intensity/Temperature/CollectionContainer *)
				typeSameQ = Length[DeleteDuplicates[options[[All, 3]]]] == 1;
				instrumentSameQ = Length[DeleteDuplicates[options[[All, 4]]]] == 1;
				pressureSameQ = Length[DeleteDuplicates[options[[All, 5]]]] == 1;
				intensitySameQ = Length[DeleteDuplicates[options[[All, 6]]]] == 1;
				temperatureSameQ = Length[DeleteDuplicates[options[[All, 8]]]] == 1;
				collectionContainerSameQ = Length[DeleteDuplicates[options[[All, 9]]]] == 1;
				filterLabelSameQ = Length[DeleteDuplicates[options[[All, 10]]]] == 1;

				(* Get the options that are problematic *)
				problemOptions = {
					If[typeSameQ, Nothing, FiltrationType],
					If[instrumentSameQ, Nothing, Instrument],
					If[pressureSameQ, Nothing, Pressure],
					If[intensitySameQ, Nothing, Intensity],
					If[temperatureSameQ, Nothing, Temperature],
					If[collectionContainerSameQ, Nothing, CollectionContainer],
					If[filterLabelSameQ, Nothing, FilterLabel]
				};

				(* Get the corresponding samples if the options are problematic *)
				problemSamples = If[MatchQ[problemOptions, {}],
					{},
					DeleteDuplicates[options[[All, 1]]]
				];
				problemFilters = If[MatchQ[problemOptions, {}],
					{},
					filter
				];

				{
					problemOptions,
					problemFilters,
					problemSamples
				}


			]

		],
		groupedSamplesAndOptions
	]];

	(* Throw a message if samples in the same plate have different filtration options *)
	sameFilterConflictingErrorOptions = If[Not[MatchQ[Flatten[sameFilterConflictingOptions], {}]] && messages,
		(
			Message[Error::ConflictingFilterPlateOptions, ObjectToString[sameFilterConflictingFilters, Cache -> cacheBall], sameFilterConflictingOptions];
			DeleteDuplicates[Flatten[sameFilterConflictingOptions]]
		),
		{}
	];
	sameFilterConflictingErrorTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[Keys[groupedSamplesAndOptions], sameFilterConflictingOptions, Except[{}]];
			passingInputs = PickList[Keys[groupedSamplesAndOptions], sameFilterConflictingOptions, {}];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["For the following filters, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", all filtering parameters are consistent across the plate:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["For the following filters, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", all filtering parameters are consistent across the plate:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];


	(* NOTE: all pipetting options are specific to Robotic preparation only *)
	(* Get the specified pipetting parameter options *)
	pipettingOptionNames = Keys[Join[SafeOptions[TransferTipOptions],SafeOptions[TransferRoboticTipOptions]]];
	pipettingOptionsToPass = Map[
		# -> Lookup[filterOptions, #]&,
		pipettingOptionNames
	];

	(* --- Ok this is a little weird --- *)
	(* 1.) We need to split the preResolvedPipettingParameterOptions to be mapThreadFriendly *)
	(* 2.) We need to get only the samples/filters/volumes/options that are relevant to actually moving to a new place *)
	(* 3.) We need to resolve all the ones where we're NOT moving to a new place to Null, and throw an error for the ones that are not Null *)
	(* 4.) We need to call resolveTransferRoboticPrimitive on everything we _are_ moving, unless we aren't moving anything in which case we skip it *)
	(* 5.) We need to mapThreadFriendly the output of resolveTransferRoboticPrimitive, then use ReplacePart to put it in the correct order with the all-Null ones *)
	(* 6.) We need to re-combine everything to get the resolved options *)

	(* Split the parameters to be mapThreadFriendly *)
	mapThreadFriendlyPreResolvedPipettingParameterOptions = OptionsHandling`Private`mapThreadOptions[ExperimentTransfer, pipettingOptionsToPass];

	(* Get only the samples/filters/volumes/options that are relevant to actually moving to a new place *)
	{samplesToTransfer, samplesToNotTransfer} = {
		PickList[myInputSamples, transferringToNewFilterQs],
		PickList[myInputSamples, transferringToNewFilterQs, False]
	};
	(* NOTE: Some of the filters may have resolved to Null. Replace with a huge filter that should have no problems handling volume. *)
	{filtersToTransfer, filtersToNotTransfer} = {
		PickList[resolvedFilter, transferringToNewFilterQs]/.{Null -> Model[Container, Vessel, Filter, "id:4pO6dMWK83az"]},
		PickList[resolvedFilter, transferringToNewFilterQs, False]
	};
	{volumesToTransfer, volumesToNotTransfer} = {
		PickList[resolvedVolumes, transferringToNewFilterQs],
		PickList[resolvedVolumes, transferringToNewFilterQs, False]
	};
	{optionsToTransfer, optionsToNotTransfer} = {
		PickList[mapThreadFriendlyPreResolvedPipettingParameterOptions, transferringToNewFilterQs],
		PickList[mapThreadFriendlyPreResolvedPipettingParameterOptions, transferringToNewFilterQs, False]
	};

	{samplesToTransferSterile, samplesToNotTransferSterile} = {
		PickList[resolvedSterile, transferringToNewFilterQs],
		PickList[resolvedSterile, transferringToNewFilterQs, False]
	};

	(* Get the filter label options that we are transferring since that needs to get passed into Transfer's resolver *)
	filterLabelsToTransfer = PickList[resolvedFilterLabel, transferringToNewFilterQs];

	(* Resolve the options we aren't transferring to Null *)
	resolvedOptionsToNotTransfer = Map[
		Function[{options},
			Association@@KeyValueMap[
				Function[{option,value},
					Which[
						(* AspirationMix and DispenseMix are resolved to False if we are not transfer, because they are not allowed to be Null as options *)
						(MatchQ[option,AspirationMix]||MatchQ[option,DispenseMix])&&MatchQ[value,Automatic],
						option -> False,
						(* Other pipetting options are resolved to Null if we are not transfer *)
						MatchQ[value,Automatic],
						option -> Null,
						(* Otherwise, stay as what it is for error checking *)
						True, option -> value
					]
				],options
			]
		],optionsToNotTransfer
	 ];

	(* Get options that are specified even though we're not transferring *)
	optionsWithInvalidTransferOptions = Map[
		Function[{options},
			Module[{invalidOptions},
				invalidOptions = KeyValueMap[
					Function[{option, value},
						If[MatchQ[option, Cache | Simulation | Output] || MatchQ[value, Null] || (MatchQ[option,AspirationMix]&&MatchQ[value,False]) || (MatchQ[option,DispenseMix]&&MatchQ[value,False]),
							Nothing,
							option
						]
					],
					options
				];

				invalidOptions
			]
		],
		resolvedOptionsToNotTransfer
	];

	(* Throw a message if pipetting parameters were specified but no sample actually needs to be transferred *)
	invalidPipettingParameterOptions = If[Not[MatchQ[Flatten[optionsWithInvalidTransferOptions], {}]] && messages,
		(
			Message[
				Error::UnusedPipettingOptions,
				ObjectToString[PickList[samplesToNotTransfer, optionsWithInvalidTransferOptions, Except[{}]], Cache -> cacheBall],
				Cases[optionsWithInvalidTransferOptions, Except[{}]]
			];
			Flatten[optionsWithInvalidTransferOptions]
		),
		{}
	];
	invalidPipettingParameterTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[samplesToNotTransfer, optionsWithInvalidTransferOptions, Except[{}]];
			passingInputs = PickList[samplesToNotTransfer, optionsWithInvalidTransferOptions, {}];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples that are not going to be pipetted during this filter operation, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " do not have any pipetting parameter options specified:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples that are not going to be pipetted during this filter operation, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " do not have any pipetting parameter options specified:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		]
	];

	(* Split the samples/filters/volumes/options based on the maximum that can be transferred at once *)
	(* this is because if you have 2 transfers but need to do 1 mL of one and 0.3 mL of the other, the first transfer is going to be done in sequence (970 uL, then 30 uL) *)
	(* this messes with our index matching unless we know how to deal with it *)
	{
		nestedSamplesToTransfer,
		nestedFiltersToTransfer,
		nestedVolumesToTransfer,
		nestedMapThreadOptionsToTransfer
	} = If[MatchQ[samplesToTransfer, {}],
		{{}, {}, {}, {}},
		expandInputsBasedOnMaxVolume[samplesToTransfer, filtersToTransfer, volumesToTransfer, optionsToTransfer]
	];

	(* calculate the destination wells to transfer to *)
	destWellsToTransferTo = PickList[resolvedFilterPosition, transferringToNewFilterQs];

	(* Add the cache/simulation options in  *)
	preResolvedPipettingParameterOptions = Flatten[{
		Map[
			# -> Lookup[optionsToTransfer, #, {}]&,
			pipettingOptionNames
		],
		DestinationContainerLabel -> filterLabelsToTransfer,
		DestinationWell -> destWellsToTransferTo,
		Preparation -> Robotic,
		SterileTechnique -> samplesToTransferSterile,
		WorkCell -> resolvedWorkCell
	}];

	(* call resolveTransferRoboticPrimitive to resolve the pipetting parameters. Only for robotic (e.g. samplesToTransfer is also {} for Robotic preparation) *)
	preResolvedPipettingParameterSafeOptions=If[MatchQ[samplesToTransfer, {}],
		{},
		Last[ExpandIndexMatchedInputs[ExperimentTransfer,{samplesToTransfer, filtersToTransfer, volumesToTransfer},SafeOptions[ExperimentTransfer,preResolvedPipettingParameterOptions]]]
	];

	(* NOTE: 970 Microliter is the maximum volume that can be transferred during micro. *)
	(* By this point we will have already called resolveFilterMethod, which means Error::ConflictingUnitOperationMethodRequirements will have already been thrown (and Error::InvalidOption will be thrown below) so we can quiet these here *)
	(* I don't love quieting these messages, but duplicate messages are annoying and also cause General::Stop trainwrecks so we don't want to replicate that here *)
	{allResolvedTransferOptions, transferTests} = Quiet[
		Which[
			MatchQ[samplesToTransfer, {}], {{}, {}},
			gatherTests && roboticQ, ExperimentTransfer[samplesToTransfer, filtersToTransfer, (Min[970 Microliter, #]&)/@volumesToTransfer, ReplaceRule[preResolvedPipettingParameterSafeOptions, {OptionsResolverOnly -> True, Simulation -> simulation, Output -> {Options, Tests}}]],
			gatherTests, ExperimentTransfer[samplesToTransfer, filtersToTransfer, volumesToTransfer, ReplaceRule[preResolvedPipettingParameterSafeOptions, {OptionsResolverOnly -> True, Simulation -> simulation, Output -> {Options, Tests}}]],
			roboticQ, {ExperimentTransfer[samplesToTransfer, filtersToTransfer, (Min[$MaxRoboticSingleTransferVolume, #]&)/@volumesToTransfer, ReplaceRule[preResolvedPipettingParameterSafeOptions, {OptionsResolverOnly -> True, Simulation -> simulation, Output -> Options}]], {}},
			True, {ExperimentTransfer[samplesToTransfer, filtersToTransfer, volumesToTransfer, ReplaceRule[preResolvedPipettingParameterSafeOptions, {OptionsResolverOnly -> True, Simulation -> simulation, Output -> Options}]], {}}
		],
		{Error::InvalidOption, Error::ConflictingUnitOperationMethodRequirements}
	];

	(* Split the resolved transfer options to be map threaded again *)
	mapThreadFriendlyPartialResolvedTransferOptions = If[MatchQ[allResolvedTransferOptions, {}],
		{},
		OptionsHandling`Private`mapThreadOptions[ExperimentTransfer, allResolvedTransferOptions]
	];

	(* Get only the options that we want; if you have multiple transfers per sample, then only take the first transfer's pipetting parameters *)
	mapThreadFriendlyPartialResolvedTransferOptionsCorrectAmount = If[MatchQ[allResolvedTransferOptions, {}],
		{},
		mapThreadFriendlyPartialResolvedTransferOptions

	];

	(* Combine the options together again; RiffleAlternatives is a weird function but basically will turn RiffleAlternatives[{a,b,c}, {d,e}, {False, True, True, True, False}] into {d, a, b, c, e} *)
	combinedMapThreadFriendlyOptions = RiffleAlternatives[mapThreadFriendlyPartialResolvedTransferOptionsCorrectAmount, resolvedOptionsToNotTransfer, transferringToNewFilterQs];

	(* Determine how much of each buffer we are going to reserve (excluding PrewetFilterBuffer because we don't use that for robotic) *)
	groupedBuffersAndVolumes = Merge[
		MapThread[
			If[NullQ[#1] || NullQ[#2] || NullQ[#3] || NullQ[#4],
				Nothing,
				{#1, #4} -> (#2 * #3)
			]&,
			{
				Download[Flatten[{resolvedRetentateWashBuffer, resolvedResuspensionBuffer}], Object],
				Flatten[{resolvedRetentateWashVolume, resolvedResuspensionVolume}],
				Flatten[{resolvedNumberOfRetentateWashes, ConstantArray[1, Length[resolvedResuspensionVolume]]}],
				Flatten[{resolvedRetentateWashBufferLabel, resolvedResuspensionBufferLabel}]
			}
		],
		Total
	];

	(* Get the containers for each buffer we're going to use *)
	buffersAndContainers = KeyValueMap[
		Last[#1] -> If[MatchQ[First[#1], ObjectP[Object[Sample]]],
			fastAssocLookup[fastAssoc, First[#1], {Container, Model, Object}],
			PreferredContainer[#2, Type -> All, LiquidHandlerCompatible -> If[roboticQ, True, Automatic]]
		]&,
		groupedBuffersAndVolumes
	];
	retentateWashBufferContainers = Map[
		Function[{containers},
			Which[
				NullQ[containers], Null,
				ListQ[containers], fetchPacketFromFastAssoc[#, fastAssoc]& /@ containers,
				True, fetchPacketFromFastAssoc[containers, fastAssoc]
			]
		],
		resolvedRetentateWashBufferLabel /. buffersAndContainers
	];
	resuspensionBufferContainers = fetchPacketFromFastAssoc[#, fastAssoc]& /@ (resolvedResuspensionBufferLabel /. buffersAndContainers);

	(* Resolve what the tips will be for retentate washing and resuspension if we are doing that, robotically *)
	(* TODO ideally this would just call Transfer directly and not replicate what Transfer does.  However this is way faster so for now I'm keeping it *)
	retentateWashTips = Flatten[MapThread[
		Function[{washRetentate, retentateWashVolume, numWashes, containerPackets},
			If[Not[roboticQ] || Not[washRetentate],
				Nothing,
				MapThread[
					Function[{washVolume, numberOfWashesOneBuffer, containerPacket},
						With[{splitVolumes = splitVolumesBy970[washVolume]},
							ConstantArray[Map[
								Function[volume,
									Module[{potentialTips, tipsThatCanAspirate},
										(* Get the tips that can actually reach the bottom *)
										(* tipsCanAspirateQCoreHamilton is a helper from ExperimentTransfer that does this same thing *)
										(* Doing FirstOrDefault for resolvedSterile because this should be the same for everything no matter what in robotic anyway *)
										potentialTips = TransferDevices[Model[Item, Tips], volume, Sterile -> FirstOrDefault[resolvedSterile], PipetteType -> Hamilton][[All, 1]];
										tipsThatCanAspirate = Select[potentialTips, tipsCanAspirateQCoreHamilton[#, containerPacket, fetchPacketFromFastAssoc[#, fastAssoc], Null]&];

										FirstOrDefault[tipsThatCanAspirate]
									]
								],
								splitVolumes
							], numberOfWashesOneBuffer]
						]
					],
					{retentateWashVolume, numWashes, containerPackets}
				]
			]
		],
		{resolvedWashRetentate, resolvedRetentateWashVolume, resolvedNumberOfRetentateWashes, retentateWashBufferContainers}
	]];
	resuspensionTips = Flatten[MapThread[
		Function[{resuspensionVolume, containerPacket},
			With[{splitVolumes = If[VolumeQ[resuspensionVolume], splitVolumesBy970[resuspensionVolume], {}]},
				Map[
					Function[{volume},
						If[Not[roboticQ],
							Nothing,
							Module[{potentialTips, tipsThatCanAspirate},
								(* Get the tips that can actually reach the bottom *)
								(* tipsCanAspirateQCoreHamilton is a helper from ExperimentTransfer that does this same thing *)
								(* Doing FirstOrDefault for resolvedSterile because this should be the same for everything no matter what in robotic anyway *)
								potentialTips = TransferDevices[Model[Item, Tips], volume, Sterile -> FirstOrDefault[resolvedSterile], PipetteType -> Hamilton][[All, 1]];
								tipsThatCanAspirate = Select[potentialTips, tipsCanAspirateQCoreHamilton[#, containerPacket, fetchPacketFromFastAssoc[#, fastAssoc], Null]&];

								(* Doing it twice so that we can do the transfer into the container, and then also the transfer out and into the retentate container out *)
								{FirstOrDefault[tipsThatCanAspirate], FirstOrDefault[tipsThatCanAspirate]}
							]
						]
					],
					splitVolumes
				]
			]
		],
		{resolvedResuspensionVolume, resuspensionBufferContainers}
	]];

	(* these are the tips for moving sample from the collection container to FiltrateContainerOut/WashFlowThroughContainers *)
	(* TODO same as above, I don't love this implementation and hopefully when we have a better future for calling Transfer inside of Filter, this can get killed *)
	filtrateContainerOutTips = Flatten[{
		(* FiltrateContainerOut *)
		MapThread[
			Function[{volume, collectionContainerLabel, filtrateContainerLabel, collectionContainerPacket},
				With[{splitVolumes = If[VolumeQ[volume], splitVolumesBy970[volume], {}]},
					If[Not[roboticQ] || MatchQ[collectionContainerLabel, filtrateContainerLabel],
						Nothing,
						Map[
							Function[{volume},
								Module[{potentialTips, tipsThatCanAspirate},
									(* Get the tips that can actually reach the bottom *)
									(* tipsCanAspirateQCoreHamilton is a helper from ExperimentTransfer that does this same thing *)
									(* Doing FirstOrDefault for resolvedSterile because this should be the same for everything no matter what in robotic anyway *)
									potentialTips = TransferDevices[Model[Item, Tips], volume, Sterile -> FirstOrDefault[resolvedSterile], PipetteType -> Hamilton][[All, 1]];
									tipsThatCanAspirate = Select[potentialTips, tipsCanAspirateQCoreHamilton[#, collectionContainerPacket, fetchPacketFromFastAssoc[#, fastAssoc], Null]&];

									FirstOrDefault[tipsThatCanAspirate]
								]
							],
							splitVolumes
						]
					]
				]
			],
			{resolvedVolumes, resolvedCollectionContainerLabel, resolvedFiltrateContainerLabel, collectionContainerModelPackets}
		],
		(* WashFlowThrough *)
		MapThread[
			Function[{washRetentate, washVolumes, numWashes, collectionContainerLabel, flowThroughContainerLabel, collectionContainerPacket},
				If[Not[roboticQ] || Not[washRetentate],
					Nothing,
					MapThread[
						Function[{washVolume, numberOfWashesOneBuffer, flowThroughLabel},
							If[NullQ[washVolume] || MatchQ[collectionContainerLabel, flowThroughLabel],
								Nothing,
								ConstantArray[
									Map[
										Function[volume,
											Module[{potentialTips, tipsThatCanAspirate},
												(* Get the tips that can actually reach the bottom *)
												(* tipsCanAspirateQCoreHamilton is a helper from ExperimentTransfer that does this same thing *)
												(* Doing FirstOrDefault for resolvedSterile because this should be the same for everything no matter what in robotic anyway *)
												potentialTips = TransferDevices[Model[Item, Tips], volume, Sterile -> FirstOrDefault[resolvedSterile], PipetteType -> Hamilton][[All, 1]];
												tipsThatCanAspirate = Select[potentialTips, tipsCanAspirateQCoreHamilton[#, collectionContainerPacket, fetchPacketFromFastAssoc[#, fastAssoc], Null]&];

												FirstOrDefault[tipsThatCanAspirate]
											]
										],
										splitVolumesBy970[washVolume]
									],
									numberOfWashesOneBuffer
								]
							]
						],
						{washVolumes, numWashes, flowThroughContainerLabel}
					]
				]
			],
			{resolvedWashRetentate, resolvedRetentateWashVolume, resolvedNumberOfRetentateWashes, resolvedCollectionContainerLabel, resolvedWashFlowThroughContainerLabel, collectionContainerModelPackets}
		]
	}];

	(* Get all the pipetting parameters from the call above *)
	resolvedPipettingParameters = Map[
		(* have to do this Null thing right now because for whatever reason resolveTransferRoboticPrimitive isn't actually resolving DispenseMixVolume/AspirationMixVolume; once that is no longer the case (is it now?) then we can remove that *)
		# -> (Lookup[combinedMapThreadFriendlyOptions, #, Null] /. _?MissingQ :> Null)&,
		pipettingOptionNames
	];

	(* Add the sample prep options to the options being passed into resolveAliquotOptions *)
	optionsForAliquot = ReplaceRule[myOptions, resolvedSamplePrepOptions];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentFilter,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts -> Null,
			RequiredAliquotContainers -> Automatic,
			AllowSolids -> False,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests},
			AliquotWarningMessage -> "because the given samples are not compatible with the chosen filtration type. If aliquoting is not desired, please choose a different filtration type."
		],
		{resolveAliquotOptions[
			ExperimentFilter,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts -> Null,
			RequiredAliquotContainers -> Automatic,
			AllowSolids -> False,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> Result,
			AliquotWarningMessage -> "because the given samples are not compatible with the chosen filtration type. If aliquoting is not desired, please choose a different filtration type."
		], {}}
	];



	(* Gather all the resolved options together *)
	(* Doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Preparation -> resolvedPreparation,
			FiltrationType -> resolvedFiltrationType,
			Instrument -> resolvedInstrument,
			Syringe -> resolvedSyringe,
			FlowRate -> resolvedFlowRate,
			PoreSize -> resolvedPoreSize,
			MolecularWeightCutoff -> resolvedMolecularWeightCutoff,
			PrefilterPoreSize -> resolvedPrefilterPoreSize,
			MembraneMaterial -> resolvedMembraneMaterial,
			PrefilterMembraneMaterial -> resolvedPrefilterMembraneMaterial,
			Filter -> resolvedFilter,
			FilterPosition -> resolvedFilterPosition,
			FilterHousing -> resolvedFilterHousing,
			FiltrateContainerOut -> groupedFiltrateContainersOut,
			FiltrateDestinationWell -> resolvedFiltrateDestinationWell,
			SampleOut -> resolvedSampleOut,
			SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
			Intensity -> resolvedIntensity,
			Time -> resolvedTime,
			FilterUntilDrained -> resolvedFilterUntilDrained,
			MaxTime -> resolvedMaxTime,
			Temperature -> resolvedTemperature,
			Sterile -> resolvedSterile,
			CollectionContainer -> resolvedCollectionContainer,
			RetentateCollectionContainer -> resolvedRetentateCollectionContainer,
			CollectRetentate -> resolvedCollectRetentate,
			WashRetentate -> resolvedWashRetentate,
			RetentateWashMix -> resolvedRetentateWashMix,
			RetentateWashBuffer -> resolvedRetentateWashBuffer,
			RetentateWashVolume -> resolvedRetentateWashVolume,
			NumberOfRetentateWashes -> resolvedNumberOfRetentateWashes,
			RetentateWashDrainTime -> resolvedRetentateWashDrainTime,
			RetentateWashCentrifugeIntensity -> resolvedRetentateWashCentrifugeIntensity,
			NumberOfRetentateWashMixes -> resolvedNumberOfRetentateWashMixes,
			RetentateCollectionMethod -> resolvedRetentateCollectionMethod,
			ResuspensionVolume -> resolvedResuspensionVolume,
			ResuspensionBuffer -> resolvedResuspensionBuffer,
			NumberOfResuspensionMixes -> resolvedResuspensionNumberOfMixes,
			(* because {{Null, Null}} technically doesn't match the option pattern which we want to avoid for template reasons *)
			RetentateContainerOut -> Replace[resolvedRetentateContainersOut, {{Null, Null} -> Null}, {1}],
			RetentateDestinationWell -> resolvedRetentateDestinationWell,
			FilterStorageCondition -> resolvedFilterStorageCondition,
			EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation],
			Target -> Lookup[myOptions, Target],
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			FiltrateLabel -> resolvedFiltrateLabel,
			FiltrateContainerLabel -> resolvedFiltrateContainerLabel,
			RetentateLabel -> resolvedRetentateLabel,
			RetentateContainerLabel -> resolvedRetentateContainerLabel,
			SampleOutLabel -> resolvedSampleOutLabel,
			ContainerOutLabel -> resolvedContainerOutLabel,
			ResuspensionBufferLabel -> finalResolvedResuspensionBufferLabel,
			ResuspensionBufferContainerLabel -> finalResolvedResuspensionBufferContainerLabel,
			RetentateWashBufferLabel -> finalResolvedRetentateWashBufferLabel,
			RetentateWashBufferContainerLabel -> finalResolvedRetentateWashBufferContainerLabel,
			PrewetFilter -> resolvedPrewetFilter,
			PrewetFilterTime -> resolvedPrewetFilterTime,
			PrewetFilterBufferVolume -> resolvedPrewetFilterBufferVolume,
			PrewetFilterCentrifugeIntensity -> resolvedPrewetFilterCentrifugeIntensity,
			PrewetFilterBuffer -> resolvedPrewetFilterBuffer,
			PrewetFilterBufferLabel -> finalResolvedPrewetFilterBufferLabel,
			PrewetFilterContainerOut -> resolvedPrewetFilterContainerOut,
			PrewetFilterContainerLabel -> resolvedPrewetFilterContainerLabel,
			NumberOfFilterPrewettings -> resolvedNumberOfFilterPrewettings,
			WashFlowThroughLabel -> resolvedWashFlowThroughLabel,
			WashFlowThroughContainerLabel -> resolvedWashFlowThroughContainerLabel,
			WashFlowThroughContainer -> resolvedWashFlowThroughContainer,
			WashFlowThroughDestinationWell -> resolvedWashFlowThroughDestinationWell,
			WashFlowThroughStorageCondition -> resolvedWashFlowThroughStorageCondition,
			CollectOccludingRetentate -> resolvedCollectOccludingRetentate,
			OccludingRetentateContainer -> resolvedOccludingRetentateContainer,
			OccludingRetentateDestinationWell -> resolvedOccludingRetentateDestWell,
			OccludingRetentateContainerLabel -> resolvedOccludingRetentateContainerLabel,
			CounterbalanceWeight -> Lookup[myOptions, CounterbalanceWeight] /. {Automatic -> Null},
			Operator -> resolvedOperator,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			(* robotic options *)
			FilterLabel -> resolvedFilterLabel,
			CollectionContainerLabel -> resolvedCollectionContainerLabel,
			Volume -> If[Not[roboticQ],
				ConstantArray[Null,Length[myInputSamples]],
				resolvedVolumes
			],
			Pressure -> resolvedPressure,
			RetentateWashPressure -> Replace[resolvedRetentateWashPressure, {{Null..} :> Null}, {1}],
			Counterweight -> resolvedCounterweight,
			WashAndResuspensionTips -> Flatten[{retentateWashTips, resuspensionTips}],
			FiltrateContainerOutTips -> filtrateContainerOutTips,
			resolvedPipettingParameters,
			WorkCell -> resolvedWorkCell
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{nonLiquidSampleInvalidInputs, discardedInvalidInputs}]];

	(* Gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOption,
		typeInstrumentInvalidOptions,
		typeAndSyringeInvalidOptions,
		filterTypeMismatchInvalidOptions,
		filterMaterialMismatchInvalidOptions,
		filterPoreSizeMismatchInvalidOptions,
		filterMaxVolumeMismatchInvalidOptions,
		filterInletConnectionTypeMismatchInvalidOptions,
		filterAirPressureDimensionsErrorsOptions,
		badCentrifugeErrorsOptions,
		noUsableCentrifugeErrorsOptions,
		noFilterAvailableInvalidOptions,
		invalidFiltrateDestWellPositionOptions,
		filtrateContainerOverOccupiedOptions,
		filtrateContainerOutMismatchedIndexOptions,
		collectRetentateInvalidOptions,
		retentateCollectionMethodInvalidOptions,
		retentateContainerOutMismatchedIndexOptions,
		retentateContainerOverOccupiedOptions,
		invalidRetentateDestWellPositionOptions,
		poreSizeandMWCOInvalidOptions,
		prefilterOptionMismatchInvalidOptions,
		filterMWCOMismatchInvalidOptions,
		incompatibleFilterTimeWithTypeOptions,
		incompatibleFilterTimeOptions,
		filterHousingMismatchOptions,
		sterileInstrumentMismatchOptions,
		typeCentrifugeMismatchOptions,
		filtrateContainerOutMaxVolumeOptions,
		syringeMaxVolumeOptions,
		incorrectSyringeConnectionOptions,
		temperatureInvalidOptions,
		retentateWashCentrifugeIntensityTypeOptions,
		washRetentateTypeOptions,
		retentateWashMixInvalidOptions,
		retentateWashInvalidOptions,
		resuspensionVolumeTooHighOptions,
		containerLabelMismatchOptions,
		sampleLabelMismatchOptions,
		filtrateContainerLabelIndexMismatchOptions,
		retentateContainerLabelIndexMismatchOptions,
		flowRateMismatchOptions,
		retentateCollectionContainerInvalidOptions,
		centrifugeContainerDestInvalidOptions,
		transferCollectionMethodInvalidOptions,
		retentateContainerOutPlateInvalidOptions,
		intensityTooHighErrorOptions,
		typePressureMismatchErrorOptions,
		pressureTooHighErrorOptions,
		invalidPipettingParameterOptions,
		sameFilterConflictingErrorOptions,
		overOccupiedErrorOptions,
		destWellPositionErrorOptions,
		noCounterweightOptions,
		multipleMultipleInvalidOptions,
		collectionContainerPlateMismatchErrorOptions,
		prewetFilterMismatchOptions,
		prewetFilterCentrifugeIntensityTypeOptions,
		filterPositionDoesNotExistOptions,
		filterPositionInvalidOptions,
		occludingRetentateMismatchOptions,
		occludingRetentateNotSupportedOptions,
		numberOfFilterPrewettingsTooHighOptions,
		prewettingTypeMismatchOptions,
		collectionContainerMaxVolumeOptions,
		If[MatchQ[preparationResult, $Failed],
			{Preparation},
			Nothing
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];


	(* Get all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		missingVolumeTest,
		nonLiquidSampleTest,
		nameInvalidTest,
		typeInstrumentTest,
		typeAndSyringeTest,
		filterTypeMismatchInvalidTests,
		filterMaterialMismatchInvalidTests,
		filterPoreSizeMismatchInvalidTests,
		filterMaxVolumeMismatchInvalidTests,
		filterInletConnectionTypeMismatchInvalidTests,
		filterAirPressureDimensionsErrorTests,
		badCentrifugeErrorTests,
		noUsableCentrifugeErrorsTests,
		noFilterAvailableInvalidTest,
		invalidFiltrateDestWellPositionTest,
		filtrateContainerOverOccupiedTest,
		filtrateContainerOutMismatchedIndexTest,
		collectRetentateInvalidTest,
		retentateCollectionMethodInvalidTest,
		retentateContainerOutMismatchedIndexTest,
		retentateContainerOverOccupiedTest,
		invalidRetentateDestWellPositionTest,
		poreSizeandMWCOInvalidTest,
		prefilterOptionMismatchTests,
		filterMWCOMismatchInvalidTests,
		incompatibleFilterTimeWithTypeTests,
		incompatibleFilterTimeTests,
		filterHousingMismatchTest,
		sterileInstrumentMismatchTest,
		typeCentrifugeMismatchTest,
		sterileContainerOutMismatchTest,
		filtrateContainerOutMaxVolumeTest,
		syringeMaxVolumeTest,
		incorrectSyringeConnectionTest,
		temperatureInvalidTest,
		retentateWashCentrifugeIntensityTypeTest,
		washRetentateTypeTest,
		retentateWashMixInvalidTest,
		retentateWashInvalidTest,
		resuspensionVolumeTooHighTest,
		containerLabelMismatchTest,
		sampleLabelMismatchTest,
		filtrateContainerLabelIndexMismatchTest,
		retentateContainerLabelIndexMismatchTest,
		flowRateMismatchTest,
		retentateCollectionContainerInvalidTest,
		centrifugeContainerDestInvalidTest,
		transferCollectionMethodInvalidTest,
		retentateContainerOutPlateInvalidTest,
		intensityTooHighErrorTests,
		typePressureMismatchErrorTests,
		pressureTooHighErrorTests,
		transferTests,
		invalidPipettingParameterTests,
		sameFilterConflictingErrorTests,
		overOccupiedErrorTests,
		destWellPositionErrorTest,
		noCounterweightTest,
		multipleMultipleInvalidTest,
		collectionContainerPlateMismatchErrorTests,
		prewetFilterMismatchTests,
		prewetFilterCentrifugeIntensityTypeTest,
		filterPositionDoesNotExistTest,
		filterPositionInvalidTest,
		occludingRetentateMismatchTest,
		numberOfFilterPrewettingsTooHighTest,
		prewettingTypeMismatchTest,
		occludingRetentateNotSupportedTest,
		collectionContainerMaxVolumeTest,
		allCompatibleMaterialsTests
	}], TestP];

	(* pending to add updatedExperimentFilterSimulation to the Result *)
	(* return our resolved options and/or tests *)
	outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}

];

(* ::Subsection:: *)
(*filterResourcePackets *)

DefineOptions[filterResourcePackets,
	Options :> {
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

(* Populate fields and make resources for samples and things we're using to filter *)
filterResourcePackets[mySamples: {ObjectP[Object[Sample]]..}, myUnresolvedOptions: {___Rule}, myResolvedOptions: {___Rule}, myCollapsedResolvedOptions: {___Rule}, myOptions: OptionsPattern[]] := Module[
	{
		outputSpecification,output,containersIn,containersInInternalDepth,samplesOut,containersInModels,
		cache,sterile,operator,filtrateContainerOut,sampleOut,
		resolvedPreparation,filtrationType,targets,filters,filterLabel,instruments,filterHousings,membraneMaterials,prefilterMembraneMaterials,poreSizes,prefilterPoreSizes,molecularWeightCutoffs, filterModelFilterTypes,
		intensities,times,volumes,pressures,temperatures,syringes, filterPackets, buchnerFunnelQs,
		needles,allResourceBlobs, safeOps, allIDs, protocolID, primitiveIDs,
		groupedOptions,defaultDestinationContainers, filterModelPackets, storageBufferQs,
		instrumentResources,samplesInResources,containersInResources,filtrateContainerOutResources,
		filterHousingResources,blowGunResource, membraneFilterDiameters, filterHousingTag,
		filterResources,tipResources,cleaningSolutionResources,syringeResources, washAndResuspensionTipResources,
		filtrateContainerOutTipResources,
		needleResources,instrumentTag,instrumentAndTimeRules,linklessFiltrateContainerOut,mergedInstrumentTimes, filterPacketsAndContainers,
		gatheredFilterPacketsAndContainers, filterPacketReplaceRules, target,
		filtrateDestinationWell, retentateContainerOut, retentateDestinationWell, filterStorageConditions,
		collectionContainers, filterUntilDrained, maxTimes, collectRetentate,
		retentateCollectionMethod, washRetentate, retentateWashBuffer, retentateWashVolume, numRetentateWashes,
		retentateWashDrainTime, retentateWashCentrifugeIntensity,retentateWashPressure, retentateWashMix, numRetentateWashMixes,
		resuspensionBuffer, resuspensionVolume, resuspensionNumberOfMixes, retentateCollectionContainers,
		allSortedBuchnerFunnels, allSortedFilterAdapters, buchnerFunnelsToUse, tubingAdapterResource,
		allVacuumFlaskPackets, collectionContainerPackets, collectionContainerModelPackets, filterAdaptersToUse,
		counterbalanceWeights, simulation, protocolPacket,unitOperationPackets, fulfillable, frqTests, previewRule, optionsRule,testsRule, resultRule,
		gatherTests, messages, buchnerFunnelResources, filterAdapterResources, groupedBuffersAndVolumes,
		resuspensionBufferResources, prewetFilterBufferResources, washFlowThroughContainerResources, washFlowThroughContainerResourceReplaceRules,
		expandedRetentateWashBufferLabel, expandedRetentateWashBufferContainerLabel, expandedRetentateWashBufferObjs, liquidHandlerContainers,
		bufferVolumeReplaceRules, retentateWashBufferResources, protocolPacketMinusRequiredObjects,
		retentateContainerLabel, retentateContainerOutResources, linklessRetentateContainerOut, sampleLabel,
		sampleContainerLabel, filtrateLabel, filtrateContainerLabel, retentateLabel, sampleOutLabel, containerOutLabel,collectionContainerLabel,
		simulatedSamples, updatedSimulation, simulatedSampleContainers, fakeContainersOut, expandRetentateWashOptions,
		expandedRetentateWashBuffer, expandedRetentateWashVolume, expandedRetentateWashDrainTime,
		expandedRetentateWashCentrifugeIntensity, expandedRetentateWashMix, expandedNumRetentateWashMixes,expandedRetentateWashPressures,
		resuspensionBufferObjs, spatulaResource,filtrateSampleResources,retentateSampleResources,collectionContainerResources,resuspensionBufferContainerResources,retentateWashBufferContainerResources,counterweightResourceRules, groupedFilters, filtersTimesIntensities,
		filterResourceLabelReplaceRules, filterResourceLabels, filterResourceIndices, fakeFilterPositions,
		primitiveRetentateWashBatchLengths, primitiveRetentateWashBuffers, primitiveRetentateWashVolume,
		primitiveRetentateWashDrainTime, primitiveRetentateWashCentrifugeIntensity, primitiveRetentateWashMix,
		primitiveNumberOfRetentateWashMixes, primitiveWashRetentate, flowRates, schlenkLineResources,
		filtrateContainerModelPackets, allSelfStandingContainers, destinationRackResources, samplesOutStorage,
		allSelfStandingContainersOrEmptyList,
		collectionContainerResourceReplaceRules, resuspensionBufferLabel, resuspensionBufferContainerLabel,
		retentateWashBufferLabel, retentateWashBufferContainerLabel, primitiveRetentateWashBufferLabels,
		primitiveRetentateWashBufferContainerLabels, retentateWashBufferObjs, counterweight, resuspensionBufferPackets,retentateWashBufferPackets,
		resuspensionBufferContainerResourceRules, retentateWashBufferContainerResourceRules, prewetFilter,
		prewetFilterTime, prewetFilterBufferVolume, prewetFilterCentrifugeIntensity, prewetFilterBuffer,
		prewetFilterContainerOut, prewetFilterBufferLabel, prewetFilterContainerLabel, prewetFilterBufferPackets,
		prewetFilterContainerResources, primitiveNumberOfRetentateWashes, filterPositions,
		fastAssoc, washFlowThroughLabel, washFlowThroughContainerLabel, washFlowThroughContainer, washFlowThroughDestinationWell,
		washFlowThroughStorageCondition, primitiveWashFlowThroughLabel, primitiveWashFlowThroughContainerLabel,
		primitiveWashFlowThroughContainer, primitiveWashFlowThroughDestinationWell, primitiveWashFlowThroughStorageCondition,
		expandedWashFlowThroughLabel, expandedWashFlowThroughContainerLabel, expandedWashFlowThroughContainer,
		expandedWashFlowThroughDestinationWell, expandedWashFlowThroughStorageCondition,
		expandedWashFlowThroughContainerObjs, washFlowThroughResources, collectOccludingRetentate, occludingRetentateContainer,
		occludingRetentateDestinationWell, occludingRetentateContainerLabel, occludingRetentateContainerResourceReplaceRules,
		occludingRetentateContainerResources, numberOfFilterPrewettings, prewetFilterBufferVolumeWithReplicates
	},

	(* Get the safe options for this function *)
	safeOps = SafeOptions[filterResourcePackets, ToList[myOptions]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* Simulate the sample preparation stuff so we have the right containers if we are aliquoting *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentFilter, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* This is the only real Download I need to do, which is to get the simulated sample containers *)
	simulatedSampleContainers = Download[simulatedSamples, Container[Object], Cache -> cache, Simulation -> updatedSimulation];

	(* Lookup option values *)
	{
		sterile,
		operator,
		filtrateContainerOut,
		filtrateDestinationWell,
		retentateContainerOut,
		retentateDestinationWell,
		sampleOut,
		resolvedPreparation,
		filtrationType,
		targets,
		filters,
		filterPositions,
		filterLabel,
		filterStorageConditions,
		instruments,
		filterHousings,
		membraneMaterials,
		prefilterMembraneMaterials,
		poreSizes,
		prefilterPoreSizes,
		molecularWeightCutoffs,
		intensities,
		times,
		volumes,
		pressures,
		temperatures,
		syringes,
		flowRates,
		collectionContainers,
		retentateCollectionContainers,
		filterUntilDrained,
		maxTimes,
		collectRetentate,
		retentateCollectionMethod,
		washRetentate,
		retentateWashBuffer,
		retentateWashVolume,
		numRetentateWashes,
		retentateWashDrainTime,
		retentateWashCentrifugeIntensity,
		retentateWashPressure,
		retentateWashMix,
		numRetentateWashMixes,
		resuspensionBuffer,
		resuspensionVolume,
		resuspensionNumberOfMixes,
		counterbalanceWeights,
		target,
		samplesOutStorage,
		prewetFilter,
		prewetFilterTime,
		prewetFilterBufferVolume,
		prewetFilterCentrifugeIntensity,
		prewetFilterBuffer,
		prewetFilterContainerOut,
		numberOfFilterPrewettings,
		washFlowThroughContainer,
		washFlowThroughDestinationWell,
		washFlowThroughStorageCondition,
		sampleLabel,
		sampleContainerLabel,
		filtrateLabel,
		filtrateContainerLabel,
		retentateLabel,
		retentateContainerLabel,
		sampleOutLabel,
		containerOutLabel,
		collectionContainerLabel,
		resuspensionBufferLabel,
		resuspensionBufferContainerLabel,
		retentateWashBufferLabel,
		retentateWashBufferContainerLabel,
		counterweight,
		prewetFilterBufferLabel,
		prewetFilterContainerLabel,
		washFlowThroughLabel,
		washFlowThroughContainerLabel,
		collectOccludingRetentate,
		occludingRetentateContainer,
		occludingRetentateDestinationWell,
		occludingRetentateContainerLabel
	} = Lookup[
		myResolvedOptions,
		{
			Sterile,
			Operator,
			FiltrateContainerOut,
			FiltrateDestinationWell,
			RetentateContainerOut,
			RetentateDestinationWell,
			SampleOut,
			Preparation,
			FiltrationType,
			Target,
			Filter,
			FilterPosition,
			FilterLabel,
			FilterStorageCondition,
			Instrument,
			FilterHousing,
			MembraneMaterial,
			PrefilterMembraneMaterial,
			PoreSize,
			PrefilterPoreSize,
			MolecularWeightCutoff,
			Intensity,
			Time,
			Volume,
			Pressure,
			Temperature,
			Syringe,
			FlowRate,
			CollectionContainer,
			RetentateCollectionContainer,
			FilterUntilDrained,
			MaxTime,
			CollectRetentate,
			RetentateCollectionMethod,
			WashRetentate,
			RetentateWashBuffer,
			RetentateWashVolume,
			NumberOfRetentateWashes,
			RetentateWashDrainTime,
			RetentateWashCentrifugeIntensity,
			RetentateWashPressure,
			RetentateWashMix,
			NumberOfRetentateWashMixes,
			ResuspensionBuffer,
			ResuspensionVolume,
			NumberOfResuspensionMixes,
			CounterbalanceWeight,
			Target,
			SamplesOutStorageCondition,
			PrewetFilter,
			PrewetFilterTime,
			PrewetFilterBufferVolume,
			PrewetFilterCentrifugeIntensity,
			PrewetFilterBuffer,
			PrewetFilterContainerOut,
			NumberOfFilterPrewettings,
			WashFlowThroughContainer,
			WashFlowThroughDestinationWell,
			WashFlowThroughStorageCondition,
			SampleLabel,
			SampleContainerLabel,
			FiltrateLabel,
			FiltrateContainerLabel,
			RetentateLabel,
			RetentateContainerLabel,
			SampleOutLabel,
			ContainerOutLabel,
			CollectionContainerLabel,
			ResuspensionBufferLabel,
			ResuspensionBufferContainerLabel,
			RetentateWashBufferLabel,
			RetentateWashBufferContainerLabel,
			Counterweight,
			PrewetFilterBufferLabel,
			PrewetFilterContainerLabel,
			WashFlowThroughLabel,
			WashFlowThroughContainerLabel,
			CollectOccludingRetentate,
			OccludingRetentateContainer,
			OccludingRetentateDestinationWell,
			OccludingRetentateContainerLabel
		}
	];

	(* Get the sample and buffer packets with container and model and volume *)
	{
		resuspensionBufferPackets,
		retentateWashBufferPackets,
		prewetFilterBufferPackets
	} = Quiet[Download[
		{
			resuspensionBuffer,
			Flatten[retentateWashBuffer],
			prewetFilterBuffer
		},
		Packet[Container, Model, Volume],
		Cache -> cache,
		Simulation -> simulation
	], {Download::FieldDoesntExist, Download::MissingCacheField}];

	(* Pull out the container the sample is in, and the internal depth  *)
	containersIn = Download[Map[
		fastAssocLookup[fastAssoc, #, Container]&,
		mySamples
	], Object];
	containersInInternalDepth = Map[
		fastAssocLookup[fastAssoc, #, {Model, InternalDepth}]&,
		containersIn
	];

	(* Get the ContainersIn models *)
	containersInModels = Download[fastAssocLookup[fastAssoc, #, Model], Object]& /@ containersIn;

	(* Samples out *)
	samplesOut = Link[#, Protocols]& /@ Lookup[myResolvedOptions, SampleOut];

	(* If doing syringe filtration, we'll need a needle to extract the sample from the source container
	 figure out which needle to use to get the sample out of the source container  *)
	needles = MapThread[
		If[MatchQ[#1, Syringe],
			Switch[#2,
				(* Reusable Stainless Steel Non-Coring 4 in x 18G Needle *)
				RangeP[0 Inch, 4 Inch], Model[Item, Needle, "id:XnlV5jmbZZpn"],
				(* Reusable Stainless Steel Non-Coring 6 in x 18G Needle *)
				RangeP[4 Inch, 6 Inch], Model[Item, Needle, "id:L8kPEjNLDD1A"],
				(* Reusable Stainless Steel Non-Coring 12 in x 18G Needle *)
				GreaterP[6 Inch], Model[Item, Needle, "id:rea9jl1orrdx"],
				(* If it's a plate, use the short needle *)
				_, Model[Item, Needle, "id:rea9jl1orrdx"]
			],
			Null
		]&,
		{filtrationType, containersInInternalDepth}
	];

	(* For Manual preparation, make a list of tags for each unique instrument *)
	instrumentTag = Map[
		# -> ToString[Unique[]]&,
		DeleteDuplicates[instruments]
	];

	(* For Robotic preparation, make instrument and time rules to merge later  *)
	instrumentAndTimeRules = MapThread[
		#1 -> #2&,
		(* Check our filter label to make sure we only count once for each filter. That is because we may be filtering plate and there is no way that we need to count time by sample *)
		Transpose@DeleteDuplicatesBy[
			Transpose@{instruments, times, filterLabel},
			Last
		]
	];
	(* Merge the instrument and time rules *)
	mergedInstrumentTimes = Merge[instrumentAndTimeRules, Total];

	(* Make instrument resources *)
	(* For Manual preparation, do this trick with the instrument tags to ensure we don't have duplicate instrument resources *)
	(* For Robotic preparation, 1.2 * total time is a little hokey but I think gives us a little more wiggle room of how long it will actually take *)
	instrumentResources = If[MatchQ[resolvedPreparation,Manual],
		Map[
			Link[Resource[Name -> (# /. instrumentTag), Instrument -> #, Time -> 5 Minute]]&,
			instruments
		],
		Module[{lookup},
			(* Build a Instrument->Resource Lookup *)
			lookup=KeyValueMap[
				If[NullQ[#1],
					#1 -> Null,
					#1 -> Resource[Instrument -> #1, Time -> 1.2 * ReplaceAll[#2, {Null -> 1Minute}], Name -> ToString[Unique[]]]
				]&,
				mergedInstrumentTimes
			];

			(* Return all instrument resources *)
			instruments/.lookup
		]
	];

	(* Make a list of tags for each unique filter housing *)
	filterHousingTag = Map[
		# -> ToString[Unique[]]&,
		DeleteDuplicates[Download[filterHousings, Object]]
	];

	(* Make resources for the filter housings *)
	filterHousingResources = Map[
		If[NullQ[#],
			Null,
			Link[Resource[Name -> (# /. filterHousingTag), Instrument -> #, Time -> 5 Minute]]
		]&,
		Download[filterHousings, Object]
	];

	(* If we're going to be using a filterhousing with a PeristalticPump, we'll need a blow gun to clean out the lines after *)
	blowGunResource = If[MemberQ[filterHousings, ObjectP[{Model[Instrument, FilterHousing], Object[Instrument, FilterHousing]}]],
		(* Model[Instrument, BlowGun, "Thumb Lever Blow Gun"] *)
		Link[Resource[Instrument -> Model[Instrument, BlowGun, "id:rea9jl1GaVeB"], Time -> 5 Minute]],
		Null
	];

	(* Get the default destination container models of the filters *)
	defaultDestinationContainers = Map[
		Function[{filter},
			Lookup[fetchPacketFromFastAssoc[filter, fastAssoc], DestinationContainerModel, Null] /. x_Link :> Download[x, Object]
		],
		filters
	];

	(* Group the filters and get positions for them *)
	{groupedFilters, fakeFilterPositions} = groupContainersOut[cache, {Automatic, #}& /@ Download[filters, Object], DestinationWell -> filterPositions, SamplesIn -> simulatedSamples, FastAssoc -> fastAssoc];

	(* Get the grouped filters where we break up things that are currently grouped if the Time or Intensity options are different *)
	filtersTimesIntensities = Transpose[{groupedFilters, intensities, times}];

	(* Make replace rules converting indices to unique values (thus, if we had the same model of filter but different intensities/times, we are still the same) *)
	filterResourceLabelReplaceRules = Map[
		# -> ToString[Unique[]]&,
		DeleteDuplicatesBy[filtersTimesIntensities, {#[[1]], EqualP[#[[2]]], EqualP[#[[3]]]}&]
	];
	filterResourceLabels = filtersTimesIntensities /. filterResourceLabelReplaceRules;

	(* Convert the resource labels to integers; this is admittedly really weird but just go with it *)
	filterResourceIndices = filterResourceLabels /. MapIndexed[
		#1 -> First[#2]&,
		DeleteDuplicates[filterResourceLabels]
	];

	(* Get the packets for the filters *)
	filterPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Download[filters, Object];

	(* Get the filter model packets *)
	filterModelPackets = Map[
		If[MatchQ[#, ObjectP[Model]],
			#,
			fetchPacketFromFastAssoc[Download[Lookup[#, Model], Object], fastAssoc]
		]&,
		filterPackets
	];

	(* Determine if StorageBuffer -> True for the filter *)
	storageBufferQs = TrueQ[#]& /@ Lookup[filterModelPackets, StorageBuffer];

	(* Get the filter type *)
	filterModelFilterTypes = Lookup[filterModelPackets, FilterType];

	(* Group the filters, containersInModels, and containersIn *)
	filterPacketsAndContainers = Transpose[{filterPackets, containersInModels, filterResourceLabels}];

	(* Group all the membrane filters together since those are going to be counted *)
	gatheredFilterPacketsAndContainers = GatherBy[filterPacketsAndContainers, If[MatchQ[Lookup[#[[1]], FilterType], Membrane], Lookup[#[[1]], Object], Unique[]]&];

	(* Make replace rules for filters indicating the required count *)
	filterPacketReplaceRules = Flatten[Map[
		Function[{packetContainerTrio},
			With[
				{
					filterPacket = packetContainerTrio[[1, 1]],
					containerInModel = packetContainerTrio[[1, 2]],
					filterResourceLabel = packetContainerTrio[[1, 3]]
				},
				Map[
					# -> Which[
						MatchQ[Lookup[filterPacket, FilterType], Membrane], Link[Resource[Sample -> Lookup[filterPacket, Object], Name -> ToString[packetContainerTrio], Amount -> Length[packetContainerTrio]]],
						MatchQ[Lookup[filterPacket, Object], ObjectReferenceP[containerInModel]], Link[Resource[Sample -> containerInModel]],
						True, Link[Resource[Name -> filterResourceLabel, Sample -> Lookup[filterPacket, Object]]]
					]&,
					packetContainerTrio
				]
			]
		],
		gatheredFilterPacketsAndContainers
	]];

	(* Use the replace rules to convert the gathered filters/packets/containers to filter resources *)
	filterResources = Replace[filterPacketsAndContainers, filterPacketReplaceRules, {1}];

	(* Make resources for tips *)
	(* mirroring what Transfer does here *)
	(* Note that since we can have volumes above 970 here, we need to make sure that if we're above it we use multiple tips *)
	tipResources = MapThread[
		If[NullQ[#1] || Not[VolumeQ[#2]],
			Null,
			Resource[Sample -> #1, Amount -> Ceiling[#2 / $MaxRoboticSingleTransferVolume], Name -> ToString[Unique[]]]
		]&,
		{Lookup[myResolvedOptions, Tips], Lookup[myResolvedOptions, Volume]}
	];
	washAndResuspensionTipResources = Map[
		If[NullQ[#],
			Nothing,
			Resource[Sample -> #, Amount -> 1, Name -> ToString[Unique[]]]
		]&,
		ToList[Lookup[myResolvedOptions, WashAndResuspensionTips]]
	];
	filtrateContainerOutTipResources = Map[
		If[NullQ[#],
			Nothing,
			Resource[Sample -> #, Amount -> 1, Name -> ToString[Unique[]]]
		]&,
		ToList[Lookup[myResolvedOptions, FiltrateContainerOutTips]]
	];

	(* Make resources for cleaning solution if *)
	cleaningSolutionResources = Map[
		If[MatchQ[#, ObjectP[{Model[Instrument, PeristalticPump], Object[Instrument, PeristalticPump]}]],
			Link[
				Resource[
					Name -> ToString[Unique[]],
					Sample -> Model[Sample, "id:8qZ1VWNmdLBD"], (* "Milli-Q water" *)
					Amount -> 1 Liter,
					Container -> PreferredContainer[1 Liter],
					RentContainer -> True
				]
			],
			Null
		]&,
		instruments
	];

	(* Make resources for the syringes and needles *)
	syringeResources = Map[If[NullQ[#], Null, Link[Resource[Name -> ToString[Unique[]], Sample -> #]]]&, syringes];
	needleResources = Map[If[NullQ[#], Null, Link[Resource[Name -> ToString[Unique[]], Sample -> #, Rent -> True]]]&, needles];

	(* NOTE: linking later since need this for the batching field (it's 2way link in ContainerIn/SampleIn and 1way link in the batching field *)
	samplesInResources = (Resource[Sample -> Download[#, Object]]&) /@ mySamples;
	containersInResources = (Resource[Sample -> Download[#, Object]]&) /@ containersIn;

	(* 1way or 2way link depending on whether the user provide a model or an object *)
	(* Note: filtrateContainerOutResources and linklessFiltrateContainerOut can be either resource blob or container model *)
	{filtrateContainerOutResources, linklessFiltrateContainerOut} = Transpose[MapThread[
		Function[{container, filter, filterResource, defaultDestination, filtrateContainerLabel, collectionContainerLabel},
			Which[
				(* If the filter and container out are the same thing, use the same resource *)
				(* Note that this link stripping is OK (we want to leave the Resource head)*)
				MatchQ[container, filter] && MatchQ[filter, ObjectP[Model]], {filterResource, filterResource /. {Link[x_] :> x}},
				MatchQ[container, filter], {Link[filterResource, Protocols], filterResource /. {Link[x_] :> x}},
				(* Now check whether the containerOut is the destination model of the filter AND has the same label as the CollectionContainer (assuming we have a CollectionContainer) AND that the container model is a component of a kit that also contains the filter. in this case, we DON'T want an additional resource because that'll be picked regardless using KitComponents *)
				And[
					MatchQ[container, ObjectP[Model]],
					MatchQ[container, ObjectP[defaultDestination]],
					(NullQ[collectionContainerLabel] || MatchQ[filtrateContainerLabel, collectionContainerLabel]),
					(* Note that this Flatten is doing a lot here; theroetically we could have a filter with multiple different kit products and multiple different collection containers *)
					(* If this happens, we could in theory end up in a weird state where we are assuming we will be picking one product in the future but actually will pick the other (since the Flatten smushes ALL the kits together) *)
					(* the problem is we don't really have a way to indicate "buy product 1 but not product 2 of the same model of container".  If we add that in the future we can change this.  As is this is probably fine and not likely to create issues *)
					With[{kitComponents = If[MatchQ[filter, ObjectP[Model]], Flatten[{fastAssocLookup[fastAssoc, filter, {KitProducts, KitComponents}]}], Flatten[{fastAssocLookup[fastAssoc, filter, {Model, KitProducts, KitComponents}]}]]},
						MatchQ[kitComponents, {__Association}] && MemberQ[Lookup[kitComponents, ProductModel], ObjectP[container]]
					]
				],
					{Link[container], container},
				MatchQ[container, ObjectP[Model]],
					{Link[Resource[Name -> filtrateContainerLabel, Sample -> container]], Resource[Name -> filtrateContainerLabel, Sample -> container]},
				True,
					{Link[Resource[Name -> filtrateContainerLabel, Sample -> container], Protocols], Resource[Name -> filtrateContainerLabel, Sample -> container]}
			]
		],
		{
			filtrateContainerOut[[All, 2]],
			filters,
			filterResources,
			defaultDestinationContainers,
			filtrateContainerLabel,
			collectionContainerLabel
		}
	]];

	(* Make the RetentateContainerOut resources; 1way or 2way link depending on whether the user provided a model or an object *)
	{retentateContainerOutResources, linklessRetentateContainerOut} = Transpose[MapThread[
		Function[{containerLabel, containerOutPair},
			Switch[containerOutPair,
				{_Integer, ObjectP[Object[Container]]}, {Link[Resource[Sample -> containerOutPair[[2]], Name -> containerLabel], Protocols], Resource[Sample -> containerOutPair[[2]], Name -> containerLabel]},
				{_Integer, ObjectP[Model[Container]]}, {Link[Resource[Sample -> containerOutPair[[2]], Name -> containerLabel]], Resource[Sample -> containerOutPair[[2]], Name -> containerLabel]},
				(* only if the container is Null (i.e., we aren't collecting the retentate) *)
				_, {Null, Null}
			]
		],
		{retentateContainerLabel, retentateContainerOut}
	]];

	(* Make the resources for the WashFlowThroughContainer *)
	washFlowThroughContainerResourceReplaceRules = Flatten[MapThread[
		Function[{containersPerSample, containerLabelsPerSample},
			MapThread[
				If[NullQ[#1] || NullQ[#2],
					Nothing,
					#2 -> Link[Resource[Name -> #2, Sample -> #1]]
				]&,
				{ToList@containersPerSample, ToList@containerLabelsPerSample}
			]
		],
		{washFlowThroughContainer, washFlowThroughContainerLabel}
	]];
	washFlowThroughContainerResources = washFlowThroughContainerLabel /. washFlowThroughContainerResourceReplaceRules;

	(* Get the packets for the filtrate container models *)
	filtrateContainerModelPackets = Map[
		If[MatchQ[#, ObjectP[Model[Container]]],
			fetchPacketFromFastAssoc[#, fastAssoc],
			fetchPacketFromFastAssoc[Download[Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Model], Object], fastAssoc]
		]&,
		Download[filtrateContainerOut[[All, 2]], Object]
	];

	(* Pull out the SelfStandingContainers field of the model packet *)
	allSelfStandingContainersOrEmptyList = ToList[Quiet[RackFinder[Lookup[filtrateContainerModelPackets,Object]]]];
	allSelfStandingContainers = If[MatchQ[allSelfStandingContainersOrEmptyList, {} | {Null}],
		ConstantArray[Null, Length[filtrationType]],
		allSelfStandingContainersOrEmptyList
	];

	(* Make resources for the rack holding the destination container *)
	destinationRackResources = MapThread[
		If[MatchQ[#1, Syringe] && MatchQ[Lookup[#2, SelfStanding], False] && MatchQ[#3, ObjectP[]],
			Resource[
				Sample -> Download[#3, Object],
				Rent -> True,
				Name -> (ToString[Download[#3, Object]] <>" destination rack")
			]
		]&,
		{filtrationType, filtrateContainerModelPackets, allSelfStandingContainers}
	];

	(* Figure out if we're using a buchner funnel or not (i.e., membrane filter with vacuum) *)
	buchnerFunnelQs = MapThread[
		MatchQ[#1, Vacuum] && MatchQ[#2, Membrane]&,
		{filtrationType, Lookup[filterPackets, FilterType]}
	];

	(* Get the filter diameter if it's a membrane filter *)
	membraneFilterDiameters = Map[
		If[MatchQ[Lookup[#, FilterType], Membrane],
			Lookup[#, Diameter],
			Null
		]&,
		filterPackets
	];

	(* Get the buchner funnels and filter adapters from the cache *)
	(* also sort them by their Diameter because that will help below *)
	allSortedBuchnerFunnels = SortBy[Cases[cache, PacketP[Model[Part, Funnel]]], Lookup[#, MouthDiameter]&];
	allSortedFilterAdapters = SortBy[Cases[cache, PacketP[Model[Part, FilterAdapter]]], Lookup[Lookup[#, OuterDiameter], Top]&];

	(* Use the smallest buchner funnel that fits the filter *)
	buchnerFunnelsToUse = MapThread[
		Function[{filterDiameter, buchnerFunnelQ},
			If[DistanceQ[filterDiameter] && buchnerFunnelQ,
				(* Note that allSortedBuchnerFunnels is already sorted from smallest diameter to biggest so this works fine *)
				SelectFirst[allSortedBuchnerFunnels, Lookup[#, MouthDiameter] > filterDiameter &, Null],
				Null
			]
		],
		{membraneFilterDiameters, buchnerFunnelQs}
	];

	(* Make a resource for the buchner funnels to use *)
	buchnerFunnelResources = Map[
		If[NullQ[#],
			Null,
			Link[Resource[Sample -> #]]
		]&,
		buchnerFunnelsToUse
	];

	(* Make a resource for the Buchner funnel tubing *)
	(* admittedly this is hard coding but this is the only tubing we have that would work here *)
	tubingAdapterResource = Map[
		If[#,
			Link[Resource[Sample -> Model[Plumbing, Tubing, "8mm Vacuum Tubing"], Name -> "Buchner Funnel Tubing"]],
			Null
		]&,
		buchnerFunnelQs
	];

	(* Make a resource for the schlenk line; this is separate from the VacuumPump *)
	schlenkLineResources = Map[
		If[#,
			Link[Resource[Instrument -> Model[Instrument, SchlenkLine, "High Tech Schlenk Line"], Name -> "Schlenk Line Resource"]],
			Null
		]&,
		buchnerFunnelQs
	];

	(* Get the packets for the vacuum flasks *)
	allVacuumFlaskPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ PreferredContainer[All, VacuumFlask -> True];

	(* Get the packets for the resolved collection container and model *)
	collectionContainerPackets = Map[
		If[MatchQ[#, ObjectP[]],
			fetchPacketFromFastAssoc[#, fastAssoc],
			Null
		]&,
		collectionContainers
	];
	collectionContainerModelPackets = Map[
		If[MatchQ[#, PacketP[Object[Container]]],
			fetchPacketFromFastAssoc[Download[Lookup[#, Model], Object], fastAssoc],
			#
		]&,
		collectionContainerPackets
	];

	(* Use the smallest filter adapter that fits the mouth of the collection container *)
	filterAdaptersToUse = MapThread[
		Function[{collectionContainerModelPacket, buchnerFunnelQ},
			If[MatchQ[collectionContainerModelPacket, PacketP[Model[Container, Vessel]]] && buchnerFunnelQ,
				SelectFirst[allSortedFilterAdapters, Lookup[Lookup[#, OuterDiameter], Top] > Lookup[collectionContainerModelPacket, Aperture]&, Null],
				Null
			]
		],
		{collectionContainerModelPackets, buchnerFunnelQs}
	];

	(* Make a resource for the filter adapters to use *)
	filterAdapterResources = Map[
		If[NullQ[#],
			Null,
			Link[Resource[Sample -> #]]
		]&,
		filterAdaptersToUse
	];

	(* Make a resource for a spatula if we are collecting retentate via transfer *)
	spatulaResource = If[MemberQ[retentateCollectionMethod, Transfer],
		Link[Resource[Sample -> Model[Item, Spatula, "Flat/Round Spatula"], Rent -> True, Name -> "Spatula resource"]],
		Null
	];

	(* Sample resources from simulation *)
	(* temporally not include this for manual *)
	filtrateSampleResources = Map[
		If[NullQ[#] || NullQ[simulation] || MissingQ[Lookup[Lookup[First[simulation], Labels], #]] || MatchQ[resolvedPreparation,Manual],
			Null,
			Resource[Name -> #, Sample -> Lookup[Lookup[First[simulation], Labels], #]]
		]&,
		Lookup[myResolvedOptions, FiltrateLabel]
	];
	retentateSampleResources = Map[
		If[NullQ[#] || NullQ[simulation] || MissingQ[Lookup[Lookup[First[simulation], Labels], #]] || MatchQ[resolvedPreparation,Manual],
			Null,
			Resource[Name -> #, Sample -> Lookup[Lookup[First[simulation], Labels], #]]
		]&,
		Lookup[myResolvedOptions, RetentateLabel]
	];
	washFlowThroughResources = Map[
		If[NullQ[#] || NullQ[simulation] || MissingQ[Lookup[Lookup[First[simulation], Labels], #]] || MatchQ[resolvedPreparation, Manual],
			Null,
			Resource[Name -> #, Sample -> Lookup[Lookup[First[simulation], Labels], #]]
		]&,
		Flatten[Lookup[myResolvedOptions, WashFlowThroughLabel]]
	];

	(* Make resources for the collection containers and wash flow through containers *)
	(* Need to check if collection container has the same label as the filtrate container out in which *)
	(* case we need to use the same resource to avoid duplicate resources. *)
	collectionContainerResourceReplaceRules = DeleteDuplicates[MapThread[
		Function[{collectionContainerLabel, collectionContainer, filtrateContainerLabel, filtrateContainerOutResource},
			Which[
				NullQ[collectionContainerLabel] || NullQ[collectionContainer],
					Nothing,
				MatchQ[collectionContainerLabel, filtrateContainerLabel],
					collectionContainerLabel -> filtrateContainerOutResource /. {Link[x_] :> x},
				True,
					collectionContainerLabel -> Resource[Name -> collectionContainerLabel, Sample -> collectionContainer]
			]
		],
		{Sequence @@ Lookup[myResolvedOptions, {CollectionContainerLabel, CollectionContainer, FiltrateContainerLabel}], filtrateContainerOutResources}
	]];
	collectionContainerResources = MapThread[
		If[NullQ[#1] || NullQ[#2],
			Link[#2],
			Link[#1 /. collectionContainerResourceReplaceRules]
		]&,
		{collectionContainerLabel, collectionContainers}
	];

	(* Make resources for the occluding retentate containers *)
	occludingRetentateContainerResourceReplaceRules = DeleteDuplicates[MapThread[
		If[NullQ[#1] || NullQ[#2],
			Nothing,
			#1 -> Resource[Name -> #1, Sample -> #2]
		]&,
		{occludingRetentateContainerLabel, occludingRetentateContainer}
	]];
	occludingRetentateContainerResources = MapThread[
		If[NullQ[#1] || NullQ[#2],
			Link[#2],
			Link[#1 /. occludingRetentateContainerResourceReplaceRules]
		]&,
		{occludingRetentateContainerLabel, occludingRetentateContainer}
	];

	(* Make the PreweFtilterContainerOut resources *)
	prewetFilterContainerResources = DeleteDuplicates[MapThread[
		If[NullQ[#1] || NullQ[#2],
			Nothing,
			#1 -> Resource[Name -> #1, Sample -> #2]
		]&,
		Lookup[myResolvedOptions, {PrewetFilterContainerLabel, PrewetFilterContainerOut}]
	]];

	(* Get the resources for all the resuspension buffers *)
	resuspensionBufferContainerResourceRules = MapThread[
		Function[{samplePacket, containerLabel, volume},
			Which[
				NullQ[containerLabel], Null,
				MatchQ[samplePacket, ObjectP[Object[Sample]]],
					containerLabel -> Resource[Sample -> Download[Lookup[samplePacket, Container], Object], Name -> containerLabel],
				MatchQ[samplePacket, ObjectP[Model[Sample]]],
					containerLabel -> Resource[Sample -> PreferredContainer[Lookup[samplePacket, Object],volume], Name -> containerLabel],
				True, Null
			]
		],
		{
			resuspensionBufferPackets,
			Lookup[myResolvedOptions, ResuspensionBufferContainerLabel],
			Lookup[myResolvedOptions, ResuspensionVolume]
		}
	];
	resuspensionBufferContainerResources = Lookup[myResolvedOptions, ResuspensionBufferContainerLabel] /. Cases[resuspensionBufferContainerResourceRules, _Rule];

	(* Get the resources for all the retentate wash buffers *)
	retentateWashBufferContainerResourceRules = MapThread[
		Function[{samplePacket, containerLabel, volume},
			Which[
				NullQ[containerLabel], Null,
				MatchQ[samplePacket, ObjectP[Object[Sample]]],
					containerLabel -> Resource[Sample -> Download[Lookup[samplePacket, Container], Object], Name -> containerLabel],
				MatchQ[samplePacket, ObjectP[Model[Sample]]],
				(* since retentate wash volume is multiple-multiple, we use the total volume to pick a container *)
					containerLabel -> Resource[Sample -> PreferredContainer[Lookup[samplePacket, Object], volume], Name -> containerLabel],
				True,
					containerLabel -> Resource[Sample -> Lookup[Lookup[First[simulation], Labels], containerLabel], Name -> containerLabel]
			]
		],
		{
			retentateWashBufferPackets,
			Flatten[Lookup[myResolvedOptions, RetentateWashBufferContainerLabel]],
			Flatten[Lookup[myResolvedOptions, RetentateWashVolume]]
		}
	];
	retentateWashBufferContainerResources = Lookup[myResolvedOptions, RetentateWashBufferContainerLabel] /. Cases[retentateWashBufferContainerResourceRules, _Rule];

	(* Make resources for the counterweights *)
	counterweightResourceRules = Map[
		(#1 -> Resource[Sample -> #1, Name -> CreateUUID[]])&,
		DeleteCases[DeleteDuplicates[Lookup[myResolvedOptions,Counterweight]],Null]
	];

	(* Get the resuspension buffer object *)
	resuspensionBufferObjs = Download[resuspensionBuffer, Object];
	retentateWashBufferObjs = Download[Flatten[retentateWashBuffer], Object];

	(* Get the amount of PrewetFilterBufferVolume after accounting for NumberOfFilterPrewettings *)
	(* Note that if we have StorageBuffer, the first iteration features NO buffer *)
	prewetFilterBufferVolumeWithReplicates = MapThread[
		Function[{prewetFilterQ, storageBufferQ, numPrewettings, prewettingVolume},
			Which[
				Not[prewetFilterQ] || NullQ[numPrewettings] || NullQ[prewettingVolume], Null,
				storageBufferQ && Not[MatchQ[numPrewettings, EqualP[1]]], (numPrewettings - 1) * prewettingVolume,
				(* this is only if we have NumberOfFilterPrewettings -> 1 and StorageBuffer -> True; don't make a 0 L resource for a liquid, that will cause errors *)
				storageBufferQ, Null,
				True, numPrewettings * prewettingVolume
			]
		],
		{prewetFilter, storageBufferQs, numberOfFilterPrewettings, prewetFilterBufferVolume}
	];

	(* Group the resources for retentate wash buffers and their volumes *)
	groupedBuffersAndVolumes = Merge[
		MapThread[
			If[NullQ[#1] || NullQ[#2] || NullQ[#3] || NullQ[#4],
				Nothing,
				{#1, #4} -> (#2 * #3)
			]&,
			{
				Flatten[{retentateWashBufferObjs, resuspensionBufferObjs, prewetFilterBuffer}],
				Flatten[{retentateWashVolume, resuspensionVolume, prewetFilterBufferVolumeWithReplicates}],
				Flatten[{numRetentateWashes, ConstantArray[1, Length[resuspensionVolume]], ConstantArray[1, Length[prewetFilterBufferVolumeWithReplicates]]}],
				Flatten[{retentateWashBufferLabel, resuspensionBufferLabel, prewetFilterBufferLabel}]
			}
		],
		Total
	];

	(* Get all the liquid handler compatible containers *)
	(* only bother doing this if we're doing Robotic *)
	liquidHandlerContainers = If[MatchQ[resolvedPreparation, Robotic],
		hamiltonAliquotContainers["Memoization"],
		{}
	];

	(* Make resources converting the merged association above to a correctly index matching value *)
	bufferVolumeReplaceRules = KeyValueMap[
		Last[#1] -> Which[
			(* Make sure we're not changing the container of the sample resource if we don't have to *)
			MatchQ[resolvedPreparation, Robotic] && #2 <= 200 Milliliter && MatchQ[First[#1], ObjectP[Object[Sample]]] && MemberQ[liquidHandlerContainers, fastAssocLookup[fastAssoc, First[#1], {Container, Model, Object}]],
				Link[Resource[Sample -> First[#1], Amount -> #2, Name -> Last[#1]]],
			MatchQ[resolvedPreparation, Robotic] && #2 <= 200 Milliliter,
				Link[Resource[Sample -> First[#1], Amount -> #2, Container -> PreferredContainer[#2, Type -> All, LiquidHandlerCompatible -> True], Name -> Last[#1]]],
			(* water resources need a container, others don't *)
			MatchQ[First[#1], WaterModelP],
				Link[Resource[Sample -> First[#1], Amount -> #2, Container -> PreferredContainer[#2], Name -> Last[#1]]],
			True,
				Link[Resource[Sample -> First[#1], Amount -> #2, Name -> Last[#1]]]
		]&,
		groupedBuffersAndVolumes
	];
	retentateWashBufferResources = retentateWashBufferLabel /. bufferVolumeReplaceRules;
	resuspensionBufferResources = resuspensionBufferLabel /. bufferVolumeReplaceRules;
	prewetFilterBufferResources = prewetFilterBufferLabel /. bufferVolumeReplaceRules;

	(* For cases where we're filtering via plate filter block, then need to group by like containers; otherwise don't care so it's Null *)
	fakeContainersOut = MapThread[
		If[MatchQ[#2, ObjectP[{Model[Container, Plate, Filter], Object[Container, Plate, Filter]}]] && MatchQ[#3, ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]],
			#1,
			Null
		]&,
		{filtrateContainerOutResources, filters, filterHousings}
	];

	(* Expand the retentate wash options to account for the NumberOfRetentateWashes option *)
	expandRetentateWashOptions[myRetentateOptions_List]:=MapThread[
		Function[{washQ, washRetentateOptionValue, numWashes},
			If[Not[TrueQ[washQ]] || NullQ[washRetentateOptionValue],
				Null,
				Flatten[MapThread[
					ConstantArray[#1, #2]&,
					{washRetentateOptionValue, numWashes}
				]]
			]
		],
		{washRetentate, myRetentateOptions, numRetentateWashes}
	];

	(* Expand all the retentate wash options with the function above *)
	expandedRetentateWashBufferObjs = expandRetentateWashOptions[retentateWashBuffer];
	expandedRetentateWashBuffer = expandRetentateWashOptions[retentateWashBufferResources];
	expandedRetentateWashBufferLabel = expandRetentateWashOptions[retentateWashBufferLabel];
	expandedRetentateWashBufferContainerLabel = expandRetentateWashOptions[retentateWashBufferContainerLabel];
	expandedRetentateWashVolume = expandRetentateWashOptions[retentateWashVolume];
	expandedRetentateWashDrainTime = expandRetentateWashOptions[retentateWashDrainTime];
	expandedRetentateWashCentrifugeIntensity = expandRetentateWashOptions[retentateWashCentrifugeIntensity];
	expandedRetentateWashMix = expandRetentateWashOptions[retentateWashMix];
	expandedNumRetentateWashMixes = MapThread[
		If[ListQ[#2],
			#2,
			ConstantArray[#2, Length[#1]]
		]&,
		{expandedRetentateWashMix, expandRetentateWashOptions[numRetentateWashMixes]}
	];
	expandedRetentateWashPressures = expandRetentateWashOptions[retentateWashPressure];

	(* Also expand all the wash flow through options *)
	expandedWashFlowThroughContainerObjs = expandRetentateWashOptions[washFlowThroughContainer];
	expandedWashFlowThroughLabel = expandRetentateWashOptions[washFlowThroughLabel];
	expandedWashFlowThroughContainerLabel = expandRetentateWashOptions[washFlowThroughContainerLabel];
	expandedWashFlowThroughContainer = expandRetentateWashOptions[washFlowThroughContainerResources];
	expandedWashFlowThroughDestinationWell = expandRetentateWashOptions[washFlowThroughDestinationWell];
	expandedWashFlowThroughStorageCondition = expandRetentateWashOptions[washFlowThroughStorageCondition];

	(* Group relevant options into batches (based on Instrument and Sterile option) *)
	(* NOTE THAT I HAVE TO REPLICATE THIS CODE TO SOME DEGREE IN filterPopulateWorkingSamples SO IF THE LOGIC CHANGES HERE CHANGE IT THERE TOO*)
	(* Note that we don't actually have to do any grouping if we're doing robotic, then we just want a list so we are just grouping by the preparation *)
	groupedOptions = groupByKey[
		{
			Preparation -> resolvedPreparation,
			(* this is the new way *)
			Sample -> Link /@ samplesInResources,
			(* this will get manually updated in the compiler.  Importantly, we shouldn't put the resource here because we're going to update manually later anyway *)
			WorkingSample -> Link /@ mySamples,
			WorkingContainer -> Link /@ containersIn,
			(* this is just for grouping *)
			(* for cases where we're filtering via plate filter block, or centrifuge plates, then need to group by like containers; otherwise don't care so it's Null *)
			FakeContainersOut -> fakeContainersOut,
			FiltrateContainerOut -> linklessFiltrateContainerOut,
			FiltrateDestinationWell -> filtrateDestinationWell,
			RetentateContainerOut -> linklessRetentateContainerOut,
			RetentateDestinationWell -> retentateDestinationWell,
			SampleLabel -> sampleLabel,
			SampleContainerLabel -> sampleContainerLabel,
			FiltrateLabel -> filtrateLabel,
			FiltrateContainerLabel -> filtrateContainerLabel,
			RetentateLabel -> retentateLabel,
			RetentateContainerLabel -> retentateContainerLabel,
			SampleOutLabel -> sampleOutLabel,
			ContainerOutLabel -> containerOutLabel,
			CollectionContainerLabel -> collectionContainerLabel,
			ResuspensionBufferLabel -> resuspensionBufferLabel,
			ResuspensionBufferContainerLabel -> resuspensionBufferContainerLabel,
			RetentateWashBufferLabel -> expandedRetentateWashBufferLabel,
			RetentateWashBufferContainerLabel -> expandedRetentateWashBufferContainerLabel,
			Instrument -> instrumentResources,
			SchlenkLine -> schlenkLineResources,
			Sterile -> sterile,
			FiltrationType -> filtrationType,
			Target -> targets,
			Filter -> filterResources,
			FilterLabel -> filterLabel,
			FilterPosition -> filterPositions,
			FilterHousing -> filterHousingResources,
			MembraneMaterial -> membraneMaterials,
			PrefilterMembraneMaterial -> prefilterMembraneMaterials,
			PoreSize -> poreSizes,
			PrefilterPoreSize -> prefilterPoreSizes,
			MolecularWeightCutoff -> molecularWeightCutoffs,
			Syringe -> syringeResources,
			FlowRate -> flowRates,
			Needle -> needleResources,
			CleaningSolution -> cleaningSolutionResources,
			Intensity -> intensities,
			CollectionContainer -> collectionContainerResources,
			RetentateCollectionContainer -> (Link /@ retentateCollectionContainers),
			Time -> times,
			Volume -> volumes,
			Pressure -> pressures,
			Temperature -> temperatures,
			FilterUntilDrained -> filterUntilDrained,
			MaxTime -> maxTimes,
			CollectRetentate -> collectRetentate,
			RetentateCollectionMethod -> retentateCollectionMethod,
			WashRetentate -> washRetentate,
			NumberOfRetentateWashes -> numRetentateWashes,
			(* Note that these guys are nested right now and will become flat later *)
			RetentateWashBuffer -> expandedRetentateWashBuffer,
			RetentateWashVolume -> expandedRetentateWashVolume,
			RetentateWashDrainTime -> expandedRetentateWashDrainTime,
			RetentateWashCentrifugeIntensity -> expandedRetentateWashCentrifugeIntensity,
			RetentateWashMix -> expandedRetentateWashMix,
			NumberOfRetentateWashMixes -> expandedNumRetentateWashMixes,
			RetentateWashPressures -> expandedRetentateWashPressures,
			ResuspensionBuffer -> resuspensionBufferResources,
			ResuspensionVolume -> resuspensionVolume,
			NumberOfResuspensionMixes -> resuspensionNumberOfMixes,

			PrewetFilter -> prewetFilter,
			PrewetFilterTime -> prewetFilterTime,
			PrewetFilterBufferVolume -> prewetFilterBufferVolume,
			PrewetFilterCentrifugeIntensity -> prewetFilterCentrifugeIntensity,
			PrewetFilterBuffer -> prewetFilterBufferResources,
			PrewetFilterBufferLabel -> prewetFilterBufferLabel,
			PrewetFilterContainerOut -> (prewetFilterContainerLabel /. prewetFilterContainerResources),
			PrewetFilterContainerLabel -> prewetFilterContainerLabel,
			NumberOfFilterPrewettings -> numberOfFilterPrewettings,

			WashFlowThroughLabel -> expandedWashFlowThroughLabel,
			WashFlowThroughContainerLabel -> expandedWashFlowThroughContainerLabel,
			WashFlowThroughContainer -> expandedWashFlowThroughContainer,
			WashFlowThroughDestinationWell -> expandedWashFlowThroughDestinationWell,
			WashFlowThroughStorageCondition -> expandedWashFlowThroughStorageCondition,

			CollectOccludingRetentate -> collectOccludingRetentate,
			OccludingRetentateContainer -> occludingRetentateContainerResources,
			OccludingRetentateDestinationWell -> occludingRetentateDestinationWell,
			OccludingRetentateContainerLabel -> occludingRetentateContainerLabel,

			BuchnerFunnel -> buchnerFunnelResources,
			FilterAdapter -> filterAdapterResources,
			VacuumTubing -> tubingAdapterResource,
			FilterTypes -> filterModelFilterTypes,
			FilterStorageCondition -> filterStorageConditions,
			CounterbalanceWeight -> counterbalanceWeights,
			DestinationRack -> (Link /@ destinationRackResources),
			Counterweight -> (Link /@ (counterweight /. counterweightResourceRules))
		},
		(* Note that we don't actually have to do any grouping if we're doing robotic, then we just want a list so we are just grouping by the preparation *)
		If[MatchQ[resolvedPreparation, Robotic],
			{},
			{Instrument, Sterile, FiltrationType, FilterHousing, FilterTypes, FakeContainersOut}
		]

	];

	(* Make IDs for the primitive packets and the protocol object *)
	allIDs = CreateID[Flatten[{Object[Protocol, Filter], ConstantArray[Object[UnitOperation, Filter], Length[groupedOptions]]}]];
	{protocolID, primitiveIDs} = {First[allIDs], Rest[allIDs]};

	(* Need to make the retentate wash fields now (RetentateWashBuffer etc) ; this is rather goofy but basically we have two ways of populating this for different branches of the procedure *)
	(* 1.) For cases where we filter one-by-one (PeristalticPump, Vacuum-BuchnerFunnel, Vacuum-BottleTop and I guess Syringe but those fields won't be populated here) *)
	(* 1a.) We make these fields be index matched to Sample such that if you have Sample -> {sample1, sample2, sample3}, RetentateWashBatchLengths -> {2, 3, 2}, RetentateWashBuffer -> {water, methanol, water, methanol, acetone, water, methanol} *)
	(* 1b.) This is because we can't parallelize this anyway *)
	(* 2.) For cases where we filter en masse (Centrifuge, Vacuum-FilterBlock, AirPressure); these are sort of transposed *)
	(* 2a.) We make these fields basically transposed such that if you have Sample -> {sample1, sample2, sample3}, RetentateBatchLengths -> {3, 3, 3}, RetentateWashBuffer -> {water, water, water, methanol, methanol, methanol, Null, acetone, Null} *)
	(* 2b.) Importantly here, RetentateBatchLengths is always ConstantArray[Length[Sample], maxNumRetentateWashesForAGivenSample] *)
	{
		primitiveWashRetentate,
		primitiveRetentateWashBatchLengths,
		primitiveRetentateWashBuffers,
		primitiveRetentateWashVolume,
		primitiveRetentateWashDrainTime,
		primitiveRetentateWashCentrifugeIntensity,
		primitiveRetentateWashMix,
		primitiveNumberOfRetentateWashMixes,
		primitiveRetentateWashBufferLabels,
		primitiveRetentateWashBufferContainerLabels,
		primitiveNumberOfRetentateWashes,
		primitiveWashFlowThroughLabel,
		primitiveWashFlowThroughContainerLabel,
		primitiveWashFlowThroughContainer,
		primitiveWashFlowThroughDestinationWell,
		primitiveWashFlowThroughStorageCondition
	} = If[MatchQ[resolvedPreparation,Manual],
		Transpose[Map[
			Function[{options},
				Module[
					{transposeQ, numSamples, maxNumRetentateWashes, padAndTranspose, washBuffer, primWashRetentate},

					(* Figure out if it's a filter type that's worth transposing *)
					transposeQ = Or[
						MatchQ[First[Lookup[options, FiltrationType]], Centrifuge | AirPressure],
						(MatchQ[Lookup[options, FilterHousing], {Link[_Resource]..}] && MatchQ[First[#][Instrument]& /@ Lookup[options, FilterHousing], {ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]..}])
					];

					(* Get the number of samples *)
					numSamples = Length[Lookup[options, Sample]];

					(* Get the maximum number of retentate washes *)
					maxNumRetentateWashes = Max[Length /@ Lookup[options, RetentateWashBuffer]];

					(* simple function that gets away from gross complicated calls over and over again *)
					padAndTranspose[myOptionName_Symbol]:=Flatten[Transpose[
						Map[
							(* this is obviously kind of absurd but NumberOfRetentateWashMixes is a special snowflake and we definitely want this to be Null and not {} *)
							PadRight[# /. {Null -> If[MatchQ[myOptionName, NumberOfRetentateWashMixes], Null, {}]}, maxNumRetentateWashes, Null]&,
							Lookup[options, myOptionName]
						]]
					];

					(* Get the retentate wash buffer here first because I need it to populate WashRetentate *)
					washBuffer = If[transposeQ,
						padAndTranspose[RetentateWashBuffer],
						Flatten[Lookup[options, RetentateWashBuffer]]
					];

					(* Get the value for WashRetentate; basically if we have a buffer then it's going to be True, and if not it's going to be False *)
					primWashRetentate = Replace[washBuffer, {Null -> False, _ -> True}, {1}];

					(* If we're transposing we have to be careful abofiltrateSampleObjectsWithDupesut if we are not washing at all; in that case we want to have *)
					(* Don't actually transpose if we aren't washing anything *)
					If[transposeQ && Not[MatchQ[primWashRetentate, {False..}]],
						{
							primWashRetentate,
							ConstantArray[numSamples, maxNumRetentateWashes],
							padAndTranspose[RetentateWashBuffer],
							padAndTranspose[RetentateWashVolume],
							padAndTranspose[RetentateWashDrainTime],
							padAndTranspose[RetentateWashCentrifugeIntensity],
							padAndTranspose[RetentateWashMix],
							padAndTranspose[NumberOfRetentateWashMixes],
							padAndTranspose[RetentateWashBufferLabel],
							padAndTranspose[RetentateWashBufferContainerLabel],
							padAndTranspose[NumberOfRetentateWashes] /. {Null -> 0},
							padAndTranspose[WashFlowThroughLabel],
							padAndTranspose[WashFlowThroughContainerLabel],
							padAndTranspose[WashFlowThroughContainer],
							padAndTranspose[WashFlowThroughDestinationWell],
							padAndTranspose[WashFlowThroughStorageCondition]
						},
						{
							Flatten[Lookup[options, WashRetentate]],
							Length /@ Lookup[options, RetentateWashBuffer],
							Flatten[Lookup[options, RetentateWashBuffer]],
							Flatten[Lookup[options, RetentateWashVolume]],
							Flatten[Lookup[options, RetentateWashDrainTime]],
							Flatten[Lookup[options, RetentateWashCentrifugeIntensity]],
							Flatten[Lookup[options, RetentateWashMix]],
							Flatten[Lookup[options, NumberOfRetentateWashMixes]],
							Flatten[Lookup[options, RetentateWashBufferLabel]],
							Flatten[Lookup[options, RetentateWashBufferContainerLabel]],
							Flatten[Lookup[options, NumberOfRetentateWashes]],
							Flatten[Lookup[options, WashFlowThroughLabel]],
							Flatten[Lookup[options, WashFlowThroughContainerLabel]],
							Flatten[Lookup[options, WashFlowThroughContainer]],
							Flatten[Lookup[options, WashFlowThroughDestinationWell]],
							Flatten[Lookup[options, WashFlowThroughStorageCondition]]
						}
					]
				]
			],
			groupedOptions[[All, 2]]
		]],
		ConstantArray[{}, 16]
	];

	(* Preparing protocol and unitOperationObject packets: Are we making resources for Manual or Robotic? *)
	(* Preparing unitOperationObject. Consider if we are making resources for Manual or Robotic *)
	unitOperationPackets = If[MatchQ[resolvedPreparation, Manual],
		Module[
			{filterPrimitives},
			filterPrimitives = MapThread[
				Function[{
					options,
					primWashRetentate,
					washBuffers,
					washVolume,
					washDrainTime,
					washIntensity,
					washMix,
					numWashMixes,
					retentateBufferLabels,
					retentateBufferContainerLabels,
					retentateWashBatchLengths,
					numRetentateWashes,
					washFlowThroughLabels,
					washFlowThroughContainerLabels,
					washFlowThroughContainers,
					washFlowThroughDestinationWells,
					washFlowThroughStorageConditions
				},
					Module[{nonHiddenOptions},
						(* Only include non-hidden options from Transfer. *)
						nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Filter]];
						Filter @@ ReplaceRule[
							Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
							{
								Sample -> Lookup[options, Sample],
								(* these are single fields since we grouped by them *)
								Instrument -> First[Lookup[options, Instrument]],
								Sterile -> First[Lookup[options, Sterile]],
								FiltrationType -> First[Lookup[options, FiltrationType]],
								(* these are all multiple *)
								Target -> Lookup[options, Target],
								FiltrateContainerOut -> (Link /@ Lookup[options, FiltrateContainerOut]),
								FiltrateDestinationWell -> Lookup[options, FiltrateDestinationWell],
								RetentateContainerOut -> Lookup[options, RetentateContainerOut],
								RetentateDestinationWell -> Lookup[options, RetentateDestinationWell],
								SampleLabel -> Lookup[options, SampleLabel],
								SampleContainerLabel -> Lookup[options, SampleContainerLabel],
								FiltrateLabel -> Lookup[options, FiltrateLabel],
								FiltrateContainerLabel -> Lookup[options, FiltrateContainerLabel],
								RetentateLabel -> Lookup[options, RetentateLabel],
								RetentateContainerLabel -> Lookup[options, RetentateContainerLabel],
								SampleOutLabel -> Lookup[options, SampleOutLabel],
								ContainerOutLabel -> Lookup[options, ContainerOutLabel],
								ResuspensionBufferLabel -> Lookup[options, ResuspensionBufferLabel],
								ResuspensionBufferContainerLabel -> Lookup[options, ResuspensionBufferContainerLabel],
								Filter -> Lookup[options, Filter],
								FilterLabel -> Lookup[options, FilterLabel],
								FilterHousing -> Lookup[options, FilterHousing],
								MembraneMaterial -> Lookup[options, MembraneMaterial],
								PrefilterMembraneMaterial -> Lookup[options, PrefilterMembraneMaterial],
								PoreSize -> Lookup[options, PoreSize],
								PrefilterPoreSize -> Lookup[options, PrefilterPoreSize],
								MolecularWeightCutoff -> Lookup[options, MolecularWeightCutoff],

								Syringe -> Lookup[options, Syringe],
								DestinationRack -> Lookup[options, DestinationRack],
								FlowRate -> Lookup[options, FlowRate],
								Needle -> Lookup[options, Needle],
								Intensity -> Lookup[options, Intensity],
								CollectionContainer -> Lookup[options, CollectionContainer],
								CollectionContainerLabel -> Lookup[options, CollectionContainerLabel],
								RetentateCollectionContainer -> Lookup[options, RetentateCollectionContainer],
								Time -> Lookup[options, Time],
								Temperature -> Lookup[options, Temperature],
								FilterUntilDrained -> Lookup[options, FilterUntilDrained],
								MaxTime -> Lookup[options, MaxTime],
								CollectRetentate -> Lookup[options, CollectRetentate],
								RetentateCollectionMethod -> Lookup[options, RetentateCollectionMethod],
								WashRetentate -> primWashRetentate,
								(* Note that if we have a resource we can't actually store it in the RetentateWashBuffer field because that field is multiple multiple (the resource will go in RetentateWashBufferResources) *)
								RetentateWashBuffer -> Map[
									Function[{retentateWashValueOrNull},
										If[NullQ[retentateWashValueOrNull],
											Null,
											First[retentateWashValueOrNull][Sample]
										]
									],
									washBuffers
								],
								RetentateWashBufferResources -> Flatten[washBuffers],
								RetentateWashBufferLabel -> retentateBufferLabels,
								RetentateWashBufferContainerLabel -> retentateBufferContainerLabels,
								NumberOfRetentateWashes -> numRetentateWashes,
								RetentateWashVolume -> washVolume,
								RetentateWashDrainTime -> washDrainTime,
								RetentateWashCentrifugeIntensity -> washIntensity,
								RetentateWashMix -> washMix,
								NumberOfRetentateWashMixes -> numWashMixes,
								ResuspensionBuffer -> Lookup[options, ResuspensionBuffer],
								ResuspensionVolume -> Lookup[options, ResuspensionVolume],
								NumberOfResuspensionMixes -> Lookup[options, NumberOfResuspensionMixes],
								CounterbalanceWeight -> Lookup[options, CounterbalanceWeight],
								FilterStorageCondition -> Lookup[options, FilterStorageCondition],

								PrewetFilter -> Lookup[options, PrewetFilter],
								PrewetFilterTime -> Lookup[options, PrewetFilterTime],
								PrewetFilterBufferVolume -> Lookup[options, PrewetFilterBufferVolume],
								PrewetFilterCentrifugeIntensity -> Lookup[options, PrewetFilterCentrifugeIntensity],
								PrewetFilterBuffer -> Lookup[options, PrewetFilterBuffer],
								PrewetFilterBufferLabel -> Lookup[options, PrewetFilterBufferLabel],
								PrewetFilterContainerOut -> Lookup[options, PrewetFilterContainerOut],
								PrewetFilterContainerLabel -> Lookup[options, PrewetFilterContainerLabel],
								NumberOfFilterPrewettings -> Lookup[options, NumberOfFilterPrewettings],

								WashFlowThroughLabel -> washFlowThroughLabels,
								WashFlowThroughContainerLabel -> washFlowThroughContainerLabels,
								WashFlowThroughContainer -> Map[
									Function[{containerResourceOrNull},
										If[NullQ[containerResourceOrNull],
											Null,
											First[containerResourceOrNull][Sample]
										]
									],
									washFlowThroughContainers
								],
								WashFlowThroughContainerResources -> Flatten[washFlowThroughContainers],
								WashFlowThroughDestinationWell -> washFlowThroughDestinationWells,
								WashFlowThroughStorageCondition -> washFlowThroughStorageConditions,

								CollectOccludingRetentate -> Lookup[options, CollectOccludingRetentate],
								OccludingRetentateContainer -> Lookup[options, OccludingRetentateContainer],
								OccludingRetentateDestinationWell -> Lookup[options, OccludingRetentateDestinationWell],
								OccludingRetentateContainerLabel -> Lookup[options, OccludingRetentateContainerLabel],

								Volume -> Lookup[options, Volume],
								Pressure -> Lookup[options, Pressure],
								RetentateWashPressure -> Lookup[options, RetentateWashPressures],
								Counterweight -> Lookup[options, Counterweight],

								(* Developer fields *)
								BuchnerFunnel -> Lookup[options, BuchnerFunnel],
								CleaningSolution -> Lookup[options, CleaningSolution],
								FilterAdapter -> Lookup[options, FilterAdapter],
								FilterPosition -> Lookup[options, FilterPosition],
								RetentateWashBatchLengths -> retentateWashBatchLengths,
								SchlenkLine -> FirstOrDefault[Lookup[options, SchlenkLine]],
								Spatula -> If[MemberQ[Lookup[options, RetentateCollectionMethod], Transfer],
									spatulaResource,
									Null
								],
								VacuumTubing -> FirstOrDefault[Lookup[options, VacuumTubing]],
								(* need this because otherwise for some reason it makes this be {Null} and we don't want that *)
								DestinationWell -> {}
							}
						]
					]
				],
				{
					groupedOptions[[All, 2]],
					primitiveWashRetentate,
					primitiveRetentateWashBuffers,
					primitiveRetentateWashVolume,
					primitiveRetentateWashDrainTime,
					primitiveRetentateWashCentrifugeIntensity,
					primitiveRetentateWashMix,
					primitiveNumberOfRetentateWashMixes,
					primitiveRetentateWashBufferLabels,
					primitiveRetentateWashBufferContainerLabels,
					primitiveRetentateWashBatchLengths,
					primitiveNumberOfRetentateWashes,
					primitiveWashFlowThroughLabel,
					primitiveWashFlowThroughContainerLabel,
					primitiveWashFlowThroughContainer,
					primitiveWashFlowThroughDestinationWell,
					primitiveWashFlowThroughStorageCondition
				}
			];

			UploadUnitOperation[
				filterPrimitives,
				UnitOperationType -> Batched,
				Preparation -> Manual,
				FastTrack -> True,
				Upload -> False
			]
		],
		(* Robotic branch *)
		Module[
			{filterUnitOperationPacket, filterUnitOperationPacketWithLabeledObjects, containerOutResources, numberOfResuspensionTADMCurves,
				numberOfLoadingTADMCurves, numberOfRetentateWashTADMCurves, labelSampleAndFilterUnitOperationPackets,
				labelSampleUnitOperationPacket, newLabelSampleUO, oldLabelSampleSamples, oldLabelSampleContainers,
				oldLabelSamplePosition, oldLabelSampleContainerLabels, oldLabelSampleAmounts, oldResourceToNewResourceRules},

			(* Upload our UnitOperation with resources. *)
			labelSampleAndFilterUnitOperationPackets = Module[{nonHiddenOptions},

				(* get the new label sample unit operation if it exists; need to replace the models in it with the sample resources we've already created/simulated *)
				{newLabelSampleUO, oldResourceToNewResourceRules} = If[MatchQ[Lookup[myResolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}],
					generateLabelSampleUO[
						Lookup[myResolvedOptions, PreparatoryUnitOperations][[1, 1]],
						updatedSimulation,
						Join[samplesInResources, containersInResources]
					],
					{Null, {}}
				];

				(* Only include non-hidden options from Filter. *)
				nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Filter]];
				UploadUnitOperation[{
					If[NullQ[newLabelSampleUO], Nothing, newLabelSampleUO],
					Filter @@ Join[
						{
							Sample -> samplesInResources /. oldResourceToNewResourceRules
						},
						ReplaceRule[
							Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
							{
								Instrument -> instrumentResources,
								Filter -> filterResources,
								FiltrateContainerOut -> linklessFiltrateContainerOut,
								RetentateContainerOut -> linklessRetentateContainerOut,
								CollectionContainer -> (Lookup[myResolvedOptions, CollectionContainerLabel] /. collectionContainerResourceReplaceRules),
								PrewetFilterContainerOut -> (prewetFilterContainerLabel /. prewetFilterContainerResources),
								PrewetFilterBuffer -> prewetFilterBufferResources,
								ResuspensionBuffer -> resuspensionBufferResources,

								(* NOTE: RetentateWashBuffer is an N-Multiple so we have to store the resources in another field. *)
								RetentateWashBuffer -> retentateWashBuffer,
								RetentateWashBufferResources -> Flatten[retentateWashBufferResources],
								(* NOTE: WashFlowThroughContainer is an N-Multiple so we have to store the resources in another field. *)
								WashFlowThroughContainer -> washFlowThroughContainer,
								WashFlowThroughDestinationWell -> washFlowThroughDestinationWell,
								WashFlowThroughContainerResources -> Flatten[washFlowThroughContainerResources],
								Tips -> tipResources,
								WashAndResuspensionTips -> washAndResuspensionTipResources,
								FiltrateContainerOutTips -> filtrateContainerOutTipResources,
								Counterweight -> (counterweight /. counterweightResourceRules),
								FilterPosition -> filterPositions,

								(* need this because otherwise for some reason it makes this be {Null} and we don't want that *)
								DestinationWell -> {}
							}
						]
					]},
					Preparation -> Robotic,
					UnitOperationType -> Output,
					FastTrack -> True,
					Upload -> False
				]
			];
			(* split out the LabelSample and Filter UOs *)
			{labelSampleUnitOperationPacket, filterUnitOperationPacket} = If[Length[labelSampleAndFilterUnitOperationPackets] == 2,
				labelSampleAndFilterUnitOperationPackets,
				{Null, First[labelSampleAndFilterUnitOperationPackets]}
			];

			(* Need to determine how many TADM traces to expect for sample loading, retentate washing, and resuspension *)
			numberOfLoadingTADMCurves = MapThread[
				Function[{containerLabel, volumeReal, filterLabel, collectionContainerLabel, filtrateContainerLabel},
					Module[{splitVolume, numLoadingCurves, numFiltrateContainerCurves},

						(* Split the volume by 970 like liquid handlers do *)
						splitVolume = splitVolumesBy970[volumeReal];

						(* If the sample is not already in the filter (i.e., sample container label and filter label are different) then we have to do transfers to move the sample there *)
						(* the number of curves is 2x the values because *)
						numLoadingCurves = If[Not[MatchQ[containerLabel, filterLabel]],
							2 * Length[splitVolume],
							0
						];

						(* If the sample needs to be moved from the collection container to the filtrate container out (i.e., collectionContainerLabel and filtrateContainerLabel are different) then we have to do transfers to move the filtrate there *)
						numFiltrateContainerCurves = If[Not[MatchQ[collectionContainerLabel, filtrateContainerLabel]],
							2 * Length[splitVolume],
							0
						];

						numLoadingCurves + numFiltrateContainerCurves
					]
				],
				{
					Lookup[filterUnitOperationPacket, Replace[SampleContainerLabel]],
					Lookup[filterUnitOperationPacket, Replace[VolumeReal]],
					Lookup[filterUnitOperationPacket, Replace[FilterLabel]],
					Lookup[filterUnitOperationPacket, Replace[CollectionContainerLabel]],
					Lookup[filterUnitOperationPacket, Replace[FiltrateContainerLabel]]
				}
			];
			numberOfRetentateWashTADMCurves = MapThread[
				Function[{washVolumes, numWashes, collectionContainerLabel, flowThroughContainerLabel},
					Module[
						{numWashCurves, numFlowThroughTransferCurves},
						numWashCurves = If[NullQ[washVolumes],
							0,
							Total[MapThread[
								Length[splitVolumesBy970[#1]] * 2 * #2&,
								{washVolumes, numWashes}
							]]
						];

						numFlowThroughTransferCurves = If[NullQ[washVolumes],
							0,
							Total[MapThread[
								If[Not[MatchQ[collectionContainerLabel, #3]],
									Length[splitVolumesBy970[#1]] * 2 * #2,
									0
								]&,
								{washVolumes, numWashes, flowThroughContainerLabel}
							]]
						];

						numWashCurves + numFlowThroughTransferCurves
					]
				],
				{
					Lookup[filterUnitOperationPacket, Replace[RetentateWashVolume]],
					Lookup[filterUnitOperationPacket, Replace[NumberOfRetentateWashes]],
					Lookup[filterUnitOperationPacket, Replace[CollectionContainerLabel]],
					Lookup[filterUnitOperationPacket, Replace[WashFlowThroughContainerLabel]]
				}
			];
			numberOfResuspensionTADMCurves = Map[
				Function[{resuspensionVolume},
					If[NullQ[resuspensionVolume],
						0,
						(* Doing x4 here because we are aspirating/dispensing into the plate, and then also aspirating/dipsensing into the destination *)
						Length[splitVolumesBy970[resuspensionVolume]] * 4
					]
				],
				Lookup[filterUnitOperationPacket, Replace[ResuspensionVolume]]
			];

			(* Get the container out resources; this is RetentateContainerOut vs FiltrateContainerOut based on what Target is *)
			containerOutResources = MapThread[
				If[MatchQ[#1, Filtrate],
					#2,
					#3
				]&,
				{target, filtrateContainerOutResources, retentateContainerOutResources}
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			filterUnitOperationPacketWithLabeledObjects = Join[
				filterUnitOperationPacket,
				<|
					Replace[NumberOfLoadingTADMCurves] -> numberOfLoadingTADMCurves,
					Replace[NumberOfRetentateWashTADMCurves] -> numberOfRetentateWashTADMCurves,
					Replace[NumberOfResuspensionTADMCurves] -> numberOfResuspensionTADMCurves,
					Replace[LabeledObjects] -> DeleteDuplicates@Join[
						(* sample labels *)
						Cases[
							Transpose[{Lookup[myResolvedOptions, SampleLabel], samplesInResources /. oldResourceToNewResourceRules}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, FiltrateLabel], filtrateSampleResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, RetentateLabel], retentateSampleResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Flatten[washFlowThroughLabel], Flatten[washFlowThroughResources]}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						(* container labels *)
						Cases[
							Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], containersInResources /. oldResourceToNewResourceRules}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, ContainerOutLabel], containerOutResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, FiltrateContainerLabel], linklessFiltrateContainerOut}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, RetentateContainerLabel], linklessRetentateContainerOut}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, CollectionContainerLabel], Link /@ (Lookup[myResolvedOptions, CollectionContainerLabel] /. collectionContainerResourceReplaceRules)}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{prewetFilterContainerLabel, Link /@ (prewetFilterContainerLabel /. prewetFilterContainerResources)}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, ResuspensionBufferContainerLabel], resuspensionBufferContainerResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Flatten[Lookup[myResolvedOptions, RetentateWashBufferContainerLabel]], Flatten[retentateWashBufferContainerResources]}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Flatten[Lookup[myResolvedOptions, WashFlowThroughContainerLabel]], Flatten[washFlowThroughContainerResources]}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						(* filter labels *)
						Cases[
							Transpose[{Lookup[myResolvedOptions, FilterLabel], filterResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						(* buffer labels *)
						Cases[
							Transpose[{Lookup[myResolvedOptions, ResuspensionBufferLabel], resuspensionBufferResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Lookup[myResolvedOptions, PrewetFilterBufferLabel], prewetFilterBufferResources}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						],
						Cases[
							Transpose[{Flatten[expandedRetentateWashBufferLabel], Flatten[expandedRetentateWashBuffer]}],
							{_String, Verbatim[Link][Resource[___]] | _Resource}
						]
					]
				|>
			];
			{If[NullQ[labelSampleUnitOperationPacket], Nothing, labelSampleUnitOperationPacket], filterUnitOperationPacketWithLabeledObjects}
		]
	];

	(* Generate the raw protocol packet *)
	protocolPacketMinusRequiredObjects = <|
		Object -> protocolID,
		If[MatchQ[resolvedPreparation,Manual],
			Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@Lookup[unitOperationPackets, Object],
			Nothing
		],
		Name -> Lookup[myResolvedOptions, Name],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[SamplesOut] -> samplesOut,
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ DeleteDuplicates[containersInResources]),
		Replace[ContainersOut] -> MapThread[
			If[MatchQ[#1, Filtrate],
				#2,
				#3
			]&,
			{target, filtrateContainerOutResources, retentateContainerOutResources}
		],
		Replace[Target] -> target,
		Replace[FiltrateContainersOut] -> Link /@ linklessFiltrateContainerOut,
		Replace[FiltrateDestinationWell] -> filtrateDestinationWell,
		Replace[RetentateContainersOut] -> Link /@ linklessRetentateContainerOut,
		Replace[RetentateDestinationWell] -> retentateDestinationWell,
		Replace[CollectionContainers] -> collectionContainerResources,
		Replace[RetentateCollectionContainers] -> Link /@ retentateCollectionContainers,
		Replace[Filters] -> filterResources,
		Replace[FilterStorageConditions] -> (If[MatchQ[#, ObjectP[]], Link[#], #]&) /@ filterStorageConditions,
		Replace[FiltrationTypes] -> filtrationType,
		Replace[Instruments] -> instrumentResources,
		Replace[FilterHousings] -> filterHousingResources,
		BlowGun -> blowGunResource,
		Replace[CleaningSolutions] -> cleaningSolutionResources,
		Replace[Syringes] -> syringeResources,
		Replace[Needles] -> needleResources,
		Replace[CounterbalanceWeights] -> counterbalanceWeights,
		Replace[SamplesOutStorage] -> samplesOutStorage,
		Measure -> True,
		Replace[Intensity] -> intensities,
		Replace[Times] -> times,
		Replace[Temperatures] -> temperatures,
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentFilter, myUnresolvedOptions],
		ResolvedOptions -> RemoveHiddenOptions[ExperimentFilter, myResolvedOptions],
		Replace[Checkpoints] -> {
			{"Preparing Samples", 0 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Null},
			{"Picking Resources", 5 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> operator, Time -> 5 Minute]]},
			{"Filtering Samples", (25 Minute * Length[containersIn]), "The samples are filtered to remove particulates larger than the filter's pore size.", Link[Resource[Operator -> operator, Time -> (25 Minute * Length[containersIn])]]},
			{"Parsing Data", 1 Minute, "The database is updated with new filtered samples.", Link[Resource[Operator -> operator, Time -> 1 Minute]]},
			{"Sample Post-Processing", 1 Minute , "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operator, Time -> 1 Minute]]},
			{"Returning Materials", 3 Minute, "Samples are returned to storage.", Link[Resource[Operator -> operator, Time -> 3 Minute]]}
		},
		KeyDrop[populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache, Simulation -> updatedSimulation], Sterile]
	|>;

	(* Get all of the resource out of the packet so they can be tested *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[{unitOperationPackets, protocolPacketMinusRequiredObjects}], _Resource, Infinity]];


	(* If we are doing Manual preparation, populate the RequiredObjects and RequiredInstruments fields of the protocol packet; Null, if we are doing Robotic preparation *)
	protocolPacket = If[MatchQ[resolvedPreparation,Manual],
		Join[
			protocolPacketMinusRequiredObjects,
			<|
				Replace[RequiredObjects] -> (Link /@ Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Sample]]]]),
				Replace[RequiredInstruments] -> (Link /@ Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]])
			|>
		],
		Null
	];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		MatchQ[resolvedPreparation, Robotic], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation -> updatedSimulation, Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation -> updatedSimulation, Messages -> messages, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentFilter, myResolvedOptions],
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{protocolPacket, unitOperationPackets},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*simulateExperimentFilter*)

DefineOptions[
	simulateExperimentFilter,
	Options :> {CacheOption, SimulationOption}
];

simulateExperimentFilter[
	myProtocolPacket: PacketP[Object[Protocol, Filter]] | $Failed | Null,
	myUnitOperationPackets:{PacketP[{Object[UnitOperation, Filter], Object[UnitOperation, LabelSample]}]..} | $Failed,
	mySamples: {ObjectP[Object[Sample]]..},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentFilter]
] := Module[
	{
		cache, simulation, protocolObject, mapThreadFriendlyOptions, resolvedPreparation, resolvedWorkCell, currentSimulation, simulatedPrimitivePackets,
		simulatedSampleSamplePackets, simulatedRetentateWashBufferPackets, simulatedResuspensionBufferPackets, protocolType,
		simulatedSampleAndDestinationCache, filtrateContainerOutPositions, retentateContainerOutPositions,
		containerOutPositions, destinationStates, filtrateAndRetentateSamplesToCreatePackets,
		filtrateSampleObjects, retentateSampleObjects, filtrateSampleSamples, filtrateSampleVolumes,
		retentateSampleSamples, retentateSampleAmounts, transposeQs, primitivePacketFields,
		uploadSampleTransferPackets, retentateLabelsToUse, retentateContainerLabelsToUse, uploadSampleTransferInput,
		simulationWithLabels, labelsRules,labelFieldsRules, primitivePacketFieldSpec,unitOperationField, filtrateAndRetentateCompositionPackets,
		nullAmountCompositionPackets, filtrateSampleObjectsWithDupes, retentateSampleObjectsWithDupes,
		simulatedPrewetFilterBufferPackets, washFlowThroughContainerPositions, filtrateSameAsWashFlowThroughQs,
		washFlowThroughLabelsToUse, washFlowThroughContainerLabelsToUse, washFlowThroughObjects, washFlowThroughSamples,
		washFlowThroughVolumes, washFlowThroughSampleObjectsWithDupes, primitiveWashRetentate, primitiveRetentateWashBatchLengths,
		primitiveRetentateWashBuffers, primitiveRetentateWashVolume, primitiveRetentateWashBufferLabels, primitiveRetentateWashBufferContainerLabels,
		primitiveNumberOfRetentateWashes, primitiveWashFlowThroughLabel, primitiveWashFlowThroughContainerLabel,
		primitiveWashFlowThroughContainer, primitiveWashFlowThroughDestinationWell, primitiveWashFlowThroughStorageCondition,
		simulatedPrimitivePacketsWithModels, retentateWashBufferObjects, washFlowThroughContainerObjects, simulatedCollectionContainerContents,
		flatCollectionContainerPackets, containersOutSamplesAlreadyInPlace, filteredContainerOutPositions, newSampleObjects,
		allFiltrateAndRetentateSamples, simulatedFiltrateContainerContents, simulatedRetentateContainerContents, simulatedRetentateCollectionContainerContents,
		filteredDestinationStates, fastAssoc, destinationsAndStates, filteredContainerOutPositionsNoDupes, filteredDestinationStatesNoDupes,
		duplicateContainerOutPositions, newSamplePackets, newSamplePacketReplacePartRules
	},

	(* Lookup our cache and simulation and make our fast association *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Lookup our resolved Preparation option. *)
	{resolvedPreparation, resolvedWorkCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];

	(* If preparation is Robotic, determine the protocol type (RCP vs. RSP) that we want to create an ID for. *)
	protocolType = If[MatchQ[resolvedPreparation, Robotic],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		],
		Object[Protocol, Filter]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[resolvedPreparation, Robotic] || MatchQ[myProtocolPacket, $Failed|Null],
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		SimulateCreateID[protocolType],
		Lookup[myProtocolPacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentFilter,
		myResolvedOptions
	];


	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[{Object[UnitOperation, Filter], Object[UnitOperation, LabelSample]}]..}],
			Module[{protocolPacket},
				protocolPacket = <|
					Object -> protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					Replace[OutputUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions -> {}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Filter]. *)
		True,
			SimulateResources[myProtocolPacket, myUnitOperationPackets, Simulation -> simulation]
	];

	(* TODO call filterPopulateWorkingSources here (and move it from Filter/Compile.m) to ensure that the simulation has the working samples populated for the unit operations *)

	(* Figure out what field to download from. *)
	(* the Quiet[OutputUnitOperations[[-1]]] is because we need to have that Part in the Download below, but it will throw a message evaluating the first time *)
	unitOperationField=If[MatchQ[protocolObject, ObjectP[Object[Protocol, Filter]]],
		BatchedUnitOperations,
		Quiet[OutputUnitOperations[[-1]]]
	];

	(* Get all the fields we want to Download from the simulated primitive packets *)
	primitivePacketFields = {
		Target,
		VolumeReal,
		VolumeExpression,
		SampleLink,
		SampleString,
		Instrument,
		FilterHousingLink,
		FiltrateContainerOutLink,
		FiltrateDestinationWell,
		RetentateContainerOutLink,
		RetentateDestinationWell,
		WashRetentate,
		RetentateWashBuffer,
		RetentateWashVolume,
		NumberOfRetentateWashes,
		RetentateWashBatchLengths,
		RetentateCollectionMethod,
		ResuspensionBufferLink,
		RetentateWashBufferResources,
		ResuspensionVolume,
		CollectRetentate,
		SampleLabel,
		SampleContainerLabel,
		FiltrateSample,
		FiltrateLabel,
		FiltrateContainerLabel,
		RetentateSample,
		RetentateLabel,
		RetentateContainerLabel,
		RetentateWashBufferLabel,
		RetentateWashBufferContainerLabel,
		ResuspensionBufferLabel,
		ResuspensionBufferContainerLabel,
		SampleOutLabel,
		ContainerOutLabel,
		CollectionContainerLink,
		CollectionContainerLabel,
		RetentateCollectionContainerLink,
		FilterLabel,
		FilterLink,
		CounterweightLink,
		CounterweightString,
		PrewetFilter,
		PrewetFilterTime,
		PrewetFilterBufferVolume,
		PrewetFilterCentrifugeIntensity,
		PrewetFilterBufferLink,
		PrewetFilterBufferString,
		PrewetFilterBufferLabel,
		PrewetFilterContainerOutLink,
		PrewetFilterContainerOutString,
		PrewetFilterContainerLabel,
		NumberOfFilterPrewettings,
		WashFlowThroughLabel,
		WashFlowThroughContainerLabel,
		WashFlowThroughContainer,
		WashFlowThroughContainerResources,
		WashFlowThroughDestinationWell,
		WashFlowThroughStorageCondition
	};
	primitivePacketFieldSpec = Packet[unitOperationField[primitivePacketFields]];

	(* Get our simulated primitive packets *)
	{
		simulatedPrimitivePacketsWithModels,
		simulatedSampleSamplePackets,
		simulatedRetentateWashBufferPackets,
		simulatedResuspensionBufferPackets,
		simulatedPrewetFilterBufferPackets,
		simulatedFiltrateContainerContents,
		simulatedRetentateContainerContents,
		simulatedCollectionContainerContents,
		simulatedRetentateCollectionContainerContents
	} = Quiet[

		With[{insertMe=unitOperationField},
			(* need the {#} here because of the [[-1]] that we might be doing here from above *)
			(* can't do ToList because if it already was a list then that wouldn't work either *)
			(* only doing it for Robotic because we only did the [[-1]] shenanigans there; don't want to mess with it for manual *)
			If[MatchQ[resolvedPreparation, Robotic], {#}, #]& /@ Download[
			protocolObject,
			{
				primitivePacketFieldSpec,
				(* TODO what I actually need here is WorkingSample, not SampleLink, but I'm not totally sure how to actually get that populated properly *)
				Packet[insertMe[SampleLink][{Model, Name, Composition, Volume, Container}]],
				Packet[insertMe[RetentateWashBufferResources][{Model, Name, Composition, Container}]],
				Packet[insertMe[ResuspensionBufferLink][{Model, Name, Composition, Container}]],
				Packet[insertMe[PrewetFilterBufferLink][{Model, Name, Composition, Container}]],
				Packet[insertMe[FiltrateContainerOutLink][{Model, Name, Contents}]],
				Packet[insertMe[RetentateContainerOutLink][{Model, Name, Contents}]],
				Packet[insertMe[CollectionContainerLink][{Model, Name, Contents}]],
				Packet[insertMe[RetentateCollectionContainerLink][{Model, Name, Contents}]]
			},
			Simulation -> currentSimulation
		]],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Add the retentate wash buffer and wash flow through container as the RetentateWashBuffer and WashFlowThroughContainer fields so we have it in object form *)
	(* If we're already expecting it as a flat list, then that's fine just keep it that way *)
	retentateWashBufferObjects = Map[
		Function[{primitivePacket},
			If[MatchQ[Lookup[primitivePacket, RetentateWashBuffer], {(ObjectP[] | Null)..}],
				Lookup[primitivePacket, RetentateWashBufferResources],
				TakeList[Lookup[primitivePacket, RetentateWashBufferResources], If[NullQ[#], 1, Length[#]]& /@ Lookup[primitivePacket, RetentateWashBuffer]]
			]
		],
		simulatedPrimitivePacketsWithModels
	];
	washFlowThroughContainerObjects = Map[
		Function[{primitivePacket},
			If[MatchQ[Lookup[primitivePacket, WashFlowThroughContainer], {(ObjectP[] | Null)..}],
				Lookup[primitivePacket, WashFlowThroughContainerResources],
				TakeList[Lookup[primitivePacket, WashFlowThroughContainerResources], If[NullQ[#], 1, Length[#]]& /@ Lookup[primitivePacket, WashFlowThroughContainer]]
			]
		],
		simulatedPrimitivePacketsWithModels
	];

	(* Add the objectified RetentateWashBuffer and WashFlowThroughContainer values to the packets *)
	simulatedPrimitivePackets = MapThread[
		Join[
			#1,
			<|
				RetentateWashBuffer -> #2,
				WashFlowThroughContainer -> #3
			|>
		]&,
		{simulatedPrimitivePacketsWithModels, retentateWashBufferObjects, washFlowThroughContainerObjects}
	];

	(* Transpose out the retentate wash options if we're doing robotic; otherwise just pull from the unit operation directly *)
	{
		primitiveWashRetentate,
		primitiveRetentateWashBatchLengths,
		primitiveRetentateWashBuffers,
		primitiveRetentateWashVolume,
		primitiveRetentateWashBufferLabels,
		primitiveRetentateWashBufferContainerLabels,
		primitiveNumberOfRetentateWashes,
		primitiveWashFlowThroughLabel,
		primitiveWashFlowThroughContainerLabel,
		primitiveWashFlowThroughContainer,
		primitiveWashFlowThroughDestinationWell,
		primitiveWashFlowThroughStorageCondition
	} = If[MatchQ[resolvedPreparation,Robotic],
		Transpose[Map[
			Function[{primitivePacket},
				Module[
					{numSamples, maxNumRetentateWashes, padAndTranspose, washBuffer, primWashRetentate, washRetentate,
						numRetentateWashes, expandRetentateWashOptions, expandedWashBuffer, transposeQ},

					(* Get the number of samples *)
					numSamples = Length[Lookup[primitivePacket, SampleLink]];

					(* Pull out the number of retentate washes and whether we're washing at all *)
					{washRetentate, numRetentateWashes} = Lookup[primitivePacket, {WashRetentate, NumberOfRetentateWashes}];

					(* Expand the retentate wash options to account for the NumberOfRetentateWashes option *)
					expandRetentateWashOptions[myRetentateOption_Symbol]:=MapThread[
						Function[{washQ, washRetentateOptionValue, numWashes},
							If[Not[TrueQ[washQ]] || NullQ[washRetentateOptionValue],
								Null,
								Flatten[MapThread[
									ConstantArray[#1, #2]&,
									{ToList[washRetentateOptionValue], ToList[numWashes]}
								]]
							]
						],
						{washRetentate, Lookup[primitivePacket, myRetentateOption] /. {{} :> ConstantArray[Null, Length[washRetentate]]}, numRetentateWashes /. {{} :> ConstantArray[Null, Length[washRetentate]]}}
					];

					(* decide whether we're transposing or not; not going to do this if we're not washing at all *)
					transposeQ = Not[MatchQ[washRetentate, {False..}]];

					(* Expand the retentate wash buffer to get the max number of retentate washes *)
					expandedWashBuffer = expandRetentateWashOptions[RetentateWashBuffer];
					maxNumRetentateWashes = Max[Length /@ expandedWashBuffer];

					(* simple function that gets away from gross complicated calls over and over again *)
					padAndTranspose[myOptionValue_List]:=Flatten[Transpose[
						Map[
							PadRight[# /. {Null -> {}}, maxNumRetentateWashes, Null]&,
							myOptionValue
						]]
					];

					(* Get the retentate wash buffer here first because I need it to populate WashRetentate *)
					washBuffer = padAndTranspose[expandedWashBuffer];

					(* Get the value for WashRetentate; basically if we have a buffer then it's going to be True, and if not it's going to be False *)
					primWashRetentate = Replace[washBuffer, {Null -> False, _ -> True}, {1}];

					(* If we're transposing we have to be careful about if we are not washing at all; in that case we want to have *)
					(* Don't actually transpose if we aren't washing anything *)
					If[transposeQ,
						{
							primWashRetentate,
							ConstantArray[numSamples, maxNumRetentateWashes],
							padAndTranspose[expandRetentateWashOptions[RetentateWashBuffer]],
							padAndTranspose[expandRetentateWashOptions[RetentateWashVolume]],
							padAndTranspose[expandRetentateWashOptions[RetentateWashBufferLabel]],
							padAndTranspose[expandRetentateWashOptions[RetentateWashBufferContainerLabel]],
							(* everything becomes a 1 here becuase we've already expanded the 2s into 1s *)
							padAndTranspose[expandRetentateWashOptions[NumberOfRetentateWashes]] /. {Null -> 0, GreaterP[1] -> 1},
							padAndTranspose[expandRetentateWashOptions[WashFlowThroughLabel]],
							padAndTranspose[expandRetentateWashOptions[WashFlowThroughContainerLabel]],
							padAndTranspose[expandRetentateWashOptions[WashFlowThroughContainer]],
							padAndTranspose[expandRetentateWashOptions[WashFlowThroughDestinationWell]],
							padAndTranspose[expandRetentateWashOptions[WashFlowThroughStorageCondition]]
						},
						{
							Flatten[Lookup[primitivePacket, WashRetentate]],
							Length /@ Lookup[primitivePacket, RetentateWashBuffer],
							Flatten[Lookup[primitivePacket, RetentateWashBuffer]],
							Flatten[Lookup[primitivePacket, RetentateWashVolume]],
							Flatten[Lookup[primitivePacket, RetentateWashBufferLabel]],
							Flatten[Lookup[primitivePacket, RetentateWashBufferContainerLabel]],
							Flatten[Lookup[primitivePacket, NumberOfRetentateWashes]],
							Flatten[Lookup[primitivePacket, WashFlowThroughLabel]],
							Flatten[Lookup[primitivePacket, WashFlowThroughContainerLabel]],
							Flatten[Lookup[primitivePacket, WashFlowThroughContainer]],
							Flatten[Lookup[primitivePacket, WashFlowThroughDestinationWell]],
							Flatten[Lookup[primitivePacket, WashFlowThroughStorageCondition]]
						}
					]
				]
			],
			simulatedPrimitivePackets
		]],
		Transpose[Lookup[
			simulatedPrimitivePackets,
			{
				WashRetentate,
				RetentateWashBatchLengths,
				RetentateWashBuffer,
				RetentateWashVolume,
				RetentateWashBufferLabel,
				RetentateWashBufferContainerLabel,
				NumberOfRetentateWashes,
				WashFlowThroughLabel,
				WashFlowThroughContainerLabel,
				WashFlowThroughContainer,
				WashFlowThroughDestinationWell,
				WashFlowThroughStorageCondition
			}
		]]
	];

	(* Combine the downloaded simulated packets as a cache *)
	simulatedSampleAndDestinationCache = FlattenCachePackets[{
		simulatedSampleSamplePackets,
		simulatedRetentateWashBufferPackets,
		simulatedResuspensionBufferPackets,
		simulatedPrewetFilterBufferPackets
	}];

	(* Get all the locations that samples are going to be created in for the filtrate *)
	filtrateContainerOutPositions = Join @@ Map[
		Function[{primitivePacket},
			If[MatchQ[Lookup[primitivePacket, FiltrateContainerOutLink], {}],
				{},
				MapThread[
					Which[
						(* If FiltrateContainerOut is the same as Filter, use similated Filter  *)
						MatchQ[#2, ObjectP[Model]] && MatchQ[#3, ObjectP[Object]], {#1, #3},
						(* If FiltrateContainerOut is a resource picked object, use it *)
						MatchQ[#2, ObjectP[Object]], {#1, #2},
						(* Otherwise, i.e. if we don't have FiltrateContainerOut, just skip this *)
						True, Nothing
					]&,
					{
						Lookup[primitivePacket, FiltrateDestinationWell],
						Lookup[primitivePacket, FiltrateContainerOutLink],
						If[MatchQ[Lookup[primitivePacket, FilterLink], {}],
							ConstantArray[{}, Length[Lookup[primitivePacket, SampleLink]]],
							Lookup[primitivePacket, FilterLink]
						]
					}
				]
			]
		],
		simulatedPrimitivePackets
	];

	(* Determine if the wash flow through sample is the same as the filtrate sample *)
	filtrateSameAsWashFlowThroughQs = MapThread[
		Function[{primitivePacket, washFlowThroughLabels},
			Map[
				Function[{washFlowThroughLabel},
					If[ListQ[washFlowThroughLabel],
						Sequence @@ Flatten[MemberQ[Lookup[primitivePacket, FiltrateLabel], #]& /@ washFlowThroughLabel],
						MemberQ[Lookup[primitivePacket, FiltrateLabel], washFlowThroughLabel]
					]
				],
				washFlowThroughLabels
			]
		],
		{simulatedPrimitivePackets, primitiveWashFlowThroughLabel}
	];

	(* Get all the locations that samples are going to be created in for the wash flow through; ONLY do this if we are not already creating this for the filtrate *)
	washFlowThroughContainerPositions = Join @@ MapThread[
		Function[{primitivePacket, filtrateSameAsWashFlowThroughQ, destWells, flowThroughContainers},
			If[MatchQ[Lookup[primitivePacket, WashFlowThroughContainerResources], {}],
				{},
				MapThread[
					If[MatchQ[#2, ObjectP[]] && Not[#3],
						{#1, #2},
						Nothing
					]&,
					{
						Flatten[destWells],
						Flatten[flowThroughContainers],
						filtrateSameAsWashFlowThroughQ
					}
				]
			]
		],
		{simulatedPrimitivePackets, filtrateSameAsWashFlowThroughQs, primitiveWashFlowThroughDestinationWell, primitiveWashFlowThroughContainer}
	];

	(* Get all the locations that samples are going to be created in for the retentate; this might be {} if we are not collecting retentate *)
	retentateContainerOutPositions = Join @@ Map[
		Function[{primitivePacket},
			(* If we are not collect retentate or don't have RetentateContainerOut, just skip this *)
			If[MatchQ[Lookup[primitivePacket, RetentateContainerOutLink],{}],
				{},
				MapThread[
					If[Not[TrueQ[#3]] || NullQ[#2],
						Nothing,
						{#1, #2}
					]&,
					{
						Lookup[primitivePacket, RetentateDestinationWell],
						Lookup[primitivePacket, RetentateContainerOutLink],
						Lookup[primitivePacket, CollectRetentate]
					}
				]
			]
		],
		simulatedPrimitivePackets
	];

	(* Get the wash flow through sample and container labels that correspond to wash flow through samples that are different from the normal filtrate samples *)
	washFlowThroughLabelsToUse = DeleteCases[PickList[
		Flatten[primitiveWashFlowThroughLabel],
		Flatten[filtrateSameAsWashFlowThroughQs],
		False
	], Null];
	washFlowThroughContainerLabelsToUse = DeleteCases[PickList[
		Flatten[primitiveWashFlowThroughContainerLabel],
		Flatten[filtrateSameAsWashFlowThroughQs],
		False
	], Null];

	(* Get the retentate labels and retentate container labels that correspond to retentates we're actually getting *)
	retentateLabelsToUse = Flatten[Map[
		Function[{primitivePacket},
			(* If we don't have RetentateLabel, just skip this *)
			If[MatchQ[Lookup[primitivePacket, RetentateLabel],{}],
				{},
				PickList[Lookup[primitivePacket, RetentateLabel], Lookup[primitivePacket, CollectRetentate], True]
			]
		],
		simulatedPrimitivePackets
	]];
	retentateContainerLabelsToUse = Flatten[Map[
		Function[{primitivePacket},
			If[MatchQ[Lookup[primitivePacket, RetentateContainerLabel],{}],
				{},
				PickList[Lookup[primitivePacket, RetentateContainerLabel], Lookup[primitivePacket, CollectRetentate], True]
			]
		],
		simulatedPrimitivePackets
	]];

	(* Get all the ContainerOut-and-positions *)
	containerOutPositions = Join[filtrateContainerOutPositions, washFlowThroughContainerPositions, retentateContainerOutPositions];

	(* Get the state of the destination samples *)
	(* Filtrate is always liquid; retentate is solid if we're Transferring and not Resuspending *)
	destinationStates = Join[
		ConstantArray[Liquid, Length[filtrateContainerOutPositions]],
		ConstantArray[Liquid, Length[washFlowThroughContainerPositions]],
		Flatten[Map[
			Function[{primitivePacket},
				Map[
					Switch[#,
						Transfer, Solid,
						Resuspend, Liquid,
						Centrifuge, Liquid, (* actually not totally sure this is kind of ambiguous.  Going to say Liquid but I'm not sure we can really say one way or another *)
						_, Nothing
					]&,
					Lookup[primitivePacket, RetentateCollectionMethod]
				]
			],
			simulatedPrimitivePackets
		]]
	];

	(* Prep collection container packets *)
	flatCollectionContainerPackets = FlattenCachePackets[{
		simulatedFiltrateContainerContents,
		simulatedRetentateContainerContents,
		simulatedCollectionContainerContents,
		simulatedRetentateCollectionContainerContents
	}];

	(* Note: edge case scenario is that we are actually filtering into a destination that already contains a sample. In this case we need to
	 not create a new sample otherwise we'll double populate the fitler destination with multiple samples *)
	containersOutSamplesAlreadyInPlace = Map[
		Function[wellContainer,
			Module[
				{well, container, containerPacket, wellSample},

				{well, container} = {First[wellContainer, Null], Last[wellContainer, Null]};

				containerPacket = FirstCase[flatCollectionContainerPackets, KeyValuePattern[Object -> Download[container, Object]], <||>];

				(* find the sample already in the destination position and return them, otherwise return a Null *)
				wellSample = FirstCase[Lookup[containerPacket, Contents, {}], {well, _}, Null];

				Download[Last[wellSample, Null], Object]

			]
		],
		containerOutPositions
	];

	(* Pick only the cases of the containerOutPositions and destinationStates where there is no sample already in place (Null) to put a new sample *)
	filteredContainerOutPositions = PickList[containerOutPositions, containersOutSamplesAlreadyInPlace, Null];
	filteredDestinationStates = PickList[destinationStates, containersOutSamplesAlreadyInPlace, Null];

	(* For cases where we are putting multiple cycles into the same position, we can't make multiple samples in that same position *)
	(* thus, need to delete duplicates by the container positions, then put them back afterwards *)
	(* need to do some weird shenanigans to do this, stay with me: *)
	(* first part is easy: remove the duplicates *)
	destinationsAndStates = Transpose[{filteredContainerOutPositions, filteredDestinationStates}];
	{
		filteredContainerOutPositionsNoDupes,
		filteredDestinationStatesNoDupes
	} = With[{dupeFree = DeleteDuplicatesBy[destinationsAndStates, #[[1]]&]},
		{
			dupeFree[[All, 1]],
			dupeFree[[All, 2]]
		}
	];

	(* second part is harder: figuring out where the duplicated ones need to go back in the original order *)
	duplicateContainerOutPositions = Map[
		Function[{wellAndContainer},
			Position[filteredContainerOutPositions, wellAndContainer, {1}]
		],
		filteredContainerOutPositionsNoDupes
	];

	(* Make the samples that go into the retentate and filtrate containers *)
	(* Note that I am NOT simulating the sample that goes through the filter for the prewetting because we're always tossing that anyway *)
	filtrateAndRetentateSamplesToCreatePackets = If[MatchQ[filteredContainerOutPositions,{}],
		{},
		UploadSample[
			(* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
			ConstantArray[{}, Length[filteredContainerOutPositionsNoDupes]],
			filteredContainerOutPositionsNoDupes,
			State -> filteredDestinationStatesNoDupes,
			InitialAmount -> ConstantArray[Null, Length[filteredContainerOutPositionsNoDupes]],
			Simulation -> currentSimulation,
			UpdatedBy -> protocolObject,
			FastTrack -> True,
			Upload -> False,
			SimulationMode -> True
		]
	];

	(* generate ReplacePart rules for putting the duplicates back that I removed *)
	(* thus, we don't make multiple samples in the same position anymore, but we do expand things to have the right index matching (but with the same sample in both positions) *)
	newSamplePackets = Take[filtrateAndRetentateSamplesToCreatePackets, Length[filteredContainerOutPositionsNoDupes]];
	newSamplePacketReplacePartRules = Join @@ MapThread[
		Function[{contOutPositions, samplePacket},
			# -> samplePacket& /@ contOutPositions
		],
		{duplicateContainerOutPositions, newSamplePackets}
	];

	newSampleObjects = Lookup[
		ReplacePart[
			filteredContainerOutPositions,
			newSamplePacketReplacePartRules
		],
		Object
	];

	(* Recombine the new packets with the already existing samples *)
	(* here we are folding over the list of existing samples. if there is no sample existing, pick the right one out of the list that we created above *)
	allFiltrateAndRetentateSamples = Fold[
		Function[{currentSamples,containerOutSample},
			(* If there's already a sample in place, take the sample ID, otherwise pop it out of newSampleObjects and shrink that list *)
			If[MatchQ[containerOutSample,ObjectP[]],
				Append[currentSamples,containerOutSample],
				Module[{sample},
					sample=First[newSampleObjects];
					newSampleObjects=Rest[newSampleObjects];
					Append[currentSamples,sample]
				]
			]
		],
		{},
		containersOutSamplesAlreadyInPlace
	];

	(* Split all samples into the filtrate, wash flow through, and retentate samples *)
	(* this is a little cumbersome in one line I know, but basically take the new-object packets and then split them into filtrate, wash flow through, and retentate ones *)
	{filtrateSampleObjects, washFlowThroughObjects, retentateSampleObjects} = If[MatchQ[allFiltrateAndRetentateSamples, {}],
		{{}, {}, {}},
		TakeList[
			allFiltrateAndRetentateSamples,
			{Length[filtrateContainerOutPositions], Length[washFlowThroughContainerPositions], Length[retentateContainerOutPositions]}
		]
	];

	(* update our simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[filtrateAndRetentateSamplesToCreatePackets]];

	(* If we're doing centrifuge or filter block filtering, then transpose; otherwise, don't *)
	transposeQs = Map[
		Or[
			MatchQ[Lookup[#, Instrument], {ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge], Model[Instrument, PressureManifold], Object[Instrument, PressureManifold]}]..}],
			MatchQ[Lookup[#, FilterHousingLink], {ObjectP[{Model[Instrument, FilterBlock], Object[Instrument, FilterBlock]}]..}]
		]&,
		simulatedPrimitivePackets
	];

	(* Get all the sources that we are transferring into the filtrate samples *)
	(* If we have retentate wash, and the wash flow through goes into the filtrate add that to the filtrate. If not, just need the sample *)
	filtrateSampleSamples = MapThread[
		Function[{primitivePacket, batchLengths, transposeQ, filtrateSameAsWashFlowThroughQ, retentateWashBuffers},
			Sequence @@ Which[
				MatchQ[batchLengths,{}|{(0)..}],
					Map[
						{#}&,
						Lookup[primitivePacket, SampleLink]
					],
				transposeQ,
					MapThread[
						{#1, PickList[Flatten[#2], Flatten[#3], True]}&,
						{
							Lookup[primitivePacket, SampleLink],
							Transpose[TakeList[retentateWashBuffers, batchLengths]],
							Transpose[TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]]
						}
					],
				True,
					MapThread[
						{#1, PickList[Flatten[#2], Flatten[#3], True]}&,
						{
							Lookup[primitivePacket, SampleLink],
							TakeList[retentateWashBuffers, batchLengths],
							TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]
						}
					]
			]
		],
		{simulatedPrimitivePackets, primitiveRetentateWashBatchLengths, transposeQs, filtrateSameAsWashFlowThroughQs, primitiveRetentateWashBuffers}
	] /. {Null -> Nothing};

	(* Get all the destinations we're transferring into *)
	filtrateSampleObjectsWithDupes = MapThread[
		ConstantArray[#1, Length[Flatten[#2]]]&,
		{filtrateSampleObjects, filtrateSampleSamples}
	];

	(* Get the amounts we're transferring into the filtrate samples *)
	(* If somehow we got a Null volume, that should just become 0 Milliliter *)
	(* If we have retentate wash, add that to the filtrate. If not, just need the sample *)
	filtrateSampleVolumes = Flatten[MapThread[
		Function[{sourcePackets, primitivePacket, batchLengths, transposeQ, filtrateSameAsWashFlowThroughQ, washVolume, numWashes},
			Sequence@@ Which[
				MatchQ[batchLengths,{}|{(0)..}],
					{
						MapThread[
							{
								If[VolumeQ[#1], #1, #2]
							}&,
							{Lookup[primitivePacket, VolumeReal], Lookup[sourcePackets, Volume]}
						]
					},
				transposeQ,
					MapThread[
						Function[{primVolumeReal, sampleVolume, retentateWashVolume, numRetentateWashes, washSameAsFiltrateQ},
							{
								If[VolumeQ[primVolumeReal], primVolumeReal, sampleVolume],
								If[NullQ[retentateWashVolume], Nothing, Replace[PickList[retentateWashVolume, washSameAsFiltrateQ, True] * PickList[numRetentateWashes, washSameAsFiltrateQ, True], 0 -> Nothing, {1}]]
							}
						],
						{
							Lookup[primitivePacket, VolumeReal],
							Lookup[sourcePackets, Volume],
							Transpose[TakeList[washVolume, batchLengths]],
							Transpose[TakeList[numWashes, batchLengths]],
							Transpose[TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]]
						}
					],
				True,
					MapThread[
						Function[{primVolumeReal, sampleVolume, retentateWashVolume, washSameAsFiltrateQ},
							{
								If[VolumeQ[primVolumeReal], primVolumeReal, sampleVolume],
								If[NullQ[retentateWashVolume], Nothing, Replace[PickList[retentateWashVolume, washSameAsFiltrateQ, True], 0 -> Nothing, {1}]]
							}
						],
						{
							Lookup[primitivePacket, VolumeReal],
							Lookup[sourcePackets, Volume],
							TakeList[washVolume, batchLengths],
							TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]
						}
					]
			]
		],
		{simulatedSampleSamplePackets, simulatedPrimitivePackets, primitiveRetentateWashBatchLengths, transposeQs, filtrateSameAsWashFlowThroughQs, primitiveRetentateWashVolume, primitiveNumberOfRetentateWashes}
	]] /. {Null -> Nothing};

	(* Get all the sources that we are transferring that are not the same as the filtrate samples (i.e., WashFlowThrough) *)
	washFlowThroughSamples = DeleteCases[PickList[
		Flatten[primitiveRetentateWashBuffers],
		Flatten[filtrateSameAsWashFlowThroughQs],
		False
	], Null];

	(* Get the amounts of wash flow through that we're collecting *)
	washFlowThroughVolumes = Flatten[MapThread[
		Function[{batchLengths, transposeQ, filtrateSameAsWashFlowThroughQ, washVolume, numWashes},
			Which[
				MatchQ[batchLengths, {}|{(0)..}],
					{},
				transposeQ,
					MapThread[
						Function[{retentateWashVolume, numRetentateWashes, washSameAsFiltrateQ},
							Replace[PickList[retentateWashVolume, washSameAsFiltrateQ, False] * PickList[numRetentateWashes, washSameAsFiltrateQ, False], 0 -> Nothing, {1}]
						],
						{
							Transpose[TakeList[washVolume, batchLengths]],
							Transpose[TakeList[numWashes, batchLengths]],
							Transpose[TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]]
						}
					],
				True,
					MapThread[
						Function[{retentateWashVolume, washSameAsFiltrateQ},
							Replace[PickList[retentateWashVolume, washSameAsFiltrateQ, False], 0 -> Nothing, {1}]
						],
						{
							TakeList[washVolume, batchLengths],
							TakeList[filtrateSameAsWashFlowThroughQ, batchLengths]
						}
					]
			]
		],
		{primitiveRetentateWashBatchLengths, transposeQs, filtrateSameAsWashFlowThroughQs, primitiveRetentateWashVolume, primitiveNumberOfRetentateWashes}
	]];

	(* Get the destination samples of the wash flow through *)
	washFlowThroughSampleObjectsWithDupes = Flatten[MapThread[
		ConstantArray[#1, Length[Flatten[#2]]]&,
		{washFlowThroughObjects, washFlowThroughSamples}
	]];

	(* Get all the sources we are transferring into the retentate samples *)
	(* basically if we are collecting retentate and the retentate collection method is Transfer, then we are going to transfer 0 gram of source sample and all retentate wash buffers into the retentate sample *)
	(* If we are collecting retentate and the retentate collection method is Resuspend, then we are going to transfer 0 milliliter of source sample and all retentate wash buffers into the retentate sample, and the full ResuspensionVolume of ResuspensionBuffer into it too *)
	(* the DeleteCases is super weird admittedly but this is just for the situations where we aren't collecting retentate at all *)
	retentateSampleSamples = DeleteCases[MapThread[
		Function[{primitivePacket, batchLengths, transposeQ, washBuffers},
			Sequence@@Which[
				MatchQ[batchLengths,{}|{(0)..}],
					MapThread[
						Function[{source, resuspensionBuffer, collectRetentate},
							If[collectRetentate,
								DeleteCases[Flatten[{source, resuspensionBuffer}], Null],
								Nothing
							]
						],
						{
							Lookup[primitivePacket, SampleLink],
							Lookup[primitivePacket, ResuspensionBufferLink],
							Lookup[primitivePacket, CollectRetentate]
						}
					],
				transposeQ,
					MapThread[
						Function[{source, washBuffers, resuspensionBuffer, collectRetentate},
							If[collectRetentate,
								DeleteCases[Flatten[{source, washBuffers, resuspensionBuffer}], Null],
								Nothing
							]
						],
						{
							Lookup[primitivePacket, SampleLink],
							Transpose[TakeList[washBuffers, batchLengths]],
							Lookup[primitivePacket, ResuspensionBufferLink],
							Lookup[primitivePacket, CollectRetentate]
						}
					],
				True,
					MapThread[
						Function[{source, washBuffers, resuspensionBuffer, collectRetentate},
							If[collectRetentate,
								DeleteCases[Flatten[{source, washBuffers, resuspensionBuffer}], Null],
								Nothing
							]
						],
						{
							Lookup[primitivePacket, SampleLink],
							TakeList[washBuffers, batchLengths],
							Lookup[primitivePacket, ResuspensionBufferLink],
							Lookup[primitivePacket, CollectRetentate]
						}
					]
			]
		],
		{simulatedPrimitivePackets, primitiveRetentateWashBatchLengths, transposeQs, primitiveRetentateWashBuffers}
	], {}];
	retentateSampleAmounts = Flatten[MapThread[
		Function[{primitivePacket, batchLengths, transposeQ, washVolume, washBuffers},
			Sequence@@With[{numSamples = Length[Lookup[primitivePacket, SampleLink]]},
				Which[
					MatchQ[batchLengths,{}|{(0)..}],
						MapThread[
							Function[{resuspensionVolume, retentateCollectionMethod},
								Switch[retentateCollectionMethod,
									Resuspend,
									{
										0 Milliliter, (* this is for the source sample *)
										resuspensionVolume
									},
									Transfer,
									{
										0 Gram (* this is for the source sample; assuming it's solid since we're transferring dry residue from the filter *)
									},
									(* kind of arbitrary whether this is a liquid or solid but going with liquid right now *)
									Centrifuge,
									{
										0 Milliliter (* this is the source sample *)
									},
									_, Nothing (* If we aren't collecting retentate then this is nothing *)

								]
							],
							{
								If[MatchQ[Lookup[primitivePacket, ResuspensionVolume], {}], ConstantArray[{}, numSamples], Lookup[primitivePacket, ResuspensionVolume]],
								Lookup[primitivePacket, RetentateCollectionMethod]
							}
						],
					transposeQ,
						MapThread[
							Function[{retentateWashVolumes, retentateWashBuffers, resuspensionVolume, retentateCollectionMethod},
								Which[
									(* If we are in a weird error state where we don't have any buffers or volumes but RetentateCollectionMethod is set, need to short circuit here to prevent a trainwreck later on *)
									NullQ[resuspensionVolume] && (Length[DeleteCases[retentateWashBuffers, Null]] == 0 || Length[DeleteCases[retentateWashVolumes, Null]] == 0),
										Nothing,
									MatchQ[retentateCollectionMethod, Resuspend],
										{
											0 Milliliter, (* this is for the source sample *)
											ConstantArray[0 Milliliter, Length[DeleteCases[retentateWashVolumes, Null]]], (* this is for all the retentate washes; might be zero *)
											resuspensionVolume
										},
									MatchQ[retentateCollectionMethod, Transfer],
										{
											0 Gram, (* this is for the source sample; assuming it's solid since we're transferring dry residue from the filter *)
											ConstantArray[0 Gram, Length[DeleteCases[retentateWashVolumes, Null]]] (* from all the retentate washes; might be zero *)
										},
									(* kind of arbitrary whether this is a liquid or solid but going with liquid right now *)
									MatchQ[retentateCollectionMethod, Centrifuge],
										{
											0 Milliliter, (* this is the source sample *)
											ConstantArray[0 Milliliter, Length[DeleteCases[retentateWashVolumes, Null]]] (* this is for all the retentate washes; might be zero *)
										},
									True, Nothing (* If we aren't collecting retentate then this is nothing *)
								]
							],
							{
								Transpose[TakeList[washVolume, batchLengths]],
								Transpose[TakeList[washBuffers, batchLengths]],
								If[MatchQ[Lookup[primitivePacket, ResuspensionVolume], {}], ConstantArray[{}, numSamples], Lookup[primitivePacket, ResuspensionVolume]],
								Lookup[primitivePacket, RetentateCollectionMethod]
							}
						],
					True,
						MapThread[
							Function[{retentateWashVolumes, retentateWashBuffers, resuspensionVolume, retentateCollectionMethod},
								Which[
									(* If we are in a weird error state where we don't have any buffers or volumes but RetentateCollectionMethod is set, need to short circuit here to prevent a trainwreck later on *)
									Length[DeleteCases[retentateWashBuffers, Null]] == 0 || Length[DeleteCases[retentateWashVolumes, Null]] == 0,
										Nothing,
									MatchQ[retentateCollectionMethod, Resuspend],
										{
											0 Milliliter, (* this is for the source sample *)
											ConstantArray[0 Milliliter, Length[DeleteCases[retentateWashVolumes, Null]]], (* this is for all the retentate washes; might be zero *)
											resuspensionVolume
										},
									MatchQ[retentateCollectionMethod, Transfer],
										{
											0 Gram, (* this is for the source sample; assuming it's solid since we're transferring dry residue from the filter *)
											ConstantArray[0 Gram, Length[DeleteCases[retentateWashVolumes, Null]]] (* from all the retentate washes; might be zero *)
										},
									(* kind of arbitrary whether this is a liquid or solid but going with liquid right now *)
									MatchQ[retentateCollectionMethod, Centrifuge],
										{
											0 Milliliter, (* this is the source sample *)
											ConstantArray[0 Milliliter, Length[DeleteCases[retentateWashVolumes, Null]]] (* this is for all the retentate washes; might be zero *)
										},
									True, Nothing (* If we aren't collecting retentate then this is nothing *)

								]
							],
							{
								TakeList[washVolume, batchLengths],
								TakeList[washBuffers, batchLengths],
								If[MatchQ[Lookup[primitivePacket, ResuspensionVolume], {}], ConstantArray[{}, numSamples], Lookup[primitivePacket, ResuspensionVolume]],
								Lookup[primitivePacket, RetentateCollectionMethod]
							}
						]
				]
			]
		],
		{simulatedPrimitivePackets, primitiveRetentateWashBatchLengths, transposeQs, primitiveRetentateWashVolume, primitiveRetentateWashBuffers}
	]] /. {Null -> 0 Milliliter};

	(* Get all the destinations we're transferring into *)
	retentateSampleObjectsWithDupes = MapThread[
		ConstantArray[#1, Length[Flatten[#2]]]&,
		{retentateSampleObjects, retentateSampleSamples}
	];

	(* Call UploadSampleTransfer on our source and destination samples *)
	uploadSampleTransferInput=Cases[
		Transpose[{
			Flatten[{filtrateSampleSamples, washFlowThroughSamples, retentateSampleSamples}],
			Flatten[{filtrateSampleObjectsWithDupes, washFlowThroughSampleObjectsWithDupes, retentateSampleObjectsWithDupes}],
			Flatten[{filtrateSampleVolumes, washFlowThroughVolumes, retentateSampleAmounts}]
		}],
		{ObjectP[], ObjectP[], VolumeP}
	];

	uploadSampleTransferPackets = If[Length[uploadSampleTransferInput]>0,
		UploadSampleTransfer[
			Sequence@@Transpose[uploadSampleTransferInput],
			Upload -> False,
			FastTrack -> True,
			Simulation -> currentSimulation,
			UpdatedBy -> protocolObject
		],
		{}
	];

	(* Update our simulation. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];
	(* Pull out the packets of the filtrate and retentate samples with their new post-transfer compositions *)
	filtrateAndRetentateCompositionPackets = Download[Flatten[{filtrateSampleObjects, washFlowThroughObjects, retentateSampleObjects}], Packet[Composition], Simulation -> currentSimulation];

	(* Update the composition of the filtrate and retentate samples to have Null for their amounts *)
	(* Since this is a simulation, do not update time element for composition yet *)
	(* The reason why we did not use ReplaceAll here to update CompositionP is because DateObject might be updated at the same time by /. {CompositionP :> Null}) *)
	nullAmountCompositionPackets = Map[
		Function[{compositionPacket},
			Module[{compositionWithNullAmount},
			compositionWithNullAmount =  Map[
				If[MatchQ[#, {CompositionP, _, _}],
					{Null, #[[2]], #[[3]]},
					#
				]&,
				Lookup[compositionPacket, Composition]
			];
			<|Object -> Lookup[compositionPacket, Object], Replace[Composition] -> compositionWithNullAmount|>
			]
		],
		filtrateAndRetentateCompositionPackets
	];

	(* Update our simulation with the Null compositions *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[nullAmountCompositionPackets]];

	(* If we don't have any label, skip the rule *)
	labelsRules = Join[
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, SampleLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, SampleLabel]], Flatten[Lookup[simulatedPrimitivePackets, SampleLink]]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, SampleContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, SampleContainerLabel]], Download[Lookup[Flatten[simulatedSampleSamplePackets], Container], Object]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, FiltrateLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, FiltrateLabel]], Flatten[filtrateSampleObjects]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, FiltrateContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, FiltrateContainerLabel]], Download[filtrateContainerOutPositions[[All, 2]], Object]}
			]
		],
		If[MatchQ[retentateLabelsToUse, {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{retentateLabelsToUse, Flatten[retentateSampleObjects]}
			]
		],
		If[MatchQ[retentateContainerLabelsToUse, {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{retentateContainerLabelsToUse, Download[retentateContainerOutPositions[[All, 2]], Object]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, ResuspensionBufferLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Lookup[#2, Object],
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, ResuspensionBufferLabel]], Flatten[simulatedResuspensionBufferPackets]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, ResuspensionBufferContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Download[Lookup[#2, Container], Object],
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, ResuspensionBufferContainerLabel]], Flatten[simulatedResuspensionBufferPackets]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterBufferLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Lookup[#2, Object],
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterBufferLabel]], Flatten[simulatedPrewetFilterBufferPackets]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, RetentateWashBufferLabel]], {}] || !MatchQ[Length[Flatten[Lookup[simulatedPrimitivePackets, RetentateWashBufferLabel]]], Length[Flatten[simulatedRetentateWashBufferPackets]]],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Lookup[#2, Object],
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, RetentateWashBufferLabel]], Flatten[simulatedRetentateWashBufferPackets]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, RetentateWashBufferContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Download[Lookup[#2, Container], Object],
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, RetentateWashBufferContainerLabel]], Flatten[simulatedRetentateWashBufferPackets]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, WashFlowThroughLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{washFlowThroughLabelsToUse, Flatten[washFlowThroughObjects]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, WashFlowThroughContainerLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> Download[#2, Object],
					Nothing
				]&,
				{washFlowThroughContainerLabelsToUse, Flatten[washFlowThroughContainerPositions[[All, 2]]]}
			]
		],
		(* Note that I removed SampleOut and ContainerOut labeling here because those are always either the FiltrateSample/RetentateSample and FiltrateContainerOut/RetentateContainerOut.  Since those labels are accounted for above, don't need to do them again here *)
		(* labels for collection container, prewet filter container out, filters, and counterweights *)
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, CollectionContainerLabel]], {}] || MatchQ[Flatten[Lookup[simulatedPrimitivePackets, CollectionContainerLink]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, CollectionContainerLabel]], Flatten[Lookup[simulatedPrimitivePackets, CollectionContainerLink]]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterContainerLabel]], {}] || MatchQ[Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterContainerOutLink]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterContainerLabel]], Flatten[Lookup[simulatedPrimitivePackets, PrewetFilterContainerOutLink]]}
			]
		],
		If[MatchQ[Flatten[Lookup[simulatedPrimitivePackets, FilterLabel]], {}],
			{},
			MapThread[
				If[MatchQ[#2, ObjectP[]] && StringQ[#1],
					#1 -> #2,
					Nothing
				]&,
				{Flatten[Lookup[simulatedPrimitivePackets, FilterLabel]], Flatten[Lookup[simulatedPrimitivePackets, FilterLink]]}
			]
		]
	];

	(* need to do the With shenanigans bc Field is HoldAll, but we have to use Field and can't use Evaluate because we don't want the part syntax to get messed up *)
	labelFieldsRules = If[!MatchQ[resolvedPreparation, Manual],
		{},
		(* need to DeleteCases Null because if we're in an error state where we have some buffer values set but not others for resuspension or retentate washing, removing Null prevents trainwrecking *)
		DeleteCases[Flatten[{
			Flatten[MapIndexed[
				Function[
					{options, index},
					With[{actualIndex = First[index]},
						KeyValueMap[
							Function[{optionName, optionFieldIndex},
								Module[{optionValue, previousNumRetentateWashBufferLabels},

									(* Get the value of the field from the primitive by looking up the keys *)
									optionValue = Lookup[options, optionName];

									(* Get the length of the RetentateWashBuffer from all previous iterations of the loop; obviously this is weird but in order to actually construct the retentate wash buffer resources index properly I need to flatten stuff out *)
									previousNumRetentateWashBufferLabels = Which[
										Not[MatchQ[optionName, RetentateWashBufferLabel | RetentateWashBufferContainerLabel]], 0,
										actualIndex == 1, 0,
										True, Length[Flatten[Lookup[mapThreadFriendlyOptions, optionName][[1;;(actualIndex - 1)]]]]
									];

									(* If we have a string, generate a label *)
									Which[
										StringQ[optionValue], optionValue -> optionFieldIndex,
										ListQ[optionValue],
											MapIndexed[
												If[StringQ[#1],
													(* Doing this /. behavior to *)
													#1 -> optionFieldIndex /. {0 -> (First[#2] + previousNumRetentateWashBufferLabels)},
													Nothing
												]&,
												optionValue
											],
										True, Nothing
									]
								]
							],
							<|
								SampleLabel -> Field[SampleLink[[actualIndex]]],
								SampleContainerLabel -> Field[SampleLink[[actualIndex]][Container]],
								FiltrateLabel -> Field[FiltrateSample[[actualIndex]]],
								FiltrateContainerLabel -> Field[FiltrateContainerOutLink[[actualIndex]]],
								PrewetFilterBufferLabel -> Field[PrewetFilterBufferLink[[actualIndex]]],
								PrewetFilterContainerLabel -> Field[PrewetFilterContainerOutLink[[actualIndex]]],
								(* I am putting the [[actualIndex, 0]] here because the 0 becomes an actual number inside the KeyValueMap but this is an N-Multiple so I can't know based on actualIndex what this is supposed to be *)
								WashFlowThroughLabel -> Field[WashFlowThroughSample[[actualIndex, 0]]],
								WashFlowThroughContainerLabel -> Field[WashFlowThroughContainer[[actualIndex, 0]]],
								RetentateLabel -> Field[RetentateSample[[actualIndex]]],
								RetentateContainerLabel -> Field[RetentateContainerOutLink[[actualIndex]]],
								ResuspensionBufferLabel -> Field[ResuspensionBufferLink[[actualIndex]]],
								ResuspensionBufferContainerLabel -> Field[ResuspensionBufferLink[[actualIndex]][Container]],
								(* I am putting the [[actualIndex, 0]] here because the 0 becomes an actual number inside the KeyValueMap but this is an N-Multiple so I can't know based on actualIndex what this is supposed to be *)
								RetentateWashBufferLabel -> Field[RetentateWashBufferResources[[0]]],
								RetentateWashBufferContainerLabel -> Field[RetentateWashBufferResources[[0]][Container]],
								CollectionContainerLabel -> Field[CollectionContainerLink[[actualIndex]]],
								FilterLabel -> Field[FilterLink[[actualIndex]]],
								If[MatchQ[Lookup[options, Target], Filtrate],
									FiltrateLabel -> Field[SamplesOut[[actualIndex]]],
									RetentateLabel -> Field[SamplesOut[[actualIndex]]]
								],
								(* these are probably duplicates but that should be ok *)
								SampleOutLabel -> If[MatchQ[Lookup[options, Target], Filtrate],
									Field[FiltrateSample[[actualIndex]]],
									Field[RetentateSample[[actualIndex]]]
								],
								ContainerOutLabel -> If[MatchQ[Lookup[options, Target], Filtrate],
									Field[FiltrateContainerOutLink[[actualIndex]]],
									Field[RetentateContainerOutLink[[actualIndex]]]
								]
							|>
						]
					]
				],
				mapThreadFriendlyOptions
			]]
		}], Null],
		{}
	];

	(* Note that I don't actually need SampleOut/ContainerOut labels here because those will already be included with either the filtrate or retentate labels *)
	simulationWithLabels = Simulation[
		Labels -> labelsRules,
		LabelFields -> labelFieldsRules
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];


Error::NestedIndexMatchingRequired="The following options are not properly indexed to each other: `1`.  Each entry must be a list of lists with length `2`.";
Error::FiltrationTypeAndInstrumentMismatch="The following FiltrationType `1` and Instrument `2` options are conflicting for input(s) `3`. PeristalticPump filtration requires a PeristalticPump instrument, Centrifuge filtration requires a Centrifuge instrument, Vacuum filtration requires a VacuumPump instrument, and Syringe filtration requires a SyringePump instrument. In order to generate a valid protocol, please specify an appropriate Instrument, FiltrationType or allow the options to be set automatically.";
Error::FiltrationTypeAndSyringeMismatch="The following FiltrationType `1` and Syringe `2` options are conflicting for input(s) `3`. A Syringe can only be specified for Syringe type filtration. In order to generate a valid protocol, please make sure to both set the filtration FiltrationType to Syringe and specify a Syringe.";
Error::FiltrationTypeMismatch="The following FiltrationType `1` and `4` `2` options are conflicting for input(s) `3`. A `4` may only be specified for `5` type filtration. In order to generate a valid protocol, please make sure to both set the filtration FiltrationType to `5` and specify `4`.";
Error::SterileOptionMismatch="The Sterile option were set to `2` for `3`, but the specified Instruments `1` are not capable of handling samples in this fashion. Please select a Sterile instrument if Sterile has been set to True, a non-Sterile instrument if Sterile has been set to False, or allow either of the options to be resolved automatically.";
Error::FiltrationTypeAndFilterHousingMismatch="The following FiltrationType `1` and FilterHousing `2` options are conflicting for input(s) `3`. A FilterHousing must not be Null for PeristalticPump and plate-based Vacuum type filtration, and must not be specified for Centrifuge, Syringe, Buchner funnel Vacuum, or BottleTop Vacuum type filtration. In order to generate a valid protocol, please adjust the FiltrationType and FilterHousing options.";
Error::VolumeTooLargeForContainerOut="The volumes, `1`, of the samples, `3` plus any RetentateWashVolumes (if applicable), are too large for the MaxVolume, `2`, of the specified FiltrateContainerOut. Please specify FiltrateContainerOut with larger MaxVolume or allowe the option to be set automatically.";
Error::VolumeTooLargeForCollectionContainer="The volumes, `1`, of the samples, `3` plus any RetentateWashVolumes (if applicable), are too large for the MaxVolume, `2`, of the specified CollectionContainer. Please specify CollectionContainer with larger MaxVolume or allowe the option to be set automatically.";
Error::VolumeTooLargeForSyringe="The volumes, `1`, of the samples, `3`, are larger than the MaxVolume, `2`, of the specified Syringe. Please specify Syringe with larger max volumes or allowed the option to be resolved automatically.";
Error::IncorrectSyringeConnection="The following syringes, `1`, specified for samples, `2` do not have a Luer-Lock ConnectionType. Please specify Syringe with an appropriate ConnectionType or allow the option to be resolved automatically.";
Error::FilterOptionMismatch="The `1` of the specified filters `2` are `3`, which are incompatible with the `4` specifications for `5` option. Please try specifying only a filter or `5`.";
Error::PrefilterOptionsMismatch="If using a prefilter, please specify both PrefilterMembraneMaterial and PrefilterPoreSize or allowed one or both to be resolved automatically.";
Error::CollectionContainerPlateMismatch="If using a plate filter and CollectionContainer is specified, CollectionContainer must also be a plate and has the same number of positions as the filter plate. Please change the CollectionContainer option for the following sample(s): `1`.";
Error::CollectRetentateMismatch="If CollectRetentate is set to True, then RetentateCollectionMethod, RetentateContainerOut, and RetentateDestinationWell cannot be Null.  If it is set to False, then those options and ResuspensionVolume, ResuspensionBuffer, and NumberOfResuspensionMixes must all not be specified.  Please alter these options for the following sample(s) `1`.";
Error::CollectRetentateTypeMismatch="The following FiltrationType `1` and CollectRetentate options `2` are conflicting for input(s) `3`.  If CollectRetentate is specified, FiltrationType must be Centrifuge or Vacuum.";
Error::RetentateCollectionMethodMismatch="If RetentateCollectionMethod is Centrifuge, Transfer or Null, then ResuspensionVolume, ResuspensionBuffer, and NumberOfResuspensionMixes cannot be specified.  If it is Resuspend, then those options cannot be Null.  Please alter these options for the following sample(s) `1`.";
Error::RetentateCollectionMethodTransferMismatch="If RetentateCollectionMethod is Transfer, then filtration may only be performed using centrifuge tubes, membrane filters with FiltrationType -> Vacuum, or non-VacuCap BottleTop filters.  Please change the Filter or FiltrationType options for the following sample(s) `1`.";
Error::RetentateCollectionContainerMismatch="If RetentateCollectionMethod is Centrifuge, then RetentateCollectionContainer must be unspecified, a Model[Container, Vessel], or an Object[Container, Vessel].  Please change these options for the following sample(s): `1`.";
Error::RetentateCollectionMethodPlateError="If RetentateCollectionMethod is Transfer, then RetentateContainerOut can only be a Model[Container, Vessel] or Object[Container, Vessel] (not a Model[Container, Plate] or Object[Container, Plate]).  Please change RetentateContainerOut for the following sample(s): `1`, or leave it unspecified.";
Error::CentrifugeFilterDestinationRequired="If the specified filter is a centrifuge tube filter, the DestinationContainerModel field of its model must not be Null.  For the following filter(s), this is not the case: `1`.  Please set the Filter option to a filter with DestinationContainerModel populated, or leave it blank to be set automatically.";
Error::FilterUntilDrainedIncompatibleWithFilterType="If FilterUntilDrained is set to True, FiltrationType may only be Vacuum or PeristalticPump.  Please adjust the FiltrationType, or FilterUntilDrained options for the following sample(s) `1`.";
Error::IncompatibleFilterTimes="If FilterUntilDrained is True, then both Time and MaxTime must be specified, and Time may not be greater than MaxTime.  If FilterUntilDrained is False, MaxTime must be unspecified.  Please adjust these options for the following sample(s) `1`.";
Error::RetentateWashCentrifugeIntensityTypeMismatch="The following FiltrationType `1` and RetentateWashCentrifugeIntensity options `2` are conflicting for input(s) `3`.  If RetentateWashCentrifugeIntensity is specified, FiltrationType must be Centrifuge.";
Error::WashRetentateTypeMismatch="The following FiltrationType `1` and WashRetentate options `2` are conflicting for input(s) `3`.  If WashRetentate is specified, FiltrationType must be Centrifuge or Vacuum.";
Error::RetentateWashMixMismatch="If RetentateWashMix -> False, then NumberOfRetentateWashes must not be specified.  If RetentateWashMix -> True, then this option must not be Null.  Please adjust these options for the following sample(s) `1`.";
Error::WashRetentateMismatch="If WashRetentate -> False, then `2` must not be specified. If WashRetentate -> True, these must not be set to Null.  Please adjust these options for the following sample(s) `1`.";
Error::PrewetFilterMismatch="If PrewetFilter -> True, then `2` must not be specified. If PrewetFilter -> True, these must not be set to Null.  Please adjust these options for the following sample(s) `1`.";
Error::PrewetFilterCentrifugeIntensityTypeMismatch="The following FiltrationType `1` and PrewetFilterCentrifugeIntensity options `2` are conflicting for input(s) `3`.  If PrewetFilterCentrifugeIntensity is specified, FiltrationType must be Centrifuge.";
Error::NumberOfFilterPrewettingsTooHigh="The specified NumberOfFilterPrewettings `1` is greater than 1 for the following filters `2`. NumberOfFilterPrewettings may not be greater than 1 for BottleTop or PeristalticPump filters.  Please set it to 1, or allow it to be set automatically.";
Error::PrewetFilterIncompatibleWithFilterType="Filter prewetting was enabled for the following filters `1`.  Filter prewetting may not be done for syringe filters or vacuum filter plates.  Please allow it to be set automatically, or select a different filter type that is compatible with prewetting.";
Error::ResuspensionVolumeTooHigh="The ResuspensionVolume `1` for input(s) `2` is greater than the MaxVolume of the resolved Filter `3`.  Please adjust ResuspensionVolume, or change to a Filter with a higher MaxVolume.";
Error::PoreSizeAndMolecularWeightCutoff="The PoreSize option for `3` were set to `1`, while the MolecularWeightCutoff option were set to `2`. These options cannot be both set to Null or both specified. Please specify one of the options or allow them to be resolved automatically.";
Error::FilterMaxVolume="The MaxVolume of the filters `1` are `2`, which is less than the sum of the sample volume and retentate wash volume `3` and the StorageBufferVolume. Please try specifying a filter with larger MaxVolume or allow the Filter option to resolve automatically.";
Error::FilterInletConnectionType="The InletConnectionType of the specified filters `1` are `2`. Only filters with LuerLock connection types can be used. Please try specifying a filter with the correct connection or allow the Filter option to resolve automatically.";
Error::FilterPlateDimensionsExceeded="The specified filter plate(s) `2` for sample(s) `1` exceed the maximum size limit and cannot be used to perform the AirPressure filtration on the instrument `3`. Please check the Positions of the instrument model and select another filter plate with Dimensions smaller than the \"Filter Plate Slot\" of the instrument.";
Error::UnusableCentrifuge="The specified centrifuges `1` for samples `2` cannot be used to centrifuge `3` filters. Please allow the Instrument option to be resolved automatically, or use CentrifugeDevices to find a Centrifuge capable of handing the filters being used.";
Error::NoUsableCentrifuge="No usable Centrifuge for `1` samples have been found capable of centrifuging `2` filter with the centrifuge parameters provided. Please allow some of the Centrifuge filtration options to resolve automatically, or use CentrifugeDevices to find a Centrifuge capable of handing the filter being used.";
Error::NoFilterAvailable="No appropriate filter could be found to filter `1` that fits all of the options specified. If a filter was directly specified, then it cannot be used given the constraints of the input sample or options. Please try using different values for the options, let some of the options be resolved automatically or explore ECL filter catalog for the filters currently available.";
Error::NonLiquidSample="The samples `1` do not have a Liquid state and cannot processed. Please remove these from the function input.";
Error::TargetLabelMismatch="If Target -> Retentate, then the `1` and `2` options must be the same value or be unspecified.  If Target -> Filtrate, then the `1` and `3` options must be the same value or be unspecified.  This is correlation is mismatched for the following sample(s): `4`.  Please update the `1` and `2` options for these sample(s).";
Error::LabelContainerOutIndexMismatch = "For all values of `1` that are replicated, the corresponding integer indices in `2` must also be replicated in the same positions.  Similarly, for all members of `2` where the integer indices are replicated, the corresponding values of `1` must also be replicated.  Please ammend the values of `1` and `2` such that these requirements hold.";
Warning::SterileContainerRecommended="The sample `1` was requested to be sterile filtered. The provided FiltrateContainerOut option `2` is not sterile, but will be used.";
Warning::MissingVolumeInformation="The sample(s) `1` are missing volume information. The MaxVolume of the source containers will be used instead when resolving Automatic options.";
Internal::ContainerOutAndSampleOutMismatch="Samples `1` specified by the SampleOut option are not located in the containers `2` specified by the ContainerOut option. Please make sure the samples are in the correct container.";
Error::FilterPositionDoesNotExist="The specified FilterPosition(s) `1` do not exist in the specified or automatically selected Filter(s) `2`.  If using a container filter, please select a position present in the Positions field of the filter.  Otherwise, please leave FilterPosition blank to be set automatically.";
Error::FilterPositionInvalid="The specified FilterPosition(s) `1` for sample(s) `2` may not be selected because these sample(s) are already in a different position of the specified or automatically selected Filter(s) `3`.  Samples may not be moved to different positions of the same filter they are are already in.  Please select a different filter, or allow FilterPosition to be set automatically.";
Error::CentrifugeIntensityAboveMaximum="For the following sample(s) (`1`), the Intensity (`2`) is greater than the maximum allowed for the Instrument that was specified or automatically set (`3`).  Please decrease the Intensity option to below the instrument's MaxRotationRate.";
Error::TypePressureMismatch="Pressure and/or RetentateWashPressure are specified but FiltrationType is set to something other than AirPressure, or Pressure is Null but FiltrationType -> AirPressure.  Please adjust these options for the following sample(s): `1`.";
Error::PressureTooHigh="For the following sample(s) (`1`), the specified Pressure and/or RetentateWashPressure exceeds the MaxPresure of the specified or automatically set filter(s) (`2`, `3`).  Please decrease the Pressure and/or RetentateWashPressure for these sample(s), or use a different filter with a higher allowed pressure.";
Error::UnusedPipettingOptions="The following sample(s) (`1`) are not going to be pipetted during this filter opteration because they are already in their filter.  However, the following pipetting option(s) are specified for these sample(s): `2`.  Please allow these options to be specified automatically.";
Error::FilterPlateOccupied="The following filter(s) (`1`) have contents that are not included in the input.  When filtering on plates, all contents must be filtered at once.  Please use a different filter, or include the full contents of the filter in the input.";
Error::ConflictingFilterPlateOptions="The following filter(s) (`1`) have contents that have conflicting option(s) `2`.  For all sample(s) in these filter(s), please ensure that these options are the same or allowed to set automatically, or to use different filters to accommodate these different parameters.";
Error::CollectionContainerNoCounterweights = "The following CollectionContainer(s) could not have any counterweights associated with them: `1`.  Please contact support to resolve this issue.";
Error::OccludingRetentateMismatch = "If CollectOccludingRetentate is set to False, then OccludingRetentateContainer, OccludingRetentateDestinationWell, and OccludingRetentateContainerLabel cannot be specified.  If CollectOccludingRetentate is True, then these options cannot be set to Null.  Please update these options for the following sample(s): `1`.";
Error::OccludingRetentateNotSupported = "CollectOccludingRetentate may only be set to True if FiltrationType is Syringe.  Please change the FiltrationType, or set CollectOccludingRetentate to False.";
Error::FilterPositionDestinationWellConflict = "If CollectionContainer and FiltrateContainerOut are the same container, then FilterPosition (`1`) and FiltrateDestinationWell (`2`) must be the same values as well.  Please change one or both of these options to agree.";

(* ::Subsubsection::Closed:: *)
(*ExperimentFilterOptions *)


DefineOptions[ExperimentFilterOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentFilter}];

ExperimentFilterOptions[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]|_String], myOptions: OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions,options},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* Get only the options for ExperimentFilter *)
	options = ExperimentFilter[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentFilter],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentFilterQ*)


DefineOptions[ValidExperimentFilterQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentFilter}
];


ValidExperimentFilterQ[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]|_String], myOptions: OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, experimentFilterTests, initialTestDescription, allTests, verbose, outputFormat},

(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* Remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Return only the tests for ExperimentFilter *)
	experimentFilterTests = ExperimentFilter[myInputs, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentFilterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

		(* Generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs],_String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs],_String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest, experimentFilterTests, voqWarnings}]
		]
	];
	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFilterQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentFilterQ"]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentFilterWorkCell*)


(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveExperimentFilterWorkCell,
	SharedOptions :> {
		ExperimentFilter,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(*resolveExperimentFilterWorkCell*)

resolveExperimentFilterWorkCell[
	mySamples_ , myOptions : OptionsPattern[]
] := Module[{workCell, userChosenInstrument, usableCentrifugeDevices, hasHiG, hasVSpin, usingCentrifugeQ, cache, simulation},

	(* Get the specified work cells and instrument, and simulation and cache *)
	workCell = Lookup[myOptions, WorkCell, Automatic];
	userChosenInstrument = Flatten[Lookup[myOptions, {Instrument}, {}]];

	simulation = Lookup[myOptions, Simulation, Null];
	cache = Lookup[myOptions, Cache, {}];

	(* all of these are centrifuge options that indicate that we're doing Centrifuge *)
	(* with that said, even if none of these are specified we _still_ could end up using a centrifuge if truly nothing was specified, and in that case this is still ending up False *)
	usingCentrifugeQ = Or[
		(* FiltrationType set to Centrifuge *)
		MemberQ[Flatten[{Lookup[myOptions, FiltrationType]}], Centrifuge],
		(* Instrument set to a centrifuge *)
		MemberQ[userChosenInstrument, ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}]],
			(* Intensity or RetentateWashCentrifugeIntensity set *)
		MemberQ[
			Flatten[Lookup[myOptions, {Intensity, PrewetFilterCentrifugeIntensity, RetentateWashCentrifugeIntensity}]],
			UnitsP[GravitationalAcceleration] | UnitsP[RPM]
		]
	];

	(* Get the usable centrifuge devices; obviously this is only if we actually are using the centrifuge *)
	usableCentrifugeDevices = Which[
		(* If a set of instruments is passed in, use those only *)
		usingCentrifugeQ && MatchQ[userChosenInstrument, {ObjectP[] ..}], userChosenInstrument,
		usingCentrifugeQ,
			(*else, figure out which centrifuges can be used from inputted options. For now the only difference between
			hig and vspin is the speed it can spin, so that is the only thing we are checking *)
			(* Ignore container selection because Filter automatically makes the container *)
			(* Note that here I cannot actually tell because we don't know the filter yet, so the stack height (which is lower for the VSpin) isn't a factor  *)
			Cases[
				Flatten[CentrifugeDevices[
					Intensity -> Lookup[myOptions, Intensity, Automatic],
					(* this is a workcell selector so assume robotic *)
					Preparation -> Robotic,
					Cache -> cache,
					Simulation -> simulation
				]],
				ObjectP[{Model[Instrument], Object[Instrument]}]
			],
		True, {}
	];

	hasHiG = MemberQ[usableCentrifugeDevices, ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]];	(*Model[Instrument, Centrifuge, "HiG4"]*)
	hasVSpin = MemberQ[usableCentrifugeDevices, ObjectP[Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]]];	(*Model[Instrument, Centrifuge, "VSpin"]*)

	(* Determine the WorkCell that can be used: *)
	Which[
		(* If the WorkCell was specified, use that *)
		Not[MatchQ[workCell, Automatic]], {workCell},
		(* everything has an MPE2 so we can do any of these at this stage *)
		Not[usingCentrifugeQ], {STAR, bioSTAR, microbioSTAR},
		(* If we're using a centrifuge and it has VSpin and not HiG, then only the STAR *)
		hasVSpin && Not[hasHiG], {STAR},
		(* HiG4 is only available for bioSTAR and microbioSTAR *)
		hasHiG && Not[hasVSpin], {bioSTAR, microbioSTAR},
		(* Otherwise we're assuming we can do either *)
		True, {STAR, bioSTAR, microbioSTAR}
	]

];

(* ::Subsubsection::Closed:: *)
(*ExperimentFilterPreview*)


DefineOptions[ExperimentFilterPreview,
	SharedOptions :> {ExperimentFilter}
];

ExperimentFilterPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentFilter *)
	ExperimentFilter[myInputs, Append[noOutputOptions, Output -> Preview]]

];


DefineOptions[cacheLookup,
	Options :> {{RemoveLinks -> True, BooleanP, "Removes Link before returning any objects."}}
];

cacheLookup[myCachedPackets_, myObject_, myOptions:OptionsPattern[cacheLookup]] := cacheLookup[myCachedPackets, myObject, Null, myOptions];

cacheLookup[myCachedPackets_, myObject_, field_, myOptions:OptionsPattern[cacheLookup]] := Module[
	{myObjectNoLink,myObjectNoPacket,lookup,return,removeLinks,returnValue},

	removeLinks = OptionValue[RemoveLinks];

	(* Make sure that myObject isn't a link. *)
	myObjectNoLink = myObject/.{link_Link :> Download[link, Object]};

	(* Make sure we're working with objects and not packets *)
	myObjectNoPacket = If[MatchQ[myObjectNoLink, PacketP[]], Lookup[myObjectNoLink, Object], myObjectNoLink];

	(* First try to find the packet from the cache using Object->myObject *)
	lookup = FirstCase[myCachedPackets, KeyValuePattern[{Object -> ObjectP[Download[myObjectNoPacket, Object]]}], Association[]];

	return = If[!MatchQ[lookup, Association[]],
		lookup,
		FirstCase[myCachedPackets, KeyValuePattern[{Type -> Most[myObjectNoPacket], Name -> Last[myObjectNoPacket]}], <||>]
	];

	returnValue = If[NullQ[field], return,
		If[
			And[MatchQ[field, _List], Length[field] >= 2],
			cacheLookup[myCachedPackets, Lookup[return, First[field]], Rest[field]],
			If[MatchQ[field, _List],
				Lookup[return, First[field], $Failed],
				Lookup[return, field, $Failed]
			]
		]
	];

	If[And[removeLinks, MatchQ[returnValue, ListableP[LinkP[]]]], Download[returnValue, Object], returnValue]
];


Options[groupContainersOut]:= {DestinationWell -> Null, Cache -> {}, SamplesIn -> Null, FastAssoc -> <||>};

groupContainersOut[myCachedPackets_, myUngroupedContainersOut_, ops:OptionsPattern[groupContainersOut]] := Module[
	{
		numWells, numWellsReplaceRules, groupedPreResolvedContainerOut, positionsOfPreResolvedContainerOut, numWellsPerGrouping,
		groupedResolvedContainerOut, resolvedContainerOutReplaceRules, resolvedContainerOutWithUniques, uniqueUniques,
		uniqueIntegers, integersToDrawFrom, integersWithIntegersRemoved, integersForOldUniques, uniqueToIntegerReplaceRules,
		destinationWell, resolvedContainerOut, availablePositions, numPositionsRequired, availableWellsReplaceRules,
		wellsToUsePerIndexRules, resolvedDestinationWell, resolvedContainerOutWithoutNulls,
		resolvedDestinationWellWithoutNulls, samplesIn, maybeSamplesIn, safeOps, fastAssoc
	},

	(* Get the safe options *)
	safeOps = SafeOptions[groupContainersOut, ToList[ops]];

	(* Get the fast association; if it is not specified, then make one from myCachedPackets *)
	fastAssoc = If[MatchQ[Lookup[safeOps, Experiment`Private`FastAssoc], <||>],
		makeFastAssocFromCache[myCachedPackets],
		Lookup[safeOps, FastAssoc]
	];

	(* Get the DestinationWell option and the SamplesIn option *)
	destinationWell = Lookup[safeOps, DestinationWell, Null];
	maybeSamplesIn = Lookup[safeOps, SamplesIn, Null];
	samplesIn = If[NullQ[maybeSamplesIn],
		ConstantArray[Null, Length[myUngroupedContainersOut]],
		maybeSamplesIn
	];

	(* Get the max number of wells in each container *)
	numWells = Map[
		Switch[#,
			ObjectP[Model[Container, Plate]], fastAssocLookup[fastAssoc,#,NumberOfWells],
			ObjectP[Model[Container, Plate,Filter]], fastAssocLookup[fastAssoc,#,NumberOfWells],
			ObjectP[Object[Container, Plate]], fastAssocLookup[fastAssoc,#,{Model,NumberOfWells}],
			_, 1
		]&,
		myUngroupedContainersOut[[All,2]]
	];

	(* Make replace rules whereby a given pairing gets converted to the number of wells for that pairing *)
	numWellsReplaceRules = AssociationThread[myUngroupedContainersOut, numWells];

	(* Group the pre resolved containers out by what they are, being sure to Download object to ensure we group properly *)
	groupedPreResolvedContainerOut = GatherBy[myUngroupedContainersOut, {#[[1]], Download[#[[2]], Object]}&];

	(* Get the positions of the pre resolved containers out *)
	positionsOfPreResolvedContainerOut = Position[myUngroupedContainersOut, #]& /@ Alternatives @@@ groupedPreResolvedContainerOut;

	(* Get the number of wells per grouping *)
	numWellsPerGrouping = Map[
		Replace[First[#], numWellsReplaceRules, {0}]&,
		groupedPreResolvedContainerOut
	];

	(* Resolve the automatics for each grouping *)
	groupedResolvedContainerOut = MapThread[
		Function[{groupedContainers, numEmptyWells},
			Module[{partitionedContainers, partitionedContainersNoAutomatics},

				(* Partition the containers to correlate with the numUniques *)
				partitionedContainers = If[MatchQ[groupedContainers, {{Automatic, ObjectP[{Model[Container, Plate],Object[Container,Plate]}]}..}],
					Partition[groupedContainers, UpTo[numEmptyWells]],
					Partition[groupedContainers, 1]
				];

				(* Get the partitioned containers with no automatics *)
				partitionedContainersNoAutomatics = Map[
					#/.{Automatic -> ToString[Unique[]]}&,
					partitionedContainers
				];
				(* Remove the partitions *)
				Join @@ partitionedContainersNoAutomatics
			]
		],
		{groupedPreResolvedContainerOut, numWellsPerGrouping}
	];

	(* Make replace rules that effectively reorder the groupedPreResolvedContainerOut to the proper order *)
	resolvedContainerOutReplaceRules = MapThread[
		#1 -> #2&,
		{Join @@ positionsOfPreResolvedContainerOut, Join @@ groupedResolvedContainerOut}
	];

	(* Pull out the resolved ContainerOut option (still including uniques) *)
	resolvedContainerOutWithUniques = ReplacePart[myUngroupedContainersOut, resolvedContainerOutReplaceRules];

	(* Get the unique uniques unique integers *)
	uniqueUniques = DeleteDuplicates[Cases[resolvedContainerOutWithUniques[[All, 1]], Except[_Integer]]];
	uniqueIntegers = DeleteDuplicates[Cases[resolvedContainerOutWithUniques[[All, 1]], _Integer]];

	(* Get the list of integers we are going to draw from *)
	integersToDrawFrom = Range[Length[Join[uniqueUniques, uniqueIntegers]]];

	(* Get the integers to draw from with the already-selected integers removed *)
	integersWithIntegersRemoved = DeleteCases[integersToDrawFrom, Alternatives @@ uniqueIntegers];

	(* Get the first n integers to draw from that will be converted to uniques *)
	(* need to do this because if uniqueIntegers = {34} and uniqueUniques = {$4974, $4976, $4992, $5020}, integersWithIntegersRemoved will still be {1, 2, 3, 4, 5}, and we only need the first 4 *)
	integersForOldUniques = Take[integersWithIntegersRemoved, Length[uniqueUniques]];

	(* Make replace rules for uniques to integers *)
	uniqueToIntegerReplaceRules = AssociationThread[uniqueUniques, integersForOldUniques];

	(* Use the replace rules to have the resolved ContainerOut option; note that this gets a little hokey with Nulls so we need to do a final roundup afterwards *)
	resolvedContainerOutWithoutNulls = Replace[resolvedContainerOutWithUniques, uniqueToIntegerReplaceRules, {2}];

	(* Make the Nulls that were there at the beginning be there again *)
	resolvedContainerOut = MapThread[
		Function[{resolvedValue, inputValue},
			If[MemberQ[inputValue, Null],
				inputValue /. {Automatic -> Null},
				resolvedValue
			]
		],
		{resolvedContainerOutWithoutNulls, myUngroupedContainersOut}
	];

	(* If we don't also want the DestinationWell then just exit here *)
	If[MatchQ[destinationWell, Null],
		Return[resolvedContainerOut]
	];

	(* Get the available positions for the containers *)
	availablePositions = MapThread[
		Function[{containerIndex, containerOut, specifiedWell, sampleIn},
			Module[{containerOrModelPacket, containerPacket, containerModelPacket, totalNumWells, allWells,
				occupiedPositions, contentsMinusSamplesIn, otherwiseSpecifiedPositions, allWellsMinusSpecifiedPositions},

				(* If containerOut and specifiedWell are Null, then we are just fast tracking to {}*)
				If[NullQ[containerOut] && NullQ[specifiedWell],
					Return[{}, Module]
				];

				(* Do some shenanigans to get the container packets *)
				containerOrModelPacket = fetchPacketFromFastAssoc[containerOut, fastAssoc];
				containerPacket = If[MatchQ[containerOrModelPacket, ObjectP[Object[Container]]],
					containerOrModelPacket,
					Null
				];
				containerModelPacket = If[NullQ[containerPacket],
					containerOrModelPacket,
					fetchPacketFromFastAssoc[Download[Lookup[containerPacket, Model], Object], fastAssoc]
				];

				(* Get the number of wells from the container (1 if it is not a plate) *)
				totalNumWells = If[MatchQ[containerModelPacket, ObjectP[Model[Container, Plate]]],
					Lookup[containerModelPacket, NumberOfWells],
					1
				];

				(* Get all the wells here; need to make special exceptions for 96 and 1; otherwise just use AllWells with NumberOfWells and AspectRatio *)
				allWells = Which[
					MatchQ[specifiedWell, WellP], {specifiedWell},
					totalNumWells == 1, {"A1"},
					totalNumWells == 96, Flatten[AllWells[]],
					True, Flatten[AllWells[NumberOfWells -> Lookup[containerModelPacket, NumberOfWells], AspectRatio -> Lookup[containerModelPacket, AspectRatio]]]
				];

				(* Get the contents not counting the SamplesIn (i.e., if the sample is already in the container, as in centrifuge filter tubes sometimes) *)
				contentsMinusSamplesIn = If[MatchQ[containerPacket, ObjectP[Object[Container]]],
					DeleteCases[Lookup[containerPacket, Contents], {_, ObjectP[sampleIn]}],
					Null
				];

				(* Get the occupied positions (if any) *)
				occupiedPositions = If[MatchQ[containerPacket, ObjectP[Object[Container]]],
					contentsMinusSamplesIn[[All, 1]],
					{}
				];

				(* Get all the positions already specified for the current index *)
				otherwiseSpecifiedPositions = With[{indexWellPairs = Transpose[{resolvedContainerOut[[All, 1]], destinationWell}]},
					Cases[indexWellPairs, {containerIndex, WellP}][[All, 2]]
				];

				(* Get all the positions that were otherwise specified for the given index *)
				(* Note that if we directly specified the well, this will result in this being {}.  That's ok though because directly specified wells jump the line below anyway *)
				allWellsMinusSpecifiedPositions = DeleteCases[allWells, Alternatives @@ Join[occupiedPositions, otherwiseSpecifiedPositions]];

				allWellsMinusSpecifiedPositions
			]
		],
		{resolvedContainerOut[[All, 1]], resolvedContainerOut[[All, 2]], destinationWell, samplesIn}
	];

	(* Make replace rules converting the index to the available wells in those indices *)
	availableWellsReplaceRules = Merge[
		DeleteDuplicates[MapThread[#1 -> #2&, {resolvedContainerOut[[All, 1]], availablePositions}]],
		Flatten
	];

	(* Count the number of positions we need for each index *)
	numPositionsRequired = Tally[resolvedContainerOut[[All, 1]]];

	(* Get the destination wells for each index *)
	(* Note that this is going to be in the form of {{1} -> "A1", {3} -> "A2", {4} -> "A3", {2} -> "A1"} to help with the ReplacePart step afterwards *)
	wellsToUsePerIndexRules = Flatten[Map[
		Function[{indexQuantityPair},
			With[{indexPotentialWells = indexQuantityPair[[1]] /. availableWellsReplaceRules, indexPositions = Position[resolvedContainerOut[[All, 1]], indexQuantityPair[[1]]]},
				(* If there are too many positions necessary for the index, go with Null and we'll do error checking afterwards *)
				(* If there are more positions than we need, then PadRight just acts like Take and the third argument doesn't do anything *)
				MapThread[#1 -> #2&, {indexPositions, PadRight[indexPotentialWells, indexQuantityPair[[2]], Null]}]
			]
		],
		numPositionsRequired
	]];

	(* Get the resolved DestinationWells; same as above, the Nulls are weird to deal with so just deal with them below *)
	resolvedDestinationWellWithoutNulls = ReplacePart[resolvedContainerOut, wellsToUsePerIndexRules];
	resolvedDestinationWell = MapThread[
		Function[{resolvedValue, inputValue},
			If[MatchQ[inputValue, WellP | Null],
				inputValue,
				resolvedValue
			]
		],
		{resolvedDestinationWellWithoutNulls, destinationWell}
	];

	(* If we got this far, return ContainerOut and DestinationWell *)
	{resolvedContainerOut, resolvedDestinationWell}

];


(* keysToGroupMultiple - this means one value per sample *)
groupByKey[listOfRules_, keysToGroupBy_] := Module[
	{
		keysToGroupValues, groupingKeys, groupingKeysUnique, listOfRulesNoSingletons,
		groupedByOptions, ruledGroupedOptions, ruledGroupingOptions, keysToGroup, singletonRules
	},

	If[MatchQ[keysToGroupBy, {}],
		Return[{{{}, listOfRules}}]
	];

	(* Get the singleton rules out of the list of rules *)
	singletonRules = Select[listOfRules, Not[ListQ[Last[#]]]&];
	listOfRulesNoSingletons = DeleteCases[listOfRules, Alternatives @@ singletonRules];

	keysToGroup = Keys[listOfRulesNoSingletons];

	(* Pull out the specific option permutations for all the fields we're grouping by *)
	keysToGroupValues = Transpose[Lookup[listOfRulesNoSingletons, keysToGroup]];

	(* These will be the options we group by, get a unique list of values to group by (eg. {{instrumentA, filterB},{instrumenB,filterB}} *)
	groupingKeys = Transpose[Lookup[listOfRulesNoSingletons, keysToGroupBy]];
	groupingKeysUnique = DeleteDuplicates[groupingKeys];

	(* Group the multiple options by the grouping fields *)
	groupedByOptions = Values[GroupBy[Transpose[{keysToGroupValues, groupingKeys}], Last -> First]];

	(* Rebuild the options (the ones we grouped) *)
	ruledGroupedOptions = Map[
		Function[{keySet},
			Join[
				MapThread[
					Rule[#1, #2]&,
					{
						keysToGroup,
						Transpose[keySet]
					}
				],
				singletonRules
			]
		],
		groupedByOptions
	];

	(* Rebuild the options (the ones we grouped by) *)
	ruledGroupingOptions = Map[
		Function[{keySet},
			MapThread[
				Rule[#1, #2]&,
				{
					keysToGroupBy,
					keySet
				}
			]
		],
		groupingKeysUnique
	];

	Transpose[{ruledGroupingOptions, ruledGroupedOptions}]

];


(* Expand the source/destination/amount/options based on the $MaxRoboticSingleTransferVolume *)
(* Go through our sources/destinations/amounts and see if we were asked to transfer an amount over this? *)
(* If so, then automatically split up that transfer into multiple transfers. *)
(* NOTE: This is technically overwriting the user's specified inputs in the builder, but this is the cleanest way to *)
(* Do it. *)
(* filter's resolver will also do this *)
(* NOTE: Sometimes the Filter option won't resolve properly (gets set to Null) but make sure to just filter this out. *)
expandInputsBasedOnMaxVolume[
	mySources: ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{_Integer,ObjectP[Model[Container]]}|{Alternatives@@Flatten[AllWells[]], ObjectP[Object[Container]]}],
	myDestinations: ListableP[ObjectP[{Object[Sample], Object[Container], Model[Container]}]|{_Integer, ObjectP[Model[Container]]}|{Alternatives@@Flatten[AllWells[]], ObjectP[Object[Container]]}|Waste],
	myAmounts: ListableP[VolumeP|All],
	myMapThreadFriendlyOptions: {(_Association | {_Rule...})...}
] := Module[
	{allValuesNested, nestedSources, nestedDestinations, nestedAmounts, nestedOptions},

	allValuesNested = MapThread[
		Function[{source, destination, amount, options},
			If[MatchQ[amount, GreaterP[$MaxRoboticSingleTransferVolume]],
				{
					(* Do the Floor[...] number of transfers of the $MaxRoboticSingleTransferVolume. *)
					Sequence@@ConstantArray[{source, destination, $MaxRoboticSingleTransferVolume, options}, Max[{Floor[amount/$MaxRoboticSingleTransferVolume], 1}]],

					(* If we have a remainder -- transfer the remaining volume. Otherwise, we've finished the transfer. *)
					If[!MatchQ[Unitless[Mod[$MaxRoboticSingleTransferVolume, amount]], 0|0.],
						{source, destination, Mod[amount, $MaxRoboticSingleTransferVolume], options},
						Nothing
					]
				},
				{{source, destination, amount, options}}
			]
		],
		{mySources, myDestinations, myAmounts, myMapThreadFriendlyOptions}
	];

	nestedSources = allValuesNested[[All, All, 1]];
	nestedDestinations = allValuesNested[[All, All, 2]];
	nestedAmounts = allValuesNested[[All, All, 3]];
	nestedOptions = allValuesNested[[All, All, 4]];

	{
		nestedSources,
		nestedDestinations,
		nestedAmounts,
		nestedOptions
	}

];
