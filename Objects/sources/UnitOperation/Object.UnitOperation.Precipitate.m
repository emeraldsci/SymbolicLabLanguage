(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,Precipitate],
	{
		Description->"A detailed set of parameters that specifies a single Precipitate step within a larger protocol.",
		CreatePrivileges->None,
		Cache -> Session,
		Fields->{
			(*---General---*)
			SampleLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Sample],
					Model[Sample],
					Object[Container],
					Model[Container]
				],
				Description->"The sample that is going to be precipitated.",
				Category->"General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that is going to be precipitated.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The sample that is going to be precipitated.",
				Category -> "General",
				Migration->SplitField
			},
			TargetPhase->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Solid|Liquid),
				Description->"For each member of SampleLink, indicates if the target molecules in this sample are expected to be located in the solid precipitate or liquid supernatant after separating the two phases by pelleting or filtration.",
				Category->"General",
				IndexMatching->SampleLink
			},
			SeparationTechnique->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Pellet|Filter),
				Description->"For each member of SampleLink, indicates if the the solid precipitate and liquid supernatant are separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
				Category->"General",
				IndexMatching->SampleLink
			},
			Sterile->{
				Format->Single,
				Class->Expression,
				Pattern:>BooleanP,
				Description->"For each member of SampleLink, indicates if the steps of the protocol are performed in a sterile environment.",
				Category->"General"
			},
			RoboticInstrument->{
				Format->Single,
				Class -> Link,
				Pattern :> _Link,
				Relation->Alternatives[Object[Instrument, LiquidHandler], Model[Instrument, LiquidHandler]],
				Description->"For each member of SampleLink, the instrument that transfers the sample and buffers between containers to execute the protocol.",
				Category->"General"
			},
			SampleVolumeReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of the InputSample that will be precipitated.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			SampleVolumeExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>All,
				Description->"For each member of SampleLink, the volume of the InputSample that will be precipitated.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},

			(*---Precipitation---*)


			PrecipitationReagent->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample], Model[Sample]],
				Description->"For each member of SampleLink, a reagent which, when added to the sample, helps form the precipitate and encourage it to crash out of solution so that it can be collected if it will contain the target molecules, or discarded if the target molecules only remain in the liquid phase.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationReagentVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of PrecipitationReagent that is added to the sample to help form the precipitate and encourage it to crash out of solution.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationReagentTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature that the PrecipitationReagent is incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which helps form the precipitate and encourage it to crash out of solution after adding it to the sample.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationReagentTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature that the PrecipitationReagent are incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which helps form the precipitate and encourage it to crash out of solution after adding it to the sample.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationReagentEquilibrationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the minimum duration during which the PrecipitationReagent is kept at PrecipitationReagentTemperature before being added to the sample, which helps form the precipitate and encourage it to crash out of solution after adding it to the sample.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Shake|Pipette|None),
				Description->"For each member of SampleLink, the manner in which the sample is agitated following the addition of PrecipitationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample is placed on a shaker at PrecipitationMixRate for PrecipitationMixTime, while Pipetting indicates that PrecipitationMixVolume of the sample is pipetted up and down for the number of times specified by NumberOfPrecipitationMixes. None indicates that no mixing occurs after adding WashSolution before incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationMixInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Shaker], Model[Instrument, Shaker]],
				Description->"For each member of SampleLink, the instrument used agitate the sample following the addition of PrecipitationReagent, in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationMixRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 RPM],
				Units->RPM,
				Description->"For each member of SampleLink, the number of rotations per minute that the sample and PrecipitationReagent is shaken at in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationMixTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationMixTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationMixTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration of time that the sample and PrecipitationReagent is shaken for, at the specified PrecipitationMixRate, in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			NumberOfPrecipitationMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Units->None,
				Description->"For each member of SampleLink, the number of times the sample and PrecipitationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationMixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of the combined sample and PrecipitationReagent displaced during each up and down pipetting cycle in order to prepare a uniform mixture prior to incubation.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Shaker], Model[Instrument, Shaker], Object[Instrument, HeatBlock], Model[Instrument, HeatBlock]],
				Description->"For each member of SampleLink, the instrument used maintain the sample temperature at PrecipitationSettlingTemperature while the sample and PrecipitationReagent are left to settle, in order to encourage crashing of precipitant following any mixing.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},
			PrecipitationTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationSettlingTime in order to encourage crashing out of precipitant.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationSettlingTime in order to encourage crashing out of precipitant.",
				Category->"Precipitation",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			PrecipitationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the combined sample and PrecipitationReagent are left to settle, at the specified PrecipitationSettlingTemperature, in order to encourage crashing of precipitant following any mixing.",
				Category->"Precipitation",
				IndexMatching->SampleLink
			},


			(*---Filtration---*)


			FiltrationInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Centrifuge], Model[Instrument, Centrifuge], Object[Instrument, PressureManifold], Model[Instrument, PressureManifold]],
				Description->"For each member of SampleLink, the instrument used to apply force to the sample in order to facilitate its passage through the filter. Either by applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FiltrationTechnique->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Centrifuge|AirPressure),
				Description->"For each member of SampleLink, the type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This is done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			PrefilterMembraneMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>FilterMembraneMaterialP,
				Description->"For each member of SampleLink, the material from which the prefilter filtration membrane, which is placed above Filter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			PoreSize->{
				Format->Multiple,
				Class->Expression,
				Pattern:>FilterSizeP,
				Description->"For each member of SampleLink, the pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			MembraneMaterial->{
				Format->Multiple,
				Class->Expression,
				Pattern:>FilterMembraneMaterialP,
				Description->"For each member of SampleLink, the material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FilterPosition->{
				Format->Multiple,
				Class->String,
				Pattern:>WellP,
				Description->"For each member of SampleLink, the desired position in the Filter in which the samples are placed for the filtering.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FilterCentrifugeIntensity->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>(GreaterP[0 GravitationalAcceleration]|GreaterP[0 RPM]),
				Description->"For each member of SampleLink, the rotational speed or force that is applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FiltrationPressure->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 * PSI],
				Units->PSI,
				Description->"For each member of SampleLink, the pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FiltrationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the samples are exposed to either FiltrationPressure or FiltrationCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PoreSize of Filter.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FiltrateVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the amount of the filtrate that is transferred into a new container, after passing through the filter thus having been separated from the molecules too large to pass through the filter.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},
			FilterStorageCondition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
				Description->"For each member of SampleLink, when FilterStorageCondition is not set to Disposal, FilterStorageCondition is the set of parameters that define the temperature, safety, and other environmental conditions under which the filter used by this experiment is stored after the protocol is completed.",
				Category->"Filtration",
				IndexMatching->SampleLink
			},

			(*---Pelleting---*)


			PelletCentrifuge->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]],
				Description->"For each member of SampleLink, the centrifuge that is used to apply centrifugal force to the samples at PelletingCentrifugeIntensity for PelletingCentrifugeTime in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
				Category->"Pelleting",
				IndexMatching->SampleLink
			},
			PelletCentrifugeIntensity->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>(GreaterP[0 GravitationalAcceleration]|GreaterP[0 RPM]),
				Description->"For each member of SampleLink, the rotational speed or force that is applied to the sample to facilitate precipitation of insoluble molecules out of solution.",
				Category->"Pelleting",
				IndexMatching->SampleLink
			},
			PelletCentrifugeTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the samples are centrifuged at PelletingCentrifugeIntensity in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
				Category->"Pelleting",
				IndexMatching->SampleLink
			},
			PelletVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, The expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of PelletVolume will result in less buffer being aspirated while underestimation of PelletVolume will risk aspiration of the pellet.",
				Category->"Pelleting",
				IndexMatching->SampleLink
			},
			SupernatantVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of the supernatant that is transferred to a new container after the insoluble molecules have been pelleted at the bottom of the starting container.",
				Category->"Pelleting",
				IndexMatching->SampleLink
			},


			(*----Wash----*)


			NumberOfWashes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Units->None,
				Description->"For each member of SampleLink, the number of times WashSolution is added to the solid, mixed, and then separated again by either pelleting and aspiration if SeparationTechnique is set to Pellet, or by filtration if SeparationTechnique is set to Filter. The wash steps are performed in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashSolution->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample], Model[Sample]],
				Description->"For each member of SampleLink, the solution used to help further wash impurities from the solid after the liquid phase has been removed. If SeparationTechnique is set to Filter, then the WashSolution is added to the filter containing the retentate. If SeparationTechnique is set to Pellet, then the WashSolution is added to the container containing the pellet.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashSolutionVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of WashSolution which is used to help further wash impurities from the solid after the liquid phase has been separated from it. If SeparationTechnique is set to Filter, then this amount of WashSolution is added to the filter containing the retentate. If SeparationTechnique is set to Pellet, then this amount of WashSolution is added to the container containing the pellet.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashSolutionTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which WashSolution equilibrates to during the WashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashSolutionTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which WashSolution equilibrates to during the WashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashSolutionEquilibrationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the minimum duration for which the WashSolution is kept at WashSolutionTemperature before being used to help further wash impurities from the solid after the liquid phase has been separated from it.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Shake|Pipette|None),
				Description->"For each member of SampleLink, the manner in which the sample is agitated following addition of WashSolution, in order to help further wash impurities from the solid. Shake indicates that the sample is placed on a shaker at the specified WashMixRate for WashMixTime, while Pipetting indicates that WashMixVolume of the sample is pipetted up and down for the number of times specified by NumberOfWashMixes. None indicates that no mixing occurs before incubation.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashMixInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Shaker], Model[Instrument, Shaker]],
				Description->"For each member of SampleLink, the instrument used agitate the sample following the addition of WashSolution in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashMixRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 RPM],
				Units->RPM,
				Description->"For each member of SampleLink, the rate at which the solid and WashSolution are mixed, for the duration of WashMixTime, in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashMixTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained for the duration of WashMixTime in order to further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashMixTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained for the duration of WashMixTime in order to further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashMixTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the solid and WashSolution are mixed at WashMixRate in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			NumberOfWashMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Units->None,
				Description->"For each member of SampleLink, the number of times WashMixVolume of the WashSolution is mixed by pipetting up and down in order to help further wash impurities from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashMixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of WashSolution that is displaced by pipette during each wash mix cycle, the number of cycles are defined by NumberOfWashMixes.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashPrecipitationInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Shaker], Model[Instrument, Shaker], Object[Instrument, HeatBlock], Model[Instrument, HeatBlock]],
				Description->"For each member of SampleLink, the instrument used to maintain the sample and WashSolution at WashSettlingTemperature for the WashSettlingTime prior to separation.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashPrecipitationTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature which the samples in WashSolution are held at for the duration of WashSettlingTime in order to facilitate the solution's passage through the filter to help seperate the WashSolution from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashPrecipitationTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature which the samples in WashSolution are held at for the duration of WashSettlingTime in order to facilitate the solution's passage through the filter to help seperate the WashSolution from the solid.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			WashPrecipitationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the samples remain in WashSolution after any mixing has occurred, held at WashSettlingTemperature, in order allow the solid to settle after mixing.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashCentrifugeIntensity->{
				Format->Multiple,
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>(GreaterP[0 GravitationalAcceleration]|GreaterP[0 RPM]),
				Description->"For each member of SampleLink, the rotational speed or the force that is applied to the sample in order to separate the WashSolution from the solid after any mixing and incubation steps have been performed. If SeparationTechnique is set to Filter, then the force is applied to the filter containing the retentate and WashSolution in order to facilitate the solution's passage through the filter to help further wash impurities from the solid. If SeparationTechnique is set to Pellet, then the force is applied to the container containing the pellet and WashSolution in order to encourage the repelleting of the solid.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashPressure->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 * PSI],
				Units->PSI,
				Description->"For each member of SampleLink, the target pressure applied to the filter containing the retentate and WashSolution in order to facilitate the solution's passage through the filter to help further wash impurities from the retentate.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			WashSeparationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration for which the samples are exposed to WashPressure or WashCentrifugeIntensity in order to seperate the WashSolution from the solid. If SeparationTechnique is set to Filter, then this separation is performed by passing the WashSolution through Filter by applying force of either WashPressure (if FiltrationTechnique is set to AirPressure) or WashCentrifugeIntensity (if FiltrationTechnique is set to Centrifuge). If SeparationTechnique is set to Pellet, then centrifugal force of WashCentrifugeIntensity is applied to encourage the solid to remain as, or return to, a pellet at the bottom of the container.",
				Category->"Wash",
				IndexMatching->SampleLink
			},
			DryingTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained for the duration of DryingTime after removal of WashSolution, in order to evaporate any residual WashSolution.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			DryingTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained for the duration of DryingTime after removal of WashSolution, in order to evaporate any residual WashSolution.",
				Category->"Wash",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			DryingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the amount of time for which the solid is exposed to open air at DryingTemperature following final removal of WashSolution, in order to evaporate any residual WashSolution.",
				Category->"Wash",
				IndexMatching->SampleLink
			},


			(*----Resuspension----*)


			ResuspensionBufferLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample], Model[Sample]],
				Description->"For each member of SampleLink, the solution into which the target molecules of the solid is resuspended or redissolved. Setting ResuspensionBuffer to None indicates that the sample will not be resuspended and that it is stored as a solid, following any wash steps.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionBufferExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>None,
				Description->"For each member of SampleLink, the solution into which the target molecules of the solid is resuspended or redissolved. Setting ResuspensionBuffer to None indicates that the sample will not be resuspended and that it is stored as a solid, following any wash steps.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionBufferVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of ResuspensionBuffer that is added to the solid and mixed in an effort to resuspend or redissolve the solid into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionBufferTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Description->"For each member of SampleLink, the temperature that the ResuspensionBuffer equilibrates to during the ResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionBufferTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature that the ResuspensionBuffer equilibrates to during the ResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionBufferEquilibrationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the minimum duration for which the ResuspensionBuffer is kept at ResuspensionBufferTemperature before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>(Shake|Pipette|None),
				Description->"For each member of SampleLink, the manner in which the sample is agitated following addition of ResuspensionBuffer in order to encourage the solid phase resuspend or redissolve into the buffer. Shake indicates that the sample is placed on a shaker at the specified ResuspensionMixRate for ResuspensionMixTime at ResuspensionMixTemperature, while Pipetting indicates that ResuspensionMixVolume of the sample is pipetted up and down for the number of times specified by NumberOfResuspensionMixes. None indicates that no mixing occurs after adding ResuspensionBuffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionMixInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument, Shaker], Model[Instrument, Shaker]],
				Description->"For each member of SampleLink, the instrument used agitate the sample following the addition of ResuspensionBuffer, in order to encourage the solid to redissolve or resuspend into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionMixRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 RPM],
				Units->RPM,
				Description->"For each member of SampleLink, the rate at which the solid and ResuspensionBuffer are shaken, for the duration of ResuspensionMixTime at ResuspensionMixTemperature, in order to encourage the solid to redissolve or resuspend into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionMixTemperatureReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature at which the sample and ResuspensionBuffer are held at for the duration of ResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionMixTemperatureExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Ambient,
				Description->"For each member of SampleLink, the temperature at which the sample and ResuspensionBuffer are held at for the duration of ResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink,
				Migration->SplitField
			},
			ResuspensionMixTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Second],
				Units->Minute,
				Description->"For each member of SampleLink, the duration of time that the solid and ResuspensionBuffer is shaken for, at the specified ResuspensionMixRate, in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			NumberOfResuspensionMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Units->None,
				Description->"For each member of SampleLink, the number of times that the ResuspensionMixVolume of the ResuspensionBuffer and solid are mixed by pipette in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionMixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SampleLink, the volume of ResuspensionBuffer displaced during each cycle of mixing by pipetting up and down, which is repeated for the number of times defined by NumberOfResuspensionMixes in order to encourage the solid to redissolve or resuspend into the ResuspensionBuffer.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},


			(*---Storage---*)

			PrecipitatedSampleContainerOutString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			PrecipitatedSampleContainerOutExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {WellP, {_Integer, ObjectP[Model[Container]]}} | {_Integer, ObjectP[Model[Container]]} | {ObjectP[Model[Container]]},
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			PrecipitatedSampleContainerOutLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Container], Model[Container]],
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			PrecipitatedSampleStorageCondition->{(*TODO Update Description*)
				Format->Multiple,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
				Description->"For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the solid that is isolated during precipitation is stored, either as a solid, or as a solution if a buffer is specified for ResuspensionBuffer.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			PrecipitatedSampleLabel->{(*TODO Update Description*)
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, a user defined word or phrase used to identify the liquid phase that is separated during this protocol. If SeparationTechnique is set to Filter, then the sample is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample is the supernatant aspirated after the solid is pelleted using centrifugla force. This label is for use in downstream unit operations.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			PrecipitatedSampleContainerLabel->{(*TODO Update Description*)
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, a user defined word or phrase used to identify the container that contains the liquid phase that is separated during this protocol. If SeparationTechnique is set to Filter, then the sample contained in the container is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample contained in the container is the supernatant aspirated after the solid is pelleted using centrifugal  force. This label is for use in downstream unit operations.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			UnprecipitatedSampleContainerOutString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			UnprecipitatedSampleContainerOutExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {WellP, {_Integer, ObjectP[Model[Container]]}} | {_Integer, ObjectP[Model[Container]]} | {ObjectP[Model[Container]]},
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			UnprecipitatedSampleContainerOutLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Container], Model[Container]],
				Description -> "For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
				IndexMatching -> SampleLink,
				Category -> "Sample Storage",
				Migration -> SplitField
			},
			UnprecipitatedSampleStorageConditionExpression->{				(*TODO Update Description*)
				Format->Multiple,
				Class->Expression,
				Pattern:>(SampleStorageTypeP|Disposal),
				Description->"For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the solid that is isolated during precipitation is stored, either as a solid, or as a solution if a buffer is specified for ResuspensionBuffer.",
				Category->"Sample Storage",
				IndexMatching->SampleLink,
				Migration -> SplitField
			},
			UnprecipitatedSampleStorageConditionLink->{				(*TODO Update Description*)
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[StorageCondition],
				Description->"For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the solid that is isolated during precipitation is stored, either as a solid, or as a solution if a buffer is specified for ResuspensionBuffer.",
				Category->"Sample Storage",
				IndexMatching->SampleLink,
				Migration -> SplitField
			},
			UnprecipitatedSampleLabel->{(*TODO Update Description*)
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, a user defined word or phrase used to identify the liquid phase that is separated during this protocol. If SeparationTechnique is set to Filter, then the sample is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample is the supernatant aspirated after the solid is pelleted using centrifugla force. This label is for use in downstream unit operations.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			},
			UnprecipitatedSampleContainerLabel->{(*TODO Update Description*)
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"For each member of SampleLink, a user defined word or phrase used to identify the container that contains the liquid phase that is separated during this protocol. If SeparationTechnique is set to Filter, then the sample contained in the container is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample contained in the container is the supernatant aspirated after the solid is pelleted using centrifugal  force. This label is for use in downstream unit operations.",
				Category->"Sample Storage",
				IndexMatching->SampleLink
			}
		}
	}
];