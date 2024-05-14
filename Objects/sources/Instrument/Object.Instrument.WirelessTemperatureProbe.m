(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, WirelessTemperatureProbe], {
    Description->"An instrument object used for measuring temperature in a device.",
    CreatePrivileges->None,
    Cache->Download,
    Fields ->{
        CurrentInstrument->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Alternatives[Object[Container,LightBox],
                Object[Instrument,PortableHeater],
                Object[Instrument,PortableCooler],
                Model[Container,LightBox],
                Model[Instrument,PortableHeater],
                Model[Instrument,PortableCooler]],
            Description->"Indicates the type of device in which the probe is measuring the temperature.",
            Category->"General"
        },
        ChargingLog->{
            Format->Multiple,
            Class->Expression,
            Pattern:>{{_?DateObjectQ,(ObjectP[Object[Maintenance],Object[Qualification]])}..},
            Description->"The logs of the temperature traces from the carrying environment inside the Devices while the Devices are reaching InstrumentTemperatures.",
            Category->"General"
        }
    }
}];