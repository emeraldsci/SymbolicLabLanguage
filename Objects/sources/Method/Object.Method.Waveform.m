

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method,Waveform],{
    Description->"A series of time-dependent voltage setting that will be repeated over the duration of the analysis for any pulsed electrochemical detection.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{

        ElectrochemicalDetectionMode->{
            Format->Single,
            Class->Expression,
            Pattern:>ElectrochemicalDetectionModeP,
            Description->"The mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
            Category -> "General"
        },
        ReferenceElectrodeMode->{
            Format->Single,
            Class->Expression,
            Pattern:>ReferenceElectrodeModeP,
            Description->"A combination pH-Ag/AgCl reference electrode that can be used to either monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
            Category -> "General"
        },
        WaveformDuration->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0*Second],
            Units->Second,
            Description->"The total time it takes to run one repetition of the waveform.",
            Category -> "General"
        },
        Waveform->{
            Format->Multiple,
            Class->{
                Time->Real,
                Voltage->Real,
                Interpolation->Expression,
                Integration->Expression
            },
            Pattern:>{
                Time->GreaterEqualP[0*Second],
                Voltage->VoltageP,
                Interpolation->BooleanP,
                Integration->BooleanP
            },
            Units->{
                Time->Second,
                Voltage->Volt,
                Interpolation->None,
                Integration->None
            },
            Relation->{
                Time->Null,
                Voltage->Null,
                Interpolation->Null,
                Integration->Null
            },
            Description->"The defined voltage vs. time pattern that will be repeated during an Ion Chromatography run using electrochemical detectors.",
            Category -> "General"
        }
    }
}];
