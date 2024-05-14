

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, MeltingCurve], {
	Description->"Measurements of absorbance, fluorescence, static light scattering, and/or dynamic light scattering at specific wavelengths with varying temperatures.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of the buffer used to dilute the sample(s) in the cuvette prior to the absorbance measurement.",
			Category -> "General"
		},
		DetectionReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample],
				Object[Sample]
			],
			Description -> "The fluorescent reagent used to detect temperature dependent structural changes in the analyte.",
			Category -> "General"
		},
		PassiveReferenceDye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample],
				Object[Sample]
			],
			Description -> "The fluorescent reagent which does not interact with the analyte and is used to normalize fluorescence emission measurements.",
			Category -> "General"
		},
		DilutionCurve -> {
			Format-> Multiple,
			Class-> Link,
			Pattern:> _Link,
			Relation-> Object[Data, MeltingCurve][DilutionCurve],
			Description -> "The data acquired for a single analyte at different dilutions.",
			Category-> "Method Information"
		},
		(*Absorbance specific fields*)
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the emission monochromator used for filtering the source light.",
			Category -> "General",
			Abstract -> True
		},
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The lower limit of the wavelength range over which sample absorbance is read.",
			Category -> "Optical Information",
			Abstract -> True
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The upper limit of the wavelength range over which sample absorbance is read.",
			Category -> "Optical Information",
			Abstract -> True
		},
		Bandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Nano,
			Description -> "The width of the light surrounding Wavelength which the monochromator does not filter out.",
			Category -> "General"
		},
		AveragingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the diode reading is averaged when detecting emission signal.",
			Category -> "General"
		},
		CuvetteModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Cuvette],
			Description -> "The model of the cuvette containing the sample(s) and through which the light beam is passed during the absorbance measurement.",
			Category -> "General"
		},
		CuvetteNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The position of the sample's cuvette inside the heatblock of the spectrophotometer instrument during absorbance measurement.",
			Category -> "General"
		},
		(*Fluorescence specific fields*)
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the fluorescent detection reagent.",
			Category -> "General",
			Abstract -> True
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light emitted by the fluorescence detection reagent upon excitation and measured by the fluorescence detector.",
			Category -> "General",
			Abstract -> True
		},
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description ->  "The minimum wavelength of light emitted by the fluorescence detection reagent upon excitation and measured by the fluorescence detector.",
			Category -> "General"
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description ->  "The maximum emission wavelength collected during the experiment.",
			Category -> "General"
		},
		Well -> {
			Format-> Single,
			Class-> String,
			Pattern:> WellP,
			Description -> "The well position of this sample in the assay plate during measurement.",
			Category-> "Method Information"
		},
		(*UNcle specific fields*)
		FluorescenceLaserPower-> {
			Format-> Single,
			Class -> Expression,
			Pattern:> LaserPowerFilterP,
			Description -> "The percentage of full power the 266nm UV laser operated at during measurement.",
			Category -> "General"
		},
		StaticLightScatteringLaserPower-> {
			Format -> Single,
			Class-> Expression,
			Description -> "The percentage of full power the 473nm Blue laser operated at during measurement.",
			Pattern :> LaserPowerFilterP,
			Category -> "General"
		},
		OptimizeFluorescenceLaserPower -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the fluorescence laser power filter is adjusted prior to sample measurement.",
			Category-> "Detection"
		},
		OptimizeStaticLightScatteringLaserPower -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the static light scattering laser power filter is matched to the optimal fluorescence laser power prior to sample measurement.",
			Category-> "Detection"
		},
		LaserOptimizationEmissionWavelengthRange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {GreaterP[0*Nanometer]..},
			Description -> "The wavelength(s) of the sample's spectra used to evaluate optimal laser setting.",
			Category-> "Detection"
		},
		LaserOptimizationTargetEmissionIntensityRange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "The intensity range, expressed as a counts, used to evaluate optimal laser setting.",
			Category-> "Detection"
		},
		FluorescenceLaserPowerOptimizationResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LaserOptimizationResultP,
			Description -> "Indicates if the fluorescence laser power filter optimization was successful. \"FailureLowSignal\" indicates the laser power could not be optimized because signal intensity at 100% laser power is lower than the LaserOptimizationTargetEmissionIntensityRange. \"FailureSignalSaturation\" indicates the laser power could not be optimized because signal intensity at 13% laser power is higher than the LaserOptimizationTargetEmissionIntensityRange.",
			Category-> "Detection"
		},
		StaticLightScatteringExcitation->{
			Format -> Multiple,
			Class-> Real,
			Description-> "The wavelength(s) used for static light scattering measurements.",
			Pattern:>GreaterP[0*NanoMeter],
			Units->Nanometer,
			Category-> "Method Information"
		},
		CapillaryWell -> {
			Format-> Single,
			Class-> String,
			Pattern:> WellP,
			Description -> "The capillary well position of this sample during measurement.",
			Category-> "Method Information"
		},
		CapillaryStrip -> {
			Format-> Single,
			Class-> Link,
			Pattern:> _Link,
			Relation -> Object[Container, Plate, CapillaryStrip],
			Description -> "The capillary strip position of this sample during measurement.",
			Category-> "Method Information"
		},

		(*===Experimental Results===*)

		MeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the first heating cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		CoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the first cooling cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SecondaryMeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the second heating cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		SecondaryCoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the second cooling cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		TertiaryMeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the third heating cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		TertiaryCoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units->{Celsius,ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the third cooling cycle If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		QuaternaryMeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, ArbitraryUnit}..}],
			Units -> {Celsius, ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the fourth heating cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		QuaternaryCoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, ArbitraryUnit}..}],
			Units -> {Celsius, ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the fourth cooling cycle If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		QuinaryMeltingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, ArbitraryUnit}..}],
			Units -> {Celsius, ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the fourth heating cycle. If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		QuinaryCoolingCurve -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, ArbitraryUnit}..}],
			Units -> {Celsius, ArbitraryUnit},
			Description -> "The measurement signal as a function of temperature during the fourth cooling cycle If MinWavelength and MaxWavelength are specified, the wavelength for this field will be 280 Nanometer if within the range and the sample is a peptide, 260 Nanometer if the sample is not a peptide and this value is within the MinWavelength/MaxWavelength range, or the MinWavelength otherwise.",
			Category -> "Experimental Results"
		},
		MeltingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the first heating cycle.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		CoolingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the first cooling cycle.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SecondaryMeltingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the second heating cycle.",
			Category -> "Experimental Results"
		},
		SecondaryCoolingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the second cooling cycle.",
			Category -> "Experimental Results"
		},
		TertiaryMeltingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the third heating cycle.",
			Category -> "Experimental Results"
		},
		TertiaryCoolingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units->{Celsius,Nanometer,ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the third cooling cycle.",
			Category -> "Experimental Results"
		},
		QuaternaryMeltingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, Nanometer, ArbitraryUnit}..}],
			Units -> {Celsius, Nanometer, ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the fourth heating cycle.",
			Category -> "Experimental Results"
		},
		QuaternaryCoolingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, Nanometer, ArbitraryUnit}..}],
			Units -> {Celsius, Nanometer, ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the fourth cooling cycle.",
			Category -> "Experimental Results"
		},
		QuinaryMeltingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, Nanometer, ArbitraryUnit}..}],
			Units -> {Celsius, Nanometer, ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the fifth heating cycle.",
			Category -> "Experimental Results"
		},
		QuinaryCoolingCurve3D -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Celsius, Nanometer, ArbitraryUnit}..}],
			Units -> {Celsius, Nanometer, ArbitraryUnit},
			Description -> "The measurement signal at each wavelength for each temperature point during the fifth cooling cycle.",
			Category -> "Experimental Results"
		},
		(*Static light scattering specific experimental results*)
		AggregationCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the first heating cycle.",
			Category-> "Experimental Results"
		},
		AggregationRecoveryCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the first cooling cycle.",
			Category->"Experimental Results"
		},
		SecondaryAggregationCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the second heating cycle.",
			Category-> "Experimental Results"
		},
		SecondaryAggregationRecoveryCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the second cooling cycle.",
			Category->"Experimental Results"
		},
		TertiaryAggregationCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the third heating cycle.",
			Category-> "Experimental Results"
		},
		TertiaryAggregationRecoveryCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the third cooling cycle.",
			Category->"Experimental Results"
		},
		AggregationCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of increasing temperature during the first heating cycle.",
			Category->"Experimental Results"
		},
		AggregationRecoveryCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of decreasing temperature during the first cooling cycle.",
			Category->"Experimental Results"
		},
		SecondaryAggregationCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of increasing temperature during the second heating cycle.",
			Category->"Experimental Results"
		},
		SecondaryAggregationRecoveryCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of decreasing temperature during the second cooling cycle.",
			Category->"Experimental Results"
		},
		TertiaryAggregationCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of increasing temperature during the third heating cycle.",
			Category->"Experimental Results"
		},
		TertiaryAggregationRecoveryCurve3D->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer,ArbitraryUnit}..}],
			Units-> {Celsius,Nanometer, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) at each wavelength as a function of decreasing temperature during the third cooling cycle.",
			Category->"Experimental Results"
		},

		(* -- DLS Fields -- *)
		DynamicLightScattering->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a DLS measurement of each sample is made before and after the thermal ramping.",
			Category->"Experimental Results"
		},
		DynamicLightScatteringMeasurements->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[
				Before,
				After
			],
			Description->"Indicates if a DLS measurement of each sample is made before thermal ramping, after thermal ramping, or both before and after thermal ramping.",
			Category->"Experimental Results"
		},
		NumberOfDynamicLightScatteringAcquisitions->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each DLS measurement, the number of series of speckle patterns that are each collected over the AcquisitionTime to create the measurement's autocorrelation curve.",
			Category -> "Experimental Results"
		},
		DynamicLightScatteringAcquisitionTime->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each DLS measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
			Category -> "Experimental Results"
		},
		AutomaticDynamicLightScatteringLaserSettings->{
			Format -> Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the DynamicLightScatteringLaserPower and DynamicLightScatteringDiodeAttenuation are automatically set at the beginning of the assay by the Instrument to levels ideal for the samples.",
			Category->"Experimental Results"
		},
		DynamicLightScatteringLaserPower->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The percent of the max dynamic light scattering laser power that is used to make DLS measurements. The laser level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and LaserLevel is Null.",
			Category -> "Experimental Results"
		},
		DynamicLightScatteringDiodeAttenuation->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The percent of scattered light signal that is allowed to reach the avalanche photodiode for DLS measurements. The attenuator level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and DiodeAttenuation is Null.",
			Category -> "Experimental Results"
		},
		InitialDynamicLightScatteringTemperature->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the particle DLS is measured before thermal ramping.",
			Category -> "Experimental Results"
		},
		InitialZAverageDiameter->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description -> "The average hydrodynamic diameter of particles in solution for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialZAverageDiffusionCoefficient->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*(Meter*Meter/Second)],
			Units->(Meter*Meter/Second),
			Description -> "Diffusion coefficeint calculated from the CorrelationCurve which is inversely proportional to particle size, for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialDiameterStandardDeviation->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description -> "The standard deviation of the ZAverageDiameter for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialPolydispersityIndex->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "A measure of the heterogeneity of the calculated hydrodynamic diameters of particles in solution for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialScatteredLightIntensity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "The amount of light that reaches the scattered light detector in counts per second for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialCorrelationCurve->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Micro*Second,ArbitraryUnit}],
			Units -> {Micro*Second, ArbitraryUnit},
			Description -> "A series of data points which describes the correlation between scattered light intensity over time for the sample for the DLS measurement before thermal ramping. This correlation typically decays from 1 to 0 over time.",
			Category->"Experimental Results"
		},
		InitialCorrelationCurveFitVariance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "A measure of the fit of multiple exponential decay function to the measured CorrelationCurve for the DLS measurement before thermal ramping.",
			Category->"Experimental Results"
		},
		InitialIntensityDistribution->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
			Units -> {Nanometer, ArbitraryUnit},
			Description -> "Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution for the DLS measurement before thermal ramping. Since larger particles scatter more light, larger particles have a higher scattered light intensity per particle in the IntensityDistribution.",
			Category->"Experimental Results"
		},
		InitialMassDistribution->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
			Units -> {Nanometer, ArbitraryUnit},
			Description -> "Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution for the DLS measurement before thermal ramping. In the MassDistribution, as opposed to the IntensityDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size, so this trace gives a more accurate representation of the number of particles of each size in solution.",
			Category->"Experimental Results"
		},
		FinalDynamicLightScatteringTemperature->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the particle DLS is measured after thermal ramping.",
			Category -> "Experimental Results"
		},
		FinalZAverageDiameter->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description -> "The average hydrodynamic diameter of particles in solution for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalZAverageDiffusionCoefficient->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*(Meter*Meter/Second)],
			Units->(Meter*Meter/Second),
			Description -> "Diffusion coefficeint calculated from the CorrelationCurve which is inversely proportional to particle size, for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalDiameterStandardDeviation->{
			Format -> Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nanometer],
			Units->Nanometer,
			Description -> "The standard deviation of the ZAverageDiameter for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalPolydispersityIndex->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "A measure of the heterogeneity of the calculated hydrodynamic diameters of particles in solution for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalScatteredLightIntensity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "The amount of light that reaches the scattered light detector in counts per second for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalCorrelationCurve->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Micro*Second,ArbitraryUnit}],
			Units -> {Micro*Second, ArbitraryUnit},
			Description -> "A series of data points which describes the correlation between scattered light intensity over time for the sample for the DLS measurement after thermal ramping. This correlation typically decays from 1 to 0 over time.",
			Category->"Experimental Results"
		},
		FinalCorrelationCurveFitVariance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description -> "A measure of the fit of multiple exponential decay function to the measured CorrelationCurve for the DLS measurement after thermal ramping.",
			Category->"Experimental Results"
		},
		FinalIntensityDistribution->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
			Units -> {Nanometer, ArbitraryUnit},
			Description -> "Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution for the DLS measurement after thermal ramping. Since larger particles scatter more light, larger particles have a higher scattered light intensity per particle in the IntensityDistribution.",
			Category->"Experimental Results"
		},
		FinalMassDistribution->{
			Format->Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
			Units -> {Nanometer, ArbitraryUnit},
			Description -> "Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution for the DLS measurement after thermal ramping. In the MassDistribution, as opposed to the IntensityDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size, so this trace gives a more accurate representation of the number of particles of each size in solution.",
			Category->"Experimental Results"
		},
		(*DynaPro-specific experimental results*)
		DLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of increasing temperature during the first heating cycle.",
			Category-> "Experimental Results"
		},
		DLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of decreasing temperature during the first cooling cycle.",
			Category->"Experimental Results"
		},
		SecondaryDLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of increasing temperature during the second heating cycle.",
			Category-> "Experimental Results"
		},
		SecondaryDLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of decreasing temperature during the second cooling cycle.",
			Category->"Experimental Results"
		},
		TertiaryDLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of increasing temperature during the third heating cycle.",
			Category-> "Experimental Results"
		},
		TertiaryDLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,Nanometer}..}],
			Units-> {Celsius, Nanometer},
			Description-> "The recorded Z-average diameter as obtained from dynamic light scattering as a function of decreasing temperature during the third cooling cycle.",
			Category->"Experimental Results"
		},
		SLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the first heating cycle.",
			Category-> "Experimental Results"
		},
		SLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the first cooling cycle.",
			Category->"Experimental Results"
		},
		SecondarySLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the second heating cycle.",
			Category-> "Experimental Results"
		},
		SecondarySLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the second cooling cycle.",
			Category->"Experimental Results"
		},
		TertiarySLSHeatingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of increasing temperature during the third heating cycle.",
			Category-> "Experimental Results"
		},
		TertiarySLSCoolingCurve->{
			Format-> Single,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Celsius,ArbitraryUnit}..}],
			Units-> {Celsius, ArbitraryUnit},
			Description-> "The recorded light scattering intensity (counts) as a function of decreasing temperature during the third cooling cycle.",
			Category->"Experimental Results"
		},
		(*--Data Processing--**)
		RawDataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file(s) containing the raw unprocessed data generated by the instrument.",
			Category -> "Data Processing"
		},
		DataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The instrument software specific file(s) containing the processed data generated by the instrument.",
			Category -> "Data Processing"
		},
		(*Analysis fields*)
		MeltingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Melting point analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		FluorescenceSpectraAnalyses-> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Fluorescence spectra analysis performed on this data (and its replicates).",
			Category->"Analysis & Reports"
		},
		AggregationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern:> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Aggregation temperature analyses done on this data (and its replicates).",
			Category -> "Analysis & Reports"
		},
		ThermalShiftAnalyses-> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Thermal shift analyses relative to a reference sample done on this data (and its replicates).",
			Category -> "Analysis & Reports"
		},
		InitialIntensityPeaksAnalyses -> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the InitialIntensityDistribution.",
			Category -> "Analysis & Reports"
		},
		FinalIntensityPeaksAnalyses -> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the FinalIntensityDistribution.",
			Category -> "Analysis & Reports"
		},
		InitialMassPeaksAnalyses -> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the InitialMassDistribution.",
			Category -> "Analysis & Reports"
		},
		FinalMassPeaksAnalyses -> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the FinalMassDistribution.",
			Category -> "Analysis & Reports"
		},
		DynamicLightScatteringAnalyses -> {
			Format -> Multiple,
			Class ->Link,
			Pattern:>_Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Analyses of the initial and final dynamic light scattering correlation curves.",
			Category -> "Analysis & Reports"
		},
		MeltingTemperature->{
			Format-> Multiple,
			Class-> Real,
			Pattern:> GreaterP[0*Kelvin],
			Units-> Celsius,
			Description-> "The temperature at the first inflection point in the melting or cooling curve for each cycle. Additional melt temperatures can be found in the corresponding analysis object.",
			Category-> "Analysis & Reports"
		},
		AggregationTemperature->{
			Format-> Multiple,
			Class->Real,
			Pattern:> GreaterP[0*Kelvin],
			Units-> Celsius,
			Description-> "The temperature at the inflection point of the aggregation curve for each heating cycle or cooling cycle.",
			Category-> "Analysis & Reports"
		},
		AggregationOnsetTemperature->{
			Format-> Multiple,
			Class->Real,
			Pattern:> GreaterP[0*Kelvin],
			Units-> Celsius,
			Description-> "The temperature at the AggregationThreshold for each heating cycle or cooling cycle.",
			Category-> "Analysis & Reports"
		}
	}
}];
