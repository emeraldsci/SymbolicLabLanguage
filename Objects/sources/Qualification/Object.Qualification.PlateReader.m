(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, PlateReader], {
	Description->"A protocol that verifies the functionality of the plate reader target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(*UV-Vis qualification protocol*)
		AbsorbanceQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol used to interrogate platereader UV-Vis performance.",
			Category -> "General"
		},

		(*UV-Vis qualification protocol*)
		AbsorbanceIntensityQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, AbsorbanceIntensity],
			Description -> "The absorbance intensity protocol used to interrogate platereader UV-Vis performance.",
			Category -> "General"
		},

		(* UV-Vis Sample Preparation *)
		AbsorbanceSamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the UV-Vis test samples.",
			Category -> "Sample Preparation"
		},

		AbsorbanceSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the UV-Vis test samples.",
			Category -> "Sample Preparation"
		},

		(*UV Vis Fields*)

		AbsorbanceQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test UV-Vis capabilities.",
			Category -> "General"
		},

		WavelengthAccuracyTestSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the wavelength accuracy of the plate readers detector.",
			Category -> "General"
		},

		AbsorbanceAccuracyTestSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the absorbance accuracy of the plate readers detector.",
			Category -> "General"
		},

		LinearityTestSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the linearity of the plate readers detector.",
			Category -> "General"
		},

		StrayLightTestSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the stray light of the plate reader.",
			Category -> "General"
		},

		AbsorbanceBlankTestSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used as blanks to normalize UV-Vis test samples for background.",
			Category -> "General"
		},
		
		(*Fluorescence Fields*)

		FluorescenceQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test fluorescence capabilites.",
			Category -> "General"
		},

		(*Luminescence Fields*)

		LuminescenceQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test luminescence capabilites.",
			Category -> "General"
		},

		(*Fluorescence Polarization protocol*)
		PolarizationQualificationProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,FluorescencePolarization],
			Description -> "The fluorescence polarization protocol used to interrogate platereader polarization performance.",
			Category -> "General"
		},

		(*Fluorescence Polarization Samples*)
		PolarizationQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test fluorescence polarization capabilites.",
			Category -> "General"
		},
		PolarizationSamplePreparationUnitOperations ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate fluorescence polarization test samples.",
			Category -> "Sample Preparation"
		},
		PolarizationSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the fluorescence polarization reference samples.",
			Category -> "Sample Preparation"
		},

		(* AlphaScreen fields *)
		AlphaScreenQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AlphaScreen],
			Description -> "The AlphaScreen protocol used to interrogate platereader's absorbance and detection performance.",
			Category -> "General"
		},
		AlphaScreenQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "The prepared plate which contains samples for the AlphaScreen qualification tests.",
			Category -> "General"
		},
		AlphaScreenAccuracySamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the absorbance accuracy of the plate readers detector.",
			Category -> "General"
		},
		AlphaScreenLinearitySamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the absorbance accuracy of the plate readers detector.",
			Category -> "General"
		},
		AlphaScreenSamplePreparationUnitOperations->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate AlphaScreen test samples.",
			Category -> "Sample Preparation"
		},
		AlphaScreenSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the AlphaScreen reference samples.",
			Category -> "Sample Preparation"
		},

		(* CD Fields *)
		CircularDichroismQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,CircularDichroism],
			Description -> "The sample manipulation protocol used to generate the CircularDichroism reference samples.",
			Category -> "General"
		},
		CircularDichroismSamplePreparationUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description -> "A set of instructions specifying the prepration of the samples for circular dichroism prepration.",
			Category -> "Sample Preparation"
		},

		(* Nephelometry fields *)
		NephelometryQualificationProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,Nephelometry],
			Description -> "The Nephelometry protocol used to interrogate the plate reader's light scattering and detection performance.",
			Category -> "General"
		},
		NephelometryQualificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "The prepared plate which contains samples for the Nephelometry qualification tests.",
			Category -> "General"
		},
		NephelometryAccuracySamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the light scattering accuracy of the plate reader's detector.",
			Category -> "General"
		},
		NephelometryLinearitySamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Samples used to test the light scattering linearity of the plate reader's detector.",
			Category -> "General"
		},
		NephelometrySamplePreparationUnitOperations->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate Nephelometry test samples.",
			Category -> "Sample Preparation"
		},
		NephelometrySamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the Nephelometry reference samples.",
			Category -> "Sample Preparation"
		},



		(*Experimental Results*)

		WavelengthAccuracyPeaksAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Peaks]
			],
			Description -> "Analyses performed to determine the peak location for wavelength standard samples in this qualification.",
			Category -> "Experimental Results"
		},

		WavelengthAccuracyAnalyses->{
			Format -> Multiple,
			Class -> {
				ExpectedLambdaMax->Real, 
				MeasuredLambdaMax->Expression, 
				ReplicateCount->Integer, 
				ReplicateData->Expression, 
				Deviation->Expression
			},
			Pattern :> {
				ExpectedLambdaMax->GreaterP[0*Nanometer], 
				MeasuredLambdaMax->DistributionP[],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->DistributionP[]
			},
			Units->{
				ExpectedLambdaMax->Nanometer, 
				MeasuredLambdaMax->None,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->None
			},
			Description -> "The measured \[Lambda]max value for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"

		},

		WavelengthAccuracyResults->{
			Format -> Multiple,
			Class -> {
				ExpectedLambdaMax->Real, 
				MeasuredLambdaMax->Expression, 
				Deviation->Expression, 
				AllowedDeviation->Real, 
				Passing->Boolean
			},
			Pattern :> {
				ExpectedLambdaMax->GreaterP[0*Nanometer], 
				MeasuredLambdaMax->DistributionP[], 
				Deviation->DistributionP[], 
				AllowedDeviation->GreaterP[0*Nanometer] , 
				Passing->BooleanP
			},
			Units->{
				ExpectedLambdaMax->Nanometer, 
				MeasuredLambdaMax->None, 
				Deviation->None, 
				AllowedDeviation->Nanometer, 
				Passing->None
			},
			Description -> "The deviation between measured/expected \[Lambda]max and whether the deviation is within passing criteria.",
			Category -> "Experimental Results"
		},

		AbsorbanceAccuracyAnalyses->{
			Format -> Multiple,
			Class -> {
				Concentration->Real,
				Wavelength->Real,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Expression
			},
			Pattern :> {
				Concentration->GreaterP[0*(Milligram/Milliliter)],
				Wavelength->GreaterP[0*Nanometer],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->DistributionP[]
			},
			Units->{
				Concentration->Milligram/Milliliter,
				Wavelength->Nanometer,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->None
			},
			Description -> "The measured absorbance value at a given analyte concentration/wavelength for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		AbsorbanceAccuracyResults->{
			Format -> Multiple,
			Class -> {
				Concentration->Real, 
				Wavelength->Real, 
				Deviation->Expression, 
				AllowedDeviation->Real, 
				Passing->Boolean
			},
			Pattern :> {
				Concentration->GreaterP[0*(Milligram/Milliliter)], 
				Wavelength->GreaterP[0*Nanometer],
				Deviation->DistributionP[],
				AllowedDeviation->GreaterP[0*AbsorbanceUnit],
				Passing->BooleanP
			},
			Units->{
				Concentration->Milligram/Milliliter, 
				Wavelength->Nanometer,
				Deviation->None,
				AllowedDeviation->AbsorbanceUnit,
				Passing->None
			},
			Description -> "The deviation between measured/expected absorbance at a given wavelength and whether the deviation is within passing criteria.",
			Category -> "Experimental Results"
		},

		AbsorbanceLinearityFitAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Fit]
			],
			Description -> "Analyses performed to determine the linear fit to absorbance data generated in this qualification.",
			Category -> "Experimental Results"
		},

		AbsorbanceLinearityAnalyses->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real, 
				Concentration->Real, 
				ReplicateCount->Integer, 
				ReplicateData->Expression, 
				Absorbance->Expression
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer], 
				Concentration->GreaterP[0*(Milligram/Milliliter)],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Absorbance->DistributionP[]
			},
			Units->{
				Wavelength->Nanometer, 
				Concentration->Milligram/Milliliter,
				ReplicateCount->None,
				ReplicateData->_None,
				Absorbance->None
			},
			Description -> "The measured absorbance value at a given wavelength/analyte concentration for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		AbsorbanceLinearityResults->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real, 
				RSquared->Real, 
				MinRSquared->Real, 
				Passing->Boolean
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer], 
				RSquared->GreaterP[0],
				MinRSquared->GreaterP[0],
				Passing->BooleanP
			},
			Units->{
				Wavelength->Nanometer, 
				RSquared->None,
				MinRSquared->None,
				Passing->None
			},
			Description -> "The R-Squared for the fit of absorbance versus concentration and whether it meets the passing criterion.",
			Category -> "Experimental Results"
		},

		StrayLightTestAnalyses->{
			Format -> Multiple,
			Class -> {
				WavelengthCutoff->Real, 
				ReplicateCount->Integer, 
				ReplicateData->Expression, 
				MaxTransmittance->Expression
			},
			Pattern :> {
				WavelengthCutoff->GreaterP[0*Nanometer], 
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				MaxTransmittance->DistributionP[]
			},
			Units->{
				WavelengthCutoff->Nanometer, 
				ReplicateCount->None,
				ReplicateData->None,
				MaxTransmittance->None
			},
			Description -> "The measured max transmittance values below the wavelength cutoff for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		StrayLightTestResults->{
			Format -> Multiple,
			Class -> {
				WavelengthCutoff->Real, 
				MaxTransmittance->Expression, 
				AllowedTransmittance->Real, 
				Passing->Boolean
			},
			Pattern :> {
				WavelengthCutoff->GreaterP[0*Nanometer], 
				MaxTransmittance->DistributionP[],
				AllowedTransmittance->GreaterP[0*Percent],
				Passing->BooleanP
			},
			Units->{
				WavelengthCutoff->Nanometer, 
				MaxTransmittance->None,
				AllowedTransmittance->Percent,
				Passing->None
			},
			Description -> "The max transmittance measured below the wavlength cutoff and whether it meets the passing criterion.",
			Category -> "Experimental Results"
		},

		AlphaScreenAccuracyAnalyses->{
			Format -> Multiple,
			Class -> {
				Concentration->Real,
				Wavelength->Real,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Real
			},
			Pattern :> {
				Concentration->GreaterEqualP[0*(Microgram/Milliliter)],
				Wavelength->GreaterP[0*Nanometer],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->GreaterEqualP[0*RLU]
			},
			Units->{
				Concentration->Microgram/Milliliter,
				Wavelength->Nanometer,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->RLU
			},
			Description -> "The measured signal from reference AlphaScreen beads at 20 Microgram/Milliliter concentration for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		AlphaScreenAccuracyResults->{
			Format -> Multiple,
			Class -> {
				Concentration->Real,
				Wavelength->Real,
				Deviation->Real,
				AllowedDeviation->Real,
				Intensity->Real,
				AllowedIntensity->Real,
				Passing->Boolean
			},
			Pattern :> {
				Concentration->GreaterEqualP[0*(Microgram/Milliliter)],
				Wavelength->GreaterP[0*Nanometer],
				Deviation->GreaterEqualP[0*RLU],
				AllowedDeviation->GreaterP[0*RLU],
				Intensity->GreaterEqualP[0*RLU],
				AllowedIntensity->GreaterP[0*RLU],
				Passing->BooleanP
			},
			Units->{
				Concentration->Microgram/Milliliter,
				Wavelength->Nanometer,
				Deviation->RLU,
				AllowedDeviation->RLU,
				Intensity->RLU,
				AllowedIntensity->RLU,
				Passing->None
			},
			Description -> "The deviation between measured/expected AlphaScreen signal and whether the deviation is within passing criteria. The mean AlphaScreen signal of blank solution and whether the mean is within passing criteria.",
			Category -> "Experimental Results"
		},
		AlphaScreenLinearityAnalyses->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real,
				Concentration->Real,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Real
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer],
				Concentration->GreaterEqualP[0*(Microgram/Milliliter)],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->GreaterEqualP[0*RLU]
			},
			Units->{
				Wavelength->Nanometer,
				Concentration->Microgram/Milliliter,
				ReplicateCount->None,
				ReplicateData->_None,
				Deviation->RLU
			},
			Description -> "The measured absorbance value at a given wavelength/analyte concentration for each AlphaScreen replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		AlphaScreenLinearityFitAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Fit]
			],
			Description -> "Analyses performed to determine the linear fit to absorbance data generated in this qualification.",
			Category -> "Experimental Results"
		},
		AlphaScreenLinearityResults->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real,
				RSquared->Real,
				MinRSquared->Real,
				Passing->Boolean
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer],
				RSquared->GreaterP[0],
				MinRSquared->GreaterP[0],
				Passing->BooleanP
			},
			Units->{
				Wavelength->Nanometer,
				RSquared->None,
				MinRSquared->None,
				Passing->None
			},
			Description -> "The R-Squared for the fit of absorbance versus concentration and whether it meets the passing criterion for AlphaScreen standard beads.",
			Category -> "Experimental Results"
		},

		CircularDichroismLinearityAnalyses->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real,
				Concentration->Real,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Real
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer],
				Concentration->UnitsP[Percent],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->GreaterEqualP[0*RLU]
			},
			Units->{
				Wavelength->Nanometer,
				Concentration->Percent,
				ReplicateCount->None,
				ReplicateData->_None,
				Deviation->RLU
			},
			Description -> "The measured absorbance value at a given wavelength/analyte concentration for each AlphaScreen replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},

		CircularDichroismLinearityFitAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Fit]
			],
			Description -> "Analyses performed to determine the linear fit to absorbance data generated in this qualification.",
			Category -> "Experimental Results"
		},
		CircularDichroismLinearityResults->{
			Format -> Multiple,
			Class -> {
				Wavelength->Real,
				RSquared->Real,
				MinRSquared->Real,
				Passing->Boolean
			},
			Pattern :> {
				Wavelength->GreaterP[0*Nanometer],
				RSquared->GreaterP[0],
				MinRSquared->GreaterP[0],
				Passing->BooleanP
			},
			Units->{
				Wavelength->Nanometer,
				RSquared->None,
				MinRSquared->None,
				Passing->None
			},
			Description -> "The R-Squared for the fit of absorbance versus concentration and whether it meets the passing criterion for AlphaScreen standard beads.",
			Category -> "Experimental Results"
		},

		CircularDichroismAccuracyPeaksAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Peaks]
			],
			Description -> "For this circular dichroism qualification, analyses performed to determine the peak location for wavelength standard samples in this circular dichroism qualification.",
			Category -> "Experimental Results"
		},

		CircularDichroismAccuracyAnalyses->{
			Format -> Multiple,
			Class -> {
				ExpectedLambdaMax->Real,
				MeasuredLambdaMax->Expression,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Expression
			},
			Pattern :> {
				ExpectedLambdaMax->GreaterP[0*Nanometer],
				MeasuredLambdaMax->DistributionP[],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation->DistributionP[]
			},
			Units->{
				ExpectedLambdaMax->Nanometer,
				MeasuredLambdaMax->None,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->None
			},
			Description -> "For this circular dichroism qualification, the measured \[Lambda]max value for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"

		},

		CircularDichroismAccuracyResults->{
			Format -> Multiple,
			Class -> {
				ExpectedLambdaMax->Real,
				MeasuredLambdaMax->Expression,
				Deviation->Expression,
				AllowedDeviation->Real,
				Passing->Boolean
			},
			Pattern :> {
				ExpectedLambdaMax->GreaterP[0*Nanometer],
				MeasuredLambdaMax->DistributionP[],
				Deviation->DistributionP[],
				AllowedDeviation->GreaterP[0*Nanometer] ,
				Passing->BooleanP
			},
			Units->{
				ExpectedLambdaMax->Nanometer,
				MeasuredLambdaMax->None,
				Deviation->None,
				AllowedDeviation->Nanometer,
				Passing->None
			},
			Description -> "For this circular dichroism qualification, the deviation between measured/expected \[Lambda]max and whether the deviation is within passing criteria.",
			Category -> "Experimental Results"
		},

		(* Nephelometry *)
		NephelometryAccuracyAnalyses->{
			Format -> Multiple,
			Class -> {
				StatedNTU->Real,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Expression
			},
			Pattern :> {
				StatedNTU->GreaterEqualP[0*ArbitraryUnit],
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation-> {GreaterEqualP[0*ArbitraryUnit]...}|{LessEqualP[0*ArbitraryUnit]...}
			},
			Units->{
				StatedNTU->ArbitraryUnit,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->ArbitraryUnit
			},
			Description -> "The measured signal from reference Nephelometry formazin solutions with a published NTU (nephelometric turbidity unit) value for each replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},
		NephelometryAccuracyResults->{
			Format -> Multiple,
			Class -> {
				StatedNTU->Real,
				Deviation->Real,
				AllowedDeviation->Real,
				Turbidity->Expression,
				AllowedTurbidity->Real,
				Passing->Boolean
			},
			Pattern :> {
				StatedNTU->GreaterEqualP[0*ArbitraryUnit],
				Deviation->GreaterEqualP[0*Percent],
				AllowedDeviation->GreaterP[0*Percent],
				Turbidity-> {GreaterEqualP[0 * ArbitraryUnit]...},
				AllowedTurbidity->GreaterP[0*ArbitraryUnit],
				Passing->BooleanP
			},
			Units->{
				StatedNTU->ArbitraryUnit,
				Deviation->Percent,
				AllowedDeviation->Percent,
				Turbidity->ArbitraryUnit,
				AllowedTurbidity->ArbitraryUnit,
				Passing->None
			},
			Description -> "The deviation between measured/expected Nephelometry signal and whether the deviation is within passing criteria.",
			Category -> "Experimental Results"
		},

		NephelometryLinearityAnalyses->{
			Format -> Multiple,
			Class -> {
				StatedNTU->Expression,
				ReplicateCount->Integer,
				ReplicateData->Expression,
				Deviation->Expression
			},
			Pattern :> {
				StatedNTU-> {GreaterEqualP[0 * ArbitraryUnit]...},
				ReplicateCount->GreaterP[0,1],
				ReplicateData->_List,
				Deviation-> {GreaterEqualP[0 * ArbitraryUnit]...}
			},
			Units->{
				StatedNTU->ArbitraryUnit,
				ReplicateCount->None,
				ReplicateData->None,
				Deviation->ArbitraryUnit
			},
			Description -> "The measured light scattering value at a given concentration for each Nephelometry replicate and its corresponding distribution.",
			Category -> "Experimental Results"
		},
		NephelometryLinearityFitAnalyses->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis,Fit]
			],
			Description -> "Analyses performed to determine the linear fit to light scattering data generated in a nephelometry qualification.",
			Category -> "Experimental Results"
		},
		NephelometryLinearityResults->{
			Format -> Multiple,
			Class -> {
				StatedNTU->Expression,
				RSquared->Real,
				MinRSquared->Real,
				Passing->Boolean
			},
			Pattern :> {
				StatedNTU-> {GreaterP[0 * ArbitraryUnit]...},
				RSquared->GreaterP[0],
				MinRSquared->GreaterP[0],
				Passing->BooleanP
			},
			Units->{
				StatedNTU->ArbitraryUnit,
				RSquared->None,
				MinRSquared->None,
				Passing->None
			},
			Description -> "The R-Squared value for the fit of RNU versus stated NTU of the standard and whether it meets the passing criterion for nephelometry.",
			Category -> "Experimental Results"
		},
		VerifySource->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the source samples for this qualification should be verified by an independent absorbance spectroscopy experiment.",
			Category -> "General"
		},
		VerifySourceAbsorbanceSpectroscopyProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol used to verify source samples for this qualificaiton.",
			Category -> "General"
		},

		(* Others *)
		QCPlateCharger->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Cable],
			Description -> "The charger used for the QC plate.",
			Category -> "General",
			Developer->True
		}
	}
}];
