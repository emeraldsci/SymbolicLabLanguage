(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ExperimentCoulterCount Options*)

DefineOptions[ExperimentCoulterCount,
	Options :> {
		(*------------------------------General------------------------------*)
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, CoulterCounter, "id:kEJ9mqJbrVpe"],
			Description -> "The instrument that is used to count and size particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities (see Figure 1.3). Note that the resistivity of the particles can be either larger or less than that of the electrolyte solution.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, CoulterCounter], Object[Instrument, CoulterCounter]}],
				OpenPaths->{
					{Object[Catalog,"Root"],"Instruments","Particle Analyzers"}
					(* catalog automatically screens objects/models based on the option's pattern *)
				}
			],
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the input samples to be inspected, for use in downstream unit operations.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Category -> "General",
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the container of the input samples to be inspected, for use in downstream unit operations.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Category -> "General",
				UnitOperation -> True
			}
		],
		{
			OptionName -> ApertureTube,
			Default -> Automatic,
			Description -> "A glass tube with a small aperture near the bottom through which particles are pumped to perturb the electrical resistance within the aperture for particle sizing and counting. The diameter of the aperture used for the electrical resistance measurement dictates the accessible window for particle size measurement, which is generally 2-80% of the ApertureDiameter.",
			ResolutionDescription -> "Automatically set to the aperture tube with aperture diameter equal to ApertureDiameter.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Part, ApertureTube], Object[Part, ApertureTube]}],
				OpenPaths->{
					{Object[Catalog,"Root"],"Materials","Coulter Counters","Aperture Tubes"}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> ApertureDiameter,
			Default -> Automatic,
			Description -> "The desired diameter of the aperture used for the electrical resistance measurement, which dictates the accessible window for particle size measurement, which is generally 2-80% of the ApertureDiameter.",
			ResolutionDescription -> "Automatically set based on the choice of ApertureTube and type of particles in the SamplesIn. Specifically, set to the ApertureDiameter value of the ApertureTube if specified, or set to a value in CoulterCounterApertureDiameterP that is greater than the largest diameters of all compositions in the SamplesIn. If none of the composition has a defined Diameter, set to "<>ToString[Max[List @@ CoulterCounterApertureDiameterP]]<>" to avoid blockage.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> CoulterCounterApertureDiameterP (* 10 µm|100 µm *)
			],
			Category -> "General"
		},
		{
			OptionName -> ElectrolyteSolution,
			Default -> Automatic,
			Description -> "The conductive solution used to suspend the particles to be counted and sized. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive. Please choose a sample solution with a solvent that does not dissolve or damage the target analyte particles to be counted and sized and an electrolyte chemical that maximizes the conductivity of the overall solution. For ApertureDiameter less than or equal to 30 Micrometer, please choose an electrolyte stock solution in the catalog that is filtered with FilterPoreSize less than or equal to 2% of the ApertureDiameter within two days.",
			ResolutionDescription -> "Automatically set to Model[Sample,\"Isoton II\"] if ApertureDiameter is greater than 30 Micrometer. Otherwise set to Model[Sample,StockSolution,\"Beckman Coulter ISOTON II Electrolyte Diluent, 500 mL, filtered\"].",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths->{
					{Object[Catalog,"Root"],"Materials","Coulter Counters","Electrolyte Solutions"}
				}
			],
			Category -> "General"
		},
		(*------------------------------flush settings: flush ApertureTube before changing the liquid in the MeasurementContainer------------------------------*)
		{
			OptionName -> ElectrolyteSolutionVolume,
			Default -> Automatic,
			Description -> "The amount of the electrolyte solution to be added into the ElectrolyteSolutionContainer of the coulter counter instrument. The amount added here supplies a reservoir of clean electrolyte solution that is pumped to flush the aperture tube before and after sample runs to remove particles that may remain trapped in the bottom of the aperture tube. The minimum amount needed to avoid drawing air into the system is 500 Milliliter.",
			ResolutionDescription -> "Automatically set to the calculated volume to fulfill all the flushes before and after sample runs based on number of SamplesIn plus a 1-Liter buffering volume for ElectrolyteContainer.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milliliter, 4 Liter],
				(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				Units -> {Milliliter, {Milliliter, Liter}}
			],
			Category -> "Flushing"
		},
		{
			OptionName -> FlushFlowRate,
			Default -> Automatic,
			Description -> "The target volume of the electrolyte solution pumped through the aperture of the ApertureTube per unit time when flushing the aperture tube (see Figure 2.1.1).",
			ResolutionDescription -> "Automatically set based on ApertureDiameter and internal PressureToFlowRateStandardCurve standard curve stored in ApertureTube object. If ApertureDiameter is greater than 560 Micrometer, set to a flow rate that maintains the internal pressure during pumping to be 3 Torr. Otherwise, set to a value that maintains the internal pressure to be 6 Torr during pumping.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter / Second, 10 Milliliter / Second],
				Units -> CompoundUnit[{1, {Microliter, {Microliter, Milliliter, Liter}}}, {-1, {Second, {Second, Minute, Hour}}}]
				(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
			],
			Category -> "Flushing"
		},
		{
			OptionName -> FlushTime,
			Default -> 12 Second,
			Description -> "The duration that electrolyte solution flow from ElectrolyteSolutionContainer, to ApertureTube, to ParticleTrapContainer, and to InternalWasteContainer is maintained, in an attempt to remove the particles inside the ApertureTube after connecting the ApertureTube to instrument for the first time, before and after sample runs, or before changing the sample in the MeasurementContainer (see Figure 2.1.1).",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Second, 5 * Minute],
				Units -> {Second, {Second, Minute}}
			],
			Category -> "Flushing"
		},
		(*------------------------------System suitability check options: whether to run system suitability check before each measurement to make sure instrument is sizing correctly or needs calibration------------------------------*)
		{
			OptionName -> SystemSuitabilityCheck,
			Default -> Automatic,
			Description -> "Indicates if a system suitability check with a particle size standard sample is run prior to the actual sample runs. During system suitability check, one or more size standard samples with known mean diameters or volumes are loaded into the instrument and sized via electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance. A discrepancy above SystemSuitabilityTolerance triggers the size-calibration procedure of the instrument to obtain a new calibration constant for the aperture tube. Afterwards, the system suitability check will automatically rerun to check if system suitability is restored. Calibration is triggered only once. If system suitability is not restored after calibration, SystemSuitabilityError is set to True in the protocol and data objects and if AbortOnSystemSuitabilityCheck is set to True, the experiment run will abort without collecting additional data.",
			ResolutionDescription -> "Automatically set to True if any suitability options are specified. Otherwise, set to False.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "System Suitability Check"
		},
		{
			OptionName -> SystemSuitabilityTolerance,
			Default -> Automatic,
			Description -> "The largest size discrepancy between the measured mean diameter and the manufacture-labelled mean diameter or the measured mean volume and the manufactured-labelled mean volume of SuitabilitySizeStandard sample(s) when sized by electrical resistance measurement to pass the system suitability check. A discrepancy above SystemSuitabilityTolerance triggers the size-calibration procedure of the instrument to obtain a new calibration constant for the aperture tube. Afterwards, the system suitability check will automatically rerun to check if system suitability is restored. Calibration is triggered only once. If system suitability is not restored after calibration, SystemSuitabilityError is set to True in the protocol object and if AbortOnSystemSuitabilityCheck is set to True, the experiment run will abort without collecting additional data.",
			ResolutionDescription -> "Automatically set to 4% if SystemSuitabilityCheck is True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent
			],
			Category -> "System Suitability Check"
		},
		IndexMatching[
			IndexMatchingParent -> SuitabilitySizeStandard,
			{
				OptionName -> SuitabilitySizeStandard,
				Default -> Automatic,
				Description -> "The particle size standard samples with known mean diameters or volumes used for the checking the system suitability. These standard samples are typically NIST traceable monodisperse polystyrene beads with sizes precharacterized by other standard techniques such as optical microscopy and transmission electron microscopy (TEM). Each of the samples is loaded into the instrument and sized by electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance.",
				ResolutionDescription -> "Automatically set to a particle size standard sample with a mean diameter closest to 20% of the ApertureDiameter in the catalog if SystemSuitabilityCheck is True. For example, if ApertureDiameter is 100 Micrometer, SuitabilitySizeStandard is automatically set to Model[Sample,\"L20 Standard, nominal 20\[Mu]m, Latex Particle (NIST Traceable), 1 x 15 mL\"].",
				(* select from a list of size standards for different ApertureDiameters *)
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths->{
						{Object[Catalog,"Root"],"Materials","Coulter Counters","Particle Size Standards"}
					}
				],
				Category -> "System Suitability Check"
			},
			{
				OptionName -> SuitabilityParticleSize,
				Default -> Automatic,
				Description -> "The manufacture-labeled mean diameter or volume of the particle size standard samples used for the system suitability check. The system is considered suitable when the measured mean particle diameter or volume matches SuitabilityParticleSize.",
				ResolutionDescription -> "Automatically set to the mean diameter in NominalParticleSize or ParticleSize field of the SuitabilitySizeStandard sample(s) if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Particle Diameter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter, 5 Millimeter],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer, {Nanometer, Micrometer, Millimeter}}
					],
					"Particle Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter^3, 20 Millimeter^3],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer^3, {Nanometer^3, Micrometer^3, Millimeter^3}}
					]
				],
				Category -> "System Suitability Check"
			},
			(*------------------------------options for sample prep and measurement parameters for system suitability check------------------------------*)
			{
				OptionName -> SuitabilityTargetConcentration,
				Default -> Automatic,
				Description -> "The target particle concentration in the solution from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume in SuitabilityMeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle, see ExperimentCoulterCount help file > Possible Issues) becomes severe if SuitabilityTargetConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SuitabilitySampleAmount, SuitabilityElectrolytePercentage, and SuitabilityElectrolyteSampleDilutionVolume. If the option information provided is not enough to calculate the target concentration, set to the calculated concentration to dilute the sample concentration by 1000x if SystemSuitabilityCheck is True. If sample concentration is not available, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> Alternatives[
						RangeP[0 Micromolar, 2 Micromolar],
						RangeP[0 EmeraldCell / Milliliter, 10^15 EmeraldCell / Milliliter],
						RangeP[0 Particle / Milliliter, 10^15 Particle / Milliliter]
					],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> Alternatives[
						{Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}},
						CompoundUnit[{1, {EmeraldCell, {EmeraldCell}}}, {-1, {Liter, {Microliter, Milliliter, Liter}}}],
						CompoundUnit[{1, {Particle, {Particle}}}, {-1, {Liter, {Microliter, Milliliter, Liter}}}]
					]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilitySampleAmount,
				Default -> Automatic,
				Description -> "The amount of SuitabilitySizeStandard sample(s) to be mixed with the electrolyte solution to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SuitabilityTargetConcentration, SuitabilityElectrolytePercentage, and SuitabilityElectrolyteSampleDilutionVolume. If the option information provided is not enough to calculate the required amount, set to the calculated amount to dilute the sample concentration by 1000x if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityElectrolyteSampleDilutionVolume,
				Default -> Automatic,
				Description -> "The amount of the electrolyte solution to be mixed with the SuitabilitySizeStandard sample(s) to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SuitabilitySampleAmount, SuitabilityElectrolytePercentage, and SuitabilityTargetConcentration. If the option information provided is not enough to calculate the required volume, set to the calculated volume to dilute the sample concentration by 1000x if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityElectrolytePercentage,
				Default -> Automatic,
				Description -> "The desired ratio of the volume of the electrolyte solution to the total volume in the sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the SuitabilityMeasurementContainer.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume, and SuitabilityTargetConcentration. If the option information provided is not enough to calculate the percentage, set to 99.9 Percent to dilute the sample concentration by 1000x if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityMeasurementContainer,
				Default -> Automatic,
				Description -> "The container that holds the SuitabilitySizeStandard sample-electrolyte solution mixture during mixing and electrical resistance measurement for the purpose of checking the system suitability.",
				ResolutionDescription -> "Automatically set to the container model that holds the total volume adding SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths->{
						{Object[Catalog,"Root"],"Materials","Coulter Counters","Containers"}
					}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityDynamicDilute,
				Default -> Automatic,
				Description -> "Indicates if additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the SuitabilitySizeStandard sample-electrolyte solution with ElectrolyteSolution according to SuitabilityConstantDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor and loaded for measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or SuitabilityMaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture is already within the suitable range even when SuitabilityDynamicDilute is set to True.",
				ResolutionDescription -> "Automatically set to True if any of the SuitabilityConstantDynamicDilutionFactor, SuitabilityCumulativeDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions options are specified and if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityConstantDynamicDilutionFactor,
				Default -> Automatic,
				Description -> "The constant factor by which the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
				ResolutionDescription -> "Automatically set to the value calculated from specified SuitabilityCumulativeDynamicDilutionFactor. Otherwise, set to 2 if SuitabilityDynamicDilute and SystemSuitabilityCheck is set to True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10^23]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityCumulativeDynamicDilutionFactor,
				Default -> Automatic,
				Description -> "The factor by which the particle concentration in the original SuitabilitySizeStandard sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in SuitabilityMaxNumberOfDynamicDilutions.",
				ResolutionDescription -> "Automatically set to the expanded list from SuitabilityConstantDynamicDilutionFactor and SuitabilityMaxNumberOfDynamicDilutions if SuitabilityDynamicDilute and SystemSuitabilityCheck is set to True. For example, if SuitabilityConstantDynamicDilutionFactor is 10 and SuitabilityMaxNumberOfDynamicDilutions is 3, SuitabilityCumulativeDynamicDilutionFactor is automatically set to {10, 100, 1000}.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 10^23]
					]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityMaxNumberOfDynamicDilutions,
				Default -> Automatic,
				Description -> "Max number of times for which the SuitabilitySizeStandard sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
				ResolutionDescription -> "If SuitabilityDynamicDilute and SystemSuitabilityCheck is set to True, SuitabilityMaxNumberOfDynamicDilutions is automatically set to the length of SuitabilityCumulativeDynamicDilutionFactor if SuitabilityCumulativeDynamicDilutionFactor is specified. Otherwise, set to 3 if SuitabilityDynamicDilute and SystemSuitabilityCheck is set to True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 999]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityMixRate,
				Default -> Automatic,
				Description -> "The rotation speed of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability. If SuitabilityMixRate is set to 0 RPM, the integrated stirrer will be put outside the SuitabilityMeasurementContainer and no mixing of the solution in SuitabilityMeasurementContainer is performed.",
				ResolutionDescription -> "Automatically set to 20 RPM if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 RPM, 120 RPM],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> RPM
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityMixTime,
				Default -> Automatic,
				Description -> "The duration that the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then sized by electrical resistance measurement for the purpose of checking the system suitability.",
				ResolutionDescription -> "Automatically set to 2 Minute if SuitabilityMixRate is not set to Null or 0 RPM and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 15 * Minute],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Minute, {Second, Minute}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityMixDirection,
				Default -> Automatic,
				Description -> "The rotation direction of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability.",
				ResolutionDescription -> "Automatically set to Clockwise if SuitabilityMixRate is not set to Null or 0 RPM and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Clockwise, Counterclockwise]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> NumberOfSuitabilityReadings,
				Default -> Automatic,
				Description -> "The number of times to perform identical system suitability runs on each SuitabilitySizeStandard sample-electrolyte solution mixture that is loaded into the instrument. Each of the system suitability runs is performed on the same sample-electrolyte solution mixture without reloading the instrument.",
				ResolutionDescription -> "Automatically set to 1 indicating no additional measurements on each loaded sample is performed if SystemSuitabilityCheck is set to True. If more than one measurement on each loaded sample is desired, this option must be manually set.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 30, 1]
					(* 96 is an arbitrary number that comes form the number of wells in a 96-well plate even though the sample is not necessarily in a plate *)
				],
				Category -> "System Suitability Measurement"
			}
		],
		(* Taking NumberOfSuitabilityReplicates out of index matching, it is a single value now *)
		{
			OptionName -> NumberOfSuitabilityReplicates,
			Default -> Null,
			Description -> "The number of replicate SuitabilitySizeStandard sample-electrolyte solution mixtures to prepare from mixing SuitabilitySizeStandard with ElectrolyteSolution. Each of the replicate mixture is loaded into the instrument individually with NumberOfSuitabilityReadings of system suitability runs performed.",
			ResolutionDescription -> "Automatically set to Null indicating no replicate sample is prepared if SystemSuitabilityCheck is set to True. If more than one replicate samples are desired, this option must be manually set.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[2, 96, 1]
				(* 96 is an arbitrary number that comes form the number of wells in a 96-well plate even though the sample is not necessarily in a plate *)
			],
			Category -> "System Suitability Measurement"
		},
		IndexMatching[
			IndexMatchingParent -> SuitabilitySizeStandard,
			{
				OptionName -> SuitabilityApertureCurrent,
				Default -> Automatic,
				Description -> "The value of the constant current that passes through the aperture of the ApertureTube during the system suitability run in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube. If measuring cellular particles, current set too high can damage the particles due to Joule heating.",
				ResolutionDescription -> "Automatically set to 1600 Microampere if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microampere, 10 Milliampere],
					Units -> {Microampere, {Microampere, Milliampere}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityGain,
				Default -> Automatic,
				Description -> "The amplification factor applied to the recorded voltage pulse during the system suitability run. Increasing the gain increases the signal and noise level simultaneously.",
				ResolutionDescription -> "Automatically set to 2 if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 99]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityFlowRate,
				Default -> Automatic,
				Description -> "The target volume of the SuitabilitySizeStandard sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the system suitability run.",
				ResolutionDescription -> "Automatically set based on ApertureDiameter and internal PressureToFlowRateStandardCurve standard curve stored in ApertureTube object. If ApertureDiameter is greater than 560 Micrometer, set to a flow rate that maintains the internal pressure during pumping to be 3 Torr if SystemSuitabilityCheck is True. Otherwise, set to a value that maintains the internal pressure to be 6 Torr during pumping if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter / Second, 10 Milliliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Microliter, Milliliter, Liter}}}, {-1, {Second, {Second, Minute, Hour}}}]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> MinSuitabilityParticleSize,
				Default -> Automatic,
				Description -> "Only particles with diameters or volumes greater than or equal to MinSuitabilityParticleSize are counted towards the SuitabilityTotalCount during the system suitability run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
				ResolutionDescription -> "Automatically set to 2.1% of the ApertureDiameter if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Particle Diameter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter, 5 Millimeter],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer, {Nanometer, Micrometer, Millimeter}}
					],
					"Particle Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter^3, 20 Millimeter^3],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer^3, {Nanometer^3, Micrometer^3, Millimeter^3}}
					]
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityEquilibrationTime,
				Default -> Automatic,
				Description -> "Duration of time before counting the voltage pulses towards the SuitabilityTotalCount after the SuitabilitySizeStandard sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to SuitabilityFlowRate during SuitabilityEquilibrationTime to reduce the noise level during the pulse recording.",
				ResolutionDescription -> "Automatically set to 3 Second if SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[3 * Second, 30 * Second],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Second, {Second, Minute}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityStopCondition,
				Default -> Automatic,
				Description -> "Indicates if the system suitability run of the SuitabilitySizeStandard sample-electrolyte solution mixture concludes based on Time, Volume, TotalCount, or ModalCount for each SuitabilitySizeStandard. In Time mode the system suitability run is performed until SuitabilityRunTime has elapsed. In Volume mode the system suitability run is performed until SuitabilityRunVolume of the sample from the SuitabilityMeasurementContainer has passed through the aperture of the ApertureTube. In TotalCount mode the system suitability run is performed until SuitabilityTotalCount of particles are counted in total. In ModalCount mode the system suitability run is performed until number of particles with sizes that appear most frequently exceeds SuitabilityModalCount (see Figure 1.2). Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
				ResolutionDescription -> "If SuitabilityRunTime is specified, SuitabilityStopCondition is automatically set to Time. If SuitabilityRunVolume is specified, SuitabilityStopCondition is automatically set to Volume. If SuitabilityTotalCount is specified, SuitabilityStopCondition is automatically set to TotalCount. If SuitabilityModalCount is specified, SuitabilityStopCondition is automatically set to ModalCount. Otherwise automatically set to Volume mode if SystemSuitabilityCheck is True and ApertureDiameter is less than 560 Micrometer. Otherwise set to Time mode if SystemSuitabilityCheck is True. ",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoulterCounterStopConditionP
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityRunTime,
				Default -> Automatic,
				Description -> "Duration of time of to perform the system suitability run to count and size particles. SuitabilityEquilibrationTime is not included in SuitabilityRunTime.",
				ResolutionDescription -> "Automatically set to 2 Minute if SuitabilityStopCondition is Time and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 999 Second],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Minute, {Second, Minute}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityRunVolume,
				Default -> Automatic,
				Description -> "The volume of the sample to pass through the aperture of the ApertureTube by the end of the system suitability run.",
				ResolutionDescription -> "Automatically set to 1000 Microliter if SuitabilityStopCondition is Volume and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[50 Microliter, 2 Milliliter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Microliter, {Microliter, Milliliter}}
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityTotalCount,
				Default -> Automatic,
				Description -> "Target total number of particles to be counted by the end of the system suitability run.",
				ResolutionDescription -> "Automatically set to 100,000 if SuitabilityStopCondition is TotalCount and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[50, 500000, 1]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "System Suitability Measurement"
			},
			{
				OptionName -> SuitabilityModalCount,
				Default -> Automatic,
				Description -> "Target number of particles with sizes that appear most frequently to be counted by the end of the system suitability run.",
				ResolutionDescription -> "Automatically set to 20,000 if SuitabilityStopCondition is ModalCount and SystemSuitabilityCheck is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[10, 100000, 1]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "System Suitability Measurement"
			}
		],
		{
			OptionName -> AbortOnSystemSuitabilityCheck,
			Default -> Automatic,
			Description -> "Indicates if the experiment is aborted early if system suitability check fails. Aborted experiments will not prepare the SamplesIn and will only consume the SuitabilitySizeStandard samples. If AbortOnSystemSuitabilityCheck is set to False, the experiment will continue to the end. If system suitability check fails, SystemSuitabilityError is set to True in the protocol and data object. Note that data obtained with SystemSuitabilityError marked True may provide less size accuracy therefore should be interpreted with caution.",
			ResolutionDescription -> "Automatically set to False if SystemSuitabilityCheck is True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "System Suitability Analysis"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(*------------------------------Sample preparation pre-dilution options: whether to dilute to bring down the particle concentration before measurement------------------------------*)
			(* Dilution options - this turns on and off the DilutionSharedOptions *)
			{
				OptionName -> Dilute,
				Default -> Automatic,
				Description -> "Indicates if preloading dilution or serial dilution is performed on each member of SamplesIn before mixing with electrolyte solution for electrical resistance measurement.",
				ResolutionDescription -> "Automatically set to True if any of the dilution options are specified. Otherwise set to True if the calculated particle concentration using specified SampleAmount, ElectrolyteSampleDilutionVolume, and ElectrolytePercentage is greater than the specified TargetMeasurementConcentration. The particle concentration is calculated from initial particle concentration in the SamplesIn, SampleAmount, and ElectrolyteSampleDilutionVolume. Otherwise, set to False.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Sample Dilution"
			},
			ModifyOptions[
				DilutionSharedOptions,
				DilutionType,
				{
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				DilutionStrategy,
				{
					Description -> "Indicates if only the final sample (EndPoint) or all diluted samples (Series) produced by serial dilution are used for following electrical resistance measurement. If set to Series, sample loading and electrical resistance measurement options are automatically expanded to be the same across all diluted samples, while TargetMeasurementConcentration and DiluentPercent options are not expanded to ensure the electrolyte concentration is the same across all sample-electrolyte solution mixtures prepared from diluted samples.",
					ResolutionDescription -> "Automatically set to EndPoint if Dilute is True and DilutionType is Serial.",
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			(*------------------------------DilutionSharedOptions------------------------------*)
			Sequence @@ ModifyOptions[
				DilutionSharedOptions,
				{
					NumberOfDilutions,
					TargetAnalyte,
					CumulativeDilutionFactor,
					SerialDilutionFactor,
					TransferVolume,
					TotalDilutionVolume,
					FinalVolume,
					DiscardFinalTransfer,
					Diluent,
					DiluentVolume,
					ConcentratedBuffer,
					ConcentratedBufferVolume,
					ConcentratedBufferDiluent,
					ConcentratedBufferDilutionFactor,
					ConcentratedBufferDiluentVolume
				},
				{
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				Incubate,
				{
					OptionName -> DilutionIncubate,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				IncubationTime,
				{
					OptionName -> DilutionIncubationTime,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				IncubationInstrument,
				{
					OptionName -> DilutionIncubationInstrument,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				IncubationTemperature,
				{
					OptionName -> DilutionIncubationTemperature,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				MixType,
				{
					OptionName -> DilutionMixType,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				NumberOfMixes,
				{
					OptionName -> DilutionNumberOfMixes,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				MixRate,
				{
					OptionName -> DilutionMixRate,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			],
			ModifyOptions[
				DilutionSharedOptions,
				MixOscillationAngle,
				{
					OptionName -> DilutionMixOscillationAngle,
					Default -> Automatic,
					AllowNull -> True,
					Category -> "Sample Dilution"
				}
			]
		],
		(*------------------------------Other Preparatory Unit Operations Primitives ------------------------------*)
		PreparatoryUnitOperationsOption,
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(*------------------------------Loading-related options: mixing sample with electrolyte solution and transfer to measurement container------------------------------*)
			{
				OptionName -> TargetMeasurementConcentration,
				Default -> Automatic,
				Description -> "The target particle concentration in the solution from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume in MeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle, see see ExperimentCoulterCount help file > Possible Issues) becomes severe if TargetMeasurementConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume. When using all dilution samples for the experiment by with DilutionStrategy set to All, TargetMeasurementConcentration refers to the target particle concentration from mixing the last dilution sample and ElectrolyteSampleDilutionVolume in MeasurementContainer.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SampleAmount, ElectrolytePercentage, and ElectrolyteSampleDilutionVolume. If the option information provided is not enough to calculate the target concentration, set to the calculated concentration to dilute the sample concentration by 1000x. If sample concentration is not available, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> Alternatives[
						RangeP[0 Micromolar, 2 Micromolar],
						RangeP[0 EmeraldCell / Milliliter, 10^15 EmeraldCell / Milliliter],
						RangeP[0 Particle / Milliliter, 10^15 Particle / Milliliter]
					],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> Alternatives[
						{Micromolar, {Nanomolar, Micromolar, Millimolar, Molar}},
						CompoundUnit[{1, {EmeraldCell, {EmeraldCell}}}, {-1, {Liter, {Microliter, Milliliter, Liter}}}],
						CompoundUnit[{1, {Particle, {Particle}}}, {-1, {Liter, {Microliter, Milliliter, Liter}}}]
					]
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> SampleAmount,
				Default -> Automatic,
				Description -> "The amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is counted and sized by electrical resistance measurement. Note that the particle concentration in the prepared sample(s) may be different from that in the SamplesIn if dilution and/or other preparatory operations are specified.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, TargetMeasurementConcentration, ElectrolytePercentage, and ElectrolyteSampleDilutionVolume. If the option information provided is not enough to calculate the required amount, set to the calculated amount to dilute the sample concentration by 1000x.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> ElectrolyteSampleDilutionVolume,
				Default -> Automatic,
				Description -> "The amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is counted and sized by electrical resistance measurement. Note that this option can be specified to zero volume if the sample has already been diluted with an electrolyte solution suitable for the electrical resistance measurement.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SampleAmount, ElectrolytePercentage, and TargetMeasurementConcentration. If the option information provided is not enough to calculate the required volume, set to the calculated volume to dilute the sample concentration by 1000x.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> ElectrolytePercentage,
				Default -> Automatic,
				Description -> "The desired ratio of the volume of the electrolyte solution to the total volume in the sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the MeasurementContainer.",
				ResolutionDescription -> "Automatically set to the value calculated from the sample concentration, SampleAmount, ElectrolyteSampleDilutionVolume, and SuitabilityTargetConcentration. If the option information provided is not enough to calculate the percentage, set to 99.9 Percent to dilute the sample concentration by 1000x.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> MeasurementContainer,
				Default -> Automatic,
				Description -> "The container that holds the sample-electrolyte solution mixture during mixing and electrical resistance measurement.",
				ResolutionDescription -> "Automatically set to the container model that holds the total volume adding SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths->{
						{Object[Catalog,"Root"],"Materials","Coulter Counters","Containers"}
					}
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> DynamicDilute,
				Default -> Automatic,
				Description -> "Indicates if additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the sample-electrolyte solution with ElectrolyteSolution according to ConstantDynamicDilutionFactor or CumulativeDynamicDilutionFactor and loaded for quick preview-type measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or MaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture is already within the suitable range even when DynamicDilute is set to True.",
				ResolutionDescription -> "Automatically set to True if any of the ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions options are specified.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> ConstantDynamicDilutionFactor,
				Default -> Automatic,
				Description -> "The constant factor by which the particle concentration in the sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
				ResolutionDescription -> "Automatically set to the value calculated from specified CumulativeDynamicDilutionFactor. Otherwise, set to 2 if DynamicDilute is set to True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10^23]
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> CumulativeDynamicDilutionFactor,
				Default -> Automatic,
				Description -> "The factor by which the particle concentration in the original sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in MaxNumberOfDynamicDilutions.",
				ResolutionDescription -> "Automatically set to the expanded list from ConstantDynamicDilutionFactor and MaxNumberOfDynamicDilutions if DynamicDilute is set to True. For example, if ConstantDynamicDilutionFactor is 10 and axNumberOfDynamicDilutions is 3, CumulativeDynamicDilutionFactor is automatically set to {10, 100, 1000}.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 10^23]
					]
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> MaxNumberOfDynamicDilutions,
				Default -> Automatic,
				Description -> "Max number of times for which the sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
				ResolutionDescription -> "If DynamicDilute is set to True, MaxNumberOfDynamicDilutions is automatically set to the length of CumulativeDynamicDilutionFactor if CumulativeDynamicDilutionFactor is specified. Otherwise, set to 3 if DynamicDilute is set to True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 999]
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> MixRate,
				Default -> Automatic,
				Description -> "The rotation speed of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement. If MixRate is set to 0 RPM, the integrated stirrer will be put outside the MeasurementContainer and no mixing of the solution in MeasurementContainer is performed.",
				ResolutionDescription -> "Automatically set to 20 RPM.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 RPM, 120 RPM],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> RPM
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> MixTime,
				Default -> Automatic,
				Description -> "The duration that the SampleAmount and ElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then counted and sized by electrical resistance measurement.",
				ResolutionDescription -> "Automatically set to 2 Minute if MixRate is not set to Null or 0 RPM.",
				(* set to a large enough number to make sure mixing is sufficient and thorough *)
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 15 * Minute],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Minute, {Second, Minute}}
				],
				Category -> "Sample Loading"
			},
			{
				OptionName -> MixDirection,
				Default -> Automatic,
				Description -> "The rotation direction of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement.",
				ResolutionDescription -> "Automatically set to Clockwise if MixRate is not set to Null or 0 RPM.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Clockwise, Counterclockwise]
				],
				Category -> "Sample Loading"
			},
			(*------------------------------Measurement parameters: instrument software setup------------------------------*)
			{
				OptionName -> NumberOfReadings,
				Default -> 1,
				Description -> "The number of times to perform identical sample runs to record voltage pulses on each sample-electrolyte solution mixture that is loaded into the instrument. Each of the sample run is performed on the same sample-electrolyte solution without reloading the instrument.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 30, 1]
					(* 96 is an arbitrary number that comes form the number of wells in a 96-well plate even though the sample is not necessarily in a plate *)
				],
				Category -> "Electrical Resistance Measurement"
			}
		],
		(* Taking NumberOfReplicates out of indexmatching *)
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of replicate sample-electrolyte solution mixtures to prepare from mixing each member of SamplesIn with ElectrolyteSolution. Each of the replicate mixture is loaded into the instrument individually with NumberOfReadings of system suitability runs performed.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[2, 96, 1]
				(* 96 is an arbitrary number that comes form the number of wells in a 96-well plate even though the sample is not necessarily in a plate *)
			],
			Category -> "Electrical Resistance Measurement"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ApertureCurrent,
				Default -> 1600 Microampere,
				Description -> "The value of the constant current that passes through the aperture of the ApertureTube during pulse recording in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube. If measuring cellular particles, current set too high can damage the particles due to Joule heating.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microampere, 10 Milliampere],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Microampere, {Microampere, Milliampere}}
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> Gain,
				Default -> 2,
				Description -> "The amplification factor applied to the recorded voltage pulse during the sample run. Increasing the gain increases the signal and noise level simultaneously.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 99]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> FlowRate,
				Default -> Automatic,
				Description -> "The target volume of the sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the sample run.",
				ResolutionDescription -> "Automatically set based on ApertureDiameter and internal PressureToFlowRateStandardCurve standard curve stored in ApertureTube object. If ApertureDiameter is greater than 560 Micrometer, set to a flow rate that maintains the internal pressure during pumping to be 3 Torr. Otherwise, set to a value that maintains the internal pressure to be 6 Torr during pumping.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter / Second, 10 Milliliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Microliter, Milliliter, Liter}}}, {-1, {Second, {Second, Minute, Hour}}}]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> MinParticleSize,
				Default -> Automatic,
				Description -> "Only particles with diameters or volumes greater than or equal to MinParticleSize are counted towards the TotalCount during the sample run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
				ResolutionDescription -> "Automatically set to 2.1% of the ApertureDiameter.",
				AllowNull -> False,
				Widget -> Alternatives[
					"Particle Diameter" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter, 5 Millimeter],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer, {Nanometer, Micrometer, Milliliter}}
					],
					"Particle Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Millimeter^3, 20 Millimeter^3],
						(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
						Units -> {Micrometer^3, {Nanometer^3, Micrometer^3, Milliliter^3}}
					]
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> EquilibrationTime,
				Default -> 3 Second,
				Description -> "Duration of time before counting the voltage pulses towards the TotalCount after the sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to FlowRate during EquilibrationTime to reduce the noise level during the pulse recording.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[3 * Second, 30 * Second],
					Units -> {Second, {Second, Minute}}
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> StopCondition,
				Default -> Automatic,
				Description -> "Indicates if the sample run of the sample-electrolyte solution mixture concludes based on Time, Volume, TotalCount, or ModalCount. In Time mode the sample run is performed until RunTime has elapsed. In Volume mode the sample run is performed until RunVolume of the sample from the MeasurementContainer has passed through the aperture of the ApertureTube. In TotalCount mode the sample run is performed until TotalCount of particles are counted in total. In ModalCount mode the sample run is performed until number of particles with sizes that appear most frequently exceeds ModalCount (see Figure 1.2). Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
				ResolutionDescription -> "If RunTime is specified, StopCondition is automatically set to Time. If RunVolume is specified, StopCondition is automatically set to Volume. If TotalCount is specified, StopCondition is automatically set to TotalCount. If ModalCount is specified, StopCondition is automatically set to ModalCount. Otherwise automatically set to Volume mode if ApertureDiameter is less than 560 Micrometer. Otherwise set to Time mode.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoulterCounterStopConditionP
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> RunTime,
				Default -> Automatic,
				Description -> "Duration of time of to perform one sample run to count and size particles in the sample-electrolyte solution mixture. EquilibrationTime is not included in RunTime.",
				ResolutionDescription -> "Automatically set to 2 Minute if StopCondition is Time.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 999 Second],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Minute, {Second, Minute}}
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> RunVolume,
				Default -> Automatic,
				Description -> "The volume of the sample to pass through the aperture of the ApertureTube by the end of the sample run.",
				ResolutionDescription -> "Automatically set to 1000 Microliter if StopCondition is Volume.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[50 Microliter, 2 Milliliter],
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
					Units -> {Microliter, {Microliter, Milliliter}}
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> TotalCount,
				Default -> Automatic,
				Description -> "Target total number of particles to be counted by the end of the sample run.",
				ResolutionDescription -> "Automatically set to 100,000 if StopCondition is TotalCount.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[50, 500000, 1]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> ModalCount,
				Default -> Automatic,
				Description -> "Target number of particles with sizes that appear most frequently to be counted by the end of the sample run.",
				ResolutionDescription -> "Automatically set to 20,000 if StopCondition is ModalCount.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[10, 100000, 1]
					(* set this upper/lower bound for future proof, will check with actual instrument max/min in option resolver and throw messages *)
				],
				Category -> "Electrical Resistance Measurement"
			},
			{
				OptionName -> QuantifyConcentration,
				Default -> Automatic,
				Description -> "Indicates if the concentration of the samples should be updated when the experiment concludes.",
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				ResolutionDescription -> "Automatically set to True if there is one countable analyte (such as cells, polymers etc) in the composition of SamplesIn.",
				Category -> "Quantification"
			}
		],
		(*------------------------------Post Measurement Options------------------------------*)
		ModifyOptions[
			NonBiologyPostProcessingOptions,
			MeasureWeight,
			{
				Default -> False
			}
		],
		ModifyOptions[
			NonBiologyPostProcessingOptions,
			MeasureVolume,
			{
				Default -> False
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 75 Milliliter."
			}

		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"Beckman Coulter Multisizer 4e Smart Technology (ST) Footed Beaker 100 mL\"]."
			}
		],
		ImageSampleOption,
		SamplesInStorageOptions,
		(*------------------------------Other Shared Options------------------------------*)
		ProtocolOptions,
		SimulationOption
	}
];


(* ::Subsection:: *)
(*ExperimentCoulterCount*)


(* ::Subsubsection:: *)
(*ExperimentCoulterCount Error Messages and Constants*)


Error::ApertureTubeDiameterMismatch = "The option ApertureDiameter->`1` is conflicting with the value `2` of the ApertureDiameter field in the option ApertureTube->`3`. Please provide alternative values for options: {ApertureDiameter, ApertureTube} and make sure they are consistent.";
Error::ParticleSizeOutOfRange = "The following object(s): `2` contain particles with sizes that are out of the accessible range of 2-80% of the ApertureDiameter `1` and therefore are beyond the instrument measurement capability. Please provide alternative values for options: {ApertureDiameter,ApertureTube} to provide a more suitable size window that can accommodate the particles out of the range, or remove the oversized samples: `3` and undersized samples: `4` from `5`.";
Warning::SolubleSamples = "The following object(s): `1` contain liquids that are in a different phase than ElectrolyteSolution `2` in use. The phase of the object(s) are predicted to be `3` while the phase of the ElectrolyteSolution is predicted to be `4`, leading to a risk of dissolving the particles of interest during measurement. Please be aware of the risk and interpret any experiment data with extra care, or consider removing the soluble object(s) from input or changing the choice of ElectrolyteSolution.";
Error::ConflictingSuitabilityCheckOptions = "The option(s): `2` are conflicting with the option SystemSuitabilityCheck->`1`. When SystemSuitability is set to True, these options must be specified with no Null values. When SystemSuitabilityCheck is set to False, these options must be set to Null or a list of Nulls. Please provide alternative values for options: `3` and make sure they are not conflicting.";
Warning::SystemSuitabilityToleranceTooHigh = "SystemSuitabilityTolerance of `1` is set too high, which may lead to an invalid system suitability check and inaccurate experiment data. SystemSuitabilityTolerance below 10 Percent is strongly recommended.";
Error::SuitabilitySizeStandardMismatch = "The following object(s): `1` specified in SuitabilitySizeStandard contain particles of sizes that are different from the SuitabilityParticleSize option value `2`. SuitabilityParticleSize should be set to a value same as either the ParticleSize or the NominalParticleSize field of the corresponding SuitabilitySizeStandard. Please provide alternative values for options: {SuitabilitySizeStandard,SuitabilityParticleSize} and make sure they are consistent";
Warning::TargetConcentrationNotUseful = "The initial particle concentration of the following object(s): `1` are unknown. Achieving `2`->`3` is not possible therefore these values are ignored during the preparation of the measurement sample(s).";
Error::ConflictingSampleLoadingOptions = "The following object(s): `1` specified have conflicting sample loading options `2`. The mathematical relation between TargetMeasurementConcentration `3`, SampleAmount `4`, ElectrolyteSampleDilutionVolume `5`, and ElectrolytePercentage `6`. Please refer to ExperimentCoulterCount documentation for more information of how these options are mathematically related and provide alternative, consistent values, or change the option value to Automatic for automatic calculation.";
Error::MeasurementContainerTooSmall = "For the following object(s): `1`, the options `2`  are too small to hold the total volume adding `3`. Please provide alternative values for options: `4` and make sure the MeasurementContainer or SuitabilityMeasurementContainer is large enough to accommodate the sample loading total volume.";
Error::NotEnoughMeasurementSample = "For the following object(s): `1`, the options `2`  provide a total volume of `3` that are not enough to satisfy the minimum volume `4` required for measurement. Please provide alternative values for sample loading options: `5` to increase the total volume of the measurement sample to be made during sample loading, or measurement options `6` to decrease the minimum volume required for each measurement.";
Error::ConflictingMixOptions = "The following object(s): `1` have conflicting mix options `2`: `1`. When MixRate or SuitabilityMixRate is set to Null or 0 RPM, MixDirection and MixTime must be set to Nulls, and vice versa. Please provide alternative values for options `3` and make sure they are consistent.";
Error::MinParticleSizeTooLarge = "For the following object(s): `1`, the options `2` are out of the accessible range of 2-80% of the ApertureDiameter `3` and therefore make an invalid measurement. Please provide alternative values for options: `4` and make sure they are all within the size window of the instrument capability.";
Error::ConflictingStopConditionOptions = "For the following object(s): `1`, the options `2` are conflicting with options `3`. When StopCondition or SuitabilityStopCondition is set to Time, only RunTime should be specified, similarly for {Volume,RunVolume}, {ModalCount,ModalCount}, and {TotalCount,TotalCount}. Please provide alternative values for options: `4` and make sure they are consistent.";
Error::NotEnoughElectrolyteSolution = "The supplied ElectrolyteSolutionVolume of `1` is not enough to fulfill all the flushes for all measurements which requires a minimum volume of `2`. Please provide alternative values for options: {ElectrolyteSolutionVolume} and make sure there is enough electrolyte solution to furnish flushing.";
Error::InvalidNumberOfDynamicDilutions = "For the following object(s): `1`, the options `2` have a length of `3` which is conflicting with the options `4` of `5`. Please provide alternative values for options: `6` and make sure they are consistent.";
Error::ConflictingDynamicDilutionOptions = "For the following object(s): `1`, the options `2` are conflicting with options `3`. When DynamicDilute or SuitabilityDynamicDilute is set to True, these options must be specified with no Null values. When DynamicDilute or SuitabilityDynamicDilute is set to False, these options must be set to Null or a list of Nulls. Please provide alternative values for options: `4` and make sure they are consistent.";
Error::ConstantCumulativeDilutionFactorMismatch = "For the following object(s): `1`, the options `2` of `3` are inconsistent with options `4` of `5`. ConstantDynamicDilutionFactor should be set to Null when the corresponding CumulativeDynamicDilutionFactor is set with variable adjacent dilution factors. On the other hand, ConstantDynamicDilutionFactor should be set to the serial dilution factor when the corresponding CumulativeDynamicDilutionFactor is set with constant serial dilution factors. Please provide alternative values for options: `6` and make sure they are consistent.";
Error::ConflictingDilutionOptions = "For the following object(s): `1`, the options `3` are conflicting with Dilute->`2`. Please provide alternative values for options: `4` and make sure they are consistent.";
Error::DynamicDiluteDilutionStrategyIncompatible = "For the following object(s): `1`, DynamicDilute is set to True when DilutionStrategy is set to Series. DynamicDilution is not supported when DilutionStrategy is Series (implying use of all dilution samples for the measurement). Please consider setting DynamicDilute->False, or DilutionStrategy->EndPoint to make sure they are compatible.";
Error::NonEmptyMeasurementContainers = "The following containers: {`2`,`3`} specified in the corresponding options: `1` are not empty therefore cannot be specified as measurement containers for this experiment. Please consider cleaning and dishwashing the corresponding containers, or specify other empty containers as alternatives.";
Warning::VolumeModeRecommended = "For the following object(s): `1`, it is recommended that the corresponding options: `2` are set to Volume mode instead for ApertureDiameter of `3` as the internal volume mode provides better accuracy regarding particle concentration measurement.";
Error::MoreThanOneComposition = "The following object (s): `1` contained more than one analytes: `2`. The concentration for these compositions the cannot be unambiguously assigned given the nature of this experiment. Please set QuantifyConcentration to False for these samples, and consider examining the data object after the experiment is completed and manually updating the composition.";
Warning::CannotMixMeasurementContainer = "For the following object(s): `1`, `2` is set or calculated to be `3`. Because the integrated stirrer for the coulter counter instrument does not support stirring small accuvettes, samples will be run without stirring during measurement.";


$MaxApertureDiameter = Max[List @@ CoulterCounterApertureDiameterP];

(* All aperture tube models we have in lab - doing a memoized search here *)
apertureTubeSearch[placeHolderString_String] := apertureTubeSearch[placeHolderString] = Module[{},
	(*Add apertureTubeSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`apertureTubeSearch];
	Search[Model[Part, ApertureTube], Deprecated != True && DeveloperObject != True]
];
$ApertureTubeModels := apertureTubeSearch["Memoization"];

(* All sizer standard samples that is recommended to use in lab - hard coded here *)
$SizeStandardModels = {
	Model[Sample, "id:AEqRl9q8GNr1"], (* Model[Sample,"Thermo Scientific 4000 Series Monosized Particles Size Standard 5 \[Micro]m"] *)
	Model[Sample, "id:Y0lXejlLdv1v"], (* Model[Sample,"Thermo Scientific 4000 Series Monosized Particles Size Standard 50 \[Micro]m"] *)
	Model[Sample, "id:Vrbp1jb90ome"], (* Model[Sample,"Thermo Scientific 3000 Series Nanosphere Size Standard 0.5 \[Micro]m"] *)
	Model[Sample, "id:WNa4ZjaGAmeV"], (* Model[Sample,"L10 Standard, nominal 10\[Mu]m, Latex Particle (NIST Traceable), 1 x 15 mL"] *)
	Model[Sample, "id:J8AY5jAnqOLj"](* Model[Sample,"L20 Standard, nominal 20\[Mu]m, Latex Particle (NIST Traceable), 1 x 15 mL"] *)
};

(* All coulter counter compatible container models - memoized search result  *)
coulterCounterContainerSearch[placeHolderString_String] := coulterCounterContainerSearch[placeHolderString] = Module[{},
	(*Add coulterCounterContainerSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`coulterCounterContainerSearch];
	Search[Model[Container, Vessel], Deprecated != True && DeveloperObject != True && Footprint == CoulterCounterContainerFootprintP]
];
$CoulterCounterContainerModels := coulterCounterContainerSearch["Memoization"];

(* CoulterCount dilution option names to DilutionSharedOptions option names map used in resolveSharedOptions *)
$CoulterCountToDilutionOptionsMap = {
	DilutionType -> DilutionType,
	DilutionStrategy -> DilutionStrategy,
	NumberOfDilutions -> NumberOfDilutions,
	TargetAnalyte -> TargetAnalyte,
	CumulativeDilutionFactor -> CumulativeDilutionFactor,
	SerialDilutionFactor -> SerialDilutionFactor,
	TargetAnalyteConcentration -> TargetAnalyteConcentration,
	TransferVolume -> TransferVolume,
	TotalDilutionVolume -> TotalDilutionVolume,
	FinalVolume -> FinalVolume,
	DiscardFinalTransfer -> DiscardFinalTransfer,
	Diluent -> Diluent,
	DiluentVolume -> DiluentVolume,
	ConcentratedBuffer -> ConcentratedBuffer,
	ConcentratedBufferVolume -> ConcentratedBufferVolume,
	ConcentratedBufferDiluent -> ConcentratedBufferDiluent,
	ConcentratedBufferDilutionFactor -> ConcentratedBufferDilutionFactor,
	ConcentratedBufferDiluentVolume -> ConcentratedBufferDiluentVolume,
	DilutionIncubate -> Incubate,
	DilutionIncubationTime -> IncubationTime,
	DilutionIncubationInstrument -> IncubationInstrument,
	DilutionIncubationTemperature -> IncubationTemperature,
	DilutionMixType -> MixType,
	DilutionNumberOfMixes -> NumberOfMixes,
	DilutionMixRate -> MixRate,
	DilutionMixOscillationAngle -> MixOscillationAngle
};

(* Types of models that we consider to be most likely particles or cells *)
$ParticleIdentityModelTypes = {
	Model[Molecule, Polymer],
	Model[Resin],
	Model[Cell] (* Including sub categories of cells such as Model[Cell, Mammalian], Model[Cell, Bacteria], Model[Cell, Yeast] *)
};

(* List out the suitability options that we need to convert into a MapThread-friendly version *)
$IndexMatchedSuitabilityOptionNames = Cases[OptionDefinition[ExperimentCoulterCount], KeyValuePattern["IndexMatching" -> "SuitabilitySizeStandard"]][[All, "OptionSymbol"]];

(* Hard code a list fo models that can be **counted** by common sense *)
$CoulterCountableAnalyteP = ObjectP[{
	Model[Molecule, cDNA],
	Model[Molecule, Oligomer],
	Model[Molecule, Transcript],
	Model[Molecule, Protein],
	Model[Molecule, Protein, Antibody],
	Model[Molecule, Carbohydrate],
	Model[Molecule, Polymer],
	Model[Lysate],
	Model[Cell]
}];

(* All suitability options that may be conflicting with SystemSuitabilityCheck *)
$SuitabilityOptions = Complement[ToExpression[Select[Keys[Options[ExperimentCoulterCount]], StringContainsQ[#, "Suitability"] &]], {SystemSuitabilityCheck}];
(* These options can be Null even if SystemSuitabilityCheck is set to True and we have conflicting checks later to check if they are consistent internally *)
$SuitabilityAllowNullOptions = {
	SuitabilityTargetConcentration, SuitabilityConstantDynamicDilutionFactor, SuitabilityCumulativeDynamicDilutionFactor,
	SuitabilityMaxNumberOfDynamicDilutions, SuitabilityMixRate, SuitabilityMixTime, SuitabilityMixDirection, NumberOfSuitabilityReplicates,
	SuitabilityRunTime, SuitabilityRunVolume, SuitabilityTotalCount, SuitabilityModalCount
};

$CoulterCountDilutionOptions = {
	DilutionType, DilutionStrategy, NumberOfDilutions, TargetAnalyte, CumulativeDilutionFactor, SerialDilutionFactor, TransferVolume, TotalDilutionVolume, FinalVolume,
	DiscardFinalTransfer, Diluent, DiluentVolume, ConcentratedBuffer, ConcentratedBufferVolume, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor,
	ConcentratedBufferDiluentVolume, DilutionIncubate, DilutionIncubationTime, DilutionIncubationInstrument, DilutionIncubationTemperature, DilutionMixType,
	DilutionNumberOfMixes, DilutionMixRate, DilutionMixOscillationAngle
};
(* These options can be Null even if master switch is set to True and we have conflicting checks later to check if they are consistent internally *)
$CoulterCountDilutionAllowNullOptions = {
	DilutionStrategy, SerialDilutionFactor, DiscardFinalTransfer, Diluent, DiluentVolume, ConcentratedBuffer, ConcentratedBufferVolume, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor,
	ConcentratedBufferDiluentVolume, DilutionIncubationTime, DilutionIncubationInstrument, DilutionIncubationTemperature, DilutionMixType, DilutionNumberOfMixes, DilutionMixRate,
	DilutionMixOscillationAngle
};


(* ::Subsubsection:: *)
(*Experiment function and overloads*)


(* -- Main Overload -- *)
ExperimentCoulterCount[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, returnEarlyQBecauseFailure, optionsResolverOnly, returnEarlyQBecauseOptionsResolverOnly, performSimulationQ,
		listedSamplesNamed, listedOptionsNamed, validSamplePreparationResult,
		mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, safeOpsNamed, safeOpsTests, safeOps,
		validLengths, validLengthTests, templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cache,
		sampleFields, sampleModelFields, moleculeFields, containerFields, containerModelFields,
		instrument, apertureTube, electrolyteSolution, suitabilitySizeStandards, suitabilityMeasurementContainers, measurementContainers,
		diluents, concentratedBuffers, concentratedBufferDiluents, diluentObjects, diluentModels,
		apertureTubeObjects, apertureTubeModels, sizeStandardSamples, sizeStandardModels, containerObjects, containerModels,
		coulterCountCache, cacheBall,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		resourcePacket, resourcePacketTests, coulterCounterSimulation, simulatedProtocol, protocolObject
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links *)
	{listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCoulterCount,
			listedSamplesNamed,
			listedOptionsNamed
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a  messages above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentCoulterCount, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentCoulterCount, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

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
		ValidInputLengthsQ[ExperimentCoulterCount, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentCoulterCount, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentCoulterCount, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentCoulterCount, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = Module[{inheritedOptionsWithWrongNesting, suitabilitySizeStandardList},
		inheritedOptionsWithWrongNesting = ReplaceRule[safeOps, templatedOptions];
		(* Need to manually make SuitabilitySizeStandard an explicit list b/c otherwise ExpandIndexMatchedInputs[...] won't work for options' singleton pattern being a list *)
		(* We are also expanding SuitabilitySizeStandard to a list of Automatics if necessary here *)
		suitabilitySizeStandardList = If[MatchQ[Lookup[inheritedOptionsWithWrongNesting, SuitabilitySizeStandard], Except[Automatic]],
			(* If user has already given us a list of non-Automatic values or a list of Automatics, don't expand, just ToList[...] *)
			ToList[Lookup[inheritedOptionsWithWrongNesting, SuitabilitySizeStandard]],
			(* Otherwise, expand a single Automatic according to index-matching variables *)
			Module[{lengthsOfSuitabilityOptions, lengthOfSuitabilityCumulativeDynamicDilutionFactor},
				(* Find out the effective length of all suitability options *)
				(* Note that we need to ToList[...] before calculating Length[...] otherwise we might end up calculating length of a different head other than List *)
				lengthsOfSuitabilityOptions = Length[ToList[#]]& /@ Lookup[inheritedOptionsWithWrongNesting, Complement[$IndexMatchedSuitabilityOptionNames, {SuitabilityCumulativeDynamicDilutionFactor}]];
				(* SuitabilityCumulativeDynamicDilutionFactor needs to be handled separately b/c its singleton form is a list already *)
				lengthOfSuitabilityCumulativeDynamicDilutionFactor = Module[{unresolvedSuitabilityCumulativeDynamicDilutionFactor},
					unresolvedSuitabilityCumulativeDynamicDilutionFactor = Lookup[inheritedOptionsWithWrongNesting, SuitabilityCumulativeDynamicDilutionFactor];
					If[MatchQ[unresolvedSuitabilityCumulativeDynamicDilutionFactor, {__?NumericQ}],
						1,
						Length[unresolvedSuitabilityCumulativeDynamicDilutionFactor]
					]
				];
				ConstantArray[Automatic, Max[lengthsOfSuitabilityOptions, lengthOfSuitabilityCumulativeDynamicDilutionFactor]]
			]
		];
		(* Do the replacement *)
		ReplaceRule[
			inheritedOptionsWithWrongNesting,
			{
				SuitabilitySizeStandard -> suitabilitySizeStandardList
			}
		]
	];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentCoulterCount, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(* Fetch the Cache options *)
	cache = Lookup[expandedSafeOps, Cache, {}];

	(* Disallow Upload->False and Confirm->True. *)
	(* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
	If[MatchQ[Lookup[safeOps, Upload], False] && TrueQ[Lookup[safeOps, Confirm]],
		Message[Error::ConfirmUploadConflict];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Fields we need for samples *)
	sampleFields = DeleteDuplicates[Flatten[{SampleHistory, Media, Solvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Model, Status, Analytes, State, Name, Density, Container, Composition, Position, Volume, CellType, ParticleSize, $PredictSamplePhaseSampleFields, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]}]];
	sampleModelFields = DeleteDuplicates[Flatten[{Media, Solvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated, Name, Composition, Density, CellType, NominalParticleSize, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]}]];
	moleculeFields = DeleteDuplicates[Flatten[{Density, CellType, Diameter, ParticleSize, $PredictSamplePhaseMoleculeFields}]];
	containerFields = {Status, Footprint, Model, Contents};
	containerModelFields = {Deprecated, MaxVolume, MinVolume, Footprint};

	(* Pull the info out of the options that we need to download from *)
	{
		instrument,
		apertureTube,
		electrolyteSolution,
		suitabilitySizeStandards,
		suitabilityMeasurementContainers,
		measurementContainers,
		diluents,
		concentratedBuffers,
		concentratedBufferDiluents
	} = Lookup[expandedSafeOps, {
		Instrument,
		ApertureTube,
		ElectrolyteSolution,
		SuitabilitySizeStandard,
		SuitabilityMeasurementContainer,
		MeasurementContainer,
		Diluent,
		ConcentratedBuffer,
		ConcentratedBufferDiluent
	}];

	(* Split the fields to download into objects and models *)
	apertureTubeObjects = DeleteDuplicates[Cases[ToList[apertureTube], ObjectP[Object[Part, ApertureTube]]]];
	apertureTubeModels = DeleteDuplicates[Join[Cases[ToList[apertureTube], ObjectP[Model[Part, ApertureTube]]], $ApertureTubeModels]];
	sizeStandardSamples = DeleteDuplicates[Cases[ToList[suitabilitySizeStandards], ObjectP[Object[Sample]]]];
	sizeStandardModels = DeleteDuplicates[Join[Cases[ToList[suitabilitySizeStandards], ObjectP[Model[Sample]]], $SizeStandardModels]];
	containerObjects = DeleteDuplicates[Cases[Flatten[{suitabilityMeasurementContainers, measurementContainers}], ObjectP[Object[Container]]]];
	containerModels = DeleteDuplicates[Join[Cases[Flatten[{suitabilityMeasurementContainers, measurementContainers}], ObjectP[Model[Container]]], $CoulterCounterContainerModels]];
	diluentObjects = Cases[Flatten[{electrolyteSolution, diluents, concentratedBuffers, concentratedBufferDiluents}], ObjectP[Object[Sample]]];
	diluentModels = DeleteDuplicates[Join[Cases[Flatten[{electrolyteSolution, diluents, concentratedBuffers, concentratedBufferDiluents}], ObjectP[Model[Sample]]], {Model[Sample, "id:8qZ1VWNmdLBD"]}]];(* Model[Sample, "Milli-Q water"] is the default diluent/concentratedBuffer/concentratedBufferDiluent by ResolvedDilutionSharedOptions[...] *)

	coulterCountCache = Quiet[
		Download[
			{
				(* 1 *)mySamplesWithPreparedSamples,
				(* 2 *)mySamplesWithPreparedSamples,
				(* 3 *)apertureTubeObjects,
				(* 4 *)apertureTubeModels,
				(* 5 *)sizeStandardSamples,
				(* 6 *)sizeStandardModels,
				(* 7 *)containerObjects,
				(* 8 *)containerModels,
				(* 9 *)diluentObjects,
				(* 10 *)diluentModels
			},
			{
				(* 1 *){Evaluate[Packet @@ sampleFields]},
				(* 2 *){Packet[Model[sampleModelFields]], Packet[Composition[[All, 2]][moleculeFields]], Packet[Solvent[sampleModelFields]], Packet[Solvent[Composition][[All, 2]][moleculeFields]], Packet[Media[sampleModelFields]], Packet[Media[Composition][[All, 2]][moleculeFields]], Packet[Container[containerFields]], Packet[Container[Model[containerModelFields]]]},
				(* 3 *){Packet[ApertureDiameter, Status, Calibration, CalibrationLog, Model], Packet[Model[ApertureDiameter, Deprecated, PressureToFlowRateStandardCurve]], Packet[Model[PressureToFlowRateStandardCurve[BestFitFunction]]]},
				(* 4 *){Packet[ApertureDiameter, Deprecated, PressureToFlowRateStandardCurve], Packet[PressureToFlowRateStandardCurve[BestFitFunction]]},
				(* 5 *){Evaluate[Packet @@ sampleFields], Packet[Model[sampleModelFields]], Packet[Composition[[All, 2]][moleculeFields]], Packet[Solvent[sampleModelFields]], Packet[Solvent[Composition][[All, 2]][moleculeFields]], Packet[Media[sampleModelFields]], Packet[Media[Composition][[All, 2]][moleculeFields]], Packet[Container[containerFields]], Packet[Container[Model[containerModelFields]]]},
				(* 6 *){Evaluate[Packet @@ sampleModelFields], Packet[Composition[[All, 2]][moleculeFields]], Packet[Solvent[sampleModelFields]], Packet[Solvent[Composition][[All, 2]][moleculeFields]], Packet[Media[sampleModelFields]], Packet[Media[Composition][[All, 2]][moleculeFields]]},
				(* 7 *){Evaluate[Packet @@ containerFields], Packet[Model[containerModelFields]]},
				(* 8 *){Evaluate[Packet @@ containerModelFields]},
				(* 9 *){Evaluate[Packet @@ sampleFields], Packet[Model[sampleModelFields]]},
				(* 10 *){Evaluate[Packet @@ sampleModelFields]}
			},
			Cache -> cache,
			Simulation -> samplePreparationSimulation
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall = FlattenCachePackets[{cache, coulterCountCache}];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentCoulterCountOptions[
			mySamplesWithPreparedSamples,
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation,
			Output -> {Result, Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {
				resolveExperimentCoulterCountOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> samplePreparationSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentCoulterCount,
		resolvedOptions,
		Ignore -> myOptionsWithPreparedSamples,
		Messages -> False
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyQBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQBecauseFailure = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Simulation | Result];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[(returnEarlyQBecauseFailure || returnEarlyQBecauseOptionsResolverOnly) && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentCoulterCount, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePacket, resourcePacketTests} = If[(returnEarlyQBecauseFailure || returnEarlyQBecauseOptionsResolverOnly),
		{$Failed, {}},
		If[gatherTests,
			experimentCoulterCountResourcePackets[ToList[mySamplesWithPreparedSamples], templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation, Output -> {Result, Tests}],
			{experimentCoulterCountResourcePackets[ToList[mySamplesWithPreparedSamples], templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation], {}}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, coulterCounterSimulation} = Which[
		(* If resource packet failed, no need to go to simulation since it will fail for sure *)
		MatchQ[resourcePacket, $Failed],
		{$Failed, samplePreparationSimulation},
		(* otherwise go into simulation *)
		performSimulationQ,
		simulateExperimentCoulterCount[resourcePacket, ToList[mySamplesWithPreparedSamples], resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation],
		(* catch all to make sure no weird result is output *)
		True,
		{Null, samplePreparationSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading,  don't bother calling UploadProtocol[...] *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentCoulterCount, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> coulterCounterSimulation
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePacket, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
		$Failed,
		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
		UploadProtocol[
			resourcePacket,
			Upload -> Lookup[expandedSafeOps, Upload],
			Confirm -> Lookup[expandedSafeOps, Confirm],
			CanaryBranch -> Lookup[expandedSafeOps, CanaryBranch],
			ParentProtocol -> Lookup[expandedSafeOps, ParentProtocol],
			ConstellationMessage -> Object[Protocol, CoulterCount],
			Cache -> cacheBall,
			Priority -> Lookup[expandedSafeOps, Priority],
			StartDate -> Lookup[expandedSafeOps, StartDate],
			HoldOrder -> Lookup[expandedSafeOps, HoldOrder],
			QueuePosition -> Lookup[expandedSafeOps, QueuePosition],
			Simulation -> coulterCounterSimulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentCoulterCount, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> coulterCounterSimulation
	}
];


(* --Container to Sample Overload-- *)
ExperimentCoulterCount[myContainers:ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions:OptionsPattern[]] := Module[
	{
		listedContainers, listedOptions, outputSpecification, output, gatherTests, cache,
		validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation,
		containerToSampleResult,
		containerToSampleOutput, samples, sampleOptions, containerToSampleTests, containerToSampleSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* convert input into list form *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions. *)
	cache = Lookup[listedOptions, Cache, {}];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCoulterCount,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 75 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "Beckman Coulter Multisizer 4e Smart Technology (ST) Footed Beaker 100 mL"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentCoulterCount,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Cache -> cache,
			Simulation -> samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentCoulterCount,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Cache -> cache,
				Simulation -> samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainer, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
			Simulation -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentCoulterCount[samples, ReplaceRule[sampleOptions, {Simulation -> containerToSampleSimulation, Cache -> cache}]]
	]
];


(* ::Subsubsection:: *)
(*resolveExperimentCoulterCountOptions*)

DefineOptions[
	resolveExperimentCoulterCountOptions,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

resolveExperimentCoulterCountOptions[mySamples:{ObjectP[Object[Sample]]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentCoulterCountOptions]] := Module[
	{
		outputSpecification, output, gatherTests, messages, warnings, simulation, cacheBall, fastCacheBall,
		instrument, unresolvedApertureTube, unresolvedElectrolyteSolution, unresolvedSuitabilitySizeStandards,
		apertureTubeModels, sizeStandardModels, samplePackets, apertureTubeModelPackets, sizeStandardModelPackets,
		(* Input Validation *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest,
		nonLiquidSamplePackets, nonLiquidInvalidInputs, nonLiquidTest,
		(* Option Precision *)
		optionPrecisions, roundedExperimentOptions, optionPrecisionTests, allOptionsRounded,
		(* Option Resolution Variables *)
		mapThreadFriendlyOptions,
		resolvedSampleLabels, resolvedSampleContainerLabels, resolvedApertureDiameter, resolvedApertureTube, pressureToFlowRateFun, resolvedElectrolyteSolution, resolvedEmail,
		resolvedSystemSuitabilityCheck, resolvedSystemSuitabilityTolerance, resolvedSuitabilitySizeStandards, resolvedAbortOnSystemSuitabilityCheck,
		resolvedSuitabilityParticleSizes, resolvedSuitabilityTargetConcentrations, resolvedSuitabilitySampleAmounts, resolvedSuitabilityElectrolyteSampleDilutionVolumes, resolvedSuitabilityElectrolytePercentages,
		resolvedSuitabilityMeasurementContainers, resolvedSuitabilityDynamicDilutes, resolvedSuitabilityConstantDynamicDilutionFactors, resolvedSuitabilityMaxNumberOfDynamicDilutions,
		resolvedSuitabilityCumulativeDynamicDilutionFactors, resolvedSuitabilityMixRates, resolvedSuitabilityMixTimes, resolvedSuitabilityMixDirections,
		resolvedNumberOfSuitabilityReadings, resolvedNumberOfSuitabilityReplicates, resolvedSuitabilityFlowRates,
		resolvedMinSuitabilityParticleSizes, resolvedSuitabilityEquilibrationTimes, resolvedSuitabilityStopConditions,
		resolvedSuitabilityRunTimes, resolvedSuitabilityRunVolumes, resolvedSuitabilityTotalCounts, resolvedSuitabilityModalCounts, resolvedSuitabilityApertureCurrents, resolvedSuitabilityGains,
		resolvedDilutes,
		resolvedDilutionTypes, preResolvedTargetAnalyteConcentrations, resolvedDilutionOptions, resolvedDilutionTests, resolvedTargetMeasurementConcentrations,
		resolvedSampleAmounts, resolvedElectrolytePercentages, resolvedElectrolyteSampleDilutionVolumes, resolvedMeasurementContainers, resolvedDynamicDilutes, resolvedConstantDynamicDilutionFactors,
		resolvedMaxNumberOfDynamicDilutions, resolvedCumulativeDynamicDilutionFactors, resolvedMixRates, resolvedMixTimes, resolvedMixDirections, resolvedNumberOfReadings, resolvedNumberOfReplicates,
		resolvedFlowRates, resolvedMinParticleSizes, resolvedEquilibrationTimes, resolvedStopConditions, resolvedRunTimes,
		resolvedRunVolumes, resolvedTotalCounts, resolvedModalCounts, resolvedQuantifyConcentrations, resolvedFlushFlowRate, resolvedElectrolyteSolutionVolume, unroundedResolvedSuitabilitySampleAmounts,
		unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes, unroundedResolvedElectrolyteSampleDilutionVolumes, unroundedResolvedSampleAmounts, resolvedPostProcessingOptions, resolvedOptions,
		(* Other Variables *)
		sampleMaxParticleDiameters, sampleParticleTypes, listedSuitabilitySizeStandardPackets, sampleStatesAfterDilution, sampleVolumesAfterDilution,
		sampleConcentrationsBeforeDilution, sampleConcentrationsAfterDilution, calculatedMeasurementConcentrationsBeforeDilution,
		sortedCoulterCounterContainerModelPackets, largestContainerMaxVolume, smallestContainerMaxVolume, totalFlushVolumeRequired, predictedSamplePhases,
		notEnoughMeasurementSampleAmountInformation, potentialAnalytesToUse,
		(* Error Checking *)
		apertureTubeDiameterMismatchError, apertureTubeDiameterMismatchInvalidOptions, apertureTubeDiameterMismatchTest, particleSizeOutOfRangeInvalidInputs, oversizedInvalidInputs, undersizedInvalidInputs,
		particleSizeOutOfRangeInvalidOptions, particleSizeOutOfRangeTest, outOfRangeSuitabilitySizeStandards, suitabilityParticleSizeOutOfRangeInvalidOptions, oversizedSuitabilitySizeStandards, undersizedSuitabilitySizeStandards,
		suitabilityParticleSizeOutOfRangeTest, solubleSamples, solubleSamplesTest, conflictingSuitabilityCheckInvalidOptions, conflictingSuitabilityCheckTest, suitabilityToleranceTooHighTest,
		suitabilitySizeStandardMismatchInvalidOptions, suitabilitySizeStandardMismatchErrors, suitabilitySizeStandardMismatchTest, targetConcentrationNotUsefulWarnings, targetConcentrationNotUsefulTest,
		suitabilityTargetConcentrationNotUsefulWarnings, suitabilityTargetConcentrationNotUsefulTest, conflictingSampleLoadingInvalidOptions, conflictingSampleLoadingInvalidSamples, conflictingSampleLoadingInformation, conflictingSampleLoadingTest,
		suitabilitySizeStandardConcentrations, measurementContainerTooSmallInvalidOptions, measurementContainerTooSmallInvalidSamples, measurementContainerTooSmallTest, notEnoughMeasurementSampleInvalidOptions,
		notEnoughMeasurementSampleErrors, notEnoughMeasurementSampleTest, conflictingMixInvalidOptions, conflictingMixInvalidSamples, conflictingMixTest, minParticleSizeTooLargeInvalidOptions, minParticleSizeTooLargeInvalidSamples,
		minParticleSizeTooLargeTest, conflictingStopConditionInvalidOptions, conflictingStopConditionInvalidSamples, conflictingStopConditionTest, notEnoughElectrolyteSolutionInvalidOptions, notEnoughElectrolyteSolutionTest, invalidNumberOfDynamicOfDilutionsInvalidOptions,
		invalidNumberOfDynamicOfDilutionsErrors, invalidNumberOfDynamicOfDilutionsTest, conflictingDynamicDilutionInvalidOptions, conflictingDynamicDilutionInvalidSamples, conflictingDynamicDilutionTest,
		constantCumulativeDilutionFactorMismatchInvalidOptions, constantCumulativeDilutionFactorMismatchErrors, constantCumulativeDilutionFactorMismatchTest, conflictingDilutionInvalidOptions, conflictingDilutionOptionsErrors,
		dynamicDiluteDilutionStrategyIncompatibleInvalidOptions, dynamicDiluteDilutionStrategyIncompatibleErrors, dynamicDiluteDilutionStrategyIncompatibleTest, conflictingDilutionOptionsTest,
		electrolyteSolutionPhase, nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors, nonEmptyMeasurementContainerInvalidOptions, nonEmptyMeasurementContainerTest, volumeModeRecommendedWarnings,
		volumeModeRecommendedInvalidOptions, volumeModeRecommendedInvalidSamples, volumeModeRecommendedTest, moreThanOneCompositionErrors, moreThanOneCompositionInvalidInputs, moreThanOneCompositionInvalidOptions, moreThanOneCompositionTest,
		cannotMixMeasurementContainerWarnings, cannotMixMeasurementContainerInvalidOptions, cannotMixMeasurementContainerTest, invalidInputs, invalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;
	warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Set up caches/fast assocs *)
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* Pull the info out of the options that we need to download from *)
	{
		instrument,
		unresolvedApertureTube,
		unresolvedElectrolyteSolution,
		unresolvedSuitabilitySizeStandards
	} = Lookup[myOptions, {
		Instrument,
		ApertureTube,
		ElectrolyteSolution,
		SuitabilitySizeStandard
	}];

	(* set the models objects to extract packets from fast cache *)
	apertureTubeModels = DeleteDuplicates[Join[Cases[ToList[unresolvedApertureTube], ObjectP[Model[Part, ApertureTube]]], $ApertureTubeModels]];
	sizeStandardModels = DeleteDuplicates[Join[Cases[ToList[unresolvedSuitabilitySizeStandards], ObjectP[Model[Sample]]], $SizeStandardModels]];
	{
		samplePackets,
		apertureTubeModelPackets,
		sizeStandardModelPackets
	} = {
		fetchPacketFromFastAssoc[#, fastCacheBall]& /@ mySamples,
		fetchPacketFromFastAssoc[#, fastCacheBall]& /@ apertureTubeModels,
		fetchPacketFromFastAssoc[#, fastCacheBall]& /@ sizeStandardModels
	};

	(*-- INPUT VALIDATION CHECKS --*)

	(* --- Discarded Samples --- *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Input samples "<>ObjectToString[discardedInvalidInputs, Cache -> cacheBall]<>" are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Input samples "<>ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall]<>" are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Only liquid sample is supported --- *)
	nonLiquidSamplePackets = Cases[samplePackets, KeyValuePattern[State -> Except[Liquid]]];

	(* set nonLiquidInvalidInputs to the input objects whose states are Gas *)
	nonLiquidInvalidInputs = Lookup[nonLiquidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[nonLiquidInvalidInputs] > 0 && messages,
		Message[Error::NonLiquidSamples, ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonLiquidTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidInvalidInputs] == 0,
				Nothing,
				Test["Input samples "<>ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall]<>" are liquid:", True, False]
			];
			passingTest = If[Length[nonLiquidInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Input samples "<>ObjectToString[Complement[mySamples, nonLiquidInvalidInputs], Cache -> cacheBall]<>" are liquid:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* Use scientific notation here to pass to RoundOptionPrecision[...] *)
	optionPrecisions = {
		{ElectrolyteSolutionVolume, 10^-1 * Microliter},
		{FlushFlowRate, 10^0 * Microliter / Second},
		{FlushTime, 10^-1 * Second},
		{SuitabilitySampleAmount, 10^-1 * Microliter},
		{SuitabilityElectrolyteSampleDilutionVolume, 10^-1 * Microliter},
		{SuitabilityMixTime, 10^-1 * Second},
		{SuitabilityMixRate, 10^0 * RPM},
		{SuitabilityFlowRate, 10^0 * Microliter / Second},
		{SuitabilityEquilibrationTime, 10^0 * Second},
		{SuitabilityRunTime, 10^0 * Second},
		{SuitabilityRunVolume, 10^0 * Microliter},
		{ElectrolyteSampleDilutionVolume, 10^-1 * Microliter},
		{MixTime, 10^-1 * Second},
		{MixRate, 10^0 * RPM},
		{FlowRate, 10^0 * Microliter / Second},
		{EquilibrationTime, 10^0 * Second},
		{RunTime, 10^0 * Second},
		{RunVolume, 10^0 * Microliter}
	};

	(* Round the options *)
	{roundedExperimentOptions, optionPrecisionTests} = Module[{roundedExperimentOptionsWithoutSampleAmount, tests, roundedSampleAmount},
		(* Round all other options *)
		{roundedExperimentOptionsWithoutSampleAmount, tests} = If[gatherTests,
			(* If we are gathering tests *)
			RoundOptionPrecision[Association[myOptions], optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
			(* Otherwise *)
			{RoundOptionPrecision[Association[myOptions], optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
		];
		(* Need to round precisions of SampleAmount twice since it can takes two units - mass and volume *)
		roundedSampleAmount = Module[{volumePos, massPos, roundedVolumes, roundedMasses, posToRoundedValueRules},
			(* Get the positions of the volume and mass quantity *)
			volumePos = Position[Lookup[myOptions, SampleAmount], VolumeP];
			massPos = Position[Lookup[myOptions, SampleAmount], MassP];
			(* Round the options *)
			roundedVolumes = Flatten@Values[RoundOptionPrecision[Association[SampleAmount -> Cases[Lookup[myOptions, SampleAmount], VolumeP]], SampleAmount, 10^-1 * Microliter]];
			roundedMasses = Flatten@Values[RoundOptionPrecision[Association[SampleAmount -> Cases[Lookup[myOptions, SampleAmount], MassP]], SampleAmount, 10^-1 * Milligram]];
			(* Get the Position to rounded value map *)
			posToRoundedValueRules = Join[MapThread[#1 -> #2&, {volumePos, roundedVolumes}], MapThread[#1 -> #2&, {massPos, roundedMasses}]];
			(* Insert back the rounded values *)
			<|SampleAmount -> ReplacePart[Lookup[myOptions, SampleAmount], posToRoundedValueRules]|>
		];
		(* Make the replacement and return results *)
		{
			Normal[Append[roundedExperimentOptionsWithoutSampleAmount, roundedSampleAmount], Association],
			tests
		}
	];

	(* Replace the raw options with rounded values in full set of options, myOptions *)
	allOptionsRounded = Module[{roundedExperimentOptionsList},
		(* Convert association of rounded options to a list of rules *)
		roundedExperimentOptionsList = Normal[roundedExperimentOptions, Association];
		ReplaceRule[
			myOptions,
			roundedExperimentOptionsList,
			Append -> False
		]
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentCoulterCount, roundedExperimentOptions];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Resolve label options *)
	resolvedSampleLabels = Module[
		{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		(* Create a unique label for each unique sample in the input *)
		suppliedSampleObjects = Lookup[samplePackets, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["coultercount sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];
		(* Expand the sample-specific unique labels *)
		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
					LookupObjectLabel[simulation, object],
					True,
					Lookup[preResolvedSampleLabelRules, object]
				]
			],
			{suppliedSampleObjects, Lookup[allOptionsRounded, SampleLabel]}
		]
	];

	resolvedSampleContainerLabels = Module[
		{suppliedContainerObjects, uniqueContainers, preResolvedSampleContainerLabels, preResolvedContainerLabelRules},
		(* Create a unique label for each unique container in the input *)
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, Nothing], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preResolvedSampleContainerLabels = Table[CreateUniqueLabel["coultercount sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preResolvedSampleContainerLabels}
		];
		(* Expand the sample-specific unique labels *)
		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
					LookupObjectLabel[simulation, object],
					True,
					Lookup[preResolvedContainerLabelRules, object]
				]
			],
			{suppliedContainerObjects, Lookup[allOptionsRounded, SampleContainerLabel]}
		]
	];

	(* Get the max particle diameter for each sample *)
	sampleMaxParticleDiameters = extractMaxParticleDiameter[#, fastCacheBall]& /@ samplePackets;

	(* Pull out any known particle types from the Composition,Solvent,Media fields of the sample in the case of if particle diameter is not available, we need particle type to estimate how big they are *)
	(* Right now we only care about CellType since each cell type has a roughly well-defined size range *)
	sampleParticleTypes = extractParticleTypes[#, fastCacheBall]& /@ samplePackets;

	(* Resolve ApertureDiameter *)
	resolvedApertureDiameter = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, ApertureDiameter], Except[Automatic]],
		Lookup[allOptionsRounded, ApertureDiameter],
		(* Otherwise if ApertureTube is set, set to ApertureDiameter of the model of the supplied ApertureTube *)
		MatchQ[unresolvedApertureTube, Except[Automatic]],
		(* If user specifies an object, set to ApertureDiameter of the corresponding Model *)
		If[MatchQ[unresolvedApertureTube, ObjectP[Object[Part, ApertureTube]]],
			fastAssocLookup[fastCacheBall, unresolvedApertureTube, {Model, ApertureDiameter}],
			(* otherwise if a model is specified, set to the ApertureDiameter of the model *)
			fastAssocLookup[fastCacheBall, unresolvedApertureTube, ApertureDiameter]
		],
		(* Otherwise if particle size is known for for any composition of the sample *)
		(* Use Max[...] to get the global max particle diameter *)
		!MatchQ[sampleMaxParticleDiameters, NullP],
		Module[{maxDiameter},
			(* Get the global max particle diameter *)
			maxDiameter = Max[Cases[sampleMaxParticleDiameters, DistanceP]];
			(* If the global max particle diameter is too large, set apertureDiameter to the largest value we have in lab and throw an error later *)
			If[MatchQ[maxDiameter, GreaterP[$MaxApertureDiameter]],
				$MaxApertureDiameter,
				(* If they fit, pick an ApertureDiameter that is just greater than the particle diameters *)
				FirstCase[Sort[List @@ CoulterCounterApertureDiameterP], GreaterEqualP[maxDiameter]]
			]
		],
		(* Otherwise if particle type is known for any composition of the sample *)
		!MatchQ[sampleParticleTypes, {($Failed | NullP)...}],
		Which[
			(* Set to 100 Micrometer if any Mammalian, Plant, or Insect cell type is present *)
			MemberQ[sampleParticleTypes, Mammalian | Plant | Insect, 2],
			100. * Micrometer,
			(*
			(* Set to 10 Micrometer if only Bacterial, Yeast, Fungal, or Microbial cell types are present*)
			MemberQ[sampleParticleTypes, Bacterial | Yeast | Fungal | Microbial, 2],
			10. * Micrometer,
			*)
			(* In all other cases default to largest aperture diameter we have in lab to avoid blockage *)
			True,
			$MaxApertureDiameter
		],
		(* Otherwise set to the largest aperture diameter we have in lab to avoid blockage *)
		True,
		$MaxApertureDiameter
	];

	(* Resolve ApertureTube *)
	resolvedApertureTube = Which[
		(* If it is set it is set *)
		MatchQ[unresolvedApertureTube, Except[Automatic]],
		unresolvedApertureTube,
		(* Otherwise set to it to the model that has field value of ApertureDiameter equal to resolvedApertureDiameter *)
		(* Use EqualP[...] here such that 100 Micrometer can be MatchQ-ed to 100. Micrometer *)
		(* If for any reason PickList[...] gives an empty list, set ApertureTube to Model[Part, ApertureTube, "Beckman Coulter Multisizer 4e Smart Technology Aperture Tube 100 \[Micro]m"] *)
		True,
		First[
			PickList[Lookup[apertureTubeModelPackets, Object], Lookup[apertureTubeModelPackets, ApertureDiameter], EqualP[resolvedApertureDiameter]],
			Model[Part, ApertureTube, "id:bq9LA095YBNd"]
		]
	];

	(* After resolving the aperture tube, obtain the analysis function *)
	pressureToFlowRateFun = If[MatchQ[resolvedApertureTube, ObjectP[Model[Part, ApertureTube]]],
		fastAssocLookup[fastCacheBall, resolvedApertureTube, {PressureToFlowRateStandardCurve, BestFitFunction}],
		fastAssocLookup[fastCacheBall, resolvedApertureTube, {Model, PressureToFlowRateStandardCurve, BestFitFunction}]
	];

	(* Use helper function PredictSamplePhase[...] to predict what phase each input sample is in - this information is potentially useful for following option resolutions though *)
	predictedSamplePhases = PredictSamplePhase[mySamples, Cache -> cacheBall, Simulation -> simulation];
	(* Resolve Electrolyte Solution *)
	resolvedElectrolyteSolution = Which[
		(* If it is set it is set *)
		MatchQ[unresolvedElectrolyteSolution, Except[Automatic]],
		unresolvedElectrolyteSolution,
		(* Otherwise, default to ISOTON II *)
		True,
		(* If ApertureDiameter in use is less than or equal to 30 Micrometer, use a filtered electrolyte solution *)
		If[MatchQ[resolvedApertureDiameter, LessEqualP[30 * Micrometer]],
			Model[Sample, StockSolution, "id:3em6Zvm8p8RM"], (* Model[Sample,StockSolution,"Beckman Coulter ISOTON II Electrolyte Diluent, 500 mL, filtered"] *)
			(* Otherwise, use the unfiltered version *)
			Model[Sample, "id:n0k9mGkbr8j6"](* Model[Sample,"Beckman Coulter ISOTON II Electrolyte Diluent"] *)
		]
	];

	(* resolve SystemSuitabilityCheck master switches *)

	(* Resolve SystemSuitabilityCheck *)
	resolvedSystemSuitabilityCheck = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, SystemSuitabilityCheck], Except[Automatic]],
		Lookup[allOptionsRounded, SystemSuitabilityCheck],
		(* Otherwise if any suitability options are specified by the user, doing a system suitability check is implied, set SystemSuitabilityCheck to True *)
		(* If any of these options are not set to Automatic or Null, set SystemSuitabilityCheck to True *)
		MemberQ[Lookup[allOptionsRounded, $SuitabilityOptions], Except[ListableP[Automatic | NullP]]],
		True,
		(* In all other cases, set it to False *)
		True,
		False
	];

	(* Resolve SystemSuitabilityTolerance *)
	resolvedSystemSuitabilityTolerance = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, SystemSuitabilityTolerance], Except[Automatic]],
		Lookup[allOptionsRounded, SystemSuitabilityTolerance],
		(* If SystemSuitabilityCheck is True, set it to 2 Percent *)
		TrueQ[resolvedSystemSuitabilityCheck],
		4 Percent,
		(* In all other cases, set it to Null *)
		True,
		Null
	];

	(* Resolve SystemSuitabilitySizeStandard *)
	resolvedSuitabilitySizeStandards = Module[{allNominalParticleSizes, allNominalParticleDiameters, nominalParticleDiameterToModelRules},
		(* Pull out all NominalParticleSize we know for all size standard models *)
		allNominalParticleSizes = Lookup[sizeStandardModelPackets, NominalParticleSize, Null];
		(* Convert distribution to diameter in unit of Micrometer *)
		allNominalParticleDiameters = convertParticleSizeToDiameter[allNominalParticleSizes, Micrometer];
		(* Create a particle size to model look up *)
		nominalParticleDiameterToModelRules = Normal[KeyDrop[Rule @@@ Transpose[{allNominalParticleDiameters, Lookup[sizeStandardModelPackets, Object, Null]}], Null], Association];
		Which[
			(* If it is set it is set *)
			!MemberQ[unresolvedSuitabilitySizeStandards, Automatic],
			unresolvedSuitabilitySizeStandards,
			(* If we are given SuitabilityParticleSize, try to find a suitability size standard model that is complying with SuitabilityParticleSize *)
			(* then default all Automatic to the size standard model with NominalParticleSize closest to 20% of the ApertureDiameter *)
			TrueQ[resolvedSystemSuitabilityCheck],
			(* convert any particle sizes to diameter unit first *)
			MapThread[
				Function[{suitabilityParticleSize, suitabilitySizeStandard},
					If[MatchQ[suitabilitySizeStandard, Automatic],
						(* Only try to resolve suitability size standard if it is set to Automatic, otherwise dont auto resolve *)
						If[MatchQ[suitabilityParticleSize, _?QuantityQ],
							(* If it is a quantity good, try to find the model with diameter closest to the specified value *)
							First[Nearest[nominalParticleDiameterToModelRules, First[convertParticleSizeToDiameter[suitabilityParticleSize, Micrometer]]]],
							(* Otherwise default to standard model with NominalParticleSize closest to 20% of the ApertureDiameter *)
							First[Nearest[nominalParticleDiameterToModelRules, 0.2 * resolvedApertureDiameter]]
						],
						suitabilitySizeStandard
					]
				],
				{Lookup[allOptionsRounded, SuitabilityParticleSize], unresolvedSuitabilitySizeStandards}
			],
			(* In all other cases, resolve all Automatics to Null *)
			True,
			Replace[unresolvedSuitabilitySizeStandards, Automatic -> Null, {1}]
		]
	];

	(* Resolve AbortOnSystemSuitabilityCheck *)
	resolvedAbortOnSystemSuitabilityCheck = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, AbortOnSystemSuitabilityCheck], Except[Automatic]],
		Lookup[allOptionsRounded, AbortOnSystemSuitabilityCheck],
		(* If SystemSuitabilityCheck is True, set it False because we are not going to abort experiment by default if system suitability fails *)
		TrueQ[resolvedSystemSuitabilityCheck],
		False,
		(* In all other cases, set it to Null *)
		True,
		Null
	];

	(* Get the suitability sample packets and sampleModel packets from cacheBall, these should be index matched to resolvedSuitabilitySizeStandards *)
	(* Replacing any Null that fetchPacketFromFastAssoc[...] gives with <||> so the result becomes immune to Lookup::invrl error *)
	listedSuitabilitySizeStandardPackets = Replace[fetchPacketFromFastAssoc[#, fastCacheBall]& /@ ToList[resolvedSuitabilitySizeStandards], NullP -> <||>, {1}];

	(* Sort all the coulter counter container models we have according to their MaxVolume *)
	sortedCoulterCounterContainerModelPackets = SortBy[fetchPacketFromFastAssoc[#, fastCacheBall]& /@ $CoulterCounterContainerModels, Lookup[#, MaxVolume]&];
	(* Find the max volume that the coulter coulter container models can hold in lab *)
	largestContainerMaxVolume = Lookup[Last[sortedCoulterCounterContainerModelPackets], MaxVolume];
	smallestContainerMaxVolume = Lookup[First[sortedCoulterCounterContainerModelPackets], MaxVolume];

	(* Resolve suitability options inside the MapThread[...] *)
	{
		resolvedSuitabilityParticleSizes,
		resolvedSuitabilityTargetConcentrations,
		unroundedResolvedSuitabilitySampleAmounts,
		unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes,
		resolvedSuitabilityElectrolytePercentages,
		resolvedSuitabilityMeasurementContainers,
		resolvedSuitabilityDynamicDilutes,
		resolvedSuitabilityConstantDynamicDilutionFactors,
		resolvedSuitabilityMaxNumberOfDynamicDilutions,
		resolvedSuitabilityCumulativeDynamicDilutionFactors,
		resolvedSuitabilityMixRates,
		resolvedSuitabilityMixTimes,
		resolvedSuitabilityMixDirections,
		resolvedNumberOfSuitabilityReadings,
		resolvedSuitabilityFlowRates,
		resolvedMinSuitabilityParticleSizes,
		resolvedSuitabilityEquilibrationTimes,
		resolvedSuitabilityStopConditions,
		resolvedSuitabilityRunTimes,
		resolvedSuitabilityRunVolumes,
		resolvedSuitabilityTotalCounts,
		resolvedSuitabilityModalCounts,
		resolvedSuitabilityApertureCurrents,
		resolvedSuitabilityGains,
		(* Gather this information for error checking *)
		suitabilitySizeStandardConcentrations
	} = If[TrueQ[resolvedSystemSuitabilityCheck],
		Module[{mapThreadFriendlySuitabilityOptions},
			(* Convert our suitability options into a MapThread friendly version with respect to size standard samples. *)
			(* Namely, in the form of {{SuitabilityParticleSize->value,SuitabilityTargetConcentration->value,...},...} *)
			mapThreadFriendlySuitabilityOptions = Module[{indexMatchedSuitabilityOptionValues},
				(* Get the option values of index matching suitability options *)
				(* Need to ToList/@... b/c otherwise the following MapThread won't give us a list of lists when the size standard is singular *)
				indexMatchedSuitabilityOptionValues = ToList /@ Lookup[allOptionsRounded, $IndexMatchedSuitabilityOptionNames];
				(* Thread each of the optionName into the corresponding list of optionValue to make a list of lists of optionName->optionValue pairs with the outermost list index matched to SuitabilitySizeStandard *)
				(* With an input of optionNames={A,B}, optionValues={{1,2},{3,4}} we should get {<|A->1,B->3|>,<|A->2,B->4|>} out, which is the mapThread-friendly format we want *)
				Association /@ Transpose[MapThread[
					Function[{name, values},
						Map[
							(name -> #)&,
							values
						]
					],
					{$IndexMatchedSuitabilityOptionNames, indexMatchedSuitabilityOptionValues}
				]]
			];

			(* Resolve suitability options inside the MapThread[...] *)
			Transpose[MapThread[
				Function[{suitabilityOptions, suitabilitySizeStandardPacket},
					Module[
						{
							resolvedSuitabilityParticleSize, unresolvedSuitabilityTargetConcentration, unresolvedSuitabilitySampleAmount, unresolvedSuitabilityElectrolyteSampleDilutionVolume, unresolvedSuitabilityElectrolytePercentage,
							unresolvedSuitabilityMeasurementContainer, resolvedSuitabilityTargetConcentration,
							sampleLoadingEquations, scaledTargetMeasurementConcentration, scaledSampleConcentration, scaledSampleAmount, scaledESDVolume, scaledSamplePercentage, solvedVarsWithUserSpecs,
							solvedQ, concentrationUnit, containerMaxVolume, suitabilitySampleVolume, resolvedSuitabilitySampleAmount, resolvedSuitabilityElectrolyteSampleDilutionVolume, resolvedSuitabilityElectrolytePercentage,
							resolvedSuitabilityMeasurementContainer, resolvedSuitabilityDynamicDilute, resolvedSuitabilityConstantDynamicDilutionFactor, resolvedSuitabilityMaxNumberOfDynamicDilutions,
							resolvedSuitabilityCumulativeDynamicDilutionFactor, resolvedSuitabilityMixRate, resolvedSuitabilityMixTime, resolvedSuitabilityMixDirection, resolvedNumberOfSuitabilityReadings,
							resolvedSuitabilityFlowRate, resolvedMinSuitabilityParticleSize,
							resolvedSuitabilityEquilibrationTime, resolvedSuitabilityStopCondition, resolvedSuitabilityRunTime, resolvedSuitabilityRunVolume,
							resolvedSuitabilityTotalCount, resolvedSuitabilityModalCount, suitabilitySizeStandardParticleType, suitabilitySizeStandardConcentration, resolvedSuitabilityApertureCurrent, resolvedSuitabilityGain
						},

						(* Resolve SuitabilityParticleSize *)
						resolvedSuitabilityParticleSize = Module[{particleSize},
							(* Get the particle size from SuitabilitySizeStandard from field ParticleSize (Object[Sample]), or NominalParticleSize (Model[Sample]) *)
							particleSize = Which[
								(* if SuitabilitySizeStandard is a model, look for NominalParticleSize *)
								MatchQ[suitabilitySizeStandardPacket, ObjectP[Model[Sample]]],
								Lookup[suitabilitySizeStandardPacket, NominalParticleSize],
								(* if SuitabilitySizeStandard is an object, look for ParticleSize *)
								MatchQ[suitabilitySizeStandardPacket, ObjectP[Object[Sample]]],
								Which[
									(* If we can find ParticleSize, set to ParticleSize if it is available *)
									MatchQ[Lookup[suitabilitySizeStandardPacket, ParticleSize, Null], DistributionP[]],
									Lookup[suitabilitySizeStandardPacket, ParticleSize],
									(* If ParticleSize is not available, look for NominalParticleSize in its model *)
									MatchQ[Lookup[suitabilitySizeStandardPacket, Model], ObjectP[]],
									fastAssocLookup[fastCacheBall, Lookup[suitabilitySizeStandardPacket, Model], NominalParticleSize],
									(* Otherwise set it to Null *)
									True,
									Null
								],
								(* if SuitabilitySizeStandard is not a valid packet, set to Null *)
								True,
								Null
							];
							(* resolve *)
							Which[
								(* If it is set it is set *)
								MatchQ[Lookup[suitabilityOptions, SuitabilityParticleSize], Except[Automatic]],
								Lookup[suitabilityOptions, SuitabilityParticleSize],
								(* If SystemSuitabilityCheck is True, set it to the NominalParticleSize or ParticleSize of the SuitabilitySizeStandard whichever is available*)
								TrueQ[resolvedSystemSuitabilityCheck] && MatchQ[particleSize, DistributionP[]],
								Mean[particleSize],
								(* In all other cases, set it to Null *)
								True,
								Null
							]
						];

						(* Pull out the particle types for the given size standard sample *)
						suitabilitySizeStandardParticleType = extractParticleTypes[suitabilitySizeStandardPacket, fastCacheBall];

						(* Resolve SuitabilityTargetConcentration, SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume, and SuitabilityMeasurementContainer *)
						(* Pull out the user-supplied value *)
						(* These are the values that are repeatedly used in resolving SampleAmount, ESDVolume, ElectrolytePercentage, and MeasurementContainer options *)
						{
							unresolvedSuitabilityTargetConcentration,
							unresolvedSuitabilitySampleAmount,
							unresolvedSuitabilityElectrolyteSampleDilutionVolume,
							unresolvedSuitabilityElectrolytePercentage,
							unresolvedSuitabilityMeasurementContainer
						} = Lookup[suitabilityOptions,
							{
								SuitabilityTargetConcentration,
								SuitabilitySampleAmount,
								SuitabilityElectrolyteSampleDilutionVolume,
								SuitabilityElectrolytePercentage,
								SuitabilityMeasurementContainer
							}
						];

						(* Extract the total particle concentration for the size standard sample *)
						suitabilitySizeStandardConcentration = Module[{targetUnit},
							(* Determine what unit we should look to convert to after we extract concentration in the sample composition *)
							(* If user specifies a TargetConcentration, use that unit *)
							targetUnit = If[MatchQ[unresolvedSuitabilityTargetConcentration, _?QuantityQ],
								Units[unresolvedSuitabilityTargetConcentration],
								(* Otherwise if we know the sample type *)
								(* Here we assume we always care Cell most b/c this instrument is primarily used to measure Cell Counts *)
								(* If sample is cell, default to Cells/mL *)
								If[MemberQ[suitabilitySizeStandardParticleType, CellTypeP],
									EmeraldCell / Milliliter,
									(* Otherwise, use ParticleConcentration (or Molar?) - subject to change after Wed discussion with Frezza *)
									(* Use Molar instead of Particle/Milliliter for now to represent particle concentration *)
									Molar
								]
							];
							(* Calculate the total concentration in the target unit from the sample *)
							calculateTotalConcentration[suitabilitySizeStandardPacket, targetUnit]
						];

						(* Setting up equals for resolving TargetMeasurementConcentration, SampleAmount, ElectrolyteSampleDilutionVolume, ElectrolytePercentage *)
						(* If sample concentration is available, we should be able to set all variables, otherwise, TargetMeasurementConcentration will be Null *)
						sampleLoadingEquations = If[MatchQ[suitabilitySizeStandardConcentration, _?QuantityQ],
							{
								scaledTargetMeasurementConcentration == scaledSampleConcentration * scaledSampleAmount / (scaledSampleAmount + scaledESDVolume),
								scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume)
							},
							{
								scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume)
							}
						];

						(* Initiate the variables by user specified values, also take away the unit *)
						scaledTargetMeasurementConcentration = If[MatchQ[unresolvedSuitabilityTargetConcentration, _?QuantityQ],
							(* If user gives us a target concentration, and sample concentration is available, convert to 1 / Milliliter *)
							unitlessCoulterCountConcentration[unresolvedSuitabilityTargetConcentration],
							(* Otherwise remain symbol form *)
							scaledTargetMeasurementConcentration
						];
						scaledSampleConcentration = If[MatchQ[suitabilitySizeStandardConcentration, _?QuantityQ],
							(* If sample concentration is available, convert to 1/Milliliter *)
							unitlessCoulterCountConcentration[suitabilitySizeStandardConcentration],
							scaledSampleConcentration
						];
						scaledSampleAmount = If[MatchQ[unresolvedSuitabilitySampleAmount, VolumeP],
							QuantityMagnitude[unresolvedSuitabilitySampleAmount, Milliliter],
							scaledSampleAmount
						];
						scaledESDVolume = If[MatchQ[unresolvedSuitabilityElectrolyteSampleDilutionVolume, VolumeP],
							QuantityMagnitude[unresolvedSuitabilityElectrolyteSampleDilutionVolume, Milliliter],
							scaledESDVolume
						];
						(* we need to introduce samplePercentage instead of electrolytePercentage to avoid 1/0 math *)
						scaledSamplePercentage = If[MatchQ[unresolvedSuitabilityElectrolytePercentage, Except[Automatic]],
							1 - Convert[unresolvedSuitabilityElectrolytePercentage, 1],
							scaledSamplePercentage
						];

						(* Solve the collective equation *)
						solvedVarsWithUserSpecs = Quiet[First[Solve[sampleLoadingEquations], {}]];
						(* Did we solve everything on the first try? *)
						solvedQ = MatchQ[Values[solvedVarsWithUserSpecs], {__?NumericQ}];

						(* This the concentration we are going to append to the target concentration *)
						concentrationUnit = Which[
							(* keep it the same as whatever the user-specified unit *)
							MatchQ[unresolvedSuitabilityTargetConcentration, _?QuantityQ],
							Units[unresolvedSuitabilityTargetConcentration],
							(* otherwise set to the unit of the sample concentration's *)
							MatchQ[suitabilitySizeStandardConcentration, _?QuantityQ],
							Units[suitabilitySizeStandardConcentration],
							(* otherwise set based on sample type, bio sample - EmeraldCell / Milliliter *)
							MemberQ[suitabilitySizeStandardParticleType, CellTypeP],
							EmeraldCell / Milliliter,
							(* Otherwise use molar *)
							True,
							Molar
						];
						(* get the max volume that container can take *)
						containerMaxVolume = Which[
							MatchQ[unresolvedSuitabilityMeasurementContainer, ObjectP[Object[Container, Vessel]]],
							fastAssocLookup[fastCacheBall, unresolvedSuitabilityMeasurementContainer, {Model, MaxVolume}],
							MatchQ[unresolvedSuitabilityMeasurementContainer, ObjectP[Model[Container, Vessel]]],
							fastAssocLookup[fastCacheBall, unresolvedSuitabilityMeasurementContainer, MaxVolume],
							True,
							largestContainerMaxVolume
						];
						(* get the volume of the suitability sample *)
						suitabilitySampleVolume = If[MatchQ[Lookup[suitabilitySizeStandardPacket, Volume], VolumeP], Lookup[suitabilitySizeStandardPacket, Volume], Infinity * Milliliter];

						Which[
							(* If every variable gets solved, easy to set up the sample loading options *)
							TrueQ[solvedQ],
							Module[{},
								(* set to the user specified value, otherwise the solved value *)
								resolvedSuitabilityTargetConcentration = Which[
									MatchQ[unresolvedSuitabilityTargetConcentration, Except[Automatic]], unresolvedSuitabilityTargetConcentration,
									(* if we are calculating using sample concentration, use solved value *)
									MatchQ[suitabilitySizeStandardConcentration, _?QuantityQ], appendCoulterCountConcentrationUnit[(scaledTargetMeasurementConcentration /. solvedVarsWithUserSpecs), concentrationUnit],
									(* otherwise set to Null *)
									True, Null
								];
								resolvedSuitabilitySampleAmount = Which[
									MatchQ[unresolvedSuitabilitySampleAmount, Except[Automatic]], unresolvedSuitabilitySampleAmount,
									MatchQ[(scaledSampleAmount /. solvedVarsWithUserSpecs), _?NumericQ], Max[(scaledSampleAmount /. solvedVarsWithUserSpecs) * Milliliter, 0 * Milliliter],
									(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
									True, Min[25 * Milliliter, suitabilitySampleVolume]
								];
								resolvedSuitabilityElectrolyteSampleDilutionVolume = Which[
									MatchQ[unresolvedSuitabilityElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedSuitabilityElectrolyteSampleDilutionVolume,
									MatchQ[(scaledESDVolume /. solvedVarsWithUserSpecs), _?NumericQ], Max[(scaledESDVolume /. solvedVarsWithUserSpecs) * Milliliter, 0 * Milliliter],
									(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
									True, 0 * Milliliter
								];
								resolvedSuitabilityElectrolytePercentage = If[MatchQ[unresolvedSuitabilityElectrolytePercentage, Except[Automatic]], unresolvedSuitabilityElectrolytePercentage, Convert[1 - (scaledSamplePercentage /. solvedVarsWithUserSpecs), Percent]]
							],
							(* Further resolve with second solve and defaults *)
							!MatchQ[solvedVarsWithUserSpecs, {}],
							Module[{unsolvedVars, secondSampleLoadingEquations, solvedVarsWithDefaults, secondSolvedQ},
								(* Extract the vars that still need to solve *)
								unsolvedVars = DeleteDuplicates@Cases[Values[solvedVarsWithUserSpecs], _Symbol, Infinity];

								(* resolve options or set based on different scenarios *)
								Switch[Length[unsolvedVars],
									(* user did not provide anything *)
									2,
									Module[{},
										(* set the sample amount to make sure we will not be requiring more sample than the input sample amount  *)
										scaledSampleAmount = Min[0.1, QuantityMagnitude[suitabilitySampleVolume, Milliliter]];
										(* set the esd volume to make sure we do not over fill the specified or largest measurement container in lab and diluting 1000x *)
										scaledESDVolume = Max[Min[scaledSampleAmount * 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledSampleAmount], 0];
										secondSampleLoadingEquations = sampleLoadingEquations;
									],
									(* user specified at least one variable *)
									1,
									Module[{userSpecifiedOptions},
										(* figure out which variable user specified *)
										userSpecifiedOptions = PickList[
											{SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume, SuitabilityElectrolytePercentage, SuitabilityTargetConcentration},
											{unresolvedSuitabilitySampleAmount, unresolvedSuitabilityElectrolyteSampleDilutionVolume, unresolvedSuitabilityElectrolytePercentage, unresolvedSuitabilityTargetConcentration},
											Except[Automatic]
										];

										Switch[First[userSpecifiedOptions],
											(* user specified sample amount *)
											SuitabilitySampleAmount,
											Module[{},
												(* set esd volume such that we are diluting 1000x and not overflow the largest measurement container we have in lab *)
												scaledESDVolume = Max[Min[scaledSampleAmount * 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledSampleAmount], 0];
												secondSampleLoadingEquations = sampleLoadingEquations;
											],
											SuitabilityElectrolyteSampleDilutionVolume,
											Module[{},
												(* set sample amount such that we are diluting 1000x and not overflow the largest measurement container we have in lab *)
												scaledSampleAmount = Max[Min[scaledESDVolume / 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledESDVolume, QuantityMagnitude[suitabilitySampleVolume, Milliliter]]];
												secondSampleLoadingEquations = sampleLoadingEquations;
											],
											SuitabilityElectrolytePercentage | SuitabilityTargetConcentration,
											Module[{},
												(* append an extra condition to the equation that we are always making 100mL in total here *)
												secondSampleLoadingEquations = If[
													Or[
														MatchQ[unresolvedSuitabilityElectrolytePercentage, EqualP[0]],
														MatchQ[unresolvedSuitabilityTargetConcentration, GreaterP[suitabilitySizeStandardConcentration]]
													],
													{
														scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume),
														scaledSamplePercentage == 1,
														scaledSampleAmount + scaledESDVolume == Min[25, QuantityMagnitude[suitabilitySampleVolume, Milliliter]]
													},
													Join[sampleLoadingEquations, {scaledSampleAmount + scaledESDVolume == 100}]
												];
											]
										]
									]
								];

								(* Solve again! *)
								solvedVarsWithDefaults = Quiet[First[Solve[secondSampleLoadingEquations], {}]];
								(* Did we solve everything on the second try? - this is the final solve *)
								secondSolvedQ = MatchQ[Values[solvedVarsWithDefaults], {__?NumericQ}];

								If[TrueQ[secondSolvedQ],
									(* We really should be here if we ever made this far *)
									Module[{},
										(* set to the user specified value, otherwise the solved value *)
										resolvedSuitabilityTargetConcentration = Which[
											MatchQ[unresolvedSuitabilityTargetConcentration, Except[Automatic]], unresolvedSuitabilityTargetConcentration,
											(* if we are calculating using sample concentration, use solved value *)
											MatchQ[suitabilitySizeStandardConcentration, _?QuantityQ], appendCoulterCountConcentrationUnit[(scaledTargetMeasurementConcentration /. solvedVarsWithDefaults), concentrationUnit],
											(* otherwise set to Null *)
											True, Null
										];
										resolvedSuitabilitySampleAmount = Which[
											MatchQ[unresolvedSuitabilitySampleAmount, Except[Automatic]], unresolvedSuitabilitySampleAmount,
											MatchQ[(scaledSampleAmount /. solvedVarsWithDefaults), _?NumericQ], Max[(scaledSampleAmount /. solvedVarsWithDefaults) * Milliliter, 0 * Milliliter],
											(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
											True, Min[25 * Milliliter, suitabilitySampleVolume]
										];
										resolvedSuitabilityElectrolyteSampleDilutionVolume = Which[
											MatchQ[unresolvedSuitabilityElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedSuitabilityElectrolyteSampleDilutionVolume,
											MatchQ[(scaledESDVolume /. solvedVarsWithDefaults), _?NumericQ], Max[(scaledESDVolume /. solvedVarsWithDefaults) * Milliliter, 0 * Milliliter],
											(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
											True, 0 * Milliliter
										];
										resolvedSuitabilityElectrolytePercentage = If[MatchQ[unresolvedSuitabilityElectrolytePercentage, Except[Automatic]], unresolvedSuitabilityElectrolytePercentage, Convert[1 - (scaledSamplePercentage /. solvedVarsWithDefaults), Percent]]
									],
									(* otherwise, the math must have been impossible due to user specified values *)
									True,
									Module[{},
										(* set to the user specified value, otherwise the solved value *)
										resolvedSuitabilityTargetConcentration = If[MatchQ[unresolvedSuitabilityTargetConcentration, Except[Automatic]], unresolvedSuitabilityTargetConcentration, Null];
										resolvedSuitabilitySampleAmount = If[MatchQ[unresolvedSuitabilitySampleAmount, Except[Automatic]], unresolvedSuitabilitySampleAmount, 0.1 * Microliter];
										resolvedSuitabilityElectrolyteSampleDilutionVolume = If[MatchQ[unresolvedSuitabilityElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedSuitabilityElectrolyteSampleDilutionVolume, 99.9 * Milliliter];
										resolvedSuitabilityElectrolytePercentage = If[MatchQ[unresolvedSuitabilityElectrolytePercentage, Except[Automatic]], unresolvedSuitabilityElectrolytePercentage, 99.9 * Percent]
									]
								]
							],
							(* if we end up here, the math must have been impossible due to user specified values *)
							True,
							Module[{},
								(* set to the user specified value, otherwise the solved value *)
								resolvedSuitabilityTargetConcentration = If[MatchQ[unresolvedSuitabilityTargetConcentration, Except[Automatic]], unresolvedSuitabilityTargetConcentration, Null];
								resolvedSuitabilitySampleAmount = If[MatchQ[unresolvedSuitabilitySampleAmount, Except[Automatic]], unresolvedSuitabilitySampleAmount, 0.1 * Microliter];
								resolvedSuitabilityElectrolyteSampleDilutionVolume = If[MatchQ[unresolvedSuitabilityElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedSuitabilityElectrolyteSampleDilutionVolume, 99.9 * Milliliter];
								resolvedSuitabilityElectrolytePercentage = If[MatchQ[unresolvedSuitabilityElectrolytePercentage, Except[Automatic]], unresolvedSuitabilityElectrolytePercentage, 99.9 * Percent]
							]
						];

						(* Resolve SuitabilityMeasurementContainer *)
						resolvedSuitabilityMeasurementContainer = Module[{totalVolume},
							(* This is the total volume that needs to be accommodated by the given container *)
							totalVolume = resolvedSuitabilitySampleAmount + resolvedSuitabilityElectrolyteSampleDilutionVolume;
							Which[
								(* If it is set it is set *)
								MatchQ[unresolvedSuitabilityMeasurementContainer, Except[Automatic]],
								unresolvedSuitabilityMeasurementContainer,
								(* Otherwise if resolvedSuitabilitySampleAmount and resolvedSuitabilityElectrolyteSampleDilutionVolume are both quantity values *)
								MatchQ[totalVolume, LessEqualP[largestContainerMaxVolume]],
								(* If we have a coulter counter container that can hold the total volume and not overflowing, set to that container model *)
								(* Overflow threshold is 100 Percent for now since these beakers are designed to hold liquid up to its max volume *)
								First[PickList[Lookup[sortedCoulterCounterContainerModelPackets, Object], Lookup[sortedCoulterCounterContainerModelPackets, MaxVolume], GreaterEqualP[totalVolume]]],
								(* Otherwise if we are doing system suitability check, set to the largest coulter counter container model we have in lab *)
								TrueQ[resolvedSystemSuitabilityCheck],
								Last[Lookup[sortedCoulterCounterContainerModelPackets, Object]],
								(* In all other cases, set it to Null *)
								True,
								Null
							]
						];

						(* Resolve SuitabilityApertureCurrent *)
						resolvedSuitabilityApertureCurrent = Which[
							(* If it is set it is set *)
							MatchQ[Lookup[suitabilityOptions, SuitabilityApertureCurrent], Except[Automatic]],
							Lookup[suitabilityOptions, SuitabilityApertureCurrent],
							(* default to 1600 uA if we are doing suitability check *)
							TrueQ[resolvedSystemSuitabilityCheck],
							1600 * Microampere,
							(* otherwise set to Null *)
							True,
							Null
						];

						(* Resolve SuitabilityGain *)
						resolvedSuitabilityGain = Which[
							(* If it is set it is set *)
							MatchQ[Lookup[suitabilityOptions, SuitabilityGain], Except[Automatic]],
							Lookup[suitabilityOptions, SuitabilityGain],
							(* default to 2 if we are doing suitability check *)
							TrueQ[resolvedSystemSuitabilityCheck],
							2,
							(* otherwise set to Null *)
							True,
							Null
						];

						(* Resolve the rest of the Sample Loading and Measurement options using helper *)
						{
							resolvedSuitabilityDynamicDilute,
							resolvedSuitabilityConstantDynamicDilutionFactor,
							resolvedSuitabilityMaxNumberOfDynamicDilutions,
							resolvedSuitabilityCumulativeDynamicDilutionFactor,
							resolvedSuitabilityMixRate,
							resolvedSuitabilityMixTime,
							resolvedSuitabilityMixDirection,
							resolvedNumberOfSuitabilityReadings,
							resolvedSuitabilityFlowRate,
							resolvedMinSuitabilityParticleSize,
							resolvedSuitabilityEquilibrationTime,
							resolvedSuitabilityStopCondition,
							resolvedSuitabilityRunTime,
							resolvedSuitabilityRunVolume,
							resolvedSuitabilityTotalCount,
							resolvedSuitabilityModalCount
						} = Module[{optionsPreresolved, optionsRenamed, suitabilityMeasurementContainerFootprint},
							(* If we are not doing system suitability check, preResolve every Automatic to Null before passing to the helper resolver *)
							(* We still pass the option with Nulls to the helper resolver just to sort the output - which may sound a little dumb *)
							optionsPreresolved = If[TrueQ[resolvedSystemSuitabilityCheck], suitabilityOptions, suitabilityOptions /. Automatic -> Null];
							(* Replace all SuitabilityXXX option names with Suitability stripped off to pass to the helper function *)
							(* eg SuitabilityMixRate (oldName) -> MixRate (newName), NumberOfSuitabilityReadings (oldName) -> NumberOfReadings (newName) *)
							optionsRenamed = KeyMap[
								(* We need to convert each Symbol of option names to a String first so we can easy manipulate and get rid of Suitability *)
								(* Then convert the resulted string back to Symbols *)
								ToExpression[StringReplace[ToString[#], (head___~~"Suitability"~~tail___) :> (head<>tail)]]&,
								optionsPreresolved
							];
							(* get the footprint of the resolved measurement container *)
							suitabilityMeasurementContainerFootprint = If[MatchQ[resolvedSuitabilityMeasurementContainer, ObjectP[Object[Container, Vessel]]],
								fastAssocLookup[fastCacheBall, resolvedSuitabilityMeasurementContainer, {Model, Footprint}],
								fastAssocLookup[fastCacheBall, resolvedSuitabilityMeasurementContainer, Footprint]
							];
							(* Then pass these options to the shared helper to get all the options sorted and resolved *)
							resolveCoulterCountMeasurementOptions[
								optionsRenamed,
								ApertureDiameter -> resolvedApertureDiameter,
								DilutionStrategy -> Null, (* no DilutionStrategy for Suitability samples *)
								QuantityFunction -> pressureToFlowRateFun,
								MeasurementContainerFootprint -> suitabilityMeasurementContainerFootprint
							]
						];

						(* Gather MapThread results *)
						{
							resolvedSuitabilityParticleSize,
							resolvedSuitabilityTargetConcentration,
							resolvedSuitabilitySampleAmount,
							resolvedSuitabilityElectrolyteSampleDilutionVolume,
							resolvedSuitabilityElectrolytePercentage,
							resolvedSuitabilityMeasurementContainer,
							resolvedSuitabilityDynamicDilute,
							resolvedSuitabilityConstantDynamicDilutionFactor,
							resolvedSuitabilityMaxNumberOfDynamicDilutions,
							resolvedSuitabilityCumulativeDynamicDilutionFactor,
							resolvedSuitabilityMixRate,
							resolvedSuitabilityMixTime,
							resolvedSuitabilityMixDirection,
							resolvedNumberOfSuitabilityReadings,
							resolvedSuitabilityFlowRate,
							resolvedMinSuitabilityParticleSize,
							resolvedSuitabilityEquilibrationTime,
							resolvedSuitabilityStopCondition,
							resolvedSuitabilityRunTime,
							resolvedSuitabilityRunVolume,
							resolvedSuitabilityTotalCount,
							resolvedSuitabilityModalCount,
							resolvedSuitabilityApertureCurrent,
							resolvedSuitabilityGain,
							(* gather this concentration for error checking *)
							suitabilitySizeStandardConcentration
						}
					]
				],
				{mapThreadFriendlySuitabilityOptions, listedSuitabilitySizeStandardPackets}
			]]
		],
		Join[
			Lookup[allOptionsRounded, {
				SuitabilityParticleSize,
				SuitabilityTargetConcentration,
				SuitabilitySampleAmount,
				SuitabilityElectrolyteSampleDilutionVolume,
				SuitabilityElectrolytePercentage,
				SuitabilityMeasurementContainer,
				SuitabilityDynamicDilute,
				SuitabilityConstantDynamicDilutionFactor,
				SuitabilityMaxNumberOfDynamicDilutions,
				SuitabilityCumulativeDynamicDilutionFactor,
				SuitabilityMixRate,
				SuitabilityMixTime,
				SuitabilityMixDirection,
				NumberOfSuitabilityReadings,
				SuitabilityFlowRate,
				MinSuitabilityParticleSize,
				SuitabilityEquilibrationTime,
				SuitabilityStopCondition,
				SuitabilityRunTime,
				SuitabilityRunVolume,
				SuitabilityTotalCount,
				SuitabilityModalCount,
				SuitabilityApertureCurrent,
				SuitabilityGain
			}] /. Automatic -> Null,
			{ConstantArray[Null, Length[ToList[resolvedSuitabilitySizeStandards]]]}
		]
	];

	(* For each sample, calculate the sample concentration before dilution as it is needed to resolve dilution master switches etc *)
	sampleConcentrationsBeforeDilution = MapThread[
		Function[{options, samplePacket, sampleParticleType},
			Module[{targetUnit},
				(* Sample concentration is determined by looking at the Composition field *)
				(* Determine what unit we should look to convert to after we extract concentration in the sample composition *)
				(* If user specifies a TargetConcentration, use that unit *)
				targetUnit = If[MatchQ[Lookup[options, TargetMeasurementConcentration], _?QuantityQ],
					Units[Lookup[options, TargetMeasurementConcentration]],
					(* Otherwise if we know the sample type *)
					(* Here we assume we always care Cell most b/c this instrument is primarily used to measure Cell Counts *)
					(* If sample is cell, default to Cells/mL *)
					If[MemberQ[sampleParticleType, CellTypeP],
						EmeraldCell / Milliliter,
						(* Otherwise, use Molar for all non-biological particles *)
						Molar
					]
				];
				(* Calculate the total concentration in the target unit from the sample *)
				calculateTotalConcentration[samplePacket, targetUnit]
			]
		],
		{mapThreadFriendlyOptions, samplePackets, sampleParticleTypes}
	];

	(* Calculate the particle concentration in the measurement containers based on any known information *)
	calculatedMeasurementConcentrationsBeforeDilution = MapThread[
		calculateMeasurementConcentration[
			#2,
			SampleAmount -> Lookup[#1, SampleAmount],
			ElectrolyteSampleDilutionVolume -> Lookup[#1, ElectrolyteSampleDilutionVolume],
			ElectrolytePercentage -> Lookup[#1, ElectrolytePercentage]
		]&,
		{mapThreadFriendlyOptions, sampleConcentrationsBeforeDilution}
	];

	(* Pre-resolve Dilute, DilutionType, and TargetAnalyteConcentration to pass to ResolveDilutionSharedOptions[...] inside MapThread *)
	{
		resolvedDilutes,
		resolvedDilutionTypes,
		preResolvedTargetAnalyteConcentrations
	} = Transpose[MapThread[
		Function[{options, sampleConcentrationBeforeDilution, calculatedMeasurementConcentrationBeforeDilution},
			Module[{resolvedDilute, numberOfDilutions, resolvedDilutionType, preResolvedTargetAnalyteConcentration},

				(* Resolve Dilute master switch for each input sample *)
				resolvedDilute = Which[
					(* If it is set it is set *)
					MatchQ[Lookup[options, Dilute], Except[Automatic]],
					Lookup[options, Dilute],
					(* Otherwise if any dilution options are specified by the user, doing a dilution is implied, set Dilute to True *)
					(* If any of these options are not set to Automatic or Null, set Dilute to True *)
					MemberQ[Lookup[options, $CoulterCountDilutionOptions], Except[ListableP[Automatic] | NullP]],
					True,
					(* Otherwise if TargetMeasurementConcentration is specified *)
					(* if the calculated measurement concentration based on any user-supplied sample loading options is greater than the specified TargetMeasurementConcentration, dilution is needed, set Dilute to True  *)
					MatchQ[Lookup[options, TargetMeasurementConcentration], _?QuantityQ],
					If[MatchQ[calculatedMeasurementConcentrationBeforeDilution, GreaterP[Lookup[options, TargetMeasurementConcentration]]],
						True,
						False
					],
					(* In all other cases, set to False *)
					True,
					False
				];

				(* Figure out what is the number of dilutions i.e. the length of the list of concentrations we are going to make *)
				numberOfDilutions = Which[
					(* If user specifies one use that value *)
					MatchQ[Lookup[options, NumberOfDilutions], Except[Automatic]],
					Lookup[options, NumberOfDilutions],
					(* Otherwise look at the length of TransferVolume, TotalDilutionVolume, FinalVolume, DiluentVolume, ConcentratedBufferVolume, ConcentratedBufferDilutionFactor, and ConcentratedBufferDiluentVolume *)
					True,
					FirstCase[
						Length[ToList[#]]& /@ Lookup[options, {TransferVolume, TotalDilutionVolume, FinalVolume, DiluentVolume, ConcentratedBufferVolume, ConcentratedBufferDilutionFactor, ConcentratedBufferDiluentVolume}],
						GreaterP[1],
						1
					]
				];

				(* Resolve DilutionType *)
				(* We are pre-resolving this option b/c in DilutionSharedOptions DilutionType is default to Linear instead of Automatic so it won't take Automatic to auto-resolve it *)
				resolvedDilutionType = Which[
					(* If it is set it is set *)
					MatchQ[Lookup[options, DilutionType], Except[Automatic]],
					Lookup[options, DilutionType],
					(* Otherwise if we are diluting *)
					TrueQ[resolvedDilute],
					(* If effective number of dilutions is greater than 1, set to Serial *)
					If[MatchQ[numberOfDilutions, GreaterP[1]],
						Serial,
						(* Otherwise set to Linear *)
						Linear
					],
					(* In all other cases, set to Null *)
					True,
					Null
				];

				(* Pre-resolve TargetAnalyteConcentration *)
				(* Since user only specifies the final final concentration in the measurement container after sample or diluted sample is mixed with electrolyte solution *)
				(* This is the concentration of the diluted sample BEFORE mixing with the electrolyte solution, not an option surfaced to the user *)
				(* We are pre-resolving TargetAnalyteConcentration only to internally pass to ResolveDilutionSharedOptions[...] *)
				preResolvedTargetAnalyteConcentration = Module[
					{
						unresolvedCumulativeDilutionFactor, unresolvedSerialDilutionFactor, unresolvedTransferVolume, unresolvedTotalDilutionVolume, unresolvedFinalVolume,
						unresolvedDiluentVolume, unresolvedConcentratedBufferVolume, unresolvedConcentratedBufferDilutionFactor, unresolvedConcentratedBufferDiluentVolume,
						unresolvedDiscardFinalTransfer, preResolveTargetAnalyteConcentrationQ, endTargetAnalyteConcentration
					},
					(* Pull out these values b/c option resolution needs these information *)
					{
						unresolvedCumulativeDilutionFactor,
						unresolvedSerialDilutionFactor,
						unresolvedTransferVolume,
						unresolvedTotalDilutionVolume,
						unresolvedFinalVolume,
						unresolvedDiluentVolume,
						unresolvedConcentratedBufferVolume,
						unresolvedConcentratedBufferDilutionFactor,
						unresolvedConcentratedBufferDiluentVolume,
						unresolvedDiscardFinalTransfer
					} = Lookup[options,
						{
							CumulativeDilutionFactor,
							SerialDilutionFactor,
							TransferVolume,
							TotalDilutionVolume,
							FinalVolume,
							DiluentVolume,
							ConcentratedBufferVolume,
							ConcentratedBufferDilutionFactor,
							ConcentratedBufferDiluentVolume,
							DiscardFinalTransfer
						}
					];

					(* A boolean to indicate whether we should resolve TargetAnalyteConcentration internally to pass to ResolveDilutionSharedOptions[...] or not *)
					preResolveTargetAnalyteConcentrationQ = Which[
						(* If SampleConcentration is not known in the first place, we do not need to resolve TargetAnalyteConcentration, set to False *)
						MatchQ[sampleConcentrationBeforeDilution, $Failed],
						False,
						(* If we already have enough information from user-specified dilution shared option values to calculate TargetAnalyteConcentration - the final concentration that sample is going to be diluted to BEFORE sample loading , we do not need to resolve TargetAnalyteConcentration, set to False *)
						(* Case 1: CumulativeDilutionFactor or SerialDilutionFactor is specified *)
						MemberQ[{unresolvedCumulativeDilutionFactor, unresolvedSerialDilutionFactor}, ListableP[_?NumericQ]],
						False,
						(* Case 2: At least two of TransferVolume, TotalDilutionVolume, and FinalVolume options are specified for Serial Dilution when we are doing more than 1 dilutions *)
						And[
							Or[
								(* we are doing more than 1 dilution, we can work out all three variables given any two *)
								MatchQ[{resolvedDilutionType, numberOfDilutions}, {Serial, GreaterEqualP[2]}],
								(* we are doing 1 dilution but DiscardFinalTransfer->True, we can work out all three variables given any two *)
								MatchQ[{resolvedDilutionType, numberOfDilutions, unresolvedDiscardFinalTransfer}, {Serial, 1, True}]
							],
							MatchQ[Count[{unresolvedTransferVolume, unresolvedTotalDilutionVolume, unresolvedFinalVolume}, Except[ListableP[Automatic | NullP]]], GreaterEqualP[2]]
						],
						False,
						(* Case 3: TransferVolume must be specified and one of {TotalDilutionVolume,FinalVolume} options are specified for Linear dilution or single-step Serial dilution *)
						And[
							Or[
								(* linear dilution *)
								MatchQ[resolvedDilutionType, Linear],
								(* single step serial dilution with DiscardFinalTransfer->False *)
								MatchQ[{resolvedDilutionType, numberOfDilutions, unresolvedDiscardFinalTransfer}, {Serial, 1, False}]
							],
							(* TransferVolume must be specified *)
							MatchQ[unresolvedTransferVolume, Except[ListableP[Automatic | NullP]]],
							(* Either DilutionVolume or FinalVolume is specified *)
							MatchQ[Count[{unresolvedTotalDilutionVolume, unresolvedFinalVolume}, Except[ListableP[Automatic | NullP]]], GreaterEqualP[1]]
						],
						False,
						(* Case 4: One from TransferVolume, TotalDilutionVolume, and FinalVolume options + DiluentVolume *)
						MatchQ[
							{
								Count[{unresolvedTransferVolume, unresolvedTotalDilutionVolume, unresolvedFinalVolume}, Except[ListableP[Automatic | NullP]]],
								unresolvedDiluentVolume
							},
							{1, ListableP[VolumeP]}
						],
						False,
						(* Case 5: One from TransferVolume, TotalDilutionVolume, and FinalVolume options + two from ConcentratedBufferVolume, ConcentratedBufferDilutionFactor, and ConcentratedBufferDiluentVolume *)
						MatchQ[
							{
								Count[{unresolvedTransferVolume, unresolvedTotalDilutionVolume, unresolvedFinalVolume}, Except[ListableP[Automatic | NullP]]],
								Count[{unresolvedConcentratedBufferVolume, unresolvedConcentratedBufferDilutionFactor, unresolvedConcentratedBufferDiluentVolume}, Except[ListableP[Automatic | NullP]]]
							},
							{1, 2}
						],
						False,
						(* If we are not doing dilution, set to False *)
						!TrueQ[resolvedDilute],
						False,
						(* In all other cases, set to True *)
						True,
						True
					];

					(* This is the final concentration we hope to achieve after sample dilution *)
					endTargetAnalyteConcentration = Module[{unresolvedTargetMeasurementConcentration},
						(* Pull out user-specified TargetMeasurementConcentration *)
						unresolvedTargetMeasurementConcentration = Lookup[options, TargetMeasurementConcentration];
						(* The calculation is based on the following equation: *)
						(* targetAnalyteConc = (targetMeasurementConc / currentMeasurementConc) * sampleConc *)
						Switch[{unresolvedTargetMeasurementConcentration, sampleConcentrationBeforeDilution, calculatedMeasurementConcentrationBeforeDilution},
							(* If user has specified TargetMeasurementConcentration and we have enough information to calculate sample conc and sample loading options *)
							{_?QuantityQ, _?QuantityQ, _?QuantityQ},
							(* Set to the calculated targetAnalyteConc if targetAnalyteConc is smaller or equal to sampleConc b/c this is dilution, you cannot make a sample concentration greater than the original after dilution*)
							If[MatchQ[calculatedMeasurementConcentrationBeforeDilution, GreaterEqualP[unresolvedTargetMeasurementConcentration]],
								(unresolvedTargetMeasurementConcentration / calculatedMeasurementConcentrationBeforeDilution) * sampleConcentrationBeforeDilution,
								Automatic
							],
							(* In all other cases leave it Automatic *)
							{_, _, _},
							Automatic
						]
					];

					(* Begin pre-resolution *)
					Which[
						(* If user has already specified enough information to calculate TargetAnalyteConcentration internally or we don't know sample concentration, don't pre-resolve, leave it Automatic *)
						!preResolveTargetAnalyteConcentrationQ,
						Automatic,
						(* Otherwise if we are doing Linear dilution *)
						MatchQ[resolvedDilutionType, Linear],
						{endTargetAnalyteConcentration},
						(* Otherwise if we are doing Serial dilution we have to supply a list of values for TargetAnalyteConcentration *)
						MatchQ[resolvedDilutionType, Serial],
						(* numberOfDilutions dictates the length of the list of concentrations we are going to make *)
						Which[
							(* If number of dilution is one, only one dilution is needed, set to whatever the endTargetAnalyteConcentration is *)
							MatchQ[numberOfDilutions, 1],
							{endTargetAnalyteConcentration},
							(* Otherwise if we have a value to for TargetAnalyteConcentration to set for, make a list of concentrations starting from sample concentration to endTargetAnalyteConcentration with equal intervals *)
							MatchQ[endTargetAnalyteConcentration, Except[Automatic]],
							Rest[Range[sampleConcentrationBeforeDilution, endTargetAnalyteConcentration, (endTargetAnalyteConcentration - sampleConcentrationBeforeDilution) / numberOfDilutions]],
							(* Otherwise, leave it Automatic *)
							True,
							Automatic
						],
						(* In all other cases, leave it Automatic *)
						True,
						Automatic
					]
				];

				(* Gather results *)
				{
					resolvedDilute,
					resolvedDilutionType,
					preResolvedTargetAnalyteConcentration
				}
			]
		],
		{mapThreadFriendlyOptions, sampleConcentrationsBeforeDilution, calculatedMeasurementConcentrationsBeforeDilution}
	]];

	(* Resolve dilution options using the shared resolver *)
	{resolvedDilutionOptions, resolvedDilutionTests} = Module[{dilutionOptions, mapThreadFriendlyDilutionOptions, dilutionOptionsWithMissings, simulationPlaceHolder, dilutionTests},
		(* Take the dilution options from myOptions to pass to resolveSharedOptions[...] plus the DilutionType and TargetAnalyteConcentration options that we just pre-resolved *)
		dilutionOptions = ReplaceRule[
			Normal[KeyTake[myOptions, Keys[$CoulterCountToDilutionOptionsMap]], Association],
			{
				DilutionType -> resolvedDilutionTypes,
				TargetAnalyteConcentration -> preResolvedTargetAnalyteConcentrations
			}
		];
		(* Turn these dilution options into a mapthread friendly version based on ResolveDilutionSharedOptions[...] *)
		mapThreadFriendlyDilutionOptions = Module[{reversedDilutionToCoulterCountOptionsMap, nestedIndexMatchingOptions, mapThreadFriendlyDilutionOptionsRaw},
			(* Make the reversed option name map from $CoulterCountToDilutionOptionsMap *)
			reversedDilutionToCoulterCountOptionsMap = Reverse /@ $CoulterCountToDilutionOptionsMap;
			(* First we change the option names to the dilution option names using /.$CoulterCountToDilutionOptionsMap so we can call OptionsHandling`Private`mapThreadOptions[...] on it *)
			(* Then we change the option names back to what they are in ExperimentCoulterCount using Map[...] *)
			mapThreadFriendlyDilutionOptionsRaw = Map[
				KeyMap[Replace[#, reversedDilutionToCoulterCountOptionsMap]&],
				OptionsHandling`Private`mapThreadOptions[ResolveDilutionSharedOptions, dilutionOptions /. $CoulterCountToDilutionOptionsMap]
			];
			(* Pull out the options that need to be re-expanded to match inner length for NestedIndexMatching *)
			nestedIndexMatchingOptions = {
				CumulativeDilutionFactor, SerialDilutionFactor, TargetAnalyteConcentration, TransferVolume, TotalDilutionVolume,
				FinalVolume, DiluentVolume, ConcentratedBufferVolume, ConcentratedBufferDilutionFactor, ConcentratedBufferDiluentVolume
			};
			Map[
				Function[{options},
					Module[{actualLengths, lengthsToExpand, newOptionValuesReplacements},
						(* Check what is the actual length for the each option *)
						actualLengths = Length[ToList[#]]& /@ Lookup[options, nestedIndexMatchingOptions];
						(* Take max to be the desired length to expand *)
						lengthsToExpand = Max[actualLengths];
						newOptionValuesReplacements = MapThread[
							Function[{optionName, optionValue},
								Module[{newOptionValue},
									(* Only expand if option value is Automatic or {Automatic} *)
									newOptionValue = If[MatchQ[optionValue, Automatic | {Automatic}],
										ConstantArray[Automatic, lengthsToExpand],
										optionValue
									];
									(* Make the new option->value rule *)
									optionName -> newOptionValue
								]
							],
							{nestedIndexMatchingOptions, Lookup[options, nestedIndexMatchingOptions]}
						];
						(* Append a oldKey-newValue pair to an existing association will replace the value of that oldKey with the newValue *)
						Append[
							options,
							newOptionValuesReplacements
						]
					]
				],
				mapThreadFriendlyDilutionOptionsRaw
			]
		];
		(* Use resolveSharedOptions to call ResolveDilutionSharedOptions[...] to resolve dilution options *)
		(* Warning::MissingTargetAnalyteInitialConcentration is Quieted b/c TargetAnalyteConcentration is not an option we surface to user *)
		(* We only surface the final final TargetMeasurementConcentration option to user and it is okay that TargetMeasurementConcentration is set to Null *)
		{dilutionOptionsWithMissings, simulationPlaceHolder, dilutionTests} = Quiet[
			resolveSharedOptions[
				(* The child resolver we are calling to resolve dilution options *)
				ResolveDilutionSharedOptions,
				(* The message prefix to append to the error msgs that ResolveDilutionSharedOptions[...] spits - we don't have any here *)
				"",
				(* All sample packets *)
				samplePackets,
				(* Dilution master switches *)
				resolvedDilutes,
				(* ExperimentCoulterCount dilution option names -> DilutionSharedOptions option names map *)
				$CoulterCountToDilutionOptionsMap,
				(* The specific dilution options that need to be resolved *)
				dilutionOptions,
				(* No option needs to be set constant across all samples *)
				{},
				(* Mapthread friendly options of all dilution options that need to be resolved *)
				mapThreadFriendlyDilutionOptions,
				gatherTests,
				Cache -> cacheBall,
				Simulation -> simulation
			],
			{Warning::MissingTargetAnalyteInitialConcentration}
		];
		(* If we are providing a set of dilution options that are impossible to resolve, resolveSharedOptions will return Missing[...] as the result so we just replace those with Null so it looks pretty *)
		{
			Replace[dilutionOptionsWithMissings, _Missing -> Null, {3}],
			dilutionTests
		}
	];

	(* Now we have resolved dilution shared options, let's update the sample concentration *)
	{
		sampleConcentrationsAfterDilution,
		sampleVolumesAfterDilution,
		sampleStatesAfterDilution
	} = Transpose[MapThread[
		Function[{samplePacket, sampleConcentrationBeforeDilution, resolvedDilute, resolvedCumulativeDilutionFactor, resolvedFinalVolume},
			If[
				(* If we are diluting, since we have ran the ResolveDilutionSharedOptions[...], we should know the cumulative dilution factor and final volume and everything by now *)
				MatchQ[
					{resolvedDilute, resolvedCumulativeDilutionFactor, resolvedFinalVolume},
					{True, ListableP[_?NumericQ], ListableP[VolumeP]}
				],
				Module[{lastCumulativeDilutionFactor},
					(* Figure out what is the cumulative dilution factor of the last dilution sample since this will be the sample that is going to be mixed with electrolyte solution to achieve TargetMeasurementConcentration *)
					lastCumulativeDilutionFactor = Last[ToList[resolvedCumulativeDilutionFactor], 1];
					{
						(* Concentrations will be diluted by the reciprocal of last cumulative dilution factors *)
						If[MatchQ[sampleConcentrationBeforeDilution, _?QuantityQ], sampleConcentrationBeforeDilution / lastCumulativeDilutionFactor, sampleConcentrationBeforeDilution],
						(* Volume will be updated to be the volume of the last dilution sample *)
						Last[ToList[resolvedFinalVolume], Lookup[samplePacket, Volume]],
						(* State of the sample will be updated to Liquid if sample dilution is performed *)
						Liquid
					}
				],
				(* Otherwise, always keep it the same as the quantities before dilution *)
				{
					sampleConcentrationBeforeDilution,
					If[MatchQ[Lookup[samplePacket, Volume], VolumeP], Lookup[samplePacket, Volume], Infinity * Milliliter],
					Lookup[samplePacket, State]
				}
			]
		],
		{samplePackets, sampleConcentrationsBeforeDilution, resolvedDilutes, Sequence @@ Lookup[resolvedDilutionOptions, {CumulativeDilutionFactor, FinalVolume}]}
	]];

	(* Determine how many potential analytes are there in each sample *)
	(* decide the potential analytes to use; specifying the Analyte here will pre-empt warnings thrown by this function *)
	potentialAnalytesToUse = selectAllAnalytesFromSample[samplePackets, Cache -> cacheBall, AnalyteTypePattern -> $CoulterCountableAnalyteP];

	(* Resolve the rest of the sample loading and measurement options inside MapThread[...] *)
	{
		resolvedTargetMeasurementConcentrations,
		unroundedResolvedSampleAmounts,
		resolvedElectrolytePercentages,
		unroundedResolvedElectrolyteSampleDilutionVolumes,
		resolvedMeasurementContainers,
		resolvedDynamicDilutes,
		resolvedConstantDynamicDilutionFactors,
		resolvedMaxNumberOfDynamicDilutions,
		resolvedCumulativeDynamicDilutionFactors,
		resolvedMixRates,
		resolvedMixTimes,
		resolvedMixDirections,
		resolvedNumberOfReadings,
		resolvedFlowRates,
		resolvedMinParticleSizes,
		resolvedEquilibrationTimes,
		resolvedStopConditions,
		resolvedRunTimes,
		resolvedRunVolumes,
		resolvedTotalCounts,
		resolvedModalCounts,
		resolvedQuantifyConcentrations
	} = Transpose[MapThread[
		Function[{options, samplePacket, potentialAnalytesPerSample, sampleStateAfterDilution, sampleConcentrationAfterDilution, sampleVolumeAfterDilution, sampleParticleType, resolvedDiluent, resolvedConcentratedBuffer, resolvedConcentratedBufferDiluent, resolvedDilutionStrategy},
			Module[
				{
					unresolvedTargetMeasurementConcentration, unresolvedElectrolyteSampleDilutionVolume, unresolvedSampleAmount, unresolvedElectrolytePercentage, unresolvedMeasurementContainer,
					sampleLoadingEquations, scaledTargetMeasurementConcentration, scaledSampleConcentration, scaledSampleAmount, scaledESDVolume, scaledSamplePercentage, solvedVarsWithUserSpecs,
					solvedQ, concentrationUnit, esdRequiredQ, containerMaxVolume, resolvedTargetMeasurementConcentration, resolvedSampleAmount, resolvedElectrolytePercentage, resolvedElectrolyteSampleDilutionVolume,
					resolvedMeasurementContainer, resolvedDynamicDilute, resolvedConstantDynamicDilutionFactor, resolvedMaxNumberOfDynamicDilutions,
					resolvedCumulativeDynamicDilutionFactor, resolvedMixRate, resolvedMixTime, resolvedMixDirection, resolvedNumberOfReadings,
					resolvedFlowRate, resolvedMinParticleSize, resolvedEquilibrationTime,
					resolvedStopCondition, resolvedRunTime, resolvedRunVolume, resolvedTotalCount, resolvedModalCount, resolvedQuantifyConcentration
				},

				(* Pull out the user-supplied value *)
				(* These are the values that are repeatedly used in resolving SampleAmount, ESDVolume, ElectrolytePercentage, and MeasurementContainer options *)
				{
					unresolvedTargetMeasurementConcentration,
					unresolvedSampleAmount,
					unresolvedElectrolyteSampleDilutionVolume,
					unresolvedElectrolytePercentage,
					unresolvedMeasurementContainer
				} = Lookup[options,
					{
						TargetMeasurementConcentration,
						SampleAmount,
						ElectrolyteSampleDilutionVolume,
						ElectrolytePercentage,
						MeasurementContainer
					}
				];

				(* Setting up equals for resolving TargetMeasurementConcentration, SampleAmount, ElectrolyteSampleDilutionVolume, ElectrolytePercentage *)
				(* If sample concentration is available, we should be able to set all variables, otherwise, TargetMeasurementConcentration will be Null *)
				sampleLoadingEquations = If[MatchQ[sampleConcentrationAfterDilution, _?QuantityQ],
					{
						scaledTargetMeasurementConcentration == scaledSampleConcentration * scaledSampleAmount / (scaledSampleAmount + scaledESDVolume),
						scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume)
					},
					{
						scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume)
					}
				];

				(* Initiate the variables by user specified values, also take away the unit *)
				scaledTargetMeasurementConcentration = If[MatchQ[unresolvedTargetMeasurementConcentration, _?QuantityQ],
					(* If user gives us a target concentration, and sample concentration is available, convert to 1 / Milliliter *)
					unitlessCoulterCountConcentration[unresolvedTargetMeasurementConcentration],
					(* Otherwise remain symbol form *)
					scaledTargetMeasurementConcentration
				];
				scaledSampleConcentration = If[MatchQ[sampleConcentrationAfterDilution, _?QuantityQ],
					(* If sample concentration is available, convert to 1/Milliliter *)
					unitlessCoulterCountConcentration[sampleConcentrationAfterDilution],
					scaledSampleConcentration
				];
				scaledSampleAmount = If[MatchQ[unresolvedSampleAmount, VolumeP],
					QuantityMagnitude[unresolvedSampleAmount, Milliliter],
					scaledSampleAmount
				];
				scaledESDVolume = If[MatchQ[unresolvedElectrolyteSampleDilutionVolume, VolumeP],
					QuantityMagnitude[unresolvedElectrolyteSampleDilutionVolume, Milliliter],
					scaledESDVolume
				];
				(* we need to introduce samplePercentage instead of electrolytePercentage to avoid 1/0 math *)
				scaledSamplePercentage = If[MatchQ[unresolvedElectrolytePercentage, Except[Automatic]],
					1 - Convert[unresolvedElectrolytePercentage, 1],
					scaledSamplePercentage
				];

				(* Solve the collective equation *)
				solvedVarsWithUserSpecs = Quiet[First[Solve[sampleLoadingEquations], {}]];
				(* Did we solve everything on the first try? *)
				solvedQ = MatchQ[Values[solvedVarsWithUserSpecs], {__?NumericQ}];

				(* This the concentration we are going to append to the target concentration *)
				concentrationUnit = Which[
					(* keep it the same as whatever the user-specified unit *)
					MatchQ[unresolvedTargetMeasurementConcentration, _?QuantityQ],
					Units[unresolvedTargetMeasurementConcentration],
					(* otherwise set to the unit of the sample concentration's *)
					MatchQ[sampleConcentrationAfterDilution, _?QuantityQ],
					Units[sampleConcentrationAfterDilution],
					(* otherwise set based on sample type, bio sample - EmeraldCell / Milliliter *)
					MemberQ[sampleParticleType, CellTypeP],
					EmeraldCell / Milliliter,
					(* Otherwise use molar *)
					True,
					Molar
				];
				(* In the follow scenarios, we do not need to extra electrolyte solution to do sample loading here since sample is already in a suitable electrolyte solution *)
				esdRequiredQ = !Or[
					(* if we are diluting and using Electrolyte Solution as the diluent, we don't need extra aliquotting *)
					Module[{resolvedDiluentObjects, allDiluentReferences},
						(* Find all the resolved objects/models from Diluent, ConcentratedBuffer, ConcentratedBufferDiluent *)
						resolvedDiluentObjects = Cases[Flatten@{resolvedDiluent, resolvedConcentratedBuffer, resolvedConcentratedBufferDiluent}, ObjectP[]];
						(* Pull out all the object and object's model references for comparison *)
						allDiluentReferences = Cases[
							Join[
								(* Pull out all the object references of all the resolved diluents *)
								Download[resolvedDiluentObjects, Object],
								(* Pull out all the object references of the models of all the resolved diluents *)
								fastAssocLookup[fastCacheBall, #, {Model, Object}]& / resolvedDiluentObjects
							],
							ObjectP[]
						];
						(* Skip the extra aliquotting only if the following conditions are met simultaneously: *)
						And[
							(* --- we can find some resolved diluent objects - probably b/c we are not diluting at all --- *)
							!MatchQ[resolvedDiluentObjects, {}],
							(* --- electrolyte solution is either one of the diluent objects or share models with --- *)
							ContainsAny[
								allDiluentReferences,
								Flatten[{Download[resolvedElectrolyteSolution, Object], fastAssocLookup[fastCacheBall, resolvedElectrolyteSolution, {Model, Object}]}]
							],
							(* --- sample concentration and target measurement concentration is either equal or not available --- *)
							Or[
								EqualQ[sampleConcentrationAfterDilution, resolvedTargetMeasurementConcentration],
								MatchQ[resolvedTargetMeasurementConcentration, Null],
								MatchQ[sampleConcentrationAfterDilution, $Failed]
							],
							(* --- sample volume can at least fill up to 75 percent of the smallest measurement container in the lab --- *)
							MatchQ[sampleVolumeAfterDilution, GreaterEqualP[0.75 * smallestContainerMaxVolume]]
						]
					],
					(* Otherwise if sample is a liquid and already in a solvent that is the same as ElectrolyteSolution, we do not need to do 'dilution', set SampleAmount to the lesser of flat 25 Milliliter and sample volume *)
					And[
						(* --- sample is a liquid --- *)
						MatchQ[sampleStateAfterDilution, Liquid],
						(* --- electrolyte solution is either one of the sample's solvent/media objects or share models with --- *)
						ContainsAny[
							Cases[
								Download[Lookup[samplePacket, {Solvent, Media}, Nothing], Object],
								ObjectP[]
							],
							Flatten[{Download[resolvedElectrolyteSolution, Object], fastAssocLookup[fastCacheBall, resolvedElectrolyteSolution, {Model, Object}]}]
						],
						(* --- sample volume can at least fill up to 75 percent of the smallest measurement container in the lab --- *)
						MatchQ[sampleVolumeAfterDilution, GreaterEqualP[0.75 * smallestContainerMaxVolume]]
					],
					(* Otherwise if sample concentration is just smaller than the user specified target concentration, we cant do any dilution to reach that *)
					MatchQ[sampleConcentrationAfterDilution, LessP[unresolvedTargetMeasurementConcentration]]
				];
				(* get the max volume that container can take *)
				containerMaxVolume = Which[
					MatchQ[unresolvedMeasurementContainer, ObjectP[Object[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, unresolvedMeasurementContainer, {Model, MaxVolume}],
					MatchQ[unresolvedMeasurementContainer, ObjectP[Model[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, unresolvedMeasurementContainer, MaxVolume],
					True,
					largestContainerMaxVolume
				];

				Which[
					(* If every variable gets solved, easy to set up the sample loading options *)
					TrueQ[solvedQ],
					Module[{},
						(* set to the user specified value, otherwise the solved value *)
						resolvedTargetMeasurementConcentration = Which[
							MatchQ[unresolvedTargetMeasurementConcentration, Except[Automatic]], unresolvedTargetMeasurementConcentration,
							(* if we are calculating target concentration, use solved value *)
							MatchQ[sampleConcentrationAfterDilution, _?QuantityQ], appendCoulterCountConcentrationUnit[(scaledTargetMeasurementConcentration /. solvedVarsWithUserSpecs), concentrationUnit],
							(* otherwise default to Null *)
							True, Null
						];
						resolvedSampleAmount = Which[
							MatchQ[unresolvedSampleAmount, Except[Automatic]], unresolvedSampleAmount,
							MatchQ[(scaledSampleAmount /. solvedVarsWithUserSpecs), _?NumericQ], Max[(scaledSampleAmount /. solvedVarsWithUserSpecs) * Milliliter, 0 * Milliliter],
							(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
							True, Min[25 * Milliliter, sampleVolumeAfterDilution]
						];
						resolvedElectrolyteSampleDilutionVolume = Which[
							MatchQ[unresolvedElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedElectrolyteSampleDilutionVolume,
							MatchQ[(scaledESDVolume /. solvedVarsWithUserSpecs), _?NumericQ], Max[(scaledESDVolume /. solvedVarsWithUserSpecs) * Milliliter, 0 * Milliliter],
							(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
							True, 0 * Milliliter
						];
						resolvedElectrolytePercentage = If[MatchQ[unresolvedElectrolytePercentage, Except[Automatic]], unresolvedElectrolytePercentage, Convert[1 - (scaledSamplePercentage /. solvedVarsWithUserSpecs), Percent]]
					],
					(* Further resolve with second solve and defaults *)
					!MatchQ[solvedVarsWithUserSpecs, {}],
					Module[{unsolvedVars, secondSampleLoadingEquations, solvedVarsWithDefaults, secondSolvedQ},
						(* Extract the vars that still need to solve *)
						unsolvedVars = DeleteDuplicates@Cases[Values[solvedVarsWithUserSpecs], _Symbol, Infinity];

						(* resolve options or set based on different scenarios *)
						Switch[Length[unsolvedVars],
							(* user did not provide anything *)
							2,
							Module[{},
								(* set the sample amount to make sure we will not be requiring more sample than the input sample amount  *)
								scaledSampleAmount = If[TrueQ[esdRequiredQ], Min[0.1, QuantityMagnitude[sampleVolumeAfterDilution, Milliliter]], Min[25, QuantityMagnitude[sampleVolumeAfterDilution, Milliliter]]];
								(* set the esd volume to make sure we do not over fill the specified or largest measurement container in lab and diluting 1000x *)
								scaledESDVolume = If[TrueQ[esdRequiredQ], Max[Min[scaledSampleAmount * 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledSampleAmount], 0], 0];
								secondSampleLoadingEquations = sampleLoadingEquations;
							],
							(* user specified at least one variable *)
							1,
							Module[{userSpecifiedOptions},
								(* figure out which variable user specified *)
								userSpecifiedOptions = PickList[
									{SampleAmount, ElectrolyteSampleDilutionVolume, ElectrolytePercentage, TargetMeasurementConcentration},
									{unresolvedSampleAmount, unresolvedElectrolyteSampleDilutionVolume, unresolvedElectrolytePercentage, unresolvedTargetMeasurementConcentration},
									Except[Automatic]
								];

								Switch[First[userSpecifiedOptions],
									(* user specified sample amount *)
									SampleAmount,
									Module[{},
										(* set esd volume such that we are diluting 1000x and not overflow the specified or largest measurement container we have in lab *)
										scaledESDVolume = Max[Min[scaledSampleAmount * 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledSampleAmount], 0];
										secondSampleLoadingEquations = sampleLoadingEquations;
									],
									ElectrolyteSampleDilutionVolume,
									Module[{},
										(* set sample amount such that we are diluting 1000x and not overflow the specified or largest measurement container we have in lab *)
										scaledSampleAmount = Max[Min[scaledESDVolume / 999, QuantityMagnitude[containerMaxVolume, Milliliter] - scaledESDVolume, QuantityMagnitude[sampleVolumeAfterDilution, Milliliter]]];
										secondSampleLoadingEquations = sampleLoadingEquations;
									],
									ElectrolytePercentage | TargetMeasurementConcentration,
									Module[{},
										(* append an extra condition to the equation that we are always making 100mL in total if we need extra aliquotting, and 25 mL if we are not requiring extra aliquotting *)
										secondSampleLoadingEquations = If[
											Or[
												MatchQ[unresolvedElectrolytePercentage, EqualP[0]],
												MatchQ[unresolvedTargetMeasurementConcentration, GreaterP[sampleConcentrationAfterDilution]]
											],
											{
												scaledSamplePercentage == scaledSampleAmount / (scaledSampleAmount + scaledESDVolume),
												scaledSamplePercentage == 1,
												scaledSampleAmount + scaledESDVolume == Min[25, QuantityMagnitude[sampleVolumeAfterDilution, Milliliter]]
											},
											Join[sampleLoadingEquations, {scaledSampleAmount + scaledESDVolume == 100}]
										];
									]
								]
							]
						];

						(* Solve again! *)
						solvedVarsWithDefaults = Quiet[First[Solve[secondSampleLoadingEquations], {}]];
						(* Did we solve everything on the second try? - this is the final solve *)
						secondSolvedQ = MatchQ[Values[solvedVarsWithDefaults], {__?NumericQ}];

						If[TrueQ[secondSolvedQ],
							(* We really should be here if we ever made this far *)
							Module[{},
								(* set to the user specified value, otherwise the solved value *)
								resolvedTargetMeasurementConcentration = Which[
									MatchQ[unresolvedTargetMeasurementConcentration, Except[Automatic]], unresolvedTargetMeasurementConcentration,
									(* if we are calculating target concentration, use solved value *)
									MatchQ[sampleConcentrationAfterDilution, _?QuantityQ], appendCoulterCountConcentrationUnit[(scaledTargetMeasurementConcentration /. solvedVarsWithDefaults), concentrationUnit],
									(* otherwise default to Null *)
									True, Null
								];
								resolvedSampleAmount = Which[
									MatchQ[unresolvedSampleAmount, Except[Automatic]], unresolvedSampleAmount,
									MatchQ[(scaledSampleAmount /. solvedVarsWithDefaults), _?NumericQ], Max[(scaledSampleAmount /. solvedVarsWithDefaults) * Milliliter, 0 * Milliliter],
									(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
									True, Min[25 * Milliliter, sampleVolumeAfterDilution]
								];
								resolvedElectrolyteSampleDilutionVolume = Which[
									MatchQ[unresolvedElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedElectrolyteSampleDilutionVolume,
									MatchQ[(scaledESDVolume /. solvedVarsWithDefaults), _?NumericQ], Max[(scaledESDVolume /. solvedVarsWithDefaults) * Milliliter, 0 * Milliliter],
									(* edge case that when electrolyte percentage is set to 0, we are still gonna end up here with no solved value for SampleAmount and ESDVolume, so we have to make some defaults here *)
									True, 0 * Milliliter
								];
								resolvedElectrolytePercentage = If[MatchQ[unresolvedElectrolytePercentage, Except[Automatic]], unresolvedElectrolytePercentage, Convert[1 - (scaledSamplePercentage /. solvedVarsWithDefaults), Percent]]
							],
							(* otherwise, the math must have been impossible due to user specified values *)
							True,
							Module[{},
								(* set to the user specified value, otherwise the solved value *)
								resolvedTargetMeasurementConcentration = If[MatchQ[unresolvedTargetMeasurementConcentration, Except[Automatic]], unresolvedTargetMeasurementConcentration, Null];
								resolvedSampleAmount = If[MatchQ[unresolvedSampleAmount, Except[Automatic]], unresolvedSampleAmount, 0.1 * Microliter];
								resolvedElectrolyteSampleDilutionVolume = If[MatchQ[unresolvedElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedElectrolyteSampleDilutionVolume, 99.9 * Milliliter];
								resolvedElectrolytePercentage = If[MatchQ[unresolvedElectrolytePercentage, Except[Automatic]], unresolvedElectrolytePercentage, 99.9 * Percent]
							]
						]
					],
					(* if we end up here, the math must have been impossible due to user specified values *)
					True,
					Module[{},
						(* set to the user specified value, otherwise the solved value *)
						resolvedTargetMeasurementConcentration = If[MatchQ[unresolvedTargetMeasurementConcentration, Except[Automatic]], unresolvedTargetMeasurementConcentration, Null];
						resolvedSampleAmount = If[MatchQ[unresolvedSampleAmount, Except[Automatic]], unresolvedSampleAmount, 0.1 * Microliter];
						resolvedElectrolyteSampleDilutionVolume = If[MatchQ[unresolvedElectrolyteSampleDilutionVolume, Except[Automatic]], unresolvedElectrolyteSampleDilutionVolume, 99.9 * Milliliter];
						resolvedElectrolytePercentage = If[MatchQ[unresolvedElectrolytePercentage, Except[Automatic]], unresolvedElectrolytePercentage, 99.9 * Percent]
					]
				];

				(* Resolve MeasurementContainer *)
				resolvedMeasurementContainer = Module[{totalVolume},
					(* This is the total volume tht needs to be accommodated by the given container *)
					totalVolume = resolvedSampleAmount + resolvedElectrolyteSampleDilutionVolume;
					Which[
						(* If it is set it is set *)
						MatchQ[unresolvedMeasurementContainer, Except[Automatic]],
						unresolvedMeasurementContainer,
						(* Otherwise based on the volumes we have resolved *)
						MatchQ[totalVolume, LessEqualP[largestContainerMaxVolume]],
						(* If we have a coulter counter container that can hold the total volume and not overflowing, set to that container model *)
						(* Overflow threshold is 100 Percent for now b/c these beakers are designed to hold volume at its max volume *)
						First[PickList[Lookup[sortedCoulterCounterContainerModelPackets, Object], Lookup[sortedCoulterCounterContainerModelPackets, MaxVolume], GreaterEqualP[totalVolume]]],
						(* Otherwise, set to the largest coulter counter container and throw error later *)
						(* In all other cases, set to the largest container model we have in lab *)
						True,
						Last[Lookup[sortedCoulterCounterContainerModelPackets, Object]]
					]
				];

				resolvedQuantifyConcentration = Which[
					(* If it is set it is set *)
					MatchQ[Lookup[options, QuantifyConcentration], Except[Automatic]],
					Lookup[options, QuantifyConcentration],
					(* Otherwise if there is only one analyte that is of cell type, set to True *)
					Length[potentialAnalytesPerSample] == 1 && MatchQ[First[potentialAnalytesPerSample], $CoulterCountableAnalyteP],
					True,
					(* Otherwise set to False *)
					True,
					False
				];

				(* Use helper function to resolve the rest of the loading and measurement options for input sample inside MapThread[...]*)
				{
					resolvedDynamicDilute,
					resolvedConstantDynamicDilutionFactor,
					resolvedMaxNumberOfDynamicDilutions,
					resolvedCumulativeDynamicDilutionFactor,
					resolvedMixRate,
					resolvedMixTime,
					resolvedMixDirection,
					resolvedNumberOfReadings,
					resolvedFlowRate,
					resolvedMinParticleSize,
					resolvedEquilibrationTime,
					resolvedStopCondition,
					resolvedRunTime,
					resolvedRunVolume,
					resolvedTotalCount,
					resolvedModalCount
				} = Module[{measurementContainerFootprint},
					(* get the footprint of resolve the measurement container *)
					measurementContainerFootprint = If[MatchQ[resolvedMeasurementContainer, ObjectP[Object[Container, Vessel]]],
						fastAssocLookup[fastCacheBall, resolvedMeasurementContainer, {Model, Footprint}],
						fastAssocLookup[fastCacheBall, resolvedMeasurementContainer, Footprint]
					];
					resolveCoulterCountMeasurementOptions[
						options,
						ApertureDiameter -> resolvedApertureDiameter,
						DilutionStrategy -> resolvedDilutionStrategy,
						QuantityFunction -> pressureToFlowRateFun,
						MeasurementContainerFootprint -> measurementContainerFootprint
					]
				];

				(* Gather MapThread results *)
				{
					resolvedTargetMeasurementConcentration,
					resolvedSampleAmount,
					resolvedElectrolytePercentage,
					resolvedElectrolyteSampleDilutionVolume,
					resolvedMeasurementContainer,
					resolvedDynamicDilute,
					resolvedConstantDynamicDilutionFactor,
					resolvedMaxNumberOfDynamicDilutions,
					resolvedCumulativeDynamicDilutionFactor,
					resolvedMixRate,
					resolvedMixTime,
					resolvedMixDirection,
					resolvedNumberOfReadings,
					resolvedFlowRate,
					resolvedMinParticleSize,
					resolvedEquilibrationTime,
					resolvedStopCondition,
					resolvedRunTime,
					resolvedRunVolume,
					resolvedTotalCount,
					resolvedModalCount,
					resolvedQuantifyConcentration
				}
			]
		],
		{mapThreadFriendlyOptions, samplePackets, potentialAnalytesToUse, sampleStatesAfterDilution, sampleConcentrationsAfterDilution, sampleVolumesAfterDilution, sampleParticleTypes, Sequence @@ Lookup[resolvedDilutionOptions, {Diluent, ConcentratedBuffer, ConcentratedBufferDiluent, DilutionStrategy}]}
	]];

	(* Need to manually round some resolved option values here *)
	{
		resolvedSuitabilitySampleAmounts,
		resolvedSuitabilityElectrolyteSampleDilutionVolumes,
		resolvedElectrolyteSampleDilutionVolumes,
		resolvedSampleAmounts
	} = {
		SafeRound[unroundedResolvedSuitabilitySampleAmounts, 10^-1 * Microliter],
		SafeRound[unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes, 10^-1 * Microliter],
		SafeRound[unroundedResolvedElectrolyteSampleDilutionVolumes, 10^-1 * Microliter],
		Map[
			Which[
				MatchQ[#, MassP],
				SafeRound[#, 10^-1 * Milligram],
				MatchQ[#, VolumeP],
				SafeRound[#, 10^-1 * Microliter]
			]&,
			unroundedResolvedSampleAmounts
		]
	};

	(* resolve the rest of the easy options *)

	(* Resolve FlushFlowRate *)
	resolvedFlushFlowRate = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, FlushFlowRate], Except[Automatic]],
		Lookup[allOptionsRounded, FlushFlowRate],
		(* If ApertureDiameter is greater than 560 Micrometer, set to a flow rate that maintains the internal pressure during pumping to be 3 Torr*)
		MatchQ[resolvedApertureDiameter, GreaterP[560 Micrometer]],
		pressureToFlowRateFun[3 * Torr],
		(* Otherwise, set to a value that maintains the internal pressure to be 6 Torr during pumping *)
		True,
		pressureToFlowRateFun[6 * Torr]
	];

	(* Resolve ElectrolyteSolutionVolume *)
	(* Need to extract NumberOfReplicates and NumberOfSuitabilityReplicates to figure out how many times we are repeating our experiments *)
	resolvedNumberOfReplicates = Lookup[allOptionsRounded, NumberOfReplicates];
	resolvedNumberOfSuitabilityReplicates = Lookup[allOptionsRounded, NumberOfSuitabilityReplicates];
	(* Figure out how many flushes are needed for the entire experiment, since ElectrolyteSolutionVolume supplies the clean electrolyte solution that is used to flush the system *)
	totalFlushVolumeRequired = Module[{numberOfTotalFlushes},
		(* One flush before and after switching samples, and in between readings *)
		(* Flushing -> Load sample 1 -> Flushing -> Reading 1 -> Flushing -> Reading 2 -> Flushing -> Switch to sample 2 -> Flushing -> Reading 1 -> Flushing -> ... *)
		(* DilutionStrategy->Series indicates that we are using all dilution samples as extra measurement samples, so numberOfTotalFlushes goes up, If[MatchQ[dilutionStrategy,Series],numberOfDilutions-1,0] takes care of this *)
		numberOfTotalFlushes = Total[
			MapThread[
				Function[{numberOfReadings, numberOfReplicates, dilutionStrategy, numberOfDilutions, measurementQ},
					If[TrueQ[measurementQ],
						(If[NullQ[numberOfReadings], 1, numberOfReadings] + 1) * (
							If[!NullQ[numberOfReplicates], numberOfReplicates, 1] + 1 + If[MatchQ[dilutionStrategy, Series], numberOfDilutions - 1, 0]
						),
						0
					]
				],
				{
					Join[resolvedNumberOfReadings, resolvedNumberOfSuitabilityReadings],
					Join[ConstantArray[resolvedNumberOfReplicates, Length[mySamples]], ConstantArray[resolvedNumberOfSuitabilityReplicates, Length[ToList[resolvedSuitabilitySizeStandards]]]],
					Join[Lookup[resolvedDilutionOptions, DilutionStrategy], ConstantArray[Null, Length[ToList[resolvedSuitabilitySizeStandards]]]],
					Join[Lookup[resolvedDilutionOptions, NumberOfDilutions], ConstantArray[Null, Length[ToList[resolvedSuitabilitySizeStandards]]]],
					Join[ConstantArray[True, Length[mySamples]], ConstantArray[resolvedSystemSuitabilityCheck, Length[ToList[resolvedSuitabilitySizeStandards]]]]
				}
			]
		] + 1;
		(* The amount that needs to be added to the electrolyte container is the number of total flushes times the volume consumed for each flushing plus a dead volume of 50 Milliliter *)
		(* or 80% of the max volume (2 Liter) of electrolyte container *)
		(* We are adding 2 Liter as a buffer in case the electrolyte solution runs out *)
		UnitScale[SafeRound[resolvedFlushFlowRate * Lookup[allOptionsRounded, FlushTime] * numberOfTotalFlushes + 2 * Liter, 10^-1 * Microliter]]
	];

	resolvedElectrolyteSolutionVolume = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, ElectrolyteSolutionVolume], Except[Automatic]],
		Lookup[allOptionsRounded, ElectrolyteSolutionVolume],
		(* Otherwise automatically set to the sum of the flush volumes *)
		True,
		totalFlushVolumeRequired
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[allOptionsRounded];

	(* Resolve the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	resolvedEmail = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[allOptionsRounded, Email], Except[Automatic]],
		Lookup[allOptionsRounded, Email],
		(* If it is a subprotocol, don't send email *)
		MatchQ[Lookup[myOptions, ParentProtocol], ObjectP[ProtocolTypes[]]],
		False,
		(* If it is a parent protocol, then yes *)
		NullQ[Lookup[myOptions, ParentProtocol]],
		True,
		(* Default to True *)
		True,
		True
	];

	(* Gather all resolved options *)
	resolvedOptions = ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedPostProcessingOptions,
			{
				SampleLabel -> resolvedSampleLabels,
				SampleContainerLabel -> resolvedSampleContainerLabels,
				Instrument -> instrument,
				ApertureDiameter -> resolvedApertureDiameter,
				ApertureTube -> resolvedApertureTube,
				ElectrolyteSolution -> resolvedElectrolyteSolution,
				SystemSuitabilityCheck -> resolvedSystemSuitabilityCheck,
				SystemSuitabilityTolerance -> resolvedSystemSuitabilityTolerance,
				SuitabilitySizeStandard -> resolvedSuitabilitySizeStandards,
				AbortOnSystemSuitabilityCheck -> resolvedAbortOnSystemSuitabilityCheck,
				SuitabilityParticleSize -> resolvedSuitabilityParticleSizes,
				SuitabilityTargetConcentration -> resolvedSuitabilityTargetConcentrations,
				SuitabilitySampleAmount -> resolvedSuitabilitySampleAmounts,
				SuitabilityElectrolyteSampleDilutionVolume -> resolvedSuitabilityElectrolyteSampleDilutionVolumes,
				SuitabilityElectrolytePercentage -> resolvedSuitabilityElectrolytePercentages,
				SuitabilityMeasurementContainer -> resolvedSuitabilityMeasurementContainers,
				SuitabilityDynamicDilute -> resolvedSuitabilityDynamicDilutes,
				SuitabilityConstantDynamicDilutionFactor -> resolvedSuitabilityConstantDynamicDilutionFactors,
				SuitabilityMaxNumberOfDynamicDilutions -> resolvedSuitabilityMaxNumberOfDynamicDilutions,
				SuitabilityCumulativeDynamicDilutionFactor -> resolvedSuitabilityCumulativeDynamicDilutionFactors,
				SuitabilityMixRate -> resolvedSuitabilityMixRates,
				SuitabilityMixTime -> resolvedSuitabilityMixTimes,
				SuitabilityMixDirection -> resolvedSuitabilityMixDirections,
				NumberOfSuitabilityReadings -> resolvedNumberOfSuitabilityReadings,
				SuitabilityApertureCurrent -> resolvedSuitabilityApertureCurrents,
				SuitabilityGain -> resolvedSuitabilityGains,
				SuitabilityFlowRate -> resolvedSuitabilityFlowRates,
				MinSuitabilityParticleSize -> resolvedMinSuitabilityParticleSizes,
				SuitabilityEquilibrationTime -> resolvedSuitabilityEquilibrationTimes,
				SuitabilityStopCondition -> resolvedSuitabilityStopConditions,
				SuitabilityRunTime -> resolvedSuitabilityRunTimes,
				SuitabilityRunVolume -> resolvedSuitabilityRunVolumes,
				SuitabilityTotalCount -> resolvedSuitabilityTotalCounts,
				SuitabilityModalCount -> resolvedSuitabilityModalCounts,
				Dilute -> resolvedDilutes,
				DilutionType -> resolvedDilutionTypes,
				TargetMeasurementConcentration -> resolvedTargetMeasurementConcentrations,
				SampleAmount -> resolvedSampleAmounts,
				ElectrolytePercentage -> resolvedElectrolytePercentages,
				ElectrolyteSampleDilutionVolume -> resolvedElectrolyteSampleDilutionVolumes,
				MeasurementContainer -> resolvedMeasurementContainers,
				DynamicDilute -> resolvedDynamicDilutes,
				ConstantDynamicDilutionFactor -> resolvedConstantDynamicDilutionFactors,
				MaxNumberOfDynamicDilutions -> resolvedMaxNumberOfDynamicDilutions,
				CumulativeDynamicDilutionFactor -> resolvedCumulativeDynamicDilutionFactors,
				MixRate -> resolvedMixRates,
				MixTime -> resolvedMixTimes,
				MixDirection -> resolvedMixDirections,
				NumberOfReadings -> resolvedNumberOfReadings,
				FlowRate -> resolvedFlowRates,
				MinParticleSize -> resolvedMinParticleSizes,
				EquilibrationTime -> resolvedEquilibrationTimes,
				StopCondition -> resolvedStopConditions,
				RunTime -> resolvedRunTimes,
				RunVolume -> resolvedRunVolumes,
				TotalCount -> resolvedTotalCounts,
				ModalCount -> resolvedModalCounts,
				FlushFlowRate -> resolvedFlushFlowRate,
				ElectrolyteSolutionVolume -> resolvedElectrolyteSolutionVolume,
				QuantifyConcentration -> resolvedQuantifyConcentrations,
				Email -> resolvedEmail
			},
			resolvedDilutionOptions
		],
		Append -> False
	];

	(*-- CONFLICTING OPTIONS CHECKS AND ALL ERROR CHECKS --*)

	(* --- ApertureDiameter matches the ApertureDiameter field value of ApertureTube. If not, throw an ERROR. --- *)
	apertureTubeDiameterMismatchError = Module[{apertureTubeModel},
		(* Get the model of the resolved aperture tube *)
		apertureTubeModel = If[MatchQ[resolvedApertureTube, ObjectP[Object[Part, ApertureTube]]], fastAssocLookup[fastCacheBall, resolvedApertureTube, Model], resolvedApertureTube];
		(* Check if the ApertureDiameter of the ApertureTube model matches our resolved ApertureDiameter option *)
		!MatchQ[fastAssocLookup[fastCacheBall, apertureTubeModel, ApertureDiameter], EqualP[resolvedApertureDiameter]]
	];

	(* Set invalid options *)
	apertureTubeDiameterMismatchInvalidOptions = If[apertureTubeDiameterMismatchError, {ApertureDiameter, ApertureTube}, Nothing];

	(* Throw messages *)
	If[apertureTubeDiameterMismatchError && messages,
		Message[
			Error::ApertureTubeDiameterMismatch,
			resolvedApertureDiameter,
			If[MatchQ[resolvedApertureTube, ObjectP[Object[Part, ApertureTube]]],
				fastAssocLookup[fastCacheBall, resolvedApertureTube, {Model, ApertureDiameter}],
				fastAssocLookup[fastCacheBall, resolvedApertureTube, ApertureDiameter]
			],
			ObjectToString[resolvedApertureTube, Cache -> cacheBall]
		]
	];

	(* Make tests *)
	apertureTubeDiameterMismatchTest = If[gatherTests,
		Test["ApertureDiameter matches the ApertureDiameter field value of ApertureTube:",
			apertureTubeDiameterMismatchError,
			False
		],
		Nothing
	];

	(* --- Max diameters of any particles (if known) in the input sample are within 2-80% of the ApertureDiameter. If not, throw an ERROR. --- *)
	oversizedInvalidInputs = PickList[mySamples, sampleMaxParticleDiameters, GreaterP[0.8 * resolvedApertureDiameter]];
	undersizedInvalidInputs = PickList[mySamples, sampleMaxParticleDiameters, LessP[0.02 * resolvedApertureDiameter]];
	particleSizeOutOfRangeInvalidInputs = Join[oversizedInvalidInputs, undersizedInvalidInputs];

	(* Set invalid options *)
	particleSizeOutOfRangeInvalidOptions = If[Length[particleSizeOutOfRangeInvalidInputs] > 0, {ApertureDiameter, ApertureTube}, Nothing];

	(* Throw messages *)
	If[Length[particleSizeOutOfRangeInvalidInputs] > 0 && messages,
		Message[
			Error::ParticleSizeOutOfRange,
			resolvedApertureDiameter,
			ObjectToString[particleSizeOutOfRangeInvalidInputs, Cache -> cacheBall],
			ObjectToString[oversizedInvalidInputs, Cache -> cacheBall],
			ObjectToString[undersizedInvalidInputs, Cache -> cacheBall],
			"input"
		]
	];

	(* Make tests *)
	particleSizeOutOfRangeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[particleSizeOutOfRangeInvalidInputs] == 0,
				Nothing,
				Test["Input samples "<>ObjectToString[particleSizeOutOfRangeInvalidInputs, Cache -> cacheBall]<>" do not contain particles with sizes beyond 2-80% of the ApertureDiameter:", True, False]
			];
			passingTest = If[Length[particleSizeOutOfRangeInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Input samples "<>ObjectToString[Complement[mySamples, particleSizeOutOfRangeInvalidInputs], Cache -> cacheBall]<>" do not contain particles with sizes beyond 2-80% of the ApertureDiameter:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- SuitabilityParticleSize are within 2-80% of the ApertureDiameters --- *)
	oversizedSuitabilitySizeStandards = PickList[ToList[resolvedSuitabilitySizeStandards], ToList[resolvedSuitabilityParticleSizes], GreaterP[0.8 * resolvedApertureDiameter]];
	undersizedSuitabilitySizeStandards = PickList[ToList[resolvedSuitabilitySizeStandards], ToList[resolvedSuitabilityParticleSizes], LessP[0.02 * resolvedApertureDiameter]];
	outOfRangeSuitabilitySizeStandards = Join[oversizedSuitabilitySizeStandards, undersizedSuitabilitySizeStandards];

	(* Set invalid options *)
	suitabilityParticleSizeOutOfRangeInvalidOptions = If[Length[outOfRangeSuitabilitySizeStandards] > 0, {SuitabilitySizeStandard, SuitabilityParticleSize}, Nothing];

	(* Throw messages *)
	If[Length[outOfRangeSuitabilitySizeStandards] > 0 && messages,
		Message[
			Error::ParticleSizeOutOfRange,
			resolvedApertureDiameter,
			ObjectToString[outOfRangeSuitabilitySizeStandards, Cache -> cacheBall],
			ObjectToString[oversizedSuitabilitySizeStandards, Cache -> cacheBall],
			ObjectToString[undersizedSuitabilitySizeStandards, Cache -> cacheBall],
			"option SuitabilitySizeStandard"
		]
	];

	(* Make tests *)
	suitabilityParticleSizeOutOfRangeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[outOfRangeSuitabilitySizeStandards] == 0,
				Nothing,
				Test["SuitabilitySizeStandard sample "<>ObjectToString[outOfRangeSuitabilitySizeStandards, Cache -> cacheBall]<>" do not contain particles with sizes beyond 2-80% of the ApertureDiameter:", True, False]
			];
			passingTest = If[Length[outOfRangeSuitabilitySizeStandards] == Length[ToList[resolvedSuitabilitySizeStandards]],
				Nothing,
				Test["SuitabilitySizeStandard sample "<>ObjectToString[Complement[ToList[resolvedSuitabilitySizeStandards], outOfRangeSuitabilitySizeStandards], Cache -> cacheBall]<>" do not contain particles with sizes beyond 2-80% of the ApertureDiameter:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- All samples should have phase the same as ElectrolyteSolution, otherwise particles in that sample have a risk of dissolving --- *)
	(* Predict the phase of the ElectrolyteSolution in use *)
	electrolyteSolutionPhase = PredictSamplePhase[resolvedElectrolyteSolution, Cache -> cacheBall];
	solubleSamples = Switch[electrolyteSolutionPhase,
		(* If the electrolyte solution is organic phase, find if we have any sample that is in aqueous phase *)
		Organic,
		PickList[Join[mySamples, Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]]], Join[predictedSamplePhases, PredictSamplePhase[Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]], Cache -> cacheBall]], Aqueous],
		(* If the electrolyte solution is aqueous phase, find if we have any sample that is in organic phase *)
		Aqueous,
		PickList[Join[mySamples, Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]]], Join[predictedSamplePhases, PredictSamplePhase[Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]], Cache -> cacheBall]], Organic],
		(* If we cannot predict the phase of electrolyte solution or it is something in between aqueous and organic, don't surface this warning at all *)
		_,
		{}
	];

	(* Throw messages *)
	If[Length[solubleSamples] > 0 && warnings,
		Message[
			Warning::SolubleSamples,
			ObjectToString[solubleSamples, Cache -> cacheBall],
			ObjectToString[resolvedElectrolyteSolution, Cache -> cacheBall],
			First[Complement[{Organic, Aqueous}, {electrolyteSolutionPhase}]],
			electrolyteSolutionPhase
		]
	];

	(* Make test *)
	solubleSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[solubleSamples] == 0,
				Nothing,
				Warning["Sample(s) "<>ObjectToString[outOfRangeSuitabilitySizeStandards, Cache -> cacheBall]<>" are not potentially soluble in the ElectrolyteSolution:", True, False]
			];
			passingTest = If[Length[solubleSamples] == Length[Join[mySamples, Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]]]],
				Nothing,
				Warning["Sample(s) "<>ObjectToString[Complement[Join[mySamples, Cases[ToList[resolvedSuitabilitySizeStandards], ObjectP[]]], solubleSamples], Cache -> cacheBall]<>" are not potentially soluble in the ElectrolyteSolution:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Suitability conflicting options. If not, throw an ERROR. --- *)
	(* Set invalid options *)
	conflictingSuitabilityCheckInvalidOptions = If[TrueQ[resolvedSystemSuitabilityCheck],
		(* If we are doing suitability check, all options should not contain Nulls in their values *)
		PickList[Complement[$SuitabilityOptions, $SuitabilityAllowNullOptions], Lookup[resolvedOptions, Complement[$SuitabilityOptions, $SuitabilityAllowNullOptions]], _?(MemberQ[ToList[#], NullP]&)],
		(* If we are not doing suitability check, all options listed should be Null or list of Nulls *)
		PickList[$SuitabilityOptions, Lookup[resolvedOptions, $SuitabilityOptions], Except[NullP]]
	];

	(* Throw messages *)
	If[Length[conflictingSuitabilityCheckInvalidOptions] > 0 && messages,
		Message[
			Error::ConflictingSuitabilityCheckOptions,
			resolvedSystemSuitabilityCheck,
			conflictingSuitabilityCheckInvalidOptions,
			Prepend[conflictingSuitabilityCheckInvalidOptions, SystemSuitabilityCheck]
		]
	];

	(* Make tests *)
	conflictingSuitabilityCheckTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[conflictingSuitabilityCheckInvalidOptions] == 0,
				Nothing,
				Test["The value of option(s) "<>ToString[conflictingSuitabilityCheckInvalidOptions]<>" is not set to Null when SystemSuitabilityCheck is set to True, and vice versa:", True, False]
			];
			passingTest = If[Length[conflictingSuitabilityCheckInvalidOptions] == Length[Complement[$SuitabilityOptions, $SuitabilityAllowNullOptions]],
				Nothing,
				Test["The value of option(s) "<>ToString[Complement[$SuitabilityOptions, conflictingSuitabilityCheckInvalidOptions]]<>" is not set to Null when SystemSuitabilityCheck is set to True, and vice versa:", True, True]
			];
			{failingTest, passingTest}
		],
		{}
	];

	(* --- SystemSuitabilityTolerance is below 10 Percent to be considered decent. If not, throw a WARNING. --- *)
	If[!MatchQ[resolvedSystemSuitabilityTolerance, LessEqualP[10 Percent] | Null] && warnings,
		Message[Warning::SystemSuitabilityToleranceTooHigh, resolvedSystemSuitabilityTolerance]
	];

	(* Make tests *)
	suitabilityToleranceTooHighTest = If[gatherTests,
		Warning[
			"SystemSuitabilityTolerance is less than or equal to 10 Percent to ensure a reliable system suitability check:",
			resolvedSystemSuitabilityTolerance,
			LessEqualP[10 Percent] | NullP
		],
		Nothing
	];

	(* --- SuitabilityParticleSize matches SuitabilitySizeStandard samples --- *)
	suitabilitySizeStandardMismatchErrors = MapThread[
		Function[{sizeStandard, sizeStandardParticleSize},
			Module[{resolvedParticleDiameter, sizeStandardParticleDiameter, sizeStandardModelParticleDiameter},
				(* Convert all particle sizes to a unified unit *)
				{resolvedParticleDiameter, sizeStandardParticleDiameter, sizeStandardModelParticleDiameter} = If[MatchQ[sizeStandard, ObjectP[Object[Sample]]],
					convertParticleSizeToDiameter[
						{sizeStandardParticleSize, fastAssocLookup[fastCacheBall, sizeStandard, ParticleSize], fastAssocLookup[fastCacheBall, sizeStandard, {Model, NominalParticleSize}]},
						Micrometer
					],
					convertParticleSizeToDiameter[
						{sizeStandardParticleSize, fastAssocLookup[fastCacheBall, sizeStandard, NominalParticleSize], Null},
						Micrometer
					]
				];
				Switch[sizeStandard,
					(* Compare SuitabilityParticleSize with sample and model particle size info sequentially *)
					ObjectP[Object[Sample]],
					If[MatchQ[sizeStandardParticleDiameter, DistanceP],
						!MatchQ[resolvedParticleDiameter, EqualP[sizeStandardParticleDiameter]],
						!MatchQ[resolvedParticleDiameter, EqualP[sizeStandardModelParticleDiameter]]
					],
					(* Compare SuitabilityParticleSize with model particle size info *)
					ObjectP[Model[Sample]],
					!MatchQ[resolvedParticleDiameter, EqualP[sizeStandardParticleDiameter]],
					(* If size standard is Null, it is okay to have a Null particle size *)
					_,
					!MatchQ[sizeStandardParticleSize, Null]
				]
			]
		],
		{ToList[resolvedSuitabilitySizeStandards], ToList[resolvedSuitabilityParticleSizes]}
	];

	(* Set invalid options *)
	suitabilitySizeStandardMismatchInvalidOptions = If[MemberQ[suitabilitySizeStandardMismatchErrors, True], {SuitabilitySizeStandard, SuitabilityParticleSize}, Nothing];

	(* Throw messages *)
	If[MemberQ[suitabilitySizeStandardMismatchErrors, True] && messages,
		Message[
			Error::SuitabilitySizeStandardMismatch,
			ObjectToString[PickList[resolvedSuitabilitySizeStandards, suitabilitySizeStandardMismatchErrors], Cache -> cacheBall],
			ToString[PickList[resolvedSuitabilityParticleSizes, suitabilitySizeStandardMismatchErrors]]
		]
	];

	(* Make tests *)
	suitabilitySizeStandardMismatchTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[suitabilitySizeStandardMismatchErrors, True],
				Nothing,
				Test["The particle size(s) of SuitabilitySizeStandard sample(s) "<>ObjectToString[PickList[resolvedSuitabilitySizeStandards, suitabilitySizeStandardMismatchErrors, True], Cache -> cacheBall]<>" match SuitabilityParticleSize:", True, False]
			];
			passingTest = If[!MemberQ[suitabilitySizeStandardMismatchErrors, False],
				Nothing,
				Test["The particle size(s) of SuitabilitySizeStandard sample(s) "<>ObjectToString[PickList[resolvedSuitabilitySizeStandards, suitabilitySizeStandardMismatchErrors, False], Cache -> cacheBall]<>" match SuitabilityParticleSize:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- Throw a warning if sample concentration is unknown, but TargetMeasurementConcentration is set by user --- *)
	targetConcentrationNotUsefulWarnings = MapThread[
		And[
			MatchQ[#1, Except[_?QuantityQ]],
			MatchQ[#2, _?QuantityQ]
		]&,
		{sampleConcentrationsAfterDilution, resolvedTargetMeasurementConcentrations}
	];

	(* Throw messages *)
	If[MemberQ[targetConcentrationNotUsefulWarnings, True] && warnings,
		Message[
			Warning::TargetConcentrationNotUseful,
			ObjectToString[PickList[mySamples, targetConcentrationNotUsefulWarnings], Cache -> cacheBall],
			TargetMeasurementConcentration,
			PickList[resolvedTargetMeasurementConcentrations, targetConcentrationNotUsefulWarnings]
		]
	];

	(* Make test *)
	targetConcentrationNotUsefulTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[targetConcentrationNotUsefulWarnings, True],
				Nothing,
				Warning["Input sample(s) "<>ObjectToString[PickList[mySamples, targetConcentrationNotUsefulWarnings], Cache -> cacheBall]<>" do not have available concentration information therefore do not need to set TargetMeasurmentConcentration", True, False]
			];
			passingTest = If[!MemberQ[targetConcentrationNotUsefulWarnings, False],
				Nothing,
				Warning["Input sample(s) "<>ObjectToString[PickList[mySamples, targetConcentrationNotUsefulWarnings, False], Cache -> cacheBall]<>" do not have available concentration information therefore do not need to set TargetMeasurmentConcentration", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- Throw a warning if SuitabilitySizeStandard sample concentration is unknown, but SuitabilityTargetMeasurementConcentration is set by user --- *)
	suitabilityTargetConcentrationNotUsefulWarnings = MapThread[
		And[
			MatchQ[calculateTotalConcentration[#1, First[Units[resolvedSuitabilityTargetConcentrations]]], Except[_?QuantityQ]],
			MatchQ[#2, _?QuantityQ]
		]&,
		{listedSuitabilitySizeStandardPackets, resolvedSuitabilityTargetConcentrations}
	];

	(* Throw messages *)
	If[MemberQ[suitabilityTargetConcentrationNotUsefulWarnings, True] && warnings,
		Message[
			Warning::TargetConcentrationNotUseful,
			ObjectToString[PickList[resolvedSuitabilitySizeStandards, suitabilityTargetConcentrationNotUsefulWarnings], Cache -> cacheBall],
			SuitabilityTargetConcentration,
			PickList[resolvedSuitabilityTargetConcentrations, suitabilityTargetConcentrationNotUsefulWarnings]
		]
	];

	(* Make test *)
	suitabilityTargetConcentrationNotUsefulTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[suitabilityTargetConcentrationNotUsefulWarnings, True],
				Nothing,
				Warning["Suitability sample(s) "<>ObjectToString[PickList[ToList[resolvedSuitabilitySizeStandards], suitabilityTargetConcentrationNotUsefulWarnings], Cache -> cacheBall]<>" do not have available concentration information therefore do not need to set SuitabilityTargetConcentration", True, False]
			];
			passingTest = If[!MemberQ[suitabilityTargetConcentrationNotUsefulWarnings, False],
				Nothing,
				Warning["Suitability sample(s) "<>ObjectToString[PickList[ToList[resolvedSuitabilitySizeStandards], suitabilityTargetConcentrationNotUsefulWarnings, False], Cache -> cacheBall]<>" do not have available concentration information therefore do not need to set SuitabilityTargetConcentration", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- {TargetMeasurementConcentration, SampleAmount, ElectrolyteSampleDilutionVolume, ElectrolytePercentage} matches calculation --- *)
	(* ReleaseHold[...] to get rid of Hold[Nothing] which is used to keep index matching so Transpose[MapThread[[...]] still works when we don't find any errors *)
	{conflictingSampleLoadingInvalidOptions, conflictingSampleLoadingInvalidSamples, conflictingSampleLoadingInformation} = ReleaseHold[Transpose[MapThread[
		Function[
			{sample, sampleConcentration, targetConcentration, sampleAmount, electrolyteSampleDilutionVolume, electrolytePercentage, suitabilityQ},
			Module[{conflictingElectrolytePercentageOptions, sampleConcentrationUnitless, targetConcentrationUnitless, conflictingTargetConcentrationOptions},
				(* Check if this equation holds *)
				(* electrolytePercentage = electrolyteSampleDilutionVolume/(electrolyteSampleDilutionVolume+sampleAmount) *)
				(* Only check for input samples *)
				conflictingElectrolytePercentageOptions = If[!suitabilityQ && !MatchQ[electrolyteSampleDilutionVolume / (electrolyteSampleDilutionVolume + sampleAmount), EqualP[electrolytePercentage]],
					{SampleAmount, ElectrolyteSampleDilutionVolume, ElectrolytePercentage},
					{}
				];
				(* Then check if this equation holds *)
				(* targetConcentration = sampleConcentration*sampleAmount/(electrolyteSampleDilutionVolume+sampleAmount) *)
				(* Take away the unit of the concentration and convert it to 1 / Milliliter before comparing *)
				sampleConcentrationUnitless = unitlessCoulterCountConcentration[sampleConcentration];
				targetConcentrationUnitless = unitlessCoulterCountConcentration[targetConcentration];
				(* do the comparison if *)
				conflictingTargetConcentrationOptions = If[
					And[
						(* we know sample concentration *)
						MatchQ[sampleConcentration, _?QuantityQ],
						(* sample concentration is greater than the target measurement container *)
						MatchQ[sampleConcentrationUnitless, GreaterEqualP[targetConcentrationUnitless]],
						!MatchQ[sampleConcentrationUnitless * sampleAmount / (electrolyteSampleDilutionVolume + sampleAmount), EqualP[targetConcentrationUnitless]]
					],
					(* Set invalid options according to if we are dealing with suitability options or not *)
					If[suitabilityQ,
						{SuitabilityTargetConcentration, SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume},
						{TargetMeasurementConcentration, SampleAmount, ElectrolyteSampleDilutionVolume}
					],
					{}
				];
				(* Gather conflicting options and invalid inputs *)
				If[Length[Join[conflictingElectrolytePercentageOptions, conflictingTargetConcentrationOptions]] > 0,
					{DeleteDuplicates[Join[conflictingElectrolytePercentageOptions, conflictingTargetConcentrationOptions]], sample, {targetConcentration, sampleAmount, electrolyteSampleDilutionVolume, electrolytePercentage}},
					(* Have to Hold[Nothing] here otherwise Transpose[...] would not work well if dont find any errors *)
					(* We will ReleaseHold after Transpose to get rid of all these *)
					{Hold[Nothing], Hold[Nothing], Hold[Nothing]}
				]
			]
		],
		{
			Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
			Join[sampleConcentrationsAfterDilution, suitabilitySizeStandardConcentrations],
			Join[resolvedTargetMeasurementConcentrations, resolvedSuitabilityTargetConcentrations],
			Join[unroundedResolvedSampleAmounts, unroundedResolvedSuitabilitySampleAmounts],
			Join[unroundedResolvedElectrolyteSampleDilutionVolumes, unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes],
			Join[resolvedElectrolytePercentages, resolvedSuitabilityElectrolytePercentages],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[Length[conflictingSampleLoadingInvalidSamples] > 0 && messages,
		Message[
			Error::ConflictingSampleLoadingOptions,
			ObjectToString[conflictingSampleLoadingInvalidSamples, Cache -> cacheBall],
			conflictingSampleLoadingInvalidOptions,
			ToString /@ UnitScale[conflictingSampleLoadingInformation[[All, 1]]],
			ToString /@ UnitScale[conflictingSampleLoadingInformation[[All, 2]]],
			ToString /@ UnitScale[conflictingSampleLoadingInformation[[All, 3]]],
			ToString /@ UnitScale[conflictingSampleLoadingInformation[[All, 4]]]
		]
	];

	(* Make test *)
	conflictingSampleLoadingTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[conflictingSampleLoadingInvalidSamples] == 0,
				Nothing,
				Test["Sample(s) "<>ObjectToString[conflictingSampleLoadingInvalidSamples, Cache -> cacheBall]<>" do not have conflicting Sample Loading options:", True, False]
			];
			passingTest = If[Length[conflictingSampleLoadingInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["Sample(s) "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], conflictingSampleLoadingInvalidSamples], Cache -> cacheBall]<>" do not have conflicting Sample Loading options:", True, True]
			];
			{failingTest, passingTest}
		]

	];

	(* --- Total volume adding SampleAmount and ESDVolume fit in MeasurementContainer for both input samples and SuitabilitySizeStandard samples --- *)
	{measurementContainerTooSmallInvalidOptions, measurementContainerTooSmallInvalidSamples} = ReleaseHold[Transpose[MapThread[
		Function[{sample, sampleAmount, electrolyteSampleDilutionVolume, measurementContainer, suitabilityQ},
			Module[{containerMaxVolume},
				(* Get the MaxVolume of MeasurementContainer *)
				containerMaxVolume = Which[
					(* Use the MaxVolume from the model of the object to avoid computable field *)
					MatchQ[measurementContainer, ObjectP[Object[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, measurementContainer, {Model, MaxVolume}],
					(* Or use the MaxVolume if we are given a model already *)
					MatchQ[measurementContainer, ObjectP[Model[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, measurementContainer, MaxVolume],
					(* Otherwise use the max volume of all containers we have in lab *)
					True,
					largestContainerMaxVolume
				];
				(* If the total volume is greater than the MaxVolume set invalid options and invalid samples *)
				If[MatchQ[sampleAmount + electrolyteSampleDilutionVolume, GreaterP[containerMaxVolume]],
					If[suitabilityQ,
						{{SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume, SuitabilityMeasurementContainer}, sample},
						{{SampleAmount, ElectrolyteSampleDilutionVolume, MeasurementContainer}, sample}
					],
					{Hold[Nothing], Hold[Nothing]}
				]
			]
		],
		{
			Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
			Join[unroundedResolvedSampleAmounts, unroundedResolvedSuitabilitySampleAmounts],
			Join[unroundedResolvedElectrolyteSampleDilutionVolumes, unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes],
			Join[resolvedMeasurementContainers, resolvedSuitabilityMeasurementContainers],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[Length[measurementContainerTooSmallInvalidSamples] > 0 && messages,
		Message[
			Error::MeasurementContainerTooSmall,
			ObjectToString[measurementContainerTooSmallInvalidSamples, Cache -> cacheBall],
			Last /@ measurementContainerTooSmallInvalidOptions,
			Most /@ measurementContainerTooSmallInvalidOptions,
			DeleteDuplicates[Flatten[measurementContainerTooSmallInvalidOptions]]
		]
	];

	(* Make test *)
	measurementContainerTooSmallTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[measurementContainerTooSmallInvalidSamples] == 0,
				Nothing,
				Test["MeasurementContainer/SuitabilityMeasurementContainer for "<>ObjectToString[measurementContainerTooSmallInvalidSamples, Cache -> cacheBall]<>" does not get overflowed:", True, False]
			];
			passingTest = If[Length[measurementContainerTooSmallInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["MeasurementContainer/SuitabilityMeasurementContainer for "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], measurementContainerTooSmallInvalidSamples], Cache -> cacheBall]<>" does not get overflowed:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* 15. TotalVolume adding {SuitabilitySampleAmount SuitabilityESDVolume} or {SampleAmount, ESDVolume} too small compared to {SuitabilityFlowRate * SuitabilityRunTime | RunVolume, FlowRate * RunTime | RunVolume} *)
	{
		notEnoughMeasurementSampleInvalidOptions,
		notEnoughMeasurementSampleErrors,
		notEnoughMeasurementSampleAmountInformation
	} = ReleaseHold[Transpose[MapThread[
		Function[{sampleAmount, electrolyteSampleDilutionVolume, flowRate, runTime, equilibrationTime, runVolume, numberOfReadings, measurementContainer, suitabilityQ},
			Module[{measurementVolume, amountSupplied, containerMaxVolume, amountRequired},
				(* Get the minimum volume for one measurement of one reading *)
				measurementVolume = Which[
					(* If RunVolume is specified set to RunVolume *)
					MatchQ[runVolume, VolumeP],
					runVolume,
					(* If FlowRate is specified, set to flow rate multiplies time *)
					(* Default minimum here is that measurement should be able to at least run 30 Second *)
					MatchQ[flowRate, FlowRateP],
					flowRate * (If[MatchQ[runTime, TimeP], runTime, 20 Second] + equilibrationTime)
				];
				(* get the container max volume *)
				containerMaxVolume = Which[
					MatchQ[measurementContainer, ObjectP[Object[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, measurementContainer, {Model, MaxVolume}],
					MatchQ[measurementContainer, ObjectP[Model[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, measurementContainer, MaxVolume],
					(* catch all case *)
					True,
					largestContainerMaxVolume
				];
				amountSupplied = sampleAmount + electrolyteSampleDilutionVolume;
				(* Make sure we have enough sample: to run at least numberOfReadings+1 runs, the extra run to ensure we can do dynamic dilution, and fill up at least 75 Percent of the measurement container *)
				amountRequired = Module[{totalRunVolume, containerDeadVolume},
					(* required amount to run at least numberOfReadings+1 runs, the extra run to ensure we can do dynamic dilution *)
					totalRunVolume = 2 * measurementVolume * If[NullQ[numberOfReadings], 2, numberOfReadings + 1];
					(* fill up at least 75 Percent of the measurement container *)
					containerDeadVolume = 0.75 * containerMaxVolume;
					Max[Cases[{totalRunVolume, containerDeadVolume}, GreaterEqualP[0 Milliliter]]]
				];
				(* If the total volume is less than minimum volume required set invalid options and invalid samples *)
				If[MatchQ[amountSupplied, LessP[amountRequired]],
					If[suitabilityQ,
						{
							{SuitabilitySampleAmount, SuitabilityElectrolyteSampleDilutionVolume, SuitabilityFlowRate, SuitabilityRunVolume, SuitabilityRunTime, SuitabilityEquilibrationTime, NumberOfSuitabilityReadings},
							True,
							{amountSupplied, amountRequired}
						},
						{
							{SampleAmount, ElectrolyteSampleDilutionVolume, FlowRate, RunVolume, RunTime, EquilibrationTime, NumberOfReadings},
							True,
							{amountSupplied, amountRequired}
						}
					],
					{Hold[Nothing], False, Hold[Nothing]}
				]
			]
		],
		{
			Join[unroundedResolvedSampleAmounts, unroundedResolvedSuitabilitySampleAmounts],
			Join[unroundedResolvedElectrolyteSampleDilutionVolumes, unroundedResolvedSuitabilityElectrolyteSampleDilutionVolumes],
			Join[resolvedFlowRates, resolvedSuitabilityFlowRates],
			Join[resolvedRunTimes, resolvedSuitabilityRunTimes],
			Join[resolvedEquilibrationTimes, resolvedSuitabilityEquilibrationTimes],
			Join[resolvedRunVolumes, resolvedSuitabilityRunVolumes],
			Join[resolvedNumberOfReadings, resolvedNumberOfSuitabilityReadings],
			Join[resolvedMeasurementContainers, resolvedSuitabilityMeasurementContainers],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[MemberQ[notEnoughMeasurementSampleErrors, True] && messages,
		Message[
			Error::NotEnoughMeasurementSample,
			ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], notEnoughMeasurementSampleErrors], Cache -> cacheBall],
			Take[#, 2]& /@ notEnoughMeasurementSampleInvalidOptions,
			UnitScale[notEnoughMeasurementSampleAmountInformation][[All, 1]],
			UnitScale[notEnoughMeasurementSampleAmountInformation][[All, 2]],
			DeleteDuplicates[Flatten[Take[#, 2]& /@ notEnoughMeasurementSampleInvalidOptions]],
			DeleteDuplicates[Flatten[Drop[#, 2]& /@ notEnoughMeasurementSampleInvalidOptions]]
		]
	];

	(* Make test *)
	notEnoughMeasurementSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[notEnoughMeasurementSampleErrors, True],
				Nothing,
				Test["Sample loading options for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], notEnoughMeasurementSampleErrors, True], Cache -> cacheBall]<>" provide enough samples for measurement:", True, False]
			];
			passingTest = If[!MemberQ[notEnoughMeasurementSampleErrors, False],
				Nothing,
				Test["Sample loading options for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], notEnoughMeasurementSampleErrors, False], Cache -> cacheBall]<>" provide enough samples for measurement:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- {SuitabilityMixTime, SuitabilityMixDirection, SuitabilityMixRate}, {MixTime, MixDirection, MixRate} conflicting options --- *)
	{conflictingMixInvalidOptions, conflictingMixInvalidSamples} = ReleaseHold[Transpose[MapThread[
		Function[{sample, mixRate, mixTime, mixDirection, suitabilityQ},
			If[
				!MatchQ[
					{mixRate, mixTime, mixDirection},
					Alternatives[
						(* MixRate is 0 RPM, we are not mixing *)
						{0 * RPM, Null, Null},
						(* MixRate is Null, we are not mixing *)
						{Null, Null, Null},
						(* MixRate is >0 RPM, we are mixing *)
						{GreaterP[0 * RPM], Except[NullP], Except[NullP]}
					]
				],
				If[suitabilityQ,
					{{SuitabilityMixRate, SuitabilityMixTime, SuitabilityMixDirection}, sample},
					{{MixRate, MixTime, MixDirection}, sample}
				],
				{Hold[Nothing], Hold[Nothing]}
			]
		],
		{
			Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
			Join[resolvedMixRates, resolvedSuitabilityMixRates],
			Join[resolvedMixTimes, resolvedSuitabilityMixTimes],
			Join[resolvedMixDirections, resolvedSuitabilityMixDirections],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[Length[conflictingMixInvalidSamples] > 0 && messages,
		Message[
			Error::ConflictingMixOptions,
			ObjectToString[conflictingMixInvalidSamples, Cache -> cacheBall],
			conflictingMixInvalidOptions,
			DeleteDuplicates[Flatten[conflictingMixInvalidOptions]]
		]
	];

	(* Make test *)
	conflictingMixTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[conflictingMixInvalidSamples] == 0,
				Nothing,
				Test["Sample(s) "<>ObjectToString[conflictingMixInvalidSamples, Cache -> cacheBall]<>" do not have conflicting mix options:", True, False]
			];
			passingTest = If[Length[conflictingMixInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["Sample(s) "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], conflictingMixInvalidSamples], Cache -> cacheBall]<>" do not have conflicting mix options:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- {MinSuitabilityParticleSize, ParticleSize} is within 2-80% of the ApertureDiameter --- *)
	{minParticleSizeTooLargeInvalidOptions, minParticleSizeTooLargeInvalidSamples} = Module[{allMinParticleDiameters, minParticleSizeTooLargeErrors},
		(* Need to convert all particle sizes in different units (Volume/Diameter) to diameter first for easy comparison *)
		allMinParticleDiameters = convertParticleSizeToDiameter[Join[resolvedMinParticleSizes, resolvedMinSuitabilityParticleSizes], Micrometer];
		(* Create a list of bools to indicate if we have any errors *)
		minParticleSizeTooLargeErrors = GreaterQ[#, 0.8 * resolvedApertureDiameter]& /@ allMinParticleDiameters;
		(* Set invalid options and invalid samples *)
		{
			(* set invalid options *)
			MapThread[
				Switch[{#1, #2},
					(* If we have error but not dealing with suitability samples *)
					{True, False},
					MinParticleSize,
					(* If we have error and dealing with suitability samples *)
					{True, True},
					MinSuitabilityParticleSize,
					(* If we don't have error *)
					{False, _},
					Nothing
				]&,
				{
					minParticleSizeTooLargeErrors,
					(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
					Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
				}
			],
			(* set invalid samples *)
			PickList[
				Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
				minParticleSizeTooLargeErrors
			]
		}
	];

	(* Throw messages *)
	If[Length[minParticleSizeTooLargeInvalidSamples] > 0 && messages,
		Message[
			Error::MinParticleSizeTooLarge,
			ObjectToString[minParticleSizeTooLargeInvalidSamples, Cache -> cacheBall],
			minParticleSizeTooLargeInvalidOptions,
			resolvedApertureDiameter,
			DeleteDuplicates[Flatten[minParticleSizeTooLargeInvalidOptions]]
		]
	];

	(* Make test *)
	minParticleSizeTooLargeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[minParticleSizeTooLargeInvalidSamples] == 0,
				Nothing,
				Test["MinParticleSize or MinSuitabilityParticleSize for "<>ObjectToString[minParticleSizeTooLargeInvalidSamples, Cache -> cacheBall]<>" do not exceed 80% of the ApertureDiameter:", True, False]
			];
			passingTest = If[Length[minParticleSizeTooLargeInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["MinParticleSize or MinSuitabilityParticleSize for "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], minParticleSizeTooLargeInvalidSamples], Cache -> cacheBall]<>" do not exceed 80% of the ApertureDiameter:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- {SuitabilityStopCondition, StopCondition} conflicting options --- *)
	{conflictingStopConditionInvalidOptions, conflictingStopConditionInvalidSamples} = ReleaseHold[Transpose[MapThread[
		Function[{sample, stopCondition, runTime, runVolume, modalCount, totalCount, suitabilityQ},
			Module[{conflictingOptions},
				(* Look for conflicting options *)
				conflictingOptions = Switch[stopCondition,
					(* Time mode, only RunTime should be set *)
					Time,
					(* If we are dealing with suitability samples, prepending Suitability to the Symbol names *)
					If[suitabilityQ, ToExpression["Suitability"<>ToString[#]], Identity[#]]& /@ Append[
						PickList[{RunVolume, ModalCount, TotalCount}, {runVolume, modalCount, totalCount}, Except[NullP]],
						If[MatchQ[runTime, GreaterP[0 Second]], Nothing, RunTime]
					],
					(* Volume mode, only RunVolume should be set *)
					Volume,
					(* If we are dealing with suitability samples, prepending Suitability to the Symbol names *)
					If[suitabilityQ, ToExpression["Suitability"<>ToString[#]], Identity[#]]& /@ Append[
						PickList[{RunTime, ModalCount, TotalCount}, {runTime, modalCount, totalCount}, Except[NullP]],
						If[MatchQ[runVolume, GreaterP[0 Microliter]], Nothing, RunVolume]
					],
					(* ModalCount mode, only ModalCount should be set *)
					ModalCount,
					(* If we are dealing with suitability samples, prepending Suitability to the Symbol names *)
					If[suitabilityQ, ToExpression["Suitability"<>ToString[#]], Identity[#]]& /@ Append[
						PickList[{RunTime, RunVolume, TotalCount}, {runTime, runVolume, totalCount}, Except[NullP]],
						If[MatchQ[modalCount, GreaterP[0]], Nothing, ModalCount]
					],
					(* TotalCount model, only TotalCount should be set *)
					TotalCount,
					(* If we are dealing with suitability samples, prepending Suitability to the Symbol names *)
					If[suitabilityQ, ToExpression["Suitability"<>ToString[#]], Identity[#]]& /@ Append[
						PickList[{RunTime, RunVolume, ModalCount}, {runTime, runVolume, modalCount}, Except[NullP]],
						If[MatchQ[totalCount, GreaterP[0]], Nothing, TotalCount]
					],
					_,
					{}
				];
				(* Gather results *)
				If[Length[conflictingOptions] > 0,
					{Append[conflictingOptions, If[suitabilityQ, SuitabilityStopCondition, StopCondition]], sample},
					{Hold[Nothing], Hold[Nothing]}
				]
			]
		],
		{
			Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
			Join[resolvedStopConditions, resolvedSuitabilityStopConditions],
			Join[resolvedRunTimes, resolvedSuitabilityRunTimes],
			Join[resolvedRunVolumes, resolvedSuitabilityRunVolumes],
			Join[resolvedModalCounts, resolvedSuitabilityModalCounts],
			Join[resolvedTotalCounts, resolvedSuitabilityTotalCounts],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[Length[conflictingStopConditionInvalidOptions] > 0 && messages,
		Message[
			Error::ConflictingStopConditionOptions,
			ObjectToString[conflictingStopConditionInvalidSamples, Cache -> cacheBall],
			Most /@ conflictingStopConditionInvalidOptions,
			Last /@ conflictingStopConditionInvalidOptions,
			DeleteDuplicates[Flatten[conflictingStopConditionInvalidOptions]]
		]
	];

	(* Make test *)
	conflictingStopConditionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[conflictingStopConditionInvalidSamples] == 0,
				Nothing,
				Test["Sample(s) "<>ObjectToString[conflictingStopConditionInvalidSamples, Cache -> cacheBall]<>" do not have conflicting StopCondition options:", True, False]
			];
			passingTest = If[Length[conflictingStopConditionInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["Sample(s) "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], conflictingStopConditionInvalidSamples], Cache -> cacheBall]<>" do not have conflicting StopCondition options:", True, True]
			];
			{failingTest, passingTest}
		]

	];

	(* --- ElectrolyteSolutionVolume not enough to fulfil all the flushes for all measurements --- *)
	notEnoughElectrolyteSolutionInvalidOptions = If[MatchQ[resolvedElectrolyteSolutionVolume, LessP[totalFlushVolumeRequired]], ElectrolyteSolutionVolume, Nothing];

	(* Throw messages *)
	If[MatchQ[resolvedElectrolyteSolutionVolume, LessP[totalFlushVolumeRequired]] && messages,
		Message[
			Error::NotEnoughElectrolyteSolution,
			resolvedElectrolyteSolutionVolume,
			UnitScale@totalFlushVolumeRequired
		]
	];

	(* Make test *)
	notEnoughElectrolyteSolutionTest = If[gatherTests,
		Test["ElectrolyteSolutionVolume is enough to fulfill all the flushes during measurements:",
			resolvedElectrolyteSolutionVolume,
			GreaterEqualP[totalFlushVolumeRequired]
		]
	];

	(* --- Length of {SuitabilityCumulativeDynamicDilutionFactor, CumulativeDynamicDilutionFactor} must equal to {SuitabilityMaxNumberOfDynamicDilutions, MaxNumberOfDynamicDilutions}. --- *)
	{invalidNumberOfDynamicOfDilutionsInvalidOptions, invalidNumberOfDynamicOfDilutionsErrors} = ReleaseHold[Transpose[MapThread[
		Function[{cumulativeDynamicDilutionFactor, maxNumberOfDynamicDilutions, suitabilityQ},
			If[MatchQ[cumulativeDynamicDilutionFactor, {__?NumericQ}] && (!MatchQ[Length[cumulativeDynamicDilutionFactor], EqualP[maxNumberOfDynamicDilutions]]),
				If[suitabilityQ,
					{{SuitabilityCumulativeDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions}, True},
					{{CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions}, True}
				],
				{Hold[Nothing], False}
			]
		],
		{
			Join[resolvedCumulativeDynamicDilutionFactors, resolvedSuitabilityCumulativeDynamicDilutionFactors],
			Join[resolvedMaxNumberOfDynamicDilutions, resolvedSuitabilityMaxNumberOfDynamicDilutions],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[MemberQ[invalidNumberOfDynamicOfDilutionsErrors, True] && messages,
		Message[
			Error::InvalidNumberOfDynamicDilutions,
			ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], invalidNumberOfDynamicOfDilutionsErrors], Cache -> cacheBall],
			First /@ invalidNumberOfDynamicOfDilutionsInvalidOptions,
			Length /@ PickList[Join[resolvedCumulativeDynamicDilutionFactors, resolvedSuitabilityCumulativeDynamicDilutionFactors], invalidNumberOfDynamicOfDilutionsErrors],
			Last /@ invalidNumberOfDynamicOfDilutionsInvalidOptions,
			PickList[Join[resolvedMaxNumberOfDynamicDilutions, resolvedSuitabilityMaxNumberOfDynamicDilutions], invalidNumberOfDynamicOfDilutionsErrors],
			DeleteDuplicates[Flatten[invalidNumberOfDynamicOfDilutionsInvalidOptions]]
		]
	];

	(* Make test *)
	invalidNumberOfDynamicOfDilutionsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[invalidNumberOfDynamicOfDilutionsErrors, True],
				Nothing,
				Test["Length of SuitabilityCumulativeDynamicDilutionFactor or CumulativeDynamicDilutionFactor for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], invalidNumberOfDynamicOfDilutionsErrors, True], Cache -> cacheBall]<>" equal to SuitabilityMaxNumberOfDynamicDilutions or MaxNumberOfDynamicDilutions:", True, False]
			];
			passingTest = If[!MemberQ[invalidNumberOfDynamicOfDilutionsErrors, False],
				Nothing,
				Test["Length of SuitabilityCumulativeDynamicDilutionFactor or CumulativeDynamicDilutionFactor for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], invalidNumberOfDynamicOfDilutionsErrors, False], Cache -> cacheBall]<>" equal to SuitabilityMaxNumberOfDynamicDilutions or MaxNumberOfDynamicDilutions:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- Dynamic dilution options do not conflict with master switches of DynamicDilute or SuitabilityDynamicDilute for input and size standard samples --- *)
	{conflictingDynamicDilutionInvalidOptions, conflictingDynamicDilutionInvalidSamples} = ReleaseHold[Transpose[MapThread[
		Function[{sample, dynamicDilute, constantDynamicDilutionFactor, cumulativeDynamicDilutionFactor, maxNumberOfDynamicDilutions, suitabilityQ},
			Module[{dynamicOptionNames, dynamicAllowNullOptionNames, conflictingOptions},
				(* All dynamic dilution options that may be conflicting with master switch DynamicDilute or SuitabilityDynamicDilute *)
				dynamicOptionNames = If[suitabilityQ,
					{SuitabilityConstantDynamicDilutionFactor, SuitabilityCumulativeDynamicDilutionFactor, SuitabilityMaxNumberOfDynamicDilutions},
					{ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions}
				];
				(* These options can be Null even if master switch is set to True and we have conflicting checks later to check if they are consistent internally *)
				dynamicAllowNullOptionNames = If[suitabilityQ,
					{SuitabilityConstantDynamicDilutionFactor},
					{ConstantDynamicDilutionFactor}
				];
				(* Set invalid options *)
				conflictingOptions = If[TrueQ[dynamicDilute],
					PickList[Complement[dynamicOptionNames, dynamicAllowNullOptionNames], {cumulativeDynamicDilutionFactor, maxNumberOfDynamicDilutions}, NullP],
					PickList[dynamicOptionNames, {constantDynamicDilutionFactor, cumulativeDynamicDilutionFactor, maxNumberOfDynamicDilutions}, Except[NullP]]
				];
				(* Set invalid samples *)
				If[Length[conflictingOptions] > 0,
					{Append[conflictingOptions, If[suitabilityQ, SuitabilityDynamicDilute, DynamicDilute]], sample},
					{Hold[Nothing], Hold[Nothing]}
				]
			]
		],
		{
			Join[mySamples, ToList[resolvedSuitabilitySizeStandards]],
			Join[resolvedDynamicDilutes, resolvedSuitabilityDynamicDilutes],
			Join[resolvedConstantDynamicDilutionFactors, resolvedSuitabilityConstantDynamicDilutionFactors],
			Join[resolvedCumulativeDynamicDilutionFactors, resolvedSuitabilityCumulativeDynamicDilutionFactors],
			Join[resolvedMaxNumberOfDynamicDilutions, resolvedSuitabilityMaxNumberOfDynamicDilutions],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[Length[conflictingDynamicDilutionInvalidSamples] > 0 && messages,
		Message[
			Error::ConflictingDynamicDilutionOptions,
			ObjectToString[conflictingDynamicDilutionInvalidSamples, Cache -> cacheBall],
			Most /@ conflictingDynamicDilutionInvalidOptions,
			Last /@ conflictingDynamicDilutionInvalidOptions,
			DeleteDuplicates[Flatten[conflictingDynamicDilutionInvalidOptions]]
		]
	];

	(* Make test *)
	conflictingDynamicDilutionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[conflictingDynamicDilutionInvalidSamples] == 0,
				Nothing,
				Test["Sample(s) "<>ObjectToString[conflictingDynamicDilutionInvalidSamples, Cache -> cacheBall]<>" do not have conflicting dynamic dilution options:", True, False]
			];
			passingTest = If[Length[conflictingDynamicDilutionInvalidSamples] == Length[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]]],
				Nothing,
				Test["Sample(s) "<>ObjectToString[Complement[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], conflictingDynamicDilutionInvalidSamples], Cache -> cacheBall]<>" do not have conflicting dynamic dilution options:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* 30. ConstantDynamicDilutionFactor does not conflict with CumulativeDynamicDilutionFactor values *)
	{constantCumulativeDilutionFactorMismatchInvalidOptions, constantCumulativeDilutionFactorMismatchErrors} = ReleaseHold[Transpose[MapThread[
		Function[{dynamicDilute, constantDynamicDilutionFactor, cumulativeDynamicDilutionFactor, suitabilityQ},
			(* Only check for this error if we are doing dynamic dilutions *)
			If[TrueQ[dynamicDilute],
				Module[{pairedDilutionFactors, uniqueSerialDilutionFactors},
					(* Partition the list of cumulative dilution factors into pairs of adjacent elements *)
					pairedDilutionFactors = Partition[Reverse[cumulativeDynamicDilutionFactor], 2, 1];
					(* Do the division to get the serial dilution factor for each pair *)
					(* Find out if the dilution factor is the same across all dilution steps *)
					uniqueSerialDilutionFactors = DeleteDuplicates[Divide @@@ pairedDilutionFactors];
					(* Set invalid options *)
					If[
						!Or[
							(* Case 1: ConstantDynamicDilutionFactor is specified and matches CumulativeDynamicDilutionFactor *)
							And[
								(* ConstantDynamicDilutionFactor is specified *)
								MatchQ[constantDynamicDilutionFactor, _?NumericQ],
								(* ConstantDynamicDilutionFactor should equal to the serial dilution factors from CumulativeDynamicDilutionFactor *)
								If[Length[uniqueSerialDilutionFactors] == 1,
									MatchQ[First[uniqueSerialDilutionFactors], EqualP[constantDynamicDilutionFactor]],
									(* otherwise this check always fails *)
									False
								]
							],
							(* Case 2: ConstantDynamicDilutionFactor is Null and CumulativeDynamicDilutionFactor have variable serial dilution factors *)
							And[
								(* ConstantDynamicDilutionFactor is Null *)
								MatchQ[constantDynamicDilutionFactor, NullP],
								(* CumulativeDynamicDilutionFactor have variable serial dilution factors *)
								MatchQ[Length[uniqueSerialDilutionFactors], GreaterP[1]]
							]
						],
						If[suitabilityQ,
							{{SuitabilityConstantDynamicDilutionFactor, SuitabilityCumulativeDynamicDilutionFactor}, True},
							{{ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor}, True}
						],
						{Hold[Nothing], False}
					]
				],
				{Hold[Nothing], False}
			]
		],
		{
			Join[resolvedDynamicDilutes, resolvedSuitabilityDynamicDilutes],
			Join[resolvedConstantDynamicDilutionFactors, resolvedSuitabilityConstantDynamicDilutionFactors],
			Join[resolvedCumulativeDynamicDilutionFactors, resolvedSuitabilityCumulativeDynamicDilutionFactors],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	]]];

	(* Throw messages *)
	If[MemberQ[constantCumulativeDilutionFactorMismatchErrors, True] && messages,
		Message[
			Error::ConstantCumulativeDilutionFactorMismatch,
			ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], constantCumulativeDilutionFactorMismatchErrors], Cache -> cacheBall],
			First /@ constantCumulativeDilutionFactorMismatchInvalidOptions,
			PickList[Join[resolvedConstantDynamicDilutionFactors, resolvedSuitabilityConstantDynamicDilutionFactors], constantCumulativeDilutionFactorMismatchErrors],
			Last /@ constantCumulativeDilutionFactorMismatchInvalidOptions,
			PickList[Join[resolvedCumulativeDynamicDilutionFactors, resolvedSuitabilityCumulativeDynamicDilutionFactors], constantCumulativeDilutionFactorMismatchErrors],
			DeleteDuplicates[Flatten[constantCumulativeDilutionFactorMismatchInvalidOptions]]
		]
	];

	(* Make test *)
	constantCumulativeDilutionFactorMismatchTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[constantCumulativeDilutionFactorMismatchErrors, True],
				Nothing,
				Test["CumulativeDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], constantCumulativeDilutionFactorMismatchErrors, True], Cache -> cacheBall]<>" do not conflict with CumulativeDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor:", True, False]
			];
			passingTest = If[!MemberQ[constantCumulativeDilutionFactorMismatchErrors, False],
				Nothing,
				Test["CumulativeDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor for "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], constantCumulativeDilutionFactorMismatchErrors, False], Cache -> cacheBall]<>" do not conflict with CumulativeDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor:", True, True]
			];
			{failingTest, passingTest}
		]
	];

	(* --- conflicting Dilution options --- *)
	{conflictingDilutionInvalidOptions, conflictingDilutionOptionsErrors} = Module[
		{mapThreadFriendlyResolvedOption},
		(* Have to now make the resolved options a MapThread friendly version *)
		mapThreadFriendlyResolvedOption = OptionsHandling`Private`mapThreadOptions[ExperimentCoulterCount, resolvedOptions];
		(* Now MapThread to check if we have any conflicting options *)
		ReleaseHold[Transpose[MapThread[
			Function[{resolvedDilute, options},
				Module[{conflictingOptions},
					(* Set invalid options *)
					conflictingOptions = If[TrueQ[resolvedDilute],
						PickList[Complement[$CoulterCountDilutionOptions, $CoulterCountDilutionAllowNullOptions], Lookup[options, Complement[$CoulterCountDilutionOptions, $CoulterCountDilutionAllowNullOptions]], NullP],
						(* If we are not doing suitability check, all options listed should be Null *)
						PickList[$CoulterCountDilutionOptions, Lookup[options, $CoulterCountDilutionOptions], Except[NullP]]
					];
					(* Return results and error marks *)
					If[Length[conflictingOptions] > 0,
						{conflictingOptions, True},
						{Hold[Nothing], False}
					]
				]
			],
			{resolvedDilutes, mapThreadFriendlyResolvedOption}
		]]]
	];

	(* Throw messages *)
	If[MemberQ[conflictingDilutionOptionsErrors, True] && messages,
		Message[
			Error::ConflictingDilutionOptions,
			ObjectToString[PickList[mySamples, conflictingDilutionOptionsErrors], Cache -> cacheBall],
			PickList[resolvedDilutes, conflictingDilutionOptionsErrors],
			conflictingDilutionInvalidOptions,
			DeleteDuplicates[Flatten[{conflictingDilutionInvalidOptions, Dilute}]]
		]
	];

	(* Make tests *)
	conflictingDilutionOptionsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[conflictingDilutionOptionsErrors, True],
				Nothing,
				Test["Sample(s) "<>ObjectToString[PickList[mySamples, conflictingDilutionOptionsErrors, True], Cache -> cacheBall]<>" do not have conflicting dilution options:", True, False]
			];
			passingTest = If[!MemberQ[conflictingDilutionOptionsErrors, False],
				Nothing,
				Test["Sample(s) "<>ObjectToString[PickList[mySamples, conflictingDilutionOptionsErrors, False], Cache -> cacheBall]<>" do not have conflicting dilution options:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];


	(* --- DynamicDilution is not supported if we are doing DilutionStrategy->Series since that will make the procedure too complicated --- *)
	{dynamicDiluteDilutionStrategyIncompatibleInvalidOptions, dynamicDiluteDilutionStrategyIncompatibleErrors} = Transpose[MapThread[
		Which[
			(* conflicting if we are doing DilutionStrategy->Series and DynamicDilute->True *)
			MatchQ[{#1, #2}, {Series, True}],
			{{DilutionStrategy, DynamicDilute}, True},
			(* Otherwise, no error *)
			True,
			{{}, False}
		]&,
		{Lookup[resolvedOptions, DilutionStrategy], resolvedDynamicDilutes}
	]];

	(* Throw messages *)
	If[MemberQ[dynamicDiluteDilutionStrategyIncompatibleErrors, True] && messages,
		Message[
			Error::DynamicDiluteDilutionStrategyIncompatible,
			ObjectToString[PickList[mySamples, dynamicDiluteDilutionStrategyIncompatibleErrors], Cache -> cacheBall]
		]
	];

	(* Make tests *)
	dynamicDiluteDilutionStrategyIncompatibleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[dynamicDiluteDilutionStrategyIncompatibleErrors, True],
				Nothing,
				Test["Sample(s) "<>ObjectToString[PickList[mySamples, dynamicDiluteDilutionStrategyIncompatibleErrors, True], Cache -> cacheBall]<>"'s DynamicDilute option is compatible with DilutionStrategy:", True, False]
			];
			passingTest = If[!MemberQ[dynamicDiluteDilutionStrategyIncompatibleErrors, False],
				Nothing,
				Test["Sample(s) "<>ObjectToString[PickList[mySamples, dynamicDiluteDilutionStrategyIncompatibleErrors, False], Cache -> cacheBall]<>"'s DynamicDilute option is compatible with DilutionStrategy:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- If an object is provided for MeasurementContainers or SuitabilityMeasurementContainers it must be empty --- *)
	{nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors} = Module[{},
		{
			Map[
				(* set an error flag if container is an object and it is not empty *)
				And[
					MatchQ[#, ObjectP[Object[Container, Vessel]]],
					MatchQ[fastAssocLookup[fastCacheBall, #, Contents], Except[{}]]
				]&,
				resolvedMeasurementContainers
			],
			Map[
				(* set an error flag if container is an object and it is not empty *)
				And[
					MatchQ[#, ObjectP[Object[Container, Vessel]]],
					MatchQ[fastAssocLookup[fastCacheBall, #, Contents], Except[{}]]
				]&,
				resolvedSuitabilityMeasurementContainers
			]
		}
	];
	nonEmptyMeasurementContainerInvalidOptions = {
		If[MemberQ[nonEmptyMeasurementContainerErrors, True], MeasurementContainer, Nothing],
		If[MemberQ[nonEmptySuitabilityMeasurementErrors, True], SuitabilityMeasurementContainer, Nothing]
	};

	(* Throw messages *)
	If[MemberQ[Join[nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors], True] && messages,
		Message[
			Error::NonEmptyMeasurementContainers,
			nonEmptyMeasurementContainerInvalidOptions,
			ObjectToString[PickList[resolvedMeasurementContainers, nonEmptyMeasurementContainerErrors], Cache -> cacheBall],
			ObjectToString[PickList[resolvedSuitabilityMeasurementContainers, nonEmptySuitabilityMeasurementErrors], Cache -> cacheBall]
		]
	];

	(* Make tests *)
	nonEmptyMeasurementContainerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[Join[nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors], True],
				Nothing,
				Test["Containers "<>ObjectToString[Join[PickList[resolvedMeasurementContainers, nonEmptyMeasurementContainerErrors], PickList[resolvedSuitabilityMeasurementContainers, nonEmptySuitabilityMeasurementErrors]], Cache -> cacheBall]<>"are either empty or a model", True, False]
			];
			passingTest = If[!MemberQ[Join[nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors], False],
				Nothing,
				Test["Containers "<>ObjectToString[Join[PickList[resolvedMeasurementContainers, nonEmptyMeasurementContainerErrors, False], PickList[resolvedSuitabilityMeasurementContainers, nonEmptySuitabilityMeasurementErrors, False]], Cache -> cacheBall]<>"are either empty or a model", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];


	(* --- If user is using non-Volume mode for aperture diameter <= 280 um, throw a warning --- *)
	volumeModeRecommendedWarnings = Map[
		If[MatchQ[resolvedApertureDiameter, LessEqualP[280 * Micrometer]], !MatchQ[#, Volume | NullP], False]&,
		Join[resolvedStopConditions, resolvedSuitabilityStopConditions]
	];

	(* Set invalid options for error message display *)
	volumeModeRecommendedInvalidOptions = MapThread[
		Switch[{#1, #2},
			(* If we have error but not dealing with suitability samples *)
			{True, False},
			StopCondition,
			(* If we have error and dealing with suitability samples *)
			{True, True},
			SuitabilityStopCondition,
			(* If we don't have error *)
			{False, _},
			Nothing
		]&,
		{
			volumeModeRecommendedWarnings,
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	];

	(* Set invalid samples for error message display *)
	volumeModeRecommendedInvalidSamples = PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], volumeModeRecommendedWarnings];

	(* throw messages *)
	If[MemberQ[volumeModeRecommendedWarnings, True] && warnings,
		Message[
			Warning::VolumeModeRecommended,
			volumeModeRecommendedInvalidSamples,
			volumeModeRecommendedInvalidOptions,
			resolvedApertureDiameter
		]
	];

	(* make tests *)
	volumeModeRecommendedTest = If[gatherTests,
		Warning["Volume mode is used when Aperture Diameter is less than or equal to 280 Micrometer",
			MemberQ[volumeModeRecommendedWarnings, True],
			False
		]
	];

	(* --- Throw an error if QuantifyConcentration is set to True, and sample has more than one analytes --- *)
	moreThanOneCompositionErrors = MapThread[
		If[TrueQ[#1] && Length[#2] > 1, True, False]&,
		{resolvedQuantifyConcentrations, potentialAnalytesToUse}
	];

	moreThanOneCompositionInvalidInputs = PickList[mySamples, moreThanOneCompositionErrors];
	moreThanOneCompositionInvalidOptions = If[MemberQ[moreThanOneCompositionErrors, True], {QuantifyConcentration}, {}];

	(* throw messages *)
	If[MemberQ[moreThanOneCompositionErrors, True] && messages,
		Message[Error::MoreThanOneComposition,
			ObjectToString[moreThanOneCompositionInvalidInputs, Cache -> cacheBall],
			ObjectToString[PickList[potentialAnalytesToUse, moreThanOneCompositionErrors], Cache -> cacheBall]
		]
	];

	(* make tests *)
	moreThanOneCompositionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[moreThanOneCompositionErrors, True],
				Nothing,
				Test["Samples "<>ObjectToString[moreThanOneCompositionInvalidInputs, Cache -> cacheBall]<>"have one countable analyte and does not conflict with QuantifyConcentration option.", True, False]
			];
			passingTest = If[!MemberQ[moreThanOneCompositionErrors, False],
				Nothing,
				Test["Samples "<>ObjectToString[PickList[mySamples, moreThanOneCompositionErrors, False], Cache -> cacheBall]<>"have one countable analyte and does not conflict with QuantifyConcentration option.", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- if we are using cuvette, we cannot mix, throw a warning --- *)
	{cannotMixMeasurementContainerWarnings, cannotMixMeasurementContainerInvalidOptions} = Transpose@MapThread[
		Function[{container, mixTime, mixRate, mixDirection, suitabilityQ},
			Module[{footprint, cannotMixMeasurementContainerWarning},
				(* check the footrpint for the resolved measruement container *)
				footprint = If[MatchQ[container, ObjectP[Object[Container, Vessel]]],
					fastAssocLookup[fastCacheBall, container, {Model, Footprint}],
					fastAssocLookup[fastCacheBall, container, Footprint]
				];
				cannotMixMeasurementContainerWarning = And[
					MatchQ[footprint, MS4e25mLCuvette],
					Or[
						MatchQ[mixTime, GreaterP[0 * Second]],
						MatchQ[mixRate, GreaterP[0 * RPM]],
						MatchQ[mixDirection, Clockwise | Counterclockwise]
					]
				];
				{
					cannotMixMeasurementContainerWarning,
					If[TrueQ[cannotMixMeasurementContainerWarning],
						If[TrueQ[suitabilityQ], SuitabilityMeasurementContainer, MeasurementContainer],
						{}
					]
				}
			]
		],
		{
			Join[resolvedMeasurementContainers, resolvedSuitabilityMeasurementContainers],
			Join[resolvedMixTimes, resolvedSuitabilityMixTimes],
			Join[resolvedMixRates, resolvedSuitabilityMixRates],
			Join[resolvedMixDirections, resolvedSuitabilityMixDirections],
			(* This is a boolean indicating if we are looking at an input sample or suitability sample *)
			Join[ConstantArray[False, Length[mySamples]], ConstantArray[True, Length[ToList[resolvedSuitabilitySizeStandards]]]]
		}
	];

	(* throw messages *)
	If[MemberQ[cannotMixMeasurementContainerWarnings, True] && warnings,
		Message[
			Warning::CannotMixMeasurementContainer,
			PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], cannotMixMeasurementContainerWarnings, True],
			Flatten[cannotMixMeasurementContainerInvalidOptions],
			PickList[Join[resolvedMeasurementContainers, resolvedSuitabilityMeasurementContainers], cannotMixMeasurementContainerWarnings, True]
		]
	];

	(* make tests *)
	cannotMixMeasurementContainerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!MemberQ[cannotMixMeasurementContainerWarnings, True],
				Nothing,
				Warning["Containers "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], cannotMixMeasurementContainerWarnings, True], Cache -> cacheBall]<>" cannot be mixed if it is a accuvette", True, False]
			];
			passingTest = If[!MemberQ[Join[nonEmptyMeasurementContainerErrors, nonEmptySuitabilityMeasurementErrors], False],
				Nothing,
				Warning["Containers "<>ObjectToString[PickList[Join[mySamples, ToList[resolvedSuitabilitySizeStandards]], cannotMixMeasurementContainerWarnings, False], Cache -> cacheBall]<>"cannot be mixed if it is a accuvette", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		nonLiquidInvalidInputs,
		particleSizeOutOfRangeInvalidInputs,
		moreThanOneCompositionInvalidInputs
	}]];
	invalidOptions = DeleteDuplicates[Flatten[{
		apertureTubeDiameterMismatchInvalidOptions,
		particleSizeOutOfRangeInvalidOptions,
		conflictingSuitabilityCheckInvalidOptions,
		suitabilityParticleSizeOutOfRangeInvalidOptions,
		suitabilitySizeStandardMismatchInvalidOptions,
		conflictingSampleLoadingInvalidOptions,
		measurementContainerTooSmallInvalidOptions,
		notEnoughMeasurementSampleInvalidOptions,
		conflictingMixInvalidOptions,
		minParticleSizeTooLargeInvalidOptions,
		conflictingStopConditionInvalidOptions,
		notEnoughElectrolyteSolutionInvalidOptions,
		invalidNumberOfDynamicOfDilutionsInvalidOptions,
		conflictingDynamicDilutionInvalidOptions,
		constantCumulativeDilutionFactorMismatchInvalidOptions,
		conflictingDilutionInvalidOptions,
		dynamicDiluteDilutionStrategyIncompatibleInvalidOptions,
		nonEmptyMeasurementContainerInvalidOptions,
		moreThanOneCompositionInvalidOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && messages,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> Flatten[{
			discardedTest,
			nonLiquidTest,
			resolvedDilutionTests,
			apertureTubeDiameterMismatchTest,
			particleSizeOutOfRangeTest,
			solubleSamplesTest,
			suitabilityParticleSizeOutOfRangeTest,
			conflictingSuitabilityCheckTest,
			suitabilityToleranceTooHighTest,
			suitabilitySizeStandardMismatchTest,
			targetConcentrationNotUsefulTest,
			suitabilityTargetConcentrationNotUsefulTest,
			conflictingSampleLoadingTest,
			measurementContainerTooSmallTest,
			notEnoughMeasurementSampleTest,
			conflictingMixTest,
			minParticleSizeTooLargeTest,
			conflictingStopConditionTest,
			notEnoughElectrolyteSolutionTest,
			invalidNumberOfDynamicOfDilutionsTest,
			conflictingDynamicDilutionTest,
			constantCumulativeDilutionFactorMismatchTest,
			conflictingDilutionOptionsTest,
			dynamicDiluteDilutionStrategyIncompatibleTest,
			nonEmptyMeasurementContainerTest,
			moreThanOneCompositionTest,
			volumeModeRecommendedTest,
			cannotMixMeasurementContainerTest
		}]
	}
];


(* ::Subsubsection:: *)
(*experimentCoulterCountResourcePackets*)

DefineOptions[experimentCoulterCountResourcePackets,
	Options :> {
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

experimentCoulterCountResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myOptions:OptionsPattern[]] := Module[
	{
		safeOps, outputSpecification, output, gatherTests, messages, warnings, cache, simulation, allResourceBlobs, fulfillable, frqTests,
		testsRule, resultRule, protocolPacket, sharedFieldPacket, finalizedPacket, resolvedOptionsNoHidden,
		(* Download *)
		fastCache, samplePackets, suitabilitySizeStandardPackets, expandedSamplePackets, expandedSuitabilitySizeStandardPackets,
		(* Option values *)
		instrument, electrolyteSolution, numbersOfReadings, numbersOfSuitabilityReadings, numberOfReplicates, numberOfSuitabilityReplicates, flushTime, flushFlowRate, runTimes, suitabilityRunTimes,
		runVolumes, suitabilityRunVolumes, flowRates, suitabilityFlowRates, apertureTube, sampleAmounts, suitabilitySampleAmounts, transferVolumes, dilutionTypes, dilutionStrategies,
		suitabilitySizeStandards, measurementContainerResourceLookup, measurementContainers, suitabilityMeasurementContainers, numbersOfDilutions, electrolyteSolutionVolume, electrolyteSampleDilutionVolumes, suitabilityElectrolyteSampleDilutionVolumes,
		mixTimes, suitabilityMixTimes, equilibrationTimes, suitabilityEquilibrationTimes, systemSuitabilityCheck, cumulativeDynamicDilutionFactors, suitabilityCumulativeDynamicDilutionFactors,
		(* Resources *)
		instrumentResource, apertureTubeResource, samplesInResources, suitabilitySizeStandardResources, electrolyteSolutionResource, measurementContainerResources, suitabilityMeasurementContainerResources,
		containersInResources, suitabilityContainersInResources, rinseContainerResource,
		(* Other variables *)
		expandedDilutionStrategies, expandedNumbersOfDilutions, expandedMeasurementContainers, expandedSuitabilityMeasurementContainers, expandedSuitabilitySampleAmounts, expandedSuitabilityElectrolyteSampleDilutionVolumes,
		numberOfTotalFlushes
	},

	(* Get the safe options for this function *)
	safeOps = SafeOptions[experimentCoulterCountResourcePackets, ToList[myOptions]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;
	warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Get cache and simulation helper options *)
	cache = Lookup[safeOps, Cache, {}];
	simulation = Lookup[safeOps, Simulation, Null];

	(* Lookup option values *)
	{
		instrument,
		electrolyteSolution,
		numbersOfReadings,
		numbersOfSuitabilityReadings,
		numberOfReplicates,
		numberOfSuitabilityReplicates,
		flushTime,
		flushFlowRate,
		runTimes,
		suitabilityRunTimes,
		runVolumes,
		suitabilityRunVolumes,
		flowRates,
		suitabilityFlowRates,
		apertureTube,
		sampleAmounts,
		suitabilitySampleAmounts,
		transferVolumes,
		dilutionTypes,
		dilutionStrategies,
		suitabilitySizeStandards,
		measurementContainers,
		suitabilityMeasurementContainers,
		numbersOfDilutions,
		electrolyteSolutionVolume,
		electrolyteSampleDilutionVolumes,
		suitabilityElectrolyteSampleDilutionVolumes,
		mixTimes,
		suitabilityMixTimes,
		equilibrationTimes,
		suitabilityEquilibrationTimes,
		systemSuitabilityCheck,
		cumulativeDynamicDilutionFactors,
		suitabilityCumulativeDynamicDilutionFactors
	} = Lookup[
		myResolvedOptions,
		{
			Instrument,
			ElectrolyteSolution,
			NumberOfReadings,
			NumberOfSuitabilityReadings,
			NumberOfReplicates,
			NumberOfSuitabilityReplicates,
			FlushTime,
			FlushFlowRate,
			RunTime,
			SuitabilityRunTime,
			RunVolume,
			SuitabilityRunVolume,
			FlowRate,
			SuitabilityFlowRate,
			ApertureTube,
			SampleAmount,
			SuitabilitySampleAmount,
			TransferVolume,
			DilutionType,
			DilutionStrategy,
			SuitabilitySizeStandard,
			MeasurementContainer,
			SuitabilityMeasurementContainer,
			NumberOfDilutions,
			ElectrolyteSolutionVolume,
			ElectrolyteSampleDilutionVolume,
			SuitabilityElectrolyteSampleDilutionVolume,
			MixTime,
			SuitabilityMixTime,
			EquilibrationTime,
			SuitabilityEquilibrationTime,
			SystemSuitabilityCheck,
			CumulativeDynamicDilutionFactor,
			SuitabilityCumulativeDynamicDilutionFactor
		}
	];

	fastCache = makeFastAssocFromCache[cache];

	(* Set up some commonly used packets *)
	(* Replacing Null with <||> so packets we fetch are immune to Lookup::invrl error *)
	samplePackets = fetchPacketFromFastAssoc[#, fastCache]& /@ mySamples;
	suitabilitySizeStandardPackets = Replace[fetchPacketFromFastAssoc[#, fastCache]& /@ ToList[suitabilitySizeStandards], NullP -> <||>, {1}];

	(* Expand the sample packets and suitability size standard packets and some option values according to NumberOfReplicates *)
	{
		expandedSamplePackets,
		expandedDilutionStrategies,
		expandedNumbersOfDilutions,
		expandedMeasurementContainers,
		expandedSuitabilitySizeStandardPackets,
		expandedSuitabilityMeasurementContainers,
		expandedSuitabilitySampleAmounts,
		expandedSuitabilityElectrolyteSampleDilutionVolumes
	} = MapThread[
		Function[
			{valuesToExpand, numberOfReplicates},
			expandForNumberOfReplicates[valuesToExpand, numberOfReplicates]
		],
		{
			{
				samplePackets,
				dilutionStrategies,
				numbersOfDilutions,
				measurementContainers,
				suitabilitySizeStandardPackets,
				suitabilityMeasurementContainers,
				suitabilitySampleAmounts,
				suitabilityElectrolyteSampleDilutionVolumes
			},
			{
				numberOfReplicates,
				numberOfReplicates,
				numberOfReplicates,
				numberOfReplicates,
				numberOfSuitabilityReplicates,
				numberOfSuitabilityReplicates,
				numberOfSuitabilityReplicates,
				numberOfSuitabilityReplicates
			}
		}
	];

	(* Estimate the number of total flushes first *)
	(* One flush before and after switching samples, and in between readings *)
	(* Flushing -> Load sample 1 -> Flushing -> Reading 1 -> Flushing -> Reading 2 -> Flushing -> Switch to sample 2 -> Flushing -> Reading 1 -> Flushing -> ... *)
	(* DilutionStrategy->Series indicates that we are using all dilution samples as extra measurement samples, so numberOfTotalFlushes goes up, If[MatchQ[#3,Series],#4-1,0] takes care of this *)
	numberOfTotalFlushes = Total[
		MapThread[
			Function[{numberOfReadings, numberOfReplicates, dilutionStrategy, numberOfDilutions, measurementQ},
				If[TrueQ[measurementQ],
					(If[NullQ[numberOfReadings], 1, numberOfReadings] + 1) * (
						If[!NullQ[numberOfReplicates], numberOfReplicates, 1] + 1 + If[MatchQ[dilutionStrategy, Series], numberOfDilutions - 1, 0]
					),
					0
				]
			],
			{
				Join[numbersOfReadings, numbersOfSuitabilityReadings],
				Join[ConstantArray[numberOfReplicates, Length[mySamples]], ConstantArray[numberOfSuitabilityReplicates, Length[ToList[suitabilitySizeStandards]]]],
				Join[dilutionStrategies, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
				Join[numbersOfDilutions, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
				Join[ConstantArray[True, Length[mySamples]], ConstantArray[systemSuitabilityCheck, Length[ToList[suitabilitySizeStandards]]]]
			}
		]
	] + 1;

	(* Make the Instrument Resource *)
	instrumentResource = Module[{initializationTime, postMeasurementTime, totalFlushTime, totalMeasurementTime, totalInstrumentTime},
		(* --- Initialization includes powering on the instrument, fill the ElectrolyteSolutionContainer, software startup, 15 min stabilization, installing the aperture tube --- *)
		initializationTime = 25 Minute;
		(* --- Total flush time --- *)
		(* Calculate total flush time, each single FlushTime is an option that we have resolved *)
		totalFlushTime = numberOfTotalFlushes * flushTime;
		(* --- Total measurement time --- *)
		(* Measurement includes: sample runs as in numberOfReadings, numberOfReplicates, blank measurement, and any preMeasurement mixing and equilibration time *)
		(* Note that blank happens after switching sample and flushing, sequence goes: *)
		(* install aperture tube -> flushing -> blank -> sample 1 reading 1 -> flushing -> (switching sample now) -> flushing -> blank -> sample 2 ... *)
		(* Loop the calculation through all input and suitability samples *)
		(* We should also take account of DilutionStrategy->Series here *)
		totalMeasurementTime = estimateTotalMeasurementTime[
			Join[runTimes, suitabilityRunTimes],
			Join[mixTimes, suitabilityMixTimes],
			Join[equilibrationTimes, suitabilityEquilibrationTimes],
			Join[runVolumes, suitabilityRunVolumes],
			Join[flowRates, suitabilityFlowRates],
			Join[numbersOfReadings, numbersOfSuitabilityReadings],
			Join[ConstantArray[numberOfReplicates, Length[mySamples]], ConstantArray[numberOfSuitabilityReplicates, Length[ToList[suitabilitySizeStandards]]]],
			Join[dilutionStrategies, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
			Join[numbersOfDilutions, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
			Join[ConstantArray[True, Length[mySamples]], ConstantArray[systemSuitabilityCheck, Length[ToList[suitabilitySizeStandards]]]]
		];
		(* --- Post measurement time: empty the WasteContainer and ElectrolyteSolutionContainer, uninstall the aperture tube, close software --- *)
		postMeasurementTime = 10 Minute;
		(* Get the total instrument time we need *)
		totalInstrumentTime = Plus[
			initializationTime,
			totalFlushTime,
			totalMeasurementTime,
			postMeasurementTime
		];
		(* Make the resource *)
		Link[Resource[Instrument -> instrument, Time -> totalInstrumentTime]]
	];

	(* Make the ApertureTube Resource *)
	(* ApertureTube is not self standing, and we dont have a special rack for it, so just using a beaker to hold it for now *)
	apertureTubeResource = Link[Resource[Sample -> apertureTube, Rent -> True]];

	(* Make the SamplesIn and SuitabilitySizeStandard Resources *)
	{samplesInResources, suitabilitySizeStandardResources} = Module[
		{
			expandedSampleAmounts, expandedTransferVolumes, expandedDilutionTypes,
			allSampleAmountsRequired, pairedAllSampleAndAmounts, allSampleToAmountRules, allSampleResourceRules
		},
		(* Need to expand these option values first for NumberOfReplicates *)
		{
			expandedSampleAmounts,
			expandedTransferVolumes,
			expandedDilutionTypes
		} = Map[
			expandForNumberOfReplicates[#, numberOfReplicates]&,
			{
				sampleAmounts,
				transferVolumes,
				dilutionTypes
			}
		];
		(* Calculate the total amount that we need for each input and suitability sample *)
		allSampleAmountsRequired = MapThread[
			Function[{sampleAmount, transferVolume, dilutionType, numberOfReplicates},
				Which[
					(* If we are doing a linear dilution - need the sum of all the transfer volumes *)
					(* We are doing a back division here b/c we only need to do one dilution for all replicates, then split during sample loading *)
					MatchQ[dilutionType, Linear],
					Total[transferVolume] / If[NullQ[numberOfReplicates], 1, numberOfReplicates],
					(* If we are doing a serial dilution - only need the first TransferVolume *)
					(* We are doing a back division here b/c we only need to do one dilution for all replicates, then split during sample loading *)
					MatchQ[dilutionType, Serial],
					First[transferVolume] / If[NullQ[numberOfReplicates], 1, numberOfReplicates],
					(* Otherwise set to SampleAmount *)
					MatchQ[sampleAmount, VolumeP | MassP],
					sampleAmount,
					(* Otherwise default to Null *)
					True,
					Null
				]
			],
			{
				Join[expandedSampleAmounts, expandedSuitabilitySampleAmounts],
				Join[expandedTransferVolumes, ConstantArray[Null, Length[expandedSuitabilitySizeStandardPackets]]],
				Join[expandedDilutionTypes, ConstantArray[Null, Length[expandedSuitabilitySizeStandardPackets]]],
				Join[ConstantArray[numberOfReplicates, Length[expandedSamplePackets]], ConstantArray[numberOfSuitabilityReplicates, Length[expandedSuitabilitySizeStandardPackets]]]
			}
		];
		(* Pair up each sample with its volume *)
		(* Note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
		pairedAllSampleAndAmounts = MapThread[
			#1 -> #2&,
			{
				Lookup[Join[expandedSamplePackets, expandedSuitabilitySizeStandardPackets], Object, Null],
				allSampleAmountsRequired
			}
		];
		(* Merge the samples volumes together to get the total volume of each sample's resource *)
		(* Need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
		allSampleToAmountRules = Merge[pairedAllSampleAndAmounts, If[NullQ[#], Null, Total[DeleteCases[#, NullP]]]&];
		(* Make replace rules for the samples and its resources *)
		allSampleResourceRules = KeyValueMap[
			Function[{sample, amount},
				(* Take the Null cases here b/c suitability samples could be Null *)
				Which[
					MatchQ[{sample, amount}, {ObjectP[], NullP}],
					sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
					MatchQ[{sample, amount}, {ObjectP[], VolumeP | MassP}],
					sample -> Resource[Sample -> sample, Name -> CreateUUID[], Amount -> amount],
					True,
					Null -> Null
				]
			],
			allSampleToAmountRules
		];
		(* Make the SamplesIn and SuitabilitySizeStandard Resources *)
		{
			Replace[Lookup[samplePackets, Object, Null], allSampleResourceRules, {1}],
			Replace[Lookup[expandedSuitabilitySizeStandardPackets, Object, Null], allSampleResourceRules, {1}]
		}
	];

	(* Make the ContainersIn Resource for input and suitability samples *)
	{containersInResources, suitabilityContainersInResources} = Module[{sampleContainers, suitabilityContainers},
		(* Find all unique containers *)
		sampleContainers = DeleteDuplicates[Download[Lookup[samplePackets, Container, Null], Object]];
		suitabilityContainers = DeleteDuplicates[Download[Lookup[suitabilitySizeStandardPackets, Container, Null], Object]];
		(* Make resources *)
		{
			If[NullQ[#], #, Resource[Sample -> #, Name -> ToString[#]]]& /@ sampleContainers,
			If[NullQ[#], #, Resource[Sample -> #, Name -> ToString[#]]]& /@ suitabilityContainers
		}
	];

	(* Make MeasurementContainer and SuitabilityMeasurementContainer Resources *)
	(* We are going to make one unique resource per unique model/object - since each container will get washed during procedure *)
	(* Note that we do not need to worry a case where sample is already in a MS4e compatible container here - we have handled that situation in option resolver so just pick resources here *)
	measurementContainerResourceLookup = Module[{uniqueMeasurementContainers},
		(* find all unique container model/objects *)
		uniqueMeasurementContainers = DeleteDuplicates[Download[Flatten[{measurementContainers, suitabilityMeasurementContainers}], Object]];
		(* For each of the unique container or model, create a resource *)
		If[MatchQ[#, ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]],
			# -> Link[Resource[Sample -> #, Name -> CreateUUID[], Rent -> True]],
			(* Skip for Null case *)
			# -> Null
		]& /@ uniqueMeasurementContainers
	];

	(* We need to account for DilutionStrategy->Series case here, DilutionStrategy->Series indicates that we are using all dilution samples as extra measurement samples *)
	(* Number of samples to be measured effectively goes up, so we would need to make a resource for each of those measurement samples *)
	measurementContainerResources = Download[expandForNumberOfReplicatesAndDilutions[measurementContainers, numberOfReplicates, dilutionStrategies, numbersOfDilutions], Object] /. measurementContainerResourceLookup;
	(* For SuitabilityMeasurementContainers, just need to expand according to NumberOfSuitabilityReplicates *)
	suitabilityMeasurementContainerResources = Download[expandedSuitabilityMeasurementContainers, Object] /. measurementContainerResourceLookup;

	(* Make the ElectrolyteSolution Resource *)
	(* We need electrolyte solution in a few places: *)
	(* --- to fill the ElectrolyteSolutionContainer with ElectrolyteSolutionVolume --- *)
	(* --- to prepare sample in either dilution step or sample loading step --- *)
	(* --- to prepare blank sample --- *)
	electrolyteSolutionResource = Module[
		{
			expandedElectrolyteSampleDilutionVolumes, totalFlushVolumeRequired,
			totalSampleLoadingVolumeRequired, totalBlankVolumeRequired, totalElectrolyteSolutionVolume, totalDynamicDilutionVolumeRequired
		},
		(* Need to expand these option values first for NumberOfReplicates *)
		expandedElectrolyteSampleDilutionVolumes = expandForNumberOfReplicates[electrolyteSampleDilutionVolumes, numberOfReplicates];
		(* --- Flush volume needed, this is the amount added to ElectrolyteSolutionContainer in instrument --- *)
		(* The amount that needs to be added to the electrolyte container is the number of total flushes times the volume consumed for each flushing plus a dead volume of 50 Milliliter *)
		(* Using a Max[...] here so we ensure we always have enough volume to fill in ElectrolyteSolutionContainer for flushing *)
		totalFlushVolumeRequired = Max[
			numberOfTotalFlushes * flushTime * flushFlowRate + 50 Milliliter,
			electrolyteSolutionVolume
		];
		(* --- Sample preparation, for ElectrolyteSampleDilutionVolume of input and suitability samples --- *)
		totalSampleLoadingVolumeRequired = Total[MapThread[
			Function[{electrolyteSampleDilutionVolume, dilutionStrategy, numberOfDilutions},
				Times[
					If[MatchQ[dilutionStrategy, Series], numberOfDilutions, 1],
					If[MatchQ[electrolyteSampleDilutionVolume, VolumeP], electrolyteSampleDilutionVolume, 0 Liter]
				]
			],
			{
				Join[expandedElectrolyteSampleDilutionVolumes, expandedSuitabilityElectrolyteSampleDilutionVolumes],
				Join[expandedDilutionStrategies, ConstantArray[Null, Length[expandedSuitabilityElectrolyteSampleDilutionVolumes]]],
				Join[expandedNumbersOfDilutions, ConstantArray[Null, Length[expandedSuitabilityElectrolyteSampleDilutionVolumes]]]
			}
		]];
		(* --- Blank sample preparation --- *)
		totalBlankVolumeRequired = Total[MapThread[
			Function[{measurementContainer, dilutionStrategy, numberOfDilutions},
				Times[
					If[MatchQ[dilutionStrategy, Series], numberOfDilutions, 1],
					(* We prepare the blank sample by using the same container with 40 percent filled with ElectrolyteSolution *)
					Switch[measurementContainer,
						ObjectP[Object[Container, Vessel]],
						fastAssocLookup[fastCache, measurementContainer, {Model, MaxVolume}],
						ObjectP[Model[Container, Vessel]],
						fastAssocLookup[fastCache, measurementContainer, MaxVolume],
						_,
						0 Liter
					],
					0.4
				]
			],
			{
				Join[expandedMeasurementContainers, expandedSuitabilityMeasurementContainers],
				Join[expandedDilutionStrategies, ConstantArray[Null, Length[expandedSuitabilityElectrolyteSampleDilutionVolumes]]],
				Join[expandedNumbersOfDilutions, ConstantArray[Null, Length[expandedSuitabilityElectrolyteSampleDilutionVolumes]]]
			}
		]];
		(* --- Estimate the amount needed for DynamicDilute --- *)
		totalDynamicDilutionVolumeRequired = Total[MapThread[
			Function[{dynamicDilute, equilibrationTime, runTime, flowRate, runVolume, numberOfReadings, sampleAmount, electrolyteSampleDilutionVolume, cumulativeDynamicDilutionFactor, numberOfReplicates, dilutionStrategy, numberOfDilutions, measurementQ},
				If[TrueQ[measurementQ] && TrueQ[dynamicDilute],
					(* Only calculate dynamic dilution volume if we are doing a measurement and dynamic dilute master switch is set to True *)
					Module[{measurementVolume, pairedDilutionFactors, serialDilutionFactors, maxDynamicDilutionVolumeList},
						(* Estimate what amount is to be used for measurement from this sample *)
						measurementVolume = Which[
							(* If RunVolume is specified set to RunVolume *)
							MatchQ[runVolume, VolumeP],
							runVolume,
							(* If FlowRate is specified, set to flow rate multiplies time *)
							(* Default minimum here is that measurement should be able to at least run 30 Second *)
							MatchQ[flowRate, FlowRateP],
							flowRate * (If[MatchQ[runTime, TimeP], runTime, 20 Second] + equilibrationTime)
						];
						(* Find out the serial dilution factor that we are doing for dynamic dilution given a list of cumulative dilution factors eg {1,10,20,40,80} *)
						(* Partition the list of cumulative dilution factors into pairs of adjacent elements *)
						(* This is to get a list of {{10,1},{20,10},{40,20},{80,40}} *)
						pairedDilutionFactors = Reverse /@ Partition[cumulativeDynamicDilutionFactor, 2, 1];
						(* Do the division to get the serial dilution factor for each pair *)
						(* @@@ to replace head of paired list so we can do division directly *)
						serialDilutionFactors = Divide @@@ pairedDilutionFactors;
						(* Calculate how much volume we need to fullfil dynamic dilution *)
						maxDynamicDilutionVolumeList = Module[{totalDilutionVolumeSingleStep},
							(* Calculate total dilution volume to make after each dynamic dilution *)
							(* Default way of doing dynamic dilution is if we are diluting by X times, take 1/X of the sample that is left and add electrolyte solution *)
							(* This way we keep the total volume constant after each dynamic dilution *)
							(* Or max it to make sure we have enough samples for measurements *)
							totalDilutionVolumeSingleStep = Max[
								sampleAmount + electrolyteSampleDilutionVolume,
								2 * measurementVolume * If[NullQ[numberOfReadings], 2, numberOfReadings + 1]
							];
							(* Calculate the volume of electrolyte solution needed based on total dilution volume and dilution factor *)
							(* (electrolyteSolutionVolume + sampleAmount) / sampleAmount = dilutionFactor *)
							(* electrolyteSolutionVolume + sampleAmount = totalDilutionVolume *)
							totalDilutionVolumeSingleStep * (serialDilutionFactors - 1) / serialDilutionFactors
						];
						(* We need to take consideration of expanding according to NumberOfDilutions and NumberOfReplicates here too *)
						Times[
							Total[maxDynamicDilutionVolumeList],
							If[NullQ[numberOfReplicates], 1, numberOfReplicates],
							If[MatchQ[dilutionStrategy, Series], numberOfDilutions, 1]
						]
					],
					0 Milliliter
				]
			],
			{
				Join @@ Lookup[myResolvedOptions, {DynamicDilute, SuitabilityDynamicDilute}],
				Join @@ Lookup[myResolvedOptions, {EquilibrationTime, SuitabilityEquilibrationTime}],
				Join[runTimes, suitabilityRunTimes],
				Join[flowRates, suitabilityFlowRates],
				Join[runVolumes, suitabilityRunVolumes],
				Join[numbersOfReadings, numbersOfSuitabilityReadings],
				Join[sampleAmounts, suitabilitySampleAmounts],
				Join[electrolyteSampleDilutionVolumes, suitabilityElectrolyteSampleDilutionVolumes],
				Join[cumulativeDynamicDilutionFactors, suitabilityCumulativeDynamicDilutionFactors],
				Join[ConstantArray[numberOfReplicates, Length[mySamples]], ConstantArray[numberOfSuitabilityReplicates, Length[ToList[suitabilitySizeStandards]]]],
				Join[dilutionStrategies, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
				Join[numbersOfDilutions, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
				Join[ConstantArray[True, Length[mySamples]], ConstantArray[systemSuitabilityCheck, Length[ToList[suitabilitySizeStandards]]]]
			}
		]];
		(* Total volume we need *)
		totalElectrolyteSolutionVolume = Plus[
			totalFlushVolumeRequired,
			totalSampleLoadingVolumeRequired,
			totalBlankVolumeRequired,
			totalDynamicDilutionVolumeRequired
		];
		(* Make the resource *)
		Link[Resource[Sample -> electrolyteSolution, Amount -> totalElectrolyteSolutionVolume]]
	];

	(* Collapse the options and remove hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentCoulterCount,
		RemoveHiddenOptions[ExperimentCoulterCount, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Make some resources for rinsing aperture tube in between switching sample *)
	(* Model[Container, Vessel, "100mL Pyrex Beaker"] *)
	rinseContainerResource = Link[Resource[Sample -> Model[Container, Vessel, "id:aXRlGnZmOOJk"], Rent -> True]];

	(* Make the protocol packet including resources *)
	protocolPacket = Module[
		{
			expandedSuitabilityParticleSizes, expandedSuitabilityTargetConcentrations, expandedSuitabilityDynamicDilutes, expandedSuitabilityConstantDynamicDilutionFactors, expandedSuitabilityCumulativeDynamicDilutionFactors, expandedSuitabilityElectrolytePercentages,
			expandedSuitabilityMaxNumberOfDynamicDilutions, expandedSuitabilityMixRates, expandedSuitabilityMixDirections, expandedSuitabilityApertureCurrents, expandedSuitabilityGains,
			expandedMinSuitabilityParticleSizes, expandedSuitabilityMixTimes, expandedNumbersOfSuitabilityReadings, expandedSuitabilityFlowRates, expandedSuitabilityEquilibrationTimes, expandedSuitabilityNulls,
			expandedQuantifyConcentrations, expandedElectrolytePercentages, expandedDynamicDilutes, expandedConstantDynamicDilutionFactors, expandedCumulativeDynamicDilutionFactors, expandedMaxNumberOfDynamicDilutions,
			expandedMixRates, expandedMixDirections, expandedMinParticleSizes, expandedSampleAmounts, expandedElectrolyteSampleDilutionVolumes, expandedApertureCurrents, expandedGains, expandedNulls,
			expandedMixTimes, expandedNumbersOfReadings, expandedFlowRates, expandedEquilibrationTimes, checkpoints
		},
		(* These suitability options need to be expanded according to NumberOfSuitabilityReplicates *)
		{
			expandedSuitabilityParticleSizes,
			expandedSuitabilityTargetConcentrations,
			expandedSuitabilityDynamicDilutes,
			expandedSuitabilityConstantDynamicDilutionFactors,
			expandedSuitabilityMaxNumberOfDynamicDilutions,
			expandedSuitabilityMixRates,
			expandedSuitabilityMixDirections,
			expandedMinSuitabilityParticleSizes,
			expandedSuitabilityElectrolytePercentages,
			expandedSuitabilityApertureCurrents,
			expandedSuitabilityGains,
			expandedSuitabilityMixTimes,
			expandedNumbersOfSuitabilityReadings,
			expandedSuitabilityFlowRates,
			expandedSuitabilityEquilibrationTimes,
			expandedSuitabilityCumulativeDynamicDilutionFactors,
			expandedSuitabilityNulls
		} = Map[
			expandForNumberOfReplicates[#, numberOfSuitabilityReplicates]&,
			Join[
				Lookup[myResolvedOptions,
					{
						SuitabilityParticleSize,
						SuitabilityTargetConcentration,
						SuitabilityDynamicDilute,
						SuitabilityConstantDynamicDilutionFactor,
						SuitabilityMaxNumberOfDynamicDilutions,
						SuitabilityMixRate,
						SuitabilityMixDirection,
						MinSuitabilityParticleSize,
						SuitabilityElectrolytePercentage,
						SuitabilityApertureCurrent,
						SuitabilityGain
					}
				],
				{
					suitabilityMixTimes,
					numbersOfSuitabilityReadings,
					suitabilityFlowRates,
					suitabilityEquilibrationTimes,
					suitabilityCumulativeDynamicDilutionFactors,
					ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]
				}
			]
		];
		(* These options need to be expanded according to NumberOfReplicates and NumberOfDilutions *)
		{
			expandedQuantifyConcentrations,
			expandedElectrolytePercentages,
			expandedDynamicDilutes,
			expandedConstantDynamicDilutionFactors,
			expandedCumulativeDynamicDilutionFactors,
			expandedMaxNumberOfDynamicDilutions,
			expandedMixRates,
			expandedMixDirections,
			expandedMinParticleSizes,
			expandedApertureCurrents,
			expandedGains,
			expandedSampleAmounts,
			expandedElectrolyteSampleDilutionVolumes,
			expandedMixTimes,
			expandedNumbersOfReadings,
			expandedFlowRates,
			expandedEquilibrationTimes,
			expandedNulls
		} = Map[
			expandForNumberOfReplicatesAndDilutions[#, numberOfReplicates, dilutionStrategies, numbersOfDilutions]&,
			Join[
				Lookup[myResolvedOptions,
					{
						QuantifyConcentration,
						ElectrolytePercentage,
						DynamicDilute,
						ConstantDynamicDilutionFactor,
						CumulativeDynamicDilutionFactor,
						MaxNumberOfDynamicDilutions,
						MixRate,
						MixDirection,
						MinParticleSize,
						ApertureCurrent,
						Gain
					}
				],
				{
					sampleAmounts,
					electrolyteSampleDilutionVolumes,
					mixTimes,
					numbersOfReadings,
					flowRates,
					equilibrationTimes,
					ConstantArray[Null, Length[mySamples]]
				}
			]
		];
		(* Estimate checkpoints *)
		checkpoints = Module[{sampleDilutionTime, sampleLoadingTime, suitabilityCheckTime, sampleMeasurementTime},
			(* estimate total time for system suitability check *)
			suitabilityCheckTime = If[systemSuitabilityCheck,
				Plus[
					estimateTotalMeasurementTime[
						suitabilityRunTimes,
						suitabilityMixTimes,
						suitabilityEquilibrationTimes,
						suitabilityRunVolumes,
						suitabilityFlowRates,
						numbersOfSuitabilityReadings,
						ConstantArray[numberOfSuitabilityReplicates, Length[ToList[suitabilitySizeStandards]]],
						ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]],
						ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]],
						ConstantArray[systemSuitabilityCheck, Length[ToList[suitabilitySizeStandards]]]
					],
					10 * Minute (* data collection and analysis time *)
				],
				0 Minute
			];
			(* estimate total time for all sample dilutions and dynamic dilutions *)
			sampleDilutionTime = Total[Flatten@MapThread[
				Function[{numberOfDilutions, maxNumberOfDynamicDilutions},
					Plus[
						If[NullQ[numberOfDilutions], 0, numberOfDilutions],
						If[NullQ[maxNumberOfDynamicDilutions], 0, maxNumberOfDynamicDilutions]
					] * 5 Minute
				],
				{
					Join[numbersOfDilutions, ConstantArray[Null, Length[ToList[suitabilitySizeStandards]]]],
					Join @@ Lookup[myResolvedOptions, {MaxNumberOfDynamicDilutions, SuitabilityMaxNumberOfDynamicDilutions}]
				}
			]];
			(* estimate total time to mix sample with electrolyte solution for making the suspension *)
			sampleLoadingTime = Module[{sampleLoading, suitabilitySampleLoading},
				sampleLoading = If[NullQ[numberOfReplicates], 1, numberOfReplicates] * Length[mySamples] * 2 * Minute;
				suitabilitySampleLoading = If[systemSuitabilityCheck,
					If[NullQ[numberOfSuitabilityReplicates], 1, numberOfSuitabilityReplicates] * Length[ToList[suitabilitySizeStandards]] * 2 * Minute,
					0 Minute
				];
				sampleLoading + suitabilitySampleLoading
			];
			(* estimate total time to measure all samples *)
			sampleMeasurementTime = estimateTotalMeasurementTime[
				runTimes,
				mixTimes,
				equilibrationTimes,
				runVolumes,
				flowRates,
				numbersOfReadings,
				ConstantArray[numberOfReplicates, Length[mySamples]],
				dilutionStrategies,
				numbersOfDilutions,
				ConstantArray[True, Length[mySamples]]
			];
			{
				{"Preparing Samples", 1 * Hour, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 * Hour]]},
				{"Picking Resources", 10 * Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 * Minute]]},
				{"Preparing Instrument", 25 * Minute, "Instrument warm up, fill ElectrolyteContainer, aperture tube installation.", Link[Resource[Operator -> $BaselineOperator, Time -> 25 * Minute]]},
				{"Checking System Suitability", suitabilityCheckTime, "Run SuitabilitySizeStandard samples and system suitability analysis.", Link[Resource[Operator -> $BaselineOperator, Time -> suitabilityCheckTime]]},
				{"Diluting Samples", sampleDilutionTime, "Samples and standards diluted and mixed, as required by Dilute, DynamicDilute, or SuitabilityDynamicDilute.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 3"], Time -> sampleDilutionTime]]},
				{"Measuring Particle Sizes", sampleLoadingTime + sampleMeasurementTime, "Measuring particle sizes of each sample/diluted sample one by one.", Link[Resource[Operator -> $BaselineOperator, Time -> (sampleLoadingTime + sampleMeasurementTime)]]},
				{"Returning Materials", 20 * Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Resource[Operator -> $BaselineOperator, Time -> 20 * Minute]}
			}
		];
		(* Now make the packet *)
		Association[
			Object -> CreateID[Object[Protocol, CoulterCount]],
			(* Protocol *)
			(* SamplesIn have all samples expanded for NumberOfReplicates *)
			Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
			(* New samples have all samples expanded for NumberOfReplicates and then, in the inner list, NumberOfDilutions *)
			Replace[ContainersIn] -> (Link[#, Protocols]& /@ containersInResources),
			UnresolvedOptions -> myUnresolvedOptions,
			ResolvedOptions -> resolvedOptionsNoHidden,
			Template -> Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated],
			Operator -> Link[Lookup[myResolvedOptions, Operator]],
			Replace[Checkpoints] -> checkpoints,
			(* General *)
			Instrument -> instrumentResource,
			ApertureTube -> apertureTubeResource,
			ApertureDiameter -> Lookup[myResolvedOptions, ApertureDiameter],
			ElectrolyteSolution -> electrolyteSolutionResource,
			(* Flushing *)
			ElectrolyteSolutionVolume -> electrolyteSolutionVolume,
			FlushFlowRate -> flushFlowRate,
			FlushTime -> flushTime,
			RinseContainer -> rinseContainerResource,
			(* System Suitability Check *)
			(* Suitability Measurement options need to be expanded for NumberOfSuitabilityReplicates *)
			SystemSuitabilityTolerance -> Lookup[myResolvedOptions, SystemSuitabilityTolerance],
			Replace[SuitabilitySizeStandards] -> (Link[#]& /@ suitabilitySizeStandardResources),
			Replace[SuitabilityContainersIn] -> (Link[#]& /@ suitabilityContainersInResources),
			Replace[SuitabilityParticleSizes] -> expandedSuitabilityParticleSizes,
			Replace[SuitabilityTargetConcentrations] -> expandedSuitabilityTargetConcentrations,
			Replace[SuitabilitySampleAmounts] -> expandedSuitabilitySampleAmounts,
			Replace[SuitabilityElectrolyteSampleDilutionVolumes] -> expandedSuitabilityElectrolyteSampleDilutionVolumes,
			Replace[SuitabilityElectrolytePercentages] -> expandedSuitabilityElectrolytePercentages,
			Replace[SuitabilityMeasurementContainers] -> suitabilityMeasurementContainerResources,
			Replace[SuitabilityDynamicDilutes] -> expandedSuitabilityDynamicDilutes,
			Replace[SuitabilityConstantDynamicDilutionFactors] -> expandedSuitabilityConstantDynamicDilutionFactors,
			Replace[SuitabilityCumulativeDynamicDilutionFactors] -> expandedSuitabilityCumulativeDynamicDilutionFactors,
			Replace[SuitabilityMaxNumberOfDynamicDilutions] -> expandedSuitabilityMaxNumberOfDynamicDilutions,
			Replace[SuitabilityMixRates] -> expandedSuitabilityMixRates,
			Replace[SuitabilityMixDirections] -> expandedSuitabilityMixDirections,
			Replace[SuitabilityMixTimes] -> expandedSuitabilityMixTimes,
			Replace[NumberOfSuitabilityReadings] -> expandedNumbersOfSuitabilityReadings,
			NumberOfSuitabilityReplicates -> numberOfSuitabilityReplicates,
			Replace[SuitabilityApertureCurrents] -> expandedSuitabilityApertureCurrents,
			Replace[SuitabilityGains] -> expandedSuitabilityGains,
			Replace[SuitabilityFlowRates] -> expandedSuitabilityFlowRates,
			Replace[MinSuitabilityParticleSizes] -> expandedMinSuitabilityParticleSizes,
			Replace[SuitabilityEquilibrationTimes] -> expandedSuitabilityEquilibrationTimes,
			Replace[SuitabilityStopConditions] -> expandForNumberOfReplicates[
				pairStopConditionWithTargetValues[
					Sequence @@ Lookup[myResolvedOptions, {SuitabilityStopCondition, SuitabilityRunTime, SuitabilityRunVolume, SuitabilityModalCount, SuitabilityTotalCount}]
				],
				numberOfSuitabilityReplicates
			],
			AbortOnSystemSuitabilityCheck -> Lookup[myResolvedOptions, AbortOnSystemSuitabilityCheck],
			(* Sample Dilution *)
			(* These options do not need to be expanded for NumberOfReplicates or NumberOfDilutions b/c NumberOfReplicates happen after sample has been diluted *)
			Replace[DilutionTypes] -> dilutionTypes,
			Replace[DilutionStrategies] -> dilutionStrategies,
			Replace[NumberOfDilutions] -> numbersOfDilutions,
			Replace[TargetAnalytes] -> Link /@ Lookup[myResolvedOptions, TargetAnalyte],
			Replace[CumulativeDilutionFactors] -> Lookup[myResolvedOptions, CumulativeDilutionFactor],
			Replace[SerialDilutionFactors] -> Lookup[myResolvedOptions, SerialDilutionFactor],
			Replace[TransferVolumes] -> Lookup[myResolvedOptions, TransferVolume],
			Replace[TotalDilutionVolumes] -> Lookup[myResolvedOptions, TotalDilutionVolume],
			Replace[FinalVolumes] -> Lookup[myResolvedOptions, FinalVolume],
			Replace[DiscardFinalTransfers] -> Lookup[myResolvedOptions, DiscardFinalTransfer],
			Replace[Diluents] -> Link /@ Lookup[myResolvedOptions, Diluent],
			Replace[DiluentVolumes] -> Lookup[myResolvedOptions, DiluentVolume],
			Replace[DilutionConcentratedBuffers] -> Link /@ Lookup[myResolvedOptions, ConcentratedBuffer],
			Replace[ConcentratedBufferVolumes] -> Lookup[myResolvedOptions, ConcentratedBufferVolume],
			Replace[ConcentratedBufferDiluents] -> Link /@ Lookup[myResolvedOptions, ConcentratedBufferDiluent],
			Replace[ConcentratedBufferDilutionFactors] -> Lookup[myResolvedOptions, ConcentratedBufferDilutionFactor],
			Replace[ConcentratedBufferDiluentVolumes] -> Lookup[myResolvedOptions, ConcentratedBufferDiluentVolume],
			Replace[DilutionIncubationTimes] -> Lookup[myResolvedOptions, DilutionIncubationTime],
			Replace[DilutionIncubationInstruments] -> Link /@ ToList[Lookup[myResolvedOptions, DilutionIncubationInstrument]],
			Replace[DilutionIncubationTemperatures] -> Lookup[myResolvedOptions, DilutionIncubationTemperature],
			Replace[DilutionMixTypes] -> Lookup[myResolvedOptions, DilutionMixType],
			Replace[DilutionNumberOfMixes] -> Lookup[myResolvedOptions, DilutionNumberOfMixes],
			Replace[DilutionMixRates] -> Lookup[myResolvedOptions, DilutionMixRate],
			Replace[DilutionMixOscillationAngles] -> Lookup[myResolvedOptions, DilutionMixOscillationAngle],
			(* Sample Loading *)
			Replace[TargetMeasurementConcentrations] -> Lookup[myResolvedOptions, TargetMeasurementConcentration],
			Replace[SampleAmounts] -> expandedSampleAmounts,
			Replace[ElectrolyteSampleDilutionVolumes] -> expandedElectrolyteSampleDilutionVolumes,
			(* Quantification *)
			Replace[QuantifyConcentrations] -> expandedQuantifyConcentrations,
			(* Have to convert all the percentage that is not in unit of Percent to quantities, otherwise Upload won't be happy about it *)
			Replace[ElectrolytePercentages] -> expandedElectrolytePercentages,
			Replace[MeasurementContainers] -> measurementContainerResources,
			Replace[DynamicDilutes] -> expandedDynamicDilutes,
			Replace[ConstantDynamicDilutionFactors] -> expandedConstantDynamicDilutionFactors,
			Replace[CumulativeDynamicDilutionFactors] -> expandedCumulativeDynamicDilutionFactors,
			Replace[MaxNumberOfDynamicDilutions] -> expandedMaxNumberOfDynamicDilutions,
			Replace[MixRates] -> expandedMixRates,
			Replace[MixDirections] -> expandedMixDirections,
			Replace[MixTimes] -> expandedMixTimes,
			(* Electrical Resistance Measurement *)
			Replace[NumberOfReadings] -> expandedNumbersOfReadings,
			NumberOfReplicates -> numberOfReplicates,
			Replace[ApertureCurrents] -> expandedApertureCurrents,
			Replace[Gains] -> expandedGains,
			Replace[FlowRates] -> expandedFlowRates,
			Replace[MinParticleSizes] -> expandedMinParticleSizes,
			Replace[EquilibrationTimes] -> expandedEquilibrationTimes,
			Replace[StopConditions] -> expandForNumberOfReplicatesAndDilutions[
				pairStopConditionWithTargetValues[
					Sequence @@ Lookup[myResolvedOptions, {StopCondition, RunTime, RunVolume, ModalCount, TotalCount}]
				],
				numberOfReplicates,
				dilutionStrategies,
				numbersOfDilutions
			],
			(* Sample Storage *)
			Replace[SamplesInStorage] -> Lookup[myResolvedOptions, SamplesInStorageCondition],
			(* Post Processing *)
			ImageSample -> Lookup[myResolvedOptions, ImageSample],
			MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
			MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],
			(* Developer Fields used in procedure *)
			Replace[MeasuredSuitabilityParticleSizes] -> expandedSuitabilityNulls,
			Replace[CurrentSuitabilityDynamicDilutionIterations] -> expandedSuitabilityNulls,
			Replace[CurrentSuitabilityDynamicDilutionPrimitives] -> expandedSuitabilityNulls,
			Replace[FinalizedSuitabilityDynamicDilutionPrimitives] -> expandedSuitabilityNulls,
			Replace[SuitabilityOversaturated] -> expandedSuitabilityNulls,
			Replace[CurrentDynamicDilutionIterations] -> expandedNulls,
			Replace[CurrentDynamicDilutionPrimitives] -> expandedNulls,
			Replace[FinalizedDynamicDilutionPrimitives] -> expandedNulls,
			Replace[Oversaturated] -> expandedNulls
		]
	];

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Cache -> cache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> Result, FastTrack -> Lookup[myResolvedOptions, FastTrack], Messages -> messages, Cache -> cache, Simulation -> simulation], Null}
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

(* ::Subsubsection:: *)
(*simulateExperimentCoulterCount*)


DefineOptions[simulateExperimentCoulterCount,
	Options :> {CacheOption, SimulationOption}
];


simulateExperimentCoulterCount[
	myResourcePacket:(PacketP[Object[Protocol, CoulterCount], {Object, ResolvedOptions}] | $Failed | Null),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCoulterCount]
] := Module[
	{
		cache, simulation, fastCache, samplePackets, suitabilitySizeStandardPackets, electrolyteSolutionPacket, protocolObject,
		currentSimulation, samplesInSimulation, suitabilitySizeStandardSimulation, electrolyteSolutionSimulation, simulationWithLabels
	},

	(* Lookup our cache and simulation *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastCache = makeFastAssocFromCache[cache];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol, CoulterCount]],
		Lookup[myResourcePacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = If[MatchQ[myResourcePacket, $Failed],
		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		SimulateResources[
			<|
				Object -> protocolObject,
				Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
				ResolvedOptions -> myResolvedOptions
			|>,
			Cache -> cache,
			Simulation -> simulation
		],
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, CoulterCount]. *)
		SimulateResources[
			myResourcePacket,
			Cache -> cache,
			Simulation -> simulation
		]
	];

	(* Download any information with the simulation on *)
	{
		samplePackets,
		suitabilitySizeStandardPackets,
		electrolyteSolutionPacket
	} = Download[
		protocolObject,
		{
			Packet[SamplesIn[Volume, Mass]],
			Packet[SuitabilitySizeStandards[Volume]],
			Packet[ElectrolyteSolution[Volume]]
		},
		Cache -> cache,
		Simulation -> currentSimulation
	];

	(* --- Any SamplesIn is reduced by the required amount used in this experiment --- *)
	samplesInSimulation = Module[{samplesInResources, samplesInRequiredAmounts, samplesInNewVolumes, samplesInNewMasses},
		(* First/@... to get rid of the Link[...] wrap we added *)
		samplesInResources = First /@ Lookup[myResourcePacket, Replace[SamplesIn]];
		samplesInRequiredAmounts = #[Amount]& /@ samplesInResources;
		(* Calculate the new mass/volume according to the required amount *)
		{samplesInNewVolumes, samplesInNewMasses} = Transpose[MapThread[
			Which[
				(* If we are requiring volume, update volume *)
				MatchQ[{#1, #3}, {VolumeP, VolumeP}],
				(* We are going to use UploadSampleProperties[...] to change volume/mass, setting Null means default *)
				{#1 - #3, Null},
				(* Otherwise if we are requiring mass, update mass *)
				MatchQ[{#2, #3}, {MassP, MassP}],
				{Null, #2 - #3},
				(* Otherwise just default to Null *)
				_,
				{Null, Null}
			]&,
			{Lookup[samplePackets, Volume], Lookup[samplePackets, Mass], samplesInRequiredAmounts}
		]];
		(* Update the volume or mass accordingly *)
		Simulation[UploadSampleProperties[
			mySamples,
			Volume -> samplesInNewVolumes,
			Mass -> samplesInNewMasses,
			Simulation -> currentSimulation,
			Upload -> False
		]]
	];
	(* Update the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, samplesInSimulation];

	(* --- Any suitability sample is reduced by the required amount used in this experiment --- *)
	suitabilitySizeStandardSimulation = If[MatchQ[suitabilitySizeStandardPackets, {PacketP[{Object[Sample], Model[Sample]}]..}],
		Module[{suitabilitySizeStandardResources, suitabilitySizeStandardRequiredAmounts, suitabilitySizeStandardNewVolumes},
			(* First/@... to get rid of the Link[...] wrap we added *)
			suitabilitySizeStandardResources = First /@ Lookup[myResourcePacket, Replace[SuitabilitySizeStandards]];
			suitabilitySizeStandardRequiredAmounts = #[Amount]& /@ suitabilitySizeStandardResources;
			(* We only allow volume for standard sample in the options though *)
			suitabilitySizeStandardNewVolumes = MapThread[
				If[MatchQ[{#1, #2}, {VolumeP, VolumeP}],
					#1 - #2,
					Null
				]&,
				{Lookup[suitabilitySizeStandardPackets, Volume], suitabilitySizeStandardRequiredAmounts}
			];
			(* Update the volume accordingly *)
			Simulation[UploadSampleProperties[
				Lookup[suitabilitySizeStandardPackets, Object],
				Volume -> suitabilitySizeStandardNewVolumes,
				Simulation -> currentSimulation,
				Upload -> False
			]]
		],
		Simulation[]
	];
	(* Update the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, suitabilitySizeStandardSimulation];

	(* --- ElectrolyteSolution is reduced by the required amount used in this experiment --- *)
	electrolyteSolutionSimulation = Module[{electrolyteSolutionResource, electrolyteSolutionRequiredVolume, electrolyteSolutionNewVolume},
		(* First/@... to get rid of the Link[...] wrap we added *)
		electrolyteSolutionResource = First[Lookup[myResourcePacket, ElectrolyteSolution]];
		electrolyteSolutionRequiredVolume = electrolyteSolutionResource[Amount];
		(* Calculate new volumes *)
		electrolyteSolutionNewVolume = If[MatchQ[{Lookup[electrolyteSolutionPacket, Volume], electrolyteSolutionRequiredVolume}, {VolumeP, VolumeP}],
			Lookup[electrolyteSolutionPacket, Volume] - electrolyteSolutionRequiredVolume,
			Null
		];
		(* Update the volume accordingly *)
		Simulation[UploadSampleProperties[
			Lookup[electrolyteSolutionPacket, Object],
			Volume -> electrolyteSolutionNewVolume,
			Simulation -> currentSimulation,
			Upload -> False
		]]
	];
	(* Update the simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, electrolyteSolutionSimulation];

	(* --- Uploaded Labels for unit operations --- *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], Lookup[samplePackets, Object]}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}

];


(* ::Subsection:: *)
(*ExperimentCoulterCountOptions*)


(* ::Subsection:: *)
(*ValidExperimentCoulterCountQ*)



(* ::Subsection:: *)
(*Helper Functions*)


(* ::Subsubsection:: *)
(*convertParticleSizeToDiameter*)
(* Helper function that converts any particle size information stored in the sample/molecule to the unit of diameter *)

convertParticleSizeToDiameter[sizes_, targetUnit:UnitsP[]] := Map[
	Function[size,
		Which[
			(* If any quantity is diameter distribution, get the mean diameter, convert it to target unit *)
			MatchQ[size, DistributionP[Micrometer]],
			N[Convert[Mean[size], targetUnit]],
			(* If any quantity is a volume, convert it to diameter assuming perfect sphere first, then convert the diameter to target unit *)
			MatchQ[size, VolumeP],
			N[Convert[CubeRoot[6 * size] / Pi, targetUnit]],
			(* If any quantity is volume distribution, get the mean volume first then convert it to diameter assuming perfect sphere, then convert the diameter to target unit *)
			MatchQ[size, DistributionP[Micrometer^3]],
			N[Convert[CubeRoot[6 * Mean[size]] / Pi, targetUnit]],
			(* If we have any $Failed in the list, convert it to Null *)
			MatchQ[size, $Failed],
			Null,
			(* In any other cases, if quantity is already a diameter, or Nulls, just convert it to target unit *)
			(* Note that we are not getting rid of any Null|$Failed b/c there's a chance that the input sizeList is index matched to something else and we don't want to destroy that *)
			True,
			N[Convert[size, targetUnit]]
		]
	],
	ToList[sizes]
];


(* ::Subsubsection:: *)
(*extractMaxParticleDiameter*)
(* Given a packet of a model sample or object sample, pull out the largest known particle sizes from its Composition, Solvent, and Media field *)

(* If given a Null packet, return Null *)
extractMaxParticleDiameter[myNullSamplePacket:(Null | <||>), _] := Null;
extractMaxParticleDiameter[mySamplePacket:PacketP[], myFastAssoc_Association] := Module[{sampleModels, sampleModelPackets, allCompositionMolecules, sampleModelCompositionMoleculePackets, allPackets, sampleParticleSizes},
	(* Get objects of its Solvent, Media, and Composition molecules that we should pull particle size information from *)
	sampleModels = Cases[Lookup[mySamplePacket, {Model, Solvent, Media}], ObjectP[]];

	(* Fetch packets of all the models in sample *)
	sampleModelPackets = DeleteDuplicates[fetchPacketFromFastAssoc[#, myFastAssoc]& /@ sampleModels];

	(* Get objects of all Composition molecules *)
	allCompositionMolecules = Cases[Flatten[Lookup[Append[sampleModelPackets, mySamplePacket], Composition]], ObjectP[]];

	(* Fetch packets of all Composition molecules *)
	sampleModelCompositionMoleculePackets = DeleteDuplicates[fetchPacketFromFastAssoc[#, myFastAssoc]& /@ allCompositionMolecules];

	(* Combine all the packets *)
	allPackets = Flatten[{mySamplePacket, sampleModelPackets, sampleModelCompositionMoleculePackets}];

	(* Pull out any known particle sizes from the Composition,Solvent,Media fields *)
	sampleParticleSizes = Cases[
		Flatten[Lookup[allPackets, {ParticleSize, NominalParticleSize, Diameter}, Nothing]],
		VolumeP | DistanceP | DistributionP[]
	];

	(* Call helper to convert particle size information to diameter in unit of Micrometer *)
	(* We really only need to know what is the max particle diameter for each sample *)
	If[MatchQ[sampleParticleSizes, {}],
		Null,
		Max[convertParticleSizeToDiameter[sampleParticleSizes, Micrometer]]
	]
];



(* ::Subsubsection:: *)
(*extractParticleTypes*)
(* Given a packet of a model sample or object sample, pull out any known particle types from its Composition, Solvent, and Media field *)


(* If given a Null packet, return Null *)
extractParticleTypes[myNullSamplePacket:(Null | <||>), _] := Null;
extractParticleTypes[mySamplePacket:PacketP[], myFastAssoc_Association] := Module[{sampleModels, sampleModelPackets, allCompositionMolecules, sampleModelCompositionMoleculePackets, allPackets},
	(* Get objects of its Solvent, Media, and Composition molecules that we should pull particle size information from *)
	sampleModels = Cases[Lookup[mySamplePacket, {Model, Solvent, Media}], ObjectP[]];

	(* Fetch packets of all the models in sample *)
	sampleModelPackets = DeleteDuplicates[fetchPacketFromFastAssoc[#, myFastAssoc]& /@ sampleModels];

	(* Get objects of all Composition molecules *)
	allCompositionMolecules = Cases[Flatten[Lookup[Append[sampleModelPackets, mySamplePacket], Composition]], ObjectP[]];

	(* Fetch packets of all Composition molecules *)
	sampleModelCompositionMoleculePackets = DeleteDuplicates[fetchPacketFromFastAssoc[#, myFastAssoc]& /@ allCompositionMolecules];

	(* Combine all the packets *)
	allPackets = Flatten[{mySamplePacket, sampleModelPackets, sampleModelCompositionMoleculePackets}];

	(* Pull out any known particle types from the Composition,Solvent,Media fields *)
	Cases[Lookup[allPackets, CellType, Nothing], CellTypeP]

];



(* ::Subsubsection:: *)
(*calculateTotalConcentration*)
(* Given a packet, calculate the total particle concentration and convert to target unit *)

calculateTotalConcentration[emptyPacket:Association[], targetUnit:UnitsP[]] := Null;
calculateTotalConcentration[samplePacket:PacketP[{Object[Sample], Model[Sample]}], targetUnit:UnitsP[]] := Module[{compositionModelsWithConcentrations, compositionModelsWithCompatibleConcentrations, compatibleCellModelsWithCellConcentrations, convertedConcentrations},
	(* Find all molecules in a composition that is either in CellConcentration unit, or ParticleConcentration unit with models that are most likely to be particles *)
	compositionModelsWithConcentrations = Cases[Lookup[samplePacket, Composition, {}], {CellConcentrationP | CFUConcentrationP | OD600P | ConcentrationP, ObjectP[$ParticleIdentityModelTypes], _}];

	(* If we did not find any, return $Failed *)
	If[MatchQ[compositionModelsWithConcentrations, {}], Return[$Failed]];

	(* Get the concentrations that are compatible with the target unit *)
	compositionModelsWithCompatibleConcentrations = Cases[compositionModelsWithConcentrations, {_?(CompatibleUnitQ[#, targetUnit]&), __}];

	(* If the target unit is one of the cell concentrations such as OD600, CFU etc, get the concentrations in cell concentration units *)
	(* The reason to extract CellConcentrationP|CFUConcentrationP|OD600P here is b/c these cell units are theoretically interconvertible with a standard curve even though they do not satisfy CompatibleUnitQ[...] *)
	(* eg: OD600 can be converted to Cells/mL if we have a standard curve analysis object stored in the specific cell model - which is what ConvertCellConcentration[...] is doing *)
	compatibleCellModelsWithCellConcentrations = If[MatchQ[targetUnit, CellConcentrationP | CFUConcentrationP | OD600P],
		Cases[Complement[compositionModelsWithConcentrations, compositionModelsWithCompatibleConcentrations], {CellConcentrationP | CFUConcentrationP | OD600P, ObjectP[Model[Cell]], _}],
		{}
	];

	(* Convert all the concentrations to target unit if we can *)
	convertedConcentrations = Cases[
		Join[
			(* --- Convert these naturally compatible units to the target unit --- *)
			Convert[compositionModelsWithCompatibleConcentrations[[All, 1]], targetUnit],
			(* --- Try converting the cell concentrations using ConvertCellConcentration[...] and model.cell information --- *)
			(* It is okay to quiet here b/c ConvertCellConcentration would return $Failed if there's not enough information which will get filtered out by the outermost Cases[...] *)
			(* TODO: add Cache option to ConvertCellConcentration[...] - feature *)
			If[!MatchQ[compatibleCellModelsWithCellConcentrations, {}],
				Quiet[
					ConvertCellConcentration[compatibleCellModelsWithCellConcentrations[[All, 1]], targetUnit, compatibleCellModelsWithCellConcentrations[[All, 2]]],
					Error::NoCompatibleStandardCurveInCellModel
				],
				{}
			]
		],
		UnitsP[targetUnit]
	];

	(* If we do not have any concentration converted to the target unit successfully convert any concentration to the target unit, return $Failed *)
	If[MatchQ[convertedConcentrations, {}],
		$Failed,
		(* If we have some converted values, add them up and return the sum *)
		Total[convertedConcentrations]
	]
];


(* ::Subsubsection:: *)
(*calculateMeasurementConcentration*)
(* Helper function that calculates the measurement concentration based on the sample concentration, and any user-supplied/known sample amount, solvent amount, and optional dilutions *)

(* Need to define these as options instead of arguments b/c we don't know how many options users are supplying to us *)
DefineOptions[calculateMeasurementConcentration,
	Options :> {
		{SampleAmount -> Automatic, Automatic | VolumeP | MassP | Null, "The amount of the prepared sample to be mixed with the electrolyte solution to create a particle suspension."},
		{ElectrolyteSampleDilutionVolume -> Automatic, Automatic | VolumeP | Null, "The amount of the electrolyte solution to be mixed with the prepared sample to create a particle suspension."},
		{ElectrolytePercentage -> Automatic, Automatic | RangeP[0 Percent, 100 Percent] | Null, "The desired ratio of the volume of the electrolyte solution to the total volume in the final sample-electrolyte solution mixture obtained from mixing the prepared sample and the electrolyte solution."}
	}
];

calculateMeasurementConcentration[failedSampleConcentration:$Failed, myOptions:OptionsPattern[]] := $Failed;
calculateMeasurementConcentration[sampleConcentration_?QuantityQ, myOptions:OptionsPattern[]] := Module[
	{safeOps, unresolvedElectrolyteSampleDilutionVolume, unresolvedElectrolytePercentage, resolvedSampleVolume, resolvedElectrolyteSampleDilutionVolume},
	(* We will AutoCorrect here b/c if user ever give us a Null SampleAmount, we'll just Default it to Automatic *)
	safeOps = SafeOptions[calculateMeasurementConcentration, ToList[myOptions]];

	(* We need to figure what SampleAmount and ElectrolyteSampleDilutionVolume is based on any known information - doing a quick option resolver here *)
	(* Pull out unresolved values *)
	{
		unresolvedElectrolyteSampleDilutionVolume,
		unresolvedElectrolytePercentage
	} = Lookup[safeOps,
		{
			ElectrolyteSampleDilutionVolume,
			ElectrolytePercentage
		}
	];

	(* Resolve SampleVolume used to calculate the concentration *)
	resolvedSampleVolume = Which[
		(* If it is a volume quantity, use that *)
		MatchQ[Lookup[safeOps, SampleAmount], VolumeP],
		Lookup[safeOps, SampleAmount],
		(* Otherwise If we known ElectrolyteSampleDilutionVolume and ElectrolytePercentage, SampleAmount can be calculated, use that *)
		(* ElectrolyteSampleDilutionVolume / (SampleAmount + ElectrolyteSampleDilutionVolume) = ElectrolytePercentage *)
		MatchQ[{unresolvedElectrolyteSampleDilutionVolume, unresolvedElectrolytePercentage}, {VolumeP, PercentP}],
		(* If ElectrolytePercentage is not 0 Percent, SampleAmount is calculatable *)
		If[!MatchQ[unresolvedElectrolytePercentage, EqualP[0 Percent]],
			(1 / unresolvedElectrolytePercentage - 1) * unresolvedElectrolyteSampleDilutionVolume,
			(* Otherwise the measurement concentration equals the sample concentration *)
			Return[sampleConcentration]
		],
		(* Otherwise, there is not enough information to proceed, return $Failed *)
		True,
		Return[$Failed]
	];

	(* Resolve ElectrolyteSampleDilutionVolume *)
	resolvedElectrolyteSampleDilutionVolume = Which[
		(* If it is a numeric value good, use that *)
		MatchQ[unresolvedElectrolyteSampleDilutionVolume, VolumeP],
		unresolvedElectrolyteSampleDilutionVolume,
		(* Otherwise if we known SampleAmount and ElectrolytePercentage, ElectrolyteSampleDilutionVolume can be calculated, use that *)
		(* ElectrolyteSampleDilutionVolume / (SampleAmount + ElectrolyteSampleDilutionVolume) = ElectrolytePercentage *)
		MatchQ[unresolvedElectrolytePercentage, PercentP],
		(* If ElectrolytePercentage is not 0 Percent, ESDVolume is calculatable *)
		If[!MatchQ[unresolvedElectrolytePercentage, EqualP[0 Percent]],
			resolvedSampleVolume / (1 / unresolvedElectrolytePercentage - 1),
			(* Otherwise ESDVolume equals 0 mL *)
			0 Milliliter
		],
		(* Otherwise, there is not enough information to proceed, return $Failed *)
		True,
		Return[$Failed]
	];

	(* Calculate the concentration using equation: *)
	(* measurementConcentration = (SampleAmount * sampleConcentration) / (ElectrolyteSampleDilutionVolume + SampleAmount) *)
	resolvedSampleVolume * sampleConcentration / (resolvedElectrolyteSampleDilutionVolume + resolvedSampleVolume)
];




(* ::Subsubsection:: *)
(*resolveCoulterCountMethods*)
(* Resolve the specific Sample Loading and Measurement options - these options appear both in system suitability check and actual sample measurement so we are making a helper here *)
DefineOptions[resolveCoulterCountMeasurementOptions,
	Options :> {
		{
			ApertureDiameter -> 100 * Micrometer,
			UnitsP[Micrometer],
			"The nominal diameter of the aperture that is located in the bottom of the aperture tube, which dictates the accessible size window for particle size measurement used in this protocol."
		},
		{
			DilutionStrategy -> Null,
			NullP | DilutionStrategyP,
			"Indicates if only the final sample (Endpoint) or all diluted samples (Series) produced by serial dilution are used for following electrical resistance measurement. If set to Series, electrical resistance measurement options are automatically expanded to be the same across all diluted samples."
		},
		{
			QuantityFunction -> QuantityFunction[#&, Torr, Microliter / Second],
			_,
			"The standard curve that is used to convert pressure used in MS4e software to flowrate."
		},
		{
			MeasurementContainerFootprint -> Null,
			FootprintP,
			"The packet of the model of the resolved measurement container."
		}
	}
];


resolveCoulterCountMeasurementOptions[
	myOptions_Association,
	ops:OptionsPattern[]
] := Module[
	{
		safeOps, apertureDiameter, dilutionStrategy, specifiedQuantityFun, quantityFun, measurementContainerFootprint,
		resolvedDynamicDilute, resolvedConstantDynamicDilutionFactor, resolvedMaxNumberOfDynamicDilutions, resolvedCumulativeDynamicDilutionFactor,
		resolvedMixRate, resolvedMixTime, resolvedMixDirection, resolvedNumberOfReadings,
		resolvedFlowRate, resolvedMinParticleSize, resolvedEquilibrationTime, resolvedStopCondition, resolvedRunTime, resolvedRunVolume,
		resolvedTotalCount, resolvedModalCount
	},

	(* Get safe options *)
	safeOps = SafeOptions[resolveCoulterCountMeasurementOptions, ToList[ops]];
	(* Pull out necessary information *)
	{apertureDiameter, dilutionStrategy, specifiedQuantityFun, measurementContainerFootprint} = Lookup[safeOps,
		{ApertureDiameter, DilutionStrategy, QuantityFunction, MeasurementContainerFootprint}
	];
	quantityFun = If[MatchQ[specifiedQuantityFun, QuantityFunctionP[Torr, Microliter / Second]], specifiedQuantityFun, QuantityFunction[#&, Torr, Microliter / Second]];

	(* Resolve DynamicDilute *)
	resolvedDynamicDilute = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, DynamicDilute], Except[Automatic]],
		Lookup[myOptions, DynamicDilute],
		(* Otherwise if any of the options {ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions} are not set to Automatic or Null, set to True *)
		MemberQ[Lookup[myOptions, {ConstantDynamicDilutionFactor, CumulativeDynamicDilutionFactor, MaxNumberOfDynamicDilutions}], Except[ListableP[Automatic | Null]]],
		True,
		(* Otherwise set to True *)
		True,
		False
	];

	(* Resolve ConstantDynamicDilutionFactor *)
	resolvedConstantDynamicDilutionFactor = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, ConstantDynamicDilutionFactor], Except[Automatic]],
		Lookup[myOptions, ConstantDynamicDilutionFactor],
		(* Otherwise if CumulativeDynamicDilutionFactor is set *)
		MatchQ[Lookup[myOptions, CumulativeDynamicDilutionFactor], {__?NumericQ}],
		Module[{pairedDilutionFactors, uniqueSerialDilutionFactors},
			(* Partition the list of cumulative dilution factors into pairs of adjacent elements *)
			pairedDilutionFactors = Partition[Reverse[Lookup[myOptions, CumulativeDynamicDilutionFactor]], 2, 1];
			(* Do the division to get the serial dilution factor for each pair *)
			(* Find out if the dilution factor is the same across all dilution steps *)
			uniqueSerialDilutionFactors = DeleteDuplicates[Divide @@@ pairedDilutionFactors];
			(* If the serial dilution factor is constant, set to that value *)
			If[Length[uniqueSerialDilutionFactors] == 1,
				First[uniqueSerialDilutionFactors],
				(* Otherwise set to Null *)
				Null
			]
		],
		(* Otherwise if DynamicDilute is True, set to 2 to do a binary search *)
		TrueQ[resolvedDynamicDilute],
		2,
		(* Otherwise, set to Null *)
		True,
		Null
	];

	(* Resolve MaxNumberOfDynamicDilutions *)
	resolvedMaxNumberOfDynamicDilutions = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, MaxNumberOfDynamicDilutions], Except[Automatic]],
		Lookup[myOptions, MaxNumberOfDynamicDilutions],
		(* Otherwise if CumulativeDynamicDilutionFactor is set, set to the Length of CumulativeDynamicDilutionFactor *)
		MatchQ[Lookup[myOptions, CumulativeDynamicDilutionFactor], {__?NumericQ}],
		Length[Lookup[myOptions, CumulativeDynamicDilutionFactor]],
		(* Otherwise if DynamicDilute is True, set to 3 *)
		TrueQ[resolvedDynamicDilute],
		3,
		(* Otherwise, set to Null *)
		True,
		Null
	];

	(* Resolve CumulativeDynamicDilutionFactor *)
	resolvedCumulativeDynamicDilutionFactor = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, CumulativeDynamicDilutionFactor], Except[Automatic]],
		Lookup[myOptions, CumulativeDynamicDilutionFactor],
		(* Otherwise if ConstantDynamicDilutionFactor and MaxNumberOfDynamicDilutions is set *)
		MatchQ[{resolvedConstantDynamicDilutionFactor, resolvedMaxNumberOfDynamicDilutions}, {_?NumericQ, _?NumericQ}],
		FoldList[Times, resolvedConstantDynamicDilutionFactor, ConstantArray[resolvedConstantDynamicDilutionFactor, resolvedMaxNumberOfDynamicDilutions - 1]],
		(* Otherwise if DynamicDilute is True, set to 3 *)
		TrueQ[resolvedDynamicDilute],
		{2, 4, 8},
		(* Otherwise, set to Null *)
		True,
		Null
	];

	(* Resolve MixRate *)
	resolvedMixRate = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, MixRate], Except[Automatic]],
		Lookup[myOptions, MixRate],
		(* If we are using cuvette, then cannot mix *)
		MatchQ[measurementContainerFootprint, MS4e25mLCuvette],
		Null,
		(* Otherwise if any of MixTime and MixDirection is set to Null, set to Null *)
		And[
			ContainsOnly[Lookup[myOptions, {MixTime, MixDirection}], {NullP, ListableP[Automatic]}, SameTest -> MatchQ],
			MemberQ[Lookup[myOptions, {MixTime, MixDirection}], NullP]
		],
		Null,
		(* Otherwise, set to 20 RPM *)
		True,
		20 * RPM
	];

	(* Resolve MixTime *)
	resolvedMixTime = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, MixTime], Except[Automatic]],
		Lookup[myOptions, MixTime],
		(* If MixRate is set to greater than 0*RPM, then we are mixing, set to 2 Minute *)
		MatchQ[resolvedMixRate, GreaterP[0 * RPM]],
		2 * Minute,
		(* In all other cases, set it to Null *)
		True,
		Null
	];

	(* Resolve MixDirection *)
	resolvedMixDirection = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, MixDirection], Except[Automatic]],
		Lookup[myOptions, MixDirection],
		(* If MixRate is set to greater than 0*RPM, then we are mixing, set to Clockwise *)
		MatchQ[resolvedMixRate, GreaterP[0 * RPM]],
		Clockwise,
		(* In all other cases, set it to Null *)
		True,
		Null
	];

	(* Resolve NumberOfReadings *)
	resolvedNumberOfReadings = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, NumberOfReadings], Except[Automatic]],
		Lookup[myOptions, NumberOfReadings],
		(* Otherwise, set to 1 *)
		True,
		1
	];

	(* Resolve FlowRate *)
	resolvedFlowRate = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, FlowRate], Except[Automatic]],
		Lookup[myOptions, FlowRate],
		(* Otherwise if the aperture diameter is greater than 560 Micrometer, resolve the result based on the aperture diameter, and electrolyte solution *)
		MatchQ[apertureDiameter, GreaterP[560 Micrometer]],
		quantityFun[3 * Torr],
		(* Otherwise always set to 50 Microliter/Second *)
		True,
		quantityFun[6 * Torr]
	];

	(* Resolve MinParticleSize *)
	resolvedMinParticleSize = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, MinParticleSize], Except[Automatic]],
		Lookup[myOptions, MinParticleSize],
		(* Otherwise, set to 2.1% of the aperture diameter *)
		True,
		0.021 * apertureDiameter
	];

	(* Resolve EquilibrationTime *)
	resolvedEquilibrationTime = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, EquilibrationTime], Except[Automatic]],
		Lookup[myOptions, EquilibrationTime],
		(* Otherwise always default to 1*Second *)
		True,
		3 * Second
	];

	(* Resolve StopCondition *)
	resolvedStopCondition = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, StopCondition], Except[Automatic]],
		Lookup[myOptions, StopCondition],
		(* If user specifies a valid RunTime, set it to Time mode *)
		MatchQ[Lookup[myOptions, RunTime], TimeP],
		Time,
		(* If user specifies a valid RunVolume, set it to Time mode *)
		MatchQ[Lookup[myOptions, RunVolume], VolumeP],
		Volume,
		(* If user specifies a valid TotalCount, set it to TotalCount mode *)
		MatchQ[Lookup[myOptions, TotalCount], _?NumericQ],
		TotalCount,
		(* If user specifies a valid ModalCount, set it to ModalCount mode *)
		MatchQ[Lookup[myOptions, ModalCount], _?NumericQ],
		ModalCount,
		(* Otherwise, if ApertureDiameter is less than 560 Micrometer, default to Volume mode *)
		MatchQ[apertureDiameter, LessEqualP[560 * Micrometer]],
		Volume,
		(* Otherwise, default to Time mode sine volume mode is not applicable over 560 Micrometer *)
		True,
		Time
	];

	(* Resolve RumTime *)
	resolvedRunTime = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, RunTime], Except[Automatic]],
		Lookup[myOptions, RunTime],
		(* Otherwise if StopCondition is Time, set to 2 Minute *)
		MatchQ[resolvedStopCondition, Time],
		2 * Minute,
		(* Otherwise, default to Null *)
		True,
		Null
	];

	(* Resolve RunVolume *)
	resolvedRunVolume = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, RunVolume], Except[Automatic]],
		Lookup[myOptions, RunVolume],
		(* Otherwise if StopCondition is Volume, set to 500 Microliter *)
		MatchQ[resolvedStopCondition, Volume],
		1000 * Microliter,
		(* Otherwise, default to Null *)
		True,
		Null
	];

	(* Resolve TotalCount *)
	resolvedTotalCount = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, TotalCount], Except[Automatic]],
		Lookup[myOptions, TotalCount],
		(* Otherwise if StopCondition is TotalCount, set to 100,000 *)
		MatchQ[resolvedStopCondition, TotalCount],
		10^5,
		(* Otherwise, default to Null *)
		True,
		Null
	];

	(* Resolve ModalCount *)
	resolvedModalCount = Which[
		(* If it is set it is set *)
		MatchQ[Lookup[myOptions, ModalCount], Except[Automatic]],
		Lookup[myOptions, ModalCount],
		(* Otherwise if StopCondition is ModalCount, set to 20,000 *)
		MatchQ[resolvedStopCondition, ModalCount],
		2 * 10^4,
		(* Otherwise, default to Null *)
		True,
		Null
	];

	(* Gather results *)
	{
		resolvedDynamicDilute,
		resolvedConstantDynamicDilutionFactor,
		resolvedMaxNumberOfDynamicDilutions,
		resolvedCumulativeDynamicDilutionFactor,
		resolvedMixRate,
		resolvedMixTime,
		resolvedMixDirection,
		resolvedNumberOfReadings,
		resolvedFlowRate,
		resolvedMinParticleSize,
		resolvedEquilibrationTime,
		resolvedStopCondition,
		resolvedRunTime,
		resolvedRunVolume,
		resolvedTotalCount,
		resolvedModalCount
	}
];


(* ::Subsubsection:: *)
(*expandForNumberOfReplicates*)
(* Expand a given list according to NumberOfReplicates values *)
(* expandForNumberOfReplicates[{sample1, sample2, sample3},3,}] gives {sample1, sample1, sample1, sample2, sample2, sample2, sample3, sample3, sample3} *)

expandForNumberOfReplicates[myInputs_, numberOfReplicates:(Null | (_?NumericQ))] := Module[{},
	Flatten[
		Map[
			ConstantArray[#, If[NullQ[numberOfReplicates], 1, numberOfReplicates]]&,
			ToList[myInputs]
		],
		1
	]
];



(* ::Subsubsection:: *)
(*expandForNumberOfReplicatesAndDilutions*)

(* Expand a given list according to NumberOfReplicates and NumberOfDilutions *)
expandForNumberOfReplicatesAndDilutions[myInputs_, numberOfReplicates:(Null | (_?NumericQ)), dilutionStrategies_, numbersOfDilutions_] := Module[{},
	Flatten[
		MapThread[
			Function[{valueToExpand, dilutionStrategy, numberOfDilutions},
				ConstantArray[
					ConstantArray[valueToExpand, If[NullQ[numberOfReplicates], 1, numberOfReplicates]],
					If[MatchQ[dilutionStrategy, Series], numberOfDilutions, 1]
				]
			],
			{myInputs, dilutionStrategies, numbersOfDilutions}
		],
		2
	]
];



(* ::Subsubsection:: *)
(*pairStopConditionWithTargetValues*)
(* pair lists of stop condition with specific target values to be acceptable for the field value of StopConditions and SuitabilityStopConditions in Object[Protocol,CoulterCount] *)

pairStopConditionWithTargetValues[stopConditions:{(CoulterCounterStopConditionP | Null)...}, runTimes:{(TimeP | Null)...}, runVolumes:{(VolumeP | Null)...}, modalCounts:{(_Integer | Null)...}, totalCounts:{(_Integer | Null)...}] := Module[{},
	MapThread[
		Switch[#1,
			Time, {Time, #2},
			Volume, {Volume, #3},
			ModalCount, {ModalCount, #4},
			TotalCount, {TotalCount, #5},
			_, {Null, Null}
		]&,
		{stopConditions, runTimes, runVolumes, modalCounts, totalCounts}
	]
];


(* ::Subsubsection:: *)
(*estimateTotalMeasurementTime*)


estimateTotalMeasurementTime[
	runTimes_List,
	mixTimes_List,
	equilibrationTimes_List,
	runVolumes_List,
	flowRates_List,
	numbersOfReadings_List,
	numbersOfReplicates_List,
	dilutionStrategies_List,
	numbersOfDilutions_List,
	measurementQs_List
] := Total[MapThread[
	Function[{runTime, mixTime, equilibrationTime, runVolume, flowRate, numberOfReadings, numberOfReplicates, dilutionStrategy, numberOfDilutions, measurementQ},
		If[measurementQ,
			(* Only calculate measurment time if we are doing actually doing a measurement eg. SystemSuitabilityCheck is True *)
			Module[{measurementTime},
				measurementTime = Which[
					(* If RunTime is specified use that as an estimate for both sample and blank runs *)
					MatchQ[runTime, TimeP],
					runTime,
					(* Otherwise if RunVolume is specified we can still use that to estimate the measurement time *)
					MatchQ[runVolume, VolumeP],
					runVolume / flowRate,
					(* Otherwise just estimate each measurment takes a flat 5 Minute at most *)
					True,
					5 Minute
				];
				(* Now calculate the total time *)
				(* (numberOfReadings+1) for NumberOfReadings here b/c we have one blank measurement in between switching samples *)
				(* DilutionStrategy->Series indicates that we are using all dilution samples as extra measurement samples, so numberOfMeasurements goes up, If[MatchQ[dilutionStrategy,Series],numberOfDilutions,1] takes care of this *)
				If[!NullQ[numberOfReadings],
					Times[
						((If[MatchQ[equilibrationTime, TimeP], equilibrationTime, 0 Minute] + measurementTime) * (numberOfReadings + 1) + If[MatchQ[mixTime, TimeP], mixTime, 0 Minute]),
						If[!NullQ[numberOfReplicates], numberOfReplicates, 1],
						If[MatchQ[dilutionStrategy, Series], numberOfDilutions, 1]
					],
					0 Minute
				]
			],
			0 Minute
		]
	],
	{
		runTimes,
		mixTimes,
		equilibrationTimes,
		runVolumes,
		flowRates,
		numbersOfReadings,
		numbersOfReplicates,
		dilutionStrategies,
		numbersOfDilutions,
		measurementQs
	}
]];


(* ::Subsubsection:: *)
(*resolveCoulterCountMethod*)
(* For DefinePrimitive[...] support even though CoulterCount is always Manual for now *)


DefineOptions[resolveCoulterCountMethod,
	SharedOptions :> {
		ExperimentCoulterCount,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

resolveCoulterCountMethod[
	mySamples:ListableP[Automatic | (ObjectP[{Object[Sample], Object[Container]}])],
	myOptions:OptionsPattern[resolveCoulterCountMethod]
] := Module[
	{outputSpecification, output, gatherTests, result, tests},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* CoulterCount is always performed manually for now *)
	result = Manual;
	tests = {};

	outputSpecification /. {
		Result -> result,
		Tests -> tests
	}
];


(* ::Subsubsection:: *)
(*selectAllAnalytesFromSample*)
(* modified from selectAllAnalytesFromSample *)

DefineOptions[selectAllAnalytesFromSample,
	Options :> {
		{AnalyteTypePattern -> Any, Any|_Alternatives, "The pattern of the molecules (ObjectP[{Model[Molecule, subtype]}] or ObjectP[identity models with IDs]) to be selected as potential analytes for this sample. When Any is specified, all identity models other than water are selected."},
		CacheOption
	}
];

(* Note: AnalyteTypePattern should be ObjectP[{Model[Molecule, subtype]}] or ObjectP[a list of identity model objects] *)
(* if Analytes field is populated, just pick the values there *)
(* if Analytes field is not populated, pick all analyte-like identity models in the Composition field *)
(* if there is no analyte-like identity model in the Composition field, pick the first identity model of any kind in the Composition field *)
(* otherwise, pick Null *)

selectAllAnalytesFromSample[mySample:ObjectP[{Object[Sample], Model[Sample]}], ops:OptionsPattern[]] := First[selectAllAnalytesFromSample[{mySample}, ops]];
selectAllAnalytesFromSample[mySamples:{ObjectP[{Object[Sample], Model[Sample]}]..}, ops:OptionsPattern[]] := Module[
	{safeOps, cache, specifiedAnalyteP, allPackets, analyteObjs, compositionObjs, analyteP},

	(* get the passed Cache option *)
	safeOps = SafeOptions[selectAllAnalytesFromSample, ToList[ops]];
	{cache, specifiedAnalyteP} = Lookup[safeOps, {Cache, AnalyteTypePattern}];

	(* get the composition and analytes fields from all the input samples or models *)
	allPackets = Download[mySamples, Packet[Analytes, Composition], Cache -> cache, Date -> Now];
	(* get the analyte objects and the composition objects *)
	analyteObjs = Download[Lookup[#, Analytes], Object]& /@ allPackets;
	compositionObjs = Download[Lookup[#, Composition][[All, 2]], Object]& /@ allPackets;

	(* pattern for analyte of interest *)
	(* if any analyte type is allowed, then we only exclude the water molecule, otherwise use the specified analyte type *)
	analyteP = If[MatchQ[specifiedAnalyteP, Any],
		(* note that this id is Model[Molecule, "Water"] *)
		Except[ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]], IdentityModelP],
		specifiedAnalyteP
	];

	(* parse and return the Analytes and Composition fields to find the correct analytes to use *)
	MapThread[
		Function[{compositionMolecules, analytes},
			Module[{allMolecules},
				(* join the analyte and composition *)
				allMolecules = DeleteDuplicates[Join[ToList[analytes], ToList[compositionMolecules]]];

				(* select all analytes of the type of interest *)
				Cases[allMolecules, analyteP]
			]
		],
		{compositionObjs, analyteObjs}
	]
];


(* ::Subsubsection:: *)
(*unitlessCoulterCountConcentration*)

(* take in a concentration and convert it to 1/Milliliter *)
unitlessCoulterCountConcentration[inputConc_] := Switch[inputConc,
	UnitsP[Molar],
	QuantityMagnitude[inputConc * AvogadroConstant, 1 / Milliliter],
	UnitsP[EmeraldCell / Milliliter],
	QuantityMagnitude[inputConc, EmeraldCell / Milliliter],
	UnitsP[Particle / Milliliter],
	QuantityMagnitude[inputConc, Particle / Milliliter],
	_,
	inputConc
];

(* ::Subsubsection:: *)
(*appendCoulterCountConcentrationUnit*)


(* append the unit back assuming the unitless was in unit 1/Milliliter *)
appendCoulterCountConcentrationUnit[unitlessInput_, unit:UnitsP[]] := Switch[unit,
	UnitsP[Molar],
	unitlessInput / AvogadroConstant / Milliliter,
	UnitsP[EmeraldCell / Milliliter],
	unitlessInput * EmeraldCell / Milliliter,
	UnitsP[Particle / Milliliter],
	unitlessInput * Particle / Milliliter,
	_,
	Null
];
