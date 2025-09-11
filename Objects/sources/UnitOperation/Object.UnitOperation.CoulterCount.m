(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, CoulterCount], {
	Description -> "A detailed set of parameters that specifies the measurement of counting and sizing particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*------------------------------General------------------------------*)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], Object[Sample],
				Model[Container], Object[Container]
			],
			Description -> "The input sample(s) to be counted and sized by the electrical resistance measurement.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The input sample(s) to be counted and sized by the electrical resistance measurement.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The input sample(s) to be counted and sized by the electrical resistance measurement.",
			Category -> "General",
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source container that are used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, CoulterCounter] | Object[Instrument, CoulterCounter],
			Description -> "The instrument that is used to count and size particles in a sample by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities.",
			Category -> "General",
			Abstract -> True
		},
		ApertureTube -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, ApertureTube] | Object[Part, ApertureTube],
			Description -> "A glass tube with a small aperture near the bottom through which particles are pumped to perturb the electrical resistance within the aperture for particle sizing and counting. The diameter of the aperture used for the electrical resistance measurement dictates the accessible window for particle size measurement, which is generally 2-80% of the ApertureDiameter.",
			Category -> "General"
		},
		ApertureDiameter -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "The desired diameter of the aperture used for the electrical resistance measurement, which dictates the accessible window for particle size measurement, which is generally 2-80% of the ApertureDiameter.",
			Category -> "General",
			Abstract -> True
		},
		ElectrolyteSolutionLink -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The conductive solution used to suspend the particles to be counted and sized. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive. Please choose a sample solution with a solvent that does not dissolve or damage the target analyte particles to be counted and sized and an electrolyte chemical that maximizes the conductivity of the overall solution.",
			Category -> "General",
			Migration -> SplitField
		},
		ElectrolyteSolutionString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The conductive solution used to suspend the particles to be counted and sized. The electrolyte solution generally contains an aqueous or organic solvent and an electrolyte chemical to make the solution conductive. Please choose a sample solution with a solvent that does not dissolve or damage the target analyte particles to be counted and sized and an electrolyte chemical that maximizes the conductivity of the overall solution.",
			Category -> "General",
			Migration -> SplitField
		},
		(*------------------------------Flushing aperture tube------------------------------*)
		ElectrolyteSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of the electrolyte solution to be added into the ElectrolyeSolutionContainer of the coulter counter instrument. The amount added here supplies a reservoir of clean electrolyte solution that is pumped to flush the aperture tube before and after sample runs to remove particles that may remain trapped in the bottom of the aperture tube. The minimum amount needed to avoid drawing air into the system is 50 Milliliter.",
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
		(*------------------------------System suitability check------------------------------*)
		SystemSuitabilityCheck -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a system suitability check with a particle size standard sample is run prior to the actual sample runs. During system suitability check, one or more size standard samples with known mean diameters or volumes are loaded into the instrument and sized via electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance. A discrepancy above SystemSuitabilityTolerance triggers the size-calibration procedure of the instrument to obtain a new calibration constant for the aperture tube. Afterwards, the system suitability check will automatically rerun to check if system suitability is restored. Calibration is triggered only once. If system suitability is not restored after calibration, SystemSuitabilityError is set to True in the protocol object and if AbortOnSystemSuitabilityCheck is set to True, the experiment run will abort without collecting additional data.",
			Category -> "System Suitability Check"
		},
		SystemSuitabilityTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The largest size discrepancy between the measured mean diameter and the manufacture-labelled mean diameter or the measured mean volume and the manufactured-labelled mean volume of SuitabilitySizeStandard sample(s) when sized by electrical resistance measurement to pass the system suitability check. A discrepancy above SystemSuitabilityTolerance triggers the size-calibration procedure of the instrument to obtain a new calibration constant for the aperture tube. Afterwards, the system suitability check will automatically rerun to check if system suitability is restored. Calibration is triggered only once. If system suitability is not restored after calibration, SystemSuitabilityError is set to True in the protocol object and if AbortOnSystemSuitabilityCheck is set to True, the experiment run will abort without collecting additional data.",
			Category -> "System Suitability Check"
		},
		SuitabilitySizeStandardLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The particle size standard samples with known mean diameters or volumes used for the checking the system suitability. These standard samples are typically NIST traceable monodisperse polystyrene beads with sizes precharacterized by other standard techniques such as optical microscopy and transmission electron microscopy (TEM). Each of the samples is loaded into the instrument and sized by electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance.",
			Category -> "System Suitability Check",
			Migration -> SplitField
		},
		SuitabilitySizeStandardString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The particle size standard samples with known mean diameters or volumes used for the checking the system suitability. These standard samples are typically NIST traceable monodisperse polystyrene beads with sizes precharacterized by other standard techniques such as optical microscopy and transmission electron microscopy (TEM). Each of the samples is loaded into the instrument and sized by electrical resistance measurement individually. The system is considered suitable when the measured mean diameter matches the manufacture-labelled mean diameter or the measured mean volume matches the manufacture-labelled mean volume within SystemSuitabilityTolerance.",
			Category -> "System Suitability Check",
			Migration -> SplitField
		},
		SuitabilityParticleSize -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Millimeter] | GreaterP[0 Millimeter^3],
			Units -> None,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the manufacture-labeled mean diameter or volume of the particle size standard samples used for the system suitability check. The system is considered suitable when the measured mean particle diameter or volume matches SuitabilityParticleSize.",
			Category -> "System Suitability Check"
		},
		(*------------------------------options for sample prep and measurement parameters for system suitability check------------------------------*)
		SuitabilityTargetConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Molar],
				GreaterEqualP[0 EmeraldCell / Milliliter],
				GreaterEqualP[0 Particle / Milliliter],
				GreaterEqualP[0 Gram / Liter]
			],
			Units -> None,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the target particle concentration in the solution from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume in SuitabilityMeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) becomes severe if SuitabilityTargetConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume.",
			Category -> "System Suitability Check"
		},
		SuitabilitySampleAmount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the amount of SuitabilitySizeStandard sample(s) to be mixed with the electrolyte solution to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityElectrolyteSampleDilutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the amount of the electrolyte solution to be mixed with the SuitabilitySizeStandard sample(s) to create a particle suspension which is sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityElectrolytePercentage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the desired ratio of the volume of the electrolyte solution to the total volume in the sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the SuitabilityMeasurementContainer.",
			Category -> "System Suitability Check"
		},
		SuitabilityMeasurementContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the container that holds the SuitabilitySizeStandard sample-electrolyte solution mixture during mixing and electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check",
			Migration -> SplitField
		},
		SuitabilityMeasurementContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the container that holds the SuitabilitySizeStandard sample-electrolyte solution mixture during mixing and electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check",
			Migration -> SplitField
		},
		SuitabilityDynamicDilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, indicates if additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture from mixing SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the SuitabilitySizeStandard sample-electrolyte solution with ElectrolyteSolution according to SuitabilityConstantDynamicDilutionFactor or SuitabilityCumulativeDynamicDilutionFactor and loaded for measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or SuitabilityMaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution mixture is already within the suitable range even when SuitabilityDynamicDilute is set to True.",
			Category -> "System Suitability Check"
		},
		SuitabilityConstantDynamicDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the constant factor by which the particle concentration in the SuitabilitySizeStandard sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
			Category -> "System Suitability Check"
		},
		SuitabilityCumulativeDynamicDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the factor by which the particle concentration in the original SuitabilitySizeStandard sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in SuitabilityMaxNumberOfDynamicDilutions.",
			Category -> "System Suitability Check"
		},
		SuitabilityMaxNumberOfDynamicDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, max number of times for which the SuitabilitySizeStandard sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the duration that the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then sized by electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
			Units -> None,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the rotation speed of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability. If SuitabilityMixRate is set to 0 RPM, the integrated stirrer will be put outside the SuitabilityMeasurementContainer and no mixing of the solution in SuitabilityMeasurementContainer is performed.",
			Category -> "System Suitability Check"
		},
		SuitabilityMixDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Clockwise | Counterclockwise,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the rotation direction of the integrated stirrer to mix the SuitabilitySampleAmount and SuitabilityElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement for the purpose of checking the system suitability.",
			Category -> "System Suitability Check"
		},
		NumberOfSuitabilityReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the number of times to perform identical system suitability runs on each SuitabilitySizeStandard sample-electrolyte solution mixture that is loaded into the instrument. Each of the system suitability runs is performed on the same sample-electrolyte solution mixture without reloading the instrument.",
			Category -> "System Suitability Check"
		},
		NumberOfSuitabilityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[2, 1],
			Description -> "For each member of SuitabilitySizeStandardLink, the number of replicate SuitabilitySizeStandard sample-electrolyte solution mixtures to prepare from mixing SuitabilitySizeStandard with ElectrolyteSolution. Each of the replicate mixture is loaded into the instrument individually with NumberOfSuitabilityReadings of system suitability runs performed.",
			Category -> "System Suitability Check"
		},
		SuitabilityApertureCurrent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microampere],
			Units -> Microampere,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the value of the constant current that passes through the aperture of the ApertureTube during the system suitability run in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube. If measuring cellular particles, current set too high can damage the particles due to Joule heating.",
			Category -> "System Suitability Check"
		},
		SuitabilityGain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the amplification factor applied to the recorded voltage pulse during the system suitability run. Increasing the gain increases the signal and noise level simultaneously.",
			Category -> "System Suitability Check"
		},
		SuitabilityFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the target volume of the SuitabilitySizeStandard sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the system suitability run.",
			Category -> "System Suitability Check"
		},
		MinSuitabilityParticleSize -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
			Units -> None,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, only particles with diameters or volumes greater than or equal to MinSuitabilityParticleSize are counted towards the SuitabilityTotalCount during the system suitability run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
			Category -> "System Suitability Check"
		},
		MinSuitabilityPulseIntensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Volt],
			Units -> Millivolt,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, only the voltage pulses with peak intensities greater than or equal to MinSuitabilityPulseIntensity are counted towards the SuitabilityTotalCount during the system suitability run. The voltage pulses are generated by particles passing through the aperture of the ApertureTube where the voltage intensity is proportional to the volume of the particle (see Figure 1.3 in the documentation of ExperimentCoulterCount).",
			Category -> "System Suitability Check"
		},
		SuitabilityEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, duration of time before counting the voltage pulses towards the SuitabilityTotalCount after the SuitabilitySizeStandard sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to SuitabilityFlowRate during SuitabilityEquilibrationTime to reduce the noise level during the pulse recording.",
			Category -> "System Suitability Check"
		},
		SuitabilityStopCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoulterCounterStopConditionP,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, indicates if the system suitability run of the SuitabilitySizeStandard sample-electrolyte solution mixture concludes based on Time, Volume, TotalCount, or ModalCount for each SuitabilitySizeStandard. In Time mode the system suitability run is performed until SuitabilityRunTime has elapsed. In Volume mode the system suitability run is performed until SuitabilityRunVolume of the sample from the SuitabilityMeasurementContainer has passed through the aperture of the ApertureTube. In TotalCount mode the system suitability run is performed until SuitabilityTotalCount of particles are counted in total. In ModalCount mode the system suitability run is performed until number of particles with sizes that appear most frequently exceeds SuitabilityModalCount. Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
			Category -> "System Suitability Check"
		},
		SuitabilityRunTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, duration of time of to perform the system suitability run to count and size particles. SuitabilityEquilibrationTime is not included in SuitabilityRunTime.",
			Category -> "System Suitability Check"
		},
		SuitabilityRunVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, the volume of the sample to pass through the aperture of the ApertureTube by the end of the system suitability run.",
			Category -> "System Suitability Check"
		},
		SuitabilityTotalCount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, target total number of particles to be counted by the end of the system suitability run.",
			Category -> "System Suitability Check"
		},
		SuitabilityModalCount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, target number of particles with sizes that appear most frequently to be counted by the end of the system suitability run.",
			Category -> "System Suitability Check"
		},
		(*------------------------------options for AnalyzePeaks to get model/mean diameter/volume------------------------------*)
		SuitabilityParticleSizeDomain -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{
					GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
					GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3]
				},
				NullP
			],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, only peaks in the measured particle size distribution whose peak range lies inside the specified domain interval are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityAbsoluteThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, only peaks in the measured particle size distribution whose maximum count is greater than or equal to this threshold are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityRelativeThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, only peaks in the measured particle size distribution whose maximum count with its baseline subtracted is greater than or equal to this threshold are detected by AnalyzePeaks analysis to obtain the mean diameter or volume within the peak range during system suitability check.",
			Category -> "System Suitability Check"
		},
		SuitabilityBaseline -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				LocalConstant,
				LocalLinear,
				DomainConstant,
				DomainLinear,
				DomainNonlinear,
				EndpointLinear,
				GlobalConstant,
				GlobalLinear,
				GlobalNonlinear
			],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, method used to compute peak baselines in the measured particle size distribution. The baseline affects a peak's height and area. The baseline is fit to the points inside the SuitabilityParticleSizeDomain that are not part of any peak.",
			Category -> "System Suitability Check"
		},
		SuitabilityBaselineFeatureWidth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			IndexMatching -> SuitabilitySizeStandardLink,
			Description -> "For each member of SuitabilitySizeStandardLink, when SuitabilityBaseline is set to DomainNonlinear, a parameter that sets the width of variations in the data above which it is followed by the fitted baseline function. Smaller SuitabilityBaselineFeatureWidth includes more features in baseline and makes baseline curvier. Larger SuitabilityBaselineFeatureWidth prunes more features from the baseline and makes it flatter. See section 'Options/BaselineFeatureWidth' in AnalyzePeaks for examples. Internally, method 'DomainNonlinear' uses Mathematica function EstimatedBackground with the setting to SuitabilityBaselineFeatureWidth determining the scale 'sigma'.",
			Category -> "System Suitability Check"
		},
		AbortOnSystemSuitabilityCheck -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the experiment is aborted early if system suitability check fails. Aborted experiments will not prepare the SamplesIn and will only consume the SuitabilitySizeStandard samples. If AbortOnSystemSuitabilityCheck is set to False, the experiment will continue to the end. If system suitability check fails, SystemSuitabilityError is set to True in the protocol and data object. Note that data obtained with SystemSuitabilityError marked True may provide less size accuracy therefore should be interpreted with caution.",
			Category -> "System Suitability Check"
		},
		(*------------------------------Dilution------------------------------*)
		Dilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if preloading dilution or serial dilution is performed on each member of SamplesIn before mixing with electrolyte solution for electrical resistance measurement.",
			Abstract -> True,
			Category -> "Sample Dilution"
		},
		DilutionType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionTypeP, (* Serial | Linear *)
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates the type of dilution performed. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration. The progression can be described by either a series of target concentrations or a series of dilution factors. In a serial dilution the source of a dilution round is the resulting sample of the previous dilution round. The first source sample is the original sample provided.",
			Category -> "Sample Dilution"
		},
		DilutionStrategy -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionStrategyP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if only the final sample (EndPoint) or all diluted samples (Series) produced by serial dilution are used for following electrical resistance measurement. If set to Series, sample loading and electrical resistance measurement options are automatically expanded to be the same across all diluted samples, while TargetMeasurementConcentration and DiluentPercent options are not expanded to ensure the electrolyte concentration is the same across all sample-electrolyte solution mixtures prepared from diluted samples.",
			Category -> "Sample Dilution"
		},
		(*------------------------------Dilution options + Mix------------------------------*)
		NumberOfDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of diluted samples to prepare.",
			Category -> "Sample Dilution"
		},
		TargetAnalyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the component in the Composition of the input sample whose concentration is being reduced to TargetAnalyteConcentration.",
			Category -> "Sample Dilution"
		},
		CumulativeDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution.",
			Category -> "Sample Dilution"
		},
		SerialDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced.",
			Category -> "Sample Dilution"
		},
		TransferVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to LinearDilution, the amount of sample that is diluted with Buffer. If DilutionType is set to Serial, the amount of sample transferred from the resulting sample of one round of the dilution series to the next sample in the series. The first transfer source is the original sample provided.",
			Category -> "Sample Dilution"
		},
		TotalDilutionVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the total volume of sample, buffer, concentrated buffer, and concentrated buffer diluent. If DilutionType is set to Serial, this is also the volume of the resulting sample before TransferVolume has been removed for use in the next dilution in the series.",
			Category -> "Sample Dilution"
		},
		FinalVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Serial, the volume of the resulting diluted sample after TransferVolume has been removed for use in the next dilution in the series. To control the volume of the final sample in the series, see the DiscardFinalTransfer option.",
			Category -> "Sample Dilution"
		},
		DiscardFinalTransfer -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is Serial, indicates if, after the final dilution is complete, TransferVolume should be removed from the final dilution container.",
			Category -> "Sample Dilution"
		},
		DiluentLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the solution used to reduce the concentration of the sample.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		DiluentString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the solution used to reduce the concentration of the sample.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		DiluentVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of diluent added to dilute the sample. If DilutionType is set to Serial, the amount of diluent added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of concentrated buffer added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferDiluentLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		ConcentratedBufferDiluentString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		ConcentratedBufferDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the factor by which to reduce ConcentratedBuffer before it is combined with the sample. The length of this list must match the corresponding value in NumberOfDilutions.",
			Category -> "Sample Dilution"
		},
		ConcentratedBufferDiluentVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Milliliter]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of concentrated buffer diluent added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer diluent added to dilute the sample at each stage of the dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, indicates if the sample is incubated following the dilution. If DilutionType is set to Serial, indicates if the resulting sample after a round of dilution is incubated before moving to the next stage in the dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the duration of time for which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the duration of time for which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives @@ Join[MixInstrumentModels, MixInstrumentObjects],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the instrument used to mix/incubate the sample following the dilution. If DilutionType is set to Serial, the instrument used to mix/incubate the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionIncubationTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		DilutionIncubationTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
			Category -> "Sample Dilution",
			Migration -> SplitField
		},
		DilutionMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MixTypeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the style of motion used to mix the sample following the dilution. If DilutionType is set to Serial, the style of motion used to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the number of times the sample is mixed following the dilution. If DilutionType is set to Serial, the number of times the resulting sample after a round of dilution is mixed before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionMixRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
			Units -> None,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the frequency of rotation the mixing instrument should use to mix the sample following the dilution. If DilutionType is set to Serial, the frequency of rotation the mixing instrument should use to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		DilutionMixOscillationAngle -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 AngularDegree],
			Units -> AngularDegree,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, if DilutionType is set to Linear, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the sample following the dilution. If DilutionType is set to Serial, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the resulting sample after a round of dilution before the next stage of dilution.",
			Category -> "Sample Dilution"
		},
		(*------------------------------Sample loading ------------------------------*)
		TargetMeasurementConcentration -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Molar],
				GreaterEqualP[0 EmeraldCell / Milliliter],
				GreaterEqualP[0 Particle / Milliliter],
				GreaterEqualP[0 Gram / Liter]
			],
			Units -> None,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the target particle concentration in the solution from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume in MeasurementContainer. The coincident particle passage effect (multiple particles passing through the aperture of the ApertureTube at approximately the same time to be registered as one larger particle) becomes severe if TargetMeasurementConcentration is set too high, leading to a decrease in the accuracy of the measured particle size distribution and measured mean particle diameter or volume. When using all dilution samples for the experiment by with DilutionStrategy set to All, TargetMeasurementConcentration refers to the target particle concentration from mixing the last dilution sample and ElectrolyteSampleDilutionVolume in MeasurementContainer.",
			Category -> "Sample Loading"
		},
		SampleAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[
				GreaterEqualP[0 Milliliter],
				GreaterEqualP[0 Milligram]
			],
			Units -> None,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the amount of the prepared sample(s) to be mixed with the electrolyte solution to create a particle suspension which is counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		ElectrolyteSampleDilutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the amount of the electrolyte solution to be mixed with the prepared sample(s) to create a particle suspension which is counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		ElectrolytePercentage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the desired ratio of the volume of the electrolyte solution to the total volume in the sample-electrolyte solution mixture obtained from mixing the prepared sample(s) and the electrolyte solution in the MeasurementContainer.",
			Category -> "Sample Loading"
		},
		MeasurementContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel] | Model[Container, Vessel],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that holds the sample-electrolyte solution mixture during mixing and electrical resistance measurement.",
			Category -> "Sample Loading",
			Migration -> SplitField
		},
		MeasurementContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that holds the sample-electrolyte solution mixture during mixing and electrical resistance measurement.",
			Category -> "Sample Loading",
			Migration -> SplitField
		},
		DynamicDilute -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture from mixing SampleAmount of prepared sample(s) and ElectrolyteSampleDilutionVolume is overly concentrated for measurement. A new diluted sample is prepared by mixing the sample-electrolyte solution with ElectrolyteSolution according to ConstantDynamicDilutionFactor or CumulativeDynamicDilutionFactor and loaded for quick preview-type measurement. If Oversaturated error persists, additional rounds of dilutions are performed until the Oversaturated error disappears or MaxNumberOfDynamicDilutions is met. Note that no additional dilution is performed if the particle concentration in the sample-electrolyte solution mixture is already within the suitable range even when DynamicDilute is set to True.",
			Category -> "Sample Loading"
		},
		ConstantDynamicDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the constant factor by which the particle concentration in the sample-electrolyte solution is reduced with respect to the previous dilution step during each additional dilution step.",
			Category -> "Sample Loading"
		},
		CumulativeDynamicDilutionFactor -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]...} | NullP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the factor by which the particle concentration in the original sample-electrolyte solution is reduced during each additional dilution step. The length of this list must match the corresponding value in MaxNumberOfDynamicDilutions.",
			Category -> "Sample Loading"
		},
		MaxNumberOfDynamicDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, max number of times for which the sample-electrolyte solution is diluted, in an attempt to reduce the particle concentration to the suitable range for measurement.",
			Category -> "Sample Loading"
		},
		MixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration that the SampleAmount and ElectrolyteSampleDilutionVolume is mixed by the integrated stirrer of the instrument in order to make a well-mixed suspension. The suspension is then counted and sized by electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		MixRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
			Units -> None,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the rotation speed of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement. If MixRate is set to 0 RPM, the integrated stirrer will be put outside the MeasurementContainer and no mixing of the solution in MeasurementContainer is performed.",
			Category -> "Sample Loading"
		},
		MixDirection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Clockwise | Counterclockwise,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the rotation direction of the integrated stirrer to mix the SampleAmount and ElectrolyteSampleDilutionVolume before electrical resistance measurement, and maintain the mixture in an equilibrated suspension during electrical resistance measurement.",
			Category -> "Sample Loading"
		},
		(*------------------------------Measurement set up------------------------------*)
		NumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of times to perform identical sample runs to record voltage pulses on each sample-electrolyte solution mixture that is loaded into the instrument. Each of the sample run is performed on the same sample-electrolyte solution without reloading the instrument.",
			Category -> "Electrical Resistance Measurement"
		},
		ApertureCurrent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microampere],
			Units -> Microampere,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the value of the constant current that passes through the aperture of the ApertureTube during pulse recording in order to measure the momentary electrical resistance change per particle passage through the aperture of the ApertureTube.",
			Category -> "Electrical Resistance Measurement"
		},
		Gain -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the amplification factor applied to the recorded voltage pulse during the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		FlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter / Second],
			Units -> Microliter / Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the target volume of the sample-electrolyte solution mixture pumped through the aperture of the ApertureTube per unit time during the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		MinParticleSize -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 Millimeter] | GreaterEqualP[0 Millimeter^3],
			Units -> None,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, only particles with diameters or volumes larger than or equal to MinParticleSize are counted towards the TotalCount during the sample run. The conversion between volume and diameter assumes each particle is a perfect solid sphere.",
			Category -> "Electrical Resistance Measurement"
		},
		MinPulseIntensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Volt],
			Units -> Millivolt,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, only the voltage pulses with peak intensities larger than or equal to MinPulseIntensity are counted towards the TotalCount during the sample run. The voltage pulses are generated by particles passing through the aperture of the ApertureTube where the voltage intensity is proportional to the volume of the particle.",
			Category -> "Electrical Resistance Measurement"
		},
		EquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, duration of time before counting the voltage pulses towards the TotalCount after the sample-electrolyte solution mixture begins pumping through the aperture of the ApertureTube. The flow rate is stabilized to FlowRate during EquilibrationTime to reduce the noise level during the pulse recording.",
			Category -> "Electrical Resistance Measurement"
		},
		StopCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoulterCounterStopConditionP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the sample run of the sample-electrolyte solution mixture concludes based on Time, Volume, TotalCount, or ModalCount. In Time mode the sample run is performed until RunTime has elapsed. In Volume mode the sample run is performed until RunVolume of the sample from the MeasurementContainer has passed through the aperture of the ApertureTube. In TotalCount mode the sample run is performed until TotalCount of particles are counted in total. In ModalCount mode the sample run is performed until number of particles with sizes that appear most frequently exceeds ModalCount. Volume mode is not applicable for ApertureDiameter greater than 360 Micrometer.",
			Category -> "Electrical Resistance Measurement"
		},
		RunTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, duration of time of to perform one sample run to count and size particles in the sample-electrolyte solution mixture. EquilibrationTime is not included in RunTime.",
			Category -> "Electrical Resistance Measurement"
		},
		RunVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the volume of the sample to pass through the aperture of the ApertureTube by the end of the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		TotalCount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, target total number of particles to be counted by the end of the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		ModalCount -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, target number of particles with sizes that appear most frequently to be counted by the end of the sample run.",
			Category -> "Electrical Resistance Measurement"
		},
		QuantifyConcentration -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the concentration of the sample is determined.",
			Category -> "Quantification"
		},
		(*------------------------------Post-experiment------------------------------*)
		ElectrolyteSolutionStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "The condition under which any unused electrolyte solution in the ElectrolyteSolutionContainer of the instrument should be stored after the protocol is completed.",
			Category -> "Sample Post-Processing"
		}
	}
}];



