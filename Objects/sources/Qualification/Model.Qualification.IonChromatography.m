(* ::Package:: *)

DefineObjectType[Model[Qualification,IonChromatography],{
    Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of an ion chromatography instrument.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{

        (* Method Information *)
        AnionColumn->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The stationary phase column employed for the separation in anion channel.",
            Category -> "General",
            Abstract->True
        },
        AnionGuardColumn->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The protective device placed upstream of the separation column in anion channel.",
            Category -> "General",
            Abstract->True
        },
        CationColumn->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The stationary phase column employed for the separation in cation channel.",
            Category -> "General",
            Abstract->True
        },
        CationGuardColumn->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The protective device placed upstream of the separation column in cation channel.",
            Category -> "General",
            Abstract->True
        },
        Column->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The stationary phase column employed for the separation in electrochemical channel.",
            Category -> "General",
            Abstract->True
        },
        GuardColumn->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Item],
            Description->"The protective device placed upstream of the separation column in electrochemical channel.",
            Category -> "General",
            Abstract->True
        },
        DefaultAnionSuppressorVoltage->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Volt],
            Units->Volt,
            Description->"The potential used to remove background from the eluent in the anion channel when not specified.",
            Category -> "General"
        },
        DefaultCationSuppressorVoltage->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Volt],
            Units->Volt,
            Description->"The potential used to remove background from the eluent in the cation channel when not specified.",
            Category -> "General"
        },
        Wavelength->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0*Nano*Meter],
            Units->Meter Nano,
            Description->"The default wavelength to measure the absorbance of in the detector's flow cell.",
            Category -> "General"
        },
        Waveform->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Waveform],
            Description->"The default waveform applied to the electrochemical detector's flow cell during data collection.",
            Category -> "General"
        },
        EluentGeneratorInletSolution->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used to feed into the eluent generator cartridge in the flow path for anion channel.",
            Category -> "General",
            Abstract->True
        },
        BufferA->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The Buffer A model used to generate the buffer gradient for the protocol.",
            Category -> "General",
            Abstract->True
        },
        BufferB->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The Buffer B model used to generate the buffer gradient for the protocol.",
            Category -> "General",
            Abstract->True
        },
        BufferC->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The Buffer C model used to generate the buffer gradient for the protocol.",
            Category -> "General",
            Abstract->True
        },
        BufferD->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The Buffer D model used to generate the buffer gradient for the protocol.",
            Category -> "General",
            Abstract->True
        },
        AnionColumnPrimeGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The buffer gradient used for anion column primes.",
            Category -> "General"
        },
        AnionColumnFlushGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The buffer gradient used for anion column flushes.",
            Category -> "General"
        },
        CationColumnPrimeGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The buffer gradient used for cation column primes.",
            Category -> "General"
        },
        CationColumnFlushGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The buffer gradient used for cation column flushes.",
            Category -> "General"
        },
        ColumnPrimeGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The buffer gradient used for electrochemical column primes.",
            Category -> "General"
        },
        ColumnFlushGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The buffer gradient used for electrochemical column flushes.",
            Category -> "General"
        },

        (* Flow Linearity - anion channel*)
        AnionFlowLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography instrument's pump for anion channel.",
            Category->"Flow Linearity Test"
        },
        AnionFlowLinearityGradients->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradients to run when testing the IonChromatography instrument's pump for anion channel.",
            Category->"Flow Linearity Test"
        },
        AnionFlowLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the IonChromatography instrument's pump for anion channel.",
            Category->"Flow Linearity Test"
        },
        AnionFlowLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the IonChromatography instrument's pump for anion channel.",
            Category->"Flow Linearity Test"
        },
        AnionMinFlowLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing flow rate linearity, the minimum acceptable correlation coefficient for the fit of 1/retention time vs. flow rate for anion channel.",
            Category->"Flow Linearity Test"
        },
        AnionMaxFlowRateError->{
            Format->Single,
            Class->Real,
            Units->Milliliter/Minute,
            Pattern:>GreaterP[0],
            Description->"When determining flow rate accuracy, the maximum acceptable absolute value of the x-intercept for the fit of 1/retention time vs. flow rate for anion channel.",
            Category->"Flow Linearity Test"
        },

        (* Flow Linearity - cation channel*)
        CationFlowLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography instrument's pump for cation channel.",
            Category->"Flow Linearity Test"
        },
        CationFlowLinearityGradients->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradients to run when testing the IonChromatography instrument's pump for cation channel.",
            Category->"Flow Linearity Test"
        },
        CationFlowLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the IonChromatography instrument's pump for cation channel.",
            Category->"Flow Linearity Test"
        },
        CationFlowLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the IonChromatography instrument's pump for cation channel.",
            Category->"Flow Linearity Test"
        },
        CationMinFlowLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing flow rate linearity, the minimum acceptable correlation coefficient for the fit of 1/retention time vs. flow rate for cation channel.",
            Category->"Flow Linearity Test"
        },
        CationMaxFlowRateError->{
            Format->Single,
            Class->Real,
            Units->Milliliter/Minute,
            Pattern:>GreaterP[0],
            Description->"When determining flow rate accuracy, the maximum acceptable absolute value of the x-intercept for the fit of 1/retention time vs. flow rate for cation channel.",
            Category->"Flow Linearity Test"
        },

        (* Flow Linearity - electrochemical channel*)
        FlowLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography instrument's pump for electrochemical channel.",
            Category->"Flow Linearity Test"
        },
        FlowLinearityGradients->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The gradients to run when testing the IonChromatography instrument's pump for electrochemical channel.",
            Category->"Flow Linearity Test"
        },
        FlowLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the IonChromatography instrument's pump for electrochemical channel.",
            Category->"Flow Linearity Test"
        },
        FlowLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the IonChromatography instrument's pump for electrochemical channel.",
            Category->"Flow Linearity Test"
        },
        MinFlowLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing flow rate linearity, the minimum acceptable correlation coefficient for the fit of 1/retention time vs. flow rate for electrochemical channel.",
            Category->"Flow Linearity Test"
        },
        MaxFlowRateError->{
            Format->Single,
            Class->Real,
            Units->Milliliter/Minute,
            Pattern:>GreaterP[0],
            Description->"When determining flow rate accuracy, the maximum acceptable absolute value of the x-intercept for the fit of 1/retention time vs. flow rate for electrochemical channel.",
            Category->"Flow Linearity Test"
        },

        (* Autosampler - injection into anion channel *)
        AnionAutosamplerTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography's autosampler with injection goes into anion channel.",
            Category->"Autosampler Test"
        },
        AnionAutosamplerGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradient to run when testing the IonChromatography's autosampler with injection goes into anion channel.",
            Category->"Autosampler Test"
        },
        AnionAutosamplerInjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volumes of sample to inject when testing the IonChromatography's autosampler with injection goes into anion channel.",
            Category->"Autosampler Test"
        },
        AnionAutosamplerReplicates->{
            Format->Multiple,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"For each member of AnionAutosamplerInjectionVolumes, the number of replicate injections to run.",
            Category->"Autosampler Test"
        },
        AnionMaxInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing anion autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections.",
            Category->"Autosampler Test"
        },
        AnionMaxFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing anion flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Autosampler Test"
        },
        AnionMinInjectionLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing anion injection volume linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },
        AnionMaxInjectionVolumeError->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Microliter,
            Description->"When testing the anion injection volume accuracy of the autosampler, the maximum acceptable absolute value of the x-intercept for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },

        (* Autosampler - injection into cation channel *)
        CationAutosamplerTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography's autosampler with injection goes into cation channel.",
            Category->"Autosampler Test"
        },
        CationAutosamplerGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradient to run when testing the IonChromatography's autosampler with injection goes into cation channel.",
            Category->"Autosampler Test"
        },
        CationAutosamplerInjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volumes of sample to inject when testing the IonChromatography's autosampler with injection goes into cation channel.",
            Category->"Autosampler Test"
        },
        CationAutosamplerReplicates->{
            Format->Multiple,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"For each member of CationAutosamplerInjectionVolumes, the number of replicate injections to run.",
            Category->"Autosampler Test"
        },
        CationMaxInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing cation autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections.",
            Category->"Autosampler Test"
        },
        CationMaxFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing cation flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Autosampler Test"
        },
        CationMinInjectionLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing cation injection volume linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },
        CationMaxInjectionVolumeError->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Microliter,
            Description->"When testing the cation injection volume accuracy of the autosampler, the maximum acceptable absolute value of the x-intercept for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },

        (* Autosampler - injection into electrochemical channel *)
        AutosamplerTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the IonChromatography's autosampler with injection goes into electrochemical channel.",
            Category->"Autosampler Test"
        },
        AutosamplerGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The gradient to run when testing the IonChromatography's autosampler with injection goes into electrochemical channel.",
            Category->"Autosampler Test"
        },
        AutosamplerInjectionVolumes->{
            Format->Multiple,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volumes of sample to inject when testing the IonChromatography's autosampler with injection goes into electrochemical channel.",
            Category->"Autosampler Test"
        },
        AutosamplerReplicates->{
            Format->Multiple,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"For each member of AutosamplerInjectionVolumes, the number of replicate injections to run.",
            Category->"Autosampler Test"
        },
        MaxInjectionPrecisionPeakAreaRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0Percent],
            Units->Percent,
            Description->"When testing anion autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections.",
            Category->"Autosampler Test"
        },
        MaxFlowPrecisionRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing anion flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
            Category->"Autosampler Test"
        },
        MinInjectionLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing anion injection volume linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },
        MaxInjectionVolumeError->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Microliter,
            Description->"When testing the anion injection volume accuracy of the autosampler, the maximum acceptable absolute value of the x-intercept for the fit of peak area vs. injection volume.",
            Category->"Autosampler Test"
        },


        (* Gradient Proportioning - this test only applies to cation/electrochemical channel *)
        GradientProportioningTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the gradient proportioning valves.",
            Category->"Gradient Proportioning Test"
        },
        GradientProportioningGradients->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient]|Object[Method,IonChromatographyGradient],
            Description->"The gradients to run when testing the IonChromatography instrument's gradient proportioning valves.",
            Category->"Gradient Proportioning Test"
        },
        GradientProportioningInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the IonChromatography instrument's gradient proportioning valves.",
            Category->"Gradient Proportioning Test"
        },
        GradientProportioningReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the IonChromatography instrument's gradient proportioning valves.",
            Category->"Gradient Proportioning Test"
        },
        MaxGradientProportioningPeakRetentionRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing the proportioning valves, the maximum percent relative standard deviation of peak retention times.",
            Category->"Gradient Proportioning Test"
        },

        (* Eluent generator cartridge concentration test - this test only applies to anion channel *)
        EluentConcentrationTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The sample model that will be injected when testing the eluent concentration generated by eluent generator cartridge in anion channel.",
            Category->"Eluent Generator Cartridge Test"
        },
        EluentConcentrationGradients->{
            Format->Multiple,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradients to run when testing the IonChromatography instrument's gradient proportioning valves.",
            Category->"Eluent Generator Cartridge Test"
        },
        EluentConcentrationInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the IonChromatography instrument's eluent concentration.",
            Category->"Eluent Generator Cartridge Test"
        },
        EluentConcentrationReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the IonChromatography instrument's eluent concentration.",
            Category->"Eluent Generator Cartridge Test"
        },
        MaxEluentConcentrationConductivityRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing the eluent concentration, the maximum percent relative standard deviation of the average conductivity measurement.",
            Category->"Eluent Generator Cartridge Test"
        },
        MinEluentConcentrationCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing eluent concentration, the minimum acceptable correlation coefficient for the fit of average conductance vs. eluent concentration.",
            Category->"Eluent Generator Cartridge Test"
        },

        (* Conductivity detection linearity test - anion channel *)
        AnionDetectorLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model of the most concentrated sample that will be injected when testing the linearity of the IonChromatography instrument's anion detector.",
            Category->"Detector Linearity Test"
        },
        AnionDetectorLinearityGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradient to run when testing the linearity of the IonChromatography instrument's anion detector.",
            Category->"Detector Linearity Test"
        },
        AnionDetectorLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the linearity of the IonChromatography instrument's anion detector.",
            Category->"Detector Linearity Test"
        },
        AnionDetectorLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the linearity of the IonChromatography instrument's anion detector.",
            Category->"Detector Linearity Test"
        },
        AnionDetectorLinearityDilutions->{
            Format->Multiple,
            Class->Real,
            Pattern:>RangeP[0,1,Inclusive->Right],
            Units->None,
            Description->"The factors to dilute the AnionDetectorLinearityTestSample by prior to injection.",
            Category->"Detector Linearity Test"
        },
        AnionDetectorLinearityDiluent->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The solution to use to dilute the anion detector linearity test samples.",
            Category->"Detector Linearity Test"
        },
        MaxAnionDetectorResponseFactorRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing anion detector response, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
            Category->"Detector Linearity Test"
        },
        MinAnionDetectorLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing anion detector linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
            Category->"Detector Linearity Test"
        },

        (* Conductivity detection linearity test - cation channel *)
        CationDetectorLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model of the most concentrated sample that will be injected when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        CationDetectorLinearityGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,IonChromatographyGradient],
            Description->"The gradient to run when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        CationDetectorLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        CationDetectorLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        CationDetectorLinearityDilutions->{
            Format->Multiple,
            Class->Real,
            Pattern:>RangeP[0,1,Inclusive->Right],
            Units->None,
            Description->"The factors to dilute the CationDetectorLinearityTestSample by prior to injection.",
            Category->"Detector Linearity Test"
        },
        CationDetectorLinearityDiluent->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The solution to use to dilute the cation detector linearity test samples.",
            Category->"Detector Linearity Test"
        },
        MaxCationDetectorResponseFactorRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing cation detector response, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
            Category->"Detector Linearity Test"
        },
        MinCationDetectorLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing cation detector linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
            Category->"Detector Linearity Test"
        },

        (* Electrochemical detection linearity test - electrochemical channel *)
        ElectrochemicalDetectorLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model of the most concentrated sample that will be injected when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        ElectrochemicalDetectorLinearityGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The gradient to run when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        ElectrochemicalDetectorLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        ElectrochemicalDetectorLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        ElectrochemicalDetectorLinearityDilutions->{
            Format->Multiple,
            Class->Real,
            Pattern:>RangeP[0,1,Inclusive->Right],
            Units->None,
            Description->"The factors to dilute the ElectrochemicalDetectorLinearityTestSample by prior to injection.",
            Category->"Detector Linearity Test"
        },
        ElectrochemicalDetectorLinearityDiluent->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The solution to use to dilute the cation detector linearity test samples.",
            Category->"Detector Linearity Test"
        },
        MaxElectrochemicalDetectorResponseFactorRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing cation detector response, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
            Category->"Detector Linearity Test"
        },
        MinElectrochemicalDetectorLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing cation detector linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
            Category->"Detector Linearity Test"
        },

        (* Absorbance detection linearity test - electrochemical channel *)
        DetectorLinearityTestSample->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model of the most concentrated sample that will be injected when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        DetectorLinearityGradient->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Object[Method,Gradient],
            Description->"The gradient to run when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        DetectorLinearityInjectionVolume->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Microliter],
            Units->Microliter,
            Description->"The volume of sample to inject when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        DetectorLinearityReplicates->{
            Format->Single,
            Class->Integer,
            Pattern:>GreaterP[0,1],
            Description->"The number of replicate injections that will be performed when testing the linearity of the IonChromatography instrument's cation detector.",
            Category->"Detector Linearity Test"
        },
        DetectorLinearityDilutions->{
            Format->Multiple,
            Class->Real,
            Pattern:>RangeP[0,1,Inclusive->Right],
            Units->None,
            Description->"The factors to dilute the CationDetectorLinearityTestSample by prior to injection.",
            Category->"Detector Linearity Test"
        },
        DetectorLinearityDiluent->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The solution to use to dilute the cation detector linearity test samples.",
            Category->"Detector Linearity Test"
        },
        MaxDetectorResponseFactorRSD->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0],
            Units->Percent,
            Description->"When testing cation detector response, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
            Category->"Detector Linearity Test"
        },
        MinDetectorLinearityCorrelation->{
            Format->Single,
            Class->Real,
            Pattern:>RangeP[0,1],
            Description->"When testing cation detector linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
            Category->"Detector Linearity Test"
        }
    }
}];
