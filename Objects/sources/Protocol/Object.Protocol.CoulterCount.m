(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, CoulterCount], {
	Description -> "A protocol for counting and sizing particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*------------------------------General------------------------------*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, CoulterCounter] | Object[Instrument, CoulterCounter],
			Description -> "The instrument that is used to count and size particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities. Note that the resistivity of the particles can be either larger or smaller than that of the electrolyte solution.",
			Category -> "General",
			Abstract -> True
		},
		ApertureTube -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, ApertureTube] | Object[Part, ApertureTube],
			Description -> "A glass tube with a small aperture near the bottom through which particles are pumped to perturb the electrical resistance within the aperture for particle sizing and counting. The diameter of the aperture used for the electrical resistance measurement dictates the accessible window for particle size measurement, which is generally 2%-80% of the ApertureDiameter.",
			Category -> "General"
		},
		ApertureDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "The desired diameter of the aperture used for the electrical resistance measurement, which dictates the accessible window for particle size measurement, which is generally 2%-80% of the ApertureDiameter.",
			Category -> "General",
			Abstract -> True
		},
		ElectrolyteSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The conductive solution used to suspend the particles to be counted and sized. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive.",
			Abstract -> True,
			Category -> "General"
		},
		(*------------------------------Flushing aperture tube------------------------------*)
		ElectrolyteSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of the electrolyte solution to be added into the ElectrolyeSolutionContainer of the coulter counter instrument. The amount added here supplies a reservoir of clean electrolyte solution that is pumped to flush the aperture tube before and after sample runs to remove particles that may remain trapped in the bottom of the aperture tube.",
			Category -> "Flushing"
		},
		FlushFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			Description -> "The target volume of the electrolyte solution pumped through the aperture of the ApertureTube per unit time when flushing the aperture tube.",
			Category -> "Flushing"
		},
		FlushTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration that electrolyte solution flow from ElectrolyteSolutionContainer, to ApertureTube, to ParticleTrapContainer, and to InternalWasteContainer is maintained, in an attempt to remove the particles inside the ApertureTube after connecting the ApertureTube to instrument for the first time, before and after sample runs, or before changing the sample in the MeasurementContainer.",
			Category -> "Flushing"
		},
		RinseContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			Description -> "The container that is used to collect the liquid used to rinse the aperture tube after each run.",
			Category -> "Flushing",
			Developer -> True
		},
		(*------------------------------System suitability check------------------------------*)
		SystemSuitabilityTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The largest size discrepancy between the measured mean diameter and the manufacture-labelled mean diameter or the measured mean volume and the manufactured-labelled mean volume of SuitabilitySizeStandard sample(s) when sized by electrical resistance measurement to pass the system suitability check. A discrepancy above SystemSuitabilityTolerance triggers the size-calibration procedure of the instrument to obtain a new calibration constant for the aperture tube. Afterwards, the system suitability check will automatically rerun to check if system suitability is restored. Calibration is triggered only once. If system suitability is not restored after calibration, SystemSuitabilityError is set to True in the protocol object and if AbortOnSystemSuitabilityCheck is set to True, the experiment run will abort without collecting additional data.",
			Category -> "System Suitability Check"
		},
		SuitabilitySizeStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The particle size standard samples with known mean diameters or volumes used for the checking the system suitability. These standard samples are typically NIST traceable monodisperse polystyrene beads with sizes precharacterized by other standard techniques such as optical microscopy and transmission electron microscopy (TEM). Each of the samples is loaded into the instrument and sized by electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance. The SuitabilitySizeStandard option values are expanded according to NumberOfSuitabilityReplicates to supply an expanded list of samples here.",
			Category -> "System Suitability Check"
		},
		WorkingSuitabilitySizeStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the derived sample on which the experiment acts. This list diverges from SuitabilitySizeStandards when SuitabilityDynamicDilute is set to True, or when they are transferred to new containers.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		SuitabilityContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Any containers containing this protocols' SuitabilitySizeStandards.",
			Category -> "System Suitability Check"
		},
		SuitabilityParticleSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the manufacture-labeled mean diameter or volume of the particle size standard samples used for the system suitability check. The system is considered suitable when either MeasuredSuitabilityParticleSizes or RepeatedMeasuredSuitabilityParticleSizes matches SuitabilityParticleSizes.",
			Category -> "System Suitability Check"
		},
		SuitabilitySampleLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, a set of instructions specifying the mixing of size standard with electrolyte solution in the given SuitabilityMeasurementContainer.",
			Category -> "Sample Loading"
		},
		SuitabilityTargetConcentrations -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Molar],
				GreaterEqualP[0 EmeraldCell / Milliliter],
				GreaterEqualP[0 Particle / Milliliter],
				GreaterEqualP[0 Gram / Liter]
			],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the target particle concentration in the final solution from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume in SuitabilityMeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) becomes severe if SuitabilityTargetConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume.",
			Category -> "System Suitability Check"
		},
		SuitabilitySampleAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the amount of SuitabilitySizeStandard sample(s) to be mixed with the electrolyte solution to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityElectrolyteSampleDilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the amount of the electrolyte solution to be mixed with the SuitabilitySizeStandard sample(s) to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityElectrolytePercentages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[Percent],
			Units -> Percent,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the desired ratio of the volume of the electrolyte solution to the total volume in the final sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the SuitabilityMeasurementContainer.",
			Category -> "Sample Loading"
		},
		SuitabilityMeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the container that holds the SuitabilitySizeStandard sample-electrolyte solution mixture during mixing and electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityDynamicDilutes -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, indicates if additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the SuitabilitySizeStandard sample-electrolyte solution with ElectrolyteSolution according to SuitabilityConstantDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor and loaded for measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or SuitabilityMaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture is already within the suitable range even when SuitabilityDynamicDilute is set to True.",
			Category -> "System Suitability Check"
		},
		SuitabilityConstantDynamicDilutionFactors -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the constant factor by which the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
			Category -> "System Suitability Check"
		},
		SuitabilityCumulativeDynamicDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the factor by which the particle concentration in the original SuitabilitySizeStandard sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in SuitabilityMaxNumberOfDynamicDilutions.",
			Category -> "System Suitability Check"
		},
		SuitabilityMaxNumberOfDynamicDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, max number of times for which the SuitabilitySizeStandard sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
			Category -> "System Suitability Check"
		},
		CurrentSuitabilityDynamicDilutionIterations -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the iteration that the dynamic dilution is at.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		CurrentSuitabilityDynamicDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, a set of instructions specifying the loading and mixing of each sample and ElectrolyteSolution to prepare the samples during the current dynamic dilution iterations prior to starting the electrical measurement.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		FinalizedSuitabilityDynamicDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, a set of instructions specifying the loading and mixing of each sample and ElectrolyteSolution to prepare the samples after dynamic dilution to obtain the most optimal concentration prior to starting the electrical measurement.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		SuitabilityDynamicDilutionProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, protocols used to to create new diluted samples if additional dilution is performed on SuitabilitySizeStandards to reduce the particle concentration to a suitable range for measurement.",
			Category -> "System Suitability Check"
		},
		SuitabilityCurrentlyOversaturated -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the particle concentration in the current suitability size standard is too high that would induce coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) that impairs the counting and sizing accuracy.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		SuitabilityOversaturated -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, indicates if the particle concentration is too high that would induce coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) that impairs the counting and sizing accuracy.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the duration that the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the rotation speed of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability. If SuitabilityMixRate is set to 0 RPM, the integrated stirrer will be put outside the SuitabilityMeasurementContainer and no mixing of the solution in SuitabilityMeasurementContainer is performed.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Clockwise | Counterclockwise,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the rotation direction of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		NumberOfSuitabilityReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the number of times to perform identical system suitability runs on each SuitabilitySizeStandard sample-electrolyte solution mixture that is loaded into the instrument. Each of the system suitability runs is performed on the same sample-electrolyte solution mixture without reloading the instrument.",
			Category -> "System Suitability Check"
		},
		NumberOfSuitabilityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[2, 1],
			Description -> "For each sample in SuitabilitySizeStandard option, the number of replicate SuitabilitySizeStandard sample-electrolyte solution mixtures to prepare from mixing SuitabilitySizeStandard with ElectrolyteSolution. Each of the replicate mixture is loaded into the instrument individually with NumberOfSuitabilityReadings of system suitability runs performed. The SuitabilitySizeStandard option values are expanded according to NumberOfSuitabilityReplicates to supply a list of samples and their replicates in SuitabilitySizeStandards.",
			Category -> "System Suitability Check"
		},
		SuitabilityApertureCurrents -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microampere],
			Units -> Microampere,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the value of the constant current that passes through the aperture of the ApertureTube during the system suitability run in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube.",
			Category -> "System Suitability Check"
		},
		SuitabilityGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the amplification factor applied to the recorded voltage pulse during the system suitability run.",
			Category -> "System Suitability Check"
		},
		SuitabilityFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the target volume of the SuitabilitySizeStandard sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the system suitability run.",
			Category -> "System Suitability Check"
		},
		MinSuitabilityParticleSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, only particles with diameters or volumes larger than or equal to MinSuitabilityParticleSize are counted towards the SuitabilityTotalCount during the system suitability run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
			Category -> "System Suitability Check"
		},
		MinSuitabilityPulseIntensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Volt],
			Units -> Millivolt,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, only the voltage pulses with peak intensities larger than or equal to MinSuitabilityPulseIntensity are counted towards the SuitabilityTotalCount during the system suitability run. The voltage pulses are generated by particles passing through the aperture of the ApertureTube where the voltage intensity is proportional to the volume of the particle.",
			Category -> "System Suitability Check"
		},
		SuitabilityEquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, duration of time before counting the voltage pulses towards the SuitabilityTotalCount after the SuitabilitySizeStandard sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to SuitabilityFlowRate during SuitabilityEquilibrationTime to reduce the noise level during the pulse recording.",
			Category -> "System Suitability Check"
		},
		SuitabilityStopConditions -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {
				CoulterCounterStopConditionP,
				Alternatives[
					GreaterP[0 Second],
					GreaterP[0 Microliter],
					GreaterP[0, 1]
				]
			},
			Headers -> {"Stop Condition", "Target Value"},
			Units -> {None, None},
			Relation -> {Null, Null},
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, parameters describing if the system suitability run of the SuitabilitySizeStandard sample-electrolyte solution mixture concludes based on Time, Volume, TotalCount, or ModalCount. In Time mode the system suitability run is performed until a duration of time specified in the target value has elapsed. In Volume mode the system suitability run is performed until a specified volume of the sample from the SuitabilityMeasurementContainer has passed through the aperture of the ApertureTube. In TotalCount mode the system suitability run is performed until a specified number of particles are counted in total. In ModalCount mode the system suitability run is performed until number of particles with sizes that appear most frequently exceeds the number specified in the target value. Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
			Category -> "System Suitability Check"
		},
		EstimatedSuitabilityProcessingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the estimated total processing time including equilibration and run time for the electrical measurement.",
			Category -> "System Suitability Check"
		},
		(*------------------------------fields for sample prep and measurement parameters for system suitability check------------------------------*)
		SuitabilityParticleSizeDomains -> {
			Format -> Multiple,
			Class -> {VariableUnit, VariableUnit},
			Pattern :> {
				GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
				GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3]
			},
			Headers -> {"Min", "Max"},
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, only peaks in the measured particle size distribution whose peak range lies inside the specified domain interval are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityAbsoluteThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, only peaks in the measured particle size distribution whose maximum count is larger than or equal to this threshold are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityRelativeThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, only peaks in the measured particle size distribution whose maximum count with its baseline subtracted is larger than or equal to this threshold are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityBaselines -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BaselineP,
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, method used to compute peak baselines in the measured particle size distribution. The baseline affects a peak's height and area. The baseline is fit to the points inside the SuitabilityParticleSizeDomain that are not part of any peak.",
			Category -> "System Suitability Check"
		},
		SuitabilityBaselineFeatureWidths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, when SuitabilityBaseline is set to DomainNonlinear, a parameter that sets the width of variations in the data above which it is followed by the fitted baseline function. Smaller SuitabilityBaselineFeatureWidth includes more features in baseline and makes baseline curvier. Larger SuitabilityBaselineFeatureWidth prunes more features from the baseline and makes it flatter. See section 'Options/BaselineFeatureWidth' in AnalyzePeaks for examples. Internally, method 'DomainNonlinear' uses Mathematica function EstimatedBackground with the setting to SuitabilityBaselineFeatureWidth determining the scale 'sigma'.",
			Category -> "System Suitability Check"
		},
		SystemSuitabilityAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "For each member of SuitabilitySizeStandards, the AnalyzePeaks analysis performed to pick the peaks in the measured particle size distribution obtained from the first system suitability run to calculate the MeasuredSuitabilityParticleSizes.",
			Category -> "System Suitability Check"
		},
		RepeatedSystemSuitabilityAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "For each member of SuitabilitySizeStandards, the AnalyzePeaks analysis performed to pick the peaks in the measured particle size distribution obtained from the repeated system suitability run after calibration to calculate the RepeatedMeasuredSuitabilityParticleSizes.",
			Category -> "System Suitability Check"
		},
		MeasuredSuitabilityParticleSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Millimeter] | DistributionP[Millimeter^3],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the measured mean diameter or volume of the particle size standard samples obtained from the first system suitability run.",
			Category -> "System Suitability Check"
		},
		RepeatedMeasuredSuitabilityParticleSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Millimeter] | DistributionP[Millimeter^3],
			IndexMatching -> SuitabilitySizeStandards,
			Description -> "For each member of SuitabilitySizeStandards, the measured mean diameter or volume of the particle size standard samples obtained from the repeated system suitability run after calibration. The calibration is triggered only once if the discrepancy between MeasuredSuitabilityParticleSizes and SuitabilityParticleSizes is above SystemSuitabilityTolerance.",
			Category -> "System Suitability Check"
		},
		AbortOnSystemSuitabilityCheck -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the experiment is aborted early if system suitability check fails. Aborted experiments will not prepare the SamplesIn and will only consume the SuitabilitySizeStandard samples. If AbortOnSystemSuitabilityCheck is set to False, the experiment will continue to the end. If system suitability check fails, SystemSuitabilityError is set to True in the protocol and data object. Note that data obtained with SystemSuitabilityError marked True may provide less size accuracy therefore should be interpreted with caution.",
			Category -> "System Suitability Check"
		},
		SystemSuitabilityError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the system suitability check fails by checking if any RepeatedMeasuredSuitabilityParticleSizes do not match SuitabilityParticleSizes within SystemSuitabilityTolerance. The instrument must be able to measure the size of particle size standard samples within a given tolerance to pass the system suitability check.",
			Category -> "System Suitability Check"
		},
		(*-----------------------------Dilution fields + Mix------------------------------*)
		DilutionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionTypeP, (* Serial | Linear *)
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates the type of dilution to perform. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration. The progression can be described by either a series of target concentrations or a series of dilution factors. In a serial dilution the source of a dilution round is the resulting sample of the previous dilution round. The first source sample is the original sample provided.",
			Category -> "Sample Dilution"
		},
		DilutionStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionStrategyP | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if only the final sample (EndPoint) or all diluted samples (Series) produced by serial dilution are used for following electrical resistance measurement. If set to Series, sample loading and electrical resistance measurement options are automatically expanded to be the same across all diluted samples, while TargetMeasurementConcentration and DiluentPercent options are not expanded to ensure the electrolyte concentration is the same across all sample-electrolyte solution mixtures prepared from diluted samples.",
			Category -> "Sample Dilution"
		},
		NumberOfDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of diluted samples to prepare.",
			Category -> "Sample Dilution"
		},
		TargetAnalytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the component in the Composition of the input sample whose concentration is being reduced to TargetAnalyteConcentration.",
			Category -> "Sample Dilution"
		},
		CumulativeDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution.",
			Category -> "Sample Dilution"
		},
		SerialDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced.",
			Category -> "Sample Dilution"
		},
		TransferVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to LinearDilution, the amount of sample that is diluted with Buffer. If DilutionType is set to Serial, the amount of sample transferred from the resulting sample of one round of the dilution series to the next sample in the series. The first transfer source is the original sample provided.",
			Category -> "Sample Dilution"
		},
		TotalDilutionVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the total volume of sample, buffer, concentrated buffer, and concentrated buffer diluent. If DilutionType is set to Serial, this is also the volume of the resulting sample before TransferVolume has been removed for use in the next dilution in the series.",
			Category -> "Sample Dilution"
		},
		FinalVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Serial, the volume of the resulting diluted sample after TransferVolume has been removed for use in the next dilution in the series.",
			Category -> "Sample Dilution"
		},
		DiscardFinalTransfers -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is Serial, indicates if, after the final dilution is complete, TransferVolume should be removed from the final dilution container.",
			Category -> "Sample Dilution"
		},
		Diluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the solution used to reduce the concentration of the sample.",
			Category -> "Sample Dilution"
		},
		DiluentVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the amount of diluent added to dilute the sample. If DilutionType is set to Serial, the amount of diluent added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		DilutionConcentratedBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a concentrated version of Buffer that has the same BaselineStock and can be used in place of Buffer if Buffer is not fulfillable but ConcentratedBuffer and ConcentratedBufferDiluent are. Additionally, if DilutionType is set to Serial and the sample Solvent does not match Buffer, but is the ConcentratedBufferDiluent of ConcentratedBuffer, this sample can also be used as a component in an initial mixture to change the Solvent of the input sample to the desired target Buffer.",
			Category -> "Sample Dilution"
		}, (* name space change to avoid conflict, already exist a field ConcentratedBuffers in aliquoting fields *)
		ConcentratedBufferVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the amount of concentrated buffer added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferDiluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the factor by which to reduce ConcentratedBuffer before it is combined with the sample. The length of this list must match the corresponding value in NumberOfDilutions.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferDiluentVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the amount of concentrated buffer diluent added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer diluent added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the duration of time for which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the duration of time for which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives @@ Join[MixInstrumentModels, MixInstrumentObjects],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the instrument used to mix/incubate the sample following the dilution. If DilutionType is set to Serial, the instrument used to mix/incubate the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Kelvin] | Ambient,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionMixTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MixTypeP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the style of motion used to mix the sample following the dilution. If DilutionType is set to Serial, the style of motion used to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the number of times the sample is mixed following the dilution. If DilutionType is set to Serial, the number of times the resulting sample after a round of dilution is mixed before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionMixRates -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the frequency of rotation the mixing instrument should use to mix the sample following the dilution. If DilutionType is set to Serial, the frequency of rotation the mixing instrument should use to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionMixOscillationAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 AngularDegree],
			Units -> AngularDegree,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if DilutionType is set to Linear, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the sample following the dilution. If DilutionType is set to Serial, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of SamplesIn, samples produced by mixing the SamplesIn with Diluent, ConcentratedBuffer, or ConcentratedBufferDiluent during dilution or serial dilution and intended for use in the following electrical resistance measurement.",
			Category -> "Sample Dilution"
		},
		DilutionProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Notebook, Script]
			],
			Description -> "For each member of SamplesIn, protocols used to to prepare DilutedSamples prior to starting the electrical resistance measurement.",
			Category -> "Sample Dilution"
		},
		SampleDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the loading and mixing of each sample and the Diluent to prepare DilutedSamples prior to starting the electrical measurement..",
			Category -> "Sample Dilution"
		},
		(*------------------------------Sample loading ------------------------------*)
		SampleLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, a set of instructions specifying the mixing of sample with electrolyte solution in the given MeasurementContainer.",
			Category -> "Sample Loading"
		},
		TargetMeasurementConcentrations -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Molar],
				GreaterEqualP[0 EmeraldCell / Milliliter],
				GreaterEqualP[0 Particle / Milliliter],
				GreaterEqualP[0 Gram / Liter]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the target particle concentration in the final solution from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume in MeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) becomes severe if TargetMeasurementConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume.",
			Category -> "Sample Loading"
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Milliliter],
				GreaterEqualP[0 Milligram]
			],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		ElectrolyteSampleDilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		ElectrolytePercentages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[Percent],
			Units -> Percent,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the desired ratio of the volume of the electrolyte solution to the total volume in the final sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the MeasurementContainer.",
			Category -> "Sample Loading"
		},
		MeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the container that holds the sample-electrolyte solution mixture and any new samples during mixing and electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		DynamicDilutes -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, indicates if additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the sample-electrolyte solution with ElectrolyteSolution according to ConstantDynamicDilutionFactor or CumulativeDynamicDilutionFactor and loaded for quick preview-type measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or MaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture is already within the suitable range even when DynamicDilute is set to True.",
			Category -> "Sample Loading"
		},
		ConstantDynamicDilutionFactors -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the constant factor by which the particle concentration in the sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
			Category -> "Sample Loading"
		},
		CumulativeDynamicDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the factor by which the particle concentration in the original sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in MaxNumberOfDynamicDilutions.",
			Category -> "Sample Loading"
		},
		MaxNumberOfDynamicDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, max number of times for which the sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
			Category -> "Sample Loading"
		},
		CurrentDynamicDilutionIterations -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the iteration that the dynamic dilution is at.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		CurrentDynamicDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, a set of instructions specifying the loading and mixing of each sample and ElectrolyteSolution to prepare the samples during the current dynamic dilution iterations prior to starting the electrical measurement.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		FinalizedDynamicDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SamplePreparationP..},
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, a set of instructions specifying the loading and mixing of each sample and ElectrolyteSolution to prepare the samples after dynamic dilution to obtain the most optimal concentration prior to starting the electrical measurement.",
			Category -> "System Suitability Check",
			Developer -> True
		},
		DynamicDilutionProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, protocols used to to create new diluted samples if additional dilution is performed on SamplesIn to reduce the particle concentration to a suitable range for measurement.",
			Category -> "Sample Loading"
		},
		CurrentlyOversaturated -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the particle concentration in the current sample is too high that would induce coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) that impairs the counting and sizing accuracy.",
			Category -> "Sample Loading",
			Developer -> True
		},
		Oversaturated -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, indicates if the particle concentration is too high that would induce coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) that impairs the counting and sizing accuracy.",
			Category -> "Sample Loading"
		},
		MixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the duration that the SampleAmount and ElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		MixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the rotation speed of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement. If MixRate is set to 0 RPM, the integrated stirrer will be put outside the MeasurementContainer and no mixing of the solution in MeasurementContainer is performed.",
			Category -> "Sample Loading"
		},
		MixDirections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Clockwise | Counterclockwise,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the rotation direction of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		(*------------------------------Measurement set up------------------------------*)
		NumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the number of times to perform identical sample runs to record voltage pulses on each sample-electrolyte solution mixture that is loaded into the instrument. Each of the sample run is performed on the same sample-electrolyte solution without reloading the instrument.",
			Category -> "Electrical Resistance Measurement"
		},
		ApertureCurrents -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microampere],
			Units -> Microampere,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the value of the constant current that passes through the aperture of the ApertureTube during pulse recording in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube.",
			Category -> "Electrical Resistance Measurement"
		},
		Gains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the amplification factor applied to the recorded voltage pulse during the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter / Second],
			Units -> Microliter / Second,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the target volume of the sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		MinParticleSizes -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, only particles with diameters or volumes larger than or equal to MinParticleSize are counted towards the TotalCount during the sample run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
			Category -> "Electrical Resistance Measurement"
		},
		MinPulseIntensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Volt],
			Units -> Millivolt,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, only the voltage pulses with peak intensities larger than or equal to MinPulseIntensity are counted towards the TotalCount during the sample run. The voltage pulses are generated by particles passing through the aperture of the ApertureTube where the voltage intensity is proportional to the volume of the particle.",
			Category -> "Electrical Resistance Measurement"
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, duration of time before counting the voltage pulses towards the TotalCount after the sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to FlowRate during EquilibrationTime to reduce the noise level during the pulse recording.",
			Category -> "Electrical Resistance Measurement"
		},
		StopConditions -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {
				CoulterCounterStopConditionP,
				Alternatives[
					GreaterP[0 Second],
					GreaterP[0 Microliter],
					GreaterP[0, 1]
				]
			},
			Headers -> {"Stop Condition", "Target Value"},
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, parameters describing if the sample run of the sample-electrolyte solution mixture in the MeasurementContainer concludes based on Time, Volume, TotalCount, or ModalCount. In Time mode the sample run is performed until a duration of time specified in the target value has elapsed. In Volume mode the sample run is performed until a specified volume of the sample has passed through the aperture of the ApertureTube. In TotalCount mode the sample run is performed until a specified number of particles are counted in total. In ModalCount mode the sample run is performed until number of particles with sizes that appear most frequently exceeds the number specified in the target value. Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
			Category -> "Electrical Resistance Measurement"
		},
		EstimatedProcessingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, the estimated total processing time including equilibration and run time for the electrical measurement.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		VolumeBeforeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes before loading samples into the instrument.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		VolumeAfterMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes after loading samples into the instrument and electrical resistance measurement.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		SuitabilityVolumeBeforeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes before loading suitability size standards into the instrument in the 1st suitability check.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		RepeatedSuitabilityVolumeBeforeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes before loading suitability size standards into the instrument in the 2nd suitability check.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		SuitabilityVolumeAfterMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes after loading suitability size standards into the instrument and electrical resistance measurement in the 1st suitability check.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		RepeatedSuitabilityVolumeAfterMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Protocols that were used to measure volumes after loading suitability size standards into the instrument and electrical resistance measurement in the 2nd suitability check.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		MeasurementError -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The type of the software error during the electrical resistance measurement.",
			Category -> "Electrical Resistance Measurement",
			Developer -> True
		},
		(*------------------------------Method information------------------------------*)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file with the run parameters.",
			Category -> "Method Information",
			Developer -> True
		},
		SuitabilityMethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the electrical resistance measurements of the SuitabilitySizeStandards samples in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		SuitabilityMethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the electrical resistance measurements of the SuitabilitySizeStandards samples in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		SuitabilityBlankMethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the electrical resistance measurements of a blank sample in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		SuitabilityBlankMethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the electrical resistance measurements of a blank sample in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		RepeatedSuitabilityMethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the repeated electrical resistance measurements of the SuitabilitySizeStandards samples in the second trial of system suitability check in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		RepeatedSuitabilityMethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the repeated electrical resistance measurements of the SuitabilitySizeStandards samples in the second trial of system suitability check in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		RepeatedSuitabilityBlankMethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the repeated electrical resistance measurements of a blank sample in the second trial of system suitability check in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		RepeatedSuitabilityBlankMethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the repeated electrical resistance measurements of a blank sample in the second trial of system suitability check in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		MethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the electrical resistance measurements of the SamplesIn in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		MethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the electrical resistance measurements of the SamplesIn in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		BlankMethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the method files for the electrical resistance measurements of a blank sample in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		BlankMethodFileFullPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The full file paths of the method files for the electrical resistance measurements of a blank sample in this protocol.",
			Category -> "Method Information",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "Method Information",
			Developer -> True
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, any blank data generated by this protocol.",
			Category -> "Experimental Results",
			AdminWriteOnly->True
		},
		(*------------------------------Placement------------------------------*)
		ApertureTubePlacement -> {
			Format -> Single,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part], Null},
			Description -> "Placement used to move the ApertureTube onto the specific slot of coulter counter instrument.",
			Headers -> {"ApertureTube", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		MeasurementContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the MeasurementContainers onto the specific slot of coulter counter instrument.",
			Headers -> {"MeasurementContainer", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		FirstMeasurementContainerPlacement -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "The placement used to move the first MeasurementContainer onto the specific slot of coulter counter instrument.",
			Headers -> {"MeasurementContainer", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		SuitabilityMeasurementContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the SuitabilityMeasurementContainers onto the specific slot of coulter counter instrument.",
			Headers -> {"MeasurementContainer", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		(*------------------------------Refilling------------------------------*)
		ElectrolyteSolutionRefillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter,
			Description -> "The amount of volume of electrolyte solution that is to be transferred to the ElectrolyteSolutionContainer of the coulter counter instrument.",
			Category -> "Refilling",
			Developer -> True
		},
		ElectrolyteSolutionRecurringRefillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter,
			Description -> "The amount of volume of electrolyte solution that is used to refill the ElectrolyteSolutionContainer of the coulter counter instrument if it is empty.",
			Category -> "Refilling",
			Developer -> True
		},
		(*------------------------------Experimental Results------------------------------*)
		SuitabilityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The data of the size standards during the 1st round of system suitability check.",
			Category -> "Experimental Results",
			AdminWriteOnly -> True
		},
		BlankSuitabilityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The blank data during the 1st round of system suitability check.",
			Category -> "Experimental Results",
			AdminWriteOnly -> True
		},
		RepeatedSuitabilityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The data of the size standards during the 2nd round of system suitability check.",
			Category -> "Experimental Results",
			AdminWriteOnly -> True
		},
		RepeatedBlankSuitabilityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The blank data during the 2nd round of system suitability check.",
			Category -> "Experimental Results",
			AdminWriteOnly -> True
		},
		(* Quantification *)
		QuantifyConcentrations -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> WorkingSamples,
			Description -> "For each member of WorkingSamples, indicates if the concentration of the samples should be determined.",
			Category -> "Analysis & Reports"
		},
		(* Maintenance *)
		ApertureTubeCalibrationModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Maintenance, CalibrateApertureTube],
			Developer -> True,
			Description -> "The maintenance model to be used for re-calibrate aperture tube if the 1st system suitability check fails.",
			Category -> "Qualifications & Maintenance"
		},
		(* Cleaning *)
		CleaningPrepPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions to prepare the cleaning solution to flush the coulter counter instrument during instrument tear down.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];



