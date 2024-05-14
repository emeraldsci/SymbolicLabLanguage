
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* The pattern required for the dataset fields *)
nestedFieldQ[arg:{_Symbol..}|{_Field..}]:=False;
nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP=_?nestedFieldQ|_Field|_Symbol;

(* ::Package:: *)

DefineObjectType[Object[Analysis, MeltingPoint], {
	Description->"Analysis used to determine the melting temperature of oligomers or solid samples after an Absorbance Thermodynamics or MeasureMeltingPoint experiment, respectively.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MeltingPointMethodP,
			Description -> "The method used to calculate the melting points from the melting and cooling curves.",
			Category -> "General"
		},
		TopBaseline -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The top baseline fit on the full raw data to normalize the fraction melted vs. unmelted.",
			Category -> "General"
		},
		BottomBaseline -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The bottom baseline fit on the full raw data to normalize the fraction melted vs. unmelted.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "Instrument this data was obtained using.",
			Category -> "General",
			Abstract -> True
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the fluorescent detection reagent.",
			Category -> "General",
			Abstract -> True
		},
		StaticLightScatteringExcitation->{
			Format -> Multiple,
			Class-> Real,
			Description-> "The wavelength(s) used for static light scattering measurements.",
			Pattern:>GreaterP[0*NanoMeter],
			Units->Nanometer,
			Category-> "Method Information"
		},
		MeanMeltingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The average melting temperature calculated from the melting curve and cooling curve melting points.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		MeltingTemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "Uncertainty in the computed melting temperature, defined as the standard deviation of the melting temperature distribution.",
			Category -> "Analysis & Reports"
		},
		MeltingTemperatureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description -> "The probability distribution for the computed melting temperature value.",
			Category -> "Analysis & Reports"
		},
		MeltingCurves -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[Output->Short]|nestedFieldP,
			Description -> "A list of unique names that indicate the DataSet used for finding the melting information and whether they are transformed.",
			Category -> "Analysis & Reports"
		},
		MeltingCurvesTransformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol|_Function,
			Description -> "For each member of MeltingCurves, the names that indicate the transformation function applied to the DataSet before finding the melting information.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingTransitions -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{Celsius ..}],
			Units -> Celsius,
			Description -> "For each member of MeltingCurves, a list of temperatures where the derivative of y with respect to x has a local peak.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of MeltingCurves, the melting temperature value.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingTemperatureDistributions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Celsius]|Null,
			Description -> "For each member of MeltingCurves, the probability distributions for the computed melting temperature.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingTemperatureStandardDeviations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[Celsius]|Null,
			Units -> Celsius,
			Description -> "For each member of MeltingCurves, the uncertainty in the computed melting temperature, defined as the standard deviation of the melting temperature distribution.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingCurvesFractionBound -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,None}],
			Units -> {Celsius, None},
			Description -> "For each member of MeltingCurves, coordinates representing molar fraction of bound as a function of temperature.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingCurvesDataPoints -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[],
			Description -> "For each member of MeltingCurves, the coordinates representing the curve which is used for finding the melting temperature.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingCurvesDerivativePoints -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[],
			Description -> "For each member of MeltingCurves, the derivatives of the smoothed melting curve with respect to temperature. For qPCR data, negative derivatives of the smoothed melting curve with respect to temperature are used.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		MeltingOnsetTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of MeltingCurves, the melting onset temperature.",
			Category -> "Analysis & Reports",
			IndexMatching->MeltingCurves
		},
		DataPointsDLSAverageZDiameter -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,Nanometer}],
			Units -> {Celsius, Nanometer},
			Description -> "The coordinates for the curve of averaged Z diameter vs. temperature from dynamic light scattering experiment.",
			Category -> "Analysis & Reports"
		},
		DataPointsSLSMolecularWeights -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius,Gram/Mole}],
			Units -> {Celsius, Gram/Mole},
			Description -> "The coordinates for the curve of molecular weights vs temperature from static light scattering experiment.",
			Category -> "Analysis & Reports"
		},
		Thermodynamics -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis, Thermodynamics][Exclude],
				Object[Analysis][Reference]
			],
			Description -> "A thermodynamics analysis done with this melting point analysis to determine binding entropy and binding enthalpy.",
			Category -> "Analysis & Reports"
		},
		PharmacopeiaStartPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The furnace temperature at which the sample begins to melt. Melting beginning is defined as the temperature when the relative light intensity through the sample first exceeds the StartPointThreshold.",
			Category -> "Analysis & Reports"
		},
		PharmacopeiaMeniscusPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The furnace temperature at which the sample is in melting progress. Melting onset is defined when the relative light intensity reaches the MeniscusPointThreshold.",
			Category -> "Analysis & Reports"
		},
		PharmacopeiaClearPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The furnace temperature at which the sample completes melting. Melting completion is defined when the slope of the relative light intensity through the sample over time dropping below the ClearPointSlopeThreshold.",
			Category -> "Analysis & Reports"
		},
		ThermodynamicStartPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The approximate capillary temperature when the sample begins to melt. It is an adjustment of the PharmacopeiaStartPointTemperature using the formula provided by the instrument manufacturer.",
			Category -> "Analysis & Reports"
		},
		ThermodynamicMeniscusPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The approximate capillary temperature when the light intensity achieves a predetermined value given by MeniscusPointThreshold. It is an adjustment of the PharmacopeiaMeniscusPointTemperature using the formula provided by the instrument manufacturer.",
			Category -> "Analysis & Reports"
		},
		ThermodynamicClearPointTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The approximate capillary temperature when the light intensity stabilizes at the conclusion of the melting process. It is an adjustment of the PharmacopeiaClearPointTemperature using the formula provided by the instrument manufacturer.",
			Category -> "Analysis & Reports"
		},
		USPharmacopeiaMeltingRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {UnitsP[Celsius], UnitsP[Celsius]},
			Units -> {Celsius, Celsius},
			Description -> "The United States Pharmacopeia (NSP) melting range. It is the range from the PharmacopeiaStartPointTemperature to the PharmacopeiaClearPointTemperature.",
			Headers -> {"Start MeltingPoint", "Clear MeltingPoint"},
			Category -> "Analysis & Reports"
		},
		BritishPharmacopeiaMeltingPoint -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The British Pharmacopeia (BP) melting point. It is the same temperature as the PharmacopeiaClearPointTemperature.",
			Category -> "Analysis & Reports"
		},
		JapanesePharmacopeiaMeltingPoint -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "The Japanese Pharmacopeia (JP) melting point. It is the same temperature as the PharmacopeiaClearPointTemperature.",
			Category -> "Analysis & Reports"
		},
		Domain -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {UnitsP[Celsius], UnitsP[Celsius]},
			Units -> {Celsius, Celsius},
			Description -> "Temperature domain evaluated for melting point.",
			Category -> "General",
			Headers->{"Min Temperature","Max Temperature"}
		},
		MeltingPlotRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {_?NumericQ, _?NumericQ},
			Description -> "Range evaluated for melting point.",
			Category -> "General",
			Headers->{"Min","Max"}
		},
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Nanometer],
			Description -> "Wavelength used in inspect 3D plot.",
			Category -> "General"
		},
		DataProcessing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Smooth,Fit],
			Description -> "Dataprocessing type, smooth (Gaussian smoothing) or fit (sigmoid function).",
			Category -> "General"
		},
		SmoothingRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Description -> "Smoothing radius for data processing.",
			Category -> "General"
		},
		DataSet -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
							All,
							MeltingCurve, MeltingCurves, CoolingCurve,
							SecondaryMeltingCurve, SecondaryCoolingCurve,
							TertiaryMeltingCurve, TertiaryCoolingCurve,
							QuaternaryMeltingCurve, QuaternaryCoolingCurve,
							QuinaryMeltingCurve, QuinaryCoolingCurve,
							AggregationCurve,
							MeltingCurve3D, CoolingCurve3D,
							SecondaryMeltingCurve3D, SecondaryCoolingCurve3D,
							TertiaryMeltingCurve3D, TertiaryCoolingCurve3D,
							QuaternaryMeltingCurve3D, QuaternaryCoolingCurve3D,
							QuinaryMeltingCurve3D, QuinaryCoolingCurve3D,
							AggregationCurve3D,
							DataPointsDLSAverageZDiameter, DataPointsSLSMolecularWeights
						],
			Description -> "Dataset used to for melting point analysis.",
			Category -> "General"
		},
		PlotType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[All,MeltingPoint,Alpha,Derivative,DerivativeOverlay],
			Description -> "Data to display on the preview plot.",
			Category -> "General"
		},
		ApplyAll -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[True,False],
			Description -> "If True, applies first set of resolved options to all remaining data sets.",
			Category -> "General"
		},
		Output -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Result, Options, Preview, Tests],
			Description -> "Output specifications.",
			Category -> "General"
		},
		Upload -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[True,False],
			Description -> "Upload the generated object of the analysis.",
			Category -> "General"
		},
		Template -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ObjectP[Types[Object[Analysis]]],
			Description -> "Template used in the analysis.",
			Category -> "General"
		},
		PharmacopeiaMeltingPointCriterion->{
			Format->Single,
			Class->Expression,
			Pattern:>MeniscusPoint|ClearPoint,
			Description->"The criterion which determines the pharmaceutical melting point of the sample. Options include MeniscusPoint and ClearPoint. MeniscusPoint is a step in melting process at which	adequate amount of the solid is melted to form a meniscus at the top of the sample in a melting point capillary. MeniscusPointThreshold is a transmission percent which determines the MeniscusPoint in the process of measuring the melting point by a melting point apparatus. ClearPoint is the earliest point during the melting process at which all of the solid is liquefied and no solid particle is present in the melting point capillary. ClearPointThreshold is a transmission-time slope which determines the clear point in the the process of measuring the melting point by a melting point apparatus and is defaulted at 0.4%/s.",
			Category->"Analysis & Reports"
		},
		PharmacopeiaMeltingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature measured at MeltingPointCriterion in accordance with the pharmacopeia standard. This temperature value is taken directly from the temperature sensor and NOT corrected for the difference between the temperature of the furnace and the capillary. MeltingPointCriterion is either MeniscusPoint determined by MeniscusPointThreshold or ClearPoint determined by ClearPointThreshold. MeniscusPointThreshold is a transmission percent which determines the meniscus point and is defaulted at 40%. ClearPointThreshold is a transmission-time slope which determines the clear point and is defaulted at 0.4%/s.",
			Category->"Analysis & Reports"
		},
		USPMeltingRange->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The range of temperature values at which the solid substance coalesces (and a continuous liquid phase is formed) and is completely melted as defined by the United States Pharmacopeia (USP), determined by StartPoint and ClearPoint in this experiment. StartPoint and ClearPoint are determined by StartPointThreshold and ClearPointThreshold which are	transmission percents defaulted at 5% and 40%, respectively.",
			Category->"Analysis & Reports"
		},
		StartPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"A parameter to represent the temperature of the first instance at which the solid sample coalesces and a continuous liquid phase forms in the melting process. In this experiment, StartPoint is determined by StartPointThreshold which is a transmittance with a default value of 5%.",
			Category->"Analysis & Reports"
		},
		StartPointThreshold->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"A parameter to represent the transmittance of the first instance at which the solid sample coalesces and a continuous liquid phase forms in the melting process. StartPointThreshold is used to determine the StartPoint temperature and is defaulted at 5%.",
			Category->"Analysis & Reports"
		},
		MeniscusPoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"A parameter to represent the temperature at which adequate amount of the solid is melted to form a meniscus at the top of the sample in a melting point capillary. MeniscusPoint is determined by MeniscusPointThreshold which is a transmittance defaulted at 40%.",
			Category->"Analysis & Reports"
		},
		MeniscusPointThreshold->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"A parameter to represent the transmittance at which adequate amount of the solid is melted to form a meniscus at the top of the sample in a melting point capillary. MeniscusPointThreshold is used to determine the MeniscusPoint temperature and is defaulted at 5%.",
			Category->"Analysis & Reports"
		},
		ClearPoint->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"A parameter to represent the temperature of the earliest point during the melting process at which all of the solid is liquefied and no solid particle is present in the melting point capillary. ClearPoint is determined by ClearPointThreshold which is slope of the time-transmittance curve defaulted at 0.4%/s.",
			Category->"Analysis & Reports"
		},
		ClearPointThreshold->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent/Second],
			Units->Percent/Second,
			Description->"A parameter to determine the ClearPoint temperature. ClearPointThreshold is the slope of time-transmittance curve at which all the solid sample is fully melted. ClearPointThreshold is defaulted at 0.4%/Second.",
			Category->"Analysis & Reports"
		}
	}
}];
