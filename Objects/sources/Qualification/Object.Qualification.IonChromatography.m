(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,IonChromatography],{
    Description->"A protocol that verifies the functionality of the ion chromatography instrument target.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{

        AnalysisChannels->{
            Format->Multiple,
            Class->Expression,
            Pattern:>AnalysisChannelP,
            Description->"For each member of QualificationSamples, the flow path into which each sample is injected, either cation or anion channel.",
            IndexMatching->QualificationSamples,
            Category -> "General"
        },
        AnionQualificationSamples->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Alternatives[Object[Sample],Model[Sample]],
            Description->"A list of qualitifcation samples that are injected into the anion channel of the instrument for separation and analysis.",
            Category -> "General"
        },
        CationQualificationSamples->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Alternatives[Object[Sample],Model[Sample]],
            Description->"A list of qualitifcation samples that are injected into the cation channel of the instrument for separation and analysis.",
            Category -> "General"
        },
        AnionInjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"For each member of AnionQualificationSamples, the volume injected by the IonChromatography instrument into the anion channel.",
            IndexMatching->AnionQualificationSamples,
            Category -> "General"
        },
        CationInjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"For each member of CationQualificationSamples, the volume injected by the IonChromatography instrument into the cation channel.",
            IndexMatching->CationQualificationSamples,
            Category -> "General"
        },
        InjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"For each member of QualificationSamples, the volume injected by the IonChromatography instrument into the electrochemical channel.",
            IndexMatching->QualificationSamples,
            Category -> "General"
        },
        AnionGradientMethods->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method],
            Description->"For each member of AnionQualificationSamples, the gradient conditions used to run the sample on the IonChromatography instrument.",
            IndexMatching->AnionQualificationSamples,
            Category -> "General"
        },
        CationGradientMethods->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method],
            Description->"For each member of CationQualificationSamples, the gradient conditions used to run the sample on the IonChromatography instrument.",
            IndexMatching->CationQualificationSamples,
            Category -> "General"
        },
        GradientMethods->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method],
            Description->"For each member of QualificationSamples, the gradient conditions used to run the sample on the IonChromatography instrument.",
            IndexMatching->QualificationSamples,
            Category -> "General"
        },
        AnionFlowLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,FlowRate->Real,Data->Link},
            Pattern:>{Sample->_Link,FlowRate->GreaterEqualP[0*Milliliter/Minute],Data->_Link},
            Units->{Sample->None,FlowRate->Milliliter/Minute,Data->None},
            Relation->{Sample->(Object[Sample]|Model[Sample]),FlowRate->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, flow rates, and data used for testing the IonChromatography instruments's anion pump.",
            Category -> "General"
        },
        CationFlowLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,FlowRate->Real,Data->Link},
            Pattern:>{Sample->_Link,FlowRate->GreaterEqualP[0*Milliliter/Minute],Data->_Link},
            Units->{Sample->None,FlowRate->Milliliter/Minute,Data->None},
            Relation->{Sample->(Object[Sample]|Model[Sample]),FlowRate->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, flow rates, and data used for testing the IonChromatography instruments's cation pump.",
            Category -> "General"
        },
        FlowLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,FlowRate->Real,Data->Link},
            Pattern:>{Sample->_Link,FlowRate->GreaterEqualP[0*Milliliter/Minute],Data->_Link},
            Units->{Sample->None,FlowRate->Milliliter/Minute,Data->None},
            Relation->{Sample->(Object[Sample]|Model[Sample]),FlowRate->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, flow rates, and data used for testing the IonChromatography instruments's pump for electrochemical channel.",
            Category -> "General"
        },
        AnionAutosamplerTests->{
            Format->Multiple,
            Class->{Sample->Link,InjectionVolume->Real,Data->Link},
            Pattern:>{Sample->_Link,InjectionVolume->GreaterEqualP[0*Microliter],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),InjectionVolume->Null,Data->Object[Data,Chromatography]},
            Units->{Sample->None,InjectionVolume->Microliter,Data->None},
            Description->"The samples, injeciton volumes, and data used for testing the IonChromatography instrument's autosampler for injection into anion channel.",
            Category -> "General"
        },
        CationAutosamplerTests->{
            Format->Multiple,
            Class->{Sample->Link,InjectionVolume->Real,Data->Link},
            Pattern:>{Sample->_Link,InjectionVolume->GreaterEqualP[0*Microliter],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),InjectionVolume->Null,Data->Object[Data,Chromatography]},
            Units->{Sample->None,InjectionVolume->Microliter,Data->None},
            Description->"The samples, injeciton volumes, and data used for testing the IonChromatography instrument's autosampler for injection into cation channel.",
            Category -> "General"
        },
        AutosamplerTests->{
            Format->Multiple,
            Class->{Sample->Link,InjectionVolume->Real,Data->Link},
            Pattern:>{Sample->_Link,InjectionVolume->GreaterEqualP[0*Microliter],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),InjectionVolume->Null,Data->Object[Data,Chromatography]},
            Units->{Sample->None,InjectionVolume->Microliter,Data->None},
            Description->"The samples, injeciton volumes, and data used for testing the IonChromatography instrument's autosampler for injection into electrochemical channel.",
            Category -> "General"
        },
        GradientProportioningTests->{
            Format->Multiple,
            Class->{Sample->Link,BufferA->Real,BufferB->Real,BufferC->Real,BufferD->Real,Data->Link},
            Pattern:>{Sample->_Link,BufferA->RangeP[0*Percent,100*Percent],BufferB->RangeP[0*Percent,100*Percent],BufferC->RangeP[0*Percent,100*Percent],BufferD->RangeP[0*Percent,100*Percent],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),BufferA->Null,BufferB->Null,BufferC->Null,BufferD->Null,Data->Object[Data,Chromatography]},
            Units->{Sample->None,BufferA->Percent,BufferB->Percent,BufferC->Percent,BufferD->Percent,Data->None},
            Description->"The samples, buffer composition {%A, %B, %C, %D}, and data used for testing the IonChromatography instrument's proportioning valves in cation channel.",
            Category -> "General"
        },
        EluentConcentrationTests->{
            Format->Multiple,
            Class->{Sample->Link,EluentConcentration->Real,Data->Link},
            Pattern:>{Sample->_Link,EluentConcentration->GreaterEqualP[0*Millimolar],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),EluentConcentration->Null,Data->Object[Data,Chromatography]},
            Units->{Sample->None,EluentConcentration->Milli*Molar,Data->None},
            Description->"The samples, eluent concentration (gradient method), and data used for testing the concentration of eluent electrolytically produced by eluent generator.",
            Category -> "General"
        },
        AnionDetectorLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,DilutionFactor->Real,Data->Link},
            Pattern:>{Sample->_Link,DilutionFactor->RangeP[0,1],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),DilutionFactor->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, dilution factors, and data used for testing the linearity of the IonChromatography instrument's anion detector.",
            Category -> "General"
        },
        CationDetectorLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,DilutionFactor->Real,Data->Link},
            Pattern:>{Sample->_Link,DilutionFactor->RangeP[0,1],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),DilutionFactor->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, dilution factors, and data used for testing the linearity of the IonChromatography instrument's cation detector.",
            Category -> "General"
        },
        ElectrochemicalDetectorLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,DilutionFactor->Real,Data->Link},
            Pattern:>{Sample->_Link,DilutionFactor->RangeP[0,1],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),DilutionFactor->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, dilution factors, and data used for testing the linearity of the IonChromatography instrument's electrochemical detector.",
            Category -> "General"
        },
        DetectorLinearityTests->{
            Format->Multiple,
            Class->{Sample->Link,DilutionFactor->Real,Data->Link},
            Pattern:>{Sample->_Link,DilutionFactor->RangeP[0,1],Data->_Link},
            Relation->{Sample->(Object[Sample]|Model[Sample]),DilutionFactor->Null,Data->Object[Data,Chromatography]},
            Description->"The samples, dilution factors, and data used for testing the linearity of the IonChromatography instrument's absorbance detector.",
            Category -> "General"
        },
        CationBlankSample -> {
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Alternatives[Model[Sample], Object[Sample]],
            Description->"The sample model that will be injected as a blank when testing the IonChromatography instrument's cation channel.",
            Category->"General"
        },
        AnionBlankSample -> {
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Alternatives[Model[Sample], Object[Sample]],
            Description->"The sample model that will be injected as a blank when testing the IonChromatography instrument's anion channel.",
            Category->"General"
        },
        (* Sample Preparation *)
        SamplePreparationUnitOperations->{
            Format->Multiple,
            Class->Expression,
            Pattern:>SamplePreparationP,
            Description->"The primitives used by Sample Manipulation to generate the test samples.",
            Category->"Sample Preparation"
        },
        SamplePreparationProtocol->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
            Description->"The sample manipulation protocol used to generate the test samples.",
            Category->"Sample Preparation"
        },
        SampleWells->{
            Format->Multiple,
            Class->String,
            Pattern:>WellP,
            Description->"The list of sample wells that will be injected from.",
            Category->"Sample Preparation",
            Developer->True
        },

        (* Experimental Results *)
        AnionDetectorResponsePeaksAnalyses->{
            Format->Multiple,
            Class->{DilutionFactor->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{DilutionFactor->GreaterP[0],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Description->"The peak area distribution for each set of anion injections of a certain dilution.",
            Category->"Experimental Results"
        },
        AnionDetectorResponseFactorResults->{
            Format->Single,
            Class->{Expression,Real,Real,Boolean},
            Pattern:>{DistributionP[],GreaterP[0 Percent],GreaterP[0 Percent],BooleanP},
            Units->{None,Percent,Percent,None},
            Headers->{"Detector Response Distribution","%RSD","Max %RSD","Passing"},
            Description->"The distribution of response factors (peak area/dilution factor) from anion detector linearity tests and whether it's %RSD meets the passing criterion.",
            Category->"Experimental Results"
        },
        AnionDetectorLinearityResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Description->"The correlation coefficient for the fit of peak areas versus sample dilutions and whether it meets the passing criterion for anion detector.",
            Category->"Experimental Results"
        },
        CationDetectorResponsePeaksAnalyses->{
            Format->Multiple,
            Class->{DilutionFactor->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{DilutionFactor->GreaterP[0],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Description->"The peak area distribution for each set of cation injections of a certain dilution.",
            Category->"Experimental Results"
        },
        CationDetectorResponseFactorResults->{
            Format->Single,
            Class->{Expression,Real,Real,Boolean},
            Pattern:>{DistributionP[],GreaterP[0 Percent],GreaterP[0 Percent],BooleanP},
            Units->{None,Percent,Percent,None},
            Headers->{"Detector Response Distribution","%RSD","Max %RSD","Passing"},
            Description->"The distribution of response factors (peak area/dilution factor) from cation detector linearity tests and whether it's %RSD meets the passing criterion.",
            Category->"Experimental Results"
        },
        CationDetectorLinearityResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Description->"The correlation coefficient for the fit of peak areas versus sample dilutions and whether it meets the passing criterion for cation detector.",
            Category->"Experimental Results"
        },
        ElectrochemicalDetectorResponsePeaksAnalyses->{
            Format->Multiple,
            Class->{DilutionFactor->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{DilutionFactor->GreaterP[0],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Description->"The peak area distribution for each set of electrochemical channel injections of a certain dilution.",
            Category->"Experimental Results"
        },
        ElectrochemicalDetectorResponseFactorResults->{
            Format->Single,
            Class->{Expression,Real,Real,Boolean},
            Pattern:>{DistributionP[],GreaterP[0 Percent],GreaterP[0 Percent],BooleanP},
            Units->{None,Percent,Percent,None},
            Headers->{"Detector Response Distribution","%RSD","Max %RSD","Passing"},
            Description->"The distribution of response factors (peak area/dilution factor) from electcrochemical detector linearity tests and whether it's %RSD meets the passing criterion.",
            Category->"Experimental Results"
        },
        ElectrochemicalDetectorLinearityResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Description->"The correlation coefficient for the fit of peak areas versus sample dilutions and whether it meets the passing criterion for electcrochemical detector.",
            Category->"Experimental Results"
        },
        DetectorResponsePeaksAnalyses->{
            Format->Multiple,
            Class->{DilutionFactor->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{DilutionFactor->GreaterP[0],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Description->"The peak area distribution for each set of electrochemical channel injections of a certain dilution.",
            Category->"Experimental Results"
        },
        DetectorResponseFactorResults->{
            Format->Single,
            Class->{Expression,Real,Real,Boolean},
            Pattern:>{DistributionP[],GreaterP[0 Percent],GreaterP[0 Percent],BooleanP},
            Units->{None,Percent,Percent,None},
            Headers->{"Detector Response Distribution","%RSD","Max %RSD","Passing"},
            Description->"The distribution of response factors (peak area/dilution factor) from absorbance detector linearity tests and whether it's %RSD meets the passing criterion.",
            Category->"Experimental Results"
        },
        DetectorLinearityResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Description->"The correlation coefficient for the fit of peak areas versus sample dilutions and whether it meets the passing criterion for absorbance detector.",
            Category->"Experimental Results"
        },
        AnionInjectionPrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,PeakAreaDistribution->None},
            Description->"The peak area distributions for each set of anion injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxAnionInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections into anion channel.",
            Category->"Experimental Results"
        },
        AnionInjectionPrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured injection precision passes acceptance criteria for anion injections.",
            Category->"Experimental Results"
        },
        CationInjectionPrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,PeakAreaDistribution->None},
            Description->"The peak area distributions for each set of cation injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxCationInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections into cation channel.",
            Category->"Experimental Results"
        },
        CationInjectionPrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured injection precision passes acceptance criteria for cation injections.",
            Category->"Experimental Results"
        },
        InjectionPrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,PeakAreaDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],PeakAreaDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,PeakAreaDistribution->None},
            Description->"The peak area distributions for each set of electrochemical channel injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections into electrochemical channel.",
            Category->"Experimental Results"
        },
        InjectionPrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured injection precision passes acceptance criteria for electrochemical channel injections.",
            Category->"Experimental Results"
        },
        AnionFlowRatePrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distribution for each set of anion injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxAnionFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing anion flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Experimental Results"
        },
        AnionFlowRatePrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured anion flow rate precision passes acceptance criteria.",
            Category->"Experimental Results"
        },
        AnionFlowLinearityPeaksAnalyses->{
            Format->Multiple,
            Class->{FlowRate->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{FlowRate->GreaterP[0 Milliliter/Minute],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{FlowRate->Milliliter/Minute,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distributions for each set of anion injections at a certain flow rate.",
            Category->"Experimental Results"
        },
        AnionFlowLinearityTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Description->"The correlation coefficient for the fit of 1/retention time versus anion flow rate and whether it meets the passing criterion.",
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Category->"Experimental Results"
        },
        AnionFlowRateAccuracyTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{_?QuantityQ,GreaterP[0 Milliliter/Minute],BooleanP},
            Units->{Milliliter/Minute,Milliliter/Minute,None},
            Description->"The measured anion flow rate error and whether it meets the passing criterion.",
            Headers->{"Flow Rate Error","Max Flow Rate Error","Passing"},
            Category->"Experimental Results"
        },
        CationFlowRatePrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distribution for each set of cation injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxCationFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing cation flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Experimental Results"
        },
        CationFlowRatePrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured cation flow rate precision passes acceptance criteria.",
            Category->"Experimental Results"
        },
        CationFlowLinearityPeaksAnalyses->{
            Format->Multiple,
            Class->{FlowRate->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{FlowRate->GreaterP[0 Milliliter/Minute],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{FlowRate->Milliliter/Minute,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distributions for each set of cation injections at a certain flow rate.",
            Category->"Experimental Results"
        },
        CationFlowLinearityTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Description->"The correlation coefficient for the fit of 1/retention time versus cation flow rate and whether it meets the passing criterion.",
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Category->"Experimental Results"
        },
        CationFlowRateAccuracyTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{_?QuantityQ,GreaterP[0 Milliliter/Minute],BooleanP},
            Units->{Milliliter/Minute,Milliliter/Minute,None},
            Description->"The measured cation flow rate error and whether it meets the passing criterion.",
            Headers->{"Flow Rate Error","Max Flow Rate Error","Passing"},
            Category->"Experimental Results"
        },
        FlowRatePrecisionPeaksAnalyses->{
            Format->Multiple,
            Class->{InjectionVolume->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{InjectionVolume->GreaterP[0 Microliter],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{InjectionVolume->Microliter,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distribution for each set of electrochemical channel injections of a certain injection volume.",
            Category->"Experimental Results"
        },
        MaxFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Experimental Results"
        },
        FlowRatePrecisionPassing->{
            Format->Single,
            Class->Boolean,
            Pattern:>BooleanP,
            Description->"Whether or not the measured electrochemical flow rate precision passes acceptance criteria.",
            Category->"Experimental Results"
        },
        FlowLinearityPeaksAnalyses->{
            Format->Multiple,
            Class->{FlowRate->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{FlowRate->GreaterP[0 Milliliter/Minute],SamplesAnalyzed->GreaterEqualP[0,1],SamplesExcluded->GreaterEqualP[0,1],RetentionTimeDistribution->DistributionP[]},
            Units->{FlowRate->Milliliter/Minute,SamplesAnalyzed->None,SamplesExcluded->None,RetentionTimeDistribution->None},
            Description->"The peak retention time distributions for each set of electrochemical channel injections at a certain flow rate.",
            Category->"Experimental Results"
        },
        FlowLinearityTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Description->"The correlation coefficient for the fit of 1/retention time versus electrochemical flow rate and whether it meets the passing criterion.",
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Category->"Experimental Results"
        },
        FlowRateAccuracyTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{_?QuantityQ,GreaterP[0 Milliliter/Minute],BooleanP},
            Units->{Milliliter/Minute,Milliliter/Minute,None},
            Description->"The measured cation flow rate error and whether it meets the passing criterion.",
            Headers->{"Flow Rate Error","Max Flow Rate Error","Passing"},
            Category->"Experimental Results"
        },
        GradientProportioningPeaksAnalyses->{
            Format->Multiple,
            Class->{BufferComposition->Expression,SamplesAnalyzed->Integer,SamplesExcluded->Integer,RetentionTimeDistribution->Expression},
            Pattern:>{
                BufferComposition->{RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent]},
                SamplesAnalyzed->GreaterEqualP[0,1],
                SamplesExcluded->GreaterEqualP[0,1],
                RetentionTimeDistribution->DistributionP[]
            },
            Description->"The peak retention time distributions for each set of cation or electrochemical injections run with a certain buffer composition.",
            Category->"Experimental Results"
        },
        GradientProportioningTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{GreaterEqualP[0 Percent],GreaterP[0 Percent],BooleanP},
            Description->"The percent relative standard deviation of retention times and whether or not it meets the passing criterion.",
            Units->{Percent,Percent,None},
            Headers->{"Measured %RSD","Max %RSD","Passing"},
            Category->"Experimental Results"
        },
        EluentConcentrationAnalyses->{
            Format->Multiple,
            Class->{EluentConcentration->Real,SamplesAnalyzed->Integer,SamplesExcluded->Integer,AverageConductance->Real},
            Pattern:>{
                EluentConcentration->RangeP[0*Millimolar,100*Millimolar],
                SamplesAnalyzed->GreaterEqualP[0,1],
                SamplesExcluded->GreaterEqualP[0,1],
                AverageConductance->GreaterEqualP[0*Micro*Siemens/Centimeter]
            },
            Description->"The average conductance normalized against 0 mM eluent concentration for each set of anion injections run.",
            Category->"Experimental Results"
        },
        EluentConcentrationTestResults->{
            Format->Single,
            Class->{Real,Real,Boolean},
            Pattern:>{RangeP[0,1],RangeP[0,1],BooleanP},
            Headers->{"Correlation Coefficient","Min Correlation Coefficient","Passing"},
            Description->"The correlation coefficient for the fit of average conductance versus eluent concentrations and whether it meets the passing criterion for the eluent generator.",
            Category->"Experimental Results"
        },
        EluentGeneratorResponseFactorResults->{
            Format->Single,
            Class->{Expression,Real,Real,Boolean},
            Pattern:>{DistributionP[],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],BooleanP},
            Units->{None,Percent,Percent,None},
            Headers->{"Eluent Generator Response Distribution","%RSD","Max %RSD","Passing"},
            Description->"The distribution of response factors (average conductance/eluent concentration)) from eluent concentration tests and whether it's %RSD meets the passing criterion.",
            Category->"Experimental Results"
        }
    }
}];
