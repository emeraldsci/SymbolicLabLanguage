(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method,IonChromatographyGradient],{
    Description->"A method containing parameters specifying a solvent gradient utilized by an IonChromatography run.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{

        AnionColumnTemperature->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Kelvin],
            Units->Celsius,
            Description->"The temperature at which the gradient is run for anion channel.",
            Category -> "General",
            Abstract->True
        },
        AnionFlowRate->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],GreaterEqualP[(0*(Liter*Milli))/Minute]}...}|GreaterEqualP[(0*(Liter*Milli))/Minute]),
            Description->"The flow rate at which the gradient is run for anion channel.",
            Category -> "General"
        },
        AnionInitialFlowRate->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[(0*(Liter*Milli))/Minute],
            Units->(Liter Milli)/Minute,
            Description->"The starting flow rate used by this gradient for anion channel.",
            Category -> "General"
        },
        EluentGeneratorInletSolution->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used to feed liquid into the eluent generator in the flow path of the ion chromatography instrument.",
            Category->"Reagents",
            Abstract->True
        },
        Eluent->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used as eluent in this gradient that is generated automatically in the flow path.",
            Category->"Reagents",
            Abstract->True
        },
        EluentGradient->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Millimolar,100 Millimolar]}...}|RangeP[0 Millimolar,100 Millimolar]),
            Description->"The concentration of eluent over time, in the form: {Time, Eluent Concentration}.",
            Category -> "General"
        },
        AnionGradient->{
            Format->Multiple,
            Class->{Real,Real,Real},
            Pattern:>{GreaterEqualP[0*Minute],GreaterEqualP[0*Millimolar],GreaterEqualP[(0*Milliliter)/Minute]},
            Units->{Minute,Millimolar,Milliliter/Minute},
            Description->"Definition of eluent concentration in the anion channel as a function of time where composition at the points in between is assumed to be a line joining the points.",
            Headers->{"Time","Eluent Concentration","Flow Rate"},
            Category -> "General"
        },
        AnionGradientStart->{
            Format->Single,
            Class->Real,
            Pattern:>ConcentrationP,
            Units->Percent,
            Description->"For linear gradients in the anion channel, the initial concentration of eluent.",
            Category -> "General"
        },
        AnionGradientEnd->{
            Format->Single,
            Class->Real,
            Pattern:>ConcentrationP,
            Units->Percent,
            Description->"For linear gradients in the anion channel, the final concentration of eluent.",
            Category -> "General"
        },
        AnionGradientDuration->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"For linear gradients in the anion channel, the duration to reach AnionGradientEnd from AnionGradientStart.",
            Category -> "General"
        },
        AnionEquilibrationTime->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"The amount of time to equilibrate at AnionGradientStart before starting the gradient for anion channel.",
            Category -> "General"
        },
        AnionFlushTime->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"The amount of time to flush at the highest specified eluent concentration at the end of the gradient for anion channel.",
            Category -> "General"
        },
        CationColumnTemperature->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Kelvin],
            Units->Celsius,
            Description->"The temperature at which the gradient is run for cation channel.",
            Category -> "General",
            Abstract->True
        },
        CationFlowRate->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],GreaterEqualP[(0*(Liter*Milli))/Minute]}...}|GreaterEqualP[(0*(Liter*Milli))/Minute]),
            Description->"The flow rate at which the gradient is run for cation channel.",
            Category -> "General"
        },
        CationInitialFlowRate->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[(0*(Liter*Milli))/Minute],
            Units->(Liter Milli)/Minute,
            Description->"The starting flow rate used by this gradient for cation channel.",
            Category -> "General"
        },
        BufferA->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used as Buffer A in this gradient.",
            Category->"Reagents",
            Abstract->True
        },
        BufferB->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used as Buffer B in this gradient.",
            Category->"Reagents",
            Abstract->True
        },
        BufferC->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used as Buffer C in this gradient.",
            Category->"Reagents",
            Abstract->True
        },
        BufferD->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Sample],
            Description->"The model used as Buffer D in this gradient.",
            Category->"Reagents",
            Abstract->True
        },
        GradientA->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
            Description->"The percentage of Buffer A in the composition over time, in the form: {Time, % Buffer A}.",
            Category -> "General"
        },
        GradientB->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
            Description->"The percentage of Buffer B in the composition over time, in the form: {Time, % Buffer B}.",
            Category -> "General"
        },
        GradientC->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
            Description->"The percentage of Buffer C in the composition over time, in the form: {Time, % Buffer C}.",
            Category -> "General"
        },
        GradientD->{
            Format->Single,
            Class->Expression,
            Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
            Description->"The percentage of Buffer D in the composition over time, in the form: {Time, % Buffer D}.",
            Category -> "General"
        },
        CationGradient->{
            Format->Multiple,
            Class->{Real,Real,Real,Real,Real,Real},
            Pattern:>{GreaterEqualP[0*Minute],RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent],RangeP[0*Percent,100*Percent],GreaterEqualP[(0*(Liter*Milli))/Minute]},
            Units->{Minute,Percent,Percent,Percent,Percent,(Liter Milli)/Minute},
            Description->"Definition of buffer composition in cation channel as a function of time where composition at the points in between is assumed to be a line joining the points.",
            Headers->{"Time","Buffer A Composition","Buffer B Composition","Buffer C Composition","Buffer D Composition","Flow Rate"},
            Category -> "General"
        },
        CationGradientStart->{
            Format->Single,
            Class->Real,
            Pattern:>PercentP,
            Units->Percent,
            Description->"For linear gradients in cation channel, the initial Buffer B percentage.",
            Category -> "General"
        },
        CationGradientEnd->{
            Format->Single,
            Class->Real,
            Pattern:>PercentP,
            Units->Percent,
            Description->"For linear gradients in cation channel, the final Buffer B percentage.",
            Category -> "General"
        },
        CationGradientDuration->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"For linear gradients in cation channel, the duration to reach CationGradientEnd from CationGradientStart.",
            Category -> "General"
        },
        CationEquilibrationTime->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"The amount of time to equilibrate at CationGradientStart before starting the gradient for cation channel.",
            Category -> "General"
        },
        CationFlushTime->{
            Format->Single,
            Class->Real,
            Pattern:>TimeP,
            Units->Minute,
            Description->"The amount of time to flush at 100% Buffer B at the end of the gradient for cation channel.",
            Category -> "General"
        }
    }
}];
